---
name: code-review
description: Principles for writing accurate, high-signal code reviews — especially in unfamiliar domains. Includes staged review process, calibrated feedback with severity labels, and patterns for difficult conversations. Use when reviewing code, auditing changes, giving feedback on a diff, or doing ad-hoc review of uncommitted changes / PRs.
---

# Code Review

## Author/Reviewer Separation

If you wrote the code, do not review it yourself. Agree on the review mode first: fresh subagent, separate session, or inline (low-risk only, labeled self-review). If using a subagent, follow [subagent review](references/subagent-review.md): it may read surrounding code, findings are not capped, and the user decides on timeout. Same context means the same blind spots.

## Core Principle: Confident Only Where Evidence Exists

A review's value is proportional to epistemic honesty. Overstating confidence in unfamiliar territory generates noise, erodes trust, and forces the author to spend time disproving non-issues while real issues get diluted.

---

## Rule 1: Diff Discovery, Ask Don't Assert

The highest-value findings come from **comparing old vs. new code** and detecting actual behavioral changes. When a change involves domain-specific semantics you cannot verify, flag it as a question, not a verdict.

**The heuristic:** If you cannot point to documentation proving your claim, you are guessing. Guesses framed as findings are worse than silence.

**How to reframe assertions as questions:**

| Instead of... | Say... |
|---------------|--------|
| "This is a bug — the value is overwritten" | "Does step X preserve the state set by the prior call? If not, data may be lost here." |
| "The layout is incompatible — the consumer will break" | "The field offset changed from A to B. Is the consumer already updated to match?" |
| "This count is wrong — it should be 6 not 2" | "Path A uses 6 but path B uses 2 for a seemingly analogous operation. Are the semantics different?" |

**Guideline:** Behavioral changes (different values, offsets, signatures, timing) are your strongest signal — flag them explicitly as "old vs. new" observations and ask whether the change is intentional.

---

## Rule 2: Calibrate Severity to Confidence

Severity must be modulated by confidence. Low-confidence guesses labeled "critical" poison the entire review.

| Confidence | Source | How to label |
|-----------|--------|-------------|
| **High** | Diff shows clear behavioral change, obvious logic error, or standard bug pattern | State as finding with severity |
| **Medium** | Something looks wrong but depends on domain-specific semantics | Flag as "needs confirmation" at the suspected severity |
| **Low** | Inferring behavior from unfamiliar APIs or conventions | Frame as a question, not a finding |

**Anti-pattern:** Mixing high-confidence and low-confidence findings at the same severity level. This makes the entire review look equally unreliable.

---

## Rule 3: Cross-Check What You Can Verify Independently

Even without domain expertise, some observations are always valid:

- **Inconsistencies within the same file.** Analogous code paths that use different constants or conventions are legitimate observations — frame as questions about intent.
- **Test coverage gaps.** Changed code paths without corresponding tests are always worth noting, regardless of domain knowledge.
- **Coupled changes across boundaries.** A change in one module may require a corresponding update in a consumer. Flag the coupling even if you haven't seen the other side.
- **Doc-code drift.** When a refactor changes type signatures, return types, or field names, always check whether docs and architecture files still match. Mismatched docs are a reliable, high-confidence finding.
- **Fallback path semantics.** When a multi-layer filter or validation has a fallback that bypasses stricter layers, the fallback effectively negates those layers. Flag whether the fallback is intentional or reveals a logic gap.
- **Redundant work in loops.** When a filter reads or computes full payloads just to decide inclusion, and matched items are processed again downstream, the repeated work is a concrete performance concern — flag with evidence of the call chain.
- **Responsibility boundary erosion.** Moving methods from an operator type onto a data-only struct blurs responsibility. Flag as a design question, not a bug.

---

## Review Process

Four-stage review. Details in [review-process](references/review-process.md).

1. **Context** — Read PR description, understand intent, check CI. If the PR is too large to review effectively, say so.
2. **High-level** — Architecture & design, file organization, test strategy.
3. **Line-by-line** — Logic & correctness, security, performance, maintainability. For tests: do they assert behavior rather than mocks or tautologies? Do they cover the task's edge cases? If the diff changes a public interface or seam, use **codebase-design** vocabulary to judge depth and seam placement. For web UI changes, run the [Web UI review](references/web-ui-review.md) and, if installed, `web-design-guidelines`.
4. **Summary & verdict** — Synthesize findings, highlight strengths, give explicit decision: Approve / Comment / Request Changes.

### Reviewing against the spec

The spec is a vision document, not a contract. Spec silence does not mean permission: judge uncovered behavior by what a reasonable user would expect, and set severity by its impact. List every behavior you deliberately chose not to judge under **Declined to judge**, with the reason, so the implementer decides rather than having it silently dropped.

### Read-only review

Do not modify the working tree, index, or HEAD. If you need another version, create a temporary `git worktree` outside the repo. Reviewers do not spawn their own subagents.

### Leave to tools

Formatting, import order, lint, and simple spelling are for the toolchain, not for human review.

---

## Feedback Rules

Details in [feedback-patterns](references/feedback-patterns.md).

- **Specific and actionable.** Not "this is wrong" but "this causes X, consider Y instead."
- **Praise good work.** Acknowledge clever solutions, clean abstractions, thorough tests. Use 🎉.
- **Severity labels.** 🔴 blocking · 🟡 important · 🟢 nit · 💡 suggestion · 📚 learning · 🎉 praise
- **Comment on code, not the author.** "This function does X when it should do Y" — not "you missed Y."

### Difficult Feedback

- **Modified sandwich:** Context + Specific Issue + Helpful Solution (not praise-criticism-praise).
- **Disagreements:** Seek to understand → Acknowledge → Provide data → Escalate → Know when to let go.

### Receiving review feedback

READ → UNDERSTAND → VERIFY → EVALUATE → RESPOND → IMPLEMENT.

- No performative agreement ("You're right", "Good point"). Respond with the action taken or the evidence.
- If any item is unclear, clarify **all** of it before changing code.
- For external reviewers, verify the claim against the codebase; push back with a technical reason when warranted.
- Run the YAGNI check before implementing "professional" suggestions.
- Implement in order: blocking → simple → complex; test each fix.
- On GitHub, reply inside the review thread, not as a top-level comment.

---

## Common Pitfalls

- **Perfectionism** — Reviewing for correctness, not for your preferred style.
- **Scope creep** — Addressing things outside the PR's scope.
- **Rubber stamping** — Approving without reading because the author is trusted.
- **Bike shedding** — Spending disproportionate time on trivial choices.
- **Delayed reviews** — Blocking progress by not reviewing promptly.

---

## Summary Checklist

Before finalizing a code review:

- [ ] Are all "critical" findings backed by evidence, not inference?
- [ ] Are domain-specific claims framed as questions where confidence is low?
- [ ] Are diff-level behavioral changes explicitly identified (old vs. new)?
- [ ] Are severity levels calibrated — no low-confidence guesses at "critical"?
- [ ] Have living docs (README, CLAUDE.md/AGENTS.md, architecture, user guide) been checked for drift?
- [ ] Do fallback paths in multi-layer logic preserve their intended semantics?
- [ ] Is redundant work across call chains flagged where present?
- [ ] Did you follow the four-stage review process?
- [ ] Are findings labeled with severity tags (🔴🟡🟢💡📚🎉)?
- [ ] Does the review include positive observations, not just problems?
- [ ] Is the verdict explicit (Approve / Comment / Request Changes)?
- [ ] Is every deliberately unjudged behavior listed under "Declined to judge"?
- [ ] Did the review stay read-only (no workspace/index/HEAD changes)?
- [ ] Did the reviewer avoid sharing the implementer's context?

## Next Steps

- **finish-work** — when the review passes, commit, create a PR, and update the issue.
- **diagnose** — when a finding needs deeper investigation rather than a direct fix.

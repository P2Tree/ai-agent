---
name: code-review-discipline
description: >
  Principles for writing accurate, high-signal code reviews — especially in
  unfamiliar domains. Trigger when reviewing code, auditing changes, giving
  feedback on a diff, or doing ad-hoc review of uncommitted changes / PRs.
---

# Code Review Discipline

## Core Principle: Confident Only Where Evidence Exists

A review's value is proportional to epistemic honesty. Overstating
confidence in unfamiliar territory generates noise, erodes trust, and
forces the author to spend time disproving non-issues while real issues
get diluted.

---

## Rule 1: Diff Discovery, Ask Don't Assert

The highest-value findings come from **comparing old vs. new code** and
detecting actual behavioral changes. When a change involves domain-specific
semantics you cannot verify, flag it as a question, not a verdict.

**The heuristic:** If you cannot point to documentation proving your claim,
you are guessing. Guesses framed as findings are worse than silence.

**How to reframe assertions as questions:**

| Instead of... | Say... |
|---------------|--------|
| "This is a data loss bug — the register is overwritten" | "Does instruction X preserve the bits set by the prior call? If not, data may be lost here." |
| "The buffer layout is incompatible — host code will break" | "The field offset changed from A to B. Is the consumer already updated to match?" |
| "This delay count is wrong — it should be 6 not 2" | "Function A uses 6 delay slots but function B uses 2 for a seemingly analogous operation. Are the latencies different?" |

**Guideline:** Behavioral changes (different prefixes, offsets, register
usage, timing) are your strongest signal — flag them explicitly as
"old vs. new" observations and ask whether the change is intentional.

---

## Rule 2: Calibrate Severity to Confidence

Severity must be modulated by confidence. Low-confidence guesses labeled
"critical" poison the entire review.

| Confidence | Source | How to label |
|-----------|--------|-------------|
| **High** | Diff shows clear behavioral change, obvious logic error, or standard bug pattern | State as finding with severity |
| **Medium** | Something looks wrong but depends on domain-specific semantics | Flag as "needs confirmation" at the suspected severity |
| **Low** | Inferring behavior from unfamiliar instructions/APIs | Frame as a question, not a finding |

**Anti-pattern:** Mixing high-confidence and low-confidence findings at the
same severity level. This makes the entire review look equally unreliable.

---

## Rule 3: Cross-Check What You Can Verify Independently

Even without domain expertise, some observations are always valid:

- **Inconsistencies within the same file.** Analogous code paths that use
  different constants, delays, or register conventions are legitimate
  observations — frame as questions about intent.

- **Test coverage gaps.** Changed code paths without corresponding tests
  are always worth noting, regardless of domain knowledge.

- **Coupled changes across boundaries.** A device-side offset change may
  require a host-side reader update. Flag the coupling even if you haven't
  seen the host code.

---

## Summary Checklist

Before finalizing a code review:

- [ ] Are all "critical" findings backed by evidence, not inference?
- [ ] Are domain-specific claims framed as questions where confidence is low?
- [ ] Are diff-level behavioral changes explicitly identified (old vs. new)?
- [ ] Are severity levels calibrated — no low-confidence guesses at "critical"?

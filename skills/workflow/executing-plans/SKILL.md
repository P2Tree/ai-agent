---
name: executing-plans
description: Execute a written implementation plan step-by-step with review checkpoints. Use when you have a plan to execute in the current session, need subagent-driven execution with two-stage review, or face multiple independent tasks.
---

# Executing Plans

Three modes: **inline** (one context), **subagent-driven** (fresh implementer + reviewer per task), and **parallel** (independent domains concurrently).

**Continuous execution:** execute every task without pausing to ask "should I continue?". **Rulings, not stalls:** decide conflicts and ambiguities yourself, record them as `Ruling: <decision> — <why> — <cost if wrong>`, and keep going. Only four things stop you: an irreversible/destructive operation, a security-sensitive action, a side effect outside the worktree that norms require asking about, and a plan so broken that every path is a guess.

## Choose Execution Mode

Present the modes with a recommendation; the user decides:

1. **Inline** — one context, one final review. Cheapest; best for small plans or a mid-tier session model.
2. **Subagent-Driven** — fresh implementer and reviewer per task. Most thorough; best for independent tasks needing review gates.
3. **Parallel** — one agent per independent domain. Best for 3+ unrelated failures with no shared state.

## Shared Setup

1. **Isolate the work.** Use a worktree/branch. Never implement on main/master without explicit consent.
2. **Create a ledger**, not just todos. Conversation memory does not survive compaction; the ledger and `git log` do. Each plan owns `<repo>/.superpowers/sdd/<plan>/progress.md`; first line: `# SDD ledger — plan: <path>`.
3. **Read the plan and its spec.** The spec is the binding authority; the plan is its argument. Note Global Constraints. If no spec is reachable, note that in the ledger — rulings are provisional.
4. **Pre-flight interface scan.** For every task consuming an earlier task's output, add a ledger row: producer, consumer, what was found. Record a ruling for each conflict. If tasks share nothing, write `Pre-flight: no shared interfaces`.
5. **Load TDD rules** before Task 1. Every test step is written first, watched to fail, then made to pass.
6. **Check for an existing ledger** and resume at the first task without a `Task <N>: complete` line. Trust the ledger and `git log` over recollection.

Details: [execution details](references/execution-details.md).

## Mode 1: Inline Execution

For each task:

1. Read the task brief and record `BASE` (`git rev-parse HEAD`).
2. Work the steps in order. For every command with an `Expected:` line, run it and compare real output.
3. If code is wrong, use **diagnose**; never patch the symptom. If the plan is wrong, rule on the smallest change satisfying the spec and ledger it.
4. Commit as the plan says. `BASE` is the review range, never `HEAD~1`.
5. **Completion contract** (all must be true before marking complete):
   - every named test exists and ran, and you read the output;
   - the task's final test run passed;
   - every `Expected:` was compared against real output;
   - every deviation has a `Ruling:` line.
6. Append `Task <N>: complete (commits <base7>..<head7>, tests: <cmd> → <result>)` and mark the todo complete. A failing run records nothing.

## Mode 2: Subagent-Driven Development

For each task:

1. Record `BASE`. Write the task brief to a file; the dispatch gives the brief path, not the whole plan. Include only: where the task fits, the brief path, interfaces from earlier tasks, your ambiguity rulings, and the report-file path. Never paste accumulated prior-task history.
2. The implementer works, tests, commits, and writes a full report file, returning only status, commits, a one-line test summary, and concerns. The implementer must not spawn its own reviewer.
3. On `DONE`, create a review package file for the `BASE..HEAD` range and dispatch the task reviewer with the brief, report, and package paths plus the plan's Global Constraints verbatim.
4. On `DONE_WITH_CONCERNS`, `NEEDS_CONTEXT`, or `BLOCKED`, handle per [execution details](references/execution-details.md).
5. **Fix loop** on spec failure or any Critical/Important finding. Each round ends with a scoped re-review. Rounds are capped; past the cap, adjudicate and park with a ruling instead of looping forever.
6. Append `Task <N>: complete (commits <base7>..<head7>, review clean)` or `... <K> parked`, then move on.

Never dispatch multiple implementation subagents in parallel. Reviewers never spawn subagents.

### Model Selection

- **Mechanical** (1–2 files, complete spec): cheapest tier.
- **Integration / debugging**: standard tier.
- **Architecture, final review, fix rounds 4–5**: most capable available tier.
- Specify the model explicitly on every dispatch; an omitted model inherits the session's.
- Turn count beats token price: cheap models often take 2–3× the turns.

Templates: [implementer](references/implementer-prompt.md), [task reviewer](references/task-reviewer-prompt.md), [re-review](references/re-review-prompt.md).

## Mode 3: Parallel Agent Dispatch

Use for multiple independent failures in different subsystems with no shared state. Do not use when failures are related, need full-system context, or agents would interfere.

1. **Identify independent domains** by what is broken.
2. **Create focused tasks**: one domain, self-contained context, specific output.
3. **Dispatch in the same response.** Multiple dispatches in one assistant turn run concurrently; dispatching one per turn runs them serially. 3+ independent failing files is the usual trigger.
4. **Review and integrate**: read summaries, check conflicts, run the full suite, and spot-check at least one agent's claims.

## Final Review

After all tasks, review the whole branch from a file-based package (commit list, stat, full diff) rather than reloading the diff into context.

1. Use the most capable model for the review; specify it explicitly. Without subagent support, perform the review yourself as a separate pass and say so.
2. **Re-grade every finding by effect**, not by the reviewer's label or the spec's silence. Grade what a reasonable user gets if it ships.
3. **Critical/Important → one fix pass.** Each fix starts with a failing test, then passes, then the whole suite is green.
4. **Minor → ledger only** under `Deferred minors`. Do not fix minors in the same pass.
5. Reviewer "Declined to judge" items become your rulings, recorded in the ledger.
6. Delete this plan's workspace when clean, then use **finishing-branch**.

## Red Flags

- Skipping reviews, verifications, or the final review.
- Making a subagent read the whole plan instead of a task brief.
- Starting quality review before spec compliance passes.
- Moving to the next task with open Critical/Important issues.
- Unledgered deviation from the plan.
- Fixing minors unasked, or accepting "close enough" on spec compliance.
- Starting implementation on main/master without explicit consent.

## Next Steps

- **finishing-branch** — verify tests, present merge/PR/cleanup options.

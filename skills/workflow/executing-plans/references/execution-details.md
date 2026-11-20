# Execution Details

Supporting detail for `executing-plans`. Read the relevant section when the SKILL points here.

## Ledger

Each plan owns a runtime workspace **outside the repository**:

`<cache>/ai-agent/sdd/<repo-basename>/<plan-basename>/`

`<cache>` is `$XDG_CACHE_HOME` or `~/.cache` on Unix, `%LOCALAPPDATA%` on Windows. The ledger is scratch, not project content: never put it in the repo and never commit it.

- First line: `# SDD ledger — plan: <plan file path>`
- A ledger whose first line names a different plan belongs to that plan: leave it and start your own.
- One line per task, written in the same message as the commit:
  - `Task <N>: complete (commits <base7>..<head7>, tests: <command> → <result>)`
  - `Task <N>: Ruling: <finding> — <decision and why>`
- After compaction, trust the ledger and `git log` over recollection.
- If the cache is cleared, recover from `git log`; deleting the workspace after final review is fine.
- Older runs stored this at `<repo>/.superpowers/sdd/`. That is runtime scratch too: delete it, or add `.superpowers/` to `.gitignore` if it may reappear.

## Waiting on subagents

- If the harness runs subagents asynchronously, do local work while waiting: ledger updates, the next review package, living-docs checks.
- If the call blocks synchronously, say so instead of pretending to work.
- Track elapsed time. At the soft threshold (about 5–10 minutes), tell the user how long it has run and ask whether to keep waiting or cancel and fall back. The user may choose to wait indefinitely.
- Never cancel a subagent on your own. If the user cancels, do the work inline and label it **self-review**, not independent review.

## Handling implementer reports

- **DONE** — create the review package for `BASE..HEAD` and dispatch the task reviewer.
- **DONE_WITH_CONCERNS** — read the concerns. Correctness concerns must be resolved before review; observations go in the ledger.
- **NEEDS_CONTEXT** — provide the missing context and re-dispatch.
- **BLOCKED** — assess the blocker: add context, upgrade the model, or split the task. Do not retry unchanged.

If the implementer asks questions, answer completely before it starts or continues.

## Fix loop

Triggers on spec ❌, any Critical/Important finding, or a confirmed ⚠️ gap.

- Each round: resume the same implementer agent for rounds 1–3; from round 4, use a model at least one tier higher.
- Scope every round to the findings. New issues outside the fix diff are ledgered for the final review, not added to the loop.
- Each round ends with a scoped re-review of the fix diff only.
- The loop is capped at 4–5 rounds. Past the cap, stop, adjudicate each open finding with a ruling, record it, and move on.
- Never silently discard a finding. "Obviously wrong" findings still get a ruling.

## Final review grading

- The reviewer's severity labels are advice; re-grade by what a reasonable user gets if the change ships.
- Spec silence does not downgrade a finding.
- Critical/Important → one fix pass, each fix RED→GREEN, whole suite green.
- Minor → `Final: minor (deferred): <one-liner>` in the ledger and under "Deferred minors" in the final message. Never fix minors unasked.
- A finding you decline to fix is a ruling, not a silent drop.

## Common rationalizations

| Excuse | Reality |
|--------|---------|
| "I remember what Task N says" | You remember a summary. Read the brief. |
| "Skip watching the test fail" | A test you never saw fail proves nothing. |
| "I'll run the full suite at the end" | Per-step runs show which step broke it; the final run is the contract. |
| "The plan is wrong, I'll just do the right thing" | Do it and ledger the ruling. Unledgered deviation is a decision made in secret. |
| "I'll write the ledger lines later" | Compaction does not wait. One line per task. |
| "Let me check in before the next task" | They chose execution, not progress prompts. Only the four stops stop you. |
| "I reviewed my own diff" | Same author, same blind spots. The final reviewer is the fresh context. |
| "The reviewer said Minor" | The label may have graded the spec's silence. Grade the effect. |
| "The fix is obvious, no failing test needed" | The failing test is the only proof the finding was real and is gone. |
| "I'll fix the minors too" | Every minor is unasked work. Ledger them; the user decides. |

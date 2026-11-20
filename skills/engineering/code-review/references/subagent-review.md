# Subagent Review

Use when the user chooses a fresh subagent to review code.

## Dispatch

- Ask before dispatching unless the user already chose a subagent review mode.
- Give the reviewer: the diff file, the task brief or spec, the project constraints, and suggested focus areas.
- Let it read surrounding code to verify concrete risks. Do not artificially limit how much of the repo it explores.
- Specify the model; prefer the fastest model that can do the review well.
- Do not cap findings. Require `file:line` evidence for each finding, the files it checked, and a "not checked / cannot verify" section.

## Waiting

- If the harness is asynchronous, do local work while it runs: run tests, check living docs, prepare the `finish-work` summary.
- If the call blocks synchronously, tell the user that you are waiting instead of idling silently.
- Track elapsed time. At the soft threshold (about 5–10 minutes), tell the user how long it has run and ask: keep waiting, or cancel and fall back? The user may choose to wait indefinitely.
- Never cancel on your own.

## Output Contract

The reviewer returns:

- findings with severity, `file:line`, why it matters, and a suggested fix;
- what it checked outside the diff, and why;
- what it could not verify from the available material;
- "Declined to judge" items with reasons;
- an explicit verdict: Approve / Comment / Request Changes.

## Fallback

If the user cancels or no subagent is available, perform the review inline and label it **self-review**, not independent review. For high-stakes changes, recommend a separate user-controlled session with a different model instead.

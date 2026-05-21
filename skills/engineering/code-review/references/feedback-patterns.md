# Feedback Patterns

How to write review comments that are useful, respectful, and actionable.

## Severity Labels

Use labels to help the author prioritize. Every finding gets a label.

| Label | Meaning | Example |
|-------|---------|---------|
| 🔴 blocking | Must fix before merge — bug, security issue, data loss | "This SQL query is vulnerable to injection." |
| 🟡 important | Should fix — correctness risk, performance problem, missing test | "This error path silently drops the message." |
| 🟢 nit | Minor style or readability issue — optional | "This variable name could be more specific." |
| 💡 suggestion | Idea for improvement, not a problem | "Consider using a builder pattern here for readability." |
| 📚 learning | Context or knowledge share, no action needed | "This library handles that edge case internally — no need to guard against it." |
| 🎉 praise | Something done well | "Clean abstraction — this makes the downstream code much easier to follow." |

**Key rule:** Only 🔴 justifies blocking the PR. Don't use 🔴 for things you merely dislike.

## Bad vs. Good Feedback

| Bad | Good |
|-----|------|
| "This is wrong." | 🔴 This function returns early without releasing the lock — will deadlock under concurrent access. |
| "Bad variable name." | 🟢 `data` is ambiguous here — consider `parsedConfig` to clarify what it holds. |
| "You should use a map instead." | 💡 A map lookup would make this O(1) instead of O(n) — consider it if this path is hot. |
| "Not sure about this." | 🟡 Needs confirmation: this changes the timeout from 5s to 30s. Is that intentional? The caller might assume a fast failure. |
| (Nothing) | 🎉 Nice use of the visitor pattern here — keeps the serialization logic cleanly separated. |

## Difficult Feedback

### Modified Sandwich Method

Traditional praise-criticism-praise feels manipulative. Instead:

**Context + Specific Issue + Helpful Solution**

1. **Context:** What is the situation? What were you looking at?
2. **Specific Issue:** What exactly is the problem? What is the impact?
3. **Helpful Solution:** What would you suggest? Or ask for their reasoning.

Example:
> Looking at the retry logic in `sendRequest()` — if all retries fail, the error gets swallowed and the caller sees a success response. This could cause data loss in production. Could we propagate the error or at least log it at ERROR level?

### Handling Disagreements

1. **Seek to understand.** Ask for their reasoning before arguing. "Can you walk me through why you chose this approach?"
2. **Acknowledge their point.** Even if you disagree, validate that their reasoning makes sense in some context.
3. **Provide data.** Cite documentation, benchmarks, or past incidents — not personal preference.
4. **Escalate if needed.** If the disagreement is about architecture or standards, involve the team rather than blocking unilaterally.
5. **Know when to let go.** If it's a matter of taste and the code works, drop it. Not every hill is worth dying on.

## Common Pitfalls

| Pitfall | What it looks like | What to do instead |
|---------|-------------------|-------------------|
| **Perfectionism** | Requesting changes on every minor style preference | Review for correctness and clarity, not for your preferred style |
| **Scope creep** | Commenting on code outside the PR's scope | Note it separately, don't block this PR |
| **Rubber stamping** | Approving without reading because the author is trusted | Trust the person, verify the code — always read the diff |
| **Bike shedding** | Spending 20 comments on a variable name while missing a race condition | Prioritize: correctness > security > performance > readability > style |
| **Delayed reviews** | Taking days to review a small PR | Review promptly — blocked PRs block the whole team |

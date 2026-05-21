# Review Process

Four-stage review process. Each stage has a specific focus — don't skip ahead.

## Phase 1: Context Gathering

Before reading any code:

- Read the PR description. What problem does it solve? What approach does it take?
- Check the PR size. If it touches more than ~400 lines of meaningful logic, consider requesting a split. Large PRs get shallow reviews — that's a fact, not a preference.
- Check CI status. Are tests passing? Do you need to understand failures before reviewing?
- Understand the business need. If the "why" is unclear, ask before reviewing the "how."
- Identify the risk surface. Which modules are affected? Who are the consumers?

**Decision point:** If the PR is too large or lacks context, stop and request clarification or a split. Don't review something you can't understand.

## Phase 2: High-Level Review

Read for design and architecture before details:

- **Architecture & design.** Does the change fit the existing architecture? Does it introduce new coupling? Does it follow established patterns or break them?
- **File organization.** Are new files in sensible locations? Are responsibilities well-separated?
- **Test strategy.** Are the right things tested? Do tests cover the stated behavior change, or just the implementation? Are edge cases addressed?
- **API design.** If the change introduces or modifies a public API, is the interface clean, consistent, and hard to misuse?

**Decision point:** If the design is fundamentally flawed, raise this now. Don't spend time on line-level feedback for a design that needs rethinking.

## Phase 3: Line-by-Line Review

Now read for correctness and quality:

- **Logic & correctness.** Do the conditions cover all cases? Are there off-by-one errors? Does the control flow match the intent?
- **Security.** Input validation, injection risks, auth checks, data exposure.
- **Performance.** Unnecessary allocations, redundant computation, O(n²) where O(n) suffices. Flag with evidence of the call chain.
- **Error handling.** Are errors propagated correctly? Are there silent failures? Does cleanup happen on error paths?
- **Maintainability.** Can a future reader understand this code? Are names clear? Is there implicit coupling?

**Apply Rule 1 & Rule 2 from SKILL.md:** Frame uncertain findings as questions. Calibrate severity to confidence.

## Phase 4: Summary & Verdict

Synthesize and decide:

- **Summarize key concerns** in priority order. Don't make the author reconstruct the important bits from a wall of comments.
- **Highlight strengths.** What did the author do well? Good design, clever solutions, thorough tests — acknowledge them.
- **Give an explicit verdict.** One of:
  - **Approve** — No blocking issues. Suggestions are optional.
  - **Comment** — No blocking issues, but there are suggestions worth considering.
  - **Request Changes** — There are blocking issues that must be addressed before merge.
- **If Requesting Changes:** Be specific about what needs to change and why. Don't leave the author guessing.

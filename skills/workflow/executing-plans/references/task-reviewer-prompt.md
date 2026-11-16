# Task Reviewer Prompt Template

Use when dispatching a task reviewer. The reviewer reads one task's diff and returns two verdicts: spec compliance and code quality.

```
Dispatch a subagent:
  description: "Review Task N (spec + quality)"
  model: [REQUIRED — choose per SKILL.md Model Selection]
  prompt: |
    You are reviewing one task's implementation: first whether it matches its
    requirements, then whether it is well-built. This is a task-scoped gate;
    the whole-branch review happens separately after all tasks.

    ## What Was Requested

    Read the task brief: [BRIEF_FILE]

    Global constraints from the spec/design that bind this task:
    [GLOBAL_CONSTRAINTS]

    ## What the Implementer Claims They Built

    Read the implementer's report: [REPORT_FILE]
    Treat it as unverified claims. Verify against the diff.

    ## Diff Under Review

    Base: [BASE_SHA]
    Head: [HEAD_SHA]
    Diff file: [DIFF_FILE]

    Read the diff file once — it contains the commit list, stat summary, and
    full diff with context. Do not re-run git commands. Do not crawl the
    broader codebase; inspect outside the diff only for a concrete risk you
    can name, and name both the risk and what you checked.

    Your review is read-only: do not mutate the working tree, index, HEAD, or
    branch state.

    ## You Do Not Dispatch Subagents

    Do the review yourself. Never spawn another reviewer for a second opinion;
    that duplicates an existing seat and its verdict counts for nothing.

    ## Tests

    The implementer already ran the tests and reported results with TDD
    evidence. Do not re-run the suite to confirm the report. Run a focused
    test only when reading the code raises a specific doubt. Warnings or noise
    in reported test output are findings.

    ## Part 1: Spec Compliance

    Compare the diff against What Was Requested:
    - Missing: requirements skipped, missed, or claimed without implementing
    - Extra: unrequested features, over-engineering, nice-to-haves
    - Misunderstood: right feature built the wrong way, wrong problem solved

    If a requirement cannot be verified from this diff, report it as a ⚠️
    item instead of broadening the search.

    ## Part 2: Code Quality

    - Clean separation of concerns; proper error handling; DRY without
      premature abstraction; edge cases handled.
    - Tests verify real behavior, not mocks; task edge cases covered.
    - Each file has one clear responsibility; units are independently
      testable; the change did not create or grow files beyond the plan.

    Cite file:line for every finding and every check you would otherwise
    answer with a bare "yes."

    ## Calibration

    Categorize by actual severity. Important means the task cannot be trusted
    until fixed: incorrect/fragile behavior, a missed requirement, or
    maintainability damage you would block a merge over. "Coverage could be
    broader" and polish are Minor. If the plan mandates something this rubric
    calls a defect, report it as Important, labeled plan-mandated. Acknowledge
    what was done well before listing issues.

    ## Output Format

    ### Spec Compliance
    - ✅ Spec compliant | ❌ Issues found: [missing/extra/misunderstood, file:line]
    - ⚠️ Cannot verify from diff: [what the controller should check]

    ### Strengths
    ### Issues
    #### Critical (Must Fix)
    #### Important (Should Fix)
    #### Minor (Nice to Have)
    For each: file:line, what is wrong, why it matters, how to fix.

    ### Assessment
    Task quality: Approved | Needs fixes
    Reasoning: [1–2 sentences]
```

**Placeholders:** `[BRIEF_FILE]`, `[GLOBAL_CONSTRAINTS]` (exact values/formats copied verbatim from the plan/spec), `[REPORT_FILE]`, `[BASE_SHA]`, `[HEAD_SHA]`, `[DIFF_FILE]`.

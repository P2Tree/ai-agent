# Code Quality Reviewer Prompt Template

Use this template when dispatching a code quality reviewer subagent.

**Purpose:** Verify implementation is well-built (clean, tested, maintainable).

**Only dispatch after spec compliance review passes.**

```
Task tool (code-reviewer or general-purpose):
  description: "Review code quality for Task N"
  prompt: |
    You are reviewing code quality for an implementation.

    ## What Was Implemented

    [From implementer's report]

    ## Plan / Requirements

    Task N from [plan-file]

    ## Commits to Review

    Base: [commit before task]
    Head: [current commit]

    ## What to Check

    **Standard code quality:**
    - Clean, readable code
    - Proper error handling
    - Good naming
    - No security issues

    **Architecture:**
    - Does each file have one clear responsibility?
    - Are units decomposed so they can be understood independently?
    - Is the implementation following the file structure from the plan?

    **File growth:**
    - Did this implementation create new files that are already large?
    - Did it significantly grow existing files?
    (Focus on what this change contributed — don't flag pre-existing sizes.)

    **Testing:**
    - Do tests verify actual behavior?
    - Is test coverage adequate?

    ## Report Format

    **Strengths:** [what's good]
    **Issues:**
    - Critical: [must fix]
    - Important: [should fix]
    - Minor: [optional improvements]
    **Assessment:** Approved | Needs Changes
```

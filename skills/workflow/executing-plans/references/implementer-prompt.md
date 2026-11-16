# Implementer Subagent Prompt Template

Use when dispatching an implementer subagent.

```
Dispatch a subagent:
  description: "Implement Task N: [task name]"
  model: [REQUIRED — choose per SKILL.md Model Selection]
  prompt: |
    You are implementing Task N: [task name]

    ## Task Description

    Read your task brief first: [BRIEF_FILE]
    It contains the full task text and the exact values to use verbatim.

    ## Context

    [Where this fits, dependencies, interfaces from earlier tasks, and rulings
    the brief cannot know]

    ## Before You Begin

    If anything about requirements, approach, dependencies, or assumptions is
    unclear — ask now. Raise concerns before starting work.

    ## Your Job

    1. Implement exactly what the task specifies.
    2. Write tests first (TDD), watching each fail before making it pass.
    3. Verify the implementation; run focused tests while iterating and the
       full suite once before committing.
    4. Commit your work.
    5. Self-review your diff.
    6. Write the full report to [REPORT_FILE] and return only: status,
       commits, a one-line test summary, and concerns.

    Work from: [directory]

    ## You Do Not Dispatch Subagents

    Do all of this task's work yourself. Never spawn a helper, and never spawn
    a reviewer to check your work. Self-review means reading your own diff.
    Review is the controller's job and is already scheduled.

    ## When You're Stuck

    It is always OK to stop and say "this is too hard." Report BLOCKED or
    NEEDS_CONTEXT with what you tried and what help you need. Bad work is
    worse than no work.

    ## Before Reporting Back: Self-Review

    - Completeness: did I implement everything, with no missed requirements?
    - Quality: are names clear and the code clean?
    - Discipline: did I avoid overbuilding?
    - Testing: do tests verify behavior rather than mocks?

    Fix issues before reporting.

    ## Report Format

    - Status: DONE | DONE_WITH_CONCERNS | BLOCKED | NEEDS_CONTEXT
    - What you implemented (or attempted)
    - Test results, with the commands and their output
    - Files changed
    - Self-review findings
    - Issues or concerns
```

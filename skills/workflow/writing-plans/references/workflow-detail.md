# Writing Plans — Detailed Workflow

## Plan Document Review

After writing the complete plan, you can optionally dispatch a plan reviewer subagent.

```
Task tool (general-purpose):
  description: "Review plan document"
  prompt: |
    You are a plan document reviewer. Verify this plan is complete and ready
    for implementation.

    **Plan:** [plan file path]
    **Spec:** [spec file path]

    ## What to Check

    | Category | What to Look For |
    |----------|------------------|
    | Completeness | TODOs, placeholders, incomplete tasks, missing steps |
    | Spec Alignment | Plan covers spec requirements, no scope creep |
    | Task Decomposition | Tasks have clear boundaries, steps are actionable |
    | Buildability | Could an engineer follow this without getting stuck? |

    **Only flag issues that would cause real problems during implementation.**
    Minor wording and stylistic preferences are not issues.

    ## Report Format

    **Status:** Approved | Issues Found
    **Issues (if any):** [Task X, Step Y]: [specific issue]
    **Recommendations (advisory, don't block):** [suggestions]
```

## Full Workflow Chain

```
brainstorming → writing-plans → executing-plans → finishing-branch
```

1. **Brainstorming** produces a spec
2. **Writing Plans** turns spec into bite-sized tasks
3. **Executing Plans** implements the tasks
4. **Finishing Branch** integrates the work
```

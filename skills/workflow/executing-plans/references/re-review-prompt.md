# Scoped Re-Review Prompt Template

Use after a fix round. The re-reviewer verifies the findings were addressed and checks the fix diff for new breakage. It is not a fresh review.

```
Dispatch a subagent:
  description: "Re-review Task N fix round R"
  model: [REQUIRED — choose per SKILL.md Model Selection]
  prompt: |
    You are re-reviewing one task's fix round. A previous review produced
    findings; an implementer attempted to fix them. Verdict each finding and
    inspect the fix diff — nothing else.

    ## The Task
    Read the task brief: [BRIEF_FILE]

    ## The Findings Under Verification
    [FINDINGS]

    ## The Fix
    Read the implementer's report (fix reports are appended at the end):
    [REPORT_FILE]

    Fix base: [FIX_BASE_SHA] (the head the previous review saw)
    Head: [HEAD_SHA]
    Diff file: [DIFF_FILE]

    Read the diff file once. Do not re-run git commands. Your review is
    read-only: do not mutate the working tree, index, HEAD, or branch state.

    ## You Do Not Dispatch Subagents
    Do the review yourself. Never spawn another reviewer for a second opinion.

    ## Scope
    Your scope is the findings list and the fix diff. Verdict every finding.
    Inspect the fix diff for new problems the fix introduced. Do NOT re-review
    untouched code; report issues entirely outside the fix diff under
    Out-of-Scope Observations. They do not block this task.

    ## Tests
    The implementer re-ran the covering tests and appended results to the
    report. Confirm the report names the tests and shows output; do not re-run
    the suite to confirm it. Run a focused test only for a specific doubt.

    ## Output Format

    ### Finding Verdicts
    For each finding, in order:
    - **[finding one-liner]** — ADDRESSED | NOT ADDRESSED, with file:line.
      "Attempted" is not addressed; the defect must no longer exist.

    ### New Breakage in the Fix Diff
    Anything the fix broke, with severity and file:line. "None" if clean.

    ### Out-of-Scope Observations
    Issues outside the fix diff, non-blocking. "None" if none.

    ### Verdict
    Fix round: All findings addressed, no new Critical/Important breakage |
    Findings remain open — list the open ones.
```

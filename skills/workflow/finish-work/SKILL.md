---
name: finish-work
description: Finish a completed task — verify tests, summarize the change, commit, optionally create a PR, and update the originating issue. Use when implementation and review are complete and you want to commit, open a PR, close an issue, or hand the work off.
---

# Finish Work

Turn finished work into a clean commit, an optional PR, and an updated issue. Every step is confirmable and skippable; the user keeps control.

## Pre-flight

- Detect the forge from `git remote -v`: GitHub (`gh`) or GitLab (`glab`). If neither, skip the issue steps and say so.
- Read `GLOSSARY.md` / `docs/adr/` only if they exist and the change touches those decisions.
- Find the originating issue from the task brief, branch name, commit messages, or the user. If none, skip issue updates.

## Step 1: Verify Tests

Run the project's documented test commands. Look for guidance in `README.md`, `CLAUDE.md`/`AGENTS.md`, `package.json` scripts, the build tool, or CI config. Do not guess a command.

- If the last code change happened **after** the last full test run, rerun now.
- If a full run already covers the final code, reuse that evidence and say where it came from.
- A green suite means a command you just ran (or a verified recent run), not "should pass". If tests fail, stop and fix before committing.

## Step 2: Summarize the Work

Write a PR-body-style summary. Do **not** print the diff. Include:

- what changed and why;
- user-visible behavior;
- verification evidence (commands and results);
- risks, rollout notes, or rollback points;
- linked issue/PR references.

Show this summary to the user and let them edit it.

## Step 3: Commit

1. Inspect `git status` and the staged/unstaged changes.
2. Stage only the intended files; never stage unrelated work or generated junk.
3. Detect the repo's commit style (`git log --oneline -20`): Conventional Commits or the existing convention.
4. Generate the commit message and **wait for approval**. If the user edits it, use their version.
5. Commit.

If the user prefers to commit manually, skip to Step 4.

## Step 4: Create a PR (optional)

Ask whether to create a PR. If yes:

- Detect the base branch from the plan, conversation, or upstream; confirm it if unclear.
- Use the repo's PR template (`.github/PULL_REQUEST_TEMPLATE.md`, `.gitlab/merge_request_templates/`, or the project's convention).
- Match the repo's language: if the source issue/spec is entirely English, write English; otherwise follow the source.
- Reuse the Step 2 summary as the PR body.
- Create the PR **before** updating the issue, so the issue comment can link it.
- If another PR guidance skill applies, invoke it. Report the PR URL.

## Step 5: Update the Originating Issue

Use the forge CLI:

- Comment with the commit and/or PR link.
- Apply or update the triage label if the repo uses them.
- Close the issue if the work is done; leave it open if follow-ups remain.

If there is no issue, skip this step and say so.

## Step 6: Clean Up (only if applicable)

- Normal repo: nothing to clean up.
- Linked worktree: remove and prune **only** if this workflow created it or the user asks. Otherwise leave it to the host.
- Never delete branches or worktrees without explicit confirmation.

## Manual Overrides

At any step the user may say "I'll do this myself". Skip that step, report what remains, and do not retry it.

## Red Flags

- Committing with failing tests or unverified changes.
- Staging unrelated files or credentials.
- Creating a PR before the summary/commit is settled.
- Force-pushing, deleting branches, or removing worktrees without explicit confirmation.
- Assuming the base branch is main.

## Next Steps

- If review has not happened yet: **code-review** with a fresh agent.
- If a follow-up bug or regression appears: **diagnose**.

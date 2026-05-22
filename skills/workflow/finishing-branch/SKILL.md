---
name: finishing-branch
description: Complete development work by verifying tests and presenting structured options for merge, PR, or cleanup. Use when implementation is complete, all tests pass, and you need to integrate the work.
---

# Finishing a Development Branch

Verify tests → Present options → Execute choice → Clean up.

## Pre-flight: read agent environment

Read the repo's agent environment (set up by `/init-agent-environment`) to close the loop with the issue tracker:

- **`docs/agents/issue-tracker.md`** — tells you how to interact with the project's issue tracker (GitHub, GitLab, local markdown, etc.). Use it to link the PR to the originating issue and close it.
- **`docs/agents/triage-labels.md`** — if the originating issue carries a triage label (e.g. `ready-for-agent`), update it to reflect completion (e.g. remove it or apply a closed-state label) using the label strings from this file.

If these files don't exist, proceed without issue-tracker integration — don't block the workflow on missing config.

## The Process

### Step 1: Verify Tests

Run the project's test suite. If tests fail, stop and fix before proceeding. Do not offer integration options with failing tests.

### Step 2: Determine Base Branch

Check the current branch's remote tracking branch first (`git rev-parse --abbrev-ref --symbolic-full-name @{u}`). If tracked, use the remote branch as the base. If not tracked, ask the user which remote branch to merge into.

### Step 3: Determine Commit & PR Style

**Commit message style:** analyze recent commit history (`git log --oneline -20`) to learn the project's commit conventions (Conventional Commits, plain text, etc.). If multiple styles are detected, present the options with your recommendation and let the user choose.

**PR template:** check for PR/MR templates in the repo (`.github/PULL_REQUEST_TEMPLATE.md`, `.gitlab/merge_request_templates/`, etc.). If multiple templates exist, ask the user which to use. If none found, use the default template below.

**PR language:** if the source issue and related specs are entirely in English, write the PR in English; otherwise, follow the language used in those source materials.

### Step 4: Present Options

Present exactly these 4 options:

1. **Merge locally** to base branch
2. **Push and create PR**
3. **Keep the branch as-is** (handle later)
4. **Discard this work**

Keep options concise — don't add explanation.

### Step 5: Execute Choice

**Option 1: Merge Locally**

```bash
git checkout <base-branch>
git pull
git merge <feature-branch>
<test command>
git branch -d <feature-branch>
```

Then cleanup worktree.

**Option 2: Push and Create PR**

```bash
git push -u origin <feature-branch>
```

Create PR using the detected template (or default below) with commit style from Step 3:

<default-pr-template>
## Summary
<2-3 bullets>

## Test Plan
- [ ] <verification steps>
</default-pr-template>

Keep worktree (may need follow-up on PR).

**Option 3: Keep As-Is**

Report branch name and worktree path. Don't cleanup worktree.

**Option 4: Discard**

Require typed "discard" confirmation. Then:

```bash
git checkout <base-branch>
git branch -D <feature-branch>
```

Cleanup worktree.

### Step 6: Cleanup Worktree

For Options 1 and 4 only, remove the worktree:

```bash
git worktree remove <worktree-path>
```

## Quick Reference

| Option | Merge | Push | Keep Worktree | Cleanup Branch |
|--------|-------|------|---------------|----------------|
| 1. Merge locally | yes | - | - | yes |
| 2. Create PR | - | yes | yes | - |
| 3. Keep as-is | - | - | yes | - |
| 4. Discard | - | - | - | yes (force) |

## Red Flags

**Never:**

- Proceed with failing tests
- Merge without verifying tests on result
- Delete work without confirmation
- Force-push without explicit request

**Always:**

- Verify tests before offering options
- Present exactly 4 options
- Get typed confirmation for discard
- Clean up worktree for Options 1 & 4 only

## Next Steps

- **triage** — update the originating issue's triage label to reflect completion

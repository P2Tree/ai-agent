---
name: finishing-branch
description: Complete development work by verifying tests and presenting structured options for merge, PR, or cleanup. Use when implementation is complete, all tests pass, and you need to integrate the work.
---

# Finishing a Development Branch

Verify tests → Detect environment → Determine base → Present options → Execute choice → Clean up.

## Pre-flight: read agent environment

Read the repo's agent environment (set up by `/init-agent-environment`) to close the loop with the issue tracker:

- **`docs/agents/issue-tracker.md`** — how to link the PR to the originating issue and close it.
- **`docs/agents/triage-labels.md`** — if the issue carries a triage label, update it using the label strings from this file.

If these files don't exist, proceed without issue-tracker integration.

## Step 1: Verify Tests

Run the project's full test suite. If tests fail, report the failures and stop — the menu comes only after a green suite.

## Step 2: Detect Environment

Capture these before changing directory:

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
WORKTREE_PATH=$(git rev-parse --show-toplevel)
```

| State | Menu | Cleanup |
|-------|------|---------|
| `GIT_DIR == GIT_COMMON` (normal repo) | Standard 3 options | No worktree |
| `GIT_DIR != GIT_COMMON`, named branch | Standard 3 options | Provenance-based |
| `GIT_DIR != GIT_COMMON`, detached HEAD | Reduced 2 options (no merge) | Leave in place |

## Step 3: Determine Base Branch

The base is whatever this work forked from — usually named in the plan, the conversation, or the branch's upstream. If it isn't already known, ask: "This branch split from <best guess> — is that correct?" Confirm before merging; merging into the wrong base is expensive to undo.

- **Commit style:** analyze `git log --oneline -20`; if mixed, present options with a recommendation.
- **PR template and language:** check `.github/PULL_REQUEST_TEMPLATE.md`, `.gitlab/merge_request_templates/`, and similar; if none use the default below. If the source issue and specs are entirely English, write the PR in English; otherwise follow the source materials.

## Step 4: Present Options

**Normal repo / named-branch worktree — exactly these 3:**

```
Implementation complete. What would you like to do?

1. Merge back to <base-branch> locally
2. Push and create a Pull Request
3. Keep the branch as-is (I'll handle it later)
```

**Detached HEAD — exactly these 2:**

```
Implementation complete. You're on a detached HEAD (externally managed workspace).

1. Push as new branch and create a Pull Request
2. Keep as-is (I'll handle it later)
```

Present the menu as written and wait. Discarding happens only when the user explicitly asks for it — never as a menu option.

## Step 5: Execute Choice

### Option 1: Merge Locally

```bash
MAIN_ROOT=$(git -C "$(git rev-parse --git-common-dir)/.." rev-parse --show-toplevel)
cd "$MAIN_ROOT"
git checkout <base-branch>
git pull
git merge <feature-branch>
<test command>
```

Merge first, verify the merged result, then clean up. If tests fail on the merged result, stop, leave the worktree and branch in place, and investigate — nothing has been pushed, so the merge is recoverable.

### Option 2: Push and Create PR

```bash
git push -u origin <feature-branch>
# Detached HEAD: git push origin HEAD:refs/heads/<new-branch>
```

Create the pull/merge request against the base with the forge's CLI or the creation URL printed by the push, following the repo's template. Report the URL. Keep the worktree — PR feedback is fixed there.

<default-pr-template>
## Summary
<2-3 bullets>

## Test Plan
- [ ] <verification steps>
</default-pr-template>

### Option 3: Keep As-Is

Report: "Keeping branch <name>. Worktree preserved at <path>."

### If the user explicitly asks to discard

Confirm first, listing the branch, commits, and worktree path, and require the typed word `discard`. Only then:

```bash
MAIN_ROOT=$(git -C "$(git rev-parse --git-common-dir)/.." rev-parse --show-toplevel)
cd "$MAIN_ROOT"
git branch -D <feature-branch>
```

Then clean up the worktree.

## Step 6: Cleanup Workspace

Runs for Option 1 and confirmed discards. Options 2 and 3 preserve the worktree. Remove from outside the worktree, using the captured `GIT_DIR`/`GIT_COMMON`/`WORKTREE_PATH`.

- **`GIT_DIR == GIT_COMMON`:** normal repo, nothing to clean up.
- **`WORKTREE_PATH` under `.worktrees/` or `worktrees/`:** this workflow created it — remove and prune:
  ```bash
  git worktree remove "$WORKTREE_PATH"
  git worktree prune
  ```
- **Removal refused** ("contains modified or untracked files"): files exist only there. Never `--force` on your own initiative. Show `git -C "$WORKTREE_PATH" status --porcelain -uall` and ask whether to commit them, move them to the main repo, or delete them.
- **Anything else:** the host owns the workspace — leave it in place.

## Quick Reference

| Option | Merge | Push | Keep Worktree | Cleanup Branch |
|--------|-------|------|---------------|----------------|
| 1. Merge locally | yes | - | - | yes |
| 2. Create PR | - | yes | yes | - |
| 3. Keep as-is | - | - | yes | - |
| Discard (explicit request only) | - | - | - | yes (force) |

## Red Flags

- Proceeding with failing tests, or assuming earlier green tests still hold.
- Offering discard in the menu, or treating "get rid of it" as confirmation.
- Assuming the base is main without confirming.
- Deleting a worktree outside `.worktrees/`/`worktrees/`, or `--force` after a refused removal.
- Force-pushing without an explicit request, or cleaning up a worktree while its PR is still being iterated on.

## Next Steps

- **triage** — update the originating issue's triage label to reflect completion.

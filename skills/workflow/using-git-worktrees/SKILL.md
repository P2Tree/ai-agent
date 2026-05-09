---
name: using-git-worktrees
description: Create isolated git worktrees for feature development. Use when starting feature work that needs isolation from current workspace or before executing implementation plans.
---

# Using Git Worktrees

Git worktrees create isolated workspaces sharing the same repository, allowing work on multiple branches simultaneously without switching.

**Core principle:** Systematic directory selection + safety verification = reliable isolation.

## Directory Selection

Follow this priority order:

1. **Check existing directories:** `.worktrees/` (preferred) or `worktrees/`
2. **Check project config** for worktree directory preference
3. **Ask user** if neither exists

If both `.worktrees/` and `worktrees/` exist, use `.worktrees/`.

## Safety Verification

For project-local directories, verify the directory is git-ignored BEFORE creating worktree:

```bash
git check-ignore -q .worktrees 2>/dev/null
```

If NOT ignored: add to .gitignore and commit. This prevents accidentally committing worktree contents.

For global directories (outside project): no .gitignore check needed.

## Creation Steps

### 1. Detect Project Name

```bash
project=$(basename "$(git rev-parse --show-toplevel)")
```

### 2. Create Worktree

```bash
git worktree add "<location>/<branch-name>" -b "<branch-name>"
cd "<location>/<branch-name>"
```

### 3. Run Project Setup

Auto-detect and run:

- `package.json` → `npm install`
- `Cargo.toml` → `cargo build`
- `requirements.txt` → `pip install -r requirements.txt`
- `pyproject.toml` → `poetry install`
- `go.mod` → `go mod download`

### 4. Verify Clean Baseline

Run tests to ensure worktree starts clean. If tests fail, report and ask whether to proceed.

### 5. Report

```
Worktree ready at <full-path>
Tests passing (<N> tests, 0 failures)
Ready to implement <feature-name>
```

## Common Mistakes

- **Skipping ignore verification** → worktree contents pollute git status
- **Assuming directory location** → inconsistency across team
- **Proceeding with failing tests** → can't distinguish new bugs from pre-existing
- **Hardcoding setup commands** → breaks on different project types

## Related Skills

- **finishing-branch** — cleans up worktree after work complete
- **executing-plans** — requires worktree before executing tasks

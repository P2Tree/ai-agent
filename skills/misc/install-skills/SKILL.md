---
name: install-skills
description: Interactively install skills from ai-agent repo to a target platform directory via symlinks. Use when setting up skills on a new machine, updating installed skills, or managing skill installations.
disable-model-invocation: true
---

# Install Skills

Interactively install skills from the ai-agent repository to a target directory via symlinks. Each skill is presented with its name and description for user confirmation.

## Process

### 1. Determine Target Directory

Check common skill directories in order:

1. `~/.claude/skills` — Claude Code
2. `~/.cursor/skills` — Cursor
3. Other user-specified path

If multiple exist, ask which to use. If none exist, propose `~/.claude/skills` and ask for confirmation. Create the directory if it doesn't exist.

### 2. Scan Available Skills

Scan all official buckets in the ai-agent repo:

- `engineering/`, `productivity/`, `composition/`, `workflow/`, `misc/`, `personal/`

Exclude: `draft/`, `deprecated/`, `internal/`.

For each skill directory containing a `SKILL.md`, extract the `name` and `description` from frontmatter.

### 3. Interactive Install

For each skill, present:

```
[skill-name]
  description line here

Install? (y/n/skip-all)
```

**Conflict handling:** If the target directory already has an entry (file or symlink) with the same name:

```
[skill-name] — already exists (symlink to /old/path | regular file)
  Replace / Keep existing?
```

- **Replace:** Remove old entry, create new symlink
- **Keep existing:** Skip this skill

Create symlink: `ln -s <source-skill-dir> <target-dir>/<skill-name>`

The source path must be absolute so the symlink works from any location.

### 4. Installation Summary

After processing all skills, display:

```
=== Installed ===
  skill-name → /path/to/ai-agent/skills/bucket/skill-name

=== Skipped ===
  skill-name (user declined)
  skill-name (kept existing)

Total: X installed, Y skipped
```

Ask: "Analyze skill design health? (y/n)"

### 5. Skill Health Analysis

If the user opts in, run three checks:

**A. Structural validation**
Run `scripts/validate-skill.sh` for each installed skill. Report any failures.

**B. Overlap detection**
Scan descriptions for semantically overlapping skill pairs. Flag pairs where:
- Two skills mention the same trigger condition
- Two skills address the same problem domain

Present as advisory, not prescriptive.

**C. Health flags**
For each installed skill:
- SKILL.md over 150 lines → "verbose, consider splitting to references/"
- No "Use when" in description → "missing trigger condition"
- Skill is just a prompt with no structure → "consider if this should be a skill vs. a CLAUDE.md rule"

Output a summary report.

## Notes

- Symlinks use absolute source paths for portability
- The skill does NOT modify any files in the ai-agent repo
- Re-running the skill detects existing symlinks and offers updates
- Compatible with bash and zsh

See [health analysis details](references/health-analysis.md) for analysis criteria.

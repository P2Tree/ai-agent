---
name: manage-skills
description: Browse, audit, and manage installed agent skills — any source, not just ai-agent. Use when checking what's installed, auditing skill health, removing skills, syncing with upstream, or wanting to install new skills.
disable-model-invocation: true
---

# Skill Manager

Browse, audit, and manage installed agent skills — works with any source, not just ai-agent.

## Bucket Definitions

Classify skills by reading their `description` from SKILL.md frontmatter:

| Bucket | Scope |
|--------|-------|
| engineering | 软件开发 (software development) |
| productivity | 效率提升 (efficiency, non-coding) |
| composition | 内容生成 (content generation) |
| workflow | 工作流 (git, plans, issues, deployment) |
| misc | 杂项 (other) |
| custom | 自定义 (user-created, doesn't fit above) |

## Process

### 1. Ask User Intent

Use AskUserQuestion to present options and get the user's choice:

- **question**: "What would you like to do?"
- **options**:
  1. "Browse installed skills"
  2. "Install & sync skills"
  3. "Audit & health check"
  4. "Remove skills"
- **multiSelect**: false

Then proceed to the corresponding section based on the user's choice.

### 2. Browse Installed Skills

Scan skill directories (`~/.claude/skills/`, project-level `.claude/skills/`). For each, read SKILL.md frontmatter (name, description). Classify into buckets using the definitions above.

Display organized by bucket, mark source (ai-agent / third-party / unknown), show descriptions. Report total count per source.

### 3. Install & Sync Skills

#### 3a. Install a Skill

User specifies what they want (name, domain, or problem description).

**A. Check find-skills availability**
- find-skills installed → proceed to B
- find-skills not installed → recommend installing: "find-skills can search the open ecosystem. Install it?" If declined → "Will only search ai-agent skills."

**B. Search ai-agent skills**
Run `npx skills add p2tree/ai-agent --list` to find matching ai-agent skills. Show matches with descriptions.

**C. Search external ecosystem (if find-skills available)**
Delegate to find-skills to find equivalent skills from other sources.

**D. Present options**

```
Matches for "[query]":
  1. [ai-agent] skill-name — description... (curated)
  2. [external] skill-name — description... (source: owner/repo, X installs)
Install which?
```

If only one source matches, show it directly with source info.

**E. Install chosen skill**
- ai-agent skill: `npx skills add p2tree/ai-agent --skill <name>`
- External skill: `npx skills add <owner/repo> --skill <name>` (via find-skills)
- Local-clone mode: also offer symlink for ai-agent skills

**Conflict handling:** If target directory already has an entry, offer: Replace / Keep existing / View both.

#### 3b. Sync Check (Missing & Outdated)

Check which ai-agent skills are uninstalled or outdated. Works for all installation types (npx, symlink, copy).

1. **Fetch remote skill list** from `p2tree/ai-agent` via `gh api` → `curl` → degraded mode (timestamp only)
2. **Identify ai-agent source** for each installed skill: skill-lock.json `source` field → symlink path → name match against remote list
3. **Uninstalled check**: remote skill list − local installed names → show missing skills with descriptions
4. **Outdated check**: compare local vs remote SKILL.md content (hash diff); fall back to mtime heuristics if remote unreachable
5. **Offer actions**: install missing (`npx skills add`), update outdated (`npx skills update` or re-add), or skip

See [sync check details](references/sync-check.md).

### 4. Audit & Health Check

#### 4a. Audit Installed Skills

Scan all skill directories. Detect source per skill:
- **skill-lock.json**: Entry with `source` → definitive source
- **Symlink target**: Path contains identifiable repo name
- **No tracking**: Label as "unknown source"

Check for issues:
- Broken symlinks (target doesn't exist)
- Moved targets (symlink points to old bucket path)
- Ghost entries (skill-lock.json entry with no directory)
- Duplicate scope (same skill in global + project)
- Orphaned skills (no lock entry, no symlink, no known source)

#### 4b. Health Analysis

Run checks per references/health-analysis.md:
- Structural validation (frontmatter, line count, sensitive data, triggers)
- Broken symlinks and stale copies
- Overlap detection between skill descriptions
- Staleness for npx-installed skills

Ask "Run health analysis? (y/n)" before proceeding.

### 5. Remove Skills

Detect installation type per skill:
- **npx-installed**: `npx skills remove <name>`
- **Symlink**: Remove the symlink
- **Copied/unknown**: Remove directory

Always confirm before removal. Show what will be removed and detected source.

## Notes

- Works in both local-clone and npx-only environments
- No agent-specific tool names in this document
- find-skills is optional — install flow degrades gracefully without it
- Compatible with bash and zsh

See [health analysis details](references/health-analysis.md).

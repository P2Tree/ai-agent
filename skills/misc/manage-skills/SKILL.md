---
name: manage-skills
description: Browse, audit, and manage installed agent skills — any source, not just ai-agent. Use when checking what's installed, auditing skill health, removing skills, syncing with upstream, or wanting to install new skills.
disable-model-invocation: true
---

# Skill Manager

Browse, audit, and manage installed agent skills — works with any source, not just ai-agent.

## Bucket Definitions

Classify by the `description` in SKILL.md frontmatter: engineering (软件开发), productivity (效率提升), composition (内容生成), workflow (工作流), misc (杂项), custom (自定义).

## Process

### 1. Ask User Intent

Use AskUserQuestion to present options and get the user's choice:

- **question**: "What would you like to do?"
- **options**:
  1. "Browse installed skills"
  2. "Install skills (incl. recommended upstream)"
  3. "Audit & health check"
  4. "Remove skills"
- **multiSelect**: false

Then proceed to the corresponding section based on the user's choice.

### 2. Browse Installed Skills

Scan skill directories (`~/.claude/skills/`, `~/.agents/skills/`, project-level `.claude/skills/`, `.agents/skills/`). For each, read SKILL.md frontmatter (name, description). Classify into buckets using the definitions above.

Display organized by bucket, mark source (ai-agent / third-party / unknown), show descriptions. Report total count per source.

### 3. Install & Sync Skills

#### 3.0 Choose the source

Ask what to install:

- **ai-agent skills** — curated skills from this repo
- **Recommended upstream skills** — official skills not bundled here (see [recommended upstream](references/recommended-upstream.md))
- **Search the ecosystem** — use find-skills to find something else

Then continue to the matching subsection.

#### 3a. Install an ai-agent Skill

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

`npx skills add` installs to `~/.agents/skills/`. Ensure this directory exists before installing (`mkdir -p ~/.agents/skills`).

- ai-agent skill: `npx skills add p2tree/ai-agent --skill <name>`
- External skill: `npx skills add <owner/repo> --skill <name>` (via find-skills)

All installs use `npx` — do not assume a local ai-agent clone exists.

**Conflict handling:** If target directory already has an entry, offer: Replace / Keep existing / View both.

#### 3b. Sync Check (Missing & Outdated)

Check which ai-agent skills are uninstalled or outdated. All operations use `npx` via cloud — no local ai-agent clone assumed.

1. **Fetch remote skill list** from `p2tree/ai-agent` via `curl -s https://raw.githubusercontent.com/p2tree/ai-agent/main/.agents/skills.json`; fall back to `gh api`; degraded mode (timestamp only) if unreachable
2. **Identify ai-agent source** for each installed skill: skill-lock.json `source` field → symlink target path → name match against remote list
3. **Uninstalled check**: remote skill list − local installed names → show missing skills with descriptions
4. **Outdated check**: directly compare local SKILL.md SHA256 vs remote raw.githubusercontent.com SKILL.md — this is the only authoritative method. Do NOT use skill-lock.json hashes for this comparison (lock hashes record install-time state for integrity, not freshness vs remote)
5. **Offer actions**: install missing (`npx skills add`), update outdated (`npx skills update`), or skip

See [sync check details](references/sync-check.md) for data-parsing pitfalls and the exact comparison method.

#### 3c. Install Recommended Upstream Skills

Read [recommended upstream](references/recommended-upstream.md), then:

1. Show the list as a **multi-select** question: "Which recommended upstream skills do you want to install?"
2. Let the user pick any subset, or cancel.
3. For each selected skill: if installed, ask update/replace/skip; otherwise follow its installer type — run `npx` commands directly, and for manual installers show the commands, explain packs/runtime requirements, and run only after confirmation.
4. Verify each install by checking the skill directory or running the browse flow.
5. Report installed, skipped, and failed items.

### 4. Audit & Health Check

#### 4a. Audit Installed Skills

Scan all skill directories. Detect source per skill:
- **skill-lock.json**: Entry with `source` → definitive source
- **Symlink target**: Path contains identifiable repo name
- **No tracking**: Label as "unknown source"

Check for broken symlinks, moved targets, ghost lock entries, duplicate global/project scope, and orphaned skills (no lock entry, symlink, or known source).

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

- All install and update operations use `npx` — no local ai-agent clone needed
- No agent-specific tool names in this document
- find-skills is optional — install flow degrades gracefully without it
- Document skills (`pdf`, `docx`, `pptx`, `xlsx`) are recommended upstream, not bundled
- Compatible with bash and zsh

See [health analysis details](references/health-analysis.md) and [recommended upstream skills](references/recommended-upstream.md).

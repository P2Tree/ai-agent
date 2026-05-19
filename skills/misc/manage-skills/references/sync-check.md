# Sync Check — Detailed Flow

Check which ai-agent skills are missing or outdated in the local installation. Works for all installation types (npx, symlink, copy).

## Remote Fetch Strategy

Fetch remote skill info with fallback chain:

1. **gh api** — `gh api repos/p2tree/ai-agent/contents/.agents/skills.json` → parse JSON → get skill list
2. **curl raw URL** — `curl -s https://raw.githubusercontent.com/p2tree/ai-agent/main/.agents/skills.json` → parse JSON
3. **Degraded mode** — if neither works (no gh, no network), fall back to timestamp-based staleness only and warn: "Cannot reach remote. Only local timestamp check available. Install gh or check network for full sync."

## Source Identification (3 tiers)

For each locally installed skill, determine if it comes from ai-agent:

| Tier | Signal | Confidence | Method |
|------|--------|------------|--------|
| 1 | skill-lock.json has `source` containing "ai-agent" or "p2tree/ai-agent" | Definitive | Read skill-lock.json in skill directory |
| 2 | Symlink target path contains "ai-agent" | Definitive | `readlink` on skill directory |
| 3 | SKILL.md `name` matches a name in the remote ai-agent skill list | Inferred | Compare after remote fetch |

Tier 3 matches are labeled "inferred source" in output — user should confirm.

## Uninstalled Check

1. Run remote fetch to get full ai-agent skill list (paths like `./skills/{bucket}/{name}`)
2. Extract skill names from paths (last path segment)
3. Scan local skill directories (`~/.claude/skills/`, project-level `.claude/skills/`), collect installed skill names
4. Compute set difference: remote names − local names = uninstalled
5. For each uninstalled skill, show name and short description (from remote skills.json or fetched SKILL.md frontmatter)

## Outdated Check

For each installed skill identified as ai-agent source (any tier):

### A. npx-installed (has skill-lock.json)

1. Read `skillFolderHash` from skill-lock.json
2. Compute SHA256 hash of current local skill files (`find . -type f | sort | xargs cat | sha256sum`)
3. If hash differs from `skillFolderHash` → "locally modified or source changed"
4. Read `updatedAt`; if over 30 days old → "may be outdated"
5. Optionally: fetch remote SKILL.md, compute hash, compare with local SKILL.md hash for definitive answer

### B. Symlink or copied (no skill-lock.json)

1. Fetch remote SKILL.md for this skill via gh api or curl raw URL
   - raw URL: `https://raw.githubusercontent.com/p2tree/ai-agent/main/skills/{bucket}/{name}/SKILL.md`
2. Compare remote content with local SKILL.md:
   - SHA256 hash comparison (preferred)
   - Line count diff as fallback (significant line count change likely means update)
3. If different → "remote version differs"
4. If remote fetch fails → check local SKILL.md mtime; if over 30 days → "may be outdated (unverified)"

### C. Remote unreachable (degraded mode)

- Check local SKILL.md mtime
- Over 30 days → "may be outdated (unverified)"
- Under 30 days → "recent, likely up to date (unverified)"

## Output Format

```
=== Sync Check ===

Source: p2tree/ai-agent (main)

Uninstalled (2):
  arch-doc       — 架构设计说明书
  writing-prd    — 将对话上下文合成为 PRD

Outdated (1):
  coauthoring    — remote version differs (installed 2026/04/01)

Up to date (4):
  diagnose, code-review, tdd, improve-architecture

Untracked (1):
  caveman        — name match, inferred source (no lock/symlink)

Total: 2 uninstalled / 1 outdated / 4 up to date / 1 untracked

Actions:
  Install missing? / Update outdated? / Skip
```

## User Actions

After displaying results, offer actions:

- **Install missing** — for each uninstalled skill user selects, run: `npx skills add p2tree/ai-agent --skill <name>`
- **Update outdated** — for each outdated skill user selects:
  - npx-installed: `npx skills update <name>`
  - Symlink: update the symlink target or re-link
  - Copied: re-download via `npx skills add p2tree/ai-agent --skill <name>` (will conflict → offer Replace)
- **Skip** — no action

Always confirm before making changes. Show what will be installed/updated.

## Notes

- Works in both local-clone and npx-only environments
- No agent-specific tool names — uses `gh`, `curl`, `sha256sum`, `readlink` (standard CLI tools)
- Compatible with bash and zsh
- Remote repo path `p2tree/ai-agent` is the default; allow override if user has a fork
- Rate limit awareness: curl to GitHub raw has 60 req/hr unauthenticated; batch skill fetches efficiently

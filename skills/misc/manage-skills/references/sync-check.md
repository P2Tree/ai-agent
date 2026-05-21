# Sync Check — Detailed Flow

Check which ai-agent skills are missing or outdated in the local installation. Works for all installation types (npx, symlink, copy).

## Remote Fetch Strategy

Fetch remote skill info with fallback chain:

1. **curl raw URL** — `curl -s https://raw.githubusercontent.com/p2tree/ai-agent/main/.agents/skills.json` → parse JSON
2. **gh api** — `gh api repos/p2tree/ai-agent/contents/.agents/skills.json` → parse JSON → get skill list
3. **Degraded mode** — if neither works (no gh, no network), fall back to timestamp-based staleness only and warn: "Cannot reach remote. Only local timestamp check available. Install gh or check network for full sync."

Prefer `curl` first — it has no auth requirements and works across environments. `gh api` is a fallback for when GitHub raw is rate-limited.

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

**Authoritative method — direct remote comparison:**

1. Get the bucket for the skill from the remote skills.json (already fetched)
2. Fetch remote SKILL.md: `curl -s https://raw.githubusercontent.com/p2tree/ai-agent/main/skills/{bucket}/{name}/SKILL.md`
3. Compute SHA256 of both local and remote SKILL.md content
4. If hashes differ → "outdated"
5. If hashes match → "up to date"

**Do NOT use `skill-lock.json` hashes for outdated detection.** Lock file `skillFolderHash` records install-time state for integrity checks, not freshness vs remote. In practice, it produces false MODIFIED reports on every skill because the hashing method differs from a direct SHA256 of file content. The only reliable comparison is local SKILL.md vs remote raw.githubusercontent.com.

**Batch efficiency:** Use a single Python/Node script to fetch and compare all skills in one pass. This avoids N separate curl invocations (rate limits: 60 req/hr unauthenticated) and is significantly faster. Construct URLs as `https://raw.githubusercontent.com/p2tree/ai-agent/main/skills/{bucket}/{name}/SKILL.md`.

**Degraded mode (remote unreachable):** Check local SKILL.md mtime. Over 30 days → "may be outdated (unverified)". Under 30 days → "recent, likely up to date (unverified)".

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

- **Install missing** — for each uninstalled skill user selects, run: `cd "$PROJECT_ROOT" && npx skills add p2tree/ai-agent --skill <name>`
- **Update outdated** — for each outdated skill user selects, run: `cd "$PROJECT_ROOT" && npx skills update <name>`
- **Skip** — no action

Always confirm before making changes. Show what will be installed/updated.

## Data Parsing Pitfalls

Real-world lessons from sync runs:

1. **`ls` with symlink arrows** — `ls -1` in a directory with symlinks emits entries like `skill-name ⇒ target`. Piping this to `comm` or `diff` silently breaks because every line contains `⇒`. Use `for d in */; do echo "${d%/}"; done` to get clean directory names.

2. **Lock file hash ≠ outdated check** — `skill-lock.json` records `skillFolderHash` at install time for integrity verification. Comparing it against a direct SHA256 of file content always shows MODIFIED (hashing methods differ). For outdated detection, only direct remote SKILL.md comparison is authoritative.

3. **Understand the symlink chain first** — Before diagnosing hash mismatches or broken installs, trace where skills actually live (`readlink -f`). Common pattern: `~/.claude/skills/<name>` → `$PROJECT_ROOT/.agents/skills/<name>` (npx-managed copies). Don't assume a git clone is involved. Note: `npx skills add` installs to `.agents/skills/` relative to CWD, so always run it from the project root (absolute path) to avoid creating `.agents/` in the wrong directory.

4. **Batch remote fetches** — A single script that fetches all remote SKILL.md files in one pass is faster and avoids rate limits. Don't loop `curl` per skill in shell.

## Notes

- All operations use `npx` — no local ai-agent clone assumed
- Always run `npx skills` commands from the project root (absolute path), because `npx skills add` installs to `.agents/skills/` relative to CWD
- No agent-specific tool names — uses `gh`, `curl`, `sha256sum`, `readlink` (standard CLI tools)
- Compatible with bash and zsh
- Remote repo path `p2tree/ai-agent` is the default; allow override if user has a fork
- Rate limit awareness: curl to GitHub raw has 60 req/hr unauthenticated; batch skill fetches efficiently

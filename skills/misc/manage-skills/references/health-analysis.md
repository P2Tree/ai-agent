# Health Analysis — Detailed Criteria

## Structural Validation

For each installed skill, check SKILL.md:

1. SKILL.md exists with valid frontmatter (name + description)
2. description contains "Use when" trigger
3. description is under 1024 characters
4. SKILL.md is under 150 lines
5. No secrets (password, secret, api.key, token, AKIA, BEGIN RSA)
6. No absolute home paths (/home/...)

## Source Detection

For each installed skill, determine its origin:

| Method | Signal | Confidence |
|--------|--------|------------|
| skill-lock.json | Entry with `source` field | Definitive |
| Symlink target | Path contains identifiable repo name | High |
| No tracking | No lock entry, no symlink | Unknown |

## Installation Integrity

| Check | Condition | Severity |
|-------|-----------|----------|
| Broken symlink | Symlink target doesn't exist | Error |
| Moved target | Symlink points to old bucket path (e.g., engineering/ → productivity/) | Warning |
| Ghost entry | skill-lock.json entry where directory no longer exists | Warning |
| Orphaned skill | Not in skill-lock.json, not a symlink to known source | Advisory |
| Duplicate scope | Same skill in both global and project directories | Warning |

## Overlap Detection

Identify skill pairs that may have functional overlap by examining:

- **Trigger conditions**: If two skills share "Use when" conditions, they may confuse agents
- **Problem domain**: If two skills address the same problem (e.g., debugging, testing), they may be candidates for merging

Present overlapping pairs with both descriptions so the user can judge.

**Not a merge recommendation** — just an observation. The user decides.

## Content Quality Flags

| Flag | Condition | Severity |
|------|-----------|----------|
| Verbose | SKILL.md over 150 lines | Warning |
| Missing trigger | No "Use when" in description | Error |
| Too thin | SKILL.md under 10 lines (might not need to be a skill) | Advisory |
| No structure | SKILL.md has only a prompt, no sections | Advisory |

## Staleness Check

For npx-installed skills tracked in skill-lock.json:

1. Check `updatedAt` timestamp — if over 30 days old, suggest running `npx skills update`
2. For definitive staleness, compare local SKILL.md SHA256 against remote `raw.githubusercontent.com/p2tree/ai-agent/main/skills/{bucket}/{name}/SKILL.md`

Do NOT use `skill-lock.json` `skillFolderHash` for staleness detection — it records install-time integrity state, not freshness vs remote, and produces false positives.

## Output Format

```
=== Health Analysis ===

Source Distribution:
  ai-agent (npx): X skills
  ai-agent (symlink): Y skills
  third-party: Z skills
  unknown source: W skills

Installation Issues:
  skill-name: broken symlink → /old/path
  skill-name: moved target (productivity/ → now in engineering/)
  skill-name: ghost entry in skill-lock.json

Structural Issues:
  skill-name: [FAIL reason]

Overlap Pairs:
  skill-a ↔ skill-b: both triggered by "debugging"

Quality Flags:
  skill-name: verbose (180 lines, limit 150)
  skill-name: missing trigger condition

Staleness:
  skill-name: not updated since 2026-03-01 (72 days)

Summary: X errors, Y warnings, Z advisory
```

# Health Analysis — Detailed Criteria

## Structural Validation

Run `scripts/validate-skill.sh <skill-dir>` for each installed skill. The script checks:

1. SKILL.md exists with valid frontmatter (name + description)
2. description contains "Use when" trigger
3. description is under 1024 characters
4. SKILL.md is under 150 lines
5. No secrets (password, secret, api.key, token, AKIA, BEGIN RSA)
6. No absolute home paths (/home/...)

## Overlap Detection

Identify skill pairs that may have functional overlap by examining:

- **Trigger conditions**: If two skills share "Use when" conditions, they may confuse agents
- **Problem domain**: If two skills address the same problem (e.g., debugging, testing), they may be candidates for merging

Present overlapping pairs with both descriptions so the user can judge.

**Not a merge recommendation** — just an observation. The user decides.

## Health Flags

| Flag | Condition | Severity |
|------|-----------|----------|
| Verbose | SKILL.md over 150 lines | Warning |
| Missing trigger | No "Use when" in description | Error |
| Too thin | SKILL.md under 10 lines (might not need to be a skill) | Advisory |
| No structure | SKILL.md has only a prompt, no sections | Advisory |
| Broken symlink | Symlink target doesn't exist | Error |
| Stale link | Symlink points to old/removed skill path | Warning |

## Output Format

```
=== Health Analysis ===

Structural Issues:
  skill-name: [FAIL reason]

Overlap Pairs:
  skill-a ↔ skill-b: both triggered by "debugging"

Health Flags:
  skill-name: verbose (180 lines, limit 150)
  skill-name: missing trigger condition

Summary: X issues, Y warnings, Z advisory
```

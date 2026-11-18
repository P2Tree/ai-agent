---
name: update-skills
description: Check third-party upstream skills for changes and decide whether to sync, adapt, merge, deprecate, introduce, or recommend upstream. Use when maintaining skill freshness, auditing drift against upstream sources, or evolving the skill system after upstream releases.
disable-model-invocation: true
---

# Update Skills

Compare local skills against upstream, then decide what the system should look like. Never copy blindly: an upstream change is an input to a decision, not an instruction.

See [evolution playbook](references/evolution-playbook.md) for the full decision framework, procedures, and examples.

## Maintenance Philosophy

- A skill earns its place only if it carries a **decision**, a distinct capability, or a reusable discipline.
- Keep the smallest decision-carrying set. Merge one-paragraph rules into existing skills; recommend heavy upstream skills instead of bundling them.
- Adapt to repo conventions: platform-agnostic, ≤150 lines, `Use when` description, references for depth, no `license` frontmatter.
- Record every removal/merge in `skills/deprecated/README.md`; add `参考：` to the destination bucket README.
- Update the whole system, not just `SKILL.md`: root/bucket READMEs, registries, playbook, architecture doc, evolution record.
- Verify with `validate-skill.sh`, `ci-validate-skills.sh`, link checks, and registry consistency.

## Decision Tests

Before keeping, adding, merging, or removing a skill:

1. What decision does it carry?
2. Does it have a distinct trigger?
3. Is it a rule or a multi-step process?
4. Does it need an independent context?
5. Does it work in single-agent, cross-environment, multi-session reality?
6. What is the lifecycle of its artifacts?
7. Does it duplicate upstream?
8. Would removing it lose decision capability?

## Classify Before You Copy

| Situation | Action |
|---|---|
| Existing skill has upstream content updates | **Sync / adapt** |
| New upstream skill overlaps an existing local skill | **Merge** into the local skill; move the upstream-only copy to `deprecated/` |
| New upstream skill has a distinct trigger and capability | **Introduce** via `skills/draft/` |
| Local skill no longer earns its place | **Deprecate / remove** |
| Large, fast-changing official skill | **Recommend upstream**, do not bundle |
| Pure wording/format drift | **Skip** |

## Process

### 1. Locate Upstream Sources

Read the `## References` section in `README.md` and `README.zh.md`; build `source-key → repo-url`. Also include sources named in bucket READMEs even if absent from the root list.

### 2. Prepare Upstream Repos

Use `/tmp/ai-agent-upstream/<owner-repo>/`. Pull if present, clone if not; use `--depth 1`. Mark a source unavailable on failure and continue.

### 3. Build the Local → Upstream Map

Scan bucket READMEs for `参考：` lines. Map `local-skill → source(s) → upstream path`. Include `draft/` skills. Merged sources map to multiple upstreams. If a source is missing or renamed, record it as a finding.

### 4. Compare

For each pair, read both `SKILL.md` files in full and compare:

- line counts and heading differences;
- substantial content changes (new/removed steps, rules, gotchas, verification);
- references/scripts/License changes;
- trigger/description changes.

Ignore whitespace and pure wording. Classify **MAJOR / MINOR / NONE**. Also note upstream skills not represented locally and local skills whose upstream disappeared.

### 5. Report

Use the compact format in [drift detection](references/drift-detection.md) or inline. Show only MAJOR/MINOR. Include:

- drift level and key changes;
- upstream additions worth considering;
- merge/removal candidates, with the decision-test reason;
- unavailable sources.

### 6. Confirm and Apply

Ask which changes to apply: all MAJOR, MAJOR+MINOR, choose individually, or none. Then apply the matching action:

- **Sync/adapt** — rewrite to repo conventions; update references.
- **Merge** — move the upstream-only skill to `skills/deprecated/<name>/`; document reason and destination in the deprecated README; add `参考` to the destination bucket README; add explicit call points in the destination skill.
- **Introduce** — create in `skills/draft/`, validate, move to a bucket.
- **Deprecate/remove** — move to `deprecated/` (or delete if no content value); document why.
- **Recommend upstream** — add to `docs/external-skills.md`, `manage-skills/references/recommended-upstream.md`, and the root README; do not add to registries.

### 7. Update the System

Check every affected surface:

- `README.md` / `README.zh.md`
- destination bucket README
- `.claude-plugin/plugin.json`
- `.agents/skills.json`
- `docs/skill-playbook.md`
- `docs/architecture_design.md` if the inventory changed
- `docs/system-evolution.md`
- `skills/deprecated/README.md` for removals/merges
- `docs/external-skills.md` for upstream recommendations

### 8. Verify

- `scripts/validate-skill.sh <skill>` for each modified skill
- `bash scripts/ci-validate-skills.sh all`
- SKILL.md ≤150 lines; description has `Use when`; no `license` frontmatter
- No platform-specific tool names; no cross-skill file paths
- Relative links resolve; registry matches actual formal skills
- If a description changed, test 3–5 trigger prompts and adjust wording

## Notes

- This skill never auto-updates; user confirmation is required.
- Merged skills are compared against all upstreams.
- Upstream repos are cached in `/tmp/ai-agent-upstream/`.
- Do not push or commit unless the user asks.
- Compatible with bash and zsh.

## References

- [Evolution playbook](references/evolution-playbook.md) — decision tests, merge/introduce/recommend procedures, examples, anti-patterns
- [Drift detection](references/drift-detection.md) — comparison algorithm

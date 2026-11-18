# Evolution Playbook

How to evolve this skill repository, not just copy upstream changes. Use with `update-skills`.

## Core idea

AI makes producing documents and code cheap. The scarce resources are **decisions, review, and maintenance attention**. A skill earns its place only if it carries a decision, a distinct capability, or a reusable discipline. Every extra skill adds trigger ambiguity, context load, and sync cost.

Keep the **smallest set of decision-carrying artifacts**. A document or skill that nobody reads or updates is negative value, even if it is well written.

## Decision tests

Before adding, keeping, merging, or removing a skill, ask:

1. **What decision does it carry?** If you cannot name one, do not add it.
2. **Does it have a distinct trigger?** If it overlaps an existing skill, merge first.
3. **Is it a rule or a process?** A one- or two-line rule belongs in `CLAUDE.md` or an existing skill's reference.
4. **Does it need an independent context?** Reviews and research do; rules and references usually do not.
5. **Does it work in single-agent, cross-environment, multi-session reality?** If only in ideal conditions, write the HITL variant or mark it conditional.
6. **What is the artifact lifecycle?** Historical record, living doc, or temporary working file? State how it is updated and retired.
7. **Does it duplicate upstream?** If upstream has the same capability, evaluate merging or recommending upstream instead of bundling.
8. **Would removing it lose decision capability?** If not, remove it; if yes, keep it and state its boundary.

## Classification

| Situation | Action | What to write |
|---|---|---|
| Existing skill has upstream content updates | **Sync / adapt** | Rewrite the local skill to repo conventions; update references |
| New upstream skill overlaps an existing local skill | **Merge** | Fold useful content into the local skill; move the upstream-only skill to `deprecated/` |
| New upstream skill has a distinct trigger and capability | **Introduce** | Draft in `skills/draft/`, validate, graduate to a bucket |
| Local skill no longer earns its place | **Deprecate / remove** | Move to `deprecated/` (or delete if no content value); document why |
| Large, fast-changing official skill (documents, design packs) | **Recommend upstream** | Add to `docs/external-skills.md`, `manage-skills` recommended list, and root README |
| Pure wording/format drift | **Skip** | No change |

## Examples from this repo

- `tdd` overlapped `diagnose` on bug fixes and `writing-plans`/`executing-plans` on test-first. Its rules were merged into those skills, then it moved to `deprecated/tdd/`.
- `init-agent-environment` generated config files nobody maintained. It was deleted; issue/label logic moved into `triage`, GLOSSARY/ADR conventions into `grill-me`.
- `pdf`/`docx`/`pptx`/`xlsx` are large, fast-changing official skills. They are no longer bundled; users install them from `anthropics/skills`.
- `ui-ux-pro-max`, `impeccable`, and `web-design-guidelines` are recommended upstream, not bundled, for the same size/churn reasons.
- `verification-before-completion` was a rule, not a process. It was folded into `configs/project/CLAUDE.md`, `executing-plans`, and `finish-work`.
- `domain-modeling` was a short discipline. It was folded into `grill-me/references/domain-model.md`.

## Merge procedure

When folding an upstream skill into an existing one:

1. Move the upstream-only skill directory to `skills/deprecated/<name>/`.
2. In `skills/deprecated/README.md`, record:
   - status: deleted / merged / renamed;
   - reason;
   - destination skill(s).
3. Add a `参考：` line to the destination bucket README, naming the upstream source.
4. Add explicit call points in the destination skill at the moment the behavior is needed, not just a vague "use the vocabulary".
5. Remove the old skill from registries and root/bucket READMEs.
6. Update `docs/system-evolution.md`.

## Introduce procedure

1. Create in `skills/draft/<name>/`.
2. Validate with `scripts/validate-skill.sh`.
3. Move to the chosen bucket.
4. Add to `.claude-plugin/plugin.json` and `.agents/skills.json`.
5. Add to root `README.md` and `README.zh.md`, plus the bucket README.
6. Add upstream attribution with `参考：`.
7. Update `docs/skill-playbook.md` if the skill affects a workflow.
8. Update `docs/system-evolution.md` with the rationale.

## Recommend-upstream procedure

1. Add the skill and install method to `docs/external-skills.md`.
2. Add it to `skills/misc/manage-skills/references/recommended-upstream.md`, marking it `npx` or `manual`.
3. Add it to the root README "Optional upstream skills" section.
4. Do not add it to `plugin.json` / `skills.json` / bucket READMEs.
5. State why it is not bundled (size, churn, runtime dependency, customization cost).

## System update checklist

After any non-trivial change, check:

- [ ] `README.md` and `README.zh.md`
- [ ] destination bucket README
- [ ] `.claude-plugin/plugin.json`
- [ ] `.agents/skills.json`
- [ ] `docs/skill-playbook.md`
- [ ] `docs/architecture_design.md` if the inventory changed
- [ ] `docs/system-evolution.md`
- [ ] `skills/deprecated/README.md` for removals/merges
- [ ] `docs/external-skills.md` for upstream recommendations
- [ ] `skills/misc/manage-skills/references/recommended-upstream.md`

## Verification

- `scripts/validate-skill.sh <skill>` for each modified skill
- `bash scripts/ci-validate-skills.sh all`
- SKILL.md ≤ 150 lines; description has a `Use when` trigger
- No `license` frontmatter; no platform-specific tool names
- Relative links resolve; avoid cross-skill file paths (skills install independently)
- Registry matches actual formal skills
- If a description changed, test 3–5 trigger prompts and adjust wording
- Run the link checker over `skills/` and the changed docs

## Documentation lifecycle

- Specs and plans are historical decision records: add `Status` and `Date`; do not treat old ones as current truth.
- README, CLAUDE.md/AGENTS.md, architecture docs, and user guides are living docs: update them when the behavior changes.
- `GLOSSARY.md` and ADRs are optional and lazily created; do not generate them up front.

## Anti-patterns

- Copying an upstream skill verbatim without asking whether it should exist.
- Keeping a skill because "it might be useful" while nobody invokes it.
- Duplicating vocabulary across skills instead of sharing one reference skill.
- Adding a new skill for a one-paragraph rule.
- Updating the skill but forgetting registries, READMEs, playbook, or deprecated notes.
- Cross-skill file links that break when a user installs only one skill.
- Making a heavy external skill mandatory for every review.

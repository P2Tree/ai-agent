# The skills of a truly AI-oriented engineer

An open-source skill repository for AI coding assistants. Collects, curates, and maintains agent skills and configurations across multiple platforms.

[中文文档](./README.zh.md)

---

## How It Works

Each skill is a self-contained directory with a `SKILL.md` entry point that the agent loads on demand:

```
skill-name/
├── SKILL.md           # Entry point — what to do, step-by-step
├── references/        # Deep-dive details (loaded progressively)
├── scripts/           # Deterministic scripts (formatting, validation, scaffolding)
└── examples/          # Usage examples
```

**Progressive disclosure** — `SKILL.md` stays under 150 lines. When the agent needs more context, it reads from `references/`. This keeps token usage low by default while remaining fully detailed when needed.

**Platform-agnostic content** — skill instructions avoid platform-specific tool names. Platform mappings live in `references/platform-mapping.md`, so the same skill works across Claude Code, Cursor, Codex, Gemini, and others.

## Installation

Run:

```bash
npx skills@latest add p2tree/ai-agent
```

Select the skills you want. That's all.

Then launch your agent console and run the `manage-skills` skill for the interactive skill management.

Configs files need to transfer to your system or project path and maintain manually.

## From Skills to Squad

Individual skills are powerful, but the real value comes from combining them into a workflow. A fuzzy idea becomes a shipped feature when *brainstorming* explores it, *grill-me* stress-tests the decisions, *brainstorming* records the spec, then *writing-plans*, *executing-plans*, *code-review*, and *finish-work* take it to a reviewed commit and PR. A bug is triaged with *triage*, investigated with *diagnose*, reviewed, and finished.

Each skill plays a role in your virtual dev team — product manager, architect, debug specialist, reviewer. The [**Skill Playbook**](./docs/skill-playbook.md) maps out 11 common work scenarios (idea → ship, bug fixing, onboarding, refactoring, pre-research, frontend dev, documentation, …), showing exactly which skills to call, in what order, and how they hand off to each other.

**Read the [Skill Playbook](./docs/skill-playbook.md) →**

## What's Inside

### Configs

| Config | Description |
|--------|-------------|
| [project/CLAUDE.md](./configs/project/CLAUDE.md) | Project-level agent config template — coding principles, workflow rules, anti-patterns |
| [user/CLAUDE.md](./configs/user/CLAUDE.md) | User-level agent config template — personal preferences, language, role context |

Copy these templates to your project root (`CLAUDE.md`) or home directory (`~/.claude/CLAUDE.md`) and customize as needed.

### Engineering

| Skill | Description |
|-------|-------------|
| [codebase-design](./skills/engineering/codebase-design/SKILL.md) | Shared deep-module reference — interface, depth, seam, adapter, leverage, locality |
| [diagnose](./skills/engineering/diagnose/SKILL.md) | Debugging cycle: red-capable feedback loop → reproduce + minimise → hypothesize → instrument → fix → clean |
| [code-review](./skills/engineering/code-review/SKILL.md) | Code review discipline — calibrated confidence, read-only review, spec-as-vision, receiving feedback |
| [improve-architecture](./skills/engineering/improve-architecture/SKILL.md) | Scope-first scan for architectural friction, ranked deep-module candidates |
| [frontend-design](./skills/engineering/frontend-design/SKILL.md) | Subject-grounded, distinctive frontend design that avoids generated-page defaults |

### Productivity

| Skill | Description |
|-------|-------------|
| [brainstorming](./skills/productivity/brainstorming/SKILL.md) | Context-first design dialogue — playback, approaches, scaled design doc, builder check |
| [prototype](./skills/productivity/prototype/SKILL.md) | Throwaway prototypes that answer a question, kept on a throwaway branch as primary source |
| [grill-me](./skills/productivity/grill-me/SKILL.md) | Frontier-based rounds of questions to pressure-test your plan or design |
| [research](./skills/productivity/research/SKILL.md) | Delegate reading to a background agent; capture cited findings in a Markdown file |

### Composition

| Skill | Description |
|-------|-------------|
| [coauthoring](./skills/composition/coauthoring/SKILL.md) | Iterative human-AI co-authoring for prose content (blogs, articles, essays) |
| [work-report](./skills/composition/work-report/SKILL.md) | Structured work reports for Chinese corporate conventions (daily through promotion) |
| [arch-doc](./skills/composition/arch-doc/SKILL.md) | Systematic architecture design documentation — create, update, or align arch docs from code |
| [humanizer](./skills/composition/humanizer/SKILL.md) | Remove AI writing patterns with fidelity constraints — 31 patterns, examples, and preserve boundaries |

### Career

| Skill | Description |
|-------|-------------|
| [pre-view](./skills/career/pre-view/SKILL.md) | Simulate realistic multi-round job interviews with diverse interviewer personas - technical, managerial, leadership rounds with pre-round evaluations and a final objective report |
| [project-highlight](./skills/career/project-highlight/SKILL.md) | Extract key contributions from git repos and format as project highlights — resume, interview, performance review, general intro |

### Workflow

| Skill | Description |
|-------|-------------|
| [writing-plans](./skills/workflow/writing-plans/SKILL.md) | Right-sized tasks with Global Constraints, Review Focus, Interfaces, and execution handoff |
| [executing-plans](./skills/workflow/executing-plans/SKILL.md) | Ledger-backed execution with rulings, completion contracts, and a final review pass |
| [finish-work](./skills/workflow/finish-work/SKILL.md) | Verify tests → summarize → commit → optional PR → update the issue |
| [writing-prd](./skills/workflow/writing-prd/SKILL.md) | Synthesize conversation context into a PRD, choosing test seams first |
| [decomposing-issues](./skills/workflow/decomposing-issues/SKILL.md) | Split PRDs into vertically-sliced, independently grabbable issues |
| [triage](./skills/workflow/triage/SKILL.md) | Issue and external-PR triage — redundancy checks, verification, briefs, out-of-scope KB |
| [retro](./skills/workflow/retro/SKILL.md) | Session retrospective on the agent's environment — navigation, checks, standards, tooling |

### Misc

| Skill | Description |
|-------|-------------|
| [manage-skills](./skills/misc/manage-skills/SKILL.md) | Browse, install, audit, and manage skills from any source |
| [find-skills](./skills/misc/find-skills/SKILL.md) | Discover, verify, install, and update skills from the open ecosystem |
| [create-skill](./skills/misc/create-skill/SKILL.md) | Create, improve, and evaluate skills with writing-for-agents principles |

### Optional Upstream Skills

These are not bundled. Install each from its upstream source when you need it.

| Skill | Covers | Install |
|-------|--------|---------|
| `pdf` | Read, extract, merge, split, rotate, watermark, encrypt, OCR, forms | `npx skills add anthropics/skills@pdf` |
| `docx` | Create, read, edit, tracked changes, comments | `npx skills add anthropics/skills@docx` |
| `pptx` | Decks, templates, editing, QA | `npx skills add anthropics/skills@pptx` |
| `xlsx` | Formulas, recalculation, financial models | `npx skills add anthropics/skills@xlsx` |

Document skills are from [anthropics/skills](https://github.com/anthropics/skills).

Claude Code plugin route: `/plugin marketplace add anthropics/skills`, then install `document-skills`.

Frontend and design:

| Skill | Covers | Install |
|-------|--------|---------|
| `ui-ux-pro-max` | Design system, styles, palettes, font pairings, UX rules, stack guidance | manual CLI — see docs |
| `impeccable` | Critique, audit, polish, redesign, AI-slop detection | manual CLI — see docs |
| `web-design-guidelines` | Web UI review against accessibility and UX guidelines | `npx skills add vercel-labs/agent-skills@web-design-guidelines -g -y` |

See [Optional upstream skills](./docs/external-skills.md) for details. The `manage-skills` skill also offers a "recommended upstream skills" install option.

## Auto-generated Paths

Skills write documents into the target repo following a unified convention. Optional domain and issue-tracker files are created lazily when a skill actually needs them.

```
<target-repo>/
├── GLOSSARY.md                             # Domain glossary
├── docs/
│   ├── specs/                              # Design specs
│   │   └── YYYY-MM-DD-<design_name>.md
│   ├── plans/                              # Implementation plans
│   │   └── YYYY-MM-DD-<feature_name>.md
│   └── adr/                                # Architecture decision records
│       └── <arch_design_topic_name>.md
```

| Path | Purpose |
|------------------|---------|
| `GLOSSARY.md` | Domain vocabulary — keeps skill output consistent with project terminology |
| `docs/specs/` | Validated design specs before implementation |
| `docs/plans/` | Step-by-step implementation plans |
| `docs/adr/` | Architecture decision records |

## One-time Setup Skills

Most skills trigger on demand; one is a one-time setup:

| Skill | Scope | What persists |
|-------|-------|---------------|
| `manage-skills` | Per system | Manages skills in your agent's skill directory; re-run when you switch machines |

## Design Philosophy

**One concept, one skill.** No duplicates. When multiple sources cover the same ground, we merge them into a single, well-maintained skill rather than keeping separate versions.

**Curated, not aggregated.** Skills are absorbed from upstream sources, then rewritten to match our style, structure, and terminology. We understand the intent before integrating — never copy-paste.

**Progressive disclosure by default.** `SKILL.md` stays concise; details live in `references/`. Agents load only what they need, keeping context windows clean.

**Platform-agnostic content.** Skill instructions avoid hardcoding any agent's tool names or UI commands. Platform-specific mappings are separated into `references/platform-mapping.md`.

**Quality gate before publish.** Every skill goes through a three-layer check — structural completeness (automated), content quality (manual), and actual verification (manual). Skills stay in `draft/` until they pass all three.

## Evolution Checklist

Before adding or changing a skill, ask:

1. **What decision does it carry?** If you can't name one, don't add it.
2. **Does it have a distinct trigger?** If it overlaps an existing skill, merge first.
3. **Is it a rule or a multi-step process?** A one- or two-line rule belongs in `CLAUDE.md` or an existing skill's reference, not a new skill.
4. **Does it need an independent context?** Review skills do; rule skills don't.
5. **Does it work for a single agent, cross-environment, multi-session reality?** If it only works in ideal conditions, document the HITL variant or mark it conditional.
6. **What is the lifecycle of its artifacts?** Historical record, living doc, or temporary working file? State how it is updated and retired.
7. **Does it duplicate upstream?** If upstream has the same capability, evaluate merging; don't add a duplicate for completeness.
8. **Would removing it lose decision capability?** If not, remove it; if yes, keep it and state its boundary.

## Maintenance Conventions

- When merging or removing an upstream skill, record the reason and destination in `skills/deprecated/README.md`.
- Add a `参考:` (reference) line to the destination bucket README when content is folded in (for example, `writing-plans` and `executing-plans` reference `tdd`).
- When the default workflow changes, update `docs/skill-playbook.md` and `docs/system-evolution.md`.
- When conventions change (e.g. `GLOSSARY.md`, `finish-work`), update the root READMEs, bucket READMEs, and registries together.

## Tradeoff Notes

**Single-source constraint.** We intentionally avoid third-party skill plugins. This means you get one coherent skill set with no conflicts, but you also can't mix in skills from other ecosystems without manual integration. If a third-party skill does something better, we absorb and rewrite it here.

**150-line SKILL.md limit.** Keeps token overhead low for the common case, but means some skills require a second read into `references/`. This is by design — the agent pays for context only when it needs depth.

**Shell compatibility.** All shell scripts target both bash and zsh (no bash-only syntax). This avoids platform surprises but rules out some bash-specific conveniences.

**No auto-sync.** Upstream changes are evaluated and merged manually on a monthly cadence. This ensures quality and intent alignment, but means we may lag behind upstream by up to a month.

**Selective inclusion.** Popular community skills are welcome, but some are not included because their core value depends on a specific platform or service, which conflicts with our platform-agnostic principle. If you need an external skill not covered here, use the [find-skills](./skills/misc/find-skills/SKILL.md) skill to search the open ecosystem.

## Repository Structure

```
ai-agent/
├── skills/                # All skills, organized by bucket
│   ├── engineering/       # Software development
│   ├── productivity/      # Efficiency (non-coding)
│   ├── composition/       # Content generation
│   ├── career/            # Career development
│   ├── workflow/          # Git, Jira, deployment, migration
│   ├── misc/              # Everything else
│   ├── draft/             # In development (not published)
│   └── deprecated/        # Retired (not published)
├── configs/               # Configuration templates and backups
├── hooks/                 # Agent hook scripts
├── docs/                  # Architecture design, skill-writing guide
├── scripts/               # Repository tooling (validation, etc.)
├── .claude-plugin/        # Claude Code plugin manifest
└── .agents/               # OpenAI Agents SDK / Codex manifest
```

## Contributing

1. Create your skill in `skills/draft/`
2. Run `scripts/validate-skill.sh` to check structural completeness
3. Manually verify the skill works end-to-end on your target platform
4. Submit a PR — the skill will be reviewed and moved to the appropriate bucket

See [Skill Writing Guide](./docs/skill-writing-guide.md) for detailed authoring instructions.

## Documentation

- [Skill 编队手册](./docs/skill-playbook.md) — 不同工作场景下如何将 skill 编组成队、协同作战
- [Architecture Design](./docs/architecture_design.md)
- [Skill Writing Guide](./docs/skill-writing-guide.md)

## References

- [anthropics agent skills](https://github.com/anthropics/skills)
- [superpowers skills](https://github.com/obra/superpowers)
- [andrej karpathy skills](https://github.com/forrestchang/andrej-karpathy-skills)
- [mattpocock skills](https://github.com/mattpocock/skills)
- [vercel-labs skills](https://github.com/vercel-labs/skills)
- [op7418 Humanizer-zh](https://github.com/op7418/Humanizer-zh)
- [wshobson agents](https://github.com/wshobson/agents)

## License

[MIT](./LICENSE)

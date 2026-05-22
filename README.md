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

Individual skills are powerful, but the real value comes from combining them into a workflow. A fuzzy idea becomes a shipped feature when *brainstorming* hands off to *writing-prd*, which feeds *decomposing-issues*, then *writing-plans*, *executing-plans*, *code-review*, and *finishing-branch*. A bug gets fixed when *triage* routes it to *diagnose*, which leads to *tdd* and *code-review*.

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
| [tdd](./skills/engineering/tdd/SKILL.md) | Red-green-refactor TDD loop with vertical slicing |
| [diagnose](./skills/engineering/diagnose/SKILL.md) | Six-stage debugging cycle: feedback loop → reproduce → hypothesize → instrument → fix → clean |
| [code-review](./skills/engineering/code-review/SKILL.md) | Code review discipline — calibrate confidence, review changes not authors |
| [improve-architecture](./skills/engineering/improve-architecture/SKILL.md) | Scan for architectural friction, suggest deep-module refactoring |
| [frontend-design](./skills/engineering/frontend-design/SKILL.md) | Create distinctive, production-grade frontends |

### Productivity

| Skill | Description |
|-------|-------------|
| [brainstorming](./skills/productivity/brainstorming/SKILL.md) | Collaborative design gating — align on requirements before coding |
| [zoom-out](./skills/productivity/zoom-out/SKILL.md) | Zoom out to see module relationships and call chains |
| [prototype](./skills/productivity/prototype/SKILL.md) | Disposable prototypes to validate designs before committing |
| [caveman](./skills/productivity/caveman/SKILL.md) | Ultra-compressed communication — fewer tokens, faster on slow networks and weak local models |
| [grill-me](./skills/productivity/grill-me/SKILL.md) | Relentless Q&A to pressure-test your plan or design |

### Composition

| Skill | Description |
|-------|-------------|
| [coauthoring](./skills/composition/coauthoring/SKILL.md) | Iterative human-AI co-authoring for prose content (blogs, articles, essays) |
| [work-report](./skills/composition/work-report/SKILL.md) | Structured work reports for Chinese corporate conventions (daily through promotion) |
| [arch-doc](./skills/composition/arch-doc/SKILL.md) | Systematic architecture design documentation — create, update, or align arch docs from code |
| [pdf](./skills/composition/pdf/SKILL.md) | PDF file processing — read, extract, merge, split, rotate, watermark, encrypt, OCR, form filling |
| [docx](./skills/composition/docx/SKILL.md) | Word document processing — create, read, edit, format .docx files |
| [pptx](./skills/composition/pptx/SKILL.md) | PowerPoint presentation processing — create, read, edit, split, merge .pptx files |
| [xlsx](./skills/composition/xlsx/SKILL.md) | Spreadsheet processing — read, create, edit, analyze .xlsx/.xlsm/.csv/.tsv files |

### Workflow

| Skill | Description |
|-------|-------------|
| [writing-plans](./skills/workflow/writing-plans/SKILL.md) | Break specs into bite-sized implementation plans |
| [executing-plans](./skills/workflow/executing-plans/SKILL.md) | Step-by-step plan execution with verification gates |
| [finishing-branch](./skills/workflow/finishing-branch/SKILL.md) | Complete a dev branch: verify → choose action → clean up |
| [writing-prd](./skills/workflow/writing-prd/SKILL.md) | Synthesize conversation context into a PRD |
| [decomposing-issues](./skills/workflow/decomposing-issues/SKILL.md) | Split PRDs into vertically-sliced, independently grabbable issues |
| [triage](./skills/workflow/triage/SKILL.md) | State-machine issue triage with label and status workflows |
| [init-agent-environment](./skills/workflow/init-agent-environment/SKILL.md) | Bootstrap agent workspace — issue tracker, labels, domain docs |

### Misc

| Skill | Description |
|-------|-------------|
| [manage-skills](./skills/misc/manage-skills/SKILL.md) | Browse, install, audit, and manage skills from any source |
| [find-skills](./skills/misc/find-skills/SKILL.md) | Discover and install skills from the open ecosystem |
| [create-skill](./skills/misc/create-skill/SKILL.md) | Create, improve, and evaluate skills |

## Auto-generated Paths

Skills write documents into the target repo following a unified convention. The `init-agent-environment` skill bootstraps these paths when setting up a new repo.

```
<target-repo>/
├── CONTEXT.md                              # Domain glossary
├── docs/
│   ├── specs/                              # Design specs
│   │   └── YYYY-MM-DD-<design_name>.md
│   ├── plans/                              # Implementation plans
│   │   └── YYYY-MM-DD-<feature_name>.md
│   ├── prd/                                # Product requirement docs
│   │   └── <prd_topic_name>.md
│   ├── issues/                             # Issue files
│   │   └── <NN>-<issue_description>.md     # NN = zero-padded sequential ID
│   ├── adr/                                # Architecture decision records
│   │   └── <arch_design_topic_name>.md
│   └── agents/                             # Agent runtime config
│       ├── issue-tracker.md
│       ├── triage-labels.md
│       └── domain.md
```

| Path | Purpose |
|------------------|---------|
| `CONTEXT.md` | Domain vocabulary — keeps skill output consistent with project terminology |
| `docs/specs/` | Validated design specs before implementation |
| `docs/plans/` | Step-by-step implementation plans |
| `docs/prd/` |  Product requirement documents |
| `docs/issues/` | Individual issue files; wontfix rejections get a `-wontfix` suffix |
| `docs/adr/` | Architecture decision records |
| `docs/agents/` | Agent environment configuration consumed by all workflow skills |

**Note:** `docs/agents/` is agent runtime config, not design documentation.

## One-time Setup Skills

Most skills trigger on demand, but a few are one-time setup:

| Skill | Scope | What persists |
|-------|-------|---------------|
| `manage-skills` | Per system | Manages skills in your agent's skill directory; re-run when you switch machines |
| `init-agent-environment` | Per repo | Agent context block in CLAUDE.md/AGENTS.md + `docs/agents/` layout; re-run for each new repo |

## Design Philosophy

**One concept, one skill.** No duplicates. When multiple sources cover the same ground, we merge them into a single, well-maintained skill rather than keeping separate versions.

**Curated, not aggregated.** Skills are absorbed from upstream sources, then rewritten to match our style, structure, and terminology. We understand the intent before integrating — never copy-paste.

**Progressive disclosure by default.** `SKILL.md` stays concise; details live in `references/`. Agents load only what they need, keeping context windows clean.

**Platform-agnostic content.** Skill instructions avoid hardcoding any agent's tool names or UI commands. Platform-specific mappings are separated into `references/platform-mapping.md`.

**Quality gate before publish.** Every skill goes through a three-layer check — structural completeness (automated), content quality (manual), and actual verification (manual). Skills stay in `draft/` until they pass all three.

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

## License

[MIT](./LICENSE)

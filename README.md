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

### Option A: Interactive Install (Recommended)

Use the built-in `install-skills` skill to selectively symlink skills into your agent's skill directory. The interactive prompts walk you through each skill — confirm or skip.

### Option B: Use as a Plugin

For **Claude Code**, add the repository as a plugin in your project or user settings:

```json
{
  "plugins": ["/path/to/ai-agent"]
}
```

For **OpenAI Codex / Agents SDK**, point to the `.agents/skills.json` manifest.

### Option C: Manual Symlink

```bash
# Link individual skills into your agent's skill directory
ln -s /path/to/ai-agent/skills/engineering/tdd ~/.claude/skills/tdd
```

## What's Inside

### Engineering

| Skill | Description |
|-------|-------------|
| [tdd](./skills/engineering/tdd/SKILL.md) | Red-green-refactor TDD loop with vertical slicing |
| [diagnose](./skills/engineering/diagnose/SKILL.md) | Six-stage debugging cycle: feedback loop → reproduce → hypothesize → instrument → fix → clean |
| [code-review](./skills/engineering/code-review/SKILL.md) | Code review discipline — calibrate confidence, review changes not authors |
| [improve-architecture](./skills/engineering/improve-architecture/SKILL.md) | Scan for architectural friction, suggest deep-module refactoring |
| [frontend-design](./skills/engineering/frontend-design/SKILL.md) | Create distinctive, production-grade frontends |
| [code-guidelines](./skills/engineering/code-guidelines/SKILL.md) | Behavioral guidelines to reduce common LLM coding errors |

### Productivity

| Skill | Description |
|-------|-------------|
| [brainstorming](./skills/productivity/brainstorming/SKILL.md) | Collaborative design gating — align on requirements before coding |
| [zoom-out](./skills/productivity/zoom-out/SKILL.md) | Zoom out to see module relationships and call chains |
| [prototype](./skills/productivity/prototype/SKILL.md) | Disposable prototypes to validate designs before committing |
| [caveman](./skills/productivity/caveman/SKILL.md) | Ultra-compressed communication — ~75% token reduction |
| [grill-me](./skills/productivity/grill-me/SKILL.md) | Relentless Q&A to pressure-test your plan or design |

### Composition

| Skill | Description |
|-------|-------------|
| [article-series-writer](./skills/composition/article-series-writer/SKILL.md) | Parallel multi-article writing with auto-review loop |

### Workflow

| Skill | Description |
|-------|-------------|
| [git-guardrails](./skills/workflow/git-guardrails/SKILL.md) | Hook-based protection against dangerous git operations |
| [bash-to-zsh-converter](./skills/workflow/bash-to-zsh-converter/SKILL.md) | Translate bash scripts to zsh-compatible syntax |
| [writing-plans](./skills/workflow/writing-plans/SKILL.md) | Break specs into bite-sized implementation plans |
| [executing-plans](./skills/workflow/executing-plans/SKILL.md) | Step-by-step plan execution with verification gates |
| [dispatching-agents](./skills/workflow/dispatching-agents/SKILL.md) | Sub-agent dispatch with two-phase review (spec compliance + code quality) |
| [using-git-worktrees](./skills/workflow/using-git-worktrees/SKILL.md) | Isolated git worktrees for feature development |
| [finishing-branch](./skills/workflow/finishing-branch/SKILL.md) | Complete a dev branch: verify → choose action → clean up |
| [verify-before-done](./skills/workflow/verify-before-done/SKILL.md) | Must-run-verification before claiming any task done |
| [to-prd](./skills/workflow/to-prd/SKILL.md) | Synthesize conversation context into a PRD |
| [to-issues](./skills/workflow/to-issues/SKILL.md) | Split PRDs into vertically-sliced, independently grabbable issues |
| [triage](./skills/workflow/triage/SKILL.md) | State-machine issue triage with label and status workflows |
| [init-agent-environment](./skills/workflow/init-agent-environment/SKILL.md) | Bootstrap agent workspace — issue tracker, labels, domain docs |
| [create-skill](./skills/misc/create-skill/SKILL.md) | Create, improve, and evaluate skills |

### Misc

| Skill | Description |
|-------|-------------|
| [install-skills](./skills/misc/install-skills/SKILL.md) | Interactive skill symlink installer |
| [update-skills](./skills/misc/update-skills/SKILL.md) | Check upstream sources for skill drift and update |
| [setup-pre-commit](./skills/misc/setup-pre-commit/SKILL.md) | Set up pre-commit hooks |

## One-time Setup Skills

Most skills trigger on demand, but a few are one-time setup:

| Skill | Scope | What persists |
|-------|-------|---------------|
| `install-skills` | Per system | Symlinks in your agent's skill directory; re-run when you switch machines |
| `git-guardrails` | Per repo | Hook config in `.claude/settings.json`; re-run for each new repo |
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

- [Architecture Design](./docs/architecture_design.md)
- [Skill Writing Guide](./docs/skill-writing-guide.md)

## References

- [anthropics agent skills](https://github.com/anthropics/skills)
- [superpowers skills](https://github.com/obra/superpowers)
- [andrej karpathy skills](https://github.com/forrestchang/andrej-karpathy-skills)
- [mattpocock skills](https://github.com/mattpocock/skills)

## License

[MIT](./LICENSE)

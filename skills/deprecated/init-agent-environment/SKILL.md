---
name: init-agent-environment
description: Sets up an `## Agent skills` block in AGENTS.md/CLAUDE.md and `docs/agents/` so the engineering skills know this repo's issue tracker (GitHub or local markdown), triage label vocabulary, and domain doc layout. Run before first use of `decomposing-issues`, `writing-prd`, `triage`, `diagnose`, `tdd`, or `improve-architecture` — or if those skills appear to be missing context about the issue tracker, triage labels, or domain docs. Use when setting up a new repo for agent skill usage, or when skills are missing context about issue tracker, triage labels, or domain docs.
disable-model-invocation: true
---

# Init Agent Environment

Scaffold the per-repo configuration that the engineering skills assume:

- **Issue tracker** — where issues live (GitHub by default; local markdown is also supported out of the box)
- **Triage labels** — the strings used for the five canonical triage roles
- **Domain docs** — where `GLOSSARY.md` and ADRs live, and the consumer rules for reading them

This is a prompt-driven skill, not a deterministic script. Explore, present what you found, confirm with the user, then write.

## Process

### 1. Explore

Read whatever exists; don't assume:

- `git remote -v` and `.git/config` — is this a GitHub or GitLab repo? Which one?
- `AGENTS.md` and `CLAUDE.md` — does either exist? Is there already an `## Agent skills` section?
- `GLOSSARY.md` and `GLOSSARY-MAP.md`, plus legacy `CONTEXT.md` / `CONTEXT-MAP.md`. If a legacy file exists, offer to `git mv` it to the `GLOSSARY` name and rewrite the names in `docs/agents/domain.md`.
- `docs/adr/` and any `src/*/docs/adr/` directories
- `docs/agents/` — does this skill's prior output already exist?
- `.scratch/` — sign that local-markdown conventions are already in use
- Is the `triage` skill installed? This decides whether Section B runs at all.
- Monorepo signals: `pnpm-workspace.yaml`, a `workspaces` field in `package.json`, or `packages/*` with its own `src/`. Absence means single-context, which is almost every repo.

### 2. Present findings and ask

Summarise what is present and missing. Take the sections in order: one section, one answer, then the next. Lead with the recommended answer so the user can accept it in a word. Skip a section entirely when exploration already settled it.

**Section A — Issue tracker.**

> Explainer: The "issue tracker" is where issues live for this repo. Skills like `decomposing-issues`, `triage`, and `writing-prd` read from and write to it. They need to know whether to call `gh issue create`, write a markdown file under `.scratch/`, or follow some other workflow you describe.

Default posture: GitHub if a remote points at GitHub, GitLab if it points at GitLab. Otherwise offer:

- **GitHub** — GitHub Issues (uses the `gh` CLI)
- **GitLab** — GitLab Issues (uses the [`glab`](https://gitlab.com/gitlab-org/cli) CLI)
- **Local markdown** — files under `.scratch/<feature>/` in this repo (good for solo projects or repos without a remote)
- **Other** (Jira, Linear, etc.) — ask for a one-paragraph description; record it as freeform prose

The GitHub and GitLab templates carry a "PRs as a request surface" flag, defaulted **off**. Leave it off and don't raise it; the user can flip it in the file later.

A GitHub or GitLab tracker needs a reachable repo. If no remote points at that host, get the repo URL and wire it up (`git init` if needed, `git remote add origin <url>`). Done when `gh repo view` / `glab repo view` prints the project from this directory; if it can't, stop and tell the user what is missing.

**Section B — Triage label vocabulary.** Skip entirely if `triage` is not installed.

Ask exactly one question: "Do you want to keep the default triage labels? (recommended: yes)". The defaults are the five canonical roles, each string equal to its name: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. On yes, write them as-is. Only if the user says no, collect overrides so `triage` applies existing labels instead of creating duplicates.

**Section C — Domain docs.** Default to **single-context** (one `GLOSSARY.md` + `docs/adr/` at the repo root); write it without asking. Offer **multi-context** (root `GLOSSARY-MAP.md` pointing to per-context `GLOSSARY.md` files) only when exploration found monorepo signals.

### 3. Confirm and edit

Show the user a draft of:

- The `## Agent skills` block to add to whichever of `CLAUDE.md` / `AGENTS.md` is being edited
- The contents of `docs/agents/issue-tracker.md`, `docs/agents/domain.md`, and `docs/agents/triage-labels.md` (the last only when `triage` is installed)

Let them edit before writing.

### 4. Write

**Pick the file to edit:**

- If `CLAUDE.md` exists, edit it.
- Else if `AGENTS.md` exists, edit it.
- If neither exists, ask which one to create — don't pick for them.

Never create `AGENTS.md` when `CLAUDE.md` already exists (or vice versa). If an `## Agent skills` block already exists, update it in place rather than appending a duplicate; don't overwrite surrounding user edits.

The block:

```markdown
## Agent skills

### Issue tracker

[one-line summary of where issues are tracked]. See `docs/agents/issue-tracker.md`.

### Triage labels

[one-line summary of the label vocabulary]. See `docs/agents/triage-labels.md`.

### Domain docs

[one-line summary of layout — "single-context" or "multi-context"]. See `docs/agents/domain.md`.
```

Include the `### Triage labels` sub-block, and write `docs/agents/triage-labels.md`, only when `triage` is installed and Section B ran. When Section B ran on GitHub or GitLab, create each configured label the tracker lacks (`gh label create` / `glab label create`).

Then write the docs files from the seed templates:

- [issue-tracker-github.md](./issue-tracker-github.md)
- [issue-tracker-gitlab.md](./issue-tracker-gitlab.md)
- [issue-tracker-local.md](./issue-tracker-local.md)
- [triage-labels.md](./triage-labels.md) — only if `triage` is installed
- [domain.md](./domain.md)

For "other" trackers, write `docs/agents/issue-tracker.md` from scratch.

### 5. Done

Tell the user setup is complete and which engineering skills now read these files. They can edit `docs/agents/*.md` directly later; re-running this skill is only necessary to switch trackers or restart from scratch.

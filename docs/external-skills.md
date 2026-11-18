# Optional Upstream Skills

Some widely useful skills are maintained by upstream projects and are **not bundled** with ai-agent. Install them separately when you need them.

## Document skills

`pdf`, `docx`, `pptx`, and `xlsx` are official skills from [anthropics/skills](https://github.com/anthropics/skills). They are not bundled here because:

- they are large (scripts and OOXML schemas) and update frequently;
- ai-agent's value is the workflow, not a copy of official document tooling;
- keeping a rewritten copy creates sync and divergence cost without much added value.

### Install with the skills CLI

The `owner/repo@skill` form is used below. If your CLI version uses flags instead, run `npx skills add anthropics/skills --skill pdf` (and likewise for the others).

```bash
npx skills add anthropics/skills@pdf
npx skills add anthropics/skills@docx
npx skills add anthropics/skills@pptx
npx skills add anthropics/skills@xlsx
```

### Install with the Claude Code plugin marketplace

```text
/plugin marketplace add anthropics/skills
```

Then install the `document-skills` plugin.

### Verify

After installing, confirm the skill appears in your agent's skill list (or run the `manage-skills` skill and choose "Browse installed skills"). The four skills should trigger on `.pdf`, `.docx`, `.pptx`, `.xlsx`, and spreadsheet/document tasks.

## Frontend and design skills

These are strong design skills but too large or too fast-changing to vendor. Keep `frontend-design` (bundled) as the lightweight daily driver; install these when you need more.

| Skill | Source | Covers | Install |
|-------|--------|--------|---------|
| `ui-ux-pro-max` | [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | Searchable design system: styles, product palettes, font pairings, UX rules, stack guidance | manual CLI (below) |
| `impeccable` | [pbakaus/impeccable](https://github.com/pbakaus/impeccable) | Design-director workflow: critique, audit, polish, shape, detect AI-slop tells | manual CLI (below) |
| `web-design-guidelines` | [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | Review Web UI against Web Interface Guidelines (a11y, UX, best practices) | `npx skills add vercel-labs/agent-skills@web-design-guidelines -g -y` |

### `ui-ux-pro-max` (manual)

```bash
npm install -g ui-ux-pro-max-cli
uipro init --ai claude --global
```

- Requires Python 3.
- Installs a **skill pack** (`ui-ux-pro-max`, `design`, `design-system`, `ui-styling`, `brand`, `slides`), not just one skill.
- Use `--ai universal --global` to target `~/.agents/skills/`; replace `claude` with your agent if needed.
- It is large: the skill directory is roughly 3.7MB with CSV data and search scripts.

### `impeccable` (manual)

```bash
npx impeccable install
```

- Alternative: `npx skills add pbakaus/impeccable -g -y`.
- Provides `/impeccable` commands such as `critique`, `audit`, `polish`, `shape`, `document`, `harden`, `animate`.
- Uses `PRODUCT.md` and `DESIGN.md` for durable product/design context.
- The repo and installed skill are large (the skill directory is roughly 2.3MB); treat it as an optional high-craft layer, not a default.

### Using the three together

- `frontend-design` (bundled) sets the direction and keeps the brief-specific point of view.
- `ui-ux-pro-max` supplies searchable design-system knowledge and stack guidance.
- `impeccable` is for critique/audit/polish and redesigns; it overlaps heavily with the other two, so don't run all three by default.
- `web-design-guidelines` is a Web UI review layer: use it for page/component/style/interaction changes, with the local Web UI checklist in `code-review` as the offline fallback. It fetches the latest guidelines at review time, so it needs network access.

## Other upstream skills

If you need a capability that ai-agent does not cover, use [find-skills](../skills/misc/find-skills/SKILL.md) to search the open ecosystem. Prefer official sources (`anthropics`, `vercel-labs`, `microsoft`) and verify install counts and repository quality before installing.

## Maintenance note

This file is the canonical list of recommended external skills. When adding or removing one, update:

- this file;
- the root README's "Optional upstream skills" section;
- `skills/misc/manage-skills/references/recommended-upstream.md`.

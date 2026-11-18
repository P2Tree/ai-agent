# Recommended Upstream Skills

Skills that are useful but intentionally **not bundled** with ai-agent. Offer them when the user chooses "Install recommended upstream skills".

## Installer types

- **npx** — install directly with the skills CLI.
- **manual** — the skill ships its own installer, a pack, or extra runtime requirements. Show the exact commands, explain what will be installed, and run only after confirmation.

## npx-installable

| Skill | Covers | Command |
|-------|--------|---------|
| `pdf` | Read, extract, merge, split, rotate, watermark, encrypt, OCR, forms | `npx skills add anthropics/skills@pdf -g -y` |
| `docx` | Create, read, edit, tracked changes, comments | `npx skills add anthropics/skills@docx -g -y` |
| `pptx` | Decks, templates, editing, QA | `npx skills add anthropics/skills@pptx -g -y` |
| `xlsx` | Formulas, recalculation, financial models | `npx skills add anthropics/skills@xlsx -g -y` |
| `web-design-guidelines` | Review Web UI for a11y, UX, and Web Interface Guidelines compliance | `npx skills add vercel-labs/agent-skills@web-design-guidelines -g -y` |

`web-design-guidelines` fetches the latest guidelines from GitHub at review time, so it needs network access. The local Web UI checklist in `code-review` is the offline fallback.

If the installed CLI version uses flags instead of `owner/repo@skill`, use `npx skills add <owner/repo> --skill <name> -g -y`.

## Manual installers

### `ui-ux-pro-max`

```bash
npm install -g ui-ux-pro-max-cli
uipro init --ai claude --global
```

- Requires Python 3.
- Installs a **skill pack**: `ui-ux-pro-max`, `design`, `design-system`, `ui-styling`, `brand`, `slides`.
- Use `--ai universal --global` for `~/.agents/skills/`, or replace `claude` with the user's agent.
- Large: about 3.7MB for the `ui-ux-pro-max` skill directory (CSV data and search scripts).

### `impeccable`

```bash
npx impeccable install
```

- Alternative: `npx skills add pbakaus/impeccable -g -y`.
- Provides `critique`, `audit`, `polish`, `shape`, `document`, `harden`, `animate` and other `/impeccable` commands.
- Uses `PRODUCT.md` and `DESIGN.md` for product/design context.
- Large: about 2.3MB for the installed skill directory; it is a high-craft optional layer, not a default.

## Selection flow

1. Show all recommended skills in one multi-select question: "Which recommended upstream skills do you want to install?"
2. Let the user pick any subset, or cancel.
3. For each selected skill:
   - If already installed, ask whether to update, replace, or skip.
   - If **npx**: run the command.
   - If **manual**: show the commands, explain what will be installed (especially packs and runtime requirements), get confirmation, then run or hand the commands to the user.
4. Verify each install by checking the skill directory or running the browse flow.
5. Report what was installed, what was skipped, and any failures.

## Frontend roles

- Bundled `frontend-design` is the lightweight art-direction layer.
- `ui-ux-pro-max` supplies searchable design-system knowledge and stack guidance.
- `impeccable` is for critique, audit, polish, and redesigns.
- `web-design-guidelines` is a Web UI review layer; pair it with the local Web UI checklist in `code-review`.

Do not run all of them by default; pick the layer the task needs.

## Maintenance

Keep this list in sync with:

- `docs/external-skills.md`
- the root README's "Optional upstream skills" section

Only add skills that are official, broadly useful, and too large or too fast-changing to vendor.

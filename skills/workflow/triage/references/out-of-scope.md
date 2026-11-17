# Out-of-Scope Knowledge Base

The `.out-of-scope/` directory stores persistent records of rejected feature requests. It provides:

1. **Institutional memory** — why a feature was rejected, so the reasoning isn't lost when the issue closes.
2. **Deduplication** — when a new request matches a prior rejection, surface the previous decision instead of re-litigating it.

## Directory structure

```
.out-of-scope/
├── dark-mode.md
├── plugin-system.md
└── graphql-api.md
```

One file per **concept**, not per issue. Multiple requests for the same thing are grouped under one file.

## File format

Write in a relaxed, readable style — closer to a short design document than a database entry.

```markdown
# Dark Mode

This project does not support dark mode or user-facing theming.

## Why this is out of scope

The rendering pipeline assumes a single palette defined in `ThemeConfig`.
Supporting multiple themes would require a theme context provider, per-component
theme-aware resolution, and a persistence layer — a significant architectural
change that does not align with the project's focus on content authoring.

## Prior requests

- #42: "Add dark mode support"
- #87: "Night theme for accessibility"
```

### Naming the file

Use a short, descriptive kebab-case name: `dark-mode.md`, `plugin-system.md`. Someone browsing the directory should understand what was rejected without opening the file.

### Writing the reason

The reason must be substantive: not "we don't want this", but why. Reference project scope or philosophy, technical constraints, or strategic decisions. Avoid temporary circumstances ("we're too busy") — those are deferrals, not rejections.

## When to check

During triage, read all files in `.out-of-scope/`. Match by concept similarity, not keyword: "night theme" matches `dark-mode.md`. Surface a match to the maintainer: "This is similar to `.out-of-scope/dark-mode.md`. We rejected it because [reason]. Do you still feel the same way?"

The maintainer may:

- **Confirm** — append the new request to the file's "Prior requests" list, then close.
- **Reconsider** — delete or update the file, then proceed with normal triage.
- **Disagree** — the issues are related but distinct; proceed with normal triage.

## When to write

Only when an **enhancement** (not a bug) is *rejected* as `wontfix`. A rejected enhancement PR is recorded too, so the same request does not return as fresh code.

Do **not** write here when something is `wontfix` because it is **already implemented**. That is a built feature, not a rejected one; recording it poisons deduplication. Point to where the feature already lives instead.

Flow:

1. Maintainer decides the request is out of scope.
2. Check for a matching file.
3. If it exists, append the request to "Prior requests"; otherwise create the file with the concept name, decision, reason, and first request.
4. Comment on the issue explaining the decision and mentioning the file.
5. Close with the `wontfix` label.

## Updating or removing

If the maintainer reconsiders, delete the file. Old issues are historical records and do not need reopening; the new request proceeds through normal triage.

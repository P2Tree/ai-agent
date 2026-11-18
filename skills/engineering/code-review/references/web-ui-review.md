# Web UI Review

Use for any change to pages, components, styles, layout, or interaction. This is the offline floor; if the upstream `web-design-guidelines` skill is installed, run it as an enhancement and fold its findings in.

## Checklist

- **Keyboard and focus** — every interactive element is reachable by keyboard; focus is visible and not obscured; focus order matches visual order.
- **Labels and errors** — form controls have visible labels; errors sit next to the field and explain what to do; required fields are marked.
- **Contrast and semantics** — text contrast meets WCAG AA; headings and landmarks are semantic; images have meaningful `alt` (or empty `alt` when decorative).
- **Responsive** — works at mobile width; no horizontal page scroll; touch targets are at least 44×44px.
- **States** — loading, empty, error, disabled, and success states exist and are distinguishable.
- **Interaction** — nothing important depends on hover only; state changes have visible feedback; motion respects `prefers-reduced-motion`.
- **Content** — no placeholder/lorem text, no truncated labels, no unstyled default controls.
- **Consistency** — same component type looks and behaves the same across the change; spacing and type scale follow the project.

## Output

Report findings as `file:line — issue — why it matters — suggested fix`. Calibrate severity like any code review: blocking for accessibility or broken interaction, minor for polish.

## If `web-design-guidelines` is installed

Run it against the changed files or routes and merge its findings. It fetches the latest Web Interface Guidelines, so treat its rules as current; resolve conflicts in favor of the project's explicit design decisions and accessibility requirements.

---
name: frontend-design
description: Create distinctive, production-grade frontend interfaces with high design quality. Use when building web components, pages, dashboards, React components, HTML/CSS layouts, or styling any web UI.
---

# Frontend Design

Approach this as the design lead at a studio known for giving every client a distinct visual identity. The client has already rejected cliché or templated proposals and is paying for a point of view: make deliberate, opinionated choices about palette, typography, and layout that are specific to this brief.

## Ground your designs in the subject matter

If the brief does not identify the product or subject, identify one concrete subject yourself, confirm it with the client, and state the audience and the page's primary job. Use any memory of the client's preferences as a hint. The subject's industry, materials, and vernacular are where distinctive visual choices come from — a toy for 8–11-year-olds looks nothing like a dashboard for financial analysts. Build with the brief's real content throughout.

## Design principles

For web designs, the hero is the first thing viewers see. Open with the most characteristic thing in the subject's world: a headline, image, animation, live demo, or interactive moment. The default "big number + small label + supporting stats + gradient accent" is only right if it is genuinely the best option.

Typography carries the page's personality. Use one family or two; if two, make them clearly distinct. Choose typefaces deliberately rather than defaults, set a clear scale following *The Elements of Typographic Style*, and use type as an active part of the design when it is a headline or visual element. Default to line lengths under 80 characters; serif body text can run slightly longer and needs slightly more line-height.

Avoid these default typographic treatments — they are the commonest tells of a generated page:

- Accenting a single word or phrase in a headline.
- All caps for labels.
- Unnecessary typographic labels above content.

Visual structure is information. Outlines, borders, numbering, eyebrows, and dividers should encode something true about the content. Numbered markers (01/02/03) are only appropriate when the content is actually a sequence.

Use non-user-triggered motion sparingly. One orchestrated page-load or reveal lands better than fade-and-slide on every section and hover on every card. Motion that answers a user action is welcome when it shows what changed.

## Process: plan, review against the brief, build, critique

AI-generated design currently clusters around these traits:

1. warm cream background (#F4F1EA-ish) with a high-contrast serif and terracotta accent (often #D97757 — reads as a tell).
2. near-black background with one acid-green or vermilion accent.
3. broadsheet layout: hairline rules, zero radius, dense newspaper columns.
4. the SaaS-card kit: identical rounded cards, one radius regardless of hierarchy, the same soft grey shadow, decorative gradient washes.
5. template chrome regardless of subject: ALL-CAPS eyebrow labels, middle-dot meta strings ('A · B · C'), 'WORD — fragment' labels, near-black instead of black, monospace micro-labels, '→' appended to links.

These are legitimate for some briefs, but they are defaults rather than choices. Where the brief pins a direction, follow it exactly — the brief always wins. Where it leaves an axis free, don't spend that freedom on a default.

Work in two passes:

1. **Design plan** — a compact token system:
   - Color: 4–6 named hex values.
   - Type: typefaces and their roles.
   - Layout: one-sentence prose descriptions plus ASCII wireframes; state alignment.
   - Principles: what makes this page unique.
2. **Review against the brief** — if any part would be the same for any similar page, revise it, say what changed and why. Only then write code.

When writing CSS, watch selector specificity. It is easy to generate classes that cancel each other out (especially a type-based `.section` and an element-based `.cta`), often around padding and margin between sections.

## Restraint and self-critique

Spend boldness in one place. Let one element be memorable and keep everything around it quiet. Build to a quality floor without announcing it: responsive down to mobile, visible keyboard focus, reduced motion respected, visually accessible, harmonious palette. Critique your own work as you build, taking screenshots when the environment supports it. Remove one accessory before shipping.

## Writing in design

Words are design content, not decoration. Before writing, ask what the design needs to say and how it can best help someone navigate the experience.

- Write from the user's perspective: "manage notifications," not "webhook config."
- Prefer plain, specific language over cleverness.
- Use active voice. A CTA says exactly what happens: "Save changes," not "Submit." Keep an action's name consistent through the flow.
- Treat failure and emptiness as moments for direction, not mood. Say what went wrong and how to fix it; empty screens invite action.
- Keep the tone conversational: plain verbs, sentence case, no filler. Each element does one job.

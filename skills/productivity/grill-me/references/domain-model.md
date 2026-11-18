# Domain Model Conventions

Optional, lazily maintained records of the project's language and important decisions. Create them only when there is something real to write.

## Location

Single-context repo:

```
/
├── GLOSSARY.md
├── docs/adr/
│   └── 0001-event-sourced-orders.md
└── src/
```

Multi-context repo (presence of `GLOSSARY-MAP.md` at the root):

```
/
├── GLOSSARY-MAP.md
├── docs/adr/                  ← system-wide decisions
└── src/
    ├── ordering/
    │   ├── GLOSSARY.md
    │   └── docs/adr/          ← context-specific decisions
    └── billing/
        ├── GLOSSARY.md
        └── docs/adr/
```

If either file/directory does not exist, create it when the first term or decision needs it.

## GLOSSARY.md format

One line per term:

```markdown
- **Order** — a customer's request to buy one or more items.
- **Cancellation** — withdrawing an Order before fulfillment starts.
```

Rules:

- Glossary only: no implementation details, specs, or scratch notes.
- Use the term consistently in specs, plans, tests, and issues.
- If the code and the glossary disagree, surface the contradiction instead of silently choosing one.

## ADR format

```markdown
# 0007 Use Postgres for the write model

**Status:** accepted

## Context

[What situation forced a decision? What constraints applied?]

## Decision

[What was chosen.]

## Consequences

[What becomes easier or harder, and what we accept.]
```

Offer an ADR **only when all three are true**:

1. **Hard to reverse** — changing your mind later is expensive.
2. **Surprising without context** — a future reader would ask "why did they do it this way?"
3. **A real trade-off** — there were genuine alternatives and a reason for the choice.

If any condition is missing, skip the ADR; the spec/plan decision section is enough.

## Who maintains and uses it

- **grill-me** — primary maintainer: challenges conflicting terms, sharpens fuzzy language, updates `GLOSSARY.md`, offers ADRs.
- **improve-architecture** — may add terms or offer ADRs during refactoring.
- **brainstorming / writing-prd / writing-plans / diagnose / triage / code-review** — read the glossary and ADRs; `code-review` reports drift instead of silently rewriting.
- **No separate setup skill** — these files are created on demand, not generated up front.

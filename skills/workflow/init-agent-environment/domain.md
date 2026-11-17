# Domain Docs

How the engineering skills should consume this repo's domain documentation when exploring the codebase.

## Before exploring, read these

- **`GLOSSARY.md`** at the repo root, or
- **`GLOSSARY-MAP.md`** at the repo root if it exists — it points at one `GLOSSARY.md` per context. Read each one relevant to the topic.
- **`docs/adr/`** — read ADRs that touch the area you're about to work in. In multi-context repos, also check `src/<context>/docs/adr/` for context-scoped decisions.

If any of these files don't exist, **proceed silently**. Don't flag their absence; don't suggest creating them upfront. The `/improve-architecture` and `/grill-me` skills create them lazily when terms or decisions actually get resolved.

## File structure

Single-context repo (most repos):

```
/
├── GLOSSARY.md
├── docs/adr/
│   ├── 0001-event-sourced-orders.md
│   └── 0002-postgres-for-write-model.md
└── src/
```

Multi-context repo (presence of `GLOSSARY-MAP.md` at the root):

```
/
├── GLOSSARY-MAP.md
├── docs/adr/                          ← system-wide decisions
└── src/
    ├── ordering/
    │   ├── GLOSSARY.md
    │   └── docs/adr/                  ← context-specific decisions
    └── billing/
        ├── GLOSSARY.md
        └── docs/adr/
```

## Use the glossary's vocabulary

When your output names a domain concept (in an issue title, a refactor proposal, a hypothesis, a test name), use the term as defined in `GLOSSARY.md`. Don't drift to synonyms the glossary explicitly avoids.

If the concept you need isn't in the glossary yet, that's a signal — either you're inventing language the project doesn't use (reconsider) or there's a real gap (note it for `/improve-architecture`).

## Flag ADR conflicts

If your output contradicts an existing ADR, surface it explicitly rather than silently overriding:

> _Contradicts ADR-0007 (event-sourced orders) — but worth reopening because…_

## Maintaining the model

Reading the glossary is a one-line habit. This section is for when the model is being **changed**.

- **Challenge conflicts.** If the user's term contradicts `GLOSSARY.md`, say so immediately: "Your glossary defines 'cancellation' as X, but you seem to mean Y. Which is it?"
- **Sharpen fuzzy language.** When a term is vague or overloaded, propose a precise canonical term: "You're saying 'account': do you mean the Customer or the User? Those are different things."
- **Stress-test with scenarios.** Invent concrete edge cases that force the boundaries between concepts to be explicit.
- **Cross-reference with code.** If the user's description disagrees with the implementation, surface the contradiction rather than silently choosing one.
- **Write terms down immediately.** Update `GLOSSARY.md` as each term is resolved. Use one line per term: `- **Term** — definition.` Keep it a glossary: no implementation details, no specs, no scratch notes.
- **Offer ADRs sparingly.** Only when all three are true: changing your mind later is expensive (hard to reverse); a future reader would wonder why (surprising without context); there were genuine alternatives and a real trade-off. Format: Title, Status, Context, Decision, Consequences.
- **Create files lazily.** Create `GLOSSARY.md` or `docs/adr/` only when the first term or decision needs it.

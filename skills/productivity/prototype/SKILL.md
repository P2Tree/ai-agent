---
name: prototype
description: Build a throwaway prototype to flush out a design before committing. Use when the user wants to prototype, sanity-check a data model, mock up a UI, explore design options, or says "prototype this", "try a few designs".
---

# Prototype

A prototype is **throwaway code that answers a question**. The question decides the shape.

## Pick a Branch

Identify which question is being answered:

- **"Does this logic / state model feel right?"** → Build a tiny interactive terminal app that pushes the state machine through hard-to-reason-about cases.
- **"What should this look like?"** → Generate several radically different UI variations on a single route, switchable via URL search param and a floating bottom bar.

If ambiguous and user isn't reachable, default to whichever matches the surrounding code (backend → logic; page/component → UI) and state the assumption.

## Rules

1. **Throwaway from day one.** Locate prototype code close to where it will be used, but name it so readers know it's a prototype.
2. **One command to run.** The user must be able to start it without thinking.
3. **No persistence by default.** State lives in memory. If the question explicitly involves a database, use a scratch DB with a clear "PROTOTYPE — wipe me" name.
4. **Skip the polish.** No tests, no error handling beyond what makes it runnable, no abstractions.
5. **Surface the state.** After every action, print or render the full relevant state.
6. **Delete or absorb when done.** Don't leave prototypes rotting in the repo.

## When Done

The *answer* is the only thing worth keeping. Capture it somewhere durable (commit message, ADR, issue) along with the question it was answering. Then delete the prototype or fold the decision into real code.

See [logic prototype guide](references/logic-prototype.md) and [UI prototype guide](references/ui-prototype.md) for branch-specific details.

## Next Steps

- **writing-prd** — if the prototype confirms feasibility and the result needs a formal PRD
- **writing-plans** — if the design is validated and ready for an implementation plan
- **frontend-design** — if the prototype was a UI direction exploration and a visual direction was chosen

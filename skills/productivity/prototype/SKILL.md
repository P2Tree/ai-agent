---
name: prototype
description: Build a throwaway prototype to flush out a design before committing. Use when the user wants to prototype, sanity-check a data model, mock up a UI, explore design options, or says "prototype this", "try a few designs".
---

# Prototype

A prototype is **throwaway code that answers a question**. The question decides the shape.

## Pick a Branch

Identify which question is being answered:

- **"Does this logic / state model feel right?"** → Build a single shareable HTML file (free-play buttons plus tabbed guided walkthroughs) that pushes the state machine through hard-to-reason-about cases and that a non-developer can drive.
- **"What should this look like?"** → Generate several radically different UI variations on a single route, switchable via URL search param and a floating bottom bar.

If ambiguous and user isn't reachable, default to whichever matches the surrounding code (backend → logic; page/component → UI) and state the assumption.

## Rules

1. **Throwaway from day one, clearly marked.** Locate prototype code close to where it will be used, but name it so a casual reader sees it's a prototype. For throwaway UI routes, obey the project's existing routing convention; don't invent a new top-level structure.
2. **Trivial to run.** A UI prototype starts from one command in the project's task runner; a logic demo is a single HTML file the user double-clicks.
3. **No persistence by default.** State lives in memory. If the question explicitly involves a database, use a scratch DB or local file with a clear "PROTOTYPE — wipe me" name.
4. **Skip the polish.** No tests, no error handling beyond what makes it runnable, no abstractions.
5. **Surface the state.** After every action (logic) or every variant switch (UI), render the full relevant state so the user sees what changed.
6. **Capture it when done.** Fold the validated decision into real code, then keep the prototype itself as a **primary source**: commit it to a throwaway branch (not main) and leave a context pointer to that branch on the implementation issue.

## When Done

The **answer** is the only thing worth keeping on main. Capture the verdict and the question it settled in the issue or commit, along with a pointer to the throwaway branch holding the prototype.

See [logic prototype guide](references/logic-prototype.md) and [UI prototype guide](references/ui-prototype.md) for branch-specific details.

## Next Steps

- **writing-prd** — if the prototype confirms feasibility and the result needs a formal PRD
- **writing-plans** — if the design is validated and ready for an implementation plan
- **frontend-design** — if the prototype was a UI direction exploration and a visual direction was chosen

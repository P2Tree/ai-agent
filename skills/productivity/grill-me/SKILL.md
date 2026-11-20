---
name: grill-me
description: Interview the user relentlessly about a plan, decision, or idea until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, get grilled on their design, or mentions "grill me".
---

# Grill Me

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

## Work in rounds

The **frontier** is every decision whose prerequisites are already settled: the questions you can ask *now* without guessing at answers you haven't heard yet. Ask the whole frontier in one round, numbered, with your recommended answer. Then wait for the user's answers before the next round.

Format a round like so:

```
❓ **Q1** - **<question title>**: <question body, possibly multiple paragraphs or multiple choices>

➡️ <your recommended answer>

---

❓ **Q2** - **<question title>**: <question body>

➡️ <your recommended answer>
```

Word each question so answering "yes" accepts your recommended answer.

Each round of answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a *later* round.

## Facts vs decisions

Finding *facts* is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, codebase), dispatch a sub-agent with a fresh context window to find it; don't ask the user for anything you can look up yourself. Give it the question and suggested modules/files, and let it search the repo as needed; don't cap what it reports. Don't block on it: only questions downstream of that fact wait; ask the rest of the frontier now. If it runs long, tell the user how long it has run and ask whether to keep waiting or proceed without it; never cancel on your own. The *decisions* are the user's — put each to them and wait.

## Finish

The session is done when the frontier is empty: every branch of the design tree visited, nothing silently assumed. Do not act on the plan until the user confirms you have reached a shared understanding.

If a decision settles a domain term or an architectural choice, record it: update `GLOSSARY.md` (create it lazily) or offer an ADR when the choice is hard to reverse, confusing out of context, and represents a real trade-off. Location, formats, and ownership are in [domain-model.md](references/domain-model.md).

## Next

- **brainstorming** — when the frontier is empty and you want to turn the decisions into a spec.
- **writing-plans** — when a plan already exists and only its complexity needs stress-testing.

---
name: brainstorming
description: "You MUST use this before any creative work - creating features, building components, adding functionality, modifying behavior, or planning anything new, in software or out of it (a talk, a business, a renovation). Use when starting a new feature, project, or major change."
---

# Brainstorming

You build what you believe your human partner wants, and that belief is usually thinner than it feels. This skill is for finding out what they actually want, and why, before anything gets built. When you understand the why, you make the hundred decisions they never mention the way they would have made them.

## Two Phases

1. **Explore** — understand intent, options, constraints, and approaches. Do not write the spec yet. Stop here if the user only wants a discussion.
2. **Grill** — hand the chosen direction to **grill-me** to resolve the decision frontier and edge cases.
3. **Spec** — write the design doc/spec only after the frontier is empty. The spec is a record of decisions already made, not a place to discover them.

## First: What Do You Actually Know?

Before replying, ask: what do I know about what they want, and why?

- **Everything that matters is in the request** ("make the icon cornflower blue"). Do it, and say what you did.
- **Something non-trivial is missing.** Start the conversation.

Before implementing, you must, in order:

1. Lay out the approaches in a message of their own, and have them pick one.
2. Write the design doc, short or full.
3. Get their approval of that doc.

If nothing is open when you write your first message and there is one sensible way, steps 1–3 happen in that message.

Two things are not implementing: a spike they said yes to, and doing what they asked once they opted out of the questions.

## Look Before You Ask

In an existing project, or when they gave you context (a spec, plan, handoff, files, earlier conversation), dig in before your first message. Read what they referred to and the code or material it connects to, until you can explain how the relevant parts work today and what this change would touch. Never ask what the project or their context already answers, or reopen what they already decided.

## Your First Message

- **They already said what they want** (a spec, plan, detailed request): aim for about 200 words. Echo the request in your own words — what they want, who it's for, why, as far as they've said. Add what you found that bears on it. End with one line inviting corrections. If they haven't said why, ask that as one open question, with nothing to pick from. If they have, ask the one open question whose answer would change what gets built most; when its choices can be named, sketch each with its trade-off and your pick. If nothing is open, end with the short design and ask them to approve it.
- **They haven't:** one open question, in their own terms, about the biggest thing their request leaves unsettled. Say what the answer would change.
- If they did not ask for brainstorming by name, end with a one-line offer to just get going instead. If they take it, this skill is done: state significant how-it-gets-made choices in one plain line, then do the work through the normal workflow.

Specs are often incomplete, so confirm before building on one.

## The Conversation

Ask a question only when the answer would change what gets built and neither the request nor the project answers it. Otherwise state your call and reason as a proposal they can correct. Process steps (writing things up, file locations, looking further, how to show something) are always your calls: do them and say so.

- **Get them describing first.** Until you know why they want it, ask open questions with no example answers. Their own words carry intent options cannot.
- Once you know why, nameable choices get options with trade-offs and your pick. "Just guess" means propose something concrete.
- **How it gets made:** read from how they talk which choices they want to make. Someone raising platform/language/tool trade-offs wants options; someone talking outcomes is handing you the how. Make those calls, state each in a line, and record them as your calls.
- **Ground to cover** (territory, not a script): what kind of thing this is and what makes it special; why now and what success looks like; goals, non-goals, anti-goals; prior art; current state; the details they care about.
- **Make every question specific** to their project and build on their last answer. State what you're hoping to learn when it isn't plain.
- **Do recon** when it would help: deeper into the codebase, their files, or the web. Say what you looked for and found.
- **Lay out the approaches** in a message of their own, after you understand what they want and before writing anything. Sketch two or three real alternatives with trade-offs, recommend one and say why, then ask. If there is one sensible way, say so and explain why the others don't fit.
- **Show, don't tell.** Whenever seeing would help, sketch it in text. Offer the visual companion when the look itself is theirs to decide.
- **Spike to feel things out** when a throwaway build is the cheapest way to learn. A spike gets no tests or minimal ones, skips the plan, and is labeled throwaway; bringing it back into the product is a new request through the gate.

## Play It Back

As soon as you understand one part well enough to describe it, describe that part back in about 200–300 words, then return to questions about the next part. Playback and questions alternate through the conversation.

Only what they said goes in as theirs. Anything you filled in goes in as your proposal, with your reason. End each chunk by asking what is wrong or missing. If the chunk describes something they will look at, put a text sketch beside it; if the look is theirs to decide, offer the visual companion first.

## Size the Work

Once you understand what they want and they picked an approach, say how big the work is in plain words; they can override it.

- **A small change** — a short design doc: what you already covered together, written down.
- **A project** — the full written design below.

If it grows mid-task, stop, say so, and step up a size. If it is really several independent projects, say so, agree on an order, and brainstorm them one at a time.

## The Written Design

Write a plain document a talented builder in the domain could plan from without going back to the user. Cover: intent and why; goals, non-goals, anti-goals; constraints; approaches and which was picked; the parts of the how they decided; what is left to the builder.

Save to `docs/specs/YYYY-MM-DD-<spec_name>.md` (user preference overrides) and commit. Add `**Status:** draft | approved | implemented | superseded` and `**Date:** YYYY-MM-DD`; old specs are historical records, not living truth. **Language:** if the conversation is entirely English, write in English; otherwise follow the conversation.

Only write the spec after **grill-me** has cleared the decision frontier. If a new question appears while writing, stop and grill it rather than inventing an answer.

**Builder check** (project-scale design only): ask first whether to use a fresh subagent or self-review. If approved, give it the design doc path, product context, and suggested focus areas, and let it read the repo as needed. Ask for questions, why each matters, and what answer would change; do not cap the count. Sort the result into: answered already (put the answer in the document), minor (settle yourself and mark it as your call), and theirs (only the user can answer). If it runs long, tell the user and ask whether to keep waiting or cancel and self-review; never cancel on your own. Without a subagent, read it as that builder yourself.

**Self-review** the spec for placeholders, contradictions, ambiguity, and scope using [spec review](references/spec-review.md), fixing inline.

<HARD-GATE>
Nothing gets built until the user approves the design doc: the short one for a small change, the full one for a project. Building includes product code, scaffolding, installing dependencies, creating projects, and invoking an implementation skill. Reading and exploring are fine.

Two exceptions: if they opted out of the questions, this skill is done and the gate goes with it; a spike they approved may be built, stays labeled throwaway, and keeping what it produced is a new request through the gate.
</HARD-GATE>

## Next

- **grill-me** — decisions still have open branches or edge cases; do this before writing the spec.
- **prototype** — a technical or UX assumption needs validation before committing.
- **writing-prd** — a second reader/stakeholder needs a formal requirements document.
- **writing-plans** — the spec is approved and ready for implementation steps.

## Red Flags

| Thought | Reality |
|---------|---------|
| "I'll offer a menu of what they might want" | Options steer. Ask them to describe it first. |
| "I'll fill in sensible defaults" | Good — say them out loud. A default they never heard is one they couldn't reject. |
| "I answered their questions, so I'll write the doc" | Lay out the approaches first, in their own message. |
| "I should explain the process first" | Ask your question. The process shows itself. |
| "They said 'sounds good' to the idea" | Approval covers what you showed them. An unwritten design doc is not approved. |
| "The spike works, I'll keep building on it" | Keeping it is a new request. Back through the gate. |

## Visual Companion

A browser tab for mockups, diagrams, and prototypes — a tool, not a mode.

**Offer it just-in-time**, the first time a visual moment comes up, never upfront. The offer is its own message:

> "This might be easier if I show you. Want me to open a browser tab with some mockups?"

If they decline, stay in text and don't offer again unless they raise it. Per question, use the browser only when seeing would beat reading: mockups, layouts, diagrams, side-by-side designs. Requirements, scope, trade-offs, and conceptual choices stay in text. If they accept, read [visual-companion.md](visual-companion.md) before starting the server.

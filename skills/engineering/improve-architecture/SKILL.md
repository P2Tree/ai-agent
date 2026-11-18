---
name: improve-architecture
description: Scan an entire codebase for deepening opportunities, informed by the domain language and architectural decisions. Use when the user wants a codebase-wide architecture review, find refactoring opportunities across modules, consolidate tightly-coupled modules, or make a whole codebase more testable and AI-navigable. For a single module's interface or seam, use codebase-design instead.
---

# Improve Codebase Architecture

Surface architectural friction and propose **deepening opportunities** — refactors that turn shallow modules into deep ones. The aim is testability and AI-navigability.

## Design vocabulary

Call the **codebase-design** skill before naming candidates; it provides the shared module/interface/depth/seam/adapter/leverage/locality vocabulary and its principles: the deletion test, "the interface is the test surface", and "one adapter = hypothetical seam, two = real". Use those terms exactly in every suggestion; don't drift into "component," "service," "API," or "boundary."

This skill is _informed_ by the project's domain model. The domain language gives names to good seams; ADRs record decisions the skill should not re-litigate.

## Pre-flight

- Read `GLOSSARY.md` and relevant `docs/adr/` if they exist; use the project's terms and don't re-litigate settled decisions.
- If a GitHub/GitLab remote exists and a candidate should be recorded, create an issue with `gh`/`glab`.
- Use this skill when you don't already know where to refactor. If you have a specific target, go straight to brainstorming/spec/plan.

## Process

### 1. Explore

**Scope before you scan: YAGNI.** Deepening a module pays off by making future changes easier, so weight the parts of the codebase that have recently changed. Decide *where* to look first:

- If the user named a direction (a module, subsystem, or pain point), take it.
- Otherwise, walk back a good stretch of `git log --oneline` to find hot spots — files and areas that keep coming up — and let those pull your attention first. If changes are scattered, widen the net.

Read the project's domain glossary and any ADRs in the area you're touching first.

Then spawn a sub-agent with a **fresh context window** to walk the codebase. Don't follow rigid heuristics — explore organically and note where you experience friction:

- Where does understanding one concept require bouncing between many small modules?
- Where are modules **shallow** — interface nearly as complex as the implementation?
- Where have pure functions been extracted just for testability, but the real bugs hide in how they're called (no **locality**)?
- Where do tightly-coupled modules leak across their seams?
- Which parts of the codebase are untested, or hard to test through their current interface?

Apply the **deletion test** to anything you suspect is shallow: would deleting it concentrate complexity, or just move it? A "yes, concentrates" is the signal you want.

### 2. Present candidates

Present a numbered list of deepening opportunities. For each candidate:

- **Files** — which files/modules are involved
- **Problem** — why the current architecture is causing friction
- **Solution** — plain English description of what would change
- **Benefits** — explained in terms of locality and leverage, and also in how tests would improve
- **Recommendation strength** — `Strong`, `Worth exploring`, or `Speculative`

End with a **Top recommendation**: which candidate to tackle first and why. If the user wants a visual report, write a self-contained HTML file to the OS temp directory and open it.

**Use `GLOSSARY.md`'s vocabulary for the domain, and the codebase-design vocabulary for the architecture.** If the glossary defines "Order," talk about "the Order intake module" — not "the FooBarHandler," and not "the Order service."

**ADR conflicts**: if a candidate contradicts an existing ADR, only surface it when the friction is real enough to warrant revisiting the ADR. Mark it clearly (e.g. _"contradicts ADR-0007 — but worth reopening because…"_). Don't list every theoretical refactor an ADR forbids.

Do NOT propose interfaces yet. Ask the user: "Which of these would you like to explore?"

### 3. Grilling loop

Once the user picks a candidate, drop into a grilling conversation. Walk the design tree with them — constraints, dependencies, the shape of the deepened module, what sits behind the seam, what tests survive.

Side effects happen inline as decisions crystallize: challenge conflicting terms, sharpen fuzzy terms, update `GLOSSARY.md` inline, and offer ADRs only when the decision is hard to reverse, surprising without context, and a real trade-off.

- **Naming a deepened module after a concept not in the domain glossary?** Add the term to the glossary file, one line per term. Create the file lazily if needed.
- **Sharpening a fuzzy term during the conversation?** Update the glossary file right there.
- **User rejects the candidate with a load-bearing reason?** Offer an ADR when the decision is hard to reverse, surprising without context, and a real trade-off. Frame it as: _"Want me to record this as an ADR so future architecture reviews don't re-suggest it?"_ Skip ephemeral reasons ("not worth it right now") and self-evident ones.
- **Want to explore alternative interfaces for the deepened module?** Use the codebase-design skill's design-it-twice pattern.

## Next Steps

- **brainstorming** / **writing-plans** — turn the approved candidate into a spec and an implementation plan.
- **executing-plans** — implement the refactor with test-first steps.
- **arch-doc** — if the architectural changes are significant, update or create architecture documentation.

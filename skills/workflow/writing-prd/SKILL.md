---
name: writing-prd
description: Turn the current conversation context into a PRD and publish it to the project issue tracker. Use when user wants to create a PRD from the current context.
---

This skill takes the current conversation context and codebase understanding and produces a PRD. Do NOT interview the user — just synthesize what you already know.

## Pre-flight

- Detect the tracker from `git remote -v`: GitHub (`gh`) or GitLab (`glab`). If neither, ask the user where to publish the PRD.
- Read `GLOSSARY.md` / `docs/adr/` if they exist; use the project's terms and respect settled decisions.
- After publishing, apply a `ready-for-agent` label only if the tracker already has one; otherwise ask before creating it.

## Process

1. Explore the repo to understand the current state of the codebase, if you haven't already.

2. Sketch out the seams at which you will test the feature. Prefer existing seams to new ones, and use the highest seam possible. If a new seam is needed, propose it at the highest point you can. Fewer seams across the codebase is better — the ideal is one.

Check with the user that these seams match their expectations.

3. Write the PRD using the template below. Add `**Status:** draft | approved | implemented | superseded` and `**Date:** YYYY-MM-DD`. **Language:** if the source issue and related specs are entirely in English, write the PRD in English; otherwise, follow the language used in those source materials. Then publish it to the project issue tracker.

<prd-template>

## Problem Statement

The problem that the user is facing, from the user's perspective.

## Solution

The solution to the problem, from the user's perspective.

## User Stories

A LONG, numbered list of user stories. Each user story should be in the format of:

1. As an <actor>, I want a <feature>, so that <benefit>

<user-story-example>
1. As a mobile bank customer, I want to see balance on my accounts, so that I can make better informed decisions about my spending
</user-story-example>

This list of user stories should be extremely extensive and cover all aspects of the feature.

## Implementation Decisions

A list of implementation decisions that were made. This can include:

- The modules that will be built/modified
- The interfaces of those modules that will be modified
- Technical clarifications from the developer
- Architectural decisions
- Schema changes
- API contracts
- Specific interactions

Do NOT include specific file paths or code snippets. They may end up being outdated very quickly.

Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it within the relevant decision and note briefly that it came from a prototype. Trim to the decision-rich parts — not a working demo, just the important bits.

## Testing Decisions

A list of testing decisions that were made. Include:

- A description of what makes a good test (only test external behavior, not implementation details)
- Which modules will be tested
- Prior art for the tests (i.e. similar types of tests in the codebase)

## Out of Scope

A description of the things that are out of scope for this PRD.

## Further Notes

Any further notes about the feature.

</prd-template>

## Next Steps

- **decomposing-issues** — split the PRD into tracer-bullet vertical slices and publish as issues
- **writing-plans** — create a detailed implementation plan directly from the PRD (skip decomposing-issues for small PRDs)

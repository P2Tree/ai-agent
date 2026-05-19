---
name: coauthoring
description: Co-author prose-heavy content through iterative human-AI collaboration. Use when writing blog posts, articles, essays, tutorials, or any content where the user's voice and ideas drive the output. NOT for structured specs (PRD, RFC) — use writing-prd for those. Trigger when user mentions writing a blog, article, post, essay, tutorial, or wants help drafting prose in their own voice.
---

# Co-Authoring Workflow

Co-author prose-heavy content through iterative human-AI collaboration — three stages: Context Gathering, Refinement & Structure, and Reader Testing.

**This skill is for content where the user's voice, ideas, and judgment drive the output** — blog posts, articles, essays, tutorials, thought pieces. The user writes; Claude amplifies.

**Not for structured specs.** If the user wants a PRD, RFC, or design doc with fixed sections, use `writing-prd` instead — those are synthesized from context, not co-authored.

## When to Offer This Workflow

**Trigger conditions:**
- User mentions writing prose content: "write a blog post", "draft an article", "help me write an essay"
- User wants to develop ideas in their own voice: "help me flesh out this draft", "I want to write about..."
- User is in a flow state and wants a writing partner, not a document generator

**Do NOT trigger for:**
- PRD → use `writing-prd`
- RFC / design doc with fixed structure → use `writing-prd` or freeform
- Pure status/report → use `work-report`

**Initial offer:**
Offer the user a structured workflow with three stages:

1. **Context Gathering**: User provides all relevant context while Claude asks clarifying questions
2. **Refinement & Structure**: Iteratively build each section through brainstorming and editing
3. **Reader Testing**: Test the doc with a fresh Claude (no context) to catch blind spots

Ask if they want to try this workflow or prefer freeform. If declined, work freeform.

## Stage 1: Context Gathering

**Goal:** Close the gap between what the user knows and what Claude knows.

1. Ask meta-context questions: doc type, primary audience, desired impact, template/format, constraints
2. Encourage info dumping — background, team discussions, alternatives, org context, timeline, architecture, stakeholders
3. Use integrations (Slack, Teams, Google Drive, MCP servers) to pull context if available
4. After initial dump, generate 5-10 clarifying questions based on gaps
5. **Exit condition:** Can ask about edge cases and trade-offs without needing basics explained

→ See [references/stage1-context-gathering.md](references/stage1-context-gathering.md) for full detail

## Stage 2: Refinement & Structure

**Goal:** Build the document section by section through brainstorming, curation, and iterative refinement.

For each section, cycle through:
1. **Clarifying questions** — 5-10 specific questions about what to include
2. **Brainstorming** — generate 5-20 options depending on section complexity
3. **Curation** — user indicates keep/remove/combine with brief justifications
4. **Gap check** — ask if anything important is missing
5. **Drafting** — replace placeholder text with actual content via `str_replace`
6. **Iterative refinement** — surgical edits based on feedback; never reprint the whole doc

**Section ordering:** Start with the section having the most unknowns. Summary sections last.

**Near completion (80%+ sections done):** Re-read entire doc for flow, consistency, redundancy, and filler.

→ See [references/stage2-refinement-structure.md](references/stage2-refinement-structure.md) for full detail

## Stage 3: Reader Testing

**Goal:** Test the document with a fresh Claude (no context bleed) to verify it works for readers.

**With sub-agents (e.g., Claude Code):** Perform testing directly — predict reader questions, test with sub-agent, check for ambiguity/contradictions, report and fix issues.

**Without sub-agents (e.g., claude.ai):** Guide user to open a fresh conversation, paste the doc, and test with predicted reader questions.

**Exit condition:** Reader Claude consistently answers correctly and doesn't surface new gaps.

→ See [references/stage3-reader-testing.md](references/stage3-reader-testing.md) for full detail

## Final Review

1. Recommend user does a final read-through — they own the document
2. Suggest double-checking facts, links, technical details
3. Verify it achieves the desired impact

Completion tips:
- Consider linking this conversation in an appendix
- Use appendices for depth without bloating the main doc
- Update as feedback is received from real readers

## Tips

- **Tone:** Direct and procedural; don't sell the approach, just execute it
- **Deviations:** User can skip stages or switch to freeform at any point; always give agency
- **Context:** Proactively ask about missing context; don't let gaps accumulate
- **Artifacts:** `create_file` for drafting sections, `str_replace` for all edits; never use artifacts for brainstorming lists
- **Quality over speed:** Each iteration should make meaningful improvements; the goal is a doc that works for readers

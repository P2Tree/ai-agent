---
name: humanizer
description: Use when the user wants to remove AI writing patterns from text, make AI-generated content sound more natural and human, or review text for machine-like phrasing. 触发词：去AI味、人性化、润色、去机器味、humanize、deAI、自然化
allowed-tools: [Read, Write, Edit, AskUserQuestion]
---

# Humanizer: 去除 AI 写作痕迹

识别并修改文本中的 AI 写作模式，使文字更自然、更有人味。

## Core Flow

1. **Read text** → 2. **Scan patterns** → 3. **Rewrite** → 4. **Self-check** → 5. **Deliver**

## Step 1: Identify Scope

- Accept text directly, a file path, or "check the current file"
- Ask user about desired tone (formal, casual, technical, narrative)
- If processing a file, read it fully before making changes

## Step 2: Scan for Patterns

Check against the 24 AI writing patterns in [ai-patterns.md](references/ai-patterns.md), organized into four categories:

| Category | Count | Key Signs |
|----------|-------|-----------|
| Content | 6 | Inflated significance, promo language, vague attribution |
| Language | 6 | AI buzzwords, copula avoidance, rule-of-three, synonym cycling |
| Style | 6 | Dash/bold overuse, emoji, inline heading lists, curly quotes |
| Filler | 6 | Chat residues, cutoff disclaimers, sycophancy, hedging |

## Step 3: Rewrite

Five core rules:

1. **Delete filler** — remove throat-clearing and emphasis crutches
2. **Break formulas** — avoid binary contrasts, dramatic pauses, rhetorical setups
3. **Vary rhythm** — mix sentence lengths; two items > three; vary paragraph endings
4. **Trust the reader** — state facts directly; skip softening, hedging, hand-holding
5. **Kill the soundbite** — if it sounds quotable, rewrite it

Beyond removing patterns, inject genuine voice — have opinions, admit uncertainty, use first person when appropriate, allow some messiness. See [ai-patterns.md](references/ai-patterns.md) for details.

## Step 4: Self-Check

Before delivering, verify:

- [ ] Three consecutive sentences same length? Break one
- [ ] Paragraph ends with a tidy one-liner? Vary it
- [ ] Dash before a reveal? Remove it
- [ ] Explaining a metaphor? Trust the reader
- [ ] Using "此外""然而" as connectors? Consider dropping
- [ ] Three-item list? Change to two or four

## Step 5: Deliver

Output:
1. The rewritten text
2. Optional: brief summary of changes made

Ask user if they want adjustments to tone or emphasis.

## Boundary with Coauthoring

This skill polishes existing text. For producing new content from scratch with human voice built in, use coauthoring instead. Coauthoring should suggest using humanizer as a final pass.

## Reference

- [ai-patterns.md](references/ai-patterns.md) — 24 AI writing patterns with before/after examples

---
name: project-highlight
description: Use when the user wants to extract key contributions from a repository and format them as project highlights — resume bullets, interview talking points, performance review summaries, or general project descriptions. 触发词：项目经验、简历项目、面试描述、项目描述、述职描述、project highlight、resume project
argument-hint: [repository-path]
allowed-tools: [Read, Glob, Grep, Bash]
---

# Project Highlight Generator

Extract key contributions from a git repository and format them as scenario-specific project highlights.

## Core Flow

1. **Identify target** → 2. **Select scenario** → 3. **Collect data** → 4. **Confirm with user** → 5. **Generate & iterate**

## Step 1: Identify Target

- Use argument as repo path, or default to current working directory
- Detect git user: `git config user.name` or list authors from `git log`
- If multiple authors or ambiguous identity, ask user to confirm
- Verify repo is accessible and has commits

## Step 2: Clarify Scenario

Ask which scenario the user needs (this determines data collection depth):

| Scenario | Key | Focus | Length |
|----------|-----|-------|--------|
| Resume | 简历 | Concise, action-oriented, quantified | 3-5 bullets |
| Interview | 面试 | STAR narrative, conversational | 2-3 min spoken |
| Performance review | 述职 | Impact + metrics + comparison | Structured sections |
| General intro | 通用介绍 | Balanced overview | 1-2 paragraphs |

Templates and style: [scenario-templates.md](references/scenario-templates.md), [style-guide.md](references/style-guide.md)

**Boundary with work-report**: This skill extracts contribution data from a codebase. For structured corporate reports (日报/周报/月报/季报/年度总结), use work-report instead. This skill's 述职 output focuses on project-level contribution summary; work-report's 述职 covers broader periodic reporting.

## Step 3: Collect Data

Run git analyses based on the chosen scenario (commands in [data-collection.md](references/data-collection.md)):

- **All scenarios**: commit stats, date range, module map
- **Resume / Interview**: additionally extract feature commits, key fixes, quantified impact
- **Performance review**: additionally extract scope analysis, cross-module contributions, keyword clustering
- **General intro**: basic commit stats and module overview only

After automated collection, present findings and ask user to confirm or supplement:

- "I identified these modules as your primary areas: [...]. Does this match?"
- "Are there contributions not reflected in git? (design docs, reviews, mentoring)"
- "Any specific achievements you want highlighted?"

## Step 4: Generate

Based on collected data and chosen scenario, produce output following the corresponding template. Key principles:

- Every claim backed by evidence from git history or user confirmation
- Quantify where possible: commit counts, line changes, module count, time span
- Use active voice for resume, narrative voice for interview
- Default language: Chinese (match user preference)
- No fabricated data — mark uncertain items as "待确认"

## Step 5: Iterate

Present draft, then:

- Ask if emphasis or tone needs adjustment
- Offer to regenerate for a different scenario
- Suggest follow-up: "Want me to also generate for interview format?"

## Self-Check

Before delivering, verify:

- [ ] All technical claims traceable to git data or user input?
- [ ] No fabricated metrics or invented achievements?
- [ ] Output matches requested scenario's style rules?
- [ ] Technical terms accurate for the domain?
- [ ] Language appropriate (Chinese default, unless English requested)?

## Reference Files

- [data-collection.md](references/data-collection.md) — git analysis commands and heuristics
- [scenario-templates.md](references/scenario-templates.md) — full templates for each output scenario
- [style-guide.md](references/style-guide.md) — writing style rules per scenario

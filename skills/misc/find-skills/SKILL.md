---
name: find-skills
description: Discover and install agent skills from the open skills ecosystem. Use when the user asks "how do I do X", "find a skill for X", "is there a skill that can...", or when current skills don't cover the user's need and an external skill might help.
---

# Find Skills

When the user's need falls outside what the local repo covers, search the open skills ecosystem for a match.

## When to Trigger

- User asks "how do I do X" where X might have an existing skill
- User says "find a skill for X" or "is there a skill for X"
- Current skills don't address the user's problem well
- User wants to extend agent capabilities in a specific domain

## Process

### 1. Clarify the Need

Identify the domain (e.g., React, testing, deployment) and the specific task (e.g., writing E2E tests, creating animations). If the need is already covered by a local skill, recommend that first.

### 2. Search the Ecosystem

Use the Skills CLI to search:

```bash
npx skills find [query]
```

Pick keywords that match the domain and task. Examples:

- "how do I make my React app faster?" -> `npx skills find react performance`
- "can you help me with PR reviews?" -> `npx skills find pr review`
- "I need to create a changelog" -> `npx skills find changelog`

You can also browse the leaderboard at <https://skills.sh/> for popular options.

### 3. Verify Before Recommending

**Do not recommend a skill based solely on search results.** Always check:

- **Install count** — prefer skills with 1K+ installs; be cautious under 100
- **Source reputation** — official sources (e.g., `anthropics`, `vercel-labs`, `microsoft`) are more trustworthy than unknown authors
- **GitHub stars** — a skill from a repo with <100 stars should be treated with skepticism

### 4. Present Options

Show the user:

1. Skill name and what it does
2. Install count and source
3. Link to learn more

Example:

```
I found a skill that might help! The "react-best-practices" skill provides
React and Next.js performance optimization guidelines from Vercel Engineering.
(185K installs)

Learn more: https://skills.sh/vercel-labs/agent-skills/react-best-practices
```

### 5. Install If Requested

If the user wants to proceed, run:

```bash
npx skills add <owner/repo@skill>
```

The skill will be installed to the agent's skill directory.

### 6. When Nothing Is Found

If no relevant skills exist:

1. Acknowledge that no match was found
2. Offer to help directly with general capabilities
3. Suggest creating a custom skill if this is a recurring need

## Common Search Categories

| Category        | Example Queries                          |
| --------------- | ---------------------------------------- |
| Web Development | react, nextjs, typescript, css, tailwind |
| Testing         | testing, jest, playwright, e2e           |
| DevOps          | deploy, docker, kubernetes, ci-cd        |
| Documentation   | docs, readme, changelog, api-docs        |
| Code Quality    | review, lint, refactor, best-practices   |
| Design          | ui, ux, design-system, accessibility     |
| Productivity    | workflow, automation, git                |

## Notes

- Always recommend local skills over external ones when both cover the same need
- The Skills CLI is a community registry — quality varies, so always verify before recommending
- If the user frequently needs an external skill, consider whether it should be absorbed into the local repo

## Reference

vercel-labs/skills:find-skills

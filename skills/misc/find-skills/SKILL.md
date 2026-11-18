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

## Skills CLI

`npx skills` is the package manager for the open skills ecosystem.

- `npx skills find [query] [--owner <owner>]` — search by keyword, optionally scoped to a GitHub owner
- `npx skills add <package>` — install a skill
- `npx skills update` — update all installed skills

Browse the leaderboard at <https://skills.sh/>.

## Process

### 1. Clarify the Need

Identify the domain (e.g., React, testing, deployment) and the specific task (e.g., writing E2E tests, creating animations). If the need is already covered by a local skill, recommend that first.

### 2. Check the Leaderboard First

Before running a CLI search, check the [skills.sh leaderboard](https://skills.sh/) for a well-known skill in the domain. It ranks by total installs and surfaces battle-tested options.

Top sources include:

- `vercel-labs/agent-skills` — React, Next.js, web design (100K+ installs each)
- `anthropics/skills` — frontend design, document processing (100K+ installs)

### 3. Search the Ecosystem

If the leaderboard doesn't cover the need:

```bash
npx skills find [query] [--owner <owner>]
```

Examples:

- "how do I make my React app faster?" -> `npx skills find react performance`
- "can you help me with PR reviews?" -> `npx skills find pr review`
- "I need to create a changelog" -> `npx skills find changelog`

Use specific keywords; if a term fails, try alternatives ("deploy" -> "deployment" / "ci-cd").

### 4. Verify Before Recommending

**Do not recommend a skill based solely on search results.** Always check:

- **Install count** — prefer skills with 1K+ installs; be cautious under 100
- **Source reputation** — official sources (e.g., `anthropics`, `vercel-labs`, `microsoft`) are more trustworthy than unknown authors
- **GitHub stars** — a skill from a repo with <100 stars should be treated with skepticism

### 5. Present Options

Show the user:

1. Skill name and what it does
2. Install count and source
3. The install command they can run
4. Link to learn more

Example:

```
I found a skill that might help! The "react-best-practices" skill provides
React and Next.js performance optimization guidelines from Vercel Engineering.
(185K installs)

To install it:
npx skills add vercel-labs/agent-skills@react-best-practices

Learn more: https://skills.sh/vercel-labs/agent-skills/react-best-practices
```

### 6. Install If Requested

```bash
npx skills add <owner/repo@skill> -g -y
```

`-g` installs globally (user-level) and `-y` skips confirmation prompts.

### 7. When Nothing Is Found

If no relevant skills exist:

1. Acknowledge that no match was found
2. Offer to help directly with general capabilities
3. Suggest creating a custom skill with `npx skills init <my-skill>`

```
I searched for skills related to "xyz" but didn't find any matches.
I can still help you with this task directly! Would you like me to proceed?

If this is something you do often, you could create your own skill:
npx skills init my-xyz-skill
```

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
- For PDF/Office document work, prefer the official `anthropics/skills` versions; they are not bundled here
- The Skills CLI is a community registry — quality varies, so always verify before recommending
- If the user frequently needs an external skill, consider whether it should be absorbed into the local repo

## Reference

vercel-labs/skills:find-skills

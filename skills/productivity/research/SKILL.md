---
name: research
description: Investigate a question against high-trust primary sources and capture the findings as a cited Markdown file. Use when the answer must be durable or cited, when reading is large enough to delegate to a background agent, or when the user asks to research a topic, gather docs or API facts, or delegate reading. Do not use for a quick lookup you can answer in-session, or when the facts already exist in the repo or conversation.
---

# Research

Spin up a **background agent** with a fresh context window, so you keep working while it reads.

## Delegation

- Ask before starting the background agent, unless the user already asked for research.
- Give it the question, suggested sources/starting points, and the output file path. Let it explore as widely as the question needs.
- Do not cap findings. Require citations, an **unverified** section, and a note on what it did not check.
- Track elapsed time. At the soft threshold, tell the user how long it has run and ask whether to keep waiting or cancel and do a quick inline search. Never cancel on your own.

## When to Use

- The answer needs a **durable, cited artifact** (API behavior, standards, competitive research, technology selection).
- Reading is large enough that it would pollute the main conversation.
- The work can run in parallel while the main session continues.

## When Not to Use

- One search or one file read answers it.
- The facts are already in the repo, the conversation, or user-provided material.
- The question is a product judgment or trade-off, not a fact-finding task.

## Output

1. Investigate **primary sources** (official docs, source code, specs, first-party APIs), not secondary summaries. Follow every claim back to the source that owns it.
2. Write findings to a single Markdown file, citing each claim's source.
3. Prefer the repo's existing notes location; if there is none, use `docs/research/YYYY-MM-DD-<topic>.md` and say where you put it.
4. Mark anything you could not verify as **unverified**; never invent a source.

## Next

- **brainstorming / grill-me** — turn the findings into a design decision.
- **writing-plans** — when the research already settles the approach.

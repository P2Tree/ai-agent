---
name: create-skill
description: Create new skills, modify and improve existing skills, and measure skill performance. Use when users want to create a skill from scratch, edit, or optimize an existing skill, run evals to test a skill, benchmark skill performance with variance analysis, or optimize a skill's description for better triggering accuracy.
---

# Skill Creator

A skill for creating new skills and iteratively improving them.

**Core loop:** Decide intent → Draft skill → Run test prompts → Evaluate (qualitative + quantitative) → Improve → Repeat. Figure out where the user is in this process and jump in. Be flexible — if the user says "just vibe with me", do that instead.

After the skill is done, offer to run the description optimizer for better triggering accuracy.

## Communicating with the user

Users range from experienced developers to people opening a terminal for the first time. Read context cues and match their vocabulary. "Evaluation" and "benchmark" are usually safe; use "JSON" and "assertion" only when the user shows they know those terms, otherwise explain briefly.

For the writing reference behind any document an agent consumes — context pointers, the two loads, information hierarchy, completion criteria, leading words, pruning — see [writing for agents](references/writing-for-agents.md). For skill-specific mechanics (model- vs user-invoked, splitting, routers), see [skill mechanics](references/skill-mechanics.md).

## Creating a skill

### Capture Intent

Start by understanding the user's intent. Extract answers from conversation history first, then ask the user to fill gaps. Key questions:

1. What should this skill enable Claude to do?
2. When should this skill trigger? (what user phrases/contexts)
3. What's the expected output format?
4. Should we set up test cases? Skills with objectively verifiable outputs benefit from them; subjective skills often don't. Suggest the default, but let the user decide.

### Interview and Research

Proactively ask about edge cases, I/O formats, example files, success criteria, and dependencies. Check available MCPs for research. Come prepared with context.

### Write the SKILL.md

Fill in: **name**, **description** (when to trigger + what it does; make it a bit "pushy" — e.g., "Use this skill whenever the user mentions dashboards, data visualization, or wants to display company data, even if they don't explicitly ask for a 'dashboard.'"), **compatibility** (optional), and the skill body.

Writing decisions that matter most:

- **Description as a context pointer.** Its wording, not its target, decides when the skill fires. Front-load the leading word, give one trigger per genuinely distinct branch, and cut identity the body already carries.
- **Information hierarchy.** Keep steps in-file; push reference that only some branches need behind a pointer. Inline what every branch needs.
- **Completion criteria.** Every step needs a checkable, exhaustive "done" condition. Sharpen the bound before hiding later steps.
- **Leading words and positive phrasing.** Anchor behaviour with a compact pretrained concept; state the target behaviour instead of prohibitions.
- **Prune.** One source of truth; don't cache what the environment already answers; delete no-op sentences whole.

For the skill writing guide (anatomy, progressive disclosure, writing patterns, style), see [Detailed Workflow](references/detailed-workflow.md#skill-writing-guide).

### Test Cases

Come up with 2-3 realistic test prompts, share with the user, save to `evals/evals.json`. Don't write assertions yet — draft those while runs are in progress. See `references/schemas.md` for the full schema.

---

## Running and evaluating test cases

One continuous sequence — don't stop partway. Do NOT use `/skill-test` or any other testing skill.

Put results in `<skill-name>-workspace/` (sibling to skill directory). Organize by iteration (`iteration-1/`, etc.) and test case (`eval-0/`, etc.).

1. **Spawn all runs** (with-skill AND baseline) in the same turn. Baseline = no skill (new) or old skill snapshot (improving). Write `eval_metadata.json` per test case.
2. **While runs run, draft assertions** — objectively verifiable, descriptive names. Update `evals/evals.json` and `eval_metadata.json`.
3. **Capture timing data** as runs complete — save `total_tokens`/`duration_ms` to `timing.json` immediately (only available from task notification).
4. **Grade, aggregate, launch viewer:**
   - Grade using `agents/grader.md`; save `grading.json` (fields: `text`/`passed`/`evidence`)
   - Aggregate: `python -m scripts.aggregate_benchmark <workspace>/iteration-N --skill-name <name>`
   - Analyst pass: see `agents/analyzer.md`
   - Launch viewer: `python <create-skill-path>/eval-viewer/generate_review.py <workspace>/iteration-N --skill-name "my-skill" --benchmark <workspace>/iteration-N/benchmark.json`
   - Cowork/headless: add `--static <output_path>`
5. **Read feedback** from `feedback.json` after user review. Kill viewer when done.

Full details: [Detailed Workflow](references/detailed-workflow.md#running-and-evaluating-test-cases--full-details)

---

## Improving the skill

Key principles:

- **Generalize from feedback** — don't overfit to test examples
- **Keep the prompt lean** — remove what isn't pulling its weight
- **Explain the why** — prefer reasoning over rigid MUSTs/NEVERs
- **Bundle repeated work** — if subagents all write the same helper script, put it in `scripts/`

### Iteration loop

1. Apply improvements → 2. Rerun tests into `iteration-<N+1>/` with baselines → 3. Launch reviewer with `--previous-workspace` → 4. Wait for user → 5. Read feedback, repeat. Stop when: user is happy, feedback is all empty, or no meaningful progress.

Full guidance: [Detailed Workflow](references/detailed-workflow.md#improving-the-skill--detailed-guidance)

---

## Advanced: Blind comparison

For rigorous A/B comparison between skill versions, read `agents/comparator.md` and `agents/analyzer.md`. Optional, requires subagents.

---

## Description Optimization

After creating or improving a skill, offer to optimize the description:

1. **Generate 20 trigger eval queries** — 8-10 should-trigger, 8-10 near-miss should-not-trigger. Must be realistic and specific.
2. **Review with user** using `assets/eval_review.html` template.
3. **Run optimization**: `python -m scripts.run_loop --eval-set <path> --skill-path <path> --model <model-id> --max-iterations 5 --verbose`
4. **Apply result** — update SKILL.md frontmatter with `best_description`.

Full details: [Detailed Workflow](references/detailed-workflow.md#description-optimization--full-details)

---

## Platform differences

- **Claude.ai**: No subagents — run tests inline, skip baselines and benchmarking, skip description optimization, present results in conversation.
- **Cowork**: Subagents work. Use `--static` for viewer. Always generate viewer BEFORE self-evaluating. Feedback downloads as `feedback.json`.
- **Updating existing skills**: Preserve original name. Copy to `/tmp/` before editing if installed path is read-only.

Full details: [Detailed Workflow](references/detailed-workflow.md#platform-specific-instructions)

---

## Reference files

- `agents/grader.md` / `agents/comparator.md` / `agents/analyzer.md` — Subagent instructions
- `references/schemas.md` — JSON schemas (evals, grading, benchmark, etc.)
- `references/detailed-workflow.md` — Expanded instructions for each stage
- `references/writing-for-agents.md` — Writing documents agents consume
- `references/skill-mechanics.md` — Invocation choice, splitting, router skills

### Package and Present (only if `present_files` tool available)

```bash
python -m scripts.package_skill <path/to/skill-folder>
```

---

Remember: Create evals JSON and run `eval-viewer/generate_review.py` so the human can review test cases — don't skip this step.

Good luck!

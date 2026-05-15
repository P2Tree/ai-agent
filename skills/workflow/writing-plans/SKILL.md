---
name: writing-plans
description: Write comprehensive implementation plans with bite-sized tasks. Use when you have a spec or requirements for a multi-step task, before touching code.
---

# Writing Plans

Write implementation plans assuming the engineer has zero context and questionable taste. Document everything: which files to touch, code, testing, how to verify. Bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

## Pre-flight: read agent environment

Read the repo's agent environment (set up by `/init-agent-environment`) to write plans that are consistent with the project's domain and architecture:

- **`docs/agents/domain.md`** — tells you where `CONTEXT.md` and `docs/adr/` live. Read `CONTEXT.md` so you use the project's own domain terminology in task names, variable names, and commit messages. Read relevant ADRs so your plan doesn't propose something that contradicts an established architectural decision — if it must contradict, flag it explicitly in the plan (e.g. "_Contradicts ADR-0003 — justified because…_").
- **`docs/agents/issue-tracker.md`** — tells you how the project tracks work. If the plan's tasks should be published as issues, use the conventions in this file.
- **`docs/agents/triage-labels.md`** — if publishing tasks as issues, apply the correct triage label strings from this file.

If these files don't exist, proceed silently — don't block plan writing on missing config.

**Save plans to:** `docs/plans/YYYY-MM-DD-<feature-name>.md`

## Scope Check

If the spec covers multiple independent subsystems, suggest breaking into separate plans — one per subsystem. Each plan should produce working, testable software on its own.

## File Structure

Before defining tasks, map out which files will be created or modified and what each one is responsible for.

- Each file should have one clear responsibility
- Prefer smaller, focused files over large ones
- Files that change together should live together
- In existing codebases, follow established patterns

This structure informs the task decomposition.

## Bite-Sized Task Granularity

Each step is one action:

- "Write the failing test" — step
- "Run it to make sure it fails" — step
- "Write minimal code to pass" — step
- "Run the tests" — step
- "Commit" — step

## Plan Document Header

Every plan MUST start with this header:

```markdown
# [Feature Name] Implementation Plan

> Use executing-plans to implement this plan task-by-task.

**Goal:** [One sentence]
**Architecture:** [2-3 sentences]
**Tech Stack:** [Key technologies]

---
```

## Task Structure

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

- [ ] **Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

- [ ] **Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL

- [ ] **Step 3: Write minimal implementation**

- [ ] **Step 4: Run test to verify it passes**

- [ ] **Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```
````

## No Placeholders

Every step must contain the actual content an engineer needs. These are plan failures:

- "TBD", "TODO", "implement later", "fill in details"
- "Add appropriate error handling" / "add validation" / "handle edge cases"
- "Write tests for the above" (without actual test code)
- "Similar to Task N" (repeat the code)
- Steps that describe what to do without showing how
- References to types or functions not defined in any task

## Self-Review

After writing the complete plan, check:

1. **Spec coverage:** Can you point to a task for each requirement?
2. **Placeholder scan:** Any red flags from the "No Placeholders" section?
3. **Type consistency:** Do types and method signatures match across tasks?

Fix issues inline. If a spec requirement has no task, add it.

## Execution Handoff

After saving the plan, offer execution choice:

1. **Dispatching Agents** — fresh subagent per task, two-stage review, fast iteration
2. **Inline Execution** — execute tasks in this session with checkpoints

See [detailed workflow](references/workflow-detail.md) for more.

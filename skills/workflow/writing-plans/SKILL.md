---
name: writing-plans
description: Write comprehensive implementation plans with bite-sized tasks. Use when you have a spec or requirements for a multi-step task, before touching code.
---

# Writing Plans

Write for an engineer who has not seen this codebase or this spec. Assume they write idiomatic code once they know the exact interface and the exact test, and make a reasonable choice wherever the plan leaves one open. What they cannot know is what you decided: which files, which names and signatures, which values from the spec, which tests prove each task. Document those. Bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

## Pre-flight

- Read `GLOSSARY.md` and relevant `docs/adr/` if they exist; use their terms, and flag any task that deliberately contradicts an ADR.
- Read the source spec, but treat older specs/plans as historical. Only the latest relevant spec is authoritative.
- If the work was split into issues, record the issue IDs and whether this plan covers one issue or the whole spec.
- Add `**Status:** draft | approved | implemented | superseded` and `**Date:** YYYY-MM-DD` to the plan header.
- If the task defines or changes an interface or seam, invoke **codebase-design** before writing the Interfaces block.

**Source spec:** `docs/specs/YYYY-MM-DD-<spec_name>.md` (if produced by brainstorming) · **Save plans to:** `docs/plans/YYYY-MM-DD-<feature-name>.md` · **Language:** if the source spec/PRD is entirely in English, write the plan in English; otherwise, follow the source materials.

## Scope Check

If the spec covers multiple independent subsystems, suggest breaking it into separate plans — one per subsystem. Each plan should produce working, testable software on its own.

## File Structure

Before defining tasks, map out which files will be created or modified and what each is responsible for. This is where decomposition decisions get locked in.

- Each file has one clear responsibility; prefer smaller, focused files. Files that change together live together; split by responsibility, not technical layer.
- In existing codebases, follow established patterns. Don't unilaterally restructure, but a split of an unwieldy file you are already touching is reasonable.

## Task Right-Sizing

A task is the smallest unit that carries its own test cycle and is worth a fresh reviewer's gate. Fold setup, configuration, scaffolding, and documentation into the task whose deliverable needs them. Split only where a reviewer could meaningfully reject one task while approving its neighbor. Each task ends with an independently testable deliverable.

## Step Granularity

Each step is one action with a checkable result: write the failing test; run it and watch it fail; write minimal code; run it and watch it pass; commit.

## Test-First Plan

- Test only at **pre-agreed seams**. Before writing tasks, list the seams with what each catches and misses, and confirm them with the user. Fewer, higher seams are better — ideally one.
- Each task is a **vertical slice**: one test → minimal implementation → repeat. Never write all tests first; that is horizontal slicing.
- A test step names the test and its assertions, with expected values from the spec, a known-good literal, or a worked example. Never recompute the expected value the way the code does (tautological test).
- The plan must make the implementer **watch the test fail, then pass**. Expected output must be real output, not "should pass".
- Refactoring is not part of the red-green loop. Put refactor work in the task's review/cleanup or in **code-review**.

## Plan Document Header

Every plan MUST start with this header:

```markdown
# [Feature Name] Implementation Plan

> Use executing-plans to implement this plan task-by-task.

**Spec:** `docs/specs/YYYY-MM-DD-<spec_name>.md`
**Goal:** [One sentence]
**Architecture:** [2-3 sentences]
**Tech Stack:** [Key technologies]
## Global Constraints

[The spec's project-wide requirements — version floors, dependency limits,
naming and copy rules, platform requirements — one line each, exact values
copied verbatim from the spec. Every task implicitly inherits this section.]

## Review Focus

[The five input classes or failure modes the spec implies but no task's tests
exercise that are most likely to bite a user — one line each, naming the input
or condition and the behavior a reasonable person expects, most likely first.
The spec's silence on an input is not permission for that input to break the
program. For each line, add the test that pins it to the task owning the code.]
---
```

## Task Structure

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`
**Interfaces:**
- Consumes: [what this task uses from earlier tasks — exact signatures]
- Produces: [what later tasks rely on — exact names, parameter and return types]

- [ ] **Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

- [ ] **Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

- [ ] **Step 3: Implement `function(input: InputType) -> ResultType` in `exact/path/to/file.py`**

One line on the approach when the signature and test leave a choice; a code block only for an algorithm they do not determine.

- [ ] **Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```
````

## What a Step Contains

A step is done when the implementer can write exactly one reasonable thing from it. That is the whole requirement: unambiguous, not complete.

- **A test step:** the test's name and assertions, as code, with the spec's exact values.
- **A code step:** the exact signature (name, parameters, return type), the file, and the values the spec pins. The implementer writes the body. A body appears only for an algorithm the signature and tests do not determine, or for exact copy the spec fixes.
- **A verification step:** the command and the output that means it passed.
- **A reference to another task:** use that task's Interfaces block; don't repeat its code.

A plan is the set of decisions the implementer cannot make alone. A plan longer than the code it describes has written the code instead. Lines that decide nothing — "TBD", "handle edge cases", "add appropriate validation", "write tests for the above", a type or function no task defines — are the opposite failure.

## Self-Review

After writing the plan, check it against the spec yourself — do not dispatch a subagent.

1. **Spec coverage:** can you point to a task for each requirement?
2. **Step scan:** can the implementer write exactly one reasonable thing from each step, and no more? A line that decides nothing is a gap; a body the signature and tests determine is a transcript.
3. **Consistency:** do types, signatures, and property names match across tasks? Does any task contradict an ADR without a flag? Do names use glossary terms? For interface/seam changes, was codebase-design consulted?
4. **Review Focus:** does each listed input class or failure mode have a test in the owning task? An empty section means you checked and found none.
5. **Proportion:** is the plan several times longer than the spec? If code blocks dominate, replace bodies with signatures, test names and assertions.

Fix issues inline. If a spec requirement has no task, add it.

## Execution Handoff

After saving and self-reviewing, link the plan for the user and ask them to review it. If they already supplied an execution method, confirm the plan captures what they want and wait for review before implementing. Otherwise, ask which approach to use before implementation:

- **Subagent-driven** — a fresh subagent implements each task and a fresh reviewer checks it before the next, then a whole-branch review. Most thorough; costs a fresh context per task and review.
- **Inline** — you implement every task in this session, then one fresh reviewer checks the whole branch. Cheapest and fastest, but no independent review until the end.

Recommend one with a one-sentence reason (task independence, task count/context pressure, cost of a shipped mistake), then use **executing-plans**.

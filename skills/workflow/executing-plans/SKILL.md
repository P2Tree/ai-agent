---
name: executing-plans
description: Execute a written implementation plan step-by-step with review checkpoints. Use when you have a plan to execute in the current session, need subagent-driven execution with two-stage review, or face multiple independent tasks.
---

# Executing Plans

Three modes: **inline** (step-by-step), **subagent-driven** (sequential tasks with review), and **parallel** (independent tasks simultaneously).

## Mode 1: Inline Execution

Load plan, review critically, execute all tasks, report when complete.

### Step 1: Load and Review Plan

1. Read plan file
2. Review critically — identify any questions or concerns
3. If concerns: raise them before starting
4. If no concerns: create task list and proceed

### Step 2: Execute Tasks

For each task:

1. Mark as in_progress
2. Follow each step exactly (plan has bite-sized steps)
3. Run verifications as specified
4. Mark as completed

### Step 3: Complete Development

After all tasks complete and verified:

- Verify tests pass, then present integration options to the user

## Mode 2: Subagent-Driven Development

Execute plan by dispatching fresh subagent per task, with two-stage review after each: spec compliance first, then code quality.

**Core principle:** Fresh subagent per task + two-stage review = high quality, fast iteration.

### When to Use

- Have an implementation plan with mostly independent tasks
- Staying in the current session
- Want review checkpoints between tasks

### The Process

1. Read plan, extract all tasks with full text, create task list
2. For each task:
   a. Dispatch implementer subagent with full task text + context
   b. If implementer asks questions → answer, then re-dispatch
   c. Dispatch spec reviewer — verify code matches spec (nothing missing, nothing extra)
   d. If spec issues → implementer fixes → re-review
   e. Dispatch code quality reviewer
   f. If quality issues → implementer fixes → re-review
   g. Mark task complete
3. After all tasks: dispatch final reviewer for entire implementation
4. Verify tests pass, then present integration options to the user

### Model Selection

- **Mechanical tasks** (1-2 files, clear spec): cheap/fast model
- **Integration tasks** (multi-file, debugging): standard model
- **Architecture/review tasks**: most capable model

### Handling Implementer Status

- **DONE:** Proceed to spec review
- **DONE_WITH_CONCERNS:** Read concerns. Address if about correctness; note if observations
- **NEEDS_CONTEXT:** Provide missing info and re-dispatch
- **BLOCKED:** Assess blocker — provide context, upgrade model, or break task smaller

### Prompt Templates

See [implementer prompt](references/implementer-prompt.md), [spec reviewer prompt](references/spec-reviewer-prompt.md), [code quality reviewer prompt](references/code-quality-reviewer-prompt.md).

## Mode 3: Parallel Agent Dispatch

When facing 2+ independent problems, dispatch one agent per problem domain concurrently.

### When to Use

- Multiple independent failures (different test files, different subsystems)
- Each problem can be understood without context from others
- No shared state between investigations

**Don't use when:** failures are related, need full system context, or agents would interfere.

### The Pattern

1. **Identify independent domains** — group failures by what's broken
2. **Create focused tasks** — each agent gets: specific scope, clear goal, constraints, expected output
3. **Dispatch in parallel** — all agents run concurrently
4. **Review and integrate** — read summaries, verify no conflicts, run full test suite

### Agent Prompt Structure

Good prompts are:

1. **Focused** — one clear problem domain
2. **Self-contained** — all context needed
3. **Specific about output** — what should the agent return

## When to Stop and Ask

**STOP immediately when:**

- Hit a blocker (missing dependency, test fails, instruction unclear)
- Plan has critical gaps preventing starting
- You don't understand an instruction
- Verification fails repeatedly

Ask for clarification rather than guessing.

## When to Revisit Earlier Steps

**Return to Review when:**

- Partner updates the plan based on your feedback
- Fundamental approach needs rethinking

Don't force through blockers — stop and ask.

## Red Flags

**Never:**

- Skip reviews (spec compliance OR code quality)
- Proceed with unfixed issues
- Dispatch multiple implementation subagents in parallel (conflicts)
- Make subagent read plan file (provide full text instead)
- Ignore subagent questions
- Accept "close enough" on spec compliance
- Start code quality review before spec compliance passes
- Move to next task while review has open issues
- Skip verifications
- Start implementation on main/master without explicit user consent

## Related Skills

- **writing-plans** — creates the plan this skill executes

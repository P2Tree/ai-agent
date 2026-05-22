---
name: executing-plans
description: Execute a written implementation plan step-by-step with review checkpoints. Use when you have a plan to execute in the current session, need subagent-driven execution with two-stage review, or face multiple independent tasks.
---

# Executing Plans

Three modes: **inline** (step-by-step), **subagent-driven** (sequential tasks with review), and **parallel** (independent tasks simultaneously).

## Choose Execution Mode

Before starting, present the three modes with your recommendation, and let the user decide:

1. **Inline** — step-by-step in this session. Good for small plans or full control.
2. **Subagent-Driven** — fresh subagent per task + two-stage review. Good for independent tasks needing review checkpoints.
3. **Parallel** — one agent per independent domain concurrently. Good for independent failures with no shared state.

Recommend the best fit, but the final choice is the user's.

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

- Use finishing-branch skill to verify tests, present options, execute choice

## Mode 2: Subagent-Driven Development

Fresh subagent per task + two-stage review = high quality, fast iteration.

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
4. Use finishing-branch skill

### Model Selection

- **Mechanical** (1-2 files, clear spec): cheap/fast model
- **Integration** (multi-file, debugging): standard model
- **Architecture/review**: most capable model

### Handling Implementer Status

- **DONE:** Proceed to spec review
- **DONE_WITH_CONCERNS:** Read concerns. Address if about correctness; note if observations
- **NEEDS_CONTEXT:** Provide missing info and re-dispatch
- **BLOCKED:** Assess blocker — provide context, upgrade model, or break task smaller

### Prompt Templates

See [implementer prompt](references/implementer-prompt.md), [spec reviewer prompt](references/spec-reviewer-prompt.md), [code quality reviewer prompt](references/code-quality-reviewer-prompt.md).

## Mode 3: Parallel Agent Dispatch

Dispatch one agent per independent problem domain concurrently.

### When to Use

- Multiple independent failures (different subsystems, no shared state)

**Don't use when:** failures are related, need full system context, or agents would interfere.

### The Pattern

1. **Identify independent domains** — group failures by what's broken
2. **Create focused tasks** — each agent gets: specific scope, clear goal, constraints, expected output
3. **Dispatch in parallel** — all agents run concurrently
4. **Review and integrate** — read summaries, verify no conflicts, run full test suite

### Agent Prompt Structure

Good prompts are: focused (one domain), self-contained (all context), specific about output.

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

**Never:** skip reviews, proceed with unfixed issues, dispatch multiple implementation subagents in parallel (conflicts), make subagent read plan file (provide full text instead), ignore subagent questions, accept "close enough" on spec compliance, start code quality review before spec compliance passes, move to next task while review has open issues, skip verifications, start implementation on main/master without explicit user consent.

## Next Steps

- **finishing-branch** — verify tests, present options for merge, PR, or cleanup

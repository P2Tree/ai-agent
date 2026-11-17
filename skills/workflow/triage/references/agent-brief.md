# Writing Agent Briefs

An agent brief is a structured comment posted on an issue or PR when it moves to `ready-for-agent`. It is the authoritative specification an AFK agent works from; the original body and discussion are context, the brief is the contract.

For an issue, the brief describes building the change from nothing. For a PR, it describes what is left to do to the existing diff: finish it, close gaps, address review points.

## Principles

### Durability over precision

The issue may sit in `ready-for-agent` for days or weeks, and the codebase will change. Write so the brief stays useful after files are renamed, moved, or refactored.

- **Do** describe interfaces, types, and behavioral contracts.
- **Do** name specific types, signatures, or config shapes to look for or modify.
- **Don't** reference file paths or line numbers; they go stale.
- **Don't** assume the current implementation structure will remain the same.

### Behavioral, not procedural

Describe **what** the system should do, not **how** to implement it. The agent explores the codebase fresh and makes its own implementation decisions.

- Good: "The `SkillConfig` type should accept an optional `schedule` field of type `CronExpression`"
- Bad: "Open src/types/skill.ts and add a schedule field on line 42"

### Complete acceptance criteria

Every brief needs concrete, independently verifiable acceptance criteria.

- Good: "Running the list command with the needs-triage label returns issues that have been through initial classification"
- Bad: "Triage should work correctly"

### Explicit scope boundaries

State what is out of scope to prevent gold-plating and assumptions about adjacent features.

## Template

```markdown
## Agent Brief

**Category:** bug / enhancement
**Summary:** one-line description of what needs to happen

**Current behavior:**
Describe what happens now. For bugs, the broken behavior. For
enhancements, the status quo the feature builds on.

**Desired behavior:**
Describe what should happen after the work is complete. Be specific
about edge cases and error conditions.

**Key interfaces:**
- `TypeName`: what needs to change and why
- `functionName()` return type: current vs desired
- Config shape: any new options needed

**Acceptance criteria:**
- [ ] Specific, testable criterion 1
- [ ] Specific, testable criterion 2

**Out of scope:**
- Thing that should NOT be changed
- Adjacent feature that is separate
```

## Example (bug)

```markdown
## Agent Brief

**Category:** bug
**Summary:** Skill description truncation drops mid-word, producing broken output

**Current behavior:**
When a skill description exceeds 1024 characters, it is truncated at exactly
1024 characters regardless of word boundaries, ending mid-word.

**Desired behavior:**
Truncation breaks at the last word boundary before 1024 characters and appends
"...".

**Key interfaces:**
- `SkillMetadata.description`: no type change, but the validation logic that
  populates it must respect word boundaries
- Any function that reads SKILL.md frontmatter and extracts the description

**Acceptance criteria:**
- [ ] Descriptions under 1024 chars are unchanged
- [ ] Descriptions over 1024 chars are truncated at the last word boundary
- [ ] Truncated descriptions end with "..."
- [ ] Total length including "..." does not exceed 1024 chars

**Out of scope:**
- Changing the 1024 char limit itself
- Multi-line description support
```

## Bad brief

```markdown
## Agent Brief

**Summary:** Fix the triage bug

**What to do:**
The triage thing is broken. Look at the main file and fix it.
The function around line 150 has the issue.

**Files to change:**
- src/triage/handler.ts (line 150)
```

It lacks a category, is vague, cites stale line numbers, and has no acceptance criteria or scope boundaries.

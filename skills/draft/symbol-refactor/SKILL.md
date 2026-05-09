---
name: symbol-refactor
description: Scan all references before renaming, deleting, or modifying any Rust symbol. Use when renaming, deleting, or modifying Rust symbols (struct, trait, enum, function, variable, module).
---

# Symbol Refactor

When renaming, deleting, or modifying a symbol, the most common failure mode is **incomplete reference coverage** — code compiles but tests or docs silently break. This skill enforces a scan-first, sync-always workflow.

## Core Principles

> **Scan first, edit second, always sync.**

Applies to all types of symbol changes:
- Rename struct/enum/type/function
- Delete unused function/variable/field
- Extract code into a new function/module
- Inline variable or function
- Add/remove/rename function parameters
- Modify type signatures
- Delete imports
- Split or merge types

## Step 1: Scan — Find All References

Before modifying anything, enumerate all occurrences of the symbol (use different grep patterns for types, functions, and variables/fields respectively). Record the impact scope (which files, code/tests/docs, local or widespread). Only start editing after confirming the scan is complete.

## Step 2: Edit — Execute Changes

Execute based on change type: rename (replace all occurrences), delete (remove definition and fix references), add/modify (update call sites), extract (create new symbol and replace original code). See [Detailed Steps](references/detailed-steps.md)

## Step 3: Verify Compilation

```bash
cargo check
```

Repeat until clean.

## Step 4: Sync Tests

Tests reference symbols by name — rename test functions, update assertions, add/remove tests. See [Detailed Steps](references/detailed-steps.md)

```bash
cargo test
```

## Step 5: Sync Docs

Documentation is part of the change, not optional. Update code examples, section headings, module descriptions, README, and architecture docs. See [Detailed Steps](references/detailed-steps.md)

## Step 6: Final Verification

```bash
grep -rn "OldName" src/ tests/ docs/
cargo build && cargo test
```

Zero matches for old names, clean build, all tests pass.

## Common Pitfalls

| Pitfall | Prevention |
|---------|-----------|
| Missing `Box<dyn T>` or `&dyn T` | Always grep `dyn ` and `Box<` |
| Forgetting test names | Test function names often match symbol names |
| Docs out of sync | Update docs and code in the same PR, never defer |
| Duplicate definitions | After editing, check for multiple `impl TypeName` or `fn name` |
| Near-match misses | `replace_all` misses similar but different strings — verify manually |
| Missing cross-file references | Always scan `tests/` and `docs/`, not just `src/` |

## Prohibitions

- Do not edit before scanning all references. Scanning is not optional.
- Do not skip `cargo check` — compilation errors tell you what you missed.
- Do not skip tests — tests catch name mismatches and broken assertions.
- Do not defer doc updates — stale docs are broken docs.
- Do not assume one grep is enough. Use multiple patterns. Check each file type.

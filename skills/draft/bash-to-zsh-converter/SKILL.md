---
name: bash-to-zsh-converter
description: Accept a bash file or code snippet, identify zsh-incompatible syntax, and translate the entire script to zsh-compatible code. Covers word splitting, glob expansion, array indexing (1-based), PATH override traps, BASH_REMATCH→match, BASH_SOURCE→(%):-%x, read -p, complete→compdef, and other incompatibilities. Use when translating bash scripts to zsh or when zsh compatibility issues arise.
---

# bash-to-zsh-converter

Convert bash scripts to zsh-compatible scripts. Takes bash input, produces working zsh output.

## Workflow

1. **Scan** the entire bash input for incompatibility markers (see the catalog below)
2. **Report** a numbered list of issues found, with line references and brief explanations
3. **Translate** the entire script to zsh, applying every fix
4. **Verify** the translation with the checklist at the end

If the user provides a file path, read the file first. If they paste a snippet, work directly on it.

---

## Incompatibility Catalog

10 bash→zsh incompatibility items: word splitting, glob expansion, array indexing, array iteration, tied variable override, BASH_SOURCE, BASH_REMATCH, read -p, complete→compdef, shebang. See [Incompatibility Catalog](references/incompatibility-catalog.md)

---

## Translation Checklist

After translating, verify every item:

- [ ] **Shebang**: `#!/bin/bash` → `#!/bin/zsh`
- [ ] **Word splitting**: Every unquoted `$var` used as a list has `${=var}` or justified `shwordsplit`
- [ ] **Glob expansion**: Every `$var` used as a glob pattern has `${~var}` or justified `globsubst`
- [ ] **Array index 0**: All `[0]` accesses changed to `[1]` (or verified as intentionally past-the-beginning)
- [ ] **Tied variable override**: No loop var, local var, or assignment uses `path`, `cdpath`, `fpath`, `manpath`, or `module_path`
- [ ] **BASH_SOURCE**: Replaced with `${(%):-%x}` or `$0` as appropriate
- [ ] **BASH_REMATCH**: Replaced with `$match` (with +1 index offset)
- [ ] **read -p**: Replaced with `read "var?prompt: "` syntax
- [ ] **complete**: Replaced with `compdef`
- [ ] **Quoting**: Variables that should remain as single strings are quoted (`"$var"`)
- [ ] **Regex**: If using PCRE features, added `setopt rematch_pcre`

Present the checklist results to the user alongside the translated script.

---

## Output Format

When converting a script, produce the following sections:

### 1. Issues Found

A numbered table:

| # | Line | Issue | Severity | Fix |
|---|------|-------|----------|-----|
| 1 | 5 | `for path in ...` overwrites `$PATH` | CRITICAL | Rename to `_path` |
| 2 | 12 | `${arr[0]}` is empty in zsh | HIGH | Change to `${arr[1]}` |

Severity levels: **CRITICAL** (data loss, broken PATH), **HIGH** (wrong output, silent failure),
**MEDIUM** (error message, obvious failure), **LOW** (style, best practice).

### 2. Translated Script

The complete zsh-compatible script, ready to use. Add inline comments only for non-obvious
changes (e.g., `${=var}` — explain why `=` is needed).

### 3. Verification Checklist

The completed checklist from above.

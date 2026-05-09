# Incompatibility Catalog

Each item: **what breaks** → **why** → **how to fix**. Scan every item against the input code.

## 1. Word Splitting (shwordsplit)

Unquoted `$var` expected to split on whitespace — zsh treats it as one string.

```bash
# bash → zsh
for i in $text; do ...     →  for i in ${=text}; do ...
```

Per-variable `${=var}` is preferred. Global `setopt shwordsplit` affects ALL code and can introduce
subtle bugs — only use it after auditing the entire script for side effects.

## 2. Glob Expansion (globsubst)

Unquoted `$pattern` expected to expand as a glob — zsh treats it as a literal string.

```bash
# bash → zsh
for f in $pattern; do ...  →  for f in ${~pattern}; do ...
```

Same global-option caveat as shwordsplit — prefer per-variable `${~var}` over `setopt globsubst`.

## 3. Array Indexing (1-based)

`${arr[0]}` returns the first element in bash but is empty in zsh.

```bash
# bash → zsh
echo "${arr[0]}"           →  echo "${arr[1]}"
```

When iterating with `${arr[@]}` or `$arr`, both shells produce all elements — no change needed.
The issue is only with explicit numeric indexing. `setopt ksharrays` makes zsh 0-indexed but
changes ALL array behavior; not recommended.

## 4. Array Iteration Syntax

`$array` expands to first element only in bash, but all elements in zsh.

```bash
# bash → zsh
echo "$array"              →  echo "${array[1]}"   # if "first element" was intended
echo "${array[@]}"         →  echo "${array[@]}"   # works identically in both
```

`"${array[@]}"` is the safest form for both shells.

## 5. Tied Variable Override Traps

zsh ties lowercase arrays to uppercase scalars: `path`↔`PATH`, `cdpath`↔`CDPATH`,
`fpath`↔`FPATH`, `manpath`↔`MANPATH`, `module_path`↔`MODULE_PATH`.

Using these names as loop variables, `local` variables, or assignments silently overwrites the
environment variable. This is the #1 most common and most destructive bash→zsh mistake.

```bash
# bash → zsh
for path in ...            →  for _path in ...
local path="/opt"          →  local _path="/opt"
```

| Bash variable | zsh-safe name | Tied env var it would overwrite |
|---|---|---|
| `path` | `_path` | `PATH` |
| `cdpath` | `_cdpath` | `CDPATH` |
| `fpath` | `_fpath` | `FPATH` |
| `manpath` | `_manpath` | `MANPATH` |
| `module_path` | `_module_path` | `MODULE_PATH` |

## 6. BASH_SOURCE → zsh Script Path

`$BASH_SOURCE` is undefined in zsh.

```bash
# bash → zsh (script executed directly)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
                           →  SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# zsh (script may be sourced — most robust)
_script_source="${(%):-%x}"
if [[ -n "$_script_source" && -f "$_script_source" ]]; then
  _script_dir="$(cd "$(dirname "$_script_source")" && pwd)"
elif [[ -n "$0" && -f "$0" ]]; then
  _script_dir="$(cd "$(dirname "$0")" && pwd)"
else
  _script_dir="$(pwd)"
fi
SCRIPT_DIR="$_script_dir"
```

## 7. BASH_REMATCH → match (Regex Capture Groups)

`${BASH_REMATCH[n]}` is empty in zsh — it uses `$match` instead, and the array is 1-indexed.

```bash
# bash → zsh
${BASH_REMATCH[0]}         →  $match[1]   # full match
${BASH_REMATCH[1]}         →  $match[2]   # first capture group
${BASH_REMATCH[N]}         →  $match[N+1] # general rule
```

If using PCRE syntax, add `setopt rematch_pcre` (otherwise zsh uses POSIX ERE).

## 8. read -p Prompt

`read -p "Prompt: " var` means "show prompt" in bash but "read from coprocess" in zsh.

```bash
# bash → zsh
read -p "Enter name: " name  →  read "name?Enter name: "
```

The `?` syntax places the prompt before the variable name inside the quotes.

## 9. complete → compdef (Completion System)

`complete -F _myfunc mycommand` does nothing in zsh.

```bash
# bash → zsh
complete -F _myfunc mycmd  →  compdef _myfunc mycmd
```

For complex completions, use `#compdef` at the top of a completion file, or `compadd`.

## 10. Shebang

```bash
#!/bin/bash                →  #!/bin/zsh
#!/usr/bin/env bash        →  #!/usr/bin/env zsh
```

For sourced scripts, keep the shebang as documentation but note it should be sourced from zsh.

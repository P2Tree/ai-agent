# Data Collection Guide

## Identifying the User

```bash
# Get configured git user
git config user.name

# List all authors by commit count
git log --format="%an" | sort | uniq -c | sort -rn | head -15

# With emails for disambiguation
git log --format="%an <%ae>" | sort | uniq -c | sort -rn | head -15
```

If the user's name appears with variations, combine them. Ask user to confirm identity.

## Commit Statistics

```bash
# Total commits by user
git log --author="<NAME>" --oneline | wc -l

# Date range
git log --author="<NAME>" --format="%ad" --date=short | sort | head -1
git log --author="<NAME>" --format="%ad" --date=short | sort | tail -1

# Lines added/deleted
git log --author="<NAME>" --numstat --format="" | awk '{add+=$1; del+=$2} END {print "Added:", add, "Deleted:", del}'

# Commit type distribution
git log --author="<NAME>" --format="%s" | grep -oP '^[a-z]+' | sort | uniq -c | sort -rn
```

## Module and File Analysis

```bash
# Top files contributed to
git log --author="<NAME>" --format="" --name-only | sort | uniq -c | sort -rn | head -30

# Top-level directory contribution
git log --author="<NAME>" --format="" --name-only | grep -oP '^[^/]+(?:/[^/]+)?' | sort | uniq -c | sort -rn | head -20
```

Group top files into modules by directory structure. Read key headers to understand each module's purpose.

## Feature Extraction

```bash
# Feature commits
git log --author="<NAME>" --format="%s" | grep -iE "^feat"

# Fix commits
git log --author="<NAME>" --format="%s" | grep -iE "^fix"

# Refactor commits
git log --author="<NAME>" --format="%s" | grep -iE "^refactor"

# Performance commits
git log --author="<NAME>" --format="%s" | grep -iE "^perf"

# Chore/infra commits
git log --author="<NAME>" --format="%s" | grep -iE "^chore|^ci|^build"
```

## Scope Analysis

Extract parenthesized scopes to identify sub-areas:

```bash
git log --author="<NAME>" --format="%s" | grep -oP '\(([^)]+)\)' | sort | uniq -c | sort -rn | head -15
```

Common scopes like `(release)`, `(printer)`, `(driver)`, `(sync)`, `(target)` indicate functional ownership.

## Keyword Clustering

Search for domain-specific keywords to identify contribution themes:

```bash
# Barrier/sync related
git log --author="<NAME>" --format="%s" | grep -iE "barrier|sync|bar\."

# Debug/sanitizer/coverage/trace
git log --author="<NAME>" --format="%s" | grep -iE "debug|sanitizer|coverage|trace"

# Device / target support
git log --author="<NAME>" --format="%s" | grep -iE "device|target|platform|hardware"

# Race check / errata / overflow
git log --author="<NAME>" --format="%s" | grep -iE "racecheck|errata|overflow|check"
```

Adapt keywords to the project's domain.

## Understanding Modules

After identifying top contributed files, read key files for context:

- `README.md` / `Readme.md` / `Readme_cn.md` for project overview
- Top-level `CMakeLists.txt` / `Makefile` / `Cargo.toml` for build structure
- Key header files for module interfaces
- 1-2 key implementation files for architecture depth

Focus on: what the module does, how it fits into the overall system, what design decisions it embodies.

## Contribution Summary Template

Organize findings before presenting to user:

1. **Project overview**: name, purpose, tech stack, team size, user's role
2. **Module ownership**: modules with user's commit count and line changes
3. **Key features**: 3-5 most significant feature additions
4. **Key fixes**: 3-5 most impactful bug fixes
5. **Refactoring impact**: notable architectural improvements
6. **Performance work**: optimizations and their impact
7. **Infrastructure**: CI/CD, build system, release management
8. **Cross-cutting**: device support expansion, multi-platform work

Present this summary to user for confirmation before generating final output.

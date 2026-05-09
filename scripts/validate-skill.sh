#!/usr/bin/env bash
# validate-skill.sh — validate skill completation

set -euo pipefail

skill_dir="${1:?Usage: validate-skill.sh <skill-directory>}"
errors=0

# 1. SKILL.md exists
skill_file="$skill_dir/SKILL.md"
if [[ ! -f "$skill_file" ]]; then
  echo "FAIL: SKILL.md not found in $skill_dir"
  exit 1
fi

# 2. frontmatter
if ! grep -q '^name:' "$skill_file"; then
  echo "FAIL: missing 'name' in frontmatter"; ((errors++))
fi
if ! grep -q '^description:' "$skill_file"; then
  echo "FAIL: missing 'description' in frontmatter"; ((errors++))
fi

# 3. description has "Use when"
if ! grep -qi 'use when' "$skill_file"; then
  echo "FAIL: description missing 'Use when' trigger"; ((errors++))
fi

# 4. description limit within 1024 characters
desc_line=$(grep '^description:' "$skill_file")
desc_len=${#desc_line}
if (( desc_len > 1024 )); then
  echo "FAIL: description exceeds 1024 chars ($desc_len)"; ((errors++))
fi

# 5. SKILL.md limit within 150 lines
line_count=$(wc -l < "$skill_file")
if (( line_count > 150 )); then
  echo "FAIL: SKILL.md exceeds 150 lines ($line_count)"; ((errors++))
fi

# 6. sensitive information check
if grep -qiE '(password|secret|api.key|token[[:space:]]*[:=]|AKIA|BEGIN RSA)' "$skill_file"; then
  echo "FAIL: possible secret found in SKILL.md"; ((errors++))
fi
if grep -qE '/home/[a-z]' "$skill_file"; then
  echo "FAIL: absolute path found in SKILL.md"; ((errors++))
fi

if (( errors > 0 )); then
  echo "RESULT: $errors error(s) in $skill_dir"
  exit 1
else
  echo "PASS: $skill_dir"
  exit 0
fi

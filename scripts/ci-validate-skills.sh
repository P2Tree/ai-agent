#!/usr/bin/env bash
# ci-validate-skills.sh — CI entry point for skill validation
#
# Modes:
#   changed  — validate only skills changed in MR/PR
#   all      — validate all skills in the repo
#
# Environment variables (auto-detected):
#   CI_MERGE_REQUEST_DIFF_BASE_SHA  — GitLab MR base SHA
#   GITHUB_BASE_REF                 — GitHub PR base ref

set -euo pipefail

MODE="${1:?Usage: ci-validate-skills.sh <changed|all>}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VALIDATE="$SCRIPT_DIR/validate-skill.sh"

# Excluded directories (no SKILL.md, not real skills)
EXCLUDE_DIRS=(deprecated personal internal)

find_all_skill_dirs() {
  find skills/ -name SKILL.md -exec dirname {} \; | sort
}

is_excluded() {
  local dir="$1"
  for excl in "${EXCLUDE_DIRS[@]}"; do
    if [[ "$dir" == skills/$excl/* ]]; then
      return 0
    fi
  done
  return 1
}

get_changed_skill_dirs() {
  # Determine the diff base
  local base_ref=""
  if [[ -n "${CI_MERGE_REQUEST_DIFF_BASE_SHA:-}" ]]; then
    # GitLab CI
    base_ref="$CI_MERGE_REQUEST_DIFF_BASE_SHA"
  elif [[ -n "${GITHUB_BASE_REF:-}" ]]; then
    # GitHub Actions — fetch base and use merge base
    git fetch origin "$GITHUB_BASE_REF" --depth=1 2>/dev/null || true
    base_ref="origin/$GITHUB_BASE_REF"
  else
    # Fallback: diff against HEAD~1
    base_ref="HEAD~1"
  fi

  local changed_files
  changed_files=$(git diff --name-only --diff-filter=ACMR "$base_ref"...HEAD 2>/dev/null || git diff --name-only --diff-filter=ACMR HEAD~1...HEAD)

  local dirs=()
  for f in $changed_files; do
    # Only care about files under skills/
    if [[ "$f" != skills/* ]]; then
      continue
    fi
    # Extract skill directory (skills/<bucket>/<skill-name>)
    local skill_dir
    skill_dir=$(echo "$f" | awk -F/ '{OFS="/"; if(NF>=3) print $1,$2,$3; else print $1,$2}')
    if [[ -f "$skill_dir/SKILL.md" ]] && ! is_excluded "$skill_dir"; then
      dirs+=("$skill_dir")
    fi
  done

  # Deduplicate
  printf '%s\n' "${dirs[@]}" 2>/dev/null | sort -u || true
}

validate_skills() {
  local skill_dirs=("$@")
  local pass=0 fail=0

  if [[ ${#skill_dirs[@]} -eq 0 ]]; then
    echo "No skills to validate."
    return 0
  fi

  echo "========================================"
  echo "Validating ${#skill_dirs[@]} skill(s)..."
  echo "========================================"

  for dir in "${skill_dirs[@]}"; do
    if bash "$VALIDATE" "$dir"; then
      pass=$((pass+1))
    else
      fail=$((fail+1))
    fi
  done

  echo "========================================"
  echo "Results: $pass passed, $fail failed"
  echo "========================================"

  if [[ $fail -gt 0 ]]; then
    return 1
  fi
  return 0
}

# --- Main ---

case "$MODE" in
  changed)
    dirs=()
    while read -r dir; do
      [[ -n "$dir" ]] && dirs+=("$dir")
    done < <(get_changed_skill_dirs)
    if [[ ${#dirs[@]} -eq 0 ]]; then
      echo "No skill changes detected in this MR/PR."
      exit 0
    fi
    validate_skills "${dirs[@]}"
    ;;
  all)
    dirs=()
    while read -r dir; do
      if ! is_excluded "$dir"; then
        dirs+=("$dir")
      fi
    done < <(find_all_skill_dirs)
    if [[ ${#dirs[@]} -eq 0 ]]; then
      echo "No skills found."
      exit 0
    fi
    validate_skills "${dirs[@]}"
    ;;
  *)
    echo "Unknown mode: $MODE (use 'changed' or 'all')"
    exit 1
    ;;
esac

---
name: update-skills
description: Check third-party upstream skills for changes not yet reflected in the local repo. Use when maintaining skill freshness, auditing drift against upstream sources, or updating skills after upstream releases.
disable-model-invocation: true
---

# Update Skills

Compare local skills against their third-party upstream sources to find drift. Report differences and let the user choose which to update.

## Process

### 1. Locate Upstream Sources

Read the `## References` section in `README.md` (or `README.zh.md`) at the repo root. Extract the GitHub repository URLs. These define the upstream sources.

Example from README:

```markdown
## References

- [anthropics agent skills](https://github.com/anthropics/skills)
- [superpowers skills](https://github.com/obra/superpowers)
- [andrej karpathy skills](https://github.com/forrestchang/andrej-karpathy-skills)
- [mattpocock skills](https://github.com/mattpocock/skills)
```

Build a source mapping from each reference label (lowercase, normalized) to its repo URL:

```
source-key → repo-url
anthropics agent skills → https://github.com/anthropics/skills
superpowers skills → https://github.com/obra/superpowers
andrej karpathy skills → https://github.com/forrestchang/andrej-karpathy-skills
mattpocock skills → https://github.com/mattpocock/skills
```

### 2. Prepare Upstream Repos

For each source referenced by at least one skill:

1. Check if the repo already exists locally at `/tmp/ai-agent-upstream/<repo-name>/` (from a previous run)
2. If it exists, run `git -C /tmp/ai-agent-upstream/<repo-name> pull` to update
3. If not, run `git clone <repo-url> /tmp/ai-agent-upstream/<repo-name>/`
4. If clone or pull fails, mark the source as **unavailable** and skip its skills

### 3. Collect Skills with Upstream References

Scan the current repo's bucket READMEs for `参考：` lines. Build a mapping:

```
local-skill-name → [source-key, source-skill-name, upstream-repo-dir]
```

For example, from `参考：mattpocock/tdd`:
- local skill: `tdd`
- source-key: `mattpocock` (matched from "mattpocock skills")
- upstream skill name: `tdd`
- upstream repo dir: `/tmp/ai-agent-upstream/skills/`

Locate the upstream skill within the repo dir by searching for a `SKILL.md` file matching the skill name. Common patterns: `<repo-dir>/skills/<bucket>/<skill-name>/SKILL.md` or `<repo-dir>/<skill-name>/SKILL.md`.

For merged sources (e.g., `参考：mattpocock/diagnose + superpowers:systematic-debugging`), map to multiple upstreams.

Include `draft/` directory skills if they have upstream references.

### 4. Compare Content

For each mapped skill pair, compare the upstream `SKILL.md` with the local `SKILL.md`:

**A. Structural comparison:**
- Line count difference
- Section headings present in upstream but missing locally
- Section headings present locally but missing in upstream

**B. Content diff:**
- Read both files in full
- Identify sections with substantial content changes (new paragraphs, rewritten steps, added/removed guidelines)
- Ignore trivial whitespace or formatting differences

**C. References/ subdirectory:**
- Check if upstream has new reference files not present locally
- Check if upstream removed reference files that exist locally

### 5. Report Differences

For each skill with differences, display:

```
=== skill-name (参考：source-name/source-skill-name) ===
  Local:  skills/bucket/skill-name (X lines)
  Upstream: /tmp/ai-agent-upstream/<repo>/path/to/skill-name (Y lines)

  Changes in upstream:
    + Section "New Section" (not in local)
    ~ Section "Existing Section" — content significantly modified
    - Section "Removed Section" (not in upstream)
    + references/new-file.md (not in local)

  Drift level: MAJOR / MINOR / NONE
```

**Drift level criteria:**
- **MAJOR**: New sections, removed sections, or substantial rewrites of core workflow steps
- **MINOR**: Small wording changes, added examples, formatting tweaks
- **NONE**: Files are identical or only trivially different

Only show skills with MAJOR or MINOR drift. Skip skills with NONE.

### 6. Confirm Updates

After reporting all differences, ask the user which skills to update:

```
Which skills to update?
  1. All with MAJOR drift
  2. All with MAJOR or MINOR drift
  3. Let me choose individually
  4. None — just show the report
```

If the user chooses to update, for each selected skill:

1. Read the upstream SKILL.md in full
2. Rewrite it to match ai-agent conventions:
   - Remove platform-specific tool names and paths
   - Remove `license` frontmatter fields
   - Ensure frontmatter has `name` + `description` with "Use when" trigger
   - Keep SKILL.md under 150 lines (overflow to references/)
   - Maintain platform-agnostic content
3. Write the updated file
4. Update references/ if upstream added/changed reference files

### 7. Post-Update Verification

After updates, run `scripts/validate-skill.sh` for each modified skill. Report any failures.

## Notes

- The skill does NOT auto-update — user confirmation is required for each change
- Merged skills (referencing multiple upstreams) are compared against all upstreams
- If an upstream source is unavailable, report it but don't block the rest
- Upstream repos are cached in `/tmp/ai-agent-upstream/` between runs
- Compatible with bash and zsh

See [drift detection details](references/drift-detection.md) for comparison algorithm.

# Drift Detection — Detailed Algorithm

## Comparison Method

### Line-Level Diff

1. Normalize both files: strip trailing whitespace, normalize blank lines
2. Split into sections by `##` headings
3. For each section, compute a content hash of the body text
4. Compare section hashes:
   - Hash mismatch → section content changed
   - Section heading in upstream but not local → new section
   - Section heading in local but not upstream → removed section

### Content Significance

Not all differences warrant reporting. Classify changes:

| Change Type | Examples | Significance |
|-------------|----------|-------------|
| New section | Added workflow step, new phase | MAJOR |
| Removed section | Deleted step, removed checklist | MAJOR |
| Rewritten section | Different process flow, new rules | MAJOR |
| New examples | Added code block or use case | MINOR |
| Wording tweaks | Synonym changes, rephrasing | MINOR |
| Formatting | Bullet style, heading level | NONE |
| Whitespace | Trailing spaces, blank lines | NONE |

### Merged Skills

When a local skill references multiple upstreams (e.g., `参考：mattpocock/diagnose + superpowers:systematic-debugging`):

1. Compare against each upstream independently
2. Report differences from each source separately
3. Flag conflicts where upstreams disagree on the same section
4. User decides how to reconcile

### References/ Comparison

1. List all files in both `references/` directories
2. For files present in both, compare content using the section-hash method
3. For files only in upstream → new reference
4. For files only in local → removed reference
5. Report new and removed references as MAJOR drift

## Output Format

```
=== Drift Report ===

Source: mattpocock (/tmp/ai-agent-upstream/skills/)
  ✅ tdd — no drift
  ⚠️ diagnose — MINOR drift
    ~ Section "Phase 3" — wording changes
  🔴 improve-architecture — MAJOR drift
    + Section "Deep Module Audit"
    ~ Section "Refactoring" — rewritten

Source: anthropic-agent-skills (/tmp/ai-agent-upstream/skills/)
  🔴 improve-architecture — MAJOR drift
    + Section "Compaction"
    + Section "Prompt Caching"
    ~ Section "Current Models" — model IDs updated

Unavailable sources:
  superpowers — git clone failed for https://github.com/obra/superpowers

Summary: 2 MAJOR, 1 MINOR, 1 no drift, 1 source unavailable
```

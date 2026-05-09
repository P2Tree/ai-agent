---
name: article-series-writer
description: Parallel multi-article writing workflow with auto-review loop. Use when users need to batch-write article series or create multiple articles in parallel.
---

# Article Series Writer

Parallel multi-article writing workflow with auto-review loop, designed for long-form article series on platforms like Zhihu and WeChat Official Account.

## Use Cases

- Have a series outline and need to quickly generate multiple articles
- Have unified style requirements that need automated checking
- Need multi-person / multi-subagent collaboration to complete writing tasks

## Workflow

### 1. Task Analysis

Read the outline file and identify:
- Total number of articles n
- Core topic and estimated word count for each article
- Core analogy running through the entire series
- Unified style requirements for the series

### 2. Writing Phase (Parallel)

Create an independent subagent for each article, passing:
- The corresponding outline section
- Style guide
- Unified analogy system
- Required content checklist (e.g., Agent, Subagent concepts)

**Output path**: `articles/part_N.md` (or custom naming)

### 3. Review Phase (Serial)

Create two independent review subagents:

**Style Review**:
- Opening type (personal narrative / candid hesitation / evocative scene)
- Analogy consistency (keyword replacement check)
- Sentence rhetoric ("although...but..." transitions, emphasis sentences as standalone paragraphs)
- Closing style (humble reassurance / philosophical wrap-up + preview of next article)

**Correctness Review**:
- Check content completeness against the outline
- Technical accuracy (command syntax, file paths, API names)
- Table / code correctness

### 4. Fix Phase

Fix issues based on review results:
- Prioritize **cross-article consistency issues** (terminology replacement, analogy drift)
- Then handle local issues within individual articles

### 5. Output Report

Summarize:
- Review results for each article
- List of fixed issues
- Remaining issues (if any)

## Troubleshooting

### Review Agent Timeout

Cause: Review task too heavy (reading 5+ long articles + analysis)

Solution:
- Write the full report to a temp file, let the main agent read and summarize
- Or set a longer timeout

### Cross-article Terminology Inconsistency

Solution: After review completes and before fixes begin, do a global search-and-replace:
```bash
# e.g., replace "helper chef" with "head chef"
sed -i 's/helper chef/head chef/g' articles/*.md
```

### Partial Subagent Failure

Solution:
- Check the specific agent's error message
- Manually rewrite the failed article sections
- Use SendMessage to recover the failed agent

## Example: Starting a Writing Task

```
Based on the series outline in <outline-dir>/, generate 5 articles in parallel:
- Output to <output-dir>/
- Follow the specified style guide
```

## Related Skills

- `brainstorming`: Solution design for complex topic selection
- `writing-review`: Review and proofreading for a single article

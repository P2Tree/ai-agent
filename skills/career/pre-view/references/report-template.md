# Report Templates

## Stage Document Template (per round)

Each round's subagent outputs a stage document with the following structure:

```markdown
# Interview Round {N}: {Round Name}

## Interviewer Persona

- **Name:** {persona name}
- **Title:** {persona title}
- **Personality tendency:** {tendency}
- **Focus areas:** {areas}

## Q&A Record

### Q1: {question}

**Candidate answer summary:** {summary}

**Evaluation:** {score}/5 — {brief justification}

### Q2: {question}

**Candidate answer summary:** {summary}

**Evaluation:** {score}/5 — {brief justification}

(Repeat for each question)

## Blind Coding Review (Round 1 only)

**Problem:** {problem description}

**Review:**

| Dimension | Observation |
|-----------|-------------|
| Correctness | {observation} |
| Code style | {observation} |
| Boundary handling | {observation} |
| Naming | {observation} |
| Over-engineering | {observation} |

**Conclusion:** {overall assessment}

## Round Summary

{2-3 sentence overall assessment from this interviewer's perspective}

## Brief Impression

{1-2 sentences about the candidate for handoff to the next round's subagent}
```

**File naming:** `interview-round{N}-YYYY-MM-DD.md`

## Final Report Template

The summary subagent reads all stage documents, company profile, and JD, then produces:

```markdown
# Interview Report — {YYYY-MM-DD}

## Company Background

{Virtual company information revealed after interview concludes}

## Job Description

{Final agreed JD}

## Interviewer Personas

| Round | Name | Title | Personality | Focus Areas |
|-------|------|-------|-------------|-------------|
| 1 | {name} | {title} | {tendency} | {areas} |
| 2 | {name} | {title} | {tendency} | {areas} |
| 3 | {name} | {title} | {tendency} | {areas} |

## Round 1: Technical Interview

### Per-Question Evaluation

| # | Question | Score | Key Observation |
|---|----------|-------|-----------------|
| 1 | {question} | {score}/5 | {observation} |
| ... | ... | ... | ... |

### Blind Coding Review

{Summary of code review findings}

### Round Summary

{Overall technical assessment}

## Round 2: Managerial Interview

### Per-Question Evaluation

| # | Question | Score | Key Observation |
|---|----------|-------|-----------------|
| 1 | {question} | {score}/5 | {observation} |
| ... | ... | ... | ... |

### Round Summary

{Overall managerial assessment}

## Round 3: Leadership Interview

### Per-Question Evaluation

| # | Question | Score | Key Observation |
|---|----------|-------|-----------------|
| 1 | {question} | {score}/5 | {observation} |
| ... | ... | ... | ... |

### Round Summary

{Overall leadership assessment}

## Comprehensive Evaluation

**Overall rating:** {A/B/C/D}

**Strengths:**
- {strength 1}
- {strength 2}
- {strength 3}

**Weaknesses:**
- {weakness 1}
- {weakness 2}
- {weakness 3}

{Note: This evaluation is from a third-party objective perspective, not from the company's interviewer standpoint.}

## Improvement Suggestions (1-3 months)

1. **{area}** — {specific actionable suggestion}
2. **{area}** — {specific actionable suggestion}
3. **{area}** — {specific actionable suggestion}

## Long-term Directions

- {career development advice}
- {areas to deepen expertise}
- {skills to develop}
```

**File naming:** `interview-report-YYYY-MM-DD.md`

## Summary Subagent Instructions

The summary subagent receives:
- All stage document file paths (Round 1, 2, 3 — or only completed rounds if early termination)
- Company profile
- Job description

The subagent must:
1. Read all provided stage documents.
2. Evaluate from a **third-party objective perspective** — not from any interviewer's standpoint, not from the company's standpoint.
3. Identify patterns across rounds: consistent strengths, recurring weaknesses, contradictions between rounds.
4. Produce actionable improvement suggestions, not vague advice.
5. Output the final report to the current directory.
6. Write in the resume's language.

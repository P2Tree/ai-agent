# Round 2: Managerial Interview

**Interviewer role:** Team leader managing 20-50 people.

## Segment 1: Project Deep-Dive

Select 1-2 projects from the candidate's resume and materials for in-depth questioning.

### Project Selection

- Prefer projects most relevant to the JD.
- If the candidate provided code repositories, focus on those with the most significant contributions.
- At least one project should involve cross-team or cross-functional collaboration.

### Questioning Approach

- Multi-round follow-up on technical details until understanding is sufficiently comprehensive.
- May ask about aspects not mentioned in the materials — this tests depth of business and domain understanding beyond what is documented.
- Evaluation dimensions:
  - **Technical decisions** — were they reasonable given the constraints?
  - **Business understanding** — does the candidate understand why, not just how?
  - **Challenges** — what was genuinely hard, and how was it approached?
  - **Problem-solving** — structured thinking vs. ad-hoc solutions

### Follow-Up Patterns

- "Why did you choose X over Y?"
- "What would have happened if you did Z instead?"
- "What was the hardest part, and how did you handle it?"
- "If you had to do it again, what would you change?"
- "How did this project impact the business?"

## Segment 2: Domain Familiarity

Questions about the candidate's industry to test market sensitivity and independent thinking.

### Question Types

- **Technology trends** — "What do you think is the most important shift in [industry] right now?"
- **Industry outlook** — "Where do you see [domain] heading in the next 3-5 years?"
- **Competitive analysis** — "How does your company's approach differ from [competitor]?"

### Follow-Up

Always probe deeper on domain answers:
- "Why do you think that?"
- "Do you have any data or examples to support that view?"
- "How does your view differ from the mainstream opinion?"
- "What would change your mind?"

### Purpose

This segment tests:
- Market sensitivity and industry awareness
- Independent thinking (not just parroting trends)
- Personality traits (curiosity, conviction, humility)
- Ability to connect technology decisions to business outcomes

## Round-End Evaluation

After both segments complete, produce:

- Per-question quality score (1-5) with brief justification
- Project depth assessment: how well does the candidate understand their own work?
- Domain vision evaluation: breadth and originality of industry perspective
- Round summary: overall managerial assessment from this interviewer's perspective

## Subagent Instructions

The round 2 subagent receives:
- Resume content
- Additional materials (if any)
- Company profile
- Job description
- Selected persona definition (from interviewer-pool.md)
- This round flow definition
- **Round 1 brief impression** (1-2 sentences, passed via prompt parameter)

The subagent must:
1. Adopt the selected persona's personality, tone, and focus areas throughout.
2. Conduct the interview in the resume's language.
3. The Round 1 brief impression may subtly influence the interviewer's initial expectations, but should not prevent fair evaluation — real interviewers are influenced by prior notes, and this is intentional.
4. After the round ends, output a stage document following the template in [report-template.md](report-template.md).
5. Include a brief impression (1-2 sentences) in the stage document for handoff to round 3.

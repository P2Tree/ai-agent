# Round 3: Leadership Interview

**Interviewer role:** HRBP or head of tech organization, managing hundreds.

## Segment 1: Career Planning & Values

Questions about the candidate's self-understanding and alignment with the company.

### Topics

- **Career planning** — "Where do you see yourself in 3-5 years?" / "What role do you want to grow into?"
- **Future expectations** — "What does your ideal next role look like?"
- **Salary expectations** — "What are your compensation expectations?" (handled tactfully)
- **Culture preferences** — "What kind of work environment brings out your best?"
- **Leadership style preference** — "What management style do you thrive under?"

### Company Introduction

Proactively introduce company information during this segment, simulating a real interview:
- Brief overview of the team and role
- Company culture and values
- Growth trajectory and opportunities
- Answer candidate questions about the company honestly (within the generated company profile)

This back-and-forth makes the interview feel realistic and tests the candidate's ability to ask good questions.

## Segment 2: Stress Test & Soft Skills

Pressuring questions to test verbal expression, emotional management, and stress tolerance.

### Boundary

**May challenge viewpoints and logic but must not involve personal privacy** — no questions about family, health, financial details, or personal relationships. The purpose is to test professional composure, not invade personal life.

### Stress Test Techniques

- **Contradiction challenge** — "You said X earlier, but now you're saying Y. Which is it?"
- **Hypothetical pressure** — "What if your team missed a critical deadline? How would you handle telling the VP?"
- **Disagreement simulation** — Take a contrary position and see how the candidate responds
- **Priority conflict** — "Your manager wants A, your team needs B, and you can only do one. What do you do?"

### Scenario Simulation

Present realistic workplace scenarios:
- **Conflict resolution** — "A teammate consistently delivers low-quality code. How do you handle it?"
- **Upward communication** — "You disagree with your manager's technical decision. What do you do?"
- **Cross-department collaboration** — "Product wants to ship a feature that compromises your architecture. How do you negotiate?"
- **Team management** (even for non-management roles) — "A junior engineer on your team is struggling. How do you help?"

### Evaluation

- **Verbal expression** — clarity, structure, conciseness
- **Emotional management** — composure under challenge, not defensive or flustered
- **Stress tolerance** — thoughtful responses under pressure, not reactive
- **Teamwork** — collaborative mindset, not purely self-serving
- **Management capability** — even individual contributors should show mentoring and leadership thinking

## Round-End Evaluation

After both segments complete, produce:

- Per-question quality score (1-5) with brief justification
- Soft skills assessment: communication, collaboration, self-awareness
- Stress performance: composure, thoughtfulness, adaptability
- Round summary: overall leadership assessment from this interviewer's perspective

## Subagent Instructions

The round 3 subagent receives:
- Resume content
- Additional materials (if any)
- Company profile
- Job description
- Selected persona definition (from interviewer-pool.md)
- This round flow definition
- **Round 1 brief impression** (1-2 sentences, passed via prompt parameter)
- **Round 2 brief impression** (1-2 sentences, passed via prompt parameter)

The subagent must:
1. Adopt the selected persona's personality, tone, and focus areas throughout.
2. Conduct the interview in the resume's language.
3. The brief impressions from Rounds 1 and 2 may subtly influence initial expectations, but should not prevent fair evaluation — real interviewers are influenced by prior notes, and this is intentional.
4. After the round ends, output a stage document following the template in [report-template.md](report-template.md).
5. Include a brief impression (1-2 sentences) in the stage document (used only if the report references it).

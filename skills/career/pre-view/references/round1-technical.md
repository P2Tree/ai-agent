# Round 1: Technical Interview

**Interviewer role:** Technical leader managing <10 people, familiar with the candidate's tech domain.

## Segment 1: Technical Q&A

- ~10 questions centered on resume tech stack and JD requirements.
- Each question is followed by deeper probing until sufficient depth is reached or candidate admits unfamiliarity.
- **One question per message** — never bundle multiple questions into a single message. If you have multiple angles on a topic, probe them one at a time through follow-up questions.
- **Probing limit:** max 3-4 follow-up rounds per question. Questions directly related to JD core requirements may extend 1-2 additional rounds.
- Question sources: resume tech keywords, JD-required skills, knowledge gaps exposed in candidate's answers.
- Probing rhythm: conceptual understanding → implementation details → edge cases/tradeoffs/first principles.
- 50%-70% of questions around JD; rest tests technical breadth.
- **Standard knowledge check:** include 2-3 standalone technical questions (often called "八股文" in Chinese interview culture) based on the candidate's tech stack. These are pure knowledge questions detached from project context — e.g., "What's the difference between virtual inheritance and ordinary inheritance in C++?" or "Explain Rust's borrow checker rules." These test foundational knowledge that interviewers often probe regardless of project familiarity.

### Question Flow

1. Start with a topic from the candidate's resume or JD.
2. Ask a foundational question: "Can you explain how X works?"
3. Based on the answer, probe deeper:
   - If the answer is strong → push to edge cases or tradeoffs
   - If the answer is shallow → ask for implementation details
   - If the candidate is struggling → move on after 3-4 follow-up rounds
4. Move to the next topic. Avoid spending too long on any single area.

## Segment 2: Blind Coding

Design a demo problem based on Q&A performance and resume background.

### Applicability

Blind coding applies to roles where hands-on coding is a core expectation (engineers, SRE, toolchain developers, etc.). For non-coding roles (product manager, architect, project manager), skip this segment and replace with a **system design discussion** or **case analysis** appropriate to the role.

### Problem Design

- Difficulty calibrated to be completable within ~20 minutes.
- Problem type should match JD role nature:
  - **Infrastructure/toolchain roles** → implementing a small feature or debugging exercise
  - **Algorithm/data roles** → algorithm problem
  - **Architecture roles** → system design sketch (module breakdown, interface definitions, data flow)
- Problem requirements: relevant to JD and candidate's background; clear input/output; tests code quality and thinking.
- Optionally provide a code skeleton (base classes, test cases, main function) so the candidate focuses on the key implementation. The interviewer decides whether a skeleton is appropriate based on the problem and role.

### Execution

1. Present the problem statement with clear input/output examples.
2. Specify a file path for the candidate to write code.
3. Remind the candidate: "Suggested time is ~20 minutes, but no hard limit."
4. Wait for the candidate to signal completion.
5. Read the file using the Read tool.
6. **Revision round:** after first submission, provide feedback on any issues (misunderstood requirements, missed edge cases, logical errors). Ask the candidate if they want to revise. Wait for their decision.
7. After the candidate confirms their final submission (or declines to revise), proceed to review.
8. Review the code on these dimensions:
   - **Correctness** — does it solve the stated problem?
   - **Code style** — readability, consistency
   - **Boundary handling** — edge cases, error conditions
   - **Naming** — clarity of variable/function names
   - **Over-engineering** — unnecessary abstractions or complexity

## Round-End Evaluation

After both segments complete, produce:

- Per-question quality score (1-5) with brief justification
- Blind coding review conclusion with specific observations
- Round summary: overall technical assessment from this interviewer's perspective

## Subagent Instructions

The round 1 subagent receives:
- Resume content
- Additional materials (if any)
- Company profile
- Job description
- Selected persona definition (from interviewer-pool.md)
- This round flow definition

The subagent must:
1. Adopt the selected persona's personality, tone, and focus areas throughout.
2. Conduct the interview in the resume's language.
3. After the round ends, output a stage document following the template in [report-template.md](report-template.md).
4. Include a brief impression (1-2 sentences) in the stage document for handoff to round 2.

---
name: pre-view
description: "Simulate realistic multi-round job interviews with diverse interviewer personas. Reviews your resume and optional materials, generates a virtual company and JD, then conducts 3 rounds (technical, managerial, leadership) with per-round evaluations and a final objective report. Use when preparing for interviews, practicing interview skills, role-playing as an interviewee, or whenever the user mentions 模拟面试, 面试练习, 面试准备, mock interview, interview practice, pre-view, or wants to be interviewed — even if they don't explicitly ask for a 'mock interview.'"
---

# Pre-view

Simulate realistic multi-round job interviews. Pre-view generates a virtual company, negotiates a JD, then runs 3 rounds of interviews with diverse interviewer personas. Each round produces a stage document; a final summary subagent delivers an objective evaluation.

## Pre-interview

### 1. Material Collection

- Resume is **mandatory** — provide a file path or paste content. Skill stops if not provided.
- Ask whether you have additional materials: code repositories, blog posts, technical documents.
- Read and digest all materials before proceeding.
- After reading, tell the user what you understood: name, background, and key info that will be used in the interview.

### 2. Company Profile Generation

- Generate a virtual company from resume-inferred industry, tech stack, and seniority.
- Dimensions: name, industry, employee count, revenue, stage, business lines, culture, founder.
- Company stage/scale influences interview style: startups → hands-on versatility; large companies → depth and process.
- → See [company-profile.md](references/company-profile.md) for generation rules.

### 3. JD Negotiation

- Present the company background.
- Ask what position you plan to interview for and provide a basic description.
- Generate a JD and discuss until you are satisfied.
- Confirm: show company background + final JD before interview begins.

### 4. Interviewer Persona Selection

- For each round, select one persona from the pool. Do not reveal to you during the interview.
- The persona manifests naturally through question style, tone, and focus areas.
- Personas revealed in the final report.
- → See [interviewer-pool.md](references/interviewer-pool.md) for persona definitions.

## Interview Rounds

### General Rules

- 50%-70% of questions revolve around the JD; the rest probe breadth and depth.
- Difficulty adapts: junior → fundamentals and hands-on; senior → architecture, tradeoffs, domain depth.
- Language follows the resume. Interview dialogue and documents match resume language.
- Each round is executed by a subagent adopting the selected persona.

### Subagent Handoff

- After each round, the main agent extracts a **brief impression** (1-2 sentences) from the stage document.
- Round 2 subagent receives Round 1's brief impression.
- Round 3 subagent receives brief impressions from both Round 1 and Round 2.
- Impressions are passed via prompt parameter, not written into stage documents.

### After Each Round

- The subagent outputs a stage document to the current directory.
- Ask: continue to the next round, or end the interview?
- If "end" — the summary subagent produces a partial report based on completed rounds only.
- No pause/resume across sessions.

### Round Flows

- → See [Round 1: Technical Interview](references/round1-technical.md) — Q&A (~10 questions, probing limit 3-4 rounds) + blind coding (if applicable per JD)
- → See [Round 2: Managerial Interview](references/round2-managerial.md) — project deep-dive + domain familiarity
- → See [Round 3: Leadership Interview](references/round3-leadership.md) — career planning & values + stress test & soft skills

## Final Report

- A separate summary subagent reads all stage documents, company profile, and JD.
- Evaluates from a **third-party objective perspective** — not from the company's standpoint.
- Output to the current directory.
- → See [report-template.md](references/report-template.md) for templates.

**File naming:**
- Stage documents: `interview-round{N}-YYYY-MM-DD.md`
- Final report: `interview-report-YYYY-MM-DD.md`

## Notes

- Language follows resume (auto-detect). Dialogue and documents match.
- Difficulty scales with education, years of experience, and seniority.
- Stress test boundary: may challenge viewpoints and logic, but **never** involve personal privacy (family, health, financial details).

## Anti-Patterns

- Do not reveal the interviewer persona during the interview.
- Do not hard-time the blind coding exercise — suggest ~20 minutes, no enforcement.
- Do not allow pause/resume across sessions — only continue or end.
- Do not pass full stage documents between rounds — only brief impressions.
- Do not ask multiple questions at once — one question per message. If you have follow-up angles, save them for probing.

# Company Profile Generation

Rules for generating a virtual company background from the candidate's resume.

## Inference

Extract from the resume:

- **Industry** — e.g., internet, semiconductor, finance, healthcare
- **Tech stack** — languages, frameworks, infrastructure
- **Years of experience** — determines company scale
- **Seniority level** — junior, mid, senior, staff, principal

## Generated Dimensions

| Dimension | Description |
|-----------|-------------|
| Company name | Fictional but realistic for the industry |
| Industry | Matched to resume |
| Employee count | Scaled to candidate level (see below) |
| Annual revenue | Appropriate for company stage and size |
| Company stage | Startup / Growth / Mature |
| Main business lines | 1-3 lines relevant to the candidate's domain |
| Culture keywords | 2-3 traits (e.g., "engineer-driven", "fast iteration", "data-driven") |
| Founder background | One sentence: role and personality |

## Scale Mapping

| Candidate level | Company size | Company stage |
|----------------|-------------|---------------|
| Junior (0-3 years) | 50-200 | Startup / Growth |
| Mid (3-6 years) | 200-1000 | Growth |
| Senior (6-10 years) | 500-5000 | Growth / Mature |
| Staff/Principal (10+ years) | 1000-10000+ | Mature |

These are guidelines — adjust if the candidate's background suggests otherwise.

## Interview Style Influence

Company stage and scale affect questioning tendency:

| Company stage | Interview tendency |
|--------------|-------------------|
| Startup | Hands-on versatility, speed, multi-role capability, pragmatism |
| Growth | Balance of depth and breadth, process awareness, scalability thinking |
| Mature | Deep specialization, process discipline, cross-team collaboration, system-level thinking |

The selected interviewer persona's focus should align with this tendency. For example, a startup company should not pair with a persona focused solely on process compliance.

## Constraints

- Position direction must match the resume. A frontend engineer should not be interviewing for an embedded systems role.
- Company scale should correspond to the candidate's level. A junior engineer should not face a 10,000-person enterprise VP.
- Culture keywords should be plausible for the industry.

## Output Format

Present to the candidate as a structured list:

```
公司名称：[name]
所属行业：[industry]
员工规模：[count]
年营收量级：[range]
公司阶段：[stage]
主要业务：[lines]
文化关键词：[keywords]
创始人：[background and personality]
```

If the resume language is English, use English labels.

# ai-agent 仓库架构设计

> 最后更新：2026-05-09

## 1. 仓库定位

ai-agent 是一个开源的 AI 编码助手技能仓库，收集、融合、维护各类 agent skill 及相关配置。目标：

- **集百家之长**：从多个第三方源吸收优秀实践，融合改写
- **单一来源**：所有 skill 由本仓库提供，不依赖第三方插件运行，避免冲突
- **严格质量**：每个 skill 经过质量审核才能发布
- **多平台兼容**：skill 内容平台无关，通过映射表适配 Claude Code / Cursor / Codex / Gemini 等

## 2. 仓库布局

```
ai-agent/
├── README.md                          ← 正式 skill 索引 + 目录说明
├── CLAUDE.md                          ← 本仓库的开发规范
├── .claude-plugin/
│   └── plugin.json                    ← Claude Code 插件注册表
├── .agents/
│   └── skills.json                    ← OpenAI Agents SDK / Codex 注册表
│
├── skills/                            ← 所有 skill
│   ├── engineering/                   ← 软件开发
│   ├── productivity/                  ← 效率改进
│   ├── composition/                   ← 内容生成
│   ├── workflow/                      ← 工作流
│   ├── misc/                          ← 杂项
│   ├── personal/                      ← 私人，脱敏后开源
│   ├── internal/                      ← 公司内部专用，永不开源
│   ├── draft/                         ← 开发中
│   └── deprecated/                    ← 已废弃
│
├── configs/                           ← 配置文件备份与模板
│   ├── project/                       ← 项目级配置模板（CLAUDE.md, AGENTS.md 等）
│   ├── user/                          ← 用户级配置模板（~/.claude/CLAUDE.md 等）
│   └── internal/                      ← 公司内部配置，不开源
│
├── hooks/                             ← Agent hooks 脚本
│
├── docs/
│   ├── architecture_design.md        ← 本文档
│   └── skill-writing-guide.md         ← 如何写一个好 skill
│
├── scripts/                           ← 仓库级工具
│   ├── validate-skill.sh              ← skill 结构完整性检查（bash）
│   ├── validate-skill.zsh             ← skill 结构完整性检查（zsh）
│   └── validate-skill.fish            ← skill 结构完整性检查（fish）
│
└── internal/                          ← 公司内部资料，不开源
```

### 目录说明

| 隐藏目录 | 用途 |
|---------|------|
| `.claude-plugin/` | Claude Code 插件注册表，平台约定路径 |
| `.agents/` | OpenAI Agents SDK / Codex 注册表，平台约定路径 |

## 3. Skills 分桶规则

| 桶 | 定义 | 发布 |
|---|------|------|
| `engineering/` | 软件开发过程中的 skill：编码、测试、调试、架构、审查 | 开源 |
| `productivity/` | 提高工作效率但不直接写代码：通信压缩、对齐、token 优化 | 开源 |
| `composition/` | 文章、文档、图表等内容生成相关 | 开源 |
| `workflow/` | 工作流操作相关：git、Jira、部署、迁移、初始化 | 开源 |
| `misc/` | 不好归类的其他项目 | 开源 |
| `personal/` | 个人专用 skill，脱敏后开源 | 开源 |
| `internal/` | 公司内部使用的 skill | 不开源 |
| `draft/` | 开发中，未达质量门槛 | 不发布 |
| `deprecated/` | 已废弃 | 不发布 |

### 发布与排除规则

- 开源时排除所有 `internal/` 目录（`skills/internal/`、`configs/internal/`、根 `internal/`），写入 .gitignore
- `draft/` 和 `deprecated/` 不出现在 README 和注册表中
- `personal/` 必须**脱敏**后才能开源：不含密钥、绝对路径、个人身份信息等安全和隐私相关内容

## 4. 单个 skill 结构

```
skill-name/
├── SKILL.md           ← 必需，技能主体
├── references/        ← 可选，详细参考（渐进披露）
├── scripts/           ← 可选，确定性脚本
└── examples/          ← 可选，示例
```

### SKILL.md 规范

```markdown
---
name: skill-name
description: 一句话说做什么。Use when [触发条件]。
---

# 技能标题

## 要做什么
简洁的指令，agent 照着执行。

## 流程
（如果技能有步骤，用 checklist 列出）

## 注意事项
（坑、反模式、边界情况）

## 参考
（详细内容拆到 references/，这里链接过去）
```

**约束**：

- frontmatter 的 `description` 不超过 1024 字符；第一句说做什么，第二句 `Use when [触发条件]`
- SKILL.md 不超过 150 行；超出的内容拆到 `references/`
- 不含敏感信息（密钥、绝对路径、个人身份信息）
- 术语一致，不自造黑话
- 平台无关——不包含特定 agent 的工具名或指令；需要平台映射时放 `references/platform-mapping.md`

### 渐进披露

SKILL.md 保持精简，agent 按需加载 `references/` 中的详细内容。适用场景：

- skill 流程有大量细节步骤
- 包含平台映射表
- 包含详细示例或模板

### scripts 使用时机

当操作满足以下条件时写成脚本：

- 确定性操作（格式化、校验、模板生成）
- 每次生成的代码都一样
- 需要明确的错误处理

脚本省 token 且结果更可靠。

## 5. 质量控制体系

### 三层检查

**结构完整性**（可自动化，由 `scripts/validate-skill.{sh,zsh,fish}` 检查，根据当前 shell 选择）：

- [ ] SKILL.md 存在且 frontmatter 格式正确（name + description）
- [ ] description 符合格式：第一句说做什么，第二句 `Use when [触发条件]`
- [ ] description 不超过 1024 字符
- [ ] SKILL.md 不超过 150 行
- [ ] 无敏感信息（如密钥、绝对路径、个人身份信息）

**内容质量**（人工检查）：

- [ ] 指令明确，agent 可以直接照做
- [ ] 流程类技能有步骤 checklist
- [ ] 包含注意事项或反模式（如果有坑）
- [ ] 术语一致
- [ ] 无废话、无装饰性段落

**实际验证**（人工检查）：

- [ ] 至少手动跑过一次完整流程
- [ ] 在目标平台上能正确触发
- [ ] 如果有 scripts/，脚本可执行且幂等

### 成熟流程

```
draft/ → 手动验证 → 质量检查通过 → mv 到正式桶 → 更新 README 和注册表
```

不通过则留在 draft 继续改。

### 废弃机制

skill 不再维护时，移入 `deprecated/`，README 和注册表中移除。在 `deprecated/README.md` 中注明废弃原因。

## 6. 注册与索引

### 顶层 README.md

列出每个正式桶的所有 skill，每个 skill 一行：

```markdown
## Engineering

- **[tdd](./skills/engineering/tdd/SKILL.md)** — 红绿重构 TDD 循环，垂直切片开发
- **[diagnose](./skills/engineering/diagnose/SKILL.md)** — 六阶段调试循环
```

规则：

- 只列正式桶（engineering / productivity / composition / workflow / misc / personal）
- 不列 `draft/`、`internal/`、`deprecated/`

### 桶级 README.md

每个桶目录下有 README.md，对本桶每个 skill 提供详细介绍：

```markdown
# Engineering

软件开发过程中的 skill。

## tdd

红绿重构 TDD 循环，垂直切片开发。每次只写一个测试，再写最少代码通过，再重构。禁止水平切片（先写全部测试再写全部代码）。

适用于：需要用 TDD 方式开发功能或修复 bug 时。

## diagnose

六阶段调试循环：反馈环 → 复现 → 假设 → 插桩 → 修复 → 清理。强调先建立可复现的反馈环，再逐步缩小范围。

适用于：遇到难调的 bug、性能回退、或行为不符合预期时。
```

每个 skill 包含：名称、2-3 句描述（做什么 + 怎么做）、适用场景。

### plugin.json（Claude Code）

```json
{
  "name": "ai-agent",
  "skills": [
    "./skills/engineering/tdd",
    "./skills/engineering/diagnose"
  ]
}
```

### 多平台注册表

```
.claude-plugin/plugin.json    ← Claude Code
.agents/skills.json           ← OpenAI Agents SDK / Codex
```

skill 内容不变，只是注册路径不同。

**同步规则**：skill 毕业或废弃时，必须同时更新根 README、桶 README、所有注册表。

## 7. 第三方源同步策略

### 流程

```
发现 → 评估 → 吸收 → 通知
```

1. **发现**：每月一次手动检查各上游仓库的变更
2. **评估**：读上游变更，判断是否值得吸收（bug 修复？流程改进？我们不需要的东西？）
3. **吸收**：理解变更意图后**改写**进我们的 skill，保持自己的风格、结构、术语一致。不是复制粘贴。吸收后在 git commit 中注明来源
4. **通知**：在仓库 CHANGELOG.md 中记录"从 xxx 吸收了 yyy 改进"

### 输入源

#### superpowers (obra/superpowers-marketplace)

- **特点**：流程纪律体系——brainstorming、writing-plans、executing-plans、systematic-debugging、checklist 纪律、子 agent 分发模式、验证完成、分支收尾
- **吸纳部分**：流程纪律框架、checklist 模式、agent 分发与并行执行模式、验证与完成门控
- **已融合 skill**：brainstorming、tdd、diagnose、code-review、writing-plans、executing-plans、using-git-worktrees、dispatching-agents、finishing-branch、verify-before-done

#### mattpocock/skills

- **特点**：工程实践 + 领域语言驱动。grill 对齐、TDD 垂直切片、深模块架构、CONTEXT.md 共享术语、ADR 决策记录
- **吸纳部分**：grill 对话模式、TDD 垂直切片方法论、深模块设计理念、领域语言与 CONTEXT.md 实践、ADR 判断原则
- **已融合 skill**：grill-me、grill-with-docs、tdd、diagnose、improve-architecture、to-prd、to-issues、triage、zoom-out、prototype、setup-matt-pocock-skills、write-a-skill

#### andrej-karpathy-skills

- **特点**：编码行为准则，单一 skill，强调减少 LLM 常见编码错误
- **吸纳部分**：编码行为约束和反模式清单
- **已融合 skill**：karpathy-guidelines → code-guidelines

#### anthropic-agent-skills

- **特点**：文档与内容生成类 skill（pdf、xlsx、pptx、docx）及前端开发辅助
- **吸纳部分**：文档生成模式、前端设计与测试
- **已融合 skill**：frontend-design、ppt-generator（含 pptx）、pdf-handler、xlsx-handler、docx-handler、doc-coauthoring

### 同步频率

每月一次，由人工触发。在每次同步后记录到 CHANGELOG.md。

## 8. 冲突策略

**原则：一个概念只有一个 skill，由本仓库提供。**

- 不安装 superpowers 等第三方 skill 插件
- 同功能的 skill 合并为一个
- 第三方源的优秀实践吸收改写进我们的 skill，不是原样搬入
- 用户只需安装本仓库即可使用全部 skill，无需额外插件

## 9. 每个 skill 的桶归属与来源

### engineering/（6 个）

| Skill | 来源与合并说明 | 状态 |
|-------|--------------|------|
| tdd | ai-agent + mattpocock/tdd + superpowers:test-driven-development | ✅ 已创建 |
| diagnose | ai-agent + mattpocock/diagnose + superpowers:systematic-debugging | ✅ 已创建 |
| code-review | ai-agent:code-review-discipline + superpowers:requesting-code-review + superpowers:receiving-code-review | ✅ 已创建 |
| improve-architecture | ai-agent + mattpocock | ✅ 已创建 |
| frontend-design | anthropic-agent-skills | ✅ 已创建 |
| triage | mattpocock | ✅ 已创建 |
| init-agent-environment | ai-agent + mattpocock/setup-matt-pocock-skills | ✅ 已创建（workflow 桶） |

### productivity/（5 个）

| Skill | 来源与合并说明 | 状态 |
|-------|--------------|------|
| brainstorming | ai-agent + superpowers:brainstorming | ✅ 已创建 |
| zoom-out | mattpocock | ✅ 已创建 |
| prototype | mattpocock | ✅ 已创建 |
| caveman | ai-agent | ✅ 已创建 |
| code-guidelines | andrej-karpathy-skills | ✅ 已创建 |
| grill-me | ai-agent + mattpocock/grill-with-docs | ✅ 已创建 |
| token-efficiency-master | 公司 | ⏳ 待迁移 |
| agentic-harness-patterns | 公司 | ⏳ 待迁移 |

### composition/（7 个）

| Skill | 来源与合并说明 | 状态 |
|-------|--------------|------|
| article-series-writer | ai-agent | ✅ 已创建 |
| ppt-generator | 公司 + anthropic-agent-skills/pptx | ⏳ 待迁移 |
| pdf-handler | anthropic-agent-skills | ⏳ 待迁移 |
| xlsx-handler | anthropic-agent-skills | ⏳ 待迁移 |
| docx-handler | anthropic-agent-skills | ⏳ 待迁移 |
| uml-generator | 公司 | ⏳ 待迁移 |
| coauthoring | anthropic-agent-skills:doc-coauthoring | ✅ 已创建 |

### workflow/（20 个）

| Skill | 来源与合并说明 | 状态 |
|-------|--------------|------|
| writing-plans | superpowers:writing-plans | ✅ 已创建 |
| executing-plans | superpowers:executing-plans | ✅ 已创建 |
| using-git-worktrees | superpowers:using-git-worktrees | ✅ 已创建 |
| dispatching-agents | superpowers:dispatching-parallel-agents + superpowers:subagent-driven-development | ✅ 已创建 |
| finishing-branch | superpowers:finishing-a-development-branch | ✅ 已创建 |
| verify-before-done | superpowers:verification-before-completion | ✅ 已创建 |
| git-commit-mr | 公司，脱敏 | ⏳ 待迁移 |
| git-guardrails | ai-agent:git-guardrails-claude-code | ✅ 已创建 |
| bash-to-zsh-converter | ai-agent | ✅ 已创建 |
| to-prd | ai-agent | ✅ 已创建 |
| to-issues | ai-agent | ✅ 已创建 |
| create-skill | ai-agent + mattpocock/write-a-skill | ✅ 已创建（misc 桶） |
| daily-summary | 公司，脱敏 | ⏳ 待迁移 |
| weekly-summary | ai-agent | ✅ 已创建（internal 桶） |
| deploy-fullstack | 公司，脱敏 | ⏳ 待迁移 |
| repo-cleanup | 公司 | ⏳ 待迁移 |
| jira-ops | 公司 jira-search-read + jira-writer + jira-query + jira-fault-case-generator，脱敏，详细操作放 references/ | ⏳ 待迁移 |
| confluence-ops | 公司:confluence-op，脱敏 | ⏳ 待迁移 |
| gantt-report | 公司，脱敏 | ⏳ 待迁移 |

### misc/（5 个）

| Skill | 来源与合并说明 | 状态 |
|-------|--------------|------|
| skill-changelog | 公司 | ⏳ 待迁移 |
| skill-reflector | 公司 | ⏳ 待迁移 |
| skill-sync-audit | 公司 | ⏳ 待迁移 |
| setup-pre-commit | mattpocock | ✅ 已创建 |

### personal/

暂无。未来添加时需脱敏。

### internal/（公司内部）

暂无。公司内部 skill 将由人工逐个迁移，不在此列出。

### draft/

当前为空。新 skill 先在此开发，通过质量审核后 mv 到正式桶。

### deprecated/

当前为空。废弃时 mv 到此，在 README.md 注明原因。

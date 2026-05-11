# 面向 AI 的工程师技能

开源 AI 编码助手技能仓库。跨平台收集、筛选、维护 agent 技能及配置。

[English](./README.md)

---

## 工作原理

每个 skill 是一个自包含目录，以 `SKILL.md` 为入口，agent 按需加载：

```
skill-name/
├── SKILL.md           # 入口 — 做什么、怎么做
├── references/        # 深入细节（渐进加载）
├── scripts/           # 确定性脚本（格式化、校验、脚手架）
└── examples/          # 使用示例
```

**渐进披露** — `SKILL.md` 不超过 150 行。agent 需要更多上下文时从 `references/` 加载。默认保持低 token 开销，需要深度时自动展开。

**平台无关** — skill 指令不包含特定 agent 的工具名或 UI 命令。平台映射放在 `references/platform-mapping.md`，同一 skill 可在 Claude Code、Cursor、Codex、Gemini 等平台使用。

## 安装

### 方式 A：skills.sh 自动安装

运行：
```bash
npx skills@latest add p2tree/ai-agent
```

选择你想要的 skills。

### 方式 B：手动软链接

```bash
# 拉取仓库
git clone https://github.com/p2tree/ai-agent.git
cd ai-agent

# 将 install-skill 安装到你的 agent skills 目录
ln -s skills/misc/install-skills ~/.claude/skills/install-skills
```

然后，启动你的 agent 控制台，运行 `install-skills` skill 进行剩余的交互式安装。

## 内容一览

### Engineering（软件开发）

| Skill | 说明 |
|-------|------|
| [tdd](./skills/engineering/tdd/SKILL.md) | 红绿重构 TDD 循环，垂直切片开发 |
| [diagnose](./skills/engineering/diagnose/SKILL.md) | 六阶段调试循环：反馈环 → 复现 → 假设 → 插桩 → 修复 → 清理 |
| [code-review](./skills/engineering/code-review/SKILL.md) | 代码审查纪律 — 校准置信度，审查变更而非作者 |
| [improve-architecture](./skills/engineering/improve-architecture/SKILL.md) | 扫描架构摩擦，提出深模块重构建议 |
| [frontend-design](./skills/engineering/frontend-design/SKILL.md) | 创建独特的、生产级前端界面 |

### Productivity（效率提升）

| Skill | 说明 |
|-------|------|
| [brainstorming](./skills/productivity/brainstorming/SKILL.md) | 协作式设计门控 — 写代码前先对齐需求 |
| [zoom-out](./skills/productivity/zoom-out/SKILL.md) | 拉高视角，查看模块关系和调用链 |
| [prototype](./skills/productivity/prototype/SKILL.md) | 抛弃式原型，验证设计后再决定 |
| [caveman](./skills/productivity/caveman/SKILL.md) | 超压缩通信模式 — 约省 75% token |
| [code-guidelines](./skills/productivity/code-guidelines/SKILL.md) | 编码行为准则，减少 LLM 常见编码错误 |
| [grill-me](./skills/productivity/grill-me/SKILL.md) | 逐问压力测试你的计划或设计 |

### Composition（内容生成）

| Skill | 说明 |
|-------|------|
| [article-series-writer](./skills/composition/article-series-writer/SKILL.md) | 并行批量写作系列文章，自动 review 闭环 |
| [coauthoring](./skills/composition/coauthoring/SKILL.md) | 人机协作撰写文章、博客、随笔等 prose 类内容 |
| [work-report](./skills/composition/work-report/SKILL.md) | 适应中国本土企业的工作汇报（日报、年终总结到晋升述职全场景覆盖） |

### Workflow（工作流）

| Skill | 说明 |
|-------|------|
| [git-guardrails](./skills/workflow/git-guardrails/SKILL.md) | Hook 保护，阻止危险 git 操作 |
| [writing-plans](./skills/workflow/writing-plans/SKILL.md) | 将 spec 拆解为 bite-sized 实施计划 |
| [executing-plans](./skills/workflow/executing-plans/SKILL.md) | 逐步执行计划，带验证门控 |
| [executing-plans](./skills/workflow/executing-plans/SKILL.md) | 逐步执行计划，带验证门控 |
| [using-git-worktrees](./skills/workflow/using-git-worktrees/SKILL.md) | 隔离的 git worktree 做特性开发 |
| [finishing-branch](./skills/workflow/finishing-branch/SKILL.md) | 完成开发分支：验证 → 选择操作 → 清理 |
| [verify-before-done](./skills/workflow/verify-before-done/SKILL.md) | 声称完成前必须运行验证命令并确认输出 |
| [to-prd](./skills/workflow/to-prd/SKILL.md) | 将对话上下文合成为 PRD |
| [to-issues](./skills/workflow/to-issues/SKILL.md) | 将 PRD 拆分为垂直切片的独立 issue |
| [triage](./skills/workflow/triage/SKILL.md) | 状态机驱动的 issue 分诊 |
| [init-agent-environment](./skills/workflow/init-agent-environment/SKILL.md) | 初始化 agent 工作环境 — issue tracker、标签、领域文档 |
| [create-skill](./skills/misc/create-skill/SKILL.md) | 创建、改进、评估 skill |

### Misc（杂项）

| Skill | 说明 |
|-------|------|
| [install-skills](./skills/misc/install-skills/SKILL.md) | 交互式 skill 软链接安装器 |
| [update-skills](./skills/misc/update-skills/SKILL.md) | 检查上游 skill 漂移并更新 |

## 一次性设置 Skill

大部分 skill 按需触发，但有几个是一次性设置：

| Skill | 作用范围 | 持久化内容 |
|-------|---------|-----------|
| `install-skills` | 每台机器 | agent skill 目录中的软链接；换机器需要重装 |
| `git-guardrails` | 每个仓库 | `.claude/settings.json` 中的 hook 配置；新仓库需要重新运行 |
| `init-agent-environment` | 每个仓库 | CLAUDE.md/AGENTS.md 中的 agent 上下文块 + `docs/agents/` 目录结构；新仓库需要重新运行 |

## 设计哲学

**一个概念，一个 skill。** 不做重复。多个来源覆盖同一领域时，合并为一个维护良好的 skill，而非保留多个版本。

**精心筛选，而非简单聚合。** 从上游源吸收 skill 后改写，保持统一的风格、结构和术语。先理解意图再集成 — 绝不复制粘贴。

**默认渐进披露。** `SKILL.md` 保持精简；细节放 `references/`。agent 只加载需要的内容，保持上下文窗口干净。

**平台无关内容。** skill 指令不硬编码任何 agent 的工具名或 UI 命令。平台特定映射分离在 `references/platform-mapping.md`。

**发布前质量门控。** 每个 skill 经过三层检查 — 结构完整性（自动化）、内容质量（人工）、实际验证（人工）。未通过则留在 `draft/`。

## 权衡说明

**单一来源约束。** 我们有意避免第三方 skill 插件。好处是一套一致的 skill 无冲突；代价是不能直接混用其他生态的 skill。如果第三方 skill 更好，我们会吸收并改写进来。

**150 行 SKILL.md 限制。** 常见场景下保持低 token 开销，但某些 skill 需要二次加载 `references/`。这是刻意设计 — agent 只在需要深度时才付出上下文成本。

**Shell 兼容性。** 所有 shell 脚本同时兼容 bash 和 zsh（不使用 bash 特有语法）。避免平台问题，但也排除了某些 bash 便利特性。

**无自动同步。** 上游变更按月度手动评估和合并。保证质量和意图一致，但可能比上游延迟最多一个月。

## 仓库结构

```
ai-agent/
├── skills/                # 所有 skill，按桶分类
│   ├── engineering/       # 软件开发
│   ├── productivity/      # 效率提升（非编码）
│   ├── composition/       # 内容生成
│   ├── workflow/          # Git、Jira、部署、迁移
│   ├── misc/              # 其他
│   ├── draft/             # 开发中（不发布）
│   └── deprecated/        # 已废弃（不发布）
├── configs/               # 配置模板与备份
├── hooks/                 # Agent hook 脚本
├── docs/                  # 架构设计、skill 写作指南
├── scripts/               # 仓库工具（校验等）
├── .claude-plugin/        # Claude Code 插件清单
└── .agents/               # OpenAI Agents SDK / Codex 清单
```

## 参与贡献

1. 在 `skills/draft/` 创建你的 skill
2. 运行 `scripts/validate-skill.sh` 检查结构完整性
3. 手动验证 skill 在目标平台上能端到端工作
4. 提交 PR — skill 会被审核并移到合适的桶

详见 [Skill 写作指南](./docs/skill-writing-guide.md)。

## 文档

- [架构设计](./docs/architecture_design.md)
- [Skill 写作指南](./docs/skill-writing-guide.md)

## 参考

- [anthropics agent skills](https://github.com/anthropics/skills)
- [superpowers skills](https://github.com/obra/superpowers)
- [andrej karpathy skills](https://github.com/forrestchang/andrej-karpathy-skills)
- [mattpocock skills](https://github.com/mattpocock/skills)

## 许可证

[MIT](./LICENSE)

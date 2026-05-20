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

运行：

```bash
npx skills@latest add p2tree/ai-agent
```

选择你想要的 skills。这就可以了。

当启动你的 agent 控制台后，可以运行 `manage-skills` skill 进行交互式的 skills 管理。

仓库里的 Configs 文件需要手动移植到你的系统或工程目录下，进行修改和维护。

## 内容一览

### Configs（配置模板）

| 配置 | 说明 |
|------|------|
| [project/CLAUDE.md](./configs/project/CLAUDE.md) | 项目级 agent 配置模板 — 编码原则、工作流规则、反模式 |
| [user/CLAUDE.md](./configs/user/CLAUDE.md) | 用户级 agent 配置模板 — 个人偏好、语言、角色上下文 |

将模板复制到项目根目录（`CLAUDE.md`）或家目录（`~/.claude/CLAUDE.md`），按需定制即可。

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
| [caveman](./skills/productivity/caveman/SKILL.md) | 超压缩通信模式 — 省 token、弱网络传输快、本地弱模型生成快 |
| [grill-me](./skills/productivity/grill-me/SKILL.md) | 逐问压力测试你的计划或设计 |

### Composition（内容生成）

| Skill | 说明 |
|-------|------|
| [coauthoring](./skills/composition/coauthoring/SKILL.md) | 人机协作撰写文章、博客、随笔等 prose 类内容 |
| [work-report](./skills/composition/work-report/SKILL.md) | 适应中国本土企业的工作汇报（日报、年终总结到晋升述职全场景覆盖） |
| [arch-doc](./skills/composition/arch-doc/SKILL.md) | 架构设计说明书 — 从代码生成、更新或对齐架构文档 |

### Workflow（工作流）

| Skill | 说明 |
|-------|------|
| [writing-plans](./skills/workflow/writing-plans/SKILL.md) | 将 spec 拆解为 bite-sized 实施计划 |
| [executing-plans](./skills/workflow/executing-plans/SKILL.md) | 逐步执行计划，带验证门控 |
| [finishing-branch](./skills/workflow/finishing-branch/SKILL.md) | 完成开发分支：验证 → 选择操作 → 清理 |
| [writing-prd](./skills/workflow/writing-prd/SKILL.md) | 将对话上下文合成为 PRD |
| [decomposing-issues](./skills/workflow/decomposing-issues/SKILL.md) | 将 PRD 拆分为垂直切片的独立 issue |
| [triage](./skills/workflow/triage/SKILL.md) | 状态机驱动的 issue 分诊 |
| [init-agent-environment](./skills/workflow/init-agent-environment/SKILL.md) | 初始化 agent 工作环境 — issue tracker、标签、领域文档 |

### Misc（杂项）

| Skill | 说明 |
|-------|------|
| [manage-skills](./skills/misc/manage-skills/SKILL.md) | 浏览、安装、审计、管理任何来源的 skill |
| [update-skills](./skills/misc/update-skills/SKILL.md) | 检查上游 skill 漂移并更新 |
| [find-skills](./skills/misc/find-skills/SKILL.md) | 从开源 skill 生态发现并安装 skill |
| [create-skill](./skills/misc/create-skill/SKILL.md) | 创建、改进、评估 skill |

## 自动创建的路径

各 skill 按统一约定将文档写入目标仓库。`init-agent-environment` skill 在初始化新仓库时会引导创建这些路径。

```
<目标仓库>/
├── CONTEXT.md                              # 领域术语表
├── docs/
│   ├── specs/                              # 设计规格
│   │   └── YYYY-MM-DD-<design_name>.md
│   ├── plans/                              # 实施计划
│   │   └── YYYY-MM-DD-<feature_name>.md
│   ├── prd/                                # 产品需求文档
│   │   └── <prd_topic_name>.md
│   ├── issues/                             # Issue 文件
│   │   └── <NN>-<issue_description>.md     # NN 为零填充的顺序编号
│   ├── adr/                                # 架构决策记录
│   │   └── <arch_design_topic_name>.md
│   └── agents/                             # Agent 运行配置
│       ├── issue-tracker.md
│       ├── triage-labels.md
│       └── domain.md
```

| 路径  | 用途 |
|------------|------|
| `CONTEXT.md` |  领域词汇表，保持 skill 输出与项目术语一致 |
| `docs/specs/` | 经验证的设计规格，实现前的产物 |
| `docs/plans/` | 逐步实施计划 |
| `docs/prd/` |  产品需求文档 |
| `docs/issues/` | 单个 issue 文件；wontfix 拒绝记录加 `-wontfix` 后缀 |
| `docs/adr/` |  架构决策记录 |
| `docs/agents/` | Agent 环境配置，所有工作流 skill 消费 |

**注意：** `docs/agents/` 是 agent 运行配置，不是设计文档。

## 一次性设置 Skill

大部分 skill 按需触发，但有几个是一次性设置：

| Skill | 作用范围 | 持久化内容 |
|-------|---------|-----------|
| `manage-skills` | 每台机器 | 管理 agent skill 目录中的 skill；换机器需要重装 |
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

**选择性收录。** 社区热门 skill 欢迎贡献，但部分 skill 因核心价值依赖特定平台或服务，与平台无关原则冲突而未收录。如果你需要本仓库未覆
盖的外部 skill，可使用 [find-skills](./skills/misc/find-skills/SKILL.md) skill 搜索开源生态。

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
- [vercel-labs skills](https://github.com/vercel-labs/skills)

## 许可证

[MIT](./LICENSE)

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

## 从 Skill 到编队

单个 skill 已经很有用，但真正的价值在于组合成工作流。一个模糊想法变成上线功能，靠的是 brainstorming 探索、grill-me 压测决策、brainstorming 记录 spec，再由 writing-plans、executing-plans、code-review、finish-work 把代码推进到 reviewed commit 和 PR。一个 bug 由 triage 分流、diagnose 定位、code-review 审查、finish-work 收尾。

每个 skill 都在你的虚拟开发团队中扮演一个角色——产品经理、架构师、调试专家、审查者。[**Skill 编队手册**](./docs/skill-playbook.md) 为 11 个常见工作场景（想法落地、Bug 排查、项目接手、重构、预研、前端开发、文档编写……）绘制了完整的 skill 编队方案：调哪些 skill、什么顺序、之间怎么衔接。

**阅读 [Skill 编队手册](./docs/skill-playbook.md) →**

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
| [codebase-design](./skills/engineering/codebase-design/SKILL.md) | 深模块共享 reference — interface/depth/seam/adapter/leverage/locality |
| [diagnose](./skills/engineering/diagnose/SKILL.md) | 调试循环：可对 bug 变红的反馈环 → 复现+最小化 → 假设 → 插桩 → 修复 → 清理 |
| [code-review](./skills/engineering/code-review/SKILL.md) | 代码审查纪律 — 校准置信度、只读审查、规格作为愿景、接收反馈流程 |
| [improve-architecture](./skills/engineering/improve-architecture/SKILL.md) | 先定范围再扫描架构摩擦，给出带推荐强度的深模块候选 |
| [frontend-design](./skills/engineering/frontend-design/SKILL.md) | 从主题素材出发，创建避开生成式默认套路的独特前端界面 |

### Productivity（效率提升）

| Skill | 说明 |
|-------|------|
| [brainstorming](./skills/productivity/brainstorming/SKILL.md) | 先读上下文的设计对话 — 逐段复述、方案对比、按规模写 design doc、builder check |
| [prototype](./skills/productivity/prototype/SKILL.md) | 回答特定问题的抛弃式原型，原型保留在 throwaway branch 作为一手证据 |
| [grill-me](./skills/productivity/grill-me/SKILL.md) | 按 frontier 分轮提问，压力测试你的计划或设计 |
| [research](./skills/productivity/research/SKILL.md) | 委托后台 agent 阅读，把带引用的结论写成 Markdown |

### Composition（内容生成）

| Skill | 说明 |
|-------|------|
| [coauthoring](./skills/composition/coauthoring/SKILL.md) | 人机协作撰写文章、博客、随笔等 prose 类内容 |
| [work-report](./skills/composition/work-report/SKILL.md) | 适应中国本土企业的工作汇报（日报、年终总结到晋升述职全场景覆盖） |
| [arch-doc](./skills/composition/arch-doc/SKILL.md) | 架构设计说明书 — 从代码生成、更新或对齐架构文档 |
| [humanizer](./skills/composition/humanizer/SKILL.md) | 去除 AI 写作痕迹 — 31 种模式、保真约束与改写边界 |

### Career （职业发展）

| Skill | 说明 |
|-------|------|
| [pre-view](./skills/career/pre-view/SKILL.md) | 模拟真实多轮面试 - 技术面、主管面、领导面，每轮不同人设面试官，最终输出客观评价报告 |
| [project-highlight](./skills/career/project-highlight/SKILL.md) | 从项目 git 日志中提取关键贡献并整理成可以用于简历、面试、述职等场景的内容 |

### Workflow（工作流）

| Skill | 说明 |
|-------|------|
| [writing-plans](./skills/workflow/writing-plans/SKILL.md) | 任务规模界定、Global Constraints、Review Focus、Interfaces 与执行交接 |
| [executing-plans](./skills/workflow/executing-plans/SKILL.md) | ledger 记录进度，ruling 处理歧义，完成契约与最终审查 |
| [finish-work](./skills/workflow/finish-work/SKILL.md) | 验证测试 → 摘要 → 提交 → 可选 PR → 更新 issue |
| [writing-prd](./skills/workflow/writing-prd/SKILL.md) | 将对话上下文合成为 PRD，先确定测试 seam |
| [decomposing-issues](./skills/workflow/decomposing-issues/SKILL.md) | 将 PRD 拆分为垂直切片的独立 issue |
| [triage](./skills/workflow/triage/SKILL.md) | issue 与外部 PR 分诊 — 冗余检查、验证、agent brief、out-of-scope 知识库 |
| [retro](./skills/workflow/retro/SKILL.md) | 会话复盘 — 导航、自动检查、编码规范、工具与信息获取 |

### Misc（杂项）

| Skill | 说明 |
|-------|------|
| [manage-skills](./skills/misc/manage-skills/SKILL.md) | 浏览、安装、审计、管理任何来源的 skill |
| [find-skills](./skills/misc/find-skills/SKILL.md) | 从开源生态发现、验证、安装和更新 skill |
| [create-skill](./skills/misc/create-skill/SKILL.md) | 用 writing-for-agents 原则创建、改进、评估 skill |

### 可选的上游 skill

以下 skill 不随本仓库打包。需要时从各自的上游来源安装。

| Skill | 能力 | 安装 |
|-------|------|------|
| `pdf` | 读取、提取、合并、拆分、旋转、水印、加密、OCR、表单 | `npx skills add anthropics/skills@pdf` |
| `docx` | 创建、读取、编辑、修订追踪、注释 | `npx skills add anthropics/skills@docx` |
| `pptx` | 演示文稿、模板、编辑、QA | `npx skills add anthropics/skills@pptx` |
| `xlsx` | 公式、重算、财务模型 | `npx skills add anthropics/skills@xlsx` |

文档类 skill 来自 [anthropics/skills](https://github.com/anthropics/skills)。

Claude Code 插件路线：`/plugin marketplace add anthropics/skills`，然后安装 `document-skills`。

前端与设计：

| Skill | 能力 | 安装 |
|-------|------|------|
| `ui-ux-pro-max` | 设计系统、风格、配色、字体配对、UX 规则、技术栈建议 | 手动 CLI — 见文档 |
| `impeccable` | critique、audit、polish、redesign、AI-slop 检测 | 手动 CLI — 见文档 |
| `web-design-guidelines` | Web UI 可访问性与 UX 规范审查 | `npx skills add vercel-labs/agent-skills@web-design-guidelines -g -y` |

详见 [可选上游 skill](./docs/external-skills.md)。`manage-skills` 也提供「安装推荐上游 skill」选项。

## 自动创建的路径

各 skill 按统一约定将文档写入目标仓库。可选的领域文档和 issue tracker 文件在真正需要时按需创建。

```
<目标仓库>/
├── GLOSSARY.md                             # 领域术语表
├── docs/
│   ├── specs/                              # 设计规格
│   │   └── YYYY-MM-DD-<design_name>.md
│   ├── plans/                              # 实施计划
│   │   └── YYYY-MM-DD-<feature_name>.md
│   └── adr/                                # 架构决策记录
│       └── <arch_design_topic_name>.md
```

| 路径  | 用途 |
|------------|------|
| `GLOSSARY.md` | 领域词汇表，保持 skill 输出与项目术语一致 |
| `docs/specs/` | 经验证的设计规格，实现前的产物 |
| `docs/plans/` | 逐步实施计划 |
| `docs/adr/` | 架构决策记录 |

## 一次性设置 Skill

大部分 skill 按需触发，只有一个是一次性设置：

| Skill | 作用范围 | 持久化内容 |
|-------|---------|-----------|
| `manage-skills` | 每台机器 | 管理 agent skill 目录中的 skill；换机器需要重装 |

## 设计哲学

**一个概念，一个 skill。** 不做重复。多个来源覆盖同一领域时，合并为一个维护良好的 skill，而非保留多个版本。

**精心筛选，而非简单聚合。** 从上游源吸收 skill 后改写，保持统一的风格、结构和术语。先理解意图再集成 — 绝不复制粘贴。

**默认渐进披露。** `SKILL.md` 保持精简；细节放 `references/`。agent 只加载需要的内容，保持上下文窗口干净。

**平台无关内容。** skill 指令不硬编码任何 agent 的工具名或 UI 命令。平台特定映射分离在 `references/platform-mapping.md`。

**发布前质量门控。** 每个 skill 经过三层检查 — 结构完整性（自动化）、内容质量（人工）、实际验证（人工）。未通过则留在 `draft/`。

## 演进检查清单

新增或修改 skill 前，先问：

1. **它承载什么决策？** 说不清就不加。
2. **它有独立触发条件吗？** 如果和现有 skill 的触发条件重叠，优先合并。
3. **它是一段规则还是多步流程？** 一两句话能说清的，放进 `CLAUDE.md` 或现有 skill 的 reference，不单独做 skill。
4. **它需要独立上下文吗？** 审查类需要；规则类不需要。
5. **它在单 agent、交叉环境、跨会话的现实中可用吗？** 如果只在理想环境可用，写清 HITL 变体或标为条件使用。
6. **它的产物的生命周期是什么？** 历史记录、living doc，还是临时工作文件？写清更新和过时规则。
7. **它是否与上游重复？** 上游有相同能力时，先评估合并；不要为了「齐全」引入重复 skill。
8. **删除它会不会损失决策能力？** 不会，就删；会，就保留但说明边界。

## 维护约定

- 合并/删除上游 skill 时，在 `skills/deprecated/README.md` 写清原因和融入位置。
- 在融入位置的桶 README 里补 `参考：`，注明来源（例如 `writing-plans` / `executing-plans` 的 `tdd`）。
- 每次调整默认流程，同步更新 `docs/skill-playbook.md` 和 `docs/system-evolution.md`。
- 规范变化（如 `GLOSSARY.md`、`finish-work`）要同时更新根 README、桶 README 和注册表。
- 用 `update-skills` skill 执行这套流程；它内置决策测试以及合并/废弃/推荐上游的具体做法。

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
│   ├── career/            # 职业发展
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

- [Skill 编队手册](./docs/skill-playbook.md) — 不同工作场景下如何将 skill 编组成队、协同作战
- [架构设计](./docs/architecture_design.md)
- [Skill 写作指南](./docs/skill-writing-guide.md)

## 参考

- [anthropics agent skills](https://github.com/anthropics/skills)
- [superpowers skills](https://github.com/obra/superpowers)
- [andrej karpathy skills](https://github.com/forrestchang/andrej-karpathy-skills)
- [mattpocock skills](https://github.com/mattpocock/skills)
- [vercel-labs skills](https://github.com/vercel-labs/skills)
- [op7418 Humanizer-zh](https://github.com/op7418/Humanizer-zh)
- [wshobson agents](https://github.com/wshobson/agents)

## 许可证

[MIT](./LICENSE)

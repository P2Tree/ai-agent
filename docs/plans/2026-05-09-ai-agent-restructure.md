# ai-agent 仓库重构实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 将 ai-agent 仓库从当前的扁平 `claude/skills/` 结构，重构为架构设计文档定义的新布局

**Architecture:** 保留现有 skill 文件不动，先建好新目录结构和基础设施（.gitignore、桶级 README、plugin.json、validate-skill.sh、skill-writing-guide.md），然后将 skill 从旧路径 `claude/skills/` 移动到新路径 `skills/<bucket>/`，最后清理旧目录并更新根 README 和 CLAUDE.md

**Tech Stack:** shell scripts, markdown, JSON

---

### Task 1: 创建新目录结构

**Files:**
- Create: `skills/engineering/`, `skills/productivity/`, `skills/composition/`, `skills/workflow/`, `skills/misc/`, `skills/personal/`, `skills/internal/`, `skills/draft/`, `skills/deprecated/`
- Create: `configs/project/`, `configs/user/`, `configs/internal/`
- Create: `hooks/`
- Create: `scripts/`
- Create: `internal/`

- [ ] **Step 1: 创建所有目录**

```bash
cd /home/e00618/ai-agent
mkdir -p skills/{engineering,productivity,composition,workflow,misc,personal,internal,draft,deprecated}
mkdir -p configs/{project,user,internal}
mkdir -p hooks
mkdir -p scripts
mkdir -p internal
```

- [ ] **Step 2: 验证目录结构**

```bash
find skills configs hooks scripts internal -type d | sort
```

Expected: 列出所有新建目录

- [ ] **Step 3: Commit**

```bash
git add skills/ configs/ hooks/ scripts/ internal/
git commit -m "[REFACTOR] scaffold new directory structure per architecture doc"
```

---

### Task 2: 创建 .gitignore

**Files:**
- Create: `.gitignore`

- [ ] **Step 1: 创建 .gitignore，排除所有 internal 目录**

```
# 公司内部资料，不开源
skills/internal/
configs/internal/
internal/
```

- [ ] **Step 2: Commit**

```bash
git add .gitignore
git commit -m "[CHORE] add .gitignore to exclude internal directories"
```

---

### Task 3: 移动现有 skill 到新桶结构

**Files:**
- Move: `claude/skills/brainstorming/` → `skills/engineering/brainstorming/`
- Move: `claude/skills/tdd/` → `skills/engineering/tdd/`
- Move: `claude/skills/diagnose/` → `skills/engineering/diagnose/`
- Move: `claude/skills/code-review-discipline/` → `skills/engineering/code-review/` (rename)
- Move: `claude/skills/improve-architecture/` → `skills/engineering/improve-architecture/`
- Move: `claude/skills/symbol-refactor/` → `skills/engineering/symbol-refactor/`
- Move: `claude/skills/caveman/` → `skills/productivity/caveman/`
- Move: `claude/skills/grill-me/` → `skills/productivity/grill-me/`
- Move: `claude/skills/article-series-writer/` → `skills/composition/article-series-writer/`
- Move: `claude/skills/git-guardrails-claude-code/` → `skills/workflow/git-guardrails/` (rename)
- Move: `claude/skills/bash-to-zsh-converter/` → `skills/workflow/bash-to-zsh-converter/`
- Move: `claude/skills/to-prd/` → `skills/workflow/to-prd/`
- Move: `claude/skills/to-issues/` → `skills/workflow/to-issues/`
- Move: `claude/skills/init-agent-environment/` → `skills/workflow/init-agent-environment/`
- Move: `claude/skills/skill-creator/` → `skills/workflow/skill-creator/`
- Move: `claude/skills/weekly-summary/` → `skills/workflow/weekly-summary/`

- [ ] **Step 1: 移动 engineering 类 skill**

```bash
cd /home/e00618/ai-agent
git mv claude/skills/brainstorming skills/engineering/
git mv claude/skills/tdd skills/engineering/
git mv claude/skills/diagnose skills/engineering/
git mv claude/skills/code-review-discipline skills/engineering/code-review
git mv claude/skills/improve-architecture skills/engineering/
git mv claude/skills/symbol-refactor skills/engineering/
```

- [ ] **Step 2: 移动 productivity 类 skill**

```bash
git mv claude/skills/caveman skills/productivity/
git mv claude/skills/grill-me skills/productivity/
```

- [ ] **Step 3: 移动 composition 类 skill**

```bash
git mv claude/skills/article-series-writer skills/composition/
```

- [ ] **Step 4: 移动 workflow 类 skill**

```bash
git mv claude/skills/git-guardrails-claude-code skills/workflow/git-guardrails
git mv claude/skills/bash-to-zsh-converter skills/workflow/
git mv claude/skills/to-prd skills/workflow/
git mv claude/skills/to-issues skills/workflow/
git mv claude/skills/init-agent-environment skills/workflow/
git mv claude/skills/skill-creator skills/workflow/
git mv claude/skills/weekly-summary skills/workflow/
```

- [ ] **Step 5: 删除空的 claude/skills/ 目录**

```bash
# bash-to-fish-converter 是空目录，直接删除
rmdir claude/skills/bash-to-fish-converter 2>/dev/null
rmdir claude/skills 2>/dev/null
rmdir claude 2>/dev/null
```

- [ ] **Step 6: 验证移动结果**

```bash
find skills -name "SKILL.md" | sort
```

Expected: 16 个 SKILL.md 文件，分布在新桶路径下

- [ ] **Step 7: Commit**

```bash
git add -A
git commit -m "[REFACTOR] move skills from claude/skills/ to new bucket structure"
```

---

### Task 4: 更新重命名 skill 的 SKILL.md frontmatter

**Files:**
- Modify: `skills/engineering/code-review/SKILL.md`
- Modify: `skills/workflow/git-guardrails/SKILL.md`

- [ ] **Step 1: 更新 code-review 的 name 字段**

在 `skills/engineering/code-review/SKILL.md` 中，将 frontmatter 的 `name: code-review-discipline` 改为 `name: code-review`

- [ ] **Step 2: 更新 git-guardrails 的 name 字段**

在 `skills/workflow/git-guardrails/SKILL.md` 中，将 frontmatter 的 `name: git-guardrails-claude-code` 改为 `name: git-guardrails`，并将 description 中平台相关内容移除

- [ ] **Step 3: Commit**

```bash
git add skills/engineering/code-review/SKILL.md skills/workflow/git-guardrails/SKILL.md
git commit -m "[REFACTOR] update frontmatter for renamed skills"
```

---

### Task 5: 创建桶级 README.md

**Files:**
- Create: `skills/engineering/README.md`
- Create: `skills/productivity/README.md`
- Create: `skills/composition/README.md`
- Create: `skills/workflow/README.md`
- Create: `skills/misc/README.md`
- Create: `skills/personal/README.md`
- Create: `skills/draft/README.md`
- Create: `skills/deprecated/README.md`

- [ ] **Step 1: 创建 engineering/README.md**

```markdown
# Engineering

软件开发过程中的 skill。

## brainstorming

协作式设计门控。在动手写代码之前，通过提问对齐需求，确认设计方案，避免方向错误。包含可视化伴侣用于展示原型。

适用于：开始新功能、新项目、或重大改动之前。

## tdd

红绿重构 TDD 循环，垂直切片开发。每次只写一个测试，再写最少代码通过，再重构。禁止水平切片（先写全部测试再写全部代码）。

适用于：需要用 TDD 方式开发功能或修复 bug 时。

## diagnose

六阶段调试循环：反馈环 → 复现 → 假设 → 插桩 → 修复 → 清理。强调先建立可复现的反馈环，再逐步缩小范围。

适用于：遇到难调的 bug、性能回退、或行为不符合预期时。

## code-review

代码审查纪律。审查时校准置信度与严重度匹配，不熟悉的领域多问少断，审查代码变更而非代码作者。

适用于：需要审查 PR 或代码变更时。

## improve-architecture

扫描代码库中的架构摩擦，提出"加深模块"的重构建议。基于领域语言（CONTEXT.md）和架构决策记录（ADR）进行分析。

适用于：代码库变复杂时，定期运行以保持架构健康。

## symbol-refactor

Rust 符号重命名/删除/修改流程：先扫描所有引用，编辑，验证编译，同步测试，同步文档。

适用于：需要重命名、删除或修改 Rust 中的符号时。
```

- [ ] **Step 2: 创建 productivity/README.md**

```markdown
# Productivity

提高工作效率但不直接写代码的 skill。

## caveman

超压缩通信模式。去掉填充词、冠词、客套话，只保留技术实质。约省 75% token。

适用于：需要降低 token 消耗时。

## grill-me

逐个问题追问，压力测试你的计划或设计。遍历决策树的每个分支，逐一解决。能通过探索代码库回答的问题，不问你。

适用于：有了一个想法但还没想清楚，想让 agent 帮你理清时。
```

- [ ] **Step 3: 创建 composition/README.md**

```markdown
# Composition

文章、文档、图表等内容生成相关 skill。

## article-series-writer

基于大纲并行编写系列文章，自动 review 闭环。每篇文章独立编写，完成后自动审校并修订。

适用于：需要批量撰写系列技术文章时。
```

- [ ] **Step 4: 创建 workflow/README.md**

```markdown
# Workflow

工作流操作相关 skill。

## git-guardrails

设置 agent hooks 来阻止危险的 git 操作（push、reset --hard、clean、branch -D 等），防止误操作。

适用于：希望在 agent 工作时保护 git 仓库安全时。

## bash-to-zsh-converter

将 bash 脚本翻译为 zsh 兼容语法。包含 10 项常见不兼容问题清单，每项带严重度、示例和修复方案。

适用于：有 bash 脚本需要在 zsh 环境中运行时。

## to-prd

将当前对话上下文合成为 PRD 文档（问题陈述、方案、用户故事、实现决策、测试决策），并发布到 issue tracker。

适用于：对齐需求后需要输出正式 PRD 时。

## to-issues

将计划或 PRD 拆分为垂直切片的独立 issue，每个 issue 可独立认领和执行。

适用于：PRD 写好后需要拆分执行任务时。

## init-agent-environment

初始化 agent 工作环境：配置 issue tracker、triage 标签、领域文档布局。

适用于：新仓库首次使用 agent skill 时。

## skill-creator

创建、改进、评估 skill 的全生命周期工具。包含草稿、子 agent 测试、打分、基准对比、描述优化等环节。

适用于：需要新建或改进 skill 时。

## weekly-summary

更新周报 YAML 数据文件。自动识别员工 ID，定位 YAML 文件，处理进行中任务，创建新任务。

适用于：需要更新周报时。
```

- [ ] **Step 5: 创建 misc/README.md, personal/README.md, draft/README.md, deprecated/README.md**

```markdown
# Misc

不好归类的其他 skill。

（暂无）
```

```markdown
# Personal

个人专用 skill。脱敏后开源。

（暂无）
```

```markdown
# Draft

开发中的 skill，尚未通过质量审核。

通过审核后将移动到正式桶目录。
```

```markdown
# Deprecated

已废弃的 skill。

| Skill | 废弃原因 |
|-------|---------|
| （暂无） | |
```

- [ ] **Step 6: Commit**

```bash
git add skills/*/README.md
git commit -m "[DOCS] add bucket-level READMEs with skill descriptions"
```

---

### Task 6: 创建 .claude-plugin/plugin.json

**Files:**
- Create: `.claude-plugin/plugin.json`

- [ ] **Step 1: 创建 plugin.json，列出所有正式桶中的 skill**

```json
{
  "name": "ai-agent",
  "skills": [
    "./skills/engineering/brainstorming",
    "./skills/engineering/tdd",
    "./skills/engineering/diagnose",
    "./skills/engineering/code-review",
    "./skills/engineering/improve-architecture",
    "./skills/engineering/symbol-refactor",
    "./skills/productivity/caveman",
    "./skills/productivity/grill-me",
    "./skills/composition/article-series-writer",
    "./skills/workflow/git-guardrails",
    "./skills/workflow/bash-to-zsh-converter",
    "./skills/workflow/to-prd",
    "./skills/workflow/to-issues",
    "./skills/workflow/init-agent-environment",
    "./skills/workflow/skill-creator",
    "./skills/workflow/weekly-summary"
  ]
}
```

- [ ] **Step 2: Commit**

```bash
git add .claude-plugin/plugin.json
git commit -m "[CHORE] add Claude Code plugin registry"
```

---

### Task 7: 创建 .agents/skills.json

**Files:**
- Create: `.agents/skills.json`

- [ ] **Step 1: 创建 skills.json**

内容与 plugin.json 相同的 skill 列表，格式适配 OpenAI Agents SDK / Codex：

```json
{
  "name": "ai-agent",
  "skills": [
    "./skills/engineering/brainstorming",
    "./skills/engineering/tdd",
    "./skills/engineering/diagnose",
    "./skills/engineering/code-review",
    "./skills/engineering/improve-architecture",
    "./skills/engineering/symbol-refactor",
    "./skills/productivity/caveman",
    "./skills/productivity/grill-me",
    "./skills/composition/article-series-writer",
    "./skills/workflow/git-guardrails",
    "./skills/workflow/bash-to-zsh-converter",
    "./skills/workflow/to-prd",
    "./skills/workflow/to-issues",
    "./skills/workflow/init-agent-environment",
    "./skills/workflow/skill-creator",
    "./skills/workflow/weekly-summary"
  ]
}
```

- [ ] **Step 2: Commit**

```bash
git add .agents/skills.json
git commit -m "[CHORE] add OpenAI Agents SDK / Codex skill registry"
```

---

### Task 8: 创建 scripts/validate-skill.sh

**Files:**
- Create: `scripts/validate-skill.sh`

- [ ] **Step 1: 编写 validate-skill.sh**

脚本功能：
- 检查 SKILL.md 是否存在
- 检查 frontmatter 格式（name + description）
- 检查 description 格式（含 "Use when"）
- 检查 description 不超过 1024 字符
- 检查 SKILL.md 不超过 150 行
- 扫描敏感信息（密钥关键词、绝对路径模式）
- 输出 PASS/FAIL 汇总

```bash
#!/usr/bin/env zsh
# validate-skill.sh — 检查 skill 结构完整性

set -euo pipefail

skill_dir="${1:?Usage: validate-skill.sh <skill-directory>}"
errors=0

# 1. SKILL.md 存在
skill_file="$skill_dir/SKILL.md"
if [[ ! -f "$skill_file" ]]; then
  echo "FAIL: SKILL.md not found in $skill_dir"
  exit 1
fi

# 2. frontmatter 格式
if ! grep -q '^name:' "$skill_file"; then
  echo "FAIL: missing 'name' in frontmatter"; ((errors++))
fi
if ! grep -q '^description:' "$skill_file"; then
  echo "FAIL: missing 'description' in frontmatter"; ((errors++))
fi

# 3. description 含 "Use when"
if ! grep -qi 'use when' "$skill_file"; then
  echo "FAIL: description missing 'Use when' trigger"; ((errors++))
fi

# 4. description 不超过 1024 字符
desc_line=$(grep '^description:' "$skill_file")
desc_len=${#desc_line}
if (( desc_len > 1024 )); then
  echo "FAIL: description exceeds 1024 chars ($desc_len)"; ((errors++))
fi

# 5. SKILL.md 不超过 150 行
line_count=$(wc -l < "$skill_file")
if (( line_count > 150 )); then
  echo "FAIL: SKILL.md exceeds 150 lines ($line_count)"; ((errors++))
fi

# 6. 敏感信息扫描
if grep -qiE '(password|secret|api.key|token|AKIA|BEGIN RSA)' "$skill_file"; then
  echo "FAIL: possible secret found in SKILL.md"; ((errors++))
fi
if grep -qE '/home/[a-z]' "$skill_file"; then
  echo "FAIL: absolute path found in SKILL.md"; ((errors++))
fi

if (( errors > 0 )); then
  echo "RESULT: $errors error(s) in $skill_dir"
  exit 1
else
  echo "PASS: $skill_dir"
  exit 0
fi
```

- [ ] **Step 2: 设置可执行权限**

```bash
chmod +x scripts/validate-skill.sh
```

- [ ] **Step 3: 对所有现有 skill 运行验证**

```bash
for skill in skills/*/*/SKILL.md; do
  scripts/validate-skill.sh "$(dirname "$skill")"
done
```

Expected: 部分 skill 可能因为缺少 "Use when" 或行数超限而 FAIL——这些是后续改进项

- [ ] **Step 4: Commit**

```bash
git add scripts/validate-skill.sh
git commit -m "[TOOL] add skill structure validation script"
```

---

### Task 9: 创建 docs/skill-writing-guide.md

**Files:**
- Create: `docs/skill-writing-guide.md`

- [ ] **Step 1: 编写 skill-writing-guide.md**

内容从架构文档第 4 节和第 5 节提炼，作为独立的写作参考：

```markdown
# Skill 写作指南

本文档说明如何写一个好的 agent skill。

## 基本结构

每个 skill 是一个目录，包含：

```
skill-name/
├── SKILL.md           ← 必需
├── references/        ← 可选，详细参考
├── scripts/           ← 可选，确定性脚本
└── examples/          ← 可选，示例
```

## SKILL.md 写法

### Frontmatter

```yaml
---
name: skill-name
description: 一句话说做什么。Use when [触发条件]。
---
```

`description` 是 agent 决定是否加载这个 skill 的唯一依据。格式：
- 第一句：做什么
- 第二句：`Use when` + 什么时候触发
- 不超过 1024 字符

好的例子：`Extract text and tables from PDF files. Use when working with PDF files.`
坏的例子：`Helps with documents.`

### 正文结构

```markdown
# 技能标题

## 要做什么
简洁的指令，agent 照着执行。

## 流程
（如果有步骤，用 checklist 列出）

## 注意事项
（坑、反模式、边界情况）

## 参考
（详细内容拆到 references/，这里链接过去）
```

### 约束

- SKILL.md 不超过 150 行；超出的内容拆到 `references/`
- 不含敏感信息（密钥、绝对路径、个人身份信息）
- 术语一致，不自造黑话
- 平台无关——不包含特定 agent 的工具名或指令

## 渐进披露

SKILL.md 保持精简，agent 按需加载 `references/` 中的详细内容。适用场景：

- skill 流程有大量细节步骤
- 包含平台映射表
- 包含详细示例或模板

拆到 references/ 的内容在 SKILL.md 中用链接引用：`详见 [参考文档](references/detail.md)`

## 何时用 scripts

当操作满足以下条件时写成脚本：

- 确定性操作（格式化、校验、模板生成）
- 每次生成的代码都一样
- 需要明确的错误处理

脚本省 token 且结果更可靠。

## 质量检查清单

### 结构完整性
- [ ] SKILL.md 存在且 frontmatter 格式正确
- [ ] description 含 `Use when` 触发条件
- [ ] description 不超过 1024 字符
- [ ] SKILL.md 不超过 150 行
- [ ] 无敏感信息

### 内容质量
- [ ] 指令明确，agent 可以直接照做
- [ ] 流程类技能有步骤 checklist
- [ ] 包含注意事项或反模式
- [ ] 术语一致
- [ ] 无废话

### 实际验证
- [ ] 至少手动跑过一次完整流程
- [ ] 在目标平台上能正确触发
- [ ] scripts/ 下的脚本可执行且幂等

可用 `scripts/validate-skill.sh <skill-dir>` 自动检查结构完整性。
```

- [ ] **Step 2: Commit**

```bash
git add docs/skill-writing-guide.md
git commit -m "[DOCS] add skill writing guide"
```

---

### Task 10: 更新根 README.md

**Files:**
- Modify: `README.md`

- [ ] **Step 1: 重写 README.md**

按架构文档第 6 节定义的格式，列出所有正式桶的 skill，每行一个。同时在末尾加上目录说明。

```markdown
# ai-agent

AI 编码助手技能仓库。收集、融合、维护各类 agent skill 及相关配置。

## 目录说明

| 目录 | 用途 |
|------|------|
| `skills/` | 所有 skill，按桶分类 |
| `configs/` | 配置文件模板与备份 |
| `hooks/` | Agent hooks 脚本 |
| `docs/` | 文档 |
| `scripts/` | 仓库级工具 |
| `.claude-plugin/` | Claude Code 插件注册表 |
| `.agents/` | OpenAI Agents SDK / Codex 注册表 |

## Engineering

- **[brainstorming](./skills/engineering/brainstorming/SKILL.md)** — 协作式设计门控，动手前对齐需求
- **[tdd](./skills/engineering/tdd/SKILL.md)** — 红绿重构 TDD 循环
- **[diagnose](./skills/engineering/diagnose/SKILL.md)** — 六阶段调试循环
- **[code-review](./skills/engineering/code-review/SKILL.md)** — 代码审查纪律
- **[improve-architecture](./skills/engineering/improve-architecture/SKILL.md)** — 架构改进
- **[symbol-refactor](./skills/engineering/symbol-refactor/SKILL.md)** — Rust 符号重构

## Productivity

- **[caveman](./skills/productivity/caveman/SKILL.md)** — 超压缩通信模式
- **[grill-me](./skills/productivity/grill-me/SKILL.md)** — 逐问压力测试计划

## Composition

- **[article-series-writer](./skills/composition/article-series-writer/SKILL.md)** — 系列文章批量写作

## Workflow

- **[git-guardrails](./skills/workflow/git-guardrails/SKILL.md)** — 阻止危险 git 操作
- **[bash-to-zsh-converter](./skills/workflow/bash-to-zsh-converter/SKILL.md)** — bash 转 zsh 兼容语法
- **[to-prd](./skills/workflow/to-prd/SKILL.md)** — 对话上下文合成 PRD
- **[to-issues](./skills/workflow/to-issues/SKILL.md)** — PRD 拆分为垂直切片 issue
- **[init-agent-environment](./skills/workflow/init-agent-environment/SKILL.md)** — 初始化 agent 工作环境
- **[skill-creator](./skills/workflow/skill-creator/SKILL.md)** — 创建和改进 skill
- **[weekly-summary](./skills/workflow/weekly-summary/SKILL.md)** — 更新周报

## 文档

- [架构设计](./docs/architecture.md)
- [Skill 写作指南](./docs/skill-writing-guide.md)
```

- [ ] **Step 2: Commit**

```bash
git add README.md
git commit -m "[DOCS] rewrite root README with new bucket structure"
```

---

### Task 11: 更新 CLAUDE.md

**Files:**
- Modify: `claude/CLAUDE.md` → 移动到根目录 `CLAUDE.md`

- [ ] **Step 1: 将 claude/CLAUDE.md 移动到根目录**

```bash
git mv claude/CLAUDE.md CLAUDE.md
```

- [ ] **Step 2: 在 CLAUDE.md 中追加仓库开发规范**

在文件末尾追加：

```markdown

## 本仓库开发规范

- 新建 skill 先放 `skills/draft/`，通过质量审核后 mv 到正式桶
- skill 毕业时同时更新根 README、桶 README、所有注册表
- 所有 skill 不含敏感信息（密钥、绝对路径、个人身份信息）
- skill 内容保持平台无关，平台映射放 references/
- 使用 `scripts/validate-skill.sh <skill-dir>` 检查结构完整性
- 参考 `docs/skill-writing-guide.md` 了解 skill 写作规范
```

- [ ] **Step 3: 删除空的 claude/ 目录**

```bash
rmdir claude 2>/dev/null || rm -rf claude
```

- [ ] **Step 4: Commit**

```bash
git add -A
git commit -m "[REFACTOR] move CLAUDE.md to root and add repo development rules"
```

---

### Task 12: 最终验证

- [ ] **Step 1: 验证目录结构**

```bash
cd /home/e00618/ai-agent
find . -not -path './.git/*' -type f | sort
```

Expected: 文件都在新路径下，无残留的 `claude/` 目录

- [ ] **Step 2: 对所有 skill 运行验证**

```bash
for skill in skills/*/*/SKILL.md; do
  scripts/validate-skill.sh "$(dirname "$skill")" || true
done
```

- [ ] **Step 3: 检查注册表与 README 一致性**

验证 plugin.json 和 skills.json 中列出的 skill 数量与 README 中列出的数量一致（16 个）。

```bash
echo "plugin.json skills:" && jq '.skills | length' .claude-plugin/plugin.json
echo "skills.json skills:" && jq '.skills | length' .agents/skills.json
echo "README skill links:" && grep -c 'SKILL.md' README.md
```

Expected: 三者数量一致

- [ ] **Step 4: 如果有差异，修复并提交**

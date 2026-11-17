# Engineering

软件开发相关的 skill。

## tdd `[自动]`

经典的 TDD 循环。写一个测试，写最少代码让它通过。一次只切一个垂直切片，不做"先把所有测试写完再写代码"的水平切片。测试只能写在预先与用户确认的 seam 上；禁止同义反复测试；重构属于 code review 阶段，不在红绿循环内。

**什么时候用：** 想用 TDD 方式开发功能或修 bug 时。

**触发方式：** 明确说要 TDD、test-first、或红绿重构，agent 时激活。

**参考：** mattpocock:tdd + superpowers:test-driven-development

## codebase-design `[自动]`

深模块设计的共享词汇和判断纪律：module / interface / depth / seam / adapter / leverage / locality，删除测试、接口即测试面、一个 adapter 是假 seam。供 `tdd`、`improve-architecture` 等 skill 在设计接口或判断测试位置时调用。

**什么时候用：** 设计或改进模块接口、决定 seam 位置、让代码更可测试或更易被 agent 导航时。

**触发方式：** 你讨论接口设计、重构模块、或测试该放在哪一层时，agent 自动激活。

**参考：** mattpocock:codebase-design

## diagnose `[自动]`

系统化的调试方法：先建立一个能对该 bug 变红的紧反馈环，再复现、最小化、假设、插桩、修复、清理。不是靠猜，是靠排除法。展示命令和输出前先脱敏；修复前先写回归测试；三次修复失败就回头质疑架构。

**什么时候用：** 遇到难调的 bug、性能回退、或行为不合预期时。

**触发方式：** 你报告 bug、说"有问题""挂了""报错""性能回退"时，agent 自动识别并激活。

**参考：** mattpocock/diagnose + superpowers:systematic-debugging

## code-review `[自动]`

做 code review 时的行为准则：不确定的地方多问少断，审查的是代码变更而不是作者，置信度和严重度要匹配。包含四阶段审查流程、严重度标签、困难反馈模式、只读审查纪律、规格作为愿景文档的判断方式、以及接收评审反馈的流程。

**什么时候用：** 审查 PR 或代码变更时。

**触发方式：** 你要求审查代码、review PR、或看 diff 时，agent 自动激活。

**参考：** superpowers:requesting-code-review + superpowers:receiving-code-review + wshobson:code-review-excellence

## improve-architecture `[自动]`

扫描代码库里的架构问题，提出"加深模块"的重构建议。先按 YAGNI 定扫描范围（优先近期热点），再基于项目的领域语言和架构决策记录分析；候选带 Recommendation strength 和 Top recommendation。

**什么时候用：** 代码库变复杂了，想定期做架构健康检查时。

**触发方式：** 当你明确说要改善架构、找重构机会、或解耦模块，agent 就会激活。

**参考：** mattpocock:improve-codebase-architecture

## frontend-design `[自动]`

做有个性的前端界面，不要千篇一律的 AI 风格。从主题素材和受众出发立意，避开生成式设计的同质化套路；先做 design plan 并对照 brief 自审，再写代码，最后做质量底线检查。

**什么时候用：** 做 Web 组件、页面、仪表盘、React 组件、HTML/CSS 布局时。

**触发方式：** 你要求构建 Web 组件、页面、仪表盘等前端界面时，agent 自动激活。

**参考：** anthropic-agent-skills:frontend-design


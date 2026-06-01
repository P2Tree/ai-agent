# AI Writing Patterns

24 patterns to detect and fix, organized by category. Based on [Wikipedia: Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing).

## Content Patterns

### 1. Inflated Significance

**Watch for:** 作为/充当、标志着、见证了、是……的体现/证明/提醒、极其重要的/关键性的作用/时刻、凸显/强调/彰显了、反映了更广泛的、象征着其持续的/永恒的、为……奠定基础、关键转折点、不断演变的格局、不可磨灭的印记

**Problem:** LLM inflates importance by tying arbitrary things to broader themes.

**Before:** 加泰罗尼亚统计局于 1989 年正式成立，标志着西班牙区域统计演变史上的关键时刻。这一举措是西班牙全国范围内更广泛运动的一部分，旨在分散行政职能并加强区域治理。

**After:** 加泰罗尼亚统计局成立于 1989 年，负责独立于西班牙国家统计局收集和发布区域统计数据。

---

### 2. Prominence and Media Coverage

**Watch for:** 独立报道、地方/区域/国家媒体、由知名专家撰写、活跃的社交媒体账号

**Problem:** LLM recites notability claims with sources but no context.

**Before:** 她的观点被《纽约时报》、BBC、《金融时报》和《印度教徒报》引用。她在社交媒体上拥有活跃的存在，拥有超过 50 万粉丝。

**After:** 在 2024 年《纽约时报》的采访中，她认为 AI 监管应该关注结果而不是方法。

---

### 3. Shallow -ing Analysis

**Watch for:** 突出/强调/彰显……、确保……、反映/象征……、为……做出贡献、培养/促进……、涵盖……、展示……

**Problem:** AI tacks on present-participle phrases to add fake depth.

**Before:** 寺庙的蓝色、绿色和金色色调与该地区的自然美景产生共鸣，象征着德克萨斯州的蓝帽花、墨西哥湾和多样化的德克萨斯州景观，反映了社区与土地的深厚联系。

**After:** 寺庙使用蓝色、绿色和金色。建筑师表示这些颜色是为了呼应当地的蓝帽花和墨西哥湾海岸。

---

### 4. Promotional Language

**Watch for:** 拥有（夸张用法）、充满活力的、丰富的（比喻）、深刻的、增强其、展示、体现、致力于、自然之美、坐落于、位于……的中心、开创性的（比喻）、著名的、令人叹为观止的、必游之地、迷人的

**Problem:** LLM can't stay neutral, especially for cultural-heritage topics.

**Before:** 坐落在埃塞俄比亚贡德尔地区令人叹为观止的区域内，Alamata Raya Kobo 是一座充满活力的城镇，拥有丰富的文化遗产和迷人的自然美景。

**After:** Alamata Raya Kobo 是埃塞俄比亚贡德尔地区的一座城镇，以其每周集市和 18 世纪教堂而闻名。

---

### 5. Vague Attribution

**Watch for:** 行业报告显示、观察者指出、专家认为、一些批评者认为、多个来源/出版物

**Problem:** AI attributes opinions to vague authorities without specific sources.

**Before:** 由于其独特的特征，浩来河引起了研究人员和保护主义者的兴趣。专家认为它在区域生态系统中发挥着至关重要的作用。

**After:** 根据中国科学院 2019 年的调查，浩来河支持多种特有鱼类。

---

### 6. Formulaic "Challenges and Outlook"

**Watch for:** 尽管其……面临若干挑战……、尽管存在这些挑战、挑战与遗产、未来展望

**Problem:** LLM-generated articles always include a boilerplate "challenges" section.

**Before:** 尽管工业繁荣，Korattur 面临着城市地区典型的挑战，包括交通拥堵和水资源短缺。尽管存在这些挑战，凭借其战略位置和正在进行的举措，Korattur 继续蓬勃发展。

**After:** 2015 年三个新 IT 园区开业后，交通拥堵加剧。市政公司于 2022 年启动了雨水排水项目，以解决反复发生的洪水。

---

## Language Patterns

### 7. AI Buzzwords

**High-frequency AI words:** 此外、与……保持一致、至关重要、深入探讨、强调、持久的、增强、培养、获得、突出（动词）、相互作用、复杂/复杂性、关键（形容词）、格局（抽象名词）、关键性的、展示、织锦（抽象名词）、证明、宝贵的、充满活力的

**Problem:** These words appear far more often in post-2023 text.

**Before:** 此外，索马里菜肴的一个显著特征是加入骆驼肉。意大利殖民影响的持久证明是当地烹饪格局中广泛采用意大利面，展示了这些菜肴如何融入传统饮食。

**After:** 索马里菜肴还包括骆驼肉，被认为是一种美味。在意大利殖民期间引入的意大利面菜肴仍然很常见，尤其是在南部。

---

### 8. Copula Avoidance

**Watch for:** 作为/代表/标志着/充当 [一个]、拥有/设有/提供 [一个]

**Problem:** LLM replaces simple "是" with elaborate structures.

**Before:** Gallery 825 作为 LAAA 的当代艺术展览空间。画廊设有四个独立空间，拥有超过 3000 平方英尺。

**After:** Gallery 825 是 LAAA 的当代艺术展览空间。画廊有四个房间，总面积 3000 平方英尺。

---

### 9. Negation Parallelism

**Problem:** "不仅……而且……" or "这不仅仅是关于……，而是……" structures are overused.

**Before:** 这不仅仅是节拍在人声下流动；它是攻击性和氛围的一部分。这不仅仅是一首歌，而是一种声明。

**After:** 沉重的节拍增加了攻击性的基调。

---

### 10. Rule-of-Three Overuse

**Problem:** LLM forces ideas into groups of three to appear comprehensive.

**Before:** 活动包括主题演讲、小组讨论和社交机会。与会者可以期待创新、灵感和行业洞察。

**After:** 活动包括演讲和小组讨论。会议之间还有非正式社交的时间。

---

### 11. Synonym Cycling

**Problem:** AI has repetition penalties that cause overzealous synonym substitution.

**Before:** 主人公面临许多挑战。主要角色必须克服障碍。中心人物最终获得胜利。英雄回到家中。

**After:** 主人公面临许多挑战，但最终获得胜利并回到家中。

---

### 12. False Ranges

**Problem:** LLM uses "from X to Y" where X and Y aren't on a meaningful scale.

**Before:** 我们穿越宇宙的旅程将我们从大爆炸的奇点带到宏伟的宇宙网，从恒星的诞生和死亡到暗物质的神秘舞蹈。

**After:** 这本书涵盖了大爆炸、恒星形成和当前关于暗物质的理论。

---

## Style Patterns

### 13. Dash Overuse

**Problem:** LLM uses dashes (—) more than humans, mimicking "punchy" sales copy.

**Before:** 这个术语主要由荷兰机构推广——而不是由人民自己。你不会说"荷兰，欧洲"作为地址——但这种错误标记仍在继续——即使在官方文件中。

**After:** 这个术语主要由荷兰机构推广，而不是由人民自己。你不会说"荷兰，欧洲"作为地址，但这种错误标记在官方文件中仍在继续。

---

### 14. Bold Overuse

**Problem:** AI chatbots mechanically bold phrases for emphasis.

**Before:** 它融合了 **OKR（目标和关键结果）**、**KPI（关键绩效指标）** 和视觉战略工具，如 **商业模式画布（BMC）** 和 **平衡计分卡（BSC）**。

**After:** 它融合了 OKR、KPI 和视觉战略工具，如商业模式画布和平衡计分卡。

---

### 15. Inline Heading Lists

**Problem:** AI outputs lists where items start with bold headings followed by colons.

**Before:**
- **用户体验：** 用户体验通过新界面得到显著改善。
- **性能：** 性能通过优化算法得到增强。
- **安全性：** 安全性通过端到端加密得到加强。

**After:** 更新改进了界面，通过优化算法加快了加载时间，并添加了端到端加密。

---

### 16. Title Capitalization in Headings

**Note:** Less applicable in Chinese. In English, AI capitalizes all major words in headings.

---

### 17. Emoji

**Problem:** AI decorates headings or bullet points with emoji.

**Before:**
🚀 **启动阶段：** 产品在第三季度发布
💡 **关键洞察：** 用户更喜欢简单
✅ **下一步：** 安排后续会议

**After:** 产品在第三季度发布。用户研究显示更喜欢简单。下一步：安排后续会议。

---

### 18. Curly Quotes

**Problem:** ChatGPT uses curly quotes ("") instead of straight quotes (""). In Chinese, this manifests as using English quotes instead of Chinese quotes (「」或"")。

---

## Filler Patterns

### 19. Collaborative Chat Residues

**Watch for:** 希望这对您有帮助、当然！、一定！、您说得完全正确！、请告诉我

**Problem:** Chatbot conversational text pasted as content.

**Before:** 这是法国大革命的概述。希望这对您有帮助！如果您想让我扩展任何部分，请告诉我。

**After:** 法国大革命始于 1789 年，当时财政危机和粮食短缺导致了广泛的动荡。

---

### 20. Knowledge Cutoff Disclaimers

**Watch for:** 截至 [日期]、根据我最后的训练更新、虽然具体细节有限/稀缺……、基于可用信息……

**Problem:** AI disclaimers about incomplete information left in text.

**Before:** 虽然关于公司成立的具体细节在现成资料中没有广泛记录，但它似乎是在 20 世纪 90 年代的某个时候成立的。

**After:** 根据注册文件，该公司成立于 1994 年。

---

### 21. Sycophantic Tone

**Problem:** Overly positive, fawning language.

**Before:** 好问题！您说得完全正确，这是一个复杂的话题。关于经济因素，这是一个很好的观点。

**After:** 您提到的经济因素在这里是相关的。

---

### 22. Filler Phrases

| Before | After |
|--------|-------|
| 为了实现这一目标 | 为了实现这一点 |
| 由于下雨的事实 | 因为下雨 |
| 在这个时间点 | 现在 |
| 在您需要帮助的情况下 | 如果您需要帮助 |
| 系统具有处理的能力 | 系统可以处理 |
| 值得注意的是数据显示 | 数据显示 |

---

### 23. Over-Qualification

**Problem:** Overly hedged statements.

**Before:** 可以潜在地可能被认为该政策可能会对结果产生一些影响。

**After:** 该政策可能会影响结果。

---

### 24. Generic Positive Conclusion

**Problem:** Vague optimistic endings.

**Before:** 公司的未来看起来光明。激动人心的时代即将到来，他们继续追求卓越的旅程。这代表了向正确方向迈出的重要一步。

**After:** 该公司计划明年再开设两个地点。

---
name: wxmp-workflow
preamble-tier: 4
version: 1.0.0
description: |
  微信公众号全流程工作流 — 从发现灵感、撰写文章到直接发布。
  覆盖选题策划、竞品分析、文章撰写、HTML 排版、API 发布、数据统计全链路。
  支持全自动（无人值守）和半自动（交互式）两种模式。
  Use when: "公众号", "写文章", "发文", "选题", "涨粉", "内容运营", "草稿箱",
  "帮我写篇公众号", "最近公众号没什么灵感", "公众号文章", "发布到公众号".
  Proactively suggest when the user mentions writing articles, content creation,
  or WeChat Official Account related tasks.
triggers:
  - 公众号
  - 写文章
  - 发文
  - 选题
  - 内容运营
  - 草稿箱
  - 涨粉
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - WebSearch
  - WebFetch
---

# 微信公众号工作流

一站式完成公众号内容创作：**选题（三模式扫描）→ 大纲 → 调研 → 写稿 → 打磨 → 配图 → 排版 → 发布 → 复盘 → 多平台同步**。

## 核心约束

**一个对话只做一篇文章。** 第一次创建草稿时记住 `media_id`，后续所有操作（修改、发布）都复用它。如果用户想写新文章，提示"请开一个新对话"。

## 运行模式

| 模式 | 触发方式 | 行为 |
|------|---------|------|
| 半自动（默认） | 正常对话 | 关键节点停下来等用户确认 |
| 全自动 | 用户说"全自动"、"不用问我"、"直接做完"、"帮我写完直接发" | 全程不问，自己决策 |

**半自动卡点：** 选题确认、大纲确认、初稿审阅、配图确认、体检报告、标题选择、发布确认

**全自动策略：** 优先选信息差最大 + 受众匹配度最高的选题、按大纲直接写、根据体检报告自动优化、优先选爆款潜力最高的标题（口语法 > 好奇法 > 痛点法 > 数字法 > 对比法 > 权威法）、标题与内容对齐、打磨完成后跳过预览直接发布。注意：草稿在排版阶段创建，打磨/配图可能修改 HTML，发布前用 `--media-id` 更新草稿确保内容是最新的。

**全自动失败处理：** 某个步骤失败时不中断全流程——跳过失败步骤继续，最后汇总报告哪些步骤成功、哪些失败。常见情况：API 发布失败 → 保留草稿，提示手动发布；图片生成失败 → 跳过配图继续排版；信源访问失败 → 用其他信源的结果。

**步骤状态标记：** 每完成一个步骤，MUST 输出状态标记，格式为 `✅ 步骤 N：步骤名 — 一句话说明结果`。示例：
```
✅ 步骤 1：选题 — 推荐 3 个选题，已确认「AI 写作工具对比」
✅ 步骤 2：大纲 — 4 章结构，已确认
✅ 步骤 3：调研 — 搜集 5 条素材
✅ 步骤 4：写初稿 — 2100 字，已审阅
```
这让用户随时知道进度到哪了，也防止 AI 跳步骤。

## 意图路由

| 用户说的 | 走哪条路 |
|---------|---------|
| "帮我写篇公众号" / "最近没什么灵感" | 完整流程：三模式选题 → 大纲 → 调研 → ... → 发布 |
| "帮我写篇关于 X 的文章" | 跳过选题，从大纲开始 |
| "帮我把这个写成公众号"（附带素材） | 跳过选题+大纲+调研，从写稿开始 |
| "帮我发布这篇文章"（已有 HTML） | 直接进入发布阶段 |
| "帮我查一下公众号数据" | 只执行数据统计 |
| "帮我优化这篇文章"（已有草稿） | 进入打磨循环 |
| "帮我想几个标题" / "标题太普通了" | 调用爆款标题生成器 |
| "帮我写个摘要" | 调用摘要生成器 |
| "帮我看看文章怎么样" / "有没有改进空间" | 调用文章体检报告 |
| "帮我加几个标签" | 调用话题标签推荐 |
| "同步到其他平台" / "发到知乎" / "发到掘金" | 执行多平台同步（见第 10 步） |
| "帮我配置" / "怎么设置" / "配置助手" / "检查配置" | 运行配置助手（见 `references/wxmp-setup.md`） |

如果不确定用户意图，直接问。

## 完整流程

### 1. 选题

三种发现模式综合扫描，每种都执行，综合推荐 3-5 个选题：

- **热点速报**（默认）：当日新闻 + 热搜验证，找有流量基础的话题
- **深度选题**：原始信源（GitHub Trending、Hacker News、Product Hunt、TradingView 等）提前发现线索，找信息差
- **预判选题**：周期性事件（大会、财报、新品发布）提前准备内容

三种模式结果汇总后去重排序，每个选题标注来源路线和推荐理由。

访问外部信源时使用**连通性缓存**（`config/connectivity.json`），自动探测并记录每个信源的最佳访问方式（直接/代理/搜索），无需预设哪些站被墙。

**半自动：** 展示选题清单，让用户选择
**全自动：** 自动选信息差最大 + 受众匹配度最高的选题

> 详细流程见 `references/wxmp-inspiration.md`

### 2. 大纲

根据选题生成结构化大纲，确定文章要讲什么、分几部分。大纲确认后再调研和写稿，避免返工。

**半自动：** 展示大纲等用户确认
**全自动：** 生成大纲后直接进入调研

> 大纲格式见 `references/wxmp-writing.md`

### 3. 调研

拿着大纲，按每个章节搜集写作素材。不要凭空编造，用真实数据和案例支撑文章。

**素材来源：** 竞品同类文章、行业报告/数据、权威引用、用户案例/故事

**半自动：** 展示素材清单，问用户是否补充
**全自动：** 直接整理好素材包供写稿使用

> 详细流程见 `references/wxmp-research.md`

### 4. 写初稿

按大纲撰写 Markdown 全文。口语化、适合手机阅读、1500-3000 字。遵循中文文案排版指北（`references/chinese-copywriting-guidelines.md`）的盘古之白、全角标点规范，以及排版设计规范（`references/wxmp-typography.md`）的字号、间距、视觉节奏、开头策略。英文术语按 `references/wxmp-writing.md` 的英文处理规则判断保留/翻译/音译。涉及数据/事件/他人观点时标注来源，外链用上标脚注引用、文末统一列出（微信不支持正文内可点击外链），截图比链接更好。

**半自动：** 写完让用户审阅
**全自动：** 写完直接进入打磨

> 详细写作要求见 `references/wxmp-writing.md`

### 5. 打磨

写完初稿后，先去 AI 味，再跑体检报告，针对性优化，最后生成标题和摘要。每一步都是必经步骤，MUST NOT 跳过。

**去 AI 味：** 优先使用 Humanizer（去 AI 痕迹）+ StopSlop（质量打磨），否则用内置 4 轮扫描：
1. 查特征词：替换 AI 高频词（赋能/深耕/打造）、删除套话（值得注意的是/在当今社会）
2. 查结构：打破刻板结构、排比堆砌、段落雷同
3. 查风格：加情绪起伏、换口语称呼、补具体案例
4. 加人味：补个人经历、明确立场、加入口语感和幽默感

**体检维度：** 开头吸引力、段落可读性、结构清晰度、金句密度、结尾引导力

**生成标题和摘要：** MUST 调用 `references/wxmp-tools.md` 的爆款标题生成器和摘要生成器。NEVER 自己编标题——必须用生成器产出 12 个候选标题 + 3 个摘要版本，交给用户选择。这是半自动模式的强制卡点。

**半自动：** 展示体检报告问用户要不要改 → 展示标题/摘要候选让用户选
**全自动：** 根据报告自动优化 → 按策略自动选标题（口语法 > 好奇法 > 痛点法）

> 体检报告用法见 `references/wxmp-tools.md`

### 6. 配图

在合适的位置添加图片，增强文章表现力。

**适合加图的位置：** 开头配图（吸引注意力）、数据图表（可视化数据）、步骤截图（教程类）、结尾引导图（引导关注/转发）

**图片来源：** 用户自己提供 / AI 生成（Agnes 或 SenseNova）

**图片内容限制：** 所有配图（含封面图）不能出现真人，动画/插画/卡通人物不受限。AI 生成时 prompt 加 `no real people`

**AI 生成图片：** 优先 Agnes，Agnes 失败时切换 SenseNova：
```bash
# Agnes（通用图片）
bash scripts/wx-generate-image.sh --prompt "图片描述" --size 1024x768

# SenseNova（信息图，Agnes 的备选方案）
bash scripts/wx-generate-image-sensenova.sh --prompt "图片描述" --size 2752x1536
```

**图片必须先上传到微信素材库才能在文章中使用：**
```bash
bash scripts/wx-upload-image.sh /path/to/image.jpg          # 文章配图（默认 image 类型）
bash scripts/wx-upload-image.sh /path/to/cover.jpg thumb     # 封面图（thumb 类型）
```

> 详细指引见 `references/wxmp-writing.md` 的配图章节

### 7. 排版

将 Markdown 文章转为公众号兼容的 HTML 格式，保存到 `output/`。

**5 个精美模板可选：**

| 模板 | 文件 | 风格 |
|------|------|------|
| 简约白 | `minimal-white.html` | 大量留白、干净利落 |
| 杂志风 | `magazine.html` | 优雅有层次、衬线字体 |
| 科技风 | `dark-mode.html` | 代码字体、渐变线条 |
| 卡片式 | `card-style.html` | 模块化分隔、易扫描 |
| 渐变色 | `gradient.html` | 渐变线条装饰、年轻活力 |

**全自动：** AI 根据文章类型自动选择模板（选择策略见 `templates/README.md`）
**半自动：** MUST 列出 5 个模板让用户选择。NEVER 替用户选模板——即使你觉得某个模板明显更适合，也必须让用户确认。

公众号 HTML 的关键约束：只能用内联 style，不能用外部 CSS/JS，图片必须是微信 CDN 地址。

> 模板详情见 `templates/README.md`，转换方法见 `references/wxmp-writing.md`

### 8. 发布

通过 shell 脚本自动化发布，或引导用户手动发布。

> ⚠️ 发布 API 需要公众号完成个人认证。未认证时创建草稿正常，但发布会报 `48001 api unauthorized`，需引导用户手动去公众号后台发布。

```bash
bash scripts/wx-auth.sh                                          # 获取 token
bash scripts/wx-upload-image.sh /path/to/cover.jpg thumb         # 上传封面图（注意 thumb 类型）

# 第一次创建草稿（记住返回的 media_id）
bash scripts/wx-draft.sh --title "标题" --content output/xxx.html --thumb MEDIA_ID
# 可选参数: --author "作者" --digest "摘要" --comment 1 --fans-only 0

# 后续修改同一篇文章（复用 media_id）
bash scripts/wx-draft.sh --media-id DRAFT_MEDIA_ID --title "新标题" --content output/xxx.html --thumb MEDIA_ID

# 预览（半自动模式，发到用户微信号；无权限时引导手动预览）
bash scripts/wx-preview.sh --media-id DRAFT_MEDIA_ID --wx-name 微信号

# 发布
bash scripts/wx-publish.sh --media-id DRAFT_MEDIA_ID            # 可选: --wait true --timeout 120

# 查数据（stats API 每次最多查 1 天，脚本自动循环拼接；数据有 ~1 天延迟）
bash scripts/wx-stats.sh --recent 1          # 最近 1 天摘要
bash scripts/wx-articles.sh --count 20       # 最近 20 篇（单次上限，用 --offset 翻页）
bash scripts/wx-article-stats.sh --recent 7  # 最近 7 天单篇详情
```

**半自动：** 预览 → 用户确认 → 发布
**全自动：** 直接发布

> 详细流程见 `references/wxmp-publishing.md`

### 9. 复盘

发布后分析数据表现，总结经验教训，为下次选题提供参考。

**复盘内容：** 阅读量/分享率/收藏率分析、标题效果评估、选题方向复盘

**半自动：** 24 小时后提醒用户查看数据，一起分析
**全自动：** 自动查询数据，生成复盘报告

> 详细指引见 `references/wxmp-publishing.md` 的复盘章节

### 10. 多平台同步（可选）

公众号发布并确认效果后，可将文章同步到其他内容平台（知乎、掘金、CSDN 等）的草稿箱。

**前置条件：**
- `npm install -g @wechatsync/cli`
- Chrome 安装 [Wechatsync 扩展](https://chrome.google.com/webstore/detail/hchobocdmclopcbnibdnoafilagadion)
- 在浏览器里登录各平台账号

**首次同步：** 询问用户要同步到哪些平台，写入 `config/wxmp.json` 的 `wechatsync_platforms` 字段
**后续同步：** 读取配置，直接同步
**添加平台：** 用户说"加一个 XXX 平台"，更新配置文件即可

```bash
wechatsync sync output/xxx.html -p zhihu,juejin,csdn
```

文章进入各平台草稿箱，用户自行预览和发布。详细指引见 `references/wxmp-sync.md`

## 增强工具

随时可调用，不绑定特定阶段：

| 工具 | 干什么 | 什么时候用 |
|------|--------|-----------|
| 爆款标题生成器 | 6 种策略各生成 2 个标题（共 12 个），按推荐度排序 | 写完文章取标题时 |
| 摘要生成器 | 3 个版本的 120 字摘要（悬念/价值/故事） | 需要公众号列表摘要时 |
| 文章体检报告 | 5 维度打分 + 优化建议 | 打磨阶段必用，也可随时调用 |
| 话题标签推荐 | 提取 3-5 个关键词标签 | 发布前加标签时 |

> 详细用法见 `references/wxmp-tools.md`

## 配置说明

首次使用需要配置。配置文件 `config/wxmp.json` 支持两个位置（当前目录优先）：

> 详细流程见 `references/wxmp-setup.md`

- **当前项目目录**：`{项目}/config/wxmp.json`
- **Skill 目录**：skill 安装位置下的 `config/wxmp.json`

```bash
cp config/wxmp.example.json config/wxmp.json
# 然后填入真实的 AppID 和 Secret
```

获取方式：微信公众平台 → 我的业务与服务 → 公众号 → 开发密钥

配置文件包含敏感信息，已在 `.gitignore` 中排除。

用户说"帮我配置"或"配置助手"时，先检查 `config/wxmp.json` 中哪些已配置、哪些缺失，只引导用户配置缺失的部分。可选功能（Humanizer、StopSlop、Agnes AI、Wechatsync、Reddit）逐个询问是否需要，用户说不要就跳过。

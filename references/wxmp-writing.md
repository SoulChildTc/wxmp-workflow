# 文章撰写

从选题到成稿，再到公众号可用的 HTML。包含大纲、写稿、打磨、配图、排版五个环节。

## 处理用户已有内容

用户可能带着不同形态的内容进来：

- **只有主题**：正常走大纲 → 正文流程
- **有大纲/思路**：基于用户的大纲展开，不要推翻重来
- **有初稿/素材**：在用户基础上润色、补充、优化结构，不要重写
- **有外部链接/文档**：先读取内容，提炼核心观点，再写成公众号风格

尊重用户的原始意图和风格偏好，你的角色是增强而非替代。

## 文章类型

不同类型的文章有不同的写法，先确认类型再动笔：

| 类型 | 特点 | 适合场景 |
|------|------|---------|
| 教程/干货 | 步骤清晰、可操作、有截图 | 技能教学、工具推荐 |
| 观点/评论 | 立场鲜明、论据充分、有争议性 | 行业分析、热点评论 |
| 故事/案例 | 有情节、有转折、有启发 | 个人经历、用户案例 |
| 盘点/清单 | 结构化、信息密度高、易收藏 | 工具推荐、资源整理 |
| 深度长文 | 逻辑严密、引用丰富、有深度 | 行业研究、技术解析 |

## 生成大纲

根据选定的选题和文章类型，生成结构化大纲：

```
📝 文章大纲

标题：《xxx》（15-30字，有吸引力）
摘要：xxx（120字以内，用于公众号列表展示）
类型：教程/观点/故事/盘点/深度

一、引言（吸引注意力的开头）
二、核心论点1
   - 要点A
   - 要点B
三、核心论点2
   - 要点A
   - 要点B
四、总结与行动号召

预计字数：xxx 字
```

**半自动：** 展示大纲等用户确认
**全自动：** 生成大纲后直接进入写稿

大纲确认后再写正文，避免返工。

## 撰写正文

按确认的大纲撰写 Markdown 全文。写作原则：

- **标题**：15-30字，制造好奇或承诺价值，避免标题党
- **开头**：前3行决定读者是否继续。从 `references/wxmp-typography.md` 的开头策略库中选手法（数据冲击、痛点提问、场景代入等），确保连续几篇文章不重复同一种开头
- **段落**：每段不超过4行（手机屏幕约显示3-4行），段间留白
- **语言**：口语化、有温度，像在和朋友聊天，避免学术腔
- **结构**：善用小标题（h2/h3）、列表、引用块，让读者能扫读
- **结尾**：用 `references/wxmp-typography.md` 的互动引导区样式，引导点赞/在看/评论，措辞可变化
- **字数**：1500-3000字为宜，深度长文可到5000字
- **图片**：直接展示图片，不加"图片来源""图：xxx"等底部说明文字

**排版规范：** 遵循中文文案排版指北（见 `references/chinese-copywriting-guidelines.md`），重点关注：中英文之间加空格（盘古之白）、全角标点、数字半角、专有名词大小写、不重复标点。

**英文处理：** 遇到英文名词或术语时，先判断读者是否需要看到原文，再决定保留、翻译或音译：

| 情况 | 做法 | 示例 |
|------|------|------|
| 读者群广泛使用的英文 | 直接保留，不翻译 | API、iPhone、GitHub、ChatGPT、Docker、npm |
| 有公认中文译名的术语 | 用中文，首次出现括注英文 | 机器学习 (Machine Learning)、开源 (Open Source) |
| 中文更生动或更常用 | 用中文，不括注 | blog→博客、hacker→黑客、startup→创业公司 |
| 英文品牌/产品名 | 保留英文，不翻译不音译 | GitHub、Notion、Figma、Vercel、Stripe |
| 英文概念无公认译法 | 首次括注，后续用中文简称 | Large Language Model (LLM) → 后续用 LLM |
| 英文标语/slogan | 保留英文，后面加中文解释 | "Move fast and break things"——快速行动、打破常规 |

**判断标准：** 读一遍句子，如果英文换成中文会让读者困惑（"API 接口"说成"应用程序编程接口接口"？），就保留英文。如果中文更自然（"深度学习"比"Deep Learning"读起来顺），就用中文。拿不准时优先中文——公众号读者不是程序员群体时，中文容错率更高。

**格式：** 英文词与中文之间加空格（盘古之白），专有名词保持官方大小写（GitHub 不是 Github，iPhone 不是 Iphone）。

**来源标注：** 涉及数据、事件、他人观点时，尽量注明信息来源。不需要学术级引用格式，口语化即可：
- 数据类："根据 XX 报告..."、"XX 的数据显示..."
- 事件类："XX 在昨天的发布会上宣布..."、"据 XX 报道..."
- 观点类："XX 认为..."、"XX 在一次访谈中提到..."

目的是让读者知道这不是 AI 编的。拿不到确切来源时，用模糊表述（"据了解"、"有消息显示"）比编一个假来源好。

**外链限制：** 微信公众号正文不支持可点击的外链（个人订阅号完全不支持，已认证服务号需配白名单）。处理方式：正文用上标编号引用（如 `<sup>[1]</sup>`），文末设「参考资料」区统一列出来源名称和纯文本 URL。截图比链接更好——截官方页面/数据图直接插文中，既是证据又不受外链限制。具体 HTML 模式见 `references/wxmp-typography.md` 组件库的「脚注引用」。

**半自动：** 写完让用户审阅
**全自动：** 写完直接进入打磨

## 打磨

写完初稿后，先去 AI 味，再用体检报告检查质量，最后针对性优化。每一步都是必经步骤，不能跳过。

### 1. 去 AI 味

按以下优先级执行，已安装的工具优先使用：

**Humanizer（已安装时）：** 按 Humanizer skill 的规则执行，检测并消除 30 种 AI 写作模式。如果用户提供了个人文稿样本，启用声音校准匹配个人风格。执行两轮重写：第一轮修 30 种模式，第二轮审计残留。

**StopSlop（已安装时）：** 在 Humanizer 之后执行，按 StopSlop skill 的 8 条写作原则打磨文章质量，用 12 项快速检查做最终把关。

**内置规则（两个都没装时）：** 用去 AI 味检查工具（见 `references/wxmp-tools.md`）的 4 轮扫描规则，逐条消除 AI 写作痕迹。

### 2. 跑体检报告

用文章体检报告工具（见 `references/wxmp-tools.md`）从 5 个维度打分：
- 开头吸引力：前 3 行是否能抓住读者？
- 段落可读性：段落是否够短？是否适合手机阅读？
- 结构清晰度：小标题是否清晰？逻辑是否连贯？
- 金句密度：是否有值得划线/转发的句子？
- 结尾引导力：是否有互动引导？

### 3. 根据报告优化

| 低分项 | 怎么改 |
|--------|--------|
| 开头吸引力 | 重写开头：用问题、数据、故事、反常识切入 |
| 段落可读性 | 拆分长段落，每段不超过 4 行 |
| 结构清晰度 | 加小标题，调整段落顺序 |
| 金句密度 | 每 500 字补一个金句（观点、类比、反问） |
| 结尾引导力 | 加明确的互动引导（点赞、在看、评论、转发） |

### 4. 生成标题和摘要

打磨完成后：
- 用爆款标题生成器生成 12 个标题选项（6 种策略各 2 个）
- 用摘要生成器生成 3 个摘要版本

**半自动：** 展示选项让用户选择
**全自动：** 优先选爆款潜力最高的标题（口语法 > 好奇法 > 痛点法 > 数字法 > 对比法 > 权威法），同时确保标题与内容能对齐

### 5. 标题与内容对齐

选定标题后，回查文章内容是否兑现了标题的承诺。标题可以大胆追求爆款，但内容必须跟上。

检查要点：
- 标题承诺了数字（"5 个方法"）→ 文章里是否真的有 5 个？
- 标题承诺了效果（"月入过万"）→ 文章里是否有支撑案例/数据？
- 标题制造了悬念（"90% 的人不知道"）→ 文章里是否真的揭示了？
- 标题用了对比（"从小白到大神"）→ 文章里是否有转变过程？

**不匹配时的处理：**
- 内容缺了 → 补充内容，让文章兑现标题的承诺
- 标题夸大了 → 微调标题，让标题回归文章实际内容

原则：**先保标题吸引力，再补内容匹配度。**

## 配图

在合适的位置添加图片，增强文章表现力。

### 什么时候该加图

| 位置 | 作用 | 适合的文章类型 |
|------|------|---------------|
| 开头配图 | 吸引注意力，制造氛围 | 所有类型 |
| 证据截图 | 增加可信度，证明不是编的 | 分析/预测、观点/评论、深度长文 |
| 数据图表 | 让数据更直观 | 深度长文、观点/评论 |
| 步骤截图 | 让教程更清晰 | 教程/干货 |
| 案例配图 | 让故事更生动 | 故事/案例 |
| 结尾引导图 | 引导关注/转发 | 所有类型 |

**证据截图优先于装饰图。** 涉及事实性内容（发布会信息、官方公告、数据报告、产品截图）时，优先用截图作为证据，而不是配一张无关的插画。截图来源：官网页面、官方社交媒体、数据报告图表、产品界面等。

### 图片来源

1. **用户自己提供** — 最常见，用户发图片文件过来
2. **从素材中提取** — 调研阶段搜集的文章中的图片（注意版权）
3. **AI 生成** — 用 Agnes AI 或 SenseNova 生成，prompt 中加上"不包含真人"的约束。优先 Agnes，Agnes 失败时切换 SenseNova
4. **用占位符标注** — 暂时没有合适的图，先用文字标注位置

### 图片内容限制

**所有配图都不能出现真人**（包括 AI 生成的、从网上找的、封面图）。动画、插画、卡通人物不受限。

- AI 生成图片时，prompt 末尾加 `no real people, no human faces, illustration style`
- 从网上找图时，排除含真人照片的素材
- 封面图同样适用此规则

### 图片上传

图片必须先上传到微信素材库才能在文章中使用：

```bash
bash scripts/wx-upload-image.sh /path/to/image.jpg
```

上传后脚本返回微信 CDN 地址。**把这个地址记下来**，后续排版时直接用，不要再去本地找文件或重新生成图片。

**重要：** 图片只需生成和上传一次。上传成功后，本地文件不再需要，文章中统一用 CDN 地址：

```html
<img src="https://mmbiz.qpic.cn/xxx" style="width: 100%; border-radius: 8px; margin: 15px 0;" />
```

如果暂时无法上传（没配置 API），先用占位符标注图片位置，提醒用户后续手动添加：

```html
<!-- TODO: 在此处添加图片 - {图片描述} -->
```

### 图片规格

- 封面图：900×383（2.35:1 比例），最大 10MB
- 正文配图：宽度 100%，建议不超过 10MB
- 格式：JPG、PNG

## 多轮修改

根据用户反馈迭代修改。常见场景：

- "语气太正式了" → 调整为更口语化的表达
- "加个案例" → 补充具体案例或数据支撑
- "开头不够吸引人" → 重写开头，制造更强的好奇心
- "太长了" → 精简冗余段落，保留核心观点
- "标题不行" → 提供 3-5 个备选标题让用户选

修改时保留用户认可的部分，只改需要改的地方。

## 转换为公众号 HTML

用户确认文章后，按以下步骤转为公众号可用的 HTML。

**图片处理：** 排版时直接使用配图阶段上传后获得的 CDN 地址，不要再去本地找文件或重新生成图片。如果图片还没上传，先上传再排版。

### 1. 选择并读取模板

根据文章类型选择模板（见 `templates/README.md` 的选择策略），然后读取对应文件。模板中有 1 个通用占位符：
- `{{CONTENT}}` — 正文 HTML

> `card-style.html` 额外有 `{{WORD_COUNT}}` 占位符，替换为文章字数（如 `2350`）。标题不需要在模板中渲染——微信会自动显示。

### 2. 将 Markdown 转为内联样式 HTML

公众号不支持外部 CSS，所有样式必须写在 `style` 属性里。转换时遵循 `references/wxmp-typography.md` 的排版规范（字号、间距、配色、视觉节奏、组件库）。

> 详细规范见 `references/wxmp-typography.md`。以下为常用标签速查。

```html
<!-- 大标题（h2 章节标题） -->
<section style="font-size: 1.2em; font-weight: bold; color: #3f3f3f; margin: 1.5em 0 0.75em; padding-bottom: 0.5em; border-bottom: 2px solid #fa5151;">
  章节标题
</section>

<!-- 小标题（h3 子标题） -->
<section style="font-size: 1.1em; font-weight: bold; color: #3f3f3f; margin: 1.25em 0 0.5em;">
  子标题
</section>

<!-- 段落（用 section 包裹，确保 margin/line-height 生效） -->
<section style="font-size: 15px; color: #3f3f3f; line-height: 1.75; margin: 0 0 1.25em; text-align: justify;">
  正文内容...
</section>

<!-- 引用 -->
<section style="margin: 1.25em 0; padding: 0.75em 1em; background: #f7f7f7; border-left: 4px solid #fa5151; font-size: 15px; color: #666;">
  引用内容...
</section>

<!-- 列表（用 section 包裹） -->
<section style="font-size:15px; margin:0 0 0.75em; padding-left:1.5em;">
  <span style="color:#fa5151; font-weight:bold;">•</span>
  <strong style="color:#3f3f3f;">关键词</strong> — 具体说明内容
</section>
<section style="font-size:15px; margin:0 0 0.75em; padding-left:1.5em;">
  <span style="color:#fa5151; font-weight:bold;">•</span>
  <strong style="color:#3f3f3f;">关键词</strong> — 具体说明内容
</section>

<!-- 卡片式列表（重点功能清单、组件介绍） -->
<section style="margin:0 0 0.75em; padding:0.75em 1em; border-left:3px solid #fa5151; background:#f7f7f7; border-radius:6px;">
  <section style="font-size:15px; color:#3f3f3f;">
  <strong style="color:#fa5151;">关键词</strong> — 具体说明内容
  </section>
</section>

<!-- 加粗 -->
<strong style="color: #fa5151;">重点内容</strong>

<!-- 图片（必须是微信 CDN 地址） -->
<img src="微信CDN地址" style="width: 100%; border-radius: 8px;" />

<!-- Mac 代码块 -->
<section style="margin: 1.25em 0; border-radius: 8px; overflow: hidden; background: #1e1e1e;">
  <section style="padding: 12px 16px; background: #2d2d2d;">
  <span style="display: inline-block; width: 12px; height: 12px; border-radius: 50%; background: #ff5f56; margin-right: 8px;"></span>
  <span style="display: inline-block; width: 12px; height: 12px; border-radius: 50%; background: #ffbd2e; margin-right: 8px;"></span>
  <span style="display: inline-block; width: 12px; height: 12px; border-radius: 50%; background: #27c93f;"></span>
  </section>
  <pre style="margin: 0; padding: 16px; overflow-x: auto; font-size: 14px; line-height: 1.6; color: #e0e0e0; font-family: 'SF Mono', 'Fira Code', 'Consolas', monospace;"><code>代码内容</code></pre>
</section>

<!-- 脚注引用（正文内） -->
根据研究<sup style="font-size: 12px; color: #fa5151; padding: 0 2px;">[1]</sup>显示……

<!-- 脚注引用（底部引用区，放在互动引导之前） -->
<hr style="border: none; border-top: 1px solid #eee; margin: 1.5em 0 1.25em;" />
<section style="margin: 0 0 1.25em; font-size: 14px; color: #999;">
  <section style="font-weight: bold; color: #666; margin: 0 0 0.5em;">参考资料</section>
  <section style="margin: 0 0 0.3em;">[1] 来源名称 — 纯文本 URL</section>
</section>
```

**列表标签限制：** 不要使用 `<ul>/<ol>/<li>`，公众号编辑器会特殊处理这些标签，可能导致空 bullet、样式剥离等兼容性问题。用上述模拟列表组件代替。

**视觉节奏：** 连续纯文字段落不超过 3 段，第 4 段之前必须插入一个视觉断点（引用块、金句高亮、卡片、图片、分割线）。详见 `references/wxmp-typography.md`。

### 3. 替换模板占位符

用 Read 读取模板文件全文，然后用 Write 写入最终 HTML 文件，替换占位符：
- `{{CONTENT}}` → 步骤 2 转换后的正文 HTML（整体替换，保留模板的 `<section>` 外壳）
- `{{WORD_COUNT}}` → 仅 `card-style.html` 需要，替换为文章正文字数（如 `2350`）

标题不需要渲染——微信会自动从草稿 metadata 中显示标题。

**不要用 Edit 逐步替换**——模板文件不应被修改，直接 Write 输出文件即可。

### 4. 保存文件

保存到 `output/{YYYY-MM-DD}-{标题关键词}.html`，例如 `output/2026-06-05-ai-writing-guide.html`。

### 5. 创建草稿前验证

保存 HTML 后，用 grep 检查是否包含列表标签：

```bash
grep -c '<ul\|<li\|<ol' output/xxx.html
```

如果命中（返回值 > 0），**必须替换为模拟列表组件**后再创建草稿。不要直接用 `<ul>/<li>` 提交草稿。

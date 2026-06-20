# 排版设计规范

## Contents

- 设计原则（手机优先、呼吸感、视觉节奏、一致性、黑白之道）
- 字体
- 微信编辑器兼容性（可靠属性、不可靠属性、section 替代 p、HTML 缩进规范）
- 字号体系
- 间距体系
- 配色方案
- 标点符号
- 视觉节奏（打断规则、段落长度节奏、分割线、金句高亮）
- 开头策略（10 种手法库、选择原则）
- 中西文混排
- 组件库（信息提示框、步骤卡、对比卡、重点卡片、标题样式、Mac 代码块、脚注引用、互动引导区）
- 深色模式兼容
- 完整示例：文章结构
- 检查清单

公众号文章的手机端排版规范。AI 将 Markdown 转 HTML 时必须遵循这些规则，确保每篇文章在手机上阅读体验一致、舒适。

## 设计原则

1. **手机优先** — 所有样式以 375px 宽度为基准，手指滑动阅读
2. **呼吸感** — 密集文字之间必须有留白，让眼睛休息
3. **视觉节奏** — 连续纯文字不超过 3 段，中间插结构化元素打断
4. **一致性** — 同一篇文章的字号、间距、配色保持统一
5. **黑白之道** — 排版是「黑与白」的艺术：文字是黑，留白是白，黑白得当才有和谐美感

## 字体

```css
font-family: -apple-system-font, BlinkMacSystemFont, Helvetica Neue, PingFang SC, Hiragino Sans GB, Microsoft YaHei UI, Microsoft YaHei, Arial, sans-serif;
```

此字体栈覆盖 iOS（PingFang SC）、macOS（Helvetica Neue）、Android（Hiragino Sans GB / Microsoft YaHei）三大平台。

## 微信编辑器兼容性（重要）

微信编辑器会过滤或覆盖部分 CSS 属性。以下规则决定了哪些样式能生效、哪些不能用。

### ✅ 可靠生效的属性

| 属性 | 适用标签 | 说明 |
|------|---------|------|
| `font-size` | 所有标签 | 最小约 14px，低于此值会被强制放大 |
| `font-weight` | 所有标签 | `bold`/`normal` 可靠 |
| `color` | 所有标签 | 可靠 |
| `background` | `section`/`div` | 可靠，`<p>` 上可能被过滤 |
| `border` | `section`/`div` | 可靠 |
| `text-align` | 所有标签 | 可靠 |
| `padding` | `section`/`div` | 可靠，`<p>` 上可能被过滤 |
| `border-radius` | `section`/`div` | 可靠 |
| `display: flex` | `section`/`div` | 部分支持 |
| `width`/`max-width` | `section`/`div`/`img` | 可靠 |

### ⚠️ 不可靠或会被覆盖的属性

| 属性 | 问题 | 替代方案 |
|------|------|---------|
| `letter-spacing` | `<p>` 上可能被过滤；`<section>`/`<span>` 上通常生效 | 避免在 `<p>` 上使用；若需要，在 `<section>` 或 `<span>` 上设置 |
| `line-height` | `<p>` 上几乎一定被覆盖 | 用 `<section>` 包裹，在 `<section>` 上设置 |
| `margin` | `<p>` 的 margin 几乎一定被覆盖 | 用 `<section>` 包裹，在 `<section>` 上设置 |
| `padding` | `<p>` 上可能被过滤 | 用 `<section>` 包裹 |
| `text-indent` | `<p>` 上可能被覆盖；`<section>` 上大概率生效 | 优先用段间留白代替首行缩进；若必须用，在 `<section>` 上设置 |
| `text-size-adjust` | 微信 WebView 内不一定生效 | 保留但不依赖它 |
| `font-style: italic` | 中文字体无真正 italic 变体，会渲染为伪斜体（倾斜但不好看） | 不建议用斜体中文，效果差 |

### 核心结论

**所有内容块必须用 `<section>` 而非 `<p>` 包裹**，这样 margin、line-height、padding、background、border 才能可靠生效。只有纯文本行才用 `<p>`（只设 font-size + color，不依赖 margin/line-height）。

### HTML 缩进规范

全文只用一级缩进（2 空格），禁止二级及以上缩进（4 空格、6 空格等）。

- 所有标签统一缩进 2 空格，无论嵌套层级
- 不要出现 4 空格或更深的缩进
- 文本内容与标签同级缩进

```html
<!-- ✅ 正确：所有标签统一 2 空格 -->
<section style="margin: 0 0 1.25em; font-size: 15px; color: #3f3f3f;">
  正文段落内容。
</section>

<section style="margin: 1.25em 0; padding: 0.75em 1em; border-left: 3px solid #fa5151; background: #f7f7f7;">
  <section style="font-size: 14px; color: #666;">
  💡 提示内容。
  </section>
</section>

<!-- ❌ 错误：出现 4 空格、6 空格缩进 -->
<section style="...">
    <section style="...">
        <span>内容</span>
    </section>
</section>
```

## 字号体系

基准字号 **15px**，标题用相对倍率（em）。注释不得低于 14px（微信最小值限制）。

| 元素 | 标签 | 字号 | 颜色 | 说明 |
|------|------|------|------|------|
| 大标题（h2 章节标题） | `<section>` | 1.2em（≈18px） | #3f3f3f | 粗体+底线区分 |
| 小标题（h3 子标题） | `<section>` | 1.1em（≈16.5px） | #3f3f3f | 粗体 |
| 正文 | `<section>` | 15px | #3f3f3f | 手机端阅读基准，两端对齐 |
| 引用块 | `<section>` | 15px | #666 | 灰色，左边框装饰 |
| 注释/来源 | `<section>` | 14px | #999 | 不低于 14px |
| 金句高亮 | `<section>` | 17px | #3f3f3f | 短句居中，长句左对齐 |

**行高控制：** 在 `<section>` 容器上设置 `line-height`（如 1.75），不要在 `<p>` 上设——会被覆盖。

## 间距体系

间距统一用 `<section>` 容器的 margin 控制，不用 `<p>` 的 margin。

| 位置 | 方式 | 说明 |
|------|------|------|
| 段落之间 | `<section style="margin: 0 0 1.25em">` | 每个段落是一个 section |
| 章节标题与正文 | 标题 `<section>` 的 margin-bottom | 标题下方留白 |
| 引用块上下 | `<section style="margin: 1.25em 0">` | 独立 section |
| 图片上下 | `<section style="margin: 1em 0">` | 图片包裹在 section 中 |
| 组件上下 | `<section style="margin: 1.25em 0">` | 卡片/信息框 |

**首行不缩进**，用段间留白代替。

## 配色方案

正文颜色不超过 3 种（不含图片）。

| 用途 | 色值 | 说明 |
|------|------|------|
| 正文 | `#3f3f3f` | 主要文字，比纯黑柔和 |
| 次要文字 | `#666` | 引用、补充说明 |
| 注释 | `#999` | 来源、时间、作者信息 |
| 强调/重点 | `#fa5151` | 加粗、标记、小圆点 |
| 标题底线 | `#fa5151` | h2 下方的 2px 红线 |
| 背景色 | `#f7f7f7` | 引用块、卡片背景 |
| 分割线 | `#eee` | 章节分隔 |

**强调方式优先级：** 加粗 > 改变颜色 > 改变字号。不要用下划线（过时）、不要用斜体（中文斜体在微信中可能不生效）。

## 标点符号

- 中文标点全部使用**全角符号**
- 引号推荐**直角引号「」**，比弯引号更优雅，也避免全角半角混用
- 省略号用「……」（shift+6），不要用六个句号或三个点
- 破折号用「——」（shift+-），不要用连字符

## 视觉节奏

### 打断规则

连续纯文字段落不超过 3 段。第 4 段之前必须插入一个视觉元素：

- 引用块（`<section>` 带左边框）
- 金句高亮（居中大字）
- 卡片式组件（`<section>` 带左边框 + 背景色）
- 图片
- 分割线（`<hr>`）

### 段落长度节奏

长、中、短段落结合——像音乐的节奏变化：

- **长段落**（4-5 行）：阐述核心观点
- **中段落**（2-3 行）：展开论述
- **短段落**（1 行）：强调、转折、过渡

段落最长不超过一屏。

### 分割线

```html
<hr style="border: none; border-top: 1px solid #eee; margin: 1.5em 0;" />
```

### 金句高亮

值得划线/转发的句子，用大号样式突出。

**短金句（≤20 字，一行以内）— 居中：**

```html
<section style="margin: 1.5em 0; padding: 1em; text-align: center;">
  <span style="font-size: 17px; color: #3f3f3f;">金句内容，控制在一行以内。</span>
</section>
```

**长金句（>20 字，需要换行）— 左对齐：**

```html
<section style="margin: 1.5em 0; padding: 1em 1.25em; text-align: left;">
  <span style="font-size: 17px; color: #3f3f3f;">较长的金句内容，超过一行时左对齐更舒适。<br/>手动换行比自动换行更可控。</span>
</section>
```

规则：
- 尽量控制在一行以内（≤20 字）
- 超过一行时用左对齐，不要居中（居中多行很难看）
- 需要断行时用 `<br/>` 手动换行，不要靠自动换行
- 一篇文章 1500 字至少有 2-3 个金句高亮

## 开头策略

文章开头决定读者是否继续。不要每次都用同一种开头，根据内容选择不同手法。

### 策略库

| 手法 | 说明 | 适合 |
|------|------|------|
| 数据冲击 | 用一个反直觉的数据开头 | 深度长文、观点/评论 |
| 痛点提问 | 问一个读者正在经历的问题 | 教程/干货、观点/评论 |
| 场景代入 | 描述一个具体的生活场景 | 故事/案例、盘点/清单 |
| 反常识 | 挑战一个普遍认知 | 观点/评论、深度长文 |
| 直接下判断 | 开门见山亮出观点 | 观点/评论、深度长文 |
| 故事悬念 | 讲一个小故事，留个悬念 | 故事/案例、观点/评论 |
| 热点切入 | 从当天热点事件引入 | 观点/评论、盘点/清单 |
| 自嘲/幽默 | 用自嘲拉近距离 | 故事/案例、教程/干货 |
| 对比冲击 | 前后/新旧/理想与现实的反差 | 故事/案例、深度长文 |
| 引用金句 | 用一句有力量的话开头 | 观点/评论、深度长文 |

**选择原则：** 同一作者连续几篇文章不要用同一种开头。AI 根据文章内容和风格选最合适的，措辞每次都不同——这些是手法，不是填空模板。

## 中西文混排

- 中文与英文之间加空格：「我用 Typora 写作」
- 中文与数字之间加空格：「现在已经到了 2 月份」
- 中文夹杂英文时使用全角标点：「这是我新买的 iPhone，你拿去吧」
- 完整英语句子用半角标点：「Each man is the architect of his own fate.」

## 组件库

所有组件用 `<section>` 构建，确保 margin/padding/background/border 可靠生效。

### 信息提示框

```html
<section style="margin: 1.25em 0; padding: 0.75em 1em; border-left: 3px solid #fa5151; background: #f7f7f7; border-radius: 0 6px 6px 0;">
  <section style="font-size: 14px; color: #666;">
  💡 提示内容写在这里。
  </section>
</section>
```

### 步骤卡

```html
<section style="margin: 0 0 0.75em; padding-left: 1.5em;">
  <span style="display: inline-block; width: 22px; height: 22px; line-height: 22px; text-align: center; background: #fa5151; color: #fff; border-radius: 50%; font-size: 14px; font-weight: bold; margin-right: 8px;">1</span>
  <strong>第一步标题</strong> — 具体操作说明
</section>
```

### 对比卡

```html
<section style="margin: 1.25em 0; padding: 0.75em 1em; border-left: 3px solid #07c160; background: #f0faf4; border-radius: 0 6px 6px 0;">
  <section style="font-size: 15px; color: #3f3f3f;">
  <strong style="color: #07c160;">✅ 正确：</strong>具体示例
  </section>
</section>
<section style="margin: 0.3em 0 1.25em; padding: 0.75em 1em; border-left: 3px solid #fa5151; background: #fef0f0; border-radius: 0 6px 6px 0;">
  <section style="font-size: 15px; color: #3f3f3f;">
  <strong style="color: #fa5151;">❌ 错误：</strong>具体示例
  </section>
</section>
```

### 重点卡片

```html
<section style="margin: 1.25em 0; padding: 0.9em 1em; border-left: 3px solid #fa5151; background: #f7f7f7; border-radius: 0 6px 6px 0;">
  <section style="font-size: 15px; color: #3f3f3f;">
  <strong style="color: #fa5151;">关键点</strong> — 核心内容描述
  </section>
</section>
```

### 标题样式

**大标题（h2 章节标题）— 粗体 + 红底线：**

```html
<section style="font-size: 1.2em; font-weight: bold; color: #3f3f3f; margin: 1.5em 0 0.75em; padding-bottom: 0.5em; border-bottom: 2px solid #fa5151;">
  章节标题
</section>
```

**小标题（h3 子标题）— 纯粗体，无底线：**

```html
<section style="font-size: 1.1em; font-weight: bold; color: #3f3f3f; margin: 1.25em 0 0.5em;">
  子标题
</section>
```

### Mac 代码块

macOS 终端风格代码块，适合展示代码、命令、配置。

```html
<section style="margin: 1.25em 0; border-radius: 8px; overflow: hidden; background: #1e1e1e;">
  <section style="padding: 12px 16px; background: #2d2d2d;">
  <span style="display: inline-block; width: 12px; height: 12px; border-radius: 50%; background: #ff5f56; margin-right: 8px;"></span>
  <span style="display: inline-block; width: 12px; height: 12px; border-radius: 50%; background: #ffbd2e; margin-right: 8px;"></span>
  <span style="display: inline-block; width: 12px; height: 12px; border-radius: 50%; background: #27c93f;"></span>
  </section>
  <pre style="margin: 0; padding: 16px; overflow-x: auto; font-size: 14px; line-height: 1.6; color: #e0e0e0; font-family: 'SF Mono', 'Fira Code', 'Consolas', monospace;"><code>代码内容写在这里</code></pre>
</section>
```

规则：
- 深色背景在微信亮色/暗色模式下表现一致，无需特殊适配
- 代码区用 `<pre>` 保留换行和空格，用 `<code>` 标记代码语义
- `overflow-x: auto` 确保长代码行可横向滚动
- 字号 14px（等宽字体在 14px 下可读性最佳）

### 脚注引用

微信不支持正文内可点击的外链，用上标编号 + 底部引用区替代。

**正文内引用（上标编号）：**

```html
根据最新研究<sup style="font-size: 12px; color: #fa5151; padding: 0 2px;">[1]</sup>显示……
```

**底部引用区（文末、互动引导之前）：**

```html
<hr style="border: none; border-top: 1px solid #eee; margin: 1.5em 0 1.25em;" />
<section style="margin: 0 0 1.25em; font-size: 14px; color: #999;">
  <section style="font-weight: bold; color: #666; margin: 0 0 0.5em;">参考资料</section>
  <section style="margin: 0 0 0.3em;">[1] 来源名称 — 纯文本 URL</section>
  <section style="margin: 0 0 0.3em;">[2] 来源名称 — 纯文本 URL</section>
</section>
```

规则：
- 正文内只放上标编号 `<sup>[N]</sup>`，不放 URL
- 底部引用区放在互动引导区之前
- 每条引用写来源名称 + 纯文本 URL（不可点击，但读者可手动复制）
- 如果引用少于 3 条且来源都是知名机构/网站，可以只写名称不写 URL

### 互动引导区

```html
<hr style="border: none; border-top: 1px solid #eee; margin: 1.5em 0 1.25em;" />
<section style="text-align: center; margin: 0 0 0.5em;">
  <span style="font-size: 14px; color: #999;">👆 觉得有用？点个<strong style="color: #fa5151;">「在看」</strong>让更多人看到</span>
</section>
<section style="text-align: center;">
  <span style="font-size: 14px; color: #999;">💬 你怎么看？评论区聊聊</span>
</section>
```

## 深色模式兼容

微信有深色模式，排版必须兼容。核心原则：

| 规则 | 说明 |
|------|------|
| 不设背景色 | 外层 `<section>` 不设 background，让微信自动适配 |
| 不用纯白文字 | 深色模式下纯白 (#fff) 太刺眼 |
| 文字用中性色 | `#3f3f3f`/`#666`/`#999` 在深色模式下微信会自动反转 |
| 背景色用浅灰 | `#f7f7f7` 比纯白在深色模式下表现更好 |
| 强调色不要大面积 | `#fa5151` 只用于小元素（加粗、边框、圆点） |

## 完整示例：一篇文章的结构

```
┌─────────────────────────┐
│  （标题由微信自动显示，不渲染） │
├─────────────────────────┤
│                              │
│  开头段落（选一种开头策略）      │
│  <section> 包裹               │
│                              │
│  正文段落 1（section, 15px）    │
│                              │
│  正文段落 2                    │
│                              │
│  正文段落 3                    │
│                              │
│  ─── 视觉断点 ───             │
│  引用块 / 金句 / 卡片          │
│                              │
│  正文段落 4                    │
│                              │
│  ────────────────             │
│  章节标题（1.2em, 粗体+底线）   │
│                              │
│  ...更多内容...                │
│                              │
│  ────────────────             │
│  参考资料区（脚注, 14px #999）  │
│                              │
│  ────────────────             │
│  互动引导区（居中, #999）       │
│                              │
└─────────────────────────┘
```

## 检查清单

排版完成后，逐项检查：

- [ ] 所有内容块用 `<section>` 包裹（不用 `<p>` 做容器）
- [ ] `<p>` 标签只用于纯文本行，不依赖其 margin/line-height
- [ ] HTML 缩进：全文统一 2 空格，无 4 空格或更深缩进
- [ ] 正文 15px，行高在 `<section>` 容器上设置
- [ ] `letter-spacing` 仅在 `<section>`/`<span>` 上使用，不在 `<p>` 上使用
- [ ] `text-indent` 仅在 `<section>` 上使用（或优先用段间留白代替）
- [ ] 注释字号 ≥ 14px（微信最小值限制）
- [ ] 连续纯文字 ≤3 段，中间有视觉断点
- [ ] 章节标题用粗体+底线装饰
- [ ] 段落首行不缩进，段间用 section margin 控制
- [ ] 正文段落两端对齐（text-align: justify）
- [ ] 章节标题用 h2 样式（粗体+底线），子标题用 h3 样式（纯粗体）
- [ ] 代码块用 Mac 终端风格组件（深色背景+彩色圆点）
- [ ] 外链用上标脚注引用，文末有「参考资料」区
- [ ] 结尾有互动引导区
- [ ] 图片宽度 100%，有圆角
- [ ] 无 `<ul>`/`<ol>`/`<li>` 标签
- [ ] 强调色统一用 `#fa5151`
- [ ] 正文颜色不超过 3 种（不含图片）
- [ ] 无斜体中文（伪斜体效果差）、无下划线（超链接除外）
- [ ] 深色模式兼容（无大面积背景色）

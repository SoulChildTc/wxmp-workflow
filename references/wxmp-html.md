# 转换为公众号 HTML

## Contents

- 选择并读取模板
- Markdown 转内联样式 HTML（标签速查 + 列表/视觉节奏限制）
- 替换模板占位符
- 保存文件
- 创建草稿前验证

用户确认文章后，按以下步骤转为公众号可用的 HTML。

**图片处理：** 排版时直接使用配图阶段上传后获得的 CDN 地址，不要再去本地找文件或重新生成图片。如果图片还没上传，先上传再排版。

## 1. 选择并读取模板

根据文章类型选择模板（见 `templates/README.md` 的选择策略），然后读取对应文件。模板中有 1 个通用占位符：
- `{{CONTENT}}` — 正文 HTML

> `card-style.html` 额外有 `{{WORD_COUNT}}` 占位符，替换为文章字数（如 `2350`）。标题不需要在模板中渲染——微信会自动显示。

## 2. 将 Markdown 转为内联样式 HTML

公众号不支持外部 CSS，所有样式必须写在 `style` 属性里。转换时遵循排版设计规范的排版规范（字号、间距、配色、视觉节奏、组件库）。

> 详细规范见排版设计参考文档。以下为常用标签速查。

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

**视觉节奏：** 连续纯文字段落不超过 3 段，第 4 段之前必须插入一个视觉断点（引用块、金句高亮、卡片、图片、分割线）。详见排版设计规范。

## 3. 替换模板占位符

用 Read 读取模板文件全文，然后用 Write 写入最终 HTML 文件，替换占位符：
- `{{CONTENT}}` → 步骤 2 转换后的正文 HTML（整体替换，保留模板的 `<section>` 外壳）
- `{{WORD_COUNT}}` → 仅 `card-style.html` 需要，替换为文章正文字数（如 `2350`）

标题不需要渲染——微信会自动从草稿 metadata 中显示标题。作者和日期也自动显示。

**不要用 Edit 逐步替换**——模板文件不应被修改，直接 Write 输出文件即可。

## 4. 保存文件

保存到 `output/{YYYY-MM-DD}-{标题关键词}.html`，例如 `output/2026-06-05-ai-writing-guide.html`。

## 5. 创建草稿前验证

保存 HTML 后，用 grep 检查是否包含列表标签：

```bash
grep -c '<ul\|<li\|<ol' output/xxx.html
```

如果命中（返回值 > 0），**必须替换为模拟列表组件**后再创建草稿。不要直接用 `<ul>/<li>` 提交草稿。

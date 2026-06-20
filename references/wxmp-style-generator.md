# 文章专属插图风格生成

## Contents

- 原理：风格就是一段文字
- 风格生成流程
- 风格维度参考
- 模型安全风格指南
- 封面图专有建议
- 如何注入图片生成 prompt
- 全文统一风格

## 原理：风格就是一段文字

无论用 Agnes AI 还是 SenseNova，图片生成的核心是一个文本 prompt。所谓"风格"在 prompt 层面只是一段描述文字——不是硬编码的逻辑。

每次生成配图前让 AI 为这篇文章**现场编一套视觉风格**，注入到图片 prompt 里。

## 风格生成流程

```
确定配图位置 → [新] 生成文章专属风格 → 构造 prompt → 生成图片 → 上传
```

AI 读完全文后做两件事：

**1. 分析文章气质**

| 维度 | 分析什么 |
|------|---------|
| 内容类型 | 教程干货 / 观点评论 / 故事案例 / 盘点清单 / 深度长文 |
| 情感基调 | 严肃 / 轻松 / 热血 / 温和 / 吐槽 / 悬念 |
| 目标读者 | 程序员 / 产品经理 / 普通用户 / 行业从业者 |
| 核心隐喻 | 文章本身用了什么比喻？（如"信息工厂""知识树"） |

**2. 基于分析创造一套风格。** 不是列表里选，组合维度创造新的，每篇不同。

## 风格维度参考

| 维度 | 创作方向 | 示例 |
|------|---------|------|
| 技法 | 优先选模型擅长的（见安全风格指南）。抽象技法翻车率高 | flat illustration、几何色块、minimalist line art、清新插画 |
| 配色 | 整体色调 + 强调色（1-2种），用文字不用色号 | 暖橙加深棕、冷蓝配银灰、黑白加红 |
| 角色 | 可有可无。如有：外形、大小、在画面中的角色 | 小方块人、一只猫、几何角色 |
| 背景 | 纯白、浅色渐变、单色背景 | 教程类纯白，故事类可加渐变 |
| 构图 | 描述要具体、模型好理解 | "左侧一人坐桌前，右侧漂浮三个图标"比"不规则的节奏感构图"安全 |
| 氛围 | 一句话概括感觉 | "像科技产品草图""像清新杂志内页插画" |

### 关键原则

- **绝对不要放任何文字在图中。** 这是 #1 翻车原因。所有生成模型画文字都出乱码。用颜色对比/构图焦点代替。
- **绝对不要用 Hex Code。** "暖橙"不是 "#E67E22"，色号引导模型出的是色板不是插画。
- **构图描述要具体。** "不规则几何裁切"模型理解不了。换成"干净几何图形拼接、flat design"——模型在 flat design 上训练数据多。
- **画场景不画图表。** 不要流程图、架构图、思维导图、信息图。
- **prompt 末尾加约束：** `no real people, no human faces, no text, no labels, no chart, no diagram`

## 模型安全风格指南

国内模型（SenseNova/Agnes）的安全区和风险区：

### 安全区（翻车概率低）

| 风格 | prompt 关键词 | 说明 |
|------|-------------|------|
| Flat illustration | flat illustration, clean vector shapes, solid colors | 训练数据最多，最稳 |
| Minimalist line art | minimalist line art, thin clean lines, simple shapes | 线条简单，模型好理解 |
| 清新插画 | 清新插画、柔和色彩、干净构图 | 国内模型理解好 |
| 商务信息图 | 商务风格、简洁图表、干净排版 | 适合数据/流程配图 |
| 几何抽象 | geometric abstract, simple shapes, color blocks | 不画具体物体，容错高 |
| 渐变+几何图形 | gradient background, one large geometric shape | 封面图专用，100% 安全 |

### 高风险区（翻车概率高）

| 风格 | 翻车原因 |
|------|---------|
| 水彩 / watercolor | 模型容易画糊，晕染不可控 |
| 拼贴 / collage | "不规则裁切"模型理解不了 |
| 手绘线稿 | 线条抖动不自然像坏矢量图 |
| 水墨 / ink wash | 国内模型不如 SD 擅长 |
| 油画棒 / oil pastel | 纹理质感模型处理不好 |
| 3D 渲染 / C4D | 灯光材质容易崩 |

**安全策略：** 不确定就 flat illustration + minimal composition，宁可保守不出错。

## 封面图专有建议

封面图公式 **100% 不出错**：

```
[渐变/纯色背景] + [一个大号几何图形/极简主体] + 无文字
```

文字通过公众号编辑器加。示例 prompt：

```
Soft gradient background from light blue to white. One large simple geometric circle in warm orange in the center. Minimalist, clean. no text, no labels, no real people, no human faces
```

## 如何注入图片生成 prompt

完整 prompt 结构：

```
[风格描述] + [这张图画的是什么场景] + no real people, no human faces, no text, no labels, no chart, no diagram
```

示例：

```
风格描述：
Flat illustration style on clean white background. Soft warm orange and cream color palette. Minimal geometric shapes. A small square character with simple face sits at a desk. Clean vector look, modern and fresh.

图片内容：
The square character sits at a desk with a laptop. Three simplified icon-like shapes float above the screen: a lightbulb, a gear, and a star. The character reaches up toward them.

完整 prompt：
Flat illustration style on clean white background. Soft warm orange and cream color palette. Minimal geometric shapes. A small square character with simple face sits at a desk. Clean vector look, modern and fresh. The square character sits at a desk with a laptop. Three simplified icon-like shapes float above the screen: a lightbulb, a gear, and a star. The character reaches up toward them. no real people, no human faces, no text, no labels, no chart, no diagram
```

## 全文统一风格

一篇文章所有概念型配图用同一套风格。**封面图不受此限制**，封面图永远用安全公式。

**半自动：** 生成风格后展示给用户确认
**全自动：** 直接生成

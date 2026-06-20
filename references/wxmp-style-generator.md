# 文章专属插图风格生成

## Contents

- 原理：风格就是一段文字
- 风格生成流程
- 风格维度参考
- 如何注入图片生成 prompt
- 全文统一风格

## 原理：风格就是一段文字

无论用 Agnes AI 还是 SenseNova，图片生成的核心是一个文本 prompt。所谓"风格"在 prompt 层面只是一段描述文字——不是硬编码的逻辑。

所以每次生成配图前，先让 AI 为这篇文章**现场编一套视觉风格**，然后注入到图片 prompt 里。下一篇换一篇文章，风格完全不同。

## 风格生成流程

配图时先执行这一步，再进入原有的图片生成流程：

```
确定配图位置 → [新] 生成文章专属风格 → 构造 prompt → 生成图片 → 上传
```

AI 读完全文后，做两件事：

**1. 分析文章气质**

| 维度 | 分析什么 |
|------|---------|
| 内容类型 | 教程干货 / 观点评论 / 故事案例 / 盘点清单 / 深度长文 |
| 情感基调 | 严肃 / 轻松 / 热血 / 温和 / 吐槽 / 悬念 |
| 目标读者 | 程序员 / 产品经理 / 普通用户 / 行业从业者 |
| 核心隐喻 | 文章本身用了什么比喻？（如"信息工厂""知识树""数据河流"） |

**2. 基于分析创造一套风格**

不是从列表里选，而是组合各种维度创造一套新的。每篇文章都要不同。

## 风格维度参考

AI 参考以下维度创造风格，但**不要当填空模板用**——理解每个维度的作用后，用自然语言写一段连贯的风格描述。

| 维度 | 创作方向 | 示例 |
|------|---------|------|
| 技法 | 手绘线稿、水墨淡彩、几何色块、水彩晕染、版画黑白、铅笔素描、蜡笔质感、拼贴风格 | 不要写死，每篇换一种 |
| 配色 | 整体色调 + 强调色（1-3 种），基于文章情感基调选 | 暖橙+深棕、冷蓝+银灰、黑白+红 |
| 角色 | 可以有也可以没有。如果有：外形、大小、在画面中扮演什么角色 | 小方块人、一只猫、影子形象 |
| 背景 | 纯白、浅色纹理、渐变、抽象图形 | 教程类纯白保持干净，故事类可加氛围 |
| 线条 | 粗细、干净或抖动、有机或几何 | 粗犷碳笔、细钢笔、干净矢量线 |
| 标注 | 中文标注的方式：手写体、标签贴、箭头指示 | 红色手写、黑体标签、气泡说明 |
| 氛围 | 一句话概括这张图给人的感觉 | "像工程师在餐巾纸上画的草图""像一本旧绘本的插页" |

### 关键原则

- **风格从内容长出来。** 一篇讲 AI 管线的文章自然适合机械感、冷色调；一篇讲个人成长的自然适合暖色、有机线条。AI 应该能感受到这种关联。
- **不要套模板。** 每次都是新创造。上一篇用水彩，下一篇就换版画。不需要刻意避免重复，但也不要有"默认风格"。
- **文字描述要具体可生成。** "暖色"不够，"暖橙 #E67E22 + 深棕背景，像傍晚阳光照在纸上"才够。图像模型需要看得见的具体描述。
- **加入图片来源限制：** 所有配图不能出现真人，动画/插画/卡通人物不受限。生成时在风格描述末尾加上 `no real people, no human faces`。

## 如何注入图片生成 prompt

AI 为整篇文章生成一段风格描述后，每张图的完整 prompt 结构如下：

```
[风格描述] + [这张图要画什么: 场景/主体/动作] + no real people, no human faces
```

示例：

```
风格描述：
Clean black ink line drawing on warm white paper. Thick bold strokes. One accent color: vermillion red used sparingly for highlights. No character. Minimal composition, lots of empty space, like a zen sketch.

图片内容：
A branching flowchart where the main path forks into three, one path leads to a dead end marked with a red X, the other two continue forward with dashed lines

完整 prompt：
Clean black ink line drawing on warm white paper. Thick bold strokes. One accent color: vermillion red used sparingly for highlights. No character. Minimal composition, lots of empty space, like a zen sketch. A branching flowchart where the main path forks into three, one path leads to a dead end marked with a red X, the other two continue forward with dashed lines. no real people, no human faces
```

## 全文统一风格

一篇文章的所有配图必须使用**同一套风格**，确保视觉连贯。风格在配图阶段开始时一次性生成，所有图片共享。

**半自动：** 生成风格后展示给用户确认。"这篇我打算用 xx 风格出图，你觉得怎么样？"
**全自动：** 直接生成风格，不需要确认。

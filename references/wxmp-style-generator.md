# 文章专属插图风格生成

## Contents

- 核心原则
- 风格生成流程
- 如何写 prompt
- 全文统一风格

## 核心原则

**每一篇文章的配图都应该是独一无二的。**

风格不是从库里选的，也不是套固定公式。AI 读完全文后，基于文章的内容、情感和受众去想象：这篇适合什么样的视觉风格？

写 prompt 时遵守三条底线：

1. **图中不能有任何文字。** 所有图像模型画文字都会出乱码。用构图和颜色代替文字表达。
2. **不能出现真人。** 动画、插画、卡通人物不受限。
3. **不能画图表/流程图。** 画场景，不要画 A→B→C 的箭头。

## 风格生成流程

```
确定配图位置 → 创造风格 → 写 prompt → 生成 → 上传
```

AI 读完全文后，想象这篇配图应该传达什么感觉，然后用自然语言写一段连贯的风格描述。

**不是填空，是想场景。** 不是列"技法+配色+角色+背景"，而是想"这篇内容如果用一幅图来表达，它看起来应该是什么氛围？像什么？"

示例风格描述（AI 应基于文章内容自由发挥，不套这些）：

```
一篇讲副业赚钱的文章 → "像一个人在爬梯子，梯子延伸到云端，暖色调，有光从上方照下来"
一篇讲 AI 工具对比的文章 → "两个不同的齿轮组合在一起，冷色背景，严谨但清爽的构图"
一篇讲效率方法的文章 → "一张乱糟糟的桌子上慢慢变整齐的过程感，柔和色彩"
```

## 如何写 prompt

完整 prompt 结构：

```
[视觉描述] + [具体场景] + 三条底线约束
```

`视觉描述` 是抽象的：什么氛围、什么色调、什么感觉。
`具体场景` 是具象的：画面里有什么、谁在做什么。
`三条底线约束`：`no real people, no human faces, no text, no labels, no chart, no diagram`

示例如下，但**不要套用这些 prompt**——每次根据内容重新发挥：

```
# 小红书赚钱机会：温暖、上升、希望感
Warm orange and golden yellow tones, soft light from above, dreamy and uplifting atmosphere. A simple ladder extends from bottom center up into soft clouds. Warm and inviting mood. no real people, no human faces, no text, no labels, no chart, no diagram

# AI 技能对比：冷静、清晰、结构感
Cool blue and white tones, clean and precise atmosphere. Two distinct geometric shapes sit side by side, connected by a thin line. Technical but not cold. no real people, no human faces, no text, no labels, no chart, no diagram

# 效率方法：从乱到整、轻松、成就感
Warm cream and soft green tones, gentle and satisfying atmosphere. A desk surface gradually transforming from cluttered to organized, soft light highlighting the clean half. no real people, no human faces, no text, no labels, no chart, no diagram
```

## 全文统一风格

一篇文章的所有概念型配图（开头、隐喻、案例、结尾引导）共用同一套视觉风格。

**封面图不受此限制**——封面图可以单独选择更适合传播的风格。

**半自动：** 生成风格后展示给用户确认
**全自动：** 直接生成
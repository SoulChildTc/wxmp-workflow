# 配图风格生成

## prompt 结构

```
[视觉描述] + [具体场景] + 底线约束
```

- `视觉描述`：氛围、色调、感觉
- `具体场景`：画面里有什么、谁在做什么
- `底线约束`：`no real people, no human faces, no text, no labels, no chart, no diagram`

## 底线

1. 图片中不能有文字。图像模型画文字会出乱码。
2. 不能有真人。
3. 不能画图表、流程图。

## 生图前自检

写完 prompt 后检查两项：

1. **位置词是否模糊。** 检查有没有"周围""上方""旁边"——改成"左侧""右下角""居中偏上"这类具体方位。
2. **约束与内容是否冲突。** `no chart` 的同时不能描述图表布局。冲突了就删掉冲突的约束或改画面描述。

## 统一风格

同一篇文章的概念型配图（开头配图、隐喻、案例、结尾引导）共用一套风格。封面图可以不同。

**半自动：** 风格内容展示给用户确认
**全自动：** 直接生成

## 参考

```
# 副业赚钱 — 暖色、上升、希望感
Warm orange and golden yellow tones, soft light from above. A ladder extends from bottom center up into soft clouds. no real people, no human faces, no text, no labels, no chart, no diagram

# 工具对比 — 冷色、清晰、结构感
Cool blue and white tones, clean atmosphere. Two geometric shapes sit side by side connected by a thin line. no real people, no human faces, no text, no labels, no chart, no diagram
```
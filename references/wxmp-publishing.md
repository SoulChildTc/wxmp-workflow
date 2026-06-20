# 发布流程

## Contents

- 前置条件
- 发布步骤（获取 token、上传封面图、创建草稿）
- 手动发布（无认证默认路径）
- API 增强（已认证账号可用）
- 复盘（未认证账号 / 已认证账号 触发词、执行流程、查询命令、分析内容、输出格式）
- 错误处理策略
- 注意事项

## 前置条件

1. `config/wxmp.json` 中配置好 AppID 和 Secret
2. 获取方式：微信公众平台 → 我的业务与服务 → 公众号 → 开发密钥

> 个人订阅号通常**没有**个人认证。无认证时能做的事：
> - 获取 token ✅
> - 上传图片 ✅
> - 创建/更新草稿 ✅
> - 查询数据 ✅
> - API 预览 ❌（报 `48001`）
> - API 发布 ❌（报 `48001`）
>
> 发布流程走哪条路由 `config/wxmp.json` 的 `verified` 字段决定（默认 `false`）。

## 发布步骤

以下步骤无需认证，大多数用户都能走通。

### 1. 获取访问凭证

```bash
bash scripts/wx-auth.sh
```

脚本自动获取并缓存 access_token（2小时有效），缓存在 `/tmp/wxmp-token.json`。

**可能的错误：**
- `invalid appid` — AppID 配置错误，检查 `config/wxmp.json`
- `invalid secret` — AppSecret 配置错误
- 超过调用频率限制 — 等待一段时间后重试，或使用缓存的 token

### 2. 上传封面图

上传封面图时**必须指定 `thumb` 类型**，否则上传的是正文图片，创建草稿时会报错：

```bash
bash scripts/wx-upload-image.sh /path/to/cover-image.jpg thumb
```

返回 `thumb_media_id`，用于创建草稿。

**两种类型的区别：**
- `thumb`（封面图）：创建草稿时用，返回 `media_id`
- `image`（正文图片）：文章内插图用，返回 `media_id` + `url`

不传第二个参数默认是 `image`。

**要求：**
- 封面图推荐尺寸 900×383（2.35:1 比例）
- 最大 10MB
- 支持 JPG、PNG 格式

**可能的错误：**
- 文件不存在或路径错误 — 确认图片路径
- 文件过大 — 压缩图片后重试
- 格式不支持 — 转换为 JPG 后重试

### 3. 创建草稿

```bash
bash scripts/wx-draft.sh \
  --title "文章标题" \
  --author "作者名" \
  --digest "文章摘要（120字以内）" \
  --content output/2026-06-05-article.html \
  --thumb MEDIA_ID \
  --comment 1
```

参数说明：
- `--title`：文章标题（必填）
- `--content`：HTML 文件路径（必填）
- `--thumb`：封面图 media_id（必填）
- `--author`：作者名（可选，默认读取配置文件）
- `--digest`：摘要，120字以内（可选）
- `--comment`：是否开启评论 0|1（可选，默认1）
- `--fans-only`：仅粉丝可评论 0|1（可选，默认0）

首次调用返回 `media_id`，后续操作（更新、预览、发布）都复用这个 `media_id`。

**草稿更新：** 如果打磨/配图阶段修改了 HTML 或标题，发布前必须用 `--media-id` 更新草稿：

```bash
bash scripts/wx-draft.sh \
  --media-id DRAFT_MEDIA_ID \
  --title "最终标题" \
  --content output/2026-06-05-article.html \
  --thumb MEDIA_ID
```

**可能的错误：**
- `thumb_media_id is invalid` — 封面图上传失败或 media_id 过期，重新上传
- `content is invalid` — HTML 内容格式有问题，检查是否有不支持的标签
- `title is missing` — 标题为空

## 手动发布（默认路径）

草稿创建成功后，**大多数用户走这个路径**——去公众号后台完成预览和发布：

1. 打开公众号后台 → 内容管理 → 草稿箱
2. 找到刚刚创建的草稿
3. 点击「预览」发送到手机查看效果（检查排版、图片、链接）
4. 确认无误后点击「发布」

预览时重点检查：
- 标题是否显示正常
- 封面图是否清晰
- 正文排版是否整齐
- 图片是否加载成功
- 在手机上阅读是否舒适

**半自动：** 草稿创建后告诉用户去后台预览 → 用户看了说"可以发"→ 指导用户手动点发布
**全自动：** 草稿创建成功后，告诉用户"草稿已就绪，去公众号后台手动发布"

## API 增强（已认证账号：`verified: true`）

在 `config/wxmp.json` 中设置 `"verified": true` 后启用。脚本读取配置，不需要每次询问。

### 预览

```bash
bash scripts/wx-preview.sh --media-id DRAFT_MEDIA_ID --wx-name 微信号
```

需要公众号有消息推送权限。个人订阅号可能无此权限，报 `48001` 时走手动预览。

**半自动：** 发预览，等用户确认"可以发了"
**全自动：** 跳过预览，直接发布

### 发布文章

发布前确认草稿内容是最新的——如果打磨/配图阶段修改过 HTML，先用 `--media-id` 更新草稿。

```bash
bash scripts/wx-publish.sh --media-id DRAFT_MEDIA_ID
```

脚本自动轮询发布状态，直到成功或失败（默认超时 120 秒）。

**发布是异步操作**，提交后需要等待。脚本会每 5 秒检查一次状态。

**可能的错误：**
- `48001 api unauthorized` — 公众号未完成个人认证，引导用户手动去公众号后台发布
- `publish limit reached` — 当天发布次数已用完（订阅号1次/天，服务号4次/天）
- 超时 — 可能仍在排队，稍后用 publish_id 手动查询状态
- `freepublish not enabled` — 账号未开通发布功能

**半自动：** 发布前停下来等用户最终确认
**全自动：** 草稿更新后直接发布

## 复盘

用户回来说"帮我查数据"时启动。先读 `config/wxmp.json` 的 `verified` 字段。

### 未认证账号（`verified: false`）

告知用户："未认证账号无法通过 API 查询文章数据。去公众号后台 → 统计 → 图文数据查看。"

### 已认证账号（`verified: true`）

### 触发词

用户说以下任意一句即启动复盘流程：`帮我查数据`、`帮我看看那篇文章的数据`、`复盘`、`看看数据`。

### 执行流程

1. **拉文章列表**：`bash scripts/wx-articles.sh`，展示给用户选择
2. **用户选文章**：确认要复盘哪篇
3. **检查数据是否可用**：发布时间是否已过 1 天
   - 还没到：告知用户"数据有 ~1 天延迟，明天再来查"
   - 已过 1 天：继续下一步
4. **查数据**：`bash scripts/wx-article-stats.sh --recent N`
   - N 的范围：发布到现在的天数，最多 7 天
   - 如果超过 7 天，优先查前 7 天（近期数据最有参考价值）
5. **输出复盘分析**

### 查询命令参考

```bash
# 查看已发布文章列表
bash scripts/wx-articles.sh                          # 获取最近20篇
bash scripts/wx-articles.sh --count 20 --offset 20   # 获取第21-40篇（用 --offset 翻页）

# 查看单篇文章详细数据
bash scripts/wx-article-stats.sh --date 2026-06-05   # 指定某天
bash scripts/wx-article-stats.sh --recent 7          # 最近7天
```

统计数据有约 1 天延迟，且最多查询 7 天范围。API 数据按日期查询，脚本自动拼接。

### 复盘分析内容

查看数据后，按以下维度输出分析：

1. **数据表现**
   - 阅读量（人数 + 次数）
   - 分享率 = 分享人数 / 阅读人数
   - 收藏率 = 收藏人数 / 阅读人数
   - 和历史文章对比（如果 API 能查到历史数据）

2. **标题效果**
   - 这篇的阅读量是否正常？
   - 分享率是否高于平均水平？

3. **选题建议**
   - 这个方向值得继续写吗？
   - 根据数据给出下篇选题建议

### 复盘输出格式

输出为内联 HTML，风格参考排版设计规范（配色 #3f3f3f/#fa5151/#f7f7f7、圆角 8px、留白）。数据用卡片呈现，让数字一目了然。

**设计规则：**
- 每个关键指标（阅读、分享率、收藏率）独立一张卡片，`flex` 并排
- 数字用大字（24px）+ 品牌色（#fa5151），标签用小字（12px）+ 灰色（#999）
- 表现好的指标（分享率 > 10%）用绿色（#07c160）标记，一般的用默认色
- 分析区用左边框卡片（参照排版规范的信息提示框组件）
- 建议区单独一行

示例结构（实际输出时填充真实数据，样式可微调以适配不同数据量）：

```html
<section style="margin: 0 0 1.25em; font-family: -apple-system-font, Helvetica Neue, PingFang SC, Hiragino Sans GB, Microsoft YaHei, sans-serif;">

  <section style="font-size: 18px; font-weight: bold; color: #3f3f3f; margin: 0 0 0.25em;">
  📊 复盘报告
  </section>
  <section style="font-size: 13px; color: #999; margin: 0 0 1.25em;">
  《文章标题》· xxxx-xx-xx 发布
  </section>

  <!-- 数据卡片行 -->
  <section style="display: flex; gap: 10px; margin: 0 0 1.25em;">
    <section style="flex: 1; padding: 14px 8px; background: #f7f7f7; border-radius: 8px; text-align: center;">
      <section style="font-size: 26px; font-weight: bold; color: #fa5151; line-height: 1.3;">xxx</section>
      <section style="font-size: 12px; color: #999; line-height: 1.4;">阅读人数</section>
    </section>
    <section style="flex: 1; padding: 14px 8px; background: #f7f7f7; border-radius: 8px; text-align: center;">
      <section style="font-size: 26px; font-weight: bold; color: #07c160; line-height: 1.3;">xx%</section>
      <section style="font-size: 12px; color: #999; line-height: 1.4;">分享率</section>
    </section>
    <section style="flex: 1; padding: 14px 8px; background: #f7f7f7; border-radius: 8px; text-align: center;">
      <section style="font-size: 26px; font-weight: bold; color: #3f3f3f; line-height: 1.3;">xx%</section>
      <section style="font-size: 12px; color: #999; line-height: 1.4;">收藏率</section>
    </section>
  </section>

  <!-- 分析卡片 -->
  <section style="margin: 0 0 0.75em; padding: 0.75em 1em; border-left: 3px solid #fa5151; background: #f7f7f7; border-radius: 0 6px 6px 0;">
    <section style="font-size: 14px; color: #3f3f3f; line-height: 1.7;">
    <strong>标题效果：</strong>xxx<br/>
    <strong>选题评估：</strong>xxx
    </section>
  </section>

  <!-- 建议 -->
  <section style="font-size: 14px; color: #666; line-height: 1.6; padding: 0.5em 0;">
  💡 <strong>建议：</strong>xxx
  </section>
</section>
```

## 错误处理策略

当 API 调用失败时，按以下优先级处理：

1. **配置错误**（AppID/Secret 错误）→ 引导用户检查配置文件
2. **权限错误**（功能未开通）→ 提示用户在公众号后台开通对应功能
3. **频率限制** → 等待后重试，或使用缓存的 token
4. **内容格式错误** → 检查 HTML 是否符合公众号要求
5. **网络错误** → 重试一次，仍失败则建议用户稍后再试

遇到无法自动修复的错误时，清晰地告知用户：
- 错误是什么
- 可能的原因
- 建议的解决方案

## 注意事项

- 微信公众号每天发布次数有限制：订阅号 1 次，服务号 4 次
- access_token 有效期 2 小时，脚本会自动缓存和刷新
- 文章内容不支持外部 CSS 和 JavaScript
- 图片必须先上传到微信素材库才能在文章中使用
- 发布后文章无法修改，只能删除重发（会占用当天的发布次数）

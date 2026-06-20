# 多平台同步

## Contents

- 前置条件（安装 CLI、Chrome 扩展、登录平台、MCP 连接）
- 平台配置（首次同步、后续同步、添加/移除）
- 同步步骤（检查登录、执行同步、确认结果）
- 支持的平台（24 个平台 ID 速查）
- 常见问题（连不上扩展、未登录、排版错乱、图片不显示）
- 注意事项

公众号发布并确认效果后，用 Wechatsync CLI 把同一篇文章同步到其他内容平台的草稿箱。用户自行预览、确认、发布。

## 前置条件

### 1. 安装 Wechatsync CLI

```bash
npm install -g @wechatsync/cli
```

验证安装：
```bash
wechatsync --version
```

### 2. 安装 Chrome 扩展

在 Chrome 网上应用店搜索「文章同步助手」或访问：
https://chrome.google.com/webstore/detail/hchobocdmclopcbnibdnoafilagadion

支持 Chrome / Edge / 360 / QQ 等 Chromium 内核浏览器。

### 3. 登录各平台账号

在浏览器里正常登录你要同步的平台（知乎、掘金、CSDN 等）。Wechatsync 使用浏览器已有的 Cookie，不需要额外授权。

### 4. 启用扩展的 MCP 连接

在 Chrome 扩展设置中启用「MCP 连接」，获取 Token。CLI 通过 WebSocket 与扩展通信。

```bash
export WECHATSYNC_TOKEN="你的token"
```

## 平台配置

### 首次同步

第一次同步时，询问用户要同步到哪些平台：

```
你想同步到哪些平台？目前支持：

技术社区：掘金(juejin)、CSDN(csdn)、SegmentFault(segmentfault)、开源中国(oschina)、博客园(cnblogs)、51CTO(51cto)
自媒体：知乎(zhihu)、头条号(toutiao)、微博(weibo)、小红书(xiaohongshu)、抖音图文(douyin)
通用：简书(jianshu)、B站专栏(bilibili)、百家号(baijiahao)、语雀(yuque)、豆瓣(douban)、搜狐号(sohu)
其他：雪球(xueqiu)、东方财富(eastmoney)、什么值得买(smzdm)、网易号(netease)
建站：WordPress(wordpress)、Typecho(typecho)

请输入平台 ID，多个用逗号分隔（如：zhihu,juejin,csdn）
```

用户选择后，写入 `config/wxmp.json`：

```json
{
  "wechatsync_platforms": ["zhihu", "juejin", "csdn"]
}
```

### 后续同步

读取配置文件中的 `wechatsync_platforms`，直接同步。不再询问。

### 添加/移除平台

用户说"加一个 XXX 平台"或"以后不用同步 XXX 了"，更新配置文件即可。

## 同步步骤

### 1. 检查登录状态

```bash
wechatsync platforms --auth
```

确认目标平台都显示已登录。未登录的平台需要用户在浏览器里先登录。

### 2. 执行同步

```bash
wechatsync sync output/2026-06-05-article.html -p zhihu,juejin,csdn
```

可选参数：
- `-t "标题"` — 指定标题（默认从 HTML 提取）
- `--cover URL` — 指定封面图
- `--dry-run` — 预览模式，不同步

### 3. 确认同步结果

同步完成后，CLI 会输出每个平台的结果。文章进入各平台的草稿箱。

提醒用户：
- 去各平台的草稿箱检查文章
- 确认排版、图片是否正常
- 手动点击发布

## 支持的平台

| 平台 | ID | 类型 |
|------|-----|------|
| 微信公众号 | weixin | 主流自媒体 |
| 知乎 | zhihu | 主流自媒体 |
| 微博 | weibo | 主流自媒体 |
| 小红书 | xiaohongshu | 主流自媒体 |
| 掘金 | juejin | 技术社区 |
| CSDN | csdn | 技术社区 |
| 简书 | jianshu | 通用 |
| 头条号 | toutiao | 主流自媒体 |
| 抖音图文 | douyin | 主流自媒体 |
| B站专栏 | bilibili | 通用 |
| 百家号 | baijiahao | 通用 |
| 语雀 | yuque | 技术社区 |
| 豆瓣 | douban | 通用 |
| 搜狐号 | sohu | 通用 |
| 雪球 | xueqiu | 财经 |
| 东方财富 | eastmoney | 财经 |
| 什么值得买 | smzdm | 通用 |
| 网易号 | netease | 通用 |
| SegmentFault | segmentfault | 技术社区 |
| 开源中国 | oschina | 技术社区 |
| 博客园 | cnblogs | 技术社区 |
| 51CTO | 51cto | 技术社区 |
| WordPress | wordpress | 建站 |
| Typecho | typecho | 建站 |

## 常见问题

### CLI 连不上 Chrome 扩展

- 确认 Chrome 扩展已安装且启用
- 确认扩展设置中「MCP 连接」已开启
- 确认 Token 一致：`export WECHATSYNC_TOKEN="xxx"`

### 平台显示未登录

- 在浏览器里手动登录该平台
- 登录后刷新扩展状态：`wechatsync platforms --auth`

### 同步后排版错乱

- 各平台对 HTML 的支持程度不同，Wechatsync 会自动做格式转换
- 公众号的特殊样式（引导关注卡片等）在其他平台可能显示不正常
- 建议同步后去各平台草稿箱检查，必要时手动调整

### 图片显示不出来

- 公众号文章的图片走的是微信 CDN，其他平台可能无法访问
- Wechatsync 会自动转存图片到目标平台
- 如果图片仍未显示，需要手动上传

## 注意事项

- 同步的是 HTML 文件，各平台会自动转换格式
- 同步后文章进入草稿箱，不会自动发布
- 部分平台对文章长度、图片数量有限制
- Wechatsync 依赖 Chrome 扩展，需要保持浏览器打开

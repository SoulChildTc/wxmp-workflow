# 配置助手

## Contents

- 执行流程（7 步：检查→选择位置→基础配置→代理→信源→可选功能→确认）
- 配置总览（功能速查表）
- 1. 微信公众号 API
- 2. 写作质量工具（Humanizer + StopSlop 合并）
- 3. 图片生成（Agnes + SenseNova 合并）
- 4. Wechatsync（多平台同步）
- 5. Reddit 信源（选题扩展）
- 快速检查清单
- 配置文件模板

首次使用或需要配置新功能时，引导用户完成前置准备。按需配置，不是所有功能都需要。

## 执行流程

当用户说"帮我配置"时，按以下步骤执行：

### 第 1 步：检查现有配置

读取 `config/wxmp.json`，检查各项配置状态。配置文件支持两个位置，按优先级查找：

1. **当前项目目录**：`{项目}/config/wxmp.json`（用户自己的项目）
2. **Skill 安装目录**：skill 安装位置下的 `config/wxmp.json`（所有项目共享）

配置状态检查：

```
📋 配置检查

| 功能 | 状态 | 说明 |
|------|------|------|
| 公众号 API | ✅ 已配置 / ❌ 未配置 | AppID + Secret，发布必需 |
| Humanizer | ✅ 已安装 / ❌ 未安装 | 去 AI 痕迹，可选 |
| StopSlop | ✅ 已安装 / ❌ 未安装 | 写作质量打磨，可选 |
| Agnes AI | ✅ 已配置 / ❌ 未配置 | 图片生成，可选 |
| Wechatsync | ✅ 已配置 / ❌ 未配置 | 多平台同步，可选 |
| Reddit 信源 | ✅ 已配置 / ❌ 未配置 | 选题扩展，可选 |
```

检测 Humanizer/StopSlop 安装状态：检查 skill 安装目录下是否存在 `humanizer` / `stop-slop` 文件夹。
检测 Reddit 配置状态：执行 `which rdt` 检查 rdt-cli 是否安装，再检查 `topic_sources` 中是否包含 Reddit。

### 第 2 步：选择配置保存位置

如果有任何配置缺失，先问用户配置文件保存在哪里：

```
配置文件保存在哪里？
1. 当前项目目录（{项目路径}/config/wxmp.json）— 只对当前项目生效
2. Skill 安装目录（{skill路径}/config/wxmp.json）— 所有项目共享
```

选 1 → 创建 `{项目}/config/wxmp.json`
选 2 → 创建 `{skill安装目录}/config/wxmp.json`

如果配置文件已存在，跳过此步，直接在已有文件上修改。

### 第 3 步：处理基础配置

如果公众号 API 未配置，优先引导配置（发布功能依赖它）。

同时确认以下基础字段（未配置时询问）：
- `author`："文章作者名是什么？创建草稿时会自动填入。"
- `default_comment`："默认开启评论吗？（1=开，0=关）"
- `default_fans_only_comment`："默认仅粉丝可评论吗？（1=是，0=否）"

### 第 4 步：询问代理地址

选题功能会扫描国际信源，有代理可以作为备选访问方式。AI 会自动探测每个信源的最佳访问方式并缓存，代理只是备选方案之一。

```
你有科学上网的代理吗？如果有，请告诉我代理地址（如 127.0.0.1:7890）。
- 有代理 → 作为备选访问方式，直接访问失败时自动走代理
- 没有代理 → 直接访问失败时通过搜索引擎间接获取
```

用户提供地址（如 `127.0.0.1:7890`）→ 写入：
```json
"proxy": {
  "http": "http://127.0.0.1:7890",
  "https": "http://127.0.0.1:7890"
}
```

用户说没有 → 写入：
```json
"proxy": {
  "http": "",
  "https": ""
}
```

### 第 5 步：询问选题信源偏好

选题功能默认配置了科技和金融两个领域的信源。询问用户是否要调整：

```
选题默认信源已配置：
- 科技：GitHub Trending、Hacker News、Product Hunt
- 金融：TradingView、CNBC、Financial Times

要调整吗？比如添加你关注的领域或信源。
- 不用改 → 保持默认
- 要改 → 让用户描述关注的领域，更新 topic_sources
```

用户说不用改 → 跳过
用户要改 → 根据用户描述更新 `topic_sources` 的 `tech`/`finance`/`custom` 字段

### 第 6 步：询问可选配置

逐个询问未配置的可选功能：

- Humanizer："要安装 Humanizer 来消除 AI 写作痕迹吗？基于维基百科 AI 写作特征检测，支持声音校准。"
- StopSlop："要安装 StopSlop 来提升文章质量吗？它是一套专业的写作打磨规则，配合 Humanizer 效果更好。"
- Agnes AI："要配置 AI 图片生成吗？可以一句话生成配图。"
- SenseNova："Agnes 不稳定的话，要同时配置 SenseNova 作为备选图片生成方案吗？擅长信息图。"
- Wechatsync："要配置多平台同步吗？可以把文章一键同步到知乎、掘金等 24 平台。"
- Reddit："要接入 Reddit 作为选题信源吗？信息差大、时效性强。需要在浏览器登录 Reddit。"

用户说"要"→ 引导配置；说"不要"→ 跳过，不打扰；说"已经装过了"→ 跳过安装，验证可用即可。

**Skill 安装位置：** 用户说要安装 Humanizer 或 StopSlop 时，询问安装位置：
```
安装到哪里？
1. 当前项目 — 只对当前项目生效
2. 全局 — 所有项目共享
```

- 当前项目：`npx skills add <repo> -y`，直接装到项目 `.agents/skills/` 下，无需选择 Agent
- 全局：`npx skills add <repo> -g -y`，装到 `~/.agent/` 下。用 `--all` 跳过 Agent 选择（装到所有 Agent），或用 `-a <agent>` 只装到当前 Agent。AI 需判断自己运行在哪个 Agent 工具中（如 Claude Code、Cursor 等），并确认该 Agent 在 `skills` 支持的列表中，再决定是否指定 `-a` 及用哪个 Agent 名称

**网络提示：** `npx skills add` 需要从 GitHub 下载，国内可能访问不了。如果安装卡住或超时，提示用户配置代理后重试。

### 第 7 步：确认

配置完成后，再次运行检查，展示最终状态。

## 配置总览

> 以下功能按配置依赖排序。不配置不影响核心写作功能，只会缺少对应能力。

| 功能 | 必须 | 需要什么 |
|------|------|---------|
| 写文章、打磨、排版 | ✅ | 无，开箱即用 |
| 发布到公众号 | 推荐 | AppID + Secret |
| 去 AI 痕迹 + 打磨质量 | 可选 | Humanizer / StopSlop skill |
| 图片生成 | 可选 | Agnes / SenseNova API Key |
| 多平台同步 | 可选 | Wechatsync CLI + Chrome 扩展 |
| Reddit 选题 | 可选 | rdt-cli + Chrome 登录 |

> 💡 选题时的信源连通性由 AI 自动探测并缓存到 `config/connectivity.json`，无需手动配置。

---

## 1. 微信公众号 API

用于自动创建草稿、发布文章、查询数据统计。

> ⚠️ 发布需公众号完成**个人认证**，否则报 `48001 api unauthorized`。未认证时只能创建草稿。

**获取：** 微信公众平台 → 我的业务与服务 → 公众号 → 开发密钥

**填入 `config/wxmp.json`：**
```json
{ "appid": "你的AppID", "secret": "你的AppSecret" }
```
其他可选字段（`author`、`default_comment`、`default_fans_only_comment`）在第 3 步按需配置。

**验证：** `bash scripts/wx-auth.sh` → 输出 `✅ access_token 获取成功`

**常见问题：**
- `invalid appid` / `invalid secret` — 检查有无多余空格
- `ip not in whitelist` — 在公众号后台配 IP 白名单
- 没 API 也能用 — 写文打磨排版都正常，发布时手动去后台贴 HTML

---

## 2. 写作质量工具（可选）

| 工具 | 作用 | 安装 | 验证 | 降级 |
|------|------|------|------|------|
| Humanizer | 消除 30 种 AI 写作模式，支持声音校准 | `npx skills add blader/humanizer` | 检查 skill 目录下有 `humanizer` 文件夹 | 用内置 4 轮去 AI 味检查 |
| StopSlop | 8 条写作原则 + 12 项快速检查 | `npx skills add hardikpandya/stop-slop` | 检查 skill 目录下有 `stop-slop` 文件夹 | 用内置体检报告 |

> 执行顺序：Humanizer（去痕迹）→ StopSlop（打磨质量），配合使用效果最好。

**关于安装位置：** 询问用户后决定：
- 当前项目：`npx skills add <repo> -y`
- 全局：`npx skills add <repo> -g -y`（或用 `--all` 装到所有 Agent）

> 💡 `npx skills add` 需从 GitHub 下载，国内可能访问不了。卡住时配代理重试。

---

## 3. 图片生成（可选）

| 方案 | 特点 | 获取 | 验证 |
|------|------|------|------|
| Agnes AI | 通用图片 | [agnes-ai.com](https://agnes-ai.com/) 注册获取 API Key | `bash scripts/wx-generate-image.sh --prompt "一只猫" --size 512x512` |
| SenseNova | 信息图，Agnes 备选 | [sensenova.cn](https://sensenova.cn/) 注册获取 API Key | `bash scripts/wx-generate-image-sensenova.sh --prompt "一张简单的测试图"` |

配置任一即可，优先 Agnes。在 `config/wxmp.json` 中添加对应 `agnes_api_key` / `sensenova_api_key`。

两个都没配时：配图阶段需要用户自己提供图片，或用占位符标注位置后续补充。

---

## 4. Wechatsync（多平台同步，可选）

把文章同步到知乎、掘金、CSDN 等 24 平台草稿箱。

**配置步骤：**
1. 安装 CLI：`npm install -g @wechatsync/cli`
2. Chrome 安装[文章同步助手扩展](https://chrome.google.com/webstore/detail/hchobocdmclopcbnibdnoafilagadion)
3. 在浏览器里登录目标平台
4. 在扩展设置中启用「MCP 连接」，记下 Token

**配置同步平台：** 首次同步时告诉 AI 目标平台，自动写入 `config/wxmp.json` 的 `wechatsync_platforms`。后续说"加一个 XXX 平台"即可更新。

**验证：** `export WECHATSYNC_TOKEN="你的token" && wechatsync platforms --auth`

**常见问题：**
- CLI 连不上扩展 → 确认扩展已装且「MCP 连接」已开启
- 平台未登录 → 在浏览器里手动登录
- Token 不一致 → CLI 的 Token 和扩展里的要一致

没配时：文章只发公众号，同步需手动复制粘贴。

---

## 5. Reddit 信源（选题扩展，可选）

AI 负责安装和配置，用户只需在浏览器登录 Reddit。

1. AI 安装 rdt-cli：`uv tool install rdt-cli || pipx install rdt-cli`
2. **用户操作：** 在 Chrome 登录 [Reddit](https://www.reddit.com)
3. AI 验证：`rdt login`（自动读取 Chrome 登录状态）
4. AI 写入配置 `topic_sources.custom`，默认加入 `r/technology` 和 `r/worldnews`

**验证：** `rdt sub technology -n 1 --compact` → 输出一条帖子即正确

没配时：选题只用默认信源（GitHub Trending、Hacker News 等），不影响核心功能。

## 快速检查清单

告诉 AI "帮我检查配置" 时，按第 1 步的配置状态检查表逐项检查。

## 配置文件模板

完整的 `config/wxmp.json` 示例：

```json
{
  "appid": "wx1234567890abcdef",
  "secret": "your_app_secret_here",
  "author": "你的公众号名称",
  "default_comment": 1,
  "default_fans_only_comment": 0,
  "agnes_api_key": "your_agnes_api_key_here",
  "wechatsync_platforms": ["zhihu", "juejin", "csdn"],
  "proxy": {
    "http": "",
    "https": ""
  },
  "topic_sources": {
    "tech": ["GitHub Trending", "Hacker News", "Product Hunt"],
    "finance": ["TradingView", "CNBC", "Financial Times"],
    "custom": []
  }
}
```

| 字段 | 说明 | 默认值 |
|------|------|--------|
| `appid` | 公众号 AppID | 发布必需 |
| `secret` | 公众号 AppSecret | 发布必需 |
| `author` | 文章作者名，创建草稿时自动填入 | 空 |
| `default_comment` | 是否开启评论（1=开，0=关） | 1 |
| `default_fans_only_comment` | 是否仅粉丝可评论（1=是，0=否） | 0 |
| `proxy` | 代理配置，含 `http` 和 `https` 两个字段，空则不走代理 | `{"http":"","https":""}` |
| `agnes_api_key` | Agnes AI 图片生成 API Key | 可选 |
| `wechatsync_platforms` | 多平台同步目标列表 | 可选 |
| `topic_sources` | 选题信源，对象结构：`tech`（科技）、`finance`（财经）、`custom`（自定义），每个字段是字符串数组。`custom` 用于 Reddit 等扩展信源 | 见示例 |

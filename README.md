# wxmp-workflow

> 微信公众号全流程工作流 — 从灵感到发布，一站式完成

一个 AI Agent skill，帮你完成公众号内容创作的全链路。兼容 Claude Code、Cursor、Windsurf 等支持 skill 的 Agent 工具：

```
选题 → 大纲 → 调研 → 写稿 → 打磨 → 配图 → 排版 → 发布 → 复盘
```

支持**全自动**（无人值守）和**半自动**（交互式确认）两种模式。

---

## ✨ 功能

| 阶段 | 能力 |
|------|------|
| 📡 选题 | 三模式扫描（热点速报/深度选题/预判选题）、Reddit 信源可选 |
| 🔍 调研 | 竞品文章、行业数据、权威引用、用户案例 |
| ✍️ 撰写 | 大纲生成、正文撰写、多轮修改 |
| 💎 打磨 | 去 AI 味（Humanizer + StopSlop / 内置 4 轮扫描）、文章体检报告、爆款标题、摘要 |
| 🎨 配图 | Agnes AI 一句话生成配图 |
| 📐 排版 | 5 个精美 HTML 模板，适配微信深色/浅色模式 |
| 🚀 发布 | API 自动发布、数据统计查询 |
| 📊 复盘 | 阅读量/分享率分析、经验总结 |

---

## 🚀 快速开始

### 1. 安装

```bash
npx skills add SoulChildTc/wxmp-workflow
```

更新到最新版本：

```bash
npx skills update wxmp-workflow
```

### 2. 使用

在支持 skill 的 Agent 工具中调用 skill，再输入指令：

```
> /wxmp-workflow
> 帮我写篇公众号
```

常用指令：

| 指令 | 说明 |
|------|------|
| 帮我配置 | 配置助手，引导完成各项设置 |
| 帮我写篇公众号 | 完整流程：选题 → 发布 |
| 帮我写篇关于 AI 的文章 | 跳过选题，从调研开始 |
| 全自动帮我写完直接发 | 无人值守模式 |
| 帮我想几个标题 | 单独调用爆款标题生成器 |
| 帮我看看文章怎么样 | 调用文章体检报告 |

---

## ⚙️ 配置

```bash
cp config/wxmp.example.json config/wxmp.json
```

配置文件支持两个位置（当前项目目录优先）：

| 功能 | 是否必须 | 配置项 |
|------|---------|--------|
| 写文章、打磨、排版 | ✅ 必须 | 无，开箱即用 |
| 发布到公众号 | 推荐 | `appid` + `secret` |
| 去 AI 痕迹 | 可选 | Humanizer skill |
| 写作质量打磨 | 可选 | StopSlop skill |
| AI 生成配图 | 可选 | `agnes_api_key` |
| Reddit 选题信源 | 可选 | rdt-cli + Chrome 登录 Reddit |

获取公众号 API：微信公众平台 → 我的业务与服务 → 公众号 → 开发密钥

说"帮我配置"可以引导完成所有设置。

---

## 🧹 去 AI 味增强（Humanizer + StopSlop）

内置的去 AI 味规则已经覆盖了特征词、结构、风格、人味 4 个层面。如果想要更专业的效果，可以安装两个互补的工具：

```bash
# 去 AI 痕迹（基于维基百科 AI 写作特征检测，支持声音校准）
npx skills add blader/humanizer

# 写作质量打磨（8 条原则 + 12 项快速检查 + 评分系统）
npx skills add hardikpandya/stop-slop
```

执行顺序：Humanizer（去 AI 痕迹）→ StopSlop（打磨质量）。安装后 AI 会自动优先使用，不安装也不影响正常使用。

---

## 🔌 扩展选题信源

选题功能默认内置了科技和金融领域的信源（GitHub Trending、Hacker News、Product Hunt、TradingView 等）。你可以通过 `config/wxmp.json` 的 `topic_sources` 字段添加自定义信源。

### Reddit（内置可选）

Reddit 是优质的原始话题来源，信息差大、时效性强。通过 `rdt-cli` 接入，配置助手会引导完成：

```
> 帮我配置
> ...选择配置 Reddit...
```

AI 会自动安装 `rdt-cli`，你只需要在 Chrome 里登录 Reddit 即可。

AI 会自动探测访问方式并缓存结果，先尝试直接访问，失败后走代理或搜索引擎。

---

## 📁 项目结构

```
wxmp-workflow/
├── SKILL.md                    # skill 入口
├── config/
│   ├── wxmp.example.json       # 配置模板
│   └── connectivity.json       # 信源连通性缓存（自动生成，不提交）
├── references/                 # 各阶段详细指引
│   ├── wxmp-inspiration.md     # 选题（含连通性缓存机制）
│   ├── chinese-copywriting-guidelines.md  # 中文排版规范
│   ├── wxmp-research.md        # 调研
│   ├── wxmp-writing.md         # 撰写 + 打磨 + 配图 + 排版
│   ├── wxmp-tools.md           # 增强工具集
│   ├── wxmp-publishing.md      # 发布 + 复盘
│   └── wxmp-setup.md           # 配置助手
├── scripts/                    # API 脚本（curl + jq）
├── templates/                  # 5 个精美 HTML 模板
└── output/                     # 生成的文章输出目录
```

---

## 📝 脚本用法

```bash
# 获取 token（自动缓存 2 小时）
bash scripts/wx-auth.sh

# 上传封面图 → 创建草稿 → 发布
bash scripts/wx-upload-image.sh /path/to/cover.jpg
bash scripts/wx-draft.sh --title "标题" --content output/xxx.html --thumb MEDIA_ID
bash scripts/wx-publish.sh --media-id DRAFT_MEDIA_ID

# 查询数据
bash scripts/wx-stats.sh --recent 7
bash scripts/wx-article-stats.sh --recent 7

# AI 图片生成
bash scripts/wx-generate-image.sh --prompt "图片描述"
```

---

## 📌 注意事项

- 公众号每天发布次数有限制：订阅号 1 次，服务号 4 次
- 文章 HTML 必须使用内联样式，不支持外部 CSS/JS
- 图片必须先上传到微信素材库才能在文章中使用
- 发布后文章无法修改，只能删除重发（会占用当天发布次数）

---

## License

MIT

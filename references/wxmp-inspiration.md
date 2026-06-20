# 选题发现

## Contents

- 何时跳过此阶段
- 信源访问策略（连通性缓存、访问流程、method 说明）
- 三种发现模式（热点速报、深度选题、预判选题）
- 竞品分析（补充手段）
- 用户互动分析（补充手段）
- 选题评估标准
- 综合推荐

帮助用户从零开始找到有价值的公众号选题。

## 何时跳过此阶段

以下情况直接进入撰写阶段：
- 用户已经明确说了要写什么主题
- 用户提供了素材（文档、链接、笔记）要求写成文章
- 用户说"跳过选题"或类似表达

## 信源访问策略

访问外部信源时，不要假设哪些站能直接访问、哪些不能。使用**连通性缓存**自动适配网络环境。

### 连通性缓存

缓存文件：`config/connectivity.json`（已在 `.gitignore` 中，不提交）

```json
{
  "github.com": { "method": "proxy", "tested_at": "2026-06-07T10:00:00" },
  "techcrunch.com": { "method": "direct", "tested_at": "2026-06-07T10:00:00" },
  "reddit.com": { "method": "websearch", "tested_at": "2026-06-07T10:00:00" }
}
```

- `method`：上次成功的方式（`direct` / `proxy` / `websearch`）
- `tested_at`：上次测试时间

### 访问流程

```
1. 查缓存 → 有记录？
   ├── 是 → 用缓存的 method 访问
   │   ├── 成功 → 直接使用
   │   └── 失败 → 按 direct → proxy → websearch 顺序重试，更新缓存
   └── 否 / 无记录 → 按 direct → proxy → websearch 顺序尝试，记录结果
```

**每种方式的具体操作：**

| method | 操作 |
|--------|------|
| `direct` | `curl -s --connect-timeout 5 {url}` |
| `proxy` | `curl -s -x {proxy.https} {url}`（代理地址从 `config/wxmp.json` 读取） |
| `websearch` | `WebSearch` 搜索关键词获取摘要信息 |

**关键原则：**
- 不要硬编码"某站需要代理"——实际试试才知道
- 每次成功/失败都更新缓存
- 没有配置代理时，跳过 proxy 步骤，直接从 direct 失败跳到 websearch
- 缓存不会过期，只在访问失败时更新（自愈：某次访问失败后自动尝试其他方式并更新缓存）

## 三种发现模式

选题不是单一来源，而是三种模式综合扫描，最终推荐 3-5 个选题。

### 模式 1：热点速报（默认）

扫描当日新闻 + 热搜验证，找有流量基础的话题。

**搜索策略：**
- WebSearch 搜索「微博热搜」「知乎热榜」「百度热搜」等关键词 + 当天日期
- 搜索与用户领域相关的当日新闻（如「AI 最新进展」「教育政策」）
- 每个来源提取 3-5 个相关话题，不需要面面俱到

**国际新闻源：**

国际新闻的时效性通常优于国内转载，适合抢先发现选题。通过连通性缓存决定访问方式。

科技类（推荐，更新快、与公众号受众重合度高）：
- TechCrunch (techcrunch.com) — 硅谷科技创业新闻
- The Verge (theverge.com) — 消费科技、产品评测
- Wired (wired.com) — 科技趋势、深度报道
- Ars Technica (arstechnica.com) — 技术深度分析

商业/财经类：
- Forbes (forbes.com) — 商业、创业、财富
- Fortune (fortune.com) — 商业、科技、管理
- CNBC (cnbc.com) — 金融市场、商业
- Business Insider (businessinsider.com) — 商业、科技

综合新闻类：
- AP News (apnews.com) — 美联社，全球新闻
- CNN (cnn.com) — 全球综合新闻
- DW (dw.com) — 德国之声，欧洲视角
- Straits Times (straitstimes.com) — 新加坡，东南亚视角

**搜索技巧：**
- 用 WebSearch 搜索 `site:techcrunch.com AI` 等限定域名
- 搜索英文关键词，结果更新更快
- 找到国际热点后，搜索国内是否有相关讨论，判断信息差价值

**时效性要求：** 只选最近 3-7 天内的新闻，超过一周的不选。国际新闻的价值在于"国内还没人写"，时间一长就被转载烂了。搜索时加上时间限定（如 `after:2026-06-01`）。

**筛选标准：**
- 能否结合用户专业领域给出独特见解？
- 热点生命周期是否足够长（>3天）？
- 是否有争议性或讨论空间？

### 模式 2：深度选题

从原始信源提前发现线索，找"没人讲透"的角度。比新闻快一步，信息差更大。

**默认信源：**

| 信源 | 类型 | URL |
|------|------|-----|
| GitHub Trending | 开源项目热度 | `github.com/trending` |
| Hacker News | 技术社区讨论 | `news.ycombinator.com` |
| Product Hunt | 新产品发布 | `producthunt.com` |
| TradingView | 金融市场趋势 | `tradingview.com` |
| X (Twitter) trending | 全球热点话题 | `x.com/explore` |
| Financial Times | 全球商业、金融 | `ft.com` |
| CNBC | 金融市场、商业 | `cnbc.com` |

每个信源都通过连通性缓存决定访问方式（direct / proxy / websearch）。

**用户自定义信源：**

用户可以在 `config/wxmp.json` 的 `topic_sources` 字段配置自己关注的领域和信源。配置后优先使用用户指定的信源。

**国内信源（补充）：**

| 信源 | 类型 | 访问方式 |
|------|------|---------|
| 掘金 (juejin.cn) | 技术社区 | WebSearch「掘金 热榜」 |
| V2EX (v2ex.com) | 技术/创业讨论 | WebSearch「V2EX 热门话题」 |
| 少数派 (sspai.com) | 效率工具/数字生活 | WebSearch「少数派 最新文章」 |
| 36氪 (36kr.com) | 科技创业新闻 | WebSearch「36氪 热榜」 |
| InfoQ (infoq.cn) | 技术深度文章 | WebSearch「InfoQ 最新」 |
| 虎嗅 (huxiu.com) | 商业科技评论 | WebSearch「虎嗅 热文」 |

**Reddit（可选，需配置 rdt-cli）：**

当 `topic_sources.custom` 中包含 Reddit 时才使用。通过连通性缓存决定访问方式：

- `direct` / `proxy`：用 `rdt` 命令直接抓取（见下方命令速查）
- `websearch`：用 WebSearch 搜索「Reddit r/technology today」间接获取

默认 subreddit：`r/technology`、`r/worldnews`。用户可在配置中调整。

**rdt-cli 命令速查：**

```bash
# 检查登录状态
rdt status

# 浏览 subreddit（选题用）
rdt sub technology -s hot -n 10 --compact
rdt sub technology -s top -t week -n 10 --compact    # 本周热门

# 搜索（关键词选题用）
rdt search "AI writing" -r technology -s top -t month -n 10 --compact
rdt search "rust vs go" -s hot -n 5 --compact

# 读帖子详情（感兴趣的话题深入看）
rdt read <post_id> -n 20    # post_id 从 sub/search 输出中获取

# 导出结果（批量处理）
rdt export "machine learning" -r technology -n 50 -o /tmp/reddit.csv
```

**关键参数：**
- `--compact` / `-c`：精简输出，agent 友好（选题时必加）
- `--json`：输出 JSON 格式（需要结构化数据时用）
- `-n` / `--limit`：结果数量
- `-s` / `--sort`：排序方式（hot / new / top / rising）
- `-t` / `--time`：时间范围（hour / day / week / month / year / all）
- `-r` / `--subreddit`：限定 subreddit（search 命令用）

**常见报错处理：**
- `Not logged in` → 提示用户在 Chrome 登录 Reddit，然后 `rdt login`
- `Rate limited` → 等 30 秒重试，或切换 websearch 方式
- `Subreddit not found` → 检查 subreddit 名称拼写

**搜索策略：**
1. 用连通性缓存访问各信源，提取当前热门话题
2. 与国内新闻对比——如果国内还没有报道，信息差价值高
3. 评估话题的深度空间：能否写 2000+ 字？能否给出独特分析？

**筛选标准：**
- 信息差：国内是否已有大量报道？
- 深度空间：能否写成有深度的长文？
- 受众匹配：目标读者是否关心这个话题？

### 模式 3：预判选题

基于确定性事件提前准备内容，事件发生当天即可发布。

**周期性事件类别：**

| 类别 | 示例 | 提前时间 |
|------|------|---------|
| 科技大会 | WWDC、Google I/O、CES、MWC | 1-2 周 |
| 财报季 | 苹果/微软/谷歌财报 | 3-5 天 |
| 政策发布 | 央行利率决议、行业新规 | 1-3 天 |
| 新品上市 | iPhone、特斯拉新车、游戏大作 | 1-2 周 |
| 行业节日 | 双11、618、黑五 | 1-2 周 |

**搜索策略：**
1. WebSearch 搜索「{行业} 近期大事件」「{公司} 发布会」
2. 查看日历推算周期性事件（如财报季、大会时间）
3. 在信源中发现趋势信号（如 GitHub 上某个项目突然爆火）

**筛选标准：**
- 事件确定性：时间/内容是否已确认？
- 受众关注度：目标读者是否在意这个事件？
- 提前准备时间：是否有足够时间写稿？

## 竞品分析（补充手段）

用户提供了竞品公众号名称时：
- 搜索「{竞品名称} 公众号 最近文章」或「{竞品名称} site:mp.weixin.qq.com」
- 分析其近期选题方向、标题风格、内容结构
- 找到可借鉴的选题角度（借鉴思路，不抄袭内容）

## 用户互动分析（补充手段）

用户提供了近期留言或私信内容时：
- 提取高频关键词和话题
- 识别用户最关心的问题
- 发现未被充分解答的需求
- 这类选题往往转化率最高，因为直接回应了读者的真实需求

## 选题评估标准

好的选题通常满足以下条件中的 2-3 个：

| 维度 | 说明 |
|------|------|
| 读者痛点 | 能解决读者的实际问题 |
| 时效性 | 结合当下热点或趋势 |
| 专业性 | 能体现作者的专业深度 |
| 争议性 | 有讨论空间，容易引发互动 |
| 实操性 | 读者看完能直接行动 |
| 信息差 | 国内还没人写过 / 写透 |

## 综合推荐

三种模式的结果汇总后，去重、排序，输出最终推荐：

```
📋 选题建议（共 N 个）

1. 《标题建议》
   - 来源路线：热点速报 / 深度选题 / 预判选题
   - 信息源：具体来源（如 TechCrunch、掘金热榜）
   - 角度：切入角度说明
   - 理由：为什么这个选题值得写
   - 评估：符合哪些选题标准

2. ...

💡 推荐排序：信息差 > 时效性 > 受众匹配度
```

请用户选择 1 个选题进入撰写阶段。如果用户对建议不满意，可以根据反馈调整方向重新生成。

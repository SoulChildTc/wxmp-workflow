# Skill 设计原则

本文档整理了 Agent Skill 设计的权威原则，作为本项目优化的依据和未来维护的参考。

## 信息来源

- [agentskills.io](https://agentskills.io/specification) — 官方格式规范
- [Anthropic Skill 最佳实践](https://docs.anthropic.com/en/docs/agents-and-tools/agent-skills/overview) — Anthropic 官方文档
- skill-creator / writing-skills — 社区实践总结

---

## 核心原则

### 1. 渐进式加载（Progressive Disclosure）

Skill 分三层加载，每层按需进入上下文：

```
Level 1: 元数据（name + description）  → 始终在上下文中（~100 tokens）
Level 2: SKILL.md 正文                → 触发时加载（<5000 tokens）
Level 3: 资源（scripts/references/）   → 按需加载
```

这意味着：
- SKILL.md 必须保持精简，只包含核心流程和路由
- 详细内容放在 references/，AI 在执行对应步骤时才读取
- 不要把多个步骤的内容塞进一个文件

### 2. Self-Contained（自包含）

每个 reference 文件独立可读。AI 在执行某个步骤时只读对应文件。

**判断标准：** 一个文件只做一件事。如果它包含了 AI 在不同阶段才需要的信息，就应该拆分。

### 3. 引用文件一层深度

所有 reference 文件由 SKILL.md 直接引用。reference 文件之间不应互相引用。

```
✅ 正确：
SKILL.md → references/foo.md (一级)
SKILL.md → references/bar.md (一级)

❌ 错误：
SKILL.md → references/foo.md
           references/foo.md → references/bar.md (二级)
```

嵌套引用会导致 Claude 用 `head -100` 预览子文件，错过关键内容。

### 4. 超过 100 行的 reference 文件必须有目录

Claude 读取长文件时可能只预览开头。目录让它在预览时就能看到文件的完整范围，然后跳到需要的章节。

## SKILL.md Frontmatter

### 必要字段

```yaml
---
name: skill-name
description: A description of what this skill does and when to use it.
---
```

| 字段 | 要求 |
|------|------|
| `name` | 1-64 字符，仅小写字母、数字、连字符 |
| `description` | 1-1024 字符，第三人称，写场景和触发条件 |

### 可选但推荐

```yaml
---
name: wxmp-workflow
description: 微信公众号全流程工作流...
preamble-tier: 4
version: 1.0.0
triggers:
  - 公众号
  - 写文章
allowed-tools:
  - Bash
  - WebSearch
---
```

- `allowed-tools`：限定 AI 在执行 skill 时可用的工具
- `triggers`：关键词列表，辅助 agent 判断是否触发
- `preamble-tier`：优先级层级

### Description 编写原则

1. **写触发条件，不写工作流。** Description 告诉 AI "什么时候用"，不是"怎么用"。总结工作流的 description 会导致 AI 跳过 SKILL.md 正文。
2. **第三人称。** Description 会被注入 system prompt，第一人称会造成混淆。
3. **包含关键词。** AI 使用 description 做技能选择的唯一依据。关键词越全，匹配越准。

```
❌ 总结了工作流：Use when executing plans - dispatches subagent per task
❌ 第一人称：I can help you write WeChat articles
✅ 纯触发条件：微信公众号内容创作。Use when user mentions writing articles, WeChat Official Account, or content publishing
```

## Directory Structure

```
skill-name/
├── SKILL.md              # 必需：元数据 + 核心指令
├── scripts/              # 可选：可执行脚本
├── references/           # 可选：按需加载的详细文档
├── assets/               # 可选：模板、资源
└── ...                   # 其他文件
```

### 什么时候文件放哪里

| 放在 SKILL.md 正文 | 放在 references/ | 放在 scripts/ |
|---|---|---|
| 核心流程、意图路由 | 详细步骤指引 | 可执行工具 |
| <500 行的内容 | 用于渐进加载 | 确定性操作 |
| 跨步骤共享的规则 | 按领域/步骤组织 | 避免 AI 自己写代码 |

## 关于简洁

### 默认假设：AI 已经足够聪明

每句话问自己：
- "AI 真的需要这个解释吗？"
- "我能假设 AI 已经知道这个吗？"
- "这段话值得它的 token 成本吗？"

### 自由度匹配

| 场景 | 自由度 | 写法 |
|------|--------|------|
| 多条路都能走通 | 高 | 给方向，让 AI 自己选 |
| 有推荐模式但可以灵活 | 中 | 给模板+示例 |
| 操作脆弱、顺序严格 | 低 | 精确指令，禁止变通 |

## 常见反模式

| 反模式 | 问题 | 正确做法 |
|--------|------|---------|
| 一个文件塞多步 | AI 加载了当前不需要的上下文 | 按步骤/领域拆文件 |
| 引用文件没有目录 | Claude 预览时错过关键内容 | 超过 100 行加目录 |
| reference 互相引用 | 嵌套导致部分读取 | 所有引用从 SKILL.md 出发 |
| description 总结工作流 | AI 跳过 SKILL.md 正文 | description 只写触发条件 |
| 过度解释基础概念 | 浪费 token，稀释关键指令 | 假设 AI 已具备常识 |
| 文件名含义模糊 | AI 不知道什么时候该读 | 文件名体现内容（`wxmp-writing.md` ✅） |

## 检查清单

### Core quality
- [ ] Description 是第三人称，写触发条件不写工作流
- [ ] SKILL.md 正文 <500 行
- [ ] 长引用文件（>100行）有目录
- [ ] 引用文件只从 SKILL.md 出发，不互相嵌套
- [ ] 每个 reference 文件 self-contained（独立读取）
- [ ] 没有基础概念的过度解释
- [ ] 一致的术语和命名

### Code and scripts
- [ ] 脚本自行处理错误，不留给 AI
- [ ] 不假设工具已安装，给出安装命令
- [ ] 没有魔数（所有常量有解释）
- [ ] 无 Windows 风格路径
- [ ] 关键操作有验证/反馈循环

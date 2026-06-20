# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A Claude Code skill for WeChat Official Account (微信公众号) content creation workflow. It covers the full lifecycle: topic discovery (three-mode scanning) → research → writing → polishing → formatting → publishing → post-publish review.

This is **not** a traditional codebase with build/test commands. It's a skill definition that instructs AI agents how to help users create and publish WeChat articles.

## Architecture

**SKILL.md** is the entry point. It defines:
- Frontmatter metadata (name, description, triggers, allowed-tools)
- Intent routing (what to do based on user input)
- Two execution modes: 全自动 (unattended) vs 半自动 (interactive with confirmation checkpoints)
- The 10-step workflow overview with pointers to reference docs
- De-AI-flavor checking (4-round scan: feature words, structure, style, human touch)

**references/** contains detailed instructions for each workflow phase. SKILL.md points here when the agent needs specifics. Files use `wxmp-` prefix to avoid naming conflicts. The topic discovery phase (`wxmp-inspiration.md`) uses three discovery modes: 热点速报 (daily news + hot search), 深度选题 (original sources like GitHub/HN for information gaps), 预判选题 (calendar events). A connectivity cache (`config/connectivity.json`) auto-detects the best access method for each source (direct/proxy/websearch). Reddit is an optional source via `rdt-cli`. Writing follows Chinese copywriting guidelines (`references/chinese-copywriting-guidelines.md`) for typography (pangu spacing, full-width punctuation, etc.) and a mobile-first layout spec (`references/wxmp-typography.md`) for font sizes, spacing, colors, visual rhythm, opening strategies, and component patterns. The polishing phase (`wxmp-writing.md`) includes a mandatory de-AI-flavor step — uses [Humanizer](https://github.com/blader/humanizer) + [StopSlop](https://github.com/hardikpandya/stop-slop) if installed, otherwise falls back to built-in 4-round scan (feature words, structure, style, human touch) in `wxmp-tools.md`. The setup guide (`wxmp-setup.md`) walks users through configuring WeChat API, StopSlop, Agnes AI, and optional Reddit.

**scripts/** are shell scripts (curl + jq) for API interaction. All read config from `config/wxmp.json`. Key scripts:
- `wx-auth.sh` — token management with 2-hour cache in `/tmp/wxmp-token.json`
- `wx-upload-image.sh` — upload images to WeChat material system
- `wx-draft.sh` — create or update draft articles (use `--media-id` to update existing draft)
- `wx-preview.sh` — send draft preview to a WeChat user (requires mass message permission)
- `wx-publish.sh` — publish with async status polling
- `wx-stats.sh` — daily summary stats (API limit: 1-day max per query, script auto-loops)
- `wx-articles.sh` — list published articles
- `wx-article-stats.sh` — per-article detailed stats (7-day max range)
- `wx-generate-image.sh` — Agnes AI image generation (文生图)
- `wx-generate-image-sensenova.sh` — SenseNova U1 Fast image generation (信息图, Agnes fallback)

**templates/** contains 5 beautiful HTML templates with inline styles:
- `minimal-white.html` — clean, lots of whitespace (tutorials, guides)
- `magazine.html` — elegant, editorial style with serif fonts (deep articles, opinions)
- `dark-mode.html` — code-style fonts, gradient lines, tech feel (tech, programming)
- `card-style.html` — modular cards, easy to scan (lists, roundups)
- `gradient.html` — gradient line decorations, youthful (lifestyle, stories)

Templates are designed for WeChat dark/light mode compatibility: no background colors, neutral text colors (#3f3f3f/#666/#999), no author/date duplication.

## Key Constraints

- **One conversation, one article** — first `wx-draft.sh` call creates a draft and returns `media_id`; all subsequent operations (update, publish) reuse that same `media_id`. Refuse if the user tries to start a second article in the same conversation.
- WeChat HTML content must use **inline styles only** — no `<link>`, `<style>`, `<script>`, `<iframe>`
- Images must be uploaded to WeChat's material system first (via `wx-upload-image.sh`), then referenced by CDN URL
- `access_token` expires every 2 hours; `wx-auth.sh` caches it in `/tmp/wxmp-token.json`
- Publishing is async — `wx-publish.sh` polls status until complete
- Daily publish limits: subscription accounts (订阅号) 1/day, service accounts (服务号) 4/day
- Stats APIs have time span limits: `getarticlesummary` max 1 day, `getarticletotal` max 7 days
- Stats data has ~1 day delay (can't query today's data until tomorrow)

## Configuration

```bash
cp config/wxmp.example.json config/wxmp.json  # then fill in AppID + Secret + Agnes API Key
```

Config file lookup order (first match wins):
1. `{current_project}/config/wxmp.json` — user's project directory
2. `{skill_dir}/config/wxmp.json` — skill installation directory (auto-detected via script location)

The config file contains secrets and is gitignored. Key fields:
- `appid` / `secret` — WeChat Official Account API credentials
- `author` — article author name, auto-filled when creating drafts (optional)
- `default_comment` — enable comments (1) or disable (0), default 1
- `default_fans_only_comment` — fans-only commenting (1) or open (0), default 0
- `agnes_api_key` — Agnes AI API key for image generation (optional)
- `proxy` — proxy config object with `http` and `https` fields (e.g. `{"http":"http://127.0.0.1:7890","https":"http://127.0.0.1:7890"}`); empty strings mean no proxy (optional)
- `topic_sources` — user-configured original sources for deep topic discovery (optional, has defaults)

## Modifying the Skill

When editing SKILL.md or reference files:
- Keep SKILL.md under 500 lines; detailed content goes in references/
- Follow the existing frontmatter format (preamble-tier, version, description, triggers, allowed-tools)
- Reference files should be self-contained — the agent reads them independently
- Use imperative form in instructions, explain the "why" not just the "what"

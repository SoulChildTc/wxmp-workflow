#!/usr/bin/env bash
# wx-generate-image-sensenova.sh — 使用 SenseNova 生成图片
# 支持模型：U1.5 Lite (默认) / U1 Fast (信息图)
#
# 用法:
#   bash scripts/wx-generate-image-sensenova.sh --prompt "提示词"
#   bash scripts/wx-generate-image-sensenova.sh --prompt "提示词" --model sensenova-u1-fast
#   bash scripts/wx-generate-image-sensenova.sh --prompt "提示词" --size 2720x1536
#   bash scripts/wx-generate-image-sensenova.sh --prompt "提示词" --output /path/to/output.png
#
# 参数:
#   --prompt   图片生成提示词（必填），最大 4096 token
#   --model    模型 ID（可选），默认从 config 读取或 sensenova-u1.5-lite
#   --size     输出尺寸（可选），默认根据模型自动选择
#   --output   输出文件路径，默认 output/sensenova-{timestamp}.png（可选）
#
# U1.5 Lite 可用尺寸（2K/4K，宽高须为 32 的倍数，512-4096，比例 ≤ 3:1）:
#   2720x1536 (16:9 2K)  | 1536x2720 (9:16 2K)    [默认]
#   2496x1664 (3:2 2K)   | 1664x2496 (2:3 2K)
#   2048x2048 (1:1 2K)   | 4096x4096 (1:1 4K)
#   自定义尺寸也支持，只要满足 32 倍数 + 512-4096 + 比例 ≤ 3:1
#
# U1 Fast 可用尺寸（仅 2K，11 种固定比例）:
#   2752x1536 (16:9)     | 1536x2752 (9:16)
#   2496x1664 (3:2)      | 1664x2496 (2:3)
#   2368x1760 (4:3)      | 1760x2368 (3:4)
#   2272x1824 (5:4)      | 1824x2272 (4:5)
#   2048x2048 (1:1)
#   3072x1376 (21:9)     | 1344x3136 (9:21)
#
# 配置: 需要在 config/wxmp.json 中配置 sensenova_api_key
#       可选配置 sensenova_model（模型 ID）和 sensenova_prompt_extend（提示词自动润色）
#
# 输出: 图片文件路径（stdout）

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# 配置文件查找：当前目录优先，skill 目录兜底
if [ -f "$PWD/config/wxmp.json" ]; then
  CONFIG_FILE="$PWD/config/wxmp.json"
else
  CONFIG_FILE="$PROJECT_DIR/config/wxmp.json"
fi

# 解析参数
PROMPT=""
SIZE=""
OUTPUT=""
MODEL=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --prompt)  PROMPT="$2"; shift 2 ;;
    --model)   MODEL="$2"; shift 2 ;;
    --size)    SIZE="$2"; shift 2 ;;
    --output)  OUTPUT="$2"; shift 2 ;;
    *)
      echo "未知参数: $1" >&2
      exit 1
      ;;
  esac
done

# 验证必填参数
if [ -z "$PROMPT" ]; then
  echo "❌ 缺少必填参数: --prompt" >&2
  echo "用法: bash scripts/wx-generate-image-sensenova.sh --prompt \"图片描述\"" >&2
  exit 1
fi

# 读取配置
if [ ! -f "$CONFIG_FILE" ]; then
  echo "❌ 配置文件不存在: $CONFIG_FILE" >&2
  exit 1
fi

API_KEY=$(jq -r '.sensenova_api_key // empty' "$CONFIG_FILE")
if [ -z "$API_KEY" ]; then
  echo "❌ 未配置 SenseNova API Key" >&2
  echo "请在 config/wxmp.json 中添加 sensenova_api_key 字段" >&2
  echo "获取方式: https://sensenova.cn" >&2
  exit 1
fi

# 解析模型：CLI 参数 > 配置文件 > 默认值
if [ -z "$MODEL" ]; then
  MODEL=$(jq -r '.sensenova_model // "sensenova-u1.5-lite"' "$CONFIG_FILE")
fi

# 读取 prompt_extend 配置（仅 U1.5 Lite 支持）
PROMPT_EXTEND=$(jq -r '.sensenova_prompt_extend // false' "$CONFIG_FILE")

# 根据模型设置默认尺寸
if [ -z "$SIZE" ]; then
  case "$MODEL" in
    sensenova-u1-fast) SIZE="2752x1536" ;;
    *)                 SIZE="2720x1536" ;;
  esac
fi

# 设置默认输出路径
if [ -z "$OUTPUT" ]; then
  TIMESTAMP=$(date +%Y%m%d%H%M%S)
  OUTPUT="$PROJECT_DIR/output/sensenova-${TIMESTAMP}.png"
fi

# 确保输出目录存在
mkdir -p "$(dirname "$OUTPUT")"

echo "🎨 正在生成图片 (SenseNova $MODEL)..." >&2
echo "   提示词: $PROMPT" >&2
echo "   尺寸: $SIZE" >&2

# 根据模型构建请求体
if [ "$MODEL" = "sensenova-u1.5-lite" ]; then
  REQUEST_BODY=$(jq -n \
    --arg model "$MODEL" \
    --arg prompt "$PROMPT" \
    --arg size "$SIZE" \
    --argjson prompt_extend "$PROMPT_EXTEND" \
    '{
      model: $model,
      prompt: $prompt,
      size: $size,
      n: 1,
      watermark: false,
      prompt_extend: $prompt_extend,
      output_format: "png",
      response_format: "url"
    }')
else
  REQUEST_BODY=$(jq -n \
    --arg model "$MODEL" \
    --arg prompt "$PROMPT" \
    --arg size "$SIZE" \
    '{
      model: $model,
      prompt: $prompt,
      size: $size,
      n: 1,
      watermark: false
    }')
fi

# 调用 SenseNova API
RESPONSE=$(curl -s \
  --max-time 180 \
  -X POST \
  "https://token.sensenova.cn/v1/images/generations" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d "$REQUEST_BODY")

if [ -z "$RESPONSE" ]; then
  echo "❌ 生成失败: 服务器无响应" >&2
  exit 1
fi

# 检查错误
if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
  ERROR_MSG=$(echo "$RESPONSE" | jq -r '.error.message // .error // "unknown error"')
  echo "❌ 生成失败: $ERROR_MSG" >&2
  exit 1
fi

# 提取图片 URL
IMAGE_URL=$(echo "$RESPONSE" | jq -r '.data[0].url // empty')
if [ -z "$IMAGE_URL" ]; then
  echo "❌ 响应中未包含图片 URL" >&2
  echo "$RESPONSE" >&2
  exit 1
fi

# 下载图片
echo "📥 下载图片..." >&2
curl -s -o "$OUTPUT" "$IMAGE_URL"

if [ ! -f "$OUTPUT" ]; then
  echo "❌ 图片下载失败" >&2
  exit 1
fi

FILE_SIZE=$(wc -c < "$OUTPUT" | tr -d ' ')
echo "✅ 图片已生成: $OUTPUT (${FILE_SIZE} bytes)" >&2

echo "$OUTPUT"

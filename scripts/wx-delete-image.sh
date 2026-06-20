#!/usr/bin/env bash
# wx-delete-image.sh — 从微信素材库删除图片
# 用法: bash scripts/wx-delete-image.sh <media_id>
# 输出: 删除结果

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MEDIA_ID="${1:-}"

if [ -z "$MEDIA_ID" ]; then
  echo "用法: bash scripts/wx-delete-image.sh <media_id>" >&2
  exit 1
fi

ACCESS_TOKEN=$(bash "$SCRIPT_DIR/wx-auth.sh")

RESPONSE=$(curl -s -X POST \
  "https://api.weixin.qq.com/cgi-bin/material/del_material?access_token=${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{\"media_id\": \"${MEDIA_ID}\"}")

ERRCODE=$(echo "$RESPONSE" | jq -r '.errcode // empty')
ERRMSG=$(echo "$RESPONSE" | jq -r '.errmsg // "unknown error"')

if [ "$ERRCODE" = "0" ]; then
  echo "✅ 已删除素材: $MEDIA_ID" >&2
else
  echo "❌ 删除失败: [$ERRCODE] $ERRMSG" >&2
  exit 1
fi

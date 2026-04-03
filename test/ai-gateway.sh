#!/usr/bin/env bash
#
# Verify LLM gateway routes. Run from host with gateway stack up.
# Usage: ./test/ai-gateway.sh [model]

source $(readlink -f $(dirname $0))/../.env 2>/dev/null

MODEL="${1:-claude-haiku-4-5}"
GATEWAY_PORT="${GATEWAY_PROXY_PORT:-4000}"
OAUTH_PORT="${GATEWAY_OAUTH_PORT:-8317}"
XNDV_HOSTNAME="${XNDV_HOSTNAME:-localhost}"
GATEWAY_URL="http://${XNDV_HOSTNAME}:${GATEWAY_PORT}"
OAUTH_URL="http://${XNDV_HOSTNAME}:${OAUTH_PORT}"
PAYLOAD="$(jq -n --arg model "$MODEL" '{model: $model, max_tokens: 64, messages: [{role: "user", content: "Reply with exactly: ok"}]}')"

echo "=== Gateway Health ==="
curl -sf "${GATEWAY_URL}/health" | jq . || echo "FAIL: gateway not reachable at ${GATEWAY_URL}"
echo ""

echo "=== API Route (Anthropic format) ==="
curl -s "${GATEWAY_URL}/v1/messages" \
  -H "x-api-key: $GATEWAY_MASTER_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d "$PAYLOAD" | jq .
echo ""

echo "=== OAuth Proxy Health ==="
if curl -sf "${OAUTH_URL}/" >/dev/null 2>&1; then
  echo "OK"

  echo ""
  echo "=== OAuth Proxy Models ==="
  curl -s "${OAUTH_URL}/v1/models" \
    -H "Authorization: Bearer sk-cliproxy" | jq .
  echo ""

  echo "=== OAuth Route (via LiteLLM) ==="
  curl -s "${GATEWAY_URL}/v1/chat/completions" \
    -H "Authorization: Bearer $GATEWAY_MASTER_KEY" \
    -H "content-type: application/json" \
    -d "$PAYLOAD" | jq .
else
  echo "SKIP: CLIProxyAPI not reachable at ${OAUTH_URL}"
fi

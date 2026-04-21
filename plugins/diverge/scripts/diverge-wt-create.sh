#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../monitor/emit.sh" 2>/dev/null || true
BRANCH="${1:?branch name is required as the first positional arg}"
# BASE_BRANCH comes from the environment (exported by the launcher). See
# diverge-consolidate.sh for rationale: positional branch args get guessed-at
# by the LLM when reconstructing the bash call.
: "${BASE_BRANCH:?BASE_BRANCH env var is required; it is exported by the launcher — do not call this script outside a launched diverge session}"
wt switch --create "$BRANCH" --base "$BASE_BRANCH" --no-cd
WT_PATH=$(wt list --format=json | jq -r --arg b "$BRANCH" \
  '.[] | select(.branch == $b) | .path')
if [[ -z "$WT_PATH" || ! -d "$WT_PATH" ]]; then
  echo "diverge-wt-create: could not resolve path for branch $BRANCH" >&2
  exit 1
fi
diverge_emit script wt_create "{\"branch\":\"$BRANCH\",\"base\":\"$BASE_BRANCH\",\"path\":\"$WT_PATH\"}" || true
echo "$WT_PATH"

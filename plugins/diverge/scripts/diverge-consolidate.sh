#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../monitor/emit.sh" 2>/dev/null || true
# BASE_BRANCH is exported by the launcher (generate-launcher.sh). This script
# reads it from the environment rather than a positional arg — when prompted
# LLMs reconstruct the bash call, they sometimes substitute a plausible-looking
# default like "main" for ${BASE_BRANCH} and quietly consolidate against the
# wrong branch.
: "${BASE_BRANCH:?BASE_BRANCH env var is required; it is exported by the launcher — do not call this script outside a launched diverge session}"
MERGE_BASE=$(git merge-base HEAD "$BASE_BRANCH")
if [[ -z "$MERGE_BASE" ]]; then
  echo "diverge-consolidate: could not find merge-base with $BASE_BRANCH" >&2
  exit 1
fi
git reset --soft "$MERGE_BASE"
diverge_emit script consolidate "{\"mergeBase\":\"$MERGE_BASE\",\"baseBranch\":\"$BASE_BRANCH\"}" || true
echo "diverge-consolidate: all commits since $MERGE_BASE (base: $BASE_BRANCH) soft-reset to staged state"

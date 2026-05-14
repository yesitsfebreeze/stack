#!/usr/bin/env bash
# Stack update - POSIX (macOS, Linux, Git Bash on Windows).
# Idempotent. Safe to re-run.

set -uo pipefail

MARKETPLACE="stack"
PLUGINS=(stack git-fs vicky context7 pdf-reader caveman context-mode)

echo "==> Stack update"

if ! command -v claude >/dev/null 2>&1; then
  echo "ERROR: 'claude' CLI not on PATH. Install Claude Code first." >&2
  exit 1
fi

echo "==> Refresh marketplace ${MARKETPLACE}"
claude plugin marketplace update "${MARKETPLACE}" || echo "  (marketplace refresh failed, continuing)"

for p in "${PLUGINS[@]}"; do
  echo "==> Update ${p}@stack"
  claude plugin update "${p}@stack" || echo "  (update failed or not installed, continuing)"
done

echo ""
echo "==> Done. Restart Claude Code to apply. Then /stack:doctor to verify."

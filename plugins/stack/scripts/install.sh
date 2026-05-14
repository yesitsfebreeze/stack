#!/usr/bin/env bash
# Stack bootstrap - POSIX (macOS, Linux, Git Bash on Windows).
# Idempotent. Safe to re-run.

set -euo pipefail

MARKETPLACE="yesitsfebreeze/stack"
PLUGINS=(stack git-fs vicky context7 caveman context-mode)

echo "==> Stack bootstrap"

if ! command -v claude >/dev/null 2>&1; then
  echo "ERROR: 'claude' CLI not on PATH. Install Claude Code first." >&2
  exit 1
fi

echo "==> Add marketplace ${MARKETPLACE}"
claude plugin marketplace add "${MARKETPLACE}" || true

for p in "${PLUGINS[@]}"; do
  echo "==> Install ${p}@stack"
  claude plugin install "${p}@stack" || echo "  (already installed or failed, continuing)"
done

echo "==> Create .stack marker in $(pwd)"
if [ ! -f .stack ]; then
  touch .stack
  echo "  .stack created"
else
  echo "  .stack already present"
fi

if [ -z "${CONTEXT7_API_KEY:-}" ]; then
  echo ""
  echo "WARN: CONTEXT7_API_KEY not set. context7 MCP will fail auth."
  echo "      Get key from https://context7.com/dashboard, then:"
  echo "        export CONTEXT7_API_KEY=ctx7sk-..."
fi

echo ""
echo "==> Done. Run /stack:doctor to verify."

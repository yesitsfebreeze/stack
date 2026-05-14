---
description: One-shot install for the full stack. Detects OS, runs the matching script, creates the .stack marker, reports CONTEXT7_API_KEY status.
---

Run the platform-appropriate bootstrap script from this plugin via Bash. The script is idempotent — safe to re-run.

## Steps

1. Detect OS. On Windows: run `${CLAUDE_PLUGIN_ROOT}/scripts/install.ps1` via `powershell -ExecutionPolicy Bypass -File`. On macOS/Linux: run `bash ${CLAUDE_PLUGIN_ROOT}/scripts/install.sh`.

2. The script will:
   - `claude plugin marketplace add yesitsfebreeze/stack`
   - `claude plugin install` each of: `stack`, `git-fs`, `vicky`, `context7`, `caveman`, `context-mode`
   - `touch .stack` in cwd (opt-in marker for routing hooks)
   - Warn if `CONTEXT7_API_KEY` is unset

3. After it completes, invoke `/stack-doctor` to verify all MCPs connect.

## If the script fails

- `'claude' CLI not on PATH` → install Claude Code first.
- A specific plugin install fails → re-run; script tolerates already-installed entries.
- `context7` MCP shows `failed` → `CONTEXT7_API_KEY` missing. Export it and restart the session.

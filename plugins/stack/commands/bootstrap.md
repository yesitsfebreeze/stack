---
description: One-shot install for the full stack. Detects OS, runs the matching script, creates the .stack marker, reports CONTEXT7_API_KEY status.
---

Run the platform-appropriate bootstrap script from this plugin via Bash. The script is idempotent — safe to re-run.

## Steps

1. Detect OS. On Windows: prefer `pwsh` (PowerShell 7, UTF-8 default) — `pwsh -ExecutionPolicy Bypass -File "${CLAUDE_PLUGIN_ROOT}/scripts/install.ps1"`. Fall back to `powershell` only if `pwsh` is not on PATH (Windows PowerShell 5.1 mangles non-ASCII; scripts are ASCII-only as defense). On macOS/Linux: `bash "${CLAUDE_PLUGIN_ROOT}/scripts/install.sh"`.

2. The script will:
   - `claude plugin marketplace add yesitsfebreeze/stack`
   - `claude plugin install` each of: `stack`, `git-fs`, `vicky`, `context7`, `pdf-reader`, `caveman`, `context-mode`
   - `touch .stack` in cwd (opt-in marker for routing hooks)
   - Warn if `CONTEXT7_API_KEY` is unset. Tell user to grab a key at **https://context7.com/dashboard** and set the env var (Windows: `setx CONTEXT7_API_KEY "<key>"`; macOS/Linux: add `export CONTEXT7_API_KEY=<key>` to shell rc), then restart the session.
   - Warn if `npx` is not on PATH (required for `pdf-reader`). Install Node.js (>=18) from https://nodejs.org.

3. After it completes, invoke `/stack:doctor` to verify all MCPs connect.

## If the script fails

- `'claude' CLI not on PATH` → install Claude Code first.
- A specific plugin install fails → re-run; script tolerates already-installed entries.
- `context7` MCP shows `failed` → `CONTEXT7_API_KEY` missing. Get one at https://context7.com/dashboard, export it, and restart the session.
- `pdf-reader` MCP shows `failed` → `npx` missing or first-run npm download blocked. Install Node.js, then re-run.

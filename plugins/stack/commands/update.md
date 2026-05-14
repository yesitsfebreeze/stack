---
description: Refresh the stack marketplace and update every sub-plugin (stack, git-fs, vicky, context7, caveman, context-mode). Restart required to apply.
---

Run the platform-appropriate update script from this plugin via Bash. Idempotent — safe to re-run.

## Steps

1. Detect OS. On Windows: prefer `pwsh` — `pwsh -ExecutionPolicy Bypass -File "${CLAUDE_PLUGIN_ROOT}/scripts/update.ps1"`. Fall back to `powershell` only if `pwsh` is not on PATH. On macOS/Linux: `bash "${CLAUDE_PLUGIN_ROOT}/scripts/update.sh"`.

2. The script will:
   - `claude plugin marketplace update stack`
   - `claude plugin update <name>@stack` for each of: `stack`, `git-fs`, `vicky`, `context7`, `caveman`, `context-mode`
   - Continue on individual failures (missing plugin, network blip) instead of aborting

3. Tell user: **restart Claude Code** for new versions to load. Then `/stack:doctor` to verify MCPs reconnect.

## If the script fails

- `'claude' CLI not on PATH` → install Claude Code first.
- A specific plugin update fails → re-run; transient. If it persists, that plugin may not be installed — run `/stack:bootstrap` first.
- Marketplace refresh fails → check network; the marketplace ref is `yesitsfebreeze/stack`.

# stack

Token-efficient workflow stack for Claude Code. One marketplace, one install command, one routing hook.

## What it does

Bundles the MCP servers and skills that route work cheaply:

| Plugin | Job |
|---|---|
| `stack` | Hub. Ships routing/setup/maintenance skills, `SessionStart` + `PreToolUse` hooks, `/stack:doctor`, `/stack:bootstrap`. |
| `git-fs` | Per-session virtual filesystem. Branch isolation, auto-merge on stop. |
| `vicky` | Persistent research KB. Survives sessions, links findings. |
| `context7` | Versioned library/SDK/framework docs over HTTP. |
| `caveman` | (external) Ultra-compressed communication mode. |
| `context-mode` | (external) Sandbox raw tool output, FTS5 search. |

Sub-plugins ship their own `.mcp.json` — no manual `~/.claude.json` edits.

### Routing hook (the point)

Drop `.stack` (empty file) in any project root. From then on, every session in that project gets:

- **SessionStart**: routing summary injected as context — which tool to use for which signal.
- **PreToolUse**: nudges on `WebFetch` of library docs (→ Context7), `WebSearch` (→ vicky first), `Read` on large files (→ Grep).

Without the marker the hooks are silent. Zero cost.

## Install

```
/plugin marketplace add yesitsfebreeze/stack
/plugin install stack@stack
/stack:bootstrap
```

`/stack:bootstrap` runs `scripts/install.sh` (POSIX) or `scripts/install.ps1` (Windows) via Bash. The script:

- Adds the `stack` marketplace.
- Installs all sub-plugins: `git-fs`, `vicky`, `context7`, `caveman`, `context-mode`.
- Creates `.stack` marker in cwd (activates routing hooks).
- Warns if `CONTEXT7_API_KEY` is unset.

Idempotent — safe to re-run.

Direct invocation (without Claude Code):

```bash
# POSIX
bash scripts/install.sh

# Windows
powershell -ExecutionPolicy Bypass -File scripts/install.ps1
# or
scripts\install.bat
```

Then verify:

```
/stack:doctor
```

Reports MCP health, env vars, opt-in marker, installed plugins.

### Prereqs per sub-plugin

| Plugin | Needs |
|---|---|
| `git-fs` | None — plugin auto-downloads binary on first run. |
| `vicky` | None — upstream `yesitsfebreeze/vicky` plugin. |
| `context7` | `CONTEXT7_API_KEY` env var ([get key](https://context7.com)) |

### Activate per project

```bash
touch .stack
```

See [docs/OPT-IN.md](docs/OPT-IN.md).

## Update

One-shot via the bundled command:

```
/stack:update
```

Runs `scripts/update.sh` (POSIX) or `scripts/update.ps1` (Windows) — refreshes the `stack` marketplace and `claude plugin update`s each sub-plugin (`stack`, `git-fs`, `vicky`, `context7`, `caveman`, `context-mode`). Idempotent. **Restart Claude Code** to apply, then `/stack:doctor` to verify.

Direct invocation (without Claude Code):

```bash
# POSIX
bash scripts/update.sh

# Windows
powershell -ExecutionPolicy Bypass -File scripts/update.ps1
# or
scripts\update.bat
```

Manual fallback (per-plugin):

```
/plugin marketplace update stack
/plugin update stack@stack
/plugin update git-fs@stack
/plugin update vicky@stack
/plugin update context7@stack
/plugin update caveman@stack
/plugin update context-mode@stack
```

## Uninstall

```
/plugin uninstall stack@stack
/plugin marketplace remove stack
```

Removes hooks, skills, MCP registrations. Vendored vicky source and `.stack` markers stay — delete by hand.

## Docs

| File | Purpose |
|---|---|
| [docs/SETUP.md](docs/SETUP.md) | Manual bootstrap checklist (without marketplace) |
| [docs/ROUTING.md](docs/ROUTING.md) | Full decision table |
| [docs/MAINTENANCE.md](docs/MAINTENANCE.md) | Monthly audit / prune |
| [docs/OPT-IN.md](docs/OPT-IN.md) | `.stack` marker mechanics |
| [docs/tools/](docs/tools/) | Per-tool reference (git-fs, vicky, context7, skills) |
| [docs/install/](docs/install/) | Legacy manual install docs |
| [docs/reference/WORKFLOWS.md](docs/reference/WORKFLOWS.md) | Comparison vs 2026 ecosystem |

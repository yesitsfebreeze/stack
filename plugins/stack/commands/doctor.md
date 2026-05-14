---
description: Health check for the stack — MCPs connected, env vars set, binaries on PATH, opt-in marker present.
---

Run the following checks and report a checklist. For each item: ✅ pass, ❌ fail with one-line fix.

## 1. MCP servers

Run `claude mcp list`. Expect entries `connected`:

- `git-fs`
- `vicky`
- `context7`

Any missing or `failed`: report which, and suggest `/plugin install <name>@stack`.

## 2. Env vars

Check process env:

- `CONTEXT7_API_KEY` — required for `context7`

Empty: report and suggest export.

## 3. Routing opt-in

Check cwd for `.stack` or `.stack.toml` marker. Present → SessionStart hook injects routing summary. Absent → routing is dormant unless user types stack trigger phrase.

Report status only — do not create the file.

## 4. Stack plugins installed

Run `/plugin list` (or read user settings). Expect:

- `stack@stack`
- `git-fs@stack`
- `vicky@stack`
- `context7@stack`

Optional: `caveman@stack`, `context-mode@stack`.

## Output format

```
Stack doctor:
  MCPs:        [✅/❌] git-fs, vicky, context7
  Env:         [✅/❌] CONTEXT7_API_KEY
  Opt-in:      [✅/—] .stack marker
  Plugins:     [✅/❌] stack, git-fs, vicky, context7
```

Then list fixes for each ❌.

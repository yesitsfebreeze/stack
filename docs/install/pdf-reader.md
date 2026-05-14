# pdf-reader — Install

PDF text/image/metadata extraction via `@sylphx/pdf-reader-mcp`. Stdio MCP launched through `npx`.

Source: https://mcpservers.org/servers/sylphxltd/pdf-reader-mcp

## Install (via stack marketplace)

```
/plugin install pdf-reader@stack
```

Or bundled with `/stack:bootstrap`.

## Prereqs

- **Node.js ≥18** so `npx` is on PATH. Get it from https://nodejs.org.
- First MCP launch downloads `@sylphx/pdf-reader-mcp` from npm; subsequent launches use the npm cache.

## Verify

```
claude mcp list | grep pdf-reader   # connected
```

Tool exposed: `read_pdf` (text, images base64, metadata, page count; local file or HTTP URL; batch + parallel).

## Optional env (security)

| Var | Effect |
|---|---|
| `MCP_PDF_ALLOWED_DIRS` | Restrict filesystem reads (`:` or `,` separated) |
| `MCP_PDF_ALLOW_HTTP` | Set `false` to block URL sources |
| `MCP_PDF_ALLOWED_HOSTS` | Allowlist hosts (`,` separated) |

## Troubleshooting

| Symptom | Fix |
|---|---|
| `pdf-reader` shows `failed` in `claude mcp list` | `npx` missing or blocked. Install Node.js, restart Claude Code. |
| `npm ERR! 404` on first run | Network/proxy blocks npm registry. Configure `npm config set registry` or pre-install: `npm i -g @sylphx/pdf-reader-mcp`. |
| Hangs on first launch | First-run download. Pre-warm: `npx -y @sylphx/pdf-reader-mcp` (Ctrl+C once it prints). |

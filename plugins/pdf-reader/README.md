# pdf-reader plugin

Registers `@sylphx/pdf-reader-mcp` (stdio MCP). Single `read_pdf` tool extracts text, images (base64), metadata, page counts from local files or HTTP URLs. Batch + parallel.

Source: https://mcpservers.org/servers/sylphxltd/pdf-reader-mcp

## Prerequisite

`npx` on PATH (ships with Node.js). First run downloads the package; subsequent runs use the npm cache.

Verify: `claude mcp list | grep pdf-reader` → `connected`.

## Optional env vars

- `MCP_PDF_ALLOWED_DIRS` — restrict filesystem access (`:` or `,` separated)
- `MCP_PDF_ALLOW_HTTP=false` — block URL sources
- `MCP_PDF_ALLOWED_HOSTS` — allowlist hosts (`,` separated)

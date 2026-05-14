# Install — Context7

## Repo / Service

- GitHub: https://github.com/upstash/context7
- Hosted MCP: https://mcp.context7.com/mcp
- Docs: https://context7.com

## Install — Option A: Hosted HTTP (recommended)

Get API key from https://context7.com (free tier exists).

### Inside Claude
```
/mcp add context7 https://mcp.context7.com/mcp
```

Then set header `CONTEXT7_API_KEY` = your key.

### Config snippet (manual `.claude.json`)

```json
"context7": {
  "type": "http",
  "url": "https://mcp.context7.com/mcp",
  "headers": {
    "CONTEXT7_API_KEY": "ctx7sk-..."
  }
}
```

## Install — Option B: Local npx (no key, rate-limited)

```bash
claude mcp add context7 --scope user -- npx -y @upstash/context7-mcp@latest
```

Auto-pulls `@latest` each spawn → no manual update.

## Update

Hosted: nothing to update — server-side.
Local npx: automatic via `@latest`. To pin: `npx -y @upstash/context7-mcp@1.2.3`.

## Verify

```bash
claude mcp list | grep context7
```

Expect `connected`. Tools: `resolve-library-id`, `query-docs`.

## Test call

```
mcp__context7__resolve-library-id(libraryName="Next.js", query="middleware")
```

Expect `/vercel/next.js` returned.

## Troubleshooting

- 401 / auth errors → re-check `CONTEXT7_API_KEY` header.
- Library not found → try official name (`Next.js` not `nextjs`), add version (`/vercel/next.js/v15.0.0`).
- Stale docs → call `query-docs` with `researchMode: true` (more expensive — sandboxed agents + git-pull source + live web search).
- npx slow first run → it's downloading the package. Subsequent runs cached.

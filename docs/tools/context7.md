# Context7

Versioned, current library/framework/SDK docs.

## Tools

| Tool | Use |
|---|---|
| `resolve-library-id(libraryName, query)` | Map name → `/org/project` ID |
| `query-docs(libraryId, query)` | Fetch docs scoped to question |

## Standard flow

```
1. resolve-library-id(libraryName="Next.js", query="middleware auth")
   → returns /vercel/next.js (or versioned /vercel/next.js/v15.0.0)
2. query-docs(libraryId="/vercel/next.js", query="middleware auth with JWT")
   → fetches current docs, returns relevant snippets
3. answer using fetched docs
```

## When to use

- Library / framework / SDK / API / CLI / cloud service mentioned
- Setup questions
- Version migration
- Code generation involving libraries
- **Even for well-known libs** — training cutoff drifts, docs change

## When NOT to use

- Refactoring (no library docs needed)
- Writing scripts from scratch
- Debugging business logic
- General programming concepts
- Project-internal code (use kern)

## Selection tips

When `resolve-library-id` returns multiple matches, pick by:
1. Exact name match
2. Source reputation (High/Medium preferred)
3. Code snippet count (higher = better coverage)
4. Benchmark score (higher = better quality)
5. Version match if user specified

Max 3 calls per question. If unhappy with answer, re-call `query-docs` with `researchMode: true` (runs sandboxed agents + git-pulls source repos + live web search).

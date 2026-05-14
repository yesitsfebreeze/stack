# ROUTING — Decision Table

Apply silently. Don't narrate unless asked.

## Signal → Route

| User signal | Route | Why |
|---|---|---|
| Library/SDK name + "how do I…" / API syntax / version migration | **Context7** `resolve-library-id` → `query-docs` | Versioned, current. Training data drifts. |
| PDF file or URL → extract text/images/metadata | **pdf-reader** `read_pdf` | Native PDF; supports page ranges, batch, HTTP. |
| Project-internal "where is X" / "what does our code say about Y" | **kern** `search_fulltext`; fallback Grep/Glob | Indexed, no file re-read |
| "Latest" / "current" / "in 2026" / open research | **vicky** `query` → if gap: `web-search` → `remember` | Persistent across sessions |
| Code review, refactor, "where is X called" | codegraph (if installed); else kern + Grep | Structural > textual |
| Two+ parallel agents, throwaway experiment | **git-fs** `git_fs_branch_create` | Isolation w/o working-tree cost |
| External tool needs working tree (build/lint/LSP) | native worktree `EnterWorktree` | git-fs is object-only |
| Long session, context bloating | kern `trim_oldest` / `rewrite_at` / `copy_history_into` | Surgical pruning |
| Pure observability / logging | hook with `discard` injection mode | Zero context cost |
| Recurring specialized task | propose **new skill** | Auto-trigger amortizes setup |

## Anti-patterns

- ❌ `Read` whole file just to analyze → kern search or codegraph
- ❌ `WebFetch` library docs → Context7
- ❌ `Read` on `.pdf` → pdf-reader `read_pdf` (Read returns garbage on binary)
- ❌ Repeat web search across sessions → `vicky.query` first
- ❌ Dump raw tool output into context → sandbox via context-mode
- ❌ Skill with vague description → must contain verbatim trigger phrase
- ❌ Hooks injecting unused payloads → `discard` mode

## Tool missing or stale? → install/

If a routed tool is **not available** in the MCP tool list, or user reports it broken:

1. Read [install/](install/) doc for that tool.
2. Run install / update steps shown.
3. Verify with `claude mcp list`.
4. Resume routing.

| Tool unavailable | Read |
|---|---|
| kern / wiki | [install/kern.md](install/kern.md) |
| git-fs | [install/git-fs.md](install/git-fs.md) |
| vicky | [install/vicky.md](install/vicky.md) |
| Context7 | [install/context7.md](install/context7.md) |
| pdf-reader | [install/pdf-reader.md](install/pdf-reader.md) |
| Skill not firing | [install/skills.md](install/skills.md) |

Do not invent install commands. If the install doc lacks info, ask the user — don't guess.

## Tool-call hierarchy (preferred → last resort)

```
1. kern.search_fulltext              (project docs)
2. vicky.query                       (research KB)
3. context7.query-docs               (library docs)
4. pdf-reader.read_pdf               (PDF files / URLs)
5. codegraph                         (structural code)
6. Grep / Glob                       (raw search fallback)
7. Read                              (only when editing)
8. WebSearch                         (only after vicky gap signal)
9. WebFetch                          (only for non-library content not in vicky)
```

## Quick decision flow

```
question arrives
  ├─ about library API?       → Context7
  ├─ involves a PDF?          → pdf-reader
  ├─ about our project?       → kern
  ├─ "latest" / external?     → vicky → web-search if gap
  ├─ code structure?          → codegraph / kern
  └─ writing/editing files?
       ├─ multi-agent?        → git-fs branch
       ├─ tool needs tree?    → worktree
       └─ solo, simple?       → direct Edit
```

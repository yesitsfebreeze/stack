---
name: stack-routing
description: Stack decision table for routing work across kern, git-fs, vicky, Context7, skills. Trigger when user says "follow stack routing", "route this", "which tool", or starts work in a stack-enabled project.
---

# Stack Routing

Apply silently. Don't narrate unless asked.

## Signal → Route

| User signal | Route | Why |
|---|---|---|
| Library/SDK name + "how do I…" / API syntax / version migration | **Context7** `resolve-library-id` → `query-docs` | Versioned, current. Training data drifts. |
| Project-internal "where is X" / "what does our code say about Y" | Grep/Glob; index via **vicky** if recurring | No kern in this stack |
| "Latest" / "current" / "in 2026" / open research | **vicky** `query` → if gap: `web-search` → `remember` | Persistent across sessions |
| Code review, refactor, "where is X called" | codegraph (if installed); else Grep | Structural > textual |
| Two+ parallel agents, throwaway experiment | **git-fs** `git_fs_branch_create` | Isolation w/o working-tree cost |
| External tool needs working tree (build/lint/LSP) | native worktree `EnterWorktree` | git-fs is object-only |
| Long session, context bloating | `/compact` or `/clear` + vicky recall of key facts | No kern surgical prune |
| Pure observability / logging | hook with `discard` injection mode | Zero context cost |
| Recurring specialized task | propose **new skill** | Auto-trigger amortizes setup |

## Anti-patterns

- `Read` whole file just to analyze → Grep or codegraph
- `WebFetch` library docs → Context7
- Repeat web search across sessions → `vicky.query` first
- Dump raw tool output into context → sandbox via context-mode
- Skill with vague description → must contain verbatim trigger phrase
- Hooks injecting unused payloads → `discard` mode

## Tool-call hierarchy

```
1. vicky.query                       (research KB)
2. context7.query-docs               (library docs)
3. codegraph                         (structural code, if installed)
4. Grep / Glob                       (raw search)
5. Read                              (only when editing)
6. WebSearch                         (only after vicky gap signal)
7. WebFetch                          (only for non-library content not in vicky)
```

## Quick decision flow

```
question arrives
  ├─ about library API?       → Context7
  ├─ about our project?       → Grep / Glob
  ├─ "latest" / external?     → vicky → web-search if gap
  ├─ code structure?          → codegraph / Grep
  └─ writing/editing files?
       ├─ multi-agent?        → git-fs branch
       ├─ tool needs tree?    → worktree
       └─ solo, simple?       → direct Edit
```

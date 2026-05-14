# Token-Efficient Workflows — Tool Stack & 2026 Adjustment

> Translation, consolidation, and 2026-best-practice gap analysis of `token-werkzeuge.md`.
> Focus stack: **kern** (knowledge index) · **git-fs** (session VFS) · **vicky** (research KB) · **skills** (auto-loaded capability modules).
> Date compiled: 2026-05-14.

---

## 1. Quick comparison — your stack vs 2026 ecosystem

| Capability | Your tool | 2026 equivalent / peer | Verdict |
|---|---|---|---|
| Project-wide doc index | **kern** (Tantivy FTS + embeddings, `search_fulltext`, `search_by_tag`) | `context-mode` (SQLite + FTS5/BM25, sandbox tool output, claims 98% reduction); `code-review-graph` / `CodeGraph` (Tree-sitter structural graph, up to 49× reduction on reviews) | Keep kern for *docs*. Add structural code graph alongside it — kern is text-first, codegraph is AST-first. Complementary, not redundant. |
| Specialized capability loading | **skills** with `description:` frontmatter, progressive disclosure | Same pattern is the 2026 industry default (Anthropic docs, Firecrawl/Nimbalyst guides) | Already correct. Just enforce hygiene: ≤12 active skills, monthly audit, prune anything untriggered for 30 days. |
| Logging / telemetry w/o token cost | Hooks with `discard` injection mode | Standard Claude Code hooks (`SessionStart`, `PostToolUse`, etc.) — `discard` is a kern-specific extension | Kern wins here. Native hooks always inject; `discard` is the only zero-context mode. |
| Always-warm files | Session file cache w/ mtime + FIFO | CLAUDE.md auto-load + manual `@file` references | Kern cache is stricter. Native behavior is sloppier and re-reads. Kern wins. |
| Ingest filtering | Two-stage compression: LLM rewrite + relevance gate (cosine ≥ 0.15) | Most MCP indexers ingest raw chunks. `context-mode` sandboxes raw, doesn't pre-compress. | Kern wins. Prevents index pollution. |
| Long-session memory mgmt | `trim_oldest`, `rewrite_at`, `copy_history_into` | `/compact`, `/clear`, native context summarization | Native is automatic but lossy. Kern primitives let you fork conversation at decision points — keep. |
| Session isolation | **git-fs** — bare-git VFS, branch per session, 3-way merge at stop | Native worktrees (`--worktree`, `EnterWorktree`), `mcp-virtual-fs` (Postgres-backed VFS) | Git-fs more sophisticated: object-store, conflicts go to `CONFLICTS.md` not context. Worktrees are file-level, git-fs is object-level. Keep git-fs as primary; worktree as fallback for tools that need real working tree. |
| External research / web KB | **vicky** (`research`, `web-search`, `remember`, `query`, gap-signal) | `deep-research-mcp`, Context7 (library docs), native WebSearch/WebFetch | Vicky for *persistent* research findings. Context7 for *library docs* (current, versioned). WebSearch for *one-shot* facts. Different jobs — keep all three, route correctly. |

---

## 2. Tools — what each does, when to reach for it

### 2.1 `kern` — token-efficient knowledge layer
Underlying model: Tantivy full-text index + embedding store + lifecycle hooks + ingest pipeline + message buffer ops. Source: `token-werkzeuge.md` items 1, 3, 4, 5, 6.

| Primitive | Use |
|---|---|
| `learn_pass` | One-time index of project docs |
| `search_fulltext`, `search_by_tag` | Recurring lookup w/o file re-read |
| Hooks (`startup`, `pre_turn`, `post_turn`, `pre_tool`, `post_tool`) + modes (`system` / `user` / `tool_result` / `discard`) | Inject only when needed; `discard` = zero context cost |
| File cache (mtime + FIFO, per-session) | Layer-1 files (CLAUDE.md) stay warm |
| `ingest_chunk()` w/ `maybe_rewrite` + `passes_purpose` (cos ≥ 0.15) | Single ingest path, no bypass; 40–60% chunk shrink before storage |
| `trim_oldest(cap)` / `rewrite_at(ts, new)` / `copy_history_into(dest, cutoff)` | Long-session pruning + forking |

**When to reach:** recurring question, cross-repo nav, architecture overview without dumping files.

### 2.2 `git-fs` — per-session virtual filesystem
Bare-git object store as VFS. Session = branch `agent/<session-id>`. Auto-commit on every Write/Edit. 3-way merge to `main` at Stop hook.

11 MCP tools (stdio JSON-RPC 2.0):
`git_fs_read` · `git_fs_write` · `git_fs_rm` · `git_fs_merge` · `git_fs_diff` · `git_fs_log` · `git_fs_ls` · `git_fs_checkout` · `git_fs_branch_create` · `git_fs_branch_delete` · `git_fs_patch` · `git_fs_replace` · `git_fs_init` · `git_fs_branch_list`

**When to reach:** parallel agents, disposable experiments, anything where cross-session overwrite would cost debugging time. Disk read-only during session — conflicts land in `CONFLICTS.md`, not in your context.

**Don't reach for:** tools that need a real working tree (linters, language servers, build systems). Use `git_fs_checkout` to materialize, or run those in a native worktree.

### 2.3 `vicky` — research / persistent KB
| Tool | Purpose |
|---|---|
| `query` | Ask KB. Returns context + gap-signal if missing |
| `web-search` | Fill gap, save sources |
| `research` / `research-gap` / `complete-research` | Long-running research tasks |
| `remember` | Persist conclusion |
| `enqueue` / `promote` / `relink` | Queue mgmt + graph maintenance |

**When to reach:** before answering a research-flavored question. Pattern: `query` → if gap, `web-search` → `remember`. Builds compounding KB across sessions.

**Don't reach for:** library API/syntax docs → use **Context7** (`resolve-library-id` → `query-docs`). It's versioned and current.

### 2.4 Skills — auto-loaded capability modules
Layout: `.claude/skills/<name>/SKILL.md`. YAML frontmatter `name` + `description`. Body ≤ ~5k tokens (loads in full when triggered).

Token math (2026 docs): ~100 tokens per skill scanned at boot via frontmatter alone. Full body only on trigger.

**2026 best practice consensus:**
- Description **is** the trigger. Words user actually types must appear.
- ≤12 active skills. Audit monthly. Delete unfired-for-30-days.
- Global rules → CLAUDE.md. Domain workflows → skill.
- Big skills split into supporting files; SKILL.md stays the index.

Your active skills observed: `caveman`, `relay`, `coder`, `fact-check`, `graphify`.

---

## 3. Gaps & adjustments — what to change

### 3.1 Add a structural code graph alongside kern
Kern indexes text. Code reviews and refactors benefit from a Tree-sitter graph (calls / imports / definitions). Candidates: `code-review-graph`, `CodeGraph`. They ship as MCP and auto-load on `.codegraph/` presence. Reported 6.8×–49× token reduction on review tasks.

**Action:** evaluate `CodeGraph` for one repo. If it adds value, wire as MCP server. Kern stays for docs; codegraph for code.

### 3.2 Stop using kern for library/API docs
Your training cutoff drifts. Library docs move. Route:
- Library/framework/SDK question → **Context7** (`resolve-library-id` → `query-docs`).
- Project-internal doc → **kern** (`search_fulltext`).
- Open research → **vicky** (`query` → `web-search` → `remember`).

### 3.3 Skill audit checklist
- [ ] List `.claude/skills/*/SKILL.md`, log last-fired timestamp.
- [ ] Delete any unfired ≥30 days.
- [ ] For each kept skill: trigger phrase appears in description verbatim.
- [ ] Body ≤ 5k tokens; overflow → supporting file referenced from SKILL.md.

### 3.4 Hook injection budgets — verify in use
`turn_inject_budget` = 32 KiB shared across hooks; per-hook `max_bytes` clips payload. Priority-drop on overflow. Confirm priority assignment on every hook. Anything purely observational (logging, metrics) → `discard` mode.

### 3.5 Session-isolation routing
- Quick edit, no parallel agent → no isolation needed.
- Two+ Claude sessions on same repo → **git-fs** branches.
- External tool needs working tree (build, lint, LSP) → **native worktree** (`EnterWorktree`).
- Throwaway experiment → git-fs branch, delete at stop, never merge.

### 3.6 Vicky-first research protocol
Before every research-flavored answer:
1. `vicky.query(question)` — cheap.
2. If gap signal → `vicky.web-search` or `WebSearch` → write back via `vicky.remember`.
3. Cite source in answer.

Prevents repeating the same web search across sessions.

---

## 4. Combined workflow — fastest path per scenario

| Scenario | Step 1 | Step 2 | Step 3 |
|---|---|---|---|
| "What does our codebase say about X?" | `kern.search_fulltext` | If miss → `Grep`/`Glob` | Update kern via `learn_pass` |
| "How does library Y do Z?" | `context7.resolve-library-id` | `context7.query-docs` | (optional) `vicky.remember` |
| "Latest on topic Q?" | `vicky.query` | gap → `vicky.web-search` | `vicky.remember` |
| Code review / refactor | codegraph query (if installed) | `kern.search_fulltext` for ADRs | Edit in git-fs branch |
| Two parallel features | `git_fs_branch_create` per agent | Work in branches | `git_fs_merge` at stop |
| Long session bloating | `trim_oldest` | or `rewrite_at` decision point | or fork via `copy_history_into` |
| New capability needed often | Write skill, tight description | Place in `.claude/skills/<name>/` | Test trigger phrase |
| Observability without context cost | Hook `post_tool` mode `discard` | Log to disk | Query later via kern |

---

## 5. Open questions to resolve next

1. Is `CodeGraph` worth adding, or does kern's embedding store already cover structural queries adequately? Try on one repo, measure.
2. Does git-fs currently auto-route to native worktree when a tool needs a working tree, or is that manual? If manual, write a small skill.
3. Skill inventory — when last audited? Run §3.3 checklist this week.
4. Vicky `research` long-running mode — currently triggered manually. Worth a skill auto-trigger on phrases like "deep dive on…"?

---

## Sources

- [Extend Claude with skills — Claude Code Docs](https://code.claude.com/docs/en/skills)
- [Claude Code Skills: A Practical 2026 Guide — Nimbalyst](https://nimbalyst.com/blog/claude-code-skills-guide/)
- [Best Claude Code Skills in 2026 — Firecrawl](https://www.firecrawl.dev/blog/best-claude-code-skills)
- [Run parallel sessions with worktrees — Claude Code Docs](https://code.claude.com/docs/en/worktrees)
- [Connect Claude Code to tools via MCP — Claude Code Docs](https://code.claude.com/docs/en/mcp)
- [context-mode — context window optimization (GitHub)](https://github.com/mksglu/context-mode)
- [code-review-graph (GitHub)](https://github.com/tirth8205/code-review-graph)
- [CodeGraph (GitHub)](https://github.com/colbymchenry/codegraph)
- [mcp-virtual-fs (GitHub)](https://github.com/lu-zhengda/mcp-virtual-fs)
- [Inside Claude Code — Architecture: Tools, Memory, Hooks, MCP](https://www.penligent.ai/hackinglabs/inside-claude-code-the-architecture-behind-tools-memory-hooks-and-mcp/)
- [Deep Research MCP](https://neuralnoise.com/2026/deep-research-mcp/)
- [7 MCP Servers Every Claude User Should Know — 2026](https://medium.com/@docat0209/7-mcp-servers-every-claude-user-should-know-about-2026-9d17a0f5db73)

# SETUP — Stack Bootstrap

Walk in order. Skip steps already satisfied.

## 1. MCP servers reachable

Check tool list shows:
- `mcp__git-fs__git_fs_*` — git-fs
- `mcp__vicky__*` — vicky
- `mcp__context7__*` — Context7
- kern primitives: `search_fulltext`, `search_by_tag`, `learn_pass` (only if kern registered)

If missing → register MCP server in `~/.claude.json` or project `.mcp.json`. Don't proceed without.

## 2. CLAUDE.md sanity

Read `~/.claude/CLAUDE.md`. Confirm:
- Only **global** rules (file-naming, no `.env` commits, language preferences).
- **No** domain workflows (those go in skills or this stack).
- ≤200 lines (everything after gets truncated in context).

## 3. Skill audit

```
ls ~/.claude/skills/*/SKILL.md
```

For each:
- Frontmatter has `description:` with verbatim trigger words user actually types.
- Body ≤ 5k tokens; overflow → `references/<topic>.md`.
- Active count ≤ 12. Over → retire least-used.

See [tools/skills.md](tools/skills.md).

## 4. Kern index freshness

If kern registered:
```
learn_pass(root=<project>)
```
Run once per project, re-run weekly or on big merges.

## 5. git-fs session branch

If multi-agent expected:
```
git_fs_branch_create(name="agent/<session-id>")
```
Stop hook handles merge → `main` automatically. Verify `.git-fs/` dir exists in project.

See [tools/git-fs.md](tools/git-fs.md).

## 6. Vicky KB sanity

```
vicky.query("known-good question")
```
Expect context returned, not empty. If empty → run `vicky.web-search` on a seed topic + `vicky.remember`.

See [tools/vicky.md](tools/vicky.md).

---

## Done state

- [ ] All 4 MCP servers reachable
- [ ] CLAUDE.md ≤200 lines, global-only
- [ ] Skill count ≤12, descriptions verified
- [ ] Kern indexed this week
- [ ] git-fs branch live (if multi-agent)
- [ ] Vicky returns context for seed query

When all checked → load [ROUTING.md](ROUTING.md), start work.

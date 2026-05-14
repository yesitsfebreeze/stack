---
name: setup
description: Bootstrap checklist for the stack workflow. Trigger when user says "stack setup", "bootstrap stack", "set up stack", or starts a new machine/project that needs stack tools.
---

# Stack Setup

Walk in order. Skip steps already satisfied.

## 1. MCP servers reachable

Check tool list shows:
- `mcp__git-fs__git_fs_*`
- `mcp__vicky__*`
- `mcp__context7__*`
- `mcp__pdf-reader__*`

Missing? Install the matching plugin from the `stack` marketplace:
```
/plugin install git-fs@stack
/plugin install vicky@stack
/plugin install context7@stack
/plugin install pdf-reader@stack
```

## 2. CLAUDE.md sanity

Read `~/.claude/CLAUDE.md`. Confirm:
- Only **global** rules (file-naming, no `.env` commits, language preferences).
- **No** domain workflows.
- ≤200 lines.

## 3. Skill audit

For each `~/.claude/skills/*/SKILL.md` and plugin-bundled skills:
- Frontmatter `description:` has verbatim trigger words.
- Body ≤ 5k tokens; overflow → `references/<topic>.md`.
- Active count ≤ 12.

## 4. git-fs session branch

If multi-agent expected:
```
git_fs_branch_create(name="agent/<session-id>")
```

## 5. Vicky KB sanity

```
vicky.query("known-good question")
```
Empty? Seed via `vicky.web-search` + `vicky.remember`.

## Done state

- [ ] All 4 MCP servers reachable (git-fs, vicky, context7, pdf-reader)
- [ ] CLAUDE.md ≤200 lines, global-only
- [ ] Skill count ≤12, descriptions verified
- [ ] git-fs branch live (if multi-agent)
- [ ] Vicky returns context for seed query

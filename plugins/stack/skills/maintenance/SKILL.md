---
name: maintenance
description: Monthly audit, prune, reindex commands for the stack. Trigger when user says "stack maintenance", "audit stack", "prune stack", "reindex".
---

# Stack Maintenance

Run monthly or after big merges.

## Audit

```
ls ~/.claude/skills/*/SKILL.md           # skill count
claude mcp list                          # MCP health
```

Skill count > 12 → retire least-used.

## Prune git-fs

```
git_fs_branch_list()
git_fs_branch_delete(name=<stale>)
```

## Vicky KB hygiene

```
vicky.relink                # reconnect orphans
vicky.dashboard             # health
```

Stale conclusions → delete `.vicky/` + reseed.

## Context7

Nothing local. Hosted updates server-side.

## CLAUDE.md drift

Re-check ≤200 lines. Move domain-specific content out → skills.

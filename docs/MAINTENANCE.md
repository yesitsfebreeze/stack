# MAINTENANCE

## Monthly

### Skill audit
```
ls ~/.claude/skills/*/SKILL.md
```
For each: last-fired ≥30 days → propose delete.
Verify description has verbatim trigger phrase.
Verify body ≤5k tokens.

### Kern reindex
```
learn_pass(root=<project>, force=true)
```
Report chunk-count delta. Big delta → docs grew, consider splitting.

### Vicky relink
```
vicky.relink
```
Reconnects orphan notes to current graph.

## Weekly

### Hook budget check
Inspect `<config_root>/events/*.yaml`:
- All observability hooks → `mode: discard`.
- Per-hook `max_bytes` set.
- Total under `turn_inject_budget` (32 KiB).

### git-fs branch cleanup
```
git_fs_branch_list
```
Delete merged `agent/*` branches older than 7 days.

## Per-session

### Context bloat
Watch context %. At 60%:
- `kern.trim_oldest(cap=N)` — drop oldest N messages.
- Or `kern.rewrite_at(ts, summary)` — collapse history at decision point.

### Fork experiment
```
kern.copy_history_into(dest=new_session, cutoff_ts=now)
```
Spin off branch without doubling context.

## On demand

| Command | Action |
|---|---|
| `stack audit` | Run monthly skill audit + report |
| `stack prune` | Propose deletions for unfired skills |
| `stack reindex` | Run `learn_pass` on current project |
| `stack doctor` | Check all 4 MCP servers reachable |

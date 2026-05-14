# git-fs

Bare-git object store as virtual filesystem per Claude session.

## Model

```
SessionStart → branch agent/<session-id> created
PostToolUse  → every Write/Edit auto-commits to session branch
Stop hook    → 3-way merge agent/<session-id> → main, materialize disk
```

Disk read-only during session. Conflicts go to `CONFLICTS.md` (not into context).

## 11 MCP tools

| Tool | Use |
|---|---|
| `git_fs_init` | Init new git-fs in project |
| `git_fs_read` | Read file from session branch |
| `git_fs_write` | Write file (auto-commits) |
| `git_fs_rm` | Delete file |
| `git_fs_replace` | Replace file contents |
| `git_fs_patch` | Apply patch |
| `git_fs_ls` | List paths |
| `git_fs_diff` | Show diff |
| `git_fs_log` | Commit log |
| `git_fs_checkout` | Materialize to disk |
| `git_fs_merge` | 3-way merge |
| `git_fs_branch_create` / `_delete` / `_list` | Branch mgmt |

## When to use

- Two+ Claude sessions on same repo → branch per session
- Throwaway experiment → branch, never merge, delete at stop
- Want disk read-only during work → default behavior

## When NOT to use

- Tool needs real working tree (build, lint, LSP) → use native worktree `EnterWorktree` instead
- Solo edit, no parallel work → direct Edit fine

## Trade-off vs native worktree

| | git-fs | native worktree |
|---|---|---|
| Granularity | Git-object level | Filesystem level |
| Speed | Faster, no FS ops | Real files, slower |
| Tool compat | Limited (no working tree) | Full |
| Conflict surface | `CONFLICTS.md` | Merge conflicts in tree |

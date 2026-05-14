# Install — git-fs

## Repo

https://github.com/yesitsfebreeze/git-fs

Local clone (if present): `C:\Users\sayhe\dev\git-fs`

## Install (via Claude plugin marketplace)

### Terminal
```bash
claude marketplace add yesitsfebreeze/git-fs
claude plugin install git-fs@yesitsfebreeze
```

### Inside Claude
```
/plugin marketplace add yesitsfebreeze/git-fs
/plugin install git-fs@yesitsfebreeze
```

Installs `git-fs-mcp` binary + SessionStart / PostToolUse / Stop hooks.

## Update

```bash
claude plugin update git-fs@yesitsfebreeze
```

Or pull + rebuild:
```bash
cd ~/dev/git-fs
git pull
# build per repo README (likely cargo build --release or npm install)
```

## Verify

```bash
claude mcp list | grep git-fs
```

Expect `connected`. Tools: `git_fs_read`, `git_fs_write`, `git_fs_merge`, `git_fs_diff`, `git_fs_log`, `git_fs_ls`, `git_fs_checkout`, `git_fs_branch_create`, `git_fs_branch_delete`, `git_fs_branch_list`, `git_fs_patch`, `git_fs_replace`, `git_fs_init`, `git_fs_rm`.

## Config snippet (manual `.claude.json`)

```json
"git-fs": {
  "type": "stdio",
  "command": "git-fs-mcp",
  "args": [],
  "env": {}
}
```

`git-fs-mcp` must be on `PATH`. Check with `where git-fs-mcp` (Windows) / `which git-fs-mcp` (Unix).

## Per-project init

```
git_fs_init(project_root=".")
```

Creates `.git-fs/` (bare git object store). Add to `.gitignore` if you don't want it in main repo.

## Troubleshooting

- `git-fs-mcp not found` → reinstall plugin or add to PATH manually.
- Stop hook didn't merge → check `~/.claude/settings.json` has Stop hook registered for git-fs.
- Conflicts after merge → see `CONFLICTS.md` in project root.
- Want to disable for one session → don't `git_fs_init` on that project, falls back to native filesystem.

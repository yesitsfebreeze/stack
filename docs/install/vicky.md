# Install — vicky

## Repo

https://github.com/yesitsfebreeze/vicky

Local clone (if present): `C:\Users\sayhe\dev\vicky`

## Install (via Claude plugin marketplace)

### Terminal
```bash
claude marketplace add yesitsfebreeze/vicky
claude plugin install vicky@yesitsfebreeze
```

### Inside Claude
```
/plugin marketplace add yesitsfebreeze/vicky
/plugin install vicky@yesitsfebreeze
```

## Update

```bash
claude plugin update vicky@yesitsfebreeze
```

Or pull source:
```bash
cd ~/dev/vicky
git pull
npm install      # vicky is a Node project per package.json
```

## Verify

```bash
claude mcp list | grep vicky
```

Expect `connected`. Tools: `query`, `web-search`, `research`, `research-gap`, `complete-research`, `remember`, `enqueue`, `promote`, `relink`.

## Config snippet (manual `.claude.json`)

```json
"vicky": {
  "type": "stdio",
  "command": "node",
  "args": [
    "C:/Users/sayhe/.claude/plugins/vicky/src/index.js"
  ],
  "env": {}
}
```

**Known issue:** relative paths can break. Use absolute path to `src/index.js`.

## First-run init

```bash
npm run init     # runs ~/.claude/skills/vicky/init.mjs
```

Or call `vicky.query("test")` — gap signal expected, then `web-search` + `remember` seed the KB.

## Troubleshooting

- `query` always empty → KB not seeded. Run a few `web-search` + `remember` cycles.
- Path-resolution errors → switch config args to absolute paths.
- Stale conclusions → `relink` reconnects orphaned notes; or delete `.vicky/` and re-seed.

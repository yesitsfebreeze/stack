# Install — Skills

Skills are files, not MCP servers. No marketplace install. You author them directly.

## Location

```
~/.claude/skills/<name>/SKILL.md
```

Optional supporting files:
```
~/.claude/skills/<name>/
├── SKILL.md             # required
├── references/          # overflow content
│   └── deep-topic.md
└── scripts/             # executable helpers
    └── helper.sh
```

## Create new skill

### Option A — manual

```bash
mkdir -p ~/.claude/skills/myskill
```

Write `SKILL.md`:

```markdown
---
name: myskill
description: Trigger spec with verbatim phrases user types. "do X", "run Y", "fix Z".
---

# Body

Instructions Claude follows when triggered.
≤5k tokens. Overflow → references/<topic>.md.
```

### Option B — via skill-creator skill

```
/skill-creator
```

Interactive scaffold + description-tuning.

## Update

Edit `SKILL.md` directly. Reload happens on next session.

To verify trigger fires: type the trigger phrase verbatim, check skill activates.

## List installed

```bash
ls ~/.claude/skills/*/SKILL.md
```

Or inspect harness skills panel.

## Marketplace-installed skills (yesitsfebreeze plugins)

Some of these come bundled with plugins:

| Plugin | Bundles skill |
|---|---|
| `wiki@yesitsfebreeze` (kern) | wiki query skills |
| `vicky@yesitsfebreeze` | research-loop, vicky-commands |
| `git-fs@yesitsfebreeze` | git-fs skill |

Plugin uninstall removes its bundled skills.

## Audit / delete

See [../MAINTENANCE.md](../MAINTENANCE.md) — monthly section.

## Troubleshooting

- Skill doesn't fire → description lacks verbatim trigger phrase. Fix description first.
- Body too long → split to `references/<topic>.md`, body becomes index.
- Skill fires when it shouldn't → description too broad. Tighten trigger phrases.
- Marketplace-installed skill needs custom override → don't edit in `~/.claude/plugins/`; copy to `~/.claude/skills/<name>/` to shadow.

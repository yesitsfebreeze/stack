# Skills

Auto-loaded capability modules. Live in `~/.claude/skills/<name>/SKILL.md`.

## Anatomy

```
~/.claude/skills/myskill/
├── SKILL.md              # required — frontmatter + body
├── references/           # optional — overflow content
│   └── deep-topic.md
└── scripts/              # optional — executable helpers
    └── helper.sh
```

## SKILL.md format

```markdown
---
name: myskill
description: One-line trigger spec. MUST contain verbatim words user actually types. Triggers when user says "X", "Y", or asks about Z.
---

# Body

Instructions Claude follows when skill fires.
Cap: 5k tokens. Overflow → references/<topic>.md.
```

## Progressive disclosure

| Stage | Tokens |
|---|---|
| Boot: scan all skills' frontmatter | ~100 per skill |
| Trigger fires: load body | ≤5k |
| Reference file needed: explicit load | variable |

So: dozens of skills can be installed with negligible boot cost. Bloat hits only on trigger.

## Description rules

- Words user actually says **must appear verbatim**. "When user says X, Y, or Z."
- Bad: `description: A useful helper for common tasks`
- Good: `description: Use when user says "format JSON" or "pretty-print JSON"`

If skill doesn't fire when you think it should → fix description first.

## 2026 hygiene

- ≤12 active skills. More = context tax with no payoff.
- Body ≤5k tokens. Loaded content stays in context across turns.
- Monthly audit. Delete unfired-for-30-days.
- Global rules → CLAUDE.md.
- Domain workflows → skill.
- Big skill → split: SKILL.md is index, body in `references/`.

## When to write a new skill

- Recurring task with specialized steps (≥3 invocations expected)
- Trigger phrase clear and unambiguous
- Saves >100 tokens per invocation vs explaining each time

## When NOT to write a skill

- One-off task
- Trigger ambiguous (will fire wrong)
- Already covered by existing skill
- Trivial enough to live in CLAUDE.md

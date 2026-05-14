# Opt-in marker

Create `.stack` (empty file) in a project root to activate stack routing for that project.

```bash
touch .stack
```

When present, the `stack` plugin SessionStart hook injects a routing summary at every session start in that project. Without the marker, the hook is silent (zero context cost) and routing only engages when the user invokes a trigger phrase.

Alternative: set `STACK_ROUTING=1` in your shell env to opt in globally.

## Why a marker file

- Per-project, not per-machine — different projects can have different needs.
- Survives clones and CI — env vars don't.
- Discoverable via `ls`.

## Disable

Delete `.stack` or unset `STACK_ROUTING`. Hook output goes empty next session.

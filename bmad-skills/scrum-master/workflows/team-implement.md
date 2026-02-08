---
name: team-implement
description: "Scrum Master: Shortcut for /dev-sprint-auto --team. Forces team mode for parallel story implementation. See developer/workflows/dev-sprint-auto.md for the full workflow."
---

# Team Implement (Shortcut)

This is a **convenience shortcut** that forces team mode on `/dev-sprint-auto`.

**Equivalent to:** `/dev-sprint-auto --team`

## Redirect

Execute the `/dev-sprint-auto` workflow with `--team` flag forced:

1. Load and execute `developer/workflows/dev-sprint-auto.md`
2. Skip mode selection — go directly to **TEAM MODE**
3. All other options still apply (`--epic`, `--max`, `--no-merge`, `--dry-run`)

## When to Use This Shortcut

Use `/team-implement` when you know you want parallel team execution and don't want the mode selection prompt. Otherwise, just use `/dev-sprint-auto` — it will offer team mode automatically when appropriate.

See [dev-sprint-auto.md](../../developer/workflows/dev-sprint-auto.md) for the complete workflow documentation.

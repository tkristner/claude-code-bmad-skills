# BMAD Agent Teams Guide

BMAD leverages Claude Code's **Agent Teams** feature to upgrade existing commands with real multi-agent collaboration: inter-agent messaging, shared task lists, plan approval, and quality hooks.

**Design principle:** Team mode is integrated INTO existing commands, not added as separate commands. Each command auto-detects when teams add value and offers the upgrade transparently.

## How It Works

Every team-capable command follows this pattern:

```
User runs /dev-sprint-auto (or /research, /code-review, etc.)
    │
    ▼
Command checks: Teams available? Project level? Scope?
    │
    ├── Teams NOT available → subagent mode (transparent)
    ├── Teams available + scope too small → subagent mode (transparent)
    └── Teams available + scope justifies it → PROPOSES team mode
         │
         "I can run this as a team workflow:
          • N agents working in parallel
          • [specific team benefit]
          [T] Team (recommended) / [S] Standard"
```

No separate commands to learn. The same `/dev-sprint-auto` you already use becomes parallel when it makes sense.

## Team-Capable Commands

### Tier 1 — High Value (agents collaborate, challenge, coordinate)

| Command | Standard Mode | Team Mode | When Team Activates |
|---------|--------------|-----------|---------------------|
| **`/dev-sprint-auto`** | Sequential story loop | N parallel devs + reviewer + plan approval | 2+ independent stories |
| **`/research`** | Single-agent research | 4 adversarial researchers (Research → Challenge → Rebuttal) | Level 2+ or complex topic |
| **`/code-review`** | Single-perspective review | 3 specialists (security/perf/testing) + severity debate | Level 2+ or full codebase review |
| **`/architecture`** | Fan-out to files | Research best patterns + parallel component design + cross-review | Level 3+ or 4+ components |
| **`/create-epics-stories`** | Fan-out story writers | Parallel writers + live validator challenging FR coverage | Level 3+ or 4+ epics |
| **`/validate-prd`** | Sequential dimension checks | 3 parallel validators + synthesized report | Level 2+ |
| **`/check-implementation-readiness`** | Sequential category checks | 5 parallel checkers (PRD, Arch, Stories, Deps, Estimation) | Level 2+ |

### Tier 2 — Medium Value (parallel execution + task tracking)

| Command | Standard Mode | Team Mode | When Team Activates |
|---------|--------------|-----------|---------------------|
| **`/qa-automate`** | Sequential test generation | 3 parallel agents (Unit / API / E2E) | Large codebase or multi-module |
| **`/sprint-planning`** | Parallel section generation | 3 coordinated analysis agents | Level 3+ |
| **`/create-ux-design`** | Sequential 9-part process | 4 parallel designers (Flows / Wireframes / Accessibility / Components) | 4+ screens |
| **`/wcag-validate`** | Sequential WCAG categories | 4 parallel checkers (Perceivable / Operable / Understandable / Robust) | Full site audit |
| **`/generate-project-context`** | 10 sequential analysis steps | 4 parallel analyzers (Stack / Conventions / Tests / Patterns) | Large codebase |
| **`/prd`** | Sequential with user interaction | After interactive phase: 4 parallel section generators (FRs / NFRs / Epics / Personas) | Level 3+ |
| **`/api-docs`** | Sequential endpoint documentation | N parallel agents (1 per endpoint group) | 10+ endpoints |
| **`/architecture-docs`** | Sequential doc generation | 3 parallel agents (Overview / Components / ADRs) | 4+ components |

### Not Team-Capable (overhead exceeds benefit)

| Command | Reason |
|---------|--------|
| `/product-brief` | Interactive discovery with user, sequential by nature |
| `/tech-spec` | Lightweight, conversational, Level 0-1 scope |
| `/quick-spec`, `/quick-dev` | Quick by design — teams add latency |
| `/expedited-fix` | Emergency — speed over coordination |
| `/brainstorm` | Value is in synthesis, not parallel generation |
| `/retrospective` | Human facilitation, must follow conversational flow |
| `/dev-story` (single) | Single story — no parallelization benefit |
| `/readme`, `/changelog` | Simple single documents |
| `/workflow-init`, `/workflow-status` | Setup/check operations |

## Shortcut Commands

For power users who know they want team mode, these shortcuts force it:

| Shortcut | Equivalent |
|----------|-----------|
| `/team-research` | `/research --team` (forces team mode) |
| `/team-implement` | `/dev-sprint-auto --team` (forces team mode) |
| `/team-review` | `/code-review --team` (forces team mode) |

These exist for convenience. The underlying commands are identical.

## Key Team Workflows in Detail

### /dev-sprint-auto (Team Mode)

The most impactful team integration. Implements an entire sprint in parallel.

**Team:** Lead (delegate, never codes) + N dev agents (plan mode) + 1 reviewer

**Wave-based execution:**
```
Wave 1: Independent stories run in parallel
  dev-story-2-1 ──┐
  dev-story-2-2 ──┼── reviewer validates each
  dev-story-3-1 ──┘
         │
    merge all to develop
         │
Wave 2: Stories that depended on Wave 1
  dev-story-2-3 ──┐
  dev-story-3-2 ──┼── reviewer validates each
                  │
    merge all to develop
```

**Plan approval flow:** Each dev must submit an implementation plan before coding. Lead reviews for: AC coverage, TDD approach, security considerations, architecture conformance.

**Invoke:** `/dev-sprint-auto` (auto-offers team) or `/dev-sprint-auto --team` (forces team)

### /research (Team Mode)

**Team:** Lead (delegate) + 4 researchers (Market, Competitive, Technical, User)

**3-round adversarial process:**
1. **Research** — Each investigates their dimension independently
2. **Challenge** — Each challenges 2+ findings from other dimensions
3. **Rebuttal** — Each defends or revises their positions

**Output:** Confidence-rated findings with challenge/rebuttal audit trail

**Invoke:** `/research` (auto-offers team for Level 2+) or `/team-research` (forces team)

### /code-review (Team Mode)

**Team:** Lead (delegate) + Security reviewer + Performance reviewer + Testing reviewer

**2-phase process:**
1. **Independent review** — Each specialist reviews from their lens (min 3 findings each)
2. **Debate** — Reviewers discuss severity disagreements, identify cross-cutting concerns

**Output:** Consolidated report with severity consensus and prioritized action list

**Invoke:** `/code-review` (auto-offers team for full codebase reviews) or `/team-review` (forces team)

## Configuration

### Team Naming Convention

All BMAD teams: `bmad-{workflow}-{project_name}`

Examples: `bmad-implement-myapp`, `bmad-research-myapp`, `bmad-review-myapp`

This prefix is critical: BMAD hooks only activate for `bmad-*` teams.

### Hooks

| Hook | Trigger | Purpose | Exit Codes |
|------|---------|---------|------------|
| `bmad-teammate-idle.sh` | TeammateIdle | Check for unclaimed tasks | 0=idle OK, 2=keep working |
| `bmad-task-completed.sh` | TaskCompleted | Validate output quality + run tests | 0=allow, 2=reject |

**How hooks work:** Both hooks receive event data as JSON on **stdin** (fields: `team_name`, `teammate_name`, `task_id`, `task_subject`, etc.). On exit code 2, **stderr** is sent back to the agent as feedback. Requires `jq` for JSON parsing.

### Helper Operations

Team operations in `helpers.md`:
- `Check-Teams-Available` — detect if teams feature is accessible
- `Create-BMAD-Team` — create team with naming convention
- `Spawn-Teammate` — launch agent into team
- `Distribute-Tasks` — create and assign tasks via shared list
- `Collect-Team-Results` — monitor progress and gather outputs
- `Shutdown-Team` — graceful shutdown of all teammates

## Graceful Degradation

Every team-capable command falls back automatically when teams are unavailable:

| Command | Team Mode | Fallback |
|---------|-----------|----------|
| `/dev-sprint-auto` | Parallel devs + reviewer | Sequential story loop (original behavior) |
| `/research` | 4 adversarial researchers | Fan-Out Research (4 background agents, no challenge rounds) |
| `/code-review` | 3 specialist reviewers + debate | Single-agent adversarial review |
| `/architecture` | Research + parallel design + cross-review | Fan-Out Architecture (3 background agents) |
| `/create-epics-stories` | Parallel writers + validator | Fan-Out Story Generation |
| Others | Parallel execution with task tracking | Standard subagent patterns |

The fallback is transparent — no user action needed.

## Temporary Files

Team workflows use `accbmad/tmp/` for intermediate outputs (cleaned up on team shutdown):

| Workflow | Temp Files |
|----------|-----------|
| dev-sprint-auto | `implementation-review.md`, `sprint-implementation-summary.md` |
| research | `research-{dim}.md`, `challenge-{dim}.md`, `rebuttal-{dim}.md` |
| code-review | `review-{lens}.md`, `debate-{lens}.md` |

## Troubleshooting

### Team mode not offered
- Check project level (most commands require Level 2+)
- Verify Agent Teams feature is available in your Claude Code version
- Use `--team` flag to force team mode and see specific error

### Teammates not picking up tasks
- Check TaskList for unclaimed tasks
- Verify teammate was spawned with correct `team_name`
- TeammateIdle hook should auto-assign if unclaimed work exists

### Hook not triggering
- Verify hooks registered in `settings.json` (TeammateIdle, TaskCompleted)
- Check scripts are executable (`chmod +x`)
- Ensure team name starts with `bmad-` prefix

### Task completion rejected
- Check hook output for validation error
- Verify expected output files exist
- For dev tasks, ensure tests pass locally

## Integration with Existing BMAD

Agent Teams enhance but do not replace existing patterns:

- **`BMAD-SUBAGENT-PATTERNS.md`** — Still the reference for basic parallel execution (fallback mode)
- **`helpers.md`** — Team Operations section alongside Subagent Operations
- **`settings.json`** — Two hooks registered alongside existing session/tool hooks
- **Existing commands** — Same commands, smarter execution when teams are available

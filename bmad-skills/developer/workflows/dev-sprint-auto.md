---
name: dev-sprint-auto
description: "Developer: Autonomous sprint implementation. Implements all ready stories with auto code review and git management. When Agent Teams are available and multiple independent stories exist, launches parallel dev agents with a dedicated reviewer for dramatically faster sprint execution. Falls back to sequential mode otherwise."
---

# [Developer] Dev Sprint Auto Workflow

**Goal:** Autonomous sprint implementation — sequential or parallel with Agent Teams

**Phase:** 4 - Implementation (Autonomous Mode)

**Agent:** Developer (sequential mode) or Scrum Master lead + N dev agents + reviewer (team mode)

**Trigger keywords:** dev sprint auto, auto dev, autonomous dev, implement all stories, auto implement, sprint auto, continuous dev, team implement, parallel stories, parallel sprint, dev story auto

**Inputs:** Sprint status file with ready-for-dev stories

**Output:** Implemented stories with commits on develop branch

---

## When to Use

- Multiple stories ready for implementation
- Want hands-off development cycle
- Trust automated code review and fixes
- Clean sprint backlog ready to execute

**Invoke:** `/dev-sprint-auto` or `/dev-sprint-auto --team` or `/dev-sprint-auto --epic {N}` or `/dev-sprint-auto --max {N}`

---

## Command Options

| Option | Description | Example |
|--------|-------------|---------|
| (none) | All ready-for-dev stories, auto-detect mode | `/dev-sprint-auto` |
| `--team` | Force team mode (parallel agents) | `/dev-sprint-auto --team` |
| `--sequential` | Force sequential mode (classic loop) | `/dev-sprint-auto --sequential` |
| `--epic N` | Only stories from epic N | `/dev-sprint-auto --epic 2` |
| `--story ID` | Single specific story | `/dev-sprint-auto --story 2-3` |
| `--max N` | Maximum N stories then pause | `/dev-sprint-auto --max 3` |
| `--no-merge` | Commit but don't merge to develop | `/dev-sprint-auto --no-merge` |
| `--dry-run` | Show plan without executing | `/dev-sprint-auto --dry-run` |

---

## Pre-Flight (Both Modes)

1. **Load sprint status** - Read `accbmad/4-implementation/sprint.yaml`
2. **Verify git state** - Must be on develop, working tree clean
3. **Find ready stories** - Filter stories with status `ready-for-dev`
4. **Load project context** - Read `accbmad/3-solutioning/project-context.md` if exists
5. **Analyze dependencies** - Map story dependencies to identify independent vs blocked stories

**Pre-Flight Checks:**
```bash
# Must pass before starting
git status --porcelain  # Must be empty (clean)
git branch --show-current  # Must be "develop"
```

---

## Mode Selection

After pre-flight, determine execution mode:

```
1. Count independent stories (no unresolved dependencies on each other)
2. Count total ready stories

If --sequential flag → SEQUENTIAL MODE
If --story flag → SEQUENTIAL MODE (single story)
If --team flag → TEAM MODE (force)

If no flag specified:
  Check if Agent Teams available (TeamCreate, SendMessage, TaskCreate tools)

  If teams available AND independent_stories >= 2:
    → Propose team mode:

    "Found {total} stories ready, {independent} can run in parallel.

     I can execute this sprint in two modes:

     [T] Team mode (recommended) — {independent} dev agents work in parallel
         + dedicated reviewer giving real-time feedback
         + plan approval before each implementation
         + estimated ~{time_estimate}

     [S] Sequential mode — stories implemented one at a time
         + simpler, single-agent execution
         + estimated ~{time_estimate}

     Team mode is {N}x faster for {independent} independent stories."

  If teams not available OR independent_stories < 2:
    → SEQUENTIAL MODE (transparent, no question asked)
```

---

# SEQUENTIAL MODE (Classic)

The original autonomous loop — one story at a time.

## Sequential Workflow Loop

For each story in queue:

### Seq-Step 1: Prepare Git Branch

```bash
git checkout develop
git pull origin develop 2>/dev/null || true
git checkout -b story/{story-id}
```

**Branch naming:** `story/{epic}-{story}-{slug}`

### Seq-Step 2: Execute Dev-Story

Run the standard dev-story workflow:

1. Load story file from `accbmad/4-implementation/stories/{story-id}.md`
2. Implement all acceptance criteria
3. Write/update tests
4. Ensure all tests pass

### Seq-Step 3: Execute Code Review (Auto-Fix Mode)

Run adversarial code review with **automatic fix mode**:

1. Review all changes in current branch
2. Identify issues (security, quality, patterns)
3. **Automatically apply fixes** (no user prompt)
4. Re-verify after fixes

**Auto-Fix Rules:**
- Security issues: Fix immediately
- Code quality issues: Fix immediately
- Pattern violations: Fix immediately
- Style issues: Fix immediately

**Max fix iterations:** 3 — if still failing → HALT and notify user

### Seq-Step 4: Git Commit

```bash
git add -A
git commit -m "feat({scope}): {story-title}

Implements story {story-id}
- {acceptance-criteria-1}
- {acceptance-criteria-2}

Code-reviewed and auto-fixed.

Co-Authored-By: Claude <noreply@anthropic.com>"
```

### Seq-Step 5: Final Verification Code Review

Run a second code-review pass after commit to catch issues missed due to context limitations:

1. Re-read all changed files in the branch
2. Run code-review one more time (verification mode)
3. If new issues found: apply fixes, amend commit
4. If clean → proceed to merge

### Seq-Step 6: Merge to Develop

```bash
git checkout develop
git merge story/{story-id} --no-ff -m "Merge story/{story-id}: {title}"
git branch -d story/{story-id}
```

### Seq-Step 7: Update Sprint Status

Update `accbmad/4-implementation/sprint.yaml`:
```yaml
development_status:
  {story-id}: done  # was: ready-for-dev
```

### Seq-Step 8: Next Story or Complete

- **More stories:** Log `✓ Story {id} complete`, continue to Step 1
- **Queue empty:** Log summary, exit workflow

---

# TEAM MODE (Agent Teams)

Parallel implementation using Agent Teams. The lead coordinates, dev agents implement, a reviewer validates.

## Team-Step 1: Dependency Analysis

```
1. Parse all ready stories and their dependency fields
2. Build dependency graph:
   - Independent stories: can start immediately (parallel)
   - Dependent stories: must wait for their blockers
   - Dependency chains: ordered execution within chain
3. Group into waves:
   Wave 1: All independent stories (parallel)
   Wave 2: Stories blocked by Wave 1 (parallel after Wave 1)
   Wave N: Continue until all stories scheduled
4. Present execution plan to user for confirmation
```

**Example:**
```
Sprint Execution Plan (Team Mode):

Wave 1 (parallel):
  • STORY-2-1: User profile page (5 pts) — dev-story-2-1
  • STORY-2-2: Edit profile form (3 pts) — dev-story-2-2
  • STORY-3-1: Product listing (8 pts) — dev-story-3-1

Wave 2 (after Wave 1):
  • STORY-2-3: Password reset (5 pts) — blocked by 2-1
  • STORY-3-2: Product detail (5 pts) — blocked by 3-1

Team: 3 dev agents (Wave 1) + 1 reviewer
Proceed? [Y/n]
```

## Team-Step 2: Create Team

```
1. Load project config (helpers.md#Load-Project-Config)
2. TeamCreate(
     team_name: "bmad-implement-{project_name}",
     description: "Sprint implementation: {story_count} stories in {wave_count} waves"
   )
```

## Team-Step 3: Create Tasks for Wave 1

For each story in current wave:

```
TaskCreate(
  subject: "Implement {STORY-ID}: {title}",
  description: """
    Story file: accbmad/4-implementation/stories/{STORY-ID}.md
    Branch: story/{story-id}

    Implementation requirements:
    {acceptance_criteria}

    Technical context:
    {technical_notes from story}

    Definition of Done:
    - All acceptance criteria implemented
    - Tests written and passing (TDD: Red → Green → Refactor)
    - No linting errors
    - Security checklist passed
    - Code follows project conventions
    - Committed on story branch with conventional format

    Output: Code on branch story/{story-id}, ready for review
  """,
  activeForm: "Implementing {STORY-ID}"
)
```

Create review tasks (1 per story):
```
TaskCreate(
  subject: "Review {STORY-ID}: {title}",
  description: """
    Review branch story/{story-id} after dev completes implementation.

    Review checklist:
    - All acceptance criteria implemented
    - Tests exist and pass
    - Error handling appropriate
    - No security issues (OWASP Top 10)
    - Code follows project conventions
    - No hardcoded values or secrets
    - Edge cases handled

    Send findings to dev-{STORY-ID} via SendMessage.
    Must find minimum 3 issues (look harder if 0).
  """,
  activeForm: "Reviewing {STORY-ID}"
)
# Block review on implementation
TaskUpdate(taskId: review_task, addBlockedBy: [impl_task])
```

## Team-Step 4: Spawn Dev Agents

For each story in Wave 1:

```
Task(
  subagent_type: "general-purpose",
  team_name: "bmad-implement-{project_name}",
  name: "dev-{STORY-ID}",
  mode: "plan",
  prompt: """
    You are a developer on a BMAD sprint team implementing story {STORY-ID}.

    ## Your Assignment
    Implement story {STORY-ID}: {title}

    ## Setup
    1. Check TaskList and claim your implementation task
    2. Create your story branch:
       git checkout develop && git pull origin develop 2>/dev/null || true
       git checkout -b story/{story-id}

    ## Context (Read these first)
    - Story: accbmad/4-implementation/stories/{STORY-ID}.md
    - Architecture: accbmad/3-solutioning/architecture-*.md (if exists)
    - Project context: accbmad/3-solutioning/project-context.md (if exists)
    - Existing code patterns in the codebase

    ## Implementation Plan (Plan Mode)
    You are in plan mode. Before coding:
    1. Read all context files
    2. Analyze the story requirements
    3. Create an implementation plan covering:
       - Files to create/modify
       - TDD approach (which tests first)
       - Security considerations
       - Edge cases
    4. Submit plan for approval
    5. Wait for lead's approval before implementing

    ## After Plan Approval — Implement with TDD
    1. RED: Write failing tests for each acceptance criterion
    2. GREEN: Implement minimal code to pass tests
    3. REFACTOR: Clean up while keeping tests green
    4. Run full test suite — zero failures allowed
    5. Security checklist:
       - [ ] Inputs validated and sanitized
       - [ ] No injection vectors (SQL, XSS, command)
       - [ ] Auth/authz checked where required
       - [ ] No secrets hardcoded
       - [ ] Error messages don't leak internals
    6. Git commit with conventional format:
       git add -A
       git commit -m "feat({scope}): {title}

       Implements story {STORY-ID}
       Co-Authored-By: Claude <noreply@anthropic.com>"

    ## After Implementation
    1. Mark your implementation task as completed
    2. Wait for reviewer feedback via messages
    3. If reviewer sends findings:
       - Address all Must Fix items
       - Re-run tests
       - Amend commit
       - Notify reviewer via SendMessage that fixes are applied

    ## Rules
    - NEVER skip writing tests
    - NEVER mark done without all tests passing
    - Follow existing code conventions strictly
    - Minimum code to satisfy requirements — no over-engineering
  """
)
```

## Team-Step 5: Spawn Reviewer Agent

```
Task(
  subagent_type: "general-purpose",
  team_name: "bmad-implement-{project_name}",
  name: "reviewer",
  mode: "default",
  prompt: """
    You are the code reviewer on a BMAD sprint implementation team.

    ## Your Role
    Review each story implementation as devs complete them.
    You are adversarial — assume there ARE bugs. Finding 0 issues means you
    didn't look hard enough. Minimum 3 findings per story.

    ## Workflow
    1. Check TaskList for review tasks that are unblocked (implementation complete)
    2. Claim the review task
    3. For the story:
       a. Read the story file for acceptance criteria
       b. Check out the story branch: git log story/{id}..develop, git diff develop...story/{id}
       c. Read all changed/new files
       d. Review against checklist below
    4. Send findings to dev via SendMessage:

       "## Code Review: {STORY-ID}

       | # | Severity | Issue | Location | Fix |
       |---|----------|-------|----------|-----|
       | F1 | {sev} | {issue} | {file:line} | {suggestion} |

       Must Fix: {count}
       Should Fix: {count}
       Nice to Have: {count}

       Please address Must Fix items and notify me when done."

    5. After dev applies fixes:
       - Re-review the fixed code
       - If satisfactory, mark review task as completed
       - If not, send another round (max 3 iterations, then escalate)

    ## Review Checklist
    - [ ] All acceptance criteria implemented (compare to story file)
    - [ ] Tests exist for each AC (TDD evidence)
    - [ ] Error handling covers failure paths
    - [ ] No security issues (OWASP Top 10 scan)
    - [ ] Input validation on all external data
    - [ ] No hardcoded secrets or credentials
    - [ ] Code matches project conventions
    - [ ] No debug code, console.logs, TODOs left
    - [ ] Edge cases handled (null, empty, boundary)
    - [ ] Performance: no N+1 queries, no unbounded loops

    ## Severity Definitions
    - **Must Fix:** Security issue, missing AC, broken functionality
    - **Should Fix:** Code quality, missing edge case, weak test
    - **Nice to Have:** Style, naming, minor optimization
  """
)
```

## Team-Step 6: Manage Plan Approvals

As dev agents submit implementation plans:

```
For each plan_approval_request received:
  1. Review the plan:
     - Does it cover all acceptance criteria from the story?
     - Is the TDD approach clear (which tests first)?
     - Are security considerations addressed?
     - Does it follow architecture and project conventions?
     - Is scope appropriate (no over-engineering)?

  2. If plan is good:
     SendMessage(
       type: "plan_approval_response",
       request_id: "{id}",
       recipient: "dev-{STORY-ID}",
       approve: true
     )

  3. If plan needs work:
     SendMessage(
       type: "plan_approval_response",
       request_id: "{id}",
       recipient: "dev-{STORY-ID}",
       approve: false,
       content: "{specific feedback — what to add/change/remove}"
     )

     Max 3 rejections per story. After 3 → escalate to user.
```

## Team-Step 7: Monitor and Coordinate

```
Loop:
  status = TaskList()

  # Track wave progress
  wave_complete = all Wave N implementation + review tasks done

  # When a dev completes implementation:
  #   → The review task auto-unblocks
  #   → Reviewer picks it up

  # When reviewer completes review:
  #   → Story is ready for merge

  # Process teammate messages:
  #   → Plan approval requests
  #   → Review feedback relays
  #   → Blocker notifications

  # When entire wave complete:
  if wave_complete:
    # Merge all reviewed stories to develop (sequential to avoid conflicts)
    For each completed story in wave:
      git checkout develop
      git merge story/{story-id} --no-ff -m "Merge story/{story-id}: {title}"
      git branch -d story/{story-id}
      Update sprint.yaml: {story-id} → done

    # Start next wave if stories remain
    if next_wave_exists:
      Create tasks for next wave (Team-Step 3)
      Spawn new dev agents for new stories
      continue
    else:
      break  # All waves complete

  continue
```

## Team-Step 8: Sprint Completion

```
1. Verify all stories done in sprint.yaml
2. Generate sprint summary:
   - Stories implemented: {count}
   - Total story points: {points}
   - Team size: {N} devs + 1 reviewer
   - Execution time: {duration}
   - Review findings: {total_findings} ({must_fix} must-fix, all resolved)

3. Shutdown team:
   For each teammate:
     SendMessage(type: "shutdown_request", recipient: "{name}")
   Wait for confirmations

4. Clean up:
   - Remove temp files from accbmad/tmp/
   - Update workflow status (helpers.md#Update-Workflow-Status)
```

---

## Progress Display

### Sequential Mode
```
╔══════════════════════════════════════════════════════════════╗
║  DEV-SPRINT-AUTO: Sprint Progress (Sequential)               ║
╠══════════════════════════════════════════════════════════════╣
║  Stories: 2/5 complete                                       ║
║  Current: 2-3-password-reset                                 ║
║  Phase:   Code Review (fix iteration 1/3)                    ║
╠══════════════════════════════════════════════════════════════╣
║  ✓ 2-1-profile-page         [done]                          ║
║  ✓ 2-2-edit-profile         [done]                          ║
║  → 2-3-password-reset       [in-progress]                   ║
║  ○ 2-4-account-settings     [queued]                        ║
║  ○ 2-5-user-preferences     [queued]                        ║
╚══════════════════════════════════════════════════════════════╝
```

### Team Mode
```
╔══════════════════════════════════════════════════════════════╗
║  DEV-SPRINT-AUTO: Sprint Progress (Team Mode)                 ║
╠══════════════════════════════════════════════════════════════╣
║  Wave 1/2: 3 stories in parallel                             ║
║  Team: 3 devs + 1 reviewer                                  ║
╠══════════════════════════════════════════════════════════════╣
║  Wave 1:                                                     ║
║  ✓ 2-1-profile-page         [dev: done, review: done]       ║
║  → 2-2-edit-profile         [dev: done, review: in-progress]║
║  → 3-1-product-listing      [dev: implementing, review: —]  ║
║                                                               ║
║  Wave 2 (waiting):                                           ║
║  ○ 2-3-password-reset       [blocked by 2-1]                ║
║  ○ 3-2-product-detail       [blocked by 3-1]                ║
╚══════════════════════════════════════════════════════════════╝
```

---

## HALT Conditions (Both Modes)

| Condition | Message | Recovery |
|-----------|---------|----------|
| Git not clean | "Working tree has uncommitted changes." | Commit or stash changes |
| Not on develop | "Must start from develop branch." | `git checkout develop` |
| No ready stories | "No stories with status 'ready-for-dev'." | Update sprint status |
| Code review fails 3x | "Story {id} failed code review after 3 fix attempts." | Manual intervention |
| Tests failing | "Tests failing after implementation." | Manual fix required |
| Merge conflict | "Merge conflict on story {id}." | Manual resolution |
| Story file missing | "Cannot find story file: {path}" | Create story file |
| Plan rejected 3x (team) | "Story {id} plan rejected 3 times." | User provides guidance |
| Circular dependency | "Circular dependency detected: {chain}" | Fix story dependencies |

## Recovery After HALT

If workflow halts mid-sprint:

1. Fix the blocking issue manually
2. Resume with: `/dev-sprint-auto --story {failed-story-id}`
3. Or skip and continue: update sprint status, then `/dev-sprint-auto`

---

## Example Sessions

### Sequential Mode
```
User: /dev-sprint-auto --epic 2

Developer:
Starting autonomous development for Epic 2...

Pre-flight: ✓ clean ✓ develop ✓ sprint loaded ✓ context loaded
Found 4 stories ready. 2 independent, 2 dependent.

Agent Teams not available — running in sequential mode.

Starting story 2-1-profile-page...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Git] Branch: story/2-1-profile-page
[Dev] Implementing acceptance criteria...
[Dev] Tests: 12/12 passing
[Review] 3 issues found, auto-fixing...
[Review] All resolved ✓
[Git] Committed + merged to develop
[Status] 2-1-profile-page → done
✓ Complete (4m 32s)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Starting story 2-2-edit-profile...
...
```

### Team Mode
```
User: /dev-sprint-auto --team

Developer:
Starting autonomous development...

Pre-flight: ✓ clean ✓ develop ✓ sprint loaded ✓ context loaded
Found 5 stories ready. 3 independent (Wave 1), 2 dependent (Wave 2).

Sprint Execution Plan (Team Mode):

Wave 1 (parallel):
  • STORY-2-1: User profile page (5 pts)
  • STORY-2-2: Edit profile form (3 pts)
  • STORY-3-1: Product listing (8 pts)

Wave 2 (after Wave 1):
  • STORY-2-3: Password reset (5 pts) — blocked by 2-1
  • STORY-3-2: Product detail (5 pts) — blocked by 3-1

Team: 3 dev agents + 1 reviewer
Proceed? [Y]

Creating team bmad-implement-myapp...
Spawning dev-story-2-1, dev-story-2-2, dev-story-3-1, reviewer...

[dev-story-2-1] Plan submitted → Approved ✓
[dev-story-2-2] Plan submitted → Approved ✓
[dev-story-3-1] Plan submitted → Revised (missing auth check) → Approved ✓

[dev-story-2-1] Implementation complete, reviewer notified
[reviewer → dev-story-2-1] 4 findings (1 must-fix, 2 should-fix, 1 nice-to-have)
[dev-story-2-1] Fixes applied ✓
[reviewer] Review passed ✓

[dev-story-2-2] Implementation complete → Review → 3 findings → Fixed → Passed ✓

[dev-story-3-1] Implementation complete → Review → 5 findings → Fixed → Passed ✓

Wave 1 complete! Merging to develop...
✓ story/2-1 merged
✓ story/2-2 merged
✓ story/3-1 merged

Starting Wave 2...
Spawning dev-story-2-3, dev-story-3-2...
...

═══════════════════════════════════════
Sprint Complete! (Team Mode)

Stories: 5/5 ✓
Points: 26 pts
Team: 3 devs + 1 reviewer
Duration: 12m 18s (vs ~25m sequential)
Findings: 19 total, all resolved
═══════════════════════════════════════
```

---

## Integration

**Requires:**
- `accbmad/4-implementation/sprint.yaml` with story statuses
- `accbmad/4-implementation/stories/{story-id}.md` for each story
- Clean git repository on develop branch

**Calls internally:**
- `/dev-story` workflow (per story, in sequential mode)
- `/code-review` workflow (with auto-fix flag, in sequential mode)
- Agent Teams tools (TeamCreate, TaskCreate, SendMessage, in team mode)

**Updates:**
- `accbmad/4-implementation/sprint.yaml` (story status → done)
- Git branches and commits

---

## Notes for Claude

**CRITICAL - THIS IS A LOOP:**
- You MUST continue processing stories until ALL pending stories are done
- Do NOT stop after completing one story
- Do NOT ask user "should I continue?" — just continue automatically
- The only valid stop conditions are: no more stories, HALT condition, or --max limit

**MANDATORY CODE REVIEW (MUST FIND ISSUES):**
- You MUST run adversarial code review on EVERY story before committing
- You MUST find at least 3 issues — if you find 0, review harder
- "Code looks clean" is NOT acceptable — that means you didn't look hard enough
- Auto-fix all issues, then verify fixes worked
- In team mode, the reviewer agent handles this with same standards

**MODE SELECTION:**
- Default: auto-detect (teams available + 2+ independent stories → offer team mode)
- `--team`: force team mode (fail if teams unavailable)
- `--sequential`: force sequential mode (ignore teams)
- `--story X`: always sequential (single story)

**TEAM MODE SPECIFICS:**
- Lead NEVER writes code — only coordinates, approves plans, merges
- Each dev agent gets plan mode — must get approval before implementing
- Reviewer must find minimum 3 issues per story
- Merges happen wave-by-wave (sequential within wave to avoid conflicts)
- Dev agents rebase if develop has moved since branch creation

**GIT SAFETY:**
- Always verify clean state before starting
- Use `--no-ff` merges to preserve history
- Delete story branches after successful merge
- Never force push or rewrite history
- In team mode, only the lead merges to develop

**PROGRESS TRACKING:**
- Update sprint.yaml after EACH story completion (not at end)
- In team mode, update after each wave merge
- Show clear progress indicators throughout

**REMEMBER: After completing a story (or wave), IMMEDIATELY start the next one. Do not stop.**

---

*Generated by BMAD Method - Developer Skill (v1.6.0 with Agent Teams)*

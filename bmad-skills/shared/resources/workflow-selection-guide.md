# BMAD Workflow Selection Guide

This guide helps you choose the right BMAD workflow for your task. When in doubt, use `/workflow-status` to see recommendations based on your project's current phase.

---

## Quick Reference

| I want to... | Use this workflow | Phase |
|--------------|-------------------|-------|
| Initialize BMAD in a project | `/workflow-init` | Setup |
| Check project progress | `/workflow-status` | Any |
| Validate phase transition | `/validate-phase-transition` | Any |
| Define product vision | `/product-brief` | 1 |
| Generate creative ideas | `/brainstorm` | 1 |
| Gather market/user evidence | `/research` | 1 |
| Document full product requirements | `/prd` | 2 |
| Quick spec for small change | `/quick-spec` | 2 |
| Technical specification | `/tech-spec` | 2 |
| Create UX wireframes/flows | `/create-ux-design` | 2 |
| Validate PRD quality | `/validate-prd` | 2 |
| Design system architecture | `/architecture` | 3 |
| Quick implementation readiness check | `/solutioning-gate-check` | 3 |
| Comprehensive pre-implementation validation | `/check-implementation-readiness` | 3 |
| Plan sprints from requirements | `/sprint-planning` | 4 |
| Create all stories from PRD | `/create-epics-stories` | 4 |
| Create single detailed story | `/create-story` | 4 |
| Implement a story (full TDD) | `/dev-story` | 4 |
| Quick fix without ceremony | `/quick-dev` | 4 |
| Fix urgent production issue | `/expedited-fix` | 4 |
| Review code quality | `/code-review` | 4 |
| Generate test coverage | `/qa-automate` | 4 |
| Sprint retrospective | `/retrospective` | 4 |
| Generate AI context file | `/generate-project-context` | Any |

---

## Decision Trees

### Requirements Workflow Selection

```
Is it a bug fix or tiny change (< 1 day)?
├── Yes → /quick-spec + /quick-dev
└── No → How complex is it?
    ├── 1-3 features, clear scope → /tech-spec
    │   └── Level 1 project
    └── 4+ features, multiple users → /prd
        └── Level 2-4 project
            └── Then → /architecture (if Level 2+)
```

**Key Differences:**

| Aspect | /quick-spec | /tech-spec | /prd |
|--------|-------------|------------|------|
| **Scope** | Single change | Technical details | Full product |
| **Duration** | 15-30 min | 30-60 min | 1-2 hours |
| **Output** | Mini spec | Technical specification | PRD document |
| **Best for** | Bug fixes, tweaks | API design, algorithms | New products, features |
| **Project Level** | 0-1 | 1-3 | 2-4 |
| **Includes** | Problem, solution, tests | Implementation details | FRs, NFRs, Epics |

---

### Story Creation Selection

```
Do you have a PRD with epics defined?
├── Yes → /create-epics-stories (bulk creation)
│   └── Then → /create-story (for details on each)
└── No →
    ├── Small project (Level 0-1) → /create-story directly
    └── Large project (Level 2+) → /prd first
```

**Key Differences:**

| Aspect | /create-epics-stories | /create-story |
|--------|----------------------|---------------|
| **Input** | PRD with epics | Single requirement |
| **Output** | All stories for all epics | One detailed story |
| **When** | After PRD completion | Backlog refinement |
| **Detail level** | High-level stories | Full acceptance criteria |
| **Typical count** | 10-50 stories | 1 story |
| **Sprint planning** | Creates initial backlog | Adds to existing backlog |

---

### Implementation Selection

```
Do you have a formal story in sprint?
├── Yes → /dev-story STORY-XXX
│   └── Full TDD cycle with code review
└── No →
    ├── Bug fix or hotfix → /quick-dev
    ├── Exploratory coding → /quick-dev
    └── Need a story first → /create-story
```

**Key Differences:**

| Aspect | /dev-story | /quick-dev |
|--------|-----------|------------|
| **Input** | Story file from sprint | Problem description |
| **Process** | Full TDD, review, validation | Rapid implementation |
| **Testing** | Comprehensive test suite | Basic tests |
| **Tracking** | Updates sprint status | No status tracking |
| **Best for** | Sprint work | Hotfixes, experiments |
| **Code review** | Built-in (Step 8) | Optional |

---

### Research vs Brainstorm

```
What's your goal?
├── Generate new ideas → /brainstorm
│   └── Techniques: SCAMPER, Mind Map, Six Thinking Hats
├── Validate assumptions with data → /research
│   └── Techniques: Market analysis, competitive analysis
└── Both → /brainstorm first, then /research to validate
```

**Key Differences:**

| Aspect | /brainstorm | /research |
|--------|-------------|-----------|
| **Goal** | Generate ideas | Gather evidence |
| **Output** | Ideas, concepts, possibilities | Data, insights, validation |
| **Methods** | SCAMPER, Mind Mapping, SWOT | Market analysis, user interviews |
| **Mindset** | Divergent thinking | Convergent analysis |
| **Best for** | "What could we build?" | "What should we build?" |
| **Phase** | Early exploration | Validation, planning |

---

### Validation Workflow Selection

```
What phase are you in?
├── Phase 2 (Planning) → /validate-prd
│   └── Checks: Completeness, testability, clarity
├── Phase 3 (Solutioning) →
│   ├── Quick check → /solutioning-gate-check
│   └── Comprehensive → /check-implementation-readiness
│       └── Includes: PRD, Architecture, Coverage, Dependencies, Estimates
└── Unsure → /workflow-status for recommendations
```

**Key Differences:**

| Aspect | /validate-prd | /solutioning-gate-check | /check-implementation-readiness |
|--------|---------------|-------------------------|--------------------------------|
| **When** | After writing PRD | Quick Phase 3 check | Final pre-implementation gate |
| **Validates** | PRD quality | Basic readiness | 5 validation categories |
| **Checks** | Completeness, testability | Architecture exists | PRD, Arch, FR Coverage, Deps, Estimates |
| **Output** | Issues to fix in PRD | Basic Go/No-Go | Detailed readiness report |
| **Duration** | 10-15 min | 5-10 min | 15-30 min |
| **Best for** | PRD refinement | Quick sanity check | Before Sprint 1 commitment |

---

### Code Review Selection

```
Are you implementing a story?
├── Yes → /dev-story (includes review in Step 8)
│   └── Want extra review? → /code-review after
└── No → /code-review standalone
    └── Use for: PR review, security audit, legacy code
```

**When to use standalone /code-review:**
- Reviewing someone else's PR
- Security audit of existing code
- Legacy code assessment
- Pre-release quality check

---

## Common Workflow Patterns

### Pattern 1: New Product Development (Level 3-4)

```
Phase 1: Analysis
├── /product-brief - Vision and scope
├── /brainstorm - Feature ideation
└── /research - Market validation

Phase 2: Planning
├── /prd - Full requirements
├── /create-ux-design - User experience
└── /validate-prd - Quality check

Phase 3: Solutioning
├── /architecture - System design
├── /solutioning-gate-check - Quick readiness check
└── /check-implementation-readiness - Final comprehensive gate

Phase 4: Implementation
├── /sprint-planning - Plan sprints
├── /create-epics-stories - Generate stories
├── /dev-story (per story) - Implement
└── /retrospective (per sprint) - Learn
```

### Pattern 2: Feature Addition (Level 1-2)

```
/tech-spec - Technical requirements
    └── /create-story - Single story (or few stories)
        └── /dev-story - Implement
            └── /code-review (optional extra review)
```

### Pattern 3: Bug Fix (Level 0)

```
/quick-spec - Document the fix
    └── /quick-dev - Implement
        └── /code-review (optional validation)
```

### Pattern 4: Hotfix (Emergency)

```
/quick-dev - Fix immediately
    └── /code-review - Post-fix validation
```

---

## Project Level Guide

| Level | Scope | Typical Stories | Required Workflows |
|-------|-------|-----------------|-------------------|
| 0 | Single atomic change | 1 | `/quick-spec` + `/quick-dev` |
| 1 | Small feature | 1-10 | `/tech-spec` + `/dev-story` |
| 2 | Medium feature set | 5-15 | `/prd` + `/architecture` + full Phase 4 |
| 3 | Complex integration | 12-40 | All phases recommended |
| 4 | Enterprise expansion | 40+ | All phases required |

---

## Anti-Patterns to Avoid

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| Skipping `/prd` for Level 2+ | Missing requirements later | Take time for proper planning |
| Using `/dev-story` without story file | No tracking, unclear scope | Use `/quick-dev` or create story first |
| `/brainstorm` without `/research` | Untested assumptions | Validate ideas before building |
| Multiple `/quick-dev` instead of proper stories | Technical debt, no visibility | Plan properly for multi-change work |
| Skipping `/validate-prd` | Quality issues in requirements | Always validate before architecture |

---

## Tips

1. **When unsure, start with `/workflow-status`** - It shows your project phase and recommends next steps

2. **Match workflow to project level** - Don't over-engineer Level 0-1 with full ceremonies; don't under-plan Level 3-4

3. **Workflows are composable** - You can always add more rigor (e.g., `/code-review` after `/dev-story`)

4. **Phase gates are checkpoints** - `/validate-prd` and `/solutioning-gate-check` prevent issues downstream

5. **Use Quick Flow for speed** - `/quick-spec` + `/quick-dev` is ideal for small changes

---

*Generated by BMAD Method - For workflow details, see individual skill documentation*

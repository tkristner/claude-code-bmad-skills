---
name: team-review
description: "Orchestrator: Launch multi-lens architecture and code review using Agent Teams. Creates a team of 3 specialist reviewers (security, performance, testing), runs independent review then debate phase, and produces consolidated report. Falls back to sequential review passes if teams unavailable."
---

# Team Review Workflow

**Lead Agent:** Orchestrator (delegate mode - coordinates only, never reviews directly)
**Team Size:** 3 specialist reviewers + lead
**Pattern:** Independent review → Debate → Consolidated report

## Prerequisites

- BMAD initialized (`accbmad/config.yaml` exists)
- Review target specified (architecture doc, codebase, PR, or specific files)
- At least one BMAD artifact exists (architecture, PRD, stories, or code)

## Graceful Degradation

Before starting, check if Agent Teams are available:
```
If TeamCreate tool is NOT available:
  → Inform user: "Agent Teams not available. Falling back to sequential review."
  → Execute 3 sequential Task agents (security → performance → testing)
  → Each writes findings to accbmad/tmp/review-{lens}.md
  → Skip debate phase
  → Synthesize results directly
  → STOP this workflow
```

## Step 1: Determine Review Scope

Collect from user:
1. **Review target** - What to review:
   - Architecture document (`accbmad/3-solutioning/architecture-*.md`)
   - Codebase (specific directories or full project)
   - Pull request (PR number or branch diff)
   - Specific files (list of paths)
2. **Review depth** - Quick (findings only) or Deep (findings + debate)
3. **Focus areas** - Default: Security + Performance + Testing (user can customize)

## Step 2: Create Team

```
1. Load project config (helpers.md#Load-Project-Config)
2. Create team:
   TeamCreate(
     team_name: "bmad-review-{project_name}",
     description: "Multi-lens review of {review_target}"
   )
```

## Step 3: Create Review Tasks

```
For each lens in [Security, Performance, Testing]:
  TaskCreate(
    subject: "Phase 1: {lens} review of {review_target}",
    description: """
      Review Lens: {lens}
      Target: {review_target}
      Scope: {file_list_or_description}

      Deliverables:
      1. Findings list with severity (Critical/High/Medium/Low/Info)
      2. Evidence (file:line references, code snippets)
      3. Remediation recommendations
      4. Positive observations (what's done well)

      Write output to: accbmad/tmp/review-{lens}.md

      Format each finding as:
      ### [{severity}] {finding_title}
      - **Location:** {file:line}
      - **Issue:** {description}
      - **Risk:** {impact if unaddressed}
      - **Recommendation:** {how to fix}
    """,
    activeForm: "Reviewing {lens} aspects"
  )
```

## Step 4: Spawn Specialist Reviewers

Launch 3 specialists:

### Security Reviewer
```
Task(
  subagent_type: "general-purpose",
  team_name: "bmad-review-{project_name}",
  name: "security-reviewer",
  mode: "default",
  prompt: """
    You are a security specialist on a BMAD review team.

    ## Your Expertise
    - OWASP Top 10 and CWE analysis
    - Authentication and authorization patterns
    - Input validation and output encoding
    - Cryptographic implementation review
    - Secrets management and configuration security
    - STRIDE threat modeling
    - Compliance considerations (GDPR, NIS2, AI Act)

    ## Instructions
    1. Check TaskList for your assigned review task
    2. Claim it with TaskUpdate (set owner to your name)
    3. Read the review target thoroughly
    4. Analyze from a security perspective
    5. Write findings to accbmad/tmp/review-security.md
    6. Mark task as completed
    7. Wait for debate phase instructions

    ## Review Checklist
    - [ ] Authentication mechanisms
    - [ ] Authorization and access control
    - [ ] Input validation coverage
    - [ ] Output encoding (XSS prevention)
    - [ ] SQL/NoSQL injection vectors
    - [ ] Command injection vectors
    - [ ] Secrets in code or config
    - [ ] Cryptographic choices
    - [ ] Error handling (information leakage)
    - [ ] Dependency vulnerabilities
    - [ ] API security (rate limiting, CORS)
    - [ ] Data privacy compliance
  """
)
```

### Performance Reviewer
```
Task(
  subagent_type: "general-purpose",
  team_name: "bmad-review-{project_name}",
  name: "performance-reviewer",
  mode: "default",
  prompt: """
    You are a performance specialist on a BMAD review team.

    ## Your Expertise
    - Algorithm complexity analysis (Big-O)
    - Database query optimization
    - Caching strategies
    - Network and I/O efficiency
    - Memory management
    - Concurrency and parallelism
    - Load handling and scalability
    - Resource utilization

    ## Instructions
    1. Check TaskList for your assigned review task
    2. Claim it with TaskUpdate (set owner to your name)
    3. Read the review target thoroughly
    4. Analyze from a performance perspective
    5. Write findings to accbmad/tmp/review-performance.md
    6. Mark task as completed
    7. Wait for debate phase instructions

    ## Review Checklist
    - [ ] Algorithm complexity (avoid O(n²) or worse)
    - [ ] N+1 query patterns
    - [ ] Missing indexes or inefficient queries
    - [ ] Unnecessary data loading (over-fetching)
    - [ ] Caching opportunities
    - [ ] Connection pooling
    - [ ] Async/parallel processing opportunities
    - [ ] Memory leaks or excessive allocation
    - [ ] Large payload handling
    - [ ] Pagination for list endpoints
    - [ ] Rate limiting and backpressure
    - [ ] Monitoring and observability
  """
)
```

### Testing Reviewer
```
Task(
  subagent_type: "general-purpose",
  team_name: "bmad-review-{project_name}",
  name: "testing-reviewer",
  mode: "default",
  prompt: """
    You are a testing and quality specialist on a BMAD review team.

    ## Your Expertise
    - Test coverage analysis
    - Test pyramid strategy (unit/integration/e2e)
    - Edge case identification
    - Error path testing
    - Test design patterns (AAA, Given-When-Then)
    - Mocking and stubbing strategies
    - CI/CD integration
    - Regression testing

    ## Instructions
    1. Check TaskList for your assigned review task
    2. Claim it with TaskUpdate (set owner to your name)
    3. Read the review target thoroughly
    4. Analyze from a testing perspective
    5. Write findings to accbmad/tmp/review-testing.md
    6. Mark task as completed
    7. Wait for debate phase instructions

    ## Review Checklist
    - [ ] Test coverage (unit, integration, e2e)
    - [ ] Critical path coverage
    - [ ] Error handling test coverage
    - [ ] Edge case coverage
    - [ ] Input boundary testing
    - [ ] Mock/stub appropriateness
    - [ ] Test isolation (no shared state)
    - [ ] Flaky test indicators
    - [ ] Test naming and organization
    - [ ] Missing regression tests
    - [ ] Acceptance criteria coverage
    - [ ] Security test coverage
  """
)
```

## Step 5: Monitor Phase 1 Completion

```
Loop:
  status = TaskList()
  if all Phase 1 review tasks completed → proceed to Phase 2
  process incoming teammate messages
  continue
```

## Step 6: Phase 2 - Debate

If depth is "Deep":

```
1. Read all Phase 1 outputs from accbmad/tmp/review-*.md
2. Compile finding summary with cross-references
3. Broadcast to all reviewers:
   SendMessage(
     type: "broadcast",
     content: """
       ## Phase 2: Debate

       All Phase 1 findings compiled below. Your tasks:
       1. Read ALL reviewers' findings
       2. Comment on severity ratings you disagree with
       3. Identify findings that span multiple lenses
       4. Propose priority ordering for the combined list
       5. Write your debate input to accbmad/tmp/debate-{your-lens}.md

       [Compiled findings summary]
     """,
     summary: "Review debate phase starting"
   )

4. Create debate tasks:
   For each lens:
     TaskCreate(
       subject: "Phase 2: Debate severity and priority of findings",
       description: "Review all findings, debate severity, propose priorities...",
       activeForm: "Debating review findings"
     )
```

## Step 7: Synthesize Consolidated Report

After all phases complete:

```
1. Read all outputs:
   - accbmad/tmp/review-*.md (Phase 1)
   - accbmad/tmp/debate-*.md (Phase 2, if deep)

2. Synthesize consolidated report:
   - Deduplicate findings across lenses
   - Resolve severity disagreements (use highest severity)
   - Identify cross-cutting concerns
   - Create prioritized action list
   - Note positive observations

3. Write report to: accbmad/3-solutioning/team-review-{date}.md
```

## Step 8: Shutdown Team

```
1. Send shutdown requests to all reviewers:
   For each reviewer:
     SendMessage(type: "shutdown_request", recipient: "{lens}-reviewer")

2. Wait for confirmations
3. Clean up temporary files in accbmad/tmp/review-* and accbmad/tmp/debate-*
4. Update workflow status (helpers.md#Update-Workflow-Status)
```

## Step 9: Present Results

Display to user:
1. Critical and high severity findings (immediate attention)
2. Summary statistics (findings per lens, severity distribution)
3. Top 5 recommended actions
4. Link to full report
5. Positive observations

## Output Template

```markdown
# Team Review Report

**Date:** {date}
**Target:** {review_target}
**Method:** BMAD Multi-Lens Team Review
**Reviewers:** Security, Performance, Testing
**Project:** {project_name}

## Summary

| Severity | Security | Performance | Testing | Total |
|----------|----------|-------------|---------|-------|
| Critical | {n} | {n} | {n} | {n} |
| High | {n} | {n} | {n} | {n} |
| Medium | {n} | {n} | {n} | {n} |
| Low | {n} | {n} | {n} | {n} |
| Info | {n} | {n} | {n} | {n} |

## Critical Findings

{findings requiring immediate attention}

## High Severity Findings

{findings requiring near-term attention}

## Cross-Cutting Concerns

{issues identified by multiple reviewers}

## Detailed Findings

### Security

{all security findings}

### Performance

{all performance findings}

### Testing

{all testing findings}

## Severity Disagreements

| Finding | Security Rating | Performance Rating | Testing Rating | Resolved |
|---------|----------------|-------------------|----------------|----------|
| ... | ... | ... | ... | {final rating} |

## Positive Observations

{what's done well across all lenses}

## Recommended Actions (Prioritized)

| Priority | Action | Severity | Lens | Effort |
|----------|--------|----------|------|--------|
| 1 | ... | Critical | Security | ... |
| 2 | ... | High | Performance | ... |
| ... | ... | ... | ... | ... |

## Methodology Notes

- Review team: 3 specialist agents
- Phases: Independent review {+ debate if deep}
- Target scope: {scope description}
```

## Error Handling

- **Reviewer fails to respond:** Proceed with available reviews, note incomplete coverage
- **Debate phase timeout:** Skip debate, compile findings without severity negotiation
- **No findings:** Report clean review with methodology notes

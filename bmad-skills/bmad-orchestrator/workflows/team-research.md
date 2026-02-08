---
name: team-research
description: "Orchestrator: Launch adversarial multi-perspective research using Agent Teams. Creates a team of 4 researchers with different dimensions, runs 3 rounds (Research → Challenge → Rebuttal), and synthesizes a consolidated report. Falls back to subagent Fan-Out Research if teams unavailable."
---

# Team Research Workflow

**Lead Agent:** Orchestrator (delegate mode - coordinates only, never researches directly)
**Team Size:** 4 researchers + lead
**Pattern:** 3-round adversarial research

## Prerequisites

- BMAD initialized (`accbmad/config.yaml` exists)
- Research topic provided by user
- User specifies research dimensions or accepts defaults

## Graceful Degradation

Before starting, check if Agent Teams are available:
```
If TeamCreate tool is NOT available:
  → Inform user: "Agent Teams not available. Falling back to parallel subagent research."
  → Execute BMAD-SUBAGENT-PATTERNS.md Pattern 1 (Fan-Out Research) instead
  → Use 4 background Task agents with run_in_background: true
  → Skip adversarial rounds (challenge/rebuttal)
  → Synthesize results directly
  → STOP this workflow
```

## Step 1: Gather Research Parameters

Collect from user:
1. **Research topic** - What to research
2. **Research dimensions** (default: Market, Competitive, Technical, User)
   - User can customize dimensions based on need
3. **Depth** - Quick (1 round only) or Deep (full 3 rounds)
4. **Constraints** - Budget, timeline, geography, industry focus

## Step 2: Create Team

```
1. Load project config (helpers.md#Load-Project-Config)
2. Create team:
   TeamCreate(
     team_name: "bmad-research-{project_name}",
     description: "Adversarial multi-perspective research: {topic}"
   )
```

## Step 3: Create Research Tasks

Create one task per dimension:

```
For each dimension in [Market, Competitive, Technical, User]:
  TaskCreate(
    subject: "Round 1: Research {dimension} dimension for {topic}",
    description: """
      Research Dimension: {dimension}
      Topic: {topic}
      Constraints: {constraints}

      Deliverables:
      1. Key findings (5-10 bullet points)
      2. Supporting evidence and sources
      3. Confidence level (High/Medium/Low) for each finding
      4. Risks and uncertainties
      5. Connections to other dimensions

      Write output to: accbmad/tmp/research-{dimension}.md
    """,
    activeForm: "Researching {dimension} dimension"
  )
```

## Step 4: Spawn Researcher Teammates

Launch 4 researchers with specialized perspectives:

```
For each dimension:
  Task(
    subagent_type: "general-purpose",
    team_name: "bmad-research-{project_name}",
    name: "{dimension}-researcher",
    mode: "default",
    prompt: """
      You are a {dimension} research specialist on a BMAD research team.

      Your Role: Investigate the {dimension} dimension of: {topic}

      ## Your Expertise
      {dimension-specific expertise description}

      ## Instructions
      1. Check TaskList for your assigned task
      2. Claim it with TaskUpdate (set owner to your name)
      3. Conduct thorough research on your dimension
      4. Write findings to accbmad/tmp/research-{dimension}.md
      5. Mark task as completed
      6. Wait for Round 2 instructions from the lead

      ## Research Standards
      - Cite sources where possible
      - Rate confidence for each finding
      - Note assumptions explicitly
      - Identify gaps in available information
      - Flag potential biases in your analysis

      ## Constraints
      {constraints}
    """
  )
```

**Dimension-specific expertise:**

| Dimension | Expertise Focus |
|-----------|----------------|
| Market | Market size, trends, TAM/SAM/SOM, growth projections, regulatory landscape |
| Competitive | Competitor analysis, positioning, differentiation, market gaps, SWOT |
| Technical | Technology landscape, feasibility, architecture options, maturity, risks |
| User | User needs, personas, pain points, Jobs-to-be-Done, adoption barriers |

## Step 5: Monitor Round 1 Completion

```
Loop:
  status = TaskList()
  if all Round 1 tasks completed → proceed to Round 2
  process incoming teammate messages
  continue
```

## Step 6: Round 2 - Challenge Phase

If depth is "Deep" (3 rounds):

```
1. Read all Round 1 outputs from accbmad/tmp/research-*.md
2. Broadcast findings to all researchers:
   SendMessage(
     type: "broadcast",
     content: """
       ## Round 2: Challenge Phase

       All Round 1 findings are compiled below. Your task:
       1. Read ALL other researchers' findings
       2. Challenge at least 2 findings from other dimensions
       3. Identify contradictions, weak evidence, or missing perspectives
       4. Write your challenges to accbmad/tmp/challenge-{your-dimension}.md

       [Compiled Round 1 findings summary]
     """,
     summary: "Round 2 challenge phase starting"
   )

3. Create Round 2 tasks:
   For each dimension:
     TaskCreate(
       subject: "Round 2: Challenge other dimensions' findings",
       description: "Read all Round 1 outputs and challenge at least 2 findings...",
       activeForm: "Challenging research findings"
     )
```

## Step 7: Round 3 - Rebuttal Phase

```
1. Read all challenge outputs from accbmad/tmp/challenge-*.md
2. Broadcast challenges to researchers:
   SendMessage(
     type: "broadcast",
     content: """
       ## Round 3: Rebuttal Phase

       Challenges have been filed against your findings. Your task:
       1. Read challenges directed at your dimension
       2. Defend valid findings with additional evidence
       3. Revise or retract findings where challenges are valid
       4. Write final position to accbmad/tmp/rebuttal-{your-dimension}.md
     """,
     summary: "Round 3 rebuttal phase starting"
   )

3. Create Round 3 tasks:
   For each dimension:
     TaskCreate(
       subject: "Round 3: Defend or revise findings",
       description: "Respond to challenges, defend or revise...",
       activeForm: "Writing rebuttal"
     )
```

## Step 8: Synthesize Final Report

After all rounds complete:

```
1. Read all final outputs:
   - accbmad/tmp/research-*.md (Round 1)
   - accbmad/tmp/challenge-*.md (Round 2, if deep)
   - accbmad/tmp/rebuttal-*.md (Round 3, if deep)

2. Synthesize into consolidated report:
   - Findings that survived challenge (highest confidence)
   - Findings revised after challenge (medium confidence)
   - Unresolved disagreements (flag for human decision)
   - Cross-dimension insights and connections
   - Recommended actions with confidence ratings

3. Write report to: accbmad/1-analysis/team-research-{topic}-{date}.md
```

## Step 9: Shutdown Team

```
1. Send shutdown requests to all researchers:
   For each researcher:
     SendMessage(type: "shutdown_request", recipient: "{dimension}-researcher")

2. Wait for confirmations
3. Clean up temporary files in accbmad/tmp/research-* and accbmad/tmp/challenge-* and accbmad/tmp/rebuttal-*
4. Update workflow status (helpers.md#Update-Workflow-Status)
```

## Step 10: Present Results

Display to user:
1. Executive summary (3-5 key findings)
2. Confidence-rated findings table
3. Unresolved disagreements requiring human input
4. Link to full report
5. Recommended next BMAD workflow

## Output Template

```markdown
# Research Report: {topic}

**Date:** {date}
**Method:** BMAD Adversarial Team Research ({rounds} rounds)
**Dimensions:** {dimensions}
**Project:** {project_name}

## Executive Summary

{3-5 paragraph summary of key findings}

## Findings by Dimension

### Market
{findings with confidence ratings}

### Competitive
{findings with confidence ratings}

### Technical
{findings with confidence ratings}

### User
{findings with confidence ratings}

## Cross-Dimension Insights

{insights that emerged from adversarial process}

## Challenges and Rebuttals

| Finding | Challenge | Rebuttal | Final Status |
|---------|-----------|----------|--------------|
| ... | ... | ... | Confirmed/Revised/Retracted |

## Unresolved Disagreements

{areas where researchers could not reach consensus - flagged for human decision}

## Recommended Actions

| Action | Confidence | Priority | Rationale |
|--------|-----------|----------|-----------|
| ... | High/Med/Low | P1-P4 | ... |

## Methodology Notes

- Research team: 4 specialized agents
- Adversarial rounds: {rounds}
- Key assumptions: {list}
- Known limitations: {list}
```

## Error Handling

- **Teammate fails to respond:** Wait 2 rounds of TaskList checks, then proceed without that dimension
- **Round 2/3 timeout:** Synthesize with available data, note incomplete adversarial process
- **All teammates fail:** Fall back to direct orchestrator synthesis from Round 1 data

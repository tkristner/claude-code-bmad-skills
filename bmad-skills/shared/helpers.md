# BMAD Shared Helpers

Reusable patterns for all BMAD skills. Reference specific sections to avoid repetition.

## Config Operations

### Load-Project-Config
```
Path: accbmad/config.yaml
Purpose: Load project-specific BMAD configuration

Steps:
1. Read accbmad/config.yaml
2. Parse YAML to extract:
   - project.name
   - project.type
   - project.level
   - paths.output_folder
   - workflow settings
3. Return config object or null if not found
```

### Load-Workflow-Status
```
Path: accbmad/status.yaml
Purpose: Get current workflow progress

Steps:
1. Read status file from paths.status_file
2. Parse YAML to extract:
   - current_phase
   - current_workflow
   - phase completion status
   - workflow outputs
3. Return status object
```

### Update-Workflow-Status
```
Purpose: Mark workflow as complete

Steps:
1. Load current status file
2. Find workflow in appropriate phase
3. Update:
   - completed: true
   - output_file: "{path}"
   - completed_at: "{timestamp}"
4. Update phase status if all required workflows complete
5. Update metrics
6. Save file
```

## Subagent Operations

### Launch-Parallel-Agents
```
Purpose: Launch multiple subagents for parallel work

Pattern:
1. Prepare shared context file (accbmad/context/current-task.md)
2. For each task:
   - Create agent prompt with:
     * Task objective
     * Context file reference
     * Output location
     * Constraints
   - Launch with Task tool, run_in_background: true
3. Store agent IDs for tracking
4. Return agent ID list
```

### Collect-Agent-Results
```
Purpose: Gather results from parallel agents

Pattern:
1. For each agent ID:
   - Call AgentOutputTool with block: false
   - If not ready, add to pending list
2. If pending agents exist:
   - Continue other work or
   - Call AgentOutputTool with block: true
3. Read output files from each agent
4. Return collected results
```

### Synthesize-Results
```
Purpose: Combine outputs from multiple agents

Pattern:
1. Load all agent output files
2. Identify overlaps and conflicts
3. Merge into unified document
4. Resolve conflicts (prefer more detailed)
5. Write synthesized output
```

## Team Operations

### Check-Teams-Available
```
Purpose: Detect if Agent Teams feature is available

Steps:
1. Check if TeamCreate, SendMessage, TaskCreate tools are accessible
2. If available → return true, team workflows can proceed
3. If unavailable → return false, fall back to subagent patterns

Usage:
- Call at the start of any /team-* workflow
- If false, redirect to equivalent subagent pattern in BMAD-SUBAGENT-PATTERNS.md
```

### Create-BMAD-Team
```
Purpose: Create a team with BMAD naming convention

Naming Convention: bmad-{workflow}-{project_name}
  - bmad-research-myapp
  - bmad-implement-myapp
  - bmad-review-myapp

Steps:
1. Load project config (helpers.md#Load-Project-Config)
2. Derive team_name: "bmad-{workflow}-{config.project.name}"
3. Call TeamCreate with:
   - team_name: derived name
   - description: workflow-specific purpose
4. Return team_name for use by teammates

Example:
  TeamCreate(
    team_name: "bmad-research-myapp",
    description: "Adversarial multi-perspective research for MyApp"
  )
```

### Spawn-Teammate
```
Purpose: Launch a teammate that joins the BMAD team

Steps:
1. Call Task tool with:
   - subagent_type: "general-purpose"
   - team_name: from Create-BMAD-Team
   - name: descriptive role name (e.g., "market-researcher", "security-reviewer")
   - mode: "default" or "plan" (if plan approval required)
   - prompt: self-contained task description with:
     * Role and expertise
     * Assigned tasks/dimensions
     * Output expectations
     * Team coordination instructions
2. Return teammate reference

Parameters:
- subagent_type: string (required, recommend "general-purpose")
- team_name: string (required)
- name: string (required, unique within team)
- prompt: string (required, self-contained task description with role and expertise)
- mode: string (optional, "default" | "plan" | "delegate")
```

### Distribute-Tasks
```
Purpose: Create tasks for team members via shared task list

Steps:
1. For each work item:
   - Call TaskCreate with:
     * subject: clear task title
     * description: detailed requirements
     * activeForm: present continuous description
2. Optionally set dependencies with TaskUpdate:
   - addBlockedBy: for sequential dependencies
   - addBlocks: for downstream tasks
3. Assign owners with TaskUpdate:
   - owner: teammate name

Pattern:
  TaskCreate(subject: "Research market trends", description: "...", activeForm: "Researching market trends")
  TaskUpdate(taskId: "1", owner: "market-researcher")
```

### Collect-Team-Results
```
Purpose: Monitor team progress and gather results

Steps:
1. Call TaskList to check overall progress
2. For each completed task:
   - Read output files referenced in task description
   - Collect findings/deliverables
3. If tasks still pending:
   - Wait for teammate messages (auto-delivered)
   - Check TaskList periodically
4. When all tasks complete:
   - Aggregate results for synthesis
5. Return collected results

Monitoring Pattern:
  Loop:
    status = TaskList()
    if all tasks completed → break
    process incoming teammate messages
    continue
```

### Shutdown-Team
```
Purpose: Gracefully shut down all teammates and clean up

Steps:
1. Read team config: ~/.claude/teams/{team-name}/config.json
2. For each teammate in config.members:
   - SendMessage(type: "shutdown_request", recipient: teammate.name)
3. Wait for shutdown confirmations
4. Optionally call TeamDelete to remove team resources
5. Log team completion

Note: Only shut down after all tasks are completed or explicitly cancelled.
```

## Document Operations

### Load-Template
```
Purpose: Load document template for workflow

Steps:
1. Determine template path:
   - Skill templates: {skill}/templates/{name}.template.md
   - Shared templates: shared/{name}.template.yaml
2. Read template file
3. Extract {{variable}} placeholders
4. Return template content and variables list
```

### Apply-Variables
```
Purpose: Substitute {{variables}} with values

Standard Variables:
- {{project_name}} → config.project.name
- {{project_type}} → config.project.type
- {{project_level}} → config.project.level
- {{date}} → YYYY-MM-DD
- {{timestamp}} → ISO 8601
- {{user_name}} → from global config or "User"

Steps:
1. For each {{variable}} in template:
   - Look up value in config or provided values
   - Replace placeholder with value
2. Return completed content
```

### Save-Document
```
Purpose: Save generated document

Steps:
1. Determine output path:
   - {output_folder}/{workflow}-{project_name}-{date}.md
2. Write content to file
3. Return file path for status update
```

## Phase Logic

### Determine-Requirements
```
Purpose: Set workflow requirements based on level

Level 0 (1 story):
- product_brief: skip
- prd: skip
- tech_spec: required
- architecture: skip

Level 1 (1-10 stories):
- product_brief: recommended
- prd: recommended
- tech_spec: required
- architecture: optional

Level 2+ (5+ stories):
- product_brief: required
- prd: required
- tech_spec: optional
- architecture: required
```

### Determine-Next-Workflow
```
Purpose: Recommend next workflow based on status

Logic:
1. Check Phase 1:
   - If product_brief required and not complete → /product-brief
2. Check Phase 2:
   - If PRD required and not complete → /prd
   - If tech_spec required and not complete → /tech-spec
3. Check Phase 3:
   - If architecture required and not complete → /architecture
4. Check Phase 4:
   - If sprint_planning not complete → /sprint-planning
   - If stories exist → /dev-story {next-story}
5. Return recommendation with rationale
```

### Display-Status
```
Purpose: Format status for user display

Symbols:
- ✓ = Completed
- ⚠ = Required, not started
- → = Current phase/workflow
- - = Optional
- ○ = In progress

Format:
Phase {n}: {name} [{STATUS}]
  {symbol} {workflow} ({status}) [output if complete]
```

## Validation Operations

### Validate-YAML
```
Purpose: Check YAML file validity

Steps:
1. Attempt to parse file
2. If error:
   - Return error message with line number
   - Suggest fixes
3. If valid:
   - Return parsed content
```

### Validate-Document-Sections
```
Purpose: Check document completeness

Steps:
1. Load expected sections for document type
2. Parse document headings
3. Compare against expected
4. Return:
   - Missing sections
   - Empty sections
   - Completeness percentage
```

## Token Optimization

### Reference-Pattern
```
Instead of embedding full instructions:
✓ Good: "Follow helpers.md#Load-Project-Config"
✗ Bad: [Full 50-line config loading instructions]

Instead of repeating patterns:
✓ Good: "Use standard subagent prompt from BMAD-SUBAGENT-PATTERNS.md"
✗ Bad: [Full subagent prompt template repeated]
```

### Lazy-Loading
```
Load content only when needed:
1. Start with SKILL.md only (~2-3K tokens)
2. Load REFERENCE.md when detailed info needed
3. Load resources/ files for specific lookups
4. Run scripts for deterministic operations
```

## Error Handling

### Config-Not-Found
```
If accbmad/config.yaml missing:
1. Inform user: "BMAD not initialized in this project"
2. Offer: "Run /workflow-init to set up BMAD"
3. Provide quick setup option
```

### Status-File-Missing
```
If workflow status file missing:
1. Check if config exists
2. If config exists: Recreate status file from template
3. If no config: Direct to initialization
```

### Agent-Failure
```
If subagent fails or times out:
1. Log failure with agent ID
2. Check partial output
3. Retry with simplified prompt or
4. Fall back to sequential processing
```

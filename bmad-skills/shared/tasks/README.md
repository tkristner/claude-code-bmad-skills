# Core Tasks

Core tasks are reusable building blocks that can be invoked by any BMAD skill or workflow. They encapsulate specific, well-defined behaviors that are used across multiple contexts.

## Available Tasks

| Task | Purpose | Used By |
|------|---------|---------|
| `review-adversarial.md` | Cynical review finding 3-10+ issues | Code review, PR review, document review |
| `editorial-review.md` | Prose quality review (grammar, clarity) | Documentation, specs, stories |

## How to Use

Tasks can be invoked in two ways:

### 1. Inline Invocation

Reference the task behavior directly in your workflow:

```markdown
### Step N: Adversarial Review

Apply adversarial review per `shared/tasks/review-adversarial.md`:
- Review with extreme skepticism
- Find at least 3-10 issues
- Present findings as markdown list
```

### 2. Subagent Delegation

Launch a subagent with the task as its primary instruction:

```markdown
Launch subagent with:
- Task: Read shared/tasks/review-adversarial.md
- Input: {content_to_review}
- Output: Write findings to bmad/outputs/review-findings.md
```

## Task Structure

Each task file contains:

1. **Objective** - What the task accomplishes
2. **Inputs** - What content/parameters are needed
3. **Mindset** - The approach/persona to adopt
4. **Flow** - Step-by-step execution
5. **Output** - Expected format of results
6. **Halt Conditions** - When to stop or ask for help

## Creating New Tasks

Tasks should be:
- **Focused** - Single responsibility
- **Reusable** - Applicable across contexts
- **Standalone** - No external dependencies
- **Clear** - Unambiguous instructions

Use this template:

```markdown
# Task Name

**Objective:** What this task accomplishes

**Inputs:**
- `content` (required): What to process
- `option` (optional): Configuration option

## Mindset

Describe the approach/persona to adopt.

## Flow

### Step 1: Validate
- Check inputs
- Halt if invalid

### Step 2: Execute
- Main task logic

### Step 3: Output
- Format and present results

## Output Format

Describe expected output structure.

## Halt Conditions

- When to stop
- When to ask for clarification
```

## Design Principles

1. **CONTENT IS SACROSANCT** - Tasks review how ideas are expressed, not what they say
2. **Minimal Intervention** - Apply smallest fix that achieves the goal
3. **No False Positives** - If no issues found, that's valid (for editorial review)
4. **Zero Findings is Suspicious** - For adversarial review, dig deeper if nothing found

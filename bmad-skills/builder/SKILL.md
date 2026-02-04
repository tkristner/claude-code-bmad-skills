---
name: builder
description: Creates custom agents, workflows, and templates for BMAD. Extends BMAD functionality with domain-specific components. Trigger keywords - create agent, create workflow, custom skill, extend BMAD, new template, customize, scaffold skill
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, TodoWrite
---

# Builder

**Role:** Custom skill and workflow creation specialist

**Function:** Create custom agents, workflows, and templates for specialized domains. Extend BMAD functionality with domain-specific components.

## When to Use This Skill

Use this skill when you need to:
- Create custom agent skills for specific domains (QA, DevOps, Security, etc.)
- Generate workflow commands following BMAD patterns
- Create domain-specific document templates
- Customize BMAD for specific organizational needs
- Scaffold and validate new skill directory structures

## Responsibilities

- Guide users in creating custom agents for specific domains (QA, DevOps, Security, etc.)
- Generate workflow commands following BMAD patterns
- Create domain-specific document templates
- Customize BMAD for specific use cases
- Validate and scaffold skill directory structures

## Core Principles

1. **User-Driven** - Build what the user needs, not what exists
2. **Specification-Compliant** - Follow Anthropic Claude Code skill specification (YAML frontmatter required)
3. **Token-Optimized** - Use references, avoid redundancy, keep under 5k tokens
4. **Functional** - Focus on what agents do, not fictional personas
5. **Reusable** - Create components that can be reused across projects

## Creation Workflows

### Create Custom Agent

**Purpose:** Create domain-specific agent skills (e.g., QA Engineer, DevOps Engineer)

**Process:**
1. Gather requirements (domain, responsibilities, workflows)
2. Scaffold skill directory structure
3. Create SKILL.md with YAML frontmatter
4. Create workflows, templates, scripts
5. Validate using validate-skill.sh

**Invoke:** `/create-agent` or `/create-agent {domain-name}`

**See:** [workflows/create-agent.md](workflows/create-agent.md) for detailed workflow

### Create Workflow Command

**Purpose:** Create domain-specific workflows (e.g., /deploy, /security-audit)

**Process:**
1. Identify workflow purpose and inputs/outputs
2. Design workflow steps
3. Create workflow .md file
4. Update parent skill SKILL.md
5. Create supporting templates/scripts

**Invoke:** `/create-workflow` or `/create-workflow {skill}/{workflow}`

**See:** [workflows/create-workflow.md](workflows/create-workflow.md) for detailed workflow

### Create Document Template

**Purpose:** Create domain-specific document templates

**Process:**
1. Identify document type
2. Define sections needed
3. List variables for {{placeholder}} substitution
4. Create and test template
5. Validate against TEMPLATE-GUIDELINES.md

**See:**
- [TEMPLATE-GUIDELINES.md](../TEMPLATE-GUIDELINES.md) for style guide and checklist
- [REFERENCE.md](REFERENCE.md) for template patterns

## Available Scripts

### validate-skill.sh

Validates SKILL.md files have required YAML frontmatter:
- `name` field (required)
- `description` field (required)
- `allowed-tools` field (optional but recommended)

**Usage:**
```bash
./scripts/validate-skill.sh path/to/SKILL.md
```

### scaffold-skill.sh

Creates skill directory structure with subdirectories:
- `scripts/` - Validation and utility scripts
- `templates/` - Reusable templates
- `resources/` - Reference documentation

**Usage:**
```bash
./scripts/scaffold-skill.sh skill-name
```

## File Organization

Custom components should follow this structure:

```
~/.claude/skills/{skill-name}/
├── SKILL.md                 (required: YAML frontmatter + skill definition)
├── REFERENCE.md             (optional: detailed patterns/examples)
├── scripts/                 (optional: validation/utility scripts)
├── templates/               (optional: reusable templates)
└── resources/               (optional: reference materials)
```

## Installation Process

After creating custom components:

1. **Skills:** Copy to `~/.claude/skills/{skill-name}/`
2. **Workflows:** Place workflow .md files in appropriate location
3. **Templates:** Store in templates/ subdirectory
4. **Validate:** Run validate-skill.sh on SKILL.md
5. **Test:** Load skill and verify functionality

## YAML Frontmatter Requirements

Every SKILL.md must have YAML frontmatter:

```yaml
---
name: skill-name
description: Clear description with trigger keywords for when to activate this skill
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, TodoWrite
---
```

**Required fields:**
- `name` - Skill identifier (lowercase, hyphenated, max 64 chars)
- `description` - Clear description including trigger keywords (max 1024 chars)

**Optional fields:**
- `allowed-tools` - List of tools the skill can use
- Other custom metadata as needed

## Skill Validation Checklist

Before deploying a custom skill, validate:

```
[ ] YAML frontmatter is valid (no syntax errors)
[ ] name field is lowercase with hyphens only
[ ] description includes trigger keywords
[ ] SKILL.md is under 5K tokens
[ ] All referenced files exist (REFERENCE.md, scripts/, templates/)
[ ] Scripts are executable (chmod +x)
[ ] Templates follow TEMPLATE-GUIDELINES.md standards
[ ] No hardcoded paths (use relative paths)
[ ] Integration points documented
[ ] Example interaction included
```

**Validation Command:**
```bash
./scripts/validate-skill.sh path/to/SKILL.md
```

## Skill Versioning

When updating skills, follow semantic versioning principles:

**Version in frontmatter (optional):**
```yaml
---
name: qa-engineer
description: ...
version: 1.3.0
---
```

**Version Changes:**
- **Patch (1.0.x):** Bug fixes, typo corrections, clarifications
- **Minor (1.x.0):** New workflows, new scripts, new templates
- **Major (x.0.0):** Breaking changes, restructured workflows, renamed files

**Changelog in REFERENCE.md:**
```markdown
## Changelog

### 1.3.0 (2026-02-01)
- Added /security-scan workflow
- New security-checklist template

### 1.1.0 (2026-01-15)
- Added parallel test execution support
- Improved coverage reporting
```

## Skill Update & Migration

When updating existing skills:

### Non-Breaking Updates
1. Add new workflows/templates alongside existing
2. Update SKILL.md with new capabilities
3. Add to REFERENCE.md changelog
4. Test with existing projects

### Breaking Changes
1. Document migration path in REFERENCE.md
2. Provide deprecation warnings
3. Keep old patterns working for transition period
4. Update all dependent workflows

### Migration Checklist
```
[ ] Identify affected users/projects
[ ] Document what's changing and why
[ ] Provide migration script if possible
[ ] Update documentation with new patterns
[ ] Test migration on sample project
[ ] Communicate changes clearly
```

## Token Optimization

Keep SKILL.md under 5k tokens:
- Use references to [REFERENCE.md](REFERENCE.md) for detailed patterns
- Link to skill-patterns.md for design guidance
- Avoid embedding large code blocks
- Use progressive disclosure (Level 1 overview, Level 2 details, Level 3 examples)

## Subagent Strategy

> For comprehensive subagent patterns and examples, see [BMAD-SUBAGENT-PATTERNS.md](../BMAD-SUBAGENT-PATTERNS.md)

This skill leverages parallel subagents to maximize context utilization (each agent has 200K tokens).

### Skill Creation Workflow
**Pattern:** Parallel Component Creation
**Agents:** 4 parallel agents

| Agent | Task | Output |
|-------|------|--------|
| Agent 1 | Create SKILL.md with YAML frontmatter and core content | bmad-skills/{skill-name}/SKILL.md |
| Agent 2 | Create helper scripts for validation and utilities | bmad-skills/{skill-name}/scripts/*.sh |
| Agent 3 | Create document templates | bmad-skills/{skill-name}/templates/*.md |
| Agent 4 | Create reference resources and guides | bmad-skills/{skill-name}/resources/*.md |

**Coordination:**
1. Gather requirements for new skill from user (sequential)
2. Write skill specification to accbmad/context/skill-spec.md
3. Run scaffold-skill.sh to create directory structure
4. Launch parallel agents to create skill components
5. Each agent follows BMAD patterns and conventions
6. Main context validates YAML frontmatter with validate-skill.sh
7. Assemble complete skill package

**Best for:** Creating comprehensive custom skills with full structure

### Multi-Skill Creation Workflow
**Pattern:** Parallel Component Creation
**Agents:** N parallel agents (one per skill)

| Agent | Task | Output |
|-------|------|--------|
| Agent 1 | Create complete Skill 1 (QA Engineer) | bmad-skills/qa-engineer/ |
| Agent 2 | Create complete Skill 2 (DevOps Engineer) | bmad-skills/devops-engineer/ |
| Agent N | Create complete Skill N (Security Engineer) | bmad-skills/security-engineer/ |

**Coordination:**
1. Identify suite of related skills to create
2. Define common patterns and shared resources
3. Launch parallel agents, each creating one complete skill
4. Each agent creates SKILL.md, scripts, templates, resources
5. Main context validates all skills and ensures consistency
6. Create integration documentation

**Best for:** Creating a family of related skills for a domain

### Template Creation Workflow
**Pattern:** Parallel Section Generation
**Agents:** N parallel agents (one per template)

| Agent | Task | Output |
|-------|------|--------|
| Agent 1 | Create test plan template | templates/test-plan.template.md |
| Agent 2 | Create deployment runbook template | templates/deployment-runbook.template.md |
| Agent 3 | Create security assessment template | templates/security-assessment.template.md |
| Agent N | Create additional domain templates | templates/*.template.md |

**Coordination:**
1. Identify document types needed for skill
2. Launch parallel agents for each template
3. Each agent defines sections, variables, example content
4. Main context validates template format and placeholder consistency

**Best for:** Creating multiple templates for a skill quickly

### Skill Validation Workflow
**Pattern:** Fan-Out Research
**Agents:** 4 parallel agents (validation domains)

| Agent | Task | Output |
|-------|------|--------|
| Agent 1 | Validate YAML frontmatter and skill structure | accbmad/outputs/validation-structure.md |
| Agent 2 | Validate token count and optimization | accbmad/outputs/validation-tokens.md |
| Agent 3 | Validate script functionality and permissions | accbmad/outputs/validation-scripts.md |
| Agent 4 | Validate templates and resources completeness | accbmad/outputs/validation-content.md |

**Coordination:**
1. Load created skill files
2. Launch parallel validation agents for different aspects
3. Each agent runs validation checks and reports issues
4. Main context consolidates validation report
5. Fix identified issues before delivery

**Best for:** Comprehensive quality check of new skills

### Example Subagent Prompt
```
Task: Create SKILL.md for QA Engineer skill
Context: Read accbmad/context/skill-spec.md for requirements
Objective: Create complete SKILL.md with YAML frontmatter following BMAD patterns
Output: Write to bmad-skills/qa-engineer/SKILL.md

Deliverables:
1. YAML frontmatter (name, description with trigger keywords, allowed-tools)
2. Role and function description
3. Core responsibilities (5-8 bullet points)
4. Core principles (5 key principles)
5. When to use this skill section
6. Available commands/workflows (2-4 commands)
7. Workflow process descriptions
8. Integration points with other skills
9. Notes for LLMs section
10. Example interaction

Constraints:
- Follow Anthropic skill specification for YAML
- Keep under 5K tokens (use references for detail)
- Include trigger keywords in description
- Specify allowed-tools list
- Use consistent BMAD formatting and structure
- Include TodoWrite in workflow guidance
- Reference REFERENCE.md for detailed patterns
```

## Notes for LLMs

- Use TodoWrite to track component creation tasks
- Validate YAML frontmatter before finalizing skills
- Follow Anthropic skill specification strictly
- Test generated components before delivery
- Ask user for domain-specific details
- Keep token usage minimal (reference external files)
- Document integration points clearly
- Use scaffold-skill.sh to create directory structure
- Run validate-skill.sh before declaring success

## Example Domain Customizations

**QA Engineering:**
- QA Engineer agent skill
- /create-test-plan workflow
- /execute-tests workflow
- Test plan template

**DevOps:**
- DevOps Engineer agent skill
- /deploy workflow
- /rollback workflow
- Deployment runbook template

**Security:**
- Security Engineer agent skill
- /security-audit workflow
- Security assessment template

**Data Science:**
- Data Scientist agent skill
- /data-analysis workflow
- Analysis report template

**Remember:** Custom components should feel native to BMAD, following the same patterns and conventions as built-in skills.

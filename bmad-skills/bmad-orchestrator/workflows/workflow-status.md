You are executing the **Workflow Status** command to check project progress.

## Purpose
Display BMAD project status and recommend next steps.

## Execution
1. Read `bmad/config.yaml` for project info
2. Read `docs/bmm-workflow-status.yaml` for workflow progress
3. Read `docs/sprint-status.yaml` if it exists for sprint info
4. Display:
   - Project overview (name, type, level)
   - Phase completion status (Analysis, Planning, Solutioning, Implementation)
   - Document status (PRD, Tech Spec, Architecture)
   - Sprint progress if applicable
5. Recommend next workflow based on current state

## Status Indicators
- ✓ Completed
- → In Progress
- ○ Not Started
- ⊘ Not Required (based on level)

## Recommendations
Provide specific workflow recommendations based on:
- Current phase
- Project level requirements
- Document completion status

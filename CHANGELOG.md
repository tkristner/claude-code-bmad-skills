# Changelog

All notable changes to **Another Claude-Code BMAD** are documented in this file.

This project is a fork of [aj-geddes/another-claude-code-bmad](https://github.com/aj-geddes/another-claude-code-bmad), which implements the [BMAD Method](https://github.com/bmad-code-org/BMAD-METHOD) for Claude Code.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.6.0] - 2026-02-08

### Added
- **Agent Teams Integration** — Smart upgrade pattern for multi-agent coordination
  - Existing commands (`/dev-sprint-auto`, `/research`, `/code-review`) auto-detect when teams add value
  - Wave-based parallel story implementation with dependency grouping
  - Adversarial 3-round research (Research → Challenge → Rebuttal)
  - Multi-lens architecture/code review with debate phase
  - Graceful degradation to subagent patterns when teams unavailable

- **Team Lifecycle Hooks**
  - `bmad-teammate-idle.sh` — Checks for unclaimed tasks, keeps teammates working
  - `bmad-task-completed.sh` — Validates output quality before marking done

- **Brownfield Workflow** — First-class support for existing projects
  - `/accbmad:generate-project-context` analyzes codebase conventions
  - `/workflow-init` auto-detects existing code and proposes context generation
  - All implementation commands load project context automatically

- **Documentation**
  - `BMAD-AGENT-TEAMS.md` — Complete Agent Teams guide
  - Team configuration template (`team-config.template.json`)
  - Comprehensive Workflow Guide in README with decision trees and flow paths

### Changed
- Command count: 34 → 37 workflow commands
- Documentation centralized in repository (removed GitHub Pages dependency)
- Migrated reference docs to `bmad-skills/shared/resources/`
- Updated troubleshooting and configuration guides for v1.6.0

### Removed
- `docs/` directory — All content migrated to `bmad-skills/shared/resources/` and README
- GitHub Pages site dependency

---

## [1.5.0] - 2026-02-07

### Added
- **Subagent Patterns** — Documented multi-agent coordination patterns
  - Fan-out research, parallel implementation, adversarial review
  - Shared context via `accbmad/context/` directory
  - `BMAD-SUBAGENT-PATTERNS.md` reference guide

### Changed
- Workflow state moved to `accbmad/tmp/` for cleaner separation
- All workflow outputs migrated to `accbmad/` phase-based structure
- Agent overrides use `accbmad/` paths

### Fixed
- Workflow state file paths use `accbmad/` consistently
- Agent override paths corrected

---

## [1.4.0] - 2026-02-06

### Changed
- **Phase-Based Project Structure** — Reorganized all outputs by BMAD phase:
  - `accbmad/1-analysis/` — Product briefs, research
  - `accbmad/2-planning/` — PRD, tech specs, UX design
  - `accbmad/3-solutioning/` — Architecture, project context
  - `accbmad/4-implementation/` — Sprint plans, stories
- Skills organized under `accbmad/` parent folder
- Added `context/` and `outputs/` directories for subagent coordination
- Agent name prefix added to all command descriptions for clarity

### Fixed
- Scripts updated for new `accbmad/` structure
- Structure diagrams updated with context and outputs directories

---

## [1.3.0] - 2026-02-04

### Added
- **Autonomous Sprint Execution** (`/accbmad:dev-sprint-auto`)
  - Script-driven story queue with `story-queue.sh`
  - Processes all pending stories automatically
  - Mandatory code review with `--auto-fix` mode
  - Double review pattern (pre-commit + post-commit verification)
  - HALT conditions on conflicts or repeated failures

- **Command Namespace** - All commands now use `/accbmad:` prefix to differentiate from original BMAD

- **Uninstall Script** (`uninstall-bmad-skills.sh`)
  - Clean removal of all BMAD skills and commands
  - Options: `--keep-commands`, `--keep-skills`, `-p <project>`

### Changed
- Command prefix changed from `/bmad:` to `/accbmad:`
- Installation path changed from `commands/bmad/` to `commands/accbmad/`
- Refactored install script to use file-based commands (removed heredocs)

### Fixed
- Version consistency across all template files (BMAD Method v6.0.0)

---

## [1.2.0] - 2026-02-02

### Added
- Tech Writer skill improvements
- Documentation enhancements

---

## [1.1.0] - 2026-01-15

### Added
- **Tech Writer Skill** with 5 workflows:
  - `/accbmad:readme` - Generate comprehensive README files
  - `/accbmad:api-docs` - Create API documentation from code
  - `/accbmad:user-guide` - Write user guides and tutorials
  - `/accbmad:changelog` - Maintain changelog entries
  - `/accbmad:architecture-docs` - Document system architecture

- **Quick Flow** for small changes:
  - `/accbmad:quick-spec` - Lightweight tech spec via conversation
  - `/accbmad:quick-dev` - Quick implementation with built-in review

- **Adversarial Code Review** (`/accbmad:code-review`)
  - Minimum 3-10 issues expected
  - Git diff validation
  - Auto-fix mode

### Changed
- Improved documentation structure
- Improved in-repository documentation

---

## [1.0.0] - 2025-12-01

### Added
- Initial fork from aj-geddes/another-claude-code-bmad
- **10 Specialized Skills**:
  - bmad-orchestrator (workflow management)
  - business-analyst (Phase 1 - Analysis)
  - product-manager (Phase 2 - Planning)
  - system-architect (Phase 3 - Solutioning)
  - scrum-master (Phase 4 - Sprint Planning)
  - developer (Phase 4 - Implementation)
  - ux-designer (Cross-phase UX)
  - creative-intelligence (Research & Brainstorming)
  - builder (Create custom skills)
  - tech-writer (Documentation)

- **34 Workflow Commands** covering all 4 BMAD phases
- **Installation Script** (`install-bmad-skills.sh`)
- **Project Levels** (0-4) for right-sized planning
- **Phase Gates** for quality validation

### Attribution
Based on the BMAD Method v6.0.0 by [BMAD Code Organization](https://github.com/bmad-code-org).

---

[1.6.0]: https://github.com/tkristner/Another_Claude-Code_BMAD/compare/v1.5.0...v1.6.0
[1.5.0]: https://github.com/tkristner/Another_Claude-Code_BMAD/compare/v1.4.0...v1.5.0
[1.4.0]: https://github.com/tkristner/Another_Claude-Code_BMAD/compare/v1.3.0...v1.4.0
[1.3.0]: https://github.com/tkristner/Another_Claude-Code_BMAD/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/tkristner/Another_Claude-Code_BMAD/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/tkristner/Another_Claude-Code_BMAD/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/tkristner/Another_Claude-Code_BMAD/releases/tag/v1.0.0

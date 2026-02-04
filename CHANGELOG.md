# Changelog

All notable changes to **Another Claude-Code BMAD** are documented in this file.

This project is a fork of [aj-geddes/another-claude-code-bmad](https://github.com/aj-geddes/another-claude-code-bmad), which implements the [BMAD Method](https://github.com/bmad-code-org/BMAD-METHOD) for Claude Code.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.3.0] - 2026-02-04

### Added
- **Autonomous Sprint Execution** (`/accbmad:dev-story-auto`)
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
- GitHub Pages site with full reference

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

[1.3.0]: https://github.com/tkristner/Another_Claude-Code_BMAD/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/tkristner/Another_Claude-Code_BMAD/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/tkristner/Another_Claude-Code_BMAD/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/tkristner/Another_Claude-Code_BMAD/releases/tag/v1.0.0

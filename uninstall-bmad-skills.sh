#!/bin/bash
###############################################################################
# BMAD Skills Uninstaller
# Removes BMAD Skills from Claude Code
###############################################################################

set -euo pipefail

# Version (should match install script)
BMAD_VERSION="1.3.0"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Installation paths
CLAUDE_DIR="${HOME}/.claude"
SKILLS_DIR="${CLAUDE_DIR}/skills"
COMMANDS_DIR="${CLAUDE_DIR}/commands/accbmad"

# Skills to remove
BMAD_SKILLS=(
    "bmad-orchestrator"
    "business-analyst"
    "product-manager"
    "system-architect"
    "scrum-master"
    "developer"
    "ux-designer"
    "creative-intelligence"
    "builder"
    "tech-writer"
)

###############################################################################
# Logging
###############################################################################

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_header() {
    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}  $1${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

###############################################################################
# Pre-flight checks
###############################################################################

check_installation() {
    local found=0

    # Check for skills
    for skill in "${BMAD_SKILLS[@]}"; do
        if [[ -d "${SKILLS_DIR}/${skill}" ]]; then
            found=1
            break
        fi
    done

    # Check for commands
    if [[ -d "${COMMANDS_DIR}" ]]; then
        found=1
    fi

    if [[ $found -eq 0 ]]; then
        log_warning "No BMAD installation found."
        echo ""
        echo "Checked locations:"
        echo "  Skills:   ${SKILLS_DIR}/"
        echo "  Commands: ${COMMANDS_DIR}/"
        echo ""
        exit 0
    fi
}

###############################################################################
# Uninstall functions
###############################################################################

remove_skills() {
    log_info "Removing BMAD skills..."

    local removed=0
    local skipped=0

    for skill in "${BMAD_SKILLS[@]}"; do
        local skill_path="${SKILLS_DIR}/${skill}"
        if [[ -d "${skill_path}" ]]; then
            rm -rf "${skill_path}"
            log_success "Removed: ${skill}"
            ((removed++))
        else
            ((skipped++))
        fi
    done

    echo ""
    log_info "Skills removed: ${removed}, not found: ${skipped}"
}

remove_commands() {
    log_info "Removing BMAD commands..."

    if [[ -d "${COMMANDS_DIR}" ]]; then
        local count=$(find "${COMMANDS_DIR}" -name "*.md" 2>/dev/null | wc -l)
        rm -rf "${COMMANDS_DIR}"
        log_success "Removed ${count} command files from ${COMMANDS_DIR}"
    else
        log_warning "Commands directory not found: ${COMMANDS_DIR}"
    fi
}

remove_shared_files() {
    log_info "Removing shared BMAD files..."

    # Remove BMAD-GUIDE.md (installed from CLAUDE.md)
    local guide_md="${SKILLS_DIR}/BMAD-GUIDE.md"
    if [[ -f "${guide_md}" ]]; then
        rm -f "${guide_md}"
        log_success "Removed: BMAD-GUIDE.md"
    fi

    # Remove BMAD-SUBAGENT-PATTERNS.md (installed from SUBAGENT-PATTERNS.md)
    local subagent_md="${SKILLS_DIR}/BMAD-SUBAGENT-PATTERNS.md"
    if [[ -f "${subagent_md}" ]]; then
        rm -f "${subagent_md}"
        log_success "Removed: BMAD-SUBAGENT-PATTERNS.md"
    fi

    # Note: TEMPLATE-GUIDELINES.md and shared/ are NOT installed by install script
    # They remain in the source repo only
}

###############################################################################
# Project cleanup (optional)
###############################################################################

cleanup_project() {
    local project_dir="$1"

    log_info "Cleaning up BMAD files in project: ${project_dir}"

    # Remove bmad/ directory
    if [[ -d "${project_dir}/bmad" ]]; then
        rm -rf "${project_dir}/bmad"
        log_success "Removed: bmad/"
    fi

    # Remove BMAD status files
    local status_file="${project_dir}/docs/bmm-workflow-status.yaml"
    if [[ -f "${status_file}" ]]; then
        rm -f "${status_file}"
        log_success "Removed: docs/bmm-workflow-status.yaml"
    fi

    # Remove sprint status
    local sprint_file="${project_dir}/docs/sprint-status.yaml"
    if [[ -f "${sprint_file}" ]]; then
        rm -f "${sprint_file}"
        log_success "Removed: docs/sprint-status.yaml"
    fi

    # Remove project-level commands
    local proj_commands="${project_dir}/.claude/commands/accbmad"
    if [[ -d "${proj_commands}" ]]; then
        rm -rf "${proj_commands}"
        log_success "Removed: .claude/commands/accbmad/"
    fi

    log_info "Project cleanup complete"
}

###############################################################################
# Main
###############################################################################

print_usage() {
    cat << EOF
BMAD Skills Uninstaller v${BMAD_VERSION}

Usage: $0 [OPTIONS]

Options:
    -h, --help              Show this help message
    -y, --yes               Skip confirmation prompt
    -p, --project <path>    Also clean up BMAD files in specified project
    --keep-commands         Keep workflow commands, only remove skills
    --keep-skills           Keep skills, only remove workflow commands

Examples:
    $0                      # Interactive uninstall
    $0 -y                   # Uninstall without confirmation
    $0 -p /path/to/project  # Also clean project BMAD files
    $0 --keep-commands      # Only remove skills

EOF
}

main() {
    local skip_confirm=false
    local project_path=""
    local keep_commands=false
    local keep_skills=false

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                print_usage
                exit 0
                ;;
            -y|--yes)
                skip_confirm=true
                shift
                ;;
            -p|--project)
                project_path="$2"
                shift 2
                ;;
            --keep-commands)
                keep_commands=true
                shift
                ;;
            --keep-skills)
                keep_skills=true
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                print_usage
                exit 1
                ;;
        esac
    done

    log_header "BMAD Skills Uninstaller v${BMAD_VERSION}"

    # Check if anything is installed
    check_installation

    # Show what will be removed
    echo "This will remove:"
    echo ""
    if [[ "$keep_skills" != true ]]; then
        echo "  📦 BMAD Skills from: ${SKILLS_DIR}/"
        for skill in "${BMAD_SKILLS[@]}"; do
            if [[ -d "${SKILLS_DIR}/${skill}" ]]; then
                echo "     - ${skill}"
            fi
        done
    fi
    if [[ "$keep_commands" != true ]]; then
        echo ""
        echo "  📋 Workflow commands from: ${COMMANDS_DIR}/"
    fi
    if [[ -n "$project_path" ]]; then
        echo ""
        echo "  🗂️  Project BMAD files in: ${project_path}/"
    fi
    echo ""

    # Confirm
    if [[ "$skip_confirm" != true ]]; then
        read -p "Continue with uninstall? [y/N] " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Uninstall cancelled."
            exit 0
        fi
    fi

    echo ""

    # Perform uninstall
    if [[ "$keep_skills" != true ]]; then
        remove_skills
        remove_shared_files
    fi

    if [[ "$keep_commands" != true ]]; then
        remove_commands
    fi

    # Project cleanup if specified
    if [[ -n "$project_path" ]]; then
        if [[ -d "$project_path" ]]; then
            cleanup_project "$project_path"
        else
            log_error "Project path not found: ${project_path}"
        fi
    fi

    # Success message
    log_header "Uninstall Complete"

    echo "BMAD Skills have been removed."
    echo ""
    echo "Note: Restart Claude Code for changes to take effect."
    echo ""

    if [[ -z "$project_path" ]]; then
        echo "To also clean up a specific project's BMAD files, run:"
        echo "  $0 -p /path/to/your/project"
        echo ""
    fi

    echo -e "${GREEN}✓ BMAD Skills uninstalled successfully${NC}"
}

main "$@"

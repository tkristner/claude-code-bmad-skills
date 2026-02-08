#!/bin/bash
# BMAD Task Completed Hook
# Triggered on TaskCompleted event
# Validates output quality before allowing task completion
#
# Exit codes:
#   0 = Allow completion (output valid)
#   2 = Reject completion (validation failed)

# Only activate for BMAD teams
TEAM_NAME="${CLAUDE_TEAM_NAME:-}"
if [[ -z "$TEAM_NAME" ]] || [[ "$TEAM_NAME" != bmad-* ]]; then
    exit 0
fi

TASK_ID="${CLAUDE_TASK_ID:-}"
TASKS_DIR="${HOME}/.claude/tasks/${TEAM_NAME}"
TASK_FILE="${TASKS_DIR}/${TASK_ID}.json"

# If task file doesn't exist, allow completion
if [ ! -f "$TASK_FILE" ]; then
    exit 0
fi

# Extract task metadata (prefer jq, fall back to grep)
if command -v jq &>/dev/null; then
    task_subject=$(jq -r '.subject // ""' "$TASK_FILE" 2>/dev/null)
    task_desc=$(jq -r '.description // ""' "$TASK_FILE" 2>/dev/null)
else
    task_subject=$(grep -o '"subject"[[:space:]]*:[[:space:]]*"[^"]*"' "$TASK_FILE" 2>/dev/null | head -1 | cut -d'"' -f4)
    task_desc=$(grep -o '"description"[[:space:]]*:[[:space:]]*"[^"]*"' "$TASK_FILE" 2>/dev/null | head -1 | cut -d'"' -f4)
fi

# Check for expected output files referenced in task description
# Look for accbmad/ paths in the description
output_paths=$(echo "$task_desc" | grep -oE 'accbmad/[a-zA-Z0-9/_.-]+\.(md|yaml|json)' 2>/dev/null || true)

if [ -n "$output_paths" ]; then
    missing=0
    while IFS= read -r path; do
        [ -z "$path" ] && continue
        # Reject path traversal attempts
        if echo "$path" | grep -qE '(\.\./|/\.\.)'; then
            echo "BMAD: Rejected suspicious path: $path"
            missing=$((missing + 1))
            continue
        fi
        if [ ! -f "$path" ]; then
            missing=$((missing + 1))
            echo "BMAD: Expected output file missing: $path"
        fi
    done <<< "$output_paths"

    if [ "$missing" -gt 0 ]; then
        echo "BMAD: Task '$task_subject' has $missing missing output file(s). Rejecting completion."
        exit 2
    fi
fi

# For dev/implementation tasks, check if tests pass
if echo "$task_subject" | grep -qiE '\b(implement|develop|story|build|fix|refactor)\b'; then
    # Detect test runner and run tests
    if [ -f "package.json" ] && grep -q '"test"' package.json 2>/dev/null; then
        if command -v npm &>/dev/null; then
            if ! npm test --silent 2>/dev/null; then
                echo "BMAD: Tests failed for task '$task_subject'. Rejecting completion."
                exit 2
            fi
        fi
    elif [ -f "pytest.ini" ] || [ -f "pyproject.toml" ] || [ -f "setup.cfg" ]; then
        if command -v pytest &>/dev/null; then
            if ! pytest --tb=no -q 2>/dev/null; then
                echo "BMAD: Tests failed for task '$task_subject'. Rejecting completion."
                exit 2
            fi
        fi
    elif [ -f "go.mod" ]; then
        if command -v go &>/dev/null; then
            if ! go test ./... 2>/dev/null; then
                echo "BMAD: Tests failed for task '$task_subject'. Rejecting completion."
                exit 2
            fi
        fi
    elif [ -f "Cargo.toml" ]; then
        if command -v cargo &>/dev/null; then
            if ! cargo test --quiet 2>/dev/null; then
                echo "BMAD: Tests failed for task '$task_subject'. Rejecting completion."
                exit 2
            fi
        fi
    fi
fi

# All validations passed
exit 0

#!/bin/bash
# BMAD Task Completed Hook
# Triggered on TaskCompleted event — receives JSON on stdin
# Validates output quality before allowing task completion
#
# Stdin JSON fields: task_id, task_subject, task_description,
#                    teammate_name (optional), team_name (optional),
#                    session_id, cwd, ...
# Exit codes:
#   0 = Allow completion (output valid)
#   2 = Reject completion (stderr feedback sent to agent)

# Read JSON input from stdin
INPUT=$(cat)

# Parse fields — require jq for JSON parsing
if ! command -v jq &>/dev/null; then
    # No jq available — cannot validate, allow completion
    exit 0
fi

TEAM_NAME=$(echo "$INPUT" | jq -r '.team_name // ""')

# Only activate for BMAD teams (bmad-* prefix)
if [[ -z "$TEAM_NAME" ]] || [[ "$TEAM_NAME" != bmad-* ]]; then
    exit 0
fi

# Extract task metadata from stdin (no disk read needed)
task_subject=$(echo "$INPUT" | jq -r '.task_subject // ""')
task_desc=$(echo "$INPUT" | jq -r '.task_description // ""')

# Check for expected output files referenced in task description
# Look for accbmad/ paths in the description
output_paths=$(echo "$task_desc" | grep -oE 'accbmad/[a-zA-Z0-9/_.-]+\.(md|yaml|json)' 2>/dev/null || true)

if [ -n "$output_paths" ]; then
    missing=0
    while IFS= read -r path; do
        [ -z "$path" ] && continue
        # Reject path traversal attempts
        if echo "$path" | grep -qE '(\.\./|/\.\.)'; then
            echo "BMAD: Rejected suspicious path in task description: $path" >&2
            missing=$((missing + 1))
            continue
        fi
        if [ ! -f "$path" ]; then
            missing=$((missing + 1))
            echo "BMAD: Expected output file missing: $path" >&2
        fi
    done <<< "$output_paths"

    if [ "$missing" -gt 0 ]; then
        echo "BMAD: Task '$task_subject' has $missing missing output file(s). Create the expected files before completing." >&2
        exit 2
    fi
fi

# For dev/implementation tasks, check if tests pass
if echo "$task_subject" | grep -qiE '\b(implement|develop|story|build|fix|refactor)\b'; then
    test_output=""
    test_failed=false

    # Detect test runner and run tests (capture output for feedback)
    if [ -f "package.json" ] && grep -q '"test"' package.json 2>/dev/null; then
        if command -v npm &>/dev/null; then
            test_output=$(npm test 2>&1) || test_failed=true
        fi
    elif [ -f "pytest.ini" ] || [ -f "pyproject.toml" ] || [ -f "setup.cfg" ]; then
        if command -v pytest &>/dev/null; then
            test_output=$(pytest --tb=short -q 2>&1) || test_failed=true
        fi
    elif [ -f "go.mod" ]; then
        if command -v go &>/dev/null; then
            test_output=$(go test ./... 2>&1) || test_failed=true
        fi
    elif [ -f "Cargo.toml" ]; then
        if command -v cargo &>/dev/null; then
            test_output=$(cargo test 2>&1) || test_failed=true
        fi
    fi

    if [ "$test_failed" = true ]; then
        # Include test output in feedback so the agent can see what failed
        {
            echo "BMAD: Tests failed for task '$task_subject'. Fix failing tests before completing."
            echo "--- Test output ---"
            echo "$test_output" | tail -30
        } >&2
        exit 2
    fi
fi

# All validations passed
exit 0

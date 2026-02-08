#!/bin/bash
# BMAD Teammate Idle Hook
# Triggered on TeammateIdle event — receives JSON on stdin
# Checks for unclaimed tasks and keeps teammate working if work remains
#
# Stdin JSON fields: teammate_name, team_name, session_id, cwd, ...
# Exit codes:
#   0 = Allow idle (no more work)
#   2 = Keep working (stderr feedback sent to teammate)

# Read JSON input from stdin
INPUT=$(cat)

# Parse team_name — only activate for BMAD teams (bmad-* prefix)
if command -v jq &>/dev/null; then
    TEAM_NAME=$(echo "$INPUT" | jq -r '.team_name // ""')
    TEAMMATE_NAME=$(echo "$INPUT" | jq -r '.teammate_name // ""')
else
    # No jq available — cannot parse input, allow idle
    exit 0
fi

if [[ -z "$TEAM_NAME" ]] || [[ "$TEAM_NAME" != bmad-* ]]; then
    exit 0
fi

TASKS_DIR="${HOME}/.claude/tasks/${TEAM_NAME}"

# If task directory doesn't exist, allow idle
if [ ! -d "$TASKS_DIR" ]; then
    exit 0
fi

# Check for unclaimed pending tasks (no owner, status=pending, not blocked)
unclaimed=0
for task_file in "$TASKS_DIR"/*.json; do
    [ -f "$task_file" ] || continue

    status=$(jq -r '.status // ""' "$task_file" 2>/dev/null)
    owner=$(jq -r '.owner // ""' "$task_file" 2>/dev/null)
    blocked_count=$(jq -r '.blockedBy | if . == null then 0 elif (. | length) == 0 then 0 else length end' "$task_file" 2>/dev/null)

    # Count unclaimed: pending status, no owner, not blocked
    if [[ "$status" == "pending" ]] && [[ -z "$owner" || "$owner" == "null" ]]; then
        if [[ "$blocked_count" -eq 0 ]]; then
            unclaimed=$((unclaimed + 1))
        fi
    fi
done

if [ "$unclaimed" -gt 0 ]; then
    # Unclaimed tasks exist — keep teammate working (feedback via stderr)
    echo "BMAD: $unclaimed unclaimed task(s) available for $TEAMMATE_NAME in $TEAM_NAME. Check TaskList and claim one." >&2
    exit 2
fi

# No unclaimed tasks — allow idle
exit 0

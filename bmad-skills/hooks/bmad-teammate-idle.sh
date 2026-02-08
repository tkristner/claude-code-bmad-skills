#!/bin/bash
# BMAD Teammate Idle Hook
# Triggered on TeammateIdle event
# Checks for unclaimed tasks and keeps teammate working if work remains
#
# Exit codes:
#   0 = Allow idle (no more work)
#   2 = Keep working (unclaimed tasks exist)

# Only activate for BMAD teams
TEAM_NAME="${CLAUDE_TEAM_NAME:-}"
if [[ -z "$TEAM_NAME" ]] || [[ "$TEAM_NAME" != bmad-* ]]; then
    exit 0
fi

TEAMMATE_NAME="${CLAUDE_TEAMMATE_NAME:-}"
TASKS_DIR="${HOME}/.claude/tasks/${TEAM_NAME}"

# If task directory doesn't exist, allow idle
if [ ! -d "$TASKS_DIR" ]; then
    exit 0
fi

# Check for unclaimed pending tasks (no owner, status=pending, not blocked)
unclaimed=0
for task_file in "$TASKS_DIR"/*.json; do
    [ -f "$task_file" ] || continue

    # Parse task status and owner (prefer jq, fall back to grep)
    if command -v jq &>/dev/null; then
        status=$(jq -r '.status // ""' "$task_file" 2>/dev/null)
        owner=$(jq -r '.owner // ""' "$task_file" 2>/dev/null)
        blocked_count=$(jq -r '.blockedBy | if . == null then 0 elif (. | length) == 0 then 0 else length end' "$task_file" 2>/dev/null)
    else
        status=$(grep -o '"status"[[:space:]]*:[[:space:]]*"[^"]*"' "$task_file" 2>/dev/null | head -1 | cut -d'"' -f4)
        owner=$(grep -o '"owner"[[:space:]]*:[[:space:]]*"[^"]*"' "$task_file" 2>/dev/null | head -1 | cut -d'"' -f4)
        blocked_count=0
        blocked_by=$(grep -o '"blockedBy"[[:space:]]*:[[:space:]]*\[[^]]*\]' "$task_file" 2>/dev/null | head -1)
        # Check if blockedBy has actual entries (not empty array)
        if [[ -n "$blocked_by" ]] && echo "$blocked_by" | grep -qE '"[^"]+' 2>/dev/null; then
            blocked_count=1
        fi
    fi

    # Count unclaimed: pending status, no owner, not blocked
    if [[ "$status" == "pending" ]] && [[ -z "$owner" || "$owner" == "null" ]]; then
        if [[ "$blocked_count" -eq 0 ]]; then
            unclaimed=$((unclaimed + 1))
        fi
    fi
done

if [ "$unclaimed" -gt 0 ]; then
    # Unclaimed tasks exist - keep teammate working
    echo "BMAD: $unclaimed unclaimed task(s) available for $TEAMMATE_NAME in $TEAM_NAME"
    exit 2
fi

# No unclaimed tasks - allow idle
exit 0

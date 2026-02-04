You are executing the **Dev Story Auto** workflow for autonomous story implementation.

## Script-Driven Loop

This workflow uses a script to manage the story queue. **You MUST follow the script's instructions.**

### Start: Run the Queue Script

```bash
./scripts/story-queue.sh next
```

The script will output:
- `ACTION: IMPLEMENT` → Process the story shown in NEXT_STORY
- `ACTION: STOP` → All stories complete, workflow done

### Process Each Story

When ACTION is IMPLEMENT, execute these steps for the story:

**Step 1: Git Branch**
```bash
git checkout develop 2>/dev/null || git checkout main
git pull origin $(git branch --show-current) 2>/dev/null || true
git checkout -b story/{story-id}
```

**Step 2: Implement** - Read story file, implement all acceptance criteria with tests.

**Step 3: CODE REVIEW (MANDATORY) - INVOKE THE SKILL**

**You MUST invoke the `/accbmad:code-review` skill using the Skill tool.**

Do NOT do an inline mini-review. You MUST actually invoke the skill:

```
Use Skill tool:
  skill: "accbmad:code-review"
  args: "--auto-fix"
```

The code-review skill will:
1. Perform adversarial review (MUST find 3-10 issues)
2. Auto-fix all issues (no user prompts with --auto-fix)
3. Re-verify fixes

**If the skill finds CRITICAL or HIGH issues, fix them and re-run the skill.**

**WARNING: Creating your own table of issues is NOT the same as invoking the skill. You MUST use the Skill tool to invoke `/accbmad:code-review`.**

**Step 4: Commit**
```bash
git add -A && git commit -m "feat({scope}): {story-title}

Implements story {story-id}
Code-reviewed and auto-fixed.

Co-Authored-By: Claude <noreply@anthropic.com>"
```

**Step 5: Verification Review** - Invoke `/accbmad:code-review --auto-fix` again after commit. If issues found, fix & amend commit.

**Step 6: Merge & Push**
```bash
git checkout develop 2>/dev/null || git checkout main
git merge story/{story-id} --no-ff
git branch -d story/{story-id}
git push origin $(git branch --show-current)
```

**Step 7: Update Status** - Set story status to `done` in sprint-status.yaml

**Step 8: GET NEXT STORY**
```bash
./scripts/story-queue.sh next
```
**Follow the script output. If ACTION: IMPLEMENT, go back to Step 1. If ACTION: STOP, workflow complete.**

## Arguments
- `--story ID` → single story only (skip queue, implement just this one)
- `--dry-run` → run `./scripts/story-queue.sh status` and show plan only

## HALT Conditions
- Script returns `ACTION: STOP`
- Code review fails 3 times on same issues
- Git conflict requiring human resolution

# Step 2: User Segments & Personas

**Step:** 2 of 4
**Purpose:** Define who the product serves and their characteristics
**Duration:** 10-15 minutes
**Entry Criteria:** Problem and opportunity defined (Step 1 complete)

---

## Objectives

Capture: Primary user segment(s), At least 1 persona, User goals, Pain points

---

## User Discovery Questions

1. **Who specifically experiences this problem?** (roles, demographics)
2. **What are their goals?** (what they're trying to accomplish)
3. **What frustrates them about current solutions?** (pain points, workarounds)
4. **How tech-savvy are they?** (comfort level, UX expectations)

### Building a Persona

```
**Name:** (representative name)
**Role:** (job title/description)
**Goals:** (what they want to achieve)
**Frustrations:** (current pain points)
**Quote:** (something they might say)
```

---

## Facilitator Instructions

- Make personas specific, not generic
- Include emotional and functional needs
- Ask: "Walk me through a day in their life"
- Ask: "What would make them recommend this?"

---

## Data to Capture

```yaml
data:
  user_segments:
    - name: "{{segment_name}}"
      description: "{{description}}"
  primary_persona:
    name: "{{persona_name}}"
    role: "{{role}}"
    goals: ["{{goal_1}}", "{{goal_2}}"]
    frustrations: ["{{pain_1}}", "{{pain_2}}"]
    quote: "{{quote}}"
```

---

## Step Completion

**Exit Criteria:**
- [ ] At least 1 user segment defined
- [ ] Primary persona has name, role, goals, frustrations
- [ ] User confirms persona is representative

**Transition:**
```
Here's our primary user persona:

**{{persona_name}}** - {{role}}
Goals: {{goals}}
Frustrations: {{frustrations}}

Does this represent your target user?
[Y] Yes, continue to value  [A] Add another  [R] Revise
```

**On Completion:** Save data, mark Step 2 complete, load Step 3

# Step 3: Value Proposition & Scope

**Step:** 3 of 4
**Purpose:** Define what value the product delivers and its boundaries
**Duration:** 10-15 minutes
**Entry Criteria:** Users defined (Step 2 complete)

---

## Objectives

Capture: Value proposition, Key features, In/Out scope, Success metrics

---

## Value Proposition Questions

### Core Value

1. **In one sentence, what does this product do for users?** (benefit, not features)
2. **What's the single most important thing it delivers?** (prioritize)
3. **How is this different from existing solutions?** (unique value)

### Scope Definition

4. **What features are essential for v1?** (must-haves, MVP)
5. **What features are explicitly NOT in v1?** (intentional exclusions)
6. **What are the product boundaries?** (integrations, constraints)

### Success Metrics

7. **How will you know if this succeeds?** (measurable outcomes, targets)

---

## Data to Capture

```yaml
data:
  value_proposition: "{{one_sentence_value}}"
  key_differentiator: "{{what_makes_it_unique}}"
  in_scope:
    - "{{feature_1}}"
    - "{{feature_2}}"
  out_of_scope:
    - "{{exclusion_1}}"
    - "{{exclusion_2}}"
  success_metrics:
    - metric: "{{metric_name}}"
      target: "{{target_value}}"
```

---

## Step Completion

**Exit Criteria:**
- [ ] Value proposition is clear and compelling
- [ ] At least 3 in-scope items defined
- [ ] At least 2 out-of-scope items defined
- [ ] At least 3 success metrics with targets

**Transition:**
```
Here's the value proposition and scope:

**Value:** {{value_proposition}}
**In Scope:** {{in_scope_list}}
**Out of Scope:** {{out_of_scope_list}}
**Metrics:** {{metrics_list}}

Ready for final review?
[Y] Yes, proceed  [R] Revise
```

**On Completion:** Save data, mark Step 3 complete, load Step 4

# Sprint Plan: {{project_name}}

**Version:** {{version}}
**Last Updated:** {{last_updated}}
**Author:** {{author}}
**Sprint Number:** {{sprint_number}}
**Sprint Dates:** {{start_date}} - {{end_date}}
**Sprint Duration:** {{duration}}
**Created:** {{creation_date}}

## Sprint Overview

**Sprint Goal:** {{Sprint_Goal}}

**Sprint Capacity:** {{Capacity}} story points
**Stories Planned:** {{Story_Count}} stories
**Total Story Points:** {{Total_Points}} points

**Capacity Calculation:**
- **Base capacity:** {{Base_Capacity}} points (from velocity history or dev-days calculation)
- **Adjustments:** {{Adjustments}}
- **Final capacity:** {{Final_Capacity}} points

## Velocity Metrics

**Historical Velocity:**
- Sprint {{N_3}}: {{Velocity_N3}} points
- Sprint {{N_2}}: {{Velocity_N2}} points
- Sprint {{N_1}}: {{Velocity_N1}} points
- **3-Sprint Average:** {{Velocity_Avg}} points

**Team Composition:**
- {{Developer_Count}} developers
- {{Dev_Days}} dev-days available this sprint
- Estimated {{Points_Per_Day}} points per dev-day

## Sprint Backlog

### Epic 1: {{Epic_1_Name}} ({{Epic_1_Points}} points)

**Epic Goal:** {{Epic_1_Goal}}

#### STORY-{{Story_Number}}: {{Story_Title}}
- **Priority:** {{Priority}}
- **Points:** {{Points}}
- **Status:** Not Started
- **Dependencies:** {{Dependencies}}
- **Brief:** {{Story_Brief}}

#### STORY-{{Story_Number}}: {{Story_Title}}
- **Priority:** {{Priority}}
- **Points:** {{Points}}
- **Status:** Not Started
- **Dependencies:** {{Dependencies}}
- **Brief:** {{Story_Brief}}

---

### Epic 2: {{Epic_2_Name}} ({{Epic_2_Points}} points)

**Epic Goal:** {{Epic_2_Goal}}

#### STORY-{{Story_Number}}: {{Story_Title}}
- **Priority:** {{Priority}}
- **Points:** {{Points}}
- **Status:** Not Started
- **Dependencies:** {{Dependencies}}
- **Brief:** {{Story_Brief}}

#### STORY-{{Story_Number}}: {{Story_Title}}
- **Priority:** {{Priority}}
- **Points:** {{Points}}
- **Status:** Not Started
- **Dependencies:** {{Dependencies}}
- **Brief:** {{Story_Brief}}

---

### Epic 3: {{Epic_3_Name}} ({{Epic_3_Points}} points)

**Epic Goal:** {{Epic_3_Goal}}

#### STORY-{{Story_Number}}: {{Story_Title}}
- **Priority:** {{Priority}}
- **Points:** {{Points}}
- **Status:** Not Started
- **Dependencies:** {{Dependencies}}
- **Brief:** {{Story_Brief}}

---

## Story Prioritization

### Must Have (Critical Path)
Stories that must be completed to achieve sprint goal:
1. {{Must_Have_Story_1}} - {{Must_Have_Brief_1}} ({{Must_Have_Points_1}} points)
2. {{Must_Have_Story_2}} - {{Must_Have_Brief_2}} ({{Must_Have_Points_2}} points)
3. {{Must_Have_Story_3}} - {{Must_Have_Brief_3}} ({{Must_Have_Points_3}} points)

**Total Must Have:** {{Must_Have_Total}} points

### Should Have (High Priority)
Important stories that significantly contribute to sprint goal:
1. {{Should_Have_Story_1}} - {{Should_Have_Brief_1}} ({{Should_Have_Points_1}} points)
2. {{Should_Have_Story_2}} - {{Should_Have_Brief_2}} ({{Should_Have_Points_2}} points)

**Total Should Have:** {{Should_Have_Total}} points

### Could Have (Nice to Have)
Lower priority stories, may be deferred if needed:
1. {{Could_Have_Story_1}} - {{Could_Have_Brief_1}} ({{Could_Have_Points_1}} points)
2. {{Could_Have_Story_2}} - {{Could_Have_Brief_2}} ({{Could_Have_Points_2}} points)

**Total Could Have:** {{Could_Have_Total}} points

## Implementation Order

Recommended sequence based on dependencies and priorities:

1. **Week 1, Days 1-2:** {{Impl_Story_1}} - {{Impl_Title_1}}
   - Rationale: {{Impl_Rationale_1}}

2. **Week 1, Days 3-5:** {{Impl_Story_2}} - {{Impl_Title_2}}
   - Rationale: {{Impl_Rationale_2}}

3. **Week 2, Days 1-2:** {{Impl_Story_3}} - {{Impl_Title_3}}
   - Rationale: {{Impl_Rationale_3}}

4. **Week 2, Days 3-5:** {{Impl_Story_4}} - {{Impl_Title_4}}
   - Rationale: {{Impl_Rationale_4}}

## Story Dependencies

### Dependency Graph
```
STORY-001 (no dependencies)
  ├─> STORY-002 (depends on STORY-001)
  └─> STORY-003 (depends on STORY-001)
       └─> STORY-004 (depends on STORY-003)

STORY-005 (no dependencies, can start immediately)
  └─> STORY-006 (depends on STORY-005)
```

### Critical Path Stories
Stories on the critical path (blocking other work):
- {{Critical_Story_1}} - Blocks {{Blocked_Stories_1}}
- {{Critical_Story_2}} - Blocks {{Blocked_Stories_2}}

### External Dependencies
- {{External_Dep_1}}: {{External_Dep_1_Details}}
- {{External_Dep_2}}: {{External_Dep_2_Details}}

## Risks and Mitigation

### Risk 1: {{Risk_1_Name}}
- **Probability:** {{Risk_1_Probability}}
- **Impact:** {{Risk_1_Impact}}
- **Mitigation:** {{Risk_1_Mitigation}}
- **Contingency:** {{Risk_1_Contingency}}

### Risk 2: {{Risk_2_Name}}
- **Probability:** {{Risk_2_Probability}}
- **Impact:** {{Risk_2_Impact}}
- **Mitigation:** {{Risk_2_Mitigation}}
- **Contingency:** {{Risk_2_Contingency}}

## Sprint Milestones

- **Day 3:** {{Milestone_1}}
- **Day 6:** {{Milestone_2}}
- **Day 9:** {{Milestone_3}}
- **Day 10:** {{Milestone_4}}

## Definition of Done

A story is complete when:

- [ ] All acceptance criteria are met
- [ ] Code is reviewed and approved
- [ ] Tests are written and passing
- [ ] Documentation is updated
- [ ] Code is merged to main branch
- [ ] Deployed to {{Deploy_Environment}}
- [ ] Product owner has accepted the story

## Sprint Ceremonies

### Daily Standups
- **Time:** {{Standup_Time}}
- **Duration:** 15 minutes
- **Format:** What I did yesterday, what I'm doing today, blockers

### Sprint Review
- **Date:** {{Review_Date}}
- **Time:** {{Review_Time}}
- **Duration:** 1-2 hours
- **Attendees:** Team, product owner, stakeholders
- **Purpose:** Demo completed stories, gather feedback

### Sprint Retrospective
- **Date:** {{Retro_Date}}
- **Time:** {{Retro_Time}}
- **Duration:** 1 hour
- **Attendees:** Team only
- **Purpose:** Reflect on process, identify improvements

### Sprint Planning (Next Sprint)
- **Date:** {{Next_Planning_Date}}
- **Time:** {{Next_Planning_Time}}
- **Duration:** 2-4 hours
- **Purpose:** Plan next sprint based on completed velocity

## Success Criteria

This sprint is successful if:
1. **Sprint goal achieved:** {{Sprint_Goal}}
2. **Velocity within range:** Complete {{Velocity_Target}} story points
3. **Quality maintained:** All stories meet definition of done
4. **No critical bugs:** Zero high-priority bugs at sprint end
5. **Team health:** Sustainable pace, no burnout

## Burndown Tracking

Track remaining story points daily or every few days:

| Date | Completed | Remaining | Ideal Remaining | Notes |
|------|-----------|-----------|-----------------|-------|
| {{Start_Date}} | 0 | {{Total_Points}} | {{Total_Points}} | Sprint begins |
| {{Track_Date_1}} | {{Completed_1}} | {{Remaining_1}} | {{Ideal_1}} | {{Notes_1}} |
| {{Track_Date_2}} | {{Completed_2}} | {{Remaining_2}} | {{Ideal_2}} | {{Notes_2}} |
| {{End_Date}} | {{Total_Points}} | 0 | 0 | Sprint complete |

## Team Capacity

### Team Members
- **Developer 1:** {{Dev_1_Name}} - {{Dev_1_Days}} dev-days available
- **Developer 2:** {{Dev_2_Name}} - {{Dev_2_Days}} dev-days available (Note: {{Dev_2_Notes}})
- **Developer 3:** {{Dev_3_Name}} - {{Dev_3_Days}} dev-days available

**Total Developer-Days:** {{Total_Dev_Days}} days

### Capacity Adjustments
- **Holidays:** {{Holiday_Dates}} - {{Holiday_Impact}}
- **PTO:** {{PTO_Details}} - {{PTO_Impact}}
- **Meetings:** Estimated {{Meeting_Percent}}% time - {{Meeting_Impact}}
- **Support/On-call:** {{Support_Percent}}% time - {{Support_Impact}}

## Notes

{{Additional_Notes}}

---

## Sprint Plan Template Usage

### Creating a Sprint Plan:
1. Fill in sprint metadata (number, dates, capacity)
2. List all stories grouped by epic
3. Assign priorities (Must/Should/Could Have)
4. Calculate total points and verify against capacity
5. Define clear sprint goal
6. Identify dependencies and critical path
7. Plan implementation sequence
8. Identify risks and mitigation strategies

### Capacity Planning:
- **New team:** Use dev-days × points/day (2-3 pts/day)
- **After Sprint 1:** Use Sprint 1 actual velocity
- **After Sprint 3+:** Use 3-sprint rolling average (recommended)

### Sprint Goal Best Practices:
- **Specific:** Clear what will be achieved
- **Achievable:** Realistic given capacity
- **Valuable:** Delivers user or business value
- **Testable:** Can verify goal is met
- **Example:** "Complete user authentication (registration, login, password reset)"

### Priority Guidelines:
- **Must Have:** 60-70% of capacity
- **Should Have:** 20-30% of capacity
- **Could Have:** 10% of capacity (buffer for velocity variance)

### Adjusting Mid-Sprint:
- If behind: Remove "Could Have" stories
- If ahead: Pull in next sprint's top priority story
- Don't add unplanned work without removing equal points
- Focus on sprint goal, not just completing points

---

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| {{version}} | {{date}} | {{author}} | {{change_description}} |
<!-- Add rows for each revision -->

---

*Generated by BMAD Method - Scrum Master Skill*

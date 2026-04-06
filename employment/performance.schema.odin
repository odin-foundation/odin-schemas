; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Performance Management Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Performance goals, OKRs, reviews, assessments, competency tracking,
; performance improvement plans (PIPs), and recognition programs.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.employment.performance"
version = "1.0.0"
title = "Performance Management Schema"
description = "Goals, reviews, assessments, competencies, PIPs, and recognition"

{$derivation}
methodology = "domain_analysis"
proprietary_sources_consulted = ?false
notes = "Performance management structures derived from common HR practices and OKR methodology"

changelog[0].date = 2025-12-21
changelog[0].change = "Initial performance management schema"
changelog[0].rationale = "Goal tracking, reviews, competencies, and performance improvement plans"

; ═══════════════════════════════════════════════════════════════════════════════
; GOAL
; ═══════════════════════════════════════════════════════════════════════════════

{@goal}
= @types.audit_info

goal_id = !:                                     ; Unique goal identifier
employee_id = !:                                 ; Associated employee
goal_type = (development, okr, performance, project, smart)
goal_category = (business_objective, competency_development, individual, organizational, team)

title = !:                                       ; Goal title
description = !:                                 ; Goal description
success_criteria = :                             ; Measurable success criteria

; Timeframe
start_date = !date                               ; Goal start date
target_date = !date                              ; Target completion date
completed_date = date                            ; Actual completion date

; OKR-specific fields
objective = :if goal_type = okr                  ; Objective statement
{.key_results[]}
:if goal_type = okr                              ; Key results for OKR
key_result = !:                                  ; Key result description
target_value = :                                 ; Target metric value
current_value = :                                ; Current metric value
progress_percent = ##:(0..100)                   ; Progress percentage

{@goal}

; Progress tracking
status = (achieved, at_risk, cancelled, in_progress, not_started, on_track)
progress_percent = ##:(0..100)                   ; Overall progress
last_update_date = date                          ; Last progress update

; Weight and priority
weight = #:(0..100)                              ; Goal weight (for weighted scoring)
priority = (critical, high, low, medium)         ; Goal priority

; Alignment
aligned_to_goal_id = :                           ; Parent/organizational goal
manager_id = :                                   ; Manager who assigned goal

notes = :                                        ; Goal notes
coaching_notes = :                               ; Manager coaching notes

; ═══════════════════════════════════════════════════════════════════════════════
; PERFORMANCE REVIEW
; ═══════════════════════════════════════════════════════════════════════════════

{@performance_review}
= @types.audit_info

review_id = !:                                   ; Unique review identifier
employee_id = !:                                 ; Associated employee
review_type = (annual, mid_year, probationary, project, quarterly)
review_period_start = !date                      ; Review period start
review_period_end = !date                        ; Review period end
review_date = date                               ; Date review conducted

reviewer_id = !:                                 ; Primary reviewer (manager)
reviewer_name = :                                ; Reviewer name

; Overall rating
overall_rating = ##:(1..5)                       ; Overall performance rating (1-5)
rating_scale = :                                 ; Description of rating scale

; Competency assessments
competency_assessments[] = @competency_assessment

; Goal achievement
{.goal_review[]}
goal_id = !:                                     ; Goal identifier
goal_title = :                                   ; Goal title
achievement_rating = ##:(1..5)                   ; Achievement rating
achievement_percent = ##:(0..100)                ; Percent achieved
comments = :                                     ; Comments on goal

{@performance_review}

; Review content
strengths = :                                    ; Employee strengths
areas_for_improvement = :                        ; Improvement areas
accomplishments = :                              ; Key accomplishments
challenges = :                                   ; Challenges faced

; Future development
development_needs = :                            ; Development needs identified
career_aspirations = :                           ; Employee career goals
succession_potential = (high_potential, ready_now, ready_1_2_years, ready_3_5_years, not_ready)

; Compensation impact
salary_increase_percent = #:(0..100)             ; Recommended salary increase
salary_increase_amount = #$:(0..)                ; Recommended increase amount
bonus_recommended = #$:(0..)                     ; Recommended bonus
promotion_recommended = ?                        ; Promotion recommended
promotion_title = :if promotion_recommended = true

; Signatures and acknowledgment
manager_signature_date = date                    ; Manager signature date
employee_signature_date = date                   ; Employee acknowledgment date
employee_comments = :                            ; Employee comments
employee_disagrees = ?                           ; Employee disagrees with review

status = (acknowledged, completed, draft, in_progress, submitted)
status_date = date                               ; Date of status change

; ═══════════════════════════════════════════════════════════════════════════════
; COMPETENCY ASSESSMENT
; ═══════════════════════════════════════════════════════════════════════════════

{@competency_assessment}
competency_id = !:                               ; Competency identifier
competency_name = !:                             ; Competency name
competency_category = (behavioral, functional, leadership, technical)
competency_description = :                       ; Competency description

rating = !##:(1..5)                              ; Competency rating (1-5)
required_level = ##:(1..5)                       ; Required proficiency level
current_level = ##:(1..5)                        ; Current proficiency level
gap = ##                                         ; Proficiency gap

comments = :                                     ; Comments on competency
examples = :                                     ; Behavioral examples
development_actions = :                          ; Recommended development

; ═══════════════════════════════════════════════════════════════════════════════
; 360-DEGREE FEEDBACK
; ═══════════════════════════════════════════════════════════════════════════════

{@feedback_360}
= @types.audit_info

feedback_id = !:                                 ; Unique feedback identifier
employee_id = !:                                 ; Employee being reviewed
review_cycle = !:                                ; Review cycle identifier
cycle_start_date = !date                         ; Cycle start
cycle_end_date = !date                           ; Cycle end

; Feedback sources
{.feedback_sources[]}
:(1..)                                           ; At least one source
source_type = (direct_report, manager, peer, self, other)
source_id = :                                    ; Source employee ID (anonymous if blank)
source_name = :                                  ; Source name (if not anonymous)
anonymous = ?                                    ; Anonymous feedback

{@feedback_360}

; Consolidated feedback
{.consolidated_ratings[]}
competency = !:                                  ; Competency name
self_rating = ##:(1..5)                          ; Self rating
manager_avg = #:(1..5)                           ; Manager average
peer_avg = #:(1..5)                              ; Peer average
direct_report_avg = #:(1..5)                     ; Direct report average
overall_avg = #:(1..5)                           ; Overall average

{@feedback_360}

strengths_themes = :                             ; Common strength themes
development_themes = :                           ; Common development themes
actionable_insights = :                          ; Key insights for development

report_released_date = date                      ; Date report released
acknowledgment_date = date                       ; Employee acknowledgment

; ═══════════════════════════════════════════════════════════════════════════════
; PERFORMANCE IMPROVEMENT PLAN (PIP)
; ═══════════════════════════════════════════════════════════════════════════════

{@performance_improvement_plan}
= @types.audit_info

pip_id = !:                                      ; Unique PIP identifier
employee_id = !:                                 ; Associated employee
manager_id = !:                                  ; Manager overseeing PIP

start_date = !date                               ; PIP start date
review_date = !date                              ; Review/checkpoint date
end_date = !date                                 ; PIP end date
duration_days = ##:(1..)                         ; PIP duration

; Performance issues
{.performance_issues[]}
:(1..)                                           ; At least one issue
issue_category = (attendance, behavior, communication, productivity, quality, skills)
issue_description = !:                           ; Detailed description
impact = :                                       ; Impact of issue
prior_discussions[] = date                       ; Dates of prior discussions
prior_warnings[] = date                          ; Dates of prior warnings

{@performance_improvement_plan}

; Improvement expectations
{.expectations[]}
:(1..)                                           ; At least one expectation
expectation_description = !:                     ; What must improve
success_criteria = !:                            ; How success is measured
target_date = date                               ; Target completion
achieved = ?                                     ; Expectation met
achievement_date = date                          ; Date achieved

{@performance_improvement_plan}

; Support and resources
manager_support = :                              ; Manager support provided
training_required[] = :                          ; Required training
resources_provided = :                           ; Resources/tools provided

; Check-ins
{.checkpoints[]}
checkpoint_date = !date                          ; Checkpoint date
progress_summary = :                             ; Progress summary
concerns = :                                     ; Ongoing concerns
next_steps = :                                   ; Next steps

{@performance_improvement_plan}

; Outcome
status = (active, cancelled, completed, extended)
outcome = (expectations_met, partially_met, not_met):if status = completed
outcome_date = date                              ; Date of outcome
outcome_notes = :                                ; Outcome notes
extended_end_date = date:if status = extended    ; New end date if extended

; Consequences
consequences_if_unsuccessful = :                 ; Consequences documented
termination_recommended = ?:if outcome = not_met ; Termination recommended
termination_date = date                          ; Termination date if applicable

employee_signature_date = date                   ; Employee signature
manager_signature_date = date                    ; Manager signature
hr_signature_date = date                         ; HR signature

; ═══════════════════════════════════════════════════════════════════════════════
; RECOGNITION
; ═══════════════════════════════════════════════════════════════════════════════

{@recognition}
= @types.audit_info

recognition_id = !:                              ; Unique recognition identifier
employee_id = !:                                 ; Employee being recognized
recognition_type = (award, bonus, certificate, peer_recognition, public_acknowledgment, service_anniversary, spot_award)
recognition_date = !date                         ; Date of recognition

awarded_by = !:                                  ; Who gave recognition
awarded_by_name = :                              ; Name of person/department

title = !:                                       ; Recognition title
description = !:                                 ; What was recognized
reason = :                                       ; Reason for recognition
accomplishment = :                               ; Specific accomplishment

; Monetary recognition
monetary_award = #$:(0..)                        ; Monetary value if applicable
award_date = date                                ; Date award given/paid

; Non-monetary recognition
certificate_issued = ?                           ; Certificate issued
gift_card_amount = #$:(0..)                      ; Gift card value
physical_award = :                               ; Physical award description

public_announcement = ?                          ; Publicly announced
announcement_channel = :                         ; Where announced

employee_notified_date = date                    ; Date employee notified
presentation_date = date                         ; Date presented (if ceremony)

; ═══════════════════════════════════════════════════════════════════════════════
; SUCCESSION PLAN
; ═══════════════════════════════════════════════════════════════════════════════

{@succession_plan}
= @types.audit_info

succession_plan_id = !:                          ; Unique plan identifier
position_id = !:                                 ; Critical position
position_title = !:                              ; Position title
department = :                                   ; Department
current_incumbent_id = :                         ; Current employee in position

criticality = (critical, high, medium)          ; Position criticality
risk_of_vacancy = (high, low, medium)            ; Risk of upcoming vacancy

; Succession candidates
{.candidates[]}
:(1..)                                           ; At least one candidate
candidate_employee_id = !:                       ; Candidate employee ID
candidate_name = :                               ; Candidate name
current_position = :                             ; Current role
readiness = (ready_1_2_years, ready_3_5_years, ready_now)
development_needs = :                            ; Development needed
development_plan = :                             ; Development plan

{@succession_plan}

review_date = date                               ; Last review date
next_review_date = date                          ; Next review date

notes = :                                        ; Plan notes

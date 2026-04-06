; ===================================================================================
; ODIN Construction Schedule Schema
; ===================================================================================
; Project schedules, activities, dependencies, and CPM scheduling.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.construction.schedule"
version = "1.0.0"
title = "Construction Schedule Schema"
description = "Project schedules and CPM scheduling"

{$derivation}
source[0].authority = "PMI"
source[0].citation = "PMBOK Guide - Schedule Management"
source[0].url = "https://www.pmi.org/"

source[1].authority = "AACE"
source[1].citation = "AACE Recommended Practices for Scheduling"
source[1].url = "https://www.aacei.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial construction schedule schema"
changelog[0].rationale = "Schedule structures for construction operations"

; ===================================================================================
; SCHEDULE
; ===================================================================================

{@schedule}
= @types.audit_info

schedule_id = :                                ; Schedule identifier
project_id = :                                 ; Project reference
schedule_name = :                              ; Schedule name
schedule_type = (baseline, current, recovery, target, what_if)

version = :                                     ; Schedule version
data_date = date                               ; Data date
last_update = timestamp                         ; Last update timestamp
updated_by = :                                  ; Updated by

; Summary
total_activities = ##:(0..)                     ; Total activities
completed_activities = ##:(0..)                 ; Completed activities
in_progress_activities = ##:(0..)               ; In-progress activities

project_start = date                            ; Project start date
project_finish = date                           ; Project finish date
original_duration = ##:(0..)                    ; Original duration (days)
remaining_duration = ##:(0..)                   ; Remaining duration (days)

percent_complete = #:(0..100)                   ; Percent complete
critical_path_length = ##:(0..)                 ; Critical path length (days)
total_float = ##                                ; Total float (days)

status = (approved, baseline, draft, superseded, working)
approved_by = :                                 ; Approved by
approved_date = date                            ; Approved date

activities[] = @activity                        ; Schedule activities
milestones[] = @schedule_milestone              ; Schedule milestones
calendars[] = @calendar                         ; Work calendars

; ===================================================================================
; ACTIVITY
; ===================================================================================

{@activity}
= @types.audit_info

activity_id = :                                ; Activity identifier
activity_name = :                              ; Activity name
wbs_code = :                                    ; WBS code
activity_code = :                               ; Activity code

activity_type = (finish_milestone, hammock, level_of_effort, start_milestone, task)
task_type = (fixed_duration, fixed_units, fixed_work)

; Description
description = :                                 ; Description
notes = :                                       ; Notes

; Responsibility
responsible_party = :                           ; Responsible contractor
trade = :                                       ; Trade
resource_ids[] = :                              ; Resource IDs

; Dates - Original
original_start = date                           ; Original start
original_finish = date                          ; Original finish
original_duration = ##:(0..)                    ; Original duration

; Dates - Current/Planned
early_start = date                              ; Early start
early_finish = date                             ; Early finish
late_start = date                               ; Late start
late_finish = date                              ; Late finish
planned_start = date                            ; Planned start
planned_finish = date                           ; Planned finish

; Dates - Actual
actual_start = date                             ; Actual start
actual_finish = date                            ; Actual finish

; Duration
planned_duration = ##:(0..)                     ; Planned duration (days)
actual_duration = ##:(0..)                      ; Actual duration (days)
remaining_duration = ##:(0..)                   ; Remaining duration (days)

; Float
total_float = ##                                ; Total float (days)
free_float = ##                                 ; Free float (days)
critical = ?                                    ; On critical path

; Progress
percent_complete = #:(0..100)                   ; Percent complete
physical_percent = #:(0..100)                   ; Physical percent complete

; Cost
budgeted_cost = #$:(0..)                        ; Budgeted cost
actual_cost = #$:(0..)                          ; Actual cost to date
cost_percent_complete = #:(0..100)              ; Cost percent complete

; Calendar
calendar_id = :                                 ; Calendar assignment

status = (complete, in_progress, not_started)
constraint_type = (as_late_as_possible, finish_no_later, must_finish, must_start, start_no_earlier)
constraint_date = date                          ; Constraint date

dependencies[] = @dependency                    ; Activity dependencies

; ===================================================================================
; DEPENDENCY
; ===================================================================================

{@dependency}
predecessor_id = :                             ; Predecessor activity
successor_id = :                               ; Successor activity
dependency_type = (finish_to_finish, finish_to_start, start_to_finish, start_to_start)
lag = ##                                        ; Lag in days (+ or -)
driving = ?                                     ; Driving relationship

; ===================================================================================
; SCHEDULE MILESTONE
; ===================================================================================

{@schedule_milestone}
milestone_id = :                               ; Milestone identifier
milestone_name = :                             ; Milestone name
milestone_type = (contractual, internal, owner, regulatory)

baseline_date = date                            ; Baseline date
planned_date = date                             ; Planned date
forecast_date = date                            ; Forecast date
actual_date = date                              ; Actual date

variance = ##                                   ; Variance in days
critical = ?                                    ; Critical milestone
status = (achieved, at_risk, late, on_track)

; ===================================================================================
; CALENDAR
; ===================================================================================

{@calendar}
calendar_id = :                                ; Calendar identifier
calendar_name = :                              ; Calendar name
calendar_type = (7_day, 5_day, 6_day, custom)

; Work hours
hours_per_day = #:(0..24) "8"                   ; Hours per day
work_start = time                               ; Work start time
work_end = time                                 ; Work end time

; Work days
sunday = ?                                      ; Sunday is workday
monday = ? "true"                               ; Monday is workday
tuesday = ? "true"                              ; Tuesday is workday
wednesday = ? "true"                            ; Wednesday is workday
thursday = ? "true"                             ; Thursday is workday
friday = ? "true"                               ; Friday is workday
saturday = ?                                    ; Saturday is workday

holidays[] = @holiday                           ; Holidays/non-work days

; ===================================================================================
; HOLIDAY
; ===================================================================================

{@holiday}
date = date                                    ; Holiday date
name = :                                        ; Holiday name
recurring = ?                                   ; Recurring annually

; ===================================================================================
; SCHEDULE DELAY
; ===================================================================================

{@schedule_delay}
delay_id = :                                   ; Delay identifier
project_id = :                                 ; Project reference
schedule_id = :                                 ; Schedule reference

delay_type = (compensable, concurrent, excusable, non_excusable)
cause = (design_issue, force_majeure, labor, material, owner_change, permit, subcontractor, weather)

description = :                                 ; Delay description
affected_activities[] = :                       ; Affected activity IDs

start_date = date                              ; Delay start date
end_date = date                                 ; Delay end date
duration = ##:(0..)                             ; Delay duration in days
critical_impact = ##:(0..)                      ; Impact to critical path

responsible_party = :                           ; Responsible party
status = (analysis, claimed, documented, resolved)

time_extension_requested = ##:(0..)             ; Days requested
time_extension_granted = ##:(0..)               ; Days granted
cost_claimed = #$:(0..)                         ; Cost claimed
cost_granted = #$:(0..)                         ; Cost granted

; ===================================================================================
; LOOKAHEAD SCHEDULE
; ===================================================================================

{@lookahead}
lookahead_id = :                               ; Lookahead identifier
project_id = :                                 ; Project reference
period_start = date                            ; Period start
period_end = date                              ; Period end
weeks = ##:(1..) "3"                            ; Number of weeks

created = timestamp                        ; Created date
created_by = :                                  ; Created by
status = (approved, draft, issued)

activities[] = @lookahead_activity              ; Lookahead activities

; ===================================================================================
; LOOKAHEAD ACTIVITY
; ===================================================================================

{@lookahead_activity}
activity_id = :                                ; Schedule activity reference
activity_name = :                               ; Activity name
responsible = :                                 ; Responsible contractor

planned_start = date                            ; Planned start this period
planned_finish = date                           ; Planned finish this period

prerequisites_ready = ?                         ; Prerequisites ready
materials_ready = ?                             ; Materials ready
labor_available = ?                             ; Labor available
equipment_available = ?                         ; Equipment available

constraints = :                                 ; Constraints/issues
notes = :                                       ; Notes


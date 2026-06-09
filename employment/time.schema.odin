; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Time & Attendance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Time tracking, attendance, schedules, shifts, absences, PTO, and overtime
; management for workforce planning and payroll integration.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.employment.time"
version = "1.0.0"
title = "Time & Attendance Schema"
description = "Timecards, punches, schedules, absences, and PTO tracking"

{$derivation}
source[0].authority = "U.S. Department of Labor"
source[0].citation = "Fair Labor Standards Act (FLSA), 29 USC 207"
source[0].url = "https://www.law.cornell.edu/uscode/text/29/chapter-8"

source[1].authority = "U.S. Department of Labor"
source[1].citation = "FLSA Recordkeeping Requirements, 29 CFR Part 516"
source[1].url = "https://www.dol.gov/agencies/whd/fact-sheets/21-flsa-recordkeeping"

source[2].authority = "U.S. Department of Labor"
source[2].citation = "Family and Medical Leave Act (FMLA), 29 USC 2601 et seq."
source[2].url = "https://www.ecfr.gov/current/title-29/subtitle-B/chapter-V/subchapter-C/part-825"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial time and attendance schema"
changelog[0].rationale = "Timecard, schedule, absence tracking derived from FLSA and FMLA recordkeeping requirements"

; ═══════════════════════════════════════════════════════════════════════════════
; TIMECARD
; ═══════════════════════════════════════════════════════════════════════════════

{@timecard}
= @types.audit_info

timecard_id = :                                 ; Unique timecard identifier
employee_id = :                                 ; Associated employee
pay_period_id = :                               ; Associated pay period
period_start_date = date                        ; Timecard period start
period_end_date = date                          ; Timecard period end

; Hours summary
{.hours}
regular_hours = #:(0..)                         ; Regular hours worked
overtime_hours = #:(0..)                         ; Overtime hours (over 40/week)
double_time_hours = #:(0..)                      ; Double-time hours
holiday_hours = #:(0..)                          ; Holiday hours worked
pto_hours = #:(0..)                              ; PTO hours used
sick_hours = #:(0..)                             ; Sick hours used
bereavement_hours = #:(0..)                      ; Bereavement hours used
jury_duty_hours = #:(0..)                        ; Jury duty hours
other_paid_hours = #:(0..)                       ; Other paid time
unpaid_hours = #:(0..)                           ; Unpaid time off
total_hours = #:(0..)                           ; Total hours

{@timecard}

; Time entries
time_entries[] = @time_entry                     ; Daily time entries
punches[] = @punch                               ; Clock in/out punches

status = (approved, rejected, submitted, unsubmitted)
submitted_date = date                            ; Date submitted
approved_date = date                             ; Date approved
approved_by = :                                  ; Who approved timecard
rejected_date = date                             ; Date rejected
rejected_by = :                                  ; Who rejected timecard
rejection_reason = :                             ; Reason for rejection

notes = :                                        ; Timecard notes

; ═══════════════════════════════════════════════════════════════════════════════
; TIME ENTRY
; ═══════════════════════════════════════════════════════════════════════════════

{@time_entry}
entry_id = :                                    ; Unique entry identifier
work_date = date                                ; Date worked
day_of_week = (friday, monday, saturday, sunday, thursday, tuesday, wednesday)

; Time worked
in_time = time                                   ; Shift start time
out_time = time                                  ; Shift end time
break_minutes = ##:(0..)                         ; Unpaid break time (minutes)

regular_hours = #:(0..)                          ; Regular hours
overtime_hours = #:(0..)                         ; Overtime hours
double_time_hours = #:(0..)                      ; Double-time hours
total_hours = #:(0..)                           ; Total hours for day

; Labor allocation
department = :                                   ; Department code
cost_center = :                                  ; Cost center code
job_code = :                                     ; Job/project code
task_code = :                                    ; Task code

entry_type = (absence, holiday, regular, pto, sick)
notes = :                                        ; Entry notes

; ═══════════════════════════════════════════════════════════════════════════════
; PUNCH
; ═══════════════════════════════════════════════════════════════════════════════

{@punch}
punch_id = :                                    ; Unique punch identifier
employee_id = :                                 ; Associated employee
punch_timestamp = timestamp                     ; Punch timestamp
punch_type = (break_end, break_start, clock_in, clock_out)
punch_method = (badge, biometric, mobile, terminal, web)

location = :                                     ; Punch location
terminal_id = :                                  ; Terminal/device ID
ip_address = :                                   ; IP address if web/mobile
gps_latitude = #:(-90..90)                       ; GPS latitude if mobile
gps_longitude = #:(-180..180)                    ; GPS longitude if mobile

edited = ?                                       ; Punch was edited
edited_by = :if edited = true                    ; Who edited punch
edited_timestamp = timestamp:if edited = true    ; When punch was edited
edit_reason = :if edited = true                  ; Reason for edit
original_timestamp = timestamp:if edited = true  ; Original punch time

; ═══════════════════════════════════════════════════════════════════════════════
; SCHEDULE
; ═══════════════════════════════════════════════════════════════════════════════

{@schedule}
= @types.audit_info

schedule_id = :                                 ; Unique schedule identifier
employee_id = :                                 ; Associated employee
schedule_name = :                                ; Schedule name/description
effective_start_date = date                     ; Schedule start date
effective_end_date = date                        ; Schedule end date (blank if ongoing)

schedule_type = (fixed, rotating, variable)      ; Schedule type
rotation_weeks = ##:(1..):if schedule_type = rotating

; Weekly pattern
{.weekly_pattern[]}
:(0..7)                                          ; Up to 7 days
day_of_week = (friday, monday, saturday, sunday, thursday, tuesday, wednesday)
shift_id = :                                     ; Associated shift ID
scheduled_start = time                          ; Scheduled start time
scheduled_end = time                            ; Scheduled end time
scheduled_hours = #:(0..24)                     ; Scheduled hours
break_minutes = ##:(0..)                         ; Scheduled break (minutes)
work_day = ?                                     ; Is a work day
department = :                                   ; Department
location = :                                     ; Work location

{@schedule}

status = (active, inactive, pending)             ; Schedule status

; ═══════════════════════════════════════════════════════════════════════════════
; SHIFT
; ═══════════════════════════════════════════════════════════════════════════════

{@shift}
shift_id = :                                    ; Unique shift identifier
shift_name = :                                  ; Shift name
shift_code = :                                   ; Shift code
shift_type = (day, evening, graveyard, night, swing)

start_time = time                               ; Shift start time
end_time = time                                 ; Shift end time
duration_hours = #:(0..24)                      ; Shift duration
break_minutes = ##:(0..)                         ; Paid/unpaid break (minutes)

shift_differential = #$:(0..)                    ; Shift differential pay
shift_differential_percent = #:(0..100)          ; Differential percentage

department = :                                   ; Department
location = :                                     ; Work location

active = ?                                       ; Shift is active

; ═══════════════════════════════════════════════════════════════════════════════
; ABSENCE
; ═══════════════════════════════════════════════════════════════════════════════

{@absence}
= @types.audit_info

absence_id = :                                  ; Unique absence identifier
employee_id = :                                 ; Associated employee
absence_type = (bereavement, fmla, jury_duty, military, personal, pto, sick, unpaid)

start_date = date                               ; Absence start date
end_date = date                                  ; Absence end date (blank if ongoing)
total_days = #:(0..)                             ; Total absence days
total_hours = #:(0..)                            ; Total absence hours

paid = ?                                         ; Paid absence
approved = ?                                     ; Absence approved

requested_date = date                            ; Date requested
approved_date = date                             ; Date approved
approved_by = :                                  ; Who approved absence
denied_date = date                               ; Date denied
denied_by = :                                    ; Who denied absence
denial_reason = :                                ; Reason for denial

; FMLA-specific fields
fmla_qualifying_reason = (
    birth_adoption,
    care_for_family_member,
    military_caregiver,
    qualifying_exigency,
    serious_health_condition
):if absence_type = fmla
fmla_intermittent = ?:if absence_type = fmla     ; Intermittent leave
fmla_reduced_schedule = ?:if absence_type = fmla ; Reduced schedule
fmla_year_start = date:if absence_type = fmla    ; FMLA year start
fmla_hours_used_ytd = #:(0..):if absence_type = fmla

notes = :                                        ; Absence notes
medical_certification = ?                        ; Medical cert required/provided

; ═══════════════════════════════════════════════════════════════════════════════
; PTO BALANCE
; ═══════════════════════════════════════════════════════════════════════════════

{@pto_balance}
= @types.audit_info

employee_id = :                                 ; Associated employee
pto_type = (bereavement, floating_holiday, personal, pto, sick, vacation)

; Balances
balance_hours = #:(0..)                         ; Current balance (hours)
accrued_hours = #:(0..)                          ; Total accrued (this year)
used_hours = #:(0..)                             ; Total used (this year)
scheduled_hours = #:(0..)                        ; Scheduled/pending hours
available_hours = #:(0..)                        ; Available to use

; Accrual rules
accrual_rate = #:(0..)                           ; Accrual rate (hours per period)
accrual_frequency = (annual, biweekly, monthly, pay_period, semi_monthly, weekly)
accrual_start_date = date                        ; When accrual started
next_accrual_date = date                         ; Next accrual date

max_balance_hours = #:(0..)                      ; Maximum balance cap
max_carryover_hours = #:(0..)                    ; Maximum carryover to next year
carryover_expiration_date = date                 ; When carryover expires

; Anniversary/calendar tracking
balance_year = ##:(1900..)                       ; Balance year
balance_year_start = date                        ; Year start date
balance_year_end = date                          ; Year end date

; ═══════════════════════════════════════════════════════════════════════════════
; PTO TRANSACTION
; ═══════════════════════════════════════════════════════════════════════════════

{@pto_transaction}
= @types.audit_info

transaction_id = :                              ; Unique transaction ID
employee_id = :                                 ; Associated employee
pto_type = (bereavement, floating_holiday, personal, pto, sick, vacation)

transaction_date = date                         ; Transaction date
transaction_type = (accrual, adjustment, carryover, usage)
hours = #                                       ; Hours (positive = add, negative = deduct)

reason = :                                       ; Transaction reason
reference_id = :                                 ; Reference (timecard, absence ID)
balance_after = #:(0..)                          ; Balance after transaction

approved_by = :                                  ; Who approved transaction
notes = :                                        ; Transaction notes

; ═══════════════════════════════════════════════════════════════════════════════
; OVERTIME TRACKING
; ═══════════════════════════════════════════════════════════════════════════════

{@overtime}
employee_id = :                                 ; Associated employee
work_week_start = date                          ; Work week start (FLSA)
work_week_end = date                            ; Work week end

regular_hours = #:(0..40)                       ; Regular hours (up to 40)
overtime_hours = #:(0..)                         ; Overtime hours (over 40)
total_hours = #:(0..)                           ; Total hours worked

:invariant total_hours = regular_hours + overtime_hours

flsa_workweek_overtime = #:(0..)                 ; FLSA overtime (over 40/week)
daily_overtime_hours = #:(0..)                   ; Daily OT (state-specific, e.g., CA)
seventh_day_hours = #:(0..)                      ; Seventh consecutive day

overtime_approved = ?                            ; Overtime pre-approved
approved_by = :                                  ; Who approved overtime
overtime_reason = :                              ; Reason for overtime

notes = :                                        ; Overtime notes

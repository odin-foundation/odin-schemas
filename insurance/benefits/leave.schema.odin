; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Leave Benefits Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Paid time off, parental leave, bereavement, and military leave benefits derived
; from FMLA, USERRA, and state paid leave laws.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as benefits

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.benefits.leave"
version = "1.0.0"
title = "Leave Benefits Schema"
description = "Paid time off, parental leave, bereavement, and military leave"

{$derivation}
source[0].authority = "DOL"
source[0].citation = "29 CFR Part 825 - FMLA Regulations"
source[0].url = "https://www.ecfr.gov/current/title-29/subtitle-B/chapter-V/subchapter-C/part-825"

source[1].authority = "DOL"
source[1].citation = "38 USC Chapter 43 - USERRA"
source[1].url = "https://www.law.cornell.edu/uscode/text/38/chapter-43"

source[2].authority = "DOL"
source[2].citation = "State Paid Family and Medical Leave Programs"
source[2].url = "https://www.dol.gov/agencies/whd/fmla"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial leave benefits schema"
changelog[0].rationale = "Structure derived from FMLA, USERRA, and state leave laws"

; ═══════════════════════════════════════════════════════════════════════════════
; PAID TIME OFF (PTO) POLICY
; ═══════════════════════════════════════════════════════════════════════════════

{@pto_policy}
policy_id = !:                              ; Policy ID
employer_id = !:                            ; Employer
policy_name = !:                            ; Policy name

; Policy type
{.type}
pto_type = !(combined, separate, unlimited)
; combined = single PTO bank
; separate = separate vacation, sick, personal
; unlimited = unlimited PTO
combined_pto = ?:if pto_type = combined
separate_banks = ?:if pto_type = separate

{@pto_policy}

; Accrual structure (if not unlimited)
{.accrual}
accrual_method = (anniversary, calendar, per_pay_period)
accrual_frequency = (annual_grant, biweekly, monthly, per_hour_worked)
front_loaded = ?                            ; Front-loaded at year start
proration_new_hires = ?                     ; Prorate for new hires

{@pto_policy}

; Accrual tiers by tenure
{.tiers}
{@pto_policy.tiers[]}
years_of_service_min = ##:(0..50)           ; Minimum years of service
years_of_service_max = ##:(0..50)           ; Maximum years of service
annual_accrual_days = ##:(0..60)            ; Annual days accrued
annual_accrual_hours = ##:(0..480)          ; Annual hours accrued
accrual_rate_per_period = #:(0..50)         ; Rate per accrual period

{@pto_policy}

; Carryover
{.carryover}
carryover_allowed = ?                       ; Carryover allowed
carryover_limit_days = ##:(0..90)           ; Maximum carryover days
carryover_limit_hours = ##:(0..720)         ; Maximum carryover hours
use_by_date = date                          ; Use carryover by date
forfeit_unused = ?                          ; Forfeit unused carryover

{@pto_policy}

; Maximum balance
{.cap}
accrual_cap = ?                             ; Cap on accrual
accrual_cap_days = ##:(0..120)              ; Maximum days accumulated
accrual_cap_hours = ##:(0..960)             ; Maximum hours accumulated
accrual_stops_at_cap = ?                    ; Stop accruing at cap

{@pto_policy}

; Usage
{.usage}
minimum_increment_hours = #:(0.25..8)       ; Minimum increment
advance_notice_days = ##:(0..30)            ; Advance notice required
blackout_periods[] = :                      ; Blackout periods
manager_approval_required = ?               ; Manager approval
negative_balance_allowed = ?                ; Negative balance allowed

{@pto_policy}

; Payout
{.payout}
payout_at_termination = ?                   ; Payout at termination
payout_cap_days = ##:(0..60)                ; Maximum payout days
payout_rate = (current_rate, hire_rate)     ; Payout rate
voluntary_termination_payout = ?            ; Payout for voluntary term
involuntary_termination_payout = ?          ; Payout for involuntary term

{@pto_policy}

; ═══════════════════════════════════════════════════════════════════════════════
; VACATION POLICY (if separate from PTO)
; ═══════════════════════════════════════════════════════════════════════════════

{@vacation_policy}
policy_id = !:                              ; Policy ID
employer_id = !:                            ; Employer

; Accrual by tenure
{@vacation_policy.tiers[]}
years_of_service_min = ##:(0..50)           ; Minimum years
years_of_service_max = ##:(0..50)           ; Maximum years
annual_days = ##:(0..40)                    ; Annual vacation days
annual_hours = ##:(0..320)                  ; Annual vacation hours

{@vacation_policy}

; Accrual
{.accrual}
accrual_frequency = (annual_grant, biweekly, monthly)
front_loaded = ?                            ; Front-loaded
waiting_period_days = ##:(0..180)           ; Waiting period

{@vacation_policy}

; Carryover
{.carryover}
carryover_allowed = ?                       ; Carryover allowed
carryover_limit_days = ##:(0..30)           ; Carryover limit
use_by_date = date                          ; Use-by date

{@vacation_policy}

; ═══════════════════════════════════════════════════════════════════════════════
; SICK LEAVE POLICY
; ═══════════════════════════════════════════════════════════════════════════════

{@sick_leave_policy}
policy_id = !:                              ; Policy ID
employer_id = !:                            ; Employer

; Accrual
{.accrual}
accrual_method = (accrued, front_loaded, per_hour_worked)
annual_days = ##:(0..30)                    ; Annual sick days
annual_hours = ##:(0..240)                  ; Annual sick hours
accrual_rate_per_hour = #:(0..1)            ; Hours accrued per hour worked

{@sick_leave_policy}

; Carryover
{.carryover}
carryover_allowed = ?                       ; Carryover allowed
carryover_limit_days = ##:(0..90)           ; Carryover limit
carryover_limit_hours = ##:(0..720)         ; Carryover hours limit
no_carryover_cap = ?                        ; Unlimited carryover

{@sick_leave_policy}

; Usage
{.usage}
allowed_uses[] = :                          ; Allowed uses (own illness, family, safe leave, etc.)
documentation_required_days = ##:(0..5)     ; Days before documentation required
minimum_increment_hours = #:(0.25..8)       ; Minimum increment

{@sick_leave_policy}

; Payout
{.payout}
payout_at_termination = ?                   ; Payout at termination
payout_to_retirement_fund = ?               ; Convert to retirement credit

{@sick_leave_policy}

; State compliance - Per state sick leave laws
{.compliance}
state_law_compliance[] = :(2)               ; State codes

{@sick_leave_policy}

; ═══════════════════════════════════════════════════════════════════════════════
; PARENTAL LEAVE POLICY
; ═══════════════════════════════════════════════════════════════════════════════

{@parental_leave_policy}
policy_id = !:                              ; Policy ID
employer_id = !:                            ; Employer
policy_name = !:                            ; Policy name

; Leave types
{.types}
birth_parent_leave = ?                      ; Birth parent leave
non_birth_parent_leave = ?                  ; Non-birth parent leave
adoption_leave = ?                          ; Adoption leave
foster_placement_leave = ?                  ; Foster care leave

{@parental_leave_policy}

; Duration - Birth parent
{.birth_parent}
paid_weeks = ##:(0..26)                     ; Paid weeks
unpaid_weeks = ##:(0..26)                   ; Additional unpaid weeks
pay_percent = #:(0..100)                    ; Percent of pay
pay_cap_weekly = #$:(0..)                   ; Weekly pay cap

{@parental_leave_policy}

; Duration - Non-birth parent
{.non_birth_parent}
paid_weeks = ##:(0..26)                     ; Paid weeks
unpaid_weeks = ##:(0..26)                   ; Additional unpaid weeks
pay_percent = #:(0..100)                    ; Percent of pay
pay_cap_weekly = #$:(0..)                   ; Weekly pay cap

{@parental_leave_policy}

; Duration - Adoption/Foster
{.adoption_foster}
paid_weeks = ##:(0..26)                     ; Paid weeks
unpaid_weeks = ##:(0..26)                   ; Additional unpaid weeks
pay_percent = #:(0..100)                    ; Percent of pay
pay_cap_weekly = #$:(0..)                   ; Weekly pay cap
child_age_limit = ##:(0..18)                ; Child age limit for adoption

{@parental_leave_policy}

; Eligibility
{.eligibility}
service_requirement_months = ##:(0..24)     ; Months of service required
hours_requirement = ##:(0..1250)            ; Hours worked requirement
all_employees_eligible = ?                  ; All employees eligible

{@parental_leave_policy}

; Leave usage
{.usage}
must_be_continuous = ?                      ; Must be taken continuously
intermittent_allowed = ?                    ; Intermittent leave allowed
reduced_schedule_allowed = ?                ; Reduced schedule allowed
use_within_months = ##:(6..12)              ; Use within X months of birth/placement

{@parental_leave_policy}

; Coordination
{.coordination}
concurrent_with_fmla = ?                    ; Runs concurrent with FMLA
concurrent_with_state_leave = ?             ; Runs concurrent with state leave
supplemental_to_state_pay = ?               ; Supplements state paid leave

{@parental_leave_policy}

; Benefits continuation
{.benefits}
health_insurance_continues = ?              ; Health insurance continues
employer_pays_full_premium = ?              ; Employer pays full premium
pto_accrues = ?                             ; PTO accrues during leave

{@parental_leave_policy}

; ═══════════════════════════════════════════════════════════════════════════════
; BEREAVEMENT LEAVE POLICY
; ═══════════════════════════════════════════════════════════════════════════════

{@bereavement_policy}
policy_id = !:                              ; Policy ID
employer_id = !:                            ; Employer

; Immediate family
{.immediate_family}
days = ##:(0..10)                           ; Days for immediate family
paid = ?                                    ; Paid leave
family_members[] = :                        ; Covered relationships
; Typical: spouse, child, parent, sibling, grandparent, grandchild

{@bereavement_policy}

; Extended family
{.extended_family}
days = ##:(0..5)                            ; Days for extended family
paid = ?                                    ; Paid leave
family_members[] = :                        ; Covered relationships
; Typical: in-laws, aunt, uncle, niece, nephew, cousin

{@bereavement_policy}

; Additional situations
{.additional}
travel_time_days = ##:(0..3)                ; Additional days for travel
miscarriage_stillbirth_days = ##:(0..10)    ; Days for pregnancy loss
pet_death_days = ##:(0..3)                  ; Days for pet death (if offered)

{@bereavement_policy}

; Documentation
{.documentation}
documentation_required = ?                  ; Documentation required
acceptable_documentation[] = :              ; Acceptable documentation types

{@bereavement_policy}

; ═══════════════════════════════════════════════════════════════════════════════
; MILITARY LEAVE POLICY
; ═══════════════════════════════════════════════════════════════════════════════
; Per USERRA (38 USC Chapter 43)

{@military_leave_policy}
policy_id = !:                              ; Policy ID
employer_id = !:                            ; Employer

; Basic military leave
{.basic}
annual_paid_days = ##:(0..30)               ; Annual paid military leave days
pay_differential = ?                        ; Pay differential provided
cumulative_service_limit_years = ##:(0..5)  ; Cumulative service limit

{@military_leave_policy}

; Pay during leave
{.pay}
full_pay_days = ##:(0..30)                  ; Days at full pay
differential_pay_days = ##:(0..365)         ; Days at differential pay
differential_calculation = :                ; How differential calculated
unpaid_after_days = ##:(0..365)             ; Unpaid after X days

{@military_leave_policy}

; Benefits continuation - Per USERRA
{.benefits}
health_insurance_continues = ?              ; Health continues during leave
health_continuation_months = ##:(0..24)     ; Months health continues
employee_pays_premium = ?                   ; Employee pays premium
cobra_like_continuation = ?                 ; COBRA-like option available
pto_accrues = ?                             ; PTO accrues during leave
pension_service_credit = ?                  ; Pension service credit

{@military_leave_policy}

; Reemployment rights - Per USERRA
{.reemployment}
reemployment_rights = ?true                 ; USERRA reemployment rights
escalator_position = ?                      ; Escalator position rights
seniority_continues = ?                     ; Seniority continues

{@military_leave_policy}

; Documentation
{.documentation}
advance_notice_required = ?                 ; Advance notice required
orders_required = ?                         ; Military orders required

{@military_leave_policy}

; ═══════════════════════════════════════════════════════════════════════════════
; JURY DUTY LEAVE
; ═══════════════════════════════════════════════════════════════════════════════

{@jury_duty_policy}
policy_id = !:                              ; Policy ID
employer_id = !:                            ; Employer

; Pay
{.pay}
paid = ?                                    ; Paid jury duty leave
full_pay = ?                                ; Full pay during service
differential_pay = ?                        ; Differential pay
pay_offset_by_jury_fees = ?                 ; Offset by jury fees
maximum_paid_days = ##:(0..30)              ; Maximum paid days

{@jury_duty_policy}

; Requirements
{.requirements}
summons_required = ?                        ; Summons required
return_to_work_same_day = ?                 ; Return if dismissed early
advance_notice_days = ##:(0..7)             ; Advance notice required

{@jury_duty_policy}

; ═══════════════════════════════════════════════════════════════════════════════
; VOTING LEAVE
; ═══════════════════════════════════════════════════════════════════════════════

{@voting_leave_policy}
policy_id = !:                              ; Policy ID
employer_id = !:                            ; Employer

; Leave allowed
{.leave}
paid = ?                                    ; Paid voting leave
hours_allowed = #:(1..4)                    ; Hours allowed
beginning_or_end_of_day = ?                 ; Must be at day start/end

{@voting_leave_policy}

; State compliance
compliance_states[] = :(2)                  ; State codes

; ═══════════════════════════════════════════════════════════════════════════════
; LEAVE BALANCE
; ═══════════════════════════════════════════════════════════════════════════════

{@leave_balance}
balance_id = !:                             ; Balance ID
employee_id = !:                            ; Employee
policy_id = !:                              ; Policy ID
leave_type = !(bereavement, floating_holiday, jury_duty, military, parental, personal, pto, sick, vacation)

; Current balance
{.balance}
available_hours = #:(0..)                   ; Available hours
available_days = #:(0..)                    ; Available days
pending_hours = #:(0..)                     ; Pending (not yet approved)
scheduled_hours = #:(0..)                   ; Scheduled (future)

{@leave_balance}

; Year-to-date
{.ytd}
accrued_hours = #:(0..)                     ; YTD accrued
used_hours = #:(0..)                        ; YTD used
forfeited_hours = #:(0..)                   ; YTD forfeited
carryover_hours = #:(0..)                   ; Carryover from prior year

{@leave_balance}

; As of date
as_of_date = date                           ; Balance as of date

; ═══════════════════════════════════════════════════════════════════════════════
; LEAVE REQUEST
; ═══════════════════════════════════════════════════════════════════════════════

{@leave_request}
request_id = !:                             ; Request ID
employee_id = !:                            ; Employee
policy_id = !:                              ; Policy ID
leave_type = !(bereavement, floating_holiday, jury_duty, military, parental, personal, pto, sick, vacation)

; Request details
{.details}
start_date = !date                          ; Start date
end_date = !date                            ; End date
start_time = time                           ; Start time (if partial day)
end_time = time                             ; End time (if partial day)
hours_requested = #:(0..)                   ; Total hours requested
days_requested = #:(0..)                    ; Total days requested

{@leave_request}

; Request type
{.type}
full_day = ?                                ; Full day(s)
partial_day = ?                             ; Partial day(s)
intermittent = ?                            ; Intermittent leave
reduced_schedule = ?                        ; Reduced schedule

{@leave_request}

; Reason
{.reason}
reason_category = :                         ; Reason category
reason_description = :                      ; Detailed reason
fmla_qualifying = ?                         ; FMLA qualifying reason
documentation_required = ?                  ; Documentation required
documentation_received = ?                  ; Documentation received

{@leave_request}

; Approval
{.approval}
submitted_date = date                       ; Date submitted
manager_id = :                              ; Approving manager
approval_date = date                        ; Approval date
status = !(approved, cancelled, denied, pending)
denial_reason = :                           ; Denial reason (if denied)

{@leave_request}

; ═══════════════════════════════════════════════════════════════════════════════
; STATE PAID FAMILY LEAVE
; ═══════════════════════════════════════════════════════════════════════════════
; State-mandated paid family and medical leave programs

{@state_paid_leave}
state = !:(2)                               ; State code
employer_id = !:                            ; Employer
plan_year = !##:(2000..)                    ; Plan year

; Program info
{.program}
program_name = :                            ; State program name
; Examples: CA PFL, NY PFL, WA PFML, MA PFML, etc.
private_plan = ?                            ; Using private plan vs state
state_fund = ?                              ; Using state fund

{@state_paid_leave}

; Carrier (if private plan)
{.carrier}
carrier_name = :                            ; Carrier name
policy_number = :                           ; Policy number

{@state_paid_leave}

; Family leave - Per state requirements
{.family_leave}
weeks_available = ##:(0..20)                ; Weeks available
benefit_percent = #:(50..100)               ; Benefit percentage
weekly_maximum = #$:(0..)                   ; Weekly maximum
qualifying_reasons[] = :                    ; Qualifying reasons
; Examples: bonding, family care, military exigency

{@state_paid_leave}

; Medical leave - Per state requirements
{.medical_leave}
weeks_available = ##:(0..20)                ; Weeks available
benefit_percent = #:(50..100)               ; Benefit percentage
weekly_maximum = #$:(0..)                   ; Weekly maximum
waiting_period_days = ##:(0..7)             ; Waiting period

{@state_paid_leave}

; Contributions - Per state requirements
{.contributions}
employee_contribution_rate = #:(0..2)       ; Employee contribution %
employer_contribution_rate = #:(0..2)       ; Employer contribution %
wage_base = #$:(0..)                        ; Taxable wage base

{@state_paid_leave}

; Coordination with employer policy
{.coordination}
supplemented_by_employer = ?                ; Employer supplements
employer_top_up_percent = #:(0..100)        ; Employer top-up %
concurrent_with_employer_leave = ?          ; Runs concurrent

{@state_paid_leave}

; ═══════════════════════════════════════════════════════════════════════════════
; STATE PAID LEAVE CLAIM
; ═══════════════════════════════════════════════════════════════════════════════

{@state_leave_claim}
claim_id = !:                               ; Claim ID
employee_id = !:                            ; Employee
state = !:(2)                               ; State

; Claim type
{.type}
leave_type = !(family_care, medical, military_exigency, new_child_bonding)
family_member = :                           ; Family member (if family care)
relationship = :                            ; Relationship

{@state_leave_claim}

; Leave period
{.period}
start_date = !date                          ; Start date
end_date = date                             ; End date (or ongoing)
intermittent = ?                            ; Intermittent leave
reduced_schedule = ?                        ; Reduced schedule

{@state_leave_claim}

; Benefit calculation
{.benefit}
weekly_benefit = #$:(0..)                   ; Weekly benefit amount
employer_supplement = #$:(0..)              ; Employer supplement
total_weekly_benefit = #$:(0..)             ; Total weekly

{@state_leave_claim}

; Status
{.status}
status = !(approved, denied, paid, pending)
determination_date = date                   ; Determination date
denial_reason = :                           ; Denial reason

{@state_leave_claim}



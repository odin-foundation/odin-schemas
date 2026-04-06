; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Employee Disability Benefits Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Short-term disability, long-term disability, and statutory disability benefits
; derived from ERISA and state disability requirements.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as benefits

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.benefits.disability"
version = "1.0.0"
title = "Employee Disability Benefits Schema"
description = "Short-term disability, long-term disability, and statutory disability"

{$derivation}
source[0].authority = "GPO"
source[0].citation = "29 USC Chapter 18 - ERISA Welfare Benefit Plans"
source[0].url = "https://www.law.cornell.edu/uscode/text/29/chapter-18"

source[1].authority = "SSA"
source[1].citation = "Social Security Disability Integration"
source[1].url = "https://www.ssa.gov/disability/"

source[2].authority = "DOL"
source[2].citation = "FMLA Regulations - 29 CFR Part 825"
source[2].url = "https://www.ecfr.gov/current/title-29/subtitle-B/chapter-V/subchapter-C/part-825"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial employee disability benefits schema"
changelog[0].rationale = "Structure derived from ERISA and disability benefit requirements"

; ═══════════════════════════════════════════════════════════════════════════════
; SHORT-TERM DISABILITY (STD)
; ═══════════════════════════════════════════════════════════════════════════════

{@std}
plan_id = !:                                ; Plan ID
employer_id = !:                            ; Employer
plan_name = !:                              ; Plan name

; Type
{.type}
plan_type = !(fully_insured, self_funded)
voluntary = ?                               ; Voluntary vs employer-paid

{@std}

; Carrier
{.carrier}
carrier_name = :                            ; Carrier name
policy_number = :                           ; Policy number
group_number = :                            ; Group number
tpa_name = :                                ; TPA (if self-funded)

{@std}

; Elimination period
{.elimination}
accident_elimination_days = ##:(0..14)      ; Days for accident
illness_elimination_days = ##:(0..14)       ; Days for illness
pregnancy_elimination_days = ##:(0..14)     ; Days for pregnancy

{@std}

; Benefit percentage
{.benefit}
benefit_percent = #:(40..100)               ; Percentage of salary
weekly_maximum = #$:(0..)                   ; Weekly maximum
weekly_minimum = #$:(0..)                   ; Weekly minimum
taxable_benefit = ?                         ; Benefit is taxable

{@std}

; Duration
{.duration}
maximum_weeks = ##:(4..52)                  ; Maximum benefit weeks
benefit_period_weeks = ##:(4..52)           ; Benefit period

{@std}

; Pre-existing condition
{.pre_existing}
pre_existing_lookback_months = ##:(0..12)   ; Lookback period
pre_existing_exclusion_months = ##:(0..12)  ; Exclusion period

{@std}

; Integration
{.integration}
integrates_with_std_state = ?               ; Integrates with state STD
integrates_with_pto = ?                     ; Integrates with PTO
integrates_with_sick_leave = ?              ; Integrates with sick leave
offset_type = (direct, supplemental)        ; Offset type

{@std}

; Rates
{.rates}
employer_paid = ?                           ; Employer pays premium
rate_structure = (age_banded, composite, volume_rated)
rate_per_10 = #:(0..5)                      ; Rate per $10 weekly benefit

{@std}

; ═══════════════════════════════════════════════════════════════════════════════
; LONG-TERM DISABILITY (LTD)
; ═══════════════════════════════════════════════════════════════════════════════

{@ltd}
plan_id = !:                                ; Plan ID
employer_id = !:                            ; Employer
plan_name = !:                              ; Plan name

; Type
{.type}
plan_type = !(fully_insured, self_funded)
voluntary = ?                               ; Voluntary vs employer-paid

{@ltd}

; Carrier
{.carrier}
carrier_name = :                            ; Carrier name
policy_number = :                           ; Policy number
group_number = :                            ; Group number

{@ltd}

; Elimination period
{.elimination}
elimination_days = ##:(30..365)             ; Elimination period days
; Common: 90, 180 days

{@ltd}

; Benefit
{.benefit}
benefit_percent = #:(40..70)                ; Percentage of salary
monthly_maximum = #$:(0..)                  ; Monthly maximum
monthly_minimum = #$:(0..)                  ; Monthly minimum
taxable_benefit = ?                         ; Benefit is taxable
earnings_definition = (base_only, base_plus_bonus, w2)

{@ltd}

; Duration
{.duration}
benefit_duration = (age_65, ssnra, to_age_70, two_year, five_year)
; ssnra = Social Security Normal Retirement Age
own_occupation_months = ##:(12..60)         ; Own occupation period
any_occupation_after = ?                    ; Any occupation after own occ

{@ltd}

; Disability definition
{.definition}
own_occupation = ?                          ; Own occupation definition
any_occupation = ?                          ; Any occupation definition
partial_disability = ?                      ; Partial/residual disability
mental_nervous_limitation = ?               ; MN limitation
mental_nervous_months = ##:(12..24)         ; MN limitation months

{@ltd}

; Pre-existing condition
{.pre_existing}
pre_existing_lookback_months = ##:(3..12)   ; Lookback period
pre_existing_exclusion_months = ##:(6..24)  ; Exclusion period

{@ltd}

; Integration/offsets
{.integration}
offsets_social_security = ?                 ; Offsets SSDI
offsets_workers_comp = ?                    ; Offsets workers' comp
offsets_state_disability = ?                ; Offsets state disability
offsets_other_income = ?                    ; Offsets other income
family_social_security = ?                  ; Family SS offset
minimum_benefit = #:(0..100)                ; Minimum benefit after offsets

{@ltd}

; Additional benefits
{.additional}
survivor_benefit = ?                        ; Survivor benefit
survivor_benefit_months = ##:(0..12)        ; Survivor benefit months
rehabilitation = ?                          ; Vocational rehab
rehabilitation_incentive = ?                ; Rehab incentive
cola = ?                                    ; Cost of living adjustment
cola_percent = #:(0..5)                     ; COLA percentage

{@ltd}

; Rates
{.rates}
employer_paid = ?                           ; Employer pays premium
rate_structure = (age_banded, composite, volume_rated)
rate_per_100 = #:(0..5)                     ; Rate per $100 monthly benefit

{@ltd}

; Portability/conversion
{.portability}
portability_available = ?                   ; Portability available
conversion_available = ?                    ; Conversion available

{@ltd}

; ═══════════════════════════════════════════════════════════════════════════════
; STATUTORY DISABILITY
; ═══════════════════════════════════════════════════════════════════════════════
; State-mandated disability (CA, HI, NJ, NY, RI, PR)

{@statutory_disability}
state = !:(2)                               ; State code
employer_id = !:                            ; Employer
plan_year = !##:(2000..)                    ; Plan year

; State program - Per state requirements
{.program}
program_name = :                            ; State program name
; CA SDI, HI TDI, NJ TDI, NY DBL, RI TDI, PR SINOT
private_plan = ?                            ; Using private plan vs state
state_fund = ?                              ; Using state fund

{@statutory_disability}

; Carrier (if private plan)
{.carrier}
carrier_name = :                            ; Carrier name
policy_number = :                           ; Policy number

{@statutory_disability}

; Benefit - Per state requirements
{.benefit}
waiting_period_days = ##:(0..7)             ; Waiting period
benefit_percent = #:(50..70)                ; Benefit percentage
weekly_maximum = #$:(0..)                   ; State weekly maximum
maximum_weeks = ##:(26..52)                 ; Maximum weeks

{@statutory_disability}

; Contributions - Per state requirements
{.contributions}
employee_contribution = ?                   ; Employee contributes
employer_contribution = ?                   ; Employer contributes
contribution_rate = #:(0..5)                ; Contribution rate
wage_base = #$:(0..)                        ; Taxable wage base

{@statutory_disability}

; Paid family leave integration
{.pfl}
pfl_included = ?                            ; State PFL included
pfl_weeks = ##:(0..12)                      ; PFL weeks
pfl_benefit_percent = #:(50..90)            ; PFL benefit percent

{@statutory_disability}

; ═══════════════════════════════════════════════════════════════════════════════
; DISABILITY ENROLLMENT
; ═══════════════════════════════════════════════════════════════════════════════

{@disability_enrollment}
enrollment_id = !:                          ; Enrollment ID
employee_id = !:                            ; Employee
plan_id = !:                                ; Plan ID
coverage_type = !(ltd, std, statutory)

; Coverage
{.coverage}
covered_earnings = #$:(0..)                 ; Covered earnings
weekly_benefit = #$:(0..)                   ; Weekly benefit (STD)
monthly_benefit = #$:(0..)                  ; Monthly benefit (LTD)
effective_date = date                       ; Effective date
termination_date = date                     ; Termination date

{@disability_enrollment}

; Premium
{.premium}
monthly_premium = #$:(0..)                  ; Monthly premium
employee_paid = #$:(0..)                    ; Employee pays
employer_paid = #$:(0..)                    ; Employer pays

{@disability_enrollment}

; Status
status = !(active, declined, terminated)

; ═══════════════════════════════════════════════════════════════════════════════
; DISABILITY CLAIM
; ═══════════════════════════════════════════════════════════════════════════════

{@disability_claim}
claim_id = !:                               ; Claim ID
enrollment_id = !:                          ; Enrollment
employee_id = !:                            ; Employee
claim_type = !(ltd, partial, std)

; Disability dates
{.dates}
disability_date = !date                     ; Date disability began
last_day_worked = date                      ; Last day worked
return_to_work_date = date                  ; Actual/expected RTW
claim_filed_date = date                     ; Claim filed date

{@disability_claim}

; Diagnosis
{.diagnosis}
primary_diagnosis = :                       ; Primary diagnosis
icd10_code = :                              ; ICD-10 code
disability_type = (mental_nervous, physical, pregnancy)
work_related = ?                            ; Work-related injury

{@disability_claim}

; Physician
{.physician}
name = :                                    ; Physician name
npi = :                                     ; Physician NPI
phone = @phone                              ; Phone
specialty = :                               ; Specialty

{@disability_claim}

; Benefit calculation
{.benefit}
pre_disability_earnings = #$:(0..)          ; Pre-disability earnings
gross_benefit = #$:(0..)                    ; Gross benefit
ss_offset = #$:(0..)                        ; Social Security offset
wc_offset = #$:(0..)                        ; Workers' comp offset
other_offsets = #$:(0..)                    ; Other offsets
net_benefit = #$:(0..)                      ; Net benefit payable

{@disability_claim}

; Status
{.status}
status = !(approved, closed, denied, pending)
elimination_period_satisfied = ?            ; Elimination period met
own_occupation_period = ?                   ; In own occupation period
any_occupation_period = ?                   ; In any occupation period

{@disability_claim}

; Payments
{.payments}
total_paid = #$:(0..)                       ; Total paid to date
last_payment_date = date                    ; Last payment date
next_payment_date = date                    ; Next payment date

{@disability_claim}

; Return to work
{.rtw}
rtw_date = date                             ; Return to work date
rtw_type = (full_duty, modified_duty, part_time)
transition_benefit = ?                      ; Receiving transition benefit

{@disability_claim}

; ═══════════════════════════════════════════════════════════════════════════════
; FMLA TRACKING
; ═══════════════════════════════════════════════════════════════════════════════
; Per 29 CFR Part 825

{@fmla_leave}
leave_id = !:                               ; Leave ID
employee_id = !:                            ; Employee
employer_id = !:                            ; Employer

; FMLA eligibility - Per 29 CFR 825.110
{.eligibility}
eligible = ?                                ; FMLA eligible
months_employed = ##:(0..99)                ; Months employed
hours_worked = ##:(0..9999)                 ; Hours in past 12 months
worksite_employees = ##:(0..999)            ; Employees at worksite

{@fmla_leave}

; Leave type - Per 29 CFR 825.112
{.type}
leave_reason = !(care_family, care_newborn, military_caregiver, military_exigency, own_serious_health)
family_member = (child, parent, spouse)     ; If family care
military_member = ?                         ; Military family leave

{@fmla_leave}

; Leave dates
{.dates}
requested_start = date                      ; Requested start date
actual_start = date                         ; Actual start date
expected_end = date                         ; Expected end date
actual_end = date                           ; Actual end date

{@fmla_leave}

; Leave tracking
{.tracking}
leave_type = (block, intermittent, reduced_schedule)
total_entitlement_hours = ##:(0..480)       ; Total entitlement (12 weeks = 480 hrs)
used_hours = ##:(0..)                       ; Hours used
remaining_hours = ##:(0..)                  ; Hours remaining
leave_year_method = (calendar, fixed, rolling_backward, rolling_forward)

{@fmla_leave}

; Certification
{.certification}
certification_required = ?                  ; Certification required
certification_received = ?                  ; Certification received
certification_date = date                   ; Certification date
recertification_due = date                  ; Recertification due date

{@fmla_leave}

; Status
{.status}
status = !(approved, completed, denied, pending)
denial_reason = :                           ; Denial reason

{@fmla_leave}

; Coordination with disability
{.coordination}
concurrent_with_std = ?                     ; Concurrent with STD
concurrent_with_ltd = ?                     ; Concurrent with LTD
concurrent_with_workers_comp = ?            ; Concurrent with WC
concurrent_with_state_leave = ?             ; Concurrent with state leave

{@fmla_leave}


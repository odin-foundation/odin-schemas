; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Medicare Common Types
; ═══════════════════════════════════════════════════════════════════════════════
; Reusable type definitions shared across Medicare schemas including beneficiary,
; entitlement basis, enrollment period, and premium types. Derived from CMS
; public manuals and 42 CFR regulations.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.medicare.types"
version = "1.0.0"
title = "Medicare Common Types"
description = "Reusable type definitions for Medicare schemas"

{$derivation}
source[0].authority = "CMS"
source[0].citation = "Medicare General Information, Eligibility, and Entitlement Manual (CMS Pub 100-01)"
source[0].url = "https://www.cms.gov/regulations-and-guidance/guidance/manuals/internet-only-manuals-ioms"

source[1].authority = "CMS"
source[1].citation = "Medicare & You 2025 Handbook"
source[1].url = "https://www.medicare.gov/publications/10050-Medicare-and-You.pdf"

source[2].authority = "GPO"
source[2].citation = "42 CFR Part 405 - Federal Health Insurance for the Aged and Disabled"
source[2].url = "https://www.ecfr.gov/current/title-42/chapter-IV/subchapter-B/part-405"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial Medicare common types schema"
changelog[0].rationale = "Base types derived from CMS public manuals and 42 CFR"

; ═══════════════════════════════════════════════════════════════════════════════
; MEDICARE BENEFICIARY
; ═══════════════════════════════════════════════════════════════════════════════
; Per CMS Pub 100-01 Chapter 2 - Beneficiary Identification

{@beneficiary}
= @person                                    ; Inherits person fields (name, ssn, dob, contact)

; Identification - Per 42 CFR 405.803
mbi = *:/^[1-9AC-HJKMNP-RT-Y][AC-HJKMNP-RT-Y0-9][0-9][AC-HJKMNP-RT-Y][AC-HJKMNP-RT-Y0-9][0-9][AC-HJKMNP-RT-Y][AC-HJKMNP-RT-Y0-9][0-9][AC-HJKMNP-RT-Y][AC-HJKMNP-RT-Y0-9]$/  ; Medicare Beneficiary Identifier
hicn = *:                                    ; Legacy Health Insurance Claim Number (deprecated)

; Override required name fields - Per CMS-40B application
{.name}
first = :                                   ; First name (required)
last = :                                    ; Last name (required)

{@beneficiary}

; Override required demographics
date_of_birth = *date                       ; Date of birth (required)
gender = (female, male)                     ; Sex per SSA records (required)

; Medicare-specific demographics
date_of_death = *date                        ; Date of death if deceased

; ═══════════════════════════════════════════════════════════════════════════════
; ENTITLEMENT BASIS
; ═══════════════════════════════════════════════════════════════════════════════
; Per CMS Pub 100-01 Chapter 2 - Entitlement and Enrollment

{@entitlement_basis}
basis = (age, disability, esrd, esrd_age, esrd_disability)

; Age-based (65+) - Per 42 CFR 406.10
age_65_date = date                           ; Date reached age 65

; Disability-based - Per 42 CFR 406.12
{.disability}
ssdi_entitlement_date = date                 ; SSDI entitlement start
ssdi_waiting_months = ##:(0..24)             ; 24-month waiting period
disability_onset_date = date                 ; Date disability began
rrb_disability = ?                           ; Railroad Retirement Board disability

{@entitlement_basis}

; ESRD-based - Per 42 CFR 406.13
{.esrd}
dialysis_start_date = date                   ; Date dialysis began
transplant_date = date                       ; Date of kidney transplant
esrd_waiting_months = ##:(0..3)              ; 3-month waiting period
self_dialysis_trained = ?                    ; Home dialysis training
transplant_candidate = ?                     ; On transplant waiting list

{@entitlement_basis}

; ALS (automatic entitlement) - Per 42 CFR 406.12(c)
als_diagnosis_date = date                    ; Date of ALS diagnosis

; ═══════════════════════════════════════════════════════════════════════════════
; PREMIUM INFORMATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per CMS Pub 100-01 Chapter 2 and Medicare & You handbook

{@medicare_premium}
part = (a, b, c, d)                         ; Medicare part
year = ##:(2000..2100)                      ; Calendar year

; Standard premium - Per annual CMS announcement
standard_premium = #$:(0..)                  ; Standard monthly premium
actual_premium = #$:(0..)                    ; Beneficiary's actual premium

; Premium-free status (Part A) - Per 42 CFR 406.20
premium_free = ?                             ; Qualified for premium-free
premium_free_reason = (covered_quarters, government_employment, spouse_quarters):if premium_free = true

; Late enrollment penalty - Per 42 CFR 406.32, 407.32, 423.46
{.penalty}
applies = ?                                  ; Late enrollment penalty applies
penalty_percent = #:(0..100):if applies = true  ; Penalty percentage
penalty_months = ##:(0..)                    ; Months used in penalty calculation

{@medicare_premium}

; IRMAA surcharge - Per 42 CFR 407.20
{.irmaa}
applies = ?                                  ; Income-related adjustment applies
bracket = ##:(1..5):if applies = true        ; IRMAA bracket (1-5)
surcharge = #$:(0..):if applies = true       ; Monthly surcharge amount
magi_year = ##:(2000..2100):if applies = true  ; Tax year used for MAGI

{@medicare_premium}

; Payment
{.payment}
method = (direct_bill, employer_group, rrb_deduction, ssa_deduction, state_buy_in)
deducted_from = (civil_service, rrb, ssa):if method = ssa_deduction
account_reference = :                        ; Payment account reference

{@medicare_premium}

; ═══════════════════════════════════════════════════════════════════════════════
; ENROLLMENT PERIOD TYPES
; ═══════════════════════════════════════════════════════════════════════════════
; Per Medicare & You handbook and 42 CFR 406, 407, 422, 423

{@enrollment_period}
type = (aep, general, icep, iep, oep, sep)  ; Period type
start_date = date                           ; Period start
end_date = date                             ; Period end
applicable_parts[] = :(a, b, c, d)           ; Parts available for enrollment

; Period type explanations:
; iep = Initial Enrollment Period (7 months around 65th birthday)
; general = General Enrollment Period (Jan-Mar annually for Part B)
; sep = Special Enrollment Period (qualifying event)
; aep = Annual Election Period (Oct 15 - Dec 7 for MA/Part D)
; oep = Open Enrollment Period (Jan 1 - Mar 31 for MA)
; icep = Initial Coverage Election Period (MA initial enrollment)

; SEP qualification - Per 42 CFR 406.24, 422.62, 423.38
sep_reason = (chronic_condition, contract_violation, dual_eligible, employer_coverage, five_star_plan, incarceration_release, lawful_presence, medicaid_gain_loss, move, natural_disaster, other, snp_eligible):if type = sep
sep_documentation = :                        ; Supporting documentation reference

; ═══════════════════════════════════════════════════════════════════════════════
; COVERAGE PERIOD
; ═══════════════════════════════════════════════════════════════════════════════
; Per CMS Pub 100-01 Chapter 2

{@coverage_period}
part = (a, b, c, d)                         ; Medicare part
effective_date = date                       ; Coverage start date
termination_date = date                      ; Coverage end date (if terminated)
status = (active, disenrolled, pending, terminated)

; Termination reason - Per 42 CFR 406.28, 407.60
termination_reason = (beneficiary_request, death, employer_coverage, incarceration, loss_of_entitlement, loss_of_lawful_presence, ma_enrollment, nonpayment, other, part_d_enrollment):if status = terminated

; ═══════════════════════════════════════════════════════════════════════════════
; MEDICARE CARD
; ═══════════════════════════════════════════════════════════════════════════════
; Per CMS Medicare Card information

{@medicare_card}
mbi = *:                                    ; Medicare Beneficiary Identifier
{.name}
first = :                                    ; First name as printed
last = :                                     ; Last name as printed
middle_initial = :                           ; Middle initial

{@medicare_card}

{.entitlement}
part_a = ?                                   ; Hospital (Part A) coverage
part_a_effective = date:if part_a = true     ; Part A effective date
part_b = ?                                   ; Medical (Part B) coverage
part_b_effective = date:if part_b = true     ; Part B effective date

{@medicare_card}

issue_date = date                            ; Card issue date
replacement = ?                              ; Is replacement card

; ═══════════════════════════════════════════════════════════════════════════════
; EMPLOYER GROUP HEALTH PLAN
; ═══════════════════════════════════════════════════════════════════════════════
; Per CMS Pub 100-01 Chapter 2 - Coordination of Benefits

{@employer_group}
group_health_plan = ?                        ; Has employer group health plan
employer_name = :                            ; Employer name
employer_size = (large, small)               ; Large (20+) or small (<20) employer
plan_name = :                                ; Plan name
group_number = :                             ; Group number
member_id = :                                ; Member ID

; MSP status - Per 42 CFR 411 (Medicare Secondary Payer)
{.msp}
msp_applies = ?                              ; Medicare Secondary Payer applies
msp_type = (disability_large_group, esrd_coordination, working_aged):if msp_applies = true
coordination_period_end = date               ; End of MSP coordination period

{@employer_group}

; ═══════════════════════════════════════════════════════════════════════════════
; EXTRA HELP / LOW INCOME SUBSIDY
; ═══════════════════════════════════════════════════════════════════════════════
; Per CMS Pub 100-18 Chapter 13 - Low Income Subsidy

{@low_income_subsidy}
eligible = ?                                ; LIS eligible
level = (deemed_full, full, partial_1, partial_2, partial_3):if eligible = true

; Deemed status - Per 42 CFR 423.773
deemed = ?                                   ; Auto-enrolled (deemed eligible)
deemed_reason = (medicaid, msp, ssi):if deemed = true

; Income/resources - Per 42 CFR 423.773
{.qualification}
income_percent_fpl = #:(0..200)              ; Income as percent of FPL
resource_level = (high, low)                 ; Resource level
application_date = date                      ; Application date
redetermination_date = date                  ; Next redetermination

{@low_income_subsidy}

; Subsidy amounts - Per annual CMS announcement
{.subsidy}
premium_subsidy_percent = #:(0..100)         ; Premium subsidy percentage
deductible_reduction = #$:(0..)              ; Deductible reduction amount
copay_generic = #$:(0..)                     ; Generic drug copay
copay_brand = #$:(0..)                       ; Brand drug copay
copay_catastrophic = #$:(0..)                ; Catastrophic copay

{@low_income_subsidy}

; ═══════════════════════════════════════════════════════════════════════════════
; COORDINATION OF BENEFITS
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 411 - Medicare Secondary Payer

{@cob_record}
payer_type = (auto_liability, employer_group, federal_black_lung, no_fault, other_liability, tricare, va, workers_comp)
payer_name = :                               ; Payer name
payer_id = :                                 ; Payer identifier
group_number = :                             ; Group/policy number

; Payer sequence
medicare_primary = ?                         ; Medicare is primary payer
coordination_period_start = date             ; COB period start
coordination_period_end = date               ; COB period end

; MSP recovery - Per 42 CFR 411.24
recovery_applicable = ?                      ; CMS may recover from this payer

; ═══════════════════════════════════════════════════════════════════════════════
; NOTICE TYPES
; ═══════════════════════════════════════════════════════════════════════════════
; Per CMS required notices

{@medicare_notice}
notice_type = (abm, anoc, eob, msp_questionnaire, non_coverage, snf_notice)
notice_date = date                          ; Date notice issued
reference_number = :                         ; Notice reference number

; Notice type explanations:
; abm = Advance Beneficiary Notice of Noncoverage
; anoc = Annual Notice of Change (MA/Part D plans)
; eob = Medicare Summary Notice / Explanation of Benefits
; snf_notice = Skilled Nursing Facility advance notice
; msp_questionnaire = MSP determination questionnaire


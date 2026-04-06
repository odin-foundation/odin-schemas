; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Employee Life Insurance Benefits Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Basic life, supplemental life, dependent life, and AD&D benefit structures
; derived from IRC Section 79 and ERISA requirements.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as benefits

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.benefits.life"
version = "1.0.0"
title = "Employee Life Insurance Benefits Schema"
description = "Basic life, supplemental life, dependent life, and AD&D benefits"

{$derivation}
source[0].authority = "IRS"
source[0].citation = "IRC Section 79 - Group Term Life Insurance"
source[0].url = "https://www.law.cornell.edu/uscode/text/26/79"

source[1].authority = "GPO"
source[1].citation = "29 USC Chapter 18 - ERISA Welfare Benefit Plans"
source[1].url = "https://www.law.cornell.edu/uscode/text/29/chapter-18"

source[2].authority = "IRS"
source[2].citation = "Publication 15-B - Employer's Tax Guide to Fringe Benefits"
source[2].url = "https://www.irs.gov/publications/p15b"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial employee life insurance benefits schema"
changelog[0].rationale = "Structure derived from IRC Section 79 and ERISA"

; ═══════════════════════════════════════════════════════════════════════════════
; BASIC LIFE INSURANCE
; ═══════════════════════════════════════════════════════════════════════════════
; Employer-paid group term life - Per IRC Section 79

{@basic_life}
plan_id = !:                                ; Plan ID
employer_id = !:                            ; Employer
plan_name = !:                              ; Plan name

; Carrier
{.carrier}
carrier_name = :                            ; Carrier name
policy_number = :                           ; Policy number
group_number = :                            ; Group number

{@basic_life}

; Benefit amount
{.benefit}
benefit_type = !(flat_amount, multiple_of_salary)
flat_amount = #$:(0..):if benefit_type = flat_amount
salary_multiple = #:(0..10):if benefit_type = multiple_of_salary
benefit_maximum = #$:(0..)                  ; Maximum benefit
benefit_minimum = #$:(0..)                  ; Minimum benefit
benefit_rounded_to = #$:(0..)               ; Rounded to nearest

{@basic_life}

; Age reduction - Per typical schedules
{.age_reduction}
age_reduction_applies = ?                   ; Age reduction schedule
reduction_age_65 = #:(0..100)               ; % reduction at 65
reduction_age_70 = #:(0..100)               ; % reduction at 70
reduction_age_75 = #:(0..100)               ; % reduction at 75

{@basic_life}

; IRC Section 79 - Per tax rules
{.section_79}
employer_paid = ?true                       ; Employer paid
section_79_applies = ?true                  ; Section 79 taxation
first_50k_tax_free = ?true                  ; First $50K tax-free
imputed_income_over_50k = ?                 ; Imputed income over $50K

{@basic_life}

; Conversion/portability
{.conversion}
conversion_available = ?                    ; Conversion to individual policy
conversion_days = ##:(31..)                 ; Days to convert
portability_available = ?                   ; Portability option
portability_maximum = #$:(0..)              ; Portability maximum

{@basic_life}

; Accelerated benefits
{.accelerated}
accelerated_benefit = ?                     ; Accelerated death benefit
accelerated_percent = #:(0..100)            ; Percent available
terminal_illness_months = ##:(6..24)        ; Terminal illness definition

{@basic_life}

; ═══════════════════════════════════════════════════════════════════════════════
; SUPPLEMENTAL LIFE INSURANCE
; ═══════════════════════════════════════════════════════════════════════════════
; Employee-paid voluntary life

{@supplemental_life}
plan_id = !:                                ; Plan ID
employer_id = !:                            ; Employer
plan_name = !:                              ; Plan name

; Carrier
{.carrier}
carrier_name = :                            ; Carrier name
policy_number = :                           ; Policy number
group_number = :                            ; Group number

{@supplemental_life}

; Benefit structure
{.benefit}
increment_amount = #$:(0..)                 ; Increment amount
maximum_benefit = #$:(0..)                  ; Maximum benefit
multiple_of_salary_max = #:(0..10)          ; Maximum multiple of salary
gi_amount = #$:(0..)                        ; Guaranteed issue amount

{@supplemental_life}

; Guaranteed issue - Per underwriting rules
{.guaranteed_issue}
gi_for_new_hires = #$:(0..)                 ; GI for new hires
gi_for_open_enrollment = #$:(0..)           ; GI during OE
gi_for_qle = #$:(0..)                       ; GI for QLE
gi_election_period_days = ##:(0..60)        ; Days to elect GI

{@supplemental_life}

; Evidence of insurability
{.eoi}
eoi_required_over_gi = ?true                ; EOI for amounts over GI
eoi_form_required = ?                       ; Form required
eoi_medical_exam = ?                        ; Medical exam may be required
eoi_approval_period_days = ##:(0..90)       ; Approval timeframe

{@supplemental_life}

; Age reduction
{.age_reduction}
age_reduction_applies = ?                   ; Age reduction schedule
reduction_age_65 = #:(0..100)               ; % reduction at 65
reduction_age_70 = #:(0..100)               ; % reduction at 70

{@supplemental_life}

; Rates - Per age bands
{.rates}
rate_structure = (age_banded, composite, smoker_non_smoker)
rate_per_1000 = #:(0..10)                   ; Rate per $1,000

{@supplemental_life}

; Portability/conversion
{.portability}
portability_available = ?                   ; Portability available
portability_maximum = #$:(0..)              ; Maximum portable
conversion_available = ?                    ; Conversion available
conversion_days = ##:(31..)                 ; Days to convert

{@supplemental_life}

; ═══════════════════════════════════════════════════════════════════════════════
; DEPENDENT LIFE INSURANCE
; ═══════════════════════════════════════════════════════════════════════════════
; Life insurance on spouse and children

{@dependent_life}
plan_id = !:                                ; Plan ID
employer_id = !:                            ; Employer
plan_name = !:                              ; Plan name

; Carrier
{.carrier}
carrier_name = :                            ; Carrier name
policy_number = :                           ; Policy number

{@dependent_life}

; Spouse coverage
{.spouse}
spouse_coverage_available = ?               ; Spouse coverage available
spouse_increments = #$:(0..)                ; Spouse increment amount
spouse_maximum = #$:(0..)                   ; Spouse maximum
spouse_gi_amount = #$:(0..)                 ; Spouse GI amount
spouse_eoi_over_gi = ?                      ; EOI required over GI

{@dependent_life}

; Child coverage
{.child}
child_coverage_available = ?                ; Child coverage available
child_amount = #$:(0..)                     ; Child coverage amount
child_flat_rate = ?                         ; Flat rate for all children
child_age_minimum_days = ##:(0..365)        ; Minimum age (days)
child_age_maximum = ##:(19..26)             ; Maximum age
student_age_extension = ##:(0..26)          ; Age extension for students
disabled_child_no_age_limit = ?             ; No age limit for disabled

{@dependent_life}

; Combined rates
{.rates}
spouse_rate_per_1000 = #:(0..10)            ; Spouse rate per $1,000
child_rate_flat = #$:(0..)                  ; Child flat rate (all children)

{@dependent_life}

; ═══════════════════════════════════════════════════════════════════════════════
; ACCIDENTAL DEATH & DISMEMBERMENT (AD&D)
; ═══════════════════════════════════════════════════════════════════════════════

{@add}
plan_id = !:                                ; Plan ID
employer_id = !:                            ; Employer
plan_name = !:                              ; Plan name

; Carrier
{.carrier}
carrier_name = :                            ; Carrier name
policy_number = :                           ; Policy number

{@add}

; AD&D type
{.type}
add_type = !(basic, supplemental, voluntary)
bundled_with_life = ?                       ; Bundled with life insurance
standalone = ?                              ; Standalone AD&D

{@add}

; Principal sum
{.principal_sum}
principal_sum = #$:(0..)                    ; Principal sum
equals_life_benefit = ?                     ; Equals life insurance benefit
multiple_of_salary = #:(0..10)              ; Multiple of salary
maximum = #$:(0..)                          ; Maximum principal sum

{@add}

; Schedule of benefits - Per typical schedules
{.schedule}
loss_of_life = #:(100..100)                 ; % for death
loss_two_limbs = #:(100..100)               ; Loss of 2 hands/feet
loss_sight_both_eyes = #:(100..100)         ; Loss of sight both eyes
loss_one_limb_one_eye = #:(100..100)        ; One limb + one eye
loss_one_limb = #:(50..50)                  ; Loss of one hand/foot
loss_sight_one_eye = #:(50..50)             ; Loss of sight one eye
loss_thumb_index = #:(25..25)               ; Thumb and index finger
loss_speech = #:(50..100)                   ; Loss of speech
loss_hearing_both = #:(50..100)             ; Loss of hearing both ears
quadriplegia = #:(100..200)                 ; Quadriplegia
paraplegia = #:(75..100)                    ; Paraplegia
hemiplegia = #:(50..75)                     ; Hemiplegia

{@add}

; Additional benefits
{.additional}
seatbelt_benefit = ?                        ; Seatbelt benefit
airbag_benefit = ?                          ; Airbag benefit
common_carrier = ?                          ; Common carrier benefit
education_benefit = ?                       ; Education benefit
child_care_benefit = ?                      ; Child care benefit
repatriation = ?                            ; Repatriation benefit
rehabilitation = ?                          ; Rehabilitation benefit

{@add}

; Dependent AD&D
{.dependent}
spouse_ad_d = ?                             ; Spouse AD&D available
spouse_percent = #:(0..100)                 ; Spouse % of principal sum
child_ad_d = ?                              ; Child AD&D available
child_percent = #:(0..100)                  ; Child % of principal sum

{@add}

; ═══════════════════════════════════════════════════════════════════════════════
; LIFE ENROLLMENT
; ═══════════════════════════════════════════════════════════════════════════════

{@life_enrollment}
enrollment_id = !:                          ; Enrollment ID
employee_id = !:                            ; Employee
plan_id = !:                                ; Plan ID

; Coverage elected
{.coverage}
coverage_type = !(basic, supplemental, dependent)
benefit_amount = #$:(0..)                   ; Elected benefit amount
effective_date = date                       ; Coverage effective date
termination_date = date                     ; Termination date

{@life_enrollment}

; EOI status
{.eoi}
eoi_required = ?                            ; EOI required
eoi_submitted = ?                           ; EOI submitted
eoi_submitted_date = date                   ; EOI submission date
eoi_status = (approved, declined, pending)  ; EOI status
eoi_approved_amount = #$:(0..):if eoi_status = approved

{@life_enrollment}

; Premium
{.premium}
monthly_premium = #$:(0..)                  ; Monthly premium
employee_paid = #$:(0..)                    ; Employee portion
employer_paid = #$:(0..)                    ; Employer portion
imputed_income = #$:(0..)                   ; Imputed income (Section 79)

{@life_enrollment}

; Beneficiaries
beneficiaries[] = @benefits.beneficiary     ; Designated beneficiaries

; Status
status = !(active, declined, pending_eoi, terminated)

; ═══════════════════════════════════════════════════════════════════════════════
; LIFE CLAIM
; ═══════════════════════════════════════════════════════════════════════════════

{@life_claim}
claim_id = !:                               ; Claim ID
enrollment_id = !:                          ; Enrollment
employee_id = !:                            ; Employee
claim_type = !(accelerated, death, dismemberment)

; Claimant
{.claimant}
claimant_name = :                           ; Claimant name
relationship = :                            ; Relationship to deceased
beneficiary_id = :                          ; Beneficiary ID

{@life_claim}

; Deceased/injured information
{.insured}
date_of_death = date                        ; Date of death
date_of_accident = date                     ; Date of accident (AD&D)
cause_of_death = :                          ; Cause of death
manner_of_death = (accident, homicide, natural, suicide, undetermined)
accidental = ?                              ; Accidental death

{@life_claim}

; Benefit calculation
{.benefit}
base_benefit = #$:(0..)                     ; Base benefit amount
ad_d_benefit = #$:(0..)                     ; AD&D benefit
additional_benefits = #$:(0..)              ; Additional benefits
total_benefit = #$:(0..)                    ; Total benefit payable

{@life_claim}

; Documentation
{.documentation}
death_certificate_received = ?              ; Death certificate
proof_of_relationship = ?                   ; Proof of relationship
beneficiary_statement = ?                   ; Beneficiary statement
autopsy_report = ?                          ; Autopsy report if applicable

{@life_claim}

; Status
{.status}
status = !(approved, denied, paid, pending)
filed_date = date                           ; Date filed
decision_date = date                        ; Decision date
payment_date = date                         ; Payment date
denial_reason = :                           ; Denial reason if applicable

{@life_claim}


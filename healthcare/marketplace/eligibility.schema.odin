; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Health Insurance Marketplace Eligibility Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Marketplace eligibility determination for QHP enrollment, advance premium
; tax credits (APTC), and cost-sharing reductions (CSR). Derived from
; 45 CFR Part 155 Subpart D and IRC 36B.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as marketplace

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.marketplace.eligibility"
version = "1.0.0"
title = "Health Insurance Marketplace Eligibility Schema"
description = "Marketplace eligibility determination for QHP, APTC, and CSR"

{$derivation}
source[0].authority = "GPO"
source[0].citation = "45 CFR 155.305 - Eligibility standards"
source[0].url = "https://www.ecfr.gov/current/title-45/subtitle-A/subchapter-B/part-155/subpart-D/section-155.305"

source[1].authority = "GPO"
source[1].citation = "45 CFR 155.310 - Eligibility process"
source[1].url = "https://www.ecfr.gov/current/title-45/subtitle-A/subchapter-B/part-155/subpart-D/section-155.310"

source[2].authority = "IRS"
source[2].citation = "IRC 36B - Premium Tax Credit"
source[2].url = "https://www.law.cornell.edu/uscode/text/26/36B"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial Marketplace eligibility schema"
changelog[0].rationale = "Structure derived from 45 CFR 155.305-310 and IRC 36B"

; ═══════════════════════════════════════════════════════════════════════════════
; ELIGIBILITY DETERMINATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.305

{@determination}
determination_id = !:                       ; Determination ID
application_id = !:                         ; Application ID
applicant_id = !:                           ; Applicant ID
determination_date = !date                  ; Date of determination

; QHP eligibility - Per 45 CFR 155.305(a)
{.qhp}
eligible = ?                                ; Eligible for QHP
ineligibility_reason = :                    ; Reason if ineligible
; citizenship, incarcerated, not_resident, other_coverage

{@determination}

; Medicaid/CHIP assessment - Per 45 CFR 155.305(c)
{.medicaid_chip}
assessed = ?                                ; Assessed for Medicaid/CHIP
potentially_eligible = ?                    ; Potentially eligible
referred_to_medicaid = ?                    ; Referred to Medicaid agency
referral_date = date                        ; Referral date
medicaid_magi_fpl = #:(0..)                 ; Income as % FPL for Medicaid
chip_fpl = #:(0..)                          ; Income as % FPL for CHIP

{@determination}

; APTC eligibility - Per 45 CFR 155.305(f)
aptc_eligibility = @aptc_determination      ; APTC determination

; CSR eligibility - Per 45 CFR 155.305(g)
csr_eligibility = @csr_determination        ; CSR determination

; Effective dates
{.effective}
effective_date = date                       ; Eligibility effective date
end_date = date                             ; Eligibility end date
redetermination_date = date                 ; Next redetermination

{@determination}

; ═══════════════════════════════════════════════════════════════════════════════
; QHP ELIGIBILITY
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.305(a)

{@qhp_eligibility}
applicant_id = !:                           ; Applicant

; Requirements - Per 45 CFR 155.305(a)
{.requirements}
citizen_or_lawfully_present = ?             ; Citizenship/immigration
state_resident = ?                          ; State residency
not_incarcerated = ?                        ; Not incarcerated
not_enrolled_medicare = ?                   ; Not enrolled in Medicare

{@qhp_eligibility}

; Verification results
{.verification}
citizenship_verified = ?                    ; Citizenship verified
immigration_verified = ?                    ; Immigration status verified
residency_verified = ?                      ; Residency verified
incarceration_verified = ?                  ; Incarceration status verified
all_verified = ?                            ; All requirements verified

{@qhp_eligibility}

; Result
eligible = ?                                ; Eligible for QHP
ineligibility_reasons[] = :                 ; Reasons if ineligible

; ═══════════════════════════════════════════════════════════════════════════════
; APTC DETERMINATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.305(f) and IRC 36B

{@aptc_determination}
household_id = !:                           ; Tax household
tax_year = !##:(2014..)                     ; Coverage/tax year

; Eligibility criteria - Per 45 CFR 155.305(f)
{.criteria}
qhp_eligible = ?                            ; Eligible for QHP
enrolled_in_qhp = ?                         ; Will enroll in QHP
not_eligible_other_coverage = ?             ; Not eligible for other MEC
income_in_range = ?                         ; Income 100-400% FPL
files_taxes = ?                             ; Required to file/will file
not_claimed_dependent = ?                   ; Not claimed as dependent

{@aptc_determination}

; MEC check - Per 45 CFR 155.305(f)(1)(ii)
{.mec}
eligible_for_mec = ?                        ; Eligible for other MEC
mec_type = :                                ; Type of MEC
employer_coverage_affordable = ?            ; Employer coverage affordable
employer_coverage_mv = ?                    ; Employer coverage minimum value

{@aptc_determination}

; Income - Per 45 CFR 155.305(f)(1)
{.income}
household_magi = #$                         ; Household MAGI
household_size = ##:(1..)                   ; Household size
fpl_amount = #$:(0..)                       ; FPL for household size
fpl_percent = #:(0..)                       ; Income as % FPL

{@aptc_determination}

; Result
{.result}
eligible = ?                                ; APTC eligible
monthly_aptc = #$:(0..)                     ; Maximum monthly APTC
annual_aptc = #$:(0..)                      ; Maximum annual APTC
ineligibility_reason = :                    ; Reason if ineligible

{@aptc_determination}

; Applicable percentage - Per IRC 36B(b)(3)(A)
{.applicable_percent}
applicable_percentage = #:(0..9.12)         ; Applicable percentage
expected_contribution = #$:(0..)            ; Expected annual contribution
second_lowest_silver = #$:(0..)             ; SLCSP benchmark premium

{@aptc_determination}

; ═══════════════════════════════════════════════════════════════════════════════
; CSR DETERMINATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.305(g) and 156.420

{@csr_determination}
applicant_id = !:                           ; Applicant
household_id = !:                           ; Household

; Eligibility - Per 45 CFR 155.305(g)
{.eligibility}
aptc_eligible = ?                           ; Must be APTC eligible
enrolled_silver_plan = ?                    ; Must enroll in silver plan
income_under_250_fpl = ?                    ; Income under 250% FPL

{@csr_determination}

; Income level
{.income}
household_fpl_percent = #:(0..)             ; Household income % FPL

{@csr_determination}

; CSR level - Per 45 CFR 156.420
{.level}
eligible = ?                                ; CSR eligible
csr_variant = ##:(73..94)                   ; CSR plan variant (73, 87, 94)
; 100-150% FPL = 94% AV
; 150-200% FPL = 87% AV
; 200-250% FPL = 73% AV

{@csr_determination}

; Native American CSR - Per 45 CFR 155.305(g)(2)
{.native_american}
native_american_csr = ?                     ; Native American CSR eligible
tribal_member = ?                           ; AI/AN tribal member
below_300_fpl = ?                           ; Below 300% FPL
zero_cost_sharing = ?                       ; Zero cost sharing plan

{@csr_determination}

; ═══════════════════════════════════════════════════════════════════════════════
; EMPLOYER COVERAGE AFFORDABILITY
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.305(f)(1)(ii)(B)

{@employer_affordability}
applicant_id = !:                           ; Applicant
determination_year = !##:(2014..)           ; Year

; Employer coverage
{.coverage}
employer_name = :                           ; Employer name
employee_premium = #$:(0..)                 ; Employee-only monthly premium
coverage_month = :                          ; Month for analysis

{@employer_affordability}

; Income
{.income}
household_income = #$:(0..)                 ; Household income
affordability_threshold = #:(0..10)         ; Affordability threshold %

{@employer_affordability}

; Calculation - Per 45 CFR 155.305(f)(1)(ii)(B)
{.calculation}
premium_as_percent = #:(0..100)             ; Premium as % of income
affordability_threshold = #:(0..10)         ; Threshold (9.12% for 2024)
affordable = ?                              ; Coverage affordable

{@employer_affordability}

; Minimum value - Per 45 CFR 156.145
{.minimum_value}
meets_minimum_value = ?                     ; Meets 60% AV
mv_calculator_used = ?                      ; MV calculator used
employer_attestation = ?                    ; Employer attested to MV

{@employer_affordability}

; Result
employer_coverage_bars_aptc = ?             ; Employer coverage bars APTC

; ═══════════════════════════════════════════════════════════════════════════════
; VERIFICATION STATUS
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.315

{@verification_status}
application_id = !:                         ; Application ID
verification_date = !date                   ; Status date

; Verification items
verifications[] = @marketplace.verification ; All verification items

; Summary
{.summary}
all_verified = ?                            ; All items verified
pending_count = ##:(0..)                    ; Pending verification count
inconsistency_count = ##:(0..)              ; Inconsistencies found
documents_pending = ?                       ; Documents pending

{@verification_status}

; Inconsistency period - Per 45 CFR 155.315(f)
{.inconsistency}
in_inconsistency_period = ?                 ; In inconsistency resolution period
period_start = date                         ; Period start
period_end = date                           ; Period end (90 days)
extension_granted = ?                       ; Extension granted

{@verification_status}

; Data matching - Per 45 CFR 155.320
{.data_matching}
income_verified_electronically = ?          ; Income verified via hub
citizenship_verified_electronically = ?     ; Citizenship verified
immigration_verified_electronically = ?     ; Immigration verified via SAVE
incarceration_verified = ?                  ; Incarceration verified

{@verification_status}

; ═══════════════════════════════════════════════════════════════════════════════
; REDETERMINATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.330 and 155.335

{@redetermination}
redetermination_id = !:                     ; Redetermination ID
original_determination_id = !:              ; Prior determination
applicant_id = !:                           ; Applicant
redetermination_date = !date                ; Date

; Trigger - Per 45 CFR 155.330
trigger = !(annual_renewal, change_report, new_information, periodic)

; Change analysis
{.changes}
change_type = :                             ; Type of change
prior_value = :                             ; Prior value
new_value = :                               ; New value

{@redetermination}

; Prior eligibility
{.prior}
prior_qhp_eligible = ?                      ; Prior QHP eligible
prior_aptc_eligible = ?                     ; Prior APTC eligible
prior_aptc_amount = #$:(0..)                ; Prior APTC amount
prior_csr_level = ##:(0..94)                ; Prior CSR level

{@redetermination}

; New eligibility
{.new}
new_qhp_eligible = ?                        ; New QHP eligible
new_aptc_eligible = ?                       ; New APTC eligible
new_aptc_amount = #$:(0..)                  ; New APTC amount
new_csr_level = ##:(0..94)                  ; New CSR level

{@redetermination}

; Effective dates
{.effective}
change_effective = date                     ; When change takes effect
prospective = ?                             ; Prospective (future) change

{@redetermination}

; ═══════════════════════════════════════════════════════════════════════════════
; ANNUAL FPL GUIDELINES
; ═══════════════════════════════════════════════════════════════════════════════
; Per HHS Poverty Guidelines

{@fpl_guidelines}
year = !##:(2014..)                         ; Year
state_type = !(alaska, continental, hawaii) ; State type

; FPL amounts by household size
base_amount = #$:(0..)                      ; Base amount (1 person)
additional_person = #$:(0..)                ; Additional per person

; Specific thresholds
{.thresholds}
size_1 = #$:(0..)                           ; 1 person
size_2 = #$:(0..)                           ; 2 persons
size_3 = #$:(0..)                           ; 3 persons
size_4 = #$:(0..)                           ; 4 persons
size_5 = #$:(0..)                           ; 5 persons
size_6 = #$:(0..)                           ; 6 persons
size_7 = #$:(0..)                           ; 7 persons
size_8 = #$:(0..)                           ; 8 persons

{@fpl_guidelines}


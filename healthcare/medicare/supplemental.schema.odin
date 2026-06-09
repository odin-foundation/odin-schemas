; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Medicare Supplemental (Medigap) Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Medicare Supplement Insurance (Medigap) policies covering standardized plan
; types (A through N), benefits, pricing, and open enrollment protections.
; Derived from NAIC Model Regulation and CMS Medigap guidance.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as medicare

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.medicare.supplemental"
version = "1.0.0"
title = "Medicare Supplemental (Medigap) Schema"
description = "Medicare Supplement Insurance (Medigap) policies"

{$derivation}
source[0].authority = "NAIC"
source[0].citation = "Model Regulation to Implement the NAIC Medicare Supplement Insurance Minimum Standards Model Act"
source[0].url = "https://content.naic.org/sites/default/files/model-law-651.pdf"

source[1].authority = "CMS"
source[1].citation = "Choosing a Medigap Policy: A Guide to Health Insurance for People with Medicare"
source[1].url = "https://www.medicare.gov/publications/02110-Medigap-guide-health-insurance.pdf"

source[2].authority = "GPO"
source[2].citation = "42 CFR Part 403 Subpart E - Medigap Provisions"
source[2].url = "https://www.ecfr.gov/current/title-42/chapter-IV/subchapter-B/part-403"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial Medicare Supplemental schema"
changelog[0].rationale = "Structure derived from NAIC Model Regulation and CMS Medigap guide"

; ═══════════════════════════════════════════════════════════════════════════════
; MEDIGAP PLAN TYPES
; ═══════════════════════════════════════════════════════════════════════════════
; Per NAIC Model Regulation standardized plans

{@plan_type}
plan_letter = (a, b, c, d, f, f_hd, g, g_hd, k, l, m, n)

; Plan availability
{.availability}
available_post_2020 = ?                      ; Available to those new to Medicare after 1/1/2020
pre_2020_only = ?                            ; Only for those eligible before 1/1/2020

{@plan_type}

; ───────────────────────────────────────────────────────────────────────────────
; Standardized Benefits - Per NAIC Model Regulation
; ───────────────────────────────────────────────────────────────────────────────
{.benefits}
; Part A coinsurance - Days 61-90 and 60 lifetime reserve days
part_a_coinsurance = ?                       ; Part A coinsurance (100%)
part_a_coinsurance_percent = #:(0..100)      ; Percentage covered

; Hospice Part A coinsurance
hospice_coinsurance = ?                      ; Hospice Part A coinsurance

; Part A deductible
part_a_deductible = ?                        ; Part A deductible
part_a_deductible_percent = #:(0..100)       ; Percentage covered (50% for Plan K)

; Part B coinsurance
part_b_coinsurance = ?                       ; Part B coinsurance (20%)
part_b_coinsurance_percent = #:(0..100)      ; Percentage covered

; Part B deductible (Plans C and F only for pre-2020)
part_b_deductible = ?                        ; Part B deductible
part_b_deductible_percent = #:(0..100)       ; Percentage covered

; Part B excess charges (Plans F and G)
part_b_excess = ?                            ; Part B excess charges
part_b_excess_percent = #:(0..100)           ; Percentage covered

; Blood (first 3 pints)
blood_first_3_pints = ?                      ; First 3 pints of blood
blood_percent = #:(0..100)                   ; Percentage covered

; Skilled nursing facility coinsurance
snf_coinsurance = ?                          ; SNF coinsurance days 21-100
snf_coinsurance_percent = #:(0..100)         ; Percentage covered (50% for Plan K)

; Foreign travel emergency
foreign_travel = ?                           ; Foreign travel emergency
foreign_travel_deductible = #$:(0..)         ; Deductible amount
foreign_travel_percent = #:(0..100)          ; Percentage after deductible
foreign_travel_lifetime_max = #$:(0..)       ; Lifetime maximum

{@plan_type}

; High-deductible option (Plans F and G)
{.high_deductible}
available = ?                                ; High deductible option
annual_deductible = #$:(0..)                 ; Annual deductible amount

{@plan_type}

; Out-of-pocket limits (Plans K and L)
{.oop_limit}
oop_limited = ?                              ; Out-of-pocket limit
annual_limit = #$:(0..)                      ; Annual OOP limit
after_limit_coverage = #:(0..100)            ; Coverage after limit reached

{@plan_type}

; ═══════════════════════════════════════════════════════════════════════════════
; MEDIGAP POLICY
; ═══════════════════════════════════════════════════════════════════════════════
; Per NAIC Model Regulation

{@policy}
; Policy identification
policy_number = :                           ; Policy number
id = :                                       ; Unique identifier

; Plan type
plan_type = @plan_type                      ; Standardized plan type

; Insurer information
{.insurer}
company_name = :                            ; Insurance company name
naic_number = :                              ; NAIC company code
state_of_domicile = :(2)                     ; Company domicile state

{@policy}

; Policyholder
{.policyholder}
name_first = :                              ; First name
name_last = :                               ; Last name
date_of_birth = *date                       ; Date of birth
gender = (female, male)                     ; Sex
address = @address                           ; Mailing address
mbi = *:                                     ; Medicare Beneficiary Identifier

{@policy}

; Policy dates
{.dates}
effective = date                            ; Policy effective date
application = date                           ; Application date
issue = date                                 ; Issue date
termination = date                           ; Termination date (if applicable)
renewal = date                               ; Next renewal date

{@policy}

; State of issue
issue_state = :(2)                          ; State where policy issued

; Premium information
{.premium}
monthly = #$:(0..)                           ; Monthly premium
annual = #$:(0..)                            ; Annual premium
rating_method = (attained_age, community_rated, issue_age)
tobacco_rate = ?                             ; Tobacco user rate applies
household_discount = ?                       ; Household discount applied
payment_frequency = (annual, monthly, quarterly, semi_annual)

{@policy}

; Underwriting - Per guaranteed issue and open enrollment rules
{.underwriting}
guaranteed_issue = ?                         ; Guaranteed issue applies
open_enrollment = ?                          ; Within Medigap open enrollment
open_enrollment_end = date                   ; Open enrollment end date
medical_underwriting = ?                     ; Subject to medical underwriting
pre_existing_waiting = ?                     ; Pre-existing condition waiting period
pre_existing_months = ##:(0..6)              ; Waiting period months

{@policy}

; Policy status
status = (active, cancelled, lapsed, pending, terminated)

; Cancellation/termination
{.termination}
date = date                                  ; Termination date
reason = (insured_request, insurer_action, nonpayment, other)
notice_date = date                           ; Notice date

{@policy}

; ═══════════════════════════════════════════════════════════════════════════════
; MEDIGAP OPEN ENROLLMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 403.240 - Medigap Open Enrollment Period

{@open_enrollment}
beneficiary_mbi = *:                        ; Beneficiary MBI

; Open enrollment period - Per NAIC Model Regulation
{.period}
start_date = date                           ; OEP start date (Part B effective)
end_date = date                             ; OEP end date (6 months from start)
part_b_effective = date                      ; Part B effective date
age_at_start = ##:(0..100)                   ; Age at OEP start

{@open_enrollment}

; Rights during OEP
{.rights}
guaranteed_issue = ?true                     ; Cannot be denied coverage
no_medical_underwriting = ?true              ; No health questions
no_pre_existing_exclusion = ?                ; Pre-existing conditions covered
may_charge_pre_existing_wait = ?             ; 6-month wait may apply if no prior creditable coverage

{@open_enrollment}

; Prior creditable coverage
{.prior_coverage}
had_creditable = ?                           ; Had creditable coverage
months_creditable = ##:(0..)                 ; Months of creditable coverage
coverage_end_date = date                     ; Prior coverage end date
gap_days = ##:(0..63)                        ; Days gap in coverage

{@open_enrollment}

; ═══════════════════════════════════════════════════════════════════════════════
; GUARANTEED ISSUE RIGHTS
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 403.240 and NAIC Model Regulation

{@guaranteed_issue}
beneficiary_mbi = *:                        ; Beneficiary MBI
qualifying_event = :                        ; Event triggering GI rights

; Qualifying situations - Per NAIC Model
situation = (
    employer_coverage_loss,
    enrollment_violation,
    first_medicare_advantage,
    ma_area_move,
    ma_contract_termination,
    ma_disenrollment,
    medigap_insurer_insolvency,
    medigap_misrepresentation
)

; Event details
{.event}
event_date = date                           ; Date of qualifying event
documentation_type = :                       ; Required documentation
gi_start_date = date                         ; GI period start
gi_end_date = date                           ; GI period end (63 days)

{@guaranteed_issue}

; Plans available under GI
{.available_plans}
plan_a = ?                                   ; Plan A available
plan_b = ?                                   ; Plan B available
plan_c = ?                                   ; Plan C available (if applicable)
plan_d = ?                                   ; Plan D available
plan_f = ?                                   ; Plan F available (if applicable)
plan_g = ?                                   ; Plan G available
plan_k = ?                                   ; Plan K available
plan_l = ?                                   ; Plan L available

{@guaranteed_issue}

; Limitations
{.limitations}
same_or_lesser_benefits = ?                  ; Limited to same/lesser benefits
prior_plan_type = :                          ; Prior Medigap plan type

{@guaranteed_issue}

; ═══════════════════════════════════════════════════════════════════════════════
; MEDIGAP CLAIM
; ═══════════════════════════════════════════════════════════════════════════════
; Medigap claim processing

{@claim}
claim_number = :                            ; Claim number
policy_number = :                           ; Policy number

; Service information
{.service}
service_date = date                         ; Date of service
provider_name = :                            ; Provider name
provider_npi = :                             ; Provider NPI
service_description = :                      ; Service description

{@claim}

; Medicare processing (crossover)
{.medicare}
claim_number = :                             ; Medicare claim number
approved_amount = #$:(0..)                   ; Medicare approved amount
medicare_paid = #$:(0..)                     ; Medicare payment
beneficiary_liability = #$:(0..)             ; Beneficiary liability after Medicare

{@claim}

; Medigap payment
{.medigap_payment}
eligible_amount = #$:(0..)                   ; Amount eligible under Medigap
payment_amount = #$:(0..)                    ; Medigap payment
payment_type = (part_a_coinsurance, part_a_deductible, part_b_coinsurance, part_b_deductible, part_b_excess, snf_coinsurance)
payment_date = date                          ; Payment date

{@claim}

; Claim status
status = (denied, paid, pending)
denial_reason = ::if status = denied         ; Reason if denied

; ═══════════════════════════════════════════════════════════════════════════════
; SELECT POLICY (NETWORK MEDIGAP)
; ═══════════════════════════════════════════════════════════════════════════════
; Per NAIC Model Regulation - SELECT plans

{@select_policy}
= @policy                                    ; Inherit standard policy fields

; SELECT-specific
select_plan = ?true                          ; Is a SELECT policy
network_required = ?                         ; Must use network providers

; Network information
{.network}
network_name = :                             ; Network name
provider_count = ##:(0..)                    ; Network provider count
hospital_count = ##:(0..)                    ; Network hospital count

{@select_policy}

; Out-of-network coverage
{.out_of_network}
emergency_covered = ?                        ; Emergency services covered OON
non_emergency_covered = ?                    ; Non-emergency covered OON
oon_benefit_reduction = #:(0..100)           ; Benefit reduction for OON

{@select_policy}


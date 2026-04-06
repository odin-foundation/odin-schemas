; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Life Insurance Base Policy Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Base life insurance policy type that all life products extend. Contains common
; fields shared by term, whole, universal, and variable life including death
; benefit, beneficiaries, premium, and underwriting.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/life-annuity/types.schema.odin" as la
@import "../common/types.schema.odin" as types
@import "../common/party.schema.odin" as party
@import "../common/agency.schema.odin" as agency
@import "../common/carrier.schema.odin" as carrier

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.life.policy"
version = "1.0.0"
title = "Life Insurance Base Policy Schema"
description = "Base life insurance policy type for all life products"

{$derivation}
source[0].authority = "NAIC"
source[0].citation = "Life Insurance Disclosure Model Regulation"
source[0].url = "https://content.naic.org/sites/default/files/model-law-582.pdf"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-15
changelog[0].change = "Initial life insurance base policy schema"
changelog[0].rationale = "Base type for all life insurance products"

; ═══════════════════════════════════════════════════════════════════════════════
; Life Policy Base Type
; ═══════════════════════════════════════════════════════════════════════════════

{@policy}
; Required fields
death_benefit = !#$:(0..)                     ; Face amount / death benefit
effective = !date                             ; Policy effective date
insured = !@la.life_party                     ; Primary insured
number = !:                                   ; Policy number
status = !@la.life_policy_status              ; Policy status

; ───────────────────────────────────────────────────────────────────────────────
; Policy Identification
; ───────────────────────────────────────────────────────────────────────────────
application_date = date                       ; Application date
application_number = :                        ; Application number
delivered = date                              ; Delivery date
expiration = date                             ; Policy expiration (term policies)
id = :                                        ; Unique identifier
issue_age = ##:(0..100)                       ; Insured age at issue
issue_date = date                             ; Issue date
issue_state = :(2)                            ; State of issue
maturity_date = date                          ; Maturity date (endowment)
policy_year = ##:(1..)                        ; Current policy year

; ───────────────────────────────────────────────────────────────────────────────
; Policy Type Classification
; ───────────────────────────────────────────────────────────────────────────────
product_code = :                              ; Carrier product code
product_name = :                              ; Product marketing name
product_type = (indexed_universal, term, universal, variable_universal, whole)  ; Product type

; ───────────────────────────────────────────────────────────────────────────────
; Premium Information
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
annual = #$:(0..)                             ; Annual premium
frequency = (annual, monthly, other, quarterly, semi_annual, single)  ; Payment frequency
mode_amount = #$:(0..)                        ; Modal premium amount
next_due = date                               ; Next premium due date
paid_to = date                                ; Premiums paid through date
waived = ?                                    ; Premium waiver active

{@policy}

; ───────────────────────────────────────────────────────────────────────────────
; Death Benefit Options
; ───────────────────────────────────────────────────────────────────────────────
{.death_benefit}
accidental_death = ?                          ; Accidental death benefit included
option = (face_amount, face_plus_cash_value, face_plus_premiums)  ; DB option type
return_of_premium = ?                         ; Return of premium on death

{@policy}

; ───────────────────────────────────────────────────────────────────────────────
; Parties
; ───────────────────────────────────────────────────────────────────────────────
owner = @la.life_party                        ; Policy owner
joint_insured = @la.life_party                ; Joint insured (if applicable)
payor = @la.life_party                        ; Premium payor (if different from owner)

; ───────────────────────────────────────────────────────────────────────────────
; Beneficiaries
; ───────────────────────────────────────────────────────────────────────────────
beneficiaries[] = @la.beneficiary             ; Beneficiary designations

; ───────────────────────────────────────────────────────────────────────────────
; Underwriting
; ───────────────────────────────────────────────────────────────────────────────
underwriting = @la.underwriting_class         ; Underwriting classification

; ───────────────────────────────────────────────────────────────────────────────
; Tax Information
; ───────────────────────────────────────────────────────────────────────────────
tax = @la.tax_info                            ; Tax qualification and basis

; ───────────────────────────────────────────────────────────────────────────────
; Premium History
; ───────────────────────────────────────────────────────────────────────────────
payments[] = @la.premium_payment              ; Premium payment history

; ───────────────────────────────────────────────────────────────────────────────
; Distribution
; ───────────────────────────────────────────────────────────────────────────────
agent = @agency.agent                         ; Writing agent
agency = @agency.agency                       ; Writing agency
carrier = @carrier.carrier                    ; Issuing carrier

; ───────────────────────────────────────────────────────────────────────────────
; Policy Status Details
; ───────────────────────────────────────────────────────────────────────────────
{.status_detail}
free_look_end = date                          ; Free look period end date
grace_period_end = date                       ; Grace period end date
lapse_date = date                             ; Date policy lapsed
reinstatement_deadline = date                 ; Last date to reinstate

{@policy}

; ───────────────────────────────────────────────────────────────────────────────
; Illustrations
; ───────────────────────────────────────────────────────────────────────────────
illustrations[] = @la.life_illustration       ; Policy illustrations/ledgers

; ═══════════════════════════════════════════════════════════════════════════════
; Common Life Insurance Riders
; ═══════════════════════════════════════════════════════════════════════════════
; Riders that apply to most life insurance products

{@policy.riders[]}
= @la.rider

; Life-specific rider types
rider_type = (accelerated_death_benefit, accidental_death, child_term, chronic_illness, conversion, critical_illness, disability_income, guaranteed_insurability, long_term_care, other_insured, return_of_premium, spouse_term, term, waiver_of_premium)

; ───────────────────────────────────────────────────────────────────────────────
; Accelerated Death Benefit (ADB)
; ───────────────────────────────────────────────────────────────────────────────
{.adb}
max_acceleration_percent = #:(0..100)         ; Maximum percentage acceleratable
qualifying_conditions[] = (chronic_illness, cognitive_impairment, terminal_illness)  ; Qualifying conditions
terminal_months = ##:(6..24)                  ; Terminal illness definition (months)

{@policy.riders[]}

; ───────────────────────────────────────────────────────────────────────────────
; Waiver of Premium
; ───────────────────────────────────────────────────────────────────────────────
{.waiver}
elimination_period_days = ##:(0..365)         ; Waiting period in days
own_occupation_period_months = ##:(0..60)     ; Own-occupation definition period
to_age = ##:(60..70)                          ; Age waiver ends

{@policy.riders[]}

; ───────────────────────────────────────────────────────────────────────────────
; Guaranteed Insurability Option (GIO)
; ───────────────────────────────────────────────────────────────────────────────
{.gio}
exercise_ages[] = ##:(18..55)                 ; Ages when option can be exercised
max_amount_per_option = #$:(0..)              ; Maximum additional coverage per exercise
remaining_options = ##:(0..10)                ; Number of options remaining

{@policy.riders[]}

; ───────────────────────────────────────────────────────────────────────────────
; Long-Term Care Rider
; ───────────────────────────────────────────────────────────────────────────────
{.ltc}
acceleration_percent = #:(0..100)             ; Percent of DB available for LTC
benefit_period_months = ##:(12..120)          ; Benefit period in months
daily_benefit = #$:(0..)                      ; Daily benefit amount
elimination_period_days = ##:(0..365)         ; Waiting period
inflation_protection = ?                      ; Inflation protection included
monthly_benefit = #$:(0..)                    ; Monthly benefit amount

{@policy.riders[]}

; ═══════════════════════════════════════════════════════════════════════════════
; Life Insurance Claim
; ═══════════════════════════════════════════════════════════════════════════════

{@claim}
; Required fields
date_of_death = !date                         ; Date of death
policy_number = !:                            ; Policy number
status = !@la.claim_status                    ; Claim status

; Optional fields
amount_paid = #$:(0..)                        ; Total amount paid
autopsy_performed = ?                         ; Autopsy was performed
beneficiary_count = ##:(1..20)                ; Number of beneficiaries
cause_of_death = :                            ; Cause of death
claim_number = :                              ; Claim number
contestability_period = ?                     ; Within contestability period
date_notified = date                          ; Date carrier notified
death_certificate_received = ?                ; Death certificate received
denied_reason = :                             ; Reason for denial
gross_death_benefit = #$:(0..)                ; Gross death benefit
id = :                                        ; Unique identifier
interest_paid = #$:(0..)                      ; Interest paid on delayed payment
loan_offset = #$:(0..)                        ; Policy loan offset
manner_of_death = (accident, homicide, natural, pending, suicide, undetermined)  ; Manner of death
net_death_benefit = #$:(0..)                  ; Net death benefit after offsets
paid_date = date                              ; Date claim was paid
pending_documentation[] = :                   ; List of pending documents
suicide_exclusion_applies = ?                 ; Suicide exclusion applies

; ───────────────────────────────────────────────────────────────────────────────
; Claim Beneficiary Payments
; ───────────────────────────────────────────────────────────────────────────────
{@claim.payments[]}
amount = !#$:(0..)                            ; Payment amount
beneficiary_name = !:                         ; Beneficiary name
check_number = :                              ; Check number
date = date                                   ; Payment date
method = (check, direct_deposit, retained_asset, wire)  ; Payment method
percent = #:(0..100)                          ; Percentage of total benefit
status = (issued, pending, void)              ; Payment status


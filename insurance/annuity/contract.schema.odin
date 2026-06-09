; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Annuity Base Contract Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Base annuity contract type that all annuity products extend. Contains common
; fields shared across fixed, indexed, variable, and structured annuities through
; accumulation and distribution phases.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/life-annuity/types.schema.odin" as la
@import "../common/types.schema.odin" as types
@import "../common/party.schema.odin" as party
@import "../common/agency.schema.odin" as agency
@import "../common/carrier.schema.odin" as carrier

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.annuity.contract"
version = "1.0.0"
title = "Annuity Base Contract Schema"
description = "Base annuity contract type for all annuity products"

{$derivation}
source[0].authority = "NAIC"
source[0].citation = "Annuity Disclosure Model Regulation"
source[0].url = "https://content.naic.org/sites/default/files/model-law-245.pdf"

source[1].authority = "IRS"
source[1].citation = "IRC Section 72 - Annuities"
source[1].url = "https://www.irs.gov/publications/p575"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-15
changelog[0].change = "Initial annuity base contract schema"
changelog[0].rationale = "Base type for all annuity products"

; ═══════════════════════════════════════════════════════════════════════════════
; Annuity Contract Base Type
; ═══════════════════════════════════════════════════════════════════════════════

{@contract}
; Required fields
contract_value = #$:(0..)                    ; Current contract value
effective = date                             ; Contract effective date
number = :                                   ; Contract number
owner = @la.life_party                       ; Contract owner
status = @la.annuity_contract_status         ; Contract status

; ───────────────────────────────────────────────────────────────────────────────
; Product Classification
; ───────────────────────────────────────────────────────────────────────────────
annuity_type = (deferred, immediate)         ; Deferred vs immediate
product_type = (fixed, indexed, structured, variable)  ; Product type

; ───────────────────────────────────────────────────────────────────────────────
; Contract Identification
; ───────────────────────────────────────────────────────────────────────────────
annuitant = @la.life_party                    ; Annuitant (person covered)
application_date = date                       ; Application date
application_number = :                        ; Application number
contract_year = ##:(1..)                      ; Current contract year
delivered = date                              ; Delivery date
id = :                                        ; Unique identifier
issue_date = date                             ; Issue date
issue_state = :(2)                            ; State of issue
joint_annuitant = @la.life_party              ; Joint annuitant
joint_owner = @la.life_party                  ; Joint owner
product_code = :                              ; Carrier product code
product_name = :                              ; Product marketing name

; ───────────────────────────────────────────────────────────────────────────────
; Contract Phase
; ───────────────────────────────────────────────────────────────────────────────
phase = (accumulation, annuitization, distribution, payout)  ; Current phase

; ───────────────────────────────────────────────────────────────────────────────
; Beneficiaries
; ───────────────────────────────────────────────────────────────────────────────
beneficiaries[] = @la.beneficiary             ; Death benefit beneficiaries

; ───────────────────────────────────────────────────────────────────────────────
; Purchase Payments / Contributions
; ───────────────────────────────────────────────────────────────────────────────
accepts_additional = ?                        ; Accepts additional contributions
initial_premium = #$:(0..)                    ; Initial purchase payment
max_additional_premium = #$:(0..)             ; Maximum additional payment
min_additional_premium = #$:(0..)             ; Minimum additional payment
payments[] = @la.premium_payment              ; Purchase payment history
total_contributions = #$:(0..)                ; Total contributions to date

; ───────────────────────────────────────────────────────────────────────────────
; Tax Information
; ───────────────────────────────────────────────────────────────────────────────
tax = @la.tax_info                            ; Tax qualification and basis

; ───────────────────────────────────────────────────────────────────────────────
; Contract Value Components
; ───────────────────────────────────────────────────────────────────────────────
{.values}
accumulated_value = #$:(0..)                  ; Accumulated contract value
bonus_value = #$:(0..)                        ; Bonus value (if applicable)
death_benefit_value = #$:(0..)                ; Death benefit amount
free_withdrawal_amount = #$:(0..)             ; Available free withdrawal
market_value_adjustment = #$                  ; MVA amount (if applicable) - can be negative
net_surrender_value = #$:(0..)                ; Net surrender value
surrender_charge = #$:(0..)                   ; Current surrender charge
withdrawal_charge = #$:(0..)                  ; Withdrawal charge (if applicable)

{@contract}

; ───────────────────────────────────────────────────────────────────────────────
; Surrender Information
; ───────────────────────────────────────────────────────────────────────────────
surrender_schedule = @la.surrender_schedule   ; Surrender charge schedule
surrender_charge_expiration = date            ; When surrender charges end

; ───────────────────────────────────────────────────────────────────────────────
; Free Withdrawal
; ───────────────────────────────────────────────────────────────────────────────
{.free_withdrawal}
annual_amount = #$:(0..)                      ; Annual free withdrawal dollar amount
annual_percent = #:(0..20)                    ; Annual free withdrawal percentage
cumulative = ?                                ; Unused free withdrawal cumulates
max_amount = #$:(0..)                         ; Maximum free withdrawal
remaining_amount = #$:(0..)                   ; Remaining this contract year
rmd_exempt = ?                                ; RMDs don't count against free withdrawal
used_amount = #$:(0..)                        ; Amount used this year

{@contract}

; ───────────────────────────────────────────────────────────────────────────────
; Withdrawal History
; ───────────────────────────────────────────────────────────────────────────────
withdrawals[] = @withdrawal                   ; Withdrawal history

; ───────────────────────────────────────────────────────────────────────────────
; Distribution
; ───────────────────────────────────────────────────────────────────────────────
agent = @agency.agent                         ; Writing agent
agency = @agency.agency                       ; Writing agency
carrier = @carrier.carrier                    ; Issuing carrier

; ───────────────────────────────────────────────────────────────────────────────
; Contract Status Details
; ───────────────────────────────────────────────────────────────────────────────
{.status_detail}
annuitization_date = date                     ; Date annuitized (if applicable)
free_look_expiration = date                   ; Free look period end date
maturity_age = ##:(85..115)                   ; Contract maturity age
maturity_date = date                          ; Contract maturity date
surrender_date = date                         ; Date surrendered

{@contract}

; ───────────────────────────────────────────────────────────────────────────────
; Illustrations
; ───────────────────────────────────────────────────────────────────────────────
illustrations[] = @la.annuity_illustration    ; Contract illustrations/projections

; ═══════════════════════════════════════════════════════════════════════════════
; Withdrawal Record
; ═══════════════════════════════════════════════════════════════════════════════

{@withdrawal}
; Required fields
amount = #$:(0..)                            ; Withdrawal amount
date = date                                  ; Withdrawal date

; Optional fields
account_last_four = *:(4)                     ; Last 4 digits of destination account
charge_amount = #$:(0..)                      ; Any withdrawal charges
free_amount = #$:(0..)                        ; Amount from free withdrawal
gain_amount = #$:(0..)                        ; Taxable gain portion
id = :                                        ; Withdrawal identifier
method = (ach, check, wire)                   ; Disbursement method
mva_amount = #$                               ; Market value adjustment - can be negative
principal_amount = #$:(0..)                   ; Return of principal portion
reference = :                                 ; Transaction reference
rmd = ?                                       ; Required minimum distribution
status = (cancelled, completed, pending, returned)  ; Withdrawal status
surrender_charge = #$:(0..)                   ; Surrender charge applied
type = (hardship, partial, rmd, scheduled, surrender, systematic)  ; Withdrawal type

; ═══════════════════════════════════════════════════════════════════════════════
; Premium Bonus
; ═══════════════════════════════════════════════════════════════════════════════
; Many annuities offer premium bonuses (with longer surrender periods)

{@premium_bonus}
bonus_percent = #                            ; Bonus percentage
effective = date                             ; Date bonus credited

bonus_amount = #$:(0..)                       ; Dollar amount of bonus
recapture = ?                                 ; Subject to bonus recapture
recapture_period_years = ##:(1..15)           ; Years bonus can be recaptured
vesting_schedule[] = @bonus_vesting           ; Vesting schedule

{@bonus_vesting}
year = ##:(1..15)                            ; Contract year
vested_percent = #:(0..100)                  ; Percentage vested

; ═══════════════════════════════════════════════════════════════════════════════
; Death Benefit Options
; ═══════════════════════════════════════════════════════════════════════════════
; Death benefit options for deferred annuities

{@death_benefit}
type = (accumulated_value, greater_of, highest_anniversary, return_of_premium, stepped_up)  ; DB type

; Death benefit amounts
amount = #$:(0..)                             ; Current death benefit
enhanced = ?                                  ; Enhanced death benefit rider
enhanced_cost_bps = ##                        ; Annual cost in basis points
enhanced_type = (earnings_enhanced, greater_of_roll_up, percentage_roll_up)  ; Enhanced DB type
guaranteed_amount = #$:(0..)                  ; Guaranteed minimum
last_step_up = date                           ; Date of last step-up
roll_up_percent = #:(0..10)                   ; Roll-up percentage (if applicable)
step_up_frequency = (annual, monthly, none, quarterly)  ; Step-up frequency
step_up_value = #$:(0..)                      ; Step-up value

; ═══════════════════════════════════════════════════════════════════════════════
; Annuity Base Riders
; ═══════════════════════════════════════════════════════════════════════════════

{@contract.riders[]}
= @la.rider

annuity_rider_type = (beneficiary_protection, confinement_waiver, death_benefit_enhanced, earnings_protection, glwb, gmab, gmdb, gmib, income_doubler, long_term_care, nursing_home_waiver, return_of_premium, terminal_illness)

; ═══════════════════════════════════════════════════════════════════════════════
; Annuity Claim (Death Benefit)
; ═══════════════════════════════════════════════════════════════════════════════

{@claim}
; Required fields
contract_number = :                          ; Contract number
date_of_death = date                         ; Date of death (owner or annuitant)
status = @la.claim_status                    ; Claim status

; Optional fields
amount_paid = #$:(0..)                        ; Total amount paid
beneficiary_count = ##                        ; Number of beneficiaries
claim_number = :                              ; Claim number
contract_value_at_death = #$:(0..)            ; Contract value at date of death
date_notified = date                          ; Date carrier notified
death_benefit_type = :                        ; Death benefit type claimed
death_certificate_received = ?                ; Death certificate received
deceased = (annuitant, joint_annuitant, joint_owner, owner)  ; Who deceased
denied_reason = :                             ; Reason for denial
gross_death_benefit = #$:(0..)                ; Gross death benefit
id = :                                        ; Unique identifier
interest_paid = #$:(0..)                      ; Interest on delayed payment
net_death_benefit = #$:(0..)                  ; Net benefit after charges
paid_date = date                              ; Date claim was paid
pending_documentation[] = :                   ; Pending documents
spousal_continuation = ?                      ; Spouse continuing contract
stretch_election = ?                          ; Beneficiary electing stretch
surrender_charge_waived = ?                   ; Surrender charge waived on death

; ───────────────────────────────────────────────────────────────────────────────
; Claim Beneficiary Options
; ───────────────────────────────────────────────────────────────────────────────
{@claim.beneficiary_elections[]}
beneficiary_name = :                         ; Beneficiary name
election = (annuitization, five_year_rule, lifetime_stretch, lump_sum, spousal_continuation)  ; Distribution election
percent = #:(0..100)                          ; Percentage of benefit
amount = #$:(0..)                             ; Dollar amount
payment_date = date                           ; Payment/start date
status = (completed, elected, pending)        ; Election status


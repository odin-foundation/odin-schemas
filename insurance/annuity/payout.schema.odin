; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Annuity Payout/Income Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Income annuities and payout phase for all annuity types including Single Premium
; Immediate Annuity (SPIA), Deferred Income Annuity (DIA), and Qualified Longevity
; Annuity Contract (QLAC).
; ═══════════════════════════════════════════════════════════════════════════════

@import "./contract.schema.odin" as annuity
@import "../common/life-annuity/types.schema.odin" as la

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.annuity.payout"
version = "1.0.0"
title = "Annuity Payout/Income Schema"
description = "Income annuities and payout phase schemas"

{$derivation}
source[0].authority = "IRS"
source[0].citation = "IRC Section 72 - Annuity Taxation"
source[0].url = "https://www.irs.gov/publications/p575"

source[1].authority = "Treasury"
source[1].citation = "QLAC Final Regulations"
source[1].url = "https://www.federalregister.gov/documents/2014/07/21/2014-16837/longevity-annuity-contracts"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-15
changelog[0].change = "Initial annuity payout/income schema"
changelog[0].rationale = "Income annuity and payout phase data structures"

; ═══════════════════════════════════════════════════════════════════════════════
; Payout Options
; ═══════════════════════════════════════════════════════════════════════════════
; Standard payout/annuitization options available

{@payout_option}
; Required fields
option_type = (cash_refund, installment_refund, joint_100, joint_50, joint_66, joint_75, life_only, life_with_period, period_certain, temporary)  ; Payout type

; Option details
{.details}
; Joint life
joint_annuitant_age = ##:(18..100)            ; Joint annuitant age
joint_percentage = #:(0..100)                 ; Survivor percentage

; Period certain
period_remaining = ##:(0..30)                 ; Remaining guaranteed period
period_years = ##:(5..30)                     ; Guaranteed period (years)

; Refund options
refund_remaining = #$:(0..)                   ; Remaining refund amount
refund_type = (cash, installment)             ; Refund payment type

{@payout_option}

; Payout amounts
{.amounts}
annual_payment = #$:(0..)                     ; Annual payment amount
first_payment_date = date                     ; First payment date
monthly_payment = #$:(0..)                    ; Monthly payment amount
next_payment_date = date                      ; Next scheduled payment
payment_frequency = (annual, monthly, quarterly, semi_annual)  ; Payment frequency
payments_made = ##                            ; Total payments made
payments_remaining = ##                       ; Payments remaining (if period certain)
total_paid = #$:(0..)                         ; Total paid to date

{@payout_option}

; Payment adjustments
{.adjustments}
cola = ?                                      ; Cost of living adjustment
cola_percent = #:(0..10)                      ; COLA percentage
cola_type = (compound, simple)                ; COLA calculation
inflation_indexed = ?                         ; Indexed to inflation

{@payout_option}

; ═══════════════════════════════════════════════════════════════════════════════
; Single Premium Immediate Annuity (SPIA)
; ═══════════════════════════════════════════════════════════════════════════════
; Immediate income stream in exchange for lump sum

{@spia}
; Required fields
annuitant = @la.life_party                   ; Annuitant
first_payment = date                         ; First payment date
number = :                                   ; Contract number
owner = @la.life_party                       ; Contract owner
payout_option = @payout_option               ; Selected payout option
premium = #$:(0..)                           ; Single premium paid
status = (active, completed, terminated)     ; Contract status

; ───────────────────────────────────────────────────────────────────────────────
; Contract Identification
; ───────────────────────────────────────────────────────────────────────────────
effective = date                              ; Contract effective date
id = :                                        ; Unique identifier
issue_date = date                             ; Issue date
issue_state = :(2)                            ; State of issue
product_code = :                              ; Product code
product_name = :                              ; Product name

; ───────────────────────────────────────────────────────────────────────────────
; Joint Annuitant (if applicable)
; ───────────────────────────────────────────────────────────────────────────────
joint_annuitant = @la.life_party              ; Joint annuitant

; ───────────────────────────────────────────────────────────────────────────────
; Payment Details
; ───────────────────────────────────────────────────────────────────────────────
{.payments}
amount = #$:(0..)                             ; Payment amount
frequency = (annual, monthly, quarterly, semi_annual)  ; Frequency
last_payment = date                           ; Most recent payment date
next_payment = date                           ; Next payment date
payments_made = ##                            ; Total payments made
total_paid = #$:(0..)                         ; Total amount paid

{@spia}

; ───────────────────────────────────────────────────────────────────────────────
; Tax Information
; ───────────────────────────────────────────────────────────────────────────────
tax = @la.tax_info                            ; Tax qualification

{.tax_exclusion}
exclusion_ratio = #:(0..100)                  ; Exclusion ratio (percent tax-free)
expected_return = #$:(0..)                    ; Expected return for exclusion
investment_in_contract = #$:(0..)             ; Cost basis
tax_free_amount = #$:(0..)                    ; Tax-free portion per payment
taxable_amount = #$:(0..)                     ; Taxable portion per payment

{@spia}

; ───────────────────────────────────────────────────────────────────────────────
; Beneficiaries
; ───────────────────────────────────────────────────────────────────────────────
beneficiaries[] = @la.beneficiary             ; Beneficiaries (for refund options)

; ───────────────────────────────────────────────────────────────────────────────
; Commutation (if allowed)
; ───────────────────────────────────────────────────────────────────────────────
{.commutation}
available = ?                                 ; Commutation allowed
commutation_value = #$:(0..)                  ; Current commutation value
max_commutation_percent = #:(0..100)          ; Maximum commutable

{@spia}

; ═══════════════════════════════════════════════════════════════════════════════
; Deferred Income Annuity (DIA) / Longevity Annuity
; ═══════════════════════════════════════════════════════════════════════════════
; Purchase now, payments begin at future date

{@dia}
; Required fields
annuitant = @la.life_party                   ; Annuitant
income_start_date = date                     ; Date income begins
number = :                                   ; Contract number
owner = @la.life_party                       ; Contract owner
premium = #$:(0..)                           ; Purchase payment(s)
status = (active, deferred, terminated)      ; Contract status

; ───────────────────────────────────────────────────────────────────────────────
; Contract Identification
; ───────────────────────────────────────────────────────────────────────────────
effective = date                              ; Contract effective date
id = :                                        ; Unique identifier
issue_date = date                             ; Issue date
issue_state = :(2)                            ; State of issue
product_code = :                              ; Product code
product_name = :                              ; Product name

; ───────────────────────────────────────────────────────────────────────────────
; Deferral Period
; ───────────────────────────────────────────────────────────────────────────────
{.deferral}
deferral_years = ##:(1..45)                   ; Years until income begins
start_age = ##:(50..90)                       ; Age when income begins
years_remaining = ##:(0..45)                  ; Years until income starts

{@dia}

; ───────────────────────────────────────────────────────────────────────────────
; Income Details (Guaranteed at Purchase)
; ───────────────────────────────────────────────────────────────────────────────
{.income}
monthly_amount = #$:(0..)                     ; Guaranteed monthly income
annual_amount = #$:(0..)                      ; Guaranteed annual income
frequency = (annual, monthly, quarterly, semi_annual)  ; Payment frequency
payout_option = @payout_option                ; Selected payout option

{@dia}

; ───────────────────────────────────────────────────────────────────────────────
; Cash Refund Value (During Deferral)
; ───────────────────────────────────────────────────────────────────────────────
{.refund}
cash_refund_available = ?                     ; Can surrender during deferral
cash_refund_value = #$:(0..)                  ; Current cash refund value
return_of_premium_death_benefit = ?           ; ROP death benefit during deferral

{@dia}

; ───────────────────────────────────────────────────────────────────────────────
; Joint Annuitant
; ───────────────────────────────────────────────────────────────────────────────
joint_annuitant = @la.life_party              ; Joint annuitant

; ───────────────────────────────────────────────────────────────────────────────
; Tax Information
; ───────────────────────────────────────────────────────────────────────────────
tax = @la.tax_info                            ; Tax qualification

; ───────────────────────────────────────────────────────────────────────────────
; Beneficiaries
; ───────────────────────────────────────────────────────────────────────────────
beneficiaries[] = @la.beneficiary             ; Beneficiaries

; ═══════════════════════════════════════════════════════════════════════════════
; Qualified Longevity Annuity Contract (QLAC)
; ═══════════════════════════════════════════════════════════════════════════════
; Special DIA that can be purchased with qualified funds, exempt from RMD

{@qlac}
= @dia                                        ; Inherit DIA fields

; QLAC-specific requirements
qlac_qualified = ?true                        ; Is QLAC qualified

; ───────────────────────────────────────────────────────────────────────────────
; QLAC Limits
; ───────────────────────────────────────────────────────────────────────────────
{.qlac_limits}
max_age_to_start = ##:(70..85)                ; Maximum age income must start
max_premium = #$:(0..)                        ; Maximum QLAC premium allowed
premium_limit_used = #$:(0..)                 ; How much of limit used
remaining_limit = #$:(0..)                    ; Remaining QLAC limit

{@qlac}

; ───────────────────────────────────────────────────────────────────────────────
; QLAC Certification
; ───────────────────────────────────────────────────────────────────────────────
{.certification}
certified = ?                                 ; Carrier certified as QLAC
certification_date = date                     ; Date certified
form_filed = ?                                ; Required forms filed
rmd_exempt_amount = #$:(0..)                  ; Amount exempt from RMD calculation

{@qlac}

; ═══════════════════════════════════════════════════════════════════════════════
; Annuitization of Deferred Annuity
; ═══════════════════════════════════════════════════════════════════════════════
; When a deferred annuity (fixed, indexed, variable) is annuitized

{@annuitization}
; Required fields
annuitization_date = date                    ; Date of annuitization
contract_number = :                          ; Original contract number
contract_value_annuitized = #$:(0..)         ; Amount annuitized
payout_option = @payout_option               ; Selected payout option

; Optional fields
annuitization_rates_used = :                  ; Rate basis used
first_payment = date                          ; First payment date
guaranteed_payment_period = ##:(0..30)        ; Guaranteed period (years)
id = :                                        ; Annuitization record ID
partial = ?                                   ; Partial annuitization
partial_amount = #$:(0..)                     ; Amount partially annuitized
remaining_contract_value = #$:(0..)           ; Value remaining in deferred contract
settlement_option = :                         ; Settlement option name

; ───────────────────────────────────────────────────────────────────────────────
; Payment Schedule
; ───────────────────────────────────────────────────────────────────────────────
{.schedule}
payment_amount = #$:(0..)                     ; Periodic payment amount
payment_frequency = (annual, monthly, quarterly, semi_annual)  ; Frequency
first_payment_date = date                     ; First payment date
last_payment_date = date                      ; Last payment date (if period certain)
total_payments_expected = ##                  ; Total payments expected

{@annuitization}

; ═══════════════════════════════════════════════════════════════════════════════
; Payment Record
; ═══════════════════════════════════════════════════════════════════════════════
; Individual payment record for income annuities

{@payment}
; Required fields
amount = #$:(0..)                            ; Payment amount
date = date                                  ; Payment date

; Optional fields
account_last_four = *:(4)                     ; Last 4 digits of deposit account
contract_number = :                           ; Contract number
federal_withholding = #$:(0..)                ; Federal tax withheld
gross_amount = #$:(0..)                       ; Gross amount before withholding
id = :                                        ; Payment ID
method = (ach, check, wire)                   ; Payment method
net_amount = #$:(0..)                         ; Net amount after withholding
payment_number = ##                           ; Payment sequence number
reference = :                                 ; Transaction reference
state_withholding = #$:(0..)                  ; State tax withheld
status = (issued, pending, returned, void)    ; Payment status
tax_free_portion = #$:(0..)                   ; Exclusion ratio portion
taxable_portion = #$:(0..)                    ; Taxable portion

; ═══════════════════════════════════════════════════════════════════════════════
; Payout Factors
; ═══════════════════════════════════════════════════════════════════════════════
; Actuarial factors used to calculate income payments

{@payout_factors}
; Required fields
effective = date                             ; Factor effective date

; Factor details
age = ##:(0..120)                             ; Annuitant age
gender = (female, male, unisex)               ; Gender basis
joint_age = ##:(0..120)                       ; Joint annuitant age (if applicable)
mortality_table = :                           ; Mortality table used
option_type = @payout_option                  ; Payout option type
payout_factor = #                             ; Dollars per $1000 of value

; Rate information
assumed_interest_rate = #:(0..10)             ; AIR used in calculation
current_interest_rate = #:(0..10)             ; Current rate (for variable)


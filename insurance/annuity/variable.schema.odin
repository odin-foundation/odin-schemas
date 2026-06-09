; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Variable Annuity Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Variable annuities with investment subaccounts and living benefit guarantees.
; SEC and FINRA regulated securities featuring GLWB, GMIB, GMAB riders and
; death benefit guarantees (GMDB).
; ═══════════════════════════════════════════════════════════════════════════════

@import "./contract.schema.odin" as annuity
@import "../common/life-annuity/types.schema.odin" as la

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.annuity.variable"
version = "1.0.0"
title = "Variable Annuity Schema"
description = "Variable annuity with investment subaccounts and living benefits"

{$derivation}
source[0].authority = "SEC"
source[0].citation = "Securities Act Registration for Variable Annuities"
source[0].url = "https://www.sec.gov/rules/final/33-8098.htm"

source[1].authority = "FINRA"
source[1].citation = "Variable Annuity Suitability Rule 2330"
source[1].url = "https://www.finra.org/rules-guidance/rulebooks/finra-rules/2330"

source[2].authority = "NAIC"
source[2].citation = "Variable Annuity Model Regulation"
source[2].url = "https://content.naic.org/sites/default/files/model-law-250.pdf"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-15
changelog[0].change = "Initial variable annuity schema"
changelog[0].rationale = "Variable annuity with SEC/FINRA compliance fields"

; ═══════════════════════════════════════════════════════════════════════════════
; Variable Annuity
; ═══════════════════════════════════════════════════════════════════════════════

{@variable_annuity}
= @annuity.contract                           ; Inherit all base contract fields

; Set product type
product_type = (variable)

; ───────────────────────────────────────────────────────────────────────────────
; Separate Account (Investment Portion)
; ───────────────────────────────────────────────────────────────────────────────
{.separate_account}
last_valuation_date = date                    ; Date of last valuation
total_value = #$:(0..)                        ; Total separate account value
valuation_frequency = (daily, monthly, weekly)  ; How often valued

{@variable_annuity}

; ───────────────────────────────────────────────────────────────────────────────
; Fixed Account (General Account Option)
; ───────────────────────────────────────────────────────────────────────────────
{.fixed_account}
available = ?                                 ; Fixed account available
balance = #$:(0..)                            ; Fixed account balance
current_rate = #:(0..10)                      ; Current declared rate
guaranteed_rate = #                           ; Guaranteed minimum rate
max_allocation_percent = #:(0..100)           ; Maximum allowed in fixed
transfer_restrictions = :                     ; Transfer restrictions

{@variable_annuity}

; ───────────────────────────────────────────────────────────────────────────────
; Subaccount Holdings
; ───────────────────────────────────────────────────────────────────────────────
available_subaccounts_count = ##              ; Number of available options
subaccounts[] = @la.subaccount                ; Investment subaccount holdings

; ───────────────────────────────────────────────────────────────────────────────
; Model Portfolio
; ───────────────────────────────────────────────────────────────────────────────
{.model_portfolio}
active = ?                                    ; Using a model portfolio
model_name = :                                ; Model portfolio name
risk_level = (aggressive, conservative, moderate, moderately_aggressive, moderately_conservative)  ; Risk profile

{@variable_annuity}

; ───────────────────────────────────────────────────────────────────────────────
; Automatic Rebalancing
; ───────────────────────────────────────────────────────────────────────────────
{.rebalancing}
active = ?                                    ; Auto-rebalancing enabled
frequency = (annual, monthly, quarterly, semi_annual)  ; Rebalancing frequency
last_rebalance = date                         ; Date of last rebalance
next_rebalance = date                         ; Next scheduled rebalance
threshold_percent = #:(0..25)                 ; Drift threshold to trigger
tolerance_band = #:(0..10)                    ; Tolerance band percentage

{@variable_annuity}

; ───────────────────────────────────────────────────────────────────────────────
; Dollar Cost Averaging (DCA)
; ───────────────────────────────────────────────────────────────────────────────
{.dca}
active = ?                                    ; DCA active
amount = #$:(0..)                             ; DCA amount per period
effective = date                              ; DCA start date
frequency = (monthly, quarterly)              ; DCA frequency
from_account = :                              ; Source account
remaining_periods = ##:(0..120)               ; Periods remaining
to_allocations[] = @dca_target                ; Target allocations

{@variable_annuity}

{@dca_target}
subaccount = :                               ; Target subaccount
percent = #:(0..100)                         ; Allocation percentage

; ───────────────────────────────────────────────────────────────────────────────
; Transfer Activity
; ───────────────────────────────────────────────────────────────────────────────
{.transfers}
free_transfers_per_year = ##:(0..24)          ; Free transfers allowed
free_transfers_used = ##:(0..24)              ; Free transfers used this year
last_transfer_date = date                     ; Date of last transfer
transfer_fee = #$:(0..)                       ; Fee per excess transfer
ytd_transfer_count = ##:(0..100)              ; Transfers year-to-date

{@variable_annuity}

; ───────────────────────────────────────────────────────────────────────────────
; Fees and Expenses
; ───────────────────────────────────────────────────────────────────────────────
{.fees}
admin_fee_annual = #$:(0..)                   ; Annual administrative fee
admin_fee_percent = #                         ; Admin fee as percent of value
base_contract_charge = #:(0..3)               ; Base contract charge (M&E)
mortality_expense = #:(0..2)                  ; Mortality and expense charge
rider_charges_total = #:(0..5)                ; Total rider charges
total_annual_expense = #:(0..8)               ; Total annual expenses

{@variable_annuity}

; ═══════════════════════════════════════════════════════════════════════════════
; Guaranteed Minimum Death Benefit (GMDB)
; ═══════════════════════════════════════════════════════════════════════════════
; Death benefit guarantee options for variable annuities

{@variable_annuity.death_benefit}
= @annuity.death_benefit                      ; Inherit base death benefit

; GMDB-specific options
gmdb_type = (annual_step_up, earnings_protection, greater_of, highest_anniversary, return_of_premium, roll_up)  ; GMDB type

; Roll-up death benefit
{.roll_up}
percent = #:(0..10)                           ; Annual roll-up percentage
roll_up_type = (compound, simple)             ; Roll-up calculation method
roll_up_value = #$:(0..)                      ; Current roll-up value
max_age = ##:(75..90)                         ; Maximum age for roll-up

; Step-up death benefit
{.step_up}
frequency = (annual, every_5_years, quarterly)  ; Step-up frequency
highest_value = #$:(0..)                      ; Highest stepped-up value
last_step_up = date                           ; Date of last step-up

; Spousal continuation
{.spousal}
continuation_allowed = ?                      ; Spouse can continue contract
stepped_up_basis = ?                          ; Spouse gets stepped-up basis

{@variable_annuity}

; ═══════════════════════════════════════════════════════════════════════════════
; Variable Annuity Living Benefit Riders
; ═══════════════════════════════════════════════════════════════════════════════

; ───────────────────────────────────────────────────────────────────────────────
; Guaranteed Lifetime Withdrawal Benefit (GLWB)
; ───────────────────────────────────────────────────────────────────────────────
; Most popular living benefit - guarantees withdrawals for life

{@va_glwb}
= @la.rider

; Required fields
withdrawal_type = (for_life, for_life_joint, for_period)  ; Withdrawal guarantee type

; Status
{.status}
activated = ?                                 ; Withdrawals have begun
activation_age = ##:(50..95)                  ; Age at activation
activation_date = date                        ; Date withdrawals began
in_deferral = ?                               ; Still in deferral period
step_up_available = ?                         ; Step-up currently available

{@va_glwb}

; Benefit base
{.benefit_base}
amount = #$:(0..)                             ; Current benefit base
bonus_credits = #$:(0..)                      ; Total bonus credits
guaranteed_amount = #$:(0..)                  ; Guaranteed minimum
highest_anniversary = #$:(0..)                ; Highest anniversary value
initial_amount = #$:(0..)                     ; Initial benefit base
roll_up_percent = #:(0..10)                   ; Annual deferral credit
roll_up_type = (compound, simple)             ; Roll-up calculation
total_roll_up = #$:(0..)                      ; Total accumulated roll-up

{@va_glwb}

; Withdrawal percentages by age
{.withdrawal_rates}
age_55_59 = #:(0..10)                         ; Rate for ages 55-59
age_60_64 = #:(0..10)                         ; Rate for ages 60-64
age_65_69 = #:(0..10)                         ; Rate for ages 65-69
age_70_74 = #:(0..10)                         ; Rate for ages 70-74
age_75_plus = #:(0..10)                       ; Rate for age 75+
current_rate = #:(0..10)                      ; Current withdrawal rate
joint_reduction = #:(0..3)                    ; Reduction for joint option
locked_rate = #:(0..10)                       ; Rate locked at activation

{@va_glwb}

; Annual withdrawal amounts
{.amounts}
annual_max = #$:(0..)                         ; Maximum annual withdrawal
annual_withdrawal = #$:(0..)                  ; Guaranteed annual amount
excess_withdrawals = #$:(0..)                 ; Excess withdrawals (reduces benefit)
lifetime_total = #$:(0..)                     ; Total lifetime withdrawals
remaining_this_year = #$:(0..)                ; Remaining this contract year
ytd_withdrawals = #$:(0..)                    ; Year-to-date withdrawals

{@va_glwb}

; Investment restrictions
{.investment_restrictions}
allocation_models_required = ?                ; Must use allocation models
restricted_subaccounts[] = :                  ; Restricted subaccounts
volatility_management = ?                     ; Required volatility management

{@va_glwb}

; Fees
{.fees}
annual_fee_bps = ##:(0..300)                  ; Annual fee in basis points
fee_basis = (benefit_base, contract_value, higher_of)  ; Fee calculation basis
fee_increases_allowed = ?                     ; Carrier can increase fee
max_fee_bps = ##:(0..400)                     ; Maximum fee if increases allowed

{@va_glwb}

; ───────────────────────────────────────────────────────────────────────────────
; Guaranteed Minimum Income Benefit (GMIB)
; ───────────────────────────────────────────────────────────────────────────────
; Guarantees minimum income at annuitization

{@va_gmib}
= @la.rider

; Status
{.status}
can_exercise = ?                              ; Currently eligible to exercise
exercise_deadline = date                      ; Must exercise by this date
exercised = ?                                 ; Annuitization has occurred
waiting_period_years = ##:(5..15)             ; Required waiting period
years_to_exercise = ##:(0..20)                ; Years until can exercise

{@va_gmib}

; Benefit base
{.benefit_base}
amount = #$:(0..)                             ; Current benefit base
guaranteed_amount = #$:(0..)                  ; Minimum guaranteed amount
roll_up_percent = #:(0..10)                   ; Annual roll-up rate
roll_up_type = (compound, simple)             ; Roll-up calculation

{@va_gmib}

; Annuitization
{.annuitization}
estimated_monthly_income = #$:(0..)           ; Estimated monthly income
payout_factor = #                             ; Payout factor per $1000
payout_options[] = (cash_refund, installment_refund, joint_100, joint_50, joint_66, life_only, period_5, period_10, period_15, period_20)  ; Available options

{@va_gmib}

; Fees
{.fees}
annual_fee_bps = ##:(0..200)                  ; Annual fee in basis points
fee_basis = (benefit_base, contract_value)    ; Fee calculation basis

{@va_gmib}

; ───────────────────────────────────────────────────────────────────────────────
; Guaranteed Minimum Accumulation Benefit (GMAB)
; ───────────────────────────────────────────────────────────────────────────────
; Guarantees minimum accumulation value at specific date

{@va_gmab}
= @la.rider

; Terms
{.terms}
guarantee_date = date                         ; Date guarantee matures
guarantee_period_years = ##:(5..20)           ; Guarantee period
years_remaining = ##:(0..20)                  ; Years until maturity

{@va_gmab}

; Guarantee amounts
{.guarantee}
guaranteed_percent = #:(0..200)               ; Percentage of premium guaranteed
guaranteed_amount = #$:(0..)                  ; Guaranteed minimum value
premiums_accumulated = #$:(0..)               ; Total premiums for guarantee
projected_shortfall = #$:(0..)                ; Projected shortfall at maturity

{@va_gmab}

; Current values
{.values}
contract_value = #$:(0..)                     ; Current contract value
on_track = ?                                  ; Currently on track to meet guarantee

{@va_gmab}

; Fees
{.fees}
annual_fee_bps = ##:(0..150)                  ; Annual fee in basis points

{@va_gmab}

; ═══════════════════════════════════════════════════════════════════════════════
; Variable Annuity Claim (Death Benefit)
; ═══════════════════════════════════════════════════════════════════════════════

{@va_claim}
= @annuity.claim                              ; Inherit base claim

; VA-specific claim fields
{.valuation}
contract_value_at_death = #$:(0..)            ; Contract value at DOD
gmdb_value = #$:(0..)                         ; GMDB value
highest_anniversary_value = #$:(0..)          ; Highest anniversary value
return_of_premium_value = #$:(0..)            ; Total premiums paid
roll_up_value = #$:(0..)                      ; Roll-up value

{@va_claim}

; Death benefit determination
{.determination}
greater_of_calculation = ?                    ; Greater-of calculation used
value_used = (contract_value, gmdb, highest_anniversary, roll_up)  ; Which value was highest
final_death_benefit = #$:(0..)                ; Final death benefit amount

{@va_claim}

; ═══════════════════════════════════════════════════════════════════════════════
; Compliance and Suitability
; ═══════════════════════════════════════════════════════════════════════════════
; FINRA suitability requirements for variable annuities

{@suitability}
; Required fields
suitability_determination = :                ; Suitability determination
suitability_date = date                      ; Date of determination

; Customer profile
{.customer_profile}
age_at_purchase = ##:(18..100)                ; Age at purchase
annual_income = #$:(0..)                      ; Annual income
investment_experience = (extensive, limited, moderate, none)  ; Investment experience
investment_horizon_years = ##:(1..50)         ; Investment time horizon
liquidity_needs = (high, low, moderate)       ; Liquidity requirements
net_worth = #$                                ; Net worth - can be negative
risk_tolerance = (aggressive, conservative, moderate)  ; Risk tolerance
tax_bracket = #:(0..50)                       ; Tax bracket

{@suitability}

; Exchange evaluation
{.exchange}
existing_annuity = ?                          ; Replacing existing annuity
fee_comparison_done = ?                       ; Fee comparison completed
feature_comparison_done = ?                   ; Feature comparison completed
new_surrender_period = ##:(1..15)             ; New surrender period
surrender_charge_remaining = #$:(0..)         ; Surrender charge on existing

{@suitability}

; Principal signature
{.approval}
approval_date = date                          ; Approval date
approved_by = :                               ; Principal name
firm_name = :                                 ; B/D firm name
rep_crd = :                                   ; Rep CRD number
rep_name = :                                  ; Rep name

{@suitability}


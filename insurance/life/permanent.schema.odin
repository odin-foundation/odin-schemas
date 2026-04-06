; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Permanent Life Insurance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Permanent life insurance extending the base life policy for cash value products
; including whole life, universal life, variable universal life, and indexed
; universal life with cash value, dividends, and loan provisions.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./policy.schema.odin" as life
@import "../common/life-annuity/types.schema.odin" as la

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.life.permanent"
version = "1.0.0"
title = "Permanent Life Insurance Schema"
description = "Permanent (cash value) life insurance extending base policy"

{$derivation}
source[0].authority = "NAIC"
source[0].citation = "Universal Life Insurance Model Regulation"
source[0].url = "https://content.naic.org/sites/default/files/model-law-585.pdf"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-15
changelog[0].change = "Initial permanent life insurance schema"
changelog[0].rationale = "Permanent life types with shared cash value fields"

; ═══════════════════════════════════════════════════════════════════════════════
; Permanent Life Policy Base
; ═══════════════════════════════════════════════════════════════════════════════

{@policy}
= @life.policy                                ; Inherit all base life policy fields

; ───────────────────────────────────────────────────────────────────────────────
; Cash Value
; ───────────────────────────────────────────────────────────────────────────────
{.cash_value}
account_value = #$:(0..)                      ; Current account/cash value
cash_surrender_value = #$:(0..)               ; Net cash surrender value
gross_cash_value = #$:(0..)                   ; Gross cash value before loans/charges
guaranteed_cash_value = #$:(0..)              ; Guaranteed cash value
net_cash_value = #$:(0..)                     ; Net cash value
projected_cash_value = #$:(0..)               ; Projected future value

{@policy}

; ───────────────────────────────────────────────────────────────────────────────
; Policy Loans
; ───────────────────────────────────────────────────────────────────────────────
loan_interest_rate = #                        ; Current loan interest rate
loans[] = @la.policy_loan                     ; Policy loan history
max_loan_amount = #$:(0..)                    ; Maximum available loan
total_loan_balance = #$:(0..)                 ; Total outstanding loans

; ───────────────────────────────────────────────────────────────────────────────
; Surrender Information
; ───────────────────────────────────────────────────────────────────────────────
surrender_schedule = @la.surrender_schedule   ; Surrender charge schedule
surrender_charge = #$:(0..)                   ; Current surrender charge

; ═══════════════════════════════════════════════════════════════════════════════
; Whole Life
; ═══════════════════════════════════════════════════════════════════════════════
; Traditional whole life with fixed premiums and guarantees

{@whole_life}
= @policy

; Whole life type
whole_life_type = !(limited_pay, ordinary, single_premium)  ; Whole life variant

; ───────────────────────────────────────────────────────────────────────────────
; Participation Status (Dividends)
; ───────────────────────────────────────────────────────────────────────────────
{.dividends}
accumulated_value = #$                        ; Accumulated dividend value
current_year_dividend = #$                    ; Current year dividend
dividend_history[] = @dividend_payment        ; Dividend payment history
eligible = ?                                  ; Participating policy
option = (accumulate, cash, paid_up_additions, premium_reduction, term_additions)  ; Dividend option

{@whole_life}

; ───────────────────────────────────────────────────────────────────────────────
; Paid-Up Additions
; ───────────────────────────────────────────────────────────────────────────────
{.paid_up_additions}
additional_death_benefit = #$                 ; Additional DB from PUAs
cash_value = #$                               ; Cash value in PUAs
total_pua_face = #$                           ; Total PUA face amount

{@whole_life}

; ───────────────────────────────────────────────────────────────────────────────
; Limited Pay Options
; ───────────────────────────────────────────────────────────────────────────────
{.limited_pay}
paid_up = ?                                   ; Policy is fully paid up
paid_up_age = ##:(50..100)                    ; Age policy becomes paid up
paid_up_date = date                           ; Date policy becomes paid up
pay_period_years = ##:(5..30)                 ; Number of years to pay premiums

{@whole_life}

{@dividend_payment}
amount = !#$                                  ; Dividend amount
date = !date                                  ; Payment date
disposition = (accumulated, cash, paid_up_addition, premium_reduction, term)  ; How dividend was used

; ═══════════════════════════════════════════════════════════════════════════════
; Universal Life Base
; ═══════════════════════════════════════════════════════════════════════════════
; Flexible premium universal life (base for UL, VUL, IUL)

{@universal_life}
= @policy

; UL product type discriminator
ul_type = !(indexed, traditional, variable)   ; Universal life variant

; ───────────────────────────────────────────────────────────────────────────────
; Flexible Premium
; ───────────────────────────────────────────────────────────────────────────────
{.flexible_premium}
guideline_annual_premium = #$                 ; Guideline annual premium (7-pay test)
guideline_single_premium = #$                 ; Guideline single premium
max_premium = #$                              ; Maximum allowed premium
min_premium = #$                              ; Minimum required premium
mec = ?                                       ; Modified Endowment Contract
mec_date = date                               ; Date became MEC
planned_premium = #$                          ; Planned periodic premium
target_premium = #$                           ; Target premium amount

{@universal_life}

; ───────────────────────────────────────────────────────────────────────────────
; Death Benefit Options
; ───────────────────────────────────────────────────────────────────────────────
{.db_option}
current_option = !(increasing, level)         ; Current death benefit option
changes_allowed = ?                           ; Can change DB option
option_change_date = date                     ; Date of last option change

{@universal_life}

; ───────────────────────────────────────────────────────────────────────────────
; Cost of Insurance
; ───────────────────────────────────────────────────────────────────────────────
{.coi}
current_monthly = #$                          ; Current monthly COI
guaranteed_rate = ?                           ; Using guaranteed COI rates
max_monthly = #$                              ; Maximum monthly COI
rate_class = :                                ; COI rate classification

{@universal_life}

; ───────────────────────────────────────────────────────────────────────────────
; Monthly Deductions
; ───────────────────────────────────────────────────────────────────────────────
{.deductions}
admin_charge = #$                             ; Monthly administrative charge
coi_charge = #$                               ; Cost of insurance
flat_extra = #$                               ; Flat extra charge
premium_load = #:(0..20)                      ; Premium load percentage
rider_charges = #$                            ; Total rider charges
surrender_charge = #$                         ; Monthly surrender charge
total_monthly = #$                            ; Total monthly deductions

{@universal_life}

; ───────────────────────────────────────────────────────────────────────────────
; Interest Crediting (Traditional UL)
; ───────────────────────────────────────────────────────────────────────────────
{.interest}
crediting_method = (declared, indexed, variable)  ; How interest is credited
current_rate = #                              ; Current credited rate
declared_rate = #                             ; Current declared rate
guaranteed_rate = #:(0..10)                   ; Guaranteed minimum rate
portfolio_rate = #                            ; Portfolio rate (if different)
rate_effective = date                         ; Date rate became effective

{@universal_life}

; ───────────────────────────────────────────────────────────────────────────────
; No-Lapse Guarantee
; ───────────────────────────────────────────────────────────────────────────────
{.no_lapse}
active = ?                                    ; No-lapse guarantee in force
age_limit = ##:(60..121)                      ; Age no-lapse expires
duration_years = ##:(1..50)                   ; Years of no-lapse guarantee
premium_required = #$                         ; Premium to keep guarantee active
shadow_account_value = #$                     ; Shadow account value

{@universal_life}

; ───────────────────────────────────────────────────────────────────────────────
; Policy Value Projections
; ───────────────────────────────────────────────────────────────────────────────
{.projections}
end_age = ##:(60..121)                        ; Projection end age
guaranteed_values[] = @projection_year        ; Guaranteed value projections
illustrated_values[] = @projection_year       ; Non-guaranteed projections
projection_rate = #:(0..15)                   ; Assumed interest rate

{@universal_life}

{@projection_year}
age = !##:(0..121)                            ; Attained age
year = !##:(1..)                              ; Policy year
cash_value = #$                               ; Projected cash value
death_benefit = #$                            ; Projected death benefit
premium = #$                                  ; Annual premium

; ═══════════════════════════════════════════════════════════════════════════════
; Indexed Universal Life (IUL)
; ═══════════════════════════════════════════════════════════════════════════════
; UL with interest tied to stock market index performance

{@indexed_universal_life}
= @universal_life

; Set UL type
ul_type = !(indexed)

; ───────────────────────────────────────────────────────────────────────────────
; Index Strategies
; ───────────────────────────────────────────────────────────────────────────────
strategies[] = @la.index_strategy             ; Available index strategies

{@indexed_universal_life}

; ═══════════════════════════════════════════════════════════════════════════════
; Variable Universal Life (VUL)
; ═══════════════════════════════════════════════════════════════════════════════
; UL with investment in separate account subaccounts

{@variable_universal_life}
= @universal_life

; Set UL type
ul_type = !(variable)

; ───────────────────────────────────────────────────────────────────────────────
; Separate Account
; ───────────────────────────────────────────────────────────────────────────────
{.separate_account}
total_value = #$                              ; Total separate account value
fixed_account_value = #$                      ; Value in fixed account
guaranteed_account_value = #$                 ; Value in guaranteed account
last_valuation = date                         ; Last valuation date

{@variable_universal_life}

; ───────────────────────────────────────────────────────────────────────────────
; Subaccount Holdings
; ───────────────────────────────────────────────────────────────────────────────
subaccounts[] = @la.subaccount                ; Investment subaccount holdings

; ───────────────────────────────────────────────────────────────────────────────
; Transfer Rules
; ───────────────────────────────────────────────────────────────────────────────
{.transfers}
free_transfers_remaining = ##:(0..20)         ; Free transfers remaining this year
free_transfers_per_year = ##:(0..20)          ; Free transfers allowed per year
last_transfer = date                          ; Date of last transfer
transfer_fee = #$                             ; Transfer fee after free transfers

{@variable_universal_life}

; ───────────────────────────────────────────────────────────────────────────────
; Dollar Cost Averaging
; ───────────────────────────────────────────────────────────────────────────────
{.dca}
active = ?                                    ; DCA active
amount = #$                                   ; Monthly DCA amount
frequency = (monthly, quarterly)              ; DCA frequency
from_account = :                              ; Source account
remaining_months = ##:(0..60)                 ; Months remaining
to_allocations[] = @dca_allocation            ; Target allocations

{@variable_universal_life}

{@dca_allocation}
subaccount = !:                               ; Target subaccount name
percent = !#:(0..100)                         ; Allocation percentage

; ───────────────────────────────────────────────────────────────────────────────
; Model Portfolios
; ───────────────────────────────────────────────────────────────────────────────
{.model_portfolio}
active = ?                                    ; Using model portfolio
name = :                                      ; Model portfolio name
rebalance_frequency = (annual, quarterly, semi_annual)  ; Rebalance frequency
risk_level = (aggressive, conservative, moderate, moderately_aggressive, moderately_conservative)  ; Risk profile

{@variable_universal_life}

; ═══════════════════════════════════════════════════════════════════════════════
; Additional Permanent Life Riders
; ═══════════════════════════════════════════════════════════════════════════════
; Riders specific to permanent life products

{@permanent_rider}
= @la.rider

permanent_rider_type = (enhanced_surrender, estate_protection, extended_no_lapse, flexible_death_benefit, overloan_protection, persistency_bonus, return_of_charges, secondary_guarantee)

; ───────────────────────────────────────────────────────────────────────────────
; Overloan Protection
; ───────────────────────────────────────────────────────────────────────────────
{.overloan}
active = ?                                    ; Overloan protection active
election_date = date                          ; Date elected
max_loan_percent = #:(0..100)                 ; Maximum loan percentage before trigger
triggered = ?                                 ; Protection has been triggered
trigger_date = date                           ; Date triggered

{@permanent_rider}

; ───────────────────────────────────────────────────────────────────────────────
; Secondary Guarantee (No-Lapse)
; ───────────────────────────────────────────────────────────────────────────────
{.secondary_guarantee}
active = ?                                    ; Secondary guarantee in force
guarantee_age = ##:(85..121)                  ; Age guarantee extends to
minimum_premium = #$                          ; Minimum premium for guarantee
shadow_account = #$                           ; Shadow account balance

{@permanent_rider}


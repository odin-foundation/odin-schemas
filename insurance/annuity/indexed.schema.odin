; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Fixed Indexed Annuity (FIA) Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Fixed Indexed Annuities (FIA) with interest linked to market index performance.
; Principal is guaranteed with upside potential tied to indices, subject to caps,
; participation rates, and spreads.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./contract.schema.odin" as annuity
@import "../common/life-annuity/types.schema.odin" as la

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.annuity.indexed"
version = "1.0.0"
title = "Fixed Indexed Annuity (FIA) Schema"
description = "Fixed indexed annuities with index-linked interest crediting"

{$derivation}
source[0].authority = "NAIC"
source[0].citation = "Suitability in Annuity Transactions Model Regulation"
source[0].url = "https://content.naic.org/sites/default/files/model-law-275.pdf"

source[1].authority = "NAIC"
source[1].citation = "Fixed Indexed Annuity Buyer's Guide"
source[1].url = "https://content.naic.org/sites/default/files/publication-anb-fia-lp.pdf"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-15
changelog[0].change = "Initial fixed indexed annuity (FIA) schema"
changelog[0].rationale = "Separated from fixed for cleaner organization"

; ═══════════════════════════════════════════════════════════════════════════════
; Fixed Indexed Annuity (FIA)
; ═══════════════════════════════════════════════════════════════════════════════
; Fixed annuity with interest linked to market index performance
; Principal protected with upside potential tied to index

{@indexed_annuity}
= @annuity.contract                           ; Inherit base contract fields

; Set product type
product_type = !(indexed)

; ───────────────────────────────────────────────────────────────────────────────
; Principal Protection
; ───────────────────────────────────────────────────────────────────────────────
{.guarantee}
guaranteed_minimum_rate = #                   ; Guaranteed minimum accumulation rate
guaranteed_minimum_value = #$:(0..)           ; Guaranteed minimum value
principal_protected = ?true                   ; Principal guaranteed

{@indexed_annuity}

; ───────────────────────────────────────────────────────────────────────────────
; Fixed Account (Declared Rate Bucket)
; ───────────────────────────────────────────────────────────────────────────────
{.fixed_account}
allocation_percent = #:(0..100)               ; Percentage in fixed account
balance = #$:(0..)                            ; Current fixed account balance
current_rate = #:(0..10)                      ; Current declared rate
guaranteed_rate = #                           ; Guaranteed floor rate

{@indexed_annuity}

; ───────────────────────────────────────────────────────────────────────────────
; Index Strategies
; ───────────────────────────────────────────────────────────────────────────────
strategies[] = @la.index_strategy             ; Available/elected strategies
total_indexed_value = #$:(0..)                ; Total in indexed strategies

; ───────────────────────────────────────────────────────────────────────────────
; Strategy Allocation
; ───────────────────────────────────────────────────────────────────────────────
{.allocation}
can_reallocate = ?                            ; Can change allocations
last_reallocation = date                      ; Date of last reallocation
next_reallocation_window = date               ; Next allocation change window
reallocation_frequency = (annual, contract_anniversary, monthly, quarterly)  ; When changes allowed

{@indexed_annuity}

; ═══════════════════════════════════════════════════════════════════════════════
; FIA Guaranteed Lifetime Withdrawal Benefit (GLWB)
; ═══════════════════════════════════════════════════════════════════════════════
; Most popular living benefit rider for FIAs

{@fia_glwb}
= @la.rider

; GLWB status
{.status}
activated = ?                                 ; GLWB withdrawals have started
activation_date = date                        ; Date withdrawals began
in_waiting_period = ?                         ; Still in waiting period
waiting_period_years = ##:(0..10)             ; Required waiting period

; Benefit base
{.benefit_base}
amount = #$:(0..)                             ; Current benefit base
annual_roll_up_percent = #:(0..10)            ; Annual simple roll-up rate
bonus_percent = #:(0..50)                     ; Bonus added to benefit base
guaranteed_roll_up_years = ##:(0..20)         ; Years roll-up is guaranteed
highest_anniversary = #$:(0..)                ; Highest anniversary value
initial_amount = #$:(0..)                     ; Initial benefit base
roll_up_type = (compound, simple)             ; Roll-up calculation method
step_up_frequency = (annual, none, quarterly) ; How often step-ups occur

{@fia_glwb}

; Withdrawal rates
{.withdrawal_rates}
current_rate = #                              ; Current withdrawal rate
joint_rate = #                                ; Joint life withdrawal rate
rate_at_activation = #                        ; Rate locked at activation
single_rate = #                               ; Single life withdrawal rate

{@fia_glwb}

; Annual amounts
{.amounts}
annual_withdrawal = #$:(0..)                  ; Annual withdrawal amount
lifetime_payments = #$:(0..)                  ; Total lifetime payments to date
max_annual = #$:(0..)                         ; Maximum annual withdrawal
remaining_this_year = #$:(0..)                ; Remaining withdrawal this year

{@fia_glwb}

; GLWB fees
{.fees}
annual_fee_bps = ##:(0..300)                  ; Annual fee in basis points
fee_basis = (benefit_base, contract_value)    ; What fee is charged against

{@fia_glwb}

; ═══════════════════════════════════════════════════════════════════════════════
; Income Rider (Guaranteed Minimum Income Benefit - GMIB)
; ═══════════════════════════════════════════════════════════════════════════════

{@fia_gmib}
= @la.rider

; GMIB status
{.status}
activated = ?                                 ; Annuitization has occurred
can_exercise = ?                              ; Eligible to exercise
exercise_deadline = date                      ; Latest date to exercise
waiting_period_years = ##:(5..15)             ; Required waiting period

; Benefit base
{.benefit_base}
amount = #$:(0..)                             ; Current benefit base
roll_up_percent = #:(0..10)                   ; Annual roll-up rate
roll_up_type = (compound, simple)             ; Roll-up calculation

; Annuitization options
{.annuitization}
estimated_monthly = #$:(0..)                  ; Estimated monthly income
payout_factor = #                             ; Payout factor per $1000
payout_option = (joint_survivor, life_only, period_certain, refund)  ; Available options

{@fia_gmib}

; ═══════════════════════════════════════════════════════════════════════════════
; Accumulation Rider (Guaranteed Minimum Accumulation Benefit - GMAB)
; ═══════════════════════════════════════════════════════════════════════════════

{@fia_gmab}
= @la.rider

; GMAB terms
{.terms}
guarantee_percent = #:(0..200)                ; Percentage of premium guaranteed
guarantee_period_years = ##:(5..20)           ; Guarantee period length
maturity_date = date                          ; Date guarantee matures

; GMAB values
{.values}
current_contract_value = #$:(0..)             ; Current contract value
guaranteed_amount = #$:(0..)                  ; Guaranteed minimum at maturity
shortfall = #$:(0..)                          ; Shortfall to be made up (if any)

{@fia_gmab}


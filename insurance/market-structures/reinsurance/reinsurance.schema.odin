; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Reinsurance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Reinsurance schema covering treaty and facultative reinsurance including quota
; share, surplus share, excess of loss, catastrophe XOL, aggregate stop loss,
; and retrocession arrangements.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../commercial/business.schema.odin" as entity
@import "../../coverages/coverage.schema.odin" as cov

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.market-structures.reinsurance"
version = "1.0.0"
title = "Reinsurance Schema"
description = "Comprehensive reinsurance schema for treaty, facultative, and retrocession arrangements"

{$derivation}
source[0].authority = "National Association of Insurance Commissioners (NAIC)"
source[0].citation = "Credit for Reinsurance Model Law (MDL-785)"
source[0].url = "https://content.naic.org/sites/default/files/model-law-785.pdf"

source[1].authority = "Reinsurance Association of America"
source[1].citation = "RAA Fundamentals of Reinsurance"
source[1].url = "https://web.archive.org/web/2024/https://www.reinsurance.org/"

source[2].authority = "State Insurance Regulations"
source[2].citation = "Various state reinsurance regulations and statutes"
source[2].url = "https://content.naic.org/state-insurance-departments"

source[3].authority = "International Association of Insurance Supervisors"
source[3].citation = "IAIS Reinsurance and Financial Stability"
source[3].url = "https://www.iaisweb.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Derived from NAIC model laws, state regulations, and published reinsurance industry guides"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial reinsurance schema"
changelog[0].rationale = "Comprehensive reinsurance structure for treaty, facultative, and retrocession"

; ═══════════════════════════════════════════════════════════════════════════════
; Ceding Company (Cedent)
; ═══════════════════════════════════════════════════════════════════════════════
; The primary insurer transferring risk to a reinsurer

{@ceding_company}
cedent_id = :                                     ; Unique identifier for cedent
legal_name = :                                    ; Legal entity name of cedent
naic_code = :(5..6)                               ; NAIC company code (5-6 digits)
domicile_state_province = :(2..3)                 ; State/province of domicile
domicile_country = :(2..3) "US"                   ; Country code (ISO 2-3 letter)

; ───────────────────────────────────────────────────────────────────────────────
; Financial Strength
; ───────────────────────────────────────────────────────────────────────────────
am_best_rating = :                                ; A.M. Best financial strength rating
am_best_financial_size = :                        ; A.M. Best financial size category
sp_rating = :                                     ; Standard & Poor's rating
moodys_rating = :                                 ; Moody's rating
fitch_rating = :                                  ; Fitch Ratings rating

; ───────────────────────────────────────────────────────────────────────────────
; Licensing
; ───────────────────────────────────────────────────────────────────────────────
licensed_states_provinces[] = :(2..3)             ; States/provinces where licensed
admitted_reinsurer = ?                            ; Whether admitted in cedent domicile

; ───────────────────────────────────────────────────────────────────────────────
; Contact Information
; ───────────────────────────────────────────────────────────────────────────────
contact_ref = :                               ; Contact reference

{@ceding_company}

; ═══════════════════════════════════════════════════════════════════════════════
; Reinsurer (Assuming Company)
; ═══════════════════════════════════════════════════════════════════════════════
; The company accepting risk from the ceding company

{@reinsurer}
reinsurer_id = :                                  ; Unique identifier for reinsurer
legal_name = :                                    ; Legal entity name of reinsurer
naic_code = :(5..6)                               ; NAIC company code (5-6 digits)
domicile_state_province = :(2..3)                 ; State/province of domicile
domicile_country = :(2..3)                        ; Country code (ISO 2-3 letter)

; ───────────────────────────────────────────────────────────────────────────────
; Reinsurer Type
; ───────────────────────────────────────────────────────────────────────────────
reinsurer_type = (
    admitted,                                 ; Licensed in cedent's domicile
    certified,                                ; NAIC certified reinsurer
    non_admitted,                             ; Not licensed, requires collateral
    reciprocal_jurisdiction                   ; Covered by reciprocal agreement
)

; ───────────────────────────────────────────────────────────────────────────────
; Financial Strength Ratings
; ───────────────────────────────────────────────────────────────────────────────
am_best_rating = :                                ; A.M. Best financial strength rating
am_best_financial_size = :                        ; A.M. Best financial size category
sp_rating = :                                     ; Standard & Poor's rating
moodys_rating = :                                 ; Moody's rating
fitch_rating = :                                  ; Fitch Ratings rating

; ───────────────────────────────────────────────────────────────────────────────
; Credit for Reinsurance
; ───────────────────────────────────────────────────────────────────────────────
credit_for_reinsurance_eligible = ?               ; Eligible for statutory credit
collateral_required = ?                           ; Whether collateral is required
collateral_percentage = #:(0..100):if collateral_required = true  ; Percentage of collateral required

; ───────────────────────────────────────────────────────────────────────────────
; Contact Information
; ───────────────────────────────────────────────────────────────────────────────
contact_ref = :                               ; Contact reference

{@reinsurer}

; ═══════════════════════════════════════════════════════════════════════════════
; Intermediary (Reinsurance Broker)
; ═══════════════════════════════════════════════════════════════════════════════
; Broker facilitating reinsurance placement

{@reinsurance_intermediary}
intermediary_id = :                               ; Unique identifier for intermediary
legal_name = :                                    ; Legal entity name of broker
license_number = *:                               ; Broker license number (confidential)
domicile_state_province = :(2..3)                 ; State/province of domicile
domicile_country = :(2..3) "US"                   ; Country code (ISO 2-3 letter)

; ───────────────────────────────────────────────────────────────────────────────
; Brokerage Information
; ───────────────────────────────────────────────────────────────────────────────
brokerage_percentage = #:(0..20)                  ; Brokerage fee percentage
brokerage_amount = #$:(0..)                       ; Brokerage fee amount
brokerage_basis = (ceded_premium, written_premium, earned_premium)  ; Premium basis for brokerage

; ───────────────────────────────────────────────────────────────────────────────
; Errors and Omissions
; ───────────────────────────────────────────────────────────────────────────────
{.eo_coverage}
carrier = :                                       ; E&O insurance carrier
policy_number = :                                 ; E&O policy number
limit = #$:(0..)                                  ; E&O coverage limit
effective_date = date                             ; E&O policy effective date
expiration_date = date                            ; E&O policy expiration date

{@reinsurance_intermediary}

; ═══════════════════════════════════════════════════════════════════════════════
; Quota Share Terms (Proportional)
; ═══════════════════════════════════════════════════════════════════════════════
; Fixed percentage cession of premium and losses

{@quota_share}
quota_share_id = :                                ; Unique identifier for quota share

; ───────────────────────────────────────────────────────────────────────────────
; Cession Percentage
; ───────────────────────────────────────────────────────────────────────────────
cession_percentage = #:(0..100)              ; % ceded to reinsurer
retention_percentage = #:(0..100)            ; % retained by cedent
:invariant cession_percentage + retention_percentage = 100

; ───────────────────────────────────────────────────────────────────────────────
; Subject Premium
; ───────────────────────────────────────────────────────────────────────────────
subject_premium_basis = (
    gross_net_written_premium,
    gross_written_premium,
    net_written_premium
)                                                 ; Basis for subject premium calculation
estimated_subject_premium = #$:(0..)              ; Estimated subject premium
minimum_premium = #$:(0..)                        ; Minimum premium due
deposit_premium = #$:(0..)                        ; Initial deposit premium

; ───────────────────────────────────────────────────────────────────────────────
; Per Risk/Per Occurrence Limits
; ───────────────────────────────────────────────────────────────────────────────
per_risk_limit = #$:(0..)                    ; Maximum per single risk
per_occurrence_limit = #$:(0..)              ; Maximum per occurrence
event_limit = #$:(0..)                       ; Maximum per event

; ───────────────────────────────────────────────────────────────────────────────
; Authorized Shares
; ───────────────────────────────────────────────────────────────────────────────
authorized_share_minimum = #:(0..100)        ; Minimum reinsurer share
authorized_share_maximum = #:(0..100)        ; Maximum reinsurer share

; ═══════════════════════════════════════════════════════════════════════════════
; Surplus Share Terms (Proportional)
; ═══════════════════════════════════════════════════════════════════════════════
; Variable percentage cession based on retention limit

{@surplus_share}
surplus_share_id = :                              ; Unique identifier for surplus share

; ───────────────────────────────────────────────────────────────────────────────
; Retention and Lines
; ───────────────────────────────────────────────────────────────────────────────
; Cedent's retention is "1 line"
retention = #$:(0..)                         ; Cedent's net retention per risk
line_count = ##:(1..)                             ; Number of lines in treaty

; Maximum cession = retention x line_count
maximum_cession = #$:(0..)                        ; Maximum cession amount
:invariant maximum_cession = retention * line_count

; ───────────────────────────────────────────────────────────────────────────────
; Surplus Treaty Capacity
; ───────────────────────────────────────────────────────────────────────────────
treaty_capacity = #$:(0..)                   ; Total treaty capacity
automatic_capacity = #$:(0..)                ; Automatic acceptance capacity
facultative_capacity = #$:(0..)              ; Additional fac capacity

; ───────────────────────────────────────────────────────────────────────────────
; Subject Premium
; ───────────────────────────────────────────────────────────────────────────────
estimated_subject_premium = #$:(0..)              ; Estimated subject premium
minimum_premium = #$:(0..)                        ; Minimum premium due
deposit_premium = #$:(0..)                        ; Initial deposit premium

; ═══════════════════════════════════════════════════════════════════════════════
; Excess of Loss Terms (Non-Proportional)
; ═══════════════════════════════════════════════════════════════════════════════
; Coverage for losses exceeding a specified retention

{@excess_of_loss}
xol_id = :                                        ; Unique identifier for XOL

; ───────────────────────────────────────────────────────────────────────────────
; XOL Type
; ───────────────────────────────────────────────────────────────────────────────
xol_type = (
    aggregate,
    per_occurrence,
    per_risk
)

; ───────────────────────────────────────────────────────────────────────────────
; Layer Structure
; ───────────────────────────────────────────────────────────────────────────────
; Expressed as "Limit XS Attachment" (e.g., $5M XS $5M)
limit = #$:(0..)                             ; Layer limit (coverage amount)
attachment_point = #$:(0..)                  ; Retention / deductible
exhaustion_point = #$:(0..)                  ; Limit + attachment
:invariant exhaustion_point = limit + attachment_point

; Layer position in program
layer_number = ##:(1..)                           ; Layer number in reinsurance program
layer_description = :                             ; Description of layer coverage

; ───────────────────────────────────────────────────────────────────────────────
; Aggregate Annual Limit
; ───────────────────────────────────────────────────────────────────────────────
annual_aggregate_limit = #$:(0..)            ; Maximum payout per treaty year
annual_aggregate_deductible = #$:(0..)       ; Annual aggregate retention

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
rate_on_line = #:(0..100)                    ; Premium as % of limit
minimum_premium = #$:(0..)                        ; Minimum premium due
deposit_premium = #$:(0..)                        ; Initial deposit premium
flat_premium = #$:(0..)                      ; Fixed premium amount
adjustable_premium = ?                       ; Subject to adjustment

; Subject Premium (for rate-on-line calculation)
subject_premium = #$:(0..)                        ; Subject premium for calculation
rate_on_subject = #:(0..100)                 ; Premium as % of subject

; ───────────────────────────────────────────────────────────────────────────────
; Aggregate XL Specific (Stop Loss)
; ───────────────────────────────────────────────────────────────────────────────
; Expressed as percentage of premium or absolute amounts
loss_ratio_attachment = #:(0..500):if xol_type = aggregate  ; % loss ratio trigger
loss_ratio_limit = #:(0..500):if xol_type = aggregate       ; % loss ratio cap

; ═══════════════════════════════════════════════════════════════════════════════
; Catastrophe Excess of Loss (Cat XL)
; ═══════════════════════════════════════════════════════════════════════════════
; Per-occurrence excess of loss for catastrophic events

{@cat_xl}
cat_xl_id = :                                     ; Unique identifier for cat XL

; ───────────────────────────────────────────────────────────────────────────────
; Perils Covered
; ───────────────────────────────────────────────────────────────────────────────
perils_covered[] = (
    all_natural_perils,
    earthquake,
    flood,
    hurricane,
    named_storm,
    severe_convective_storm,
    terrorism,
    wildfire,
    winter_storm
)

; ───────────────────────────────────────────────────────────────────────────────
; Layer Structure
; ───────────────────────────────────────────────────────────────────────────────
limit = #$:(0..)                                  ; Layer limit (coverage amount)
attachment_point = #$:(0..)                       ; Retention / deductible
exhaustion_point = #$:(0..)                       ; Limit + attachment
:invariant exhaustion_point = limit + attachment_point

layer_number = ##:(1..)                           ; Layer number in reinsurance program
layer_description = :                             ; Description of layer coverage

; ───────────────────────────────────────────────────────────────────────────────
; Hours Clause
; ───────────────────────────────────────────────────────────────────────────────
; Defines duration for aggregating losses into single occurrence
hours_clause = ##:(0..504)                   ; Standard: 72-168 hours
hours_clause_type = (
    fixed,                                   ; Fixed window
    floating                                 ; Cedent selects optimal window
)

; ───────────────────────────────────────────────────────────────────────────────
; Event Definition
; ───────────────────────────────────────────────────────────────────────────────
event_definition = (
    each_occurrence,
    per_168_hour_period,
    per_72_hour_period,
    per_earthquake_shock,
    per_named_storm
)

; ───────────────────────────────────────────────────────────────────────────────
; Reinstatements
; ───────────────────────────────────────────────────────────────────────────────
reinstatements = @reinstatement                   ; Reinstatement provisions

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
rate_on_line = #:(0..100)                         ; Premium as % of limit
deposit_premium = #$:(0..)                        ; Initial deposit premium
minimum_premium = #$:(0..)                        ; Minimum premium due
adjustable = ?                                    ; Subject to adjustment

; ═══════════════════════════════════════════════════════════════════════════════
; Clash Cover
; ═══════════════════════════════════════════════════════════════════════════════
; Coverage for multiple insureds/policies affected by single occurrence

{@clash_cover}
clash_cover_id = :                                ; Unique identifier for clash cover

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Scope
; ───────────────────────────────────────────────────────────────────────────────
; Clash deductible exceeds any single policy limit
minimum_clash_policies = ##:(2..)                 ; Minimum policies to trigger clash

; ───────────────────────────────────────────────────────────────────────────────
; Layer Structure
; ───────────────────────────────────────────────────────────────────────────────
limit = #$:(0..)                                  ; Layer limit (coverage amount)
attachment_point = #$:(0..)                       ; Retention / deductible
exhaustion_point = #$:(0..)                       ; Limit + attachment
:invariant exhaustion_point = limit + attachment_point

; ───────────────────────────────────────────────────────────────────────────────
; Lines of Business Covered
; ───────────────────────────────────────────────────────────────────────────────
covered_lines[] = :                               ; Lines of business covered

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
rate_on_line = #:(0..100)                         ; Premium as % of limit
flat_premium = #$:(0..)                           ; Fixed premium amount

; ═══════════════════════════════════════════════════════════════════════════════
; Reinstatement Provisions
; ═══════════════════════════════════════════════════════════════════════════════
; Restoration of coverage limit after a loss payment

{@reinstatement}
reinstatement_id = :                              ; Unique identifier for reinstatement

; ───────────────────────────────────────────────────────────────────────────────
; Reinstatement Terms
; ───────────────────────────────────────────────────────────────────────────────
reinstatement_count = ##:(0..)                    ; Number of reinstatements allowed
reinstatement_type = (
    automatic,                               ; Reinstates without cedent action
    conditional,                             ; Requires notice/acceptance
    unlimited                                ; Unlimited reinstatements
)

; ───────────────────────────────────────────────────────────────────────────────
; Reinstatement Premium
; ───────────────────────────────────────────────────────────────────────────────
reinstatement_premium_type = (
    additional_premium,                      ; Additional premium required
    free,                                    ; No additional premium
    pro_rata                                 ; Pro-rata as to amount and time
)

; Pro-rata calculation basis
pro_rata_amount = ?:if reinstatement_premium_type = pro_rata  ; % of loss
pro_rata_time = ?:if reinstatement_premium_type = pro_rata    ; % of time remaining

; Reinstatement premium as percentage of original
reinstatement_percentage = #:(0..):if reinstatement_premium_type = additional_premium

; ───────────────────────────────────────────────────────────────────────────────
; Reinstatement Hours
; ───────────────────────────────────────────────────────────────────────────────
; Waiting period before reinstatement effective
reinstatement_waiting_hours = ##:(0..168)         ; Hours before reinstatement effective

; ═══════════════════════════════════════════════════════════════════════════════
; Ceding Commission
; ═══════════════════════════════════════════════════════════════════════════════
; Commission paid by reinsurer to cedent

{@ceding_commission}
commission_id = :                                 ; Unique identifier for commission

; ───────────────────────────────────────────────────────────────────────────────
; Commission Type
; ───────────────────────────────────────────────────────────────────────────────
commission_type = (
    flat,                                    ; Fixed percentage
    profit,                                  ; Based on profitability
    sliding_scale                            ; Varies with loss ratio
)

; ───────────────────────────────────────────────────────────────────────────────
; Flat Commission
; ───────────────────────────────────────────────────────────────────────────────
flat_percentage = #:(0..50):if commission_type = flat

; ───────────────────────────────────────────────────────────────────────────────
; Sliding Scale Commission
; ───────────────────────────────────────────────────────────────────────────────
; Commission varies inversely with loss ratio
provisional_commission = #:(0..50):if commission_type = sliding_scale
minimum_commission = #:(0..50):if commission_type = sliding_scale
maximum_commission = #:(0..50):if commission_type = sliding_scale

; Loss ratio scale
loss_ratio_for_minimum = #:(0..):if commission_type = sliding_scale
loss_ratio_for_maximum = #:(0..):if commission_type = sliding_scale

; Slide factor (commission change per LR point)
slide_factor = #:(0..5):if commission_type = sliding_scale

; ───────────────────────────────────────────────────────────────────────────────
; Profit Commission
; ───────────────────────────────────────────────────────────────────────────────
profit_commission_percentage = #:(0..100):if commission_type = profit  ; % of profit to cedent

; Profit calculation deductions
{.profit_calculation}
loss_ratio_cap = #:(0..):if commission_type = profit
expense_allowance = #:(0..50):if commission_type = profit     ; % expense deduction
reinsurer_margin = #:(0..50):if commission_type = profit      ; Reinsurer's margin
deficit_carryforward = ?:if commission_type = profit          ; Carry deficits forward
carryforward_years = ##:(0..):if deficit_carryforward = true

{@ceding_commission}

; ═══════════════════════════════════════════════════════════════════════════════
; Loss Corridor
; ═══════════════════════════════════════════════════════════════════════════════
; Cedent participation in losses within defined corridor

{@loss_corridor}
corridor_id = :                                   ; Unique identifier for corridor

; ───────────────────────────────────────────────────────────────────────────────
; Corridor Definition
; ───────────────────────────────────────────────────────────────────────────────
; Cedent pays additional % of losses in corridor
corridor_attachment = #:(0..)                     ; Corridor attachment point (%)
corridor_exhaustion = #:(0..)                     ; Corridor exhaustion point (%)
cedent_participation = #:(0..100)            ; Cedent's % in corridor

; ───────────────────────────────────────────────────────────────────────────────
; Expressed as Dollar Amounts
; ───────────────────────────────────────────────────────────────────────────────
corridor_attachment_amount = #$:(0..)             ; Corridor attachment (dollar amount)
corridor_exhaustion_amount = #$:(0..)             ; Corridor exhaustion (dollar amount)
cedent_participation_amount = #$:(0..)            ; Cedent participation (dollar amount)

; ═══════════════════════════════════════════════════════════════════════════════
; Funds Withheld Arrangement
; ═══════════════════════════════════════════════════════════════════════════════
; Cedent retains premium as security for reinsurer obligations

{@funds_withheld}
funds_withheld_id = :                             ; Unique identifier for funds withheld

; ───────────────────────────────────────────────────────────────────────────────
; Funds Withheld Terms
; ───────────────────────────────────────────────────────────────────────────────
funds_withheld_percentage = #:(0..100)       ; % of premium withheld
initial_funds_withheld = #$:(0..)                 ; Initial funds withheld amount
current_balance = #$:(0..)                        ; Current balance in account

; ───────────────────────────────────────────────────────────────────────────────
; Interest Crediting
; ───────────────────────────────────────────────────────────────────────────────
interest_crediting_rate = #:(0..20)          ; % annual interest
interest_basis = (
    fixed_rate,
    libor_plus,
    prime_plus,
    sofr_plus,
    treasury_plus
)                                                 ; Basis for interest calculation
spread_basis_points = ##:(0..):if interest_basis != fixed_rate  ; Spread over index (bps)

; ───────────────────────────────────────────────────────────────────────────────
; Release Schedule
; ───────────────────────────────────────────────────────────────────────────────
release_schedule = (
    claims_settled,                          ; Release as claims settle
    contract_termination,                    ; Release at termination
    periodic                                 ; Periodic releases
)                                                 ; Release schedule type
periodic_release_frequency = (monthly, quarterly, annually):if release_schedule = periodic  ; Frequency of releases

; ═══════════════════════════════════════════════════════════════════════════════
; Collateral Requirements
; ═══════════════════════════════════════════════════════════════════════════════
; Security required for credit for reinsurance

{@reinsurance_collateral}
collateral_id = :                                 ; Unique identifier for collateral

; ───────────────────────────────────────────────────────────────────────────────
; Collateral Type
; ───────────────────────────────────────────────────────────────────────────────
collateral_type = (
    clean_irrevocable_loc,                   ; Letter of credit
    funds_withheld,
    multibeneficiary_trust,
    regulation_114_trust,
    single_beneficiary_trust
)

; ───────────────────────────────────────────────────────────────────────────────
; Collateral Amount
; ───────────────────────────────────────────────────────────────────────────────
collateral_percentage = #:(0..100)           ; % of liabilities
collateral_amount = #$:(0..)                      ; Collateral amount provided
minimum_collateral = #$:(0..)                     ; Minimum collateral required

; ───────────────────────────────────────────────────────────────────────────────
; Trust Information
; ───────────────────────────────────────────────────────────────────────────────
{.trust}
trustee_name = ::if collateral_type = regulation_114_trust  ; Trustee for Reg 114 trust
trustee_name = ::if collateral_type = single_beneficiary_trust  ; Trustee for single beneficiary trust
trustee_name = ::if collateral_type = multibeneficiary_trust  ; Trustee for multibeneficiary trust
trust_agreement_date = date                       ; Date of trust agreement
trust_account_number = *:                         ; Trust account number (confidential)

{@reinsurance_collateral}

; ───────────────────────────────────────────────────────────────────────────────
; Letter of Credit Information
; ───────────────────────────────────────────────────────────────────────────────
{.loc}
issuing_bank = ::if collateral_type = clean_irrevocable_loc  ; Bank issuing LOC
loc_number = ::if collateral_type = clean_irrevocable_loc  ; Letter of credit number
loc_amount = #$:(0..):if collateral_type = clean_irrevocable_loc  ; LOC amount
issue_date = date:if collateral_type = clean_irrevocable_loc  ; LOC issue date
expiration_date = date:if collateral_type = clean_irrevocable_loc  ; LOC expiration date
evergreen = ?:if collateral_type = clean_irrevocable_loc  ; Whether LOC auto-renews

{@reinsurance_collateral}

; ═══════════════════════════════════════════════════════════════════════════════
; Cut-Through Clause
; ═══════════════════════════════════════════════════════════════════════════════
; Direct payment to insured/claimant upon cedent insolvency

{@cut_through}
cut_through_id = :                                ; Unique identifier for cut-through

; ───────────────────────────────────────────────────────────────────────────────
; Cut-Through Terms
; ───────────────────────────────────────────────────────────────────────────────
enabled = ?                                       ; Whether cut-through is enabled
trigger_event = (
    cedent_default,
    cedent_insolvency,
    liquidation_order,
    rehabilitation_order
)                                                 ; Event triggering cut-through

; ───────────────────────────────────────────────────────────────────────────────
; Beneficiary
; ───────────────────────────────────────────────────────────────────────────────
beneficiary_name = ::if enabled = true
beneficiary_type = (
    insured,
    loss_payee,
    mortgagee,
    policyholder
):if enabled = true

; ═══════════════════════════════════════════════════════════════════════════════
; Follow-the-Fortunes / Follow-the-Settlements
; ═══════════════════════════════════════════════════════════════════════════════
; Reinsurer bound by cedent's claims decisions

{@follow_provisions}
provisions_id = :                                 ; Unique identifier for provisions

; ───────────────────────────────────────────────────────────────────────────────
; Follow-the-Fortunes Clause
; ───────────────────────────────────────────────────────────────────────────────
; Reinsurer follows cedent's underwriting decisions
follow_the_fortunes = ?                           ; Whether follow-fortunes applies
ftf_scope = (
    broad,                                   ; All underwriting decisions
    limited                                  ; Specified decisions only
):if follow_the_fortunes = true               ; Scope of follow-fortunes

; ───────────────────────────────────────────────────────────────────────────────
; Follow-the-Settlements Clause
; ───────────────────────────────────────────────────────────────────────────────
; Reinsurer bound by cedent's claims settlements
follow_the_settlements = ?                        ; Whether follow-settlements applies
fts_scope = (
    broad,                                   ; All settlement decisions
    limited                                  ; Specified decisions only
):if follow_the_settlements = true            ; Scope of follow-settlements

; ───────────────────────────────────────────────────────────────────────────────
; Exceptions
; ───────────────────────────────────────────────────────────────────────────────
; Conditions that override follow clauses
exceptions[] = (
    bad_faith,
    collusion,
    fraud,
    no_coverage_in_underlying,
    outside_treaty_scope
)                                                 ; Exceptions to follow clauses

; ═══════════════════════════════════════════════════════════════════════════════
; Premium Bordereau
; ═══════════════════════════════════════════════════════════════════════════════
; Detailed premium reporting

{@premium_bordereau}
bordereau_id = :                                  ; Unique identifier for bordereau

; ───────────────────────────────────────────────────────────────────────────────
; Reporting Period
; ───────────────────────────────────────────────────────────────────────────────
reporting_period_start = date                     ; Start of reporting period
reporting_period_end = date                       ; End of reporting period
submission_date = date                            ; Date bordereau submitted
due_date = date                                   ; Due date for bordereau

; ───────────────────────────────────────────────────────────────────────────────
; Reporting Frequency
; ───────────────────────────────────────────────────────────────────────────────
frequency = (
    annually,
    monthly,
    quarterly,
    semi_annually
)                                                 ; Frequency of bordereau reporting

; ───────────────────────────────────────────────────────────────────────────────
; Premium Summary
; ───────────────────────────────────────────────────────────────────────────────
gross_written_premium = #$:(0..)                  ; Gross written premium
gross_earned_premium = #$:(0..)                   ; Gross earned premium
ceded_written_premium = #$:(0..)                  ; Ceded written premium
ceded_earned_premium = #$:(0..)                   ; Ceded earned premium
ceding_commission = #$:(0..)                      ; Ceding commission amount
net_premium_due = #$:(0..)                        ; Net premium due to reinsurer

; ───────────────────────────────────────────────────────────────────────────────
; Premium Detail Records
; ───────────────────────────────────────────────────────────────────────────────
{.records[]}
policy_number = :                                 ; Policy number
insured_name = :                                  ; Name of insured
effective_date = date                             ; Policy effective date
expiration_date = date                            ; Policy expiration date
policy_limit = #$:(0..)                           ; Policy limit
gross_premium = #$:(0..)                          ; Gross premium
cession_percentage = #:(0..100)                   ; Cession percentage
ceded_premium = #$:(0..)                          ; Ceded premium amount
transaction_type = (
    cancellation,
    endorsement,
    new_business,
    reinstatement,
    renewal
)                                                 ; Type of transaction
transaction_date = date                           ; Transaction date

{@premium_bordereau}

; ═══════════════════════════════════════════════════════════════════════════════
; Loss Bordereau
; ═══════════════════════════════════════════════════════════════════════════════
; Detailed loss reporting

{@loss_bordereau}
bordereau_id = :                                  ; Unique identifier for bordereau

; ───────────────────────────────────────────────────────────────────────────────
; Reporting Period
; ───────────────────────────────────────────────────────────────────────────────
reporting_period_start = date                     ; Start of reporting period
reporting_period_end = date                       ; End of reporting period
submission_date = date                            ; Date bordereau submitted
valuation_date = date                             ; Valuation date for losses

; ───────────────────────────────────────────────────────────────────────────────
; Loss Summary
; ───────────────────────────────────────────────────────────────────────────────
gross_paid_losses = #$:(0..)                      ; Gross paid losses
gross_outstanding_losses = #$:(0..)               ; Gross outstanding reserves
gross_incurred_losses = #$:(0..)                  ; Gross incurred losses
ceded_paid_losses = #$:(0..)                      ; Ceded paid losses
ceded_outstanding_losses = #$:(0..)               ; Ceded outstanding reserves
ceded_incurred_losses = #$:(0..)                  ; Ceded incurred losses

; ───────────────────────────────────────────────────────────────────────────────
; ALAE / LAE
; ───────────────────────────────────────────────────────────────────────────────
gross_paid_alae = #$:(0..)                   ; Allocated Loss Adjustment Expense
gross_outstanding_alae = #$:(0..)                 ; Gross outstanding ALAE
ceded_paid_alae = #$:(0..)                        ; Ceded paid ALAE
ceded_outstanding_alae = #$:(0..)                 ; Ceded outstanding ALAE

; ───────────────────────────────────────────────────────────────────────────────
; Loss Detail Records
; ───────────────────────────────────────────────────────────────────────────────
{.records[]}
claim_number = :                                  ; Claim number
policy_number = :                                 ; Policy number
insured_name = :                                  ; Name of insured
claimant_name = :                                 ; Name of claimant
date_of_loss = date                               ; Date of loss
date_reported = date                              ; Date loss reported
description = :                                   ; Loss description
gross_paid = #$:(0..)                             ; Gross paid amount
gross_outstanding = #$:(0..)                      ; Gross outstanding reserves
gross_incurred = #$:(0..)                         ; Gross incurred amount
ceded_paid = #$:(0..)                             ; Ceded paid amount
ceded_outstanding = #$:(0..)                      ; Ceded outstanding reserves
ceded_incurred = #$:(0..)                         ; Ceded incurred amount
status = (
    closed_with_payment,
    closed_without_payment,
    open,
    reopened
)                                                 ; Claim status

{@loss_bordereau}

; ═══════════════════════════════════════════════════════════════════════════════
; Reinsurance Claim
; ═══════════════════════════════════════════════════════════════════════════════
; Individual claim cession

{@reinsurance_claim}
id = :                                            ; Unique identifier for claim
treaty_id = :                                     ; Treaty identifier
certificate_number = :                            ; Certificate number (if facultative)

; ───────────────────────────────────────────────────────────────────────────────
; Underlying Claim
; ───────────────────────────────────────────────────────────────────────────────
underlying_policy_number = :                      ; Underlying policy number
underlying_claim_number = :                       ; Underlying claim number
insured_name = :                                  ; Name of insured
claimant_name = :                                 ; Name of claimant
date_of_loss = date                               ; Date of loss
date_reported_to_cedent = date                    ; Date reported to cedent
date_reported_to_reinsurer = date                 ; Date reported to reinsurer

; ───────────────────────────────────────────────────────────────────────────────
; Loss Description
; ───────────────────────────────────────────────────────────────────────────────
loss_description = :                              ; Description of loss
cause_of_loss = :                                 ; Cause of loss
coverage_triggered = :                            ; Coverage triggered

; ───────────────────────────────────────────────────────────────────────────────
; Gross Loss (Cedent's Full Exposure)
; ───────────────────────────────────────────────────────────────────────────────
{.gross}
paid_indemnity = #$:(0..)                         ; Gross paid indemnity
paid_expense = #$:(0..)                           ; Gross paid expense
outstanding_indemnity = #$:(0..)                  ; Gross outstanding indemnity reserves
outstanding_expense = #$:(0..)                    ; Gross outstanding expense reserves
incurred_indemnity = #$:(0..)                     ; Gross incurred indemnity
incurred_expense = #$:(0..)                       ; Gross incurred expense
total_incurred = #$:(0..)                         ; Total gross incurred

{@reinsurance_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Ceded Loss (Reinsurer's Share)
; ───────────────────────────────────────────────────────────────────────────────
{.ceded}
paid_indemnity = #$:(0..)                         ; Ceded paid indemnity
paid_expense = #$:(0..)                           ; Ceded paid expense
outstanding_indemnity = #$:(0..)                  ; Ceded outstanding indemnity reserves
outstanding_expense = #$:(0..)                    ; Ceded outstanding expense reserves
incurred_indemnity = #$:(0..)                     ; Ceded incurred indemnity
incurred_expense = #$:(0..)                       ; Ceded incurred expense
total_incurred = #$:(0..)                         ; Total ceded incurred

; Cession Calculation
cession_percentage = #:(0..100)              ; For proportional
attachment_point = #$:(0..)                  ; For XOL
layer_limit = #$:(0..)                       ; For XOL
layer_exhausted = ?                               ; Whether layer limit exhausted

{@reinsurance_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (
    closed_with_payment,
    closed_without_payment,
    in_litigation,
    open,
    reopened
)                                                 ; Claim status
status_date = date                                ; Date of status

; ───────────────────────────────────────────────────────────────────────────────
; Payment History
; ───────────────────────────────────────────────────────────────────────────────
{.payments[]}
payment_date = date                               ; Date of payment
payment_type = (cash_call, claim_payment, expense, partial_recovery)  ; Type of payment
amount = #$:(0..)                                 ; Payment amount
reference_number = :                              ; Payment reference number

{@reinsurance_claim}

; ═══════════════════════════════════════════════════════════════════════════════
; Facultative Certificate
; ═══════════════════════════════════════════════════════════════════════════════
; Individual risk reinsurance placement

{@facultative_certificate}
certificate_id = :                                ; Unique identifier for certificate
certificate_number = :                            ; Certificate number

; ───────────────────────────────────────────────────────────────────────────────
; Parties
; ───────────────────────────────────────────────────────────────────────────────
cedent = @ceding_company                          ; Ceding company reference
reinsurer = @reinsurer                            ; Reinsurer reference
intermediary = @reinsurance_intermediary          ; Intermediary reference

; ───────────────────────────────────────────────────────────────────────────────
; Underlying Policy
; ───────────────────────────────────────────────────────────────────────────────
underlying_policy_number = :                      ; Underlying policy number
insured_name = :                                  ; Name of insured
risk_location = :                                 ; Location of risk
line_of_business = :                              ; Line of business
coverage_description = :                          ; Description of coverage

; ───────────────────────────────────────────────────────────────────────────────
; Term
; ───────────────────────────────────────────────────────────────────────────────
effective_date = date                             ; Certificate effective date
expiration_date = date                            ; Certificate expiration date
:invariant expiration_date > effective_date

; ───────────────────────────────────────────────────────────────────────────────
; Cession Type
; ───────────────────────────────────────────────────────────────────────────────
cession_type = (
    excess_of_loss,
    proportional
)                                                 ; Type of cession

; ───────────────────────────────────────────────────────────────────────────────
; Proportional Terms
; ───────────────────────────────────────────────────────────────────────────────
{.proportional}
cession_percentage = #:(0..100):if cession_type = proportional  ; Cession percentage
gross_limit = #$:(0..):if cession_type = proportional  ; Gross policy limit
ceded_limit = #$:(0..):if cession_type = proportional  ; Ceded limit
cedent_retention = #$:(0..):if cession_type = proportional  ; Cedent's retention
gross_premium = #$:(0..):if cession_type = proportional  ; Gross premium
ceded_premium = #$:(0..):if cession_type = proportional  ; Ceded premium
ceding_commission_percentage = #:(0..50):if cession_type = proportional  ; Ceding commission %
ceding_commission_amount = #$:(0..):if cession_type = proportional  ; Ceding commission amount

{@facultative_certificate}

; ───────────────────────────────────────────────────────────────────────────────
; Excess of Loss Terms
; ───────────────────────────────────────────────────────────────────────────────
{.xol}
limit = #$:(0..):if cession_type = excess_of_loss  ; XOL layer limit
attachment = #$:(0..):if cession_type = excess_of_loss  ; XOL attachment point
premium = #$:(0..):if cession_type = excess_of_loss  ; XOL premium
rate_on_line = #:(0..100):if cession_type = excess_of_loss  ; Rate on line

{@facultative_certificate}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (
    bound,
    cancelled,
    declined,
    expired,
    pending,
    quoted
)                                                 ; Certificate status

; ═══════════════════════════════════════════════════════════════════════════════
; Reinsurance Treaty (Master Contract)
; ═══════════════════════════════════════════════════════════════════════════════
; Automatic reinsurance agreement for defined book of business

{@reinsurance_treaty}
treaty_id = :                                     ; Unique identifier for treaty
treaty_number = :                                 ; Treaty number
treaty_name = :                                   ; Treaty name

; ───────────────────────────────────────────────────────────────────────────────
; Parties
; ───────────────────────────────────────────────────────────────────────────────
cedent = @ceding_company                          ; Ceding company reference
lead_reinsurer = @reinsurer                       ; Lead reinsurer reference
intermediary = @reinsurance_intermediary          ; Intermediary reference

; Participating Reinsurers
{.participants[]}
reinsurer = @reinsurer                            ; Participating reinsurer reference
participation_percentage = #:(0..100)             ; Reinsurer's participation %
signed_line = #:(0..100)                          ; Signed line percentage
written_line = #:(0..100)                         ; Written line percentage

{@reinsurance_treaty}

; ───────────────────────────────────────────────────────────────────────────────
; Treaty Term
; ───────────────────────────────────────────────────────────────────────────────
effective_date = date                             ; Treaty effective date
expiration_date = date                            ; Treaty expiration date
:invariant expiration_date > effective_date

; Treaty Type
treaty_type = (
    continuous,                              ; Evergreen
    multi_year,
    single_year
)                                                 ; Type of treaty
continuous_until_cancelled = ?:if treaty_type = continuous  ; Whether continuous
cancellation_notice_days = ##:(30..):if treaty_type = continuous  ; Days notice for cancellation
contract_years = ##:(1..):if treaty_type = multi_year  ; Number of contract years

; ───────────────────────────────────────────────────────────────────────────────
; Treaty Structure
; ───────────────────────────────────────────────────────────────────────────────
treaty_structure = (
    aggregate_xl,
    cat_xl,
    clash_cover,
    per_occurrence_xl,
    per_risk_xl,
    quota_share,
    surplus_share
)                                                 ; Type of treaty structure

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Scope
; ───────────────────────────────────────────────────────────────────────────────
covered_lines[] = :                               ; Lines of business covered
covered_territory[] = :(2..3)                     ; Territories covered
excluded_perils[] = :                             ; Excluded perils
excluded_classes[] = :                            ; Excluded classes

; ───────────────────────────────────────────────────────────────────────────────
; Treaty Terms - Proportional
; ───────────────────────────────────────────────────────────────────────────────
quota_share = @quota_share:if treaty_structure = quota_share  ; Quota share terms
surplus_share = @surplus_share:if treaty_structure = surplus_share  ; Surplus share terms

; ───────────────────────────────────────────────────────────────────────────────
; Treaty Terms - Non-Proportional
; ───────────────────────────────────────────────────────────────────────────────
excess_of_loss = @excess_of_loss:if treaty_structure = per_risk_xl  ; Per risk XL terms
excess_of_loss = @excess_of_loss:if treaty_structure = per_occurrence_xl  ; Per occurrence XL terms
excess_of_loss = @excess_of_loss:if treaty_structure = aggregate_xl  ; Aggregate XL terms
cat_xl = @cat_xl:if treaty_structure = cat_xl    ; Cat XL terms
clash_cover = @clash_cover:if treaty_structure = clash_cover  ; Clash cover terms

; ───────────────────────────────────────────────────────────────────────────────
; Commission
; ───────────────────────────────────────────────────────────────────────────────
ceding_commission = @ceding_commission            ; Ceding commission structure

; ───────────────────────────────────────────────────────────────────────────────
; Loss Provisions
; ───────────────────────────────────────────────────────────────────────────────
loss_corridor = @loss_corridor                    ; Loss corridor provisions
follow_provisions = @follow_provisions            ; Follow-the-fortunes/settlements

; ───────────────────────────────────────────────────────────────────────────────
; Security
; ───────────────────────────────────────────────────────────────────────────────
funds_withheld = @funds_withheld                  ; Funds withheld arrangement
collateral = @reinsurance_collateral              ; Collateral requirements
cut_through = @cut_through                        ; Cut-through provisions

; ───────────────────────────────────────────────────────────────────────────────
; Reporting
; ───────────────────────────────────────────────────────────────────────────────
{.reporting}
premium_reporting_frequency = (monthly, quarterly, annually)  ; Premium reporting frequency
loss_reporting_frequency = (monthly, quarterly, annually)  ; Loss reporting frequency
premium_due_days = ##:(0..90)                ; Days after period end
account_statement_required = ?                    ; Whether account statement required
bordereau_format = (electronic, manual)           ; Format of bordereau

{@reinsurance_treaty}

; ───────────────────────────────────────────────────────────────────────────────
; Special Clauses
; ───────────────────────────────────────────────────────────────────────────────
{.clauses}
sunset_clause = ?                                 ; Whether sunset clause applies
sunset_months = ##:(12..):if sunset_clause = true  ; Months after expiration
commutation_clause = ?                            ; Whether commutation allowed
arbitration_clause = ?                            ; Whether arbitration required
arbitration_location = ::if arbitration_clause = true  ; Location for arbitration
governing_law = :                                 ; Governing law jurisdiction
service_of_suit = ?                               ; Whether service of suit included
errors_and_omissions = ?                          ; Whether E&O clause included
insolvency_clause = ?                             ; Whether insolvency clause included
intermediary_clause = ?                           ; Whether intermediary clause included
offset_clause = ?                                 ; Whether offset allowed
currency_clause = ?                               ; Whether currency clause included
currency = :(3) "USD"                             ; Treaty currency

{@reinsurance_treaty}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (
    active,
    cancelled,
    commuted,
    expired,
    in_negotiation,
    run_off
)                                                 ; Treaty status

; ═══════════════════════════════════════════════════════════════════════════════
; Retrocession Agreement
; ═══════════════════════════════════════════════════════════════════════════════
; Reinsurance of reinsurance

{@retrocession}
retro_id = :                                      ; Unique identifier for retrocession
retro_number = :                                  ; Retrocession number
retro_name = :                                    ; Retrocession name

; ───────────────────────────────────────────────────────────────────────────────
; Parties
; ───────────────────────────────────────────────────────────────────────────────
retrocedent = @reinsurer                     ; Reinsurer ceding risk
retrocessionaire = @reinsurer                ; Reinsurer accepting risk
intermediary = @reinsurance_intermediary          ; Intermediary reference

; ───────────────────────────────────────────────────────────────────────────────
; Retrocession Type
; ───────────────────────────────────────────────────────────────────────────────
retrocession_type = (
    blanket,                                 ; Covers entire portfolio
    specific                                 ; Covers specific risk/treaty
)                                                 ; Type of retrocession

; ───────────────────────────────────────────────────────────────────────────────
; Covered Inward Business
; ───────────────────────────────────────────────────────────────────────────────
; What reinsurance business is being retroceded
covered_treaties[] = ::if retrocession_type = blanket  ; Treaties covered (blanket)
specific_treaty_id = ::if retrocession_type = specific  ; Specific treaty ID
covered_lines[] = :                               ; Lines of business covered
covered_territory[] = :(2..3)                     ; Territories covered

; ───────────────────────────────────────────────────────────────────────────────
; Term
; ───────────────────────────────────────────────────────────────────────────────
effective_date = date                             ; Retrocession effective date
expiration_date = date                            ; Retrocession expiration date
:invariant expiration_date > effective_date

; ───────────────────────────────────────────────────────────────────────────────
; Structure
; ───────────────────────────────────────────────────────────────────────────────
retro_structure = (
    aggregate_xl,
    cat_xl,
    per_occurrence_xl,
    proportional
)                                                 ; Retrocession structure type

; ───────────────────────────────────────────────────────────────────────────────
; Terms - Proportional
; ───────────────────────────────────────────────────────────────────────────────
{.proportional}
cession_percentage = #:(0..100):if retro_structure = proportional  ; Cession percentage
subject_premium = #$:(0..):if retro_structure = proportional  ; Subject premium
ceded_premium = #$:(0..):if retro_structure = proportional  ; Ceded premium
ceding_commission_percentage = #:(0..50):if retro_structure = proportional  ; Ceding commission %

{@retrocession}

; ───────────────────────────────────────────────────────────────────────────────
; Terms - Non-Proportional
; ───────────────────────────────────────────────────────────────────────────────
{.xol}
limit = #$:(0..):if retro_structure = aggregate_xl  ; Layer limit (aggregate XL)
limit = #$:(0..):if retro_structure = cat_xl       ; Layer limit (cat XL)
limit = #$:(0..):if retro_structure = per_occurrence_xl  ; Layer limit (per occurrence)
attachment = #$:(0..):if retro_structure = aggregate_xl  ; Attachment point (aggregate)
attachment = #$:(0..):if retro_structure = cat_xl  ; Attachment point (cat XL)
attachment = #$:(0..):if retro_structure = per_occurrence_xl  ; Attachment point (per occ)
annual_aggregate_limit = #$:(0..):if retro_structure = aggregate_xl  ; Annual aggregate limit
annual_aggregate_limit = #$:(0..):if retro_structure = cat_xl  ; Annual aggregate limit (cat)
annual_aggregate_limit = #$:(0..):if retro_structure = per_occurrence_xl  ; Annual agg limit (per occ)
rate_on_line = #:(0..100):if retro_structure = aggregate_xl  ; Rate on line (aggregate)
rate_on_line = #:(0..100):if retro_structure = cat_xl  ; Rate on line (cat XL)
rate_on_line = #:(0..100):if retro_structure = per_occurrence_xl  ; Rate on line (per occ)
deposit_premium = #$:(0..):if retro_structure = aggregate_xl  ; Deposit premium (aggregate)
deposit_premium = #$:(0..):if retro_structure = cat_xl  ; Deposit premium (cat XL)
deposit_premium = #$:(0..):if retro_structure = per_occurrence_xl  ; Deposit premium (per occ)

{@retrocession}

; ───────────────────────────────────────────────────────────────────────────────
; Reinstatements
; ───────────────────────────────────────────────────────────────────────────────
reinstatements = @reinstatement:if retro_structure = aggregate_xl  ; Reinstatements (aggregate)
reinstatements = @reinstatement:if retro_structure = cat_xl  ; Reinstatements (cat XL)
reinstatements = @reinstatement:if retro_structure = per_occurrence_xl  ; Reinstatements (per occ)

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (
    active,
    cancelled,
    commuted,
    expired,
    run_off
)                                                 ; Retrocession status

; ═══════════════════════════════════════════════════════════════════════════════
; Treaty Account Statement
; ═══════════════════════════════════════════════════════════════════════════════
; Periodic accounting between cedent and reinsurer

{@treaty_account}
account_id = :                                    ; Unique identifier for account
treaty_id = :                                     ; Treaty identifier

; ───────────────────────────────────────────────────────────────────────────────
; Period
; ───────────────────────────────────────────────────────────────────────────────
account_period_start = date                       ; Account period start
account_period_end = date                         ; Account period end
statement_date = date                             ; Statement date
due_date = date                                   ; Due date for payment

; ───────────────────────────────────────────────────────────────────────────────
; Premium Section
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
gross_written = #$:(0..)                          ; Gross written premium
ceded_written = #$:(0..)                          ; Ceded written premium
ceding_commission = #$:(0..)                      ; Ceding commission
brokerage = #$:(0..)                              ; Brokerage amount
net_premium_due = #$:(0..)                        ; Net premium due to reinsurer

{@treaty_account}

; ───────────────────────────────────────────────────────────────────────────────
; Loss Section
; ───────────────────────────────────────────────────────────────────────────────
{.losses}
paid_losses = #$:(0..)                            ; Paid losses
paid_alae = #$:(0..)                              ; Paid ALAE
outstanding_losses = #$:(0..)                     ; Outstanding loss reserves
outstanding_alae = #$:(0..)                       ; Outstanding ALAE reserves
total_incurred = #$:(0..)                         ; Total incurred

{@treaty_account}

; ───────────────────────────────────────────────────────────────────────────────
; Commission Adjustments
; ───────────────────────────────────────────────────────────────────────────────
{.commission_adjustment}
sliding_scale_adjustment = #$:(..)                ; Sliding scale adjustment
profit_commission = #$:(0..)                      ; Profit commission amount
total_adjustment = #$:(..)                        ; Total commission adjustment

{@treaty_account}

; ───────────────────────────────────────────────────────────────────────────────
; Balance
; ───────────────────────────────────────────────────────────────────────────────
{.balance}
prior_balance = #$:(..)                           ; Prior balance
current_activity = #$:(..)                        ; Current period activity
interest = #$:(0..)                               ; Interest credited
ending_balance = #$:(..)                          ; Ending balance
direction = (due_from_reinsurer, due_to_reinsurer)  ; Balance direction

{@treaty_account}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (
    disputed,
    final,
    paid,
    pending,
    reconciled
)                                                 ; Account statement status

; ═══════════════════════════════════════════════════════════════════════════════
; Experience Account (for Loss-Sensitive Programs)
; ═══════════════════════════════════════════════════════════════════════════════
; Tracks premium/loss experience for commission adjustments

{@experience_account}
experience_id = :                                 ; Unique identifier for experience account
treaty_id = :                                     ; Treaty identifier

; ───────────────────────────────────────────────────────────────────────────────
; Experience Period
; ───────────────────────────────────────────────────────────────────────────────
experience_year = ##:(1900..2100)                 ; Experience year
experience_period_start = date                    ; Experience period start
experience_period_end = date                      ; Experience period end
development_period_months = ##:(0..)              ; Development period in months

; ───────────────────────────────────────────────────────────────────────────────
; Premium Experience
; ───────────────────────────────────────────────────────────────────────────────
subject_premium = #$:(0..)                        ; Subject premium
earned_premium = #$:(0..)                         ; Earned premium

; ───────────────────────────────────────────────────────────────────────────────
; Loss Experience
; ───────────────────────────────────────────────────────────────────────────────
incurred_losses = #$:(0..)                        ; Incurred losses
incurred_alae = #$:(0..)                          ; Incurred ALAE
total_incurred = #$:(0..)                         ; Total incurred
loss_ratio = #:(0..)                              ; Loss ratio percentage

; ───────────────────────────────────────────────────────────────────────────────
; Commission Calculation
; ───────────────────────────────────────────────────────────────────────────────
{.commission}
provisional_rate = #:(0..50)                      ; Provisional commission rate
provisional_amount = #$:(0..)                     ; Provisional commission amount
calculated_rate = #:(0..50)                  ; Based on experience
calculated_amount = #$:(0..)                      ; Calculated commission amount
adjustment_due = #$:(..)                     ; Positive = to cedent
adjustment_direction = (due_from_reinsurer, due_to_reinsurer)  ; Direction of adjustment

{@experience_account}

; ───────────────────────────────────────────────────────────────────────────────
; Profit Commission (if applicable)
; ───────────────────────────────────────────────────────────────────────────────
{.profit}
gross_profit = #$:(..)                            ; Gross profit (can be negative)
reinsurer_margin = #$:(0..)                       ; Reinsurer's margin amount
deficit_carryforward = #$:(0..)                   ; Deficit carried forward
net_profit = #$:(..)                              ; Net profit after deductions
cedent_share = #:(0..100)                         ; Cedent's share of profit
profit_commission = #$:(0..)                      ; Profit commission to cedent

{@experience_account}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
final = ?                                         ; Whether account is final
finalization_date = date:if final = true          ; Date account finalized



; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Umbrella/Excess Coverage Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Umbrella and excess coverage line extension of the universal coverage primitive
; adding fields for underlying policy requirements, self-insured retentions,
; and drop-down provisions.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../coverage.schema.odin" as cov
@import "../limits.schema.odin" as limits

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.coverages.lines.umbrella"
version = "1.0.0"
title = "Umbrella/Excess Coverage Schema"
description = "Umbrella and excess liability coverage extending universal coverage primitive"

{$derivation}
source[0].authority = "U.S. Department of Labor"
source[0].citation = "Employee Benefits Security Administration"
source[0].url = "https://www.dol.gov/agencies/ebsa"

source[1].authority = "National Association of Insurance Commissioners (NAIC)"
source[1].citation = "Excess and Surplus Lines Model Laws"
source[1].url = "https://content.naic.org/"

source[2].authority = "State Insurance Departments"
source[2].citation = "Various state umbrella/excess liability regulations"
source[2].url = "https://www.usa.gov/state-insurance"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Umbrella and excess liability coverage line extension"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial umbrella/excess coverage schema"
changelog[0].rationale = "Coverage-centric architecture - umbrella line extension"

; ═══════════════════════════════════════════════════════════════════════════════
; Umbrella Coverage (Extends Universal Coverage)
; ═══════════════════════════════════════════════════════════════════════════════

{@umbrella_coverage}
= @coverage                                       ; Inherit all universal coverage fields

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Type Classification
; ───────────────────────────────────────────────────────────────────────────────
umbrella_type = !(
    true_umbrella,                                ; Broad coverage, may drop down
    excess_follow_form,                           ; Follows underlying exactly
    excess_specific                               ; Excess with specific terms
)

; ───────────────────────────────────────────────────────────────────────────────
; Umbrella/Excess Limits
; ───────────────────────────────────────────────────────────────────────────────
{.umbrella_limits}
each_occurrence = !#$:(0..)                       ; Per occurrence limit
aggregate = !#$:(0..)                             ; Annual aggregate
products_aggregate = #$:(0..)                     ; Separate products aggregate if applicable

{@umbrella_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Self-Insured Retention
; ───────────────────────────────────────────────────────────────────────────────
self_insured_retention = #$:(0..)                 ; SIR amount
sir_applies_to = (all_claims, gaps_only, non_scheduled)

; ───────────────────────────────────────────────────────────────────────────────
; Drop-Down Coverage (True Umbrella)
; ───────────────────────────────────────────────────────────────────────────────
drop_down_available = ?                           ; Does umbrella drop down?
drop_down_for_exhausted = ?                       ; Drops when underlying exhausted
drop_down_for_gaps = ?                            ; Drops for coverage gaps

; ───────────────────────────────────────────────────────────────────────────────
; Defense
; ───────────────────────────────────────────────────────────────────────────────
defense_within_limits = ?                         ; Defense costs within limits
defense_obligation = (excess_of_underlying, none, primary)

; ═══════════════════════════════════════════════════════════════════════════════
; Underlying Policies
; ═══════════════════════════════════════════════════════════════════════════════

{@umbrella_coverage.underlying_policies[]}
underlying_type = !(
    auto_liability,
    employers_liability,
    general_liability,
    liquor_liability,
    professional_liability,
    watercraft,
    other
)
underlying_carrier = :
underlying_policy_number = :

; Required underlying limits
{.required_limits}
each_occurrence = !#$:(0..)
general_aggregate = #$:(0..)
products_aggregate = #$:(0..)
auto_csl = #$:(0..)
auto_bi_per_person = #$:(0..)
auto_bi_per_accident = #$:(0..)
auto_pd = #$:(0..)
employers_liability_accident = #$:(0..)
employers_liability_disease_employee = #$:(0..)
employers_liability_disease_policy = #$:(0..)

{@umbrella_coverage.underlying_policies[]}

; Scheduled vs non-scheduled
scheduled = ?                                     ; Is this a scheduled underlying?

; ═══════════════════════════════════════════════════════════════════════════════
; Excess Follow Form Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@umbrella_coverage}

{.follow_form}
follows_underlying = ?                            ; Follows terms of underlying
follows_which = (all, specified)
specified_underlying[] = ::if follows_which = specified
differences_in_conditions = ?                     ; DIC provisions

{@umbrella_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Coverage Extensions/Restrictions
; ═══════════════════════════════════════════════════════════════════════════════

{.coverage_scope}
; What's covered
personal_injury = ?
advertising_injury = ?
products_completed_ops = ?
contractual_liability = ?
employers_liability = ?
auto_liability = ?
watercraft = ?
aircraft = ?

; Territory
worldwide = ?
us_canada_only = ?

{@umbrella_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Exclusions (Common Umbrella/Excess)
; ═══════════════════════════════════════════════════════════════════════════════

{.exclusions}
pollution = ?
pollution_buyback = ?:if pollution = true
asbestos = ?
nuclear = ?
war = ?
terrorism = ?
professional_liability = ?
employment_practices = ?
cyber = ?
punitive_damages = ?
aircraft = ?
watercraft = ?

{@umbrella_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Layer Information (for Excess Towers)
; ═══════════════════════════════════════════════════════════════════════════════

{.layer}
layer_number = ##:(1..)                           ; Which layer (1st excess, 2nd excess, etc.)
attachment_point = #$:(0..)                       ; Where this layer attaches
layer_limit = #$:(0..)                            ; This layer's limit
underlying_layer_ref = :                          ; Reference to layer below

{@umbrella_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Commercial Umbrella
; ═══════════════════════════════════════════════════════════════════════════════

{@commercial_umbrella_coverage}
= @umbrella_coverage

coverage_type_ref = "UMB"
umbrella_type = "true_umbrella"

; Commercial umbrella specific
retained_limit = #$:(0..)                         ; Retained limit (similar to SIR)

; Aggregate restoration
aggregate_restoration = ?
restoration_premium = #$:(0..):if aggregate_restoration = true

; ═══════════════════════════════════════════════════════════════════════════════
; Personal Umbrella
; ═══════════════════════════════════════════════════════════════════════════════

{@personal_umbrella_coverage}
= @umbrella_coverage

; Personal umbrella specific
{.personal}
uninsured_motorist = ?
um_limit = #$:(0..):if uninsured_motorist = true
underinsured_motorist = ?
uim_limit = #$:(0..):if underinsured_motorist = true

{@personal_umbrella_coverage}

; Underlying personal policies
{.underlying_personal}
auto_liability = #$:(0..)
homeowners_liability = #$:(0..)
watercraft_liability = #$:(0..)

{@personal_umbrella_coverage}


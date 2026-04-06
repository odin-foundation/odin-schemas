; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Coverage Deductibles Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Coverage deductible definitions including per-occurrence, aggregate, percentage,
; and waiting period deductibles applicable across all lines of business.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.coverages.deductibles"
version = "1.0.0"
title = "Coverage Deductibles Schema"
description = "Reusable deductible structures for various coverage types"

{$derivation}
source[0].authority = "U.S. Department of Labor"
source[0].citation = "Employee Benefits Security Administration"
source[0].url = "https://www.dol.gov/agencies/ebsa"

source[1].authority = "State Insurance Departments"
source[1].citation = "Various state insurance regulations and statutes"
source[1].url = "https://www.usa.gov/state-insurance"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Standardized deductible structures for all coverage types"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial deductibles schema"
changelog[0].rationale = "Coverage-centric architecture - reusable deductible patterns"

; ═══════════════════════════════════════════════════════════════════════════════
; Standard Deductible
; ═══════════════════════════════════════════════════════════════════════════════
; Basic flat dollar deductible

{@deductible_standard}
; Required fields first
amount = !#$                                     ; Deductible amount
basis = !(annual, per_claim, per_item, per_occurrence)  ; Deductible application basis

; Optional fields
applies_to = :                                   ; What the deductible applies to
waived_for[] = :                                 ; Conditions where waived

; ═══════════════════════════════════════════════════════════════════════════════
; Percentage Deductible
; ═══════════════════════════════════════════════════════════════════════════════
; Common in property (especially coastal/earthquake)

{@deductible_percentage}
; Required fields first
percent = !#:(0..100)                            ; Percentage value
percent_of = !(building_value, contents_value, coverage_a, dwelling_limit, loss_amount, replacement_cost, total_insured_value)  ; Percentage basis

; Optional fields
basis = (annual, per_building, per_claim, per_occurrence)  ; Deductible application basis
maximum = #$                                     ; Maximum dollar amount cap
minimum = #$                                     ; Minimum dollar amount

; ═══════════════════════════════════════════════════════════════════════════════
; Disappearing Deductible
; ═══════════════════════════════════════════════════════════════════════════════
; Deductible that reduces as loss increases

{@deductible_disappearing}
; Required fields first
disappearance_threshold = !#$                    ; Loss amount where deductible becomes zero
initial_amount = !#$                             ; Starting deductible amount

; Optional fields
formula = :                                      ; Formula description

; ═══════════════════════════════════════════════════════════════════════════════
; Franchise Deductible
; ═══════════════════════════════════════════════════════════════════════════════
; Either pays nothing (below threshold) or pays full loss (above threshold)

{@deductible_franchise}
; Required fields first
threshold = !#$                                  ; Franchise threshold

; Optional fields
basis = (per_claim, per_occurrence)              ; Deductible application basis

; If loss < threshold: nothing paid
; If loss >= threshold: full loss paid

; ═══════════════════════════════════════════════════════════════════════════════
; Auto Physical Damage Deductibles
; ═══════════════════════════════════════════════════════════════════════════════
; Split deductibles for comprehensive and collision

{@deductible_auto_pd}
; Optional fields (all deductibles are optional)
collision = #$                                   ; Collision deductible
collision_waived_if_not_at_fault = ?             ; Collision deductible waived if not at fault
comprehensive = #$                               ; Comprehensive deductible
deductible_waived_for_repairs = ?                ; Deductible waived for approved repairs
full_safety_glass = ?                            ; Glass replacement without deductible
glass = #$                                       ; Separate glass deductible if not full coverage
rental = #$                                      ; Rental reimbursement deductible
towing = #$                                      ; Towing deductible

; ═══════════════════════════════════════════════════════════════════════════════
; Property Deductible Structure
; ═══════════════════════════════════════════════════════════════════════════════

{@deductible_property}
; Optional fields
basis = (per_claim, per_location, per_occurrence)  ; Deductible application basis
standard = #$                                    ; Standard property deductible

; ───────────────────────────────────────────────────────────────────────────────
; Wind and Hail
; ───────────────────────────────────────────────────────────────────────────────
{.wind_hail}
amount = #$:if type = flat                       ; Flat dollar amount
maximum = #$:if type = percentage                ; Maximum dollar amount
minimum = #$:if type = percentage                ; Minimum dollar amount
percent = #:(0..100):if type = percentage        ; Percentage value
percent_of = (building_value, coverage_a, total_insured_value):if type = percentage  ; Percentage basis
type = (flat, percentage)                        ; Deductible type

{@deductible_property}

; ───────────────────────────────────────────────────────────────────────────────
; Hurricane
; ───────────────────────────────────────────────────────────────────────────────
{.hurricane}
amount = #$:if type = flat                       ; Flat dollar amount
minimum = #$:if type = percentage                ; Minimum dollar amount
percent = #:(0..100):if type = percentage        ; Percentage value
percent_of = (building_value, coverage_a, total_insured_value):if type = percentage  ; Percentage basis
trigger = (hurricane_warning, hurricane_watch, named_storm)  ; Hurricane trigger
type = (flat, percentage)                        ; Deductible type

{@deductible_property}

; ───────────────────────────────────────────────────────────────────────────────
; Earthquake
; ───────────────────────────────────────────────────────────────────────────────
{.earthquake}
amount = #$:if type = flat                       ; Flat dollar amount
applies_to = (all_coverages, building_and_contents, building_only)  ; What the deductible applies to
minimum = #$:if type = percentage                ; Minimum dollar amount
percent = #:(0..100):if type = percentage        ; Percentage value
percent_of = (building_value, coverage_a, total_insured_value):if type = percentage  ; Percentage basis
type = (flat, percentage)                        ; Deductible type

{@deductible_property}

; ───────────────────────────────────────────────────────────────────────────────
; Flood
; ───────────────────────────────────────────────────────────────────────────────
{.flood}
amount = #$:if type = flat                       ; Flat dollar amount
building_deductible = #$                         ; Building coverage deductible
contents_deductible = #$                         ; Contents coverage deductible
percent = #:(0..100):if type = percentage        ; Percentage value
type = (flat, percentage)                        ; Deductible type

{@deductible_property}

; ═══════════════════════════════════════════════════════════════════════════════
; Aggregate Deductible
; ═══════════════════════════════════════════════════════════════════════════════
; Cumulative deductible over policy period

{@deductible_aggregate}
; Required fields first
amount = !#$                                     ; Total annual deductible amount

; Optional fields
per_claim_amount = #$                            ; Per claim amount contributing to aggregate
remaining = #$                                   ; Amount remaining
satisfied = #$                                   ; Amount already satisfied

; ═══════════════════════════════════════════════════════════════════════════════
; WC Deductible Structure
; ═══════════════════════════════════════════════════════════════════════════════
; Workers comp deductible programs

{@deductible_wc}
; Required fields first
program_type = !(large_deductible, retrospective, small_deductible)  ; Deductible program type

; Optional fields
aggregate = #$                                   ; Aggregate deductible
applies_to = (indemnity_and_medical, indemnity_only, medical_only)  ; What the deductible applies to
collateral_amount = #$:if collateral_required = true  ; Collateral amount required
collateral_required = ?                          ; Collateral is required
collateral_type = (cash, letter_of_credit, surety_bond, trust):if collateral_required = true  ; Collateral type
per_claim = #$                                   ; Per claim deductible

; ═══════════════════════════════════════════════════════════════════════════════
; Professional Liability Deductible
; ═══════════════════════════════════════════════════════════════════════════════

{@deductible_professional}
; Required fields first
amount = !#$                                     ; Deductible amount

; Optional fields
applies_to = (defense_and_indemnity, indemnity_only)  ; What the deductible applies to
each_claim = ?                                   ; Per claim deductible
each_wrongful_act = ?                            ; Per wrongful act deductible

; ═══════════════════════════════════════════════════════════════════════════════
; Cyber Deductible Structure
; ═══════════════════════════════════════════════════════════════════════════════

{@deductible_cyber}
; Optional fields
standard = #$                                    ; Standard deductible amount
waiting_period_hours = ##:(0..168)               ; Business interruption waiting period in hours

; ───────────────────────────────────────────────────────────────────────────────
; Per-Coverage Deductibles
; ───────────────────────────────────────────────────────────────────────────────
{.by_coverage}
breach_response = #$                             ; Breach response deductible
business_interruption = #$                       ; Business interruption deductible
cyber_extortion = #$                             ; Cyber extortion deductible
network_security = #$                            ; Network security deductible
privacy_liability = #$                           ; Privacy liability deductible

{@deductible_cyber}

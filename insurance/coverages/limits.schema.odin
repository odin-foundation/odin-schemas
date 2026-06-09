; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Coverage Limits Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Coverage limit definitions including per-occurrence, aggregate, split, combined
; single, and shared limits applicable across all lines of business.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.coverages.limits"
version = "1.0.0"
title = "Coverage Limits Schema"
description = "Reusable limit structures for complex limit patterns"

{$derivation}
source[0].authority = "U.S. Department of Labor"
source[0].citation = "Employee Benefits Security Administration"
source[0].url = "https://www.dol.gov/agencies/ebsa"

source[1].authority = "State Insurance Departments"
source[1].citation = "Various state insurance regulations and statutes"
source[1].url = "https://content.naic.org/state-insurance-departments"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Standardized limit structures for all coverage types"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial limits schema"
changelog[0].rationale = "Coverage-centric architecture - reusable limit patterns"

; ═══════════════════════════════════════════════════════════════════════════════
; Split Limits (Auto Liability)
; ═══════════════════════════════════════════════════════════════════════════════
; Traditional auto liability expressed as three separate limits:
; - Per person bodily injury
; - Per accident bodily injury
; - Property damage

{@limit_split}
; Optional fields
bi_per_accident = #$                             ; Bodily injury per accident limit
bi_per_person = #$                               ; Bodily injury per person limit
display = :                                      ; Display format (e.g. "100/300/100")
pd = #$                                          ; Property damage per accident limit

; ═══════════════════════════════════════════════════════════════════════════════
; Combined Single Limit
; ═══════════════════════════════════════════════════════════════════════════════
; Single limit covering both BI and PD combined

{@limit_csl}
; Required fields first
amount = #$                                     ; Combined single limit amount

; Optional fields
per = (accident, occurrence)                     ; Per accident or per occurrence

; ═══════════════════════════════════════════════════════════════════════════════
; Aggregate Limit Structure
; ═══════════════════════════════════════════════════════════════════════════════
; Tracks aggregate limits and erosion

{@limit_aggregate}
; Required fields first
amount = #$                                     ; Total aggregate amount
type = (annual, disease, general, per_location, per_project, policy_period, products_completed_ops)  ; Aggregate limit type

; Optional fields
per = (location, policy, project)                ; Aggregate applies per
reinstatable = ?                                 ; Can be reinstated
reinstatement_premium = #$                       ; Premium to reinstate aggregate
remaining = #$                                   ; Remaining aggregate if tracked

; ═══════════════════════════════════════════════════════════════════════════════
; CGL Limit Structure
; ═══════════════════════════════════════════════════════════════════════════════
; Standard CGL limit structure

{@limit_cgl}
; Required fields first
each_occurrence = #$                            ; Each occurrence limit
general_aggregate = #$                          ; General aggregate limit

; Optional fields
aggregate_per = (location, policy, project)      ; Aggregate applies per
damage_to_premises = #$                          ; Damage to premises rented to you
medical_expense = #$                             ; Medical expense per person
personal_advertising_injury = #$                 ; Personal and advertising injury limit
products_completed_ops_aggregate = #$            ; Products completed operations aggregate

; ═══════════════════════════════════════════════════════════════════════════════
; Workers Comp Limit Structure
; ═══════════════════════════════════════════════════════════════════════════════
; Standard WC employers liability limits

{@limit_wc}
; Required fields first
each_accident = #$                              ; Bodily injury by accident limit
disease_each_employee = #$                      ; Bodily injury by disease per employee
disease_policy_limit = #$                       ; Bodily injury by disease policy limit

; Optional fields
statutory = ? "true"                             ; Part One statutory coverage (no dollar limit)

; ═══════════════════════════════════════════════════════════════════════════════
; Umbrella/Excess Limit Structure
; ═══════════════════════════════════════════════════════════════════════════════

{@limit_umbrella}
; Required fields first
aggregate = #$                                  ; Annual aggregate limit
each_occurrence = #$                            ; Each occurrence limit

; Optional fields
self_insured_retention = #$                      ; SIR amount

; ═══════════════════════════════════════════════════════════════════════════════
; Property Limit Structure
; ═══════════════════════════════════════════════════════════════════════════════

{@limit_property}
; Optional fields
blanket_limit = #$                               ; Blanket limit if applicable
building = #$                                    ; Building coverage limit
business_income = #$                             ; Business income limit
coinsurance_percent = #:(0..100)                 ; Coinsurance percentage
contents = #$                                    ; Contents or BPP limit
extra_expense = #$                               ; Extra expense limit
valuation = (actual_cash_value, agreed_value, functional, replacement_cost)  ; Valuation basis

; ═══════════════════════════════════════════════════════════════════════════════
; Professional Liability Limit Structure
; ═══════════════════════════════════════════════════════════════════════════════

{@limit_professional}
; Required fields first
aggregate = #$                                  ; Annual aggregate limit
each_claim = #$                                 ; Per claim limit

; Optional fields
deductible_applies_to_defense = ?                ; Deductible applies to defense costs
defense_within_limits = ?                        ; Defense costs erode limits

; ═══════════════════════════════════════════════════════════════════════════════
; Cyber Liability Limit Structure
; ═══════════════════════════════════════════════════════════════════════════════

{@limit_cyber}
; Required fields first
aggregate = #$                                  ; Policy aggregate limit

; ───────────────────────────────────────────────────────────────────────────────
; Sublimits
; ───────────────────────────────────────────────────────────────────────────────
{.sublimits}
breach_response = #$                             ; Breach response sublimit
business_interruption = #$                       ; Business interruption sublimit
cyber_extortion = #$                             ; Cyber extortion sublimit
data_restoration = #$                            ; Data restoration sublimit
media_liability = #$                             ; Media liability sublimit
network_security = #$                            ; Network security sublimit
pci_fines = #$                                   ; PCI fines and penalties sublimit
privacy_liability = #$                           ; Privacy liability sublimit
regulatory_defense = #$                          ; Regulatory defense sublimit
social_engineering = #$                          ; Social engineering sublimit

{@limit_cyber}

; ═══════════════════════════════════════════════════════════════════════════════
; Sublimit Structure
; ═══════════════════════════════════════════════════════════════════════════════
; Generic sublimit that sits within another limit

{@sublimit_legacy}
= @sublimit                                      ; Use shared sublimit type

; Coverage-specific extensions
name = :                                        ; What this sublimit covers
id = :                                           ; Sublimit identifier
parent_coverage_ref = :                          ; Coverage this is a sublimit of
separate_deductible = ?                          ; Has its own deductible

; ═══════════════════════════════════════════════════════════════════════════════
; Shared Limit Structure
; ═══════════════════════════════════════════════════════════════════════════════
; When multiple coverages share a single limit

{@limit_shared}
; Required fields first
amount = #$                                     ; Shared limit amount

; Optional fields
allocation_method = (equal, first_come, proportional)  ; Allocation method
id = :                                           ; Shared limit identifier
participating_coverages[] = :                    ; Coverage IDs sharing this limit
remaining = #$                                   ; Remaining amount if tracked

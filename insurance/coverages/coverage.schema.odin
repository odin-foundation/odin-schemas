; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Coverage Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Coverage instance - the universal primitive from which all coverage
; representations derive across every line of business.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./coverage-type.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.coverages.coverage"
version = "1.0.0"
title = "Coverage Schema"
description = "Coverage instance - a policy HAS this coverage"

{$derivation}
source[0].authority = "U.S. Department of Labor"
source[0].citation = "Employee Benefits Security Administration"
source[0].url = "https://www.dol.gov/agencies/ebsa"

source[1].authority = "State Insurance Departments"
source[1].citation = "Various state insurance regulations and statutes"
source[1].url = "https://content.naic.org/state-insurance-departments"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Universal coverage primitive for all lines of business"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial coverage schema"
changelog[0].rationale = "Coverage-centric architecture - coverage as atomic unit"

; ═══════════════════════════════════════════════════════════════════════════════
; Coverage Instance
; ═══════════════════════════════════════════════════════════════════════════════

{@coverage}
; Required fields first
type_ref = !:                                    ; Reference to coverage type code
status = !(active, declined, excluded, pending, waived)  ; Coverage status

; Optional fields
code = :                                         ; Coverage code
id = :                                           ; Coverage instance identifier
name = :                                         ; Coverage name

; ───────────────────────────────────────────────────────────────────────────────
; Selection Status
; ───────────────────────────────────────────────────────────────────────────────
mandatory = ?                                    ; Coverage is mandatory
selected = ?                                     ; Coverage has been selected

; ───────────────────────────────────────────────────────────────────────────────
; Dates (if different from policy/schedule)
; ───────────────────────────────────────────────────────────────────────────────
effective = date                                 ; Coverage effective date
expiration = date                                ; Coverage expiration date

; ───────────────────────────────────────────────────────────────────────────────
; Territory
; ───────────────────────────────────────────────────────────────────────────────
territory = :                                    ; Coverage territory description
territory_code = :                               ; Territory code

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Modifiers
; ───────────────────────────────────────────────────────────────────────────────
additional_insured_available = ?                 ; Additional insured option available
primary_noncontributory_available = ?            ; Primary non-contributory available
waiver_of_subrogation_available = ?              ; Waiver of subrogation available

; ───────────────────────────────────────────────────────────────────────────────
; References to What/Who is Covered
; ───────────────────────────────────────────────────────────────────────────────
covered_item_refs[] = :                          ; References to covered items
covered_party_refs[] = :                         ; References to covered parties

; ───────────────────────────────────────────────────────────────────────────────
; Exclusions and Conditions
; ───────────────────────────────────────────────────────────────────────────────
conditions[] = :                                 ; Coverage conditions
endorsement_refs[] = :                           ; References to endorsements
exclusions[] = :                                 ; Coverage exclusions

; ───────────────────────────────────────────────────────────────────────────────
; Versioning / Temporal
; ───────────────────────────────────────────────────────────────────────────────
change_effective_date = date                     ; Date change becomes effective
change_reason = :                                ; Reason for coverage change
previous_version_ref = :                         ; Reference to previous version
version = ##:(1..)                               ; Coverage version number

; ═══════════════════════════════════════════════════════════════════════════════
; Limits
; ═══════════════════════════════════════════════════════════════════════════════

{@coverage.limits[]}
= @coverage_limit                                ; Use shared coverage limit type

; Coverage-specific extensions
reinstatable = ?                                 ; Limit is reinstatable
shared_with[] = :                                ; Coverage IDs sharing this limit
statutory = ?                                    ; Statutory limit (no dollar amount)

{@coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Deductibles
; ═══════════════════════════════════════════════════════════════════════════════

{@coverage.deductibles[]}
= @deductible                                    ; Use shared deductible type

; Coverage-specific extensions (percentage-based)
maximum = #$:if type = percentage                ; Maximum deductible amount
minimum = #$:if type = percentage                ; Minimum deductible amount
percent = #:(0..100):if type = percentage        ; Percentage value
percent_of = :if type = percentage               ; What percentage is based on
waived_for[] = :                                 ; Conditions where waived

{@coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Premium Structure
; ═══════════════════════════════════════════════════════════════════════════════

{.premium}
= @premium_detail                                ; Use shared premium detail type

; Coverage-specific extensions
auditable = ?                                    ; Premium is auditable
earned = #$                                      ; Earned premium
rate = #                                         ; Premium rate
rate_per = :                                     ; Rate per unit
written = #$                                     ; Written premium

{@coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Rating Information
; ═══════════════════════════════════════════════════════════════════════════════

{.rating}
= @rating_classification                         ; Use shared rating classification type

; Coverage-specific extensions
experience_mod = #                               ; Experience modification
manual_rate = #                                  ; Manual rating rate

{@coverage}

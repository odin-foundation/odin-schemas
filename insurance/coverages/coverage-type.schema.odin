; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Coverage Type Definition Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Coverage type definition schema establishing the canonical code and name for
; coverage types. Defines the shared vocabulary that coverage instances reference.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.coverages.coverage-type"
version = "1.0.0"
title = "Coverage Type Definition Schema"
description = "Canonical coverage type definitions - shared vocabulary for coverage instances"

{$derivation}
methodology = "industry_practice"
proprietary_sources_consulted = ?false
notes = "Coverage type definitions - structure not rules"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial coverage type schema"
changelog[0].rationale = "Coverage-centric architecture foundation"

; ═══════════════════════════════════════════════════════════════════════════════
; Coverage Type Definition
; ═══════════════════════════════════════════════════════════════════════════════

{@coverage_type}
; Required fields first
code = :                                        ; Coverage type code
line_of_business = (auto, cyber, dwelling, general_liability, homeowners, inland_marine, professional_liability, property, renters, umbrella_excess, workers_compensation)  ; Line of business
name = :                                        ; Coverage type name

; Optional fields
description = :                                  ; Coverage type description

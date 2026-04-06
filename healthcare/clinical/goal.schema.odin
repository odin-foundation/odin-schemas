; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Healthcare Clinical - Goal Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Clinical goal resource representing intended objectives and desired outcomes
; for patient care, used in care planning and evaluation. Derived from HL7
; FHIR R4/R5 (CC0 public domain).
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as fhir

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.clinical.goal"
version = "1.0.0"
title = "Healthcare Clinical Goal Schema"
description = "Clinical goal resource derived from FHIR R4/R5"

{$derivation}
source[0].authority = "HL7"
source[0].citation = "HL7 FHIR R4 - Goal Resource"
source[0].url = "https://hl7.org/fhir/R4/goal.html"

source[1].authority = "HL7"
source[1].citation = "HL7 FHIR R5 - Goal Resource"
source[1].url = "https://hl7.org/fhir/R5/goal.html"

source[2].authority = "HL7"
source[2].citation = "US Core Goal Profile"
source[2].url = "https://hl7.org/fhir/us/core/StructureDefinition-us-core-goal.html"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-20
changelog[0].change = "Initial clinical goal schema"
changelog[0].rationale = "Goal resource derived from FHIR R4/R5 specification"

; ═══════════════════════════════════════════════════════════════════════════════
; GOAL
; ═══════════════════════════════════════════════════════════════════════════════
; FHIR: Goal - https://hl7.org/fhir/R4/goal.html
; Describes the intended objective(s) for a patient

{@goal}
; Resource metadata
id = !:                                       ; Logical id of resource
meta = @fhir.meta                             ; Resource metadata

; Identifiers - FHIR: Goal.identifier
identifiers[] = @fhir.identifier              ; External identifiers

; Lifecycle status - FHIR: Goal.lifecycleStatus (required)
lifecycle_status = !(accepted, active, cancelled, completed, entered_in_error, on_hold, planned, proposed, rejected)

; Achievement status - FHIR: Goal.achievementStatus
achievement_status = @fhir.codeable_concept   ; in-progress | improving | worsening | no-change | achieved | sustaining | not-achieved | no-progress | not-attainable

; Categories - FHIR: Goal.category
categories[] = @fhir.codeable_concept         ; E.g., Treatment, dietary, behavioral

; Priority - FHIR: Goal.priority
priority = @fhir.codeable_concept             ; high-priority | medium-priority | low-priority

; Description - FHIR: Goal.description (required)
description = !@fhir.codeable_concept         ; Code or text describing goal

; Subject - FHIR: Goal.subject (required)
subject = !@fhir.reference                    ; Who this goal is intended for

; Start - FHIR: Goal.start[x] (polymorphic)
start_date = date                             ; When goal pursuit begins
start_codeable_concept = @fhir.codeable_concept  ; E.g., admission, discharge

; Target - FHIR: Goal.target
targets[] = @goal_target                      ; Target outcome for the goal

; Status date - FHIR: Goal.statusDate
status_date = date                            ; When goal status took effect

; Status reason - FHIR: Goal.statusReason
status_reason = :                             ; Reason for current status

; Expressed by - FHIR: Goal.expressedBy
expressed_by = @fhir.reference                ; Who's responsible for creating goal

; Addresses - FHIR: Goal.addresses
addresses[] = @fhir.reference                 ; Issues this goal addresses

; Notes - FHIR: Goal.note
notes[] = @fhir.annotation                    ; Comments about goal

; Outcome codes - FHIR: Goal.outcomeCode
outcome_codes[] = @fhir.codeable_concept      ; What result was achieved

; Outcome references - FHIR: Goal.outcomeReference
outcome_references[] = @fhir.reference        ; Observation of outcome

; ───────────────────────────────────────────────────────────────────────────────
; Goal Target - FHIR: Goal.target
; ───────────────────────────────────────────────────────────────────────────────

{@goal_target}
; Measure - FHIR: Goal.target.measure
measure = @fhir.codeable_concept              ; Parameter whose value is to be tracked

; Detail - FHIR: Goal.target.detail[x] (polymorphic)
detail_quantity = @fhir.quantity              ; Target value as quantity
detail_range = @fhir.range                    ; Target value as range
detail_codeable_concept = @fhir.codeable_concept  ; Target value as code
detail_string = :                             ; Target value as string
detail_boolean = ?                            ; Target value as boolean
detail_integer = ##                           ; Target value as integer
detail_ratio = @fhir.ratio                    ; Target value as ratio

; Due - FHIR: Goal.target.due[x] (polymorphic)
due_date = date                               ; Reach goal on or before
due_duration = @fhir.duration                 ; Reach goal within duration


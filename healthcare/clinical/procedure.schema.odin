; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Healthcare Clinical - Procedure Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Clinical procedure resource representing activities performed on or for a
; patient as part of care, ranging from surgeries to counseling to diagnostic
; tests. Derived from HL7 FHIR R4/R5 (CC0 public domain).
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as fhir

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.clinical.procedure"
version = "1.0.0"
title = "Healthcare Clinical Procedure Schema"
description = "Clinical procedure resource derived from FHIR R4/R5"

{$derivation}
source[0].authority = "HL7"
source[0].citation = "HL7 FHIR R4 - Procedure Resource"
source[0].url = "https://hl7.org/fhir/R4/procedure.html"

source[1].authority = "HL7"
source[1].citation = "HL7 FHIR R5 - Procedure Resource"
source[1].url = "https://hl7.org/fhir/R5/procedure.html"

source[2].authority = "HL7"
source[2].citation = "US Core Procedure Profile"
source[2].url = "https://hl7.org/fhir/us/core/StructureDefinition-us-core-procedure.html"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-20
changelog[0].change = "Initial clinical procedure schema"
changelog[0].rationale = "Procedure resource derived from FHIR R4/R5 specification"

; ═══════════════════════════════════════════════════════════════════════════════
; PROCEDURE
; ═══════════════════════════════════════════════════════════════════════════════
; FHIR: Procedure - https://hl7.org/fhir/R4/procedure.html
; An action performed on, with, or for a patient

{@procedure}
; Resource metadata
id = !:                                       ; Logical id of resource
meta = @fhir.meta                             ; Resource metadata

; Identifiers - FHIR: Procedure.identifier
identifiers[] = @fhir.identifier              ; External identifiers for procedure

; Instantiates - FHIR: Procedure.instantiatesCanonical, instantiatesUri
instantiates_canonical[] = :                  ; Instantiates FHIR protocol/definition
instantiates_uri[] = :                        ; Instantiates external protocol

; Based on - FHIR: Procedure.basedOn
based_on[] = @fhir.reference                  ; A request for this procedure

; Part of - FHIR: Procedure.partOf
part_of[] = @fhir.reference                   ; Part of another procedure

; Status - FHIR: Procedure.status (required)
status = !(completed, entered_in_error, in_progress, not_done, on_hold, preparation, stopped, unknown)

; Status reason - FHIR: Procedure.statusReason
status_reason = @fhir.codeable_concept        ; Reason for current status

; Category - FHIR: Procedure.category
category = @fhir.codeable_concept             ; Classification of procedure

; Code - FHIR: Procedure.code (required by US Core)
code = @fhir.codeable_concept                 ; Identification of the procedure (CPT, SNOMED, etc.)

; Subject - FHIR: Procedure.subject (required)
subject = !@fhir.reference                    ; Patient on whom procedure was performed

; Encounter - FHIR: Procedure.encounter
encounter = @fhir.reference                   ; Encounter during which procedure was performed

; Performed - FHIR: Procedure.performed[x] (polymorphic)
performed_date_time = timestamp               ; When procedure was performed (instant)
performed_period = @fhir.period               ; When procedure was performed (period)
performed_string = :                          ; When procedure was performed (text)
performed_age = @fhir.age                     ; When procedure was performed (age)
performed_range = @fhir.range                 ; When procedure was performed (range)

; Recorder - FHIR: Procedure.recorder
recorder = @fhir.reference                    ; Who recorded the procedure

; Asserter - FHIR: Procedure.asserter
asserter = @fhir.reference                    ; Who asserts procedure was performed

; Performers - FHIR: Procedure.performer
performers[] = @procedure_performer           ; Who performed the procedure

; Location - FHIR: Procedure.location
location = @fhir.reference                    ; Where procedure was performed

; Reason codes - FHIR: Procedure.reasonCode
reason_codes[] = @fhir.codeable_concept       ; Coded reason for procedure

; Reason references - FHIR: Procedure.reasonReference
reason_references[] = @fhir.reference         ; Condition/Observation as reason

; Body sites - FHIR: Procedure.bodySite
body_sites[] = @fhir.codeable_concept         ; Target body site

; Outcome - FHIR: Procedure.outcome
outcome = @fhir.codeable_concept              ; Result of procedure

; Reports - FHIR: Procedure.report
reports[] = @fhir.reference                   ; DiagnosticReport related to procedure

; Complications - FHIR: Procedure.complication
complications[] = @fhir.codeable_concept      ; Complications encountered

; Complication details - FHIR: Procedure.complicationDetail
complication_details[] = @fhir.reference      ; Condition representing complication

; Follow up - FHIR: Procedure.followUp
follow_up[] = @fhir.codeable_concept          ; Instructions for follow up

; Notes - FHIR: Procedure.note
notes[] = @fhir.annotation                    ; Additional information

; Focal devices - FHIR: Procedure.focalDevice
focal_devices[] = @procedure_focal_device     ; Devices manipulated during procedure

; Used references - FHIR: Procedure.usedReference
used_references[] = @fhir.reference           ; Items used during procedure

; Used codes - FHIR: Procedure.usedCode
used_codes[] = @fhir.codeable_concept         ; Coded items used during procedure

; ───────────────────────────────────────────────────────────────────────────────
; Procedure Performer - FHIR: Procedure.performer
; ───────────────────────────────────────────────────────────────────────────────

{@procedure_performer}
function = @fhir.codeable_concept             ; Type of performance
actor = !@fhir.reference                      ; Practitioner/Organization who performed
on_behalf_of = @fhir.reference                ; Organization performer was acting for

; ───────────────────────────────────────────────────────────────────────────────
; Focal Device - FHIR: Procedure.focalDevice
; ───────────────────────────────────────────────────────────────────────────────

{@procedure_focal_device}
action = @fhir.codeable_concept               ; Kind of change to device
manipulated = !@fhir.reference                ; Device that was changed


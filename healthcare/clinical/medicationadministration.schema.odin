; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Healthcare Clinical - Medication Administration Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Clinical medication administration resource representing the event of a
; medication being given to a patient, including self-administration and
; nurse-administered medications. Derived from HL7 FHIR R4/R5 (CC0 public domain).
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as fhir

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.clinical.medicationadministration"
version = "1.0.0"
title = "Healthcare Clinical Medication Administration Schema"
description = "Clinical medication administration resource derived from FHIR R4/R5"

{$derivation}
source[0].authority = "HL7"
source[0].citation = "HL7 FHIR R4 - MedicationAdministration Resource"
source[0].url = "https://hl7.org/fhir/R4/medicationadministration.html"

source[1].authority = "HL7"
source[1].citation = "HL7 FHIR R5 - MedicationAdministration Resource"
source[1].url = "https://hl7.org/fhir/R5/medicationadministration.html"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-20
changelog[0].change = "Initial clinical medication administration schema"
changelog[0].rationale = "MedicationAdministration resource derived from FHIR R4/R5 specification"

; ═══════════════════════════════════════════════════════════════════════════════
; MEDICATION ADMINISTRATION
; ═══════════════════════════════════════════════════════════════════════════════
; FHIR: MedicationAdministration - https://hl7.org/fhir/R4/medicationadministration.html
; Describes the event of a patient consuming or being given a medication

{@medication_administration}
; Resource metadata
id = !:                                       ; Logical id of resource
meta = @fhir.meta                             ; Resource metadata

; Identifiers - FHIR: MedicationAdministration.identifier
identifiers[] = @fhir.identifier              ; External identifiers

; Instantiates - FHIR: MedicationAdministration.instantiates
instantiates[] = :                            ; Instantiates protocol/definition

; Part of - FHIR: MedicationAdministration.partOf
part_of[] = @fhir.reference                   ; Part of another event

; Status - FHIR: MedicationAdministration.status (required)
status = !(completed, entered_in_error, in_progress, not_done, on_hold, stopped, unknown)

; Status reason - FHIR: MedicationAdministration.statusReason
status_reasons[] = @fhir.codeable_concept     ; Reason status is current

; Category - FHIR: MedicationAdministration.category
category = @fhir.codeable_concept             ; Type of medication usage

; Medication - FHIR: MedicationAdministration.medication[x] (polymorphic, required)
medication_codeable_concept = @fhir.codeable_concept  ; What was administered
medication_reference = @fhir.reference        ; Reference to Medication resource

; Subject - FHIR: MedicationAdministration.subject (required)
subject = !@fhir.reference                    ; Patient receiving medication

; Context - FHIR: MedicationAdministration.context
context = @fhir.reference                     ; Encounter or episode of care

; Supporting information - FHIR: MedicationAdministration.supportingInformation
supporting_information[] = @fhir.reference    ; Additional information

; Effective - FHIR: MedicationAdministration.effective[x] (polymorphic, required)
effective_date_time = timestamp               ; Start and end time of administration
effective_period = @fhir.period               ; Period of administration

; Performers - FHIR: MedicationAdministration.performer
performers[] = @medication_administration_performer  ; Who performed the administration

; Reason codes - FHIR: MedicationAdministration.reasonCode
reason_codes[] = @fhir.codeable_concept       ; Reason for giving medication

; Reason references - FHIR: MedicationAdministration.reasonReference
reason_references[] = @fhir.reference         ; Condition/Observation as reason

; Request - FHIR: MedicationAdministration.request
request = @fhir.reference                     ; Request that authorized administration

; Device - FHIR: MedicationAdministration.device
devices[] = @fhir.reference                   ; Devices used in administration

; Notes - FHIR: MedicationAdministration.note
notes[] = @fhir.annotation                    ; Additional information

; Dosage - FHIR: MedicationAdministration.dosage
dosage = @medication_administration_dosage    ; Details of how medication was taken

; Event history - FHIR: MedicationAdministration.eventHistory
event_history[] = @fhir.reference             ; Events of interest

; ───────────────────────────────────────────────────────────────────────────────
; Administration Performer - FHIR: MedicationAdministration.performer
; ───────────────────────────────────────────────────────────────────────────────

{@medication_administration_performer}
function = @fhir.codeable_concept             ; Type of performance
actor = !@fhir.reference                      ; Who performed the administration

; ───────────────────────────────────────────────────────────────────────────────
; Administration Dosage - FHIR: MedicationAdministration.dosage
; ───────────────────────────────────────────────────────────────────────────────

{@medication_administration_dosage}
text = :                                      ; Free text dosage instructions
site = @fhir.codeable_concept                 ; Body site of administration
route = @fhir.codeable_concept                ; Route of administration
method = @fhir.codeable_concept               ; How drug was administered
dose = @fhir.simple_quantity                  ; Amount of medication per dose

; Rate - FHIR: MedicationAdministration.dosage.rate[x] (polymorphic)
rate_ratio = @fhir.ratio                      ; Dose rate (dose per time)
rate_quantity = @fhir.simple_quantity         ; Dose rate (dose per unit time)


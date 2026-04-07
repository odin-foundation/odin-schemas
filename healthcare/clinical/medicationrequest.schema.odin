; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Healthcare Clinical - Medication Request Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Clinical medication request resource representing prescriptions, medication
; orders, and administration instructions for a patient. Derived from HL7
; FHIR R4/R5 (CC0 public domain).
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as fhir

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.clinical.medicationrequest"
version = "1.0.0"
title = "Healthcare Clinical Medication Request Schema"
description = "Clinical medication request (prescription) resource derived from FHIR R4/R5"

{$derivation}
source[0].authority = "HL7"
source[0].citation = "HL7 FHIR R4 - MedicationRequest Resource"
source[0].url = "https://hl7.org/fhir/R4/medicationrequest.html"

source[1].authority = "HL7"
source[1].citation = "HL7 FHIR R5 - MedicationRequest Resource"
source[1].url = "https://hl7.org/fhir/R5/medicationrequest.html"

source[2].authority = "HL7"
source[2].citation = "US Core MedicationRequest Profile"
source[2].url = "https://hl7.org/fhir/us/core/StructureDefinition-us-core-medicationrequest.html"

source[3].authority = "DEA"
source[3].citation = "Electronic Prescriptions for Controlled Substances (EPCS)"
source[3].url = "https://www.ecfr.gov/current/title-21/chapter-II/part-1311"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-20
changelog[0].change = "Initial clinical medication request schema"
changelog[0].rationale = "MedicationRequest resource derived from FHIR R4/R5 specification"

; ═══════════════════════════════════════════════════════════════════════════════
; MEDICATION REQUEST
; ═══════════════════════════════════════════════════════════════════════════════
; FHIR: MedicationRequest - https://hl7.org/fhir/R4/medicationrequest.html
; An order or request for medication

{@medication_request}
; Resource metadata
id = !:                                       ; Logical id of resource
meta = @fhir.meta                             ; Resource metadata

; Identifiers - FHIR: MedicationRequest.identifier
identifiers[] = @fhir.identifier              ; External identifiers

; Status - FHIR: MedicationRequest.status (required)
status = !(active, cancelled, completed, draft, entered_in_error, on_hold, stopped, unknown)

; Status reason - FHIR: MedicationRequest.statusReason
status_reason = @fhir.codeable_concept        ; Reason for current status

; Intent - FHIR: MedicationRequest.intent (required)
intent = !(filler_order, instance_order, option, order, original_order, plan, proposal, reflex_order)

; Category - FHIR: MedicationRequest.category
categories[] = @fhir.codeable_concept         ; Type of medication usage (inpatient, outpatient, community)

; Priority - FHIR: MedicationRequest.priority
priority = (asap, routine, stat, urgent)      ; Order priority

; Do not perform - FHIR: MedicationRequest.doNotPerform
do_not_perform = ?                            ; True if request is prohibiting action

; Reported - FHIR: MedicationRequest.reported[x] (polymorphic)
reported = ?                                  ; Reported rather than primary record
reported_reference = @fhir.reference          ; Source of reported information

; Medication - FHIR: MedicationRequest.medication[x] (polymorphic, required)
medication_codeable_concept = @fhir.codeable_concept  ; Medication code (RxNorm, NDC)
medication_reference = @fhir.reference        ; Reference to Medication resource

; Subject - FHIR: MedicationRequest.subject (required)
subject = !@fhir.reference                    ; Patient for whom medication is requested

; Encounter - FHIR: MedicationRequest.encounter
encounter = @fhir.reference                   ; Encounter context

; Supporting information - FHIR: MedicationRequest.supportingInformation
supporting_information[] = @fhir.reference    ; Supporting information for request

; Authored on - FHIR: MedicationRequest.authoredOn
authored_on = timestamp                       ; When request was initially authored

; Requester - FHIR: MedicationRequest.requester
requester = @fhir.reference                   ; Prescriber/requester

; Performer - FHIR: MedicationRequest.performer
performer = @fhir.reference                   ; Intended performer of administration

; Performer type - FHIR: MedicationRequest.performerType
performer_type = @fhir.codeable_concept       ; Kind of performer

; Recorder - FHIR: MedicationRequest.recorder
recorder = @fhir.reference                    ; Person who entered request

; Reason codes - FHIR: MedicationRequest.reasonCode
reason_codes[] = @fhir.codeable_concept       ; Reason for ordering medication

; Reason references - FHIR: MedicationRequest.reasonReference
reason_references[] = @fhir.reference         ; Condition/Observation as reason

; Instantiates canonical - FHIR: MedicationRequest.instantiatesCanonical
instantiates_canonical[] = :                  ; Instantiates FHIR protocol/definition

; Instantiates URI - FHIR: MedicationRequest.instantiatesUri
instantiates_uri[] = :                        ; Instantiates external protocol

; Based on - FHIR: MedicationRequest.basedOn
based_on[] = @fhir.reference                  ; What request fulfills

; Group identifier - FHIR: MedicationRequest.groupIdentifier
group_identifier = @fhir.identifier           ; Composite request identifier

; Course of therapy type - FHIR: MedicationRequest.courseOfTherapyType
course_of_therapy_type = @fhir.codeable_concept  ; Overall pattern of medication

; Insurance - FHIR: MedicationRequest.insurance
insurance[] = @fhir.reference                 ; Associated insurance coverage

; Notes - FHIR: MedicationRequest.note
notes[] = @fhir.annotation                    ; Information about prescription

; Dosage instructions - FHIR: MedicationRequest.dosageInstruction
dosage_instructions[] = @fhir.dosage          ; How medication should be taken

; Dispense request - FHIR: MedicationRequest.dispenseRequest
dispense_request = @medication_dispense_request  ; Dispensing authorization

; Substitution - FHIR: MedicationRequest.substitution
substitution = @medication_substitution       ; Substitution preferences

; Prior prescription - FHIR: MedicationRequest.priorPrescription
prior_prescription = @fhir.reference          ; Prior prescription being replaced

; Detected issues - FHIR: MedicationRequest.detectedIssue
detected_issues[] = @fhir.reference           ; Clinical issues with action

; Event history - FHIR: MedicationRequest.eventHistory
event_history[] = @fhir.reference             ; Lifecycle events

; ───────────────────────────────────────────────────────────────────────────────
; Dispense Request - FHIR: MedicationRequest.dispenseRequest
; ───────────────────────────────────────────────────────────────────────────────

{@medication_dispense_request}
; Initial fill - FHIR: MedicationRequest.dispenseRequest.initialFill
{.initial_fill}
quantity = @fhir.simple_quantity              ; First fill quantity
duration = @fhir.duration                     ; First fill duration

{@medication_dispense_request}

; Dispense interval - FHIR: MedicationRequest.dispenseRequest.dispenseInterval
dispense_interval = @fhir.duration            ; Minimum period between dispenses

; Validity period - FHIR: MedicationRequest.dispenseRequest.validityPeriod
validity_period = @fhir.period                ; Time period prescription is valid

; Number of refills - FHIR: MedicationRequest.dispenseRequest.numberOfRepeatsAllowed
refills_allowed = ##:(0..)                    ; Number of refills authorized

; Quantity - FHIR: MedicationRequest.dispenseRequest.quantity
quantity = @fhir.simple_quantity              ; Amount to dispense per fill

; Expected supply duration - FHIR: MedicationRequest.dispenseRequest.expectedSupplyDuration
expected_supply_duration = @fhir.duration     ; Days of supply per fill

; Performer - FHIR: MedicationRequest.dispenseRequest.performer
performer = @fhir.reference                   ; Intended dispenser

; ───────────────────────────────────────────────────────────────────────────────
; Substitution - FHIR: MedicationRequest.substitution
; ───────────────────────────────────────────────────────────────────────────────

{@medication_substitution}
; Allowed - FHIR: MedicationRequest.substitution.allowed[x] (polymorphic)
allowed = ?                                   ; Whether substitution is allowed (boolean)
allowed_codeable_concept = @fhir.codeable_concept  ; Allowed substitution type

; Reason - FHIR: MedicationRequest.substitution.reason
reason = @fhir.codeable_concept               ; Why substitution allowed/not allowed


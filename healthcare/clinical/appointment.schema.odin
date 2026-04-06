; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Healthcare Clinical - Appointment Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Clinical appointment resource representing bookings of healthcare events
; including visits, procedures, and telemedicine appointments. Derived from
; HL7 FHIR R4/R5 (CC0 public domain).
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as fhir

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.clinical.appointment"
version = "1.0.0"
title = "Healthcare Clinical Appointment Schema"
description = "Clinical appointment resource derived from FHIR R4/R5"

{$derivation}
source[0].authority = "HL7"
source[0].citation = "HL7 FHIR R4 - Appointment Resource"
source[0].url = "https://hl7.org/fhir/R4/appointment.html"

source[1].authority = "HL7"
source[1].citation = "HL7 FHIR R5 - Appointment Resource"
source[1].url = "https://hl7.org/fhir/R5/appointment.html"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-20
changelog[0].change = "Initial clinical appointment schema"
changelog[0].rationale = "Appointment resource derived from FHIR R4/R5 specification"

; ═══════════════════════════════════════════════════════════════════════════════
; APPOINTMENT
; ═══════════════════════════════════════════════════════════════════════════════
; FHIR: Appointment - https://hl7.org/fhir/R4/appointment.html
; A booking of a healthcare event

{@appointment}
; Resource metadata
id = !:                                       ; Logical id of resource
meta = @fhir.meta                             ; Resource metadata

; Identifiers - FHIR: Appointment.identifier
identifiers[] = @fhir.identifier              ; External identifiers

; Status - FHIR: Appointment.status (required)
status = !(arrived, booked, cancelled, checked_in, entered_in_error, fulfilled, noshow, pending, proposed, waitlist)

; Cancelation reason - FHIR: Appointment.cancelationReason
cancelation_reason = @fhir.codeable_concept   ; Reason for cancellation

; Service categories - FHIR: Appointment.serviceCategory
service_categories[] = @fhir.codeable_concept ; Broad categorization of service

; Service types - FHIR: Appointment.serviceType
service_types[] = @fhir.codeable_concept      ; Specific service to be performed

; Specialties - FHIR: Appointment.specialty
specialties[] = @fhir.codeable_concept        ; Specialty of practitioner needed

; Appointment type - FHIR: Appointment.appointmentType
appointment_type = @fhir.codeable_concept     ; Style of appointment (routine, urgent)

; Reason codes - FHIR: Appointment.reasonCode
reason_codes[] = @fhir.codeable_concept       ; Coded reason for appointment

; Reason references - FHIR: Appointment.reasonReference
reason_references[] = @fhir.reference         ; Condition/Procedure/Observation/ImmunizationRecommendation

; Priority - FHIR: Appointment.priority
priority = ##:(0..)                           ; Appointment priority (0=routine)

; Description - FHIR: Appointment.description
description = :                               ; Shown on a subject line in meeting

; Supporting information - FHIR: Appointment.supportingInformation
supporting_information[] = @fhir.reference    ; Additional information

; Start - FHIR: Appointment.start
start = timestamp                             ; When appointment begins

; End - FHIR: Appointment.end
end = timestamp                               ; When appointment ends

; Minutes duration - FHIR: Appointment.minutesDuration
minutes_duration = ##:(0..)                   ; Duration in minutes

; Slots - FHIR: Appointment.slot
slots[] = @fhir.reference                     ; Slot(s) appointment fills

; Created - FHIR: Appointment.created
created = timestamp                           ; Date appointment was created

; Comment - FHIR: Appointment.comment
comment = :                                   ; Additional comments

; Patient instruction - FHIR: Appointment.patientInstruction
patient_instruction = :                       ; Instructions for patient

; Based on - FHIR: Appointment.basedOn
based_on[] = @fhir.reference                  ; The ServiceRequest this fulfills

; Participants - FHIR: Appointment.participant (required)
participants[] = @appointment_participant     ; Participants in appointment

; Requested periods - FHIR: Appointment.requestedPeriod
requested_periods[] = @fhir.period            ; Potential date/time for appointment

; ───────────────────────────────────────────────────────────────────────────────
; Appointment Participant - FHIR: Appointment.participant
; ───────────────────────────────────────────────────────────────────────────────

{@appointment_participant}
; Types - FHIR: Appointment.participant.type
types[] = @fhir.codeable_concept              ; Role of participant

; Actor - FHIR: Appointment.participant.actor
actor = @fhir.reference                       ; Person, Location, HealthcareService, Device

; Required - FHIR: Appointment.participant.required
required = (information_only, optional, required)

; Status - FHIR: Appointment.participant.status (required)
status = !(accepted, declined, needs_action, tentative)

; Period - FHIR: Appointment.participant.period
period = @fhir.period                         ; Participation period


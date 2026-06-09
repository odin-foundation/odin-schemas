; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Healthcare Clinical - Service Request Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Clinical service request resource representing orders, referrals, and
; requests for procedures, diagnostics, or consults. Derived from HL7
; FHIR R4/R5 (CC0 public domain).
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as fhir

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.clinical.servicerequest"
version = "1.0.0"
title = "Healthcare Clinical Service Request Schema"
description = "Clinical service request (orders/referrals) resource derived from FHIR R4/R5"

{$derivation}
source[0].authority = "HL7"
source[0].citation = "HL7 FHIR R4 - ServiceRequest Resource"
source[0].url = "https://hl7.org/fhir/R4/servicerequest.html"

source[1].authority = "HL7"
source[1].citation = "HL7 FHIR R5 - ServiceRequest Resource"
source[1].url = "https://hl7.org/fhir/R5/servicerequest.html"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-20
changelog[0].change = "Initial clinical service request schema"
changelog[0].rationale = "ServiceRequest resource derived from FHIR R4/R5 specification"

; ═══════════════════════════════════════════════════════════════════════════════
; SERVICE REQUEST
; ═══════════════════════════════════════════════════════════════════════════════
; FHIR: ServiceRequest - https://hl7.org/fhir/R4/servicerequest.html
; A request for a procedure or diagnostic to be performed

{@service_request}
; Resource metadata
id = :                                       ; Logical id of resource
meta = @fhir.meta                             ; Resource metadata

; Identifiers - FHIR: ServiceRequest.identifier
identifiers[] = @fhir.identifier              ; Identifiers assigned to request

; Instantiates canonical - FHIR: ServiceRequest.instantiatesCanonical
instantiates_canonical[] = :                  ; Instantiates FHIR protocol/definition

; Instantiates URI - FHIR: ServiceRequest.instantiatesUri
instantiates_uri[] = :                        ; Instantiates external protocol

; Based on - FHIR: ServiceRequest.basedOn
based_on[] = @fhir.reference                  ; Fulfills plan/proposal

; Replaces - FHIR: ServiceRequest.replaces
replaces[] = @fhir.reference                  ; Request(s) this replaces

; Requisition - FHIR: ServiceRequest.requisition
requisition = @fhir.identifier                ; Composite request identifier

; Status - FHIR: ServiceRequest.status (required)
status = (active, completed, draft, entered_in_error, on_hold, revoked, unknown)

; Intent - FHIR: ServiceRequest.intent (required)
intent = (directive, filler_order, instance_order, option, order, original_order, plan, proposal, reflex_order)

; Categories - FHIR: ServiceRequest.category
categories[] = @fhir.codeable_concept         ; Classification of service

; Priority - FHIR: ServiceRequest.priority
priority = (asap, routine, stat, urgent)      ; Request priority

; Do not perform - FHIR: ServiceRequest.doNotPerform
do_not_perform = ?                            ; True if service is prohibited

; Code - FHIR: ServiceRequest.code
code = @fhir.codeable_concept                 ; What is being requested

; Order detail - FHIR: ServiceRequest.orderDetail
order_details[] = @fhir.codeable_concept      ; Additional order information

; Quantity - FHIR: ServiceRequest.quantity[x] (polymorphic)
quantity_quantity = @fhir.quantity            ; Service amount as quantity
quantity_ratio = @fhir.ratio                  ; Service amount as ratio
quantity_range = @fhir.range                  ; Service amount as range

; Subject - FHIR: ServiceRequest.subject (required)
subject = @fhir.reference                    ; Individual or entity the service is for

; Encounter - FHIR: ServiceRequest.encounter
encounter = @fhir.reference                   ; Encounter motivating request

; Occurrence - FHIR: ServiceRequest.occurrence[x] (polymorphic)
occurrence_date_time = timestamp              ; When service should occur
occurrence_period = @fhir.period              ; When service should occur
occurrence_timing = @fhir.timing              ; When service should occur

; As needed - FHIR: ServiceRequest.asNeeded[x] (polymorphic)
as_needed = ?                                 ; Preconditions for service
as_needed_codeable_concept = @fhir.codeable_concept  ; Preconditions for service

; Authored on - FHIR: ServiceRequest.authoredOn
authored_on = timestamp                       ; Date request was signed

; Requester - FHIR: ServiceRequest.requester
requester = @fhir.reference                   ; Who/what is requesting service

; Performer type - FHIR: ServiceRequest.performerType
performer_type = @fhir.codeable_concept       ; Type of performer

; Performers - FHIR: ServiceRequest.performer
performers[] = @fhir.reference                ; Requested performer

; Location codes - FHIR: ServiceRequest.locationCode
location_codes[] = @fhir.codeable_concept     ; Requested location

; Location references - FHIR: ServiceRequest.locationReference
location_references[] = @fhir.reference       ; Requested location

; Reason codes - FHIR: ServiceRequest.reasonCode
reason_codes[] = @fhir.codeable_concept       ; Explanation/justification

; Reason references - FHIR: ServiceRequest.reasonReference
reason_references[] = @fhir.reference         ; Explanation/justification

; Insurance - FHIR: ServiceRequest.insurance
insurance[] = @fhir.reference                 ; Associated insurance coverage

; Supporting info - FHIR: ServiceRequest.supportingInfo
supporting_info[] = @fhir.reference           ; Additional clinical information

; Specimens - FHIR: ServiceRequest.specimen
specimens[] = @fhir.reference                 ; Specimens to be tested

; Body sites - FHIR: ServiceRequest.bodySite
body_sites[] = @fhir.codeable_concept         ; Location on body

; Notes - FHIR: ServiceRequest.note
notes[] = @fhir.annotation                    ; Comments about request

; Patient instruction - FHIR: ServiceRequest.patientInstruction
patient_instruction = :                       ; Instructions for patient

; Relevant history - FHIR: ServiceRequest.relevantHistory
relevant_history[] = @fhir.reference          ; Request provenance


; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Healthcare Clinical - Care Plan Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Clinical care plan resource representing how practitioners intend to deliver
; care for a patient, including treatment plans, nursing care plans, and
; integrated care plans. Derived from HL7 FHIR R4/R5 (CC0 public domain).
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as fhir

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.clinical.careplan"
version = "1.0.0"
title = "Healthcare Clinical Care Plan Schema"
description = "Clinical care plan resource derived from FHIR R4/R5"

{$derivation}
source[0].authority = "HL7"
source[0].citation = "HL7 FHIR R4 - CarePlan Resource"
source[0].url = "https://hl7.org/fhir/R4/careplan.html"

source[1].authority = "HL7"
source[1].citation = "HL7 FHIR R5 - CarePlan Resource"
source[1].url = "https://hl7.org/fhir/R5/careplan.html"

source[2].authority = "HL7"
source[2].citation = "US Core CarePlan Profile"
source[2].url = "https://hl7.org/fhir/us/core/StructureDefinition-us-core-careplan.html"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-20
changelog[0].change = "Initial clinical care plan schema"
changelog[0].rationale = "CarePlan resource derived from FHIR R4/R5 specification"

; ═══════════════════════════════════════════════════════════════════════════════
; CARE PLAN
; ═══════════════════════════════════════════════════════════════════════════════
; FHIR: CarePlan - https://hl7.org/fhir/R4/careplan.html
; Intention of how care is to be delivered

{@care_plan}
; Resource metadata
id = !:                                       ; Logical id of resource
meta = @fhir.meta                             ; Resource metadata

; Identifiers - FHIR: CarePlan.identifier
identifiers[] = @fhir.identifier              ; External identifiers

; Instantiates canonical - FHIR: CarePlan.instantiatesCanonical
instantiates_canonical[] = :                  ; Instantiates FHIR protocol/definition

; Instantiates URI - FHIR: CarePlan.instantiatesUri
instantiates_uri[] = :                        ; Instantiates external protocol

; Based on - FHIR: CarePlan.basedOn
based_on[] = @fhir.reference                  ; Fulfills CarePlan

; Replaces - FHIR: CarePlan.replaces
replaces[] = @fhir.reference                  ; CarePlan replaced by this one

; Part of - FHIR: CarePlan.partOf
part_of[] = @fhir.reference                   ; Part of referenced CarePlan

; Status - FHIR: CarePlan.status (required)
status = !(active, completed, draft, entered_in_error, on_hold, revoked, unknown)

; Intent - FHIR: CarePlan.intent (required)
intent = !(option, order, plan, proposal)

; Categories - FHIR: CarePlan.category
categories[] = @fhir.codeable_concept         ; Type of plan

; Title - FHIR: CarePlan.title
title = :                                     ; Human-friendly name for plan

; Description - FHIR: CarePlan.description
description = :                               ; Summary of nature of plan

; Subject - FHIR: CarePlan.subject (required)
subject = !@fhir.reference                    ; Patient for whom plan is created

; Encounter - FHIR: CarePlan.encounter
encounter = @fhir.reference                   ; Encounter creating plan

; Period - FHIR: CarePlan.period
period = @fhir.period                         ; Time period plan covers

; Created - FHIR: CarePlan.created
created = timestamp                           ; Date record was first created

; Author - FHIR: CarePlan.author
author = @fhir.reference                      ; Who is responsible for content

; Contributors - FHIR: CarePlan.contributor
contributors[] = @fhir.reference              ; Who provided plan content

; Care team - FHIR: CarePlan.careTeam
care_teams[] = @fhir.reference                ; Who's involved in plan

; Addresses - FHIR: CarePlan.addresses
addresses[] = @fhir.reference                 ; Conditions plan addresses

; Supporting info - FHIR: CarePlan.supportingInfo
supporting_info[] = @fhir.reference           ; Information considered

; Goals - FHIR: CarePlan.goal
goals[] = @fhir.reference                     ; Desired outcomes

; Activities - FHIR: CarePlan.activity
activities[] = @care_plan_activity            ; Actions to occur

; Notes - FHIR: CarePlan.note
notes[] = @fhir.annotation                    ; Comments about plan

; ───────────────────────────────────────────────────────────────────────────────
; Care Plan Activity - FHIR: CarePlan.activity
; ───────────────────────────────────────────────────────────────────────────────

{@care_plan_activity}
; Outcome codes - FHIR: CarePlan.activity.outcomeCodeableConcept
outcome_codeable_concepts[] = @fhir.codeable_concept  ; Results of activity

; Outcome references - FHIR: CarePlan.activity.outcomeReference
outcome_references[] = @fhir.reference        ; Appointment, Encounter, etc.

; Progress - FHIR: CarePlan.activity.progress
progress[] = @fhir.annotation                 ; Comments about activity status

; Reference - FHIR: CarePlan.activity.reference
reference = @fhir.reference                   ; Activity details in external resource

; Detail - FHIR: CarePlan.activity.detail
detail = @care_plan_activity_detail           ; In-line activity details

; ───────────────────────────────────────────────────────────────────────────────
; Care Plan Activity Detail - FHIR: CarePlan.activity.detail
; ───────────────────────────────────────────────────────────────────────────────

{@care_plan_activity_detail}
; Kind - FHIR: CarePlan.activity.detail.kind
kind = (appointment, communication_request, device_request, medication_request, nutrition_order, service_request, task, vision_prescription)

; Instantiates canonical - FHIR: CarePlan.activity.detail.instantiatesCanonical
instantiates_canonical[] = :                  ; Instantiates FHIR protocol

; Instantiates URI - FHIR: CarePlan.activity.detail.instantiatesUri
instantiates_uri[] = :                        ; Instantiates external protocol

; Code - FHIR: CarePlan.activity.detail.code
code = @fhir.codeable_concept                 ; Detail type of activity

; Reason codes - FHIR: CarePlan.activity.detail.reasonCode
reason_codes[] = @fhir.codeable_concept       ; Why activity should be done

; Reason references - FHIR: CarePlan.activity.detail.reasonReference
reason_references[] = @fhir.reference         ; Condition/Observation/etc.

; Goals - FHIR: CarePlan.activity.detail.goal
goals[] = @fhir.reference                     ; Goals this activity relates to

; Status - FHIR: CarePlan.activity.detail.status (required)
status = !(cancelled, completed, entered_in_error, in_progress, not_started, on_hold, scheduled, stopped, unknown)

; Status reason - FHIR: CarePlan.activity.detail.statusReason
status_reason = @fhir.codeable_concept        ; Reason for current status

; Do not perform - FHIR: CarePlan.activity.detail.doNotPerform
do_not_perform = ?                            ; If true, activity should NOT occur

; Scheduled - FHIR: CarePlan.activity.detail.scheduled[x] (polymorphic)
scheduled_timing = @fhir.timing               ; When activity should occur
scheduled_period = @fhir.period               ; Period for activity
scheduled_string = :                          ; Text description of timing

; Location - FHIR: CarePlan.activity.detail.location
location = @fhir.reference                    ; Where activity should happen

; Performers - FHIR: CarePlan.activity.detail.performer
performers[] = @fhir.reference                ; Who will be responsible

; Product - FHIR: CarePlan.activity.detail.product[x] (polymorphic)
product_codeable_concept = @fhir.codeable_concept  ; What is to be administered/supplied
product_reference = @fhir.reference           ; What is to be administered/supplied

; Daily amount - FHIR: CarePlan.activity.detail.dailyAmount
daily_amount = @fhir.simple_quantity          ; How much to consume/day

; Quantity - FHIR: CarePlan.activity.detail.quantity
quantity = @fhir.simple_quantity              ; How much to administer/supply

; Description - FHIR: CarePlan.activity.detail.description
description = :                               ; Extra info describing activity


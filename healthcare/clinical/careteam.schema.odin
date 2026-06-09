; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Healthcare Clinical - Care Team Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Clinical care team resource representing the composition of practitioners,
; patients, and related persons participating in care coordination. Derived
; from HL7 FHIR R4/R5 (CC0 public domain).
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as fhir

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.clinical.careteam"
version = "1.0.0"
title = "Healthcare Clinical Care Team Schema"
description = "Clinical care team resource derived from FHIR R4/R5"

{$derivation}
source[0].authority = "HL7"
source[0].citation = "HL7 FHIR R4 - CareTeam Resource"
source[0].url = "https://hl7.org/fhir/R4/careteam.html"

source[1].authority = "HL7"
source[1].citation = "HL7 FHIR R5 - CareTeam Resource"
source[1].url = "https://hl7.org/fhir/R5/careteam.html"

source[2].authority = "HL7"
source[2].citation = "US Core CareTeam Profile"
source[2].url = "https://hl7.org/fhir/us/core/StructureDefinition-us-core-careteam.html"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-20
changelog[0].change = "Initial clinical care team schema"
changelog[0].rationale = "CareTeam resource derived from FHIR R4/R5 specification"

; ═══════════════════════════════════════════════════════════════════════════════
; CARE TEAM
; ═══════════════════════════════════════════════════════════════════════════════
; FHIR: CareTeam - https://hl7.org/fhir/R4/careteam.html
; Planned participants in coordinated care for a patient

{@care_team}
; Resource metadata
id = :                                       ; Logical id of resource
meta = @fhir.meta                             ; Resource metadata

; Identifiers - FHIR: CareTeam.identifier
identifiers[] = @fhir.identifier              ; External identifiers

; Status - FHIR: CareTeam.status
status = (active, entered_in_error, inactive, proposed, suspended)

; Categories - FHIR: CareTeam.category
categories[] = @fhir.codeable_concept         ; Type of team (condition, encounter, episode, longitudinal)

; Name - FHIR: CareTeam.name
name = :                                      ; Name of care team

; Subject - FHIR: CareTeam.subject
subject = @fhir.reference                     ; Patient for whom team exists

; Encounter - FHIR: CareTeam.encounter
encounter = @fhir.reference                   ; Encounter creating team

; Period - FHIR: CareTeam.period
period = @fhir.period                         ; Time period team covers

; Participants - FHIR: CareTeam.participant
participants[] = @care_team_participant       ; Members of the team

; Reason codes - FHIR: CareTeam.reasonCode
reason_codes[] = @fhir.codeable_concept       ; Why team exists

; Reason references - FHIR: CareTeam.reasonReference
reason_references[] = @fhir.reference         ; Condition(s) team addresses

; Managing organizations - FHIR: CareTeam.managingOrganization
managing_organizations[] = @fhir.reference    ; Organization(s) responsible

; Telecom - FHIR: CareTeam.telecom
telecoms[] = @fhir.contact_point              ; Contact for the team

; Notes - FHIR: CareTeam.note
notes[] = @fhir.annotation                    ; Comments about team

; ───────────────────────────────────────────────────────────────────────────────
; Care Team Participant - FHIR: CareTeam.participant
; ───────────────────────────────────────────────────────────────────────────────

{@care_team_participant}
roles[] = @fhir.codeable_concept              ; Type of involvement
member = @fhir.reference                      ; Who is involved
on_behalf_of = @fhir.reference                ; Organization of member
period = @fhir.period                         ; Time period of participant


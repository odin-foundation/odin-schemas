; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Healthcare Clinical - Allergy Intolerance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Clinical allergy and intolerance resource recording risk of harmful physiological
; response upon substance exposure. Derived from HL7 FHIR R4/R5 (CC0 public domain).
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as fhir

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.clinical.allergyintolerance"
version = "1.0.0"
title = "Healthcare Clinical Allergy Intolerance Schema"
description = "Clinical allergy/intolerance resource derived from FHIR R4/R5"

{$derivation}
source[0].authority = "HL7"
source[0].citation = "HL7 FHIR R4 - AllergyIntolerance Resource"
source[0].url = "https://hl7.org/fhir/R4/allergyintolerance.html"

source[1].authority = "HL7"
source[1].citation = "HL7 FHIR R5 - AllergyIntolerance Resource"
source[1].url = "https://hl7.org/fhir/R5/allergyintolerance.html"

source[2].authority = "HL7"
source[2].citation = "US Core AllergyIntolerance Profile"
source[2].url = "https://hl7.org/fhir/us/core/StructureDefinition-us-core-allergyintolerance.html"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-20
changelog[0].change = "Initial clinical allergy intolerance schema"
changelog[0].rationale = "AllergyIntolerance resource derived from FHIR R4/R5 specification"

; ═══════════════════════════════════════════════════════════════════════════════
; ALLERGY INTOLERANCE
; ═══════════════════════════════════════════════════════════════════════════════
; FHIR: AllergyIntolerance - https://hl7.org/fhir/R4/allergyintolerance.html
; Allergy or intolerance (generally to food or medication)

{@allergy_intolerance}
; Resource metadata
id = :                                       ; Logical id of resource
meta = @fhir.meta                             ; Resource metadata

; Identifiers - FHIR: AllergyIntolerance.identifier
identifiers[] = @fhir.identifier              ; External identifiers

; Clinical status - FHIR: AllergyIntolerance.clinicalStatus
clinical_status = @fhir.codeable_concept      ; active | inactive | resolved

; Verification status - FHIR: AllergyIntolerance.verificationStatus
verification_status = @fhir.codeable_concept  ; unconfirmed | confirmed | refuted | entered-in-error

; Type - FHIR: AllergyIntolerance.type
type = (allergy, intolerance)                 ; Underlying mechanism

; Category - FHIR: AllergyIntolerance.category
categories[] = (biologic, environment, food, medication)

; Criticality - FHIR: AllergyIntolerance.criticality
criticality = (high, low, unable_to_assess)   ; Potential for clinical harm

; Code - FHIR: AllergyIntolerance.code
code = @fhir.codeable_concept                 ; Code identifying the allergy/intolerance

; Patient - FHIR: AllergyIntolerance.patient (required)
patient = @fhir.reference                    ; Who has the allergy/intolerance

; Encounter - FHIR: AllergyIntolerance.encounter
encounter = @fhir.reference                   ; Encounter when identified

; Onset - FHIR: AllergyIntolerance.onset[x] (polymorphic)
onset_date_time = timestamp                   ; When allergy/intolerance identified
onset_age = @fhir.age                         ; Age when identified
onset_period = @fhir.period                   ; Period when identified
onset_range = @fhir.range                     ; Range when identified
onset_string = :                              ; Text description of onset

; Recorded date - FHIR: AllergyIntolerance.recordedDate
recorded_date = timestamp                     ; Date record was first recorded

; Recorder - FHIR: AllergyIntolerance.recorder
recorder = @fhir.reference                    ; Who recorded the allergy

; Asserter - FHIR: AllergyIntolerance.asserter
asserter = @fhir.reference                    ; Source of information

; Last occurrence - FHIR: AllergyIntolerance.lastOccurrence
last_occurrence = timestamp                   ; Date(/time) of last reaction

; Notes - FHIR: AllergyIntolerance.note
notes[] = @fhir.annotation                    ; Additional information

; Reactions - FHIR: AllergyIntolerance.reaction
reactions[] = @allergy_reaction               ; Adverse reactions

; ───────────────────────────────────────────────────────────────────────────────
; Allergy Reaction - FHIR: AllergyIntolerance.reaction
; ───────────────────────────────────────────────────────────────────────────────

{@allergy_reaction}
; Substance - FHIR: AllergyIntolerance.reaction.substance
substance = @fhir.codeable_concept            ; Specific substance that triggered reaction

; Manifestations - FHIR: AllergyIntolerance.reaction.manifestation (required)
manifestations[] = @fhir.codeable_concept    ; Clinical symptoms/signs observed

; Description - FHIR: AllergyIntolerance.reaction.description
description = :                               ; Description of reaction event

; Onset - FHIR: AllergyIntolerance.reaction.onset
onset = timestamp                             ; When reaction started

; Severity - FHIR: AllergyIntolerance.reaction.severity
severity = (mild, moderate, severe)           ; Severity of the reaction

; Exposure route - FHIR: AllergyIntolerance.reaction.exposureRoute
exposure_route = @fhir.codeable_concept       ; How the subject was exposed

; Notes - FHIR: AllergyIntolerance.reaction.note
notes[] = @fhir.annotation                    ; Additional information


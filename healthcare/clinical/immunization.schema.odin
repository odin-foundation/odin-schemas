; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Healthcare Clinical - Immunization Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Clinical immunization resource representing vaccine administration events
; including routine vaccinations, travel vaccines, and outbreak response.
; Derived from HL7 FHIR R4/R5 (CC0 public domain).
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as fhir

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.clinical.immunization"
version = "1.0.0"
title = "Healthcare Clinical Immunization Schema"
description = "Clinical immunization (vaccination) resource derived from FHIR R4/R5"

{$derivation}
source[0].authority = "HL7"
source[0].citation = "HL7 FHIR R4 - Immunization Resource"
source[0].url = "https://hl7.org/fhir/R4/immunization.html"

source[1].authority = "HL7"
source[1].citation = "HL7 FHIR R5 - Immunization Resource"
source[1].url = "https://hl7.org/fhir/R5/immunization.html"

source[2].authority = "HL7"
source[2].citation = "US Core Immunization Profile"
source[2].url = "https://hl7.org/fhir/us/core/StructureDefinition-us-core-immunization.html"

source[3].authority = "CDC"
source[3].citation = "CDC Vaccine Code Sets (CVX, MVX)"
source[3].url = "https://www.cdc.gov/vaccines/programs/iis/code-sets.html"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-20
changelog[0].change = "Initial clinical immunization schema"
changelog[0].rationale = "Immunization resource derived from FHIR R4/R5 specification"

; ═══════════════════════════════════════════════════════════════════════════════
; IMMUNIZATION
; ═══════════════════════════════════════════════════════════════════════════════
; FHIR: Immunization - https://hl7.org/fhir/R4/immunization.html
; Describes the event of a patient being administered a vaccine

{@immunization}
; Resource metadata
id = !:                                       ; Logical id of resource
meta = @fhir.meta                             ; Resource metadata

; Identifiers - FHIR: Immunization.identifier
identifiers[] = @fhir.identifier              ; Business identifiers

; Status - FHIR: Immunization.status (required)
status = !(completed, entered_in_error, not_done)

; Status reason - FHIR: Immunization.statusReason
status_reason = @fhir.codeable_concept        ; Reason not done (if not_done)

; Vaccine code - FHIR: Immunization.vaccineCode (required)
vaccine_code = !@fhir.codeable_concept        ; Vaccine product administered (CVX)

; Patient - FHIR: Immunization.patient (required)
patient = !@fhir.reference                    ; Who was immunized

; Encounter - FHIR: Immunization.encounter
encounter = @fhir.reference                   ; Encounter during which given

; Occurrence - FHIR: Immunization.occurrence[x] (polymorphic, required)
occurrence_date_time = timestamp              ; Vaccine administration date
occurrence_string = :                         ; Vaccine administration date (string)

; Recorded - FHIR: Immunization.recorded
recorded = timestamp                          ; When immunization was first captured

; Primary source - FHIR: Immunization.primarySource
primary_source = ?                            ; Is this primary source of information

; Report origin - FHIR: Immunization.reportOrigin
report_origin = @fhir.codeable_concept        ; How report was received (if not primary)

; Location - FHIR: Immunization.location
location = @fhir.reference                    ; Where immunization occurred

; Manufacturer - FHIR: Immunization.manufacturer
manufacturer = @fhir.reference                ; Vaccine manufacturer (MVX)

; Lot number - FHIR: Immunization.lotNumber
lot_number = :                                ; Vaccine lot number

; Expiration date - FHIR: Immunization.expirationDate
expiration_date = date                        ; Vaccine expiration date

; Site - FHIR: Immunization.site
site = @fhir.codeable_concept                 ; Body site vaccine was administered

; Route - FHIR: Immunization.route
route = @fhir.codeable_concept                ; Route of administration

; Dose quantity - FHIR: Immunization.doseQuantity
dose_quantity = @fhir.simple_quantity         ; Amount of vaccine administered

; Performers - FHIR: Immunization.performer
performers[] = @immunization_performer        ; Who performed the immunization

; Notes - FHIR: Immunization.note
notes[] = @fhir.annotation                    ; Additional information

; Reason codes - FHIR: Immunization.reasonCode
reason_codes[] = @fhir.codeable_concept       ; Why immunization occurred

; Reason references - FHIR: Immunization.reasonReference
reason_references[] = @fhir.reference         ; Condition/Observation/DiagnosticReport

; Is subpotent - FHIR: Immunization.isSubpotent
subpotent = ?                                 ; Dose potency (true = subpotent)

; Subpotent reasons - FHIR: Immunization.subpotentReason
subpotent_reasons[] = @fhir.codeable_concept  ; Reason for subpotent dose

; Education - FHIR: Immunization.education
education[] = @immunization_education         ; Educational materials presented

; Program eligibility - FHIR: Immunization.programEligibility
program_eligibility[] = @fhir.codeable_concept  ; Patient eligibility for funding program

; Funding source - FHIR: Immunization.fundingSource
funding_source = @fhir.codeable_concept       ; Funding source (private, public)

; Reactions - FHIR: Immunization.reaction
reactions[] = @immunization_reaction          ; Details of reaction

; Protocol applied - FHIR: Immunization.protocolApplied
protocol_applied[] = @immunization_protocol   ; Protocol followed

; ───────────────────────────────────────────────────────────────────────────────
; Immunization Performer - FHIR: Immunization.performer
; ───────────────────────────────────────────────────────────────────────────────

{@immunization_performer}
function = @fhir.codeable_concept             ; Type of performance (ordering, administering)
actor = !@fhir.reference                      ; Practitioner/Organization who performed

; ───────────────────────────────────────────────────────────────────────────────
; Immunization Education - FHIR: Immunization.education
; ───────────────────────────────────────────────────────────────────────────────

{@immunization_education}
document_type = :                             ; Type of educational material
reference = :                                 ; URI of educational material
publication_date = timestamp                  ; Date of publication
presentation_date = timestamp                 ; Date patient was given material

; ───────────────────────────────────────────────────────────────────────────────
; Immunization Reaction - FHIR: Immunization.reaction
; ───────────────────────────────────────────────────────────────────────────────

{@immunization_reaction}
date = timestamp                              ; When reaction started
detail = @fhir.reference                      ; Additional details about reaction
reported = ?                                  ; Was reaction self-reported

; ───────────────────────────────────────────────────────────────────────────────
; Immunization Protocol - FHIR: Immunization.protocolApplied
; ───────────────────────────────────────────────────────────────────────────────

{@immunization_protocol}
series = :                                    ; Name of vaccine series
authority = @fhir.reference                   ; Who is responsible for protocol
target_diseases[] = @fhir.codeable_concept    ; Diseases vaccine protects against

; Dose number - FHIR: Immunization.protocolApplied.doseNumber[x] (polymorphic)
dose_number_positive_int = ##:(1..)           ; Dose number within series
dose_number_string = :                        ; Dose number as text

; Series doses - FHIR: Immunization.protocolApplied.seriesDoses[x] (polymorphic)
series_doses_positive_int = ##:(1..)          ; Recommended total doses
series_doses_string = :                       ; Total doses as text


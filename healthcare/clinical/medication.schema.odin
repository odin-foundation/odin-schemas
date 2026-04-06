; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Healthcare Clinical - Medication Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Clinical medication resource representing medication definitions used for
; prescribing, dispensing, and administering, including manufactured products
; and compound preparations. Derived from HL7 FHIR R4/R5 (CC0 public domain).
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as fhir

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.clinical.medication"
version = "1.0.0"
title = "Healthcare Clinical Medication Schema"
description = "Clinical medication resource derived from FHIR R4/R5"

{$derivation}
source[0].authority = "HL7"
source[0].citation = "HL7 FHIR R4 - Medication Resource"
source[0].url = "https://hl7.org/fhir/R4/medication.html"

source[1].authority = "HL7"
source[1].citation = "HL7 FHIR R5 - Medication Resource"
source[1].url = "https://hl7.org/fhir/R5/medication.html"

source[2].authority = "FDA"
source[2].citation = "National Drug Code Directory"
source[2].url = "https://www.fda.gov/drugs/drug-approvals-and-databases/national-drug-code-directory"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-20
changelog[0].change = "Initial clinical medication schema"
changelog[0].rationale = "Medication resource derived from FHIR R4/R5 specification"

; ═══════════════════════════════════════════════════════════════════════════════
; MEDICATION
; ═══════════════════════════════════════════════════════════════════════════════
; FHIR: Medication - https://hl7.org/fhir/R4/medication.html
; Definition of a medication

{@medication}
; Resource metadata
id = !:                                       ; Logical id of resource
meta = @fhir.meta                             ; Resource metadata

; Identifiers - FHIR: Medication.identifier
identifiers[] = @fhir.identifier              ; Business identifiers

; Code - FHIR: Medication.code
code = @fhir.codeable_concept                 ; Codes identifying medication (RxNorm, NDC)

; Status - FHIR: Medication.status
status = (active, entered_in_error, inactive) ; active | inactive | entered-in-error

; Manufacturer - FHIR: Medication.manufacturer
manufacturer = @fhir.reference                ; Manufacturer of medication

; Form - FHIR: Medication.form
form = @fhir.codeable_concept                 ; Dose form (tablet, capsule, injection, etc.)

; Amount - FHIR: Medication.amount
amount = @fhir.ratio                          ; Amount of drug in package

; Ingredients - FHIR: Medication.ingredient
ingredients[] = @medication_ingredient        ; Active or inactive ingredient

; Batch - FHIR: Medication.batch
batch = @medication_batch                     ; Batch details for manufactured product

; ───────────────────────────────────────────────────────────────────────────────
; Medication Ingredient - FHIR: Medication.ingredient
; ───────────────────────────────────────────────────────────────────────────────

{@medication_ingredient}
; Item - FHIR: Medication.ingredient.item[x] (polymorphic)
item_codeable_concept = @fhir.codeable_concept  ; Ingredient code (e.g., SNOMED)
item_reference = @fhir.reference              ; Reference to Substance/Medication

; Is active - FHIR: Medication.ingredient.isActive
active = ?                                    ; Is this an active ingredient

; Strength - FHIR: Medication.ingredient.strength
strength = @fhir.ratio                        ; Quantity of ingredient

; ───────────────────────────────────────────────────────────────────────────────
; Medication Batch - FHIR: Medication.batch
; ───────────────────────────────────────────────────────────────────────────────

{@medication_batch}
lot_number = :                                ; Identifier assigned to batch
expiration_date = timestamp                   ; When batch expires


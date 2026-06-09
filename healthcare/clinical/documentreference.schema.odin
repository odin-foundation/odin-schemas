; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Healthcare Clinical - Document Reference Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Clinical document reference resource representing references to clinical
; documents including CDA/C-CDA, PDF reports, images, and other content.
; Derived from HL7 FHIR R4/R5 (CC0 public domain).
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as fhir

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.clinical.documentreference"
version = "1.0.0"
title = "Healthcare Clinical Document Reference Schema"
description = "Clinical document reference resource derived from FHIR R4/R5"

{$derivation}
source[0].authority = "HL7"
source[0].citation = "HL7 FHIR R4 - DocumentReference Resource"
source[0].url = "https://hl7.org/fhir/R4/documentreference.html"

source[1].authority = "HL7"
source[1].citation = "HL7 FHIR R5 - DocumentReference Resource"
source[1].url = "https://hl7.org/fhir/R5/documentreference.html"

source[2].authority = "HL7"
source[2].citation = "US Core DocumentReference Profile"
source[2].url = "https://hl7.org/fhir/us/core/StructureDefinition-us-core-documentreference.html"

source[3].authority = "HL7"
source[3].citation = "C-CDA Implementation Guide"
source[3].url = "https://www.hl7.org/implement/standards/product_brief.cfm?product_id=492"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-20
changelog[0].change = "Initial clinical document reference schema"
changelog[0].rationale = "DocumentReference resource derived from FHIR R4/R5 specification"

; ═══════════════════════════════════════════════════════════════════════════════
; DOCUMENT REFERENCE
; ═══════════════════════════════════════════════════════════════════════════════
; FHIR: DocumentReference - https://hl7.org/fhir/R4/documentreference.html
; Reference to a document

{@document_reference}
; Resource metadata
id = :                                       ; Logical id of resource
meta = @fhir.meta                             ; Resource metadata

; Master identifier - FHIR: DocumentReference.masterIdentifier
master_identifier = @fhir.identifier          ; Master version specific identifier

; Identifiers - FHIR: DocumentReference.identifier
identifiers[] = @fhir.identifier              ; Other identifiers

; Status - FHIR: DocumentReference.status (required)
status = (current, entered_in_error, superseded)

; Doc status - FHIR: DocumentReference.docStatus
doc_status = (amended, appended, entered_in_error, final, preliminary)

; Type - FHIR: DocumentReference.type
type = @fhir.codeable_concept                 ; Type of document (LOINC doc type)

; Categories - FHIR: DocumentReference.category
categories[] = @fhir.codeable_concept         ; Categorization of document

; Subject - FHIR: DocumentReference.subject
subject = @fhir.reference                     ; Who/what is the subject

; Date - FHIR: DocumentReference.date
date = timestamp                              ; When document reference created

; Authors - FHIR: DocumentReference.author
authors[] = @fhir.reference                   ; Who/what authored document

; Authenticator - FHIR: DocumentReference.authenticator
authenticator = @fhir.reference               ; Who/what authenticated document

; Custodian - FHIR: DocumentReference.custodian
custodian = @fhir.reference                   ; Organization maintaining document

; Relates to - FHIR: DocumentReference.relatesTo
relates_to[] = @document_reference_relates_to ; Relationships to other documents

; Description - FHIR: DocumentReference.description
description = :                               ; Human-readable description

; Security labels - FHIR: DocumentReference.securityLabel
security_labels[] = @fhir.codeable_concept    ; Document security tags

; Content - FHIR: DocumentReference.content (required)
content[] = @document_reference_content       ; Document content

; Context - FHIR: DocumentReference.context
context = @document_reference_context         ; Clinical context of document

; ───────────────────────────────────────────────────────────────────────────────
; Document Relates To - FHIR: DocumentReference.relatesTo
; ───────────────────────────────────────────────────────────────────────────────

{@document_reference_relates_to}
code = (appends, replaces, signs, transforms)  ; Type of relationship
target = @fhir.reference                     ; Target of relationship

; ───────────────────────────────────────────────────────────────────────────────
; Document Content - FHIR: DocumentReference.content
; ───────────────────────────────────────────────────────────────────────────────

{@document_reference_content}
attachment = @fhir.attachment                ; Where to access document
format = @fhir.coding                         ; Format/content rules

; ───────────────────────────────────────────────────────────────────────────────
; Document Context - FHIR: DocumentReference.context
; ───────────────────────────────────────────────────────────────────────────────

{@document_reference_context}
encounters[] = @fhir.reference                ; Encounter during which created
events[] = @fhir.codeable_concept             ; Main clinical acts documented
period = @fhir.period                         ; Time of service documented
facility_type = @fhir.codeable_concept        ; Kind of facility
practice_setting = @fhir.codeable_concept     ; Additional specialty context
source_patient_info = @fhir.reference         ; Patient demographics from source
related[] = @fhir.reference                   ; Related resources


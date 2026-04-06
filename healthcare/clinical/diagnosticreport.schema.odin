; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Healthcare Clinical - Diagnostic Report Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Clinical diagnostic report resource representing findings and interpretation
; of diagnostic tests including laboratory, imaging, and other clinical reports.
; Derived from HL7 FHIR R4/R5 (CC0 public domain).
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as fhir

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.clinical.diagnosticreport"
version = "1.0.0"
title = "Healthcare Clinical Diagnostic Report Schema"
description = "Clinical diagnostic report resource derived from FHIR R4/R5"

{$derivation}
source[0].authority = "HL7"
source[0].citation = "HL7 FHIR R4 - DiagnosticReport Resource"
source[0].url = "https://hl7.org/fhir/R4/diagnosticreport.html"

source[1].authority = "HL7"
source[1].citation = "HL7 FHIR R5 - DiagnosticReport Resource"
source[1].url = "https://hl7.org/fhir/R5/diagnosticreport.html"

source[2].authority = "HL7"
source[2].citation = "US Core DiagnosticReport Profiles"
source[2].url = "https://hl7.org/fhir/us/core/StructureDefinition-us-core-diagnosticreport-lab.html"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-20
changelog[0].change = "Initial clinical diagnostic report schema"
changelog[0].rationale = "DiagnosticReport resource derived from FHIR R4/R5 specification"

; ═══════════════════════════════════════════════════════════════════════════════
; DIAGNOSTIC REPORT
; ═══════════════════════════════════════════════════════════════════════════════
; FHIR: DiagnosticReport - https://hl7.org/fhir/R4/diagnosticreport.html
; Findings and interpretation of diagnostic tests

{@diagnostic_report}
; Resource metadata
id = !:                                       ; Logical id of resource
meta = @fhir.meta                             ; Resource metadata

; Identifiers - FHIR: DiagnosticReport.identifier
identifiers[] = @fhir.identifier              ; Business identifiers

; Based on - FHIR: DiagnosticReport.basedOn
based_on[] = @fhir.reference                  ; What was requested

; Status - FHIR: DiagnosticReport.status (required)
status = !(amended, appended, cancelled, corrected, entered_in_error, final, partial, preliminary, registered, unknown)

; Categories - FHIR: DiagnosticReport.category
categories[] = @fhir.codeable_concept         ; Service category (LAB, RAD, etc.)

; Code - FHIR: DiagnosticReport.code (required)
code = !@fhir.codeable_concept                ; Name/code for report (LOINC)

; Subject - FHIR: DiagnosticReport.subject
subject = @fhir.reference                     ; Subject of report (patient)

; Encounter - FHIR: DiagnosticReport.encounter
encounter = @fhir.reference                   ; Healthcare event context

; Effective - FHIR: DiagnosticReport.effective[x] (polymorphic)
effective_date_time = timestamp               ; Clinically relevant time
effective_period = @fhir.period               ; Clinically relevant period

; Issued - FHIR: DiagnosticReport.issued
issued = timestamp                            ; DateTime report was released

; Performers - FHIR: DiagnosticReport.performer
performers[] = @fhir.reference                ; Responsible practitioners

; Results interpreter - FHIR: DiagnosticReport.resultsInterpreter
results_interpreters[] = @fhir.reference      ; Primary result interpreters

; Specimens - FHIR: DiagnosticReport.specimen
specimens[] = @fhir.reference                 ; Specimens this report is based on

; Results - FHIR: DiagnosticReport.result
results[] = @fhir.reference                   ; Observations (lab values, findings)

; Imaging study - FHIR: DiagnosticReport.imagingStudy
imaging_studies[] = @fhir.reference           ; Reference to full imaging study

; Media - FHIR: DiagnosticReport.media
media[] = @diagnostic_report_media            ; Key images associated with report

; Conclusion - FHIR: DiagnosticReport.conclusion
conclusion = :                                ; Clinical conclusion (free text)

; Conclusion codes - FHIR: DiagnosticReport.conclusionCode
conclusion_codes[] = @fhir.codeable_concept   ; Coded diagnoses/conclusions

; Presented form - FHIR: DiagnosticReport.presentedForm
presented_forms[] = @fhir.attachment          ; Entire report as rendered document

; ───────────────────────────────────────────────────────────────────────────────
; Diagnostic Report Media - FHIR: DiagnosticReport.media
; ───────────────────────────────────────────────────────────────────────────────

{@diagnostic_report_media}
comment = :                                   ; Comment about media
link = !@fhir.reference                       ; Reference to media


; ===================================================================================
; ODIN Manufacturing Quality Schema
; ===================================================================================
; Quality management including inspections, non-conformance reports, and
; corrective/preventive actions.
; ===================================================================================

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.manufacturing.quality"
version = "1.0.0"
title = "Manufacturing Quality Schema"
description = "Quality inspections, NCRs, and corrective actions"

{$derivation}
source[0].authority = "ISO"
source[0].citation = "ISO 9001:2015 Quality Management Systems"
source[0].url = "https://www.iso.org/iso-9001-quality-management.html"

source[1].authority = "ASQ"
source[1].citation = "Quality Management Standards"
source[1].url = "https://asq.org/quality-resources"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial manufacturing quality schema"
changelog[0].rationale = "Quality structures derived from ISO 9001 standards"

; ===================================================================================
; INSPECTION
; ===================================================================================

{@inspection}
= @types.audit_info

inspection_id = :                               ; Inspection identifier
inspection_type = (final, first_article, in_process, receiving, source)
product_id = :                                  ; Product inspected
lot_number = :                                   ; Lot/batch number

inspection_date = date                          ; Inspection date
inspector = :                                   ; Inspector ID
result = (accepted, conditionally_accepted, pending, rejected)

; Quantities
quantity_inspected = #:(0..)                     ; Quantity inspected
quantity_accepted = #:(0..)                      ; Quantity accepted
quantity_rejected = #:(0..)                      ; Quantity rejected

; Measurements
measurements[] = @measurement                    ; Inspection measurements
notes = :                                        ; Inspection notes

; ===================================================================================
; MEASUREMENT
; ===================================================================================

{@measurement}
characteristic = :                              ; Characteristic measured
specification = :                                ; Specification reference
nominal = #                                      ; Nominal value
lower_limit = #                                  ; Lower limit
upper_limit = #                                  ; Upper limit
actual_value = #                                 ; Measured value
unit = :                                         ; Unit of measure
in_spec = ?                                      ; Within specification

; ===================================================================================
; NONCONFORMANCE
; ===================================================================================

{@nonconformance}
= @types.audit_info

ncr_id = :                                      ; NCR identifier
ncr_number = :                                  ; NCR number
status = (closed, in_review, open, pending_capa)

product_id = :                                  ; Product affected
lot_number = :                                   ; Lot/batch number
quantity_affected = #:(0..)                      ; Quantity affected

; Discovery
discovered_date = date                          ; Date discovered
discovered_by = :                               ; Discovered by
discovery_location = :                           ; Discovery location
operation = :                                    ; Operation where discovered

; Description
defect_type = (cosmetic, dimensional, functional, material, other)
description = :                                 ; Defect description
root_cause = :                                   ; Root cause analysis
severity = (critical, major, minor)

; Disposition
disposition = (rework, return_to_supplier, scrap, use_as_is, none)
disposition_date = date                          ; Disposition date
disposition_by = :                               ; Disposition authority

corrective_action = @corrective_action           ; Related CAPA

; ===================================================================================
; CORRECTIVE ACTION
; ===================================================================================

{@corrective_action}
= @types.audit_info

capa_id = :                                     ; CAPA identifier
capa_type = (corrective, preventive)
status = (closed, in_progress, open, verified)

description = :                                 ; Action description
assigned_to = :                                 ; Assigned responsibility
due_date = date                                 ; Due date
completion_date = date                           ; Completion date

root_cause = :                                   ; Root cause
action_taken = :                                 ; Action taken
effectiveness_verified = ?                       ; Effectiveness verified
verified_by = :                                  ; Verified by
verified_date = date                             ; Verification date

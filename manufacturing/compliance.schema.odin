; ===================================================================================
; ODIN Manufacturing Compliance Schema
; ===================================================================================
; Regulatory compliance, certifications, audits, and engineering change management
; for manufacturing operations.
; ===================================================================================

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.manufacturing.compliance"
version = "1.0.0"
title = "Manufacturing Compliance Schema"
description = "Certifications, audits, and engineering change management"

{$derivation}
source[0].authority = "ISO"
source[0].citation = "ISO 9001:2015 Quality Management Systems"
source[0].url = "https://www.iso.org/iso-9001-quality-management.html"

source[1].authority = "SAE"
source[1].citation = "SAE AS9100 Quality Management"
source[1].url = "https://www.sae.org/standards/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial manufacturing compliance schema"
changelog[0].rationale = "Compliance structures derived from ISO and SAE standards"

; ===================================================================================
; CERTIFICATION
; ===================================================================================

{@certification}
= @types.audit_info

certification_id = :                            ; Certification ID
certification_type = (as9100, iatf_16949, iso_13485, iso_14001, iso_9001, nadcap)
standard = :                                    ; Standard reference
scope = :                                        ; Certification scope

registrar = :                                   ; Registrar/certifying body
certificate_number = :                          ; Certificate number

issue_date = date                               ; Issue date
expiration_date = date                          ; Expiration date
last_audit_date = date                           ; Last audit date
next_audit_date = date                           ; Next surveillance audit

status = (active, expired, suspended, withdrawn)

; ===================================================================================
; AUDIT
; ===================================================================================

{@audit}
= @types.audit_info

audit_id = :                                    ; Audit ID
audit_type = (customer, external, internal, registrar, regulatory, supplier)
audit_date = date                               ; Audit date
auditor = :                                     ; Auditor name/firm

scope = :                                        ; Audit scope
standard = :                                     ; Standard audited against
status = (closed, completed, in_progress, scheduled)

; Results
result = (approved, conditionally_approved, disapproved, na)
major_findings = ##:(0..)                        ; Major findings count
minor_findings = ##:(0..)                        ; Minor findings count
observations = ##:(0..)                          ; Observations count

findings[] = @audit_finding                      ; Audit findings
report_reference = :                             ; Audit report reference

; ===================================================================================
; AUDIT FINDING
; ===================================================================================

{@audit_finding}
finding_id = :                                  ; Finding ID
finding_type = (major_nc, minor_nc, observation, opportunity)
clause = :                                       ; Standard clause reference
description = :                                 ; Finding description

status = (closed, open, pending_verification)
root_cause = :                                   ; Root cause
corrective_action = :                            ; Corrective action
due_date = date                                  ; Due date
closure_date = date                              ; Closure date
verified_by = :                                  ; Verified by

; ===================================================================================
; ENGINEERING CHANGE
; ===================================================================================

{@engineering_change}
eco_number = :                                  ; ECO/ECN number
title = :                                       ; Change title
description = :                                 ; Change description

change_type = (design, documentation, material, process)
priority = (critical, high, low, medium)
status = (approved, cancelled, closed, implemented, pending, rejected, under_review)

; Requestor
requested_by = :                                ; Requestor
request_date = date                             ; Request date
reason = :                                      ; Reason for change

; Affected items
affected_products[] = :                          ; Affected product IDs
affected_documents[] = :                         ; Affected documents
bom_changes = ?                                  ; BOM changes required
routing_changes = ?                              ; Routing changes required

; Impact
cost_impact = #$                                 ; Cost impact estimate
schedule_impact_days = ##                        ; Schedule impact (days)
quality_impact = (high, low, medium, none)

; Approvals
approvers[] = :                                  ; Required approvers
approval_date = date                             ; Approval date
approved_by = :                                  ; Approved by

; Implementation
effective_date = date                            ; Effective date
implementation_date = date                       ; Implementation date
implemented_by = :                               ; Implemented by

; Disposition
existing_inventory = (rework, scrap, use_as_is)
existing_wip = (complete_as_is, rework, scrap)

; ===================================================================================
; ODIN Construction Submittal Schema
; ===================================================================================
; Submittals, shop drawings, product data, and approval workflow.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.construction.submittal"
version = "1.0.0"
title = "Construction Submittal Schema"
description = "Submittals, shop drawings, and approvals"

{$derivation}
source[0].authority = "AIA"
source[0].citation = "AIA G810 Transmittal Letter"
source[0].url = "https://www.aiacontracts.org/"

source[1].authority = "CSI"
source[1].citation = "CSI SectionFormat for Submittals"
source[1].url = "https://www.csiresources.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial construction submittal schema"
changelog[0].rationale = "Submittal structures for construction operations"

; ===================================================================================
; SUBMITTAL
; ===================================================================================

{@submittal}
= @types.audit_info

submittal_id = :                               ; Submittal identifier
project_id = :                                 ; Project reference
submittal_number = :                           ; Submittal number
revision = : "0"                                ; Revision number

title = :                                      ; Submittal title
description = :                                 ; Description

submittal_type = (certificate, color_chart, maintenance_data, manufacturer_data, mock_up, product_data, sample, shop_drawing, test_report, warranty)

; Specification reference
spec_section = :                               ; Specification section
spec_paragraph = :                              ; Specification paragraph

; Contractor
contractor_id = :                              ; Submitting contractor
contractor_name = :                             ; Contractor name
subcontractor_id = :                            ; Subcontractor
subcontractor_name = :                          ; Subcontractor name

; Dates
required_date = date                            ; Required on site date
lead_time = ##:(0..)                            ; Lead time in days
submitted_date = date                           ; Submitted date
due_date = date                                 ; Review due date
returned_date = date                            ; Returned date

; Review
reviewer = :                                    ; Current reviewer
review_days = ##:(0..)                          ; Days in review
review_time_used = ##:(0..)                     ; Review time used

; Status
status = (approved, approved_as_noted, cancelled, closed, draft, in_review, pending, rejected, resubmit, revise_resubmit)

; Ball in court
ball_in_court = :                               ; Current responsible party
ball_in_court_type = (architect, consultant, contractor, owner)

; Priority
priority = (high, low, normal, urgent)
critical = ?                                    ; Critical submittal

; Review action
action_taken = (approved, approved_as_noted, no_exceptions, not_reviewed, rejected, revise_resubmit)
reviewer_comments = :                           ; Reviewer comments
stamped_date = date                             ; Stamp date
stamped_by = :                                  ; Stamped by

; Files
file_count = ##:(0..)                           ; Number of files
copies_required = ##:(1..)                      ; Copies required

items[] = @submittal_item                       ; Submittal items
history[] = @submittal_history                  ; Review history

; ===================================================================================
; SUBMITTAL ITEM
; ===================================================================================

{@submittal_item}
item_number = ##:(1..)                         ; Item number
product = :                                    ; Product/material
manufacturer = :                                ; Manufacturer
model_number = :                                ; Model number
description = :                                 ; Description

status = (approved, approved_as_noted, rejected, revise)
comments = :                                    ; Comments

; ===================================================================================
; SUBMITTAL HISTORY
; ===================================================================================

{@submittal_history}
revision = :                                   ; Revision
action = (approved, approved_as_noted, forwarded, received, rejected, returned, resubmitted, submitted)
action_date = timestamp                        ; Action date
action_by = :                                  ; Action by
action_by_company = :                           ; Company
comments = :                                    ; Comments

; ===================================================================================
; SUBMITTAL PACKAGE
; ===================================================================================

{@submittal_package}
package_id = :                                 ; Package identifier
project_id = :                                 ; Project reference
package_number = :                             ; Package number
package_name = :                               ; Package name

; Scope
description = :                                 ; Package description
spec_sections[] = :                             ; Specification sections
trades[] = :                                    ; Trades included

; Schedule
required_date = date                            ; Required date
submitted_date = date                           ; Submitted date
status = (approved, in_review, open, partial, pending)

submittals[] = @submittal                       ; Submittals in package

; Statistics
total_submittals = ##:(0..)                     ; Total submittals
approved = ##:(0..)                             ; Approved count
pending = ##:(0..)                              ; Pending count
rejected = ##:(0..)                             ; Rejected count

; ===================================================================================
; SUBMITTAL REGISTER
; ===================================================================================

{@submittal_register}
register_id = :                                ; Register identifier
project_id = :                                 ; Project reference
created = timestamp                        ; Created date
updated = timestamp                        ; Last updated

; Summary
total_required = ##:(0..)                       ; Total required
total_submitted = ##:(0..)                      ; Total submitted
total_approved = ##:(0..)                       ; Total approved
total_pending = ##:(0..)                        ; Total pending
total_overdue = ##:(0..)                        ; Total overdue

entries[] = @submittal_register_entry           ; Register entries

; ===================================================================================
; SUBMITTAL REGISTER ENTRY
; ===================================================================================

{@submittal_register_entry}
spec_section = :                               ; Specification section
section_title = :                               ; Section title
submittal_description = :                       ; Required submittal

required = ?                                    ; Required Y/N
submittal_number = :                            ; Submittal number (when submitted)
status = (approved, not_required, not_submitted, pending, submitted)

responsible_contractor = :                      ; Responsible contractor
required_date = date                            ; Required date
submitted_date = date                           ; Submitted date
approved_date = date                            ; Approved date

notes = :                                       ; Notes

; ===================================================================================
; TRANSMITTAL
; ===================================================================================

{@transmittal}
= @types.audit_info

transmittal_id = :                             ; Transmittal identifier
project_id = :                                 ; Project reference
transmittal_number = :                         ; Transmittal number

transmittal_type = (correspondence, drawing, misc, report, sample, shop_drawing, specification, submittal)
subject = :                                    ; Subject

; From/To
from_company = :                               ; From company
from_contact = :                                ; From contact
to_company = :                                 ; To company
to_contact = :                                  ; To contact

cc[] = :                                        ; CC list

transmittal_date = date                        ; Transmittal date
via = (courier, email, ftp, hand, mail, overnight)

; Purpose
purpose = (approval, as_requested, distribution, for_record, for_review, information, resubmittal)
action_required = ?                             ; Action required
response_required_by = date                     ; Response required by

remarks = :                                     ; Remarks

items[] = @transmittal_item                     ; Items transmitted

; ===================================================================================
; TRANSMITTAL ITEM
; ===================================================================================

{@transmittal_item}
item_number = ##:(1..)                         ; Item number
document_number = :                             ; Document number
revision = :                                    ; Revision
title = :                                      ; Title/description
copies = ##:(1..) "1"                           ; Number of copies
format = (digital, hard_copy, both)


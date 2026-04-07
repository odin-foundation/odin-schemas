; ===================================================================================
; ODIN Construction Closeout Schema
; ===================================================================================
; Punch lists, warranties, as-builts, and project closeout.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.construction.closeout"
version = "1.0.0"
title = "Construction Closeout Schema"
description = "Project closeout, punch lists, and warranties"

{$derivation}
source[0].authority = "AIA"
source[0].citation = "AIA A201 General Conditions - Closeout"
source[0].url = "https://aiacontracts.com/"

source[1].authority = "CSI"
source[1].citation = "CSI Division 01 7800 Closeout Submittals"
source[1].url = "https://www.csiresources.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial construction closeout schema"
changelog[0].rationale = "Closeout structures for construction operations"

; ===================================================================================
; CLOSEOUT
; ===================================================================================

{@closeout}
= @types.audit_info

closeout_id = :                                ; Closeout identifier
project_id = :                                 ; Project reference

; Dates
substantial_completion_date = date              ; Substantial completion
final_completion_date = date                    ; Final completion
certificate_of_occupancy = date                 ; Certificate of occupancy

; Checklists
punchlist_complete = ?                          ; Punch list complete
submittals_complete = ?                         ; Closeout submittals complete
training_complete = ?                           ; Training complete
warranties_received = ?                         ; Warranties received
as_builts_received = ?                          ; As-builts received
o_and_m_manuals = ?                             ; O&M manuals received
spare_parts_delivered = ?                       ; Spare parts/attic stock delivered
keys_delivered = ?                              ; Keys delivered
final_cleaning = ?                              ; Final cleaning complete

; Financial
final_pay_app_submitted = ?                     ; Final pay app submitted
final_pay_app_approved = ?                      ; Final pay app approved
retainage_released = ?                          ; Retainage released
final_lien_waivers = ?                          ; Final lien waivers received

; Status
percent_complete = #:(0..100)                   ; Closeout percent complete
status = (closed, final_completion, in_progress, substantial_completion)

closeout_manager = :                            ; Closeout manager
target_close_date = date                        ; Target close date
actual_close_date = date                        ; Actual close date

items[] = @closeout_item                        ; Closeout items/checklist

; ===================================================================================
; CLOSEOUT ITEM
; ===================================================================================

{@closeout_item}
item_id = :                                    ; Item identifier
category = (as_built, commissioning, document, financial, inspection, punch, training, warranty)
description = :                                ; Item description
spec_section = :                                ; Specification section

responsible_party = :                           ; Responsible party
due_date = date                                 ; Due date
completed_date = date                           ; Completed date
verified_by = :                                 ; Verified by

status = (complete, in_progress, not_applicable, pending)
notes = :                                       ; Notes

; ===================================================================================
; PUNCH LIST
; ===================================================================================

{@punch_list}
= @types.audit_info

punchlist_id = :                               ; Punch list identifier
project_id = :                                 ; Project reference
punchlist_number = :                           ; Punch list number
punchlist_type = (final, pre_final, substantial_completion, walk_through)

title = :                                       ; Punch list title
area = :                                        ; Area/zone
floor = :                                       ; Floor

created = date                            ; Created date
created_by = :                                 ; Created by
walk_date = date                                ; Walk-through date
due_date = date                                 ; Completion due date

; Counts
total_items = ##:(0..)                          ; Total items
open_items = ##:(0..)                           ; Open items
completed_items = ##:(0..)                      ; Completed items

status = (closed, draft, issued, in_progress)
closed_date = date                              ; Closed date

items[] = @punch_item                           ; Punch items

; ===================================================================================
; PUNCH ITEM
; ===================================================================================

{@punch_item}
item_id = :                                    ; Item identifier
item_number = ##:(1..)                         ; Item number

; Location
area = :                                        ; Area
room = :                                        ; Room/space
floor = :                                       ; Floor
grid_location = :                               ; Grid location

; Issue
trade = :                                      ; Trade/CSI division
contractor = :                                  ; Responsible contractor
description = :                                ; Item description
spec_section = :                                ; Spec section reference

priority = (critical, high, low, normal)
category = (adjustment, cleaning, damage, incomplete, missing, quality)

; Photos
photo_before = :                                ; Before photo
photo_after = :                                 ; After photo

; Status
status = (accepted, complete, disputed, in_progress, open, reinspection)
assigned_date = date                            ; Assigned date
due_date = date                                 ; Due date
completed_date = date                           ; Completed date
verified_date = date                            ; Verified date
verified_by = :                                 ; Verified by

notes = :                                       ; Notes
contractor_response = :                         ; Contractor response

back_charge = ?                                 ; Back charge
back_charge_amount = #$:(0..)                   ; Back charge amount

; ===================================================================================
; WARRANTY
; ===================================================================================

{@warranty}
= @types.audit_info

warranty_id = :                                ; Warranty identifier
project_id = :                                 ; Project reference
warranty_number = :                             ; Warranty number

; Item covered
description = :                                ; Description
equipment = :                                   ; Equipment/system name
manufacturer = :                                ; Manufacturer
model_number = :                                ; Model number
serial_number = :                               ; Serial number
location = :                                    ; Location

; Warranty details
warranty_type = (equipment, extended, labor, labor_and_material, manufacturer, parts)
coverage = :                                    ; Coverage description

start_date = date                              ; Start date
end_date = date                                ; End date
duration_months = ##:(0..)                      ; Duration in months

; Provider
warrantor = :                                   ; Warrantor/provider
contact_name = :                                ; Contact name
contact_phone = @types.phone                    ; Contact phone
contact_email = @types.email                    ; Contact email

; Subcontractor
contractor = :                                  ; Installing contractor
contractor_contact = :                          ; Contractor contact
contractor_phone = @types.phone                 ; Contractor phone

; Documents
spec_section = :                                ; Specification section
document_path = :                               ; Warranty document path

status = (active, expired, pending, voided)
reminder_date = date                            ; Reminder before expiration

claims[] = @warranty_claim                      ; Warranty claims

; ===================================================================================
; WARRANTY CLAIM
; ===================================================================================

{@warranty_claim}
claim_id = :                                   ; Claim identifier
warranty_id = :                                ; Warranty reference

claim_date = date                              ; Claim date
reported_by = :                                 ; Reported by
description = :                                ; Issue description
location = :                                    ; Location of issue

; Response
response_date = date                            ; Response date
repair_date = date                              ; Repair date
repaired_by = :                                 ; Repaired by
repair_description = :                          ; Repair description
parts_replaced = :                              ; Parts replaced

; Costs (if not covered)
labor_cost = #$:(0..)                           ; Labor cost
parts_cost = #$:(0..)                           ; Parts cost
total_cost = #$:(0..)                           ; Total cost
covered = ?                                     ; Covered by warranty

status = (closed, denied, open, pending)
resolution = :                                  ; Resolution notes

; ===================================================================================
; AS-BUILT DOCUMENT
; ===================================================================================

{@as_built}
as_built_id = :                                ; As-built identifier
project_id = :                                 ; Project reference

document_type = (drawing, model, record, specification)
discipline = :(architectural, civil, electrical, mechanical, plumbing, structural)

drawing_number = :                              ; Drawing number
drawing_title = :                               ; Drawing title
original_revision = :                           ; Original revision
as_built_revision = :                           ; As-built revision

; Changes
change_description = :                          ; Description of changes
marked_up_by = :                                ; Marked up by
markup_date = date                              ; Markup date

; Submitted
contractor = :                                  ; Submitting contractor
submitted_date = date                           ; Submitted date
reviewed_by = :                                 ; Reviewed by
review_date = date                              ; Review date

file_path = :                                   ; File path
file_format = :(dwf, dwg, pdf, rvt)

status = (accepted, pending, rejected, submitted)

; ===================================================================================
; O&M MANUAL
; ===================================================================================

{@om_manual}
manual_id = :                                  ; Manual identifier
project_id = :                                 ; Project reference

system = :                                     ; System/equipment
description = :                                 ; Description
spec_section = :                                ; Specification section

; Contents
manufacturer = :                                ; Manufacturer
model_number = :                                ; Model number
serial_number = :                               ; Serial number

; Manual components
product_data = ?                                ; Product data included
installation_instructions = ?                   ; Installation instructions
operation_procedures = ?                        ; Operation procedures
maintenance_schedule = ?                        ; Maintenance schedule
troubleshooting = ?                             ; Troubleshooting guide
parts_list = ?                                  ; Parts list
wiring_diagrams = ?                             ; Wiring diagrams
warranty_info = ?                               ; Warranty information

; Submission
contractor = :                                  ; Submitting contractor
submitted_date = date                           ; Submitted date
reviewed_by = :                                 ; Reviewed by
review_date = date                              ; Review date

copies = ##:(1..)                               ; Number of copies
format = (digital, hard_copy, both)
file_path = :                                   ; File path

status = (accepted, pending, rejected, submitted)

; ===================================================================================
; TRAINING SESSION
; ===================================================================================

{@closeout_training}
training_id = :                                ; Training identifier
project_id = :                                 ; Project reference

system = :                                     ; System/equipment
training_type = (maintenance, operation, safety)
description = :                                 ; Training description
spec_section = :                                ; Specification section

; Schedule
scheduled_date = date                           ; Scheduled date
scheduled_time = time                           ; Scheduled time
duration_hours = #:(0..)                        ; Duration in hours
location = :                                    ; Training location

; Trainer
trainer = :                                     ; Trainer name
trainer_company = :                             ; Trainer company
trainer_phone = @types.phone                    ; Trainer phone

; Attendees
attendees_required = ##:(0..)                   ; Required attendees
attendees_actual = ##:(0..)                     ; Actual attendees
attendee_list[] = :                             ; Attendee names

; Documentation
video_recorded = ?                              ; Video recorded
video_path = :                                  ; Video file path
handouts_provided = ?                           ; Handouts provided
sign_in_sheet = :                               ; Sign-in sheet path

status = (cancelled, completed, scheduled)
completed_date = date                           ; Completed date


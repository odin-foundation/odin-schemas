; ===================================================================================
; ODIN Construction Project Schema
; ===================================================================================
; Construction projects, phases, milestones, and project management.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.construction.project"
version = "1.0.0"
title = "Construction Project Schema"
description = "Construction projects and project management"

{$derivation}
source[0].authority = "AIA"
source[0].citation = "AIA Contract Documents"
source[0].url = "https://aiacontracts.com/"

source[1].authority = "CSI"
source[1].citation = "Construction Specifications Institute"
source[1].url = "https://www.csiresources.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial construction project schema"
changelog[0].rationale = "Project structures for construction operations"

; ===================================================================================
; PROJECT
; ===================================================================================

{@project}
= @types.audit_info

project_id = !:                                 ; Project identifier
project_number = :                              ; Project number
project_name = :                               ; Project name
project_type = (commercial, industrial, infrastructure, institutional, residential)

status = (active, bid, cancelled, closeout, complete, design, on_hold, preconstruction)

; Description
description = :                                 ; Project description
scope_summary = :                               ; Scope summary

; Client
owner_id = :                                    ; Owner/client
owner_name = :                                  ; Owner name
owner_contact = :                               ; Owner contact

; Location
location = @types.address                       ; Project address
latitude = #:(-90..90)                          ; Latitude
longitude = #:(-180..180)                       ; Longitude

; Team
project_manager = :                             ; Project manager
superintendent = :                              ; Superintendent
project_engineer = :                            ; Project engineer

; Contract
contract_type = (cost_plus, design_build, gmp, lump_sum, time_and_materials, unit_price)
contract_value = #$:(0..)                       ; Original contract value
current_contract_value = #$:(0..)               ; Current contract value

; Dates
bid_date = date                                 ; Bid date
award_date = date                               ; Award date
notice_to_proceed = date                        ; Notice to proceed
start_date = date                               ; Start date
substantial_completion = date                   ; Substantial completion
final_completion = date                         ; Final completion

; Size
gross_sqft = #:(0..)                            ; Gross square feet
stories = ##:(1..)                              ; Number of stories

phases[] = @phase                               ; Project phases
milestones[] = @milestone                       ; Project milestones
team[] = @project_team_member                   ; Project team
documents[] = @project_document                 ; Project documents

; ===================================================================================
; PHASE
; ===================================================================================

{@phase}
phase_id = !:                                   ; Phase identifier
phase_name = :                                  ; Phase name
phase_number = ##:(1..)                         ; Phase number
phase_type = (construction, design, permitting, preconstruction, warranty)

status = (complete, in_progress, not_started, on_hold)

start_date = date                               ; Planned start
end_date = date                                 ; Planned end
actual_start = date                             ; Actual start
actual_end = date                               ; Actual end

budget = #$:(0..)                               ; Phase budget
actual_cost = #$:(0..)                          ; Actual cost to date
percent_complete = #:(0..100)                   ; Percent complete

description = :                                 ; Phase description

; ===================================================================================
; MILESTONE
; ===================================================================================

{@milestone}
milestone_id = !:                               ; Milestone identifier
milestone_name = :                              ; Milestone name
milestone_type = (contractual, internal, owner, regulatory)

planned_date = date                             ; Planned date
forecast_date = date                            ; Forecast date
actual_date = date                              ; Actual date

status = (achieved, at_risk, late, on_track, upcoming)
critical = ?                                    ; Critical milestone

description = :                                 ; Milestone description
responsible_party = :                           ; Responsible party

; ===================================================================================
; PROJECT TEAM MEMBER
; ===================================================================================

{@project_team_member}
member_id = !:                                  ; Member identifier
project_id = :                                  ; Project reference
company_id = :                                  ; Company
contact_id = :                                  ; Contact

role = (architect, consultant, contractor, engineer, owner, subcontractor)
role_detail = :                                 ; Specific role title
trade = :                                       ; Trade (for subcontractors)

start_date = date                               ; Start on project
end_date = date                                 ; End on project
status = (active, inactive)

; Contact
name = :                                        ; Full name
email = @types.email                            ; Email
phone = @types.phone                            ; Phone

; ===================================================================================
; PROJECT DOCUMENT
; ===================================================================================

{@project_document}
document_id = :                                 ; Document identifier
project_id = :                                  ; Project reference
document_type = (as_built, contract, correspondence, drawing, permit, photo, report, specification)

title = :                                      ; Document title
document_number = :                             ; Document number
revision = :                                    ; Revision

uploaded = timestamp                         ; Upload date
uploaded_by = :                                 ; Uploaded by
file_path = :                                   ; File path
file_size = ##:(0..)                            ; File size in bytes

status = (approved, current, superseded, under_review)


; ===================================================================================
; ODIN Construction Safety Schema
; ===================================================================================
; Safety plans, incidents, inspections, and OSHA compliance.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.construction.safety"
version = "1.0.0"
title = "Construction Safety Schema"
description = "Safety management and OSHA compliance"

{$derivation}
source[0].authority = "OSHA"
source[0].citation = "OSHA Construction Standards 29 CFR 1926"
source[0].url = "https://www.osha.gov/construction"

source[1].authority = "ANSI"
source[1].citation = "ANSI/ASSP Z10 Safety Management"
source[1].url = "https://www.assp.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial construction safety schema"
changelog[0].rationale = "Safety structures for construction operations"

; ===================================================================================
; SAFETY PLAN
; ===================================================================================

{@safety_plan}
= @types.audit_info

plan_id = :                                    ; Plan identifier
project_id = :                                 ; Project reference
plan_name = :                                  ; Plan name
plan_type = (crane_lift, excavation, fall_protection, hot_work, jha, site_specific)

version = :                                     ; Version
effective_date = date                          ; Effective date
expiration_date = date                          ; Expiration date
review_date = date                              ; Next review date

prepared_by = :                                ; Prepared by
approved_by = :                                 ; Approved by
approved_date = date                            ; Approved date

; Content
scope = :                                       ; Plan scope
hazard_analysis = :                             ; Hazard analysis
control_measures = :                            ; Control measures
emergency_procedures = :                        ; Emergency procedures
training_requirements = :                       ; Training requirements

; Contacts
safety_manager = :                              ; Safety manager
safety_phone = @types.phone                     ; Safety phone
emergency_contact = :                           ; Emergency contact
emergency_phone = @types.phone                  ; Emergency phone

status = (active, approved, draft, expired, superseded)

attachments[] = :                               ; Attachment file paths

; ===================================================================================
; INCIDENT
; ===================================================================================

{@incident}
= @types.audit_info

incident_id = :                                ; Incident identifier
project_id = :                                 ; Project reference
incident_number = :                            ; Incident number

incident_type = (environmental, equipment_damage, first_aid, illness, injury, near_miss, property_damage, vehicle)
severity = (fatality, first_aid, lost_time, medical_treatment, near_miss, recordable, restricted_work)

; Date/Time/Location
incident_date = date                           ; Incident date
incident_time = time                            ; Incident time
shift = :(day, night, swing)                    ; Shift
location = :                                    ; Location on site
weather_conditions = :                          ; Weather conditions

; Description
description = :                                ; Incident description
immediate_cause = :                             ; Immediate cause
root_cause = :                                  ; Root cause
contributing_factors = :                        ; Contributing factors

; Injured party (if applicable)
injured_party = *:                              ; Injured party name (confidential)
employee_id = *:                                ; Employee ID (confidential)
employer = :                                    ; Employer company
trade = :                                       ; Trade
job_title = :                                   ; Job title
years_experience = ##:(0..)                     ; Years experience

; Injury details (if applicable)
injury_type = :(burn, cut, fall, fracture, sprain, strain, struck_by, other)
body_part = :                                   ; Body part affected
treatment = :                                   ; Treatment provided
hospitalized = ?                                ; Hospitalized
days_away = ##:(0..)                            ; Days away from work
days_restricted = ##:(0..)                      ; Days restricted work

; Investigation
investigated_by = :                             ; Investigated by
investigation_date = date                       ; Investigation date
witnesses[] = :                                 ; Witness names
photos_taken = ?                                ; Photos taken
drug_test_required = ?                          ; Drug test required
drug_test_result = *:                           ; Drug test result (confidential)

; Corrective actions
corrective_actions = :                          ; Corrective actions taken
preventive_measures = :                         ; Preventive measures

; Reporting
osha_recordable = ?                             ; OSHA recordable
osha_reported = ?                               ; Reported to OSHA
osha_report_date = date                         ; OSHA report date
osha_case_number = :                            ; OSHA case number

workers_comp_claim = ?                          ; Workers comp filed
claim_number = *:                               ; Claim number (confidential)

status = (closed, investigating, open, reported)

; ===================================================================================
; SAFETY INSPECTION
; ===================================================================================

{@safety_inspection}
= @types.audit_info

inspection_id = :                              ; Inspection identifier
project_id = :                                 ; Project reference
inspection_type = (daily, equipment, monthly, osha, third_party, weekly)

inspection_date = date                         ; Inspection date
inspector = :                                  ; Inspector name
inspector_company = :                           ; Inspector company
inspector_title = :                             ; Inspector title

; Scope
areas_inspected[] = :                           ; Areas inspected
trades_observed[] = :                           ; Trades observed
weather = :                                     ; Weather conditions
workers_on_site = ##:(0..)                      ; Workers on site

; Results
rating = (excellent, fair, good, poor)
findings_count = ##:(0..)                       ; Number of findings
critical_findings = ##:(0..)                    ; Critical findings
open_items = ##:(0..)                           ; Open items

summary = :                                     ; Summary
recommendations = :                             ; Recommendations

findings[] = @safety_finding                    ; Findings

status = (closed, complete, follow_up_required, open)

; ===================================================================================
; SAFETY FINDING
; ===================================================================================

{@safety_finding}
finding_id = :                                 ; Finding identifier
finding_number = ##:(1..)                       ; Finding number

category = (electrical, excavation, fall_protection, fire, hazcom, housekeeping, ppe, scaffolding, struck_by, other)
severity = (critical, high, low, medium)
osha_reference = :                              ; OSHA regulation reference

description = :                                ; Finding description
location = :                                    ; Location
responsible_contractor = :                      ; Responsible contractor
photo = :                                       ; Photo reference

corrective_action = :                           ; Required corrective action
due_date = date                                 ; Correction due date
corrected_date = date                           ; Corrected date
verified_by = :                                 ; Verified by
status = (closed, open, overdue, verified)

; ===================================================================================
; SAFETY TRAINING
; ===================================================================================

{@safety_training}
training_id = :                                ; Training identifier
project_id = :                                 ; Project reference
training_type = (confined_space, crane, excavation, fall_protection, first_aid, forklift, hazcom, orientation, osha_10, osha_30, silica, toolbox)

title = :                                      ; Training title
description = :                                 ; Description
duration_hours = #:(0..)                        ; Duration in hours

trainer = :                                     ; Trainer name
trainer_company = :                             ; Trainer company
training_date = date                           ; Training date
location = :                                    ; Training location

attendees_count = ##:(0..)                      ; Number of attendees
attendees[] = @training_attendee                ; Attendees

expiration_date = date                          ; Certification expiration

; ===================================================================================
; TRAINING ATTENDEE
; ===================================================================================

{@training_attendee}
employee_id = :                                ; Employee identifier
employee_name = :                               ; Employee name
employer = :                                    ; Employer company
trade = :                                       ; Trade
completed = ?                                   ; Completed training
score = #:(0..100)                              ; Test score (if applicable)
certification_number = :                        ; Certification number

; ===================================================================================
; TOOLBOX TALK
; ===================================================================================

{@toolbox_talk}
talk_id = :                                    ; Talk identifier
project_id = :                                 ; Project reference
talk_date = date                               ; Talk date
talk_time = time                                ; Talk time

topic = :                                      ; Talk topic
content = :                                     ; Talk content
duration_minutes = ##:(0..)                     ; Duration in minutes

presented_by = :                               ; Presented by
company = :                                     ; Company
trade = :                                       ; Trade

attendees_count = ##:(0..)                      ; Number of attendees
sign_in_sheet = :                               ; Sign-in sheet file path

weather_discussed = ?                           ; Weather conditions discussed
jha_reviewed = ?                                ; JHA reviewed
ppe_verified = ?                                ; PPE verified

; ===================================================================================
; SAFETY STATISTICS
; ===================================================================================

{@safety_statistics}
stats_id = :                                   ; Statistics identifier
project_id = :                                 ; Project reference
period = :                                     ; Period (YYYY-MM or YYYY)
period_type = (monthly, project_to_date, quarterly, yearly)

; Hours
man_hours = ##:(0..)                            ; Man hours worked
safe_hours = ##:(0..)                           ; Safe man hours

; Incidents
total_incidents = ##:(0..)                      ; Total incidents
recordable_incidents = ##:(0..)                 ; OSHA recordables
lost_time_incidents = ##:(0..)                  ; Lost time incidents
first_aid_cases = ##:(0..)                      ; First aid cases
near_misses = ##:(0..)                          ; Near misses reported

; Rates
trir = #:(0..)                                  ; Total recordable incident rate
dart = #:(0..)                                  ; Days away/restricted rate
ltir = #:(0..)                                  ; Lost time incident rate
severity_rate = #:(0..)                         ; Severity rate
emr = #:(0..)                                   ; Experience modification rate

; Other metrics
inspections_conducted = ##:(0..)                ; Inspections conducted
findings_identified = ##:(0..)                  ; Findings identified
findings_closed = ##:(0..)                      ; Findings closed
training_hours = #:(0..)                        ; Training hours
toolbox_talks = ##:(0..)                        ; Toolbox talks conducted

days_since_recordable = ##:(0..)                ; Days since last recordable


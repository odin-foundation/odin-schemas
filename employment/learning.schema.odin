; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Learning & Development Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Training courses, enrollments, completions, compliance training tracking,
; certifications, credentials, tuition assistance, and learning paths.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.employment.learning"
version = "1.0.0"
title = "Learning & Development Schema"
description = "Courses, training, certifications, and tuition assistance"

{$derivation}
source[0].authority = "Occupational Safety and Health Administration"
source[0].citation = "OSHA Training Requirements, 29 CFR 1910"
source[0].url = "https://www.osha.gov/training"

source[1].authority = "U.S. Department of Labor"
source[1].citation = "Workforce Innovation and Opportunity Act (WIOA)"
source[1].url = "https://www.dol.gov/agencies/eta/wioa"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Compliance training requirements derived from OSHA and industry-specific mandates"

changelog[0].date = 2025-12-21
changelog[0].change = "Initial learning and development schema"
changelog[0].rationale = "Course tracking, compliance training, certifications, tuition assistance"

; ═══════════════════════════════════════════════════════════════════════════════
; COURSE
; ═══════════════════════════════════════════════════════════════════════════════

{@course}
= @types.audit_info

course_id = :                                   ; Unique course identifier
course_code = :                                  ; Course code
course_title = :                                ; Course title
course_description = :                          ; Course description
course_category = (compliance, leadership, onboarding, professional_development, safety, skills, technical)

; Course details
provider = :                                     ; Training provider/vendor
delivery_method = (classroom, elearning, on_the_job, self_paced, virtual_instructor_led, webinar)
duration_hours = #:(0..)                         ; Course duration (hours)
duration_days = #:(0..)                          ; Course duration (days)
credit_hours = #:(0..)                           ; Continuing education credits

; Prerequisites
prerequisites[] = :                              ; Prerequisite course IDs
required_for_position[] = :                      ; Position codes requiring course

; Compliance tracking
compliance_required = ?                          ; Compliance/mandatory training
regulatory_authority = :if compliance_required = true
regulation_citation = :if compliance_required = true
initial_training = ?:if compliance_required = true
refresher_training = ?:if compliance_required = true
refresher_frequency_months = ##:(1..):if refresher_training = true

; Course materials
{.materials[]}
material_type = (assessment, handout, presentation, reference, video)
material_name = :                                ; Material name
document = @types.document_reference            ; Document reference

{@course}

; Assessment
passing_score = ##:(0..100)                      ; Minimum passing score
assessment_required = ?                          ; Assessment required
certificate_issued = ?                           ; Certificate issued on completion

active = ?                                       ; Course is active
effective_date = date                            ; Course effective date
expiration_date = date                           ; Course expiration date

; ═══════════════════════════════════════════════════════════════════════════════
; COURSE ENROLLMENT
; ═══════════════════════════════════════════════════════════════════════════════

{@course_enrollment}
= @types.audit_info

enrollment_id = :                               ; Unique enrollment identifier
employee_id = :                                 ; Associated employee
course_id = :                                   ; Associated course
session_id = :                                   ; Course session ID

enrollment_date = date                          ; Date enrolled
enrollment_type = (assigned, self_enrolled, waitlist)
assigned_by = :if enrollment_type = assigned     ; Who assigned the course

; Scheduling
scheduled_start_date = date                      ; Scheduled start
scheduled_end_date = date                        ; Scheduled end
location = :                                     ; Training location
instructor_name = :                              ; Instructor name
class_size = ##                                  ; Class size limit
seat_confirmed = ?                               ; Seat confirmed

; Completion
status = (cancelled, completed, enrolled, failed, in_progress, no_show, waitlisted, withdrawn)
status_date = date                               ; Date of status change

actual_start_date = date                         ; Actual start date
actual_completion_date = date                    ; Actual completion date
completion_hours = #:(0..)                       ; Actual hours completed

; Assessment results
score = ##:(0..100)                              ; Assessment score
passing_score_required = ##:(0..100)             ; Required passing score
passed = ?                                       ; Passed assessment

; Certificate
certificate_number = :                           ; Certificate number if issued
certificate_issued_date = date                   ; Date certificate issued
certificate_expiration_date = date               ; Certificate expiration

; Cost
registration_fee = #$:(0..)                      ; Registration fee
total_cost = #$:(0..)                            ; Total cost including materials
employer_paid = #$:(0..)                         ; Amount employer paid
employee_paid = #$:(0..)                         ; Amount employee paid

; Feedback
employee_rating = ##:(1..5)                      ; Employee course rating
employee_feedback = :                            ; Employee feedback
instructor_notes = :                             ; Instructor notes

; ═══════════════════════════════════════════════════════════════════════════════
; CERTIFICATION
; ═══════════════════════════════════════════════════════════════════════════════

{@certification}
= @types.audit_info

certification_id = :                            ; Unique certification identifier
employee_id = :                                 ; Associated employee

certification_name = :                          ; Certification name
certification_type = (industry, internal, license, professional)
certifying_body = :                             ; Issuing organization
certification_number = *:                        ; Certification number (confidential)

; Dates
issued_date = date                              ; Issue date
expiration_date = date                           ; Expiration date (if applicable)
renewal_date = date                              ; Renewal date
last_verified_date = date                        ; Last verification date

; Renewal requirements
requires_renewal = ?                             ; Requires periodic renewal
renewal_frequency_months = ##:(1..):if requires_renewal = true
renewal_credits_required = #:(0..):if requires_renewal = true
renewal_credits_earned = #:(0..)                 ; Credits earned toward renewal

status = (active, expired, inactive, pending_renewal, revoked, suspended)
status_date = date                               ; Date of status change

; Verification
verification_url = :                             ; Online verification URL
verified = ?                                     ; Certification verified
verified_by = :                                  ; Who verified
verified_date = date                             ; Verification date

; Documents
certificate_document = @types.document_reference ; Certificate document
renewal_documents[] = @types.document_reference  ; Renewal documents

required_for_position = ?                        ; Required for current position
job_critical = ?                                 ; Critical for job performance

; ═══════════════════════════════════════════════════════════════════════════════
; COMPLIANCE TRAINING RECORD
; ═══════════════════════════════════════════════════════════════════════════════

{@compliance_training_record}
= @types.audit_info

record_id = :                                   ; Unique record identifier
employee_id = :                                 ; Associated employee
course_id = :                                   ; Associated compliance course
enrollment_id = :                                ; Associated enrollment

; Compliance details
compliance_category = (anti_harassment, code_of_conduct, cybersecurity, data_privacy, ethics, export_control, safety, security)
regulatory_authority = :                        ; Regulatory body (OSHA, DOT, etc.)
regulation_citation = :                          ; Regulation reference
mandate = :                                     ; Specific mandate/requirement

; Training completion
initial_training_date = date                    ; Initial training completion
initial_training_score = ##:(0..100)             ; Initial score
initial_training_passed = ?                      ; Passed initial training

; Refresher tracking
refresher_required = ?                           ; Refresher required
refresher_frequency_months = ##:(1..):if refresher_required = true
last_refresher_date = date                       ; Last refresher date
next_refresher_due_date = date                   ; Next due date
last_refresher_score = ##:(0..100)               ; Last refresher score

; Compliance status
compliant = ?                                    ; Currently compliant
non_compliant_since = date                       ; Date became non-compliant
grace_period_end = date                          ; Grace period end
enforcement_action_required = ?                  ; Enforcement needed

; Verification
verified_by = :                                  ; Who verified compliance
verification_date = date                         ; Verification date
audit_trail_notes = :                            ; Audit notes

; ═══════════════════════════════════════════════════════════════════════════════
; LEARNING PATH
; ═══════════════════════════════════════════════════════════════════════════════

{@learning_path}
= @types.audit_info

path_id = :                                     ; Unique path identifier
path_name = :                                   ; Learning path name
path_description = :                            ; Path description
path_category = (career_development, compliance, leadership, onboarding, role_transition, skills)

target_audience = :                              ; Intended audience
required_for_position[] = :                      ; Positions requiring path

; Path courses
{.path_courses[]}
:(1..)                                           ; At least one course
sequence = ##:(1..)                             ; Course sequence number
course_id = :                                   ; Course identifier
course_name = :                                  ; Course name
required = ?                                     ; Required or optional

{@learning_path}

total_duration_hours = #:(0..)                   ; Total path hours
estimated_completion_weeks = ##:(0..)            ; Estimated weeks to complete

active = ?                                       ; Path is active
effective_date = date                            ; Path effective date

; ═══════════════════════════════════════════════════════════════════════════════
; LEARNING PATH ENROLLMENT
; ═══════════════════════════════════════════════════════════════════════════════

{@learning_path_enrollment}
= @types.audit_info

enrollment_id = :                               ; Unique enrollment identifier
employee_id = :                                 ; Associated employee
path_id = :                                     ; Associated learning path

enrollment_date = date                          ; Date enrolled
target_completion_date = date                    ; Target completion
actual_completion_date = date                    ; Actual completion

; Progress tracking
{.course_progress[]}
course_id = :                                   ; Course identifier
enrollment_id = :                                ; Course enrollment ID
completed = ?                                    ; Course completed
completion_date = date                           ; Completion date
score = ##:(0..100)                              ; Score if applicable

{@learning_path_enrollment}

courses_completed = ##:(0..)                     ; Courses completed count
courses_total = ##:(1..)                        ; Total courses in path
progress_percent = ##:(0..100)                   ; Overall progress

status = (completed, in_progress, not_started)   ; Path status

; ═══════════════════════════════════════════════════════════════════════════════
; TUITION ASSISTANCE
; ═══════════════════════════════════════════════════════════════════════════════

{@tuition_assistance}
= @types.audit_info

assistance_id = :                               ; Unique assistance identifier
employee_id = :                                 ; Associated employee

application_date = date                         ; Date applied
academic_year = :                               ; Academic year
semester = (fall, spring, summer, year_round)    ; Semester/term

; Program details
institution_name = :                            ; Educational institution
institution_type = (college_university, graduate_school, trade_school, vocational)
degree_program = :                              ; Degree/program
major = :                                        ; Field of study
course_name[] = :                                ; Course names
credit_hours = #:(0..)                           ; Credit hours

; Job relevance
job_related = ?                                 ; Related to current/future job
relevance_explanation = :                       ; How program is job-related

; Costs
tuition = #$:(0..)                              ; Tuition cost
fees = #$:(0..)                                  ; Fees
books = #$:(0..)                                 ; Books and materials
other_costs = #$:(0..)                           ; Other costs
total_cost = #$:(0..)                           ; Total cost

:invariant total_cost = tuition + fees + books + other_costs

; Assistance requested
amount_requested = #$:(0..)                     ; Assistance requested
amount_approved = #$:(0..)                       ; Assistance approved
amount_paid = #$:(0..)                           ; Amount paid to date

payment_schedule = (after_completion, before_semester, reimbursement)
reimbursement_percent = ##:(0..100)              ; Reimbursement percentage

; Grade requirements
minimum_grade_required = :                       ; Minimum grade for reimbursement
grade_achieved = :                               ; Actual grade received
grade_submitted_date = date                      ; Date grade submitted

; Status
status = (approved, completed, denied, paid, pending, submitted, withdrawn)
status_date = date                               ; Date of status change

approved_by = :                                  ; Who approved
approved_date = date                             ; Approval date
denied_reason = :                                ; Reason denied

completion_date = date                           ; Completion date
completion_verified = ?                          ; Completion verified
transcript_received = ?                          ; Official transcript received

; Service commitment
service_commitment_months = ##:(0..)             ; Required service months
service_commitment_end = date                    ; Service commitment end date
repayment_required_if_leave = ?                  ; Repayment if leaves early
repayment_terms = :                              ; Repayment terms

notes = :                                        ; Assistance notes

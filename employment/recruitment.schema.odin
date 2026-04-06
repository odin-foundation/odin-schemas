; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Recruitment Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Recruitment and hiring including requisitions, job postings, applications,
; candidates, screening, interviews, assessments, offers, and candidate
; disposition tracking.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.employment.recruitment"
version = "1.0.0"
title = "Recruitment Schema"
description = "Requisitions, postings, applications, candidates, and hiring workflows"

{$derivation}
source[0].authority = "U.S. Equal Employment Opportunity Commission"
source[0].citation = "Uniform Guidelines on Employee Selection Procedures, 29 CFR Part 1607"
source[0].url = "https://www.eeoc.gov/laws/guidance/uniform-guidelines-employee-selection-procedures"

source[1].authority = "Office of Federal Contract Compliance Programs"
source[1].citation = "Affirmative Action Requirements, 41 CFR Part 60"
source[1].url = "https://www.dol.gov/agencies/ofccp/compliance-assistance/41-cfr-60"

source[2].authority = "U.S. Department of Labor"
source[2].citation = "Fair Labor Standards Act (FLSA) recordkeeping requirements"
source[2].url = "https://www.dol.gov/agencies/whd/flsa"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial recruitment schema"
changelog[0].rationale = "Applicant tracking derived from EEOC, OFCCP, and DOL recordkeeping requirements"

; ═══════════════════════════════════════════════════════════════════════════════
; REQUISITION
; ═══════════════════════════════════════════════════════════════════════════════

{@requisition}
= @types.audit_info

requisition_id = !:                              ; Unique requisition identifier
requisition_number = :                           ; Human-readable requisition number
position_title = !:                              ; Title of position to fill
job_code = :                                     ; Job classification code
department = !:                                  ; Hiring department
division = :                                     ; Division or business unit
location = !:                                    ; Work location
reports_to = :                                   ; Supervisor/manager name or ID
cost_center = :                                  ; Cost center code

headcount = !##:(1..)                            ; Number of positions to fill
employment_type = (full_time, intern, part_time, seasonal, temporary)
flsa_classification = (exempt, non_exempt)      ; FLSA classification

salary_range_min = #$:(0..)                      ; Minimum salary/wage
salary_range_max = #$:(0..)                      ; Maximum salary/wage
pay_basis = (annual, hourly)                     ; Pay structure

status = (approved, cancelled, draft, filled, on_hold, open, pending_approval)
status_date = date                               ; Date of status change

opened_date = date                               ; Date requisition opened
approved_date = date                             ; Date requisition approved
filled_date = date                               ; Date all positions filled
cancelled_date = date                            ; Date requisition cancelled

opened_by = :                                    ; Who opened requisition
approved_by = :                                  ; Who approved requisition

reason_for_opening = (backfill, expansion, new_position, reorganization, replacement)
urgency = (critical, high, low, medium)          ; Hiring urgency
target_start_date = date                         ; Target start date for new hire

; Job details
job_description = :                              ; Full job description text
required_qualifications = :                      ; Required qualifications
preferred_qualifications = :                     ; Preferred qualifications
essential_functions = :                          ; Essential job functions

; ═══════════════════════════════════════════════════════════════════════════════
; JOB POSTING
; ═══════════════════════════════════════════════════════════════════════════════

{@job_posting}
= @types.audit_info

posting_id = !:                                  ; Unique posting identifier
requisition_id = !:                              ; Associated requisition
posting_title = !:                               ; Public job title
posting_description = !:                         ; Public job description

posting_date = !date                             ; Date posted
closing_date = date                              ; Application closing date
internal_only = ?                                ; Internal candidates only
external_posting = ?                             ; Posted externally

; Posting channels
{.channels[]}
channel = (career_site, external_board, internal_board, referral, social_media)
channel_name = :                                 ; Name of posting site/board
posted_date = date                               ; Date posted to channel
removed_date = date                              ; Date removed from channel
url = :                                          ; Posting URL

{@job_posting}

status = (active, closed, draft, expired, filled, on_hold)
status_date = date                               ; Date of status change

; EEO statement
eeo_statement = :                                ; Equal opportunity statement text

; ═══════════════════════════════════════════════════════════════════════════════
; APPLICANT
; ═══════════════════════════════════════════════════════════════════════════════

{@applicant}
= @types.audit_info

applicant_id = !:                                ; Unique applicant identifier
application_number = :                           ; Human-readable application number
requisition_id = !:                              ; Requisition applied for
posting_id = :                                   ; Job posting applied through

; Personal information
{.personal}
name = !@types.person_name                       ; Applicant full name
address = @types.address                         ; Current address
phones[] = *@types.phone                         ; Phone numbers (confidential)
emails[] = *@types.email                         ; Email addresses (confidential)
date_of_birth = *date                            ; DOB if collected (confidential)

{@applicant}

; Application details
application_date = !date                         ; Date application submitted
application_source = (career_site, employee_referral, external_board, internal_posting, recruiter, social_media, walk_in)
referrer_employee_id = :if application_source = employee_referral
referrer_name = :if application_source = employee_referral

; Employment history
{.employment_history[]}
employer = !:                                    ; Employer name
position_title = !:                              ; Job title
start_date = !date                               ; Start date
end_date = date                                  ; End date (blank if current)
current_employer = ?                             ; Currently employed here
responsibilities = :                             ; Job responsibilities
reason_for_leaving = :                           ; Reason for departure

{@applicant}

; Education
{.education[]}
institution = !:                                 ; School/institution name
degree = :                                       ; Degree earned
field_of_study = :                               ; Major or field
graduation_date = date                           ; Graduation date
gpa = #:(0..4.0)                                 ; Grade point average

{@applicant}

; Skills & certifications
skills[] = :                                     ; Skills list
{.certifications[]}
certification = !:                               ; Certification name
issuing_organization = :                         ; Certifying body
certification_number = :                         ; Certification number
issued_date = date                               ; Issue date
expiration_date = date                           ; Expiration date

{@applicant}

; Documents
{.documents[]}
document_type = (cover_letter, other, resume, transcript, writing_sample)
document_id = !:                                 ; Document identifier
filename = :                                     ; Original filename
uploaded_date = date                             ; Upload date

{@applicant}

; Screening & disposition
status = (applied, background_check, hired, interview, offer, rejected, screening, withdrawn)
status_date = date                               ; Date of status change
disposition = @candidate_disposition             ; Final disposition

; ═══════════════════════════════════════════════════════════════════════════════
; SCREENING
; ═══════════════════════════════════════════════════════════════════════════════

{@screening}
= @types.audit_info

screening_id = !:                                ; Unique screening identifier
applicant_id = !:                                ; Associated applicant
screening_type = (phone_screen, pre_employment_assessment, resume_review, video_interview)
screening_date = !date                           ; Date screening conducted
screened_by = :                                  ; Person who conducted screening

outcome = (advance, hold, reject)               ; Screening outcome
score = ##                                       ; Numeric score if applicable
notes = :                                        ; Screening notes
recommendation = :                               ; Recommendation for next steps

; Assessment details
assessment_name = :if screening_type = pre_employment_assessment
assessment_score = ##:if screening_type = pre_employment_assessment
assessment_percentile = ##:(0..100):if screening_type = pre_employment_assessment

; ═══════════════════════════════════════════════════════════════════════════════
; INTERVIEW
; ═══════════════════════════════════════════════════════════════════════════════

{@interview}
= @types.audit_info

interview_id = !:                                ; Unique interview identifier
applicant_id = !:                                ; Associated applicant
interview_type = (group, panel, one_on_one, phone, video)
interview_round = ##:(1..)                       ; Interview round number
scheduled_date = !date                           ; Scheduled interview date
scheduled_time = time                            ; Scheduled interview time
actual_date = date                               ; Actual interview date
actual_time = time                               ; Actual interview time

location = :                                     ; Interview location
conference_link = :                              ; Video conference URL

; Interviewers
{.interviewers[]}
:(1..)                                           ; At least one interviewer
interviewer_id = :                               ; Interviewer employee ID
interviewer_name = !:                            ; Interviewer name
role = :                                         ; Interviewer role

{@interview}

; Outcome
status = (cancelled, completed, no_show, rescheduled, scheduled)
outcome = (advance, hold, reject)                ; Interview outcome
overall_rating = ##:(1..5)                       ; Overall rating (1-5)
notes = :                                        ; Interview notes
recommendation = :                               ; Recommendation for next steps

; Competency ratings
{.competencies[]}
competency = !:                                  ; Competency name
rating = !##:(1..5)                              ; Rating (1-5)
comments = :                                     ; Comments on competency

{@interview}

; ═══════════════════════════════════════════════════════════════════════════════
; OFFER
; ═══════════════════════════════════════════════════════════════════════════════

{@offer}
= @types.audit_info

offer_id = !:                                    ; Unique offer identifier
applicant_id = !:                                ; Associated applicant
requisition_id = !:                              ; Associated requisition

offer_date = !date                               ; Date offer extended
offer_expiration_date = date                     ; Offer expiration date
response_due_date = date                         ; Response due date

; Position details
position_title = !:                              ; Position title
department = !:                                  ; Department
location = !:                                    ; Work location
reports_to = :                                   ; Supervisor/manager
start_date = !date                               ; Proposed start date

; Compensation
employment_type = (full_time, intern, part_time, seasonal, temporary)
flsa_classification = (exempt, non_exempt)      ; FLSA classification
pay_rate = !#$:(0..)                             ; Offered pay rate
pay_basis = (annual, hourly)                    ; Pay structure
pay_frequency = (biweekly, monthly, semi_monthly, weekly)
currency = :(3) "USD"                            ; ISO 4217 currency code

sign_on_bonus = #$:(0..)                         ; Sign-on bonus if any
relocation_assistance = #$:(0..)                 ; Relocation assistance
other_compensation = :                           ; Other compensation details

; Benefits
benefits_eligible = ?                            ; Eligible for benefits
benefits_start_date = date                       ; Benefits eligibility date
benefits_summary = :                             ; Benefits package summary

; Offer status
status = (accepted, cancelled, declined, expired, extended, pending, rescinded)
status_date = date                               ; Date of status change
accepted_date = date:if status = accepted        ; Date offer accepted
declined_date = date:if status = declined        ; Date offer declined
declined_reason = :if status = declined          ; Reason for declining

offered_by = :                                   ; Who extended offer
approved_by = :                                  ; Who approved offer

; Contingencies
{.contingencies[]}
contingency_type = (background_check, drug_screen, i9_verification, reference_check)
contingency_status = (completed, in_progress, not_started, waived)
completed_date = date                            ; Date contingency satisfied

{@offer}

; ═══════════════════════════════════════════════════════════════════════════════
; CANDIDATE DISPOSITION
; ═══════════════════════════════════════════════════════════════════════════════

{@candidate_disposition}
disposition_date = !date                         ; Date of final disposition
disposition = (hired, not_selected, withdrew)   ; Final disposition

; Not selected reasons (EEOC/OFCCP recordkeeping)
not_selected_reason = (failed_assessment, failed_background, failed_drug_test, insufficient_experience, insufficient_qualifications, interview_performance, overqualified, position_filled, salary_requirements):if disposition = not_selected

; Withdrawal reasons
withdrawal_reason = (accepted_other_offer, compensation, location, personal_reasons, position_requirements):if disposition = withdrew

; EEO tracking (voluntary)
{.eeo_data}
eeo_category = (executive_senior_officials, first_mid_officials_managers, professionals, technicians, sales_workers, administrative_support, craft_workers, operatives, laborers_helpers, service_workers)
gender = (female, male, non_binary)
ethnicity = (hispanic_or_latino, not_hispanic_or_latino)
race[] = (american_indian_alaska_native, asian, black_african_american, native_hawaiian_pacific_islander, white)
veteran_status = (armed_forces_veteran, disabled_veteran, other_protected_veteran, recently_separated_veteran, not_applicable)
disability_status = (disabled, not_disabled, not_disclosed)
self_identification_date = date                  ; Date candidate self-identified

{@candidate_disposition}

notes = :                                        ; Disposition notes
eligible_for_future_consideration = ?            ; Eligible for future openings

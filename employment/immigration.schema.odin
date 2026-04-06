; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Immigration & Work Authorization Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Work authorization, I-9 compliance, E-Verify, visa sponsorship (H-1B, L-1,
; TN), PERM labor certification, green card sponsorship, and immigration
; status tracking.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.employment.immigration"
version = "1.0.0"
title = "Immigration & Work Authorization Schema"
description = "I-9, E-Verify, visas, PERM, and green card sponsorship"

{$derivation}
source[0].authority = "U.S. Citizenship and Immigration Services"
source[0].citation = "Form I-9, Employment Eligibility Verification"
source[0].url = "https://www.uscis.gov/i-9"

source[1].authority = "U.S. Citizenship and Immigration Services"
source[1].citation = "E-Verify Program, 8 CFR 274a"
source[1].url = "https://www.e-verify.gov"

source[2].authority = "U.S. Department of Labor"
source[2].citation = "PERM Labor Certification, 20 CFR Part 656"
source[2].url = "https://www.dol.gov/agencies/eta/foreign-labor/programs/permanent"

source[3].authority = "U.S. Citizenship and Immigration Services"
source[3].citation = "H-1B Specialty Occupation, 8 CFR 214.2(h)"
source[3].url = "https://www.uscis.gov/working-in-the-united-states/temporary-workers/h-1b-specialty-occupations"

source[4].authority = "U.S. Citizenship and Immigration Services"
source[4].citation = "L-1 Intracompany Transferee, 8 CFR 214.2(l)"
source[4].url = "https://www.uscis.gov/working-in-the-united-states/temporary-workers/l-1a-intracompany-transferee-executive-or-manager"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial immigration and work authorization schema"
changelog[0].rationale = "I-9, E-Verify, visa sponsorship derived from USCIS and DOL requirements"

; ═══════════════════════════════════════════════════════════════════════════════
; I-9 VERIFICATION
; ═══════════════════════════════════════════════════════════════════════════════

{@i9_verification}
= @types.audit_info

i9_id = !:                                       ; Unique I-9 identifier
employee_id = !:                                 ; Associated employee
i9_version = !:                                  ; Form version (e.g., "11/14/2016")

; Section 1 - Employee Information and Attestation
{.section_1}
completed_date = !date                           ; Date Section 1 completed
citizenship_status = (citizen, lawful_permanent_resident, non_citizen_national, work_authorized_alien)

; If work authorized alien
uscis_number = *:if citizenship_status = work_authorized_alien
alien_number = *:if citizenship_status = work_authorized_alien
i94_admission_number = *:if citizenship_status = work_authorized_alien
foreign_passport_number = *:if citizenship_status = work_authorized_alien
foreign_passport_country = :(2..3):if citizenship_status = work_authorized_alien
work_authorization_expiration = date:if citizenship_status = work_authorized_alien

preparer_used = ?                                ; Preparer/translator used
preparer_name = :if preparer_used = true         ; Preparer name

{@i9_verification}

; Section 2 - Employer Review and Verification
{.section_2}
verification_date = !date                        ; Date employer verified (within 3 days)
verified_by = !:                                 ; Name of person who verified
verified_by_title = !:                           ; Title of verifier
verified_by_signature_date = !date               ; Signature date

first_day_of_employment = !date                  ; Employee's first day

; Document verification (List A OR List B + List C)
documents_presented = (list_a, list_b_and_c)    ; Documents presented

{.list_a_document}
:if documents_presented = list_a
document_title = !:                              ; Document type
issuing_authority = !:                           ; Issuing authority
document_number = !*:                            ; Document number (confidential)
expiration_date = date                           ; Expiration date

{@i9_verification.section_2}

{.list_b_document}
:if documents_presented = list_b_and_c
document_title = !:                              ; Identity document type
issuing_authority = !:                           ; Issuing authority
document_number = !*:                            ; Document number (confidential)
expiration_date = date                           ; Expiration date

{@i9_verification.section_2}

{.list_c_document}
:if documents_presented = list_b_and_c
document_title = !:                              ; Work authorization doc type
issuing_authority = !:                           ; Issuing authority
document_number = !*:                            ; Document number (confidential)
expiration_date = date                           ; Expiration date

{@i9_verification}

; Section 3 - Reverification and Rehires
{.section_3_records[]}
action_type = (rehire, reverification)          ; Action type
action_date = !date                              ; Date of action
verified_by = !:                                 ; Name of person
signature_date = !date                           ; Signature date

; If reverification
new_document_title = :if action_type = reverification
new_document_number = *:if action_type = reverification
new_expiration_date = date:if action_type = reverification

{@i9_verification}

; Retention and audit
retention_termination_date = date                ; 3 years after hire or 1 year after termination
destruction_date = date                          ; Date form can be destroyed
scanned_document = @types.document_reference     ; Scanned I-9 form

; E-Verify integration
e_verify_case_number = :                         ; E-Verify case number
e_verify_status = (case_verified, tentative_nonconfirmation, employment_authorized, final_nonconfirmation, case_in_continuance)
e_verify_submitted_date = date                   ; E-Verify submission date
e_verify_result_date = date                      ; E-Verify result date

; Audit findings
{.audit_findings[]}
audit_date = !date                               ; Audit date
auditor = !:                                     ; Auditor name
finding = :                                      ; Finding description
corrected = ?                                    ; Finding corrected
correction_date = date                           ; Correction date
correction_description = :                       ; How corrected

{@i9_verification}

; ═══════════════════════════════════════════════════════════════════════════════
; E-VERIFY CASE
; ═══════════════════════════════════════════════════════════════════════════════

{@e_verify_case}
= @types.audit_info

case_number = !:                                 ; E-Verify case number
employee_id = !:                                 ; Associated employee
i9_id = !:                                       ; Associated I-9 form

case_creation_date = !date                       ; Date case created
case_submitted_date = !date                      ; Date submitted to E-Verify
submission_deadline = !date                      ; 3 business days after hire

; Employee information submitted
ssn_submitted = !*:format ssn                    ; SSN submitted (confidential)
name_submitted = !:                              ; Name submitted
dob_submitted = !*date                           ; DOB submitted (confidential)
citizenship_status_submitted = !:                ; Citizenship status submitted

; Initial verification result
initial_result = (case_in_continuance, employment_authorized, tentative_nonconfirmation)
initial_result_date = !date                      ; Date of initial result

; Tentative Nonconfirmation (TNC) process
tnc_reason = (dhs_verification, ssa_mismatch):if initial_result = tentative_nonconfirmation
tnc_notice_issued_date = date:if initial_result = tentative_nonconfirmation
employee_notified_date = date:if initial_result = tentative_nonconfirmation
employee_contest = ?:if initial_result = tentative_nonconfirmation
employee_contest_date = date:if employee_contest = true
referral_date = date:if employee_contest = true  ; Date referred to SSA/DHS

; Final result
final_result = (case_verified, employment_authorized, final_nonconfirmation)
final_result_date = date                         ; Date of final result
close_case_date = date                           ; Date case closed

; Case in continuance
continuance_reason = :if initial_result = case_in_continuance
continuance_end_date = date                      ; Expected resolution

; Final Nonconfirmation (FNC)
fnc_notice_issued_date = date:if final_result = final_nonconfirmation
termination_date = date:if final_result = final_nonconfirmation

notes = :                                        ; Case notes

; ═══════════════════════════════════════════════════════════════════════════════
; VISA PETITION
; ═══════════════════════════════════════════════════════════════════════════════

{@visa_petition}
= @types.audit_info

petition_id = !:                                 ; Unique petition identifier
employee_id = !:                                 ; Associated employee (beneficiary)
visa_type = (e1, e2, e3, h1b, h1b1, h2a, h2b, h3, l1a, l1b, o1, o2, p1, p2, p3, r1, tn)

; Petition details
petition_type = (extension, initial, transfer)   ; Petition type
receipt_number = !*:                             ; USCIS receipt number (confidential)
petition_filed_date = !date                      ; Date filed with USCIS
priority_date = date                             ; Priority date if applicable

; Requested period
requested_start_date = !date                     ; Requested start
requested_end_date = !date                       ; Requested end
requested_duration_years = #:(0..6)              ; Duration requested

; Approval/denial
approval_notice_date = date                      ; I-797 approval date
denial_date = date                               ; Denial date
denial_reason = :                                ; Denial reason
appeal_filed = ?                                 ; Appeal filed
appeal_date = date                               ; Appeal filing date

approved_start_date = date                       ; Approved start
approved_end_date = date                         ; Approved end

status = (approved, denied, pending, received, rfe_issued, rfe_responded, withdrawn)
status_date = date                               ; Date of status change

; Request for Evidence (RFE)
rfe_issued_date = date                           ; RFE issue date
rfe_due_date = date                              ; RFE response due
rfe_responded_date = date                        ; RFE response submitted

; Attorney/representative
attorney_firm = :                                ; Law firm representing
attorney_name = :                                ; Attorney name
attorney_email = :                               ; Attorney email

; Costs
filing_fee = #$:(0..)                            ; USCIS filing fee
attorney_fee = #$:(0..)                          ; Legal fees
premium_processing_fee = #$:(0..)                ; Premium processing fee
total_cost = #$:(0..)                            ; Total petition cost

premium_processing = ?                           ; Premium processing used
premium_processing_receipt = :                   ; Premium receipt number

; Documents
petition_documents[] = @types.document_reference ; Supporting documents
approval_notice = @types.document_reference      ; I-797 approval notice

notes = :                                        ; Petition notes

; ═══════════════════════════════════════════════════════════════════════════════
; VISA STAMP
; ═══════════════════════════════════════════════════════════════════════════════

{@visa_stamp}
= @types.audit_info

visa_stamp_id = !:                               ; Unique visa stamp identifier
employee_id = !:                                 ; Associated employee
petition_id = :                                  ; Associated petition
visa_type = (e1, e2, e3, h1b, h1b1, h2a, h2b, h3, l1a, l1b, o1, o2, p1, p2, p3, r1, tn)

; Consular processing
consulate_location = !:                          ; Consulate location
consulate_country = !:(2..3)                     ; Country
appointment_date = !date                         ; Visa interview date
visa_issued_date = date                          ; Visa issuance date
visa_denied_date = date                          ; Denial date
denial_reason = :                                ; Denial reason (if applicable)

; Visa details
passport_number = !*:                            ; Passport number (confidential)
passport_country = !:(2..3)                      ; Passport country
passport_expiration = !date                      ; Passport expiration
visa_number = !*:                                ; Visa number (confidential)
visa_valid_from = !date                          ; Visa valid from
visa_valid_until = !date                         ; Visa valid until
entries_allowed = (multiple, single)             ; Entry allowance

status = (active, cancelled, denied, expired, issued, pending)

notes = :                                        ; Visa stamp notes

; ═══════════════════════════════════════════════════════════════════════════════
; PERM LABOR CERTIFICATION
; ═══════════════════════════════════════════════════════════════════════════════

{@perm}
= @types.audit_info

perm_id = !:                                     ; Unique PERM identifier
employee_id = !:                                 ; Associated employee (beneficiary)
case_number = *:                                 ; DOL case number (confidential)

; Position details
job_title = !:                                   ; Job title
soc_code = !:                                    ; Standard Occupational Classification
soc_title = !:                                   ; SOC title
prevailing_wage = !#$:(0..)                      ; Prevailing wage
wage_source = !:                                 ; Wage determination source
offered_wage = !#$:(0..)                         ; Offered wage
wage_basis = (annual, hourly)                   ; Wage basis

work_location_address = !@types.address          ; Work location
job_requirements = !:                            ; Minimum job requirements
job_duties = !:                                  ; Job duties

; Recruitment process
{.recruitment}
recruitment_start_date = !date                   ; Recruitment start
recruitment_end_date = !date                     ; Recruitment end

; Recruitment steps (required)
internal_posting_start = !date                   ; Internal posting start
internal_posting_end = !date                     ; Internal posting end
job_order_placed_date = !date                    ; State workforce agency posting
sunday_newspaper_ad_1 = !date                    ; First Sunday ad
sunday_newspaper_ad_2 = !date                    ; Second Sunday ad

; Additional recruitment (3 of 10 required for professional)
{.additional_recruitment[]}
method = (campus_recruiting, employee_referral, internet_posting, job_fair, local_newspaper, private_employment_firm, radio_tv, trade_journal)
method_date = !date                              ; Date of recruitment method
publication_name = :                             ; Publication/site name

{@perm.recruitment}

applicants_reviewed = ##:(0..)                   ; Total applicants reviewed
us_workers_considered = ##:(0..)                 ; US workers considered
us_workers_rejected = ##:(0..)                   ; US workers not qualified

{@perm}

; PERM filing
perm_filed_date = !date                          ; Date filed with DOL
priority_date = date                             ; Priority date assigned

; Audit (if selected)
audit_notice_date = date                         ; Audit notice date
audit_response_due = date                        ; Audit response due
audit_response_submitted = date                  ; Audit response submitted

; Approval/denial
approval_date = date                             ; Approval date
denial_date = date                               ; Denial date
denial_reason = :                                ; Denial reason

status = (approved, denied, filed, pending, recruiting, under_audit)
status_date = date                               ; Status change date

; Attorney/representative
attorney_firm = :                                ; Law firm
attorney_name = :                                ; Attorney name

; Costs
recruitment_costs = #$:(0..)                     ; Recruitment costs
attorney_fees = #$:(0..)                         ; Legal fees
total_cost = #$:(0..)                            ; Total PERM cost

notes = :                                        ; PERM notes

; ═══════════════════════════════════════════════════════════════════════════════
; GREEN CARD (I-485 ADJUSTMENT OF STATUS)
; ═══════════════════════════════════════════════════════════════════════════════

{@green_card_application}
= @types.audit_info

application_id = !:                              ; Unique application identifier
employee_id = !:                                 ; Associated employee
perm_id = :                                      ; Associated PERM case
i140_petition_id = :                             ; Associated I-140 petition

; I-140 Immigrant Petition
i140_receipt_number = *:                         ; I-140 receipt number (confidential)
i140_filed_date = date                           ; I-140 filing date
i140_approved_date = date                        ; I-140 approval date
i140_priority_date = date                        ; Priority date
i140_category = (eb1, eb2, eb3, eb4, eb5)        ; Employment-based category

; I-485 Application to Adjust Status
i485_receipt_number = *:                         ; I-485 receipt number (confidential)
i485_filed_date = date                           ; I-485 filing date
biometrics_appointment_date = date               ; Biometrics date
interview_date = date                            ; Interview date (if required)
medical_exam_date = date                         ; Medical exam date

; Approval
approval_date = date                             ; Approval date
card_production_date = date                      ; Card production date
card_mailed_date = date                          ; Card mailed date
card_received_date = date                        ; Card received date
green_card_number = *:                           ; Green card number (confidential)
card_expiration_date = date                      ; Card expiration (10 years)

denial_date = date                               ; Denial date
denial_reason = :                                ; Denial reason

status = (approved, biometrics_scheduled, card_produced, denied, filed, interview_scheduled, pending)
status_date = date                               ; Status change date

; Costs
i140_filing_fee = #$:(0..)                       ; I-140 fee
i485_filing_fee = #$:(0..)                       ; I-485 fee
attorney_fees = #$:(0..)                         ; Legal fees
medical_exam_cost = #$:(0..)                     ; Medical exam cost
total_cost = #$:(0..)                            ; Total cost

notes = :                                        ; Application notes

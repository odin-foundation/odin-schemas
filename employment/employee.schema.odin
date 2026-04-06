; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Employee Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Core employee record including personal information, demographics, employment
; details, position, classification, tax withholding (W-4), work authorization
; (I-9), and employment status.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.employment.employee"
version = "1.0.0"
title = "Employee Schema"
description = "Core employee record with personal, employment, and compliance data"

{$derivation}
source[0].authority = "U.S. Department of Labor"
source[0].citation = "Fair Labor Standards Act (FLSA), 29 USC 201 et seq."
source[0].url = "https://www.dol.gov/agencies/whd/flsa"

source[1].authority = "U.S. Equal Employment Opportunity Commission"
source[1].citation = "Title VII of the Civil Rights Act of 1964, 42 USC 2000e et seq."
source[1].url = "https://www.eeoc.gov/statutes/title-vii-civil-rights-act-1964"

source[2].authority = "Internal Revenue Service"
source[2].citation = "Publication 15 (Circular E), Employer's Tax Guide"
source[2].url = "https://www.irs.gov/publications/p15"

source[3].authority = "Internal Revenue Service"
source[3].citation = "Form W-4, Employee's Withholding Certificate"
source[3].url = "https://www.irs.gov/forms-pubs/about-form-w-4"

source[4].authority = "U.S. Citizenship and Immigration Services"
source[4].citation = "Form I-9, Employment Eligibility Verification"
source[4].url = "https://www.uscis.gov/i-9"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial employee schema"
changelog[0].rationale = "Core employee fields derived from FLSA, EEOC, IRS, and USCIS requirements"

; ═══════════════════════════════════════════════════════════════════════════════
; EMPLOYEE
; ═══════════════════════════════════════════════════════════════════════════════

{@employee}
= @types.audit_info

; ───────────────────────────────────────────────────────────────────────────────
; Identification
; ───────────────────────────────────────────────────────────────────────────────
employee_id = !:                                 ; Unique employee identifier
employee_number = :                              ; Employee number (may differ from ID)

; ───────────────────────────────────────────────────────────────────────────────
; Personal Information
; ───────────────────────────────────────────────────────────────────────────────
{.personal}
name = !@types.person_name                       ; Employee full name
identifiers = @types.person_identifiers          ; SSN, SIN, driver license
demographics = @types.demographics               ; DOB, gender, marital status
preferred_name = :                               ; Name employee prefers to use

{@employee}

; ───────────────────────────────────────────────────────────────────────────────
; Contact Information
; ───────────────────────────────────────────────────────────────────────────────
{.contact}
home_address = @types.address                    ; Primary residence
mailing_address = @types.address                 ; Mailing address if different
phones[] = *@types.phone                         ; Phone numbers (confidential)
emails[] = *@types.email                         ; Email addresses (confidential)
work_email = :                                   ; Company email address
work_phone = @types.phone                        ; Company phone/extension

{@employee}

; ───────────────────────────────────────────────────────────────────────────────
; Emergency Contacts
; ───────────────────────────────────────────────────────────────────────────────
{.emergency_contacts[]}
:(1..)                                           ; At least one required
name = !:                                        ; Emergency contact name
relationship = !:                                ; Relationship to employee
phone = !*@types.phone                           ; Primary phone (confidential)
alternate_phone = *@types.phone                  ; Alternate phone (confidential)
primary = ?                                      ; Primary emergency contact

{@employee}

; ───────────────────────────────────────────────────────────────────────────────
; Employment Details
; ───────────────────────────────────────────────────────────────────────────────
{.employment}
hire_date = !date                                ; Original hire date
adjusted_hire_date = date                        ; Adjusted for service credit
rehire_date = date                               ; Most recent rehire if applicable
probation_end_date = date                        ; End of probationary period
continuous_service_date = date                   ; Start of continuous service
termination_date = date                          ; Employment end date
expected_return_date = date                      ; Return from leave date

employment_type = (full_time, part_time, seasonal, temporary)
status = !@employment_status                     ; Current employment status

{@employee}

; ───────────────────────────────────────────────────────────────────────────────
; Position & Classification
; ───────────────────────────────────────────────────────────────────────────────
{.position}
current_position = !@position                    ; Current position details
position_history[] = @position                   ; Historical positions

{@employee}

; ───────────────────────────────────────────────────────────────────────────────
; Compensation
; ───────────────────────────────────────────────────────────────────────────────
{.compensation}
flsa_classification = (exempt, non_exempt)      ; FLSA classification
pay_rate = !#$:(0..)                             ; Current pay rate
pay_basis = (annual, biweekly, daily, hourly, monthly, weekly)
pay_frequency = (biweekly, monthly, semi_monthly, weekly)
pay_grade = :                                    ; Pay grade or level
pay_step = ##                                    ; Step within grade
currency = :(3) "USD"                            ; ISO 4217 currency code
overtime_eligible = ?                            ; Eligible for overtime pay
commission_eligible = ?                          ; Eligible for commission
bonus_eligible = ?                               ; Eligible for bonuses

{@employee}

; ───────────────────────────────────────────────────────────────────────────────
; Tax Withholding (W-4 Data)
; ───────────────────────────────────────────────────────────────────────────────
{.tax_withholding}
w4_year = ##:(2020..)                            ; W-4 form version year
w4_received_date = date                          ; Date W-4 was received

; Step 1(c) - Filing Status (2020+ W-4)
filing_status = (married_filing_jointly, married_filing_separately, single_or_married_filing_separately, head_of_household)

; Step 2 - Multiple Jobs or Spouse Works
multiple_jobs = ?                                ; Multiple jobs checkbox
uses_estimator = ?                               ; Uses IRS estimator

; Step 3 - Claim Dependents
dependents_amount = #$                           ; Total dependents credit amount

; Step 4 - Other Adjustments
other_income = #$                                ; Other income (not from jobs)
deductions = #$                                  ; Deductions (non-wage)
extra_withholding = #$                           ; Additional withholding per pay

; State/Local Withholding
state_withholding[] = @state_tax_withholding     ; State withholding certificates
local_withholding[] = @local_tax_withholding     ; Local withholding certificates

{@employee}

; ───────────────────────────────────────────────────────────────────────────────
; Work Authorization (I-9)
; ───────────────────────────────────────────────────────────────────────────────
{.work_authorization}
citizenship_status = (citizen, lawful_permanent_resident, non_citizen_national, work_authorized_alien)
i9_completed_date = !date                        ; Date I-9 Section 1 completed
i9_verified_date = !date                         ; Date employer verified (Section 2)
i9_verified_by = !:                              ; Name of person who verified
i9_reverification_date = date                    ; Next reverification date if needed
work_authorization_expiration = date             ; Authorization expiration

; Document verification (List A, List B, or List C)
{.i9_documents[]}
list = (list_a, list_b, list_c)                 ; USCIS document list
document_type = !:                               ; Document type/title
issuing_authority = !:                           ; Issuing organization
document_number = !*:                            ; Document number (confidential)
expiration_date = date                           ; Document expiration

{@employee}

; ───────────────────────────────────────────────────────────────────────────────
; EEO & Affirmative Action (Voluntary)
; ───────────────────────────────────────────────────────────────────────────────
{.eeo_data}
eeo_category = (executive_senior_officials, first_mid_officials_managers, professionals, technicians, sales_workers, administrative_support, craft_workers, operatives, laborers_helpers, service_workers)
ethnicity = (hispanic_or_latino, not_hispanic_or_latino)
race[] = (american_indian_alaska_native, asian, black_african_american, native_hawaiian_pacific_islander, white)
veteran_status = (armed_forces_veteran, disabled_veteran, other_protected_veteran, recently_separated_veteran, not_applicable)
disability_status = (disabled, not_disabled, not_disclosed)
self_identification_date = date                  ; Date employee self-identified

{@employee}

; ───────────────────────────────────────────────────────────────────────────────
; Notes & Flags
; ───────────────────────────────────────────────────────────────────────────────
{.flags}
do_not_rehire = ?                                ; Do not rehire flag
eligible_for_rehire = ?                          ; Eligible for rehire
background_check_completed = ?                   ; Background check done
background_check_date = date                     ; Background check date
notes = :                                        ; General employee notes

; ═══════════════════════════════════════════════════════════════════════════════
; EMPLOYMENT STATUS
; ═══════════════════════════════════════════════════════════════════════════════

{@employment_status}
status = (active, leave_of_absence, retired, suspended, terminated)
status_date = !date                              ; Date of status change
effective_date = date                            ; When status takes effect
reason = :                                       ; Reason for status
changed_by = :                                   ; Who changed the status

; Leave-specific fields
leave_type = (disability, family_medical, military, personal, sabbatical, unpaid):if status = leave_of_absence
expected_return_date = date:if status = leave_of_absence

; Termination-specific fields
termination_type = (involuntary, retirement, voluntary):if status = terminated
termination_reason = :if status = terminated
termination_reason_code = :if status = terminated
eligible_for_rehire = ?:if status = terminated
final_work_date = date:if status = terminated

; ═══════════════════════════════════════════════════════════════════════════════
; POSITION
; ═══════════════════════════════════════════════════════════════════════════════

{@position}
position_id = !:                                 ; Position identifier
position_title = !:                              ; Job title
job_code = :                                     ; Job classification code
department = !:                                  ; Department name
division = :                                     ; Division or business unit
location = :                                     ; Work location
cost_center = :                                  ; Cost center code
reports_to_employee_id = :                       ; Manager employee ID
position_start_date = !date                      ; Date in this position
position_end_date = date                         ; Date left this position
fte = #:(0..1)                                   ; Full-time equivalent (0.0 to 1.0)

; ═══════════════════════════════════════════════════════════════════════════════
; STATE TAX WITHHOLDING
; ═══════════════════════════════════════════════════════════════════════════════

{@state_tax_withholding}
state = !:(2)                                    ; State code
filing_status = !:                               ; State-specific filing status
allowances = ##                                  ; State withholding allowances
exemptions = ##                                  ; Number of exemptions
additional_withholding = #$                      ; Additional withholding amount
exempt = ?                                       ; Exempt from state withholding
form_date = date                                 ; Date state form received

; ═══════════════════════════════════════════════════════════════════════════════
; LOCAL TAX WITHHOLDING
; ═══════════════════════════════════════════════════════════════════════════════

{@local_tax_withholding}
locality = !:                                    ; Local jurisdiction name
locality_code = :                                ; Local jurisdiction code
filing_status = :                                ; Local filing status
allowances = ##                                  ; Local withholding allowances
additional_withholding = #$                      ; Additional withholding amount
exempt = ?                                       ; Exempt from local withholding
form_date = date                                 ; Date local form received

; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Financial Aid Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Federal student aid for Title IV programs including FAFSA, ISIR, need analysis,
; award packaging (grants, loans, work-study), disbursement, and satisfactory
; academic progress.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types
@import "./student.schema.odin" as student
@import "./institution.schema.odin" as institution

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.education.financial_aid"
version = "1.0.0"
title = "Financial Aid Schema"
description = "FAFSA, ISIR, need analysis, award package, grants, loans, work-study, disbursement, and SAP"

{$derivation}
source[0].authority = "U.S. Department of Education"
source[0].citation = "Federal Student Aid Handbook 2025-2026"
source[0].url = "https://fsapartners.ed.gov/knowledge-center/fsa-handbook/2025-2026"
source[0].accessed = 2025-12-21

source[1].authority = "U.S. Department of Education"
source[1].citation = "34 CFR Part 668 - Student Assistance General Provisions"
source[1].url = "https://www.ecfr.gov/current/title-34/subtitle-B/chapter-VI/part-668"
source[1].accessed = 2025-12-21

source[2].authority = "U.S. Department of Education"
source[2].citation = "34 CFR Part 690 - Federal Pell Grant Program"
source[2].url = "https://www.ecfr.gov/current/title-34/subtitle-B/chapter-VI/part-690"
source[2].accessed = 2025-12-21

source[3].authority = "U.S. Department of Education"
source[3].citation = "34 CFR Part 685 - William D. Ford Federal Direct Loan Program"
source[3].url = "https://www.ecfr.gov/current/title-34/subtitle-B/chapter-VI/part-685"
source[3].accessed = 2025-12-21

source[4].authority = "U.S. Department of Education"
source[4].citation = "34 CFR Part 676 - Federal Supplemental Educational Opportunity Grant Program"
source[4].url = "https://www.ecfr.gov/current/title-34/subtitle-B/chapter-VI/part-676"
source[4].accessed = 2025-12-21

source[5].authority = "U.S. Department of Education"
source[5].citation = "34 CFR Part 675 - Federal Work-Study Program"
source[5].url = "https://www.ecfr.gov/current/title-34/subtitle-B/chapter-VI/part-675"
source[5].accessed = 2025-12-21

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema derived from FSA Handbook and Title IV regulations (34 CFR 668, 675, 676, 685, 690)"

changelog[0].date = 2025-12-21
changelog[0].change = "Initial financial aid schema"
changelog[0].rationale = "Federal student aid programs per FSA Handbook and Title IV regulations"

; ═══════════════════════════════════════════════════════════════════════════════
; FAFSA (FREE APPLICATION FOR FEDERAL STUDENT AID)
; ═══════════════════════════════════════════════════════════════════════════════

{@fafsa}
; Required fields first
student_id = *:                                     ; Student identifier
award_year = :                                      ; Award year (e.g., 2025-2026)
submission_date = date                              ; FAFSA submission date

; Optional fields
transaction_number = *:                              ; FAFSA transaction number
application_receipt_date = date                      ; Date application received
processed_date = date                                ; Date processed

; Student information
student_ssn = *:format ssn                         ; Student SSN (required, PII)
student_date_of_birth = *date                       ; Student DOB (required, PII)
student_marital_status = (married, separated, single, unmarried_and_both_parents_living_together, unmarried_and_both_parents_not_living_together, widowed)

; Dependency status
dependency_status = (dependent, independent)

; Student income (from federal tax return)
student_agi = *#$                                    ; Adjusted gross income (PII)
student_income_earned = *#$                          ; Income earned from work (PII)
student_taxes_paid = *#$                             ; Taxes paid (PII)

; Student assets
student_cash_savings = *#$:(0..)                     ; Cash and savings (PII)
student_investments = *#$:(0..)                      ; Investments (PII)
student_business_farm_value = *#$:(0..)              ; Business/farm value (PII)

; Parent information (if dependent)
parent_marital_status = (married_remarried, never_married_single, separated_divorced, unmarried_parents_living_together, widowed):if dependency_status = dependent
parent_household_size = ##:(1..):if dependency_status = dependent
parent_in_college_count = ##:(0..):if dependency_status = dependent

; Parent income
parent_agi = *#$:if dependency_status = dependent
parent_income_earned = *#$:if dependency_status = dependent
parent_taxes_paid = *#$:if dependency_status = dependent

; Parent assets
parent_cash_savings = *#$:(0..):if dependency_status = dependent
parent_investments = *#$:(0..):if dependency_status = dependent
parent_business_farm_value = *#$:(0..):if dependency_status = dependent

; Household size
household_size = ##:(1..)
number_in_college = ##:(0..)

; Verification
selected_for_verification = ?
verification_tracking_flag = :

; ═══════════════════════════════════════════════════════════════════════════════
; ISIR (INSTITUTIONAL STUDENT INFORMATION RECORD)
; ═══════════════════════════════════════════════════════════════════════════════

{@isir}
; Required fields first
student_id = *:                                     ; Student identifier
award_year = :                                      ; Award year
transaction_number = *:                             ; ISIR transaction number
processed_date = date                               ; Processing date

; Optional fields
isir_type = (correction, initial, renewal)

; SAI (Student Aid Index) - replaces EFC starting 2024-25
sai = *##                                            ; Student Aid Index (PII)
sai_formula = (a, b, c)                              ; SAI formula used

; Legacy EFC (through 2023-24)
efc = *##                                            ; Expected Family Contribution (PII, legacy)

; Verification
verification_selection = :                           ; Verification tracking group
verification_required = ?

; Pell eligibility
pell_eligible = ?
estimated_pell_grant = #$:(0..)

; DL eligibility
subsidized_usage = #:(0..600)                        ; Subsidized usage limit (%)
direct_loan_eligible = ?

; Flags and rejects
reject_codes[] = :                                   ; ISIR reject codes
comment_codes[] = :                                  ; ISIR comment codes
c_flag = ?                                           ; Correction flag

; Dependency status
dependency_override = ?                              ; Dependency override granted
professional_judgment = ?                            ; Professional judgment applied

; ═══════════════════════════════════════════════════════════════════════════════
; COST OF ATTENDANCE (COA)
; ═══════════════════════════════════════════════════════════════════════════════

{@cost_of_attendance}
; Required fields first
award_year = :                                      ; Award year
enrollment_status = (full_time, half_time, less_than_half_time, three_quarter_time)

; Optional fields
living_arrangement = (off_campus, on_campus, with_parent)
program_length = :                                   ; Academic year, semester, etc.

; Standard budgets
tuition_fees = #$:(0..)                              ; Tuition and fees
books_supplies = #$:(0..)                            ; Books and supplies
room_board = #$:(0..)                                ; Room and board
transportation = #$:(0..)                            ; Transportation
personal_expenses = #$:(0..)                         ; Personal expenses
loan_fees = #$:(0..)                                 ; Loan fees

; Special allowances
dependent_care = #$:(0..)                            ; Dependent care
disability_expenses = #$:(0..)                       ; Disability-related expenses
study_abroad = #$:(0..)                              ; Study abroad costs
computer_costs = #$:(0..)                            ; Computer costs (first year)

; Total COA
total_coa = #$:(0..)                                ; Total cost of attendance

; ═══════════════════════════════════════════════════════════════════════════════
; NEED ANALYSIS
; ═══════════════════════════════════════════════════════════════════════════════

{@need_analysis}
; Required fields first
student_id = *:                                     ; Student identifier
award_year = :                                      ; Award year

; Optional fields
cost_of_attendance = #$:(0..)                        ; Total COA
sai = ##                                             ; Student Aid Index
efc = ##                                             ; Expected Family Contribution (legacy)

; Financial need
financial_need = #$                                  ; COA - SAI (can be negative)
unmet_need = #$                                      ; Need not covered by aid
remaining_eligibility = #$:(0..)                     ; Remaining aid eligibility

; Other resources
estimated_financial_assistance = #$:(0..)            ; EFA - outside aid
veterans_benefits = #$:(0..)                         ; VA benefits
outside_scholarships = #$:(0..)                      ; Outside scholarships
tuition_waivers = #$:(0..)                           ; Tuition waivers

; ═══════════════════════════════════════════════════════════════════════════════
; AWARD PACKAGE
; ═══════════════════════════════════════════════════════════════════════════════

{@award_package}
; Required fields first
student_id = *:                                     ; Student identifier
award_year = :                                      ; Award year
packaging_date = date                               ; Date package created

; Optional fields
revised_date = date                                  ; Last revision date
revision_number = ##:(0..)                           ; Revision count

; Enrollment
enrollment_status = (full_time, half_time, less_than_half_time, three_quarter_time)
academic_level = (first_year, fourth_year, graduate, second_year, third_year)

; Financial summary
cost_of_attendance = #$:(0..)                        ; Total COA
sai = ##                                             ; Student Aid Index
financial_need = #$                                  ; Calculated need

; Awards
awards[] = @financial_aid_award                      ; All awards in package

; Totals
total_grants = #$:(0..)                              ; Total grant aid
total_loans = #$:(0..)                               ; Total loan aid
total_work_study = #$:(0..)                          ; Total work-study
total_aid = #$:(0..)                                 ; Total aid awarded

; Package status
status = (accepted, cancelled, declined, offered, pending, revised)
acceptance_deadline = date                           ; Deadline to accept
confirmed_date = date                                ; Date student confirmed

; ═══════════════════════════════════════════════════════════════════════════════
; FINANCIAL AID AWARD
; ═══════════════════════════════════════════════════════════════════════════════

{@financial_aid_award}
; Required fields first
award_id = :                                        ; Award identifier
fund_source = :                                     ; Fund source code
award_type = (grant, loan, scholarship, work_study)

; Optional fields
fund_name = :                                        ; Fund name
fund_description = :                                 ; Fund description

; Award details
award_amount = #$:(0..)                              ; Award amount
accepted_amount = #$:(0..)                           ; Amount student accepted
disbursed_amount = #$:(0..)                          ; Amount disbursed

; Specific fund types
pell_grant = #$:(0..):if fund_source = pell
fseog = #$:(0..):if fund_source = fseog
iraq_afghanistan = #$:(0..):if fund_source = iraq_afghanistan
teach_grant = #$:(0..):if fund_source = teach

; Direct Loans
subsidized_loan = #$:(0..):if fund_source = direct_subsidized
unsubsidized_loan = #$:(0..):if fund_source = direct_unsubsidized
grad_plus = #$:(0..):if fund_source = grad_plus
parent_plus = #$:(0..):if fund_source = parent_plus

; Work-Study
fws_award = #$:(0..):if award_type = work_study
earnings_to_date = #$:(0..):if award_type = work_study

; Award period
award_period_begin = date                            ; Award period start
award_period_end = date                              ; Award period end
academic_year = :                                    ; Academic year

; Status
award_status = (accepted, cancelled, declined, disbursed, offered, paid, pending)
status_date = date                                   ; Status change date

; ═══════════════════════════════════════════════════════════════════════════════
; DISBURSEMENT
; ═══════════════════════════════════════════════════════════════════════════════

{@disbursement}
; Required fields first
award_id = :                                        ; Award identifier
student_id = *:                                     ; Student identifier
disbursement_date = date                            ; Disbursement date
amount = #$:(0..)                                   ; Disbursement amount

; Optional fields
disbursement_number = ##:(1..)                       ; Disbursement sequence
academic_term = :                                    ; Academic term
payment_period = :                                   ; Payment period

; Enrollment verification
enrollment_status = (full_time, half_time, less_than_half_time, three_quarter_time)
credit_hours = #:(0..)                               ; Enrolled credit hours
enrollment_verified_date = date                      ; Enrollment verification date

; Direct Loan specifics
origination_fee = #$:(0..)                           ; Loan origination fee
net_amount = #$:(0..)                                ; Net amount after fees
anticipated_disbursement = ?                         ; Anticipated vs actual

; COD reporting
cod_reported = ?                                     ; Reported to COD
cod_report_date = date                               ; COD report date
cod_accepted = ?                                     ; COD accepted
cod_acceptance_date = date                           ; COD acceptance date

; Refund/return
returned_amount = #$:(0..)                           ; Amount returned
return_date = date                                   ; Return date
return_reason = :                                    ; Reason for return

; ═══════════════════════════════════════════════════════════════════════════════
; SATISFACTORY ACADEMIC PROGRESS (SAP)
; ═══════════════════════════════════════════════════════════════════════════════

{@sap_status}
; Required fields first
student_id = *:                                     ; Student identifier
evaluation_date = date                              ; Evaluation date
status = (meeting, not_meeting, probation, warning)

; Optional fields
academic_year = :                                    ; Academic year
academic_term = :                                    ; Academic term

; Qualitative measure (GPA)
cumulative_gpa = #:(0..4)                            ; Cumulative GPA
required_gpa = #:(0..4)                              ; Required GPA
gpa_met = ?                                          ; GPA requirement met

; Quantitative measure (Pace)
credits_attempted = #:(0..)                          ; Total credits attempted
credits_earned = #:(0..)                             ; Total credits earned
completion_rate = #:(0..100)                         ; Completion rate percentage
required_completion_rate = #:(0..100)                ; Required completion rate
pace_met = ?                                         ; Pace requirement met

; Maximum timeframe
credits_toward_degree = #:(0..)                      ; Credits counting toward degree
program_length = #:(0..)                             ; Published program length
max_timeframe_percentage = #:(100..150)              ; Maximum timeframe (150%)
max_timeframe_credits = #:(0..)                      ; Maximum credits allowed
max_timeframe_met = ?                                ; Within maximum timeframe

; Appeal and plan
appeal_filed = ?                                     ; Appeal filed
appeal_approved = ?                                  ; Appeal approved
academic_plan = ?                                    ; Academic plan in place
probation_end_term = :                               ; When probation ends

; Financial aid eligibility
eligible_for_aid = ?                                 ; Eligible for Title IV aid
suspension_reason = :                                ; Reason for suspension if not eligible

; ═══════════════════════════════════════════════════════════════════════════════
; VERIFICATION
; ═══════════════════════════════════════════════════════════════════════════════

{@verification}
; Required fields first
student_id = *:                                     ; Student identifier
award_year = :                                      ; Award year
tracking_group = :                                  ; Verification tracking group

; Optional fields
selected_date = date                                 ; Date selected for verification
completion_date = date                               ; Verification completion date

; Documents required
tax_transcript_required = ?
w2_required = ?
verification_worksheet = ?
identity_verification = ?
statement_educational_purpose = ?

; Documents received
tax_transcript_received = ?
tax_transcript_date = date
w2_received = ?
w2_date = date
worksheet_received = ?
worksheet_date = date

; Review results
discrepancies_found = ?
discrepancy_description = :
corrections_made = ?
correction_description = :

; Status
verification_complete = ?
referred_for_fraud = ?

; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Employee Separation Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Employee separations including terminations, resignations, retirements,
; offboarding, final pay calculations, severance agreements, COBRA qualifying
; events, and unemployment claims.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.employment.separation"
version = "1.0.0"
title = "Employee Separation Schema"
description = "Terminations, resignations, offboarding, final pay, and severance"

{$derivation}
source[0].authority = "U.S. Department of Labor"
source[0].citation = "Fair Labor Standards Act (FLSA), 29 USC 201 et seq."
source[0].url = "https://www.dol.gov/agencies/whd/flsa"

source[1].authority = "U.S. Department of Labor"
source[1].citation = "Worker Adjustment and Retraining Notification (WARN) Act, 29 USC 2101 et seq."
source[1].url = "https://www.dol.gov/agencies/eta/layoffs/warn"

source[2].authority = "U.S. Department of Labor"
source[2].citation = "COBRA Continuation Coverage, 29 USC 1161-1168"
source[2].url = "https://www.dol.gov/agencies/ebsa/laws-and-regulations/laws/cobra"

source[3].authority = "U.S. Department of Labor"
source[3].citation = "Federal Unemployment Tax Act (FUTA), 26 USC 3301 et seq."
source[3].url = "https://www.irs.gov/businesses/small-businesses-self-employed/futa-credit-reduction"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial employee separation schema"
changelog[0].rationale = "Termination, resignation, offboarding, WARN Act, COBRA, and unemployment derived from DOL and IRS requirements"

; ═══════════════════════════════════════════════════════════════════════════════
; SEPARATION
; ═══════════════════════════════════════════════════════════════════════════════

{@separation}
= @types.audit_info

separation_id = !:                               ; Unique separation identifier
employee_id = !:                                 ; Associated employee
separation_type = (death, discharge, layoff, resignation, retirement, termination)

; Dates
notice_date = date                               ; Date notice given
last_work_date = !date                           ; Last physical day worked
separation_date = !date                          ; Official separation date
benefits_end_date = date                         ; Benefits end date

; Reason details
reason_category = (attendance, business_closure, job_elimination, performance, policy_violation, resignation_personal, resignation_other_opportunity, retirement_age, retirement_early, voluntary)
reason_code = :                                  ; Internal reason code
reason_description = !:                          ; Detailed reason
termination_for_cause = ?                        ; Terminated for cause

; Notice period
notice_period_days = ##:(0..)                    ; Notice period given
notice_waived = ?                                ; Notice waived by employer
pay_in_lieu_of_notice = ?                        ; Paid instead of notice

; Resignation-specific
resignation_letter_date = date:if separation_type = resignation
resignation_letter_received = ?:if separation_type = resignation
counteroffer_made = ?:if separation_type = resignation
counteroffer_details = :if counteroffer_made = true

; Involuntary separation
{.involuntary_details}
:if separation_type = termination
:if separation_type = layoff
:if separation_type = discharge

termination_meeting_date = date                  ; Termination meeting date
termination_meeting_attendees = :                ; Who attended meeting
documentation_provided = ?                       ; Documentation given to employee
appeal_rights_explained = ?                      ; Appeal process explained

progressive_discipline = ?                       ; Progressive discipline used
{.prior_actions[]}
action_type = (coaching, final_warning, pip, suspension, verbal_warning, written_warning)
action_date = !date                              ; Date of action
description = :                                  ; Action description

{@separation}

; WARN Act (mass layoffs)
warn_event = ?                                   ; Part of WARN event
warn_notice_date = date:if warn_event = true     ; WARN notice date (60 days)
affected_employees_count = ##:if warn_event = true

; Rehire eligibility
eligible_for_rehire = !?                         ; Eligible for rehire
rehire_restrictions = :                          ; Restrictions if applicable
do_not_rehire_reason = :                         ; Reason if not eligible

; Exit interview
exit_interview_completed = ?                     ; Exit interview done
exit_interview_id = :                            ; Exit interview ID
exit_interview_date = date                       ; Interview date

; References
reference_authorized = ?                         ; May provide references
reference_restrictions = :                       ; What can be disclosed

notes = :                                        ; Separation notes
confidential_notes = *:                          ; Confidential notes (managers only)

; ═══════════════════════════════════════════════════════════════════════════════
; OFFBOARDING CHECKLIST
; ═══════════════════════════════════════════════════════════════════════════════

{@offboarding_checklist}
= @types.audit_info

checklist_id = !:                                ; Unique checklist identifier
separation_id = !:                               ; Associated separation
employee_id = !:                                 ; Associated employee

; Checklist items
{.items[]}
:(1..)                                           ; At least one item
item_category = (access_termination, benefits, equipment_return, final_pay, knowledge_transfer, notifications, policy_acknowledgment)
item_description = !:                            ; Item description
responsible_party = !:                           ; Who is responsible
due_date = date                                  ; Due date
completed = ?                                    ; Item completed
completed_date = date                            ; Completion date
completed_by = :                                 ; Who completed
notes = :                                        ; Item notes

{@offboarding_checklist}

; Equipment return
{.equipment_returned[]}
equipment_type = (badge, keys, laptop, mobile_phone, tablet, tools, uniform, vehicle, other)
description = :                                  ; Equipment description
asset_tag = :                                    ; Asset tag or ID
returned = ?                                     ; Equipment returned
return_date = date                               ; Return date
condition = (damaged, good, lost, not_returned)  ; Condition
replacement_charge = #$:(0..)                    ; Charge for lost/damaged

{@offboarding_checklist}

; Access termination
{.access_terminated[]}
access_type = (building, email, network, systems, vpn)
system_name = :                                  ; System/application name
access_disabled = ?                              ; Access disabled
disabled_date = date                             ; Date disabled
disabled_by = :                                  ; Who disabled

{@offboarding_checklist}

checklist_completed = ?                          ; All items completed
completion_date = date                           ; Checklist completion date

; ═══════════════════════════════════════════════════════════════════════════════
; EXIT INTERVIEW
; ═══════════════════════════════════════════════════════════════════════════════

{@exit_interview}
= @types.audit_info

interview_id = !:                                ; Unique interview identifier
separation_id = !:                               ; Associated separation
employee_id = !:                                 ; Associated employee
interview_date = !date                           ; Interview date
interview_method = (in_person, online_survey, phone, video)
interviewer_id = :                               ; Interviewer ID
interviewer_name = :                             ; Interviewer name

; Reason for leaving
primary_reason = (advancement_opportunity, better_compensation, career_change, company_culture, commute, education, family_personal, job_dissatisfaction, management, relocation, retirement, work_life_balance, other)
secondary_reasons[] = :                          ; Additional reasons

reason_details = :                               ; Detailed explanation
new_employer_industry = :                        ; New employer industry (if applicable)
new_position_title = :                           ; New position (if applicable)

; Job satisfaction ratings
{.ratings}
overall_satisfaction = ##:(1..5)                 ; Overall satisfaction (1-5)
job_role_satisfaction = ##:(1..5)                ; Job role
compensation_satisfaction = ##:(1..5)            ; Compensation
benefits_satisfaction = ##:(1..5)                ; Benefits
management_satisfaction = ##:(1..5)              ; Management
culture_satisfaction = ##:(1..5)                 ; Company culture
work_life_balance = ##:(1..5)                    ; Work-life balance
growth_opportunities = ##:(1..5)                 ; Career growth
training_development = ##:(1..5)                 ; Training/development

{@exit_interview}

; Feedback
what_did_well = :                                ; What company did well
what_could_improve = :                           ; Improvement suggestions
manager_feedback = *:                            ; Feedback on manager (confidential)
reason_for_staying = :                           ; What would have made them stay
would_recommend_employer = ?                     ; Would recommend to others
would_consider_returning = ?                     ; Would consider returning

; Concerns and issues
concerns_raised = ?                              ; Concerns raised
concern_details = *:                             ; Concern details (confidential)
harassment_discrimination_alleged = ?            ; Harassment/discrimination alleged
investigation_required = ?                       ; Investigation needed
hr_followup_required = ?                         ; HR followup needed

summary = :                                      ; Interview summary
themes_identified = :                            ; Themes for HR
action_items = :                                 ; Action items from interview

; ═══════════════════════════════════════════════════════════════════════════════
; FINAL PAY
; ═══════════════════════════════════════════════════════════════════════════════

{@final_pay}
= @types.audit_info

final_pay_id = !:                                ; Unique final pay identifier
separation_id = !:                               ; Associated separation
employee_id = !:                                 ; Associated employee

last_work_date = !date                           ; Last day worked
final_pay_date = !date                           ; Final paycheck date
payment_method = (check, direct_deposit)        ; Payment method

; Earnings
{.earnings}
regular_wages = #$:(0..)                         ; Regular wages through last day
overtime_wages = #$:(0..)                        ; Overtime wages
unused_pto_payout = #$:(0..)                     ; Unused PTO payout
unused_vacation_payout = #$:(0..)                ; Unused vacation payout
bonus_prorated = #$:(0..)                        ; Prorated bonus
commission = #$:(0..)                            ; Commissions earned
expense_reimbursement = #$:(0..)                 ; Expense reimbursement
other_earnings = #$:(0..)                        ; Other earnings

gross_final_pay = !#$:(0..)                      ; Total gross final pay

{@final_pay}

; Deductions
{.deductions}
federal_tax = #$:(0..)                           ; Federal income tax
social_security = #$:(0..)                       ; Social Security
medicare = #$:(0..)                              ; Medicare
state_tax = #$:(0..)                             ; State income tax
local_tax = #$:(0..)                             ; Local income tax
benefits_owed = #$:(0..)                         ; Benefits premiums owed
loan_repayment = #$:(0..)                        ; Outstanding loans
equipment_charges = #$:(0..)                     ; Equipment not returned
other_deductions = #$:(0..)                      ; Other deductions

total_deductions = #$:(0..)                      ; Total deductions

{@final_pay}

net_final_pay = !#$                              ; Net final pay
:invariant net_final_pay = earnings.gross_final_pay - deductions.total_deductions

check_number = :                                 ; Check number if applicable
payment_confirmation = :                         ; Confirmation number

; State-specific requirements
state = :(2)                                     ; State of employment
immediate_pay_required = ?                       ; State requires immediate pay
final_pay_deadline = date                        ; State-mandated deadline

; ═══════════════════════════════════════════════════════════════════════════════
; SEVERANCE AGREEMENT
; ═══════════════════════════════════════════════════════════════════════════════

{@severance_agreement}
= @types.audit_info

agreement_id = !:                                ; Unique agreement identifier
separation_id = !:                               ; Associated separation
employee_id = !:                                 ; Associated employee

agreement_offered_date = !date                   ; Date offered to employee
agreement_signed_date = date                     ; Date signed by employee
agreement_effective_date = date                  ; Effective date

; Severance payment
severance_amount = !#$:(0..)                     ; Total severance amount
severance_basis = (flat_amount, weeks_of_pay)    ; How calculated
weeks_of_pay = ##:(0..):if severance_basis = weeks_of_pay
payment_schedule = (installments, lump_sum)      ; Payment method
installment_frequency = (biweekly, monthly):if payment_schedule = installments
installment_count = ##:(1..):if payment_schedule = installments

; Additional benefits
{.benefits_continuation}
health_insurance_months = ##:(0..)               ; Months of health coverage
dental_insurance_months = ##:(0..)               ; Months of dental coverage
vision_insurance_months = ##:(0..)               ; Months of vision coverage
life_insurance_months = ##:(0..)                 ; Months of life coverage
employer_pays_premiums = ?                       ; Employer pays COBRA premiums

{@severance_agreement}

outplacement_services = ?                        ; Outplacement provided
outplacement_duration_months = ##:(0..):if outplacement_services = true
outplacement_provider = :if outplacement_services = true

continued_use_of_equipment = ?                   ; Laptop/phone continued use
equipment_duration_days = ##:(0..):if continued_use_of_equipment = true

; Agreement terms
{.terms}
release_of_claims = !?                           ; Releases legal claims
non_disparagement = ?                            ; Non-disparagement clause
confidentiality = ?                              ; Confidentiality clause
non_compete = ?                                  ; Non-compete clause
non_compete_duration_months = ##:(0..):if non_compete = true
non_solicitation = ?                             ; Non-solicitation clause
cooperation_clause = ?                           ; Cooperation with investigations
return_of_property = ?                           ; Must return property

{@severance_agreement}

; Age Discrimination considerations (OWBPA)
employee_age_at_separation = ##:(0..)            ; Employee age
adea_release_included = ?                        ; ADEA release included
owbpa_21_day_period = ?:if adea_release_included = true ; 21-day consideration
owbpa_7_day_revocation = ?:if adea_release_included = true ; 7-day revocation
group_termination = ?                            ; Part of group termination
owbpa_45_day_period = ?:if group_termination = true ; 45-day consideration

consideration_period_start = date                ; Consideration period start
consideration_period_end = date                  ; Consideration period end
revocation_period_end = date                     ; Revocation period end

employee_signature_date = date                   ; Employee signature date
company_signature_date = date                    ; Company signature date
revoked = ?                                      ; Agreement revoked
revocation_date = date                           ; Revocation date

agreement_status = (cancelled, executed, offered, pending, revoked)

; ═══════════════════════════════════════════════════════════════════════════════
; UNEMPLOYMENT CLAIM
; ═══════════════════════════════════════════════════════════════════════════════

{@unemployment_claim}
= @types.audit_info

claim_id = !:                                    ; Unique claim identifier
separation_id = !:                               ; Associated separation
employee_id = !:                                 ; Associated employee (claimant)

state = !:(2)                                    ; State where claim filed
claim_number = *:                                ; State claim number (confidential)
claim_filed_date = !date                         ; Date claim filed

; Claim details
benefit_year_begin = !date                       ; Benefit year start
benefit_year_end = !date                         ; Benefit year end
weekly_benefit_amount = #$:(0..)                 ; Weekly benefit amount
maximum_benefit_amount = #$:(0..)                ; Maximum benefit
waiting_week_required = ?                        ; Waiting week required

; Employer notice
employer_notice_date = !date                     ; Date employer notified
response_due_date = !date                        ; Response due date
employer_response_date = date                    ; Date employer responded
employer_contests = ?                            ; Employer contests claim

; Contest details
contest_reason = (
    insufficient_work_search,
    misconduct,
    quit_without_good_cause,
    refused_suitable_work,
    voluntary_quit
):if employer_contests = true
contest_details = :if employer_contests = true   ; Detailed explanation
supporting_documentation[] = @types.document_reference

; Determination
initial_determination = (approved, denied, pending)
initial_determination_date = date                ; Initial decision date
claimant_eligible = ?                            ; Claimant eligible
employer_charged = ?                             ; Employer UI account charged

; Appeal
appeal_filed = ?                                 ; Appeal filed
appeal_filed_by = (claimant, employer):if appeal_filed = true
appeal_filed_date = date                         ; Appeal date
hearing_date = date                              ; Hearing date
hearing_location = :                             ; Hearing location
hearing_method = (in_person, phone, video)       ; Hearing method

appeal_decision = (affirmed, modified, reversed) ; Appeal decision
appeal_decision_date = date                      ; Decision date
final_decision = (approved, denied)              ; Final decision

; Charges to employer
{.charges}
total_benefits_paid = #$:(0..)                   ; Total benefits paid to claimant
employer_share = #$:(0..)                        ; Employer's share of cost
benefit_charge_date = date                       ; Date charges applied
ui_rate_impact = #                               ; Impact on UI tax rate

{@unemployment_claim}

claim_status = (active, appealed, closed, denied, exhausted, pending)
claim_closed_date = date                         ; Date claim closed

notes = :                                        ; Claim notes

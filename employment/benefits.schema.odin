; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Employee Benefits Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Benefits enrollment, coverage elections (health, dental, vision, life,
; disability, FSA, HSA), beneficiary designations, COBRA administration,
; and qualifying event tracking.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.employment.benefits"
version = "1.0.0"
title = "Employee Benefits Schema"
description = "Benefits enrollment, coverage, beneficiaries, and COBRA"

{$derivation}
source[0].authority = "U.S. Department of Labor"
source[0].citation = "Employee Retirement Income Security Act (ERISA), 29 USC 1001 et seq."
source[0].url = "https://www.law.cornell.edu/uscode/text/29/chapter-18"

source[1].authority = "U.S. Department of Labor"
source[1].citation = "Consolidated Omnibus Budget Reconciliation Act (COBRA), 29 USC 1161-1168"
source[1].url = "https://www.ecfr.gov/current/title-29/subtitle-B/chapter-XXV/subchapter-L/part-2590"

source[2].authority = "Internal Revenue Service"
source[2].citation = "Health Savings Accounts (HSAs), 26 USC 223"
source[2].url = "https://www.irs.gov/publications/p969"

source[3].authority = "Internal Revenue Service"
source[3].citation = "Flexible Spending Arrangements (FSAs), 26 USC 125"
source[3].url = "https://www.irs.gov/publications/p969"

source[4].authority = "Internal Revenue Service"
source[4].citation = "Affordable Care Act (ACA) Reporting, 26 USC 4980H"
source[4].url = "https://www.irs.gov/affordable-care-act"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial employee benefits schema"
changelog[0].rationale = "Enrollment, coverage, beneficiaries, COBRA derived from ERISA, COBRA, IRS HSA/FSA regulations"

; ═══════════════════════════════════════════════════════════════════════════════
; BENEFIT ENROLLMENT
; ═══════════════════════════════════════════════════════════════════════════════

{@benefit_enrollment}
= @types.audit_info

enrollment_id = :                               ; Unique enrollment identifier
employee_id = :                                 ; Associated employee
plan_year = ##:(2000..)                         ; Benefit plan year
enrollment_event = (annual_enrollment, initial_enrollment, life_event, qualifying_event)
enrollment_date = date                          ; Date enrolled
effective_date = date                           ; Coverage effective date

; Enrollment period
enrollment_period_start = date                   ; Enrollment period start
enrollment_period_end = date                     ; Enrollment period end

; Qualifying event (if applicable)
qualifying_event_type = (
    adoption,
    birth,
    death,
    divorce,
    loss_of_coverage,
    marriage,
    spouse_employment_change
):if enrollment_event = qualifying_event
qualifying_event_date = date:if enrollment_event = qualifying_event

; Coverage elections
coverage_elections[] = @coverage_election        ; Benefit elections

status = (active, cancelled, declined, pending, terminated)
status_date = date                               ; Date of status change
termination_date = date                          ; Coverage termination date
termination_reason = :                           ; Reason for termination

; ═══════════════════════════════════════════════════════════════════════════════
; COVERAGE ELECTION
; ═══════════════════════════════════════════════════════════════════════════════

{@coverage_election}
election_id = :                                 ; Unique election identifier
benefit_type = (dental, disability_ltd, disability_std, fsa_dependent_care, fsa_health, hsa, life_add, life_basic, life_spouse, life_child, vision, health)
plan_id = :                                     ; Benefit plan identifier
plan_name = :                                    ; Plan name
carrier = :                                      ; Insurance carrier

; Coverage tier
coverage_tier = (employee_only, employee_spouse, employee_children, family):if benefit_type = health
coverage_tier = (employee_only, employee_spouse, employee_children, family):if benefit_type = dental
coverage_tier = (employee_only, employee_spouse, employee_children, family):if benefit_type = vision

; Life insurance coverage amount
coverage_amount = #$:(0..):if benefit_type = life_basic
coverage_amount = #$:(0..):if benefit_type = life_add
coverage_amount = #$:(0..):if benefit_type = life_spouse
coverage_amount = #$:(0..):if benefit_type = life_child

; Disability coverage
monthly_benefit = #$:(0..):if benefit_type = disability_std
monthly_benefit = #$:(0..):if benefit_type = disability_ltd
elimination_period_days = ##:(0..):if benefit_type = disability_std
elimination_period_days = ##:(0..):if benefit_type = disability_ltd
benefit_period = :if benefit_type = disability_std
benefit_period = :if benefit_type = disability_ltd

; HSA/FSA annual election
annual_election_amount = #$:(0..):if benefit_type = hsa
annual_election_amount = #$:(0..):if benefit_type = fsa_health
annual_election_amount = #$:(0..):if benefit_type = fsa_dependent_care

; Premium
employee_premium = #$:(0..)                     ; Employee premium (per pay period)
employer_premium = #$:(0..)                      ; Employer premium (per pay period)
total_premium = #$:(0..)                         ; Total premium
premium_frequency = (biweekly, monthly, semi_monthly, weekly)

; Dependents covered
dependents_covered[] = @covered_dependent        ; Dependents on this coverage

waived = ?                                       ; Coverage waived
waiver_reason = :if waived = true                ; Reason for waiver

effective_date = date                           ; Coverage effective date
termination_date = date                          ; Coverage termination date

; ═══════════════════════════════════════════════════════════════════════════════
; COVERED DEPENDENT
; ═══════════════════════════════════════════════════════════════════════════════

{@covered_dependent}
dependent_id = :                                ; Unique dependent identifier
name = @types.person_name                       ; Dependent name
relationship = (child, domestic_partner, spouse)
date_of_birth = *date                           ; DOB (confidential)
ssn = *:format ssn                    ; SSN if applicable (confidential)
gender = (female, male, non_binary)

student = ?                                      ; Full-time student
disabled = ?                                     ; Disabled dependent
adopted = ?                                      ; Adopted child
court_ordered = ?                                ; Court-ordered coverage

effective_date = date                           ; Coverage effective date
termination_date = date                          ; Coverage termination date
termination_reason = :                           ; Reason coverage ended

; ═══════════════════════════════════════════════════════════════════════════════
; BENEFICIARY
; ═══════════════════════════════════════════════════════════════════════════════

{@beneficiary}
= @types.audit_info

beneficiary_id = :                              ; Unique beneficiary identifier
employee_id = :                                 ; Associated employee
benefit_type = (life_add, life_basic, life_child, life_spouse, retirement_401k, retirement_403b)

; Beneficiary information
{.beneficiary_info}
name = @types.person_name                       ; Beneficiary name
relationship = :                                ; Relationship to employee
date_of_birth = *date                            ; DOB (confidential)
ssn = *:format ssn                    ; SSN (confidential)
address = @types.address                         ; Beneficiary address
phones[] = *@types.phone                         ; Phone numbers
emails[] = *@types.email                         ; Email addresses

{@beneficiary}

beneficiary_type = (contingent, primary)        ; Primary or contingent
percentage = #:(0..100)                         ; Percentage of benefit
per_stirpes = ?                                  ; Per stirpes distribution

designation_date = date                         ; Date designated
effective_date = date                           ; Effective date
removed_date = date                              ; Date removed (if applicable)
removed_reason = :                               ; Reason removed

; ═══════════════════════════════════════════════════════════════════════════════
; COBRA ENROLLMENT
; ═══════════════════════════════════════════════════════════════════════════════

{@cobra_enrollment}
= @types.audit_info

cobra_id = :                                    ; Unique COBRA identifier
employee_id = :                                 ; Former employee ID
qualified_beneficiary_id = :                     ; Qualified beneficiary ID
qualifying_event = (death, divorce, employment_termination, hours_reduction, medicare_entitlement, dependent_loss)
qualifying_event_date = date                    ; Date of qualifying event

; Notice dates (COBRA compliance)
employer_notice_date = date                      ; Date employer notified of event
election_notice_sent_date = date                ; Date election notice sent
election_notice_sent_method = (certified_mail, email, hand_delivery)

election_deadline = date                        ; Election deadline (60 days)
election_received_date = date                    ; Date election received
elected = ?                                      ; Elected COBRA
declined = ?                                     ; Declined COBRA
declined_date = date                             ; Date declined

; Coverage details
coverage_type = (dental, health, vision)        ; Type of COBRA coverage
prior_plan_id = :                                ; Original plan ID
coverage_start_date = date:if elected = true     ; COBRA coverage start
coverage_end_date = date                         ; COBRA coverage end
maximum_coverage_months = ##:(18..36)           ; Max coverage period

; Premium
monthly_premium = #$:(0..):if elected = true    ; Monthly COBRA premium
administrative_fee = #$:(0..):if elected = true  ; Admin fee (2% max)
total_monthly_cost = #$:(0..):if elected = true  ; Total monthly cost

; Payment tracking
{.payments[]}
payment_month = date                            ; Month of coverage
due_date = date                                 ; Payment due date
payment_received_date = date                     ; Date payment received
payment_amount = #$:(0..)                        ; Payment amount
late = ?                                         ; Payment was late
grace_period_end = date                          ; Grace period end date

{@cobra_enrollment}

; Termination
termination_date = date                          ; COBRA termination date
termination_reason = (coverage_exhausted, medicare_eligible, non_payment, reemployed, voluntary)
final_notice_sent_date = date                    ; Final notice sent

; ═══════════════════════════════════════════════════════════════════════════════
; HSA ACCOUNT
; ═══════════════════════════════════════════════════════════════════════════════

{@hsa_account}
= @types.audit_info

account_id = :                                  ; Unique HSA account ID
employee_id = :                                 ; Associated employee
plan_year = ##:(2000..)                         ; Plan year
account_number = *:                             ; HSA account number (confidential)
custodian = :                                   ; HSA custodian/bank

; Contribution limits (IRS annual limits)
annual_contribution_limit = #$:(0..)            ; IRS annual limit
catch_up_contribution_limit = #$:(0..):if age_55_or_older = true
age_55_or_older = ?                              ; Eligible for catch-up

; Contribution tracking
employee_contribution_ytd = #$:(0..)             ; Employee contributions YTD
employer_contribution_ytd = #$:(0..)             ; Employer contributions YTD
total_contribution_ytd = #$:(0..)                ; Total YTD contributions
remaining_contribution_room = #$:(0..)           ; Remaining contribution space

:invariant total_contribution_ytd = employee_contribution_ytd + employer_contribution_ytd

; Account balance
account_balance = #$:(0..)                       ; Current account balance
invested_balance = #$:(0..)                      ; Amount invested
cash_balance = #$:(0..)                          ; Cash balance

; Distributions
total_distributions_ytd = #$:(0..)               ; Total distributions YTD
qualified_distributions_ytd = #$:(0..)           ; Qualified medical distributions
non_qualified_distributions_ytd = #$:(0..)       ; Non-qualified distributions

; ═══════════════════════════════════════════════════════════════════════════════
; FSA ACCOUNT
; ═══════════════════════════════════════════════════════════════════════════════

{@fsa_account}
= @types.audit_info

account_id = :                                  ; Unique FSA account ID
employee_id = :                                 ; Associated employee
plan_year = ##:(2000..)                         ; Plan year
fsa_type = (dependent_care, health_care)        ; FSA type

; Election
annual_election = #$:(0..)                      ; Annual election amount
per_pay_period = #$:(0..)                        ; Deduction per pay period
total_contributed_ytd = #$:(0..)                 ; Total contributed YTD

; Reimbursements
total_reimbursed_ytd = #$:(0..)                  ; Total reimbursed YTD
pending_reimbursements = #$:(0..)                ; Pending claims
available_balance = #$:(0..)                     ; Available to reimburse

; Use-it-or-lose-it rules
carryover_allowed = ?                            ; Plan allows carryover
max_carryover_amount = #$:(0..):if carryover_allowed = true
carryover_from_prior_year = #$:(0..)             ; Carryover from prior year
grace_period_allowed = ?                         ; Grace period allowed
grace_period_end = date:if grace_period_allowed = true

run_out_period_end = date                       ; Run-out period end date
forfeited_amount = #$:(0..)                      ; Forfeited (use-it-or-lose-it)

; ═══════════════════════════════════════════════════════════════════════════════
; FSA CLAIM
; ═══════════════════════════════════════════════════════════════════════════════

{@fsa_claim}
= @types.audit_info

claim_id = :                                    ; Unique claim identifier
account_id = :                                  ; Associated FSA account
employee_id = :                                 ; Associated employee

claim_date = date                               ; Date claim submitted
service_date = date                             ; Date of service
service_end_date = date                          ; End date (for range)
provider_name = :                               ; Provider/merchant name
amount_requested = #$:(0..)                     ; Reimbursement requested

expense_type = :                                ; Type of expense
description = :                                  ; Expense description

; Documentation
documentation_received = ?                       ; Documentation provided
documentation_type = :                           ; Type of documentation

; Claim status
status = (approved, denied, paid, pending, submitted)
status_date = date                               ; Date of status change
approved_date = date                             ; Date approved
approved_amount = #$:(0..)                       ; Amount approved
denied_date = date                               ; Date denied
denial_reason = :                                ; Reason for denial
paid_date = date                                 ; Date paid
paid_amount = #$:(0..)                           ; Amount paid
check_number = :                                 ; Check number or EFT confirmation

notes = :                                        ; Claim notes

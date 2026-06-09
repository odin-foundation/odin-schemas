; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Employee Benefits Common Types Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Common types for employee benefits administration derived from ERISA, IRS,
; and DOL requirements.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.benefits.types"
version = "1.0.0"
title = "Employee Benefits Common Types Schema"
description = "Common types for employee benefits administration"

{$derivation}
source[0].authority = "GPO"
source[0].citation = "29 USC Chapter 18 - ERISA"
source[0].url = "https://www.law.cornell.edu/uscode/text/29/chapter-18"

source[1].authority = "IRS"
source[1].citation = "IRC Section 125 - Cafeteria Plans"
source[1].url = "https://www.law.cornell.edu/uscode/text/26/125"

source[2].authority = "DOL"
source[2].citation = "EBSA Compliance Assistance"
source[2].url = "https://www.dol.gov/agencies/ebsa/employers-and-advisers/guidance"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial employee benefits types schema"
changelog[0].rationale = "Structure derived from ERISA and IRS requirements"

; ═══════════════════════════════════════════════════════════════════════════════
; EMPLOYER
; ═══════════════════════════════════════════════════════════════════════════════

{@employer}
= @organization                             ; Inherits organization fields

employer_id = :                            ; Employer identifier
ein = *:                                   ; Employer Identification Number (overrides tax_id)

; Classification
{.classification}
entity_type = (corporation, government, llc, nonprofit, partnership, sole_prop)
industry_naics = :                          ; NAICS code
ale_status = ?                              ; Applicable Large Employer (ACA)
full_time_employees = ##:(0..)              ; FTE count
total_employees = ##:(0..)                  ; Total employee count

{@employer}

; HR Contact
hr_contact = :                              ; HR contact name
hr_email = *@email                          ; HR email

; Plan sponsor
{.sponsor}
plan_sponsor = ?true                        ; Is plan sponsor
fiduciary = :                               ; Named fiduciary
plan_administrator = :                      ; Plan administrator

{@employer}

; ═══════════════════════════════════════════════════════════════════════════════
; EMPLOYEE
; ═══════════════════════════════════════════════════════════════════════════════

{@employee}
employee_id = :                            ; Employee ID
employer_id = :                            ; Employer ID

; Demographics
{.demographics}
first_name = :                             ; First name
middle_name = :                             ; Middle name
last_name = :                              ; Last name
suffix = :                                  ; Suffix
ssn = *:                                   ; SSN
dob = *date                                ; Date of birth
gender = (female, male, other)              ; Gender
marital_status = (divorced, married, single, widowed)

{@employee}

; Employment
{.employment}
hire_date = date                           ; Hire date
termination_date = date                     ; Termination date
employment_status = (active, leave, terminated)
employment_type = (full_time, part_time, seasonal, temporary)
job_title = :                               ; Job title
department = :                              ; Department
location = :                                ; Work location
pay_frequency = (biweekly, monthly, semi_monthly, weekly)
annual_salary = #$:(0..)                    ; Annual salary
hourly_rate = #$:(0..)                      ; Hourly rate

{@employee}

; Benefits eligibility
{.eligibility}
benefits_eligible = ?                       ; Eligible for benefits
eligibility_date = date                     ; Eligibility date
waiting_period_days = ##:(0..365)           ; Waiting period
class = :                                   ; Benefits class (exec, hourly, etc.)

{@employee}

; Contact
address = @address                          ; Physical address
phones[] = *@phone                          ; Phone numbers
personal_email = *@email                    ; Personal email
work_email = *@email                        ; Work email

{@employee}

; ═══════════════════════════════════════════════════════════════════════════════
; DEPENDENT
; ═══════════════════════════════════════════════════════════════════════════════

{@dependent}
dependent_id = :                           ; Dependent ID
employee_id = :                            ; Employee ID

; Demographics
{.demographics}
first_name = :                             ; First name
middle_name = :                             ; Middle name
last_name = :                              ; Last name
ssn = *:                                    ; SSN
dob = *date                                ; Date of birth
gender = (female, male, other)              ; Gender

{@dependent}

; Relationship - Per IRS and plan definitions
{.relationship}
relationship = (child, domestic_partner, parent, spouse, step_child)
spouse = ?                                  ; Spouse relationship
child = ?                                   ; Child relationship
disabled = ?                                ; Disabled dependent
full_time_student = ?                       ; Full-time student
student_school = :                          ; School name (if student)

{@dependent}

; Eligibility
{.eligibility}
eligible = ?                                ; Currently eligible
eligibility_date = date                     ; Date became eligible
ineligibility_date = date                   ; Date became ineligible
age_out_date = date                         ; Age-out date (children)

{@dependent}

; Address if different from employee
different_address = ?                       ; Has different address
address = @address                          ; Physical address (if different)

{@dependent}

; ═══════════════════════════════════════════════════════════════════════════════
; BENEFICIARY
; ═══════════════════════════════════════════════════════════════════════════════

{@beneficiary}
beneficiary_id = :                         ; Beneficiary ID
employee_id = :                            ; Employee ID
benefit_type = :                           ; Which benefit (life, 401k, etc.)

; Beneficiary info
{.info}
beneficiary_type = (charity, estate, individual, trust)
name = :                                   ; Name (person, trust, or entity)
ssn_tin = *:                                ; SSN or TIN
dob = *date                                 ; Date of birth (if individual)
relationship = :                            ; Relationship to employee

{@beneficiary}

; Designation
{.designation}
designation_type = (contingent, per_stirpes, primary)
percentage = #:(0..100)                    ; Percentage share
effective_date = date                       ; Designation date

{@beneficiary}

; Contact
address = @address                          ; Physical address
phone = *@phone                             ; Phone number

{@beneficiary}

; ═══════════════════════════════════════════════════════════════════════════════
; BENEFIT PLAN
; ═══════════════════════════════════════════════════════════════════════════════

{@benefit_plan}
plan_id = :                                ; Plan identifier
employer_id = :                            ; Employer
plan_name = :                              ; Plan name
plan_type = :                              ; Type code
plan_year = ##:(2000..)                    ; Plan year

; Plan category
{.category}
category = (dental, disability, health, life, retirement, vision, voluntary)
erisa_plan = ?                              ; Subject to ERISA
welfare_plan = ?                            ; ERISA welfare benefit plan
pension_plan = ?                            ; ERISA pension plan

{@benefit_plan}

; Dates
{.dates}
effective_date = date                      ; Plan effective date
termination_date = date                     ; Plan termination date
plan_year_start = date                      ; Plan year start
plan_year_end = date                        ; Plan year end

{@benefit_plan}

; Carrier/administrator
{.carrier}
carrier_name = :                            ; Insurance carrier
carrier_id = :                              ; Carrier ID
policy_number = :                           ; Policy number
group_number = :                            ; Group number
tpa_name = :                                ; Third party administrator

{@benefit_plan}

; Compliance
{.compliance}
spd_provided = ?                            ; SPD provided to participants
form_5500_filed = ?                         ; Form 5500 filed
wrap_document = ?                           ; Has wrap document
erisa_bond = ?                              ; Fidelity bond in place

{@benefit_plan}

; ═══════════════════════════════════════════════════════════════════════════════
; ENROLLMENT
; ═══════════════════════════════════════════════════════════════════════════════

{@enrollment}
enrollment_id = :                          ; Enrollment ID
employee_id = :                            ; Employee
plan_id = :                                ; Plan

; Enrollment type
{.type}
enrollment_type = (initial, open_enrollment, qle, termination)
election = (decline, elect)
coverage_level = :                          ; ee, ee+sp, ee+ch, family, etc.

{@enrollment}

; Dates
{.dates}
enrollment_date = date                     ; Enrollment date
effective_date = date                      ; Coverage effective date
termination_date = date                     ; Coverage termination date
qle_date = date                             ; QLE date if applicable
qle_type = :                                ; QLE type if applicable

{@enrollment}

; Covered persons
{.covered}
employee_covered = ?                        ; Employee covered
dependents_covered[] = :                    ; Covered dependent IDs

{@enrollment}

; Premium
{.premium}
total_premium = #$:(0..)                    ; Total premium
employer_contribution = #$:(0..)            ; Employer pays
employee_contribution = #$:(0..)            ; Employee pays
pre_tax = ?                                 ; Pre-tax deduction (Section 125)
deduction_frequency = (biweekly, monthly, semi_monthly, weekly)

{@enrollment}

; Status
status = (active, pending, terminated, waived)

; ═══════════════════════════════════════════════════════════════════════════════
; QUALIFYING LIFE EVENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per IRC Section 125

{@qle}
qle_id = :                                 ; QLE ID
employee_id = :                            ; Employee
event_date = date                          ; Event date

; Event type - Per Section 125 regulations
{.event}
event_type = (birth_adoption, change_residence, death, divorce, employment_change, legal_separation, loss_coverage, marriage, medicare_medicaid, other)
event_description = :                       ; Description
court_order = ?                             ; Court-ordered change

{@qle}

; Documentation
{.documentation}
documentation_required = ?                  ; Documentation required
documentation_type = :                      ; Type required
documentation_received = ?                  ; Documentation received
documentation_date = date                   ; Date received

{@qle}

; Enrollment window
{.window}
notification_deadline = date                ; Must notify by
election_deadline = date                    ; Must elect by
days_from_event = ##:(30..60)               ; Days allowed

{@qle}

; Status
{.status}
status = (approved, denied, pending)
approval_date = date                        ; Approval date
denial_reason = :                           ; Denial reason

{@qle}

; ═══════════════════════════════════════════════════════════════════════════════
; OPEN ENROLLMENT
; ═══════════════════════════════════════════════════════════════════════════════

{@open_enrollment}
oe_id = :                                  ; Open enrollment ID
employer_id = :                            ; Employer
plan_year = ##:(2000..)                    ; Plan year

; Period
{.period}
start_date = date                          ; OE start date
end_date = date                            ; OE end date
effective_date = date                      ; Coverage effective date

{@open_enrollment}

; Plans available
plans[] = :                                 ; Plans available for election

; Communication
{.communication}
enrollment_guide_sent = ?                   ; Enrollment guide sent
benefit_fair_scheduled = ?                  ; Benefit fair scheduled
benefit_fair_date = date                    ; Benefit fair date
reminder_sent = ?                           ; Reminder sent

{@open_enrollment}

; Status
{.status}
status = (active, completed, upcoming)
participation_rate = #:(0..100)             ; Participation rate

{@open_enrollment}

; ═══════════════════════════════════════════════════════════════════════════════
; DEDUCTION
; ═══════════════════════════════════════════════════════════════════════════════

{@deduction}
deduction_id = :                           ; Deduction ID
employee_id = :                            ; Employee
benefit_type = :                           ; Benefit type

; Amount
{.amount}
amount = #$:(0..)                           ; Deduction amount
per_pay_period = ?                          ; Per pay period
annual = ?                                  ; Annual deduction

{@deduction}

; Tax treatment
{.tax}
pre_tax = ?                                 ; Pre-tax (Section 125)
post_tax = ?                                ; Post-tax
roth = ?                                    ; Roth (after-tax retirement)

{@deduction}

; Effective dates
{.dates}
effective_date = date                       ; Start date
end_date = date                             ; End date

{@deduction}

; ═══════════════════════════════════════════════════════════════════════════════
; CAFETERIA PLAN (SECTION 125)
; ═══════════════════════════════════════════════════════════════════════════════
; Per IRC Section 125

{@cafeteria_plan}
plan_id = :                                ; Plan ID
employer_id = :                            ; Employer
plan_year = ##:(2000..)                    ; Plan year

; Plan document
{.document}
plan_document_date = date                   ; Plan document date
amendment_date = date                       ; Last amendment

{@cafeteria_plan}

; Eligible benefits - Per Section 125
{.benefits}
health_insurance = ?                        ; Group health
dental = ?                                  ; Dental
vision = ?                                  ; Vision
fsa_health = ?                              ; Health FSA
fsa_dependent_care = ?                      ; Dependent Care FSA
hsa_contributions = ?                       ; HSA contributions
adoption_assistance = ?                     ; Adoption assistance
group_term_life = ?                         ; Group term life (up to $50k)
disability = ?                              ; Disability premiums
accident_insurance = ?                      ; Accident
critical_illness = ?                        ; Critical illness
hospital_indemnity = ?                      ; Hospital indemnity

{@cafeteria_plan}

; Non-discrimination testing
{.testing}
highly_compensated_test = ?                 ; Passed HC test
key_employee_test = ?                       ; Passed key EE test
eligibility_test = ?                        ; Passed eligibility test
benefits_test = ?                           ; Passed benefits test
testing_date = date                         ; Testing date

{@cafeteria_plan}


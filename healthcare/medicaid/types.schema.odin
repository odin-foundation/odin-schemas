; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Medicaid Common Types
; ═══════════════════════════════════════════════════════════════════════════════
; Reusable type definitions shared across Medicaid schemas including member,
; household, eligibility group, and benefit package types. Derived from CMS
; Medicaid guidance and 42 CFR regulations.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.medicaid.types"
version = "1.0.0"
title = "Medicaid Common Types"
description = "Reusable type definitions for Medicaid schemas"

{$derivation}
source[0].authority = "CMS"
source[0].citation = "Medicaid Eligibility Handbook"
source[0].url = "https://www.medicaid.gov/medicaid/eligibility/index.html"

source[1].authority = "GPO"
source[1].citation = "42 CFR Part 435 - Eligibility in the States, District of Columbia, the Northern Mariana Islands, and American Samoa"
source[1].url = "https://www.ecfr.gov/current/title-42/chapter-IV/subchapter-C/part-435"

source[2].authority = "GPO"
source[2].citation = "42 CFR Part 438 - Managed Care"
source[2].url = "https://www.ecfr.gov/current/title-42/chapter-IV/subchapter-C/part-438"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial Medicaid common types schema"
changelog[0].rationale = "Base types derived from CMS Medicaid guidance and 42 CFR"

; ═══════════════════════════════════════════════════════════════════════════════
; MEDICAID MEMBER
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR Part 435

{@member}
= @person                                    ; Inherits person fields (name, ssn, dob, contact)

; Identification
medicaid_id = *:                            ; State Medicaid ID
state = :(2)                                ; State of coverage

; Override required name fields
{.name}
first = :                                   ; First name (required)
last = :                                    ; Last name (required)

{@member}

; Override required demographics
date_of_birth = *date                       ; Date of birth (required)
gender = (female, male)                     ; Administrative gender (required)

; Medicaid-specific fields
citizenship_status = (citizen, lawfully_present, other)  ; Citizenship/immigration status
residence_type = (community, institution, other)  ; Living situation
interpreter_needed = ?                       ; Interpreter needed

; ═══════════════════════════════════════════════════════════════════════════════
; HOUSEHOLD
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 435.603 - MAGI household composition

{@household}
household_id = :                            ; Household identifier
size = ##:(1..)                             ; Household size

; Members
members[] = @household_member                ; Household members

; Income - Per MAGI methodology
{.income}
monthly_gross = #$:(0..)                     ; Monthly gross income
annual_gross = #$:(0..)                      ; Annual gross income
magi = #$:(0..)                              ; Modified Adjusted Gross Income
fpl_percent = #:(0..)                        ; Income as percent of FPL

{@household}

; Deductions - Per 42 CFR 435.603(d)
{.deductions}
standard_deduction = #$:(0..)                ; 5% standard deduction
child_care = #$:(0..)                        ; Child care deduction
self_employment = #$:(0..)                   ; Self-employment expenses

{@household}

{@household_member}
member_ref = :                               ; Reference to @member
relationship_to_applicant = (child, grandchild, grandparent, other, parent, self, sibling, spouse, step_child, step_parent)
tax_filer = ?                                ; Tax filer status
tax_dependent = ?                            ; Claimed as tax dependent
pregnant = ?                                 ; Currently pregnant
disabled = ?                                 ; Meets disability criteria
student = ?                                  ; Student status
incarcerated = ?                             ; Incarceration status

; ═══════════════════════════════════════════════════════════════════════════════
; ELIGIBILITY GROUP
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 435 Subpart B-H

{@eligibility_group}
group_code = :                              ; Eligibility group code
group_name = :                              ; Eligibility group name
methodology = (magi, non_magi)              ; Eligibility methodology

; MAGI groups - Per 42 CFR 435.110-119
magi_category = (adult, child, chip, former_foster, parent, pregnant, targeted_low_income_child):if methodology = magi

; Non-MAGI groups - Per 42 CFR 435.120-137
non_magi_category = (aged, blind, disabled, foster_care, medically_needy, ssi, ssi_related):if methodology = non_magi

; Income limits
{.income_limits}
fpl_percent = #:(0..400)                     ; FPL percentage limit
income_standard = #$:(0..)                   ; Dollar amount limit
resource_limit = #$:(0..)                    ; Asset/resource limit (non-MAGI)

{@eligibility_group}

; ═══════════════════════════════════════════════════════════════════════════════
; BENEFIT PACKAGE
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 440 - Services

{@benefit_package}
package_id = :                              ; Benefit package identifier
package_name = :                             ; Package name
state = :(2)                                ; State
effective_date = date                       ; Effective date

; Package type
package_type = (abp, benchmark, benchmark_equivalent, state_plan)
; abp = Alternative Benefit Plan (Section 1937)
; benchmark = Benchmark coverage
; benchmark_equivalent = Benchmark-equivalent
; state_plan = Standard state plan benefits

; Coverage type
coverage_type = (comprehensive, limited, targeted)

{@benefit_package}

; ═══════════════════════════════════════════════════════════════════════════════
; COVERAGE PERIOD
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 435.916

{@coverage_period}
member_id = :                               ; Member ID
effective_date = date                       ; Coverage start date
end_date = date                              ; Coverage end date
status = (active, closed, pending, suspended)

; Eligibility group
eligibility_group = @eligibility_group      ; Eligibility group

; Benefit package
benefit_package = @benefit_package           ; Assigned benefit package

; Managed care enrollment
mco_enrollment = @mco_enrollment             ; MCO if enrolled

; Termination
{.termination}
reason = (death, eligibility_change, incarceration, moved, non_renewal, request, other):if status = closed
termination_date = date                      ; Termination effective date

{@coverage_period}

; ═══════════════════════════════════════════════════════════════════════════════
; MCO ENROLLMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 438.54

{@mco_enrollment}
plan_id = :                                 ; Plan identifier
plan_name = :                                ; Plan name
plan_type = (mco, pahp, pccm, pihp)         ; Plan type
; mco = Managed Care Organization
; pihp = Prepaid Inpatient Health Plan
; pahp = Prepaid Ambulatory Health Plan
; pccm = Primary Care Case Management

effective_date = date                       ; Enrollment effective date
end_date = date                              ; Enrollment end date

; Enrollment type
{.enrollment}
type = (auto_assigned, beneficiary_choice, default, mandatory)
pcp_assigned = ?                             ; PCP assigned
pcp_name = :                                 ; PCP name
pcp_npi = :                                  ; PCP NPI

{@mco_enrollment}

; ═══════════════════════════════════════════════════════════════════════════════
; INCOME TYPES
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 435.601-603

{@income}
income_type = (alimony, business, child_support, earned, interest_dividends, other, pension, rental, self_employment, social_security, ssi, unemployment, veterans)
source = :                                   ; Income source name
frequency = (annual, biweekly, monthly, one_time, semi_monthly, weekly)
amount = #$:(0..)                            ; Income amount
start_date = date                            ; Income start date
end_date = date                              ; Income end date
verified = ?                                 ; Income verified
verification_source = :                      ; Verification source

; Tax treatment - Per MAGI
taxable = ?                                  ; Counted as taxable income
countable = ?                                ; Counted for Medicaid eligibility

; ═══════════════════════════════════════════════════════════════════════════════
; RESOURCE/ASSET TYPES
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 435.840-845 (Non-MAGI only)

{@resource}
resource_type = (burial_fund, cash, life_insurance, other, property, retirement_account, vehicle)
description = :                              ; Resource description
value = #$:(0..)                             ; Resource value
countable = ?                                ; Countable for eligibility
exempt_reason = :                            ; Reason if exempt

; ═══════════════════════════════════════════════════════════════════════════════
; VERIFICATION TYPES
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 435.948-956

{@verification}
verification_type = (citizenship, identity, income, residency, ssn)
status = (not_verified, pending, verified)
method = (data_source, documentation, self_attestation)
source = :                                   ; Verification source
date = date                                  ; Verification date
expiration = date                            ; When reverification needed
document_type = :                            ; Document type if submitted

; ═══════════════════════════════════════════════════════════════════════════════
; REASONABLE OPPORTUNITY PERIOD
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 435.956(b)

{@rop}
rop_type = (citizenship, immigration, ssn)
start_date = date                           ; ROP start date
end_date = date                             ; ROP end date (90 days)
status = (closed, expired, open)
documentation_received = ?                   ; Documentation received
documentation_date = date                    ; Date received
determination = (eligible, ineligible, pending)

; ═══════════════════════════════════════════════════════════════════════════════
; THIRD PARTY LIABILITY
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR Part 433 Subpart D

{@tpl}
member_id = :                               ; Member ID
carrier_type = (commercial, employer, medicare, military, other)
carrier_name = :                             ; Insurance carrier name
policy_number = :                            ; Policy number
group_number = :                             ; Group number
policyholder_name = :                        ; Policyholder name
relationship = (other, self, spouse)         ; Relationship to policyholder
effective_date = date                        ; Coverage effective date
end_date = date                              ; Coverage end date
verified = ?                                 ; TPL verified
verification_date = date                     ; Verification date


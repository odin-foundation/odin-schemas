; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Government Benefits - Social Security Programs Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Social Security Administration programs including SSDI, SSI, retirement,
; and survivor benefits. Covers applications, earnings records, benefit
; calculations, disability determinations, and appeals processes.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.government.benefits.social-security"
version = "1.0.0"
title = "Social Security Programs"
description = "SSDI, SSI, retirement, and survivor benefits"

{$derivation}
source[0].authority = "Social Security Administration"
source[0].citation = "42 USC Chapter 7 - Social Security"
source[0].url = "https://www.ssa.gov/"
source[0].accessed = 2025-12-21

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial social security benefits schema"
changelog[0].rationale = "Social Security programs per SSA regulations"

; ═══════════════════════════════════════════════════════════════════════════════
; SOCIAL SECURITY DISABILITY INSURANCE (SSDI)
; ═══════════════════════════════════════════════════════════════════════════════

{@ssdi_application}
= @types.audit_info

application_date = !date
claim_number = :

; Applicant Information
{.applicant}
first_name = !:
last_name = !:
ssn = !*:format ssn
date_of_birth = !*date
address = !@address
phone = @phone
email = @email
marital_status = (divorced, married, never_married, widowed)

{@ssdi_application}
; Disability Information
{.disability}
alleged_onset_date = !date
disability_description = !:
still_working = ?
last_day_worked = date
unable_to_work_since = date

{@ssdi_application}
; Medical Conditions
{.medical_conditions[]}
condition_name = !:
diagnosis_date = date
treating_physician = :
hospitalized = ?

{@ssdi_application}
; Work History
{.work_history[]}
employer = !:
job_title = !:
start_date = !date
end_date = date
hours_per_week = #:(0..168)
earnings = #$:(0..)

{@ssdi_application}
; Decision
{.determination}
status = (approved, denied, pending, under_review)
decision_date = date
benefit_start_date = date
monthly_benefit = #$:(0..)
denial_reason = :
appeal_filed = ?

{@ssdi_application}
; ═══════════════════════════════════════════════════════════════════════════════
; SUPPLEMENTAL SECURITY INCOME (SSI)
; ═══════════════════════════════════════════════════════════════════════════════

{@ssi_application}
= @types.audit_info

application_date = !date
claim_number = :

; Applicant
{.applicant}
first_name = !:
last_name = !:
ssn = *:format ssn
date_of_birth = !*date
address = !@address
phone = @phone
citizen = !?
living_arrangement = (alone, household, institution, nursing_home)

{@ssi_application}
; Disability/Age/Blindness
{.eligibility_basis}
aged_65_or_older = ?
disabled = ?
blind = ?
disability_onset_date = date

{@ssi_application}
; Income
{.income}
earned_income = #$:(0..)
unearned_income = #$:(0..)
in_kind_support = #$:(0..)
deeming_income = #$:(0..)
total_countable_income = #$:(0..)

{@ssi_application}
; Resources
{.resources}
cash = #$:(0..)
bank_accounts = #$:(0..)
vehicles_value = #$:(0..)
real_property_value = #$:(0..)
life_insurance_value = #$:(0..)
total_countable_resources = #$:(0..)

{@ssi_application}
; Benefit Determination
{.benefit}
eligible = ?
federal_benefit_rate = #$:(0..)
state_supplement = #$:(0..)
total_monthly_benefit = #$:(0..)
payment_start_date = date

{@ssi_application}
; ═══════════════════════════════════════════════════════════════════════════════
; RETIREMENT BENEFITS
; ═══════════════════════════════════════════════════════════════════════════════

{@retirement_benefits}
= @types.audit_info

claim_number = :
application_date = date

; Claimant
{.claimant}
first_name = !:
last_name = !:
ssn = !*:format ssn
date_of_birth = !*date
address = !@address
marital_status = (divorced, married, never_married, widowed)

{@retirement_benefits}
; Retirement Age
{.retirement}
full_retirement_age = ##:(62..70)
actual_retirement_age = ##:(62..70)
early_retirement = ?
delayed_retirement_credits = ##:(0..)

{@retirement_benefits}
; Work History
{.earnings}
quarters_of_coverage = !##:(40..)
average_indexed_monthly_earnings = #$:(0..)
primary_insurance_amount = #$:(0..)

{@retirement_benefits}
; Benefit Amount
{.benefit}
monthly_benefit_amount = !#$:(0..)
reduction_factor = #:(0..100)
cost_of_living_adjustment = #:(0..100)
payment_start_date = !date

{@retirement_benefits}
; Spouse/Dependent Benefits
{.dependents[]}
name = !:
ssn = *:format ssn
relationship = (child, ex_spouse, spouse)
benefit_amount = #$:(0..)

{@retirement_benefits}
; Direct Deposit
{.payment}
account_type = (checking, savings)
routing_number = *:(9)
account_number = *:

{@retirement_benefits}
; ═══════════════════════════════════════════════════════════════════════════════
; SURVIVOR BENEFITS
; ═══════════════════════════════════════════════════════════════════════════════

{@survivor_benefits}
= @types.audit_info

claim_number = :
application_date = date

; Deceased Worker
{.deceased}
first_name = !:
last_name = !:
ssn = !*:format ssn
date_of_birth = *date
date_of_death = !date

{@survivor_benefits}
; Survivor/Claimant
{.claimant}
first_name = !:
last_name = !:
ssn = !*:format ssn
date_of_birth = !*date
relationship = (child, parent, spouse, surviving_divorced_spouse)
address = !@address

{@survivor_benefits}
; Benefit Eligibility
{.eligibility}
eligible = ?
benefit_type = (child, lump_sum_death, parent, widow_widower)
monthly_benefit = #$:(0..)
payment_start_date = date
benefit_end_date = date

{@survivor_benefits}
; Dependent Children
{.children[]}
name = !:
ssn = *:format ssn
date_of_birth = *date
disabled = ?
full_time_student = ?
benefit_amount = #$:(0..)

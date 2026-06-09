; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Government Benefits - Public Assistance Programs Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Public assistance programs including SNAP, TANF, WIC, and housing assistance.
; Covers eligibility determination, benefit calculations, household
; composition, recertification, and case management workflows.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.government.benefits.assistance"
version = "1.0.0"
title = "Public Assistance Programs"
description = "SNAP, TANF, WIC, and housing assistance programs"

{$derivation}
source[0].authority = "U.S. Department of Agriculture"
source[0].citation = "7 USC Chapter 51 - Supplemental Nutrition Assistance Program"
source[0].url = "https://www.fns.usda.gov/snap"
source[0].accessed = 2025-12-21

source[1].authority = "U.S. Department of Health and Human Services"
source[1].citation = "45 CFR Part 260 - TANF Requirements"
source[1].url = "https://www.acf.hhs.gov/ofa/programs/tanf"
source[1].accessed = 2025-12-21

source[2].authority = "U.S. Department of Housing and Urban Development"
source[2].citation = "24 CFR Part 982 - Section 8 Housing Choice Voucher Program"
source[2].url = "https://www.hud.gov/program_offices/public_indian_housing/programs/hcv"
source[2].accessed = 2025-12-21

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial public assistance schema"
changelog[0].rationale = "Public benefit programs per federal regulations"

; ═══════════════════════════════════════════════════════════════════════════════
; SNAP (Supplemental Nutrition Assistance Program)
; ═══════════════════════════════════════════════════════════════════════════════

{@snap_application}
= @types.audit_info

application_date = date
state = :(2)
case_number = :

; Household Information
{.household}
household_size = ##:(1..)
{.members[]}
first_name = :
last_name = :
ssn = *:format ssn
date_of_birth = *date
relationship = (applicant, child, other, parent, spouse)
student = ?
disabled = ?
elderly = ?

{@snap_application}
; Address
residence_address = @types.address
mailing_address = @types.address
homeless = ?

; Income
{.income}
{.earned[]}
source = :
monthly_amount = #$:(0..)
frequency = (biweekly, monthly, weekly)
{@snap_application}
{.unearned[]}
source = :
monthly_amount = #$:(0..)
{@snap_application}
total_gross_monthly_income = #$:(0..)
total_net_monthly_income = #$:(0..)

{@snap_application}
; Resources
{.resources}
cash = #$:(0..)
checking_accounts = #$:(0..)
savings_accounts = #$:(0..)
vehicles_value = #$:(0..)
other_resources = #$
total_resources = #$:(0..)

{@snap_application}
; Expenses
{.expenses}
rent_mortgage = #$:(0..)
utilities = #$:(0..)
child_care = #$:(0..)
child_support_paid = #$:(0..)
medical_expenses = #$:(0..)

{@snap_application}
; Eligibility Determination
{.eligibility}
eligible = ?
benefit_amount = #$:(0..)
certification_period_start = date
certification_period_end = date
denial_reason = :

{@snap_application}
; EBT Card
ebt_card_number = *:
issue_date = date

; ═══════════════════════════════════════════════════════════════════════════════
; TANF (Temporary Assistance for Needy Families)
; ═══════════════════════════════════════════════════════════════════════════════

{@tanf_case}
= @types.audit_info

case_number = :
state = :(2)
open_date = date
close_date = date

; Family Composition
{.family_members[]}
first_name = :
last_name = :
ssn = *:format ssn
date_of_birth = *date
relationship = :
minor_child = ?

{@tanf_case}
; Case Head
{.case_head}
first_name = :
last_name = :
ssn = *:format ssn
address = @types.address
phone = *@types.phone

{@tanf_case}
; Income and Resources
{.financial}
gross_monthly_income = #$:(0..)
countable_income = #$:(0..)
resources = #$:(0..)

{@tanf_case}
; Work Requirements
{.work_activity}
participation_required = ?
hours_per_week_required = ##:(0..):if participation_required = true
activity_type = (community_service, job_search, job_training, vocational_education, work_experience)
hours_completed = ##:(0..)
compliant = ?
sanction_applied = ?

{@tanf_case}
; Benefit Information
{.benefit}
monthly_benefit = #$:(0..)
payment_method = (direct_deposit, ebt)
months_received = ##:(0..60)                         ; 60-month lifetime limit
time_limit_months_remaining = ##:(0..60)

{@tanf_case}
; Case Status
status = (active, closed, pending, sanctioned, suspended)
status_date = date
closure_reason = :

; ═══════════════════════════════════════════════════════════════════════════════
; WIC (Women, Infants, and Children)
; ═══════════════════════════════════════════════════════════════════════════════

{@wic_enrollment}
= @types.audit_info

participant_id = :
state = :(2)
enrollment_date = date

; Participant Information
{.participant}
first_name = :
last_name = :
date_of_birth = *date
category = (child, infant, postpartum_woman, pregnant_woman)
pregnant_due_date = date:if category = pregnant_woman

{@wic_enrollment}
; Guardian (if participant is child/infant)
{.guardian}
first_name = :
last_name = :
relationship = :
address = @types.address
phone = *@types.phone

{@wic_enrollment}
; Categorical Eligibility
medicaid_recipient = ?
snap_recipient = ?
tanf_recipient = ?

; Income Eligibility
{.income}
household_size = ##:(1..)
gross_income = #$:(0..)
percent_federal_poverty_level = #:(0..)
income_eligible = ?

{@wic_enrollment}
; Nutrition Risk
{.nutrition_risk}
risk_category = (dietary, medical, medically_based)
risk_description = :
assessed_by = :
assessment_date = date

{@wic_enrollment}
; Benefits
{.benefits}
certification_period_start = date
certification_period_end = date
food_package_type = :
breastfeeding_support = ?

{@wic_enrollment}
; Participation
status = (active, inactive, transferred)
last_clinic_visit = date
next_appointment = date

; ═══════════════════════════════════════════════════════════════════════════════
; SECTION 8 HOUSING CHOICE VOUCHER
; ═══════════════════════════════════════════════════════════════════════════════

{@housing_assistance}
= @types.audit_info

program = (liheap, public_housing, section_8_voucher)
state = :(2)
application_date = date

; Applicant/Participant
{.head_of_household}
first_name = :
last_name = :
ssn = *:format ssn
date_of_birth = *date
address = @types.address
phone = *@types.phone
email = *@types.email

{@housing_assistance}
; Household Composition
{.household_members[]}
first_name = :
last_name = :
date_of_birth = *date
relationship = :
ssn = *:format ssn
disabled = ?

{@housing_assistance}
total_household_size = ##:(1..)

; Income
{.income}
annual_gross_income = #$:(0..)
adjusted_annual_income = #$:(0..)
percent_area_median_income = #:(0..)
extremely_low_income = ?
very_low_income = ?

{@housing_assistance}
; Voucher Information (Section 8)
{.voucher}
voucher_number = :if program = section_8_voucher
voucher_size = ##:(0..):if program = section_8_voucher
payment_standard = #$:(0..):if program = section_8_voucher
utility_allowance = #$:(0..):if program = section_8_voucher
family_share = #$:(0..):if program = section_8_voucher
hap_amount = #$:(0..):if program = section_8_voucher
issue_date = date:if program = section_8_voucher
expiration_date = date:if program = section_8_voucher

{@housing_assistance}
; Unit Information
{.unit}
address = @types.address:if program = section_8_voucher
landlord_name = :
landlord_phone = *@types.phone
rent_amount = #$:(0..)
bedroom_count = ##:(0..)
hqs_inspection_date = date
hqs_passed = ?

{@housing_assistance}
; Status
status = (active, pending, terminated, waiting_list)
status_date = date
termination_reason = :

; ═══════════════════════════════════════════════════════════════════════════════
; LIHEAP (Low Income Home Energy Assistance Program)
; ═══════════════════════════════════════════════════════════════════════════════

{@liheap_assistance}
= @types.audit_info

application_date = date
state = :(2)
program_year = ##:(2020..)

; Applicant
{.applicant}
first_name = :
last_name = :
ssn = *:format ssn
address = @types.address
phone = *@types.phone

{@liheap_assistance}
; Household
household_size = ##:(1..)
annual_income = #$:(0..)
percent_poverty_level = #:(0..)

; Heating/Cooling Need
{.energy}
primary_heating_source = (electric, natural_gas, oil, propane, wood)
utility_company = :
account_number = *:
current_balance = #$
shutoff_notice = ?
service_disconnected = ?

{@liheap_assistance}
; Assistance
{.benefit}
approved = ?
benefit_amount = #$:(0..)
payment_date = date
paid_to = (applicant, utility_company)

{@liheap_assistance}
; Crisis Assistance
crisis_situation = ?
crisis_type = :if crisis_situation = true
crisis_assistance_amount = #$:(0..)

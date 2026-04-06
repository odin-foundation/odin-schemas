; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Government Licensing - Business License Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Business formation, registration, and licensing including articles of
; incorporation/organization, annual reports, DBA registrations, EIN
; applications, and operating licenses. Covers entity types, registered
; agents, and state-level compliance requirements.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.government.licensing.business"
version = "1.0.0"
title = "Business Licensing and Registration"
description = "Business formation, registration, annual reports, and operating permits"

{$derivation}
source[0].authority = "Secretary of State Offices"
source[0].citation = "Business Entity Filing Requirements"
source[0].url = "https://www.nass.org/business-services"
source[0].accessed = 2025-12-21

source[1].authority = "Internal Revenue Service"
source[1].citation = "SS-4 Application for Employer Identification Number"
source[1].url = "https://www.irs.gov/forms-pubs/about-form-ss-4"
source[1].accessed = 2025-12-21

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial business licensing schema"
changelog[0].rationale = "Business formation and registration per state requirements"

; ═══════════════════════════════════════════════════════════════════════════════
; BUSINESS FORMATION (Articles of Incorporation/Organization)
; ═══════════════════════════════════════════════════════════════════════════════

{@business_formation}
= @types.audit_info

entity_type = (c_corporation, llc, nonprofit_corporation, professional_corporation, s_corporation, sole_proprietorship)
state_of_formation = !:(2)
filing_date = date

; Entity Name
entity_name = !:
name_available = ?
name_reservation_number = :

; Principal Office
principal_address = !@types.address

; Registered Agent
{.registered_agent}
name = !:
address = !@types.address
consent_to_appointment = ?

{@business_formation}
; Purpose
business_purpose = !:

; Capital Stock (for corporations)
{.stock}
authorized_shares = ##:(0..):if entity_type != llc
par_value = #$:(0..):if entity_type != llc
class_of_stock = :

{@business_formation}
; LLC Members (if LLC)
{.members[]}
name = !:if entity_type = llc
address = @types.address
ownership_percentage = #:(0..100)

{@business_formation}
; Incorporators/Organizers
{.incorporators[]}
name = !:
address = !@types.address
signature = :
signature_date = date

{@business_formation}
; Directors/Managers
{.initial_directors[]}
name = !:
address = @types.address

{@business_formation}
; Duration
perpetual_duration = ?
dissolution_date = date:if perpetual_duration = false

; Filing Information
filing_number = :
filing_fee = #$:(0..)
expedited_processing = ?

; ═══════════════════════════════════════════════════════════════════════════════
; ANNUAL REPORT
; ═══════════════════════════════════════════════════════════════════════════════

{@annual_report}
= @types.audit_info

report_year = !##:(2020..)
state = !:(2)
filing_date = date
due_date = !date

; Entity Information
entity_name = !:
entity_id = !:
entity_type = (c_corporation, llc, nonprofit_corporation, professional_corporation, s_corporation)
date_of_formation = date
state_of_formation = :(2)

; Principal Office
principal_address = !@types.address
principal_email = *@types.email
principal_phone = *@types.phone

; Registered Agent
{.registered_agent}
name = !:
address = !@types.address

{@annual_report}
; Officers/Directors/Managers
{.officers[]}
name = !:
title = !:
address = @types.address

{@annual_report}
; Business Activity
{.business}
description = :
naics_code = ##:(100000..999999)
number_employees = ##:(0..)

{@annual_report}
; Financial Information (for some states)
{.financial}
total_assets = #$:(0..)
total_liabilities = #$:(0..)
total_revenue = #$:(0..)

{@annual_report}
; Filing Fee
filing_fee = #$:(0..)
late_filing_penalty = #$:(0..)

; Signature
signed_by = :
title = :
signature_date = date

; ═══════════════════════════════════════════════════════════════════════════════
; DBA (DOING BUSINESS AS) REGISTRATION
; ═══════════════════════════════════════════════════════════════════════════════

{@dba_registration}
= @types.audit_info

state = !:(2)
county = :
filing_date = date
expiration_date = date

; Legal Entity Information
{.legal_entity}
legal_name = !:
entity_type = (corporation, individual, llc, partnership)
formation_state = :(2)
entity_id = :

{@dba_registration}
; DBA Name
dba_name = !:
name_available = ?

; Business Address
business_address = !@types.address
business_phone = *@types.phone
business_email = *@types.email

; Owner/Registrant Information
{.owners[]}
name = !:
address = !@types.address
ownership_percentage = #:(0..100)

{@dba_registration}
; Business Activity
business_description = :
naics_code = ##:(100000..999999)
start_date = date

; Filing Information
registration_number = :
filing_fee = #$:(0..)

; Signature
signed_by = :
signature_date = date

; ═══════════════════════════════════════════════════════════════════════════════
; EIN APPLICATION (IRS SS-4)
; ═══════════════════════════════════════════════════════════════════════════════

{@ein_application}
= @types.audit_info

; Entity Information
legal_name = !:
trade_name = :
executor_administrator_trustee_name = :

; Responsible Party
{.responsible_party}
name = !:
ssn_itin_ein = !*:
title = :
address = @types.address

{@ein_application}
; Entity Type
entity_type = (banking_purpose, church_controlled_organization, estate, farmers_cooperative, government, llc, nonprofit_organization, partnership, personal_service_corporation, plan_administrator, remic, sole_proprietor, trust)

; LLC Classification (if LLC)
llc_classification = (c_corporation, partnership, s_corporation):if entity_type = llc
number_llc_members = ##:(1..):if entity_type = llc

; Reason for Applying
{.reason}
started_new_business = ?
hired_employees = ?
created_pension_plan = ?
banking_purpose = ?
changed_type_of_organization = ?
purchased_going_business = ?
created_trust = ?
other_reason = :

{@ein_application}
; Business Start Date
business_start_date = date

; Accounting Period
accounting_year_end = (December, January, February, March, April, May, June, July, August, September, October, November)

; Principal Activity
principal_activity = !:
principal_product_service = !:

; Employees
{.employees}
expect_employment_tax_liability = ?
first_wage_date = date
highest_number_employees = ##:(0..)
agricultural_household_other = :

{@ein_application}
; Application Date
application_date = date

; Signature
applicant_name = :
applicant_title = :
signature_date = date
phone = :

; ═══════════════════════════════════════════════════════════════════════════════
; BUSINESS OPERATING LICENSE
; ═══════════════════════════════════════════════════════════════════════════════

{@business_operating_license}
= @types.audit_info

license_type = !:
state = :(2)
county = :
municipality = :

; Business Information
business_name = !:
dba_name = :
ein = :format ein
business_address = !@types.address
mailing_address = @types.address
phone = *@types.phone
email = *@types.email
website = :

; Owner/Applicant
{.applicant}
name = !:
title = :
ssn = *:format ssn
address = @types.address
phone = *@types.phone
email = *@types.email

{@business_operating_license}
; Business Activity
{.business}
description = !:
naics_code = ##:(100000..999999)
start_date = date
number_employees = ##:(0..)
annual_revenue = #$:(0..)

{@business_operating_license}
; License Information
{.license}
license_number = *:
application_date = date
issue_date = date
effective_date = date
expiration_date = date
renewable = ?

{@business_operating_license}
; Fees
application_fee = #$:(0..)
license_fee = #$:(0..)
renewal_fee = #$:(0..)
late_penalty = #$:(0..)

; Inspection Required
inspection_required = ?
inspection_date = date:if inspection_required = true
inspection_passed = ?:if inspection_required = true

; Status
status = (active, expired, pending, revoked, suspended)
status_date = date
revocation_reason = :

; Signature
signed_by = :
signature_date = date

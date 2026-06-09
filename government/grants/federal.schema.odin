; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Government Grants - Federal Grant Programs Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Federal grant programs including SF-424 applications, grant awards,
; financial reporting (SF-425), subaward management, and closeout procedures.
; Covers budget narratives, cost sharing, and compliance requirements.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.government.grants.federal"
version = "1.0.0"
title = "Federal Grant Programs"
description = "SF-424, awards, reporting (SF-425), subawards, and closeout"

{$derivation}
source[0].authority = "Office of Management and Budget"
source[0].citation = "SF-424 Application for Federal Assistance (OMB 4040-0004)"
source[0].url = "https://www.grants.gov/forms/forms-repository/sf-424-family"
source[0].accessed = 2025-12-21

source[1].authority = "Office of Management and Budget"
source[1].citation = "2 CFR Part 200 - Uniform Administrative Requirements"
source[1].url = "https://www.ecfr.gov/current/title-2/subtitle-A/chapter-II/part-200"
source[1].accessed = 2025-12-21

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial federal grants schema"
changelog[0].rationale = "Federal grant programs per 2 CFR 200 and OMB requirements"

; ═══════════════════════════════════════════════════════════════════════════════
; SF-424 - APPLICATION FOR FEDERAL ASSISTANCE
; ═══════════════════════════════════════════════════════════════════════════════

{@sf424_application}
= @types.audit_info

submission_date = date
type_of_submission = (application, changed_corrected_application, pre_application)
application_identifier = :
federal_entity_identifier = :
federal_award_identifier = :

; Applicant Information
{.applicant}
legal_name = :
employer_tin = :format ein
organizational_duns = :(9)
organizational_uei = :(12)
address = @types.address
organization_type = (
    city_township_government,
    county_government,
    higher_education_institution,
    independent_school_district,
    indian_tribe,
    individual,
    nonprofit,
    other,
    private_higher_education,
    public_higher_education,
    small_business,
    state_government,
    special_district_government
)

{@sf424_application}
; Applicant Contact
{.contact}
prefix = :
first_name = :
middle_name = :
last_name = :
suffix = :
title = :
phone = *@types.phone
fax = *@types.phone
email = *@types.email

{@sf424_application}
; Federal Agency and Program
{.federal_program}
agency_name = :
catalog_of_federal_domestic_assistance_number = :(5)
catalog_of_federal_domestic_assistance_title = :
funding_opportunity_number = :
funding_opportunity_title = :
competition_identification_number = :

{@sf424_application}
; Areas Affected
{.areas_affected}
state = :(2)
county[] = :
city[] = :
other_areas[] = :

{@sf424_application}
; Congressional Districts
applicant_congressional_district = :
program_project_congressional_district = :

; Project Information
{.project}
title = :
description = :
proposed_start_date = date
proposed_end_date = date

{@sf424_application}
; Estimated Funding
{.funding}
federal = #$:(0..)
applicant = #$:(0..)
state = #$:(0..)
local = #$:(0..)
other = #$:(0..)
program_income = #$:(0..)
total = #$:(0..)

{@sf424_application}
; Certifications
{.certifications}
delinquent_on_federal_debt = ?
debt_explanation = :if delinquent_on_federal_debt = true

{@sf424_application}
; Authorized Representative
{.authorized_representative}
prefix = :
first_name = :
middle_name = :
last_name = :
suffix = :
title = :
phone = *@types.phone
fax = *@types.phone
email = *@types.email
signature = :
signature_date = date

{@sf424_application}
; ═══════════════════════════════════════════════════════════════════════════════
; GRANT AWARD
; ═══════════════════════════════════════════════════════════════════════════════

{@grant_award}
= @types.audit_info

federal_award_identifier = :
federal_award_date = date
recipient_uei = :(12)
recipient_name = :
recipient_duns = :(9)

; Awarding Agency
{.awarding_agency}
agency_name = :
agency_code = :
awarding_official_name = :
awarding_official_title = :

{@grant_award}
; Award Information
{.award}
cfda_number = :(5)
cfda_title = :
project_title = :
project_description = :
award_type = (cooperative_agreement, grant)

{@grant_award}
; Period of Performance
period_start = date
period_end = date
budget_period_start = date
budget_period_end = date

; Award Amount
{.financial}
total_federal_funds = #$:(0..)
federal_share = #$:(0..)
non_federal_share = #$:(0..)
total_project_cost = #$:(0..)

{@grant_award}
; Terms and Conditions
{.terms}
uniform_guidance_applies = ?
research_and_development = ?
indirect_cost_rate = #:(0..100)
indirect_cost_base = :

{@grant_award}
; Reporting Requirements
{.reporting}
financial_reports_required = ?
financial_report_frequency = (annual, quarterly, semi_annual)
performance_reports_required = ?
performance_report_frequency = (annual, quarterly, semi_annual)
closeout_report_due = date

{@grant_award}
; ═══════════════════════════════════════════════════════════════════════════════
; SF-425 - FEDERAL FINANCIAL REPORT
; ═══════════════════════════════════════════════════════════════════════════════

{@federal_financial_report}
= @types.audit_info

federal_agency = :
federal_award_number = :
recipient_organization = :
duns_number = :(9)
recipient_uei = :(12)
recipient_account_number = :

; Report Information
{.report}
reporting_period_start = date
reporting_period_end = date
report_type = (annual, final, quarterly, semi_annual)
report_number = :

{@federal_financial_report}
; Basis of Accounting
basis_of_accounting = (accrual, cash)

; Federal Cash
{.federal_cash}
cash_receipts = #$:(0..)
cash_disbursements = #$:(0..)
cash_on_hand = #$:(0..)

{@federal_financial_report}
; Federal Expenditures
{.expenditures}
total_federal_funds_authorized = #$:(0..)
federal_share_of_expenditures = #$:(0..)
federal_share_of_unliquidated_obligations = #$:(0..)
total_federal_share = #$:(0..)
unobligated_balance = #$:(0..)

{@federal_financial_report}
; Recipient Share
{.recipient_share}
total_recipient_share_required = #$:(0..)
recipient_share_of_expenditures = #$:(0..)
remaining_recipient_share = #$:(0..)

{@federal_financial_report}
; Program Income
{.program_income}
earned_during_period = #$:(0..)
expended_during_period = #$:(0..)

{@federal_financial_report}
; Indirect Expense
{.indirect}
type = (current_rate, final_rate, predetermined_rate, provisional_rate)
rate = #:(0..100)
base = #$:(0..)
amount_charged = #$:(0..)
federal_share = #$:(0..)

{@federal_financial_report}
; Remarks
remarks = :

; Certification
{.certification}
certified_by = :
title = :
phone = *@types.phone
email = *@types.email
signature_date = date

{@federal_financial_report}
; ═══════════════════════════════════════════════════════════════════════════════
; SUBAWARD
; ═══════════════════════════════════════════════════════════════════════════════

{@subaward}
= @types.audit_info

prime_recipient_name = :
prime_recipient_uei = :(12)
prime_award_number = :

; Subrecipient
{.subrecipient}
legal_name = :
uei = :(12)
duns = :(9)
address = @types.address
organization_type = :

{@subaward}
; Subaward Information
{.subaward_info}
subaward_number = :
subaward_date = date
subaward_amount = #$:(0..)
project_description = :
period_start = date
period_end = date

{@subaward}
; Reporting Requirements
{.reporting}
financial_reports_required = ?
performance_reports_required = ?
report_frequency = :

{@subaward}
; ═══════════════════════════════════════════════════════════════════════════════
; GRANT CLOSEOUT
; ═══════════════════════════════════════════════════════════════════════════════

{@grant_closeout}
= @types.audit_info

federal_award_number = :
recipient_name = :
recipient_uei = :(12)
project_title = :

; Period of Performance
period_start = date
period_end = date
closeout_date = date

; Final Financial Information
{.final_financial}
total_federal_funds_awarded = #$:(0..)
total_federal_expenditures = #$:(0..)
unliquidated_obligations = #$:(0..)
unobligated_balance = #$:(0..)
recipient_share_required = #$:(0..)
recipient_share_met = #$:(0..)

{@grant_closeout}
; Final Reports Submitted
{.reports}
final_performance_report_submitted = ?
final_performance_report_date = date
final_financial_report_submitted = ?
final_financial_report_date = date
final_invention_report_submitted = ?
final_invention_report_date = date

{@grant_closeout}
; Property Disposition
{.property}
federally_owned_property = ?
equipment_acquired = ?
equipment_disposition = (continue_use, return_to_federal, sell_compensate_federal, transfer_to_federal)

{@grant_closeout}
; Outstanding Issues
{.outstanding}
audit_findings = ?
audit_resolution_pending = ?
debt_owed_to_federal = ?
amount_owed = #$:(0..)

{@grant_closeout}
; Certification
closeout_certified_by = :
title = :
certification_date = date

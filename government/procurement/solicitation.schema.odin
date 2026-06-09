; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Government Procurement - Solicitation and Contract Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Government procurement including RFPs, RFQs, IFBs, bid responses, contract
; awards, and SAM registration. Covers evaluation criteria, set-aside
; programs, contract modifications, performance tracking, and closeout.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.government.procurement.solicitation"
version = "1.0.0"
title = "Government Procurement and Contracting"
description = "RFPs, RFQs, IFBs, bids, contracts, and SAM registration"

{$derivation}
source[0].authority = "General Services Administration"
source[0].citation = "Federal Acquisition Regulation (FAR)"
source[0].url = "https://www.acquisition.gov/browse/index/far"
source[0].accessed = 2025-12-21

source[1].authority = "System for Award Management"
source[1].citation = "SAM.gov Entity Registration Requirements"
source[1].url = "https://sam.gov/"
source[1].accessed = 2025-12-21

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial procurement schema"
changelog[0].rationale = "Government procurement per FAR regulations"

; ═══════════════════════════════════════════════════════════════════════════════
; REQUEST FOR PROPOSAL (RFP)
; ═══════════════════════════════════════════════════════════════════════════════

{@rfp}
= @types.audit_info

solicitation_number = :
solicitation_type = (ifb, rfp, rfq)
issue_date = date
response_due_date = date
response_due_time = time

; Issuing Agency
{.agency}
name = :
contracting_officer = :
address = @types.address
phone = *@types.phone
email = *@types.email

{@rfp}
; Project Description
{.project}
title = :
description = :
scope_of_work = :
period_of_performance_start = date
period_of_performance_end = date
place_of_performance = @types.address

{@rfp}
; Contract Information
{.contract}
naics_code = ##:(100000..999999)
psc_code = :                                         ; Product Service Code
contract_type = (cost_plus, cost_reimbursable, firm_fixed_price, time_and_materials)
estimated_value = #$:(0..)
socioeconomic_set_aside = (
    "8a",
    economically_disadvantaged_women_owned,
    hubzone,
    none,
    sdvosb,
    small_business,
    women_owned
)

{@rfp}
; Evaluation Criteria
{.evaluation}
technical_weight = #:(0..100)
cost_weight = #:(0..100)
past_performance_weight = #:(0..100)
{.factors[]}
factor_name = :
weight = #:(0..100)
description = :

{@rfp}
; Submission Requirements
{.submission}
format = (electronic, paper)
copy_count = ##:(0..)
page_limit = ##:(0..)
submission_portal = :
technical_proposal_required = ?
cost_proposal_required = ?
past_performance_references_required = ?

{@rfp}
; Questions and Amendments
{.questions}
questions_due_date = date
amendment_issued = ?
{.amendments[]}
amendment_number = :
amendment_date = date
description = :

{@rfp}
; ═══════════════════════════════════════════════════════════════════════════════
; BID/PROPOSAL RESPONSE
; ═══════════════════════════════════════════════════════════════════════════════

{@bid_response}
= @types.audit_info

solicitation_number = :
submission_date = date

; Bidder/Offeror Information
{.bidder}
legal_name = :
dba = :
duns_number = :(9)
uei = :(12)
cage_code = :(5)
tax_id = *:format ein
address = @types.address
point_of_contact = :
phone = *@types.phone
email = *@types.email

{@bid_response}
; Small Business Status
{.small_business}
small_business = ?
small_disadvantaged_business = ?
women_owned_small_business = ?
veteran_owned_small_business = ?
service_disabled_veteran_owned = ?
hubzone_small_business = ?
8a_certified = ?

{@bid_response}
; Technical Proposal
{.technical}
approach = :
methodology = :
staffing_plan = :
project_schedule = :
{.key_personnel[]}
name = :
role = :
qualifications = :
resume_attached = ?

{@bid_response}
; Past Performance
{.past_performance[]}
client_name = :
contract_number = :
contract_value = #$:(0..)
period_of_performance_start = date
period_of_performance_end = date
description = :
reference_contact = :
reference_phone = *@types.phone

{@bid_response}
; Cost/Price Proposal
{.cost}
total_proposed_cost = #$:(0..)
{.cost_breakdown[]}
line_item = :
description = :
quantity = ##:(0..)
unit_price = #$:(0..)
total_price = #$:(0..)

{@bid_response}
; Certifications and Representations
{.certifications}
authorized_to_bind = ?
conflict_of_interest = ?
debarred_or_suspended = ?
tax_delinquency = ?

{@bid_response}
; Signature
signed_by = :
title = :
signature_date = date

; ═══════════════════════════════════════════════════════════════════════════════
; CONTRACT AWARD
; ═══════════════════════════════════════════════════════════════════════════════

{@contract_award}
= @types.audit_info

contract_number = :
solicitation_number = :
award_date = date

; Awarding Agency
{.agency}
name = :
contracting_officer = :
address = @types.address
phone = *@types.phone
email = *@types.email

{@contract_award}
; Awardee (Contractor)
{.contractor}
legal_name = :
dba = :
duns_number = :(9)
uei = :(12)
cage_code = :(5)
address = @types.address

{@contract_award}
; Contract Details
{.contract}
title = :
description = :
contract_type = (cost_plus, firm_fixed_price, time_and_materials)
naics_code = ##:(100000..999999)
psc_code = :
socioeconomic_category = :

{@contract_award}
; Period of Performance
period_start = date
period_end = date
base_period_end = date
{.option_periods[]}
option_number = ##:(1..)
start_date = date
end_date = date
value = #$:(0..)

{@contract_award}
; Contract Value
{.financial}
base_period_value = #$:(0..)
total_option_value = #$:(0..)
total_contract_value = #$:(0..)
obligated_amount = #$:(0..)

{@contract_award}
; Place of Performance
place_of_performance = @types.address
principal_place_of_performance_state = :(2)
principal_place_of_performance_country = :(2..3)

; Payment Terms
{.payment}
payment_method = (ach, eft, wire)
payment_terms = :
invoice_submission = :

{@contract_award}
; Reporting Requirements
{.reporting}
monthly_reports_required = ?
quarterly_reports_required = ?
annual_reports_required = ?
final_report_required = ?

{@contract_award}
; Signature
contracting_officer = :
signature_date = date

; ═══════════════════════════════════════════════════════════════════════════════
; SAM (SYSTEM FOR AWARD MANAGEMENT) REGISTRATION
; ═══════════════════════════════════════════════════════════════════════════════

{@sam_registration}
= @types.audit_info

uei = :(12)
registration_date = date
expiration_date = date
activation_date = date

; Entity Information
{.entity}
legal_business_name = :
dba_name = :
physical_address = @types.address
mailing_address = @types.address
business_start_date = date
fiscal_year_end_date = date

{@sam_registration}
; Entity Structure
{.structure}
entity_type = (
    business,
    government,
    higher_education,
    nonprofit,
    other,
    sole_proprietor
)
corporate_structure = (
    corporate_entity_not_tax_exempt,
    corporate_entity_tax_exempt,
    llc,
    partnership,
    sole_proprietorship
)
incorporation_state = :(2)
incorporation_country = :(2..3)

{@sam_registration}
; Identifiers
{.identifiers}
duns_number = :(9)
cage_code = :(5)
ncage_code = :(5)
tin = *:format ein
tin_type = (ein, ssn)

{@sam_registration}
; Points of Contact
{.primary_poc}
first_name = :
last_name = :
title = :
address = @types.address
phone = *@types.phone
email = *@types.email

{@sam_registration}
{.alternate_poc}
first_name = :
last_name = :
title = :
phone = *@types.phone
email = *@types.email

{@sam_registration}
; Business Classifications
{.classifications}
small_business = ?
small_disadvantaged_business = ?
women_owned_small_business = ?
economically_disadvantaged_wosb = ?
veteran_owned_small_business = ?
service_disabled_veteran_owned = ?
hubzone_small_business = ?
8a_program_participant = ?
minority_owned_business = ?

{@sam_registration}
; NAICS Codes
{.naics_codes[]}
naics_code = ##:(100000..999999)
small_business_indicator = ?
exception_to_size_standard = ?

{@sam_registration}
; Financial Information
{.financial}
credit_card_usage = ?
{.eft_information}
account_type = (checking, savings)
routing_number = *:(9)
account_number = *:
remittance_address = @types.address

{@sam_registration}
; Representations and Certifications
{.certifications}
debarred_suspended = ?
federal_tax_delinquent = ?
unpaid_federal_tax_assessment = ?
felony_conviction = ?
tax_exempt_status = ?

{@sam_registration}
; Registration Status
status = (active, expired, inactive)
last_updated = date

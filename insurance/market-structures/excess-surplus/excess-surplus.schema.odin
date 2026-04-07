; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Excess & Surplus Lines (E&S) Insurance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Excess and surplus (E&S) lines insurance for risks that standard admitted
; markets cannot accommodate, covering surplus lines broker licensing, state
; stamping fees, diligent search requirements, and non-admitted carrier details.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/carrier.schema.odin" as carrier
@import "../../common/agency.schema.odin" as agency
@import "../../common/types.schema.odin" as types
@import "../../commercial/business.schema.odin" as entity

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.market-structures.excess-surplus"
version = "1.0.0"
title = "Excess & Surplus Lines Insurance Schema"
description = "Regulatory overlay for non-admitted insurance market placements"

{$derivation}
source[0].authority = "U.S. Congress"
source[0].citation = "Nonadmitted and Reinsurance Reform Act of 2010 (Dodd-Frank Act, Title V, Subtitle B, Sections 521-527)"
source[0].url = "https://www.congress.gov/111/plaws/publ203/PLAW-111publ203.pdf"

source[1].authority = "National Association of Insurance Commissioners"
source[1].citation = "Nonadmitted Insurance Model Act (#870)"
source[1].url = "https://content.naic.org/insurance-topics/surplus-lines"

source[2].authority = "National Association of Insurance Commissioners"
source[2].citation = "Quarterly Listing of Alien Insurers"
source[2].url = "https://content.naic.org/sites/default/files/publication-qls-as-quarterly-alien-insurers-january-2025.pdf"

source[3].authority = "Wholesale & Specialty Insurance Association"
source[3].citation = "Surplus Lines Manual and Reference Guide"
source[3].url = "https://web.archive.org/web/2024/https://www.wsia.org/wcm/About/What_is_Surplus_Lines.aspx"

source[4].authority = "Surplus Lines Stamping Office of Texas"
source[4].citation = "Filing Requirements and Tax Guidelines"
source[4].url = "https://www.sltx.org/"

source[5].authority = "Florida Surplus Lines Service Office"
source[5].citation = "Filing Requirements and Compliance Guidelines"
source[5].url = "https://www.fslso.com/filing/filing-requirements"

source[6].authority = "California Department of Insurance"
source[6].citation = "Surplus Line Brokers and Special Lines Filing Instructions"
source[6].url = "https://www.insurance.ca.gov/01-consumers/120-company/07-lasli/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "E&S schema derived from NRRA, NAIC model laws, and state surplus lines regulations"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial E&S market structure schema"
changelog[0].rationale = "Regulatory overlay for non-admitted market placements per NRRA and state laws"

; ═══════════════════════════════════════════════════════════════════════════════
; Non-Admitted Insurer (Surplus Lines Carrier)
; ═══════════════════════════════════════════════════════════════════════════════
; Insurers not licensed/admitted in the state where risk is located. May be:
; - U.S. domiciled surplus lines insurers
; - Lloyd's of London syndicates
; - Non-U.S. (alien) insurers on NAIC Quarterly Listing

{@es_non_admitted_insurer}
insurer_id = :

; ───────────────────────────────────────────────────────────────────────────────
; Identification
; ───────────────────────────────────────────────────────────────────────────────
name = !:
legal_name = :
naic_code = :(5..6)
naic_alien_id = :                          ; Alien identification number for non-US insurers
am_best_number = :
fein = *:(9..11)

; ───────────────────────────────────────────────────────────────────────────────
; Insurer Classification
; ───────────────────────────────────────────────────────────────────────────────
insurer_type = (
    alien_insurer,                               ; Non-US insurer on NAIC Quarterly Listing
    domestic_surplus_lines,                      ; US domiciled surplus lines insurer
    lloyds_syndicate                             ; Lloyd's of London syndicate
)

; Lloyd's syndicate specific
lloyds_syndicate_number = ::if insurer_type = lloyds_syndicate
lloyds_managing_agent = ::if insurer_type = lloyds_syndicate

; ───────────────────────────────────────────────────────────────────────────────
; Domicile
; ───────────────────────────────────────────────────────────────────────────────
domicile_state_province = :(2):if insurer_type = domestic_surplus_lines
domicile_country = :(2..3)                       ; ISO 3166 country code
domicile_country_name = :

; ───────────────────────────────────────────────────────────────────────────────
; Eligibility Status
; ───────────────────────────────────────────────────────────────────────────────
; Per NRRA Section 524, eligible surplus lines insurers must meet federal criteria
eligibility_status = (
    eligible,                                    ; Listed/approved to write surplus lines
    export_list,                                 ; On state export list (no diligent search required)
    ineligible,                                  ; Not eligible to write surplus lines
    suspended                                    ; Temporarily suspended
)

; NAIC Quarterly Listing status (for alien insurers)
naic_quarterly_listing = ?:if insurer_type = alien_insurer
naic_listing_date = date:if naic_quarterly_listing = true
naic_listing_expiration = date:if naic_quarterly_listing = true

; Trust fund requirements (alien insurers and Lloyd's)
{.trust_fund}
maintained = ?:if insurer_type = alien_surplus_lines
maintained = ?:if insurer_type = lloyds_syndicate
amount = #$:(0..):if trust_fund.maintained = true
location = ::if trust_fund.maintained = true

{@es_non_admitted_insurer}

; ───────────────────────────────────────────────────────────────────────────────
; Financial Ratings
; ───────────────────────────────────────────────────────────────────────────────
am_best_rating = :
am_best_financial_size = :
sp_rating = :
moodys_rating = :
fitch_rating = :

; ───────────────────────────────────────────────────────────────────────────────
; Surplus/Capital Requirements
; ───────────────────────────────────────────────────────────────────────────────
; Per NRRA Section 524, minimum capital/surplus requirements
policyholder_surplus = #$:(0..)
capital_stock = #$:(0..)

; ───────────────────────────────────────────────────────────────────────────────
; State Eligibility
; ───────────────────────────────────────────────────────────────────────────────
{.state_eligibility[]}
state_province = :(2)
country = :(2..3) "US"
eligible = ?
effective_date = date
expiration_date = date
filing_number = :

{@es_non_admitted_insurer}

; ───────────────────────────────────────────────────────────────────────────────
; Contact Information
; ───────────────────────────────────────────────────────────────────────────────
address = @address

{.phone}
main = *@phone
claims = *@phone
underwriting = *@phone

{@es_non_admitted_insurer}
website = :

; ═══════════════════════════════════════════════════════════════════════════════
; Surplus Lines Broker
; ═══════════════════════════════════════════════════════════════════════════════
; Licensed intermediary authorized to place insurance with non-admitted insurers.
; Per NRRA, only the home state can require broker licensing for that transaction.

{@es_surplus_lines_broker}
broker_id = :

; ───────────────────────────────────────────────────────────────────────────────
; Entity Information
; ───────────────────────────────────────────────────────────────────────────────
entity_type = (corporation, individual, llc, partnership)

; Individual broker
{.individual}
name_prefix = ::if entity_type = individual
name_first = !::if entity_type = individual
name_middle = ::if entity_type = individual
name_last = !::if entity_type = individual
name_suffix = ::if entity_type = individual

{@es_surplus_lines_broker}

; Business entity
business_name = !::if entity_type != individual
dba_name = :

; ───────────────────────────────────────────────────────────────────────────────
; Licensing
; ───────────────────────────────────────────────────────────────────────────────
; Surplus lines broker must be licensed in the insured's home state
npn = :                                    ; National Producer Number
fein = *:(9..11)

{.home_state_license}
state_province = :(2)
country = :(2..3) "US"
license_number = *:
license_type = (non_resident, resident)
effective_date = date
expiration_date = date
status = (active, expired, revoked, suspended)

{@es_surplus_lines_broker}

; Additional state licenses
{.additional_licenses[]}
state_province = :(2)
country = :(2..3) "US"
license_number = *:
license_type = (non_resident, resident)
effective_date = date
expiration_date = date
status = (active, expired, revoked, suspended)

{@es_surplus_lines_broker}

; ───────────────────────────────────────────────────────────────────────────────
; Contact Information
; ───────────────────────────────────────────────────────────────────────────────
address = @address

{.phone}
main = *@phone
cell = *@phone
fax = *@phone

{@es_surplus_lines_broker}
email = *@email
website = :

; ───────────────────────────────────────────────────────────────────────────────
; E&O Insurance (Errors and Omissions)
; ───────────────────────────────────────────────────────────────────────────────
{.eo_coverage}
carrier = :
policy_number = :
effective_date = date
expiration_date = date
limit_per_occurrence = #$:(0..)
aggregate_limit = #$:(0..)

{@es_surplus_lines_broker}

; ───────────────────────────────────────────────────────────────────────────────
; Bond (if required by state)
; ───────────────────────────────────────────────────────────────────────────────
{.surety_bond}
required = ?
surety_company = ::if surety_bond.required = true
bond_number = ::if surety_bond.required = true
bond_amount = #$:(0..):if surety_bond.required = true
effective_date = date:if surety_bond.required = true
expiration_date = date:if surety_bond.required = true

{@es_surplus_lines_broker}

; ═══════════════════════════════════════════════════════════════════════════════
; Admitted Market Declination
; ═══════════════════════════════════════════════════════════════════════════════
; Individual declination record from an admitted insurer

{@es_declination}
declination_id = :
sequence = ##:(1..)

; ───────────────────────────────────────────────────────────────────────────────
; Admitted Insurer Information
; ───────────────────────────────────────────────────────────────────────────────
carrier_ref = :                                  ; Reference to carrier.schema.odin
admitted_state = :(2)                            ; State where insurer is admitted

; ───────────────────────────────────────────────────────────────────────────────
; Declination Details
; ───────────────────────────────────────────────────────────────────────────────
declination_date = date
declination_method = (
    email,
    electronic,
    in_person,
    letter,
    phone,
    portal
)

declination_reason = (
    cannot_write_class,                          ; Cannot write this class of business
    capacity_exhausted,                          ; No capacity for this risk
    claims_history,                              ; Adverse loss history
    coverage_not_offered,                        ; Coverage type not offered
    geographic_restriction,                      ; Territory not written
    insufficient_info,                           ; Unable to quote without additional info
    limit_unavailable,                           ; Cannot provide requested limits
    moratorium,                                  ; Temporary writing moratorium
    other,                                       ; Other reason
    premium_volume_restriction,                  ; Premium falls outside guidelines
    risk_characteristics,                        ; Risk doesn't meet underwriting guidelines
    terms_unacceptable                           ; Insured rejected available terms
)

declination_reason_detail = :

; ───────────────────────────────────────────────────────────────────────────────
; Contact Who Provided Declination
; ───────────────────────────────────────────────────────────────────────────────
contact_ref = :                               ; Contact reference

{@es_declination}

; ───────────────────────────────────────────────────────────────────────────────
; Quote Information (if partial quote provided)
; ───────────────────────────────────────────────────────────────────────────────
quote_provided = ?
quoted_premium = #$:(0..):if quote_provided = true
quoted_coverage_description = ::if quote_provided = true
reason_quote_rejected = ::if quote_provided = true

; ───────────────────────────────────────────────────────────────────────────────
; Documentation
; ───────────────────────────────────────────────────────────────────────────────
written_confirmation = ?
confirmation_document_ref = ::if written_confirmation = true

; ═══════════════════════════════════════════════════════════════════════════════
; Diligent Search Documentation
; ═══════════════════════════════════════════════════════════════════════════════
; Documents the search of the admitted market before surplus lines placement.
; Requirements vary by state. See state-specific declination requirements.

{@es_diligent_search}
search_id = :

; ───────────────────────────────────────────────────────────────────────────────
; Search Parameters
; ───────────────────────────────────────────────────────────────────────────────
search_date = date
home_state = :(2)                                ; State where diligent search applies
home_state_country = :(2..3) "US"

; Coverage being placed
coverage_description = :
coverage_type = :
requested_limit = #$:(0..)
requested_deductible = #$:(0..)

; ───────────────────────────────────────────────────────────────────────────────
; Search Exemptions
; ───────────────────────────────────────────────────────────────────────────────
; Certain placements may be exempt from diligent search requirements
search_exempt = ?

exemption_type = (
    ecp,                                         ; Exempt Commercial Purchaser per NRRA
    export_list,                                 ; Coverage on state export list
    industrial_insured,                          ; Industrial insured exemption
    none,                                        ; No exemption - search required
    ocean_marine,                                ; Ocean marine exemption
    state_specific                               ; Other state-specific exemption
):if search_exempt = true

exemption_documentation = ::if search_exempt = true

; ───────────────────────────────────────────────────────────────────────────────
; Exempt Commercial Purchaser (ECP) Criteria
; ───────────────────────────────────────────────────────────────────────────────
; Per NRRA Section 527, ECP must meet all of the following:
{.ecp_qualification}
qualifies = ?:if exemption_type = ecp

; Net worth of at least $20 million (or $50 million if in manufacturer/retailer list)
net_worth = #$:(0..):if ecp_qualification.qualifies = true
net_worth_threshold_met = ?:if ecp_qualification.qualifies = true

; Generates annual gross revenue of at least $50 million
gross_revenue = #$:(0..):if ecp_qualification.qualifies = true
gross_revenue_threshold_met = ?:if ecp_qualification.qualifies = true

; Employs or retains qualified risk manager
risk_manager = ?:if ecp_qualification.qualifies = true

; Pays annual insurance premiums of at least $100,000
total_annual_premiums = #$:(0..):if ecp_qualification.qualifies = true
premium_threshold_met = ?:if ecp_qualification.qualifies = true

; Written ECP disclosure provided
disclosure_provided = ?:if ecp_qualification.qualifies = true
disclosure_date = date:if disclosure_provided = true

; Written request to procure from non-admitted
written_request_received = ?:if ecp_qualification.qualifies = true
request_date = date:if written_request_received = true

{@es_diligent_search}

; ───────────────────────────────────────────────────────────────────────────────
; State-Specific Requirements
; ───────────────────────────────────────────────────────────────────────────────
declinations_required = ##:(0..10)               ; Number required by state
declinations_obtained = ##:(0..10)
meets_state_requirements = ?

; ───────────────────────────────────────────────────────────────────────────────
; Declination Records
; ───────────────────────────────────────────────────────────────────────────────
declinations[] = @es_declination

; ───────────────────────────────────────────────────────────────────────────────
; Search Conducted By
; ───────────────────────────────────────────────────────────────────────────────
search_conducted_by = (
    producing_agent,                             ; Retail agent conducted search
    surplus_lines_broker                         ; Surplus lines broker conducted search
)

producing_agent_name = ::if search_conducted_by = producing_agent
producing_agent_license = ::if search_conducted_by = producing_agent
surplus_lines_broker_ref = @es_surplus_lines_broker:if search_conducted_by = surplus_lines_broker

; ───────────────────────────────────────────────────────────────────────────────
; Certification
; ───────────────────────────────────────────────────────────────────────────────
certified = ?
certification_date = date:if certified = true
certifier_name = ::if certified = true
certifier_title = ::if certified = true

; ═══════════════════════════════════════════════════════════════════════════════
; Home State Determination
; ═══════════════════════════════════════════════════════════════════════════════
; Per NRRA Section 527, determines which state's laws apply and receives tax

{@es_home_state_determination}
determination_id = :

; ───────────────────────────────────────────────────────────────────────────────
; Insured Information
; ───────────────────────────────────────────────────────────────────────────────
insured_type = (
    affiliated_group,                            ; Multiple affiliated insureds
    individual,                                  ; Natural person
    organization,                                ; Business entity
    unaffiliated_group                           ; Multiple unaffiliated insureds
)

; ───────────────────────────────────────────────────────────────────────────────
; Home State Determination Basis
; ───────────────────────────────────────────────────────────────────────────────
; Per NRRA: home state = principal place of business (organization) or
; principal residence (individual), OR if 100% of risk is outside that state,
; the state with greatest percentage of premium allocation

determination_basis = (
    largest_premium_allocation,                  ; 100% of risk outside principal location
    principal_place_of_business,                 ; Organization's headquarters
    principal_residence                          ; Individual's primary residence
)

; Principal Location
principal_location_state = :(2)              ; Principal location state
principal_location_country = :(2..3) "US"    ; Principal location country
principal_location_address = @address        ; Principal location address

; ───────────────────────────────────────────────────────────────────────────────
; Affiliated Group Determination
; ───────────────────────────────────────────────────────────────────────────────
; If multiple affiliated insureds, home state = home state of member with
; largest percentage of premium attributable to it

{.affiliated_group}
applicable = ?:if insured_type = affiliated_group
controlling_member_name = ::if affiliated_group.applicable = true
controlling_member_state = :(2):if affiliated_group.applicable = true
controlling_member_premium_percentage = #:(0..100):if affiliated_group.applicable = true

{@es_home_state_determination}

; ───────────────────────────────────────────────────────────────────────────────
; Risk Location Analysis
; ───────────────────────────────────────────────────────────────────────────────
all_risk_outside_principal = ?                   ; Is 100% of risk outside principal location?

{.risk_allocation[]}
state_province = :(2)
country = :(2..3) "US"
percentage_of_risk = #:(0..100)
premium_allocated = #$:(0..)

{@es_home_state_determination}

; ───────────────────────────────────────────────────────────────────────────────
; Determined Home State
; ───────────────────────────────────────────────────────────────────────────────
home_state = :(2)
home_state_country = :(2..3) "US"
determination_date = date
determination_notes = :

; ═══════════════════════════════════════════════════════════════════════════════
; Surplus Lines Tax Calculation
; ═══════════════════════════════════════════════════════════════════════════════
; Per NRRA, only the home state may tax surplus lines transactions

{@es_surplus_lines_tax}
tax_id = *:

; ───────────────────────────────────────────────────────────────────────────────
; Taxing Jurisdiction
; ───────────────────────────────────────────────────────────────────────────────
home_state = :(2)
home_state_country = :(2..3) "US"

; ───────────────────────────────────────────────────────────────────────────────
; Premium Base
; ───────────────────────────────────────────────────────────────────────────────
gross_premium = #$:(0..)
policy_fees = #$:(0..)
inspection_fees = #$:(0..)
other_fees = #$:(0..)
taxable_premium = #$:(0..)                       ; Gross premium plus applicable fees

; Return premium (for endorsements/cancellations)
return_premium = #$:(0..)
net_taxable_premium = #$:(0..)

; ───────────────────────────────────────────────────────────────────────────────
; State Tax Rate
; ───────────────────────────────────────────────────────────────────────────────
; Tax rates vary by state (2% to 5%)
state_tax_rate = #:(0..10)
state_tax_amount = #$:(0..)

; ───────────────────────────────────────────────────────────────────────────────
; Additional State Fees/Assessments
; ───────────────────────────────────────────────────────────────────────────────
{.additional_fees[]}
fee_type = (
    fire_marshal,                                ; Fire marshal tax/fee
    regulatory_assessment,                       ; State regulatory assessment
    slas_clearinghouse,                          ; SLAS clearinghouse fee
    stamping_fee,                                ; Stamping office fee
    surcharge,                                   ; State surcharge
    other                                        ; Other fee
)
fee_description = :
fee_rate = #:(0..5)
fee_amount = #$:(0..)

{@es_surplus_lines_tax}

; ───────────────────────────────────────────────────────────────────────────────
; Total Tax Due
; ───────────────────────────────────────────────────────────────────────────────
total_additional_fees = #$:(0..)
total_tax_due = #$:(0..)

; ───────────────────────────────────────────────────────────────────────────────
; Tax Exemption (if applicable)
; ───────────────────────────────────────────────────────────────────────────────
tax_exempt = ?
exemption_type = (
    governmental_entity,                         ; State/county/municipal entity
    nonprofit_charitable,                        ; Qualified nonprofit
    other                                        ; Other exemption
):if tax_exempt = true
exemption_documentation = ::if tax_exempt = true

; ───────────────────────────────────────────────────────────────────────────────
; Payment Information
; ───────────────────────────────────────────────────────────────────────────────
due_date = date
payment_date = date
payment_reference = :
paid = ?

; ═══════════════════════════════════════════════════════════════════════════════
; Stamping Office Filing
; ═══════════════════════════════════════════════════════════════════════════════
; Many states require surplus lines transactions be filed with a stamping office

{@es_stamping_office_filing}
filing_id = :

; ───────────────────────────────────────────────────────────────────────────────
; Stamping Office
; ───────────────────────────────────────────────────────────────────────────────
stamping_office = (
    fslso,                                       ; Florida Surplus Lines Service Office
    ncsla,                                       ; North Carolina Surplus Lines Association
    pasla,                                       ; Pennsylvania Surplus Lines Association
    slacal,                                      ; Surplus Line Association of California
    slai,                                        ; Surplus Line Association of Illinois
    sltx,                                        ; Surplus Lines Stamping Office of Texas
    other                                        ; Other stamping office
)
stamping_office_name = ::if stamping_office = other
state = :(2)

; ───────────────────────────────────────────────────────────────────────────────
; Filing Information
; ───────────────────────────────────────────────────────────────────────────────
filing_type = (
    cancellation,
    endorsement,
    new_business,
    reinstatement,
    renewal
)

filing_method = (
    batch_csv,                                   ; CSV batch upload
    batch_xml,                                   ; XML batch upload
    electronic_portal,                           ; Online portal (SLIP, EFS, etc.)
    manual                                       ; Paper/manual submission
)

filing_date = date
filing_deadline = date

; ───────────────────────────────────────────────────────────────────────────────
; Filing Documents
; ───────────────────────────────────────────────────────────────────────────────
; California SL-1 and SL-2 forms or state equivalent
{.documents}
confidential_report = ?                          ; SL-1 or equivalent
diligent_search_report = ?                       ; SL-2 or equivalent
declarations_page = ?
policy_form = ?
endorsements = ?

{@es_stamping_office_filing}

; ───────────────────────────────────────────────────────────────────────────────
; Stamping Office Response
; ───────────────────────────────────────────────────────────────────────────────
{.response}
received_date = date
status = (
    accepted,
    pending_review,
    rejected,
    returned_for_correction
)
rejection_reason = ::if response.status = rejected
correction_required = ::if response.status = returned_for_correction
stamp_number = ::if response.status = accepted
stamped_date = date:if response.status = accepted

{@es_stamping_office_filing}

; ───────────────────────────────────────────────────────────────────────────────
; Stamping Fee
; ───────────────────────────────────────────────────────────────────────────────
stamping_fee_rate = #:(0..1)                     ; Range: 0.04% to 0.15%
stamping_fee_amount = #$:(0..)
stamping_fee_paid = ?

; ═══════════════════════════════════════════════════════════════════════════════
; Policyholder Disclosure
; ═══════════════════════════════════════════════════════════════════════════════
; Required disclosures about non-admitted insurance

{@es_policyholder_disclosure}
disclosure_id = :

; ───────────────────────────────────────────────────────────────────────────────
; Disclosure Requirements
; ───────────────────────────────────────────────────────────────────────────────
; Non-admitted insurance disclosures required by state law

{.required_disclosures}
; The insurer is not admitted/licensed in the state
non_admitted_status = ?
non_admitted_disclosed = ?:if non_admitted_status = true
non_admitted_disclosure_date = date:if non_admitted_disclosed = true

; State guaranty fund does not cover this policy
no_guaranty_fund = ?
no_guaranty_fund_disclosed = ?:if no_guaranty_fund = true
no_guaranty_fund_disclosure_date = date:if no_guaranty_fund_disclosed = true

; Premium tax is the responsibility of the insured (if applicable)
tax_responsibility = ?
tax_responsibility_disclosed = ?:if tax_responsibility = true
tax_responsibility_disclosure_date = date:if tax_responsibility_disclosed = true

; Rate/form not approved by state insurance department
unregulated_rates_forms = ?
unregulated_rates_forms_disclosed = ?:if unregulated_rates_forms = true
unregulated_rates_forms_disclosure_date = date:if unregulated_rates_forms_disclosed = true

{@es_policyholder_disclosure}

; ───────────────────────────────────────────────────────────────────────────────
; ECP Disclosure (if applicable)
; ───────────────────────────────────────────────────────────────────────────────
; Exempt Commercial Purchaser must be informed coverage may be available
; from the admitted market
{.ecp_disclosure}
applicable = ?
coverage_may_be_available_admitted = ?:if ecp_disclosure.applicable = true
disclosure_date = date:if ecp_disclosure.applicable = true
written_request_received = ?:if ecp_disclosure.applicable = true
request_date = date:if written_request_received = true

{@es_policyholder_disclosure}

; ───────────────────────────────────────────────────────────────────────────────
; Insured Acknowledgment
; ───────────────────────────────────────────────────────────────────────────────
all_disclosures_provided = ?
insured_acknowledged = ?
acknowledgment_date = date:if insured_acknowledged = true
acknowledgment_method = (
    electronic_signature,
    email_confirmation,
    verbal_recorded,
    written_signature
):if insured_acknowledged = true
acknowledgment_document_ref = ::if insured_acknowledged = true

; ═══════════════════════════════════════════════════════════════════════════════
; E&S Policy Wrapper
; ═══════════════════════════════════════════════════════════════════════════════
; Wraps underlying coverage schemas with E&S regulatory overlay.
; The underlying coverage (property, liability, professional, etc.) is
; referenced separately - this schema captures the E&S-specific components.

{@es_policy_wrapper}
es_policy_id = :
transaction_id = :

; ───────────────────────────────────────────────────────────────────────────────
; Policy Reference
; ───────────────────────────────────────────────────────────────────────────────
; Reference to the underlying coverage policy
policy_number = !:
effective_date = date
expiration_date = date
:invariant expiration_date > effective_date

; ───────────────────────────────────────────────────────────────────────────────
; Underlying Coverage Type
; ───────────────────────────────────────────────────────────────────────────────
; Indicates what type of coverage is being placed in the E&S market
underlying_coverage_type = (
    aviation,                                    ; Aircraft/aviation
    commercial_auto,                             ; Commercial auto
    commercial_property,                         ; Commercial property
    cyber_liability,                             ; Cyber/technology
    directors_officers,                          ; D&O liability
    employment_practices,                        ; EPLI
    environmental,                               ; Pollution/environmental
    excess_umbrella,                             ; Excess/umbrella liability
    general_liability,                           ; CGL
    inland_marine,                               ; Inland marine
    miscellaneous,                               ; Misc/other
    ocean_marine,                                ; Ocean marine
    package,                                     ; Package/multi-line
    product_liability,                           ; Product liability
    professional_liability,                      ; E&O/professional
    residential_property,                        ; Homeowners/dwelling
    special_events,                              ; Special event
    surety,                                      ; Surety bonds
    workers_compensation                         ; WC (in states that allow)
)

underlying_coverage_description = :

; Reference to underlying coverage schema instance (external reference)
underlying_coverage_ref = :

; ───────────────────────────────────────────────────────────────────────────────
; Insured Information
; ───────────────────────────────────────────────────────────────────────────────
named_insured = !:
named_insured_entity = @entity.business

; Additional named insureds
additional_named_insureds[] = :

; ───────────────────────────────────────────────────────────────────────────────
; E&S Regulatory Components
; ───────────────────────────────────────────────────────────────────────────────
non_admitted_insurer = @es_non_admitted_insurer
surplus_lines_broker = @es_surplus_lines_broker
home_state_determination = @es_home_state_determination
diligent_search = @es_diligent_search
policyholder_disclosure = @es_policyholder_disclosure

; ───────────────────────────────────────────────────────────────────────────────
; Tax and Filing
; ───────────────────────────────────────────────────────────────────────────────
surplus_lines_tax = @es_surplus_lines_tax
stamping_office_filing = @es_stamping_office_filing

; ───────────────────────────────────────────────────────────────────────────────
; Premium Information
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
policy_premium = #$:(0..)
policy_fees = #$:(0..)
inspection_fees = #$:(0..)
surplus_lines_tax = #$:(0..)
stamping_fee = #$:(0..)
other_fees = #$:(0..)
total_cost = #$:(0..)

{@es_policy_wrapper}

; ───────────────────────────────────────────────────────────────────────────────
; Policy Form
; ───────────────────────────────────────────────────────────────────────────────
; E&S policies may use manuscript (custom) forms
policy_form_type = (
    admitted_form_modified,                      ; Admitted form with modifications
    bureau_form,                                 ; ISO/bureau form
    carrier_proprietary,                         ; Carrier's own form
    hybrid,                                      ; Mix of standard and custom
    manuscript                                   ; Fully custom manuscript
)
policy_form_number = :
policy_form_edition = date

; ───────────────────────────────────────────────────────────────────────────────
; Transaction Type
; ───────────────────────────────────────────────────────────────────────────────
transaction_type = (
    cancellation,
    endorsement,
    new_business,
    reinstatement,
    renewal
)

; For endorsements
endorsement_number = ::if transaction_type = endorsement
endorsement_effective_date = date:if transaction_type = endorsement
endorsement_description = ::if transaction_type = endorsement
premium_change = #$:if transaction_type = endorsement

; For cancellations
cancellation_effective_date = date:if transaction_type = cancellation
cancellation_reason = (
    flat_cancel,
    insured_request,
    material_change_risk,
    non_payment,
    other,
    underwriter_request
):if transaction_type = cancellation
return_premium = #$:(0..):if transaction_type = cancellation

; ───────────────────────────────────────────────────────────────────────────────
; Compliance Status
; ───────────────────────────────────────────────────────────────────────────────
{.compliance}
diligent_search_complete = ?
all_disclosures_provided = ?
tax_filed = ?
stamping_office_filed = ?
fully_compliant = ?

{@es_policy_wrapper}

; ───────────────────────────────────────────────────────────────────────────────
; Key Dates
; ───────────────────────────────────────────────────────────────────────────────
{.dates}
quote_date = date
bound_date = date
policy_issued_date = date
tax_due_date = date
filing_deadline = date

{@es_policy_wrapper}

; ───────────────────────────────────────────────────────────────────────────────
; Producing Agent (Retail Agent)
; ───────────────────────────────────────────────────────────────────────────────
; The retail agent who brought the risk to the surplus lines broker
{.producing_agent}
name = :
agency_name = :
license_number = *:
license_state = :(2)
phone = *@phone
email = *@email
commission = #:(0..100)

{@es_policy_wrapper}

; ═══════════════════════════════════════════════════════════════════════════════
; State Export List Entry
; ═══════════════════════════════════════════════════════════════════════════════
; Coverages on a state's export list can be placed without diligent search

{@es_export_list_entry}
entry_id = :

; ───────────────────────────────────────────────────────────────────────────────
; State Information
; ───────────────────────────────────────────────────────────────────────────────
state = :(2)
state_name = :

; ───────────────────────────────────────────────────────────────────────────────
; Export List Coverage
; ───────────────────────────────────────────────────────────────────────────────
coverage_code = :
coverage_description = :
coverage_category = (
    aviation,
    environmental,
    excess_surplus,
    general_liability,
    marine,
    miscellaneous,
    product_liability,
    professional_liability,
    property,
    special_events
)

; ───────────────────────────────────────────────────────────────────────────────
; Effective Period
; ───────────────────────────────────────────────────────────────────────────────
effective_date = date
expiration_date = date
permanent = ?                                    ; No expiration

; ───────────────────────────────────────────────────────────────────────────────
; Conditions/Restrictions
; ───────────────────────────────────────────────────────────────────────────────
conditions = :
minimum_limit = #$:(0..)
maximum_limit = #$:(0..)

; ═══════════════════════════════════════════════════════════════════════════════
; State Surplus Lines Tax Reference
; ═══════════════════════════════════════════════════════════════════════════════
; Reference data for state tax rates (as of schema creation date)

{@es_state_tax_reference}
state = :(2)
state_name = :
country = :(2..3) "US"

; ───────────────────────────────────────────────────────────────────────────────
; Tax Information
; ───────────────────────────────────────────────────────────────────────────────
premium_tax_rate = #:(0..10)                     ; Percentage (e.g., 4.85 for TX, 3.0 for CA)
effective_date = date

; Fire Marshal / Additional Taxes
fire_marshal_tax_rate = #:(0..5)
fire_marshal_tax_applies = ?

; ───────────────────────────────────────────────────────────────────────────────
; Stamping Office
; ───────────────────────────────────────────────────────────────────────────────
stamping_office = ?
stamping_office_name = ::if stamping_office = true
stamping_fee_rate = #:(0..1):if stamping_office = true

; ───────────────────────────────────────────────────────────────────────────────
; Diligent Search Requirements
; ───────────────────────────────────────────────────────────────────────────────
declinations_required = ##:(0..10)
export_list = ?
diligent_search_abolished = ?                    ; Some states have abolished (LA, MS, VA, WI)

; ───────────────────────────────────────────────────────────────────────────────
; Filing Requirements
; ───────────────────────────────────────────────────────────────────────────────
filing_deadline_days = ##:(0..90)                ; Days from effective date
tax_due_frequency = (annual, monthly, quarterly, semi_annual)
tax_due_date = :                           ; Description (e.g., "March 1 for prior year")

; ───────────────────────────────────────────────────────────────────────────────
; Special Provisions
; ───────────────────────────────────────────────────────────────────────────────
notes = :


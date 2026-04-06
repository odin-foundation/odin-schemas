; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Lloyd's of London Market Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Lloyd's of London market schema covering syndicates, managing agents, members'
; agents, and the subscription market including slip placement, binding
; authority, and bureau premium processing.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.market-structures.lloyds"
version = "1.0.0"
title = "Lloyd's of London Market Schema"
description = "Lloyd's market structures, participants, and transaction types"

{$derivation}
source[0].authority = "Lloyd's of London"
source[0].citation = "Lloyd's Market Resources and Conduct Requirements"
source[0].url = "https://www.lloyds.com/conducting-business"

source[1].authority = "Lloyd's of London"
source[1].citation = "Delegated Authority Code of Practice"
source[1].url = "https://www.lloyds.com/conducting-business/delegated-authorities/compliance-and-operations/code-of-practice"

source[2].authority = "Financial Conduct Authority (FCA)"
source[2].citation = "Lloyd's Market Supervision Requirements"
source[2].url = "https://www.fca.org.uk"

source[3].authority = "Prudential Regulation Authority (PRA)"
source[3].citation = "Lloyd's Insurance Prudential Sourcebook"
source[3].url = "https://www.bankofengland.co.uk/prudential-regulation"

source[4].authority = "London Market Group"
source[4].citation = "Market Reform Contract (MRC) v3 Template and Guidance"
source[4].url = "https://lmg.london/documents/mrc/"

source[5].authority = "HMRC"
source[5].citation = "Lloyd's Manual - LLM1100 to LLM1210"
source[5].url = "https://www.gov.uk/hmrc-internal-manuals/lloyds-manual"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Lloyd's market structures derived from public Lloyd's requirements, FCA/PRA regulations, and London Market Group resources"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial Lloyd's market schema"
changelog[0].rationale = "Comprehensive Lloyd's market structures for international specialty insurance"

; ═══════════════════════════════════════════════════════════════════════════════
; Lloyd's Syndicate
; ═══════════════════════════════════════════════════════════════════════════════
; A syndicate is formed by one or more members joining together to provide capital
; and accept insurance risks. Each syndicate sets its own appetite, develops a
; business plan, arranges reinsurance, and manages exposures and claims.

{@lloyds_syndicate}
id = :                                            ; Unique syndicate identifier

; ───────────────────────────────────────────────────────────────────────────────
; Syndicate Identification
; ───────────────────────────────────────────────────────────────────────────────
syndicate_name = :                         ; Syndicate trading name
syndicate_number = :(4)                           ; Lloyd's syndicate number (e.g., "2623")
syndicate_stamp = :                         ; Syndicate stamp code
year_of_account = ##                              ; YOA - year syndicate is underwriting

; ───────────────────────────────────────────────────────────────────────────────
; Syndicate Type and Status
; ───────────────────────────────────────────────────────────────────────────────
aligned = ?                                       ; Aligned syndicate (single corporate member)
status = (active, closed, in_runoff)              ; Alphabetical: active, closed, in_runoff
syndicate_type = (
    special_purpose_arrangement,                  ; SPA - quota share arrangements
    syndicate_in_a_box,                           ; SIAB - simplified entry model
    traditional                                   ; Standard syndicate
)                                                 ; Alphabetical

; ───────────────────────────────────────────────────────────────────────────────
; Capacity and Capital
; ───────────────────────────────────────────────────────────────────────────────
stamp_capacity = #$                               ; Maximum premium capacity for YOA
utilized_capacity = #$                            ; Premium written to date
available_capacity = #$                           ; Remaining capacity

; ───────────────────────────────────────────────────────────────────────────────
; Managing Agent Reference
; ───────────────────────────────────────────────────────────────────────────────
managing_agent_ref = :                      ; Reference to managing agent

; ───────────────────────────────────────────────────────────────────────────────
; Business Classes
; ───────────────────────────────────────────────────────────────────────────────
; Lloyd's risk codes and classes of business
{.business_classes[]}
lloyds_risk_code = :                              ; Lloyd's risk code
class_description = :                             ; Description of business class
gross_premium_capacity = #$                       ; Gross premium capacity for this class
net_premium_capacity = #$                         ; Net premium capacity after reinsurance
percentage_of_stamp = #:(0..100)                  ; Percentage of total stamp capacity

{@lloyds_syndicate}

; ───────────────────────────────────────────────────────────────────────────────
; Syndicate Ratings
; ───────────────────────────────────────────────────────────────────────────────
am_best_rating = :                                ; A.M. Best rating
fitch_rating = :                                  ; Fitch rating
moodys_rating = :                                 ; Moody's rating
sp_rating = :                                     ; S&P rating

; ───────────────────────────────────────────────────────────────────────────────
; Syndicate Contacts
; ───────────────────────────────────────────────────────────────────────────────
{.contact}
claims_email = *@email         ; Claims department email
general_email = *@email        ; General inquiries email
phone = *@phone                ; Syndicate contact phone
underwriting_email = *@email   ; Underwriting email

{@lloyds_syndicate}

; ═══════════════════════════════════════════════════════════════════════════════
; Managing Agent
; ═══════════════════════════════════════════════════════════════════════════════
; A managing agent is a company set up to manage one or more syndicates on behalf
; of the members. Managing agents employ underwriters, oversee underwriting, and
; manage infrastructure and day-to-day operations.

{@managing_agent}
id = :                                            ; Unique managing agent identifier

; ───────────────────────────────────────────────────────────────────────────────
; Identification
; ───────────────────────────────────────────────────────────────────────────────
company_number = :                                ; Companies House registration
legal_name = :                             ; Legal entity name
lloyds_code = :                                   ; Lloyd's managing agent code
trading_name = :                           ; Trading name

; ───────────────────────────────────────────────────────────────────────────────
; Regulatory Status
; ───────────────────────────────────────────────────────────────────────────────
authorized_date = date                            ; Date authorized by Lloyd's
fca_firm_reference = :                            ; FCA firm reference number
pra_firm_reference = :                            ; PRA firm reference number
status = (active, inactive, suspended)            ; Alphabetical: active, inactive, suspended

; ───────────────────────────────────────────────────────────────────────────────
; Syndicates Managed
; ───────────────────────────────────────────────────────────────────────────────
{.syndicates_managed[]}
syndicate_number = :(4)                           ; Syndicate number
syndicate_name = :                                ; Syndicate name
year_of_account = ##                              ; Year of account
relationship_start_date = date                    ; Management relationship start date
relationship_end_date = date                      ; Management relationship end date

{@managing_agent}

; ───────────────────────────────────────────────────────────────────────────────
; Parent Company
; ───────────────────────────────────────────────────────────────────────────────
parent_company = :                                ; Parent company name
parent_country = :(2..3)                          ; ISO country code
ultimate_parent = :                               ; Ultimate parent company name

; ───────────────────────────────────────────────────────────────────────────────
; Contact Information
; ───────────────────────────────────────────────────────────────────────────────
registered_address = @address                         ; Registered office address

{@managing_agent}
email = *@email                 ; Primary email contact
main_phone = *@phone            ; Main telephone number
website = :                     ; Company website URL

; ═══════════════════════════════════════════════════════════════════════════════
; Lloyd's Member (Capital Provider)
; ═══════════════════════════════════════════════════════════════════════════════
; Members provide capital to support syndicate underwriting. They include
; corporations (majority of capital) and individuals known as "Names".

{@lloyds_member}
id = :                                            ; Unique member identifier

; ───────────────────────────────────────────────────────────────────────────────
; Member Identification
; ───────────────────────────────────────────────────────────────────────────────
member_name = :                            ; Member name
member_number = :                                 ; Lloyd's member number

; ───────────────────────────────────────────────────────────────────────────────
; Member Type
; ───────────────────────────────────────────────────────────────────────────────
member_type = (
    corporate,                                    ; Corporate member (limited liability)
    individual_limited,                           ; Individual with limited liability
    individual_unlimited,                         ; Traditional "Name" (unlimited liability)
    namecos,                                      ; Namecos corporate structure
    scottish_limited_partnership                  ; SLP member
)                                                 ; Alphabetical
trading_status = (active, ceased, suspended)      ; Alphabetical: active, ceased, suspended

; ───────────────────────────────────────────────────────────────────────────────
; Capacity and Capital
; ───────────────────────────────────────────────────────────────────────────────
overall_premium_limit = #$                        ; Total underwriting capacity
funds_at_lloyds = #$                              ; FAL - capital held at Lloyd's

; ───────────────────────────────────────────────────────────────────────────────
; Syndicate Participations
; ───────────────────────────────────────────────────────────────────────────────
{.participations[]}
syndicate_number = :(4)                           ; Syndicate number
year_of_account = ##                              ; Year of account
allocated_capacity = #$                           ; Member's share of syndicate capacity
percentage_of_syndicate = #:(0..100)              ; Percentage of total syndicate capacity

{@lloyds_member}

; ───────────────────────────────────────────────────────────────────────────────
; Members' Agent (for individual members)
; ───────────────────────────────────────────────────────────────────────────────
members_agent_ref = :                             ; Reference to members' agent
members_agent_name = :                            ; Members' agent name

; ───────────────────────────────────────────────────────────────────────────────
; For Corporate Members
; ───────────────────────────────────────────────────────────────────────────────
company_number = ::if member_type = corporate     ; Company registration number
country_of_incorporation = :(2..3):if member_type = corporate   ; Country of incorporation
parent_company = ::if member_type = corporate     ; Parent company name

; ═══════════════════════════════════════════════════════════════════════════════
; Funds at Lloyd's (FAL)
; ═══════════════════════════════════════════════════════════════════════════════
; Capital lodged and held in trust at Lloyd's as security for policyholders
; and to support a member's overall underwriting business.

{@funds_at_lloyds}
id = :                                            ; Unique FAL identifier

; ───────────────────────────────────────────────────────────────────────────────
; FAL Identification
; ───────────────────────────────────────────────────────────────────────────────
member_ref = :                                    ; Reference to member
year_of_account = ##                              ; Year of account
valuation_date = date                             ; Valuation date

; ───────────────────────────────────────────────────────────────────────────────
; FAL Components
; ───────────────────────────────────────────────────────────────────────────────
lloyds_deposit = #$                               ; Minimum deposit requirement
personal_reserve_fund = #$                        ; PRF
special_reserve_fund = #$                         ; SRF (individuals only)
total_fal = #$                                    ; Total FAL value

; ───────────────────────────────────────────────────────────────────────────────
; FAL Composition
; ───────────────────────────────────────────────────────────────────────────────
{.composition[]}
asset_type = (
    approved_securities,
    bank_guarantee,
    cash,
    equities,
    fixed_income,
    letter_of_credit                              ; LOC - limited to 50%
)                                                 ; Alphabetical
currency = :(3)                                   ; USD, GBP, EUR, AUD, CAD, JPY
percentage_of_total = #:(0..100)                  ; Percentage of total FAL
value = #$                                        ; Asset value

{@funds_at_lloyds}

; ───────────────────────────────────────────────────────────────────────────────
; Capital Requirements
; ───────────────────────────────────────────────────────────────────────────────
required_fal = #$                                 ; Capital requirement
economic_capital_assessment = #$                  ; ECA - SCR with 35% uplift
surplus_deficit = #$                              ; FAL minus requirement

; ═══════════════════════════════════════════════════════════════════════════════
; Lloyd's Broker
; ═══════════════════════════════════════════════════════════════════════════════
; Lloyd's brokers facilitate risk transfer between policyholders and underwriters.
; Only registered Lloyd's brokers can place business directly in the Lloyd's market.

{@lloyds_broker}
id = :                                            ; Unique broker identifier

; ───────────────────────────────────────────────────────────────────────────────
; Broker Identification
; ───────────────────────────────────────────────────────────────────────────────
broker_code = :(4)                                ; Lloyd's broker code (4 digits)
legal_name = :                             ; Legal entity name
trading_name = :                           ; Trading name

; ───────────────────────────────────────────────────────────────────────────────
; Regulatory Status
; ───────────────────────────────────────────────────────────────────────────────
fca_firm_reference = :                            ; FCA firm reference number
lloyds_registration_date = date                   ; Date registered with Lloyd's
status = (active, suspended, terminated)          ; Alphabetical: active, suspended, terminated

; ───────────────────────────────────────────────────────────────────────────────
; Broker Classification
; ───────────────────────────────────────────────────────────────────────────────
broker_type = (
    london_market,                                ; Full London Market broker
    reinsurance,                                  ; Reinsurance specialist
    specialty,                                    ; Specialty lines broker
    wholesale                                     ; Wholesale broker
)                                                 ; Alphabetical
lloyds_accredited = ?                             ; Accredited broker status

; ───────────────────────────────────────────────────────────────────────────────
; Parent/Group
; ───────────────────────────────────────────────────────────────────────────────
parent_company = :                                ; Parent company name
broker_group = :                                  ; e.g., "Marsh", "Aon", "WTW"

; ───────────────────────────────────────────────────────────────────────────────
; Contact Information
; ───────────────────────────────────────────────────────────────────────────────
registered_address = @address                         ; Registered office address

{@lloyds_broker}
email = *@email                 ; Primary email contact
main_phone = *@phone            ; Main telephone number
website = :                     ; Company website URL

; ═══════════════════════════════════════════════════════════════════════════════
; Lloyd's Coverholder
; ═══════════════════════════════════════════════════════════════════════════════
; A coverholder (Managing General Agent - MGA) is authorized by a managing agent
; to enter into contracts of insurance on behalf of Lloyd's syndicates through
; a binding authority agreement.

{@lloyds_coverholder}
id = :                                            ; Unique coverholder identifier

; ───────────────────────────────────────────────────────────────────────────────
; Coverholder Identification
; ───────────────────────────────────────────────────────────────────────────────
coverholder_pin = :                               ; Lloyd's coverholder PIN
legal_name = :                             ; Legal entity name
trading_name = :                           ; Trading name

; ───────────────────────────────────────────────────────────────────────────────
; Coverholder Status
; ───────────────────────────────────────────────────────────────────────────────
approval_date = date                              ; Date approved by Lloyd's
last_review_date = date                           ; Last review date
next_review_date = date                           ; Next scheduled review date
status = (approved, suspended, terminated)        ; Alphabetical: approved, suspended, terminated

; ───────────────────────────────────────────────────────────────────────────────
; Sponsorship
; ───────────────────────────────────────────────────────────────────────────────
; Coverholders must be sponsored by both a Lloyd's broker and managing agent
sponsoring_broker_ref = :                         ; Reference to sponsoring broker
sponsoring_broker_code = :(4)                     ; Sponsoring broker code

; ───────────────────────────────────────────────────────────────────────────────
; Location and Jurisdiction
; ───────────────────────────────────────────────────────────────────────────────
domicile_country = :(2..3)                            ; Country of domicile
registered_address = @address                         ; Registered office address

{@lloyds_coverholder}

; ───────────────────────────────────────────────────────────────────────────────
; Binding Authorities Held
; ───────────────────────────────────────────────────────────────────────────────
{.binding_authorities[]}
binding_authority_ref = :                   ; Reference to binding authority
effective = date                                  ; Authority effective date
expiration = date                                 ; Authority expiration date
status = (active, cancelled, expired)             ; Alphabetical: active, cancelled, expired
umr = :                                           ; UMR for the binding authority

{@lloyds_coverholder}

; ───────────────────────────────────────────────────────────────────────────────
; Contact Information
; ───────────────────────────────────────────────────────────────────────────────
email = *@email                 ; Primary email contact
main_phone = *@phone            ; Main telephone number
website = :                     ; Company website URL

; ═══════════════════════════════════════════════════════════════════════════════
; Unique Market Identifier (UMR)
; ═══════════════════════════════════════════════════════════════════════════════
; The UMR uniquely identifies a contract in the Lloyd's market. Format starts
; with "B" followed by Lloyd's broker code and alphanumeric reference.
; Maximum 17 characters, no spaces or punctuation.

{@unique_market_identifier}
id = :                                            ; Unique UMR identifier

; ───────────────────────────────────────────────────────────────────────────────
; UMR Components
; ───────────────────────────────────────────────────────────────────────────────
umr = :/^B[0-9]{4}[A-Z0-9]{1,12}$/                ; B + 4-digit broker code + up to 12 chars
broker_code = :(4)                                ; Extracted from UMR
broker_reference = :                              ; Unique broker reference portion

; ───────────────────────────────────────────────────────────────────────────────
; UMR Context
; ───────────────────────────────────────────────────────────────────────────────
contract_type = (
    binding_authority,                            ; Binding authority agreement
    consortium,                                   ; Consortium arrangement
    facultative_reinsurance,                      ; Facultative reinsurance
    lineslip,                                     ; Line slip arrangement
    open_market,                                  ; Standard open market placement
    treaty_reinsurance                            ; Treaty reinsurance
)                                                 ; Alphabetical
created_by_broker_ref = :                         ; Broker reference who created UMR
created = date                                    ; UMR creation date

; ═══════════════════════════════════════════════════════════════════════════════
; Lloyd's Slip (Risk Presentation)
; ═══════════════════════════════════════════════════════════════════════════════
; The slip is a document created by a broker containing summary terms of a
; proposed insurance contract, presented to underwriters for consideration.

{@lloyds_slip}
id = :                                            ; Unique slip identifier

; ───────────────────────────────────────────────────────────────────────────────
; Slip Identification
; ───────────────────────────────────────────────────────────────────────────────
umr = :/^B[0-9]{4}[A-Z0-9]{1,12}$/                ; Unique market reference
broker_slip_reference = :                         ; Broker's slip reference
slip_version = ##                                 ; Slip version number

; ───────────────────────────────────────────────────────────────────────────────
; Slip Type and Stage
; ───────────────────────────────────────────────────────────────────────────────
slip_stage = (
    closed,                                       ; Administratively closed
    firm_order,                                   ; Firm order to bind
    indication,                                   ; Seeking indicative terms
    signed                                        ; Fully signed/placed
)                                                 ; Alphabetical
slip_type = (
    endorsement_slip,                             ; Mid-term amendment
    placing_slip,                                 ; Initial risk presentation
    renewal_slip,                                 ; Renewal presentation
    signing_slip                                  ; Post-placement for signing
)                                                 ; Alphabetical

; ───────────────────────────────────────────────────────────────────────────────
; Broker Details
; ───────────────────────────────────────────────────────────────────────────────
broker_code = :(4)                                ; Lloyd's broker code
broker_contact = :                         ; Broker contact name
broker_contact_email = *@email   ; Broker contact email
broker_contact_phone = *@phone   ; Broker contact phone
broker_name = :                            ; Broker name
broker_ref = :                              ; Reference to broker

; ───────────────────────────────────────────────────────────────────────────────
; Insured/Reinsured Details
; ───────────────────────────────────────────────────────────────────────────────
insured_name = :                             ; Insured name
insured_address = @address                   ; Insured address
insured_country = :(2..3)                    ; Insured country
insured_industry = :                         ; Insured industry

; ───────────────────────────────────────────────────────────────────────────────
; Risk Details
; ───────────────────────────────────────────────────────────────────────────────
risk_type = (insurance, reinsurance, retrocession)   ; Type of risk
class_of_business = :                             ; Lloyd's class code/description
subclass = :                                      ; Risk subclass
risk_description = :                              ; Description of the risk
risk_location = :                                 ; Location of the risk

; ───────────────────────────────────────────────────────────────────────────────
; Period
; ───────────────────────────────────────────────────────────────────────────────
effective = date                                  ; Policy effective date
expiration = date                                 ; Policy expiration date
period_basis = (
    annual,
    claims_made,
    continuous,
    losses_occurring,
    multi_year,
    risks_attaching,
    short_period
)                                                 ; Period basis (alphabetical)
period_months = ##:(1..120)                       ; Period duration in months

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Details
; ───────────────────────────────────────────────────────────────────────────────
currency = :(3)                                   ; Currency code
limit = #$                                        ; Policy limit
excess = #$                                       ; Excess amount
deductible = #$                                   ; Deductible amount
aggregate_limit = #$                              ; Aggregate limit
aggregate_deductible = #$                         ; Aggregate deductible

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
gross_premium = #$                                ; Gross premium amount
minimum_deposit_premium = #$                      ; Minimum deposit premium
adjustable = ?                                    ; Whether premium is adjustable
rate = #                                          ; Premium rate
rate_basis = :                                    ; e.g., "per mille", "percentage of TSI"

{@lloyds_slip}

; ───────────────────────────────────────────────────────────────────────────────
; Terms and Conditions
; ───────────────────────────────────────────────────────────────────────────────
policy_form = :                                   ; e.g., "Lloyd's MAR Form"
jurisdiction = :                                  ; Jurisdiction
governing_law = :                                 ; Governing law
dispute_resolution = :                            ; Dispute resolution method

; ───────────────────────────────────────────────────────────────────────────────
; Warranties, Conditions, Exclusions
; ───────────────────────────────────────────────────────────────────────────────
warranties[] = :                                  ; Policy warranties
conditions[] = :                                  ; Policy conditions
exclusions[] = :                                  ; Policy exclusions
subjectivities[] = :                              ; Conditions precedent to attachment

; ───────────────────────────────────────────────────────────────────────────────
; Information Basis
; ───────────────────────────────────────────────────────────────────────────────
information_provided[] = :                        ; Documents provided to underwriters
;basis_of_presentation = :

; ───────────────────────────────────────────────────────────────────────────────
; Placement Status
; ───────────────────────────────────────────────────────────────────────────────
total_written_line = #                            ; May exceed 100% before signing down
total_signed_line = #:(0..100)                    ; Final signed percentage
placement_complete = ?                            ; Whether placement is complete
placement_date = date                             ; Placement completion date

; ═══════════════════════════════════════════════════════════════════════════════
; Market Reform Contract (MRC)
; ═══════════════════════════════════════════════════════════════════════════════
; The MRC is the London Market standard contract format since November 2007.
; MRC v3 enables structured data flow through the insurance transaction lifecycle.

{@market_reform_contract}
id = :                                            ; Unique MRC identifier

; ───────────────────────────────────────────────────────────────────────────────
; MRC Identification
; ───────────────────────────────────────────────────────────────────────────────
umr = :/^B[0-9]{4}[A-Z0-9]{1,12}$/                ; Unique market reference
mrc_version = (v2, v3)                            ; MRC format version
document_version = ##                             ; Document revision number

; ───────────────────────────────────────────────────────────────────────────────
; Contract Type
; ───────────────────────────────────────────────────────────────────────────────
contract_type = (insurance, reinsurance, retrocession)   ; Alphabetical
placement_type = (
    binding_authority,
    consortium,
    lineslip_declaration,
    open_market
)                                                 ; Alphabetical

; ───────────────────────────────────────────────────────────────────────────────
; Risk Details (Mandatory MRC Headings)
; ───────────────────────────────────────────────────────────────────────────────
{.risk_details}
type_of_insurance = :                             ; Type of insurance/reinsurance
class = :                                         ; Class of business
subclass = :                                      ; Subclass of business

{@market_reform_contract}
insured = :                                       ; Insured name
period_from = date                                ; Policy period start date
period_to = date                                  ; Policy period end date

; ───────────────────────────────────────────────────────────────────────────────
; Interest (what is covered)
; ───────────────────────────────────────────────────────────────────────────────
interest = :                                      ; Subject matter insured
situation = :                                     ; Location/territory

; ───────────────────────────────────────────────────────────────────────────────
; Conditions (coverage terms)
; ───────────────────────────────────────────────────────────────────────────────
conditions = :                                    ; Coverage conditions
limit_of_liability = #$                           ; Limit of liability
limit_currency = :(3)                             ; Limit currency
basis_of_cover = :                                ; Basis of cover

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
amount = #$                                       ; Premium amount
currency = :(3)                                   ; Premium currency
payment_terms = :                                 ; Premium payment terms
adjustment_basis = :                              ; Premium adjustment basis

{@market_reform_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Deductible
; ───────────────────────────────────────────────────────────────────────────────
{.deductible}
amount = #$                                       ; Deductible amount
currency = :(3)                                   ; Deductible currency
basis = :                                         ; Deductible basis

{@market_reform_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Exclusions
; ───────────────────────────────────────────────────────────────────────────────
exclusions[] = :                                  ; Coverage exclusions

; ───────────────────────────────────────────────────────────────────────────────
; Security Details
; ───────────────────────────────────────────────────────────────────────────────
{.security[]}
company_name = ::if security_type = company   ; Company name (if company security)
order = ##                                        ; Order in slip presentation
security_type = (company, lloyds, mixed)          ; Alphabetical: company, lloyds, mixed
signed_line = #:(0..100)                          ; Signed line percentage
syndicate_ref = ::if security_type = lloyds ; Syndicate reference (if Lloyd's security)
written_line = #                                  ; Written line percentage

{@market_reform_contract}

; ───────────────────────────────────────────────────────────────────────────────
; General Provisions
; ───────────────────────────────────────────────────────────────────────────────
claims_agreement = :                              ; Claims agreement parties
jurisdiction = :                                  ; Jurisdiction
choice_of_law = :                                 ; Choice of law
several_liability_clause = :                      ; Several liability clause
order_hereon = ##                                 ; Order hereon number

; ───────────────────────────────────────────────────────────────────────────────
; Fiscal and Regulatory
; ───────────────────────────────────────────────────────────────────────────────
{.regulatory}
surplus_lines_state = :(2):if applies            ; US surplus lines state
surplus_lines_license = :                         ; Surplus lines license number
tax_treatment = :                                 ; Tax treatment
regulatory_notifications = :                      ; Regulatory notifications

{@market_reform_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Broker Details
; ───────────────────────────────────────────────────────────────────────────────
broker_code = :(4)                           ; Broker code
broker_name = :                              ; Broker name
broker_address = @address                    ; Broker address

; ───────────────────────────────────────────────────────────────────────────────
; Information
; ───────────────────────────────────────────────────────────────────────────────
information[] = :                                 ; Information provided to underwriters

; ═══════════════════════════════════════════════════════════════════════════════
; Binding Authority Agreement
; ═══════════════════════════════════════════════════════════════════════════════
; A binding authority is an agreement between a managing agent and a coverholder
; delegating authority to enter into contracts of insurance on behalf of syndicates.

{@binding_authority}
id = :                                            ; Unique binding authority identifier

; ───────────────────────────────────────────────────────────────────────────────
; Binding Authority Identification
; ───────────────────────────────────────────────────────────────────────────────
umr = :/^B[0-9]{4}[A-Z0-9]{1,12}$/                ; Binding authority UMR
agreement_reference = :                           ; Agreement reference
agreement_name = :                                ; Agreement name

; ───────────────────────────────────────────────────────────────────────────────
; Parties
; ───────────────────────────────────────────────────────────────────────────────
coverholder_ref = :                               ; Reference to coverholder
coverholder_name = :                              ; Coverholder name
coverholder_pin = :                               ; Coverholder PIN
broker_ref = :                                    ; Reference to broker
broker_code = :(4)                                ; Broker code

; ───────────────────────────────────────────────────────────────────────────────
; Agreement Period
; ───────────────────────────────────────────────────────────────────────────────
effective = date                                  ; Agreement effective date
expiration = date                                 ; Agreement expiration date
notice_period_days = ##:(0..365)                  ; Notice period in days (standard: 90)

; ───────────────────────────────────────────────────────────────────────────────
; Underwriting Authority
; ───────────────────────────────────────────────────────────────────────────────
class_of_business = :                             ; Class of business
territory = :                                     ; Geographic scope
risk_types_permitted[] = :                        ; Risk types permitted
risk_types_excluded[] = :                         ; Risk types excluded

; ───────────────────────────────────────────────────────────────────────────────
; Limits of Authority
; ───────────────────────────────────────────────────────────────────────────────
{.limits}
maximum_policy_limit = #$                         ; Maximum policy limit
currency = :(3)                                   ; Limits currency
aggregate_limit = #$                              ; Aggregate limit
single_risk_limit = #$                            ; Single risk limit
maximum_premium_per_policy = #$                   ; Maximum premium per policy
minimum_premium_per_policy = #$                   ; Minimum premium per policy
minimum_deductible = #$                           ; Minimum deductible

{@binding_authority}

; ───────────────────────────────────────────────────────────────────────────────
; Capacity and Premium
; ───────────────────────────────────────────────────────────────────────────────
estimated_premium_income = #$                     ; Estimated premium income
premium_limit = #$                                ; Maximum premium under agreement
premium_written_to_date = #$                      ; Premium written to date

; ───────────────────────────────────────────────────────────────────────────────
; Security/Capacity Providers
; ───────────────────────────────────────────────────────────────────────────────
{.capacity_providers[]}
syndicate_number = :(4)                           ; Syndicate number
syndicate_name = :                                ; Syndicate name
managing_agent_ref = :                            ; Reference to managing agent
line_percentage = #:(0..100)                      ; Line percentage
order_hereon = ##                                 ; Order hereon number

{@binding_authority}

; ───────────────────────────────────────────────────────────────────────────────
; Delegated Authorities
; ───────────────────────────────────────────────────────────────────────────────
can_bind_risks = ?                                ; Underwriting authority
can_issue_policies = ?                            ; Documentation authority
can_collect_premium = ?                           ; Premium collection authority
can_handle_claims = ?                             ; Claims authority
claims_authority_limit = #$:if can_handle_claims = true   ; Claims authority limit if claims handling delegated

; ───────────────────────────────────────────────────────────────────────────────
; Reporting Requirements
; ───────────────────────────────────────────────────────────────────────────────
bordereaux_frequency = (daily, monthly, quarterly, weekly)   ; Alphabetical
risk_data_format = :                              ; e.g., "ACORD", "Custom"

; ───────────────────────────────────────────────────────────────────────────────
; Agreement Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, cancelled, expired, run_off, suspended)   ; Alphabetical
termination_date = date                           ; Date agreement terminated
termination_reason = :                            ; Reason for termination

; ═══════════════════════════════════════════════════════════════════════════════
; Syndicate Participation (Written/Signed Line)
; ═══════════════════════════════════════════════════════════════════════════════
; Represents a syndicate's share of a risk in Lloyd's subscription market.
; Written line may exceed 100%; signed line is proportioned to exactly 100%.

{@syndicate_participation}
id = :                                            ; Unique participation identifier

; ───────────────────────────────────────────────────────────────────────────────
; Contract Reference
; ───────────────────────────────────────────────────────────────────────────────
umr = :/^B[0-9]{4}[A-Z0-9]{1,12}$/                ; Unique market reference
contract_ref = :                                  ; Contract reference

; ───────────────────────────────────────────────────────────────────────────────
; Syndicate Details
; ───────────────────────────────────────────────────────────────────────────────
syndicate_number = :(4)                           ; Syndicate number
syndicate_name = :                                ; Syndicate name
managing_agent_ref = :                            ; Reference to managing agent
syndicate_stamp = :                               ; Syndicate stamp

; ───────────────────────────────────────────────────────────────────────────────
; Underwriter Details
; ───────────────────────────────────────────────────────────────────────────────
underwriter_name = :                              ; Underwriter name
underwriter_reference = :                         ; Underwriter reference
underwriting_date = date                          ; Underwriting date

; ───────────────────────────────────────────────────────────────────────────────
; Line Details
; ───────────────────────────────────────────────────────────────────────────────
written_line = #                                  ; Initial written percentage (may > 100%)
signed_line = #:(0..100)                          ; Final signed percentage after signing down
order_percentage = #:(0..100)                     ; Order hereon (position percentage)

; ───────────────────────────────────────────────────────────────────────────────
; Line Status
; ───────────────────────────────────────────────────────────────────────────────
line_protected = ?                                ; Line protected from signing down
line_status = (
    quoted,                                       ; Indication given
    scratched,                                    ; Written on slip
    signed,                                       ; Formally signed
    withdrawn                                     ; Line withdrawn
)                                                 ; Alphabetical

; ───────────────────────────────────────────────────────────────────────────────
; Participation Role
; ───────────────────────────────────────────────────────────────────────────────
lead = ?                                       ; Lead underwriter indicator
lead_order = ##:(1..5)                            ; Position in lead order
participation_role = (
    follower,                                     ; Following market
    lead,                                         ; Lead underwriter (sets terms)
    second                                        ; Second agreement party
)                                                 ; Alphabetical

; ───────────────────────────────────────────────────────────────────────────────
; Premium Share
; ───────────────────────────────────────────────────────────────────────────────
gross_premium_share = #$                          ; Syndicate's share of gross premium
net_premium_share = #$                            ; After brokerage
premium_currency = :(3)                           ; Premium currency

; ───────────────────────────────────────────────────────────────────────────────
; Subjectivities
; ───────────────────────────────────────────────────────────────────────────────
subjectivities[] = :                              ; Conditions for this syndicate
subjectivities_cleared = ?                        ; All subjectivities cleared flag

; ═══════════════════════════════════════════════════════════════════════════════
; Line Slip
; ═══════════════════════════════════════════════════════════════════════════════
; A line slip is an agreement where insurers delegate underwriting authority
; to a lead insurer for a certain class of risks. Set up by brokers.

{@line_slip}
id = :                                            ; Unique line slip identifier

; ───────────────────────────────────────────────────────────────────────────────
; Line Slip Identification
; ───────────────────────────────────────────────────────────────────────────────
umr = :/^B[0-9]{4}[A-Z0-9]{1,12}$/                ; Unique market reference
line_slip_reference = :                           ; Line slip reference
line_slip_name = :                                ; Line slip name

; ───────────────────────────────────────────────────────────────────────────────
; Line Slip Lead
; ───────────────────────────────────────────────────────────────────────────────
lead_syndicate_number = :(4)                      ; Lead syndicate number
lead_syndicate_name = :                           ; Lead syndicate name
lead_managing_agent_ref = :                       ; Reference to lead managing agent

; ───────────────────────────────────────────────────────────────────────────────
; Broker
; ───────────────────────────────────────────────────────────────────────────────
broker_ref = :                                    ; Reference to broker
broker_code = :(4)                                ; Broker code

; ───────────────────────────────────────────────────────────────────────────────
; Line Slip Terms
; ───────────────────────────────────────────────────────────────────────────────
class_of_business = :                             ; Class of business covered
effective = date                                  ; Line slip effective date
expiration = date                                 ; Line slip expiration date
territory = :                                     ; Geographic coverage territory

; ───────────────────────────────────────────────────────────────────────────────
; Participants
; ───────────────────────────────────────────────────────────────────────────────
{.participants[]}
line_percentage = #:(0..100)                      ; Participant's line percentage
participant_role = (follower, lead)               ; Alphabetical: follower, lead
syndicate_name = :                         ; Syndicate name
syndicate_number = :(4)                           ; Syndicate number

{@line_slip}

; ───────────────────────────────────────────────────────────────────────────────
; Declaration Limits
; ───────────────────────────────────────────────────────────────────────────────
maximum_declaration_limit = #$                    ; Maximum declaration limit
currency = :(3)                                   ; Currency code

; ═══════════════════════════════════════════════════════════════════════════════
; Consortium
; ═══════════════════════════════════════════════════════════════════════════════
; A consortium allows syndicates to pool capacity and present a single front.
; Unlike line slips, consortia can involve multiple brokers.

{@consortium}
id = :                                            ; Unique consortium identifier

; ───────────────────────────────────────────────────────────────────────────────
; Consortium Identification
; ───────────────────────────────────────────────────────────────────────────────
consortium_reference = :                          ; Consortium reference
consortium_name = :                               ; Consortium name
consortium_stamp = :                              ; Single stamp for all members

; ───────────────────────────────────────────────────────────────────────────────
; Consortium Lead
; ───────────────────────────────────────────────────────────────────────────────
lead_syndicate_number = :(4)                      ; Lead syndicate number
lead_syndicate_name = :                           ; Lead syndicate name
lead_managing_agent_ref = :                       ; Reference to lead managing agent

; ───────────────────────────────────────────────────────────────────────────────
; Consortium Terms
; ───────────────────────────────────────────────────────────────────────────────
class_of_business = :                             ; Class of business covered
effective = date                                  ; Consortium effective date
expiration = date                                 ; Consortium expiration date
territory = :                                     ; Geographic coverage territory

; ───────────────────────────────────────────────────────────────────────────────
; Consortium Members
; ───────────────────────────────────────────────────────────────────────────────
{.members[]}
managing_agent_ref = :                      ; Managing agent reference
member_role = (lead, member)                      ; Alphabetical: lead, member
share_percentage = #:(0..100)                     ; Member's share percentage
syndicate_name = :                         ; Syndicate name
syndicate_number = :(4)                           ; Syndicate number

{@consortium}

; ───────────────────────────────────────────────────────────────────────────────
; Capacity
; ───────────────────────────────────────────────────────────────────────────────
total_consortium_capacity = #$                    ; Total consortium capacity
currency = :(3)                                   ; Currency code

; ═══════════════════════════════════════════════════════════════════════════════
; Lloyd's Claim
; ═══════════════════════════════════════════════════════════════════════════════
; Lloyd's claims follow the Claims Scheme where lead underwriters agree claims
; on behalf of all participating syndicates (followers).

{@lloyds_claim}
id = :                                            ; Unique claim identifier

; ───────────────────────────────────────────────────────────────────────────────
; Claim Identification
; ───────────────────────────────────────────────────────────────────────────────
ucr = :                                           ; Unique Claims Reference
umr = :/^B[0-9]{4}[A-Z0-9]{1,12}$/                ; Links to placing UMR
broker_reference = :                              ; Broker reference
insured_reference = :                             ; Insured reference

; ───────────────────────────────────────────────────────────────────────────────
; Claim Details
; ───────────────────────────────────────────────────────────────────────────────
cause = :                                  ; Cause of loss
description = :                           ; Claim description
type = (ex_gratia, first_party, recovery, third_party)   ; Alphabetical
loss_date = date                                  ; Date of loss
loss_location = :                          ; Loss location
notification_date = date                          ; Date claim notified

; ───────────────────────────────────────────────────────────────────────────────
; Claim Financials
; ───────────────────────────────────────────────────────────────────────────────
currency = :(3)                                   ; Claim currency
amount_claimed = #$                               ; Amount claimed
amount_reserved = #$                              ; Amount reserved
amount_paid = #$                                  ; Amount paid
amount_outstanding = #$                           ; Amount outstanding
deductible_applied = #$                           ; Deductible applied
recovery_received = #$                            ; Recovery received

; ───────────────────────────────────────────────────────────────────────────────
; Claims Agreement Parties (CAPs)
; ───────────────────────────────────────────────────────────────────────────────
; Lead(s) agree claims on behalf of all Lloyd's insurers
{.claims_agreement_parties[]}
agreement_date = date                             ; Date of agreement
agreement_status = (agreed, disputed, pending, referred)   ; Alphabetical
cap_role = (follower, lead, second)               ; Alphabetical: follower, lead, second
claims_adjuster = :                        ; Claims adjuster name
syndicate_name = :                         ; Syndicate name
syndicate_number = :(4)                           ; Syndicate number

{@lloyds_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Claim Thresholds
; ───────────────────────────────────────────────────────────────────────────────
; Claims under threshold need only lead agreement; complex claims need two CAPs
complex_claim = ?                                 ; Requires two CAPs
threshold_amount = #$                             ; Standard: GBP 250,000
threshold_currency = :(3) "GBP"                   ; Threshold currency
two_cap_required = ?                              ; Two CAPs required flag

; ───────────────────────────────────────────────────────────────────────────────
; Claim Status
; ───────────────────────────────────────────────────────────────────────────────
status = (
    agreed,                                       ; All CAPs agreed
    awaiting_information,                         ; Additional info needed
    cap_review,                                   ; With CAP for agreement
    closed,                                       ; Administratively closed
    declined,                                     ; Claim declined
    notified,                                     ; Initial notification
    paid,                                         ; Fully paid
    part_agreed,                                  ; Partial agreement
    reopened,                                     ; Previously closed, now reopened
    under_review                                  ; Being assessed
)                                                 ; Alphabetical

; ───────────────────────────────────────────────────────────────────────────────
; ECF (Electronic Claims File)
; ───────────────────────────────────────────────────────────────────────────────
ecf_created = timestamp                           ; ECF creation timestamp (standardized)
ecf_reference = :                                 ; Electronic Claims File reference
ecf_status = (agreed, closed, created, pending, settled)   ; Alphabetical

; ───────────────────────────────────────────────────────────────────────────────
; Syndicate Settlement Shares
; ───────────────────────────────────────────────────────────────────────────────
{.settlement_shares[]}
outstanding = #$                                  ; Outstanding claim amount
paid_to_date = #$                                 ; Amount paid to date
share_of_claim = #$                               ; Syndicate's share of claim
signed_line = #:(0..100)                          ; Signed line percentage
syndicate_number = :(4)                           ; Syndicate number

{@lloyds_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Broker Details
; ───────────────────────────────────────────────────────────────────────────────
broker_code = :(4)                                ; Broker code
broker_claims_handler = :                         ; Broker claims handler name
broker_claims_email = *@email                     ; Broker claims email

; ═══════════════════════════════════════════════════════════════════════════════
; Lloyd's Central Fund
; ═══════════════════════════════════════════════════════════════════════════════
; The Central Fund provides mutuality - backstop for policyholder claims if
; a member cannot meet liabilities. Third link in chain of security.

{@central_fund_contribution}
id = :                                            ; Unique contribution identifier

; ───────────────────────────────────────────────────────────────────────────────
; Contribution Details
; ───────────────────────────────────────────────────────────────────────────────
member_ref = :                                    ; Reference to member
year_of_account = ##                              ; Year of account
contribution_year = ##                            ; Contribution year

; ───────────────────────────────────────────────────────────────────────────────
; Contribution Amount
; ───────────────────────────────────────────────────────────────────────────────
annual_contribution = #$                          ; Annual contribution to Central Fund
contribution_rate = #:(0..100)                    ; Percentage of premium limit
premium_limit_basis = #$                          ; Member's overall premium limit
currency = :(3) "GBP"                             ; Currency (default GBP)

; ───────────────────────────────────────────────────────────────────────────────
; Callable Layer
; ───────────────────────────────────────────────────────────────────────────────
callable_amount = #$                              ; Up to 5% of premium limits
callable_percentage = #:(0..100)                  ; Callable percentage

; ═══════════════════════════════════════════════════════════════════════════════
; Lloyd's Service Company
; ═══════════════════════════════════════════════════════════════════════════════
; Service companies provide services to syndicates (e.g., claims handling,
; policy issuance) but cannot bind risks.

{@lloyds_service_company}
id = :                                            ; Unique service company identifier

; ───────────────────────────────────────────────────────────────────────────────
; Identification
; ───────────────────────────────────────────────────────────────────────────────
service_company_pin = :                           ; Lloyd's PIN
legal_name = :                                    ; Legal entity name
trading_name = :                                  ; Trading name

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
approval_date = date                              ; Date approved by Lloyd's
status = (approved, suspended, terminated)        ; Alphabetical: approved, suspended, terminated

; ───────────────────────────────────────────────────────────────────────────────
; Services Provided
; ───────────────────────────────────────────────────────────────────────────────
services_provided[] = (
    administration,
    claims_handling,
    loss_adjusting,
    policy_issuance,
    premium_collection,
    risk_survey
)                                                 ; Alphabetical

; ───────────────────────────────────────────────────────────────────────────────
; Location
; ───────────────────────────────────────────────────────────────────────────────
domicile_country = :(2..3)                            ; Country of domicile
registered_address = @address                         ; Registered office address

{@lloyds_service_company}

; ═══════════════════════════════════════════════════════════════════════════════
; Lloyd's Risk Code
; ═══════════════════════════════════════════════════════════════════════════════
; Lloyd's uses specific risk codes to classify business lines.

{@lloyds_risk_code}
active = ?                                        ; Risk code active flag
category = (
    accident_health,
    aviation,
    casualty,
    energy,
    life,
    marine,
    motor,
    property,
    reinsurance_casualty,
    reinsurance_property,
    reinsurance_specialty
)                                                 ; Alphabetical
code = :                                          ; Lloyd's risk code
description = :                                   ; Risk code description
reporting_class = :                               ; Reporting class

; ═══════════════════════════════════════════════════════════════════════════════
; Premium Trust Fund
; ═══════════════════════════════════════════════════════════════════════════════
; First link in chain of security. Syndicate-level assets held in trust.

{@premium_trust_fund}
id = :                                            ; Unique trust fund identifier

; ───────────────────────────────────────────────────────────────────────────────
; Trust Fund Details
; ───────────────────────────────────────────────────────────────────────────────
currency = :(3)                                   ; Trust fund currency
syndicate_number = :(4)                           ; Syndicate number
trust_fund_type = (
    lloyd_asia_trust_fund,                        ; For Asian business
    lloyds_american_trust_fund,                   ; LATF - US dollar business
    lloyds_canadian_trust_fund,                   ; For Canadian business
    premium_trust_fund_euro,                      ; Euro business
    premium_trust_fund_uk                         ; UK/other sterling
)                                                 ; Alphabetical
valuation_date = date                             ; Valuation date
year_of_account = ##                              ; Year of account

; ───────────────────────────────────────────────────────────────────────────────
; Fund Values
; ───────────────────────────────────────────────────────────────────────────────
total_assets = #$                                 ; Total trust fund assets
technical_provisions = #$                         ; Technical provisions
surplus_deficit = #$                              ; Surplus or deficit

; ═══════════════════════════════════════════════════════════════════════════════
; Lloyd's Policy
; ═══════════════════════════════════════════════════════════════════════════════
; A Lloyd's policy issued under a placement or binding authority.

{@lloyds_policy}
id = :                                            ; Unique policy identifier

; ───────────────────────────────────────────────────────────────────────────────
; Policy Identification
; ───────────────────────────────────────────────────────────────────────────────
umr = :/^B[0-9]{4}[A-Z0-9]{1,12}$/                ; Unique market reference
policy_number = :                                 ; Policy number
certificate_number = :                            ; Certificate number

; ───────────────────────────────────────────────────────────────────────────────
; Policy Source
; ───────────────────────────────────────────────────────────────────────────────
binding_authority_umr = ::if policy_source = binding_authority   ; BA UMR if from binding authority
policy_source = (binding_authority, consortium, lineslip, open_market)   ; Alphabetical

; ───────────────────────────────────────────────────────────────────────────────
; Period
; ───────────────────────────────────────────────────────────────────────────────
effective = date                                  ; Policy effective date
expiration = date                                 ; Policy expiration date

; ───────────────────────────────────────────────────────────────────────────────
; Policy Details
; ───────────────────────────────────────────────────────────────────────────────
insured_name = :                                  ; Insured name
risk_description = :                              ; Risk description
class_of_business = :                             ; Class of business
currency = :(3)                                   ; Policy currency
sum_insured = #$                                  ; Sum insured
premium = #$                                      ; Premium amount

; ───────────────────────────────────────────────────────────────────────────────
; Syndicate Participation
; ───────────────────────────────────────────────────────────────────────────────
{.participations[]}
syndicate_number = :(4)                           ; Syndicate number
signed_line = #:(0..100)                          ; Signed line percentage
premium_share = #$                                ; Premium share amount

{@lloyds_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
issue_date = date                                 ; Policy issue date
status = (
    bound,
    cancelled,
    expired,
    in_force,
    void
)                                                 ; Alphabetical


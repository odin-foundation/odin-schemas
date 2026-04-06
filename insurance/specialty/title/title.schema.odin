; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Title Insurance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Title insurance protecting real estate buyers and lenders against defects in
; property title including owner's policies, lender's policies, title search,
; and covered defects such as liens, encumbrances, and fraud.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as types
@import "../../common/party.schema.odin" as party

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.specialty.title"
version = "1.0.0"
title = "Title Insurance Schema"
description = "Comprehensive title insurance for real property transactions"

{$derivation}
source[0].authority = "American Land Title Association (ALTA)"
source[0].citation = "ALTA Policy Forms and Endorsements - Public Information"
source[0].url = "https://www.alta.org/policy-forms/"

source[1].authority = "Texas Department of Insurance"
source[1].citation = "Title Insurance Rate Manual and Forms"
source[1].url = "https://www.tdi.texas.gov/title/index.html"

source[2].authority = "California Department of Insurance"
source[2].citation = "Title Insurance Regulations and Consumer Guides"
source[2].url = "https://www.insurance.ca.gov/01-consumers/105-type/95-guides/03-res/Title-Insurance.cfm"

source[3].authority = "NAIC"
source[3].citation = "Title Insurance Issues - Consumer Insights"
source[3].url = "https://content.naic.org/article/consumer-insight-vitals-title-insurance-what-you-need-know"

source[4].authority = "Colorado Division of Property Taxation"
source[4].citation = "Land Identification and Real Property Descriptions"
source[4].url = "https://arl.colorado.gov/chapter-13-land-identification-and-real-property-descriptions"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Title insurance schema derived from public ALTA resources, state insurance department regulations, and real property law principles. No proprietary ISO/NAIC forms were consulted."

changelog[0].date = 2025-12-14
changelog[0].change = "Initial title insurance schema"
changelog[0].rationale = "Specialty line coverage for real property title protection"

; ═══════════════════════════════════════════════════════════════════════════════
; Title Property - Real Property Being Insured
; ═══════════════════════════════════════════════════════════════════════════════
; The subject property with full legal description and physical characteristics.

{@title_property}
; Optional fields (all property details are optional)
address = @address                           ; Property physical address
apn = :                                      ; Assessor's parcel number
country = :(2..3) "US"                       ; ISO 3166 country code
deed_book = :                                ; Deed book number
deed_page = :                                ; Deed page number
id = :                                       ; Unique identifier
instrument_number = :                        ; Recording instrument number
property_id = :                              ; Property identifier
tax_map_number = :                           ; Tax map number
tax_parcel_id = :                            ; Tax parcel identifier

; ───────────────────────────────────────────────────────────────────────────────
; Legal Description
; ───────────────────────────────────────────────────────────────────────────────
; Three primary types: Lot/Block (platted), Metes & Bounds, Rectangular Survey

legal_description_full = :                   ; Full legal description text
legal_description_type = (combination, condominium, lot_and_block, metes_and_bounds, rectangular_survey)  ; Legal description method

; Lot and Block (Platted Subdivision)
{.lot_block}
block_number = :if legal_description_type = lot_and_block  ; Block number in subdivision
filing = :if legal_description_type = lot_and_block  ; Filing number
lot_number = :if legal_description_type = lot_and_block  ; Lot number in subdivision
phase = :if legal_description_type = lot_and_block  ; Development phase
plat_book = :if legal_description_type = lot_and_block  ; Plat book reference
plat_page = :if legal_description_type = lot_and_block  ; Plat page reference
subdivision_name = :if legal_description_type = lot_and_block  ; Subdivision name

; Metes and Bounds
{@title_property}
{.metes_bounds}
point_of_beginning = ::if legal_description_type = metes_and_bounds  ; Starting point for boundary description
bearings_distances = ::if legal_description_type = metes_and_bounds  ; Directional bearings and distances
monuments_references = ::if legal_description_type = metes_and_bounds  ; Physical markers and reference points

; Rectangular Survey System (Government Survey)
{@title_property}
{.rectangular}
township = ::if legal_description_type = rectangular_survey  ; Township designation
range = ::if legal_description_type = rectangular_survey  ; Range designation
section = ##:(1..36):if legal_description_type = rectangular_survey  ; Section number (1-36)
quarter_section = ::if legal_description_type = rectangular_survey  ; Quarter section designation
principal_meridian = ::if legal_description_type = rectangular_survey  ; Principal meridian reference

; Condominium Description
{@title_property}
{.condominium}
unit_number = ::if legal_description_type = condominium  ; Condominium unit number
building = ::if legal_description_type = condominium  ; Building identifier
condominium_name = ::if legal_description_type = condominium  ; Name of condominium complex
declaration_recording = ::if legal_description_type = condominium  ; Recording reference for declaration
common_elements_percentage = #:(0..100):if legal_description_type = condominium  ; Percentage interest in common elements

{@title_property}

; ───────────────────────────────────────────────────────────────────────────────
; Property Identifiers
; ───────────────────────────────────────────────────────────────────────────────
apn = :                                    ; Assessor's Parcel Number
tax_parcel_id = :                          ; Tax Parcel Identification
tax_map_number = :                         ; Tax map reference number
deed_book = :                              ; Deed book number
deed_page = :                              ; Deed page number
instrument_number = :                      ; Recording instrument number

; ───────────────────────────────────────────────────────────────────────────────
; Property Type and Characteristics
; ───────────────────────────────────────────────────────────────────────────────
property_type = (
    commercial,
    condominium,
    cooperative,
    industrial,
    mixed_use,
    multi_family,
    planned_unit_development,
    raw_land,
    single_family,
    townhouse,
    vacant_lot
)

property_use = (
    agricultural,
    commercial,
    industrial,
    investment,
    mixed,
    residential_primary,
    residential_rental,
    residential_secondary
)

; Physical Characteristics
acreage = #:(0..)                          ; Total acreage of property
square_feet = ##:(0..)                     ; Total square footage
frontage_feet = #                          ; Street frontage in feet
depth_feet = #                             ; Property depth in feet
zoning = :                                 ; Zoning classification code
zoning_description = :                     ; Zoning description

; Improvements
{.improvements}
improved = ?                               ; Whether property has improvements
year_built = ##:(1600..2100)               ; Year structure was built
building_type = :                          ; Type of building structure
stories = ##                               ; Number of stories
total_units = ##                           ; Total number of units
gross_building_area = ##:(0..)             ; Total building area in square feet
living_area = ##:(0..)                     ; Habitable living area in square feet

{@title_property}

; ───────────────────────────────────────────────────────────────────────────────
; Survey Information
; ───────────────────────────────────────────────────────────────────────────────
{.survey}
survey_date = date                         ; Date survey was performed
surveyor_name = :                          ; Name of surveyor
surveyor_license = :                       ; Surveyor license number
survey_type = (alta_nsps, boundary, improvement_location, topographic)  ; Type of survey
survey_certified = ?                       ; Whether survey is certified

{@title_property}

; ───────────────────────────────────────────────────────────────────────────────
; Current Ownership
; ───────────────────────────────────────────────────────────────────────────────
vesting_type = (
    community_property,
    community_property_survivorship,
    corporation,
    joint_tenancy,
    life_estate,
    llc,
    partnership,
    sole_ownership,
    tenancy_by_entirety,
    tenancy_in_common,
    trust
)

current_owner_names = :                    ; Names of current property owners
ownership_acquired_date = date             ; Date current ownership was acquired

; ═══════════════════════════════════════════════════════════════════════════════
; Title Search - Examination of Public Records
; ═══════════════════════════════════════════════════════════════════════════════
; Results of the title examination identifying matters affecting title.

{@title_search}
id = :                                     ; Unique identifier
search_id = :                              ; Search identifier
property_ref = @title_property             ; Reference to property

; ───────────────────────────────────────────────────────────────────────────────
; Search Details
; ───────────────────────────────────────────────────────────────────────────────
search_date = date                         ; Date search was performed
search_type = (
    current_owner,
    full,
    limited,
    two_owner,
    update
)                                          ; Type of title search performed
search_period_from = date                  ; Start date of search period
search_period_to = date                    ; End date of search period
examiner_name = :                          ; Name of title examiner
examiner_license = :                       ; Examiner license number

; ───────────────────────────────────────────────────────────────────────────────
; Records Searched
; ───────────────────────────────────────────────────────────────────────────────
{.records_searched}
county_recorder = ?                        ; County recorder's office searched
tax_assessor = ?                           ; Tax assessor records searched
court_records = ?                          ; Court records searched
federal_court = ?                          ; Federal court records searched
bankruptcy = ?                             ; Bankruptcy records searched
ucc_filings = ?                            ; UCC filing records searched
judgment_liens = ?                         ; Judgment lien records searched
tax_liens = ?                              ; Tax lien records searched
municipal_records = ?                      ; Municipal records searched
probate = ?                                ; Probate records searched

{@title_search}

; ───────────────────────────────────────────────────────────────────────────────
; Chain of Title
; ───────────────────────────────────────────────────────────────────────────────
chain_of_title_complete = ?                ; Whether chain of title is complete
chain_years_searched = ##:(0..500)         ; Number of years searched
earliest_record_date = date                ; Date of earliest record found
gaps_in_chain = ?                          ; Whether gaps exist in chain
gap_description = ::if gaps_in_chain = true  ; Description of gaps in chain

; ───────────────────────────────────────────────────────────────────────────────
; Findings Summary
; ───────────────────────────────────────────────────────────────────────────────
{.findings}
liens_found = ##:(0..)                     ; Number of liens found
encumbrances_found = ##:(0..)              ; Number of encumbrances found
easements_found = ##:(0..)                 ; Number of easements found
restrictions_found = ##:(0..)              ; Number of restrictions found
judgments_found = ##:(0..)                 ; Number of judgments found
defects_found = ##:(0..)                   ; Number of title defects found

{@title_search}

; ═══════════════════════════════════════════════════════════════════════════════
; Recorded Document - Documents Found in Title Search
; ═══════════════════════════════════════════════════════════════════════════════

{@title_recorded_document}
id = :                                     ; Unique identifier
document_id = :                            ; Document identifier
search_ref = @title_search                 ; Reference to title search

; Document Recording Information
recording_date = date                      ; Date document was recorded
book = :                                   ; Recording book number
page = :                                   ; Recording page number
instrument_number = :                      ; Instrument number
document_number = :                        ; Document number

; Document Details
document_type = (
    assignment,
    cc_and_r,
    court_order,
    deed,
    deed_of_trust,
    easement,
    judgment,
    lease,
    lien,
    lis_pendens,
    mortgage,
    option,
    partial_release,
    plat,
    power_of_attorney,
    release,
    restriction,
    right_of_way,
    subordination,
    ucc_filing
)                                          ; Type of recorded document

document_date = date                       ; Date of document
grantor = :                                ; Grantor name
grantee = :                                ; Grantee name
consideration = #$:(0..)                   ; Consideration amount
description = :                            ; Document description

; Status
release_date = date:if status = released    ; Release date
release_recording = :if status = released   ; Release recording reference
status = (active, released, satisfied, superseded)  ; Document status

; ═══════════════════════════════════════════════════════════════════════════════
; Title Exception - Matters Excluded from Coverage
; ═══════════════════════════════════════════════════════════════════════════════
; Specific items listed in Schedule B-2 that are excluded from policy coverage.

{@title_exception}
id = :                                     ; Unique identifier
exception_id = :                           ; Exception identifier
exception_number = ##:(1..)                ; Exception number on Schedule B-2

; ───────────────────────────────────────────────────────────────────────────────
; Exception Classification
; ───────────────────────────────────────────────────────────────────────────────
exception_class = (
    special,                                     ; Property-specific
    standard                                     ; Applies to all policies
)

exception_type = (
    boundary_dispute,
    building_setback_violation,
    cc_and_r,
    easement,
    encroachment,
    environmental_lien,
    homeowners_association,
    judgment,
    lease,
    lien_mechanic,
    lien_other,
    lien_tax,
    mineral_rights,
    mortgage,
    other,
    party_in_possession,
    restriction,
    right_of_way,
    survey_exception,
    utility_easement,
    water_rights,
    zoning_violation
)

; ───────────────────────────────────────────────────────────────────────────────
; Exception Details
; ───────────────────────────────────────────────────────────────────────────────
description = :                            ; Description of exception
recording_reference = :                    ; Recording reference for exception
recorded_date = date                       ; Date exception was recorded
affects_entire_property = ?                ; Whether exception affects entire property
affected_portion = ::if affects_entire_property = false  ; Description of affected portion

; ───────────────────────────────────────────────────────────────────────────────
; Exception Status
; ───────────────────────────────────────────────────────────────────────────────
curable = ?                                ; Whether exception can be cured
cure_method = ::if curable = true          ; Method to cure exception
cure_estimated_cost = #$:(0..):if curable = true  ; Estimated cost to cure
cure_deadline = date:if curable = true     ; Deadline to cure exception
cured = ?:if curable = true                ; Whether exception has been cured
cure_date = date:if cured = true           ; Date exception was cured
cure_recording = ::if cured = true         ; Recording reference for cure

; Can exception be insured over?
insurable = ?                              ; Whether exception can be insured over
endorsement_available = ?:if insurable = true  ; Whether endorsement is available
endorsement_type = ::if endorsement_available = true  ; Type of endorsement needed
endorsement_premium = #$:(0..):if endorsement_available = true  ; Premium for endorsement

; ═══════════════════════════════════════════════════════════════════════════════
; Title Requirement - Conditions to be Satisfied Before Closing
; ═══════════════════════════════════════════════════════════════════════════════
; Items listed in Schedule B-1 that must be completed for policy issuance.

{@title_requirement}
id = :                                     ; Unique identifier
requirement_id = :                         ; Requirement identifier
requirement_number = ##:(1..)              ; Requirement number on Schedule B-1

; ───────────────────────────────────────────────────────────────────────────────
; Requirement Type
; ───────────────────────────────────────────────────────────────────────────────
requirement_type = (
    deed_execution,
    deed_recording,
    hoa_clearance,
    judgment_satisfaction,
    lien_release,
    loan_payoff,
    mortgage_payoff,
    other,
    power_of_attorney,
    probate_approval,
    signature,
    survey,
    tax_clearance,
    trust_certification
)

; ───────────────────────────────────────────────────────────────────────────────
; Requirement Details
; ───────────────────────────────────────────────────────────────────────────────
description = :                            ; Description of requirement
responsible_party = :                      ; Party responsible for satisfying requirement
deadline = date                            ; Deadline to satisfy requirement
priority = (critical, high, low, normal)   ; Priority level of requirement

; Payoff Requirements
payoff_required = ?                        ; Whether payoff is required
payoff_payee = ::if payoff_required = true  ; Payee for payoff
payoff_amount = #$:(0..):if payoff_required = true  ; Payoff amount
payoff_per_diem = #$:(0..):if payoff_required = true  ; Daily interest charge
payoff_good_through = date:if payoff_required = true  ; Date payoff is valid through

; ───────────────────────────────────────────────────────────────────────────────
; Requirement Status
; ───────────────────────────────────────────────────────────────────────────────
satisfaction_documentation = :if status = satisfied  ; Documentation of satisfaction
satisfied_by = :if status = satisfied    ; Party who satisfied requirement
satisfied_date = date:if status = satisfied  ; Date requirement satisfied
status = (in_progress, pending, satisfied, waived)  ; Requirement status

; ═══════════════════════════════════════════════════════════════════════════════
; Title Commitment - Preliminary Title Report
; ═══════════════════════════════════════════════════════════════════════════════
; The title company's commitment to issue a policy upon satisfaction of requirements.

{@title_commitment}
id = :                                     ; Unique identifier
commitment_id = :                          ; Commitment identifier
commitment_number = :                      ; Commitment number
order_number = :                           ; Order number

; ───────────────────────────────────────────────────────────────────────────────
; Commitment Dates
; ───────────────────────────────────────────────────────────────────────────────
commitment_date = date                     ; Date commitment was issued
effective_date = date                      ; Effective date of commitment
effective_time = time                      ; Effective time of commitment
expiration_date = date                     ; Expiration date of commitment

; ───────────────────────────────────────────────────────────────────────────────
; Schedule A - Transaction Information
; ───────────────────────────────────────────────────────────────────────────────
{.schedule_a}
property = @title_property                 ; Property being insured

; Proposed Policies
owner_policy_proposed = ?                  ; Whether owner's policy will be issued
owner_policy_amount = #$:(0..):if owner_policy_proposed = true  ; Owner's policy amount
owner_policy_type = (
    alta_homeowner,
    alta_owner,
    standard_owner
):if owner_policy_proposed = true          ; Type of owner's policy

loan_policy_proposed = ?                   ; Whether lender's policy will be issued
loan_policy_amount = #$:(0..):if loan_policy_proposed = true  ; Lender's policy amount
loan_policy_type = (
    alta_loan,
    alta_short_form_loan,
    standard_loan
):if loan_policy_proposed = true           ; Type of lender's policy

; Current Ownership
current_owner = :                          ; Name of current property owner
vesting_deed_date = date                   ; Date of current vesting deed
vesting_deed_recording = :                 ; Recording reference for vesting deed

; Proposed Insured
proposed_owner_insured = ::if owner_policy_proposed = true  ; Proposed owner to be insured
proposed_lender_insured = ::if loan_policy_proposed = true  ; Proposed lender to be insured

; Transaction
transaction_type = (
    construction_loan,
    equity_loan,
    purchase,
    refinance
)                                          ; Type of transaction
purchase_price = #$:(0..):if transaction_type = purchase  ; Purchase price for sale
loan_amount = #$:(0..):if loan_policy_proposed = true  ; Loan amount

{@title_commitment}

; ───────────────────────────────────────────────────────────────────────────────
; Schedule B-1 - Requirements
; ───────────────────────────────────────────────────────────────────────────────
requirements[] = @title_requirement        ; List of requirements to satisfy

; ───────────────────────────────────────────────────────────────────────────────
; Schedule B-2 - Exceptions
; ───────────────────────────────────────────────────────────────────────────────
; Standard Exceptions (apply to all policies unless removed)
{.standard_exceptions}
survey_exception = ?true                   ; Survey exception included
parties_in_possession = ?true              ; Parties in possession exception included
mechanics_liens = ?true                    ; Mechanics liens exception included
taxes_not_yet_due = ?true                  ; Taxes not yet due exception included
special_assessments = ?true                ; Special assessments exception included
unrecorded_easements = ?true               ; Unrecorded easements exception included
water_rights = ?true                       ; Water rights exception included
mineral_rights = ?true                     ; Mineral rights exception included

{@title_commitment}
exceptions[] = @title_exception            ; List of exceptions to coverage

; ───────────────────────────────────────────────────────────────────────────────
; Underwriter and Agent
; ───────────────────────────────────────────────────────────────────────────────
agent_address = @address         ; Agent mailing address
agent_license = :                ; Agent license number
agent_name = :                   ; Agent company name
agent_phones[] = *@phone         ; Agent contact phones (confidential)
underwriter_naic = :(5..6)       ; NAIC company code
underwriter_name = :             ; Underwriter company name

; ───────────────────────────────────────────────────────────────────────────────
; Authorized Signature
; ───────────────────────────────────────────────────────────────────────────────
authorized_signatory = :                   ; Name of authorized signatory
signatory_title = :                        ; Title of signatory

; ═══════════════════════════════════════════════════════════════════════════════
; Title Endorsement - ALTA Endorsements for Additional Coverage
; ═══════════════════════════════════════════════════════════════════════════════
; Standard ALTA endorsements that extend or modify policy coverage.

{@title_endorsement}
id = :                                     ; Unique identifier

; ───────────────────────────────────────────────────────────────────────────────
; Endorsement Identification
; ───────────────────────────────────────────────────────────────────────────────
endorsement_form = (
    ; Street/Assessment
    alta_1_street_assessments,
    ; Zoning
    alta_3_zoning,
    alta_3_1_zoning_completed_structure,
    alta_3_2_zoning_land_under_development,
    ; Condominium
    alta_4_condominium,
    alta_4_1_condominium_assessments,
    ; PUD
    alta_5_pud,
    alta_5_1_pud_assessments,
    ; Variable Rate
    alta_6_variable_rate_mortgage,
    alta_6_2_variable_rate_mortgage_negative_amort,
    ; Environmental
    alta_8_1_environmental_protection_lien,
    alta_8_2_environmental_protection_lien_commercial,
    ; Restrictions
    alta_9_restrictions,
    alta_9_1_restrictions_covenants,
    alta_9_2_restrictions_private_rights,
    alta_9_3_restrictions_encroachments,
    alta_9_6_restrictions_encroachments_minerals,
    alta_9_7_restrictions_encroachments_minerals_improved,
    alta_9_10_restrictions_minerals,
    ; Mortgage Modification
    alta_10_mortgage_modification,
    alta_10_1_mortgage_modification_additional,
    alta_11_mortgage_modification_subordination,
    ; Aggregation
    alta_12_aggregation_mortgage,
    ; Leasehold
    alta_13_leasehold_owner,
    alta_13_1_leasehold_loan,
    ; Future Advance
    alta_14_future_advance_priority,
    alta_14_1_future_advance_knowledge,
    alta_14_2_future_advance_letter_of_credit,
    alta_14_3_future_advance_reverse_mortgage,
    ; Nonimputation
    alta_15_nonimputation_full_equity,
    alta_15_1_nonimputation_additional,
    alta_15_2_nonimputation_partial_equity,
    ; Mezzanine Financing
    alta_16_mezzanine_financing,
    ; Access and Entry
    alta_17_access_and_entry,
    alta_17_1_access_and_entry_indirect,
    alta_17_2_access_and_entry_utilities,
    ; Single Tax Parcel
    alta_18_single_tax_parcel,
    alta_18_1_single_tax_parcel_multiple,
    ; Contiguity
    alta_19_contiguity_multiple_parcels,
    alta_19_1_contiguity_single_parcel,
    ; First Loss
    alta_20_first_loss_mortgage,
    ; Creditors Rights
    alta_21_creditors_rights,
    ; Location
    alta_22_location,
    ; Co-Insurance
    alta_23_coinsurance_single_policy,
    alta_23_1_coinsurance_multiple_policies,
    ; Doing Business
    alta_24_doing_business,
    ; Same as Survey
    alta_25_same_as_survey,
    alta_25_1_same_as_survey_descriptions,
    ; Subdivision
    alta_26_subdivision,
    ; Usury
    alta_27_usury,
    ; Easement
    alta_28_easement_damage_or_enforced_removal,
    alta_28_1_easement_encroachment,
    alta_28_2_easement_use_and_maintenance,
    alta_28_3_easement_encroachment_mineral_owner,
    ; Interest Rate Swap
    alta_29_interest_rate_swap,
    alta_29_1_interest_rate_swap_direct,
    alta_29_2_interest_rate_swap_additional,
    alta_29_3_interest_rate_swap_direct_additional,
    ; Shared Appreciation
    alta_30_shared_appreciation,
    ; Severable Improvements
    alta_31_severable_improvements,
    ; Construction Loan
    alta_32_construction_loan,
    alta_32_1_construction_loan_direct_payment,
    alta_32_2_construction_loan_lender_obligated,
    ; Disbursement
    alta_33_disbursement,
    ; Identified Exception
    alta_34_identified_risk_coverage,
    ; Mineral Rights
    alta_35_mineral_and_other_subsurface,
    alta_35_1_mineral_and_other_subsurface_improvements,
    alta_35_2_mineral_and_other_subsurface_described,
    alta_35_3_mineral_and_other_subsurface_described_improvements,
    ; Energy Project
    alta_36_energy_project_covenants,
    alta_36_1_energy_project_leasehold,
    alta_36_2_energy_project_fee,
    alta_36_3_energy_project_covenants_land_under_development,
    alta_36_4_energy_project_leasehold_land_under_development,
    alta_36_5_energy_project_fee_land_under_development,
    alta_36_6_energy_project_encroachments,
    ; Utility Access
    alta_37_assignment_of_rents,
    ; Mortgage Tax
    alta_38_mortgage_tax,
    ; Policy Authentication
    alta_39_policy_authentication,
    ; Tax Credit
    alta_40_tax_credit_defined_amount,
    alta_40_1_tax_credit_full_amount,
    ; Water
    alta_41_water_buildings,
    alta_41_1_water_improvements,
    alta_41_2_water_described_improvements,
    alta_41_3_water_no_improvements,
    ; Commercial
    alta_42_commercial_lender_group,
    ; Anti_taint
    alta_43_anti_taint,
    ; Insured Mortgage Recording
    alta_44_insured_mortgage_recording,
    ; Pari Passu Mortgage
    alta_45_pari_passu_mortgage,
    alta_45_1_pari_passu_mortgage_junior,
    ; Option
    alta_46_option,
    ; State specific or other
    other
)                                          ; ALTA endorsement form number

endorsement_code = :                       ; Endorsement code
endorsement_name = :                       ; Endorsement name
endorsement_edition = :                    ; Endorsement edition/version

; ───────────────────────────────────────────────────────────────────────────────
; Endorsement Details
; ───────────────────────────────────────────────────────────────────────────────
description = :                            ; Description of endorsement coverage
applies_to = (both, lender, owner)         ; Which policy endorsement applies to
effective_date = date                      ; Effective date of endorsement

; Schedule/Exhibit Attachments
schedule_attached = ?                      ; Whether schedule is attached
schedule_description = ::if schedule_attached = true  ; Description of attached schedule

; ───────────────────────────────────────────────────────────────────────────────
; Endorsement Premium
; ───────────────────────────────────────────────────────────────────────────────
premium = #$:(0..)                         ; Endorsement premium amount
premium_basis = (flat, percentage, per_thousand)  ; Basis for premium calculation
percentage_rate = #:(0..100):if premium_basis = percentage  ; Percentage rate if applicable
per_thousand_rate = #$:(0..):if premium_basis = per_thousand  ; Per thousand rate if applicable

; ═══════════════════════════════════════════════════════════════════════════════
; Title Owner Policy - Protects Buyer/Owner
; ═══════════════════════════════════════════════════════════════════════════════
; Owner's title insurance protecting the purchaser's interest in the property.
; Coverage is for the purchase price and lasts as long as owner (or heirs) has interest.

{@title_owner_policy}
id = :                                     ; Unique identifier
number = :                                 ; Policy number
file_number = :                            ; File number
order_number = :                           ; Order number

; ───────────────────────────────────────────────────────────────────────────────
; Policy Dates
; ───────────────────────────────────────────────────────────────────────────────
policy_date = date                         ; Date policy was issued
policy_time = time                         ; Time policy was issued
effective_date = date                      ; Effective date of coverage
effective_time = time                      ; Effective time of coverage

; Title insurance has perpetual coverage (no expiration)
; Coverage terminates only when owner no longer has interest

; ───────────────────────────────────────────────────────────────────────────────
; Policy Type
; ───────────────────────────────────────────────────────────────────────────────
form = (
    alta_homeowner,
    alta_owner,
    alta_residential_owner,
    extended_coverage,
    standard_coverage
)

property_type_covered = (
    commercial,
    condominium,
    mixed_use,
    multi_family,
    pud,
    raw_land,
    residential_1_4
)

; ───────────────────────────────────────────────────────────────────────────────
; Insured Party
; ───────────────────────────────────────────────────────────────────────────────
insured_name = :                           ; Name of insured party
insured_type = (corporation, individual, llc, married_couple, partnership, trust)  ; Type of insured entity
insured_address = @address                 ; Address of insured party

; Successor Insureds (coverage extends to heirs/successors)
successor_coverage = ?true                 ; Whether coverage extends to successors

; ───────────────────────────────────────────────────────────────────────────────
; Property Covered
; ───────────────────────────────────────────────────────────────────────────────
property = @title_property                 ; Property covered by policy

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Amount and Premium
; ───────────────────────────────────────────────────────────────────────────────
; Owner's policy amount equals purchase price
amount = #$:(0..)                          ; Policy coverage amount
purchase_price = #$:(0..)                  ; Purchase price of property
:invariant amount >= purchase_price * 0.9  ; Amount must be at least 90% of purchase price

; One-time premium (title insurance unique feature)
{.premium}
base_premium = #$:(0..)                    ; Base policy premium
endorsement_premium = #$:(0..)             ; Premium for endorsements
total_premium = #$:(0..)                   ; Total premium amount
:invariant total_premium = base_premium + endorsement_premium  ; Total equals base plus endorsements

{@title_owner_policy}

; Premium calculation basis
rate_type = (basic, refinance, reissue, simultaneous)  ; Type of rate used
reissue_credit = #$:(0..):if rate_type = reissue  ; Credit for reissue
simultaneous_discount = #$:(0..):if rate_type = simultaneous  ; Discount for simultaneous issue

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Type
; ───────────────────────────────────────────────────────────────────────────────
coverage_type = (extended, standard)       ; Type of coverage provided

; Standard Coverage (protects against defects in public records)
{.standard_coverage}
record_defects = ?true                     ; Covers defects in public records
liens = ?true                              ; Covers liens against property
encumbrances = ?true                       ; Covers encumbrances
lack_of_access = ?true                     ; Covers lack of legal access
unmarketable_title = ?true                 ; Covers unmarketable title
document_defects = ?true                   ; Covers document defects

{@title_owner_policy}

; Extended/Homeowner Coverage (additional protections)
{.extended_coverage}
unrecorded_liens = ?:if coverage_type = extended  ; Covers unrecorded liens
encroachments = ?:if coverage_type = extended  ; Covers encroachments
easements_not_shown = ?:if coverage_type = extended  ; Covers easements not in public records
parties_in_possession = ?:if coverage_type = extended  ; Covers rights of parties in possession
survey_matters = ?:if coverage_type = extended  ; Covers survey matters
post_policy_forgery = ?:if coverage_type = extended  ; Covers post-policy forgery
zoning_violations = ?:if coverage_type = extended  ; Covers zoning violations
subdivision_violations = ?:if coverage_type = extended  ; Covers subdivision violations
building_permit_violations = ?:if coverage_type = extended  ; Covers building permit violations
covenant_violations = ?:if coverage_type = extended  ; Covers covenant violations
living_area_incorrect = ?:if coverage_type = extended  ; Covers incorrect living area

{@title_owner_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Exceptions from Coverage
; ───────────────────────────────────────────────────────────────────────────────
exceptions[] = @title_exception            ; List of exceptions to coverage

; ───────────────────────────────────────────────────────────────────────────────
; Endorsements
; ───────────────────────────────────────────────────────────────────────────────
endorsements[] = @title_endorsement        ; List of endorsements to policy

; ───────────────────────────────────────────────────────────────────────────────
; Underwriter
; ───────────────────────────────────────────────────────────────────────────────
underwriter_name = :                       ; Underwriter company name
underwriter_address = @address             ; Underwriter mailing address
underwriter_naic = :(5..6)                 ; NAIC company code

; ───────────────────────────────────────────────────────────────────────────────
; Issuing Agent
; ───────────────────────────────────────────────────────────────────────────────
agent_address = @address                     ; Agent mailing address
agent_emails[] = *@email         ; Agent contact emails (confidential)
agent_license = :                ; Agent license number
agent_name = :                   ; Agent company name
agent_phones[] = *@phone         ; Agent contact phones (confidential)

; ───────────────────────────────────────────────────────────────────────────────
; Policy Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, claim_filed, claim_paid, transferred)  ; Current status of policy
transfer_date = date:if status = transferred  ; Date policy was transferred
transferee_name = ::if status = transferred  ; Name of transferee

; ═══════════════════════════════════════════════════════════════════════════════
; Title Lender Policy - Protects Mortgagee/Lender
; ═══════════════════════════════════════════════════════════════════════════════
; Loan policy protecting the mortgage lender's security interest.
; Coverage amount decreases as loan is paid down; terminates when loan is paid off.

{@title_lender_policy}
id = :                                     ; Unique identifier
number = :                                 ; Policy number
file_number = :                            ; File number
order_number = :                           ; Order number

; ───────────────────────────────────────────────────────────────────────────────
; Policy Dates
; ───────────────────────────────────────────────────────────────────────────────
policy_date = date                         ; Date policy was issued
policy_time = time                         ; Time policy was issued
effective_date = date                      ; Effective date of coverage
effective_time = time                      ; Effective time of coverage

; Lender policy terminates when loan is paid off
loan_payoff_date = date                    ; Date loan was paid off

; ───────────────────────────────────────────────────────────────────────────────
; Policy Type
; ───────────────────────────────────────────────────────────────────────────────
form = (
    alta_construction_loan,
    alta_loan,
    alta_short_form_loan,
    standard_loan
)

property_type_covered = (
    commercial,
    condominium,
    mixed_use,
    multi_family,
    pud,
    raw_land,
    residential_1_4
)

; ───────────────────────────────────────────────────────────────────────────────
; Insured Lender
; ───────────────────────────────────────────────────────────────────────────────
insured_lender_name = :                    ; Name of insured lender
insured_lender_address = @address          ; Address of insured lender
insured_lender_successors = ?true          ; Whether coverage extends to successors

; MERS Registration (if applicable)
mers_registered = ?                        ; Whether loan is MERS registered
mers_min = :(18):if mers_registered = true  ; MERS Mortgage Identification Number

; ───────────────────────────────────────────────────────────────────────────────
; Loan Information
; ───────────────────────────────────────────────────────────────────────────────
{.loan}
loan_number = *:                           ; Loan number (confidential)
loan_amount = #$:(0..)                     ; Loan amount
loan_date = date                           ; Date of loan
loan_type = (
    construction,
    conventional,
    fha,
    heloc,
    reverse_mortgage,
    usda,
    va
)                                          ; Type of loan
interest_rate_type = (adjustable, fixed, variable)  ; Interest rate type
loan_term_months = ##:(0..600)             ; Loan term in months
maturity_date = date                       ; Loan maturity date

; For construction loans
construction_loan = ?                      ; Whether this is a construction loan
max_disbursement = #$:(0..):if construction_loan = true  ; Maximum disbursement amount

{@title_lender_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Security Instrument
; ───────────────────────────────────────────────────────────────────────────────
security_type = (deed_of_trust, mortgage, security_deed)  ; Type of security instrument
security_date = date                       ; Date of security instrument
security_recording_date = date             ; Date security instrument was recorded
security_book = :                          ; Recording book number
security_page = :                          ; Recording page number
security_instrument_number = :             ; Recording instrument number

; Priority
lien_position = (first, junior, second, third)  ; Position of lien priority

; ───────────────────────────────────────────────────────────────────────────────
; Borrower Information
; ───────────────────────────────────────────────────────────────────────────────
borrower_name = :                          ; Name of borrower
borrower_address = @address                ; Address of borrower
co_borrower_name = :                       ; Name of co-borrower

; ───────────────────────────────────────────────────────────────────────────────
; Property Covered
; ───────────────────────────────────────────────────────────────────────────────
property = @title_property                 ; Property covered by policy

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Amount and Premium
; ───────────────────────────────────────────────────────────────────────────────
; Lender's policy amount equals loan amount (decreases over time)
amount = #$:(0..)                          ; Policy coverage amount

{.premium}
base_premium = #$:(0..)                    ; Base policy premium
endorsement_premium = #$:(0..)             ; Premium for endorsements
total_premium = #$:(0..)                   ; Total premium amount
:invariant total_premium = base_premium + endorsement_premium  ; Total equals base plus endorsements

{@title_lender_policy}

; Simultaneous issue with owner's policy
simultaneous_issue = ?                     ; Whether issued simultaneously with owner's policy
simultaneous_discount = #$:(0..):if simultaneous_issue = true  ; Discount for simultaneous issue
owner_policy_ref = @title_owner_policy:if simultaneous_issue = true  ; Reference to owner's policy

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Provisions
; ───────────────────────────────────────────────────────────────────────────────
{.coverage}
; Standard loan policy coverage
valid_lien = ?true                         ; Covers validity of lien
priority_of_lien = ?true                   ; Covers priority of lien
lien_enforceability = ?true                ; Covers enforceability of lien
title_vested_in_borrower = ?true           ; Covers title vested in borrower
access_to_property = ?true                 ; Covers access to property
; Future advance coverage (for HELOCs, construction)
future_advances = ?                        ; Whether future advances are covered
future_advance_limit = #$:(0..):if future_advances = true  ; Maximum future advance amount

{@title_lender_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Exceptions from Coverage
; ───────────────────────────────────────────────────────────────────────────────
exceptions[] = @title_exception            ; List of exceptions to coverage

; ───────────────────────────────────────────────────────────────────────────────
; Endorsements
; ───────────────────────────────────────────────────────────────────────────────
endorsements[] = @title_endorsement        ; List of endorsements to policy

; ───────────────────────────────────────────────────────────────────────────────
; Underwriter and Agent
; ───────────────────────────────────────────────────────────────────────────────
underwriter_name = :                       ; Underwriter company name
underwriter_address = @address             ; Underwriter mailing address
underwriter_naic = :(5..6)                 ; NAIC company code

agent_name = :                             ; Agent company name
agent_license = :                          ; Agent license number
agent_address = @address                   ; Agent mailing address

; ───────────────────────────────────────────────────────────────────────────────
; Policy Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, assigned, claim_filed, claim_paid, terminated)  ; Current status of policy
termination_reason = (assumption, foreclosure, loan_paid_off):if status = terminated  ; Reason for termination
termination_date = date:if status = terminated  ; Date policy was terminated
assignment_date = date:if status = assigned  ; Date policy was assigned
assignee_name = ::if status = assigned     ; Name of assignee

; ═══════════════════════════════════════════════════════════════════════════════
; Title Claim - Claim for Title Defect
; ═══════════════════════════════════════════════════════════════════════════════
; Claims made under title policies for covered title defects.

{@title_claim}
id = :                                     ; Unique identifier
number = :                                 ; Claim number

; ───────────────────────────────────────────────────────────────────────────────
; Claim Filing
; ───────────────────────────────────────────────────────────────────────────────
contact_emails[] = *@email       ; Contact email addresses (confidential)
contact_name = :                 ; Primary contact name
contact_phones[] = *@phone       ; Contact phone numbers (confidential)
filing_date = date                           ; Date claim filed
reported_by = :                              ; Party reporting the claim
reported_date = date                         ; Date defect reported

; ───────────────────────────────────────────────────────────────────────────────
; Policy Reference
; ───────────────────────────────────────────────────────────────────────────────
type = (lender, owner)                     ; Type of policy claim is under
owner_policy_ref = @title_owner_policy:if type = owner  ; Reference to owner's policy
lender_policy_ref = @title_lender_policy:if type = lender  ; Reference to lender's policy
policy_number = :                          ; Policy number
policy_amount = #$:(0..)                   ; Policy coverage amount

; ───────────────────────────────────────────────────────────────────────────────
; Claim Details
; ───────────────────────────────────────────────────────────────────────────────
claim_type = (
    boundary_dispute,
    chain_of_title_break,
    easement_interference,
    encroachment,
    estate_claim,
    forgery_fraud,
    heir_claim,
    judgment_lien,
    lack_of_access,
    lien_not_satisfied,
    mechanic_lien,
    missing_heir,
    mortgage_not_released,
    other,
    prior_conveyance,
    restriction_violation,
    survey_error,
    tax_lien,
    unmarketable_title
)                                          ; Type of claim

description = :                            ; Description of claim
date_defect_discovered = date              ; Date defect was discovered
date_defect_originated = date              ; Date defect originated

; ───────────────────────────────────────────────────────────────────────────────
; Claimant Information
; ───────────────────────────────────────────────────────────────────────────────
claimant_name = :                          ; Name of claimant
claimant_relationship = (heir, insured, lender, successor)  ; Relationship to policy
claimant_address = @address                ; Address of claimant

; Adverse Party (party claiming against insured)
adverse_party_name = :                     ; Name of adverse party
adverse_party_claim = :                    ; Description of adverse party's claim
adverse_party_counsel = :                  ; Adverse party's legal counsel

; ───────────────────────────────────────────────────────────────────────────────
; Claim Amounts
; ───────────────────────────────────────────────────────────────────────────────
{.amounts}
amount = #$:(0..)                          ; Claimed amount
defense_costs = #$:(0..)                   ; Legal defense costs
settlement_reserve = #$:(0..)              ; Amount reserved for settlement
total_incurred = #$:(0..)                  ; Total incurred expenses
total_paid = #$:(0..)                      ; Total amount paid

{@title_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Claim Status
; ───────────────────────────────────────────────────────────────────────────────
status = (
    acknowledged,
    closed_no_payment,
    closed_paid,
    denied,
    investigating,
    litigating,
    negotiating,
    reported,
    settled
)                                          ; Current status of claim

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Determination
; ───────────────────────────────────────────────────────────────────────────────
coverage_determination = (covered, denied, partial)  ; Coverage determination
coverage_determination_date = date         ; Date coverage was determined
coverage_letter_date = date                ; Date coverage letter was sent
denial_reason = ::if coverage_determination = denied  ; Reason for denial
covered_amount = #$:(0..):if coverage_determination = covered  ; Amount covered
uncovered_amount = #$:(0..):if coverage_determination = partial  ; Amount not covered

; ───────────────────────────────────────────────────────────────────────────────
; Claim Resolution
; ───────────────────────────────────────────────────────────────────────────────
resolution_type = (
    claim_withdrawn,
    curative_action,
    defense_successful,
    indemnity_payment,
    litigation_judgment,
    negotiated_settlement
)                                          ; Type of resolution

resolution_date = date                     ; Date claim was resolved
resolution_description = :                 ; Description of resolution

; Curative Action (title company fixes the defect)
{.curative_action}
action_type = (
    document_obtained,
    lien_paid,
    quiet_title,
    release_obtained
):if resolution_type = curative_action     ; Type of curative action
action_date = date:if resolution_type = curative_action  ; Date action was completed
action_cost = #$:(0..):if resolution_type = curative_action  ; Cost of curative action

{@title_claim}

; Indemnity Payment (title company pays loss)
{.payment}
payment_date = date                        ; Date of payment
payment_amount = #$:(0..)                  ; Payment amount
payment_type = (combined, defense_costs, loss)  ; Type of payment
payee_name = :                             ; Name of payee
subrogation_rights = ?                     ; Whether subrogation rights exist

{@title_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Litigation
; ───────────────────────────────────────────────────────────────────────────────
litigation_pending = ?                     ; Whether litigation is pending

{.litigation}
case_number = :if litigation_pending = true  ; Court case number
court = :if litigation_pending = true      ; Court name
filed_date = date:if litigation_pending = true  ; Date case was filed
defense_counsel = :if litigation_pending = true  ; Name of defense counsel
plaintiff = :if litigation_pending = true  ; Name of plaintiff
defendant = :if litigation_pending = true  ; Name of defendant

{@title_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Claim Handling
; ───────────────────────────────────────────────────────────────────────────────
examiner = :                               ; Claim examiner name
adjuster = :                               ; Claim adjuster name
assigned_date = date                       ; Date claim was assigned
last_activity_date = date                  ; Date of last activity

; ═══════════════════════════════════════════════════════════════════════════════
; Escrow/Closing Information
; ═══════════════════════════════════════════════════════════════════════════════
; Integration with the real estate closing process.

{@title_closing}
id = :                                     ; Unique identifier
closing_id = :                             ; Closing identifier
escrow_number = :                          ; Escrow number
file_number = :                            ; File number

; ───────────────────────────────────────────────────────────────────────────────
; Closing Details
; ───────────────────────────────────────────────────────────────────────────────
scheduled_closing_date = date              ; Scheduled closing date
actual_closing_date = date                 ; Actual closing date
closing_type = (escrow, mail_away, table_closing)  ; Type of closing

; ───────────────────────────────────────────────────────────────────────────────
; Transaction Parties
; ───────────────────────────────────────────────────────────────────────────────
seller_name = :                            ; Name of seller
seller_address = @address                  ; Address of seller
buyer_name = :                             ; Name of buyer
buyer_address = @address                   ; Address of buyer
lender_name = :                            ; Name of lender
lender_address = @address                  ; Address of lender

; ───────────────────────────────────────────────────────────────────────────────
; Property
; ───────────────────────────────────────────────────────────────────────────────
property = @title_property                 ; Property being closed

; ───────────────────────────────────────────────────────────────────────────────
; Financial Summary
; ───────────────────────────────────────────────────────────────────────────────
{.financials}
purchase_price = #$:(0..)                  ; Purchase price
loan_amount = #$:(0..)                     ; Loan amount
earnest_money = #$:(0..)                   ; Earnest money deposit
down_payment = #$:(0..)                    ; Down payment amount
seller_credits = #$:(0..)                  ; Credits from seller
closing_costs_buyer = #$:(0..)             ; Buyer's closing costs
closing_costs_seller = #$:(0..)            ; Seller's closing costs

{@title_closing}

; ───────────────────────────────────────────────────────────────────────────────
; Title Charges
; ───────────────────────────────────────────────────────────────────────────────
{.title_charges}
title_search_fee = #$:(0..)                ; Fee for title search
title_examination_fee = #$:(0..)           ; Fee for title examination
title_insurance_premium = #$:(0..)         ; Title insurance premium
endorsement_fees = #$:(0..)                ; Fees for endorsements
closing_fee = #$:(0..)                     ; Closing/settlement fee
document_preparation = #$:(0..)            ; Document preparation fee
recording_fees = #$:(0..)                  ; Recording fees
wire_transfer_fee = #$:(0..)               ; Wire transfer fee
notary_fees = #$:(0..)                     ; Notary fees

{@title_closing}

; ───────────────────────────────────────────────────────────────────────────────
; Policies Issued
; ───────────────────────────────────────────────────────────────────────────────
owner_policy = @title_owner_policy         ; Owner's policy issued
lender_policy = @title_lender_policy       ; Lender's policy issued

; ───────────────────────────────────────────────────────────────────────────────
; Recording Information
; ───────────────────────────────────────────────────────────────────────────────
{.recording}
deed_recorded_date = date                  ; Date deed was recorded
deed_book = :                              ; Deed recording book number
deed_page = :                              ; Deed recording page number
deed_instrument = :                        ; Deed instrument number
mortgage_recorded_date = date              ; Date mortgage was recorded
mortgage_book = :                          ; Mortgage recording book number
mortgage_page = :                          ; Mortgage recording page number
mortgage_instrument = :                    ; Mortgage instrument number

{@title_closing}

; ───────────────────────────────────────────────────────────────────────────────
; Escrow Agent
; ───────────────────────────────────────────────────────────────────────────────
escrow_address = @address        ; Escrow company address
escrow_agent = :                 ; Escrow agent company name
escrow_officer = :               ; Escrow officer name
escrow_phones[] = *@phone        ; Escrow contact phones (confidential)

; ───────────────────────────────────────────────────────────────────────────────
; Closing Status
; ───────────────────────────────────────────────────────────────────────────────
status = (cancelled, closed, funded, pending, scheduled)  ; Status of closing
cancellation_reason = ::if status = cancelled  ; Reason for cancellation
funding_date = date:if status = funded     ; Date funds were released
disbursement_date = date                   ; Date funds were disbursed

; ═══════════════════════════════════════════════════════════════════════════════
; Title Policy - Combined Structure (Transaction Level)
; ═══════════════════════════════════════════════════════════════════════════════
; Master structure for a title insurance transaction containing all components.

{@title_policy}
id = :                                     ; Unique identifier
transaction_id = :                         ; Transaction identifier
file_number = :                            ; File number

; ───────────────────────────────────────────────────────────────────────────────
; Property
; ───────────────────────────────────────────────────────────────────────────────
property = @title_property                 ; Property being insured

; ───────────────────────────────────────────────────────────────────────────────
; Title Search and Commitment
; ───────────────────────────────────────────────────────────────────────────────
search = @title_search                     ; Title search results
commitment = @title_commitment             ; Title commitment

; ───────────────────────────────────────────────────────────────────────────────
; Recorded Documents
; ───────────────────────────────────────────────────────────────────────────────
recorded_documents[] = @title_recorded_document  ; List of recorded documents

; ───────────────────────────────────────────────────────────────────────────────
; Policies
; ───────────────────────────────────────────────────────────────────────────────
owner_policy = @title_owner_policy         ; Owner's policy
lender_policy = @title_lender_policy       ; Lender's policy

; ───────────────────────────────────────────────────────────────────────────────
; Closing
; ───────────────────────────────────────────────────────────────────────────────
closing = @title_closing                   ; Closing information

; ───────────────────────────────────────────────────────────────────────────────
; Claims
; ───────────────────────────────────────────────────────────────────────────────
claims[] = @title_claim                    ; List of claims

; ───────────────────────────────────────────────────────────────────────────────
; Premium Summary
; ───────────────────────────────────────────────────────────────────────────────
{.premium_summary}
owner_policy_premium = #$:(0..)            ; Owner's policy premium
lender_policy_premium = #$:(0..)           ; Lender's policy premium
endorsement_premium_total = #$:(0..)       ; Total endorsement premiums
total_title_premium = #$:(0..)             ; Total title insurance premium
:invariant total_title_premium = owner_policy_premium + lender_policy_premium + endorsement_premium_total  ; Total equals sum of all premiums

{@title_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Transaction Status
; ───────────────────────────────────────────────────────────────────────────────
status = (
    cancelled,
    claim_active,
    closed,
    commitment_issued,
    in_process,
    ordered,
    policy_issued
)                                          ; Current status of transaction

order_date = date                          ; Date transaction was ordered
commitment_date = date                     ; Date commitment was issued
closing_date = date                        ; Date of closing
policy_issue_date = date                   ; Date policy was issued


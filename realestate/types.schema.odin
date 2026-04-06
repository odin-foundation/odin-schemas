; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Real Estate Common Types
; ═══════════════════════════════════════════════════════════════════════════════
; Reusable type definitions shared across real estate schemas. Includes legal
; descriptions, parcel identifiers, property characteristics, zoning, flood
; zones, ownership/vesting, tax information, utilities, encumbrances,
; condition reports, and property status tracking.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as common
@import "../insurance/common/party.schema.odin" as party
@import "../mortgage/types.schema.odin" as mtg

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.realestate.types"
version = "1.0.0"
title = "Real Estate Common Types"
description = "Reusable type definitions for real estate transactions"

{$derivation}
source[0].authority = "American Land Title Association (ALTA)"
source[0].citation = "Title Insurance and Settlement Company Best Practices"
source[0].url = "https://www.alta.org/best-practices/"

source[1].authority = "National Association of Realtors"
source[1].citation = "Real Estate Transaction Standards"
source[1].url = "https://www.nar.realtor/"

source[2].authority = "Appraisal Foundation"
source[2].citation = "Uniform Standards of Professional Appraisal Practice (USPAP)"
source[2].url = "https://www.appraisalfoundation.org/imis/TAF/Standards/Appraisal_Standards/Uniform_Standards_of_Professional_Appraisal_Practice/TAF/USPAP.aspx"

source[3].authority = "CFPB"
source[3].citation = "TILA-RESPA Integrated Disclosure Rule"
source[3].url = "https://www.consumerfinance.gov/rules-policy/regulations/1026/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Common types derived from public regulatory standards and industry practices"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial real estate common types schema"
changelog[0].rationale = "Base types for real estate transaction processing"

; ═══════════════════════════════════════════════════════════════════════════════
; LEGAL DESCRIPTION
; ═══════════════════════════════════════════════════════════════════════════════
; Three primary types: Lot/Block (platted), Metes & Bounds, Rectangular Survey
; Per state recording statutes and ALTA requirements

{@re_legal_description}
; Required fields first
full_description = !:                             ; Complete legal description text
type = !(combination, condominium, lot_and_block, metes_and_bounds, rectangular_survey)

; ───────────────────────────────────────────────────────────────────────────────
; Lot and Block (Platted Subdivision)
; ───────────────────────────────────────────────────────────────────────────────
{.lot_block}
block = ::if type = lot_and_block                 ; Block number in subdivision
filing = ::if type = lot_and_block                ; Filing or recording number
lot = ::if type = lot_and_block                   ; Lot number in subdivision
phase = ::if type = lot_and_block                 ; Development phase
plat_book = ::if type = lot_and_block             ; Plat book reference
plat_page = ::if type = lot_and_block             ; Plat page reference
subdivision = ::if type = lot_and_block           ; Subdivision name
unit = ::if type = lot_and_block                  ; Unit number (for condos in subdivision)

{@re_legal_description}

; ───────────────────────────────────────────────────────────────────────────────
; Metes and Bounds
; ───────────────────────────────────────────────────────────────────────────────
{.metes_bounds}
bearings_distances = ::if type = metes_and_bounds ; Bearing and distance calls
monuments = ::if type = metes_and_bounds          ; Monument references
point_of_beginning = ::if type = metes_and_bounds ; Starting point description

{@re_legal_description}

; ───────────────────────────────────────────────────────────────────────────────
; Rectangular Survey (Government Survey)
; ───────────────────────────────────────────────────────────────────────────────
{.rectangular}
principal_meridian = ::if type = rectangular_survey  ; Principal meridian name
quarter_section = ::if type = rectangular_survey     ; Quarter section (NE, NW, SE, SW)
range = ::if type = rectangular_survey               ; Range number (E or W)
section = ##:(1..36):if type = rectangular_survey    ; Section number (1-36)
township = ::if type = rectangular_survey            ; Township number (N or S)

{@re_legal_description}

; ───────────────────────────────────────────────────────────────────────────────
; Condominium Description
; ───────────────────────────────────────────────────────────────────────────────
{.condominium}
building = ::if type = condominium                ; Building identifier
common_elements_percentage = #:(0..100):if type = condominium  ; Common element share
condominium_name = ::if type = condominium        ; Condominium project name
declaration_recording = ::if type = condominium   ; Declaration recording reference
floor = ##:(0..):if type = condominium            ; Floor number
parking_spaces[] = ::if type = condominium        ; Assigned parking space numbers
storage_units[] = ::if type = condominium         ; Assigned storage unit numbers
unit = ::if type = condominium                    ; Unit number

{@re_legal_description}

; ═══════════════════════════════════════════════════════════════════════════════
; PARCEL IDENTIFIERS
; ═══════════════════════════════════════════════════════════════════════════════
; Tax and recording identifiers for property

{@re_parcel_identifiers}
; Primary identifier
apn = :                                           ; Assessor's Parcel Number
tax_parcel_id = :                                 ; Tax parcel identification

; Recording references
deed_book = :                                     ; Deed book number
deed_page = :                                     ; Deed page number
instrument_number = :                             ; Recording instrument number

; Other identifiers
geo_id = :                                        ; Geographic identifier
map_number = :                                    ; Tax map number
parcel_sequence = :                               ; Parcel sequence number
plat_reference = :                                ; Plat recording reference

; ═══════════════════════════════════════════════════════════════════════════════
; PROPERTY CHARACTERISTICS
; ═══════════════════════════════════════════════════════════════════════════════
; Physical characteristics common to all property types

{@re_property_characteristics}
; Land dimensions
acreage = #:(0..)                                 ; Total acreage
depth_feet = #:(0..)                              ; Lot depth in feet
frontage_feet = #:(0..)                           ; Street frontage in feet
lot_sqft = ##:(0..)                               ; Lot size in square feet
shape = (corner, cul_de_sac, flag, interior, irregular, through)  ; Lot shape

; Building characteristics (if improved)
{.building}
bathrooms = #:(0..99)                             ; Number of bathrooms
bedrooms = ##:(0..)                               ; Number of bedrooms
gross_building_area = ##:(0..)                    ; Gross building area sqft
living_area = ##:(0..)                            ; Living area sqft
stories = #:(0..)                                 ; Number of stories
style = :                                         ; Architectural style
year_built = ##:(1600..2100)                      ; Year constructed
year_renovated = ##:(1600..2100)                  ; Year of major renovation

{@re_property_characteristics}

; Construction details
{.construction}
basement = (crawl, finished, full, none, partial, unfinished)
exterior = (aluminum, brick, concrete, fiber_cement, other, stone, stucco, vinyl, wood)
foundation = (basement, crawl_space, pier, pilings, slab)
heating = (baseboard, central, forced_air, heat_pump, none, other, radiant)
cooling = (central, evaporative, mini_split, none, other, wall_unit, window)
roof = (asphalt_shingle, flat, metal, other, slate, tile, wood)
frame = (concrete, hybrid, masonry, steel, wood)

{@re_property_characteristics}

; Site features
{.site}
driveway = ?                                      ; Property has driveway
fence = ?                                         ; Property is fenced
garage_spaces = ##:(0..)                          ; Number of garage spaces
garage_type = (attached, carport, detached, none)
landscaping = (extensive, minimal, moderate, none)
parking_spaces = ##:(0..)                         ; Total off-street parking
pool = ?                                          ; Property has pool
pool_type = (above_ground, in_ground, indoor):if pool = true

{@re_property_characteristics}

; ═══════════════════════════════════════════════════════════════════════════════
; ZONING
; ═══════════════════════════════════════════════════════════════════════════════
; Zoning information per local jurisdiction

{@re_zoning}
; Required fields first
classification = !:                               ; Zoning classification code

; Zoning details
category = (agricultural, commercial, industrial, mixed_use, planned_unit, residential, special)
description = :                                   ; Zoning description
jurisdiction = :                                  ; Zoning authority name

; Permitted uses
{.permitted_uses}
multifamily = ?                                   ; Multifamily permitted
office = ?                                        ; Office use permitted
retail = ?                                        ; Retail use permitted
single_family = ?                                 ; Single family permitted
other_uses[] = :                                  ; Other permitted uses

{@re_zoning}

; Development restrictions
{.restrictions}
building_height_max = ##:(0..)                    ; Maximum building height feet
coverage_max = #:(0..100)                         ; Maximum lot coverage percent
density_max = #:(0..)                             ; Maximum units per acre
far_max = #:(0..)                                 ; Maximum floor area ratio
setback_front = ##:(0..)                          ; Front setback feet
setback_rear = ##:(0..)                           ; Rear setback feet
setback_side = ##:(0..)                           ; Side setback feet

{@re_zoning}

; Compliance status
compliance_status = (compliant, legal_nonconforming, noncompliant, unknown, variance)
variance_description = ::if compliance_status = variance

; ═══════════════════════════════════════════════════════════════════════════════
; OWNERSHIP
; ═══════════════════════════════════════════════════════════════════════════════
; How title is held (vesting)

{@re_ownership}
; Required fields first
vesting_type = !(community_property, community_property_survivorship, corporation, estate, joint_tenancy, life_estate, llc, partnership, sole_ownership, tenancy_by_entirety, tenancy_in_common, trust)

; Owner information
owners[] = :                                      ; Names as vested on title
ownership_percentage[] = #:(0..100)               ; Percentage each owner holds

; Acquisition
acquisition_date = date                           ; Date ownership acquired
acquisition_type = (foreclosure, gift, inheritance, new_construction, purchase, quitclaim, tax_sale)
deed_reference = :                                ; Recording reference for deed

; ═══════════════════════════════════════════════════════════════════════════════
; ENCUMBRANCE
; ═══════════════════════════════════════════════════════════════════════════════
; Liens, easements, and other encumbrances on title

{@re_encumbrance}
; Required fields first
type = !(assessment, cc_r, easement, encroachment, judgment, lease, lien, lis_pendens, mechanic_lien, mortgage, option, restriction, right_of_way, tax_lien, utility_easement)

; Recording information
recording_date = date                             ; Date recorded
recording_reference = :                           ; Book/page or instrument number

; Encumbrance details
amount = #$:(0..)                                 ; Amount (for monetary liens)
beneficiary = :                                   ; Party benefiting from encumbrance
description = :                                   ; Description of encumbrance
expiration_date = date                            ; When encumbrance expires/terminates
grantor = :                                       ; Party granting encumbrance
id = :                                            ; Unique identifier
priority = ##:(1..)                               ; Lien priority position

; Status
released = ?                                      ; Has been released
release_date = date:if released = true            ; Date of release
release_recording = ::if released = true          ; Release recording reference
status = (active, expired, released, subordinated)

; ═══════════════════════════════════════════════════════════════════════════════
; REAL ESTATE PARTY
; ═══════════════════════════════════════════════════════════════════════════════
; Party to a real estate transaction (buyer, seller, agent, etc.)

{@re_party}
= @person                                         ; Inherits person fields

; Required fields first
role = !(appraiser, attorney, borrower, broker, buyer, closing_agent, co_borrower, escrow_officer, inspector, lender, listing_agent, property_manager, seller, selling_agent, title_officer)

; Party identification
party_id = :                                      ; Unique party identifier

; License information (for licensed professionals)
license = @license_credential                     ; Professional license

{@re_party}

; Representing
representing = (buyer, dual, lender, seller, transaction)  ; Party represented

; ═══════════════════════════════════════════════════════════════════════════════
; REAL ESTATE COMPANY
; ═══════════════════════════════════════════════════════════════════════════════
; Company in a real estate transaction (brokerage, title company, etc.)

{@re_company}
= @organization                                   ; Inherits organization fields

; Required fields first
company_type = !(appraisal_management, brokerage, builder, developer, escrow, home_warranty, inspection, lender, property_management, title)

; Company identification
company_id = :                                    ; Unique company identifier

; License information
license = @license_credential                     ; Company license

{@re_company}

; ═══════════════════════════════════════════════════════════════════════════════
; REAL ESTATE AGENT
; ═══════════════════════════════════════════════════════════════════════════════
; Licensed real estate agent or broker

{@re_agent}
= @person                                         ; Inherits person fields

; Required fields first
agent_type = !(associate_broker, broker, designated_broker, real_estate_agent, salesperson)

; Agent identification
agent_id = :                                      ; Agent MLS or system ID
nrds_id = :                                       ; National REALTOR Database System ID

; License information
license = !@license_credential                    ; Professional real estate license (required)

{@re_agent}

; Brokerage affiliation
brokerage_name = :                                ; Affiliated brokerage name
brokerage_ref = @re_company                       ; Reference to brokerage company

; Production info
active = ?                                        ; Currently active
mls_id = :                                        ; MLS member ID

; ═══════════════════════════════════════════════════════════════════════════════
; TAX INFORMATION
; ═══════════════════════════════════════════════════════════════════════════════
; Property tax information

{@re_tax_info}
; Required fields first
tax_year = !##:(1900..2100)                       ; Tax year

; Tax amounts
assessed_land = #$:(0..)                          ; Assessed land value
assessed_improvements = #$:(0..)                  ; Assessed improvement value
assessed_total = #$:(0..)                         ; Total assessed value
exemptions = #$:(0..)                             ; Total exemption amount
tax_amount = #$:(0..)                             ; Annual tax amount
tax_rate = #:(0..)                                ; Tax rate (mills or percentage)

; Exemptions
{.exemptions_detail}
homestead = ?                                     ; Homestead exemption
over_65 = ?                                       ; Senior exemption
disabled = ?                                      ; Disability exemption
veteran = ?                                       ; Veteran exemption
agricultural = ?                                  ; Agricultural exemption
other[] = :                                       ; Other exemptions

{@re_tax_info}

; Tax status
delinquent = ?                                    ; Taxes are delinquent
delinquent_amount = #$:(0..):if delinquent = true ; Delinquent amount
penalty_amount = #$:(0..):if delinquent = true    ; Penalty amount
interest_amount = #$:(0..):if delinquent = true   ; Interest amount

; Special assessments
special_assessments = #$:(0..)                    ; Special assessment amount
special_assessment_description = :                ; Description of special assessments

; ═══════════════════════════════════════════════════════════════════════════════
; PROPERTY STATUS
; ═══════════════════════════════════════════════════════════════════════════════
; Current status of property for transaction purposes

{@re_property_status}
listing_status = (active, canceled, closed, coming_soon, contingent, expired, pending, withdrawn)
occupancy = (owner_occupied, rented, vacant)
condition = (excellent, fair, good, needs_work, poor)

; Listing information (if applicable)
list_date = date                                  ; Date listed
list_price = #$:(0..)                             ; Current list price
original_list_price = #$:(0..)                    ; Original list price
days_on_market = ##:(0..)                         ; Days on market

; Sale information (if under contract or sold)
contract_date = date                              ; Date under contract
contract_price = #$:(0..)                         ; Contract price
sold_date = date                                  ; Date sold
sold_price = #$:(0..)                             ; Final sale price

; ═══════════════════════════════════════════════════════════════════════════════
; PROPERTY CONDITION REPORT
; ═══════════════════════════════════════════════════════════════════════════════
; Summary of property condition from inspection or disclosure

{@re_condition_report}
; Required fields first
report_date = !date                               ; Date of report
report_type = !(appraisal, disclosure, inspection, pre_listing)

; Reporter information
inspector_name = :                                ; Inspector or preparer name
inspector_license = :                             ; Inspector license number
company = :                                       ; Inspection company

; Overall condition
overall_condition = (excellent, fair, good, needs_work, poor)

; Major systems condition
{.systems}
electrical = (functional, needs_repair, not_functional, not_inspected, updated)
hvac = (functional, needs_repair, not_functional, not_inspected, updated)
plumbing = (functional, needs_repair, not_functional, not_inspected, updated)
roof = (functional, needs_repair, not_functional, not_inspected, updated)
foundation = (functional, needs_repair, not_functional, not_inspected, updated)

{@re_condition_report}

; Issues found
{.issues}
count = ##:(0..)                                  ; Total issues found
major_count = ##:(0..)                            ; Major issues count
safety_count = ##:(0..)                           ; Safety hazard count
summary = :                                       ; Summary of issues

{@re_condition_report}

; Estimated repairs
repair_estimate = #$:(0..)                        ; Estimated repair cost

; ═══════════════════════════════════════════════════════════════════════════════
; UTILITY INFORMATION
; ═══════════════════════════════════════════════════════════════════════════════
; Available utilities for the property

{@re_utilities}
; Water
{.water}
available = ?                                     ; Water service available
source = (municipal, private, well)               ; Water source
provider = :                                      ; Utility provider name
meter_number = :                                  ; Meter number

{@re_utilities}

; Sewer
{.sewer}
available = ?                                     ; Sewer service available
type = (municipal, private, septic)               ; Sewer type
provider = :                                      ; Utility provider name

{@re_utilities}

; Electric
{.electric}
available = ?                                     ; Electric service available
provider = :                                      ; Utility provider name
meter_number = :                                  ; Meter number
amps = ##:(0..)                                   ; Service amperage

{@re_utilities}

; Gas
{.gas}
available = ?                                     ; Gas service available
type = (lp, natural, none)                        ; Gas type
provider = :                                      ; Utility provider name
meter_number = :                                  ; Meter number

{@re_utilities}

; Other utilities
{.other}
cable = ?                                         ; Cable TV available
fiber = ?                                         ; Fiber internet available
internet = ?                                      ; Internet available
phone = ?                                         ; Phone service available
trash = ?                                         ; Trash service available
trash_provider = ::if trash = true                ; Trash provider name

{@re_utilities}

; ═══════════════════════════════════════════════════════════════════════════════
; FLOOD ZONE
; ═══════════════════════════════════════════════════════════════════════════════
; FEMA flood zone information

{@re_flood_zone}
; Required fields first
zone = !:                                         ; FEMA flood zone designation

; Flood determination
determination_date = date                         ; Date of flood determination
map_number = :                                    ; FEMA flood map number
map_panel = :                                     ; Map panel number
map_suffix = :                                    ; Map suffix
community_number = :                              ; NFIP community number

; Risk classification
high_risk = ?                                     ; In Special Flood Hazard Area
insurance_required = ?                            ; Flood insurance required
base_flood_elevation = #                          ; Base flood elevation feet

; Insurance information
nfip_community_participant = ?                    ; Community participates in NFIP


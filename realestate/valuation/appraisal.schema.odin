; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Real Estate Appraisal Schema
; ═══════════════════════════════════════════════════════════════════════════════
; USPAP-compliant property appraisal schema covering self-contained, summary,
; and restricted report types. Includes comparable sales analysis, adjustment
; grids, valuation approaches (sales comparison, cost, income), and
; reconciliation of value indicators.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as common
@import "../types.schema.odin" as re

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.realestate.valuation.appraisal"
version = "1.0.0"
title = "Real Estate Appraisal Schema"
description = "USPAP-compliant real estate appraisal and valuation"

{$derivation}
source[0].authority = "Appraisal Standards Board"
source[0].citation = "Uniform Standards of Professional Appraisal Practice (USPAP)"
source[0].url = "https://www.appraisalfoundation.org/imis/TAF/Standards/Appraisal_Standards/Uniform_Standards_of_Professional_Appraisal_Practice/TAF/USPAP.aspx"

source[1].authority = "Fannie Mae"
source[1].citation = "Selling Guide: Appraisal Requirements"
source[1].url = "https://selling-guide.fanniemae.com/"

source[2].authority = "HUD/FHA"
source[2].citation = "FHA Single Family Housing Policy Handbook 4000.1"
source[2].url = "https://www.hud.gov/program_offices/housing/sfh/handbook_4000-1"

source[3].authority = "Appraisal Institute"
source[3].citation = "The Appraisal of Real Estate, 15th Edition"
source[3].url = "https://www.appraisalinstitute.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Appraisal schema derived from USPAP and GSE requirements"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial appraisal schema"
changelog[0].rationale = "USPAP-compliant appraisal structure"

; ═══════════════════════════════════════════════════════════════════════════════
; APPRAISER
; ═══════════════════════════════════════════════════════════════════════════════
; Licensed/certified appraiser information

{@appraiser}
= @person                                            ; Inherits person base fields

; Appraiser identification
appraiser_id = :                                     ; Unique appraiser identifier

; ───────────────────────────────────────────────────────────────────────────────
; Credentials
; ───────────────────────────────────────────────────────────────────────────────
{.credentials}
license_type = (certified_general, certified_residential, licensed, trainee)
license_number = *:                                  ; State license number
license_state = :(2)                                ; State of licensure
license_expiration = date                           ; License expiration date
license_status = (active, expired, inactive, revoked, suspended)
fha_roster = ?                                       ; On FHA appraiser roster
fha_id = ::if fha_roster = true                      ; FHA appraiser ID
va_fee_panel = ?                                     ; On VA fee panel
va_id = ::if va_fee_panel = true                     ; VA appraiser ID

{@appraiser}

; ───────────────────────────────────────────────────────────────────────────────
; Designations
; ───────────────────────────────────────────────────────────────────────────────
{.designations[]}
designation = :                                      ; Designation (MAI, SRA, etc.)
organization = :                                     ; Granting organization
date_awarded = date                                  ; Date awarded

{@appraiser}

; ───────────────────────────────────────────────────────────────────────────────
; Errors and Omissions Insurance
; ───────────────────────────────────────────────────────────────────────────────
{.eo_insurance}
carrier = :                                          ; Insurance carrier
policy_number = :                                    ; Policy number
coverage_amount = #$:(0..)                           ; Coverage amount
expiration = date                                    ; Policy expiration

{@appraiser}

; ═══════════════════════════════════════════════════════════════════════════════
; APPRAISAL ASSIGNMENT
; ═══════════════════════════════════════════════════════════════════════════════
; The appraisal engagement/order

{@appraisal_assignment}
; Required fields first
assignment_date = date                              ; Date of assignment
client_name = :                                     ; Client name
intended_use = :                                    ; Intended use of appraisal
property_address = @address                         ; Subject property address
purpose = (estate, financing, legal, listing, other, purchase, refinance, relocation)

; Assignment identification
assignment_id = :                                    ; Unique assignment identifier
order_number = :                                     ; AMC/lender order number

; ───────────────────────────────────────────────────────────────────────────────
; Assignment Details
; ───────────────────────────────────────────────────────────────────────────────
assignment_type = (exterior_only, interior_inspection, no_inspection)
report_type = (restricted, self_contained, summary)
property_type = (commercial, land, mixed_use, multi_family, residential)
appraisal_type = (complete, drive_by, desktop, field_review, retrospective, update)

{@appraisal_assignment}

; ───────────────────────────────────────────────────────────────────────────────
; Client and Intended Users
; ───────────────────────────────────────────────────────────────────────────────
{.client}
client_type = (amc, attorney, court, estate, government, individual, lender, other)
client_address = @address                            ; Client address
client_contact = :                                   ; Contact name
client_phone = @phone                                ; Contact phone
client_email = @email                                ; Contact email

{@appraisal_assignment}

; Intended users
intended_users[] = :                                 ; List of intended users

; ───────────────────────────────────────────────────────────────────────────────
; Scope of Work
; ───────────────────────────────────────────────────────────────────────────────
{.scope}
approaches_required[] = (cost, income, sales_comparison)
data_sources[] = :                                   ; Required data sources
inspection_type = (exterior, interior, none)
extraordinary_assumptions[] = :                      ; Extraordinary assumptions
hypothetical_conditions[] = :                        ; Hypothetical conditions
jurisdictional_exception = ?                         ; Jurisdictional exception applies
jurisdictional_exception_description = ::if jurisdictional_exception = true

{@appraisal_assignment}

; ───────────────────────────────────────────────────────────────────────────────
; Fee and Timeline
; ───────────────────────────────────────────────────────────────────────────────
{.fee}
appraisal_fee = #$:(0..)                             ; Appraisal fee
rush_fee = #$:(0..)                                  ; Rush/expedite fee
additional_fees = #$:(0..)                           ; Additional fees
total_fee = #$:(0..)                                 ; Total fee
due_date = date                                      ; Report due date
rush_order = ?                                       ; Rush/expedite order

{@appraisal_assignment}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (accepted, cancelled, completed, declined, delivered, in_progress, pending, revision_requested)
status_date = date                                   ; Status change date
decline_reason = ::if status = declined              ; Reason for decline
cancellation_reason = ::if status = cancelled        ; Reason for cancellation

; ═══════════════════════════════════════════════════════════════════════════════
; APPRAISAL
; ═══════════════════════════════════════════════════════════════════════════════
; The appraisal report itself

{@appraisal}
; Required fields first
appraised_value = #$:(0..)                          ; Final appraised value
effective_date = date                               ; Effective date of value
property_address = @address                         ; Subject property address
report_date = date                                  ; Date of report

; Appraisal identification
appraisal_id = :                                     ; Unique appraisal identifier
file_number = :                                      ; Appraiser file number

; Assignment reference
assignment_ref = @appraisal_assignment               ; Reference to assignment

; ───────────────────────────────────────────────────────────────────────────────
; Appraiser(s)
; ───────────────────────────────────────────────────────────────────────────────
appraiser = @appraiser                               ; Primary appraiser
supervisory_appraiser = @appraiser                   ; Supervisory appraiser (if trainee)
review_appraiser = @appraiser                        ; Review appraiser (if applicable)

{@appraisal}

; ───────────────────────────────────────────────────────────────────────────────
; Subject Property
; ───────────────────────────────────────────────────────────────────────────────
{.subject}
legal_description = @re_legal_description            ; Legal description
parcel = @re_parcel_identifiers                      ; Parcel identifiers
property_type = (condominium, cooperative, manufactured, multi_family, pud, single_family)
property_rights = (fee_simple, ground_lease, leased_fee, leasehold, life_estate)
zoning = @re_zoning                                  ; Zoning information
flood = @re_flood_zone                               ; Flood zone information
census_tract = :                                     ; Census tract number

{@appraisal}

; Owner information
{.subject.owner}
owner_name = :                                       ; Current owner
owner_occupied = ?                                   ; Owner occupied
occupancy_status = (owner, rental, vacant)

{@appraisal}

; Sale/transfer history
{.subject.sale_history[]}
sale_date = date                                     ; Date of sale
sale_price = #$:(0..)                                ; Sale price
seller = :                                           ; Seller name
buyer = :                                            ; Buyer name
data_source = :                                      ; Data source

{@appraisal}

; Current listing
{.subject.listing}
currently_listed = ?                                 ; Currently listed for sale
list_price = #$:(0..):if currently_listed = true    ; List price
list_date = date:if currently_listed = true          ; List date
dom = ##:(0..):if currently_listed = true            ; Days on market
mls_number = ::if currently_listed = true            ; MLS number

{@appraisal}

; Contract (if purchase/refinance)
{.subject.contract}
contract_price = #$:(0..)                            ; Contract price
contract_date = date                                 ; Contract date
seller_concessions = #$:(0..)                        ; Seller concessions
financing_type = (cash, conventional, fha, other, usda, va)
personal_property_included = ?                       ; Personal property in sale
personal_property_value = #$:(0..):if personal_property_included = true

{@appraisal}

; ───────────────────────────────────────────────────────────────────────────────
; Site Analysis
; ───────────────────────────────────────────────────────────────────────────────
{.site}
lot_size_sqft = ##:(0..)                             ; Lot size square feet
lot_size_acres = #:(0..)                             ; Lot size acres
lot_shape = :                                        ; Lot shape description
topography = :                                       ; Topography description
view = :                                             ; View description
drainage = :                                         ; Drainage description
utilities = @re_utilities                            ; Available utilities
off_site_improvements = :                            ; Off-site improvements
site_comments = :                                    ; Additional site comments

{@appraisal}

; ───────────────────────────────────────────────────────────────────────────────
; Improvements
; ───────────────────────────────────────────────────────────────────────────────
{.improvements}
gla = ##:(0..)                                       ; Gross living area
total_rooms = ##:(0..)                               ; Total room count
bedrooms = ##:(0..)                                  ; Bedroom count
bathrooms_full = ##:(0..)                            ; Full bath count
bathrooms_half = ##:(0..)                            ; Half bath count
basement_sqft = ##:(0..)                             ; Basement square feet
basement_finished_sqft = ##:(0..)                    ; Finished basement sqft
above_grade_sqft = ##:(0..)                          ; Above grade sqft
below_grade_sqft = ##:(0..)                          ; Below grade sqft
stories = #:(0..)                                    ; Number of stories
year_built = ##:(1600..2100)                         ; Year built
effective_age = ##:(0..)                             ; Effective age in years
remaining_economic_life = ##:(0..)                   ; Remaining economic life years
condition = (average, excellent, fair, good, poor)
quality = (average, excellent, fair, good, poor)

{@appraisal}

; Construction
{.improvements.construction}
foundation = :                                       ; Foundation type
exterior_walls = :                                   ; Exterior wall material
roof_surface = :                                     ; Roof surface material
insulation = :                                       ; Insulation type
windows = :                                          ; Window type
screens = ?                                          ; Has screens

{@appraisal}

; Interior
{.improvements.interior}
floors = :                                           ; Floor material
walls = :                                            ; Wall finish
trim = :                                             ; Trim/finish work
bath_floor = :                                       ; Bathroom floor
bath_wainscot = :                                    ; Bathroom walls

{@appraisal}

; Systems
{.improvements.systems}
heating_type = :                                     ; Heating type
heating_fuel = :                                     ; Heating fuel
cooling_type = :                                     ; Cooling type
attic = :                                            ; Attic description
fireplace_count = ##:(0..)                           ; Number of fireplaces

{@appraisal}

; Garage/Parking
{.improvements.parking}
garage_type = (attached, built_in, carport, detached, none)
garage_spaces = ##:(0..)                             ; Garage capacity
driveway = :                                         ; Driveway surface

{@appraisal}

; Amenities
{.improvements.amenities}
pool = ?                                             ; Has pool
patio_deck = ?                                       ; Has patio/deck
porch = ?                                            ; Has porch
fence = ?                                            ; Has fence
outbuildings = :                                     ; Outbuildings description

{@appraisal}

; ───────────────────────────────────────────────────────────────────────────────
; Neighborhood
; ───────────────────────────────────────────────────────────────────────────────
{.neighborhood}
location = (rural, suburban, urban)
built_up = (over_75, under_25, 25_75)
growth = (declining, rapid, slow, stable)
property_values = (declining, increasing, stable)
demand_supply = (in_balance, over_supply, shortage)
marketing_time = (over_6_months, under_3_months, 3_6_months)
neighborhood_boundaries = :                          ; Neighborhood boundaries
neighborhood_description = :                         ; Neighborhood description
market_conditions = :                                ; Current market conditions

{@appraisal}

; Land use
{.neighborhood.land_use}
one_unit = #:(0..100)                                ; Percentage one-unit
two_four_unit = #:(0..100)                           ; Percentage 2-4 unit
multi_family = #:(0..100)                            ; Percentage multi-family
commercial = #:(0..100)                              ; Percentage commercial
other = #:(0..100)                                   ; Percentage other

{@appraisal}

; Price/age range
{.neighborhood.price_range}
low = #$:(0..)                                       ; Low price
high = #$:(0..)                                      ; High price
predominant = #$:(0..)                               ; Predominant price

{@appraisal}

{.neighborhood.age_range}
low = ##:(0..)                                       ; Lowest age
high = ##:(0..)                                      ; Highest age
predominant = ##:(0..)                               ; Predominant age

{@appraisal}

; ───────────────────────────────────────────────────────────────────────────────
; Sales Comparison Approach
; ───────────────────────────────────────────────────────────────────────────────
{.sales_comparison}
approach_developed = ?                               ; Approach developed
value_indication = #$:(0..)                          ; Value indication
comments = :                                         ; Approach comments

{@appraisal}

; Comparable sales
{.sales_comparison.comparables[]}
comparable_number = ##:(1..)                         ; Comparable number (1-6)
address = @address                                   ; Comparable address
proximity = #:(0..)                                  ; Distance from subject (miles)
sale_price = #$:(0..)                                ; Sale price
sale_date = date                                     ; Sale date
data_source = :                                      ; Data source/verification
price_per_sqft = #$:(0..)                            ; Price per sqft
gla = ##:(0..)                                       ; Gross living area
lot_size_sqft = ##:(0..)                             ; Lot size
bedrooms = ##:(0..)                                  ; Bedrooms
bathrooms = #:(0..)                                  ; Bathrooms (total)
year_built = ##:(1600..2100)                         ; Year built
condition = :                                        ; Condition
view = :                                             ; View
location = :                                         ; Location rating
site = :                                             ; Site description
quality = :                                          ; Quality rating
design_style = :                                     ; Design/style
basement_sqft = ##:(0..)                             ; Basement sqft
functional_utility = :                               ; Functional utility
heating_cooling = :                                  ; Heating/cooling
garage_spaces = ##:(0..)                             ; Garage spaces

{@appraisal}

; Adjustments for each comparable
{.sales_comparison.adjustments[]}
comparable_number = ##:(1..)                         ; Which comparable
sale_concessions = #$                                ; Sale concessions adjustment
date_of_sale = #$                                    ; Time adjustment
location = #$                                        ; Location adjustment
site = #$                                            ; Site adjustment
view = #$                                            ; View adjustment
design_style = #$                                    ; Design/style adjustment
quality = #$                                         ; Quality adjustment
age = #$                                             ; Age adjustment
condition = #$                                       ; Condition adjustment
gla = #$                                             ; GLA adjustment
basement = #$                                        ; Basement adjustment
functional_utility = #$                              ; Functional utility adjustment
heating_cooling = #$                                 ; Heating/cooling adjustment
garage = #$                                          ; Garage adjustment
porch_patio_deck = #$                                ; Porch/patio/deck adjustment
other_adjustment_1 = #$                              ; Other adjustment 1
other_adjustment_1_description = :                   ; Description
other_adjustment_2 = #$                              ; Other adjustment 2
other_adjustment_2_description = :                   ; Description
net_adjustment = #$                                  ; Net adjustment
gross_adjustment = #$:(0..)                          ; Gross adjustment
adjusted_sale_price = #$:(0..)                       ; Adjusted sale price

{@appraisal}

; ───────────────────────────────────────────────────────────────────────────────
; Cost Approach
; ───────────────────────────────────────────────────────────────────────────────
{.cost}
approach_developed = ?                               ; Approach developed
value_indication = #$:(0..)                          ; Value indication
comments = :                                         ; Approach comments

{@appraisal}

; Site value
{.cost.site}
site_value = #$:(0..)                                ; Estimated site value
source = :                                           ; Source of site value

{@appraisal}

; Improvement costs
{.cost.improvements}
dwelling_sqft = ##:(0..)                             ; Dwelling square feet
cost_per_sqft = #$:(0..)                             ; Cost per sqft
dwelling_cost_new = #$:(0..)                         ; Dwelling cost new
extras_description = :                               ; Extras description
extras_cost = #$:(0..)                               ; Extras cost
garage_sqft = ##:(0..)                               ; Garage square feet
garage_cost = #$:(0..)                               ; Garage cost
total_cost_new = #$:(0..)                            ; Total cost new

{@appraisal}

; Depreciation
{.cost.depreciation}
physical = #$:(0..)                                  ; Physical depreciation
functional = #$:(0..)                                ; Functional depreciation
external = #$:(0..)                                  ; External depreciation
total_depreciation = #$:(0..)                        ; Total depreciation
depreciated_value = #$:(0..)                         ; Depreciated improvement value

{@appraisal}

; ───────────────────────────────────────────────────────────────────────────────
; Income Approach
; ───────────────────────────────────────────────────────────────────────────────
{.income}
approach_developed = ?                               ; Approach developed
value_indication = #$:(0..)                          ; Value indication
comments = :                                         ; Approach comments

{@appraisal}

; Rental data
{.income.rental}
estimated_market_rent = #$:(0..)                     ; Estimated market rent
rent_period = (annual, monthly)                      ; Rent period
vacancy_rate = #:(0..100)                            ; Vacancy rate
effective_gross_income = #$:(0..)                    ; Effective gross income
operating_expenses = #$:(0..)                        ; Operating expenses
net_operating_income = #$                            ; NOI (can be negative)

{@appraisal}

; Rent comparables
{.income.rent_comparables[]}
address = @address                                   ; Comparable address
rent = #$:(0..)                                      ; Monthly rent
sqft = ##:(0..)                                      ; Square feet
bedrooms = ##:(0..)                                  ; Bedrooms
bathrooms = #:(0..)                                  ; Bathrooms
condition = :                                        ; Condition
location = :                                         ; Location
adjustments = :                                      ; Adjustments made
adjusted_rent = #$:(0..)                             ; Adjusted rent

{@appraisal}

; GRM analysis
{.income.grm}
grm_used = #:(0..)                                   ; Gross rent multiplier used
grm_source = :                                       ; Source of GRM

{@appraisal}

; ───────────────────────────────────────────────────────────────────────────────
; Reconciliation
; ───────────────────────────────────────────────────────────────────────────────
{.reconciliation}
sales_comparison_value = #$:(0..)                    ; Sales comparison indication
cost_approach_value = #$:(0..)                       ; Cost approach indication
income_approach_value = #$:(0..)                     ; Income approach indication
final_value = #$:(0..)                               ; Final reconciled value
reconciliation_comments = :                          ; Reconciliation discussion
most_weight = (cost, income, sales_comparison)       ; Approach given most weight
as_is = ?                                            ; Value is "as is"
as_completed = ?                                     ; Value subject to completion
as_repaired = ?                                      ; Value subject to repairs
prospective = ?                                      ; Prospective value

{@appraisal}

; ───────────────────────────────────────────────────────────────────────────────
; Certifications and Limiting Conditions
; ───────────────────────────────────────────────────────────────────────────────
{.certifications}
uspap_compliant = ?                                  ; USPAP compliant
prior_services = ?                                   ; Prior services on property
prior_services_description = ::if prior_services = true
personal_interest = ?                                ; Personal interest in property
compensation_contingent = ?                          ; Fee contingent on value
significant_assistance = ?                           ; Significant professional assistance
assistance_description = ::if significant_assistance = true
inspection_date = date                               ; Date of inspection
signature_date = date                                ; Date of signature

{@appraisal}

; Limiting conditions
limiting_conditions[] = :                            ; Standard limiting conditions

; ───────────────────────────────────────────────────────────────────────────────
; Exhibits/Attachments
; ───────────────────────────────────────────────────────────────────────────────
{.exhibits}
location_map = ?                                     ; Location map included
plat_map = ?                                         ; Plat map included
floor_plan = ?                                       ; Floor plan included
exterior_photos = ##:(0..)                           ; Number of exterior photos
interior_photos = ##:(0..)                           ; Number of interior photos
comparable_photos = ?                                ; Comparable photos included
comparable_location_map = ?                          ; Comparable location map

{@appraisal}

; ───────────────────────────────────────────────────────────────────────────────
; Quality Control
; ───────────────────────────────────────────────────────────────────────────────
{.quality_control}
desk_review_date = date                              ; Desk review date
desk_reviewer = :                                    ; Desk reviewer name
field_review_date = date                             ; Field review date
field_reviewer = :                                   ; Field reviewer name
cuv_score = ##:(0..1000)                             ; Collateral Underwriter score
cuv_risk = (high, low, medium)                       ; CU risk rating
revision_count = ##:(0..)                            ; Number of revisions
revision_reasons[] = :                               ; Revision reasons

{@appraisal}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (accepted, cancelled, completed, delivered, in_review, rejected, revision_submitted)
status_date = date                                   ; Status change date
rejection_reason = ::if status = rejected            ; Rejection reason


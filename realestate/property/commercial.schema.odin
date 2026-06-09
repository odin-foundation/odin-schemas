; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Commercial Property Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Commercial and investment property information covering office, retail,
; industrial, multifamily, mixed-use, hospitality, healthcare, and self-storage
; properties. Includes building details, tenancy, rent rolls, income/expense
; statements, valuation metrics, and environmental assessments.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as common
@import "../types.schema.odin" as re

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.realestate.property.commercial"
version = "1.0.0"
title = "Commercial Property Schema"
description = "Comprehensive commercial and investment property information"

{$derivation}
source[0].authority = "NCREIF"
source[0].citation = "National Council of Real Estate Investment Fiduciaries Property Index"
source[0].url = "https://www.ncreif.org/"

source[1].authority = "BOMA International"
source[1].citation = "Building Owners and Managers Association Standards"
source[1].url = "https://www.boma.org/"

source[2].authority = "Appraisal Institute"
source[2].citation = "The Appraisal of Real Estate"
source[2].url = "https://www.appraisalinstitute.org/"

source[3].authority = "CCIM Institute"
source[3].citation = "Commercial Investment Real Estate Standards"
source[3].url = "https://www.ccim.com/"

methodology = "industry_practice"
proprietary_sources_consulted = ?false
notes = "Commercial property schema derived from industry standards and valuation practices"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial commercial property schema"
changelog[0].rationale = "Comprehensive property structure for commercial transactions"

; ═══════════════════════════════════════════════════════════════════════════════
; COMMERCIAL PROPERTY
; ═══════════════════════════════════════════════════════════════════════════════

{@commercial_property}
; Required fields first
address = @address                               ; Property physical address
property_type = (healthcare, hospitality, industrial, mixed_use, multifamily, office, retail, self_storage, special_purpose)

; Property identification
property_id = :                                   ; Unique property identifier
property_name = :                                 ; Property/building name

; ───────────────────────────────────────────────────────────────────────────────
; Legal Description
; ───────────────────────────────────────────────────────────────────────────────
legal_description = @re_legal_description         ; Legal description
parcel = @re_parcel_identifiers                   ; Tax and recording identifiers

{@commercial_property}

; ───────────────────────────────────────────────────────────────────────────────
; Building Information
; ───────────────────────────────────────────────────────────────────────────────
{.building}
class = (a, b, c):if property_type = office       ; Office building class
construction_type = (concrete, masonry, steel, wood_frame)
gross_building_area = ##:(0..)                    ; Gross building area sqft
net_rentable_area = ##:(0..)                      ; Net rentable area sqft
floors_above_grade = ##:(0..)                     ; Stories above grade
floors_below_grade = ##:(0..)                     ; Stories below grade
building_count = ##:(1..)                         ; Number of buildings
year_built = ##:(1600..2100)                      ; Year constructed
year_renovated = ##:(1600..2100)                  ; Major renovation year
eff_age_years = ##:(0..)                          ; Effective age
condition = (excellent, fair, good, needs_work, poor)
sprinklered = ?                                   ; Fire sprinkler system
fire_alarm = ?                                    ; Fire alarm system
elevator_count = ##:(0..)                         ; Number of elevators

{@commercial_property}

; ───────────────────────────────────────────────────────────────────────────────
; Site Information
; ───────────────────────────────────────────────────────────────────────────────
{.site}
acreage = #:(0..)                                 ; Site size in acres
site_sqft = ##:(0..)                              ; Site size in square feet
coverage_ratio = #:(0..100)                       ; Building coverage percentage
far = #:(0..)                                     ; Actual floor area ratio
parking_spaces = ##:(0..)                         ; Total parking spaces
parking_ratio = #:(0..)                           ; Spaces per 1000 sqft
parking_type = (covered, open, structured, surface)
parking_reserved = ##:(0..)                       ; Reserved spaces
parking_visitor = ##:(0..)                        ; Visitor spaces
loading_docks = ##:(0..)                          ; Number of loading docks
drive_in_doors = ##:(0..)                         ; Drive-in doors

{@commercial_property}

; ───────────────────────────────────────────────────────────────────────────────
; Zoning
; ───────────────────────────────────────────────────────────────────────────────
zoning = @re_zoning                               ; Zoning information

; ───────────────────────────────────────────────────────────────────────────────
; Utilities
; ───────────────────────────────────────────────────────────────────────────────
utilities = @re_utilities                         ; Utility information

; ───────────────────────────────────────────────────────────────────────────────
; Flood Zone
; ───────────────────────────────────────────────────────────────────────────────
flood = @re_flood_zone                            ; Flood zone information

; ───────────────────────────────────────────────────────────────────────────────
; Ownership
; ───────────────────────────────────────────────────────────────────────────────
ownership = @re_ownership                         ; Ownership/vesting information

; ───────────────────────────────────────────────────────────────────────────────
; Tax Information
; ───────────────────────────────────────────────────────────────────────────────
taxes = @re_tax_info                              ; Property tax information

; ───────────────────────────────────────────────────────────────────────────────
; Encumbrances
; ───────────────────────────────────────────────────────────────────────────────
encumbrances[] = @re_encumbrance                  ; Liens and encumbrances

{@commercial_property}

; ───────────────────────────────────────────────────────────────────────────────
; Tenancy Information
; ───────────────────────────────────────────────────────────────────────────────
{.tenancy}
anchor_tenant = ?                                 ; Has anchor tenant
anchor_tenant_name = ::if anchor_tenant = true    ; Anchor tenant name
average_lease_term = ##:(0..)                     ; Average remaining lease months
multi_tenant = ?                                  ; Multi-tenant building
occupancy_rate = #:(0..100)                       ; Current occupancy percentage
single_tenant = ?                                 ; Single tenant building
tenant_count = ##:(0..)                           ; Number of tenants
total_leasable_area = ##:(0..)                    ; Total leasable sqft
vacancy_rate = #:(0..100)                         ; Current vacancy percentage
wault = #:(0..)                                   ; Weighted avg unexpired lease term (years)

{@commercial_property}

; ───────────────────────────────────────────────────────────────────────────────
; Rent Roll Summary
; ───────────────────────────────────────────────────────────────────────────────
{.rent_roll}
as_of_date = date                                 ; Rent roll date
annual_base_rent = #$:(0..)                       ; Total annual base rent
annual_expense_recovery = #$:(0..)                ; Annual expense recoveries
average_rent_psf = #$:(0..)                       ; Average rent per sqft
gross_potential_rent = #$:(0..)                   ; Gross potential rent
market_rent_psf = #$:(0..)                        ; Market rent per sqft
vacancy_loss = #$:(0..)                           ; Vacancy loss amount

{@commercial_property}

; ───────────────────────────────────────────────────────────────────────────────
; Office Specific
; ───────────────────────────────────────────────────────────────────────────────
{.office}
avg_floor_plate = ##:(0..):if property_type = office  ; Average floor plate sqft
ceiling_height = #:(0..):if property_type = office    ; Ceiling height feet
common_area_factor = #:(0..100):if property_type = office  ; Load factor
fiber_optic = ?:if property_type = office         ; Fiber optic connectivity
hvac_hours = ::if property_type = office          ; HVAC operating hours
medical_office = ?:if property_type = office      ; Medical office building
raised_floor = ?:if property_type = office        ; Raised floor data center
security = ?:if property_type = office            ; 24/7 security
tenant_improvements = ::if property_type = office ; TI allowance market

{@commercial_property}

; ───────────────────────────────────────────────────────────────────────────────
; Retail Specific
; ───────────────────────────────────────────────────────────────────────────────
{.retail}
anchor_sqft = ##:(0..):if property_type = retail  ; Anchor tenant square feet
frontage_feet = #:(0..):if property_type = retail ; Street frontage
inline_sqft = ##:(0..):if property_type = retail  ; Inline tenant square feet
outparcel_count = ##:(0..):if property_type = retail  ; Number of outparcels
pylon_signage = ?:if property_type = retail       ; Pylon sign available
retail_type = (community_center, convenience, lifestyle, mall, neighborhood, outlet, power_center, regional_mall, strip, superregional):if property_type = retail
traffic_count = ##:(0..):if property_type = retail  ; Daily traffic count
visibility = (excellent, fair, good, limited, poor):if property_type = retail

{@commercial_property}

; ───────────────────────────────────────────────────────────────────────────────
; Industrial Specific
; ───────────────────────────────────────────────────────────────────────────────
{.industrial}
bay_depths[] = ##:(0..):if property_type = industrial  ; Bay depths feet
clear_height = #:(0..):if property_type = industrial  ; Clear height feet
column_spacing = ::if property_type = industrial  ; Column spacing
crane = ?:if property_type = industrial           ; Has overhead crane
crane_capacity = ##:(0..):if crane = true         ; Crane capacity tons
cross_dock = ?:if property_type = industrial      ; Cross dock capability
dock_high_doors = ##:(0..):if property_type = industrial  ; Dock high doors
floor_load = ##:(0..):if property_type = industrial  ; Floor load capacity psf
grade_level_doors = ##:(0..):if property_type = industrial  ; Grade level doors
industrial_type = (bulk_distribution, cold_storage, data_center, distribution, flex, heavy_manufacturing, light_manufacturing, r_and_d, telecom, warehouse):if property_type = industrial
office_percent = #:(0..100):if property_type = industrial  ; Office percentage
rail_served = ?:if property_type = industrial     ; Rail access
trailer_parking = ##:(0..):if property_type = industrial  ; Trailer parking spaces
truck_court_depth = ##:(0..):if property_type = industrial  ; Truck court depth feet

{@commercial_property}

; ───────────────────────────────────────────────────────────────────────────────
; Multifamily Specific (5+ units)
; ───────────────────────────────────────────────────────────────────────────────
{.multifamily}
affordable_units = ##:(0..):if property_type = multifamily  ; Affordable housing units
amenities[] = ::if property_type = multifamily    ; Community amenities
average_unit_sqft = ##:(0..):if property_type = multifamily  ; Average unit size
furnished = ?:if property_type = multifamily      ; Furnished units
market_rate_units = ##:(0..):if property_type = multifamily  ; Market rate units
multifamily_type = (garden, high_rise, low_rise, mid_rise, seniors, student, townhome):if property_type = multifamily
rent_controlled = ?:if property_type = multifamily  ; Subject to rent control
total_units = ##:(5..):if property_type = multifamily  ; Total units
unit_mix = ::if property_type = multifamily       ; Unit mix summary

{@commercial_property.multifamily.unit_summary[]}
unit_type = :                                    ; Unit type (studio, 1BR, etc.)
unit_count = ##:(0..)                             ; Number of this type
avg_sqft = ##:(0..)                               ; Average square feet
avg_rent = #$:(0..)                               ; Average rent

{@commercial_property}

; ───────────────────────────────────────────────────────────────────────────────
; Hospitality Specific
; ───────────────────────────────────────────────────────────────────────────────
{.hospitality}
adr = #$:(0..):if property_type = hospitality     ; Average daily rate
brand = ::if property_type = hospitality          ; Hotel brand
convention_sqft = ##:(0..):if property_type = hospitality  ; Convention/meeting space
flag = ::if property_type = hospitality           ; Franchise flag
food_beverage = ?:if property_type = hospitality  ; Has F&B outlets
franchise = ?:if property_type = hospitality      ; Franchised property
hospitality_type = (boutique, convention, extended_stay, full_service, limited_service, luxury, resort, select_service):if property_type = hospitality
management_company = ::if property_type = hospitality  ; Management company
meeting_rooms = ##:(0..):if property_type = hospitality  ; Number of meeting rooms
occupancy_rate = #:(0..100):if property_type = hospitality  ; Average occupancy
restaurant_count = ##:(0..):if property_type = hospitality  ; Number of restaurants
revpar = #$:(0..):if property_type = hospitality  ; Revenue per available room
room_count = ##:(0..):if property_type = hospitality  ; Total guest rooms
star_rating = #:(0..5):if property_type = hospitality  ; Star rating

{@commercial_property}

; ───────────────────────────────────────────────────────────────────────────────
; Self-Storage Specific
; ───────────────────────────────────────────────────────────────────────────────
{.self_storage}
climate_controlled_sqft = ##:(0..):if property_type = self_storage  ; Climate controlled sqft
climate_controlled_units = ##:(0..):if property_type = self_storage  ; Climate controlled units
drive_up_units = ##:(0..):if property_type = self_storage  ; Drive-up units
floors = ##:(1..):if property_type = self_storage ; Number of floors
rv_boat_storage = ?:if property_type = self_storage  ; RV/boat storage
security_features = ::if property_type = self_storage  ; Security description
total_sqft = ##:(0..):if property_type = self_storage  ; Total net rentable sqft
total_units = ##:(0..):if property_type = self_storage  ; Total storage units
wine_storage = ?:if property_type = self_storage  ; Wine storage

{@commercial_property}

; ───────────────────────────────────────────────────────────────────────────────
; Healthcare Specific
; ───────────────────────────────────────────────────────────────────────────────
{.healthcare}
beds = ##:(0..):if property_type = healthcare     ; Number of beds
healthcare_type = (ambulatory_surgery, assisted_living, hospital, medical_office, memory_care, nursing_home, rehabilitation, skilled_nursing):if property_type = healthcare
licensed = ?:if property_type = healthcare        ; Licensed facility
license_type = ::if licensed = true               ; License type
operator = ::if property_type = healthcare        ; Facility operator
payer_mix = ::if property_type = healthcare       ; Payer mix description

{@commercial_property}

; ───────────────────────────────────────────────────────────────────────────────
; Mixed-Use Specific
; ───────────────────────────────────────────────────────────────────────────────
{.mixed_use}
components[] = (hospitality, multifamily, office, retail):if property_type = mixed_use
hotel_keys = ##:(0..):if property_type = mixed_use  ; Hotel rooms
office_sqft = ##:(0..):if property_type = mixed_use  ; Office component sqft
residential_units = ##:(0..):if property_type = mixed_use  ; Residential units
retail_sqft = ##:(0..):if property_type = mixed_use  ; Retail component sqft

{@commercial_property}

; ───────────────────────────────────────────────────────────────────────────────
; Income and Expenses
; ───────────────────────────────────────────────────────────────────────────────
{.financials}
as_of_date = date                                 ; Financial statement date
statement_type = (actual, budget, proforma, trailing_12)

; Income
{.income}
base_rent = #$:(0..)                              ; Base rental income
cam_reimbursement = #$:(0..)                      ; CAM reimbursements
effective_gross_income = #$:(0..)                 ; Effective gross income
gross_potential_income = #$:(0..)                 ; Gross potential income
insurance_reimbursement = #$:(0..)                ; Insurance reimbursements
other_income = #$:(0..)                           ; Other income
percentage_rent = #$:(0..)                        ; Percentage rent
tax_reimbursement = #$:(0..)                      ; Tax reimbursements
vacancy_collection_loss = #$:(0..)                ; Vacancy and collection loss

{@commercial_property.financials}

; Expenses
{.expenses}
cam = #$:(0..)                                    ; CAM expenses
insurance = #$:(0..)                              ; Insurance
management_fee = #$:(0..)                         ; Management fee
other_expenses = #$:(0..)                         ; Other operating expenses
property_taxes = #$:(0..)                         ; Property taxes
repairs_maintenance = #$:(0..)                    ; Repairs and maintenance
total_expenses = #$:(0..)                         ; Total operating expenses
utilities = #$:(0..)                              ; Utilities

{@commercial_property.financials}

; Net Operating Income
noi = #$                                          ; Net operating income (can be negative)
expense_ratio = #:(0..100)                        ; Expense ratio percentage

{@commercial_property}

; ───────────────────────────────────────────────────────────────────────────────
; Valuation Metrics
; ───────────────────────────────────────────────────────────────────────────────
{.valuation}
appraisal_date = date                             ; Date of appraisal
appraised_value = #$:(0..)                        ; Appraised value
cap_rate = #:(0..100)                             ; Capitalization rate
cap_rate_market = #:(0..100)                      ; Market cap rate
grm = #:(0..)                                     ; Gross rent multiplier
price_per_sqft = #$:(0..)                         ; Price per square foot
price_per_unit = #$:(0..):if property_type = multifamily  ; Price per unit

{@commercial_property}

; ───────────────────────────────────────────────────────────────────────────────
; Environmental
; ───────────────────────────────────────────────────────────────────────────────
{.environmental}
phase_i_date = date                               ; Phase I ESA date
phase_i_clean = ?                                 ; Phase I found no RECs
phase_ii_required = ?                             ; Phase II recommended/required
phase_ii_date = date:if phase_ii_required = true  ; Phase II date
environmental_issues = ?                          ; Known environmental issues
issue_description = ::if environmental_issues = true
remediation_complete = ?:if environmental_issues = true
asbestos = ?                                      ; Contains asbestos
lead_paint = ?                                    ; Contains lead paint
underground_tanks = ?                             ; Underground storage tanks

{@commercial_property}

; ───────────────────────────────────────────────────────────────────────────────
; Property Status
; ───────────────────────────────────────────────────────────────────────────────
status = @re_property_status                      ; Current property status

; ───────────────────────────────────────────────────────────────────────────────
; Condition
; ───────────────────────────────────────────────────────────────────────────────
condition = @re_condition_report                  ; Property condition


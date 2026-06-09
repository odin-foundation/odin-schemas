; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Residential Property Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Residential property information for single-family, condominium, cooperative,
; townhouse, multi-family (2-4 units), manufactured, and PUD properties.
; Covers structure details, lot, parking, amenities, energy features, HOA,
; disclosures, and type-specific sections for condos, co-ops, and more.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as common
@import "../types.schema.odin" as re

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.realestate.property.residential"
version = "1.0.0"
title = "Residential Property Schema"
description = "Comprehensive residential property information for real estate transactions"

{$derivation}
source[0].authority = "Fannie Mae"
source[0].citation = "Selling Guide - Property Eligibility"
source[0].url = "https://www.fanniemae.com/"

source[1].authority = "Freddie Mac"
source[1].citation = "Seller/Servicer Guide - Property Requirements"
source[1].url = "https://guide.freddiemac.com/app/guide/section/5601.1"

source[2].authority = "HUD"
source[2].citation = "Single Family Housing Policy Handbook 4000.1"
source[2].url = "https://www.hud.gov/program_offices/housing/sfh/handbook_4000-1"

source[3].authority = "National Association of Realtors"
source[3].citation = "RESO Data Dictionary"
source[3].url = "https://www.reso.org/data-dictionary/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Residential property schema derived from GSE requirements and industry standards"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial residential property schema"
changelog[0].rationale = "Comprehensive property structure for residential transactions"

; ═══════════════════════════════════════════════════════════════════════════════
; RESIDENTIAL PROPERTY
; ═══════════════════════════════════════════════════════════════════════════════

{@residential_property}
; Required fields first
address = @address                               ; Property physical address
property_type = (condominium, cooperative, manufactured, multi_family, pud, single_family_attached, single_family_detached)

; Property identification
property_id = :                                   ; Unique property identifier

; ───────────────────────────────────────────────────────────────────────────────
; Legal Description
; ───────────────────────────────────────────────────────────────────────────────
legal_description = @re_legal_description         ; Legal description

; Parcel identifiers
parcel = @re_parcel_identifiers                   ; Tax and recording identifiers

{@residential_property}

; ───────────────────────────────────────────────────────────────────────────────
; Property Characteristics
; ───────────────────────────────────────────────────────────────────────────────
characteristics = @re_property_characteristics    ; Physical characteristics

; Additional residential details
{.residential_details}
bathrooms_full = ##:(0..)                         ; Full bathrooms
bathrooms_half = ##:(0..)                         ; Half bathrooms
bathrooms_three_quarter = ##:(0..)                ; Three-quarter bathrooms
bedrooms = ##:(0..)                               ; Number of bedrooms
den = ?                                           ; Has den/study
dining_room = ?                                   ; Has formal dining room
family_room = ?                                   ; Has family room
fireplace = ?                                     ; Has fireplace
fireplace_count = ##:(0..):if fireplace = true    ; Number of fireplaces
kitchen_count = ##:(1..)                          ; Number of kitchens
living_area_sqft = ##:(0..)                       ; Living area square feet
living_room = ?                                   ; Has living room
loft = ?                                          ; Has loft
rooms_total = ##:(0..)                            ; Total room count

{@residential_property}

; ───────────────────────────────────────────────────────────────────────────────
; Structure Details
; ───────────────────────────────────────────────────────────────────────────────
{.structure}
age_years = ##:(0..)                              ; Building age in years
architectural_style = (bungalow, cape_cod, colonial, contemporary, craftsman, farmhouse, georgian, log, mediterranean, mid_century, modern, other, prairie, ranch, split_level, tudor, victorian)
attached = ?                                      ; Attached structure
attached_type = (common_wall, end_unit, row):if attached = true
basement = ?                                      ; Has basement
basement_sqft = ##:(0..):if basement = true       ; Basement square feet
basement_finished = ?:if basement = true          ; Basement is finished
construction_status = (completed, proposed, under_construction)
finished_sqft = ##:(0..)                          ; Total finished area
levels = ##:(1..)                                 ; Number of levels
main_floor_sqft = ##:(0..)                        ; Main floor square feet
year_built = ##:(1600..2100)                      ; Year constructed
year_renovated = ##:(1600..2100)                  ; Year of major renovation

{@residential_property}

; ───────────────────────────────────────────────────────────────────────────────
; Lot Details
; ───────────────────────────────────────────────────────────────────────────────
{.lot}
acreage = #:(0..)                                 ; Lot size in acres
corner_lot = ?                                    ; Corner lot
cul_de_sac = ?                                    ; On cul-de-sac
depth_feet = #:(0..)                              ; Lot depth
frontage_feet = #:(0..)                           ; Street frontage
shape = (flag, irregular, rectangular, square, triangular)
size_sqft = ##:(0..)                              ; Lot size square feet
topography = (flat, hillside, level, rolling, sloped, steep)
view = :                                          ; View description
waterfront = ?                                    ; Waterfront property
waterfront_type = (bayfront, canal, creek, gulf, lake, ocean, pond, river):if waterfront = true
wooded = ?                                        ; Wooded lot

{@residential_property}

; ───────────────────────────────────────────────────────────────────────────────
; Garage and Parking
; ───────────────────────────────────────────────────────────────────────────────
{.parking}
garage = ?                                        ; Has garage
garage_attached = ?:if garage = true              ; Garage attached
garage_spaces = ##:(0..):if garage = true         ; Garage capacity
carport = ?                                       ; Has carport
carport_spaces = ##:(0..):if carport = true       ; Carport capacity
covered_spaces = ##:(0..)                         ; Total covered parking
driveway = ?                                      ; Has driveway
driveway_surface = (asphalt, concrete, gravel, paver):if driveway = true
open_spaces = ##:(0..)                            ; Open parking spaces
rv_parking = ?                                    ; RV parking available
total_spaces = ##:(0..)                           ; Total parking spaces

{@residential_property}

; ───────────────────────────────────────────────────────────────────────────────
; Amenities
; ───────────────────────────────────────────────────────────────────────────────
{.amenities}
air_conditioning = ?                              ; Has air conditioning
attic = ?                                         ; Has attic
attic_finished = ?:if attic = true                ; Attic is finished
central_vacuum = ?                                ; Has central vacuum
deck = ?                                          ; Has deck
deck_sqft = ##:(0..):if deck = true               ; Deck size
fence = ?                                         ; Has fence
fence_type = (chain_link, iron, privacy, vinyl, wood):if fence = true
hot_tub = ?                                       ; Has hot tub/spa
laundry = (basement, closet, garage, hookups_only, main_floor, none, upper)
outdoor_kitchen = ?                               ; Has outdoor kitchen
patio = ?                                         ; Has patio
patio_sqft = ##:(0..):if patio = true             ; Patio size
pool = ?                                          ; Has pool
pool_type = (above_ground, in_ground, indoor):if pool = true
porch = ?                                         ; Has porch
security_system = ?                               ; Has security system
smart_home = ?                                    ; Has smart home features
solar = ?                                         ; Has solar panels
solar_owned = ?:if solar = true                   ; Solar panels owned (vs leased)
sprinkler_system = ?                              ; Has irrigation system
storage_shed = ?                                  ; Has storage building

{@residential_property}

; ───────────────────────────────────────────────────────────────────────────────
; Energy and Green Features
; ───────────────────────────────────────────────────────────────────────────────
{.energy}
energy_efficient = ?                              ; Energy efficient construction
energy_star = ?                                   ; ENERGY STAR certified
ev_charger = ?                                    ; EV charger installed
ev_charger_level = (level_1, level_2, level_3):if ev_charger = true
green_certified = ?                               ; Green certification
green_certification = ::if green_certified = true ; Certification name (LEED, etc.)
hers_rating = ##:(0..150)                         ; HERS Index rating
insulation = :                                    ; Insulation type/rating
propane = ?                                       ; Propane heat/appliances
tankless_water = ?                                ; Tankless water heater
windows = (double_pane, single_pane, triple_pane)

{@residential_property}

; ───────────────────────────────────────────────────────────────────────────────
; Utilities
; ───────────────────────────────────────────────────────────────────────────────
utilities = @re_utilities                         ; Utility information

; ───────────────────────────────────────────────────────────────────────────────
; Zoning
; ───────────────────────────────────────────────────────────────────────────────
zoning = @re_zoning                               ; Zoning information

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
; Property Status
; ───────────────────────────────────────────────────────────────────────────────
status = @re_property_status                      ; Current property status

; ───────────────────────────────────────────────────────────────────────────────
; Encumbrances
; ───────────────────────────────────────────────────────────────────────────────
encumbrances[] = @re_encumbrance                  ; Liens and encumbrances

{@residential_property}

; ───────────────────────────────────────────────────────────────────────────────
; HOA/Community
; ───────────────────────────────────────────────────────────────────────────────
{.hoa}
subject_to_hoa = ?                                ; Subject to HOA
hoa_name = ::if subject_to_hoa = true             ; HOA name
hoa_fee = #$:(0..):if subject_to_hoa = true       ; HOA fee amount
hoa_fee_frequency = (annual, monthly, quarterly, semi_annual):if subject_to_hoa = true
hoa_includes[] = ::if subject_to_hoa = true       ; What HOA fee includes
master_hoa = ?:if subject_to_hoa = true           ; Additional master HOA
master_hoa_fee = #$:(0..):if master_hoa = true    ; Master HOA fee

{@residential_property}

; ───────────────────────────────────────────────────────────────────────────────
; Condominium Specific
; ───────────────────────────────────────────────────────────────────────────────
{.condo}
building_name = ::if property_type = condominium  ; Building name
common_elements = #:(0..100):if property_type = condominium  ; Common element percentage
floor_number = ##:(0..):if property_type = condominium  ; Unit floor number
owner_occupancy_percent = ##:(0..100):if property_type = condominium  ; Building owner occupancy
parking_assigned = ::if property_type = condominium  ; Assigned parking space
storage_assigned = ::if property_type = condominium  ; Assigned storage unit
total_units_building = ##:(0..):if property_type = condominium  ; Total units in building
total_units_project = ##:(0..):if property_type = condominium  ; Total units in project
unit_number = ::if property_type = condominium    ; Unit number

{@residential_property}

; ───────────────────────────────────────────────────────────────────────────────
; Cooperative Specific
; ───────────────────────────────────────────────────────────────────────────────
{.coop}
blanket_mortgage = #$:(0..):if property_type = cooperative  ; Underlying mortgage
maintenance_fee = #$:(0..):if property_type = cooperative  ; Monthly maintenance
shares = ##:(0..):if property_type = cooperative  ; Number of shares
total_shares = ##:(0..):if property_type = cooperative  ; Total shares in coop

{@residential_property}

; ───────────────────────────────────────────────────────────────────────────────
; PUD Specific
; ───────────────────────────────────────────────────────────────────────────────
{.pud}
pud_name = ::if property_type = pud               ; PUD development name
phase = ::if property_type = pud                  ; Development phase

{@residential_property}

; ───────────────────────────────────────────────────────────────────────────────
; Manufactured Home Specific
; ───────────────────────────────────────────────────────────────────────────────
{.manufactured}
attached_to_foundation = ?:if property_type = manufactured  ; Permanently attached
certificate_title = ::if property_type = manufactured  ; Certificate of title
hud_label[] = ::if property_type = manufactured   ; HUD certification label
land_included = ?:if property_type = manufactured ; Land included in sale
make = ::if property_type = manufactured          ; Manufacturer
model = ::if property_type = manufactured         ; Model
serial_number = *::if property_type = manufactured  ; Serial number
width = (double_wide, single_wide, triple_wide):if property_type = manufactured
year = ##:(1900..2100):if property_type = manufactured  ; Year manufactured

{@residential_property}

; ───────────────────────────────────────────────────────────────────────────────
; Multi-Family Specific (2-4 units)
; ───────────────────────────────────────────────────────────────────────────────
{.multifamily}
total_units = ##:(2..4):if property_type = multi_family  ; Total units
unit_mix = ::if property_type = multi_family      ; Unit mix description
owner_occupied_unit = ##:(0..4):if property_type = multi_family  ; Which unit owner occupies
gross_rental_income = #$:(0..):if property_type = multi_family  ; Monthly gross rent
vacancy_rate = #:(0..100):if property_type = multi_family  ; Current vacancy rate

{@residential_property.multifamily.units[]}
unit_number = :                                  ; Unit identifier
bedrooms = ##:(0..)                               ; Bedrooms in unit
bathrooms = #:(0..)                               ; Bathrooms in unit
sqft = ##:(0..)                                   ; Unit square feet
monthly_rent = #$:(0..)                           ; Current monthly rent
occupied = ?                                      ; Currently occupied
lease_end = date                                  ; Current lease end date

{@residential_property}

; ───────────────────────────────────────────────────────────────────────────────
; Condition
; ───────────────────────────────────────────────────────────────────────────────
condition = @re_condition_report                  ; Property condition

; ───────────────────────────────────────────────────────────────────────────────
; Disclosures
; ───────────────────────────────────────────────────────────────────────────────
{.disclosures}
disclosure_provided = ?                           ; Seller disclosure provided
disclosure_date = date:if disclosure_provided = true
lead_paint = ?                                    ; Built before 1978 (lead paint)
lead_paint_disclosure = ?:if lead_paint = true    ; Lead paint disclosure provided
mold_history = ?                                  ; History of mold
pest_history = ?                                  ; History of pest infestation
previous_fire = ?                                 ; Previous fire damage
previous_flood = ?                                ; Previous flood damage
structural_issues = ?                             ; Known structural issues

{@residential_property}

; ───────────────────────────────────────────────────────────────────────────────
; School District
; ───────────────────────────────────────────────────────────────────────────────
{.schools}
district = :                                      ; School district name
elementary = :                                    ; Elementary school
middle = :                                        ; Middle school
high = :                                          ; High school

{@residential_property}

; ───────────────────────────────────────────────────────────────────────────────
; Mortgage Bridge
; ───────────────────────────────────────────────────────────────────────────────
; Reference to mortgage property type for loan integration
mortgage_property_ref = @mtg.property             ; Bridge to mortgage property


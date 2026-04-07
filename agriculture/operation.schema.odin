; ===================================================================================
; ODIN Agriculture Operation Schema
; ===================================================================================
; Farm and ranch operation including land management (tracts, fields, acreage),
; FSA registration, classifications, and operational details.
; ===================================================================================

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.agriculture.operation"
version = "1.0.0"
title = "Agriculture Operation Schema"
description = "Farm and ranch operation with land management and FSA registration"

{$derivation}
source[0].authority = "U.S. Department of Agriculture Farm Service Agency"
source[0].citation = "FSA Handbook 2-CM, Common Land Unit (CLU) Handbook"
source[0].url = "https://www.ecfr.gov/current/title-7/subtitle-B/chapter-VII/subchapter-B/part-718"

source[1].authority = "U.S. Department of Agriculture Farm Service Agency"
source[1].citation = "FSA-578, Report of Acreage"
source[1].url = "https://www.ecfr.gov/current/title-7/subtitle-B/chapter-VII/subchapter-B/part-718"

source[2].authority = "U.S. Department of Agriculture NASS"
source[2].citation = "NASS Farm Operation Classifications"
source[2].url = "https://www.nass.usda.gov/Publications/AgCensus/"

source[3].authority = "U.S. Department of Agriculture NRCS"
source[3].citation = "Land Use and Land Cover Classification System"
source[3].url = "https://www.nrcs.usda.gov/conservation-basics/natural-resource-concerns/land"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial agriculture operation schema"
changelog[0].rationale = "Farm structure derived from FSA CLU, tract, and field requirements"

; ===================================================================================
; FARM OPERATION
; ===================================================================================

{@farm_operation}
= @types.audit_info

; ───────────────────────────────────────────────────────────────────────────────
; Identification
; ───────────────────────────────────────────────────────────────────────────────
operation_id = !:                                ; Unique operation identifier
operation_name = !:                              ; Farm or ranch name
dba_name = :                                     ; Doing business as name

; ───────────────────────────────────────────────────────────────────────────────
; Classification
; ───────────────────────────────────────────────────────────────────────────────
{.classification}
operation_type = (crop, diversified, livestock, mixed, specialty)
farm_type = (beef_cattle, cash_grain, dairy, fruit_tree_nut, general_crop, greenhouse_nursery, hog_pig, poultry_egg, sheep_goat, tobacco, vegetable_melon, other)
primary_commodity = :                            ; Primary commodity produced
organic_certified = ?                            ; USDA organic certified
size_category = (large, medium, small, very_large)

{@farm_operation}

; ───────────────────────────────────────────────────────────────────────────────
; Ownership & Legal Structure
; ───────────────────────────────────────────────────────────────────────────────
{.ownership}
ownership_type = (corporation, estate_trust, family_partnership, individual, joint_operation, llc, partnership)
tax_id = *:                                      ; EIN or SSN (confidential)
naics_code = :(6)                                ; NAICS classification code
legal_entity_name = :                            ; Legal entity name if applicable
state_incorporation = :(2)                       ; State of incorporation

{@farm_operation}

; ───────────────────────────────────────────────────────────────────────────────
; FSA Registration
; ───────────────────────────────────────────────────────────────────────────────
{.fsa}
farm_number = !:                                 ; FSA farm number
state_code = !:(2)                               ; FSA state code
county_code = !:(3)                              ; FSA county code
tract_count = ##:(0..)                           ; Number of tracts
total_acres = #:(0..)                            ; Total farm acres (decimal allowed)
cropland_acres = #:(0..)                         ; Cropland acres
pasture_acres = #:(0..)                          ; Pasture acres
woodland_acres = #:(0..)                         ; Woodland acres
other_acres = #:(0..)                            ; Other acres
beginning_farmer = ?                             ; Beginning farmer status
socially_disadvantaged = ?                       ; Socially disadvantaged status
veteran = ?                                      ; Veteran farmer status
limited_resource = ?                             ; Limited resource farmer

{@farm_operation}

; ───────────────────────────────────────────────────────────────────────────────
; Primary Location
; ───────────────────────────────────────────────────────────────────────────────
{.location}
headquarters_address = @types.address            ; Primary farm address
mailing_address = @types.address                 ; Mailing address if different
county = :                                       ; County name
township = :                                     ; Township if applicable
plss_section = :                                 ; Public Land Survey Section
latitude = #:(-90..90)                           ; GPS latitude
longitude = #:(-180..180)                        ; GPS longitude

{@farm_operation}

; ───────────────────────────────────────────────────────────────────────────────
; Production
; ───────────────────────────────────────────────────────────────────────────────
{.production}
crop_production = ?                              ; Engages in crop production
livestock_production = ?                         ; Engages in livestock production
specialty_production = ?                         ; Specialty crops/products
value_added_products = ?                         ; Produces value-added products
direct_marketing = ?                             ; Direct-to-consumer sales
farmers_market = ?                               ; Sells at farmers market
csa = ?                                          ; Community Supported Agriculture
agritourism = ?                                  ; Agritourism activities

{@farm_operation}

; ───────────────────────────────────────────────────────────────────────────────
; Land Management
; ───────────────────────────────────────────────────────────────────────────────
{.land}
owned_acres = #:(0..)                            ; Owned acres
rented_acres = #:(0..)                           ; Rented acres
leased_acres = #:(0..)                           ; Leased acres
cash_rent_acres = #:(0..)                        ; Cash rent acres
crop_share_acres = #:(0..)                       ; Crop share acres
irrigated_acres = #:(0..)                        ; Irrigated acres
tile_drained_acres = #:(0..)                     ; Tile drained acres
conservation_acres = #:(0..)                     ; Conservation program acres

{@farm_operation}

; ───────────────────────────────────────────────────────────────────────────────
; Infrastructure
; ───────────────────────────────────────────────────────────────────────────────
{.infrastructure}
buildings_count = ##:(0..)                       ; Number of buildings
barn_count = ##:(0..)                            ; Number of barns
silo_count = ##:(0..)                            ; Number of silos
grain_storage_capacity_bu = ##:(0..)             ; Grain storage bushels
well_count = ##:(0..)                            ; Number of wells
pond_count = ##:(0..)                            ; Number of ponds
irrigation_systems[] = :                         ; Irrigation system types
fencing_miles = #:(0..)                          ; Miles of fencing

{@farm_operation}

; ───────────────────────────────────────────────────────────────────────────────
; Operators & Labor
; ───────────────────────────────────────────────────────────────────────────────
{.operators[]}
:(1..)                                           ; At least one operator required
name = !@types.person_name                       ; Operator name
role = (managing_partner, operator, owner, senior_partner)
ownership_percent = #:(0..100)                   ; Ownership percentage
primary_operator = ?                             ; Primary operator flag
days_worked = ##:(0..365)                        ; Days worked on farm per year

{@farm_operation}

{.labor}
family_labor_count = ##:(0..)                    ; Family workers
hired_workers_count = ##:(0..)                   ; Hired workers
seasonal_workers_count = ##:(0..)                ; Seasonal workers
h2a_workers_count = ##:(0..)                     ; H-2A visa workers
contract_labor = ?                               ; Uses contract labor

{@farm_operation}

; ───────────────────────────────────────────────────────────────────────────────
; Financial
; ───────────────────────────────────────────────────────────────────────────────
{.financial}
tax_year = ##:(1900..2100)                       ; Tax year
gross_income = #$                                ; Gross farm income
net_income = #$                                  ; Net farm income
government_payments = #$:(0..)                   ; Government payments received
crop_insurance_indemnity = #$:(0..)              ; Crop insurance indemnities
total_assets = #$:(0..)                          ; Total farm assets
total_liabilities = #$:(0..)                     ; Total farm liabilities
working_capital = #$                             ; Working capital

{@farm_operation}

; ───────────────────────────────────────────────────────────────────────────────
; Tracts
; ───────────────────────────────────────────────────────────────────────────────
tracts[] = @tract                                ; Farm tracts

; ===================================================================================
; TRACT
; ===================================================================================
; FSA tract - continuous parcel under one ownership within a county.

{@tract}
; ───────────────────────────────────────────────────────────────────────────────
; Identification
; ───────────────────────────────────────────────────────────────────────────────
tract_number = !:                                ; FSA tract number
farm_number = !:                                 ; FSA farm number
state_code = !:(2)                               ; FSA state code
county_code = !:(3)                              ; FSA county code
tract_name = :                                   ; Tract name

; ───────────────────────────────────────────────────────────────────────────────
; Ownership
; ───────────────────────────────────────────────────────────────────────────────
{.ownership}
ownership_interest = (cash_rent, crop_share, custom_farming, owned)
owner_name = :                                   ; Landowner name
landlord_name = :                                ; Landlord name if rented
share_percent = #:(0..100)                       ; Ownership/share percentage

{@tract}

; ───────────────────────────────────────────────────────────────────────────────
; Location
; ───────────────────────────────────────────────────────────────────────────────
{.location}
county = :                                       ; County name
township = :                                     ; Township
range = :                                        ; Range
section = :                                      ; Section
quarter_section = :                              ; Quarter section
plss_description = :                             ; PLSS legal description
address = @types.address                         ; Physical address

{@tract}

; ───────────────────────────────────────────────────────────────────────────────
; Acreage
; ───────────────────────────────────────────────────────────────────────────────
{.acreage}
total_acres = !#:(0..)                           ; Total tract acres
cropland_acres = #:(0..)                         ; Cropland acres
pasture_acres = #:(0..)                          ; Pasture acres
woodland_acres = #:(0..)                         ; Woodland acres
wasteland_acres = #:(0..)                        ; Wasteland acres
farmstead_acres = #:(0..)                        ; Farmstead acres
other_acres = #:(0..)                            ; Other acres

{@tract}

; ───────────────────────────────────────────────────────────────────────────────
; Fields
; ───────────────────────────────────────────────────────────────────────────────
fields[] = @field                                ; Fields in this tract
clus[] = @common_land_unit                       ; Common Land Units

; ===================================================================================
; FIELD
; ===================================================================================
; Contiguous area within a tract under uniform crop/management.

{@field}
; ───────────────────────────────────────────────────────────────────────────────
; Identification
; ───────────────────────────────────────────────────────────────────────────────
field_number = !:                                ; Field number within farm
field_name = :                                   ; Field name
tract_number = :                                 ; Parent tract number

; ───────────────────────────────────────────────────────────────────────────────
; Acreage
; ───────────────────────────────────────────────────────────────────────────────
{.acreage}
total_acres = !#:(0..)                           ; Total field acres
planted_acres = #:(0..)                          ; Planted acres
harvested_acres = #:(0..)                        ; Harvested acres
prevented_plant_acres = #:(0..)                  ; Prevented plant acres
failed_acres = #:(0..)                           ; Failed crop acres

{@field}

; ───────────────────────────────────────────────────────────────────────────────
; Soil & Productivity
; ───────────────────────────────────────────────────────────────────────────────
{.soil}
soil_map_unit = :                                ; NRCS soil map unit
soil_type = :                                    ; Primary soil type
soil_class = :                                   ; Land capability class (I-VIII)
productivity_index = #:(0..100)                  ; Soil productivity index
drainage_class = (excessively_drained, moderately_well_drained, poorly_drained, somewhat_poorly_drained, very_poorly_drained, well_drained)
erosion_potential = (high, low, moderate, severe)
ph_level = #:(0..14)                             ; Soil pH

{@field}

; ───────────────────────────────────────────────────────────────────────────────
; Irrigation
; ───────────────────────────────────────────────────────────────────────────────
{.irrigation}
irrigated = ?                                    ; Field is irrigated
irrigation_type = (center_pivot, drip, flood, furrow, micro_sprinkler, side_roll, solid_set, sub_surface)
water_source = (groundwater, municipal, pond, reservoir, river_stream, well)
irrigated_acres = #:(0..)                        ; Irrigated acres
irrigation_capacity_gpm = ##:(0..)               ; Irrigation capacity (gallons per minute)

{@field}

; ───────────────────────────────────────────────────────────────────────────────
; Conservation
; ───────────────────────────────────────────────────────────────────────────────
{.conservation}
conservation_practices[] = :                     ; Conservation practices applied
cover_crop = ?                                   ; Cover crop used
no_till = ?                                      ; No-till practice
reduced_till = ?                                 ; Reduced tillage
contour_farming = ?                              ; Contour farming
strip_cropping = ?                               ; Strip cropping
terraces = ?                                     ; Terraced field
grassed_waterways = ?                            ; Grassed waterways
buffer_strips = ?                                ; Buffer strips
crp_acres = #:(0..)                              ; CRP enrolled acres

{@field}

; ───────────────────────────────────────────────────────────────────────────────
; Location
; ───────────────────────────────────────────────────────────────────────────────
{.location}
latitude = #:(-90..90)                           ; Center point latitude
longitude = #:(-180..180)                        ; Center point longitude
elevation_ft = ##                                ; Elevation in feet
boundary_coordinates[] = @geo_coordinate         ; Field boundary polygon

{@field}

; ===================================================================================
; COMMON LAND UNIT (CLU)
; ===================================================================================
; FSA Common Land Unit - smallest unit of land with permanent boundaries.

{@common_land_unit}
; ───────────────────────────────────────────────────────────────────────────────
; Identification
; ───────────────────────────────────────────────────────────────────────────────
clu_number = !:                                  ; FSA CLU identifier
state_code = !:(2)                               ; State FIPS code
county_code = !:(3)                              ; County FIPS code
farm_number = :                                  ; FSA farm number
tract_number = :                                 ; FSA tract number

; ───────────────────────────────────────────────────────────────────────────────
; Acreage & Classification
; ───────────────────────────────────────────────────────────────────────────────
{.acreage}
calculated_acres = !#:(0..)                      ; GIS calculated acres
reported_acres = #:(0..)                         ; Reported acres
land_use = (barren, cropland, forest, idle, orchard, other, pasture, range, urban, water, wetland)
hel = ?                                          ; Highly erodible land
wetland = ?                                      ; Wetland determination

{@common_land_unit}

; ───────────────────────────────────────────────────────────────────────────────
; Boundary
; ───────────────────────────────────────────────────────────────────────────────
{.boundary}
boundary_type = (fence, legal_description, natural, road, survey)
boundary_coordinates[] = @geo_coordinate         ; CLU boundary polygon

{@common_land_unit}

; ───────────────────────────────────────────────────────────────────────────────
; History
; ───────────────────────────────────────────────────────────────────────────────
{.history}
last_update_date = date                          ; Last CLU update
last_crop = :                                    ; Last reported crop
crop_year = ##:(1900..2100)                      ; Crop year

; ===================================================================================
; GEO COORDINATE
; ===================================================================================
; Geographic coordinate for boundaries.

{@geo_coordinate}
latitude = !#:(-90..90)                          ; Latitude
longitude = !#:(-180..180)                       ; Longitude
elevation_ft = ##                                ; Elevation in feet
sequence = ##:(1..)                              ; Point sequence in polygon

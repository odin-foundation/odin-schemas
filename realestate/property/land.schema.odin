; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Land Property Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Vacant land, agricultural, ranch, timber, development, and recreational
; property information. Covers topography, soil, water resources, access,
; utilities, mineral rights, and environmental factors along with
; type-specific details for agriculture, ranching, timber, and development.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as common
@import "../types.schema.odin" as re

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.realestate.property.land"
version = "1.0.0"
title = "Land Property Schema"
description = "Comprehensive vacant land and agricultural property information"

{$derivation}
source[0].authority = "USDA"
source[0].citation = "Farm Service Agency Land Classification"
source[0].url = "https://www.fsa.usda.gov/"

source[1].authority = "Bureau of Land Management"
source[1].citation = "Land Classification System"
source[1].url = "https://www.blm.gov/"

source[2].authority = "Natural Resources Conservation Service"
source[2].citation = "Soil Survey"
source[2].url = "https://www.nrcs.usda.gov/wps/portal/nrcs/main/soils/survey/"

source[3].authority = "Appraisal Institute"
source[3].citation = "The Appraisal of Rural Property"
source[3].url = "https://www.appraisalinstitute.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Land property schema derived from USDA and appraisal industry standards"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial land property schema"
changelog[0].rationale = "Comprehensive property structure for land transactions"

; ═══════════════════════════════════════════════════════════════════════════════
; LAND PROPERTY
; ═══════════════════════════════════════════════════════════════════════════════

{@land_property}
; Required fields first
address = @address                               ; Property address (may be general)
land_type = (agricultural, commercial_land, development, industrial_land, ranch, recreational, residential_land, timber, transitional)

; Property identification
property_id = :                                   ; Unique property identifier
property_name = :                                 ; Property/tract name

; ───────────────────────────────────────────────────────────────────────────────
; Legal Description
; ───────────────────────────────────────────────────────────────────────────────
legal_description = @re_legal_description         ; Legal description
parcel = @re_parcel_identifiers                   ; Tax and recording identifiers

{@land_property}

; ───────────────────────────────────────────────────────────────────────────────
; Land Size
; ───────────────────────────────────────────────────────────────────────────────
{.size}
total_acres = #:(0..)                            ; Total acreage
deeded_acres = #:(0..)                            ; Deeded acres
leased_acres = #:(0..)                            ; Leased acres (grazing rights, etc.)
surveyed = ?                                      ; Property has been surveyed
surveyed_acres = #:(0..):if surveyed = true       ; Surveyed acreage
sqft = ##:(0..)                                   ; Size in square feet (smaller parcels)

{@land_property}

; ───────────────────────────────────────────────────────────────────────────────
; Topography and Terrain
; ───────────────────────────────────────────────────────────────────────────────
{.topography}
terrain = (flat, gently_rolling, hilly, mountainous, rolling, steep)
elevation_low = ##                                ; Lowest elevation feet
elevation_high = ##                               ; Highest elevation feet
elevation_average = ##                            ; Average elevation feet
slope_percent = #:(0..100)                        ; Average slope percentage
flood_plain_acres = #:(0..)                       ; Acres in flood plain
wetland_acres = #:(0..)                           ; Wetland acres
wooded_acres = #:(0..)                            ; Wooded/forested acres
cleared_acres = #:(0..)                           ; Cleared/open acres
pasture_acres = #:(0..)                           ; Pasture acres

{@land_property}

; ───────────────────────────────────────────────────────────────────────────────
; Soil
; ───────────────────────────────────────────────────────────────────────────────
{.soil}
soil_types[] = :                                  ; Soil type names
primary_soil = :                                  ; Primary soil type
soil_class = :                                    ; Soil capability class (I-VIII)
prime_farmland = ?                                ; Contains prime farmland
prime_farmland_acres = #:(0..):if prime_farmland = true
percolation_rate = #:(0..)                        ; Perc rate (for septic)
septic_suitable = ?                               ; Suitable for septic system
drainage = (excellent, fair, good, poor)          ; Drainage quality

{@land_property}

; ───────────────────────────────────────────────────────────────────────────────
; Water Resources
; ───────────────────────────────────────────────────────────────────────────────
{.water}
creek = ?                                         ; Creek on property
creek_name = ::if creek = true                    ; Creek name
lake = ?                                          ; Lake or pond on property
lake_acres = #:(0..):if lake = true               ; Lake/pond size
river = ?                                         ; River frontage
river_name = ::if river = true                    ; River name
river_frontage_feet = #:(0..):if river = true     ; River frontage
spring = ?                                        ; Natural spring
water_frontage = ?                                ; Any water frontage
water_rights = ?                                  ; Includes water rights
water_rights_type = (adjudicated, appropriative, riparian):if water_rights = true
water_rights_acre_feet = #:(0..):if water_rights = true
well = ?                                          ; Existing well
well_depth = ##:(0..):if well = true              ; Well depth feet
well_gpm = #:(0..):if well = true                 ; Well gallons per minute

{@land_property}

; ───────────────────────────────────────────────────────────────────────────────
; Access
; ───────────────────────────────────────────────────────────────────────────────
{.access}
road_access = ?                                   ; Has road access
road_type = (county, easement, private, state, unimproved):if road_access = true
road_surface = (asphalt, concrete, dirt, gravel):if road_access = true
road_frontage_feet = #:(0..):if road_access = true
easement_access = ?                               ; Access via easement
easement_recorded = ?:if easement_access = true   ; Easement is recorded
landlocked = ?                                    ; No current access
year_round_access = ?                             ; Accessible year-round

{@land_property}

; ───────────────────────────────────────────────────────────────────────────────
; Utilities
; ───────────────────────────────────────────────────────────────────────────────
{.utilities}
electric_available = ?                            ; Electric at property
electric_distance = ##:(0..):if electric_available = false  ; Distance to electric (feet)
gas_available = ?                                 ; Natural gas at property
gas_distance = ##:(0..):if gas_available = false  ; Distance to gas (feet)
internet_available = ?                            ; Internet available
municipal_sewer = ?                               ; Municipal sewer at property
municipal_water = ?                               ; Municipal water at property
phone_available = ?                               ; Phone service available
water_distance = ##:(0..):if municipal_water = false  ; Distance to water (feet)

{@land_property}

; ───────────────────────────────────────────────────────────────────────────────
; Zoning
; ───────────────────────────────────────────────────────────────────────────────
zoning = @re_zoning                               ; Zoning information

; Additional zoning for land
{.zoning_details}
etj = ?                                           ; In Extra-Territorial Jurisdiction
jurisdiction = :                                  ; Governing jurisdiction
minimum_lot_size = #:(0..)                        ; Minimum lot size acres
subdivision_restrictions = ?                      ; Subdivision restrictions
mobile_homes_allowed = ?                          ; Mobile homes permitted
livestock_allowed = ?                             ; Livestock permitted
commercial_allowed = ?                            ; Commercial use permitted
industrial_allowed = ?                            ; Industrial use permitted

{@land_property}

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

{@land_property}

; ───────────────────────────────────────────────────────────────────────────────
; Improvements
; ───────────────────────────────────────────────────────────────────────────────
{.improvements}
improved = ?                                      ; Improvements on land
fencing = ?                                       ; Fencing present
fence_type = ::if fencing = true                  ; Fence type (barbed wire, etc.)
fence_condition = (excellent, fair, good, needs_work, poor):if fencing = true
barn = ?                                          ; Barn on property
barn_sqft = ##:(0..):if barn = true               ; Barn size
outbuildings_count = ##:(0..)                     ; Other outbuildings
residence = ?                                     ; Residence on property
residence_sqft = ##:(0..):if residence = true     ; Residence size
irrigation = ?                                    ; Irrigation system
irrigation_type = (center_pivot, drip, flood, sprinkler):if irrigation = true
irrigated_acres = #:(0..):if irrigation = true    ; Irrigated acres

{@land_property}

; ───────────────────────────────────────────────────────────────────────────────
; Agricultural Specific
; ───────────────────────────────────────────────────────────────────────────────
{.agricultural}
current_use = ::if land_type = agricultural       ; Current agricultural use
crops[] = ::if land_type = agricultural           ; Crops grown
crop_history = ::if land_type = agricultural      ; Crop history
fsa_farm_number = ::if land_type = agricultural   ; FSA farm number
base_acres = #:(0..):if land_type = agricultural  ; Base acres (government programs)
crp_enrolled = ?:if land_type = agricultural      ; Conservation Reserve Program
crp_acres = #:(0..):if crp_enrolled = true        ; CRP acres
crp_expiration = date:if crp_enrolled = true      ; CRP contract expiration
tillable_acres = #:(0..):if land_type = agricultural  ; Tillable acres
dryland_acres = #:(0..):if land_type = agricultural   ; Dryland crop acres
organic_certified = ?:if land_type = agricultural ; Organic certification

{@land_property}

; ───────────────────────────────────────────────────────────────────────────────
; Ranch Specific
; ───────────────────────────────────────────────────────────────────────────────
{.ranch}
carrying_capacity = ##:(0..):if land_type = ranch ; Animal units
au_per_acre = #:(0..):if land_type = ranch        ; Animal units per acre
grazing_lease = ?:if land_type = ranch            ; Active grazing lease
grazing_lease_income = #$:(0..):if grazing_lease = true
hunting_lease = ?:if land_type = ranch            ; Active hunting lease
hunting_lease_income = #$:(0..):if hunting_lease = true
livestock_facilities = ?:if land_type = ranch     ; Livestock working facilities
pens = ?:if land_type = ranch                     ; Cattle pens
chutes = ?:if land_type = ranch                   ; Working chutes
scales = ?:if land_type = ranch                   ; Livestock scales

{@land_property}

; ───────────────────────────────────────────────────────────────────────────────
; Timber Specific
; ───────────────────────────────────────────────────────────────────────────────
{.timber}
timber_acres = #:(0..):if land_type = timber      ; Acres in timber
timber_types[] = ::if land_type = timber          ; Tree species
mbf_estimate = ##:(0..):if land_type = timber     ; Thousand board feet estimate
timber_cruise_date = date:if land_type = timber   ; Date of timber cruise
age_class = ::if land_type = timber               ; Age class distribution
harvest_history = ::if land_type = timber         ; Harvest history
reforestation = ?:if land_type = timber           ; Active reforestation
timber_management_plan = ?:if land_type = timber  ; Has management plan

{@land_property}

; ───────────────────────────────────────────────────────────────────────────────
; Development Specific
; ───────────────────────────────────────────────────────────────────────────────
{.development}
entitled = ?:if land_type = development           ; Entitlements in place
entitlements[] = ::if entitled = true             ; List of entitlements
approved_units = ##:(0..):if land_type = development  ; Approved residential units
approved_commercial_sqft = ##:(0..):if land_type = development  ; Approved commercial sqft
infrastructure_complete = ?:if land_type = development  ; Infrastructure installed
phase = ::if land_type = development              ; Development phase
plat_approved = ?:if land_type = development      ; Plat approved
site_plan_approved = ?:if land_type = development ; Site plan approved
pud = ?:if land_type = development                ; Planned unit development
impact_fees_paid = ?:if land_type = development   ; Impact fees paid
utility_agreements = ?:if land_type = development ; Utility agreements in place

{@land_property}

; ───────────────────────────────────────────────────────────────────────────────
; Recreational Specific
; ───────────────────────────────────────────────────────────────────────────────
{.recreational}
game_present[] = ::if land_type = recreational    ; Wildlife present
hunting_allowed = ?:if land_type = recreational   ; Hunting permitted
fishing_available = ?:if land_type = recreational ; Fishing available
trails = ?:if land_type = recreational            ; Has trails
atv_access = ?:if land_type = recreational        ; ATV use permitted
high_fence = ?:if land_type = recreational        ; High-fenced property
game_management = ?:if land_type = recreational   ; Active game management
duck_blinds = ##:(0..):if land_type = recreational  ; Number of duck blinds
food_plots_acres = #:(0..):if land_type = recreational  ; Food plot acres

{@land_property}

; ───────────────────────────────────────────────────────────────────────────────
; Mineral Rights
; ───────────────────────────────────────────────────────────────────────────────
{.minerals}
mineral_rights_convey = ?                         ; Mineral rights convey with sale
mineral_rights_percent = #:(0..100):if mineral_rights_convey = true  ; Percentage conveying
current_lease = ?                                 ; Active mineral lease
current_lessee = ::if current_lease = true        ; Current lessee
lease_expiration = date:if current_lease = true   ; Lease expiration
production = ?                                    ; Active production
production_type = (gas, oil, other):if production = true
royalty_rate = #:(0..100):if production = true    ; Royalty rate
wind_rights = ?                                   ; Wind rights included
solar_rights = ?                                  ; Solar rights included

{@land_property}

; ───────────────────────────────────────────────────────────────────────────────
; Environmental
; ───────────────────────────────────────────────────────────────────────────────
{.environmental}
endangered_species = ?                            ; Known endangered species
endangered_species_type = ::if endangered_species = true
environmental_restrictions = ?                    ; Environmental restrictions
restriction_description = ::if environmental_restrictions = true
phase_i_complete = ?                              ; Phase I ESA complete
phase_i_date = date:if phase_i_complete = true    ; Phase I date
recognized_environmental_conditions = ?:if phase_i_complete = true
contamination = ?                                 ; Known contamination
remediation_required = ?:if contamination = true  ; Remediation required

{@land_property}

; ───────────────────────────────────────────────────────────────────────────────
; Property Status
; ───────────────────────────────────────────────────────────────────────────────
status = @re_property_status                      ; Current property status

; ───────────────────────────────────────────────────────────────────────────────
; Income (if income-producing)
; ───────────────────────────────────────────────────────────────────────────────
{.income}
income_producing = ?                              ; Property produces income
annual_gross_income = #$:(0..):if income_producing = true
annual_expenses = #$:(0..):if income_producing = true
annual_net_income = #$:if income_producing = true  ; Can be negative
income_sources[] = ::if income_producing = true   ; Description of income sources

{@land_property}

; ───────────────────────────────────────────────────────────────────────────────
; Valuation
; ───────────────────────────────────────────────────────────────────────────────
{.valuation}
price_per_acre = #$:(0..)                         ; Listed/sold price per acre
assessed_value_per_acre = #$:(0..)                ; Assessed value per acre
comparable_sales[] = :                            ; Reference to comparable sales
appraisal_date = date                             ; Date of appraisal
appraised_value = #$:(0..)                        ; Appraised value

{@land_property}


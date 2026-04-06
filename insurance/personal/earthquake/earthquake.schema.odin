; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Insurance - Earthquake Insurance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Earthquake insurance covering residential and personal property damage from
; seismic events including dwelling, contents, loss of use, and additional
; living expenses with percentage-based deductibles.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.earthquake"
version = "1.0.0"
title = "Earthquake Insurance Policy Schema"
description = "Personal earthquake insurance policy derived from CEA, FEMA, USGS, and building code sources"

{$derivation}
source[0].authority = "California Earthquake Authority (CEA)"
source[0].citation = "CEA Residential Policy Forms and Endorsements"
source[0].url = "https://www.earthquakeauthority.com/Policy/Policy-Forms"

source[1].authority = "California Earthquake Authority (CEA)"
source[1].citation = "CEA Rate Filing Documentation"
source[1].url = "https://www.insurance.ca.gov/0250-insurers/0300-insurers/0200-filings/earthquake/"

source[2].authority = "California Department of Insurance"
source[2].citation = "Earthquake Insurance Regulations"
source[2].url = "https://www.insurance.ca.gov/01-consumers/105-type/95-guides/09-eq/"

source[3].authority = "United States Geological Survey (USGS)"
source[3].citation = "National Seismic Hazard Maps"
source[3].url = "https://www.usgs.gov/programs/earthquake-hazards/science/national-seismic-hazard-maps"

source[4].authority = "International Code Council"
source[4].citation = "Uniform Building Code (UBC) Seismic Zones"
source[4].url = "https://codes.iccsafe.org/"

source[5].authority = "American Society of Civil Engineers (ASCE)"
source[5].citation = "ASCE 7 Seismic Design Categories"
source[5].url = "https://www.asce.org/publications-and-news/asce-7"

source[6].authority = "Federal Emergency Management Agency (FEMA)"
source[6].citation = "HAZUS Earthquake Model Technical Manual"
source[6].url = "https://www.fema.gov/flood-maps/products-tools/hazus"

source[7].authority = "Insurance Services Office (ISO)"
source[7].citation = "Earthquake Territory Definitions (Public Filing)"
source[7].url = "https://www.verisk.com/insurance/products/iso-products/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-20
changelog[0].change = "Initial earthquake insurance schema"
changelog[0].rationale = "Earthquake policy structures derived from CEA, FEMA, USGS, and building code public sources"

; ═══════════════════════════════════════════════════════════════════════════════
; SEISMIC ZONE
; ═══════════════════════════════════════════════════════════════════════════════
; Seismic zone classification based on USGS hazard maps, UBC zones, and ASCE
; seismic design categories. Zone determines base rates and availability.

{@earthquake_zone}
; UBC seismic zones (legacy but still used in insurance)
ubc_zone = (zone_0, zone_1, zone_2a, zone_2b, zone_3, zone_4)
; ASCE 7 seismic design category (current standard)
asce_category = (category_a, category_b, category_c, category_d, category_d0, category_d1, category_d2, category_e, category_f)
; ISO earthquake territory (1-10)
iso_territory = ##:(1..10)                          ; ISO territory number
; USGS peak ground acceleration (PGA) at site
pga_2_percent_50_year = #:(0..)                     ; PGA with 2% probability of exceedance in 50 years (g)
pga_10_percent_50_year = #:(0..)                    ; PGA with 10% probability of exceedance in 50 years (g)
; State-specific zone (e.g., CEA zones)
state_zone = :                                      ; State-specific zone identifier
state_zone_description = :                          ; Zone description
; Distance to known fault
nearest_fault_name = :                              ; Name of nearest mapped fault
nearest_fault_distance_miles = #:(0..)              ; Distance to nearest fault in miles

; ═══════════════════════════════════════════════════════════════════════════════
; SOIL CLASSIFICATION
; ═══════════════════════════════════════════════════════════════════════════════
; Soil type affects ground motion amplification and liquefaction risk.
; Based on NEHRP/ASCE site classifications.

{@earthquake_soil}
; NEHRP/ASCE site class (A-F)
site_class = !(site_class_a, site_class_b, site_class_bc, site_class_c, site_class_cd, site_class_d, site_class_de, site_class_e, site_class_f)
site_class_description = :                          ; Site class description
; Shear wave velocity
vs30 = #:(0..)                                      ; Average shear wave velocity in top 30m (m/s)
; Liquefaction susceptibility
liquefaction_susceptibility = (high, low, moderate, none, very_high)
; Landslide susceptibility
landslide_susceptibility = (high, low, moderate, none, very_high)
; Soil report available
geotechnical_report_available = ?                   ; Site-specific geotechnical report on file
geotechnical_report_date = timestamp                ; Date of geotechnical report

; ═══════════════════════════════════════════════════════════════════════════════
; FOUNDATION TYPE
; ═══════════════════════════════════════════════════════════════════════════════
; Foundation construction significantly affects seismic vulnerability.
; Cripple walls and unreinforced masonry are high-risk features.

{@earthquake_foundation}
; Foundation type
type = !(basement, crawlspace, hillside, pier_and_beam, raised, slab_on_grade)
; Cripple wall (short wood-stud wall between foundation and first floor)
cripple_wall = ?                                    ; Has cripple wall
cripple_wall_height_inches = ##:(0..)               ; Height of cripple wall in inches
cripple_wall_braced = ?                             ; Cripple wall has been braced
; Foundation anchorage
foundation_bolted = ?                               ; Structure bolted to foundation
bolt_spacing_inches = ##:(0..)                      ; Spacing between foundation bolts
; Stem wall
stem_wall_height_inches = ##:(0..)                  ; Height of stem wall
; Hillside construction
hillside_percent_grade = #:(0..100)                 ; Hillside grade percentage
downhill_side_open = ?                              ; Open on downhill side (stilts/posts)
; Basement details
basement_type = (daylight, full, partial, walkout)  ; Type of basement
basement_finished = ?                               ; Basement is finished living space

; ═══════════════════════════════════════════════════════════════════════════════
; BUILDING FRAME
; ═══════════════════════════════════════════════════════════════════════════════
; Structural frame type is a primary rating factor. Wood frame typically
; performs better than unreinforced masonry in seismic events.

{@earthquake_frame}
; Primary structural system
type = !(concrete_frame, light_metal_frame, masonry_bearing_wall, steel_frame, wood_frame)
; Construction details
exterior_walls = (brick_veneer, concrete, hardboard, metal, stucco, vinyl, wood)
; Masonry characteristics (high risk if unreinforced)
masonry_construction = ?                            ; Contains masonry construction
masonry_reinforced = ?                              ; Masonry is reinforced
unreinforced_masonry_area_sqft = ##:(0..)           ; Square footage of URM
; Soft story (parking/commercial on ground floor)
soft_story = ?                                      ; Has soft story condition
soft_story_retrofitted = ?                          ; Soft story has been retrofitted
; Chimney
chimney_present = ?                                 ; Has chimney
chimney_type = (factory_built, masonry_exterior, masonry_interior)
chimney_reinforced = ?                              ; Chimney is reinforced
chimney_braced = ?                                  ; Chimney is braced to structure

; ═══════════════════════════════════════════════════════════════════════════════
; EARTHQUAKE PROPERTY
; ═══════════════════════════════════════════════════════════════════════════════
; Complete property description for earthquake insurance rating.

{@earthquake_property}
; Required property identifiers
address = !@address                                 ; Property address
; Building characteristics
year_built = !##:(1800..2100)                       ; Year structure was built
building_code_era = (pre_1933, 1933_1948, 1949_1975, 1976_1990, 1991_2000, 2001_present)
stories = !##:(1..)                                 ; Number of stories
total_square_feet = !##:(1..)                       ; Total square footage
; Construction
frame = !@earthquake_frame                          ; Building frame details
foundation = !@earthquake_foundation                ; Foundation details
; Seismic hazard
zone = @earthquake_zone                             ; Seismic zone information
soil = @earthquake_soil                             ; Soil classification
; Structure type
structure_type = (condo_unit, manufactured_home, mobile_home, single_family, townhouse)
occupancy = (owner_occupied, rental, seasonal, secondary, vacant)
; Special features
swimming_pool = ?                                   ; Has swimming pool
pool_type = (above_ground, in_ground)               ; Pool construction
hot_tub_spa = ?                                     ; Has hot tub or spa
; Water heater (can cause fire/water damage if not strapped)
water_heater_strapped = ?                           ; Water heater properly strapped
water_heater_type = (electric, gas, solar, tankless)

{.other_structures}
; Other structures on property (Coverage B)
detached_garage = ?                                 ; Detached garage present
detached_garage_sqft = ##:(0..)                     ; Detached garage square footage
guest_house = ?                                     ; Guest house present
guest_house_sqft = ##:(0..)                         ; Guest house square footage
pool_house = ?                                      ; Pool house present
shed_outbuilding = ?                                ; Shed or outbuilding present
fence_wall = ?                                      ; Fence or retaining wall
total_other_structures_value = #$:(0..)             ; Total value of other structures

{@earthquake_property}

; ═══════════════════════════════════════════════════════════════════════════════
; RETROFIT STATUS
; ═══════════════════════════════════════════════════════════════════════════════
; Seismic retrofits reduce vulnerability and earn premium credits.
; Based on CEA retrofit discount program and FEMA P-50 guidelines.

{@earthquake_retrofit}
; Foundation bolting (most common retrofit)
foundation_bolting = ?                              ; Foundation bolting completed
foundation_bolting_date = timestamp                 ; Date of foundation bolting
foundation_bolting_permit = :                       ; Building permit number
foundation_bolting_contractor = :                   ; Licensed contractor name
foundation_bolting_contractor_license = :           ; Contractor license number
; Cripple wall bracing
cripple_wall_bracing = ?                            ; Cripple wall bracing completed
cripple_wall_bracing_date = timestamp               ; Date of cripple wall bracing
cripple_wall_bracing_permit = :                     ; Building permit number
; Combined brace and bolt (CEA EBB program)
brace_and_bolt_completed = ?                        ; Both brace and bolt completed
brace_and_bolt_program = (cea_ebb, fema_hmgp, local_program, private)
; Soft story retrofit
soft_story_retrofit = ?                             ; Soft story retrofit completed
soft_story_retrofit_date = timestamp                ; Date of soft story retrofit
soft_story_retrofit_permit = :                      ; Building permit number
; Water heater strapping
water_heater_strapping = ?                          ; Water heater strapping completed
water_heater_strapping_date = timestamp             ; Date of strapping
; Chimney bracing
chimney_bracing = ?                                 ; Chimney bracing completed
chimney_bracing_date = timestamp                    ; Date of chimney bracing
; Automatic gas shutoff valve
gas_shutoff_valve = ?                               ; Automatic gas shutoff valve installed
gas_shutoff_valve_date = timestamp                  ; Date of installation
; Total retrofit investment
total_retrofit_cost = #$:(0..)                      ; Total cost of all retrofits
; Retrofit inspection
retrofit_inspected = ?                              ; Retrofit professionally inspected
inspection_date = timestamp                         ; Date of inspection
inspector_name = :                                  ; Inspector name
inspector_certification = :                         ; Inspector certification number

; ═══════════════════════════════════════════════════════════════════════════════
; COVERAGE STRUCTURE
; ═══════════════════════════════════════════════════════════════════════════════
; Earthquake coverage follows standard Coverage A/B/C/D structure.
; CEA policies use percentage deductibles (5%, 10%, 15%, 20%, 25%).

{@earthquake_coverage}
; Coverage A - Dwelling
coverage_a_dwelling = !#$:(0..)                     ; Dwelling limit
coverage_a_deductible_percent = !#:(5..25)          ; Deductible as percentage of Coverage A
coverage_a_deductible_amount = #$:(0..)             ; Calculated deductible amount
; Coverage B - Other Structures
coverage_b_other_structures = #$:(0..)              ; Other structures limit
coverage_b_included = ?                             ; Other structures coverage included
coverage_b_percent_of_a = #:(0..100)                ; Percentage of Coverage A
; Coverage C - Personal Property (Contents)
coverage_c_contents = #$:(0..)                      ; Contents limit
coverage_c_included = ?                             ; Contents coverage included
coverage_c_deductible_percent = #:(5..25)           ; Contents deductible percentage
coverage_c_deductible_amount = #$:(0..)             ; Calculated contents deductible
; Coverage D - Loss of Use (Additional Living Expenses)
coverage_d_loss_of_use = #$:(0..)                   ; Loss of use limit
coverage_d_included = ?                             ; Loss of use coverage included
coverage_d_waiting_period_days = ##:(0..)           ; Waiting period before coverage begins
; Breakables coverage (optional - CEA)
breakables_included = ?                             ; Breakables coverage included
breakables_limit = #$:(0..)                         ; Breakables coverage limit
; Masonry veneer coverage
masonry_veneer_included = ?                         ; Masonry veneer coverage included
masonry_veneer_limit = #$:(0..)                     ; Masonry veneer limit
; Emergency repairs
emergency_repairs_limit = #$:(0..)                  ; Limit for emergency repairs
; Building code upgrade
building_code_upgrade_included = ?                  ; Building code upgrade coverage
building_code_upgrade_limit = #$:(0..)              ; Building code upgrade limit
building_code_upgrade_percent = #:(0..100)          ; Percentage of dwelling limit
; Loss assessment (condos)
loss_assessment_included = ?                        ; Loss assessment coverage included
loss_assessment_limit = #$:(0..)                    ; Loss assessment limit

; ═══════════════════════════════════════════════════════════════════════════════
; RATING FACTORS
; ═══════════════════════════════════════════════════════════════════════════════
; Earthquake insurance rating factors derived from CEA rate filings
; and ISO earthquake rating methodologies.

{@earthquake_rating}
; Base rate factors
territory_factor = !#:(0..)                         ; Territory/zone factor
soil_factor = #:(0..)                               ; Soil amplification factor
construction_factor = #:(0..)                       ; Construction type factor
age_factor = #:(0..)                                ; Building age factor
stories_factor = #:(0..)                            ; Number of stories factor
; Foundation factors
foundation_type_factor = #:(0..)                    ; Foundation type factor
cripple_wall_factor = #:(0..)                       ; Cripple wall factor (surcharge)
hillside_factor = #:(0..)                           ; Hillside construction factor
; Retrofit credits
foundation_bolting_credit = #:(0..1)                ; Credit for foundation bolting
cripple_wall_bracing_credit = #:(0..1)              ; Credit for cripple wall bracing
brace_and_bolt_credit = #:(0..1)                    ; Combined brace and bolt credit
soft_story_retrofit_credit = #:(0..1)               ; Soft story retrofit credit
water_heater_credit = #:(0..1)                      ; Water heater strapping credit
gas_shutoff_credit = #:(0..1)                       ; Gas shutoff valve credit
; Other factors
masonry_surcharge = #:(0..)                         ; Unreinforced masonry surcharge
chimney_surcharge = #:(0..)                         ; Masonry chimney surcharge
soft_story_surcharge = #:(0..)                      ; Soft story surcharge
; Deductible factor
deductible_factor = #:(0..)                         ; Factor based on deductible selection
; Calculated premium
base_premium = #$:(0..)                             ; Base premium before adjustments
adjusted_premium = #$:(0..)                         ; Premium after all factors
policy_fee = #$:(0..)                               ; Policy fee
total_premium = #$:(0..)                            ; Total premium including fees

; ═══════════════════════════════════════════════════════════════════════════════
; EARTHQUAKE CLAIM
; ═══════════════════════════════════════════════════════════════════════════════
; Earthquake claim structure including damage assessment and loss calculation.

{@earthquake_claim}
; Claim identification
claim_number = !:                                   ; Unique claim identifier
policy_number = !:                                  ; Associated policy number
; Event information
event_date = !timestamp                             ; Date and time of earthquake
event_magnitude = #:(0..10)                         ; Earthquake magnitude (Richter/moment)
event_epicenter_latitude = #:(-90..90)              ; Epicenter latitude
event_epicenter_longitude = #:(-180..180)           ; Epicenter longitude
event_epicenter_depth_km = #:(0..)                  ; Depth of earthquake in km
event_name = :                                      ; Named earthquake event
usgs_event_id = :                                   ; USGS earthquake event ID
; Claim dates
date_of_loss = !timestamp                           ; Date loss occurred
date_reported = !timestamp                          ; Date claim reported
date_inspected = timestamp                          ; Date property inspected
date_closed = timestamp                             ; Date claim closed
; Claim status
status = !(closed_no_payment, closed_paid, denied, in_review, open, reopened, under_investigation)
; Damage description
damage_description = :                              ; Description of damage
; Property damage assessment
dwelling_damage = ?                                 ; Dwelling damage present
dwelling_damage_description = :                     ; Description of dwelling damage
dwelling_damage_severity = (catastrophic, major, minor, moderate, none)
other_structures_damage = ?                         ; Other structures damage present
other_structures_damage_description = :             ; Description of other structures damage
contents_damage = ?                                 ; Contents damage present
contents_damage_description = :                     ; Description of contents damage

{.structural_damage}
; Detailed structural damage assessment
foundation_damage = ?                               ; Foundation damage
foundation_damage_type = (cracking, displacement, settlement, shearing)
cripple_wall_damage = ?                             ; Cripple wall damage
chimney_damage = ?                                  ; Chimney damage
chimney_damage_type = (collapse, cracking, separation)
wall_damage = ?                                     ; Wall damage
wall_damage_type = (cracking, separation, shear_failure)
roof_damage = ?                                     ; Roof damage
garage_damage = ?                                   ; Garage damage (soft story)

{@earthquake_claim}

{.loss_amounts}
; Loss amounts by coverage
coverage_a_loss = #$:(0..)                          ; Dwelling loss amount
coverage_a_deductible = #$:(0..)                    ; Dwelling deductible applied
coverage_a_payment = #$:(0..)                       ; Dwelling payment
coverage_b_loss = #$:(0..)                          ; Other structures loss amount
coverage_b_payment = #$:(0..)                       ; Other structures payment
coverage_c_loss = #$:(0..)                          ; Contents loss amount
coverage_c_deductible = #$:(0..)                    ; Contents deductible applied
coverage_c_payment = #$:(0..)                       ; Contents payment
coverage_d_loss = #$:(0..)                          ; Loss of use expenses
coverage_d_payment = #$:(0..)                       ; Loss of use payment
emergency_repairs_payment = #$:(0..)                ; Emergency repairs payment
total_loss = #$:(0..)                               ; Total loss amount
total_deductible = #$:(0..)                         ; Total deductible applied
total_payment = #$:(0..)                            ; Total claim payment

{@earthquake_claim}

; Inspection
inspector_name = :                                  ; Claims inspector name
inspector_company = :                               ; Inspection company
inspection_report_id = :                            ; Inspection report reference
; Additional claim details
temporary_housing_required = ?                      ; Temporary housing needed
temporary_housing_start_date = timestamp            ; Start of temporary housing
temporary_housing_end_date = timestamp              ; End of temporary housing
; Subrogation (rare for earthquake)
subrogation_potential = ?                           ; Subrogation potential exists
subrogation_target = :                              ; Subrogation target (if any)

; ═══════════════════════════════════════════════════════════════════════════════
; ENDORSEMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Earthquake policy endorsements for coverage modifications.

{@earthquake_endorsement}
; Endorsement identification
endorsement_number = !:                             ; Unique endorsement identifier
endorsement_type = !(additional_coverage, coverage_change, deductible_change, exclusion, limit_change, premium_adjustment, property_change, retrofit_credit)
effective_date = !timestamp                         ; Endorsement effective date
; Endorsement details
description = !:                                    ; Description of change
reason = :                                          ; Reason for endorsement
; Premium impact
premium_change = #$                                 ; Change in premium (can be negative)
new_total_premium = #$:(0..)                        ; New total premium after endorsement
; Coverage changes
coverage_a_change = #$                              ; Change to Coverage A limit
coverage_b_change = #$                              ; Change to Coverage B limit
coverage_c_change = #$                              ; Change to Coverage C limit
coverage_d_change = #$                              ; Change to Coverage D limit
deductible_change = #                               ; Change to deductible percentage
; New coverage values (after endorsement)
new_coverage_a = #$:(0..)                           ; New Coverage A limit
new_coverage_b = #$:(0..)                           ; New Coverage B limit
new_coverage_c = #$:(0..)                           ; New Coverage C limit
new_coverage_d = #$:(0..)                           ; New Coverage D limit
new_deductible_percent = #:(5..25)                  ; New deductible percentage
; Retrofit endorsement
retrofit_type_added = (brace_and_bolt, chimney_bracing, foundation_bolting, gas_shutoff, soft_story, water_heater)
retrofit_credit_applied = #:(0..1)                  ; Credit percentage applied
; Processing
processed_by = :                                    ; Agent/underwriter who processed
processed_date = timestamp                          ; Date processed
; Document reference
document_id = :                                     ; Reference to endorsement document

; ═══════════════════════════════════════════════════════════════════════════════
; EARTHQUAKE POLICY
; ═══════════════════════════════════════════════════════════════════════════════
; Complete earthquake insurance policy combining all components.

{@earthquake_policy}
; Policy identification
policy_number = !:                                  ; Unique policy number
quote_number = :                                    ; Original quote number
; Policy type
policy_type = !(cea_basic, cea_homeowners_choice, private_market, standalone, wrap_around)
; Policy term
effective_date = !timestamp                         ; Policy effective date
expiration_date = !timestamp                        ; Policy expiration date
policy_term_months = ##:(1..36)                     ; Policy term in months
; Status
status = !(active, cancelled, expired, lapsed, non_renewed, pending, reinstated, suspended)
cancellation_date = timestamp                       ; Date of cancellation
cancellation_reason = (insured_request, non_payment, underwriting, carrier_non_renewal)
; Parties
insured = !@person                                  ; Primary named insured
additional_insureds[] = @person                     ; Additional named insureds
; Property
property = !@earthquake_property                    ; Insured property
; Coverage
coverage = !@earthquake_coverage                    ; Coverage structure
; Rating
rating = @earthquake_rating                         ; Rating factors and premium
; Premium
annual_premium = !#$:(0..)                          ; Annual premium
policy_fee = #$:(0..)                               ; Policy fee
total_annual_cost = #$:(0..)                        ; Total annual cost
payment_plan = (annual, monthly, quarterly, semi_annual)
; Retrofit status
retrofit = @earthquake_retrofit                     ; Retrofit information
; Claims
claims[] = @earthquake_claim                        ; Associated claims
; Endorsements
endorsements[] = @earthquake_endorsement            ; Policy endorsements
; Underlying policy (if endorsement to homeowners)
underlying_policy_number = :                        ; Underlying homeowners policy
underlying_carrier = :                              ; Underlying policy carrier
; Agent information
agent_name = :                                      ; Producing agent name
agent_license = :                                   ; Agent license number
agency_name = :                                     ; Agency name
agency_code = :                                     ; Agency code
; Carrier
carrier_name = :                                    ; Insurance carrier name
carrier_naic = :                                    ; Carrier NAIC code
carrier_am_best_rating = :                          ; AM Best rating
; Documents
policy_document_id = :                              ; Reference to policy document
declarations_page_id = :                            ; Reference to declarations page
; Timestamps
created_at = timestamp                              ; Policy creation timestamp
updated_at = timestamp                              ; Last update timestamp

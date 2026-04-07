; ===================================================================================
; ODIN Agriculture Crop Schema
; ===================================================================================
; Crop production including planting, inputs (fertilizer, pesticide, irrigation),
; growth stages, harvest, yield, and crop insurance.
; ===================================================================================

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.agriculture.crop"
version = "1.0.0"
title = "Agriculture Crop Schema"
description = "Crop production with planting, inputs, growth, harvest, and insurance"

{$derivation}
source[0].authority = "U.S. Department of Agriculture NASS"
source[0].citation = "NASS Crop Classification"
source[0].url = "https://www.nass.usda.gov/Publications/AgCensus/"

source[1].authority = "U.S. Department of Agriculture RMA"
source[1].citation = "Crop Insurance Handbook - Common Crop Insurance Policy"
source[1].url = "https://www.ecfr.gov/current/title-7/subtitle-B/chapter-IV/part-457"

source[2].authority = "Environmental Protection Agency"
source[2].citation = "40 CFR Part 170 - Worker Protection Standard"
source[2].url = "https://www.ecfr.gov/current/title-40/chapter-I/subchapter-E/part-170"

source[3].authority = "U.S. Department of Agriculture NRCS"
source[3].citation = "Nutrient Management (Code 590)"
source[3].url = "https://www.nrcs.usda.gov/conservation-basics/conservation-by-state"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial agriculture crop schema"
changelog[0].rationale = "Crop structures derived from NASS, RMA, EPA, and NRCS requirements"

; ===================================================================================
; CROP PLANTING
; ===================================================================================

{@crop_planting}
= @types.audit_info

; ───────────────────────────────────────────────────────────────────────────────
; Identification
; ───────────────────────────────────────────────────────────────────────────────
planting_id = !:                                 ; Unique planting identifier
crop_year = !##:(1900..2100)                     ; Crop year
field_ref = !:                                   ; Reference to field
farm_ref = :                                     ; Reference to farm operation

; ───────────────────────────────────────────────────────────────────────────────
; Crop Information
; ───────────────────────────────────────────────────────────────────────────────
{.crop}
crop_code = !:                                   ; NASS crop code
crop_name = !:                                   ; Common crop name
commodity_type = (field_crop, fruit, grain, oilseed, pulse, specialty, vegetable)
variety = :                                      ; Variety or cultivar name
hybrid = ?                                       ; Hybrid variety
gmo = ?                                          ; GMO variety
organic = ?                                      ; Organic certified crop
trait_package = :                                ; Seed trait package (e.g. Roundup Ready)

{@crop_planting}

; ───────────────────────────────────────────────────────────────────────────────
; Planting Details
; ───────────────────────────────────────────────────────────────────────────────
{.planting}
planting_date = !date                            ; Actual planting date
intended_planting_date = date                    ; Intended planting date
final_planting_date = date                       ; Final planting date per insurance
late_planting_period_end = date                  ; Late planting period end
planting_method = (aerial, broadcast, conventional_till, drill, minimum_till, no_till, transplant)
seeding_rate = #:(0..)                           ; Seeds per acre
seeding_rate_unit = (lbs_acre, plants_acre, seeds_acre)
row_spacing_in = #:(0..)                         ; Row spacing in inches
population = ##:(0..)                            ; Target plant population per acre
replanted = ?                                    ; Replanted flag
replant_date = date:if replanted = true          ; Replant date
replant_reason = :if replanted = true            ; Reason for replanting

{@crop_planting}

; ───────────────────────────────────────────────────────────────────────────────
; Seed Information
; ───────────────────────────────────────────────────────────────────────────────
{.seed}
seed_lot = :                                     ; Seed lot number
seed_source = (bin_run, certified, farm_saved, foundation, registered)
seed_treatment = :                               ; Seed treatment applied
seed_brand = :                                   ; Seed brand
seed_cost_per_unit = #$:(0..)                    ; Cost per unit
seed_units = #:(0..)                             ; Units purchased
total_seed_cost = #$:(0..)                       ; Total seed cost

{@crop_planting}

; ───────────────────────────────────────────────────────────────────────────────
; Acreage
; ───────────────────────────────────────────────────────────────────────────────
{.acreage}
planted_acres = !#:(0..)                         ; Planted acres
prevented_plant_acres = #:(0..)                  ; Prevented plant acres
failed_acres = #:(0..)                           ; Failed acres
insured_acres = #:(0..)                          ; Insured acres
harvested_acres = #:(0..)                        ; Harvested acres

{@crop_planting}

; ───────────────────────────────────────────────────────────────────────────────
; Intended Use
; ───────────────────────────────────────────────────────────────────────────────
{.intended_use}
use_type = (feed, food, forage, grain, seed, silage)
market_type = (contract, organic, specialty, standard)
contracted = ?                                   ; Under contract
contract_buyer = :                               ; Contract buyer name
contract_price = #$                              ; Contract price per unit

{@crop_planting}

; ───────────────────────────────────────────────────────────────────────────────
; Inputs Applied
; ───────────────────────────────────────────────────────────────────────────────
fertilizer_applications[] = @fertilizer_application
pesticide_applications[] = @pesticide_application
irrigation_events[] = @irrigation_event

; ───────────────────────────────────────────────────────────────────────────────
; Growth & Development
; ───────────────────────────────────────────────────────────────────────────────
growth_stages[] = @growth_stage

; ───────────────────────────────────────────────────────────────────────────────
; Harvest
; ───────────────────────────────────────────────────────────────────────────────
harvest = @harvest

; ===================================================================================
; FERTILIZER APPLICATION
; ===================================================================================

{@fertilizer_application}
; ───────────────────────────────────────────────────────────────────────────────
; Application Details
; ───────────────────────────────────────────────────────────────────────────────
application_id = !:                              ; Application record ID
application_date = !date                         ; Date applied
application_method = (broadcast, banded, deep_placement, foliar, side_dress, starter)
acres_treated = !#:(0..)                         ; Acres treated

; ───────────────────────────────────────────────────────────────────────────────
; Product Information
; ───────────────────────────────────────────────────────────────────────────────
{.product}
product_name = !:                                ; Fertilizer product name
manufacturer = :                                 ; Manufacturer
product_type = (composted_manure, dry, liquid, manure, organic, synthetic)
nutrient_analysis = :                            ; N-P-K analysis (e.g., "10-10-10")
nitrogen_percent = #:(0..100)                    ; Nitrogen percentage
phosphorus_percent = #:(0..100)                  ; Phosphorus percentage (P2O5)
potassium_percent = #:(0..100)                   ; Potassium percentage (K2O)
sulfur_percent = #:(0..100)                      ; Sulfur percentage

{@fertilizer_application}

; ───────────────────────────────────────────────────────────────────────────────
; Application Rate
; ───────────────────────────────────────────────────────────────────────────────
{.rate}
rate_per_acre = !#:(0..)                         ; Application rate per acre
rate_unit = (gal_acre, lbs_acre, tons_acre)
total_quantity = #:(0..)                         ; Total quantity applied
quantity_unit = :(gal, lbs, tons)

{@fertilizer_application}

; ───────────────────────────────────────────────────────────────────────────────
; Costs
; ───────────────────────────────────────────────────────────────────────────────
{.costs}
product_cost = #$:(0..)                          ; Product cost
application_cost = #$:(0..)                      ; Application cost
total_cost = #$:(0..)                            ; Total cost

{@fertilizer_application}

; ───────────────────────────────────────────────────────────────────────────────
; Applicator
; ───────────────────────────────────────────────────────────────────────────────
{.applicator}
applicator_name = :                              ; Applicator name
operator_name = :                                ; Equipment operator
company = :                                      ; Application company

; ===================================================================================
; PESTICIDE APPLICATION
; ===================================================================================

{@pesticide_application}
; ───────────────────────────────────────────────────────────────────────────────
; Application Details
; ───────────────────────────────────────────────────────────────────────────────
application_id = !:                              ; Application record ID
application_date = !date                         ; Date applied
application_time = time                          ; Time applied
application_method = (aerial, banded, broadcast, chemigation, in_furrow, seed_treatment, soil_incorporated, spray)
acres_treated = !#:(0..)                         ; Acres treated

; ───────────────────────────────────────────────────────────────────────────────
; Product Information (EPA Required)
; ───────────────────────────────────────────────────────────────────────────────
{.product}
product_name = !:                                ; Product name
epa_registration_number = !:                     ; EPA registration number
active_ingredient = !:                           ; Active ingredient(s)
formulation = :                                  ; Formulation type
rei_hours = !##:(0..)                            ; Restricted Entry Interval (hours)
phi_days = ##:(0..)                              ; Pre-Harvest Interval (days)
pesticide_type = (fungicide, herbicide, insecticide, nematicide, other)
target_pest = !:                                 ; Target pest or weed

{@pesticide_application}

; ───────────────────────────────────────────────────────────────────────────────
; Application Rate
; ───────────────────────────────────────────────────────────────────────────────
{.rate}
rate_per_acre = !#:(0..)                         ; Application rate per acre
rate_unit = (fl_oz_acre, gal_acre, lbs_acre, oz_acre, pints_acre)
total_quantity = #:(0..)                         ; Total quantity applied
quantity_unit = :

{@pesticide_application}

; ───────────────────────────────────────────────────────────────────────────────
; Conditions (EPA Required)
; ───────────────────────────────────────────────────────────────────────────────
{.conditions}
temperature_f = #:(-50..150)                     ; Temperature (Fahrenheit)
wind_speed_mph = #:(0..100)                      ; Wind speed (mph)
wind_direction = (calm, e, n, ne, nw, s, se, sw, w)
humidity_percent = #:(0..100)                    ; Relative humidity
soil_condition = (dry, moist, wet)

{@pesticide_application}

; ───────────────────────────────────────────────────────────────────────────────
; Applicator (EPA Required)
; ───────────────────────────────────────────────────────────────────────────────
{.applicator}
applicator_name = !:                             ; Certified applicator name
license_number = !*:                              ; Applicator license number
license_state = !:(2)                            ; License state
company = :                                      ; Application company
operator_name = :                                ; Equipment operator if different

{@pesticide_application}

; ───────────────────────────────────────────────────────────────────────────────
; Costs
; ───────────────────────────────────────────────────────────────────────────────
{.costs}
product_cost = #$:(0..)                          ; Product cost
application_cost = #$:(0..)                      ; Application cost
total_cost = #$:(0..)                            ; Total cost

; ===================================================================================
; IRRIGATION EVENT
; ===================================================================================

{@irrigation_event}
; ───────────────────────────────────────────────────────────────────────────────
; Event Details
; ───────────────────────────────────────────────────────────────────────────────
event_id = !:                                    ; Irrigation event ID
event_date = !date                               ; Date irrigated
acres_irrigated = !#:(0..)                       ; Acres irrigated

; ───────────────────────────────────────────────────────────────────────────────
; Application
; ───────────────────────────────────────────────────────────────────────────────
{.application}
application_method = (center_pivot, drip, flood, furrow, micro_sprinkler, side_roll, solid_set, sub_surface)
water_source = (groundwater, municipal, pond, reservoir, river_stream, well)
application_rate_in = #:(0..)                    ; Application inches
duration_hours = #:(0..)                         ; Duration in hours
flow_rate_gpm = #:(0..)                          ; Flow rate (gallons per minute)
total_volume_gal = #:(0..)                       ; Total volume applied (gallons)

{@irrigation_event}

; ───────────────────────────────────────────────────────────────────────────────
; Costs
; ───────────────────────────────────────────────────────────────────────────────
{.costs}
water_cost = #$:(0..)                            ; Water cost
energy_cost = #$:(0..)                           ; Energy cost (pumping)
total_cost = #$:(0..)                            ; Total irrigation cost

; ===================================================================================
; GROWTH STAGE
; ===================================================================================

{@growth_stage}
; ───────────────────────────────────────────────────────────────────────────────
; Stage Information
; ───────────────────────────────────────────────────────────────────────────────
observation_date = !date                         ; Date observed
stage_code = :                                   ; Growth stage code (Zadoks, Feekes, etc.)
stage_name = !:                                  ; Stage name (e.g., "V6", "Flowering", "Dough")
stage_description = :                            ; Stage description

; ───────────────────────────────────────────────────────────────────────────────
; Measurements
; ───────────────────────────────────────────────────────────────────────────────
{.measurements}
plant_height_in = #:(0..)                        ; Average plant height (inches)
stand_count = ##:(0..)                           ; Stand count per acre
leaf_count = ##:(0..)                            ; Leaf count
flowering_percent = #:(0..100)                   ; Percent flowering
canopy_cover_percent = #:(0..100)                ; Canopy coverage
ndvi = #:(0..1)                                  ; Normalized Difference Vegetation Index

{@growth_stage}

; ───────────────────────────────────────────────────────────────────────────────
; Stress Indicators
; ───────────────────────────────────────────────────────────────────────────────
{.stress}
water_stress = (high, low, moderate, none)
nutrient_stress = (high, low, moderate, none)
pest_pressure = (high, low, moderate, none)
disease_present = ?                              ; Disease detected
disease_name = :                                 ; Disease name
insect_damage = ?                                ; Insect damage present
weed_pressure = (heavy, light, moderate, none)

; ===================================================================================
; HARVEST
; ===================================================================================

{@harvest}
; ───────────────────────────────────────────────────────────────────────────────
; Harvest Timing
; ───────────────────────────────────────────────────────────────────────────────
harvest_start_date = !date                       ; Harvest start date
harvest_end_date = date                          ; Harvest end date
harvest_method = (combine, custom_harvester, hand_harvest, mechanical_harvester)

; ───────────────────────────────────────────────────────────────────────────────
; Acreage & Yield
; ───────────────────────────────────────────────────────────────────────────────
{.production}
harvested_acres = !#:(0..)                       ; Acres harvested
total_production = !#:(0..)                      ; Total production quantity
production_unit = (bales, bushels, cwt, lbs, tons)
yield_per_acre = #:(0..)                         ; Yield per acre
moisture_percent = #:(0..100)                    ; Moisture percentage at harvest
test_weight = #:(0..)                            ; Test weight (lbs/bushel)

{@harvest}

; ───────────────────────────────────────────────────────────────────────────────
; Quality
; ───────────────────────────────────────────────────────────────────────────────
{.quality}
grade = :                                        ; USDA grade
protein_percent = #:(0..100)                     ; Protein percentage
oil_content_percent = #:(0..100)                 ; Oil content percentage
foreign_material_percent = #:(0..100)            ; Foreign material
damaged_kernels_percent = #:(0..100)             ; Damaged kernels
defects = :                                      ; Quality defects noted

{@harvest}

; ───────────────────────────────────────────────────────────────────────────────
; Disposition
; ───────────────────────────────────────────────────────────────────────────────
{.disposition}
on_farm_storage = #:(0..)                        ; Quantity in on-farm storage
commercial_storage = #:(0..)                     ; Quantity in commercial storage
sold = #:(0..)                                   ; Quantity sold
fed_on_farm = #:(0..)                            ; Quantity used for feed
seed = #:(0..)                                   ; Quantity saved for seed

{@harvest}

; ───────────────────────────────────────────────────────────────────────────────
; Revenue
; ───────────────────────────────────────────────────────────────────────────────
{.revenue}
market_price = #$                                ; Market price per unit
gross_revenue = #$:(0..)                         ; Gross revenue
crop_insurance_indemnity = #$:(0..)              ; Insurance indemnity received

{@harvest}

; ───────────────────────────────────────────────────────────────────────────────
; Costs
; ───────────────────────────────────────────────────────────────────────────────
harvest_costs = @harvest_costs

; ===================================================================================
; HARVEST COSTS
; ===================================================================================

{@harvest_costs}
custom_harvesting = #$:(0..)                     ; Custom harvesting cost
hauling = #$:(0..)                               ; Hauling cost
drying = #$:(0..)                                ; Drying cost
storage = #$:(0..)                               ; Storage cost
labor = #$:(0..)                                 ; Labor cost
fuel = #$:(0..)                                  ; Fuel cost
equipment = #$:(0..)                             ; Equipment cost
other = #$:(0..)                                 ; Other costs
total_harvest_cost = #$:(0..)                    ; Total harvest cost

; ===================================================================================
; CROP INSURANCE
; ===================================================================================

{@crop_insurance}
; ───────────────────────────────────────────────────────────────────────────────
; Policy Information
; ───────────────────────────────────────────────────────────────────────────────
policy_number = !:                               ; Crop insurance policy number
crop_year = !##:(1900..2100)                     ; Crop year
insurance_company = !:                           ; Insurance provider
agent_name = :                                   ; Agent name
agent_code = :                                   ; Agent code

; ───────────────────────────────────────────────────────────────────────────────
; Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.coverage}
insurance_plan = (area_risk_protection, catastrophic, group_risk, revenue_protection, whole_farm_revenue, yield_protection)
coverage_level = !#:(0..100)                     ; Coverage level percentage
unit_structure = (basic, enterprise, optional, whole_farm)
practice = (conventional, irrigated, organic, prevented_plant)
type_code = :                                    ; Crop type code

{@crop_insurance}

; ───────────────────────────────────────────────────────────────────────────────
; Insured Crop
; ───────────────────────────────────────────────────────────────────────────────
{.insured_crop}
crop_code = !:                                   ; RMA crop code
crop_name = !:                                   ; Crop name
insured_acres = !#:(0..)                         ; Insured acres
intended_acres = #:(0..)                         ; Intended acres
prevented_plant_acres = #:(0..)                  ; Prevented plant acres
aph_yield = #:(0..)                              ; Approved APH yield
projected_price = #$:(0..)                       ; Projected price
harvest_price = #$:(0..)                         ; Harvest price
guarantee_per_acre = #$:(0..)                    ; Guarantee per acre

{@crop_insurance}

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
total_premium = !#$:(0..)                        ; Total premium
producer_premium = #$:(0..)                      ; Producer premium (after subsidy)
subsidy = #$:(0..)                               ; Federal subsidy amount
subsidy_percent = #:(0..100)                     ; Subsidy percentage
due_date = date                                  ; Premium due date
paid_date = date                                 ; Premium paid date

{@crop_insurance}

; ───────────────────────────────────────────────────────────────────────────────
; Claim
; ───────────────────────────────────────────────────────────────────────────────
{.claim}
claim_number = :                                 ; Claim number
loss_date = date                                 ; Date of loss
loss_cause = :                                   ; Cause of loss (drought, flood, hail, etc.)
notice_date = date                               ; Date notice filed
adjuster_name = :                                ; Adjuster name
inspection_date = date                           ; Inspection date
actual_yield = #:(0..)                           ; Actual yield
indemnity = #$:(0..)                             ; Indemnity payment
payment_date = date                              ; Payment date
claim_status = (approved, denied, open, paid, pending)

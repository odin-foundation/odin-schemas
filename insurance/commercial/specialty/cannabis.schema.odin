; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Cannabis Insurance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Cannabis business insurance for cultivators, manufacturers, distributors,
; dispensaries, and testing laboratories covering crop/cultivation, property,
; product liability, cash coverage, and regulatory compliance.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../coverages/coverage.schema.odin" as cov
@import "../../coverages/lines/property.schema.odin" as property
@import "../../coverages/lines/liability.schema.odin" as liability
@import "../../common/types.schema.odin" as com
@import "../business.schema.odin" as entity
@import "../business-location.schema.odin" as location

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.specialty.cannabis"
version = "1.0.0"
title = "Cannabis Insurance Schema"
description = "Comprehensive insurance coverage for licensed cannabis operations"

{$derivation}
source[0].authority = "California Department of Cannabis Control"
source[0].citation = "Cannabis Licensing Requirements - Business and Professions Code Division 10"
source[0].url = "https://cannabis.ca.gov/applicants/license-types/"

source[1].authority = "Colorado Marijuana Enforcement Division"
source[1].citation = "Marijuana Rules and Regulations"
source[1].url = "https://sbg.colorado.gov/med"

source[2].authority = "Metrc"
source[2].citation = "Track and Trace Compliance Requirements"
source[2].url = "https://www.metrc.com/"

source[3].authority = "Internal Revenue Service"
source[3].citation = "IRC Section 280E - Expenditures in Connection with Illegal Drugs"
source[3].url = "https://www.irs.gov/"

source[4].authority = "National Association of Insurance Commissioners"
source[4].citation = "State Cannabis Insurance Bulletins and Guidelines"
source[4].url = "https://content.naic.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Cannabis insurance schema derived from state regulatory requirements and industry practices"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial cannabis insurance schema"
changelog[0].rationale = "Comprehensive coverage for cultivation, manufacturing, distribution, and retail cannabis operations"

; ═══════════════════════════════════════════════════════════════════════════════
; Cannabis License
; ═══════════════════════════════════════════════════════════════════════════════
; State license details - coverage is contingent on valid license status

{@cannabis_license}
id = :                                                ; Unique identifier for the license

; ───────────────────────────────────────────────────────────────────────────────
; License Identification
; ───────────────────────────────────────────────────────────────────────────────
license_number = *:                               ; State-issued license number (confidential)
state = :(2)                                      ; US state code
issuing_authority = :                             ; State cannabis agency name
license_class = (
    adult_use,                                    ; Recreational
    medical,                                      ; Medical marijuana
    medical_and_adult_use                         ; Dual license type
)

; ───────────────────────────────────────────────────────────────────────────────
; License Type (based on California DCC model)
; ───────────────────────────────────────────────────────────────────────────────
license_type = (
    ; Cultivation
    cultivation_specialty_outdoor,                ; Small outdoor (up to 5,000 sq ft)
    cultivation_specialty_indoor,                 ; Small indoor (up to 5,000 sq ft)
    cultivation_specialty_mixed_light,            ; Small mixed light (up to 5,000 sq ft)
    cultivation_small_outdoor,                    ; Small outdoor (5,001-10,000 sq ft)
    cultivation_small_indoor,                     ; Small indoor (5,001-10,000 sq ft)
    cultivation_small_mixed_light,                ; Small mixed light (5,001-10,000 sq ft)
    cultivation_medium_outdoor,                   ; Medium outdoor (10,001+ sq ft)
    cultivation_medium_indoor,                    ; Medium indoor (10,001-22,000 sq ft)
    cultivation_medium_mixed_light,               ; Medium mixed light (10,001-22,000 sq ft)
    cultivation_large_outdoor,                    ; Large outdoor
    cultivation_large_indoor,                     ; Large indoor (22,001+ sq ft)
    cultivation_nursery,                          ; Seeds, clones, immature plants only
    cultivation_processor,                        ; Harvest and post-harvest only
    ; Manufacturing
    manufacturing_type_n,                         ; Non-volatile extraction (CO2, ethanol)
    manufacturing_type_p,                         ; Packaging and labeling only
    manufacturing_type_6,                         ; Volatile extraction (butane, propane)
    manufacturing_type_7,                         ; Infusion and extraction
    manufacturing_shared_use,                     ; Shared manufacturing facility
    ; Distribution
    distribution,                                 ; Full distribution
    distribution_transport_only,                  ; Transport only
    ; Retail
    retail_dispensary,                            ; Storefront retail
    retail_delivery_only,                         ; Non-storefront retail
    retail_consumption_lounge,                    ; Onsite consumption
    ; Testing
    testing_laboratory,                           ; State-licensed testing lab
    ; Microbusiness (vertically integrated)
    microbusiness                                 ; Vertically integrated small business
)

license_type_code = :                             ; State-specific code (e.g., "Type 10", "M-Cultivator")

; ───────────────────────────────────────────────────────────────────────────────
; License Status
; ───────────────────────────────────────────────────────────────────────────────
license_status = (
    active,                                       ; License is active and in good standing
    conditional,                                  ; Provisional/conditional license
    suspended,                                    ; Temporarily suspended
    revoked,                                      ; Permanently revoked
    expired,                                      ; License has expired
    pending_renewal,                              ; Renewal application pending
    pending_initial                               ; Initial application pending
)

; License Dates
issue_date = date                                 ; Date license was initially issued
effective_date = date                             ; Date license became effective
expiration_date = date                            ; Date license expires
last_renewal_date = date                          ; Date of most recent renewal

; ───────────────────────────────────────────────────────────────────────────────
; Compliance Status
; ───────────────────────────────────────────────────────────────────────────────
{.compliance}
current_violations = ##:(0..)                     ; Number of current violations on record
pending_enforcement_actions = ##:(0..)            ; Number of pending enforcement actions
administrative_holds = ?                          ; Whether there are administrative holds
license_at_risk = ?                               ; Whether license is at risk of suspension
last_inspection_date = date                       ; Date of most recent inspection
next_inspection_due = date                        ; Date next inspection is due
inspection_result = (passed, passed_with_conditions, failed, pending):if last_inspection_date ; Result of last inspection

{@cannabis_license}

; ───────────────────────────────────────────────────────────────────────────────
; Track and Trace System
; ───────────────────────────────────────────────────────────────────────────────
{.track_and_trace}
system = (metrc, biotrack, mj_freeway, leaf_data, custom_state) ; Track and trace system used
api_key_registered = ?                            ; Whether API key is registered
account_active = ?                                ; Whether account is active
last_sync_date = date                             ; Date of last data synchronization
compliance_rate_percent = ##:(0..100)             ; Percentage of transactions in compliance

{@cannabis_license}

; ═══════════════════════════════════════════════════════════════════════════════
; Cannabis Facility
; ═══════════════════════════════════════════════════════════════════════════════

{@cannabis_facility}
id = :                                            ; Unique identifier for the facility
facility_name = :                                 ; Name of the cannabis facility

; ───────────────────────────────────────────────────────────────────────────────
; Location
; ───────────────────────────────────────────────────────────────────────────────
location = @location.business_location            ; Physical location of the facility

; Local Jurisdiction Approval
local_permit_number = :                           ; Local permit number
local_jurisdiction = :                            ; Local city or county jurisdiction
conditional_use_permit = ?                        ; Whether conditional use permit obtained

; ───────────────────────────────────────────────────────────────────────────────
; Facility Type
; ───────────────────────────────────────────────────────────────────────────────
facility_type = (
    cultivation_indoor,                           ; Indoor cultivation facility
    cultivation_outdoor,                          ; Outdoor cultivation facility
    cultivation_greenhouse,                       ; Greenhouse cultivation facility
    cultivation_mixed_light,                      ; Mixed light cultivation facility
    manufacturing_extraction,                     ; Extraction manufacturing facility
    manufacturing_infusion,                       ; Infusion manufacturing facility
    manufacturing_packaging,                      ; Packaging facility
    distribution_warehouse,                       ; Distribution and storage warehouse
    retail_dispensary,                            ; Retail dispensary location
    retail_delivery_hub,                          ; Delivery-only hub
    consumption_lounge,                           ; On-site consumption lounge
    testing_laboratory,                           ; Testing laboratory
    microbusiness_facility,                       ; Vertically integrated microbusiness
    mixed_use                                     ; Multiple license types at location
)

; ───────────────────────────────────────────────────────────────────────────────
; Physical Specifications
; ───────────────────────────────────────────────────────────────────────────────
{.building}
total_square_feet = ##                            ; Total building square footage
canopy_square_feet = ##:if facility_type = cultivation_indoor ; Licensed canopy square feet
canopy_square_feet = ##:if facility_type = cultivation_greenhouse ; Licensed canopy square feet
canopy_square_feet = ##:if facility_type = cultivation_mixed_light ; Licensed canopy square feet
outdoor_acres = #:if facility_type = cultivation_outdoor ; Outdoor cultivation acres
grow_rooms = ##:if facility_type = cultivation_indoor ; Number of grow rooms
greenhouse_bays = ##:if facility_type = cultivation_greenhouse ; Number of greenhouse bays
construction_type = (frame, masonry, metal, concrete, greenhouse) ; Building construction type
year_built = ##:(1900..2100)                      ; Year building was built
sprinklered = ?                                   ; Whether building has sprinkler system
fire_alarm = ?                                    ; Whether building has fire alarm
smoke_detection = ?                               ; Whether building has smoke detection

{@cannabis_facility}

; ───────────────────────────────────────────────────────────────────────────────
; Security Requirements (State Mandated)
; ───────────────────────────────────────────────────────────────────────────────
{.security}
perimeter_fencing = ?                             ; Whether facility has perimeter fencing
commercial_grade_locks = ?                        ; Whether commercial-grade locks installed
video_surveillance = ?                            ; Whether video surveillance installed
video_retention_days = ##:(30..180)               ; Number of days video is retained
alarm_system = ?                                  ; Whether alarm system installed
alarm_company = :                                 ; Name of alarm monitoring company
armed_guards = ?                                  ; Whether armed guards employed
guard_service = :                                 ; Name of guard service company
security_plan_approved = ?                        ; Whether security plan state-approved
intrusion_detection = ?                           ; Whether intrusion detection installed
panic_buttons = ?                                 ; Whether panic buttons installed

; Access Control
access_control_system = ?                         ; Whether access control system installed
biometric_access = ?                              ; Whether biometric access installed
key_card_access = ?                               ; Whether key card access installed
visitor_log_maintained = ?                        ; Whether visitor logs are maintained
limited_access_areas_secured = ?                  ; Whether limited access areas secured

{@cannabis_facility}

; ───────────────────────────────────────────────────────────────────────────────
; Vault/Safe (for Cannabis and Cash)
; ───────────────────────────────────────────────────────────────────────────────
{.vault}
vault = ?                                         ; Whether vault or safe is present
vault_type = (safe, vault_room, gun_safe):if vault = true ; Type of vault
vault_rating = (b_rate, c_rate, tl_15, tl_30, trtl_30, trtl_60):if vault = true ; Vault security rating
vault_ul_listed = ?:if vault = true               ; Whether vault is UL-listed
time_lock = ?:if vault = true                     ; Whether vault has time lock

{@cannabis_facility}

; ───────────────────────────────────────────────────────────────────────────────
; Cultivation Equipment (if applicable)
; ───────────────────────────────────────────────────────────────────────────────
{.cultivation_equipment}
hvac_value = #$:(0..)                             ; Value of HVAC systems
lighting_system_value = #$:(0..)                  ; Value of lighting systems
irrigation_system_value = #$:(0..)                ; Value of irrigation systems
environmental_controls_value = #$:(0..)           ; Value of environmental control systems
trimming_equipment_value = #$:(0..)               ; Value of trimming equipment
drying_curing_equipment_value = #$:(0..)          ; Value of drying and curing equipment
total_equipment_value = #$:(0..)                  ; Total cultivation equipment value

{@cannabis_facility}

; ───────────────────────────────────────────────────────────────────────────────
; Manufacturing Equipment (if applicable)
; ───────────────────────────────────────────────────────────────────────────────
{.manufacturing_equipment}
extraction_equipment_value = #$:(0..)             ; Value of extraction equipment
extraction_type = (co2, ethanol, hydrocarbon, rosin, solventless) ; Type of extraction method
infusion_equipment_value = #$:(0..)               ; Value of infusion equipment
packaging_equipment_value = #$:(0..)              ; Value of packaging equipment
testing_equipment_value = #$:(0..)                ; Value of testing equipment
total_equipment_value = #$:(0..)                  ; Total manufacturing equipment value
c1d1_room = ?                                     ; Explosion-proof room for volatiles
c1d2_room = ?                                     ; Class 1 Division 2 hazardous location room

{@cannabis_facility}

; ───────────────────────────────────────────────────────────────────────────────
; Retail Equipment (if applicable)
; ───────────────────────────────────────────────────────────────────────────────
{.retail_equipment}
pos_system_value = #$:(0..)                       ; Value of point-of-sale system
display_cases_value = #$:(0..)                    ; Value of display cases
security_equipment_value = #$:(0..)               ; Value of security equipment
furniture_fixtures_value = #$:(0..)               ; Value of furniture and fixtures
total_equipment_value = #$:(0..)                  ; Total retail equipment value

{@cannabis_facility}

; ───────────────────────────────────────────────────────────────────────────────
; Fire Protection
; ───────────────────────────────────────────────────────────────────────────────
{.fire_protection}
fire_district = :                                 ; Name of fire protection district
distance_to_fire_station_miles = #:(0..100)       ; Distance to nearest fire station in miles
protection_class = ##                             ; ISO protection class rating
hydrant_within_1000_feet = ?                      ; Whether fire hydrant within 1000 feet
fire_extinguishers = ?                            ; Whether fire extinguishers present
fire_department_inspection_date = date            ; Date of fire department inspection

{@cannabis_facility}

; ═══════════════════════════════════════════════════════════════════════════════
; Cannabis Stock/Inventory
; ═══════════════════════════════════════════════════════════════════════════════
; Inventory at various stages of production

{@cannabis_stock}
id = :                                            ; Unique identifier for stock record
facility_ref = :                                  ; Reference to @cannabis_facility.id
valuation_date = date                             ; Date of stock valuation

; ───────────────────────────────────────────────────────────────────────────────
; Living Plants (Cultivation)
; ───────────────────────────────────────────────────────────────────────────────
{.living_plants}
immature_plants_count = ##:(0..)                  ; Seedlings, clones
immature_plants_value = #$:(0..)                  ; Value of immature plants
vegetative_plants_count = ##:(0..)                ; Number of vegetative stage plants
vegetative_plants_value = #$:(0..)                ; Value of vegetative plants
flowering_plants_count = ##:(0..)                 ; Number of flowering stage plants
flowering_plants_value = #$:(0..)                 ; Value of flowering plants
mother_plants_count = ##:(0..)                    ; Number of mother plants
mother_plants_value = #$:(0..)                    ; Value of mother plants
total_plants_value = #$:(0..)                     ; Total value of all living plants

{@cannabis_stock}

; ───────────────────────────────────────────────────────────────────────────────
; Harvested/Processing
; ───────────────────────────────────────────────────────────────────────────────
{.harvested}
wet_trim_pounds = #:(0..)                         ; Pounds of wet trim
wet_trim_value = #$:(0..)                         ; Value of wet trim
drying_product_pounds = #:(0..)                   ; Pounds of product in drying
drying_product_value = #$:(0..)                   ; Value of drying product
cured_flower_pounds = #:(0..)                     ; Pounds of cured flower
cured_flower_value = #$:(0..)                     ; Value of cured flower
trim_biomass_pounds = #:(0..)                     ; Pounds of trim and biomass
trim_biomass_value = #$:(0..)                     ; Value of trim and biomass
total_harvested_value = #$:(0..)                  ; Total value of harvested product

{@cannabis_stock}

; ───────────────────────────────────────────────────────────────────────────────
; Manufactured/Processed Products
; ───────────────────────────────────────────────────────────────────────────────
{.manufactured}
concentrate_value = #$:(0..)                      ; Value of concentrates
edibles_value = #$:(0..)                          ; Value of edibles
tinctures_value = #$:(0..)                        ; Value of tinctures
topicals_value = #$:(0..)                         ; Value of topicals
vape_cartridges_value = #$:(0..)                  ; Value of vape cartridges
prerolls_value = #$:(0..)                         ; Value of pre-rolls
other_products_value = #$:(0..)                   ; Value of other manufactured products
packaging_materials_value = #$:(0..)              ; Value of packaging materials
total_manufactured_value = #$:(0..)               ; Total value of manufactured products

{@cannabis_stock}

; ───────────────────────────────────────────────────────────────────────────────
; Retail Ready Inventory
; ───────────────────────────────────────────────────────────────────────────────
{.retail_inventory}
packaged_flower_value = #$:(0..)                  ; Value of packaged flower products
packaged_concentrates_value = #$:(0..)            ; Value of packaged concentrates
packaged_edibles_value = #$:(0..)                 ; Value of packaged edibles
packaged_other_value = #$:(0..)                   ; Value of other packaged products
total_retail_value = #$:(0..)                     ; Total retail-ready inventory value

{@cannabis_stock}

; ───────────────────────────────────────────────────────────────────────────────
; Stock Totals
; ───────────────────────────────────────────────────────────────────────────────
maximum_stock_value = #$:(0..)                    ; Maximum stock value on hand
average_stock_value = #$:(0..)                    ; Average stock value over time
peak_season_value = #$:(0..)                      ; Peak season stock value
stock_turn_rate_days = ##:(1..365)                ; Average number of days to turn stock

; Valuation Method
valuation_method = (actual_cost, market_value, replacement_cost, selling_price) ; Method used to value stock

; ═══════════════════════════════════════════════════════════════════════════════
; Cannabis Cultivation Coverage (Extends Property Coverage)
; ═══════════════════════════════════════════════════════════════════════════════
; Crop insurance for cannabis plants

{@cannabis_cultivation_coverage}
= @property_coverage                              ; Inherit from property line

coverage_id = :                                   ; Unique identifier for coverage
facility_ref = :                                  ; Reference to @cannabis_facility.id

; ───────────────────────────────────────────────────────────────────────────────
; Living Plant Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.living_plants}
included = ?                                      ; Whether living plant coverage included
limit = #$:(0..):if living_plants.included = true ; Coverage limit for living plants
valuation = (actual_cash_value, agreed_value, replacement_cost):if living_plants.included = true ; Valuation basis
deductible = #$:(0..):if living_plants.included = true ; Deductible amount
waiting_period_hours = ##:(0..168):if living_plants.included = true ; Waiting period before coverage attaches

; Covered Perils
covered_perils = (all_risk, named_perils):if living_plants.included = true ; Perils coverage form
fire = ?:if living_plants.included = true         ; Whether fire covered
theft = ?:if living_plants.included = true        ; Whether theft covered
vandalism = ?:if living_plants.included = true    ; Whether vandalism covered
equipment_breakdown = ?:if living_plants.included = true ; Whether equipment breakdown covered
power_failure = ?:if living_plants.included = true ; Whether power failure covered
water_damage = ?:if living_plants.included = true ; Whether water damage covered
wind_hail = ?:if living_plants.included = true    ; Whether wind/hail covered

; Exclusions
mold_mildew_excluded = ?true:if living_plants.included = true ; Whether mold/mildew excluded
pest_infestation_excluded = ?true:if living_plants.included = true ; Whether pest infestation excluded
disease_excluded = ?true:if living_plants.included = true ; Whether disease excluded
pollination_excluded = ?true:if living_plants.included = true ; Whether pollination issues excluded
crop_failure_excluded = ?true:if living_plants.included = true ; Whether crop failure excluded

{@cannabis_cultivation_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Harvested Product Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.harvested_product}
included = ?                                      ; Whether harvested product coverage included
limit = #$:(0..):if harvested_product.included = true ; Coverage limit for harvested product
valuation = (actual_cash_value, replacement_cost, selling_price):if harvested_product.included = true ; Valuation basis
deductible = #$:(0..):if harvested_product.included = true ; Deductible amount

; Coverage during processing stages
drying_covered = ?:if harvested_product.included = true ; Whether drying stage covered
curing_covered = ?:if harvested_product.included = true ; Whether curing stage covered
trimming_covered = ?:if harvested_product.included = true ; Whether trimming stage covered
packaging_covered = ?:if harvested_product.included = true ; Whether packaging stage covered

{@cannabis_cultivation_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Equipment Breakdown for Cultivation
; ───────────────────────────────────────────────────────────────────────────────
{.equipment_breakdown}
included = ?                                      ; Whether equipment breakdown coverage included
limit = #$:(0..):if equipment_breakdown.included = true ; Equipment breakdown coverage limit
deductible = #$:(0..):if equipment_breakdown.included = true ; Deductible amount

; Covered Equipment
hvac_systems = ?:if equipment_breakdown.included = true ; Whether HVAC systems covered
lighting_systems = ?:if equipment_breakdown.included = true ; Whether lighting systems covered
irrigation_systems = ?:if equipment_breakdown.included = true ; Whether irrigation systems covered
environmental_controls = ?:if equipment_breakdown.included = true ; Whether environmental controls covered
backup_generators = ?:if equipment_breakdown.included = true ; Whether backup generators covered

; Resultant Damage
spoilage_coverage = ?:if equipment_breakdown.included = true ; Whether spoilage/crop loss covered
spoilage_limit = #$:(0..):if spoilage_coverage = true ; Spoilage coverage limit

{@cannabis_cultivation_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Cannabis Property Coverage
; ═══════════════════════════════════════════════════════════════════════════════
; Building and business personal property coverage

{@cannabis_property_coverage}
= @property_coverage                              ; Inherit from property line

coverage_id = :                                   ; Unique identifier for coverage
facility_ref = :                                  ; Reference to @cannabis_facility.id

; ───────────────────────────────────────────────────────────────────────────────
; Building Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.building}
included = ?                                      ; Whether building coverage included
limit = #$:(0..):if building.included = true      ; Building coverage limit
valuation = (actual_cash_value, agreed_value, replacement_cost):if building.included = true ; Valuation basis
coinsurance = ##:(80, 90, 100):if building.included = true ; Coinsurance percentage
deductible = #$:(0..):if building.included = true ; Deductible amount

; Tenant Improvements
tenant_improvements_included = ?:if building.included = true ; Whether tenant improvements covered
tenant_improvements_limit = #$:(0..):if tenant_improvements_included = true ; Tenant improvements limit

{@cannabis_property_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Business Personal Property (Equipment)
; ───────────────────────────────────────────────────────────────────────────────
{.business_personal_property}
included = ?                                      ; Whether business personal property covered
limit = #$:(0..):if business_personal_property.included = true ; Business personal property limit
valuation = (actual_cash_value, replacement_cost):if business_personal_property.included = true ; Valuation basis
deductible = #$:(0..):if business_personal_property.included = true ; Deductible amount

; Scheduled High-Value Equipment
scheduled_equipment = ?:if business_personal_property.included = true ; Whether equipment is scheduled

{@cannabis_property_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Business Income / Extra Expense
; ───────────────────────────────────────────────────────────────────────────────
{.business_income}
included = ?                                      ; Whether business income coverage included
limit = #$:(0..):if business_income.included = true ; Business income coverage limit
extra_expense = ?:if business_income.included = true ; Whether extra expense coverage included
extra_expense_limit = #$:(0..):if extra_expense = true ; Extra expense limit
waiting_period_hours = ##:(0, 24, 48, 72):if business_income.included = true ; Waiting period in hours
period_of_restoration_days = ##:(30..365):if business_income.included = true ; Maximum restoration period

; License Contingency
license_suspension_coverage = ?:if business_income.included = true ; Whether license suspension covered
license_suspension_limit = #$:(0..):if license_suspension_coverage = true ; License suspension coverage limit

{@cannabis_property_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Causes of Loss
; ───────────────────────────────────────────────────────────────────────────────
causes_of_loss_form = (basic, broad, special)    ; Type of causes of loss form

; ═══════════════════════════════════════════════════════════════════════════════
; Cannabis Cash Coverage
; ═══════════════════════════════════════════════════════════════════════════════
; Coverage for cash handling due to federal banking restrictions

{@cannabis_cash_coverage}
coverage_id = :                                   ; Unique identifier for coverage
facility_ref = :                                  ; Reference to @cannabis_facility.id

; ───────────────────────────────────────────────────────────────────────────────
; Cash Exposure (Due to Banking Restrictions)
; ───────────────────────────────────────────────────────────────────────────────
{.exposure}
banking_relationship = ?                          ; Has bank/credit union account
cash_only_operations = ?                          ; Primarily cash-based
average_daily_cash_on_premises = #$:(0..)         ; Average daily cash amount on premises
maximum_cash_on_premises = #$:(0..)               ; Maximum cash amount on premises
average_daily_cash_in_transit = #$:(0..)          ; Average daily cash in transit
bank_deposit_frequency = (daily, multiple_per_day, twice_weekly, weekly) ; How often deposits made
armored_car_service = ?                           ; Whether armored car service used
armored_car_company = ::if armored_car_service = true ; Name of armored car company

{@cannabis_cash_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Inside Premises Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.inside_premises}
included = ?                                      ; Whether inside premises coverage included
limit = #$:(0..):if inside_premises.included = true ; Inside premises coverage limit
deductible = #$:(0..):if inside_premises.included = true ; Deductible amount
robbery = ?:if inside_premises.included = true    ; Whether robbery covered
burglary = ?:if inside_premises.included = true   ; Whether burglary covered
safe_burglary = ?:if inside_premises.included = true ; Whether safe burglary covered
employee_theft = ?:if inside_premises.included = true ; Whether employee theft covered

{@cannabis_cash_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Outside Premises / In Transit Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.in_transit}
included = ?                                      ; Whether in-transit coverage included
limit = #$:(0..):if in_transit.included = true    ; In-transit coverage limit
deductible = #$:(0..):if in_transit.included = true ; Deductible amount
messenger_robbery = ?:if in_transit.included = true ; Whether messenger robbery covered
vehicle_theft = ?:if in_transit.included = true   ; Whether vehicle theft covered
armored_car_required = ?:if in_transit.included = true ; Whether armored car required
armed_guard_required = ?:if in_transit.included = true ; Whether armed guard required

{@cannabis_cash_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Cash Controls Requirements
; ───────────────────────────────────────────────────────────────────────────────
{.controls}
dual_custody = ?                                  ; Whether dual custody procedures in place
shift_counts = ?                                  ; Whether shift cash counts performed
video_surveillance_of_cash = ?                    ; Whether cash areas under video surveillance
safe_with_time_lock = ?                           ; Whether safe has time lock
drop_safe = ?                                     ; Whether drop safe in use
currency_counter = ?                              ; Whether currency counter used

{@cannabis_cash_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Cannabis Transportation Coverage
; ═══════════════════════════════════════════════════════════════════════════════
; Coverage for product in transit between licensed facilities

{@cannabis_transport_coverage}
coverage_id = :                                   ; Unique identifier for coverage

; ───────────────────────────────────────────────────────────────────────────────
; Transportation Operations
; ───────────────────────────────────────────────────────────────────────────────
transport_license_type = (
    distribution,                                 ; Licensed distributor
    distribution_transport_only,                  ; Transport-only license
    self_distribution                             ; Transport own products
)

transport_territory = (
    county_only,                                  ; Operating within single county
    multi_county,                                 ; Operating across multiple counties
    statewide                                     ; Operating statewide
)

average_shipments_per_month = ##:(0..)            ; Average number of shipments per month
maximum_shipment_value = #$:(0..)                 ; Maximum value of single shipment
average_shipment_value = #$:(0..)                 ; Average value per shipment

; ───────────────────────────────────────────────────────────────────────────────
; Vehicle Fleet
; ───────────────────────────────────────────────────────────────────────────────
{.vehicles}
owned_vehicles = ##:(0..)                         ; Number of owned vehicles
leased_vehicles = ##:(0..)                        ; Number of leased vehicles
total_vehicles = ##:(0..)                         ; Total number of vehicles in fleet
unmarked_vehicles = ?                             ; Required by some states
gps_tracking = ?                                  ; Whether GPS tracking installed
locked_container_in_vehicle = ?                   ; Whether locked containers used
temperature_controlled = ?                        ; Whether temperature-controlled transport

{@cannabis_transport_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Product in Transit Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.product_coverage}
included = ?                                      ; Whether product in transit coverage included
per_shipment_limit = #$:(0..):if product_coverage.included = true ; Per-shipment coverage limit
aggregate_limit = #$:(0..):if product_coverage.included = true ; Aggregate coverage limit
deductible = #$:(0..):if product_coverage.included = true ; Deductible amount
valuation = (actual_cash_value, invoice_value, replacement_cost) ; Valuation basis

; Covered Perils
theft = ?:if product_coverage.included = true     ; Whether theft covered
collision = ?:if product_coverage.included = true ; Whether collision covered
overturning = ?:if product_coverage.included = true ; Whether overturning covered
fire = ?:if product_coverage.included = true      ; Whether fire covered

{@cannabis_transport_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Manifest and Compliance
; ───────────────────────────────────────────────────────────────────────────────
{.compliance}
manifest_required = ?true                         ; Whether manifest required for all shipments
track_and_trace_updated = ?true                   ; Whether track and trace system updated
locked_container_required = ?true                 ; Whether locked containers required
transport_personnel_licensed = ?true              ; Whether transport personnel licensed
transport_personnel_background_checked = ?true    ; Whether personnel background checked

{@cannabis_transport_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Cannabis Product Liability Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@cannabis_product_liability}
= @liability_coverage                             ; Inherit from liability line

coverage_id = :                                   ; Unique identifier for coverage

; ───────────────────────────────────────────────────────────────────────────────
; Product Categories Covered
; ───────────────────────────────────────────────────────────────────────────────
{.products}
flower = ?                                        ; Whether flower products sold
concentrates = ?                                  ; Whether concentrates sold
edibles = ?                                       ; Whether edibles sold
beverages = ?                                     ; Whether beverages sold
tinctures = ?                                     ; Whether tinctures sold
topicals = ?                                      ; Whether topicals sold
vape_cartridges = ?                               ; Whether vape cartridges sold
capsules = ?                                      ; Whether capsules sold
pre_rolls = ?                                     ; Whether pre-rolls sold
clones_seeds = ?                                  ; Whether clones or seeds sold
other = ?                                         ; Whether other products sold
other_description = ::if products.other = true    ; Description of other products

{@cannabis_product_liability}

; ───────────────────────────────────────────────────────────────────────────────
; Product Liability Limits
; ───────────────────────────────────────────────────────────────────────────────
{.limits}
each_occurrence = #$:(0..)                        ; Per-occurrence limit
products_completed_ops_aggregate = #$:(0..)       ; Products/completed operations aggregate
personal_advertising_injury = #$:(0..)            ; Personal and advertising injury limit
general_aggregate = #$:(0..)                      ; General aggregate limit

{@cannabis_product_liability}

; ───────────────────────────────────────────────────────────────────────────────
; Specific Product Liability Exposures
; ───────────────────────────────────────────────────────────────────────────────
{.exposures}
; Contamination
contamination_coverage = ?                        ; Whether contamination coverage included
contamination_types = (biological, chemical, foreign_matter, pesticide) ; Types of contamination covered
microbial_contamination = ?:if contamination_coverage = true ; Whether microbial contamination covered
heavy_metals = ?:if contamination_coverage = true ; Whether heavy metal contamination covered
residual_solvents = ?:if contamination_coverage = true ; Whether residual solvents covered
pesticide_residue = ?:if contamination_coverage = true ; Whether pesticide residue covered

; Potency/Labeling
incorrect_potency_coverage = ?                    ; Whether incorrect potency claims covered
mislabeling_coverage = ?                          ; Whether mislabeling claims covered
thc_overdose_coverage = ?                         ; Consumer overconsumption
allergen_disclosure_coverage = ?                  ; Whether allergen disclosure claims covered

{@cannabis_product_liability}

; ───────────────────────────────────────────────────────────────────────────────
; Testing and Quality Assurance
; ───────────────────────────────────────────────────────────────────────────────
{.quality_assurance}
third_party_testing = ?                           ; Whether third-party testing used
testing_lab_name = ::if third_party_testing = true ; Name of testing laboratory
coa_for_each_batch = ?                            ; Certificate of Analysis
potency_testing = ?                               ; Whether potency testing performed
contaminant_testing = ?                           ; Whether contaminant testing performed
homogeneity_testing = ?:if products.edibles = true ; Whether homogeneity testing for edibles
retain_samples = ?                                ; Whether samples retained
sample_retention_days = ##:if retain_samples = true ; Number of days samples retained

{@cannabis_product_liability}

; ───────────────────────────────────────────────────────────────────────────────
; Sales Information
; ───────────────────────────────────────────────────────────────────────────────
annual_product_sales = #$:(0..)                   ; Total annual product sales
white_label_products = ?                          ; Products sold under other brands
wholesale_sales = ?                               ; Whether wholesale sales conducted
direct_to_consumer_sales = ?                      ; Whether direct-to-consumer sales conducted

; ═══════════════════════════════════════════════════════════════════════════════
; Cannabis Product Recall Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@cannabis_product_recall}
coverage_id = :                                   ; Unique identifier for coverage

; ───────────────────────────────────────────────────────────────────────────────
; Recall Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.coverage}
included = ?                                      ; Whether product recall coverage included
limit = #$:(0..):if coverage.included = true      ; Per-recall coverage limit
deductible = #$:(0..):if coverage.included = true ; Deductible amount
aggregate_limit = #$:(0..):if coverage.included = true ; Aggregate limit

; Trigger
voluntary_recall = ?:if coverage.included = true  ; Whether voluntary recalls covered
mandatory_recall = ?:if coverage.included = true  ; Government ordered
third_party_recall = ?:if coverage.included = true ; Supplier contamination

{@cannabis_product_recall}

; ───────────────────────────────────────────────────────────────────────────────
; Covered Expenses
; ───────────────────────────────────────────────────────────────────────────────
{.expenses}
notification_costs = ?:if coverage.included = true ; Whether notification costs covered
product_retrieval = ?:if coverage.included = true ; Whether product retrieval costs covered
storage_costs = ?:if coverage.included = true     ; Whether storage costs covered
destruction_disposal = ?:if coverage.included = true ; Whether destruction/disposal costs covered
transportation_costs = ?:if coverage.included = true ; Whether transportation costs covered
replacement_product = ?:if coverage.included = true ; Whether replacement product costs covered
public_relations = ?:if coverage.included = true  ; Whether PR costs covered
third_party_consultant = ?:if coverage.included = true ; Whether consultant costs covered
overtime_labor = ?:if coverage.included = true    ; Whether overtime labor costs covered
lost_profits = ?:if coverage.included = true      ; Whether lost profits covered
business_interruption = ?:if coverage.included = true ; Whether business interruption covered

{@cannabis_product_recall}

; ───────────────────────────────────────────────────────────────────────────────
; Recall Plan
; ───────────────────────────────────────────────────────────────────────────────
{.recall_plan}
written_recall_plan = ?                           ; Whether written recall plan exists
updated = date:if written_recall_plan = true      ; Date recall plan last updated
mock_recall_conducted = ?                         ; Whether mock recalls conducted
last_mock_recall_date = date:if mock_recall_conducted = true ; Date of last mock recall
recall_coordinator_designated = ?                 ; Whether recall coordinator designated
regulatory_notification_procedures = ?            ; Whether notification procedures documented

{@cannabis_product_recall}

; ═══════════════════════════════════════════════════════════════════════════════
; Cannabis Premises Liability Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@cannabis_premises_liability}
= @liability_coverage                             ; Inherit from liability line

coverage_id = :                                   ; Unique identifier for coverage
facility_ref = :                                  ; Reference to @cannabis_facility.id

; ───────────────────────────────────────────────────────────────────────────────
; Premises Type
; ───────────────────────────────────────────────────────────────────────────────
premises_type = (
    cultivation_facility,                         ; Cultivation facility
    manufacturing_facility,                       ; Manufacturing facility
    distribution_warehouse,                       ; Distribution warehouse
    retail_dispensary,                            ; Retail dispensary
    consumption_lounge,                           ; On-site consumption lounge
    testing_laboratory,                           ; Testing laboratory
    delivery_hub,                                 ; Delivery hub
    office_only                                   ; Office only (no cannabis operations)
)

; ───────────────────────────────────────────────────────────────────────────────
; Visitor Exposure
; ───────────────────────────────────────────────────────────────────────────────
{.visitor_exposure}
open_to_public = ?                                ; Whether facility is open to public
annual_customer_visits = ##:(0..):if open_to_public = true ; Number of annual customer visits
delivery_customers = ##:(0..)                     ; Number of delivery customers per year
vendors_contractors_daily = ##:(0..)              ; Average daily vendors and contractors
tours_offered = ?                                 ; Whether facility tours offered
tour_frequency = (daily, weekly, monthly, by_appointment):if tours_offered = true ; Frequency of tours

{@cannabis_premises_liability}

; ───────────────────────────────────────────────────────────────────────────────
; Consumption Lounge (if applicable)
; ───────────────────────────────────────────────────────────────────────────────
{.consumption_lounge}
onsite_consumption_allowed = ?                    ; Whether on-site consumption allowed
seating_capacity = ##:if onsite_consumption_allowed = true ; Seating capacity
smoking_lounge = ?:if onsite_consumption_allowed = true ; Whether smoking allowed
edibles_consumption = ?:if onsite_consumption_allowed = true ; Whether edibles consumption allowed
beverages_consumption = ?:if onsite_consumption_allowed = true ; Whether beverages consumption allowed
ventilation_system = ?:if smoking_lounge = true   ; Whether ventilation system installed
serving_limits_enforced = ?:if onsite_consumption_allowed = true ; Whether serving limits enforced
intoxication_monitoring = ?:if onsite_consumption_allowed = true ; Whether intoxication monitored
transportation_services = ?:if onsite_consumption_allowed = true ; Whether transportation offered

{@cannabis_premises_liability}

; ───────────────────────────────────────────────────────────────────────────────
; Limits
; ───────────────────────────────────────────────────────────────────────────────
{.limits}
each_occurrence = #$:(0..)                        ; Per-occurrence limit
general_aggregate = #$:(0..)                      ; General aggregate limit
fire_damage = #$:(0..)                            ; Fire damage limit to rented premises
medical_payments = #$:(0..)                       ; Medical payments limit

{@cannabis_premises_liability}

; ═══════════════════════════════════════════════════════════════════════════════
; Cannabis Directors & Officers Coverage
; ═══════════════════════════════════════════════════════════════════════════════
; D&O coverage for cannabis company executives

{@cannabis_do_coverage}
coverage_id = :                                   ; Unique identifier for coverage

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Structure
; ───────────────────────────────────────────────────────────────────────────────
{.limits}
aggregate_limit = #$:(0..)                        ; Total aggregate limit
side_a_limit = #$:(0..)                          ; Non-indemnifiable losses
side_b_limit = #$:(0..)                          ; Corporate reimbursement
side_c_limit = #$:(0..)                          ; Entity coverage
retention = #$:(0..)                              ; Self-insured retention (deductible)

{@cannabis_do_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Cannabis-Specific D&O Risks
; ───────────────────────────────────────────────────────────────────────────────
{.cannabis_risks}
; Regulatory Risks
regulatory_investigation_defense = ?              ; Whether regulatory investigation defense covered
license_revocation_defense = ?                    ; Whether license revocation defense covered
tax_280e_compliance_claims = ?                    ; Whether 280E tax claims covered

; Investor Claims
investor_claims_coverage = ?                      ; Whether investor claims covered
private_placement_coverage = ?                    ; Whether private placement claims covered
securities_claims = ?                             ; Whether securities claims covered

; Banking/Financial
banking_relationship_claims = ?                   ; Whether banking relationship claims covered
financial_misrepresentation = ?                   ; Whether financial misrepresentation covered

; Federal Exposure
federal_prosecution_defense = ?                   ; Whether federal prosecution defense covered
asset_forfeiture_defense = ?                      ; Whether asset forfeiture defense covered

{@cannabis_do_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Insured Persons
; ───────────────────────────────────────────────────────────────────────────────
{.insured_persons}
directors = ?true                                 ; Whether directors covered
officers = ?true                                  ; Whether officers covered
managers = ?                                      ; LLC managers
general_counsel = ?                               ; Whether general counsel covered
compliance_officers = ?                           ; Whether compliance officers covered
former_do_coverage = ?                            ; Whether former directors/officers covered
former_do_years = ##:(1..10):if former_do_coverage = true ; Years of coverage for former D&O

{@cannabis_do_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Cannabis Regulatory/Compliance Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@cannabis_compliance_coverage}
coverage_id = :                                   ; Unique identifier for coverage

; ───────────────────────────────────────────────────────────────────────────────
; License Protection
; ───────────────────────────────────────────────────────────────────────────────
{.license_protection}
included = ?                                      ; Whether license protection coverage included
limit = #$:(0..):if license_protection.included = true ; Coverage limit for license protection
deductible = #$:(0..):if license_protection.included = true ; Deductible amount

; Covered Events
administrative_hearing_defense = ?:if license_protection.included = true ; Whether hearing defense covered
license_suspension_income = ?:if license_protection.included = true ; Whether income loss during suspension covered
license_revocation_defense = ?:if license_protection.included = true ; Whether revocation defense covered
appeal_costs = ?:if license_protection.included = true ; Whether appeal costs covered
compliance_consultant = ?:if license_protection.included = true ; Whether consultant costs covered

{@cannabis_compliance_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Regulatory Defense
; ───────────────────────────────────────────────────────────────────────────────
{.regulatory_defense}
included = ?                                      ; Whether regulatory defense coverage included
limit = #$:(0..):if regulatory_defense.included = true ; Regulatory defense coverage limit

; Agencies
state_cannabis_agency = ?:if regulatory_defense.included = true ; Whether state cannabis agency claims covered
local_enforcement = ?:if regulatory_defense.included = true ; Whether local enforcement claims covered
tax_authority = ?:if regulatory_defense.included = true ; Whether tax authority claims covered
environmental_agency = ?:if regulatory_defense.included = true ; Whether environmental agency claims covered
osha = ?:if regulatory_defense.included = true    ; Whether OSHA claims covered

{@cannabis_compliance_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Compliance Program Status
; ───────────────────────────────────────────────────────────────────────────────
{.compliance_program}
written_compliance_plan = ?                       ; Whether written compliance plan exists
compliance_officer_designated = ?                 ; Whether compliance officer designated
regular_compliance_audits = ?                     ; Whether regular compliance audits conducted
audit_frequency = (annual, quarterly, semi_annual):if regular_compliance_audits = true ; Frequency of compliance audits
employee_compliance_training = ?                  ; Whether employee training conducted
track_and_trace_compliance = ?                    ; Whether track and trace compliance maintained

{@cannabis_compliance_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Cannabis Workers Compensation
; ═══════════════════════════════════════════════════════════════════════════════

{@cannabis_workers_comp}
coverage_id = :                                   ; Unique identifier for coverage

; ───────────────────────────────────────────────────────────────────────────────
; Employee Information
; ───────────────────────────────────────────────────────────────────────────────
{.employees}
full_time_count = ##:(0..)                        ; Number of full-time employees
part_time_count = ##:(0..)                        ; Number of part-time employees
seasonal_count = ##:(0..)                         ; Number of seasonal employees
total_annual_payroll = #$:(0..)                   ; Total annual payroll

{@cannabis_workers_comp}

; ───────────────────────────────────────────────────────────────────────────────
; Classification by Operation
; ───────────────────────────────────────────────────────────────────────────────
{.classifications[]}
operation_type = (
    cultivation_indoor,                           ; Indoor cultivation operations
    cultivation_outdoor,                          ; Outdoor cultivation operations
    manufacturing_non_volatile,                   ; Non-volatile manufacturing
    manufacturing_volatile,                       ; Volatile manufacturing (higher risk)
    distribution_warehouse,                       ; Distribution and warehousing
    transportation,                               ; Transportation operations
    retail_dispensary,                            ; Retail dispensary operations
    laboratory_testing,                           ; Laboratory testing
    office_clerical                               ; Office/clerical work
)
payroll = #$:(0..)                                ; Payroll for this classification
employee_count = ##:(0..)                         ; Number of employees in this classification

{@cannabis_workers_comp}

; ───────────────────────────────────────────────────────────────────────────────
; Cannabis-Specific Hazards
; ───────────────────────────────────────────────────────────────────────────────
{.hazards}
extraction_equipment = ?                          ; Whether extraction equipment present
volatile_solvents = ?                             ; Whether volatile solvents used
heavy_machinery = ?                               ; Whether heavy machinery used
electrical_systems = ?                            ; Whether high-voltage electrical systems present
chemical_exposure = ?                             ; Whether chemical exposure risk exists
ergonomic_trimming = ?                            ; Whether repetitive trimming work performed
heat_exposure_grow_rooms = ?                      ; Whether heat exposure in grow rooms

{@cannabis_workers_comp}

; ═══════════════════════════════════════════════════════════════════════════════
; Cannabis Endorsement
; ═══════════════════════════════════════════════════════════════════════════════

{@cannabis_endorsement}
id = :                                            ; Unique identifier for endorsement
number = :                                        ; Endorsement number
title = :                                         ; Endorsement title
effective_date = date                             ; Effective date of endorsement

; Endorsement Type
type = (
    ; Coverage Modifications
    additional_insured,                           ; Add additional insured party
    additional_location,                          ; Add additional location
    cash_limit_increase,                          ; Increase cash coverage limit
    crop_coverage_extension,                      ; Extend crop coverage
    equipment_schedule,                           ; Schedule specific equipment
    limit_increase,                               ; Increase coverage limit
    limit_decrease,                               ; Decrease coverage limit
    ; Exclusions
    consumption_lounge_exclusion,                 ; Exclude consumption lounge
    delivery_exclusion,                           ; Exclude delivery operations
    extraction_exclusion,                         ; Exclude extraction operations
    outdoor_cultivation_exclusion,                ; Exclude outdoor cultivation
    product_exclusion,                            ; Exclude specific products
    ; Conditions
    compliance_condition,                         ; Add compliance condition
    license_warranty,                             ; Add license warranty
    security_requirement,                         ; Add security requirement
    track_and_trace_condition,                    ; Add track and trace condition
    ; Other
    loss_payee,                                   ; Add loss payee
    waiver_of_subrogation,                        ; Waive subrogation rights
    other                                         ; Other endorsement type
)

description = :                                   ; Description of endorsement
premium_impact = #$                               ; Premium impact (positive or negative)

; ═══════════════════════════════════════════════════════════════════════════════
; Cannabis Claim
; ═══════════════════════════════════════════════════════════════════════════════

{@cannabis_claim}
id = :                                            ; Unique identifier for claim
policy_ref = :                                    ; Reference to @cannabis_policy.id
number = :                                        ; Claim number

; ───────────────────────────────────────────────────────────────────────────────
; Claim Identification
; ───────────────────────────────────────────────────────────────────────────────
date_of_loss = date                               ; Date loss occurred
date_reported = date                              ; Date claim was reported
date_of_discovery = date                          ; Date loss was discovered

; ───────────────────────────────────────────────────────────────────────────────
; Claim Type
; ───────────────────────────────────────────────────────────────────────────────
type = (
    ; Property Claims
    building_damage,                              ; Damage to building
    equipment_breakdown,                          ; Equipment breakdown loss
    crop_loss_disease,                            ; Crop loss due to disease
    crop_loss_environmental,                      ; Crop loss due to environmental factors
    crop_loss_equipment_failure,                  ; Crop loss due to equipment failure
    crop_loss_theft,                              ; Crop loss due to theft
    stock_loss,                                   ; Stock/inventory loss
    ; Cash Claims
    cash_theft_inside,                            ; Cash theft inside premises
    cash_theft_in_transit,                        ; Cash theft in transit
    cash_robbery,                                 ; Cash robbery
    employee_theft,                               ; Employee theft
    ; Product Claims
    product_contamination,                        ; Product contamination claim
    product_liability_injury,                     ; Product liability bodily injury
    product_recall,                               ; Product recall claim
    mislabeling_claim,                            ; Product mislabeling claim
    potency_claim,                                ; Incorrect potency claim
    ; Liability Claims
    premises_bodily_injury,                       ; Bodily injury on premises
    premises_property_damage,                     ; Property damage on premises
    consumption_lounge_injury,                    ; Injury in consumption lounge
    ; Transportation
    transit_loss,                                 ; Loss during transit
    vehicle_accident,                             ; Vehicle accident
    ; Regulatory
    license_suspension,                           ; License suspension claim
    compliance_violation,                         ; Compliance violation claim
    ; Other
    do_claim,                                     ; Directors & officers claim
    cyber_claim,                                  ; Cyber-related claim
    other                                         ; Other claim type
)

claim_description = :                             ; Description of claim

; ───────────────────────────────────────────────────────────────────────────────
; Claim Status
; ───────────────────────────────────────────────────────────────────────────────
status = (open, closed_paid, closed_no_payment, litigation, subrogation) ; Current claim status
coverage_determination = (covered, denied, partial, pending_investigation) ; Coverage determination

; ───────────────────────────────────────────────────────────────────────────────
; Financial
; ───────────────────────────────────────────────────────────────────────────────
{.financials}
incurred = #$:(0..)                               ; Total amount incurred
paid = #$:(0..)                                   ; Amount paid to date
reserved = #$:(0..)                               ; Amount in reserves
recovered = #$:(0..)                              ; Amount recovered (subrogation/salvage)

{@cannabis_claim}

; ═══════════════════════════════════════════════════════════════════════════════
; Cannabis Policy (Composes All Parts)
; ═══════════════════════════════════════════════════════════════════════════════

{@cannabis_policy}
id = :                                            ; Unique identifier for policy
policy_number = :                                 ; Policy number

; ───────────────────────────────────────────────────────────────────────────────
; Term
; ───────────────────────────────────────────────────────────────────────────────
effective_date = date                             ; Policy effective date
effective_time = time                             ; Policy effective time
expiration_date = date                            ; Policy expiration date
expiration_time = time                            ; Policy expiration time
:invariant expiration_date > effective_date       ; Expiration must be after effective date

; ───────────────────────────────────────────────────────────────────────────────
; Policy Type
; ───────────────────────────────────────────────────────────────────────────────
policy_form = (
    admitted,                                     ; State-licensed carrier
    surplus_lines,                                ; Non-admitted carrier
    captive,                                      ; Captive insurance carrier
    risk_retention_group                          ; Risk retention group
)

market_type = (
    standard,                                     ; Standard market
    specialty_cannabis,                           ; Specialty cannabis market
    excess_surplus                                ; Excess and surplus lines market
)

; ───────────────────────────────────────────────────────────────────────────────
; Named Insured
; ───────────────────────────────────────────────────────────────────────────────
named_insured = @entity.business                  ; Named insured business entity

; ───────────────────────────────────────────────────────────────────────────────
; Licenses
; ───────────────────────────────────────────────────────────────────────────────
licenses[] = @cannabis_license                    ; Array of cannabis licenses

; ───────────────────────────────────────────────────────────────────────────────
; License Warranty (Critical - Coverage Contingent on Valid License)
; ───────────────────────────────────────────────────────────────────────────────
{.license_warranty}
active_license_required = ?true                   ; Whether active license is required for coverage
license_notification_days = ##:(5..30)            ; Days to notify of license change
coverage_voided_if_revoked = ?true                ; Whether coverage voided if license revoked
coverage_suspended_if_suspended = ?true           ; Whether coverage suspended if license suspended

{@cannabis_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Facilities
; ───────────────────────────────────────────────────────────────────────────────
facilities[] = @cannabis_facility                 ; Array of cannabis facilities

; ───────────────────────────────────────────────────────────────────────────────
; Stock/Inventory
; ───────────────────────────────────────────────────────────────────────────────
stock[] = @cannabis_stock                         ; Array of stock/inventory records

; ───────────────────────────────────────────────────────────────────────────────
; Coverages
; ───────────────────────────────────────────────────────────────────────────────
cultivation_coverage = @cannabis_cultivation_coverage ; Cultivation coverage
property_coverage = @cannabis_property_coverage   ; Property coverage
cash_coverage = @cannabis_cash_coverage           ; Cash coverage
transport_coverage = @cannabis_transport_coverage ; Transportation coverage
product_liability = @cannabis_product_liability   ; Product liability coverage
product_recall = @cannabis_product_recall         ; Product recall coverage
premises_liability = @cannabis_premises_liability ; Premises liability coverage
do_coverage = @cannabis_do_coverage               ; Directors & officers coverage
compliance_coverage = @cannabis_compliance_coverage ; Compliance coverage
workers_comp = @cannabis_workers_comp             ; Workers compensation coverage

; ───────────────────────────────────────────────────────────────────────────────
; Endorsements
; ───────────────────────────────────────────────────────────────────────────────
endorsements[] = @cannabis_endorsement            ; Array of policy endorsements

; ───────────────────────────────────────────────────────────────────────────────
; Claims History
; ───────────────────────────────────────────────────────────────────────────────
claims[] = @cannabis_claim                        ; Array of claims

; ───────────────────────────────────────────────────────────────────────────────
; Premium Summary
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
cultivation = #$:(0..)                            ; Cultivation coverage premium
property = #$:(0..)                               ; Property coverage premium
cash = #$:(0..)                                   ; Cash coverage premium
transportation = #$:(0..)                         ; Transportation coverage premium
product_liability = #$:(0..)                      ; Product liability premium
product_recall = #$:(0..)                         ; Product recall premium
premises_liability = #$:(0..)                     ; Premises liability premium
directors_officers = #$:(0..)                     ; Directors & officers premium
compliance = #$:(0..)                             ; Compliance coverage premium
workers_comp = #$:(0..)                           ; Workers compensation premium
endorsements = #$:(0..)                           ; Total endorsement premiums
taxes_fees = #$:(0..)                             ; Taxes and fees
total = #$:(0..)                                  ; Total policy premium
minimum = #$:(0..)                                ; Minimum earned premium
deposit = #$:(0..)                                ; Deposit premium

{@cannabis_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Surplus Lines Information (if applicable)
; ───────────────────────────────────────────────────────────────────────────────
{.surplus_lines}
surplus_lines_broker = ::if policy_form = surplus_lines ; Name of surplus lines broker
surplus_lines_license = ::if policy_form = surplus_lines ; Broker's surplus lines license number
state_filing_fee = #$:(0..):if policy_form = surplus_lines ; State filing fee
state_tax_rate = #:(0..10):if policy_form = surplus_lines ; State surplus lines tax rate percentage
stamping_fee = #$:(0..):if policy_form = surplus_lines ; Stamping office fee
insurer_admitted_state = :(2):if policy_form = surplus_lines ; State where insurer is admitted

{@cannabis_policy}


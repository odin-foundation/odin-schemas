; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Equipment Breakdown Insurance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Equipment breakdown (boiler and machinery) insurance covering mechanical,
; electrical, pressure, HVAC, production, electronic, and renewable energy
; equipment including business income, spoilage, and utility interruption.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../coverages/coverage.schema.odin" as cov
@import "../../coverages/lines/property.schema.odin" as property
@import "../../common/types.schema.odin" as com
@import "../business.schema.odin" as entity
@import "../business-location.schema.odin" as location

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.property.equipment-breakdown"
version = "1.0.0"
title = "Equipment Breakdown Insurance Schema"
description = "Comprehensive equipment breakdown coverage extending universal coverage primitive"

{$derivation}
source[0].authority = "U.S. Department of Energy"
source[0].citation = "Energy Equipment Standards and Regulations"
source[0].url = "https://www.energy.gov/eere/buildings/standards-and-regulations"

source[1].authority = "Occupational Safety and Health Administration"
source[1].citation = "29 CFR 1910.217 - Mechanical Power Presses"
source[1].url = "https://www.osha.gov/laws-regs/regulations/standardnumber/1910/1910.217"

source[2].authority = "National Board of Boiler and Pressure Vessel Inspectors"
source[2].citation = "National Board Inspection Code"
source[2].url = "https://www.nationalboard.org/"

source[3].authority = "American Society of Mechanical Engineers"
source[3].citation = "ASME Boiler and Pressure Vessel Code"
source[3].url = "https://www.asme.org/codes-standards/find-codes-standards/bpvc-boiler-pressure-vessel-code"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Equipment breakdown schema based on OSHA regulations, ASME codes, and National Board standards"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial equipment breakdown schema"
changelog[0].rationale = "Coverage-centric architecture - standalone EB coverage for commercial property"

; ═══════════════════════════════════════════════════════════════════════════════
; Equipment Item (Scheduled Equipment)
; ═══════════════════════════════════════════════════════════════════════════════

{@eb_equipment}
sequence = ##:(1..)                            ; Equipment item sequence number
location_number = ##:(1..)                     ; Location identifier
building_number = ##:(1..)                     ; Building identifier within location

id = :                                         ; Unique equipment identifier

; ───────────────────────────────────────────────────────────────────────────────
; Equipment Identification
; ───────────────────────────────────────────────────────────────────────────────
description = :                                ; Equipment description
manufacturer = :                               ; Equipment manufacturer
model = :                                      ; Equipment model number
serial_number = :                              ; Equipment serial number

; Equipment Category
category = (                                   ; Primary equipment category
    communications,
    computer_systems,
    control_systems,
    electrical_distribution,
    engines_turbines,
    generators,
    hvac_refrigeration,
    mechanical_production,
    motors_compressors,
    other,
    pressure_vessels_boilers,
    pumps_fans,
    renewable_energy,
    transformers
)
category_description = ::if category = other  ; Description when category is other

; Subcategory Detail
subcategory = (                                ; Detailed equipment subcategory
    ; Mechanical
    air_compressor,
    centrifugal_pump,
    conveyor_system,
    diesel_engine,
    electric_motor,
    gas_engine,
    hydraulic_press,
    reciprocating_compressor,
    rotary_pump,
    screw_compressor,
    ; Electrical
    bus_duct,
    circuit_breaker,
    control_panel,
    diesel_generator,
    dry_transformer,
    gas_turbine_generator,
    liquid_filled_transformer,
    motor_control_center,
    solar_inverter,
    switchgear,
    ups_system,
    wind_turbine_generator,
    ; Pressure
    boiler_fire_tube,
    boiler_water_tube,
    expansion_tank,
    heat_exchanger,
    hot_water_heater,
    pressure_vessel,
    process_piping,
    steam_generator,
    ; HVAC
    air_handler,
    chiller_absorption,
    chiller_centrifugal,
    chiller_reciprocating,
    chiller_screw,
    cooling_tower,
    furnace,
    heat_pump,
    refrigeration_system,
    rooftop_unit,
    ; Production
    cnc_machine,
    food_processing_equipment,
    injection_molder,
    packaging_equipment,
    printing_press,
    robot_automation,
    ; Electronic
    data_center_equipment,
    plc_controller,
    security_system,
    server,
    telecom_switch,
    ; Renewable
    battery_storage,
    geothermal_heat_pump,
    solar_panel_array,
    wind_turbine,
    ; Other
    elevator,
    escalator,
    fire_suppression,
    other
)

; ───────────────────────────────────────────────────────────────────────────────
; Equipment Specifications
; ───────────────────────────────────────────────────────────────────────────────
{.specifications}
year_manufactured = ##:(1900..2100)            ; Year equipment was manufactured
year_installed = ##:(1900..2100)               ; Year equipment was installed
horsepower = #                                 ; Equipment horsepower rating
voltage = ##                                   ; Operating voltage
amperage = ##                                  ; Operating amperage
pressure_psi = ##                              ; Operating pressure in PSI
capacity_tons = #                              ; Equipment capacity in tons
btu_rating = ##                                ; BTU rating
kw_rating = #                                  ; Kilowatt rating
kva_rating = #                                 ; Kilovolt-ampere rating

{@eb_equipment}

; ───────────────────────────────────────────────────────────────────────────────
; Condition and Maintenance
; ───────────────────────────────────────────────────────────────────────────────
{.condition}
age_years = ##                                 ; Age of equipment in years
condition_rating = (excellent, good, fair, poor)  ; Physical condition rating
last_inspection_date = date                    ; Date of last inspection
next_inspection_due = date                     ; Next scheduled inspection date
inspection_authority = :                       ; Authority conducting inspections
inspection_certificate_number = :              ; Inspection certificate number

{@eb_equipment}

{.maintenance}
maintenance_contract = ?                       ; Maintenance contract in place
maintenance_provider = ::if maintenance_contract = true  ; Maintenance service provider
maintenance_frequency = (monthly, quarterly, semi_annual, annual):if maintenance_contract = true  ; Frequency of scheduled maintenance
last_maintenance_date = date                   ; Date of last maintenance service
predictive_maintenance = ?                     ; Predictive maintenance program in use
condition_monitoring = ?                       ; Continuous condition monitoring enabled

{@eb_equipment}

; ───────────────────────────────────────────────────────────────────────────────
; Valuation
; ───────────────────────────────────────────────────────────────────────────────
{.valuation}
replacement_cost = #$                          ; Cost to replace with new equivalent
actual_cash_value = #$                         ; Depreciated current value
original_cost = #$                             ; Original purchase cost
installation_cost = #$                         ; Cost of installation
depreciation_percent = #:(0..100)              ; Percentage depreciated
useful_life_years = ##                         ; Expected useful life in years

{@eb_equipment}

; ───────────────────────────────────────────────────────────────────────────────
; Operational Details
; ───────────────────────────────────────────────────────────────────────────────
{.operations}
critical_equipment = ?                        ; Essential to operations
redundant_equipment = ?                       ; Backup available
backup_equipment_id = ::if redundant_equipment = true  ; ID of backup equipment
hours_operation_daily = ##:(0..24)             ; Hours operated per day
days_operation_weekly = ##:(0..7)              ; Days operated per week
seasonal_use = ?                               ; Equipment used seasonally
peak_season = date_range:if seasonal_use = true  ; Peak season date range

{@eb_equipment}

; ───────────────────────────────────────────────────────────────────────────────
; Location within Building
; ───────────────────────────────────────────────────────────────────────────────
{.location}
floor = ##                                     ; Floor number in building
room = :                                       ; Room number or identifier
area_description = :                           ; Description of area
indoor = ?                                     ; Located indoors
outdoor = ?                                    ; Located outdoors
underground = ?                                ; Located underground

{@eb_equipment}

; ───────────────────────────────────────────────────────────────────────────────
; Special Considerations
; ───────────────────────────────────────────────────────────────────────────────
{.special}
hazardous_materials = ?                        ; Uses hazardous materials
hazardous_material_type = ::if hazardous_materials = true  ; Type of hazardous materials
ammonia_system = ?                             ; Uses ammonia system
ammonia_charge_lbs = ##:if ammonia_system = true  ; Ammonia charge in pounds
refrigerant_type = :                           ; Type of refrigerant used
refrigerant_charge_lbs = ##                    ; Refrigerant charge in pounds
high_voltage = ?                              ; >600V
explosion_exposure = ?                         ; Exposed to explosion risk
food_contact = ?                               ; Has food contact surfaces

{@eb_equipment}

; ═══════════════════════════════════════════════════════════════════════════════
; Equipment Breakdown Coverage (Extends @equipment_breakdown_coverage)
; ═══════════════════════════════════════════════════════════════════════════════
; Inherits from @equipment_breakdown_coverage which inherits from @property_coverage <- @coverage

{@eb_commercial_coverage}
= @equipment_breakdown_coverage                   ; Inherit from property line extension

coverage_form = (                              ; Form of equipment breakdown coverage
    blanket_all_equipment,
    comprehensive,
    scheduled,
    specified_perils
)

id = :                                         ; Coverage identifier

; ───────────────────────────────────────────────────────────────────────────────
; Business Income Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.business_income}
included = ?                                   ; Business income coverage included
limit = #$:if business_income.included = true  ; Business income coverage limit
waiting_period_hours = ##:(0, 12, 24, 48, 72, 168):if business_income.included = true  ; Waiting period before coverage starts
period_of_restoration_days = ##:(0..365):if business_income.included = true  ; Maximum restoration period
coinsurance = ##:(50, 60, 70, 80, 90, 100):if business_income.included = true  ; Coinsurance percentage
actual_loss_sustained = ?:if business_income.included = true  ; Actual loss sustained basis
monthly_limit = #$:if business_income.actual_loss_sustained = true  ; Monthly limit if actual loss sustained

{@eb_commercial_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Extra Expense Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.extra_expense}
included = ?                                   ; Extra expense coverage included
limit = #$:if extra_expense.included = true    ; Extra expense coverage limit
waiting_period_hours = ##:(0, 12, 24, 48, 72):if extra_expense.included = true  ; Waiting period in hours
combined_with_bi = ?:if extra_expense.included = true  ; Combined with business income

{@eb_commercial_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Expediting Expense
; ───────────────────────────────────────────────────────────────────────────────
{.expediting}
included = ?true                               ; Expediting expense coverage included
limit = #$                                     ; Expediting expense limit
overtime_labor = ?                             ; Overtime labor costs covered
express_freight = ?                            ; Express shipping costs covered
temporary_repairs = ?                          ; Temporary repair costs covered

{@eb_commercial_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Spoilage Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.spoilage}
included = ?                                   ; Spoilage coverage included
limit = #$:if spoilage.included = true         ; Spoilage coverage limit
deductible = #$:if spoilage.included = true    ; Spoilage coverage deductible
breakdown_or_contamination = ?:if spoilage.included = true  ; Covers breakdown or contamination
off_premises_power_failure = ?:if spoilage.included = true  ; Covers off-premises power failure
on_premises_power_failure = ?:if spoilage.included = true  ; Covers on-premises power failure
ammonia_contamination = ?:if spoilage.included = true  ; Covers ammonia contamination

; Types of Perishables
perishable_types[] = (                         ; Types of perishable goods
    agricultural_products,
    blood_plasma,
    chemicals,
    cosmetics,
    dairy,
    electronics,
    film,
    flowers,
    food_products,
    frozen_goods,
    meat,
    medical_supplies,
    other,
    pharmaceuticals,
    produce,
    seafood,
    vaccines,
    wine
):if spoilage.included = true

refrigerated_space_sqft = ##:if spoilage.included = true  ; Square feet of refrigerated space
average_inventory_value = #$:if spoilage.included = true  ; Average value of perishable inventory

{@eb_commercial_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Hazardous Substances Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.hazardous_substances}
included = ?                                   ; Hazardous substances coverage included
limit = #$:if hazardous_substances.included = true  ; Coverage limit
deductible = #$:if hazardous_substances.included = true  ; Coverage deductible
cleanup_costs = ?:if hazardous_substances.included = true  ; Cleanup costs covered
disposal_costs = ?:if hazardous_substances.included = true  ; Disposal costs covered
testing_costs = ?:if hazardous_substances.included = true  ; Testing costs covered

{@eb_commercial_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Ammonia Contamination Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.ammonia_contamination}
included = ?                                   ; Ammonia contamination coverage included
limit = #$:if ammonia_contamination.included = true  ; Coverage limit
deductible = #$:if ammonia_contamination.included = true  ; Coverage deductible
product_contamination = ?:if ammonia_contamination.included = true  ; Product contamination covered
cleanup_costs = ?:if ammonia_contamination.included = true  ; Cleanup costs covered

{@eb_commercial_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Water Damage Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.water_damage}
included = ?                                   ; Water damage coverage included
limit = #$:if water_damage.included = true     ; Coverage limit
deductible = #$:if water_damage.included = true  ; Coverage deductible
sprinkler_leakage = ?:if water_damage.included = true  ; Sprinkler leakage covered
cooling_water = ?:if water_damage.included = true  ; Cooling water damage covered
steam_discharge = ?:if water_damage.included = true  ; Steam discharge damage covered

{@eb_commercial_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Utility Interruption (Off-Premises)
; ───────────────────────────────────────────────────────────────────────────────
{.utility_interruption}
included = ?                                   ; Utility interruption coverage included
limit = #$:if utility_interruption.included = true  ; Coverage limit
waiting_period_hours = ##:(0, 12, 24, 48):if utility_interruption.included = true  ; Waiting period in hours

; Utility Types
power_supply = ?:if utility_interruption.included = true  ; Power supply interruption covered
water_supply = ?:if utility_interruption.included = true  ; Water supply interruption covered
gas_supply = ?:if utility_interruption.included = true  ; Gas supply interruption covered
telecommunications = ?:if utility_interruption.included = true  ; Telecom interruption covered
wastewater = ?:if utility_interruption.included = true  ; Wastewater service interruption covered

; Transmission Lines
overhead_transmission = ?:if utility_interruption.included = true  ; Overhead transmission lines covered
underground_transmission = ?:if utility_interruption.included = true  ; Underground transmission lines covered

{@eb_commercial_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Contingent Business Income
; ───────────────────────────────────────────────────────────────────────────────
{.contingent_bi}
included = ?                                   ; Contingent business income coverage included
limit = #$:if contingent_bi.included = true    ; Coverage limit
waiting_period_hours = ##:(0, 12, 24, 48, 72):if contingent_bi.included = true  ; Waiting period in hours
suppliers_named[] = ::if contingent_bi.included = true  ; Named suppliers covered
customers_named[] = ::if contingent_bi.included = true  ; Named customers covered

{@eb_commercial_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Ordinance or Law
; ───────────────────────────────────────────────────────────────────────────────
{.ordinance_law}
included = ?                                   ; Ordinance or law coverage included
limit = #$:if ordinance_law.included = true    ; Coverage limit
coverage_a = ?:if ordinance_law.included = true                 ; Undamaged portion
coverage_b = ?:if ordinance_law.included = true                 ; Demolition
coverage_c = ?:if ordinance_law.included = true                 ; Increased cost

{@eb_commercial_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Data Restoration
; ───────────────────────────────────────────────────────────────────────────────
{.data_restoration}
included = ?                                   ; Data restoration coverage included
limit = #$:if data_restoration.included = true  ; Coverage limit
media_replacement = ?:if data_restoration.included = true  ; Media replacement costs covered
data_recreation = ?:if data_restoration.included = true  ; Data recreation costs covered
programming_costs = ?:if data_restoration.included = true  ; Programming costs covered

{@eb_commercial_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Service Interruption (On-Premises)
; ───────────────────────────────────────────────────────────────────────────────
{.service_interruption}
included = ?                                   ; Service interruption coverage included
limit = #$:if service_interruption.included = true  ; Coverage limit
on_premises_power_generation = ?:if service_interruption.included = true  ; On-premises power generation covered

{@eb_commercial_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Green Coverage / Sustainability
; ───────────────────────────────────────────────────────────────────────────────
{.green_coverage}
included = ?                                   ; Green coverage included
limit = #$:if green_coverage.included = true   ; Coverage limit
energy_efficient_replacement = ?:if green_coverage.included = true  ; Energy efficient replacement covered
environmental_upgrade = ?:if green_coverage.included = true  ; Environmental upgrades covered
leed_certification = ?:if green_coverage.included = true  ; LEED certification costs covered

{@eb_commercial_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Covered Equipment Categories
; ───────────────────────────────────────────────────────────────────────────────
{.equipment_categories}
; Mechanical
air_compressors = ?                            ; Air compressors covered
engines = ?                                    ; Engines covered
fans_blowers = ?                               ; Fans and blowers covered
pumps = ?                                      ; Pumps covered
mechanical_production = ?                      ; Mechanical production equipment covered

; Electrical
electrical_distribution = ?                    ; Electrical distribution equipment covered
generators = ?                                 ; Generators covered
motors = ?                                     ; Motors covered
transformers = ?                               ; Transformers covered
ups_battery = ?                                ; UPS and battery systems covered

; Pressure/Process
boilers = ?                                    ; Boilers covered
pressure_vessels = ?                           ; Pressure vessels covered
process_piping = ?                             ; Process piping covered
steam_equipment = ?                            ; Steam equipment covered

; HVAC/Refrigeration
air_conditioning = ?                           ; Air conditioning systems covered
chillers = ?                                   ; Chillers covered
cooling_towers = ?                             ; Cooling towers covered
heating_systems = ?                            ; Heating systems covered
refrigeration = ?                              ; Refrigeration systems covered

; Electronic/Computer
computer_systems = ?                           ; Computer systems covered
control_systems = ?                            ; Control systems covered
data_processing = ?                            ; Data processing equipment covered
telecommunications = ?                         ; Telecommunications equipment covered

; Renewable Energy
solar_systems = ?                              ; Solar systems covered
wind_systems = ?                               ; Wind systems covered
geothermal = ?                                 ; Geothermal systems covered
battery_storage = ?                            ; Battery storage systems covered

; Other
elevators_escalators = ?                       ; Elevators and escalators covered
fire_suppression = ?                           ; Fire suppression systems covered
other_equipment = ?                            ; Other equipment covered

{@eb_commercial_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Exclusions (Tracking what's excluded)
; ───────────────────────────────────────────────────────────────────────────────
{.exclusions}
; Standard Exclusions
deferred_maintenance = ?true                   ; Deferred maintenance excluded
fungus_bacteria = ?true                        ; Fungus and bacteria excluded
explosion_within_vessels = ?true              ; Steam boiler/process vessel explosion covered
testing = ?true                                ; Testing excluded
hydrostatic_pneumatic_testing = ?true          ; Hydrostatic and pneumatic testing excluded
wear_and_tear = ?true                          ; Wear and tear excluded
corrosion_rust = ?true                         ; Corrosion and rust excluded
settling_expansion = ?true                     ; Settling and expansion excluded

; Optional Exclusions
vehicles = ?                                   ; Vehicles excluded
aircraft = ?                                   ; Aircraft excluded
watercraft = ?                                 ; Watercraft excluded
underground_equipment = ?                      ; Underground equipment excluded
offshore_equipment = ?                         ; Offshore equipment excluded
electronic_circuitry = ?                       ; Electronic circuitry excluded

{@eb_commercial_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
base = #$                                      ; Base coverage premium
business_income = #$                           ; Business income coverage premium
extra_expense = #$                             ; Extra expense coverage premium
spoilage = #$                                  ; Spoilage coverage premium
utility_interruption = #$                      ; Utility interruption coverage premium
endorsements = #$                              ; Endorsements premium
total = #$                                     ; Total premium

{@eb_commercial_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Equipment Breakdown Endorsement
; ═══════════════════════════════════════════════════════════════════════════════

{@eb_endorsement}
id = :                                         ; Endorsement identifier
number = :                                     ; Endorsement number
title = :                                      ; Endorsement title
effective_date = date                          ; Endorsement effective date

; Endorsement Type
type = (                                       ; Type of endorsement
    additional_covered_equipment,
    additional_insured,
    ammonia_contamination_extension,
    business_income_extension,
    contingent_bi_extension,
    data_restoration_extension,
    deductible_change,
    equipment_exclusion,
    expediting_expense_extension,
    green_coverage,
    hazardous_substances_extension,
    limit_change,
    ordinance_law_extension,
    other,
    service_interruption_extension,
    spoilage_extension,
    utility_interruption_extension,
    water_damage_extension
)

description = :                                ; Endorsement description
premium_impact = #$                            ; Impact on premium

; ═══════════════════════════════════════════════════════════════════════════════
; Equipment Breakdown Policy (Composes All Parts)
; ═══════════════════════════════════════════════════════════════════════════════

{@eb_policy}
; ───────────────────────────────────────────────────────────────────────────────
; Policy Type
; ───────────────────────────────────────────────────────────────────────────────
type = (                                       ; Type of policy
    monoline,
    package_endorsement,
    primary,
    excess
)

; ───────────────────────────────────────────────────────────────────────────────
; Term
; ───────────────────────────────────────────────────────────────────────────────
effective_date = date                          ; Policy effective date
effective_time = time                          ; Policy effective time
expiration_date = date                         ; Policy expiration date
expiration_time = time                         ; Policy expiration time
:invariant expiration_date > effective_date

id = :                                         ; Policy identifier
number = :                                     ; Policy number

; Package Policy Reference (if endorsement)
underlying_policy_number = ::if type = package_endorsement  ; Underlying policy number
underlying_policy_type = (bop, commercial_property, cpp):if type = package_endorsement  ; Type of underlying policy

; ───────────────────────────────────────────────────────────────────────────────
; Named Insured
; ───────────────────────────────────────────────────────────────────────────────
named_insured = @entity.business               ; Named insured business entity

; ───────────────────────────────────────────────────────────────────────────────
; Locations
; ───────────────────────────────────────────────────────────────────────────────
locations[] = @location.business_location      ; Covered business locations

; ───────────────────────────────────────────────────────────────────────────────
; Coverage
; ───────────────────────────────────────────────────────────────────────────────
coverage = @eb_commercial_coverage             ; Equipment breakdown coverage details

; ───────────────────────────────────────────────────────────────────────────────
; Scheduled Equipment
; ───────────────────────────────────────────────────────────────────────────────
scheduled_equipment[] = @eb_equipment          ; Scheduled equipment items

; ───────────────────────────────────────────────────────────────────────────────
; Equipment Summary by Category
; ───────────────────────────────────────────────────────────────────────────────
{.equipment_summary}
total_equipment_count = ##                     ; Total count of all equipment
total_equipment_value = #$                     ; Total value of all equipment

mechanical_count = ##                          ; Count of mechanical equipment
mechanical_value = #$                          ; Value of mechanical equipment

electrical_count = ##                          ; Count of electrical equipment
electrical_value = #$                          ; Value of electrical equipment

pressure_vessels_count = ##                    ; Count of pressure vessels
pressure_vessels_value = #$                    ; Value of pressure vessels

hvac_count = ##                                ; Count of HVAC equipment
hvac_value = #$                                ; Value of HVAC equipment

production_count = ##                          ; Count of production equipment
production_value = #$                          ; Value of production equipment

electronic_count = ##                          ; Count of electronic equipment
electronic_value = #$                          ; Value of electronic equipment

renewable_count = ##                           ; Count of renewable energy equipment
renewable_value = #$                           ; Value of renewable energy equipment

{@eb_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Inspection Requirements
; ───────────────────────────────────────────────────────────────────────────────
{.inspections}
jurisdictional_inspection_required = ?         ; Jurisdictional inspection required
inspection_provider = :                        ; Inspection service provider
inspection_frequency = (monthly, quarterly, annual, biennial)  ; Frequency of inspections
last_inspection_date = date                    ; Date of last inspection
next_inspection_due = date                     ; Next inspection due date
open_violations = ?                            ; Open violations exist
violation_description = ::if open_violations = true  ; Description of violations

{@eb_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Endorsements
; ───────────────────────────────────────────────────────────────────────────────
endorsements[] = @eb_endorsement               ; Policy endorsements

; ───────────────────────────────────────────────────────────────────────────────
; Premium Summary
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
estimated_annual = #$                          ; Estimated annual premium
minimum = #$                                   ; Minimum premium
deposit = #$                                   ; Deposit premium

{@eb_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Loss History
; ───────────────────────────────────────────────────────────────────────────────
{.loss_history[]}
loss_date = date                               ; Date of loss
equipment_description = :                      ; Description of equipment involved
cause_of_loss = (                              ; Cause of the loss
    arcing,
    bearing_failure,
    centrifugal_force,
    control_system_failure,
    electrical_breakdown,
    explosion,
    mechanical_breakdown,
    operator_error,
    other,
    overheating,
    overpressure,
    power_surge
)
property_damage_paid = #$                      ; Property damage paid
business_income_paid = #$                      ; Business income loss paid
expediting_paid = #$                           ; Expediting expense paid
spoilage_paid = #$                             ; Spoilage loss paid
total_paid = #$                                ; Total amount paid
status = (open, closed, subrogation)           ; Claim status

{@eb_policy}


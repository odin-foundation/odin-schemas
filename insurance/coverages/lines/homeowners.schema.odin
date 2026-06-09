; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Homeowners Coverage Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Homeowners coverage line extension of the universal coverage primitive adding
; dwelling (Coverage A), other structures (B), personal property (C), loss of
; use (D), personal liability (E), and medical payments (F).
; ═══════════════════════════════════════════════════════════════════════════════

@import "../coverage.schema.odin" as cov
@import "../limits.schema.odin" as limits
@import "property.schema.odin" as prop
@import "liability.schema.odin" as liability

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.coverages.lines.homeowners"
version = "1.0.0"
title = "Homeowners Coverage Schema"
description = "Homeowners coverage extending universal coverage primitive"

{$derivation}
source[0].authority = "National Association of Insurance Commissioners (NAIC)"
source[0].citation = "Homeowners Insurance Data Definitions"
source[0].url = "https://content.naic.org/sites/default/files/industry-data-call-property-ho-definitions.pdf"

source[1].authority = "Texas Department of Insurance"
source[1].citation = "Home Insurance Guide"
source[1].url = "https://tdi.texas.gov/pubs/consumer/cb025.html"

source[2].authority = "North Carolina Department of Insurance"
source[2].citation = "Consumer Guide to Homeowners Insurance"
source[2].url = "https://www.ncdoi.gov/consumers/homeowners-insurance"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Homeowners coverage line extension based on NAIC and state regulatory definitions"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial homeowners coverage schema"
changelog[0].rationale = "Coverage-centric architecture - homeowners line extension"

; ═══════════════════════════════════════════════════════════════════════════════
; Homeowners Coverage (Base for all HO coverages)
; ═══════════════════════════════════════════════════════════════════════════════

{@homeowners_coverage}
= @coverage                                       ; Inherit all universal coverage fields

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Section Identifier
; ───────────────────────────────────────────────────────────────────────────────
coverage_section = (A, B, C, D, E, F, endorsement, extension, other)

; ───────────────────────────────────────────────────────────────────────────────
; Peril Coverage Type
; ───────────────────────────────────────────────────────────────────────────────
peril_type = (
    named_perils,                                 ; Covers specific listed perils
    open_perils                                   ; All-risk except exclusions
)

; Named perils (when peril_type = named_perils)
named_perils[] = (
    accidental_discharge_overflow,               ; Water/steam from appliances
    aircraft,
    artificially_generated_electrical_current,
    civil_commotion,
    explosion,
    falling_objects,
    fire,
    freezing,
    hail,
    lightning,
    riot,
    smoke,
    sudden_cracking_burning_bulging,             ; HVAC/water heating systems
    theft,
    vandalism,
    vehicles,
    volcanic_eruption,
    weight_of_ice_snow_sleet,
    windstorm
)

; ───────────────────────────────────────────────────────────────────────────────
; Loss Settlement
; ───────────────────────────────────────────────────────────────────────────────
loss_settlement = (
    actual_cash_value,                           ; Depreciated value
    extended_replacement_cost,                   ; RCV plus percentage
    functional_replacement_cost,                 ; Like kind and quality
    guaranteed_replacement_cost,                 ; Unlimited rebuild
    modified_replacement_cost,                   ; For HO-8 older homes
    replacement_cost                             ; Full cost without depreciation
)

extended_rcv_percent = ##:(0..100):if loss_settlement = extended_replacement_cost
insurance_to_value_percent = ##:(0..100)         ; Coinsurance requirement for full RCV

; ───────────────────────────────────────────────────────────────────────────────
; Limit Structure
; ───────────────────────────────────────────────────────────────────────────────
{.limits}
coverage_limit = #$                              ; Primary limit for this coverage
sublimit = #$                                    ; Sublimit if applicable
aggregate = #$                                   ; Aggregate if applicable
per_occurrence = #$                              ; Per occurrence if applicable

{@homeowners_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Percentage of Coverage A (for B, C, D calculations)
; ───────────────────────────────────────────────────────────────────────────────
percentage_of_coverage_a = ##:(0..100)           ; How limit relates to Coverage A

; ═══════════════════════════════════════════════════════════════════════════════
; Coverage A - Dwelling
; ═══════════════════════════════════════════════════════════════════════════════

{@ho_dwelling_coverage}
= @homeowners_coverage

coverage_section = "A"
coverage_type_ref = "HO_A"

; Dwelling limit (the primary coverage amount)
dwelling_limit = #$
replacement_cost_estimate = #$

; Loss settlement for dwelling
dwelling_loss_settlement = (
    actual_cash_value,
    extended_replacement_cost,
    guaranteed_replacement_cost,
    modified_replacement_cost,
    replacement_cost
)

; Extended/guaranteed replacement cost
extended_rcv_percent = ##:(0..100):if dwelling_loss_settlement = extended_replacement_cost

; Coinsurance (insurance-to-value)
insurance_to_value_required = ##:(0..100)        ; Coinsurance requirement

; Ordinance or law coverage
{.ordinance_law}
included = ?
coverage_a_undamaged_portion = ?                 ; Loss to undamaged portion
coverage_b_demolition = ?                        ; Demolition cost
coverage_c_increased_cost = ?                    ; Increased cost of construction
limit = #$
limit_percent_of_dwelling = #:(0..100)

{@ho_dwelling_coverage}

; Inflation guard
{.inflation_guard}
included = ?
annual_increase_percent = #:(0..25):if included = true

{@ho_dwelling_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Coverage B - Other Structures
; ═══════════════════════════════════════════════════════════════════════════════

{@ho_other_structures_coverage}
= @homeowners_coverage

coverage_section = "B"
coverage_type_ref = "HO_B"

; Other structures limit
other_structures_limit = #$
percentage_of_coverage_a = #:(0..100)            ; Standard: 10%

; What's covered
structures_included[] = (
    barn,
    carport,
    detached_garage,
    fence,
    gazebo,
    guest_house,
    other,
    pool_house,
    retaining_wall,
    shed,
    workshop
)

; Individual structure details (optional for scheduling)
{@ho_other_structures_coverage.scheduled_structures[]}
structure_type = :
description = :
square_footage = ##
construction_type = :
year_built = ##:(1800..)
specific_limit = #$

{@ho_other_structures_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Coverage C - Personal Property / Contents
; ═══════════════════════════════════════════════════════════════════════════════

{@ho_personal_property_coverage}
= @homeowners_coverage

coverage_section = "C"
coverage_type_ref = "HO_C"

; Personal property limit
personal_property_limit = #$
percentage_of_coverage_a = #:(0..100)            ; Standard: 50%

; Loss settlement for contents
contents_loss_settlement = (
    actual_cash_value,
    replacement_cost                             ; Requires endorsement on HO-3
)

; Peril coverage type (named perils for most forms, open perils for HO-5)
contents_peril_type = (named_perils, open_perils)

; ───────────────────────────────────────────────────────────────────────────────
; Special Limits of Liability (sublimits for specific property categories)
; ───────────────────────────────────────────────────────────────────────────────
{.special_limits}
; Money and securities
money = #$:(0..)                                 ; Sublimit
bank_notes = #$:(0..)
bullion = #$:(0..)
coins = #$:(0..)
medals = #$:(0..)
securities = #$:(0..)

; Jewelry and precious items
jewelry_theft = #$:(0..)                         ; Sublimit
jewelry_all_perils = #$:(0..)
furs = #$:(0..)
watches = #$:(0..)

; Precious metals and stones
silverware = #$:(0..)                            ; Sublimit
goldware = #$:(0..)
pewterware = #$:(0..)
platinumware = #$:(0..)

; Firearms
firearms_theft = #$:(0..)                        ; Sublimit
firearms_all_perils = #$:(0..)

; Electronics and equipment
electronic_apparatus = #$:(0..)
computers = #$:(0..)
computer_software = #$:(0..)
portable_electronics = #$:(0..)

; Watercraft and trailers
watercraft = #$:(0..)
watercraft_equipment = #$:(0..)
trailers = #$:(0..)

; Business property
business_property_on_premises = #$:(0..)
business_property_off_premises = #$:(0..)

; Collectibles and art
fine_arts = #$:(0..)
stamps = #$:(0..)
collectibles = #$:(0..)
antiques = #$:(0..)

; Other
musical_instruments = #$:(0..)
sports_equipment = #$:(0..)
tools = #$:(0..)
outdoor_equipment = #$:(0..)
grave_markers = #$:(0..)

{@ho_personal_property_coverage}

; Off-premises coverage
off_premises_coverage = ?
off_premises_limit = #$:(0..):if off_premises_coverage = true
off_premises_percent_of_c = ##:(0..100):if off_premises_coverage = true

; Property of students away at school
student_property_coverage = ?
student_property_limit = #$:(0..):if student_property_coverage = true

; ═══════════════════════════════════════════════════════════════════════════════
; Coverage D - Loss of Use / Additional Living Expenses
; ═══════════════════════════════════════════════════════════════════════════════

{@ho_loss_of_use_coverage}
= @homeowners_coverage

coverage_section = "D"
coverage_type_ref = "HO_D"

; Loss of use limit
loss_of_use_limit = #$:(0..)
percentage_of_coverage_a = ##:(0..100)           ; Standard: 20%

; Time limit
maximum_period_months = ##:(0..)                 ; May be unlimited
maximum_period_days = ##:(0..)

; Components of Coverage D
{.components}
; Additional living expenses - increased costs while home uninhabitable
additional_living_expenses = ?
ale_limit = #$:(0..):if additional_living_expenses = true

; Fair rental value - loss of rental income from part of dwelling
fair_rental_value = ?
frv_limit = #$:(0..):if fair_rental_value = true

; Prohibited use - civil authority prohibits occupancy
prohibited_use_by_civil_authority = ?
prohibited_use_limit = #$:(0..):if prohibited_use_by_civil_authority = true
prohibited_use_max_days = ##:(0..):if prohibited_use_by_civil_authority = true

{@ho_loss_of_use_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Coverage E - Personal Liability
; ═══════════════════════════════════════════════════════════════════════════════

{@ho_personal_liability_coverage}
= @homeowners_coverage

coverage_section = "E"
coverage_type_ref = "HO_E"

; Liability limit (common: $100k, $300k, $500k)
liability_limit = #$:(0..)
per_occurrence = ?                               ; Per occurrence

; Defense costs
defense_costs = (outside_limits, within_limits)

; Damage to property of others
damage_to_property_of_others_limit = #$:(0..)    ; Sublimit

; Supplementary coverages
{.supplementary}
claim_expenses = ?
first_aid_expenses = ?
loss_of_earnings = #$:(0..)
court_costs = ?
prejudgment_interest = ?
postjudgment_interest = ?

{@ho_personal_liability_coverage}

; Insured activities covered
{.covered_activities}
premises_operations = ?
personal_activities = ?
residence_employees = ?                          ; Domestic workers
watercraft_liability = ?                         ; Under certain HP limits
recreational_motor_vehicles = ?                  ; Off-road, golf carts

{@ho_personal_liability_coverage}

; Watercraft exclusion threshold
watercraft_hp_threshold = ##:(0..)               ; Above this, excluded

; ═══════════════════════════════════════════════════════════════════════════════
; Coverage F - Medical Payments to Others
; ═══════════════════════════════════════════════════════════════════════════════

{@ho_medical_payments_coverage}
= @homeowners_coverage

coverage_section = "F"
coverage_type_ref = "HO_F"

; Medical payments limit (common: $1,000, $2,000, $5,000)
medical_payments_limit = #$:(0..)
per_person = ?                                   ; Per person

; Time limit for medical expenses
expense_time_limit_years = ##:(0..)              ; Time limit from accident

; No-fault coverage
no_fault_required = ?                            ; Pays regardless of fault

; Who is covered
{.covered_persons}
guests = ?
residence_employees = ?
persons_on_insured_location = ?
persons_off_premises_by_insured_activities = ?

{@ho_medical_payments_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Scheduled Personal Property (Personal Articles Floater)
; ═══════════════════════════════════════════════════════════════════════════════

{@ho_scheduled_property}
scheduled_id = :

; Item details
item_type = (
    cameras,
    coins,
    collectibles,
    fine_arts,
    firearms,
    furs,
    golf_equipment,
    jewelry,
    musical_instruments,
    silverware,
    sports_equipment,
    stamps,
    other
)
item_description = :
scheduled_amount = #$:(0..)
appraisal_date = date
appraisal_value = #$:(0..)
appraiser_name = :

; Coverage details
deductible = #$:(0..)                            ; Scheduled items
coverage_type = (all_risk, named_perils)
mysterious_disappearance = ?                     ; Covered for unexplained loss
breakage = ?                                     ; Covers accidental breakage
pairs_and_sets = ?                               ; Full value if pair/set damaged

; Serial/identification
serial_number = :
make = :
model = :

; ═══════════════════════════════════════════════════════════════════════════════
; Standard Exclusions (Reference for Excluded Perils)
; ═══════════════════════════════════════════════════════════════════════════════

{@ho_exclusions}

; Universal exclusions (apply to all HO policies)
{.universal}
flood = ?true                                    ; Always excluded, requires NFIP
earthquake = ?true                               ; Excluded, endorsement available
war = ?true
nuclear_hazard = ?true
government_action = ?true
neglect = ?true
intentional_loss = ?true
ordinance_or_law = ?                             ; Standard excluded, endorsement available
earth_movement = ?true                           ; Landslide, mudflow, sinkhole, etc.
power_failure = ?                                ; Off-premises
water_damage_surface = ?true                     ; Surface water, flood
water_backup = ?                                 ; Sewer/drain backup (endorsement available)

{@ho_exclusions}

; Property exclusions
{.property_exclusions}
wear_tear_deterioration = ?true
inherent_vice = ?true
mechanical_breakdown = ?true
smog_rust_rot = ?true
mold_fungus = ?                                  ; Limited coverage
pollution = ?true
settling_cracking = ?true
birds_vermin_insects = ?true

{@ho_exclusions}

; Liability exclusions
{.liability_exclusions}
business_activities = ?true
professional_services = ?true
motor_vehicles = ?true                           ; Auto liability separate
aircraft = ?true
watercraft_over_limit = ?                        ; Above HP threshold
intentional_injury = ?true
workers_compensation = ?true                     ; Covered under WC
communicable_disease = ?

{@ho_exclusions}

; ═══════════════════════════════════════════════════════════════════════════════
; Deductibles
; ═══════════════════════════════════════════════════════════════════════════════

{@ho_deductible}
id = :

; Deductible type
type = (
    all_other_perils,                            ; Standard AOP deductible
    hurricane,                                   ; Special hurricane/named storm
    named_storm,                                 ; Named storm (hurricane, tropical storm)
    percentage,                                  ; Percentage of Coverage A
    standard,                                    ; Dollar amount
    wind_hail,                                   ; Wind/hail specific
    disappearing,                                ; Reduces as loss increases
    split                                        ; Different amounts for different perils
)

; Amount
amount = #$:(0..)                                ; Dollar amount
percent_of_coverage_a = #:(0..100)               ; Percentage (hurricane deductibles)

; Applies to
applies_to = (
    all_coverages,
    coverage_a_only,
    property_only,                               ; A, B, C
    liability_excluded,                          ; Property only
    specific_perils
)

; Common deductible amounts: $250, $500, $1000, $2000, $2500, $5000

; Hurricane/wind deductible (applies in coastal states)
; States with hurricane deductibles: AL, CT, DE, FL, GA, HI, LA, ME, MD, MA, MS, NJ, NY, NC, PA, RI, SC, TX, VA, DC
hurricane_deductible_applicable_states[] = :(2)  ; State codes where this applies

; ═══════════════════════════════════════════════════════════════════════════════
; Protection Devices and Discounts
; ═══════════════════════════════════════════════════════════════════════════════

{@ho_protection_devices}

; Fire protection
{.fire}
fire_alarm = ?
fire_alarm_central_station = ?
sprinkler_system = ?
smoke_detectors = ?
fire_extinguishers = ?
deadman_water_shutoff = ?

{@ho_protection_devices}

; Security/burglar
{.security}
burglar_alarm = ?
burglar_alarm_central_station = ?
deadbolt_locks = ?
security_system = ?
security_cameras = ?
gated_community = ?

{@ho_protection_devices}

; Water damage prevention
{.water}
water_leak_detection = ?
automatic_water_shutoff = ?
sump_pump = ?
backup_sump_pump = ?
battery_backup_sump = ?

{@ho_protection_devices}

; Weather protection
{.weather}
storm_shutters = ?
impact_resistant_roof = ?
hip_roof = ?                                     ; Hip roof construction
roof_tie_downs = ?
reinforced_garage_door = ?

{@ho_protection_devices}

; Fire department proximity
protection_class = ##:(1..10)                    ; Fire protection class (1-10 scale)
distance_to_fire_station_miles = #:(0..99)
distance_to_hydrant_feet = ##:(0..)
fire_department_response_subscription = ?        ; Rural areas


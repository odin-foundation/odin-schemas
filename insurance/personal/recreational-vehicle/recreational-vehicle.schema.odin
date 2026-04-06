; ===================================================================================
; ODIN Recreational Vehicle Insurance Schema
; ===================================================================================
; Recreational vehicle insurance for motorhomes (Class A/B/C), travel trailers,
; fifth wheels, pop-up campers, and toy haulers covering liability, collision,
; comprehensive, personal effects, and full-timer coverage.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.recreational-vehicle"
version = "1.0.0"
title = "Recreational Vehicle Insurance Schema"
description = "Comprehensive RV insurance for motorhomes, trailers, and campers"

{$derivation}
source[0].authority = "National Association of Insurance Commissioners (NAIC)"
source[0].citation = "Personal Lines Insurance Data Elements"
source[0].url = "https://content.naic.org/"

source[1].authority = "Recreation Vehicle Industry Association (RVIA)"
source[1].citation = "RV Classification Standards"
source[1].url = "https://www.rvia.org/"

source[2].authority = "Federal Motor Carrier Safety Administration"
source[2].citation = "Motor Vehicle Safety Standards for RVs"
source[2].url = "https://www.fmcsa.dot.gov/"

source[3].authority = "California Department of Insurance"
source[3].citation = "Recreational Vehicle Insurance Consumer Guide"
source[3].url = "https://www.insurance.ca.gov/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on RVIA classifications and state insurance regulations"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial recreational vehicle insurance schema"
changelog[0].rationale = "Personal lines coverage for RVs, motorhomes, and trailers"

; ===================================================================================
; RV Type Classification
; ===================================================================================
; Standard RV classifications per RVIA standards.

{@rv_type}
classification = !(
    class_a_diesel,                           ; Diesel pusher motorhome
    class_a_gas,                              ; Gas Class A motorhome
    class_b,                                  ; Camper van/van conversion
    class_b_plus,                             ; Class B+ (super B)
    class_c,                                  ; Cab-over motorhome
    fifth_wheel,                              ; Fifth wheel trailer
    folding_camper,                           ; Pop-up/tent trailer
    park_model,                               ; Park model trailer
    toy_hauler_motorized,                     ; Motorized toy hauler
    toy_hauler_towable,                       ; Towable toy hauler
    travel_trailer,                           ; Conventional travel trailer
    truck_camper                              ; Slide-in truck camper
)

motorized = ?                                 ; Is self-propelled
towable = ?                                   ; Requires tow vehicle

; ===================================================================================
; RV Vehicle Details
; ===================================================================================
; Detailed RV specifications and features.

{@rv_vehicle}
; Required fields first
body_type = !@rv_type                         ; RV classification
make = !:                                     ; Manufacturer (Thor, Winnebago, etc.)
model = !:                                    ; Model name
model_year = !##:(1950..2100)                 ; Model year
vin = !*:/^[A-HJ-NPR-Z0-9]{17}$/              ; Vehicle identification number

; Optional fields
axle_count = ##:(1..5)                        ; Number of axles
base_weight_lbs = ##                          ; Dry weight
chassis_make = :                              ; Chassis manufacturer
chassis_model = :                             ; Chassis model
engine_type = (diesel, electric, gas, hybrid, propane)
floor_plan = :                                ; Floor plan name
fuel_capacity_gallons = ##                    ; Fuel tank capacity
gvwr_lbs = ##                                 ; Gross vehicle weight rating
hitch_weight_lbs = ##:if body_type.towable = true  ; Tongue/pin weight
length_feet = #:(8..50)                       ; Overall length
license_plate = :                             ; License plate number
license_state = :(2)                          ; Registration state
odometer = ##                                 ; Current mileage
purchase_date = date                          ; Date acquired
purchase_price = #$:(0..)                     ; Purchase price
registration_expiration = date                ; Registration expiry
slide_out_count = ##:(0..6)                   ; Number of slide-outs
sleeping_capacity = ##                        ; Sleep positions
tow_capacity_lbs = ##:if body_type.motorized = true  ; Towing capacity
vehicle_id = :                                ; Internal identifier
width_feet = #:(6..9)                         ; Body width

; ---------------------------------------------------------------------------
; Motorized-Specific Fields
; ---------------------------------------------------------------------------
{.engine}
displacement_liters = #:if body_type.motorized = true
engine_make = ::if body_type.motorized = true
fuel_type = (diesel, gas, propane):if body_type.motorized = true
horsepower = ##:if body_type.motorized = true
transmission = (automatic, manual):if body_type.motorized = true

{@rv_vehicle}

; ---------------------------------------------------------------------------
; Interior Features
; ---------------------------------------------------------------------------
{.interior}
ac_units = ##                                 ; Air conditioner count
awning = ?                                    ; Has awning
bathroom_count = ##                           ; Number of bathrooms
furnace = ?                                   ; Has furnace
generator = ?                                 ; Has generator
generator_watts = ##:if interior.generator = true
holding_tank_capacity = ##                    ; Grey/black water gallons
inverter = ?                                  ; Has power inverter
leveling_system = (automatic, hydraulic, manual, none)
refrigerator = ?                              ; Has refrigerator
solar_panels = ?                              ; Has solar
solar_watts = ##:if interior.solar_panels = true
washer_dryer = ?                              ; Has washer/dryer
water_heater = ?                              ; Has water heater
water_tank_capacity = ##                      ; Fresh water gallons

{@rv_vehicle}

; ---------------------------------------------------------------------------
; Safety Equipment
; ---------------------------------------------------------------------------
{.safety}
backup_camera = ?                             ; Has backup camera
carbon_monoxide_detector = ?                  ; CO detector installed
fire_extinguisher = ?                         ; Fire extinguisher present
lp_gas_detector = ?                           ; LP gas detector
smoke_detector = ?                            ; Smoke detector installed
tire_pressure_monitoring = ?                  ; TPMS installed

{@rv_vehicle}

; ---------------------------------------------------------------------------
; Condition and Modifications
; ---------------------------------------------------------------------------
condition = (excellent, fair, good, poor)     ; Overall condition
modifications[] = :                           ; Aftermarket modifications
original_msrp = #$:(0..)                      ; Original MSRP
salvage_title = ?                             ; Salvage/rebuilt title

; ---------------------------------------------------------------------------
; Storage and Location
; ---------------------------------------------------------------------------
garage_kept = ?                               ; Stored in garage/covered
garaging_address = @address                   ; Primary storage location
storage_type = (
    covered,                                  ; Covered outdoor
    indoor,                                   ; Indoor facility
    outdoor,                                  ; Outdoor uncovered
    rv_park                                   ; RV park/campground
)

; ===================================================================================
; RV Usage
; ===================================================================================
; How the RV is used affects rating.

{@rv_usage}
; Required fields first
primary_use = !(
    full_time_living,                         ; Primary residence
    occasional_vacation,                      ; Few trips per year
    part_time_living,                         ; Extended stays
    rental,                                   ; Rented to others
    seasonal_vacation,                        ; Seasonal use
    weekender                                 ; Weekend use
)

; Optional fields
annual_miles = ##                             ; Estimated annual mileage
commercial_use = ?                            ; Any commercial use
days_used_per_year = ##:(0..365)              ; Days of use annually
destination_states[] = :(2)                   ; States traveled to
international_travel = ?                      ; Mexico/Canada travel
longest_trip_days = ##                        ; Longest single trip
mexico_coverage = ?                           ; Mexico travel coverage
peak_season_months[] = ##:(1..12)             ; Primary use months
primary_destination = (
    boondocking,                              ; Off-grid camping
    full_hookup,                              ; Full hookup sites
    national_parks,                           ; National/state parks
    private_campgrounds,                      ; Private RV parks
    varies                                    ; Mixed destinations
)
towed_vehicle = ?:if body_type.motorized = true  ; Tows a vehicle
towed_vehicle_value = #$:(0..):if towed_vehicle = true

; ===================================================================================
; RV Liability Coverage
; ===================================================================================
; Liability coverage for RV operations.

{@rv_liability}
; Required fields first
bodily_injury_per_person = !#$:(0..)          ; BI per person limit
bodily_injury_per_accident = !#$:(0..)        ; BI per accident limit
property_damage = !#$:(0..)                   ; PD limit

; Optional fields
combined_single_limit = #$:(0..)              ; CSL if used instead
liability_form = (combined_single_limit, split_limits)
mexico_liability = ?                          ; Mexico liability coverage
mexico_limit = #$:(0..):if mexico_liability = true
vacation_liability = ?                        ; Campsite liability
vacation_liability_limit = #$:(0..):if vacation_liability = true

; ===================================================================================
; RV Uninsured/Underinsured Motorist
; ===================================================================================
; UM/UIM coverage options.

{@rv_um_coverage}
; Optional (not required in all states)
bodily_injury_per_person = #$:(0..)           ; UM BI per person
bodily_injury_per_accident = #$:(0..)         ; UM BI per accident
property_damage = #$:(0..)                    ; UMPD limit
stacked = ?                                   ; Stacked coverage
underinsured_bodily_injury_per_person = #$:(0..)
underinsured_bodily_injury_per_accident = #$:(0..)

; ===================================================================================
; RV Medical Payments
; ===================================================================================
; Medical payments coverage.

{@rv_medical_payments}
limit_per_person = #$:(0..)                   ; Per person limit
included = ?                                  ; Coverage included

; ===================================================================================
; RV Physical Damage Coverage
; ===================================================================================
; Comprehensive and collision coverage for the RV.

{@rv_physical_damage}
; Required fields first
coverage_type = !(comprehensive, collision)    ; Coverage type

; Optional fields
actual_cash_value = #$:(0..)                  ; ACV valuation
agreed_value = #$:(0..)                       ; Agreed value amount
deductible = #$:(0..)                         ; Deductible amount
diminishing_deductible = ?                    ; Decreasing deductible
full_replacement = ?                          ; Full replacement coverage
full_replacement_years = ##:if full_replacement = true
glass_deductible = #$:(0..)                   ; Separate glass deductible
stated_amount = #$:(0..)                      ; Stated value
valuation = (
    actual_cash_value,                        ; Depreciated value
    agreed_value,                             ; Pre-agreed amount
    replacement_cost,                         ; New equivalent
    stated_amount                             ; Declared value
)

; ===================================================================================
; RV Personal Effects Coverage
; ===================================================================================
; Coverage for personal belongings inside the RV.

{@rv_personal_effects}
; Optional coverage
limit = #$:(0..)                              ; Total limit
deductible = #$:(0..)                         ; Deductible
included = ?                                  ; Coverage included
per_item_limit = #$:(0..)                     ; Per item sublimit
scheduled_items[] = :                         ; Specifically scheduled items

; Exclusions from personal effects
{.exclusions}
cash = ?true                                  ; Cash excluded
jewelry = ?                                   ; Jewelry excluded
securities = ?true                            ; Securities excluded

{@rv_personal_effects}

; ===================================================================================
; RV Attached Accessories Coverage
; ===================================================================================
; Coverage for permanently attached accessories.

{@rv_attached_accessories}
; Optional coverage
limit = #$:(0..)                              ; Total accessories limit
deductible = #$:(0..)                         ; Deductible
included = ?                                  ; Coverage included

; Covered items
awning = ?                                    ; Awning coverage
cb_radio = ?                                  ; CB/two-way radio
custom_paint = ?                              ; Custom paint/graphics
satellite_dish = ?                            ; Satellite system
solar_panels = ?                              ; Solar panel system

; ---------------------------------------------------------------------------
; Scheduled Accessories
; ---------------------------------------------------------------------------
{.scheduled_items[]}
accessory_type = :                            ; Type of accessory
description = :                               ; Description
value = #$:(0..)                              ; Accessory value

{@rv_attached_accessories}

; ===================================================================================
; RV Emergency Expense Coverage
; ===================================================================================
; Coverage for emergency expenses while traveling.

{@rv_emergency_expense}
; Optional coverage
included = ?                                  ; Coverage included
limit_per_occurrence = #$:(0..)               ; Per incident limit

; Covered expenses
emergency_repairs = ?                         ; Roadside repairs
lodging = ?                                   ; Hotel/motel
meals = ?                                     ; Meal expenses
pet_boarding = ?                              ; Pet boarding costs
rental_rv = ?                                 ; Rental RV coverage
transportation = ?                            ; Transportation home

; Limits
lodging_daily = #$:(0..)                      ; Daily lodging limit
max_days = ##                                 ; Maximum days covered

; ===================================================================================
; Full-Timer Coverage
; ===================================================================================
; Extended coverage for full-time RV residents.

{@rv_full_timer}
; Required if full-time living
full_time_resident = !?                       ; Lives in RV full-time

; Optional coverages
contents_replacement_cost = ?                 ; RC on contents
guest_medical_payments = ?                    ; Guest med pay
guest_medical_limit = #$:(0..):if guest_medical_payments = true
liability_extension = ?                       ; Extended liability
loss_assessment = ?                           ; HOA assessment
loss_of_use = ?                               ; Loss of use coverage
loss_of_use_daily = #$:(0..):if loss_of_use = true
loss_of_use_max = #$:(0..):if loss_of_use = true
personal_liability = ?                        ; Personal liability
personal_liability_limit = #$:(0..):if personal_liability = true
scheduled_property = ?                        ; Scheduled valuables
site_improvements = ?                         ; Awnings, decks, etc.
site_improvements_limit = #$:(0..):if site_improvements = true

; ===================================================================================
; Roadside Assistance
; ===================================================================================
; Roadside assistance and towing coverage.

{@rv_roadside}
; Optional coverage
included = ?                                  ; Coverage included
provider = :                                  ; Service provider

; Covered services
battery_service = ?                           ; Jump start
flat_tire = ?                                 ; Tire change
fuel_delivery = ?                             ; Fuel delivery
lockout = ?                                   ; Locksmith service
towing = ?                                    ; Towing service
towing_limit = #$:(0..):if towing = true
winching = ?                                  ; Extraction service

; Limits
service_calls_per_year = ##                   ; Annual calls allowed

; ===================================================================================
; Towed Vehicle Coverage
; ===================================================================================
; Coverage for vehicles towed behind motorhome.

{@rv_towed_vehicle}
; Required fields
towed_vehicle_vin = !*:/^[A-HJ-NPR-Z0-9]{17}$/  ; Towed vehicle VIN
towed_vehicle_value = !#$:(0..)               ; Towed vehicle value

; Optional fields
collision_coverage = ?                        ; Collision while towed
collision_deductible = #$:(0..):if collision_coverage = true
comprehensive_coverage = ?                    ; Comp while towed
comprehensive_deductible = #$:(0..):if comprehensive_coverage = true
make = :                                      ; Towed vehicle make
model = :                                     ; Towed vehicle model
year = ##                                     ; Towed vehicle year

; ===================================================================================
; RV Driver
; ===================================================================================
; Driver information for rating.

{@rv_driver}
; Required fields first
date_of_birth = !*date                        ; Driver DOB
name = !@person_name                          ; Driver name

; Optional fields
driver_id = :                                 ; Internal identifier
drivers_license = *:                          ; License number
license_state = :(2)                          ; Issuing state
license_status = (
    expired,
    permit,
    revoked,
    suspended,
    valid
)
marital_status = (divorced, married, single, widowed)
occupation = :                                ; Occupation
relationship = (
    child,
    employee,
    other,
    self,
    spouse
)
rv_driving_experience_years = ##              ; Years driving RVs
sex = (female, male)                          ; Gender for rating

; ---------------------------------------------------------------------------
; Driving Record
; ---------------------------------------------------------------------------
accidents_3_years = ##:(0..10)                ; At-fault accidents
dui_dwi = ?                                   ; DUI/DWI history
major_violations_3_years = ##:(0..10)         ; Major violations
minor_violations_3_years = ##:(0..10)         ; Minor violations
sr22_required = ?                             ; SR-22 filing required
suspended_revoked = ?                         ; License suspension history

; ---------------------------------------------------------------------------
; Training and Certification
; ---------------------------------------------------------------------------
defensive_driving = ?                         ; Completed course
rv_driving_course = ?                         ; RV-specific training

; ===================================================================================
; Premium and Rating
; ===================================================================================
; Premium calculation components.

{@rv_premium}
; Required fields first
total_premium = !#$:(0..)                     ; Total annual premium

; Optional fields
collision_premium = #$:(0..)                  ; Collision premium
comprehensive_premium = #$:(0..)              ; Comprehensive premium
emergency_expense_premium = #$:(0..)          ; Emergency expense premium
full_timer_premium = #$:(0..)                 ; Full-timer endorsement
liability_premium = #$:(0..)                  ; Liability premium
medical_payments_premium = #$:(0..)           ; Med pay premium
minimum_premium = #$:(0..)                    ; Minimum annual premium
personal_effects_premium = #$:(0..)           ; Personal effects premium
policy_fee = #$:(0..)                         ; Policy fee
roadside_premium = #$:(0..)                   ; Roadside assistance
taxes_and_fees = #$:(0..)                     ; State taxes/fees
um_uim_premium = #$:(0..)                     ; UM/UIM premium

; ---------------------------------------------------------------------------
; Discounts Applied
; ---------------------------------------------------------------------------
{.discounts}
anti_theft = ?                                ; Anti-theft device
claim_free = ?                                ; Claim-free discount
club_membership = ?                           ; RV club member
defensive_driving = ?                         ; Defensive driving course
multi_policy = ?                              ; Multi-policy discount
new_rv = ?                                    ; New RV discount
paid_in_full = ?                              ; Pay-in-full discount
prior_insurance = ?                           ; Prior coverage discount
rv_course = ?                                 ; RV driving course
safety_features = ?                           ; Safety equipment
storage = ?                                   ; Seasonal storage

{@rv_premium}

; ===================================================================================
; Prior Claims
; ===================================================================================
; Claims history for the RV.

{@rv_prior_claim}
; Required fields first
claim_date = !date                            ; Date of loss
claim_type = !(
    collision,                                ; Collision loss
    comprehensive,                            ; Comp loss
    liability_bi,                             ; BI claim
    liability_pd,                             ; PD claim
    other,                                    ; Other
    personal_effects,                         ; Contents claim
    total_loss,                               ; Total loss
    um_uim                                    ; UM/UIM claim
)

; Optional fields
amount_paid = #$:(0..)                        ; Amount paid
at_fault = ?                                  ; At-fault indicator
claim_id = :                                  ; Claim identifier
claim_status = (closed, open, subrogation)    ; Claim status
description = :                               ; Loss description

; ===================================================================================
; Exclusions
; ===================================================================================
; Policy exclusions.

{@rv_exclusions}
; Standard exclusions
business_use = ?true                          ; Business use excluded
commercial_rental = ?true                     ; Commercial rental excluded
intentional_damage = ?true                    ; Intentional acts
racing = ?true                                ; Racing excluded
war = ?true                                   ; War/terrorism

; Optional exclusions
off_road = ?                                  ; Off-road use excluded
unlicensed_driver = ?                         ; Unlicensed driver

; ===================================================================================
; Endorsements
; ===================================================================================
; Available policy endorsements.

{@rv_endorsement}
; Required fields first
effective_date = !date                        ; Endorsement effective date
endorsement_type = !(
    agreed_value,                             ; Agreed value coverage
    attached_accessories,                     ; Accessories coverage
    emergency_expense,                        ; Emergency expense
    full_replacement,                         ; Total loss replacement
    full_timer,                               ; Full-time residence
    mexico_coverage,                          ; Mexico physical damage
    other,                                    ; Other endorsement
    personal_effects,                         ; Contents coverage
    pet_coverage,                             ; Pet injury coverage
    roadside,                                 ; Roadside assistance
    towed_vehicle,                            ; Towed vehicle coverage
    vacation_liability                        ; Campsite liability
)

; Optional fields
description = :                               ; Endorsement description
endorsement_id = :                            ; Endorsement identifier
expiration_date = date                        ; Expiration if temporary
premium = #$:(0..)                            ; Endorsement premium

; ===================================================================================
; Recreational Vehicle Policy
; ===================================================================================
; Complete policy composition.

{@rv_policy}
; Required fields first
drivers[] = !@rv_driver                       ; Covered drivers
effective_date = !date                        ; Policy effective date
expiration_date = !date                       ; Policy expiration date
liability = !@rv_liability                    ; Liability coverage
policy_number = !:                            ; Policy number
vehicle = !@rv_vehicle                        ; Covered RV

; Invariants
:invariant expiration_date > effective_date

; Optional fields
agency = @agency                              ; Issuing agency
attached_accessories = @rv_attached_accessories  ; Accessories coverage
billing_address = @address                    ; Billing address
collision = @rv_physical_damage               ; Collision coverage
comprehensive = @rv_physical_damage           ; Comprehensive coverage
emergency_expense = @rv_emergency_expense     ; Emergency expense coverage
endorsements[] = @rv_endorsement              ; Policy endorsements
exclusions = @rv_exclusions                   ; Exclusions
full_timer = @rv_full_timer                   ; Full-timer coverage
id = :                                        ; Internal identifier
medical_payments = @rv_medical_payments       ; Med pay coverage
named_insured = @person_name                  ; Named insured
named_insured_address = @address              ; Insured address
personal_effects = @rv_personal_effects       ; Personal effects coverage
policy_form = (
    motorhome,                                ; Motorhome form
    travel_trailer,                           ; Trailer form
    truck_camper                              ; Truck camper form
)
policy_status = (
    active,
    cancelled,
    expired,
    pending,
    renewal
)
premium = @rv_premium                         ; Premium details
prior_claims[] = @rv_prior_claim              ; Prior claims
producer = @producer                          ; Producing agent
roadside = @rv_roadside                       ; Roadside assistance
state_province = :(2)                         ; Issuing state
term_months = ##:(1..12)                      ; Policy term
towed_vehicle = @rv_towed_vehicle             ; Towed vehicle coverage
um_uim = @rv_um_coverage                      ; UM/UIM coverage
underwriting = @underwriting_decision         ; Underwriting decision
usage = @rv_usage                             ; Usage information

; ---------------------------------------------------------------------------
; Coverage Summary
; ---------------------------------------------------------------------------
{.coverage_summary}
collision_deductible = #$:(0..)               ; Collision deductible
comprehensive_deductible = #$:(0..)           ; Comp deductible
liability_limit = :                           ; Liability limit string
total_insured_value = #$:(0..)                ; Total coverage value

{@rv_policy}


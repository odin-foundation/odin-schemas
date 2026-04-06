; ===================================================================================
; ODIN Automotive Inspection Schema
; ===================================================================================
; Vehicle inspections including safety, emissions, and pre-purchase. Derived from
; state inspection programs and EPA regulations.
; ===================================================================================

@import "../common/vehicle.schema.odin" as vehicle
@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.automotive.inspection"
version = "1.0.0"
title = "Automotive Inspection Schema"
description = "Vehicle safety, emissions, and pre-purchase inspections"

{$derivation}
source[0].authority = "Environmental Protection Agency"
source[0].citation = "40 CFR Part 51 Subpart S - Inspection/Maintenance Program Requirements"
source[0].url = "https://www.ecfr.gov/current/title-40/chapter-I/subchapter-C/part-51/subpart-S"

source[1].authority = "National Highway Traffic Safety Administration"
source[1].citation = "Federal Motor Vehicle Safety Standards (FMVSS)"
source[1].url = "https://www.nhtsa.gov/laws-regulations/fmvss"

source[2].authority = "American Association of Motor Vehicle Administrators"
source[2].citation = "AAMVA Vehicle Safety Inspection Guidelines"
source[2].url = "https://www.aamva.org/"

source[3].authority = "National Institute for Automotive Service Excellence"
source[3].citation = "ASE Certification Standards"
source[3].url = "https://www.ase.com/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Vehicle inspection structures per EPA, NHTSA, and state requirements"

changelog[0].date = 2025-12-21
changelog[0].change = "Initial automotive inspection schema"
changelog[0].rationale = "Structures derived from EPA I/M and state safety programs"

; ===================================================================================
; SAFETY INSPECTION
; ===================================================================================
; State safety inspection per AAMVA guidelines.

{@safety_inspection}
; Required fields first
inspection_id = !:                               ; Inspection identifier
vin = !*:format vin                              ; Vehicle VIN
inspection_date = !date                          ; Inspection date
result = !(fail, pass, conditional_pass)         ; Overall result

; Inspection station
{.station}
station_id = !:                                  ; Station identifier
station_name = !:                                ; Station name
station_address = @address                       ; Station address
station_license = :                              ; Station license number
station_type = (dealer, fleet, government, independent)

{@safety_inspection}

; Inspector
{.inspector}
inspector_name = :                               ; Inspector name
inspector_id = :                                 ; Inspector ID/badge
ase_certification = :                            ; ASE certification

{@safety_inspection}

; Vehicle at inspection
{.vehicle}
year = ##:(1900..2100)                           ; Model year
make = :                                         ; Make
model = :                                        ; Model
odometer = ##:(0..)                              ; Odometer at inspection
plate_number = :                                 ; License plate
plate_state = :(2)                               ; Plate state

{@safety_inspection}

; Brakes
{.brakes}
result = !(fail, pass)                           ; Brake system result
front_pads_mm = #:(0..20)                        ; Front pad thickness
rear_pads_mm = #:(0..20)                         ; Rear pad thickness
rotor_condition = (good, needs_attention, replace)
drum_condition = (good, needs_attention, replace):if applicable
parking_brake = (fail, pass)                     ; Parking brake test
brake_lines = (fail, pass)                       ; Brake line condition
abs_warning = ?                                  ; ABS warning light on
notes = :                                        ; Brake notes

{@safety_inspection}

; Steering and suspension
{.steering}
result = !(fail, pass)                           ; Steering result
steering_play = (excessive, normal)              ; Steering wheel play
power_steering = (fail, na, pass)                ; Power steering
tie_rods = (fail, pass)                          ; Tie rod ends
ball_joints = (fail, pass)                       ; Ball joints
shocks_struts = (fail, pass)                     ; Shocks/struts
control_arms = (fail, pass)                      ; Control arms
wheel_bearings = (fail, pass)                    ; Wheel bearings
notes = :                                        ; Steering/suspension notes

{@safety_inspection}

; Tires and wheels
{.tires}
result = !(fail, pass)                           ; Tires result
front_left_tread_32 = ##:(0..20)                 ; FL tread depth (32nds)
front_right_tread_32 = ##:(0..20)                ; FR tread depth
rear_left_tread_32 = ##:(0..20)                  ; RL tread depth
rear_right_tread_32 = ##:(0..20)                 ; RR tread depth
spare_present = ?                                ; Spare present
spare_condition = (flat, good, missing)          ; Spare condition
tire_damage = ?                                  ; Tire damage observed
tire_mismatch = ?                                ; Mismatched tires
wheel_condition = (fail, pass)                   ; Wheel condition
lug_nuts = (fail, pass)                          ; Lug nut security
notes = :                                        ; Tire notes

{@safety_inspection}

; Lights and electrical
{.lights}
result = !(fail, pass)                           ; Lighting result
headlights_low = (fail, pass)                    ; Low beams
headlights_high = (fail, pass)                   ; High beams
headlight_aim = (fail, pass)                     ; Headlight aim
turn_signals_front = (fail, pass)                ; Front turn signals
turn_signals_rear = (fail, pass)                 ; Rear turn signals
brake_lights = (fail, pass)                      ; Brake lights
tail_lights = (fail, pass)                       ; Tail lights
hazard_lights = (fail, pass)                     ; Hazard lights
reverse_lights = (fail, pass)                    ; Reverse lights
license_plate_light = (fail, pass)               ; Plate light
horn = (fail, pass)                              ; Horn
notes = :                                        ; Lighting notes

{@safety_inspection}

; Windshield and wipers
{.glass}
result = !(fail, pass)                           ; Glass result
windshield = (cracked, chipped, fail, pass)      ; Windshield condition
windshield_damage_location = :                   ; Damage location if any
wipers_front = (fail, pass)                      ; Front wipers
wipers_rear = (fail, na, pass)                   ; Rear wiper
washer_system = (fail, pass)                     ; Washer system
defrost = (fail, pass)                           ; Defrost operation
mirrors = (fail, pass)                           ; Mirror condition
notes = :                                        ; Glass notes

{@safety_inspection}

; Body and frame
{.body}
result = !(fail, pass)                           ; Body result
rust_damage = (excessive, minor, none)           ; Rust condition
structural_damage = ?                            ; Structural damage
bumpers = (fail, pass)                           ; Bumper condition
doors = (fail, pass)                             ; Door operation
hood_latch = (fail, pass)                        ; Hood latch
trunk_latch = (fail, pass)                       ; Trunk latch
fuel_door = (fail, pass)                         ; Fuel door
notes = :                                        ; Body notes

{@safety_inspection}

; Exhaust
{.exhaust}
result = !(fail, pass)                           ; Exhaust result
exhaust_leaks = ?                                ; Leaks detected
exhaust_secure = ?                               ; Properly secured
catalytic_converter = (fail, missing, pass)      ; Cat converter
muffler_condition = (fail, pass)                 ; Muffler
notes = :                                        ; Exhaust notes

{@safety_inspection}

; Safety equipment
{.safety_equipment}
result = !(fail, pass)                           ; Safety equipment result
seatbelts_driver = (fail, pass)                  ; Driver seatbelt
seatbelts_passenger = (fail, pass)               ; Passenger seatbelt
seatbelts_rear = (fail, na, pass)                ; Rear seatbelts
airbag_warning = ?                               ; Airbag light on
warning_lights = ?                               ; Other warning lights
notes = :                                        ; Safety equipment notes

{@safety_inspection}

; Sticker/certificate
{.certificate}
sticker_number = :                               ; Inspection sticker number
expiration_date = date                           ; Sticker expiration
fee = #$:(0..)                                   ; Inspection fee

{@safety_inspection}

; Rejection details (if failed)
{.rejection}
rejection_reasons[] = ::if result = fail         ; Reasons for failure
reinspection_required = ?:if result = fail       ; Reinspection needed
reinspection_deadline = date:if result = fail    ; Deadline for reinspection
reinspection_fee = #$:(0..):if result = fail     ; Reinspection fee

{@safety_inspection}

; ===================================================================================
; EMISSIONS INSPECTION
; ===================================================================================
; Emissions testing per EPA 40 CFR Part 51 Subpart S (I/M Programs).

{@emissions_inspection}
; Required fields first
inspection_id = !:                               ; Inspection identifier
vin = !*:format vin                              ; Vehicle VIN
inspection_date = !date                          ; Inspection date
result = !(conditional_pass, fail, pass, waiver)

; Inspection station
{.station}
station_id = !:                                  ; Station identifier
station_name = !:                                ; Station name
station_address = @address                       ; Station address
station_type = (centralized, decentralized)      ; Station type
analyzer_id = :                                  ; Analyzer equipment ID

{@emissions_inspection}

; Inspector
{.inspector}
inspector_name = :                               ; Inspector name
inspector_id = :                                 ; Inspector certification ID

{@emissions_inspection}

; Vehicle at inspection
{.vehicle}
year = ##:(1900..2100)                           ; Model year
make = :                                         ; Make
model = :                                        ; Model
odometer = ##:(0..)                              ; Odometer at inspection
engine_type = :                                  ; Engine type
fuel_type = (diesel, gasoline, hybrid)           ; Fuel type
gvwr_lb = ##:(0..)                               ; GVWR

{@emissions_inspection}

; OBD-II test (1996+ gasoline vehicles)
{.obd}
test_type = (obd_ii, obd_i, na)                  ; OBD test type
mil_commanded = (off, on)                        ; MIL (check engine) status
mil_status = !(fail, pass)                       ; MIL result
dtc_count = ##:(0..)                             ; Stored DTCs
dtc_codes[] = :                                  ; DTC codes if any
readiness_monitors = ##:(0..11)                  ; Monitors set
monitors_not_ready[] = :                         ; Monitors not ready
catalyst_ready = ?                               ; Catalyst monitor
evap_ready = ?                                   ; Evaporative system
oxygen_sensor_ready = ?                          ; O2 sensor
oxygen_heater_ready = ?                          ; O2 heater
egr_ready = ?                                    ; EGR system
secondary_air_ready = ?                          ; Secondary air
ac_refrigerant_ready = ?                         ; A/C refrigerant
misfire_ready = ?                                ; Misfire
fuel_system_ready = ?                            ; Fuel system
comprehensive_ready = ?                          ; Comprehensive component

{@emissions_inspection}

; Tailpipe test (if applicable)
{.tailpipe}
test_type = (as_4000, bar_31, im_240, tsi, two_speed_idle)
hc_ppm = ##:(0..)                                ; Hydrocarbons (ppm)
hc_limit = ##:(0..)                              ; HC limit
hc_result = (fail, pass)                         ; HC result
co_percent = #:(0..15)                           ; Carbon monoxide (%)
co_limit = #:(0..15)                             ; CO limit
co_result = (fail, pass)                         ; CO result
nox_ppm = ##:(0..):if test_type = im_240         ; NOx (ppm) - IM240
nox_limit = ##:(0..):if test_type = im_240       ; NOx limit
nox_result = (fail, pass):if test_type = im_240  ; NOx result
co2_percent = #:(0..20)                          ; CO2 (%)
o2_percent = #:(0..25)                           ; O2 (%)

{@emissions_inspection}

; Diesel test (if diesel)
{.diesel}
test_type = (opacity, loaded_mode, snap_idle)    ; Diesel test type
opacity_percent = #:(0..100)                     ; Opacity (%)
opacity_limit = #:(0..100)                       ; Opacity limit
opacity_result = (fail, pass)                    ; Opacity result
nox_gpm = #:(0..):if test_type = loaded_mode     ; NOx (grams/mile)
pm_gpm = #:(0..):if test_type = loaded_mode      ; PM (grams/mile)

{@emissions_inspection}

; Visual inspection
{.visual}
gas_cap = (fail, missing, pass)                  ; Gas cap inspection
gas_cap_pressure = ?                             ; Gas cap pressure test
evap_system = (fail, pass, tampered)             ; Evap system visual
catalytic_converter = (fail, missing, pass, tampered)
air_injection = (fail, na, pass, tampered)       ; Air injection system
egr_valve = (fail, na, pass, tampered)           ; EGR valve
pcv_valve = (fail, na, pass, tampered)           ; PCV valve
tampering_found = ?                              ; Any tampering found
tampering_description = ::if tampering_found = true

{@emissions_inspection}

; Certificate
{.certificate}
certificate_number = :                           ; Certificate number
expiration_date = date                           ; Certificate expiration
fee = #$:(0..)                                   ; Inspection fee

{@emissions_inspection}

; Waiver (if applicable)
{.waiver}
waiver_granted = ?:if result = waiver            ; Waiver granted
waiver_type = (economic_hardship, equipment_problem, repair_limit, time_extension):if result = waiver
repair_expenditure = #$:(0..):if waiver_type = repair_limit
repair_limit = #$:(0..):if waiver_type = repair_limit
waiver_expiration = date:if result = waiver      ; Waiver expiration
waiver_conditions = ::if result = waiver         ; Conditions

{@emissions_inspection}

; Rejection (if failed)
{.rejection}
rejection_reasons[] = ::if result = fail         ; Failure reasons
repair_recommendations[] = ::if result = fail    ; Recommended repairs
reinspection_deadline = date:if result = fail    ; Reinspection deadline

{@emissions_inspection}

; ===================================================================================
; PRE-PURCHASE INSPECTION
; ===================================================================================
; Independent pre-purchase vehicle inspection.

{@prepurchase_inspection}
; Required fields first
inspection_id = !:                               ; Inspection identifier
vin = !*:format vin                              ; Vehicle VIN
inspection_date = !date                          ; Inspection date
overall_rating = !(excellent, fair, good, not_recommended, poor)

; Inspector/shop
{.inspector}
shop_name = !:                                   ; Shop name
shop_address = @address                          ; Shop address
shop_phone = *@phone                             ; Shop phone
inspector_name = :                               ; Inspector name
ase_certifications[] = :                         ; ASE certifications

{@prepurchase_inspection}

; Inspection type
inspection_type = !(basic, comprehensive, specialty)
specialty_type = ::if inspection_type = specialty ; e.g., "exotic", "classic", "diesel"

; Vehicle details
{.vehicle}
year = ##:(1900..2100)                           ; Model year
make = :                                         ; Make
model = :                                        ; Model
trim = :                                         ; Trim level
odometer = ##:(0..)                              ; Odometer
vin_verified = ?                                 ; VIN matches vehicle

{@prepurchase_inspection}

; Engine
{.engine}
rating = !(excellent, fair, good, needs_repair, poor)
starts_properly = ?                              ; Starts without issue
idle_quality = (rough, smooth)                   ; Idle quality
oil_condition = (clean, dark, sludge)            ; Oil condition
oil_level = (full, low, overfull)                ; Oil level
coolant_level = (full, low)                      ; Coolant level
coolant_condition = (clean, contaminated, rusty)
leaks_observed = ?                               ; Fluid leaks
leak_description = ::if leaks_observed = true
compression_tested = ?                           ; Compression test done
compression_results = ::if compression_tested = true
timing_belt_chain = (belt, chain, na)            ; Belt or chain
timing_service_due = ?                           ; Timing service needed
estimated_repair = #$:(0..)                      ; Repair estimate
notes = :                                        ; Engine notes

{@prepurchase_inspection}

; Transmission
{.transmission}
rating = !(excellent, fair, good, needs_repair, poor)
type = (automatic, cvt, dual_clutch, manual)     ; Transmission type
shifts_properly = ?                              ; Shifts correctly
slipping = ?                                     ; Slipping detected
fluid_condition = (clean, dark, burnt)           ; Fluid condition
fluid_level = (full, low, overfull)              ; Fluid level
leaks = ?                                        ; Transmission leaks
clutch_condition = ::if type = manual            ; Clutch condition
estimated_repair = #$:(0..)                      ; Repair estimate
notes = :                                        ; Transmission notes

{@prepurchase_inspection}

; Brakes
{.brakes}
rating = !(excellent, fair, good, needs_service, poor)
front_pad_percent = ##:(0..100)                  ; Front pad life %
rear_pad_percent = ##:(0..100)                   ; Rear pad life %
rotor_condition = (good, machined, replace, warped)
fluid_condition = (clean, contaminated, dark)
abs_functional = ?                               ; ABS working
estimated_repair = #$:(0..)                      ; Repair estimate
notes = :                                        ; Brake notes

{@prepurchase_inspection}

; Suspension and steering
{.suspension}
rating = !(excellent, fair, good, needs_repair, poor)
ride_quality = (bumpy, harsh, smooth)            ; Ride quality
handling = (loose, normal, tight)                ; Handling feel
alignment_needed = ?                             ; Alignment needed
shocks_struts = (good, leaking, worn)            ; Shock condition
cv_boots = (cracked, good, torn)                 ; CV boot condition
bushings = (cracked, good, worn)                 ; Bushing condition
ball_joints = (good, play, worn)                 ; Ball joint condition
tie_rod_ends = (good, play, worn)                ; Tie rod condition
estimated_repair = #$:(0..)                      ; Repair estimate
notes = :                                        ; Suspension notes

{@prepurchase_inspection}

; Electrical
{.electrical}
rating = !(excellent, fair, good, needs_repair, poor)
battery_condition = (good, weak, replace)        ; Battery condition
battery_age_months = ##:(0..)                    ; Battery age
alternator = (fail, pass)                        ; Alternator test
starter = (fail, pass)                           ; Starter test
warning_lights = ?                               ; Warning lights on
warning_lights_description = ::if warning_lights = true
power_windows = (all_work, some_fail)            ; Window operation
power_locks = (all_work, some_fail)              ; Lock operation
hvac = (all_work, some_fail)                     ; HVAC operation
estimated_repair = #$:(0..)                      ; Repair estimate
notes = :                                        ; Electrical notes

{@prepurchase_inspection}

; Tires
{.tires}
rating = !(excellent, fair, good, needs_replacement, poor)
front_left_tread_32 = ##:(0..20)                 ; FL tread (32nds)
front_right_tread_32 = ##:(0..20)                ; FR tread
rear_left_tread_32 = ##:(0..20)                  ; RL tread
rear_right_tread_32 = ##:(0..20)                 ; RR tread
tire_brand = :                                   ; Tire brand
tire_age_years = ##:(0..)                        ; Tire age
wear_pattern = (cupped, even, feathered, inner, outer)
replacement_needed = ?                           ; Replacement needed
estimated_cost = #$:(0..)                        ; Tire cost estimate
notes = :                                        ; Tire notes

{@prepurchase_inspection}

; Body and paint
{.body}
rating = !(excellent, fair, good, poor)
paint_condition = (excellent, fair, good, poor)  ; Paint condition
paint_meter_used = ?                             ; Paint meter used
repaint_detected = ?                             ; Repaint detected
repaint_panels[] = ::if repaint_detected = true  ; Repainted panels
rust_present = ?                                 ; Rust present
rust_location = ::if rust_present = true         ; Rust location
dents_dings = (many, minor, none, several)       ; Dent assessment
scratches = (deep, minor, none, several)         ; Scratch assessment
glass_condition = (chipped, cracked, good)       ; Glass condition
estimated_repair = #$:(0..)                      ; Repair estimate
notes = :                                        ; Body notes

{@prepurchase_inspection}

; Interior
{.interior}
rating = !(excellent, fair, good, poor)
seat_condition = (excellent, fair, good, torn, worn)
carpet_condition = (clean, fair, stained, worn)
dashboard_condition = (cracked, faded, good)
odors = (mildew, none, pet, smoke)               ; Odor present
headliner = (good, sagging, stained)             ; Headliner
controls_functional = ?                          ; All controls work
notes = :                                        ; Interior notes

{@prepurchase_inspection}

; Test drive
{.test_drive}
completed = ?                                    ; Test drive done
miles_driven = #:(0..)                           ; Miles driven
acceleration = (hesitation, normal, sluggish)    ; Acceleration feel
braking = (normal, pulsating, pulling, soft, squealing)
steering = (normal, pulling, vibration, wandering)
noise_present = ?                                ; Abnormal noises
noise_description = ::if noise_present = true
vibration_present = ?                            ; Abnormal vibration
vibration_description = ::if vibration_present = true
notes = :                                        ; Test drive notes

{@prepurchase_inspection}

; Frame/undercarriage
{.undercarriage}
rating = !(excellent, fair, good, poor)
frame_damage = ?                                 ; Frame damage
frame_rust = (heavy, light, moderate, none)      ; Frame rust
exhaust_condition = (good, leaking, rusted)      ; Exhaust
fluid_leaks = ?                                  ; Leaks from undercarriage
cv_axles = (boots_torn, good, leaking)           ; CV axle condition
notes = :                                        ; Undercarriage notes

{@prepurchase_inspection}

; Accident history assessment
{.accident_assessment}
accident_evidence = ?                            ; Evidence of accident
evidence_details = ::if accident_evidence = true
panel_gaps = (consistent, inconsistent)          ; Panel gap assessment
frame_pulled = ?                                 ; Frame straightening signs
overspray = ?                                    ; Paint overspray
welding_evidence = ?                             ; Non-factory welds

{@prepurchase_inspection}

; Summary
{.summary}
immediate_concerns[] = :                         ; Immediate repair needs
near_term_concerns[] = :                         ; Near-term (6 mo) needs
long_term_concerns[] = :                         ; Long-term (1 yr+) needs
total_immediate_repairs = #$:(0..)               ; Immediate repair cost
total_near_term_repairs = #$:(0..)               ; Near-term repair cost
recommendation = !(buy_as_is, negotiate, not_recommended, recommended, walk_away)
recommendation_notes = :                         ; Recommendation details

{@prepurchase_inspection}

; Report
{.report}
photos_included = ##:(0..)                       ; Number of photos
photo_urls[] = :                                 ; Photo URLs
report_url = :                                   ; Full report URL
fee = #$:(0..)                                   ; Inspection fee

{@prepurchase_inspection}

; ===================================================================================
; CERTIFIED PRE-OWNED INSPECTION
; ===================================================================================
; Manufacturer certified pre-owned (CPO) inspection checklist.

{@cpo_inspection}
; Required fields first
inspection_id = !:                               ; Inspection identifier
vin = !*:format vin                              ; Vehicle VIN
inspection_date = !date                          ; Inspection date
result = !(fail, pass)                           ; Overall result

; CPO program
{.program}
manufacturer = !:                                ; Vehicle manufacturer
program_name = :                                 ; CPO program name
point_count = ##:(0..)                           ; Inspection point count (e.g., 172-point)

{@cpo_inspection}

; Dealer/inspector
{.dealer}
dealer_name = :                                  ; Certifying dealer
dealer_code = :                                  ; Dealer code
inspector_name = :                               ; Inspector name
inspector_id = :                                 ; Inspector certification

{@cpo_inspection}

; Eligibility requirements
{.eligibility}
age_years_max = ##                               ; Maximum vehicle age
mileage_max = ##                                 ; Maximum mileage
single_owner_required = ?                        ; Single owner required
accident_free_required = ?                       ; Accident-free required
title_brand_free = ?                             ; No title brands
eligible = ?                                     ; Meets eligibility

{@cpo_inspection}

; Reconditioning
{.reconditioning}
items_addressed[] = :                            ; Items addressed
parts_replaced[] = :                             ; Parts replaced
labor_hours = #:(0..)                            ; Labor hours
parts_cost = #$:(0..)                            ; Parts cost
labor_cost = #$:(0..)                            ; Labor cost
total_reconditioning = #$:(0..)                  ; Total reconditioning

{@cpo_inspection}

; Warranty
{.warranty}
warranty_type = (extended, new, remaining)       ; Warranty type
powertrain_months = ##:(0..)                     ; Powertrain months
powertrain_miles = ##:(0..)                      ; Powertrain miles
comprehensive_months = ##:(0..)                  ; Comprehensive months
comprehensive_miles = ##:(0..)                   ; Comprehensive miles
warranty_start_date = date                       ; Warranty start
warranty_deductible = #$:(0..)                   ; Deductible amount

{@cpo_inspection}

; Benefits
{.benefits}
roadside_assistance = ?                          ; Roadside assistance
roadside_months = ##:(0..)                       ; Roadside duration
trip_interruption = ?                            ; Trip interruption coverage
loaner_vehicle = ?                               ; Loaner vehicle program
special_financing = ?                            ; Special financing available
exchange_policy = ?                              ; Exchange policy

{@cpo_inspection}

; Certification
{.certification}
certified = ?:if result = pass                   ; Vehicle certified
certification_date = date:if result = pass       ; Certification date
certificate_number = ::if result = pass          ; Certificate number
expiration = date:if result = pass               ; Certification expiration

{@cpo_inspection}


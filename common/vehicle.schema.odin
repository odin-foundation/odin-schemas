; ===================================================================================
; ODIN Common Vehicle Types
; ===================================================================================
; Universal vehicle type definitions shared across automotive and insurance domains.
; These are the canonical definitions for vehicle-related structures.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.common.vehicle"
version = "1.0.0"
title = "Common Vehicle Types"
description = "Universal vehicle type definitions for automotive and insurance schemas"

{$derivation}
source[0].authority = "National Highway Traffic Safety Administration"
source[0].citation = "49 CFR Part 565 - Vehicle Identification Number (VIN) Requirements"
source[0].url = "https://www.ecfr.gov/current/title-49/subtitle-B/chapter-V/part-565"

source[1].authority = "National Highway Traffic Safety Administration"
source[1].citation = "NHTSA vPIC VIN Decoder API"
source[1].url = "https://vpic.nhtsa.dot.gov/api/"

source[2].authority = "International Organization for Standardization"
source[2].citation = "ISO 3779:2009 - Road vehicles - Vehicle identification number (VIN)"
source[2].url = "https://www.iso.org/standard/52200.html"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Core vehicle identification per NHTSA VIN requirements and ISO 3779"

changelog[0].date = 2025-12-21
changelog[0].change = "Initial common vehicle types schema"
changelog[0].rationale = "Shared vehicle types for automotive and insurance domains"

; ===================================================================================
; VEHICLE IDENTIFICATION
; ===================================================================================
; Core vehicle identification fields used universally across all domains.
; Per NHTSA 49 CFR Part 565 and ISO 3779 VIN standards.

{@vehicle_identification}
; Required fields first
vin = !*:format vin                              ; ISO 3779 VIN (17 alphanumeric, excludes I, O, Q)
year = !##:(1900..2100)                          ; Model year
make = !:                                        ; Manufacturer brand name
model = !:                                       ; Model name

; Optional identification
body_type = :                                    ; Body style description
trim = :                                         ; Trim level
color_exterior = :                               ; Exterior color
color_interior = :                               ; Interior color

; ===================================================================================
; VIN DECODE
; ===================================================================================
; NHTSA vPIC VIN decoder structure. World Manufacturer Identifier (WMI),
; Vehicle Descriptor Section (VDS), and Vehicle Identifier Section (VIS).

{@vin_decode}
; Required fields first
vin = !*:format vin                               ; Full VIN

; World Manufacturer Identifier (positions 1-3)
{.wmi}
manufacturer_id = :(3)                           ; WMI code (positions 1-3)
manufacturer_name = :                            ; Manufacturer name
country = :                                      ; Country of manufacture

{@vin_decode}

; Vehicle Descriptor Section (positions 4-8)
{.vds}
model_line = :                                   ; Model line code
body_class = :                                   ; Body class
engine_type = :                                  ; Engine type code
restraint_system = :                             ; Restraint system type
check_digit = :(1)                               ; Check digit (position 9)

{@vin_decode}

; Vehicle Identifier Section (positions 10-17)
{.vis}
model_year_code = :(1)                           ; Model year code (position 10)
plant_code = :(1)                                ; Assembly plant (position 11)
sequential_number = :(6)                         ; Production sequence (positions 12-17)

{@vin_decode}

; Decoded vehicle information
{.decoded}
year = ##:(1900..2100)                           ; Model year (from position 10)
make = :                                         ; Make/brand
model = :                                        ; Model name
trim = :                                         ; Trim level
body_class = :                                   ; Body type classification
vehicle_type = :                                 ; Vehicle type (Passenger Car, Truck, MPV, etc.)
drive_type = :                                   ; Drive type (AWD, FWD, RWD, 4WD)
fuel_type = :                                    ; Primary fuel type
engine_cylinders = ##                            ; Number of cylinders
engine_displacement_l = #                        ; Engine displacement in liters
engine_horsepower = ##                           ; Engine horsepower
transmission = :                                 ; Transmission type
doors = ##:(0..8)                                ; Number of doors
gvwr_class = :                                   ; GVWR class
plant_city = :                                   ; Assembly plant city
plant_country = :                                ; Assembly plant country
plant_state = :                                  ; Assembly plant state

{@vin_decode}

; NHTSA decode metadata
{.metadata}
decode_source = (nhtsa_vpic, vin_database, manual)
decode_date = timestamp                          ; When VIN was decoded
error_code = :                                   ; Error code if decode failed
error_text = :                                   ; Error message if decode failed

{@vin_decode}

; ===================================================================================
; ENGINE SPECIFICATION
; ===================================================================================
; Internal combustion engine specifications.

{@engine_spec}
; Engine identification
engine_id = :                                    ; Engine code/ID
configuration = (boxer, inline, rotary, v, w)    ; Cylinder configuration
cylinders = ##:(0..)                             ; Number of cylinders
displacement_l = #:(0..)                         ; Displacement in liters
displacement_cc = ##:(0..)                       ; Displacement in cc

; Performance
horsepower = ##:(0..)                            ; Peak horsepower
horsepower_rpm = ##:(0..)                        ; RPM at peak horsepower
torque_lb_ft = ##:(0..)                          ; Peak torque in lb-ft
torque_nm = ##:(0..)                             ; Peak torque in Nm
torque_rpm = ##:(0..)                            ; RPM at peak torque

; Fuel system
fuel_type = (diesel, flex_fuel, gasoline, natural_gas, propane)
fuel_injection = (carbureted, direct, port, tbi)
aspiration = (naturally_aspirated, supercharged, turbocharged, twin_turbo)
compression_ratio = :                            ; Compression ratio

; ===================================================================================
; ELECTRIC VEHICLE SPECIFICATION
; ===================================================================================
; EV and hybrid vehicle specifications.

{@ev_spec}
; Propulsion type
propulsion = !(bev, fcev, hev, mhev, phev)       ; BEV=Battery, HEV=Hybrid, PHEV=Plug-in, FCEV=Fuel Cell, MHEV=Mild

; Battery pack
{.battery}
type = (lfp, lithium_ion, nickel_metal_hydride, solid_state)
capacity_kwh = #:(0..)                           ; Usable capacity in kWh
voltage = ##:(0..)                               ; Nominal voltage
weight_lb = ##:(0..)                             ; Battery weight
warranty_years = ##:(0..)                        ; Battery warranty (years)
warranty_miles = ##:(0..)                        ; Battery warranty (miles)

{@ev_spec}

; Electric motors
{.motors}
count = ##:(1..)                                 ; Number of motors
total_power_kw = ##:(0..)                        ; Combined power in kW
total_power_hp = ##:(0..)                        ; Combined power in HP
total_torque_nm = ##:(0..)                       ; Combined torque in Nm

{@ev_spec}

; Charging
{.charging}
port_type = (ccs, chademo, j1772, nacs)          ; Charging port standard
max_dc_charge_kw = ##:(0..)                      ; Max DC fast charge rate
onboard_charger_kw = #:(0..)                     ; AC charger capacity

{@ev_spec}

; Range
epa_range_miles = ##:(0..)                       ; EPA rated range
city_range_miles = ##:(0..)                      ; City driving range
highway_range_miles = ##:(0..)                   ; Highway driving range
combined_mpge = ##:(0..)                         ; MPGe equivalent

{@ev_spec}

; ===================================================================================
; TRANSMISSION SPECIFICATION
; ===================================================================================
; Transmission specifications.

{@transmission_spec}
type = !(automatic, cvt, dual_clutch, manual)    ; Transmission type
speeds = ##:(1..12)                              ; Number of forward gears
manufacturer = :                                 ; Transmission manufacturer
model = :                                        ; Transmission model/code

; ===================================================================================
; FUEL ECONOMY
; ===================================================================================
; EPA fuel economy ratings per 40 CFR Part 600.

{@fuel_economy}
; EPA ratings
city_mpg = #:(0..200)                            ; EPA city MPG
highway_mpg = #:(0..200)                         ; EPA highway MPG
combined_mpg = #:(0..200)                        ; EPA combined MPG
mpge = ##:(0..200)                               ; MPGe for EVs

; Fuel capacity
tank_capacity_gal = #:(0..200)                   ; Fuel tank capacity (gallons)
tank_capacity_l = #:(0..800)                     ; Fuel tank capacity (liters)

; Annual estimates
annual_fuel_cost = #$:(0..)                      ; EPA estimated annual fuel cost
annual_fuel_consumption_gal = ##:(0..)           ; Estimated annual gallons

; ===================================================================================
; VEHICLE DIMENSIONS
; ===================================================================================
; Physical dimensions and weights.

{@vehicle_dimensions}
; Exterior dimensions (inches)
length_in = #:(0..)                              ; Overall length
width_in = #:(0..)                               ; Overall width
height_in = #:(0..)                              ; Overall height
wheelbase_in = #:(0..)                           ; Wheelbase
ground_clearance_in = #:(0..)                    ; Ground clearance
track_front_in = #:(0..)                         ; Front track width
track_rear_in = #:(0..)                          ; Rear track width

; Interior dimensions (inches)
headroom_front_in = #:(0..)                      ; Front headroom
headroom_rear_in = #:(0..)                       ; Rear headroom
legroom_front_in = #:(0..)                       ; Front legroom
legroom_rear_in = #:(0..)                        ; Rear legroom
shoulder_room_front_in = #:(0..)                 ; Front shoulder room
shoulder_room_rear_in = #:(0..)                  ; Rear shoulder room

; Cargo
cargo_volume_cu_ft = #:(0..)                     ; Cargo volume (cubic feet)
max_cargo_volume_cu_ft = #:(0..)                 ; Max cargo with seats folded
bed_length_in = #:(0..)                          ; Truck bed length

; Weight (pounds)
curb_weight_lb = ##:(0..)                        ; Curb weight
gvwr_lb = ##:(0..)                               ; Gross Vehicle Weight Rating
payload_capacity_lb = ##:(0..)                   ; Maximum payload
towing_capacity_lb = ##:(0..)                    ; Maximum towing capacity

; Passenger capacity
seating_capacity = ##:(1..15)                    ; Number of seats
doors = ##:(0..8)                                ; Number of doors

; ===================================================================================
; ODOMETER READING
; ===================================================================================
; Odometer disclosure per 49 CFR Part 580.

{@odometer_reading}
; Required fields first
reading = !##:(0..)                              ; Odometer reading
reading_date = !date                             ; Date of reading
reading_type = !(actual, discrepancy, exempt, not_actual)

; Source and validation
source = (dealer, dmv, inspection, owner, service)
verified = ?                                     ; Reading verified
verification_method = (electronic, manual, title)

; Discrepancy information
discrepancy_reason = ::if reading_type = discrepancy|not_actual
prior_reading = ##:(0..):if reading_type = discrepancy
rollover_suspected = ?                           ; Rollover suspected

; ===================================================================================
; VEHICLE VALUATION
; ===================================================================================
; Vehicle value and pricing information.

{@vehicle_valuation}
; Pricing
msrp = #$:(0..)                                  ; Manufacturer Suggested Retail Price
invoice_price = #$:(0..)                         ; Dealer invoice price

; Current values
retail_value = #$:(0..)                          ; Retail market value
wholesale_value = #$:(0..)                       ; Wholesale/trade value
trade_in_value = #$:(0..)                        ; Trade-in value
private_party_value = #$:(0..)                   ; Private party sale value

; Insurance values
actual_cash_value = #$:(0..)                     ; ACV for insurance
stated_value = #$:(0..)                          ; Stated/declared value
agreed_value = #$:(0..)                          ; Agreed value (specialty)
replacement_cost = #$:(0..)                      ; Replacement cost

; Valuation metadata - valuations often obtained from multiple sources
{.metadata}
sources[] = {@valuation_source}                  ; Valuation sources (KBB, NADA, Black Book, etc.)
condition = (excellent, fair, good, poor, rough)
mileage_at_valuation = ##:(0..)                  ; Mileage at time of valuation

{@valuation_source}
source = !(black_book, cargurus, edmunds, jd_power, kbb, nada, other)
valuation_date = date                            ; Date of valuation from this source
value = #$:(0..)                                 ; Value from this source

{@vehicle_valuation}

; ===================================================================================
; SAFETY EQUIPMENT
; ===================================================================================
; Vehicle safety features and equipment.

{@safety_equipment}
; Passive safety
airbags_front = ?                                ; Front airbags
airbags_side = ?                                 ; Side airbags
airbags_curtain = ?                              ; Curtain airbags
airbags_knee = ?                                 ; Knee airbags
airbag_count = ##:(0..12)                        ; Total airbag count

; Active safety - braking
antilock_brakes = ?                              ; ABS
electronic_brake_distribution = ?                ; EBD
brake_assist = ?                                 ; Emergency brake assist
automatic_emergency_braking = ?                  ; AEB

; Active safety - stability
traction_control = ?                             ; Traction control
stability_control = ?                            ; Electronic stability control
hill_start_assist = ?                            ; Hill start assist
hill_descent_control = ?                         ; Hill descent control

; Driver assistance
adaptive_cruise_control = ?                      ; ACC
lane_departure_warning = ?                       ; LDW
lane_keeping_assist = ?                          ; LKA
blind_spot_monitoring = ?                        ; BSM
rear_cross_traffic_alert = ?                     ; RCTA
forward_collision_warning = ?                    ; FCW
pedestrian_detection = ?                         ; Pedestrian detection

; Visibility
backup_camera = ?                                ; Rearview camera
surround_view_camera = ?                         ; 360 degree camera
night_vision = ?                                 ; Night vision
auto_high_beams = ?                              ; Automatic high beams
adaptive_headlights = ?                          ; Curve adaptive lighting

; Parking assistance
parking_sensors_front = ?                        ; Front sensors
parking_sensors_rear = ?                         ; Rear sensors
self_parking = ?                                 ; Automated parking

; ===================================================================================
; ANTI-THEFT EQUIPMENT
; ===================================================================================
; Vehicle security and anti-theft features.

{@antitheft_equipment}
; Alarm systems
factory_alarm = ?                                ; Factory alarm system
aftermarket_alarm = ?                            ; Aftermarket alarm
alarm_type = (active, passive)                   ; Active vs passive

; Immobilizers
immobilizer = ?                                  ; Engine immobilizer
transponder_key = ?                              ; Transponder key

; Tracking
gps_tracking = ?                                 ; GPS tracker installed
tracking_service = :                             ; Tracking service name
lojack = ?                                       ; LoJack installed

; Physical deterrents
vin_etching = ?                                  ; VIN etched on windows
steering_wheel_lock = ?                          ; Steering wheel lock
kill_switch = ?                                  ; Hidden kill switch

; ===================================================================================
; LICENSE PLATE
; ===================================================================================
; Vehicle license plate information. USAGE: Use as array `license_plates[] = @license_plate`
; since vehicles commonly have multiple plates (front/rear, dealer/permanent, multi-state).

{@license_plate}
plate_number = !:                                ; License plate number
state_province = !:(2)                           ; Issuing state/province
country = :(2..3) "US"                           ; Issuing country
plate_type = (antique, commercial, disabled, farm, fleet, government, personalized, standard, temporary)
position = (front, rear, single)                 ; Plate position on vehicle
status = (active, expired, replaced, surrendered, temporary)  ; Plate status
issue_date = date                                ; Date plate was issued
expiration_date = date                           ; Plate expiration

; ===================================================================================
; VEHICLE STATUS
; ===================================================================================
; Universal vehicle status enumeration.

{@vehicle_status}
status = !(
    active,                                      ; Active/operational
    damaged,                                     ; Damaged, needs repair
    disposed,                                    ; Disposed/scrapped
    impounded,                                   ; Impounded by authorities
    in_transit,                                  ; Being transported
    sold,                                        ; Sold to new owner
    stolen,                                      ; Reported stolen
    totaled                                      ; Total loss
)
status_date = date                               ; Date of status change
status_reason = :                                ; Reason for status


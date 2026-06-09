; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Auto Vehicle Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Base vehicle fields shared by both personal and commercial auto. Contains only
; fields applicable to all vehicle types; personal and commercial schemas extend
; this with their specific attributes.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../../common/vehicle.schema.odin" as vehicle
@import "../../../common/types.schema.odin" as types
@import "../../../automotive/vehicle.schema.odin" as automotive

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.auto.vehicle"
version = "1.0.0"
title = "Auto Vehicle Schema"
description = "Base vehicle fields shared by personal and commercial auto"

{$derivation}
source[0].authority = "National Highway Traffic Safety Administration"
source[0].citation = "49 CFR Part 565 - Vehicle Identification Number (VIN) Requirements"
source[0].url = "https://www.ecfr.gov/current/title-49/subtitle-B/chapter-V/part-565"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Core vehicle identification and attributes common to all auto insurance"

changelog[0].date = 2025-12-13
changelog[0].change = "Initial vehicle core schema - refactored from monolithic vehicle schema"
changelog[0].rationale = "Clean separation of shared vs personal vs commercial fields"

changelog[1].date = 2025-12-21
changelog[1].change = "Document bridge to common/vehicle.schema.odin and automotive vertical"
changelog[1].rationale = "Shared vehicle types now in common/vehicle.schema.odin for cross-domain reuse"

; ═══════════════════════════════════════════════════════════════════════════════
; Vehicle Core (Shared Fields Only)
; ═══════════════════════════════════════════════════════════════════════════════

{@vehicle}
id = :
number = ##                                   ; Position on policy

; ───────────────────────────────────────────────────────────────────────────────
; Identification
; ───────────────────────────────────────────────────────────────────────────────
vin = *!:/^[A-HJ-NPR-Z0-9]{17}$/               ; ISO 3779 VIN format
year = ##:(1900..2100)
make = :
model = :

body_type = :                                 ; Sedan, Coupe, SUV, etc.
body_type_code = :                            ; Abbreviated body type
trim = :
color = :
license_plate = :
license_plate_state_province = :(2)           ; US state or Canadian province
title_number = :
title_state_province = :(2)                   ; US state or Canadian province

; Serial numbers
chassis_serial = *:
engine_serial = *:
transmission_serial = *:

; ───────────────────────────────────────────────────────────────────────────────
; Technical Specifications
; ───────────────────────────────────────────────────────────────────────────────
{.engine}
cylinders = ##:(0..)                          ; Number of cylinders (ICE vehicles)
displacement = #:(0..)                        ; Engine displacement in liters
horsepower = ##:(0..)                         ; Engine horsepower

{@vehicle}

; ───────────────────────────────────────────────────────────────────────────────
; Electric Vehicle Specifications
; ───────────────────────────────────────────────────────────────────────────────
{.ev}

{.battery}
capacity_kwh = #:(0..)                        ; Battery capacity in kilowatt-hours
range_miles = ##:(0..)                        ; EPA estimated range
type = (lfp, lithium_ion, nickel_metal_hydride, solid_state, other)
health_percent = #:(0..100)                   ; State of health
warranty_months = ##:(0..)                    ; Battery warranty period
warranty_miles = ##:(0..)                     ; Battery warranty mileage

{.charging}
port_type = (ccs, chademo, j1772, nacs, tesla, other)
dc_fast_charge_capable = ?                    ; Can accept DC fast charging
max_charge_rate_kw = ##:(0..)                 ; Maximum DC charge rate
onboard_charger_kw = #:(0..)                  ; AC onboard charger capacity
home_charging_available = ?                   ; Has access to home charging

{.motor}
count = ##:(1..)                              ; Number of electric motors
power_kw = ##:(0..)                           ; Combined motor power
torque_nm = ##:(0..)                          ; Combined motor torque

{@vehicle}
fuel_type = (
    diesel,
    electric,
    flex_fuel,
    gasoline,
    hybrid,
    hydrogen,
    natural_gas,
    other,
    plug_in_hybrid,
    propane
)
transmission = (automatic, cvt, manual, other)
drive_type = (awd, four_wd, fwd, rwd)
doors = ##:(0..8)
seats = ##:(0..99)
curb_weight = ##:(0..80000)

; ───────────────────────────────────────────────────────────────────────────────
; Vehicle Condition & History
; ───────────────────────────────────────────────────────────────────────────────
salvage_title = ?
salvage_title_number = :
existing_damage = ?
existing_damage_description = :
inspection_status = (failed, not_inspected, passed, pending, waived)
inspection_date = date
agent_inspected = ?

; ───────────────────────────────────────────────────────────────────────────────
; Valuation
; ───────────────────────────────────────────────────────────────────────────────
msrp = #$:(0..)
acv = #$:(0..)
stated_value = #$:(0..)
agreed_value = #$:(0..)
cost_new = #$:(0..)

; Purchase information
purchase_date = date
purchase_price = #$:(0..)
purchase_type = (lease, new, used)
odometer = ##
odometer_date = date

; ───────────────────────────────────────────────────────────────────────────────
; Garaging Location - uses shared @address type (US and Canada)
; ───────────────────────────────────────────────────────────────────────────────
{.garaging}
address = @address

{@garaging}
same_as_insured = ?
type = (carport, driveway, garage, other, parking_lot, street, yard)
owned = ?
months_at_location = ##

{@vehicle}

; Rating territory (carrier-assigned)
territory = :
territory_code = :

; ───────────────────────────────────────────────────────────────────────────────
; Usage (Core - applies to both personal and commercial)
; ───────────────────────────────────────────────────────────────────────────────
{.usage}
primary = (
    business,
    commercial,
    commute,
    farm,
    pleasure
)
annual_miles = ##
annual_miles_verified = ?
mileage_source = (eld, estimated, gps, odometer, telematics)
mileage_verification_date = date

{@vehicle}

; ───────────────────────────────────────────────────────────────────────────────
; Ownership
; ───────────────────────────────────────────────────────────────────────────────
{.ownership}
type = (company, financed, leased, owned, rented)

{@vehicle}

; ───────────────────────────────────────────────────────────────────────────────
; Registration
; ───────────────────────────────────────────────────────────────────────────────
{.registration}
registered = ?
state_province = :(2)
expiration = date

{@vehicle}

; ───────────────────────────────────────────────────────────────────────────────
; Lienholders
; ───────────────────────────────────────────────────────────────────────────────
; Embedded array - applies to both personal and commercial

{@vehicle.lienholders[]}
id = :
sequence = ##
type = (lease, loan)
name = :

; Address - uses shared @address type (US and Canada)
address = @address

{@vehicle.lienholders[]}
phones[] = *@phone
account_number = *:

; Deductible requirements
requires_comp = ?
requires_coll = ?
max_comp_ded = ##
max_coll_ded = ##

; ───────────────────────────────────────────────────────────────────────────────
; Safety Equipment
; ───────────────────────────────────────────────────────────────────────────────
{.equipment}
airbags = (
    all,
    driver_only,
    driver_passenger,
    front_side,
    front_side_curtain,
    none
)
antilock_brakes = (
    all_wheels,
    front_only,
    none,
    rear_only
)

{@vehicle}
{.equipment}
daytime_running_lights = ?
traction_control = ?
stability_control = ?
lane_departure_warning = ?
forward_collision_warning = ?
automatic_emergency_braking = ?
blind_spot_monitoring = ?
backup_camera = ?
adaptive_cruise = ?

{@vehicle}

; ───────────────────────────────────────────────────────────────────────────────
; Anti-Theft Equipment
; ───────────────────────────────────────────────────────────────────────────────
{.anti_theft}
level = (
    active_disable,
    audible_alarm,
    none,
    passive_alarm,
    passive_disable,
    recovery_system
)
vin_etching = ?
kill_switch = ?
steering_lock = ?
tracking_device = ?
tracking_vendor = :

{@vehicle}

; ───────────────────────────────────────────────────────────────────────────────
; Rating Symbols
; ───────────────────────────────────────────────────────────────────────────────
{.rating}
symbol = :
company_symbol = :
company_territory = :
class_code = :
liability_symbol = :
comp_symbol = :
coll_symbol = :
tier = :

{@vehicle}

; ───────────────────────────────────────────────────────────────────────────────
; Driver Assignment
; ───────────────────────────────────────────────────────────────────────────────
primary_operator = ##                         ; Driver number
primary_operator_id = :                 ; Driver ID reference
assigned_drivers[] = ##                       ; All assigned driver numbers

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, deleted, pending, suspended)
added_date = date
deleted_date = date
delete_reason = (gifted, other, repo, sold, totaled, traded)

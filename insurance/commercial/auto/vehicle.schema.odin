; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Commercial Auto Vehicle Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Commercial auto vehicle extending the base vehicle schema with power unit and
; trailer types, DOT/FMCSA compliance fields, fleet assignment, radius/zone
; classification, and commercial ratings.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/auto/vehicle.schema.odin" as core

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.auto.vehicle"
version = "1.0.0"
title = "Commercial Auto Vehicle Schema"
description = "Commercial vehicle definitions extending base auto vehicle"

{$derivation}
source[0].authority = "Federal Motor Carrier Safety Administration"
source[0].citation = "49 CFR Part 390.5 - Definitions (Commercial Motor Vehicle)"
source[0].url = "https://www.ecfr.gov/current/title-49/subtitle-B/chapter-III/subchapter-B/part-390/subpart-A/section-390.5"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "FMCSA vehicle definitions; industry-standard commercial vehicle structures"

changelog[0].date = 2025-12-13
changelog[0].change = "Initial commercial vehicle schema"
changelog[0].rationale = "Commercial vehicle requirements per DOT/FMCSA regulations"

; ═══════════════════════════════════════════════════════════════════════════════
; Commercial Vehicle (Extends Vehicle Core)
; ═══════════════════════════════════════════════════════════════════════════════

{@commercial_vehicle}
= @core.vehicle                               ; Inherit all base vehicle fields

; ───────────────────────────────────────────────────────────────────────────────
; Fleet Assignment
; ───────────────────────────────────────────────────────────────────────────────
{.fleet}
name = :                                ; Fleet name
number = :                                     ; Fleet/unit number

{@commercial_vehicle}
terminal_name = :
terminal_number = ##                           ; Assigned terminal

; ───────────────────────────────────────────────────────────────────────────────
; Commercial Vehicle Classification
; ───────────────────────────────────────────────────────────────────────────────
commercial_type = !(
    bus,                                       ; Passenger bus
    pickup_truck,                              ; Commercial pickup
    power_unit,                                ; Tractor, truck, bus
    straight_truck,                            ; Single unit truck
    tractor_trailer_combo,                     ; Combined unit
    trailer,                                   ; Trailer, semi-trailer
    van,                                       ; Commercial van
    other
)

vehicle_class = (
    class_1,                                   ; 0-6,000 lbs GVWR
    class_2a,                                  ; 6,001-8,500 lbs
    class_2b,                                  ; 8,501-10,000 lbs
    class_3,                                   ; 10,001-14,000 lbs
    class_4,                                   ; 14,001-16,000 lbs
    class_5,                                   ; 16,001-19,500 lbs
    class_6,                                   ; 19,501-26,000 lbs
    class_7,                                   ; 26,001-33,000 lbs
    class_8                                    ; > 33,000 lbs
)

; FMCSA Commercial Motor Vehicle (CMV) classification
cmv = ?                                        ; Is CMV (>10,001 lbs GVWR or hazmat or 16+ passengers)
cmv_reason = (hazmat, passengers, weight):if cmv = true  ; Reason for CMV classification

; ───────────────────────────────────────────────────────────────────────────────
; Weight & Dimensions
; ───────────────────────────────────────────────────────────────────────────────
gvw = ##                                       ; Gross Vehicle Weight (actual)
gvwr = ##                                      ; Gross Vehicle Weight Rating
gcw = ##                                       ; Gross Combination Weight
gcwr = ##                                      ; Gross Combination Weight Rating
unladen_weight = ##                            ; Empty weight
payload_capacity = ##                          ; Max cargo weight

axles = ##:(2..)                               ; Number of axles
length_feet = ##
width_inches = ##
height_inches = ##

; ───────────────────────────────────────────────────────────────────────────────
; Power Unit Specific (Tractors, Trucks)
; ───────────────────────────────────────────────────────────────────────────────
{@power_unit}
= @core.vehicle                               ; Inherit base vehicle fields

; Classification
power_unit_type = (
    box_truck,
    bus,
    dump_truck,
    flatbed,
    garbage_truck,
    mixer,                                     ; Concrete mixer
    straight_truck,                            ; Single unit
    tanker,
    tractor_day_cab,                           ; Day cab tractor
    tractor_sleeper,                           ; Sleeper cab tractor
    other
)

; Cab Type
cab_type = (cabover, conventional, extended)
sleeper = ?
sleeper_size = (double, single, studio):if sleeper = true

; Engine
{.engine}
displacement = ##                              ; Cubic inches
horsepower = ##
make = :
model = :
serial = :

{@power_unit}
; Transmission
{.transmission}
make = :
serial = :
speeds = ##
type = (automated_manual, automatic, manual)

{@power_unit}
; Fifth Wheel (for tractors)
{.fifth_wheel}
position = ##                                  ; Inches from rear axle
type = (fixed, sliding)

{@power_unit}

; Seating (for buses/passenger)
seating_capacity = ##
wheelchair_accessible = ?
wheelchair_positions = ##

; ───────────────────────────────────────────────────────────────────────────────
; Trailer Specific
; ───────────────────────────────────────────────────────────────────────────────
{@trailer}
id = :                                         ; Trailer identifier
number = ##                                    ; Number
year = ##:(1900..2100)                         ; Model year
make = !:                                      ; Manufacturer name
type = !(
    auto_carrier,
    container_chassis,                         ; Intermodal container
    dolly,                                     ; Converter dolly
    dry_van,                                   ; Enclosed box
    dump,
    flatbed,
    hopper,                                    ; Grain hopper
    livestock,
    logging,
    lowboy,                                    ; Low deck heavy haul
    other,
    pole,
    reefer,                                    ; Refrigerated
    step_deck,                                 ; Drop deck flatbed
    tanker_dry_bulk,
    tanker_liquid
)

; Identification
vin = *:/^[A-HJ-NPR-Z0-9]{17}$/                ; Vehicle identification number (confidential)
model = :                                      ; Model name

; Trailer Type

; Dimensions
length_feet = ##
width_inches = ##
height_inches = ##
axles = ##

; Weight
unladen_weight = ##
gvwr = ##
payload_capacity = ##

; Refrigeration Unit (for reefers)
{.reefer}
make = ::if type = reefer
model = ::if type = reefer
serial = ::if type = reefer
year = ##:(1990..2100):if type = reefer

{@trailer}
; Tank (for tankers)
{.tank}
capacity_gallons = ##:if type = tanker_liquid
compartments = ##:(1..):if type = tanker_liquid
material = (aluminum, fiberglass, stainless, steel):if type = tanker_liquid

{@trailer}
; Ownership
{.ownership}
lease_term_months = ##:if ownership.type = leased
lessor = ::if ownership.type = leased
type = (interchange, leased, owned, rented)

{@trailer}

; Fleet Assignment
fleet_number = :
terminal_number = ##:(1..)
assigned_power_unit = :                        ; Assigned tractor

; Status
status = (active, inactive, sold, totaled)

{@commercial_vehicle}
; ───────────────────────────────────────────────────────────────────────────────
; Radius / Zone Classification
; ───────────────────────────────────────────────────────────────────────────────
{.radius}
miles = ##                                     ; Operating radius
type = (intermediate, local, long_distance)
zone_code = :

{@commercial_vehicle}

; Primary Use Zone
near_zone = :
far_zone = :
zone_combination = :

; ───────────────────────────────────────────────────────────────────────────────
; Commercial Usage
; ───────────────────────────────────────────────────────────────────────────────
{.usage}
primary_class = :                              ; Primary class code
secondary_class = :                            ; Secondary class
special_class = :                              ; Special industry class

; Business Use
business_type = (
    farm,
    for_hire,                                  ; For-hire carrier
    government,
    lease,                                     ; Leased with driver
    other,
    owner_operator,                            ; Owner-operator
    private,                                   ; Private carrier
    rental,                                    ; Rental fleet
    utility
)

; Cargo Type
hazmat = ?                                     ; Hauls hazardous materials
oversized = ?                                  ; Hauls oversized loads
primary_commodity = :                          ; Primary commodity hauled
refrigerated = ?                               ; Refrigerated cargo

{@commercial_vehicle}

; ───────────────────────────────────────────────────────────────────────────────
; DOT / FMCSA Compliance
; ───────────────────────────────────────────────────────────────────────────────
{.dot}
inspection_required = ?
inspection_result = (failed, out_of_service, passed)
last_inspection_date = date
out_of_service_date = date
out_of_service_reason = :

{@commercial_vehicle}
; Annual Inspection (per 49 CFR 396.17)
{.annual_inspection}
date = date
decal_number = :
expiration = date
inspector = :

{@commercial_vehicle}
; IRP (International Registration Plan)
{.irp}
account_number = *:
base_state_province = :(2)                     ; US state or Canadian province
cab_card_expiration = date
registered = ?

{@commercial_vehicle}
; IFTA (International Fuel Tax Agreement)
{.ifta}
account_number = *:
license_expiration = date
registered = ?

{@commercial_vehicle}
; UCR (Unified Carrier Registration)
{.ucr}
registered = ?
year = ##:(2020..2100)

{@commercial_vehicle}

; ───────────────────────────────────────────────────────────────────────────────
; Commercial Rating Factors
; ───────────────────────────────────────────────────────────────────────────────
{.rating}
coll_symbol = :
comp_symbol = :
experience_mod = #
fleet_discount_eligible = ?
liability_symbol = :
primary_factor_liability = #
primary_factor_physical_damage = #
secondary_factor = #
special_factor = #
specified_perils_symbol = :

{@commercial_vehicle}
; ───────────────────────────────────────────────────────────────────────────────
; Electronic Monitoring
; ───────────────────────────────────────────────────────────────────────────────
{.eld}
install_date = date                            ; ELD installation date
installed = ?                                  ; Electronic Logging Device installed
serial = :                                     ; ELD serial number
vendor = :                                     ; ELD vendor name

{@commercial_vehicle}
{.gps}
installed = ?                                  ; GPS tracking installed
serial = :                                     ; GPS serial number
vendor = :                                     ; GPS vendor name

{@commercial_vehicle}
{.dash_cam}
installed = ?                                  ; Dash camera installed
type = (dual, forward, multi):if dash_cam.installed = true  ; Camera configuration

{@commercial_vehicle}

; ───────────────────────────────────────────────────────────────────────────────
; Lienholder (inherited but may have commercial-specific)
; ───────────────────────────────────────────────────────────────────────────────
; Uses @vehicle.lienholders from base auto schema

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, inactive, leased_out, sold, totaled)
added_date = date
removed_date = date
removed_reason = :

; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Logistics Carrier Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Carrier profiles for motor, rail, ocean, air, and parcel carriers including
; regulatory compliance, equipment tracking, and safety scores.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.logistics.carrier"
version = "1.0.0"
title = "Logistics Carrier Schema"
description = "Carrier information for motor, rail, ocean, air, and parcel carriers"

{$derivation}
source[0].authority = "FMCSA"
source[0].citation = "49 CFR Part 365 - Rules Governing Applications for Operating Authority"
source[0].url = "https://www.ecfr.gov/current/title-49/subtitle-B/chapter-III/subchapter-B/part-365"

source[1].authority = "FMCSA SAFER Database"
source[1].citation = "Safety and Fitness Electronic Records System"
source[1].url = "https://safer.fmcsa.dot.gov/"

source[2].authority = "FMC"
source[2].citation = "Federal Maritime Commission - Ocean Carrier Licensing"
source[2].url = "https://www.fmc.gov/"

source[3].authority = "IATA"
source[3].citation = "IATA Air Cargo Standards"
source[3].url = "https://www.iata.org/en/programs/cargo/"

source[4].authority = "STB"
source[4].citation = "Surface Transportation Board - Rail Carrier Registration"
source[4].url = "https://www.stb.gov/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial carrier schema"
changelog[0].rationale = "Comprehensive carrier types with regulatory compliance"

; ═══════════════════════════════════════════════════════════════════════════════
; CARRIER BASE
; ═══════════════════════════════════════════════════════════════════════════════

{@carrier_base}
; Required fields first
carrier_id = !:                                      ; Unique carrier identifier
name = !:                                            ; Legal business name
type = (air, motor, ocean, parcel, rail)            ; Carrier type

; Optional fields
dba = :                                              ; Doing business as name
scac = :(4)                                          ; Standard Carrier Alpha Code
iata_code = :(3)                                     ; IATA airline/agent code

; Contact
address = @types.address                             ; Primary business address
phone = *@types.phone                                ; Primary phone
email = *@types.email                                ; Primary email
website = :                                          ; Company website

; Status
status = (active, inactive, out_of_service, suspended)
status_date = date                                   ; Status effective date

; ═══════════════════════════════════════════════════════════════════════════════
; MOTOR CARRIER AUTHORITY
; ═══════════════════════════════════════════════════════════════════════════════

{@motor_carrier_authority}
; Required fields first
dot_number = !:                                      ; USDOT number
mc_number = :                                        ; MC (Motor Carrier) number

; Optional fields
ff_number = :                                        ; FF (Freight Forwarder) number
mx_number = :                                        ; MX (Mexico-domiciled) number
docket_number = :                                    ; ICC/MC docket number

; Authority types
authority_type = (
    broker,
    contract_carrier,
    freight_forwarder,
    intermodal,
    motor_carrier,
    private_carrier
)

; Operating authority
common_authority = ?                                 ; Common carrier authority
contract_authority = ?                               ; Contract carrier authority
broker_authority = ?                                 ; Broker authority

; Operating classification
carrier_operation = (
    interstate,
    intrastate_hazmat,
    intrastate_non_hazmat
)

; Cargo carried
cargo_carried[] = (
    building_materials,
    commodities_dry_bulk,
    construction,
    drive_away,
    farm_supplies,
    fresh_produce,
    garbage,
    general_freight,
    grain_feed,
    household_goods,
    logs_poles,
    meat,
    mobile_homes,
    motor_vehicles,
    oilfield_equipment,
    paper_products,
    passengers,
    refrigerated_food,
    tow_away,
    utility,
    water_well
)

; Dates
authority_granted = date                             ; Authority granted date
authority_revoked = date                             ; Authority revoked date

; ═══════════════════════════════════════════════════════════════════════════════
; MOTOR CARRIER INSURANCE
; ═══════════════════════════════════════════════════════════════════════════════

{@motor_carrier_insurance}
; Required fields first
required_amount = !#$:(0..)                          ; Required insurance amount

; Optional fields
on_file = ?                                          ; Insurance on file with FMCSA
policy_number = :                                    ; Policy number
insurance_carrier = :                                ; Insurance carrier name
effective_date = date                                ; Effective date
expiration_date = date                               ; Expiration date

insurance_type = (
    bipd,                                            ; Bodily injury and property damage
    cargo,                                           ; Cargo insurance
    general_liability,                               ; General liability
    surety_bond                                      ; Surety bond
)

; Coverage amounts
bodily_injury = #$:(0..)                             ; BI coverage amount
property_damage = #$:(0..)                           ; PD coverage amount
cargo_coverage = #$:(0..)                            ; Cargo coverage amount
bond_amount = #$:(0..)                               ; Bond amount

; ═══════════════════════════════════════════════════════════════════════════════
; CSA SAFETY RATING
; ═══════════════════════════════════════════════════════════════════════════════

{@csa_safety}
; Optional fields
safety_rating = (conditional, satisfactory, unrated, unsatisfactory)
rating_date = date                                   ; Rating date

; BASIC scores (Behavior Analysis and Safety Improvement Categories)
{.basics}
unsafe_driving = ##:(0..100)                         ; Unsafe driving percentile
hours_of_service = ##:(0..100)                       ; HOS compliance percentile
driver_fitness = ##:(0..100)                         ; Driver fitness percentile
controlled_substances = ##:(0..100)                  ; Drug/alcohol percentile
vehicle_maintenance = ##:(0..100)                    ; Vehicle maintenance percentile
hazmat_compliance = ##:(0..100)                      ; Hazmat compliance percentile
crash_indicator = ##:(0..100)                        ; Crash indicator percentile

{@csa_safety}

; Inspection history
{.inspections}
total_inspections = ##:(0..)                         ; Total inspections
driver_inspections = ##:(0..)                        ; Driver inspections
vehicle_inspections = ##:(0..)                       ; Vehicle inspections
hazmat_inspections = ##:(0..)                        ; Hazmat inspections
iep_inspections = ##:(0..)                           ; IEP inspections
total_violations = ##:(0..)                          ; Total violations
driver_oos_violations = ##:(0..)                     ; Driver out-of-service violations
vehicle_oos_violations = ##:(0..)                    ; Vehicle out-of-service violations
hazmat_oos_violations = ##:(0..)                     ; Hazmat out-of-service violations

{@csa_safety}

; Crash history
{.crashes}
total_crashes = ##:(0..)                             ; Total crashes
fatal_crashes = ##:(0..)                             ; Fatal crashes
injury_crashes = ##:(0..)                            ; Injury crashes
tow_crashes = ##:(0..)                               ; Tow-away crashes

{@csa_safety}

; ═══════════════════════════════════════════════════════════════════════════════
; MOTOR CARRIER EQUIPMENT
; ═══════════════════════════════════════════════════════════════════════════════

{@motor_carrier_equipment}
; Optional fields
{.fleet}
power_units = ##:(0..)                               ; Tractors and straight trucks
trailers = ##:(0..)                                  ; Trailers owned
drivers = ##:(0..)                                   ; Number of drivers

{@motor_carrier_equipment}

; Equipment types
equipment_types[] = (
    auto_carrier,
    container_chassis,
    dry_van,
    dump_truck,
    flatbed,
    hopper,
    lowboy,
    reefer,
    step_deck,
    tanker,
    van
)

; Capabilities
team_drivers = ?                                     ; Team driver capability
hazmat_capable = ?                                   ; Hazmat certified
temp_controlled = ?                                  ; Temperature controlled
lift_gate = ?                                        ; Lift gate equipped
air_ride = ?                                         ; Air ride suspension
tsa_certified = ?                                    ; TSA certified

; ═══════════════════════════════════════════════════════════════════════════════
; LANE
; ═══════════════════════════════════════════════════════════════════════════════

{@lane}
; Required fields first
origin_city = !:                                     ; Origin city
origin_state = !:(2)                                 ; Origin state/province
destination_city = !:                                ; Destination city
destination_state = !:(2)                            ; Destination state/province

; Optional fields
origin_postal = :                                    ; Origin postal code
destination_postal = :                               ; Destination postal code
distance_miles = ##:(0..)                            ; Lane distance in miles
transit_days = ##:(0..)                              ; Standard transit days

rate = #$                                            ; Rate per mile or flat rate
rate_type = (flat, per_cwt, per_mile, per_pallet)    ; Rate type

service_days[] = (friday, monday, saturday, sunday, thursday, tuesday, wednesday)

; ═══════════════════════════════════════════════════════════════════════════════
; MOTOR CARRIER
; ═══════════════════════════════════════════════════════════════════════════════

{@motor_carrier}
= @carrier_base                                      ; Inherit base carrier fields

; Authority
authority = @motor_carrier_authority                 ; Operating authority

; Insurance
insurance[] = @motor_carrier_insurance               ; Insurance policies

; Safety
safety = @csa_safety                                 ; CSA safety scores

; Equipment
equipment = @motor_carrier_equipment                 ; Fleet and equipment

; Service lanes
lanes[] = @lane                                      ; Service lanes

; ═══════════════════════════════════════════════════════════════════════════════
; RAIL CARRIER
; ═══════════════════════════════════════════════════════════════════════════════

{@rail_carrier}
= @carrier_base                                      ; Inherit base carrier fields

; Rail-specific
stb_id = :                                           ; Surface Transportation Board ID
class = (class_i, class_ii, class_iii)               ; Railroad classification
short_line = ?                                       ; Short line railroad flag

; Services
intermodal_service = ?                               ; Intermodal service offered
unit_train = ?                                       ; Unit train service
carload = ?                                          ; Carload service

; Equipment
railcar_types[] = (
    auto_rack,
    boxcar,
    centerbeam,
    coil_car,
    covered_hopper,
    flatcar,
    gondola,
    intermodal,
    refrigerated,
    tank_car
)

railcars_owned = ##:(0..)                            ; Railcars owned
locomotives = ##:(0..)                               ; Locomotives owned

; Network
route_miles = ##:(0..)                               ; Route miles operated
states_served[] = :(2)                               ; States served

; ═══════════════════════════════════════════════════════════════════════════════
; VESSEL
; ═══════════════════════════════════════════════════════════════════════════════

{@vessel}
; Required fields first
vessel_name = !:                                     ; Vessel name
imo_number = :(7)                                    ; IMO number

; Optional fields
vessel_type = (
    bulk_carrier,
    container_ship,
    general_cargo,
    roro,
    tanker
)

flag = :(2)                                          ; Flag state (country code)
built_year = ##:(1900..2100)                         ; Year built
gross_tonnage = ##:(0..)                             ; Gross tonnage
deadweight_tonnage = ##:(0..)                        ; Deadweight tonnage

; Container capacity
teu_capacity = ##:(0..)                              ; TEU capacity (20-ft equivalent)
feu_capacity = ##:(0..)                              ; FEU capacity (40-ft equivalent)
reefer_capacity = ##:(0..)                           ; Reefer plug capacity

; Dimensions
length_meters = #:(0..)                              ; Length overall
beam_meters = #:(0..)                                ; Beam width
draft_meters = #:(0..)                               ; Draft depth

; Speed
service_speed_knots = #:(0..)                        ; Service speed in knots

; ═══════════════════════════════════════════════════════════════════════════════
; OCEAN SERVICE
; ═══════════════════════════════════════════════════════════════════════════════

{@ocean_service}
; Required fields first
service_name = !:                                    ; Service name/route code

; Optional fields
service_type = (direct, feeder, relay, transshipment)
trade_lane = :                                       ; Trade lane identifier
rotation = :                                         ; Port rotation string

; Ports
origin_port = :                                      ; Origin port code (UNLOCODE)
destination_port = :                                 ; Destination port code
ports_of_call[] = :                                  ; All ports in rotation

; Schedule
frequency = (bi_weekly, daily, monthly, weekly)      ; Service frequency
transit_days = ##:(0..)                              ; Transit time in days
sailing_day = (friday, monday, saturday, sunday, thursday, tuesday, wednesday)

; Cutoff times
cutoff_date = date                                   ; Documentation cutoff
cargo_cutoff = timestamp                             ; Cargo cutoff time
vgm_cutoff = timestamp                               ; VGM cutoff time

; ═══════════════════════════════════════════════════════════════════════════════
; OCEAN CARRIER
; ═══════════════════════════════════════════════════════════════════════════════

{@ocean_carrier}
= @carrier_base                                      ; Inherit base carrier fields

; Ocean-specific
fmc_number = :                                       ; FMC license number
nvocc = ?                                            ; Non-vessel operating common carrier

; Alliance membership
alliance = :                                         ; Alliance name (2M, THE, Ocean, etc.)
vessel_sharing_agreements[] = :                      ; VSA partners

; Fleet
vessels[] = @vessel                                  ; Vessel fleet
total_teu_capacity = ##:(0..)                        ; Total fleet TEU capacity

; Services
services[] = @ocean_service                          ; Service routes

; Container types
container_types[] = (
    dry_20,
    dry_40,
    dry_40_hc,
    dry_45,
    flat_rack_20,
    flat_rack_40,
    open_top_20,
    open_top_40,
    platform_20,
    platform_40,
    reefer_20,
    reefer_40,
    reefer_40_hc,
    tank_20
)

; ═══════════════════════════════════════════════════════════════════════════════
; AIRCRAFT
; ═══════════════════════════════════════════════════════════════════════════════

{@aircraft}
; Required fields first
registration = !:                                    ; Aircraft registration number
aircraft_type = !:                                   ; Aircraft model

; Optional fields
manufacturer = :                                     ; Manufacturer
cargo_capacity_kg = ##:(0..)                         ; Cargo capacity in kg
cargo_capacity_cbm = #:(0..)                         ; Cargo capacity in cubic meters
max_range_km = ##:(0..)                              ; Maximum range in km

freighter = ?                                        ; Dedicated freighter or passenger
uld_positions = ##:(0..)                             ; ULD positions available

; ═══════════════════════════════════════════════════════════════════════════════
; AIR SCHEDULE
; ═══════════════════════════════════════════════════════════════════════════════

{@air_schedule}
; Required fields first
flight_number = !:                                   ; Flight number
origin_airport = !:(3)                               ; Origin airport code (IATA)
destination_airport = !:(3)                          ; Destination airport code

; Optional fields
departure_day = (friday, monday, saturday, sunday, thursday, tuesday, wednesday)
departure_time = time                                ; Departure time (local)
arrival_time = time                                  ; Arrival time (local)
frequency = (daily, multiple_daily, weekly)          ; Flight frequency

aircraft = @aircraft                                 ; Aircraft assigned
capacity_available_kg = ##:(0..)                     ; Available cargo capacity

; Cutoff times
booking_cutoff = timestamp                           ; Booking cutoff
cargo_acceptance = timestamp                         ; Cargo acceptance cutoff

; ═══════════════════════════════════════════════════════════════════════════════
; AIR CARRIER
; ═══════════════════════════════════════════════════════════════════════════════

{@air_carrier}
= @carrier_base                                      ; Inherit base carrier fields

; Air-specific
airline_code = :(2)                                  ; IATA 2-letter code
icao_code = :(3)                                     ; ICAO 3-letter code
prefix = :(3)                                        ; AWB prefix (airline designator)

; Certifications
tsa_certified = ?                                    ; TSA certified
dangerous_goods = ?                                  ; DG certified
live_animals = ?                                     ; Live animal handling
pharma = ?                                           ; Pharma certified (CEIV)

; Fleet
aircraft_fleet[] = @aircraft                         ; Aircraft fleet
total_cargo_capacity_kg = ##:(0..)                   ; Total fleet cargo capacity

; Schedules
schedules[] = @air_schedule                          ; Flight schedules

; ULD types
uld_types[] = (
    AKE,                                             ; LD3 container
    AKN,                                             ; Half pallet
    AMJ,                                             ; M1 container
    AMP,                                             ; M2 container
    AYF,                                             ; 20ft container
    AYK,                                             ; 10ft container
    DQF,                                             ; LD7 container
    DQP,                                             ; LD9 pallet
    PAG,                                             ; Standard pallet
    PMC                                              ; Main deck pallet
)

; ═══════════════════════════════════════════════════════════════════════════════
; PARCEL ZONE
; ═══════════════════════════════════════════════════════════════════════════════

{@parcel_zone}
; Required fields first
origin_postal = !:                                   ; Origin postal code
destination_postal = !:                              ; Destination postal code
zone = !:                                            ; Zone identifier

; Optional fields
transit_days = ##:(0..)                              ; Transit days for zone
ground_service = ?                                   ; Ground service available
air_service = ?                                      ; Air service available

; ═══════════════════════════════════════════════════════════════════════════════
; PARCEL CARRIER
; ═══════════════════════════════════════════════════════════════════════════════

{@parcel_carrier}
= @carrier_base                                      ; Inherit base carrier fields

; Parcel-specific
carrier_category = (integrator, postal, regional)    ; Carrier category

; Services offered
ground = ?                                           ; Ground service
express = ?                                          ; Express service
overnight = ?                                        ; Overnight service
two_day = ?                                          ; Two-day service
international = ?                                    ; International service

; Capabilities
pickup_service = ?                                   ; Pickup service available
drop_off_locations = ##:(0..)                        ; Drop-off location count
tracking = ?                                         ; Real-time tracking
signature_service = ?                                ; Signature required service
insurance_available = ?                              ; Insurance available
cod_service = ?                                      ; COD service

; Weight limits
max_weight_lbs = ##:(0..)                            ; Maximum weight per package
max_length_in = ##:(0..)                             ; Maximum length
max_girth_in = ##:(0..)                              ; Maximum girth

; Coverage
countries_served[] = :(2)                            ; Countries served
states_served[] = :(2)                               ; States/provinces served

; Zones
zones[] = @parcel_zone                               ; Zone matrix

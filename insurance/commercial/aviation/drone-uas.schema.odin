; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Drone/UAS Insurance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Unmanned Aircraft Systems (UAS) hull and liability coverage for drone operators
; conducting commercial, recreational, or government operations. Covers hull
; physical damage, ground/air liability, payload, and FAA Part 107 compliance.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../coverages/coverage.schema.odin" as cov
@import "../../coverages/lines/property.schema.odin" as property
@import "../../coverages/lines/liability.schema.odin" as liability
@import "../business.schema.odin" as entity

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.aviation.drone-uas"
version = "1.0.0"
title = "Drone/UAS Insurance Schema"
description = "Unmanned Aircraft Systems hull and liability coverage for commercial and recreational operators"

{$derivation}
source[0].authority = "Federal Aviation Administration"
source[0].citation = "14 CFR Part 107 - Small Unmanned Aircraft Systems"
source[0].url = "https://www.ecfr.gov/current/title-14/chapter-I/subchapter-F/part-107"

source[1].authority = "Federal Aviation Administration"
source[1].citation = "14 CFR Part 91 - General Operating and Flight Rules"
source[1].url = "https://www.ecfr.gov/current/title-14/chapter-I/subchapter-F/part-91"

source[2].authority = "Federal Aviation Administration"
source[2].citation = "14 CFR Part 89 - Remote Identification of Unmanned Aircraft"
source[2].url = "https://www.ecfr.gov/current/title-14/chapter-I/subchapter-F/part-89"

source[3].authority = "Federal Aviation Administration"
source[3].citation = "14 CFR Part 135 - Commuter and On Demand Operations (Drone Delivery)"
source[3].url = "https://www.ecfr.gov/current/title-14/chapter-I/subchapter-G/part-135"

source[4].authority = "Federal Aviation Administration"
source[4].citation = "FAA Airspace Classifications and UAS Operations"
source[4].url = "https://www.faa.gov/uas/getting_started/where_can_i_fly/airspace_101"

source[5].authority = "Transport Canada"
source[5].citation = "Canadian Aviation Regulations (CARs) Part IX - Remotely Piloted Aircraft Systems"
source[5].url = "https://tc.canada.ca/en/aviation/drone-safety/flying-your-drone-safely-legally"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Drone/UAS insurance based on FAA Part 107/Part 135 regulations, Remote ID requirements, and airspace classifications"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial drone/UAS insurance schema"
changelog[0].rationale = "Commercial drone operations require specialized coverage for hull, payload, and liability exposures"

; ═══════════════════════════════════════════════════════════════════════════════
; Drone (UAS Aircraft)
; ═══════════════════════════════════════════════════════════════════════════════

{@drone}
id = :                                        ; Unique drone identifier
sequence = ##:(1..)                           ; Sequence number for multiple drones

; ───────────────────────────────────────────────────────────────────────────────
; Drone Identification
; ───────────────────────────────────────────────────────────────────────────────
faa_registration_number = :                   ; FAA registration (FA number)
serial_number = :                             ; Manufacturer's serial number
manufacturer = :                              ; Drone manufacturer name
model = :                                     ; Drone model designation
nickname = :                                  ; Operator's name for the drone

; ───────────────────────────────────────────────────────────────────────────────
; Remote ID Compliance (FAA Part 89)
; ───────────────────────────────────────────────────────────────────────────────
{.remote_id}
compliant = ?                                 ; Remote ID equipped
compliance_method = (broadcast_module, fria_only, standard):if compliant = true
remote_id_serial = ::if compliance_method = standard
broadcast_module_serial = ::if compliance_method = broadcast_module

{@drone}

; ───────────────────────────────────────────────────────────────────────────────
; Weight Classification (FAA Part 107 limits)
; ───────────────────────────────────────────────────────────────────────────────
weight_class = (
    large,                                    ; Over 55 lbs
    micro,                                    ; Under 0.55 lbs
    small                                     ; 0.55 to 55 lbs
)
takeoff_weight_lbs = #:(0..1320)              ; Weight at takeoff including payload
empty_weight_lbs = #:(0..1320)
max_payload_capacity_lbs = #:(0..500)

; ───────────────────────────────────────────────────────────────────────────────
; Drone Type
; ───────────────────────────────────────────────────────────────────────────────
airframe_type = (
    blimp,                                    ; Lighter-than-air
    fixed_wing,                               ; Airplane-style
    helicopter,                               ; Single rotor
    hybrid_vtol,                              ; Vertical takeoff with fixed wing cruise
    multirotor                                ; Quadcopter, hexacopter, octocopter
)

rotor_count = ##:if airframe_type = multirotor ; Number of rotors for multirotor drones
wingspan_inches = ##:if airframe_type = fixed_wing ; Wingspan for fixed wing aircraft
wingspan_inches = ##:if airframe_type = hybrid_vtol ; Wingspan for hybrid VTOL aircraft

; ───────────────────────────────────────────────────────────────────────────────
; Propulsion
; ───────────────────────────────────────────────────────────────────────────────
{.propulsion}
type = (electric, gas, hybrid)                ; Propulsion system type
motor_count = ##:                             ; Number of motors
battery_type = ::if propulsion.type = electric ; Battery chemistry type
battery_capacity_mah = ##:if propulsion.type = electric ; Battery capacity in milliamp hours
flight_time_minutes = ##:                     ; Maximum flight time per charge/tank

{@drone}

; ───────────────────────────────────────────────────────────────────────────────
; Performance Specifications
; ───────────────────────────────────────────────────────────────────────────────
{.performance}
max_speed_mph = ##:(0..200)                   ; Maximum speed
max_altitude_feet = ##:(0..60000)             ; Maximum altitude
max_range_miles = #:(0..500)                  ; Maximum range
wind_resistance_mph = ##:(0..50)              ; Wind resistance rating
ip_rating = :                                 ; Ingress protection rating
operating_temp_min_f = ##:(-40..120)          ; Minimum operating temperature
operating_temp_max_f = ##:(-40..150)          ; Maximum operating temperature

{@drone}

; ───────────────────────────────────────────────────────────────────────────────
; Avionics and Sensors
; ───────────────────────────────────────────────────────────────────────────────
{.avionics}
gps = ?                                       ; GPS positioning system
glonass = ?                                   ; Russian GLONASS navigation system
galileo = ?                                   ; European Galileo navigation system
rtk_capable = ?                               ; Real-time kinematic for precision
compass = ?                                   ; Magnetic compass
altimeter = ?                                 ; Altitude measurement system
imu = ?                                       ; Inertial measurement unit
obstacle_avoidance = ?                        ; Obstacle detection and avoidance system
collision_avoidance = ?                       ; Collision avoidance system
terrain_following = ?                         ; Terrain following capability
return_to_home = ?                            ; Automatic return to home function
geofencing = ?                                ; Geofencing capability
ads_b_receiver = ?                            ; ADS-B In for traffic awareness

{@drone}

; ───────────────────────────────────────────────────────────────────────────────
; Autonomy Level
; ───────────────────────────────────────────────────────────────────────────────
autonomy_level = (
    assisted,                                 ; GPS hold, altitude hold
    autonomous,                               ; Full autonomous operation
    manual,                                   ; Full pilot control
    semi_autonomous                           ; Waypoint navigation
)

; ───────────────────────────────────────────────────────────────────────────────
; Year and Condition
; ───────────────────────────────────────────────────────────────────────────────
year_manufactured = ##:(2010..2100)           ; Year the drone was manufactured
condition = (excellent, fair, good, new, poor, refurbished) ; Current condition of the drone
total_flight_hours = ##                       ; Total accumulated flight hours
total_flight_cycles = ##                      ; Number of flights

; ───────────────────────────────────────────────────────────────────────────────
; Valuation
; ───────────────────────────────────────────────────────────────────────────────
{.valuation}
agreed_value = #$:(0..)                       ; Pre-agreed value for insurance purposes
hull_value = #$:(0..)                         ; Value of the drone hull/airframe
accessories_value = #$:(0..)                  ; Controllers, batteries, cases
total_insured_value = #$:(0..)                ; Total insured value of drone and accessories

{@drone}

; ───────────────────────────────────────────────────────────────────────────────
; Storage Location
; ───────────────────────────────────────────────────────────────────────────────
{.storage}
location_type = (commercial_facility, home, vehicle, warehouse) ; Type of storage location
address = @address                            ; Storage location address
secured = ?                                   ; Locked/alarmed facility

{@drone}

; ───────────────────────────────────────────────────────────────────────────────
; Lienholders
; ───────────────────────────────────────────────────────────────────────────────
{@drone.lienholders[]}
id = :                                        ; Unique lienholder identifier
sequence = ##:(1..)                           ; Sequence number for multiple lienholders
lienholder = @entity.business                 ; Reference to lienholder business entity
account_number = *:                           ; Confidential account number with lienholder

{@drone}

; ═══════════════════════════════════════════════════════════════════════════════
; Drone Payload
; ═══════════════════════════════════════════════════════════════════════════════

{@drone_payload}
id = :                                        ; Unique payload identifier
drone_ref = :                                 ; Reference to @drone.id
sequence = ##:(1..)                           ; Sequence number for multiple payloads

; ───────────────────────────────────────────────────────────────────────────────
; Payload Type
; ───────────────────────────────────────────────────────────────────────────────
payload_type = (
    camera_infrared,                          ; IR camera
    camera_multispectral,                     ; Agriculture/environmental
    camera_rgb,                               ; Standard visible light camera
    camera_thermal,                           ; Thermal imaging
    cargo_container,                          ; Delivery payload
    cinema_camera,                            ; Professional film camera
    gas_sensor,                               ; Environmental monitoring
    lidar,                                    ; Light detection and ranging
    magnetometer,                             ; Magnetic surveys
    other,
    radar,                                    ; Ground penetrating radar
    speaker,                                  ; Public address
    spotlight,                                ; Search/illumination
    spreader,                                 ; Seed/fertilizer spreader
    sprayer,                                  ; Agricultural sprayer
    winch                                     ; Winch/tether system
)

; ───────────────────────────────────────────────────────────────────────────────
; Payload Details
; ───────────────────────────────────────────────────────────────────────────────
manufacturer = :                              ; Payload manufacturer
model = :                                     ; Payload model designation
serial_number = :                             ; Payload serial number
weight_lbs = #:(0..100)                       ; Payload weight in pounds

; Camera-specific
resolution_megapixels = ##:if payload_type = camera_rgb ; Camera resolution in megapixels
resolution_megapixels = ##:if payload_type = cinema_camera ; Cinema camera resolution in megapixels
sensor_size = ::if payload_type = camera_rgb  ; Camera sensor size
sensor_size = ::if payload_type = cinema_camera ; Cinema camera sensor size
video_resolution = ::if payload_type = camera_rgb ; Video recording resolution
video_resolution = ::if payload_type = cinema_camera ; Cinema video recording resolution

; LiDAR-specific
points_per_second = ##:if payload_type = lidar ; LiDAR point measurement rate
range_meters = ##:if payload_type = lidar     ; LiDAR maximum range in meters

; Sprayer-specific
tank_capacity_gallons = #:if payload_type = sprayer ; Spray tank capacity in gallons
spray_width_feet = #:if payload_type = sprayer ; Spray pattern width in feet

; Cargo-specific
cargo_capacity_lbs = #:if payload_type = cargo_container ; Maximum cargo weight capacity in pounds

; ───────────────────────────────────────────────────────────────────────────────
; Valuation
; ───────────────────────────────────────────────────────────────────────────────
{.valuation}
agreed_value = #$:(0..)                       ; Pre-agreed value for insurance purposes
replacement_cost = #$:(0..)                   ; Cost to replace with new equivalent
actual_cash_value = #$:(0..)                  ; Depreciated current value

{@drone_payload}

year_acquired = ##:(2010..2100)               ; Year the payload was acquired
condition = (excellent, fair, good, new, poor, refurbished) ; Current condition of the payload

; ═══════════════════════════════════════════════════════════════════════════════
; Drone Operator (Remote Pilot)
; ═══════════════════════════════════════════════════════════════════════════════

{@drone_operator}
id = :                                        ; Unique operator identifier

; ───────────────────────────────────────────────────────────────────────────────
; Identity
; ───────────────────────────────────────────────────────────────────────────────
{.name}
first = !:                                    ; Operator first name (required)
middle = :                                    ; Operator middle name
last = !:                                     ; Operator last name (required)

{@drone_operator}

date_of_birth = *date                         ; Operator date of birth (confidential)

; ───────────────────────────────────────────────────────────────────────────────
; FAA Remote Pilot Certificate (Part 107)
; ───────────────────────────────────────────────────────────────────────────────
{.part_107}
certified = ?                                 ; Holds FAA Part 107 remote pilot certificate
certificate_number = ::if part_107.certified = true ; Part 107 certificate number
date_issued = date:if part_107.certified = true ; Certificate issue date
expiration_date = date:if part_107.certified = true ; Certificate expiration date
last_recurrent = date:if part_107.certified = true ; Must complete recurrent training every 24 months

{@drone_operator}

; ───────────────────────────────────────────────────────────────────────────────
; Traditional Pilot Certificate (if applicable)
; ───────────────────────────────────────────────────────────────────────────────
{.pilot_certificate}
holds_certificate = ?                         ; Holds traditional manned aircraft pilot certificate
type = (
    airline_transport,                        ; Airline Transport Pilot
    commercial,                               ; Commercial Pilot
    private,                                  ; Private Pilot
    recreational,                             ; Recreational Pilot
    sport,                                    ; Sport Pilot
    student                                   ; Student Pilot
):if pilot_certificate.holds_certificate = true ; Type of pilot certificate
certificate_number = ::if pilot_certificate.holds_certificate = true ; Pilot certificate number
current_flight_review = ?:if pilot_certificate.holds_certificate = true ; Flight review is current

{@drone_operator}

; ───────────────────────────────────────────────────────────────────────────────
; Additional Certifications/Waivers
; ───────────────────────────────────────────────────────────────────────────────
{.waivers}
night_operations = ?                          ; Night waiver or anti-collision lighting
over_people = ?                               ; Operations over people authorization
bvlos = ?                                     ; Beyond Visual Line of Sight waiver
part_135 = ?                                  ; Air carrier certification (delivery)
other_waivers[] = :                           ; Other FAA waivers granted

{@drone_operator}

; ───────────────────────────────────────────────────────────────────────────────
; Experience
; ───────────────────────────────────────────────────────────────────────────────
{.experience}
total_flight_hours = ##                       ; Total drone flight hours
total_flights = ##                            ; Total number of drone flights
years_flying = ##                             ; Years of drone flying experience
make_model_hours[] = :                        ; Experience on specific models

; Experience by operation type
commercial_hours = ##                         ; Commercial operation hours
inspection_hours = ##                         ; Inspection operation hours
mapping_hours = ##                            ; Mapping/surveying hours
photography_hours = ##                        ; Aerial photography hours
agriculture_hours = ##                        ; Agricultural operation hours
delivery_hours = ##                           ; Delivery operation hours
fpv_hours = ##                                ; First Person View experience

{@drone_operator}

; ───────────────────────────────────────────────────────────────────────────────
; Training
; ───────────────────────────────────────────────────────────────────────────────
{.training}
manufacturer_training = ?                     ; Completed manufacturer training
simulator_training = ?                        ; Completed simulator training
last_training_date = date                     ; Date of most recent training
training_provider = :                         ; Name of training provider
continuing_education = ?                      ; Participates in continuing education

{@drone_operator}

; ───────────────────────────────────────────────────────────────────────────────
; History
; ───────────────────────────────────────────────────────────────────────────────
{.history}
accidents = ##                                ; Number of accidents
incidents = ##                                ; Number of incidents
violations = ##                               ; Number of violations
faa_enforcement_actions = ?                   ; Subject to FAA enforcement actions
certificate_revoked = ?                       ; Certificate previously revoked
claims_history = ?                            ; Has insurance claims history
prior_coverage_cancelled = ?                  ; Prior coverage cancelled or non-renewed

{@drone_operator}

; ═══════════════════════════════════════════════════════════════════════════════
; Drone Operations
; ═══════════════════════════════════════════════════════════════════════════════

{@drone_operations}
id = :                                        ; Unique operations identifier

; ───────────────────────────────────────────────────────────────────────────────
; Primary Use
; ───────────────────────────────────────────────────────────────────────────────
primary_use = (
    aerial_photography,                       ; Photo/video for real estate, events
    aerial_survey,                            ; Land surveying, mapping
    agriculture,                              ; Crop monitoring, spraying
    cinematography,                           ; Film and television production
    construction,                             ; Progress monitoring, site survey
    delivery,                                 ; Package/cargo delivery
    emergency_response,                       ; Search and rescue, disaster
    energy_inspection,                        ; Power lines, wind turbines, solar
    environmental,                            ; Wildlife monitoring, pollution
    government,                               ; Law enforcement, military
    infrastructure_inspection,                ; Bridges, buildings, cell towers
    insurance_claims,                         ; Claims adjustment, inspections
    journalism,                               ; News gathering
    mining,                                   ; Stockpile measurement, survey
    public_safety,                            ; Fire, police, EMS support
    racing,                                   ; FPV drone racing
    real_estate,                              ; Property photography
    recreational,                             ; Hobby flying
    research,                                 ; Scientific research
    telecommunications,                       ; Cell tower inspection
    training,                                 ; Pilot training/instruction
    other
)

secondary_uses[] = (
    aerial_photography,
    aerial_survey,
    agriculture,
    cinematography,
    construction,
    delivery,
    emergency_response,
    energy_inspection,
    environmental,
    government,
    infrastructure_inspection,
    insurance_claims,
    journalism,
    mining,
    public_safety,
    racing,
    real_estate,
    recreational,
    research,
    telecommunications,
    training,
    other
)

; ───────────────────────────────────────────────────────────────────────────────
; Operation Type
; ───────────────────────────────────────────────────────────────────────────────
operation_type = (
    commercial,                               ; For hire operations
    government,                               ; Public agency operations
    recreational                              ; Hobby/personal use
)

; ───────────────────────────────────────────────────────────────────────────────
; FAA Operating Rules
; ───────────────────────────────────────────────────────────────────────────────
{.faa_rules}
part_107 = ?                                  ; Commercial operations certification
part_91 = ?                                   ; General operating rules certification
part_135 = ?                                  ; Air carrier certification
recreational_safety_test = ?                  ; Recreational safety certification

{@drone_operations}

; ───────────────────────────────────────────────────────────────────────────────
; Operational Parameters
; ───────────────────────────────────────────────────────────────────────────────
{.parameters}
vlos_only = ?                                 ; Visual line of sight only
bvlos_approved = ?                            ; Beyond visual line of sight approved
max_altitude_agl_feet = ##:(0..400)           ; Maximum altitude above ground level
night_operations = ?                          ; Night operations authorized
twilight_operations = ?                       ; Twilight operations authorized
over_people = ?                               ; Operations over people authorized
over_moving_vehicles = ?                      ; Operations over moving vehicles authorized
fpv_operations = ?                            ; First person view operations authorized

{@drone_operations}

; ───────────────────────────────────────────────────────────────────────────────
; Flight Frequency
; ───────────────────────────────────────────────────────────────────────────────
flights_per_month = ##:                       ; Average flights per month
hours_per_month = ##:(0..500)                 ; Average flight hours per month
annual_flights_estimated = ##                 ; Estimated total flights per year
annual_hours_estimated = ##                   ; Estimated total flight hours per year

; ═══════════════════════════════════════════════════════════════════════════════
; Approved Airspace
; ═══════════════════════════════════════════════════════════════════════════════

{@approved_airspace}
id = :                                        ; Unique approved airspace identifier

; ───────────────────────────────────────────────────────────────────────────────
; Geographic Territory
; ───────────────────────────────────────────────────────────────────────────────
territory = (
    canada,                                   ; Canada only
    continental_us,                           ; Continental United States only
    north_america,                            ; All of North America
    us_territories,                           ; US territories
    worldwide                                 ; Worldwide coverage
)                                             ; Geographic territory covered
states[] = :(2)                               ; Specific states covered
excluded_states[] = :(2)                      ; States excluded
excluded_countries[] = :(2..3)                ; Countries excluded from coverage

; ───────────────────────────────────────────────────────────────────────────────
; Airspace Classes (FAA)
; ───────────────────────────────────────────────────────────────────────────────
; Class A: 18,000-60,000 ft MSL (no drone operations)
; Class B: Major airports, surface to 10,000 ft (requires LAANC authorization)
; Class C: Medium airports, surface to 4,000 ft (requires LAANC authorization)
; Class D: Smaller airports, surface to 2,500 ft (requires LAANC authorization)
; Class E: Controlled airspace, various altitudes (may require authorization)
; Class G: Uncontrolled, surface to 1,200 ft AGL (no authorization required)
; ───────────────────────────────────────────────────────────────────────────────
{.airspace_authorization}
class_g_authorized = ?                        ; Uncontrolled airspace (default allowed)
class_e_authorized = ?                        ; Controlled airspace (requires LAANC/DroneZone)
class_d_authorized = ?                        ; Small airport airspace
class_c_authorized = ?                        ; Medium airport airspace
class_b_authorized = ?                        ; Major airport airspace
laanc_authorization = ?                       ; Low Altitude Authorization and Notification
drone_zone_authorization = ?                  ; FAA DroneZone approval

{@approved_airspace}

; ───────────────────────────────────────────────────────────────────────────────
; Restricted Areas
; ───────────────────────────────────────────────────────────────────────────────
{.restrictions}
tfr_monitoring = ?                            ; Temporary Flight Restrictions monitoring
notam_monitoring = ?                          ; NOTAMs monitoring
national_parks_excluded = ?                   ; National parks prohibited
stadiums_excluded = ?                         ; Stadiums/events prohibited
critical_infrastructure_excluded = ?          ; Power plants, prisons, etc.
military_excluded = ?                         ; Military installations
dc_sfra_excluded = ?                          ; Washington DC Special Flight Rules Area

{@approved_airspace}

; ═══════════════════════════════════════════════════════════════════════════════
; Drone Hull Coverage (Extends Property Coverage)
; ═══════════════════════════════════════════════════════════════════════════════

{@drone_hull_coverage}
= @property_coverage                          ; Inherit property coverage fields

coverage_type_ref = "DRONE_HULL"              ; Coverage type identifier
drone_ref = :                                 ; Reference to @drone.id

; ───────────────────────────────────────────────────────────────────────────────
; Hull Coverage Form
; ───────────────────────────────────────────────────────────────────────────────
hull_form = (
    all_risk_ground_and_flight,               ; Most comprehensive
    all_risk_not_in_motion,                   ; Excludes flight damage
    named_perils,                             ; Specified perils only
    total_loss_only                           ; Only for complete loss
)                                             ; Type of hull coverage form

; ───────────────────────────────────────────────────────────────────────────────
; Covered Perils
; ───────────────────────────────────────────────────────────────────────────────
{.covered_perils}
crash = ?                                     ; Crash damage covered
collision = ?                                 ; Collision damage covered
hard_landing = ?                              ; Hard landing damage covered
flyaway = ?                                   ; Loss of signal, uncontrolled flight
water_damage = ?                              ; Water damage covered
fire = ?                                      ; Fire damage covered
theft = ?                                     ; Theft covered
vandalism = ?                                 ; Vandalism damage covered
lightning = ?                                 ; Lightning strike damage covered
wind_damage = ?                               ; Wind damage covered
bird_strike = ?                               ; Bird strike damage covered
power_failure = ?                             ; Power failure damage covered
signal_interference = ?                       ; Signal interference damage covered

{@drone_hull_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Deductibles
; ───────────────────────────────────────────────────────────────────────────────
{.hull_deductibles}
ground = #$:(0..)                             ; Damage while not in flight
in_flight = #$:(0..)                          ; Damage during flight
percentage_deductible = ?                     ; Deductible is percentage-based
percentage_amount = ##:(0..25):if percentage_deductible = true ; Percentage deductible amount

{@drone_hull_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Valuation Method
; ───────────────────────────────────────────────────────────────────────────────
valuation_method = (
    actual_cash_value,                        ; Depreciated value
    agreed_value,                             ; Pre-agreed amount
    replacement_cost                          ; New equivalent
)                                             ; Method for valuing losses

agreed_value_amount = #$:(0..):if valuation_method = agreed_value ; Pre-agreed value amount

; ───────────────────────────────────────────────────────────────────────────────
; Component Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.components}
spare_batteries = ?                           ; Spare batteries covered
spare_batteries_limit = #$:(0..):if spare_batteries = true ; Coverage limit for spare batteries
spare_propellers = ?                          ; Spare propellers covered
controllers = ?                               ; Controllers covered
controllers_limit = #$:(0..):if controllers = true ; Coverage limit for controllers
accessories = ?                               ; Accessories covered
accessories_limit = #$:(0..):if accessories = true ; Coverage limit for accessories

{@drone_hull_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Drone Payload Coverage (Extends Property Coverage)
; ═══════════════════════════════════════════════════════════════════════════════

{@drone_payload_coverage}
= @property_coverage                          ; Inherit property coverage fields

coverage_type_ref = "DRONE_PAYLOAD"           ; Coverage type identifier
payload_ref = :                               ; Reference to @drone_payload.id

; ───────────────────────────────────────────────────────────────────────────────
; Payload Coverage Form
; ───────────────────────────────────────────────────────────────────────────────
payload_form = (
    all_risk,                                 ; All covered perils
    named_perils,                             ; Specified perils only
    scheduled                                 ; Specifically listed equipment
)                                             ; Type of payload coverage form

; ───────────────────────────────────────────────────────────────────────────────
; Valuation
; ───────────────────────────────────────────────────────────────────────────────
valuation_method = (
    actual_cash_value,                        ; Depreciated value
    agreed_value,                             ; Pre-agreed amount
    replacement_cost                          ; New equivalent
)                                             ; Method for valuing payload losses

agreed_value_amount = #$:(0..):if valuation_method = agreed_value ; Pre-agreed value amount
replacement_cost_limit = #$:(0..):if valuation_method = replacement_cost ; Maximum replacement cost

; ───────────────────────────────────────────────────────────────────────────────
; Deductibles
; ───────────────────────────────────────────────────────────────────────────────
{.deductibles}
per_item = #$:(0..)                           ; Deductible per payload item
per_occurrence = #$:(0..)                     ; Deductible per occurrence

{@drone_payload_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Drone Liability Coverage (Extends Liability Coverage)
; ═══════════════════════════════════════════════════════════════════════════════

{@drone_liability_coverage}
= @liability_coverage                         ; Inherit liability coverage fields

coverage_type_ref = "DRONE_LIABILITY"         ; Coverage type identifier
drone_ref = :                                 ; Reference to @drone.id

; ───────────────────────────────────────────────────────────────────────────────
; Liability Structure
; ───────────────────────────────────────────────────────────────────────────────
liability_form = (
    combined_single_limit,                    ; Single limit for all liability
    split_limits                              ; Separate limits by type
)                                             ; Liability limit structure

; Combined Single Limit
csl_limit = #$:(0..):if liability_form = combined_single_limit ; Combined single limit amount
aggregate_limit = #$:(0..)                    ; Annual aggregate limit

; Split Limits
{.split_limits}
bodily_injury_per_person = #$:(0..):if liability_form = split_limits ; Bodily injury limit per person
bodily_injury_per_occurrence = #$:(0..):if liability_form = split_limits ; Bodily injury limit per occurrence
property_damage = #$:(0..):if liability_form = split_limits ; Property damage limit

{@drone_liability_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Ground Liability
; ───────────────────────────────────────────────────────────────────────────────
{.ground_liability}
included = ?                                  ; Ground liability coverage included
bodily_injury = ?                             ; Injury to people on ground
property_damage = ?                           ; Damage to property on ground
limit = #$:(0..):if ground_liability.included = true ; Ground liability coverage limit

{@drone_liability_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Air Liability
; ───────────────────────────────────────────────────────────────────────────────
{.air_liability}
included = ?                                  ; Air liability coverage included
other_aircraft = ?                            ; Collision with other aircraft
limit = #$:(0..):if air_liability.included = true ; Air liability coverage limit

{@drone_liability_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Personal and Advertising Injury
; ───────────────────────────────────────────────────────────────────────────────
{.personal_advertising_injury}
included = ?                                  ; Personal and advertising injury coverage included
invasion_of_privacy = ?                       ; Privacy violations from surveillance
trespass = ?                                  ; Aerial trespass claims
defamation = ?                                ; From captured/published content
limit = #$:(0..):if personal_advertising_injury.included = true ; Personal/advertising injury limit

{@drone_liability_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Medical Payments
; ───────────────────────────────────────────────────────────────────────────────
{.medical_payments}
included = ?                                  ; Medical payments coverage included
per_person = #$:(0..):if medical_payments.included = true ; Medical payments limit per person
per_occurrence = #$:(0..):if medical_payments.included = true ; Medical payments limit per occurrence

{@drone_liability_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Additional Drone Coverages
; ═══════════════════════════════════════════════════════════════════════════════

{@drone_additional_coverage}
id = :                                        ; Unique additional coverage identifier

; ───────────────────────────────────────────────────────────────────────────────
; Non-Owned Drone Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.non_owned}
included = ?                                  ; Non-owned drone coverage included
liability_limit = #$:(0..):if non_owned.included = true ; Liability limit for non-owned drones
physical_damage = ?:if non_owned.included = true ; Physical damage coverage for non-owned drones
physical_damage_limit = #$:(0..):if non_owned.physical_damage = true ; Physical damage limit
rental_reimbursement = ?:if non_owned.included = true ; Rental reimbursement coverage

{@drone_additional_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Search and Recovery
; ───────────────────────────────────────────────────────────────────────────────
{.search_recovery}
included = ?                                  ; Search and recovery coverage included
limit = #$:(0..):if search_recovery.included = true ; Search and recovery expense limit

{@drone_additional_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Data Loss Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.data_loss}
included = ?                                  ; Data loss coverage included
sd_card_recovery = ?:if data_loss.included = true ; SD card data recovery covered
cloud_backup_failure = ?:if data_loss.included = true ; Cloud backup failure covered
limit = #$:(0..):if data_loss.included = true ; Data loss coverage limit

{@drone_additional_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Cyber Liability
; ───────────────────────────────────────────────────────────────────────────────
{.cyber}
included = ?                                  ; Cyber liability coverage included
hijacking = ?:if cyber.included = true        ; Control signal hijacking
data_breach = ?:if cyber.included = true      ; Captured data breach
limit = #$:(0..):if cyber.included = true     ; Cyber liability coverage limit

{@drone_additional_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Business Income
; ───────────────────────────────────────────────────────────────────────────────
{.business_income}
included = ?                                  ; Business income coverage included
daily_limit = #$:(0..):if business_income.included = true ; Daily business income limit
max_days = ##:(0..365):if business_income.included = true ; Maximum days of coverage
waiting_period_hours = ##:(0..168):if business_income.included = true ; Waiting period before coverage begins

{@drone_additional_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Cargo/Payload Liability (Part 135 delivery)
; ───────────────────────────────────────────────────────────────────────────────
{.cargo_liability}
included = ?                                  ; Cargo liability coverage included
per_shipment = #$:(0..):if cargo_liability.included = true ; Liability limit per shipment
aggregate = #$:(0..):if cargo_liability.included = true ; Annual aggregate cargo liability limit

{@drone_additional_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Drone Fleet
; ═══════════════════════════════════════════════════════════════════════════════

{@drone_fleet}
id = :                                        ; Unique fleet identifier

fleet_name = :                                ; Name of the drone fleet
fleet_description = :                         ; Description of fleet operations

; Fleet-level limits
{.fleet_limits}
aggregate_hull_limit = #$:(0..)               ; Total hull coverage limit for entire fleet
aggregate_liability_limit = #$:(0..)          ; Total liability coverage limit for entire fleet
per_drone_max = #$:(0..)                      ; Maximum coverage per individual drone

{@drone_fleet}

; Drones in fleet
drones[] = @drone                             ; Array of drones in the fleet
total_insured_value = #$:(0..)                ; Total insured value of all drones in fleet
total_count = ##                              ; Total number of drones in fleet

; Fleet discounts
{.discounts}
fleet_discount_applied = ?                    ; Fleet discount applied
fleet_discount_percent = ##:(0..50):if fleet_discount_applied = true ; Fleet discount percentage
safety_program_discount = ?                   ; Safety program discount applied
no_claims_discount = ?                        ; No claims discount applied

{@drone_fleet}

; ═══════════════════════════════════════════════════════════════════════════════
; Operator Warranty
; ═══════════════════════════════════════════════════════════════════════════════

{@operator_warranty}
id = :                                        ; Unique operator warranty identifier

; ───────────────────────────────────────────────────────────────────────────────
; Operator Requirements
; ───────────────────────────────────────────────────────────────────────────────
open_operator = ?                             ; Any qualified operator
approved_operators_only = ?:if open_operator = false ; Only approved operators allowed

; Minimum Requirements (for open operator)
{.minimums}
part_107_required = ?:if open_operator = true ; Part 107 certification required
min_total_hours = ##:if open_operator = true  ; Minimum total flight hours required
min_make_model_hours = ##:if open_operator = true ; Minimum hours on specific make/model
min_experience_years = ##:if open_operator = true ; Minimum years of flying experience
training_required = ?:if open_operator = true ; Formal training required
clean_record_required = ?:if open_operator = true ; Clean safety record required

{@operator_warranty}

; ───────────────────────────────────────────────────────────────────────────────
; Operating Restrictions
; ───────────────────────────────────────────────────────────────────────────────
{.restrictions}
vlos_only = ?                                 ; Visual Line of Sight only
daylight_only = ?                             ; No night operations
no_over_people = ?                            ; Cannot fly over non-participants
no_over_vehicles = ?                          ; Cannot fly over moving vehicles
max_altitude_feet = ##:(0..400)               ; Maximum altitude in feet AGL
max_wind_mph = ##:(0..50)                     ; Maximum wind speed for operations
manual_control_only = ?                       ; No autonomous operations
fpv_prohibited = ?                            ; No First Person View

{@operator_warranty}

; ═══════════════════════════════════════════════════════════════════════════════
; Drone Policy
; ═══════════════════════════════════════════════════════════════════════════════

{@drone_policy}
id = :                                        ; Unique policy identifier
number = :                                    ; Policy number

; ───────────────────────────────────────────────────────────────────────────────
; Term
; ───────────────────────────────────────────────────────────────────────────────
effective_date = date                         ; Policy effective date
effective_time = time                         ; Policy effective time
expiration_date = date                        ; Policy expiration date
expiration_time = time                        ; Policy expiration time
:invariant expiration_date > effective_date

; ───────────────────────────────────────────────────────────────────────────────
; Named Insured
; ───────────────────────────────────────────────────────────────────────────────
named_insured = @entity.business              ; Primary named insured
additional_named_insureds[] = @entity.business ; Additional named insureds

; ───────────────────────────────────────────────────────────────────────────────
; Policy Type
; ───────────────────────────────────────────────────────────────────────────────
type = (
    commercial,                               ; Business use
    fleet,                                    ; Multiple drones
    government,                               ; Public agency
    recreational                              ; Personal/hobby
)                                             ; Type of drone policy

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Basis
; ───────────────────────────────────────────────────────────────────────────────
coverage_basis = (
    annual,                                   ; Full year coverage
    monthly,                                  ; Month-to-month
    on_demand,                                ; Per-flight or per-hour
    project                                   ; Specific project duration
)                                             ; Basis for coverage period

; On-demand specifics
per_flight_available = ?:if coverage_basis = on_demand ; Per-flight coverage available
per_hour_available = ?:if coverage_basis = on_demand ; Per-hour coverage available
minimum_flight_hours = ##:if coverage_basis = on_demand ; Minimum flight hours required

; ───────────────────────────────────────────────────────────────────────────────
; Drones / Fleet
; ───────────────────────────────────────────────────────────────────────────────
drones[] = @drone                             ; Drones covered by policy
fleet = @drone_fleet                          ; Fleet covered by policy
payloads[] = @drone_payload                   ; Payloads covered by policy

; ───────────────────────────────────────────────────────────────────────────────
; Operations
; ───────────────────────────────────────────────────────────────────────────────
operations = @drone_operations                ; Operations details
approved_airspace = @approved_airspace        ; Approved airspace for operations

; ───────────────────────────────────────────────────────────────────────────────
; Operators
; ───────────────────────────────────────────────────────────────────────────────
operators[] = @drone_operator                 ; Authorized drone operators
operator_warranty = @operator_warranty        ; Operator warranty requirements

; ───────────────────────────────────────────────────────────────────────────────
; Coverages
; ───────────────────────────────────────────────────────────────────────────────
hull_coverages[] = @drone_hull_coverage       ; Hull coverage details
payload_coverages[] = @drone_payload_coverage ; Payload coverage details
liability_coverages[] = @drone_liability_coverage ; Liability coverage details
additional_coverages[] = @drone_additional_coverage ; Additional coverage details

; ───────────────────────────────────────────────────────────────────────────────
; Exclusions
; ───────────────────────────────────────────────────────────────────────────────
{.exclusions}
war = ?true                                   ; War exclusion (default excluded)
terrorism = ?                                 ; Terrorism exclusion
nuclear = ?true                               ; Nuclear incident exclusion (default excluded)
pollution = ?                                 ; Pollution exclusion
intentional_damage = ?true                    ; Intentional damage exclusion (default excluded)
illegal_operations = ?true                    ; Operations violating FAA regulations
no_remote_id = ?                              ; No coverage without Remote ID compliance
bvlos_without_waiver = ?true                  ; BVLOS without proper authorization
controlled_airspace_unauthorized = ?true      ; Operating in controlled airspace without LAANC
night_without_lighting = ?                    ; Night ops without anti-collision lights
over_people_unauthorized = ?                  ; Over people without proper category
racing = ?                                    ; Drone racing excluded
fpv_without_observer = ?                      ; FPV without visual observer

{@drone_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
annual_premium = #$:(0..)                     ; Annual premium amount
deposit_premium = #$:(0..)                    ; Deposit premium amount
hull_premium = #$:(0..)                       ; Hull coverage premium
liability_premium = #$:(0..)                  ; Liability coverage premium
payload_premium = #$:(0..)                    ; Payload coverage premium
additional_coverage_premium = #$:(0..)        ; Additional coverages premium
taxes_fees = #$:(0..)                         ; Taxes and fees
total_premium = #$:(0..)                      ; Total premium amount

{@drone_policy}

; ═══════════════════════════════════════════════════════════════════════════════
; Drone Claim
; ═══════════════════════════════════════════════════════════════════════════════

{@drone_claim}
id = :                                        ; Unique claim identifier
policy_ref = :                                ; Reference to @drone_policy.id
drone_ref = :                                 ; Reference to @drone.id

; ───────────────────────────────────────────────────────────────────────────────
; Loss Details
; ───────────────────────────────────────────────────────────────────────────────
loss_date = date                              ; Date of loss
loss_time = time                              ; Time of loss
report_date = date                            ; Date loss was reported

loss_type = (
    bird_strike,                              ; Bird strike
    collision_aircraft,                       ; Collision with aircraft
    collision_structure,                      ; Collision with structure
    controller_failure,                       ; Controller malfunction
    crash,                                    ; Crash
    fire,                                     ; Fire damage
    flyaway,                                  ; Flyaway/loss of control
    gps_failure,                              ; GPS system failure
    hard_landing,                             ; Hard landing
    liability_bodily_injury,                  ; Liability for bodily injury
    liability_privacy,                        ; Liability for privacy violation
    liability_property_damage,                ; Liability for property damage
    lightning,                                ; Lightning strike
    power_failure,                            ; Power system failure
    signal_loss,                              ; Signal loss
    software_failure,                         ; Software failure
    theft,                                    ; Theft
    vandalism,                                ; Vandalism
    water_damage,                             ; Water damage
    weather,                                  ; Weather-related damage
    other                                     ; Other loss type
)                                             ; Type of loss

; ───────────────────────────────────────────────────────────────────────────────
; Location
; ───────────────────────────────────────────────────────────────────────────────
{.location}
address = @address                            ; Address of loss location
coordinates_lat = #:(-90..90)                 ; Latitude coordinate of loss
coordinates_lon = #:(-180..180)               ; Longitude coordinate of loss
airspace_class = (a, b, c, d, e, g)           ; FAA airspace class at loss location
altitude_agl_feet = ##:(0..60000)             ; Altitude above ground level in feet

{@drone_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Flight Conditions
; ───────────────────────────────────────────────────────────────────────────────
{.conditions}
time_of_day = (day, night, twilight)          ; Time of day during loss
weather = (clear, cloudy, fog, rain, snow, wind) ; Weather conditions at time of loss
wind_speed_mph = ##:(0..100)                  ; Wind speed in MPH
visibility_miles = #:(0..10)                  ; Visibility in miles
vlos_maintained = ?                           ; Visual Line of Sight maintained
remote_id_active = ?                          ; Remote ID broadcasting

{@drone_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Operator at Time of Loss
; ───────────────────────────────────────────────────────────────────────────────
operator_ref = :                              ; Reference to @drone_operator.id
operator_part_107_current = ?                 ; Operator's Part 107 certification current at loss
operator_flight_hours_at_loss = ##            ; Operator's total flight hours at time of loss

; ───────────────────────────────────────────────────────────────────────────────
; Flight Data
; ───────────────────────────────────────────────────────────────────────────────
{.flight_data}
flight_log_available = ?                      ; Flight log available for investigation
telemetry_available = ?                       ; Telemetry data available
video_available = ?                           ; Video footage available
controller_log_available = ?                  ; Controller log available
total_flight_time_minutes = ##                ; Total flight time of this flight in minutes
distance_from_operator_feet = ##              ; Distance from operator at time of loss

{@drone_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Damages
; ───────────────────────────────────────────────────────────────────────────────
{.damages}
drone_damage_description = :                  ; Description of drone damage
drone_total_loss = ?                          ; Drone is a total loss
drone_recoverable = ?                         ; Drone is recoverable
payload_damaged = ?                           ; Payload was damaged
payload_description = ::if payload_damaged = true ; Description of payload damage
third_party_property_damaged = ?              ; Third party property damaged
third_party_property_description = ::if third_party_property_damaged = true ; Description of third party property damage
third_party_injury = ?                        ; Third party injury occurred
third_party_injury_description = *::if third_party_injury = true ; Description of third party injury (confidential)

{@drone_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Reserves and Payments
; ───────────────────────────────────────────────────────────────────────────────
{.financials}
hull_reserve = #$:(0..)                       ; Hull damage reserve amount
hull_paid = #$:(0..)                          ; Hull damage paid amount
payload_reserve = #$:(0..)                    ; Payload damage reserve amount
payload_paid = #$:(0..)                       ; Payload damage paid amount
liability_reserve = #$:(0..)                  ; Liability reserve amount
liability_paid = #$:(0..)                     ; Liability paid amount
medical_reserve = #$:(0..)                    ; Medical payments reserve amount
medical_paid = #$:(0..)                       ; Medical payments paid amount
total_reserve = #$:(0..)                      ; Total reserves
total_paid = #$:(0..)                         ; Total payments
deductible_applied = #$:(0..)                 ; Deductible amount applied
subrogation_recovery = #$:(0..)               ; Subrogation recovery amount

{@drone_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (
    closed,                                   ; Claim is closed
    denied,                                   ; Claim was denied
    investigation,                            ; Under investigation
    litigation,                               ; In litigation
    open,                                     ; Claim is open
    subrogation                               ; Subrogation in progress
)                                             ; Claim status

denial_reason = ::if status = denied          ; Reason for claim denial
closure_date = date:if status = closed        ; Date claim was closed
description = :                               ; Claim description

; ═══════════════════════════════════════════════════════════════════════════════
; Scheduled Payloads (for scheduling on policy)
; ═══════════════════════════════════════════════════════════════════════════════

{@scheduled_payload}
id = :                                        ; Unique scheduled payload identifier
sequence = ##:(1..)                           ; Sequence number for multiple scheduled payloads
payload = @drone_payload                      ; Reference to payload being scheduled
insured_value = #$:(0..)                      ; Insured value for scheduled payload
coverage = @drone_payload_coverage            ; Coverage details for scheduled payload


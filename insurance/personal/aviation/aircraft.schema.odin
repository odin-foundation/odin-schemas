; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Aircraft Insurance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Personal aircraft insurance covering hull physical damage and aircraft liability
; for private pilots and owners including in-flight, not-in-motion, and taxi
; coverage with pilot warranty requirements.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../coverages/coverage.schema.odin" as cov
@import "../../coverages/lines/property.schema.odin" as property
@import "../../coverages/lines/liability.schema.odin" as liability
@import "../../commercial/business.schema.odin" as entity

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.aviation.aircraft"
version = "1.0.0"
title = "Aircraft Insurance Schema"
description = "Aircraft hull and liability coverage for owners and operators"

{$derivation}
source[0].authority = "Federal Aviation Administration"
source[0].citation = "14 CFR Part 91 - General Operating and Flight Rules"
source[0].url = "https://www.ecfr.gov/current/title-14/chapter-I/subchapter-F/part-91"

source[1].authority = "Federal Aviation Administration"
source[1].citation = "14 CFR Part 135 - Commuter and On Demand Operations"
source[1].url = "https://www.ecfr.gov/current/title-14/chapter-I/subchapter-G/part-135"

source[2].authority = "U.S. Department of Transportation"
source[2].citation = "49 U.S.C. 41112 - Air Carrier Insurance Requirements"
source[2].url = "https://uscode.house.gov/view.xhtml?req=granuleid:USC-prelim-title49-section41112"

source[3].authority = "Transport Canada"
source[3].citation = "Canadian Aviation Regulations (CARs)"
source[3].url = "https://laws-lois.justice.gc.ca/eng/regulations/sor-96-433/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Aircraft insurance based on FAA/Transport Canada regulations and DOT requirements"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial aircraft insurance schema"
changelog[0].rationale = "Standalone aircraft coverage separate from hangarkeepers"

; ═══════════════════════════════════════════════════════════════════════════════
; Aircraft
; ═══════════════════════════════════════════════════════════════════════════════

{@aircraft}
id = :                                            ; Unique aircraft identifier
sequence = ##:                                    ; Sequence number for ordering

; ───────────────────────────────────────────────────────────────────────────────
; Aircraft Identification
; ───────────────────────────────────────────────────────────────────────────────
registration_number = :                           ; FAA registration number (N-number)
registration_country = :(2..3) "US"               ; Country of registration
serial_number = :                                 ; Manufacturer serial number
year_manufactured = ##:(1900..2100)               ; Year aircraft was manufactured
manufacturer = :                                  ; Aircraft manufacturer name
model = :                                         ; Aircraft model designation
model_designation = :                             ; Official model designation

; ───────────────────────────────────────────────────────────────────────────────
; Aircraft Classification
; ───────────────────────────────────────────────────────────────────────────────
aircraft_type = (                                 ; Aircraft type classification
    airplane_multi_engine_land,
    airplane_multi_engine_sea,
    airplane_single_engine_land,
    airplane_single_engine_sea,
    balloon,
    drone_uas,
    glider,
    gyroplane,
    helicopter,
    lighter_than_air,
    powered_lift,
    powered_parachute,
    weight_shift_control
)

aircraft_category = (experimental, large, light_sport, limited, normal, primary, restricted, small, transport, utility) ; FAA airworthiness category

; ───────────────────────────────────────────────────────────────────────────────
; Specifications
; ───────────────────────────────────────────────────────────────────────────────
{.specifications}
seats_total = ##                                  ; Total number of seats
seats_passenger = ##                              ; Number of passenger seats
seats_crew = ##                                   ; Number of crew seats
engines = ##                                      ; Number of engines
engine_type = (electric, hybrid, jet, piston, turboprop, turboshaft) ; Type of engine
engine_manufacturer = :                           ; Engine manufacturer name
engine_model = :                                  ; Engine model designation
horsepower_total = ##                             ; Total horsepower (piston)
thrust_lbs_total = ##                             ; Total thrust in pounds (jet)

; Weights
max_takeoff_weight_lbs = ##                       ; Maximum takeoff weight in pounds
empty_weight_lbs = ##                             ; Empty weight in pounds
useful_load_lbs = ##                              ; Useful load in pounds
fuel_capacity_gallons = ##                        ; Fuel capacity in gallons

; Performance
cruise_speed_ktas = ##                            ; Cruise speed in knots true airspeed
range_nm = ##                                     ; Range in nautical miles
service_ceiling_ft = ##                           ; Service ceiling in feet

{@aircraft}

; ───────────────────────────────────────────────────────────────────────────────
; Ownership
; ───────────────────────────────────────────────────────────────────────────────
{.ownership}
type = (                                          ; Ownership type
    charter,
    corporate,
    flight_school,
    fractional,
    government,
    individual,
    leaseback,
    leased,
    other,
    owned,
    partnership
)
owner = @entity.business                          ; Aircraft owner entity
lessee = @entity.business:if type = leased        ; Lessee if leased
lessee = @entity.business:if type = leaseback     ; Lessee if leaseback
trustee_name = :                                  ; Trustee name if held in trust

{@aircraft}

; ───────────────────────────────────────────────────────────────────────────────
; Use
; ───────────────────────────────────────────────────────────────────────────────
{.use}
purpose = (                                       ; Primary use of aircraft
    aerial_application,                           ; Crop dusting
    aerial_photography,
    aerial_survey,
    air_ambulance,
    air_cargo,
    air_taxi,
    business_pleasure,
    charter,
    commercial,
    corporate,
    flight_instruction,
    government,
    industrial_aid,
    medevac,
    other,
    parachute_operations,
    patrol,
    personal_pleasure,
    rental,
    sales_demo,
    scheduled_airline,
    sightseeing
)
commercial_operations = ?                         ; Used for commercial operations
part_91 = ?                                       ; FAR Part 91
part_135 = ?                                      ; FAR Part 135
part_121 = ?                                      ; FAR Part 121
annual_hours_estimated = ##                       ; Estimated annual flight hours

{@aircraft}

; ───────────────────────────────────────────────────────────────────────────────
; Base Location
; ───────────────────────────────────────────────────────────────────────────────
{.base}
airport_icao = :(4)                               ; ICAO code
airport_name = :                                  ; Airport name
city = :                                          ; City where aircraft is based
state_province = :(2)                             ; State or province code
country = :(2..3) "US"                            ; Country code
hangar_type = (none, private_hangar, shared_hangar, tiedown) ; Type of storage
controlled_airport = ?                            ; Towered

{@aircraft}

; ───────────────────────────────────────────────────────────────────────────────
; Valuation
; ───────────────────────────────────────────────────────────────────────────────
{.valuation}
agreed_value = #$:(0..)                           ; Agreed value for hull coverage
hull_value = #$:(0..)                             ; Hull value excluding avionics
avionics_value = #$:(0..)                         ; Value of avionics equipment
spares_value = #$:(0..)                           ; Value of spare parts
accessories_value = #$:(0..)                      ; Value of accessories
total_insured_value = #$:(0..)                    ; Total insured value

{@aircraft}

; ───────────────────────────────────────────────────────────────────────────────
; Avionics
; ───────────────────────────────────────────────────────────────────────────────
{.avionics}
glass_cockpit = ?                                 ; Has glass cockpit displays
gps = ?                                           ; GPS navigation system installed
autopilot = ?                                     ; Autopilot installed
weather_radar = ?                                 ; Weather radar installed
tcas = ?                                          ; Traffic Collision Avoidance
taws = ?                                          ; Terrain Awareness
ads_b_out = ?                                     ; ADS-B Out equipped
ads_b_in = ?                                      ; ADS-B In equipped

{@aircraft}

; ───────────────────────────────────────────────────────────────────────────────
; Airworthiness
; ───────────────────────────────────────────────────────────────────────────────
{.airworthiness}
certificate_type = (experimental, restricted, special, standard) ; Airworthiness certificate type
certificate_number = :                            ; Certificate number
certificate_date = date                           ; Date certificate was issued
annual_inspection_due = date                      ; Date annual inspection is due
last_annual_date = date                           ; Date of last annual inspection
total_airframe_hours = ##                         ; Total airframe hours
total_engine_hours = ##                           ; Total engine hours
time_since_overhaul = ##                          ; Hours since major overhaul
ad_compliance = ?                                 ; Airworthiness directives compliant

{@aircraft}

; ───────────────────────────────────────────────────────────────────────────────
; Lienholders
; ───────────────────────────────────────────────────────────────────────────────
{@aircraft.lienholders[]}
id = :                                            ; Unique lienholder identifier
sequence = ##:                                    ; Sequence number for ordering
lienholder = @entity.business                     ; Lienholder entity
account_number = *:                               ; Loan or lease account number


{@aircraft}

; ───────────────────────────────────────────────────────────────────────────────
; Pilot Warranty (per aircraft)
; ───────────────────────────────────────────────────────────────────────────────
pilot_warranty = @pilot_warranty                  ; Pilot requirements for this aircraft

; ───────────────────────────────────────────────────────────────────────────────
; Approved Pilots (per aircraft with make/model experience)
; ───────────────────────────────────────────────────────────────────────────────
{@aircraft.approved_pilots[]}
pilot_ref = :                                     ; Reference to @pilot.id
approved_date = date                              ; Date pilot was approved

; Make/Model specific experience for THIS aircraft
make_model_hours = ##                             ; Hours in this make/model
make_model_hours_pic = ##                         ; PIC hours in this make/model
make_model_simulator_hours = ##                   ; Simulator hours in this make/model
make_model_landings = ##                          ; Landings in this make/model
make_model_night_hours = ##                       ; Night hours in this make/model
make_model_instrument_hours = ##                  ; Instrument hours in this make/model

type_rating_required = ?                          ; Type rating required for this aircraft
type_rating_held = ?:if type_rating_required = true ; Pilot holds required type rating
type_rating_designation = ::if type_rating_held = true ; Type rating designation
type_rating_initial_date = date:if type_rating_held = true ; Date type rating was obtained
type_rating_last_recurrent = date:if type_rating_held = true ; Date of last recurrent training
type_rating_recurrent_provider = ::if type_rating_held = true ; Training provider for recurrent

; Approval status
status = (active, expired, probationary, suspended) ; Approval status

{@aircraft}

; ═══════════════════════════════════════════════════════════════════════════════
; Pilot
; ═══════════════════════════════════════════════════════════════════════════════

{@pilot}
id = :                                            ; Unique pilot identifier

; ───────────────────────────────────────────────────────────────────────────────
; Identity
; ───────────────────────────────────────────────────────────────────────────────
{.name}
first = !:                                        ; First name
middle = :                                        ; Middle name
last = !:                                         ; Last name

{@pilot}

date_of_birth = *date                             ; Date of birth (confidential)

; ───────────────────────────────────────────────────────────────────────────────
; Certificate
; ───────────────────────────────────────────────────────────────────────────────
{.certificate}
type = (                                          ; Pilot certificate type
    airline_transport,
    commercial,
    foreign,
    military,
    none,
    private,
    recreational,
    sport,
    student
)
number = :                                        ; Certificate number
date_issued = date                                ; Date certificate was issued
country_issued = :(2..3) "US"                     ; Country that issued certificate

; Ratings
instrument_rating = ?                             ; Instrument rating held
multi_engine_rating = ?                           ; Multi-engine rating held
single_engine_land = ?                            ; Single-engine land rating
single_engine_sea = ?                             ; Single-engine sea rating
multi_engine_land = ?                             ; Multi-engine land rating
multi_engine_sea = ?                              ; Multi-engine sea rating
helicopter_rating = ?                             ; Helicopter rating held
rotorcraft_rating = ?                             ; Rotorcraft rating held
glider_rating = ?                                 ; Glider rating held
type_ratings[] = :                                ; Type ratings held

{@pilot}

; ───────────────────────────────────────────────────────────────────────────────
; Medical
; ───────────────────────────────────────────────────────────────────────────────
{.medical}
class = (basic_med, first, none, second, third)  ; Medical certificate class
date_issued = date                                ; Date medical was issued
expiration_date = date                            ; Medical expiration date
restrictions[] = :                                ; Medical restrictions or limitations
special_issuance = ?                              ; Special issuance medical certificate

{@pilot}

; ───────────────────────────────────────────────────────────────────────────────
; Experience
; ───────────────────────────────────────────────────────────────────────────────
{.experience}
total_hours = ##                                  ; Total flight hours
total_hours_pic = ##                              ; Pilot in Command
retractable_hours = ##                            ; Retractable gear hours
multi_engine_hours = ##                           ; Multi-engine hours
turbine_hours = ##                                ; Turbine engine hours
jet_hours = ##                                    ; Jet aircraft hours
helicopter_hours = ##                             ; Helicopter hours
instrument_hours = ##                             ; Instrument flight hours
instrument_simulator_hours = ##                   ; Instrument simulator hours
night_hours = ##                                  ; Night flight hours
simulator_hours = ##                              ; Total simulator hours
last_12_months = ##                               ; Flight hours in last 12 months
last_90_days = ##                                 ; Flight hours in last 90 days

{@pilot}

; ───────────────────────────────────────────────────────────────────────────────
; Training
; ───────────────────────────────────────────────────────────────────────────────
{.training}
last_flight_review = date                         ; BFR
last_ipc = date                                   ; Instrument Proficiency Check
last_checkride = date                             ; Date of last checkride
recurrent_training = ?                            ; Receives recurrent training
simulator_training = ?                            ; Receives simulator training

{@pilot}

; ───────────────────────────────────────────────────────────────────────────────
; History
; ───────────────────────────────────────────────────────────────────────────────
{.history}
accidents = ##                                    ; Number of accidents
incidents = ##                                    ; Number of incidents
violations = ##                                   ; Number of FAA violations
certificate_actions = ?                           ; Certificate actions or suspensions
dui_dwi = ?                                       ; DUI/DWI history
insurance_cancelled = ?                           ; Insurance previously cancelled
claims_history = ?                                ; Prior insurance claims

{@pilot}

; ═══════════════════════════════════════════════════════════════════════════════
; Aircraft Hull Coverage (Extends Property Coverage)
; ═══════════════════════════════════════════════════════════════════════════════

{@aircraft_hull_coverage}
= @property_coverage                              ; Inherit property coverage fields

coverage_type_ref = "AIRCRAFT_HULL"               ; Coverage type identifier
aircraft_ref = :                                  ; Reference to @aircraft.id

; ───────────────────────────────────────────────────────────────────────────────
; Hull Coverage Form
; ───────────────────────────────────────────────────────────────────────────────
hull_form = (                                     ; Type of hull coverage
    all_risk_ground_and_flight,
    all_risk_not_in_flight,
    all_risk_not_in_motion,
    named_perils,
    total_loss_only
)

; ───────────────────────────────────────────────────────────────────────────────
; Deductibles by Phase
; ───────────────────────────────────────────────────────────────────────────────
{.hull_deductibles}
not_in_motion = #$:(0..)                          ; Deductible when not in motion
in_motion = #$:(0..)                              ; Deductible when in motion on ground
in_flight = #$:(0..)                              ; Deductible during flight
percentage_deductible = ?                         ; Use percentage deductible
percentage_amount = ##:(0..100):if percentage_deductible = true ; Percentage of hull value

{@aircraft_hull_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Component Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.components}
spares_covered = ?                                ; Spare parts coverage included
spares_limit = #$:(0..):if spares_covered = true  ; Limit for spare parts coverage
tools_covered = ?                                 ; Tools coverage included
tools_limit = #$:(0..):if tools_covered = true    ; Limit for tools coverage
avionics_scheduled = ?                            ; Avionics on scheduled basis

{@aircraft_hull_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Aircraft Liability Coverage (Extends Liability Coverage)
; ═══════════════════════════════════════════════════════════════════════════════

{@aircraft_liability_coverage}
= @liability_coverage                             ; Inherit liability coverage fields

coverage_type_ref = "AIRCRAFT_LIABILITY"          ; Coverage type identifier
aircraft_ref = :                                  ; Reference to @aircraft.id

; ───────────────────────────────────────────────────────────────────────────────
; Liability Structure
; ───────────────────────────────────────────────────────────────────────────────
liability_form = (                                ; Liability limit structure
    combined_single_limit,
    smooth,                                       ; Per seat
    split_limits
)

; Combined Single Limit
csl_limit = #$:(0..):if liability_form = combined_single_limit ; CSL limit amount

; Split Limits
{.split_limits}
each_person_bi = #$:(0..):if liability_form = split_limits ; Bodily injury per person
each_occurrence_bi = #$:(0..):if liability_form = split_limits ; Bodily injury per occurrence
property_damage = #$:(0..):if liability_form = split_limits ; Property damage per occurrence

{@aircraft_liability_coverage}

; Smooth (per seat per occurrence)
{.smooth_limits}
per_seat = #$:(0..):if liability_form = smooth    ; Liability limit per seat
per_occurrence = #$:(0..):if liability_form = smooth ; Aggregate per occurrence

{@aircraft_liability_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Passenger Liability
; ───────────────────────────────────────────────────────────────────────────────
{.passenger}
included = ?                                      ; Passenger liability included
per_person = #$:(0..):if passenger.included = true ; Passenger liability per person
per_occurrence = #$:(0..):if passenger.included = true ; Passenger liability per occurrence
passengers_excluded = ?                           ; Passengers excluded from coverage

{@aircraft_liability_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Crew Liability
; ───────────────────────────────────────────────────────────────────────────────
{.crew}
included = ?                                      ; Crew liability included
limit = #$:(0..):if crew.included = true          ; Crew liability limit

{@aircraft_liability_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Medical Payments
; ───────────────────────────────────────────────────────────────────────────────
{.medical_payments}
included = ?                                      ; Medical payments coverage included
per_person = #$:(0..):if medical_payments.included = true ; Medical payments per person
per_occurrence = #$:(0..):if medical_payments.included = true ; Medical payments per occurrence
crew_included = ?:if medical_payments.included = true ; Crew included in medical payments
passengers_included = ?:if medical_payments.included = true ; Passengers included in medical

{@aircraft_liability_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Guest Voluntary Settlement
; ───────────────────────────────────────────────────────────────────────────────
{.guest_voluntary_settlement}
included = ?                                      ; Guest voluntary settlement included
per_seat = #$:(0..):if guest_voluntary_settlement.included = true ; Settlement amount per seat
aggregate = #$:(0..):if guest_voluntary_settlement.included = true ; Aggregate settlement limit

{@aircraft_liability_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Admitted Liability
; ───────────────────────────────────────────────────────────────────────────────
{.admitted_liability}
included = ?                                      ; Admitted liability coverage included
per_seat = #$:(0..):if admitted_liability.included = true ; Admitted liability per seat
aggregate = #$:(0..):if admitted_liability.included = true ; Aggregate admitted liability limit
territory = (canada, international, us):if admitted_liability.included = true ; Coverage territory

{@aircraft_liability_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Pilot Warranty
; ═══════════════════════════════════════════════════════════════════════════════

{@pilot_warranty}
id = :                                            ; Unique pilot warranty identifier

open_pilot = ?                                    ; Open pilot warranty
approved_pilots_only = ?:if open_pilot = false    ; Only approved pilots may fly

; Open Pilot Minimums
{.minimums}
certificate = (airline_transport, commercial, private, student):if open_pilot = true ; Minimum certificate required
total_hours = ##:if open_pilot = true             ; Minimum total hours
pic_hours = ##:if open_pilot = true               ; Minimum PIC hours
make_model_hours = ##:if open_pilot = true        ; Minimum make/model hours
instrument_required = ?:if open_pilot = true      ; Instrument rating required
multi_engine_required = ?:if open_pilot = true    ; Multi-engine rating required
type_rating_required = ?:if open_pilot = true     ; Type rating required
retract_hours = ##:if open_pilot = true           ; Minimum retractable gear hours
complex_hours = ##:if open_pilot = true           ; Minimum complex aircraft hours
high_performance_hours = ##:if open_pilot = true  ; Minimum high performance hours

{@pilot_warranty}

; Note: Named pilots are in @aircraft.approved_pilots[] with their make/model experience

; ═══════════════════════════════════════════════════════════════════════════════
; Use Restrictions
; ═══════════════════════════════════════════════════════════════════════════════

{@use_restrictions}
id = :                                            ; Unique use restrictions identifier

; Permitted Uses
pleasure_business_only = ?                        ; Restricted to pleasure/business use
instruction_permitted = ?                         ; Flight instruction permitted
rental_permitted = ?                              ; Rental operations permitted
charter_permitted = ?                             ; Charter operations permitted
commercial_permitted = ?                          ; Commercial operations permitted

; Geographic Territory
territory = (                                     ; Coverage territory
    canada,
    caribbean,
    continental_us,
    mexico,
    north_america,
    worldwide
)
excluded_territories[] = :                        ; Territories excluded from coverage

; Flight Conditions
vfr_only = ?                                      ; VFR flight only
ifr_permitted = ?                                 ; IFR flight permitted
night_vfr_permitted = ?                           ; Night VFR permitted
over_water_restricted = ?                         ; Over water flight restricted
mountainous_terrain_restricted = ?                ; Mountainous terrain restricted

; ═══════════════════════════════════════════════════════════════════════════════
; Additional Coverages
; ═══════════════════════════════════════════════════════════════════════════════

{@aircraft_additional_coverage}
id = :                                            ; Unique additional coverage identifier

; ───────────────────────────────────────────────────────────────────────────────
; Temporary Substitute Aircraft
; ───────────────────────────────────────────────────────────────────────────────
{.temporary_substitute}
included = ?                                      ; Temporary substitute coverage included
value_limit = #$:(0..):if temporary_substitute.included = true ; Maximum value of substitute

{@aircraft_additional_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Newly Acquired Aircraft
; ───────────────────────────────────────────────────────────────────────────────
{.newly_acquired}
included = ?                                      ; Newly acquired coverage included
days = ##:(0..90):if newly_acquired.included = true ; Days of automatic coverage
value_limit = #$:(0..):if newly_acquired.included = true ; Maximum value of new aircraft

{@aircraft_additional_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Search and Rescue
; ───────────────────────────────────────────────────────────────────────────────
{.search_rescue}
included = ?                                      ; Search and rescue coverage included
limit = #$:(0..):if search_rescue.included = true ; Maximum search and rescue expense

{@aircraft_additional_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Loss of Use
; ───────────────────────────────────────────────────────────────────────────────
{.loss_of_use}
included = ?                                      ; Loss of use coverage included
daily_limit = #$:(0..):if loss_of_use.included = true ; Daily reimbursement limit
maximum_days = ##:(0..365):if loss_of_use.included = true ; Maximum days covered

{@aircraft_additional_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Aircraft Policy
; ═══════════════════════════════════════════════════════════════════════════════

{@aircraft_policy}
id = :                                            ; Unique policy identifier
number = :                                        ; Policy number

; ───────────────────────────────────────────────────────────────────────────────
; Term
; ───────────────────────────────────────────────────────────────────────────────
effective_date = date                             ; Policy effective date
effective_time = time                             ; Policy effective time
expiration_date = date                            ; Policy expiration date
expiration_time = time                            ; Policy expiration time
:invariant expiration_date > effective_date

; ───────────────────────────────────────────────────────────────────────────────
; Named Insured
; ───────────────────────────────────────────────────────────────────────────────
named_insured = @entity.business                  ; Primary named insured
additional_named_insureds[] = @entity.business    ; Additional named insureds

; ───────────────────────────────────────────────────────────────────────────────
; Aircraft
; ───────────────────────────────────────────────────────────────────────────────
aircraft[] = @aircraft                            ; Aircraft covered by policy

; ───────────────────────────────────────────────────────────────────────────────
; Coverages (per aircraft - linked via aircraft_ref)
; ───────────────────────────────────────────────────────────────────────────────
hull_coverages[] = @aircraft_hull_coverage        ; Hull coverage sections
liability_coverages[] = @aircraft_liability_coverage ; Liability coverage sections
additional_coverages[] = @aircraft_additional_coverage ; Additional coverages

; ───────────────────────────────────────────────────────────────────────────────
; Pilots (master list - approvals are per-aircraft in @aircraft.approved_pilots[])
; ───────────────────────────────────────────────────────────────────────────────
pilots[] = @pilot                                 ; Pilots on policy

; ───────────────────────────────────────────────────────────────────────────────
; Use Restrictions
; ───────────────────────────────────────────────────────────────────────────────
use_restrictions = @use_restrictions              ; Policy use restrictions

; ───────────────────────────────────────────────────────────────────────────────
; Exclusions
; ───────────────────────────────────────────────────────────────────────────────
{.exclusions}
war = ?true                                       ; War risk excluded
terrorism = ?                                     ; Terrorism excluded
nuclear = ?true                                   ; Nuclear hazard excluded
pollution = ?                                     ; Pollution excluded
noise_claims = ?                                  ; Noise claims excluded
criminal_acts = ?                                 ; Criminal acts excluded

{@aircraft_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Loss History
; ───────────────────────────────────────────────────────────────────────────────
{@aircraft_policy.loss_history[]}
loss_date = date                                  ; Date of loss
aircraft_registration = :                         ; Aircraft registration number
location = :                                      ; Location of loss
type_of_loss = (                                  ; Type of loss
    collision,
    ground_damage,
    hangar_rash,
    hard_landing,
    in_flight,
    liability_claim,
    propeller_strike,
    theft,
    weather
)
hull_paid = #$:(0..)                              ; Hull damage paid
liability_paid = #$:(0..)                         ; Liability paid
medical_paid = #$:(0..)                           ; Medical payments paid
total_paid = #$:(0..)                             ; Total amount paid
subrogation_recovery = #$:(0..)                   ; Amount recovered through subrogation
status = (closed, open, subrogation)              ; Claim status
description = :                                   ; Loss description

{@aircraft_policy}


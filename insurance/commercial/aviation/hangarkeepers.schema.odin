; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Hangarkeepers Liability Insurance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Bailees coverage for damage to aircraft in the care, custody, or control of
; the insured. Covers FBOs, maintenance shops, flight schools, and storage
; facilities for damage to other people's aircraft while in their possession.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../coverages/coverage.schema.odin" as cov
@import "../../coverages/lines/liability.schema.odin" as liability
@import "../business.schema.odin" as entity
@import "../business-location.schema.odin" as location

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.aviation.hangarkeepers"
version = "1.0.0"
title = "Hangarkeepers Liability Insurance Schema"
description = "Bailees coverage for aircraft in care, custody, or control"

{$derivation}
source[0].authority = "Federal Aviation Administration"
source[0].citation = "14 CFR Part 145 - Repair Stations"
source[0].url = "https://www.ecfr.gov/current/title-14/chapter-I/subchapter-H/part-145"

source[1].authority = "Federal Aviation Administration"
source[1].citation = "14 CFR Part 139 - Certification of Airports"
source[1].url = "https://www.ecfr.gov/current/title-14/chapter-I/subchapter-G/part-139"

source[2].authority = "National Air Transportation Association"
source[2].citation = "FBO Industry Standards"
source[2].url = "https://www.nata.aero/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Hangarkeepers is bailees coverage - distinct from premises liability (CGL)"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial hangarkeepers liability schema"
changelog[0].rationale = "Standalone bailees coverage separate from aircraft and CGL"

; ═══════════════════════════════════════════════════════════════════════════════
; Hangarkeepers Location
; ═══════════════════════════════════════════════════════════════════════════════

{@hangarkeepers_location}
id = :
sequence = ##:(1..)

; ───────────────────────────────────────────────────────────────────────────────
; Airport/Facility Identification
; ───────────────────────────────────────────────────────────────────────────────
airport_icao = :(4)                               ; ICAO code
airport_name = :
faa_lid = :(3..4)                                 ; FAA Location ID (US)

; Address
location = @location.business_location

; ───────────────────────────────────────────────────────────────────────────────
; Airport Classification
; ───────────────────────────────────────────────────────────────────────────────
airport_type = (
    heliport,
    private,
    public_use,
    reliever,
    seaplane_base
)
controlled_airport = ?                            ; Towered
part_139_certified = ?                            ; FAR Part 139

; ───────────────────────────────────────────────────────────────────────────────
; Facility Details
; ───────────────────────────────────────────────────────────────────────────────
{.facilities}
hangar_count = ##
hangar_sqft_total = ##
tiedown_spaces = ##
ramp_sqft = ##

{@hangarkeepers_location}

; ───────────────────────────────────────────────────────────────────────────────
; Operations at This Location
; ───────────────────────────────────────────────────────────────────────────────
{.operations}
aircraft_storage = ?
aircraft_maintenance = ?
avionics_maintenance = ?
aircraft_detailing = ?
flight_training = ?
aircraft_rental = ?
fueling = ?
aircraft_sales = ?

{@hangarkeepers_location}

; ───────────────────────────────────────────────────────────────────────────────
; Aircraft Exposure
; ───────────────────────────────────────────────────────────────────────────────
{.exposure}
max_aircraft_in_care = ##                         ; Maximum at any time
average_aircraft_in_care = ##                     ; Average daily
max_single_aircraft_value = #$                    ; Highest value aircraft
average_aircraft_value = #$
total_exposure = #$                               ; Max total value at once

{@hangarkeepers_location}

; ═══════════════════════════════════════════════════════════════════════════════
; Hangarkeepers Coverage (Extends Liability Coverage)
; ═══════════════════════════════════════════════════════════════════════════════
; Bailees coverage for damage to aircraft of others in care, custody, control

{@hangarkeepers_coverage}
= @liability_coverage                             ; Inherit liability coverage fields

coverage_type_ref = "HANGARKEEPERS"

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Form
; ───────────────────────────────────────────────────────────────────────────────
; Legal Liability: Requires proof of negligence
; Named Perils: Covers specific listed perils regardless of negligence
; Broad Form: Open perils - covers all perils except those specifically excluded

coverage_form = (
    broad_form,                                   ; Open perils
    legal_liability,                              ; Negligence required
    named_perils                                  ; Specific perils only
)

; Named Perils (when coverage_form = named_perils)
{.named_perils}
fire = ?:if coverage_form = named_perils
lightning = ?:if coverage_form = named_perils
explosion = ?:if coverage_form = named_perils
windstorm = ?:if coverage_form = named_perils
hail = ?:if coverage_form = named_perils
theft = ?:if coverage_form = named_perils
vandalism = ?:if coverage_form = named_perils
collision = ?:if coverage_form = named_perils
upset = ?:if coverage_form = named_perils
flood = ?:if coverage_form = named_perils
earthquake = ?:if coverage_form = named_perils

{@hangarkeepers_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Covered Situations
; ───────────────────────────────────────────────────────────────────────────────
{.covered_situations}
in_hangar = ?
on_ramp = ?
on_tiedown = ?
in_motion_taxiing = ?                             ; Being taxied
in_motion_towing = ?                              ; Being towed
in_flight = ?                                     ; Test flights (rare)

{@hangarkeepers_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Covered Property
; ───────────────────────────────────────────────────────────────────────────────
{.covered_property}
aircraft_hull = ?
aircraft_contents = ?                             ; Contents of aircraft
installed_equipment = ?
loose_equipment = ?                               ; Avionics being installed
customer_parts = ?

{@hangarkeepers_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Exclusions
; ───────────────────────────────────────────────────────────────────────────────
{.exclusions}
wear_and_tear = ?true
mechanical_breakdown = ?true
faulty_workmanship = ?                            ; May be covered or excluded
electrical_breakdown = ?true
inherent_vice = ?true
war = ?true
nuclear = ?true

{@hangarkeepers_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Hangarkeepers Policy
; ═══════════════════════════════════════════════════════════════════════════════

{@hangarkeepers_policy}
id = :
number = :

; ───────────────────────────────────────────────────────────────────────────────
; Term
; ───────────────────────────────────────────────────────────────────────────────
effective_date = date
effective_time = time
expiration_date = date
expiration_time = time
:invariant expiration_date > effective_date

; ───────────────────────────────────────────────────────────────────────────────
; Named Insured
; ───────────────────────────────────────────────────────────────────────────────
named_insured = @entity.business
additional_named_insureds[] = @entity.business

; ───────────────────────────────────────────────────────────────────────────────
; Business Type
; ───────────────────────────────────────────────────────────────────────────────
business_type = (
    aircraft_dealer,
    aircraft_detailer,
    aircraft_rental,
    aircraft_storage,
    avionics_shop,
    fbo,
    flight_school,
    maintenance_repair_overhaul,
    other
)
business_description = :

; ───────────────────────────────────────────────────────────────────────────────
; Locations
; ───────────────────────────────────────────────────────────────────────────────
locations[] = @hangarkeepers_location

; ───────────────────────────────────────────────────────────────────────────────
; Coverage
; ───────────────────────────────────────────────────────────────────────────────
coverage = @hangarkeepers_coverage

; ───────────────────────────────────────────────────────────────────────────────
; Employees
; ───────────────────────────────────────────────────────────────────────────────
{.employees}
total = ##
pilots = ##
mechanics = ##
line_service = ##
annual_payroll = #$

{@hangarkeepers_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Operations Volume
; ───────────────────────────────────────────────────────────────────────────────
{.operations_volume}
annual_aircraft_serviced = ##
annual_maintenance_revenue = #$
annual_storage_revenue = #$
annual_fuel_gallons = ##
annual_gross_revenue = #$

{@hangarkeepers_policy}

; ───────────────────────────────────────────────────────────────────────────────
; FAA Certifications
; ───────────────────────────────────────────────────────────────────────────────
{.certifications}
part_145_repair_station = ?
repair_station_number = ::if part_145_repair_station = true
repair_station_ratings[] = ::if part_145_repair_station = true
part_141_flight_school = ?
part_141_certificate = ::if part_141_flight_school = true
part_135_certificate = ?
part_135_number = ::if part_135_certificate = true

{@hangarkeepers_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Loss History
; ───────────────────────────────────────────────────────────────────────────────
{@hangarkeepers_policy.loss_history[]}
loss_date = date
aircraft_registration = :
aircraft_owner = :
aircraft_value = #$
location = :
situation = (in_flight, in_hangar, in_motion, on_ramp, on_tiedown)
cause_of_loss = (
    collision,
    employee_negligence,
    fire,
    flood,
    hangar_collapse,
    hangar_door,
    hail,
    other,
    prop_strike,
    theft,
    towing_damage,
    vandalism,
    wind
)
amount_paid = #$
subrogation_recovery = #$
status = (closed, open, subrogation)
description = :

{@hangarkeepers_policy}


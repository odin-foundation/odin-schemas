; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Commercial Business Location Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Physical business location extending P&C risk location with commercial-specific
; fields for property, liability, and workers compensation rating including
; construction classification, fire protection, and building occupancy details.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../personal/types.schema.odin" as types
@import "./types.schema.odin" as com

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.business-location"
version = "1.0.0"
title = "Commercial Business Location Schema"
description = "Physical business location for commercial insurance rating"

{$derivation}
source[0].authority = "U.S. Census Bureau"
source[0].citation = "American Community Survey - Building Characteristics"
source[0].url = "https://www.census.gov/programs-surveys/acs"

source[1].authority = "Federal Emergency Management Agency"
source[1].citation = "National Flood Insurance Program"
source[1].url = "https://www.fema.gov/flood-insurance"

source[2].authority = "U.S. Fire Administration"
source[2].citation = "National Fire Incident Reporting System"
source[2].url = "https://www.usfa.fema.gov/nfirs/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Comprehensive location data for property, liability, and WC rating"

changelog[0].date = 2025-12-13
changelog[0].change = "Initial business location schema"
changelog[0].rationale = "Location-level detail for commercial underwriting"

; ═══════════════════════════════════════════════════════════════════════════════
; Business Location (Extends Risk Location)
; ═══════════════════════════════════════════════════════════════════════════════

{@business_location}
= @types.risk_location                      ; Inherit base risk location fields

; ───────────────────────────────────────────────────────────────────────────────
; Location Identification
; ───────────────────────────────────────────────────────────────────────────────
location_type = !(administrative_office, assembly_facility, branch_office, call_center, clinic, construction_site, data_center, dental_office, distribution_center, farm, headquarters, hospital, hotel, job_site, laboratory, manufacturing_plant, medical_office, mine, mobile_operations, oil_gas_facility, other, parking_garage, processing_facility, quarry, ranch, repair_shop, research_facility, restaurant, retail_store, sales_office, service_center, solar_facility, storage_facility, temporary, vehicle_garaging, warehouse, wind_farm, work_from_home)

location_id = :
location_number = ##:(1..)                     ; Location sequence
location_name = :                       ; Descriptive name

; ───────────────────────────────────────────────────────────────────────────────
; Address - uses shared @address type (US and Canada)
; ───────────────────────────────────────────────────────────────────────────────
address = @address

; Suite/Unit (additional location-specific fields)
suite = :
floor = :
building = :

; ───────────────────────────────────────────────────────────────────────────────
; Geocoding
; ───────────────────────────────────────────────────────────────────────────────
{.geo}
latitude = #:(-90..90)
longitude = #:(-180..180)
accuracy = (approximate, geometric_center, range_interpolated, rooftop)
geocode_date = date
fips_code = :                            ; Census FIPS code
census_tract = :

{@business_location}

; ───────────────────────────────────────────────────────────────────────────────
; Building Information
; ───────────────────────────────────────────────────────────────────────────────
{.building}
year_built = ##:(1700..2100)
year_renovated = ##:(1700..2100)
story_count = ##:(1..)
basement = ?
basement_finished = ?:if basement = true
total_square_footage = ##:(0..)
occupied_square_footage = ##:(0..)

; Building Use
use_type = (
    agricultural,
    commercial,
    industrial,
    manufacturing,
    mixed_use,
    office,
    residential,
    retail,
    warehouse
)
single_occupant = ?
tenant_occupied = ?

{@business_location}

; ───────────────────────────────────────────────────────────────────────────────
; Construction Classification
; ───────────────────────────────────────────────────────────────────────────────
{.construction}
construction_class = !(
    class_1_frame,                             ; Wood frame
    class_2_joisted_masonry,                   ; Masonry walls, wood floors/roof
    class_3_noncombustible,                    ; Metal/steel frame
    class_4_masonry_noncombustible,            ; Masonry walls, metal deck
    class_5_modified_fire_resistive,           ; Modified fire resistive
    class_6_fire_resistive                     ; Full fire resistive concrete/steel
)

wall_material = (
    concrete_poured,
    concrete_tilt_up,
    glass_curtain_wall,
    masonry_block,
    masonry_brick,
    masonry_stone,
    metal_aluminum,
    metal_steel,
    mixed,
    wood_frame
)

roof_material = (
    asphalt_shingle,
    built_up,
    gravel,
    metal,
    single_ply_membrane,
    slate,
    tile_clay,
    tile_concrete,
    wood_shingle
)

roof_shape = (flat, gable, gambrel, hip, mansard, pitched)
floor_material = (concrete, steel_deck, wood)
fire_rating_hours = ##:(0..4)                  ; Fire resistance rating

{@business_location}

; ───────────────────────────────────────────────────────────────────────────────
; Public Protection Classification
; ───────────────────────────────────────────────────────────────────────────────
{.protection}
ppc = :(1..10)                                 ; Public Protection Class (ISO fire protection rating)
split_ppc = :
ppc_effective_date = date

; Fire Department
fire_department_name = :
responding_fire_station = :
distance_to_station_miles = #:(0..99)
fire_department_type = (career, combination, none, volunteer)
distance_to_hydrant_feet = ##:(0..9999)
hydrant_type = (none, private, public)
fire_district = :

{@business_location}

; ───────────────────────────────────────────────────────────────────────────────
; Fire Protection Systems
; ───────────────────────────────────────────────────────────────────────────────
{.fire_protection}
fire_alarm = ?
alarm_type = (
    central_station,
    local,
    none,
    proprietary,
    remote_station
):if fire_alarm = true
alarm_monitoring_company = :
alarm_certificate_number = :

sprinkler_system = ?
sprinkler_type = (
    deluge,
    dry_pipe,
    foam,
    partial,
    pre_action,
    wet_pipe
):if sprinkler_system = true
sprinkler_coverage = (full, partial):if sprinkler_system = true
sprinkler_maintenance = ?:if sprinkler_system = true
last_sprinkler_inspection = date:if sprinkler_system = true

standpipe = ?
fire_extinguishers = ?
smoke_detectors = ?
heat_detectors = ?
fire_suppression_other = :

{@business_location}

; ───────────────────────────────────────────────────────────────────────────────
; Security Systems
; ───────────────────────────────────────────────────────────────────────────────
{.security}
burglar_alarm = ?
alarm_type = (central_station, local, none):if burglar_alarm = true
surveillance_cameras = ?
camera_count = ##:(0..999):if surveillance_cameras = true
access_control = ?
access_control_type = (biometric, keycard, keypad, traditional):if access_control = true
security_guard = (24_hour, business_hours, night_only, none)
security_guard_armed = ?:if security_guard = 24_hour
security_guard_armed = ?:if security_guard = business_hours
security_guard_armed = ?:if security_guard = night_only
perimeter_fence = ?
fence_type = (barbed_wire, chain_link, electric, privacy):if perimeter_fence = true
safe_vault = ?
safe_rating = ::if safe_vault = true

{@business_location}

; ───────────────────────────────────────────────────────────────────────────────
; Operations at Location
; ───────────────────────────────────────────────────────────────────────────────
{.operations}
description = :
primary_activity = :
secondary_activities[] = :

; Employee Information at Location
employees_at_location = ##:(0..99999)
employees_full_time = ##:(0..99999)
employees_part_time = ##:(0..99999)

; Financial at Location
payroll_at_location = #$
revenue_at_location = #$
receipts_at_location = #$

; Hours of Operation
hours_of_operation = :
days_per_week = ##:(1..7)
operates_24_hours = ?
seasonal_operation = ?
months_of_operation = ##:(1..12):if seasonal_operation = true

{@business_location}

; ───────────────────────────────────────────────────────────────────────────────
; Property Values at Location
; ───────════════════════════════════════════════════════════════════════════════
{.property}
building_value = #$
building_valuation = (actual_cash_value, agreed_value, functional, replacement_cost)
contents_value = #$
contents_valuation = (actual_cash_value, replacement_cost)
business_personal_property = #$
improvements_betterments = #$
equipment_value = #$
inventory_value = #$
outdoor_property = #$

; Business Income
business_income_limit = #$
extra_expense_limit = #$
ordinary_payroll_included = ?

{@business_location}

; ───────────────────────────────────────────────────────────────────────────────
; Occupancy Status
; ───────────────────────────────────────────────────────────────────────────────
{.occupancy}
type = (owner_occupied, tenant, under_construction, vacant)
lease_effective = date:if type = tenant
lease_expiration = date:if type = tenant
landlord_name = ::if type = tenant
percentage_occupied = ##:(0..100)

; Tenant Information (if building owner)
tenant_count = ##:(0..999):if type = owner_occupied
tenant_types[] = :

{@business_location}

; ───────────────────────────────────────────────────────────────────────────────
; Environmental/Hazards
; ───────────────────────────────────────────────────────────────────────────────
{.hazards}
flood_zone = :                           ; FEMA flood zone
in_sfha = ?                                    ; Special Flood Hazard Area
earthquake_zone = ##:(0..4)
wind_zone = ##:(0..4)
hurricane_exposure = ?
tornado_alley = ?
wildfire_risk = (extreme, high, low, moderate)
coastal_location = ?
distance_to_coast_miles = #:(0..500):if coastal_location = true

; Environmental
underground_storage_tanks = ?
ust_count = ##:(0..99):if underground_storage_tanks = true
above_ground_storage_tanks = ?
hazardous_materials_stored = ?
hazardous_materials_types[] = ::if hazardous_materials_stored = true
asbestos_present = ?
lead_paint_present = ?
mold_issues = ?
environmental_contamination = ?

{@business_location}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, inactive, pending, removed)
effective_date = date
removed_date = date
removed_reason = :

; ═══════════════════════════════════════════════════════════════════════════════
; Workers Compensation Class Codes at Location
; ═══════════════════════════════════════════════════════════════════════════════

{@business_location.wc_classes[]}
class_code = !:                          ; State class code
payroll = !#$

class_description = :
governing_class = ?                            ; Is this the governing class?
employee_count = ##:(0..99999)
rate = #:(0..999.999999)                       ; Per $100 payroll
base_premium = #$

; ═══════════════════════════════════════════════════════════════════════════════
; GL Classifications at Location
; ═══════════════════════════════════════════════════════════════════════════════

{@business_location.gl_classes[]}
class_code = !:                         ; GL class code
exposure_basis = !(admissions, area, gross_receipts, other, payroll, sales, units)
exposure_amount = !#$

class_description = :
rate = #:(0..999.999999)
base_premium = #$
products_exposure = #$       ; Products/completed ops exposure


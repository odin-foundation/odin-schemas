; ===================================================================================
; ODIN Agriculture Equipment Schema
; ===================================================================================
; Farm machinery and equipment including tractors, implements, telematics,
; maintenance, and precision agriculture equipment (GPS guidance, yield monitors, VRT).
; ===================================================================================

@import "../common/types.schema.odin" as types
@import "../common/vehicle.schema.odin" as vehicle

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.agriculture.equipment"
version = "1.0.0"
title = "Agriculture Equipment Schema"
description = "Farm machinery, telematics, maintenance, and precision agriculture"

{$derivation}
source[0].authority = "Agricultural Industry Electronics Foundation (AEF)"
source[0].citation = "ISOBUS Standards (ISO 11783)"
source[0].url = "https://www.iso.org/standard/57556.html"

source[1].authority = "AgGateway"
source[1].citation = "ADAPT Framework - Agricultural Data Application Programming Toolkit"
source[1].url = "https://adaptframework.org/"

source[2].authority = "Association of Equipment Manufacturers"
source[2].citation = "Equipment Data Dictionary and Telemetry Standards"
source[2].url = "https://www.aem.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial agriculture equipment schema"
changelog[0].rationale = "Equipment structures derived from ISOBUS, ADAPT, and AEM standards"

; ===================================================================================
; EQUIPMENT
; ===================================================================================

{@equipment}
= @types.audit_info

; ───────────────────────────────────────────────────────────────────────────────
; Identification
; ───────────────────────────────────────────────────────────────────────────────
equipment_id = !:                                ; Unique equipment identifier
equipment_number = :                             ; Equipment/unit number
equipment_name = :                               ; Equipment name/nickname
farm_ref = :                                     ; Farm reference

; ───────────────────────────────────────────────────────────────────────────────
; Classification
; ───────────────────────────────────────────────────────────────────────────────
{.classification}
equipment_category = (harvesting, haying, implement, planting, power_unit, spraying, tillage, utility)
equipment_type = !:                              ; Specific type (tractor, combine, planter, etc.)
self_propelled = ?                               ; Self-propelled equipment
towed = ?                                        ; Towed implement
mounted = ?                                      ; Mounted implement
pto_driven = ?                                   ; PTO-driven implement

{@equipment}

; ───────────────────────────────────────────────────────────────────────────────
; Manufacturer Details
; ───────────────────────────────────────────────────────────────────────────────
{.manufacturer}
make = !:                                        ; Manufacturer
model = !:                                       ; Model
model_year = ##:(1900..2100)                     ; Model year
serial_number = *:                               ; Serial number (confidential)
vin = *:format vin:if equipment_category = power_unit

{@equipment}

; ───────────────────────────────────────────────────────────────────────────────
; Specifications
; ───────────────────────────────────────────────────────────────────────────────
{.specifications}
engine_hp = ##:(0..)                             ; Engine horsepower
pto_hp = ##:(0..)                                ; PTO horsepower
fuel_type = (biodiesel, diesel, electric, gasoline, hybrid, propane)
engine_hours = #:(0..)                           ; Current engine hours
transmission_type = (automatic, cvt, hydrostatic, manual, powershift)
four_wheel_drive = ?                             ; 4WD equipped
weight_lbs = ##:(0..)                            ; Operating weight
width_in = #:(0..)                               ; Working width (inches)
capacity = #:(0..)                               ; Capacity (bushels, gallons, etc.)
capacity_unit = :                                ; Capacity unit

{@equipment}

; ───────────────────────────────────────────────────────────────────────────────
; Ownership
; ───────────────────────────────────────────────────────────────────────────────
{.ownership}
ownership_type = (leased, owned, rented, shared)
owner_id = :                                     ; Owner ID
acquisition_date = date                          ; Purchase/acquisition date
acquisition_cost = #$:(0..)                      ; Purchase price
estimated_value = #$:(0..)                       ; Current estimated value
depreciation_method = (declining_balance, straight_line, units_of_production)

{@equipment}

; ───────────────────────────────────────────────────────────────────────────────
; Lease/Finance
; ───────────────────────────────────────────────────────────────────────────────
{.lease}
lessor = ::if ownership_type = leased            ; Leasing company
lease_start_date = date:if ownership_type = leased
lease_end_date = date:if ownership_type = leased
monthly_payment = #$:(0..):if ownership_type = leased
buyout_amount = #$:(0..):if ownership_type = leased
loan_balance = #$:(0..)                          ; Outstanding loan balance
lien_holder = :                                  ; Lien holder name

{@equipment}

; ───────────────────────────────────────────────────────────────────────────────
; Status & Location
; ───────────────────────────────────────────────────────────────────────────────
{.status}
operational_status = (active, down, in_maintenance, retired, sold)
status_date = date                               ; Status change date
current_location = :                             ; Current location description
storage_location = @types.address                ; Storage address
assigned_operator = :                            ; Assigned operator ID

{@equipment}

; ───────────────────────────────────────────────────────────────────────────────
; Insurance
; ───────────────────────────────────────────────────────────────────────────────
{.insurance}
insured = ?                                      ; Equipment insured
insurance_company = :                            ; Insurance provider
policy_number = :                                ; Policy number
coverage_amount = #$:(0..)                       ; Coverage amount
premium = #$:(0..)                               ; Annual premium
policy_expiration = date                         ; Policy expiration date

{@equipment}

; ───────────────────────────────────────────────────────────────────────────────
; Maintenance
; ───────────────────────────────────────────────────────────────────────────────
maintenance_records[] = @maintenance_record

; ───────────────────────────────────────────────────────────────────────────────
; Telematics
; ───────────────────────────────────────────────────────────────────────────────
telematics = @telematics

; ───────────────────────────────────────────────────────────────────────────────
; Precision Agriculture
; ───────────────────────────────────────────────────────────────────────────────
precision_ag = @precision_ag

; ===================================================================================
; MAINTENANCE RECORD
; ===================================================================================

{@maintenance_record}
; ───────────────────────────────────────────────────────────────────────────────
; Record Details
; ───────────────────────────────────────────────────────────────────────────────
maintenance_id = !:                              ; Maintenance record ID
maintenance_date = !date                         ; Date performed
equipment_id = !:                                ; Equipment ID
engine_hours = #:(0..)                           ; Engine hours at maintenance
odometer_miles = #:(0..)                         ; Odometer reading if applicable

; ───────────────────────────────────────────────────────────────────────────────
; Maintenance Type
; ───────────────────────────────────────────────────────────────────────────────
{.maintenance_type}
service_type = (inspection, modification, preventive, repair, safety_recall)
category = (electrical, engine, hydraulic, mechanical, scheduled_service, tire, transmission)
description = !:                                 ; Maintenance description
severity = (critical, high, low, medium)
downtime_hours = #:(0..)                         ; Equipment downtime

{@maintenance_record}

; ───────────────────────────────────────────────────────────────────────────────
; Parts & Labor
; ───────────────────────────────────────────────────────────────────────────────
{.parts[]}
part_number = :                                  ; Part number
part_description = :                             ; Part description
quantity = ##:(1..)                              ; Quantity
unit_cost = #$:(0..)                             ; Cost per unit
total_cost = #$:(0..)                            ; Total part cost

{@maintenance_record}

{.labor}
technician_name = :                              ; Technician name
labor_hours = #:(0..)                            ; Labor hours
labor_rate = #$:(0..)                            ; Hourly rate
labor_cost = #$:(0..)                            ; Total labor cost

{@maintenance_record}

; ───────────────────────────────────────────────────────────────────────────────
; Service Provider
; ───────────────────────────────────────────────────────────────────────────────
{.service_provider}
provider_name = :                                ; Service provider name
provider_type = (dealer, in_house, independent)
invoice_number = :                               ; Invoice number
warranty_work = ?                                ; Covered under warranty

{@maintenance_record}

; ───────────────────────────────────────────────────────────────────────────────
; Costs
; ───────────────────────────────────────────────────────────────────────────────
{.costs}
parts_total = #$:(0..)                           ; Total parts cost
labor_total = #$:(0..)                           ; Total labor cost
tax = #$:(0..)                                   ; Sales tax
shipping = #$:(0..)                              ; Shipping cost
total_cost = #$:(0..)                            ; Total maintenance cost

; ===================================================================================
; TELEMATICS
; ===================================================================================

{@telematics}
; ───────────────────────────────────────────────────────────────────────────────
; System Information
; ───────────────────────────────────────────────────────────────────────────────
telematics_provider = :                          ; Telematics provider
device_id = :                                    ; Telematics device ID
device_serial = :                                ; Device serial number
installed_date = date                            ; Installation date
subscription_status = (active, expired, inactive, trial)
subscription_expiration = date                   ; Subscription expiration

; ───────────────────────────────────────────────────────────────────────────────
; Connectivity
; ───────────────────────────────────────────────────────────────────────────────
{.connectivity}
cellular_carrier = :                             ; Cellular carrier
sim_number = :                                   ; SIM card number
last_connection = timestamp                      ; Last connection timestamp
connection_status = (connected, disconnected, error)
signal_strength = ##:(0..100)                    ; Signal strength percentage

{@telematics}

; ───────────────────────────────────────────────────────────────────────────────
; Current Status (Real-time)
; ───────────────────────────────────────────────────────────────────────────────
{.current_status}
status_timestamp = timestamp                     ; Status timestamp
latitude = #:(-90..90)                           ; Current latitude
longitude = #:(-180..180)                        ; Current longitude
heading_degrees = #:(0..360)                     ; Heading (degrees)
speed_mph = #:(0..)                              ; Current speed (mph)
engine_running = ?                               ; Engine status
engine_hours = #:(0..)                           ; Engine hours
fuel_level_percent = #:(0..100)                  ; Fuel level percentage
coolant_temp_f = #:(-50..300)                    ; Coolant temperature
oil_pressure_psi = #:(0..200)                    ; Oil pressure
battery_voltage = #:(0..30)                      ; Battery voltage

{@telematics}

; ───────────────────────────────────────────────────────────────────────────────
; Diagnostics
; ───────────────────────────────────────────────────────────────────────────────
{.diagnostics}
fault_codes[] = :                                ; Active fault codes
warnings[] = :                                   ; Active warnings
def_level_percent = #:(0..100)                   ; DEF fluid level (diesel)
regen_status = (active, not_needed, required)    ; DPF regeneration status

; ===================================================================================
; PRECISION AGRICULTURE
; ===================================================================================

{@precision_ag}
; ───────────────────────────────────────────────────────────────────────────────
; GPS/Guidance System
; ───────────────────────────────────────────────────────────────────────────────
{.guidance}
guidance_system = :                              ; Guidance system brand/model
guidance_type = (assisted_steering, autosteer, manual_guidance, rtk_autosteer)
accuracy_cm = #:(0..)                            ; Positioning accuracy (cm)
rtk_provider = :                                 ; RTK correction provider
subscription_status = (active, expired, trial)
antenna_type = :                                 ; GPS antenna type
calibration_date = date                          ; Last calibration date

{@precision_ag}

; ───────────────────────────────────────────────────────────────────────────────
; Yield Monitor
; ───────────────────────────────────────────────────────────────────────────────
{.yield_monitor}
monitor_brand = :                                ; Yield monitor brand
monitor_model = :                                ; Monitor model
moisture_sensor = ?                              ; Moisture sensor equipped
mass_flow_sensor = ?                             ; Mass flow sensor
calibration_date = date                          ; Last calibration
crop_type = :                                    ; Calibrated for crop type
calibration_factor = #                           ; Calibration factor

{@precision_ag}

; ───────────────────────────────────────────────────────────────────────────────
; Variable Rate Technology (VRT)
; ───────────────────────────────────────────────────────────────────────────────
{.vrt}
vrt_capable = ?                                  ; VRT capable
vrt_type = (prescription_map, sensor_based)
application_types[] = :                          ; VRT application types (seed, fertilizer, etc.)
control_system = :                               ; VRT control system
section_control = ?                              ; Section control enabled
section_count = ##:(0..)                         ; Number of controllable sections

{@precision_ag}

; ───────────────────────────────────────────────────────────────────────────────
; Data Management
; ───────────────────────────────────────────────────────────────────────────────
{.data}
isobus_compatible = ?                            ; ISOBUS compatible (ISO 11783)
task_controller = :                              ; Task controller brand/model
data_format = :                                  ; Data export format (ISOXML, ADAPT, etc.)
cloud_platform = :                               ; Cloud data platform
auto_upload = ?                                  ; Automatic data upload enabled
last_upload = timestamp                          ; Last data upload

; ===================================================================================
; FIELD OPERATION
; ===================================================================================

{@field_operation}
; ───────────────────────────────────────────────────────────────────────────────
; Operation Details
; ───────────────────────────────────────────────────────────────────────────────
operation_id = !:                                ; Operation ID
operation_date = !date                           ; Date performed
operation_type = (fertilizing, harvesting, planting, spraying, tillage)
field_ref = !:                                   ; Field reference
equipment_id = !:                                ; Equipment used
operator_id = :                                  ; Operator ID

; ───────────────────────────────────────────────────────────────────────────────
; Area & Duration
; ───────────────────────────────────────────────────────────────────────────────
{.work}
acres_worked = !#:(0..)                          ; Acres worked
start_time = timestamp                           ; Operation start time
end_time = timestamp                             ; Operation end time
duration_hours = #:(0..)                         ; Duration in hours
passes = ##:(0..)                                ; Number of passes

{@field_operation}

; ───────────────────────────────────────────────────────────────────────────────
; Application (if applicable)
; ───────────────────────────────────────────────────────────────────────────────
{.application}
product_name = :                                 ; Product applied
application_rate = #:(0..)                       ; Target rate per acre
rate_unit = :                                    ; Rate unit
total_applied = #:(0..)                          ; Total quantity applied
variable_rate = ?                                ; Variable rate application
avg_rate = #:(0..)                               ; Actual average rate
min_rate = #:(0..)                               ; Minimum rate applied
max_rate = #:(0..)                               ; Maximum rate applied

{@field_operation}

; ───────────────────────────────────────────────────────────────────────────────
; Conditions
; ───────────────────────────────────────────────────────────────────────────────
{.conditions}
temperature_f = #:(-50..150)                     ; Temperature (Fahrenheit)
wind_speed_mph = #:(0..100)                      ; Wind speed
soil_moisture = (dry, moist, wet)
weather = :                                      ; Weather conditions

{@field_operation}

; ───────────────────────────────────────────────────────────────────────────────
; Performance
; ───────────────────────────────────────────────────────────────────────────────
{.performance}
fuel_used_gal = #:(0..)                          ; Fuel consumed (gallons)
fuel_rate_gal_per_acre = #:(0..)                 ; Fuel rate per acre
avg_speed_mph = #:(0..)                          ; Average working speed
efficiency_acres_per_hour = #:(0..)              ; Acres per hour

{@field_operation}

; ───────────────────────────────────────────────────────────────────────────────
; Costs
; ───────────────────────────────────────────────────────────────────────────────
{.costs}
labor_cost = #$:(0..)                            ; Labor cost
fuel_cost = #$:(0..)                             ; Fuel cost
equipment_cost = #$:(0..)                        ; Equipment/depreciation cost
product_cost = #$:(0..)                          ; Product cost (if applicable)
total_cost = #$:(0..)                            ; Total operation cost
cost_per_acre = #$:(0..)                         ; Cost per acre

{@field_operation}

; ───────────────────────────────────────────────────────────────────────────────
; Geospatial Data
; ───────────────────────────────────────────────────────────────────────────────
{.geospatial}
coverage_map_url = :                             ; Coverage map file URL
as_applied_map_url = :                           ; As-applied map URL
yield_map_url = :                                ; Yield map URL (if harvesting)
boundary_logged = ?                              ; Field boundary logged
headland_logged = ?                              ; Headland tracks logged

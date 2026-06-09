; ===================================================================================
; ODIN Automotive Fleet Schema
; ===================================================================================
; Fleet management including driver assignment, maintenance, telematics, and fuel.
; Derived from DOT requirements and industry fleet management practices.
; ===================================================================================

@import "../common/vehicle.schema.odin" as vehicle
@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.automotive.fleet"
version = "1.0.0"
title = "Automotive Fleet Schema"
description = "Fleet management including driver assignment, maintenance, telematics, and fuel"

{$derivation}
source[0].authority = "Federal Motor Carrier Safety Administration"
source[0].citation = "49 CFR Part 395 - Hours of Service of Drivers"
source[0].url = "https://www.ecfr.gov/current/title-49/subtitle-B/chapter-III/subchapter-B/part-395"

source[1].authority = "Federal Motor Carrier Safety Administration"
source[1].citation = "49 CFR Part 396 - Inspection, Repair, and Maintenance"
source[1].url = "https://www.ecfr.gov/current/title-49/subtitle-B/chapter-III/subchapter-B/part-396"

source[2].authority = "Society of Automotive Engineers"
source[2].citation = "SAE J1939 - Serial Control and Communications Vehicle Network"
source[2].url = "https://www.sae.org/standards/content/j1939_201308/"

source[3].authority = "NAFA Fleet Management Association"
source[3].citation = "NAFA Fleet Metrics and Benchmarking Standards"
source[3].url = "https://www.nafa.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Fleet management structures per FMCSA, SAE, and NAFA standards"

changelog[0].date = 2025-12-21
changelog[0].change = "Initial automotive fleet schema"
changelog[0].rationale = "Structures derived from DOT regulations and fleet industry practices"

; ===================================================================================
; FLEET VEHICLE
; ===================================================================================
; Vehicle assigned to a fleet with operational data.

{@fleet_vehicle}
= @vehicle_identification                        ; Inherits core vehicle identification

; Fleet assignment
{.fleet}
fleet_id = :                                    ; Fleet identifier
fleet_name = :                                   ; Fleet name
unit_number = :                                  ; Fleet unit number
asset_number = :                                 ; Asset/equipment number
department = :                                   ; Assigned department
cost_center = :                                  ; Cost center code
division = :                                     ; Division

{@fleet_vehicle}

; Vehicle status
{.status}
status = (
    active,                                      ; In service
    decommissioned,                              ; Removed from fleet
    maintenance,                                 ; In maintenance
    out_of_service,                              ; Out of service
    pool,                                        ; Pool/unassigned
    reserved,                                    ; Reserved
    storage                                      ; In storage
)
status_date = date                               ; Status change date
status_reason = :                                ; Status reason
estimated_return = date                          ; Estimated return date

{@fleet_vehicle}

; Acquisition
{.acquisition}
acquisition_type = (lease, purchase, rental)    ; How acquired
acquisition_date = date                          ; Date acquired
in_service_date = date                           ; Date in service
acquisition_cost = #$:(0..)                      ; Acquisition cost
lease_id = ::if acquisition_type = lease         ; Lease reference
vendor = :                                       ; Vendor/seller

{@fleet_vehicle}

; Disposal
{.disposal}
planned_disposal_date = date                     ; Planned disposal
planned_disposal_mileage = ##:(0..)              ; Planned disposal miles
actual_disposal_date = date                      ; Actual disposal
disposal_type = (auction, dealer, employee, trade, wholesale)
disposal_value = #$:(0..)                        ; Disposal proceeds

{@fleet_vehicle}

; Current metrics
{.metrics}
current_odometer = ##:(0..)                      ; Current odometer
odometer_date = date                             ; Odometer read date
lifetime_miles = ##:(0..)                        ; Total miles driven
ytd_miles = ##:(0..)                             ; Year to date miles
avg_daily_miles = #:(0..)                        ; Average daily miles
days_in_service = ##:(0..)                       ; Total days in service

{@fleet_vehicle}

; Assigned driver
current_driver = @driver_assignment              ; Current driver

; Garaging location
{.location}
primary_location = :                             ; Primary location name
primary_address = @address                       ; Primary address
overnight_location = :                           ; Overnight location
territory = :                                    ; Operating territory

{@fleet_vehicle}

; Licensing and registration
{.registration}
registration_state = :(2)                        ; Registration state
plate_number = :                                 ; License plate
plate_type = (commercial, fleet, standard)       ; Plate type
registration_expiration = date                   ; Registration expiration
irp_registered = ?                               ; IRP registration
ifta_registered = ?                              ; IFTA registration
dot_number = :                                   ; DOT number
mc_number = :                                    ; MC number

{@fleet_vehicle}

; Equipment installed
{.equipment}
telematics_installed = ?                         ; Telematics device
telematics_provider = ::if telematics_installed = true
gps_device_id = ::if telematics_installed = true
eld_installed = ?                                ; ELD device
eld_provider = ::if eld_installed = true
dash_camera = ?                                  ; Dash camera
camera_provider = ::if dash_camera = true
fuel_card_assigned = ?                           ; Fuel card
fuel_card_number = *::if fuel_card_assigned = true
ez_pass = ?                                      ; Toll transponder
ez_pass_number = ::if ez_pass = true

{@fleet_vehicle}

; ===================================================================================
; DRIVER ASSIGNMENT
; ===================================================================================
; Driver-to-vehicle assignment record.

{@driver_assignment}
; Required fields first
assignment_id = :                               ; Assignment identifier
driver_id = :                                   ; Driver identifier
vehicle_id = :                                  ; Vehicle identifier
assignment_type = (permanent, pool, temporary)

; Driver information
{.driver}
= @person                                        ; Inherits person fields

; Driver license override to make required
{.license}
license_number = *:                             ; Driver license (required, confidential)
license_state = :(2)                            ; License state (required)
license_class = :                                ; License class (A, B, C, CDL)
license_expiration = date                        ; License expiration
endorsements[] = :                               ; Endorsements (H, T, P, N, S, X)
restrictions[] = :                               ; Restrictions

{@driver_assignment}

{.employment}
employee_id = :                                  ; Employee ID
department = :                                   ; Department
job_title = :                                    ; Job title
supervisor = :                                   ; Supervisor name
hire_date = date                                 ; Hire date
termination_date = date                          ; Termination date

{@driver_assignment}

; Assignment dates
{.dates}
effective_date = date                           ; Assignment start
end_date = date                                  ; Assignment end
reason_ended = ::if end_date                     ; Reason assignment ended

{@driver_assignment}

; Authorization
{.authorization}
authorized = ?                                   ; Authorization verified
authorization_date = date                        ; Authorization date
mvr_checked = ?                                  ; MVR checked
mvr_date = date                                  ; MVR check date
mvr_acceptable = ?                               ; MVR acceptable
training_completed = ?                           ; Training completed
training_date = date                             ; Training date
drug_test_completed = ?                          ; Drug test done
drug_test_date = date                            ; Drug test date

{@driver_assignment}

; Usage terms
{.usage}
personal_use_allowed = ?                         ; Personal use allowed
commute_allowed = ?                              ; Commute use allowed
family_use_allowed = ?                           ; Family member use
geographic_restrictions = :                      ; Geographic limits
mileage_limit = ##:(0..)                         ; Monthly mileage limit

{@driver_assignment}

; Driver metrics
{.metrics}
miles_driven = ##:(0..)                          ; Miles driven on assignment
fuel_used_gal = #:(0..)                          ; Fuel used
mpg_average = #:(0..100)                         ; Average MPG
accidents = ##:(0..)                             ; Accidents
violations = ##:(0..)                            ; Violations
safety_score = ##:(0..100)                       ; Safety score

{@driver_assignment}

; ===================================================================================
; MAINTENANCE SCHEDULE
; ===================================================================================
; Preventive maintenance scheduling per FMCSA 49 CFR Part 396.

{@maintenance_schedule}
; Required fields first
vehicle_id = :                                  ; Vehicle identifier
schedule_type = (custom, manufacturer, mileage, time)

; Service intervals
{.intervals}
oil_change_miles = ##:(0..)                      ; Oil change interval
oil_change_months = ##:(0..)                     ; Oil change months
tire_rotation_miles = ##:(0..)                   ; Tire rotation interval
brake_inspection_miles = ##:(0..)                ; Brake inspection
transmission_service_miles = ##:(0..)            ; Transmission service
coolant_service_miles = ##:(0..)                 ; Coolant service
air_filter_miles = ##:(0..)                      ; Air filter interval
fuel_filter_miles = ##:(0..)                     ; Fuel filter interval
spark_plug_miles = ##:(0..)                      ; Spark plug interval
timing_belt_miles = ##:(0..)                     ; Timing belt interval

{@maintenance_schedule}

; Next service due
{.next_service}
oil_change_due_miles = ##:(0..)                  ; Oil change due at
oil_change_due_date = date                       ; Oil change due by
brake_inspection_due = date                      ; Brake inspection due
tire_rotation_due = date                         ; Tire rotation due
annual_inspection_due = date                     ; Annual inspection due
dot_inspection_due = date                        ; DOT inspection due
emissions_due = date                             ; Emissions test due
registration_renewal_due = date                  ; Registration due

{@maintenance_schedule}

; Last service
{.last_service}
last_oil_change_miles = ##:(0..)                 ; Last oil change mileage
last_oil_change_date = date                      ; Last oil change date
last_brake_inspection = date                     ; Last brake inspection
last_tire_rotation = date                        ; Last tire rotation
last_annual_inspection = date                    ; Last annual inspection
last_dot_inspection = date                       ; Last DOT inspection

{@maintenance_schedule}

; Alerts
{.alerts}
service_due = ?                                  ; Service due flag
service_overdue = ?                              ; Service overdue flag
overdue_days = ##:(0..)                          ; Days overdue
overdue_miles = ##:(0..)                         ; Miles overdue
next_alert_date = date                           ; Next alert date

{@maintenance_schedule}

; ===================================================================================
; MAINTENANCE WORK ORDER
; ===================================================================================
; Maintenance work order and repair record.

{@maintenance_work_order}
; Required fields first
work_order_id = :                               ; Work order number
vehicle_id = :                                  ; Vehicle identifier
order_date = date                               ; Order date
order_type = (breakdown, pm, recall, repair, warranty)

; Status
{.status}
status = (cancelled, closed, completed, in_progress, open, waiting_parts)
priority = (emergency, high, low, normal)        ; Priority
requested_by = :                                 ; Requester
requested_date = date                            ; Request date
scheduled_date = date                            ; Scheduled date
completed_date = date                            ; Completion date

{@maintenance_work_order}

; Vehicle at service
{.vehicle}
vin = *:format vin                               ; VIN
unit_number = :                                  ; Unit number
odometer_in = ##:(0..)                           ; Odometer at check-in
odometer_out = ##:(0..)                          ; Odometer at check-out
engine_hours_in = ##:(0..)                       ; Engine hours in
engine_hours_out = ##:(0..)                      ; Engine hours out

{@maintenance_work_order}

; Service provider
{.provider}
internal = ?                                     ; Internal or external
shop_name = :                                    ; Shop name
shop_address = @address                          ; Shop address
vendor_id = :                                    ; Vendor ID
technician = :                                   ; Technician name

{@maintenance_work_order}

; Work performed
work_items[] = @work_item                        ; Work items

; Parts used
parts[] = @work_order_part                       ; Parts used

; Costs
{.costs}
labor_hours = #:(0..)                            ; Labor hours
labor_rate = #$:(0..)                            ; Labor rate
labor_total = #$:(0..)                           ; Labor total
parts_total = #$:(0..)                           ; Parts total
sublet_total = #$:(0..)                          ; Sublet/outside services
tax = #$:(0..)                                   ; Tax
total_cost = #$:(0..)                            ; Total cost
warranty_coverage = #$:(0..)                     ; Warranty covered amount
net_cost = #$:(0..)                              ; Net cost to fleet

{@maintenance_work_order}

; Payment
{.payment}
payment_type = (account, credit, fleet_card, po)
po_number = :                                    ; PO number
invoice_number = :                               ; Invoice number
paid = ?                                         ; Paid

{@maintenance_work_order}

; Downtime
{.downtime}
downtime_hours = #:(0..)                         ; Hours out of service
downtime_start = timestamp                       ; Out of service start
downtime_end = timestamp                         ; Returned to service
substitute_vehicle = :                           ; Substitute vehicle ID

{@maintenance_work_order}

{@work_item}
; Required fields first
item_number = ##:(1..)                          ; Line item number
service_code = :                                ; Service code (VMRS, ATA)
description = :                                 ; Work description

; Classification
category = (body, brakes, electrical, engine, exhaust, hvac, pm, steering, suspension, tires, transmission)
reason = (breakdown, customer_request, dot_violation, inspection, pm, recall, wear)

; Labor
labor_hours = #:(0..)                            ; Labor hours
labor_rate = #$:(0..)                            ; Labor rate
labor_cost = #$:(0..)                            ; Labor cost

; Status
completed = ?                                    ; Completed
technician = :                                   ; Technician

{@work_order_part}
; Required fields first
part_number = :                                 ; Part number
description = :                                 ; Part description
quantity = ##:(1..)                             ; Quantity used

; Part details
part_type = (aftermarket, new_oem, remanufactured, used)
vendor = :                                       ; Part vendor
core_charge = #$:(0..)                           ; Core charge
unit_cost = #$:(0..)                             ; Unit cost
extended_cost = #$:(0..)                         ; Extended cost

; Warranty
warranty_months = ##:(0..)                       ; Part warranty
warranty_miles = ##:(0..)                        ; Part warranty miles
under_warranty = ?                               ; Covered by warranty

; ===================================================================================
; TELEMATICS DATA
; ===================================================================================
; Telematics/GPS data per SAE J1939 and industry standards.

{@telematics_event}
; Required fields first
event_id = :                                    ; Event identifier
vehicle_id = :                                  ; Vehicle identifier
event_timestamp = timestamp                     ; Event timestamp
event_type = (
    accident,                                    ; Collision detected
    diagnostics,                                 ; Diagnostic data
    driver_behavior,                             ; Driving behavior event
    geofence,                                    ; Geofence event
    heartbeat,                                   ; Regular heartbeat
    idle,                                        ; Idle event
    ignition,                                    ; Ignition on/off
    location,                                    ; Location update
    maintenance,                                 ; Maintenance alert
    power,                                       ; Power event
    speeding                                     ; Speed event
)

; Location
{.location}
latitude = #:(-90..90)                           ; GPS latitude
longitude = #:(-180..180)                        ; GPS longitude
altitude_ft = ##                                 ; Altitude (feet)
heading = ##:(0..360)                            ; Heading (degrees)
accuracy_m = ##:(0..)                            ; GPS accuracy (meters)
address = :                                      ; Reverse geocoded address
city = :                                         ; City
state = :(2)                                     ; State
zip = :                                          ; ZIP code

{@telematics_event}

; Vehicle data
{.vehicle_data}
odometer = ##:(0..)                              ; Odometer reading
speed_mph = ##:(0..200)                          ; Speed (mph)
engine_rpm = ##:(0..10000)                       ; Engine RPM
fuel_level_percent = ##:(0..100)                 ; Fuel level %
engine_hours = #:(0..)                           ; Engine hours
coolant_temp_f = ##:(-40..300)                   ; Coolant temp
oil_pressure_psi = ##:(0..100)                   ; Oil pressure
battery_voltage = #:(0..30)                      ; Battery voltage
fuel_rate_gph = #:(0..50)                        ; Fuel rate (gal/hr)

{@telematics_event}

; Driver behavior
{.behavior}
hard_brake = ?                                   ; Hard brake detected
hard_acceleration = ?                            ; Hard accel detected
harsh_cornering = ?                              ; Harsh cornering
speeding = ?                                     ; Over speed limit
speed_over_limit_mph = ##:(0..)                  ; MPH over limit
seatbelt_unbuckled = ?                           ; Seatbelt not used
phone_usage = ?                                  ; Phone usage detected
fatigue_alert = ?                                ; Fatigue detected

{@telematics_event}

; Geofence
{.geofence}
geofence_id = ::if event_type = geofence         ; Geofence ID
geofence_name = ::if event_type = geofence       ; Geofence name
geofence_action = (enter, exit):if event_type = geofence
time_in_geofence = ##::if geofence_action = exit ; Minutes in zone

{@telematics_event}

; Ignition
{.ignition}
ignition_status = (off, on):if event_type = ignition
trip_started = timestamp:if ignition_status = on
trip_ended = timestamp:if ignition_status = off
trip_miles = #:(0..):if ignition_status = off
trip_minutes = ##:(0..):if ignition_status = off
idle_minutes = ##:(0..):if ignition_status = off

{@telematics_event}

; Diagnostics
{.diagnostics}
dtc_count = ##:(0..):if event_type = diagnostics ; DTC count
dtc_codes[] = ::if event_type = diagnostics      ; DTC codes
mil_status = (off, on):if event_type = diagnostics

{@telematics_event}

; ===================================================================================
; FUEL TRANSACTION
; ===================================================================================
; Fuel purchase and consumption tracking.

{@fuel_transaction}
; Required fields first
transaction_id = :                              ; Transaction ID
vehicle_id = :                                  ; Vehicle identifier
transaction_date = date                         ; Transaction date
transaction_time = time                          ; Transaction time

; Fuel details
{.fuel}
fuel_type = (
    bio_diesel,
    diesel,
    e85,
    electric,                                    ; EV charging
    gasoline_87,
    gasoline_89,
    gasoline_91,
    gasoline_93,
    natural_gas,
    propane
)
quantity = #:(0..)                               ; Gallons/kWh
unit_price = #$:(0..)                            ; Price per unit
total_price = #$:(0..)                           ; Total price

{@fuel_transaction}

; Location
{.location}
merchant_name = :                                ; Merchant name
merchant_id = :                                  ; Merchant ID
address = @address                               ; Location address
city = :                                         ; City
state = :(2)                                     ; State
zip = :                                          ; ZIP

{@fuel_transaction}

; Vehicle at fill-up
{.vehicle}
odometer = ##:(0..)                              ; Odometer at fill
driver_id = :                                    ; Driver ID
unit_number = :                                  ; Unit number
vin = *:format vin                               ; VIN

{@fuel_transaction}

; Fuel card
{.card}
card_type = (comdata, fleet_one, fuelman, pft, shell, wex, wright_express)
card_number = *:                                 ; Card number (confidential)
card_restriction = ?                             ; Transaction restricted
restriction_code = ::if card_restriction = true

{@fuel_transaction}

; Efficiency
{.efficiency}
miles_since_last_fill = ##:(0..)                 ; Miles since last fill
mpg_calculated = #:(0..100)                      ; Calculated MPG
mpg_expected = #:(0..100)                        ; Expected MPG
variance_percent = #:(-50..50)                   ; MPG variance %

{@fuel_transaction}

; Exceptions
{.exceptions}
fuel_type_mismatch = ?                           ; Wrong fuel type
quantity_exception = ?                           ; Unusual quantity
location_exception = ?                           ; Unusual location
time_exception = ?                               ; Unusual time
price_exception = ?                              ; Unusual price
exception_cleared = ?                            ; Exception cleared
exception_notes = :                              ; Exception notes

{@fuel_transaction}

; ===================================================================================
; TOLL TRANSACTION
; ===================================================================================
; Toll charges and transponder transactions.

{@toll_transaction}
; Required fields first
transaction_id = :                              ; Transaction ID
vehicle_id = :                                  ; Vehicle identifier
transaction_datetime = timestamp                ; Transaction timestamp

; Toll details
{.toll}
toll_authority = :                               ; Toll authority name
toll_road = :                                    ; Toll road name
plaza_name = :                                   ; Plaza/exit name
plaza_id = :                                     ; Plaza ID
entry_plaza = :                                  ; Entry plaza
exit_plaza = :                                   ; Exit plaza

{@toll_transaction}

; Location
{.location}
state = :(2)                                     ; State
latitude = #:(-90..90)                           ; Latitude
longitude = #:(-180..180)                        ; Longitude

{@toll_transaction}

; Payment
{.payment}
toll_amount = #$:(0..)                           ; Toll amount
payment_type = (cash, invoice, transponder, violation)
transponder_id = :                               ; Transponder ID
transponder_type = (e_zpass, fastrak, geauxpass, good_to_go, i_pass, pike_pass, sun_pass, txtag)

{@toll_transaction}

; Vehicle at toll
{.vehicle}
axle_count = ##:(2..10)                          ; Axle count
vehicle_class = ##:(1..10)                       ; Toll class
occupancy = ##:(1..10)                           ; Occupancy (for HOV)
hov_lane = ?                                     ; HOV lane used

{@toll_transaction}

; ===================================================================================
; ACCIDENT REPORT
; ===================================================================================
; Fleet accident/incident report.

{@fleet_accident_report}
; Required fields first
report_id = :                                   ; Report identifier
vehicle_id = :                                  ; Vehicle involved
incident_datetime = timestamp                   ; Incident date/time
incident_type = (
    backing,
    collision_fixed_object,
    collision_moving_object,
    collision_pedestrian,
    hit_and_run,
    jackknife,
    rollover,
    sideswipe,
    vehicle_fire,
    weather_related
)

; Location
{.location}
address = :                                      ; Address/intersection
city = :                                         ; City
state = :(2)                                     ; State
latitude = #:(-90..90)                           ; Latitude
longitude = #:(-180..180)                        ; Longitude
highway = :                                      ; Highway/road name
mile_marker = #:(0..)                            ; Mile marker

{@fleet_accident_report}

; Driver
{.driver}
driver_id = :                                    ; Driver ID
driver_name = :                                  ; Driver name
driver_injury = ?                                ; Driver injured
injury_description = ::if driver_injury = true
driver_fault = ?                                 ; Driver at fault
seatbelt_worn = ?                                ; Seatbelt in use
drug_alcohol_test = ?                            ; D&A test required
test_result = (negative, pending, positive):if drug_alcohol_test = true

{@fleet_accident_report}

; Vehicle condition
{.vehicle}
vin = *:format vin                               ; VIN
unit_number = :                                  ; Unit number
odometer = ##:(0..)                              ; Odometer at incident
driveable = ?                                    ; Vehicle driveable
towed = ?                                        ; Vehicle towed
tow_destination = ::if towed = true              ; Tow destination
damage_estimate = #$:(0..)                       ; Damage estimate
total_loss = ?                                   ; Total loss

{@fleet_accident_report}

; Other party
{.other_party}
involved = ?                                     ; Other party involved
other_vehicle_count = ##:(0..)                   ; Other vehicles
other_vehicle_info = :                           ; Other vehicle description
other_party_name = :                             ; Other party name
other_party_phone = *@phone                      ; Other party phone
other_party_insurance = :                        ; Other party insurance
other_party_policy = *:                          ; Other policy number
other_party_injury = ?                           ; Other party injured

{@fleet_accident_report}

; Police
{.police}
police_called = ?                                ; Police called
police_report = ?                                ; Police report filed
report_number = :                                ; Report number
agency = :                                       ; Police agency
officer_name = :                                 ; Officer name
officer_badge = :                                ; Badge number
citation_issued = ?                              ; Citation issued
citation_to = (driver, other_party):if citation_issued = true
citation_violation = ::if citation_issued = true

{@fleet_accident_report}

; Witnesses
{.witnesses}
witness_count = ##:(0..)                         ; Number of witnesses
witnesses[] = :                                  ; Witness names
witness_statements = ?                           ; Statements obtained

{@fleet_accident_report}

; Documentation
{.documentation}
photos_taken = ?                                 ; Photos taken
photo_count = ##:(0..)                           ; Number of photos
dash_cam_footage = ?                             ; Dash cam available
diagram_prepared = ?                             ; Diagram prepared
supervisor_notified = ?                          ; Supervisor notified
notification_datetime = timestamp                ; Notification time

{@fleet_accident_report}

; Insurance claim
{.insurance}
claim_filed = ?                                  ; Claim filed
claim_number = *:                                ; Claim number
carrier = :                                      ; Insurance carrier
adjuster = :                                     ; Adjuster name
claim_status = (closed, open, pending, subrogation)
deductible = #$:(0..)                            ; Deductible
claim_paid = #$:(0..)                            ; Amount paid
subrogation_amount = #$:(0..)                    ; Subrogation recovered

{@fleet_accident_report}

; Investigation
{.investigation}
under_investigation = ?                          ; Under investigation
investigator = :                                 ; Investigator name
investigation_complete = ?                       ; Investigation complete
findings = :                                     ; Investigation findings
preventable = ?                                  ; Preventable accident
disciplinary_action = ?                          ; Discipline taken
action_taken = ::if disciplinary_action = true

{@fleet_accident_report}


; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Utilities/Energy - Renewable Energy Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Distributed energy resources and renewable generation including solar PV,
; battery storage, EV charging, net metering, virtual power plants, demand
; response, and renewable energy incentives.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.utilities.renewable"
version = "1.0.0"
title = "Renewable Energy and DER"
description = "Renewable energy systems and distributed energy resources for electric utilities"

{$derivation}
source[0].authority = "Institute of Electrical and Electronics Engineers"
source[0].citation = "IEEE 1547 Standard for Interconnecting Distributed Energy Resources"
source[0].url = "https://standards.ieee.org/standard/1547-2018.html"
source[0].accessed = 2025-12-21

source[1].authority = "Federal Energy Regulatory Commission"
source[1].citation = "FERC Order 2222 - Participation of DER Aggregations"
source[1].url = "https://www.ferc.gov/media/order-no-2222"
source[1].accessed = 2025-12-21

source[2].authority = "North American Electric Reliability Corporation"
source[2].citation = "NERC Reliability Standards for DER"
source[2].url = "https://www.nerc.com/"
source[2].accessed = 2025-12-21

source[3].authority = "Interstate Renewable Energy Council"
source[3].citation = "Model Interconnection Procedures"
source[3].url = "https://irecusa.org/"
source[3].accessed = 2025-12-21

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial renewable energy and DER schema"
changelog[0].rationale = "Standard DER and renewable structures per IEEE 1547 and FERC requirements"

; ═══════════════════════════════════════════════════════════════════════════════
; SOLAR PHOTOVOLTAIC SYSTEM
; ═══════════════════════════════════════════════════════════════════════════════

{@solar_system}
= @types.audit_info

; Required fields first
system_id = !:                                     ; Unique system identifier
account_number = !*:                                ; Associated account
installation_type = (commercial, industrial, residential)
system_status = (active, decommissioned, inactive, pending, under_construction)

; System specifications
rated_capacity_kw = !#:(0..)                       ; System rated capacity in kW DC
module_count = ##:(1..)                            ; Number of solar modules
module_manufacturer = :                            ; Panel manufacturer
module_model = :                                   ; Panel model
module_wattage = #:(0..)                           ; Per-module wattage
module_technology = (monocrystalline, polycrystalline, thin_film)

; Inverter information
{.inverters[]}
inverter_id = !:                                   ; Inverter identifier
manufacturer = :                                   ; Inverter manufacturer
model = :                                          ; Inverter model
rated_capacity_kw = #:(0..)                        ; Inverter rating in kW AC
efficiency_percent = #:(0..100)                    ; Conversion efficiency
inverter_type = (central, micro, string)           ; Inverter type
installed_date = date                              ; Installation date
serial_number = :                                  ; Serial number

{@solar_system}
; Installation details
install_date = date                                ; System installation date
commissioned_date = date                           ; Permission to operate date
installer = :                                      ; Installation company
installer_license = :                              ; Installer license number

; Location
service_address = @address                         ; Installation address
array_location = (carport, ground_mount, rooftop)  ; Array mounting location
azimuth_degrees = #:(0..360)                       ; Panel azimuth (0=North)
tilt_degrees = #:(0..90)                           ; Panel tilt angle

; Interconnection
interconnection_agreement = :                      ; Agreement number
interconnection_date = date                        ; Interconnection date
net_metering = !?                                  ; Net metering enrolled
net_metering_rate = :                              ; Rate schedule for NEM
export_limit_kw = #:(0..)                          ; Export limit if applicable
bidirectional_meter = ?                            ; Bi-directional metering

; Performance
{.performance}
annual_production_kwh = #:(0..)                    ; Annual production estimate
capacity_factor = #:(0..100)                       ; Capacity factor percentage
degradation_rate = #:(0..10)                       ; Annual degradation %

{@solar_system}
; Production metering
production_meter_number = :                        ; Production meter ID
inverter_monitoring = ?                            ; Inverter-level monitoring
monitoring_platform = :                            ; Monitoring system used
monitoring_url = :                                 ; Portal URL

; Warranties
module_warranty_years = ##:(0..)                   ; Module warranty term
inverter_warranty_years = ##:(0..)                 ; Inverter warranty term
performance_warranty_years = ##:(0..)              ; Performance warranty term
workmanship_warranty_years = ##:(0..)              ; Installation warranty term

; Incentives received
{.incentives[]}
incentive_type = (grant, irc, performance, rebate, srec, tax_credit)
program_name = :                                   ; Program name
amount = #$:(0..)                                  ; Incentive amount
received_date = date                               ; Date received
expiration_date = date                             ; Expiration if applicable

{@solar_system}
; Maintenance
last_maintenance_date = date                       ; Last maintenance
next_maintenance_due = date                        ; Next maintenance due
maintenance_contract = ?                           ; Maintenance contract active
maintenance_provider = :                           ; Service provider

{@solar_system}

; ═══════════════════════════════════════════════════════════════════════════════
; BATTERY ENERGY STORAGE SYSTEM (BESS)
; ═══════════════════════════════════════════════════════════════════════════════

{@battery_storage}
= @types.audit_info

; Required fields first
system_id = !:                                     ; Unique system identifier
account_number = !*:                                ; Associated account
system_status = (active, decommissioned, inactive, pending, standby)

; System specifications
rated_capacity_kwh = !#:(0..)                      ; Energy capacity in kWh
rated_power_kw = !#:(0..)                          ; Power rating in kW
usable_capacity_kwh = #:(0..)                      ; Usable capacity
chemistry = (flow_battery, lead_acid, lithium_ion, nickel, other)
chemistry_details = :                              ; Specific chemistry variant

; Battery modules
{.modules[]}
module_id = !:                                     ; Module identifier
manufacturer = :                                   ; Battery manufacturer
model = :                                          ; Battery model
capacity_kwh = #:(0..)                             ; Module capacity
serial_number = :                                  ; Serial number
installed_date = date                              ; Installation date

{@battery_storage}
; Inverter/converter
inverter_manufacturer = :                          ; Inverter manufacturer
inverter_model = :                                 ; Inverter model
inverter_rating_kw = #:(0..)                       ; Inverter power rating
round_trip_efficiency = #:(0..100)                 ; Round-trip efficiency %

; Installation
install_date = date                                ; Installation date
commissioned_date = date                           ; Commissioning date
installer = :                                      ; Installation company
location = (exterior, garage, interior, utility_room)

; Operating parameters
min_state_of_charge = #:(0..100)                   ; Min SOC %
max_state_of_charge = #:(0..100)                   ; Max SOC %
depth_of_discharge = #:(0..100)                    ; Usable DOD %
cycle_life_rating = ##:(0..)                       ; Rated cycle life

; Interconnection
interconnection_agreement = :                      ; Agreement number
grid_connected = !?                                ; Grid connection status
islanding_capable = ?                              ; Can operate off-grid
backup_capable = ?                                 ; Backup power capability

; Operating modes
{.operating_modes}
self_consumption = ?                               ; Self-consumption mode
time_of_use_arbitrage = ?                          ; TOU arbitrage mode
demand_charge_reduction = ?                        ; Peak shaving mode
backup_power = ?                                   ; Backup/resilience mode
grid_services = ?                                  ; Grid services participation
vpp_enrolled = ?                                   ; Virtual power plant enrollment

{@battery_storage}
; Performance monitoring
current_state_of_charge = #:(0..100)               ; Current SOC %
current_power_kw = #                               ; Current power (+ charge, - discharge)
cycles_completed = ##:(0..)                        ; Lifetime cycles
state_of_health = #:(0..100)                       ; Battery health %
capacity_remaining = #:(0..)                       ; Remaining capacity kWh

; Warranties
battery_warranty_years = ##:(0..)                  ; Battery warranty term
inverter_warranty_years = ##:(0..)                 ; Inverter warranty term
performance_warranty_years = ##:(0..)              ; Performance warranty
throughput_warranty_kwh = #:(0..)                  ; Throughput guarantee

{@battery_storage}

; ═══════════════════════════════════════════════════════════════════════════════
; ELECTRIC VEHICLE CHARGER
; ═══════════════════════════════════════════════════════════════════════════════

{@ev_charger}
= @types.audit_info

; Required fields first
charger_id = !:                                    ; Unique charger identifier
account_number = !*:                                ; Associated account
charger_level = (level_1, level_2, level_3_dcfc)  ; Charging level
status = (active, available, charging, faulted, inactive, offline)

; Charger specifications
manufacturer = :                                   ; Charger manufacturer
model = :                                          ; Charger model
serial_number = :                                  ; Serial number
max_power_kw = #:(0..)                             ; Maximum power output
voltage = #:(0..)                                  ; Operating voltage
amperage = #:(0..)                                 ; Maximum amperage
connector_type = (ccs, chademo, j1772, nacs, tesla)

; Installation
install_date = date                                ; Installation date
installer = :                                      ; Installation company
location = (exterior, garage, parking_lot, public, workplace)
service_address = @address                         ; Installation address

; Network and control
networked = ?                                      ; Network-connected charger
network_provider = :                               ; Network operator
remote_start_stop = ?                              ; Remote control capability
load_management = ?                                ; Load management enabled
smart_charging = ?                                 ; Smart charging capable

; Access control
access_type = (open_public, private, restricted)   ; Access level
authentication = (app, credit_card, open, rfid)    ; Authentication method
pricing_model = (free, per_kwh, per_minute, subscription)

; Metering
dedicated_meter = ?                                ; Dedicated meter installed
meter_number = :                                   ; Meter identifier
submeter_id = :                                    ; Submeter if applicable

; Rate programs
managed_charging_enrolled = ?                      ; Managed charging program
time_of_use_rate = :                               ; TOU rate schedule
ev_rate_schedule = :                               ; EV-specific rate

; Usage tracking
{.usage}
total_sessions = ##:(0..)                          ; Lifetime sessions
total_energy_kwh = #:(0..)                         ; Lifetime energy delivered
average_session_kwh = #:(0..)                      ; Average per session
utilization_percent = #:(0..100)                   ; Charger utilization

{@ev_charger}
; Incentives
{.incentives[]}
incentive_type = (grant, rebate, tax_credit, utility_incentive)
program_name = :                                   ; Program name
amount = #$:(0..)                                  ; Incentive amount
received_date = date                               ; Date received

{@ev_charger}
; Maintenance
last_maintenance_date = date                       ; Last service date
next_maintenance_due = date                        ; Next service due
warranty_expiration = date                         ; Warranty end date

{@ev_charger}

; ═══════════════════════════════════════════════════════════════════════════════
; DISTRIBUTED ENERGY RESOURCE (DER)
; ═══════════════════════════════════════════════════════════════════════════════

{@der}
= @types.audit_info

; Required fields first
der_id = !:                                        ; Unique DER identifier
account_number = !*:                                ; Associated account
resource_type = (battery_storage, ev_charger, generator, solar, wind)
status = (active, decommissioned, inactive, pending, testing)

; Capacity
rated_capacity_kw = !#:(0..)                       ; Rated capacity in kW
rated_capacity_kva = #:(0..)                       ; Rated capacity in kVA
energy_capacity_kwh = #:(0..)                      ; Energy capacity (storage)

; Interconnection
interconnection_agreement = :                      ; Agreement number
interconnection_date = date                        ; Interconnection date
point_of_interconnection = :                       ; POI identifier
voltage_level = (distribution, subtransmission, transmission)
voltage_kv = #:(0..)                               ; Interconnection voltage

; IEEE 1547 compliance
ieee_1547_certified = ?                            ; 1547 compliant
certification_date = date                          ; Certification date
revision = (ieee_1547_2003, ieee_1547_2018)        ; Standard revision

; Grid support capabilities
{.capabilities}
volt_var_support = ?                               ; Volt-VAR support
frequency_response = ?                             ; Frequency response
voltage_regulation = ?                             ; Voltage regulation
ride_through = ?                                   ; Fault ride-through
islanding_prevention = ?                           ; Anti-islanding
black_start = ?                                    ; Black start capability

{@der}
; Control and monitoring
der_management_system = :                          ; DMS integration
scada_monitored = ?                                ; SCADA monitoring
telemetry_interval_seconds = ##:(1..)              ; Data reporting interval
remote_control_enabled = ?                         ; Remote control access

; Grid services participation
{.grid_services}
frequency_regulation = ?                           ; Frequency regulation market
spinning_reserve = ?                               ; Spinning reserve
non_spinning_reserve = ?                           ; Non-spinning reserve
demand_response = ?                                ; Demand response programs
energy_arbitrage = ?                               ; Energy market participation

{@der}
; Aggregation
aggregator = :                                     ; Aggregator name
vpp_id = :                                         ; Virtual power plant ID
aggregation_agreement = :                          ; Agreement reference

{@der}

; ═══════════════════════════════════════════════════════════════════════════════
; NET METERING AGREEMENT
; ═══════════════════════════════════════════════════════════════════════════════

{@net_metering}
; Required fields first
agreement_number = !:                              ; Agreement identifier
account_number = !*:                                ; Account number
system_id = :                                      ; Associated DER system
status = (active, cancelled, expired, pending)

; Agreement terms
effective_date = !date                             ; Agreement start
expiration_date = date                             ; Agreement end
rate_schedule = :                                  ; NEM rate schedule
program_type = (net_billing, net_metering, nem_2, nem_3)

; System details
system_capacity_kw = #:(0..)                       ; System capacity
export_limit_kw = #:(0..)                          ; Export limit
technology_type = (battery, solar, wind)           ; Technology

; Metering
production_meter = :                               ; Production meter
net_meter = :                                      ; Net meter number
bidirectional = !?                                 ; Bi-directional metering

; Compensation
{.compensation}
export_rate = #$                                   ; Export compensation rate
excess_compensation_method = (annual_true_up, credit_rollover, monthly_payout)
netting_period = (annual, billing, instantaneous, monthly)
credit_carryover_months = ##:(0..12)               ; Credit rollover period

{@net_metering}
; Banking and credits
current_credit_balance = #$                        ; Current credit balance
current_credit_kwh = #:(0..)                       ; Current kWh credit
annual_true_up_date = date                         ; True-up date
true_up_payment = #$                               ; True-up amount

{@net_metering}

; ═══════════════════════════════════════════════════════════════════════════════
; DEMAND RESPONSE PROGRAM
; ═══════════════════════════════════════════════════════════════════════════════

{@demand_response}
; Required fields first
program_id = !:                                    ; Program identifier
program_name = !:                                  ; Program name
account_number = !*:                                ; Account number
enrollment_status = (active, cancelled, enrolled, pending, suspended)

; Program details
program_type = (automated, direct_load_control, manual, pricing_based)
targeted_resource = (air_conditioning, battery, electric_vehicle, heating, pool_pump, water_heater)
event_type = (critical_peak, demand_bidding, emergency, peak_time_rebate, scheduled)

; Enrollment
enrolled_date = date                               ; Enrollment date
effective_date = date                              ; Program effective date
term_months = ##:(1..)                             ; Program term
auto_renew = ?                                     ; Auto-renewal flag

; Capacity enrolled
enrolled_kw = #:(0..)                              ; Enrolled load reduction
committed_kw = #:(0..)                             ; Committed reduction
tested_kw = #:(0..)                                ; Tested capability

; Event parameters
max_events_per_year = ##:(0..)                     ; Maximum events
max_event_duration_hours = #:(0..)                 ; Maximum duration
advance_notice_hours = #:(0..)                     ; Notice period
opt_out_allowed = ?                                ; Opt-out permitted
opt_outs_remaining = ##:(0..)                      ; Remaining opt-outs

; Compensation
{.compensation}
enrollment_incentive = #$:(0..)                    ; Upfront incentive
capacity_payment_per_kw = #$:(0..)                 ; Annual capacity payment
performance_payment_per_kwh = #$:(0..)             ; Per-event payment
total_incentives_earned = #$:(0..)                 ; Total earned to date

{@demand_response}
; Event history
{.events[]}
event_id = !:                                      ; Event identifier
event_date = !date                                 ; Event date
notification_time = timestamp                      ; Notification timestamp
start_time = !timestamp                            ; Event start
end_time = !timestamp                              ; Event end
duration_hours = #:(0..)                           ; Event duration
target_reduction_kw = #:(0..)                      ; Reduction target
actual_reduction_kw = #:(0..)                      ; Actual reduction
baseline_kw = #:(0..)                              ; Baseline load
participation = (full, none, partial)              ; Participation level
opted_out = ?                                      ; Customer opted out
payment = #$:(0..)                                 ; Event payment

{@demand_response}
; Performance
{.performance}
events_participated = ##:(0..)                     ; Events participated
events_opted_out = ##:(0..)                        ; Events opted out
participation_rate = #:(0..100)                    ; Participation %
average_reduction_kw = #:(0..)                     ; Average reduction
total_kwh_reduced = #:(0..)                        ; Lifetime reduction

{@demand_response}

; ═══════════════════════════════════════════════════════════════════════════════
; RENEWABLE ENERGY INCENTIVE
; ═══════════════════════════════════════════════════════════════════════════════

{@renewable_incentive}
; Required fields first
incentive_id = !:                                  ; Incentive identifier
account_number = !*:                                ; Account number
system_id = :                                      ; Associated system
program_name = !:                                  ; Program name
incentive_type = (capacity_based, grant, performance_based, rebate, tax_credit)

; Application
application_date = date                            ; Application submitted
application_status = (approved, denied, paid, pending, processing)
approval_date = date                               ; Approval date
approved_amount = #$:(0..)                         ; Approved incentive

; System details
system_capacity_kw = #:(0..)                       ; System capacity
technology = (battery, ev_charger, solar, wind)    ; Technology type

; Payment terms
payment_method = (lump_sum, per_kwh, per_kw, quarterly)
payment_term_years = ##:(0..)                      ; Payment term
payment_per_kwh = #$:(0..)                         ; Per-kWh rate
payment_per_kw = #$:(0..)                          ; Per-kW rate

; Requirements
{.requirements}
preapproval_required = ?                           ; Preapproval needed
inspection_required = ?                            ; Inspection needed
inspection_date = date                             ; Inspection performed
certification_required = ?                         ; Certification needed
certification_date = date                          ; Certification date

{@renewable_incentive}
; Payments
{.payments[]}
payment_date = !date                               ; Payment date
payment_amount = !#$:(0..)                         ; Payment amount
period_start = date                                ; Period start
period_end = date                                  ; Period end
production_kwh = #:(0..)                           ; Production basis

{@renewable_incentive}
; Totals
total_paid = #$:(0..)                              ; Total paid to date
total_remaining = #$:(0..)                         ; Remaining balance
final_payment_date = date                          ; Final payment date

{@renewable_incentive}

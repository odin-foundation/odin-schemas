; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Utilities/Energy - Meter Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Utility meter devices, readings, events, and exchanges for electric, gas,
; and water meters including AMI/AMR smart metering, interval data, and
; demand readings.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.utilities.meter"
version = "1.0.0"
title = "Utility Meter and Readings"
description = "Meter device and reading schema for electric, gas, and water utilities"

{$derivation}
source[0].authority = "American National Standards Institute"
source[0].citation = "ANSI C12.1 Code for Electricity Metering"
source[0].url = "https://www.ansi.org/"
source[0].accessed = 2025-12-21

source[1].authority = "American National Standards Institute"
source[1].citation = "ANSI C12.19 Utility Industry End Device Data Tables"
source[1].url = "https://www.ansi.org/"
source[1].accessed = 2025-12-21

source[2].authority = "North American Energy Standards Board"
source[2].citation = "NAESB WEQ-015 Meter Information"
source[2].url = "https://www.naesb.org/"
source[2].accessed = 2025-12-21

source[3].authority = "International Electrotechnical Commission"
source[3].citation = "IEC 62056 Electricity Metering Data Exchange"
source[3].url = "https://www.iec.ch/"
source[3].accessed = 2025-12-21

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial utilities meter schema"
changelog[0].rationale = "Standard meter and reading structures per ANSI C12 and NAESB requirements"

; ═══════════════════════════════════════════════════════════════════════════════
; METER DEVICE
; ═══════════════════════════════════════════════════════════════════════════════

{@meter}
= @types.audit_info

; Required fields first
meter_number = :                                  ; Unique meter identifier
meter_type = (electric, gas, water)               ; Meter commodity type
status = (active, inactive, removed, stock, testing)

; Optional fields
manufacturer = :                                   ; Meter manufacturer
model = :                                          ; Meter model number
serial_number = :                                  ; Factory serial number
form_number = :                                    ; Meter form designation
base_type = :                                      ; Meter base type
class = :                                          ; Accuracy class
technology = (ami, amr, encoder, mechanical, pulse, solid_state)

; Installation details
install_date = date                                ; Installation date
install_location = :                               ; Specific location description
removal_date = date                                ; Removal date
location_type = (basement, exterior, interior, pole, vault)

; Meter characteristics
voltage = #:(0..)                                  ; Rated voltage
amperage = #:(0..)                                 ; Rated amperage
phases = ##:(1..3)                                 ; Number of phases
wires = ##:(2..4)                                  ; Number of wires
test_amps = #:(0..)                                ; Test amperage
dial_constant = #                                  ; Meter constant (Kh)
multiplier = #:(0..)                               ; Billing multiplier

; Smart meter capabilities
ami_enabled = ?                                    ; Advanced metering infrastructure
remote_connect_disconnect = ?                      ; Remote switching capability
tamper_detection = ?                               ; Tamper detection feature
outage_detection = ?                               ; Outage detection capability
voltage_monitoring = ?                             ; Voltage monitoring feature
load_profile = ?                                   ; Interval data recording

; Communication
communication_type = (cellular, mesh, plc, pylon, rf)
communication_id = :                               ; Communication module ID
last_communication = timestamp                     ; Last successful communication

; Meter condition
condition = (calibrated, excellent, fair, good, poor)
accuracy_percent = #:(0..100)                      ; Accuracy percentage
last_test_date = date                              ; Last accuracy test date
next_test_due = date                               ; Next test due date
test_required = ?                                  ; Test required flag

; Seals
seal_number = :                                    ; Primary seal number
seal_installed_date = date                         ; Seal installation date
seal_broken = ?                                    ; Seal broken indicator
seal_broken_date = date                            ; Date seal was broken

; Service point
service_point_id = :                               ; Service point identifier
account_number = *:                                 ; Associated account number
premise_id = :                                     ; Associated premise ID

; GPS location
latitude = #:(-90..90)                             ; Meter latitude
longitude = #:(-180..180)                          ; Meter longitude

{@meter}

; ═══════════════════════════════════════════════════════════════════════════════
; METER REGISTERS
; ═══════════════════════════════════════════════════════════════════════════════

{@meter.registers[]}
register_number = ##:(0..)                        ; Register index (0, 1, 2, etc.)
register_type = (consumption, demand, energy, reactive)
uom = (ccf, gallons, kva, kvar, kvah, kvarh, kw, kwh, mcf, therms)
multiplier = #:(0..)                               ; Register multiplier
digits = ##:(4..10)                                ; Number of dial digits
decimals = ##:(0..3)                               ; Decimal places
max_value = #:(0..)                                ; Maximum register value
rollover_value = #:(0..)                           ; Rollover threshold
time_of_use_period = :                             ; TOU period if applicable
description = :                                    ; Register description

{@meter}

; ═══════════════════════════════════════════════════════════════════════════════
; METER READING
; ═══════════════════════════════════════════════════════════════════════════════

{@meter_reading}
= @types.audit_info

; Required fields first
meter_number = :                                  ; Meter identifier
read_date = date                                  ; Reading date
read_type = (actual, customer, estimated, off_cycle, scheduled, special)

; Optional fields
read_time = time                                   ; Specific reading time
read_timestamp = timestamp                         ; Full timestamp
read_sequence = ##                                 ; Reading sequence number

; Reading source
read_source = (ami, amr, handheld, manual, remote, web_portal)
reader_id = :                                      ; Person/device that took reading
read_method = (drive_by, on_site, remote, self_reported)

; Reading values (by register)
{.registers[]}
register_number = ##:(0..)                        ; Register index
reading = #:(0..)                                 ; Register reading value
uom = (ccf, gallons, kva, kvar, kvah, kvarh, kw, kwh, mcf, therms)
previous_reading = #:(0..)                         ; Prior reading value
consumption = #:(0..)                              ; Calculated consumption
multiplier = #:(0..)                               ; Applied multiplier
rollover_occurred = ?                              ; Rollover indicator

{@meter_reading}
; Reading quality
quality_code = :                                   ; Quality code
quality_description = :                            ; Quality description
estimated_reason = :                               ; Reason if estimated
verified = ?                                       ; Verification flag
verified_by = :                                    ; Who verified
verified_date = timestamp                          ; Verification timestamp

; Reading exceptions
exception_code = :                                 ; Exception code if any
exception_description = :                          ; Exception details
tamper_detected = ?                                ; Tamper flag
removal_detected = ?                               ; Removal flag
reverse_flow_detected = ?                          ; Reverse flow indicator

; Demand readings (electric)
demand_kw = #:(0..)                                ; Demand in kW
demand_timestamp = timestamp                       ; When demand occurred
demand_reset_date = date                           ; Last demand reset

; Temperature compensation (gas)
temperature_f = #:(-50..150)                       ; Temperature in Fahrenheit
pressure_psig = #:(0..)                            ; Pressure in PSIG
uncorrected_volume = #:(0..)                       ; Uncorrected volume
correction_factor = #:(0..)                        ; Applied correction factor

; Images
meter_image_url = :                                ; Photo of meter
dial_image_url = :                                 ; Photo of dials/display

{@meter_reading}

; ═══════════════════════════════════════════════════════════════════════════════
; INTERVAL DATA
; ═══════════════════════════════════════════════════════════════════════════════

{@interval_data}
; Required fields first
meter_number = :                                  ; Meter identifier
interval_length = ##:(1..)                        ; Interval length in minutes
start_timestamp = timestamp                       ; Interval start time
end_timestamp = timestamp                         ; Interval end time

; Interval values
consumption = #:(0..)                              ; Consumption for interval
demand = #:(0..)                                   ; Demand for interval
uom = (ccf, gallons, kva, kvar, kvah, kvarh, kw, kwh, mcf, therms)

; Data quality
quality = (actual, estimated, missing, questionable, verified)
quality_code = :                                   ; Detailed quality code
estimation_method = :                              ; Method used if estimated
flags = :                                          ; Any data flags

; Power quality (electric)
voltage_avg = #:(0..)                              ; Average voltage
voltage_min = #:(0..)                              ; Minimum voltage
voltage_max = #:(0..)                              ; Maximum voltage
power_factor = #:(-1..1)                           ; Power factor

; Events during interval
outage_occurred = ?                                ; Outage during interval
tamper_detected = ?                                ; Tamper during interval

{@meter_reading}

; ═══════════════════════════════════════════════════════════════════════════════
; METER EVENT
; ═══════════════════════════════════════════════════════════════════════════════

{@meter.events[]}
event_type = (alarm, communication, demand_reset, disconnect, error, outage, reconnect, tamper, test)
event_code = :                                     ; Specific event code
severity = (critical, high, informational, low, medium)
event_timestamp = timestamp                       ; When event occurred
reported_timestamp = timestamp                     ; When event was reported
cleared = ?                                        ; Event cleared flag
cleared_timestamp = timestamp                      ; When cleared
description = :                                    ; Event description
meter_reading = #:(0..)                            ; Meter reading at event
register_number = ##                               ; Register if applicable

{@meter}

; ═══════════════════════════════════════════════════════════════════════════════
; METER EXCHANGE
; ═══════════════════════════════════════════════════════════════════════════════

{@meter_exchange}
; Required fields first
exchange_date = date                              ; Exchange date
exchange_reason = (accuracy, damage, failure, periodic_test, upgrade)

; Old meter
old_meter_number = :                              ; Removed meter number
old_final_reading = #:(0..)                        ; Final reading from old meter
old_read_date = date                               ; Date of final reading
old_condition = :                                  ; Condition at removal

; New meter
new_meter_number = :                              ; Installed meter number
new_initial_reading = #:(0..)                      ; Initial reading of new meter
new_read_date = date                               ; Date of initial reading
new_install_date = date                            ; Installation date

; Exchange details
performed_by = :                                   ; Technician who performed
work_order = :                                     ; Related work order number
account_number = *:                                 ; Account number
service_point_id = :                               ; Service point
notes = :                                          ; Exchange notes

; Testing
test_required = ?                                  ; Test required flag
test_date = date                                   ; Test date
test_result = (failed, passed, pending)            ; Test result
test_performed_by = :                              ; Who tested
as_found_accuracy = #:(0..100)                     ; Accuracy before adjustment
as_left_accuracy = #:(0..100)                      ; Accuracy after adjustment

{@meter_exchange}

; ═══════════════════════════════════════════════════════════════════════════════
; METER TEST
; ═══════════════════════════════════════════════════════════════════════════════

{@meter_test}
; Required fields first
meter_number = :                                  ; Meter being tested
test_date = date                                  ; Test date
test_type = (accuracy, bench, field, periodic, special)
test_result = (failed, passed, pending)           ; Overall result

; Test details
test_standard = :                                  ; Standard used (ANSI C12.1, etc.)
test_performed_by = :                              ; Technician
test_facility = :                                  ; Where tested
test_equipment = :                                 ; Test equipment used

; Accuracy results
as_found_accuracy_light = #:(0..100)               ; Light load accuracy
as_found_accuracy_full = #:(0..100)                ; Full load accuracy
as_left_accuracy_light = #:(0..100)                ; Light load after adjustment
as_left_accuracy_full = #:(0..100)                 ; Full load after adjustment
tolerance_percent = #:(0..100)                     ; Acceptable tolerance

; Test conditions
temperature_f = #:(-50..150)                       ; Test temperature
voltage = #:(0..)                                  ; Test voltage
amperage = #:(0..)                                 ; Test amperage

; Disposition
disposition = (adjust_and_return, calibrate, repair, retire, return_to_stock)
calibration_date = date                            ; Calibration date
next_test_due = date                               ; Next test due
notes = :                                          ; Test notes

{@meter_test}

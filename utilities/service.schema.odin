; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Utilities/Energy - Service Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Service requests, work orders, and outage management for utilities including
; connect/disconnect, meter installations, outage restoration, investigations,
; and customer complaints.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.utilities.service"
version = "1.0.0"
title = "Utility Service Requests and Work Orders"
description = "Service request, work order, and outage schema for electric, gas, and water utilities"

{$derivation}
source[0].authority = "North American Energy Standards Board"
source[0].citation = "NAESB WEQ-016 Work Management"
source[0].url = "https://www.naesb.org/"
source[0].accessed = 2025-12-21

source[1].authority = "North American Electric Reliability Corporation"
source[1].citation = "NERC EOP-004 Event Reporting"
source[1].url = "https://www.nerc.com/pa/Stand/Pages/ReliabilityStandards.aspx"
source[1].accessed = 2025-12-21

source[2].authority = "Edison Electric Institute"
source[2].citation = "Outage Management System Best Practices"
source[2].url = "https://www.eei.org/"
source[2].accessed = 2025-12-21

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial utilities service schema"
changelog[0].rationale = "Standard service request and work order structures per NAESB and NERC requirements"

; ═══════════════════════════════════════════════════════════════════════════════
; SERVICE REQUEST
; ═══════════════════════════════════════════════════════════════════════════════

{@service_request}
= @types.audit_info

; Required fields first
request_number = :                                ; Unique request identifier
request_type = (connect, disconnect, investigation, meter_exchange, start, stop, transfer)
request_date = timestamp                          ; Request submission timestamp
status = (cancelled, completed, in_progress, pending, scheduled)

; Account and service information
account_number = *:                                 ; Account number
customer_name = :                                  ; Customer name
service_address = @address                         ; Service location

; Requested service date
requested_date = date                              ; Requested service date
requested_time = time                              ; Requested time window
scheduled_date = date                              ; Scheduled date
scheduled_time_start = time                        ; Scheduled window start
scheduled_time_end = time                          ; Scheduled window end

; Service type details
{.start_service}
move_in_date = date:if request_type = start        ; Move-in date
landlord_authorization = ?:if request_type = start ; Landlord auth received
deposit_required = ?:if request_type = start       ; Deposit required
deposit_amount = #$:(0..):if request_type = start  ; Deposit amount

{@service_request}
{.stop_service}
move_out_date = date:if request_type = stop        ; Move-out date
final_bill_address = @address:if request_type = stop
forwarding_address = @address:if request_type = stop
refund_requested = ?:if request_type = stop        ; Deposit refund requested

{@service_request}
{.transfer_service}
transfer_from_account = :if request_type = transfer
transfer_to_account = :if request_type = transfer
transfer_date = date:if request_type = transfer

{@service_request}
; Contact information
contact_name = @person_name                        ; Contact person
contact_phone = *@phone                            ; Contact phone
contact_email = *@email                            ; Contact email
preferred_contact_method = (email, phone, sms)     ; Contact preference

; Special instructions
special_instructions = :                           ; Special instructions
access_instructions = :                            ; Site access notes
gate_code = *:                                     ; Gate code if needed
hazards = :                                        ; Hazards or warnings

; Priority
priority = (emergency, high, routine, urgent)      ; Request priority
expedite_requested = ?                             ; Expedite flag
expedite_reason = :                                ; Reason for expedite

; Assignment
assigned_to = :                                    ; Assigned technician/crew
assigned_date = timestamp                          ; Assignment timestamp
work_order_number = :                              ; Generated work order

; Completion
completed_date = timestamp                         ; Completion timestamp
completed_by = :                                   ; Technician who completed
completion_notes = :                               ; Completion notes
customer_signature = ?                             ; Customer signature obtained

; Cancellation
cancelled_date = timestamp                         ; Cancellation timestamp
cancel_reason = :                                  ; Cancellation reason
cancelled_by = :                                   ; Who cancelled

{@service_request}

; ═══════════════════════════════════════════════════════════════════════════════
; WORK ORDER
; ═══════════════════════════════════════════════════════════════════════════════

{@work_order}
= @types.base_work_order

; Additional work order fields
work_type = (emergency, inspection, installation, maintenance, meter_exchange, repair, service_request)

; Location details
premise_id = :                                     ; Premise identifier
pole_number = :                                    ; Pole number if applicable
transformer_id = :                                 ; Transformer ID if applicable
circuit_id = :                                     ; Circuit/feeder ID

; Account information
account_number = *:                                 ; Account number
customer_name = :                                  ; Customer name
meter_number = :                                   ; Meter number

; Scheduling details
scheduled_time_start = time                        ; Start of time window
scheduled_time_end = time                          ; End of time window

; Priority and classification
outage_related = ?                                 ; Related to outage
safety_issue = ?                                   ; Safety concern
customer_requested = ?                             ; Customer requested

; Assignment details
dispatched_date = timestamp                        ; Dispatch timestamp
crew_size = ##:(1..)                               ; Number of workers

; Execution details
arrival_time = timestamp                           ; Crew arrival time
start_time = timestamp                             ; Work start time
completion_time = timestamp                        ; Work completion time

; Work details
cause_found = :                                    ; Cause identified
corrective_action = :                              ; Corrective action taken

; Materials used
{.materials[]}
material_code = :                                 ; Material identifier
description = :                                    ; Material description
quantity = #:(0..)                                ; Quantity used
uom = :                                            ; Unit of measure
cost = #$:(0..)                                    ; Material cost

{@work_order}
; Equipment
{.equipment[]}
equipment_id = :                                  ; Equipment identifier
equipment_type = :                                 ; Equipment type
usage_hours = #:(0..)                              ; Hours used
cost = #$:(0..)                                    ; Equipment cost

{@work_order}
; Labor
{.labor[]}
employee_id = :                                    ; Employee identifier
employee_name = :                                  ; Employee name
labor_hours = #:(0..)                             ; Hours worked
labor_rate = #$:(0..)                              ; Hourly rate
labor_cost = #$:(0..)                              ; Total labor cost
overtime = ?                                       ; Overtime hours flag

{@work_order}
; Costs
total_labor_cost = #$:(0..)                        ; Total labor
total_material_cost = #$:(0..)                     ; Total materials
total_equipment_cost = #$:(0..)                    ; Total equipment
total_cost = #$:(0..)                              ; Total work order cost

; Customer interaction
customer_present = ?                               ; Customer on-site
customer_signature = ?                             ; Signature obtained
customer_notification = ?                          ; Customer notified
notification_method = (door_hanger, email, phone)  ; Notification method

; Follow-up
follow_up_required = ?                             ; Follow-up needed
follow_up_date = date                              ; Follow-up date
follow_up_work_order = :                           ; Follow-up WO number

; Completion
completed_by = :                                   ; Technician who completed
verified_by = :                                    ; Supervisor verification
notes = :                                          ; Work order notes

{@work_order}

; ═══════════════════════════════════════════════════════════════════════════════
; CONNECT/DISCONNECT ORDER
; ═══════════════════════════════════════════════════════════════════════════════

{@connect_disconnect_order}
; Required fields first
order_number = :                                  ; Order identifier
order_type = (connect, disconnect, reconnect)     ; Order type
order_date = timestamp                            ; Order timestamp
status = (cancelled, completed, pending, scheduled)

; Account and location
account_number = *:                                ; Account number
meter_number = :                                   ; Meter number
service_address = @address                         ; Service location

; Reason
reason = (move_in, move_out, non_payment, owner_request, safety, service_restoration, theft)
reason_details = :                                 ; Additional details
authorization = :                                  ; Authorization reference

; Scheduling
scheduled_date = date                              ; Scheduled date
scheduled_time = time                              ; Scheduled time
completed_date = timestamp                         ; Completion timestamp

; Non-payment disconnect
{.non_payment}
past_due_amount = #$:(0..):if reason = non_payment ; Amount past due
disconnect_notice_date = date:if reason = non_payment
final_notice_date = date:if reason = non_payment
payment_required = #$:(0..):if reason = non_payment ; Payment to reconnect
payment_received = ?:if reason = non_payment       ; Payment received flag

{@connect_disconnect_order}
; Execution
performed_by = :                                   ; Technician
method = (ami_remote, collar, manual_switch, meter_removal)
meter_reading = #:(0..)                            ; Reading at time of action
seal_number = :                                    ; Seal applied if any

; Special circumstances
access_issue = ?                                   ; Access problem encountered
customer_refused_entry = ?                         ; Customer denied access
safety_concern = ?                                 ; Safety issue identified
referred_for_investigation = ?                     ; Investigation needed

; Reconnection
reconnect_fee = #$:(0..)                           ; Reconnection fee
reconnect_authorized_by = :                        ; Who authorized
reconnect_date = timestamp                         ; Reconnection timestamp

; Notes
notes = :                                          ; Order notes

{@connect_disconnect_order}

; ═══════════════════════════════════════════════════════════════════════════════
; OUTAGE
; ═══════════════════════════════════════════════════════════════════════════════

{@outage}
= @types.base_outage

; Additional outage fields
commodity = (electric, gas, water)                ; Commodity affected

; Extended timing
crew_assigned_time = timestamp                     ; Crew assignment time
crew_arrived_time = timestamp                      ; Crew arrival time

; Location details
pole_number = :                                    ; Pole identifier
transformer_id = :                                 ; Transformer ID
circuit_id = :                                     ; Circuit/feeder ID
substation_id = :                                  ; Substation ID
zone = :                                           ; Service zone

; Scope details
critical_customers_affected = ##:(0..)             ; Critical customers
load_interrupted_mw = #:(0..)                      ; Load interrupted (electric)

; Cause details
weather_related = ?                                ; Weather event flag
storm_name = :                                     ; Storm identifier if applicable

; Damage assessment
{.damage}
damaged_equipment = :                              ; Equipment damaged
pole_damage = ?                                    ; Pole damaged
wire_damage = ?                                    ; Wire/conductor damaged
transformer_damage = ?                             ; Transformer damaged
meter_damage = ?                                   ; Meter damaged
estimated_repair_cost = #$:(0..)                   ; Estimated cost

{@outage}
; Response
assigned_crew = :                                  ; Assigned crew ID
crew_count = ##:(1..)                              ; Number of crews
mutual_aid = ?                                     ; Mutual aid crews
contractor_crews = ##:(0..)                        ; Contractor crew count

; Restoration
restoration_method = (bypass, permanent, temporary)
estimated_restoration_time = timestamp             ; ERT
priority_restoration_order = ##                    ; Restoration priority

; Customer communications
automated_calls_sent = ##:(0..)                    ; IVR notifications
emails_sent = ##:(0..)                             ; Email notifications
text_messages_sent = ##:(0..)                      ; SMS notifications
estimated_restoration_communicated = ?             ; ERT communicated

; Regulatory reporting
{.regulatory}
reportable_event = ?                               ; NERC/PUC reportable
report_submitted = ?                               ; Report filed
report_date = date                                 ; Report submission date
report_number = :                                  ; Report reference
saidi_minutes = #:(0..)                            ; SAIDI impact
saifi_contribution = #:(0..)                       ; SAIFI contribution
caidi_minutes = #:(0..)                            ; CAIDI impact

{@outage}
; Notes
notes = :                                          ; Outage notes
root_cause_analysis = :                            ; Root cause findings

{@outage}

; ═══════════════════════════════════════════════════════════════════════════════
; SERVICE INVESTIGATION
; ═══════════════════════════════════════════════════════════════════════════════

{@service_investigation}
; Required fields first
investigation_number = :                          ; Investigation identifier
investigation_type = (billing_dispute, high_bill, low_voltage, meter_accuracy, power_quality, service_quality, voltage_fluctuation)
status = (assigned, cancelled, closed, completed, pending)
request_date = timestamp                          ; Investigation requested

; Account and location
account_number = *:                                ; Account number
customer_name = :                                  ; Customer name
service_address = @address                         ; Service location
meter_number = :                                   ; Meter number

; Complaint details
customer_complaint = :                             ; Customer description
symptoms = :                                       ; Reported symptoms
frequency = (continuous, intermittent, occasional) ; Occurrence frequency
duration = :                                       ; How long occurring

; Assignment
assigned_to = :                                    ; Assigned investigator
assigned_date = timestamp                          ; Assignment timestamp
priority = (high, routine, urgent)                 ; Investigation priority

; Investigation activities
{.activities[]}
activity_date = timestamp                         ; Activity timestamp
activity_type = (field_visit, meter_test, monitoring, voltage_test)
performed_by = :                                   ; Who performed
description = :                                   ; Activity description
findings = :                                       ; Findings

{@service_investigation}
; Meter testing
{.meter_test}
test_date = date                                   ; Test date
test_result = (failed, inconclusive, passed)       ; Test result
as_found_accuracy = #:(0..100)                     ; Accuracy found
meter_exchanged = ?                                ; Meter replaced
new_meter_number = :                               ; New meter if exchanged

{@service_investigation}
; Voltage monitoring
{.voltage_monitoring}
monitor_installed_date = date                      ; Monitor install date
monitor_removed_date = date                        ; Monitor removal date
monitoring_duration_days = ##:(1..)                ; Days monitored
voltage_avg = #:(0..)                              ; Average voltage
voltage_min = #:(0..)                              ; Minimum voltage
voltage_max = #:(0..)                              ; Maximum voltage
fluctuations_detected = ##:(0..)                   ; Number of events
ansi_violations = ##:(0..)                         ; ANSI range violations

{@service_investigation}
; Findings and resolution
cause_determined = :                               ; Root cause
corrective_action = :                              ; Action taken
corrective_work_order = :                          ; Work order number
billing_adjustment_required = ?                    ; Adjustment needed
adjustment_amount = #$                             ; Adjustment amount

; Customer communication
customer_notified = ?                              ; Customer notified
notification_date = date                           ; Notification date
notification_method = (email, letter, phone)       ; How notified

; Completion
completed_date = timestamp                         ; Completion timestamp
completed_by = :                                   ; Who completed
resolution_notes = :                               ; Resolution details

{@service_investigation}

; ═══════════════════════════════════════════════════════════════════════════════
; CUSTOMER COMPLAINT
; ═══════════════════════════════════════════════════════════════════════════════

{@customer_complaint}
; Required fields first
complaint_number = :                              ; Complaint identifier
complaint_type = (billing, communication, outage_response, power_quality, service_quality, tree_trimming)
received_date = timestamp                         ; Received timestamp
status = (closed, escalated, in_progress, pending, resolved)

; Customer information
account_number = *:                                 ; Account number
customer_name = :                                  ; Customer name
contact_phone = *@phone                            ; Contact phone
contact_email = *@email                            ; Contact email

; Complaint details
description = :                                   ; Complaint description
impact = :                                         ; Impact to customer
requested_resolution = :                           ; What customer wants

; Receipt
received_by = :                                    ; Who received
received_method = (email, in_person, phone, portal, social_media, written)

; Assignment
assigned_to = :                                    ; Assigned to handle
assigned_date = timestamp                          ; Assignment timestamp
priority = (high, routine, urgent)                 ; Priority level
escalated = ?                                      ; Escalated flag
escalated_to = :                                   ; Escalation recipient
escalation_date = timestamp                        ; Escalation timestamp

; Response
{.responses[]}
response_date = timestamp                         ; Response timestamp
responded_by = :                                   ; Who responded
response_method = (email, phone, written)          ; Response method
response_text = :                                  ; Response content

{@customer_complaint}
; Resolution
resolved_date = timestamp                          ; Resolution timestamp
resolved_by = :                                    ; Who resolved
resolution = :                                     ; Resolution description
customer_satisfied = ?                             ; Customer satisfaction
follow_up_required = ?                             ; Follow-up needed

; Regulatory
reportable_to_commission = ?                       ; PUC reportable
reported_date = date                               ; Report date
report_reference = :                               ; Report number

{@customer_complaint}

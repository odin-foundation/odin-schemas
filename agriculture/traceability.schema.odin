; ===================================================================================
; ODIN Agriculture Traceability Schema
; ===================================================================================
; Product traceability including lot tracking, traceability events (harvest, receiving,
; processing, shipping), chain of custody, recall procedures, and GS1 integration.
; ===================================================================================

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.agriculture.traceability"
version = "1.0.0"
title = "Agriculture Traceability Schema"
description = "Product traceability with lot tracking, events, chain of custody, and recalls"

{$derivation}
source[0].authority = "U.S. Food and Drug Administration"
source[0].citation = "21 CFR Part 1, Subpart S - Food Traceability Requirements (FSMA 204)"
source[0].url = "https://www.fda.gov/food/food-safety-modernization-act-fsma/fsma-final-rule-requirements-additional-traceability-records-certain-foods"

source[1].authority = "GS1"
source[1].citation = "GS1 Standards for Product Traceability in the Food and Agriculture Supply Chain"
source[1].url = "https://www.gs1.org/industries/agriculture"

source[2].authority = "Produce Traceability Initiative"
source[2].citation = "PTI Implementation Guidelines"
source[2].url = "https://www.producetraceability.org/"

source[3].authority = "International Organization for Standardization"
source[3].citation = "ISO 22005:2007 - Traceability in the feed and food chain"
source[3].url = "https://www.iso.org/standard/36297.html"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial agriculture traceability schema"
changelog[0].rationale = "Traceability structures derived from FDA FSMA 204, GS1, PTI, and ISO 22005"

; ===================================================================================
; LOT
; ===================================================================================

{@lot}
= @types.audit_info

; ───────────────────────────────────────────────────────────────────────────────
; Lot Identification
; ───────────────────────────────────────────────────────────────────────────────
lot_number = !:                                  ; Internal lot number
gtin = :                                         ; GS1 Global Trade Item Number
lot_code = :                                     ; Lot code (case label)
traceability_lot_code = :                        ; FDA TLC (FSMA 204)
sscc = :                                         ; GS1 Serial Shipping Container Code

; ───────────────────────────────────────────────────────────────────────────────
; Product Information
; ───────────────────────────────────────────────────────────────────────────────
{.product}
product_name = !:                                ; Product name
product_description = :                          ; Product description
commodity_code = :                               ; Commodity code
variety = :                                      ; Variety/cultivar
brand = :                                        ; Brand name
organic = ?                                      ; Organic product
pack_size = :                                    ; Pack size/format
pack_date = date                                 ; Pack/processing date

{@lot}

; ───────────────────────────────────────────────────────────────────────────────
; Origin (FSMA 204 Required)
; ───────────────────────────────────────────────────────────────────────────────
{.origin}
grower_name = !:                                 ; Grower/producer name
farm_ref = :                                     ; Farm reference
growing_location = @types.address                ; Growing location
field_ref = :                                    ; Field reference
harvest_date = date                              ; Harvest date
country_of_origin = :(2..3)                      ; Country of origin

{@lot}

; ───────────────────────────────────────────────────────────────────────────────
; Quantity
; ───────────────────────────────────────────────────────────────────────────────
{.quantity}
initial_quantity = !#:(0..)                      ; Initial quantity
current_quantity = #:(0..)                       ; Current quantity
quantity_unit = (boxes, bushels, cases, cwt, lbs, pallets, pounds, units)
initial_weight_lbs = #:(0..)                     ; Initial weight
current_weight_lbs = #:(0..)                     ; Current weight

{@lot}

; ───────────────────────────────────────────────────────────────────────────────
; Dates
; ───────────────────────────────────────────────────────────────────────────────
{.dates}
production_date = date                           ; Production/pack date
best_by_date = date                              ; Best by date
use_by_date = date                               ; Use by date
sell_by_date = date                              ; Sell by date
expiration_date = date                           ; Expiration date

{@lot}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
{.status}
lot_status = (consumed, destroyed, expired, in_transit, processed, quarantined, recalled, released, stored)
status_date = date                               ; Status change date
hold_reason = :                                  ; Reason for hold/quarantine
release_date = date                              ; Release from hold date

{@lot}

; ───────────────────────────────────────────────────────────────────────────────
; Traceability Events
; ───────────────────────────────────────────────────────────────────────────────
events[] = @traceability_event                   ; Traceability events

; ───────────────────────────────────────────────────────────────────────────────
; Chain of Custody
; ───────────────────────────────────────────────────────────────────────────────
chain_of_custody[] = @chain_of_custody           ; Custody transfers

; ===================================================================================
; TRACEABILITY EVENT
; ===================================================================================

{@traceability_event}
; ───────────────────────────────────────────────────────────────────────────────
; Event Details
; ───────────────────────────────────────────────────────────────────────────────
event_id = !:                                    ; Event ID
event_date = !date                               ; Event date
event_time = timestamp                           ; Event timestamp
event_type = (
    cooling,                                     ; Initial cooling
    harvesting,                                  ; Harvest event (FSMA CTE)
    packing,                                     ; Packing/processing
    receiving,                                   ; Receiving event (FSMA RTE)
    shipping,                                    ; Shipping event (FSMA STE)
    transformation,                              ; Transformation event (FSMA TTE)
    transporting                                 ; Transportation
)
lot_number = !:                                  ; Lot number

; ───────────────────────────────────────────────────────────────────────────────
; Location
; ───────────────────────────────────────────────────────────────────────────────
{.location}
location_name = !:                               ; Location/facility name
location_address = @types.address                ; Location address
location_gln = :                                 ; GS1 Global Location Number
location_type = (cold_storage, distribution_center, farm, packing_house, processor, retail, warehouse)

{@traceability_event}

; ───────────────────────────────────────────────────────────────────────────────
; Harvesting Event (FSMA CTE)
; ───────────────────────────────────────────────────────────────────────────────
{.harvesting}
field_ref = :if event_type = harvesting          ; Field reference
growing_location = @types.address:if event_type = harvesting
harvest_date = !date:if event_type = harvesting
traceability_lot_code = :if event_type = harvesting
commodity = !:if event_type = harvesting         ; Commodity harvested
quantity = #:(0..):if event_type = harvesting    ; Quantity harvested
quantity_unit = :if event_type = harvesting

{@traceability_event}

; ───────────────────────────────────────────────────────────────────────────────
; Cooling Event
; ───────────────────────────────────────────────────────────────────────────────
{.cooling}
cooling_method = (air, forced_air, hydro, ice, vacuum):if event_type = cooling
initial_temp_f = #:if event_type = cooling       ; Initial temperature
final_temp_f = #:if event_type = cooling         ; Final temperature
cooling_start = timestamp:if event_type = cooling
cooling_end = timestamp:if event_type = cooling
cooling_duration_hours = #:(0..):if event_type = cooling

{@traceability_event}

; ───────────────────────────────────────────────────────────────────────────────
; Packing/Processing
; ───────────────────────────────────────────────────────────────────────────────
{.packing}
packer_name = :if event_type = packing           ; Packing facility name
pack_date = date:if event_type = packing
pack_line = :if event_type = packing             ; Pack line identifier
input_lots[] = :if event_type = packing          ; Input lot numbers
output_lots[] = :if event_type = packing         ; Output lot numbers
quantity_packed = #:(0..):if event_type = packing

{@traceability_event}

; ───────────────────────────────────────────────────────────────────────────────
; Receiving Event (FSMA RTE)
; ───────────────────────────────────────────────────────────────────────────────
{.receiving}
received_from = !:if event_type = receiving      ; Sender name
sender_address = @types.address:if event_type = receiving
traceability_lot_code = :if event_type = receiving
quantity_received = #:(0..):if event_type = receiving
quantity_unit = :if event_type = receiving
temperature_at_receipt_f = #:if event_type = receiving
condition_at_receipt = :if event_type = receiving
accepted = ?:if event_type = receiving
rejection_reason = :if event_type = receiving

{@traceability_event}

; ───────────────────────────────────────────────────────────────────────────────
; Shipping Event (FSMA STE)
; ───────────────────────────────────────────────────────────────────────────────
{.shipping}
shipped_to = !:if event_type = shipping          ; Recipient name
recipient_address = @types.address:if event_type = shipping
traceability_lot_code = :if event_type = shipping
quantity_shipped = #:(0..):if event_type = shipping
quantity_unit = :if event_type = shipping
carrier_name = :if event_type = shipping
transport_vehicle_id = :if event_type = shipping
reference_document = :if event_type = shipping   ; BOL, invoice, etc.

{@traceability_event}

; ───────────────────────────────────────────────────────────────────────────────
; Transformation Event (FSMA TTE)
; ───────────────────────────────────────────────────────────────────────────────
{.transformation}
process_type = :if event_type = transformation   ; Process type
input_lots[] = !:if event_type = transformation  ; Input lot numbers
output_lots[] = !:if event_type = transformation ; Output lot numbers
process_date = date:if event_type = transformation
process_description = :if event_type = transformation

{@traceability_event}

; ───────────────────────────────────────────────────────────────────────────────
; Transportation
; ───────────────────────────────────────────────────────────────────────────────
{.transport}
carrier = :if event_type = transporting          ; Carrier name
vehicle_id = :if event_type = transporting       ; Vehicle/trailer ID
driver_name = :if event_type = transporting      ; Driver name
origin = @types.address:if event_type = transporting
destination = @types.address:if event_type = transporting
departure_date = timestamp:if event_type = transporting
arrival_date = timestamp:if event_type = transporting
temperature_controlled = ?:if event_type = transporting
set_temp_f = #:if event_type = transporting      ; Set temperature

{@traceability_event}

; ───────────────────────────────────────────────────────────────────────────────
; Personnel
; ───────────────────────────────────────────────────────────────────────────────
{.personnel}
performed_by = :                                 ; Person who performed event
supervisor = :                                   ; Supervisor name
recorded_by = :                                  ; Person who recorded

{@traceability_event}

; ───────────────────────────────────────────────────────────────────────────────
; Quality/Conditions
; ───────────────────────────────────────────────────────────────────────────────
{.conditions}
temperature_f = #:(-50..150)                     ; Temperature
humidity_percent = #:(0..100)                    ; Relative humidity
condition_notes = :                              ; Condition observations

; ===================================================================================
; CHAIN OF CUSTODY
; ===================================================================================

{@chain_of_custody}
; ───────────────────────────────────────────────────────────────────────────────
; Transfer Details
; ───────────────────────────────────────────────────────────────────────────────
transfer_id = !:                                 ; Transfer ID
transfer_date = !date                            ; Transfer date
transfer_time = timestamp                        ; Transfer timestamp
lot_number = !:                                  ; Lot number

; ───────────────────────────────────────────────────────────────────────────────
; From (Transferor)
; ───────────────────────────────────────────────────────────────────────────────
{.from}
from_entity = !:                                 ; Transferor name
from_location = @types.address                   ; Transferor location
from_contact = :                                 ; Contact name
relinquished_by = :                              ; Person relinquishing custody
relinquish_signature = :                         ; Signature/ID
relinquish_timestamp = timestamp                 ; Relinquish timestamp

{@chain_of_custody}

; ───────────────────────────────────────────────────────────────────────────────
; To (Transferee)
; ───────────────────────────────────────────────────────────────────────────────
{.to}
to_entity = !:                                   ; Transferee name
to_location = @types.address                     ; Transferee location
to_contact = :                                   ; Contact name
received_by = :                                  ; Person accepting custody
receive_signature = :                            ; Signature/ID
receive_timestamp = timestamp                    ; Receive timestamp

{@chain_of_custody}

; ───────────────────────────────────────────────────────────────────────────────
; Product Details
; ───────────────────────────────────────────────────────────────────────────────
{.product}
product_description = !:                         ; Product description
quantity = !#:(0..)                              ; Quantity transferred
quantity_unit = :                                ; Unit of measure
temperature_f = #                                ; Temperature at transfer
condition = :                                    ; Product condition
seals_intact = ?                                 ; Seals intact
seal_numbers[] = :                               ; Seal numbers

{@chain_of_custody}

; ───────────────────────────────────────────────────────────────────────────────
; Purpose
; ───────────────────────────────────────────────────────────────────────────────
{.purpose}
transfer_purpose = (delivery, investigation, return, sale, storage, testing, transport)
reference_document = :                           ; Reference document number
special_instructions = :                         ; Special handling instructions

; ===================================================================================
; RECALL
; ===================================================================================

{@recall}
; ───────────────────────────────────────────────────────────────────────────────
; Recall Details
; ───────────────────────────────────────────────────────────────────────────────
recall_number = !:                               ; Recall identifier
recall_date = !date                              ; Recall initiation date
recall_type = (company_initiated, fda_requested, fsis_requested, voluntary)
recall_class = (class_i, class_ii, class_iii)   ; FDA recall classification
recall_status = (completed, in_progress, ongoing, terminated)

; ───────────────────────────────────────────────────────────────────────────────
; Product Information
; ───────────────────────────────────────────────────────────────────────────────
{.product}
product_name = !:                                ; Product name
product_description = !:                         ; Product description
brand = :                                        ; Brand name
lot_numbers[] = !:                               ; Affected lot numbers
gtin = :                                         ; GTIN
pack_dates[] = date                              ; Pack dates affected
upc_codes[] = :                                  ; UPC codes

{@recall}

; ───────────────────────────────────────────────────────────────────────────────
; Reason
; ───────────────────────────────────────────────────────────────────────────────
{.reason}
reason_description = !:                          ; Recall reason
hazard_type = (allergen, biological, chemical, foreign_material, labeling, physical, undeclared_ingredient)
contaminant = :                                  ; Specific contaminant/allergen
health_hazard = (high, low, medium)             ; Health hazard evaluation

{@recall}

; ───────────────────────────────────────────────────────────────────────────────
; Scope
; ───────────────────────────────────────────────────────────────────────────────
{.scope}
quantity_affected = !#:(0..)                     ; Total quantity affected
quantity_unit = :                                ; Unit of measure
quantity_distributed = #:(0..)                   ; Quantity distributed
quantity_recovered = #:(0..)                     ; Quantity recovered
recovery_percent = #:(0..100)                    ; Percent recovered
distribution_pattern = :                         ; Geographic distribution

{@recall}

; ───────────────────────────────────────────────────────────────────────────────
; Company Conducting Recall
; ───────────────────────────────────────────────────────────────────────────────
{.company}
company_name = !:                                ; Company name
company_address = @types.address                 ; Company address
contact_person = :                               ; Contact person
contact_phone = *@types.phone                    ; Contact phone
contact_email = *@types.email                    ; Contact email

{@recall}

; ───────────────────────────────────────────────────────────────────────────────
; Notification
; ───────────────────────────────────────────────────────────────────────────────
{.notification}
press_release_issued = ?                         ; Press release issued
press_release_date = date                        ; Press release date
customer_notification_date = date                ; Customer notification date
fda_notification_date = date                     ; FDA notification date
public_notification = ?                          ; Public notification issued
notification_method = :                          ; Notification method

{@recall}

; ───────────────────────────────────────────────────────────────────────────────
; Distribution List
; ───────────────────────────────────────────────────────────────────────────────
{.distribution[]}
recipient_name = :                               ; Recipient name
recipient_address = @types.address               ; Recipient address
quantity_shipped = #:(0..)                       ; Quantity shipped to recipient
notification_date = date                         ; Date notified
response_date = date                             ; Date responded
quantity_returned = #:(0..)                      ; Quantity returned
disposition = :                                  ; Disposition of product

{@recall}

; ───────────────────────────────────────────────────────────────────────────────
; Effectiveness Checks
; ───────────────────────────────────────────────────────────────────────────────
{.effectiveness_checks[]}
check_date = date                                ; Check date
check_level = (a, b, c, d, e)                    ; FDA level
consignees_checked = ##:(0..)                    ; Number checked
responses_received = ##:(0..)                    ; Number responded
product_recovered = #:(0..)                      ; Product recovered
effectiveness = (effective, ineffective, ongoing)

{@recall}

; ───────────────────────────────────────────────────────────────────────────────
; Corrective Actions
; ───────────────────────────────────────────────────────────────────────────────
{.corrective_actions}
root_cause = :                                   ; Root cause analysis
preventive_actions[] = :                         ; Preventive actions taken
process_changes = :                              ; Process changes implemented
verification_date = date                         ; Verification date

{@recall}

; ───────────────────────────────────────────────────────────────────────────────
; Termination
; ───────────────────────────────────────────────────────────────────────────────
{.termination}
termination_date = date                          ; Recall termination date
termination_reason = :                           ; Reason for termination
final_disposition = :                            ; Final product disposition

; ===================================================================================
; MOCK RECALL EXERCISE
; ===================================================================================

{@mock_recall}
; ───────────────────────────────────────────────────────────────────────────────
; Exercise Details
; ───────────────────────────────────────────────────────────────────────────────
exercise_id = !:                                 ; Exercise identifier
exercise_date = !date                            ; Exercise date
product_selected = !:                            ; Product selected for exercise
lot_selected = :                                 ; Lot selected
reason_simulated = :                             ; Simulated recall reason

; ───────────────────────────────────────────────────────────────────────────────
; Participants
; ───────────────────────────────────────────────────────────────────────────────
{.participants[]}
name = :                                         ; Participant name
role = :                                         ; Role in exercise

{@mock_recall}

; ───────────────────────────────────────────────────────────────────────────────
; Timeline
; ───────────────────────────────────────────────────────────────────────────────
{.timeline}
notification_start = timestamp                   ; Exercise start time
trace_forward_complete = timestamp               ; Trace forward complete
trace_back_complete = timestamp                  ; Trace back complete
total_duration_minutes = #:(0..)                 ; Total duration
target_duration_minutes = ##:(0..)               ; Target duration (usually 120-240)

{@mock_recall}

; ───────────────────────────────────────────────────────────────────────────────
; Results
; ───────────────────────────────────────────────────────────────────────────────
{.results}
trace_back_successful = ?                        ; Trace back successful
trace_forward_successful = ?                     ; Trace forward successful
all_records_found = ?                            ; All records located
time_target_met = ?                              ; Completed within target time
issues_identified[] = :                          ; Issues identified
corrective_actions[] = :                         ; Corrective actions needed

{@mock_recall}

; ───────────────────────────────────────────────────────────────────────────────
; Documentation
; ───────────────────────────────────────────────────────────────────────────────
{.documentation}
records_reviewed[] = :                           ; Records reviewed
gaps_identified[] = :                            ; Documentation gaps
improvements_needed[] = :                        ; Recommended improvements

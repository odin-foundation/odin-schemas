; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Logistics Shipment Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Domestic and international shipments including tracking events, proof of
; delivery, multimodal transport, and shipment consolidation.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.logistics.shipment"
version = "1.0.0"
title = "Logistics Shipment Schema"
description = "Shipment information for domestic and international freight"

{$derivation}
source[0].authority = "FMCSA"
source[0].citation = "49 CFR Part 373 - Receipts and Bills"
source[0].url = "https://www.ecfr.gov/current/title-49/subtitle-B/chapter-III/subchapter-B/part-373"

source[1].authority = "IATA"
source[1].citation = "IATA Cargo Services Conference Resolutions"
source[1].url = "https://www.iata.org/en/programs/cargo/"

source[2].authority = "GS1"
source[2].citation = "GS1 Logistics Standards"
source[2].url = "https://www.gs1.org/standards"

source[3].authority = "ICC"
source[3].citation = "Incoterms 2020"
source[3].url = "https://iccwbo.org/resources-for-business/incoterms-rules/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial shipment schema"
changelog[0].rationale = "Core shipment structure with tracking and POD"

; ═══════════════════════════════════════════════════════════════════════════════
; SHIPMENT PARTY
; ═══════════════════════════════════════════════════════════════════════════════

{@shipment_party}
; Required fields first
name = !:                                            ; Party name
role = (
    bill_to,
    broker,
    carrier,
    consignee,
    consignor,
    freight_forwarder,
    notify_party,
    pickup,
    shipper
)

; Optional fields
reference = :                                        ; Internal reference number
account_number = *:                                   ; Account number with carrier
address = @types.address                             ; Party address
email = *@types.email                                ; Contact email
phone = *@types.phone                                ; Contact phone

; ═══════════════════════════════════════════════════════════════════════════════
; PACKAGE
; ═══════════════════════════════════════════════════════════════════════════════

{@package}
; Required fields first
package_id = !:                                      ; Package identifier
package_type = (
    bag,
    barrel,
    box,
    bundle,
    carton,
    case,
    container,
    crate,
    drum,
    envelope,
    pallet,
    reel,
    roll,
    skid,
    tank,
    tube
)
quantity = !##:(1..)                                 ; Number of packages

; Optional fields
description = :                                      ; Package description
piece_count = ##:(1..)                               ; Individual pieces per package
stackable = ?                                        ; Can be stacked

; Dimensions
{.dimensions}
length = #:(0..)                                     ; Length
width = #:(0..)                                      ; Width
height = #:(0..)                                     ; Height
unit = (cm, ft, in, m)                               ; Dimension unit

{@package}

; Weight
{.weight}
gross = !#:(0..)                                     ; Gross weight including packaging
tare = #:(0..)                                       ; Packaging weight only
net = #:(0..)                                        ; Net weight (gross - tare)
unit = (kg, lb, oz, ton)                            ; Weight unit

{@package}

; Markings
marking = :                                          ; Package marking/label
handling_instructions[] = :                          ; Special handling instructions

; Tracking
tracking_number = :                                  ; Individual package tracking number
barcode = :                                          ; Package barcode
rfid_tag = :                                         ; RFID tag identifier

; ═══════════════════════════════════════════════════════════════════════════════
; COMMODITY
; ═══════════════════════════════════════════════════════════════════════════════

{@commodity}
; Required fields first
description = !:                                     ; Commodity description

; Optional fields
classification = :                                   ; NMFC class, HTS code, or other
code = :                                             ; Commodity code
nmfc = :                                             ; National Motor Freight Classification
nmfc_sub = :                                         ; NMFC sub classification
freight_class = (50, 55, 60, 65, 70, 77.5, 85, 92.5, 100, 110, 125, 150, 175, 200, 250, 300, 400, 500)

; Quantity
quantity = #:(0..)                                   ; Commodity quantity
quantity_unit = :                                    ; Quantity unit of measure

; Weight
weight = #:(0..)                                     ; Commodity weight
weight_unit = (kg, lb, oz, ton)                      ; Weight unit

; Value
declared_value = #$:(0..)                            ; Declared value for insurance
currency = :(3) "USD"                                ; Currency code

; Product details
harmonized_code = :                                  ; HTS/HS tariff code
country_of_origin = :(2)                             ; ISO country code
manufacturer = :                                     ; Manufacturer name

; Flags
hazmat = ?                                           ; Hazardous material flag
un_number = :if hazmat = true                        ; UN number for hazmat
proper_shipping_name = :if hazmat = true             ; DOT proper shipping name
hazard_class = :if hazmat = true                     ; Hazard class
packing_group = (I, II, III):if hazmat = true        ; Packing group

perishable = ?                                       ; Perishable flag
temperature_controlled = ?                           ; Requires temperature control
min_temperature = #:if temperature_controlled = true ; Minimum temperature
max_temperature = #:if temperature_controlled = true ; Maximum temperature
temp_unit = (C, F):if temperature_controlled = true  ; Temperature unit

; ═══════════════════════════════════════════════════════════════════════════════
; TRACKING EVENT
; ═══════════════════════════════════════════════════════════════════════════════

{@tracking_event}
; Required fields first
event_code = !:                                      ; Event code
status = (
    accepted,
    arrived,
    cancelled,
    cleared_customs,
    delivered,
    delayed,
    departed,
    exception,
    in_transit,
    out_for_delivery,
    pending,
    picked_up,
    received,
    returned,
    sorted,
    tendered
)
timestamp = !timestamp                               ; Event timestamp

; Optional fields
description = :                                      ; Event description
location = @types.address                            ; Event location
facility = :                                         ; Facility identifier
city = :                                             ; Event city
state_province = :(2)                                ; State or province code
country = :(2)                                       ; Country code
postal_code = :                                      ; Postal code

; Details
signed_by = :                                        ; Who signed for delivery
delivery_location = (dock, front_door, left_with_neighbor, mailroom, reception, side_door)
exception_code = :                                   ; Exception reason code
exception_description = :                            ; Exception description
delay_reason = :                                     ; Delay reason
estimated_delivery = timestamp                       ; Updated estimated delivery

; ═══════════════════════════════════════════════════════════════════════════════
; PROOF OF DELIVERY
; ═══════════════════════════════════════════════════════════════════════════════

{@proof_of_delivery}
; Required fields first
delivery_date = !date                                ; Delivery date
delivery_time = !time                                ; Delivery time

; Optional fields
signature_name = :                                   ; Name of person who signed
signature_image = ^                                  ; Digital signature image (Base64)
photo_image = ^                                      ; Photo proof of delivery
electronic_signature = ?                             ; Electronic signature flag

delivery_location = (dock, front_door, left_with_neighbor, mailroom, reception, side_door)
delivery_instructions = :                            ; Special delivery instructions
delivery_notes = :                                   ; Delivery notes from driver

received_by = :                                      ; Name of recipient
relationship = (authorized, employee, occupant, other, owner, recipient)

pieces_delivered = ##:(0..)                          ; Number of pieces delivered
pieces_refused = ##:(0..)                            ; Number of pieces refused
pieces_short = ##:(0..)                              ; Number of pieces missing

damage_noted = ?                                     ; Damage noted on delivery
damage_description = :if damage_noted = true         ; Damage description

; ═══════════════════════════════════════════════════════════════════════════════
; SHIPMENT MILESTONE
; ═══════════════════════════════════════════════════════════════════════════════

{@shipment_milestone}
; Required fields first
milestone = (
    arrival_at_destination,
    booked,
    cleared_customs,
    delivered,
    departed_origin,
    estimated_arrival,
    in_transit,
    picked_up,
    ready_for_pickup,
    tendered_to_carrier
)

; Optional fields
planned_date = date                                  ; Planned milestone date
planned_time = time                                  ; Planned milestone time
actual_date = date                                   ; Actual milestone date
actual_time = time                                   ; Actual milestone time
status = (achieved, delayed, pending, planned)       ; Milestone status
location = :                                         ; Milestone location
notes = :                                            ; Milestone notes

; ═══════════════════════════════════════════════════════════════════════════════
; SHIPMENT STOP
; ═══════════════════════════════════════════════════════════════════════════════

{@shipment_stop}
; Required fields first
sequence = !##:(1..)                                 ; Stop sequence number
type = (delivery, pickup)                           ; Stop type
address = !@types.address                            ; Stop address

; Optional fields
contact = :                                          ; Contact name at stop
phone = *@types.phone                                ; Contact phone
email = *@types.email                                ; Contact email

appointment_date = date                              ; Scheduled appointment date
appointment_time = time                              ; Scheduled appointment time
appointment_type = (by_appointment, fcfs, scheduled_window)

arrival_date = date                                  ; Actual arrival date
arrival_time = time                                  ; Actual arrival time
departure_date = date                                ; Actual departure date
departure_time = time                                ; Actual departure time

reference_numbers[] = :                              ; Stop reference numbers (PO, DO, etc.)
special_instructions = :                             ; Special instructions

; ═══════════════════════════════════════════════════════════════════════════════
; CONSOLIDATION
; ═══════════════════════════════════════════════════════════════════════════════

{@consolidation}
; Required fields first
consolidation_id = !:                                ; Consolidation identifier
type = (container, pallet, trailer)                 ; Consolidation type

; Optional fields
master_bill = :                                      ; Master bill of lading number
house_bills[] = :                                    ; House bill numbers consolidated
total_weight = #:(0..)                               ; Total consolidated weight
weight_unit = (kg, lb, ton)                          ; Weight unit
total_pieces = ##:(0..)                              ; Total pieces consolidated

; Container details
container_number = :if type = container              ; Container number
container_type = (
    dry,
    flat_rack,
    high_cube,
    open_top,
    platform,
    reefer,
    tank
):if type = container
container_size = (10, 20, 40, 45, 53):if type = container
seal_number = :if type = container                   ; Container seal number

; ═══════════════════════════════════════════════════════════════════════════════
; SHIPMENT
; ═══════════════════════════════════════════════════════════════════════════════

{@shipment}
; Required fields first
shipment_id = !:                                     ; Unique shipment identifier
status = (
    booked,
    cancelled,
    delivered,
    exception,
    in_transit,
    pending,
    picked_up,
    returned
)

; Shipment type
service_level = (
    air_freight,
    drayage,
    expedited,
    ftl,
    ground,
    intermodal,
    last_mile,
    ltl,
    ocean_fcl,
    ocean_lcl,
    parcel,
    white_glove
)
mode = (air, intermodal, ocean, parcel, rail, road)

; Dates
ship_date = !date                                    ; Ship date
requested_pickup_date = date                         ; Requested pickup date
actual_pickup_date = date                            ; Actual pickup date
estimated_delivery_date = date                       ; Estimated delivery date
requested_delivery_date = date                       ; Requested delivery date
actual_delivery_date = date                          ; Actual delivery date

; Parties
shipper = !@shipment_party                           ; Shipper information
consignee = !@shipment_party                         ; Consignee information
bill_to = @shipment_party                            ; Bill to party
carrier = @shipment_party                            ; Carrier information
broker = @shipment_party                             ; Customs broker
notify_parties[] = @shipment_party                   ; Notify parties

; References
bol_number = :                                       ; Bill of lading number
pro_number = :                                       ; Progressive number (LTL)
master_bill = :                                      ; Master bill of lading
house_bill = :                                       ; House bill of lading
booking_number = :                                   ; Booking reference
customer_reference = :                               ; Customer reference number
purchase_order = :                                   ; Purchase order number
invoice_number = :                                   ; Invoice number
container_number = :                                 ; Container number

; Packages and commodities
packages[] = @package                                ; Packages in shipment
commodities[] = @commodity                           ; Commodities being shipped

; Weight and measurements
{.totals}
total_weight = #:(0..)                               ; Total shipment weight
weight_unit = (kg, lb, ton)                          ; Weight unit
total_pieces = ##:(0..)                              ; Total pieces
total_pallets = ##:(0..)                             ; Total pallets
total_volume = #:(0..)                               ; Total volume
volume_unit = (cbm, cuft)                            ; Volume unit
chargeable_weight = #:(0..)                          ; Chargeable weight for billing
dim_weight = #:(0..)                                 ; Dimensional weight

{@shipment}

; Routing
{.route}
origin_city = :                                      ; Origin city
origin_state = :(2)                                  ; Origin state/province
origin_country = :(2)                                ; Origin country code
origin_postal = :                                    ; Origin postal code

destination_city = :                                 ; Destination city
destination_state = :(2)                             ; Destination state/province
destination_country = :(2)                           ; Destination country code
destination_postal = :                               ; Destination postal code

stops[] = @shipment_stop                             ; Multiple stops

{@shipment}

; Terms
incoterm = (CFR, CIF, CIP, CPT, DAP, DDP, DPU, EXW, FAS, FCA, FOB)
payment_terms = (collect, prepaid, third_party)      ; Freight payment terms
declared_value = #$:(0..)                            ; Declared value for insurance

; Special services
cod_amount = #$:(0..)                                ; COD amount
inside_delivery = ?                                  ; Inside delivery required
liftgate_required = ?                                ; Liftgate required
residential = ?                                      ; Residential delivery
signature_required = ?                               ; Signature required
notify_before_delivery = ?                           ; Notify before delivery
weekend_delivery = ?                                 ; Weekend delivery allowed

; Tracking
tracking_number = :                                  ; Primary tracking number
tracking_events[] = @tracking_event                  ; Tracking event history
milestones[] = @shipment_milestone                   ; Shipment milestones

; Proof of delivery
pod = @proof_of_delivery                             ; Proof of delivery

; Consolidation
consolidation = @consolidation                       ; Consolidation details

; Charges
{.charges}
freight_charges = #$                                 ; Freight charges
fuel_surcharge = #$                                  ; Fuel surcharge
accessorial_charges = #$                             ; Accessorial charges
total_charges = #$                                   ; Total charges
currency = :(3) "USD"                                ; Currency code

{@shipment}

; Notes and instructions
special_instructions = :                             ; Special handling instructions
shipping_notes = :                                   ; General shipping notes
customs_notes = :                                    ; Customs-related notes

; Flags
international = ?                                    ; International shipment flag
bonded = ?                                           ; Bonded shipment flag
temperature_controlled = ?                           ; Temperature controlled
hazmat = ?                                           ; Contains hazardous materials
high_value = ?                                       ; High value shipment
guaranteed_service = ?                               ; Guaranteed delivery service

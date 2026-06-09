; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Logistics Warehouse and Fulfillment Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Warehouse facility management, inventory operations, ASN processing, and
; 3PL service agreements.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.logistics.warehouse"
version = "1.0.0"
title = "Logistics Warehouse and Fulfillment Schema"
description = "Warehouse facilities, inventory operations, ASN, and 3PL agreements"

{$derivation}
source[0].authority = "GS1"
source[0].citation = "GS1 Logistics Standards - Warehouse Management"
source[0].url = "https://www.gs1.org/standards"

source[1].authority = "IWLA"
source[1].citation = "International Warehouse Logistics Association Best Practices"
source[1].url = "https://www.iwla.com/"

source[2].authority = "WERC"
source[2].citation = "Warehousing Education and Research Council Standards"
source[2].url = "https://werc.org/"

source[3].authority = "APICS"
source[3].citation = "APICS Supply Chain Operations Reference (SCOR) Model"
source[3].url = "https://www.ascm.org/"

methodology = "industry_practice"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial warehouse and fulfillment schema"
changelog[0].rationale = "Warehouse facility, inventory operations, ASN, 3PL structures"

; ═══════════════════════════════════════════════════════════════════════════════
; WAREHOUSE
; ═══════════════════════════════════════════════════════════════════════════════

{@warehouse}
; Required fields first
warehouse_id = :                                    ; Unique warehouse identifier
name = :                                            ; Warehouse name
type = (
    cross_dock,
    distribution_center,
    fulfillment_center,
    public_warehouse,
    temperature_controlled,
    transload
)

; Location
address = @types.address                            ; Physical address
latitude = #:(-90..90)                               ; GPS latitude
longitude = #:(-180..180)                            ; GPS longitude

; Capacity
{.capacity}
total_square_feet = ##:(0..)                         ; Total square footage
warehouse_square_feet = ##:(0..)                     ; Usable warehouse space
office_square_feet = ##:(0..)                        ; Office space
pallet_positions = ##:(0..)                          ; Pallet positions
clear_height_feet = ##:(0..)                         ; Clear ceiling height

{@warehouse}

; Physical characteristics
{.facility}
construction_type = (
    concrete_tilt_up,
    masonry,
    metal_building,
    precast_concrete,
    steel_frame
)
roof_type = (built_up, epdm, metal, tpo)
year_built = ##:(1900..2100)                         ; Year built
last_renovated = ##:(1900..2100)                     ; Last renovation year

{@warehouse}

; Loading capabilities
{.loading}
dock_doors = ##:(0..)                                ; Number of dock doors
drive_in_doors = ##:(0..)                            ; Drive-in doors
rail_doors = ##:(0..)                                ; Rail car doors
rail_spurs = ##:(0..)                                ; Rail spurs
truck_parking_spaces = ##:(0..)                      ; Truck parking spaces

{@warehouse}

; Equipment
{.equipment}
forklifts = ##:(0..)                                 ; Forklift count
reach_trucks = ##:(0..)                              ; Reach truck count
pallet_jacks = ##:(0..)                              ; Pallet jack count
order_pickers = ##:(0..)                             ; Order picker count
dock_levelers = ##:(0..)                             ; Dock leveler count
dock_plates = ##:(0..)                               ; Dock plate count

{@warehouse}

; Technology
{.technology}
wms_system = :                                       ; WMS system name
wms_version = :                                      ; WMS version
rf_scanning = ?                                      ; RF scanning capability
barcode_system = ?                                   ; Barcode system
voice_picking = ?                                    ; Voice-directed picking
automated_storage = ?                                ; AS/RS or automated storage
conveyor_system = ?                                  ; Conveyor system
sortation_system = ?                                 ; Automated sortation

{@warehouse}

; Capabilities
{.capabilities}
temperature_controlled = ?                           ; Temperature controlled
refrigerated = ?                                     ; Refrigerated storage
frozen = ?                                           ; Frozen storage
hazmat_certified = ?                                 ; Hazmat storage certified
fda_registered = ?                                   ; FDA registered
usda_inspected = ?                                   ; USDA inspected
food_grade = ?                                       ; Food-grade facility
pharmaceutical = ?                                   ; Pharmaceutical storage
bonded_warehouse = ?                                 ; Customs bonded warehouse
ftz = ?                                              ; Foreign Trade Zone
cross_docking = ?                                    ; Cross-docking capability
kitting = ?                                          ; Kitting/assembly
co_packing = ?                                       ; Co-packing services
labeling = ?                                         ; Labeling services
returns_processing = ?                               ; Returns processing

{@warehouse}

; Certifications
certifications[] = (
    AIB,                                             ; American Institute of Baking
    BRC,                                             ; British Retail Consortium
    C_TPAT,                                          ; Customs-Trade Partnership
    FSSC_22000,                                      ; Food Safety System Certification
    GMP,                                             ; Good Manufacturing Practices
    HACCP,                                           ; Hazard Analysis Critical Control Points
    ISO_9001,                                        ; Quality Management
    ISO_14001,                                       ; Environmental Management
    ISO_22000,                                       ; Food Safety Management
    LEED,                                            ; Leadership in Energy and Environmental Design
    SQF,                                             ; Safe Quality Food
    USDA_Organic                                     ; USDA Organic
)

; Operating hours
{.hours}
operating_days = (five_day, seven_day, six_day)      ; Operating days per week
hours_per_day = ##:(0..24)                           ; Hours per day
shifts_per_day = ##:(1..3)                           ; Shifts per day
twentyfour_seven = ?                                 ; 24/7 operation

{@warehouse}

; Status
status = (active, closed, inactive, planned)         ; Facility status
status_date = date                                   ; Status effective date

; ═══════════════════════════════════════════════════════════════════════════════
; INVENTORY LOCATION
; ═══════════════════════════════════════════════════════════════════════════════

{@inventory_location}
; Required fields first
location_id = :                                     ; Location identifier
type = (
    bulk,
    damage,
    floor,
    hold,
    pallet_rack,
    pick_face,
    quarantine,
    receiving,
    returns,
    shipping,
    staging
)

; Optional fields
aisle = :                                            ; Aisle identifier
bay = :                                              ; Bay identifier
level = :                                            ; Level/tier
position = :                                         ; Position within level
zone = :                                             ; Zone identifier

; Characteristics
{.characteristics}
pickable = ?                                         ; Pickable location
replenishable = ?                                    ; Replenishment location
multi_sku = ?                                        ; Multi-SKU allowed
dedicated = ?                                        ; Dedicated to SKU

{@inventory_location}

; Capacity
{.capacity}
max_pallets = ##:(0..)                               ; Maximum pallets
max_weight_lbs = ##:(0..)                            ; Maximum weight
max_cube_cuft = #:(0..)                              ; Maximum cubic feet

{@inventory_location}

; Environment
temperature_zone = (ambient, chilled, frozen)        ; Temperature zone
humidity_controlled = ?                              ; Humidity controlled

; Current status
occupied = ?                                         ; Currently occupied
available = ?                                        ; Available for putaway
blocked = ?                                          ; Blocked/unavailable
blocked_reason = :if blocked = true                  ; Block reason

; ═══════════════════════════════════════════════════════════════════════════════
; INVENTORY ITEM
; ═══════════════════════════════════════════════════════════════════════════════

{@inventory_item}
; Required fields first
sku = :                                             ; SKU identifier
warehouse_id = :                                    ; Warehouse identifier

; Optional fields
description = :                                      ; Item description
upc = :                                              ; UPC/EAN barcode
lot_number = :                                       ; Lot/batch number
serial_number = :                                    ; Serial number
manufacture_date = date                              ; Manufacture date
expiration_date = date                               ; Expiration date
best_by_date = date                                  ; Best by date

; Quantity
{.quantity}
on_hand = ##:(0..)                                  ; Total on hand
available = ##:(0..)                                 ; Available quantity
allocated = ##:(0..)                                 ; Allocated to orders
on_hold = ##:(0..)                                   ; On hold
damaged = ##:(0..)                                   ; Damaged
in_transit = ##:(0..)                                ; In transit

:invariant on_hand >= available + allocated + on_hold + damaged

{@inventory_item}

; Physical attributes
{.physical}
unit_weight = #:(0..)                                ; Weight per unit
weight_unit = (kg, lb, oz)                           ; Weight unit
length = #:(0..)                                     ; Length
width = #:(0..)                                      ; Width
height = #:(0..)                                     ; Height
dimension_unit = (cm, in)                            ; Dimension unit
cube = #:(0..)                                       ; Cubic feet/meters
ti = ##:(0..)                                        ; Tier (units high on pallet)
hi = ##:(0..)                                        ; High (tiers per pallet)

{@inventory_item}

; Storage requirements
{.storage}
temperature_zone = (ambient, chilled, frozen)        ; Temperature zone
min_temperature = #                                  ; Minimum temperature
max_temperature = #                                  ; Maximum temperature
temp_unit = (C, F)                                   ; Temperature unit
stackable = ?                                        ; Stackable
max_stack_height = ##:(0..)                          ; Max stack height
hazmat = ?                                           ; Hazardous material
fragile = ?                                          ; Fragile handling

{@inventory_item}

; Location
location_id = @inventory_location                    ; Primary storage location
additional_locations[] = @inventory_location         ; Additional locations

; Value
unit_cost = #$:(0..)                                 ; Unit cost
total_value = #$:(0..)                               ; Total inventory value

; Cycle count
{.cycle_count}
last_count_date = date                               ; Last cycle count date
last_count_quantity = ##:(0..)                       ; Last counted quantity
next_count_date = date                               ; Next scheduled count
count_frequency = (annual, daily, monthly, quarterly, weekly)

{@inventory_item}

; ═══════════════════════════════════════════════════════════════════════════════
; RECEIPT
; ═══════════════════════════════════════════════════════════════════════════════

{@receipt}
; Required fields first
receipt_id = :                                      ; Receipt identifier
receipt_date = date                                 ; Receipt date
receipt_type = (asn, blind, purchase_order, return, transfer)

; Optional fields
po_number = :                                        ; Purchase order number
asn_id = :                                           ; ASN identifier
vendor_name = :                                      ; Vendor name
vendor_id = :                                        ; Vendor identifier
carrier = :                                          ; Carrier name
tracking_number = :                                  ; Tracking number
bol_number = :                                       ; BOL number

; Receiving
dock_door = :                                        ; Dock door number
received_by = :                                      ; Received by (user)
appointment_time = timestamp                         ; Appointment time
arrival_time = timestamp                             ; Actual arrival time
unload_start = timestamp                             ; Unload start time
unload_complete = timestamp                          ; Unload complete time

; Expected vs received
expected_pieces = ##:(0..)                           ; Expected pieces
received_pieces = ##:(0..)                           ; Received pieces
expected_pallets = ##:(0..)                          ; Expected pallets
received_pallets = ##:(0..)                          ; Received pallets

; Discrepancies
{.discrepancies}
overages = ##:(0..)                                  ; Overage quantity
shortages = ##:(0..)                                 ; Shortage quantity
damages = ##:(0..)                                   ; Damaged quantity
discrepancy_reason = :                               ; Discrepancy reason
notes = :                                            ; Discrepancy notes

{@receipt}

; Status
status = (cancelled, completed, in_progress, pending, put_away)
status_date = date                                   ; Status date

; ═══════════════════════════════════════════════════════════════════════════════
; PICK ORDER
; ═══════════════════════════════════════════════════════════════════════════════

{@pick_order}
; Required fields first
pick_order_id = :                                   ; Pick order identifier
order_number = :                                    ; Customer order number
priority = (high, normal, rush, standard)           ; Pick priority

; Optional fields
customer_name = :                                    ; Customer name
customer_id = :                                      ; Customer identifier
requested_ship_date = date                           ; Requested ship date
pick_type = (batch, cluster, discrete, wave, zone)   ; Pick method

; Assignment
assigned_to = :                                      ; Assigned picker
assigned_date = timestamp                            ; Assignment timestamp
pick_start = timestamp                               ; Pick start time
pick_complete = timestamp                            ; Pick complete time

; Lines
{.lines[]}
line_number = ##:(1..)                               ; Line number
sku = :                                             ; SKU
description = :                                      ; Item description
ordered_quantity = ##:(0..)                         ; Ordered quantity
picked_quantity = ##:(0..)                           ; Picked quantity
location_id = :                                      ; Pick location
lot_number = :                                       ; Lot number
serial_number = :                                    ; Serial number

{@pick_order}

; Status
status = (
    assigned,
    cancelled,
    completed,
    in_progress,
    packed,
    pending,
    short_picked
)
status_date = date                                   ; Status date

; ═══════════════════════════════════════════════════════════════════════════════
; SHIPMENT ORDER
; ═══════════════════════════════════════════════════════════════════════════════

{@shipment_order}
; Required fields first
shipment_id = :                                     ; Shipment identifier
order_number = :                                    ; Order number

; Optional fields
customer_name = :                                    ; Customer name
customer_id = :                                      ; Customer identifier

; Ship to
{.ship_to}
name = :                                            ; Ship to name
address = @types.address                            ; Ship to address
phone = *@types.phone                                ; Ship to phone
email = *@types.email                                ; Ship to email

{@shipment_order}

; Carrier
carrier_name = :                                     ; Carrier name
carrier_scac = :(4)                                  ; Carrier SCAC
service_level = :                                    ; Service level
tracking_number = :                                  ; Tracking number
pro_number = :                                       ; PRO number
bol_number = :                                       ; BOL number

; Ship date
requested_ship_date = date                           ; Requested ship date
actual_ship_date = date                              ; Actual ship date
estimated_delivery_date = date                       ; Estimated delivery

; Package details
total_packages = ##:(0..)                            ; Total packages
total_pallets = ##:(0..)                             ; Total pallets
total_weight = #:(0..)                               ; Total weight
weight_unit = (kg, lb)                               ; Weight unit

; Packing
packed_by = :                                        ; Packed by (user)
pack_start = timestamp                               ; Pack start time
pack_complete = timestamp                            ; Pack complete time
dock_door = :                                        ; Staging dock door

; Status
status = (
    cancelled,
    manifested,
    packed,
    pending,
    picked,
    shipped
)
status_date = date                                   ; Status date

; ═══════════════════════════════════════════════════════════════════════════════
; ADVANCE SHIP NOTICE (ASN)
; ═══════════════════════════════════════════════════════════════════════════════

{@asn}
; Required fields first
asn_id = :                                          ; ASN identifier
shipment_id = :                                      ; Shipment identifier
expected_delivery_date = date                       ; Expected delivery date

; Optional fields
po_number = :                                        ; Purchase order number
vendor_name = :                                      ; Vendor name
vendor_id = :                                        ; Vendor identifier
ship_from_name = :                                   ; Ship from name
ship_from_address = @types.address                   ; Ship from address

; Carrier
carrier_name = :                                     ; Carrier name
carrier_scac = :(4)                                  ; Carrier SCAC
tracking_number = :                                  ; Tracking number
pro_number = :                                       ; PRO number
bol_number = :                                       ; BOL number

; Shipment details
ship_date = date                                     ; Ship date
total_packages = ##:(0..)                            ; Total packages
total_pallets = ##:(0..)                             ; Total pallets
total_weight = #:(0..)                               ; Total weight
weight_unit = (kg, lb)                               ; Weight unit

; ASN line items
{.lines[]}
line_number = ##:(1..)                               ; Line number
sku = :                                             ; SKU
description = :                                      ; Item description
ordered_quantity = ##:(0..)                          ; Ordered quantity
shipped_quantity = ##:(0..)                         ; Shipped quantity
uom = :                                              ; Unit of measure
lot_number = :                                       ; Lot number
serial_numbers[] = :                                 ; Serial numbers
manufacture_date = date                              ; Manufacture date
expiration_date = date                               ; Expiration date

{@asn}

; Receipt status
received = ?                                         ; ASN received at warehouse
receipt_id = :                                       ; Receipt identifier
receipt_date = date                                  ; Actual receipt date

; Variance
{.variance}
variance_exists = ?                                  ; Variance between ASN and receipt
overage_quantity = ##:(0..)                          ; Overage quantity
shortage_quantity = ##:(0..)                         ; Shortage quantity
damage_quantity = ##:(0..)                           ; Damaged quantity
variance_reason = :                                  ; Variance reason

{@asn}

; Status
status = (cancelled, pending, received, shipped)     ; ASN status
status_date = date                                   ; Status date

; ═══════════════════════════════════════════════════════════════════════════════
; 3PL SERVICE LEVEL AGREEMENT
; ═══════════════════════════════════════════════════════════════════════════════

{@sla_metric}
; Required fields first
metric_name = :                                     ; Metric name
target_value = #                                    ; Target value
measurement_unit = :                                 ; Unit of measure

; Optional fields
actual_value = #                                     ; Actual value
variance = #                                         ; Variance from target
in_compliance = ?                                    ; In compliance with SLA
measurement_period = (annual, daily, monthly, quarterly, weekly)

; ═══════════════════════════════════════════════════════════════════════════════
; 3PL WAREHOUSE AGREEMENT
; ═══════════════════════════════════════════════════════════════════════════════

{@warehouse_agreement}
; Required fields first
agreement_id = :                                    ; Agreement identifier
client_name = :                                     ; Client name
warehouse_id = :                                    ; Warehouse identifier
effective_date = date                               ; Effective date

; Optional fields
expiration_date = date                               ; Expiration date
agreement_type = (dedicated, multi_client, shared)   ; Agreement type
term_months = ##:(1..)                               ; Term in months
auto_renew = ?                                       ; Auto-renew flag
notice_days = ##:(30..)                              ; Termination notice days

; Services included
{.services}
receiving = ?                                        ; Receiving service
storage = ?                                          ; Storage service
picking = ?                                          ; Picking service
packing = ?                                          ; Packing service
shipping = ?                                         ; Shipping service
kitting = ?                                          ; Kitting service
labeling = ?                                         ; Labeling service
returns_processing = ?                               ; Returns processing
inventory_management = ?                             ; Inventory management
order_management = ?                                 ; Order management
transportation_management = ?                        ; Transportation management
value_added_services = ?                             ; Value-added services

{@warehouse_agreement}

; Dedicated space
{.space}
dedicated_square_feet = ##:(0..)                     ; Dedicated square footage
dedicated_pallet_positions = ##:(0..)                ; Dedicated pallet positions
shared_space = ?                                     ; Shared space allowed
min_billable_space = ##:(0..)                        ; Minimum billable space

{@warehouse_agreement}

; Billing rates
{.rates}
receiving_rate = #$                                  ; Receiving rate per unit
storage_rate = #$                                    ; Storage rate per pallet/month
picking_rate = #$                                    ; Picking rate per line
packing_rate = #$                                    ; Packing rate per unit
shipping_rate = #$                                   ; Shipping rate per order
handling_rate = #$                                   ; Handling rate per unit
minimum_monthly_charge = #$:(0..)                    ; Minimum monthly charge

{@warehouse_agreement}

; SLA metrics
sla_metrics[] = @sla_metric                          ; SLA metrics

; Common SLA targets
{.kpis}
order_accuracy_pct = #:(0..100)                      ; Order accuracy target
on_time_shipment_pct = #:(0..100)                    ; On-time shipment target
inventory_accuracy_pct = #:(0..100)                  ; Inventory accuracy target
damage_rate_pct = #:(0..100)                         ; Acceptable damage rate
order_cycle_time_hours = ##:(0..)                    ; Order cycle time target

{@warehouse_agreement}

; Insurance and liability
{.insurance}
client_insurance_required = #$:(0..)                 ; Client insurance requirement
provider_insurance_coverage = #$:(0..)               ; Provider insurance coverage
liability_limit = #$:(0..)                           ; Liability limit per incident
claims_process = :                                   ; Claims process description

{@warehouse_agreement}

; Status
status = (active, cancelled, expired, pending, terminated)
status_date = date                                   ; Status date
termination_reason = :                               ; Termination reason

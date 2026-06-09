; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Logistics Freight Documentation Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Freight documentation covering bills of lading, air waybills, freight bills,
; claims, and rating information (NMFC class, tariff, contract rates).
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.logistics.freight"
version = "1.0.0"
title = "Logistics Freight Documentation Schema"
description = "Freight bills, bills of lading, waybills, claims, and rating"

{$derivation}
source[0].authority = "49 CFR"
source[0].citation = "Part 373 - Receipts and Bills; Part 370 - Principles and Practices for Investigation of Freight Loss and Damage Claims"
source[0].url = "https://www.ecfr.gov/current/title-49/subtitle-B/chapter-III/subchapter-B"

source[1].authority = "Uniform Bill of Lading"
source[1].citation = "Uniform Straight Bill of Lading and Uniform Order Bill of Lading"
source[1].url = "https://www.law.cornell.edu/ucc/7/7-104"

source[2].authority = "Carmack Amendment"
source[2].citation = "49 USC 14706 - Liability of carriers for property loss or damage"
source[3].url = "https://www.govinfo.gov/content/pkg/USCODE-2011-title49/html/USCODE-2011-title49-subtitleIV-partB-chap147-sec14706.htm"

source[3].authority = "IATA"
source[3].citation = "IATA Air Waybill Standards"
source[3].url = "https://www.iata.org/en/programs/cargo/"

source[4].authority = "NMFC"
source[4].citation = "National Motor Freight Classification"
source[4].url = "https://www.nmfta.org/nmfc"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial freight documentation schema"
changelog[0].rationale = "BOL, AWB, freight bill, claims, and rating structures"

; ═══════════════════════════════════════════════════════════════════════════════
; CHARGE ITEM
; ═══════════════════════════════════════════════════════════════════════════════

{@charge_item}
; Required fields first
description = :                                     ; Charge description
amount = #$                                         ; Charge amount

; Optional fields
code = :                                             ; Charge code
type = (
    accessorial,
    base_freight,
    detention,
    fuel_surcharge,
    layover,
    liftgate,
    lumper,
    redelivery,
    residential,
    storage,
    tonu,
    waiting_time
)
quantity = #:(0..)                                   ; Quantity
rate = #$                                            ; Rate per unit
unit = :                                             ; Unit of measure
taxable = ?                                          ; Subject to tax

; ═══════════════════════════════════════════════════════════════════════════════
; FREIGHT LINE ITEM
; ═══════════════════════════════════════════════════════════════════════════════

{@freight_line_item}
; Required fields first
description = :                                     ; Item description
pieces = ##:(0..)                                   ; Number of pieces

; Optional fields
weight = #:(0..)                                     ; Weight
weight_unit = (kg, lb)                               ; Weight unit
commodity_class = :                                  ; Freight class or commodity code
nmfc = :                                             ; NMFC item number
nmfc_sub = :                                         ; NMFC sub

; Dimensions
length = #:(0..)                                     ; Length
width = #:(0..)                                      ; Width
height = #:(0..)                                     ; Height
dimension_unit = (cm, in)                            ; Dimension unit

; Package type
package_type = (
    bag,
    bale,
    barrel,
    box,
    bundle,
    carton,
    case,
    container,
    crate,
    drum,
    pail,
    pallet,
    reel,
    roll,
    skid,
    tank,
    tote
)

; Flags
hazmat = ?                                           ; Hazardous material
un_number = :if hazmat = true                        ; UN number
hazmat_class = :if hazmat = true                     ; Hazard class

stackable = ?                                        ; Stackable flag
fragile = ?                                          ; Fragile flag

; Value
declared_value = #$:(0..)                            ; Declared value

; ═══════════════════════════════════════════════════════════════════════════════
; BILL OF LADING
; ═══════════════════════════════════════════════════════════════════════════════

{@bill_of_lading}
; Required fields first
bol_number = :                                      ; BOL number
bol_date = date                                     ; BOL issue date
type = (
    express,                                         ; Express BOL
    inland,                                          ; Inland waterway
    multimodal,                                      ; Combined transport
    ocean,                                           ; Ocean BOL
    order,                                           ; Order (negotiable) BOL
    straight,                                        ; Straight (non-negotiable) BOL
    through                                          ; Through BOL
)

; Parties
shipper_name = :                                    ; Shipper name
shipper_address = @types.address                    ; Shipper address
consignee_name = :                                  ; Consignee name
consignee_address = @types.address                  ; Consignee address

; Optional fields
pro_number = :                                       ; Progressive number
scac = :(4)                                          ; Standard Carrier Alpha Code
carrier_name = :                                     ; Carrier name
carrier_address = @types.address                     ; Carrier address

; Additional parties
notify_party_name = :                                ; Notify party
notify_party_address = @types.address                ; Notify party address
third_party_name = :                                 ; Third party (freight charges)
third_party_address = @types.address                 ; Third party address

; Shipment details
master_bol = :                                       ; Master BOL if house BOL
house_bol = :                                        ; House BOL number
booking_number = :                                   ; Booking reference
purchase_order = :                                   ; PO number
customer_reference = :                               ; Customer reference
export_reference = :                                 ; Export reference
import_reference = :                                 ; Import reference

; Routing
{.origin}
city = :                                             ; Origin city
state_province = :(2)                                ; Origin state/province
country = :(2)                                       ; Origin country
postal_code = :                                      ; Origin postal code

{@bill_of_lading}

{.destination}
city = :                                             ; Destination city
state_province = :(2)                                ; Destination state/province
country = :(2)                                       ; Destination country
postal_code = :                                      ; Destination postal code

{@bill_of_lading}

{.routing}
port_of_loading = :                                  ; Port of loading (ocean/air)
port_of_discharge = :                                ; Port of discharge
place_of_receipt = :                                 ; Place of receipt (multimodal)
place_of_delivery = :                                ; Place of delivery (multimodal)
vessel_voyage = :                                    ; Vessel/voyage (ocean)
carrier_routing = :                                  ; Carrier routing instructions

{@bill_of_lading}

; Freight details
line_items[] = @freight_line_item                    ; Freight line items
total_pieces = ##:(0..)                              ; Total pieces
total_weight = #:(0..)                               ; Total weight
weight_unit = (kg, lb)                               ; Weight unit

; Terms
freight_charges = (collect, prepaid, third_party)    ; Freight charges
cod_amount = #$:(0..)                                ; COD amount
declared_value = #$:(0..)                            ; Declared value for liability
insured_value = #$:(0..)                             ; Insured value

; Special instructions
special_instructions = :                             ; Special handling instructions
delivery_instructions = :                            ; Delivery instructions

; Flags
negotiable = ?                                       ; Negotiable (order) BOL
original = ?                                         ; Original BOL
corrected = ?                                        ; Corrected BOL
duplicate = ?                                        ; Duplicate BOL

; Signatures
{.signatures}
shipper_signature = :                                ; Shipper signature
shipper_date = date                                  ; Shipper signature date
carrier_signature = :                                ; Carrier signature
carrier_date = date                                  ; Carrier signature date
consignee_signature = :                              ; Consignee signature (delivery)
consignee_date = date                                ; Consignee signature date

{@bill_of_lading}

; Subject to terms
subject_to_tariff = :                                ; Subject to tariff name/number
subject_to_section_7 = ?true                         ; Subject to Section 7 (liability)

; ═══════════════════════════════════════════════════════════════════════════════
; AIR WAYBILL
; ═══════════════════════════════════════════════════════════════════════════════

{@air_waybill}
; Required fields first
awb_number = :                                      ; Air waybill number (11 digits: 3-8)
awb_type = (house, master)                          ; AWB type
issue_date = date                                   ; Issue date

; Parties
shipper_name = :                                    ; Shipper name
shipper_address = @types.address                    ; Shipper address
shipper_account = :                                  ; Shipper account number
consignee_name = :                                  ; Consignee name
consignee_address = @types.address                  ; Consignee address
consignee_account = :                                ; Consignee account number

issuing_carrier = :                                 ; Issuing carrier name
issuing_carrier_code = :(3)                          ; Issuing carrier IATA code

; Optional fields
agent_name = :                                       ; Agent name
agent_code = :(7)                                    ; Agent IATA code
agent_city = :                                       ; Agent city

; Master/House relationship
master_awb = :if awb_type = house                    ; Master AWB number
house_awbs[] = :if awb_type = master                 ; House AWB numbers

; Routing
{.routing}
origin_airport = :(3)                               ; Origin airport code (IATA)
destination_airport = :(3)                          ; Destination airport code
requested_routing = :                                ; Requested routing
actual_routing = :                                   ; Actual routing
flight_number = :                                    ; Flight number
flight_date = date                                   ; Flight date

{@air_waybill}

; Shipment details
pieces = ##:(1..)                                   ; Number of pieces
gross_weight = #:(0..)                              ; Gross weight
weight_unit = :(2)                                  ; Weight unit (KG or LB)
chargeable_weight = #:(0..)                          ; Chargeable weight
volume = #:(0..)                                     ; Volume
volume_unit = (cbm, cuft)                            ; Volume unit

; Nature and quantity of goods
commodity_description = :                           ; Commodity description
harmonized_code = :                                  ; HS code
dimensions = :                                       ; Dimensions

; Special handling
{.handling}
special_handling_codes[] = :                         ; SHC codes (e.g., PER, AVI, DGR)
handling_information = :                             ; Handling information

{@air_waybill}

; Charges
{.charges}
weight_charge = #$                                   ; Weight charge
valuation_charge = #$                                ; Valuation charge
tax = #$                                             ; Tax
total_other_charges_due_carrier = #$                 ; Other charges due carrier
total_other_charges_due_agent = #$                   ; Other charges due agent
total_charges = #$                                   ; Total charges
currency = :(3) "USD"                                ; Currency code
charge_code = (C, P):if awb_type = master            ; C=collect, P=prepaid
payment_type = (CA, CC):if awb_type = master         ; CA=cash, CC=credit card

{@air_waybill}

; Declared value
declared_value_carriage = #$:(0..)                   ; Declared value for carriage
declared_value_customs = #$:(0..)                    ; Declared value for customs

; Insurance
insurance_amount = #$:(0..)                          ; Insurance amount requested

; Execution
{.execution}
place_of_execution = :                               ; Place
date_of_execution = date                             ; Date
signature_of_shipper = :                             ; Shipper signature
signature_of_carrier = :                             ; Carrier signature

{@air_waybill}

; ═══════════════════════════════════════════════════════════════════════════════
; FREIGHT BILL
; ═══════════════════════════════════════════════════════════════════════════════

{@freight_bill}
; Required fields first
invoice_number = :                                  ; Freight bill/invoice number
invoice_date = date                                 ; Invoice date
due_date = date                                      ; Payment due date

; References
pro_number = :                                       ; PRO number
bol_number = :                                       ; BOL number
shipment_id = :                                      ; Shipment identifier
po_number = :                                        ; Purchase order number

; Parties
bill_to_name = :                                    ; Bill to party
bill_to_address = @types.address                     ; Bill to address
bill_to_account = :                                  ; Bill to account number

shipper_name = :                                     ; Shipper name
consignee_name = :                                   ; Consignee name
carrier_name = :                                    ; Carrier name
scac = :(4)                                          ; Carrier SCAC

; Shipment info
ship_date = date                                     ; Ship date
delivery_date = date                                 ; Delivery date
origin = :                                           ; Origin location
destination = :                                      ; Destination location

; Weight and pieces
total_weight = #:(0..)                               ; Total weight
weight_unit = (kg, lb)                               ; Weight unit
total_pieces = ##:(0..)                              ; Total pieces

; Charges
charges[] = @charge_item                             ; Itemized charges

{.totals}
subtotal = #$                                       ; Subtotal before tax
tax = #$                                             ; Tax amount
total = #$                                          ; Total amount due
amount_paid = #$                                     ; Amount paid
balance_due = #$                                     ; Balance due

{@freight_bill}

; Payment terms
payment_terms = (
    advance,
    collect,
    net_10,
    net_15,
    net_30,
    net_45,
    net_60,
    net_90,
    prepaid,
    quick_pay,
    third_party
)
discount_terms = :                                   ; Discount terms (e.g., "2/10 net 30")

; Status
status = (disputed, outstanding, overdue, paid, partial_payment, submitted, void)
payment_date = date                                  ; Payment date
payment_method = :                                   ; Payment method
payment_reference = :                                ; Payment reference/check number

; Audit
{.audit}
audited = ?                                          ; Freight bill audited
audited_date = date                                  ; Audit date
audited_by = :                                       ; Audited by
original_total = #$                                  ; Original billed amount
audit_adjustments = #$                               ; Audit adjustments
audit_notes = :                                      ; Audit notes

{@freight_bill}

; ═══════════════════════════════════════════════════════════════════════════════
; FREIGHT CLAIM
; ═══════════════════════════════════════════════════════════════════════════════

{@freight_claim}
; Required fields first
claim_number = :                                    ; Claim number
claim_date = date                                   ; Claim filed date
claim_type = (damage, loss, overcharge, shortage)   ; Claim type

; Shipment reference
pro_number = :                                       ; PRO number
bol_number = :                                       ; BOL number
invoice_number = :                                   ; Invoice number
shipment_date = date                                 ; Shipment date
delivery_date = date                                 ; Delivery date

; Parties
claimant_name = :                                   ; Claimant name
claimant_address = @types.address                    ; Claimant address
claimant_contact = :                                 ; Claimant contact person
claimant_phone = *@types.phone                       ; Claimant phone
claimant_email = *@types.email                       ; Claimant email

carrier_name = :                                     ; Carrier name
carrier_scac = :(4)                                  ; Carrier SCAC

; Claim details
claimed_amount = #$:(0..)                           ; Amount claimed
currency = :(3) "USD"                                ; Currency

; Loss/Damage details
description = :                                     ; Description of claim
commodity_description = :                            ; Commodity description
pieces_affected = ##:(0..)                           ; Pieces lost/damaged/short
weight_affected = #:(0..)                            ; Weight affected

; Cause
cause = :                                            ; Cause of loss/damage
cause_code = :                                       ; Standardized cause code
where_discovered = :                                 ; Where loss/damage discovered

; Supporting documentation
{.documentation}
photographs = ?                                      ; Photographs attached
inspection_report = ?                                ; Inspection report attached
invoice = ?                                          ; Invoice attached
proof_of_delivery = ?                                ; POD attached
repair_estimate = ?                                  ; Repair estimate attached
salvage_report = ?                                   ; Salvage report attached

{@freight_claim}

; Status and resolution
status = (
    acknowledged,
    approved,
    closed,
    denied,
    investigation,
    litigation,
    open,
    paid,
    settled
)
status_date = date                                   ; Status date

{.resolution}
approved_amount = #$:(0..)                           ; Approved amount
paid_amount = #$:(0..)                               ; Amount paid
payment_date = date                                  ; Payment date
payment_reference = :                                ; Check/payment reference
denial_reason = :                                    ; Reason for denial
settlement_notes = :                                 ; Settlement notes

{@freight_claim}

; Legal
{.legal}
statute_of_limitations = date                        ; Claim filing deadline (9 months from delivery)
suit_filed = ?                                       ; Lawsuit filed
suit_date = date                                     ; Lawsuit filing date
case_number = :                                      ; Case number
attorney = :                                         ; Attorney name

{@freight_claim}

; ═══════════════════════════════════════════════════════════════════════════════
; NMFC CLASSIFICATION
; ═══════════════════════════════════════════════════════════════════════════════

{@nmfc_classification}
; Required fields first
nmfc_item = :                                       ; NMFC item number
class = (50, 55, 60, 65, 70, 77.5, 85, 92.5, 100, 110, 125, 150, 175, 200, 250, 300, 400, 500)

; Optional fields
sub = :                                              ; Sub-classification
description = :                                      ; Item description
commodity_group = :                                  ; Commodity grouping
notes = :                                            ; Classification notes

; Density (lbs per cubic foot) - key rating factor
min_density = #:(0..)                                ; Minimum density
max_density = #:(0..)                                ; Maximum density

; ═══════════════════════════════════════════════════════════════════════════════
; TARIFF RATE
; ═══════════════════════════════════════════════════════════════════════════════

{@tariff_rate}
; Required fields first
tariff_name = :                                     ; Tariff name
rate = #$:(0..)                                     ; Rate amount
rate_basis = (cwt, flat, per_mile, per_shipment)    ; Rate basis

; Optional fields
tariff_number = :                                    ; Tariff number
item_number = :                                      ; Item number within tariff
effective_date = date                                ; Effective date
expiration_date = date                               ; Expiration date

; Geographic scope
origin_point = :                                     ; Origin point code
origin_zone = :                                      ; Origin zone
destination_point = :                                ; Destination point code
destination_zone = :                                 ; Destination zone

; Applicable freight class
freight_class = (50, 55, 60, 65, 70, 77.5, 85, 92.5, 100, 110, 125, 150, 175, 200, 250, 300, 400, 500)

; Weight breaks
min_weight = #:(0..)                                 ; Minimum weight
max_weight = #:(0..)                                 ; Maximum weight

; Additional charges
{.charges}
fuel_surcharge_pct = #:(0..100)                      ; Fuel surcharge percent
minimum_charge = #$:(0..)                            ; Minimum charge
deficit_weight_charge = #$                           ; Deficit weight charge

{@tariff_rate}

; ═══════════════════════════════════════════════════════════════════════════════
; CONTRACT RATE
; ═══════════════════════════════════════════════════════════════════════════════

{@contract_rate}
; Required fields first
contract_id = :                                     ; Contract identifier
customer_name = :                                   ; Customer name
rate = #$                                           ; Contract rate
rate_basis = (cwt, flat, per_mile, per_shipment)    ; Rate basis

; Optional fields
contract_number = :                                  ; Contract number
effective_date = date                                ; Effective date
expiration_date = date                               ; Expiration date

; Lane
origin_city = :                                      ; Origin city
origin_state = :(2)                                  ; Origin state/province
origin_postal = :                                    ; Origin postal/ZIP
destination_city = :                                 ; Destination city
destination_state = :(2)                             ; Destination state/province
destination_postal = :                               ; Destination postal/ZIP

; Freight class
freight_class = (50, 55, 60, 65, 70, 77.5, 85, 92.5, 100, 110, 125, 150, 175, 200, 250, 300, 400, 500)

; Weight thresholds
min_weight = #:(0..)                                 ; Minimum weight
max_weight = #:(0..)                                 ; Maximum weight

; Volume commitments
annual_shipment_minimum = ##:(0..)                   ; Annual shipment minimum
annual_revenue_minimum = #$:(0..)                    ; Annual revenue minimum

; Accessorial rates
{.accessorial}
fuel_surcharge_pct = #:(0..100)                      ; Fuel surcharge percent
detention_rate = #$                                  ; Detention rate (per hour)
layover_rate = #$                                    ; Layover rate (per day)
liftgate_charge = #$                                 ; Liftgate charge
residential_charge = #$                              ; Residential delivery charge

{@contract_rate}

; ═══════════════════════════════════════════════════════════════════════════════
; SPOT RATE
; ═══════════════════════════════════════════════════════════════════════════════

{@spot_rate}
; Required fields first
rate = #$                                           ; Spot rate
rate_basis = (flat, per_mile)                       ; Rate basis (usually flat or per-mile)
quote_date = date                                   ; Quote date
valid_until = date                                  ; Valid until date

; Optional fields
quote_id = :                                         ; Quote identifier
carrier_name = :                                     ; Carrier name
carrier_scac = :(4)                                  ; Carrier SCAC

; Lane
origin = :                                          ; Origin location
destination = :                                     ; Destination location
miles = ##:(0..)                                     ; Lane miles

; Load details
equipment_type = (
    dry_van,
    flatbed,
    power_only,
    reefer,
    step_deck,
    tanker
)
load_weight = #:(0..)                                ; Load weight
load_type = (full, ltl, partial, volume)             ; Load type

; Dates
pickup_date = date                                   ; Pickup date
delivery_date = date                                 ; Delivery date

; All-in rate
all_in = ?                                           ; All-in rate (no accessorials)
fuel_included = ?                                    ; Fuel surcharge included

; Market conditions
market_rate = #$                                     ; Average market rate
rate_vs_market = #                                   ; Percent above/below market

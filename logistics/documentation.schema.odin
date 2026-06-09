; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Logistics Documentation Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Logistics documentation covering commercial documents, certificates, dangerous
; goods declarations, and export control documentation.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.logistics.documentation"
version = "1.0.0"
title = "Logistics Documentation Schema"
description = "Commercial documents, certificates, dangerous goods, and export control"

{$derivation}
source[0].authority = "ICC"
source[0].citation = "ICC Uniform Customs and Practice for Documentary Credits (UCP 600)"
source[0].url = "https://iccwbo.org/business-solutions/incoterms-rules/incoterms-2020/"

source[1].authority = "IATA"
source[1].citation = "IATA Dangerous Goods Regulations (DGR)"
source[1].url = "https://www.iata.org/en/publications/dgr/"

source[2].authority = "IMO"
source[2].citation = "IMDG Code - International Maritime Dangerous Goods Code"
source[2].url = "https://www.imo.org/en/OurWork/Safety/Pages/DangerousGoods-default.aspx"

source[3].authority = "49 CFR"
source[3].citation = "Part 172 - Hazardous Materials Table, Special Provisions, Hazardous Materials Communications, Emergency Response Information, Training Requirements, and Security Plans"
source[3].url = "https://www.ecfr.gov/current/title-49/subtitle-B/chapter-I/subchapter-C/part-172"

source[4].authority = "15 CFR"
source[4].citation = "Export Administration Regulations (EAR)"
source[4].url = "https://www.ecfr.gov/current/title-15/subtitle-B/chapter-VII/subchapter-C"

source[5].authority = "CBP"
source[5].citation = "19 CFR Part 192 - Export Control"
source[5].url = "https://www.ecfr.gov/current/title-19/chapter-I/part-192"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial logistics documentation schema"
changelog[0].rationale = "Commercial docs, certificates, DG, export control structures"

; ═══════════════════════════════════════════════════════════════════════════════
; COMMERCIAL INVOICE LINE
; ═══════════════════════════════════════════════════════════════════════════════

{@commercial_invoice_line}
; Required fields first
line_number = ##:(1..)                              ; Line number
description = :                                     ; Item description
quantity = #:(0..)                                  ; Quantity
unit_price = #$:(0..)                               ; Unit price

; Optional fields
hs_code = :(6..10)                                   ; Harmonized System code
part_number = :                                      ; Manufacturer part number
country_of_origin = :(2)                             ; ISO country code
unit_of_measure = :                                  ; Unit of measure
weight = #:(0..)                                     ; Weight per unit
weight_unit = (kg, lb)                               ; Weight unit

; Totals
line_total = #$:(0..)                                ; Line total
currency = :(3) "USD"                                ; Currency code

:invariant line_total >= 0

; ═══════════════════════════════════════════════════════════════════════════════
; COMMERCIAL INVOICE
; ═══════════════════════════════════════════════════════════════════════════════

{@commercial_invoice}
; Required fields first
invoice_number = :                                  ; Invoice number
invoice_date = date                                 ; Invoice date

; Seller/Exporter
seller_name = :                                     ; Seller name
seller_address = @types.address                     ; Seller address
seller_tax_id = :                                    ; Seller tax ID/VAT number
seller_phone = *@types.phone                         ; Seller phone
seller_email = *@types.email                         ; Seller email

; Buyer/Importer
buyer_name = :                                      ; Buyer name
buyer_address = @types.address                      ; Buyer address
buyer_tax_id = :                                     ; Buyer tax ID/VAT number
buyer_phone = *@types.phone                          ; Buyer phone
buyer_email = *@types.email                          ; Buyer email

; Consignee (if different from buyer)
consignee_name = :                                   ; Consignee name
consignee_address = @types.address                   ; Consignee address

; Notify party
notify_name = :                                      ; Notify party name
notify_address = @types.address                      ; Notify party address

; Shipment references
po_number = :                                        ; Purchase order number
contract_number = :                                  ; Contract number
export_reference = :                                 ; Export reference
import_reference = :                                 ; Import reference
lc_number = :                                        ; Letter of credit number

; Shipment details
{.shipment}
port_of_loading = :                                  ; Port of loading
port_of_discharge = :                                ; Port of discharge
country_of_export = :(2)                             ; Exporting country
country_of_import = :(2)                             ; Importing country
terms_of_sale = (CFR, CIF, CIP, CPT, DAP, DDP, DPU, EXW, FAS, FCA, FOB)
carrier_name = :                                     ; Carrier name
vessel_voyage = :                                    ; Vessel/voyage or flight
bill_of_lading = :                                   ; Bill of lading number
departure_date = date                                ; Departure date

{@commercial_invoice}

; Line items
line_items[] = @commercial_invoice_line              ; Invoice line items

; Invoice totals
{.totals}
subtotal = #$:(0..)                                 ; Subtotal
freight_charges = #$                                 ; Freight charges
insurance_charges = #$                               ; Insurance charges
other_charges = #$                                   ; Other charges
discount = #$                                        ; Discount amount
tax = #$                                             ; Tax amount
total = #$:(0..)                                    ; Invoice total
currency = :(3)                                     ; Currency code
exchange_rate = #:(0..)                              ; Exchange rate (if applicable)

{@commercial_invoice}

; Payment terms
payment_terms = :                                    ; Payment terms
payment_method = (
    advance_payment,
    cash_against_documents,
    consignment,
    documentary_collection,
    letter_of_credit,
    open_account
)
payment_due_date = date                              ; Payment due date

; Declarations
{.declarations}
true_and_correct = ?                                 ; Declaration of truth
signature = :                                        ; Authorized signature
signer_name = :                                      ; Name of signer
signer_title = :                                     ; Title of signer
signature_date = date                                ; Signature date
signature_place = :                                  ; Place of signature

{@commercial_invoice}

; ═══════════════════════════════════════════════════════════════════════════════
; PACKING LIST LINE
; ═══════════════════════════════════════════════════════════════════════════════

{@packing_list_line}
; Required fields first
line_number = ##:(1..)                              ; Line number
description = :                                     ; Item description
quantity = #:(0..)                                  ; Quantity
unit_of_measure = :                                  ; Unit of measure

; Optional fields
package_number = :                                   ; Package/carton number
hs_code = :(6..10)                                   ; HS code
part_number = :                                      ; Part number

; Weight and dimensions
gross_weight = #:(0..)                               ; Gross weight
net_weight = #:(0..)                                 ; Net weight
weight_unit = (kg, lb)                               ; Weight unit
length = #:(0..)                                     ; Length
width = #:(0..)                                      ; Width
height = #:(0..)                                     ; Height
dimension_unit = (cm, in, m)                         ; Dimension unit
volume = #:(0..)                                     ; Volume
volume_unit = (cbm, cuft)                            ; Volume unit

; ═══════════════════════════════════════════════════════════════════════════════
; PACKING LIST
; ═══════════════════════════════════════════════════════════════════════════════

{@packing_list}
; Required fields first
packing_list_number = :                             ; Packing list number
packing_list_date = date                            ; Packing list date

; References
invoice_number = :                                   ; Related invoice number
po_number = :                                        ; Purchase order number
shipment_id = :                                      ; Shipment identifier

; Shipper
shipper_name = :                                    ; Shipper name
shipper_address = @types.address                    ; Shipper address

; Consignee
consignee_name = :                                  ; Consignee name
consignee_address = @types.address                  ; Consignee address

; Shipment details
{.shipment}
carrier_name = :                                     ; Carrier name
vessel_voyage = :                                    ; Vessel/voyage or flight
port_of_loading = :                                  ; Port of loading
port_of_discharge = :                                ; Port of discharge
container_numbers[] = :                              ; Container numbers
seal_numbers[] = :                                   ; Seal numbers

{@packing_list}

; Packaging details
{.packages}
total_packages = ##:(0..)                            ; Total number of packages
total_pallets = ##:(0..)                             ; Total pallets
package_type = :                                     ; Package type
gross_weight = #:(0..)                               ; Total gross weight
net_weight = #:(0..)                                 ; Total net weight
weight_unit = (kg, lb)                               ; Weight unit
total_volume = #:(0..)                               ; Total volume
volume_unit = (cbm, cuft)                            ; Volume unit

{@packing_list}

; Line items
line_items[] = @packing_list_line                    ; Packing list line items

; Marks and numbers
shipping_marks = :                                   ; Shipping marks
handling_marks = :                                   ; Handling marks
container_marks = :                                  ; Container marks

; ═══════════════════════════════════════════════════════════════════════════════
; SHIPPER'S LETTER OF INSTRUCTION
; ═══════════════════════════════════════════════════════════════════════════════

{@shippers_letter_of_instruction}
; Required fields first
sli_number = :                                      ; SLI number
sli_date = date                                     ; SLI date

; Shipper
shipper_name = :                                    ; Shipper name
shipper_address = @types.address                    ; Shipper address
shipper_phone = *@types.phone                        ; Shipper phone
shipper_email = *@types.email                        ; Shipper email
shipper_ein = :                                      ; Shipper EIN

; Consignee
consignee_name = :                                  ; Ultimate consignee name
consignee_address = @types.address                  ; Ultimate consignee address
consignee_country = :(2)                            ; Consignee country

; Intermediate consignee/Freight forwarder
forwarding_agent = :                                 ; Forwarding agent name
forwarding_agent_address = @types.address            ; Forwarding agent address

; Shipment details
{.shipment}
export_reference = :                                 ; Export reference
carrier_name = :                                     ; Carrier name
port_of_export = :                                   ; Port of export
port_of_unlading = :                                 ; Port of unlading
loading_pier = :                                     ; Loading pier
method_of_transport = (air, ocean, rail, truck)      ; Method of transport

{@shippers_letter_of_instruction}

; Commodity details
{.commodities[]}
description = :                                     ; Commodity description
schedule_b_number = :(10)                            ; Schedule B number (export classification)
eccn = :                                             ; Export Control Classification Number
quantity = #:(0..)                                   ; Quantity
unit_of_measure = :                                  ; Unit of measure
value = #$:(0..)                                     ; Value
weight = #:(0..)                                     ; Weight
weight_unit = (kg, lb)                               ; Weight unit
country_of_origin = :(2)                             ; Country of origin

{@shippers_letter_of_instruction}

; Export license
export_license_required = ?                          ; Export license required
export_license_number = :if export_license_required = true
export_license_symbol = :if export_license_required = true
license_exception = :                                ; License exception code

; Routed export transaction
routed_export = ?                                    ; Routed export transaction
usppi = :if routed_export = false                    ; US Principal Party in Interest
fppi = :if routed_export = true                      ; Foreign Principal Party in Interest

; Special handling
special_instructions = :                             ; Special handling instructions
hazardous_materials = ?                              ; Contains hazmat
dg_declaration_attached = ?:if hazardous_materials = true

; Signature
{.signature}
authorized_signature = :                             ; Authorized signature
signer_name = :                                      ; Name of signer
signer_title = :                                     ; Title of signer
signature_date = date                                ; Signature date

{@shippers_letter_of_instruction}

; ═══════════════════════════════════════════════════════════════════════════════
; CERTIFICATE OF ORIGIN
; ═══════════════════════════════════════════════════════════════════════════════

{@certificate_of_origin}
; Required fields first
certificate_number = :                              ; Certificate number
issue_date = date                                   ; Issue date
exporter_name = :                                   ; Exporter name
exporter_address = @types.address                   ; Exporter address

; Consignee
consignee_name = :                                   ; Consignee name
consignee_address = @types.address                   ; Consignee address

; Commodity
commodity_description = :                           ; Description of goods
hs_code = :(6..10)                                   ; HS code
country_of_origin = :(2)                            ; Country of origin
invoice_number = :                                   ; Invoice number
invoice_date = date                                  ; Invoice date

; Certification
{.certification}
certify_statement = :                                ; Certification statement
certified_by = :                                     ; Certifying authority
certifier_signature = :                              ; Signature
certifier_title = :                                  ; Title
certification_date = date                            ; Certification date
certification_place = :                              ; Place of certification
seal_stamp = ^                                       ; Official seal/stamp image

{@certificate_of_origin}

; Type
certificate_type = (
    chamber_of_commerce,
    form_a,                                          ; GSP Form A
    nafta,                                           ; NAFTA certificate
    non_preferential,                                ; Non-preferential
    usmca                                            ; USMCA certificate
)

; ═══════════════════════════════════════════════════════════════════════════════
; CERTIFICATE OF INSURANCE
; ═══════════════════════════════════════════════════════════════════════════════

{@certificate_of_insurance}
; Required fields first
certificate_number = :                              ; Certificate number
issue_date = date                                   ; Issue date
policy_number = :                                   ; Policy number

; Insurer
insurance_company = :                               ; Insurance company name
insurance_company_address = @types.address           ; Insurer address

; Insured
insured_name = :                                    ; Name of insured
insured_address = @types.address                     ; Insured address

; Shipment
{.shipment}
description_of_goods = :                             ; Description of goods
conveyance = :                                       ; Vessel/flight/vehicle
departure_date = date                                ; Departure date
from_location = :                                    ; From
to_location = :                                      ; To
invoice_number = :                                   ; Invoice number

{@certificate_of_insurance}

; Coverage
{.coverage}
insured_amount = #$:(0..)                           ; Insured amount
currency = :(3) "USD"                                ; Currency
coverage_type = (all_risks, fpa, wpa)                ; Coverage type (Free of Particular Average, With Particular Average)
deductible = #$:(0..)                                ; Deductible amount
additional_coverage = :                              ; Additional coverage details

{@certificate_of_insurance}

; Validity
valid_from = date                                    ; Valid from date
valid_to = date                                      ; Valid to date

; Signature
authorized_signature = :                             ; Signature
signer_name = :                                      ; Signer name
signer_title = :                                     ; Signer title
signature_date = date                                ; Signature date

; ═══════════════════════════════════════════════════════════════════════════════
; INSPECTION CERTIFICATE
; ═══════════════════════════════════════════════════════════════════════════════

{@inspection_certificate}
; Required fields first
certificate_number = :                              ; Certificate number
issue_date = date                                   ; Issue date
inspection_date = date                              ; Inspection date
inspection_type = (
    pre_shipment,
    quality,
    quantity,
    sampling,
    weight
)

; Inspected goods
commodity_description = :                           ; Description of goods
quantity = #:(0..)                                   ; Quantity inspected
invoice_number = :                                   ; Invoice number
po_number = :                                        ; PO number

; Inspection results
{.results}
passed = ?                                           ; Inspection passed
findings = :                                         ; Inspection findings
defects_noted = :                                    ; Defects noted
grade = :                                            ; Grade/quality level
weight_verified = #:(0..):if inspection_type = weight
weight_unit = (kg, lb, ton):if inspection_type = weight

{@inspection_certificate}

; Inspector
inspection_company = :                              ; Inspection company
inspector_name = :                                   ; Inspector name
inspector_signature = :                              ; Inspector signature
inspector_license = :                                ; Inspector license number

; Location
inspection_location = :                              ; Inspection location
inspection_address = @types.address                  ; Inspection address

; ═══════════════════════════════════════════════════════════════════════════════
; PHYTOSANITARY CERTIFICATE
; ═══════════════════════════════════════════════════════════════════════════════

{@phytosanitary_certificate}
; Required fields first
certificate_number = :                              ; Certificate number
issue_date = date                                   ; Issue date
issuing_authority = :                               ; Issuing authority (NPPO)
issuing_country = :(2)                              ; Issuing country

; Exporter/Consignor
exporter_name = :                                   ; Exporter name
exporter_address = @types.address                   ; Exporter address

; Consignee
consignee_name = :                                   ; Consignee name
consignee_address = @types.address                   ; Consignee address

; Plant products
{.products}
description = :                                     ; Botanical name and description
quantity = #:(0..)                                   ; Quantity
country_of_origin = :(2)                             ; Country of origin
intended_use = :                                     ; Intended use

{@phytosanitary_certificate}

; Treatment
{.treatment}
treatment_type = (
    cold_treatment,
    fumigation,
    heat_treatment,
    irradiation,
    methyl_bromide,
    none
)
treatment_date = date                                ; Treatment date
treatment_duration = :                               ; Duration
chemical_used = :if treatment_type != none           ; Chemical used
concentration = :if treatment_type != none           ; Concentration
temperature = #:if treatment_type != none            ; Temperature

{@phytosanitary_certificate}

; Inspection
{.inspection}
place_of_inspection = :                              ; Place of inspection
inspection_date = date                               ; Inspection date
findings = :                                         ; Findings
free_from_pests = ?                                  ; Free from quarantine pests
additional_declaration = :                           ; Additional declarations

{@phytosanitary_certificate}

; Signature
{.signature}
authorized_officer = :                               ; Name of authorized officer
signature = :                                        ; Signature
signature_date = date                                ; Signature date
official_seal = ^                                    ; Official seal/stamp image

{@phytosanitary_certificate}

; ═══════════════════════════════════════════════════════════════════════════════
; DANGEROUS GOODS DECLARATION
; ═══════════════════════════════════════════════════════════════════════════════

{@dangerous_goods_item}
; Required fields first
un_number = :(4)                                    ; UN number (4 digits)
proper_shipping_name = :                            ; Proper shipping name
hazard_class = :                                    ; Primary hazard class
packing_group = (I, II, III)                         ; Packing group

; Optional fields
subsidiary_risk = :                                  ; Subsidiary hazard class
quantity = #:(0..)                                   ; Quantity
unit_of_measure = :                                  ; Unit of measure
packing_instruction = :                              ; Packing instruction
authorization = :                                    ; Special authorization

; Marine pollutant
marine_pollutant = ?                                 ; Marine pollutant flag

; Emergency response
{.emergency}
emergency_contact = :                                ; Emergency contact name
emergency_phone = *@types.phone                      ; 24-hour emergency phone
erg_guide_number = :                                 ; ERG guide number

{@dangerous_goods_item}

; ═══════════════════════════════════════════════════════════════════════════════
; SHIPPER'S DECLARATION FOR DANGEROUS GOODS
; ═══════════════════════════════════════════════════════════════════════════════

{@dangerous_goods_declaration}
; Required fields first
declaration_number = :                              ; Declaration number
declaration_date = date                             ; Declaration date
mode = (air, ocean, rail, road)                     ; Mode of transport

; Shipper
shipper_name = :                                    ; Shipper name
shipper_address = @types.address                    ; Shipper address
shipper_phone = *@types.phone                        ; Shipper phone
shipper_emergency_contact = :                       ; 24-hour emergency contact
shipper_emergency_phone = *@types.phone             ; Emergency phone

; Consignee
consignee_name = :                                  ; Consignee name
consignee_address = @types.address                  ; Consignee address

; Carrier
carrier_name = :                                     ; Carrier name
flight_vessel = :                                    ; Flight number or vessel name
port_of_loading = :                                  ; Port of loading
port_of_discharge = :                                ; Port of discharge
departure_date = date                                ; Departure date

; Dangerous goods items
dangerous_goods[] = @dangerous_goods_item            ; DG items

; Packaging
{.packaging}
packaging_type = :                                   ; Type of packaging
packaging_specification = :                          ; Packaging spec/UN marking
package_count = ##:(1..)                             ; Number of packages
net_quantity = #:(0..)                               ; Net quantity
gross_weight = #:(0..)                               ; Gross weight
weight_unit = (kg, lb)                               ; Weight unit

{@dangerous_goods_declaration}

; Additional handling
{.handling}
cargo_aircraft_only = ?                              ; Cargo aircraft only
radioactive = ?                                      ; Radioactive material
excepted_quantity = ?                                ; Excepted quantity
limited_quantity = ?                                 ; Limited quantity

{@dangerous_goods_declaration}

; Certification
{.certification}
certify_statement = :                                ; Certification statement
signature = :                                        ; Shipper signature
signer_name = :                                      ; Name of signer
signer_title = :                                     ; Title
signature_date = date                                ; Signature date
signature_place = :                                  ; Place of signature

{@dangerous_goods_declaration}

; ═══════════════════════════════════════════════════════════════════════════════
; AES (AUTOMATED EXPORT SYSTEM) FILING
; ═══════════════════════════════════════════════════════════════════════════════

{@aes_filing}
; Required fields first
itn = :                                             ; Internal Transaction Number
filing_date = timestamp                             ; Filing timestamp

; Filer
filer_id = :                                        ; Filer ID (EIN)
filer_type = (exporter, forwarding_agent, usppi)    ; Filer type

; USPPI (US Principal Party in Interest)
usppi_name = :                                      ; USPPI name
usppi_id = :                                        ; USPPI EIN
usppi_address = @types.address                      ; USPPI address
usppi_contact = :                                    ; Contact name
usppi_phone = *@types.phone                          ; Contact phone

; Ultimate consignee
ultimate_consignee_name = :                         ; Ultimate consignee name
ultimate_consignee_country = :(2)                   ; Ultimate consignee country
ultimate_consignee_address = @types.address          ; Ultimate consignee address

; Intermediate consignee
intermediate_consignee_name = :                      ; Intermediate consignee name
intermediate_consignee_country = :(2)                ; Intermediate consignee country

; Transport details
{.transport}
carrier_name = :                                     ; Carrier name
carrier_id = :(4)                                    ; Carrier SCAC
port_of_export = :(5)                               ; US port of export (Schedule D)
country_of_ultimate_destination = :(2)              ; Ultimate destination country
foreign_port_of_unlading = :                         ; Foreign port code
method_of_transport = (air, ocean, rail, truck)     ; Method of transport
conveyance_name = :                                  ; Vessel/flight name
voyage_flight_number = :                             ; Voyage/flight number
export_date = date                                   ; Export date

{@aes_filing}

; Commodity lines
{.commodities[]}
line_number = ##:(1..)                               ; Line number
schedule_b_number = :(10)                           ; Schedule B number
description = :                                     ; Commodity description
quantity = #:(0..)                                  ; Primary quantity
unit_of_measure = :                                 ; Primary unit
secondary_quantity = #:(0..)                         ; Secondary quantity
secondary_unit = :                                   ; Secondary unit
value = #$:(0..)                                    ; Value in USD
export_license_number = :                            ; Export license number
license_exception_code = :                           ; License exception code (e.g., LVS, GBS)
eccn = :                                             ; Export Control Classification Number
country_of_origin = :(2)                             ; Country of origin
gross_weight_kg = #:(0..)                            ; Gross weight in kg
vin = *:                                              ; VIN (for vehicles)

{@aes_filing}

; Filing status
status = (accepted, amended, rejected, submitted)    ; Filing status
status_date = timestamp                              ; Status timestamp
rejection_reason = :                                 ; Rejection reason if rejected

; References
reference_number = :                                 ; Reference number
invoice_number = :                                   ; Invoice number
bol_number = :                                       ; BOL number

; ═══════════════════════════════════════════════════════════════════════════════
; EXPORT LICENSE
; ═══════════════════════════════════════════════════════════════════════════════

{@export_license}
; Required fields first
license_number = *:                                  ; License number
license_type = (
    BIS,                                             ; Bureau of Industry and Security
    DDTC,                                            ; State Dept DDTC (ITAR)
    OFAC,                                            ; Treasury OFAC
    other
)
issue_date = date                                   ; Issue date
expiration_date = date                              ; Expiration date

; Licensee
licensee_name = :                                   ; Licensee name
licensee_address = @types.address                   ; Licensee address

; Export details
{.export}
commodity_description = :                            ; Commodity description
eccn = :                                             ; ECCN (BIS)
usml_category = :                                    ; USML category (DDTC)
end_user = :                                         ; End user name
end_user_country = :(2)                              ; End user country
quantity_authorized = #:(0..)                        ; Quantity authorized
value_authorized = #$:(0..)                          ; Value authorized
quantity_used = #:(0..)                              ; Quantity used
value_used = #$:(0..)                                ; Value used

{@export_license}

; Conditions
conditions = :                                       ; License conditions
provisos = :                                         ; Provisos
country_restrictions[] = :(2)                        ; Country restrictions
end_use_restrictions = :                             ; End use restrictions

; Status
status = (active, expired, revoked, suspended, superseded)
status_date = date                                   ; Status date

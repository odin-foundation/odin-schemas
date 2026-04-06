; ===================================================================================
; ODIN Manufacturing Product Schema
; ===================================================================================
; Product definitions, bills of materials (BOM), specifications, and lifecycle
; management for manufactured goods.
; ===================================================================================

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.manufacturing.product"
version = "1.0.0"
title = "Manufacturing Product Schema"
description = "Product definitions, BOMs, specifications, and lifecycle"

{$derivation}
source[0].authority = "APICS"
source[0].citation = "Supply Chain Operations Reference (SCOR) Model"
source[0].url = "https://www.ascm.org/corporate-transformation/standards-methodology/"

source[1].authority = "ISA"
source[1].citation = "ISA-95 Enterprise-Control System Integration"
source[1].url = "https://www.isa.org/standards-and-publications/isa-standards"

source[2].authority = "GS1"
source[2].citation = "Global Trade Item Number (GTIN) Standards"
source[2].url = "https://www.gs1.org/standards/id-keys/gtin"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial manufacturing product schema"
changelog[0].rationale = "Product structures derived from ISA-95 and SCOR standards"

; ===================================================================================
; PRODUCT
; ===================================================================================

{@product}
= @types.base_product

; ───────────────────────────────────────────────────────────────────────────────
; Identification
; ───────────────────────────────────────────────────────────────────────────────
product_number = :                              ; Product/part number

; ───────────────────────────────────────────────────────────────────────────────
; Classification
; ───────────────────────────────────────────────────────────────────────────────
{.classification}
product_type = (assembly, component, finished_good, raw_material, sub_assembly, wip)
product_category = :                             ; Product category
product_family = :                               ; Product family
commodity_code = :                               ; Commodity classification code
unspsc_code = :                                  ; UNSPSC code

{@product}

; ───────────────────────────────────────────────────────────────────────────────
; Identifiers
; ───────────────────────────────────────────────────────────────────────────────
{.identifiers}
drawing_number = :                               ; Engineering drawing number
revision = :                                     ; Part revision

{@product}

; ───────────────────────────────────────────────────────────────────────────────
; Specifications
; ───────────────────────────────────────────────────────────────────────────────
{.specifications}
unit_of_measure = (ea, ft, gal, kg, lb, m, oz, unit)

{@product}

; ───────────────────────────────────────────────────────────────────────────────
; Manufacturing
; ───────────────────────────────────────────────────────────────────────────────
{.manufacturing}
make_or_buy = (buy, make, make_and_buy)
lead_time_days = ##:(0..)                        ; Manufacturing lead time
routing_id = :                                   ; Manufacturing routing ID
setup_time_minutes = #:(0..)                     ; Setup time
cycle_time_minutes = #:(0..)                     ; Cycle time per unit
batch_size = ##:(1..)                            ; Standard batch size

{@product}

; ───────────────────────────────────────────────────────────────────────────────
; Costing
; ───────────────────────────────────────────────────────────────────────────────
{.costing}
standard_cost = #$:(0..)                         ; Standard unit cost
material_cost = #$:(0..)                         ; Material cost component
labor_cost = #$:(0..)                            ; Labor cost component
overhead_cost = #$:(0..)                         ; Overhead cost component
list_price = #$:(0..)                            ; List price
currency = :(3) "USD"                            ; Currency code

{@product}

; ───────────────────────────────────────────────────────────────────────────────
; Inventory
; ───────────────────────────────────────────────────────────────────────────────
{.inventory}
lot_tracked = ?                                  ; Lot tracking required
serial_tracked = ?                               ; Serial tracking required
min_stock_level = #:(0..)                        ; Minimum stock level
reorder_point = #:(0..)                          ; Reorder point
safety_stock = #:(0..)                           ; Safety stock level
abc_class = (A, B, C)                            ; ABC classification

{@product}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
{.status}
lifecycle_status = (active, discontinued, obsolete, pending, prototype)
phase_in_date = date                             ; Introduction date
phase_out_date = date                            ; Discontinuation date

{@product}

; ───────────────────────────────────────────────────────────────────────────────
; Compliance
; ───────────────────────────────────────────────────────────────────────────────
{.compliance}
rohs_compliant = ?                               ; RoHS compliant
reach_compliant = ?                              ; REACH compliant
country_of_origin = :(2)                         ; ISO country code
export_controlled = ?                            ; Export control flag

{@product}

bom = @bom                                       ; Bill of materials

; ===================================================================================
; BILL OF MATERIALS (BOM)
; ===================================================================================

{@bom}
bom_id = :                                      ; BOM identifier
parent_product_id = :                           ; Parent product ID
bom_type = (engineering, manufacturing, planning, service)
revision = :                                    ; BOM revision
effective_date = date                           ; Effective date
status = (active, inactive, pending, superseded)
items[] = @bom_item

; ===================================================================================
; BOM ITEM
; ===================================================================================

{@bom_item}
sequence = ##:(1..)                             ; Line sequence
component_id = :                                ; Component product ID
quantity = #:(0..)                              ; Quantity per assembly
unit_of_measure = :                             ; Unit of measure
scrap_factor = #:(0..1)                          ; Scrap allowance factor
optional = ?                                     ; Optional component
effective_date = date                            ; Component effective date
expiration_date = date                           ; Component expiration date

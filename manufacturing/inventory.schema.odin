; ===================================================================================
; ODIN Manufacturing Inventory Schema
; ===================================================================================
; Inventory management including locations, transactions, lot tracking, and
; serial number tracking for manufacturing operations.
; ===================================================================================

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.manufacturing.inventory"
version = "1.0.0"
title = "Manufacturing Inventory Schema"
description = "Inventory locations, transactions, and tracking"

{$derivation}
source[0].authority = "APICS"
source[0].citation = "APICS Dictionary - Inventory Management"
source[0].url = "https://www.ascm.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial manufacturing inventory schema"
changelog[0].rationale = "Inventory structures derived from APICS standards"

; ===================================================================================
; INVENTORY LOCATION
; ===================================================================================

{@inventory_location}
location_id = :                                 ; Location identifier
location_name = :                               ; Location name
location_type = (aisle, bin, floor, rack, shelf, warehouse, zone)

; Hierarchy
warehouse = :                                    ; Warehouse code
zone = :                                         ; Zone
aisle = :                                        ; Aisle
rack = :                                         ; Rack
shelf = :                                        ; Shelf
bin = :                                          ; Bin

status = (active, blocked, inactive)
capacity = #:(0..)                               ; Storage capacity
capacity_unit = :                                ; Capacity unit

; ===================================================================================
; INVENTORY TRANSACTION
; ===================================================================================

{@inventory_transaction}
transaction_id = :                              ; Transaction identifier
transaction_type = (adjustment, issue, receipt, return, scrap, transfer)
transaction_date = timestamp                    ; Transaction timestamp

product_id = :                                  ; Product
quantity = #                                    ; Quantity (+ or -)
unit_of_measure = :                             ; Unit of measure

; Locations
from_location = :                                ; Source location
to_location = :                                  ; Destination location

; References
lot_number = :                                   ; Lot/batch number
serial_number = *:                               ; Serial number
reference_type = (manufacturing_order, purchase_order, sales_order, work_order)
reference_number = :                             ; Reference document

reason_code = :                                  ; Transaction reason
notes = :                                        ; Transaction notes
performed_by = :                                ; User who performed

; ===================================================================================
; LOT
; ===================================================================================

{@lot}
= @types.base_lot

; Domain-specific fields
manufacturing_order = :                          ; Manufacturing order
certificate_of_analysis = :                      ; COA reference

; ===================================================================================
; SERIAL NUMBER
; ===================================================================================

{@serial_number}
serial_number = *:                              ; Serial number (confidential)
product_id = :                                  ; Product
lot_number = :                                   ; Parent lot

status = (available, in_use, retired, sold)
location = :                                     ; Current location

manufacturing_date = date                        ; Manufacturing date
manufacturing_order = :                          ; Manufacturing order
warranty_expiration = date                       ; Warranty expiration

current_owner = :                                ; Current owner/customer

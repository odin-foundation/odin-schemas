; ===================================================================================
; ODIN Retail Inventory Schema
; ===================================================================================
; Inventory management including stock levels, allocations, and transfers.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.retail.inventory"
version = "1.0.0"
title = "Retail Inventory Schema"
description = "Inventory levels, allocations, and stock management"

{$derivation}
source[0].authority = "GS1"
source[0].citation = "GS1 Inventory Management Standards"
source[0].url = "https://www.gs1.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial retail inventory schema"
changelog[0].rationale = "Inventory structures for retail operations"

; ===================================================================================
; INVENTORY LEVEL
; ===================================================================================

{@inventory_level}
= @types.audit_info

product_id = :                                  ; Product/SKU
location_id = :                                 ; Store/warehouse
location_type = (distribution_center, store, warehouse)

; Quantities
on_hand = #:(0..)                                ; On hand quantity
available = #:(0..)                              ; Available for sale
allocated = #:(0..)                              ; Allocated quantity
on_order = #:(0..)                               ; On order quantity
in_transit = #:(0..)                             ; In transit quantity
reserved = #:(0..)                               ; Reserved quantity

unit_of_measure = :                             ; Unit of measure

; Thresholds
min_stock = #:(0..)                              ; Minimum stock level
max_stock = #:(0..)                              ; Maximum stock level
reorder_point = #:(0..)                          ; Reorder point
reorder_quantity = #:(0..)                       ; Reorder quantity

last_count_date = date                           ; Last count date
last_received_date = date                        ; Last receipt date
last_sold_date = date                            ; Last sale date

; ===================================================================================
; ALLOCATION
; ===================================================================================

{@allocation}
allocation_id = :                               ; Allocation identifier
product_id = :                                  ; Product/SKU
source_location = :                             ; Source location
destination_location = :                        ; Destination location

quantity = #:(0..)                              ; Allocated quantity
quantity_shipped = #:(0..)                       ; Shipped quantity
quantity_received = #:(0..)                      ; Received quantity

status = (cancelled, completed, in_transit, pending, shipped)

allocation_date = date                          ; Allocation date
ship_date = date                                 ; Ship date
arrival_date = date                              ; Expected arrival
received_date = date                             ; Received date

reason = :                                       ; Allocation reason
priority = (high, low, normal, urgent)

; ===================================================================================
; TRANSFER
; ===================================================================================

{@transfer}
transfer_id = :                                 ; Transfer identifier
transfer_number = :                             ; Transfer number
transfer_type = (distribution, inter_store, return_to_vendor, warehouse)

source_location = :                             ; Source location
destination_location = :                        ; Destination location

status = (cancelled, completed, in_transit, pending, shipped)

created = date                                   ; Created date
ship_date = date                                 ; Ship date
arrival_date = date                              ; Expected arrival
received_date = date                             ; Received date

lines[] = @transfer_line                         ; Transfer lines
notes = :                                        ; Transfer notes

; ===================================================================================
; TRANSFER LINE
; ===================================================================================

{@transfer_line}
line_number = ##:(1..)                          ; Line number
product_id = :                                  ; Product/SKU
quantity_requested = #:(0..)                    ; Requested quantity
quantity_shipped = #:(0..)                       ; Shipped quantity
quantity_received = #:(0..)                      ; Received quantity
unit_of_measure = :                             ; Unit of measure
unit_cost = #$:(0..)                             ; Unit cost

; ===================================================================================
; CYCLE COUNT
; ===================================================================================

{@cycle_count}
count_id = :                                    ; Count identifier
location_id = :                                 ; Location
count_date = date                               ; Count date
counted_by = :                                  ; Counted by

status = (completed, in_progress, pending, reconciled)

items[] = @count_item                            ; Count items

variance_count = ##:(0..)                        ; Items with variance
variance_value = #$                              ; Total variance value

; ===================================================================================
; COUNT ITEM
; ===================================================================================

{@count_item}
product_id = :                                  ; Product/SKU
system_quantity = #:(0..)                        ; System quantity
counted_quantity = #:(0..)                       ; Counted quantity
variance = #                                     ; Variance (+/-)
variance_reason = :                              ; Variance reason
unit_cost = #$:(0..)                             ; Unit cost
variance_value = #$                              ; Variance $ value

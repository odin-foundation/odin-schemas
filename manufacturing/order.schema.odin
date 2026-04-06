; ===================================================================================
; ODIN Manufacturing Order Schema
; ===================================================================================
; Manufacturing orders, work orders, and production scheduling.
; ===================================================================================

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.manufacturing.order"
version = "1.0.0"
title = "Manufacturing Order Schema"
description = "Manufacturing orders, work orders, and production scheduling"

{$derivation}
source[0].authority = "ISA"
source[0].citation = "ISA-95 Enterprise-Control System Integration"
source[0].url = "https://www.isa.org/standards-and-publications/isa-standards"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial manufacturing order schema"
changelog[0].rationale = "Order structures derived from ISA-95 standards"

; ===================================================================================
; MANUFACTURING ORDER
; ===================================================================================

{@manufacturing_order}
order_id = :                                    ; Order identifier
order_number = :                                ; Order number
product_id = :                                  ; Product to manufacture
quantity_ordered = #:(0..)                      ; Quantity ordered
quantity_completed = #:(0..)                     ; Quantity completed
unit_of_measure = :                             ; Unit of measure

status = (cancelled, closed, completed, in_progress, planned, released)
priority = ##:(1..99)                            ; Order priority

; Schedule
{.schedule}
planned_start = date                             ; Planned start date
planned_end = date                               ; Planned end date
actual_start = date                              ; Actual start date
actual_end = date                                ; Actual end date
due_date = date                                 ; Due date

{@manufacturing_order}

; Source
{.source}
source_type = (customer_order, forecast, inventory_replenishment, rework)
source_reference = :                             ; Source order reference
customer_id = :                                  ; Customer ID if applicable

{@manufacturing_order}

operations[] = @operation                        ; Manufacturing operations

; ===================================================================================
; OPERATION
; ===================================================================================

{@operation}
operation_id = :                                ; Operation identifier
sequence = ##:(1..)                             ; Operation sequence
operation_name = :                              ; Operation name
work_center = :                                 ; Work center

; Times
setup_time = #:(0..)                             ; Setup time (hours)
run_time = #:(0..)                               ; Run time (hours)
queue_time = #:(0..)                             ; Queue time (hours)
move_time = #:(0..)                              ; Move time (hours)

status = (cancelled, completed, in_progress, pending, ready)
quantity_completed = #:(0..)                     ; Quantity completed
scrap_quantity = #:(0..)                         ; Scrap quantity

actual_start = timestamp                         ; Actual start time
actual_end = timestamp                           ; Actual end time

; ===================================================================================
; WORK ORDER
; ===================================================================================

{@work_order}
= @types.base_work_order

; Domain-specific fields
manufacturing_order_id = :                      ; Parent manufacturing order
operation_id = :                                ; Operation reference
work_center = :                                 ; Work center assignment
shift = :                                        ; Shift assignment

planned_start = timestamp                        ; Planned start
planned_end = timestamp                          ; Planned end
actual_start = timestamp                         ; Actual start
actual_end = timestamp                           ; Actual end

machine_hours = #:(0..)                          ; Machine hours recorded
quantity_produced = #:(0..)                      ; Quantity produced
scrap_quantity = #:(0..)                         ; Scrap quantity

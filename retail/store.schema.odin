; ===================================================================================
; ODIN Retail Store Schema
; ===================================================================================
; Store locations, hours, departments, and operations.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.retail.store"
version = "1.0.0"
title = "Retail Store Schema"
description = "Store locations and operations"

{$derivation}
source[0].authority = "NRF"
source[0].citation = "NRF Store Operations Standards"
source[0].url = "https://nrf.com/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial retail store schema"
changelog[0].rationale = "Store structures for retail operations"

; ===================================================================================
; STORE
; ===================================================================================

{@store}
= @types.audit_info

store_id = :                                    ; Store identifier
store_number = :                                ; Store number
store_name = :                                  ; Store name
store_type = (flagship, outlet, pop_up, regular, warehouse)

status = (closed, open, opening_soon, temporarily_closed)

; Location
address = @types.address                         ; Store address
phone = @types.phone                             ; Store phone
email = @types.email                             ; Store email
timezone = :                                     ; Timezone

; Size
selling_sqft = #:(0..)                           ; Selling square feet
total_sqft = #:(0..)                             ; Total square feet
parking_spaces = ##:(0..)                        ; Parking spaces

; Organization
district = :                                     ; District
region = :                                       ; Region
division = :                                     ; Division
manager = :                                      ; Store manager

; Dates
open_date = date                                 ; Open date
close_date = date                                ; Close date (if closed)
last_remodel_date = date                         ; Last remodel

hours = @store_hours                             ; Operating hours
departments[] = @department                      ; Store departments

; Capabilities
bopis_enabled = ?                                ; Buy online pickup in store
ship_from_store = ?                              ; Ship from store
curbside_pickup = ?                              ; Curbside pickup
same_day_delivery = ?                            ; Same day delivery

; ===================================================================================
; STORE HOURS
; ===================================================================================

{@store_hours}
; Regular hours
monday_open = time                               ; Monday open
monday_close = time                              ; Monday close
tuesday_open = time                              ; Tuesday open
tuesday_close = time                             ; Tuesday close
wednesday_open = time                            ; Wednesday open
wednesday_close = time                           ; Wednesday close
thursday_open = time                             ; Thursday open
thursday_close = time                            ; Thursday close
friday_open = time                               ; Friday open
friday_close = time                              ; Friday close
saturday_open = time                             ; Saturday open
saturday_close = time                            ; Saturday close
sunday_open = time                               ; Sunday open
sunday_close = time                              ; Sunday close

; Exceptions
holiday_hours[] = @holiday_hours                 ; Holiday hours

; ===================================================================================
; HOLIDAY HOURS
; ===================================================================================

{@holiday_hours}
date = date                                      ; Holiday date
name = :                                         ; Holiday name
open_time = time                                 ; Open time
close_time = time                                ; Close time
closed = ?                                       ; Closed all day

; ===================================================================================
; DEPARTMENT
; ===================================================================================

{@department}
department_id = :                               ; Department identifier
department_name = :                             ; Department name
department_code = :                              ; Department code

location_in_store = :                            ; Location in store
sqft = #:(0..)                                   ; Square feet
manager = :                                      ; Department manager

; ===================================================================================
; STORE PERFORMANCE
; ===================================================================================

{@store_performance}
store_id = :                                    ; Store
period = :                                      ; Period (YYYY-MM)
period_type = (daily, monthly, weekly, yearly)

; Sales
net_sales = #$                                   ; Net sales
gross_sales = #$:(0..)                           ; Gross sales
returns = #$:(0..)                               ; Returns
transaction_count = ##:(0..)                     ; Transaction count
average_transaction = #$:(0..)                   ; Average transaction

; Comparisons
sales_plan = #$:(0..)                            ; Sales plan
sales_ly = #$:(0..)                              ; Sales last year
sales_variance_plan = #$                         ; Variance to plan
sales_variance_ly = #$                           ; Variance to LY

; Traffic
traffic_count = ##:(0..)                         ; Customer traffic
conversion_rate = #:(0..100)                     ; Conversion rate
units_per_transaction = #:(0..)                  ; UPT

; Labor
labor_hours = #:(0..)                            ; Labor hours
labor_cost = #$:(0..)                            ; Labor cost
sales_per_labor_hour = #$:(0..)                  ; SPLH

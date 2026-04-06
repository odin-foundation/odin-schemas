; ===================================================================================
; ODIN Retail Order Schema
; ===================================================================================
; Customer orders, fulfillment, and order management.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.retail.order"
version = "1.0.0"
title = "Retail Order Schema"
description = "Customer orders and fulfillment"

{$derivation}
source[0].authority = "GS1"
source[0].citation = "GS1 Order Management Standards"
source[0].url = "https://www.gs1.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial retail order schema"
changelog[0].rationale = "Order structures for retail operations"

; ===================================================================================
; ORDER
; ===================================================================================

{@order}
= @types.audit_info

order_id = :                                    ; Order identifier
order_number = :                                ; Order number
order_type = (in_store, online, phone, subscription)
channel = (app, marketplace, store, web)

customer_id = :                                 ; Customer ID
order_date = timestamp                          ; Order date/time
status = (backordered, cancelled, completed, pending, processing, shipped)

; Addresses
billing_address = @types.address                 ; Billing address
shipping_address = @types.address                ; Shipping address

; Financials
subtotal = #$:(0..)                              ; Subtotal
discount_total = #$:(0..)                        ; Total discounts
tax_total = #$:(0..)                             ; Total tax
shipping_total = #$:(0..)                        ; Shipping cost
order_total = #$:(0..)                          ; Order total
currency = :(3) "USD"                            ; Currency

; Payment
payment = @types.payment                         ; Payment information
payment_status = (authorized, captured, failed, partial, pending, refunded)

; Shipping
shipping_method = :                              ; Shipping method
requested_ship_date = date                       ; Requested ship date
estimated_delivery = date                        ; Estimated delivery

lines[] = @order_line                            ; Order lines
fulfillments[] = @fulfillment                    ; Fulfillments

notes = :                                        ; Order notes
gift = ?                                         ; Gift order
gift_message = :                                 ; Gift message

; ===================================================================================
; ORDER LINE
; ===================================================================================

{@order_line}
line_number = ##:(1..)                          ; Line number
product_id = :                                  ; Product/SKU
product_name = :                                 ; Product name

quantity = #:(0..)                              ; Quantity ordered
quantity_fulfilled = #:(0..)                     ; Quantity fulfilled
quantity_cancelled = #:(0..)                     ; Quantity cancelled
unit_of_measure = :                              ; Unit of measure

unit_price = #$:(0..)                           ; Unit price
line_discount = #$:(0..)                         ; Line discount
line_tax = #$:(0..)                              ; Line tax
line_total = #$:(0..)                            ; Line total

status = (backordered, cancelled, fulfilled, pending)
fulfillment_location = :                         ; Fulfillment location

; ===================================================================================
; FULFILLMENT
; ===================================================================================

{@fulfillment}
fulfillment_id = :                              ; Fulfillment identifier
order_id = :                                    ; Order reference
fulfillment_type = (bopis, delivery, ship_from_store, ship_to_home)

location_id = :                                 ; Fulfillment location
status = (cancelled, delivered, in_transit, packed, pending, picked, shipped)

; Dates
picked_date = timestamp                          ; Picked date
packed_date = timestamp                          ; Packed date
shipped_date = timestamp                         ; Shipped date
delivered_date = timestamp                       ; Delivered date

; Shipping
carrier = :                                      ; Carrier
service = :                                      ; Service level
tracking_number = :                              ; Tracking number
tracking_url = :                                 ; Tracking URL

lines[] = @fulfillment_line                      ; Fulfillment lines

; ===================================================================================
; FULFILLMENT LINE
; ===================================================================================

{@fulfillment_line}
order_line_number = ##:(1..)                    ; Order line reference
product_id = :                                  ; Product/SKU
quantity = #:(0..)                              ; Quantity fulfilled

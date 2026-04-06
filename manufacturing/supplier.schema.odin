; ===================================================================================
; ODIN Manufacturing Supplier Schema
; ===================================================================================
; Supplier management, purchase orders, and supplier quality tracking.
; ===================================================================================

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.manufacturing.supplier"
version = "1.0.0"
title = "Manufacturing Supplier Schema"
description = "Supplier management and procurement"

{$derivation}
source[0].authority = "ISO"
source[0].citation = "ISO 9001:2015 - External Providers"
source[0].url = "https://www.iso.org/iso-9001-quality-management.html"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial manufacturing supplier schema"
changelog[0].rationale = "Supplier structures derived from ISO 9001"

; ===================================================================================
; SUPPLIER
; ===================================================================================

{@supplier}
= @types.audit_info

supplier_id = :                                 ; Supplier identifier
supplier_name = :                               ; Supplier name
supplier_type = (distributor, manufacturer, service_provider)

status = (active, approved, disqualified, inactive, pending_approval, probation)
approval_date = date                             ; Approval date
review_date = date                               ; Next review date

; Contact
address = @types.address                         ; Business address
phone = @types.phone                             ; Phone
email = @types.email                             ; Email
website = :                                      ; Website

; Business
tax_id = *:                                      ; Tax ID (confidential)
duns_number = :                                  ; DUNS number
payment_terms = :                                ; Payment terms
currency = :(3) "USD"                            ; Currency

; Certifications
iso_9001 = ?                                     ; ISO 9001 certified
iso_14001 = ?                                    ; ISO 14001 certified
as9100 = ?                                       ; AS9100 certified
iatf_16949 = ?                                   ; IATF 16949 certified

commodities[] = :                                ; Approved commodities
quality = @supplier_quality                      ; Quality metrics

; ===================================================================================
; SUPPLIER QUALITY
; ===================================================================================

{@supplier_quality}
supplier_id = :                                 ; Supplier reference
rating_period = :                                ; Rating period

quality_rating = #:(0..100)                      ; Quality score
delivery_rating = #:(0..100)                     ; Delivery score
overall_rating = #:(0..100)                      ; Overall score
rating_class = (A, B, C, D, F)                   ; Rating class

; Metrics
total_lots_received = ##:(0..)                   ; Total lots received
lots_rejected = ##:(0..)                         ; Lots rejected
ppm_defect_rate = #:(0..)                        ; PPM defect rate
on_time_delivery_percent = #:(0..100)            ; On-time delivery %

last_audit_date = date                           ; Last audit date
next_audit_date = date                           ; Next audit date
audit_result = (approved, conditionally_approved, disapproved, pending)

; ===================================================================================
; PURCHASE ORDER
; ===================================================================================

{@purchase_order}
= @types.audit_info

po_number = :                                   ; PO number
supplier_id = :                                 ; Supplier
status = (cancelled, closed, open, partially_received, pending)

order_date = date                               ; Order date
required_date = date                             ; Required date
promised_date = date                             ; Supplier promised date

; Financials
subtotal = #$:(0..)                              ; Subtotal
tax = #$:(0..)                                   ; Tax amount
shipping = #$:(0..)                              ; Shipping cost
total = #$:(0..)                                ; Total amount
currency = :(3) "USD"                            ; Currency

payment_terms = :                                ; Payment terms
ship_to = :                                      ; Ship-to location
freight_terms = (collect, prepaid, prepaid_and_add)

lines[] = @po_line                               ; PO line items

; ===================================================================================
; PO LINE
; ===================================================================================

{@po_line}
line_number = ##:(1..)                          ; Line number
product_id = :                                  ; Product/part
description = :                                  ; Description
quantity = #:(0..)                              ; Quantity ordered
unit_of_measure = :                             ; Unit of measure
unit_price = #$:(0..)                           ; Unit price
extended_price = #$:(0..)                        ; Extended price

required_date = date                             ; Required date
quantity_received = #:(0..)                      ; Quantity received
quantity_open = #:(0..)                          ; Quantity open

status = (cancelled, closed, open, received)

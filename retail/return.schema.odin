; ===================================================================================
; ODIN Retail Return Schema
; ===================================================================================
; Returns, refunds, exchanges, and return merchandise authorizations.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.retail.return"
version = "1.0.0"
title = "Retail Return Schema"
description = "Returns, refunds, and exchanges"

{$derivation}
source[0].authority = "NRF"
source[0].citation = "NRF Return Policy Standards"
source[0].url = "https://nrf.com/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial retail return schema"
changelog[0].rationale = "Return structures for retail operations"

; ===================================================================================
; RETURN
; ===================================================================================

{@return}
= @types.audit_info

return_id = :                                   ; Return identifier
return_number = :                               ; Return number
return_type = (exchange, refund, store_credit)

original_order_id = :                            ; Original order
original_transaction_id = :                      ; Original transaction
customer_id = :                                  ; Customer

return_date = timestamp                         ; Return date
store_id = :                                     ; Store
processed_by = :                                 ; Processed by

status = (approved, completed, pending, rejected)

; Amounts
return_subtotal = #$:(0..)                       ; Return subtotal
restocking_fee = #$:(0..)                        ; Restocking fee
return_total = #$:(0..)                          ; Return total

lines[] = @return_line                           ; Return lines
refund = @refund                                 ; Refund details

notes = :                                        ; Return notes

; ===================================================================================
; RETURN LINE
; ===================================================================================

{@return_line}
line_number = ##:(1..)                          ; Line number
product_id = :                                  ; Product/SKU
quantity = #:(0..)                              ; Quantity returned
unit_price = #$:(0..)                            ; Unit price
line_total = #$:(0..)                            ; Line total

reason = :                                      ; Return reason
reason_code = (damaged, defective, not_as_described, not_needed, ordered_wrong, other, too_large, too_small, wrong_item)

condition = (damaged, good, opened, used)
disposition = (damage_out, restock, return_to_vendor, scrap)

; Exchange
exchange_product_id = :                          ; Exchange product
exchange_quantity = #:(0..)                      ; Exchange quantity

; ===================================================================================
; REFUND
; ===================================================================================

{@refund}
refund_id = :                                   ; Refund identifier
return_id = :                                   ; Return reference
refund_type = (credit_card, original_payment, store_credit)

amount = #$:(0..)                               ; Refund amount
status = (completed, failed, pending, processed)

refund_date = timestamp                          ; Refund date
processed_by = :                                 ; Processed by

; Payment details
original_tender_type = :                         ; Original payment method
refund_to_card_last_four = *:(4)                 ; Card last 4
reference_number = :                             ; Reference number

; Store credit
store_credit_number = :                          ; Store credit number
store_credit_expiration = date                   ; Expiration date

; ===================================================================================
; RMA (Return Merchandise Authorization)
; ===================================================================================

{@rma}
= @types.audit_info

rma_id = :                                      ; RMA identifier
rma_number = :                                  ; RMA number
order_id = :                                    ; Order reference
customer_id = :                                 ; Customer

status = (approved, cancelled, closed, pending, received)

request_date = date                             ; Request date
approval_date = date                             ; Approval date
expiration_date = date                           ; RMA expiration
received_date = date                             ; Received date

return_reason = :                               ; Return reason
return_instructions = :                          ; Return instructions
return_label_url = :                             ; Return label URL
tracking_number = :                              ; Return tracking

lines[] = @rma_line                              ; RMA lines

; ===================================================================================
; RMA LINE
; ===================================================================================

{@rma_line}
line_number = ##:(1..)                          ; Line number
product_id = :                                  ; Product/SKU
quantity_authorized = #:(0..)                   ; Quantity authorized
quantity_received = #:(0..)                      ; Quantity received
reason = :                                       ; Line-level reason
resolution = (exchange, refund, repair, store_credit)

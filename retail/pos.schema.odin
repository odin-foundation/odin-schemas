; ===================================================================================
; ODIN Retail POS Schema
; ===================================================================================
; Point of sale transactions, tenders, and register operations.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.retail.pos"
version = "1.0.0"
title = "Retail POS Schema"
description = "Point of sale transactions and register operations"

{$derivation}
source[0].authority = "NRF"
source[0].citation = "NRF ARTS XML Standards"
source[0].url = "https://nrf.com/resources/retail-library/arts-xml"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial retail POS schema"
changelog[0].rationale = "POS structures derived from NRF ARTS standards"

; ===================================================================================
; TRANSACTION
; ===================================================================================

{@transaction}
= @types.audit_info

transaction_id = :                              ; Transaction identifier
transaction_number = :                          ; Transaction number
transaction_type = (exchange, no_sale, return, sale, void)

store_id = :                                    ; Store
register_id = :                                 ; Register
cashier_id = :                                  ; Cashier
transaction_date = timestamp                    ; Transaction timestamp

; Customer
customer_id = :                                  ; Customer ID
loyalty_id = :                                   ; Loyalty ID

; Amounts
subtotal = #$:(0..)                              ; Subtotal
discount_total = #$:(0..)                        ; Total discounts
tax_total = #$:(0..)                             ; Total tax
grand_total = #$:(0..)                          ; Grand total
change_due = #$:(0..)                            ; Change due

lines[] = @transaction_line                      ; Transaction lines
tenders[] = @tender                              ; Payment tenders

status = (completed, suspended, voided)
void_reason = :                                  ; Void reason
voided_by = :                                    ; Voided by

; ===================================================================================
; TRANSACTION LINE
; ===================================================================================

{@transaction_line}
line_number = ##:(1..)                          ; Line number
line_type = (discount, fee, item, return, tax)

product_id = :                                   ; Product/SKU
description = :                                  ; Description
quantity = #                                     ; Quantity (+/-)
unit_price = #$:(0..)                            ; Unit price
extended_price = #$                              ; Extended price
discount = #$:(0..)                              ; Line discount
tax = #$:(0..)                                   ; Line tax
line_total = #$                                  ; Line total

serial_number = *:                               ; Serial number
return_reason = :                                ; Return reason

; ===================================================================================
; TENDER
; ===================================================================================

{@tender}
tender_id = :                                   ; Tender identifier
tender_type = (cash, check, credit, debit, gift_card, loyalty_points, mobile)
amount = #$:(0..)                               ; Tender amount

; Card info (confidential)
card_type = *(amex, discover, mastercard, visa)
last_four = *:(4)                                ; Last 4 digits
authorization_code = *:                          ; Auth code
reference_number = *:                            ; Reference number

; Gift card
gift_card_number = *:                            ; Gift card number
gift_card_balance = #$:(0..)                     ; Remaining balance

; Check
check_number = :                                 ; Check number

; ===================================================================================
; REGISTER
; ===================================================================================

{@register}
register_id = :                                 ; Register identifier
register_number = :                             ; Register number
store_id = :                                    ; Store

status = (active, inactive, offline)
current_cashier = :                              ; Current cashier
shift_id = :                                     ; Current shift

last_transaction = timestamp                     ; Last transaction time
transaction_count = ##:(0..)                     ; Transactions today

; ===================================================================================
; SHIFT
; ===================================================================================

{@shift}
shift_id = :                                    ; Shift identifier
register_id = :                                 ; Register
cashier_id = :                                  ; Cashier

start_time = timestamp                          ; Shift start
end_time = timestamp                             ; Shift end
status = (closed, open)

; Opening
opening_cash = #$:(0..)                          ; Opening cash
opening_verified_by = :                          ; Verified by

; Closing
closing_cash = #$:(0..)                          ; Closing cash
expected_cash = #$:(0..)                         ; Expected cash
cash_variance = #$                               ; Variance

; Totals
transaction_count = ##:(0..)                     ; Transaction count
sales_total = #$:(0..)                           ; Sales total
returns_total = #$:(0..)                         ; Returns total
net_sales = #$                                   ; Net sales

; Tenders
cash_collected = #$:(0..)                        ; Cash collected
card_collected = #$:(0..)                        ; Card collected
other_tenders = #$:(0..)                         ; Other tenders

; ===================================================================================
; ODIN Retail Pricing Schema
; ===================================================================================
; Pricing, markdowns, promotions, and price management.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.retail.pricing"
version = "1.0.0"
title = "Retail Pricing Schema"
description = "Pricing, markdowns, and promotions"

{$derivation}
source[0].authority = "NRF"
source[0].citation = "National Retail Federation Pricing Standards"
source[0].url = "https://nrf.com/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial retail pricing schema"
changelog[0].rationale = "Pricing structures for retail operations"

; ===================================================================================
; PRICE
; ===================================================================================

{@price}
= @types.audit_info

price_id = :                                    ; Price identifier
product_id = :                                  ; Product/SKU
price_type = (clearance, list, promotional, regular, sale)

amount = #$:(0..)                               ; Price amount
currency = :(3) "USD"                            ; Currency code
unit_of_measure = :                              ; Price per unit

effective_date = date                           ; Effective date
expiration_date = date                           ; Expiration date

; Cost basis
cost = *#$:(0..)                                 ; Cost (confidential)
margin_percent = *#:(0..100)                     ; Margin % (confidential)

; Zone pricing
price_zone = :                                   ; Price zone
store_id = :                                     ; Store-specific price

; ===================================================================================
; MARKDOWN
; ===================================================================================

{@markdown}
markdown_id = :                                 ; Markdown identifier
product_id = :                                  ; Product/SKU
markdown_type = (clearance, permanent, seasonal, temporary)

original_price = #$:(0..)                       ; Original price
markdown_price = #$:(0..)                       ; Markdown price
markdown_percent = #:(0..100)                    ; Markdown percentage

effective_date = date                           ; Effective date
expiration_date = date                           ; Expiration date

reason = :                                       ; Markdown reason
approved_by = :                                  ; Approval authority

; ===================================================================================
; PROMOTION
; ===================================================================================

{@promotion}
= @types.audit_info

promotion_id = :                                ; Promotion identifier
promotion_name = :                              ; Promotion name
promotion_type = (bogo, bundle, coupon, discount, loyalty, rebate)

status = (active, cancelled, expired, pending, scheduled)

start_date = date                               ; Start date
end_date = date                                 ; End date

; Discount
discount_type = (amount, percent)
discount_value = #:(0..)                         ; Discount value
minimum_purchase = #$:(0..)                      ; Minimum purchase
maximum_discount = #$:(0..)                      ; Maximum discount cap

; Eligibility
eligible_products[] = :                          ; Eligible product IDs
eligible_categories[] = :                        ; Eligible categories
excluded_products[] = :                          ; Excluded products
customer_segment = :                             ; Customer segment

; Limits
usage_limit = ##:(0..)                           ; Total usage limit
usage_per_customer = ##:(0..)                    ; Per customer limit
current_usage = ##:(0..)                         ; Current usage count

; Stacking
stackable = ?                                    ; Can stack with other promos
priority = ##:(1..)                              ; Priority order

; ===================================================================================
; COUPON
; ===================================================================================

{@coupon}
coupon_id = :                                   ; Coupon identifier
coupon_code = :                                 ; Coupon code
promotion_id = :                                 ; Related promotion

status = (active, expired, redeemed, void)
single_use = ?                                   ; Single use only

issue_date = date                                ; Issue date
expiration_date = date                           ; Expiration date
redeemed_date = date                             ; Redeemed date

discount_type = (amount, percent)
discount_value = #:(0..)                         ; Discount value
minimum_purchase = #$:(0..)                      ; Minimum purchase

customer_id = :                                  ; Assigned customer

; ===================================================================================
; ODIN Retail Customer Schema
; ===================================================================================
; Customer records, loyalty programs, and preferences for retail operations.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.retail.customer"
version = "1.0.0"
title = "Retail Customer Schema"
description = "Customer records and loyalty management"

{$derivation}
source[0].authority = "NRF"
source[0].citation = "National Retail Federation Customer Standards"
source[0].url = "https://nrf.com/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial retail customer schema"
changelog[0].rationale = "Customer structures for retail operations"

; ===================================================================================
; CUSTOMER
; ===================================================================================

{@customer}
= @types.audit_info

customer_id = :                                 ; Customer identifier
status = (active, inactive, suspended)

; Personal info
name = @types.person_name                        ; Customer name
email = *@types.email                            ; Email (confidential)
phone = *@types.phone                            ; Phone (confidential)
date_of_birth = *date                            ; Date of birth (confidential)

; Addresses
addresses[] = @customer_address                  ; Customer addresses

; Account
last_activity_date = date                        ; Last activity

; Marketing
marketing_consent = ?                            ; Marketing consent
email_opt_in = ?                                 ; Email opt-in
sms_opt_in = ?                                   ; SMS opt-in

; Loyalty
loyalty = @loyalty_account                       ; Loyalty account

; Preferences
preferences = @preference                        ; Customer preferences

; Metrics
lifetime_value = *#$:(0..)                       ; Lifetime value (confidential)
total_orders = ##:(0..)                          ; Total orders
average_order_value = #$:(0..)                   ; Average order value

; ===================================================================================
; CUSTOMER ADDRESS
; ===================================================================================

{@customer_address}
= @types.address

address_id = :                                  ; Address identifier
address_type = (billing, shipping, both)
default = ?                                      ; Default address

; ===================================================================================
; LOYALTY ACCOUNT
; ===================================================================================

{@loyalty_account}
loyalty_id = :                                  ; Loyalty identifier
program_name = :                                 ; Program name
tier = :(bronze, gold, platinum, silver)         ; Loyalty tier
status = (active, inactive, suspended)

enrollment_date = date                           ; Enrollment date
tier_expiration = date                           ; Tier expiration

; Points
points_balance = ##:(0..)                        ; Current points balance
points_earned_ytd = ##:(0..)                     ; Points earned YTD
points_redeemed_ytd = ##:(0..)                   ; Points redeemed YTD
points_expiring = ##:(0..)                       ; Points expiring
points_expiration_date = date                    ; Expiration date

; Rewards
available_rewards[] = :                          ; Available reward IDs
redeemed_rewards[] = :                           ; Redeemed reward IDs

; ===================================================================================
; PREFERENCE
; ===================================================================================

{@preference}
preferred_store = :                              ; Preferred store
preferred_language = :(2)                        ; Language code
preferred_currency = :(3)                        ; Currency code
preferred_size = :                               ; Preferred size
preferred_brands[] = :                           ; Preferred brands
preferred_categories[] = :                       ; Preferred categories

communication_channel = (email, mail, none, sms)
communication_frequency = (daily, monthly, never, weekly)

; ===================================================================================
; CUSTOMER SEGMENT
; ===================================================================================

{@customer_segment}
segment_id = :                                  ; Segment identifier
segment_name = :                                ; Segment name
description = :                                  ; Segment description

segment_type = (behavioral, demographic, geographic, psychographic)
criteria = :                                     ; Segment criteria
customer_count = ##:(0..)                        ; Customer count

created = date                              ; Created date
last_refresh = date                              ; Last refresh date

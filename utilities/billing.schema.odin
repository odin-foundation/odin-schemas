; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Utilities/Energy - Billing Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Customer billing for utilities including invoices, commodity charges, delivery
; charges, demand charges, taxes, credits, rate schedules, and payments.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.utilities.billing"
version = "1.0.0"
title = "Utility Billing and Payments"
description = "Billing, invoicing, and payment schema for electric, gas, and water utilities"

{$derivation}
source[0].authority = "North American Energy Standards Board"
source[0].citation = "NAESB WEQ-013 Billing Data Exchange"
source[0].url = "https://www.naesb.org/"
source[0].accessed = 2025-12-21

source[1].authority = "Federal Energy Regulatory Commission"
source[1].citation = "18 CFR Part 35 - Rate Schedules and Tariffs"
source[1].url = "https://www.ecfr.gov/current/title-18/chapter-I/subchapter-B/part-35"
source[1].accessed = 2025-12-21

source[2].authority = "National Association of Regulatory Utility Commissioners"
source[2].citation = "Billing Format Standards"
source[2].url = "https://www.naruc.org/"
source[2].accessed = 2025-12-21

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial utilities billing schema"
changelog[0].rationale = "Standard billing structures per NAESB, FERC, and NARUC requirements"

; ═══════════════════════════════════════════════════════════════════════════════
; BILL
; ═══════════════════════════════════════════════════════════════════════════════

{@bill}
= @types.audit_info

; Required fields first
bill_number = :                                   ; Unique bill identifier
account_number = *:                                ; Account number
bill_date = date                                  ; Bill generation date
due_date = date                                   ; Payment due date
status = (adjusted, cancelled, paid, partial, pending, void)

; Service period
service_start_date = date                         ; Service period start
service_end_date = date                           ; Service period end
billing_days = ##:(1..)                            ; Number of days billed

; Amounts
current_charges = #$:(0..)                        ; Current period charges
previous_balance = #$                              ; Prior unpaid balance (can be negative)
payments_received = #$:(0..)                       ; Payments since last bill
adjustments = #$                                   ; Adjustments (can be negative)
total_amount_due = #$                             ; Total amount due (can be negative for credit)

; Payment terms
minimum_due = #$:(0..)                             ; Minimum payment required
late_payment_date = date                           ; Late payment threshold
late_fee_amount = #$:(0..)                         ; Late fee if applicable

; Bill delivery
delivery_method = (email, mail, portal)            ; How bill delivered
bill_format = (electronic, paper, summary)         ; Bill format
paperless = ?                                      ; Paperless billing enrolled

; Meter information
meter_number = :                                   ; Primary meter number
previous_read_date = date                          ; Prior reading date
current_read_date = date                           ; Current reading date
next_read_date = date                              ; Estimated next read

; Messages
message = :                                        ; Bill message to customer
alert = :                                          ; Important alert or notice
budget_message = :                                 ; Budget billing message

{@bill}

; ═══════════════════════════════════════════════════════════════════════════════
; CHARGES
; ═══════════════════════════════════════════════════════════════════════════════

{@bill.charges[]}
; Required fields first
charge_type = (adjustment, commodity, credit, delivery, demand, fee, tax, transmission)
description = :                                   ; Charge description
amount = #$                                       ; Charge amount (can be negative for credits)

; Optional fields
charge_code = :                                    ; Internal charge code
commodity = (electric, gas, water)                 ; Commodity if applicable
uom = (ccf, gallons, kva, kvar, kw, kwh, mcf, therms)
quantity = #:(0..)                                 ; Quantity billed
rate = #$                                          ; Rate per unit
rate_schedule = :                                  ; Rate schedule reference

; Rate components
base_rate = #$                                     ; Base rate per unit
adjustment_factor = #                              ; Rate adjustment factor
effective_rate = #$                                ; Effective rate after adjustments

; Tier information (tiered rates)
tier = ##                                          ; Tier number
tier_start = #:(0..)                               ; Tier start quantity
tier_end = #:(0..)                                 ; Tier end quantity

; Time-of-use
tou_period = (mid_peak, off_peak, on_peak, super_off_peak)
season = (shoulder, summer, winter)                ; Seasonal rate

; Tax details
tax_type = :                                       ; Tax type if applicable
tax_rate = #:(0..100)                              ; Tax percentage
taxable_amount = #$                                ; Amount subject to tax

; Proration
prorated = ?                                       ; Charge prorated flag
proration_factor = #:(0..1)                        ; Proration multiplier

{@bill}

; ═══════════════════════════════════════════════════════════════════════════════
; COMMODITY CHARGES (Electric, Gas, Water)
; ═══════════════════════════════════════════════════════════════════════════════

{@commodity_charge}
; Required fields first
commodity = (electric, gas, water)                ; Commodity type
consumption = #:(0..)                             ; Consumption amount
uom = (ccf, gallons, kwh, mcf, therms)            ; Unit of measure
rate = #$:(0..)                                   ; Rate per unit
charge = #$:(0..)                                 ; Total charge

; Optional fields
rate_schedule = :                                  ; Rate schedule code
tier = ##                                          ; Tier if applicable
tou_period = (mid_peak, off_peak, on_peak, super_off_peak)
season = (shoulder, summer, winter)                ; Season

; Rate components (unbundled markets)
generation_rate = #$:(0..)                         ; Generation component
transmission_rate = #$:(0..)                       ; Transmission component
distribution_rate = #$:(0..)                       ; Distribution component

; Supplier information (competitive markets)
supplier_name = :                                  ; Energy supplier
supplier_rate = #$:(0..)                           ; Supplier's rate

{@commodity_charge}

; ═══════════════════════════════════════════════════════════════════════════════
; DEMAND CHARGE (Electric)
; ═══════════════════════════════════════════════════════════════════════════════

{@demand_charge}
; Required fields first
demand_kw = #:(0..)                               ; Billing demand in kW
rate = #$:(0..)                                   ; Rate per kW
charge = #$:(0..)                                 ; Total demand charge

; Optional fields
demand_type = (actual, contract, ratchet)          ; Demand basis
ratchet_percent = #:(0..100)                       ; Ratchet percentage
contract_demand = #:(0..)                          ; Contracted demand
demand_date = date                                 ; Date of peak
demand_time = time                                 ; Time of peak
tou_period = (mid_peak, off_peak, on_peak)         ; TOU period if applicable
season = (shoulder, summer, winter)                ; Season

; Components
distribution_demand_charge = #$:(0..)              ; Distribution demand
transmission_demand_charge = #$:(0..)              ; Transmission demand
capacity_charge = #$:(0..)                         ; Capacity charge

{@demand_charge}

; ═══════════════════════════════════════════════════════════════════════════════
; DELIVERY/TRANSMISSION CHARGES
; ═══════════════════════════════════════════════════════════════════════════════

{@delivery_charge}
; Required fields first
charge_type = (customer, delivery, distribution, transmission)
description = :                                   ; Charge description
amount = #$:(0..)                                 ; Charge amount

; Optional fields
basis = (consumption, demand, fixed)               ; Charge basis
quantity = #:(0..)                                 ; Quantity if applicable
rate = #$                                          ; Rate
uom = (kva, kw, kwh)                               ; Unit of measure

; Fixed charges
customer_charge = #$:(0..)                         ; Basic customer charge
meter_charge = #$:(0..)                            ; Meter charge
service_charge = #$:(0..)                          ; Service availability charge

{@delivery_charge}

; ═══════════════════════════════════════════════════════════════════════════════
; TAXES AND FEES
; ═══════════════════════════════════════════════════════════════════════════════

{@bill.taxes[]}
; Required fields first
tax_type = :                                      ; Tax type description
amount = #$:(0..)                                 ; Tax amount

; Optional fields
tax_code = :                                       ; Tax jurisdiction code
tax_rate = #:(0..100)                              ; Tax percentage
taxable_amount = #$:(0..)                          ; Amount subject to tax
jurisdiction = :                                   ; Taxing jurisdiction
state_province = :(2)                              ; State/province code

{@bill}
{@bill.fees[]}
; Required fields first
fee_type = :                                      ; Fee type description
amount = #$:(0..)                                 ; Fee amount

; Optional fields
fee_code = :                                       ; Fee code
description = :                                    ; Fee description
reason = :                                         ; Reason for fee

{@bill}

; ═══════════════════════════════════════════════════════════════════════════════
; CREDITS AND ADJUSTMENTS
; ═══════════════════════════════════════════════════════════════════════════════

{@bill.credits[]}
; Required fields first
credit_type = (adjustment, grant, overpayment, rebate, refund)
description = :                                   ; Credit description
amount = #$:(0..)                                 ; Credit amount

; Optional fields
credit_code = :                                    ; Credit code
reason = :                                         ; Reason for credit
reference = :                                      ; Reference number
applied_date = date                                ; Date credit applied
program = :                                        ; Program name if applicable

{@bill}
{@bill.adjustments[]}
; Required fields first
adjustment_type = (billing_error, estimated_to_actual, meter_error, rate_change, rebill, usage_correction)
description = :                                   ; Adjustment description
amount = #$                                       ; Adjustment amount (can be negative)

; Optional fields
adjustment_code = :                                ; Adjustment code
reason = :                                         ; Detailed reason
reference_bill = :                                 ; Original bill number
approved_by = :                                    ; Approver
approval_date = date                               ; Approval date

{@bill}

; ═══════════════════════════════════════════════════════════════════════════════
; PAYMENT
; ═══════════════════════════════════════════════════════════════════════════════

{@payment}
= @types.payment

; Required fields first
payment_id = :                                    ; Unique payment identifier
account_number = *:                                ; Account number

; Utility-specific payment fields
; Payment source
bank_routing = *:(9)                               ; Bank routing number
bank_account = *:                                  ; Bank account number (last 4 digits)
card_type = (amex, discover, mastercard, visa)     ; Card type
card_last_four = *:(4)                             ; Last 4 digits of card

; Payment allocation
{.allocations[]}
bill_number = :                                    ; Bill being paid
allocation_amount = #$:(0..)                      ; Amount allocated to bill
charge_type = :                                    ; Charge type if specific

{@payment}
; Auto-pay
auto_pay = ?                                       ; Auto-pay transaction
scheduled_date = date                              ; Scheduled payment date

; Payment plan
payment_plan_id = :                                ; Associated payment plan
installment_number = ##                            ; Installment number

; Processing
processor = :                                      ; Payment processor
transaction_id = :                                 ; Processor transaction ID
batch_id = :                                       ; Batch identifier

; Failed payments
failure_reason = :                                 ; Reason for failure
nsf_fee = #$:(0..)                                 ; NSF fee charged
reversed_date = date                               ; Date reversed if applicable

{@payment}

; ═══════════════════════════════════════════════════════════════════════════════
; RATE SCHEDULE
; ═══════════════════════════════════════════════════════════════════════════════

{@rate_schedule}
; Required fields first
rate_code = :                                     ; Rate schedule code
rate_name = :                                     ; Rate schedule name
commodity = (electric, gas, water)                ; Commodity type
customer_type = (commercial, government, industrial, residential)

; Optional fields
effective_date = date                              ; Effective date
tariff_number = :                                  ; Filed tariff reference
description = :                                    ; Rate description

; Fixed charges
customer_charge = #$:(0..)                         ; Monthly customer charge
meter_charge = #$:(0..)                            ; Meter charge
service_availability = #$:(0..)                    ; Service availability charge

; Energy/volume rates (tiered)
{.tiers[]}
tier_number = ##:(1..)                            ; Tier number
tier_start = #:(0..)                              ; Tier start quantity
tier_end = #:(0..)                                 ; Tier end quantity (blank for unlimited)
rate = #$:(0..)                                   ; Rate per unit
season = (all_year, shoulder, summer, winter)      ; Applicable season

{@rate_schedule}
; Demand rates (electric)
{.demand_rates[]}
rate = #$:(0..)                                   ; Demand rate per kW
tou_period = (all_day, mid_peak, off_peak, on_peak)
season = (all_year, shoulder, summer, winter)

{@rate_schedule}
; Time-of-use periods
{.tou_periods[]}
period_name = (mid_peak, off_peak, on_peak, super_off_peak)
season = (all_year, shoulder, summer, winter)
rate = #$:(0..)                                   ; Rate for period
days_of_week = :                                   ; Applicable days
start_time = time                                  ; Period start time
end_time = time                                    ; Period end time

{@rate_schedule}
; Riders and adjustments
{.riders[]}
rider_code = :                                    ; Rider code
rider_name = :                                     ; Rider description
rate = #$                                          ; Rate or fee
percent = #:(0..100)                               ; Percentage adjustment
applies_to = :                                     ; What rider applies to

{@rate_schedule}

; ═══════════════════════════════════════════════════════════════════════════════
; INVOICE HISTORY
; ═══════════════════════════════════════════════════════════════════════════════

{@bill.history[]}
event_type = (adjustment, generation, payment, rebill, void)
event_date = timestamp                            ; Event timestamp
description = :                                   ; Event description
performed_by = :                                   ; User who performed action
prior_amount = #$                                  ; Prior amount
new_amount = #$                                    ; New amount

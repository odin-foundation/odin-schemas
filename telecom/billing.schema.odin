; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Telecom Billing Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Invoices, monthly recurring charges, usage charges, regulatory fees
; (USF, E911), taxes, payments, and billing adjustments.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.telecom.billing"
version = "1.0.0"
title = "Telecom Billing Schema"
description = "Invoices, charges, regulatory fees, taxes, and payments"

{$derivation}
source[0].authority = "Federal Communications Commission"
source[0].citation = "47 CFR Part 64, Subpart M - Billing Practices"
source[0].url = "https://www.ecfr.gov/current/title-47/chapter-I/subchapter-B/part-64/subpart-M"

source[1].authority = "Federal Communications Commission"
source[1].citation = "47 CFR Part 54 - Universal Service Fund"
source[1].url = "https://www.ecfr.gov/current/title-47/chapter-I/subchapter-B/part-54"

source[2].authority = "Federal Communications Commission"
source[2].citation = "47 CFR Part 9 - 911 Requirements"
source[2].url = "https://www.ecfr.gov/current/title-47/chapter-I/subchapter-A/part-9"

source[3].authority = "TM Forum"
source[3].citation = "TMF678 - Customer Bill Management API"
source[3].url = "https://www.tmforum.org/resources/specification/tmf678-customer-bill-management-api/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial billing schema"
changelog[0].rationale = "Billing structure derived from FCC billing rules and USF requirements"

; ═══════════════════════════════════════════════════════════════════════════════
; INVOICE
; ═══════════════════════════════════════════════════════════════════════════════
; Customer invoice or bill

{@invoice}
= @types.audit_info

; ───────────────────────────────────────────────────────────────────────────────
; Invoice Identification (Required)
; ───────────────────────────────────────────────────────────────────────────────
invoice_id = :                                   ; Unique invoice identifier
invoice_number = :                               ; Invoice number (customer-facing)
account_ref = :                                  ; Account reference

; ───────────────────────────────────────────────────────────────────────────────
; Invoice Dates
; ───────────────────────────────────────────────────────────────────────────────
{.dates}
invoice_date = date                              ; Invoice generation date
due_date = date                                  ; Payment due date
period_start = date                              ; Billing period start
period_end = date                                ; Billing period end

{@invoice}

; ───────────────────────────────────────────────────────────────────────────────
; Invoice Status
; ───────────────────────────────────────────────────────────────────────────────
status = (cancelled, paid, partial_payment, past_due, pending)
status_date = date                                ; Status change date

; ───────────────────────────────────────────────────────────────────────────────
; Invoice Totals
; ───────────────────────────────────────────────────────────────────────────────
{.totals}
subtotal = #$:(0..)                              ; Subtotal before taxes and fees
taxes = #$:(0..)                                 ; Total taxes
regulatory_fees = #$:(0..)                       ; Total regulatory fees
total_charges = #$:(0..)                         ; Total charges
total_credits = #$:(0..)                          ; Total credits/adjustments
previous_balance = #$                             ; Previous balance carried forward
payments_received = #$:(0..)                      ; Payments received this period
balance_due = #$                                 ; Current balance due
past_due_amount = #$:(0..)                        ; Past due amount

{@invoice}

; ───────────────────────────────────────────────────────────────────────────────
; Charge Line Items
; ───────────────────────────────────────────────────────────────────────────────
charges[] = @charge_line_item                     ; Itemized charges

; ───────────────────────────────────────────────────────────────────────────────
; Tax Line Items
; ───────────────────────────────────────────────────────────────────────────────
taxes[] = @tax_line_item                          ; Itemized taxes

; ───────────────────────────────────────────────────────────────────────────────
; Regulatory Fee Line Items
; ───────────────────────────────────────────────────────────────────────────────
regulatory_fees[] = @regulatory_fee_line_item     ; Itemized regulatory fees

; ───────────────────────────────────────────────────────────────────────────────
; Payment History
; ───────────────────────────────────────────────────────────────────────────────
payments[] = @payment                             ; Payments applied to invoice

; ───────────────────────────────────────────────────────────────────────────────
; Delivery Information
; ───────────────────────────────────────────────────────────────────────────────
{.delivery}
delivery_method = (both, email, mail, online_only)
delivered_date = date                             ; Date invoice delivered
email_sent = ?                                    ; Email notification sent
mailed = ?                                        ; Physical bill mailed

{@invoice}

; ═══════════════════════════════════════════════════════════════════════════════
; CHARGE LINE ITEM
; ═══════════════════════════════════════════════════════════════════════════════
; Individual charge on invoice

{@charge_line_item}
; ───────────────────────────────────────────────────────────────────────────────
; Charge Identification
; ───────────────────────────────────────────────────────────────────────────────
charge_id = :                                    ; Unique charge identifier
line_number = ##:(0..)                            ; Line number on invoice

; ───────────────────────────────────────────────────────────────────────────────
; Charge Description
; ───────────────────────────────────────────────────────────────────────────────
description = :                                  ; Charge description
charge_category = (
    activation,
    adjustment,
    credit,
    device,
    discount,
    equipment,
    feature,
    installation,
    late_fee,
    overage,
    plan,
    roaming,
    usage
)

; ───────────────────────────────────────────────────────────────────────────────
; Charge Type
; ───────────────────────────────────────────────────────────────────────────────
charge_type = (credit, one_time, recurring, usage)
recurring_period = (annual, monthly, quarterly, weekly)

; ───────────────────────────────────────────────────────────────────────────────
; Charge Amount
; ───────────────────────────────────────────────────────────────────────────────
{.amount}
unit_price = #$:(0..)                             ; Price per unit
quantity = #:(0..)                                ; Quantity
amount = #$                                      ; Total charge amount (can be negative for credits)

{@charge_line_item}

; ───────────────────────────────────────────────────────────────────────────────
; Service/Subscription Reference
; ───────────────────────────────────────────────────────────────────────────────
subscription_ref = :                              ; Associated subscription
phone_number = :                                  ; Associated phone number
device_ref = :                                    ; Associated device

; ───────────────────────────────────────────────────────────────────────────────
; Proration (if applicable)
; ───────────────────────────────────────────────────────────────────────────────
{.proration}
prorated = ?                                      ; Charge is prorated
days_in_period = ##:(0..)                         ; Days in billing period
days_charged = ##:(0..)                           ; Days actually charged
proration_start = date                            ; Proration start date
proration_end = date                              ; Proration end date

{@charge_line_item}

; ───────────────────────────────────────────────────────────────────────────────
; Usage Details (for usage charges)
; ───────────────────────────────────────────────────────────────────────────────
{.usage_details}
usage_type = (data, messaging, voice)
units_used = #:(0..)                              ; Units used (minutes, MB, messages)
allowance_units = #:(0..)                         ; Included allowance
overage_units = #:(0..)                           ; Overage units
rate_per_unit = #$:(0..)                          ; Rate per unit

{@charge_line_item}

; ═══════════════════════════════════════════════════════════════════════════════
; TAX LINE ITEM
; ═══════════════════════════════════════════════════════════════════════════════
; Individual tax on invoice

{@tax_line_item}
; ───────────────────────────────────────────────────────────────────────────────
; Tax Identification
; ───────────────────────────────────────────────────────────────────────────────
tax_id = *:                                       ; Unique tax identifier
line_number = ##:(0..)                            ; Line number on invoice

; ───────────────────────────────────────────────────────────────────────────────
; Tax Description
; ───────────────────────────────────────────────────────────────────────────────
description = :                                  ; Tax description
tax_name = :                                     ; Tax name

; ───────────────────────────────────────────────────────────────────────────────
; Tax Type and Jurisdiction
; ───────────────────────────────────────────────────────────────────────────────
tax_type = (city, county, federal, local, state)
jurisdiction = :                                  ; Tax jurisdiction
tax_code = :                                      ; Tax code/identifier

; ───────────────────────────────────────────────────────────────────────────────
; Tax Calculation
; ───────────────────────────────────────────────────────────────────────────────
{.calculation}
taxable_amount = #$:(0..)                        ; Amount subject to tax
tax_rate = #:(0..100)                            ; Tax rate percentage
tax_amount = #$:(0..)                            ; Tax amount

{@tax_line_item}

; ───────────────────────────────────────────────────────────────────────────────
; Service Reference
; ───────────────────────────────────────────────────────────────────────────────
subscription_ref = :                              ; Associated subscription
charge_ref = :                                    ; Associated charge

; ═══════════════════════════════════════════════════════════════════════════════
; REGULATORY FEE LINE ITEM
; ═══════════════════════════════════════════════════════════════════════════════
; Regulatory fee or surcharge (USF, E911, etc.)

{@regulatory_fee_line_item}
; ───────────────────────────────────────────────────────────────────────────────
; Fee Identification
; ───────────────────────────────────────────────────────────────────────────────
fee_id = :                                       ; Unique fee identifier
line_number = ##:(0..)                            ; Line number on invoice

; ───────────────────────────────────────────────────────────────────────────────
; Fee Description
; ───────────────────────────────────────────────────────────────────────────────
description = :                                  ; Fee description
fee_name = :                                     ; Fee name

; ───────────────────────────────────────────────────────────────────────────────
; Fee Type
; ───────────────────────────────────────────────────────────────────────────────
fee_type = (
    "911_e911",
    administrative_fee,
    carrier_cost_recovery,
    emergency_services,
    federal_regulatory,
    local_regulatory,
    state_regulatory,
    trs_relay,
    universal_service_fund
)

; ───────────────────────────────────────────────────────────────────────────────
; Fee Calculation
; ───────────────────────────────────────────────────────────────────────────────
{.calculation}
base_amount = #$:(0..)                            ; Amount subject to fee
fee_rate = #:(0..100)                             ; Fee rate percentage (if applicable)
fee_amount = #$:(0..)                            ; Total fee amount
flat_fee = ?                                      ; Flat fee (not percentage)

{@regulatory_fee_line_item}

; ───────────────────────────────────────────────────────────────────────────────
; Regulatory Authority
; ───────────────────────────────────────────────────────────────────────────────
authority = :                                     ; Regulatory authority (FCC, state PUC, etc.)
mandate_reference = :                             ; Legal mandate reference

; ───────────────────────────────────────────────────────────────────────────────
; Service Reference
; ───────────────────────────────────────────────────────────────────────────────
subscription_ref = :                              ; Associated subscription
charge_ref = :                                    ; Associated charge

; ═══════════════════════════════════════════════════════════════════════════════
; PAYMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Customer payment record

{@payment}
= @types.payment

; ───────────────────────────────────────────────────────────────────────────────
; Payment Identification (Required)
; ───────────────────────────────────────────────────────────────────────────────
payment_id = :                                   ; Unique payment identifier
account_ref = :                                  ; Account reference

; ───────────────────────────────────────────────────────────────────────────────
; Payment Details (Additional telecom fields)
; ───────────────────────────────────────────────────────────────────────────────
{.details}
payment_method = (ach, cash, check, credit_card, debit_card, wire_transfer)

{@payment}

; ───────────────────────────────────────────────────────────────────────────────
; Payment Status (Additional telecom statuses)
; ───────────────────────────────────────────────────────────────────────────────
failure_reason = :                                ; Failure reason (if failed)

; ───────────────────────────────────────────────────────────────────────────────
; Payment Method Details
; ───────────────────────────────────────────────────────────────────────────────
{.method_details}
card_type = (amex, discover, mastercard, visa)    ; Card type
card_last_four = *:                               ; Last 4 digits of card (confidential)
check_number = :                                  ; Check number
confirmation_number = :                           ; Payment confirmation number
transaction_id = :                                ; Transaction identifier
authorization_code = :                            ; Authorization code

{@payment}

; ───────────────────────────────────────────────────────────────────────────────
; Payment Application
; ───────────────────────────────────────────────────────────────────────────────
{.application}
applied_to_invoice = :                            ; Invoice ID payment applied to
applied_to_balance = #$:(0..)                     ; Amount applied to account balance
unapplied_amount = #$:(0..)                       ; Unapplied/prepaid amount

{@payment}

; ───────────────────────────────────────────────────────────────────────────────
; Auto-Pay Details (if applicable)
; ───────────────────────────────────────────────────────────────────────────────
{.auto_pay}
auto_pay = ?                                      ; Auto-pay transaction
scheduled_date = date                             ; Scheduled payment date
retry_count = ##:(0..)                            ; Number of retry attempts

{@payment}

; ═══════════════════════════════════════════════════════════════════════════════
; BILLING ADJUSTMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Adjustment or credit to account

{@adjustment}
; ───────────────────────────────────────────────────────────────────────────────
; Adjustment Identification (Required)
; ───────────────────────────────────────────────────────────────────────────────
adjustment_id = :                                ; Unique adjustment identifier
account_ref = :                                  ; Account reference

; ───────────────────────────────────────────────────────────────────────────────
; Adjustment Details
; ───────────────────────────────────────────────────────────────────────────────
adjustment_date = date                           ; Adjustment date
adjustment_amount = #$                           ; Adjustment amount (negative for credit)
description = :                                  ; Adjustment description

; ───────────────────────────────────────────────────────────────────────────────
; Adjustment Type
; ───────────────────────────────────────────────────────────────────────────────
adjustment_type = (
    billing_error,
    courtesy_credit,
    dispute_resolution,
    goodwill,
    pricing_correction,
    promotional_credit,
    refund,
    service_credit,
    write_off
)

; ───────────────────────────────────────────────────────────────────────────────
; Adjustment Reason
; ───────────────────────────────────────────────────────────────────────────────
reason = :                                       ; Reason for adjustment
reason_code = :                                   ; Standardized reason code

; ───────────────────────────────────────────────────────────────────────────────
; Authorization
; ───────────────────────────────────────────────────────────────────────────────
{.authorization}
authorized_by = :                                 ; User who authorized adjustment
authorization_date = date                         ; Authorization date
approval_required = ?                             ; Manager approval required
approval_status = (approved, pending, rejected)

{@adjustment}

; ───────────────────────────────────────────────────────────────────────────────
; Related References
; ───────────────────────────────────────────────────────────────────────────────
invoice_ref = :                                   ; Related invoice
subscription_ref = :                              ; Related subscription
charge_ref = :                                    ; Related charge

; ═══════════════════════════════════════════════════════════════════════════════
; PAYMENT ARRANGEMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Payment plan or arrangement for past due balance

{@payment_arrangement}
; ───────────────────────────────────────────────────────────────────────────────
; Arrangement Identification (Required)
; ───────────────────────────────────────────────────────────────────────────────
arrangement_id = :                               ; Unique arrangement identifier
account_ref = :                                  ; Account reference

; ───────────────────────────────────────────────────────────────────────────────
; Arrangement Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
arrangement_date = date                          ; Arrangement date
total_amount = #$:(0..)                          ; Total amount in arrangement
installments = ##:(1..)                          ; Number of installments
installment_amount = #$:(0..)                    ; Installment amount
start_date = date                                ; First payment date
frequency = (biweekly, monthly, weekly)

{@payment_arrangement}

; ───────────────────────────────────────────────────────────────────────────────
; Arrangement Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, broken, cancelled, completed)
status_date = date                                ; Status change date

; ───────────────────────────────────────────────────────────────────────────────
; Payment Tracking
; ───────────────────────────────────────────────────────────────────────────────
{.tracking}
installments_paid = ##:(0..)                      ; Installments paid
installments_remaining = ##:(0..)                 ; Installments remaining
amount_paid = #$:(0..)                            ; Amount paid
balance_remaining = #$:(0..)                      ; Balance remaining
last_payment_date = date                          ; Last payment date
next_payment_date = date                          ; Next payment due date
missed_payments = ##:(0..)                        ; Number of missed payments

{@payment_arrangement}

; ───────────────────────────────────────────────────────────────────────────────
; Terms and Conditions
; ───────────────────────────────────────────────────────────────────────────────
{.terms}
late_fee_waived = ?                               ; Late fees waived during arrangement
service_suspension_waived = ?                     ; Service suspension waived
default_terms = :                                 ; Terms if arrangement is broken

{@payment_arrangement}

; ═══════════════════════════════════════════════════════════════════════════════
; DISPUTE
; ═══════════════════════════════════════════════════════════════════════════════
; Billing dispute or customer inquiry

{@dispute}
; ───────────────────────────────────────────────────────────────────────────────
; Dispute Identification (Required)
; ───────────────────────────────────────────────────────────────────────────────
dispute_id = :                                   ; Unique dispute identifier
account_ref = :                                  ; Account reference

; ───────────────────────────────────────────────────────────────────────────────
; Dispute Details
; ───────────────────────────────────────────────────────────────────────────────
dispute_date = date                              ; Dispute filing date
disputed_amount = #$:(0..)                       ; Amount in dispute
description = :                                  ; Dispute description

; ───────────────────────────────────────────────────────────────────────────────
; Dispute Type
; ───────────────────────────────────────────────────────────────────────────────
dispute_type = (
    billing_error,
    fraud,
    service_quality,
    unauthorized_charge,
    usage_dispute
)

; ───────────────────────────────────────────────────────────────────────────────
; Dispute Status
; ───────────────────────────────────────────────────────────────────────────────
status = (closed, escalated, pending, resolved)
status_date = date                                ; Status change date
resolution = :                                    ; Resolution description
resolution_date = date                            ; Resolution date

; ───────────────────────────────────────────────────────────────────────────────
; Related References
; ───────────────────────────────────────────────────────────────────────────────
invoice_ref = :                                   ; Disputed invoice
charge_ref = :                                    ; Disputed charge
subscription_ref = :                              ; Related subscription

; ───────────────────────────────────────────────────────────────────────────────
; Investigation
; ───────────────────────────────────────────────────────────────────────────────
{.investigation}
assigned_to = :                                   ; Investigator/agent assigned
investigation_notes = :                           ; Investigation notes
evidence_provided = ?                             ; Customer provided evidence

{@dispute}

; ───────────────────────────────────────────────────────────────────────────────
; Outcome
; ───────────────────────────────────────────────────────────────────────────────
{.outcome}
outcome = (adjustment_applied, dispute_denied, partial_credit)
adjustment_ref = :                                ; Adjustment applied (if any)
customer_notified = ?                             ; Customer notified of outcome
notification_date = date                          ; Notification date

{@dispute}

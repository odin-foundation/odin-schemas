; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Legal Billing Invoice Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Legal billing invoices compliant with LEDES billing standards (1998B, 2000,
; eBilling XML). Covers line items with UTBMS task/activity codes, expense
; entries, adjustments, trust account transactions, and payment tracking.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as legal
@import "../../common/types.schema.odin" as common

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.legal.billing.invoice"
version = "1.0.0"
title = "Legal Billing Invoice Schema"
description = "LEDES-compliant legal billing invoices"

{$derivation}
source[0].authority = "Legal Electronic Data Exchange Standard"
source[0].citation = "LEDES 1998B Specification"
source[0].url = "https://ledes.org/ledes-98b-format/"

source[1].authority = "Legal Electronic Data Exchange Standard"
source[1].citation = "LEDES 2000 Specification"
source[1].url = "https://ledes.org/ledes-2000/"

source[2].authority = "Legal Electronic Data Exchange Standard"
source[2].citation = "LEDES eBilling XML Specification"
source[2].url = "https://ledes.org/ledes-xml-ebilling-ver-2-2/"

source[3].authority = "Uniform Task-Based Management System"
source[3].citation = "UTBMS Code Sets"
source[3].url = "https://ledes.org/utbms/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Invoice schema derived from LEDES billing format specifications"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial legal invoice schema"
changelog[0].rationale = "LEDES-compliant billing structure"

; ═══════════════════════════════════════════════════════════════════════════════
; LEGAL INVOICE
; ═══════════════════════════════════════════════════════════════════════════════
; Primary invoice record

{@legal_invoice}
; Required fields first (LEDES required fields)
invoice_date = !date                              ; Invoice date (INV_DATE)
invoice_number = !:                               ; Invoice number (INVOICE_NUMBER)
invoice_total = !#$:(0..)                         ; Invoice total (INVOICE_TOTAL)

; Invoice identification
invoice_id = :                                    ; Internal invoice ID
ledes_invoice_id = :                              ; LEDES invoice ID

; ───────────────────────────────────────────────────────────────────────────────
; Client/Matter Information (LEDES fields)
; ───────────────────────────────────────────────────────────────────────────────
{.client}
client_id = :                                     ; CLIENT_ID
client_name = :                                   ; Client name
client_matter_id = :                              ; CLIENT_MATTER_ID
matter_name = :                                   ; Matter description
matter_ref = @legal_matter_ref                    ; Reference to matter

{@legal_invoice}

; ───────────────────────────────────────────────────────────────────────────────
; Law Firm Information (LEDES fields)
; ───────────────────────────────────────────────────────────────────────────────
{.firm}
law_firm_id = :                                   ; LAW_FIRM_ID
law_firm_name = :                                 ; Law firm name
law_firm_matter_id = :                            ; LAW_FIRM_MATTER_ID
billing_attorney = :                              ; Billing attorney name
billing_attorney_ref = @legal_attorney            ; Reference to attorney
firm_address = @address                           ; Firm billing address
firm_tax_id = *:                                  ; Firm tax ID

{@legal_invoice}

; ───────────────────────────────────────────────────────────────────────────────
; Billing Period
; ───────────────────────────────────────────────────────────────────────────────
{.period}
billing_start_date = date                         ; BILLING_START_DATE
billing_end_date = date                           ; BILLING_END_DATE
billing_frequency = (biweekly, monthly, quarterly, upon_request)

{@legal_invoice}

; ───────────────────────────────────────────────────────────────────────────────
; Line Items
; ───────────────────────────────────────────────────────────────────────────────
line_items[] = @invoice_line_item                 ; Invoice line items

{@legal_invoice}

; ───────────────────────────────────────────────────────────────────────────────
; Fee Summary
; ───────────────────────────────────────────────────────────────────────────────
{.fees}
total_fees = #$:(0..)                             ; Total fees
total_hours = #:(0..)                             ; Total hours billed
blended_rate = #$:(0..)                           ; Effective blended rate
discount_amount = #$:(0..)                        ; Discount applied
discount_percentage = #:(0..100)                  ; Discount percentage
net_fees = #$:(0..)                               ; Net fees after discount

{@legal_invoice}

; ───────────────────────────────────────────────────────────────────────────────
; Expense Summary
; ───────────────────────────────────────────────────────────────────────────────
{.expenses}
total_expenses = #$:(0..)                         ; Total expenses
expense_markup = #$:(0..)                         ; Markup amount
net_expenses = #$:(0..)                           ; Net expenses

{@legal_invoice}

; ───────────────────────────────────────────────────────────────────────────────
; Tax
; ───────────────────────────────────────────────────────────────────────────────
{.tax}
tax_applicable = ?                                ; Tax applies
tax_rate = #:(0..100):if tax_applicable = true    ; Tax rate
tax_amount = #$:if tax_applicable = true          ; Tax amount
tax_jurisdiction = ::if tax_applicable = true     ; Tax jurisdiction

{@legal_invoice}

; ───────────────────────────────────────────────────────────────────────────────
; Invoice Totals
; ───────────────────────────────────────────────────────────────────────────────
{.totals}
subtotal = #$:(0..)                               ; Subtotal before tax
total_adjustments = #$                            ; Total adjustments
invoice_total = #$:(0..)                          ; Invoice total
previous_balance = #$                             ; Previous balance forward
payments_received = #$:(0..)                      ; Payments during period
credits_applied = #$:(0..)                        ; Credits applied
amount_due = #$                                   ; Amount currently due
trust_applied = #$:(0..)                          ; Amount from trust

{@legal_invoice}

; ───────────────────────────────────────────────────────────────────────────────
; Payment Terms
; ───────────────────────────────────────────────────────────────────────────────
{.terms}
due_date = date                                   ; Payment due date
payment_terms_days = ##:(0..)                     ; Net days
late_fee_applicable = ?                           ; Late fee applies
late_fee_rate = #:(0..100):if late_fee_applicable = true
interest_rate = #:(0..100)                        ; Interest on overdue
remittance_address = @address                     ; Payment address
wire_instructions = :                             ; Wire transfer info
ach_instructions = :                              ; ACH info

{@legal_invoice}

; ───────────────────────────────────────────────────────────────────────────────
; Budget Tracking
; ───────────────────────────────────────────────────────────────────────────────
{.budget}
budget_amount = #$:(0..)                          ; Matter budget
budget_used_prior = #$:(0..)                      ; Budget used before this invoice
budget_used_this = #$:(0..)                       ; This invoice amount
budget_remaining = #$                             ; Remaining budget
over_budget = ?                                   ; Invoice exceeds budget

{@legal_invoice}

; ───────────────────────────────────────────────────────────────────────────────
; E-Billing
; ───────────────────────────────────────────────────────────────────────────────
{.ebilling}
ledes_format = (ledes_1998b, ledes_2000, ledes_xml)
ebilling_vendor = :                               ; E-billing vendor name
submission_date = date                            ; Date submitted to ebilling
submission_id = :                                 ; Submission confirmation ID
validation_passed = ?                             ; Passed validation
validation_errors[] = :                           ; Validation error messages

{@legal_invoice}

; ───────────────────────────────────────────────────────────────────────────────
; Adjustments
; ───────────────────────────────────────────────────────────────────────────────
adjustments[] = @invoice_adjustment               ; Invoice adjustments

{@legal_invoice}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (appealed, approved, draft, paid, partial_payment, pending, rejected, sent, submitted, void, write_off)
status_date = date                                ; Date of current status
paid_date = date:if status = paid                 ; Date paid in full
paid_amount = #$:(0..):if status = paid | status = partial_payment
void_reason = ::if status = void                  ; Reason for voiding
rejection_reason = ::if status = rejected         ; Reason for rejection
write_off_amount = #$:(0..):if status = write_off ; Amount written off

; ═══════════════════════════════════════════════════════════════════════════════
; INVOICE LINE ITEM
; ═══════════════════════════════════════════════════════════════════════════════
; Individual line item on invoice (fee or expense)

{@invoice_line_item}
; Required fields first (LEDES required)
line_item_date = !date                            ; LINE_ITEM_DATE
line_item_description = !:                        ; LINE_ITEM_DESCRIPTION
line_item_total = !#$:(0..)                       ; LINE_ITEM_TOTAL
line_item_type = !(expense, fee)                  ; Fee or expense

; Line item identification
line_item_number = ##:(1..)                       ; LINE_ITEM_NUMBER

; ───────────────────────────────────────────────────────────────────────────────
; Timekeeper (for fee entries)
; ───────────────────────────────────────────────────────────────────────────────
{.timekeeper}
timekeeper_id = ::if line_item_type = fee         ; TIMEKEEPER_ID
timekeeper_name = ::if line_item_type = fee       ; Timekeeper name
timekeeper_classification = ::if line_item_type = fee ; UTBMS classification
timekeeper_ref = @legal_timekeeper:if line_item_type = fee
rate = #$:(0..):if line_item_type = fee           ; LINE_ITEM_UNIT_COST (rate)

{@invoice_line_item}

; ───────────────────────────────────────────────────────────────────────────────
; Time (for fee entries)
; ───────────────────────────────────────────────────────────────────────────────
{.time}
hours = #:(0..):if line_item_type = fee           ; LINE_ITEM_NUMBER_OF_UNITS
billable_hours = #:(0..):if line_item_type = fee  ; Billable hours
adjustment_hours = #:if line_item_type = fee      ; Hours adjusted
time_entry_ref = @legal_time_entry:if line_item_type = fee

{@invoice_line_item}

; ───────────────────────────────────────────────────────────────────────────────
; UTBMS Codes
; ───────────────────────────────────────────────────────────────────────────────
{.utbms}
task_code = :                                     ; TASK_UTBMS_CODE
activity_code = :                                 ; ACTIVITY_UTBMS_CODE
expense_code = ::if line_item_type = expense      ; EXPENSE_UTBMS_CODE
phase_code = :                                    ; Phase code

{@invoice_line_item}

; ───────────────────────────────────────────────────────────────────────────────
; Expense Details (for expense entries)
; ───────────────────────────────────────────────────────────────────────────────
{.expense}
expense_type = ::if line_item_type = expense      ; Type of expense
vendor_name = ::if line_item_type = expense       ; Vendor name
quantity = #:(0..):if line_item_type = expense    ; Quantity
unit_cost = #$:(0..):if line_item_type = expense  ; Unit cost
markup_percentage = #:(0..100):if line_item_type = expense
markup_amount = #$:(0..):if line_item_type = expense
receipt_attached = ?:if line_item_type = expense  ; Receipt available
expense_entry_ref = @legal_expense:if line_item_type = expense

{@invoice_line_item}

; ───────────────────────────────────────────────────────────────────────────────
; Adjustments
; ───────────────────────────────────────────────────────────────────────────────
{.adjustments}
adjustment_type = (courtesy, error, negotiated, no_charge, other)
original_amount = #$:(0..)                        ; Original line total
adjustment_amount = #$                            ; Adjustment (+/-)
adjustment_reason = :                             ; Reason for adjustment

{@invoice_line_item}

; ═══════════════════════════════════════════════════════════════════════════════
; INVOICE ADJUSTMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Invoice-level adjustment

{@invoice_adjustment}
; Required fields first
adjustment_date = !date                           ; Adjustment date
adjustment_type = !(courtesy, credit, error_correction, negotiated, write_off)
adjustment_amount = !#$                           ; Adjustment amount (+/-)

; Adjustment identification
adjustment_id = :                                 ; Unique adjustment ID

; Details
{.details}
description = :                                   ; Adjustment description
approved_by = :                                   ; Who approved
approval_date = date                              ; Approval date
line_items_affected[] = ##:(1..)                  ; Line item numbers affected
applies_to = (all, expenses, fees, specific_items) ; What adjustment applies to

{@invoice_adjustment}

; ═══════════════════════════════════════════════════════════════════════════════
; LEGAL TIMEKEEPER
; ═══════════════════════════════════════════════════════════════════════════════
; Timekeeper for billing purposes

{@legal_timekeeper}
; Required fields first (LEDES required)
timekeeper_id = !:                                ; TIMEKEEPER_ID
timekeeper_name = !:                              ; Timekeeper name
timekeeper_classification = !:                    ; UTBMS classification code

; ───────────────────────────────────────────────────────────────────────────────
; Classification
; ───────────────────────────────────────────────────────────────────────────────
{.classification}
role = (associate, contract_attorney, law_clerk, of_counsel, paralegal, partner, senior_associate, staff_attorney, summer_associate)
practice_group = :                                ; Practice group/department
years_experience = ##:(0..)                       ; Years of experience
bar_date = date                                   ; Bar admission date

{@legal_timekeeper}

; Reference
attorney_ref = @legal_attorney                    ; Reference to attorney
staff_ref = @legal_staff                          ; Reference to staff

; ───────────────────────────────────────────────────────────────────────────────
; Rates
; ───────────────────────────────────────────────────────────────────────────────
{.rates}
standard_rate = #$:(0..)                          ; Standard hourly rate
rate_effective_date = date                        ; Rate effective date
ledes_rate = #$:(0..)                             ; LEDES rate for this client/matter

{@legal_timekeeper}

; Client-specific rates
{.rates.client_rates[]}
client_id = :                                     ; Client ID
matter_id = :                                     ; Matter ID (if matter-specific)
agreed_rate = #$:(0..)                            ; Agreed rate
rate_effective = date                             ; Effective date
rate_expiration = date                            ; Expiration date

{@legal_timekeeper}

; Status
active = ?                                        ; Currently billable

; ═══════════════════════════════════════════════════════════════════════════════
; LEGAL TIME ENTRY
; ═══════════════════════════════════════════════════════════════════════════════
; Individual time entry

{@legal_time_entry}
; Required fields first
work_date = !date                                 ; Date work performed
description = !:                                  ; Work description
hours = !#:(0..)                                  ; Hours worked

; Time entry identification
entry_id = :                                      ; Unique entry ID

; ───────────────────────────────────────────────────────────────────────────────
; Timekeeper
; ───────────────────────────────────────────────────────────────────────────────
{.timekeeper}
timekeeper_ref = @legal_timekeeper                ; Reference to timekeeper
timekeeper_id = :                                 ; Timekeeper ID
timekeeper_name = :                               ; Timekeeper name

{@legal_time_entry}

; ───────────────────────────────────────────────────────────────────────────────
; Matter
; ───────────────────────────────────────────────────────────────────────────────
{.matter}
matter_ref = @legal_matter_ref                    ; Reference to matter
client_id = :                                     ; Client ID
matter_id = :                                     ; Matter ID

{@legal_time_entry}

; ───────────────────────────────────────────────────────────────────────────────
; UTBMS Codes
; ───────────────────────────────────────────────────────────────────────────────
{.utbms}
task_code = :                                     ; UTBMS task code
activity_code = :                                 ; UTBMS activity code
phase_code = :                                    ; UTBMS phase code

{@legal_time_entry}

; ───────────────────────────────────────────────────────────────────────────────
; Billing
; ───────────────────────────────────────────────────────────────────────────────
{.billing}
billable = ?                                      ; Time is billable
rate = #$:(0..)                                   ; Billing rate
amount = #$:(0..)                                 ; Total amount (hours * rate)
no_charge = ?                                     ; No charge entry
no_charge_reason = ::if no_charge = true          ; Reason for no charge
write_down = #:(0..):if billable = true           ; Hours written down
write_down_reason = ::if write_down > 0           ; Reason for write down

{@legal_time_entry}

; ───────────────────────────────────────────────────────────────────────────────
; Timer
; ───────────────────────────────────────────────────────────────────────────────
{.timer}
timer_used = ?                                    ; Timer was used
start_time = time:if timer_used = true            ; Timer start
end_time = time:if timer_used = true              ; Timer end
actual_duration = #:(0..):if timer_used = true    ; Actual minutes

{@legal_time_entry}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (approved, billed, draft, pending_approval, rejected, void)
status_date = date                                ; Date of status
approved_by = ::if status = approved | status = billed
rejection_reason = ::if status = rejected
invoice_ref = @legal_invoice:if status = billed   ; Reference to invoice
invoice_line_number = ##:(1..):if status = billed ; Line item number

; ═══════════════════════════════════════════════════════════════════════════════
; LEGAL EXPENSE
; ═══════════════════════════════════════════════════════════════════════════════
; Expense entry

{@legal_expense}
; Required fields first
expense_date = !date                              ; Date of expense
expense_type = !(copies, courier, court_fees, deposition, expert, filing_fee, long_distance, meals, mileage, other, postage, printing, research, supplies, transcripts, travel)
description = !:                                  ; Expense description
amount = !#$:(0..)                                ; Expense amount

; Expense identification
expense_id = :                                    ; Unique expense ID

; ───────────────────────────────────────────────────────────────────────────────
; Matter
; ───────────────────────────────────────────────────────────────────────────────
{.matter}
matter_ref = @legal_matter_ref                    ; Reference to matter
client_id = :                                     ; Client ID
matter_id = :                                     ; Matter ID

{@legal_expense}

; ───────────────────────────────────────────────────────────────────────────────
; Person
; ───────────────────────────────────────────────────────────────────────────────
{.person}
incurred_by = :                                   ; Person who incurred
timekeeper_ref = @legal_timekeeper                ; Reference to timekeeper

{@legal_expense}

; ───────────────────────────────────────────────────────────────────────────────
; UTBMS Code
; ───────────────────────────────────────────────────────────────────────────────
expense_code = :                                  ; UTBMS expense code

; ───────────────────────────────────────────────────────────────────────────────
; Expense Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
vendor = :                                        ; Vendor name
quantity = #:(0..)                                ; Quantity
unit_cost = #$:(0..)                              ; Cost per unit
receipt_available = ?                             ; Receipt on file
receipt_reference = ::if receipt_available = true ; Receipt reference
preapproved = ?                                   ; Preapproved expense
preapproval_reference = ::if preapproved = true   ; Preapproval reference

{@legal_expense}

; ───────────────────────────────────────────────────────────────────────────────
; Billing
; ───────────────────────────────────────────────────────────────────────────────
{.billing}
billable = ?                                      ; Expense is billable
markup_percentage = #:(0..100)                    ; Markup applied
markup_amount = #$:(0..)                          ; Markup amount
billing_amount = #$:(0..)                         ; Total billing amount
reimbursable = ?                                  ; Client will reimburse
no_charge = ?                                     ; No charge expense
no_charge_reason = ::if no_charge = true          ; Why no charge

{@legal_expense}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (approved, billed, draft, pending_approval, rejected, reimbursed, void)
status_date = date                                ; Date of status
approved_by = ::if status = approved | status = billed
rejection_reason = ::if status = rejected
invoice_ref = @legal_invoice:if status = billed   ; Reference to invoice
invoice_line_number = ##:(1..):if status = billed ; Line item number
reimbursement_date = date:if status = reimbursed  ; When reimbursed


; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Escrow Disbursement Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Escrow disbursement and funds distribution management including wire
; instructions, check disbursements, payoff demands, and disbursement ledgers.
; Covers authorization workflows, dual-control verification, and three-way
; reconciliation for escrow trust accounts.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as common
@import "../types.schema.odin" as re

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.realestate.escrow.disbursement"
version = "1.0.0"
title = "Escrow Disbursement Schema"
description = "Escrow disbursement and funds distribution"

{$derivation}
source[0].authority = "American Land Title Association"
source[0].citation = "ALTA Best Practices - Wire Fraud Prevention"
source[0].url = "https://www.alta.org/best-practices/"

source[1].authority = "Consumer Financial Protection Bureau"
source[1].citation = "RESPA Disbursement Requirements"
source[1].url = "https://www.consumerfinance.gov/rules-policy/regulations/1024/"

source[2].authority = "State Escrow Regulations"
source[2].citation = "Trust Account and Disbursement Requirements"
source[2].url = "varies by jurisdiction"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Disbursement schema derived from ALTA best practices and RESPA requirements"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial disbursement schema"
changelog[0].rationale = "Comprehensive escrow disbursement structure"

; ═══════════════════════════════════════════════════════════════════════════════
; DISBURSEMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Individual escrow disbursement

{@disbursement}
; Required fields first
amount = !#$:(0..)                                   ; Disbursement amount
disbursement_date = !date                            ; Disbursement date
payee_name = !:                                      ; Payee name

; Disbursement identification
disbursement_id = :                                  ; Unique disbursement identifier
escrow_number = :                                    ; Escrow/file number
check_number = :                                     ; Check number (if applicable)
wire_reference = :                                   ; Wire reference (if applicable)

; Transaction reference
transaction_ref = :                                  ; Reference to transaction

; ───────────────────────────────────────────────────────────────────────────────
; Disbursement Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
disbursement_type = !(commission, earnest_money_return, fee, lien_payoff, loan_payoff, net_proceeds, proration, recording, refund, tax, title_premium)
payment_method = (ach, cashiers_check, check, wire)
description = :                                      ; Description of disbursement
line_item_ref = :                                    ; Reference to settlement line item
account_code = :                                     ; Internal account code

{@disbursement}

; ───────────────────────────────────────────────────────────────────────────────
; Payee Information
; ───────────────────────────────────────────────────────────────────────────────
{.payee}
payee_type = (attorney, broker, buyer, contractor, government, lender, seller, service_provider, taxing_authority, title_company)
payee_address = @address                             ; Payee mailing address
payee_phone = @phone                                 ; Payee phone
payee_email = @email                                 ; Payee email
tax_id_required = ?                                  ; 1099 required
tax_id = *::if tax_id_required = true               ; Tax ID (confidential)
w9_on_file = ?:if tax_id_required = true            ; W-9 on file

{@disbursement}

; ───────────────────────────────────────────────────────────────────────────────
; Wire Details (if wire disbursement)
; ───────────────────────────────────────────────────────────────────────────────
{.wire}
wire_instruction_ref = @wire_instruction:if payment_method = wire
beneficiary_name = ::if payment_method = wire        ; Beneficiary name
beneficiary_account = *::if payment_method = wire    ; Account number (confidential)
bank_name = ::if payment_method = wire               ; Bank name
bank_aba = ::if payment_method = wire                ; Bank ABA/routing
bank_swift = ::if payment_method = wire              ; SWIFT code (international)
for_further_credit = ::if payment_method = wire      ; FFC instructions
reference = ::if payment_method = wire               ; Wire reference

{@disbursement}

; ───────────────────────────────────────────────────────────────────────────────
; Check Details (if check disbursement)
; ───────────────────────────────────────────────────────────────────────────────
{.check}
check_date = date:if payment_method = check | payment_method = cashiers_check
check_number = ::if payment_method = check | payment_method = cashiers_check
bank_account = ::if payment_method = check           ; Trust account used
delivery_method = (fedex, hand_delivery, mail, pickup, ups):if payment_method = check | payment_method = cashiers_check
tracking_number = ::if payment_method = check | payment_method = cashiers_check
delivery_address = @address:if payment_method = check | payment_method = cashiers_check

{@disbursement}

; ───────────────────────────────────────────────────────────────────────────────
; Authorization
; ───────────────────────────────────────────────────────────────────────────────
{.authorization}
authorized_by = :                                    ; Person authorizing
authorization_date = date                            ; Authorization date
dual_control = ?                                     ; Dual authorization required
second_authorized_by = ::if dual_control = true      ; Second authorizer
second_authorization_date = date:if dual_control = true
verified_by = :                                      ; Verification person
verification_date = date                             ; Verification date
verification_method = (callback, email, in_person, portal)

{@disbursement}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (authorized, cancelled, cleared, pending, processing, returned, sent, void)
status_date = date                                   ; Status date
cleared_date = date:if status = cleared              ; Check cleared/wire confirmed
return_reason = ::if status = returned               ; Return reason
void_reason = ::if status = void                     ; Void reason

; ═══════════════════════════════════════════════════════════════════════════════
; WIRE INSTRUCTION
; ═══════════════════════════════════════════════════════════════════════════════
; Verified wire transfer instructions

{@wire_instruction}
; Required fields first
beneficiary_name = !:                                ; Beneficiary name
bank_name = !:                                       ; Bank name
bank_routing = !:                                    ; ABA/Routing number

; Wire instruction identification
wire_id = :                                          ; Unique identifier
escrow_number = :                                    ; Escrow/file number

; ───────────────────────────────────────────────────────────────────────────────
; Beneficiary Information
; ───────────────────────────────────────────────────────────────────────────────
{.beneficiary}
name = :                                             ; Beneficiary name
account_number = *:                                  ; Account number (confidential)
account_type = (checking, savings, trust)            ; Account type
address = @address                                   ; Beneficiary address
phone = @phone                                       ; Beneficiary phone
email = @email                                       ; Beneficiary email

{@wire_instruction}

; ───────────────────────────────────────────────────────────────────────────────
; Bank Information
; ───────────────────────────────────────────────────────────────────────────────
{.bank}
name = :                                             ; Bank name
aba_routing = :                                      ; ABA routing number
swift_code = :                                       ; SWIFT/BIC code
address = @address                                   ; Bank address
phone = @phone                                       ; Bank phone

{@wire_instruction}

; Intermediary bank (if applicable)
{.bank.intermediary}
required = ?                                         ; Intermediary required
name = ::if required = true                          ; Intermediary bank name
aba_routing = ::if required = true                   ; Intermediary routing
swift_code = ::if required = true                    ; Intermediary SWIFT
for_further_credit = ::if required = true            ; FFC instructions

{@wire_instruction}

; ───────────────────────────────────────────────────────────────────────────────
; Verification
; ───────────────────────────────────────────────────────────────────────────────
{.verification}
verified = ?                                         ; Wire verified
verification_date = date:if verified = true          ; Date verified
verification_method = (callback, email, in_person, notarized, portal):if verified = true
verified_by = ::if verified = true                   ; Person who verified
callback_number = @phone:if verification_method = callback
callback_extension = ::if verification_method = callback
spoke_with = ::if verification_method = callback     ; Person spoken with
source_document = ::if verified = true               ; Source of wire instructions

{@wire_instruction}

; ───────────────────────────────────────────────────────────────────────────────
; Security
; ───────────────────────────────────────────────────────────────────────────────
{.security}
change_detected = ?                                  ; Change from previous
previous_aba = ::if change_detected = true           ; Previous ABA
previous_account = *::if change_detected = true      ; Previous account
change_verified = ?:if change_detected = true        ; Change verified
change_reason = ::if change_detected = true          ; Reason for change
fraud_alert = ?                                      ; Potential fraud indicator
fraud_alert_reason = ::if fraud_alert = true         ; Fraud concern description

{@wire_instruction}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, expired, pending_verification, rejected, superseded)
status_date = date                                   ; Status date
expiration_date = date                               ; Expiration date

; ═══════════════════════════════════════════════════════════════════════════════
; PAYOFF DEMAND
; ═══════════════════════════════════════════════════════════════════════════════
; Loan/lien payoff demand statement

{@payoff_demand}
; Required fields first
good_through_date = !date                            ; Payoff good through date
payoff_amount = !#$:(0..)                            ; Total payoff amount
property_address = !@address                         ; Property address

; Payoff identification
payoff_id = :                                        ; Unique identifier
loan_number = :                                      ; Loan number
escrow_number = :                                    ; Escrow/file number

; ───────────────────────────────────────────────────────────────────────────────
; Lender/Lienholder Information
; ───────────────────────────────────────────────────────────────────────────────
{.lender}
name = :                                             ; Lender/lienholder name
contact_name = :                                     ; Contact person
address = @address                                   ; Lender address
phone = @phone                                       ; Lender phone
fax = :                                              ; Lender fax
email = @email                                       ; Lender email

{@payoff_demand}

; ───────────────────────────────────────────────────────────────────────────────
; Loan Information
; ───────────────────────────────────────────────────────────────────────────────
{.loan}
loan_type = (construction, first_mortgage, heloc, home_equity, other, second_mortgage)
original_amount = #$:(0..)                           ; Original loan amount
current_principal = #$:(0..)                         ; Current principal balance
interest_rate = #:(0..100)                           ; Interest rate
maturity_date = date                                 ; Loan maturity date
borrower_names = :                                   ; Borrower name(s)

{@payoff_demand}

; ───────────────────────────────────────────────────────────────────────────────
; Payoff Breakdown
; ───────────────────────────────────────────────────────────────────────────────
{.breakdown}
principal_balance = #$:(0..)                         ; Principal balance
accrued_interest = #$:(0..)                          ; Accrued interest
interest_per_diem = #$:(0..)                         ; Interest per diem
prepayment_penalty = #$:(0..)                        ; Prepayment penalty
late_charges = #$:(0..)                              ; Late charges
escrow_balance = #$                                  ; Escrow balance (credit if positive)
suspense_balance = #$                                ; Suspense balance
fees = #$:(0..)                                      ; Other fees
recording_fee = #$:(0..)                             ; Recording fee
wire_fee = #$:(0..)                                  ; Wire fee
release_tracking_fee = #$:(0..)                      ; Release tracking fee
gross_payoff = #$:(0..)                              ; Gross payoff before credits
credits = #$:(0..)                                   ; Total credits
net_payoff = #$:(0..)                                ; Net payoff amount

{@payoff_demand}

; ───────────────────────────────────────────────────────────────────────────────
; Per Diem Information
; ───────────────────────────────────────────────────────────────────────────────
{.per_diem}
interest_per_diem = #$:(0..)                         ; Daily interest amount
first_day_of_interest = date                         ; First day interest was calc
good_through_date = date                             ; Payoff good through date
days_after_good_through = ##:(0..)                   ; Days interest calc'd after

{@payoff_demand}

; ───────────────────────────────────────────────────────────────────────────────
; Wire Instructions
; ───────────────────────────────────────────────────────────────────────────────
wire_instruction_ref = @wire_instruction             ; Reference to wire instructions

; Alternative payoff delivery
{.delivery}
payment_type = (cashiers_check, certified_funds, wire)
payee_name = :                                       ; Make payable to
delivery_address = @address                          ; Delivery address
overnight_required = ?                               ; Overnight required
special_instructions = :                             ; Special instructions

{@payoff_demand}

; ───────────────────────────────────────────────────────────────────────────────
; Release Information
; ───────────────────────────────────────────────────────────────────────────────
{.release}
release_method = (electronic, mail, record_direct, title_company)
release_turnaround = ##:(0..)                        ; Days to receive release
release_to = :                                       ; Release sent to
release_address = @address                           ; Release address
tracking_required = ?                                ; Lien release tracking

{@payoff_demand}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (cancelled, expired, ordered, paid, received, release_pending, release_received)
status_date = date                                   ; Status date
order_date = date                                    ; Date ordered
received_date = date                                 ; Date received
paid_date = date:if status = paid                    ; Date paid
wire_confirmation = ::if status = paid               ; Wire confirmation number
release_received_date = date:if status = release_received

; ═══════════════════════════════════════════════════════════════════════════════
; DISBURSEMENT LEDGER
; ═══════════════════════════════════════════════════════════════════════════════
; Complete ledger for escrow file

{@disbursement_ledger}
; Required fields first
escrow_number = !:                                   ; Escrow/file number
property_address = !@address                         ; Property address

; Ledger identification
ledger_id = :                                        ; Unique ledger identifier

; ───────────────────────────────────────────────────────────────────────────────
; Account Information
; ───────────────────────────────────────────────────────────────────────────────
{.account}
trust_account_name = :                               ; Trust account name
trust_account_number = :                             ; Trust account number
opening_date = date                                  ; File open date
closing_date = date                                  ; Expected closing date
closing_officer = :                                  ; Closing officer

{@disbursement_ledger}

; ───────────────────────────────────────────────────────────────────────────────
; Receipts
; ───────────────────────────────────────────────────────────────────────────────
{.receipts[]}
receipt_date = date                                  ; Receipt date
receipt_type = (earnest_money, loan_funds, other, payoff_balance, seller_deposit, title_premium)
payor = :                                            ; Payor name
amount = #$:(0..)                                    ; Amount received
payment_method = (ach, cashiers_check, check, wire)
reference_number = :                                 ; Reference/check number
deposited_date = date                                ; Date deposited
cleared_date = date                                  ; Date cleared

{@disbursement_ledger}

; ───────────────────────────────────────────────────────────────────────────────
; Disbursements
; ───────────────────────────────────────────────────────────────────────────────
disbursements[] = @disbursement                      ; List of disbursements

; ───────────────────────────────────────────────────────────────────────────────
; Balance Summary
; ───────────────────────────────────────────────────────────────────────────────
{.balance}
total_receipts = #$:(0..)                            ; Total receipts
total_disbursements = #$:(0..)                       ; Total disbursements
pending_disbursements = #$:(0..)                     ; Pending disbursements
current_balance = #$:(0..)                           ; Current balance
expected_balance_at_close = #$:(0..)                 ; Expected balance at close
out_of_balance = ?                                   ; File out of balance
variance = #$:if out_of_balance = true               ; Variance amount

{@disbursement_ledger}

; ───────────────────────────────────────────────────────────────────────────────
; Three-Way Reconciliation
; ───────────────────────────────────────────────────────────────────────────────
{.reconciliation}
bank_balance = #$:(0..)                              ; Bank statement balance
book_balance = #$:(0..)                              ; Book/ledger balance
outstanding_deposits = #$:(0..)                      ; Deposits in transit
outstanding_checks = #$:(0..)                        ; Outstanding checks
adjusted_bank_balance = #$:(0..)                     ; Adjusted bank balance
reconciled = ?                                       ; Is reconciled
reconciliation_date = date:if reconciled = true      ; Reconciliation date
reconciled_by = ::if reconciled = true               ; Reconciled by

{@disbursement_ledger}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (cancelled, closed, disbursed, funded, open, reconciled)
status_date = date                                   ; Status date


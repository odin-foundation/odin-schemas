; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Finance Payments Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Payment messaging derived from ISO 20022 pacs (Payments Clearing and
; Settlement) and pain (Payments Initiation) message families.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as fin

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.finance.payments"
version = "1.0.0"
title = "Finance Payments Schema"
description = "Payment initiation and clearing messages derived from ISO 20022"

{$derivation}
source[0].authority = "ISO"
source[0].citation = "ISO 20022 pain.001 - Customer Credit Transfer Initiation"
source[0].url = "https://www.iso20022.org/catalogue-messages/iso-20022-messages-archive?search=pain.001"

source[1].authority = "ISO"
source[1].citation = "ISO 20022 pacs.008 - FI to FI Customer Credit Transfer"
source[1].url = "https://www.iso20022.org/catalogue-messages/iso-20022-messages-archive?search=pacs.008"

source[2].authority = "ISO"
source[2].citation = "ISO 20022 pain.008 - Customer Direct Debit Initiation"
source[2].url = "https://www.iso20022.org/catalogue-messages/iso-20022-messages-archive?search=pain.008"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial payments schema"
changelog[0].rationale = "Payment types derived from ISO 20022 pain/pacs messages"

; ═══════════════════════════════════════════════════════════════════════════════
; CREDIT TRANSFER INITIATION
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: pain.001 - CustomerCreditTransferInitiation

{@credit_transfer}
; Message header (required)
header = @fin.message_header                 ; Group header

; Payment information (required)
payment_info_id = :                          ; Payment information identifier
payment_method = (chk, trf, trd)             ; Payment method (check, transfer, draft)
requested_execution_date = date              ; Requested execution date

; Debtor (payer) information
debtors[] = @fin.party                       ; Debtors (multiple legal entities)
debtor_accounts[] = @fin.account             ; Debtor accounts (multi-account funding)
debtor_agent = @fin.financial_institution    ; Debtor's bank

; Charge bearer
charge_bearer = (cred, debt, shar, slev)      ; Who pays charges

; Transactions
transactions[] = @credit_transfer_transaction ; Credit transfer instructions

; ───────────────────────────────────────────────────────────────────────────────
; Credit Transfer Transaction
; ───────────────────────────────────────────────────────────────────────────────
{@credit_transfer_transaction}
; Required fields
instruction_id = :                           ; Unique instruction identifier
end_to_end_id = :                            ; End-to-end identifier
amount = @fin.amount                         ; Instructed amount

; Creditor (payee) information
creditor = @fin.party                        ; Creditor party
creditor_account = @fin.account               ; Creditor account
creditor_agent = @fin.financial_institution   ; Creditor's bank

; Intermediary agents (correspondent banks - chains can have 3+)
intermediary_agents[] = {@intermediary_agent}

{@intermediary_agent}
agent = @fin.financial_institution           ; Intermediary bank
account = @fin.account                        ; Intermediary account
sequence = ##:(1..)                           ; Order in correspondent chain

{@credit_transfer_transaction}

; Payment purpose
purpose_code = :                              ; Purpose code (ISO 20022 ExternalPurpose1Code)
category_purpose = :                          ; Category purpose code

; Remittance information
remittance_infos[] = @fin.remittance_info     ; Payment details (multiple invoices, POs)

; Regulatory reporting
regulatory_reporting[] = @fin.regulatory_reporting  ; Regulatory information

; Exchange rate (for cross-currency)
exchange_rate = @fin.exchange_rate            ; FX rate information

; Charges
charges[] = @fin.charges                      ; Transaction charges

; Instruction priority
priority = (high, norm)                       ; Processing priority

; ═══════════════════════════════════════════════════════════════════════════════
; DIRECT DEBIT INITIATION
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: pain.008 - CustomerDirectDebitInitiation

{@direct_debit}
; Message header
header = @fin.message_header                 ; Group header

; Payment information
payment_info_id = :                          ; Payment information identifier
payment_method = : "dd"                      ; Direct debit method
requested_collection_date = date             ; Requested collection date

; Creditor (collector) information
creditors[] = @fin.party                     ; Creditors (multiple collectors)
creditor_accounts[] = @fin.account           ; Creditor accounts (multi-account collection)
creditor_agent = @fin.financial_institution  ; Creditor's bank
creditor_scheme_id = :                        ; Creditor scheme identifier

; Charge bearer
charge_bearer = (cred, debt, shar, slev)      ; Who pays charges

; Direct debit type
sequence_type = (fnal, frst, ooff, rcur)     ; Sequence type (final, first, one-off, recurring)
local_instrument = :                          ; Local instrument code (CORE, B2B, etc.)

; Transactions
transactions[] = @direct_debit_transaction    ; Direct debit instructions

; ───────────────────────────────────────────────────────────────────────────────
; Direct Debit Transaction
; ───────────────────────────────────────────────────────────────────────────────
{@direct_debit_transaction}
; Required fields
instruction_id = :                           ; Unique instruction identifier
end_to_end_id = :                            ; End-to-end identifier
amount = @fin.amount                         ; Instructed amount

; Debtor (payer) information
debtors[] = @fin.party                       ; Debtors (joint account holders)
debtor_account = @fin.account                ; Debtor account
debtor_agent = @fin.financial_institution     ; Debtor's bank

; Mandate information
{.mandate}
id = :                                       ; Mandate identifier
date_of_signature = date                     ; Date mandate signed
amendment_indicator = ?                       ; Mandate has been amended
final_collection_date = date                  ; Final collection date
frequency = (adho, dail, inda, mian, mnth, qurt, semi, week, year)

{@direct_debit_transaction}

; Purpose
purpose_code = :                              ; Purpose code
category_purpose = :                          ; Category purpose

; Remittance information
remittance_infos[] = @fin.remittance_info     ; Payment details (multiple invoices)

; ═══════════════════════════════════════════════════════════════════════════════
; PAYMENT STATUS REPORT
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: pain.002 - CustomerPaymentStatusReport

{@payment_status}
; Message header
header = @fin.message_header                 ; Group header

; Original message reference
{.original}
message_id = :                               ; Original message identifier
message_name = :                              ; Original message type
created = timestamp                           ; Original creation date

{@payment_status}

; Group status
group_status = @fin.transaction_status        ; Overall status

; Individual statuses
transaction_statuses[] = @transaction_status_detail  ; Per-transaction status

; ───────────────────────────────────────────────────────────────────────────────
; Transaction Status Detail
; ───────────────────────────────────────────────────────────────────────────────
{@transaction_status_detail}
original_instruction_id = :                  ; Original instruction ID
original_end_to_end_id = :                   ; Original E2E ID
status = @fin.transaction_status             ; Transaction status
original_amount = @fin.amount                 ; Original instructed amount

; Reason information
reason_codes[] = :                            ; Status reason codes (multiple failure reasons)
additional_info = :                           ; Additional status information

; Charges deducted
charges[] = @fin.charges                      ; Charges applied

; ═══════════════════════════════════════════════════════════════════════════════
; PAYMENT RETURN
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: pacs.004 - PaymentReturn

{@payment_return}
; Message header
header = @fin.message_header                 ; Group header

; Original transaction reference
{.original}
message_id = :                               ; Original message identifier
instruction_id = :                           ; Original instruction ID
end_to_end_id = :                            ; Original E2E ID
interbank_settlement_date = date              ; Original settlement date

{@payment_return}

; Return reason
return_reason_codes[] = :                    ; Return reason codes (multiple contributing reasons)
return_reason_info = :                        ; Additional return information

; Returned amount
returned_amount = @fin.amount                ; Amount being returned
original_amount = @fin.amount                 ; Original transaction amount

; Parties
return_chain[] = @fin.financial_institution   ; Return chain agents

; Charges
charges[] = @fin.charges                      ; Return charges

; ═══════════════════════════════════════════════════════════════════════════════
; PAYMENT CANCELLATION REQUEST
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: camt.056 - FIToFIPaymentCancellationRequest

{@cancellation_request}
; Message header
header = @fin.message_header                 ; Group header

; Assigner/Assignee
assigner = @fin.party                        ; Party requesting cancellation
assignee = @fin.party                        ; Party to process cancellation

; Case identification
case_id = :                                  ; Case identifier
case_creator = :                              ; Case creator

; Original transaction
{.original}
message_id = :                               ; Original message ID
instruction_id = :                            ; Original instruction ID
end_to_end_id = :                             ; Original E2E ID
amount = @fin.amount                          ; Original amount

{@cancellation_request}

; Cancellation reason
cancellation_reasons[] = (cust, dupl, frad, tech, upay)  ; Reason codes (multiple contributing factors)
additional_info = :                           ; Additional information

; cust = Customer request
; dupl = Duplicate payment
; frad = Fraud suspected
; tech = Technical problems
; upay = Undue payment


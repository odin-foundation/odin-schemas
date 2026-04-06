; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Finance Cash Management Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Cash management messaging derived from ISO 20022 camt (Cash Management)
; family including account statements, balance reports, and notifications.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as fin

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.finance.cash"
version = "1.0.0"
title = "Finance Cash Management Schema"
description = "Cash management and account reporting derived from ISO 20022"

{$derivation}
source[0].authority = "ISO"
source[0].citation = "ISO 20022 camt.053 - Bank to Customer Statement"
source[0].url = "https://www.iso20022.org/catalogue-messages/iso-20022-messages-archive?search=camt.053"

source[1].authority = "ISO"
source[1].citation = "ISO 20022 camt.052 - Bank to Customer Account Report"
source[1].url = "https://www.iso20022.org/catalogue-messages/iso-20022-messages-archive?search=camt.052"

source[2].authority = "ISO"
source[2].citation = "ISO 20022 camt.054 - Bank to Customer Debit/Credit Notification"
source[2].url = "https://www.iso20022.org/catalogue-messages/iso-20022-messages-archive?search=camt.054"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial cash management schema"
changelog[0].rationale = "Cash management types derived from ISO 20022 camt messages"

; ═══════════════════════════════════════════════════════════════════════════════
; ACCOUNT STATEMENT
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: camt.053 - BankToCustomerStatement

{@statement}
; Message header
header = !@fin.message_header                 ; Group header

; Statement identification
statement_id = !:                             ; Statement identifier
sequence_number = ##:(1..)                    ; Statement sequence number
legal_sequence_number = ##:(1..)              ; Legal sequence number
created = !timestamp                          ; Statement creation date/time

; Account information
account = !@fin.account                       ; Account being reported
account_owner = @fin.party                    ; Account owner
account_servicer = @fin.financial_institution ; Servicing institution

; Statement period
{.period}
from = !timestamp                             ; Period start
to = !timestamp                               ; Period end

{@statement}

; Balances
balances[] = @balance                         ; Account balances

; Transactions (entries)
entries[] = @statement_entry                  ; Transaction entries

; Transaction summary
{.summary}
total_entries = ##:(0..)                      ; Total number of entries
total_credit_entries = ##:(0..)               ; Number of credit entries
total_debit_entries = ##:(0..)                ; Number of debit entries
total_credit_amount = @fin.amount             ; Sum of credits
total_debit_amount = @fin.amount              ; Sum of debits

{@statement}

; ───────────────────────────────────────────────────────────────────────────────
; Account Balance
; ───────────────────────────────────────────────────────────────────────────────
; ISO 20022: CashBalance

{@balance}
type = !(clav, clbd, fwav, info, itav, itbd, opav, opbd, prcd, xpcd)
amount = !@fin.amount                         ; Balance amount
credit_debit = !(crdt, dbit)                  ; Credit or debit balance
date = !date                                  ; Balance date
date_time = timestamp                         ; Balance date/time (if intraday)

; Balance type codes:
; clav = Closing Available
; clbd = Closing Booked
; fwav = Forward Available
; info = Information
; itav = Interim Available
; itbd = Interim Booked
; opav = Opening Available
; opbd = Opening Booked
; prcd = Previously Closed Booked
; xpcd = Expected

; ───────────────────────────────────────────────────────────────────────────────
; Statement Entry
; ───────────────────────────────────────────────────────────────────────────────
; ISO 20022: ReportEntry

{@statement_entry}
; Required fields
entry_reference = !:                          ; Entry reference
amount = !@fin.amount                         ; Entry amount
credit_debit = !(crdt, dbit)                  ; Credit or debit
status = !(book, info, pdng)                  ; Entry status

; Dates
booking_date = date                           ; Booking date
value_date = date                             ; Value date

; Bank transaction code
{.bank_transaction_code}
domain = :                                    ; Domain code
family = :                                    ; Family code
sub_family = :                                ; Sub-family code
proprietary_code = :                          ; Bank's proprietary code
issuer = :                                    ; Code issuer

{@statement_entry}

; Reversal indicator
reversal_indicator = ?                        ; Entry is a reversal

; Transaction details
entry_details[] = @entry_detail               ; Underlying transaction details

; ───────────────────────────────────────────────────────────────────────────────
; Entry Detail
; ───────────────────────────────────────────────────────────────────────────────
{@entry_detail}
; Transaction references
message_id = :                                ; Original message ID
instruction_id = :                            ; Original instruction ID
end_to_end_id = :                             ; End-to-end identifier
transaction_id = :                            ; Transaction identifier
mandate_id = :                                ; Mandate identifier

; Amount
amount = @fin.amount                          ; Transaction amount
charges[] = @fin.charges                      ; Associated charges

; Parties
debtor = @fin.party                           ; Debtor
debtor_account = @fin.account                 ; Debtor account
debtor_agent = @fin.financial_institution     ; Debtor agent
creditor = @fin.party                         ; Creditor
creditor_account = @fin.account               ; Creditor account
creditor_agent = @fin.financial_institution   ; Creditor agent

; Remittance
remittance_info = @fin.remittance_info        ; Remittance information

; Purpose
purpose_code = :                              ; Purpose code

; Return information
{.return_info}
returned = ?                                  ; Transaction was returned
reason_code = :                               ; Return reason code
reason_info = :                               ; Return reason information

{@entry_detail}

; ═══════════════════════════════════════════════════════════════════════════════
; ACCOUNT REPORT (INTRADAY)
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: camt.052 - BankToCustomerAccountReport

{@account_report}
; Message header
header = !@fin.message_header                 ; Group header

; Report identification
report_id = !:                                ; Report identifier
sequence_number = ##:(1..)                    ; Report sequence
created = !timestamp                          ; Report creation time

; Account
account = !@fin.account                       ; Account being reported
account_owner = @fin.party                    ; Account owner
account_servicer = @fin.financial_institution ; Servicing institution

; Reporting period
{.period}
from = timestamp                              ; Period start (can be intraday)
to = timestamp                                ; Period end

{@account_report}

; Balances (typically real-time or near real-time)
balances[] = @balance                         ; Current balances

; Recent entries
entries[] = @statement_entry                  ; Recent entries

; ═══════════════════════════════════════════════════════════════════════════════
; DEBIT/CREDIT NOTIFICATION
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: camt.054 - BankToCustomerDebitCreditNotification

{@notification}
; Message header
header = !@fin.message_header                 ; Group header

; Notification identification
notification_id = !:                          ; Notification identifier
created = !timestamp                          ; Notification creation time

; Account
account = !@fin.account                       ; Account being notified
account_owner = @fin.party                    ; Account owner

; Notification entries (typically single transaction alerts)
entries[] = @statement_entry                  ; Notified transactions

; ═══════════════════════════════════════════════════════════════════════════════
; BALANCE INQUIRY
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: camt.003 - GetAccount (request for balance)

{@balance_inquiry}
; Message header
header = !@fin.message_header                 ; Group header

; Request identification
request_id = !:                               ; Request identifier

; Account to query
account = !@fin.account                       ; Account identifier
account_owner = @fin.party                    ; Account owner

; Query criteria
{.criteria}
balance_type = (clav, clbd, itav, itbd, opav, opbd)  ; Requested balance type
as_of_date = date                             ; Balance as of date
as_of_time = timestamp                        ; Balance as of time

{@balance_inquiry}

; ═══════════════════════════════════════════════════════════════════════════════
; TRANSACTION INQUIRY
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: camt.005 - GetTransaction

{@transaction_inquiry}
; Message header
header = !@fin.message_header                 ; Group header

; Request identification
request_id = !:                               ; Request identifier

; Account to query
account = !@fin.account                       ; Account identifier

; Search criteria
{.criteria}
from_date = date                              ; Start date
to_date = date                                ; End date
from_amount = @fin.amount                     ; Minimum amount
to_amount = @fin.amount                       ; Maximum amount
credit_debit = (crdt, dbit)                   ; Filter by direction
entry_reference = :                           ; Specific entry reference
end_to_end_id = :                             ; Specific E2E ID
status = (book, pdng)                         ; Entry status filter

{@transaction_inquiry}

; Pagination
{.pagination}
page_number = ##:(1..)                        ; Requested page
page_size = ##:(1..)                          ; Entries per page

{@transaction_inquiry}


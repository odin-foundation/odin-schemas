; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Finance Securities Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Securities settlement and management derived from ISO 20022 sese (Securities
; Settlement) and semt (Securities Management) message families.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as fin

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.finance.securities"
version = "1.0.0"
title = "Finance Securities Schema"
description = "Securities settlement and management derived from ISO 20022"

{$derivation}
source[0].authority = "ISO"
source[0].citation = "ISO 20022 sese.023 - Securities Settlement Transaction Instruction"
source[0].url = "https://www.iso20022.org/catalogue-messages/iso-20022-messages-archive?search=sese.023"

source[1].authority = "ISO"
source[1].citation = "ISO 20022 semt.002 - Securities Balance Custody Report"
source[1].url = "https://www.iso20022.org/catalogue-messages/iso-20022-messages-archive?search=semt.002"

source[2].authority = "ISO"
source[2].citation = "ISO 6166 ISIN Standard"
source[2].url = "https://www.iso.org/standard/78502.html"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial securities schema"
changelog[0].rationale = "Securities types derived from ISO 20022 sese/semt messages"

; ═══════════════════════════════════════════════════════════════════════════════
; SECURITY IDENTIFICATION
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: SecurityIdentification, FinancialInstrumentIdentification

{@security}
; Required - at least one identifier
isin = :format isin             ; ISO 6166 ISIN
cusip = :format cusip                      ; CUSIP (North America)
sedol = :/^[A-Z0-9]{7}$/                      ; SEDOL (UK/Ireland)
tickers[] = {@ticker_symbol}                  ; Tickers (multiple exchanges)
other_ids[] = :                               ; Proprietary identifiers (vendor IDs)

{@ticker_symbol}
ticker = :                                   ; Exchange ticker symbol
exchange = :                                  ; Exchange MIC code

; Security details
name = :                                      ; Security name/description
short_name = :                                ; Short name
cfi = :/^[A-Z]{6}$/                           ; ISO 10962 CFI code

; Classification
type = (bond, collective_investment, derivative, equity, fund, loan, option, structured, warrant)
sub_type = :                                  ; Security sub-type

; Issue details
{.issue}
issuer = @fin.party                           ; Issuer
issue_date = date                             ; Issue date
maturity_date = date                          ; Maturity date
currency = :(3)                               ; Denomination currency
country = :(2)                                ; Country of issue

{@security}

; Pricing
{.price}
value = #.6                                   ; Price value
type = (actu, deal, mrkt, midp)               ; Price type
currency = :(3)                               ; Price currency
quote_date = date                             ; Price date

{@security}

:one_of isin, cusip, sedol, ticker, other_id  ; At least one identifier

; ═══════════════════════════════════════════════════════════════════════════════
; SECURITIES ACCOUNT
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: SecuritiesAccount

{@securities_account}
id = :                                       ; Account identifier
name = :                                      ; Account name
type = (cash, mrgn, nomi, own, safe)          ; Account type
owners[] = @fin.party                         ; Account owners (joint/trust accounts)
servicer = @fin.financial_institution         ; Account servicer (custodian)

; ═══════════════════════════════════════════════════════════════════════════════
; SECURITY HOLDING
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: AggregateBalanceInformation, BalanceQuantity

{@holding}
security = @security                         ; Security held
account = @securities_account                ; Securities account

; Quantity and balance
{.balance}
total_quantity = #.6                         ; Total quantity held
available_quantity = #.6                      ; Available for settlement
blocked_quantity = #.6                        ; Blocked quantity
borrowed_quantity = #.6                       ; Borrowed securities
collateral_in_quantity = #.6                  ; Collateral received
collateral_out_quantity = #.6                 ; Collateral pledged
loaned_quantity = #.6                         ; Securities loaned out
pending_delivery_quantity = #.6               ; Pending delivery
pending_receipt_quantity = #.6                ; Pending receipt
registered_quantity = #.6                     ; Registered quantity

{@holding}

; Valuation
{.valuation}
book_value = @fin.amount                      ; Book value
market_value = @fin.amount                    ; Market value
unrealized_gain_loss = @fin.amount            ; Unrealized P&L
accrued_interest = @fin.amount                ; Accrued interest (bonds)
valuation_date = date                         ; Valuation date

{@holding}

; Place of safekeeping
safekeeping_place = @fin.financial_institution  ; Custodian/depository

; ═══════════════════════════════════════════════════════════════════════════════
; SETTLEMENT INSTRUCTION
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: sese.023 - SecuritiesSettlementTransactionInstruction

{@settlement_instruction}
; Message header
header = @fin.message_header                 ; Group header

; Instruction identification
instruction_id = :                           ; Instruction identifier
transaction_id = :                            ; Transaction identifier

; Security
security = @security                         ; Security to settle
quantity = #.6                               ; Settlement quantity

; Settlement details
settlement_type = (dvp, fop, rcv)            ; DVP, free of payment, receive
settlement_date = date                       ; Intended settlement date
settlement_amount = @fin.amount               ; Cash settlement amount

; Accounts
delivering_account = @securities_account      ; Delivering securities account
receiving_account = @securities_account       ; Receiving securities account
cash_account = @fin.account                   ; Cash settlement account

; Parties
{.parties}
delivering_party = @fin.party                 ; Delivering party
receiving_parties[] = @fin.party              ; Receiving parties (multiple recipients)
delivering_agent = @fin.financial_institution ; Delivering agent
receiving_agent = @fin.financial_institution  ; Receiving agent

{@settlement_instruction}

; Trade details
{.trade}
trade_date = date                             ; Trade date
deal_price = #.6                              ; Deal price
place_of_trade = :                            ; Trading venue (MIC code)
trade_transaction_type = (bsbo, bsec, buyi, cncb, coli, colo, conv, cros, divr, etft, fcta, insp, issu, mgrd, opts, plac, prea, repo, rpto, rvpo, sbbk, sbre, secl, sell, slbk, slre, swif, tbac, trca, trin, trpo, trvo)

{@settlement_instruction}

; Corporate action
{.corporate_action}
event_id = :                                  ; CA event identifier
event_type = :                                ; Event type

{@settlement_instruction}

; Matching
{.matching}
status = (mach, nmat, pmat)                   ; Matching status
matched_date = timestamp                      ; Date matched

{@settlement_instruction}

; ═══════════════════════════════════════════════════════════════════════════════
; SETTLEMENT STATUS
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: sese.024 - SecuritiesSettlementTransactionStatusAdvice

{@settlement_status}
; Message header
header = @fin.message_header                 ; Group header

; Original instruction reference
{.original}
instruction_id = :                           ; Original instruction ID
transaction_id = :                            ; Original transaction ID

{@settlement_status}

; Settlement status
status = (ackp, canc, cand, canp, defp, futu, pend, penf, pprc, sett)
reason_codes[] = :                            ; Status reason codes (multiple failure reasons)
additional_info = :                           ; Additional information
effective = timestamp                         ; Status effective date/time

; Status codes:
; ackp = Acknowledged/Accepted
; canc = Cancelled
; cand = Cancellation Denied
; canp = Cancellation Pending
; defp = Defaulted
; futu = Future
; pend = Pending
; penf = Pending Failing
; pprc = Partially Processed
; sett = Settled

; Unmatched reason (if status = nmat)
unmatched_reasons[] = :                       ; Why not matched (multiple simultaneous reasons)

; Failing reason (if status = penf)
failing_reasons[] = :                         ; Why failing (multiple concurrent reasons)

; Settled details (if status = sett)
{.settled}
settlement_date = date                        ; Actual settlement date
settled_quantity = #.6                        ; Quantity settled
settled_amount = @fin.amount                  ; Amount settled

{@settlement_status}

; ═══════════════════════════════════════════════════════════════════════════════
; PORTFOLIO STATEMENT
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: semt.002 - SecuritiesBalanceCustodyReport

{@portfolio_statement}
; Message header
header = @fin.message_header                 ; Group header

; Statement identification
statement_id = :                             ; Statement identifier
statement_date = date                        ; Statement date
frequency = (dail, mnth, week, year)          ; Statement frequency

; Account
account = @securities_account                ; Securities account
account_owners[] = @fin.party                 ; Account owners (joint/trust accounts)
custodian = @fin.financial_institution        ; Custodian

; Holdings
holdings[] = @holding                         ; Security holdings

; Summary
{.summary}
total_holdings = ##:(0..)                     ; Number of holdings
total_market_value = @fin.amount              ; Total portfolio value
total_book_value = @fin.amount                ; Total book value
cash_balances[] = @fin.amount                 ; Cash balances (multiple currencies)

{@portfolio_statement}

; ═══════════════════════════════════════════════════════════════════════════════
; CORPORATE ACTION NOTIFICATION
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: seev.031 - CorporateActionNotification

{@corporate_action}
; Event identification
event_id = :                                 ; Corporate action ID
event_type = (bonu, capd, capg, cash, conv, decr, deti, dlst, draw, drip, dvca, dvop, dvsc, dvse, exof, exri, exwa, incr, intr, liqu, lotd, mcal, mrgr, odlt, pcal, pdef, pink, plac, ppmt, pred, prii, prwi, redo, remk, rhdi, rhts, shpr, soff, splf, splr, subs, tend, xmet)

; Securities
securities[] = @security                     ; Affected securities (mergers affect multiple)

; Event dates
{.dates}
announcement = date                           ; Announcement date
record = date                                 ; Record date
ex = date                                     ; Ex-date
payment = date                                ; Payment date
deadline = date                               ; Instruction deadline
market_deadline = date                        ; Market deadline

{@corporate_action}

; Event details
{.details}
rate = #.6                                    ; Rate (for dividends, splits)
price = @fin.amount                           ; Price (for offers)
quantity = #.6                                ; Quantity (for bonus issues)
gross_amount = @fin.amount                    ; Gross dividend/distribution
net_amount = @fin.amount                      ; Net after tax
tax_amount = @fin.amount                      ; Tax withheld
currency = :(3)                               ; Currency

{@corporate_action}

; Options (for events with choices)
options[] = @ca_option                        ; Available options

{@ca_option}
option_number = ##:(1..)                     ; Option number
option_type = (cash, noac, secu)             ; Option type
default = ?                                   ; Default option
rate = #.6                                    ; Option rate
price = @fin.amount                           ; Option price
security = @security                          ; Security (if secu option)


; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Finance Foreign Exchange Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Foreign exchange trading derived from ISO 20022 fxtr (Foreign Exchange Trade)
; message family including trade instructions, confirmations, and notifications.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as fin

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.finance.fx"
version = "1.0.0"
title = "Finance Foreign Exchange Schema"
description = "Foreign exchange trading derived from ISO 20022"

{$derivation}
source[0].authority = "ISO"
source[0].citation = "ISO 20022 fxtr.014 - Foreign Exchange Trade Instruction"
source[0].url = "https://www.iso20022.org/catalogue-messages/iso-20022-messages-archive?search=fxtr"

source[1].authority = "ISO"
source[1].citation = "ISO 4217 Currency Codes"
source[1].url = "https://www.iso.org/iso-4217-currency-codes.html"

source[2].authority = "BIS"
source[2].citation = "Triennial Central Bank Survey - Foreign Exchange Turnover"
source[2].url = "https://www.bis.org/statistics/rpfx22.htm"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial FX schema"
changelog[0].rationale = "FX types derived from ISO 20022 fxtr messages"

; ═══════════════════════════════════════════════════════════════════════════════
; FX TRADE
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: ForeignExchangeTradeInstruction

{@trade}
; Message header
header = @fin.message_header                 ; Group header

; Trade identification
trade_id = :                                 ; Unique trade identifier
related_trade_id = :                          ; Related trade reference
common_trade_id = :                           ; Common reference (both parties)

; Trade type
trade_type = (fxfwd, fxndf, fxopt, fxspot, fxswap)
side = (buy, sell)                           ; Trade side

; Currencies and amounts
{.traded_currency}
currency = :(3)                              ; Traded currency (ISO 4217)
amount = #$                                  ; Amount in traded currency
direction = (rcvd, deli)                     ; Receive or deliver

{@trade}

{.counter_currency}
currency = :(3)                              ; Counter currency (ISO 4217)
amount = #$                                  ; Amount in counter currency
direction = (rcvd, deli)                     ; Receive or deliver

{@trade}

; Exchange rate
{.rate}
exchange_rate = #.8                          ; Agreed exchange rate
forward_points = #.6                          ; Forward points (for forwards)
spot_rate = #.8                               ; Underlying spot rate

{@trade}

; Dates
trade_date = date                            ; Trade date
value_date = date                            ; Settlement/value date
fixing_date = date                            ; Rate fixing date (NDF)

; Parties
trading_party = @fin.party                   ; Trading party
counterparty = @fin.party                    ; Counterparty

; Settlement
{.settlement}
traded_currency_account = @fin.account        ; Account for traded currency
counter_currency_account = @fin.account       ; Account for counter currency
settlement_type = (gros, nett, pvu)           ; Settlement method
netting_id = :                                ; Netting identifier

{@trade}

; NDF specific (Non-Deliverable Forward)
{.ndf}
fixing_source = :                             ; Fixing rate source
fixing_rate = #.8                             ; Fixed rate
settlement_currency = :(3)                    ; Settlement currency
settlement_amount = #$                        ; Net settlement amount

{@trade}

; ═══════════════════════════════════════════════════════════════════════════════
; FX SWAP
; ═══════════════════════════════════════════════════════════════════════════════
; Two-legged FX transaction (spot + forward or forward + forward)

{@swap}
; Message header
header = @fin.message_header                 ; Group header

; Swap identification
swap_id = :                                  ; Unique swap identifier

; Parties
trading_party = @fin.party                   ; Trading party
counterparty = @fin.party                    ; Counterparty

; Near leg
{.near_leg}
trade_id = :                                 ; Near leg trade ID
value_date = date                            ; Near leg value date
exchange_rate = #.8                          ; Near leg rate
traded_currency = :(3)                        ; Traded currency
traded_amount = #$                            ; Traded amount
counter_currency = :(3)                       ; Counter currency
counter_amount = #$                           ; Counter amount
direction = (buy, sell)                      ; Buy or sell traded currency

{@swap}

; Far leg
{.far_leg}
trade_id = :                                 ; Far leg trade ID
value_date = date                            ; Far leg value date
exchange_rate = #.8                          ; Far leg rate
traded_currency = :(3)                        ; Traded currency
traded_amount = #$                            ; Traded amount
counter_currency = :(3)                       ; Counter currency
counter_amount = #$                           ; Counter amount
direction = (buy, sell)                      ; Buy or sell traded currency
forward_points = #.6                          ; Forward points

{@swap}

; ═══════════════════════════════════════════════════════════════════════════════
; FX OPTION
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: ForeignExchangeOption

{@option}
; Message header
header = @fin.message_header                 ; Group header

; Option identification
option_id = :                                ; Unique option identifier

; Option type
option_type = (call, put)                    ; Call or put
option_style = (amer, euro)                  ; American or European
side = (buy, sell)                           ; Buy or sell option

; Underlying currencies
call_currency = :(3)                         ; Call currency
call_amount = #$                             ; Call amount
put_currency = :(3)                          ; Put currency
put_amount = #$                              ; Put amount

; Strike
strike_rate = #.8                            ; Strike exchange rate

; Premium
{.premium}
amount = #$                                  ; Premium amount
currency = :(3)                              ; Premium currency
payment_date = date                          ; Premium payment date
payer = (buyer, seller)                      ; Premium payer

{@option}

; Dates
trade_date = date                            ; Trade date
expiry_date = date                           ; Expiry date
expiry_time = time                            ; Expiry time
delivery_date = date                          ; Delivery date (if exercised)

; Exercise
{.exercise}
automatic = ?                                 ; Automatic exercise
cut_off_time = time                           ; Exercise cut-off time
settlement_type = (cash, physical)            ; Settlement method

{@option}

; Parties
buyer = @fin.party                           ; Option buyer
seller = @fin.party                          ; Option seller (writer)

; ═══════════════════════════════════════════════════════════════════════════════
; FX ORDER
; ═══════════════════════════════════════════════════════════════════════════════
; Order to execute FX trade at specified conditions

{@order}
; Message header
header = @fin.message_header                 ; Group header

; Order identification
order_id = :                                 ; Unique order identifier

; Order type
order_type = (limit, market, stop, stop_limit)
side = (buy, sell)                           ; Buy or sell traded currency
time_in_force = (day, fok, gtc, gtd, ioc)     ; Time in force

; Currencies and amounts
traded_currency = :(3)                       ; Currency to buy/sell
traded_amount = #$                           ; Amount
counter_currency = :(3)                      ; Counter currency

; Price
limit_rate = #.8                              ; Limit rate (if limit order)
stop_rate = #.8                               ; Stop rate (if stop order)

; Dates
order_date = date                            ; Order date
expiry_date = date                            ; Order expiry date
value_date = date                             ; Desired value date

; Parties
ordering_party = @fin.party                  ; Party placing order
executing_party = @fin.party                  ; Executing counterparty

; Execution instructions
{.instructions}
all_or_none = ?                               ; Execute all or nothing
partial_fill_allowed = ?                      ; Allow partial fills
minimum_quantity = #$                         ; Minimum fill quantity

{@order}

; ═══════════════════════════════════════════════════════════════════════════════
; FX TRADE STATUS
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: ForeignExchangeTradeStatusAndDetails

{@trade_status}
; Message header
header = @fin.message_header                 ; Group header

; Trade reference
trade_id = :                                 ; Trade identifier

; Status
status = (aloc, canc, conf, done, matd, pcom, pend, rejc, rjct, sett, trmd, vald)
status_reason = :                             ; Status reason code
status_date = timestamp                      ; Status effective time

; Status codes:
; aloc = Allocated
; canc = Cancelled
; conf = Confirmed
; done = Done (executed)
; matd = Matured
; pcom = Pre-Confirmed
; pend = Pending
; rejc = Rejected
; rjct = Rejected (alternate code)
; sett = Settled
; trmd = Terminated
; vald = Validated

; Settlement status
{.settlement_status}
traded_currency_settled = ?                   ; Traded currency settled
counter_currency_settled = ?                  ; Counter currency settled
settlement_date = date                        ; Actual settlement date

{@trade_status}


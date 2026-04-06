; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Finance Derivatives Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Derivatives trading and regulatory reporting derived from ISO 20022 auth
; (Authorities) and derv (Derivatives) message families.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as fin

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.finance.derivatives"
version = "1.0.0"
title = "Finance Derivatives Schema"
description = "Derivatives trading and reporting derived from ISO 20022"

{$derivation}
source[0].authority = "ISO"
source[0].citation = "ISO 20022 auth.030 - Derivative Trade Report"
source[0].url = "https://www.iso20022.org/catalogue-messages/iso-20022-messages-archive?search=auth.030"

source[1].authority = "ISDA"
source[1].citation = "ISDA Common Domain Model (CDM) - Open Source"
source[1].url = "https://www.isda.org/2019/10/14/isda-common-domain-model/"

source[2].authority = "BIS"
source[2].citation = "OTC Derivatives Statistics"
source[2].url = "https://www.bis.org/statistics/derstats.htm"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial derivatives schema"
changelog[0].rationale = "Derivatives types derived from ISO 20022 and public sources"

; ═══════════════════════════════════════════════════════════════════════════════
; DERIVATIVE PRODUCT
; ═══════════════════════════════════════════════════════════════════════════════
; Product identification and classification

{@product}
; Product identification
product_id = !:                               ; Unique product identifier
isin = :format isin             ; ISIN if available
uti = :                                       ; Unique Transaction Identifier
usi = :                                       ; Unique Swap Identifier

; Classification
asset_class = !(commodity, credit, equity, foreign_exchange, interest_rate)
product_type = !(forward, futures, option, swap, swaption)
sub_type = :                                  ; Product sub-type

; Underlying
{.underlying}
type = (bond, commodity, credit, currency, equity, index, rate)
identifier = :                                ; Underlying identifier
name = :                                      ; Underlying name
currency = :(3)                               ; Underlying currency

{@product}

; ═══════════════════════════════════════════════════════════════════════════════
; DERIVATIVE TRADE
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: DerivativeTradeReport

{@trade}
; Trade identification
trade_id = !:                                 ; Unique trade identifier
uti = :                                       ; Unique Transaction Identifier
prior_uti = :                                 ; Prior UTI (for amendments)
report_id = :                                 ; Reporting identifier

; Product
product = !@product                           ; Derivative product

; Parties
{.parties}
party1 = !@fin.party                          ; First party
party1_side = !(buyer, payer, receiver, seller)
party2 = !@fin.party                          ; Second party
party2_side = !(buyer, payer, receiver, seller)
broker = @fin.party                           ; Broker (if any)
clearing_member = @fin.party                  ; Clearing member

{@trade}

; Dates
trade_date = !date                            ; Trade execution date
effective_date = !date                        ; Effective date
termination_date = date                       ; Termination/maturity date
settlement_date = date                        ; Settlement date

; Notional
{.notional}
amount = !#$                                  ; Notional amount
currency = !:(3)                              ; Notional currency
amount_2 = #$                                 ; Second notional (cross-currency)
currency_2 = :(3)                             ; Second currency

{@trade}

; Price/Rate
{.pricing}
price = #.8                                   ; Price
rate = #.8                                    ; Rate
spread = #.6                                  ; Spread
strike = #.8                                  ; Strike price/rate

{@trade}

; Clearing
{.clearing}
cleared = ?                                   ; Centrally cleared
ccp = @fin.financial_institution              ; Central counterparty
clearing_date = date                          ; Clearing date
clearing_status = (clrd, pend, rejd, unclrd)  ; Clearing status

{@trade}

; Collateral
{.collateral}
collateralized = ?                            ; Trade is collateralized
collateral_type = (cash, mixed, securities)   ; Collateral type
initial_margin = @fin.amount                  ; Initial margin
variation_margin = @fin.amount                ; Variation margin

{@trade}

; Execution venue
{.execution}
venue = :                                     ; Execution venue (MIC)
venue_type = (otc, sef, regulated_market)     ; Venue type
confirmation_method = (electronic, manual)    ; Confirmation method

{@trade}

; ═══════════════════════════════════════════════════════════════════════════════
; INTEREST RATE SWAP
; ═══════════════════════════════════════════════════════════════════════════════
; IRS-specific fields

{@interest_rate_swap}
= @trade                                      ; Inherit trade fields

; Swap type
swap_type = !(basis, fixed_float, fixed_fixed, float_float, ois, xccy)

; Fixed leg
{.fixed_leg}
rate = !#.6                                   ; Fixed rate
day_count = !(30_360, act_360, act_365, act_act)  ; Day count convention
payment_frequency = !(annual, monthly, quarterly, semi_annual)
notional = !#$                                ; Leg notional
currency = !:(3)                              ; Leg currency
payer = !(party1, party2)                     ; Payer of fixed leg

{@interest_rate_swap}

; Floating leg
{.floating_leg}
index = !:                                    ; Reference rate index (e.g., SOFR)
index_tenor = :                               ; Index tenor (e.g., 3M)
spread = #.6                                  ; Spread over index
day_count = !(30_360, act_360, act_365, act_act)
payment_frequency = !(annual, monthly, quarterly, semi_annual)
reset_frequency = !(daily, monthly, quarterly, semi_annual)
notional = !#$                                ; Leg notional
currency = !:(3)                              ; Leg currency
payer = !(party1, party2)                     ; Payer of floating leg

{@interest_rate_swap}

; ═══════════════════════════════════════════════════════════════════════════════
; CREDIT DEFAULT SWAP
; ═══════════════════════════════════════════════════════════════════════════════
; CDS-specific fields

{@credit_default_swap}
= @trade                                      ; Inherit trade fields

; CDS type
cds_type = !(index, single_name, tranche)

; Reference entity/obligation
{.reference}
entity = !@fin.party                          ; Reference entity
entity_type = (corporate, sovereign)          ; Entity type
seniority = (senior, subordinated)            ; Debt seniority
restructuring = (cr, mm, mr, xr)              ; Restructuring type

{@credit_default_swap}

; Premium leg
{.premium_leg}
spread = !#.6                                 ; CDS spread (bps)
payment_frequency = !(annual, monthly, quarterly, semi_annual)
day_count = !(30_360, act_360)                ; Day count convention
upfront_amount = #$                           ; Upfront payment

{@credit_default_swap}

; Protection leg
{.protection_leg}
notional = !#$                                ; Protected notional
currency = !:(3)                              ; Notional currency
recovery_rate = #:(0..100)                    ; Assumed recovery rate

{@credit_default_swap}

; Index specific (if cds_type = index)
{.index}
name = :                                      ; Index name (e.g., CDX.NA.IG)
series = ##                                   ; Index series
version = ##                                  ; Index version
factor = #.6                                  ; Index factor

{@credit_default_swap}

; ═══════════════════════════════════════════════════════════════════════════════
; EQUITY DERIVATIVE
; ═══════════════════════════════════════════════════════════════════════════════
; Equity options, swaps, forwards

{@equity_derivative}
= @trade                                      ; Inherit trade fields

; Equity type
equity_type = !(forward, option, swap, variance_swap, volatility_swap)

; Underlying
{.equity_underlying}
type = !(basket, etf, index, single_stock)
identifier = !:                               ; Ticker/ISIN
name = :                                      ; Name
exchange = :                                  ; Exchange (MIC)
quantity = #.6                                ; Number of shares/units
initial_price = #.6                           ; Initial price

{@equity_derivative}

; Option terms (if equity_type = option)
{.option}
option_type = !(call, put)                    ; Call or put
option_style = !(american, bermudan, european)
strike = !#.6                                 ; Strike price
expiry = !date                                ; Expiry date
settlement = (cash, physical)                 ; Settlement type

{@equity_derivative}

; Premium (for options)
{.premium}
amount = #$                                   ; Premium amount
currency = :(3)                               ; Premium currency
payment_date = date                           ; Premium payment date

{@equity_derivative}

; ═══════════════════════════════════════════════════════════════════════════════
; COMMODITY DERIVATIVE
; ═══════════════════════════════════════════════════════════════════════════════
; Commodity futures, options, swaps

{@commodity_derivative}
= @trade                                      ; Inherit trade fields

; Commodity type
commodity_type = !(forward, futures, option, swap)

; Commodity underlying
{.commodity}
type = !(agricultural, energy, industrial_metals, precious_metals)
sub_type = :                                  ; Specific commodity
grade = :                                     ; Grade/quality
delivery_location = :                         ; Delivery point

{@commodity_derivative}

; Quantity
{.quantity}
amount = !#.6                                 ; Quantity
unit = !:                                     ; Unit of measure (barrel, bushel, oz, etc.)

{@commodity_derivative}

; Pricing
{.commodity_pricing}
price = #.6                                   ; Fixed price
price_unit = :                                ; Price per unit
floating_index = :                            ; Floating price index
floating_spread = #.6                         ; Spread to index

{@commodity_derivative}

; ═══════════════════════════════════════════════════════════════════════════════
; VALUATION
; ═══════════════════════════════════════════════════════════════════════════════
; Mark-to-market valuation

{@valuation}
; Reference
trade_id = !:                                 ; Trade being valued
valuation_id = :                              ; Valuation identifier

; Valuation
{.mark_to_market}
value = !#$                                   ; MTM value
currency = !:(3)                              ; Valuation currency
date = !date                                  ; Valuation date
time = timestamp                              ; Valuation timestamp
method = (dcf, market, model)                 ; Valuation method

{@valuation}

; Greeks (for options)
{.greeks}
delta = #.6                                   ; Delta
gamma = #.6                                   ; Gamma
vega = #.6                                    ; Vega
theta = #.6                                   ; Theta
rho = #.6                                     ; Rho

{@valuation}

; Sensitivities
{.sensitivities}
dv01 = #$                                     ; Dollar value of 1bp
cs01 = #$                                     ; Credit spread 1bp
pv01 = #$                                     ; Present value 1bp

{@valuation}

; ═══════════════════════════════════════════════════════════════════════════════
; REGULATORY REPORT
; ═══════════════════════════════════════════════════════════════════════════════
; Derivative trade reporting (EMIR, Dodd-Frank, etc.)

{@regulatory_report}
; Report identification
report_id = !:                                ; Report identifier
report_type = !(amendment, error, new, termination, valuation)
action_type = !(correct, modi, new, term)     ; Action type

; Trade reference
trade = !@trade                               ; Trade being reported
uti = !:                                      ; Unique Transaction Identifier

; Reporting entity
{.reporter}
entity = !@fin.party                          ; Reporting entity
entity_type = !(dealer, non_dealer)           ; Entity type
reporting_side = !(both, report_submitting)   ; Reporting obligation

{@regulatory_report}

; Counterparty
{.counterparty}
entity = !@fin.party                          ; Counterparty
entity_type = :(2)                            ; Entity type code
country = :(2)                                ; Counterparty country

{@regulatory_report}

; Regime
{.regime}
jurisdiction = !(cftc, emir, hkma, jfsa, mas) ; Regulatory regime
repository = :                                ; Trade repository
submission_date = timestamp                   ; Submission timestamp
acceptance_date = timestamp                   ; Acceptance timestamp
status = (accepted, pending, rejected)        ; Report status

{@regulatory_report}


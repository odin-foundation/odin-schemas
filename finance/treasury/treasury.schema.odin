; ===================================================================================
; ODIN Finance Treasury Schema
; ===================================================================================
; Treasury management covering cash positioning, netting, forecasting,
; investments, and bank account management. Supports ISO 20022, SWIFT,
; BAI2, and Basel III liquidity requirements.
; ===================================================================================

@import "../types.schema.odin" as fin

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.finance.treasury"
version = "1.0.0"
title = "Finance Treasury Schema"
description = "Comprehensive treasury management schema for cash, netting, forecasting, investments, and bank accounts"

{$derivation}
source[0].authority = "ISO"
source[0].citation = "ISO 20022 camt - Cash Management Messages"
source[0].url = "https://www.iso20022.org/catalogue-messages/iso-20022-messages-archive?search=camt"

source[1].authority = "SWIFT"
source[1].citation = "MT9XX Series - Balance and Transaction Reports"
source[1].url = "https://en.wikipedia.org/wiki/SWIFT_message_types"

source[2].authority = "Bank Administration Institute"
source[2].citation = "BAI2 Cash Management Balance Reporting"
source[2].url = "https://www.bai.org/docs/default-source/libraries/site-general-downloads/cash_management_2005.pdf"

source[3].authority = "Basel Committee on Banking Supervision"
source[3].citation = "Basel III: Liquidity Coverage Ratio and Liquidity Risk Monitoring Tools"
source[3].url = "https://www.bis.org/publ/bcbs238.htm"

source[4].authority = "Association for Financial Professionals"
source[4].citation = "AFP Guide to Treasury Management"
source[4].url = "https://www.afponline.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Derived from ISO 20022 camt, SWIFT MT standards, BAI2, and Basel III liquidity requirements"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial treasury schema"
changelog[0].rationale = "Comprehensive treasury management for cash, netting, forecasting, and investments"

; ===================================================================================
; LEGAL ENTITY
; ===================================================================================
; Corporate entity for treasury management.

{@legal_entity}
; Required fields first
entity_id = :                                  ; Entity identifier
entity_type = (
    branch,                                     ; Branch office
    holding,                                    ; Holding company
    in_house_bank,                              ; In-house bank
    joint_venture,                              ; JV entity
    operating,                                  ; Operating company
    regional_treasury,                          ; Regional treasury center
    spe,                                        ; Special purpose entity
    subsidiary                                  ; Subsidiary
)
name = :                                       ; Entity legal name
parent_entity = :                               ; Parent entity ID
country = :(2)                                 ; Country of incorporation

; Identification
lei = :format lei                         ; Legal Entity Identifier
tax_ids[] = *:                                  ; Tax IDs (multi-jurisdiction)
registration_numbers[] = :                      ; Registration numbers (multi-jurisdiction)

; Treasury role
{.treasury}
treasury_center = ?                             ; Is treasury center
netting_center = ?                              ; Participates in netting
in_house_bank = ?                               ; In-house bank participant
payment_factory = ?                             ; Payment factory participant
regional_hub = ?                                ; Regional treasury hub
base_currency = :(3)                            ; Functional currency

{@legal_entity}

; ===================================================================================
; BANK ACCOUNT
; ===================================================================================
; Corporate bank account master data.

{@bank_account}
; Required fields first
account_id = :                                 ; Internal account ID
account_number = *:                             ; Bank account number
currency = :(3)                                ; Account currency
bank = @fin.financial_institution              ; Account bank

; Account identification
iban = :format iban         ; IBAN (if applicable)
bban = :                                        ; Local account format
sort_code = :                                   ; UK sort code
routing_number = :format routing                     ; US ABA routing
swift_bic = :format bic

; Account holder
entity = @legal_entity                         ; Account owner entity
signatories[] = :                               ; Authorized signatories

; Account type
account_type = (
    checking,                                   ; Operating/checking
    concentration,                              ; Concentration account
    controlled_disbursement,                    ; CD account
    deposit,                                    ; Term deposit
    escrow,                                     ; Escrow account
    funding,                                    ; Funding account
    header,                                     ; Pool header
    investment,                                 ; Investment account
    lockbox,                                    ; Lockbox account
    money_market,                               ; MMA
    notional,                                   ; Notional pool account
    payroll,                                    ; Payroll account
    savings,                                    ; Savings account
    sweep,                                      ; Sweep account
    target,                                     ; ZBA target
    zero_balance                                ; ZBA account
)

; Status
status = (
    active,
    blocked,
    closed,
    dormant,
    pending_approval,
    pending_closure
)
opened_date = date                              ; Account open date
closed_date = date                              ; Account close date

; ---------------------------------------------------------------------------
; Account Structure
; ---------------------------------------------------------------------------
{.structure}
structure_type = (
    notional_pool,                              ; Notional pooling
    physical_pool,                              ; Physical pooling
    standalone,                                 ; Standalone account
    zba                                         ; Zero balance
)
parent_account = :                              ; Parent account ID
header_account = :                              ; Pool header ID
sweep_to = :                                    ; Sweep destination
sweep_frequency = (daily, end_of_day, intraday)
target_balance = #$                             ; Target balance (ZBA)

{@bank_account}

; ---------------------------------------------------------------------------
; Banking Relationship
; ---------------------------------------------------------------------------
{.relationship}
relationship_manager = :                        ; Bank RM name
rm_email = *@email                              ; RM email
rm_phone = *@phone                              ; RM phone
region = :                                      ; Bank region
branch = :                                      ; Bank branch

{@bank_account}

; ---------------------------------------------------------------------------
; Limits and Controls
; ---------------------------------------------------------------------------
{.limits}
overdraft_limit = #$:(0..)                      ; Overdraft facility
credit_line = #$:(0..)                          ; Credit line
daily_payment_limit = #$:(0..)                  ; Daily payment limit
single_payment_limit = #$:(0..)                 ; Single payment limit
minimum_balance = #$:(0..)                      ; Minimum balance required
compensating_balance = #$:(0..)                 ; Compensating balance

{@bank_account}

; ---------------------------------------------------------------------------
; Services
; ---------------------------------------------------------------------------
{.services}
online_banking = ?                              ; Online banking enabled
host_to_host = ?                                ; H2H connectivity
swift_enabled = ?                               ; SWIFT connected
positive_pay = ?                                ; Positive pay
ach_origination = ?                             ; ACH origination
wire_origination = ?                            ; Wire origination
lockbox = ?                                     ; Lockbox service
controlled_disbursement = ?                     ; CD reporting
balance_reporting = ?                           ; Balance reporting
image_services = ?                              ; Check imaging

{@bank_account}

; ---------------------------------------------------------------------------
; Connectivity
; ---------------------------------------------------------------------------
{.connectivity}
connection_type = (
    api,                                        ; API/RESTful
    ebics,                                      ; EBICS
    file_transfer,                              ; SFTP/File
    host_to_host,                               ; H2H
    online_portal,                              ; Portal access
    swift                                       ; SWIFT
)
format_balance = (bai2, camt052, camt053, mt940, mt942)
format_payment = (iso20022, mt101, nacha, proprietary)
file_encryption = (gpg, none, pgp)
cutoff_time = time                              ; Payment cutoff

{@bank_account}

; ===================================================================================
; CASH POSITION
; ===================================================================================
; Real-time and end-of-day cash position.

{@cash_position}
; Required fields first
position_id = :                                ; Position identifier
position_date = date                           ; Position date
position_type = (
    closing,                                    ; End of day closing
    current,                                    ; Current/real-time
    opening,                                    ; Opening balance
    projected                                   ; Projected/forecasted
)
entities[] = @legal_entity                     ; Entities (consolidated position)
currency = :(3)                                ; Position currency

; Position amounts
{.balances}
ledger_balance = #$                             ; Ledger/book balance
available_balance = #$                          ; Available balance
collected_balance = #$                          ; Collected balance
value_dated_balance = #$                        ; Value-dated balance
float = #$                                      ; Float amount
pending_credits = #$:(0..)                      ; Pending credits
pending_debits = #$:(0..)                       ; Pending debits

{@cash_position}

; Aggregation
{.aggregation}
consolidated = ?                                ; Consolidated position
includes_entities[] = :                         ; Included entity IDs
includes_accounts[] = :                         ; Included account IDs
in_base_currency = ?                            ; Converted to base currency
fx_rate_date = date                             ; FX rate date

{@cash_position}

; Account-level positions
account_positions[] = @account_position         ; Per-account breakdown

{@account_position}
account = @bank_account                        ; Bank account
ledger_balance = #$                             ; Ledger balance
available_balance = #$                          ; Available balance
collected_balance = #$                          ; Collected balance
overdraft_used = #$:(0..)                       ; Overdraft utilization
credit_line_available = #$:(0..)                ; Available credit

; Value-dated breakdown
{.value_dated}
same_day = #$                                   ; Value today
next_day = #$                                   ; Value T+1
two_day = #$                                    ; Value T+2
beyond = #$                                     ; Value T+3+

{@account_position}

; ===================================================================================
; INTRADAY POSITION
; ===================================================================================
; Real-time intraday cash position tracking.

{@intraday_position}
; Required fields first
position_id = :                                ; Position identifier
timestamp = timestamp                          ; Position timestamp
account = @bank_account                        ; Bank account

; Balances
opening_available = #$                          ; Opening available
current_available = #$                          ; Current available
expected_closing = #$                           ; Expected closing

; Intraday activity
{.activity}
credits_count = ##:(0..)                        ; Credit count
credits_amount = #$:(0..)                       ; Credit total
debits_count = ##:(0..)                         ; Debit count
debits_amount = #$:(0..)                        ; Debit total
pending_credits = #$:(0..)                      ; Pending credits
pending_debits = #$:(0..)                       ; Pending debits

{@intraday_position}

; High/low tracking
{.high_low}
intraday_high = #$                              ; Intraday high balance
high_time = timestamp                           ; Time of high
intraday_low = #$                               ; Intraday low balance
low_time = timestamp                            ; Time of low

{@intraday_position}

; ===================================================================================
; NETTING CENTER
; ===================================================================================
; Intercompany netting center for payment optimization.

{@netting_center}
; Required fields first
center_id = :                                  ; Netting center ID
center_type = (
    bilateral,                                  ; Bilateral netting
    multilateral,                               ; Multilateral netting
    regional                                    ; Regional hub
)
name = :                                       ; Center name
base_currency = :(3)                           ; Netting currency

; Operating entity
operating_entity = @legal_entity               ; Operating entity
participants[] = @netting_participant           ; Participating entities

; Netting cycle
{.cycle}
frequency = (daily, monthly, weekly)           ; Netting frequency
cutoff_day = ##:(1..31)                         ; Cutoff day (monthly)
cutoff_weekday = (friday, monday, wednesday)    ; Cutoff weekday
cutoff_time = time                              ; Cutoff time
settlement_lag = ##:(0..5)                      ; Settlement delay (days)
next_cycle_date = date                          ; Next netting date

{@netting_center}

; Settlement
{.settlement}
settlement_bank = @fin.financial_institution    ; Settlement bank
settlement_account = @bank_account              ; Settlement account
payment_method = (
    book_transfer,                              ; Internal transfer
    in_house_bank,                              ; Via IHB
    swift,                                      ; SWIFT payment
    wire                                        ; Wire transfer
)

{@netting_center}

{@netting_participant}
entity = @legal_entity                         ; Participating entity
status = (active, inactive, pending)            ; Participation status
currencies[] = :(3)                             ; Eligible currencies
settlement_account = @bank_account              ; Entity settlement account
credit_limit = #$:(0..)                         ; Credit limit
debit_limit = #$:(0..)                          ; Debit limit

; ===================================================================================
; NETTING CYCLE
; ===================================================================================
; Individual netting cycle/run.

{@netting_cycle}
; Required fields first
cycle_id = :                                   ; Cycle identifier
center_id = :                                  ; Netting center reference
cycle_date = date                              ; Netting cycle date
status = (
    cancelled,
    completed,
    pending,
    processing,
    settled
)

; Cycle totals
{.totals}
gross_payables = #$:(0..)                       ; Gross payables
gross_receivables = #$:(0..)                    ; Gross receivables
net_settlements = #$:(0..)                      ; Net settlement total
transaction_count = ##:(0..)                    ; Transaction count
participant_count = ##:(0..)                    ; Participant count
netting_efficiency = #:(0..100)                 ; Efficiency %

{@netting_cycle}

; Transactions included
transactions[] = @netting_transaction           ; Netted transactions
settlements[] = @netting_settlement             ; Net settlements

{@netting_transaction}
transaction_id = :                             ; Transaction ID
payer = @legal_entity                          ; Paying entity
payee = @legal_entity                          ; Receiving entity
amount = #$:(0..)                              ; Transaction amount
currency = :(3)                                ; Currency
original_due_date = date                        ; Original due date
invoice_references[] = :                        ; Invoice references (consolidated invoices)

{@netting_settlement}
settlement_id = :                              ; Settlement ID
entity = @legal_entity                         ; Settling entity
net_amount = #$                                ; Net amount (+/-)
direction = (pay, receive)                     ; Pay or receive
settlement_date = date                          ; Settlement date
status = (failed, pending, settled)             ; Settlement status
payment_reference = :                           ; Payment reference

; ===================================================================================
; CASH FORECAST
; ===================================================================================
; Cash flow forecasting and liquidity planning.

{@cash_forecast}
; Required fields first
forecast_id = :                                ; Forecast identifier
forecast_date = date                           ; Forecast as-of date
forecast_type = (
    budget,                                     ; Budget forecast
    operational,                                ; Operational forecast
    rolling,                                    ; Rolling forecast
    strategic                                   ; Strategic/long-term
)
entities[] = @legal_entity                     ; Forecasting entities (consolidated forecast)
currency = :(3)                                ; Forecast currency

; Forecast horizon
{.horizon}
start_date = date                              ; Forecast start
end_date = date                                ; Forecast end
granularity = (daily, monthly, weekly)         ; Forecast granularity
periods = ##:(1..)                              ; Number of periods

{@cash_forecast}

; Forecast summary
{.summary}
opening_balance = #$                            ; Opening cash
total_inflows = #$:(0..)                        ; Total inflows
total_outflows = #$:(0..)                       ; Total outflows
net_cash_flow = #$                              ; Net change
closing_balance = #$                            ; Closing cash
minimum_balance = #$                            ; Minimum during period
maximum_balance = #$                            ; Maximum during period

{@cash_forecast}

; Period forecasts
periods[] = @forecast_period                    ; Period breakdown

{@forecast_period}
period_start = date                            ; Period start
period_end = date                              ; Period end
opening_balance = #$                            ; Opening balance
inflows = #$:(0..)                              ; Period inflows
outflows = #$:(0..)                             ; Period outflows
net_flow = #$                                   ; Net flow
closing_balance = #$                            ; Closing balance
confidence = (high, low, medium)                ; Forecast confidence

; ---------------------------------------------------------------------------
; Inflow Categories
; ---------------------------------------------------------------------------
{.inflows}
accounts_receivable = #$:(0..)                  ; A/R collections
intercompany = #$:(0..)                         ; Intercompany receipts
financing = #$:(0..)                            ; Financing inflows
asset_sales = #$:(0..)                          ; Asset sale proceeds
other_operating = #$:(0..)                      ; Other operating
investment_income = #$:(0..)                    ; Investment income
fx_settlements = #$:(0..)                       ; FX settlements

{@forecast_period}

; ---------------------------------------------------------------------------
; Outflow Categories
; ---------------------------------------------------------------------------
{.outflows}
accounts_payable = #$:(0..)                     ; A/P payments
payroll = #$:(0..)                              ; Payroll
taxes = #$:(0..)                                ; Tax payments
debt_service = #$:(0..)                         ; Debt service
capex = #$:(0..)                                ; Capital expenditure
dividends = #$:(0..)                            ; Dividend payments
intercompany = #$:(0..)                         ; Intercompany payments
other_operating = #$:(0..)                      ; Other operating

{@forecast_period}

; ===================================================================================
; FORECAST VARIANCE
; ===================================================================================
; Actual vs forecast variance analysis.

{@forecast_variance}
; Required fields first
variance_id = :                                ; Variance ID
forecast_id = :                                ; Forecast reference
period_start = date                            ; Period start
period_end = date                              ; Period end

; Variance totals
{.variance}
forecast_inflows = #$:(0..)                     ; Forecasted inflows
actual_inflows = #$:(0..)                       ; Actual inflows
inflow_variance = #$                            ; Variance
inflow_variance_pct = #                         ; Variance %
forecast_outflows = #$:(0..)                    ; Forecasted outflows
actual_outflows = #$:(0..)                      ; Actual outflows
outflow_variance = #$                           ; Variance
outflow_variance_pct = #                        ; Variance %
forecast_net = #$                               ; Forecasted net
actual_net = #$                                 ; Actual net
net_variance = #$                               ; Net variance

{@forecast_variance}

; Variance analysis
{.analysis}
significant_variances[] = :                     ; Significant items
explanation = :                                 ; Variance explanation
action_items[] = :                              ; Follow-up actions

{@forecast_variance}

; ===================================================================================
; INVESTMENT
; ===================================================================================
; Short-term investment/money market instruments.

{@investment}
; Required fields first
investment_id = :                              ; Investment identifier
instrument_type = (
    agency,                                     ; Agency securities
    cd,                                         ; Certificate of deposit
    commercial_paper,                           ; Commercial paper
    government,                                 ; Government securities
    mmf,                                        ; Money market fund
    repo,                                       ; Repurchase agreement
    reverse_repo,                               ; Reverse repo
    tbill,                                      ; Treasury bill
    time_deposit                                ; Time deposit
)
entity = @legal_entity                         ; Investing entity
counterparty = @fin.financial_institution      ; Counterparty/issuer

; Investment details
face_value = #$:(0..)                          ; Face/principal value
currency = :(3)                                ; Currency
purchase_date = date                           ; Purchase/trade date
settlement_date = date                         ; Settlement date
maturity_date = date                           ; Maturity date

; Status
status = (
    active,                                     ; Currently held
    matured,                                    ; Matured
    pending,                                    ; Pending settlement
    redeemed,                                   ; Early redemption
    sold                                        ; Sold before maturity
)

; ---------------------------------------------------------------------------
; Yield/Return
; ---------------------------------------------------------------------------
{.yield}
purchase_price = #$:(0..)                       ; Purchase price
discount = #$:(0..)                             ; Discount amount
yield = #.4                                     ; Yield (annualized)
rate_type = (discount, interest)                ; Rate basis
day_count = (30_360, act_360, act_365, act_act)
interest_rate = #.4                             ; Coupon/interest rate
accrued_interest = #$:(0..)                     ; Accrued interest

{@investment}

; ---------------------------------------------------------------------------
; Valuation
; ---------------------------------------------------------------------------
{.valuation}
book_value = #$:(0..)                           ; Book value
market_value = #$:(0..)                         ; Market value
valuation_date = date                           ; Valuation date
unrealized_gain_loss = #$                       ; Unrealized P&L

{@investment}

; ---------------------------------------------------------------------------
; MMF Specific
; ---------------------------------------------------------------------------
{.mmf}
fund_name = ::if instrument_type = mmf          ; Fund name
fund_ticker = ::if instrument_type = mmf        ; Fund ticker
nav = #.4:if instrument_type = mmf              ; Net asset value
shares = #.4:if instrument_type = mmf           ; Shares held
seven_day_yield = #.4:if instrument_type = mmf  ; 7-day yield
fund_rating = ::if instrument_type = mmf        ; Fund rating

{@investment}

; ---------------------------------------------------------------------------
; CD/Time Deposit Specific
; ---------------------------------------------------------------------------
{.time_deposit}
deposit_rate = #.4:if instrument_type = cd      ; Deposit rate
compounding = (daily, monthly, quarterly):if instrument_type = cd
interest_payment = (at_maturity, monthly, quarterly):if instrument_type = cd
early_withdrawal_penalty = #$:(0..):if instrument_type = cd
fdic_insured = ?:if instrument_type = cd        ; FDIC coverage

{@investment}

; ---------------------------------------------------------------------------
; Repo Specific
; ---------------------------------------------------------------------------
{.repo}
repo_rate = #.4:if instrument_type = repo       ; Repo rate
collateral_type = ::if instrument_type = repo   ; Collateral description
collateral_value = #$:(0..):if instrument_type = repo
haircut = #:(0..50):if instrument_type = repo   ; Haircut %
triparty = ?:if instrument_type = repo          ; Triparty repo
triparty_agent = @fin.financial_institution:if instrument_type = repo

{@investment}

; ===================================================================================
; INVESTMENT PORTFOLIO
; ===================================================================================
; Aggregate investment portfolio view.

{@investment_portfolio}
; Required fields first
portfolio_id = :                               ; Portfolio identifier
portfolio_date = date                          ; Portfolio date
entity = @legal_entity                         ; Owning entity
currency = :(3)                                ; Reporting currency

; Portfolio totals
{.totals}
total_investments = #$:(0..)                    ; Total invested
total_market_value = #$:(0..)                   ; Total market value
weighted_avg_yield = #.4                        ; Weighted average yield
weighted_avg_maturity_days = ##                 ; WAM (days)

{@investment_portfolio}

; By instrument type
{.by_type}
mmf = #$:(0..)                                  ; Money market funds
tbills = #$:(0..)                               ; T-bills
commercial_paper = #$:(0..)                     ; Commercial paper
cds = #$:(0..)                                  ; CDs
repos = #$:(0..)                                ; Repos
other = #$:(0..)                                ; Other

{@investment_portfolio}

; By maturity bucket
{.by_maturity}
overnight = #$:(0..)                            ; Overnight
days_2_7 = #$:(0..)                             ; 2-7 days
days_8_30 = #$:(0..)                            ; 8-30 days
days_31_90 = #$:(0..)                           ; 31-90 days
days_91_180 = #$:(0..)                          ; 91-180 days
days_181_365 = #$:(0..)                         ; 181-365 days
beyond_365 = #$:(0..)                           ; Beyond 1 year

{@investment_portfolio}

; Holdings
holdings[] = @investment                        ; Individual holdings

; ===================================================================================
; BANK RELATIONSHIP
; ===================================================================================
; Bank relationship management.

{@bank_relationship}
; Required fields first
relationship_id = :                            ; Relationship ID
bank = @fin.financial_institution              ; Bank
entities[] = @legal_entity                     ; Corporate entities (shared banking)

; Relationship details
relationship_type = (
    correspondent,                              ; Correspondent bank
    custody,                                    ; Custody services
    investment,                                 ; Investment services
    lending,                                    ; Lending relationship
    operating,                                  ; Operating bank
    primary                                     ; Primary bank
)
status = (active, dormant, inactive, pending)   ; Status
start_date = date                               ; Relationship start

; Contacts
{.contacts}
relationship_manager = :                        ; RM name
rm_email = *@email                              ; RM email
rm_phone = *@phone                              ; RM phone
treasury_contacts[] = :                         ; Treasury contacts (multiple)
treasury_email = *@email                        ; Treasury email

{@bank_relationship}

; Accounts
accounts[] = @bank_account                      ; Related accounts

; Services utilized
{.services}
cash_management = ?                             ; Cash management
payments = ?                                    ; Payment services
collections = ?                                 ; Collection services
liquidity = ?                                   ; Liquidity/pooling
trade_finance = ?                               ; Trade finance
fx = ?                                          ; Foreign exchange
investments = ?                                 ; Investment services
lending = ?                                     ; Credit facilities
custody = ?                                     ; Custody
merchant_services = ?                           ; Merchant services

{@bank_relationship}

; Fee tracking
{.fees}
annual_fees = #$:(0..)                          ; Annual fees
monthly_fees = #$:(0..)                         ; Monthly fees
transaction_fees = #$:(0..)                     ; Transaction fees
ecr_credit = #$:(0..)                           ; Earnings credit
net_fees = #$:(0..)                             ; Net fees paid
last_analysis_date = date                       ; Last account analysis

{@bank_relationship}

; ===================================================================================
; LIQUIDITY BUFFER
; ===================================================================================
; Regulatory and operational liquidity buffers.

{@liquidity_buffer}
; Required fields first
buffer_id = :                                  ; Buffer identifier
buffer_date = date                             ; Reporting date
buffer_type = (
    lcr,                                        ; Liquidity Coverage Ratio
    nsfr,                                       ; Net Stable Funding Ratio
    operational,                                ; Operational buffer
    regulatory,                                 ; Regulatory requirement
    strategic                                   ; Strategic/internal
)
entity = @legal_entity                         ; Reporting entity
currency = :(3)                                ; Reporting currency

; LCR components (if applicable)
{.lcr}
hqla_level_1 = #$:(0..)                         ; Level 1 HQLA
hqla_level_2a = #$:(0..)                        ; Level 2A HQLA
hqla_level_2b = #$:(0..)                        ; Level 2B HQLA
total_hqla = #$:(0..)                           ; Total HQLA
net_cash_outflows = #$:(0..)                    ; 30-day net outflows
lcr_ratio = #:(0..500)                          ; LCR ratio %

{@liquidity_buffer}

; NSFR components (if applicable)
{.nsfr}
available_stable_funding = #$:(0..)             ; ASF
required_stable_funding = #$:(0..)              ; RSF
nsfr_ratio = #:(0..500)                         ; NSFR ratio %

{@liquidity_buffer}

; Operational buffer
{.operational}
minimum_cash_days = ##                          ; Minimum days of cash
target_cash_days = ##                           ; Target days of cash
actual_cash_days = ##                           ; Actual days of cash
minimum_balance = #$:(0..)                      ; Minimum balance required
target_balance = #$:(0..)                       ; Target balance
actual_balance = #$:(0..)                       ; Actual balance
committed_facilities = #$:(0..)                 ; Committed credit lines
available_facilities = #$:(0..)                 ; Available credit

{@liquidity_buffer}

; ===================================================================================
; CASH POOL
; ===================================================================================
; Physical or notional cash pooling structure.

{@cash_pool}
; Required fields first
pool_id = :                                    ; Pool identifier
pool_type = (
    hybrid,                                     ; Hybrid pooling
    notional,                                   ; Notional pooling
    physical,                                   ; Physical pooling
    target_balance                              ; Target balance pooling
)
pool_name = :                                  ; Pool name
pool_currency = :(3)                           ; Pool currency
pool_bank = @fin.financial_institution         ; Pool bank

; Header account
header_account = @bank_account                 ; Pool header account
operating_entity = @legal_entity               ; Pool operator

; Pool structure
participants[] = @pool_participant              ; Pool participants
cross_currency = ?                              ; Cross-currency pool
currencies[] = :(3)                             ; Included currencies

; Status
status = (active, inactive, pending)            ; Pool status

; ---------------------------------------------------------------------------
; Notional Pooling
; ---------------------------------------------------------------------------
{.notional}
interest_optimization = ?:if pool_type = notional
shadow_rate = #.4:if pool_type = notional       ; Shadow interest rate
debit_rate = #.4:if pool_type = notional        ; Debit rate
credit_rate = #.4:if pool_type = notional       ; Credit rate
advantage_sharing = (
    proportional,                               ; Pro-rata sharing
    retained_by_bank,                           ; Bank keeps benefit
    to_header                                   ; All to header
):if pool_type = notional

{@cash_pool}

; ---------------------------------------------------------------------------
; Physical Pooling
; ---------------------------------------------------------------------------
{.physical}
sweep_frequency = (daily, intraday, weekly):if pool_type = physical
sweep_type = (
    target_balance,                             ; To target
    zero_balance                                ; Full sweep
):if pool_type = physical
reverse_sweep = ?:if pool_type = physical       ; Reverse sweep enabled
target_time = time:if pool_type = physical      ; Sweep time

{@cash_pool}

{@pool_participant}
entity = @legal_entity                         ; Participating entity
account = @bank_account                        ; Participant account
role = (header, participant)                    ; Pool role
status = (active, inactive, pending)            ; Participation status
target_balance = #$                             ; Target balance (if ZBA)
credit_limit = #$:(0..)                         ; Credit limit
debit_limit = #$:(0..)                          ; Debit limit
interest_allocation_pct = #:(0..100)            ; Interest allocation %

; ===================================================================================
; IN-HOUSE BANK
; ===================================================================================
; Internal banking/intercompany financing.

{@in_house_bank}
; Required fields first
ihb_id = :                                     ; IHB identifier
name = :                                       ; IHB name
operating_entity = @legal_entity               ; Operating entity
base_currency = :(3)                           ; Base currency

; Status
status = (active, inactive, pending)            ; IHB status

; Participants
participants[] = @ihb_participant               ; IHB participants

; ---------------------------------------------------------------------------
; Funding
; ---------------------------------------------------------------------------
{.funding}
external_funding = #$:(0..)                     ; External funding
intercompany_deposits = #$:(0..)                ; IC deposits
intercompany_loans = #$:(0..)                   ; IC loans outstanding
net_position = #$                               ; Net funding position

{@in_house_bank}

; ---------------------------------------------------------------------------
; Interest Rates
; ---------------------------------------------------------------------------
{.rates}
deposit_rate = #.4                              ; Deposit rate
loan_rate = #.4                                 ; Loan rate
base_rate = (euribor, prime, sofr)              ; Reference rate
spread_deposits = #.4                           ; Deposit spread
spread_loans = #.4                              ; Loan spread

{@in_house_bank}

; ---------------------------------------------------------------------------
; Transactions
; ---------------------------------------------------------------------------
{.transactions}
daily_limit = #$:(0..)                          ; Daily transaction limit
single_limit = #$:(0..)                         ; Single transaction limit
currencies[] = :(3)                             ; Supported currencies

{@in_house_bank}

{@ihb_participant}
entity = @legal_entity                         ; Participating entity
status = (active, inactive, pending)            ; Participation status
deposit_balance = #$:(0..)                      ; Current deposits
loan_balance = #$:(0..)                         ; Current borrowings
net_position = #$                               ; Net position
credit_limit = #$:(0..)                         ; Borrowing limit
deposit_rate = #.4                              ; Entity deposit rate
loan_rate = #.4                                 ; Entity loan rate


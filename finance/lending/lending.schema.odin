; ===================================================================================
; ODIN Finance Lending Schema
; ===================================================================================
; Lending products covering consumer, commercial, syndicated, asset-based, and
; SBA lending. Includes loan origination, borrower management, facility
; structures, and regulatory compliance (TILA, ECOA, FFIEC).
; ===================================================================================

@import "../types.schema.odin" as fin

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.finance.lending"
version = "1.0.0"
title = "Finance Lending Schema"
description = "Comprehensive lending schema for consumer, commercial, syndicated, asset-based, and SBA loans"

{$derivation}
source[0].authority = "Consumer Financial Protection Bureau"
source[0].citation = "Regulation Z - Truth in Lending (12 CFR 1026)"
source[0].url = "https://www.consumerfinance.gov/rules-policy/regulations/1026/"

source[1].authority = "Consumer Financial Protection Bureau"
source[1].citation = "Regulation B - Equal Credit Opportunity Act (12 CFR 1002)"
source[1].url = "https://www.consumerfinance.gov/rules-policy/regulations/1002/"

source[2].authority = "Federal Financial Institutions Examination Council"
source[2].citation = "FFIEC 031/041 Call Report Instructions"
source[2].url = "https://www.ffiec.gov/ffiec_report_forms.htm"

source[3].authority = "Office of the Comptroller of the Currency"
source[3].citation = "Comptroller's Handbook - Commercial Lending"
source[3].url = "https://www.occ.treas.gov/publications-and-resources/publications/comptrollers-handbook/index-comptrollers-handbook.html"

source[4].authority = "Loan Syndications and Trading Association"
source[4].citation = "LSTA Market Practice and Documentation Standards"
source[4].url = "https://www.lsta.org/content/primary-market-and-agent-transfer-practices/"

source[5].authority = "U.S. Small Business Administration"
source[5].citation = "SOP 50 10 7 - Lender and Development Company Loan Programs"
source[5].url = "https://www.sba.gov/document/sop-50-10-lender-development-company-loan-programs"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Derived from federal lending regulations, FFIEC guidance, OCC handbooks, LSTA standards, and SBA SOPs"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial lending schema"
changelog[0].rationale = "Comprehensive lending coverage across consumer, commercial, syndicated, ABL, and SBA"

; ===================================================================================
; BORROWER
; ===================================================================================
; Loan borrower/obligor identification and credit profile.

{@borrower}
; Required fields first
borrower_id = !:                                ; Internal borrower identifier
borrower_type = !(
    corporation,                                ; C-Corp or S-Corp
    government,                                 ; Government entity
    individual,                                 ; Natural person
    llc,                                        ; Limited liability company
    non_profit,                                 ; Non-profit organization
    partnership,                                ; General or limited partnership
    sole_proprietor,                            ; DBA/sole proprietorship
    trust                                       ; Trust entity
)
name = !:                                       ; Borrower legal name

; Identification
lei = :format lei                         ; Legal Entity Identifier
tax_id = *:                                     ; EIN or SSN (confidential)
duns = :/^\d{9}$/                               ; D-U-N-S number
naics_codes[] = :(6)                            ; NAICS codes (primary + secondary industries)
sic_codes[] = :(4)                              ; SIC codes (primary + secondary industries)

; Contact - borrowers have multiple locations and contacts
addresses[] = @address                          ; Addresses (HQ, operations, registered agent)
emails[] = *@email                              ; Emails (primary, CFO, AP, legal)
phones[] = *@phone                              ; Phones (main, direct, mobile)

; Organizational details
date_established = date                         ; Date formed/incorporated
fiscal_year_end = :(5)                          ; Fiscal year end (MM-DD)
state_of_incorporation = :(2)                   ; State/province of formation
country = :(2) "US"                             ; Country of formation

; ---------------------------------------------------------------------------
; Credit Profile
; ---------------------------------------------------------------------------
{.credit}
credit_scores[] = {@credit_score}               ; Credit scores (Experian, Equifax, TransUnion)

{@credit_score}
bureau = !(equifax, experian, transunion)       ; Credit bureau
score = !##:(300..850)                          ; Credit score
model = (fico, fico_sbss, vantage)              ; Scoring model
score_date = date                               ; Score date

{@borrower.credit}
internal_risk_rating = :(1..2)                  ; Bank internal rating (1-10)
external_rating = :                             ; S&P/Moody's rating if rated
pd_estimate = #:(0..100)                        ; Probability of default %
lgd_estimate = #:(0..100)                       ; Loss given default %

{@borrower}

; ---------------------------------------------------------------------------
; Financial Summary
; ---------------------------------------------------------------------------
{.financials}
annual_revenue = #$:(0..)                       ; Annual revenue
total_assets = #$:(0..)                         ; Total assets
total_liabilities = #$:(0..)                    ; Total liabilities
net_worth = #$                                  ; Net worth
ebitda = #$                                     ; EBITDA
debt_service_coverage = #                       ; DSCR ratio
current_ratio = #                               ; Current ratio
leverage_ratio = #                              ; Debt/equity ratio
financial_statement_date = date                 ; Statement as-of date
audited = ?                                     ; Audited financials
audit_firm = ::if audited = true                ; Auditor name

{@borrower}

; ---------------------------------------------------------------------------
; Guarantors (for guaranteed loans)
; ---------------------------------------------------------------------------
guarantors[] = @guarantor                       ; Personal/corporate guarantors

{@guarantor}
guarantor_id = !:                               ; Guarantor identifier
guarantor_type = !(corporate, individual)       ; Guarantor type
name = !:                                       ; Guarantor name
relationships[] = (                             ; Relationships (owner AND officer)
    affiliate,
    officer,
    owner,
    parent,
    related_party,
    spouse
)
ownership_pct = #:(0..100)                      ; Ownership percentage
guarantee_pct = #:(0..100)                      ; Guarantee coverage
guarantee_type = (
    full,                                       ; Full recourse
    limited,                                    ; Limited to amount
    partial,                                    ; Partial coverage
    subordinated                                ; Subordinated to senior
)
personal_financial_statement = ?                ; PFS on file
pfs_date = date                                 ; PFS date
net_worth = *#$                                 ; Guarantor net worth (confidential)
liquid_assets = *#$:(0..)                       ; Liquid assets (confidential)

; ===================================================================================
; LOAN FACILITY
; ===================================================================================
; Core loan facility structure used by all loan types.

{@facility}
; Required fields first
facility_id = !:                                ; Internal facility ID
facility_type = !(
    asset_based,                                ; ABL facility
    bridge,                                     ; Bridge loan
    construction,                               ; Construction loan
    delayed_draw_term,                          ; DDTL
    letter_of_credit,                           ; Standalone LC facility
    line_of_credit,                             ; LOC/revolver
    sba_504,                                    ; SBA 504
    sba_7a,                                     ; SBA 7(a)
    sba_express,                                ; SBA Express
    swing_line,                                 ; Swing line
    term_loan                                   ; Term loan
)
commitment_amount = !#$:(0..)                   ; Total commitment
currency = !:(3) "USD"                          ; Facility currency

; Borrower
borrowers[] = !@borrower                        ; Borrowers (jointly and severally liable)

; Status
status = (
    active,
    approved,
    closed,
    default,
    expired,
    funded,
    in_workout,
    non_accrual,
    paid_off,
    pending,
    written_off
)

; Dates
application_date = date                         ; Application date
approval_date = date                            ; Approval date
closing_date = date                             ; Loan closing date
effective_date = date                           ; Facility effective date
maturity_date = date                            ; Final maturity
expiration_date = date                          ; Commitment expiration

; Amounts
outstanding_principal = #$:(0..)                ; Current principal balance
available_commitment = #$:(0..)                 ; Available to draw
unfunded_commitment = #$:(0..)                  ; Unfunded portion
accrued_interest = #$:(0..)                     ; Accrued interest

; ---------------------------------------------------------------------------
; Interest Rate Terms
; ---------------------------------------------------------------------------
{.interest}
rate_type = !(fixed, floating)                  ; Fixed or floating
base_rate = (
    fed_funds,
    prime,
    sofr,                                       ; Secured Overnight Financing Rate
    sofr_term,                                  ; Term SOFR
    treasury,
    us_libor                                    ; Legacy LIBOR (deprecated)
)
spread = #.4                                    ; Spread over base (bps or %)
floor = #.4                                     ; Interest rate floor
ceiling = #.4                                   ; Interest rate ceiling/cap
all_in_rate = #.4                               ; Current all-in rate
day_count = (act_360, act_365, act_act, basis_30_360)
accrual_method = (
    actual,
    daily,
    monthly
)
payment_frequency = (
    annual,
    monthly,
    quarterly,
    semi_annual
)
compounding = (
    daily,
    monthly,
    none,
    quarterly
)

; Fixed rate terms
fixed_rate = #.4:if rate_type = fixed           ; Fixed rate
fixed_rate_expiry = date:if rate_type = fixed   ; Fixed rate period end

; Floating rate terms
reset_frequency = (daily, monthly, quarterly):if rate_type = floating
lookback_days = ##:if rate_type = floating      ; SOFR lookback period
observation_shift = ?:if rate_type = floating   ; Observation shift method

{@facility}

; ---------------------------------------------------------------------------
; Amortization
; ---------------------------------------------------------------------------
{.amortization}
type = (
    balloon,                                    ; Bullet at maturity
    custom,                                     ; Custom schedule
    equal_principal,                            ; Equal principal + interest
    fully_amortizing,                           ; Full amortization
    interest_only,                              ; I/O then amortizing
    seasonal                                    ; Seasonal payments
)
term_months = ##:(1..)                          ; Amortization term
io_period_months = ##:if type = interest_only   ; Interest-only period
payment_amount = #$:(0..)                       ; Scheduled payment
first_payment_date = date                       ; First payment date
balloon_amount = #$:(0..):if type = balloon     ; Balloon payment amount

{@facility}

; ---------------------------------------------------------------------------
; Fees
; ---------------------------------------------------------------------------
{.fees}
origination_fee = #$:(0..)                      ; Origination/closing fee
origination_fee_pct = #:(0..10)                 ; As percentage
commitment_fee = #.4                            ; Unused commitment fee (bps)
utilization_fee = #.4                           ; Utilization fee (bps)
letter_of_credit_fee = #.4                      ; LC fee (bps)
agency_fee = #$:(0..)                           ; Agent bank fee
amendment_fee = #$:(0..)                        ; Amendment fee
prepayment_fee_pct = #:(0..10)                  ; Prepayment penalty %
annual_fee = #$:(0..)                           ; Annual administrative fee
late_fee = #$:(0..)                             ; Late payment fee
late_fee_grace_days = ##:(0..)                  ; Grace period for late fee

{@facility}

; ---------------------------------------------------------------------------
; Collateral Summary
; ---------------------------------------------------------------------------
{.collateral_summary}
secured = ?                                     ; Secured loan flag
collateral_types[] = (
    accounts_receivable,
    cash,
    deposit_accounts,
    equipment,
    intellectual_property,
    inventory,
    investments,
    real_estate,
    stock_pledge,
    vehicles
)
collateral_value = #$:(0..)                     ; Total collateral value
ltv = #:(0..200)                                ; Loan-to-value ratio
advance_rate = #:(0..100)                       ; Blended advance rate

{@facility}

; ---------------------------------------------------------------------------
; Covenants Summary
; ---------------------------------------------------------------------------
covenants[] = @covenant                         ; Financial covenants

; ===================================================================================
; COVENANT
; ===================================================================================
; Financial and non-financial covenants.

{@covenant}
; Required fields first
covenant_id = !:                                ; Covenant identifier
covenant_type = !(
    affirmative,                                ; Must do something
    financial,                                  ; Financial ratio test
    negative,                                   ; Must not do something
    reporting                                   ; Reporting requirement
)
name = !:                                       ; Covenant name
description = :                                 ; Covenant description

; Financial covenant specifics
{.financial}
metric = (
    current_ratio,
    debt_service_coverage,
    fixed_charge_coverage,
    interest_coverage,
    leverage_ratio,
    minimum_ebitda,
    minimum_liquidity,
    minimum_net_worth,
    senior_leverage,
    tangible_net_worth,
    total_debt_to_ebitda
):if covenant_type = financial
threshold_type = (maximum, minimum):if covenant_type = financial
threshold_value = #:if covenant_type = financial
cure_period_days = ##:if covenant_type = financial
measurement_frequency = (annual, monthly, quarterly):if covenant_type = financial

{@covenant}

; Compliance tracking
{.compliance}
last_tested = date                              ; Last test date
last_actual = #                                 ; Last actual value
compliant = ?                                   ; In compliance
waiver_granted = ?                              ; Waiver in effect
waiver_expiry = date:if waiver_granted = true   ; Waiver expiration
amendment_date = date                           ; Last amendment date

{@covenant}

; ===================================================================================
; COLLATERAL
; ===================================================================================
; Detailed collateral information.

{@collateral}
; Required fields first
collateral_id = !:                              ; Collateral identifier
collateral_type = !(
    accounts_receivable,
    cash,
    deposit_accounts,
    equipment,
    intellectual_property,
    inventory,
    investments,
    real_estate,
    stock_pledge,
    vehicles
)

; Valuation
appraised_value = #$:(0..)                      ; Appraised value
appraisal_date = date                           ; Appraisal date
appraiser = :                                   ; Appraiser name/firm
book_value = #$:(0..)                           ; Book value
market_value = #$:(0..)                         ; Current market value
forced_sale_value = #$:(0..)                    ; Forced liquidation value
advance_rate = #:(0..100)                       ; Advance rate %
collateral_amount = #$:(0..)                    ; Amount attributed to loan

; Description
description = :                                 ; Collateral description
location = :                                    ; Physical location
serial_number = :                               ; Serial/VIN if applicable

; ---------------------------------------------------------------------------
; Real Estate Collateral
; ---------------------------------------------------------------------------
{.real_estate}
property_type = (
    agricultural,
    commercial,
    industrial,
    mixed_use,
    multi_family,
    office,
    residential,
    retail
):if collateral_type = real_estate
property_address = @address:if collateral_type = real_estate
square_footage = ##:if collateral_type = real_estate
year_built = ##:if collateral_type = real_estate
occupancy_rate = #:(0..100):if collateral_type = real_estate
noi = #$:if collateral_type = real_estate       ; Net operating income

{@collateral}

; ---------------------------------------------------------------------------
; Equipment Collateral
; ---------------------------------------------------------------------------
{.equipment}
equipment_type = ::if collateral_type = equipment
manufacturer = ::if collateral_type = equipment
model = ::if collateral_type = equipment
year = ##:if collateral_type = equipment
condition = (excellent, fair, good, poor):if collateral_type = equipment
useful_life_months = ##:if collateral_type = equipment

{@collateral}

; ---------------------------------------------------------------------------
; Security Interest
; ---------------------------------------------------------------------------
{.security_interest}
lien_position = ##:(1..)                        ; Lien priority (1=first)
ucc_filings[] = {@ucc_filing}                   ; UCC filings (original, amendments, continuations)
mortgage_recorded = ?                           ; Mortgage recorded
mortgage_recording_date = date                  ; Recording date
deed_of_trust = ?                               ; DOT state
title_insurance = ?                             ; Title policy obtained

{@ucc_filing}
filing_number = !:                              ; UCC filing number
filing_type = !(amendment, continuation, initial, termination)
filing_date = !date                             ; Filing date
filing_state = :(2)                             ; Filing jurisdiction
lapse_date = date                               ; Lapse date (5 years from initial)

{@collateral}

; ===================================================================================
; CONSUMER LOAN
; ===================================================================================
; Consumer lending specific fields per Regulation Z (TILA) requirements.

{@consumer_loan}
= @facility                                     ; Inherit facility fields

; Reg Z Disclosures
{.reg_z}
apr = !#.4                                      ; Annual Percentage Rate
finance_charge = !#$:(0..)                      ; Total finance charge
amount_financed = !#$:(0..)                     ; Amount financed
total_of_payments = !#$:(0..)                   ; Total of payments
payment_schedule_provided = !?                  ; Payment schedule disclosed
rescission_rights = ?                           ; Right to rescind (3 days)
rescission_end_date = date:if rescission_rights = true

{@consumer_loan}

; Loan Purpose
loan_purpose = (
    auto_new,
    auto_used,
    consolidation,
    credit_card_refinance,
    education,
    home_improvement,
    major_purchase,
    medical,
    other,
    vacation
)

; Consumer-specific terms
consumer_type = (
    auto_direct,
    auto_indirect,
    credit_card,
    heloc,
    installment,
    personal_loc,
    student
)

; Credit card specific
{.credit_card}
credit_limit = #$:(0..):if consumer_type = credit_card
purchase_apr = #.4:if consumer_type = credit_card
balance_transfer_apr = #.4:if consumer_type = credit_card
cash_advance_apr = #.4:if consumer_type = credit_card
penalty_apr = #.4:if consumer_type = credit_card
minimum_payment_pct = #:(0..100):if consumer_type = credit_card
grace_period_days = ##:if consumer_type = credit_card

{@consumer_loan}

; HELOC specific
{.heloc}
draw_period_months = ##:if consumer_type = heloc
repayment_period_months = ##:if consumer_type = heloc
property_address = @address:if consumer_type = heloc
property_value = #$:(0..):if consumer_type = heloc
cltv = #:(0..200):if consumer_type = heloc

{@consumer_loan}

; Reg B (ECOA) - Adverse Action
{.adverse_action}
action_taken = (
    approved,
    approved_not_accepted,
    counter_offer,
    denied,
    incomplete_application,
    withdrawn
)
action_date = date
denial_reasons[] = (
    collateral,
    credit_application_incomplete,
    credit_history,
    delinquent_accounts,
    employment,
    excessive_obligations,
    garnishment_attachment,
    income,
    insufficient_credit_file,
    length_of_employment,
    length_of_residence,
    temporary_residence,
    unable_to_verify_credit,
    unable_to_verify_employment,
    unable_to_verify_income
)

{@consumer_loan}

; ===================================================================================
; COMMERCIAL LOAN
; ===================================================================================
; Commercial lending specific fields per OCC Commercial Lending Handbook.

{@commercial_loan}
= @facility                                     ; Inherit facility fields

; Commercial classification
commercial_type = (
    agricultural,
    cre_construction,
    cre_income_producing,
    cre_land_development,
    cre_owner_occupied,
    equipment_finance,
    floor_plan,
    general_c_and_i,
    leveraged,
    project_finance,
    working_capital
)

; Loan size classification
loan_size_class = (
    large,                                      ; >$25M
    medium,                                     ; $1M-$25M
    small,                                      ; $100K-$1M
    small_business                              ; <$100K
)

; Regulatory reporting
call_report_code = :(4)                         ; FFIEC Call Report code
shared_national_credit = ?                      ; SNC program loan (>$100M)
snc_agent = ::if shared_national_credit = true  ; SNC agent bank

; ---------------------------------------------------------------------------
; Risk Rating
; ---------------------------------------------------------------------------
{.risk_rating}
internal_rating = :(1..2)                       ; Bank rating (1-10 scale)
rating_date = date                              ; Rating date
previous_rating = :(1..2)                       ; Prior rating
rating_trend = (downgrade, stable, upgrade)     ; Rating trend
watch_list = ?                                  ; On watch list
special_mention = ?                             ; OCC special mention
substandard = ?                                 ; OCC substandard
doubtful = ?                                    ; OCC doubtful
loss = ?                                        ; OCC loss
exam_rating = :(1..2)                           ; Regulator exam rating

{@commercial_loan}

; ---------------------------------------------------------------------------
; Relationship
; ---------------------------------------------------------------------------
{.relationship}
relationship_manager = :                        ; RM name
relationship_id = :                             ; Relationship ID
total_exposure = #$:(0..)                       ; Total relationship exposure
related_facilities[] = :                        ; Related facility IDs
cross_default = ?                               ; Cross-default with other facilities
cross_collateral = ?                            ; Cross-collateralized

{@commercial_loan}

; ===================================================================================
; SYNDICATED LOAN
; ===================================================================================
; Syndicated lending per LSTA standards.

{@syndicated_loan}
= @facility                                     ; Inherit facility fields

; Syndication structure
syndication_type = !(
    bilateral,                                  ; Single lender
    club_deal,                                  ; Small group, direct
    syndicated                                  ; Broadly syndicated
)

; Agent banks
{.agent_banks}
administrative_agent = !@fin.financial_institution    ; Admin agent
collateral_agent = @fin.financial_institution         ; Collateral agent
documentation_agent = @fin.financial_institution      ; Doc agent
syndication_agent = @fin.financial_institution        ; Syndication agent
co_agents[] = @fin.financial_institution              ; Co-agents

{@syndicated_loan}

; Lender participations
lenders[] = @lender_participation               ; Lender participations

; ---------------------------------------------------------------------------
; LSTA Documentation
; ---------------------------------------------------------------------------
{.documentation}
credit_agreement_type = (
    lsta_form,
    lma_form,                                   ; UK/Europe
    proprietary
)
credit_agreement_date = date                    ; Execution date
governing_law = (delaware, new_york, uk)        ; Governing law
agent_fee_letter = ?                            ; Fee letter signed
lender_accession = ?                            ; Accession agreement

{@syndicated_loan}

; ---------------------------------------------------------------------------
; Voting and Amendment
; ---------------------------------------------------------------------------
{.voting}
required_lender_threshold = #:(50..100)         ; Required lender %
supermajority_threshold = #:(66.67..100)        ; Super-majority %
unanimous_matters[] = :                         ; Unanimous consent items

{@syndicated_loan}

{@lender_participation}
; Required fields first
lender = !@fin.financial_institution            ; Participating lender
commitment = !#$:(0..)                          ; Commitment amount
funded = !#$:(0..)                              ; Funded amount
share_pct = !#:(0..100)                         ; Pro-rata share %

; Roles
roles[] = (                                     ; Roles (lead_arranger AND bookrunner)
    arranger,
    bookrunner,
    co_lead,
    lead_arranger,
    mandated_lead_arranger,
    participant
)
voting = ?true                                  ; Voting lender

; Transfer
assignable = ?true                              ; Can assign
minimum_assignment = #$:(0..)                   ; Minimum assignment amount
minimum_hold = #$:(0..)                         ; Minimum hold requirement

; ---------------------------------------------------------------------------
; Secondary Market
; ---------------------------------------------------------------------------
{.trading}
par_traded = ?                                  ; Traded at par
distressed = ?                                  ; Distressed trading
last_trade_date = date                          ; Last trade date
last_trade_price = #:(0..200)                   ; Last trade price (% of par)
accrued_interest = #$:(0..)                     ; Accrued interest at trade

{@lender_participation}

; ===================================================================================
; ASSET-BASED LOAN
; ===================================================================================
; Asset-based lending with borrowing base mechanics.

{@asset_based_loan}
= @facility                                     ; Inherit facility fields

; ABL structure
abl_type = !(
    accounts_only,                              ; AR only
    accounts_and_inventory,                     ; AR + Inventory
    full_abl                                    ; AR + Inv + Equipment
)

; ---------------------------------------------------------------------------
; Borrowing Base
; ---------------------------------------------------------------------------
{.borrowing_base}
total_availability = #$:(0..)                   ; Total availability
borrowing_base_date = date                      ; BBC date
submission_frequency = (daily, monthly, weekly) ; BBC frequency
field_exam_date = date                          ; Last field exam
field_exam_frequency_months = ##                ; Field exam frequency

{@asset_based_loan}

; ---------------------------------------------------------------------------
; Accounts Receivable
; ---------------------------------------------------------------------------
{.accounts_receivable}
gross_ar = #$:(0..)                             ; Gross A/R
eligible_ar = #$:(0..)                          ; Eligible A/R
ineligibles_total = #$:(0..)                    ; Total ineligibles
advance_rate = #:(0..100)                       ; Advance rate %
ar_availability = #$:(0..)                      ; A/R availability

; Eligibility criteria
over_90_days = #$:(0..)                         ; Over 90 days past due
cross_aged = #$:(0..)                           ; Cross-aged ineligibles
concentration_excess = #$:(0..)                 ; Concentration excess
contra_accounts = #$:(0..)                      ; Contra accounts
foreign = #$:(0..)                              ; Foreign (if ineligible)
affiliate = #$:(0..)                            ; Affiliate/intercompany
government = #$:(0..)                           ; Government excess
disputed = #$:(0..)                             ; Disputed amounts

; Concentration limits
largest_debtor_limit_pct = #:(0..100)           ; Single debtor limit %
top_10_debtor_limit_pct = #:(0..100)            ; Top 10 limit %

{@asset_based_loan}

; ---------------------------------------------------------------------------
; Inventory
; ---------------------------------------------------------------------------
{.inventory}
gross_inventory = #$:(0..)                      ; Gross inventory
eligible_inventory = #$:(0..)                   ; Eligible inventory
advance_rate = #:(0..100)                       ; Advance rate %
inventory_availability = #$:(0..)               ; Inventory availability

; Inventory by type
raw_materials = #$:(0..)                        ; Raw materials
work_in_process = #$:(0..)                      ; WIP (often ineligible)
finished_goods = #$:(0..)                       ; Finished goods
packaging = #$:(0..)                            ; Packaging/supplies

; Caps
inventory_cap = #$:(0..)                        ; Inventory cap
inventory_cap_pct = #:(0..100)                  ; As % of AR

; NOLV
nolv = #$:(0..)                                 ; Net orderly liquidation value
nolv_date = date                                ; NOLV appraisal date
nolv_advance_rate = #:(0..100)                  ; NOLV advance rate

{@asset_based_loan}

; ---------------------------------------------------------------------------
; Equipment (if applicable)
; ---------------------------------------------------------------------------
{.equipment}
gross_value = #$:(0..)                          ; Gross equipment value
eligible_value = #$:(0..)                       ; Eligible value
advance_rate = #:(0..100)                       ; Advance rate %
equipment_availability = #$:(0..)               ; Equipment availability
fmv = #$:(0..)                                  ; Fair market value
flv = #$:(0..)                                  ; Forced liquidation value
appraisal_date = date                           ; Appraisal date

{@asset_based_loan}

; ---------------------------------------------------------------------------
; Dominion/Control
; ---------------------------------------------------------------------------
{.dominion}
lockbox = ?                                     ; Lockbox in place
blocked_account = ?                             ; Blocked account
springing_dominion = ?                          ; Springing trigger
dominion_trigger = #$:(0..)                     ; Availability trigger amount
full_dominion = ?                               ; Full dominion active
deposit_account_control = ?                     ; DACA in place

{@asset_based_loan}

; ===================================================================================
; SBA LOAN
; ===================================================================================
; SBA loan programs per SOP 50 10.

{@sba_loan}
= @facility                                     ; Inherit facility fields

; SBA program
sba_program = !(
    community_advantage,                        ; CA program
    disaster,                                   ; SBA disaster loan
    express,                                    ; SBA Express (up to $500K)
    export_express,                             ; Export Express
    export_working_capital,                     ; EWCP
    microloan,                                  ; Microloan program
    sba_504,                                    ; 504/CDC program
    sba_7a,                                     ; 7(a) program
    sba_7a_small                                ; 7(a) Small Loan
)

; SBA identification
sba_loan_number = :                             ; SBA loan number
pfs_number = :                                  ; PLP/SBA Express number
e_tran_number = :                               ; E-Tran number

; Guarantee
{.guarantee}
guarantee_pct = #:(0..90)                       ; SBA guarantee %
guaranty_fee = #$:(0..)                         ; Guaranty fee paid
ongoing_guaranty_fee = #.4                      ; Ongoing fee (bps)
guarantee_expiry = date                         ; Guarantee expiration

{@sba_loan}

; Eligibility
{.eligibility}
size_standard_met = ?                           ; SBA size standard
for_profit = ?                                  ; For-profit entity
us_based = ?                                    ; US business
owner_occupied = ?:if sba_program = sba_504     ; 51% owner occupied
credit_elsewhere_test = ?                       ; Credit elsewhere
business_type_eligible = ?                      ; Eligible business type
franchise_directory = ?                         ; Franchise registry

{@sba_loan}

; Use of proceeds
{.use_of_proceeds}
working_capital = #$:(0..)                      ; Working capital
equipment = #$:(0..)                            ; Equipment purchase
inventory = #$:(0..)                            ; Inventory
real_estate = #$:(0..)                          ; Real estate
debt_refinance = #$:(0..)                       ; Debt refinance
business_acquisition = #$:(0..)                 ; Business acquisition
leasehold_improvements = #$:(0..)               ; Leasehold improvements

{@sba_loan}

; 504 specific (CDC debenture)
{.sba_504}
cdc_name = ::if sba_program = sba_504           ; CDC name
debenture_amount = #$:(0..):if sba_program = sba_504
project_cost = #$:(0..):if sba_program = sba_504
lender_contribution = #$:(0..):if sba_program = sba_504
borrower_injection = #$:(0..):if sba_program = sba_504
job_creation_required = ##:if sba_program = sba_504
jobs_created = ##:if sba_program = sba_504
jobs_retained = ##:if sba_program = sba_504

{@sba_loan}

; ---------------------------------------------------------------------------
; Authorization
; ---------------------------------------------------------------------------
{.authorization}
authorization_date = date                       ; SBA authorization date
authorization_expiry = date                     ; Authorization expiration
sba_office = :                                  ; SBA district office
sba_approval_type = (
    community_advantage,
    express,
    plp,                                        ; Preferred Lender Program
    sba_express,
    standard                                    ; Standard processing
)
declined = ?                                    ; SBA declined
decline_reasons[] = :                           ; Decline reasons (credit, collateral, eligibility)

{@sba_loan}

; ===================================================================================
; LOAN PAYMENT
; ===================================================================================
; Payment transaction record.

{@loan_payment}
; Required fields first
payment_id = !:                                 ; Payment identifier
facility_id = !:                                ; Facility reference
payment_date = !date                            ; Payment date
total_amount = !#$:(0..)                        ; Total payment amount

; Allocation
principal = #$:(0..)                            ; Principal portion
interest = #$:(0..)                             ; Interest portion
fees = #$:(0..)                                 ; Fees portion
escrow = #$:(0..)                               ; Escrow portion
late_charges = #$:(0..)                         ; Late charges

; Payment details
payment_type = (
    advance,                                    ; Draw/advance
    curtailment,                                ; Extra principal
    fee_payment,                                ; Fee only
    interest_only,                              ; Interest only
    payoff,                                     ; Full payoff
    prepayment,                                 ; Prepayment
    regular,                                    ; Scheduled payment
    reversal                                    ; Payment reversal
)
payment_method = (
    ach,
    check,
    fed_wire,
    internal_transfer,
    swift
)
reference = :                                   ; Payment reference

; Status
status = (
    applied,
    nsf,
    pending,
    reversed
)
effective_date = date                           ; Value date

; Post-payment balances
principal_balance_after = #$:(0..)              ; Balance after payment
next_payment_due = date                         ; Next due date

; ===================================================================================
; LOAN DRAW / ADVANCE
; ===================================================================================
; Borrowing request/draw on credit facility.

{@loan_draw}
; Required fields first
draw_id = !:                                    ; Draw identifier
facility_id = !:                                ; Facility reference
request_date = !date                            ; Request date
amount = !#$:(0..)                              ; Draw amount

; Draw details
draw_type = (
    initial,                                    ; Initial funding
    regular,                                    ; Regular draw
    swing_line,                                 ; Swing line
    letter_of_credit                            ; LC issuance
)
purpose = :                                     ; Purpose description
interest_period = (
    daily,
    one_month,
    one_week,
    overnight,
    six_months,
    three_months
)

; Status
status = (
    approved,
    cancelled,
    funded,
    pending,
    rejected
)
approval_date = date                            ; Approval date
funding_date = date                             ; Funding date
rejection_reason = :                            ; If rejected

; Funding
funding_account = @fin.account                  ; Funding account
wire_reference = :                              ; Wire reference

; ===================================================================================
; REGULATORY REPORTING
; ===================================================================================
; Loan-level regulatory reporting fields.

{@loan_regulatory}
facility_id = !:                                ; Facility reference

; FFIEC Call Report
{.call_report}
schedule = :(4)                                 ; RC-C, RC-N, etc.
line_item = :(4)                                ; Line item code
past_due_category = (
    current,
    days_30_89,
    days_90_plus,
    non_accrual
)
charge_off_amount = #$:(0..)                    ; Charge-off amount
specific_reserve = #$:(0..)                     ; Specific reserve

{@loan_regulatory}

; CRA (Community Reinvestment Act)
{.cra}
reportable = ?                                  ; CRA reportable
loan_amount = #$:(0..)                          ; Loan amount
census_tract = :                                ; Property census tract
borrower_income_level = (
    low,
    moderate,
    middle,
    upper
)
small_business = ?                              ; Small business loan
small_farm = ?                                  ; Small farm loan
community_development = ?                       ; CD purpose

{@loan_regulatory}

; HMDA (if applicable to real estate)
{.hmda}
reportable = ?                                  ; HMDA reportable
lei = :format lei                         ; Lender LEI
uli = :                                         ; Universal Loan Identifier
action_taken = ##:(1..8)                        ; HMDA action code
action_date = date                              ; Action date
loan_purpose = ##:(1..32)                       ; HMDA purpose code
property_type = ##:(1..3)                       ; HMDA property type

{@loan_regulatory}


; ===================================================================================
; ODIN Finance Regulatory Schema
; ===================================================================================
; Regulatory reporting covering call reports (FFIEC), stress testing (CCAR/DFAST),
; AML/BSA (CTR, SAR), sanctions screening (OFAC), and consumer compliance
; (HMDA, CRA, Fair Lending).
; ===================================================================================

@import "../types.schema.odin" as fin

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.finance.regulatory"
version = "1.0.0"
title = "Finance Regulatory Schema"
description = "Comprehensive regulatory reporting for call reports, stress testing, AML, sanctions, and consumer compliance"

{$derivation}
source[0].authority = "Federal Financial Institutions Examination Council"
source[0].citation = "FFIEC 031/041/051 Call Report Instructions"
source[0].url = "https://www.ffiec.gov/ffiec_report_forms.htm"

source[1].authority = "Board of Governors of the Federal Reserve System"
source[1].citation = "Comprehensive Capital Analysis and Review (CCAR) Assessment Framework"
source[1].url = "https://www.federalreserve.gov/supervisionreg/ccar.htm"

source[2].authority = "Financial Crimes Enforcement Network"
source[2].citation = "Bank Secrecy Act Regulations (31 CFR Chapter X)"
source[2].url = "https://www.fincen.gov/resources/statutes-and-regulations"

source[3].authority = "Office of Foreign Assets Control"
source[3].citation = "OFAC Sanctions Programs and Information"
source[3].url = "https://ofac.treasury.gov/sanctions-programs-and-country-information"

source[4].authority = "Consumer Financial Protection Bureau"
source[4].citation = "HMDA Regulation C (12 CFR 1003)"
source[4].url = "https://www.consumerfinance.gov/rules-policy/regulations/1003/"

source[5].authority = "Board of Governors of the Federal Reserve System"
source[5].citation = "Regulation BB - Community Reinvestment Act"
source[5].url = "https://www.federalreserve.gov/consumerscommunities/cra_about.htm"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Derived from FFIEC instructions, Federal Reserve frameworks, FinCEN/OFAC requirements, and CFPB regulations"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial regulatory schema"
changelog[0].rationale = "Comprehensive regulatory reporting for banking compliance"

; ===================================================================================
; REPORTING ENTITY
; ===================================================================================
; Regulated financial institution.

{@reporting_entity}
; Required fields first
entity_id = !:                                  ; Entity identifier
entity_type = !(
    bank_holding_company,                       ; BHC
    community_bank,                             ; Community bank
    credit_union,                               ; Credit union
    foreign_bank_branch,                        ; Foreign bank branch
    ihc,                                        ; Intermediate holding company
    national_bank,                              ; National bank (OCC)
    savings_association,                        ; Thrift/S&L
    slhc,                                       ; S&L holding company
    state_member,                               ; State member bank
    state_nonmember                             ; State non-member bank
)
name = !:                                       ; Institution name
charter_number = :                              ; Charter number
rssd_id = :(10)                                 ; RSSD ID (Fed)
fdic_cert = :(5)                                ; FDIC certificate number
occ_charter = :(5)                              ; OCC charter number
lei = :format lei                         ; Legal Entity Identifier

; Regulator
primary_regulator = !(
    fdic,                                       ; FDIC
    frb,                                        ; Federal Reserve
    ncua,                                       ; NCUA
    occ,                                        ; OCC
    state                                       ; State regulator
)
state_regulator = :                             ; State regulatory agency

; Asset size category
{.size}
total_assets = #$:(0..)                         ; Total assets
asset_category = (
    community,                                  ; <$10B
    large,                                      ; $100B-$250B
    mid_size,                                   ; $10B-$100B
    systemically_important                      ; >$250B / G-SIB
)
domestic_only = ?                               ; Domestic reporting only

{@reporting_entity}

; ===================================================================================
; CALL REPORT
; ===================================================================================
; FFIEC Consolidated Reports of Condition and Income.

{@call_report}
; Required fields first
report_id = !:                                  ; Report identifier
report_type = !(
    ffiec_031,                                  ; Large banks with foreign offices
    ffiec_041,                                  ; Banks with domestic offices only
    ffiec_051,                                  ; Small banks (eligible for reduced)
    fr_y_9c,                                    ; BHC consolidated
    fr_y_9lp,                                   ; BHC parent only
    fr_y_9sp                                    ; Small BHC
)
entity = !@reporting_entity                     ; Reporting institution
report_date = !date                             ; As-of date (quarter end)

; Status
status = (
    accepted,                                   ; Accepted by regulator
    amended,                                    ; Amended submission
    draft,                                      ; Draft/in progress
    rejected,                                   ; Rejected by regulator
    submitted                                   ; Submitted
)
submission_date = date                          ; Submission date
accepted_date = date                            ; Acceptance date

; ---------------------------------------------------------------------------
; Schedule RC - Balance Sheet
; ---------------------------------------------------------------------------
{.schedule_rc}
; Assets
cash_and_due = #$:(0..)                         ; RC Line 1
securities_htm = #$:(0..)                       ; RC Line 2a (HTM)
securities_afs = #$:(0..)                       ; RC Line 2b (AFS)
securities_trading = #$:(0..)                   ; RC Line 2c (Trading)
fed_funds_sold = #$:(0..)                       ; RC Line 3
loans_and_leases = #$:(0..)                     ; RC Line 4a (Gross)
less_allowance = #$:(0..)                       ; RC Line 4b (ALLL)
loans_net = #$:(0..)                            ; RC Line 4c (Net)
premises_fixed_assets = #$:(0..)                ; RC Line 6
other_real_estate = #$:(0..)                    ; RC Line 7
goodwill = #$:(0..)                             ; RC Line 10a
other_intangibles = #$:(0..)                    ; RC Line 10b
other_assets = #$:(0..)                         ; RC Line 11
total_assets = #$:(0..)                         ; RC Line 12

; Liabilities
deposits_domestic = #$:(0..)                    ; RC Line 13a
deposits_foreign = #$:(0..)                     ; RC Line 13b
fed_funds_purchased = #$:(0..)                  ; RC Line 14
trading_liabilities = #$:(0..)                  ; RC Line 15
other_borrowed = #$:(0..)                       ; RC Line 16
subordinated_debt = #$:(0..)                    ; RC Line 19
other_liabilities = #$:(0..)                    ; RC Line 20
total_liabilities = #$:(0..)                    ; RC Line 21

; Equity
common_stock = #$:(0..)                         ; RC Line 24
surplus = #$:(0..)                              ; RC Line 25
retained_earnings = #$:(0..)                    ; RC Line 26a
aoci = #$                                       ; RC Line 26b (AOCI)
total_equity = #$:(0..)                         ; RC Line 28
total_liabilities_equity = #$:(0..)             ; RC Line 29

{@call_report}

; ---------------------------------------------------------------------------
; Schedule RC-C - Loans and Lease Financing
; ---------------------------------------------------------------------------
{.schedule_rc_c}
; Part I - Loans and Leases
construction_land = #$:(0..)                    ; RC-C Line 1a
secured_farmland = #$:(0..)                     ; RC-C Line 1b
res_re_first_lien = #$:(0..)                    ; RC-C Line 1c(1)
res_re_junior_lien = #$:(0..)                   ; RC-C Line 1c(2)
res_re_heloc = #$:(0..)                         ; RC-C Line 1c(3)
multifamily = #$:(0..)                          ; RC-C Line 1d
cre_nonfarm = #$:(0..)                          ; RC-C Line 1e
commercial_industrial = #$:(0..)                ; RC-C Line 4
consumer_credit_card = #$:(0..)                 ; RC-C Line 6a
consumer_other = #$:(0..)                       ; RC-C Line 6b
agricultural_loans = #$:(0..)                   ; RC-C Line 3
leases = #$:(0..)                               ; RC-C Line 10
total_loans_leases = #$:(0..)                   ; RC-C Line 12

{@call_report}

; ---------------------------------------------------------------------------
; Schedule RC-N - Past Due and Nonaccrual
; ---------------------------------------------------------------------------
{.schedule_rc_n}
; 30-89 days past due
past_due_30_89_real_estate = #$:(0..)
past_due_30_89_ci = #$:(0..)
past_due_30_89_consumer = #$:(0..)
past_due_30_89_total = #$:(0..)

; 90+ days past due
past_due_90_plus_real_estate = #$:(0..)
past_due_90_plus_ci = #$:(0..)
past_due_90_plus_consumer = #$:(0..)
past_due_90_plus_total = #$:(0..)

; Nonaccrual
nonaccrual_real_estate = #$:(0..)
nonaccrual_ci = #$:(0..)
nonaccrual_consumer = #$:(0..)
nonaccrual_total = #$:(0..)

{@call_report}

; ---------------------------------------------------------------------------
; Schedule RI - Income Statement
; ---------------------------------------------------------------------------
{.schedule_ri}
; Interest income
interest_loans_leases = #$:(0..)                ; RI Line 1a
interest_securities = #$:(0..)                  ; RI Line 1b
interest_other = #$:(0..)                       ; RI Line 1e
total_interest_income = #$:(0..)                ; RI Line 1h

; Interest expense
interest_deposits = #$:(0..)                    ; RI Line 2a
interest_borrowed = #$:(0..)                    ; RI Line 2b
total_interest_expense = #$:(0..)               ; RI Line 2e

; Net interest income
net_interest_income = #$                        ; RI Line 3

; Provision and noninterest
provision_loan_losses = #$                      ; RI Line 4
noninterest_income = #$:(0..)                   ; RI Line 5h
noninterest_expense = #$:(0..)                  ; RI Line 7e

; Net income
income_before_taxes = #$                        ; RI Line 8
income_taxes = #$                               ; RI Line 9
net_income = #$                                 ; RI Line 12

{@call_report}

; ---------------------------------------------------------------------------
; Risk-Based Capital (Schedule RC-R)
; ---------------------------------------------------------------------------
{.capital}
cet1_capital = #$:(0..)                         ; CET1 capital
tier_1_capital = #$:(0..)                       ; Tier 1 capital
total_capital = #$:(0..)                        ; Total capital
rwa = #$:(0..)                                  ; Risk-weighted assets
cet1_ratio = #.2                                ; CET1 ratio %
tier_1_ratio = #.2                              ; Tier 1 ratio %
total_capital_ratio = #.2                       ; Total capital ratio %
leverage_ratio = #.2                            ; Leverage ratio %

; Well-capitalized thresholds
well_capitalized = ?                            ; Meets well-capitalized
adequately_capitalized = ?                      ; Meets adequately capitalized
undercapitalized = ?                            ; Undercapitalized

{@call_report}

; ===================================================================================
; STRESS TEST
; ===================================================================================
; CCAR and DFAST stress testing.

{@stress_test}
; Required fields first
test_id = !:                                    ; Test identifier
test_type = !(
    ccar,                                       ; Fed CCAR
    dfast_company,                              ; Company-run DFAST
    dfast_supervisory,                          ; Supervisory DFAST
    internal                                    ; Internal capital stress
)
entity = !@reporting_entity                     ; Reporting institution
cycle_year = !##:(2000..2100)                   ; Test cycle year
as_of_date = !date                              ; Starting balance sheet date

; Horizons
planning_horizon_quarters = ##:(4..13)          ; Planning horizon (quarters)

; Status
status = (
    approved,                                   ; Fed approved
    completed,                                  ; Test completed
    in_progress,                                ; In progress
    objected,                                   ; Fed objected
    submitted                                   ; Submitted to Fed
)

; ---------------------------------------------------------------------------
; Scenarios
; ---------------------------------------------------------------------------
scenarios[] = @stress_scenario                  ; Test scenarios

{@stress_scenario}
scenario_id = !:                                ; Scenario identifier
scenario_type = !(
    adverse,                                    ; Adverse scenario
    baseline,                                   ; Baseline/expected
    severely_adverse                            ; Severely adverse
)
scenario_name = !:                              ; Scenario name
description = :                                 ; Scenario description

; Macroeconomic variables
{.macro}
real_gdp_growth[] = #                           ; Quarterly GDP growth
unemployment_rate[] = #:(0..30)                 ; Unemployment rate
house_price_index[] = #                         ; HPI change
cre_price_index[] = #                           ; CRE index change
dow_jones[] = #                                 ; DJIA level
vix[] = #                                       ; VIX index
treasury_3m[] = #.2                             ; 3M Treasury yield
treasury_10y[] = #.2                            ; 10Y Treasury yield
bbb_spread[] = #                                ; BBB spread

{@stress_scenario}

; ---------------------------------------------------------------------------
; Projected Results
; ---------------------------------------------------------------------------
{.projections}
quarters[] = @quarter_projection                ; Quarterly projections

{@stress_scenario}

{@quarter_projection}
quarter = !:                                    ; Quarter (YYYY-Q#)

; Income statement
net_interest_income = #$                        ; Projected NII
provision = #$                                  ; Provision expense
noninterest_income = #$                         ; Non-interest income
noninterest_expense = #$                        ; Non-interest expense
pre_tax_income = #$                             ; Pre-tax income
taxes = #$                                      ; Tax expense
net_income = #$                                 ; Net income

; Losses by portfolio
{.losses}
first_lien_residential = #$:(0..)               ; First lien mortgage losses
junior_lien = #$:(0..)                          ; Junior lien losses
commercial_industrial = #$:(0..)                ; C&I losses
cre = #$:(0..)                                  ; CRE losses
credit_card = #$:(0..)                          ; Credit card losses
other_consumer = #$:(0..)                       ; Other consumer losses
other = #$:(0..)                                ; Other losses
total_losses = #$:(0..)                         ; Total credit losses

{@quarter_projection}

; Capital
{.capital}
cet1 = #$:(0..)                                 ; CET1 capital
tier1 = #$:(0..)                                ; Tier 1 capital
total_capital = #$:(0..)                        ; Total capital
rwa = #$:(0..)                                  ; RWA
cet1_ratio = #.2                                ; CET1 ratio
tier1_ratio = #.2                               ; Tier 1 ratio
total_ratio = #.2                               ; Total capital ratio
leverage_ratio = #.2                            ; Leverage ratio
minimum_cet1_ratio = #.2                        ; Minimum CET1 in scenario

{@quarter_projection}

; ===================================================================================
; CAPITAL PLAN
; ===================================================================================
; Capital planning and distribution.

{@capital_plan}
; Required fields first
plan_id = !:                                    ; Plan identifier
entity = !@reporting_entity                     ; Institution
cycle_year = !##:(2000..2100)                   ; Planning cycle year

; Planned capital actions
{.distributions}
common_dividends[] = @planned_action            ; Planned dividends
share_repurchases[] = @planned_action           ; Planned buybacks
preferred_actions[] = @planned_action           ; Preferred actions
subordinated_debt[] = @planned_action           ; Sub debt actions

{@capital_plan}

; Capital targets
{.targets}
target_cet1_ratio = #.2                         ; Target CET1
target_tier1_ratio = #.2                        ; Target Tier 1
target_total_ratio = #.2                        ; Target Total
target_leverage_ratio = #.2                     ; Target Leverage
capital_buffer = #.2                            ; Management buffer

{@capital_plan}

{@planned_action}
action_id = !:                                  ; Action identifier
action_type = !(
    common_dividend,                            ; Common dividend
    preferred_dividend,                         ; Preferred dividend
    share_repurchase,                           ; Share buyback
    sub_debt_call,                              ; Sub debt redemption
    sub_debt_issue                              ; Sub debt issuance
)
quarter = !:                                    ; Planned quarter
amount = !#$:(0..)                              ; Planned amount
shares = ##:if action_type = share_repurchase   ; Shares to repurchase
per_share = #$:if action_type = common_dividend ; Per share amount

; ===================================================================================
; SUSPICIOUS ACTIVITY REPORT (SAR)
; ===================================================================================
; FinCEN SAR filing.

{@sar}
; Required fields first
sar_id = !:                                     ; Internal SAR ID
bsa_id = :                                      ; FinCEN BSA ID
filing_type = !(
    continuing,                                 ; Continuing activity
    correction,                                 ; Correction
    initial,                                    ; Initial filing
    joint                                       ; Joint SAR
)

; Filing institution
filer = !@reporting_entity                      ; Filing institution
branch_where_occurred = :                       ; Branch location

; Status
status = (
    draft,                                      ; Draft
    filed,                                      ; Filed with FinCEN
    in_review,                                  ; Management review
    rejected,                                   ; FinCEN rejected
    submitted                                   ; Submitted
)
filing_date = date                              ; Filing date
date_received_by_fincen = date                  ; FinCEN receipt date

; ---------------------------------------------------------------------------
; Suspicious Activity
; ---------------------------------------------------------------------------
{.activity}
date_activity_from = !date                      ; Activity start date
date_activity_to = !date                        ; Activity end date
amount_involved = #$:(0..)                      ; Amount of suspicious activity
activity_type[] = (
    bribery,
    check_fraud,
    counterfeit_instrument,
    credit_card_fraud,
    embezzlement,
    forgery,
    identity_theft,
    money_laundering,
    mortgage_fraud,
    other,
    structuring,
    tax_evasion,
    terrorist_financing,
    wire_fraud
)
narrative = !:                                  ; Narrative description

{@sar}

; ---------------------------------------------------------------------------
; Subject Information
; ---------------------------------------------------------------------------
subjects[] = @sar_subject                       ; Subjects of SAR

{@sar_subject}
subject_type = !(business, individual)          ; Subject type
name = !:                                       ; Subject name
aliases[] = :                                   ; Known aliases (AKAs, DBAs)
date_of_birth = *date                           ; DOB (individuals)
ssn_ein = *:                                    ; SSN or EIN (confidential)
addresses[] = @address                          ; Subject addresses (multiple known locations)
phones[] = *@phone                              ; Phones (multiple contact numbers)
emails[] = *@email                              ; Emails (multiple accounts)
ids[] = {@subject_id}                           ; Identification documents (multiple forms)
occupation = :                                  ; Occupation
employer = :                                    ; Employer

{@subject_id}
id_type = !(drivers_license, military_id, other, passport, state_id)
id_number = !*:                                 ; ID number
id_state_country = :(2..3)                      ; ID issuing jurisdiction

; Relationship to institution
{.relationship}
account_holder = ?                              ; Has account
account_numbers[] = *:                          ; Account numbers involved
relationship_type = (
    agent,
    customer,
    employee,
    no_relationship,
    officer,
    other
)

{@sar_subject}

; ===================================================================================
; CURRENCY TRANSACTION REPORT (CTR)
; ===================================================================================
; FinCEN CTR for cash transactions >$10,000.

{@ctr}
; Required fields first
ctr_id = !:                                     ; Internal CTR ID
bsa_id = :                                      ; FinCEN BSA ID
transaction_date = !date                        ; Transaction date
filing_type = !(correction, initial)            ; Filing type

; Filing institution
filer = !@reporting_entity                      ; Filing institution
branch = :                                      ; Branch where conducted

; Status
status = (draft, filed, in_review, rejected, submitted)
filing_date = date                              ; Filing date

; ---------------------------------------------------------------------------
; Transaction Details
; ---------------------------------------------------------------------------
{.transaction}
total_cash_in = #$:(0..)                        ; Total cash received
total_cash_out = #$:(0..)                       ; Total cash dispensed
total_amount = #$:(0..)                         ; Total cash amount

; Cash in breakdown
cash_in_currency = #$:(0..)                     ; Currency
cash_in_coin = #$:(0..)                         ; Coin
cash_in_check = #$:(0..)                        ; Cash from check cashing
foreign_cash_in = ?                             ; Foreign currency
foreign_country = :(2)                          ; Foreign currency country

; Cash out breakdown
cash_out_currency = #$:(0..)                    ; Currency dispensed
cash_out_coin = #$:(0..)                        ; Coin dispensed

{@ctr}

; Conductor
{.conductor}
same_as_customer = ?                            ; Conductor is the customer
name = :                                        ; Conductor name
date_of_birth = *date                           ; DOB
ssn = *:format ssn                              ; SSN
addresses[] = @address                          ; Addresses (multiple known locations)
ids[] = {@conductor_id}                         ; IDs (multiple forms presented)

{@conductor_id}
id_type = !(alien_registration, drivers_license, military_id, other, passport, state_id)
id_number = !*:                                 ; ID number
id_state_country = :(2..3)                      ; ID jurisdiction

{@ctr}

; Customer
customer = @ctr_customer                        ; Person/entity on whose behalf

{@ctr_customer}
customer_type = !(business, individual)         ; Customer type
name = !:                                       ; Customer name
dbas[] = :                                      ; DBA names (multiple trade names)
date_of_birth = *date                           ; DOB (individuals)
ssn_ein = *:                                    ; SSN or EIN
addresses[] = !@address                         ; Customer addresses (multiple locations)
phones[] = *@phone                              ; Phones (multiple contact numbers)
occupation = :                                  ; Occupation
employer = :                                    ; Employer
naics_code = :(6)                               ; NAICS (businesses)
account_numbers[] = *:                          ; Account numbers involved

; ===================================================================================
; OFAC SCREENING
; ===================================================================================
; OFAC sanctions screening and matches.

{@ofac_screening}
; Required fields first
screening_id = !:                               ; Screening ID
screening_type = !(
    batch,                                      ; Batch screening
    onboarding,                                 ; New customer
    ongoing,                                    ; Periodic rescreening
    transaction                                 ; Transaction screening
)
screening_date = !timestamp                     ; Screening timestamp

; Screened entity
{.screened}
entity_type = !(business, individual, vessel)   ; Entity type
name = !:                                       ; Name screened
alt_names[] = :                                 ; Alternate names
date_of_birth = *date                           ; DOB
addresses[] = @address                          ; Addresses (multiple known locations)
country = :(2)                                  ; Country

{@ofac_screening}

; Screening results
{.results}
lists_screened[] = (
    bis_denied,                                 ; BIS denied parties
    consolidated,                               ; Consolidated screening list
    eu_sanctions,                               ; EU sanctions
    ofac_sdn,                                   ; OFAC SDN
    un_sanctions,                               ; UN sanctions
    uk_sanctions                                ; UK sanctions
)
hits_found = ##:(0..)                           ; Number of potential hits
match_score = #:(0..100)                        ; Match score %
clear = ?                                       ; Cleared (no matches)

{@ofac_screening}

; Matches found
matches[] = @ofac_match                         ; Potential matches

{@ofac_match}
match_id = !:                                   ; Match identifier
lists[] = !:                                    ; Sanctions lists (can appear on multiple)
list_entry_id = !:                              ; List entry ID
matched_name = !:                               ; Matched name from list
match_score = !#:(0..100)                       ; Match score
match_type = (
    exact,                                      ; Exact match
    fuzzy,                                      ; Fuzzy match
    partial,                                    ; Partial match
    phonetic                                    ; Phonetic match
)

; List entry details
{.list_entry}
programs[] = :                                  ; Sanctions programs (IRAN, SDGT, etc.)
entry_type = (entity, individual, vessel)       ; Entry type
entry_date = date                               ; Date added to list
aliases[] = :                                   ; Known aliases
nationalities[] = :(2)                          ; Nationalities
addresses[] = @address                          ; Known addresses
ids[] = :                                       ; Known IDs

{@ofac_match}

; Disposition
{.disposition}
status = !(
    escalated,                                  ; Escalated to compliance
    false_positive,                             ; Cleared as false positive
    pending,                                    ; Pending review
    true_match                                  ; Confirmed match
)
reviewed_by = :                                 ; Reviewer
review_date = date                              ; Review date
disposition_reason = :                          ; Reason for disposition
action_taken = :                                ; Action taken

{@ofac_match}

; ===================================================================================
; CUSTOMER DUE DILIGENCE (CDD)
; ===================================================================================
; CDD and beneficial ownership.

{@cdd}
; Required fields first
cdd_id = !:                                     ; CDD record ID
customer_id = !:                                ; Customer reference
customer_type = !(
    business,
    government,
    individual,
    non_profit
)
cdd_level = !(
    enhanced,                                   ; Enhanced due diligence
    simplified,                                 ; Simplified DD
    standard                                    ; Standard CDD
)

; Status
status = (
    approved,                                   ; CDD approved
    expired,                                    ; CDD expired
    pending,                                    ; Pending review
    rejected,                                   ; CDD rejected
    under_review                                ; Under review
)
cdd_date = date                                 ; CDD completion date
next_review_date = date                         ; Next review date

; ---------------------------------------------------------------------------
; Identity Verification
; ---------------------------------------------------------------------------
{.identity}
verification_method = (
    documentary,                                ; Document-based
    non_documentary,                            ; Data/database
    combination                                 ; Both methods
)
documents_collected[] = (
    articles_of_incorporation,
    business_license,
    certificate_of_formation,
    drivers_license,
    partnership_agreement,
    passport,
    trust_agreement,
    utility_bill
)
verification_date = date                        ; Verification date
verified_by = :                                 ; Verifier
verification_status = (failed, passed, pending)

{@cdd}

; ---------------------------------------------------------------------------
; Risk Assessment
; ---------------------------------------------------------------------------
{.risk}
risk_rating = !(high, low, medium)              ; Customer risk rating
risk_score = ##:(0..100)                        ; Risk score
risk_factors[] = (
    cash_intensive,
    foreign_correspondent,
    high_risk_country,
    high_risk_industry,
    msr,
    pep,
    prior_sar,
    unusual_transactions
)
next_review_date = date                         ; Next review date

{@cdd}

; ---------------------------------------------------------------------------
; Beneficial Ownership (FinCEN BOI)
; ---------------------------------------------------------------------------
beneficial_owners[] = @beneficial_owner         ; Beneficial owners (>25%)

{@beneficial_owner}
owner_id = !:                                   ; Owner ID
name = !:                                       ; Owner name
ownership_pct = !#:(25..100)                    ; Ownership percentage
date_of_birth = !*date                          ; DOB (confidential)
address = !@address                             ; Address
ssn = *:format ssn                              ; SSN (US)
passports[] = {@owner_passport}                 ; Passports (dual/multi-citizenship)
ids[] = {@owner_id}                             ; IDs (multiple forms presented)
id_verified = ?                                 ; ID verified
verification_date = date                        ; Verification date

{@owner_passport}
passport_number = !*:                           ; Passport number
passport_country = !:(2)                        ; Passport issuing country

{@owner_id}
id_type = !(drivers_license, passport, state_id)
id_number = !*:                                 ; ID number
id_state_country = :(2..3)                      ; ID jurisdiction

; ===================================================================================
; HMDA LAR
; ===================================================================================
; Home Mortgage Disclosure Act Loan Application Register.

{@hmda_lar}
; Required fields first
lar_id = !:                                     ; Internal LAR ID
lei = !:format lei                        ; Lender LEI
uli = !:                                        ; Universal Loan Identifier
action_taken = !##:(1..8)                       ; Action taken code
action_date = !date                             ; Action taken date
report_year = !##:(2018..2100)                  ; Reporting year

; Application/Loan Info
{.loan}
loan_type = !##:(1..4)                          ; Loan type code
loan_purpose = !##:(1..32)                      ; Loan purpose code
preapproval = ##:(1..2)                         ; Preapproval requested
construction_method = ##:(1..2)                 ; Construction method
occupancy_type = ##:(1..3)                      ; Occupancy type
loan_amount = !#$:(0..)                         ; Loan amount ($000)
combined_ltv = #:(0..999)                       ; CLTV ratio
interest_rate = #.3                             ; Interest rate
rate_spread = #.3                               ; Rate spread
hoepa_status = ##:(1..3)                        ; HOEPA status
lien_status = ##:(1..2)                         ; Lien status
loan_term = ##                                  ; Loan term (months)
intro_rate_period = ##                          ; Intro rate period
balloon = ##:(1..2)                             ; Balloon payment
io_payment = ##:(1..2)                          ; Interest-only
negative_am = ##:(1..2)                         ; Negative amortization
other_non_am = ##:(1..2)                        ; Other non-amortizing
application_channel = ##:(1..3)                 ; Application channel
mortgage_type = (conventional, fha, fsa_rhs, va)

{@hmda_lar}

; Property Info
{.property}
address = @address                              ; Property address
county = :(5)                                   ; County FIPS
census_tract = :(11)                            ; Census tract
property_value = #$:(0..)                       ; Property value
manufactured_home_type = ##:(1..3)              ; Manufactured home type
manufactured_land_type = ##:(1..5)              ; Land property interest
multi_family_units = ##                         ; Multifamily units

{@hmda_lar}

; Applicant Demographics
{.applicant}
ethnicity_1 = ##:(1..5)                         ; Ethnicity 1
ethnicity_2 = ##:(1..5)                         ; Ethnicity 2
ethnicity_observed = ##:(1..3)                  ; Ethnicity observed
race_1 = ##:(1..5)                              ; Race 1
race_2 = ##:(1..5)                              ; Race 2
race_3 = ##:(1..5)                              ; Race 3
race_observed = ##:(1..3)                       ; Race observed
sex = ##:(1..4)                                 ; Sex
sex_observed = ##:(1..3)                        ; Sex observed
age = ##                                        ; Age
income = ##                                     ; Income ($000)
credit_score = ##:(300..850)                    ; Credit score
credit_model = ##:(1..10)                       ; Credit score model

{@hmda_lar}

; Co-Applicant Demographics (same structure)
{.co_applicant}
ethnicity_1 = ##:(1..5)
race_1 = ##:(1..5)
sex = ##:(1..6)
age = ##
credit_score = ##:(300..850)

{@hmda_lar}

; Denial Reasons (if action_taken in 3,7)
denial_reasons[] = ##:(1..10)                   ; Denial reason codes

; ===================================================================================
; CRA DATA
; ===================================================================================
; Community Reinvestment Act data collection.

{@cra_data}
; Required fields first
cra_id = !:                                     ; CRA record ID
entity = !@reporting_entity                     ; Reporting institution
report_year = !##:(2000..2100)                  ; Reporting year
loan_type = !(
    community_development,                      ; CD loan
    small_business,                             ; Small business loan
    small_farm                                  ; Small farm loan
)

; Loan details
loan_amount = !#$:(0..)                         ; Loan amount at origination
loan_amount_bucket = (
    bucket_1,                                   ; <=$100K
    bucket_2,                                   ; $100K-$250K
    bucket_3,                                   ; $250K-$1M
    bucket_4                                    ; >$1M
)
revenue_bucket = (
    bucket_1,                                   ; <=$1M revenue
    bucket_2                                    ; >$1M revenue
)

; Geography
census_tract = :(11)                            ; Census tract
msa_md = :(5)                                   ; MSA/MD code
state = :(2)                                    ; State code
county = :(3)                                   ; County code
income_level = (
    low,                                        ; <50% of area median
    moderate,                                   ; 50-79% of area median
    middle,                                     ; 80-119% of area median
    upper                                       ; >=120% of area median
)
distressed_underserved = ?                      ; Distressed/underserved tract

; Affiliate info
affiliate_flag = ?                              ; Affiliate loan
affiliate_id = :                                ; Affiliate ID

; ===================================================================================
; FAIR LENDING ANALYSIS
; ===================================================================================
; Fair lending statistical analysis.

{@fair_lending_analysis}
; Required fields first
analysis_id = !:                                ; Analysis ID
entity = !@reporting_entity                     ; Institution
analysis_type = !(
    comparative_file,                           ; Comparative file review
    focal_point,                                ; Focal point analysis
    regression,                                 ; Regression analysis
    threshold                                   ; Threshold/outlier
)
product = !:                                    ; Product analyzed
analysis_date = !date                           ; Analysis date
period_from = !date                             ; Analysis period start
period_to = !date                               ; Analysis period end

; Scope
{.scope}
total_applications = ##:(0..)                   ; Total applications
total_originations = ##:(0..)                   ; Total originations
geographic_scope = :                            ; Geographic scope
loan_amount_range = :                           ; Loan amount range

{@fair_lending_analysis}

; Statistical results
{.results}
control_group = :                               ; Control group definition
protected_classes[] = :                         ; Protected classes (race, sex, age, etc.)
disparate_treatment_identified = ?              ; DT findings
disparate_impact_identified = ?                 ; DI findings
statistical_significance = #.4                  ; P-value
practical_significance = ?                      ; Practical significance
odds_ratio = #.4                                ; Odds ratio
margin_difference = #.4                         ; Margin difference

{@fair_lending_analysis}

; Findings
{.findings}
finding_level = (high, low, medium, none)       ; Finding severity
description = :                                 ; Finding description
root_causes[] = :                               ; Root causes (multiple contributing factors)
corrective_actions[] = :                        ; Corrective actions (multiple remediation steps)
action_due_date = date                          ; Due date

{@fair_lending_analysis}


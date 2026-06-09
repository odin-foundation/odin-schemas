; ===================================================================================
; ODIN Trade Credit Insurance Schema
; ===================================================================================
; Trade credit insurance protecting businesses against non-payment of commercial
; debt including whole turnover, key account, single buyer, and export credit
; policies covering commercial and political risks.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.specialty.trade-credit"
version = "1.0.0"
title = "Trade Credit Insurance Schema"
description = "Coverage for accounts receivable and buyer non-payment"

{$derivation}
source[0].authority = "International Credit Insurance & Surety Association"
source[0].citation = "Trade Credit Insurance Standards"
source[0].url = "https://www.icisa.org/"

source[1].authority = "Export-Import Bank of the United States"
source[1].citation = "Export Credit Insurance Programs"
source[1].url = "https://www.exim.gov/"

source[2].authority = "Berne Union"
source[2].citation = "International Credit and Investment Insurers"
source[2].url = "https://www.berneunion.org/"

source[3].authority = "National Association of Credit Management"
source[3].citation = "Trade Credit Risk Management"
source[3].url = "https://nacm.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on ICISA standards and export credit agency practices"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial trade credit insurance schema"
changelog[0].rationale = "Specialty coverage for accounts receivable protection"

; ===================================================================================
; Insured Business
; ===================================================================================

{@tc_insured}
; Required fields first
annual_sales = #$:(0..)                      ; Annual sales on credit
business_name = :                            ; Business name
industry = (
    agriculture,                              ; Agriculture
    automotive,                               ; Auto parts
    chemicals,                                ; Chemicals
    construction,                             ; Construction materials
    consumer_goods,                           ; Consumer goods
    electronics,                              ; Electronics
    energy,                                   ; Energy sector
    food_beverage,                            ; Food/beverage
    healthcare,                               ; Healthcare/pharma
    industrial,                               ; Industrial goods
    metals,                                   ; Metals
    retail,                                   ; Retail
    services,                                 ; Services
    technology,                               ; Technology
    textiles,                                 ; Textiles
    transportation                            ; Transportation
)

; Optional fields
address = @address                            ; Business address
average_days_sales = ##                       ; Avg DSO
average_invoice = #$:(0..)                    ; Avg invoice size
buyer_concentration = #:(0..100)              ; Top 10 buyer %
buyer_count = ##                              ; Number of buyers
contact_email = *@email                       ; Contact email
contact_phone = *@phone                       ; Contact phone
credit_terms = :                              ; Standard terms
domestic_sales = #$:(0..)                     ; Domestic sales
export_sales = #$:(0..)                       ; Export sales
fein = *:                                     ; Tax ID
insured_id = :                                ; Internal identifier
total_receivables = #$:(0..)                  ; Total A/R
years_in_business = ##                        ; Years operating

; ===================================================================================
; Buyer Information
; ===================================================================================

{@tc_buyer}
; Required fields first
buyer_name = :                               ; Buyer name
credit_limit = #$:(0..)                      ; Credit limit requested

; Optional fields
buyer_id = :                                  ; Internal identifier
country = :                                   ; Buyer country
credit_rating = :                             ; Credit rating
duns_number = :                               ; D&B DUNS
industry = :                                  ; Buyer industry
payment_experience = (excellent, fair, good, poor)
payment_terms = :                             ; Payment terms
relationship_years = ##                       ; Years as customer
total_exposure = #$:(0..)                     ; Current exposure

; ===================================================================================
; Trade Credit Coverage
; ===================================================================================

{@tc_coverage}
; Required fields first
coverage_percentage = #:(0..100)             ; Indemnity percentage
policy_limit = #$:(0..)                      ; Maximum liability

; Coverage type
coverage_type = (
    catastrophe,                              ; Catastrophe/excess
    key_account,                              ; Key accounts only
    single_buyer,                             ; Single buyer
    top_up,                                   ; Top-up coverage
    whole_turnover                            ; All receivables
)

; Optional fields
aggregate_deductible = #$:(0..)               ; Annual aggregate ded
discretionary_limit = #$:(0..)                ; Discretionary CL
first_loss = #$:(0..)                         ; First loss amount
loss_minimum = #$:(0..)                       ; Loss minimum
maximum_credit_period = ##                    ; Max credit days
waiting_period_days = ##                      ; Waiting period

; ---------------------------------------------------------------------------
; Commercial Risk
; ---------------------------------------------------------------------------
{.commercial}
included = ?                                  ; Commercial risk coverage
buyer_insolvency = ?:if included = true       ; Insolvency
chapter_11 = ?:if included = true             ; Bankruptcy
deductible = #$:(0..):if included = true      ; Commercial deductible
liquidation = ?:if included = true            ; Liquidation
percentage = #:(0..100):if included = true    ; Indemnity %
protracted_default = ?:if included = true     ; Protracted default
waiting_period_days = ##:if included = true   ; Default wait period

{@tc_coverage}

; ---------------------------------------------------------------------------
; Political Risk
; ---------------------------------------------------------------------------
{.political}
included = ?                                  ; Political risk coverage
contract_frustration = ?:if included = true   ; Contract frustration
currency_inconvertibility = ?:if included = true  ; Currency risk
deductible = #$:(0..):if included = true      ; Political deductible
expropriation = ?:if included = true          ; Expropriation
license_cancellation = ?:if included = true   ; License cancellation
moratorium = ?:if included = true             ; Payment moratorium
percentage = #:(0..100):if included = true    ; Indemnity %
transfer_restriction = ?:if included = true   ; Transfer restriction
waiting_period_days = ##:if included = true   ; Political wait period
war = ?:if included = true                    ; War/civil war

{@tc_coverage}

; ---------------------------------------------------------------------------
; Pre-Shipment
; ---------------------------------------------------------------------------
{.pre_shipment}
included = ?                                  ; Pre-shipment coverage
contract_cancellation = ?:if included = true  ; Contract cancel
limit = #$:(0..):if included = true           ; Pre-ship limit
manufacturing_risk = ?:if included = true     ; Manufacturing risk
percentage = #:(0..100):if included = true    ; Indemnity %

{@tc_coverage}

; ===================================================================================
; Credit Limits
; ===================================================================================

{@tc_credit_limits}
; Credit limit structure
discretionary_limit = #$:(0..)                ; Seller discretion
named_buyer_limits[] = @tc_buyer              ; Named buyer limits
non_cancellable = ?                           ; Non-cancel limits
total_approved = #$:(0..)                     ; Total approved limits

; Limit management
automatic_renewal = ?                         ; Auto-renew limits
limit_review_period = (annual, monthly, quarterly, semi_annual)
online_portal = ?                             ; Online limit requests

; ===================================================================================
; Premium Details
; ===================================================================================

{@tc_premium}
; Required fields first
total_premium = #$:(0..)                     ; Total premium

; Premium structure
adjustment_premium = #$:(0..)                 ; End-of-period adjustment
commercial_premium = #$:(0..)                 ; Commercial risk
minimum_premium = #$:(0..)                    ; Minimum premium
political_premium = #$:(0..)                  ; Political risk
policy_fee = #$:(0..)                         ; Policy fee
pre_shipment_premium = #$:(0..)               ; Pre-shipment
provisional_premium = #$:(0..)                ; Provisional premium
taxes_and_fees = #$:(0..)                     ; Taxes/fees

; Rating basis
rate_per_sales = #                            ; Rate per $100 sales
rating_basis = (
    receivables,                              ; A/R balance
    sales,                                    ; Insured sales
    shipments                                 ; Shipments
)

; ---------------------------------------------------------------------------
; Rating Factors
; ---------------------------------------------------------------------------
{.rating}
buyer_concentration = #                       ; Concentration factor
country_factor = #                            ; Country risk
deductible_credit = #                         ; Deductible discount
industry_factor = #                           ; Industry risk
loss_experience = #                           ; Loss history
terms_factor = #                              ; Credit terms

{@tc_premium}

; ===================================================================================
; Claims
; ===================================================================================

{@tc_claim}
; Required fields first
buyer_name = :                               ; Defaulting buyer
claim_date = date                            ; Claim date
claim_type = (
    bankruptcy,                               ; Bankruptcy
    contract_frustration,                     ; Political frustration
    expropriation,                            ; Expropriation
    insolvency,                               ; Formal insolvency
    liquidation,                              ; Liquidation
    moratorium,                               ; Government moratorium
    protracted_default,                       ; Protracted default
    transfer_restriction,                     ; Transfer restriction
    war,                                      ; War/hostilities
    other                                     ; Other
)

; Optional fields
amount_claimed = #$:(0..)                     ; Amount claimed
amount_paid = #$:(0..)                        ; Amount paid
buyer_country = :                             ; Buyer country
claim_id = :                                  ; Claim ID
claim_status = (
    closed,
    denied,
    open,
    paid,
    partial_payment,
    recovery_pending,
    reserved
)
deductible_applied = #$:(0..)                 ; Deductible
description = :                               ; Description
indemnity_paid = #$:(0..)                     ; Indemnity amount
invoice_amount = #$:(0..)                     ; Original invoice
invoice_date = date                           ; Invoice date
recovery = #$:(0..)                           ; Recovery amount
reserve = #$:(0..)                            ; Reserve amount
shipment_date = date                          ; Shipment date

; ===================================================================================
; Trade Credit Policy
; ===================================================================================

{@trade_credit_policy}
; Required fields first
coverage = @tc_coverage                      ; Coverage terms
effective_date = date                        ; Policy effective date
expiration_date = date                       ; Policy expiration date
insured = @tc_insured                        ; Insured business
policy_number = :                            ; Policy number

; Invariants
:invariant expiration_date > effective_date

; Optional fields
agency = @agency                              ; Issuing agency
claims[] = @tc_claim                          ; Claims history
credit_limits = @tc_credit_limits             ; Credit limit structure
endorsements[] = :                            ; Policy endorsements
excluded_buyers[] = :                         ; Excluded buyers
excluded_countries[] = :                      ; Excluded countries
id = :                                        ; Internal identifier
loss_payee = :                                ; Loss payee (bank)
policy_form = (
    excess_of_loss,                           ; Excess/catastrophe
    key_accounts,                             ; Key accounts
    single_buyer,                             ; Single buyer
    whole_turnover                            ; Whole turnover
)
policy_status = (
    active,
    cancelled,
    expired,
    pending,
    suspended
)
premium = @tc_premium                         ; Premium details
producer = @producer                          ; Agent
underwriting = @underwriting_decision         ; Underwriting

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
approved_limits = #$:(0..)                    ; Approved credit limits
coverage_percentage = #:(0..100)              ; Indemnity %
insured_name = :                              ; Business name
insured_sales = #$:(0..)                      ; Annual insured sales
policy_limit = #$:(0..)                       ; Policy limit

{@trade_credit_policy}


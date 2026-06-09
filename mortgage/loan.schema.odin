; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Mortgage Loan Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Mortgage loan origination and terms including applications, underwriting,
; and loan products.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as mtg

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.mortgage.loan"
version = "1.0.0"
title = "Mortgage Loan Schema"
description = "Mortgage loan origination and terms"

{$derivation}
source[0].authority = "CFPB"
source[0].citation = "TILA-RESPA Integrated Disclosure Rule"
source[0].url = "https://www.consumerfinance.gov/rules-policy/regulations/1026/"

source[1].authority = "Fannie Mae"
source[1].citation = "Selling Guide - B2 Eligibility"
source[1].url = "https://singlefamily.fanniemae.com/originating-underwriting"

source[2].authority = "Freddie Mac"
source[2].citation = "Seller/Servicer Guide Chapter 4301"
source[2].url = "https://guide.freddiemac.com/app/guide/section/4301.1"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial mortgage loan schema"
changelog[0].rationale = "Loan structure derived from TRID, Fannie Mae, Freddie Mac requirements"

; ═══════════════════════════════════════════════════════════════════════════════
; LOAN APPLICATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per Fannie Mae Form 1003/Freddie Mac Form 65 structure

{@application}
; Identification
application_id = :                           ; Unique application identifier
loan_number = :                               ; Loan number (once assigned)

; Application dates
application_date = date                      ; Application received date
decision_date = date                          ; Underwriting decision date

; Application type
loan_purpose = (cash_out_refinance, construction, construction_permanent, home_improvement, purchase, rate_term_refinance)
loan_type = (conventional, fha, usda, va)

; Borrowers
borrowers[] = @mtg.borrower                   ; Borrower(s)

; Property
property = @mtg.property                     ; Subject property

; Loan request
{.request}
amount = #$:(0..)                            ; Requested loan amount
term_months = ##:(1..)                       ; Requested term in months
product_type = :(arm, fixed, hybrid)          ; Product type requested

{@application}

; Transaction details (for purchase)
{.transaction}
purchase_price = #$:(0..)                     ; Contract purchase price
down_payment = #$:(0..)                       ; Down payment amount
seller_concessions = #$:(0..)                 ; Seller credits/concessions

{@application}

; Refinance details (for refinance)
{.refinance}
current_lender = :                            ; Current lender name
current_balance = #$:(0..)                    ; Current loan balance
current_rate = #:(0..100)                     ; Current interest rate
cash_out_amount = #$:(0..)                    ; Cash out amount

{@application}

; Employment history
employment_history[] = @mtg.employment        ; Employment records

; Assets
assets[] = @mtg.asset                         ; Asset accounts

; Liabilities
liabilities[] = @mtg.liability                ; Liability accounts

; Real estate owned
real_estate_owned[] = @mtg.real_estate_owned  ; Other properties

; Credit
credit = @mtg.credit                          ; Credit information

; Declarations - Standard 1003 declarations
{.declarations}
outstanding_judgments = ?                     ; Any outstanding judgments
bankruptcy_7_years = ?                        ; Bankruptcy in last 7 years
foreclosure_7_years = ?                       ; Foreclosure in last 7 years
lawsuit_party = ?                             ; Party to lawsuit
loan_default = ?                              ; Defaulted on any loan
alimony_child_support_owed = ?                ; Owe alimony/child support
down_payment_borrowed = ?                     ; Down payment borrowed
co_maker_endorser = ?                         ; Co-maker or endorser on debt
us_citizen = ?                                ; US citizen
permanent_resident = ?                        ; Permanent resident alien
primary_residence = ?                         ; Will be primary residence
ownership_interest_3_years = ?                ; Owned property in last 3 years

{@application}

; ═══════════════════════════════════════════════════════════════════════════════
; LOAN TERMS
; ═══════════════════════════════════════════════════════════════════════════════
; Per TRID Loan Estimate/Closing Disclosure requirements

{@terms}
; Loan identification
loan_number = :                              ; Loan number

; Principal
loan_amount = #$:(0..)                       ; Loan principal amount

; Term
term_months = ##:(1..)                       ; Loan term in months
amortization_type = (fixed, arm, balloon, interest_only, negative_amortization)

; Interest rate - Per TRID Section L
{.interest_rate}
initial_rate = #.3:(0..100)                  ; Initial interest rate
rate_type = (adjustable, fixed)              ; Fixed or adjustable
fully_indexed_rate = #.3:(0..100)             ; Fully indexed rate (ARM)

{@terms}

; ARM terms (if adjustable) - TRID requirements
{.arm}
index = :                                     ; Index name (SOFR, etc.)
margin = #.3:(0..100)                         ; Margin over index
first_adjustment_months = ##:(1..)            ; Months to first adjustment
adjustment_period_months = ##:(1..)           ; Adjustment frequency
initial_cap = #.3:(0..100)                    ; Initial adjustment cap
periodic_cap = #.3:(0..100)                   ; Periodic adjustment cap
lifetime_cap = #.3:(0..100)                   ; Lifetime rate cap
floor = #.3:(0..100)                          ; Interest rate floor

{@terms}

; Payment - Per TRID Projected Payments
{.payment}
principal_interest = #$:(0..)                ; Monthly P&I
mortgage_insurance = #$:(0..)                 ; Monthly MI premium
escrow = #$:(0..)                             ; Monthly escrow
total_monthly = #$:(0..)                     ; Total monthly payment

{@terms}

; Balloon (if applicable)
{.balloon}
balloon = ?                                   ; Balloon payment
balloon_months = ##:(1..)                     ; Months to balloon
balloon_amount = #$:(0..)                     ; Balloon payment amount

{@terms}

; Prepayment penalty
{.prepayment}
penalty = ?                                   ; Prepayment penalty
penalty_term_months = ##:(1..)                ; Penalty period
max_penalty = #$:(0..)                        ; Maximum penalty amount

{@terms}

; Qualifying ratios - Per Fannie Mae B3-6
{.ratios}
front_end_dti = #.2:(0..100)                  ; Housing DTI ratio
back_end_dti = #.2:(0..100)                   ; Total DTI ratio
ltv = #.2:(0..200)                            ; Loan-to-value ratio
cltv = #.2:(0..200)                           ; Combined LTV ratio
hcltv = #.2:(0..200)                          ; HELOC CLTV ratio

{@terms}

; ═══════════════════════════════════════════════════════════════════════════════
; CLOSING COSTS
; ═══════════════════════════════════════════════════════════════════════════════
; Per TRID Closing Disclosure Section A-J structure

{@closing_costs}
; Loan costs (Section A-C)
{.loan_costs}
; Section A - Origination charges
origination_fee = #$:(0..)                    ; Origination fee
points = #$:(0..)                             ; Discount points
application_fee = #$:(0..)                    ; Application fee
underwriting_fee = #$:(0..)                   ; Underwriting fee
processing_fee = #$:(0..)                     ; Processing fee

; Section B - Services borrower cannot shop for
appraisal_fee = #$:(0..)                      ; Appraisal fee
credit_report_fee = #$:(0..)                  ; Credit report fee
flood_certification = #$:(0..)                ; Flood determination fee
tax_service_fee = #$:(0..)                    ; Tax service fee

; Section C - Services borrower can shop for
title_search = #$:(0..)                       ; Title search fee
title_insurance_lender = #$:(0..)             ; Lender's title insurance
title_insurance_owner = #$:(0..)              ; Owner's title insurance
settlement_fee = #$:(0..)                     ; Settlement/closing fee
survey_fee = #$:(0..)                         ; Survey fee

{@closing_costs}

; Other costs (Section D-I)
{.other_costs}
; Section D - Taxes and government fees
recording_fees = #$:(0..)                     ; Recording fees
transfer_taxes = #$:(0..)                     ; Transfer taxes

; Section E - Prepaids
homeowners_insurance_premium = #$:(0..)       ; Prepaid insurance
mortgage_insurance_premium = #$:(0..)         ; Prepaid MI
prepaid_interest = #$:(0..)                   ; Prepaid interest
property_taxes = #$:(0..)                     ; Prepaid taxes

; Section F - Initial escrow
escrow_homeowners_insurance = #$:(0..)        ; Escrow for insurance
escrow_mortgage_insurance = #$:(0..)          ; Escrow for MI
escrow_property_taxes = #$:(0..)              ; Escrow for taxes
escrow_aggregate_adjustment = #$              ; Aggregate adjustment

; Section G - Other
owners_title_insurance = #$:(0..)             ; Owner's title policy
other_costs[] = @fee_item                     ; Other fees

{@closing_costs}

; Totals - Per TRID Calculating Cash to Close
{.totals}
total_loan_costs = #$:(0..)                   ; Total Section A-C
total_other_costs = #$:(0..)                  ; Total Section D-I
total_closing_costs = #$:(0..)                ; Total costs
lender_credits = #$:(0..)                     ; Lender credits
seller_credits = #$:(0..)                     ; Seller credits
other_credits = #$:(0..)                      ; Other credits
cash_to_close = #$                            ; Cash to close (can be negative)

{@closing_costs}

{@fee_item}
description = :                              ; Fee description
amount = #$:(0..)                            ; Fee amount
paid_by = (borrower, lender, seller, third_party)
paid_at = (closing, outside_closing)          ; When paid

; ═══════════════════════════════════════════════════════════════════════════════
; MORTGAGE INSURANCE
; ═══════════════════════════════════════════════════════════════════════════════
; Per Fannie Mae B7-1 MI requirements

{@mortgage_insurance}
required = ?                                 ; MI required
type = (fha_mip, lender_paid, monthly, single_premium, split_premium, usda, va_funding_fee)
provider = :                                  ; MI company name
certificate_number = :                        ; MI certificate number

; Premium structure
{.premium}
upfront = #$:(0..)                            ; Upfront premium
upfront_financed = ?                          ; Upfront financed into loan
monthly = #$:(0..)                            ; Monthly premium
annual_rate = #.4:(0..100)                    ; Annual rate percentage

{@mortgage_insurance}

; Cancellation
{.cancellation}
cancellation_type = (automatic, borrower_requested, never)
cancellation_ltv = #.2:(0..100)               ; LTV for cancellation
cancellation_date = date                      ; Projected cancellation date

{@mortgage_insurance}

; ═══════════════════════════════════════════════════════════════════════════════
; GOVERNMENT LOAN
; ═══════════════════════════════════════════════════════════════════════════════
; FHA/VA/USDA specific requirements per HUD, VA, USDA handbooks

{@government_loan}
program = (fha, usda, va)                    ; Government program

; FHA specific - Per HUD Handbook 4000.1
{.fha}
case_number = :                               ; FHA case number
upfront_mip = #$:(0..)                        ; Upfront MIP amount
annual_mip_rate = #.4:(0..100)                ; Annual MIP rate
sponsor_id = :                                ; Sponsor ID (if applicable)

{@government_loan}

; VA specific - Per VA Lender's Handbook
{.va}
certificate_of_eligibility = ?                ; COE obtained
entitlement_amount = #$:(0..)                 ; Entitlement used
funding_fee = #$:(0..)                        ; VA funding fee
funding_fee_financed = ?                      ; Funding fee financed
exempt_from_funding_fee = ?                   ; Exempt from funding fee
loan_number = :                               ; VA loan number
service_type = (active_duty, national_guard, regular_military, reserves, surviving_spouse)

{@government_loan}

; USDA specific - Per USDA handbook
{.usda}
guarantee_fee = #$:(0..)                      ; Upfront guarantee fee
annual_fee_rate = #.4:(0..100)                ; Annual fee rate
eligible_area = ?                             ; Property in eligible area
income_eligible = ?                           ; Household income eligible

{@government_loan}

; ═══════════════════════════════════════════════════════════════════════════════
; UNDERWRITING DECISION
; ═══════════════════════════════════════════════════════════════════════════════
; Per Fannie Mae DU/Freddie Mac LP decisioning

{@underwriting}
; Decision
recommendation = (approve_eligible, approve_ineligible, caution, out_of_scope, refer, refer_with_caution)
decision_date = timestamp                    ; Decision timestamp

; Automated underwriting
{.automated}
system = (desktop_underwriter, loan_prospector, manual)
finding_id = :                                ; AUS finding ID
risk_assessment = :                           ; Risk assessment class

{@underwriting}

; Conditions
conditions[] = @underwriting_condition        ; Underwriting conditions

; Stipulations
stipulations[] = :                            ; Required stipulations

; Compensating factors
compensating_factors[] = :                    ; Compensating factors noted

{@underwriting_condition}
code = :                                     ; Condition code
description = :                              ; Condition description
category = (credit, employment, income, prior_to_closing, prior_to_docs, prior_to_funding, property)
status = (cleared, open, waived)              ; Condition status
cleared_date = date                           ; Date cleared
cleared_by = :                                ; Cleared by user


; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Government Taxation - Information Returns Schema
; ═══════════════════════════════════════════════════════════════════════════════
; IRS information reporting forms including W-2 wage statements, the 1099
; series (MISC, NEC, INT, DIV, B, R, S, K, G, C, A, Q, SA), 1098 mortgage
; and tuition statements, 1095 health coverage forms, and 5498 IRA
; contribution information.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.government.taxation.information"
version = "1.0.0"
title = "Information Returns"
description = "IRS W-2, 1099 series, 1098 series, 1095 series, and 5498"

{$derivation}
source[0].authority = "Internal Revenue Service"
source[0].citation = "General Instructions for Certain Information Returns (2024-2025)"
source[0].url = "https://www.irs.gov/forms-pubs/about-form-1099"
source[0].accessed = 2025-12-21

source[1].authority = "Internal Revenue Service"
source[1].citation = "Publication 1179 - Substitute Forms Specifications"
source[1].url = "https://www.irs.gov/pub/irs-pdf/p1179.pdf"
source[1].accessed = 2025-12-21

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial information returns schema"
changelog[0].rationale = "Comprehensive information reporting per IRS specifications"

; ═══════════════════════════════════════════════════════════════════════════════
; W-2 - Wage and Tax Statement
; ═══════════════════════════════════════════════════════════════════════════════

{@w2}
= @types.audit_info

tax_year = ##:(2020..)
corrected = ?
void = ?

; Employer Information
{.employer}
name = :
eins[] = :format ein                           ; EINs (multi-subsidiary, acquired entities)
address = @types.address

; Employee Information
{.employee}
ssn = *:format ssn
first_name = :
last_name = :
address = @types.address

{@w2}
; Wages and Compensation
wages_tips_compensation = #$:(0..)
federal_income_tax_withheld = #$:(0..)
social_security_wages = #$:(0..)
social_security_tax_withheld = #$:(0..)
medicare_wages_tips = #$:(0..)
medicare_tax_withheld = #$:(0..)
social_security_tips = #$:(0..)
allocated_tips = #$:(0..)
dependent_care_benefits = #$:(0..)
nonqualified_plans = #$:(0..)
retirement_plan = ?
third_party_sick_pay = ?
statutory_employee = ?
household_employee = ?

; State and Local Information
{.state[]}
state_code = :(2)
state_id = :
state_wages = #$:(0..)
state_income_tax = #$:(0..)

{@w2}
{.local[]}
locality_name = :
local_wages = #$:(0..)
local_income_tax = #$:(0..)

{@w2}
; Other Information
{.other[]}
box = :(2)                                           ; Box 12 codes (A-HH)
amount = #$

{@w2}
; ═══════════════════════════════════════════════════════════════════════════════
; 1099-MISC - Miscellaneous Information
; ═══════════════════════════════════════════════════════════════════════════════

{@form_1099_misc}
= @types.audit_info

tax_year = ##:(2020..)
corrected = ?
void = ?

; Payer Information
{.payer}
name = :
tin = :                                             ; TIN (EIN or SSN)
address = @types.address
phone = *@types.phone

; Recipient Information
{.recipient}
tin = *:                                            ; TIN (SSN, EIN, ITIN)
name = :
address = @types.address
account_number = *:

{@form_1099_misc}
; Amounts
rents = #$
royalties = #$
other_income = #$
federal_income_tax_withheld = #$:(0..)
fishing_boat_proceeds = #$
medical_health_care_payments = #$:(0..)
substitute_payments_dividends = #$
crop_insurance_proceeds = #$:(0..)
gross_proceeds_attorney = #$:(0..)
section_409a_deferrals = #$
section_409a_income = #$

; State Reporting (multi-state income)
{.state_reporting[]}
state = :(2)                                         ; State code
tax_withheld = #$:(0..)                              ; State tax withheld
payer_state_number = :                               ; Payer state ID
income = #$                                          ; State income

; ═══════════════════════════════════════════════════════════════════════════════
; 1099-NEC - Nonemployee Compensation
; ═══════════════════════════════════════════════════════════════════════════════

{@form_1099_nec}
= @types.audit_info

tax_year = ##:(2020..)
corrected = ?
void = ?

; Payer Information
{.payer}
name = :
tin = :
address = @types.address
phone = *@types.phone

; Recipient Information
{.recipient}
tin = *:
name = :
address = @types.address
account_number = *:

{@form_1099_nec}
; Amounts
nonemployee_compensation = #$:(0..)
federal_income_tax_withheld = #$:(0..)

; State Reporting (multi-state income)
{.state_reporting[]}
state = :(2)                                         ; State code
tax_withheld = #$:(0..)                              ; State tax withheld
payer_state_number = :                               ; Payer state ID
income = #$                                          ; State income

; ═══════════════════════════════════════════════════════════════════════════════
; 1099-INT - Interest Income
; ═══════════════════════════════════════════════════════════════════════════════

{@form_1099_int}
= @types.audit_info

tax_year = ##:(2020..)
corrected = ?

; Payer Information
{.payer}
name = :
tin = :
address = @types.address

; Recipient Information
{.recipient}
tin = *:
name = :
address = @types.address
account_number = *:

{@form_1099_int}
; Interest Amounts
interest_income = #$:(0..)
early_withdrawal_penalty = #$:(0..)
interest_us_savings_bonds = #$:(0..)
federal_income_tax_withheld = #$:(0..)
investment_expenses = #$:(0..)
foreign_tax_paid = #$:(0..)
foreign_countries[] = :                              ; Countries (multi-country investments)
tax_exempt_interest = #$:(0..)
specified_private_activity_bond_interest = #$:(0..)
market_discount = #$:(0..)
bond_premium = #$:(0..)
bond_premium_treasury = #$:(0..)
tax_exempt_oID = #$:(0..)

; State Reporting (multi-state income)
{.state_reporting[]}
state = :(2)                                         ; State code
tax_withheld = #$:(0..)                              ; State tax withheld
payer_state_number = :                               ; Payer state ID
income = #$                                          ; State income

; ═══════════════════════════════════════════════════════════════════════════════
; 1099-DIV - Dividends and Distributions
; ═══════════════════════════════════════════════════════════════════════════════

{@form_1099_div}
= @types.audit_info

tax_year = ##:(2020..)
corrected = ?

; Payer Information
{.payer}
name = :
tin = :
address = @types.address

; Recipient Information
{.recipient}
tin = *:
name = :
address = @types.address
account_number = *:

{@form_1099_div}
; Dividend Amounts
total_ordinary_dividends = #$:(0..)
qualified_dividends = #$:(0..)
total_capital_gain_distributions = #$:(0..)
unrecaptured_section_1250_gain = #$:(0..)
section_1202_gain = #$:(0..)
collectibles_28_percent_gain = #$:(0..)
nondividend_distributions = #$:(0..)
federal_income_tax_withheld = #$:(0..)
section_199a_dividends = #$:(0..)
investment_expenses = #$:(0..)
foreign_tax_paid = #$:(0..)
foreign_countries[] = :                              ; Countries (multi-country investments)
cash_liquidation_distributions = #$:(0..)
noncash_liquidation_distributions = #$:(0..)
exempt_interest_dividends = #$:(0..)
specified_private_activity_bond_dividends = #$:(0..)

; State Reporting (multi-state income)
{.state_reporting[]}
state = :(2)                                         ; State code
tax_withheld = #$:(0..)                              ; State tax withheld
payer_state_number = :                               ; Payer state ID
income = #$                                          ; State income

; ═══════════════════════════════════════════════════════════════════════════════
; 1099-B - Proceeds from Broker and Barter Exchange Transactions
; ═══════════════════════════════════════════════════════════════════════════════

{@form_1099_b}
= @types.audit_info

tax_year = ##:(2020..)
corrected = ?

; Payer Information
{.payer}
name = :
tin = :
address = @types.address
phone = *@types.phone

; Recipient Information
{.recipient}
tin = *:
name = :
address = @types.address
account_number = *:

{@form_1099_b}
; Transaction Details
{.transaction[]}
cusip_number = :
date_sold = date
date_acquired = date
proceeds = #$
cost_basis = #$
wash_sale_loss_disallowed = #$
realized_gain_loss = #$
federal_income_tax_withheld = #$:(0..)
description = :
short_term = ?
collectibles = ?
noncovered_security = ?
basis_reported_to_irs = ?
loss_not_allowed = ?
bartering = ?

{@form_1099_b}
; Aggregate Reporting
aggregate_profit_loss_contracts = #$
unrealized_profit_loss_open_contracts = #$

; ═══════════════════════════════════════════════════════════════════════════════
; 1099-R - Distributions From Pensions, Annuities, Retirement
; ═══════════════════════════════════════════════════════════════════════════════

{@form_1099_r}
= @types.audit_info

tax_year = ##:(2020..)
corrected = ?

; Payer Information
{.payer}
name = :
tin = :
address = @types.address
phone = *@types.phone

; Recipient Information
{.recipient}
tin = *:
name = :
address = @address

{@form_1099_r}
; Distribution Amounts
gross_distribution = #$:(0..)
taxable_amount = #$
taxable_amount_not_determined = ?
total_distribution = ?
capital_gain = #$:(0..)
federal_income_tax_withheld = #$:(0..)
employee_contributions = #$:(0..)
net_unrealized_appreciation = #$:(0..)
distribution_codes[] = :                            ; Codes 1-9, A-W (up to 2 per IRS)
ira_sep_simple = ?
first_year_roth_conversion = ##:(2000..2100)

; State Reporting (multi-state distributions)
{.state_reporting[]}
state = :(2)                                         ; State code
tax_withheld = #$:(0..)                              ; State tax withheld
payer_state_number = :                               ; Payer state ID
distribution = #$                                    ; State distribution

{@form_1099_r}
; Recipient Details
date_of_birth = *date

; ═══════════════════════════════════════════════════════════════════════════════
; Additional 1099 Forms (Simplified)
; ═══════════════════════════════════════════════════════════════════════════════

{@form_1099_s}
= @types.audit_info

tax_year = ##:(2020..)
gross_proceeds = #$:(0..)
buyer_address = @types.address
date_of_closing = date
property_address = @types.address

{@form_1099_k}
= @types.audit_info

tax_year = ##:(2020..)
gross_amount_payment_transactions = #$:(0..)
card_not_present_transactions = #$:(0..)
number_payment_transactions = ##:(0..)
federal_income_tax_withheld = #$:(0..)
merchant_category_codes[] = ##:(1000..9999)          ; MCCs (multiple business types)

{@form_1099_g}
= @types.audit_info

tax_year = ##:(2020..)
unemployment_compensation = #$:(0..)
state_local_income_tax_refunds = #$:(0..)
taxable_grants = #$:(0..)
federal_income_tax_withheld = #$:(0..)
rtaa_payments = #$:(0..)
agriculture_payments = #$:(0..)
market_gain = #$:(0..)

{@form_1099_c}
= @types.audit_info

tax_year = ##:(2020..)
date_canceled = date
amount_debt_canceled = #$:(0..)
interest_included = #$:(0..)
debt_descriptions[] = :                              ; Debt descriptions (multiple debts consolidated)
personally_liable = ?
identifiable_event_codes[] = :(1)                    ; Event codes A-H (multiple events)

{@form_1099_a}
= @types.audit_info

tax_year = ##:(2020..)
date_acquisition = date
balance_principal_outstanding = #$:(0..)
fair_market_value = #$:(0..)
property_descriptions[] = :                          ; Property descriptions (multiple parcels)
personally_liable = ?

{@form_1099_q}
= @types.audit_info

tax_year = ##:(2020..)
gross_distribution = #$:(0..)
earnings = #$:(0..)
basis = #$:(0..)
trustee_to_trustee_transfer = ?

{@form_1099_sa}
= @types.audit_info

tax_year = ##:(2020..)
gross_distribution = #$:(0..)
earnings = #$:(0..)
distribution_code = (1, 2, 3, 4, 5, 6)              ; HSA, Archer MSA, Medicare
fair_market_value = #$:(0..)

; ═══════════════════════════════════════════════════════════════════════════════
; 1098 Series - Mortgage Interest and Educational Expenses
; ═══════════════════════════════════════════════════════════════════════════════

{@form_1098}
= @types.audit_info

tax_year = ##:(2020..)
mortgage_interest_received = #$:(0..)
outstanding_mortgage_principal = #$:(0..)
mortgage_origination_date = date
refund_overpaid_interest = #$:(0..)
mortgage_insurance_premiums = #$:(0..)
points_paid = #$:(0..)
property_addresses[] = @types.address                ; Property addresses (multiple collateral)
number_properties_securing_mortgage = ##:(1..)
other_informations[] = :                             ; Other information items

{@form_1098_t}
= @types.audit_info

tax_year = ##:(2020..)
payments_qualified_tuition = #$:(0..)
adjustments_qualified_tuition = #$
scholarships_grants = #$:(0..)
adjustments_prior_year = #$
half_time_student = ?
graduate_student = ?
insurance_contract_reimbursement = #$:(0..)
box_1_includes_prior_year = ?

{@form_1098_e}
= @types.audit_info

tax_year = ##:(2020..)
student_loan_interests[] = {@student_loan_interest}  ; Interests by loan (multiple loans)

{@student_loan_interest}
loan_id = :                                          ; Loan identifier
interest_paid = #$:(0..)                            ; Interest paid on loan

; ═══════════════════════════════════════════════════════════════════════════════
; 1095 Series - Health Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@form_1095_a}
= @types.audit_info

tax_year = ##:(2020..)
marketplace_identifier = :
marketplace_assigned_policy_number = :
{.covered_individuals[]}
name = :
ssn = *:format ssn
covered_all_year = ?
coverage_start_date = date
coverage_termination_date = date
{@form_1095_a}
{.monthly_premium[]}
month = (January, February, March, April, May, June, July, August, September, October, November, December)
premium_amount = #$:(0..)
slcsp_premium_amount = #$:(0..)
advance_payment_premium_tax_credit = #$:(0..)
{@form_1095_a}

{@form_1095_b}
= @types.audit_info

tax_year = ##:(2020..)
responsible_individual_name = :
responsible_individual_ssn = *:format ssn
{.covered_individuals[]}
name = :
ssn = *:format ssn
covered_all_year = ?
{.coverage_months[]}
month = (January, February, March, April, May, June, July, August, September, October, November, December)
covered = ?
{@form_1095_b}

{@form_1095_c}
= @types.audit_info

tax_year = ##:(2020..)
employee_name = :
employee_ssn = *:format ssn
{.monthly_coverage[]}
month = (January, February, March, April, May, June, July, August, September, October, November, December)
offer_of_coverage_code = :(2)
employee_required_contribution = #$:(0..)
safe_harbor_code = :(2)
{@form_1095_c}

; ═══════════════════════════════════════════════════════════════════════════════
; 5498 - IRA Contribution Information
; ═══════════════════════════════════════════════════════════════════════════════

{@form_5498}
= @types.audit_info

tax_year = ##:(2020..)
participant_ssn = *:format ssn
ira_contributions = #$:(0..)
rollover_contributions = #$:(0..)
roth_ira_conversion = #$:(0..)
recharacterized_contributions = #$
fair_market_value = #$:(0..)
life_insurance_cost = #$:(0..)
ira_types[] = (roth, sep, simple, traditional)       ; IRA types (trustee may hold multiple)
rmd_date = date
postponed_contribution = #$:(0..)
repayments = #$:(0..)

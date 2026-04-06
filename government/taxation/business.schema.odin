; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Government Taxation - Business Returns Schema
; ═══════════════════════════════════════════════════════════════════════════════
; IRS business tax returns for corporations (Form 1120/1120-S), partnerships
; (Form 1065), tax-exempt organizations (Form 990), and estates/trusts
; (Form 1041). Includes Schedule K-1 pass-through income reporting and
; related supporting schedules.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.government.taxation.business"
version = "1.0.0"
title = "Business Tax Returns"
description = "IRS Forms 1120, 1120-S, 1065, 990, 1041, and Schedule K-1"

{$derivation}
source[0].authority = "Internal Revenue Service"
source[0].citation = "Business Tax Forms and Instructions (2024-2025)"
source[0].url = "https://www.irs.gov/businesses"
source[0].accessed = 2025-12-21

source[1].authority = "Internal Revenue Service"
source[1].citation = "26 USC Subtitle A - Income Taxes"
source[1].url = "https://www.law.cornell.edu/uscode/text/26/subtitle-A"
source[1].accessed = 2025-12-21

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial business taxation schema"
changelog[0].rationale = "Corporate, partnership, S-corp, nonprofit, and estate/trust tax returns"

; ═══════════════════════════════════════════════════════════════════════════════
; FORM 1120 - U.S. Corporation Income Tax Return
; ═══════════════════════════════════════════════════════════════════════════════

{@form_1120}
= @types.audit_info

tax_year = !##:(2020..)
calendar_year = ?
fiscal_year_begin = date:if calendar_year = false
fiscal_year_end = date:if calendar_year = false

; Corporation Information
corporation_name = !:
ein = !:format ein
business_address = !@address
date_incorporated = date
business_activity_codes[] = ##:(100000..999999)       ; NAICS codes (multi-segment operations)
total_assets = #$:(0..)

; Consolidated Return
consolidated_return = ?
parent_corporation = :if consolidated_return = true
parent_ein = :format ein:if consolidated_return = true

; Income
{.income}
gross_receipts = #$
returns_allowances = #$
cost_of_goods_sold = #$:(0..)
gross_profit = #$
dividends_domestic = #$
dividends_foreign = #$
interest = #$
gross_rents = #$
gross_royalties = #$
capital_gain_net = #$
other_income = #$
total_income = #$

{@form_1120}
; Deductions
{.deductions}
compensation_officers = #$:(0..)
salaries_wages = #$:(0..)
repairs_maintenance = #$:(0..)
bad_debts = #$
rents = #$
taxes_licenses = #$:(0..)
interest = #$
charitable_contributions = #$:(0..)
depreciation = #$:(0..)
depletion = #$:(0..)
advertising = #$:(0..)
pension_profit_sharing = #$:(0..)
employee_benefit_programs = #$:(0..)
domestic_production_activities = #$
other_deductions = #$
total_deductions = #$:(0..)

{@form_1120}
; Tax Computation
taxable_income = !#$
income_tax = !#$:(0..)
alternative_minimum_tax = #$
base_erosion_minimum_tax = #$
total_tax = #$:(0..)

; Tax Credits
{.credits}
foreign_tax_credits[] = {@foreign_tax_credit}       ; Foreign taxes (multi-jurisdiction)
general_business_credit = #$:(0..)
credit_prior_year_minimum_tax = #$:(0..)
total_credits = #$:(0..)

{@foreign_tax_credit}
country = !:(2..3)                                   ; Country code
amount = !#$:(0..)                                   ; Credit amount

{@form_1120}

{@form_1120}
; Tax Payments
{.payments}
estimated_tax_payments[] = {@tax_payment}           ; Quarterly estimated payments
withholdings[] = {@withholding_payment}             ; Multiple withholding sources
total_payments = #$:(0..)

{@tax_payment}
date = !date                                         ; Payment date
amount = !#$:(0..)                                   ; Payment amount

{@withholding_payment}
payer = :                                            ; Withholding agent
amount = !#$:(0..)                                   ; Withheld amount

{@form_1120}

{@form_1120}
; Refund or Amount Owed
overpayment = #$
refund = #$:(0..)
applied_to_next_year = #$:(0..)
amount_owed = #$

; ═══════════════════════════════════════════════════════════════════════════════
; FORM 1120-S - U.S. Income Tax Return for an S Corporation
; ═══════════════════════════════════════════════════════════════════════════════

{@form_1120s}
= @types.audit_info

tax_year = !##:(2020..)
calendar_year = ?
fiscal_year_begin = date:if calendar_year = false
fiscal_year_end = date:if calendar_year = false

; S Corporation Information
corporation_name = !:
ein = !:format ein
business_address = !@address
date_incorporated = date
s_election_effective_date = date
business_activity_codes[] = ##:(100000..999999)      ; NAICS codes (multi-segment operations)
total_assets = #$:(0..)
number_shareholders = !##:(1..100)

; Income
{.income}
gross_receipts = #$
returns_allowances = #$
cost_of_goods_sold = #$:(0..)
gross_profit = #$
net_gain_loss = #$
other_income = #$
total_income = #$

{@form_1120s}
; Deductions
{.deductions}
compensation_officers = #$:(0..)
salaries_wages = #$:(0..)
repairs_maintenance = #$:(0..)
bad_debts = #$
rents = #$
taxes_licenses = #$:(0..)
interest = #$
depreciation = #$:(0..)
depletion = #$:(0..)
advertising = #$:(0..)
pension_profit_sharing = #$:(0..)
employee_benefit_programs = #$:(0..)
other_deductions = #$
total_deductions = #$:(0..)

{@form_1120s}
; Ordinary Business Income
ordinary_business_income_loss = !#$

; Tax and Payments
{.tax}
built_in_gains_tax = #$
excess_net_passive_income_tax = #$
tax_deposits[] = {@tax_deposit}                      ; Tax deposits (multiple per year)
total_tax = #$

{@tax_deposit}
date = !date                                         ; Deposit date
amount = !#$:(0..)                                   ; Deposit amount

{@form_1120s}

{@form_1120s}
; Refund or Amount Owed
overpayment = #$
refund = #$:(0..)
amount_owed = #$

; ═══════════════════════════════════════════════════════════════════════════════
; FORM 1065 - U.S. Return of Partnership Income
; ═══════════════════════════════════════════════════════════════════════════════

{@form_1065}
= @types.audit_info

tax_year = !##:(2020..)
calendar_year = ?
fiscal_year_begin = date:if calendar_year = false
fiscal_year_end = date:if calendar_year = false

; Partnership Information
partnership_name = !:
ein = !:format ein
business_address = !@address
business_activity_codes[] = ##:(100000..999999)      ; NAICS codes (multi-segment operations)
number_partners = !##:(2..)
domestic_partnership = !?

; Accounting Method
accounting_method = (accrual, cash, other)

; Income
{.income}
gross_receipts = #$
returns_allowances = #$
cost_of_goods_sold = #$:(0..)
gross_profit = #$
ordinary_income_loss_other = #$
net_farm_profit_loss = #$
net_gain_loss = #$
other_income = #$
total_income = #$

{@form_1065}
; Deductions
{.deductions}
salaries_wages = #$:(0..)
guaranteed_payments[] = {@guaranteed_payment}        ; Payments to partners

{@guaranteed_payment}
partner_name = !:                                    ; Partner name
partner_ein_ssn = !*:                                ; Partner TIN
amount = !#$:(0..)                                   ; Payment amount
type = (capital, services)                           ; Payment type

{@form_1065}
repairs_maintenance = #$:(0..)
bad_debts = #$
rents = #$
taxes_licenses = #$:(0..)
interest = #$
depreciation = #$:(0..)
depletion = #$:(0..)
retirement_plans = #$:(0..)
employee_benefit_programs = #$:(0..)
other_deductions = #$
total_deductions = #$:(0..)

{@form_1065}
; Ordinary Business Income
ordinary_business_income_loss = !#$

; ═══════════════════════════════════════════════════════════════════════════════
; SCHEDULE K-1 - Partner's/Shareholder's Share of Income, Deductions, Credits
; ═══════════════════════════════════════════════════════════════════════════════

{@schedule_k1}
= @types.audit_info

tax_year = !##:(2020..)
entity_type = (form_1065_partnership, form_1120s_s_corp, form_1041_estate_trust)
final_k1 = ?
amended_k1 = ?

; Entity Information
entity_name = !:
entity_ein = !:format ein
entity_address = @address

; Partner/Shareholder/Beneficiary Information
{.recipient}
name = !:
ssn_ein = !*:                                        ; SSN or EIN
address = @address
domestic = ?
ownership_changes[] = {@k1_ownership}                ; Ownership history (mid-year changes)

{@k1_ownership}
effective_date = !date                               ; Date of change
profit_share = !#:(0..100)                           ; Profit percentage
loss_share = !#:(0..100)                             ; Loss percentage
capital_share = !#:(0..100)                          ; Capital percentage

{@schedule_k1}

{@schedule_k1}
; Income Items
{.income}
ordinary_business_income_loss = #$
net_rental_real_estate_income_loss = #$
other_net_rental_income_loss = #$
guaranteed_payments_services = #$
guaranteed_payments_capital = #$
interest_income = #$
ordinary_dividends = #$
qualified_dividends = #$:(0..)
royalties = #$
net_short_term_capital_gain_loss = #$
net_long_term_capital_gain_loss = #$
collectibles_28_percent_gain_loss = #$
unrecaptured_section_1250_gain = #$:(0..)
section_1231_gain_loss = #$
other_income = #$

{@schedule_k1}
; Deductions
{.deductions}
section_179_deduction = #$:(0..)
charitable_contributions = #$:(0..)
investment_interest_expense = #$
section_59e2_expenditures = #$
other_deductions = #$

{@schedule_k1}
; Credits
{.credits}
low_income_housing_credit = #$:(0..)
qualified_rehabilitation_credit = #$:(0..)
other_rental_credits = #$:(0..)
biofuel_producer_credit = #$:(0..)
work_opportunity_credit = #$:(0..)
other_credits = #$

{@schedule_k1}
; Self-Employment
{.self_employment}
net_earnings_loss_from_self_employment = #$

{@schedule_k1}
; Foreign Transactions
{.foreign}
foreign_activities[] = {@k1_foreign}                 ; Foreign income by country

{@k1_foreign}
country = !:                                         ; Country name
gross_income = #$                                    ; Gross income
taxes_paid = #$:(0..)                                ; Taxes paid
trading_gross_receipts = #$                          ; Trading receipts

{@schedule_k1}

{@schedule_k1}
; Alternative Minimum Tax
{.amt}
post_1986_depreciation_adjustment = #$
adjusted_gain_loss = #$
depletion = #$
other_amt_items = #$

{@schedule_k1}
; Capital Account
{.capital_account}
beginning_capital = #$
capital_contributed = #$:(0..)
current_year_net_income_loss = #$
other_increases = #$
withdrawals_distributions = #$
other_decreases = #$
ending_capital = #$

{@schedule_k1}
; Basis Limitations
at_risk_limitations = ?
excess_business_loss_limitation = ?

; ═══════════════════════════════════════════════════════════════════════════════
; FORM 990 - Return of Organization Exempt From Income Tax
; ═══════════════════════════════════════════════════════════════════════════════

{@form_990}
= @types.audit_info

tax_year = !##:(2020..)
calendar_year = ?
fiscal_year_begin = date:if calendar_year = false
fiscal_year_end = date:if calendar_year = false

; Organization Information
organization_name = !:
doing_business_as[] = :                              ; DBAs (multiple trade names)
ein = !:format ein
address = !@address
websites[] = :                                       ; Websites (multiple domains)
phones[] = :                                         ; Phone numbers (main, programs, donations)
group_return = ?
group_exemption_number = ##:if group_return = true

; Tax-Exempt Status
{.tax_exempt}
section_501c = !##:(1..29)                           ; 501(c)(3), etc.
other_sections[] = :                                 ; Other exemption sections
private_foundation = ?

{@form_990}
; Mission and Activities
mission_statements[] = !:                            ; Mission descriptions (multiple programs)
program_service_accomplishments[] = {@program_accomplishment}  ; Form 990 Part III

{@program_accomplishment}
description = !:                                     ; Program description
expenses = #$:(0..)                                  ; Program expenses
grants = #$:(0..)                                    ; Grants paid
revenue = #$:(0..)                                   ; Revenue generated

{@form_990}
total_program_service_expenses = #$:(0..)

; Revenue
{.revenue}
contributions_gifts_grants = #$
program_service_revenue = #$
membership_dues = #$
investment_income = #$
fundraising_events_gross = #$
fundraising_events_contributions = #$
fundraising_events_direct_expenses = #$:(0..)
gaming_gross_revenue = #$
gaming_direct_expenses = #$:(0..)
other_revenue = #$
total_revenue = #$

{@form_990}
; Expenses
{.expenses}
grants_domestic_organizations = #$:(0..)
grants_domestic_individuals = #$:(0..)
grants_foreign = #$:(0..)
benefits_paid_to_members = #$:(0..)
compensation_current_officers = #$:(0..)
compensation_other = #$:(0..)
pension_employee_benefits = #$:(0..)
professional_fundraising_fees = #$:(0..)
accounting_fees = #$:(0..)
legal_fees = #$:(0..)
advertising_promotion = #$:(0..)
office_expenses = #$:(0..)
information_technology = #$:(0..)
occupancy = #$:(0..)
travel = #$:(0..)
conferences_meetings = #$:(0..)
interest = #$
depreciation_depletion = #$:(0..)
other_expenses = #$
total_expenses = #$:(0..)

{@form_990}
; Net Assets
{.net_assets}
total_assets_beginning = #$
total_liabilities_beginning = #$
net_assets_beginning = #$
total_assets_ending = #$
total_liabilities_ending = #$
net_assets_ending = #$

{@form_990}
; Governance
{.governance}
number_voting_members = ##:(0..)
number_independent_voting_members = ##:(0..)
contemporaneous_documentation = ?

{@form_990}
; Officers, Directors, Trustees
{.officers[]}
name = !:
titles[] = !:                                        ; Titles (CEO, Board Chair, etc.)
average_hours_per_week = #:(0..168)
compensation = #$
other_compensation = #$

{@form_990}
; Public Support Test
public_support_percentage = #:(0..100)
investment_income_percentage = #:(0..100)

; ═══════════════════════════════════════════════════════════════════════════════
; FORM 1041 - U.S. Income Tax Return for Estates and Trusts
; ═══════════════════════════════════════════════════════════════════════════════

{@form_1041}
= @types.audit_info

tax_year = !##:(2020..)
calendar_year = ?
fiscal_year_begin = date:if calendar_year = false
fiscal_year_end = date:if calendar_year = false

; Estate or Trust Information
name = !:
ein = !:format ein
address = @address
entity_type = (bankruptcy_estate, complex_trust, decedent_estate, grantor_trust, qualified_disability_trust, simple_trust)
date_entity_created = date

; Decedent Information (for estates)
decedent_name = :if entity_type = decedent_estate
decedent_ssn = *:format ssn:if entity_type = decedent_estate
date_of_death = date:if entity_type = decedent_estate

; Income
{.income}
interest_income = #$
ordinary_dividends = #$
qualified_dividends = #$:(0..)
business_income_loss = #$
capital_gain_loss = #$
rents_royalties = #$
farm_income_loss = #$
ordinary_gain_loss = #$
other_income = #$
total_income = #$

{@form_1041}
; Deductions
{.deductions}
fiduciary_fees = #$:(0..)
charitable_deduction = #$:(0..)
attorney_accountant_fees = #$:(0..)
other_deductions = #$
exemption = #$:(0..)
total_deductions = #$:(0..)

{@form_1041}
; Tax and Payments
{.tax}
adjusted_total_income = #$
distributable_net_income = #$
income_distribution_deduction = #$:(0..)
estate_trust_income = #$
tentative_income_tax = #$:(0..)
alternative_minimum_tax = #$
total_tax = #$:(0..)

{@form_1041}
{.payments}
estimated_tax_payments[] = {@tax_payment}            ; Quarterly estimated payments
withholdings[] = {@withholding_payment}              ; Multiple withholding sources
total_payments = #$:(0..)

{@form_1041}
; Refund or Amount Owed
overpayment = #$
refund = #$:(0..)
amount_owed = #$

; Beneficiaries
{.beneficiaries[]}
name = !:
ssn_ein = !*:
domestic = ?

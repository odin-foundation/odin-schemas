; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Government Taxation - Individual Returns Schema
; ═══════════════════════════════════════════════════════════════════════════════
; IRS Form 1040 and supporting schedules (A through SE) for individual income
; tax returns. Covers wages, business income, capital gains, rental income,
; itemized deductions, self-employment tax, and Form 8949 capital asset
; dispositions.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.government.taxation.individual"
version = "1.0.0"
title = "Individual Income Tax Returns"
description = "IRS Form 1040 and supporting schedules"

{$derivation}
source[0].authority = "Internal Revenue Service"
source[0].citation = "Form 1040 and Instructions (2024-2025)"
source[0].url = "https://www.irs.gov/forms-pubs/about-form-1040"
source[0].accessed = 2025-12-21

source[1].authority = "Internal Revenue Service"
source[1].citation = "26 USC (Internal Revenue Code)"
source[1].url = "https://www.law.cornell.edu/uscode/text/26"
source[1].accessed = 2025-12-21

source[2].authority = "Internal Revenue Service"
source[2].citation = "26 CFR (Treasury Regulations)"
source[2].url = "https://www.ecfr.gov/current/title-26"
source[2].accessed = 2025-12-21

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial individual taxation schema for Form 1040 and schedules"
changelog[0].rationale = "Comprehensive coverage of individual tax forms per IRS specifications"

; ═══════════════════════════════════════════════════════════════════════════════
; FORM 1040 - U.S. Individual Income Tax Return
; ═══════════════════════════════════════════════════════════════════════════════

{@form_1040}
= @types.audit_info

; Filing Information
tax_year = !##:(2020..)                              ; Tax year
filing_status = (head_of_household, married_filing_jointly, married_filing_separately, qualifying_surviving_spouse, single)
amended_return = ?                                   ; Amended return indicator

; Taxpayer Information
{.taxpayer}
first_name = !:
last_name = !:
middle_initial = :
ssn = !*:format ssn                                  ; Social Security Number
date_of_birth = *date
occupations[] = :                                    ; Occupations (multiple jobs)
presidential_election_campaign_fund = ?

{@form_1040}
; Spouse Information (if married filing jointly)
{.spouse}
first_name = :if filing_status = married_filing_jointly
first_name = :if filing_status = qualifying_surviving_spouse
last_name = :if filing_status = married_filing_jointly
last_name = :if filing_status = qualifying_surviving_spouse
middle_initial = :
ssn = *:format ssn:if filing_status = married_filing_jointly
ssn = *:format ssn:if filing_status = qualifying_surviving_spouse
date_of_birth = *date
occupation = :
presidential_election_campaign_fund = ?

{@form_1040}
; Addresses
addresses[] = !@address                              ; Addresses (primary, during year)

; Dependents
{.dependents[]}
first_name = !:
last_name = !:
ssn = !*:format ssn
relationship = (child, other, parent, sibling, spouse)
qualifying_child_credit = ?
qualifying_other_dependent_credit = ?

{@form_1040}
; Digital Assets
digital_assets_received = ?                          ; Virtual currency question

; Standard or Itemized Deduction
someone_can_claim_as_dependent = ?
spouse_itemizes_separately = ?
deduction_type = (itemized, standard)
itemized_deductions_amount = #$:(0..):if deduction_type = itemized
standard_deduction_amount = #$:(0..)

; Income
{.income}
wages_salaries_tips = #$                             ; W-2 income
tax_exempt_interest = #$:(0..)
taxable_interest = #$                                ; Schedule B
qualified_dividends = #$:(0..)
ordinary_dividends = #$                              ; Schedule B
ira_distributions = #$
ira_taxable_amount = #$
pensions_annuities = #$
pensions_taxable_amount = #$
social_security_benefits = #$:(0..)
social_security_taxable_amount = #$
capital_gain_loss = #$                               ; Schedule D
schedule_1_additional_income = #$
total_income = #$

{@form_1040}
; Adjustments to Income (Schedule 1)
{.adjustments}
educator_expenses = #$:(0..)
business_expenses = #$
health_savings_account = #$:(0..)
moving_expenses = #$
deductible_self_employment_tax = #$
self_employed_sep_simple_qualified = #$
self_employed_health_insurance = #$
penalty_early_withdrawal = #$
alimony_paid = #$
ira_deduction = #$:(0..)
student_loan_interest = #$:(0..)
total_adjustments = #$

{@form_1040}
; Tax Computation
adjusted_gross_income = !#$
taxable_income = !#$
tax = !#$:(0..)

; Tax Credits
{.credits}
child_tax_credit = #$:(0..)
credit_for_other_dependents = #$:(0..)
education_credits = #$:(0..)
retirement_savings_credit = #$:(0..)
child_care_credit = #$:(0..)
residential_energy_credit = #$:(0..)
other_credits = #$
total_credits = #$:(0..)

{@form_1040}
; Other Taxes (Schedule 2)
{.other_taxes}
alternative_minimum_tax = #$
excess_advance_premium_tax_credit = #$
self_employment_tax = #$                             ; Schedule SE
household_employment_taxes = #$
additional_medicare_tax = #$
net_investment_income_tax = #$
total_other_taxes = #$

{@form_1040}
; Payments
{.payments}
federal_withholding = #$:(0..)
estimated_tax_payments = #$:(0..)
earned_income_credit = #$:(0..)
additional_child_tax_credit = #$:(0..)
american_opportunity_credit = #$:(0..)
recovery_rebate_credit = #$
other_payments = #$
total_payments = #$:(0..)

{@form_1040}
; Refund or Amount Owed
amount_overpaid = #$
refund_amount = #$:(0..)
applied_to_next_year = #$:(0..)
amount_owed = #$
estimated_tax_penalty = #$

; Direct Deposit (Form 8888 allows up to 3 accounts)
{.direct_deposits[]}
account_type = (checking, savings)                   ; Account type
routing_number = *:(9)                               ; Routing number
account_number = *:                                  ; Account number
amount = #$:(0..)                                    ; Amount to deposit

{@form_1040}
; Preparer Information (complex returns may have multiple)
{.preparers[]}
self_prepared = ?                                    ; Self-prepared flag
name = :                                             ; Preparer name
firm_name = :                                        ; Firm name
firm_ein = :format ein                          ; Firm EIN
ptin = :                                             ; Preparer TIN
phone = :                                            ; Phone
address = @address                                   ; Address

{@form_1040}
; Signature and Date
signed_date = date
spouse_signed_date = date:if filing_status = married_filing_jointly

; ═══════════════════════════════════════════════════════════════════════════════
; SCHEDULE A - Itemized Deductions
; ═══════════════════════════════════════════════════════════════════════════════

{@schedule_a}
= @types.audit_info

tax_year = !##:(2020..)

; Medical and Dental Expenses
{.medical}
medical_dental_expenses = #$:(0..)
agi_percentage = #:(0..100) #7.5                     ; 7.5% of AGI threshold
deductible_medical = #$

{@schedule_a}
; Taxes Paid (multiple state/local jurisdictions)
{.taxes[]}
jurisdiction = :                                     ; State/locality name
type = (income, personal_property, real_estate, sales)  ; Tax type
amount = #$:(0..)                                    ; Amount paid

{@schedule_a}
total_deductible_taxes = #$:(0..10000)               ; $10,000 SALT cap

{@schedule_a}
; Interest Paid (multiple mortgages common)
{.mortgages[]}
lender_name = :                                      ; Lender name
interest_paid = #$:(0..)                             ; Mortgage interest
points_paid = #$:(0..)                               ; Points paid
property_address = @address                          ; Property securing loan

{@schedule_a}
investment_interest = #$
total_deductible_interest = #$:(0..)

{@schedule_a}
; Gifts to Charity
{.charity}
cash_contributions = #$:(0..)
noncash_contributions = #$:(0..)
carryover_from_prior_year = #$
total_charitable_contributions = #$:(0..)

{@schedule_a}
; Casualty and Theft Losses (multiple events possible)
{.casualties[]}
description = :                                      ; Loss description
date = date                                          ; Date of loss
amount = #$                                          ; Loss amount

{@schedule_a}
; Other Itemized Deductions
{.other}
gambling_losses = #$:(0..)
other_deductions = #$

{@schedule_a}
; Total Itemized Deductions
total_itemized_deductions = !#$:(0..)

; ═══════════════════════════════════════════════════════════════════════════════
; SCHEDULE B - Interest and Ordinary Dividends
; ═══════════════════════════════════════════════════════════════════════════════

{@schedule_b}
= @types.audit_info

tax_year = !##:(2020..)

; Interest Income
{.interest_income[]}
payer_name = !:
amount = !#$

{@schedule_b}
total_interest = #$

; Dividend Income
{.dividend_income[]}
payer_name = !:
ordinary_dividends = !#$
qualified_dividends = #$:(0..)

{@schedule_b}
total_ordinary_dividends = #$
total_qualified_dividends = #$:(0..)

; Foreign Accounts and Trusts
foreign_account = ?
foreign_trust = ?
foreign_account_countries[] = :if foreign_account = true  ; Countries (accounts in multiple)
finCEN_114_filed = ?:if foreign_account = true

; ═══════════════════════════════════════════════════════════════════════════════
; SCHEDULE C - Profit or Loss from Business (Sole Proprietorship)
; ═══════════════════════════════════════════════════════════════════════════════

{@schedule_c}
= @types.audit_info

tax_year = !##:(2020..)

; Business Information
business_name = !:
business_address = @address
principal_business_codes[] = !##:(100000..999999)    ; NAICS codes (multi-line business)
ein = :format ein
business_activity = !:
material_participation = !?
started_business_year = ?

; Accounting Method
accounting_method = (accrual, cash, other)
accounting_method_other = :if accounting_method = other

; Income
{.income}
gross_receipts = #$
returns_allowances = #$
cost_of_goods_sold = #$:(0..)
gross_profit = #$
other_income = #$
gross_income = #$

{@schedule_c}
; Expenses
{.expenses}
advertising = #$:(0..)
car_truck_expenses = #$:(0..)
commissions_fees = #$:(0..)
contract_labor = #$:(0..)
depletion = #$:(0..)
depreciation = #$:(0..)
employee_benefit_programs = #$:(0..)
insurance = #$:(0..)
interest_mortgage = #$
interest_other = #$
legal_professional = #$:(0..)
office_expense = #$:(0..)
pension_profit_sharing = #$:(0..)
rent_lease_vehicles = #$:(0..)
rent_lease_property = #$:(0..)
repairs_maintenance = #$:(0..)
supplies = #$:(0..)
taxes_licenses = #$:(0..)
travel = #$:(0..)
meals = #$:(0..)
utilities = #$:(0..)
wages = #$:(0..)
other_expenses = #$
total_expenses = #$:(0..)

{@schedule_c}
; Net Profit or Loss
net_profit_loss = !#$
at_risk = ?

; Vehicle Information (multiple vehicles)
{.vehicles[]}
description = :                                      ; Vehicle description
vehicle_placed_in_service = date                     ; Date placed in service
business_miles = ##:(0..)                            ; Business miles
commuting_miles = ##:(0..)                           ; Commuting miles
other_miles = ##:(0..)                               ; Other miles
vehicle_available_offduty = ?                        ; Available for personal use
evidence_to_support = ?                              ; Evidence maintained
evidence_written = ?                                 ; Written records

{@schedule_c}
; Home Office
home_office_deduction = #$

; ═══════════════════════════════════════════════════════════════════════════════
; SCHEDULE D - Capital Gains and Losses
; ═══════════════════════════════════════════════════════════════════════════════

{@schedule_d}
= @types.audit_info

tax_year = !##:(2020..)

; Short-term Capital Gains and Losses
{.short_term}
transactions_from_8949_box_a = #$
transactions_from_8949_box_b = #$
transactions_from_8949_box_c = #$
short_term_gain_loss_installment_sales = #$
short_term_gain_loss_like_kind = #$
partnership_scorp_estate_trust = #$
short_term_capital_loss_carryover = #$
net_short_term_gain_loss = #$

{@schedule_d}
; Long-term Capital Gains and Losses
{.long_term}
transactions_from_8949_box_d = #$
transactions_from_8949_box_e = #$
transactions_from_8949_box_f = #$
gain_from_form_4797 = #$:(0..)
long_term_gain_loss_installment_sales = #$
long_term_gain_loss_like_kind = #$
partnership_scorp_estate_trust = #$
capital_gain_distributions = #$:(0..)
long_term_capital_loss_carryover = #$
net_long_term_gain_loss = #$

{@schedule_d}
; Summary
total_capital_gain_loss = !#$
unrecaptured_section_1250_gain = #$:(0..)
collectibles_28_percent_gain = #$:(0..)

; Tax Computation
{.tax_computation}
qualified_dividends = #$:(0..)
taxable_income = #$
capital_gains_tax_rate = #:(0..100)
capital_gains_tax = #$:(0..)

{@schedule_d}
; ═══════════════════════════════════════════════════════════════════════════════
; FORM 8949 - Sales and Other Dispositions of Capital Assets
; ═══════════════════════════════════════════════════════════════════════════════

{@form_8949}
= @types.audit_info

tax_year = !##:(2020..)
parts[] = (I, II)                                    ; Parts used (short-term, long-term)
boxes_checked[] = (A, B, C, D, E, F)                 ; Boxes checked (multiple per filing)

{.transactions[]}
description = !:                                     ; Property description
date_acquired = date                                 ; Acquisition date
date_sold = !date                                    ; Sale date
proceeds = !#$                                       ; Proceeds
cost_basis = !#$                                     ; Cost basis
adjustment_codes[] = :                               ; Adjustment codes (B, W, etc.)
adjustment_amount = #$                               ; Adjustment amount
gain_loss = !#$                                      ; Gain or loss
wash_sale = ?                                        ; Wash sale indicator

{@form_8949}
totals_proceeds = #$
totals_cost_basis = #$
totals_adjustments = #$
totals_gain_loss = #$

; ═══════════════════════════════════════════════════════════════════════════════
; SCHEDULE E - Supplemental Income and Loss
; ═══════════════════════════════════════════════════════════════════════════════

{@schedule_e}
= @types.audit_info

tax_year = !##:(2020..)

; Part I - Rental Real Estate and Royalty Income
{.rental_properties[]}
property_type = (multi_family, single_family, vacation_short_term)
address = @address
days_rented_fair_value = ##:(0..366)
days_personal_use = ##:(0..366)
qualified_joint_venture = ?

{.rental_properties[].income}
rents_received = #$
royalties_received = #$:(0..)

{.rental_properties[].expenses}
advertising = #$:(0..)
auto_travel = #$:(0..)
cleaning_maintenance = #$:(0..)
commissions = #$:(0..)
insurance = #$:(0..)
legal_professional = #$:(0..)
management_fees = #$:(0..)
mortgage_interest = #$
other_interest = #$
repairs = #$:(0..)
supplies = #$:(0..)
taxes = #$:(0..)
utilities = #$:(0..)
depreciation = #$:(0..)
other_expenses = #$

{.rental_properties[]}
total_expenses = #$:(0..)
net_income_loss = #$

{@schedule_e}
total_rental_income_loss = #$

; Part II - Partnerships and S Corporations
{.passthrough_entities[]}
entity_name = !:
entity_type = (partnership, s_corporation)
ein = !:format ein
foreign_entity = ?
passive_income_loss = #$
nonpassive_income_loss = #$
section_179_deduction = #$:(0..)

{@schedule_e}
total_passthrough_income_loss = #$

; Part III - Estates and Trusts
{.estates_trusts[]}
entity_name = !:
ein = !:format ein
passive_income_loss = #$
nonpassive_income_loss = #$

{@schedule_e}
total_estate_trust_income_loss = #$

; Summary
total_income_loss = !#$

; ═══════════════════════════════════════════════════════════════════════════════
; SCHEDULE F - Profit or Loss from Farming
; ═══════════════════════════════════════════════════════════════════════════════

{@schedule_f}
= @types.audit_info

tax_year = !##:(2020..)

; Farm Information
principal_products[] = !:                            ; Principal products (diversified farms)
employer_identification_number = :format ein
accounting_method = (accrual, cash, crop)
material_participation = !?

; Income
{.income}
sales_livestock_purchased = #$
sales_livestock_raised = #$
sales_produce = #$
cooperative_distributions = #$:(0..)
agricultural_payments = #$:(0..)
commodity_credit_loans = #$
crop_insurance_proceeds = #$
custom_hire_income = #$:(0..)
other_income = #$
gross_income = #$

{@schedule_f}
; Expenses
{.expenses}
car_truck = #$:(0..)
chemicals = #$:(0..)
conservation = #$:(0..)
custom_hire = #$:(0..)
depreciation = #$:(0..)
employee_benefit_programs = #$:(0..)
feed = #$:(0..)
fertilizers_lime = #$:(0..)
freight_trucking = #$:(0..)
gasoline_fuel_oil = #$:(0..)
insurance = #$:(0..)
interest_mortgage = #$
interest_other = #$
labor_hired = #$:(0..)
pension_profit_sharing = #$:(0..)
rent_lease_vehicles = #$:(0..)
rent_lease_land_animals = #$:(0..)
repairs_maintenance = #$:(0..)
seeds_plants = #$:(0..)
storage_warehousing = #$:(0..)
supplies = #$:(0..)
taxes = #$:(0..)
utilities = #$:(0..)
veterinary_breeding_medicine = #$:(0..)
other_expenses = #$
total_expenses = #$:(0..)

{@schedule_f}
; Net Farm Profit or Loss
net_farm_profit_loss = !#$

; ═══════════════════════════════════════════════════════════════════════════════
; SCHEDULE SE - Self-Employment Tax
; ═══════════════════════════════════════════════════════════════════════════════

{@schedule_se}
= @types.audit_info

tax_year = !##:(2020..)

; Taxpayer Information (joint returns may have multiple)
{.taxpayers[]}
name = !:                                            ; Taxpayer name
ssn = !*:format ssn                                  ; SSN

{@schedule_se}
; Self-Employment Income
{.income}
net_farm_profit_loss = #$                            ; Schedule F
net_business_profit_loss = #$                        ; Schedule C
combined_net_earnings = #$

{@schedule_se}
; Computation
{.computation}
maximum_earnings_subject_to_se_tax = #$:(0..)        ; Wage base limit
social_security_wages = #$:(0..)                     ; W-2 wages
earnings_subject_to_se_tax = #$
self_employment_tax_rate = #:(0..100) #15.3
self_employment_tax = !#$:(0..)
deductible_part_se_tax = #$:(0..)                    ; 50% deductible

{@schedule_se}
; Optional Methods
optional_method_used = ?
farm_optional_method = ?:if optional_method_used = true
nonfarm_optional_method = ?:if optional_method_used = true

; Minister Clergy Exception
exempt_form_4361 = ?

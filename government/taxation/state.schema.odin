; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Government Taxation - State Tax Returns Schema
; ═══════════════════════════════════════════════════════════════════════════════
; State-level tax forms including income tax returns, employer withholding,
; sales and use tax returns, and property tax assessments. Covers multi-state
; apportionment, nexus determination, and state-specific credits and
; deductions.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.government.taxation.state"
version = "1.0.0"
title = "State Tax Returns"
description = "State income, withholding, sales-use, and property taxes"

{$derivation}
source[0].authority = "Federation of Tax Administrators"
source[0].citation = "State Tax Forms and Filing Information"
source[0].url = "https://www.taxadmin.org/state-tax-forms"
source[0].accessed = 2025-12-21

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial state taxation schema"
changelog[0].rationale = "State-level tax return structures"

; ═══════════════════════════════════════════════════════════════════════════════
; STATE INCOME TAX RETURN
; ═══════════════════════════════════════════════════════════════════════════════

{@state_income_tax}
= @types.audit_info

tax_year = ##:(2020..)
states[] = :(2)                                     ; State codes (multi-state filers)
filing_status = (head_of_household, married_filing_jointly, married_filing_separately, single)
amended_return = ?

; Taxpayer Information
{.taxpayer}
first_name = :
last_name = :
ssn = *:format ssn
date_of_birth = *date

{@state_income_tax}
; Spouse (if married filing jointly)
{.spouse}
first_name = :if filing_status = married_filing_jointly
last_name = :if filing_status = married_filing_jointly
ssn = *:format ssn:if filing_status = married_filing_jointly
date_of_birth = *date

{@state_income_tax}
addresses[] = @address                              ; Addresses (primary, during year)

; Dependents
{.dependents[]}
name = :
ssn = *:format ssn
relationship = :
months_in_home = ##:(0..12)

{@state_income_tax}
; Income by Source (multiple employers, accounts, investments)
{.income_sources[]}
type = (business, capital_gains, dividends, interest, other, rental, wages_salaries)
source = :                                           ; Source name/description
amount = #$                                          ; Amount from this source

{@state_income_tax}
{.income}
federal_adjusted_gross_income = #$
total_state_income = #$

{@state_income_tax}
; State Adjustments (Additions/Subtractions)
{.additions}
other_state_tax_refunds = #$:(0..)
municipal_bond_interest_other_states = #$:(0..)
federal_income_tax_deduction = #$:(0..)
other_additions[] = {@state_adjustment}              ; Other additions (multiple sources)
total_additions = #$:(0..)

{@state_adjustment}
description = :                                     ; Adjustment description
amount = #$                                          ; Adjustment amount

{@state_income_tax}

{@state_income_tax}
{.subtractions}
us_government_interest = #$:(0..)
state_pension_exclusion = #$:(0..)
social_security_benefits = #$:(0..)
other_subtractions[] = @state_adjustment             ; Other subtractions (multiple types)
total_subtractions = #$:(0..)

{@state_income_tax}
; State Adjusted Gross Income
state_adjusted_gross_income = #$

; Deductions
deduction_type = (itemized, standard)
standard_deduction_amount = #$:(0..)
itemized_deductions_amount = #$:(0..):if deduction_type = itemized
total_deductions = #$:(0..)

; Exemptions
personal_exemption_count = ##:(0..)
personal_exemption_amount = #$:(0..)
dependent_exemption_count = ##:(0..)
dependent_exemption_amount = #$:(0..)
total_exemptions = #$:(0..)

; Taxable Income
state_taxable_income = #$

; Tax Computation
{.tax}
state_income_tax = #$:(0..)
use_tax = #$:(0..)
other_taxes[] = @state_adjustment                    ; Other taxes (multiple items)
total_tax = #$:(0..)

{@state_income_tax}
; Credits
{.credits}
earned_income_credit = #$:(0..)
child_care_credit = #$:(0..)
education_credit = #$:(0..)
property_tax_credit = #$:(0..)
other_credits[] = @state_adjustment                  ; Other credits (numerous state credits)
total_credits = #$:(0..)

{@state_income_tax}
; Payments (multiple employers/payers and quarterly payments)
{.withholdings[]}
payer = :                                            ; Employer/payer name
amount = #$:(0..)                                    ; Withholding amount

{@state_income_tax}
{.estimated_payments[]}
date = date                                          ; Payment date
amount = #$:(0..)                                    ; Payment amount

{@state_income_tax}
{.payments}
extension_payment = #$:(0..)
total_payments = #$:(0..)

{@state_income_tax}
; Refund or Amount Owed
amount_overpaid = #$
refund = #$:(0..)
applied_to_next_year = #$:(0..)
amount_owed = #$

; Direct Deposit (multiple accounts for split refunds)
{.direct_deposits[]}
account_type = (checking, savings)                   ; Account type
routing_number = *:(9)                               ; Routing number
account_number = *:                                  ; Account number
amount = #$:(0..)                                    ; Amount to deposit

{@state_income_tax}
; ═══════════════════════════════════════════════════════════════════════════════
; STATE WITHHOLDING
; ═══════════════════════════════════════════════════════════════════════════════

{@state_withholding}
= @types.audit_info

quarter = (Q1, Q2, Q3, Q4)
tax_year = ##:(2020..)
state = :(2)

; Employer Information
employer_name = :
state_id_number = :
federal_ein = :format ein
address = @address

; Withholding Summary
total_wages_paid = #$:(0..)
state_income_tax_withheld = #$:(0..)
number_employees = ##:(0..)

; Payments Made
total_payments = #$:(0..)
balance_due = #$
overpayment = #$

; ═══════════════════════════════════════════════════════════════════════════════
; SALES AND USE TAX RETURN
; ═══════════════════════════════════════════════════════════════════════════════

{@sales_use_tax}
= @types.audit_info

filing_period = date
state = :(2)
permit_number = :

; Business Information
business_names[] = :                                ; Legal names (name changes, multiple locations)
dbas[] = :                                           ; DBAs (multiple trade names)
address = @address
business_types[] = :                                 ; Business types (multiple categories)

; Sales
{.sales}
gross_receipts = #$:(0..)
exempt_sales[] = {@exempt_sale}                      ; Exempt sales by category
taxable_sales = #$:(0..)
sales_tax_collected = #$:(0..)

{@exempt_sale}
category = :                                         ; Exemption category
amount = #$:(0..)                                    ; Exempt amount

{@sales_use_tax}

{@sales_use_tax}
; Use Tax
{.use_tax}
purchases_no_tax_paid = #$:(0..)
use_tax_due = #$:(0..)

{@sales_use_tax}
; Total Tax Due
total_tax_due = #$:(0..)

; Credits and Adjustments
{.credits}
bad_debt_deductions[] = {@bad_debt}                  ; Bad debt deductions (multiple claims)
timely_filing_discount = #$:(0..)
other_credits[] = @state_adjustment                  ; Other credits (multiple types)
total_credits = #$:(0..)

{@bad_debt}
customer = :                                         ; Customer name
amount = #$:(0..)                                    ; Bad debt amount
date = date                                          ; Date written off

{@sales_use_tax}

{@sales_use_tax}
; Net Tax Due
net_tax_due = #$:(0..)
penalty = #$:(0..)
interest = #$:(0..)
total_amount_due = #$

; ═══════════════════════════════════════════════════════════════════════════════
; PROPERTY TAX ASSESSMENT
; ═══════════════════════════════════════════════════════════════════════════════

{@property_tax_assessment}
= @types.audit_info

tax_year = ##:(2020..)
state = :(2)
county = :
municipality = :
parcel_number = :

; Property Information
{.property}
address = @address
property_type = (agricultural, commercial, industrial, residential, vacant_land)
legal_descriptions[] = :                             ; Legal descriptions (multiple parcels)
lot_size_acres = #:(0..)
building_square_feet = ##:(0..)
year_built = ##:(1700..2100)

{@property_tax_assessment}
; Owner Information (multiple owners for joint ownership)
{.owners[]}
name = :                                            ; Owner name
mailing_address = @address                           ; Owner address
ownership_percentage = #:(0..100)                    ; Ownership percentage

{@property_tax_assessment}
; Assessment Values
{.assessment}
land_value = #$:(0..)
improvement_value = #$:(0..)
total_assessed_value = #$:(0..)
assessment_ratio = #:(0..100)
taxable_value = #$:(0..)

{@property_tax_assessment}
; Exemptions
{.exemptions}
homestead_exemption = #$:(0..)
senior_exemption = #$:(0..)
veteran_exemption = #$:(0..)
disability_exemption = #$:(0..)
other_exemptions[] = @state_adjustment               ; Other exemptions (multiple miscellaneous)
total_exemptions = #$:(0..)

{@property_tax_assessment}
; Tax Calculation
{.tax}
net_taxable_value = #$:(0..)
{.jurisdictions[]}
jurisdiction_name = :
mill_rate = #:(0..)
tax_amount = #$:(0..)
{@property_tax_assessment}
total_property_tax = #$:(0..)

; Due Dates and Payments
{.installments[]}
installment_number = ##:(1..12)
due_date = date
amount_due = #$:(0..)
amount_paid = #$:(0..)
payment_date = date

{@property_tax_assessment}
; Assessment Appeals (multiple appeals possible)
{.appeals[]}
filed_date = date                                    ; Appeal filing date
status = (denied, granted, pending)                  ; Appeal status
contested_value = #$:(0..)                           ; Value being contested
requested_value = #$:(0..)                           ; Requested value
resolution_date = date                               ; Resolution date
resolution_notes = :                                 ; Resolution notes

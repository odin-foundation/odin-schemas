; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Government Taxation - Employment Tax Returns Schema
; ═══════════════════════════════════════════════════════════════════════════════
; IRS employment tax forms for payroll withholding and unemployment taxes
; including Form 941 (quarterly), Form 940 (FUTA), Form 944 (small employer
; annual), and Form 943 (agricultural). Covers deposit schedules, tax
; liability calculations, and reconciliation.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.government.taxation.employment"
version = "1.0.0"
title = "Employment Tax Returns"
description = "IRS Forms 941, 940, 944, 943 for employment taxes"

{$derivation}
source[0].authority = "Internal Revenue Service"
source[0].citation = "Employment Tax Forms and Instructions (2024-2025)"
source[0].url = "https://www.irs.gov/businesses/e-file-employment-tax-forms"
source[0].accessed = 2025-12-21

source[1].authority = "Internal Revenue Service"
source[1].citation = "26 USC Chapter 21 - Federal Insurance Contributions Act (FICA)"
source[1].url = "https://www.law.cornell.edu/uscode/text/26/subtitle-C/chapter-21"
source[1].accessed = 2025-12-21

source[2].authority = "Internal Revenue Service"
source[2].citation = "26 USC Chapter 23 - Federal Unemployment Tax Act (FUTA)"
source[2].url = "https://www.law.cornell.edu/uscode/text/26/subtitle-C/chapter-23"
source[2].accessed = 2025-12-21

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial employment taxation schema"
changelog[0].rationale = "Quarterly and annual employment tax reporting requirements"

; ═══════════════════════════════════════════════════════════════════════════════
; FORM 941 - Employer's Quarterly Federal Tax Return
; ═══════════════════════════════════════════════════════════════════════════════

{@form_941}
= @types.audit_info

; Filing Period
tax_year = !##:(2020..)
quarter = (Q1, Q2, Q3, Q4)
quarter_begin_date = !date
quarter_end_date = !date

; Employer Information
employer_names[] = !:                                ; Legal names (name changes over time)
trade_names[] = :                                    ; DBAs (multiple trade names)
ein = !:format ein
addresses[] = !@types.address                        ; Business locations

; Business Type
business_closed = ?
business_closed_date = date:if business_closed = true
seasonal_employer = ?
final_return = ?

; Employees
number_employees = !##:(0..)

; Wages and Taxes
{.wages}
wages_tips_compensation = !#$:(0..)
federal_income_tax_withheld = !#$:(0..)
taxable_social_security_wages = #$:(0..)
social_security_tax = #$:(0..)
taxable_social_security_tips = #$:(0..)
social_security_tax_on_tips = #$:(0..)
taxable_medicare_wages_tips = #$:(0..)
medicare_tax = #$:(0..)
additional_medicare_withholding = #$:(0..)

{@form_941}
; Tax Adjustments
{.adjustments[]}
type = (fractions_of_cents, group_term_life, other, sick_pay)  ; Adjustment type
amount = #$                                          ; Adjustment amount
description = :                                      ; Adjustment detail

{@form_941}
total_adjustments = #$

{@form_941}
; Credits
{.credits[]}
type = (cobra_assistance, covid_family_leave, covid_sick_leave, other, small_business_payroll_tax)
amount = #$:(0..)                                    ; Credit amount
description = :                                      ; Credit detail

{@form_941}
total_credits = #$:(0..)

{@form_941}
; Tax Computation
total_taxes_after_adjustments_credits = !#$
total_deposits = #$:(0..)
balance_due = #$
overpayment = #$
applied_to_next_return = #$:(0..)
refund = #$:(0..)

; Deposit Schedule
deposit_schedule = (monthly, semiweekly)

; Monthly Deposits (if monthly schedule)
{.monthly_liability}
month1_liability = #$:(0..):if deposit_schedule = monthly
month2_liability = #$:(0..):if deposit_schedule = monthly
month3_liability = #$:(0..):if deposit_schedule = monthly
total_liability = #$:(0..)

{@form_941}
; Third Party Designees
{.designees[]}
name = :                                             ; Designee name
phone = *@types.phone                                ; Designee phone
pin = *:(5)                                          ; Designee PIN

{@form_941}
; Signatories
{.signatories[]}
name = :                                             ; Signatory name
title = :                                            ; Signatory title
signed_date = date                                   ; Signature date
phone = *@types.phone                                ; Contact phone

; ═══════════════════════════════════════════════════════════════════════════════
; FORM 940 - Employer's Annual Federal Unemployment (FUTA) Tax Return
; ═══════════════════════════════════════════════════════════════════════════════

{@form_940}
= @types.audit_info

; Tax Year
tax_year = !##:(2020..)

; Employer Information
employer_names[] = !:                                ; Legal names (name changes over time)
trade_names[] = :                                    ; DBAs (multiple trade names)
ein = !:format ein
addresses[] = !@types.address                        ; Business locations

; Business Type
amended_return = ?
successor_employer = ?
no_payments_to_employees = ?
final_return = ?

; FUTA Tax Status
{.futa_status}
paid_wages_in_state[] = :(2)                         ; State codes
multi_state_employer = ?
credit_reduction_states[] = :(2)

{@form_940}
; Wages
{.wages}
total_payments = !#$:(0..)
exempt_payments[] = {@exempt_payment}                ; Exempt payments by category

{@exempt_payment}
type = (dependent_care, fringe_benefits, group_term_life, health_insurance, meals_lodging, other, retirement)
amount = #$:(0..)                                    ; Exempt amount

{@form_940}
excess_7000 = #$:(0..)
subtotal = #$:(0..)
total_taxable_futa_wages = !#$:(0..)

{@form_940}
; FUTA Tax Computation
{.tax}
futa_tax_before_adjustments = !#$:(0..)
futa_tax_rate = #:(0..100) #6.0
maximum_credit = #$:(0..)
computation_credit = (schedule_a, worksheets)
credit_reduction = #$
total_futa_tax = !#$:(0..)

{@form_940}
; Deposits and Payments
total_futa_tax_deposited = #$:(0..)
balance_due = #$
overpayment = #$
applied_to_next_return = #$:(0..)
refund = #$:(0..)

; Quarterly FUTA Liability
{.quarterly_liability}
q1_liability = #$:(0..)
q2_liability = #$:(0..)
q3_liability = #$:(0..)
q4_liability = #$:(0..)
total_liability = #$:(0..)

{@form_940}
; Third Party Designees
{.designees[]}
name = :                                             ; Designee name
phone = *@types.phone                                ; Designee phone
pin = *:(5)                                          ; Designee PIN

{@form_940}
; Signatories
{.signatories[]}
name = :                                             ; Signatory name
title = :                                            ; Signatory title
signed_date = date                                   ; Signature date
phone = *@types.phone                                ; Contact phone

{@form_940}
; ═══════════════════════════════════════════════════════════════════════════════
; FORM 944 - Employer's Annual Federal Tax Return
; ═══════════════════════════════════════════════════════════════════════════════

{@form_944}
= @types.audit_info

; Tax Year
tax_year = !##:(2020..)

; Employer Information
employer_names[] = !:                                ; Legal names (name changes over time)
trade_names[] = :                                    ; DBAs (multiple trade names)
ein = !:format ein
addresses[] = !@types.address                        ; Business locations

; Business Status
business_closed = ?
business_closed_date = date:if business_closed = true
seasonal_employer = ?
final_return = ?

; Wages and Taxes
{.wages}
wages_tips_compensation = !#$:(0..)
federal_income_tax_withheld = !#$:(0..)
taxable_social_security_wages = #$:(0..)
social_security_tax = #$:(0..)
taxable_social_security_tips = #$:(0..)
social_security_tax_on_tips = #$:(0..)
taxable_medicare_wages_tips = #$:(0..)
medicare_tax = #$:(0..)
additional_medicare_withholding = #$:(0..)

{@form_944}
; Tax Computation
total_taxes_before_adjustments = #$:(0..)
current_year_adjustments = #$
total_taxes_after_adjustments = #$:(0..)
qualified_small_business_payroll_tax_credit = #$:(0..)
total_taxes_after_credits = !#$:(0..)

; Deposits and Payments
total_deposits = #$:(0..)
balance_due = #$
overpayment = #$
applied_to_next_return = #$:(0..)
refund = #$:(0..)

; Monthly Tax Liability (if over $2,500)
{.monthly_liability[]}
month = (January, February, March, April, May, June, July, August, September, October, November, December)
tax_liability = #$:(0..)

{@form_944}
total_liability = #$:(0..)

; Third Party Designees
{.designees[]}
name = :                                             ; Designee name
phone = *@types.phone                                ; Designee phone
pin = *:(5)                                          ; Designee PIN

{@form_944}
; Signatories
{.signatories[]}
name = :                                             ; Signatory name
title = :                                            ; Signatory title
signed_date = date                                   ; Signature date
phone = *@types.phone                                ; Contact phone

{@form_944}
; ═══════════════════════════════════════════════════════════════════════════════
; FORM 943 - Employer's Annual Tax Return for Agricultural Employees
; ═══════════════════════════════════════════════════════════════════════════════

{@form_943}
= @types.audit_info

; Tax Year
tax_year = !##:(2020..)

; Employer Information
employer_names[] = !:                                ; Legal names (name changes over time)
trade_names[] = :                                    ; DBAs (multiple trade names)
ein = !:format ein
addresses[] = !@types.address                        ; Business locations

; Business Status
business_closed = ?
business_closed_date = date:if business_closed = true
seasonal_employer = ?
final_return = ?

; Wages and Taxes
{.wages}
wages_tips_compensation = !#$:(0..)
federal_income_tax_withheld = !#$:(0..)
taxable_social_security_wages = #$:(0..)
social_security_tax = #$:(0..)
taxable_medicare_wages_tips = #$:(0..)
medicare_tax = #$:(0..)
additional_medicare_withholding = #$:(0..)

{@form_943}
; Tax Computation
total_taxes_before_adjustments = #$:(0..)
current_year_adjustments = #$
total_taxes_after_adjustments = #$:(0..)
qualified_small_business_payroll_tax_credit = #$:(0..)
total_taxes_after_credits = !#$:(0..)

; Deposits and Payments
total_deposits = #$:(0..)
balance_due = #$
overpayment = #$
applied_to_next_return = #$:(0..)
refund = #$:(0..)

; Deposit Schedule
deposit_schedule = (monthly, semiweekly)

; Monthly Tax Liability
{.monthly_liability}
month1_liability = #$:(0..):if deposit_schedule = monthly
month2_liability = #$:(0..):if deposit_schedule = monthly
month3_liability = #$:(0..):if deposit_schedule = monthly
month4_liability = #$:(0..):if deposit_schedule = monthly
month5_liability = #$:(0..):if deposit_schedule = monthly
month6_liability = #$:(0..):if deposit_schedule = monthly
month7_liability = #$:(0..):if deposit_schedule = monthly
month8_liability = #$:(0..):if deposit_schedule = monthly
month9_liability = #$:(0..):if deposit_schedule = monthly
month10_liability = #$:(0..):if deposit_schedule = monthly
month11_liability = #$:(0..):if deposit_schedule = monthly
month12_liability = #$:(0..):if deposit_schedule = monthly
total_liability = #$:(0..)

{@form_943}
; Third Party Designees
{.designees[]}
name = :                                             ; Designee name
phone = *@types.phone                                ; Designee phone
pin = *:(5)                                          ; Designee PIN

{@form_943}
; Signatories
{.signatories[]}
name = :                                             ; Signatory name
title = :                                            ; Signatory title
signed_date = date                                   ; Signature date
phone = *@types.phone                                ; Contact phone

; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Payroll Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Payroll processing including earnings (regular, overtime, bonus, commission),
; deductions (tax, benefits, garnishments), employer taxes, pay statements,
; and year-to-date totals.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.employment.payroll"
version = "1.0.0"
title = "Payroll Schema"
description = "Earnings, deductions, taxes, and pay statement processing"

{$derivation}
source[0].authority = "Internal Revenue Service"
source[0].citation = "Publication 15 (Circular E), Employer's Tax Guide"
source[0].url = "https://www.irs.gov/publications/p15"

source[1].authority = "Internal Revenue Service"
source[1].citation = "Publication 15-A, Employer's Supplemental Tax Guide"
source[1].url = "https://www.irs.gov/publications/p15a"

source[2].authority = "Internal Revenue Service"
source[2].citation = "Publication 15-B, Employer's Tax Guide to Fringe Benefits"
source[2].url = "https://www.irs.gov/publications/p15b"

source[3].authority = "U.S. Department of Labor"
source[3].citation = "Fair Labor Standards Act (FLSA), 29 USC 201 et seq."
source[3].url = "https://www.dol.gov/agencies/whd/flsa"

source[4].authority = "U.S. Department of Labor"
source[4].citation = "Wage Garnishment, 29 CFR Part 870"
source[4].url = "https://www.dol.gov/agencies/whd/government-contracts/garnishment"

source[5].authority = "Social Security Administration"
source[5].citation = "Federal Insurance Contributions Act (FICA)"
source[5].url = "https://www.ssa.gov/employer"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial payroll schema"
changelog[0].rationale = "Pay period, earnings, deductions, taxes derived from IRS, DOL, and SSA requirements"

; ═══════════════════════════════════════════════════════════════════════════════
; PAY PERIOD
; ═══════════════════════════════════════════════════════════════════════════════

{@pay_period}
pay_period_id = !:                               ; Unique pay period identifier
pay_frequency = (biweekly, monthly, semi_monthly, weekly)
period_start_date = !date                        ; Pay period start
period_end_date = !date                          ; Pay period end
pay_date = !date                                 ; Payment date
check_date = date                                ; Check/deposit date

:invariant period_end_date >= period_start_date  ; End must be after start
:invariant pay_date >= period_end_date           ; Pay date after period end

year = !##:(1900..)                              ; Calendar year
quarter = !##:(1..4)                             ; Quarter (1-4)
period_number = !##:(1..)                        ; Period number in year

status = (closed, open, processing)              ; Pay period status

; ═══════════════════════════════════════════════════════════════════════════════
; PAY STATEMENT
; ═══════════════════════════════════════════════════════════════════════════════

{@pay_statement}
= @types.audit_info

pay_statement_id = !:                            ; Unique statement identifier
employee_id = !:                                 ; Associated employee
pay_period_id = !:                               ; Associated pay period

; Check/payment information
check_number = :                                 ; Check number if paper check
payment_method = (ach, check, direct_deposit, pay_card)
payment_date = !date                             ; Payment/deposit date

; Earnings
{.earnings}
regular = @earnings_detail                       ; Regular wages/salary
overtime = @earnings_detail                      ; Overtime earnings
double_time = @earnings_detail                   ; Double-time earnings
holiday = @earnings_detail                       ; Holiday pay
pto = @earnings_detail                           ; Paid time off
sick = @earnings_detail                          ; Sick pay
bonus = @earnings_detail                         ; Bonuses
commission = @earnings_detail                    ; Commissions
other_earnings[] = @earnings_detail              ; Other earning types

gross_earnings = !#$:(0..)                       ; Total gross earnings

{@pay_statement}

; Deductions
{.deductions}
; Tax deductions
federal_income_tax = @deduction_detail           ; Federal income tax
social_security = @deduction_detail              ; Social Security (OASDI)
medicare = @deduction_detail                     ; Medicare
state_income_tax[] = @deduction_detail           ; State income tax(es)
local_income_tax[] = @deduction_detail           ; Local income tax(es)

; Benefit deductions
health_insurance = @deduction_detail             ; Health insurance premium
dental_insurance = @deduction_detail             ; Dental insurance premium
vision_insurance = @deduction_detail             ; Vision insurance premium
life_insurance = @deduction_detail               ; Life insurance premium
disability_insurance = @deduction_detail         ; Disability insurance premium
retirement_401k = @deduction_detail              ; 401(k) contribution
retirement_403b = @deduction_detail              ; 403(b) contribution
retirement_457 = @deduction_detail               ; 457 contribution
hsa = @deduction_detail                          ; Health Savings Account
fsa_health = @deduction_detail                   ; FSA Health Care
fsa_dependent = @deduction_detail                ; FSA Dependent Care

; Other deductions
garnishments[] = @garnishment_detail             ; Wage garnishments
other_deductions[] = @deduction_detail           ; Other deduction types

total_deductions = !#$:(0..)                     ; Total deductions

{@pay_statement}

; Net pay
net_pay = !#$                                    ; Net pay amount
:invariant net_pay = earnings.gross_earnings - deductions.total_deductions

; Year-to-date totals
{.ytd}
gross_earnings = !#$:(0..)                       ; YTD gross earnings
federal_income_tax = !#$:(0..)                   ; YTD federal tax
social_security = !#$:(0..)                      ; YTD Social Security
medicare = !#$:(0..)                             ; YTD Medicare
state_income_tax = #$:(0..)                      ; YTD state tax
local_income_tax = #$:(0..)                      ; YTD local tax
retirement = #$:(0..)                            ; YTD retirement contributions
hsa = #$:(0..)                                   ; YTD HSA contributions
net_pay = !#$                                    ; YTD net pay

{@pay_statement}

; Hours (for hourly employees)
{.hours}
regular_hours = #:(0..)                          ; Regular hours worked
overtime_hours = #:(0..)                         ; Overtime hours
double_time_hours = #:(0..)                      ; Double-time hours
holiday_hours = #:(0..)                          ; Holiday hours
pto_hours = #:(0..)                              ; PTO hours used
sick_hours = #:(0..)                             ; Sick hours used
total_hours = #:(0..)                            ; Total hours

{@pay_statement}

; ═══════════════════════════════════════════════════════════════════════════════
; EARNINGS DETAIL
; ═══════════════════════════════════════════════════════════════════════════════

{@earnings_detail}
earning_type = !:                                ; Type of earning
description = :                                  ; Earning description
hours = #:(0..)                                  ; Hours if applicable
rate = #$:(0..)                                  ; Pay rate
amount = !#$:(0..)                               ; Earning amount
taxable = ?                                      ; Subject to income tax
fica_taxable = ?                                 ; Subject to FICA tax
futa_taxable = ?                                 ; Subject to FUTA tax
suta_taxable = ?                                 ; Subject to SUTA tax

; ═══════════════════════════════════════════════════════════════════════════════
; DEDUCTION DETAIL
; ═══════════════════════════════════════════════════════════════════════════════

{@deduction_detail}
deduction_type = !:                              ; Type of deduction
description = :                                  ; Deduction description
amount = !#$:(0..)                               ; Deduction amount
pre_tax = ?                                      ; Pre-tax deduction
employer_match = #$:(0..)                        ; Employer match amount
jurisdiction = :                                 ; Tax jurisdiction if applicable

; ═══════════════════════════════════════════════════════════════════════════════
; GARNISHMENT DETAIL
; ═══════════════════════════════════════════════════════════════════════════════

{@garnishment_detail}
garnishment_id = !:                              ; Garnishment identifier
garnishment_type = (bankruptcy, child_support, creditor, federal_levy, student_loan, tax_levy)
order_number = !*:                               ; Court order number (confidential)
issuing_authority = !:                           ; Issuing court/agency
priority = !##:(1..)                             ; Garnishment priority (1 = highest)

amount = !#$:(0..)                               ; Amount garnished this period
calculation_method = (fixed_amount, percentage)  ; How amount is calculated
percentage = #:(0..100):if calculation_method = percentage
maximum_per_period = #$:(0..)                    ; Maximum per pay period
cumulative_amount = #$:(0..)                     ; Total garnished to date
total_obligation = #$:(0..)                      ; Total obligation amount
remaining_balance = #$:(0..)                     ; Remaining balance

order_date = !date                               ; Date order received
start_date = !date                               ; Garnishment start date
end_date = date                                  ; Garnishment end date (if known)
status = (active, completed, on_hold, pending)   ; Garnishment status

remittance_address = @types.address              ; Where to send payments
remittance_payee = :                             ; Payee name
remittance_account = *:                          ; Account number (confidential)

; ═══════════════════════════════════════════════════════════════════════════════
; EMPLOYER TAXES
; ═══════════════════════════════════════════════════════════════════════════════

{@employer_taxes}
employee_id = !:                                 ; Associated employee
pay_period_id = !:                               ; Associated pay period

; Federal employer taxes
{.federal}
social_security_employer = !#$:(0..)             ; Employer FICA (6.2%)
medicare_employer = !#$:(0..)                    ; Employer Medicare (1.45%)
medicare_additional = #$:(0..)                   ; Additional Medicare (0.9% on high earners)
futa = !#$:(0..)                                 ; Federal Unemployment Tax (FUTA)

{@employer_taxes}

; State employer taxes
{.state[]}
state = !:(2)                                    ; State code
suta = !#$:(0..)                                 ; State Unemployment Tax (SUTA/SUI)
sdi = #$:(0..)                                   ; State Disability Insurance
other_state_taxes = #$:(0..)                     ; Other state-specific taxes

{@employer_taxes}

total_employer_taxes = !#$:(0..)                 ; Total employer tax liability

; ═══════════════════════════════════════════════════════════════════════════════
; TAX DEPOSIT
; ═══════════════════════════════════════════════════════════════════════════════

{@tax_deposit}
= @types.audit_info

deposit_id = !:                                  ; Unique deposit identifier
deposit_date = !date                             ; Date of deposit
deposit_period_start = !date                     ; Period start
deposit_period_end = !date                       ; Period end
tax_period = (monthly, quarterly, semi_weekly)   ; Deposit frequency
deposit_type = (eftps, same_day_wire)            ; Deposit method

; Federal tax amounts
{.federal}
income_tax_withheld = !#$:(0..)                  ; Employee federal withholding
social_security_employee = !#$:(0..)             ; Employee FICA
social_security_employer = !#$:(0..)             ; Employer FICA
medicare_employee = !#$:(0..)                    ; Employee Medicare
medicare_employer = !#$:(0..)                    ; Employer Medicare
total_federal = !#$:(0..)                        ; Total federal deposit

{@tax_deposit}

; State tax amounts
{.state[]}
state = !:(2)                                    ; State code
income_tax_withheld = #$:(0..)                   ; Employee state withholding
suta = #$:(0..)                                  ; SUTA/SUI
sdi = #$:(0..)                                   ; SDI
total_state = #$:(0..)                           ; Total state deposit

{@tax_deposit}

confirmation_number = :                          ; Deposit confirmation
status = (cancelled, failed, pending, submitted, verified)

; ═══════════════════════════════════════════════════════════════════════════════
; YEAR-END REPORTING
; ═══════════════════════════════════════════════════════════════════════════════

{@w2_data}
employee_id = !:                                 ; Associated employee
tax_year = !##:(1900..)                          ; Tax year

; Box data (W-2 form)
box_1_wages = !#$:(0..)                          ; Wages, tips, other compensation
box_2_federal_tax = !#$:(0..)                    ; Federal income tax withheld
box_3_ss_wages = !#$:(0..)                       ; Social Security wages
box_4_ss_tax = !#$:(0..)                         ; Social Security tax withheld
box_5_medicare_wages = !#$:(0..)                 ; Medicare wages and tips
box_6_medicare_tax = !#$:(0..)                   ; Medicare tax withheld
box_7_ss_tips = #$:(0..)                         ; Social Security tips
box_8_allocated_tips = #$:(0..)                  ; Allocated tips
box_10_dependent_care = #$:(0..)                 ; Dependent care benefits
box_11_nonqualified_plans = #$:(0..)             ; Nonqualified plans
box_12[] = @w2_box_12                            ; Box 12 codes
box_13_statutory = ?                             ; Statutory employee
box_13_retirement = ?                            ; Retirement plan
box_13_sick_pay = ?                              ; Third-party sick pay
box_14[] = @w2_box_14                            ; Other (state-specific)

; State/local
{.state_local[]}
state = :(2)                                     ; State code
state_id = :                                     ; Employer state ID
state_wages = #$:(0..)                           ; State wages
state_tax = #$:(0..)                             ; State income tax
locality = :                                     ; Locality name
local_wages = #$:(0..)                           ; Local wages
local_tax = #$:(0..)                             ; Local income tax

{@w2_data}

; ═══════════════════════════════════════════════════════════════════════════════
; W-2 BOX 12 CODES
; ═══════════════════════════════════════════════════════════════════════════════

{@w2_box_12}
code = (
    a, b, c, d, e, f, g, h, j, k, l, m, n, p, q, r, s, t, v, w, y, z,
    aa, bb, dd, ee, ff, gg, hh
)                                                ; IRS Box 12 code
amount = !#$:(0..)                               ; Amount for code

; ═══════════════════════════════════════════════════════════════════════════════
; W-2 BOX 14 OTHER
; ═══════════════════════════════════════════════════════════════════════════════

{@w2_box_14}
description = !:                                 ; Description (state-specific)
amount = !#$:(0..)                               ; Amount

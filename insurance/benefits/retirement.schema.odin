; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Employee Retirement Benefits Schema
; ═══════════════════════════════════════════════════════════════════════════════
; 401(k), pension, profit-sharing, and nonqualified deferred compensation plans
; derived from ERISA and IRS qualified plan requirements.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as benefits

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.benefits.retirement"
version = "1.0.0"
title = "Employee Retirement Benefits Schema"
description = "401(k), pension, profit-sharing, and nonqualified deferred compensation plans"

{$derivation}
source[0].authority = "GPO"
source[0].citation = "29 USC Chapter 18 - ERISA"
source[0].url = "https://www.law.cornell.edu/uscode/text/29/chapter-18"

source[1].authority = "IRS"
source[1].citation = "IRC Section 401 - Qualified Plans"
source[1].url = "https://www.law.cornell.edu/uscode/text/26/401"

source[2].authority = "IRS"
source[2].citation = "IRC Section 402 - Taxability of Beneficiary"
source[2].url = "https://www.law.cornell.edu/uscode/text/26/402"

source[3].authority = "IRS"
source[3].citation = "IRC Section 409A - Nonqualified Deferred Compensation"
source[3].url = "https://www.law.cornell.edu/uscode/text/26/409A"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial employee retirement benefits schema"
changelog[0].rationale = "Structure derived from ERISA and IRC qualified plan requirements"

; ═══════════════════════════════════════════════════════════════════════════════
; 401(k) PLAN
; ═══════════════════════════════════════════════════════════════════════════════
; Per IRC Section 401(k)

{@plan_401k}
plan_id = :                                ; Plan identifier
employer_id = :                            ; Employer
plan_name = :                              ; Plan name
ein = *:                                   ; Employer EIN
plan_number = :                            ; Plan number (3-digit)

; Plan type
{.type}
plan_type = (safe_harbor, safe_harbor_match, simple_401k, traditional)
roth_feature = ?                            ; Roth 401(k) available
auto_enrollment = ?                         ; Automatic enrollment

{@plan_401k}

; Eligibility - Per 401(k) requirements
{.eligibility}
minimum_age = ##:(18..21)                   ; Minimum age
minimum_service_months = ##:(0..12)         ; Minimum service
entry_dates = (first_of_month, immediate, quarterly, semi_annual)
excluded_classes[] = :                      ; Excluded employee classes

{@plan_401k}

; Employee contributions - Per IRC 402(g) limits
{.contributions}
employee_deferral = ?                       ; Employee deferrals allowed
deferral_limit = #$:(0..)                   ; Annual 402(g) limit
catch_up_age = ##:(50..50)                  ; Catch-up eligibility age
catch_up_limit = #$:(0..)                   ; Catch-up contribution limit
roth_deferrals = ?                          ; Roth deferrals allowed
after_tax_contributions = ?                 ; After-tax (non-Roth) allowed

{@plan_401k}

; Employer contributions
{.employer_match}
match_formula = :                           ; Match formula description
match_percent = #:(0..100)                  ; Match percentage
match_cap_percent = #:(0..100)              ; Cap as % of compensation
discretionary_match = ?                     ; Discretionary match
safe_harbor_match = ?                       ; Safe harbor match (if applicable)

{@plan_401k}

; Profit sharing
{.profit_sharing}
profit_sharing = ?                          ; Profit sharing feature
allocation_method = (integrated, new_comparability, pro_rata)
discretionary = ?                           ; Discretionary contribution

{@plan_401k}

; Vesting - Per ERISA minimum vesting
{.vesting}
deferral_vesting = : "immediate"            ; Employee deferrals (always immediate)
match_vesting_schedule = (cliff_2, cliff_3, graded_6, immediate)
profit_sharing_vesting = (cliff_2, cliff_3, graded_6, immediate)
hours_per_year_of_service = ##:(500..1000)  ; Hours for year of service

{@plan_401k}

; Loans - Per 401(k) loan rules
{.loans}
loans_allowed = ?                           ; Loans permitted
maximum_loan_percent = #:(0..50)            ; Max % of vested balance
maximum_loan_amount = #$:(0..50000)         ; Max loan amount ($50K limit)
loan_interest_rate = :                      ; Interest rate (prime + x)
repayment_term_months = ##:(12..60)         ; Maximum repayment term

{@plan_401k}

; Distributions - Per 401(k) distribution rules
{.distributions}
in_service_at_age = ##:(59..72)             ; In-service distribution age
hardship_withdrawals = ?                    ; Hardship withdrawals allowed
required_minimum_distribution_age = ##:(72..75) ; RMD age (per SECURE 2.0)
installment_distributions = ?               ; Installment option
annuity_option = ?                          ; Annuity option

{@plan_401k}

; Auto-enrollment features - Per SECURE Act
{.auto_enroll}
auto_enroll_percent = #:(1..15)             ; Initial auto-enroll %
auto_escalation = ?                         ; Automatic escalation
escalation_percent = #:(1..2)               ; Annual escalation %
escalation_cap = #:(6..15)                  ; Escalation cap %
qdia = :                                    ; Qualified default investment

{@plan_401k}

; Investment options
{.investments}
self_directed = ?                           ; Self-directed brokerage
investment_options[] = :                    ; Investment fund options
company_stock = ?                           ; Company stock offered
company_stock_limit = #:(0..100)            ; Limit on company stock

{@plan_401k}

; Recordkeeper
{.recordkeeper}
recordkeeper_name = :                       ; Recordkeeper name
trustee_name = :                            ; Plan trustee
custodian_name = :                          ; Custodian

{@plan_401k}

; ═══════════════════════════════════════════════════════════════════════════════
; DEFINED BENEFIT PENSION
; ═══════════════════════════════════════════════════════════════════════════════
; Per ERISA Title I and IRC Section 401(a)

{@pension}
plan_id = :                                ; Plan identifier
employer_id = :                            ; Employer
plan_name = :                              ; Plan name
ein = *:                                   ; Employer EIN
plan_number = :                            ; Plan number

; Plan type
{.type}
plan_type = (cash_balance, final_average_pay, flat_benefit, hybrid)
frozen = ?                                  ; Plan frozen to new participants
soft_freeze = ?                             ; Soft freeze (accruals continue)
hard_freeze = ?                             ; Hard freeze (no new accruals)

{@pension}

; Eligibility
{.eligibility}
minimum_age = ##:(18..21)                   ; Minimum age
minimum_service_years = ##:(0..5)           ; Years of service
entry_dates = (first_of_month, immediate, quarterly, semi_annual)

{@pension}

; Benefit formula - Per plan document
{.formula}
formula_type = (career_average, cash_balance, final_average, flat_dollar)
benefit_percent = #:(0..5)                  ; Percent per year of service
final_average_years = ##:(3..5)             ; Years for final average pay
integration_level = :                       ; Social Security integration
maximum_years = ##:(0..50)                  ; Maximum credited years
cash_balance_credit_percent = #:(0..15)    ; Cash balance pay credit %

{@pension}

; Vesting - Per ERISA minimum vesting
{.vesting}
vesting_schedule = (cliff_3, cliff_5, graded_7)
years_for_full_vesting = ##:(3..7)          ; Years to full vesting
hours_per_year = ##:(1000..1000)            ; Hours for year of service

{@pension}

; Normal retirement
{.normal_retirement}
normal_retirement_age = ##:(62..67)         ; Normal retirement age
normal_retirement_service = ##:(0..30)      ; Service for normal retirement

{@pension}

; Early retirement
{.early_retirement}
early_retirement_available = ?              ; Early retirement available
early_retirement_age = ##:(55..62)          ; Minimum early retirement age
early_retirement_service = ##:(0..30)       ; Service for early retirement
early_retirement_reduction = #:(0..10)      ; % reduction per year

{@pension}

; Payment forms - Per 417(e) requirements
{.payment_forms}
life_annuity = ?                            ; Single life annuity
joint_survivor = ?                          ; Joint and survivor
lump_sum = ?                                ; Lump sum option
installments = ?                            ; Installment payments
qjsa = ?                                    ; Qualified joint and survivor
qpsa = ?                                    ; Qualified preretirement survivor

{@pension}

; PBGC - Per ERISA Title IV
{.pbgc}
pbgc_covered = ?                            ; PBGC-insured plan
pbgc_premium_per_participant = #$:(0..)     ; Per-participant premium
pbgc_variable_rate = #$:(0..)               ; Variable rate premium
funded_status = #:(0..200)                  ; Funded percentage

{@pension}

; Actuary
{.actuary}
enrolled_actuary = :                        ; Enrolled actuary name
actuarial_firm = :                          ; Actuarial firm
valuation_date = date                       ; Last valuation date

{@pension}

; ═══════════════════════════════════════════════════════════════════════════════
; PROFIT SHARING PLAN
; ═══════════════════════════════════════════════════════════════════════════════
; Per IRC Section 401(a) - Standalone profit sharing

{@profit_sharing}
plan_id = :                                ; Plan identifier
employer_id = :                            ; Employer
plan_name = :                              ; Plan name
ein = *:                                   ; Employer EIN

; Contribution formula
{.contributions}
discretionary = ?                           ; Discretionary contributions
formula_based = ?                           ; Formula-based contributions
formula = :                                 ; Contribution formula
maximum_contribution_percent = #:(0..25)    ; Maximum % of compensation

{@profit_sharing}

; Allocation method - Per IRS guidelines
{.allocation}
allocation_method = (age_weighted, integrated, new_comparability, pro_rata)
integration_level = :                       ; Social Security taxable wage base
permitted_disparity = #:(0..5.7)            ; Integration percentage

{@profit_sharing}

; Eligibility
{.eligibility}
minimum_age = ##:(18..21)                   ; Minimum age
minimum_service_months = ##:(0..24)         ; Minimum months of service
hours_requirement = ##:(0..1000)            ; Hours requirement
entry_dates = (first_of_month, immediate, quarterly)

{@profit_sharing}

; Vesting
{.vesting}
vesting_schedule = (cliff_2, cliff_3, graded_6, immediate)
hours_per_year_of_service = ##:(500..1000)  ; Hours for year of service

{@profit_sharing}

; Distributions
{.distributions}
in_service_distributions = ?                ; In-service withdrawals allowed
age_for_in_service = ##:(59..72)            ; Age for in-service
rmd_age = ##:(72..75)                       ; Required minimum distribution age

{@profit_sharing}

; ═══════════════════════════════════════════════════════════════════════════════
; NONQUALIFIED DEFERRED COMPENSATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per IRC Section 409A

{@nqdc}
plan_id = :                                ; Plan identifier
employer_id = :                            ; Employer
plan_name = :                              ; Plan name

; Plan type
{.type}
plan_type = (excess_benefit, salary_deferral, serp, sip)
; serp = Supplemental Executive Retirement Plan
; sip = Stock Incentive Plan
rabbi_trust = ?                             ; Rabbi trust funded
secular_trust = ?                           ; Secular trust funded

{@nqdc}

; Eligibility - Per plan design
{.eligibility}
eligible_class = :                          ; Eligible employee class
top_hat_plan = ?                            ; Top-hat plan (HCE only)
select_group = ?                            ; Select group of management

{@nqdc}

; Deferrals
{.deferrals}
salary_deferral = ?                         ; Salary deferral allowed
bonus_deferral = ?                          ; Bonus deferral allowed
maximum_deferral_percent = #:(0..100)       ; Max deferral percentage
election_deadline = :                       ; Election deadline

{@nqdc}

; Employer contributions
{.employer}
employer_match = ?                          ; Employer matching
employer_discretionary = ?                  ; Discretionary contribution
restoration_match = ?                       ; 401(k) restoration match

{@nqdc}

; Investment crediting - Per plan design
{.investment}
crediting_rate = :                          ; Interest crediting method
phantom_investments = ?                     ; Phantom investment options
investment_options[] = :                    ; Crediting rate options
company_stock_units = ?                     ; Company stock units

{@nqdc}

; Distribution timing - Per 409A rules
{.distribution}
distribution_events[] = :                   ; Triggering events
; Per 409A: separation, disability, death, change in control, unforeseeable emergency, specified time
separation_payout = (installments, lump_sum)
payout_period_years = ##:(1..15)            ; Installment period
six_month_delay = ?                         ; 6-month delay (key employees)

{@nqdc}

; 409A compliance
{.compliance}
initial_deferral_election = ?               ; Timely initial election
subsequent_deferral_election = ?            ; Subsequent election rules
acceleration_prohibited = ?                 ; No acceleration of payments
compliant = ?                               ; 409A compliant

{@nqdc}

; ═══════════════════════════════════════════════════════════════════════════════
; ESOP (Employee Stock Ownership Plan)
; ═══════════════════════════════════════════════════════════════════════════════
; Per IRC Sections 409 and 4975(e)(7)

{@esop}
plan_id = :                                ; Plan identifier
employer_id = :                            ; Employer
plan_name = :                              ; Plan name

; ESOP type
{.type}
esop_type = (leveraged, non_leveraged)
s_corp_esop = ?                             ; S-corp ESOP
c_corp_esop = ?                             ; C-corp ESOP
ksop = ?                                    ; 401(k)/ESOP combination

{@esop}

; Stock
{.stock}
stock_ticker = :                            ; Ticker (if public)
closely_held = ?                            ; Closely held stock
voting_rights = ?                           ; Pass-through voting
put_option = ?                              ; Put option required
valuation_date = date                       ; Last valuation date
share_value = #$:(0..)                      ; Current share value

{@esop}

; Contributions
{.contributions}
employer_contribution = ?                   ; Employer contributions
employee_deferrals = ?                      ; 401(k) deferrals (if KSOP)
loan_repayment = ?                          ; Leveraged ESOP loan repayment

{@esop}

; Vesting
{.vesting}
vesting_schedule = (cliff_3, graded_6)
years_for_full_vesting = ##:(3..6)          ; Years to full vesting

{@esop}

; Diversification - Per IRC 401(a)(28)
{.diversification}
diversification_available = ?               ; Diversification option
age_requirement = ##:(55..55)               ; Age for diversification
service_requirement = ##:(10..10)           ; Years for diversification
diversification_percent = #:(25..50)        ; Percent that can diversify

{@esop}

; Distributions
{.distributions}
distribution_options = (installments, lump_sum, stock)
rmd_age = ##:(72..75)                       ; RMD age
put_option_period_days = ##:(60..120)       ; Put option period

{@esop}

; ═══════════════════════════════════════════════════════════════════════════════
; RETIREMENT ENROLLMENT
; ═══════════════════════════════════════════════════════════════════════════════

{@retirement_enrollment}
enrollment_id = :                          ; Enrollment ID
employee_id = :                            ; Employee
plan_id = :                                ; Plan ID
plan_type = (esop, nqdc, pension, profit_sharing, _401k)

; Enrollment details
{.enrollment}
enrollment_date = date                     ; Enrollment date
auto_enrolled = ?                           ; Auto-enrolled
effective_date = date                       ; Participation effective date
rehire_enrollment = ?                       ; Rehire reinstatement

{@retirement_enrollment}

; Deferral elections (if applicable)
{.deferrals}
deferral_percent = #:(0..100)               ; Deferral percentage
deferral_amount = #$:(0..)                  ; Flat dollar amount
roth_percent = #:(0..100)                   ; Roth deferral %
after_tax_percent = #:(0..100)              ; After-tax %
catch_up_election = ?                       ; Catch-up contributions

{@retirement_enrollment}

; Investment elections
{.investments}
investment_elections[] = :                  ; Investment fund elections
; Each with fund_id and allocation_percent
target_date_fund = :                        ; Target date fund selected
self_directed_brokerage = ?                 ; Self-directed account

{@retirement_enrollment}

; Beneficiaries
beneficiaries[] = @benefits.beneficiary     ; Designated beneficiaries

; Status
status = (active, declined, suspended, terminated)

; ═══════════════════════════════════════════════════════════════════════════════
; RETIREMENT ACCOUNT
; ═══════════════════════════════════════════════════════════════════════════════

{@retirement_account}
account_id = :                             ; Account ID
enrollment_id = :                          ; Enrollment ID
employee_id = :                            ; Employee

; Balances
{.balances}
total_balance = #$:(0..)                    ; Total account balance
vested_balance = #$:(0..)                   ; Vested balance
employee_contributions = #$:(0..)           ; Employee contribution balance
employer_match = #$:(0..)                   ; Employer match balance
profit_sharing = #$:(0..)                   ; Profit sharing balance
roth_balance = #$:(0..)                     ; Roth balance
after_tax_balance = #$:(0..)                ; After-tax balance
rollover_balance = #$:(0..)                 ; Rollover balance

{@retirement_account}

; YTD contributions
{.ytd}
ytd_employee = #$:(0..)                     ; YTD employee contributions
ytd_employer_match = #$:(0..)               ; YTD employer match
ytd_profit_sharing = #$:(0..)               ; YTD profit sharing
ytd_catch_up = #$:(0..)                     ; YTD catch-up contributions

{@retirement_account}

; Loans outstanding
{.loans}
loan_balance = #$:(0..)                     ; Outstanding loan balance
loan_count = ##:(0..5)                      ; Active loans

{@retirement_account}

; Vesting
{.vesting}
vesting_percent = #:(0..100)                ; Current vesting %
years_of_service = ##:(0..50)               ; Vesting service years
fully_vested = ?                            ; Fully vested

{@retirement_account}

; As of date
as_of_date = date                           ; Balance as of date

; ═══════════════════════════════════════════════════════════════════════════════
; RETIREMENT DISTRIBUTION
; ═══════════════════════════════════════════════════════════════════════════════

{@retirement_distribution}
distribution_id = :                        ; Distribution ID
account_id = :                             ; Account ID
employee_id = :                            ; Employee

; Distribution type
{.type}
distribution_reason = (death, disability, hardship, in_service, normal_retirement, rmd, separation, qdro)
distribution_form = (annuity, direct_rollover, installments, lump_sum)

{@retirement_distribution}

; Amount
{.amount}
gross_amount = #$:(0..)                     ; Gross distribution
federal_withholding = #$:(0..)              ; Federal tax withheld
state_withholding = #$:(0..)                ; State tax withheld
net_amount = #$:(0..)                       ; Net distribution

{@retirement_distribution}

; Tax treatment
{.tax}
taxable_amount = #$:(0..)                   ; Taxable portion
non_taxable_amount = #$:(0..)               ; Non-taxable portion
roth_qualified = ?                          ; Qualified Roth distribution
early_distribution = ?                      ; Before age 59½
penalty_exception_code = :                  ; 10% penalty exception code

{@retirement_distribution}

; Rollover
{.rollover}
direct_rollover = ?                         ; Direct rollover
rollover_destination = :                    ; Receiving institution
rollover_account_type = :                   ; IRA, 401k, etc.

{@retirement_distribution}

; Dates
{.dates}
request_date = date                         ; Request date
distribution_date = date                    ; Distribution date

{@retirement_distribution}

; QDRO (if applicable) - Per ERISA 206(d)
{.qdro}
qdro_distribution = ?                       ; QDRO distribution
qdro_number = :                             ; QDRO reference number
alternate_payee = :                         ; Alternate payee name

{@retirement_distribution}

; Status
status = (approved, denied, paid, pending)

; ═══════════════════════════════════════════════════════════════════════════════
; RETIREMENT LOAN
; ═══════════════════════════════════════════════════════════════════════════════
; Per 401(k) loan rules

{@retirement_loan}
loan_id = :                                ; Loan ID
account_id = :                             ; Account ID
employee_id = :                            ; Employee

; Loan details
{.details}
loan_type = (general, principal_residence)
original_amount = #$:(0..50000)             ; Original loan amount
current_balance = #$:(0..)                  ; Current balance
interest_rate = #:(0..20)                   ; Interest rate

{@retirement_loan}

; Repayment
{.repayment}
term_months = ##:(12..60)                   ; Loan term (60 for residence)
payment_amount = #$:(0..)                   ; Payment per period
payment_frequency = (biweekly, monthly, semi_monthly, weekly)
origination_date = date                     ; Loan origination date
matyours_date = date                        ; Loan maturity date
payoff_date = date                          ; Actual payoff date

{@retirement_loan}

; Default
{.default}
deemed_distribution = ?                     ; Deemed distribution
deemed_distribution_date = date             ; Date deemed distributed
cure_period_end = date                      ; End of cure period

{@retirement_loan}

; Status
status = (active, defaulted, paid_off)



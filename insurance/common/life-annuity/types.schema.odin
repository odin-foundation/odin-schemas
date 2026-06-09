; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Life & Annuity Common Types
; ═══════════════════════════════════════════════════════════════════════════════
; Reusable type definitions shared by life insurance and annuity products including
; beneficiaries, underwriting classes, and surrender charges. These types are not
; shared with P&C products due to fundamental domain differences.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as types
@import "../party.schema.odin" as party

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.common.life_annuity.types"
version = "1.0.0"
title = "Life & Annuity Common Types"
description = "Reusable type definitions for life insurance and annuity products"

{$derivation}
source[0].authority = "NAIC"
source[0].citation = "NAIC Life Insurance Buyer's Guide"
source[0].url = "https://content.naic.org/insurance-topics/life-insurance"

methodology = "industry_practice"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-15
changelog[0].change = "Initial life and annuity common types schema"
changelog[0].rationale = "Standard life/annuity insurance industry data patterns"

; ═══════════════════════════════════════════════════════════════════════════════
; Beneficiary Designation
; ═══════════════════════════════════════════════════════════════════════════════
; Beneficiary designations for death benefits (life) and contract proceeds (annuity)
; Critical for claims processing and estate planning

{@beneficiary}
; Required fields
designation = (contingent, primary)          ; Beneficiary level
name = :                                     ; Beneficiary name
percent = #:(0..100)                         ; Percentage of benefit

; Optional fields
address = @types.address                      ; Mailing address
date_of_birth = *date                         ; Birth date for person beneficiaries
distribution = (lump_sum, periodic, retained_asset)  ; Distribution method
id = :                                        ; Unique identifier
irrevocable = ?                               ; Cannot be changed without beneficiary consent
phones[] = *@types.phone                      ; Contact phones
relation = (business, charity, child, domestic_partner, estate, grandchild, other, parent, sibling, spouse, trust)  ; Relationship to owner or insured
removed = date                                ; Date removed as beneficiary
ssn = *:format ssn                            ; SSN for tax reporting
tax_id = *:                                   ; Tax ID for trusts or entities
trust_name = :                                ; Trust name if beneficiary is trust
type = (entity, estate, person, trust)        ; Beneficiary type

; ───────────────────────────────────────────────────────────────────────────────
; Per Stirpes / Distribution Rules
; ───────────────────────────────────────────────────────────────────────────────
{.distribution_rule}
per_stirpes = ?                               ; Passes to descendants if beneficiary predeceases insured
specific_amount = #$:(0..)                          ; Fixed dollar amount instead of percentage

{@beneficiary}

; ═══════════════════════════════════════════════════════════════════════════════
; Underwriting Classification
; ═══════════════════════════════════════════════════════════════════════════════
; Risk classification for life insurance and annuity mortality charges
; Determines premium rates and eligibility

{@underwriting_class}
; Required fields
classification = (decline, preferred, preferred_plus, standard, standard_plus, substandard)  ; Risk class
effective = date                             ; Classification effective date

; Optional fields
build_chart_used = :                          ; Height and weight chart reference
decline_reason = :                            ; Reason for decline
expiration = date                             ; Classification expiration
flat_extra = #$:(0..)
flat_extra_duration = ##:(1..25)
flat_extra_reason = :                         ; Reason for flat extra
medical_exam = ?                              ; Medical exam completed
medical_exam_date = date                      ; Date of medical exam
provisional = ?                               ; Provisional rating pending additional information
rating_reason = :                             ; Reason for rating
table_rating = (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p)  ; Table rating A through P
table_rating_percent = ##:(125..400)
tobacco_class = (never, non_tobacco, tobacco) ; Tobacco use classification
tobacco_last_use = date                       ; Date of last tobacco use

; ───────────────────────────────────────────────────────────────────────────────
; Build Information
; ───────────────────────────────────────────────────────────────────────────────
{.build}
height_inches = ##:(36..96)                   ; Height in inches
weight_pounds = ##:(50..600)                  ; Weight in pounds
bmi = #:(10..80)                              ; Calculated BMI

{@underwriting_class}

; ───────────────────────────────────────────────────────────────────────────────
; Medical History
; ───────────────────────────────────────────────────────────────────────────────
{.medical}
blood_pressure_diastolic = ##:(30..200)       ; Diastolic reading
blood_pressure_systolic = ##:(60..300)        ; Systolic reading
cholesterol_hdl = ##:(10..200)                ; HDL cholesterol
cholesterol_ldl = ##:(10..400)                ; LDL cholesterol
cholesterol_total = ##:(50..500)              ; Total cholesterol
diabetes = ?                                  ; Diabetes diagnosis
heart_disease = ?                             ; Heart disease history
labs_date = date                              ; Date of lab work

{@underwriting_class}

; ═══════════════════════════════════════════════════════════════════════════════
; Investment Subaccount
; ═══════════════════════════════════════════════════════════════════════════════
; Investment options for variable products (VUL, variable annuity)
; Allows allocation across multiple funds

{@subaccount}
; Required fields
fund_name = :                                ; Fund name
ticker = :                                   ; Fund ticker symbol

; Optional fields
allocation_percent = #:(0..100)
asset_class = (alternative, balanced, bond, commodity, fixed_income, international, money_market, real_estate, sector, stock)
cusip = :(9)
current_value = #$:(0..)
expense_ratio = #:(0..5)
fund_family = :                               ; Fund family name
effective = date                              ; Fund inception date
investment_objective = (aggressive_growth, balanced, capital_preservation, growth, growth_and_income, income)
management_fee = #:(0..3)
morningstar_rating = ##:(1..5)
nav = #$:(0..)
risk_level = (aggressive, conservative, moderate, very_aggressive, very_conservative)
units = #
ytd_return = #:(-100..500)

; ═══════════════════════════════════════════════════════════════════════════════
; Surrender Schedule
; ═══════════════════════════════════════════════════════════════════════════════
; Surrender charge schedule for cash value life and annuities
; Typically decreasing over time

{@surrender_schedule}
; Required fields
effective = date                             ; Schedule effective date

; Optional fields
free_withdrawal_percent = #:(0..100)
free_withdrawal_amount = #$:(0..)
market_value_adjustment = ?                   ; MVA applies to surrenders

; ───────────────────────────────────────────────────────────────────────────────
; Surrender Charge by Year
; ───────────────────────────────────────────────────────────────────────────────
{@surrender_schedule.years[]}
year = ##:(1..20)                            ; Policy/contract year
charge_percent = #:(0..25)                   ; Surrender charge percentage

; ═══════════════════════════════════════════════════════════════════════════════
; Premium Payment
; ═══════════════════════════════════════════════════════════════════════════════
; Premium or purchase payment record
; Used by both life (premiums) and annuity (contributions)

{@premium_payment}
; Required fields
amount = #$:(0..)                                  ; Payment amount
date = date                                  ; Payment date

; Optional fields
account_last_four = *:(4)                     ; Last 4 digits of payment account
allocated = ?                                 ; Payment has been allocated
id = :                                        ; Payment identifier
method = (ach, check, credit_card, eft, payroll_deduction, wire)
nsf = ?
reference = :                                 ; Payment reference number
returned = ?                                  ; Payment was returned
source = (1035_exchange, direct, employer, rollover)
status = (applied, pending, returned)

; ═══════════════════════════════════════════════════════════════════════════════
; Policy Loan
; ═══════════════════════════════════════════════════════════════════════════════
; Loans against cash value (whole life, universal life)

{@policy_loan}
; Required fields
amount = #$:(0..)                                  ; Original loan amount
date = date                                  ; Loan date

; Optional fields
accrued_interest = #$:(0..)
balance = #$:(0..)
capitalized_interest = #$:(0..)
id = :                                        ; Loan identifier
interest_rate = #:(0..15)
paid_off = date                               ; Date loan was paid off
status = (active, defaulted, paid)

; ═══════════════════════════════════════════════════════════════════════════════
; Rider Base Type
; ═══════════════════════════════════════════════════════════════════════════════
; Base type for all riders (life and annuity extend this)

{@rider}
; Required fields
effective = date                             ; Rider effective date
name = :                                     ; Rider name
type = :                                     ; Rider type code

; Optional fields
annual_cost = #$:(0..)
benefit_amount = #$:(0..)
declined = ?                                  ; Rider was offered and declined
expiration = date                             ; Rider expiration date
id = :                                        ; Rider identifier
removed = date                                ; Date rider was removed
status = (active, expired, pending, removed, suspended)
waived = ?                                    ; Rider fee waived

; ═══════════════════════════════════════════════════════════════════════════════
; Owner/Annuitant/Insured Party Types
; ═══════════════════════════════════════════════════════════════════════════════
; Party types specific to life and annuity products

{@life_party}
= @party.person

; Required fields
role = (annuitant, insured, joint_annuitant, joint_owner, owner, payor)  ; Party role

; Optional fields
age_at_issue = ##:(0..100)                    ; Age when policy or contract issued
issue_state = :(2)                            ; State of issue for party
medical_records_authorization = *?            ; Authorized medical records access
ownership_percent = #:(0..100)
smoker = *?                                   ; Smoker status at issue

; ═══════════════════════════════════════════════════════════════════════════════
; Tax Information (1035 Exchange, RMD, etc.)
; ═══════════════════════════════════════════════════════════════════════════════

{@tax_info}
; Tax qualification
qualified = ?                                 ; Qualified plan (IRA, 401k, etc.)
qualification_type = (403b, 457, ira_roth, ira_sep, ira_simple, ira_traditional, non_qualified, pension, profit_sharing)  ; Qualification type

; 1035 Exchange
exchange_1035 = ?                             ; Product received via 1035 exchange
exchange_1035_carrier = :                     ; Prior carrier name
exchange_1035_contract = :                    ; Prior contract number
exchange_1035_date = date                     ; Exchange date

; Cost Basis
cost_basis = #$:(0..)                               ; Investment in the contract
cost_basis_date = date                        ; Date cost basis established

; RMD (Required Minimum Distribution)
rmd_applicable = ?                            ; Subject to RMD rules
rmd_calculated = #$:(0..)                           ; Calculated RMD amount
rmd_deadline = date                           ; RMD deadline date
rmd_satisfied = ?                             ; RMD satisfied for year

; ═══════════════════════════════════════════════════════════════════════════════
; Index Strategy (Shared by FIA and IUL)
; ═══════════════════════════════════════════════════════════════════════════════
; Index crediting strategy used by both indexed annuities and indexed universal life

{@index_strategy}
; Required fields
name = :                                     ; Strategy name
strategy_type = (buffer, fixed, indexed, performance_triggered)  ; Strategy type

; ───────────────────────────────────────────────────────────────────────────────
; Index Information
; ───────────────────────────────────────────────────────────────────────────────
index = (barclays_aggregate, custom, euro_stoxx_50, msci_eafe, nasdaq_100, russell_2000, sp_500)  ; Tracked index
index_ticker = :                              ; Index ticker symbol

; ───────────────────────────────────────────────────────────────────────────────
; Crediting Method
; ───────────────────────────────────────────────────────────────────────────────
crediting_method = (annual_point_to_point, biennial, daily_averaging, monthly_averaging, monthly_point_to_point, monthly_sum, performance_triggered, spread, two_year_point_to_point)  ; How interest is calculated

; ───────────────────────────────────────────────────────────────────────────────
; Strategy Rates and Caps
; ───────────────────────────────────────────────────────────────────────────────
{.rates}
; Cap (maximum credit)
cap_type = (annual, none, segment, term)      ; Type of cap
cap_rate = #:(0..50)                          ; Cap rate percentage
current_cap = #:(0..50)                       ; Current cap rate
guaranteed_cap = #:(0..50)                    ; Guaranteed minimum cap

; Floor (minimum credit)
floor_rate = #:(-30..5)                       ; Floor rate (often 0%)
guaranteed_floor = #:(-30..5)                 ; Guaranteed minimum floor

; Participation rate
participation_rate = #:(0..500)               ; Participation in index gains
guaranteed_participation = #:(0..500)         ; Guaranteed minimum participation

; Spread/Margin
spread = #:(0..10)                            ; Spread deducted from gains
guaranteed_spread = #:(0..10)                 ; Guaranteed maximum spread

{@index_strategy}

; ───────────────────────────────────────────────────────────────────────────────
; Segment/Term Information
; ───────────────────────────────────────────────────────────────────────────────
{.segment}
allocation_amount = #$:(0..)                        ; Amount allocated to this strategy
allocation_percent = #:(0..100)               ; Percentage of contract in strategy
current_value = #$:(0..)                            ; Current segment value
segment_length_months = ##:(6..84)            ; Segment term length
segment_effective = date                      ; Current segment effective date
segment_expiration = date                     ; Current segment expiration date

{@index_strategy}

; ───────────────────────────────────────────────────────────────────────────────
; Performance Tracking
; ───────────────────────────────────────────────────────────────────────────────
{.performance}
index_start_value = #                         ; Index value at segment start
index_current_value = #                       ; Current index value
index_change_percent = #:(-100..1000)         ; Index change percentage
credited_interest = #$:(0..)                        ; Interest credited this segment
interim_value = #$:(0..)                            ; Interim (if surrendered today)
ytd_index_return = #:(-100..500)              ; Year-to-date index return

{@index_strategy}

; ───────────────────────────────────────────────────────────────────────────────
; Historical Segments
; ───────────────────────────────────────────────────────────────────────────────
segment_history[] = @segment_result           ; Completed segment history

{@segment_result}
effective = date                             ; Segment effective date
expiration = date                            ; Segment expiration date
cap_rate = #:(0..50)                          ; Cap rate for segment
credited_amount = #$:(0..)                          ; Interest credited
floor_rate = #:(-30..5)                       ; Floor rate for segment
index_return = #:(-100..1000)                 ; Raw index return
participation_rate = #:(0..500)               ; Participation rate
starting_value = #$:(0..)                           ; Segment starting value

; ═══════════════════════════════════════════════════════════════════════════════
; Common Status Enums
; ═══════════════════════════════════════════════════════════════════════════════

{@life_policy_status}
; Life policy status (workflow progression)
status = (pending, applied, underwriting, approved, declined, issued, delivered, free_look, in_force, grace, lapsed, reinstated, reduced_paid_up, paid_up, matured, surrendered, terminated, not_taken)

{@annuity_contract_status}
; Annuity contract status (workflow progression)
status = (pending, applied, underwriting, approved, declined, issued, delivered, free_look, in_force, matured, surrendered, terminated)

{@claim_status}
; Life/annuity claim status (workflow progression)
status = (reported, documentation_requested, documentation_received, under_review, approved, denied, contested, paid)

; ═══════════════════════════════════════════════════════════════════════════════
; Life Insurance Illustration
; ═══════════════════════════════════════════════════════════════════════════════
; Policy illustration/ledger showing year-by-year projections
; Required for life insurance sales (NAIC Illustration Model Regulation)

{@life_illustration}
; Required fields
illustration_date = date                     ; Date illustration generated
policy_number = :                             ; Policy number (if in force)
product_name = :                             ; Product name
version = :                                  ; Illustration software version

; ───────────────────────────────────────────────────────────────────────────────
; Illustration Assumptions
; ───────────────────────────────────────────────────────────────────────────────
{.assumptions}
death_benefit = #$:(0..)                            ; Initial death benefit
face_amount = #$:(0..)                              ; Face amount
initial_premium = #$:(0..)                          ; Initial/planned premium
insured_age = ##:(0..100)                     ; Insured age at issue
insured_gender = (female, male)               ; Insured gender
insured_tobacco = (non_tobacco, tobacco)      ; Tobacco class
rating_class = :                              ; Underwriting class assumed
state = :(2)                                  ; State of issue

{@life_illustration}

; ───────────────────────────────────────────────────────────────────────────────
; Interest Rate Scenarios (for UL/IUL/VUL)
; ───────────────────────────────────────────────────────────────────────────────
{.rate_scenarios}
guaranteed_rate = #:(0..10)                   ; Guaranteed minimum rate
current_rate = #:(0..15)                      ; Current declared/assumed rate
midpoint_rate = #:(0..15)                     ; Midpoint illustration rate
alternate_rate = #:(0..15)                    ; Alternate scenario rate

{@life_illustration}

; ───────────────────────────────────────────────────────────────────────────────
; Illustration Ledger (Year-by-Year)
; ───────────────────────────────────────────────────────────────────────────────
guaranteed_ledger[] = @life_ledger_row        ; Guaranteed values
current_ledger[] = @life_ledger_row           ; Current/illustrated values
midpoint_ledger[] = @life_ledger_row          ; Midpoint scenario
alternate_ledger[] = @life_ledger_row         ; Alternate scenario

; ───────────────────────────────────────────────────────────────────────────────
; Summary Values
; ───────────────────────────────────────────────────────────────────────────────
{.summary}
total_premiums_to_age_65 = #$:(0..)                 ; Total premiums to age 65
total_premiums_to_age_100 = #$:(0..)                ; Total premiums to age 100/121
cash_value_at_age_65 = #$:(0..)                     ; Cash value at 65 (current)
cash_value_at_age_100 = #$:(0..)                    ; Cash value at 100 (current)
death_benefit_at_age_65 = #$:(0..)                  ; Death benefit at 65
death_benefit_at_age_100 = #$:(0..)                 ; Death benefit at 100
lapse_year_guaranteed = ##:(0..100)           ; Year policy lapses (guaranteed)
lapse_year_current = ##:(0..100)              ; Year policy lapses (current)

{@life_illustration}

{@life_ledger_row}
; Required fields
year = ##:(1..)                              ; Policy year
age = ##:(0..121)                            ; Attained age

; Premium
annual_premium = #$:(0..)                           ; Annual premium paid
cumulative_premium = #$:(0..)                       ; Cumulative premiums paid

; Cash Values
beginning_cash_value = #$:(0..)                     ; BOY cash value
end_of_year_cash_value = #$:(0..)                   ; EOY cash value
cash_surrender_value = #$:(0..)                     ; Net cash surrender value

; Death Benefit
death_benefit = #$:(0..)                            ; Death benefit
net_death_benefit = #$:(0..)                        ; Net DB after loans

; Policy Charges (UL/VUL)
coi_charge = #$:(0..)                               ; Cost of insurance
admin_charge = #$:(0..)                             ; Administrative charges
rider_charges = #$:(0..)                            ; Rider charges
total_charges = #$:(0..)                            ; Total annual charges

; Credits
interest_credited = #$:(0..)                        ; Interest/earnings credited

; Loans (if applicable)
loan_balance = #$:(0..)                             ; Outstanding loan balance
loan_interest = #$:(0..)                            ; Loan interest accrued

; Dividends (whole life)
dividend = #$:(0..)                                 ; Annual dividend
cumulative_dividends = #$:(0..)                     ; Cumulative dividends

; ═══════════════════════════════════════════════════════════════════════════════
; Annuity Illustration
; ═══════════════════════════════════════════════════════════════════════════════
; Annuity illustration showing accumulation and income projections

{@annuity_illustration}
; Required fields
illustration_date = date                     ; Date illustration generated
contract_number = :                           ; Contract number (if in force)
product_name = :                             ; Product name
version = :                                  ; Illustration software version

; ───────────────────────────────────────────────────────────────────────────────
; Illustration Assumptions
; ───────────────────────────────────────────────────────────────────────────────
{.assumptions}
initial_premium = #$:(0..)                          ; Initial purchase payment
owner_age = ##:(0..100)                       ; Owner age at issue
annuitant_age = ##:(0..100)                   ; Annuitant age at issue
state = :(2)                                  ; State of issue
product_type = (fixed, indexed, structured, variable)  ; Product type

{@annuity_illustration}

; ───────────────────────────────────────────────────────────────────────────────
; Rate/Return Scenarios
; ───────────────────────────────────────────────────────────────────────────────
{.rate_scenarios}
; Fixed annuity
guaranteed_rate = #:(0..10)                   ; Guaranteed minimum rate
current_rate = #:(0..10)                      ; Current declared rate

; Variable/indexed scenarios
low_return = #:(-5..10)                       ; Low return scenario
mid_return = #:(0..15)                        ; Mid return scenario
high_return = #:(5..20)                       ; High return scenario

{@annuity_illustration}

; ───────────────────────────────────────────────────────────────────────────────
; Accumulation Phase Ledger
; ───────────────────────────────────────────────────────────────────────────────
guaranteed_accumulation[] = @annuity_ledger_row  ; Guaranteed accumulation
current_accumulation[] = @annuity_ledger_row     ; Current/assumed accumulation
low_accumulation[] = @annuity_ledger_row         ; Low scenario (variable)
mid_accumulation[] = @annuity_ledger_row         ; Mid scenario (variable)
high_accumulation[] = @annuity_ledger_row        ; High scenario (variable)

; ───────────────────────────────────────────────────────────────────────────────
; Income Phase Projections
; ───────────────────────────────────────────────────────────────────────────────
{.income_projections}
annuitization_age = ##:(50..95)               ; Assumed annuitization age
payout_option = :                             ; Assumed payout option
; Monthly income at various start ages
income_at_60 = #$:(0..)                             ; Projected income at age 60
income_at_65 = #$:(0..)                             ; Projected income at age 65
income_at_70 = #$:(0..)                             ; Projected income at age 70
income_at_75 = #$:(0..)                             ; Projected income at age 75

{@annuity_illustration}

; ───────────────────────────────────────────────────────────────────────────────
; Living Benefit Projections (GLWB)
; ───────────────────────────────────────────────────────────────────────────────
{.glwb_projections}
benefit_base_year_5 = #$:(0..)                      ; Benefit base at year 5
benefit_base_year_10 = #$:(0..)                     ; Benefit base at year 10
annual_withdrawal_at_65 = #$:(0..)                  ; Annual withdrawal at 65
annual_withdrawal_at_70 = #$:(0..)                  ; Annual withdrawal at 70

{@annuity_illustration}

; ───────────────────────────────────────────────────────────────────────────────
; Summary Values
; ───────────────────────────────────────────────────────────────────────────────
{.summary}
total_contributions = #$:(0..)                      ; Total planned contributions
value_at_year_5 = #$:(0..)                          ; Contract value at year 5
value_at_year_10 = #$:(0..)                         ; Contract value at year 10
value_at_annuitization = #$:(0..)                   ; Value at annuitization age
surrender_charge_period_end = date            ; When surrender charges end

{@annuity_illustration}

{@annuity_ledger_row}
; Required fields
year = ##:(1..50)                            ; Contract year
age = ##:(0..121)                            ; Owner/annuitant age

; Contributions
annual_contribution = #$:(0..)                      ; Annual contribution
cumulative_contributions = #$:(0..)                 ; Cumulative contributions

; Contract Values
beginning_value = #$:(0..)                          ; BOY contract value
end_of_year_value = #$:(0..)                        ; EOY contract value
surrender_value = #$:(0..)                          ; Net surrender value
death_benefit = #$:(0..)                            ; Death benefit value

; Credits/Returns
interest_credited = #$:(0..)                        ; Interest/earnings credited
index_credit = #$:(0..)                             ; Index credit (FIA/RILA)
investment_gain_loss = #$                     ; Investment gain/loss (VA) - can be negative

; Charges
surrender_charge = #$:(0..)                         ; Surrender charge if withdrawn
surrender_charge_percent = #:(0..25)          ; Surrender charge percentage
admin_charges = #$:(0..)                            ; Administrative charges
rider_charges = #$:(0..)                            ; Rider/guarantee charges
m_and_e_charge = #$:(0..)                           ; M&E charge (VA)
total_charges = #$:(0..)                            ; Total annual charges

; Living Benefit Values (if applicable)
benefit_base = #$:(0..)                             ; GLWB benefit base
available_withdrawal = #$:(0..)                     ; Available annual withdrawal

; Free Withdrawal
free_withdrawal_available = #$:(0..)                ; Free withdrawal amount


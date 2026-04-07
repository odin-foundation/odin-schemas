; ═══════════════════════════════════════════════════════════════════════════════
; ODIN HOA Dues and Assessment Schema
; ═══════════════════════════════════════════════════════════════════════════════
; HOA dues, assessments, and financial management including regular and special
; assessments, budget allocations, owner account ledgers, payment plans, and
; delinquency tracking. Also covers reserve fund studies, funding projections,
; and component-level replacement planning.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as common
@import "../types.schema.odin" as re

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.realestate.hoa.dues"
version = "1.0.0"
title = "HOA Dues and Assessment Schema"
description = "HOA assessment, dues, and financial management"

{$derivation}
source[0].authority = "Community Associations Institute"
source[0].citation = "Reserve Studies and Funding"
source[0].url = "https://www.caionline.org/"

source[1].authority = "Association of Professional Reserve Analysts"
source[1].citation = "National Reserve Study Standards"
source[1].url = "https://www.apra-usa.com/"

source[2].authority = "State HOA Statutes"
source[2].citation = "Assessment and Collection Laws"
source[2].url = "https://www.law.cornell.edu/wex/homeowners_association"

methodology = "industry_practice"
proprietary_sources_consulted = ?false
notes = "Dues schema derived from CAI standards and state collection laws"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial dues schema"
changelog[0].rationale = "Comprehensive HOA financial structure"

; ═══════════════════════════════════════════════════════════════════════════════
; ASSESSMENT SCHEDULE
; ═══════════════════════════════════════════════════════════════════════════════
; Association assessment schedule

{@assessment_schedule}
; Required fields first
effective_date = !date                               ; Effective date
fiscal_year = !##:(2000..2100)                       ; Fiscal year

; Schedule identification
schedule_id = :                                      ; Unique schedule identifier

; Association reference
association_ref = @association                       ; Reference to association

; ───────────────────────────────────────────────────────────────────────────────
; Regular Assessments
; ───────────────────────────────────────────────────────────────────────────────
{.regular}
base_assessment = #$:(0..)                           ; Base monthly assessment
frequency = (annual, monthly, quarterly, semi_annual)
due_day = ##:(1..31)                                 ; Day of month due
grace_period_days = ##:(0..30)                       ; Grace period
late_fee_type = (fixed, percent)                     ; Late fee type
late_fee_amount = #$:(0..):if late_fee_type = fixed  ; Fixed late fee
late_fee_percent = #:(0..100):if late_fee_type = percent
interest_rate = #:(0..100)                           ; Annual interest rate
interest_compounds = (daily, monthly, none)          ; Interest compounding

{@assessment_schedule}

; Assessment tiers (if variable by unit type)
{.regular.tiers[]}
tier_name = :                                        ; Tier name/description
unit_types[] = :                                     ; Applicable unit types
assessment_amount = #$:(0..)                         ; Assessment for this tier

{@assessment_schedule}

; ───────────────────────────────────────────────────────────────────────────────
; Budget Allocation
; ───────────────────────────────────────────────────────────────────────────────
{.budget}
total_operating_budget = #$:(0..)                    ; Total operating budget
reserve_contribution = #$:(0..)                      ; Monthly reserve contribution
reserve_percent = #:(0..100)                         ; Reserve as % of budget

{@assessment_schedule}

; Operating expense categories
{.budget.categories[]}
category = (administration, common_area, insurance, landscaping, legal, management, pool, repairs, security, trash, utilities)
annual_amount = #$:(0..)                             ; Annual budgeted amount
monthly_amount = #$:(0..)                            ; Monthly allocation
percent_of_budget = #:(0..100)                       ; Percentage of total

{@assessment_schedule}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, approved, draft, superseded)
approval_date = date:if status = approved | status = active
approved_by = ::if status = approved | status = active

; ═══════════════════════════════════════════════════════════════════════════════
; SPECIAL ASSESSMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Special assessment levy

{@special_assessment}
; Required fields first
assessment_name = !:                                 ; Assessment name/description
effective_date = !date                               ; Effective date
total_amount = !#$:(0..)                             ; Total assessment amount

; Assessment identification
assessment_id = :                                    ; Unique assessment identifier

; Association reference
association_ref = @association                       ; Reference to association

; ───────────────────────────────────────────────────────────────────────────────
; Assessment Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
purpose = :                                          ; Purpose of assessment
assessment_type = (capital_improvement, deferred_maintenance, emergency, legal, reserve_funding)
approved_date = date                                 ; Board/member approval date
approval_method = (board_only, member_vote)          ; How approved
vote_percentage = #:(0..100):if approval_method = member_vote
member_notice_date = date                            ; Notice to members

{@special_assessment}

; ───────────────────────────────────────────────────────────────────────────────
; Payment Terms
; ───────────────────────────────────────────────────────────────────────────────
{.payment}
payment_method = (lump_sum, installment)             ; Payment method
installments = ##:(1..):if payment_method = installment
installment_amount = #$:(0..):if payment_method = installment
first_due_date = date                                ; First payment due
final_due_date = date                                ; Final payment due
prepay_discount = ?                                  ; Prepayment discount
discount_percent = #:(0..100):if prepay_discount = true
discount_deadline = date:if prepay_discount = true

{@special_assessment}

; ───────────────────────────────────────────────────────────────────────────────
; Unit Allocation
; ───────────────────────────────────────────────────────────────────────────────
{.allocation}
allocation_method = (equal_share, percentage_interest, sqft, unit_type)
per_unit_amount = #$:(0..):if allocation_method = equal_share

{@special_assessment}

; Variable allocations by unit
{.allocation.units[]}
unit_number = :                                      ; Unit number
unit_address = @address                              ; Unit address
allocated_amount = #$:(0..)                          ; Amount allocated
paid_amount = #$:(0..)                               ; Amount paid
balance = #$:(0..)                                   ; Remaining balance
status = (delinquent, paid, partial, unpaid)

{@special_assessment}

; ───────────────────────────────────────────────────────────────────────────────
; Collection Status
; ───────────────────────────────────────────────────────────────────────────────
{.collection}
total_billed = #$:(0..)                              ; Total billed
total_collected = #$:(0..)                           ; Total collected
total_outstanding = #$:(0..)                         ; Outstanding balance
collection_rate = #:(0..100)                         ; Collection percentage
units_paid_full = ##:(0..)                           ; Units paid in full
units_delinquent = ##:(0..)                          ; Units delinquent

{@special_assessment}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, cancelled, completed, pending)
status_date = date                                   ; Status date

; ═══════════════════════════════════════════════════════════════════════════════
; OWNER ACCOUNT
; ═══════════════════════════════════════════════════════════════════════════════
; Individual owner account ledger

{@owner_account}
; Required fields first
owner_name = !:                                      ; Owner name
unit_number = !:                                     ; Unit number

; Account identification
account_id = :                                       ; Unique account identifier
account_number = *:                                   ; Account number

; Unit reference
unit_ref = @association_unit                         ; Reference to unit

; ───────────────────────────────────────────────────────────────────────────────
; Balance Summary
; ───────────────────────────────────────────────────────────────────────────────
{.balance}
current_balance = #$                                 ; Current balance (credit if negative)
regular_balance = #$                                 ; Regular assessment balance
special_balance = #$                                 ; Special assessment balance
late_fees = #$:(0..)                                 ; Late fees owed
interest = #$:(0..)                                  ; Interest owed
legal_fees = #$:(0..)                                ; Legal fees owed
fines = #$:(0..)                                     ; Fines owed
other_charges = #$:(0..)                             ; Other charges
credits = #$:(0..)                                   ; Credits on account
last_statement_date = date                           ; Last statement date
last_statement_balance = #$                          ; Balance on last statement

{@owner_account}

; ───────────────────────────────────────────────────────────────────────────────
; Payment History
; ───────────────────────────────────────────────────────────────────────────────
{.payments[]}
payment_date = date                                  ; Payment date
payment_amount = #$:(0..)                            ; Payment amount
payment_method = (ach, cash, check, credit_card, money_order, online)
reference_number = :                                 ; Check/reference number
applied_to = (fines, interest, late_fees, legal, other, regular, special)
applied_period = :                                   ; Period applied to
received_by = :                                      ; Received by

{@owner_account}

; ───────────────────────────────────────────────────────────────────────────────
; Charge History
; ───────────────────────────────────────────────────────────────────────────────
{.charges[]}
charge_date = date                                   ; Charge date
charge_type = (fine, interest, late_fee, legal, other, regular, special)
description = :                                      ; Charge description
amount = #$:(0..)                                    ; Charge amount
period = :                                           ; Period covered
due_date = date                                      ; Due date

{@owner_account}

; ───────────────────────────────────────────────────────────────────────────────
; Payment Plan
; ───────────────────────────────────────────────────────────────────────────────
{.payment_plan}
active = ?                                           ; Payment plan active
plan_start_date = date:if active = true              ; Plan start date
plan_end_date = date:if active = true                ; Plan end date
original_balance = #$:(0..):if active = true         ; Original balance
payment_amount = #$:(0..):if active = true           ; Monthly payment
payment_due_day = ##:(1..31):if active = true        ; Day of month due
payments_made = ##:(0..):if active = true            ; Payments made
payments_remaining = ##:(0..):if active = true       ; Payments remaining
current_on_plan = ?:if active = true                 ; Current on plan

{@owner_account}

; ───────────────────────────────────────────────────────────────────────────────
; Auto-Pay
; ───────────────────────────────────────────────────────────────────────────────
{.autopay}
enrolled = ?                                         ; Auto-pay enrolled
payment_method = (ach, credit_card):if enrolled = true
account_last_four = ::if enrolled = true             ; Last 4 digits
bank_name = ::if enrolled = true                     ; Bank name
process_day = ##:(1..28):if enrolled = true          ; Day to process
enrollment_date = date:if enrolled = true            ; Enrollment date

{@owner_account}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (collection, current, delinquent, foreclosure, legal, lien_filed, payment_plan)
status_date = date                                   ; Status date
days_delinquent = ##:(0..)                           ; Days past due
months_delinquent = ##:(0..)                         ; Months delinquent

; ═══════════════════════════════════════════════════════════════════════════════
; DELINQUENCY
; ═══════════════════════════════════════════════════════════════════════════════
; Delinquent account management

{@delinquency}
; Required fields first
delinquent_amount = !#$:(0..)                        ; Amount delinquent
delinquent_since = !date                             ; Date became delinquent
unit_number = !:                                     ; Unit number

; Delinquency identification
delinquency_id = :                                   ; Unique identifier

; Account reference
account_ref = @owner_account                         ; Reference to account

; ───────────────────────────────────────────────────────────────────────────────
; Delinquency Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
principal_owed = #$:(0..)                            ; Principal assessments owed
late_fees = #$:(0..)                                 ; Late fees
interest = #$:(0..)                                  ; Interest
legal_fees = #$:(0..)                                ; Legal fees
other_charges = #$:(0..)                             ; Other charges
total_owed = #$:(0..)                                ; Total amount owed
months_delinquent = ##:(0..)                         ; Months delinquent
last_payment_date = date                             ; Last payment date
last_payment_amount = #$:(0..)                       ; Last payment amount

{@delinquency}

; ───────────────────────────────────────────────────────────────────────────────
; Collection Actions
; ───────────────────────────────────────────────────────────────────────────────
{.actions[]}
action_date = date                                   ; Action date
action_type = (collection_agency, demand_letter, foreclosure_filed, hearing_notice, intent_to_lien, lien_filed, lien_foreclosure, payment_plan, personal_contact, pre_lien_letter)
description = :                                      ; Action description
performed_by = :                                     ; Performed by
response_required = ?                                ; Response required
response_deadline = date:if response_required = true
response_received = ?:if response_required = true
response_date = date:if response_received = true
result = :                                           ; Result/outcome

{@delinquency}

; ───────────────────────────────────────────────────────────────────────────────
; Lien Information
; ───────────────────────────────────────────────────────────────────────────────
{.lien}
lien_filed = ?                                       ; Lien filed
lien_date = date:if lien_filed = true                ; Lien filing date
lien_amount = #$:(0..):if lien_filed = true          ; Lien amount
recording_number = ::if lien_filed = true            ; Recording number
super_lien = ?:if lien_filed = true                  ; Super-priority lien
super_lien_amount = #$:(0..):if super_lien = true    ; Super-lien amount
foreclosure_filed = ?                                ; Foreclosure filed
foreclosure_date = date:if foreclosure_filed = true  ; Foreclosure date
case_number = ::if foreclosure_filed = true          ; Court case number

{@delinquency}

; ───────────────────────────────────────────────────────────────────────────────
; Attorney/Collection Agency
; ───────────────────────────────────────────────────────────────────────────────
{.collection}
referred = ?                                         ; Referred for collection
referral_date = date:if referred = true              ; Referral date
collector_type = (agency, attorney):if referred = true
collector_name = ::if referred = true                ; Collector name
collector_phone = @phone:if referred = true          ; Phone
collector_email = @email:if referred = true          ; Email
collector_fees = #$:(0..):if referred = true         ; Collection fees

{@delinquency}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, bankruptcy, collection, foreclosure, legal, lien, paid, payment_plan, write_off)
status_date = date                                   ; Status date
resolution_date = date:if status = paid              ; Resolution date
resolution_amount = #$:(0..):if status = paid        ; Resolution amount

; ═══════════════════════════════════════════════════════════════════════════════
; RESERVE FUND
; ═══════════════════════════════════════════════════════════════════════════════
; Reserve fund and reserve study

{@reserve_fund}
; Required fields first
current_balance = !#$:(0..)                          ; Current reserve balance
fiscal_year = !##:(2000..2100)                       ; Fiscal year

; Reserve identification
reserve_id = :                                       ; Unique identifier

; Association reference
association_ref = @association                       ; Reference to association

; ───────────────────────────────────────────────────────────────────────────────
; Reserve Study
; ───────────────────────────────────────────────────────────────────────────────
{.study}
study_date = date                                    ; Reserve study date
study_company = :                                    ; Study provider
study_type = (full, update_with_site, update_without_site)
analyst_credentials = :                              ; Analyst credentials
next_study_due = date                                ; Next study due date

{@reserve_fund}

; ───────────────────────────────────────────────────────────────────────────────
; Funding Status
; ───────────────────────────────────────────────────────────────────────────────
{.funding}
fully_funded_balance = #$:(0..)                      ; Fully funded balance
current_balance = #$:(0..)                           ; Current balance
percent_funded = #:(0..100)                          ; Percent funded
funding_method = (baseline, cash_flow, full_funding, statutory)
monthly_contribution = #$:(0..)                      ; Monthly contribution
recommended_contribution = #$:(0..)                  ; Recommended contribution
contribution_adequate = ?                            ; Contribution adequate

{@reserve_fund}

; ───────────────────────────────────────────────────────────────────────────────
; Reserve Components
; ───────────────────────────────────────────────────────────────────────────────
{.components[]}
component_name = :                                   ; Component name
category = (common_area, electrical, envelope, landscaping, mechanical, pavement, plumbing, pool, recreation, roofing, structural)
useful_life_years = ##:(1..)                         ; Useful life
remaining_life_years = ##:(0..)                      ; Remaining life
current_cost = #$:(0..)                              ; Current replacement cost
future_cost = #$:(0..)                               ; Future replacement cost
last_replaced = date                                 ; Last replacement date
next_replacement = date                              ; Next scheduled replacement
annual_reserve_allocation = #$:(0..)                 ; Annual reserve allocation
percent_of_total = #:(0..100)                        ; Percent of total reserves

{@reserve_fund}

; ───────────────────────────────────────────────────────────────────────────────
; Expenditures
; ───────────────────────────────────────────────────────────────────────────────
{.expenditures[]}
expenditure_date = date                              ; Expenditure date
component = :                                        ; Component name
description = :                                      ; Description
vendor = :                                           ; Vendor name
amount = #$:(0..)                                    ; Amount spent
planned = ?                                          ; Planned vs. unplanned
board_approval_date = date                           ; Board approval date

{@reserve_fund}

; ───────────────────────────────────────────────────────────────────────────────
; 30-Year Projection
; ───────────────────────────────────────────────────────────────────────────────
{.projection[]}
year = ##:(2000..2100)                               ; Projection year
beginning_balance = #$:(0..)                         ; Beginning balance
contributions = #$:(0..)                             ; Contributions
interest_earned = #$:(0..)                           ; Interest earned
expenditures = #$:(0..)                              ; Expenditures
ending_balance = #$:(0..)                            ; Ending balance
percent_funded = #:(0..100)                          ; Percent funded

{@reserve_fund}

; ───────────────────────────────────────────────────────────────────────────────
; Investment Information
; ───────────────────────────────────────────────────────────────────────────────
{.investment}
bank_name = :                                        ; Bank name
account_type = (cd, money_market, savings)           ; Account type
interest_rate = #:(0..100)                           ; Interest rate
fdic_insured = ?                                     ; FDIC insured
collateralized = ?:if fdic_insured = false           ; Collateralized if over limit
maturity_date = date:if account_type = cd            ; CD maturity date

{@reserve_fund}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (adequate, critical, marginal, strong)
status_date = date                                   ; Status date


; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Commercial Property Valuation Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Investment-grade commercial property valuation using income approach methods
; including direct capitalization, discounted cash flow (DCF), gross rent
; multiplier, and band of investment analysis. Covers NOI projections, cap
; rate analysis, and sensitivity modeling.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as common
@import "../types.schema.odin" as re

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.realestate.valuation.commercial"
version = "1.0.0"
title = "Commercial Property Valuation Schema"
description = "Investment-grade commercial property valuation and analysis"

{$derivation}
source[0].authority = "Appraisal Institute"
source[0].citation = "The Appraisal of Real Estate, 15th Edition"
source[0].url = "https://www.appraisalinstitute.org/"

source[1].authority = "NCREIF"
source[1].citation = "NCREIF Property Index Methodology"
source[1].url = "https://www.ncreif.org/"

source[2].authority = "Urban Land Institute"
source[2].citation = "Real Estate Market Analysis"
source[2].url = "https://uli.org/"

source[3].authority = "CCIM Institute"
source[3].citation = "Commercial Investment Real Estate Analysis"
source[3].url = "https://www.ccim.com/"

methodology = "industry_practice"
proprietary_sources_consulted = ?false
notes = "Commercial valuation schema derived from appraisal and investment industry standards"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial commercial valuation schema"
changelog[0].rationale = "Investment-grade valuation structure"

; ═══════════════════════════════════════════════════════════════════════════════
; COMMERCIAL VALUATION
; ═══════════════════════════════════════════════════════════════════════════════
; Comprehensive commercial property valuation

{@commercial_valuation}
; Required fields first
effective_date = date                               ; Valuation effective date
indicated_value = #$:(0..)                          ; Indicated/concluded value
property_address = @address                         ; Subject property address

; Valuation identification
valuation_id = :                                     ; Unique valuation identifier

; Property reference
property_ref = :                                     ; Reference to commercial property

; ───────────────────────────────────────────────────────────────────────────────
; Property Summary
; ───────────────────────────────────────────────────────────────────────────────
{.property}
property_type = (healthcare, hospitality, industrial, mixed_use, multifamily, office, retail, self_storage, special_purpose)
property_subtype = :                                 ; Detailed subtype
year_built = ##:(1600..2100)                         ; Year built
effective_age = ##:(0..)                             ; Effective age
remaining_economic_life = ##:(0..)                   ; Remaining economic life
gla = ##:(0..)                                       ; Gross leasable area
nra = ##:(0..)                                       ; Net rentable area
units = ##:(0..)                                     ; Number of units (if applicable)
floors = ##:(0..)                                    ; Number of floors
land_area_sqft = ##:(0..)                            ; Land area
land_area_acres = #:(0..)                            ; Land area in acres
far = #:(0..)                                        ; Floor area ratio
lot_coverage = #:(0..100)                            ; Lot coverage percentage
parking_ratio = #:(0..)                              ; Parking spaces per 1000 sf
condition = (average, excellent, fair, good, poor)
quality = (a_class, b_class, c_class, institutional, trophy)

{@commercial_valuation}

; ───────────────────────────────────────────────────────────────────────────────
; Tenancy Summary
; ───────────────────────────────────────────────────────────────────────────────
{.tenancy}
total_tenants = ##:(0..)                             ; Number of tenants
occupied_sqft = ##:(0..)                             ; Occupied square feet
vacant_sqft = ##:(0..)                               ; Vacant square feet
occupancy_rate = #:(0..100)                          ; Occupancy percentage
walt = #:(0..)                                       ; Weighted avg lease term (years)
average_rent_psf = #$:(0..)                          ; Average rent per sqft
largest_tenant = :                                   ; Largest tenant name
largest_tenant_sqft = ##:(0..)                       ; Largest tenant sqft
largest_tenant_percent = #:(0..100)                  ; Largest tenant percentage
credit_tenants = ?                                   ; Has credit tenants

{@commercial_valuation}

; Lease expiration schedule
{.tenancy.expirations[]}
year = ##:(2000..2100)                               ; Expiration year
sqft_expiring = ##:(0..)                             ; Square feet expiring
percent_expiring = #:(0..100)                        ; Percentage expiring
tenants_expiring = ##:(0..)                          ; Number of leases expiring

{@commercial_valuation}

; ───────────────────────────────────────────────────────────────────────────────
; Income Analysis (Trailing 12 Months / Pro Forma)
; ───────────────────────────────────────────────────────────────────────────────
{.income}
analysis_type = (pro_forma, trailing_12, year_1)    ; Income period type
analysis_period = :                                  ; Period description

{@commercial_valuation}

; Potential gross income
{.income.pgi}
base_rent = #$:(0..)                                 ; Base rental income
cam_reimbursements = #$:(0..)                        ; CAM reimbursements
tax_reimbursements = #$:(0..)                        ; Tax reimbursements
insurance_reimbursements = #$:(0..)                  ; Insurance reimbursements
utility_reimbursements = #$:(0..)                    ; Utility reimbursements
percentage_rent = #$:(0..)                           ; Percentage rent
parking_income = #$:(0..)                            ; Parking income
other_income = #$:(0..)                              ; Other income
other_income_description = :                         ; Description of other income
total_pgi = #$:(0..)                                 ; Total potential gross income

{@commercial_valuation}

; Vacancy and collection loss
{.income.vacancy}
physical_vacancy_rate = #:(0..100)                   ; Physical vacancy rate
economic_vacancy_rate = #:(0..100)                   ; Economic vacancy rate
collection_loss_rate = #:(0..100)                    ; Collection loss rate
total_vacancy_loss = #$:(0..)                        ; Total vacancy/collection loss

{@commercial_valuation}

; Effective gross income
effective_gross_income = #$:(0..)                    ; EGI

{@commercial_valuation}

; ───────────────────────────────────────────────────────────────────────────────
; Operating Expenses
; ───────────────────────────────────────────────────────────────────────────────
{.expenses}
analysis_type = (actual, pro_forma, stabilized)     ; Expense period type

{@commercial_valuation}

; Fixed expenses
{.expenses.fixed}
real_estate_taxes = #$:(0..)                         ; Real estate taxes
insurance = #$:(0..)                                 ; Property insurance
ground_rent = #$:(0..)                               ; Ground rent (if applicable)
total_fixed = #$:(0..)                               ; Total fixed expenses

{@commercial_valuation}

; Variable expenses
{.expenses.variable}
management_fee = #$:(0..)                            ; Management fee
management_percent = #:(0..100)                      ; Management as % of EGI
utilities = #$:(0..)                                 ; Utilities
repairs_maintenance = #$:(0..)                       ; Repairs and maintenance
janitorial = #$:(0..)                                ; Janitorial/cleaning
security = #$:(0..)                                  ; Security
landscaping = #$:(0..)                               ; Landscaping
administrative = #$:(0..)                            ; Administrative
marketing = #$:(0..)                                 ; Marketing/leasing
legal_accounting = #$:(0..)                          ; Legal and accounting
other_variable = #$:(0..)                            ; Other variable expenses
total_variable = #$:(0..)                            ; Total variable expenses

{@commercial_valuation}

; Summary
{.expenses.summary}
total_operating_expenses = #$:(0..)                  ; Total operating expenses
expense_ratio = #:(0..100)                           ; Expense ratio (% of EGI)
expenses_per_sqft = #$:(0..)                         ; Expenses per sqft
expenses_per_unit = #$:(0..)                         ; Expenses per unit

{@commercial_valuation}

; ───────────────────────────────────────────────────────────────────────────────
; Net Operating Income
; ───────────────────────────────────────────────────────────────────────────────
{.noi}
net_operating_income = #$                            ; NOI (can be negative)
noi_per_sqft = #$                                    ; NOI per sqft
noi_per_unit = #$                                    ; NOI per unit (if applicable)

{@commercial_valuation}

; ───────────────────────────────────────────────────────────────────────────────
; Direct Capitalization
; ───────────────────────────────────────────────────────────────────────────────
{.direct_cap}
approach_used = ?                                    ; Approach developed
stabilized_noi = #$                                  ; Stabilized NOI
overall_cap_rate = #:(0..100)                        ; Overall capitalization rate
indicated_value = #$:(0..)                           ; Value indication
value_per_sqft = #$:(0..)                            ; Value per sqft
value_per_unit = #$:(0..)                            ; Value per unit

{@commercial_valuation}

; Cap rate support
{.direct_cap.cap_rate_support}
derivation_method = (band_of_investment, comparable_sales, debt_coverage, investor_surveys, market_extraction)
mortgage_rate = #:(0..100)                           ; Mortgage interest rate
ltv = #:(0..100)                                     ; Loan to value ratio
mortgage_constant = #:(0..)                          ; Mortgage constant
equity_dividend_rate = #:(0..100)                    ; Equity dividend rate
debt_coverage_ratio = #:(0..)                        ; Debt coverage ratio
comments = :                                         ; Cap rate comments

{@commercial_valuation}

; Comparable cap rates
{.direct_cap.comparables[]}
property_address = @address                          ; Comparable address
sale_date = date                                     ; Sale date
sale_price = #$:(0..)                                ; Sale price
noi = #$                                             ; NOI at sale
cap_rate = #:(0..100)                                ; Implied cap rate
property_type = :                                    ; Property type
year_built = ##:(1600..2100)                         ; Year built
sqft = ##:(0..)                                      ; Square feet
quality = :                                          ; Quality rating
occupancy = #:(0..100)                               ; Occupancy at sale
adjustments = :                                      ; Adjustments made
adjusted_cap_rate = #:(0..100)                       ; Adjusted cap rate

{@commercial_valuation}

; ───────────────────────────────────────────────────────────────────────────────
; Discounted Cash Flow Analysis
; ───────────────────────────────────────────────────────────────────────────────
{.dcf}
approach_used = ?                                    ; Approach developed
projection_period = ##:(1..30)                       ; Holding period years
discount_rate = #:(0..100)                           ; Discount rate
terminal_cap_rate = #:(0..100)                       ; Terminal/reversion cap rate
indicated_value = #$:(0..)                           ; Value indication
irr = #:(0..100)                                     ; Internal rate of return

{@commercial_valuation}

; Assumptions
{.dcf.assumptions}
rent_growth_rate = #                                 ; Annual rent growth %
expense_growth_rate = #                              ; Annual expense growth %
vacancy_assumption = #:(0..100)                      ; Stabilized vacancy %
sale_costs = #:(0..100)                              ; Sale costs %
capital_reserves = #$:(0..)                          ; Annual capital reserves
inflation_rate = #                                   ; Inflation assumption

{@commercial_valuation}

; Cash flow projections
{.dcf.projections[]}
year = ##:(1..)                                      ; Projection year
pgi = #$:(0..)                                       ; Potential gross income
vacancy_loss = #$:(0..)                              ; Vacancy/collection loss
egi = #$:(0..)                                       ; Effective gross income
operating_expenses = #$:(0..)                        ; Operating expenses
noi = #$                                             ; Net operating income
capital_expenditures = #$:(0..)                      ; Capital expenditures
cash_flow_before_debt = #$                           ; Cash flow before debt service
debt_service = #$:(0..)                              ; Debt service (if applicable)
cash_flow_after_debt = #$                            ; Cash flow after debt service
present_value_factor = #:(0..)                       ; PV factor
present_value = #$                                   ; Present value of cash flow

{@commercial_valuation}

; Reversion
{.dcf.reversion}
terminal_year_noi = #$                               ; NOI in terminal year
terminal_cap_rate = #:(0..100)                       ; Terminal cap rate
gross_sale_proceeds = #$:(0..)                       ; Gross sale price
sale_costs = #$:(0..)                                ; Costs of sale
net_sale_proceeds = #$:(0..)                         ; Net sale proceeds
present_value_reversion = #$:(0..)                   ; PV of reversion

{@commercial_valuation}

; Value summary
{.dcf.value_summary}
pv_cash_flows = #$:(0..)                             ; Sum of PV cash flows
pv_reversion = #$:(0..)                              ; PV of reversion
indicated_value = #$:(0..)                           ; Total indicated value

{@commercial_valuation}

; ───────────────────────────────────────────────────────────────────────────────
; Gross Rent Multiplier Analysis
; ───────────────────────────────────────────────────────────────────────────────
{.grm}
approach_used = ?                                    ; Approach developed
gross_rent = #$:(0..)                                ; Annual gross rent
grm = #:(0..)                                        ; Gross rent multiplier
indicated_value = #$:(0..)                           ; Value indication

{@commercial_valuation}

; GRM comparables
{.grm.comparables[]}
property_address = @address                          ; Comparable address
sale_price = #$:(0..)                                ; Sale price
gross_rent = #$:(0..)                                ; Gross rent at sale
grm = #:(0..)                                        ; Implied GRM

{@commercial_valuation}

; ───────────────────────────────────────────────────────────────────────────────
; Cost Approach (for special purpose)
; ───────────────────────────────────────────────────────────────────────────────
{.cost}
approach_used = ?                                    ; Approach developed
land_value = #$:(0..)                                ; Land value
replacement_cost_new = #$:(0..)                      ; Replacement cost new
entrepreneurial_profit = #$:(0..)                    ; Entrepreneurial profit
physical_depreciation = #$:(0..)                     ; Physical depreciation
functional_obsolescence = #$:(0..)                   ; Functional obsolescence
external_obsolescence = #$:(0..)                     ; External obsolescence
depreciated_improvement_value = #$:(0..)             ; Depreciated value
indicated_value = #$:(0..)                           ; Value indication

{@commercial_valuation}

; ───────────────────────────────────────────────────────────────────────────────
; Market Analysis
; ───────────────────────────────────────────────────────────────────────────────
{.market}
market_rent_psf = #$:(0..)                           ; Market rent per sqft
market_vacancy_rate = #:(0..100)                     ; Market vacancy rate
absorption_rate = ##                                 ; Net absorption (sqft/year)
new_construction_sqft = ##:(0..)                     ; New construction pipeline
market_trend = (declining, increasing, stable)       ; Market direction
submarket = :                                        ; Submarket name
submarket_rank = :                                   ; Submarket ranking
market_comments = :                                  ; Market commentary

{@commercial_valuation}

; ───────────────────────────────────────────────────────────────────────────────
; Reconciliation
; ───────────────────────────────────────────────────────────────────────────────
{.reconciliation}
direct_cap_value = #$:(0..)                          ; Direct cap indication
dcf_value = #$:(0..)                                 ; DCF indication
cost_value = #$:(0..)                                ; Cost approach indication
grm_value = #$:(0..)                                 ; GRM indication
concluded_value = #$:(0..)                           ; Concluded value
value_per_sqft = #$:(0..)                            ; Concluded value per sqft
value_per_unit = #$:(0..)                            ; Concluded value per unit
primary_approach = (cost, dcf, direct_cap, grm)      ; Primary approach
reconciliation_comments = :                          ; Reconciliation discussion

{@commercial_valuation}

; ───────────────────────────────────────────────────────────────────────────────
; Investment Metrics
; ───────────────────────────────────────────────────────────────────────────────
{.investment_metrics}
cap_rate = #:(0..100)                                ; Overall cap rate
cash_on_cash = #:(0..100)                            ; Cash-on-cash return
irr_levered = #                                      ; Levered IRR
irr_unlevered = #                                    ; Unlevered IRR
equity_multiple = #:(0..)                            ; Equity multiple
payback_period = #:(0..)                             ; Payback period years
dscr = #:(0..)                                       ; Debt service coverage ratio
breakeven_occupancy = #:(0..100)                     ; Breakeven occupancy

{@commercial_valuation}

; ───────────────────────────────────────────────────────────────────────────────
; Sensitivity Analysis
; ───────────────────────────────────────────────────────────────────────────────
{.sensitivity[]}
variable = (cap_rate, discount_rate, exit_cap, rent_growth, vacancy)
base_case = #                                        ; Base case value
low_case = #                                         ; Low case value
high_case = #                                        ; High case value
value_at_base = #$:(0..)                             ; Value at base case
value_at_low = #$:(0..)                              ; Value at low case
value_at_high = #$:(0..)                             ; Value at high case

{@commercial_valuation}

; ───────────────────────────────────────────────────────────────────────────────
; Capital Expenditure Plan
; ───────────────────────────────────────────────────────────────────────────────
{.capex[]}
item = :                                             ; Expenditure item
year = ##:(0..)                                      ; Year of expenditure
amount = #$:(0..)                                    ; Expenditure amount
category = (deferred_maintenance, improvement, replacement, tenant_improvement)
description = :                                      ; Description

{@commercial_valuation}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (completed, draft, in_review, revision)
status_date = date                                   ; Status date
prepared_by = :                                      ; Preparer name
reviewed_by = :                                      ; Reviewer name

; ═══════════════════════════════════════════════════════════════════════════════
; RENT ROLL
; ═══════════════════════════════════════════════════════════════════════════════
; Detailed rent roll for income analysis

{@rent_roll}
; Required fields first
as_of_date = date                                   ; Rent roll date
property_address = @address                         ; Property address

; Rent roll identification
rent_roll_id = :                                     ; Unique identifier

; Property reference
property_ref = :                                     ; Reference to commercial property

; ───────────────────────────────────────────────────────────────────────────────
; Summary
; ───────────────────────────────────────────────────────────────────────────────
{.summary}
total_units = ##:(0..)                               ; Total units/suites
total_sqft = ##:(0..)                                ; Total rentable sqft
occupied_units = ##:(0..)                            ; Occupied units
occupied_sqft = ##:(0..)                             ; Occupied sqft
occupancy_rate = #:(0..100)                          ; Occupancy rate
scheduled_rent = #$:(0..)                            ; Total scheduled rent
actual_collected = #$:(0..)                          ; Actual collected (if known)
average_rent_psf = #$:(0..)                          ; Average rent per sqft

{@rent_roll}

; ───────────────────────────────────────────────────────────────────────────────
; Tenants
; ───────────────────────────────────────────────────────────────────────────────
{.tenants[]}
unit_number = :                                      ; Unit/suite number
tenant_name = :                                      ; Tenant name
tenant_type = (anchor, in_line, major, pad, vacant)  ; Tenant type
industry = :                                         ; Tenant industry/use
credit_rated = ?                                     ; Credit-rated tenant
lease_sqft = ##:(0..)                                ; Leased square feet
percent_of_total = #:(0..100)                        ; Percentage of building
lease_start = date                                   ; Lease commencement
lease_end = date                                     ; Lease expiration
base_rent_monthly = #$:(0..)                         ; Monthly base rent
base_rent_annual = #$:(0..)                          ; Annual base rent
rent_per_sqft = #$:(0..)                             ; Rent per sqft
lease_type = (absolute_net, double_net, full_service, gross, modified_gross, triple_net)
escalation_type = (cpi, fixed_amount, fixed_percent, market, none, step)
escalation_rate = #                                  ; Escalation rate/amount
next_escalation = date                               ; Next escalation date
cam_reimbursement = (base_year, full, none, partial)
tax_reimbursement = (base_year, full, none, partial)
insurance_reimbursement = (base_year, full, none, partial)
options[] = :                                        ; Renewal/expansion options
percentage_rent = ?                                  ; Has percentage rent
percentage_rate = #:(0..100):if percentage_rent = true
breakpoint = #$:(0..):if percentage_rent = true
security_deposit = #$:(0..)                          ; Security deposit
status = (current, delinquent, month_to_month, vacant)

{@rent_roll}

; ───────────────────────────────────────────────────────────────────────────────
; Vacant Units
; ───────────────────────────────────────────────────────────────────────────────
{.vacant_units[]}
unit_number = :                                      ; Unit/suite number
sqft = ##:(0..)                                      ; Square feet
market_rent_psf = #$:(0..)                           ; Market rent per sqft
projected_market_rent = #$:(0..)                     ; Projected annual rent
condition = (as_is, needs_work, ready)               ; Condition
months_vacant = ##:(0..)                             ; Months vacant
estimated_downtime = ##:(0..)                        ; Additional estimated downtime

{@rent_roll}

; ═══════════════════════════════════════════════════════════════════════════════
; COMPARABLE SALE
; ═══════════════════════════════════════════════════════════════════════════════
; Commercial comparable sale for valuation

{@commercial_comparable}
; Required fields first
property_address = @address                         ; Property address
sale_date = date                                    ; Sale date
sale_price = #$:(0..)                               ; Sale price

; Comparable identification
comparable_id = :                                    ; Unique identifier

; ───────────────────────────────────────────────────────────────────────────────
; Property Details
; ───────────────────────────────────────────────────────────────────────────────
{.property}
property_type = (healthcare, hospitality, industrial, mixed_use, multifamily, office, retail, self_storage, special_purpose)
property_subtype = :                                 ; Property subtype
year_built = ##:(1600..2100)                         ; Year built
gla = ##:(0..)                                       ; Gross leasable area
nra = ##:(0..)                                       ; Net rentable area
units = ##:(0..)                                     ; Number of units
floors = ##:(0..)                                    ; Number of floors
land_area_sqft = ##:(0..)                            ; Land area
land_area_acres = #:(0..)                            ; Land area acres
quality = (a_class, b_class, c_class)                ; Quality class
condition = (average, excellent, fair, good, poor)

{@commercial_comparable}

; ───────────────────────────────────────────────────────────────────────────────
; Sale Details
; ───────────────────────────────────────────────────────────────────────────────
{.sale}
sale_type = (arm_length, auction, distressed, portfolio, related_party, reo)
financing = (assumed, cash, conventional, new_financing, owner_finance, seller_credit)
buyer = :                                            ; Buyer name
buyer_type = (institutional, private, public_reit, syndicator, user)
seller = :                                           ; Seller name
seller_type = (estate, institutional, private, public_reit)
days_on_market = ##:(0..)                            ; Days on market
verification = :                                     ; Verification source

{@commercial_comparable}

; ───────────────────────────────────────────────────────────────────────────────
; Financial Metrics
; ───────────────────────────────────────────────────────────────────────────────
{.financials}
noi = #$                                             ; NOI at sale
cap_rate = #:(0..100)                                ; Cap rate
price_per_sqft = #$:(0..)                            ; Price per sqft
price_per_unit = #$:(0..)                            ; Price per unit
occupancy = #:(0..100)                               ; Occupancy at sale
in_place_rent_psf = #$:(0..)                         ; In-place rent per sqft
grm = #:(0..)                                        ; Gross rent multiplier

{@commercial_comparable}

; ───────────────────────────────────────────────────────────────────────────────
; Adjustments
; ───────────────────────────────────────────────────────────────────────────────
{.adjustments}
property_rights = #                                  ; Property rights adjustment %
financing_terms = #                                  ; Financing adjustment %
conditions_of_sale = #                               ; Conditions of sale adjustment %
market_conditions = #                                ; Market/time adjustment %
location = #                                         ; Location adjustment %
physical_characteristics = #                         ; Physical adjustment %
net_adjustment = #                                   ; Net adjustment %
gross_adjustment = #                                 ; Gross adjustment %
adjusted_price = #$:(0..)                            ; Adjusted sale price
adjusted_price_psf = #$:(0..)                        ; Adjusted price per sqft
adjusted_cap_rate = #:(0..100)                       ; Adjusted cap rate

{@commercial_comparable}


; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Mortgage Insurance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Mortgage insurance covering lender protection against borrower default including
; private mortgage insurance (PMI), FHA/government mortgage insurance, lender-
; placed (force-placed), and title-related mortgage protection.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.specialty.mortgage"
version = "1.0.0"
title = "Mortgage Insurance Schema"
description = "Comprehensive mortgage insurance covering PMI, FHA MIP, VA, and USDA programs"

{$derivation}
source[0].authority = "U.S. Congress"
source[0].citation = "Homeowners Protection Act of 1998 (12 U.S.C. 4901-4910)"
source[0].url = "https://uscode.house.gov/view.xhtml?path=/prelim@title12/chapter49&edition=prelim"

source[1].authority = "Consumer Financial Protection Bureau"
source[1].citation = "Regulation C - Home Mortgage Disclosure (Regulation Z - TILA)"
source[1].url = "https://www.consumerfinance.gov/rules-policy/regulations/"

source[2].authority = "U.S. Department of Housing and Urban Development"
source[2].citation = "FHA Single Family Housing Policy Handbook 4000.1"
source[2].url = "https://www.hud.gov/program_offices/housing/sfh/handbook_4000-1"

source[3].authority = "U.S. Department of Veterans Affairs"
source[3].citation = "VA Lenders Handbook Chapter 8 - Funding Fee"
source[3].url = "https://www.va.gov/housing-assistance/home-loans/funding-fee-and-closing-costs/"

source[4].authority = "USDA Rural Development"
source[4].citation = "Single Family Housing Guaranteed Loan Program - 7 CFR 3555"
source[4].url = "https://www.rd.usda.gov/programs-services/single-family-housing-programs/single-family-housing-guaranteed-loan-program"

source[5].authority = "Federal Housing Finance Agency"
source[5].citation = "Private Mortgage Insurer Eligibility Requirements (PMIERs)"
source[5].url = "https://www.fhfa.gov/policy/fannie-mae-freddie-mac-private-mortgage-insurer-eligibility-requirements-pmiers"

source[6].authority = "Fannie Mae"
source[6].citation = "Selling Guide Section B7 - Mortgage Insurance"
source[6].url = "https://selling-guide.fanniemae.com/sel/b7-1-01/provision-mortgage-insurance"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Derived from public federal statutes, CFPB regulations, HUD handbooks, VA/USDA guidelines, and GSE selling guides"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial mortgage insurance schema"
changelog[0].rationale = "Comprehensive MI coverage for all major federal and private programs"

; ═══════════════════════════════════════════════════════════════════════════════
; Mortgage Loan
; ═══════════════════════════════════════════════════════════════════════════════
; The underlying mortgage loan that mortgage insurance protects.

{@mortgage_loan}
id = :                                            ; Unique identifier for the mortgage loan

; ───────────────────────────────────────────────────────────────────────────────
; Loan Identification
; ───────────────────────────────────────────────────────────────────────────────
loan_number = :                                   ; Lender's primary loan identifier
universal_loan_id = :                             ; MERS MIN or other universal ID
servicer_loan_number = :                          ; Servicer's assigned loan number
prior_loan_number = :                             ; If transferred/sold

; ───────────────────────────────────────────────────────────────────────────────
; Loan Type and Purpose
; ───────────────────────────────────────────────────────────────────────────────
loan_type = (
    conventional,                                  ; Private MI required if LTV > 80%
    fha,                                          ; FHA MIP required
    jumbo,                                        ; Non-conforming (MI varies)
    portfolio,                                    ; Lender portfolio (MI optional)
    usda,                                         ; USDA guarantee fee
    va                                            ; VA funding fee
)

loan_purpose = (
    construction_permanent,                        ; Construction loan converted to permanent
    home_equity_conversion,                       ; HECM/reverse
    purchase,                                      ; Purchase of property
    refinance_cash_out,                            ; Refinance with cash out
    refinance_rate_term,                           ; Rate and term refinance
    refinance_streamline                          ; FHA/VA streamline
)

occupancy_type = (
    investment_property,                           ; Non-owner occupied investment
    primary_residence,                             ; Owner's primary residence
    second_home                                    ; Secondary residence
)

; ───────────────────────────────────────────────────────────────────────────────
; Loan Terms
; ───────────────────────────────────────────────────────────────────────────────
amortization_type = (
    arm,                                          ; Adjustable rate
    balloon,                                       ; Balloon payment due at end
    fixed,                                         ; Fixed rate mortgage
    graduated_payment,                             ; Gradually increasing payments
    growing_equity,                                ; Increasing principal payments
    interest_only                                  ; Interest-only payments
)

original_loan_amount = #$:(0..)                   ; Original loan principal amount
current_principal_balance = #$:(0..)              ; Current unpaid principal balance
original_interest_rate = #:(0..30)                ; Percentage
current_interest_rate = #:(0..30)                 ; Current interest rate percentage
original_term_months = ##:(1..)                   ; Up to 40 years
remaining_term_months = ##:(0..)                  ; Months remaining to maturity
amortization_term_months = ##:(1..)               ; Full amortization term in months

; ARM details (if applicable)
arm_index = ::if amortization_type = arm          ; Index used for rate adjustments (SOFR, LIBOR, etc.)
arm_margin = #:(0..10):if amortization_type = arm ; Margin added to index
arm_initial_cap = #:(0..10):if amortization_type = arm ; Initial rate adjustment cap percentage
arm_periodic_cap = #:(0..5):if amortization_type = arm ; Periodic rate adjustment cap
arm_lifetime_cap = #:(0..15):if amortization_type = arm ; Lifetime rate cap percentage
arm_first_adjustment_date = date:if amortization_type = arm ; Date of first rate adjustment

; ───────────────────────────────────────────────────────────────────────────────
; LTV Ratios
; ───────────────────────────────────────────────────────────────────────────────
; Critical for MI requirements and coverage levels
original_ltv = #:(0..125)                         ; Original LTV at closing
original_cltv = #:(0..125)                        ; Combined LTV (with subordinate liens)
current_ltv = #:(0..200)                          ; Current LTV based on current balance
current_cltv = #:(0..200)
scheduled_ltv = #:(0..200)                        ; LTV per amortization schedule
hcltv = #:(0..125)                                ; HELOC combined LTV

; ───────────────────────────────────────────────────────────────────────────────
; Property Value
; ───────────────────────────────────────────────────────────────────────────────
original_appraised_value = #$:(0..)               ; Original appraisal value at origination
original_purchase_price = #$:(0..)                ; Purchase price of property
original_value = #$:(0..)                         ; Lesser of appraised/purchase
current_appraised_value = #$:(0..)                ; Current appraised value
current_appraisal_date = date                     ; Date of current appraisal
current_bpo_value = #$:(0..)                      ; Broker price opinion
current_avm_value = #$:(0..)                      ; Automated valuation model

; ───────────────────────────────────────────────────────────────────────────────
; Dates
; ───────────────────────────────────────────────────────────────────────────────
origination_date = date                           ; Date loan was originated
first_payment_date = date                         ; Date of first payment due
maturity_date = date                              ; Date loan matures/final payment
note_date = date                                  ; Date promissory note was signed

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
loan_status = (
    active,                                        ; Loan is active and performing
    bankruptcy,                                    ; Borrower in bankruptcy
    deed_in_lieu,                                  ; Deed in lieu of foreclosure
    default,                                       ; Loan in default
    forbearance,                                   ; Forbearance agreement in place
    foreclosed,                                    ; Foreclosure completed
    modification,                                  ; Under loan modification
    paid_off,                                      ; Loan paid in full
    refinanced,                                    ; Refinanced and closed
    reo,                                          ; Real estate owned
    short_sale                                     ; Short sale completed
)

delinquency_status = (
    current,                                       ; Payments current
    days_30,                                       ; 30 days delinquent
    days_60,                                       ; 60 days delinquent
    days_90,                                       ; 90 days delinquent
    days_120_plus                                  ; 120+ days delinquent
)

months_delinquent = ##:(0..)                      ; Number of months delinquent
last_paid_installment_date = date                 ; Date of last payment received
next_due_date = date                              ; Next payment due date

; ───────────────────────────────────────────────────────────────────────────────
; Conforming/Non-Conforming
; ───────────────────────────────────────────────────────────────────────────────
conforming = ?                                    ; Meets conforming loan limits
high_balance = ?                                  ; Super conforming
gse_eligible = ?                                  ; Eligible for GSE purchase
gse_delivered = ?                                 ; Delivered to Fannie Mae or Freddie Mac
gse_pool_number = :                               ; GSE pool number if securitized

{@mortgage_loan}

; ═══════════════════════════════════════════════════════════════════════════════
; Mortgage Property
; ═══════════════════════════════════════════════════════════════════════════════
; The real property securing the mortgage loan.

{@mortgage_property}
id = :                                            ; Unique identifier for the property

; ───────────────────────────────────────────────────────────────────────────────
; Property Address
; ───────────────────────────────────────────────────────────────────────────────
address = @address                                ; Physical address of the property

; ───────────────────────────────────────────────────────────────────────────────
; Property Identification
; ───────────────────────────────────────────────────────────────────────────────
apn = :                                           ; Assessor parcel number
legal_description = :                             ; Legal description from deed
census_tract = :                                  ; Census tract identifier
msa_code = :                                      ; Metropolitan statistical area

; ───────────────────────────────────────────────────────────────────────────────
; Property Type
; ───────────────────────────────────────────────────────────────────────────────
property_type = (
    condo,                                         ; Condominium
    coop,                                          ; Cooperative
    manufactured_home,                             ; Manufactured/mobile home
    mixed_use,                                     ; Mixed residential/commercial use
    modular_home,                                  ; Modular construction home
    pud,                                          ; Planned unit development
    single_family_attached,                        ; Attached single family
    single_family_detached,                        ; Detached single family
    townhouse,                                     ; Townhouse
    two_to_four_unit                               ; 2-4 unit residential
)

unit_count = ##:(1..4)                            ; 1-4 for residential
stories = ##:(1..)                                ; Number of stories
year_built = ##:(1800..2100)                      ; Year property was built
square_footage = ##:(0..)                         ; Total square footage
lot_size_sqft = ##                                ; Lot size in square feet
lot_size_acres = #:(0..)                          ; Lot size in acres

; ───────────────────────────────────────────────────────────────────────────────
; Construction
; ───────────────────────────────────────────────────────────────────────────────
construction_type = (
    log,                                           ; Log construction
    manufactured,                                  ; Manufactured/factory built
    modular,                                       ; Modular construction
    panelized,                                     ; Panelized construction
    site_built                                     ; Traditional site-built
)

foundation_type = (
    basement,                                      ; Full or partial basement
    crawl_space,                                   ; Crawl space foundation
    pier_beam,                                     ; Pier and beam foundation
    slab                                           ; Slab on grade foundation
)

exterior_walls = (
    aluminum_vinyl,                                ; Aluminum or vinyl siding
    brick,                                         ; Brick exterior
    concrete_block,                                ; Concrete block
    fiber_cement,                                  ; Fiber cement siding
    frame_wood,                                    ; Wood frame/siding
    log,                                           ; Log exterior
    stone,                                         ; Stone exterior
    stucco                                         ; Stucco finish
)

roof_type = (
    asphalt_shingle,                               ; Asphalt shingle roof
    flat_membrane,                                 ; Flat membrane roof
    metal,                                         ; Metal roof
    slate,                                         ; Slate roof
    tile,                                          ; Tile roof
    wood_shake                                     ; Wood shake/shingle roof
)

; ───────────────────────────────────────────────────────────────────────────────
; Condition and Risk
; ───────────────────────────────────────────────────────────────────────────────
condition = (
    average,                                       ; Average condition
    excellent,                                     ; Excellent condition
    fair,                                          ; Fair condition
    good,                                          ; Good condition
    poor                                           ; Poor condition
)

flood_zone = :                                    ; FEMA flood zone
flood_insurance_required = ?                      ; Flood insurance required
special_flood_hazard_area = ?                     ; Property in SFHA

; Location risks
coastal = ?                                       ; Coastal property location
wildfire_risk = ?                                 ; High wildfire risk area
earthquake_zone = ?                               ; Earthquake zone designation

{@mortgage_property}

; ═══════════════════════════════════════════════════════════════════════════════
; Mortgage Borrower
; ═══════════════════════════════════════════════════════════════════════════════
; Borrower(s) on the mortgage loan.

{@mortgage_borrower}
id = :                                            ; Unique identifier for the borrower

; ───────────────────────────────────────────────────────────────────────────────
; Borrower Identity
; ───────────────────────────────────────────────────────────────────────────────
borrower_type = (
    co_borrower,                                   ; Co-borrower on the loan
    guarantor,                                     ; Guarantor of the loan
    primary                                        ; Primary borrower
)

{.name}
first = :                                        ; First name (required)
middle = :                                        ; Middle name or initial
last = :                                         ; Last name (required)
suffix = :                                        ; Name suffix (Jr., Sr., III, etc.)

ssn = *:format ssn                               ; Confidential

; ───────────────────────────────────────────────────────────────────────────────
; Contact
; ───────────────────────────────────────────────────────────────────────────────
mailing_address = @types.address                  ; Borrower's mailing address
email = *@email                                   ; Email address (confidential)
phones[] = *@phone                                ; Contact phones

; ───────────────────────────────────────────────────────────────────────────────
; Demographics (for fair lending monitoring)
; ───────────────────────────────────────────────────────────────────────────────
date_of_birth = *date                             ; Date of birth (confidential)
citizenship = (
    non_permanent_resident,                        ; Non-permanent resident alien
    permanent_resident,                            ; Permanent resident alien
    us_citizen                                     ; U.S. citizen
)

; ───────────────────────────────────────────────────────────────────────────────
; Credit Profile
; ───────────────────────────────────────────────────────────────────────────────
credit_score = ##:(300..850)                      ; Credit score value
credit_score_model = (
    fico,                                          ; FICO classic score
    fico_10,                                       ; FICO 10 model
    fico_9,                                        ; FICO 9 model
    vantage                                        ; VantageScore model
)
credit_score_date = date                          ; Date credit score was obtained

; ───────────────────────────────────────────────────────────────────────────────
; Income and Employment
; ───────────────────────────────────────────────────────────────────────────────
employment_status = (
    employed,                                      ; Employed W-2
    military,                                      ; Active military
    retired,                                       ; Retired
    self_employed,                                 ; Self-employed
    unemployed                                     ; Unemployed
)

monthly_income = *#$:(0..)                        ; Confidential
dti_front_end = #:(0..100)                        ; Housing ratio
dti_back_end = #:(0..100)                         ; Total debt ratio
assets_verified = #$:(0..)                        ; Verified assets amount

; ───────────────────────────────────────────────────────────────────────────────
; Homebuyer Status
; ───────────────────────────────────────────────────────────────────────────────
first_time_homebuyer = ?                          ; First-time homebuyer status
homebuyer_education_completed = ?                 ; Completed homebuyer education course
housing_counseling_completed = ?                  ; Completed housing counseling

{@mortgage_borrower}

; ═══════════════════════════════════════════════════════════════════════════════
; MI Program Type
; ═══════════════════════════════════════════════════════════════════════════════
; Defines the specific mortgage insurance program parameters.

{@mi_program}
id = :                                            ; Unique identifier for the MI program

program_type = (
    fha_mip,                                      ; FHA mortgage insurance
    pool_insurance,                               ; Recourse/pool level
    private_mi,                                   ; Conventional PMI
    usda_guarantee,                               ; USDA rural housing
    va_funding_fee                                ; VA loan guarantee
)

; ───────────────────────────────────────────────────────────────────────────────
; Private MI Parameters
; ───────────────────────────────────────────────────────────────────────────────
; Applies when program_type = private_mi

{.private_mi}
premium_plan = (
    bpmi_monthly,                                 ; Borrower-paid monthly
    lpmi,                                         ; Lender-paid (in rate)
    single_premium,                               ; Paid upfront
    split_premium                                 ; Partial upfront + monthly
):if program_type = private_mi

refundable = ?:if program_type = private_mi
hpa_eligible = ?:if program_type = private_mi    ; Homeowners Protection Act

; GSE requirements
coverage_type = (
    charter_level,                                 ; Charter Act coverage level
    minimum,                                       ; Minimum coverage required
    standard                                       ; Standard coverage level
):if program_type = private_mi

{@mi_program}

; ───────────────────────────────────────────────────────────────────────────────
; FHA MIP Parameters
; ───────────────────────────────────────────────────────────────────────────────
; Applies when program_type = fha_mip

{.fha_mip}
case_number = ::if program_type = fha_mip
upfront_mip_rate = #:(0..10):if program_type = fha_mip   ; Currently 1.75%
annual_mip_rate = #:(0..2):if program_type = fha_mip     ; Currently 0.15-0.75%

mip_duration = (
    eleven_years,                                 ; 10%+ down
    life_of_loan                                  ; <10% down
):if program_type = fha_mip

refund_eligible = ?:if program_type = fha_mip    ; For refinance within 3 years
streamline_refinance = ?:if program_type = fha_mip

{@mi_program}

; ───────────────────────────────────────────────────────────────────────────────
; VA Funding Fee Parameters
; ───────────────────────────────────────────────────────────────────────────────
; Applies when program_type = va_funding_fee

{.va_funding}
veteran_type = (
    active_duty,
    regular_military,
    reserves_national_guard,
    surviving_spouse
):if program_type = va_funding_fee

usage = (
    first_use,
    subsequent_use
):if program_type = va_funding_fee

funding_fee_exempt = ?:if program_type = va_funding_fee
exemption_reason = (
    purple_heart_recipient,
    service_connected_disability,
    surviving_spouse
):if va_funding.funding_fee_exempt = true

down_payment_tier = (
    five_percent,                                 ; 5-9.99%
    ten_percent,                                  ; 10%+
    zero                                          ; No down payment
):if program_type = va_funding_fee

; Fee rates by usage and down payment (informational)
; First use: 0% down = 2.15%, 5%+ = 1.5%, 10%+ = 1.25%
; Subsequent: 0% down = 3.3%, 5%+ = 1.5%, 10%+ = 1.25%
; IRRRL: 0.5%

{@mi_program}

; ───────────────────────────────────────────────────────────────────────────────
; USDA Guarantee Parameters
; ───────────────────────────────────────────────────────────────────────────────
; Applies when program_type = usda_guarantee

{.usda}
program = (
    direct,                                       ; USDA-originated
    guaranteed                                    ; Lender-originated
):if program_type = usda_guarantee

upfront_guarantee_rate = #:(0..5):if program_type = usda_guarantee   ; Currently 1%
annual_fee_rate = #:(0..2):if program_type = usda_guarantee          ; Currently 0.35%

income_eligible = ?:if program_type = usda_guarantee
property_eligible = ?:if program_type = usda_guarantee

{@mi_program}

; ═══════════════════════════════════════════════════════════════════════════════
; MI Coverage
; ═══════════════════════════════════════════════════════════════════════════════
; The actual coverage terms for the mortgage insurance.

{@mi_coverage}
id = :                                            ; Unique identifier for the coverage

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Parameters
; ───────────────────────────────────────────────────────────────────────────────
; MI covers a percentage of the loan, not 100%

coverage_percentage = ##:(0..100)                 ; Standard: 25-35%
effective_ltv = #:(0..100)                        ; LTV after MI applied

; GSE Standard Coverage Requirements by LTV:
; 95.01-97%  LTV: 35% coverage (effective LTV 63%)
; 90.01-95%  LTV: 30% coverage (effective LTV 66.5%)
; 85.01-90%  LTV: 25% coverage (effective LTV 67.5%)
; 80.01-85%  LTV: 12% coverage (effective LTV 75%)

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Dates
; ───────────────────────────────────────────────────────────────────────────────
coverage_effective_date = date                    ; Date coverage became effective
coverage_termination_date = date                  ; Date coverage terminated
initial_coverage_term_months = ##:(1..)           ; Initial term of coverage in months

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Status
; ───────────────────────────────────────────────────────────────────────────────
status = (
    active,                                        ; Coverage is active
    cancelled,                                     ; Coverage cancelled
    claim_paid,                                    ; Claim paid and coverage ended
    claim_pending,                                 ; Claim pending
    lapsed,                                        ; Coverage lapsed
    rescinded,                                     ; Coverage rescinded
    terminated_auto,                              ; Auto-terminated at 78% LTV
    terminated_borrower_request,                  ; Cancelled at 80% LTV
    terminated_midpoint                           ; Amortization midpoint
)

status_date = date                                ; Date of current status

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Reductions
; ───────────────────────────────────────────────────────────────────────────────
reduced_coverage = ?                              ; Coverage has been reduced
reduced_coverage_percentage = ##:(0..100):if reduced_coverage = true ; Reduced coverage percentage
reduction_effective_date = date:if reduced_coverage = true ; Date reduction became effective
reduction_reason = (
    borrower_request,                              ; Borrower requested reduction
    investor_approved,                             ; Investor approved reduction
    seasoning,                                     ; Loan seasoning milestone reached
    servicer_initiated                             ; Servicer initiated reduction
):if reduced_coverage = true

{@mi_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; MI Premium
; ═══════════════════════════════════════════════════════════════════════════════
; Premium structure and payment details.

{@mi_premium}
id = :                                            ; Unique identifier for the premium

; ───────────────────────────────────────────────────────────────────────────────
; Premium Structure
; ───────────────────────────────────────────────────────────────────────────────
premium_type = (
    annual,                                        ; Annual premium
    monthly,                                       ; Monthly premium
    single,                                        ; Single upfront premium
    split                                          ; Split premium (upfront + ongoing)
)

payment_responsibility = (
    borrower,                                      ; Borrower pays premium
    lender                                         ; Lender pays premium
)

; ───────────────────────────────────────────────────────────────────────────────
; Premium Rates
; ───────────────────────────────────────────────────────────────────────────────
annual_rate = #:(0..5)                            ; Annual rate as % of loan
monthly_rate = #:(0..0.5)                         ; Monthly factor

; FHA Upfront MIP / VA Funding Fee / USDA Upfront
upfront_rate = #:(0..10)                          ; Upfront % of loan
upfront_amount = #$:(0..)                         ; Dollar amount of upfront premium
upfront_financed = ?                              ; Rolled into loan
upfront_paid_at_closing = ?                       ; Paid at closing

; Split premium upfront portion
split_upfront_rate = #:(0..5)                     ; Upfront rate for split premium
split_upfront_amount = #$:(0..)                   ; Upfront amount for split premium

; ───────────────────────────────────────────────────────────────────────────────
; Premium Amounts
; ───────────────────────────────────────────────────────────────────────────────
monthly_premium = #$:(0..)                        ; Monthly premium amount
annual_premium = #$:(0..)                         ; Annual premium amount
total_premium_to_date = #$:(0..)                  ; Total premiums paid to date

; ───────────────────────────────────────────────────────────────────────────────
; Premium Payment
; ───────────────────────────────────────────────────────────────────────────────
premium_due_date = date                           ; Next premium due date
last_premium_paid_date = date                     ; Date last premium was paid
premiums_in_arrears = #$:(0..)                    ; Amount of premiums in arrears
months_premium_unpaid = ##:(0..)                  ; Number of months premium unpaid

; ───────────────────────────────────────────────────────────────────────────────
; Rate Factors
; ───────────────────────────────────────────────────────────────────────────────
; Factors that influenced premium rate
credit_score_tier = (
    average,                                      ; 680-719
    excellent,                                    ; 760+
    fair,                                         ; 620-679
    good,                                         ; 720-759
    low                                           ; Below 620
)

ltv_tier = (
    above_97,                                     ; >97%
    below_80,                                     ; Not required at this LTV
    to_85,                                        ; 80.01-85%
    to_90,                                        ; 85.01-90%
    to_95,                                        ; 90.01-95%
    to_97                                         ; 95.01-97%
)

dti_tier = (
    high,                                         ; Above 43%
    low,                                          ; Below 36%
    moderate                                      ; 36-43%
)

{@mi_premium}

; ═══════════════════════════════════════════════════════════════════════════════
; MI Cancellation
; ═══════════════════════════════════════════════════════════════════════════════
; Tracks MI cancellation under Homeowners Protection Act (HPA) and other rules.

{@mi_cancellation}
id = :                                            ; Unique identifier for the cancellation

; ───────────────────────────────────────────────────────────────────────────────
; HPA Cancellation Milestones
; ───────────────────────────────────────────────────────────────────────────────
; Per Homeowners Protection Act of 1998

; Borrower-requested cancellation (80% LTV)
borrower_request_eligible_date = date             ; Date 80% LTV reached per schedule
borrower_request_actual_date = date               ; Date borrower actually requested
borrower_request_ltv = #:(0..100)                 ; LTV at time of borrower request

; Automatic termination (78% LTV)
auto_termination_scheduled_date = date            ; Per original amortization
auto_termination_actual_date = date               ; Date auto-termination occurred
auto_termination_ltv = #:(0..100)                 ; LTV at automatic termination

; Midpoint termination
amortization_midpoint_date = date                 ; 15 years on 30-year
midpoint_termination_eligible = ?                 ; Eligible for midpoint termination
midpoint_termination_actual_date = date           ; Date midpoint termination occurred

; ───────────────────────────────────────────────────────────────────────────────
; Cancellation Request Status
; ───────────────────────────────────────────────────────────────────────────────
cancellation_requested = ?                        ; Cancellation has been requested
cancellation_request_date = date                  ; Date cancellation was requested
cancellation_type = (
    automatic_78_ltv,                              ; Automatic at 78% LTV
    borrower_requested_80_ltv,                     ; Borrower requested at 80% LTV
    claim,                                         ; Due to claim
    midpoint,                                      ; At amortization midpoint
    payoff,                                        ; Due to loan payoff
    refinance,                                     ; Due to refinance
    rescission                                     ; Due to rescission
)

cancellation_status = (
    approved,                                      ; Cancellation approved
    completed,                                     ; Cancellation completed
    denied,                                        ; Cancellation denied
    pending_appraisal,                             ; Pending appraisal
    pending_review                                 ; Pending review
)

denial_reason = (
    current_not_78_ltv,                            ; Current LTV not at 78%
    high_risk_loan,                                ; Loan classified as high risk
    insufficient_appraisal,                        ; Appraisal insufficient
    less_than_2_years,                             ; Less than 2 years seasoning
    not_current_on_payments,                       ; Not current on payments
    subordinate_liens,                             ; Subordinate liens exist
    value_declined                                 ; Property value declined
):if cancellation_status = denied

; ───────────────────────────────────────────────────────────────────────────────
; HPA Requirements for Cancellation
; ───────────────────────────────────────────────────────────────────────────────
; Borrower must meet these for requested cancellation at 80%

good_payment_history = ?                          ; No 30+ day late in 12 months
no_60_day_late_24_months = ?                      ; No 60+ day late in 24 months
current_on_loan = ?                               ; Loan is current
no_subordinate_liens = ?                          ; No subordinate liens on property
value_not_declined = ?                            ; Property value has not declined

; If using current value (not original)
new_appraisal_required = ?                        ; New appraisal is required
new_appraisal_obtained = ?                        ; New appraisal has been obtained
new_appraisal_date = date                         ; Date of new appraisal
new_appraisal_value = #$:(0..)                    ; Value from new appraisal
current_ltv_after_appraisal = #:(0..200)          ; LTV after new appraisal

; ───────────────────────────────────────────────────────────────────────────────
; Refund
; ───────────────────────────────────────────────────────────────────────────────
premium_refund_due = ?                            ; Premium refund is due
refund_amount = #$:(0..)                          ; Amount of refund
refund_date = date                                ; Date refund issued
refund_method = (
    applied_to_principal,                          ; Applied to loan principal
    check_to_borrower,                             ; Check issued to borrower
    escrow_credit                                  ; Credit to escrow account
)

{@mi_cancellation}

; ═══════════════════════════════════════════════════════════════════════════════
; MI Certificate
; ═══════════════════════════════════════════════════════════════════════════════
; The individual loan certificate issued under a master policy.

{@mi_certificate}
id = :                                            ; Unique identifier for the certificate

; ───────────────────────────────────────────────────────────────────────────────
; Certificate Identification
; ───────────────────────────────────────────────────────────────────────────────
certificate_number = :                            ; MI certificate number
master_policy_number = :                          ; Master policy number
commitment_number = :                             ; Initial commitment

; ───────────────────────────────────────────────────────────────────────────────
; Certificate Dates
; ───────────────────────────────────────────────────────────────────────────────
commitment_date = date                            ; Date of initial commitment
effective_date = date                             ; Certificate effective date
expiration_date = date                            ; Certificate expiration date
cancellation_date = date                          ; Date certificate was cancelled

; ───────────────────────────────────────────────────────────────────────────────
; MI Provider
; ───────────────────────────────────────────────────────────────────────────────
mi_company = (
    arch_mi,                                       ; Arch MI
    enact,                                        ; Formerly Genworth
    essent,                                        ; Essent Guaranty
    fha,                                           ; FHA
    mgic,                                          ; MGIC
    national_mi,                                   ; National MI
    other,                                         ; Other MI company
    radian,                                        ; Radian Guaranty
    usda,                                          ; USDA
    va                                             ; VA
)

mi_company_naic = :                               ; NAIC company code
mi_company_name = :                               ; Full company name

; ───────────────────────────────────────────────────────────────────────────────
; Linked Entities
; ───────────────────────────────────────────────────────────────────────────────
loan = @mortgage_loan                             ; Reference to the mortgage loan
property = @mortgage_property                     ; Reference to the property
borrowers[] = @mortgage_borrower                  ; References to borrowers
program = @mi_program                             ; Reference to the MI program
coverage = @mi_coverage                           ; Reference to coverage details
premium = @mi_premium                             ; Reference to premium details
cancellation = @mi_cancellation                   ; Reference to cancellation details

; ───────────────────────────────────────────────────────────────────────────────
; Certificate Status
; ───────────────────────────────────────────────────────────────────────────────
status = (
    active,                                        ; Certificate is active
    cancelled,                                     ; Certificate cancelled
    claim_in_process,                              ; Claim is being processed
    claim_paid,                                    ; Claim has been paid
    committed,                                     ; Commitment issued
    expired,                                       ; Certificate expired
    rescinded                                      ; Certificate rescinded
)

status_date = date                                ; Date of current status

; ───────────────────────────────────────────────────────────────────────────────
; Rescission Relief
; ───────────────────────────────────────────────────────────────────────────────
; GSE-aligned rescission relief provisions
rescission_relief_eligible = ?                    ; Eligible for rescission relief
rescission_relief_date = date                     ; 36 months from certification
rescission_relief_type = (
    automatic,                                     ; Automatic rescission relief
    validated                                      ; Validated rescission relief
)

; ───────────────────────────────────────────────────────────────────────────────
; Delegated Underwriting
; ───────────────────────────────────────────────────────────────────────────────
delegated = ?                                     ; Delegated underwriting authority
due_diligence_completed = ?                       ; Due diligence completed
due_diligence_date = date                         ; Date due diligence completed
file_review_completed = ?                         ; File review completed
file_review_date = date                           ; Date file review completed

{@mi_certificate}

; ═══════════════════════════════════════════════════════════════════════════════
; MI Master Policy
; ═══════════════════════════════════════════════════════════════════════════════
; The master policy between MI company and lender/servicer.

{@mi_master_policy}
id = :                                            ; Unique identifier for the master policy

; ───────────────────────────────────────────────────────────────────────────────
; Policy Identification
; ───────────────────────────────────────────────────────────────────────────────
policy_number = :                                 ; Master policy number
policy_version = :                                ; Policy version identifier

; ───────────────────────────────────────────────────────────────────────────────
; MI Company
; ───────────────────────────────────────────────────────────────────────────────
mi_company = (
    arch_mi,                                       ; Arch MI
    enact,                                         ; Enact (formerly Genworth)
    essent,                                        ; Essent Guaranty
    mgic,                                          ; MGIC
    national_mi,                                   ; National MI
    other,                                         ; Other MI company
    radian                                         ; Radian Guaranty
)

mi_company_name = :                               ; MI company name
mi_company_naic = :                               ; NAIC company code
mi_company_am_best_rating = :                     ; AM Best financial rating
mi_company_sp_rating = :                          ; S&P financial rating

; ───────────────────────────────────────────────────────────────────────────────
; Policyholder (Lender)
; ───────────────────────────────────────────────────────────────────────────────
lender_name = :                                   ; Lender/policyholder name
lender_nmls_id = :                                ; NMLS identifier
lender_address = @types.address                   ; Lender's address
lender_contact_name = :                           ; Primary contact name
lender_contact_email = *@email                    ; Contact email (confidential)
lender_contact_phone = *@phone                    ; Contact phone (confidential)

; ───────────────────────────────────────────────────────────────────────────────
; Policy Term
; ───────────────────────────────────────────────────────────────────────────────
effective_date = date                             ; Policy effective date
expiration_date = date                            ; Policy expiration date
auto_renewal = ?                                  ; Policy auto-renews

; ───────────────────────────────────────────────────────────────────────────────
; Policy Type
; ───────────────────────────────────────────────────────────────────────────────
type = (
    captive_reinsurance,                           ; Captive reinsurance arrangement
    excess_loss,                                   ; Excess loss coverage
    pool,                                         ; Pool/recourse
    primary                                       ; Standard primary MI
)

; ───────────────────────────────────────────────────────────────────────────────
; Underwriting Authority
; ───────────────────────────────────────────────────────────────────────────────
delegated_underwriting = ?                        ; Delegated underwriting allowed
delegated_authority_limit = #$:(0..)              ; Dollar limit for delegated authority
non_delegated_review_required = ?                 ; Non-delegated review required

; ───────────────────────────────────────────────────────────────────────────────
; GSE Approval
; ───────────────────────────────────────────────────────────────────────────────
fannie_mae_approved = ?                           ; Fannie Mae approved insurer
freddie_mac_approved = ?                          ; Freddie Mac approved insurer
pmiers_compliant = ?                              ; Private Mortgage Insurer Eligibility
last_pmiers_certification_date = date             ; Date of last PMIERs certification

; ───────────────────────────────────────────────────────────────────────────────
; Policy Terms and Conditions
; ───────────────────────────────────────────────────────────────────────────────

{.claims_provisions}
notice_of_default_days = ##:(0..)                 ; Days to notify MI of default
claim_filing_deadline_months = ##:(0..)           ; Months after foreclosure
property_acquisition_deadline_days = ##:(0..)     ; Days to acquire property after foreclosure
maximum_claim_amount = #$:(0..)                   ; Maximum claim amount allowed

{@mi_master_policy}

{.exclusions}
; Standard master policy exclusions
fraud_misrepresentation = ?true                   ; Fraud or misrepresentation exclusion
physical_damage_unrepaired = ?true                ; Unrepaired physical damage exclusion
environmental_contamination = ?true               ; Environmental contamination exclusion
foreclosure_not_completed = ?true                 ; Foreclosure not completed exclusion
documentation_deficiency = ?true                  ; Documentation deficiency exclusion

{@mi_master_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Rescission Terms
; ───────────────────────────────────────────────────────────────────────────────
{.rescission}
rescission_period_months = ##:(0..)               ; Time to rescind
rescission_relief_available = ?                   ; Rescission relief available
rescission_relief_months = ##:(0..)               ; Months until relief
early_rescission_relief_program = ?               ; Independent validation

{@mi_master_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Billing and Administration
; ───────────────────────────────────────────────────────────────────────────────
billing_method = (
    direct_bill,                                   ; Direct bill to lender
    electronic,                                    ; Electronic billing
    servicer_remittance                            ; Servicer remittance
)

remittance_frequency = (
    monthly,                                       ; Monthly remittance
    quarterly                                      ; Quarterly remittance
)

electronic_submission = ?                         ; Electronic submission allowed
batch_commitment_allowed = ?                      ; Batch commitments allowed

{@mi_master_policy}

; ═══════════════════════════════════════════════════════════════════════════════
; MI Claim
; ═══════════════════════════════════════════════════════════════════════════════
; Claim filed under mortgage insurance for borrower default.

{@mi_claim}
id = :                                            ; Unique identifier for the claim

; ───────────────────────────────────────────────────────────────────────────────
; Claim Identification
; ───────────────────────────────────────────────────────────────────────────────
number = :                                        ; Claim number
certificate_number = :                            ; MI certificate number
loan_number = :                                   ; Loan number

; ───────────────────────────────────────────────────────────────────────────────
; Claim Type
; ───────────────────────────────────────────────────────────────────────────────
claim_type = (
    percentage_claim,                             ; Standard - % of loss
    pool_claim,                                   ; Pool/recourse claim
    total_claim                                   ; Full claim amount
)

; ───────────────────────────────────────────────────────────────────────────────
; Default and Foreclosure Timeline
; ───────────────────────────────────────────────────────────────────────────────
first_delinquency_date = date                     ; Date of first delinquency
default_reported_date = date                      ; Date default was reported to MI
foreclosure_start_date = date                     ; Date foreclosure initiated
foreclosure_completion_date = date                ; Date foreclosure completed
property_acquisition_date = date                  ; REO date

; ───────────────────────────────────────────────────────────────────────────────
; Loss Mitigation Attempts
; ───────────────────────────────────────────────────────────────────────────────
loss_mitigation_attempted = ?                     ; Loss mitigation was attempted

{.loss_mitigation}
modification_offered = ?:if loss_mitigation_attempted = true ; Loan modification offered
modification_completed = ?:if loss_mitigation_attempted = true ; Loan modification completed
repayment_plan_offered = ?:if loss_mitigation_attempted = true ; Repayment plan offered
forbearance_granted = ?:if loss_mitigation_attempted = true ; Forbearance granted
short_sale_attempted = ?:if loss_mitigation_attempted = true ; Short sale attempted
deed_in_lieu_offered = ?:if loss_mitigation_attempted = true ; Deed in lieu offered

{@mi_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Claim Submission
; ───────────────────────────────────────────────────────────────────────────────
claim_submission_date = date                      ; Date claim was submitted
claim_submission_type = (
    electronic,                                    ; Electronic submission
    paper                                          ; Paper submission
)

{.required_documents}
note = ?                                          ; Promissory note provided
mortgage = ?                                      ; Mortgage/deed of trust provided
title_policy = ?                                  ; Title policy provided
appraisal = ?                                     ; Appraisal provided
property_inspection = ?                           ; Property inspection provided
foreclosure_documents = ?                         ; Foreclosure documents provided
settlement_statement = ?                          ; Settlement statement provided
proof_of_loss = ?                                 ; Proof of loss provided
property_disposition_documents = ?                ; Property disposition documents provided

{@mi_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Claim Amounts
; ───────────────────────────────────────────────────────────────────────────────

{.unpaid_principal_balance}
principal = #$:(0..)                              ; Unpaid principal balance
accrued_interest = #$:(0..)                       ; Accrued interest
escrow_advances = #$:(0..)                        ; Escrow advances made
corporate_advances = #$:(0..)                     ; Corporate advances made
foreclosure_costs = #$:(0..)                      ; Foreclosure costs
property_preservation = #$:(0..)                  ; Property preservation costs
total_indebtedness = #$:(0..)                     ; Total indebtedness

{@mi_claim}

{.property_disposition}
sale_price = #$:(0..)                             ; Property sale price
sale_date = date                                  ; Date property sold
disposition_type = (
    deed_in_lieu,                                  ; Deed in lieu of foreclosure
    foreclosure_sale,                              ; Foreclosure sale
    reo_sale,                                      ; REO sale
    short_sale                                     ; Short sale
)
net_proceeds = #$:(0..)                           ; Net proceeds from sale

{@mi_claim}

{.loss_calculation}
total_indebtedness = #$:(0..)                     ; Total indebtedness
net_proceeds = #$:(0..)                           ; Net proceeds from sale
gross_loss = #$:(0..)                             ; Gross loss amount
coverage_percentage = ##:(0..100)                 ; Coverage percentage
amount = #$:(0..)                                 ; gross_loss * coverage_percentage
:invariant amount <= gross_loss

{@mi_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Claim Status
; ───────────────────────────────────────────────────────────────────────────────
status = (
    additional_docs_requested,                     ; Additional documents requested
    approved,                                      ; Claim approved
    denied,                                        ; Claim denied
    paid,                                          ; Claim paid
    partially_approved,                            ; Claim partially approved
    rescinded,                                     ; Claim rescinded
    submitted,                                     ; Claim submitted
    under_review,                                  ; Claim under review
    withdrawn                                      ; Claim withdrawn
)

status_date = date                                ; Date of current status

; ───────────────────────────────────────────────────────────────────────────────
; Claim Decision
; ───────────────────────────────────────────────────────────────────────────────
decision_date = date                              ; Date of claim decision
approved_amount = #$:(0..)                        ; Amount approved
paid_amount = #$:(0..)                            ; Amount paid
payment_date = date                               ; Date payment made

curtailment_amount = #$:(0..)                     ; Reduction for servicer issues
curtailment_reason = (
    documentation_deficiency,                      ; Documentation deficiency
    foreclosure_delay,                             ; Foreclosure delay
    late_default_notice,                           ; Late default notice
    loss_mitigation_failure,                       ; Loss mitigation failure
    property_damage                                ; Property damage
)

denial_reason = (
    documentation_insufficient,                    ; Documentation insufficient
    exclusion_applies,                             ; Policy exclusion applies
    fraud_misrepresentation,                       ; Fraud or misrepresentation
    late_filing,                                   ; Claim filed late
    material_breach,                               ; Material breach of policy
    property_damage,                               ; Property damage
    rescission                                     ; Coverage rescinded
):if status = denied

; ───────────────────────────────────────────────────────────────────────────────
; Appeal
; ───────────────────────────────────────────────────────────────────────────────
appeal_filed = ?                                  ; Appeal has been filed
appeal_date = date                                ; Date appeal filed
appeal_status = (
    partially_reversed,                            ; Decision partially reversed
    pending,                                       ; Appeal pending
    reversed,                                      ; Decision reversed
    upheld                                         ; Decision upheld
):if appeal_filed = true
appeal_decision_date = date:if appeal_filed = true ; Date of appeal decision
arbitration_requested = ?                         ; Arbitration requested

{@mi_claim}

; ═══════════════════════════════════════════════════════════════════════════════
; MI Default Notice
; ═══════════════════════════════════════════════════════════════════════════════
; Notice to MI company of loan delinquency/default.

{@mi_default_notice}
id = :                                            ; Unique identifier for the notice

; ───────────────────────────────────────────────────────────────────────────────
; Notice Identification
; ───────────────────────────────────────────────────────────────────────────────
notice_number = :                                 ; Default notice number
certificate_number = :                            ; MI certificate number
loan_number = :                                   ; Loan number

; ───────────────────────────────────────────────────────────────────────────────
; Notice Type
; ───────────────────────────────────────────────────────────────────────────────
notice_type = (
    delinquency_update,                           ; Monthly status update
    foreclosure_referral,                         ; Referred to foreclosure
    initial_default,                              ; First notice of default
    loss_mitigation_approved,                     ; Mod/workout approved
    paid_in_full,                                 ; Loan paid off
    property_acquired,                            ; Property taken REO
    reinstated                                    ; Loan brought current
)

; ───────────────────────────────────────────────────────────────────────────────
; Notice Details
; ───────────────────────────────────────────────────────────────────────────────
notice_date = date                                ; Date notice sent
reported_by = :                                   ; Servicer contact

delinquency_date = date                           ; Date of delinquency
months_delinquent = ##:(0..)                      ; Number of months delinquent
unpaid_installments = ##:(0..)                    ; Number of unpaid installments
unpaid_amount = #$:(0..)                          ; Total unpaid amount

; ───────────────────────────────────────────────────────────────────────────────
; Borrower Contact Efforts
; ───────────────────────────────────────────────────────────────────────────────
borrower_contacted = ?                            ; Borrower has been contacted
last_contact_date = date                          ; Date of last contact
contact_method = (
    email,                                         ; Email contact
    in_person,                                     ; In-person contact
    mail,                                          ; Mail contact
    phone                                          ; Phone contact
)
right_party_contact = ?                           ; Right party contact made

; ───────────────────────────────────────────────────────────────────────────────
; Loss Mitigation Status
; ───────────────────────────────────────────────────────────────────────────────
loss_mitigation_status = (
    approved,                                      ; Loss mitigation approved
    borrower_declined,                             ; Borrower declined
    denied,                                        ; Loss mitigation denied
    in_review,                                     ; Under review
    not_eligible,                                  ; Not eligible
    not_started,                                   ; Not started
    trial_period                                   ; In trial period
)

workout_type = (
    deed_in_lieu,                                  ; Deed in lieu
    forbearance,                                   ; Forbearance agreement
    modification,                                  ; Loan modification
    none,                                          ; No workout
    repayment_plan,                                ; Repayment plan
    short_sale                                     ; Short sale
)

; ───────────────────────────────────────────────────────────────────────────────
; Acknowledgment
; ───────────────────────────────────────────────────────────────────────────────
mi_acknowledged = ?                               ; MI company acknowledged notice
acknowledgment_date = date                        ; Date MI acknowledged
mi_reference_number = :                           ; MI's reference number

{@mi_default_notice}

; ═══════════════════════════════════════════════════════════════════════════════
; MI Pool Insurance
; ═══════════════════════════════════════════════════════════════════════════════
; Pool-level insurance for credit enhancement on loan portfolios/MBS.

{@mi_pool_insurance}
id = :                                            ; Unique identifier for the pool insurance

; ───────────────────────────────────────────────────────────────────────────────
; Pool Identification
; ───────────────────────────────────────────────────────────────────────────────
pool_number = :                                   ; Pool identifier
policy_number = :                                 ; Pool insurance policy number

; ───────────────────────────────────────────────────────────────────────────────
; Pool Type
; ───────────────────────────────────────────────────────────────────────────────
pool_type = (
    gse_mbs,                                      ; Fannie/Freddie MBS
    pls,                                          ; Private label securities
    warehouse,                                    ; Warehouse line
    whole_loan                                    ; Whole loan sale
)

; ───────────────────────────────────────────────────────────────────────────────
; Pool Characteristics
; ───────────────────────────────────────────────────────────────────────────────
original_pool_balance = #$:(0..)                  ; Original pool balance
current_pool_balance = #$:(0..)                   ; Current pool balance
loan_count = ##                                   ; Number of loans in pool
weighted_average_ltv = #:(0..125)                 ; Weighted average LTV
weighted_average_credit_score = ##:(300..850)     ; Weighted average credit score
weighted_average_coupon = #:(0..30)               ; Weighted average coupon rate

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Structure
; ───────────────────────────────────────────────────────────────────────────────
coverage_type = (
    excess_loss,                                   ; Excess loss coverage
    first_loss,                                    ; First loss coverage
    stop_loss                                      ; Stop loss coverage
)

attachment_point = #:(0..100)                     ; Losses start here
detachment_point = #:(0..100)                     ; Coverage cap
coverage_amount = #$:(0..)                        ; Total coverage amount

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
upfront_premium = #$:(0..)                        ; Upfront premium amount
ongoing_premium_rate = #:(0..5)                   ; Ongoing premium rate
premium_basis = (
    current_balance,                               ; Based on current balance
    original_balance                               ; Based on original balance
)

; ───────────────────────────────────────────────────────────────────────────────
; Term
; ───────────────────────────────────────────────────────────────────────────────
effective_date = date                             ; Pool insurance effective date
expiration_date = date                            ; Pool insurance expiration date
run_off_coverage = ?                              ; Covers after expiration

; ───────────────────────────────────────────────────────────────────────────────
; Claims
; ───────────────────────────────────────────────────────────────────────────────
aggregate_claims_paid = #$:(0..)                  ; Total claims paid to date
remaining_coverage = #$:(0..)                     ; Remaining coverage available
claims_to_attachment = #$:(0..)                   ; Claims before attachment point reached

{@mi_pool_insurance}

; ═══════════════════════════════════════════════════════════════════════════════
; MI Servicer
; ═══════════════════════════════════════════════════════════════════════════════
; Loan servicer responsible for MI administration.

{@mi_servicer}
id = :                                            ; Unique identifier for the servicer

; ───────────────────────────────────────────────────────────────────────────────
; Servicer Identification
; ───────────────────────────────────────────────────────────────────────────────
servicer_name = :                                 ; Servicer company name
servicer_id = :                                   ; Servicer identifier
nmls_id = :                                       ; NMLS identifier

; ───────────────────────────────────────────────────────────────────────────────
; Contact
; ───────────────────────────────────────────────────────────────────────────────
address = @types.address                          ; Servicer address
mi_department_phone = *@phone                     ; MI department phone (confidential)
mi_department_email = *@email                     ; MI department email (confidential)
mi_department_fax = *@phone                       ; MI department fax (confidential)

; ───────────────────────────────────────────────────────────────────────────────
; Servicer Role
; ───────────────────────────────────────────────────────────────────────────────
role = (
    master_servicer,                               ; Master servicer
    servicer,                                      ; Primary servicer
    special_servicer,                              ; Special servicer (defaults)
    subservicer                                    ; Subservicer
)

; ───────────────────────────────────────────────────────────────────────────────
; MI Administration Capabilities
; ───────────────────────────────────────────────────────────────────────────────
electronic_submission = ?                         ; Electronic submission capability
batch_processing = ?                              ; Batch processing capability
default_reporting_compliant = ?                   ; Compliant with default reporting requirements
claims_filing_authorized = ?                      ; Authorized to file claims
cancellation_processing_authorized = ?            ; Authorized to process cancellations

; ───────────────────────────────────────────────────────────────────────────────
; Transfer Information
; ───────────────────────────────────────────────────────────────────────────────
transfer_effective_date = date                    ; Date servicing was transferred
prior_servicer_id = :                             ; Prior servicer identifier
prior_servicer_name = :                           ; Prior servicer name

{@mi_servicer}

; ═══════════════════════════════════════════════════════════════════════════════
; HPA Disclosure
; ═══════════════════════════════════════════════════════════════════════════════
; Homeowners Protection Act disclosure tracking.

{@hpa_disclosure}
id = :                                            ; Unique identifier for the disclosure

; ───────────────────────────────────────────────────────────────────────────────
; Disclosure Type
; ───────────────────────────────────────────────────────────────────────────────
disclosure_type = (
    annual,                                       ; Annual reminder
    cancellation_rights,                          ; When approaching 80%
    initial,                                      ; At closing
    termination_notice                            ; When MI cancelled
)

; ───────────────────────────────────────────────────────────────────────────────
; Disclosure Details
; ───────────────────────────────────────────────────────────────────────────────
disclosure_date = date                            ; Date disclosure was made
delivery_method = (
    closing_documents,                             ; Included in closing documents
    electronic,                                    ; Electronic delivery
    mail                                           ; Mailed to borrower
)

; ───────────────────────────────────────────────────────────────────────────────
; Content Required
; ───────────────────────────────────────────────────────────────────────────────
; Initial disclosure must include:
borrower_request_date_disclosed = ?              ; Date can request cancellation
auto_termination_date_disclosed = ?              ; Date MI auto-terminates
cancellation_requirements_disclosed = ?          ; Good payment history, etc.

; Annual disclosure must include:
cancellation_rights_explained = ?                ; Cancellation rights were explained
phone_number_provided = ?                        ; Contact phone number provided
address_provided = ?                             ; Contact address provided

; ───────────────────────────────────────────────────────────────────────────────
; Tracking
; ───────────────────────────────────────────────────────────────────────────────
sent_date = date                                  ; Date disclosure was sent
confirmed_delivery = ?                            ; Delivery confirmed
borrower_acknowledgment = ?                       ; Borrower acknowledged receipt
acknowledgment_date = date                        ; Date borrower acknowledged

{@hpa_disclosure}


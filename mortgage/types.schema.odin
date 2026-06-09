; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Mortgage Common Types
; ═══════════════════════════════════════════════════════════════════════════════
; Reusable type definitions for mortgage schemas including borrower, property,
; and financial structures shared across loan and servicing schemas.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.mortgage.types"
version = "1.0.0"
title = "Mortgage Common Types"
description = "Reusable type definitions for mortgage lending"

{$derivation}
source[0].authority = "CFPB"
source[0].citation = "TILA-RESPA Integrated Disclosure Rule (Regulation Z)"
source[0].url = "https://www.consumerfinance.gov/rules-policy/regulations/1026/"

source[1].authority = "Fannie Mae"
source[1].citation = "Selling Guide"
source[1].url = "https://selling-guide.fanniemae.com/"

source[2].authority = "Freddie Mac"
source[2].citation = "Seller/Servicer Guide"
source[2].url = "https://guide.freddiemac.com/"

source[3].authority = "CFPB"
source[3].citation = "HMDA Filing Instructions Guide"
source[3].url = "https://ffiec.cfpb.gov/documentation/publications/loan-level-datasets/lar-data-fields"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial mortgage common types schema"
changelog[0].rationale = "Base types derived from public regulatory requirements"

; ═══════════════════════════════════════════════════════════════════════════════
; BORROWER
; ═══════════════════════════════════════════════════════════════════════════════
; Per TRID/TILA-RESPA and Fannie Mae Selling Guide borrower requirements

{@borrower}
= @person                                     ; Inherits person fields (name, ssn, dob, contact)

; Override required fields - TRID requires full legal name on disclosures
{.name}
first = :                                    ; First/given name (required)
last = :                                     ; Last/family name (required)

{@borrower}

; Override required identifiers - Required for credit and verification
ssn = *:format ssn                           ; Social Security Number (required, confidential)
date_of_birth = *date                        ; Date of birth (required, confidential)

; Citizenship - Fannie Mae Selling Guide B3-3.1
citizenship_status = (non_permanent_resident, non_resident_alien, permanent_resident, us_citizen)

; Marital status - Affects property rights and liability
marital_status = (divorced, married, separated, single, unmarried, widowed)

; Dependents - For income qualification
dependent_count = ##:(0..)                    ; Number of dependents
dependent_ages[] = ##:(0..)                   ; Ages of dependents

; ===============================================================================
; MORTGAGE ADDRESS
; ===============================================================================
; Mortgage-specific address with ZIP validation.
; Different structure from common @address (uses zip vs postal_code).

{@mortgage_address}
line1 = :                                    ; Street address
line2 = :                                     ; Unit/apartment
city = :                                     ; City
state = :(2)                                 ; State code
zip = :/^\d{5}(-\d{4})?$/                    ; ZIP or ZIP+4
county = :                                    ; County name
country = :(2) "US"                           ; Country code

; ═══════════════════════════════════════════════════════════════════════════════
; EMPLOYMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per Fannie Mae Selling Guide B3-3.1 income/employment verification

{@employment}
employer_name = :                            ; Employer legal name
employer_address = @mortgage_address          ; Employer address
employer_phone = *:                           ; Employer phone

; Employment type - Fannie Mae categories
employment_type = (self_employed, w2_employee)
position = :                                  ; Job title
start_date = date                            ; Employment start date
end_date = date                               ; End date (if not current)
current = ?                                   ; Currently employed here

; Income - Monthly amounts per Fannie Mae requirements
{.income}
base_monthly = #$:(0..)                      ; Base monthly income
overtime_monthly = #$:(0..)                   ; Overtime income
bonus_monthly = #$:(0..)                      ; Bonus income
commission_monthly = #$:(0..)                 ; Commission income
other_monthly = #$:(0..)                      ; Other income
total_monthly = #$:(0..)                      ; Total monthly income

{@employment}

; Years in profession
years_in_profession = #:(0..)                 ; Years in line of work

; ═══════════════════════════════════════════════════════════════════════════════
; ASSET
; ═══════════════════════════════════════════════════════════════════════════════
; Per Fannie Mae Selling Guide B3-4 asset requirements

{@asset}
type = (bonds, checking, gift, money_market, mutual_fund, other, retirement, savings, stock)
institution = :                               ; Financial institution name
account_number = *:                           ; Account number (confidential)
balance = #$:(0..)                           ; Current balance

; For gift funds - Fannie Mae B3-4.3
{.gift}
donor_name = :                                ; Gift donor name
donor_relationship = :                        ; Relationship to borrower
gift_amount = #$:(0..)                        ; Gift amount

{@asset}

; ═══════════════════════════════════════════════════════════════════════════════
; LIABILITY
; ═══════════════════════════════════════════════════════════════════════════════
; Per Fannie Mae Selling Guide B3-6 liability requirements

{@liability}
type = (alimony, auto_loan, child_support, credit_card, heloc, installment, mortgage, other, student_loan)
creditor = :                                  ; Creditor name
account_number = *:                           ; Account number (confidential)
balance = #$:(0..)                            ; Outstanding balance
monthly_payment = #$:(0..)                   ; Monthly payment
months_remaining = ##:(0..)                   ; Months remaining
paid_off_at_close = ?                         ; Will be paid off at closing

; For mortgages
{.mortgage}
property_address = @mortgage_address          ; Property securing the debt
lien_position = ##:(1..)                      ; Lien position

{@liability}

; ═══════════════════════════════════════════════════════════════════════════════
; REAL ESTATE OWNED
; ═══════════════════════════════════════════════════════════════════════════════
; Per Fannie Mae B3-5 REO requirements

{@real_estate_owned}
property_address = @mortgage_address         ; Property address
property_type = (condo, manufactured, multi_family, pud, single_family, townhouse)
market_value = #$:(0..)                       ; Current market value
status = (pending_sale, rental, retained, sold)
disposition_date = date                       ; Sale/disposition date

; For rental properties
{.rental}
gross_rental_income = #$:(0..)                ; Monthly gross rent
vacancy_factor = #:(0..100)                   ; Vacancy rate percentage
net_rental_income = #$:(0..)                  ; Net rental income

{@real_estate_owned}

; Existing mortgage
{.existing_mortgage}
balance = #$:(0..)                            ; Current mortgage balance
monthly_payment = #$:(0..)                    ; Monthly payment
lender = :                                    ; Lender name

{@real_estate_owned}

; ═══════════════════════════════════════════════════════════════════════════════
; CREDIT
; ═══════════════════════════════════════════════════════════════════════════════
; Credit information per Fannie Mae B3-5 credit requirements

{@credit}
; Credit scores - Fannie Mae uses representative credit score methodology
{.scores}
equifax = ##:(300..850)                       ; Equifax FICO score
experian = ##:(300..850)                      ; Experian FICO score
transunion = ##:(300..850)                    ; TransUnion FICO score
representative = ##:(300..850)                ; Representative score (middle)

{@credit}

; Credit report details
report_date = date                            ; Credit report date
report_id = :                                 ; Credit report identifier

; Derogatory information
{.derogatory}
bankruptcy = ?                                ; Bankruptcy on record
bankruptcy_type = (chapter_11, chapter_12, chapter_13, chapter_7)
bankruptcy_discharge_date = date              ; Discharge date
foreclosure = ?                               ; Foreclosure on record
foreclosure_date = date                       ; Foreclosure date
short_sale = ?                                ; Short sale/pre-foreclosure
deed_in_lieu = ?                              ; Deed in lieu of foreclosure

{@credit}

; ═══════════════════════════════════════════════════════════════════════════════
; PROPERTY
; ═══════════════════════════════════════════════════════════════════════════════
; Subject property per TRID and Fannie Mae requirements

{@property}
address = @mortgage_address                  ; Property address

; Property type - Per Fannie Mae property eligibility
property_type = (condo, cooperative, manufactured, multi_family, pud, single_family, townhouse)
units = ##:(1..4)                             ; Number of units (1-4 for residential)
occupancy = (investment, primary, second_home)

; Property details
year_built = ##:(1800..2100)                  ; Year constructed
lot_size_sqft = ##:(0..)                      ; Lot size in square feet
living_area_sqft = ##:(0..)                   ; Living area square feet
bedrooms = ##:(0..)                           ; Number of bedrooms
bathrooms = #:(0..)                           ; Number of bathrooms

; Valuation - Required for underwriting
{.valuation}
appraised_value = #$:(0..)                    ; Appraised value
appraisal_date = date                         ; Appraisal date
purchase_price = #$:(0..)                     ; Contract purchase price
estimated_value = #$:(0..)                    ; Estimated value (pre-appraisal)

{@property}

; Legal description
{.legal}
parcel_id = :                                 ; Tax parcel/APN number
legal_description = :                         ; Legal description
lot = :                                       ; Lot number
block = :                                     ; Block number
subdivision = :                               ; Subdivision name

{@property}

; Title
{.title}
manner_held = (community_property, joint_tenancy, sole_ownership, tenancy_by_entirety, tenancy_in_common)
vesting_name = :                              ; Name(s) on title

{@property}

; ═══════════════════════════════════════════════════════════════════════════════
; LOAN AMOUNT TYPE
; ═══════════════════════════════════════════════════════════════════════════════
; Monetary amounts with optional purpose designation

{@loan_amount}
amount = #$:(0..)                            ; Dollar amount
currency = :(3) "USD"                         ; Currency (default USD)

; ═══════════════════════════════════════════════════════════════════════════════
; HMDA DATA
; ═══════════════════════════════════════════════════════════════════════════════
; Home Mortgage Disclosure Act data fields per CFPB HMDA requirements

{@hmda_data}
; Application/Action - HMDA LAR field requirements
action_taken = (application_approved_not_accepted, application_denied, application_withdrawn, file_closed_incomplete, loan_originated, loan_purchased, preapproval_denied, preapproval_granted)
action_date = date                           ; Date of action

; Loan information
loan_type = (conventional, fha, fsa_rhs, va) ; Loan type (1-4)
loan_purpose = (cash_out_refinance, home_improvement, home_purchase, other, refinance)
preapproval = (not_applicable, preapproval_not_requested, preapproval_requested)

; Property information
construction_method = (manufactured, site_built)
occupancy_type = (investment, principal_residence, second_residence)

; Census tract
census_tract = :/^\d{11}$/                    ; 11-digit census tract

; Ethnicity - HMDA ethnicity codes
ethnicity_applicant = (cuban, hispanic_or_latino, mexican, not_applicable, not_hispanic_or_latino, other_hispanic, puerto_rican)
ethnicity_coapplicant = (cuban, hispanic_or_latino, mexican, not_applicable, not_hispanic_or_latino, other_hispanic, puerto_rican)

; Race - HMDA race codes
race_applicant = (american_indian, asian, black, native_hawaiian, not_applicable, white)
race_coapplicant = (american_indian, asian, black, native_hawaiian, not_applicable, white)

; Sex
sex_applicant = (female, male, not_applicable)
sex_coapplicant = (female, male, not_applicable)

; Age
age_applicant = ##:(0..)                      ; Applicant age
age_coapplicant = ##:(0..)                    ; Co-applicant age

; Income and debt
gross_annual_income = ##                      ; Gross annual income (thousands)
debt_to_income_ratio = :                      ; DTI ratio or NA/Exempt

; Denial reasons (if applicable)
denial_reasons[] = (collateral, credit_application_incomplete, credit_history, debt_to_income, employment_history, insufficient_cash, mortgage_insurance_denied, other, unverifiable_information)

; Pricing - HMDA rate spread
rate_spread = #.2                             ; Rate spread (if applicable)
hoepa_status = ?(high_cost, not_high_cost)    ; HOEPA status

; Lien status
lien_status = (not_applicable, not_secured, secured_first_lien, secured_subordinate_lien)


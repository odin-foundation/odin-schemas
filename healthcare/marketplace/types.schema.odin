; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Health Insurance Marketplace Types Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Common reusable types for ACA Marketplace/Exchange operations including
; applicant, household, income, and contact preference types. Derived from
; 45 CFR Parts 155-156 and CMS Marketplace guidance.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.marketplace.types"
version = "1.0.0"
title = "Health Insurance Marketplace Types Schema"
description = "Common types for ACA Marketplace operations"

{$derivation}
source[0].authority = "GPO"
source[0].citation = "45 CFR Part 155 - Exchange Establishment Standards"
source[0].url = "https://www.ecfr.gov/current/title-45/subtitle-A/subchapter-B/part-155"

source[1].authority = "CMS"
source[1].citation = "HealthCare.gov Application Instructions"
source[1].url = "https://www.healthcare.gov/quick-guide/"

source[2].authority = "CMS"
source[2].citation = "Federally-facilitated Exchange Operations Manual"
source[2].url = "https://www.cms.gov/cciio/Resources/Regulations-and-Guidance"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial Marketplace types schema"
changelog[0].rationale = "Structure derived from 45 CFR Part 155 and CMS FFE guidance"

; ═══════════════════════════════════════════════════════════════════════════════
; APPLICANT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.305

{@applicant}
applicant_id = !:                           ; Applicant identifier

; Demographics
{.demographics}
first_name = !:                             ; First name
middle_name = :                             ; Middle name
last_name = !:                              ; Last name
suffix = :                                  ; Suffix
dob = !*date                                ; Date of birth
gender = (female, male, other)              ; Gender
ssn = *:                                    ; SSN (optional)
no_ssn_reason = :                           ; Reason if no SSN

{@applicant}

; Contact
address = !@marketplace_address             ; Residential address
mailing_address = @marketplace_address      ; Mailing if different
phone = *@phone                             ; Phone number
email = *@email                             ; Email address
preferred_language = : "en"                 ; Preferred language

{@applicant}

; Citizenship/immigration - Per 45 CFR 155.315
{.immigration}
citizenship_status = !(lawfully_present, naturalized, non_citizen, us_citizen)
immigration_status = :                      ; Immigration category
alien_number = *:                           ; Alien number (A-number)
i94_number = *:                             ; I-94 number
sevis_id = *:                               ; SEVIS ID
immigration_document_type = :               ; Document type
five_year_bar_applies = ?                   ; 5-year bar for immigrants

{@applicant}

; Incarceration - Per 45 CFR 155.305(a)(2)
incarcerated = ?                            ; Currently incarcerated

; Tribal membership
{.tribal}
tribal_member = ?                           ; Member of federally-recognized tribe
tribe_name = :                              ; Tribe name
tribal_id = :                               ; Tribal enrollment number

{@applicant}

; ═══════════════════════════════════════════════════════════════════════════════
; MARKETPLACE ADDRESS
; ═══════════════════════════════════════════════════════════════════════════════
; ACA Marketplace-specific address with county FIPS and rating area.
; Different structure from common @address.

{@marketplace_address}
address_1 = !:                              ; Street address line 1
address_2 = :                               ; Street address line 2
city = !:                                   ; City
state = !:(2)                               ; State code
zip = !:(5)                                 ; ZIP code
county_fips = :(5)                          ; County FIPS code
rating_area = :                             ; Rating area

; ═══════════════════════════════════════════════════════════════════════════════
; HOUSEHOLD
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.305(f) - Tax household for APTC/CSR

{@household}
household_id = !:                           ; Household identifier
tax_year = !##:(2014..)                     ; Tax year
filing_status = !(head_of_household, married_filing_jointly, married_filing_separately, qualifying_widow, single)

; Tax filer
tax_filer = !@applicant                     ; Primary tax filer
spouse = @applicant                         ; Spouse if MFJ

; Dependents
dependents[] = @applicant                   ; Tax dependents

; Household size for APTC - Per 45 CFR 155.305(f)
{.aptc_household}
household_size = !##:(1..)                  ; Household size
include_applicants[] = :                    ; Applicants included

{@household}

; ═══════════════════════════════════════════════════════════════════════════════
; INCOME
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.305(f) - MAGI for Marketplace

{@income}
applicant_id = !:                           ; Applicant
tax_year = !##:(2014..)                     ; Tax year

; Projected annual income
{.annual}
wages = #$:(0..)                            ; Wages, salaries, tips
self_employment = #$                        ; Self-employment income
unemployment = #$:(0..)                     ; Unemployment compensation
social_security = #$:(0..)                  ; Social Security benefits
pension = #$:(0..)                          ; Pension/retirement
investment = #$                             ; Investment income
alimony_received = #$:(0..)                 ; Alimony received (pre-2019)
other_income = #$                           ; Other income
total_income = #$                           ; Total income

{@income}

; MAGI adjustments - Per IRC 62
{.adjustments}
student_loan_interest = #$:(0..)            ; Student loan interest deduction
educator_expenses = #$:(0..)                ; Educator expenses
hsa_deduction = #$:(0..)                    ; HSA deduction
self_employment_tax = #$:(0..)              ; Self-employment tax (half)
alimony_paid = #$:(0..)                     ; Alimony paid (pre-2019)
other_adjustments = #$:(0..)                ; Other adjustments
total_adjustments = #$:(0..)                ; Total adjustments

{@income}

; MAGI calculation
{.magi}
agi = #$                                    ; Adjusted Gross Income
foreign_income = #$:(0..)                   ; Foreign earned income
tax_exempt_interest = #$:(0..)              ; Tax-exempt interest
non_taxable_ss = #$:(0..)                   ; Non-taxable Social Security
magi = #$                                   ; Modified AGI

{@income}

; ═══════════════════════════════════════════════════════════════════════════════
; HOUSEHOLD INCOME
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.305(f) - Household income for APTC

{@household_income}
household_id = !:                           ; Household
tax_year = !##:(2014..)                     ; Tax year

; Income totals
total_magi = #$                             ; Total household MAGI
household_size = !##:(1..)                  ; Household size

; FPL calculation - Per annual HHS guidelines
fpl_amount = #$:(0..)                       ; FPL for household size
fpl_percent = #:(0..)                       ; Income as percent of FPL

; Income ranges for eligibility
below_100_fpl = ?                           ; Below 100% FPL
between_100_138_fpl = ?                     ; 100-138% FPL (Medicaid gap)
between_100_400_fpl = ?                     ; 100-400% FPL (APTC eligible)
above_400_fpl = ?                           ; Above 400% FPL

; ═══════════════════════════════════════════════════════════════════════════════
; COVERAGE INFORMATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.305(f)(4) - MEC and employer coverage

{@coverage_info}
applicant_id = !:                           ; Applicant

; Current coverage
{.current}
covered = ?                                 ; Currently has coverage
coverage_type = (chip, employer, individual, medicaid, medicare, military, other, tricare, va)
coverage_start = date                       ; Coverage start date
coverage_end = date                         ; Coverage end date
plan_name = :                               ; Plan name
insurer_name = :                            ; Insurer name

{@coverage_info}

; Employer coverage - Per 45 CFR 155.305(f)(4)
{.employer}
employer_offer = ?                          ; Employer offers coverage
employer_name = :                           ; Employer name
employer_ein = :                            ; Employer EIN
coverage_offered_to = :                     ; Who coverage is offered to
employee_premium = #$:(0..)                 ; Employee-only monthly premium
affordable = ?                              ; Meets affordability standard
minimum_value = ?                           ; Meets minimum value

{@coverage_info}

; Access to other coverage
{.other}
access_to_medicare = ?                      ; Eligible for Medicare
access_to_medicaid = ?                      ; Eligible for Medicaid
access_to_chip = ?                          ; Eligible for CHIP

{@coverage_info}

; ═══════════════════════════════════════════════════════════════════════════════
; VERIFICATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.315 - Verification process

{@verification}
verification_id = !:                        ; Verification ID
applicant_id = !:                           ; Applicant
verification_type = !(citizenship, identity, immigration, income, incarceration, mec, residency, ssn, tribal)
verification_date = !date                   ; Date verified

; Data source
{.source}
source_type = !(document, electronic, self_attestation)
data_source = :                             ; Specific data source
hub_response = :                            ; Federal Data Hub response

{@verification}

; Result
{.result}
verified = ?                                ; Successfully verified
inconsistency = ?                           ; Data inconsistency found
inconsistency_description = :               ; Description of inconsistency

{@verification}

; Resolution - Per 45 CFR 155.315(f)
{.resolution}
resolution_required = ?                     ; Resolution needed
resolution_deadline = date                  ; Deadline for resolution
documents_requested[] = :                   ; Documents requested
resolved = ?                                ; Resolved
resolution_date = date                      ; Date resolved

{@verification}

; ═══════════════════════════════════════════════════════════════════════════════
; ISSUER
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 156.20

{@issuer}
issuer_id = !:                              ; HIOS issuer ID
name = !:                                   ; Issuer name
state = !:(2)                               ; State
market = !(individual, shop, both)          ; Market participation

; Contact
address = @marketplace_address              ; Address
phone = *@phone                             ; Phone
website = :                                 ; Website

{@issuer}

; Certification
{.certification}
ffe_certified = ?                           ; FFE certified
sbm_certified = ?                           ; SBM certified
certification_year = ##:(2014..)            ; Certification year

{@issuer}

; ═══════════════════════════════════════════════════════════════════════════════
; RATING AREA
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 147.102

{@rating_area}
state = !:(2)                               ; State
rating_area_id = !:                         ; Rating area identifier
name = :                                    ; Rating area name
counties[] = :                              ; Counties (FIPS)
zip_codes[] = :                             ; ZIP codes
effective_date = date                       ; Effective date

; ═══════════════════════════════════════════════════════════════════════════════
; SERVICE AREA
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 156.235

{@service_area}
service_area_id = !:                        ; Service area ID
issuer_id = !:                              ; Issuer
name = :                                    ; Service area name
state = !:(2)                               ; State
counties[] = :                              ; Counties served (FIPS)
zip_codes[] = :                             ; ZIP codes served
partial_county = ?                          ; Partial county service area

; ═══════════════════════════════════════════════════════════════════════════════
; ENROLLMENT PERIOD
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.410

{@enrollment_period}
period_type = !(initial, open, sep, shop_open)
plan_year = !##:(2014..)                    ; Plan year
start_date = !date                          ; Period start
end_date = !date                            ; Period end
coverage_effective = date                   ; Coverage effective date

; ═══════════════════════════════════════════════════════════════════════════════
; NOTICE
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.230

{@notice}
notice_id = !:                              ; Notice ID
notice_type = !(eligibility, enrollment, redetermination, sep, termination, verification)
applicant_id = !:                           ; Applicant/enrollee
issue_date = !date                          ; Date issued
response_deadline = date                    ; Response deadline if applicable
delivery_method = (electronic, mail)        ; Delivery method

; Content
subject = :                                 ; Subject
body = :                                    ; Notice body
appeal_rights = ?                           ; Appeal rights included


; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Property Tax Assessment Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Property tax assessment and appeal management including assessment records,
; tax bill calculations, exemptions (homestead, senior, veteran, etc.), and
; the assessment appeal process with hearing and determination tracking.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as common
@import "../types.schema.odin" as re

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.realestate.valuation.assessment"
version = "1.0.0"
title = "Property Tax Assessment Schema"
description = "Property tax assessment, valuation, and appeals"

{$derivation}
source[0].authority = "International Association of Assessing Officers"
source[0].citation = "Standard on Property Tax Policy"
source[0].url = "https://www.iaao.org/wcm/Resources/Publications_access/Technical_Standards/wcm/Resources_Content/Pubs/Technical_Standards.aspx"

source[1].authority = "State/Local Assessor Offices"
source[1].citation = "Property Tax Assessment Requirements"
source[1].url = "https://www.law.cornell.edu/wex/property_tax"

source[2].authority = "Lincoln Institute of Land Policy"
source[2].citation = "Property Tax in America"
source[2].url = "https://www.lincolninst.edu/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Assessment schema derived from IAAO standards and common state practices"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial assessment schema"
changelog[0].rationale = "Comprehensive property tax assessment structure"

; ═══════════════════════════════════════════════════════════════════════════════
; ASSESSMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Property assessment record

{@assessment}
; Required fields first
assessed_value = !#$:(0..)                           ; Assessed value
property_address = !@address                         ; Property address
tax_year = !##:(1900..2100)                          ; Tax/assessment year

; Assessment identification
assessment_id = :                                    ; Unique assessment identifier
parcel_number = :                                    ; Parcel/APN number
account_number = *:                                   ; Tax account number

; Parcel reference
parcel = @re_parcel_identifiers                      ; Full parcel identifiers

; ───────────────────────────────────────────────────────────────────────────────
; Ownership
; ───────────────────────────────────────────────────────────────────────────────
{.ownership}
owner_name = :                                       ; Owner name (as shown on roll)
owner_mailing_address = @address                     ; Mailing address
owner_type = (corporation, estate, government, individual, llc, partnership, trust)
vesting = :                                          ; Vesting description

{@assessment}

; Co-owners
{.ownership.co_owners[]}
name = :                                             ; Co-owner name
ownership_percent = #:(0..100)                       ; Ownership percentage

{@assessment}

; ───────────────────────────────────────────────────────────────────────────────
; Property Classification
; ───────────────────────────────────────────────────────────────────────────────
{.classification}
property_class = :                                   ; Property class code
property_class_description = :                       ; Class description
use_code = :                                         ; Land use code
use_description = :                                  ; Use description
zoning = :                                           ; Zoning designation
land_use_type = (agricultural, commercial, exempt, industrial, residential, special, vacant)

{@assessment}

; ───────────────────────────────────────────────────────────────────────────────
; Land
; ───────────────────────────────────────────────────────────────────────────────
{.land}
land_area_sqft = ##:(0..)                            ; Land area square feet
land_area_acres = #:(0..)                            ; Land area acres
front_feet = #:(0..)                                 ; Frontage feet
depth = #:(0..)                                      ; Depth feet
land_value = #$:(0..)                                ; Assessed land value
land_value_per_sqft = #$:(0..)                       ; Land value per sqft
land_value_per_acre = #$:(0..)                       ; Land value per acre
topography = :                                       ; Topography description
shape = :                                            ; Lot shape
corner_lot = ?                                       ; Is corner lot
waterfront = ?                                       ; Waterfront property

{@assessment}

; ───────────────────────────────────────────────────────────────────────────────
; Improvements
; ───────────────────────────────────────────────────────────────────────────────
{.improvements}
improvement_value = #$:(0..)                         ; Assessed improvement value
total_sqft = ##:(0..)                                ; Total building sqft
living_area = ##:(0..)                               ; Living area sqft
year_built = ##:(1600..2100)                         ; Year built
effective_year = ##:(1600..2100)                     ; Effective year built
stories = #:(0..)                                    ; Number of stories
bedrooms = ##:(0..)                                  ; Bedroom count
bathrooms = #:(0..)                                  ; Bathroom count
rooms = ##:(0..)                                     ; Total room count
construction_type = :                                ; Construction type
exterior_wall = :                                    ; Exterior wall material
roof_type = :                                        ; Roof type
heating = :                                          ; Heating type
cooling = :                                          ; Cooling type
quality_grade = :                                    ; Quality grade/class
condition = :                                        ; Condition rating
basement = ?                                         ; Has basement
basement_sqft = ##:(0..):if basement = true          ; Basement square feet
basement_finished_sqft = ##:(0..)                    ; Finished basement sqft
garage = ?                                           ; Has garage
garage_sqft = ##:(0..):if garage = true              ; Garage square feet
pool = ?                                             ; Has pool

{@assessment}

; Additional improvements
{.improvements.additional[]}
improvement_type = :                                 ; Type (shed, barn, etc.)
description = :                                      ; Description
sqft = ##:(0..)                                      ; Square feet
year_built = ##:(1600..2100)                         ; Year built
value = #$:(0..)                                     ; Assessed value

{@assessment}

; ───────────────────────────────────────────────────────────────────────────────
; Valuation
; ───────────────────────────────────────────────────────────────────────────────
{.valuation}
land_value = #$:(0..)                                ; Assessed land value
improvement_value = #$:(0..)                         ; Assessed improvement value
total_assessed_value = #$:(0..)                      ; Total assessed value
market_value = #$:(0..)                              ; Estimated market value
assessment_ratio = #:(0..100)                        ; Assessment ratio percentage
taxable_value = #$:(0..)                             ; Taxable value after exemptions
capped_value = #$:(0..)                              ; Value after assessment cap
prior_year_value = #$:(0..)                          ; Prior year assessed value
value_change = #$                                    ; Change from prior year
value_change_percent = #                             ; Percentage change

{@assessment}

; Valuation methodology
{.valuation.methodology}
approach_used = (cost, income, market, mass_appraisal)
valuation_date = date                                ; Date of valuation
reassessment_year = ?                                ; Is reassessment year
cost_factor = #:(0..)                                ; Cost approach factor
market_factor = #:(0..)                              ; Market adjustment factor

{@assessment}

; ───────────────────────────────────────────────────────────────────────────────
; Exemptions
; ───────────────────────────────────────────────────────────────────────────────
{.exemptions[]}
exemption_type = (agricultural, charitable, disability, government, historic, homestead, religious, senior, veteran)
exemption_code = :                                   ; Exemption code
exemption_description = :                            ; Description
exemption_amount = #$:(0..)                          ; Exemption amount
exemption_percent = #:(0..100)                       ; Exemption percentage
application_date = date                              ; Application date
approval_date = date                                 ; Approval date
expiration_date = date                               ; Expiration date (if applicable)
status = (active, denied, expired, pending)

{@assessment}

; ───────────────────────────────────────────────────────────────────────────────
; Special Assessments
; ───────────────────────────────────────────────────────────────────────────────
{.special_assessments[]}
assessment_type = :                                  ; Type (improvement district, etc.)
district_name = :                                    ; District name
assessment_number = :                                ; Assessment number
principal_balance = #$:(0..)                         ; Remaining principal
annual_payment = #$:(0..)                            ; Annual payment
remaining_years = ##:(0..)                           ; Years remaining
status = (active, paid_off, pending)

{@assessment}

; ───────────────────────────────────────────────────────────────────────────────
; Assessment History
; ───────────────────────────────────────────────────────────────────────────────
{.history[]}
tax_year = ##:(1900..2100)                           ; Tax year
land_value = #$:(0..)                                ; Land value
improvement_value = #$:(0..)                         ; Improvement value
total_value = #$:(0..)                               ; Total assessed value
taxable_value = #$:(0..)                             ; Taxable value

{@assessment}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
roll_status = (certified, pending, supplemental, under_appeal)
roll_date = date                                     ; Roll certification date
updated = date                                       ; Last update date

; ═══════════════════════════════════════════════════════════════════════════════
; TAX BILL
; ═══════════════════════════════════════════════════════════════════════════════
; Property tax bill/statement

{@tax_bill}
; Required fields first
bill_amount = !#$:(0..)                              ; Total tax bill amount
property_address = !@address                         ; Property address
tax_year = !##:(1900..2100)                          ; Tax year

; Bill identification
bill_id = :                                          ; Unique bill identifier
bill_number = :                                      ; Bill/statement number
parcel_number = :                                    ; Parcel number
account_number = *:                                   ; Account number

; Assessment reference
assessment_ref = @assessment                         ; Reference to assessment

; ───────────────────────────────────────────────────────────────────────────────
; Values
; ───────────────────────────────────────────────────────────────────────────────
{.values}
assessed_value = #$:(0..)                            ; Assessed value
taxable_value = #$:(0..)                             ; Taxable value
exemption_value = #$:(0..)                           ; Total exemptions

{@tax_bill}

; ───────────────────────────────────────────────────────────────────────────────
; Tax Breakdown
; ───────────────────────────────────────────────────────────────────────────────
{.taxes[]}
taxing_authority = :                                 ; Taxing authority name
authority_type = (city, county, library, miscellaneous, school, special_district, state)
tax_rate = #:(0..)                                   ; Tax rate (mills or percentage)
rate_type = (mills, percent)                         ; Rate type
tax_amount = #$:(0..)                                ; Tax amount

{@tax_bill}

; ───────────────────────────────────────────────────────────────────────────────
; Totals
; ───────────────────────────────────────────────────────────────────────────────
{.totals}
total_tax_rate = #:(0..)                             ; Combined tax rate
ad_valorem_taxes = #$:(0..)                          ; Ad valorem taxes
non_ad_valorem = #$:(0..)                            ; Non-ad valorem assessments
gross_tax = #$:(0..)                                 ; Gross tax before discounts
discounts = #$:(0..)                                 ; Early payment discounts
penalties = #$:(0..)                                 ; Penalties (if delinquent)
interest = #$:(0..)                                  ; Interest (if delinquent)
net_tax_due = #$:(0..)                               ; Net tax due

{@tax_bill}

; ───────────────────────────────────────────────────────────────────────────────
; Payment Information
; ───────────────────────────────────────────────────────────────────────────────
{.payment}
installment_option = ?                               ; Installment payment available
installments = ##:(1..12)                            ; Number of installments
first_installment_due = date                         ; First installment due date
first_installment_amount = #$:(0..)                  ; First installment amount
second_installment_due = date                        ; Second installment due date
second_installment_amount = #$:(0..)                 ; Second installment amount
delinquent_date = date                               ; Delinquency date
discount_date = date                                 ; Early pay discount deadline
discount_percent = #:(0..100)                        ; Discount percentage

{@tax_bill}

; Payment history
{.payment.payments[]}
payment_date = date                                  ; Payment date
payment_amount = #$:(0..)                            ; Payment amount
payment_method = (check, credit_card, eft, escrow, in_person)
receipt_number = :                                   ; Receipt number
period_covered = :                                   ; Period covered

{@tax_bill}

; ───────────────────────────────────────────────────────────────────────────────
; Escrow
; ───────────────────────────────────────────────────────────────────────────────
{.escrow}
escrow_account = ?                                   ; Paid through escrow
servicer_name = ::if escrow_account = true           ; Loan servicer name
servicer_code = ::if escrow_account = true           ; Servicer code
loan_number = ::if escrow_account = true             ; Loan number

{@tax_bill}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (delinquent, in_foreclosure, paid, paid_partial, pending, unpaid)
status_date = date                                   ; Status date
amount_due = #$:(0..)                                ; Current amount due
amount_paid = #$:(0..)                               ; Amount paid to date
balance = #$:(0..)                                   ; Remaining balance

; ═══════════════════════════════════════════════════════════════════════════════
; ASSESSMENT APPEAL
; ═══════════════════════════════════════════════════════════════════════════════
; Property tax assessment appeal

{@assessment_appeal}
; Required fields first
appellant_name = !:                                  ; Appellant name
claimed_value = !#$:(0..)                            ; Claimed/petitioned value
filing_date = !date                                  ; Appeal filing date
property_address = !@address                         ; Property address
tax_year = !##:(1900..2100)                          ; Tax year under appeal

; Appeal identification
appeal_id = :                                        ; Unique appeal identifier
appeal_number = :                                    ; Appeal/petition number
parcel_number = :                                    ; Parcel number

; Assessment reference
assessment_ref = @assessment                         ; Reference to assessment

; ───────────────────────────────────────────────────────────────────────────────
; Values
; ───────────────────────────────────────────────────────────────────────────────
{.values}
assessed_value = #$:(0..)                            ; Current assessed value
claimed_value = #$:(0..)                             ; Value claimed by appellant
difference = #$                                      ; Difference (can be negative)
reduction_requested = #$:(0..)                       ; Reduction amount requested
reduction_percent = #:(0..100)                       ; Reduction percentage

{@assessment_appeal}

; ───────────────────────────────────────────────────────────────────────────────
; Appellant Information
; ───────────────────────────────────────────────────────────────────────────────
{.appellant}
owner = ?                                            ; Appellant is owner
representative = ?                                   ; Using representative
representative_name = ::if representative = true     ; Representative name
representative_firm = ::if representative = true     ; Firm name
representative_phone = @phone:if representative = true
representative_email = @email:if representative = true
contact_address = @address                           ; Contact address
contact_phone = @phone                               ; Contact phone
contact_email = @email                               ; Contact email

{@assessment_appeal}

; ───────────────────────────────────────────────────────────────────────────────
; Appeal Grounds
; ───────────────────────────────────────────────────────────────────────────────
{.grounds}
grounds_code = (classification, exemption, illegal_assessment, overvaluation, unequal_assessment)
grounds_description = :                              ; Description of grounds
comparable_sales = ?                                 ; Using comparable sales
income_approach = ?                                  ; Using income approach
cost_approach = ?                                    ; Using cost approach
property_condition = ?                               ; Condition issues
clerical_error = ?                                   ; Clerical/data error
description = :                                      ; Detailed description

{@assessment_appeal}

; ───────────────────────────────────────────────────────────────────────────────
; Evidence
; ───────────────────────────────────────────────────────────────────────────────
{.evidence}
appraisal_submitted = ?                              ; Appraisal submitted
appraisal_value = #$:(0..):if appraisal_submitted = true
appraisal_date = date:if appraisal_submitted = true
comparable_sales_submitted = ##:(0..)                ; Number of comps
photos_submitted = ?                                 ; Photos submitted
income_data_submitted = ?                            ; Income data submitted
other_evidence = :                                   ; Other evidence description

{@assessment_appeal}

; ───────────────────────────────────────────────────────────────────────────────
; Hearing
; ───────────────────────────────────────────────────────────────────────────────
{.hearing}
hearing_scheduled = ?                                ; Hearing scheduled
hearing_date = date:if hearing_scheduled = true      ; Hearing date
hearing_time = time:if hearing_scheduled = true      ; Hearing time
hearing_location = ::if hearing_scheduled = true     ; Location
hearing_type = (formal, informal, telephone, video)
hearing_board = :                                    ; Hearing board name
attended = ?                                         ; Appellant attended

{@assessment_appeal}

; ───────────────────────────────────────────────────────────────────────────────
; Decision
; ───────────────────────────────────────────────────────────────────────────────
{.decision}
decision_date = date                                 ; Decision date
decision = (denied, granted, granted_partial, withdrawn)
decided_value = #$:(0..)                             ; Value after decision
reduction_amount = #$:(0..)                          ; Reduction granted
reduction_percent = #:(0..100)                       ; Reduction percentage
decision_reason = :                                  ; Decision reasoning
appeal_rights = :                                    ; Further appeal rights

{@assessment_appeal}

; ───────────────────────────────────────────────────────────────────────────────
; Further Appeal
; ───────────────────────────────────────────────────────────────────────────────
{.further_appeal}
further_appeal_filed = ?                             ; Further appeal filed
appeal_level = (circuit_court, state_board, state_court, tax_tribunal)
further_appeal_date = date:if further_appeal_filed = true
further_appeal_number = ::if further_appeal_filed = true

{@assessment_appeal}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (closed, decided, denied, evidence_review, filed, granted, hearing_scheduled, withdrawn)
status_date = date                                   ; Status date
withdrawal_reason = ::if status = withdrawn          ; Withdrawal reason

; ═══════════════════════════════════════════════════════════════════════════════
; TAX LIEN
; ═══════════════════════════════════════════════════════════════════════════════
; Property tax lien information

{@tax_lien}
; Required fields first
lien_amount = !#$:(0..)                              ; Original lien amount
property_address = !@address                         ; Property address
recording_date = !date                               ; Recording date

; Lien identification
lien_id = :                                          ; Unique lien identifier
certificate_number = :                               ; Certificate number
parcel_number = :                                    ; Parcel number

; Tax bill reference
tax_bill_ref = @tax_bill                             ; Reference to tax bill

; ───────────────────────────────────────────────────────────────────────────────
; Lien Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
tax_years[] = ##:(1900..2100)                        ; Tax years covered
original_amount = #$:(0..)                           ; Original lien amount
interest_rate = #:(0..100)                           ; Interest rate
penalty_rate = #:(0..100)                            ; Penalty rate
current_balance = #$:(0..)                           ; Current balance due
recording_info = :                                   ; Recording information

{@tax_lien}

; ───────────────────────────────────────────────────────────────────────────────
; Sale/Assignment
; ───────────────────────────────────────────────────────────────────────────────
{.sale}
sold = ?                                             ; Lien has been sold
sale_date = date:if sold = true                      ; Sale date
sale_price = #$:(0..):if sold = true                 ; Sale price
purchaser = ::if sold = true                         ; Purchaser name
assigned = ?                                         ; Lien assigned
assignee = ::if assigned = true                      ; Assignee name

{@tax_lien}

; ───────────────────────────────────────────────────────────────────────────────
; Redemption
; ───────────────────────────────────────────────────────────────────────────────
{.redemption}
redemption_period_ends = date                        ; Redemption deadline
redemption_amount = #$:(0..)                         ; Current redemption amount
redeemed = ?                                         ; Lien redeemed
redemption_date = date:if redeemed = true            ; Redemption date
redemption_by = ::if redeemed = true                 ; Redeemed by

{@tax_lien}

; ───────────────────────────────────────────────────────────────────────────────
; Foreclosure
; ───────────────────────────────────────────────────────────────────────────────
{.foreclosure}
foreclosure_eligible = ?                             ; Eligible for foreclosure
foreclosure_filed = ?                                ; Foreclosure filed
foreclosure_date = date:if foreclosure_filed = true  ; Filing date
case_number = ::if foreclosure_filed = true          ; Court case number
foreclosure_completed = ?                            ; Foreclosure completed
deed_date = date:if foreclosure_completed = true     ; Deed date

{@tax_lien}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, assigned, cancelled, foreclosed, redeemed, sold)
status_date = date                                   ; Status date


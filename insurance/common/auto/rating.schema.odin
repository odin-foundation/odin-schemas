; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Auto Insurance Rating Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Auto insurance rating and premium definitions including base rates, factors,
; discounts, surcharges, fees, and payment plans.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.auto.rating"
version = "1.0.0"
title = "Auto Insurance Rating Schema"
description = "Rating and premium definitions for personal auto insurance"

{$derivation}
source[0].authority = "TurboTags (The Unlicense)"
source[0].citation = "Policy-Tags, Miscellaneous-Premium-Level-Tags, Rate-Engine-Tags"
source[0].url = "https://github.com/getitc/turbotags"

source[1].authority = "California Department of Insurance"
source[1].citation = "CA CCR Title 10, § 2632.5 (Rating Factors), § 2632.8 (Factor Weights)"
source[1].url = "https://www.law.cornell.edu/regulations/california/10-CCR-2632.5"

source[2].authority = "Texas Department of Insurance"
source[2].citation = "TX Admin Code Title 28, Chapter 5 - Statistical Plan"
source[2].url = "https://texreg.sos.state.tx.us/public/readtac$ext.ViewTAC?tac_view=4&ti=28&pt=1&ch=5"

source[3].authority = "New York Department of Financial Services"
source[3].citation = "NY Insurance Law § 2303/2304 - Rate Standards"
source[3].url = "https://www.nysenate.gov/legislation/laws/ISC/2303"

source[4].authority = "Florida Office of Insurance Regulation"
source[4].citation = "FL Statutes § 627.0651 - Motor Vehicle Insurance Rates"
source[4].url = "https://www.leg.state.fl.us/statutes/index.cfm?App_mode=Display_Statute&URL=0600-0699/0627/Sections/0627.0651.html"

source[5].authority = "NAIC"
source[5].citation = "Model 751 - Regulation to Require Reporting of Statistical Data"
source[5].url = "https://content.naic.org/sites/default/files/model-law-751.pdf"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Rating structures per state rate filing requirements and NAIC statistical reporting standards"

changelog[0].date = 2025-12-13
changelog[0].change = "Initial rating schema"
changelog[0].rationale = "Standard auto insurance rating and premium structures with regulatory compliance"

; ═══════════════════════════════════════════════════════════════════════════════
; Rating Information
; ═══════════════════════════════════════════════════════════════════════════════

{@rating}
id = :                                         ; Unique rating identifier

; Rating timestamp
rated_date = !timestamp                        ; Date and time when rating was performed
rated_by = :                                   ; User or system that performed the rating

; Company/Program
carrier_ref = :                               ; Insurance carrier reference

{@rating}
{.program}
id = :                                         ; Program identifier
name = :                                       ; Program name

{@rating}

; Rate basis
rate_effective_date = !date                    ; Date when rates became effective
rate_revision = ##                             ; Rate revision number
rate_state = !:(2)                             ; Two-letter state code for rate filing
rate_filing_number = :                         ; State filing reference number
rate_type = (file_and_use, prior_approval, use_and_file)  ; Regulatory filing type
actuarial_certification = ?                    ; Whether rates are actuarially certified
actuarial_certification_date = date            ; Date of actuarial certification

; Tier
{.tier}
code = :                                       ; Tier code
name = :                                       ; Tier name
description = :                                ; Tier description

{@rating}

; Term
{.term}
months = ##:(1..24)                            ; Policy term length in months
type = (annual, monthly, other, quarterly, semi_annual)  ; Term payment type
effective_date = !date                         ; Policy effective date
expiration_date = !date                        ; Policy expiration date
:invariant expiration_date > effective_date    ; Expiration must be after effective date

{@rating}

; ═══════════════════════════════════════════════════════════════════════════════
; Credit Score Information
; ═══════════════════════════════════════════════════════════════════════════════

{@rating.credit}
ordered = ?                                    ; Whether credit report was ordered
order_date = date                              ; Date credit report was ordered
received_date = date                           ; Date credit report was received

; Score data
score = ##                                        ; Actual numeric credit score
score_text = :                                    ; Score as text
score_band = :                                    ; Tier or band
score_date = date                                 ; Date score was calculated
reference_number = :                        ; Transaction or reference number
vendor = :                                 ; Credit bureau vendor
model = :                                   ; Credit model used
tier = :                                    ; Company-assigned tier from score

; Reason codes
reason_codes[] = :                                ; Adverse action reason codes
reason_descriptions[] = :                         ; Human-readable reason text per code

; Status and errors
status = (error, frozen, no_hit, not_found, pending, success)  ; Credit report status
error_message = :                              ; Error message if status is error
no_hit_reason = :                              ; Reason if no credit record found

; Raw response (for audit trail)
raw_response = :                                  ; Full vendor response

; Secondary company (for IL bridged policies)
{.secondary}
score = ##                                     ; Secondary company credit score
score_band = :                                 ; Secondary company score band
reference_number = :                           ; Secondary company reference number
vendor = :                                     ; Secondary company credit vendor

{@rating.credit}

; ═══════════════════════════════════════════════════════════════════════════════
; Premium Breakdown
; ═══════════════════════════════════════════════════════════════════════════════

{@premium}
; ───────────────────────────────────────────────────────────────────────────────
; Base Premiums by Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.base}
liability_bi = #$:(0..)                        ; Bodily injury liability base premium
liability_pd = #$:(0..)                        ; Property damage liability base premium
um = #$:(0..)                                  ; Uninsured motorist base premium
uim = #$:(0..)                                 ; Underinsured motorist base premium
pip = #$:(0..)                                 ; Personal injury protection base premium
med_pay = #$:(0..)                             ; Medical payments base premium
comp = #$:(0..)                                ; Comprehensive coverage base premium
coll = #$:(0..)                                ; Collision coverage base premium
other = #$:(0..)                               ; Other coverage base premium
total = #$:(0..)                               ; Total base premium before discounts/surcharges

{@premium}

; ───────────────────────────────────────────────────────────────────────────────
; Discounts Applied
; ───────────────────────────────────────────────────────────────────────────────
{.discounts}
multi_policy = #$:(0..)                        ; Multiple policy discount amount
multi_car = #$:(0..)                           ; Multiple vehicle discount amount
good_driver = #$:(0..)                         ; Good driver discount amount
good_student = #$:(0..)                        ; Good student discount amount
defensive_driving = #$:(0..)                   ; Defensive driving course discount amount
senior_driver = #$:(0..)                       ; Senior driver discount amount
homeowner = #$:(0..)                           ; Homeowner discount amount
anti_theft = #$:(0..)                          ; Anti-theft device discount amount
safety_equipment = #$:(0..)                    ; Safety equipment discount amount
airbag = #$:(0..)                              ; Airbag discount amount
antilock_brakes = #$:(0..)                     ; Anti-lock brakes discount amount
daytime_running_lights = #$:(0..)              ; Daytime running lights discount amount
low_mileage = #$:(0..)                         ; Low mileage discount amount
paid_in_full = #$:(0..)                        ; Paid in full discount amount
paperless = #$:(0..)                           ; Paperless billing discount amount
autopay = #$:(0..)                             ; Automatic payment discount amount
loyalty = #$:(0..)                             ; Customer loyalty discount amount
advance_quote = #$:(0..)                       ; Advance quote discount amount
military = #$:(0..)                            ; Military service discount amount
affinity = #$:(0..)                            ; Affinity group discount amount
telematics = #$:(0..)                          ; Telematics/usage-based discount amount
other = #$:(0..)                               ; Other miscellaneous discount amount
total = #$:(0..)                               ; Total discount amount

{@premium}

; ───────────────────────────────────────────────────────────────────────────────
; Surcharges Applied
; ───────────────────────────────────────────────────────────────────────────────
{.surcharges}
violation = #$:(0..)                           ; Traffic violation surcharge amount
accident = #$:(0..)                            ; At-fault accident surcharge amount
claim = #$:(0..)                               ; Claims history surcharge amount
sr22 = #$:(0..)                                ; SR-22 filing surcharge amount
new_driver = #$:(0..)                          ; New driver surcharge amount
young_driver = #$:(0..)                        ; Young driver surcharge amount
lapse_in_coverage = #$:(0..)                   ; Lapse in prior coverage surcharge amount
inexperienced = #$:(0..)                       ; Inexperienced driver surcharge amount
excluded_driver = #$:(0..)                     ; Excluded driver surcharge amount
high_risk_vehicle = #$:(0..)                   ; High risk vehicle surcharge amount
business_use = #$:(0..)                        ; Business use surcharge amount
rideshare = #$:(0..)                           ; Rideshare use surcharge amount
other = #$:(0..)                               ; Other miscellaneous surcharge amount
total = #$:(0..)                               ; Total surcharge amount

{@premium}

; ───────────────────────────────────────────────────────────────────────────────
; Premium Calculation
; ───────────────────────────────────────────────────────────────────────────────
{.subtotal}
before_discounts = #$:(0..)                    ; Premium before applying any discounts
after_discounts = #$:(0..)                     ; Premium after discounts, before surcharges
after_surcharges = #$:(0..)                    ; Premium after both discounts and surcharges

{@premium}

; ───────────────────────────────────────────────────────────────────────────────
; Fees
; ───────────────────────────────────────────────────────────────────────────────
{.fees}
policy_fee = #$:(0..)                          ; Standard policy fee
installment_fee = #$:(0..)                     ; Fee for payment plan installments
sr22_fee = #$:(0..)                            ; SR-22 or FR-44 filing fee
late_fee = #$:(0..)                            ; Late payment fee
reinstatement_fee = #$:(0..)                   ; Policy reinstatement fee
nsf_fee = #$:(0..)                             ; Non-sufficient funds fee
mvr_fee = #$:(0..)                             ; Motor vehicle report fee
collection_fee = #$:(0..)                      ; Collections processing fee
stamp_fee = #$:(0..)                           ; State stamp or surplus lines fee
fraud_fee = #$:(0..)                           ; Fraud prevention assessment fee
regulatory_fee = #$:(0..)                      ; Regulatory or compliance fee
other = #$:(0..)                               ; Other miscellaneous fees
total = #$:(0..)                               ; Total fees

{@premium}

; ───────────────────────────────────────────────────────────────────────────────
; Taxes
; ───────────────────────────────────────────────────────────────────────────────
{.taxes}
state_tax = #$:(0..)                           ; State tax amount
state_tax_rate = #:(0..25)                     ; State tax rate percentage
municipal_tax = #$:(0..)                       ; Municipal or local tax amount
municipal_tax_rate = #:(0..15)                 ; Municipal tax rate percentage
other_tax = #$:(0..)                           ; Other tax amount
taxable_premium = #$:(0..)                     ; Base premium subject to taxation
total = #$:(0..)                               ; Total tax amount

{@premium}

; ───────────────────────────────────────────────────────────────────────────────
; Totals
; ───────────────────────────────────────────────────────────────────────────────
{.total}
premium = !#$:(0..)                            ; Total premium amount
fees = #$:(0..)                                ; Total fees amount
taxes = #$:(0..)                               ; Total taxes amount
policy_total = !#$:(0..)                       ; Grand total (premium + fees + taxes)

{@premium}

; Term breakdown
per_month = #$:(0..)                           ; Monthly premium amount
per_day = #$:(0..)                             ; Daily premium amount

; ═══════════════════════════════════════════════════════════════════════════════
; Discount Detail
; ═══════════════════════════════════════════════════════════════════════════════

{@discount}
id = :                                         ; Unique discount identifier
code = !(                                      ; Standardized discount code
    dc-ADVANCE,
    dc-AFFINITY,
    dc-AIRBAG,
    dc-ANTILOCK,
    dc-ANTITHEFT,
    dc-AUTOPAY,
    dc-COLLEGE,
    dc-CREDITCARD,
    dc-DEFDRV,
    dc-DISTSTUD,
    dc-DRL,
    dc-EMPLOYER,
    dc-GOODDRV,
    dc-GOODSTUD,
    dc-HOMEOWNR,
    dc-HYBRID,
    dc-LOWMILE,
    dc-LOYALTY,
    dc-MATUREDRV,
    dc-MILITARY,
    dc-MULTICAR,
    dc-MULTLINE,
    dc-MULTIPOL,
    dc-NEWCAR,
    dc-NONSMOKER,
    dc-OTHER,
    dc-PAIDFULL,
    dc-PAPERLESS,
    dc-PASSREST,
    dc-SAFETY,
    dc-SAFEDRVR,
    dc-SENIORDRV,
    dc-TELEMATICS
)
name = :                                       ; Discount name
type = (factor, flat, percent)                 ; Discount calculation type
value = #:(0..100)                             ; Discount value (percentage or factor)
amount = #$:(0..)                              ; Calculated discount amount
applies_to = (coverage, driver, policy, vehicle)  ; What the discount applies to
vehicle_number = ##:if applies_to = vehicle    ; Vehicle number if applicable
driver_number = ##:if applies_to = driver      ; Driver number if applicable
coverage_code = :if applies_to = coverage      ; Coverage code if applicable

; ═══════════════════════════════════════════════════════════════════════════════
; Surcharge Detail
; ═══════════════════════════════════════════════════════════════════════════════

{@surcharge}
id = :                                         ; Unique surcharge identifier
code = !(                                      ; Standardized surcharge code
    sc-ACCFAULT,
    sc-ACCMULTI,
    sc-ACCNOFLT,
    sc-BUSINESS,
    sc-CLAIM,
    sc-DELIVERY,
    sc-DUI,
    sc-EXCLUDED,
    sc-FR44,
    sc-HIGHPERF,
    sc-HIGHRISK,
    sc-INEXP,
    sc-LAPSE,
    sc-MAJVIOL,
    sc-MINVIOL,
    sc-NEWDRV,
    sc-NOPRIOR,
    sc-OTHER,
    sc-RECKLESS,
    sc-RIDESHARE,
    sc-SHORTPRIOR,
    sc-SPEED,
    sc-SR22,
    sc-SUSPEND,
    sc-VIOL,
    sc-YOUNGDRV
)
name = :                                       ; Surcharge name
type = (factor, flat, percent)                 ; Surcharge calculation type
value = #:(0..500)                             ; Surcharge value (percentage or factor)
amount = #$:(0..)                              ; Calculated surcharge amount
applies_to = (coverage, driver, policy, vehicle)  ; What the surcharge applies to
vehicle_number = ##:if applies_to = vehicle    ; Vehicle number if applicable
driver_number = ##:if applies_to = driver      ; Driver number if applicable
reason = :                                     ; Reason for surcharge

; ═══════════════════════════════════════════════════════════════════════════════
; Miscellaneous Premium Items
; ═══════════════════════════════════════════════════════════════════════════════

{@misc_premium}
id = :                                         ; Unique miscellaneous premium identifier
description = !:                               ; Description of premium item
amount = #$                                    ; Can be positive or negative (no constraint)
premium_type = (charge, credit)                ; Whether this is a charge or credit
applies_to = (driver, policy, vehicle)         ; What the premium applies to
vehicle_number = ##:if applies_to = vehicle    ; Vehicle number if applicable
driver_number = ##:if applies_to = driver      ; Driver number if applicable
apply_to_down_payment = ?                      ; Whether to apply to down payment
percent_of_total = ?                           ; Whether amount is a percentage of total
percent_amount = #:(0..100):if percent_of_total = true  ; Percentage amount if applicable

; ═══════════════════════════════════════════════════════════════════════════════
; Payment Plan
; ═══════════════════════════════════════════════════════════════════════════════

{@payment_plan}
id = :                                         ; Unique payment plan identifier
name = :                                       ; Payment plan name
type = !(                                      ; Payment plan type
    custom,
    monthly_credit_card,
    monthly_eft,
    monthly_low_down,
    monthly_standard,
    paid_in_full,
    quarterly,
    two_pay
)
description = :                                ; Payment plan description

; Down payment
{.down_payment}
amount = #$:(0..)                              ; Calculated down payment amount
percent = #:(0..100)                           ; Down payment as percentage of total
override = #$:(0..)                            ; Manual override amount if applicable
minimum = #$:(0..)                             ; Minimum required down payment

{@payment_plan}

; Payments
payment_count = ##:(1..24)                     ; Total number of payments
payment_amount = #$:(0..)                      ; Amount per payment
payment_frequency = (annual, bi_weekly, monthly, quarterly, semi_annual, weekly)  ; Payment frequency
first_payment_due = date                       ; First payment due date
last_payment_due = date                        ; Last payment due date

; Individual payment schedule
{@payment_plan.payments[]}
:(1..24)                                       ; Maximum 24 payments
payment_number = ##:(1..24)                    ; Sequential payment number
due_date = !date                               ; Payment due date
amount = !#$:(0..)                             ; Payment amount
status = (late, nsf, paid, pending, scheduled, waived)  ; Payment status
paid_date = date                               ; Actual date payment was made
paid_amount = #$:(0..)                         ; Actual amount paid
confirmation = :                               ; Payment confirmation number

{@payment_plan.payments[]}

; Finance charges
finance_amount = #$:(0..)                      ; Total amount being financed
finance_charge = #$:(0..)                      ; Total finance charges
apr = #:(0..36)                                ; Annual percentage rate
installment_fee = #$:(0..)                     ; Fee per installment
total_of_payments = #$:(0..)                   ; Total of all payments including finance charges

; Finance company (if external)
{.finance_company}
name = :                                       ; Finance company name
address = @address                             ; Finance company address
phone = *@phone                                ; Finance company phone (confidential)

{@payment_plan}

; Flags
qualified_for_financing = ?                    ; Whether customer qualifies for financing
independently_financed = ?                     ; Whether financed through external company
allow_plan_change = ?                          ; Whether plan changes are allowed

; ═══════════════════════════════════════════════════════════════════════════════
; Commission
; ═══════════════════════════════════════════════════════════════════════════════

{@commission}
id = :                                         ; Unique commission identifier
type = (endorsement, new_business, renewal)    ; Transaction type
percent = #:(0..100)                           ; Total commission percentage
amount = #$:(0..)                              ; Total commission amount
commissionable_premium = #$:(0..)              ; Premium amount eligible for commission

; Splits
producer_code = :                              ; Agent or producer code
producer_percent = #:(0..100)                  ; Producer's commission percentage
producer_amount = #$:(0..)                     ; Producer's commission amount
agency_percent = #:(0..100)                    ; Agency's commission percentage
agency_amount = #$:(0..)                       ; Agency's commission amount

; ═══════════════════════════════════════════════════════════════════════════════
; Quote Comparison
; ═══════════════════════════════════════════════════════════════════════════════

{@quote_comparison[]}
id = :                                         ; Unique quote comparison identifier
carrier_ref = :                                ; Reference to carrier.schema.odin
program_name = :                               ; Insurance program name
tier = :                                       ; Rating tier

; Premium
total_premium = !#$:(0..)                      ; Total premium for quote
term_months = ##:(1..24)                       ; Term length in months
monthly_premium = #$:(0..)                     ; Monthly premium amount

; Coverage summary
liability_limits = :                           ; Liability coverage limits
um_uim_limits = :                              ; Uninsured/underinsured motorist limits
comp_ded = ##                                  ; Comprehensive deductible
coll_ded = ##                                  ; Collision deductible

; Status
date = date                                    ; Quote date
expiration_date = date                         ; Quote expiration date
selected = ?                                   ; Whether this quote was selected
reason_not_selected = :                        ; Reason if not selected

; ═══════════════════════════════════════════════════════════════════════════════
; STATE-SPECIFIC: California Department of Insurance
; ═══════════════════════════════════════════════════════════════════════════════
; Per CA CCR Title 10, Chapter 5, Subchapter 4.7, § 2632.8
; https://www.law.cornell.edu/regulations/california/10-CCR-2632.8

{@&gov.ca.doi.rating}
; CA CCR § 2632.8 - Factor Weight Ordering Requirement
; Factors must be weighted in order: driving safety > annual miles > years licensed
factor_weight_driving_safety = #:(0..100)     ; Must be highest weight
factor_weight_annual_miles = #:(0..100)       ; Second highest
factor_weight_years_licensed = #:(0..100)     ; Third highest
factor_weights_compliant = ?                  ; Weights in correct order

; CA Insurance Code § 1861.02 - Good Driver Discount Mandate
good_driver_discount_percent = ##:(20..100)   ; Must be at least 20%

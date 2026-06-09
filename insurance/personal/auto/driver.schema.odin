; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Personal Auto Driver Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Personal auto driver extending the base driver schema with personal-specific
; fields for good student/driver discounts, PIP elections, telematics enrollment,
; and household driver management.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/auto/driver.schema.odin" as drv

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.auto.driver"
version = "1.0.0"
title = "Personal Auto Driver Schema"
description = "Personal driver extending core with personal-specific fields"

{$derivation}
source[0].authority = "California Department of Insurance"
source[0].citation = "CA Insurance Code § 1861.02 - Good Driver Discount"
source[0].url = "https://www.insurance.ca.gov/0250-insurers/0800-rate-filings/"

source[1].authority = "Texas Department of Insurance"
source[1].citation = "TX Admin Code Title 28, Chapter 5 - Credit Scoring"
source[1].url = "https://texas-sos.appianportalsgov.com/rules-and-meetings?interface=TAC_TITLE_VIEW&parameters=ti%3D28%26pt%3D1"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Personal auto driver data elements including discounts, credit scoring, and SR-22"

changelog[0].date = 2025-12-13
changelog[0].change = "Initial personal driver schema - refactored from monolithic schema"
changelog[0].rationale = "Clean separation of personal-specific driver fields"

; ═══════════════════════════════════════════════════════════════════════════════
; Personal Driver (Extends Core)
; ═══════════════════════════════════════════════════════════════════════════════

{@personal_driver}
= @drv.driver                                  ; Inherit all base driver fields

; ───────────────────────────────────────────────────────────────────────────────
; Good Driver Tracking
; ───────────────────────────────────────────────────────────────────────────────
eligible_good_driver = ?                       ; Meets good driver criteria
at_fault_3yr_count = ##                        ; At-fault accidents in 3-year period
points_3yr_count = ##                          ; Points in 3-year look-back period
principally_at_fault_count = ##                ; Total principally at-fault accidents

; ───────────────────────────────────────────────────────────────────────────────
; Personal Discount Eligibility
; ───────────────────────────────────────────────────────────────────────────────
autopay = ?                                    ; Automatic payment enrolled
distant_student = ?                            ; Away at school without car
good_student = ?                               ; Full-time student, B average
good_student_gpa = #:(0..4)                    ; GPA if good student
homeowner = ?                                  ; Owns home
mature_driver = ?                              ; Senior driver discount eligible
multi_car = ?                                  ; Multiple cars on policy
multi_policy = ?                               ; Has other policies with carrier
non_smoker = ?                                 ; Non-smoker status
paperless = ?                                  ; Paperless billing/documents

{.training}
senior_driver_course = ?                       ; Completed senior driver course
senior_driver_course_date = date               ; Date senior course completed
senior_driver_expiration = date                ; Senior course expiration date

{@personal_driver}

; ───────────────────────────────────────────────────────────────────────────────
; Financial Indicators
; ───────────────────────────────────────────────────────────────────────────────
credit_card = ?                                ; Has credit card
home_owner = ?                                 ; Owns home
months_no_collections = ##                     ; Months without collections
months_no_past_due = ##                        ; Months without past due

; ───────────────────────────────────────────────────────────────────────────────
; Credit Score
; ───────────────────────────────────────────────────────────────────────────────
{.credit}
score = ##:(0..999)                            ; Actual credit score (numeric)
score_date = date                              ; Date score was pulled
status = (error, frozen, no_hit, not_found, success)
error_message = :                              ; Error message if status is error
model = :                                      ; Credit model (FICO Auto Score 9, etc.)
no_hit_reason = :                              ; Reason for no hit
raw_response = :                               ; Full vendor response (audit trail)
reason_codes[] = :                             ; Adverse action reason codes
reason_description = :                         ; Human-readable reason text
reference_number = :                           ; Transaction reference
tier = :                                       ; Company-assigned tier from score
vendor = :                                     ; TransUnion, Experian, LexisNexis, etc.

{@personal_driver}

; ───────────────────────────────────────────────────────────────────────────────
; Additional Rating Indicators
; ───────────────────────────────────────────────────────────────────────────────
continuous_insurance = (continuous, lapse_30_to_60, lapse_over_60, lapse_under_30, no_prior, unknown)
military_rank_e5_or_higher = ?                ; Higher military rank discount
public_transit = ?                             ; Uses public transportation regularly

; ───────────────────────────────────────────────────────────────────────────────
; SR-22 / Financial Responsibility Filing
; ───────────────────────────────────────────────────────────────────────────────
{.sr22}
required = ?                                   ; SR-22 required flag
case_number = :if sr22.required = true         ; Case number for filing
effective = date:if sr22.required = true       ; Filing effective date
expiration = date:if sr22.required = true      ; Filing expiration date
reason = (at_fault_accident, court_ordered, dui_dwi, license_suspension, multiple_violations, no_insurance, other, reckless_driving):if sr22.required = true
state_province = :(2):if sr22.required = true  ; US state or Canadian province

{@personal_driver}

{.sr22a}
required = ?                                   ; Owner's certificate (for financed vehicles)

{@personal_driver}

{.fr44}
required = ?                                   ; Florida/Virginia financial responsibility

{@personal_driver}

; ───────────────────────────────────────────────────────────────────────────────
; Detailed Financial Responsibility Filing
; ───────────────────────────────────────────────────────────────────────────────
{.fr_filing}
case_number = :                                ; Case number
duration_months = ##                           ; Filing duration in months
effective = date                               ; Filing effective date
expiration = date                              ; Filing expiration date
fee = #$                                       ; Filing fee amount
incident_date = date                           ; Incident date that triggered filing
reason = :                                     ; Reason for filing
required_amount = ##                           ; Required coverage amount
required_by = (court, dmv, other, state)       ; Entity requiring filing
state_province = :(2)                          ; US state or Canadian province
status = (active, cancelled, expired, pending, transferred)
type = (fr44, other, sr22, sr22a, sr26)        ; Filing type

{@personal_driver}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Elections
; ───────────────────────────────────────────────────────────────────────────────
um_excluded = ?                                ; Excluded from UM coverage
umpd_excluded = ?                              ; Excluded from UMPD coverage

{.pip}
broadened = ?                                  ; Elected broadened PIP coverage
work_loss_declined = ?                         ; Declined work loss benefit

{@personal_driver}

; ───────────────────────────────────────────────────────────────────────────────
; Personal Rating Classification
; ───────────────────────────────────────────────────────────────────────────────
{.rating}
discount_code = ##                             ; Discount code
group_code = ##                                ; Rating group code
surcharge_code = ##                            ; Surcharge code

{@personal_driver}

; ───────────────────────────────────────────────────────────────────────────────
; Training
; ───────────────────────────────────────────────────────────────────────────────
{.training}
drug_awareness = ?                             ; Completed drug awareness course
drug_awareness_court_ordered = ?               ; Court ordered drug awareness
drug_awareness_date = date                     ; Date drug awareness completed
motorcycle_safety = ?                          ; Completed motorcycle safety course
motorcycle_safety_date = date                  ; Date motorcycle safety completed

{@personal_driver}

; ───────────────────────────────────────────────────────────────────────────────
; PIP Claims History
; ───────────────────────────────────────────────────────────────────────────────

{@personal_driver.pip_claims[]}
date = date                                   ; Claim date
amount = #$                                    ; Claim amount
id = :                                         ; Claim identifier
months_ago = ##                                ; Months since claim
status = (closed, denied, open, paid)          ; Claim status

; ═══════════════════════════════════════════════════════════════════════════════
; STATE-SPECIFIC: California Department of Insurance
; ═══════════════════════════════════════════════════════════════════════════════
; Per CA Code of Regulations Title 10, Chapter 5, Subchapter 4.7

{@&gov.ca.doi.driver_rating}
; CA Vehicle Code DUI violations (highest surchargeable per § 2632.5)
vc_23140 = ?                                   ; Minor with BAC ≥0.05
vc_23152 = ?                                   ; DUI
vc_23153 = ?                                   ; DUI causing injury

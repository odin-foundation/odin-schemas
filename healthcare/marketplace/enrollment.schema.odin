; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Health Insurance Marketplace Enrollment Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Marketplace plan enrollment and effectuation including plan selection,
; premium payments, and enrollment status tracking. Derived from 45 CFR
; Part 155 Subpart E and Part 156.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as marketplace

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.marketplace.enrollment"
version = "1.0.0"
title = "Health Insurance Marketplace Enrollment Schema"
description = "Marketplace plan enrollment and effectuation"

{$derivation}
source[0].authority = "GPO"
source[0].citation = "45 CFR 155.400 - Enrollment in QHP"
source[0].url = "https://www.ecfr.gov/current/title-45/subtitle-A/subchapter-B/part-155/subpart-E"

source[1].authority = "GPO"
source[1].citation = "45 CFR 156.265 - Enrollment process"
source[1].url = "https://www.ecfr.gov/current/title-45/subtitle-A/subchapter-B/part-156/subpart-C/section-156.265"

source[2].authority = "CMS"
source[2].citation = "834 Enrollment Transaction Technical Guidance"
source[2].url = "https://www.cms.gov/CCIIO/Resources/Regulations-and-Guidance"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial Marketplace enrollment schema"
changelog[0].rationale = "Structure derived from 45 CFR 155.400 and 156.265"

; ═══════════════════════════════════════════════════════════════════════════════
; ENROLLMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.400

{@enrollment}
enrollment_id = !:                          ; Enrollment ID (Exchange assigned ID)
subscriber_id = !:                          ; Subscriber ID
application_id = !:                         ; Associated application
exchange_id = !:                            ; Exchange identifier

; Plan
{.plan}
plan_id = !:                                ; HIOS plan ID
plan_name = :                               ; Plan name
issuer_id = !:                              ; Issuer ID
metal_level = !(bronze, catastrophic, gold, platinum, silver)
plan_type = (epo, hmo, pos, ppo)            ; Network type
csr_variant = :                             ; CSR variant if applicable

{@enrollment}

; Enrollment type
enrollment_type = !(change, initial, reinstatement, renewal, sep, termination)
enrollment_reason = :                       ; Detailed reason

; Enrollment period - Per 45 CFR 155.410
{.period}
period_type = !(initial, oep, sep)          ; Period type
sep_type = :                                ; SEP type if applicable
sep_verification_required = ?               ; SEP verification needed

{@enrollment}

; Coverage period
period = @enrollment_period                 ; Enrollment period with status tracking
policy_end_date = date                      ; Policy year end

{@enrollment}

; Status details
substatus = :                               ; Detailed substatus

{@enrollment}

; Members
subscriber = !@enrollment_member            ; Subscriber
dependents[] = @enrollment_member           ; Enrolled dependents

; Premium - Per 45 CFR 156.425
premium = @enrollment_premium               ; Premium information

; ═══════════════════════════════════════════════════════════════════════════════
; ENROLLMENT MEMBER
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.400

{@enrollment_member}
member_id = !:                              ; Member ID
applicant = !@marketplace.applicant         ; Applicant info
relationship = !(child, dependent, domestic_partner, self, spouse)

; Coverage status
coverage_period = @enrollment_period        ; Member coverage period

{@enrollment_member}

; APTC allocation - Per 45 CFR 155.305(f)
{.aptc}
aptc_eligible = ?                           ; APTC eligible
aptc_applied = #$:(0..)                     ; APTC applied to this member
percent_of_household_aptc = #:(0..100)      ; Percent of household APTC

{@enrollment_member}

; ═══════════════════════════════════════════════════════════════════════════════
; ENROLLMENT PREMIUM
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 156.425

{@enrollment_premium}
enrollment_id = !:                          ; Enrollment ID
effective_date = !date                      ; Premium effective date

; Premium amounts
{.amounts}
total_premium = #$:(0..)                    ; Total monthly premium
aptc_amount = #$:(0..)                      ; APTC applied
csr_value = #$:(0..)                        ; CSR value (actuarial)
responsible_amount = #$:(0..)               ; Enrollee responsible amount

{@enrollment_premium}

; Premium by member
member_premiums[] = @member_premium         ; Per-member premiums

; Binder payment
binder_payment = @payment                   ; Binder payment tracking
binder_payment.due_date = date              ; First payment due date

{@enrollment_premium}

{@member_premium}
member_id = !:                              ; Member ID
age = ##:(0..64)                            ; Age for rating
tobacco_user = ?                            ; Tobacco user
premium = #$:(0..)                          ; Individual premium
rating_area = :                             ; Rating area

; ═══════════════════════════════════════════════════════════════════════════════
; PLAN SELECTION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.410

{@plan_selection}
selection_id = !:                           ; Selection ID
application_id = !:                         ; Application
selection_date = !date                      ; Selection date

; Selected plan
{.plan}
plan_id = !:                                ; Selected plan HIOS ID
plan_name = :                               ; Plan name
issuer_id = !:                              ; Issuer
metal_level = !(bronze, catastrophic, gold, platinum, silver)

{@plan_selection}

; APTC election - Per 45 CFR 155.310(d)
{.aptc_election}
max_aptc = #$:(0..)                         ; Maximum APTC available
aptc_elected = #$:(0..)                     ; APTC amount elected
full_aptc = ?                               ; Elected full APTC

{@plan_selection}

; Premium summary
{.premium}
gross_premium = #$:(0..)                    ; Total premium
after_aptc = #$:(0..)                       ; Premium after APTC
monthly_payment = #$:(0..)                  ; Monthly payment amount

{@plan_selection}

; Covered members
covered_members[] = :                       ; Members to be covered

; Status
selection_status = !(cancelled, confirmed, pending)

; ═══════════════════════════════════════════════════════════════════════════════
; ENROLLMENT TRANSACTION (834)
; ═══════════════════════════════════════════════════════════════════════════════
; Per CMS 834 Technical Guidance

{@enrollment_transaction}
transaction_id = !:                         ; Transaction ID
enrollment_id = !:                          ; Enrollment ID
transaction_date = !date                    ; Transaction date

; Transaction type - Per ASC X12 834
maintenance_type = !(addition, audit, cancellation, change, reinstatement, termination)
maintenance_reason = :                      ; Reason code

; Direction
{.direction}
source = !(exchange, issuer)                ; Transaction source
destination = :(exchange, issuer)           ; Destination

{@enrollment_transaction}

; Transaction status
status = @status_record                     ; Status tracking with reason
status.status = !(accepted, acknowledged, pending, rejected)

{@enrollment_transaction}

; Policy data
{.policy}
policy_number = :                           ; Issuer policy number
group_number = :                            ; Group number
subscriber_id = :                           ; Subscriber ID

{@enrollment_transaction}

; ═══════════════════════════════════════════════════════════════════════════════
; EFFECTUATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 156.265

{@effectuation}
enrollment_id = !:                          ; Enrollment ID
effectuation_date = !date                   ; Effectuation date

; Payment status - Per 45 CFR 156.270
payment = @payment                          ; Premium payment tracking

{@effectuation}

; Issuer confirmation
{.issuer}
issuer_confirmed = ?                        ; Issuer confirmed enrollment
confirmation_date = date                    ; Confirmation date
issuer_member_id = :                        ; Issuer-assigned member ID
policy_number = :                           ; Policy number assigned

{@effectuation}

; ID cards
{.id_cards}
cards_issued = ?                            ; ID cards issued
card_issue_date = date                      ; Cards issued date

{@effectuation}

; ═══════════════════════════════════════════════════════════════════════════════
; TERMINATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.430

{@termination}
enrollment_id = !:                          ; Enrollment ID
termination_date = !date                    ; Termination effective date
termination_request_date = date             ; Date termination requested

; Termination type - Per 45 CFR 155.430(b)
termination_type = !(exchange_initiated, issuer_initiated, subscriber_initiated)

; Reason - Per 45 CFR 155.430
termination_reason = !(death, eligibility_loss, fraud, incarceration, move_out_of_area, new_coverage, non_payment, request, rescission, verification_failure)
reason_description = :                      ; Detailed description

; Notice - Per 45 CFR 155.430(d)
{.notice}
advance_notice_sent = ?                     ; Advance notice sent
notice_date = date                          ; Notice date
effective_after_notice = ?                  ; Effective after notice period

{@termination}

; Grace period - Per 45 CFR 156.270(d)
{.grace_period}
in_grace_period = ?                         ; Currently in grace period
grace_period_start = date                   ; Grace start
grace_period_end = date                     ; Grace end (3 months if APTC)
months_unpaid = ##:(0..3)                   ; Months premium unpaid

{@termination}

; COBRA/continuation
{.continuation}
cobra_offered = ?                           ; COBRA offered
continuation_elected = ?                    ; Continuation elected

{@termination}

; ═══════════════════════════════════════════════════════════════════════════════
; REINSTATEMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 156.270(f)

{@reinstatement}
original_enrollment_id = !:                 ; Original enrollment
reinstatement_date = !date                  ; Reinstatement effective date
request_date = date                         ; Reinstatement request date

; Reason
{.reason}
reinstatement_reason = !(appeal_decision, grace_period_payment, retroactive_medicaid, technical_error)
documentation = :                           ; Supporting documentation

{@reinstatement}

; Back premium payment
back_payment = @payment                     ; Back premium payment tracking
back_premium_required = ?                   ; Back premiums required

{@reinstatement}

; Coverage gap
{.gap}
had_coverage_gap = ?                        ; Had gap in coverage
gap_start = date                            ; Gap start date
gap_end = date                              ; Gap end date
retroactive_coverage = ?                    ; Retroactive coverage provided

{@reinstatement}

; ═══════════════════════════════════════════════════════════════════════════════
; APTC RECONCILIATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per IRC 36B and Form 8962

{@aptc_reconciliation}
tax_year = !##:(2014..)                     ; Tax year
household_id = !:                           ; Tax household

; APTC paid
{.aptc_paid}
annual_aptc_paid = #$:(0..)                 ; Total APTC paid during year
monthly_amounts[] = #$:(0..)                ; APTC by month

{@aptc_reconciliation}

; Premium tax credit calculation - Per IRC 36B
{.ptc_calculation}
annual_household_income = #$                ; Actual annual income
annual_fpl = #$:(0..)                       ; FPL for household size
fpl_percent = #:(0..)                       ; Income as % FPL
applicable_percentage = #:(0..9.12)         ; Applicable percentage
benchmark_premium = #$:(0..)                ; Annual SLCSP premium
expected_contribution = #$:(0..)            ; Expected contribution
calculated_ptc = #$:(0..)                   ; Calculated PTC

{@aptc_reconciliation}

; Reconciliation result
{.result}
excess_aptc = #$:(0..)                      ; Excess APTC (repayment)
additional_ptc = #$:(0..)                   ; Additional PTC (credit)
net_adjustment = #$                         ; Net adjustment
repayment_limitation_applies = ?            ; Repayment cap applies
repayment_cap = #$:(0..)                    ; Repayment limitation amount

{@aptc_reconciliation}

; ═══════════════════════════════════════════════════════════════════════════════
; PAYMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 156.270

{@payment}
payment_id = !:                             ; Payment ID
enrollment_id = !:                          ; Enrollment
payment_date = !date                        ; Payment date

; Payment details
{.details}
amount = #$:(0..)                           ; Payment amount
coverage_month = :                          ; Coverage month (YYYY-MM)
payment_type = (binder, installment, reinstatement)
payment_method = (ach, card, check, external)

{@payment}

; Status
status = @status_record                     ; Payment status tracking
status.status = !(applied, failed, pending, refunded)

{@payment}

; APTC portion
{.aptc}
aptc_amount = #$:(0..)                      ; APTC portion
member_amount = #$:(0..)                    ; Member-paid portion

{@payment}


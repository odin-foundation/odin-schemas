; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Mortgage Servicing Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Mortgage loan servicing operations including payments, escrow management,
; and loss mitigation.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as mtg

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.mortgage.servicing"
version = "1.0.0"
title = "Mortgage Servicing Schema"
description = "Mortgage loan servicing operations"

{$derivation}
source[0].authority = "CFPB"
source[0].citation = "RESPA Regulation X - Mortgage Servicing"
source[0].url = "https://www.consumerfinance.gov/rules-policy/regulations/1024/"

source[1].authority = "Fannie Mae"
source[1].citation = "Servicing Guide"
source[1].url = "https://servicing-guide.fanniemae.com/"

source[2].authority = "Freddie Mac"
source[2].citation = "Seller/Servicer Guide - Servicing"
source[2].url = "https://guide.freddiemac.com/app/guide/section/8101.1"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial mortgage servicing schema"
changelog[0].rationale = "Servicing structure derived from RESPA, Fannie Mae, Freddie Mac"

; ═══════════════════════════════════════════════════════════════════════════════
; LOAN STATUS
; ═══════════════════════════════════════════════════════════════════════════════
; Current loan servicing status

{@loan_status}
= @status_record                              ; Inherits status tracking fields

loan_number = !:                              ; Loan number

; Override with loan-specific status values
status = !(active, bankruptcy, deed_in_lieu, forbearance, foreclosure, modification, paid_off, reo, short_sale)
status_date = !date                           ; Status effective date (required)

; Balance information
{.balance}
principal = !#$:(0..)                         ; Current principal balance
interest_accrued = #$:(0..)                   ; Accrued interest
escrow = #$:(0..)                             ; Escrow balance
fees = #$:(0..)                               ; Outstanding fees
total_payoff = #$:(0..)                       ; Total payoff amount
payoff_good_through = date                    ; Payoff good through date

{@loan_status}

; Payment status
{.payment_status}
next_due_date = date                          ; Next payment due date
paid_through_date = date                      ; Paid through date
days_delinquent = ##:(0..)                    ; Days past due
delinquency_status = (current, days_30, days_60, days_90, days_120_plus)

{@loan_status}

; Modification status
{.modification}
modified = ?                                  ; Loan has been modified
modification_date = date                      ; Modification effective date
modification_type = :                         ; Type of modification
trial_period = ?                              ; In trial modification period

{@loan_status}

; ═══════════════════════════════════════════════════════════════════════════════
; MORTGAGE PAYMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per RESPA periodic statement requirements

{@mortgage_payment}
= @payment                                    ; Inherits common payment fields

; Payment identification
payment_id = !:                               ; Unique payment identifier
loan_number = !:                              ; Loan number

; Additional payment details
received_date = date                          ; Date payment received
effective_date = date                         ; Effective date applied

; Application of funds - Per RESPA 12 CFR 1024.39
{.application}
principal = #$:(0..)                          ; Applied to principal
interest = #$:(0..)                           ; Applied to interest
escrow = #$:(0..)                             ; Applied to escrow
fees = #$:(0..)                               ; Applied to fees
suspense = #$:(0..)                           ; Held in suspense
unapplied = #$:(0..)                          ; Unapplied amount

{@mortgage_payment}

; Payment for period
for_period = date                             ; Payment covers this due date

; Additional principal
additional_principal = #$:(0..)               ; Extra principal payment

; Reversals
{.reversal}
reversed = ?                                  ; Payment was reversed
reversal_date = date                          ; Reversal date
reversal_reason = :                           ; Reason for reversal

{@mortgage_payment}

; ═══════════════════════════════════════════════════════════════════════════════
; ESCROW ACCOUNT
; ═══════════════════════════════════════════════════════════════════════════════
; Per RESPA escrow requirements 12 CFR 1024.17

{@escrow_account}
loan_number = !:                              ; Loan number

; Account status
escrow_waived = ?                             ; Escrow waiver in effect
waiver_fee = #$:(0..)                         ; Waiver fee if applicable

; Balance
current_balance = #$:(0..)                    ; Current escrow balance
target_balance = #$:(0..)                     ; Target/cushion balance
shortage = #$:(0..)                           ; Shortage amount
surplus = #$:(0..)                            ; Surplus amount

; Monthly escrow payment
monthly_escrow = #$:(0..)                     ; Monthly escrow portion

; Analysis - Per annual escrow analysis requirements
{.analysis}
last_analysis_date = date                     ; Last analysis date
next_analysis_date = date                     ; Next analysis date
projected_low_point = #$                      ; Projected low balance

{@escrow_account}

; Escrow items
items[] = @escrow_item                        ; Escrow disbursement items

{@escrow_item}
type = !(county_tax, flood_insurance, hazard_insurance, hoa, mortgage_insurance, school_tax, special_assessment)
payee = :                                     ; Payee name
annual_amount = #$:(0..)                      ; Annual amount
monthly_amount = #$:(0..)                     ; Monthly accrual
next_due_date = date                          ; Next disbursement date
last_paid_date = date                         ; Last payment date
last_paid_amount = #$:(0..)                   ; Last payment amount

; ═══════════════════════════════════════════════════════════════════════════════
; ESCROW DISBURSEMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Escrow disbursement record

{@escrow_disbursement}
disbursement_id = !:                          ; Unique disbursement ID
loan_number = !:                              ; Loan number

; Disbursement details
date = !date                                  ; Disbursement date
amount = !#$:(0..)                            ; Disbursement amount
type = !(county_tax, flood_insurance, hazard_insurance, hoa, mortgage_insurance, school_tax, special_assessment)

; Payee
payee_name = :                                ; Payee name
payee_account = :                             ; Payee account number

; Check details
{.check}
check_number = :                              ; Check number
check_date = date                             ; Check date
cleared = ?                                   ; Check cleared
cleared_date = date                           ; Date cleared

{@escrow_disbursement}

; ═══════════════════════════════════════════════════════════════════════════════
; PERIODIC STATEMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per RESPA 12 CFR 1026.41 periodic statement requirements

{@periodic_statement}
loan_number = !:                              ; Loan number
statement_date = !date                        ; Statement date
statement_period_start = !date                ; Period start
statement_period_end = !date                  ; Period end

; Payment due - Required per 1026.41(d)(1)
{.payment_due}
amount = !#$:(0..)                            ; Amount due
due_date = !date                              ; Due date
late_after = date                             ; Late if received after
late_fee = #$:(0..)                           ; Late fee amount

{@periodic_statement}

; Payment breakdown - Required per 1026.41(d)(2)
{.payment_breakdown}
principal = #$:(0..)                          ; Principal portion
interest = #$:(0..)                           ; Interest portion
escrow = #$:(0..)                             ; Escrow portion
fees = #$:(0..)                               ; Fees portion

{@periodic_statement}

; Transaction activity - Required per 1026.41(d)(4)
transactions[] = @statement_transaction       ; Activity since last statement

; Account information - Required per 1026.41(d)(3)
{.account}
principal_balance = !#$:(0..)                 ; Outstanding principal
current_interest_rate = !#.3:(0..100)         ; Current rate
next_rate_adjustment = date                   ; Next rate adjustment date
prepayment_penalty = ?                        ; Subject to prepay penalty
late_charges = #$:(0..)                       ; Total late charges

{@periodic_statement}

; Delinquency information - If applicable per 1026.41(d)(8)
{.delinquency}
delinquent = ?                                ; Account is delinquent
delinquent_since = date                       ; Delinquent since date
total_past_due = #$:(0..)                     ; Total amount past due
days_delinquent = ##:(0..)                    ; Days delinquent

{@periodic_statement}

; Year to date totals
{.ytd}
principal_paid = #$:(0..)                     ; Principal paid YTD
interest_paid = #$:(0..)                      ; Interest paid YTD
escrow_paid = #$:(0..)                        ; Escrow paid YTD
total_paid = #$:(0..)                         ; Total paid YTD

{@periodic_statement}

{@statement_transaction}
date = !date                                  ; Transaction date
type = !(disbursement, fee, interest_charge, payment, reversal)
description = :                               ; Transaction description
amount = !#$                                  ; Transaction amount (can be negative)

; ═══════════════════════════════════════════════════════════════════════════════
; LOSS MITIGATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per RESPA 12 CFR 1024.41 loss mitigation procedures

{@loss_mitigation}
loan_number = !:                              ; Loan number
application_id = !:                           ; Loss mitigation application ID

; Application status
{.application}
received_date = !date                         ; Application received
complete = ?                                  ; Application complete
complete_date = date                          ; Date deemed complete
status = !(approved, denied, incomplete, pending, withdrawn)

{@loss_mitigation}

; Options being evaluated
options[] = @loss_mitigation_option           ; Available options

; Required documents
documents_required[] = :                      ; Documents needed
documents_received[] = :                      ; Documents received

; Timeline - Per RESPA requirements
{.timeline}
acknowledgment_sent = date                    ; Acknowledgment sent date
evaluation_deadline = date                    ; Evaluation deadline
decision_date = date                          ; Decision date
appeal_deadline = date                        ; Appeal deadline

{@loss_mitigation}

{@loss_mitigation_option}
type = !(deed_in_lieu, forbearance, modification, repayment_plan, short_sale)
status = !(approved, denied, offered, pending)
decision_date = date                          ; Option decision date
denial_reason = :                             ; Reason if denied

; Terms if approved/offered
{.terms}
new_payment = #$:(0..)                        ; New payment amount
new_rate = #.3:(0..100)                       ; New interest rate
term_extension_months = ##:(0..)              ; Term extension
principal_forbearance = #$:(0..)              ; Forborne principal
trial_period_months = ##:(0..)                ; Trial period length

{@loss_mitigation_option}

; ═══════════════════════════════════════════════════════════════════════════════
; PAYOFF STATEMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per RESPA payoff statement requirements

{@payoff_statement}
loan_number = !:                              ; Loan number
statement_date = !date                        ; Statement date
good_through_date = !date                     ; Payoff good through date

; Payoff amounts
{.amounts}
principal_balance = !#$:(0..)                 ; Unpaid principal
accrued_interest = #$:(0..)                   ; Interest through good through date
escrow_balance = #$                           ; Escrow balance (credit if positive)
late_charges = #$:(0..)                       ; Outstanding late charges
other_fees = #$:(0..)                         ; Other fees
recording_fee = #$:(0..)                      ; Recording fee
release_fee = #$:(0..)                        ; Release tracking fee
total_payoff = !#$:(0..)                      ; Total payoff amount

{@payoff_statement}

; Per diem interest
per_diem = #$:(0..)                           ; Daily interest after good through

; Wire instructions
{.wire}
bank_name = :                                 ; Bank name
routing = :                                   ; Routing number
account = :                                   ; Account number
reference = :                                 ; Wire reference

{@payoff_statement}


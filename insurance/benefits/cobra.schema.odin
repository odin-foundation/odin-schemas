; ═══════════════════════════════════════════════════════════════════════════════
; ODIN COBRA Benefits Schema
; ═══════════════════════════════════════════════════════════════════════════════
; COBRA continuation coverage administration derived from COBRA (29 USC 1161-1168)
; and ERISA regulations.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as benefits

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.benefits.cobra"
version = "1.0.0"
title = "COBRA Continuation Coverage Schema"
description = "COBRA continuation coverage administration per 29 USC 1161-1168"

{$derivation}
source[0].authority = "GPO"
source[0].citation = "29 USC 1161-1168 - COBRA Continuation Coverage"
source[0].url = "https://www.law.cornell.edu/uscode/text/29/1161"

source[1].authority = "DOL"
source[1].citation = "29 CFR Part 2590 - COBRA Regulations"
source[1].url = "https://www.ecfr.gov/current/title-29/subtitle-B/chapter-XXV/subchapter-L/part-2590"

source[2].authority = "IRS"
source[2].citation = "IRC Section 4980B - COBRA Excise Tax"
source[2].url = "https://www.law.cornell.edu/uscode/text/26/4980B"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial COBRA continuation coverage schema"
changelog[0].rationale = "Structure derived from COBRA statute and DOL regulations"

; ═══════════════════════════════════════════════════════════════════════════════
; COBRA QUALIFYING EVENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 29 USC 1163

{@qualifying_event}
event_id = :                               ; Event ID
employer_id = :                            ; Employer
employee_id = :                            ; Employee

; Event type - Per 29 USC 1163
{.event}
event_type = (death_of_covered_employee, dependent_ceases_to_qualify, divorce_or_legal_separation, entitlement_to_medicare, reduction_of_hours, termination_of_employment)
event_date = date                          ; Date of qualifying event
gross_misconduct = ?                        ; Gross misconduct (disqualifies)

{@qualifying_event}

; Affected beneficiaries - Per COBRA
{.beneficiaries}
employee_affected = ?                       ; Employee affected
spouse_affected = ?                         ; Spouse affected
dependents_affected[] = :                   ; Affected dependent IDs

{@qualifying_event}

; Coverage continuation period - Per 29 USC 1162
{.continuation}
maximum_months = ##:(18..36)                ; Maximum continuation months
; 18 months for termination/reduction
; 29 months for disability
; 36 months for other events
disability_extension = ?                    ; Disability extension (11 months)
second_qualifying_event = ?                 ; Second qualifying event
extended_months = ##:(0..18)                ; Additional months

{@qualifying_event}

; Notification - Per 29 USC 1166
{.notification}
employer_notification_date = date           ; Date employer notified plan
employer_notification_due = date            ; Due date (30 days from event)
employee_notification_date = date           ; Date employee notified (if required)
employee_notification_due = date            ; Due date (60 days from event)
plan_notification_to_beneficiary_date = date ; Plan notified beneficiary
plan_notification_due = date                ; Due date (14 days after employer notice)

{@qualifying_event}

; ═══════════════════════════════════════════════════════════════════════════════
; COBRA ELECTION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 29 USC 1165

{@election}
election_id = :                            ; Election ID
event_id = :                               ; Qualifying event ID
beneficiary_id = :                         ; Qualified beneficiary ID
beneficiary_type = (dependent_child, employee, spouse)

; Election decision
{.decision}
election = (declined, elected, no_response)
election_date = date                        ; Date of election
election_due_date = date                    ; Due date (60 days from notice)
retroactive_coverage = ?                    ; Retroactive to loss date

{@election}

; Coverage elected
{.coverage}
plans_elected[] = :                         ; Plan IDs elected
coverage_type = :                           ; Coverage type (EE only, family, etc.)
coverage_start_date = date                  ; Coverage start (retroactive)
coverage_end_date = date                    ; Coverage end date

{@election}

; Premium - Per 29 USC 1162(3)
{.premium}
monthly_premium = #$:(0..)                  ; Monthly premium
administrative_fee_percent = #:(0..2)       ; Admin fee (up to 2%)
total_monthly_premium = #$:(0..)            ; Total monthly (premium + admin)
disability_surcharge = ?                    ; Disability surcharge (up to 150%)
disability_premium = #$:(0..)               ; Premium during disability extension
initial_payment_due = date                  ; Initial payment due date
initial_payment_grace_days = ##:(45..45)    ; 45-day grace for initial

{@election}

; Status
status = (active, cancelled, declined, exhausted, expired, pending)

; ═══════════════════════════════════════════════════════════════════════════════
; COBRA PAYMENT
; ═══════════════════════════════════════════════════════════════════════════════

{@payment}
payment_id = :                             ; Payment ID
election_id = :                            ; Election ID
beneficiary_id = :                         ; Beneficiary ID

; Payment details
{.details}
coverage_month = date                       ; Coverage month
due_date = date                             ; Payment due date
grace_period_end = date                     ; End of 30-day grace period
amount_due = #$:(0..)                       ; Amount due

{@payment}

; Payment received
{.received}
amount_paid = #$:(0..)                      ; Amount paid
payment_date = date                         ; Date received
payment_method = (ach, check, credit_card)
check_number = :                            ; Check number (if check)
shortfall_amount = #$:(0..)                 ; Shortfall (if any)
shortfall_notice_sent = ?                   ; Insignificant shortfall notice

{@payment}

; Status
status = (cancelled, late, overdue, paid, pending)

; ═══════════════════════════════════════════════════════════════════════════════
; COBRA COVERAGE
; ═══════════════════════════════════════════════════════════════════════════════

{@coverage}
coverage_id = :                            ; Coverage ID
election_id = :                            ; Election ID
beneficiary_id = :                         ; Beneficiary ID

; Plan information
{.plan}
plan_id = :                                ; Plan ID
plan_name = :                               ; Plan name
plan_type = (dental, health, rx, vision)    ; Coverage type
carrier_name = :                            ; Carrier name
group_number = :                            ; Group number

{@coverage}

; Coverage period
{.period}
effective_date = date                      ; Coverage effective date
termination_date = date                     ; Termination date
maximum_end_date = date                     ; Maximum coverage end date

{@coverage}

; Premium
{.premium}
monthly_premium = #$:(0..)                  ; Monthly premium
employer_portion = #$:(0..)                 ; Employer subsidy (if any)
participant_portion = #$:(0..)              ; Participant pays

{@coverage}

; Status
status = (active, cancelled, terminated)
termination_reason = (coverage_exhausted, death, eligibility_lost, employer_plan_terminated, failure_to_pay, other_coverage, request, retiree_coverage)

; ═══════════════════════════════════════════════════════════════════════════════
; COBRA NOTICE
; ═══════════════════════════════════════════════════════════════════════════════
; Per 29 USC 1166

{@notice}
notice_id = :                              ; Notice ID
employer_id = :                            ; Employer
notice_type = (conversion_rights, early_termination, election, general_rights, initial_notice, insufficient_payment, premium_change, unavailability)

; Recipient
{.recipient}
recipient_type = (all_covered, employee, qualified_beneficiary, spouse)
recipient_id = :                            ; Recipient ID
recipient_name = :                          ; Recipient name
recipient_address = @address                ; Address

{@notice}

; Notice content - Per DOL model notices
{.content}
notice_date = date                         ; Date of notice
due_date = date                             ; Response due date
delivery_method = (certified_mail, electronic, first_class, hand_delivery)
tracking_number = :                         ; Tracking (if certified)

{@notice}

; Delivery confirmation
{.delivery}
sent_date = date                            ; Date sent
delivered_date = date                       ; Date delivered
return_receipt = ?                          ; Return receipt received

{@notice}

; ═══════════════════════════════════════════════════════════════════════════════
; COBRA ADMINISTRATION RECORD
; ═══════════════════════════════════════════════════════════════════════════════

{@administration}
admin_id = :                               ; Administration record ID
employer_id = :                            ; Employer
plan_year = ##:(2000..)                    ; Plan year

; Administrator
{.administrator}
self_administered = ?                       ; Self-administered
tpa_name = :                                ; TPA name (if outsourced)
tpa_contact = :                             ; TPA contact

{@administration}

; Active participants
{.participants}
total_qualified_beneficiaries = ##:(0..)    ; Total QBs
active_elections = ##:(0..)                 ; Active elections
pending_elections = ##:(0..)                ; Pending elections

{@administration}

; Compliance
{.compliance}
spd_includes_cobra = ?                      ; SPD includes COBRA info
general_notice_distributed = ?              ; General notice distributed
model_notices_used = ?                      ; Using DOL model notices

{@administration}

; ═══════════════════════════════════════════════════════════════════════════════
; STATE CONTINUATION COVERAGE
; ═══════════════════════════════════════════════════════════════════════════════
; Mini-COBRA for small employers (varies by state)

{@state_continuation}
state = :(2)                               ; State code
employer_id = :                            ; Employer
employee_id = :                            ; Employee

; State program
{.program}
program_name = :                            ; State program name
employer_size_threshold = ##:(0..20)        ; Employer size threshold
applies = ?                                 ; State continuation applies

{@state_continuation}

; Qualifying event
{.event}
event_type = :                              ; Event type (per state law)
event_date = date                           ; Event date

{@state_continuation}

; Continuation period - Per state requirements
{.continuation}
maximum_months = ##:(0..36)                 ; Maximum months (per state)
health_coverage = ?                         ; Health coverage continues
dental_coverage = ?                         ; Dental coverage continues
vision_coverage = ?                         ; Vision coverage continues

{@state_continuation}

; Premium - Per state requirements
{.premium}
premium_limit = :                           ; Premium limit (per state)
monthly_premium = #$:(0..)                  ; Monthly premium

{@state_continuation}

; Election
{.election}
election_period_days = ##:(0..60)           ; Election period (per state)
election = (declined, elected, pending)
election_date = date                        ; Election date

{@state_continuation}

; Status
status = (active, exhausted, terminated)

; ═══════════════════════════════════════════════════════════════════════════════
; COBRA SUBSIDY (ARPA 2021 model)
; ═══════════════════════════════════════════════════════════════════════════════
; Template for future subsidy programs

{@subsidy}
subsidy_id = :                             ; Subsidy ID
election_id = :                            ; Election ID
beneficiary_id = :                         ; Beneficiary ID

; Subsidy program
{.program}
program_name = :                            ; Program name (e.g., "ARPA 2021")
legislation = :                             ; Authorizing legislation
effective_start = date                      ; Subsidy period start
effective_end = date                        ; Subsidy period end

{@subsidy}

; Eligibility
{.eligibility}
eligible = ?                                ; Eligible for subsidy
eligibility_reason = :                      ; Reason (involuntary term, etc.)
ineligibility_reason = :                    ; Reason not eligible
other_coverage_available = ?                ; Other coverage disqualifies

{@subsidy}

; Subsidy amount
{.amount}
subsidy_percent = #:(0..100)                ; Subsidy percentage
monthly_subsidy = #$:(0..)                  ; Monthly subsidy amount
participant_pays = #$:(0..)                 ; Participant portion

{@subsidy}

; Status
status = (active, ended, ineligible)
end_reason = :                              ; Reason subsidy ended

; ═══════════════════════════════════════════════════════════════════════════════
; CONVERSION RIGHTS
; ═══════════════════════════════════════════════════════════════════════════════
; Per group policy conversion provisions

{@conversion}
conversion_id = :                          ; Conversion ID
election_id = :                            ; COBRA election ID
beneficiary_id = :                         ; Beneficiary ID

; Conversion offer
{.offer}
conversion_available = ?                    ; Conversion available
conversion_notice_date = date               ; Date conversion notice sent
conversion_deadline = date                  ; Conversion deadline

{@conversion}

; Converted coverage
{.coverage}
plan_type = (dental, health, vision)        ; Coverage type
individual_plan_name = :                    ; Individual plan name
carrier_name = :                            ; Carrier name
effective_date = date                       ; Effective date
monthly_premium = #$:(0..)                  ; Monthly premium

{@conversion}

; Status
status = (converted, declined, offered, pending)



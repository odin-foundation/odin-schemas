; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Telecom Subscriber Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Subscriber accounts (residential, business, enterprise), contacts, credit,
; and CPNI identity information.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.telecom.subscriber"
version = "1.0.0"
title = "Telecom Subscriber Schema"
description = "Subscriber account management and CPNI identity"

{$derivation}
source[0].authority = "Federal Communications Commission"
source[0].citation = "47 CFR Part 64, Subpart U - Customer Proprietary Network Information"
source[0].url = "https://www.ecfr.gov/current/title-47/chapter-I/subchapter-B/part-64/subpart-U"

source[1].authority = "Federal Communications Commission"
source[1].citation = "47 CFR Part 54 - Universal Service"
source[1].url = "https://www.ecfr.gov/current/title-47/chapter-I/subchapter-B/part-54"

source[2].authority = "CTIA - The Wireless Association"
source[2].citation = "CTIA Consumer Code for Wireless Service"
source[2].url = "https://www.ctia.org/consumer-resources/consumer-code"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial subscriber schema"
changelog[0].rationale = "Account structure derived from FCC CPNI regulations and carrier industry practices"

; ═══════════════════════════════════════════════════════════════════════════════
; ACCOUNT
; ═══════════════════════════════════════════════════════════════════════════════
; Subscriber account (residential, business, enterprise)

{@account}
= @types.base_account

; ───────────────────────────────────────────────────────────────────────────────
; Account Type (Telecom-specific)
; ───────────────────────────────────────────────────────────────────────────────
account_type = (business, enterprise, government, residential)

; ───────────────────────────────────────────────────────────────────────────────
; Account Status (Additional telecom statuses)
; ───────────────────────────────────────────────────────────────────────────────
status_reason = :                                 ; Reason for status change

; ───────────────────────────────────────────────────────────────────────────────
; Account Holder Information
; ───────────────────────────────────────────────────────────────────────────────
{.account_holder}
name = @types.person_name                         ; Account holder name (individual)
business_name = :                                 ; Business name (business/enterprise)
tax_id = *:                                       ; Tax ID/EIN (business)
ssn = *:format ssn                                ; SSN (individual)
date_of_birth = *date                             ; Date of birth (individual)

{@account}

; ───────────────────────────────────────────────────────────────────────────────
; Contact Information (CPNI)
; ───────────────────────────────────────────────────────────────────────────────
{.contact_info}
mailing_address = @types.address                  ; Mailing address (if different)
phones[] = *@types.phone                          ; Contact phone numbers (CPNI)
emails[] = *@types.email                          ; Contact email addresses (CPNI)
preferred_contact_method = (email, mail, phone, sms)
preferred_language = :(2)                         ; ISO 639-1 language code

{@account}

; ───────────────────────────────────────────────────────────────────────────────
; Account Dates
; ───────────────────────────────────────────────────────────────────────────────
{.dates}
activated = date                                  ; Account activation date
last_payment = date                               ; Last payment date
next_bill_date = date                             ; Next billing date

{@account}

; ───────────────────────────────────────────────────────────────────────────────
; Credit Information
; ───────────────────────────────────────────────────────────────────────────────
{.credit}
credit_check_date = date                          ; Date of credit check
credit_score = *##                                ; Credit score (confidential)
credit_tier = (excellent, fair, good, poor)       ; Credit tier classification
deposit_required = ?                              ; Deposit required flag
deposit_amount = #$:(0..)                         ; Deposit amount
deposit_status = (held, refunded, waived)

{@account}

; ───────────────────────────────────────────────────────────────────────────────
; Billing Preferences
; ───────────────────────────────────────────────────────────────────────────────
{.billing}
billing_cycle = (monthly, quarterly)
bill_delivery_method = (both, email, mail, online)
paperless_billing = ?                             ; Paperless billing enabled
auto_pay_enabled = ?                              ; Auto-pay enabled
payment_method = (ach, check, credit_card)

{@account}

; ───────────────────────────────────────────────────────────────────────────────
; Account Balance
; ───────────────────────────────────────────────────────────────────────────────
{.balance}
current_balance = #$                              ; Current account balance
past_due_amount = #$:(0..)                        ; Past due amount
credit_limit = #$:(0..)                           ; Credit limit
available_credit = #$:(0..)                       ; Available credit

{@account}

; ───────────────────────────────────────────────────────────────────────────────
; Authorized Users
; ───────────────────────────────────────────────────────────────────────────────
authorized_users[] = @authorized_user             ; Authorized account users

; ───────────────────────────────────────────────────────────────────────────────
; Service Restrictions
; ───────────────────────────────────────────────────────────────────────────────
{.restrictions}
international_calling_blocked = ?                 ; International calling blocked
premium_sms_blocked = ?                           ; Premium SMS blocked
data_roaming_blocked = ?                          ; Data roaming blocked
spending_limit = #$:(0..)                         ; Monthly spending limit
spending_limit_enabled = ?                        ; Spending limit active

{@account}

; ───────────────────────────────────────────────────────────────────────────────
; Marketing Preferences
; ───────────────────────────────────────────────────────────────────────────────
{.marketing}
marketing_opt_in = ?                              ; Marketing communications opt-in
third_party_sharing = ?                           ; Allow third-party sharing
do_not_call = ?                                   ; Do not call registry
do_not_email = ?                                  ; Do not email

{@account}

; ───────────────────────────────────────────────────────────────────────────────
; Lifeline/ACP Program (Low-Income Assistance)
; ───────────────────────────────────────────────────────────────────────────────
{.assistance_program}
program_type = (acp, lifeline, tribal)            ; Assistance program type
enrolled = ?                                      ; Enrolled in program
enrollment_date = date                            ; Enrollment date
recertification_date = date                       ; Next recertification date
benefit_amount = #$:(0..)                         ; Monthly benefit amount

{@account}

; ───────────────────────────────────────────────────────────────────────────────
; Account Notes
; ───────────────────────────────────────────────────────────────────────────────
notes[] = @account_note                           ; Account notes

; ═══════════════════════════════════════════════════════════════════════════════
; AUTHORIZED USER
; ═══════════════════════════════════════════════════════════════════════════════
; Authorized users on the account (can make changes, view bills, etc.)

{@authorized_user}
; Required fields
user_id = :                                      ; Unique user identifier
name = @types.person_name                        ; User name
relationship = (account_holder, authorized_representative, employee, other, spouse)

; Optional fields
phone = *@types.phone                             ; User contact phone
email = *@types.email                             ; User contact email
permissions = :                                   ; Permission level description
can_make_changes = ?                              ; Can make account changes
can_view_bills = ?                                ; Can view billing information
can_authorize_payments = ?                        ; Can authorize payments
added_date = date                                 ; Date user was added
removed_date = date                               ; Date user was removed
pin = *:                                          ; Security PIN (confidential)

; ═══════════════════════════════════════════════════════════════════════════════
; CONTACT RECORD
; ═══════════════════════════════════════════════════════════════════════════════
; Customer contact/interaction record

{@contact_record}
; Required fields
contact_id = :                                   ; Unique contact identifier
contact_date = timestamp                         ; Date and time of contact
contact_method = (chat, email, in_person, phone, social_media, web_form)
contact_reason = :                               ; Reason for contact

; Optional fields
contact_type = (complaint, inquiry, service_request, support)
agent_id = :                                      ; Agent/rep who handled contact
duration_seconds = ##:(0..)                       ; Contact duration in seconds
resolution = :                                    ; Resolution description
resolved = ?                                      ; Contact resolved flag
follow_up_required = ?                            ; Follow-up required
follow_up_date = date                             ; Scheduled follow-up date
notes = :                                         ; Contact notes

; ═══════════════════════════════════════════════════════════════════════════════
; ACCOUNT NOTE
; ═══════════════════════════════════════════════════════════════════════════════
; Account-level note or annotation

{@account_note}
; Required fields
note_id = :                                      ; Unique note identifier
note_date = timestamp                            ; Note timestamp
note_text = :                                    ; Note content

; Optional fields
note_type = (billing, collection, credit, general, service, technical)
created_by = :                                    ; User who created note
visible_to_customer = ?                           ; Customer can view this note
alert_flag = ?                                    ; Alert/warning flag

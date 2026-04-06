; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Medicaid Enrollment Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Medicaid application and enrollment processes including applications,
; case management, and periodic renewal. Derived from CMS-10114 Single
; Streamlined Application and 42 CFR Part 435.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as medicaid

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.medicaid.enrollment"
version = "1.0.0"
title = "Medicaid Enrollment Schema"
description = "Medicaid application and enrollment processes"

{$derivation}
source[0].authority = "CMS"
source[0].citation = "CMS-10114 Single Streamlined Application"
source[0].url = "https://www.medicaid.gov/medicaid/eligibility/downloads/application-instructions.pdf"

source[1].authority = "GPO"
source[1].citation = "42 CFR 435.907 - Application"
source[1].url = "https://www.ecfr.gov/current/title-42/chapter-IV/subchapter-C/part-435/subpart-J/section-435.907"

source[2].authority = "GPO"
source[2].citation = "42 CFR 435.916 - Periodic renewal of eligibility"
source[2].url = "https://www.ecfr.gov/current/title-42/chapter-IV/subchapter-C/part-435/subpart-J/section-435.916"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial Medicaid enrollment schema"
changelog[0].rationale = "Structure derived from CMS Single Streamlined Application and 42 CFR Part 435"

; ═══════════════════════════════════════════════════════════════════════════════
; APPLICATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 435.907 and CMS-10114

{@application}
application_id = !:                          ; Application tracking number
state = !:(2)                                ; State of application

; Application type
application_type = !(initial, renewal, change_report)
application_source = !(agency, fbe, mail, marketplace, online, phone)
; fbe = Federally Facilitated Exchange

; Dates
{.dates}
received = !date                             ; Date received
submitted = date                             ; Date submitted by applicant
due_date = date                              ; Decision due date (45 days standard)
decision_date = date                         ; Date of decision

{@application}

; Contact person - Per 42 CFR 435.908
applicant_name = :                           ; Applicant name
phone = *@phone                              ; Phone number
email = *@email                              ; Email address
authorized_rep = ?                           ; Has authorized representative
authorized_rep_name = :                      ; Authorized rep name
authorized_rep_phone = *@phone               ; Authorized rep phone

{@application}

; Household members on application
applicants[] = @applicant_info               ; Applicants on this application

; Programs requested
{.programs}
medicaid = ?                                 ; Medicaid requested
chip = ?                                     ; CHIP requested
marketplace = ?                              ; Marketplace coverage requested

{@application}

; Application status
status = @status_record                      ; Status tracking with date and reason
status.status = !(approved, denied, pending, returned, withdrawn)
substatus = :                                ; Detailed substatus

{@application}

; Verification status
{.verification}
all_verified = ?                             ; All verifications complete
pending_items[] = :                          ; Pending verification items
rop_items[] = :                              ; Items in reasonable opportunity period
documents_requested = ?                      ; Documents requested
document_due_date = date                     ; Document deadline

{@application}

; Marketplace referral - Per 42 CFR 435.1200
{.marketplace}
referred_from_marketplace = ?                ; Referred from marketplace
marketplace_app_id = :                       ; Marketplace application ID
referred_to_marketplace = ?                  ; Referred to marketplace
aptc_eligible = ?                            ; Potentially APTC eligible

{@application}

{@applicant_info}
member = !@medicaid.member                   ; Member information
applying_for = (chip, medicaid)              ; Program applying for
relationship_to_primary = :                  ; Relationship to primary applicant

; Eligibility result
{.eligibility}
determination = @eligibility.determination   ; Eligibility determination
eligible = ?                                 ; Eligible result
eligibility_group = :                        ; Eligibility group if eligible
effective_date = date                        ; Coverage effective date

{@applicant_info}

; ═══════════════════════════════════════════════════════════════════════════════
; CASE RECORD
; ═══════════════════════════════════════════════════════════════════════════════
; Per state Medicaid case management

{@case}
case_number = !:                             ; Case number
state = !:(2)                                ; State
case_type = !(family, individual)            ; Case type

; Case head
case_head = !@medicaid.member                ; Head of case/household

; Members
members[] = @case_member                     ; Members on case

; Status
status = @status_record                      ; Status tracking with date and reason
status.status = !(active, closed, pending, suspended)
open_date = date                             ; Case open date
close_date = date                            ; Case close date

{@case}

; Eligibility
{.eligibility}
current_aid_category = :                     ; Current aid category
benefit_package = :                          ; Current benefit package
redetermination_due = date                   ; Next renewal date

{@case}

; Case actions
actions[] = @case_action                     ; Case action history

{@case_member}
member = !@medicaid.member                   ; Member information
relationship_to_head = :                     ; Relationship to case head
coverage_status = !(active, closed, pending)
eligibility_group = :                        ; Member's eligibility group
effective_date = date                        ; Coverage effective date
end_date = date                              ; Coverage end date

{@case_action}
action_type = !(add_member, close, eligibility_change, open, remove_member, renewal, suspend)
action_date = !date                          ; Action date
effective_date = !date                       ; Effective date
reason = :                                   ; Reason for action
processed_by = :                             ; Worker who processed

; ═══════════════════════════════════════════════════════════════════════════════
; RENEWAL
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 435.916

{@renewal}
case_number = !:                             ; Case number
member_id = !:                               ; Member ID
renewal_type = !(annual, change_circumstance)

; Renewal period
{.period}
current_period_end = !date                   ; Current coverage end
renewal_due = !date                          ; Renewal due date
renewal_effective = date                     ; New period effective date

{@renewal}

; Ex parte attempt - Per 42 CFR 435.916(a)(2)
{.ex_parte}
attempted = ?                                ; Ex parte attempted
successful = ?                               ; Renewed ex parte
data_sources_used[] = :                      ; Data sources checked

{@renewal}

; Renewal form
{.form}
form_sent = ?                                ; Pre-populated form sent
form_sent_date = date                        ; Date form sent
form_due_date = date                         ; Form due date
form_received = ?                            ; Form received
form_received_date = date                    ; Date form received
response_required = ?                        ; Response required

{@renewal}

; Renewal result
result = @status_record                      ; Result status with reason
result.status = !(closed, pending, renewed)
renewed_eligibility_group = :                ; New eligibility group
procedural_closure = ?                       ; Closed for procedural reasons

{@renewal}

; ═══════════════════════════════════════════════════════════════════════════════
; CHANGE REPORT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 435.916(d)

{@change_report}
report_id = !:                               ; Report ID
case_number = !:                             ; Case number
report_date = !date                          ; Date reported

; Change type
change_type = !(address, contact, death, employment, household, income, insurance, other, pregnancy)

; Change details
{.change}
description = :                              ; Change description
effective_date = date                        ; When change occurred
old_value = :                                ; Previous value
new_value = :                                ; New value

{@change_report}

; Processing
{.processing}
processed = ?                                ; Change processed
processed_date = date                        ; Processing date
eligibility_impact = (closed, no_change, recalculated, suspended)
new_eligibility_group = :                    ; New group if changed

{@change_report}

; ═══════════════════════════════════════════════════════════════════════════════
; DISENROLLMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 435.916

{@disenrollment}
member_id = !:                               ; Member ID
case_number = !:                             ; Case number
disenrollment_date = !date                   ; Disenrollment effective date

; Reason - Per 42 CFR 435.916(f)
reason = !(death, eligibility_change, failure_to_respond, income_increase, incarceration, moved, other_coverage, request, transfer)

; Voluntary vs involuntary
voluntary = ?                                ; Voluntary disenrollment

; Notice - Per 42 CFR 435.918
{.notice}
advance_notice_sent = ?                      ; Advance notice sent
notice_date = date                           ; Notice date
notice_type = (adequate, advance, combined)
appeal_rights_provided = ?                   ; Appeal rights in notice
appeal_deadline = date                       ; Appeal deadline

{@disenrollment}

; Continuation during appeal
{.continuation}
aid_paid_pending = ?                         ; Benefits continue during appeal
appeal_filed = ?                             ; Appeal filed
continuation_end_date = date                 ; Aid continues until

{@disenrollment}

; ═══════════════════════════════════════════════════════════════════════════════
; FAIR HEARING / APPEAL
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR Part 431 Subpart E

{@appeal}
appeal_id = !:                               ; Appeal ID
member_id = !:                               ; Member ID
case_number = :                              ; Case number

; Appeal type
appeal_type = !(action, application_denial, eligibility)
appealed_action = :                          ; Action being appealed
appeal_reason = :                            ; Reason for appeal

; Filing
{.filing}
filed_date = !date                           ; Date appeal filed
timely_filed = ?                             ; Filed within deadline
filing_method = (mail, online, phone, written)

{@appeal}

; Scheduling
{.hearing}
hearing_scheduled = ?                        ; Hearing scheduled
hearing_date = date                          ; Hearing date
hearing_type = (in_person, phone, video)
hearing_location = :                         ; Hearing location

{@appeal}

; Resolution
resolution = @status_record                  ; Resolution status with reason
resolution.status = !(affirmed, dismissed, pending, remanded, reversed, withdrawn)

{@appeal}

; Aid during appeal - Per 42 CFR 431.230
aid_continuing = ?                           ; Aid continued during appeal
aid_continuation_requested = ?               ; Continuation requested


; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Legal Calendar Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Legal calendar, deadline, and event management for law practice. Covers
; court dates, filing and discovery deadlines, depositions, meetings, and
; statute of limitations tracking with reminder and conflict-check workflows.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as legal
@import "../../common/types.schema.odin" as common

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.legal.court.calendar"
version = "1.0.0"
title = "Legal Calendar Schema"
description = "Legal calendar and deadline management"

{$derivation}
source[0].authority = "American Bar Association"
source[0].citation = "Model Rule 1.3 Diligence - Docketing and Calendaring"
source[0].url = "https://www.americanbar.org/groups/professional_responsibility/publications/model_rules_of_professional_conduct/"

source[1].authority = "Federal Rules of Civil Procedure"
source[1].citation = "Rule 6 - Computing and Extending Time"
source[1].url = "https://www.uscourts.gov/rules-policies/current-rules-practice-procedure/federal-rules-civil-procedure"

source[2].authority = "State Court Rules"
source[2].citation = "Time Computation Rules"
source[2].url = "varies by jurisdiction"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Calendar schema derived from professional responsibility rules and court procedures"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial legal calendar schema"
changelog[0].rationale = "Comprehensive calendar and deadline tracking"

; ═══════════════════════════════════════════════════════════════════════════════
; LEGAL CALENDAR EVENT
; ═══════════════════════════════════════════════════════════════════════════════
; Base calendar event type

{@legal_calendar_event}
; Required fields first
event_date = !date                                ; Event date
event_type = !(appointment, call, conference, court_date, deadline, deposition, filing, hearing, meeting, other, reminder, trial)
title = !:                                        ; Event title

; Event identification
event_id = :                                      ; Unique event identifier

; ───────────────────────────────────────────────────────────────────────────────
; Time Details
; ───────────────────────────────────────────────────────────────────────────────
{.time}
start_time = time                                 ; Start time
end_time = time                                   ; End time
all_day = ?                                       ; All day event
timezone = :                                      ; Timezone
recurring = ?                                     ; Recurring event
recurrence_pattern = (daily, monthly, weekly):if recurring = true
recurrence_end = date:if recurring = true         ; Recurrence end date

{@legal_calendar_event}

; ───────────────────────────────────────────────────────────────────────────────
; Location
; ───────────────────────────────────────────────────────────────────────────────
{.location}
location_type = (client_site, court, firm_office, offsite, remote, virtual)
location_name = :                                 ; Location name
address = @address:if location_type != virtual & location_type != remote
room = :                                          ; Room/courtroom
virtual_meeting = ?:if location_type = virtual | location_type = remote
meeting_platform = ::if virtual_meeting = true    ; Video platform
meeting_link = ::if virtual_meeting = true        ; Meeting link
dial_in_number = *@phone:if virtual_meeting = true
access_code = ::if virtual_meeting = true         ; Access code

{@legal_calendar_event}

; ───────────────────────────────────────────────────────────────────────────────
; Matter Reference
; ───────────────────────────────────────────────────────────────────────────────
{.matter}
matter_ref = @legal_matter_ref                    ; Related matter
case_ref = @legal_case_ref                        ; Related case
client_ref = @legal_client                        ; Related client

{@legal_calendar_event}

; ───────────────────────────────────────────────────────────────────────────────
; Participants
; ───────────────────────────────────────────────────────────────────────────────
{.participants[]}
participant_name = :                              ; Participant name
role = (assistant, attorney, client, expert, judge, opposing_counsel, paralegal, vendor, witness)
required = ?                                      ; Required attendee
confirmed = ?                                     ; Attendance confirmed
email = *@email                                   ; Participant email
phone = *@phone                                   ; Participant phone

{@legal_calendar_event}

; ───────────────────────────────────────────────────────────────────────────────
; Reminders
; ───────────────────────────────────────────────────────────────────────────────
{.reminders[]}
reminder_type = (email, popup, sms)               ; Reminder type
reminder_time = ##:(0..)                          ; Minutes before event
recipients[] = :                                  ; Who to remind

{@legal_calendar_event}

; ───────────────────────────────────────────────────────────────────────────────
; Notes and Preparation
; ───────────────────────────────────────────────────────────────────────────────
description = :                                   ; Event description
notes = :                                         ; Internal notes
preparation_needed = ?                            ; Preparation required
preparation_notes = ::if preparation_needed = true
documents_needed[] = :                            ; Documents to bring
tasks_before[] = :                                ; Tasks to complete before

{@legal_calendar_event}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (cancelled, completed, confirmed, pending, rescheduled, tentative)
rescheduled_to = date:if status = rescheduled     ; New date
cancellation_reason = ::if status = cancelled     ; Why cancelled
completed_notes = ::if status = completed         ; Completion notes

; ═══════════════════════════════════════════════════════════════════════════════
; COURT DATE
; ═══════════════════════════════════════════════════════════════════════════════
; Court appearance calendar entry

{@legal_court_date}
= @legal_calendar_event                           ; Inherits calendar event

; Court-specific fields
court_date_type = !(arraignment, calendar_call, hearing, oral_argument, pretrial, scheduling, settlement, status, trial)
hearing_ref = @court_hearing                      ; Reference to hearing

; ───────────────────────────────────────────────────────────────────────────────
; Court Details
; ───────────────────────────────────────────────────────────────────────────────
{.court}
court_ref = @legal_court                          ; Court reference
courtroom = :                                     ; Courtroom number
judge_ref = @legal_judge                          ; Judge
department = :                                    ; Department/division

{@legal_court_date}

; ───────────────────────────────────────────────────────────────────────────────
; Appearance Details
; ───────────────────────────────────────────────────────────────────────────────
{.appearance}
appearing_attorneys[] = @legal_attorney           ; Attorneys appearing
lead_attorney = @legal_attorney                   ; Lead attorney
telephonic_appearance = ?                         ; Telephonic allowed
video_appearance = ?                              ; Video allowed
client_attendance = (not_required, optional, required)
interpreter_needed = ?                            ; Interpreter required
interpreter_language = ::if interpreter_needed = true

{@legal_court_date}

; ───────────────────────────────────────────────────────────────────────────────
; Motion/Matter Being Heard
; ───────────────────────────────────────────────────────────────────────────────
{.subject}
motion_type = :                                   ; Type of motion
docket_number = ##:(0..)                          ; Related docket entry
issues[] = :                                      ; Issues to be addressed
relief_sought = :                                 ; Relief being sought

{@legal_court_date}

; ───────────────────────────────────────────────────────────────────────────────
; Preparation
; ───────────────────────────────────────────────────────────────────────────────
{.preparation}
brief_filed = ?                                   ; Brief/memo filed
exhibits_prepared = ?                             ; Exhibits prepared
witness_preparation_complete = ?                  ; Witnesses prepared
argument_outline_prepared = ?                     ; Outline prepared

{@legal_court_date}

; ───────────────────────────────────────────────────────────────────────────────
; Outcome
; ───────────────────────────────────────────────────────────────────────────────
{.outcome}
appearance_made = ?                               ; Appearance was made
result = :                                        ; Hearing result
ruling = :                                        ; Judge's ruling
order_issued = ?                                  ; Order issued
next_court_date = date                            ; Next scheduled date

{@legal_court_date}

; ═══════════════════════════════════════════════════════════════════════════════
; DEPOSITION
; ═══════════════════════════════════════════════════════════════════════════════
; Deposition calendar entry

{@legal_deposition}
= @legal_calendar_event                           ; Inherits calendar event

; Required fields
deponent_name = !:                                ; Deponent name
deposition_type = !(expert, fact_witness, party, rule_30b6)

; ───────────────────────────────────────────────────────────────────────────────
; Deposition Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
noticed_by = (defendant, plaintiff, third_party)  ; Party noticing
notice_date = date                                ; Notice date
our_role = (defending, taking)                    ; Our role
estimated_duration = :                            ; Estimated length
video_recorded = ?                                ; Videotaped deposition

{@legal_deposition}

; ───────────────────────────────────────────────────────────────────────────────
; Deponent Information
; ───────────────────────────────────────────────────────────────────────────────
{.deponent}
witness_ref = @legal_fact_witness                 ; Reference to witness
expert_ref = @legal_expert_witness                ; Reference to expert
employer = :                                      ; Deponent employer
position = :                                      ; Deponent position
relationship_to_case = :                          ; Relationship to case

{@legal_deposition}

; ───────────────────────────────────────────────────────────────────────────────
; Logistics
; ───────────────────────────────────────────────────────────────────────────────
{.logistics}
reporter_name = :                                 ; Court reporter name
reporter_firm = :                                 ; Reporting firm
videographer = ::if video_recorded = true         ; Videographer name
interpreter = :                                   ; Interpreter (if needed)
exhibits_to_use[] = :                             ; Exhibits to mark

{@legal_deposition}

; ───────────────────────────────────────────────────────────────────────────────
; Subpoena (if needed)
; ───────────────────────────────────────────────────────────────────────────────
{.subpoena}
subpoena_required = ?                             ; Subpoena needed
subpoena_issued = ?:if subpoena_required = true   ; Subpoena issued
subpoena_served = ?:if subpoena_required = true   ; Subpoena served
service_date = date:if subpoena_served = true     ; Date served
documents_requested = ?                           ; Documents subpoenaed
document_production_date = date:if documents_requested = true

{@legal_deposition}

; ───────────────────────────────────────────────────────────────────────────────
; Preparation
; ───────────────────────────────────────────────────────────────────────────────
{.preparation}
outline_prepared = ?                              ; Outline prepared
documents_reviewed = ?                            ; Documents reviewed
witness_prepared = ?:if our_role = defending      ; Witness prepared
preparation_date = date                           ; Prep session date

{@legal_deposition}

; ───────────────────────────────────────────────────────────────────────────────
; Outcome
; ───────────────────────────────────────────────────────────────────────────────
{.outcome}
deposition_taken = ?                              ; Deposition completed
actual_duration = :                               ; Actual duration
pages = ##:(0..)                                  ; Transcript pages
transcript_ordered = ?                            ; Transcript ordered
transcript_received = ?:if transcript_ordered = true
errata_deadline = date                            ; Errata deadline
errata_filed = ?                                  ; Errata filed
key_testimony = :                                 ; Summary of key testimony

{@legal_deposition}

; ═══════════════════════════════════════════════════════════════════════════════
; FILING DEADLINE
; ═══════════════════════════════════════════════════════════════════════════════
; Court filing deadline

{@legal_filing_deadline}
= @legal_calendar_event                           ; Inherits calendar event

; Required fields
filing_type = !(answer, appeal, brief, complaint, discovery_response, motion, notice, objection, petition, reply, response)

; ───────────────────────────────────────────────────────────────────────────────
; Deadline Calculation
; ───────────────────────────────────────────────────────────────────────────────
{.calculation}
trigger_date = date                               ; Date triggering deadline
trigger_event = :                                 ; Event that triggered
days_allowed = ##:(0..)                           ; Days from trigger
business_days = ?                                 ; Business days only
rule_reference = :                                ; Rule governing deadline
extended = ?                                      ; Deadline extended
extension_granted_by = ::if extended = true       ; Who granted extension
original_deadline = date:if extended = true       ; Original deadline

{@legal_filing_deadline}

; ───────────────────────────────────────────────────────────────────────────────
; Assignment
; ───────────────────────────────────────────────────────────────────────────────
{.assignment}
responsible_attorney = @legal_attorney            ; Responsible attorney
assigned_to = :                                   ; Person assigned
backup_attorney = @legal_attorney                 ; Backup attorney

{@legal_filing_deadline}

; ───────────────────────────────────────────────────────────────────────────────
; Completion
; ───────────────────────────────────────────────────────────────────────────────
{.completion}
completed = ?                                     ; Deadline met
completion_date = date:if completed = true        ; Date completed
filed_by = ::if completed = true                  ; Who filed
docket_number = ##:(0..):if completed = true      ; Docket entry number
confirmation_number = ::if completed = true       ; Filing confirmation

{@legal_filing_deadline}

; ───────────────────────────────────────────────────────────────────────────────
; Reminders
; ───────────────────────────────────────────────────────────────────────────────
{.reminders}
reminder_7_day = ?                                ; 7-day reminder sent
reminder_3_day = ?                                ; 3-day reminder sent
reminder_1_day = ?                                ; 1-day reminder sent
draft_due = date                                  ; Draft deadline
review_due = date                                 ; Review deadline

{@legal_filing_deadline}

; Risk level
risk_level = (critical, high, normal, routine)    ; Deadline importance

; ═══════════════════════════════════════════════════════════════════════════════
; CLIENT MEETING
; ═══════════════════════════════════════════════════════════════════════════════
; Client meeting calendar entry

{@legal_client_meeting}
= @legal_calendar_event                           ; Inherits calendar event

; Meeting type
meeting_type = !(case_update, initial_consultation, preparation, settlement_discussion, strategy)

; ───────────────────────────────────────────────────────────────────────────────
; Client Attendees
; ───────────────────────────────────────────────────────────────────────────────
{.clients[]}
client_ref = @legal_client                        ; Client reference
contact_name = :                                  ; Contact name
contact_title = :                                 ; Contact title
confirmed = ?                                     ; Attendance confirmed

{@legal_client_meeting}

; ───────────────────────────────────────────────────────────────────────────────
; Agenda
; ───────────────────────────────────────────────────────────────────────────────
{.agenda}
agenda_items[] = :                                ; Agenda items
documents_to_review[] = :                         ; Documents to discuss
decisions_needed[] = :                            ; Decisions required
materials_sent = ?                                ; Materials sent to client
materials_sent_date = date:if materials_sent = true

{@legal_client_meeting}

; ───────────────────────────────────────────────────────────────────────────────
; Billing
; ───────────────────────────────────────────────────────────────────────────────
{.billing}
billable = ?                                      ; Meeting is billable
estimated_hours = #:(0..)                         ; Estimated hours
time_entry_created = ?:if billable = true         ; Time entry created
no_charge = ?                                     ; No charge meeting
no_charge_reason = ::if no_charge = true          ; Why no charge

{@legal_client_meeting}

; ───────────────────────────────────────────────────────────────────────────────
; Follow-up
; ───────────────────────────────────────────────────────────────────────────────
{.follow_up}
meeting_notes = :                                 ; Meeting notes/summary
action_items[] = :                                ; Action items
next_meeting_scheduled = ?                        ; Next meeting set
next_meeting_date = date:if next_meeting_scheduled = true
follow_up_letter_sent = ?                         ; Follow-up letter sent

{@legal_client_meeting}


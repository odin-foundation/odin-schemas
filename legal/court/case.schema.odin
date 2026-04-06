; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Court Case Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Court case information and management for litigation tracking. Covers
; federal and state civil cases, bankruptcy, and criminal case references
; including parties, claims, docket entries, and case status tracking.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as legal
@import "../../common/types.schema.odin" as common

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.legal.court.case"
version = "1.0.0"
title = "Court Case Schema"
description = "Court case information and tracking"

{$derivation}
source[0].authority = "Administrative Office of the U.S. Courts"
source[0].citation = "Federal Court Statistics and Case Management"
source[0].url = "https://www.uscourts.gov/"

source[1].authority = "Public Access to Court Electronic Records"
source[1].citation = "PACER Case Data Specification"
source[1].url = "https://pacer.uscourts.gov/"

source[2].authority = "State Court Administration"
source[2].citation = "Case Management Standards"
source[2].url = "varies by jurisdiction"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Case schema derived from federal and state court case management systems"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial court case schema"
changelog[0].rationale = "Comprehensive case tracking structure"

; ═══════════════════════════════════════════════════════════════════════════════
; COURT CASE
; ═══════════════════════════════════════════════════════════════════════════════
; Primary court case record

{@court_case}
; Required fields first
case_number = !:                                  ; Court-assigned case number
case_type = !(administrative, appellate, bankruptcy, civil, criminal, family, probate)
court_ref = !@legal_court                         ; Reference to court
filed_date = !date                                ; Case filing date

; Case identification
case_id = :                                       ; Internal case identifier
pacer_case_id = :                                 ; PACER case ID (federal)
state_case_id = :                                 ; State case ID

; ───────────────────────────────────────────────────────────────────────────────
; Case Caption
; ───────────────────────────────────────────────────────────────────────────────
{.caption}
short_title = :                                   ; Short case title
full_caption = :                                  ; Full case caption
plaintiffs_caption = :                            ; Plaintiffs as named
defendants_caption = :                            ; Defendants as named

{@court_case}

; ───────────────────────────────────────────────────────────────────────────────
; Court Assignment
; ───────────────────────────────────────────────────────────────────────────────
{.assignment}
judge_ref = @legal_judge                          ; Assigned judge
magistrate_ref = @legal_judge                     ; Assigned magistrate
division = :                                      ; Court division
department = :                                    ; Court department
courtroom = :                                     ; Assigned courtroom

{@court_case}

; ───────────────────────────────────────────────────────────────────────────────
; Case Classification
; ───────────────────────────────────────────────────────────────────────────────
{.classification}
; Federal classifications
nature_of_suit = :                                ; Nature of suit code
jurisdiction_basis = (diversity, federal_question, supplemental)
demand_amount = #$:(0..)                          ; Amount in controversy
jury_demand = (both, defendant, none, plaintiff)  ; Jury demand
class_action = ?                                  ; Class action case
multi_district = ?                                ; MDL case
mdl_number = ::if multi_district = true           ; MDL number

{@court_case}

; State classifications
{.classification.state}
case_category = :                                 ; State case category
case_type_code = :                                ; State type code
complexity = (complex, expedited, standard)       ; Case complexity

{@court_case}

; ───────────────────────────────────────────────────────────────────────────────
; Parties
; ───────────────────────────────────────────────────────────────────────────────
{.parties[]}
party_name = :                                    ; Party name
party_type = (appellee, appellant, claimant, counter_claimant, counter_defendant, cross_claimant, cross_defendant, defendant, intervenor, petitioner, plaintiff, respondent, third_party_defendant, third_party_plaintiff)
party_ref = @legal_party                          ; Reference to party record
represented = ?                                   ; Has representation
counsel[] = @legal_opposing_counsel               ; Party's counsel
pro_se = ?:if represented = false                 ; Proceeding pro se
date_added = date                                 ; Date added to case
date_terminated = date                            ; Date terminated from case
active = ?                                        ; Currently active party

{@court_case}

; ───────────────────────────────────────────────────────────────────────────────
; Claims
; ───────────────────────────────────────────────────────────────────────────────
claims[] = @case_claim                            ; Claims in case

{@court_case}

; ───────────────────────────────────────────────────────────────────────────────
; Key Dates
; ───────────────────────────────────────────────────────────────────────────────
{.key_dates}
complaint_filed = date                            ; Complaint filing date
summons_issued = date                             ; Summons issued date
service_completed = date                          ; Service completion date
answer_due = date                                 ; Answer due date
answer_filed = date                               ; Answer filed date
scheduling_conference = date                      ; Scheduling conference date
scheduling_order = date                           ; Scheduling order date
discovery_cutoff = date                           ; Discovery deadline
expert_disclosure = date                          ; Expert disclosure deadline
dispositive_motion_deadline = date                ; Dispositive motion deadline
pretrial_conference = date                        ; Pretrial conference date
trial_date = date                                 ; Trial date
trial_ready = date                                ; Trial ready date

{@court_case}

; ───────────────────────────────────────────────────────────────────────────────
; Docket
; ───────────────────────────────────────────────────────────────────────────────
docket_entries[] = @docket_entry                  ; Docket entries
last_docket_date = date                           ; Last docket activity
docket_entry_count = ##:(0..)                     ; Total docket entries

{@court_case}

; ───────────────────────────────────────────────────────────────────────────────
; Pending Motions
; ───────────────────────────────────────────────────────────────────────────────
{.pending_motions[]}
motion_type = :                                   ; Type of motion
docket_number = ##:(0..)                          ; Docket entry number
filed_by = :                                      ; Party who filed
filing_date = date                                ; Filing date
response_due = date                               ; Response deadline
response_filed = ?                                ; Response filed
reply_due = date                                  ; Reply deadline
reply_filed = ?                                   ; Reply filed
hearing_scheduled = ?                             ; Hearing scheduled
hearing_date = date:if hearing_scheduled = true   ; Hearing date
status = (denied, granted, granted_in_part, moot, pending, withdrawn)

{@court_case}

; ───────────────────────────────────────────────────────────────────────────────
; Hearings
; ───────────────────────────────────────────────────────────────────────────────
hearings[] = @court_hearing                       ; Scheduled hearings

{@court_case}

; ───────────────────────────────────────────────────────────────────────────────
; Related Cases
; ───────────────────────────────────────────────────────────────────────────────
{.related_cases[]}
case_number = :                                   ; Related case number
court = :                                         ; Court of related case
relationship = (companion, consolidated, lead, member, related, severed, transferred_from, transferred_to)
consolidation_date = date:if relationship = consolidated | relationship = lead | relationship = member

{@court_case}

; ───────────────────────────────────────────────────────────────────────────────
; Outcome
; ───────────────────────────────────────────────────────────────────────────────
{.outcome}
disposition = (consent_judgment, default_judgment, dismissed_with_prejudice, dismissed_without_prejudice, judgment_on_pleadings, judgment_on_verdict, other, remanded, settled, summary_judgment, transferred, voluntary_dismissal)
disposition_date = date                           ; Date of disposition
prevailing_party = (defendant, mixed, plaintiff)  ; Prevailing party
judgment_amount = #$                              ; Judgment amount
attorneys_fees_awarded = #$                       ; Attorney fees
costs_awarded = #$                                ; Costs
prejudgment_interest = #$                         ; Prejudgment interest
post_judgment_interest_rate = #:(0..100)          ; Post-judgment interest rate

{@court_case}

; ───────────────────────────────────────────────────────────────────────────────
; Appeal
; ───────────────────────────────────────────────────────────────────────────────
{.appeal}
appeal_pending = ?                                ; Appeal pending
appeal_filed_by = ::if appeal_pending = true      ; Who filed appeal
notice_of_appeal_date = date:if appeal_pending = true
appellate_court = ::if appeal_pending = true      ; Appellate court
appellate_case_number = ::if appeal_pending = true
stay_pending_appeal = ?:if appeal_pending = true  ; Judgment stayed
appeal_outcome = (affirmed, dismissed, remanded, reversed, reversed_in_part):if appeal_pending = true
appeal_decision_date = date

{@court_case}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (administratively_closed, appeal, closed, discovery, motion_practice, pending, post_judgment, pretrial, reopened, stayed, trial)
status_date = date                                ; Date of current status
closed_date = date:if status = closed             ; Case closed date

; ═══════════════════════════════════════════════════════════════════════════════
; CASE CLAIM
; ═══════════════════════════════════════════════════════════════════════════════
; Claim or cause of action in case

{@case_claim}
; Required fields first
claim_number = !##:(1..)                          ; Claim number
claim_description = !:                            ; Claim description

; Claim identification
claim_id = :                                      ; Unique identifier

; ───────────────────────────────────────────────────────────────────────────────
; Claim Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
legal_basis = :                                   ; Legal basis (statute, common law)
statute_citation = :                              ; Statutory citation
against_party = :                                 ; Party claim is against
by_party = :                                      ; Party asserting claim
damages_type = (actual, compensatory, consequential, incidental, liquidated, nominal, punitive, statutory)
damages_amount = #$:(0..)                         ; Damages claimed
equitable_relief = ?                              ; Seeking equitable relief
equitable_relief_description = ::if equitable_relief = true

{@case_claim}

; Status
status = (dismissed, pending, settled, summary_judgment, verdict)
disposition_date = date:if status != pending      ; Date resolved
disposition_type = ::if status != pending         ; How resolved

; ═══════════════════════════════════════════════════════════════════════════════
; DOCKET ENTRY
; ═══════════════════════════════════════════════════════════════════════════════
; Court docket entry

{@docket_entry}
; Required fields first
entry_date = !date                                ; Entry date
entry_number = !##:(0..)                          ; Docket number
entry_text = !:                                   ; Entry description

; Entry identification
entry_id = :                                      ; Unique identifier

; ───────────────────────────────────────────────────────────────────────────────
; Entry Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
entry_type = (answer, brief, complaint, discovery, motion, notice, order, other, subpoena, summons)
filed_by = :                                      ; Filing party
filing_method = (clerk, electronic, in_person, mail)
pages = ##:(0..)                                  ; Page count
attachments_count = ##:(0..)                      ; Number of attachments

{@docket_entry}

; ───────────────────────────────────────────────────────────────────────────────
; Related Entries
; ───────────────────────────────────────────────────────────────────────────────
{.related}
in_response_to = ##:(0..)                         ; Entry this responds to
related_entries[] = ##:(0..)                      ; Related entry numbers
motion_granted = ?                                ; If motion, was it granted
order_entered = ?                                 ; Order entered

{@docket_entry}

; ───────────────────────────────────────────────────────────────────────────────
; Document
; ───────────────────────────────────────────────────────────────────────────────
{.document}
document_available = ?                            ; Document available
document_url = ::if document_available = true     ; Document URL (PACER, etc.)
restricted = ?                                    ; Restricted access
restriction_type = (in_camera, sealed, sidebar):if restricted = true
free_look = ?                                     ; Free look available (PACER)

{@docket_entry}

; ───────────────────────────────────────────────────────────────────────────────
; Deadlines Created
; ───────────────────────────────────────────────────────────────────────────────
{.deadlines_created[]}
deadline_type = :                                 ; Type of deadline
due_date = date                                   ; Due date
party_responsible = :                             ; Responsible party
deadline_ref = @legal_deadline                    ; Reference to deadline

{@docket_entry}

; ═══════════════════════════════════════════════════════════════════════════════
; COURT HEARING
; ═══════════════════════════════════════════════════════════════════════════════
; Scheduled court hearing

{@court_hearing}
; Required fields first
hearing_date = !date                              ; Hearing date
hearing_time = !time                              ; Hearing time
hearing_type = !(argument, conference, evidentiary, motion, pretrial, scheduling, settlement, status, trial)

; Hearing identification
hearing_id = :                                    ; Unique identifier

; ───────────────────────────────────────────────────────────────────────────────
; Hearing Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
description = :                                   ; Hearing description
estimated_duration = :                            ; Estimated duration
courtroom = :                                     ; Courtroom location
judge_ref = @legal_judge                          ; Judge presiding
virtual_hearing = ?                               ; Virtual/remote hearing
video_platform = ::if virtual_hearing = true      ; Video platform
meeting_link = ::if virtual_hearing = true        ; Meeting link

{@court_hearing}

; ───────────────────────────────────────────────────────────────────────────────
; Related Matters
; ───────────────────────────────────────────────────────────────────────────────
{.related}
motion_number = ##:(0..)                          ; Related motion docket number
motion_type = :                                   ; Type of motion
case_ref = @court_case                            ; Reference to case

{@court_hearing}

; ───────────────────────────────────────────────────────────────────────────────
; Attendance
; ───────────────────────────────────────────────────────────────────────────────
{.attendance}
our_attorneys[] = :                               ; Our attending attorneys
client_attendance_required = ?                    ; Client must attend
witnesses[] = :                                   ; Witnesses to attend
interpreter_needed = ?                            ; Interpreter required
interpreter_language = ::if interpreter_needed = true

{@court_hearing}

; ───────────────────────────────────────────────────────────────────────────────
; Preparation
; ───────────────────────────────────────────────────────────────────────────────
{.preparation}
brief_due = date                                  ; Brief/memo due date
brief_filed = ?                                   ; Brief filed
exhibits_due = date                               ; Exhibits due date
exhibits_filed = ?                                ; Exhibits filed
witness_prep_date = date                          ; Witness prep date
moot_court_scheduled = ?                          ; Moot court scheduled

{@court_hearing}

; ───────────────────────────────────────────────────────────────────────────────
; Outcome
; ───────────────────────────────────────────────────────────────────────────────
{.outcome}
hearing_held = ?                                  ; Hearing was held
continued = ?                                     ; Hearing continued
continued_to = date:if continued = true           ; New hearing date
result = :                                        ; Hearing result
order_issued = ?                                  ; Order issued
order_date = date:if order_issued = true          ; Order date
transcript_ordered = ?                            ; Transcript ordered
transcript_received = ?:if transcript_ordered = true

{@court_hearing}

; Status
status = (cancelled, completed, confirmed, continued, pending, vacated)


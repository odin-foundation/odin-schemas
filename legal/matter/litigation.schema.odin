; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Litigation Matter Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Litigation matters for civil cases (state/federal), commercial disputes,
; employment, personal injury, and class actions. Covers claims, litigation
; phases, discovery management, settlement negotiations, trial preparation,
; and alternative dispute resolution (arbitration/mediation).
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as legal
@import "../../common/types.schema.odin" as common

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.legal.matter.litigation"
version = "1.0.0"
title = "Litigation Matter Schema"
description = "Civil litigation and dispute resolution matters"

{$derivation}
source[0].authority = "Federal Rules of Civil Procedure"
source[0].citation = "FRCP Rules 1-86"
source[0].url = "https://www.uscourts.gov/rules-policies/current-rules-practice-procedure/federal-rules-civil-procedure"

source[1].authority = "Federal Rules of Evidence"
source[1].citation = "FRE Rules 101-1103"
source[1].url = "https://www.uscourts.gov/rules-policies/current-rules-practice-procedure/federal-rules-evidence"

source[2].authority = "American Arbitration Association"
source[2].citation = "Commercial Arbitration Rules"
source[2].url = "https://www.adr.org/Rules"

source[3].authority = "Uniform Task-Based Management System"
source[3].citation = "UTBMS Litigation Code Set"
source[3].url = "https://ledes.org/utbms/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Litigation schema derived from FRCP, FRE, and UTBMS litigation phases"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial litigation matter schema"
changelog[0].rationale = "Comprehensive litigation tracking structure"

; ═══════════════════════════════════════════════════════════════════════════════
; LITIGATION MATTER
; ═══════════════════════════════════════════════════════════════════════════════
; Primary litigation matter record

{@litigation_matter}
; Required fields first
case_type = !(antitrust, breach_of_contract, class_action, commercial, construction, employment, environmental, insurance, intellectual_property, personal_injury, product_liability, professional_liability, real_property, securities, tort, trust_estate)
client_position = !(cross_claimant, cross_defendant, defendant, intervenor, petitioner, plaintiff, respondent, third_party_defendant)
matter_name = !:                                  ; Matter name/caption
open_date = !date                                 ; Date matter opened

; Matter identification
matter_id = :                                     ; Internal matter identifier
client_matter_id = :                              ; Client's reference number
ledes_matter_id = :                               ; LEDES matter ID for billing

; Client reference
client_ref = @legal_client                        ; Reference to client record

; ───────────────────────────────────────────────────────────────────────────────
; Case Information
; ───────────────────────────────────────────────────────────────────────────────
{.case}
court_ref = @legal_court                          ; Court information
case_number = :                                   ; Court case number
case_caption = :                                  ; Full case caption
judge_ref = @legal_judge                          ; Assigned judge

{@litigation_matter}

; Filing dates
{.case.dates}
complaint_filed = date                            ; Date complaint filed
answer_due = date                                 ; Answer due date
answer_filed = date                               ; Date answer filed
service_date = date                               ; Date of service

{@litigation_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Claims and Causes of Action
; ───────────────────────────────────────────────────────────────────────────────
claims[] = @litigation_claim                      ; Claims/causes of action

{@litigation_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Parties
; ───────────────────────────────────────────────────────────────────────────────
{.parties}
plaintiffs[] = @legal_party                       ; Plaintiff parties
defendants[] = @legal_party                       ; Defendant parties
third_parties[] = @legal_party                    ; Third-party defendants
intervenors[] = @legal_party                      ; Intervenors

{@litigation_matter}

; Counsel
{.counsel}
our_team[] = @legal_attorney                      ; Our attorneys on matter
opposing_counsel[] = @legal_opposing_counsel      ; Opposing counsel
co_counsel[] = @legal_attorney                    ; Co-counsel

{@litigation_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Jurisdiction and Venue
; ───────────────────────────────────────────────────────────────────────────────
{.jurisdiction}
jurisdiction_type = (federal, state)              ; Type of jurisdiction
jurisdictional_basis = (diversity, federal_question, supplemental)
diversity_amount_satisfied = ?:if jurisdictional_basis = diversity
venue_proper = ?                                  ; Venue is proper
venue_contested = ?                               ; Venue being contested

{@litigation_matter}

; Federal specifics
{.jurisdiction.federal}
circuit = :(2):if jurisdiction_type = federal     ; Circuit (1-11, DC, Fed)
district = ::if jurisdiction_type = federal       ; District name
division = ::if jurisdiction_type = federal       ; Division within district

{@litigation_matter}

; State specifics
{.jurisdiction.state}
state = :(2):if jurisdiction_type = state         ; State code
county = ::if jurisdiction_type = state           ; County
court_level = (appellate, supreme, trial):if jurisdiction_type = state

{@litigation_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Current Phase (UTBMS-aligned)
; ───────────────────────────────────────────────────────────────────────────────
phase = @litigation_phase                         ; Current litigation phase

{@litigation_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Discovery Status
; ───────────────────────────────────────────────────────────────────────────────
{.discovery}
discovery_commenced = ?                           ; Discovery has begun
discovery_deadline = date                         ; Discovery cutoff date
written_discovery_complete = ?                    ; Written discovery done
depositions_complete = ?                          ; Depositions done
expert_discovery_complete = ?                     ; Expert discovery done

{@litigation_matter}

; Discovery counts
{.discovery.counts}
interrogatories_served = ##:(0..)                 ; Number served
interrogatories_received = ##:(0..)               ; Number received
document_requests_served = ##:(0..)               ; RFPs served
document_requests_received = ##:(0..)             ; RFPs received
admissions_served = ##:(0..)                      ; RFAs served
admissions_received = ##:(0..)                    ; RFAs received
depositions_taken = ##:(0..)                      ; Depositions we took
depositions_defended = ##:(0..)                   ; Depositions we defended

{@litigation_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Key Dates and Deadlines
; ───────────────────────────────────────────────────────────────────────────────
{.key_dates}
scheduling_order_date = date                      ; Date of scheduling order
discovery_cutoff = date                           ; Discovery deadline
expert_designation_deadline = date                ; Expert designation due
expert_discovery_cutoff = date                    ; Expert discovery deadline
dispositive_motion_deadline = date                ; Dispositive motion deadline
pretrial_conference = date                        ; Pretrial conference date
trial_date = date                                 ; Scheduled trial date
trial_ready = ?                                   ; Case is trial ready

{@litigation_matter}

; Deadlines list
deadlines[] = @legal_deadline                     ; All matter deadlines

{@litigation_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Motions
; ───────────────────────────────────────────────────────────────────────────────
{.motions[]}
motion_type = (compel, dismiss, judgment_pleadings, preliminary_injunction, protective_order, reconsideration, sanctions, stay, strike, summary_judgment, tro)
filed_by = (defendant, plaintiff, third_party)    ; Party who filed
filing_date = date                                ; Date filed
response_due = date                               ; Response deadline
response_filed = date                             ; Date response filed
reply_due = date                                  ; Reply deadline
reply_filed = date                                ; Date reply filed
hearing_date = date                               ; Hearing date
ruling = (denied, granted, granted_in_part, pending, withdrawn)
ruling_date = date:if ruling != pending           ; Date of ruling

{@litigation_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Settlement
; ───────────────────────────────────────────────────────────────────────────────
{.settlement}
settlement_discussions = ?                        ; Settlement being discussed
mediation_ordered = ?                             ; Court-ordered mediation
mediation_date = date:if mediation_ordered = true ; Mediation date
mediator = ::if mediation_ordered = true          ; Mediator name
settlement_demand = #$                            ; Our settlement demand
settlement_offer = #$                             ; Opposing settlement offer
settled = ?                                       ; Case has settled
settlement_amount = #$:if settled = true          ; Settlement amount
settlement_date = date:if settled = true          ; Date settled
settlement_confidential = ?:if settled = true     ; Settlement is confidential

{@litigation_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Damages
; ───────────────────────────────────────────────────────────────────────────────
{.damages}
compensatory_claimed = #$:(0..)                   ; Compensatory damages claimed
punitive_claimed = #$:(0..)                       ; Punitive damages claimed
attorneys_fees_claimed = #$:(0..)                 ; Attorney fees claimed
prejudgment_interest_claimed = ?                  ; Seeking prejudgment interest
total_claimed = #$:(0..)                          ; Total damages claimed

{@litigation_matter}

; Awarded (if judgment)
{.damages.awarded}
compensatory = #$                                 ; Compensatory awarded
punitive = #$                                     ; Punitive awarded
attorneys_fees = #$                               ; Attorney fees awarded
prejudgment_interest = #$                         ; Prejudgment interest awarded
costs = #$                                        ; Costs awarded
total = #$                                        ; Total judgment

{@litigation_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Insurance
; ───────────────────────────────────────────────────────────────────────────────
{.insurance}
coverage_available = ?                            ; Insurance coverage exists
policy_ref = @legal_insurance_ref                 ; Policy reference
coverage_disputed = ?                             ; Coverage in dispute
reservation_of_rights = ?                         ; Insurer reserved rights
tender_date = date                                ; Date tendered to insurer
tender_accepted = ?                               ; Tender accepted
defense_counsel_retained = ?                      ; Defense counsel assigned
indemnity_available = ?                           ; Indemnity available

{@litigation_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Trial
; ───────────────────────────────────────────────────────────────────────────────
{.trial}
trial_type = (bench, jury)                        ; Type of trial
trial_length_days = ##:(1..)                      ; Estimated trial length
trial_started = date                              ; Trial start date
trial_ended = date                                ; Trial end date
verdict_date = date                               ; Date of verdict
verdict = (defense, mixed, plaintiff)             ; Verdict outcome
judgment_entered = date                           ; Date judgment entered

{@litigation_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Appeal
; ───────────────────────────────────────────────────────────────────────────────
{.appeal}
appeal_pending = ?                                ; Appeal is pending
appeal_filed_by = (defendant, plaintiff):if appeal_pending = true
notice_of_appeal_date = date:if appeal_pending = true
appellate_court = ::if appeal_pending = true      ; Appellate court name
appellate_case_number = ::if appeal_pending = true
briefing_complete = ?:if appeal_pending = true    ; Briefing completed
oral_argument_date = date:if appeal_pending = true
decision_date = date:if appeal_pending = true     ; Appellate decision date
outcome = (affirmed, dismissed, remanded, reversed, reversed_in_part):if appeal_pending = true

{@litigation_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Related Matters
; ───────────────────────────────────────────────────────────────────────────────
{.related_matters[]}
related_matter_id = :                             ; Related matter ID
relationship = (consolidated, cross_claim, related, third_party)
description = :                                   ; Relationship description

{@litigation_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = @legal_matter_status                     ; Matter status

; ═══════════════════════════════════════════════════════════════════════════════
; LITIGATION CLAIM
; ═══════════════════════════════════════════════════════════════════════════════
; Individual claim or cause of action

{@litigation_claim}
; Required fields first
claim_number = !##:(1..)                          ; Claim number in complaint
claim_type = !:                                   ; Type of claim (e.g., "Breach of Contract")

; Claim details
{.details}
legal_basis = :                                   ; Legal basis (statute, common law)
statute_citation = :                              ; Statutory citation if applicable
elements[] = :                                    ; Elements to prove
factual_basis = :                                 ; Factual summary

{@litigation_claim}

; Parties
claimant = :                                      ; Party asserting claim
against = :                                       ; Party claim is against

; Damages for this claim
damages_sought = #$:(0..)                         ; Damages sought for claim
damages_type = (actual, consequential, incidental, punitive, statutory)

; Status
claim_status = (dismissed, pending, settled, verdict)
dismissal_date = date:if claim_status = dismissed ; Date dismissed
dismissal_basis = ::if claim_status = dismissed   ; Basis for dismissal

; ═══════════════════════════════════════════════════════════════════════════════
; LITIGATION PHASE
; ═══════════════════════════════════════════════════════════════════════════════
; Litigation phase tracking (UTBMS-aligned)

{@litigation_phase}
; Current phase (UTBMS Litigation Phases L100-L590)
current_phase = !(L100_case_assessment, L110_development_strategy, L120_fact_investigation, L130_development_themes, L140_case_management, L200_pretrial_pleadings, L210_written_discovery, L220_document_production, L230_depositions, L240_experts, L250_discovery_motions, L300_dispositive_motions, L400_trial_prep, L410_trial, L500_appeal, L590_post_trial)

; Phase details
phase_start_date = date                           ; When phase started
phase_end_date = date                             ; When phase ended (if complete)
phase_complete = ?                                ; Phase is complete

; Phase-specific status notes
phase_notes = :                                   ; Notes about current phase

; ═══════════════════════════════════════════════════════════════════════════════
; ARBITRATION
; ═══════════════════════════════════════════════════════════════════════════════
; Arbitration proceeding (AAA, JAMS, etc.)

{@litigation_arbitration}
; Required fields first
arbitration_forum = !(aaa, finra, icc, icsid, jams, private, uncitral)
arbitration_type = !(binding, non_binding)

; Arbitration identification
case_number = :                                   ; Arbitration case number
matter_ref = @litigation_matter                   ; Related litigation matter

; ───────────────────────────────────────────────────────────────────────────────
; Arbitration Agreement
; ───────────────────────────────────────────────────────────────────────────────
{.agreement}
contract_date = date                              ; Date of underlying contract
arbitration_clause_location = :                   ; Location in contract
governing_rules = :                               ; Governing arbitration rules
seat = :                                          ; Seat of arbitration
governing_law = :                                 ; Governing substantive law

{@litigation_arbitration}

; ───────────────────────────────────────────────────────────────────────────────
; Arbitrators
; ───────────────────────────────────────────────────────────────────────────────
{.arbitrators}
panel_size = ##:(1..3)                            ; Number of arbitrators
selection_method = (administered, party_selected, sole)

{@litigation_arbitration}

{.arbitrators.arbitrator[]}
name = :                                          ; Arbitrator name
selected_by = (claimant, joint, respondent, tribunal)
appointed_date = date                             ; Date appointed
chair = ?                                         ; Is chair of panel

{@litigation_arbitration}

; ───────────────────────────────────────────────────────────────────────────────
; Proceedings
; ───────────────────────────────────────────────────────────────────────────────
{.proceedings}
demand_date = date                                ; Date demand filed
response_due = date                               ; Response deadline
response_filed = date                             ; Date response filed
preliminary_hearing = date                        ; Preliminary hearing date
discovery_allowed = ?                             ; Discovery permitted
discovery_deadline = date:if discovery_allowed = true
hearing_dates[] = date                            ; Hearing dates
post_hearing_briefs_due = date                    ; Brief deadline

{@litigation_arbitration}

; ───────────────────────────────────────────────────────────────────────────────
; Award
; ───────────────────────────────────────────────────────────────────────────────
{.award}
award_date = date                                 ; Date of award
award_amount = #$                                 ; Amount awarded
prevailing_party = (claimant, mixed, respondent)  ; Who prevailed
reasoned_award = ?                                ; Award includes reasons
fees_awarded = #$:(0..)                           ; Arbitration fees awarded
attorneys_fees_awarded = #$:(0..)                 ; Attorney fees awarded
confirmation_sought = ?                           ; Seeking confirmation
confirmation_court = :                            ; Court for confirmation
confirmation_date = date                          ; Date confirmed

{@litigation_arbitration}

; Status
status = (award_issued, closed, discovery, hearing, pending, preliminary)

; ═══════════════════════════════════════════════════════════════════════════════
; MEDIATION
; ═══════════════════════════════════════════════════════════════════════════════
; Mediation proceeding

{@litigation_mediation}
; Required fields first
mediation_type = !(court_ordered, mandatory, voluntary)

; Mediation identification
matter_ref = @litigation_matter                   ; Related litigation matter

; ───────────────────────────────────────────────────────────────────────────────
; Mediator
; ───────────────────────────────────────────────────────────────────────────────
{.mediator}
name = :                                          ; Mediator name
organization = :                                  ; Mediation organization (JAMS, etc.)
phone = *@phone                                   ; Mediator phone
email = *@email                                   ; Mediator email
hourly_rate = #$:(0..)                            ; Mediator rate

{@litigation_mediation}

; ───────────────────────────────────────────────────────────────────────────────
; Scheduling
; ───────────────────────────────────────────────────────────────────────────────
{.scheduling}
order_date = date:if mediation_type = court_ordered
deadline = date                                   ; Deadline to complete mediation
scheduled_date = date                             ; Mediation session date
location = :                                      ; Mediation location
virtual = ?                                       ; Virtual mediation
duration_hours = #:(0..)                          ; Session duration

{@litigation_mediation}

; ───────────────────────────────────────────────────────────────────────────────
; Briefs
; ───────────────────────────────────────────────────────────────────────────────
{.briefs}
brief_due = date                                  ; Mediation brief due date
our_brief_filed = date                            ; Date we filed brief
confidential_brief = ?                            ; Confidential brief filed

{@litigation_mediation}

; ───────────────────────────────────────────────────────────────────────────────
; Outcome
; ───────────────────────────────────────────────────────────────────────────────
{.outcome}
result = (continued, full_settlement, impasse, partial_settlement, pending)
settlement_amount = #$:if result = full_settlement | result = partial_settlement
settlement_date = date:if result = full_settlement | result = partial_settlement
issues_resolved = ::if result = partial_settlement
issues_remaining = ::if result = partial_settlement | result = impasse

{@litigation_mediation}

; Costs
{.costs}
mediator_fees = #$:(0..)                          ; Total mediator fees
our_share = #$:(0..)                              ; Our share of fees
paid = ?                                          ; Fees paid

{@litigation_mediation}


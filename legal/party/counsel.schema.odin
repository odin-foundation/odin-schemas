; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Legal Counsel Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Opposing counsel and co-counsel tracking for legal matters including
; opposing, co-counsel, local, and special counsel roles. Covers attorney
; bar admissions, firm details, matter assignments, and communication
; preferences.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as legal
@import "../../common/types.schema.odin" as common

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.legal.party.counsel"
version = "1.0.0"
title = "Legal Counsel Schema"
description = "Opposing and co-counsel tracking"

{$derivation}
source[0].authority = "American Bar Association"
source[0].citation = "Model Rules of Professional Conduct"
source[0].url = "https://www.americanbar.org/groups/professional_responsibility/publications/model_rules_of_professional_conduct/"

source[1].authority = "Federal Rules of Civil Procedure"
source[1].citation = "Rule 11 - Signing Pleadings"
source[1].url = "https://www.uscourts.gov/rules-policies/current-rules-practice-procedure/federal-rules-civil-procedure"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Counsel schema derived from professional responsibility rules"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial legal counsel schema"
changelog[0].rationale = "Counsel tracking structure"

; ═══════════════════════════════════════════════════════════════════════════════
; OPPOSING COUNSEL
; ═══════════════════════════════════════════════════════════════════════════════
; Opposing counsel in a legal matter

{@legal_opposing_counsel}
; Required fields first
attorney_name = :                                ; Attorney name
party_represented = :                            ; Party they represent

; Counsel identification
counsel_id = :                                    ; Unique identifier

; ───────────────────────────────────────────────────────────────────────────────
; Attorney Details
; ───────────────────────────────────────────────────────────────────────────────
{.attorney}
license = @license_credential                     ; Bar admission license
title = :                                         ; Title (Partner, Associate, etc.)

{@legal_opposing_counsel}

; Contact information
{.attorney.contact}
phone = *@phone                                   ; Direct phone
email = *@email                                   ; Email
assistant_name = :                                ; Assistant name
assistant_phone = *@phone                         ; Assistant phone
assistant_email = *@email                         ; Assistant email

{@legal_opposing_counsel}

; ───────────────────────────────────────────────────────────────────────────────
; Firm Information
; ───────────────────────────────────────────────────────────────────────────────
{.firm}
firm_name = :                                     ; Law firm name
firm_address = @address                           ; Firm address
firm_phone = *@phone                              ; Firm main phone
firm_fax = *@phone                                ; Firm fax
firm_website = :                                  ; Firm website

{@legal_opposing_counsel}

; ───────────────────────────────────────────────────────────────────────────────
; Team Members (Other attorneys at firm on matter)
; ───────────────────────────────────────────────────────────────────────────────
{.team[]}
attorney_name = :                                 ; Team member name
role = (associate, lead, of_counsel, paralegal, partner)
license = @license_credential                     ; Bar admission license
phone = *@phone                                   ; Phone
email = *@email                                   ; Email

{@legal_opposing_counsel}

; ───────────────────────────────────────────────────────────────────────────────
; Court Admissions
; ───────────────────────────────────────────────────────────────────────────────
{.admissions[]}
court = :                                         ; Court name
license = @license_credential                     ; Court admission license
pro_hac_vice = ?                                  ; Admitted pro hac vice
phv_date = date:if pro_hac_vice = true            ; PHV admission date
local_counsel = ::if pro_hac_vice = true          ; Local counsel name

{@legal_opposing_counsel}

; ───────────────────────────────────────────────────────────────────────────────
; Communication Preferences
; ───────────────────────────────────────────────────────────────────────────────
{.preferences}
preferred_contact = (email, fax, mail, phone)     ; Preferred contact method
accepts_electronic_service = ?                    ; Accepts e-service
efiling_address = *@email                         ; E-filing email
courtesy_copies_requested = ?                     ; Wants courtesy copies
special_instructions = :                          ; Special instructions

{@legal_opposing_counsel}

; ───────────────────────────────────────────────────────────────────────────────
; Notes
; ───────────────────────────────────────────────────────────────────────────────
{.notes}
negotiation_style = :                             ; Negotiation style notes
prior_dealings = ?                                ; Prior dealings with
prior_matters[] = :                               ; Prior matters
reputation_notes = :                              ; Reputation notes
conflict_check_needed = ?                         ; Need conflict check

{@legal_opposing_counsel}

; Status
active = ?                                        ; Currently active on matter
substituted = ?                                   ; Has been substituted
substitution_date = date:if substituted = true    ; Substitution date
successor_counsel = ::if substituted = true       ; Successor counsel name

; ═══════════════════════════════════════════════════════════════════════════════
; CO-COUNSEL
; ═══════════════════════════════════════════════════════════════════════════════
; Co-counsel working on same side of matter

{@legal_co_counsel}
= @legal_opposing_counsel                         ; Inherits opposing counsel fields

; Co-counsel specific fields
co_counsel_type = (co_counsel, local_counsel, referral, special_counsel)

; ───────────────────────────────────────────────────────────────────────────────
; Arrangement
; ───────────────────────────────────────────────────────────────────────────────
{.arrangement}
lead_counsel = ?                                  ; Is lead counsel
responsibility = :                                ; Areas of responsibility
fee_sharing = ?                                   ; Fee sharing arrangement
fee_split_percentage = #:(0..100):if fee_sharing = true
referral_fee = ?                                  ; Referral fee arrangement
referral_fee_percentage = #:(0..100):if referral_fee = true

{@legal_co_counsel}

; ───────────────────────────────────────────────────────────────────────────────
; Communication
; ───────────────────────────────────────────────────────────────────────────────
{.communication}
include_on_correspondence = ?                     ; Include on correspondence
include_on_filings = ?                            ; Include on court filings
joint_defense_agreement = ?                       ; JDA in place
jda_date = date:if joint_defense_agreement = true ; JDA date
common_interest_agreement = ?                     ; CIA in place
cia_date = date:if common_interest_agreement = true

{@legal_co_counsel}

; Status
engagement_date = date                            ; Date engaged
termination_date = date                           ; Date terminated

; ═══════════════════════════════════════════════════════════════════════════════
; EXPERT WITNESS
; ═══════════════════════════════════════════════════════════════════════════════
; Expert witness for litigation

{@legal_expert_witness}
; Required fields first
expert_name = :                                  ; Expert name
expertise_area = :                               ; Area of expertise
retained_by = (defendant, plaintiff, third_party)

; Expert identification
expert_id = :                                     ; Unique identifier

; ───────────────────────────────────────────────────────────────────────────────
; Qualifications
; ───────────────────────────────────────────────────────────────────────────────
{.qualifications}
title = :                                         ; Professional title
employer = :                                      ; Current employer
position = :                                      ; Position
degrees[] = :                                     ; Educational degrees
certifications[] = :                              ; Professional certifications
licenses[] = :                                    ; Professional licenses
publications_count = ##:(0..)                     ; Number of publications
years_experience = ##:(0..)                       ; Years in field

{@legal_expert_witness}

; ───────────────────────────────────────────────────────────────────────────────
; Contact Information
; ───────────────────────────────────────────────────────────────────────────────
{.contact}
address = @address                                ; Business address
phone = *@phone                                   ; Phone
email = *@email                                   ; Email
website = :                                       ; Website

{@legal_expert_witness}

; ───────────────────────────────────────────────────────────────────────────────
; Engagement
; ───────────────────────────────────────────────────────────────────────────────
{.engagement}
engagement_date = date                            ; Date retained
engagement_type = (consulting, consulting_and_testifying, testifying)
engagement_letter_signed = ?                      ; Engagement letter signed
hourly_rate = #$:(0..)                            ; Hourly rate
deposition_rate = #$:(0..)                        ; Deposition rate
trial_rate = #$:(0..)                             ; Trial testimony rate
retainer = #$:(0..)                               ; Retainer amount
retainer_paid = ?:if retainer > 0                 ; Retainer paid

{@legal_expert_witness}

; ───────────────────────────────────────────────────────────────────────────────
; Prior Testimony
; ───────────────────────────────────────────────────────────────────────────────
{.prior_testimony}
prior_testimony_count = ##:(0..)                  ; Times testified before
testified_for_us = ?                              ; Testified for our firm
testified_against_us = ?                          ; Testified against our firm
challenged_under_daubert = ?                      ; Daubert challenge faced
daubert_outcomes = :                              ; Daubert challenge outcomes

{@legal_expert_witness}

; Prior cases
{.prior_testimony.cases[]}
case_name = :                                     ; Case name
year = ##:(1950..2100)                            ; Year
retained_by = (defendant, plaintiff)              ; Retaining party
testified = ?                                     ; Actually testified
excluded = ?                                      ; Testimony excluded

{@legal_expert_witness}

; ───────────────────────────────────────────────────────────────────────────────
; Work Product
; ───────────────────────────────────────────────────────────────────────────────
{.work}
report_required = ?                               ; Report required
report_due_date = date:if report_required = true  ; Report due date
report_submitted = ?:if report_required = true    ; Report submitted
report_date = date:if report_submitted = true     ; Report date
rebuttal_required = ?                             ; Rebuttal report needed
rebuttal_due_date = date:if rebuttal_required = true
rebuttal_submitted = ?:if rebuttal_required = true
supplemental_reports_count = ##:(0..)             ; Supplemental reports

{@legal_expert_witness}

; ───────────────────────────────────────────────────────────────────────────────
; Deposition
; ───────────────────────────────────────────────────────────────────────────────
{.deposition}
deposition_scheduled = ?                          ; Deposition scheduled
deposition_date = date:if deposition_scheduled = true
deposition_location = ::if deposition_scheduled = true
preparation_sessions = ##:(0..)                   ; Prep sessions
deposition_complete = ?                           ; Deposition taken
deposition_hours = #:(0..):if deposition_complete = true

{@legal_expert_witness}

; ───────────────────────────────────────────────────────────────────────────────
; Trial
; ───────────────────────────────────────────────────────────────────────────────
{.trial}
trial_testimony_expected = ?                      ; Expected to testify
trial_prep_sessions = ##:(0..)                    ; Trial prep sessions
testified_at_trial = ?                            ; Testified at trial
testimony_date = date:if testified_at_trial = true
testimony_duration = ::if testified_at_trial = true

{@legal_expert_witness}

; ───────────────────────────────────────────────────────────────────────────────
; Billing
; ───────────────────────────────────────────────────────────────────────────────
{.billing}
total_billed = #$:(0..)                           ; Total billed to date
total_paid = #$:(0..)                             ; Total paid to date
outstanding = #$:(0..)                            ; Outstanding balance
invoices_count = ##:(0..)                         ; Number of invoices

{@legal_expert_witness}

; Status
status = (active, complete, terminated, withdrawn)
status_date = date                                ; Date of status
termination_reason = ::if status = terminated | status = withdrawn

; ═══════════════════════════════════════════════════════════════════════════════
; FACT WITNESS
; ═══════════════════════════════════════════════════════════════════════════════
; Fact witness in litigation

{@legal_fact_witness}
; Required fields first
witness_name = :                                 ; Witness name

; Witness identification
witness_id = :                                    ; Unique identifier

; ───────────────────────────────────────────────────────────────────────────────
; Witness Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
person_ref = @person                              ; Reference to person record
relationship = :                                  ; Relationship to parties
employer = :                                      ; Current employer
position = :                                      ; Current position
former_employer = :                               ; Former employer (if relevant)

{@legal_fact_witness}

; ───────────────────────────────────────────────────────────────────────────────
; Contact Information
; ───────────────────────────────────────────────────────────────────────────────
{.contact}
address = @address                                ; Address
phone = *@phone                                   ; Phone
email = *@email                                   ; Email
alternate_contact = :                             ; Alternate contact
alternate_phone = *@phone                         ; Alternate phone
best_time_to_reach = :                            ; Best time to contact

{@legal_fact_witness}

; ───────────────────────────────────────────────────────────────────────────────
; Subject Matter
; ───────────────────────────────────────────────────────────────────────────────
{.knowledge}
knowledge_areas[] = :                             ; What witness knows about
key_witness = ?                                   ; Key/important witness
favorable = ?                                     ; Favorable to our case
adverse = ?                                       ; Adverse to our case
corroborative = ?                                 ; Corroborates other testimony
documents_possessed = ?                           ; Has relevant documents
documents_described = ::if documents_possessed = true

{@legal_fact_witness}

; ───────────────────────────────────────────────────────────────────────────────
; Interview
; ───────────────────────────────────────────────────────────────────────────────
{.interview}
interviewed = ?                                   ; Has been interviewed
interview_date = date:if interviewed = true       ; Interview date
interviewed_by = ::if interviewed = true          ; Who interviewed
interview_summary = ::if interviewed = true       ; Summary of interview
statement_taken = ?:if interviewed = true         ; Written statement obtained
declaration_signed = ?                            ; Declaration/affidavit signed
will_cooperate = ?                                ; Willing to cooperate

{@legal_fact_witness}

; ───────────────────────────────────────────────────────────────────────────────
; Deposition
; ───────────────────────────────────────────────────────────────────────────────
{.deposition}
deposition_scheduled = ?                          ; Deposition scheduled
deposition_date = date:if deposition_scheduled = true
noticed_by = (defendant, plaintiff, third_party)  ; Who noticed
subpoena_served = ?                               ; Subpoena served
subpoena_date = date:if subpoena_served = true
deposition_complete = ?                           ; Deposition taken
preparation_needed = ?                            ; We need to prepare witness
preparation_date = date:if preparation_needed = true

{@legal_fact_witness}

; ───────────────────────────────────────────────────────────────────────────────
; Trial
; ───────────────────────────────────────────────────────────────────────────────
{.trial}
trial_witness = ?                                 ; On trial witness list
our_witness = ?:if trial_witness = true           ; We're calling witness
opposing_witness = ?:if trial_witness = true      ; Opposing calling witness
subpoena_for_trial = ?:if trial_witness = true    ; Trial subpoena needed
subpoena_served = ?:if subpoena_for_trial = true
testified = ?                                     ; Testified at trial
testimony_date = date:if testified = true

{@legal_fact_witness}

; Status
status = (active, deposed, interviewed, located, unknown)
status_date = date                                ; Date of status


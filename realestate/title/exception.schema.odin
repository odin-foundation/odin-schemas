; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Title Exception Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Title exceptions, standard/printed exceptions, and exception clearing
; workflows. Covers Schedule B exceptions, survey matters, rights of parties
; in possession, and the clearance process for resolving title issues.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as common
@import "../types.schema.odin" as re

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.realestate.title.exception"
version = "1.0.0"
title = "Title Exception Schema"
description = "Title exceptions and exception management"

{$derivation}
source[0].authority = "American Land Title Association"
source[0].citation = "ALTA Commitment and Policy Forms"
source[0].url = "https://www.alta.org/policy-forms/"

source[1].authority = "State Bar Title Standards"
source[1].citation = "Title Examination Standards"
source[1].url = "varies by jurisdiction"

methodology = "industry_practice"
proprietary_sources_consulted = ?false
notes = "Exception schema derived from ALTA forms and title industry practice"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial exception schema"
changelog[0].rationale = "Comprehensive exception management structure"

; ═══════════════════════════════════════════════════════════════════════════════
; STANDARD EXCEPTION
; ═══════════════════════════════════════════════════════════════════════════════
; Standard/printed exceptions common to most policies

{@standard_exception}
; Required fields first
exception_category = !(boundary_survey, defects_created_after, easements_not_shown, encroachments, general_taxes, liens_not_shown, mechanics_liens, mining_claims, mineral_reservations, parties_in_possession, restrictions, rights_of_way, shortages_in_area, special_assessments, unrecorded_matters, water_rights)
exception_number = !##:(1..)                         ; Standard exception number

; Exception identification
exception_id = :                                     ; Unique exception identifier

; ───────────────────────────────────────────────────────────────────────────────
; Exception Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
exception_text = :                                   ; Full exception text
short_description = :                                ; Short description
state_specific = ?                                   ; State-specific exception
state = :(2):if state_specific = true                ; Applicable state
alta_reference = :                                   ; ALTA reference if applicable

{@standard_exception}

; ───────────────────────────────────────────────────────────────────────────────
; Removal/Waiver
; ───────────────────────────────────────────────────────────────────────────────
{.removal}
removable = ?                                        ; Can be removed
removal_method = (affidavit, endorsement, survey, underwriter_waiver):if removable = true
removal_requirements = ::if removable = true         ; Requirements to remove
additional_premium = #$:(0..):if removable = true    ; Additional premium
endorsement_number = ::if removal_method = endorsement

{@standard_exception}

; ───────────────────────────────────────────────────────────────────────────────
; Common Standard Exceptions by Type
; ───────────────────────────────────────────────────────────────────────────────
; Taxes
{.taxes}
current_year_taxes = ?:if exception_category = general_taxes
subsequent_taxes = ?:if exception_category = general_taxes
supplemental_taxes = ?:if exception_category = general_taxes
special_assessments = ?:if exception_category = special_assessments

{@standard_exception}

; Survey matters
{.survey}
boundary_line = ?:if exception_category = boundary_survey
encroachments = ?:if exception_category = encroachments
shortages = ?:if exception_category = shortages_in_area
overlaps = ?:if exception_category = boundary_survey
conflicts = ?:if exception_category = boundary_survey

{@standard_exception}

; Unrecorded matters
{.unrecorded}
parties_in_possession = ?:if exception_category = parties_in_possession | exception_category = unrecorded_matters
unrecorded_easements = ?:if exception_category = easements_not_shown | exception_category = unrecorded_matters
unrecorded_liens = ?:if exception_category = liens_not_shown | exception_category = unrecorded_matters
mechanics_liens = ?:if exception_category = mechanics_liens

{@standard_exception}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, removed, waived)
status_date = date                                   ; Status date

; ═══════════════════════════════════════════════════════════════════════════════
; EXCEPTION CLEARANCE
; ═══════════════════════════════════════════════════════════════════════════════
; Clearing/curing title exceptions

{@exception_clearance}
; Required fields first
exception_description = !:                           ; Exception to be cleared
requested_date = !date                               ; Date clearance requested

; Clearance identification
clearance_id = :                                     ; Unique clearance identifier
file_number = :                                      ; Title file number

; Commitment reference
commitment_ref = @title_commitment                   ; Reference to commitment

; ───────────────────────────────────────────────────────────────────────────────
; Exception Reference
; ───────────────────────────────────────────────────────────────────────────────
{.exception}
exception_type = (commitment_exception, commitment_requirement, standard_exception)
exception_number = ##:(1..)                          ; Exception number
schedule = (b1, b2):if exception_type = commitment_exception | exception_type = commitment_requirement

{@exception_clearance}

; ───────────────────────────────────────────────────────────────────────────────
; Clearance Method
; ───────────────────────────────────────────────────────────────────────────────
{.method}
clearance_type = !(affidavit, document_recording, endorsement, indemnity, payoff, release, subordination, underwriter_approval, waiver)
document_required = :                                ; Document required
document_description = :                             ; Document description
payoff_required = ?                                  ; Payoff required
payoff_amount = #$:(0..):if payoff_required = true   ; Payoff amount
payoff_to = ::if payoff_required = true              ; Payee
indemnity_required = ?                               ; Indemnity required
indemnitor = ::if indemnity_required = true          ; Indemnitor name
underwriter_approval = ?                             ; Underwriter approval required

{@exception_clearance}

; ───────────────────────────────────────────────────────────────────────────────
; Responsible Party
; ───────────────────────────────────────────────────────────────────────────────
{.responsible_party}
party_type = (buyer, lender, seller, third_party, title_company)
party_name = :                                       ; Party name
contact_name = :                                     ; Contact name
contact_phone = @phone                               ; Contact phone
contact_email = @email                               ; Contact email
deadline = date                                      ; Deadline to clear

{@exception_clearance}

; ───────────────────────────────────────────────────────────────────────────────
; Documentation
; ───────────────────────────────────────────────────────────────────────────────
{.documentation}
document_received = ?                                ; Document received
received_date = date:if document_received = true     ; Date received
document_type = ::if document_received = true        ; Document type
reviewed = ?:if document_received = true             ; Document reviewed
review_date = date:if reviewed = true                ; Review date
acceptable = ?:if reviewed = true                    ; Document acceptable
rejection_reason = ::if acceptable = false           ; Why rejected

{@exception_clearance}

; Recording (if document needs recording)
{.documentation.recording}
needs_recording = ?                                  ; Needs to be recorded
recorded = ?:if needs_recording = true               ; Has been recorded
recording_date = date:if recorded = true             ; Recording date
recording_number = ::if recorded = true              ; Document number
book = ::if recorded = true                          ; Book
page = ::if recorded = true                          ; Page

{@exception_clearance}

; ───────────────────────────────────────────────────────────────────────────────
; Underwriter Action
; ───────────────────────────────────────────────────────────────────────────────
{.underwriter}
submitted_to_uw = ?                                  ; Submitted to underwriter
submission_date = date:if submitted_to_uw = true     ; Submission date
uw_reference = ::if submitted_to_uw = true           ; UW reference number
uw_decision = (approved, denied, pending):if submitted_to_uw = true
decision_date = date:if uw_decision = approved | uw_decision = denied
conditions = ::if uw_decision = approved             ; Approval conditions
denial_reason = ::if uw_decision = denied            ; Denial reason

{@exception_clearance}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (abandoned, cleared, in_progress, pending, waived)
status_date = date                                   ; Status date
cleared_date = date:if status = cleared              ; Date cleared
waiver_reason = ::if status = waived                 ; Waiver reason

; ═══════════════════════════════════════════════════════════════════════════════
; AFFIDAVIT
; ═══════════════════════════════════════════════════════════════════════════════
; Affidavit to clear title exception

{@title_affidavit}
; Required fields first
affiant_name = !:                                    ; Affiant name
affidavit_date = !date                               ; Affidavit date
affidavit_type = !(chain_of_title, debts_liens, gap, heirship, identity, marital, mechanics_lien, name_variance, no_liens, possession, seller, survey)

; Affidavit identification
affidavit_id = :                                     ; Unique affidavit identifier

; Clearance reference
clearance_ref = @exception_clearance                 ; Reference to clearance

; ───────────────────────────────────────────────────────────────────────────────
; Affiant Information
; ───────────────────────────────────────────────────────────────────────────────
{.affiant}
name = :                                             ; Affiant name
relationship = (buyer, heir, owner, personal_rep, seller, spouse, third_party)
address = @address                                   ; Affiant address
phone = @phone                                       ; Affiant phone

{@title_affidavit}

; ───────────────────────────────────────────────────────────────────────────────
; Affidavit Content
; ───────────────────────────────────────────────────────────────────────────────
{.content}
property_address = @address                          ; Property address
purpose = :                                          ; Purpose of affidavit
statements[] = :                                     ; Key statements made
exception_addressed = :                              ; Exception being addressed

{@title_affidavit}

; Type-specific content
{.content.identity}
statement_of_identity = ?:if affidavit_type = identity | affidavit_type = name_variance
names_same_person[] = ::if statement_of_identity = true
no_other_persons_same_name = ?:if affidavit_type = identity

{@title_affidavit}

{.content.liens}
no_mechanics_liens = ?:if affidavit_type = mechanics_lien | affidavit_type = no_liens
work_completed = date:if affidavit_type = mechanics_lien
all_contractors_paid = ?:if affidavit_type = mechanics_lien
no_unpaid_debts = ?:if affidavit_type = debts_liens | affidavit_type = no_liens

{@title_affidavit}

{.content.possession}
sole_possession = ?:if affidavit_type = possession
no_adverse_claims = ?:if affidavit_type = possession
no_unrecorded_leases = ?:if affidavit_type = possession
no_boundary_disputes = ?:if affidavit_type = possession

{@title_affidavit}

{.content.marital}
current_marital_status = (divorced, married, single, widowed):if affidavit_type = marital
spouse_name = ::if current_marital_status = married
spouse_joining = ?:if current_marital_status = married
divorce_date = date:if current_marital_status = divorced
divorce_state = :(2):if current_marital_status = divorced
widow_date = date:if current_marital_status = widowed

{@title_affidavit}

; ───────────────────────────────────────────────────────────────────────────────
; Execution
; ───────────────────────────────────────────────────────────────────────────────
{.execution}
signed_date = date                                   ; Date signed
notarized = ?                                        ; Notarized
notary_name = ::if notarized = true                  ; Notary name
notary_county = ::if notarized = true                ; Notary county
notary_state = :(2):if notarized = true              ; Notary state
notary_commission_expires = date:if notarized = true ; Commission expiration

{@title_affidavit}

; ───────────────────────────────────────────────────────────────────────────────
; Recording (if recorded)
; ───────────────────────────────────────────────────────────────────────────────
{.recording}
recorded = ?                                         ; Affidavit recorded
recording_date = date:if recorded = true             ; Recording date
recording_number = ::if recorded = true              ; Document number
book = ::if recorded = true                          ; Book
page = ::if recorded = true                          ; Page
county = ::if recorded = true                        ; Recording county

{@title_affidavit}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (accepted, draft, executed, recorded, rejected)
status_date = date                                   ; Status date
rejection_reason = ::if status = rejected            ; Rejection reason

; ═══════════════════════════════════════════════════════════════════════════════
; INDEMNITY AGREEMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Indemnity agreement for title exceptions

{@title_indemnity}
; Required fields first
indemnitor = !:                                      ; Indemnitor name
indemnitee = !:                                      ; Indemnitee (usually underwriter)
indemnity_date = !date                               ; Agreement date

; Indemnity identification
indemnity_id = :                                     ; Unique indemnity identifier

; Clearance reference
clearance_ref = @exception_clearance                 ; Reference to clearance

; ───────────────────────────────────────────────────────────────────────────────
; Parties
; ───────────────────────────────────────────────────────────────────────────────
{.indemnitor}
name = :                                             ; Indemnitor name
entity_type = (corporation, individual, llc, partnership)
address = @address                                   ; Address
phone = @phone                                       ; Phone
email = @email                                       ; Email

{@title_indemnity}

{.indemnitee}
name = :                                             ; Indemnitee name (underwriter/agent)
address = @address                                   ; Address

{@title_indemnity}

; ───────────────────────────────────────────────────────────────────────────────
; Indemnity Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
exception_description = :                            ; Exception being indemnified
policy_amount = #$:(0..)                             ; Policy amount
indemnity_amount = #$:(0..)                          ; Indemnity amount (may be policy amount or more)
property_address = @address                          ; Property address
file_number = :                                      ; Title file number
policy_number = :                                    ; Policy number (if issued)

{@title_indemnity}

; ───────────────────────────────────────────────────────────────────────────────
; Terms
; ───────────────────────────────────────────────────────────────────────────────
{.terms}
defense_obligation = ?                               ; Indemnitor must defend claims
payment_on_demand = ?                                ; Payment on demand
secured = ?                                          ; Secured indemnity
security_type = ::if secured = true                  ; Type of security
escrow_funds = #$:(0..):if secured = true            ; Funds escrowed
expiration = date                                    ; Expiration date (if any)
perpetual = ?                                        ; Perpetual indemnity

{@title_indemnity}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, cancelled, expired, released)
status_date = date                                   ; Status date
release_date = date:if status = released             ; Release date
release_reason = ::if status = released              ; Release reason


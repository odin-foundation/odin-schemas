; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Title Commitment Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Title commitment/binder for real estate transactions based on ALTA
; commitment forms. Covers Schedule A (transaction information), Schedule B-I
; (requirements to be satisfied), and Schedule B-II (exceptions from coverage).
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as common
@import "../types.schema.odin" as re

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.realestate.title.commitment"
version = "1.0.0"
title = "Title Commitment Schema"
description = "Title commitment/binder for real estate transactions"

{$derivation}
source[0].authority = "American Land Title Association"
source[0].citation = "ALTA Commitment Form"
source[0].url = "https://www.alta.org/policy-forms/"

source[1].authority = "State Insurance Departments"
source[1].citation = "Title Insurance Regulations"
source[1].url = "https://content.naic.org/insurance-topics/title-insurance"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Title commitment schema derived from ALTA commitment form"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial title commitment schema"
changelog[0].rationale = "ALTA-compliant commitment structure"

; ═══════════════════════════════════════════════════════════════════════════════
; TITLE COMMITMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Title commitment/preliminary report/binder

{@title_commitment}
; Required fields first
commitment_date = !date                              ; Commitment date
effective_date = !date                               ; Effective date
property_address = !@address                         ; Property address

; Commitment identification
commitment_id = :                                    ; Unique commitment identifier
commitment_number = :                                ; Commitment number
file_number = :                                      ; Title file number
order_number = :                                     ; Order number

; Title search reference
search_ref = @title_search                           ; Reference to title search

; ───────────────────────────────────────────────────────────────────────────────
; Title Company
; ───────────────────────────────────────────────────────────────────────────────
{.company}
underwriter_name = :                                 ; Title insurance underwriter
underwriter_file = :                                 ; Underwriter file number
agent_name = :                                       ; Title agent name
agent_address = @address                             ; Agent address
agent_phone = @phone                                 ; Agent phone
agent_email = @email                                 ; Agent email
agent_license = :                                    ; Agent license number
escrow_officer = :                                   ; Escrow officer name
title_officer = :                                    ; Title officer name

{@title_commitment}

; ───────────────────────────────────────────────────────────────────────────────
; Schedule A - Transaction Information
; ───────────────────────────────────────────────────────────────────────────────
{.schedule_a}
; Policy to be issued
owner_policy = ?                                     ; Owner's policy to be issued
owner_amount = #$:(0..):if owner_policy = true       ; Owner's policy amount
owner_proposed_insured = ::if owner_policy = true    ; Proposed insured (buyer)
lender_policy = ?                                    ; Lender's policy to be issued
lender_amount = #$:(0..):if lender_policy = true     ; Lender's policy amount
lender_proposed_insured = ::if lender_policy = true  ; Proposed insured (lender)
simultaneous_issue = ?                               ; Simultaneous issue discount

{@title_commitment}

; Fee simple estate
{.schedule_a.estate}
estate_type = (fee_simple, ground_lease, leasehold)  ; Estate to be insured
vested_in = :                                        ; Current vested owner
vesting = :                                          ; Vesting type

{@title_commitment}

; Legal description
legal_description = @re_legal_description            ; Legal description
parcel = @re_parcel_identifiers                      ; Parcel identifiers

{@title_commitment}

; ───────────────────────────────────────────────────────────────────────────────
; Schedule B-I - Requirements
; ───────────────────────────────────────────────────────────────────────────────
{.schedule_b1}
requirements[] = @commitment_requirement             ; List of requirements

{@title_commitment}

; ───────────────────────────────────────────────────────────────────────────────
; Schedule B-II - Exceptions
; ───────────────────────────────────────────────────────────────────────────────
{.schedule_b2}
standard_exceptions = ?                              ; Standard exceptions apply
standard_exceptions_waived = ?                       ; Standard exceptions waived
survey_exception = ?                                 ; Survey exception (waived with survey)
exceptions[] = @commitment_exception                 ; List of exceptions

{@title_commitment}

; ───────────────────────────────────────────────────────────────────────────────
; Conditions
; ───────────────────────────────────────────────────────────────────────────────
{.conditions}
commitment_expiration = date                         ; Commitment expiration date
liability_before_policy = :                          ; Liability limitations
conditions_and_stipulations = :                      ; Additional conditions

{@title_commitment}

; ───────────────────────────────────────────────────────────────────────────────
; Premiums and Fees
; ───────────────────────────────────────────────────────────────────────────────
{.premiums}
owner_premium = #$:(0..)                             ; Owner's policy premium
lender_premium = #$:(0..)                            ; Lender's policy premium
simultaneous_discount = #$:(0..)                     ; Simultaneous issue discount
endorsement_fees = #$:(0..)                          ; Endorsement fees
search_fee = #$:(0..)                                ; Title search fee
exam_fee = #$:(0..)                                  ; Title examination fee
closing_protection_fee = #$:(0..)                    ; Closing protection letter fee
total_title_charges = #$:(0..)                       ; Total title charges

{@title_commitment}

; ───────────────────────────────────────────────────────────────────────────────
; Endorsements
; ───────────────────────────────────────────────────────────────────────────────
{.endorsements[]}
endorsement_number = :                               ; ALTA endorsement number
endorsement_name = :                                 ; Endorsement name
owner_or_lender = (lender, owner)                    ; Which policy
premium = #$:(0..)                                   ; Endorsement premium
available = ?                                        ; Available for this transaction
requirements = :                                     ; Requirements to issue

{@title_commitment}

; ───────────────────────────────────────────────────────────────────────────────
; Amendments
; ───────────────────────────────────────────────────────────────────────────────
{.amendments[]}
amendment_number = ##:(1..)                          ; Amendment number
amendment_date = date                                ; Amendment date
description = :                                      ; Description of amendment
requirements_added[] = @commitment_requirement       ; Requirements added
requirements_removed[] = ##:(0..)                    ; Requirement numbers removed
exceptions_added[] = @commitment_exception           ; Exceptions added
exceptions_removed[] = ##:(0..)                      ; Exception numbers removed

{@title_commitment}

; ───────────────────────────────────────────────────────────────────────────────
; Pro Forma Policy
; ───────────────────────────────────────────────────────────────────────────────
{.pro_forma}
pro_forma_available = ?                              ; Pro forma policy available
owner_pro_forma = ::if pro_forma_available = true    ; Owner's pro forma
lender_pro_forma = ::if pro_forma_available = true   ; Lender's pro forma

{@title_commitment}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (amended, cancelled, expired, issued, pending, policy_issued)
status_date = date                                   ; Status date
cancellation_reason = ::if status = cancelled        ; Cancellation reason
policy_issued_date = date:if status = policy_issued  ; Date policy issued

; ═══════════════════════════════════════════════════════════════════════════════
; COMMITMENT REQUIREMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Schedule B-I requirement

{@commitment_requirement}
; Required fields first
requirement_number = !##:(1..)                       ; Requirement number
requirement_text = !:                                ; Requirement text

; Requirement identification
requirement_id = :                                   ; Unique requirement identifier

; ───────────────────────────────────────────────────────────────────────────────
; Requirement Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
requirement_type = (corporate_resolution, curative, deed_requirement, judgment_payoff, lien_payoff, mortgage_payoff, probate, recording, signature, subordination, survey, tax_payment, trust_certification)
party_responsible = (buyer, lender, seller, title_company)
document_required = :                                ; Document required
payoff_required = ?                                  ; Payoff required
payoff_amount = #$:(0..):if payoff_required = true   ; Payoff amount
payee = ::if payoff_required = true                  ; Payee for payoff
due_date = date                                      ; Due date

{@commitment_requirement}

; ───────────────────────────────────────────────────────────────────────────────
; Related Document
; ───────────────────────────────────────────────────────────────────────────────
{.related_document}
document_type = :                                    ; Related document type
recording_date = date                                ; Recording date
document_number = :                                  ; Document number
book = :                                             ; Book
page = :                                             ; Page
original_amount = #$:(0..)                           ; Original amount

{@commitment_requirement}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (in_progress, not_applicable, pending, satisfied, waived)
status_date = date                                   ; Status date
satisfied_by = ::if status = satisfied               ; How satisfied
satisfied_date = date:if status = satisfied          ; Date satisfied
waiver_reason = ::if status = waived                 ; Waiver reason
waived_by = ::if status = waived                     ; Waived by

; ═══════════════════════════════════════════════════════════════════════════════
; COMMITMENT EXCEPTION
; ═══════════════════════════════════════════════════════════════════════════════
; Schedule B-II exception

{@commitment_exception}
; Required fields first
exception_number = !##:(1..)                         ; Exception number
exception_text = !:                                  ; Exception text

; Exception identification
exception_id = :                                     ; Unique exception identifier

; ───────────────────────────────────────────────────────────────────────────────
; Exception Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
exception_type = (assessment, ccr, deed_restriction, easement, encroachment, hoa, lease, lien, mineral, plat, restriction, rights_of_parties, standard, survey_matter, tax, utility)
standard_exception = ?                               ; Is a standard exception
affects_marketability = ?                            ; Affects marketability
can_be_removed = ?                                   ; Can be removed before closing
removal_action = ::if can_be_removed = true          ; Action to remove
insure_over = ?                                      ; Can insure over
endorsement_available = ::if insure_over = true      ; Endorsement to insure

{@commitment_exception}

; ───────────────────────────────────────────────────────────────────────────────
; Related Document
; ───────────────────────────────────────────────────────────────────────────────
{.related_document}
document_type = :                                    ; Document type
recording_date = date                                ; Recording date
document_number = :                                  ; Document number
book = :                                             ; Book
page = :                                             ; Page
grantor = :                                          ; Grantor
grantee = :                                          ; Grantee

{@commitment_exception}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, insured_over, remains_on_policy, removed, waived)
status_date = date                                   ; Status date
removal_method = ::if status = removed               ; How removed
waiver_reason = ::if status = waived                 ; Waiver reason
endorsement_issued = ::if status = insured_over      ; Endorsement number

; ═══════════════════════════════════════════════════════════════════════════════
; CLOSING PROTECTION LETTER
; ═══════════════════════════════════════════════════════════════════════════════
; CPL/Insured Closing Letter

{@closing_protection_letter}
; Required fields first
cpl_date = !date                                     ; CPL date
property_address = !@address                         ; Property address

; CPL identification
cpl_id = :                                           ; Unique CPL identifier
cpl_number = :                                       ; CPL number

; Commitment reference
commitment_ref = @title_commitment                   ; Reference to commitment

; ───────────────────────────────────────────────────────────────────────────────
; Parties
; ───────────────────────────────────────────────────────────────────────────────
{.parties}
underwriter = :                                      ; Underwriter name
issued_to = :                                        ; Addressee
issued_to_type = (buyer, lender, seller)             ; Addressee type
agent_name = :                                       ; Title agent name
agent_address = @address                             ; Agent address

{@closing_protection_letter}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.coverage}
coverage_type = (full, limited)                      ; Coverage type
fraud_coverage = ?                                   ; Fraud/dishonesty coverage
failure_to_follow = ?                                ; Failure to follow instructions
error_coverage = ?                                   ; Error/negligence coverage
coverage_amount = #$:(0..)                           ; Maximum coverage amount
deductible = #$:(0..)                                ; Deductible amount

{@closing_protection_letter}

; ───────────────────────────────────────────────────────────────────────────────
; Conditions
; ───────────────────────────────────────────────────────────────────────────────
{.conditions}
transaction_type = :                                 ; Transaction covered
effective_date = date                                ; Coverage effective date
expiration_date = date                               ; Coverage expiration
escrow_instructions_required = ?                     ; Escrow instructions required
conditions[] = :                                     ; Coverage conditions

{@closing_protection_letter}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, cancelled, expired, issued)
status_date = date                                   ; Status date


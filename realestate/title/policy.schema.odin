; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Title Policy Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Title insurance policies for real estate transactions including owner's,
; lender's, short form, and homeowner's policies based on ALTA 2021 forms.
; Covers policy endorsements, claims, premium calculations, and reinsurance.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as common
@import "../types.schema.odin" as re

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.realestate.title.policy"
version = "1.0.0"
title = "Title Policy Schema"
description = "Title insurance policy issuance and tracking"

{$derivation}
source[0].authority = "American Land Title Association"
source[0].citation = "ALTA Policy Forms (2021)"
source[0].url = "https://www.alta.org/policy-forms/"

source[1].authority = "State Insurance Departments"
source[1].citation = "Title Insurance Regulations"
source[1].url = "varies by jurisdiction"

source[2].authority = "CFPB"
source[2].citation = "TRID Title Insurance Disclosure"
source[2].url = "https://www.consumerfinance.gov/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Title policy schema derived from ALTA 2021 policy forms"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial title policy schema"
changelog[0].rationale = "ALTA-compliant policy structure"

; ═══════════════════════════════════════════════════════════════════════════════
; TITLE POLICY
; ═══════════════════════════════════════════════════════════════════════════════
; Title insurance policy

{@title_policy}
; Required fields first
insured_amount = !#$:(0..)                           ; Policy amount
insured_name = !:                                    ; Named insured
policy_date = !date                                  ; Policy date
policy_type = !(homeowners, lender, lender_short_form, owner, owner_short_form)
property_address = !@address                         ; Property address

; Policy identification
policy_id = :                                        ; Unique policy identifier
policy_number = :                                    ; Policy number
file_number = :                                      ; Title file number

; Commitment reference
commitment_ref = @title_commitment                   ; Reference to commitment

; ───────────────────────────────────────────────────────────────────────────────
; Underwriter
; ───────────────────────────────────────────────────────────────────────────────
{.underwriter}
underwriter_name = :                                 ; Underwriter name
underwriter_address = @address                       ; Underwriter address
underwriter_phone = @phone                           ; Underwriter phone
underwriter_naic = :                                 ; NAIC number
issuing_agent = :                                    ; Issuing agent name
agent_address = @address                             ; Agent address
agent_license = :                                    ; Agent license number
agent_file = :                                       ; Agent file number

{@title_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Insured
; ───────────────────────────────────────────────────────────────────────────────
{.insured}
primary_insured = :                                  ; Primary insured name
insured_address = @address                           ; Insured address
additional_insureds[] = :                            ; Additional insureds
successor_insureds = ?                               ; Successor insureds covered
heirs_devisees = ?:if policy_type = owner | policy_type = homeowners

{@title_policy}

; Lender policy specific
{.insured.lender}
lender_name = ::if policy_type = lender | policy_type = lender_short_form
mers = ?:if policy_type = lender | policy_type = lender_short_form
mers_min = ::if mers = true                          ; MERS MIN
loan_number = ::if policy_type = lender | policy_type = lender_short_form
assignees_covered = ?:if policy_type = lender        ; Assignees covered

{@title_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Property
; ───────────────────────────────────────────────────────────────────────────────
{.property}
legal_description = @re_legal_description            ; Legal description
parcel = @re_parcel_identifiers                      ; Parcel identifiers
property_type = (commercial, condominium, land, manufactured, multi_family, pud, residential)

{@title_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Estate and Title
; ───────────────────────────────────────────────────────────────────────────────
{.estate}
estate_type = (fee_simple, ground_lease, leasehold, life_estate)
vested_in = :                                        ; Owner as vested
vesting_type = (community_property, joint_tenants, sole_and_separate, tenants_by_entirety, tenants_in_common, trust)

{@title_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.coverage}
policy_amount = #$:(0..)                             ; Original policy amount
current_amount = #$:(0..)                            ; Current policy amount (may differ for lender)
inflation_coverage = ?                               ; Automatic inflation coverage
inflation_percentage = #:(0..100):if inflation_coverage = true
maximum_inflation = #$:(0..):if inflation_coverage = true
extended_coverage = ?                                ; Extended coverage (survey matters)
enhanced_coverage = ?:if policy_type = homeowners    ; Enhanced homeowner coverage

{@title_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Schedule A
; ───────────────────────────────────────────────────────────────────────────────
{.schedule_a}
effective_date = date                                ; Effective date of policy
policy_date = date                                   ; Policy date
amount_of_insurance = #$:(0..)                       ; Amount of insurance
premium_paid = #$:(0..)                              ; Premium paid

{@title_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Schedule B - Exceptions
; ───────────────────────────────────────────────────────────────────────────────
{.schedule_b}
standard_exceptions_removed = ?                      ; Standard exceptions removed
survey_exception_removed = ?                         ; Survey exception removed
exceptions[] = @policy_exception                     ; List of exceptions

{@title_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Endorsements
; ───────────────────────────────────────────────────────────────────────────────
endorsements[] = @policy_endorsement                 ; Attached endorsements

{@title_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Premium Information
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
base_premium = #$:(0..)                              ; Base premium
simultaneous_discount = #$:(0..)                     ; Simultaneous issue discount
reissue_credit = #$:(0..)                            ; Reissue credit
endorsement_premiums = #$:(0..)                      ; Total endorsement premiums
search_fees = #$:(0..)                               ; Search/exam fees
total_premium = #$:(0..)                             ; Total premium charged
premium_paid_by = (buyer, lender, seller, split)     ; Who paid premium

{@title_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Related Loan (Lender Policy)
; ───────────────────────────────────────────────────────────────────────────────
{.loan}
loan_amount = #$:(0..):if policy_type = lender | policy_type = lender_short_form
loan_date = date:if policy_type = lender | policy_type = lender_short_form
loan_type = (arm, conventional, fha, heloc, jumbo, usda, va):if policy_type = lender
security_instrument = (deed_of_trust, mortgage, security_deed):if policy_type = lender
recording_date = date:if policy_type = lender        ; DOT/mortgage recording date
recording_number = ::if policy_type = lender         ; Document number

{@title_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Claims
; ───────────────────────────────────────────────────────────────────────────────
{.claims[]}
claim_number = :                                     ; Claim number
claim_date = date                                    ; Date claim filed
claimant = :                                         ; Claimant name
claim_amount = #$:(0..)                              ; Amount claimed
claim_type = (access, boundary, easement, encroachment, forgery, lien, mechanics_lien, survey, tax, title_defect, unmarketable)
description = :                                      ; Claim description
status = (closed, denied, in_litigation, open, paid, settled)
resolution_date = date:if status = closed | status = paid | status = settled
amount_paid = #$:(0..):if status = paid | status = settled

{@title_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, cancelled, claim_pending, lapsed, paid_claim)
status_date = date                                   ; Status date
cancellation_date = date:if status = cancelled       ; Cancellation date
cancellation_reason = ::if status = cancelled        ; Reason for cancellation

; ═══════════════════════════════════════════════════════════════════════════════
; POLICY EXCEPTION
; ═══════════════════════════════════════════════════════════════════════════════
; Schedule B exception on policy

{@policy_exception}
; Required fields first
exception_number = !##:(1..)                         ; Exception number
exception_text = !:                                  ; Exception text

; Exception identification
exception_id = :                                     ; Unique exception identifier

; ───────────────────────────────────────────────────────────────────────────────
; Exception Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
exception_type = (ccr, easement, encroachment, hoa, lease, lien, mineral, plat_note, restriction, rights_of_parties, standard, survey, tax, utility)
standard_exception = ?                               ; Standard exception
affects_entire_property = ?                          ; Affects entire property
affected_area = ::if affects_entire_property = false ; Area affected

{@policy_exception}

; ───────────────────────────────────────────────────────────────────────────────
; Source Document
; ───────────────────────────────────────────────────────────────────────────────
{.source}
document_type = :                                    ; Document type
recording_date = date                                ; Recording date
document_number = :                                  ; Document number
book = :                                             ; Book
page = :                                             ; Page
grantor = :                                          ; Grantor
grantee = :                                          ; Grantee/beneficiary

{@policy_exception}

; ═══════════════════════════════════════════════════════════════════════════════
; POLICY ENDORSEMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Endorsement attached to policy

{@policy_endorsement}
; Required fields first
endorsement_form = !:                                ; ALTA endorsement form number
endorsement_name = !:                                ; Endorsement name

; Endorsement identification
endorsement_id = :                                   ; Unique endorsement identifier

; ───────────────────────────────────────────────────────────────────────────────
; Endorsement Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
endorsement_date = date                              ; Endorsement date
policy_type = (lender, owner)                        ; Which policy type
premium = #$:(0..)                                   ; Endorsement premium
modifies_coverage = ?                                ; Modifies policy coverage
additional_coverage = ?                              ; Adds coverage
removes_exception = ?                                ; Removes an exception
exception_removed = ##:(0..):if removes_exception = true

{@policy_endorsement}

; ───────────────────────────────────────────────────────────────────────────────
; Common Endorsement Types
; ───────────────────────────────────────────────────────────────────────────────
{.endorsement_type}
category = (access, condominium, contiguity, environmental, leasehold, location, restrictions, survey, tax_parcel, variable_rate, zoning)
alta_number = :                                      ; ALTA number (e.g., "9.0")
state_variation = :                                  ; State variation if applicable

{@policy_endorsement}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Added
; ───────────────────────────────────────────────────────────────────────────────
{.coverage}
coverage_description = :                             ; Description of coverage
additional_amount = #$:(0..)                         ; Additional coverage amount
conditions = :                                       ; Conditions/limitations

{@policy_endorsement}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, cancelled, superseded)
status_date = date                                   ; Status date


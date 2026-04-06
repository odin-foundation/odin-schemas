; ═══════════════════════════════════════════════════════════════════════════════
; ODIN HOA Governing Documents Schema
; ═══════════════════════════════════════════════════════════════════════════════
; HOA governing documents and disclosure requirements including declarations
; (CC&Rs), bylaws, articles of incorporation, rules, and amendments. Also
; covers resale certificates and HOA transaction disclosures with financial
; summaries, restrictions, and acknowledgment tracking.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as common
@import "../types.schema.odin" as re

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.realestate.hoa.governing_docs"
version = "1.0.0"
title = "HOA Governing Documents Schema"
description = "HOA governing documents and disclosure requirements"

{$derivation}
source[0].authority = "Community Associations Institute"
source[0].citation = "Governance Guidelines"
source[0].url = "https://www.caionline.org/"

source[1].authority = "State HOA Disclosure Laws"
source[1].citation = "Resale Certificate Requirements"
source[1].url = "varies by jurisdiction"

source[2].authority = "Uniform Common Interest Ownership Act"
source[2].citation = "UCIOA Disclosure Requirements"
source[2].url = "https://www.uniformlaws.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Governing documents schema derived from CAI standards and state requirements"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial governing documents schema"
changelog[0].rationale = "Comprehensive HOA document structure"

; ═══════════════════════════════════════════════════════════════════════════════
; GOVERNING DOCUMENT
; ═══════════════════════════════════════════════════════════════════════════════
; HOA governing document

{@governing_document}
; Required fields first
document_type = !(amendment, articles, bylaws, declaration, operating_rules, policies, resolutions, rules)
effective_date = !date                               ; Effective date
title = !:                                           ; Document title

; Document identification
document_id = :                                      ; Unique document identifier

; Association reference
association_ref = @association                       ; Reference to association

; ───────────────────────────────────────────────────────────────────────────────
; Document Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
original_date = date                                 ; Original document date
restated = ?                                         ; Has been restated
restated_date = date:if restated = true              ; Restatement date
amendment_count = ##:(0..)                           ; Number of amendments
last_amended = date                                  ; Last amendment date
supersedes = :                                       ; Supersedes document reference
page_count = ##:(1..)                                ; Number of pages

{@governing_document}

; ───────────────────────────────────────────────────────────────────────────────
; Recording (if recorded)
; ───────────────────────────────────────────────────────────────────────────────
{.recording}
recorded = ?                                         ; Document is recorded
recording_date = date:if recorded = true             ; Recording date
recording_number = ::if recorded = true              ; Document number
book = ::if recorded = true                          ; Book
page = ::if recorded = true                          ; Page
county = ::if recorded = true                        ; Recording county
state = :(2):if recorded = true                      ; Recording state

{@governing_document}

; ───────────────────────────────────────────────────────────────────────────────
; Approval
; ───────────────────────────────────────────────────────────────────────────────
{.approval}
approval_type = (board, declarant, member_vote)      ; How approved
approval_date = date                                 ; Approval date
vote_required = #:(0..100):if approval_type = member_vote
vote_achieved = #:(0..100):if approval_type = member_vote
quorum_met = ?:if approval_type = member_vote        ; Quorum requirement met

{@governing_document}

; ───────────────────────────────────────────────────────────────────────────────
; Declaration Specific (CC&Rs)
; ───────────────────────────────────────────────────────────────────────────────
{.declaration}
property_description = @re_legal_description:if document_type = declaration
community_name = ::if document_type = declaration    ; Community name
total_units = ##:(0..):if document_type = declaration ; Total units
common_area_description = ::if document_type = declaration
assessment_authority = ?:if document_type = declaration
lien_priority = (junior, super):if document_type = declaration
architectural_control = ?:if document_type = declaration
use_restrictions = ?:if document_type = declaration
rental_restrictions = ?:if document_type = declaration
age_restrictions = ?:if document_type = declaration
pet_restrictions = ?:if document_type = declaration
declarant_rights = ::if document_type = declaration  ; Declarant reserved rights
transition_provisions = ::if document_type = declaration

{@governing_document}

; ───────────────────────────────────────────────────────────────────────────────
; Bylaws Specific
; ───────────────────────────────────────────────────────────────────────────────
{.bylaws}
board_size = ##:(3..15):if document_type = bylaws    ; Board size
board_term = ##:(1..5):if document_type = bylaws     ; Term length years
officer_positions[] = ::if document_type = bylaws    ; Officer positions
meeting_requirements = ::if document_type = bylaws   ; Meeting requirements
quorum_board = #:(0..100):if document_type = bylaws  ; Board quorum
quorum_member = #:(0..100):if document_type = bylaws ; Member quorum
voting_rights = ::if document_type = bylaws          ; Voting rights description
amendment_process = ::if document_type = bylaws      ; Amendment requirements

{@governing_document}

; ───────────────────────────────────────────────────────────────────────────────
; Rules Specific
; ───────────────────────────────────────────────────────────────────────────────
{.rules}
rule_categories[] = (architectural, common_area, guest, landscaping, moving, noise, parking, pet, pool, rental, signage, trash):if document_type = rules | document_type = operating_rules
enforcement_procedure = ::if document_type = rules   ; Enforcement procedure
fine_schedule = ?:if document_type = rules           ; Fine schedule included
hearing_process = ::if document_type = rules         ; Hearing process

{@governing_document}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, amended, draft, superseded)
status_date = date                                   ; Status date

; ═══════════════════════════════════════════════════════════════════════════════
; AMENDMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Amendment to governing document

{@amendment}
; Required fields first
amendment_date = !date                               ; Amendment date
amendment_number = !##:(1..)                         ; Amendment number

; Amendment identification
amendment_id = :                                     ; Unique amendment identifier

; Document reference
document_ref = @governing_document                   ; Reference to original document

; ───────────────────────────────────────────────────────────────────────────────
; Amendment Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
title = :                                            ; Amendment title
purpose = :                                          ; Purpose of amendment
sections_amended[] = :                               ; Sections amended
summary = :                                          ; Summary of changes

{@amendment}

; ───────────────────────────────────────────────────────────────────────────────
; Approval
; ───────────────────────────────────────────────────────────────────────────────
{.approval}
approval_type = (board, member_vote)                 ; How approved
vote_required = #:(0..100)                           ; Vote percentage required
vote_achieved = #:(0..100)                           ; Vote percentage achieved
approval_date = date                                 ; Approval date
meeting_date = date                                  ; Meeting date

{@amendment}

; ───────────────────────────────────────────────────────────────────────────────
; Recording
; ───────────────────────────────────────────────────────────────────────────────
{.recording}
recorded = ?                                         ; Amendment recorded
recording_date = date:if recorded = true             ; Recording date
recording_number = ::if recorded = true              ; Document number
book = ::if recorded = true                          ; Book
page = ::if recorded = true                          ; Page
county = ::if recorded = true                        ; Recording county

{@amendment}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, pending, recorded, superseded)
status_date = date                                   ; Status date

; ═══════════════════════════════════════════════════════════════════════════════
; RESALE CERTIFICATE
; ═══════════════════════════════════════════════════════════════════════════════
; HOA resale certificate/disclosure package

{@resale_certificate}
; Required fields first
issue_date = !date                                   ; Issue date
unit_address = !@address                             ; Unit address
unit_number = !:                                     ; Unit number

; Certificate identification
certificate_id = :                                   ; Unique certificate identifier
certificate_number = :                               ; Certificate number

; Association reference
association_ref = @association                       ; Reference to association

; ───────────────────────────────────────────────────────────────────────────────
; Requestor Information
; ───────────────────────────────────────────────────────────────────────────────
{.requestor}
requestor_name = :                                   ; Requestor name
requestor_type = (buyer, lender, owner, seller, title_company)
requestor_company = :                                ; Company name
requestor_phone = @phone                             ; Phone
requestor_email = @email                             ; Email
request_date = date                                  ; Request date
rush_order = ?                                       ; Rush order

{@resale_certificate}

; ───────────────────────────────────────────────────────────────────────────────
; Owner/Unit Information
; ───────────────────────────────────────────────────────────────────────────────
{.unit}
current_owner = :                                    ; Current owner name
owner_mailing_address = @address                     ; Owner mailing address
unit_sqft = ##:(0..)                                 ; Unit square feet
percentage_interest = #:(0..100)                     ; Percentage interest
parking_spaces = ##:(0..)                            ; Parking spaces
storage_units = ##:(0..)                             ; Storage units

{@resale_certificate}

; ───────────────────────────────────────────────────────────────────────────────
; Assessment Information
; ───────────────────────────────────────────────────────────────────────────────
{.assessments}
regular_assessment = #$:(0..)                        ; Regular assessment
assessment_frequency = (annual, monthly, quarterly, semi_annual)
next_due_date = date                                 ; Next due date
special_assessments_pending = ?                      ; Special assessments pending
special_assessment_amount = #$:(0..):if special_assessments_pending = true
special_assessment_description = ::if special_assessments_pending = true
special_assessment_remaining = #$:(0..):if special_assessments_pending = true
assessment_increase_pending = ?                      ; Assessment increase pending
increase_amount = #$:(0..):if assessment_increase_pending = true
increase_effective_date = date:if assessment_increase_pending = true

{@resale_certificate}

; ───────────────────────────────────────────────────────────────────────────────
; Account Status
; ───────────────────────────────────────────────────────────────────────────────
{.account_status}
current_balance = #$                                 ; Current balance
past_due_amount = #$:(0..)                           ; Past due amount
late_fees = #$:(0..)                                 ; Late fees owed
fines = #$:(0..)                                     ; Fines owed
legal_fees = #$:(0..)                                ; Legal fees owed
total_due = #$:(0..)                                 ; Total due
lien_filed = ?                                       ; Lien filed
lien_amount = #$:(0..):if lien_filed = true          ; Lien amount
violations_outstanding = ?                           ; Outstanding violations
violation_description = ::if violations_outstanding = true

{@resale_certificate}

; ───────────────────────────────────────────────────────────────────────────────
; Association Financials
; ───────────────────────────────────────────────────────────────────────────────
{.financials}
operating_budget = #$:(0..)                          ; Annual operating budget
reserve_balance = #$:(0..)                           ; Reserve balance
reserve_percent_funded = #:(0..100)                  ; Percent funded
last_reserve_study = date                            ; Last reserve study
operating_deficit = ?                                ; Operating deficit
deficit_amount = #$:(0..):if operating_deficit = true
special_assessment_planned = ?                       ; Special assessment planned
planned_amount = #$:(0..):if special_assessment_planned = true
fiscal_year_end = :                                  ; Fiscal year end

{@resale_certificate}

; ───────────────────────────────────────────────────────────────────────────────
; Insurance
; ───────────────────────────────────────────────────────────────────────────────
{.insurance}
master_policy = ?                                    ; Has master policy
carrier = ::if master_policy = true                  ; Insurance carrier
policy_number = ::if master_policy = true            ; Policy number
property_coverage = #$:(0..):if master_policy = true ; Property coverage
liability_coverage = #$:(0..):if master_policy = true ; Liability coverage
deductible = #$:(0..):if master_policy = true        ; Deductible
expiration_date = date:if master_policy = true       ; Policy expiration
fidelity_bond = ?                                    ; Fidelity bond
fidelity_amount = #$:(0..):if fidelity_bond = true   ; Bond amount
directors_officers = ?                               ; D&O insurance

{@resale_certificate}

; ───────────────────────────────────────────────────────────────────────────────
; Litigation
; ───────────────────────────────────────────────────────────────────────────────
{.litigation}
pending_litigation = ?                               ; Pending litigation
litigation_description = ::if pending_litigation = true
construction_defect = ?                              ; Construction defect claim
defect_description = ::if construction_defect = true
litigation_reserve = #$:(0..):if pending_litigation = true

{@resale_certificate}

; ───────────────────────────────────────────────────────────────────────────────
; Restrictions and Disclosures
; ───────────────────────────────────────────────────────────────────────────────
{.restrictions}
rental_restrictions = ?                              ; Rental restrictions
rental_description = ::if rental_restrictions = true ; Rental restriction details
rental_cap_reached = ?:if rental_restrictions = true ; Rental cap reached
age_restrictions = ?                                 ; Age restrictions (55+)
age_description = ::if age_restrictions = true       ; Age restriction details
pet_restrictions = ?                                 ; Pet restrictions
pet_description = ::if pet_restrictions = true       ; Pet restriction details
leasing_approval = ?                                 ; Lease approval required
right_of_first_refusal = ?                           ; Right of first refusal
move_in_fee = #$:(0..)                               ; Move-in fee
move_out_fee = #$:(0..)                              ; Move-out fee
transfer_fee = #$:(0..)                              ; Transfer fee
working_capital_fee = #$:(0..)                       ; Working capital contribution

{@resale_certificate}

; ───────────────────────────────────────────────────────────────────────────────
; Documents Included
; ───────────────────────────────────────────────────────────────────────────────
{.documents}
declaration = ?                                      ; CC&Rs included
bylaws = ?                                           ; Bylaws included
articles = ?                                         ; Articles included
rules = ?                                            ; Rules included
budget = ?                                           ; Budget included
financial_statements = ?                             ; Financials included
reserve_study = ?                                    ; Reserve study included
meeting_minutes = ?                                  ; Minutes included
insurance_certificate = ?                            ; Insurance cert included
other_documents[] = :                                ; Other documents

{@resale_certificate}

; ───────────────────────────────────────────────────────────────────────────────
; Certificate Details
; ───────────────────────────────────────────────────────────────────────────────
{.certificate}
prepared_by = :                                      ; Prepared by
prepared_date = date                                 ; Preparation date
valid_through = date                                 ; Validity date
fee_charged = #$:(0..)                               ; Certificate fee
rush_fee = #$:(0..)                                  ; Rush fee
update_fee = #$:(0..)                                ; Update fee
delivery_method = (email, fedex, mail, pickup)       ; Delivery method

{@resale_certificate}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (cancelled, delivered, expired, in_progress, ordered)
status_date = date                                   ; Status date

; ═══════════════════════════════════════════════════════════════════════════════
; HOA DISCLOSURE (Transaction)
; ═══════════════════════════════════════════════════════════════════════════════
; HOA disclosure for real estate transaction

{@hoa_disclosure}
; Required fields first
disclosure_date = !date                              ; Disclosure date
property_address = !@address                         ; Property address

; Disclosure identification
disclosure_id = :                                    ; Unique disclosure identifier

; Transaction reference
transaction_ref = :                                  ; Reference to purchase transaction

; ───────────────────────────────────────────────────────────────────────────────
; Association Summary
; ───────────────────────────────────────────────────────────────────────────────
{.association}
association_name = :                                 ; Association name
association_type = (condominium, cooperative, hoa, poa, pud)
management_company = :                               ; Management company
manager_phone = @phone                               ; Manager phone
manager_email = @email                               ; Manager email
website = :                                          ; Association website

{@hoa_disclosure}

; ───────────────────────────────────────────────────────────────────────────────
; Financial Summary
; ───────────────────────────────────────────────────────────────────────────────
{.financial}
regular_assessment = #$:(0..)                        ; Regular assessment
frequency = (annual, monthly, quarterly, semi_annual)
special_assessments = #$:(0..)                       ; Special assessments due
total_current_balance = #$                           ; Total balance on unit
reserve_balance = #$:(0..)                           ; Association reserves
reserve_percent_funded = #:(0..100)                  ; Percent funded
pending_assessments = ?                              ; Pending special assessments
pending_amount = #$:(0..):if pending_assessments = true

{@hoa_disclosure}

; ───────────────────────────────────────────────────────────────────────────────
; Transaction Requirements
; ───────────────────────────────────────────────────────────────────────────────
{.transaction}
transfer_fee = #$:(0..)                              ; Transfer fee
move_in_fee = #$:(0..)                               ; Move-in fee
capital_contribution = #$:(0..)                      ; Capital contribution
document_fee = #$:(0..)                              ; Document fee
rush_fee = #$:(0..)                                  ; Rush fee
other_fees = #$:(0..)                                ; Other fees
total_fees = #$:(0..)                                ; Total closing fees
approval_required = ?                                ; Board approval required
right_of_first_refusal = ?                           ; ROFR applies

{@hoa_disclosure}

; ───────────────────────────────────────────────────────────────────────────────
; Key Restrictions
; ───────────────────────────────────────────────────────────────────────────────
{.restrictions}
rental_allowed = ?                                   ; Rentals allowed
rental_minimum_term = ::if rental_allowed = true     ; Minimum rental term
rental_cap = ?:if rental_allowed = true              ; Rental cap exists
rental_cap_reached = ?:if rental_cap = true          ; Cap reached
pets_allowed = ?                                     ; Pets allowed
pet_restrictions = ::if pets_allowed = true          ; Pet restrictions
age_restricted = ?                                   ; Age-restricted community
age_requirement = ::if age_restricted = true         ; Age requirement

{@hoa_disclosure}

; ───────────────────────────────────────────────────────────────────────────────
; Key Issues
; ───────────────────────────────────────────────────────────────────────────────
{.issues}
litigation_pending = ?                               ; Litigation pending
construction_defects = ?                             ; Construction defects
deferred_maintenance = ?                             ; Significant deferred maintenance
insurance_issues = ?                                 ; Insurance issues
special_assessment_expected = ?                      ; Special assessment expected
other_material_issues[] = :                          ; Other material issues

{@hoa_disclosure}

; ───────────────────────────────────────────────────────────────────────────────
; Acknowledgment
; ───────────────────────────────────────────────────────────────────────────────
{.acknowledgment}
buyer_acknowledged = ?                               ; Buyer acknowledged receipt
buyer_signature_date = date:if buyer_acknowledged = true
seller_provided = ?                                  ; Seller provided disclosure
seller_signature_date = date:if seller_provided = true
cancellation_right_expires = date                    ; Cancellation right expiration

{@hoa_disclosure}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (acknowledged, delivered, pending, waived)
status_date = date                                   ; Status date


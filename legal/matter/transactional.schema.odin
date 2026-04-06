; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Transactional Matter Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Transactional legal matters including mergers and acquisitions, real estate
; transactions, corporate formation/governance, commercial finance, and
; securities offerings. Covers transaction milestones, due diligence
; checklists, closing conditions, and post-closing obligations.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as legal
@import "../../common/types.schema.odin" as common
@import "../../realestate/types.schema.odin" as re

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.legal.matter.transactional"
version = "1.0.0"
title = "Transactional Matter Schema"
description = "Transactional legal matters and deal management"

{$derivation}
source[0].authority = "American Bar Association"
source[0].citation = "Business Law Section Model Documents"
source[0].url = "https://www.americanbar.org/groups/business_law/"

source[1].authority = "Uniform Task-Based Management System"
source[1].citation = "UTBMS Counseling/Transaction Code Set"
source[1].url = "https://ledes.org/utbms/"

source[2].authority = "Securities and Exchange Commission"
source[2].citation = "Securities Act and Regulation D"
source[2].url = "https://www.sec.gov/smallbusiness/exemptofferings"

source[3].authority = "American Land Title Association"
source[3].citation = "ALTA Best Practices"
source[3].url = "https://www.alta.org/best-practices/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Transactional schema derived from ABA model documents and UTBMS counseling codes"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial transactional matter schema"
changelog[0].rationale = "Comprehensive transaction tracking structure"

; ═══════════════════════════════════════════════════════════════════════════════
; TRANSACTIONAL MATTER
; ═══════════════════════════════════════════════════════════════════════════════
; Primary transactional matter record

{@transactional_matter}
; Required fields first
matter_name = !:                                  ; Matter name/description
open_date = !date                                 ; Date matter opened
transaction_type = !(acquisition, asset_purchase, commercial_lease, corporate_formation, corporate_governance, divestiture, equity_offering, financing, joint_venture, licensing, merger, real_estate_purchase, real_estate_sale, recapitalization, reorganization, securities_offering, spin_off, stock_purchase)

; Matter identification
matter_id = :                                     ; Internal matter identifier
client_matter_id = :                              ; Client's reference number
ledes_matter_id = :                               ; LEDES matter ID for billing

; Client reference
client_ref = @legal_client                        ; Reference to client record
client_role = (acquirer, borrower, buyer, investor, lender, lessor, lessee, licensee, licensor, seller, target)

; ───────────────────────────────────────────────────────────────────────────────
; Transaction Overview
; ───────────────────────────────────────────────────────────────────────────────
{.overview}
transaction_value = #$:(0..)                      ; Transaction value/deal size
currency = :(3) "USD"                             ; Transaction currency
description = :                                   ; Transaction description
confidential = ?                                  ; Confidential transaction
code_name = ::if confidential = true              ; Code name for deal

{@transactional_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Parties
; ───────────────────────────────────────────────────────────────────────────────
{.parties}
our_client_ref = @legal_client                    ; Our client
counterparties[] = @legal_party                   ; Counterparties
investors[] = @legal_party                        ; Investors (if applicable)
lenders[] = @legal_party                          ; Lenders (if applicable)
guarantors[] = @legal_party                       ; Guarantors

{@transactional_matter}

; Counsel
{.counsel}
our_team[] = @legal_attorney                      ; Our attorneys on matter
counterparty_counsel[] = @legal_opposing_counsel  ; Counterparty counsel
co_counsel[] = @legal_attorney                    ; Co-counsel
special_counsel[] = @legal_attorney               ; Special counsel (tax, IP, etc.)

{@transactional_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Key Dates
; ───────────────────────────────────────────────────────────────────────────────
{.key_dates}
engagement_date = date                            ; Date of engagement
letter_of_intent_date = date                      ; LOI execution date
loi_expiration = date                             ; LOI expiration
exclusivity_start = date                          ; Exclusivity period start
exclusivity_end = date                            ; Exclusivity period end
due_diligence_start = date                        ; DD period start
due_diligence_end = date                          ; DD period end
agreement_date = date                             ; Definitive agreement date
signing_date = date                               ; Signing date
closing_date = date                               ; Target closing date
actual_closing = date                             ; Actual closing date
termination_date = date                           ; Outside termination date

{@transactional_matter}

; Deadlines list
deadlines[] = @legal_deadline                     ; All matter deadlines

{@transactional_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Transaction Phase (UTBMS-aligned)
; ───────────────────────────────────────────────────────────────────────────────
phase = @transaction_phase                        ; Current transaction phase

{@transactional_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Due Diligence
; ───────────────────────────────────────────────────────────────────────────────
due_diligence = @due_diligence                    ; Due diligence tracking

{@transactional_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Deal Structure
; ───────────────────────────────────────────────────────────────────────────────
{.structure}
deal_structure = (asset_deal, merger, stock_deal) ; Basic structure
consideration_type = (cash, earnout, mixed, stock, stock_and_cash)
cash_portion = #$:(0..):if consideration_type != stock
stock_portion = #$:(0..):if consideration_type != cash
earnout_potential = #$:(0..):if consideration_type = earnout | consideration_type = mixed
holdback_amount = #$:(0..)                        ; Holdback/escrow
holdback_period_months = ##:(0..)                 ; Holdback period
escrow_agent = :                                  ; Escrow agent name

{@transactional_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Financing
; ───────────────────────────────────────────────────────────────────────────────
{.financing}
financing_required = ?                            ; Transaction requires financing
financing_type = (asset_based, bridge, debt, equity, mezzanine, senior_secured, subordinated):if financing_required = true
financing_amount = #$:(0..):if financing_required = true
financing_committed = ?:if financing_required = true
commitment_letter_date = date:if financing_committed = true
financing_closing_date = date:if financing_required = true

{@transactional_matter}

; Financing parties
{.financing.lenders[]}
lender_name = :                                   ; Lender name
commitment_amount = #$:(0..)                      ; Committed amount
lead_arranger = ?                                 ; Is lead arranger
facility_type = (revolver, term_a, term_b, term_c)

{@transactional_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Regulatory Approvals
; ───────────────────────────────────────────────────────────────────────────────
{.regulatory}
regulatory_approval_required = ?                  ; Regulatory approval needed

{@transactional_matter}

{.regulatory.approvals[]}
agency = :                                        ; Regulatory agency name
approval_type = (antitrust, cfius, environmental, fcc, fdic, industry, occ, sec, state)
filing_date = date                                ; Filing date
filing_fee = #$:(0..)                             ; Filing fee
waiting_period_days = ##:(0..)                    ; Waiting period
waiting_period_ends = date                        ; End of waiting period
second_request = ?                                ; Second request issued
second_request_date = date:if second_request = true
approval_received = ?                             ; Approval obtained
approval_date = date:if approval_received = true  ; Date approved
conditions = ::if approval_received = true        ; Approval conditions

{@transactional_matter}

; HSR specifics
{.regulatory.hsr}
hsr_required = ?                                  ; HSR filing required
hsr_filing_date = date:if hsr_required = true     ; HSR filing date
hsr_fee = #$:(0..):if hsr_required = true         ; HSR fee amount
early_termination_requested = ?:if hsr_required = true
early_termination_granted = ?:if early_termination_requested = true
early_termination_date = date:if early_termination_granted = true

{@transactional_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Third Party Consents
; ───────────────────────────────────────────────────────────────────────────────
{.consents[]}
consent_type = (contract, customer, employee, governmental, landlord, lender, license, supplier)
party_name = :                                    ; Party whose consent needed
description = :                                   ; What consent is for
required = ?                                      ; Consent is required
requested_date = date                             ; Date consent requested
received = ?                                      ; Consent received
received_date = date:if received = true           ; Date received
conditions = ::if received = true                 ; Any conditions

{@transactional_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Closing Conditions
; ───────────────────────────────────────────────────────────────────────────────
{.closing_conditions[]}
condition_type = (bring_down, consent, financing, mac, opinion, regulatory, representation, third_party)
description = :                                   ; Condition description
party_responsible = (buyer, mutual, seller)       ; Party responsible
satisfied = ?                                     ; Condition satisfied
satisfaction_date = date:if satisfied = true      ; Date satisfied
waived = ?                                        ; Condition waived
waiver_date = date:if waived = true               ; Date waived

{@transactional_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Documents
; ───────────────────────────────────────────────────────────────────────────────
{.documents}
letter_of_intent = ?                              ; LOI executed
term_sheet = ?                                    ; Term sheet executed
nda_executed = ?                                  ; NDA in place
nda_date = date:if nda_executed = true            ; NDA date
definitive_agreement = ?                          ; Definitive agreement executed
agreement_type = (asset_purchase, merger, stock_purchase):if definitive_agreement = true
agreement_date = date:if definitive_agreement = true
schedules_complete = ?                            ; Disclosure schedules complete
ancillary_docs_list[] = :                         ; List of ancillary documents

{@transactional_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Closing
; ───────────────────────────────────────────────────────────────────────────────
{.closing}
closing_checklist_complete = ?                    ; Checklist complete
funds_wired = ?                                   ; Funds transferred
funds_confirmed = ?                               ; Funds receipt confirmed
documents_executed = ?                            ; All docs executed
filings_made = ?                                  ; Required filings made
closing_binder_complete = ?                       ; Closing binder done
post_closing_items_count = ##:(0..)               ; Post-closing items

{@transactional_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Post-Closing
; ───────────────────────────────────────────────────────────────────────────────
{.post_closing[]}
item_description = :                              ; Post-closing item
responsible_party = (buyer, mutual, seller)       ; Party responsible
due_date = date                                   ; Due date
completed = ?                                     ; Item completed
completed_date = date:if completed = true         ; Date completed

{@transactional_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Real Estate (if real estate transaction)
; ───────────────────────────────────────────────────────────────────────────────
{.real_estate}
property_ref = @legal_property_ref:if transaction_type = real_estate_purchase | transaction_type = real_estate_sale | transaction_type = commercial_lease
purchase_price = #$:(0..)                         ; Purchase price
earnest_money = #$:(0..)                          ; Earnest money deposit
title_commitment_received = ?                     ; Title commitment received
survey_ordered = ?                                ; Survey ordered
survey_received = ?                               ; Survey received
environmental_phase_i = ?                         ; Phase I completed
environmental_phase_ii = ?                        ; Phase II required
zoning_confirmed = ?                              ; Zoning confirmed

{@transactional_matter}

; Bridge to real estate schemas
title_commitment_ref = :                          ; Title commitment reference
mortgage_ref = :                                  ; Mortgage/loan reference

{@transactional_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Related Matters
; ───────────────────────────────────────────────────────────────────────────────
{.related_matters[]}
related_matter_id = :                             ; Related matter ID
relationship = (ancillary, financing, related_transaction, regulatory, spin_off)
description = :                                   ; Relationship description

{@transactional_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = @legal_matter_status                     ; Matter status

; Transaction-specific outcome
outcome = (closed, terminated_by_buyer, terminated_by_seller, terminated_mutual, terminated_regulatory, terminated_financing)
outcome_date = date:if status.status = closed     ; Date of outcome

; ═══════════════════════════════════════════════════════════════════════════════
; TRANSACTION PHASE
; ═══════════════════════════════════════════════════════════════════════════════
; Transaction phase tracking (UTBMS-aligned)

{@transaction_phase}
; Current phase (UTBMS Project/Counseling Phases)
current_phase = !(P100_assessment, P110_strategy, P120_planning, P200_negotiation, P210_due_diligence, P220_documentation, P300_regulatory, P310_consents, P400_closing_prep, P410_closing, P500_post_closing)

; Phase details
phase_start_date = date                           ; When phase started
phase_end_date = date                             ; When phase ended (if complete)
phase_complete = ?                                ; Phase is complete

; Phase-specific status notes
phase_notes = :                                   ; Notes about current phase

; ═══════════════════════════════════════════════════════════════════════════════
; DUE DILIGENCE
; ═══════════════════════════════════════════════════════════════════════════════
; Due diligence tracking

{@due_diligence}
; Due diligence dates
dd_start_date = date                              ; DD start date
dd_end_date = date                                ; DD end date
dd_extended = ?                                   ; DD extended
extended_end_date = date:if dd_extended = true    ; Extended end date

; Data room
{.data_room}
data_room_type = (hosted, physical, virtual)      ; Type of data room
provider = :                                      ; Data room provider
access_granted_date = date                        ; When access granted
document_count = ##:(0..)                         ; Documents in data room
updated = date                                    ; Last update date

{@due_diligence}

; Due diligence streams
{.streams[]}
stream_name = :                                   ; DD stream name
stream_type = (corporate, employment, environmental, financial, insurance, intellectual_property, it, legal, operational, real_estate, regulatory, tax)
lead_attorney = :                                 ; Lead attorney for stream
start_date = date                                 ; Stream start date
target_completion = date                          ; Target completion
complete = ?                                      ; Stream complete
completion_date = date:if complete = true         ; Actual completion date
issues_found = ##:(0..)                           ; Issues identified

{@due_diligence}

; Request lists
{.requests[]}
request_number = ##:(1..)                         ; Request number
request_date = date                               ; Date of request
description = :                                   ; What was requested
stream = :                                        ; Which DD stream
priority = (high, low, medium)                    ; Priority level
response_due = date                               ; Response due date
response_received = ?                             ; Response received
response_date = date:if response_received = true  ; Date response received
follow_up_needed = ?                              ; Follow-up required

{@due_diligence}

; Issues
{.issues[]}
issue_number = ##:(1..)                           ; Issue number
category = (business, financial, legal, operational, regulatory, tax)
severity = (critical, high, low, medium)          ; Severity level
description = :                                   ; Issue description
identified_date = date                            ; When identified
identified_by = :                                 ; Who identified
recommendation = :                                ; Recommended action
resolution = (accepted, indemnity, price_adjustment, representation, resolved, termination_right, waived)
resolved = ?                                      ; Issue resolved
resolution_date = date:if resolved = true         ; Date resolved

{@due_diligence}

; Reports
{.reports[]}
report_name = :                                   ; Report name
report_type = (dd_report, executive_summary, issues_list, red_flag_report)
author = :                                        ; Report author
date = date                                       ; Report date
stream = :                                        ; Related DD stream

{@due_diligence}

; ═══════════════════════════════════════════════════════════════════════════════
; TRANSACTION MILESTONE
; ═══════════════════════════════════════════════════════════════════════════════
; Key transaction milestones

{@transaction_milestone}
; Required fields first
milestone_name = !:                               ; Milestone name
milestone_type = !(closing, dd_completion, definitive_agreement, exclusivity, filing, financing, first_draft, loi, negotiation, regulatory_approval, signing, term_sheet)
target_date = !date                               ; Target date

; Milestone identification
milestone_id = :                                  ; Unique milestone identifier

; Status
status = (at_risk, completed, delayed, on_track, pending)
actual_date = date:if status = completed          ; Actual completion date
delay_reason = ::if status = delayed              ; Reason for delay
revised_target = date:if status = delayed         ; Revised target date

; Dependencies
{.dependencies[]}
depends_on = :                                    ; Milestone this depends on
dependency_type = (blocking, informational, sequential)

{@transaction_milestone}


; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Escrow Holdback Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Escrow holdbacks and reserve accounts for real estate transactions. Covers
; repair, construction, tax/lien, dispute, and seller proceeds holdbacks with
; release conditions, balance tracking, and ongoing escrow/impound accounts
; for taxes and insurance.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as common
@import "../types.schema.odin" as re

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.realestate.escrow.holdback"
version = "1.0.0"
title = "Escrow Holdback Schema"
description = "Escrow holdback and reserve account management"

{$derivation}
source[0].authority = "American Land Title Association"
source[0].citation = "ALTA Best Practices Framework"
source[0].url = "https://www.alta.org/best-practices/"

source[1].authority = "Fannie Mae"
source[1].citation = "Selling Guide - Escrow Holdbacks for Repairs"
source[1].url = "https://selling-guide.fanniemae.com/"

source[2].authority = "State Escrow Regulations"
source[2].citation = "Escrow and Trust Account Requirements"
source[2].url = "varies by jurisdiction"

methodology = "industry_practice"
proprietary_sources_consulted = ?false
notes = "Holdback schema derived from title industry best practices and lender requirements"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial holdback schema"
changelog[0].rationale = "Comprehensive escrow holdback structure"

; ═══════════════════════════════════════════════════════════════════════════════
; ESCROW HOLDBACK
; ═══════════════════════════════════════════════════════════════════════════════
; Escrow holdback agreement and tracking

{@escrow_holdback}
; Required fields first
establishment_date = !date                           ; Date holdback established
holdback_amount = !#$:(0..)                          ; Total holdback amount
holdback_type = !(completion, construction, dispute, lien_payoff, repair, seller_proceeds, tax, warranty)
property_address = !@address                         ; Property address

; Holdback identification
holdback_id = :                                      ; Unique holdback identifier
escrow_number = :                                    ; Escrow/file number
transaction_ref = :                                  ; Reference to transaction

; ───────────────────────────────────────────────────────────────────────────────
; Parties
; ───────────────────────────────────────────────────────────────────────────────
{.parties}
escrow_holder = :                                    ; Escrow holder/agent name
escrow_holder_address = @address                     ; Escrow holder address
depositor = :                                        ; Party depositing funds
beneficiary = :                                      ; Party to receive funds
additional_parties[] = :                             ; Other interested parties

{@escrow_holdback}

; ───────────────────────────────────────────────────────────────────────────────
; Holdback Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
purpose = :                                          ; Detailed purpose description
source_of_funds = (buyer, lender, seller, third_party)
funded_date = date                                   ; Date funds received
funding_method = (cashiers_check, check, wire)       ; How funds were received
account_number = *:                                   ; Trust account number
interest_bearing = ?                                 ; Interest-bearing account
interest_rate = #:(0..100):if interest_bearing = true
interest_beneficiary = ::if interest_bearing = true  ; Who receives interest

{@escrow_holdback}

; ───────────────────────────────────────────────────────────────────────────────
; Release Conditions
; ───────────────────────────────────────────────────────────────────────────────
{.release_conditions}
release_type = !(completion_certification, document_recording, full_satisfaction, lien_release, mutual_consent, time_based)
expiration_date = date                               ; Holdback expiration date
automatic_release = ?                                ; Automatic release at expiration
release_authorization = (escrow_holder, lender, mutual, single_party)
required_signatures = ##:(1..)                       ; Signatures required
conditions_description = :                           ; Detailed conditions

{@escrow_holdback}

; Specific conditions
{.release_conditions.items[]}
condition = :                                        ; Condition description
required_documentation = :                           ; Required docs
responsible_party = :                                ; Party responsible
due_date = date                                      ; Due date for condition
satisfied = ?                                        ; Condition satisfied
satisfied_date = date:if satisfied = true            ; Date satisfied

{@escrow_holdback}

; ───────────────────────────────────────────────────────────────────────────────
; Repair Holdback Specific
; ───────────────────────────────────────────────────────────────────────────────
{.repair}
repair_type = (appraisal_required, inspection_required, lender_required, seller_agreed):if holdback_type = repair
contractor_name = ::if holdback_type = repair        ; Contractor name
contractor_license = ::if holdback_type = repair     ; Contractor license
estimated_cost = #$:(0..):if holdback_type = repair  ; Estimated repair cost
cushion_percent = #:(0..100):if holdback_type = repair  ; Cushion percentage
completion_deadline = date:if holdback_type = repair ; Completion deadline
inspection_required = ?:if holdback_type = repair    ; Inspection required
inspector = ::if holdback_type = repair              ; Inspector name/company

{@escrow_holdback}

; Repair items
{.repair.items[]}
item = :                                             ; Repair item description
estimated_cost = #$:(0..)                            ; Estimated cost
actual_cost = #$:(0..)                               ; Actual cost (when known)
completed = ?                                        ; Item completed
completion_date = date:if completed = true           ; Completion date
inspected = ?                                        ; Item inspected
passed_inspection = ?:if inspected = true            ; Passed inspection

{@escrow_holdback}

; ───────────────────────────────────────────────────────────────────────────────
; Construction Holdback Specific
; ───────────────────────────────────────────────────────────────────────────────
{.construction}
project_type = (addition, new_construction, renovation):if holdback_type = construction
total_project_cost = #$:(0..):if holdback_type = construction
retainage_percent = #:(0..100):if holdback_type = construction
draw_schedule = ?:if holdback_type = construction    ; Draw schedule in place
completion_percentage = #:(0..100):if holdback_type = construction
certificate_of_occupancy_required = ?:if holdback_type = construction

{@escrow_holdback}

; Construction draws
{.construction.draws[]}
draw_number = ##:(1..)                               ; Draw number
draw_date = date                                     ; Draw request date
draw_amount = #$:(0..)                               ; Amount requested
inspection_date = date                               ; Inspection date
approved_amount = #$:(0..)                           ; Approved amount
disbursement_date = date                             ; Disbursement date
percentage_complete = #:(0..100)                     ; Percentage complete after draw

{@escrow_holdback}

; ───────────────────────────────────────────────────────────────────────────────
; Lien/Tax Holdback Specific
; ───────────────────────────────────────────────────────────────────────────────
{.lien}
lien_type = (federal_tax, hoa, mechanics, state_tax, tax, utility):if holdback_type = lien_payoff | holdback_type = tax
lienholder = ::if holdback_type = lien_payoff        ; Lienholder name
lien_amount = #$:(0..):if holdback_type = lien_payoff
lien_recording_info = ::if holdback_type = lien_payoff
expected_payoff_date = date:if holdback_type = lien_payoff
release_recording_required = ?:if holdback_type = lien_payoff

{@escrow_holdback}

; ───────────────────────────────────────────────────────────────────────────────
; Dispute Holdback Specific
; ───────────────────────────────────────────────────────────────────────────────
{.dispute}
dispute_type = (boundary, commission, contract, property_condition, title):if holdback_type = dispute
dispute_description = ::if holdback_type = dispute
parties_involved[] = ::if holdback_type = dispute
resolution_method = (arbitration, litigation, mediation, negotiation):if holdback_type = dispute
deadline_for_resolution = date:if holdback_type = dispute

{@escrow_holdback}

; ───────────────────────────────────────────────────────────────────────────────
; Balance Tracking
; ───────────────────────────────────────────────────────────────────────────────
{.balance}
original_amount = #$:(0..)                           ; Original holdback amount
interest_accrued = #$:(0..)                          ; Interest accrued
total_released = #$:(0..)                            ; Total released to date
total_disbursed = #$:(0..)                           ; Total disbursed (repairs, etc.)
current_balance = #$:(0..)                           ; Current balance
pending_releases = #$:(0..)                          ; Pending release amounts

{@escrow_holdback}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, cancelled, disputed, expired, fully_released, partial_release, pending)
status_date = date                                   ; Status date
cancellation_reason = ::if status = cancelled        ; Cancellation reason

; ═══════════════════════════════════════════════════════════════════════════════
; HOLDBACK RELEASE
; ═══════════════════════════════════════════════════════════════════════════════
; Release of holdback funds

{@holdback_release}
; Required fields first
release_amount = !#$:(0..)                           ; Amount being released
release_date = !date                                 ; Release date
release_type = !(final, partial)                     ; Release type

; Release identification
release_id = :                                       ; Unique release identifier
release_number = ##:(1..)                            ; Sequential release number

; Holdback reference
holdback_ref = @escrow_holdback                      ; Reference to holdback

; ───────────────────────────────────────────────────────────────────────────────
; Release Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
payee_name = :                                       ; Payee name
payee_address = @address                             ; Payee address
payment_method = (ach, cashiers_check, check, wire)  ; Payment method
reference_number = :                                 ; Check/wire reference
conditions_satisfied = :                             ; Conditions satisfied for release
documentation_received = :                           ; Documentation received

{@holdback_release}

; ───────────────────────────────────────────────────────────────────────────────
; Authorization
; ───────────────────────────────────────────────────────────────────────────────
{.authorization}
authorized_by = :                                    ; Authorizing party
authorization_date = date                            ; Authorization date
authorization_method = (email, in_person, mail, portal)
co_authorization_required = ?                        ; Co-authorization required
co_authorized_by = ::if co_authorization_required = true
co_authorization_date = date:if co_authorization_required = true

{@holdback_release}

; ───────────────────────────────────────────────────────────────────────────────
; Balance After Release
; ───────────────────────────────────────────────────────────────────────────────
{.balance}
prior_balance = #$:(0..)                             ; Balance before release
release_amount = #$:(0..)                            ; Amount released
remaining_balance = #$:(0..)                         ; Balance after release
final_release = ?                                    ; Final release

{@holdback_release}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (cancelled, completed, pending, processing)
status_date = date                                   ; Status date

; ═══════════════════════════════════════════════════════════════════════════════
; ESCROW ACCOUNT
; ═══════════════════════════════════════════════════════════════════════════════
; Ongoing escrow/impound account for taxes and insurance

{@escrow_account}
; Required fields first
account_type = !(loan_escrow, pmi, property_tax, reserve)
property_address = !@address                         ; Property address

; Account identification
account_id = :                                       ; Unique account identifier
loan_number = :                                      ; Associated loan number

; ───────────────────────────────────────────────────────────────────────────────
; Account Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
servicer_name = :                                    ; Loan servicer
servicer_address = @address                          ; Servicer address
establishment_date = date                            ; Account start date
monthly_payment = #$:(0..)                           ; Monthly escrow payment
current_balance = #$:(0..)                           ; Current balance
required_balance = #$:(0..)                          ; Required minimum balance
cushion_months = ##:(0..6)                           ; Cushion months (max 2 per RESPA)
cushion_amount = #$:(0..)                            ; Cushion amount

{@escrow_account}

; ───────────────────────────────────────────────────────────────────────────────
; Escrowed Items
; ───────────────────────────────────────────────────────────────────────────────
{.items[]}
item_type = (flood_insurance, hazard_insurance, hoa_dues, mortgage_insurance, property_tax)
payee = :                                            ; Payee name
annual_amount = #$:(0..)                             ; Annual amount
monthly_accrual = #$:(0..)                           ; Monthly accrual
next_due_date = date                                 ; Next payment due
payment_frequency = (annual, monthly, quarterly, semi_annual)
last_payment_date = date                             ; Last payment made
last_payment_amount = #$:(0..)                       ; Last payment amount

{@escrow_account}

; ───────────────────────────────────────────────────────────────────────────────
; Analysis
; ───────────────────────────────────────────────────────────────────────────────
{.analysis}
analysis_date = date                                 ; Date of last analysis
analysis_period_start = date                         ; Analysis period start
analysis_period_end = date                           ; Analysis period end
projected_disbursements = #$:(0..)                   ; Total projected disbursements
projected_deposits = #$:(0..)                        ; Total projected deposits
projected_low_point = #$:(0..)                       ; Projected lowest balance
shortage_amount = #$:(0..)                           ; Shortage amount
surplus_amount = #$:(0..)                            ; Surplus amount
payment_change = #$                                  ; Monthly payment change
new_monthly_payment = #$:(0..)                       ; New monthly payment

{@escrow_account}

; ───────────────────────────────────────────────────────────────────────────────
; Transaction History
; ───────────────────────────────────────────────────────────────────────────────
{.transactions[]}
transaction_date = date                              ; Transaction date
transaction_type = (adjustment, deposit, disbursement, refund)
description = :                                      ; Description
amount = #$                                          ; Amount (positive or negative)
balance_after = #$:(0..)                             ; Balance after transaction
payee = :                                            ; Payee (for disbursements)

{@escrow_account}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, closed, shortage, surplus)
status_date = date                                   ; Status date


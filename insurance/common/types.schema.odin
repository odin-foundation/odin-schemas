; ===============================================================================
; ODIN Insurance Common Types
; ===============================================================================
; Insurance-specific type definitions shared across all lines of business including
; auto, home, and commercial. Universal types such as address, email, phone, and
; money are defined in schemas/common/types.schema.odin.
; ===============================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.common.types"
version = "1.0.0"
title = "Insurance Common Types"
description = "Insurance-specific type definitions for all insurance lines"

changelog[0].date = 2025-12-13
changelog[0].change = "Initial common types schema"

changelog[1].date = 2025-12-20
changelog[1].change = "Remove duplicate types now in common/types.schema.odin"

; ===============================================================================
; PREMIUM TYPE
; ===============================================================================
; Insurance premium amounts with payment basis.

{@premium}
; Required fields first
amount = #$:(0..)                               ; Premium amount

; Optional fields
basis = (annual, monthly, quarterly, semi_annual, term)  ; Payment frequency
currency = :(3) "USD"                            ; ISO 4217 currency code

; ===============================================================================
; PAYMENT TYPE
; ===============================================================================
; Payment transaction record.

{@payment}
; Required fields first
amount = #$:(0..)                               ; Payment amount

; Optional fields
currency = :(3) "USD"                            ; ISO 4217 currency code
due = date                                       ; Payment due date
method = (ach, card, cash, check, eft, payroll)  ; Payment method
paid = date                                      ; Date payment received
reference = :                                    ; Payment reference number

; ===============================================================================
; EMPLOYMENT TYPE
; ===============================================================================
; Employment information for insureds.

{@employment}
; Optional fields (employment may be unknown)
employer_address = @address                      ; Employer address
employer_name = :                                ; Employer company name
employer_phone = *@phone                         ; Employer phone
industry_code = :(3)                             ; Industry classification code
months_employed = ##                             ; Months at current employer
occupation = :                                   ; Job title or occupation
since = date                                     ; Employment start date
status = (employed, homemaker, military, retired, self_employed, student, unemployed)

; ===============================================================================
; RESIDENCE TYPE
; ===============================================================================
; Current residence information for insureds.

{@residence}
; Optional fields
months_at_address = ##                           ; Months at current residence
ownership = (lease, live_with_family, other, own, rent)  ; Occupancy type
type = (apartment, condo, house, mobile_home, other, townhouse)  ; Dwelling type
years_at_address = ##                            ; Years at current residence

; ===============================================================================
; POLICY NOTE TYPE
; ===============================================================================
; Universal note structure for any policy type.

{@policy_note}
; Required fields first
content = :                                     ; Note content text
date = timestamp                                ; Note creation timestamp
type = (audit, billing, claims, compliance, general, service, system, underwriting)

; Optional fields
attachments[] = :                                ; Document reference identifiers
category = :                                     ; Custom categorization
created_by = :                                   ; User who created note
id = :                                           ; Unique note identifier
internal_only = ?                                ; Not visible to insured
priority = (high, low, normal, urgent)           ; Note priority level
sequence = ##:(1..)                              ; Note sequence number
subject = :                                      ; Note subject line

; -------------------------------------------------------------------------------
; Follow-up
; -------------------------------------------------------------------------------
{.follow_up}
assigned = :                                     ; User assigned for follow-up
completed = ?                                    ; Follow-up completion flag
completed_date = date                            ; Date follow-up completed
date = date                                      ; Follow-up due date
required = ?                                     ; Follow-up required flag

; ===============================================================================
; UNDERWRITING DECISION TYPE
; ===============================================================================
; Universal underwriting structure for any policy type.

{@underwriting_decision}
; Required fields first
status = (approved, cancelled, declined, moratorium, pending, referred)

; Optional fields
decision_by = :                                  ; User who made decision
decision_date = date                             ; Date of decision
id = :                                           ; Decision record identifier
review_reason = :                                ; Reason for review requirement
review_required = ?                              ; Manual review required flag
risk_score = ##:(0..1000)                        ; Calculated risk score
risk_tier = :                                    ; Risk classification tier
tier_override = ?                                ; Tier override applied flag
tier_override_approved_by = :                    ; User who approved override
tier_override_reason = :                         ; Reason for tier override
underwriter = :                                  ; Assigned underwriter name

; -------------------------------------------------------------------------------
; Referral Details
; -------------------------------------------------------------------------------
{.referral}
date = date                                      ; Date referred
reason = :                                       ; Reason for referral
referred = ?                                     ; Referral flag
to = :                                           ; Referred to user/department

; -------------------------------------------------------------------------------
; Reports Ordered
; -------------------------------------------------------------------------------
{.reports}
clue = ?                                         ; CLUE report ordered
clue_date = date                                 ; CLUE order date
clue_status = (error, not_found, pending, received)
credit = ?                                       ; Credit report ordered
credit_date = date                               ; Credit order date
credit_status = (error, frozen, not_found, pending, received)
inspection = ?                                   ; Inspection ordered
inspection_date = date                           ; Inspection order date
inspection_status = (failed, passed, pending, waived)
mvr = ?                                          ; MVR report ordered
mvr_date = date                                  ; MVR order date
mvr_status = (error, not_found, pending, received)

{@underwriting_decision}
; -------------------------------------------------------------------------------
; Decline Details
; -------------------------------------------------------------------------------
decline_reason = (
    fraud_indicator,
    moratorium,
    other,
    outside_appetite,
    prior_cancellation,
    prior_claims,
    regulatory,
    risk_too_high,
    unacceptable_risk
):if status = declined
decline_reason_detail = :                        ; Detailed decline explanation

; ===============================================================================
; MARKETING SOURCE TYPE
; ===============================================================================
; Marketing attribution for lead tracking.

{@marketing_source}
; Optional fields (all marketing data is optional)
acquisition_cost = #$:(0..)                      ; Cost to acquire this lead
campaign_id = :                                  ; Marketing campaign identifier
campaign_name = :                                ; Marketing campaign name
channel = (agency, direct, mail, online, other, phone, referral)
commission_override = #:(0..100)                 ; Commission percentage override
contact_source = :                               ; How customer contacted us
first_contact = date                             ; Initial contact date
id = :                                           ; Marketing source identifier
lead_source = :                                  ; Where lead originated
marketing_code = :                               ; Campaign tracking code
quote = date                                     ; Quote request date
quote_template = :                               ; Quote template used
referral_name = :                                ; Name of referring party
referral_policy = :                              ; Referring policy number
referral_type = (agent, customer, employee, none, other, partner)

; ===============================================================================
; EXTERNAL REFERENCE TYPE
; ===============================================================================
; Integration reference for external systems.

{@external_reference}
; Required fields first
reference_value = :                             ; Reference identifier value
system = :                                      ; External system name

; Optional fields
created = timestamp                              ; Reference creation timestamp
created_by = :                                   ; User who created reference
id = :                                           ; Internal reference identifier
reference_type = :                               ; Type of reference (policy_id, customer_id, etc.)
sync_direction = (bidirectional, inbound, outbound)  ; Data sync direction
sync_error = :                                   ; Last sync error message
sync_status = (error, never, pending, success)   ; Current sync status
synced = timestamp                               ; Last successful sync timestamp
system_type = (accounting, agency_management, claims, crm, document_management, other, rating_engine)

; ===============================================================================
; STATUS ENUMS (Canonical Definitions)
; ===============================================================================
; These are the canonical status values. Other schemas should reference these.

{@entity_status}
; Universal entity status for records
status = (active, deleted, inactive, pending, suspended)

{@policy_status}
; Policy lifecycle status
status = (active, application, bound, cancelled, expired, non_renewed, pending, quote, reinstated, suspended)

{@claim_status}
; Claim workflow status (workflow order, not alphabetical)
status = (
    ; Initial reporting
    reported,
    ; Assignment phase
    assigned,
    ; Investigation phase
    investigation,
    coverage_review,
    ; Evaluation phase
    evaluation,
    negotiation,
    ; Resolution phase
    accepted,
    denied,
    offered,
    settled,
    ; Closure phase
    closed_no_payment,
    closed_paid,
    ; Post-closure
    litigation,
    reopened,
    subrogation
)

{@license_status}
; Driver license status
status = (disqualified, expired, revoked, suspended, valid)


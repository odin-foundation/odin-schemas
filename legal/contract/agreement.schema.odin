; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Contract Agreement Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Contract lifecycle management for legal practice covering commercial,
; employment, licensing, service, and confidentiality agreements. Includes
; clause tracking, obligation management, amendment history, and renewal
; workflows.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as legal
@import "../../common/types.schema.odin" as common

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.legal.contract.agreement"
version = "1.0.0"
title = "Contract Agreement Schema"
description = "Contract lifecycle management and tracking"

{$derivation}
source[0].authority = "American Bar Association"
source[0].citation = "Model Contract Standards"
source[0].url = "https://www.americanbar.org/groups/business_law/"

source[1].authority = "International Association for Contract & Commercial Management"
source[1].citation = "IACCM Contract Management Standards"
source[1].url = "https://www.iaccm.com/"

source[2].authority = "Uniform Commercial Code"
source[2].citation = "UCC Article 2 - Sales"
source[2].url = "https://www.law.cornell.edu/ucc"

methodology = "industry_practice"
proprietary_sources_consulted = ?false
notes = "Contract schema derived from ABA standards and IACCM best practices"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial contract agreement schema"
changelog[0].rationale = "Comprehensive contract lifecycle tracking"

; ═══════════════════════════════════════════════════════════════════════════════
; CONTRACT AGREEMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Primary contract record

{@contract_agreement}
; Required fields first
agreement_type = (consulting, distribution, employment, franchise, joint_venture, lease, license, loan, msa, nda, partnership, purchase, saas, sales, service, settlement, subscription, supply)
contract_name = :                                ; Contract name/title
effective_date = date                            ; Effective date

; Contract identification
contract_id = :                                   ; Internal contract ID
contract_number = :                               ; Contract number
client_contract_ref = :                           ; Client's reference number

; ───────────────────────────────────────────────────────────────────────────────
; Parties
; ───────────────────────────────────────────────────────────────────────────────
{.parties}
our_client = @legal_client                        ; Our client
client_role = (both, buyer, licensor, licensee, provider, recipient, seller, service_provider, supplier)
counterparty = @legal_party                       ; Counterparty
counterparty_role = :                             ; Counterparty role

{@contract_agreement}

; Additional parties
{.parties.additional[]}
party_name = :                                    ; Party name
party_ref = @legal_party                          ; Party reference
role = :                                          ; Role in contract
guarantor = ?                                     ; Is guarantor

{@contract_agreement}

; ───────────────────────────────────────────────────────────────────────────────
; Term
; ───────────────────────────────────────────────────────────────────────────────
{.term}
term_type = (auto_renewal, fixed, indefinite, perpetual)
start_date = date                                 ; Term start date
end_date = date:if term_type = fixed | term_type = auto_renewal
initial_term_months = ##:(0..):if term_type != perpetual
renewal_term_months = ##:(0..):if term_type = auto_renewal
max_renewals = ##:(0..):if term_type = auto_renewal
current_renewal = ##:(0..):if term_type = auto_renewal
notice_period_days = ##:(0..)                     ; Termination notice period
auto_renewal_notice_days = ##:(0..):if term_type = auto_renewal

{@contract_agreement}

; ───────────────────────────────────────────────────────────────────────────────
; Value
; ───────────────────────────────────────────────────────────────────────────────
{.value}
contract_value = #$:(0..)                         ; Total contract value
currency = :(3) "USD"                             ; Currency code
annual_value = #$:(0..)                           ; Annual value
payment_terms_days = ##:(0..)                     ; Payment terms (net days)
payment_frequency = (annual, milestone, monthly, one_time, quarterly)

{@contract_agreement}

; ───────────────────────────────────────────────────────────────────────────────
; Execution
; ───────────────────────────────────────────────────────────────────────────────
{.execution}
execution_date = date                             ; Date executed
execution_method = (electronic, physical, wet_signature)
fully_executed = ?                                ; All parties signed
our_signatory = :                                 ; Our client's signatory
our_signatory_title = :                           ; Signatory title
counterparty_signatory = :                        ; Counterparty signatory
counterparty_signatory_title = :                  ; Signatory title
notarization_required = ?                         ; Notarization needed
notarized = ?:if notarization_required = true     ; Was notarized
witness_required = ?                              ; Witnesses required
witness_count = ##:(0..):if witness_required = true

{@contract_agreement}

; ───────────────────────────────────────────────────────────────────────────────
; Governing Law
; ───────────────────────────────────────────────────────────────────────────────
{.governing_law}
governing_law = :                                 ; Governing law (state/country)
jurisdiction = :                                  ; Exclusive jurisdiction
venue = :                                         ; Venue
choice_of_forum = ?                               ; Forum selection clause
arbitration_clause = ?                            ; Mandatory arbitration
arbitration_rules = ::if arbitration_clause = true
arbitration_seat = ::if arbitration_clause = true

{@contract_agreement}

; ───────────────────────────────────────────────────────────────────────────────
; Key Terms
; ───────────────────────────────────────────────────────────────────────────────
{.key_terms}
; Liability
limitation_of_liability = ?                       ; Limitation of liability exists
liability_cap = #$:(0..):if limitation_of_liability = true
liability_cap_type = (contract_value, fixed, insurance, revenue):if limitation_of_liability = true
consequential_damages_waiver = ?                  ; Consequential damages waived
indemnification = ?                               ; Indemnification clause

; Confidentiality
confidentiality_clause = ?                        ; Confidentiality provisions
confidentiality_term_months = ##:(0..):if confidentiality_clause = true
mutual_confidentiality = ?:if confidentiality_clause = true

; IP
ip_ownership_clause = ?                           ; IP ownership provisions
work_for_hire = ?:if ip_ownership_clause = true
license_grant = ?:if ip_ownership_clause = true

; Non-compete/Non-solicit
non_compete = ?                                   ; Non-compete clause
non_compete_term_months = ##:(0..):if non_compete = true
non_compete_geography = ::if non_compete = true
non_solicit = ?                                   ; Non-solicitation clause
non_solicit_term_months = ##:(0..):if non_solicit = true

{@contract_agreement}

; ───────────────────────────────────────────────────────────────────────────────
; Clauses
; ───────────────────────────────────────────────────────────────────────────────
clauses[] = @contract_clause                      ; Contract clauses

{@contract_agreement}

; ───────────────────────────────────────────────────────────────────────────────
; Obligations
; ───────────────────────────────────────────────────────────────────────────────
obligations[] = @contract_obligation              ; Contract obligations

{@contract_agreement}

; ───────────────────────────────────────────────────────────────────────────────
; Milestones
; ───────────────────────────────────────────────────────────────────────────────
milestones[] = @contract_milestone                ; Contract milestones

{@contract_agreement}

; ───────────────────────────────────────────────────────────────────────────────
; Amendments
; ───────────────────────────────────────────────────────────────────────────────
amendments[] = @contract_amendment                ; Contract amendments

{@contract_agreement}

; ───────────────────────────────────────────────────────────────────────────────
; Related Documents
; ───────────────────────────────────────────────────────────────────────────────
{.documents}
master_agreement = ?                              ; Is a master agreement
master_agreement_ref = ::if master_agreement = false ; Ref to master agreement
statement_of_work = ?                             ; SOW attached
exhibits[] = :                                    ; List of exhibits
schedules[] = :                                   ; List of schedules
addenda[] = :                                     ; List of addenda

{@contract_agreement}

; ───────────────────────────────────────────────────────────────────────────────
; Insurance Requirements
; ───────────────────────────────────────────────────────────────────────────────
{.insurance}
insurance_required = ?                            ; Insurance requirements
gl_minimum = #$:(0..):if insurance_required = true
auto_minimum = #$:(0..):if insurance_required = true
professional_minimum = #$:(0..):if insurance_required = true
workers_comp_required = ?:if insurance_required = true
additional_insured = ?:if insurance_required = true
certificate_on_file = ?:if insurance_required = true

{@contract_agreement}

; ───────────────────────────────────────────────────────────────────────────────
; Compliance
; ───────────────────────────────────────────────────────────────────────────────
{.compliance}
regulatory_compliance = ?                         ; Regulatory requirements
compliance_requirements[] = :                     ; Specific requirements
audit_rights = ?                                  ; Audit rights included
data_protection = ?                               ; Data protection provisions
gdpr_applicable = ?:if data_protection = true     ; GDPR applies
ccpa_applicable = ?:if data_protection = true     ; CCPA applies

{@contract_agreement}

; ───────────────────────────────────────────────────────────────────────────────
; Alerts and Reminders
; ───────────────────────────────────────────────────────────────────────────────
{.alerts}
renewal_alert_date = date                         ; Renewal reminder date
termination_notice_date = date                    ; Termination notice deadline
expiration_alert_date = date                      ; Expiration reminder
custom_alerts[] = :                               ; Custom alert dates

{@contract_agreement}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, amended, breached, draft, expired, negotiation, renewed, superseded, terminated)
status_date = date                                ; Date of status
termination_date = date:if status = terminated    ; Termination date
termination_reason = ::if status = terminated     ; Termination reason
terminated_by = ::if status = terminated          ; Who terminated
breach_description = ::if status = breached       ; Breach description

; ═══════════════════════════════════════════════════════════════════════════════
; CONTRACT CLAUSE
; ═══════════════════════════════════════════════════════════════════════════════
; Individual contract clause

{@contract_clause}
; Required fields first
clause_type = (amendment, arbitration, assignment, audit, choice_of_law, confidentiality, definitions, dispute_resolution, entire_agreement, force_majeure, governing_law, indemnification, insurance, ip_ownership, limitation_of_liability, non_compete, non_disclosure, non_solicitation, notice, payment_terms, renewal, severability, survival, term, termination, waiver, warranty)
clause_text = :                                  ; Clause text

; Clause identification
clause_id = :                                     ; Unique clause ID
section_number = :                                ; Section/article number

; ───────────────────────────────────────────────────────────────────────────────
; Clause Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
summary = :                                       ; Plain language summary
our_position = (favorable, mutual, unfavorable)   ; Position assessment
negotiated = ?                                    ; Was negotiated
standard_clause = ?                               ; Standard/boilerplate
deviation_from_standard = ::if standard_clause = true ; Deviation description

{@contract_clause}

; ───────────────────────────────────────────────────────────────────────────────
; Key Provisions
; ───────────────────────────────────────────────────────────────────────────────
{.provisions}
monetary_value = #$:(0..)                         ; Monetary value (if applicable)
time_period_months = ##:(0..)                     ; Time period (if applicable)
geographic_scope = :                              ; Geographic scope (if applicable)

{@contract_clause}

; Status
active = ?                                        ; Clause is active

; ═══════════════════════════════════════════════════════════════════════════════
; CONTRACT OBLIGATION
; ═══════════════════════════════════════════════════════════════════════════════
; Contract obligation tracking

{@contract_obligation}
; Required fields first
description = :                                  ; Obligation description
obligation_type = (compliance, delivery, financial, notification, performance, regulatory, reporting)
responsible_party = (both, counterparty, us)     ; Who is responsible

; Obligation identification
obligation_id = :                                 ; Unique obligation ID

; ───────────────────────────────────────────────────────────────────────────────
; Timing
; ───────────────────────────────────────────────────────────────────────────────
{.timing}
due_date = date                                   ; Due date
recurring = ?                                     ; Recurring obligation
frequency = (annual, daily, monthly, quarterly, weekly):if recurring = true
next_due = date:if recurring = true               ; Next occurrence
end_date = date:if recurring = true               ; Recurrence end date
reminder_days = ##:(0..)                          ; Days before for reminder

{@contract_obligation}

; ───────────────────────────────────────────────────────────────────────────────
; Completion
; ───────────────────────────────────────────────────────────────────────────────
{.completion}
completed = ?                                     ; Obligation completed
completion_date = date:if completed = true        ; Date completed
completed_by = ::if completed = true              ; Who completed
verification_required = ?                         ; Verification needed
verified = ?:if verification_required = true      ; Was verified
verification_date = date:if verified = true       ; Verification date

{@contract_obligation}

; ───────────────────────────────────────────────────────────────────────────────
; Financial (if payment obligation)
; ───────────────────────────────────────────────────────────────────────────────
{.financial}
amount = #$:(0..):if obligation_type = financial  ; Payment amount
paid = ?:if obligation_type = financial           ; Payment made
payment_date = date:if paid = true                ; Payment date
invoice_ref = ::if paid = true                    ; Invoice reference

{@contract_obligation}

; Status
status = (completed, in_progress, overdue, pending, waived)

; ═══════════════════════════════════════════════════════════════════════════════
; CONTRACT MILESTONE
; ═══════════════════════════════════════════════════════════════════════════════
; Contract milestone

{@contract_milestone}
; Required fields first
milestone_name = :                               ; Milestone name
target_date = date                               ; Target date

; Milestone identification
milestone_id = :                                  ; Unique milestone ID

; ───────────────────────────────────────────────────────────────────────────────
; Milestone Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
description = :                                   ; Milestone description
deliverables[] = :                                ; Associated deliverables
acceptance_criteria = :                           ; Acceptance criteria
responsible_party = (both, counterparty, us)      ; Responsible party

{@contract_milestone}

; ───────────────────────────────────────────────────────────────────────────────
; Payment (if payment milestone)
; ───────────────────────────────────────────────────────────────────────────────
{.payment}
payment_due = ?                                   ; Payment associated
payment_amount = #$:(0..):if payment_due = true   ; Payment amount
payment_percentage = #:(0..100):if payment_due = true ; % of contract value
invoice_on_completion = ?:if payment_due = true   ; Invoice when complete

{@contract_milestone}

; ───────────────────────────────────────────────────────────────────────────────
; Completion
; ───────────────────────────────────────────────────────────────────────────────
{.completion}
completed = ?                                     ; Milestone completed
actual_date = date:if completed = true            ; Actual completion date
accepted = ?:if completed = true                  ; Accepted by other party
acceptance_date = date:if accepted = true         ; Acceptance date
variance_days = ##:if completed = true            ; Days early/late (+/-)

{@contract_milestone}

; Status
status = (at_risk, completed, delayed, on_track, pending)

; ═══════════════════════════════════════════════════════════════════════════════
; CONTRACT AMENDMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Contract amendment

{@contract_amendment}
; Required fields first
amendment_date = date                            ; Amendment date
amendment_number = ##:(1..)                      ; Amendment number

; Amendment identification
amendment_id = :                                  ; Unique amendment ID

; ───────────────────────────────────────────────────────────────────────────────
; Amendment Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
title = :                                         ; Amendment title
summary = :                                       ; Summary of changes
reason = :                                        ; Reason for amendment
sections_modified[] = :                           ; Sections modified
terms_extended = ?                                ; Term extended
new_expiration = date:if terms_extended = true    ; New expiration date
value_change = #$                                 ; Change in contract value

{@contract_amendment}

; ───────────────────────────────────────────────────────────────────────────────
; Execution
; ───────────────────────────────────────────────────────────────────────────────
{.execution}
executed = ?                                      ; Amendment executed
execution_date = date:if executed = true          ; Execution date
our_signatory = ::if executed = true              ; Our signatory
counterparty_signatory = ::if executed = true     ; Counterparty signatory

{@contract_amendment}

; Status
status = (draft, executed, negotiating, rejected, superseded)


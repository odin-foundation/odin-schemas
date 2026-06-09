; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Regulatory Matter Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Regulatory and administrative law matters including agency proceedings,
; compliance programs, government investigations, licensing/permits, and
; rulemaking comments. Covers enforcement actions, consent orders, and
; regulatory reporting obligations.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as legal
@import "../../common/types.schema.odin" as common

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.legal.matter.regulatory"
version = "1.0.0"
title = "Regulatory Matter Schema"
description = "Regulatory and administrative law matters"

{$derivation}
source[0].authority = "Administrative Procedure Act"
source[0].citation = "5 U.S.C. 551-559"
source[0].url = "https://www.law.cornell.edu/uscode/text/5/part-I/chapter-5/subchapter-II"

source[1].authority = "Code of Federal Regulations"
source[1].citation = "CFR Title 1 - General Provisions"
source[1].url = "https://www.ecfr.gov/"

source[2].authority = "Federal Register"
source[2].citation = "Rulemaking Procedures"
source[2].url = "https://www.federalregister.gov/"

source[3].authority = "Various Federal Agencies"
source[3].citation = "Agency-Specific Regulations"
source[3].url = "https://www.regulations.gov/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Regulatory schema derived from APA and federal agency procedures"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial regulatory matter schema"
changelog[0].rationale = "Comprehensive regulatory matter tracking"

; ═══════════════════════════════════════════════════════════════════════════════
; REGULATORY MATTER
; ═══════════════════════════════════════════════════════════════════════════════
; Primary regulatory matter record

{@regulatory_matter}
; Required fields first
matter_name = :                                  ; Matter name/description
matter_type = (adjudication, agency_action, compliance, enforcement, investigation, licensing, permit, rulemaking)
open_date = date                                 ; Date matter opened
primary_agency = :                               ; Primary regulatory agency

; Matter identification
matter_id = :                                     ; Internal matter identifier
client_matter_id = :                              ; Client's reference number
ledes_matter_id = :                               ; LEDES matter ID for billing

; Client reference
client_ref = @legal_client                        ; Reference to client record
client_role = (applicant, commenter, intervenor, licensee, petitioner, regulated_entity, respondent, subject)

; ───────────────────────────────────────────────────────────────────────────────
; Agency Information
; ───────────────────────────────────────────────────────────────────────────────
{.agency}
agency_name = :                                   ; Full agency name
agency_acronym = :                                ; Agency acronym (SEC, EPA, etc.)
agency_type = (federal, local, state, tribal)     ; Agency level
division = :                                      ; Division/office within agency
region = :                                        ; Regional office (if applicable)

{@regulatory_matter}

; Agency contacts
{.agency.contacts[]}
contact_name = :                                  ; Contact name
title = :                                         ; Contact title
phone = *@phone                                   ; Contact phone
email = *@email                                   ; Contact email
role = (attorney, case_manager, examiner, inspector, investigator, staff)

{@regulatory_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Case/Docket Information
; ───────────────────────────────────────────────────────────────────────────────
{.docket}
docket_number = :                                 ; Agency docket number
file_number = :                                   ; Agency file number
case_caption = :                                  ; Case caption/title
assigned_alj = :                                  ; Assigned administrative law judge
assigned_examiner = :                             ; Assigned examiner

{@regulatory_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Key Dates
; ───────────────────────────────────────────────────────────────────────────────
{.key_dates}
inquiry_date = date                               ; Date of initial inquiry
subpoena_date = date                              ; Date subpoena received
response_due = date                               ; Response deadline
hearing_date = date                               ; Hearing date
decision_date = date                              ; Decision date
appeal_deadline = date                            ; Appeal deadline
compliance_deadline = date                        ; Compliance deadline

{@regulatory_matter}

; Deadlines list
deadlines[] = @legal_deadline                     ; All matter deadlines

{@regulatory_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Parties
; ───────────────────────────────────────────────────────────────────────────────
{.parties}
our_client_ref = @legal_client                    ; Our client
co_respondents[] = @legal_party                   ; Co-respondents
intervenors[] = @legal_party                      ; Intervenors
complainants[] = @legal_party                     ; Complainants (if any)
affected_parties[] = @legal_party                 ; Other affected parties

{@regulatory_matter}

; Counsel
{.counsel}
our_team[] = @legal_attorney                      ; Our attorneys on matter
agency_counsel = :                                ; Agency counsel name
co_respondent_counsel[] = @legal_opposing_counsel ; Co-respondent counsel

{@regulatory_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Investigation/Inquiry
; ───────────────────────────────────────────────────────────────────────────────
{.investigation}
investigation_type = (civil, criminal, formal, informal, parallel)
investigation_commenced = date                    ; When investigation began
trigger_event = :                                 ; What triggered investigation
subject_interview_requested = ?                   ; Interview of subject requested
interview_date = date:if subject_interview_requested = true
proffer_agreement = ?                             ; Proffer agreement in place

{@regulatory_matter}

; Document requests
{.investigation.document_requests[]}
request_date = date                               ; Date of request
request_type = (cid, informal, sec_form_1662, subpoena)
description = :                                   ; Description of request
response_due = date                               ; Response deadline
extended = ?                                      ; Extension granted
extended_due = date:if extended = true            ; Extended deadline
response_submitted = ?                            ; Response submitted
response_date = date:if response_submitted = true ; Response date
documents_produced = ##:(0..)                     ; Documents produced

{@regulatory_matter}

; Witness interviews
{.investigation.witness_interviews[]}
witness_name = :                                  ; Witness name
witness_role = :                                  ; Witness role/position
interview_date = date                             ; Interview date
interview_type = (formal, informal, on_record, proffer)
counsel_present = ?                               ; Counsel attended
transcript_available = ?                          ; Transcript available

{@regulatory_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Enforcement Action
; ───────────────────────────────────────────────────────────────────────────────
{.enforcement}
enforcement_initiated = ?                         ; Enforcement action taken
enforcement_date = date:if enforcement_initiated = true
enforcement_type = (administrative, civil, criminal, informal):if enforcement_initiated = true
violation_alleged = ::if enforcement_initiated = true
statutory_basis = ::if enforcement_initiated = true
regulatory_basis = ::if enforcement_initiated = true

{@regulatory_matter}

; Proposed sanctions
{.enforcement.sanctions}
monetary_penalty_proposed = #$:(0..)              ; Proposed penalty
disgorgement_proposed = #$:(0..)                  ; Proposed disgorgement
cease_and_desist = ?                              ; C&D order sought
injunction_sought = ?                             ; Injunction sought
license_action = (revocation, suspension):if matter_type = licensing
bar_sought = ?                                    ; Industry bar sought

{@regulatory_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Settlement/Resolution
; ───────────────────────────────────────────────────────────────────────────────
{.settlement}
settlement_discussions = ?                        ; Settlement being discussed
wells_notice_received = ?                         ; Wells notice received (SEC)
wells_submission_filed = ?:if wells_notice_received = true
consent_order_offered = ?                         ; Consent order offered
consent_order_terms = ::if consent_order_offered = true

{@regulatory_matter}

; Final resolution
{.settlement.resolution}
resolved = ?                                      ; Matter resolved
resolution_type = (consent_order, dismissal, formal_order, no_action, npa, settlement, withdrawal):if resolved = true
resolution_date = date:if resolved = true         ; Resolution date
monetary_penalty_final = #$:if resolved = true    ; Final penalty
disgorgement_final = #$:if resolved = true        ; Final disgorgement
other_terms = ::if resolved = true                ; Other resolution terms
neither_admit_deny = ?:if resolved = true         ; Neither admit nor deny
compliance_term_months = ##:(0..):if resolved = true  ; Compliance period

{@regulatory_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Administrative Hearing
; ───────────────────────────────────────────────────────────────────────────────
{.hearing}
hearing_scheduled = ?                             ; Hearing scheduled
hearing_type = (formal, informal, on_record)      ; Type of hearing
hearing_date = date:if hearing_scheduled = true   ; Hearing date
hearing_location = ::if hearing_scheduled = true  ; Location
alj_name = ::if hearing_scheduled = true          ; ALJ name
pre_hearing_conference = date                     ; Pre-hearing conference date

{@regulatory_matter}

; Hearing preparation
{.hearing.preparation}
discovery_complete = ?                            ; Discovery complete
witness_list_due = date                           ; Witness list deadline
exhibit_list_due = date                           ; Exhibit list deadline
pre_hearing_brief_due = date                      ; Brief deadline
pre_hearing_brief_filed = date                    ; Brief filed date

{@regulatory_matter}

; Hearing outcome
{.hearing.outcome}
hearing_complete = ?                              ; Hearing completed
hearing_days = ##:(0..)                           ; Number of hearing days
initial_decision_date = date                      ; Initial decision date
initial_decision = (adverse, favorable, mixed)    ; Initial decision outcome
appeal_filed = ?                                  ; Appeal to commission
commission_decision_date = date:if appeal_filed = true
commission_decision = (affirmed, modified, reversed):if appeal_filed = true

{@regulatory_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Judicial Review
; ───────────────────────────────────────────────────────────────────────────────
{.judicial_review}
petition_filed = ?                                ; Judicial review petition
petition_date = date:if petition_filed = true     ; Petition date
court = ::if petition_filed = true                ; Reviewing court
case_number = ::if petition_filed = true          ; Court case number
stay_requested = ?:if petition_filed = true       ; Stay of agency action
stay_granted = ?:if stay_requested = true         ; Stay granted
decision_date = date:if petition_filed = true     ; Court decision date
outcome = (affirmed, remanded, reversed, reversed_in_part):if petition_filed = true

{@regulatory_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = @legal_matter_status                     ; Matter status

; ═══════════════════════════════════════════════════════════════════════════════
; COMPLIANCE PROGRAM
; ═══════════════════════════════════════════════════════════════════════════════
; Regulatory compliance program tracking

{@compliance_program}
; Required fields first
program_name = :                                 ; Compliance program name
program_type = (aml_bsa, antitrust, data_privacy, environmental, export_control, fcpa, healthcare, labor, osha, securities)

; Program identification
program_id = :                                    ; Unique program identifier

; Client reference
client_ref = @legal_client                        ; Reference to client record

; ───────────────────────────────────────────────────────────────────────────────
; Program Scope
; ───────────────────────────────────────────────────────────────────────────────
{.scope}
regulatory_framework[] = :                        ; Applicable regulations
geographic_scope[] = :                            ; Geographic coverage
business_units[] = :                              ; Business units covered
risk_areas[] = :                                  ; Key risk areas

{@compliance_program}

; ───────────────────────────────────────────────────────────────────────────────
; Program Components
; ───────────────────────────────────────────────────────────────────────────────
{.components}
written_policies = ?                              ; Written policies exist
policies_last_updated = date:if written_policies = true
code_of_conduct = ?                               ; Code of conduct exists
risk_assessment = ?                               ; Risk assessment conducted
risk_assessment_date = date:if risk_assessment = true
training_program = ?                              ; Training program exists
training_frequency = (annual, quarterly, upon_hire):if training_program = true
hotline = ?                                       ; Reporting hotline exists
investigations_procedure = ?                      ; Investigation procedure
third_party_due_diligence = ?                     ; Third party DD program
monitoring_testing = ?                            ; Monitoring and testing
internal_audit = ?                                ; Internal audit reviews

{@compliance_program}

; ───────────────────────────────────────────────────────────────────────────────
; Compliance Officer
; ───────────────────────────────────────────────────────────────────────────────
{.officer}
officer_name = :                                  ; Chief compliance officer
officer_title = :                                 ; Title
officer_phone = *@phone                           ; Phone
officer_email = *@email                           ; Email
reports_to = :                                    ; Reporting structure
board_access = ?                                  ; Direct board access

{@compliance_program}

; ───────────────────────────────────────────────────────────────────────────────
; Certifications/Filings
; ───────────────────────────────────────────────────────────────────────────────
{.certifications[]}
certification_type = :                            ; Type of certification
due_date = date                                   ; Due date
filing_period = :                                 ; Filing period covered
filed = ?                                         ; Certification filed
filed_date = date:if filed = true                 ; Date filed
certifying_officer = :                            ; Who certified
agency = :                                        ; Filing agency

{@compliance_program}

; ───────────────────────────────────────────────────────────────────────────────
; Incidents/Issues
; ───────────────────────────────────────────────────────────────────────────────
{.incidents[]}
incident_date = date                              ; Date of incident
category = :                                      ; Incident category
description = :                                   ; Incident description
severity = (critical, high, low, medium)          ; Severity
reported_by = :                                   ; Who reported
investigation_opened = ?                          ; Investigation opened
investigation_complete = ?:if investigation_opened = true
finding = ::if investigation_complete = true      ; Investigation finding
remediation_required = ?                          ; Remediation needed
remediation_complete = ?:if remediation_required = true
reported_to_agency = ?                            ; Reported to regulator
agency_response = ::if reported_to_agency = true  ; Agency response

{@compliance_program}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, developing, dormant, remediation)
last_reviewed = date                              ; Last program review
next_review_date = date                           ; Next scheduled review
program_effectiveness = (deficient, effective, needs_improvement)

; ═══════════════════════════════════════════════════════════════════════════════
; LICENSING MATTER
; ═══════════════════════════════════════════════════════════════════════════════
; License and permit applications/renewals

{@regulatory_license}
; Required fields first
license_type = :                                 ; Type of license/permit
issuing_agency = :                               ; Issuing agency

; License identification
license_number = *:                                ; License number
application_number = :                            ; Application number
matter_ref = @regulatory_matter                   ; Related regulatory matter

; ───────────────────────────────────────────────────────────────────────────────
; Application
; ───────────────────────────────────────────────────────────────────────────────
{.application}
application_type = (amendment, initial, modification, renewal, transfer)
application_date = date                           ; Date filed
applicant_name = :                                ; Applicant name
application_fee = #$:(0..)                        ; Application fee
fee_paid = ?                                      ; Fee paid
complete = ?                                      ; Application complete
deficiency_notice = ?                             ; Deficiency notice received
deficiency_response_due = date:if deficiency_notice = true
deficiency_cured = ?:if deficiency_notice = true

{@regulatory_license}

; ───────────────────────────────────────────────────────────────────────────────
; Review Process
; ───────────────────────────────────────────────────────────────────────────────
{.review}
assigned_reviewer = :                             ; Assigned staff reviewer
public_notice_required = ?                        ; Public notice required
public_notice_date = date:if public_notice_required = true
public_comment_period_end = date:if public_notice_required = true
public_hearing_required = ?                       ; Hearing required
hearing_date = date:if public_hearing_required = true
environmental_review = ?                          ; Environmental review needed
environmental_review_type = (categorical_exclusion, ea, eis):if environmental_review = true

{@regulatory_license}

; ───────────────────────────────────────────────────────────────────────────────
; Decision
; ───────────────────────────────────────────────────────────────────────────────
{.decision}
decision_date = date                              ; Decision date
decision = (approved, approved_conditions, denied, pending, withdrawn)
conditions[] = ::if decision = approved_conditions ; License conditions
denial_reason = ::if decision = denied            ; Reason for denial
appeal_deadline = date:if decision = denied       ; Appeal deadline
appeal_filed = ?:if decision = denied             ; Appeal filed

{@regulatory_license}

; ───────────────────────────────────────────────────────────────────────────────
; License Details (if issued)
; ───────────────────────────────────────────────────────────────────────────────
{.license}
issue_date = date:if decision = approved | decision = approved_conditions
effective_date = date                             ; Effective date
expiration_date = date                            ; Expiration date
renewal_due = date                                ; Renewal application due
annual_fee = #$:(0..)                             ; Annual license fee
conditions_compliance = ?                         ; Conditions being met
reporting_requirements[] = :                      ; Ongoing reporting required

{@regulatory_license}

; Status
status = (active, expired, pending, revoked, suspended)

; ═══════════════════════════════════════════════════════════════════════════════
; RULEMAKING COMMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Comment on proposed rulemaking

{@regulatory_comment}
; Required fields first
rule_title = :                                   ; Proposed rule title
agency = :                                       ; Issuing agency

; Rulemaking identification
docket_number = :                                 ; Docket number
rin_number = :                                    ; Regulation Identifier Number
federal_register_citation = :                     ; Federal Register citation

; Client reference
client_ref = @legal_client                        ; Reference to client record

; ───────────────────────────────────────────────────────────────────────────────
; Proposed Rule
; ───────────────────────────────────────────────────────────────────────────────
{.proposed_rule}
nprm_date = date                                  ; NPRM publication date
comment_period_end = date                         ; Comment deadline
extended_deadline = date                          ; Extended deadline (if any)
summary = :                                       ; Summary of proposed rule
client_impact = :                                 ; Impact on client

{@regulatory_comment}

; ───────────────────────────────────────────────────────────────────────────────
; Comment Submission
; ───────────────────────────────────────────────────────────────────────────────
{.comment}
comment_filed = ?                                 ; Comment submitted
filing_date = date:if comment_filed = true        ; Date filed
comment_type = (formal, letter, meeting_request, reply, supplemental)
confidential_treatment_requested = ?              ; Confidential treatment
key_points[] = :                                  ; Key comment points
coalition = ?                                     ; Part of coalition comment
coalition_members[] = ::if coalition = true       ; Coalition members

{@regulatory_comment}

; ───────────────────────────────────────────────────────────────────────────────
; Outcome
; ───────────────────────────────────────────────────────────────────────────────
{.outcome}
final_rule_date = date                            ; Final rule publication
comment_addressed = ?                             ; Our comment addressed
changes_adopted = ?                               ; Our suggestions adopted
effective_date = date                             ; Rule effective date
compliance_deadline = date                        ; Compliance deadline

{@regulatory_comment}

; Status
status = (closed, comment_period, final_rule, proposed_rule)


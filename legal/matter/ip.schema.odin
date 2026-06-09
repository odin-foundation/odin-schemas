; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Intellectual Property Matter Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Intellectual property matters including patent prosecution, trademark
; registration, copyright filing, IP litigation, and licensing. Covers
; prosecution timelines, office action responses, portfolio management,
; and maintenance fee tracking.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as legal
@import "../../common/types.schema.odin" as common

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.legal.matter.ip"
version = "1.0.0"
title = "Intellectual Property Matter Schema"
description = "Intellectual property matters and portfolio management"

{$derivation}
source[0].authority = "United States Patent and Trademark Office"
source[0].citation = "37 CFR Parts 1-7, MPEP, TMEP"
source[0].url = "https://www.uspto.gov/"

source[1].authority = "United States Copyright Office"
source[1].citation = "37 CFR Chapter II"
source[1].url = "https://www.copyright.gov/"

source[2].authority = "World Intellectual Property Organization"
source[2].citation = "PCT, Madrid Protocol, Hague Agreement"
source[2].url = "https://www.wipo.int/"

source[3].authority = "Uniform Task-Based Management System"
source[3].citation = "UTBMS IP Code Set"
source[3].url = "https://ledes.org/utbms/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "IP schema derived from USPTO, Copyright Office, and WIPO procedures"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial IP matter schema"
changelog[0].rationale = "Comprehensive IP matter tracking"

; ═══════════════════════════════════════════════════════════════════════════════
; IP MATTER (BASE)
; ═══════════════════════════════════════════════════════════════════════════════
; Base IP matter record

{@ip_matter}
; Required fields first
ip_type = (copyright, design_patent, patent, trade_secret, trademark, utility_patent)
matter_name = :                                  ; Matter name/description
matter_type = (enforcement, licensing, litigation, portfolio_management, prosecution)
open_date = date                                 ; Date matter opened

; Matter identification
matter_id = :                                     ; Internal matter identifier
client_matter_id = :                              ; Client's reference number
ledes_matter_id = :                               ; LEDES matter ID for billing

; Client reference
client_ref = @legal_client                        ; Reference to client record

; ───────────────────────────────────────────────────────────────────────────────
; Parties
; ───────────────────────────────────────────────────────────────────────────────
{.parties}
owner = @legal_party                              ; IP owner
applicant = @legal_party                          ; Applicant (if different)
inventors[] = @legal_party                        ; Inventors/creators
assignees[] = @legal_party                        ; Assignees

{@ip_matter}

; Counsel
{.counsel}
our_team[] = @legal_attorney                      ; Our attorneys on matter
foreign_counsel[] = @legal_attorney               ; Foreign counsel
prosecuting_firm = @legal_firm                    ; Prosecuting firm

{@ip_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Key Dates
; ───────────────────────────────────────────────────────────────────────────────
deadlines[] = @legal_deadline                     ; All matter deadlines

{@ip_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Related Matters
; ───────────────────────────────────────────────────────────────────────────────
{.related_matters[]}
related_matter_id = :                             ; Related matter ID
relationship = (child, continuation, division, family, foreign_counterpart, parent, reissue)
description = :                                   ; Relationship description

{@ip_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = @legal_matter_status                     ; Matter status

; ═══════════════════════════════════════════════════════════════════════════════
; PATENT MATTER
; ═══════════════════════════════════════════════════════════════════════════════
; Patent prosecution and management

{@patent_matter}
= @ip_matter                                      ; Inherits IP matter fields

; Required fields first
patent_type = (design, plant, utility)           ; Type of patent

; ───────────────────────────────────────────────────────────────────────────────
; Application Information
; ───────────────────────────────────────────────────────────────────────────────
{.application}
application_number = :                            ; USPTO application number
filing_date = date                                ; Filing date
application_type = (continuation, continuation_in_part, divisional, national_stage, original, provisional, reissue)
provisional_number = ::if application_type = original ; Related provisional
provisional_date = date:if application_type = original ; Provisional filing date
priority_date = date                              ; Priority date
pct_number = :                                    ; PCT application number
pct_filing_date = date                            ; PCT filing date

{@patent_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Invention Details
; ───────────────────────────────────────────────────────────────────────────────
{.invention}
title = :                                         ; Invention title
abstract = :                                      ; Abstract
technology_area = :                               ; Technology area
cpc_classifications[] = :                         ; CPC classification codes
uspc_classifications[] = :                        ; USPC classification codes
claims_count = ##:(1..)                           ; Number of claims
independent_claims_count = ##:(1..)               ; Independent claims

{@patent_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Inventors
; ───────────────────────────────────────────────────────────────────────────────
{.inventors[]}
inventor_name = :                                 ; Inventor name
citizenship = :(2..3)                             ; Citizenship country code
residence = @address                              ; Residence address
assignment_executed = ?                           ; Assignment signed
assignment_date = date:if assignment_executed = true

{@patent_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Prosecution
; ───────────────────────────────────────────────────────────────────────────────
{.prosecution}
examiner_name = :                                 ; USPTO examiner
art_unit = :                                      ; Art unit
docket_number = :                                 ; Internal docket number
entity_status = (large, micro, small)             ; Entity status for fees

{@patent_matter}

; Office actions
{.prosecution.office_actions[]}
oa_type = (ex_parte_quayle, final, first, non_final, restriction, second)
mailing_date = date                               ; OA mailing date
response_due = date                               ; Response deadline
extended_due = date                               ; Extended deadline
extension_months = ##:(0..6)                      ; Months of extension
response_filed = ?                                ; Response filed
response_date = date:if response_filed = true     ; Response filing date

{@patent_matter}

; Rejections in office action
{.prosecution.office_actions[].rejections[]}
rejection_type = (101, 102, 103, 112a, 112b, double_patenting, other)
claims_rejected[] = ##:(1..)                      ; Claims rejected
prior_art_cited[] = :                             ; Prior art references
overcome = ?                                      ; Rejection overcome
overcome_date = date:if overcome = true           ; Date overcome

{@patent_matter}

; Interviews
{.prosecution.interviews[]}
interview_date = date                             ; Interview date
interview_type = (in_person, telephonic, video)   ; Interview type
participants[] = :                                ; Participants
summary = :                                       ; Interview summary
examiner_agreed = ?                               ; Examiner agreed to allowance

{@patent_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Allowance/Grant
; ───────────────────────────────────────────────────────────────────────────────
{.grant}
notice_of_allowance_date = date                   ; NOA date
issue_fee_due = date                              ; Issue fee deadline
issue_fee_paid = ?                                ; Issue fee paid
patent_number = :                                 ; Granted patent number
issue_date = date                                 ; Patent issue date
term_years = ##:(0..20)                           ; Patent term
expiration_date = date                            ; Patent expiration date
pta_days = ##:(0..)                               ; Patent term adjustment days
pta_contested = ?                                 ; PTA contested

{@patent_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Maintenance
; ───────────────────────────────────────────────────────────────────────────────
{.maintenance}
; 3.5 year fee
first_maintenance_due = date                      ; 3.5 year fee due
first_maintenance_paid = ?                        ; Fee paid
first_maintenance_date = date:if first_maintenance_paid = true

; 7.5 year fee
second_maintenance_due = date                     ; 7.5 year fee due
second_maintenance_paid = ?                       ; Fee paid
second_maintenance_date = date:if second_maintenance_paid = true

; 11.5 year fee
third_maintenance_due = date                      ; 11.5 year fee due
third_maintenance_paid = ?                        ; Fee paid
third_maintenance_date = date:if third_maintenance_paid = true

{@patent_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Post-Grant Proceedings
; ───────────────────────────────────────────────────────────────────────────────
{.post_grant[]}
proceeding_type = (cbm, ex_parte_reexam, inter_partes_review, pgr, supplemental_exam)
proceeding_number = :                             ; PTAB proceeding number
filing_date = date                                ; Filing date
petitioner = :                                    ; Petitioner (if IPR/PGR)
institution_date = date                           ; Institution date
institution_granted = ?                           ; Institution granted
claims_challenged[] = ##:(1..)                    ; Claims challenged
final_decision_date = date                        ; Final decision date
outcome = (affirmed, cancelled, claims_cancelled, claims_confirmed, not_instituted, settled)

{@patent_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Foreign Filing
; ───────────────────────────────────────────────────────────────────────────────
{.foreign_filings[]}
country = :(2..3)                                 ; Country code
application_number = :                            ; Foreign application number
filing_date = date                                ; Filing date
filing_route = (direct, epo, pct_national_phase)  ; Filing route
status = (abandoned, granted, pending, refused)
patent_number = ::if status = granted             ; Granted patent number
grant_date = date:if status = granted             ; Grant date
expiration_date = date:if status = granted        ; Expiration date
local_counsel = :                                 ; Local counsel name

{@patent_matter}

; Status
prosecution_status = (abandoned, allowed, granted, pending, refused)

; ═══════════════════════════════════════════════════════════════════════════════
; TRADEMARK MATTER
; ═══════════════════════════════════════════════════════════════════════════════
; Trademark prosecution and management

{@trademark_matter}
= @ip_matter                                      ; Inherits IP matter fields

; ───────────────────────────────────────────────────────────────────────────────
; Mark Information
; ───────────────────────────────────────────────────────────────────────────────
{.mark}
mark_text = :                                     ; Word mark text
mark_type = (certification, collective, service, standard_character, stylized, trademark, trade_dress)
design_description = ::if mark_type = stylized | mark_type = trade_dress
mark_description = :                              ; Mark description
color_claim = ?                                   ; Color claimed as feature
color_description = ::if color_claim = true       ; Color description
translation = :                                   ; Translation (if foreign word)
transliteration = :                               ; Transliteration

{@trademark_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Classification
; ───────────────────────────────────────────────────────────────────────────────
{.classification[]}
class_number = ##:(1..45)                         ; Nice classification class
goods_services = :                                ; Description of goods/services
basis = (1a_use, 1b_intent, 44d_foreign, 44e_registration, 66a_madrid)

{@trademark_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Application
; ───────────────────────────────────────────────────────────────────────────────
{.application}
serial_number = :                                 ; USPTO serial number
filing_date = date                                ; Filing date
filing_basis = (use, intent_to_use, madrid, foreign)
first_use_date = date:if filing_basis = use       ; Date of first use
first_use_commerce_date = date:if filing_basis = use ; First use in commerce
priority_country = :(2..3):if filing_basis = foreign
priority_date = date:if filing_basis = foreign
priority_number = ::if filing_basis = foreign

{@trademark_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Prosecution
; ───────────────────────────────────────────────────────────────────────────────
{.prosecution}
examining_attorney = :                            ; Examining attorney name
law_office = :                                    ; Law office number

{@trademark_matter}

; Office actions
{.prosecution.office_actions[]}
oa_type = (final, first, non_final, priority_action, suspension)
mailing_date = date                               ; OA mailing date
response_due = date                               ; Response deadline
extended_due = date                               ; Extended deadline
response_filed = ?                                ; Response filed
response_date = date:if response_filed = true     ; Response date

{@trademark_matter}

; Refusals
{.prosecution.office_actions[].refusals[]}
refusal_type = (2d_likelihood_confusion, 2e1_merely_descriptive, 2e3_geographically_descriptive, 2e4_primarily_surname, 2e5_functional, other)
basis = :                                         ; Refusal basis
cited_registration = :                            ; Cited registration (if 2d)
overcome = ?                                      ; Refusal overcome

{@trademark_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Publication and Opposition
; ───────────────────────────────────────────────────────────────────────────────
{.publication}
published_date = date                             ; Publication date
opposition_period_end = date                      ; Opposition deadline
extension_request_filed = ?                       ; Extension request filed
opposed = ?                                       ; Opposition filed
opposition_number = ::if opposed = true           ; Opposition number
opposer = ::if opposed = true                     ; Opposer name

{@trademark_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Registration
; ───────────────────────────────────────────────────────────────────────────────
{.registration}
registration_number = :                           ; Registration number
registration_date = date                          ; Registration date
supplemental_register = ?                         ; On supplemental register

; Allegation of use (if ITU)
{.registration.allegation_of_use}
sou_filed = ?:if application.filing_basis = intent_to_use
sou_filing_date = date:if sou_filed = true
specimen_accepted = ?:if sou_filed = true
extension_count = ##:(0..5):if application.filing_basis = intent_to_use

{@trademark_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Maintenance
; ───────────────────────────────────────────────────────────────────────────────
{.maintenance}
; Section 8 (declaration of continued use)
section_8_due = date                              ; Section 8 due (years 5-6)
section_8_filed = ?                               ; Section 8 filed
section_8_date = date:if section_8_filed = true   ; Filing date

; Section 15 (incontestability)
section_15_filed = ?                              ; Section 15 filed
section_15_date = date:if section_15_filed = true ; Filing date
incontestable = ?:if section_15_filed = true      ; Status is incontestable

; Section 9 (renewal)
renewal_due = date                                ; Renewal due (year 10)
renewal_filed = ?                                 ; Renewal filed
renewal_date = date:if renewal_filed = true       ; Filing date
next_renewal_due = date                           ; Next renewal (each 10 years)

{@trademark_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Foreign Filing (Madrid Protocol)
; ───────────────────────────────────────────────────────────────────────────────
{.madrid}
international_registration = ?                    ; Part of Madrid system
ir_number = ::if international_registration = true
ir_date = date:if international_registration = true

{@trademark_matter}

{.madrid.designations[]}
country = :(2..3)                                 ; Designated country
designation_date = date                           ; Designation date
status = (accepted, pending, protected, refused)
protection_date = date:if status = protected
refusal_date = date:if status = refused
refusal_grounds = ::if status = refused

{@trademark_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Direct Foreign Filings
; ───────────────────────────────────────────────────────────────────────────────
{.foreign_filings[]}
country = :(2..3)                                 ; Country code
application_number = :                            ; Foreign application number
filing_date = date                                ; Filing date
status = (abandoned, pending, refused, registered)
registration_number = ::if status = registered
registration_date = date:if status = registered
renewal_due = date:if status = registered
local_counsel = :                                 ; Local counsel

{@trademark_matter}

; Status
prosecution_status = (abandoned, expired, opposed, pending, published, registered, refused)

; ═══════════════════════════════════════════════════════════════════════════════
; COPYRIGHT MATTER
; ═══════════════════════════════════════════════════════════════════════════════
; Copyright registration and management

{@copyright_matter}
= @ip_matter                                      ; Inherits IP matter fields

; ───────────────────────────────────────────────────────────────────────────────
; Work Information
; ───────────────────────────────────────────────────────────────────────────────
{.work}
title = :                                         ; Work title
work_type = (architectural, audiovisual, choreographic, dramatic, graphic, literary, motion_picture, musical, performing_arts, pictorial, sculptural, sound_recording, software)
nature_of_work = :                                ; Nature of work description
year_of_creation = ##:(1700..2100)                ; Year created
year_of_publication = ##:(1700..2100)             ; Year first published
nation_of_first_publication = :(2..3)             ; Country of first publication
published = ?                                     ; Work has been published
publication_date = date:if published = true       ; Publication date

{@copyright_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Authors
; ───────────────────────────────────────────────────────────────────────────────
{.authors[]}
author_name = :                                   ; Author name
citizenship = :(2..3)                             ; Citizenship
domicile = :(2..3)                                ; Domicile country
work_made_for_hire = ?                            ; Work for hire
anonymous = ?                                     ; Anonymous authorship
pseudonymous = ?                                  ; Pseudonymous authorship
pseudonym = ::if pseudonymous = true              ; Pseudonym
nature_of_contribution = :                        ; What author contributed

{@copyright_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Claimant
; ───────────────────────────────────────────────────────────────────────────────
{.claimant}
claimant_name = :                                 ; Copyright claimant
claimant_address = @address                       ; Claimant address
transfer_statement = :                            ; How rights were obtained (if not author)

{@copyright_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Registration
; ───────────────────────────────────────────────────────────────────────────────
{.registration}
application_type = (group, single, standard)      ; Application type
service_request_number = :                        ; SR number
filing_date = date                                ; Filing date
deposit_type = (best_edition, complete_copy, identifying_material)
registration_number = :                           ; Registration number
registration_date = date                          ; Registration date
registration_effective_date = date                ; Effective date
certificate_received = ?                          ; Certificate received
certificate_date = date:if certificate_received = true

{@copyright_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Prior Registrations
; ───────────────────────────────────────────────────────────────────────────────
{.prior_registrations[]}
registration_number = :                           ; Prior registration number
year = ##:(1700..2100)                            ; Year of registration
relationship = (derivative, new_version, supplementary)

{@copyright_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Derivative Work
; ───────────────────────────────────────────────────────────────────────────────
{.derivative}
derivative_work = ?                               ; Is derivative work
preexisting_material = ::if derivative_work = true ; Description of preexisting material
new_material = ::if derivative_work = true        ; Description of new material added

{@copyright_matter}

; Status
prosecution_status = (abandoned, correspondence, pending, refused, registered)

; ═══════════════════════════════════════════════════════════════════════════════
; TRADE SECRET MATTER
; ═══════════════════════════════════════════════════════════════════════════════
; Trade secret protection and management

{@trade_secret_matter}
= @ip_matter                                      ; Inherits IP matter fields

; ───────────────────────────────────────────────────────────────────────────────
; Trade Secret Information
; ───────────────────────────────────────────────────────────────────────────────
{.secret}
secret_name = :                                   ; Trade secret name/identifier
category = (business_information, customer_data, formulation, manufacturing_process, software, technical_data)
description = :                                   ; Description (without disclosure)
creation_date = date                              ; When developed/identified
economic_value = (high, low, medium, very_high)   ; Value assessment

{@trade_secret_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Protection Measures
; ───────────────────────────────────────────────────────────────────────────────
{.protection}
access_controls = ?                               ; Physical/electronic access controls
access_control_description = ::if access_controls = true
confidentiality_agreements = ?                    ; NDAs in place
marking_program = ?                               ; Confidentiality markings used
need_to_know_policy = ?                           ; Need-to-know restrictions
exit_interviews = ?                               ; Departing employee interviews
periodic_audits = ?                               ; Periodic protection audits
last_audit_date = date:if periodic_audits = true

{@trade_secret_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Personnel with Access
; ───────────────────────────────────────────────────────────────────────────────
{.personnel[]}
person_name = :                                   ; Name of person with access
relationship = (contractor, employee, former_employee, licensee, vendor)
nda_signed = ?                                    ; NDA signed
nda_date = date:if nda_signed = true              ; NDA date
access_granted = date                             ; When access granted
access_revoked = date                             ; When access revoked (if applicable)
departure_date = date:if relationship = former_employee

{@trade_secret_matter}

; ───────────────────────────────────────────────────────────────────────────────
; Misappropriation Incidents
; ───────────────────────────────────────────────────────────────────────────────
{.incidents[]}
incident_date = date                              ; Date of incident
incident_type = (breach_of_confidence, computer_intrusion, employee_departure, third_party_disclosure)
description = :                                   ; Incident description
suspected_actor = :                               ; Suspected responsible party
investigation_opened = ?                          ; Investigation commenced
legal_action_taken = ?                            ; Legal action initiated
litigation_matter_ref = ::if legal_action_taken = true ; Related litigation

{@trade_secret_matter}

; Status
protection_status = (active, compromised, disclosed, obsolete)

; ═══════════════════════════════════════════════════════════════════════════════
; IP LICENSING
; ═══════════════════════════════════════════════════════════════════════════════
; IP licensing matters

{@ip_license}
; Required fields first
license_type = (copyright, patent, technology, trademark, trade_secret)
license_structure = (exclusive, non_exclusive, sole)

; Matter reference
matter_ref = @ip_matter                           ; Related IP matter

; ───────────────────────────────────────────────────────────────────────────────
; Parties
; ───────────────────────────────────────────────────────────────────────────────
{.parties}
licensor = @legal_party                           ; Licensor
licensee = @legal_party                           ; Licensee
our_client_is = (licensee, licensor)              ; Which party is our client

{@ip_license}

; ───────────────────────────────────────────────────────────────────────────────
; Licensed IP
; ───────────────────────────────────────────────────────────────────────────────
{.licensed_ip[]}
ip_type = (copyright, patent, trademark, trade_secret)
ip_identifier = :                                 ; Patent number, reg number, etc.
description = :                                   ; Description of licensed IP

{@ip_license}

; ───────────────────────────────────────────────────────────────────────────────
; Scope
; ───────────────────────────────────────────────────────────────────────────────
{.scope}
field_of_use = :                                  ; Field of use limitation
territory[] = :(2..3)                             ; Licensed territory (country codes)
worldwide = ?                                     ; Worldwide license
sublicense_rights = ?                             ; Sublicensing permitted
improvements_license = ?                          ; Improvements licensed back

{@ip_license}

; ───────────────────────────────────────────────────────────────────────────────
; Term
; ───────────────────────────────────────────────────────────────────────────────
{.term}
effective_date = date                             ; License effective date
expiration_date = date                            ; License expiration
perpetual = ?                                     ; Perpetual license
renewable = ?                                     ; License is renewable
auto_renewal = ?:if renewable = true              ; Auto-renews
renewal_notice_days = ##:(0..):if renewable = true ; Notice period

{@ip_license}

; ───────────────────────────────────────────────────────────────────────────────
; Financial Terms
; ───────────────────────────────────────────────────────────────────────────────
{.financial}
upfront_fee = #$:(0..)                            ; Upfront payment
running_royalty = ?                               ; Ongoing royalties
royalty_rate = #:(0..100):if running_royalty = true ; Royalty percentage
royalty_base = ::if running_royalty = true        ; Royalty calculation base
minimum_royalty = #$:(0..):if running_royalty = true ; Minimum annual royalty
milestone_payments = ?                            ; Milestone payments
payment_terms_days = ##:(0..)                     ; Payment terms

{@ip_license}

; ───────────────────────────────────────────────────────────────────────────────
; Reporting and Audit
; ───────────────────────────────────────────────────────────────────────────────
{.reporting}
reporting_required = ?                            ; Sales reporting required
reporting_frequency = (annual, monthly, quarterly):if reporting_required = true
audit_rights = ?                                  ; Right to audit licensee
audit_frequency = ::if audit_rights = true        ; How often can audit
records_retention_years = ##:(0..):if audit_rights = true

{@ip_license}

; ───────────────────────────────────────────────────────────────────────────────
; Termination
; ───────────────────────────────────────────────────────────────────────────────
{.termination}
termination_for_convenience = ?                   ; Can terminate without cause
notice_period_days = ##:(0..)                     ; Termination notice period
termination_for_breach = ?                        ; Termination for breach
cure_period_days = ##:(0..):if termination_for_breach = true
post_termination_sell_off = ?                     ; Sell-off period permitted
sell_off_period_days = ##:(0..):if post_termination_sell_off = true

{@ip_license}

; Status
status = (active, expired, negotiation, terminated)
termination_date = date:if status = terminated
termination_reason = ::if status = terminated


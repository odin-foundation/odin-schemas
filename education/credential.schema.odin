; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Credential Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Credentials and certifications for education and workforce including academic
; degrees, certificates, professional licenses, industry credentials, digital
; badges, and continuing education units.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types
@import "./student.schema.odin" as student
@import "./institution.schema.odin" as institution

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.education.credential"
version = "1.0.0"
title = "Credential Schema"
description = "Degrees, certificates, licenses, certifications, continuing education, and digital badges"

{$derivation}
source[0].authority = "National Center for Education Statistics"
source[0].citation = "Integrated Postsecondary Education Data System (IPEDS) - Completions Survey"
source[0].url = "https://nces.ed.gov/ipeds/"
source[0].accessed = 2025-12-21

source[1].authority = "National Center for Education Statistics"
source[1].citation = "Common Education Data Standards (CEDS) - Credential Standards"
source[1].url = "https://ceds.ed.gov/"
source[1].accessed = 2025-12-21

source[2].authority = "Credential Engine"
source[2].citation = "Credential Transparency Description Language (CTDL)"
source[2].url = "https://credreg.net/"
source[2].accessed = 2025-12-21

source[3].authority = "IMS Global Learning Consortium"
source[3].citation = "Open Badges Specification v3.0"
source[3].url = "https://www.imsglobal.org/spec/ob/v3p0/"
source[3].accessed = 2025-12-21

source[4].authority = "U.S. Department of Education"
source[4].citation = "34 CFR Part 600 - Institutional Eligibility"
source[4].url = "https://www.ecfr.gov/current/title-34/subtitle-B/chapter-VI/part-600"
source[4].accessed = 2025-12-21

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema derived from IPEDS, CEDS, CTDL, Open Badges, and Title IV regulations"

changelog[0].date = 2025-12-21
changelog[0].change = "Initial credential schema"
changelog[0].rationale = "Comprehensive credentials including degrees, certificates, licenses per IPEDS and CEDS"

; ═══════════════════════════════════════════════════════════════════════════════
; DEGREE
; ═══════════════════════════════════════════════════════════════════════════════

{@degree}
; Required fields first
credential_id = !:                                   ; Credential identifier
recipient_id = !*:                                   ; Recipient identifier (PII)
degree_type = !:                                     ; Degree type
conferral_date = !date                               ; Degree conferred date

; Optional fields
degree_title = :                                     ; Full degree title
degree_name = :                                      ; Degree name

; Classification
degree_level = (associate, bachelor, certificate, doctoral, master, post_baccalaureate_certificate, post_master_certificate, professional)
cip_code = :(2..7)                                   ; Classification of Instructional Programs

; Program details
major = :                                            ; Primary major
minors[] = :                                         ; Minors
concentration = :                                    ; Concentration/specialization
emphasis = :                                         ; Emphasis area

; Institution
institution_id = :                                   ; Conferring institution
institution_name = :                                 ; Institution name
school_college = :                                   ; School or college within institution
department = :                                       ; Academic department

; Academic performance
final_gpa = #:(0..4)                                 ; Final GPA
total_credits = #:(0..)                              ; Total credits earned
honors = (cum_laude, magna_cum_laude, none, summa_cum_laude)

; Dates
completion_date = date                               ; Requirements completion date
application_date = date                              ; Degree application date

; Status
status = (awarded, conferred, in_progress, pending, revoked)
revocation_date = date                               ; If revoked
revocation_reason = :

; Verification
verification_url = :                                 ; URL for credential verification
credential_id_public = :                             ; Public credential ID
blockchain_verified = ?                              ; Blockchain verification

; ═══════════════════════════════════════════════════════════════════════════════
; CERTIFICATE / CERTIFICATION
; ═══════════════════════════════════════════════════════════════════════════════

{@certificate}
; Required fields first
credential_id = !:                                   ; Credential identifier
recipient_id = !*:                                   ; Recipient identifier (PII)
certificate_name = !:                                ; Certificate name
issue_date = !date                                   ; Issue date

; Optional fields
certificate_type = (academic, industry, occupational, professional, training)
credential_category = (apprenticeship, bootcamp, certificate, certification, license, micro_credential)

; Classification
cip_code = :(2..7)                                   ; Classification of Instructional Programs
credential_level = (advanced, basic, intermediate, master)

; Program details
program_name = :                                     ; Program name
program_hours = #:(0..)                              ; Program hours
credits = #:(0..)                                    ; Credit hours (if applicable)

; Issuing organization
issuer_id = :                                        ; Issuing organization ID
issuer_name = :                                      ; Organization name
issuer_type = (certification_body, educational_institution, employer, industry_association, professional_organization)

; Validity
expiration_date = date                               ; Expiration date if applicable
renewable = ?                                        ; Can be renewed
renewal_period = :                                   ; Renewal period (e.g., 2 years)
renewal_requirements = :                             ; Requirements for renewal

; Requirements met
requirements_met[] = :                               ; Requirements completed
competencies[] = :                                   ; Competencies demonstrated
assessments_passed[] = :                             ; Assessments passed

; Continuing education
ceu_required = #:(0..)                               ; CEUs required for renewal
ceu_earned = #:(0..)                                 ; CEUs earned

; Status
status = (active, expired, in_progress, revoked, suspended)
revocation_date = date
revocation_reason = :

; Verification
certificate_number = :                               ; Certificate number
verification_url = :                                 ; Verification URL
digital_credential_url = :                           ; Digital credential URL

; ═══════════════════════════════════════════════════════════════════════════════
; PROFESSIONAL LICENSE
; ═══════════════════════════════════════════════════════════════════════════════

{@professional_license}
; Required fields first
license_id = !:                                      ; License identifier
licensee_id = !*:                                    ; Licensee identifier (PII)
license_number = !*:                                 ; License number (PII)
license_type = !:                                    ; License type
issue_date = !date                                   ; Issue date

; Optional fields
profession = :                                       ; Licensed profession
specialty = :                                        ; Specialty area

; Jurisdiction
issuing_state = :(2)                                 ; State/province
issuing_country = :(2..3)                            ; Country
issuing_authority = :                                ; Licensing board/agency

; Validity
expiration_date = date                               ; Expiration date
renewable = ?                                        ; Renewable license
renewal_cycle = :                                    ; Renewal cycle (annual, biennial, etc.)

; Requirements
initial_requirements[] = :                           ; Initial licensure requirements
continuing_education_required = ?                    ; CE required for renewal
ce_hours_required = #:(0..)                          ; CE hours per cycle
ce_hours_completed = #:(0..)                         ; CE hours completed

; Scope of practice
practice_areas[] = :                                 ; Areas of practice
restrictions[] = :                                   ; Practice restrictions

; Status
status = (active, expired, inactive, probation, revoked, suspended, temporary)
status_date = date                                   ; Status effective date
disciplinary_action = ?                              ; Disciplinary action on record
disciplinary_description = :

; Reciprocity
reciprocal_states[] = :(2)                           ; States with reciprocity
compact_participation = ?                            ; Member of interstate compact
compact_name = :

; Verification
public_verification_url = :                          ; Public license verification URL
last_verified_date = date

; ═══════════════════════════════════════════════════════════════════════════════
; DIGITAL BADGE / MICRO-CREDENTIAL
; ═══════════════════════════════════════════════════════════════════════════════

{@digital_badge}
; Required fields first
badge_id = !:                                        ; Badge identifier
recipient_id = !*:                                   ; Recipient identifier (PII)
badge_name = !:                                      ; Badge name
issue_date = !date                                   ; Issue date

; Optional fields
badge_description = :                                ; Badge description
badge_criteria = :                                   ; Criteria for earning badge

; Badge class/template
badge_class_id = :                                   ; Badge class identifier
badge_image_url = :                                  ; Badge image URL
version = :                                          ; Badge version

; Issuer
issuer_id = :                                        ; Issuing organization ID
issuer_name = :                                      ; Issuer name
issuer_url = :                                       ; Issuer website

; Competencies and skills
competencies[] = :                                   ; Competencies demonstrated
skills[] = :                                         ; Skills acquired
learning_outcomes[] = :                              ; Learning outcomes

; Evidence
evidence_url = :                                     ; Evidence URL
evidence_description = :                             ; Evidence description
artifacts[] = :                                      ; Artifact URLs

; Alignment
aligned_standards[] = :                              ; Aligned education standards
aligned_frameworks[] = :                             ; Aligned competency frameworks
credential_alignment[] = :                           ; Aligned to other credentials

; Validity
expiration_date = date                               ; Expiration (if applicable)
expires = ?                                          ; Badge expires

; Open Badges metadata
assertion_url = :                                    ; Assertion URL (OB 3.0)
badge_class_url = :                                  ; Badge class URL
verification_method = (hosted, signed)
signature = :                                        ; Digital signature

; Blockchain
blockchain_anchored = ?                              ; Anchored to blockchain
blockchain_transaction = :                           ; Transaction hash
blockchain_network = :                               ; Blockchain network

; Status
revoked = ?                                          ; Badge revoked
revocation_reason = :

; ═══════════════════════════════════════════════════════════════════════════════
; CONTINUING EDUCATION UNIT (CEU)
; ═══════════════════════════════════════════════════════════════════════════════

{@continuing_education}
; Required fields first
activity_id = !:                                     ; Activity identifier
participant_id = !*:                                 ; Participant identifier (PII)
completion_date = !date                              ; Completion date

; Optional fields
activity_title = :                                   ; Activity title
activity_description = :                             ; Activity description

; Provider
provider_id = :                                      ; Provider identifier
provider_name = :                                    ; Provider name
provider_approved = ?                                ; Approved provider

; Credits
ceu_awarded = #:(0..)                                ; CEUs awarded
contact_hours = #:(0..)                              ; Contact hours
credit_hours = #:(0..)                               ; Credit hours

; Classification
category = (conference, course, online_learning, seminar, webinar, workshop)
subject_area = :                                     ; Subject area
professional_area = :                                ; Professional area

; Dates
activity_date = date                                 ; Activity date
start_date = date                                    ; Start date
end_date = date                                      ; End date

; Approval
approval_number = :                                  ; Approval number
approved_by = :                                      ; Approving organization

; Verification
certificate_number = :                               ; Certificate number
verification_code = :                                ; Verification code

; ═══════════════════════════════════════════════════════════════════════════════
; CREDENTIAL WALLET
; ═══════════════════════════════════════════════════════════════════════════════

{@credential_wallet}
; Required fields first
holder_id = !*:                                      ; Credential holder ID (PII)

; Optional fields
wallet_created = timestamp                           ; Wallet creation date

; Credentials held
degrees[] = @degree                                  ; Academic degrees
certificates[] = @certificate                        ; Certificates
licenses[] = @professional_license                   ; Professional licenses
badges[] = @digital_badge                            ; Digital badges
continuing_education[] = @continuing_education       ; CEUs and CE

; Summary counts
degree_count = ##:(0..)                              ; Number of degrees
certificate_count = ##:(0..)                         ; Number of certificates
license_count = ##:(0..)                             ; Number of licenses
badge_count = ##:(0..)                               ; Number of badges

; Sharing and verification
shareable_url = :                                    ; Public credential URL
verification_enabled = ?                             ; Public verification enabled

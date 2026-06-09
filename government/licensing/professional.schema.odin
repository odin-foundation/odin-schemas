; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Government Licensing - Professional License Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Professional licenses and certifications including applications, renewals,
; continuing education tracking, and disciplinary proceedings. Covers state
; licensing boards, examination requirements, and reciprocity agreements.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.government.licensing.professional"
version = "1.0.0"
title = "Professional Licensing and Certification"
description = "Professional licenses, certifications, renewals, CE, and discipline"

{$derivation}
source[0].authority = "State Professional Licensing Boards"
source[0].citation = "Professional Licensing Requirements by State"
source[0].url = "https://www.fsmb.org/"
source[0].accessed = 2025-12-21

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial professional licensing schema"
changelog[0].rationale = "Professional license and certification tracking"

; ═══════════════════════════════════════════════════════════════════════════════
; PROFESSIONAL LICENSE
; ═══════════════════════════════════════════════════════════════════════════════

{@professional_license}
= @types.audit_info

license_type = :                                    ; MD, RN, CPA, Attorney, Engineer, etc.
profession = :
state = :(2)
license_number = *:

; Licensee Information
{.licensee}
first_name = :
last_name = :
middle_name = :
ssn = *:format ssn
date_of_birth = *date
address = @address
phone = @phone
email = @email

{@professional_license}
; License Status
{.status}
current_status = (active, expired, inactive, probation, revoked, suspended)
issue_date = date
effective_date = date
expiration_date = date
renewal_date = date
status_date = date

{@professional_license}
; Education and Training
{.education[]}
degree = :
institution = :
graduation_date = date
major = :

{@professional_license}
; Board Certification
{.certifications[]}
certification_name = :
certifying_body = :
issue_date = date
expiration_date = date
certification_number = :

{@professional_license}
; Practice Information
{.practice}
practice_name = :
practice_address = @address
practice_phone = @phone
specialty = :
board_certified = ?

{@professional_license}
; Continuing Education Requirements
{.continuing_education}
required_hours_per_period = ##:(0..)
current_period_start = date
current_period_end = date
hours_completed = ##:(0..)
hours_remaining = ##:(0..)
compliant = ?

{@professional_license}
; Disciplinary History
{.discipline[]}
action_date = date
action_type = (censure, fine, probation, reprimand, revocation, suspension, warning)
reason = :
resolution = :
probation_end_date = date

{@professional_license}
; Fees
application_fee = #$:(0..)
initial_license_fee = #$:(0..)
renewal_fee = #$:(0..)
late_renewal_penalty = #$:(0..)

; ═══════════════════════════════════════════════════════════════════════════════
; LICENSE RENEWAL
; ═══════════════════════════════════════════════════════════════════════════════

{@license_renewal}
= @types.audit_info

license_number = *:
renewal_period_end = date
renewal_date = date

; Continuing Education Compliance
ce_hours_required = ##:(0..)
ce_hours_completed = ##:(0..)
ce_compliant = ?

{.ce_courses[]}
course_title = :
provider = :
completion_date = date
hours_earned = #:(0..)
course_number = :

{@license_renewal}
; Practice Attestations
practicing_profession = ?
practice_address = @address
malpractice_insurance = ?
insurance_carrier = :if malpractice_insurance = true
policy_number = :
coverage_amount = #$:(0..)

; Criminal/Disciplinary History
{.attestations}
criminal_convictions = ?
disciplinary_actions = ?
malpractice_claims = ?
explanation = :

{@license_renewal}
; Renewal Fee
renewal_fee = #$:(0..)
late_fee = #$:(0..)
total_fee = #$:(0..)

; Signature
signed_by = :
signature_date = date

; ═══════════════════════════════════════════════════════════════════════════════
; CONTINUING EDUCATION COURSE
; ═══════════════════════════════════════════════════════════════════════════════

{@continuing_education_course}
= @types.audit_info

course_title = :
course_number = :
provider_name = :
provider_number = :
approved_by = :

; Course Details
{.course}
subject_area = :
credit_hours = #:(0..)
course_level = (advanced, basic, intermediate)
delivery_method = (correspondence, in_person, online, self_study, webinar)
start_date = date
end_date = date
completion_date = date

{@continuing_education_course}
; Participant
{.participant}
name = :
license_number = *:
profession = :

{@continuing_education_course}
; Completion
passed = ?
score = #:(0..100)
certificate_number = :
certificate_date = date

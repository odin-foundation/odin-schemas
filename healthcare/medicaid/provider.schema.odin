; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Medicaid Provider Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Medicaid provider enrollment and participation including screening, agreements,
; and revalidation. Derived from 42 CFR Part 455 Subpart E and state provider
; enrollment requirements.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as medicaid

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.medicaid.provider"
version = "1.0.0"
title = "Medicaid Provider Schema"
description = "Medicaid provider enrollment and participation"

{$derivation}
source[0].authority = "GPO"
source[0].citation = "42 CFR Part 455 Subpart E - Provider Screening and Enrollment"
source[0].url = "https://www.ecfr.gov/current/title-42/chapter-IV/subchapter-C/part-455/subpart-E"

source[1].authority = "CMS"
source[1].citation = "Medicaid Provider Enrollment Compendium"
source[1].url = "https://www.ecfr.gov/current/title-42/chapter-IV/subchapter-C/part-455/subpart-E"

source[2].authority = "GPO"
source[2].citation = "42 CFR 431.107 - Required provider agreements"
source[2].url = "https://www.ecfr.gov/current/title-42/chapter-IV/subchapter-C/part-431/subpart-C/section-431.107"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial Medicaid provider schema"
changelog[0].rationale = "Structure derived from 42 CFR Part 455 Subpart E and state enrollment requirements"

; ═══════════════════════════════════════════════════════════════════════════════
; PROVIDER ENROLLMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 455.410

{@enrollment}
enrollment_id = !:                          ; Enrollment ID
state = !:(2)                               ; State
provider_type = !(atypical, facility, group, individual)

; Provider identification
{.identification}
npi = !:                                    ; National Provider Identifier
tax_id = *:                                 ; Tax ID (EIN or SSN)
medicaid_id = :                             ; State Medicaid provider ID
legacy_id = :                               ; Legacy provider number

{@enrollment}

; Organization/individual info
{.entity}
entity_type = !(individual, organization)
legal_name = !:                             ; Legal name
dba_name = :                                ; Doing business as
contact_name = :                            ; Contact person
contact_phone = *@phone                     ; Contact phone
contact_email = *@email                     ; Contact email

{@enrollment}

; Application - Per 42 CFR 455.414
{.application}
application_date = !date                    ; Application date
application_type = !(change, initial, reactivation, revalidation)
fee_paid = ?                                ; Application fee paid
fee_amount = #$:(0..)                       ; Fee amount

{@enrollment}

; Screening - Per 42 CFR 455.450
{.screening}
risk_level = !(high, limited, moderate)     ; Categorical risk level
screening_type = :                          ; Screening performed
fingerprint_required = ?                    ; Fingerprints required (high risk)
site_visit_required = ?                     ; Site visit required (high/moderate)
site_visit_date = date                      ; Site visit date
site_visit_result = (failed, passed)        ; Site visit result

{@enrollment}

; Verification - Per 42 CFR 455.412
{.verification}
license_verified = ?                        ; License verified
npi_verified = ?                            ; NPI verified
exclusion_checked = ?                       ; Exclusion databases checked
sam_checked = ?                             ; SAM.gov checked
oig_leie_checked = ?                        ; OIG LEIE checked
state_exclusion_checked = ?                 ; State exclusion list checked

{@enrollment}

; Enrollment status
status = @status_record                     ; Status tracking with date and reason
status.status = !(active, denied, inactive, pending, terminated)
denial_reason = :                           ; Reason if denied

{@enrollment}

; Revalidation - Per 42 CFR 455.414
{.revalidation}
revalidation_due = date                     ; Next revalidation due
last_revalidation = date                    ; Last revalidation date
revalidation_cycle = ##:(3..5)              ; Revalidation cycle (years)

{@enrollment}

; ═══════════════════════════════════════════════════════════════════════════════
; PROVIDER AGREEMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 431.107

{@agreement}
agreement_id = !:                           ; Agreement ID
provider_id = !:                            ; Provider enrollment ID
state = !:(2)                               ; State

; Agreement terms - Per 42 CFR 431.107
{.terms}
effective_date = !date                      ; Agreement effective date
expiration_date = date                      ; Expiration date
auto_renewal = ?                            ; Auto-renewal
signed_date = date                          ; Date signed
signatory_name = :                          ; Authorized signatory

{@agreement}

; Required provisions
{.provisions}
accept_medicaid_payment = ?true             ; Accept as payment in full
maintain_records = ?true                    ; Maintain records
allow_audit = ?true                         ; Allow state/federal audit
disclose_ownership = ?true                  ; Disclose ownership/control
comply_title_vi = ?true                     ; Title VI compliance
comply_ada = ?true                          ; ADA compliance
comply_hipaa = ?true                        ; HIPAA compliance

{@agreement}

; Program participation
{.participation}
fee_for_service = ?                         ; Participates in FFS
managed_care[] = :                          ; MCO contracts
programs[] = :                              ; Programs (Medicaid, CHIP, etc.)

{@agreement}

; ═══════════════════════════════════════════════════════════════════════════════
; PRACTICE LOCATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 455.410(b)

{@practice_location}
location_id = !:                            ; Location ID
provider_id = !:                            ; Provider enrollment ID
location_type = !(administrative, mobile, primary, satellite)

; Address
{.address}
address_1 = !:                              ; Street address
address_2 = :                               ; Suite/unit
city = !:                                   ; City
state = !:(2)                               ; State
zip = !:(5..10)                             ; ZIP code
county = :                                  ; County FIPS

{@practice_location}

; Contact
phone = *@phone                             ; Phone number
fax = *@phone                               ; Fax number
hours = :                                   ; Hours of operation
accepting_new = ?                           ; Accepting new patients

{@practice_location}

; Services at location
services[] = :                              ; Services provided
specialty_at_location = :                   ; Specialty practiced

; Accessibility
{.accessibility}
ada_compliant = ?                           ; ADA compliant
wheelchair_accessible = ?                   ; Wheelchair accessible
interpreter_available = ?                   ; Interpreter services
languages[] = :                             ; Languages spoken

{@practice_location}

; ═══════════════════════════════════════════════════════════════════════════════
; PROVIDER SPECIALTY
; ═══════════════════════════════════════════════════════════════════════════════
; Per state taxonomy requirements

{@specialty}
provider_id = !:                            ; Provider enrollment ID
taxonomy_code = !:                          ; NUCC taxonomy code
taxonomy_description = :                    ; Taxonomy description
specialty_type = (primary, secondary)       ; Primary or secondary
board_certified = ?                         ; Board certified
certification_name = :                      ; Certification name
effective_date = date                       ; Effective date
end_date = date                             ; End date

; ═══════════════════════════════════════════════════════════════════════════════
; LICENSE
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 455.412

{@license}
provider_id = !:                            ; Provider enrollment ID
= @license_credential                       ; Inherits license credential fields
license_type = !:                           ; License type (MD, DO, RN, etc.)
restrictions = :                            ; Any restrictions

; DEA information (if applicable)
{.dea}
dea_number = :                              ; DEA number
dea_schedules[] = :                         ; Schedules authorized
dea_expiration = date                       ; DEA expiration

{@license}

; ═══════════════════════════════════════════════════════════════════════════════
; OWNERSHIP AND CONTROL
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 455.104

{@ownership}
provider_id = !:                            ; Provider enrollment ID
disclosure_date = !date                     ; Disclosure date

; Owners - Per 42 CFR 455.104(b)
owners[] = @owner_info                      ; Ownership interests

; Managing employees - Per 42 CFR 455.104(c)
managing_employees[] = @managing_employee   ; Managing employees

; Agents - Per 42 CFR 455.104(c)(2)
agents[] = @agent_info                      ; Billing agents

; Subcontractors - Per 42 CFR 455.104(c)(3)
subcontractors[] = @subcontractor_info      ; Subcontractors

; Related parties
{.related}
related_parties[] = :                       ; Related organizations
common_ownership[] = :                      ; Common ownership entities

{@ownership}

{@owner_info}
name = !:                                   ; Owner name
type = !(entity, individual)                ; Owner type
ownership_percent = #:(0..100)              ; Ownership percentage
ownership_type = (direct, indirect)         ; Ownership type
ssn = *:                                    ; SSN (individuals)
ein = *:                                    ; EIN (entities)
address = @address                          ; Address
date_acquired = date                        ; Date of acquisition

; Adverse actions
{.adverse}
adverse_action = ?                          ; Has adverse action
conviction = ?                              ; Criminal conviction
exclusion = ?                               ; Excluded from program

{@owner_info}

{@managing_employee}
name = !:                                   ; Name
title = :                                   ; Title
ssn = *:                                    ; SSN
dob = *date                                 ; Date of birth
start_date = date                           ; Start date

; Adverse actions
{.adverse}
adverse_action = ?                          ; Has adverse action
conviction = ?                              ; Criminal conviction
exclusion = ?                               ; Excluded from program

{@managing_employee}

{@agent_info}
name = !:                                   ; Agent name
type = !(entity, individual)                ; Agent type
ein_ssn = *:                                ; EIN or SSN
npi = :                                     ; NPI if applicable
services = :                                ; Services provided
compensation = :                            ; Compensation arrangement

{@subcontractor_info}
name = !:                                   ; Subcontractor name
type = !(entity, individual)                ; Type
ein_ssn = *:                                ; EIN or SSN
npi = :                                     ; NPI if applicable
services = :                                ; Services subcontracted

; ═══════════════════════════════════════════════════════════════════════════════
; MCO NETWORK PARTICIPATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 438.206

{@mco_participation}
provider_id = !:                            ; Provider enrollment ID
mco_plan_id = !:                            ; MCO plan ID
contract_id = :                             ; Contract number

; Participation status
status = @enrollment_period                 ; Period with status tracking

{@mco_participation}

; Network tier
{.network}
tier = (preferred, standard)                ; Network tier
accepting_new = ?                           ; Accepting new members
panel_status = (closed, open)               ; Panel status
panel_limit = ##:(0..)                      ; Panel size limit

{@mco_participation}

; Credentialing - Per 42 CFR 438.214
{.credentialing}
credentialed = ?                            ; Credentialed
credentialing_date = date                   ; Credentialing date
recredentialing_due = date                  ; Next recredentialing
delegated_credentialing = ?                 ; Uses delegated credentialing

{@mco_participation}

; ═══════════════════════════════════════════════════════════════════════════════
; SANCTIONS AND EXCLUSIONS
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 455.416 and 1002

{@sanction}
sanction_id = !:                            ; Sanction ID
provider_id = !:                            ; Provider ID
state = :(2)                                ; State (if state sanction)

; Sanction type
sanction_type = !(civil_monetary_penalty, exclusion, payment_suspension, termination)

; Dates
{.dates}
effective_date = !date                      ; Effective date
end_date = date                             ; End date (if not permanent)
reinstatement_date = date                   ; Reinstatement date

{@sanction}

; Basis - Per 42 CFR 1001
{.basis}
basis = !(conviction, fraud, license_action, other, patient_abuse, quality)
description = :                             ; Description
citation = :                                ; Regulatory citation

{@sanction}

; Exclusion database
{.exclusion}
oig_exclusion = ?                           ; OIG LEIE exclusion
sam_exclusion = ?                           ; SAM.gov exclusion
state_exclusion = ?                         ; State exclusion
exclusion_id = :                            ; Exclusion list ID

{@sanction}

; Appeal
{.appeal}
appealed = ?                                ; Appeal filed
appeal_date = date                          ; Appeal date
appeal_outcome = (affirmed, dismissed, reversed)

{@sanction}

; ═══════════════════════════════════════════════════════════════════════════════
; PAYMENT SUSPENSION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 455.23

{@payment_suspension}
suspension_id = !:                          ; Suspension ID
provider_id = !:                            ; Provider ID
state = !:(2)                               ; State

; Suspension details
{.suspension}
suspension_type = !(fraud_investigation, other, overpayment)
effective_date = !date                      ; Effective date
end_date = date                             ; End date
amount_withheld = #$:(0..)                  ; Amount withheld

{@payment_suspension}

; Investigation
{.investigation}
credible_allegation = ?                     ; Credible allegation of fraud
referral_date = date                        ; Referral to law enforcement
investigating_agency = :                    ; Investigating agency

{@payment_suspension}

; Good cause exception - Per 42 CFR 455.23(e)
{.exception}
good_cause_claimed = ?                      ; Good cause exception claimed
good_cause_granted = ?                      ; Exception granted
exception_reason = :                        ; Reason for exception

{@payment_suspension}

; ═══════════════════════════════════════════════════════════════════════════════
; PROVIDER TYPE DEFINITIONS
; ═══════════════════════════════════════════════════════════════════════════════
; Per state provider manuals and 42 CFR

{@provider_type}
type_code = !:                              ; State provider type code
type_name = !:                              ; Provider type name
description = :                             ; Description

; Category
category = !(atypical, facility, group, individual)

; Requirements
{.requirements}
license_required = ?                        ; License required
npi_required = ?                            ; NPI required
taxonomy_codes[] = :                        ; Allowed taxonomy codes
risk_level = (high, limited, moderate)      ; Default risk level

{@provider_type}

; Enrollment requirements
{.enrollment}
fee_required = ?                            ; Enrollment fee required
site_visit_required = ?                     ; Site visit required
fingerprints_required = ?                   ; Fingerprints required
background_check = ?                        ; Background check required

{@provider_type}

; Billing
{.billing}
fee_schedule = :                            ; Applicable fee schedule
billing_taxonomy = :                        ; Billing taxonomy
claim_type = (dental, institutional, pharmacy, professional)

{@provider_type}


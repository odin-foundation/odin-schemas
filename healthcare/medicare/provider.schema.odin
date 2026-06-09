; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Medicare Provider Enrollment Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Medicare provider enrollment and certification covering CMS-855 applications,
; PECOS, screening, and revalidation. Derived from CMS-855 forms and 42 CFR
; Part 424.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as medicare
@import "../types.schema.odin" as fhir

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.medicare.provider"
version = "1.0.0"
title = "Medicare Provider Enrollment Schema"
description = "Medicare provider enrollment and certification"

{$derivation}
source[0].authority = "CMS"
source[0].citation = "CMS-855A Medicare Enrollment Application - Institutional Providers"
source[0].url = "https://www.cms.gov/medicare/forms-notices/cms-forms-list"

source[1].authority = "CMS"
source[1].citation = "CMS-855B Medicare Enrollment Application - Clinics/Group Practices"
source[1].url = "https://www.cms.gov/medicare/forms-notices/cms-forms-list"

source[2].authority = "CMS"
source[2].citation = "CMS-855I Medicare Enrollment Application - Individual Practitioners"
source[2].url = "https://www.cms.gov/medicare/forms-notices/cms-forms-list"

source[3].authority = "GPO"
source[3].citation = "42 CFR Part 424 Subpart P - Requirements for Establishing and Maintaining Medicare Billing Privileges"
source[3].url = "https://www.ecfr.gov/current/title-42/chapter-IV/subchapter-B/part-424/subpart-P"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial Medicare provider enrollment schema"
changelog[0].rationale = "Structure derived from CMS-855 forms and 42 CFR Part 424"

; ═══════════════════════════════════════════════════════════════════════════════
; PROVIDER ENROLLMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per CMS-855 application structure

{@enrollment}
; Application identification
application_id = :                          ; Application tracking number
pecos_id = :                                 ; PECOS system ID
enrollment_type = (change_of_information, initial, reactivation, revalidation)

; Provider type - Per 42 CFR 424.510
provider_type = (dme_supplier, group, individual, institutional)
application_form = (cms_855a, cms_855b, cms_855i, cms_855o, cms_855r, cms_855s)

; ───────────────────────────────────────────────────────────────────────────────
; Identifying Information - CMS-855 Section 2
; ───────────────────────────────────────────────────────────────────────────────
{.identification}
npi = :/^\d{10}$/                           ; National Provider Identifier
legal_business_name = :                      ; Legal business name (organizations)
doing_business_as = :                        ; DBA name
tax_id = *:                                  ; Tax Identification Number (EIN or SSN)
tax_id_type = (ein, ssn)                     ; Tax ID type

; Individual provider (CMS-855I)
{.individual}
first_name = :                               ; First name
last_name = :                                ; Last name
middle_name = :                              ; Middle name
suffix = :                                   ; Suffix
date_of_birth = *date                        ; Date of birth
ssn = *:/^\d{9}$/                            ; Social Security Number
gender = (female, male)                      ; Sex
state_of_birth = :(2)                        ; State of birth
country_of_birth = :(2..3)                   ; Country of birth

{@enrollment.identification}

{@enrollment}

; ───────────────────────────────────────────────────────────────────────────────
; Practice Location - CMS-855 Section 4
; ───────────────────────────────────────────────────────────────────────────────
practice_locations[] = @practice_location    ; Practice locations

{@practice_location}
location_id = :                              ; Location identifier
primary_location = ?                         ; Primary practice location

; Location address and contact
address = @address                          ; Physical address
phone = *@phone                              ; Phone number
fax = *@phone                                ; Fax number

{@practice_location}

; Location type
{.location_type}
private_practice = ?                         ; Private practice office
hospital = ?                                 ; Hospital
snf = ?                                      ; Skilled nursing facility
asc = ?                                      ; Ambulatory surgical center
clinic = ?                                   ; Clinic/group practice
laboratory = ?                               ; Laboratory
other = ?                                    ; Other setting

{@practice_location}

; Accreditation
{.accreditation}
cms_certified = ?                            ; CMS certified location
ccn = :                                      ; CMS Certification Number
accreditation_org = :                        ; Accreditation organization
accreditation_date = date                    ; Accreditation date

{@practice_location}

; Special services
{.services}
accepts_assignment = ?                       ; Accepts Medicare assignment
part_b_services = ?                          ; Provides Part B services
dmepos = ?                                   ; DMEPOS supplier
laboratory = ?                               ; Laboratory services
imaging = ?                                  ; Imaging services

{@enrollment}

; ───────────────────────────────────────────────────────────────────────────────
; Specialty/Provider Type - CMS-855 Section 2
; ───────────────────────────────────────────────────────────────────────────────
specialties[] = @provider_specialty          ; Provider specialties

{@provider_specialty}
specialty_code = :                          ; Medicare specialty code
specialty_description = :                    ; Specialty description
primary = ?                                  ; Primary specialty
board_certified = ?                          ; Board certified
certification_date = date                    ; Certification date
recertification_date = date                  ; Recertification due date

{@enrollment}

; ───────────────────────────────────────────────────────────────────────────────
; License Information - CMS-855 Section 3
; ───────────────────────────────────────────────────────────────────────────────
licenses[] = @provider_license               ; State licenses

{@provider_license}
= @license_credential                        ; Inherits license credential fields
license_type = (dea, medical, nursing, other, pharmacy, state)

{@enrollment}

; ───────────────────────────────────────────────────────────────────────────────
; Adverse Actions - CMS-855 Section 5
; ───────────────────────────────────────────────────────────────────────────────
{.adverse_actions}
any_adverse = ?                              ; Any adverse actions to report
felony_conviction = ?                        ; Felony conviction
license_revocation = ?                       ; License revocation/suspension
exclusion_history = ?                        ; Prior Medicare/Medicaid exclusion
loss_of_privileges = ?                       ; Loss of hospital privileges
sanctions = ?                                ; Other sanctions

{@enrollment.adverse_actions.details[]}
action_type = (exclusion, felony, license_action, loss_of_privileges, other_sanction)
date = date                                  ; Date of action
state = :(2)                                 ; State where action occurred
description = :                              ; Description of action
resolution = :                               ; Resolution/current status

{@enrollment}

; ───────────────────────────────────────────────────────────────────────────────
; Ownership/Control - CMS-855 Section 6
; ───────────────────────────────────────────────────────────────────────────────
owners[] = @owner_info                       ; Owners with 5%+ interest

{@owner_info}
entity_type = (individual, organization)
name = :                                     ; Owner name
title = :                                    ; Title/position
ownership_percent = #:(5..100)               ; Ownership percentage
date_acquired = date                         ; Date interest acquired

; Individual owner details
{.individual}
ssn = *:/^\d{9}$/                            ; SSN (if individual)
date_of_birth = *date                        ; Date of birth
address = @address                           ; Address

{@owner_info}

; Organization owner details
{.organization}
ein = *:                                     ; EIN (if organization)
legal_name = :                               ; Legal name
address = @address                           ; Business address

{@owner_info}

{@enrollment}

; Managing employees - CMS-855 Section 6
managing_employees[] = @managing_employee    ; Managing employees

{@managing_employee}
= @person                                    ; Inherits person fields (name, ssn, dob, address)

title = :                                    ; Title/position
start_date = date                            ; Employment start date

{@enrollment}

; ───────────────────────────────────────────────────────────────────────────────
; Billing/Payment Information - CMS-855 Section 7
; ───────────────────────────────────────────────────────────────────────────────
{.billing}
assignment_acceptance = (assigned, non_assigned, participating)
eft_authorization = ?                        ; EFT payment authorized

; EFT information
{.eft}
bank_name = :                                ; Bank name
routing_number = *:                          ; Routing number
account_number = *:                          ; Account number
account_type = (checking, savings)           ; Account type

{@enrollment.billing}

; Billing agent
{.billing_agent}
uses_agent = ?                               ; Uses billing agent
agent_name = :                               ; Billing agent name
agent_ein = *:                               ; Agent EIN
agent_address = @address                     ; Agent address

{@enrollment}

; ───────────────────────────────────────────────────────────────────────────────
; Application Status
; ───────────────────────────────────────────────────────────────────────────────
{.status}
status = (approved, denied, pending_review, returned, revoked, withdrawn)
submission_date = date                       ; Application submission date
effective_date = date                        ; Enrollment effective date
decision_date = date                         ; Decision date
denial_reason = :                            ; Reason if denied
revocation_reason = :                        ; Reason if revoked

{@enrollment}

; Revalidation - Per 42 CFR 424.515
{.revalidation}
revalidation_due = date                      ; Revalidation due date
last_revalidated = date                      ; Last revalidation date
revalidation_cycle = ##:(3..5)               ; Revalidation cycle (years)

{@enrollment}

; ═══════════════════════════════════════════════════════════════════════════════
; PECOS RECORD
; ═══════════════════════════════════════════════════════════════════════════════
; Provider Enrollment, Chain, and Ownership System record

{@pecos_record}
pecos_id = :                                ; PECOS system ID
npi = :/^\d{10}$/                            ; NPI
ptan = :                                     ; Provider Transaction Access Number

; Record status
{.record}
status = (active, deactivated, revoked)
effective_date = date                        ; Record effective date
termination_date = date                      ; Termination date
updated = timestamp                          ; Last update timestamp

{@pecos_record}

; Enrollment associations
enrollments[] = :                            ; Associated enrollment IDs
reassignments[] = @reassignment              ; Reassignment relationships

; ═══════════════════════════════════════════════════════════════════════════════
; REASSIGNMENT OF BENEFITS
; ═══════════════════════════════════════════════════════════════════════════════
; Per CMS-855R - Reassignment of Medicare Benefits

{@reassignment}
individual_npi = :/^\d{10}$/                ; Individual practitioner NPI
organization_npi = :/^\d{10}$/               ; Organization NPI (reassigning to)
effective_date = date                       ; Reassignment effective date
termination_date = date                      ; Termination date

; Relationship type
relationship = (
    contractor,
    employee,
    group_member,
    independent_contractor,
    locum_tenens,
    owner
)

; Status
status = (active, pending, terminated)
termination_reason = (employment_ended, individual_request, organization_request, other):if status = terminated

; ═══════════════════════════════════════════════════════════════════════════════
; PROVIDER CERTIFICATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR Part 488 - Survey and Certification

{@certification}
ccn = :/^\d{6}$/                            ; CMS Certification Number
provider_type = (asc, cah, esrd, hha, hospice, hospital, icf_iid, laboratory, ltc, otp, otp_bh, outpatient_rehab, psychiatric, rnhci, snf)
facility_name = :                           ; Facility name

; Certification status
{.status}
certified = ?                               ; Currently certified
initial_certification_date = date            ; Initial certification date
current_certification_date = date            ; Current certification date
termination_date = date                      ; Termination date (if applicable)
participation_date = date                    ; Medicare participation date

{@certification}

; Survey history
{.survey}
last_survey_date = date                      ; Last survey date
survey_type = (abbreviated, complaint, full, life_safety, recertification, validation)
survey_result = (compliant, deficient, not_surveyed)
next_survey_due = date                       ; Next survey due date

{@certification}

; Deficiencies
deficiencies[] = @deficiency                 ; Current deficiencies

{@deficiency}
tag = :                                      ; Deficiency tag number
description = :                              ; Deficiency description
scope_severity = :                           ; Scope and severity code
citation_date = date                         ; Date cited
correction_date = date                       ; Date corrected
idr_requested = ?                            ; Informal Dispute Resolution requested

{@certification}

; Accreditation - Per 42 CFR 488.5
{.accreditation}
accredited = ?                               ; Accreditation-based participation
accreditation_org = (aaahc, achc, aoa, chap, cihq, dnv, joint_commission, other)
accreditation_date = date                    ; Current accreditation date
accreditation_expiration = date              ; Accreditation expiration
deemed_status = ?                            ; Has deemed status

{@certification}

; ═══════════════════════════════════════════════════════════════════════════════
; ORDERING/REFERRING PROVIDER
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 424.507 - Ordering and Referring requirements

{@ordering_referring}
npi = :/^\d{10}$/                           ; Provider NPI
name_first = :                               ; First name
name_last = :                                ; Last name
eligible = ?                                ; Eligible to order/refer

; Eligibility requirements
{.eligibility}
enrolled_in_medicare = ?                     ; Enrolled in Medicare
opted_out = ?                                ; Opted out of Medicare
valid_license = ?                            ; Has valid state license
provider_type_eligible = ?                   ; Provider type can order/refer

{@ordering_referring}

; Opt-out status - Per 42 CFR 405.440
{.opt_out}
opted_out = ?                                ; Has opted out
opt_out_effective = date                     ; Opt-out effective date
opt_out_expiration = date                    ; Opt-out expiration (2 years)
private_contracts_required = ?               ; Must use private contracts

{@ordering_referring}


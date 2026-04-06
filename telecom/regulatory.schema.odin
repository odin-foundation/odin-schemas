; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Telecom Regulatory Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Regulatory compliance including CPNI consent, Lifeline/ACP programs, CALEA,
; E911 service, FCC reporting, and regulatory obligations.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.telecom.regulatory"
version = "1.0.0"
title = "Telecom Regulatory Schema"
description = "CPNI consent, Lifeline/ACP, CALEA, E911, and FCC reporting"

{$derivation}
source[0].authority = "Federal Communications Commission"
source[0].citation = "47 CFR Part 64, Subpart U - Customer Proprietary Network Information"
source[0].url = "https://www.ecfr.gov/current/title-47/chapter-I/subchapter-B/part-64/subpart-U"

source[1].authority = "Federal Communications Commission"
source[1].citation = "47 CFR Part 54 - Universal Service (Lifeline/ACP)"
source[1].url = "https://www.ecfr.gov/current/title-47/chapter-I/subchapter-B/part-54"

source[2].authority = "Federal Communications Commission"
source[2].citation = "47 CFR Part 9 - 911 Requirements"
source[2].url = "https://www.ecfr.gov/current/title-47/chapter-I/subchapter-A/part-9"

source[3].authority = "Federal Communications Commission"
source[3].citation = "47 CFR Part 64, Subpart J - CALEA"
source[3].url = "https://www.ecfr.gov/current/title-47/chapter-I/subchapter-B/part-64/subpart-J"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial regulatory schema"
changelog[0].rationale = "Regulatory compliance structures derived from FCC regulations"

; ═══════════════════════════════════════════════════════════════════════════════
; CPNI CONSENT
; ═══════════════════════════════════════════════════════════════════════════════
; Customer Proprietary Network Information consent record

{@cpni_consent}
= @types.audit_info

; ───────────────────────────────────────────────────────────────────────────────
; Consent Identification
; ───────────────────────────────────────────────────────────────────────────────
consent_id = !:                                   ; Unique consent identifier
account_ref = !:                                  ; Account reference

; ───────────────────────────────────────────────────────────────────────────────
; Consent Details
; ───────────────────────────────────────────────────────────────────────────────
{.consent}
opt_in = !?                                       ; Opt-in consent granted
opt_in_date = date                                ; Opt-in date
opt_out_date = date                               ; Opt-out date (if withdrawn)
consent_method = (in_person, online, phone, written)
consent_verified = ?                              ; Consent verified

{@cpni_consent}

; ───────────────────────────────────────────────────────────────────────────────
; Consent Scope
; ───────────────────────────────────────────────────────────────────────────────
{.scope}
marketing_consent = ?                             ; Marketing use consent
affiliate_sharing = ?                             ; Affiliate sharing consent
third_party_sharing = ?                           ; Third-party sharing consent
joint_venture_sharing = ?                         ; Joint venture sharing consent

{@cpni_consent}

; ───────────────────────────────────────────────────────────────────────────────
; CPNI Data Types Covered
; ───────────────────────────────────────────────────────────────────────────────
{.data_types}
call_details = ?                                  ; Call detail records
location_data = ?                                 ; Location information
usage_data = ?                                    ; Service usage data
billing_data = ?                                  ; Billing information

{@cpni_consent}

; ───────────────────────────────────────────────────────────────────────────────
; Consent Lifecycle
; ───────────────────────────────────────────────────────────────────────────────
{.lifecycle}
expiration_date = date                            ; Consent expiration date
renewed_date = date                               ; Renewal date
status = (active, expired, withdrawn)
status_date = date                                ; Status change date

{@cpni_consent}

; ───────────────────────────────────────────────────────────────────────────────
; Verification and Authentication
; ───────────────────────────────────────────────────────────────────────────────
{.verification}
password_authentication = ?                       ; Password used for authentication
account_number_verified = ?                       ; Account number verified
ssn_last_four_verified = ?                        ; SSN last 4 verified
verification_date = date                          ; Verification date
verified_by = :                                   ; Agent who verified

{@cpni_consent}

; ═══════════════════════════════════════════════════════════════════════════════
; LIFELINE/ACP ENROLLMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Low-income assistance program enrollment (Lifeline/Affordable Connectivity Program)

{@assistance_enrollment}
= @types.audit_info

; ───────────────────────────────────────────────────────────────────────────────
; Enrollment Identification
; ───────────────────────────────────────────────────────────────────────────────
enrollment_id = !:                                ; Unique enrollment identifier
account_ref = !:                                  ; Account reference

; ───────────────────────────────────────────────────────────────────────────────
; Program Type
; ───────────────────────────────────────────────────────────────────────────────
program_type = (acp, lifeline, tribal_lifeline)

; ───────────────────────────────────────────────────────────────────────────────
; Enrollment Details
; ───────────────────────────────────────────────────────────────────────────────
{.enrollment}
enrollment_date = !date                           ; Enrollment date
enrollment_status = (active, de_enrolled, pending, suspended)
status_date = date                                ; Status change date
status_reason = :                                 ; Status reason

{@assistance_enrollment}

; ───────────────────────────────────────────────────────────────────────────────
; Eligibility Basis
; ───────────────────────────────────────────────────────────────────────────────
{.eligibility}
eligibility_basis = (
    income_based,
    medicaid,
    program_based,
    snap,
    ssi,
    tribal,
    veterans_pension
)
eligibility_verified = !?                         ; Eligibility verified
verification_date = date                          ; Verification date
verification_method = (autopay, document, nlad)   ; Verification method
nlad_check_date = date                            ; NLAD check date

{@assistance_enrollment}

; ───────────────────────────────────────────────────────────────────────────────
; Household Information
; ───────────────────────────────────────────────────────────────────────────────
{.household}
household_id = *:                                 ; Household identifier (confidential)
household_size = ##:(1..)                         ; Number of household members
household_income = *#$:(0..)                      ; Annual household income (confidential)
duplicate_check = ?                               ; Duplicate household check performed
one_per_household_certified = ?                   ; One-per-household rule certified

{@assistance_enrollment}

; ───────────────────────────────────────────────────────────────────────────────
; Benefit Amount
; ───────────────────────────────────────────────────────────────────────────────
{.benefit}
monthly_discount = !#$:(0..)                      ; Monthly discount amount
device_discount = #$:(0..)                        ; One-time device discount
tribal_enhancement = #$:(0..)                     ; Tribal enhancement (if applicable)

{@assistance_enrollment}

; ───────────────────────────────────────────────────────────────────────────────
; Recertification
; ───────────────────────────────────────────────────────────────────────────────
{.recertification}
recertification_due = !date                       ; Next recertification date
recertification_completed = ?                     ; Recertification completed
last_recertification = date                       ; Last recertification date
recertification_method = (annual, autopay, nlad)

{@assistance_enrollment}

; ───────────────────────────────────────────────────────────────────────────────
; De-enrollment
; ───────────────────────────────────────────────────────────────────────────────
{.de_enrollment}
de_enrollment_date = date                         ; De-enrollment date
de_enrollment_reason = (
    duplicate,
    ineligible,
    non_usage,
    recertification_failure,
    voluntary
)
grace_period_end = date                           ; Grace period end date

{@assistance_enrollment}

; ═══════════════════════════════════════════════════════════════════════════════
; E911 REGISTRATION
; ═══════════════════════════════════════════════════════════════════════════════
; Enhanced 911 service registration

{@e911_registration}
= @types.audit_info

; ───────────────────────────────────────────────────────────────────────────────
; Registration Identification
; ───────────────────────────────────────────────────────────────────────────────
registration_id = !:                              ; Unique registration identifier
subscription_ref = !:                             ; Subscription reference
phone_number = !*:                                ; Phone number (CPNI)

; ───────────────────────────────────────────────────────────────────────────────
; Service Type
; ───────────────────────────────────────────────────────────────────────────────
service_type = (mobile, voip, wireline)
voip_provider = :                                 ; VoIP provider name (if applicable)

; ───────────────────────────────────────────────────────────────────────────────
; Registered Address (Required for VoIP/Fixed Wireless)
; ───────────────────────────────────────────────────────────────────────────────
{.registered_address}
address = @types.address                          ; Registered E911 address
address_type = (business, residential, temporary)
address_verified = !?                             ; Address verified
verification_date = date                          ; Verification date
verification_method = (customer_provided, geocoded, manual_validation)

{@e911_registration}

; ───────────────────────────────────────────────────────────────────────────────
; Location Information
; ───────────────────────────────────────────────────────────────────────────────
{.location}
latitude = #:(-90..90)                            ; GPS latitude
longitude = #:(-180..180)                         ; GPS longitude
location_confidence = (high, low, medium)         ; Location confidence level
dispatchable_location = ?                         ; Dispatchable location available

{@e911_registration}

; ───────────────────────────────────────────────────────────────────────────────
; PSAP Assignment
; ───────────────────────────────────────────────────────────────────────────────
{.psap}
psap_id = :                                       ; Public Safety Answering Point ID
psap_name = :                                     ; PSAP name
primary_psap = :                                  ; Primary PSAP
backup_psap = :                                   ; Backup PSAP
selective_router = :                              ; Selective router

{@e911_registration}

; ───────────────────────────────────────────────────────────────────────────────
; Registration Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, inactive, pending_verification)
status_date = date                                ; Status change date
updated = timestamp                               ; Last update timestamp
updated_by = :                                    ; Last updated by

; ───────────────────────────────────────────────────────────────────────────────
; Nomadic Service (VoIP)
; ───────────────────────────────────────────────────────────────────────────────
{.nomadic}
nomadic_service = ?                               ; Nomadic/mobile VoIP service
location_update_required = ?                      ; Location update required
location_updated = timestamp                      ; Last location update
customer_notified = ?                             ; Customer notified of update requirement

{@e911_registration}

; ═══════════════════════════════════════════════════════════════════════════════
; E911 CALL RECORD
; ═══════════════════════════════════════════════════════════════════════════════
; Emergency 911 call record

{@e911_call}
= @types.audit_info

; ───────────────────────────────────────────────────────────────────────────────
; Call Identification
; ───────────────────────────────────────────────────────────────────────────────
call_id = !:                                      ; Unique call identifier
esrn = :                                          ; Emergency Service Routing Number
esqk = :                                          ; Emergency Service Query Key

; ───────────────────────────────────────────────────────────────────────────────
; Caller Information (CPNI)
; ───────────────────────────────────────────────────────────────────────────────
calling_number = !*:                              ; Calling number (CPNI)
callback_number = *:                              ; Callback number
subscription_ref = :                              ; Subscription reference

; ───────────────────────────────────────────────────────────────────────────────
; Call Timing
; ───────────────────────────────────────────────────────────────────────────────
{.timing}
call_start = !timestamp                           ; Call start timestamp
call_end = timestamp                              ; Call end timestamp
duration_seconds = ##:(0..)                       ; Call duration

{@e911_call}

; ───────────────────────────────────────────────────────────────────────────────
; Location Information
; ───────────────────────────────────────────────────────────────────────────────
{.location}
registered_address = @types.address               ; Registered address (VoIP)
cell_tower_id = :                                 ; Cell tower ID (mobile)
sector_id = :                                     ; Sector ID
latitude = #:(-90..90)                            ; GPS latitude
longitude = #:(-180..180)                         ; GPS longitude
altitude_meters = #                               ; Altitude
location_confidence = (high, low, medium)         ; Location confidence
location_method = (cell_id, gps, registered, wifi)

{@e911_call}

; ───────────────────────────────────────────────────────────────────────────────
; PSAP Information
; ───────────────────────────────────────────────────────────────────────────────
{.psap}
psap_id = :                                       ; PSAP identifier
psap_name = :                                     ; PSAP name
ali_database_queried = ?                          ; ALI database queried
ali_query_time = timestamp                        ; ALI query timestamp

{@e911_call}

; ───────────────────────────────────────────────────────────────────────────────
; Call Disposition
; ───────────────────────────────────────────────────────────────────────────────
call_connected = !?                               ; Call successfully connected to PSAP
connection_time_seconds = #:(0..)                 ; Time to connect to PSAP
transfer_count = ##:(0..)                         ; Number of transfers
disconnect_reason = :                             ; Disconnect reason

; ═══════════════════════════════════════════════════════════════════════════════
; CALEA REQUEST
; ═══════════════════════════════════════════════════════════════════════════════
; Communications Assistance for Law Enforcement Act request

{@calea_request}
= @types.audit_info

; ───────────────────────────────────────────────────────────────────────────────
; Request Identification
; ───────────────────────────────────────────────────────────────────────────────
request_id = !*:                                  ; Unique request identifier (confidential)
case_number = *:                                  ; Case number (confidential)

; ───────────────────────────────────────────────────────────────────────────────
; Legal Authority
; ───────────────────────────────────────────────────────────────────────────────
{.authority}
issuing_agency = !*:                              ; Law enforcement agency (confidential)
agency_contact = *:                               ; Agency contact (confidential)
court_order_number = *:                           ; Court order number (confidential)
court_jurisdiction = *:                           ; Court jurisdiction (confidential)
authorization_type = (court_order, subpoena, warrant)

{@calea_request}

; ───────────────────────────────────────────────────────────────────────────────
; Target Information (Confidential)
; ───────────────────────────────────────────────────────────────────────────────
{.target}
target_phone_number = *:                          ; Target phone number (confidential)
target_imsi = *:                                  ; Target IMSI (confidential)
target_name = *:                                  ; Target name (confidential)
subscription_ref = *:                             ; Subscription reference (confidential)
account_ref = *:                                  ; Account reference (confidential)

{@calea_request}

; ───────────────────────────────────────────────────────────────────────────────
; Intercept Details
; ───────────────────────────────────────────────────────────────────────────────
{.intercept}
intercept_type = (content, pen_register, trap_and_trace)
content_types[] = (call_content, location, messaging, transaction_data)
delivery_method = (ftp, physical_media, real_time_stream, sftp)
delivery_address = *:                             ; Delivery address (confidential)

{@calea_request}

; ───────────────────────────────────────────────────────────────────────────────
; Request Timing
; ───────────────────────────────────────────────────────────────────────────────
{.timing}
received_date = !date                             ; Request received date
activation_date = !date                           ; Intercept activation date
expiration_date = date                            ; Intercept expiration date
deactivation_date = date                          ; Deactivation date

{@calea_request}

; ───────────────────────────────────────────────────────────────────────────────
; Request Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, completed, deactivated, pending)
status_date = timestamp                           ; Status change timestamp

; ───────────────────────────────────────────────────────────────────────────────
; Compliance and Tracking
; ───────────────────────────────────────────────────────────────────────────────
{.compliance}
compliance_officer = *:                           ; Compliance officer assigned (confidential)
technical_contact = *:                            ; Technical contact (confidential)
activation_time_hours = #:(0..)                   ; Hours to activate
delivery_success = ?                              ; Delivery successful

{@calea_request}

; ═══════════════════════════════════════════════════════════════════════════════
; FCC REPORT
; ═══════════════════════════════════════════════════════════════════════════════
; FCC regulatory report or filing

{@fcc_report}
= @types.audit_info

; ───────────────────────────────────────────────────────────────────────────────
; Report Identification
; ───────────────────────────────────────────────────────────────────────────────
report_id = !:                                    ; Unique report identifier
fcc_filing_id = :                                 ; FCC filing ID
report_type = (
    annual_report,
    calea_compliance,
    cpni_certification,
    network_outage,
    number_portability,
    robocall_mitigation,
    universal_service
)

; ───────────────────────────────────────────────────────────────────────────────
; Report Period
; ───────────────────────────────────────────────────────────────────────────────
{.period}
reporting_period_start = !date                    ; Reporting period start
reporting_period_end = !date                      ; Reporting period end
report_year = ##:(2000..)                         ; Report year

{@fcc_report}

; ───────────────────────────────────────────────────────────────────────────────
; Filing Information
; ───────────────────────────────────────────────────────────────────────────────
{.filing}
filed_date = date                                 ; Filing date
due_date = !date                                  ; Filing due date
filed_by = :                                      ; Person who filed
filing_method = (ecfs, online_portal, paper)
confirmation_number = :                           ; Filing confirmation number

{@fcc_report}

; ───────────────────────────────────────────────────────────────────────────────
; Report Status
; ───────────────────────────────────────────────────────────────────────────────
status = (accepted, draft, filed, rejected)
status_date = date                                ; Status change date

; ───────────────────────────────────────────────────────────────────────────────
; Filer Information
; ───────────────────────────────────────────────────────────────────────────────
{.filer}
company_name = !:                                 ; Company name
frn = :/^\d{10}$/                                 ; FCC Registration Number
contact_name = :                                  ; Contact person
contact_email = *@types.email                     ; Contact email
contact_phone = *@types.phone                     ; Contact phone

{@fcc_report}

; ═══════════════════════════════════════════════════════════════════════════════
; REGULATORY COMPLIANCE RECORD
; ═══════════════════════════════════════════════════════════════════════════════
; General regulatory compliance tracking

{@compliance_record}
= @types.audit_info

; ───────────────────────────────────────────────────────────────────────────────
; Record Identification
; ───────────────────────────────────────────────────────────────────────────────
record_id = !:                                    ; Unique record identifier
compliance_area = (billing_practices, calea, cpni, e911, number_portability, privacy, robocall, universal_service)

; ───────────────────────────────────────────────────────────────────────────────
; Compliance Details
; ───────────────────────────────────────────────────────────────────────────────
{.compliance}
compliant = !?                                    ; Compliance status
compliance_date = date                            ; Compliance date
audit_date = date                                 ; Last audit date
next_audit_date = date                            ; Next scheduled audit

{@compliance_record}

; ───────────────────────────────────────────────────────────────────────────────
; Regulation Reference
; ───────────────────────────────────────────────────────────────────────────────
{.regulation}
cfr_citation = :                                  ; CFR citation (e.g., "47 CFR 64.1200")
regulation_title = :                              ; Regulation title
effective_date = date                             ; Regulation effective date

{@compliance_record}

; ───────────────────────────────────────────────────────────────────────────────
; Issues and Remediation
; ───────────────────────────────────────────────────────────────────────────────
{.issues}
issues_found = ?                                  ; Compliance issues found
issue_description = :                             ; Issue description
severity = (critical, high, low, medium)
remediation_plan = :                              ; Remediation plan
remediation_deadline = date                       ; Remediation deadline
remediation_complete = ?                          ; Remediation completed
remediation_date = date                           ; Remediation completion date

{@compliance_record}

; ───────────────────────────────────────────────────────────────────────────────
; Responsible Parties
; ───────────────────────────────────────────────────────────────────────────────
{.responsible}
compliance_officer = :                            ; Compliance officer
legal_contact = :                                 ; Legal contact
technical_contact = :                             ; Technical contact

{@compliance_record}

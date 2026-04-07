; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Legal Common Types
; ═══════════════════════════════════════════════════════════════════════════════
; Reusable type definitions shared across legal practice management schemas.
; Includes party types, matter references, court information, document
; tracking, and billing structures used by litigation, transactional,
; regulatory, and IP matter schemas.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as common
@import "../insurance/common/party.schema.odin" as party
@import "../realestate/types.schema.odin" as re
@import "../mortgage/types.schema.odin" as mtg

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.legal.types"
version = "1.0.0"
title = "Legal Common Types"
description = "Reusable type definitions for legal practice management"

{$derivation}
source[0].authority = "American Bar Association"
source[0].citation = "Model Rules of Professional Conduct"
source[0].url = "https://www.americanbar.org/groups/professional_responsibility/publications/model_rules_of_professional_conduct/"

source[1].authority = "Legal Electronic Data Exchange Standard"
source[1].citation = "LEDES 1998B/2000/eBilling Formats"
source[1].url = "https://ledes.org/ledes-98b-format/"

source[2].authority = "Uniform Task-Based Management System"
source[2].citation = "UTBMS Litigation and Counseling Codes"
source[2].url = "https://ledes.org/utbms/"

source[3].authority = "Administrative Office of the U.S. Courts"
source[3].citation = "Federal Court Rules and PACER Standards"
source[3].url = "https://www.uscourts.gov/"

source[4].authority = "Electronic Discovery Reference Model"
source[4].citation = "EDRM Framework"
source[4].url = "https://edrm.net/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Common types derived from ABA model rules, LEDES billing standards, and court filing requirements"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial legal common types schema"
changelog[0].rationale = "Base types for legal practice management"

; ═══════════════════════════════════════════════════════════════════════════════
; BAR ADMISSION
; ═══════════════════════════════════════════════════════════════════════════════
; State bar admission and licensing information per state bar associations

{@legal_bar_admission}
= @license_credential                             ; Inherits license/credential fields

; Override required fields
number = !*:                                      ; State bar number (required, confidential)
state_province = !:(2..50)                        ; State/jurisdiction (required)
type = : "bar_admission"                          ; License type
status = !(active, deceased, disbarred, inactive, resigned, retired, suspended)

; Court admissions
{.court_admissions[]}
court_name = :                                    ; Court name
court_type = (appellate, district, state_supreme, supreme, tribal)
admission_date = date                             ; Date admitted
admission_number = :                              ; Court admission number

{@legal_bar_admission}

; Disciplinary history (if any)
disciplinary_action = ?                           ; Has disciplinary history
last_disciplinary_date = date:if disciplinary_action = true

; ═══════════════════════════════════════════════════════════════════════════════
; ATTORNEY
; ═══════════════════════════════════════════════════════════════════════════════
; Licensed attorney (lawyer/counsel)

{@legal_attorney}
= @person                                         ; Inherits person fields

; Required fields first
primary_bar = !@legal_bar_admission               ; Primary bar admission

; Attorney identification
attorney_id = :                                   ; Unique attorney identifier
ledes_attorney_id = :                             ; LEDES attorney identifier

; Practice information
{.practice}
practice_areas[] = :                              ; Areas of practice
seniority = (associate, counsel, junior_associate, of_counsel, partner, senior_associate, senior_partner, staff_attorney)
title = :                                         ; Professional title
years_experience = ##:(0..)                       ; Years in practice

{@legal_attorney}

; Bar admissions
bar_admissions[] = @legal_bar_admission           ; All bar admissions

; Firm affiliation
firm_name = :                                     ; Law firm name
firm_ref = @legal_firm                            ; Reference to firm

; Billing information
{.billing}
standard_rate = #$:(0..)                          ; Standard hourly rate
ledes_timekeeper_id = :                           ; LEDES timekeeper ID
timekeeper_classification = :                     ; UTBMS timekeeper classification

{@legal_attorney}

; ═══════════════════════════════════════════════════════════════════════════════
; LAW FIRM
; ═══════════════════════════════════════════════════════════════════════════════
; Law firm or legal organization

{@legal_firm}
= @organization                                   ; Inherits organization fields

; Firm identification
firm_id = :                                       ; Unique firm identifier
ledes_law_firm_id = :                             ; LEDES law firm ID

; Firm details
{.details}
firm_type = (am_law_100, boutique, government, in_house, large, mid_size, public_interest, small, solo)
founding_date = date                              ; Date firm founded
attorney_count = ##:(1..)                         ; Number of attorneys
office_count = ##:(1..)                           ; Number of offices
managing_partner = :                              ; Managing partner name

{@legal_firm}

; Offices
{.offices[]}
office_id = :                                     ; Office identifier
office_name = :                                   ; Office name/location
address = @address                                ; Office address
phone = *@phone                                   ; Office phone
main_office = ?                                   ; Is main/headquarters office

{@legal_firm}

; Practice areas
practice_areas[] = :                              ; Areas of practice

; ═══════════════════════════════════════════════════════════════════════════════
; PARALEGAL / LEGAL STAFF
; ═══════════════════════════════════════════════════════════════════════════════
; Non-attorney legal staff

{@legal_staff}
= @person                                         ; Inherits person fields

; Required fields first
staff_type = !(case_manager, clerk, investigator, legal_assistant, legal_nurse, legal_secretary, librarian, litigation_support, paralegal, records_clerk)

; Staff identification
staff_id = :                                      ; Unique staff identifier
ledes_timekeeper_id = :                           ; LEDES timekeeper ID

; Certification (if applicable)
{.certification}
certified = ?                                     ; Holds professional certification
certification_type = ::if certified = true        ; Type of certification
certifying_body = ::if certified = true           ; Certifying organization
certification_number = ::if certified = true      ; Certification number
expiration_date = date:if certified = true        ; Certification expiration

{@legal_staff}

; Employment
firm_ref = @legal_firm                            ; Reference to employing firm
supervisor = :                                    ; Supervising attorney name
department = :                                    ; Department/practice group

; Billing
billable = ?                                      ; Time is billable
hourly_rate = #$:(0..):if billable = true         ; Hourly rate

; ═══════════════════════════════════════════════════════════════════════════════
; JUDGE
; ═══════════════════════════════════════════════════════════════════════════════
; Judicial officer information

{@legal_judge}
= @person                                         ; Inherits person fields

; Required fields first
court_name = !:                                   ; Court name
judge_type = !(administrative_law, appellate, bankruptcy, chief, circuit, district, magistrate, senior, state_court, state_supreme, supreme)

; Judge identification
judge_id = :                                      ; Unique judge identifier

; Court details
{.court}
court_level = (appellate, federal_district, federal_special, state_appellate, state_supreme, state_trial, supreme)
division = :                                      ; Court division
department = :                                    ; Court department
courtroom = :                                     ; Assigned courtroom

{@legal_judge}

; Appointment
appointment_date = date                           ; Date appointed/elected
appointed_by = :                                  ; Appointing authority
term_expiration = date                            ; Term expiration (if applicable)

; Staff
{.staff}
law_clerk_count = ##:(0..)                        ; Number of law clerks
courtroom_deputy = :                              ; Courtroom deputy name
courtroom_deputy_phone = *@phone                  ; Deputy phone
courtroom_deputy_email = *@email                  ; Deputy email

{@legal_judge}

; Preferences
{.preferences}
scheduling_notes = :                              ; Scheduling preferences
motion_practices = :                              ; Motion practice preferences
trial_practices = :                               ; Trial preferences

{@legal_judge}

; ═══════════════════════════════════════════════════════════════════════════════
; COURT INFORMATION
; ═══════════════════════════════════════════════════════════════════════════════
; Court/tribunal information

{@legal_court}
; Required fields first
court_name = !:                                   ; Official court name
court_level = !(appellate, federal_district, federal_special, state_appellate, state_supreme, state_trial, supreme, tribal)

; Court identification
court_id = :                                      ; Unique court identifier
pacer_court_id = :                                ; PACER court identifier (federal)
fips_code = :                                     ; FIPS county code

; Location
{.location}
address = @address                                ; Court address
phone = *@phone                                   ; Court phone
fax = *@phone                                     ; Court fax
website = :                                       ; Court website

{@legal_court}

; Clerk's office
{.clerk}
clerk_name = :                                    ; Clerk of court name
clerk_phone = *@phone                             ; Clerk phone
clerk_email = *@email                             ; Clerk email
efiling_url = :                                   ; E-filing URL

{@legal_court}

; Filing requirements
{.filing}
efiling_required = ?                              ; E-filing mandatory
efiling_system = :                                ; E-filing system name (CM/ECF, etc.)
filing_fee_url = :                                ; Filing fee schedule URL
local_rules_url = :                               ; Local rules URL

{@legal_court}

; ═══════════════════════════════════════════════════════════════════════════════
; MATTER REFERENCE
; ═══════════════════════════════════════════════════════════════════════════════
; Reference to a legal matter (cross-schema linkage)

{@legal_matter_ref}
; Required fields first
matter_id = !:                                    ; Internal matter identifier

; Client reference
client_id = :                                     ; Client identifier
client_matter_id = :                              ; Client's matter reference

; Matter details
matter_name = :                                   ; Matter name/description
matter_type = (ip, litigation, regulatory, transactional)
status = (active, closed, on_hold, pending)

; Billing reference
ledes_matter_id = :                               ; LEDES matter ID

; ═══════════════════════════════════════════════════════════════════════════════
; CASE REFERENCE
; ═══════════════════════════════════════════════════════════════════════════════
; Reference to a court case

{@legal_case_ref}
; Required fields first
case_number = !:                                  ; Court case number

; Case details
caption = :                                       ; Case caption/title
court_ref = @legal_court                          ; Reference to court

; ═══════════════════════════════════════════════════════════════════════════════
; UTBMS CODES
; ═══════════════════════════════════════════════════════════════════════════════
; Uniform Task-Based Management System codes for legal billing

{@legal_utbms_code}
; Required fields first
code = !:                                         ; UTBMS code
code_type = !(activity, expense, litigation_phase, litigation_task, project_phase, project_task)

; Code details
description = :                                   ; Code description
category = :                                      ; Code category
active = ?                                        ; Code is active/current

; ═══════════════════════════════════════════════════════════════════════════════
; LEDES BILLING REFERENCE
; ═══════════════════════════════════════════════════════════════════════════════
; LEDES electronic billing format reference

{@legal_ledes_ref}
; Identification
invoice_number = :                                ; LEDES invoice number
line_item_number = :                              ; Line item number

; LEDES format
ledes_format = (ledes_1998b, ledes_2000, ledes_ebilling_xml, ledes_utbms_2008)

; Timekeeper
timekeeper_id = :                                 ; LEDES timekeeper ID
timekeeper_name = :                               ; Timekeeper name
timekeeper_classification = :                     ; UTBMS classification

; Task/activity codes
task_code = :                                     ; UTBMS task code
activity_code = :                                 ; UTBMS activity code
expense_code = :                                  ; UTBMS expense code

; ═══════════════════════════════════════════════════════════════════════════════
; CONFLICT CHECK
; ═══════════════════════════════════════════════════════════════════════════════
; Conflict of interest check per Model Rules

{@legal_conflict_check}
; Required fields first
check_date = !date                                ; Date of check
checked_by = !:                                   ; Person who ran check
result = !(cleared, conflict_found, potential_conflict, waiver_required)

; Check details
{.details}
check_id = :                                      ; Unique check identifier
matter_ref = @legal_matter_ref                    ; Related matter
parties_checked[] = :                             ; Names/entities checked
database_searched = :                             ; Conflict database name

{@legal_conflict_check}

; Results
{.conflicts[]}
party_name = :                                    ; Conflicting party name
conflict_type = (adverse_party, former_client, related_party, same_matter)
related_matter = :                                ; Related matter description
attorney_involved = :                             ; Attorney with relationship
resolution = (declined, screened, waived)
waiver_obtained = ?:if resolution = waived        ; Waiver obtained
waiver_date = date:if waiver_obtained = true      ; Date waiver obtained

{@legal_conflict_check}

; ═══════════════════════════════════════════════════════════════════════════════
; JURISDICTION
; ═══════════════════════════════════════════════════════════════════════════════
; Jurisdictional information

{@legal_jurisdiction}
; Required fields first
jurisdiction_type = !(federal, international, state, territorial, tribal)

; Federal
federal_circuit = :(2):if jurisdiction_type = federal   ; Circuit number (1-11, DC, Fed)
federal_district = ::if jurisdiction_type = federal     ; District name

; State
state_code = :(2):if jurisdiction_type = state          ; State code
county = ::if jurisdiction_type = state                 ; County name

; Venue
proper_venue = ?                                        ; Venue is proper
venue_basis = :                                         ; Basis for venue

; ═══════════════════════════════════════════════════════════════════════════════
; DEADLINE / DUE DATE
; ═══════════════════════════════════════════════════════════════════════════════
; Legal deadline tracking

{@legal_deadline}
; Required fields first
deadline_date = !date                             ; Due date
deadline_type = !(answer, appeal, brief, complaint, discovery, filing, hearing, motion, response, statute_of_limitations, trial)
description = !:                                  ; Deadline description

; Deadline identification
deadline_id = :                                   ; Unique deadline identifier

; Associated references
matter_ref = @legal_matter_ref                    ; Related matter
case_ref = @legal_case_ref                        ; Related case

; Calculation
{.calculation}
trigger_date = date                               ; Date that triggered deadline
trigger_event = :                                 ; Event that triggered deadline
days_from_trigger = ##                            ; Days from trigger
business_days = ?                                 ; Business days calculation
rule_reference = :                                ; Rule governing deadline

{@legal_deadline}

; Status
status = (completed, extended, missed, pending, waived)
completed_date = date:if status = completed       ; Date completed
extension_date = date:if status = extended        ; New deadline if extended
extension_reason = ::if status = extended         ; Reason for extension

; Assignment
assigned_to = :                                   ; Person responsible
reminder_days = ##:(0..)                          ; Days before for reminder

; ═══════════════════════════════════════════════════════════════════════════════
; PRIVILEGE DESIGNATION
; ═══════════════════════════════════════════════════════════════════════════════
; Attorney-client privilege and work product designations

{@legal_privilege}
; Required fields first
privilege_type = !(attorney_client, common_interest, joint_defense, none, work_product, work_product_opinion)

; Privilege details
designation_date = date                           ; Date of designation
designated_by = :                                 ; Person who designated
basis = :                                         ; Basis for privilege claim

; Waiver
waived = ?                                        ; Privilege waived
waiver_date = date:if waived = true               ; Date of waiver
waiver_scope = ::if waived = true                 ; Scope of waiver

; ═══════════════════════════════════════════════════════════════════════════════
; DOCUMENT TYPE (LEGAL)
; ═══════════════════════════════════════════════════════════════════════════════
; Legal document classification

{@legal_document_type}
; Required fields first
category = !(closing, contract, correspondence, court_filing, discovery, internal, pleading, research, transactional)

; Specific type
document_type = :                                 ; Specific document type
description = :                                   ; Document description

; Court filing specific
filing_type = (answer, brief, complaint, motion, notice, order, petition, response, subpoena):if category = court_filing | category = pleading

; ═══════════════════════════════════════════════════════════════════════════════
; RETAINER
; ═══════════════════════════════════════════════════════════════════════════════
; Client retainer/engagement terms

{@legal_retainer}
; Required fields first
retainer_type = !(evergreen, flat_fee, hourly, hybrid, non_refundable, refundable)
effective_date = !date                            ; Engagement start date

; Retainer identification
retainer_id = :                                   ; Unique retainer identifier

; Financial terms
{.terms}
initial_amount = #$:(0..)                         ; Initial retainer amount
minimum_balance = #$:(0..)                        ; Minimum balance to maintain
replenishment_amount = #$:(0..):if retainer_type = evergreen
replenishment_trigger = #$:(0..):if retainer_type = evergreen
flat_fee_amount = #$:(0..):if retainer_type = flat_fee | retainer_type = hybrid
flat_fee_scope = ::if retainer_type = flat_fee | retainer_type = hybrid

{@legal_retainer}

; Billing terms
{.billing}
billing_frequency = (biweekly, monthly, on_completion, quarterly, upon_request)
payment_terms = ##:(0..)                          ; Days for payment
interest_rate = #:(0..100)                        ; Interest on overdue (annual %)
billing_address = @address                        ; Invoice address

{@legal_retainer}

; Scope of engagement
{.scope}
matter_description = :                            ; Description of matter
scope_of_work = :                                 ; Scope of representation
limitations = :                                   ; Scope limitations
exclusions = :                                    ; Excluded services

{@legal_retainer}

; Status
status = (active, closed, suspended, terminated)
termination_date = date:if status = terminated    ; Date terminated
termination_reason = ::if status = terminated     ; Reason for termination

; ═══════════════════════════════════════════════════════════════════════════════
; PROPERTY REFERENCE (BRIDGE TO REAL ESTATE)
; ═══════════════════════════════════════════════════════════════════════════════
; Reference to real estate property for property-related legal matters

{@legal_property_ref}
; Property identification
property_address = @address                       ; Property address
legal_description = @re_legal_description         ; Full legal description
parcel = @re_parcel_identifiers                   ; Parcel identifiers

; Related matters
foreclosure_matter = ?                            ; Related to foreclosure
title_matter = ?                                  ; Related to title issue
zoning_matter = ?                                 ; Related to zoning
easement_matter = ?                               ; Related to easement

; Bridge references
title_commitment_ref = :                          ; Title commitment reference
title_policy_ref = :                              ; Title policy reference
mortgage_ref = :                                  ; Mortgage/loan reference

; ═══════════════════════════════════════════════════════════════════════════════
; INSURANCE REFERENCE (BRIDGE TO TITLE/LIABILITY)
; ═══════════════════════════════════════════════════════════════════════════════
; Reference to insurance policies for coverage matters

{@legal_insurance_ref}
; Policy identification
policy_number = :                                 ; Insurance policy number
policy_type = (e_and_o, general_liability, malpractice, title)
carrier_name = :                                  ; Insurance carrier
carrier_claim_number = :                          ; Carrier's claim number

; Coverage
coverage_amount = #$:(0..)                        ; Policy coverage limit
deductible = #$:(0..)                             ; Policy deductible
coverage_period_start = date                      ; Coverage start date
coverage_period_end = date                        ; Coverage end date

; Claim status (if claim filed)
claim_filed = ?                                   ; Claim has been filed
claim_date = date:if claim_filed = true           ; Date claim filed
claim_status = (closed, denied, open, paid, pending):if claim_filed = true

; ═══════════════════════════════════════════════════════════════════════════════
; STATUS CODES
; ═══════════════════════════════════════════════════════════════════════════════
; Common status enumerations for legal practice

{@legal_matter_status}
= @status_record                                  ; Inherits status tracking fields

; Override with legal-specific status values
status = !(active, closed, consultation, on_hold, pending, pre_litigation, referred)

; Closure details (if closed)
{.closure}
close_date = date:if status = closed              ; Date closed
close_reason = (adverse_judgment, client_request, completed, dismissed, fee_dispute, non_payment, settled, transferred, won):if status = closed
final_disposition = ::if status = closed          ; Final outcome description

{@legal_matter_status}


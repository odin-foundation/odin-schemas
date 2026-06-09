; ===================================================================================
; ODIN Common Types
; ===================================================================================
; Universal type definitions shared across all domain schemas. These are the
; canonical definitions for common structures like address, phone, email, and more.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.common.types"
version = "1.0.0"
title = "Common Types"
description = "Universal type definitions for all ODIN schemas"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial common types schema"

changelog[1].date = 2025-12-20
changelog[1].change = "Added shared types: @coverage_limit, @status_record, @license_credential, @rating_classification, @contact_preference, @loss_occurrence, @premium_detail, @underwriting_decision, @sublimit, @enrollment_period"

; ===================================================================================
; ADDRESS
; ===================================================================================
; Universal address for US and Canada. Uses state_province for both US states
; and Canadian provinces. Uses postal_code for ZIP and Canadian postal codes.

{@address}
; Required fields first
line1 = :                                       ; Primary street address
city = :                                        ; City or municipality name
state_province = :(2)                           ; US state or CA province code (ISO 3166-2)
postal_code = :                                 ; ZIP/ZIP+4 (US) or postal code (CA)

; Optional fields
country = :(2..3) "US"                           ; ISO 3166 country code
county = :                                       ; County (US) or regional district (CA)
line2 = :                                        ; Secondary address line
unit = :                                         ; Apartment, suite, or unit number

; Parsed Components
street_direction = :                             ; N, S, E, W, NE, NW, SE, SW
street_name = :                                  ; Street name without number
street_number = :                                ; Street number
street_type = :                                  ; St, Ave, Blvd, Rue, Dr, etc.

; Geolocation
latitude = #:(-90..90)                           ; GPS latitude coordinate
longitude = #:(-180..180)                        ; GPS longitude coordinate

; Classification
type = (billing, both, garaging, mailing, physical)  ; Address purpose

; ===================================================================================
; PHONE
; ===================================================================================
; Universal phone type used throughout all schemas. Mark as confidential when
; used for contact information (TCPA/GDPR compliance).

{@phone}
; Required fields first
number = :format phone                          ; Phone number (format validated)
type = (cell, fax, home, main, other, work)     ; Phone line type

; Optional fields
extension = :                                    ; Extension for business lines
primary = ?                                      ; Primary contact number flag

; ===================================================================================
; EMAIL
; ===================================================================================
; Universal email type. Mark as confidential when used for contact information.

{@email}
; Required fields first
address = :format email                         ; Email address (format validated)
type = (other, personal, work)                  ; Email account type

; Optional fields
primary = ?                                      ; Primary email flag

; ===================================================================================
; MONEY
; ===================================================================================
; Currency amounts. Application layer handles precision and limits.

{@money}
; Required fields first
amount = #$                                     ; Currency amount

; Optional fields
currency = :(3) "USD"                            ; ISO 4217 currency code

; ===================================================================================
; PERSON NAME
; ===================================================================================
; Standard name components for individuals.

{@person_name}
; Required fields first
first = :                                       ; First/given name
last = :                                        ; Last/family name

; Optional fields
full = :computed                                 ; Full name (derived from first + last)
middle = :                                       ; Middle name or initial
prefix = :                                       ; Mr, Mrs, Ms, Dr, etc.
suffix = :                                       ; Jr, Sr, II, III, etc.

; ===================================================================================
; PERSON IDENTIFIERS
; ===================================================================================
; Government and legal identification numbers. All confidential (PII).

{@person_identifiers}
; US identifiers
ssn = *:format ssn                               ; Social Security Number (XXX-XX-XXXX)

; Canadian identifiers
sin = *:/^\d{3}-\d{3}-\d{3}$/                    ; Social Insurance Number (XXX-XXX-XXX)
provincial_health_card = *:                      ; Provincial health card number
provincial_health_province = :(2)                ; Province issuing health card

; Shared identifiers - arrays for multiple licenses/passports
drivers_licenses[] = {@drivers_license}          ; Driver licenses (multiple jurisdictions)
passports[] = {@passport}                        ; Passports (dual/multi-citizenship)
tax_id = *:                                      ; EIN (US), BN (CA), or SSN/SIN

{@drivers_license}
number = *:                                     ; Driver license number (confidential)
state_province = :(2)                           ; US state or CA province of issuance
issued = date                                    ; Issue date
expiration = date                                ; Expiration date
class = :                                        ; License class (A, B, C, CDL, etc.)

{@person_identifiers}

{@passport}
number = *:                                     ; Passport number (confidential)
country = :(2..3)                               ; Country of passport issuance
issued = date                                    ; Issue date
expiration = date                                ; Expiration date

{@person_identifiers}

; ===================================================================================
; DEMOGRAPHICS
; ===================================================================================
; Personal demographic information. DOB is confidential (PII).

{@demographics}
; Required fields first
date_of_birth = *date                           ; Birth date (confidential PII)

; Optional fields
gender = (female, male, non_binary)
marital_status = (common_law, divorced, domestic_partner, married, single, widowed)

; ===================================================================================
; DATE RANGE
; ===================================================================================
; Generic date range.

{@date_range}
; Required fields first
start = date:immutable                          ; Range start date (immutable once set)
end = date:immutable                            ; Range end date (immutable once set)

:invariant end >= start                          ; End must be after start

; ===================================================================================
; EFFECTIVE PERIOD
; ===================================================================================
; Policy or coverage term dates.

{@effective_period}
; Required fields first
effective = date                                ; Coverage start date
expiration = date                               ; Coverage end date

; Optional fields
effective_time = time                            ; Start time if not midnight
expiration_time = time                           ; End time if not midnight

:invariant expiration >= effective               ; End must be after start

; ===================================================================================
; IDENTIFIER
; ===================================================================================
; Generic identifier with source tracking.

{@identifier}
; Required fields first
type = :                                        ; Identifier type name
value = :                                       ; Identifier value

; Optional fields
expiration = date                                ; Expiration date if applicable
issued = date                                    ; Issue date
issuer = :                                       ; Issuing authority

; ===================================================================================
; REFERENCE ID
; ===================================================================================
; Cross-system reference identifier.

{@reference_id}
; Required fields first
id = :                                          ; Reference identifier value

; Optional fields
system = :                                       ; Source system name
type = :                                         ; Reference type classification

; ===================================================================================
; TIMESTAMPS
; ===================================================================================
; Record audit timestamps.

{@timestamps}
; Required fields first
created = timestamp                             ; Record creation timestamp

; Optional fields
modified = timestamp                             ; Last modification timestamp

; ===================================================================================
; AUDIT INFO
; ===================================================================================
; Detailed audit trail with user attribution.

{@audit_info}
; Required fields first
created = timestamp                             ; Record creation timestamp

; Optional fields
created_by = :                                   ; User who created record
modified = timestamp                             ; Last modification timestamp
modified_by = :                                  ; User who last modified
version = ##:(1..)                               ; Record version number

; ===================================================================================
; CONTACT
; ===================================================================================
; Generic contact information.

{@contact}
; Optional fields - at least one should be provided
addresses[] = @address                           ; Physical addresses (multiple)
emails[] = *@email                               ; Email addresses (multiple)
phones[] = *@phone                               ; Phone numbers (multiple)

; ===================================================================================
; DOCUMENT REFERENCE
; ===================================================================================
; Reference to an external document.

{@document_reference}
; Required fields first
document_id = :                                 ; Document identifier

; Optional fields
document_type = :                                ; Type/category of document
filename = :                                     ; Original filename
mime_type = :                                    ; MIME content type
url = :format url                                ; Document URL or path
hash = :                                         ; Content hash for integrity
created = timestamp                              ; Document creation time
description = :                                  ; Document description

; ===================================================================================
; COVERAGE LIMIT
; ===================================================================================
; Shared limit structure for insurance coverages.

{@coverage_limit}
; Required fields first
amount = #$:(0..)                               ; Limit amount

; Optional fields
type = (aggregate, combined_single, occurrence, per_accident, per_claim, per_person, split)
basis = (annual, lifetime, per_occurrence, per_policy)
applies_to = :                                   ; What the limit applies to
description = :                                  ; Limit description

; ===================================================================================
; DEDUCTIBLE
; ===================================================================================
; Shared deductible structure for insurance coverages.

{@deductible}
; Required fields first
amount = #$:(0..)                               ; Deductible amount

; Optional fields
type = (aggregate, disappearing, flat, percentage, split, straight)
basis = (annual, per_claim, per_occurrence, per_policy)
applies_to = :                                   ; What the deductible applies to
waived = ?                                       ; Deductible waived
waiver_reason = :                                ; Reason for waiver

; ===================================================================================
; PREMIUM DETAIL
; ===================================================================================
; Shared premium structure for insurance coverages.

{@premium_detail}
; Required fields first
amount = #$:(0..)                               ; Premium amount

; Optional fields
basis = (annual, monthly, quarterly, semi_annual)
minimum = #$:(0..)                               ; Minimum premium
deposit = #$:(0..)                               ; Deposit premium
factor = #                                       ; Rating factor
fully_earned = ?                                 ; Fully earned at inception

; ===================================================================================
; SUBLIMIT
; ===================================================================================
; Sublimit that may erode parent limit.

{@sublimit}
; Required fields first
amount = #$:(0..)                               ; Sublimit amount

; Optional fields
applies_to = :                                   ; What sublimit covers
erodes_aggregate = ?                             ; Erodes aggregate limit
erodes_occurrence = ?                            ; Erodes occurrence limit
remaining = #$:(0..)                             ; Remaining sublimit amount

; ===================================================================================
; STATUS RECORD
; ===================================================================================
; Shared status tracking with date and reason.

{@status_record}
; Required fields first
status = :                                      ; Status value (domain-specific enum)

; Optional fields
status_date = date                               ; Date of status change
effective_date = date                            ; When status takes effect
reason = :                                       ; Reason for status
reason_code = :                                  ; Standardized reason code
changed_by = :                                   ; Who changed the status

; ===================================================================================
; LICENSE / CREDENTIAL
; ===================================================================================
; Professional license or credential.

{@license_credential}
; Required fields first
number = *:                                     ; License/credential number (confidential)

; Optional fields
type = :                                         ; License type
state_province = :(2)                            ; Issuing jurisdiction
country = :(2..3)                                ; Country of issuance
issued = date                                    ; Issue date
expiration = date                                ; Expiration date
status = (active, expired, inactive, probation, revoked, suspended)
issuing_authority = :                            ; Issuing organization

; ===================================================================================
; RATING CLASSIFICATION
; ===================================================================================
; Rating class and factor information.

{@rating_classification}
; Required fields first
class_code = :                                  ; Classification code

; Optional fields
class_description = :                            ; Class description
tier = :                                         ; Rating tier
exposure = #:(0..)                               ; Exposure amount
exposure_basis = :                               ; Basis for exposure (payroll, sales, area, etc.)
base_rate = #                                    ; Base rate
factor = #                                       ; Rating factor/multiplier
schedule_mod = #                                 ; Schedule modification

; ===================================================================================
; CONTACT PREFERENCE
; ===================================================================================
; Contact method preferences and consent.

{@contact_preference}
; Optional fields
preferred_method = (email, mail, phone, sms)     ; Preferred contact method
phone_consent = ?                                ; Consent to call
sms_consent = ?                                  ; Consent to text
email_consent = ?                                ; Consent to email
mail_consent = ?                                 ; Consent to mail
do_not_contact = ?                               ; Do not contact flag
do_not_solicit = ?                               ; Do not solicit flag
best_time_to_call = :                            ; Best time to contact

; ===================================================================================
; LOSS OCCURRENCE
; ===================================================================================
; Core loss/claim occurrence information.

{@loss_occurrence}
; Required fields first
date = date                                     ; Date of loss

; Optional fields
reported_date = date                             ; Date loss was reported
description = :                                  ; Description of loss
type = :                                         ; Loss type (domain-specific)
cause = :                                        ; Cause of loss
location = @address                              ; Location of loss
reported_by = :                                  ; Who reported the loss
reported_method = (agent, email, online, phone)  ; How loss was reported

; ===================================================================================
; UNDERWRITING DECISION
; ===================================================================================
; Underwriting decision with risk assessment.

{@underwriting_decision}
; Required fields first
status = (accepted, declined, pending, referred, withdrawn)

; Optional fields
decision_date = date                             ; Date of decision
decision_by = :                                  ; Who made decision
risk_score = ##                                  ; Numeric risk score
risk_tier = :                                    ; Risk tier classification
reason = :                                       ; Decision reason
reason_codes[] = :                               ; Standardized reason codes
conditions[] = :                                 ; Conditions for acceptance
referral_reason = :                              ; Why referred to underwriter

; ===================================================================================
; ENROLLMENT PERIOD
; ===================================================================================
; Enrollment or coverage period with status.

{@enrollment_period}
; Required fields first
effective = date                                ; Period start date
expiration = date                               ; Period end date

; Optional fields
status = (active, cancelled, expired, pending, terminated)
status_date = date                               ; Date of status change
termination_reason = :                           ; Reason for termination
termination_code = :                             ; Standardized termination code

:invariant expiration >= effective               ; End must be after start

; ===================================================================================
; TERRITORY
; ===================================================================================
; Geographic territory for rating and coverage.

{@territory}
; Required fields first
code = :                                        ; Territory code

; Optional fields
description = :                                  ; Territory description
state_province = :(2)                            ; State/province
county = :                                       ; County name
zip_codes[] = :                                  ; ZIP codes in territory
protection_class = ##:(1..10)                    ; Fire protection class

; ===================================================================================
; PAYMENT
; ===================================================================================
; Payment information.

{@payment}
; Required fields first
amount = #$:(0..)                               ; Payment amount

; Optional fields
date = date                                      ; Payment date
due_date = date                                  ; Due date
method = (ach, check, credit_card, eft, wire)    ; Payment method
status = (applied, failed, pending, refunded, voided)
reference = :                                    ; Payment reference number
confirmation = :                                 ; Confirmation number

; ===================================================================================
; BASE ACCOUNT
; ===================================================================================
; Common account pattern for utilities, telecom, and other service accounts.

{@base_account}
; Required fields first
account_id = :                                  ; Unique account identifier
account_number = *:                             ; Account number (confidential)

; Optional fields
account_name = :                                 ; Account name
account_type = :                                 ; Account type/classification
status = (active, closed, inactive, pending, suspended)
status_date = date                               ; Date of last status change
opened_date = date                               ; Account opening date
closed_date = date                               ; Account closing date

; Contacts - accounts typically have multiple contacts/phones/emails
contacts[] = {@account_contact}                  ; Account contacts (multiple)
billing_address = @address                       ; Billing address
service_address = @address                       ; Service address

{@account_contact}
name = @person_name                              ; Contact name
role = :                                         ; Contact role (primary, billing, technical)
phones[] = *@phone                               ; Phone numbers
emails[] = *@email                               ; Email addresses
primary = ?                                      ; Primary contact flag

{@base_account}

; ===================================================================================
; BASE EQUIPMENT
; ===================================================================================
; Common equipment pattern for manufacturing, agriculture, fleet, and facilities.

{@base_equipment}
= @audit_info

; Required fields first
equipment_id = :                                ; Unique equipment identifier

; Optional identification
equipment_name = :                               ; Equipment name/description
equipment_type = :                               ; Equipment type/category
serial_numbers[] = {@equipment_serial}           ; Serial numbers (multiple: manufacturer, asset tag, fleet)

{@equipment_serial}
number = *:                                     ; Serial/ID number (confidential)
type = (asset_tag, fleet_number, manufacturer, registration, vin)  ; Type of identifier

{@base_equipment}

; Manufacturer details
manufacturer = :                                 ; Manufacturer name
model = :                                        ; Model number/name
model_year = ##:(1900..2100)                     ; Model year

; Ownership
acquisition_date = date                          ; Purchase/acquisition date
acquisition_cost = #$:(0..)                      ; Purchase price
estimated_value = #$:(0..)                       ; Current estimated value

; Status
status = (active, decommissioned, maintenance, offline, retired, sold)
status_date = date                               ; Status change date
location = :                                     ; Current location

; Maintenance
last_maintenance = date                          ; Last maintenance date
next_maintenance = date                          ; Next scheduled maintenance

; ===================================================================================
; BASE MAINTENANCE RECORD
; ===================================================================================
; Common maintenance record pattern for equipment, vehicles, facilities.

{@base_maintenance}
; Required fields first
maintenance_id = :                              ; Unique maintenance record ID
equipment_ref = :                               ; Reference to equipment

; Maintenance details
maintenance_type = (breakdown, calibration, inspection, overhaul, preventive, repair)
scheduled_date = date                            ; Scheduled date
performed_date = date                            ; Date performed
performed_by = :                                 ; Technician/performer

; Work details
description = :                                  ; Work description
findings = :                                     ; Inspection findings
actions_taken = :                                ; Actions taken
parts_used[] = :                                 ; Parts used

; Cost
labor_hours = #:(0..)                            ; Labor hours
labor_cost = #$:(0..)                            ; Labor cost
parts_cost = #$:(0..)                            ; Parts cost
total_cost = #$:(0..)                            ; Total maintenance cost

; Next service
next_due = date                                  ; Next maintenance due

; ===================================================================================
; BASE LOT
; ===================================================================================
; Common lot/batch tracking pattern for manufacturing, agriculture, inventory.

{@base_lot}
; Required fields first
lot_id = :                                      ; Unique lot/batch identifier
lot_number = :                                  ; Lot/batch number

; Optional fields
product_ref = :                                  ; Product reference
quantity = #:(0..)                               ; Quantity in lot
quantity_unit = :                                ; Unit of measure

; Dates
production_date = date                           ; Production/creation date
expiration_date = date                           ; Expiration date
received_date = date                             ; Date received

; Origin
source = :                                       ; Source/origin
supplier_ref = :                                 ; Supplier reference
supplier_lot = :                                 ; Supplier's lot number

; Status
status = (available, consumed, expired, hold, quarantine, released)
status_date = date                               ; Status change date
hold_reason = :                                  ; Reason for hold/quarantine

; ===================================================================================
; BASE OUTAGE
; ===================================================================================
; Common service outage pattern for utilities, telecom, network services.

{@base_outage}
; Required fields first
outage_id = :                                   ; Unique outage identifier
start_time = timestamp                          ; Outage start time

; Optional fields
end_time = timestamp                             ; Outage end time (null if ongoing)
duration_minutes = ##:(0..)                      ; Duration in minutes

; Classification
outage_type = (emergency, planned, unplanned)
cause = :                                        ; Cause of outage
cause_category = :                               ; Cause category/classification

; Impact
affected_area = :                                ; Affected area description
affected_count = ##:(0..)                        ; Number of customers/users affected
severity = (critical, major, minor)

; Status
status = (active, cancelled, completed, investigating, resolved, scheduled)
status_time = timestamp                          ; Status update time

; Resolution
resolution = :                                   ; Resolution description
restored_time = timestamp                        ; Service restoration time

; ===================================================================================
; BASE WORK ORDER
; ===================================================================================
; Common work order pattern for service, manufacturing, maintenance.

{@base_work_order}
; Required fields first
work_order_id = :                               ; Unique work order identifier
work_order_number = :                           ; Work order number

; Optional fields
work_order_type = :                              ; Type of work order
priority = (critical, high, low, medium, urgent)
status = (assigned, cancelled, completed, in_progress, on_hold, open, scheduled)
status_date = date                               ; Status change date

; Dates
created_date = date                              ; Creation date
scheduled_date = date                            ; Scheduled date
due_date = date                                  ; Due date
completed_date = date                            ; Completion date

; Assignment - work orders often assigned to multiple people/teams
assignees[] = {@work_assignment}                 ; Assigned technicians/teams (multiple)
requested_by = :                                 ; Requester

; Work details
description = :                                  ; Work description
instructions[] = :                               ; Work instructions (multiple steps)
notes[] = {@work_note}                           ; Notes/comments (multiple)

{@work_assignment}
assigned_to = :                                 ; Technician/team name or ID
role = :                                         ; Assignment role (primary, secondary, specialist)
assigned_date = date                             ; Date of assignment

{@base_work_order}

{@work_note}
note = :                                        ; Note content
author = :                                       ; Note author
timestamp = timestamp                            ; When note was added

{@base_work_order}

; Location
location = @address                              ; Work location

; Cost
estimated_hours = #:(0..)                        ; Estimated hours
actual_hours = #:(0..)                           ; Actual hours
estimated_cost = #$:(0..)                        ; Estimated cost
actual_cost = #$:(0..)                           ; Actual cost

; ===================================================================================
; BASE PRODUCT
; ===================================================================================
; Common product pattern for manufacturing, retail, inventory.

{@base_product}
; Required fields first
product_id = :                                  ; Unique product identifier

; Identification
sku = :                                          ; Stock keeping unit
upc = :                                          ; Universal product code
gtin = :                                         ; Global trade item number
manufacturer_part_number = :                     ; Manufacturer part number

; Description
product_name = :                                 ; Product name
description = :                                  ; Product description
short_description = :                            ; Short description
brands[] = :                                     ; Brand names (co-branding, store brands, licensed)
manufacturer = :                                 ; Manufacturer name

; Classification - products often belong to multiple categories
categories[] = {@product_category}               ; Product categories (multiple)
product_type = :                                 ; Product type

{@product_category}
category = :                                    ; Category name
subcategory = :                                  ; Subcategory name
primary = ?                                      ; Primary category flag

{@base_product}

; Status
status = (active, discontinued, draft, inactive)
status_date = date                               ; Status change date

; Dimensions
weight = #:(0..)                                 ; Weight
weight_unit = (g, kg, lb, oz)                    ; Weight unit
length = #:(0..)                                 ; Length
width = #:(0..)                                  ; Width
height = #:(0..)                                 ; Height
dimension_unit = (cm, in, m)                     ; Dimension unit

; ===================================================================================
; BASE COURSE
; ===================================================================================
; Common course/training pattern for education, employment learning.

{@base_course}
; Required fields first
course_id = :                                   ; Unique course identifier
course_code = :                                 ; Course code

; Description
course_name = :                                  ; Course name/title
description = :                                  ; Course description

; Classification
course_type = :                                  ; Type of course
category = :                                     ; Course category
level = :                                        ; Course level (beginner, intermediate, advanced)

; Duration
duration_hours = #:(0..)                         ; Duration in hours
credit_hours = #:(0..)                           ; Credit hours

; Delivery
delivery_method = (blended, in_person, online, self_paced)
format = :                                       ; Course format

; Status
status = (active, archived, draft, inactive)
start_date = date                                ; Course start date
end_date = date                                  ; Course end date

; Requirements
prerequisites[] = :                              ; Prerequisite course IDs
required = ?                                     ; Mandatory course


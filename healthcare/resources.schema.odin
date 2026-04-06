; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Healthcare Resources Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Core healthcare resources including Patient, Practitioner, Organization,
; Location, and Encounter. Derived from HL7 FHIR R4 (CC0 public domain).
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as fhir

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.resources"
version = "1.0.0"
title = "Healthcare Resources Schema"
description = "Core healthcare resources derived from FHIR"

{$derivation}
source[0].authority = "HL7"
source[0].citation = "HL7 FHIR R4 - Patient Resource"
source[0].url = "https://hl7.org/fhir/R4/patient.html"

source[1].authority = "HL7"
source[1].citation = "HL7 FHIR R4 - Practitioner Resource"
source[1].url = "https://hl7.org/fhir/R4/practitioner.html"

source[2].authority = "HL7"
source[2].citation = "HL7 FHIR R4 - Organization Resource"
source[2].url = "https://hl7.org/fhir/R4/organization.html"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial healthcare resources schema"
changelog[0].rationale = "Core resources derived from FHIR R4"

; ═══════════════════════════════════════════════════════════════════════════════
; PATIENT
; ═══════════════════════════════════════════════════════════════════════════════
; FHIR: Patient - https://hl7.org/fhir/R4/patient.html

{@patient}
; Resource metadata
id = !:                                       ; Logical id of resource
meta = @fhir.meta                             ; Resource metadata

; Identifiers
identifiers[] = @fhir.identifier              ; Patient identifiers (MRN, SSN, etc.)

; Status
active = ?                                    ; Whether record is active

; Name
names[] = @fhir.human_name                    ; Patient name(s)

; Contact
telecoms[] = *@fhir.contact_point             ; Contact details (confidential)

; Demographics
gender = (female, male, other, unknown)       ; Administrative gender
birth_date = *date                            ; Date of birth (confidential)
deceased = ?                                  ; Indicates if patient deceased
deceased_date = date                          ; Date of death if deceased

; Address
addresses[] = @fhir.address                   ; Patient addresses

; Marital status
marital_status = @fhir.codeable_concept       ; Marital status

; Multiple birth
multiple_birth = ?                            ; Part of multiple birth
multiple_birth_integer = ##:(1..)             ; Birth order

; Photo
photos[] = @fhir.attachment                   ; Image of patient

; Contacts (emergency, next of kin)
contacts[] = @patient_contact                 ; Contact persons

; Communication
communications[] = @patient_communication     ; Language preferences

; General practitioner
general_practitioners[] = @fhir.reference     ; Patient's primary care providers

; Managing organization
managing_organization = @fhir.reference       ; Organization managing record

; Links to other patient records
links[] = @patient_link                       ; Links to other patient records

{@patient_contact}
relationship[] = @fhir.codeable_concept       ; Relationship to patient
name = @fhir.human_name                       ; Contact person name
telecoms[] = *@fhir.contact_point             ; Contact details
address = @fhir.address                       ; Contact address
gender = (female, male, other, unknown)       ; Contact gender
organization = @fhir.reference                ; Organization (if applicable)
period = @fhir.period                         ; Period contact is valid

{@patient_communication}
language = !@fhir.codeable_concept            ; Language code (BCP-47)
preferred = ?                                 ; Is preferred language

{@patient_link}
other = !@fhir.reference                      ; Other patient record
type = !(refer, replaced_by, replaces, seealso)

; ═══════════════════════════════════════════════════════════════════════════════
; PRACTITIONER
; ═══════════════════════════════════════════════════════════════════════════════
; FHIR: Practitioner - https://hl7.org/fhir/R4/practitioner.html

{@practitioner}
; Resource metadata
id = !:                                       ; Logical id of resource
meta = @fhir.meta                             ; Resource metadata

; Identifiers
identifiers[] = @fhir.identifier              ; NPI, DEA, state license, etc.

; Status
active = ?                                    ; Whether record is active

; Name
names[] = @fhir.human_name                    ; Practitioner name(s)

; Contact
telecoms[] = @fhir.contact_point              ; Contact details
addresses[] = @fhir.address                   ; Addresses

; Demographics
gender = (female, male, other, unknown)       ; Administrative gender
birth_date = date                             ; Date of birth

; Photo
photos[] = @fhir.attachment                   ; Image of practitioner

; Qualifications
qualifications[] = @practitioner_qualification ; Certifications, licenses

; Communications
communications[] = @fhir.codeable_concept     ; Languages spoken

{@practitioner_qualification}
identifiers[] = @fhir.identifier              ; Qualification identifier
code = !@fhir.codeable_concept                ; Coded representation
period = @fhir.period                         ; Period qualification is valid
issuer = @fhir.reference                      ; Organization issuing qualification

; ═══════════════════════════════════════════════════════════════════════════════
; ORGANIZATION
; ═══════════════════════════════════════════════════════════════════════════════
; FHIR: Organization - https://hl7.org/fhir/R4/organization.html

{@organization}
; Resource metadata
id = !:                                       ; Logical id of resource
meta = @fhir.meta                             ; Resource metadata

; Identifiers
identifiers[] = @fhir.identifier              ; NPI, Tax ID, etc.

; Status
active = ?                                    ; Whether organization is active

; Type
types[] = @fhir.codeable_concept              ; Kind of organization

; Name
name = :                                      ; Organization name
aliases[] = :                                 ; Other names (DBA, etc.)

; Contact
telecoms[] = @fhir.contact_point              ; Contact details
addresses[] = @fhir.address                   ; Organization addresses

; Parent organization
part_of = @fhir.reference                     ; Parent organization

; Contacts
contacts[] = @organization_contact            ; Contact persons

; Endpoints
endpoints[] = @fhir.reference                 ; Technical endpoints

{@organization_contact}
purpose = @fhir.codeable_concept              ; Type of contact
name = @fhir.human_name                       ; Contact name
telecoms[] = @fhir.contact_point              ; Contact details
address = @fhir.address                       ; Contact address

; ═══════════════════════════════════════════════════════════════════════════════
; LOCATION
; ═══════════════════════════════════════════════════════════════════════════════
; FHIR: Location - https://hl7.org/fhir/R4/location.html

{@location}
; Resource metadata
id = !:                                       ; Logical id of resource
meta = @fhir.meta                             ; Resource metadata

; Identifiers
identifiers[] = @fhir.identifier              ; Location identifiers

; Status
status = (active, inactive, suspended)        ; Location status

; Operational status
operational_status = @fhir.coding             ; Operational status (bed/room)

; Name and description
name = :                                      ; Location name
aliases[] = :                                 ; Other names
description = :                               ; Additional description

; Mode
mode = (instance, kind)                       ; instance = specific, kind = class

; Types
types[] = @fhir.codeable_concept              ; Type of location

; Contact
telecoms[] = @fhir.contact_point              ; Contact details
address = @fhir.address                       ; Physical address

; Physical type
physical_type = @fhir.codeable_concept        ; Physical form (room, bed, etc.)

; Position
{.position}
longitude = !#:(-180..180)                    ; Longitude
latitude = !#:(-90..90)                       ; Latitude
altitude = #                                  ; Altitude

{@location}

; Managing organization
managing_organization = @fhir.reference       ; Organization managing location

; Part of
part_of = @fhir.reference                     ; Another location this is part of

; Hours of operation
hours_of_operation[] = @location_hours        ; Operating hours

; Availability exceptions
availability_exceptions = :                   ; Holidays, closures, etc.

; Endpoints
endpoints[] = @fhir.reference                 ; Technical endpoints

{@location_hours}
days_of_week[] = (fri, mon, sat, sun, thu, tue, wed)
all_day = ?                                   ; Open all day
opening_time = time                           ; Opening time
closing_time = time                           ; Closing time

; ═══════════════════════════════════════════════════════════════════════════════
; ENCOUNTER
; ═══════════════════════════════════════════════════════════════════════════════
; FHIR: Encounter - https://hl7.org/fhir/R4/encounter.html

{@encounter}
; Resource metadata
id = !:                                       ; Logical id of resource
meta = @fhir.meta                             ; Resource metadata

; Identifiers
identifiers[] = @fhir.identifier              ; Encounter identifiers

; Status
status = !(arrived, cancelled, entered_in_error, finished, in_progress, onleave, planned, triaged, unknown)

; Status history
status_history[] = @encounter_status_history  ; Past status changes

; Class
class = !@fhir.coding                         ; Classification (inpatient, outpatient, etc.)

; Class history
class_history[] = @encounter_class_history    ; Past class changes

; Types
types[] = @fhir.codeable_concept              ; Specific type of encounter

; Service type
service_type = @fhir.codeable_concept         ; Specific service provided

; Priority
priority = @fhir.codeable_concept             ; Encounter priority (emergency, elective)

; Subject
subject = @fhir.reference                     ; Patient for encounter

; Episode of care
episode_of_care[] = @fhir.reference           ; Episode(s) this is part of

; Based on
based_on[] = @fhir.reference                  ; Service request that initiated

; Participants
participants[] = @encounter_participant       ; People involved

; Appointment
appointments[] = @fhir.reference              ; Appointment(s) that scheduled

; Period
period = @fhir.period                         ; Start and end time

; Length
length = @fhir.duration                       ; Duration of encounter

; Reason codes
reason_codes[] = @fhir.codeable_concept       ; Coded reason for encounter

; Reason references
reason_references[] = @fhir.reference         ; Reference to condition/procedure

; Diagnoses
diagnoses[] = @encounter_diagnosis            ; Diagnoses for encounter

; Account
accounts[] = @fhir.reference                  ; Billing account(s)

; Hospitalization
hospitalization = @encounter_hospitalization  ; Details about admission

; Locations
locations[] = @encounter_location             ; Locations during encounter

; Service provider
service_provider = @fhir.reference            ; Responsible organization

; Part of
part_of = @fhir.reference                     ; Another encounter this is part of

{@encounter_status_history}
status = !(arrived, cancelled, entered_in_error, finished, in_progress, onleave, planned, triaged, unknown)
period = !@fhir.period                        ; Time period for status

{@encounter_class_history}
class = !@fhir.coding                         ; Encounter class
period = !@fhir.period                        ; Time period for class

{@encounter_participant}
types[] = @fhir.codeable_concept              ; Role of participant
period = @fhir.period                         ; Period of participation
individual = @fhir.reference                  ; Practitioner/RelatedPerson

{@encounter_diagnosis}
condition = !@fhir.reference                  ; Reference to condition
use = @fhir.codeable_concept                  ; Role (admission, billing, etc.)
rank = ##:(1..)                               ; Ranking of diagnosis

{@encounter_hospitalization}
pre_admission_identifier = @fhir.identifier   ; Pre-admission identifier
origin = @fhir.reference                      ; Location from which admitted
admit_source = @fhir.codeable_concept         ; From where patient was admitted
re_admission = @fhir.codeable_concept         ; Readmission indicator
diet_preferences[] = @fhir.codeable_concept   ; Diet preferences
special_courtesies[] = @fhir.codeable_concept ; Special courtesies
special_arrangements[] = @fhir.codeable_concept  ; Special arrangements
destination = @fhir.reference                 ; Location to which discharged
discharge_disposition = @fhir.codeable_concept   ; Discharge category

{@encounter_location}
location = !@fhir.reference                   ; Location
status = (active, completed, planned, reserved)
physical_type = @fhir.codeable_concept        ; Physical form
period = @fhir.period                         ; Time period at location

; ═══════════════════════════════════════════════════════════════════════════════
; CONDITION
; ═══════════════════════════════════════════════════════════════════════════════
; FHIR: Condition - https://hl7.org/fhir/R4/condition.html

{@condition}
; Resource metadata
id = !:                                       ; Logical id of resource
meta = @fhir.meta                             ; Resource metadata

; Identifiers
identifiers[] = @fhir.identifier              ; External identifiers

; Clinical status
clinical_status = @fhir.codeable_concept      ; active | recurrence | relapse | inactive | remission | resolved

; Verification status
verification_status = @fhir.codeable_concept  ; unconfirmed | provisional | differential | confirmed | refuted | entered-in-error

; Category
categories[] = @fhir.codeable_concept         ; problem-list-item | encounter-diagnosis

; Severity
severity = @fhir.codeable_concept             ; Severity of condition

; Code
code = @fhir.codeable_concept                 ; Identification of condition

; Body site
body_sites[] = @fhir.codeable_concept         ; Anatomical location

; Subject
subject = !@fhir.reference                    ; Patient who has condition

; Encounter
encounter = @fhir.reference                   ; Encounter when condition noted

; Onset
onset_date_time = timestamp                   ; When condition started
onset_age = @fhir.age                         ; Age when started
onset_period = @fhir.period                   ; Period when started
onset_range = @fhir.range                     ; Range of time
onset_string = :                              ; Textual onset description

; Abatement
abatement_date_time = timestamp               ; When condition resolved
abatement_age = @fhir.age                     ; Age when resolved
abatement_period = @fhir.period               ; Period when resolved
abatement_range = @fhir.range                 ; Range when resolved
abatement_string = :                          ; Textual abatement

; Recorded date
recorded_date = timestamp                     ; Date record was recorded

; Recorder
recorder = @fhir.reference                    ; Who recorded condition

; Asserter
asserter = @fhir.reference                    ; Person who asserts condition

; Stage
stages[] = @condition_stage                   ; Stage/grade

; Evidence
evidence[] = @condition_evidence              ; Supporting evidence

; Notes
notes[] = @fhir.annotation                    ; Additional information

{@condition_stage}
summary = @fhir.codeable_concept              ; Simple summary (e.g., cancer stage)
assessment[] = @fhir.reference                ; Formal assessments
type = @fhir.codeable_concept                 ; Kind of staging

{@condition_evidence}
codes[] = @fhir.codeable_concept              ; Manifestation/symptom
details[] = @fhir.reference                   ; Supporting information

; ═══════════════════════════════════════════════════════════════════════════════
; OBSERVATION
; ═══════════════════════════════════════════════════════════════════════════════
; FHIR: Observation - https://hl7.org/fhir/R4/observation.html

{@observation}
; Resource metadata
id = !:                                       ; Logical id of resource
meta = @fhir.meta                             ; Resource metadata

; Identifiers
identifiers[] = @fhir.identifier              ; Business identifiers

; Based on
based_on[] = @fhir.reference                  ; Fulfills plan/order

; Part of
part_of[] = @fhir.reference                   ; Part of larger event

; Status
status = !(amended, cancelled, corrected, entered_in_error, final, preliminary, registered, unknown)

; Category
categories[] = @fhir.codeable_concept         ; Classification of observation

; Code
code = !@fhir.codeable_concept                ; Type of observation (LOINC, etc.)

; Subject
subject = @fhir.reference                     ; Patient being observed

; Focus
focus[] = @fhir.reference                     ; What observation is about

; Encounter
encounter = @fhir.reference                   ; Healthcare event context

; Effective time
effective_date_time = timestamp               ; Clinically relevant time
effective_period = @fhir.period               ; Relevant time period
effective_timing = @fhir.timing               ; Relevant timing
effective_instant = timestamp                 ; Precise instant

; Issued
issued = timestamp                            ; Date/time result issued

; Performer
performers[] = @fhir.reference                ; Who performed observation

; Value (polymorphic - only one should be present)
value_quantity = @fhir.quantity               ; Actual result (quantity)
value_codeable_concept = @fhir.codeable_concept  ; Actual result (coded)
value_string = :                              ; Actual result (string)
value_boolean = ?                             ; Actual result (boolean)
value_integer = ##                            ; Actual result (integer)
value_range = @fhir.range                     ; Actual result (range)
value_ratio = @fhir.ratio                     ; Actual result (ratio)
value_time = time                             ; Actual result (time)
value_date_time = timestamp                   ; Actual result (datetime)
value_period = @fhir.period                   ; Actual result (period)

; Data absent reason
data_absent_reason = @fhir.codeable_concept   ; Why result is missing

; Interpretation
interpretation[] = @fhir.codeable_concept     ; High, low, normal, etc.

; Notes
notes[] = @fhir.annotation                    ; Comments about observation

; Body site
body_site = @fhir.codeable_concept            ; Observed body part

; Method
method = @fhir.codeable_concept               ; How observation was made

; Specimen
specimen = @fhir.reference                    ; Specimen used

; Device
device = @fhir.reference                      ; Device used

; Reference range
reference_ranges[] = @observation_reference_range  ; Reference range

; Has member
has_members[] = @fhir.reference               ; Related observations

; Derived from
derived_from[] = @fhir.reference              ; Related measurements

; Components
components[] = @observation_component         ; Component observations

{@observation_reference_range}
low = @fhir.simple_quantity                   ; Low range
high = @fhir.simple_quantity                  ; High range
type = @fhir.codeable_concept                 ; Reference range qualifier
applies_to[] = @fhir.codeable_concept         ; Reference range population
age = @fhir.range                             ; Applicable age range
text = :                                      ; Text description

{@observation_component}
code = !@fhir.codeable_concept                ; Type of component observation
value_quantity = @fhir.quantity               ; Component value
value_codeable_concept = @fhir.codeable_concept
value_string = :
value_boolean = ?
value_integer = ##
value_range = @fhir.range
value_ratio = @fhir.ratio
value_time = time
value_date_time = timestamp
value_period = @fhir.period
data_absent_reason = @fhir.codeable_concept   ; Why result missing
interpretation[] = @fhir.codeable_concept     ; Interpretation
reference_ranges[] = @observation_reference_range


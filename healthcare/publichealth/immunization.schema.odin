; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Immunization Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Immunization records and registry structures covering vaccine administration,
; CVX/MVX codes, dose tracking, and IIS reporting. Derived from CDC
; immunization guidelines and HL7 immunization messaging standards.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.publichealth.immunization"
version = "1.0.0"
title = "Immunization Schema"
description = "Immunization records and registry structures"

{$derivation}
source[0].authority = "CDC"
source[0].citation = "ACIP Immunization Schedule"
source[0].url = "https://www.cdc.gov/vaccines/hcp/imz-schedules/index.html"

source[1].authority = "CDC"
source[1].citation = "Immunization Information System (IIS) Functional Standards"
source[1].url = "https://www.cdc.gov/iis/about/index.html"

source[2].authority = "HL7"
source[2].citation = "HL7 Implementation Guide for Immunization Messaging"
source[2].url = "https://repository.immregistries.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial immunization schema"
changelog[0].rationale = "Structure derived from CDC and HL7 immunization standards"

; ═══════════════════════════════════════════════════════════════════════════════
; IMMUNIZATION RECORD
; ═══════════════════════════════════════════════════════════════════════════════
; Per CDC IIS standards

{@record}
record_id = !:                              ; Record identifier
patient_id = !:                             ; Patient identifier
administration_date = !date                 ; Date administered

; Vaccine
{.vaccine}
cvx_code = !:                               ; CVX code
vaccine_name = :                            ; Vaccine name
mvx_code = :                                ; MVX manufacturer code
manufacturer_name = :                       ; Manufacturer name
lot_number = :                              ; Lot number
expiration_date = date                      ; Vaccine expiration date
ndc = :                                     ; NDC code

{@record}

; Administration
{.administration}
dose_number = ##:(1..10)                    ; Dose number in series
route = (id, im, in, iv, oral, sc, other)   ; Route of administration
site = (la, ll, lu, ra, rl, ru, other)      ; Body site
; la=left arm, ll=left leg, lu=left upper arm, etc.
dose_amount = #:(0..10)                     ; Dose amount
dose_unit = (mcg, mg, ml)                   ; Dose unit

{@record}

; Provider
{.provider}
provider_name = :                           ; Administering provider
provider_npi = :                            ; Provider NPI
provider_suffix = :                         ; Credential (MD, RN, etc.)
facility_name = :                           ; Facility name
facility_id = :                             ; Facility identifier

{@record}

; Funding source - Per VFC requirements
{.funding}
funding_source = (federal_317, military, other, private, state, vfc)
; vfc = Vaccines for Children
; 317 = Section 317 federal program
eligibility_category = :                    ; VFC eligibility if applicable

{@record}

; Information source
{.source}
information_source = (historical, new_record, registry)
historical_source = :                       ; Source if historical
entered_by = :                              ; Data entry person
entry_date = date                           ; Date entered

{@record}

; Status
status = !(administered, historical, refused)

; ═══════════════════════════════════════════════════════════════════════════════
; PATIENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per CDC IIS functional standards

{@patient}
patient_id = !:                             ; Patient identifier (registry assigned)

; Demographics
{.demographics}
first_name = !:                             ; First name
middle_name = :                             ; Middle name
last_name = !:                              ; Last name
dob = !*date                                ; Date of birth
gender = (female, male, other, unknown)     ; Gender
birth_state = :(2)                          ; State of birth
mothers_maiden_name = :                     ; Mother's maiden name

{@patient}

; Identifiers
{.identifiers}
ssn = *:                                    ; SSN
medicaid_id = :                             ; Medicaid ID
mrn = :                                     ; Medical record number
insurance_id = :                            ; Insurance ID

{@patient}

; Address
{.address}
address_1 = :                               ; Street address
address_2 = :                               ; Apt/unit
city = :                                    ; City
state = :(2)                                ; State
zip = :(5..10)                              ; ZIP code
county = :                                  ; County

{@patient}

; Contact
phone = *@phone                             ; Phone number
email = *@email                             ; Email
guardian_name = :                           ; Guardian name (if minor)
guardian_phone = *@phone                    ; Guardian phone

{@patient}

; Status
{.status}
registry_status = (active, inactive)        ; Status in registry
protection_indicator = ?                    ; Protected from disclosure

{@patient}

; ═══════════════════════════════════════════════════════════════════════════════
; VACCINE SERIES
; ═══════════════════════════════════════════════════════════════════════════════
; Per ACIP recommendations

{@series}
series_id = !:                              ; Series identifier
patient_id = !:                             ; Patient
vaccine_group = !:                          ; Vaccine group (e.g., DTaP, MMR)

; Series status
{.status}
series_status = !(complete, in_progress, not_started, overdue)
doses_administered = ##:(0..)               ; Doses given
doses_required = ##:(1..10)                 ; Total doses needed
next_dose_due = date                        ; Next dose due date
series_completion_date = date               ; Date series completed

{@series}

; Evaluation
{.evaluation}
evaluation_date = date                      ; Last evaluation date
valid_doses = ##:(0..)                      ; Valid doses
invalid_doses = ##:(0..)                    ; Invalid doses
forecast_dose_number = ##:(1..10)           ; Forecasted next dose number
forecast_due_date = date                    ; Due date for next dose
forecast_overdue_date = date                ; Overdue date

{@series}

; ═══════════════════════════════════════════════════════════════════════════════
; CONTRAINDICATION/PRECAUTION
; ═══════════════════════════════════════════════════════════════════════════════
; Per ACIP contraindication guidelines

{@contraindication}
contraindication_id = !:                    ; Contraindication ID
patient_id = !:                             ; Patient
documented_date = !date                     ; Date documented

; Vaccine affected
vaccine_group = :                           ; Affected vaccine group
cvx_code = :                                ; Specific CVX if applicable

; Type
{.type}
type = !(contraindication, exemption, precaution)
permanent = ?                               ; Permanent vs temporary
review_date = date                          ; Review date (if temporary)

{@contraindication}

; Reason
{.reason}
reason_code = :                             ; Reason code
reason_text = :                             ; Reason description
; Examples: allergy, immunocompromised, pregnancy, previous reaction

{@contraindication}

; Exemption (if type = exemption)
{.exemption}
exemption_type = (medical, personal, religious)
state_allows = ?                            ; State allows this exemption type
expiration = date                           ; Exemption expiration

{@contraindication}

; Documentation
{.documentation}
documented_by = :                           ; Who documented
provider_npi = :                            ; Provider NPI
facility = :                                ; Facility

{@contraindication}

; ═══════════════════════════════════════════════════════════════════════════════
; ADVERSE EVENT (VAERS REPORT)
; ═══════════════════════════════════════════════════════════════════════════════
; Per VAERS reporting requirements

{@adverse_event}
vaers_id = :                                ; VAERS ID (if submitted)
patient_id = !:                             ; Patient
report_date = !date                         ; Date of report

; Event
{.event}
event_date = !date                          ; Date of adverse event
description = :                             ; Event description
outcome = (death, disability, ed_visit, hospitalization, life_threatening, other, recovered)
hospitalized = ?                            ; Hospitalized
hospital_days = ##:(0..)                    ; Days hospitalized
recovered = ?                               ; Patient recovered

{@adverse_event}

; Vaccines given before event
vaccines[] = @adverse_event_vaccine         ; Vaccines administered

; Symptoms
symptoms[] = :                              ; MedDRA terms or descriptions

; Reporter
{.reporter}
reporter_type = (healthcare_provider, manufacturer, patient, other)
reporter_name = :                           ; Reporter name
reporter_phone = *@phone                    ; Reporter phone

{@adverse_event}

; Submission
{.submission}
submitted_to_vaers = ?                      ; Submitted to VAERS
submission_date = date                      ; Submission date

{@adverse_event}

{@adverse_event_vaccine}
cvx_code = :                                ; CVX code
vaccine_name = :                            ; Vaccine name
lot_number = :                              ; Lot number
manufacturer = :                            ; Manufacturer
administration_date = date                  ; Administration date

; ═══════════════════════════════════════════════════════════════════════════════
; VFC ELIGIBILITY
; ═══════════════════════════════════════════════════════════════════════════════
; Per VFC program requirements

{@vfc_eligibility}
patient_id = !:                             ; Patient
determination_date = !date                  ; Determination date

; Age eligibility
{.age}
under_19 = ?                                ; Under 19 years old

{@vfc_eligibility}

; Eligibility category - Per VFC guidelines
{.category}
eligible = ?                                ; VFC eligible
category = (american_indian_alaska_native, federally_qualified_hc, medicaid, state_medicaid_chip, underinsured, uninsured)
category_code = :                           ; Category code

{@vfc_eligibility}

; Documentation
{.documentation}
screened_by = :                             ; Screener name
screening_location = :                      ; Location

{@vfc_eligibility}

; ═══════════════════════════════════════════════════════════════════════════════
; VACCINE INVENTORY
; ═══════════════════════════════════════════════════════════════════════════════
; Per VFC accountability requirements

{@inventory}
inventory_id = !:                           ; Inventory ID
facility_id = !:                            ; Facility

; Vaccine
{.vaccine}
cvx_code = !:                               ; CVX code
mvx_code = :                                ; Manufacturer code
lot_number = !:                             ; Lot number
expiration_date = !date                     ; Expiration date
ndc = :                                     ; NDC code

{@inventory}

; Quantity
{.quantity}
quantity_received = ##:(0..)                ; Doses received
quantity_on_hand = ##:(0..)                 ; Doses on hand
quantity_administered = ##:(0..)            ; Doses given
quantity_wasted = ##:(0..)                  ; Doses wasted
quantity_expired = ##:(0..)                 ; Doses expired

{@inventory}

; Funding
funding_source = !(federal_317, private, state, vfc)

; Storage
{.storage}
storage_unit = :                            ; Storage unit identifier
temperature_log = ?                         ; Temperature monitored
storage_compliant = ?                       ; Proper storage maintained

{@inventory}


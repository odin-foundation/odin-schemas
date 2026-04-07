; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Reportable Conditions Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Notifiable diseases and conditions reporting structures including case
; reports, classifications, and electronic case reporting (eCR). Derived
; from CDC NNDSS and state reporting requirements.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.publichealth.reportable"
version = "1.0.0"
title = "Reportable Conditions Schema"
description = "Notifiable diseases and conditions reporting"

{$derivation}
source[0].authority = "CDC"
source[0].citation = "National Notifiable Diseases Surveillance System (NNDSS)"
source[0].url = "https://www.cdc.gov/nndss/"

source[1].authority = "CDC"
source[1].citation = "CSTE Position Statements - Nationally Notifiable Conditions"
source[1].url = "https://ndc.services.cdc.gov/"

source[2].authority = "CDC"
source[2].citation = "Electronic Case Reporting (eCR) Implementation Guide"
source[2].url = "https://www.cdc.gov/ecr/php/about/index.html"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial reportable conditions schema"
changelog[0].rationale = "Structure derived from CDC NNDSS and state reporting requirements"

; ═══════════════════════════════════════════════════════════════════════════════
; CASE REPORT
; ═══════════════════════════════════════════════════════════════════════════════
; Per NNDSS case notification requirements

{@case}
case_id = !:                                ; Case identifier
jurisdiction = !:(2)                        ; Reporting jurisdiction (state)
condition_code = !:                         ; Condition code (CDC)
report_date = !date                         ; Report date

; Condition
{.condition}
condition_name = !:                         ; Condition name
snomed_code = :                             ; SNOMED CT code
icd10_code = :                              ; ICD-10 code
disease_category = :                        ; Disease category

{@case}

; Case classification - Per CSTE definitions
{.classification}
case_status = !(confirmed, not_a_case, probable, suspected, unknown)
confirmation_method = (clinical, epidemiologic, laboratory)
classification_date = date                  ; Date classified

{@case}

; Patient
{.patient}
patient_id = *:                             ; De-identified patient ID
age = ##:(0..150)                           ; Age at diagnosis
age_unit = (days, months, years)            ; Age unit
gender = (female, male, other, unknown)     ; Gender
race[] = :                                  ; Race (CDC race codes)
ethnicity = (hispanic, non_hispanic, unknown)
pregnant = ?                                ; Pregnant (if applicable)

{@case}

; Geography
{.geography}
state = !:(2)                               ; State
county_fips = :(5)                          ; County FIPS
zip = :(5)                                  ; ZIP code
country_of_residence = : "US"               ; Country

{@case}

; Dates
{.dates}
symptom_onset = date                        ; Symptom onset date
diagnosis_date = date                       ; Date of diagnosis
lab_test_date = date                        ; Specimen collection date
hospitalization_date = date                 ; Hospitalization date if applicable
death_date = date                           ; Date of death if applicable
report_date = date                          ; Date reported to jurisdiction

{@case}

; Outcomes
{.outcomes}
hospitalized = ?                            ; Hospitalized
icu_admitted = ?                            ; ICU admission
died = ?                                    ; Death

{@case}

; ═══════════════════════════════════════════════════════════════════════════════
; LABORATORY REPORT
; ═══════════════════════════════════════════════════════════════════════════════
; Per Electronic Laboratory Reporting (ELR) standards

{@lab_report}
report_id = !:                              ; Lab report ID
case_id = :                                 ; Associated case ID
patient_id = !:                             ; Patient identifier
report_date = !date                         ; Report date

; Ordering provider
{.ordering}
provider_name = :                           ; Ordering provider
provider_npi = :                            ; Provider NPI
facility_name = :                           ; Facility name
facility_clia = :                           ; Facility CLIA number

{@lab_report}

; Performing laboratory
{.laboratory}
lab_name = !:                               ; Laboratory name
lab_clia = !:                               ; CLIA number
lab_address = @address                      ; Lab address
lab_phone = *@phone                         ; Lab phone

{@lab_report}

; Specimen
{.specimen}
specimen_id = :                             ; Specimen ID
specimen_type = :                           ; Specimen type (SNOMED)
collection_date = !date                     ; Collection date
received_date = date                        ; Date received at lab
specimen_source = :                         ; Anatomic source

{@lab_report}

; Test performed
{.test}
test_code = !:                              ; LOINC code
test_name = :                               ; Test name
method = :                                  ; Test method

{@lab_report}

; Result
{.result}
result_code = :                             ; SNOMED result code
result_value = :                            ; Result value
result_unit = :                             ; Unit of measure
reference_range = :                         ; Reference range
interpretation = (abnormal, high, low, normal, positive, negative)
result_date = date                          ; Result date

{@lab_report}

; Organism (if identified)
{.organism}
organism_name = :                           ; Organism name
snomed_organism = :                         ; SNOMED organism code
subtype = :                                 ; Subtype/serotype
antimicrobial_susceptibility = ?            ; AST performed

{@lab_report}

; ═══════════════════════════════════════════════════════════════════════════════
; ELECTRONIC INITIAL CASE REPORT (eICR)
; ═══════════════════════════════════════════════════════════════════════════════
; Per eCR FHIR Implementation Guide

{@eicr}
eicr_id = !:                                ; eICR document ID
patient_id = !:                             ; Patient ID
encounter_id = :                            ; Encounter ID
report_date = !date                         ; Report date
triggering_event = !:                       ; What triggered the report

; Triggering condition
{.trigger}
trigger_code = !:                           ; Trigger code (RCTC value set)
trigger_type = !(diagnosis, lab_order, lab_result, medication, procedure)
trigger_description = :                     ; Trigger description

{@eicr}

; Reporting facility
{.facility}
facility_name = !:                          ; Facility name
facility_id = :                             ; Facility ID
facility_type = :                           ; Facility type
facility_address = @address                 ; Address
facility_phone = *@phone                    ; Phone

{@eicr}

; Encounter information
{.encounter}
encounter_type = (ambulatory, emergency, inpatient)
encounter_date = date                       ; Encounter date
discharge_date = date                       ; Discharge date
chief_complaint = :                         ; Chief complaint
reason_for_visit = :                        ; Reason for visit

{@eicr}

; Clinical information
{.clinical}
problems[] = @clinical_problem              ; Active problems
medications[] = @clinical_medication        ; Current medications
lab_results[] = @clinical_lab               ; Recent labs
diagnoses[] = :                             ; Encounter diagnoses (ICD-10)

{@eicr}

; Social history (relevant to public health)
{.social}
occupation = :                              ; Occupation
industry = :                                ; Industry
travel_history[] = :                        ; Recent travel
pregnant = ?                                ; Pregnancy status
homeless = ?                                ; Housing status
congregate_setting = ?                      ; Congregate setting (jail, shelter)

{@eicr}

{@clinical_problem}
problem_code = :                            ; ICD-10 or SNOMED code
problem_name = :                            ; Problem name
onset_date = date                           ; Onset date
status = (active, inactive, resolved)       ; Problem status

{@clinical_medication}
medication_code = :                         ; RxNorm code
medication_name = :                         ; Medication name
start_date = date                           ; Start date
end_date = date                             ; End date

{@clinical_lab}
test_code = :                               ; LOINC code
test_name = :                               ; Test name
result = :                                  ; Result
result_date = date                          ; Result date

; ═══════════════════════════════════════════════════════════════════════════════
; REPORTABILITY RESPONSE (RR)
; ═══════════════════════════════════════════════════════════════════════════════
; Per eCR Reportability Response

{@reportability_response}
rr_id = !:                                  ; RR document ID
eicr_id = !:                                ; Associated eICR
response_date = !date                       ; Response date

; Reportability determination
{.determination}
reportable = ?                              ; Is reportable
determination_code = :                      ; Determination code
condition_code = :                          ; Condition code
condition_name = :                          ; Condition name

{@reportability_response}

; Rules evaluated
rules[] = @rr_rule                          ; Rules evaluated

; Routing information
{.routing}
routed_to_jurisdiction = ?                  ; Sent to jurisdiction
jurisdiction = :(2)                         ; Jurisdiction (state)
jurisdiction_name = :                       ; Jurisdiction name
reporting_deadline = date                   ; Reporting deadline

{@reportability_response}

; Provider actions
{.provider_actions}
action_required = ?                         ; Action required from provider
actions[] = :                               ; Required actions
resources[] = :                             ; Resource links

{@reportability_response}

{@rr_rule}
rule_id = :                                 ; Rule ID
condition = :                               ; Condition name
jurisdiction = :                            ; Jurisdiction
result = (may_be_reportable, not_reportable, reportable)

; ═══════════════════════════════════════════════════════════════════════════════
; CONDITION CODE REFERENCE
; ═══════════════════════════════════════════════════════════════════════════════
; Per CDC NNDSS condition list

{@condition_code}
code = !:                                   ; CDC condition code
name = !:                                   ; Condition name
category = :                                ; Category (infectious, non-infectious)
snomed_code = :                             ; SNOMED CT code
icd10_codes[] = :                           ; Associated ICD-10 codes

; Reporting requirements
{.reporting}
nationally_notifiable = ?                   ; Nationally notifiable
immediate_notification = ?                  ; Requires immediate notification
timeframe = :                               ; Reporting timeframe
method = (electronic, fax, phone)           ; Reporting method

{@condition_code}

; Case definition reference
case_definition_url = :                     ; Link to case definition
effective_date = date                       ; Case definition effective date

; ═══════════════════════════════════════════════════════════════════════════════
; OUTBREAK
; ═══════════════════════════════════════════════════════════════════════════════
; Per outbreak investigation standards

{@outbreak}
outbreak_id = !:                            ; Outbreak identifier
jurisdiction = !:(2)                        ; Lead jurisdiction
condition = !:                              ; Primary condition
identification_date = !date                 ; Date identified

; Outbreak status
{.status}
status = !(active, closed, monitoring)
start_date = date                           ; Estimated start
end_date = date                             ; End date (if closed)
duration_days = ##:(0..)                    ; Duration

{@outbreak}

; Case counts
{.cases}
total_cases = ##:(0..)                      ; Total cases
confirmed_cases = ##:(0..)                  ; Confirmed
probable_cases = ##:(0..)                   ; Probable
hospitalized = ##:(0..)                     ; Hospitalizations
deaths = ##:(0..)                           ; Deaths

{@outbreak}

; Geographic scope
{.geography}
affected_states[] = :(2)                    ; Affected states
affected_counties[] = :                     ; Affected counties
setting = :                                 ; Setting (restaurant, school, etc.)
multi_state = ?                             ; Multi-state outbreak

{@outbreak}

; Investigation
{.investigation}
investigating_agency = :                    ; Lead agency
epi_aid_requested = ?                       ; CDC Epi-Aid requested
source_identified = ?                       ; Source identified
source_description = :                      ; Source description
exposure_route = :                          ; Route of exposure

{@outbreak}

; Public communication
{.communication}
health_alert_issued = ?                     ; Health alert issued
public_announcement = ?                     ; Public announcement made

{@outbreak}


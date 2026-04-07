; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Disease Surveillance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Disease and syndromic surveillance structures covering ED visits, chief
; complaints, and outbreak detection. Derived from CDC BioSense, ESSENCE,
; and NSSP standards.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.publichealth.surveillance"
version = "1.0.0"
title = "Disease Surveillance Schema"
description = "Disease surveillance and syndromic surveillance structures"

{$derivation}
source[0].authority = "CDC"
source[0].citation = "National Syndromic Surveillance Program (NSSP)"
source[0].url = "https://www.cdc.gov/nssp/"

source[1].authority = "CDC"
source[1].citation = "NSSP ESSENCE Guide"
source[1].url = "https://www.cdc.gov/nssp/php/about/index.html"

source[2].authority = "CDC"
source[2].citation = "BioSense Platform Technical Guidance"
source[2].url = "https://www.cdc.gov/nssp/php/about/index.html"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial surveillance schema"
changelog[0].rationale = "Structure derived from CDC NSSP and syndromic surveillance standards"

; ═══════════════════════════════════════════════════════════════════════════════
; SYNDROMIC SURVEILLANCE RECORD
; ═══════════════════════════════════════════════════════════════════════════════
; Per NSSP data architecture

{@syndromic_record}
record_id = !:                              ; Record identifier
facility_id = !:                            ; Facility sending data
message_date = !date                        ; Message date/time

; Visit information
{.visit}
visit_id = :                                ; Encounter/visit ID
visit_date = !date                          ; Visit date
visit_time = :                              ; Visit time
facility_type = (ambulatory, ed, inpatient, urgent_care)
discharge_date = date                       ; Discharge date
discharge_disposition = :                   ; Discharge disposition

{@syndromic_record}

; Patient (de-identified)
{.patient}
patient_id = *:                             ; De-identified patient ID
age = ##:(0..150)                           ; Age
age_unit = (days, months, years)            ; Age unit
gender = (female, male, other, unknown)     ; Gender
race = :                                    ; Race code
ethnicity = (hispanic, non_hispanic, unknown)
zip = :(5)                                  ; Patient ZIP code

{@syndromic_record}

; Chief complaint - Key for syndromic surveillance
{.chief_complaint}
chief_complaint = :                         ; Chief complaint text
cc_parsed = :                               ; Parsed/standardized CC
triage_notes = :                            ; Additional triage notes
admit_reason = :                            ; Reason for admit

{@syndromic_record}

; Diagnoses
{.diagnoses}
diagnosis_codes[] = :                       ; ICD-10 codes
diagnosis_type = (admit, discharge, working)
principal_diagnosis = :                     ; Principal diagnosis

{@syndromic_record}

; Procedures
{.procedures}
procedure_codes[] = :                       ; Procedure codes (ICD-10-PCS, CPT)

{@syndromic_record}

; Facility/Provider
{.facility}
facility_name = :                           ; Facility name
facility_zip = :(5)                         ; Facility ZIP
treating_facility = :                       ; Treating facility if different

{@syndromic_record}

; Syndrome classification (ESSENCE)
{.syndrome}
syndromes[] = @syndrome_classification      ; Classified syndromes

{@syndromic_record}

{@syndrome_classification}
syndrome_code = :                           ; Syndrome code
syndrome_name = :                           ; Syndrome name (ILI, GI, etc.)
classification_method = :                   ; How classified
confidence = #:(0..1)                       ; Confidence score

; ═══════════════════════════════════════════════════════════════════════════════
; FACILITY REGISTRATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per NSSP onboarding requirements

{@facility_registration}
facility_id = !:                            ; NSSP facility ID
npi = :                                     ; Facility NPI
state = !:(2)                               ; State

; Facility info
{.info}
facility_name = !:                          ; Facility name
facility_type = !(ambulatory, ed, inpatient, pharmacy, poison_center, urgent_care)
address = @address                          ; Address
phone = *@phone                             ; Phone

{@facility_registration}

; Parent organization
{.organization}
parent_org = :                              ; Parent organization
system_name = :                             ; Health system name

{@facility_registration}

; Data feed
{.data_feed}
feed_type = (adt, custom, hl7_2x, hl7_cda)  ; Feed type
feed_status = (active, inactive, testing)   ; Feed status
onboard_date = date                         ; Onboarding date
last_message = date                         ; Last message received
daily_volume = ##:(0..)                     ; Average daily volume

{@facility_registration}

; Contact
contact_name = :                            ; Contact person
contact_email = *@email                     ; Email
contact_phone = *@phone                     ; Phone

{@facility_registration}

; ═══════════════════════════════════════════════════════════════════════════════
; SURVEILLANCE ALERT
; ═══════════════════════════════════════════════════════════════════════════════
; Per ESSENCE alerting standards

{@alert}
alert_id = !:                               ; Alert identifier
jurisdiction = !:(2)                        ; Jurisdiction
alert_date = !date                          ; Alert date

; Alert type
{.type}
alert_type = !(cluster, increase, outbreak, threshold)
syndrome = :                                ; Syndrome monitored
detection_method = :                        ; Detection algorithm

{@alert}

; Alert details
{.details}
expected_count = ##:(0..)                   ; Expected count
observed_count = ##:(0..)                   ; Observed count
p_value = #:(0..1)                          ; P-value
alerting_level = (green, red, yellow)       ; Alert level
statistical_test = :                        ; Test used (CUSUM, regression, etc.)

{@alert}

; Geography
{.geography}
geographic_level = (county, facility, region, state, zip)
geographic_value = :                        ; Geographic identifier
facilities_involved[] = :                   ; Facilities if applicable

{@alert}

; Investigation status
{.investigation}
investigated = ?                            ; Alert investigated
investigation_date = date                   ; Investigation date
outcome = (confirmed_outbreak, false_positive, needs_followup, true_signal)
notes = :                                   ; Investigation notes

{@alert}

; ═══════════════════════════════════════════════════════════════════════════════
; WASTEWATER SURVEILLANCE
; ═══════════════════════════════════════════════════════════════════════════════
; Per NWSS (National Wastewater Surveillance System)

{@wastewater}
sample_id = !:                              ; Sample identifier
site_id = !:                                ; Sampling site
collection_date = !date                     ; Collection date

; Sampling site
{.site}
site_name = :                               ; Site name
site_type = (collection_system, lift_station, manhole, treatment_plant)
county_fips = :(5)                          ; County FIPS
state = :(2)                                ; State
population_served = ##:(0..)                ; Population served
institution_type = :                        ; Institution if not community (jail, university)

{@wastewater}

; Sample collection
{.collection}
sample_type = (composite_24h, composite_timed, grab)
collection_time = :                         ; Collection time
volume_collected = #:(0..)                  ; Volume (L)
storage_condition = :                       ; Storage condition

{@wastewater}

; Laboratory analysis
{.analysis}
lab_name = :                                ; Laboratory name
test_method = :                             ; Testing method (RT-qPCR target)
target_pathogen = !:                        ; Target (SARS-CoV-2, RSV, etc.)
gene_target = :                             ; Gene target (N1, N2, etc.)

{@wastewater}

; Results
{.results}
concentration = #:(0..)                     ; Concentration (copies/L)
concentration_unit = :                      ; Unit
pcr_target_detected = ?                     ; Target detected
ct_value = #:(0..45)                        ; Cycle threshold
flow_normalized = #:(0..)                   ; Flow-normalized value
population_normalized = #:(0..)             ; Population-normalized value

{@wastewater}

; Quality
{.quality}
quality_flag = :                            ; Quality flags
sample_inhibited = ?                        ; PCR inhibition detected
replicate_agreement = ?                     ; Replicate agreement

{@wastewater}

; ═══════════════════════════════════════════════════════════════════════════════
; GENOMIC SURVEILLANCE
; ═══════════════════════════════════════════════════════════════════════════════
; Per CDC AMD/SPHERES standards

{@genomic_surveillance}
sequence_id = !:                            ; Sequence identifier
specimen_id = !:                            ; Associated specimen
submission_date = !date                     ; Submission date

; Specimen
{.specimen}
collection_date = !date                     ; Collection date
specimen_type = :                           ; Specimen type
source = :                                  ; Source (clinical, wastewater)
patient_age = ##:(0..150)                   ; Patient age (if clinical)
patient_gender = (female, male, unknown)    ; Gender

{@genomic_surveillance}

; Pathogen
{.pathogen}
pathogen_name = !:                          ; Pathogen name
pathogen_type = (bacteria, fungus, parasite, virus)

{@genomic_surveillance}

; Sequencing
{.sequencing}
sequencing_lab = :                          ; Sequencing laboratory
sequencing_method = :                       ; Sequencing platform
coverage = #:(0..100)                       ; Genome coverage %

{@genomic_surveillance}

; Lineage/variant
{.lineage}
lineage = :                                 ; Lineage assignment
lineage_system = :                          ; Classification system (Pango, etc.)
variant_designation = :                     ; WHO variant name if applicable
clade = :                                   ; Clade assignment
mutations[] = :                             ; Key mutations

{@genomic_surveillance}

; Repository submission
{.repository}
gisaid_accession = :                        ; GISAID accession
genbank_accession = :                       ; GenBank accession
sra_accession = :                           ; SRA accession

{@genomic_surveillance}

; Geography
{.geography}
state = :(2)                                ; State
county_fips = :(5)                          ; County FIPS
zip = :(5)                                  ; ZIP code (partial)

{@genomic_surveillance}

; ═══════════════════════════════════════════════════════════════════════════════
; SENTINEL SURVEILLANCE
; ═══════════════════════════════════════════════════════════════════════════════
; Per ILINet and other sentinel systems

{@sentinel_report}
report_id = !:                              ; Report identifier
site_id = !:                                ; Sentinel site ID
week_ending = !date                         ; MMWR week ending date

; Site information
{.site}
site_name = :                               ; Site name
site_type = (clinic, ed, hospital, pharmacy)
state = :(2)                                ; State
hhs_region = ##:(1..10)                     ; HHS region

{@sentinel_report}

; Visit counts
{.counts}
total_visits = ##:(0..)                     ; Total visits
syndrome_visits = ##:(0..)                  ; Syndrome visits (e.g., ILI)
syndrome_percent = #:(0..100)               ; Percent with syndrome

{@sentinel_report}

; Specimens (if laboratory surveillance)
{.specimens}
specimens_tested = ##:(0..)                 ; Specimens tested
specimens_positive = ##:(0..)               ; Positive specimens
percent_positive = #:(0..100)               ; Percent positive

{@sentinel_report}

; Syndrome-specific
{.syndrome}
syndrome_type = :(ili, covid_like, gi, rash, other)
syndrome_definition = :                     ; Definition used

{@sentinel_report}


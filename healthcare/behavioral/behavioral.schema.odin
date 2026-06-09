; ===================================================================================
; ODIN Behavioral Health Benefits Schema
; ===================================================================================
; Behavioral health benefit management covering mental health, substance use disorder
; treatment, ABA therapy, crisis services, telehealth, and MHPAEA parity compliance.
; Supports commercial, Medicare, and Medicaid plans in both carve-out and carve-in models.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.behavioral"
version = "1.0.0"
title = "Behavioral Health Benefits Schema"
description = "Behavioral health benefits including mental health, substance use, ABA therapy, crisis, telehealth, and parity"

{$derivation}
source[0].authority = "CMS"
source[0].citation = "Mental Health Parity and Addiction Equity Act (MHPAEA) Guidance"
source[0].url = "https://www.cms.gov/cciio/programs-and-initiatives/other-insurance-protections/mhpaea_factsheet"

source[1].authority = "GPO"
source[1].citation = "42 CFR Part 438 - Managed Care"
source[1].url = "https://www.ecfr.gov/current/title-42/chapter-IV/subchapter-C/part-438"

source[2].authority = "GPO"
source[2].citation = "45 CFR Part 146 - Group Health Plan Requirements"
source[2].url = "https://www.ecfr.gov/current/title-45/subtitle-A/subchapter-B/part-146"

source[3].authority = "ASAM"
source[3].citation = "The ASAM Criteria - Treatment Criteria for Addictive, Substance-Related, and Co-Occurring Conditions"
source[3].url = "https://www.asam.org/asam-criteria"

source[4].authority = "SAMHSA"
source[4].citation = "National Guidelines for Behavioral Health Crisis Care"
source[4].url = "https://www.samhsa.gov/find-help/implementing-behavioral-health-crisis-care"

source[5].authority = "DOL"
source[5].citation = "Mental Health Parity Final Rules"
source[5].url = "https://www.law.cornell.edu/uscode/text/29/1185a"

source[6].authority = "BACB"
source[6].citation = "Behavior Analyst Certification Board - Professional Standards"
source[6].url = "https://www.bacb.com/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on MHPAEA, ASAM criteria, SAMHSA guidelines, and state parity laws"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial behavioral health benefits schema"
changelog[0].rationale = "Comprehensive behavioral health coverage with parity compliance"

; ===================================================================================
; BEHAVIORAL HEALTH PLAN - Plan Structure
; ===================================================================================
; Per MHPAEA and state parity requirements

{@bh_plan}
; Required fields first
plan_id = :                                 ; Plan identifier
plan_name = :                               ; Plan name
effective_date = date                       ; Plan effective date
expiration_date = date                      ; Plan expiration date

; Invariants
:invariant expiration_date > effective_date

; Plan type
plan_type = (carve_in, carve_out, integrated)
funding_type = (fully_insured, level_funded, self_funded)
payer_type = (commercial, exchange, medicaid, medicare_advantage, self_funded)

; Behavioral health vendor (for carve-out)
{.vendor}
vendor_name = :                              ; BH vendor name
vendor_id = :                                ; Vendor identifier
network_name = :                             ; Network name
carve_out_services[] = :                     ; Services managed by vendor

{@bh_plan}

; ---------------------------------------------------------------------------
; Parity Compliance - Per MHPAEA
; ---------------------------------------------------------------------------
{.parity}
mhpaea_compliant = ?                         ; MHPAEA compliant
parity_analysis_date = date                  ; Last parity analysis
qtl_compliant = ?                            ; Quantitative treatment limits
nqtl_compliant = ?                           ; Non-quantitative treatment limits
comparative_analysis = ?                     ; Comparative analysis complete
state_parity = ?                             ; State parity compliance
state_parity_law = :                         ; State parity law reference

{@bh_plan}

; ---------------------------------------------------------------------------
; Cost Sharing - Must be at parity with M/S
; ---------------------------------------------------------------------------
{.cost_sharing}
deductible_combined = ?                      ; Combined with M/S deductible
oop_max_combined = ?                         ; Combined with M/S OOP max
mh_deductible = #$:(0..)                     ; MH/SUD deductible if separate
mh_oop_max = #$:(0..)                        ; MH/SUD OOP max if separate
inpatient_copay = #$:(0..)                   ; Inpatient per-day copay
outpatient_copay = #$:(0..)                  ; Outpatient visit copay
coinsurance = #:(0..100)                     ; Coinsurance percentage

{@bh_plan}

; ---------------------------------------------------------------------------
; Network Access
; ---------------------------------------------------------------------------
{.network}
provider_count = ##:(0..)                    ; BH provider count
psychiatrist_count = ##:(0..)                ; Psychiatrists
psychologist_count = ##:(0..)                ; Psychologists
lcsw_count = ##:(0..)                        ; Licensed clinical social workers
facility_count = ##:(0..)                    ; BH facilities
network_adequacy_met = ?                     ; Network adequacy standards
telehealth_available = ?                     ; Telehealth BH network

{@bh_plan}

; ---------------------------------------------------------------------------
; Utilization Management - Per MHPAEA NQTL requirements
; ---------------------------------------------------------------------------
{.utilization_management}
prior_auth = ?                               ; Prior authorization program
concurrent_review = ?                        ; Concurrent review program
retrospective_review = ?                     ; Retrospective review
step_therapy = ?                             ; Step therapy for BH meds
fail_first = ?                               ; Fail-first requirements
standards_same_as_ms = ?                     ; UM standards match M/S

{@bh_plan}

; ===================================================================================
; MENTAL HEALTH - Outpatient, Inpatient, PHP, IOP Services
; ===================================================================================
; Per MHPAEA and clinical guidelines

{@bh_mental_health}
; Required fields first
plan_id = :                                 ; Plan identifier
service_type = (group_therapy, individual_therapy, inpatient, intensive_outpatient, partial_hospitalization, psychiatric_eval, psychological_testing, residential)

; ---------------------------------------------------------------------------
; Outpatient Services
; ---------------------------------------------------------------------------
{.outpatient}
covered = ?:if service_type = (individual_therapy, group_therapy, psychiatric_eval, psychological_testing)
copay = #$:(0..):if covered = true           ; Visit copay
coinsurance = #:(0..100):if covered = true   ; Coinsurance
visit_limit = ##:(0..):if covered = true     ; Annual visit limit (0=unlimited)
visit_limit_combined = ?:if covered = true   ; Combined with SUD
prior_auth_required = ?:if covered = true    ; PA required
prior_auth_visits = ##:(0..):if prior_auth_required = true

{@bh_mental_health}

; ---------------------------------------------------------------------------
; Intensive Outpatient Program (IOP)
; ---------------------------------------------------------------------------
{.iop}
covered = ?:if service_type = intensive_outpatient
copay = #$:(0..):if covered = true           ; Day copay
coinsurance = #:(0..100):if covered = true   ; Coinsurance
day_limit = ##:(0..):if covered = true       ; Day limit (0=unlimited)
hours_per_day = ##:(3..6):if covered = true  ; Hours per day minimum
days_per_week = ##:(3..5):if covered = true  ; Days per week minimum
prior_auth_required = ?:if covered = true    ; PA required

{@bh_mental_health}

; ---------------------------------------------------------------------------
; Partial Hospitalization Program (PHP)
; ---------------------------------------------------------------------------
{.php}
covered = ?:if service_type = partial_hospitalization
copay = #$:(0..):if covered = true           ; Day copay
coinsurance = #:(0..100):if covered = true   ; Coinsurance
day_limit = ##:(0..):if covered = true       ; Day limit (0=unlimited)
hours_per_day = ##:(4..8):if covered = true  ; Hours per day minimum
prior_auth_required = ?:if covered = true    ; PA required

{@bh_mental_health}

; ---------------------------------------------------------------------------
; Inpatient Psychiatric
; ---------------------------------------------------------------------------
{.inpatient}
covered = ?:if service_type = inpatient
copay_per_day = #$:(0..):if covered = true   ; Per-day copay
coinsurance = #:(0..100):if covered = true   ; Coinsurance
day_limit = ##:(0..):if covered = true       ; Day limit (0=unlimited)
prior_auth_required = ?:if covered = true    ; PA required
concurrent_review = ?:if covered = true      ; Concurrent review
acute_only = ?:if covered = true             ; Acute care only

{@bh_mental_health}

; ---------------------------------------------------------------------------
; Residential Treatment
; ---------------------------------------------------------------------------
{.residential}
covered = ?:if service_type = residential
copay_per_day = #$:(0..):if covered = true   ; Per-day copay
coinsurance = #:(0..100):if covered = true   ; Coinsurance
day_limit = ##:(0..):if covered = true       ; Day limit (0=unlimited)
prior_auth_required = ?:if covered = true    ; PA required
rto_covered = ?:if covered = true            ; Residential treatment organization
imd_exclusion = ?:if covered = true          ; IMD exclusion applies

{@bh_mental_health}

; ---------------------------------------------------------------------------
; Psychological Testing
; ---------------------------------------------------------------------------
{.testing}
covered = ?:if service_type = psychological_testing
hour_limit = ##:(0..):if covered = true      ; Hour limit
prior_auth_required = ?:if covered = true    ; PA required
conditions_covered[] = ::if covered = true   ; Covered conditions
neuropsych_covered = ?:if covered = true     ; Neuropsych testing

{@bh_mental_health}

; ---------------------------------------------------------------------------
; Provider Types
; ---------------------------------------------------------------------------
{.providers}
psychiatrist = ?                             ; MD/DO psychiatrist
psychologist = ?                             ; PhD/PsyD psychologist
lcsw = ?                                     ; Licensed clinical social worker
lmft = ?                                     ; Licensed marriage/family therapist
lpc = ?                                      ; Licensed professional counselor
psychiatric_np = ?                           ; Psychiatric nurse practitioner
peer_support = ?                             ; Peer support specialist

{@bh_mental_health}

; ===================================================================================
; SUBSTANCE USE DISORDER - ASAM Levels, Detox, Residential, MAT
; ===================================================================================
; Per ASAM Criteria and MHPAEA

{@bh_sud}
; Required fields first
plan_id = :                                 ; Plan identifier
asam_level = (level_0_5, level_1, level_2_1, level_2_5, level_3_1, level_3_3, level_3_5, level_3_7, level_4, otp)

; ASAM Level descriptions:
; 0.5 = Early Intervention
; 1 = Outpatient Services
; 2.1 = Intensive Outpatient (IOP)
; 2.5 = Partial Hospitalization
; 3.1 = Clinically Managed Low-Intensity Residential
; 3.3 = Clinically Managed Population-Specific High-Intensity Residential
; 3.5 = Clinically Managed High-Intensity Residential
; 3.7 = Medically Monitored Intensive Inpatient
; 4 = Medically Managed Intensive Inpatient
; OTP = Opioid Treatment Program

; ---------------------------------------------------------------------------
; Coverage Details
; ---------------------------------------------------------------------------
{.coverage}
covered = ?                                  ; Level covered
copay = #$:(0..):if covered = true           ; Copay
coinsurance = #:(0..100):if covered = true   ; Coinsurance
day_limit = ##:(0..):if covered = true       ; Day limit (0=unlimited)
combined_with_mh = ?:if covered = true       ; Combined with MH limits
prior_auth_required = ?:if covered = true    ; PA required

{@bh_sud}

; ---------------------------------------------------------------------------
; Detoxification Services
; ---------------------------------------------------------------------------
{.detox}
covered = ?:if asam_level = (level_3_7, level_4)
inpatient_covered = ?:if covered = true      ; Inpatient detox
ambulatory_covered = ?:if covered = true     ; Ambulatory detox
day_limit = ##:(0..):if covered = true       ; Day limit
medical_supervision = ?:if covered = true    ; Medical supervision required
prior_auth_required = ?:if covered = true    ; PA required

{@bh_sud}

; ---------------------------------------------------------------------------
; Residential Treatment
; ---------------------------------------------------------------------------
{.residential}
covered = ?:if asam_level = (level_3_1, level_3_3, level_3_5)
day_limit = ##:(0..):if covered = true       ; Day limit
gender_specific = ?:if covered = true        ; Gender-specific available
co_occurring = ?:if covered = true           ; Co-occurring capable
imd_exclusion = ?:if covered = true          ; IMD exclusion (Medicaid)
prior_auth_required = ?:if covered = true    ; PA required

{@bh_sud}

; ---------------------------------------------------------------------------
; Medication-Assisted Treatment (MAT)
; ---------------------------------------------------------------------------
{.mat}
covered = ?                                  ; MAT covered
buprenorphine = ?:if covered = true          ; Buprenorphine/Suboxone
methadone = ?:if covered = true              ; Methadone (OTP)
naltrexone = ?:if covered = true             ; Naltrexone/Vivitrol
prior_auth_required = ?:if covered = true    ; PA required
otp_coverage = ?:if covered = true           ; Opioid treatment program
counseling_required = ?:if covered = true    ; Counseling with MAT

{@bh_sud}

; ---------------------------------------------------------------------------
; Outpatient SUD
; ---------------------------------------------------------------------------
{.outpatient}
covered = ?:if asam_level = (level_0_5, level_1)
copay = #$:(0..):if covered = true           ; Visit copay
visit_limit = ##:(0..):if covered = true     ; Visit limit (0=unlimited)
group_therapy = ?:if covered = true          ; Group therapy covered
individual_therapy = ?:if covered = true     ; Individual therapy
family_therapy = ?:if covered = true         ; Family therapy

{@bh_sud}

; ---------------------------------------------------------------------------
; Intensive Outpatient / Partial Hospitalization
; ---------------------------------------------------------------------------
{.iop_php}
covered = ?:if asam_level = (level_2_1, level_2_5)
day_limit = ##:(0..):if covered = true       ; Day limit
hours_per_day = ##:(3..8):if covered = true  ; Hours per day
days_per_week = ##:(3..5):if covered = true  ; Days per week
prior_auth_required = ?:if covered = true    ; PA required

{@bh_sud}

; ===================================================================================
; ABA THERAPY - Applied Behavior Analysis for Autism
; ===================================================================================
; Per BACB standards and state autism mandates

{@bh_aba}
; Required fields first
plan_id = :                                 ; Plan identifier
covered = ?                                 ; ABA therapy covered

; ---------------------------------------------------------------------------
; Coverage Details
; ---------------------------------------------------------------------------
{.coverage}
copay = #$:(0..):if covered = true           ; Visit/hour copay
coinsurance = #:(0..100):if covered = true   ; Coinsurance
annual_limit = #$:(0..):if covered = true    ; Annual dollar limit
hour_limit = ##:(0..):if covered = true      ; Annual hour limit
lifetime_limit = #$:(0..):if covered = true  ; Lifetime dollar limit
age_limit = ##:(0..26):if covered = true     ; Age limit

{@bh_aba}

; ---------------------------------------------------------------------------
; Diagnosis Requirements
; ---------------------------------------------------------------------------
{.diagnosis}
autism_required = ?:if covered = true        ; ASD diagnosis required
icd10_codes[] = ::if covered = true          ; Covered ICD-10 codes
developmental_delay = ?:if covered = true    ; Developmental delay covered
other_conditions[] = ::if covered = true     ; Other covered conditions

{@bh_aba}

; ---------------------------------------------------------------------------
; Provider Requirements
; ---------------------------------------------------------------------------
{.providers}
bcba_required = ?:if covered = true          ; BCBA supervision required
bcba_hours = ##:(0..):if bcba_required = true ; BCBA hours per month
bcaba_covered = ?:if covered = true          ; BCaBA covered
rbt_covered = ?:if covered = true            ; RBT covered
supervision_ratio = :                        ; Supervision ratio

{@bh_aba}

; ---------------------------------------------------------------------------
; Treatment Plan Requirements
; ---------------------------------------------------------------------------
{.treatment_plan}
initial_assessment = ?:if covered = true     ; Initial assessment required
treatment_plan_required = ?:if covered = true ; Written plan required
review_frequency = :                         ; Plan review frequency
goals_required = ?:if covered = true         ; Measurable goals required
parent_training = ?:if covered = true        ; Parent training included
school_coordination = ?:if covered = true    ; School coordination

{@bh_aba}

; ---------------------------------------------------------------------------
; Prior Authorization
; ---------------------------------------------------------------------------
{.prior_auth}
required = ?:if covered = true               ; PA required
initial_auth_hours = ##:(0..):if required = true
reauth_frequency = :                         ; Reauthorization frequency
documentation_required[] = ::if required = true

{@bh_aba}

; ---------------------------------------------------------------------------
; State Autism Mandate Compliance
; ---------------------------------------------------------------------------
{.mandate}
state_mandate_applies = ?                    ; State mandate applies
mandate_state = :(2):if state_mandate_applies = true
mandate_minimum = #$:(0..):if state_mandate_applies = true
mandate_age_limit = ##:(0..26):if state_mandate_applies = true

{@bh_aba}

; ===================================================================================
; CRISIS SERVICES - Crisis Intervention, Mobile Crisis, Stabilization
; ===================================================================================
; Per SAMHSA National Guidelines for Behavioral Health Crisis Care

{@bh_crisis}
; Required fields first
plan_id = :                                 ; Plan identifier
service_type = (crisis_line, crisis_stabilization, mobile_crisis, peer_respite, psychiatric_emergency, respite_care, warm_line)

; ---------------------------------------------------------------------------
; Crisis Line Services (988)
; ---------------------------------------------------------------------------
{.crisis_line}
covered = ?:if service_type = (crisis_line, warm_line)
twenty_four_seven = ?:if covered = true      ; 24/7 availability
follow_up = ?:if covered = true              ; Follow-up calls
dispatch_capability = ?:if covered = true    ; Can dispatch mobile team
text_available = ?:if covered = true         ; Text service available
chat_available = ?:if covered = true         ; Chat service available

{@bh_crisis}

; ---------------------------------------------------------------------------
; Mobile Crisis Team
; ---------------------------------------------------------------------------
{.mobile_crisis}
covered = ?:if service_type = mobile_crisis
copay = #$:(0..):if covered = true           ; Visit copay
response_time = ##:(0..):if covered = true   ; Target response minutes
geographic_coverage = :                      ; Coverage area
law_enforcement = ?:if covered = true        ; Law enforcement coordination
clinician_led = ?:if covered = true          ; Clinician-led team

{@bh_crisis}

; ---------------------------------------------------------------------------
; Crisis Stabilization Unit
; ---------------------------------------------------------------------------
{.stabilization}
covered = ?:if service_type = crisis_stabilization
copay_per_day = #$:(0..):if covered = true   ; Per-day copay
coinsurance = #:(0..100):if covered = true   ; Coinsurance
hour_limit = ##:(0..72):if covered = true    ; Hour limit (typically 23 or 72)
bed_capacity = ##:(0..):if covered = true    ; Bed capacity
voluntary_only = ?:if covered = true         ; Voluntary only
observation_hours = ##:(0..24):if covered = true

{@bh_crisis}

; ---------------------------------------------------------------------------
; Psychiatric Emergency Services
; ---------------------------------------------------------------------------
{.emergency}
covered = ?:if service_type = psychiatric_emergency
er_copay = #$:(0..):if covered = true        ; ER copay
waived_if_admitted = ?:if covered = true     ; Copay waived if admitted
psychiatric_er = ?:if covered = true         ; Dedicated psych ER
medical_clearance = ?:if covered = true      ; Medical clearance required

{@bh_crisis}

; ---------------------------------------------------------------------------
; Respite Care
; ---------------------------------------------------------------------------
{.respite}
covered = ?:if service_type = (respite_care, peer_respite)
day_limit = ##:(0..):if covered = true       ; Annual day limit
hour_limit = ##:(0..):if covered = true      ; Annual hour limit
peer_operated = ?:if service_type = peer_respite
prior_auth_required = ?:if covered = true    ; PA required

{@bh_crisis}

; ===================================================================================
; TELEHEALTH - Behavioral Telehealth Services
; ===================================================================================
; Per state telehealth laws and parity requirements

{@bh_telehealth}
; Required fields first
plan_id = :                                 ; Plan identifier
covered = ?                                 ; Telehealth BH covered

; ---------------------------------------------------------------------------
; Service Coverage
; ---------------------------------------------------------------------------
{.services}
individual_therapy = ?:if covered = true     ; Individual therapy
group_therapy = ?:if covered = true          ; Group therapy
psychiatric_eval = ?:if covered = true       ; Psychiatric evaluation
medication_management = ?:if covered = true  ; Medication management
psychological_testing = ?:if covered = true  ; Psychological testing
crisis_services = ?:if covered = true        ; Crisis services
sud_services = ?:if covered = true           ; SUD treatment
aba_therapy = ?:if covered = true            ; ABA therapy
mat_services = ?:if covered = true           ; MAT services

{@bh_telehealth}

; ---------------------------------------------------------------------------
; Cost Sharing
; ---------------------------------------------------------------------------
{.cost_sharing}
parity_with_in_person = ?:if covered = true  ; Same as in-person
copay = #$:(0..):if covered = true           ; Telehealth copay
coinsurance = #:(0..100):if covered = true   ; Coinsurance
deductible_applies = ?:if covered = true     ; Deductible applies
facility_fee = ?:if covered = true           ; Facility fee covered

{@bh_telehealth}

; ---------------------------------------------------------------------------
; Modalities
; ---------------------------------------------------------------------------
{.modalities}
synchronous_video = ?:if covered = true      ; Live video
asynchronous = ?:if covered = true           ; Store-and-forward
audio_only = ?:if covered = true             ; Audio-only (telephone)
remote_monitoring = ?:if covered = true      ; Remote patient monitoring
digital_therapeutics = ?:if covered = true   ; Digital therapeutics

{@bh_telehealth}

; ---------------------------------------------------------------------------
; Provider Requirements
; ---------------------------------------------------------------------------
{.providers}
in_network_required = ?:if covered = true    ; In-network only
state_licensure = ?:if covered = true        ; State license required
originating_site = :                         ; Originating site requirements
distant_site = :                             ; Distant site requirements
provider_types[] = ::if covered = true       ; Covered provider types

{@bh_telehealth}

; ---------------------------------------------------------------------------
; Platform Requirements
; ---------------------------------------------------------------------------
{.platform}
hipaa_compliant = ?:if covered = true        ; HIPAA compliance required
approved_platforms[] = ::if covered = true   ; Approved platforms
encryption_required = ?:if covered = true    ; Encryption required
baa_required = ?:if covered = true           ; BAA required

{@bh_telehealth}

; ---------------------------------------------------------------------------
; Geographic and Access
; ---------------------------------------------------------------------------
{.access}
cross_state = ?:if covered = true            ; Cross-state coverage
rural_priority = ?:if covered = true         ; Rural access priority
home_as_originating = ?:if covered = true    ; Home as originating site
school_as_originating = ?:if covered = true  ; School as originating site
workplace_as_originating = ?:if covered = true

{@bh_telehealth}

; ===================================================================================
; PARITY - MHPAEA Compliance Analysis
; ===================================================================================
; Per MHPAEA, 45 CFR 146.136, and DOL guidance

{@bh_parity}
; Required fields first
plan_id = :                                 ; Plan identifier
analysis_date = date                        ; Analysis date
compliant = ?                               ; Overall parity compliant

; ---------------------------------------------------------------------------
; Plan Classification
; ---------------------------------------------------------------------------
{.classification}
large_group = ?                              ; Large group health plan
small_group = ?                              ; Small group health plan
individual = ?                               ; Individual market
self_funded = ?                              ; Self-funded ERISA plan
state_regulated = ?                          ; State-regulated plan
mhpaea_applicable = ?                        ; MHPAEA applies

{@bh_parity}

; ---------------------------------------------------------------------------
; Benefit Classifications - Per 45 CFR 146.136(c)(2)
; ---------------------------------------------------------------------------
{.benefit_classifications}
inpatient_in = ?                             ; Inpatient in-network
inpatient_out = ?                            ; Inpatient out-of-network
outpatient_in = ?                            ; Outpatient in-network
outpatient_out = ?                           ; Outpatient out-of-network
emergency = ?                                ; Emergency care
prescription_drugs = ?                       ; Prescription drugs

{@bh_parity}

; ---------------------------------------------------------------------------
; Quantitative Treatment Limits (QTLs) - Per 45 CFR 146.136(c)(3)
; ---------------------------------------------------------------------------
{.qtl}
compliant = ?                                ; QTL compliant
financial_requirements_tested = ?            ; Financial requirements
deductible_parity = ?                        ; Deductible at parity
copay_parity = ?                             ; Copay at parity
coinsurance_parity = ?                       ; Coinsurance at parity
oop_max_parity = ?                           ; OOP max at parity
treatment_limits_tested = ?                  ; Treatment limits
day_limit_parity = ?                         ; Day limits at parity
visit_limit_parity = ?                       ; Visit limits at parity
findings = :                                 ; QTL findings summary

{@bh_parity}

; ---------------------------------------------------------------------------
; Non-Quantitative Treatment Limits (NQTLs) - Per 45 CFR 146.136(c)(4)
; ---------------------------------------------------------------------------
{.nqtl}
compliant = ?                                ; NQTL compliant
prior_auth_parity = ?                        ; Prior auth at parity
concurrent_review_parity = ?                 ; Concurrent review
step_therapy_parity = ?                      ; Step therapy
network_adequacy_parity = ?                  ; Network adequacy
reimbursement_parity = ?                     ; Reimbursement rates
medical_necessity_parity = ?                 ; Medical necessity criteria
formulary_design_parity = ?                  ; Formulary design
provider_admission_parity = ?                ; Provider admission
findings = :                                 ; NQTL findings summary

{@bh_parity}

; ---------------------------------------------------------------------------
; Comparative Analysis - Per CAA 2021 requirements
; ---------------------------------------------------------------------------
{.comparative_analysis}
completed = ?                                ; Comparative analysis done
completion_date = date:if completed = true   ; Completion date
factors_documented = ?:if completed = true   ; Factors documented
sources_documented = ?:if completed = true   ; Sources documented
evidentiary_standards = ?:if completed = true ; Evidentiary standards
application_documented = ?:if completed = true ; Application documented
results_documented = ?:if completed = true   ; Results documented
remediation_documented = ?:if completed = true ; Remediation plan

{@bh_parity}

; ---------------------------------------------------------------------------
; State Parity Compliance
; ---------------------------------------------------------------------------
{.state_parity}
state = :(2)                                 ; State
state_law_reference = :                      ; State parity law
exceeds_federal = ?                          ; State exceeds federal
additional_requirements = :                  ; Additional state requirements
compliant = ?                                ; State parity compliant

{@bh_parity}

; ---------------------------------------------------------------------------
; Remediation
; ---------------------------------------------------------------------------
{.remediation}
required = ?                                 ; Remediation required
plan = ::if required = true                  ; Remediation plan
target_date = date:if required = true        ; Target completion
completed = ?:if required = true             ; Remediation completed
completion_date = date:if completed = true   ; Completion date

{@bh_parity}

; ===================================================================================
; BEHAVIORAL HEALTH CLAIM
; ===================================================================================
; Per HIPAA 837P and industry standards

{@bh_claim}
; Required fields first
claim_id = :                                ; Claim identifier
service_date = date                         ; Date of service
member_id = *:                              ; Member identifier
provider_npi = :/^\d{10}$/                  ; Rendering provider NPI
service_category = (aba, crisis, inpatient, iop, mat, outpatient, php, residential, sud, telehealth, testing)

; Patient information
{.patient}
patient_name = *:                            ; Patient name
relationship = (child, other, self, spouse)  ; Relationship to subscriber
date_of_birth = *date                        ; Patient DOB

{@bh_claim}

; Service information
{.service}
cpt_code = :                                 ; CPT code
hcpcs_code = :                               ; HCPCS code
revenue_code = :                             ; Revenue code (facility)
place_of_service = :                         ; Place of service code
units = ##:(1..)                             ; Service units
minutes = ##:(0..)                           ; Service minutes
description = :                              ; Service description
primary_diagnosis = :                        ; Primary ICD-10
secondary_diagnosis[] = :                    ; Secondary diagnoses

{@bh_claim}

; Provider information
{.provider}
rendering_npi = :/^\d{10}$/                  ; Rendering provider
billing_npi = :/^\d{10}$/                    ; Billing provider
provider_name = :                            ; Provider name
provider_type = :                            ; Provider type
facility_npi = :/^\d{10}$/                   ; Facility NPI if applicable
facility_name = :                            ; Facility name

{@bh_claim}

; Charges and payment
{.charges}
billed_amount = #$:(0..)                     ; Billed amount
allowed_amount = #$:(0..)                    ; Allowed amount
deductible = #$:(0..)                        ; Deductible applied
coinsurance = #$:(0..)                       ; Coinsurance amount
copay = #$:(0..)                             ; Copay amount
plan_paid = #$:(0..)                         ; Plan payment
patient_responsibility = #$:(0..)            ; Patient responsibility
cob_amount = #$:(0..)                        ; COB adjustment

{@bh_claim}

; Authorization
{.authorization}
auth_number = :                              ; Authorization number
auth_required = ?                            ; Auth was required
auth_obtained = ?                            ; Auth was obtained
auth_status = (approved, denied, pending, retro)

{@bh_claim}

; Adjudication
{.adjudication}
status = (denied, paid, pended, pending, rejected)
process_date = date                          ; Process date
denial_reason = :                            ; Denial reason code
denial_description = :                       ; Denial description
medical_necessity_denial = ?                 ; Medical necessity
not_covered_denial = ?                       ; Not covered
no_auth_denial = ?                           ; No authorization
level_of_care_denial = ?                     ; Level of care

{@bh_claim}


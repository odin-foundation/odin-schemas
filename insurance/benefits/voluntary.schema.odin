; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Voluntary Benefits Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Voluntary and worksite benefits including accident, critical illness, hospital
; indemnity, cancer, legal, identity theft, and pet insurance derived from state
; insurance regulations and ERISA.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as benefits
@import "../personal/pet/pet.schema.odin" as pet

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.benefits.voluntary"
version = "1.0.0"
title = "Voluntary Benefits Schema"
description = "Voluntary/worksite benefits including accident, critical illness, hospital, legal, and pet"

{$derivation}
source[0].authority = "NAIC"
source[0].citation = "Individual Accident and Sickness Insurance Minimum Standards"
source[0].url = "https://content.naic.org/sites/default/files/model-law-170.pdf"

source[1].authority = "GPO"
source[1].citation = "29 USC Chapter 18 - ERISA Welfare Benefit Plans"
source[1].url = "https://www.law.cornell.edu/uscode/text/29/chapter-18"

source[2].authority = "NAIC"
source[2].citation = "Accident and Sickness Insurance Model Regulation"
source[2].url = "https://content.naic.org/sites/default/files/model-law-171.pdf"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial voluntary benefits schema"
changelog[0].rationale = "Structure derived from NAIC model laws and worksite benefit standards"

; ═══════════════════════════════════════════════════════════════════════════════
; ACCIDENT INSURANCE
; ═══════════════════════════════════════════════════════════════════════════════
; Worksite accident insurance (voluntary)

{@accident}
plan_id = !:                                ; Plan ID
employer_id = !:                            ; Employer
plan_name = !:                              ; Plan name

; Plan structure
{.plan}
coverage_type = !(employee_only, employee_family, employee_spouse)
portability = ?                             ; Portable if employment ends
guaranteed_issue = ?                        ; Guaranteed issue
rate_guarantee_years = ##:(1..5)            ; Rate guarantee period

{@accident}

; Carrier
{.carrier}
carrier_name = :                            ; Carrier name
policy_number = :                           ; Policy number
group_number = :                            ; Group number

{@accident}

; Initial accident benefits
{.accident}
accidental_death = #$:(0..)                 ; Accidental death benefit
accidental_death_common_carrier = #$:(0..)  ; Common carrier AD benefit
dismemberment_schedule = ?                  ; Per schedule
accidental_dismemberment_single = #$:(0..)  ; Single dismemberment
accidental_dismemberment_double = #$:(0..)  ; Double dismemberment
accidental_coma = #$:(0..)                  ; Coma benefit
accidental_paralysis_quad = #$:(0..)        ; Quadriplegia
accidental_paralysis_para = #$:(0..)        ; Paraplegia
accidental_paralysis_hemi = #$:(0..)        ; Hemiplegia

{@accident}

; Hospital benefits
{.hospital}
hospital_admission = #$:(0..)               ; Hospital admission benefit
hospital_confinement = #$:(0..)             ; Per-day confinement
hospital_confinement_days_max = ##:(0..365) ; Maximum days
hospital_icu = #$:(0..)                     ; ICU per-day benefit
hospital_icu_days_max = ##:(0..30)          ; ICU maximum days

{@accident}

; Emergency and treatment
{.treatment}
emergency_room = #$:(0..)                   ; Emergency room benefit
urgent_care = #$:(0..)                      ; Urgent care benefit
ambulance_ground = #$:(0..)                 ; Ground ambulance
ambulance_air = #$:(0..)                    ; Air ambulance
physician_visit = #$:(0..)                  ; Physician visit
physician_visits_max = ##:(0..10)           ; Maximum visits

{@accident}

; Diagnostic
{.diagnostic}
xray = #$:(0..)                             ; X-ray benefit
mri_ct = #$:(0..)                           ; MRI/CT benefit
lab_work = #$:(0..)                         ; Lab work benefit

{@accident}

; Surgical
{.surgical}
surgery_outpatient = #$:(0..)               ; Outpatient surgery
surgery_inpatient = #$:(0..)                ; Inpatient surgery
anesthesia = #$:(0..)                       ; Anesthesia benefit

{@accident}

; Injury-specific benefits
{.injury}
fracture_benefit_max = #$:(0..)             ; Maximum fracture benefit
dislocation_benefit_max = #$:(0..)          ; Maximum dislocation benefit
laceration_benefit_max = #$:(0..)           ; Laceration benefit
burn_benefit_max = #$:(0..)                 ; Burn benefit
concussion = #$:(0..)                       ; Concussion benefit
eye_injury = #$:(0..)                       ; Eye injury benefit
ruptured_disc = #$:(0..)                    ; Ruptured disc benefit
torn_cartilage = #$:(0..)                   ; Torn cartilage benefit

{@accident}

; Follow-up care
{.followup}
physical_therapy = #$:(0..)                 ; Per-visit benefit
physical_therapy_visits_max = ##:(0..30)    ; Maximum visits
prosthetic_device = #$:(0..)                ; Prosthetic device benefit
medical_appliance = #$:(0..)                ; Appliance (crutches, etc.)

{@accident}

; Wellness benefit (if included)
{.wellness}
wellness_benefit = #$:(0..)                 ; Health screening benefit
wellness_tests_covered[] = :                ; Covered wellness tests

{@accident}

; ═══════════════════════════════════════════════════════════════════════════════
; CRITICAL ILLNESS INSURANCE
; ═══════════════════════════════════════════════════════════════════════════════

{@critical_illness}
plan_id = !:                                ; Plan ID
employer_id = !:                            ; Employer
plan_name = !:                              ; Plan name

; Plan structure
{.plan}
coverage_type = !(employee_only, employee_family, employee_spouse)
lump_sum_benefit = #$:(0..)                 ; Lump sum benefit amount
benefit_options[] = #$:(0..)                ; Available benefit amounts
spouse_benefit_percent = #:(0..100)         ; Spouse % of employee benefit
child_benefit_percent = #:(0..100)          ; Child % of employee benefit

{@critical_illness}

; Carrier
{.carrier}
carrier_name = :                            ; Carrier name
policy_number = :                           ; Policy number
group_number = :                            ; Group number

{@critical_illness}

; Covered conditions - Per policy schedule
{.covered_conditions}
; Cancer
cancer_invasive = #:(0..100)                ; % for invasive cancer
cancer_carcinoma_in_situ = #:(0..100)       ; % for carcinoma in situ
cancer_skin = #:(0..100)                    ; % for skin cancer

; Heart
heart_attack = #:(0..100)                   ; % for heart attack
coronary_bypass = #:(0..100)                ; % for bypass surgery
heart_valve_replacement = #:(0..100)        ; % for valve replacement
aorta_surgery = #:(0..100)                  ; % for aorta surgery

; Stroke
stroke = #:(0..100)                         ; % for stroke

; Organ failure
kidney_failure = #:(0..100)                 ; % for kidney failure
major_organ_transplant = #:(0..100)         ; % for organ transplant
bone_marrow_transplant = #:(0..100)         ; % for bone marrow transplant

; Other conditions
als = #:(0..100)                            ; % for ALS
alzheimers = #:(0..100)                     ; % for Alzheimer's
parkinsons = #:(0..100)                     ; % for Parkinson's
multiple_sclerosis = #:(0..100)             ; % for MS
benign_brain_tumor = #:(0..100)             ; % for benign brain tumor
blindness = #:(0..100)                      ; % for blindness
deafness = #:(0..100)                       ; % for deafness
paralysis = #:(0..100)                      ; % for paralysis
coma = #:(0..100)                           ; % for coma
severe_burns = #:(0..100)                   ; % for severe burns
loss_of_speech = #:(0..100)                 ; % for loss of speech

{@critical_illness}

; Recurrence benefit
{.recurrence}
recurrence_benefit = ?                      ; Recurrence benefit available
recurrence_waiting_months = ##:(0..24)      ; Months between occurrences
recurrence_percent = #:(0..100)             ; % for recurrence
different_condition_waiting_days = ##:(0..90) ; Days for different condition

{@critical_illness}

; Wellness benefit
{.wellness}
wellness_benefit = #$:(0..)                 ; Health screening benefit
wellness_frequency = (annual, once)         ; Once or annual

{@critical_illness}

; Underwriting
{.underwriting}
guaranteed_issue_amount = #$:(0..)          ; GI amount
eoi_required_over = #$:(0..)                ; EOI over this amount
pre_existing_lookback_months = ##:(0..24)   ; Pre-existing lookback
pre_existing_exclusion_months = ##:(0..24)  ; Pre-existing exclusion

{@critical_illness}

; Rates
{.rates}
rate_structure = (age_banded, composite, issue_age)
portability = ?                             ; Portable coverage
rate_per_1000 = #:(0..10)                   ; Rate per $1,000

{@critical_illness}

; ═══════════════════════════════════════════════════════════════════════════════
; HOSPITAL INDEMNITY INSURANCE
; ═══════════════════════════════════════════════════════════════════════════════

{@hospital_indemnity}
plan_id = !:                                ; Plan ID
employer_id = !:                            ; Employer
plan_name = !:                              ; Plan name

; Plan structure
{.plan}
coverage_type = !(employee_only, employee_family, employee_spouse)
portability = ?                             ; Portable
guaranteed_issue = ?                        ; GI available

{@hospital_indemnity}

; Carrier
{.carrier}
carrier_name = :                            ; Carrier name
policy_number = :                           ; Policy number
group_number = :                            ; Group number

{@hospital_indemnity}

; Hospital admission benefits
{.admission}
hospital_admission = #$:(0..)               ; Admission benefit
admission_per_confinement = ?               ; Once per confinement
admissions_per_year_max = ##:(0..10)        ; Maximum admissions/year

{@hospital_indemnity}

; Hospital confinement benefits
{.confinement}
daily_benefit = #$:(0..)                    ; Daily benefit amount
daily_benefit_options[] = #$:(0..)          ; Available daily benefit options
confinement_days_max = ##:(0..365)          ; Maximum days per confinement
confinements_per_year_max = ##:(0..10)      ; Maximum confinements/year

{@hospital_indemnity}

; ICU benefits
{.icu}
icu_admission = #$:(0..)                    ; ICU admission benefit
icu_daily_benefit = #$:(0..)                ; ICU daily benefit
icu_daily_benefit_options[] = #$:(0..)      ; Available ICU daily options
icu_days_max = ##:(0..30)                   ; Maximum ICU days

{@hospital_indemnity}

; Surgery benefits (if included)
{.surgery}
inpatient_surgery = #$:(0..)                ; Inpatient surgery benefit
outpatient_surgery = #$:(0..)               ; Outpatient surgery benefit
surgeries_per_year_max = ##:(0..10)         ; Maximum surgeries/year

{@hospital_indemnity}

; Additional benefits
{.additional}
emergency_room = #$:(0..)                   ; ER benefit (accident only)
urgent_care = #$:(0..)                      ; Urgent care benefit
ambulance_ground = #$:(0..)                 ; Ground ambulance
ambulance_air = #$:(0..)                    ; Air ambulance
physician_visit = #$:(0..)                  ; Physician visit during stay

{@hospital_indemnity}

; Wellness
{.wellness}
wellness_benefit = #$:(0..)                 ; Wellness benefit
wellness_frequency = (annual, once)         ; Frequency

{@hospital_indemnity}

; Rates
{.rates}
rate_structure = (age_banded, composite)
spouse_rate = #$:(0..)                      ; Additional for spouse
child_rate = #$:(0..)                       ; Additional for children
family_rate = #$:(0..)                      ; Family rate

{@hospital_indemnity}

; ═══════════════════════════════════════════════════════════════════════════════
; CANCER INSURANCE
; ═══════════════════════════════════════════════════════════════════════════════
; Standalone cancer insurance (supplement to health)

{@cancer}
plan_id = !:                                ; Plan ID
employer_id = !:                            ; Employer
plan_name = !:                              ; Plan name

; Plan structure
{.plan}
coverage_type = !(employee_only, employee_family, employee_spouse)
first_diagnosis_benefit = #$:(0..)          ; First diagnosis lump sum
portability = ?                             ; Portable
guaranteed_issue = ?                        ; GI available

{@cancer}

; Carrier
{.carrier}
carrier_name = :                            ; Carrier name
policy_number = :                           ; Policy number
group_number = :                            ; Group number

{@cancer}

; Cancer diagnosis benefits
{.diagnosis}
internal_cancer = #$:(0..)                  ; Internal cancer benefit
carcinoma_in_situ = #$:(0..)                ; Carcinoma in situ benefit
skin_cancer = #$:(0..)                      ; Skin cancer benefit
positive_screening = #$:(0..)               ; Positive screening benefit

{@cancer}

; Treatment benefits
{.treatment}
chemotherapy = #$:(0..)                     ; Chemotherapy per treatment
chemotherapy_max = #$:(0..)                 ; Annual chemotherapy max
radiation = #$:(0..)                        ; Radiation per treatment
radiation_max = #$:(0..)                    ; Annual radiation max
immunotherapy = #$:(0..)                    ; Immunotherapy
hormone_therapy = #$:(0..)                  ; Hormone therapy
stem_cell_transplant = #$:(0..)             ; Stem cell transplant
bone_marrow_transplant = #$:(0..)           ; Bone marrow transplant
blood_plasma_platelets = #$:(0..)           ; Blood/plasma/platelets

{@cancer}

; Surgery benefits
{.surgery}
cancer_surgery = #$:(0..)                   ; Cancer surgery benefit
reconstructive_surgery = #$:(0..)           ; Reconstructive surgery
prosthetic_device = #$:(0..)                ; Prosthetic device

{@cancer}

; Hospital benefits
{.hospital}
hospital_confinement = #$:(0..)             ; Per-day confinement
hospital_days_max = ##:(0..365)             ; Maximum days
extended_care = #$:(0..)                    ; Extended care facility
hospice = #$:(0..)                          ; Hospice benefit

{@cancer}

; Other benefits
{.other}
ambulance = #$:(0..)                        ; Ambulance benefit
medical_imaging = #$:(0..)                  ; Medical imaging
experimental_treatment = #$:(0..)           ; Experimental treatment
second_opinion = #$:(0..)                   ; Second opinion benefit
waiver_of_premium = ?                       ; Waiver of premium

{@cancer}

; Wellness
{.wellness}
wellness_benefit = #$:(0..)                 ; Cancer screening benefit
mammogram = #$:(0..)                        ; Mammogram benefit
colonoscopy = #$:(0..)                      ; Colonoscopy benefit
pap_smear = #$:(0..)                        ; Pap smear benefit
psa_test = #$:(0..)                         ; PSA test benefit
wellness_annual = ?                         ; Annual wellness benefit

{@cancer}

; ═══════════════════════════════════════════════════════════════════════════════
; LEGAL SERVICES PLAN
; ═══════════════════════════════════════════════════════════════════════════════
; Group legal services plan

{@legal_services}
plan_id = !:                                ; Plan ID
employer_id = !:                            ; Employer
plan_name = !:                              ; Plan name

; Plan type
{.plan}
plan_type = !(comprehensive, limited, prepaid)
network_only = ?                            ; Network attorneys only
out_of_network_reimbursement = ?            ; OON reimbursement
portability = ?                             ; Portable

{@legal_services}

; Provider
{.provider}
provider_name = :                           ; Legal plan provider
administrator = :                           ; Plan administrator

{@legal_services}

; Covered services - Family law
{.family}
divorce = ?                                 ; Divorce representation
divorce_hours = ##:(0..100)                 ; Hours covered
child_custody = ?                           ; Child custody
child_support = ?                           ; Child support
adoption = ?                                ; Adoption
prenuptial = ?                              ; Prenuptial agreements
name_change = ?                             ; Name change

{@legal_services}

; Estate planning
{.estate}
wills = ?                                   ; Will preparation
will_updates = ?                            ; Will updates
trusts = ?                                  ; Trust preparation
power_of_attorney = ?                       ; Power of attorney
healthcare_directive = ?                    ; Healthcare directive
probate = ?                                 ; Probate assistance

{@legal_services}

; Real estate
{.real_estate}
home_purchase_sale = ?                      ; Home purchase/sale
home_refinance = ?                          ; Refinance
home_equity = ?                             ; Home equity loan
landlord_tenant = ?                         ; Landlord/tenant issues
property_boundary = ?                       ; Boundary disputes
zoning = ?                                  ; Zoning matters

{@legal_services}

; Consumer
{.consumer}
consumer_protection = ?                     ; Consumer protection
identity_theft = ?                          ; Identity theft
debt_collection = ?                         ; Debt collection defense
bankruptcy_advice = ?                       ; Bankruptcy consultation
warranty_disputes = ?                       ; Warranty disputes
small_claims = ?                            ; Small claims assistance

{@legal_services}

; Traffic
{.traffic}
traffic_violations = ?                      ; Traffic violations
moving_violations = ?                       ; Moving violations
dui_defense = ?                             ; DUI defense
license_restoration = ?                     ; License restoration

{@legal_services}

; Civil matters
{.civil}
civil_litigation = ?                        ; Civil litigation
civil_hours = ##:(0..100)                   ; Hours covered
demand_letters = ?                          ; Demand letters
contract_review = ?                         ; Contract review
immigration = ?                             ; Immigration matters
tax_audit = ?                               ; IRS audit assistance

{@legal_services}

; Advice and consultation
{.consultation}
unlimited_phone = ?                         ; Unlimited phone advice
office_consultation = ?                     ; Office consultations
document_review = ?                         ; Document review
letter_writing = ?                          ; Letter writing

{@legal_services}

; ═══════════════════════════════════════════════════════════════════════════════
; IDENTITY THEFT PROTECTION
; ═══════════════════════════════════════════════════════════════════════════════

{@identity_theft}
plan_id = !:                                ; Plan ID
employer_id = !:                            ; Employer
plan_name = !:                              ; Plan name

; Plan type
{.plan}
coverage_type = !(employee_only, employee_family)
expense_reimbursement_limit = #$:(0..)      ; Expense reimbursement max
portability = ?                             ; Portable

{@identity_theft}

; Provider
{.provider}
provider_name = :                           ; Service provider
administrator = :                           ; Administrator

{@identity_theft}

; Monitoring services
{.monitoring}
credit_monitoring = ?                       ; Credit monitoring
credit_bureaus_monitored = ##:(1..3)        ; Number of bureaus
dark_web_monitoring = ?                     ; Dark web monitoring
social_media_monitoring = ?                 ; Social media monitoring
ssn_monitoring = ?                          ; SSN monitoring
bank_account_monitoring = ?                 ; Bank account monitoring
investment_account_monitoring = ?           ; Investment account monitoring
credit_card_monitoring = ?                  ; Credit card monitoring
payday_loan_monitoring = ?                  ; Payday loan monitoring
public_records_monitoring = ?               ; Public records monitoring
sex_offender_registry = ?                   ; Sex offender registry monitoring

{@identity_theft}

; Alerts
{.alerts}
credit_alerts = ?                           ; Credit change alerts
fraud_alerts = ?                            ; Fraud alerts
breach_notifications = ?                    ; Data breach notifications
address_change_alerts = ?                   ; Address change alerts

{@identity_theft}

; Credit services
{.credit}
credit_report_access = ?                    ; Credit report access
credit_reports_per_year = ##:(0..12)        ; Reports per year
credit_score_access = ?                     ; Credit score access
credit_score_updates = (annual, daily, monthly, quarterly)
credit_freeze_assistance = ?                ; Credit freeze help

{@identity_theft}

; Resolution services
{.resolution}
dedicated_specialist = ?                    ; Dedicated resolution specialist
full_service_restoration = ?                ; Full-service restoration
limited_power_of_attorney = ?               ; Limited POA for restoration
affidavit_preparation = ?                   ; Affidavit preparation
creditor_notification = ?                   ; Creditor notification
dispute_filing = ?                          ; Dispute filing assistance

{@identity_theft}

; Insurance coverage
{.insurance}
expense_reimbursement = #$:(0..)            ; Lost wages, legal fees, etc.
lost_wages_coverage = #$:(0..)              ; Lost wages coverage
legal_fees_coverage = #$:(0..)              ; Legal fees coverage
stolen_funds_coverage = #$:(0..)            ; Stolen funds reimbursement
cpa_fees_coverage = #$:(0..)                ; CPA fees coverage
child_coverage = ?                          ; Coverage for minor children

{@identity_theft}

; ═══════════════════════════════════════════════════════════════════════════════
; PET INSURANCE BENEFIT
; ═══════════════════════════════════════════════════════════════════════════════
; Pet insurance offered as employee benefit
; References @pet and @pet_policy from personal lines pet insurance schema

{@pet_benefit}
plan_id = !:                                ; Plan ID
employer_id = !:                            ; Employer
plan_name = !:                              ; Plan name

; Plan structure
{.plan}
voluntary = ?true                           ; Voluntary benefit
employer_sponsored = ?                      ; Employer sponsors plan
payroll_deduction = ?                       ; Payroll deduction available
group_discount_percent = #:(0..30)          ; Group discount percentage

{@pet_benefit}

; Provider
{.provider}
carrier_name = :                            ; Pet insurance carrier
administrator = :                           ; Administrator

{@pet_benefit}

; Plan options available - References @pet_policy types
{.options}
accident_only_available = ?                 ; Accident-only option
accident_illness_available = ?              ; Accident + illness option
wellness_available = ?                      ; Wellness add-on
comprehensive_available = ?                 ; Comprehensive option

{@pet_benefit}

; Eligibility
{.eligibility}
eligible_species[] = :                      ; Eligible pet species
age_restrictions = :                        ; Age restrictions
pre_existing_exclusions = ?                 ; Pre-existing exclusions

{@pet_benefit}

; Coverage limits available
{.limits}
annual_limit_options[] = #$:(0..)           ; Annual limit options
deductible_options[] = #$:(0..)             ; Deductible options
reimbursement_options[] = ##:(50..100)      ; Reimbursement % options

{@pet_benefit}

; Enrollment
{.enrollment}
open_enrollment = ?                         ; Open enrollment available
new_hire_enrollment = ?                     ; New hire enrollment
qle_enrollment = ?                          ; QLE enrollment

{@pet_benefit}

; ═══════════════════════════════════════════════════════════════════════════════
; VOLUNTARY ENROLLMENT
; ═══════════════════════════════════════════════════════════════════════════════

{@voluntary_enrollment}
enrollment_id = !:                          ; Enrollment ID
employee_id = !:                            ; Employee
plan_id = !:                                ; Plan ID
benefit_type = !(accident, cancer, critical_illness, hospital_indemnity, identity_theft, legal_services, pet)

; Coverage elected
{.coverage}
coverage_level = !(employee_only, employee_child, employee_family, employee_spouse)
benefit_amount = #$:(0..)                   ; Benefit amount (if applicable)
effective_date = !date                      ; Effective date
termination_date = date                     ; Termination date

{@voluntary_enrollment}

; Dependents covered
{.dependents}
spouse_covered = ?                          ; Spouse covered
spouse_benefit_amount = #$:(0..)            ; Spouse benefit
children_covered = ?                        ; Children covered
child_benefit_amount = #$:(0..)             ; Child benefit
dependents[] = :                            ; Covered dependent IDs

{@voluntary_enrollment}

; Premium
{.premium}
monthly_premium = #$:(0..)                  ; Monthly premium
employee_paid = #$:(0..)                    ; Employee pays
employer_contribution = #$:(0..)            ; Employer contribution (if any)
pre_tax = ?                                 ; Section 125 pre-tax
deduction_frequency = (biweekly, monthly, semi_monthly, weekly)

{@voluntary_enrollment}

; Underwriting
{.underwriting}
guaranteed_issue = ?                        ; Guaranteed issue
eoi_required = ?                            ; EOI required
eoi_status = (approved, declined, pending)
eoi_approved_amount = #$:(0..)              ; Approved amount

{@voluntary_enrollment}

; Status
status = !(active, declined, pending, terminated)

; ═══════════════════════════════════════════════════════════════════════════════
; VOLUNTARY CLAIM
; ═══════════════════════════════════════════════════════════════════════════════

{@voluntary_claim}
claim_id = !:                               ; Claim ID
enrollment_id = !:                          ; Enrollment ID
employee_id = !:                            ; Employee
benefit_type = !(accident, cancer, critical_illness, hospital_indemnity, pet)

; Claim details
{.details}
incident_date = !date                       ; Date of incident/diagnosis
claim_filed_date = date                     ; Claim filed date
claim_description = :                       ; Description

{@voluntary_claim}

; Benefit triggered
{.benefit}
benefit_category = :                        ; Benefit category triggered
benefit_subcategory = :                     ; Specific benefit
scheduled_benefit = #$:(0..)                ; Scheduled benefit amount
days_claimed = ##:(0..)                     ; Days (if daily benefit)

{@voluntary_claim}

; Provider (if applicable)
{.provider}
provider_name = :                           ; Provider name
provider_npi = :                            ; NPI (if healthcare)
provider_type = :                           ; Provider type

{@voluntary_claim}

; Documentation
{.documentation}
claim_form_received = ?                     ; Claim form received
medical_records_required = ?                ; Medical records required
medical_records_received = ?                ; Medical records received
attending_physician_statement = ?           ; APS required
additional_documentation = :                ; Additional docs needed

{@voluntary_claim}

; Benefit calculation
{.calculation}
gross_benefit = #$:(0..)                    ; Gross benefit payable
prior_benefits_paid = #$:(0..)              ; Prior benefits (same condition)
remaining_benefit = #$:(0..)                ; Remaining benefit available
net_benefit = #$:(0..)                      ; Net benefit payable

{@voluntary_claim}

; Payment
{.payment}
payment_amount = #$:(0..)                   ; Payment amount
payment_date = date                         ; Payment date
payment_method = (check, direct_deposit)
payee = :                                   ; Payee name

{@voluntary_claim}

; Status
{.status}
status = !(approved, denied, paid, pending)
denial_reason = :                           ; Denial reason (if denied)

{@voluntary_claim}



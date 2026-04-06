; ===================================================================================
; ODIN Vision Benefits Schema
; ===================================================================================
; Vision benefit management covering plans, exam/materials/contact lens benefits,
; frequency limits, allowances, provider networks, and medical vision coverage.
; Supports vision HMO, PPO, indemnity, and discount plans for both standalone
; and embedded vision arrangements.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.vision"
version = "1.0.0"
title = "Vision Benefits Schema"
description = "Vision benefit management including plans, benefits, frequency, allowances, providers, and medical vision"

{$derivation}
source[0].authority = "American Optometric Association"
source[0].citation = "Evidence-Based Clinical Practice Guidelines"
source[0].url = "https://www.aoa.org/practice/clinical-guidelines"

source[1].authority = "CMS"
source[1].citation = "Medicare Vision Services Coverage"
source[1].url = "https://www.cms.gov/medicare-coverage-database"

source[2].authority = "NAIC"
source[2].citation = "Vision Care Plan Disclosure Model Regulation"
source[2].url = "https://content.naic.org/"

source[3].authority = "State Optometry Boards"
source[3].citation = "State Optometry Practice Acts"
source[3].url = "https://www.arbo.org/state-boards"

source[4].authority = "American Academy of Ophthalmology"
source[4].citation = "Preferred Practice Patterns"
source[4].url = "https://www.aao.org/preferred-practice-pattern"

source[5].authority = "GPO"
source[5].citation = "42 CFR 440.120 - Clinic Services (Medicaid Vision)"
source[5].url = "https://www.ecfr.gov/current/title-42/chapter-IV/subchapter-C/part-440"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on AOA guidelines, state optometry regulations, and CMS vision coverage"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial vision benefits schema"
changelog[0].rationale = "Comprehensive vision benefit coverage for all plan types"

; ===================================================================================
; VISION PLAN - Plan Structure and Design
; ===================================================================================
; Per NAIC model regulations and industry standards

{@vision_plan}
; Required fields first
plan_id = !:                                 ; Plan identifier
plan_name = !:                               ; Plan name
effective_date = !date                       ; Plan effective date
expiration_date = !date                      ; Plan expiration date

; Invariants
:invariant expiration_date > effective_date

; Plan type
plan_type = !(discount, hmo, indemnity, ppo)
funding_type = (fully_insured, level_funded, self_funded)
payer_type = (commercial, exchange, medicaid, medicare_advantage, self_funded)
standalone = ?                               ; Standalone vs. embedded

; Sponsor information
{.sponsor}
sponsor_name = :                             ; Plan sponsor
group_number = :                             ; Group number
situs_state = :(2)                           ; Situs state

{@vision_plan}

; ---------------------------------------------------------------------------
; Premium and Contribution
; ---------------------------------------------------------------------------
{.premium}
monthly_employee = #$:(0..)                  ; Employee monthly premium
monthly_ee_spouse = #$:(0..)                 ; Employee + spouse
monthly_ee_child = #$:(0..)                  ; Employee + child(ren)
monthly_family = #$:(0..)                    ; Family
annual_employee = #$:(0..)                   ; Employee annual
employer_contribution = #:(0..100)           ; Employer contribution %

{@vision_plan}

; ---------------------------------------------------------------------------
; Benefit Period
; ---------------------------------------------------------------------------
{.benefit_period}
period_type = !(benefit_year, calendar_year, rolling_12_month)
start_month = ##:(1..12):if period_type = benefit_year
benefit_frequency = (every_12_months, every_24_months, once_per_year)

{@vision_plan}

; ---------------------------------------------------------------------------
; Network Information
; ---------------------------------------------------------------------------
{.network}
network_name = :                             ; Network name
in_network_required = ?                      ; In-network only (HMO)
provider_count = ##:(0..)                    ; Network provider count
retail_locations = ##:(0..)                  ; Retail locations
independent_locations = ##:(0..)             ; Independent locations
states_covered[] = :(2)                      ; States with coverage
national_network = ?                         ; National network

{@vision_plan}

; ---------------------------------------------------------------------------
; Eligibility
; ---------------------------------------------------------------------------
{.eligibility}
dependent_age_limit = ##:(19..26)            ; Dependent age limit
student_age_limit = ##:(23..26)              ; Full-time student limit
disabled_dependent = ?                       ; Disabled dependent coverage
domestic_partner = ?                         ; Domestic partner coverage
waiting_period_days = ##:(0..90)             ; Eligibility waiting period

{@vision_plan}

; ---------------------------------------------------------------------------
; Plan Design
; ---------------------------------------------------------------------------
{.design}
exam_only_option = ?                         ; Exam-only plan option
materials_only_option = ?                    ; Materials-only option
contact_lens_fit_included = ?                ; CL fit in exam benefit
elective_contacts = ?                        ; Elective contacts covered
medically_necessary_contacts = ?             ; Medically necessary CL
laser_vision_discount = ?                    ; LASIK/PRK discount
additional_pairs_discount = ?                ; Additional pairs discount

{@vision_plan}

; ===================================================================================
; VISION BENEFIT - Coverage Details
; ===================================================================================
; Per industry benefit classification standards

{@vision_benefit}
; Required fields first
plan_id = !:                                 ; Plan identifier
benefit_type = !(comprehensive_exam, contact_lens_exam, contact_lens_materials, eyeglass_frames, eyeglass_lenses, laser_vision, lens_enhancements, low_vision)

; ---------------------------------------------------------------------------
; Exam Benefits
; ---------------------------------------------------------------------------
{.exam}
covered = ?:if benefit_type = (comprehensive_exam, contact_lens_exam)
copay_in = #$:(0..):if covered = true        ; In-network copay
copay_out = #$:(0..):if covered = true       ; Out-of-network copay
allowance_out = #$:(0..):if covered = true   ; Out-of-network allowance
dilation_included = ?:if covered = true      ; Dilation included
retinal_imaging = ?:if covered = true        ; Retinal imaging covered
retinal_imaging_copay = #$:(0..):if retinal_imaging = true
contact_fit_separate = ?:if benefit_type = comprehensive_exam

{@vision_benefit}

; ---------------------------------------------------------------------------
; Frame Benefits
; ---------------------------------------------------------------------------
{.frames}
covered = ?:if benefit_type = eyeglass_frames
allowance_in = #$:(0..):if covered = true    ; In-network allowance
allowance_out = #$:(0..):if covered = true   ; Out-of-network allowance
copay = #$:(0..):if covered = true           ; Frame copay
discount_over_allowance = #:(0..50):if covered = true
featured_frame_allowance = #$:(0..):if covered = true
wholesale_pricing = ?:if covered = true      ; Wholesale frame pricing

{@vision_benefit}

; ---------------------------------------------------------------------------
; Lens Benefits
; ---------------------------------------------------------------------------
{.lenses}
covered = ?:if benefit_type = eyeglass_lenses
copay_single = #$:(0..):if covered = true    ; Single vision copay
copay_bifocal = #$:(0..):if covered = true   ; Bifocal copay
copay_trifocal = #$:(0..):if covered = true  ; Trifocal copay
copay_progressive = #$:(0..):if covered = true ; Progressive copay
allowance_out = #$:(0..):if covered = true   ; Out-of-network allowance
polycarbonate_child = ?:if covered = true    ; Free poly for children

{@vision_benefit}

; ---------------------------------------------------------------------------
; Contact Lens Benefits
; ---------------------------------------------------------------------------
{.contacts}
covered = ?:if benefit_type = contact_lens_materials
allowance_in = #$:(0..):if covered = true    ; In-network allowance
allowance_out = #$:(0..):if covered = true   ; Out-of-network allowance
copay = #$:(0..):if covered = true           ; Contact lens copay
conventional_covered = ?:if covered = true   ; Conventional lenses
disposable_covered = ?:if covered = true     ; Disposable lenses
medically_necessary_covered = ?:if covered = true

{@vision_benefit}

; ---------------------------------------------------------------------------
; Lens Enhancement Benefits
; ---------------------------------------------------------------------------
{.enhancements}
covered = ?:if benefit_type = lens_enhancements
anti_reflective = #$:(0..)                   ; Anti-reflective cost
photochromic = #$:(0..)                      ; Photochromic/transitions cost
progressive = #$:(0..)                       ; Progressive upgrade cost
high_index = #$:(0..)                        ; High-index cost
polarized = #$:(0..)                         ; Polarized lenses cost
blue_light = #$:(0..)                        ; Blue light filter cost
scratch_resistant = ?                        ; Scratch coating included
uv_protection = ?                            ; UV protection included

{@vision_benefit}

; ---------------------------------------------------------------------------
; Laser Vision Benefits
; ---------------------------------------------------------------------------
{.laser}
covered = ?:if benefit_type = laser_vision
discount_percent = #:(0..50):if covered = true
allowance = #$:(0..):if covered = true       ; Per-eye allowance
providers[] = ::if covered = true            ; Approved providers/networks
lasik_covered = ?:if covered = true          ; LASIK covered
prk_covered = ?:if covered = true            ; PRK covered

{@vision_benefit}

; ===================================================================================
; VISION FREQUENCY - Service Frequency Limitations
; ===================================================================================
; Per plan design standards

{@vision_frequency}
; Required fields first
plan_id = !:                                 ; Plan identifier
service_type = !(comprehensive_exam, contact_lens_exam, contact_lens_materials, frames, lenses, low_vision_exam)

; Frequency details
{.frequency}
frequency_months = ##:(12..24)               ; Frequency in months
once_per_calendar_year = ?                   ; Once per calendar year
once_per_benefit_year = ?                    ; Once per benefit year
rolling_period = ?                           ; Rolling period from last service

{@vision_frequency}

; ---------------------------------------------------------------------------
; Exceptions
; ---------------------------------------------------------------------------
{.exceptions}
diabetic_exception = ?                       ; More frequent for diabetic
high_risk_exception = ?                      ; High-risk conditions
pediatric_exception = ?                      ; More frequent for children
prescription_change = ?                      ; Rx change exception
prescription_change_diopters = #:(0..2):if prescription_change = true

{@vision_frequency}

; ---------------------------------------------------------------------------
; Combined Benefit Rules
; ---------------------------------------------------------------------------
{.combination}
glasses_or_contacts = ?                      ; Glasses OR contacts (not both)
exam_required_for_materials = ?              ; Exam required for materials
contact_exam_with_comprehensive = ?          ; CL fit with comprehensive

{@vision_frequency}

; ===================================================================================
; VISION ALLOWANCE - Frame, Lens, and Contact Lens Allowances
; ===================================================================================
; Per plan design standards

{@vision_allowance}
; Required fields first
plan_id = !:                                 ; Plan identifier
effective_date = !date                       ; Allowance effective date

; ---------------------------------------------------------------------------
; Frame Allowance
; ---------------------------------------------------------------------------
{.frames}
in_network_base = #$:(0..)                   ; Base in-network allowance
in_network_featured = #$:(0..)               ; Featured frame allowance
out_of_network = #$:(0..)                    ; Out-of-network allowance
discount_over_allowance = #:(0..50)          ; Discount over allowance
wholesale_pricing = ?                        ; Wholesale pricing available
any_frame = ?                                ; Any frame at allowance

{@vision_allowance}

; ---------------------------------------------------------------------------
; Lens Allowance
; ---------------------------------------------------------------------------
{.lenses}
single_vision_in = #$:(0..)                  ; Single vision in-network
bifocal_in = #$:(0..)                        ; Bifocal in-network
trifocal_in = #$:(0..)                       ; Trifocal in-network
progressive_in = #$:(0..)                    ; Progressive in-network
single_vision_out = #$:(0..)                 ; Single vision out-of-network
bifocal_out = #$:(0..)                       ; Bifocal out-of-network
trifocal_out = #$:(0..)                      ; Trifocal out-of-network
progressive_out = #$:(0..)                   ; Progressive out-of-network

{@vision_allowance}

; ---------------------------------------------------------------------------
; Contact Lens Allowance
; ---------------------------------------------------------------------------
{.contacts}
elective_in = #$:(0..)                       ; Elective in-network
elective_out = #$:(0..)                      ; Elective out-of-network
medically_necessary_in = #$:(0..)            ; Med necessary in-network
medically_necessary_out = #$:(0..)           ; Med necessary out-of-network
fit_evaluation_in = #$:(0..)                 ; Fit/evaluation in-network
fit_evaluation_out = #$:(0..)                ; Fit/evaluation out-of-network
in_lieu_of_glasses = ?                       ; Contacts in lieu of glasses

{@vision_allowance}

; ---------------------------------------------------------------------------
; Enhancement Allowances/Discounts
; ---------------------------------------------------------------------------
{.enhancements}
anti_reflective_discount = #:(0..100)        ; AR coating discount
photochromic_discount = #:(0..100)           ; Photochromic discount
progressive_discount = #:(0..100)            ; Progressive discount
high_index_discount = #:(0..100)             ; High-index discount
polycarbonate_child_free = ?                 ; Free poly for children

{@vision_allowance}

; ===================================================================================
; VISION PROVIDER - Provider Network and Credentialing
; ===================================================================================
; Per state optometry board regulations and NCQA standards

{@vision_provider}
; Required fields first
provider_id = !:                             ; Provider identifier
npi = !:/^\d{10}$/                           ; National Provider Identifier
provider_type = !(dispensing_optician, ophthalmologist, optician, optometrist, retail_optical)

; Provider identification
{.identification}
first_name = :                               ; First name
last_name = :                                ; Last name
suffix = :                                   ; Suffix (OD, MD)
dba_name = :                                 ; Doing business as
practice_name = :                            ; Practice name
tax_id = *:                                  ; Tax ID
retail_chain = :                             ; Retail chain name if applicable

{@vision_provider}

; ---------------------------------------------------------------------------
; Licensure - Per state optometry/ophthalmology board
; ---------------------------------------------------------------------------
license = @license_credential                ; License credential
tpa_certified = ?                            ; Therapeutic pharmaceutical agent

; DEA information
{.dea}
dea_number = *:                              ; DEA number (if applicable)
dea_expiration = date                        ; DEA expiration

{@vision_provider}

; ---------------------------------------------------------------------------
; Specialty
; ---------------------------------------------------------------------------
{.specialty}
primary_specialty = (comprehensive_ophthalmology, cornea, general_optometry, glaucoma, neuro_ophthalmology, oculoplastics, pediatric_optometry, pediatric_ophthalmology, retina, vision_therapy)
board_certified = ?                          ; Board certified
board_name = ::if board_certified = true     ; Certifying board
fellowship_trained = ?                       ; Fellowship trained

{@vision_provider}

; ---------------------------------------------------------------------------
; Network Participation
; ---------------------------------------------------------------------------
{.network}
network_ids[] = :                            ; Network memberships
participation_status = (active, inactive, pending, terminated)
effective_date = date                        ; Network effective date
termination_date = date                      ; Termination date
accepting_patients = ?                       ; Accepting new patients
provider_tier = (premier, preferred, standard)

{@vision_provider}

; ---------------------------------------------------------------------------
; Services Offered
; ---------------------------------------------------------------------------
{.services}
comprehensive_exams = ?                      ; Comprehensive exams
contact_lens_fitting = ?                     ; Contact lens services
pediatric = ?                                ; Pediatric services
low_vision = ?                               ; Low vision services
vision_therapy = ?                           ; Vision therapy
medical_eye_care = ?                         ; Medical eye care
optical_dispensing = ?                       ; Optical dispensing
on_site_lab = ?                              ; On-site lab

{@vision_provider}

; ---------------------------------------------------------------------------
; Practice Location
; ---------------------------------------------------------------------------
{.location}
address = @address                           ; Practice address
phone = *@phone                              ; Practice phone
fax = *:                                     ; Practice fax
email = *@email                              ; Practice email
office_hours = :                             ; Office hours
handicap_accessible = ?                      ; ADA accessible
languages[] = :                              ; Languages spoken
saturday_hours = ?                           ; Saturday hours
evening_hours = ?                            ; Evening hours

{@vision_provider}

; ---------------------------------------------------------------------------
; Credentialing - Per NCQA standards
; ---------------------------------------------------------------------------
{.credentialing}
credentialed = ?                             ; Credentialing complete
credential_date = date:if credentialed = true
recredential_due = date                      ; Recredentialing due
malpractice_coverage = ?                     ; Malpractice verified
malpractice_carrier = :                      ; Malpractice carrier
malpractice_amount = #$:(0..)                ; Coverage amount
sanctions_checked = ?                        ; Sanctions verified
background_checked = ?                       ; Background verified

{@vision_provider}

; ===================================================================================
; VISION MEDICAL - Medical Vision vs. Routine Vision
; ===================================================================================
; Per CMS and medical insurance guidelines

{@vision_medical}
; Required fields first
plan_id = !:                                 ; Plan identifier
coverage_type = !(medical, routine, both)

; ---------------------------------------------------------------------------
; Medical Vision Coverage (Typically Medical Insurance)
; ---------------------------------------------------------------------------
{.medical_coverage}
diabetic_retinopathy = ?                     ; Diabetic eye exam covered
glaucoma_screening = ?                       ; Glaucoma screening
macular_degeneration = ?                     ; AMD treatment
cataract_surgery = ?                         ; Cataract surgery
corneal_conditions = ?                       ; Corneal conditions
dry_eye_treatment = ?                        ; Dry eye treatment
eye_infections = ?                           ; Eye infections
eye_injuries = ?                             ; Eye injuries
retinal_conditions = ?                       ; Retinal conditions
conjunctivitis = ?                           ; Pink eye

{@vision_medical}

; ---------------------------------------------------------------------------
; Medical Diagnosis Codes (ICD-10)
; ---------------------------------------------------------------------------
{.diagnosis}
covered_icd10[] = :                          ; Covered ICD-10 codes
diabetes_codes[] = :                         ; Diabetes-related codes
glaucoma_codes[] = :                         ; Glaucoma codes
amd_codes[] = :                              ; AMD codes
cataract_codes[] = :                         ; Cataract codes

{@vision_medical}

; ---------------------------------------------------------------------------
; Medical vs. Routine Determination
; ---------------------------------------------------------------------------
{.determination}
refraction_with_medical = ?                  ; Refraction with medical exam
refraction_separate_charge = #$:(0..)        ; Separate refraction charge
medical_copay = #$:(0..)                     ; Medical visit copay
medical_deductible = ?                       ; Medical deductible applies
specialty_referral = ?                       ; Specialist referral required
primary_care_referral = ?                    ; PCP referral required

{@vision_medical}

; ---------------------------------------------------------------------------
; Medicare Vision Coverage
; ---------------------------------------------------------------------------
{.medicare}
part_b_covered = ?                           ; Medicare Part B covered
amd_screening = ?                            ; AMD screening covered
diabetic_exam = ?                            ; Diabetic eye exam covered
glaucoma_test = ?                            ; Glaucoma test covered
cataract_post_surgical = ?                   ; Post-cataract coverage
routine_excluded = ?                         ; Routine exams excluded

{@vision_medical}

; ---------------------------------------------------------------------------
; Medicaid Vision Coverage
; ---------------------------------------------------------------------------
{.medicaid}
epsdt_covered = ?                            ; EPSDT vision covered
adult_covered = ?                            ; Adult vision covered
exam_frequency = :                           ; Exam frequency
materials_covered = ?                        ; Materials covered
materials_frequency = :                      ; Materials frequency

{@vision_medical}

; ===================================================================================
; VISION CLAIM
; ===================================================================================
; Per HIPAA 837P and industry standards

{@vision_claim}
; Required fields first
claim_id = !:                                ; Claim identifier
service_date = !date                         ; Date of service
member_id = !*:                              ; Member identifier
provider_npi = !:/^\d{10}$/                  ; Rendering provider NPI

; Patient information
{.patient}
patient_name = :                             ; Patient name
relationship = (child, other, self, spouse)  ; Relationship to subscriber
date_of_birth = *date                        ; Patient DOB

{@vision_claim}

; Service information
{.service}
service_type = (contact_lens_exam, contact_lens_materials, comprehensive_exam, frames, lenses, lens_enhancements, medical_exam)
cpt_code = :                                 ; CPT code for medical
hcpcs_code = :                               ; HCPCS code
description = :                              ; Service description
quantity = ##:(1..10)                        ; Quantity
left_eye = ?                                 ; Left eye (OS)
right_eye = ?                                ; Right eye (OD)
both_eyes = ?                                ; Both eyes (OU)

{@vision_claim}

; Prescription information
{.prescription}
sphere_od = #:(-20..20)                      ; Sphere OD
sphere_os = #:(-20..20)                      ; Sphere OS
cylinder_od = #:(-10..10)                    ; Cylinder OD
cylinder_os = #:(-10..10)                    ; Cylinder OS
axis_od = ##:(1..180)                        ; Axis OD
axis_os = ##:(1..180)                        ; Axis OS
add_power = #:(0..4)                         ; Add power
prism_od = #:(0..10)                         ; Prism OD
prism_os = #:(0..10)                         ; Prism OS
pupillary_distance = ##:(40..80)             ; PD

{@vision_claim}

; Provider information
{.provider}
rendering_npi = :/^\d{10}$/                  ; Rendering provider
billing_npi = :/^\d{10}$/                    ; Billing provider
provider_name = :                            ; Provider name
location_type = (independent, retail)        ; Location type

{@vision_claim}

; Charges and payment
{.charges}
billed_amount = #$:(0..)                     ; Billed amount
allowed_amount = #$:(0..)                    ; Allowed amount
member_cost = #$:(0..)                       ; Member cost share
copay = #$:(0..)                             ; Copay amount
allowance_applied = #$:(0..)                 ; Allowance applied
over_allowance = #$:(0..)                    ; Amount over allowance
plan_paid = #$:(0..)                         ; Plan payment
patient_responsibility = #$:(0..)            ; Patient responsibility
cob_amount = #$:(0..)                        ; COB adjustment

{@vision_claim}

; Adjudication
{.adjudication}
status = (denied, paid, pended, pending, rejected)
process_date = date                          ; Process date
denial_reason = :                            ; Denial reason code
denial_description = :                       ; Denial description
frequency_denial = ?                         ; Frequency limitation
waiting_period_denial = ?                    ; Waiting period denial
not_covered_denial = ?                       ; Not covered denial
out_of_network_denial = ?                    ; Out-of-network denial

{@vision_claim}


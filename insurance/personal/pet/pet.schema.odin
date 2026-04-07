; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Pet Insurance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Pet insurance covering accident and illness, accident-only, and wellness plans
; for dogs and cats with veterinary exam, diagnostic, surgery, medication,
; and alternative therapy benefits.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as types
@import "../../common/party.schema.odin" as party
@import "../../coverages/coverage.schema.odin" as cov

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.pet"
version = "1.0.0"
title = "Pet Insurance Schema"
description = "Comprehensive pet health insurance for dogs, cats, and exotic pets"

{$derivation}
source[0].authority = "North American Pet Health Insurance Association (NAPHIA)"
source[0].citation = "NAPHIA State of the Industry Report - Public Statistics"
source[0].url = "https://naphia.org/"

source[1].authority = "National Association of Insurance Commissioners (NAIC)"
source[1].citation = "Pet Insurance Model Act"
source[1].url = "https://content.naic.org/insurance-topics/pet-insurance"

source[2].authority = "State Insurance Departments"
source[2].citation = "Various state pet insurance regulations and consumer disclosures"
source[2].url = "https://content.naic.org/state-insurance-departments"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Pet insurance schema derived from NAIC model law and NAPHIA public industry standards"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial pet insurance schema"
changelog[0].rationale = "Complete pet health insurance coverage for personal lines"

; ═══════════════════════════════════════════════════════════════════════════════
; Pet (The Insured Animal)
; ═══════════════════════════════════════════════════════════════════════════════

{@pet}
id = :                                         ; Unique pet identifier
name = !:                                      ; Pet's name

; ───────────────────────────────────────────────────────────────────────────────
; Species Classification
; ───────────────────────────────────────────────────────────────────────────────
species = (bird_canary, bird_cockatiel, bird_cockatoo, bird_finch, bird_macaw, bird_other, bird_parakeet, bird_parrot, cat, chinchilla, dog, ferret, gerbil, guinea_pig, hamster, hedgehog, lizard_bearded_dragon, lizard_chameleon, lizard_gecko, lizard_iguana, lizard_other, mouse, other_exotic, rabbit, rat, snake, sugar_glider, tortoise, turtle)

exotic = ?                                     ; True if not dog or cat

; ───────────────────────────────────────────────────────────────────────────────
; Breed Information
; ───────────────────────────────────────────────────────────────────────────────
breed = :                                    ; Primary breed
breed_secondary = :                          ; Secondary breed for mixed breeds
mixed_breed = ?                              ; Mixed breed indicator
purebred = ?                                 ; Purebred indicator
breed_registry = :                           ; Registry (AKC, CFA, etc.)
registration_number = :                      ; Registry registration number

breed_size_category = (giant, large, medium, small, toy):if species = dog  ; Dog size category
brachycephalic = ?                           ; Flat-faced breed (breathing concerns)
high_risk_breed = ?                          ; High risk breed for underwriting

; ───────────────────────────────────────────────────────────────────────────────
; Physical Characteristics
; ───────────────────────────────────────────────────────────────────────────────
date_of_birth = *date
approximate_age = ?                               ; If DOB unknown
age_years = ##                                    ; Age in years (species-dependent)
age_months = ##:(0..11)
sex = (female, male, unknown)
altered = ?                                       ; Spayed/neutered
altered_date = date:if altered = true
weight_lbs = #:(0..500)
weight_kg = #:(0..225)
color = :                                        ; Primary coat color
markings = :                                     ; Distinctive markings

; ───────────────────────────────────────────────────────────────────────────────
; Identification
; ───────────────────────────────────────────────────────────────────────────────
microchip = ?                                    ; Microchipped
microchip_number = ::if microchip = true         ; Microchip ID number
microchip_registry = ::if microchip = true       ; Microchip registry
tattoo = :                                       ; Tattoo identification
collar_tag = :                                   ; Collar tag number

; ───────────────────────────────────────────────────────────────────────────────
; Acquisition
; ───────────────────────────────────────────────────────────────────────────────
acquisition_date = date                          ; Date pet was acquired
acquisition_source = (breeder, gift, other, pet_store, private_party, shelter_rescue, stray)  ; Source of acquisition
breeder_name = ::if acquisition_source = breeder      ; Breeder name
breeder_registration = ::if acquisition_source = breeder  ; Breeder registration
purchase_price = #$:(0..)                        ; Purchase price
adoption_fee = #$:(0..):if acquisition_source = shelter_rescue  ; Adoption fee

; ───────────────────────────────────────────────────────────────────────────────
; Living Situation
; ───────────────────────────────────────────────────────────────────────────────
residence_type = (apartment, condo, farm, house, other)  ; Residence type
indoor_only = ?                                  ; Lives indoors only
indoor_outdoor = ?                               ; Lives indoors and outdoors
outdoor_only = ?                                 ; Lives outdoors only
yard = ?                                         ; Has yard access
fence_type = (full, invisible, none, partial):if yard = true  ; Fence type
other_pets_in_home = ?                           ; Other pets in household
other_pet_count = ##:(0..):if other_pets_in_home = true  ; Number of other pets

; ───────────────────────────────────────────────────────────────────────────────
; Special Uses (affects coverage)
; ───────────────────────────────────────────────────────────────────────────────
pet_use = (breeding, companion, other, service, show, therapy, working)  ; Primary use
breeding_animal = ?:if pet_use = breeding        ; Used for breeding
show_animal = ?:if pet_use = show                ; Show animal
working_animal = ?:if pet_use = working          ; Working animal
working_type = (detection, guard, herding, hunting, other, search_rescue):if working_animal = true  ; Type of work
service_animal = ?:if pet_use = service          ; Service animal
therapy_animal = ?:if pet_use = therapy          ; Therapy animal

; ═══════════════════════════════════════════════════════════════════════════════
; Pet Medical History
; ═══════════════════════════════════════════════════════════════════════════════

{@pet_medical_history}
pet_ref = :                                       ; Reference to @pet.id
history_date = date                               ; Date of medical history record

; ───────────────────────────────────────────────────────────────────────────────
; Vaccination Records
; ───────────────────────────────────────────────────────────────────────────────
{.vaccinations}
rabies_current = ?                                ; Rabies vaccine current
rabies_date = date                                ; Rabies vaccine date
rabies_expiration = date                          ; Rabies vaccine expiration
dhpp_current = ?                                  ; Distemper, Hepatitis, Parvovirus, Parainfluenza (dogs)
dhpp_date = date                                  ; DHPP vaccine date
fvrcp_current = ?                                 ; Feline viral rhinotracheitis, calicivirus, panleukopenia (cats)
fvrcp_date = date                                 ; FVRCP vaccine date
bordetella_current = ?                            ; Kennel cough vaccine current
bordetella_date = date                            ; Bordetella vaccine date
lyme_current = ?                                  ; Lyme vaccine current
lyme_date = date                                  ; Lyme vaccine date
leptospirosis_current = ?                         ; Leptospirosis vaccine current
leptospirosis_date = date                         ; Leptospirosis vaccine date
felv_current = ?                                  ; Feline leukemia vaccine current (cats)
felv_date = date                                  ; FeLV vaccine date
fiv_tested = ?                                    ; Feline immunodeficiency virus tested (cats)
fiv_test_date = date                              ; FIV test date
fiv_positive = ?:if fiv_tested = true             ; FIV positive result

{@pet_medical_history}

; ───────────────────────────────────────────────────────────────────────────────
; Current Health Status
; ───────────────────────────────────────────────────────────────────────────────
overall_health = (excellent, fair, good, poor)    ; Overall health status
last_wellness_exam = date                         ; Last wellness exam date
current_weight_lbs = #:(0..500)                   ; Current weight in pounds
body_condition_score = ##:(1..9)                  ; 1-9 scale, 4-5 ideal

; ───────────────────────────────────────────────────────────────────────────────
; Current Medications
; ───────────────────────────────────────────────────────────────────────────────
on_medications = ?                                ; Currently on medications
heartworm_prevention = ?                          ; On heartworm prevention
flea_tick_prevention = ?                          ; On flea/tick prevention

; ───────────────────────────────────────────────────────────────────────────────
; Spay/Neuter
; ───────────────────────────────────────────────────────────────────────────────
spayed_neutered = ?                               ; Spayed or neutered
spay_neuter_date = date:if spayed_neutered = true  ; Date of spay/neuter
spay_neuter_complications = ?:if spayed_neutered = true  ; Complications from procedure

; ═══════════════════════════════════════════════════════════════════════════════
; Pre-Existing Conditions
; ═══════════════════════════════════════════════════════════════════════════════
; Conditions present before coverage starts or during waiting periods.

{@pet_medical_history.pre_existing_conditions[]}
condition_name = :                                ; Name of condition
condition_code = :                                ; Veterinary diagnosis code
condition_type = (accident_injury, acute_illness, behavioral, chronic_illness, congenital, dental, hereditary, other)  ; Type of condition

; ───────────────────────────────────────────────────────────────────────────────
; Pre-Existing Classification
; ───────────────────────────────────────────────────────────────────────────────
curability = (curable, incurable, unknown)        ; Curability classification
symptom_free_period_days = ##:(0..)               ; Days without symptoms
eligible_for_reconsideration = ?:if curability = curable  ; Eligible for coverage reconsideration

; ───────────────────────────────────────────────────────────────────────────────
; Condition Details
; ───────────────────────────────────────────────────────────────────────────────
date_first_symptoms = date                        ; First symptoms observed
date_diagnosed = date                             ; Date diagnosed
date_last_treatment = date                        ; Last treatment date
date_last_symptoms = date                         ; Last symptoms observed
currently_symptomatic = ?                         ; Currently showing symptoms
currently_on_treatment = ?                        ; Currently receiving treatment

; ───────────────────────────────────────────────────────────────────────────────
; Bilateral Condition Flag
; ───────────────────────────────────────────────────────────────────────────────
bilateral_condition = ?                           ; Affects paired body parts
affected_side = (both, left, right):if bilateral_condition = true  ; Side affected
bilateral_clause_applies = ?:if bilateral_condition = true  ; Bilateral exclusion applies

; ───────────────────────────────────────────────────────────────────────────────
; Documentation
; ───────────────────────────────────────────────────────────────────────────────
documented_in_medical_records = ?                 ; Documented in records
veterinarian_attestation = ?                      ; Vet attestation obtained
records_reviewed_date = date                      ; Records review date

{@pet_medical_history}

; ───────────────────────────────────────────────────────────────────────────────
; Prior Surgeries
; ───────────────────────────────────────────────────────────────────────────────
{@pet_medical_history.surgeries[]}
procedure = :                                     ; Procedure name
procedure_date = date                             ; Date of procedure
reason = :                                        ; Reason for surgery
complications = ?                                 ; Complications occurred
complication_details = ::if complications = true  ; Complication details
recovery_complete = ?                             ; Recovery complete

{@pet_medical_history}

; ───────────────────────────────────────────────────────────────────────────────
; Chronic Conditions
; ───────────────────────────────────────────────────────────────────────────────
{@pet_medical_history.chronic_conditions[]}
condition = :                                     ; Condition name
date_diagnosed = date                             ; Date diagnosed
currently_managed = ?                             ; Currently managed
management_type = (diet, medication, monitoring, other, surgery, therapy)  ; Management approach
management_details = :                            ; Management details

{@pet_medical_history}

; ───────────────────────────────────────────────────────────────────────────────
; Hereditary/Congenital Concerns
; ───────────────────────────────────────────────────────────────────────────────
{.hereditary}
hip_dysplasia_diagnosed = ?                       ; Hip dysplasia diagnosed
hip_dysplasia_date = date:if hip_dysplasia_diagnosed = true  ; Diagnosis date
elbow_dysplasia_diagnosed = ?                     ; Elbow dysplasia diagnosed
elbow_dysplasia_date = date:if elbow_dysplasia_diagnosed = true  ; Diagnosis date
luxating_patella_diagnosed = ?                    ; Luxating patella diagnosed
luxating_patella_date = date:if luxating_patella_diagnosed = true  ; Diagnosis date
heart_condition_diagnosed = ?                     ; Heart condition diagnosed
heart_condition_type = ::if heart_condition_diagnosed = true  ; Type of heart condition
heart_condition_date = date:if heart_condition_diagnosed = true  ; Diagnosis date
eye_condition_diagnosed = ?                       ; Eye condition diagnosed
eye_condition_type = ::if eye_condition_diagnosed = true  ; Type of eye condition
eye_condition_date = date:if eye_condition_diagnosed = true  ; Diagnosis date
intervertebral_disc_disease = ?                   ; IVDD - common in dachshunds, etc.
ivdd_date = date:if intervertebral_disc_disease = true  ; IVDD diagnosis date
brachycephalic_syndrome = ?                       ; Breathing issues in flat-faced breeds
brachycephalic_date = date:if brachycephalic_syndrome = true  ; Diagnosis date

{@pet_medical_history}

; ═══════════════════════════════════════════════════════════════════════════════
; Veterinary Provider
; ═══════════════════════════════════════════════════════════════════════════════

{@vet_provider}
id = :                                            ; Unique provider identifier
practice_name = !:                                ; Legal practice name
dba_name = :                                      ; Doing business as name

; ───────────────────────────────────────────────────────────────────────────────
; Practice Type
; ───────────────────────────────────────────────────────────────────────────────
practice_type = (emergency_hospital, exotic_specialist, general_practice, low_cost_clinic, mobile_vet, other, shelter_clinic, specialty_hospital, university_hospital)  ; Type of practice

; Specialties (if applicable)
specialties[] = (
    avian_exotic,
    behavior,
    cardiology,
    dentistry,
    dermatology,
    emergency_critical_care,
    internal_medicine,
    neurology,
    oncology,
    ophthalmology,
    orthopedics,
    other,
    radiology,
    rehabilitation,
    surgery
)

; ───────────────────────────────────────────────────────────────────────────────
; Location
; ───────────────────────────────────────────────────────────────────────────────
address = @address                                ; Practice address

{.hours}
monday = :                                        ; Monday hours
tuesday = :                                       ; Tuesday hours
wednesday = :                                     ; Wednesday hours
thursday = :                                      ; Thursday hours
friday = :                                        ; Friday hours
saturday = :                                      ; Saturday hours
sunday = :                                        ; Sunday hours
emergency_24hr = ?                                ; 24-hour emergency service

{@vet_provider}

; ───────────────────────────────────────────────────────────────────────────────
; Contact
; ───────────────────────────────────────────────────────────────────────────────
phone = *@phone                                   ; Practice phone (confidential)
fax = *@phone                                     ; Practice fax (confidential)
email = *@email                                   ; Practice email (confidential)
website = :                                       ; Practice website

; ───────────────────────────────────────────────────────────────────────────────
; Network Status
; ───────────────────────────────────────────────────────────────────────────────
in_network = ?                                    ; In-network provider
network_discount_percent = #:(0..100):if in_network = true  ; Network discount percentage
direct_pay_available = ?                          ; Pays provider directly vs reimbursement
accreditation = (aaha, none, other)               ; AAHA accreditation

; ───────────────────────────────────────────────────────────────────────────────
; Attending Veterinarian
; ───────────────────────────────────────────────────────────────────────────────
{@vet_provider.veterinarians[]}
veterinarian_name = :                             ; Veterinarian name
license_number = *:                               ; License number (confidential)
license_state_province = :(2)                     ; License state/province

specialty_board_certified = ?                     ; Board certified specialist
specialty = ::if specialty_board_certified = true  ; Board specialty

{@vet_provider}

; ═══════════════════════════════════════════════════════════════════════════════
; Waiting Periods
; ═══════════════════════════════════════════════════════════════════════════════

{@pet_waiting_period}
coverage_type = (accident, behavioral, cruciate, hereditary, illness, orthopedic, wellness)
waiting_period_days = ##:(0..365)
; Waiver options
waived = ?
waived_reason = (exam, prior_coverage, promotional):if waived = true
waived_date = date:if waived = true

; ═══════════════════════════════════════════════════════════════════════════════
; Reimbursement Model
; ═══════════════════════════════════════════════════════════════════════════════

{@pet_reimbursement}
model = (actual_cost_percentage, benefit_schedule)

; ───────────────────────────────────────────────────────────────────────────────
; Actual Cost Percentage Model
; ───────────────────────────────────────────────────────────────────────────────
reimbursement_percent = ##:(50, 60, 70, 80, 90, 100):if model = actual_cost_percentage
reimburse_before_deductible = ?:if model = actual_cost_percentage
reimburse_after_deductible = ?:if model = actual_cost_percentage

; ───────────────────────────────────────────────────────────────────────────────
; Benefit Schedule Model
; ───────────────────────────────────────────────────────────────────────────────
benefit_schedule_version = ::if model = benefit_schedule

; ═══════════════════════════════════════════════════════════════════════════════
; Pet Deductible
; ═══════════════════════════════════════════════════════════════════════════════

{@pet_deductible}
deductible_type = (annual, lifetime, per_condition, per_incident)
amount = #$:(0..)

applies_to_accident = ?
applies_to_illness = ?
applies_to_wellness = ?                           ; Wellness deductible applicability

; Deductible reductions
decreasing_deductible = ?                         ; Decreases for claim-free years
decrease_amount = #$:(0..):if decreasing_deductible = true
decrease_per_year = ?:if decreasing_deductible = true

; ═══════════════════════════════════════════════════════════════════════════════
; Coverage Limits
; ═══════════════════════════════════════════════════════════════════════════════

{@pet_limits}
; ───────────────────────────────────────────────────────────────────────────────
; Annual Limit
; ───────────────────────────────────────────────────────────────────────────────
annual_limit = #$:(0..)
annual_limit_unlimited = ?

; ───────────────────────────────────────────────────────────────────────────────
; Lifetime Limit
; ───────────────────────────────────────────────────────────────────────────────
lifetime_limit = #$:(0..)
lifetime_limit_unlimited = ?

; ───────────────────────────────────────────────────────────────────────────────
; Per-Condition Limits
; ───────────────────────────────────────────────────────────────────────────────
per_condition_limit = #$:(0..)
per_condition_annual = ?                          ; Resets annually
per_condition_lifetime = ?                        ; Never resets

; ───────────────────────────────────────────────────────────────────────────────
; Per-Incident Limits
; ───────────────────────────────────────────────────────────────────────────────
per_incident_limit = #$:(0..)

; ═══════════════════════════════════════════════════════════════════════════════
; Pet Accident Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@pet_accident_coverage}
= @coverage                                       ; Inherit universal coverage

; ───────────────────────────────────────────────────────────────────────────────
; Covered Accidents
; ───────────────────────────────────────────────────────────────────────────────
{.covered}
broken_bones = ?
bite_wounds = ?
lacerations = ?
burns = ?
poisoning = ?
foreign_body_ingestion = ?
hit_by_car = ?
falls = ?
eye_injuries = ?
ligament_tears = ?                                ; ACL/CCL
drowning = ?
electric_shock = ?
allergic_reactions = ?
snake_bites = ?
insect_stings = ?

{@pet_accident_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Covered Services
; ───────────────────────────────────────────────────────────────────────────────
{.services}
emergency_exam = ?
emergency_exam_limit = #$:(0..):if emergency_exam = true
hospitalization = ?
hospitalization_limit = #$:(0..):if hospitalization = true
surgery = ?
surgery_limit = #$:(0..):if surgery = true
xrays = ?
mri_ct = ?
mri_ct_limit = #$:(0..):if mri_ct = true
ultrasound = ?
lab_work = ?
medications = ?
anesthesia = ?
iv_fluids = ?
blood_transfusion = ?

{@pet_accident_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Waiting Period
; ───────────────────────────────────────────────────────────────────────────────
waiting_period_days = ##:(0..30)
waiting_period_waived = ?

; ═══════════════════════════════════════════════════════════════════════════════
; Pet Illness Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@pet_illness_coverage}
= @coverage                                       ; Inherit universal coverage

; ───────────────────────────────────────────────────────────────────────────────
; Covered Illnesses
; ───────────────────────────────────────────────────────────────────────────────
{.covered}
cancer = ?
diabetes = ?
arthritis = ?
allergies = ?
skin_conditions = ?
ear_infections = ?
urinary_tract_infections = ?
gastrointestinal_illness = ?
respiratory_illness = ?
heart_disease = ?
kidney_disease = ?
liver_disease = ?
thyroid_conditions = ?
epilepsy_seizures = ?
cushings_disease = ?
addisons_disease = ?
pancreatitis = ?
infectious_diseases = ?
parasites = ?
autoimmune_conditions = ?
neurological_conditions = ?
eye_conditions = ?
dental_illness = ?

{@pet_illness_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Hereditary and Congenital Conditions
; ───────────────────────────────────────────────────────────────────────────────
hereditary_conditions_covered = ?
congenital_conditions_covered = ?
hereditary_conditions_waiting_days = ##:(0..365):if hereditary_conditions_covered = true
breed_specific_exclusions[] = :                   ; List of excluded breed conditions

; ───────────────────────────────────────────────────────────────────────────────
; Bilateral Conditions
; ───────────────────────────────────────────────────────────────────────────────
bilateral_conditions_covered = ?
bilateral_exclusion_applies = ?                   ; If one side pre-existing, other excluded

; ───────────────────────────────────────────────────────────────────────────────
; Covered Services
; ───────────────────────────────────────────────────────────────────────────────
{.services}
exam_fees = ?
exam_fee_limit = #$:(0..):if exam_fees = true
specialist_visits = ?
specialist_limit = #$:(0..):if specialist_visits = true
hospitalization = ?
hospitalization_limit = #$:(0..):if hospitalization = true
surgery = ?
surgery_limit = #$:(0..):if surgery = true
diagnostic_tests = ?
xrays = ?
mri_ct = ?
mri_ct_limit = #$:(0..):if mri_ct = true
ultrasound = ?
lab_work = ?
medications = ?
prescription_food = ?
prescription_food_limit = #$:(0..):if prescription_food = true
chemotherapy = ?
chemotherapy_limit = #$:(0..):if chemotherapy = true
radiation = ?
radiation_limit = #$:(0..):if radiation = true

{@pet_illness_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Alternative Therapies
; ───────────────────────────────────────────────────────────────────────────────
{.alternative_therapies}
covered = ?
acupuncture = ?:if covered = true
acupuncture_limit = #$:(0..):if acupuncture = true
chiropractic = ?:if covered = true
chiropractic_limit = #$:(0..):if chiropractic = true
hydrotherapy = ?:if covered = true
hydrotherapy_limit = #$:(0..):if hydrotherapy = true
physical_therapy = ?:if covered = true
physical_therapy_limit = #$:(0..):if physical_therapy = true
cold_laser = ?:if covered = true
stem_cell = ?:if covered = true
stem_cell_limit = #$:(0..):if stem_cell = true

{@pet_illness_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Behavioral Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.behavioral}
covered = ?
behavioral_waiting_days = ##:(0..365):if covered = true
aggression = ?:if covered = true
anxiety = ?:if covered = true
compulsive_disorders = ?:if covered = true
behavioral_limit = #$:(0..):if covered = true
medications_covered = ?:if covered = true
behaviorist_visits = ?:if covered = true

{@pet_illness_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Waiting Period
; ───────────────────────────────────────────────────────────────────────────────
waiting_period_days = ##:(0..30)
orthopedic_waiting_days = ##:(0..365)             ; Cruciate, hip, etc.
cruciate_waiting_days = ##:(0..365)               ; Specifically for CCL/ACL

; ═══════════════════════════════════════════════════════════════════════════════
; Pet Wellness Coverage (Preventive Care)
; ═══════════════════════════════════════════════════════════════════════════════

{@pet_wellness_coverage}
= @coverage                                       ; Inherit universal coverage

; ───────────────────────────────────────────────────────────────────────────────
; Wellness Exam Benefits
; ───────────────────────────────────────────────────────────────────────────────
{.exams}
annual_exam = ?
annual_exam_benefit = #$:(0..):if annual_exam = true
additional_exam = ?
additional_exam_benefit = #$:(0..):if additional_exam = true
exams_per_year = ##:(1..4)

{@pet_wellness_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Vaccination Benefits
; ───────────────────────────────────────────────────────────────────────────────
{.vaccinations}
covered = ?
rabies = ?:if covered = true
rabies_benefit = #$:(0..):if rabies = true
distemper_combo = ?:if covered = true             ; DHPP/FVRCP
distemper_benefit = #$:(0..):if distemper_combo = true
bordetella = ?:if covered = true
bordetella_benefit = #$:(0..):if bordetella = true
lyme = ?:if covered = true
lyme_benefit = #$:(0..):if lyme = true
leptospirosis = ?:if covered = true
leptospirosis_benefit = #$:(0..):if leptospirosis = true
felv = ?:if covered = true
felv_benefit = #$:(0..):if felv = true
total_vaccination_benefit = #$:(0..):if covered = true

{@pet_wellness_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Parasite Prevention
; ───────────────────────────────────────────────────────────────────────────────
{.parasite_prevention}
covered = ?
heartworm_prevention = ?:if covered = true
heartworm_benefit = #$:(0..):if heartworm_prevention = true
heartworm_test = ?:if covered = true
heartworm_test_benefit = #$:(0..):if heartworm_test = true
flea_tick_prevention = ?:if covered = true
flea_tick_benefit = #$:(0..):if flea_tick_prevention = true
deworming = ?:if covered = true
deworming_benefit = #$:(0..):if deworming = true
fecal_test = ?:if covered = true
fecal_test_benefit = #$:(0..):if fecal_test = true

{@pet_wellness_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Dental Wellness
; ───────────────────────────────────────────────────────────────────────────────
{.dental}
covered = ?
cleaning = ?:if covered = true
cleaning_benefit = #$:(0..):if cleaning = true
dental_xrays = ?:if covered = true
dental_xrays_benefit = #$:(0..):if dental_xrays = true
polish_fluoride = ?:if covered = true

{@pet_wellness_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Other Wellness Benefits
; ───────────────────────────────────────────────────────────────────────────────
{.other}
spay_neuter = ?
spay_neuter_benefit = #$:(0..):if spay_neuter = true
microchipping = ?
microchipping_benefit = #$:(0..):if microchipping = true
nail_trim = ?
nail_trim_benefit = #$:(0..):if nail_trim = true
anal_gland_expression = ?
anal_gland_benefit = #$:(0..):if anal_gland_expression = true
health_certificate = ?
health_certificate_benefit = #$:(0..):if health_certificate = true
urinalysis = ?
urinalysis_benefit = #$:(0..):if urinalysis = true
blood_panel = ?
blood_panel_benefit = #$:(0..):if blood_panel = true

{@pet_wellness_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Total Wellness Benefit
; ───────────────────────────────────────────────────────────────────────────────
total_annual_benefit = #$:(0..)
no_waiting_period = ?
no_deductible = ?

; ═══════════════════════════════════════════════════════════════════════════════
; Additional Coverage Options
; ═══════════════════════════════════════════════════════════════════════════════

{@pet_additional_coverage}
; ───────────────────────────────────────────────────────────────────────────────
; End of Life
; ───────────────────────────────────────────────────────────────────────────────
{.end_of_life}
euthanasia = ?
euthanasia_benefit = #$:(0..):if euthanasia = true
cremation = ?
cremation_benefit = #$:(0..):if cremation = true
burial = ?
burial_benefit = #$:(0..):if burial = true

{@pet_additional_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Lost Pet
; ───────────────────────────────────────────────────────────────────────────────
{.lost_pet}
advertising_reward = ?
advertising_benefit = #$:(0..):if advertising_reward = true
reward_benefit = #$:(0..):if advertising_reward = true

{@pet_additional_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Travel and Boarding
; ───────────────────────────────────────────────────────────────────────────────
{.travel}
trip_cancellation = ?
trip_cancellation_benefit = #$:(0..):if trip_cancellation = true
emergency_boarding = ?
emergency_boarding_benefit = #$:(0..):if emergency_boarding = true
boarding_days_max = ##:(0..30):if emergency_boarding = true

{@pet_additional_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Liability (Third Party)
; ───────────────────────────────────────────────────────────────────────────────
{.third_party_liability}
covered = ?
bodily_injury_limit = #$:(0..):if covered = true
property_damage_limit = #$:(0..):if covered = true
legal_defense = ?:if covered = true

{@pet_additional_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Pet Insurance Claim
; ═══════════════════════════════════════════════════════════════════════════════

{@pet_claim}
id = :
number = :
policy_ref = :                                    ; Reference to @pet_policy.id
pet_ref = :                                       ; Reference to @pet.id

; ───────────────────────────────────────────────────────────────────────────────
; Claim Type
; ───────────────────────────────────────────────────────────────────────────────
type = (accident, illness, wellness)
claim_subtype = :                                 ; Specific condition/treatment

; ───────────────────────────────────────────────────────────────────────────────
; Dates
; ───────────────────────────────────────────────────────────────────────────────
date_of_service = date
date_symptoms_first_noticed = date
date_claim_submitted = date
date_claim_received = date
date_claim_processed = date
date_payment_issued = date

; ───────────────────────────────────────────────────────────────────────────────
; Condition/Incident Details
; ───────────────────────────────────────────────────────────────────────────────
condition_description = :
diagnosis = :
diagnosis_code = :                          ; Veterinary diagnosis code
new_condition = ?
continuation = ?
related_claim_ref = ::if continuation = true   ; Reference to prior claim for same condition
body_part_affected = :
bilateral_condition = ?
first_occurrence = ?:if bilateral_condition = true

; ───────────────────────────────────────────────────────────────────────────────
; Pre-Existing Review
; ───────────────────────────────────────────────────────────────────────────────
{.pre_existing_review}
reviewed = ?
determined_pre_existing = ?:if reviewed = true
pre_existing_reason = ::if determined_pre_existing = true
medical_records_requested = ?
medical_records_received = ?

{@pet_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Veterinary Provider
; ───────────────────────────────────────────────────────────────────────────────
vet_provider_ref = :                              ; Reference to @vet_provider.id
vet_practice_name = :
vet_name = :
vet_phone = *@phone
vet_license = *:
vet_license_state_province = :(2)


; ───────────────────────────────────────────────────────────────────────────────
; Invoice Details
; ───────────────────────────────────────────────────────────────────────────────
invoice_number = :
invoice_date = date
invoice_total = #$:(0..)

; ───────────────────────────────────────────────────────────────────────────────
; Invoice Line Items
; ───────────────────────────────────────────────────────────────────────────────
{@pet_claim.line_items[]}
line_number = ##:(1..)
service_date = date
service_code = :
service_description = :
quantity = ##:(1..)
unit_price = #$:(0..)
line_total = #$:(0..)
covered = ?
exclusion_reason = ::if covered = false

{@pet_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Claim Amounts
; ───────────────────────────────────────────────────────────────────────────────
{.amounts}
total_submitted = #$:(0..)
total_eligible = #$:(0..)
total_ineligible = #$:(0..)
ineligible_reason = :
deductible_applied = #$:(0..)
deductible_remaining = #$:(0..)                   ; Remaining annual deductible after claim
copay_amount = #$:(0..)
reimbursement_amount = #$:(0..)
benefit_schedule_amount = #$:(0..)                ; If benefit schedule model
limit_applied = ?
limit_reached = ?
annual_benefit_used = #$:(0..)                    ; Year-to-date benefits used
annual_benefit_remaining = #$:(0..)
lifetime_benefit_used = #$:(0..)
lifetime_benefit_remaining = #$:(0..)

{@pet_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Claim Status
; ───────────────────────────────────────────────────────────────────────────────
status = (
    submitted,
    received,
    pending_info,
    pending_records,
    in_review,
    approved,
    partial_approved,
    denied,
    paid,
    closed,
    appealed
)

denial_reason = (
    documentation_missing,
    exclusion,
    limit_reached,
    not_covered,
    other,
    policy_lapsed,
    pre_existing_condition,
    waiting_period
):if status = denied

denial_explanation = ::if status = denied

; ───────────────────────────────────────────────────────────────────────────────
; Payment
; ───────────────────────────────────────────────────────────────────────────────
{.payment}
amount = #$:(0..)
method = (check, direct_deposit, direct_to_vet)
payee = (policyholder, veterinarian)
check_number = ::if method = check
payment_date = date
payment_reference = :

{@pet_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Appeal
; ───────────────────────────────────────────────────────────────────────────────
{.appeal}
appealed = ?
appeal_date = date:if appealed = true
appeal_reason = ::if appealed = true
appeal_status = (approved, denied, pending, withdrawn):if appealed = true
appeal_decision_date = date:if appealed = true
appeal_decision_reason = ::if appealed = true

{@pet_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Documents
; ───────────────────────────────────────────────────────────────────────────────
{@pet_claim.documents[]}
document_type = (
    appeal_letter,
    claim_form,
    estimate,
    invoice,
    lab_results,
    medical_records,
    other,
    payment_receipt,
    prescription,
    referral,
    xray_images
)
document_name = :
document_date = date
received_date = date

{@pet_claim}

; ═══════════════════════════════════════════════════════════════════════════════
; Pet Insurance Policy
; ═══════════════════════════════════════════════════════════════════════════════

{@pet_policy}
id = :
number = :

; ───────────────────────────────────────────────────────────────────────────────
; Policy Term
; ───────────────────────────────────────────────────────────────────────────────
effective_date = date
effective_time = time
expiration_date = date
expiration_time = time
:invariant expiration_date > effective_date

; ───────────────────────────────────────────────────────────────────────────────
; Policy Type
; ───────────────────────────────────────────────────────────────────────────────
type = (
    accident_only,
    accident_illness,
    comprehensive,                                ; Accident + Illness + Wellness
    wellness_only
)

plan_name = :
plan_tier = (basic, custom, premium, standard)

; ───────────────────────────────────────────────────────────────────────────────
; Policyholder (Owner)
; ───────────────────────────────────────────────────────────────────────────────
policyholder = @named_insured

; ───────────────────────────────────────────────────────────────────────────────
; Insured Pets
; ───────────────────────────────────────────────────────────────────────────────
pets[] = @pet
multi_pet_discount = ?
multi_pet_discount_percent = #:(0..50):if multi_pet_discount = true

; ───────────────────────────────────────────────────────────────────────────────
; Medical History
; ───────────────────────────────────────────────────────────────────────────────
pet_medical_histories[] = @pet_medical_history

; ───────────────────────────────────────────────────────────────────────────────
; Reimbursement Model
; ───────────────────────────────────────────────────────────────────────────────
reimbursement = @pet_reimbursement

; ───────────────────────────────────────────────────────────────────────────────
; Deductible
; ───────────────────────────────────────────────────────────────────────────────
deductible = @pet_deductible

; ───────────────────────────────────────────────────────────────────────────────
; Limits
; ───────────────────────────────────────────────────────────────────────────────
limits = @pet_limits

; ───────────────────────────────────────────────────────────────────────────────
; Waiting Periods
; ───────────────────────────────────────────────────────────────────────────────
waiting_periods[] = @pet_waiting_period

; ───────────────────────────────────────────────────────────────────────────────
; Coverages
; ───────────────────────────────────────────────────────────────────────────────
accident_coverage = @pet_accident_coverage:if type = accident_only
accident_coverage = @pet_accident_coverage:if type = accident_illness
accident_coverage = @pet_accident_coverage:if type = comprehensive

illness_coverage = @pet_illness_coverage:if type = accident_illness
illness_coverage = @pet_illness_coverage:if type = comprehensive

wellness_coverage = @pet_wellness_coverage:if type = comprehensive
wellness_coverage = @pet_wellness_coverage:if type = wellness_only

additional_coverage = @pet_additional_coverage

; ───────────────────────────────────────────────────────────────────────────────
; Exclusions
; ───────────────────────────────────────────────────────────────────────────────
exclusions[] = :

; Standard exclusions
{.standard_exclusions}
pre_existing_conditions = ?true
cosmetic_procedures = ?true
elective_procedures = ?true
breeding_costs = ?true
pregnancy_whelping = ?true
cloning = ?true
experimental_treatments = ?true
food_supplements = ?true
grooming = ?true
preventive_care = ?:if type = accident_only
preventive_care = ?:if type = accident_illness

{@pet_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Enrollment Requirements
; ───────────────────────────────────────────────────────────────────────────────
{.enrollment}
minimum_age_weeks = ##:(6..52)
maximum_age_years = ##                            ; Maximum enrollment age
vet_exam_required = ?
vet_exam_within_days = ##:(0..365):if vet_exam_required = true
medical_records_required = ?
medical_records_months = ##:(0..):if medical_records_required = true

{@pet_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Veterinary Provider
; ───────────────────────────────────────────────────────────────────────────────
primary_vet = @vet_provider
any_licensed_vet = ?                              ; Can use any licensed vet

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
base_annual = #$:(0..)
wellness_annual = #$:(0..)
additional_coverage_annual = #$:(0..)
multi_pet_discount = #$:(0..)
total_annual = #$:(0..)
monthly = #$:(0..)
billing_frequency = (annual, monthly, quarterly, semi_annual)
payment_method = (ach, check, credit_card)
auto_pay = ?

{@pet_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Rating Factors
; ───────────────────────────────────────────────────────────────────────────────
{.rating}
species_factor = #:(0..9.99)
breed_factor = #:(0..9.99)
age_factor = #:(0..9.99)
zip_code_factor = #:(0..9.99)
deductible_factor = #:(0..9.99)
reimbursement_factor = #:(0..9.99)
limit_factor = #:(0..9.99)

{@pet_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Policy Status
; ───────────────────────────────────────────────────────────────────────────────
status = (
    quote,
    application,
    pending_underwriting,
    active,
    cancelled,
    non_renewed,
    expired,
    lapsed
)

cancellation_date = date:if status = cancelled
cancellation_reason = (
    fraud,
    insured_request,
    misrepresentation,
    non_payment,
    pet_death,
    underwriting
):if status = cancelled

; ───────────────────────────────────────────────────────────────────────────────
; Claims Summary
; ───────────────────────────────────────────────────────────────────────────────
claims[] = @pet_claim

{.claims_summary}
total_claims = ##:(0..)
total_paid = #$:(0..)
annual_claims = ##:(0..)
annual_paid = #$:(0..)
claim_free_years = ##:(0..)

{@pet_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Renewal
; ───────────────────────────────────────────────────────────────────────────────
{.renewal}
auto_renew = ?
renewal_date = date
renewal_premium = #$:(0..)
renewal_changes = :                               ; Description of coverage/rate changes
prior_policy_ref = :                              ; Reference to prior term policy

{@pet_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Endorsements
; ───────────────────────────────────────────────────────────────────────────────
{@pet_policy.endorsements[]}
number = :
type = (
    add_pet,
    add_wellness,
    coverage_decrease,
    coverage_increase,
    deductible_change,
    limit_change,
    other,
    remove_pet,
    remove_wellness
)
effective_date = date
description = :
premium_change = #$

{@pet_policy}

; ═══════════════════════════════════════════════════════════════════════════════
; Benefit Schedule (For Benefit Schedule Model)
; ═══════════════════════════════════════════════════════════════════════════════

{@pet_benefit_schedule}
schedule_id = :
schedule_name = :
effective_date = date

; ───────────────────────────────────────────────────────────────────────────────
; Benefit Schedule Items
; ───────────────────────────────────────────────────────────────────────────────
{@pet_benefit_schedule.benefits[]}
condition_category = (
    accident,
    cancer,
    cardiac,
    dental,
    dermatology,
    digestive,
    ear,
    endocrine,
    eye,
    infectious,
    musculoskeletal,
    neurological,
    orthopedic,
    poisoning,
    respiratory,
    urinary,
    other
)
condition_name = :
condition_code = :
maximum_benefit = #$:(0..)
per_occurrence = ?
per_policy_year = ?
lifetime = ?

{@pet_benefit_schedule}


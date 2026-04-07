; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Vital Records Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Birth and death certificate structures based on the U.S. Standard Certificate
; formats. Derived from NCHS vital statistics standards and the Model State
; Vital Statistics Act.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.publichealth.vital"
version = "1.0.0"
title = "Vital Records Schema"
description = "Birth and death certificate structures"

{$derivation}
source[0].authority = "CDC/NCHS"
source[0].citation = "U.S. Standard Certificate of Live Birth"
source[0].url = "https://www.cdc.gov/nchs/nvss/vital_certificate_revisions.htm"

source[1].authority = "CDC/NCHS"
source[1].citation = "U.S. Standard Certificate of Death"
source[1].url = "https://www.cdc.gov/nchs/nvss/vital_certificate_revisions.htm"

source[2].authority = "NCHS"
source[2].citation = "Model State Vital Statistics Act and Regulations"
source[2].url = "https://www.cdc.gov/nchs/data/misc/mvsact92b.pdf"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial vital records schema"
changelog[0].rationale = "Structure derived from NCHS vital statistics standards"

; ═══════════════════════════════════════════════════════════════════════════════
; BIRTH CERTIFICATE
; ═══════════════════════════════════════════════════════════════════════════════
; Per U.S. Standard Certificate of Live Birth (2003 revision)

{@birth}
certificate_number = !:                     ; State file number
state = !:(2)                               ; State of birth
filing_date = !date                         ; Date filed

; Child
{.child}
first_name = :                              ; First name
middle_name = :                             ; Middle name
last_name = !:                              ; Last name
suffix = :                                  ; Suffix
dob = !date                                 ; Date of birth
time_of_birth = :                           ; Time of birth
sex = !(female, male)                       ; Sex
plurality = ##:(1..10)                      ; Single, twin, etc.
birth_order = ##:(1..10)                    ; Birth order (if multiple)

{@birth}

; Place of birth
{.place}
facility_name = :                           ; Hospital/facility name
facility_id = :                             ; NPI or facility ID
city = :                                    ; City
county = :                                  ; County
state = :(2)                                ; State
country = : "US"                            ; Country

{@birth}

; Mother
{.mother}
first_name = !:                             ; First name
middle_name = :                             ; Middle name
maiden_name = !:                            ; Maiden last name
current_last_name = :                       ; Current last name
dob = *date                                 ; Date of birth
birthplace_state = :(2)                     ; State of birth
birthplace_country = :                      ; Country of birth
ssn = *:                                    ; SSN
race[] = :                                  ; Race
ethnicity = (hispanic, non_hispanic)        ; Hispanic origin
education = :                               ; Education level

{@birth}

; Mother's residence
{.residence}
address = :                                 ; Street address
city = :                                    ; City
county = :                                  ; County
state = :(2)                                ; State
zip = :(5..10)                              ; ZIP code
country = : "US"                            ; Country
inside_city_limits = ?                      ; Inside city limits

{@birth}

; Father
{.father}
first_name = :                              ; First name
middle_name = :                             ; Middle name
last_name = :                               ; Last name
dob = *date                                 ; Date of birth
birthplace_state = :(2)                     ; State of birth
birthplace_country = :                      ; Country of birth
ssn = *:                                    ; SSN
race[] = :                                  ; Race
ethnicity = (hispanic, non_hispanic)        ; Hispanic origin
education = :                               ; Education level
paternity_acknowledged = ?                  ; Paternity acknowledged

{@birth}

; Pregnancy history
{.pregnancy}
date_last_menses = date                     ; LMP date
prenatal_visits = ##:(0..50)                ; Number prenatal visits
prenatal_start_month = ##:(1..10)           ; Month prenatal care began
gestation_weeks = ##:(17..47)               ; Gestational age (weeks)
previous_live_births = ##:(0..20)           ; Previous live births
previous_terminations = ##:(0..20)          ; Previous terminations

{@birth}

; Delivery
{.delivery}
delivery_method = (cesarean, forceps, spontaneous, vacuum)
cesarean_previous = ?                       ; Previous cesarean
trial_of_labor = ?                          ; Trial of labor after cesarean
attendant_type = (certified_nurse_midwife, md_do, other, other_midwife)
attendant_name = :                          ; Attendant name
attendant_npi = :                           ; Attendant NPI

{@birth}

; Newborn
{.newborn}
birth_weight_grams = ##:(100..9000)         ; Birth weight (grams)
apgar_5_min = ##:(0..10)                    ; 5-minute APGAR
apgar_10_min = ##:(0..10)                   ; 10-minute APGAR (if needed)
abnormal_conditions[] = :                   ; Abnormal conditions
congenital_anomalies[] = :                  ; Congenital anomalies
infant_transferred = ?                      ; Transferred to NICU
breastfed_at_discharge = ?                  ; Breastfed at discharge

{@birth}

; Medical risk factors
{.risk_factors}
diabetes_preexisting = ?                    ; Pre-pregnancy diabetes
diabetes_gestational = ?                    ; Gestational diabetes
hypertension_preexisting = ?                ; Pre-pregnancy hypertension
hypertension_gestational = ?                ; Gestational hypertension
eclampsia = ?                               ; Eclampsia
previous_preterm = ?                        ; Previous preterm birth
previous_cesarean = ?                       ; Previous cesarean
infertility_treatment = ?                   ; Infertility treatment

{@birth}

; ═══════════════════════════════════════════════════════════════════════════════
; DEATH CERTIFICATE
; ═══════════════════════════════════════════════════════════════════════════════
; Per U.S. Standard Certificate of Death (2003 revision)

{@death}
certificate_number = !:                     ; State file number
state = !:(2)                               ; State of death
filing_date = !date                         ; Date filed

; Decedent
{.decedent}
first_name = !:                             ; First name
middle_name = :                             ; Middle name
last_name = !:                              ; Last name
suffix = :                                  ; Suffix
ssn = *:                                    ; SSN
dob = *date                                 ; Date of birth
sex = !(female, male, unknown)              ; Sex
race[] = :                                  ; Race
ethnicity = (hispanic, non_hispanic, unknown)
marital_status = (divorced, married, never_married, unknown, widowed)
education = :                               ; Education level
occupation = :                              ; Usual occupation
industry = :                                ; Kind of business/industry
armed_forces = ?                            ; Ever in US Armed Forces

{@death}

; Decedent residence
{.residence}
address = :                                 ; Street address
city = :                                    ; City
county = :                                  ; County
state = :(2)                                ; State
zip = :(5..10)                              ; ZIP code
country = : "US"                            ; Country
inside_city_limits = ?                      ; Inside city limits

{@death}

; Death information
{.death_info}
date_of_death = !date                       ; Date of death
time_of_death = :                           ; Time of death
date_pronounced = date                      ; Date pronounced dead
time_pronounced = :                         ; Time pronounced

{@death}

; Place of death
{.place}
place_type = !(decedent_home, er, hospice, hospital_inpatient, hospital_outpatient, nursing_home, other)
facility_name = :                           ; Facility name
city = :                                    ; City
county = :                                  ; County
state = :(2)                                ; State
country = : "US"                            ; Country

{@death}

; Cause of death - Per ICD mortality coding
{.cause}
immediate_cause = !:                        ; Immediate cause (Part I, Line a)
immediate_interval = :                      ; Interval onset to death
sequence_conditions[] = @cause_condition    ; Sequentially (Part I, b-d)
contributing_conditions[] = :               ; Contributing causes (Part II)

{@death}

; Manner of death
{.manner}
manner = !(accident, could_not_determine, homicide, natural, pending, suicide)
how_injury_occurred = :                     ; How injury occurred
injury_date = date                          ; Date of injury
injury_time = :                             ; Time of injury
injury_at_work = ?                          ; Injury at work
injury_place = :                            ; Place of injury
transport_accident = ?                      ; Transportation accident

{@death}

; Medical examiner/coroner
{.me_coroner}
me_coroner_contacted = ?                    ; ME/Coroner contacted
case_referred = ?                           ; Case referred to ME/Coroner
autopsy_performed = ?                       ; Autopsy performed
autopsy_findings_available = ?              ; Autopsy findings available
autopsy_used_in_certification = ?           ; Autopsy used in cause

{@death}

; Certifier
{.certifier}
certifier_type = !(attending, certifying_physician, me_coroner, other)
certifier_name = !:                         ; Certifier name
certifier_license = :                       ; License number
certifier_address = @address                ; Address
certifier_date = date                       ; Date certified

{@death}

; Disposition
{.disposition}
method = !(burial, cremation, donation, entombment, other, removal_from_state)
place_name = :                              ; Funeral home/crematory name
place_city = :                              ; City
place_state = :(2)                          ; State
date_disposition = date                     ; Date of disposition

{@death}

; Informant
{.informant}
name = :                                    ; Informant name
relationship = :                            ; Relationship to decedent
address = @address                          ; Address
phone = *@phone                             ; Phone

{@death}

{@cause_condition}
condition = :                               ; Condition description
interval = :                                ; Approximate interval
icd10_code = :                              ; ICD-10 code (for coding)

; ═══════════════════════════════════════════════════════════════════════════════
; FETAL DEATH REPORT
; ═══════════════════════════════════════════════════════════════════════════════
; Per U.S. Standard Report of Fetal Death

{@fetal_death}
report_number = !:                          ; State file number
state = !:(2)                               ; State
filing_date = !date                         ; Date filed

; Fetus
{.fetus}
sex = (female, male, unknown)               ; Sex
plurality = ##:(1..10)                      ; Plurality
birth_order = ##:(1..10)                    ; Birth order if multiple
delivery_date = !date                       ; Date of delivery
delivery_time = :                           ; Time of delivery
gestation_weeks = ##:(0..45)                ; Gestational age
weight_grams = ##:(0..9000)                 ; Weight

{@fetal_death}

; Timing of death
{.timing}
dead_at_delivery = ?                        ; Dead at delivery
timing = (before_labor, during_labor, unknown)

{@fetal_death}

; Place of delivery
{.place}
facility_name = :                           ; Facility name
city = :                                    ; City
county = :                                  ; County
state = :(2)                                ; State

{@fetal_death}

; Mother (similar to birth certificate)
mother = @birth.mother                      ; Mother information
residence = @birth.residence                ; Mother's residence

; Cause/initiating cause
{.cause}
initiating_cause = :                        ; Initiating cause
other_conditions[] = :                      ; Other significant conditions

{@fetal_death}

; Risk factors
risk_factors = @birth.risk_factors          ; Medical risk factors


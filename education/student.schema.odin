; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Student Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Student information for K-12 and higher education including demographics,
; enrollment status, classification, program participation, and state/federal
; identifiers.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.education.student"
version = "1.0.0"
title = "Student Schema"
description = "Student demographics, enrollment, identity, and classification"

{$derivation}
source[0].authority = "U.S. Department of Education"
source[0].citation = "34 CFR Part 99 - Family Educational Rights and Privacy (FERPA)"
source[0].url = "https://www.ecfr.gov/current/title-34/subtitle-A/part-99"
source[0].accessed = 2025-12-21

source[1].authority = "National Center for Education Statistics"
source[1].citation = "Common Education Data Standards (CEDS)"
source[1].url = "https://ceds.ed.gov/"
source[1].accessed = 2025-12-21

source[2].authority = "U.S. Department of Education"
source[2].citation = "34 CFR Part 668 - Student Assistance General Provisions"
source[2].url = "https://www.ecfr.gov/current/title-34/subtitle-B/chapter-VI/part-668"
source[2].accessed = 2025-12-21

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema derived from FERPA, CEDS, and federal student aid regulations"

changelog[0].date = 2025-12-21
changelog[0].change = "Initial student schema"
changelog[0].rationale = "Core student identity, demographics, and enrollment status per FERPA and CEDS standards"

; ═══════════════════════════════════════════════════════════════════════════════
; STUDENT IDENTITY
; ═══════════════════════════════════════════════════════════════════════════════

{@student_identifiers}
; Required fields first
student_id = *:                                     ; Local student identifier (confidential PII)

; Optional fields - state and federal IDs
state_student_id = *:                                ; State-assigned student identifier (SSID)
federal_student_id = *:                              ; Federal student identifier (NSLDS ID)
previous_ids[] = *:                                  ; Prior student IDs from transfers

; ═══════════════════════════════════════════════════════════════════════════════
; STUDENT CORE
; ═══════════════════════════════════════════════════════════════════════════════

{@student}
; Required fields first
id = *:                                             ; Student identifier
name = @person_name                                 ; Student name

; Demographics (PII)
date_of_birth = *date                               ; Birth date (confidential PII)
gender = (female, male, non_binary)
citizenship = (non_resident_alien, permanent_resident, refugee_asylee, us_citizen, us_national)

; Identity
identifiers = @student_identifiers
demographics = @demographics                         ; Additional demographics from common types
ssn = *:format ssn                                  ; Social Security Number (US only, PII)

; Contact information
addresses[] = @address                               ; Student addresses
emails[] = *@email                                   ; Student email addresses (PII)
phones[] = *@phone                                   ; Student phone numbers (PII)

; Emergency contact
{.emergency_contact}
name = @person_name
relationship = :
phones[] = *@phone
emails[] = *@email
address = @address

{@student}

; Enrollment
current_enrollment = @enrollment_record              ; Current enrollment record
enrollment_history[] = @enrollment_record            ; Historical enrollments

; Classification
classification = @student_classification             ; Current classification

; Academic program
major = :                                            ; Primary major/program
minors[] = :                                         ; Minor programs
concentration = :                                    ; Concentration within major

; Status flags
active = ?                                           ; Currently active student
full_time = ?                                        ; Full-time vs part-time
residential = ?                                      ; On-campus resident
first_generation = ?                                 ; First-generation college student
veteran = ?                                          ; Military veteran
military_dependent = ?                               ; Military dependent
foster_youth = ?                                     ; Foster care youth

; Timestamps
created = timestamp
updated = timestamp

; ═══════════════════════════════════════════════════════════════════════════════
; ENROLLMENT RECORD
; ═══════════════════════════════════════════════════════════════════════════════

{@enrollment_record}
; Required fields first
institution_id = :                                  ; Institution/school identifier
enrollment_date = date                              ; Date of enrollment
status = (enrolled, graduated, not_enrolled, transferred, withdrawn)

; Optional fields
entry_date = date                                    ; Date student entered program
exit_date = date                                     ; Date student exited
exit_reason = (completion, death, dismissal, dropout, expulsion, graduated, military, transferred, withdrawal)
exit_reason_detail = :

; Enrollment type
enrollment_type = (continuing, first_time, re_entry, transfer)
entry_type = (early_admission, first_time_freshman, readmission, transfer)

; Level
education_level = (adult_education, associate_degree, bachelor_degree, certificate, continuing_education, doctoral_degree, elementary, graduate, high_school_diploma, kindergarten, master_degree, middle_school, postsecondary, preschool, professional_degree, secondary, ungraded, undergraduate)

; Term information
academic_term = :                                    ; Term identifier
academic_year = :                                    ; Academic year

; Classification at enrollment
grade_level = :                                      ; Grade level (K-12)
class_standing = (first_year, fourth_year, graduate, second_year, third_year, unclassified)

; Load
credit_hours = #:(0..)                               ; Enrolled credit hours
full_time_status = ?                                 ; Full-time enrollment flag

; ═══════════════════════════════════════════════════════════════════════════════
; STUDENT CLASSIFICATION
; ═══════════════════════════════════════════════════════════════════════════════

{@student_classification}
; K-12 Classification
grade_level = :                                      ; Grade level (K, 01-12)
homeroom = :                                         ; Homeroom assignment
cohort_year = ##:(1900..)                            ; Expected graduation year

; Postsecondary Classification
class_standing = (first_year, fourth_year, graduate, second_year, third_year, unclassified)
degree_seeking = ?                                   ; Degree-seeking student
credential_level = (associate, bachelor, certificate, doctoral, master, non_degree, post_baccalaureate_certificate, post_master_certificate, professional)

; Program
program_name = :                                     ; Program/major name
program_code = :                                     ; CIP code or local program code
degree_type = (aa, aas, as, ba, bfa, bs, certificate, dba, edd, jd, ma, mba, mfa, ms, msw, phd)
major = :                                            ; Major field
minors[] = :                                         ; Minor fields
concentration = :                                    ; Concentration/specialization

; Special populations (CEDS)
economically_disadvantaged = ?                       ; Low income
english_learner = ?                                  ; ELL status
homeless = ?                                         ; Homeless status
immigrant = ?                                        ; Immigrant status
migrant = ?                                          ; Migrant status
military_connected = ?                               ; Military family
section_504 = ?                                      ; Section 504 eligibility
special_education = ?                                ; IDEA eligibility
title_i = ?                                          ; Title I participation

; Attendance mode
attendance_mode = (correspondence, distance_education, hybrid, in_person)
enrollment_intensity = (exclusively_full_time, exclusively_part_time, full_time_and_part_time, none)

; ═══════════════════════════════════════════════════════════════════════════════
; GUARDIAN / PARENT
; ═══════════════════════════════════════════════════════════════════════════════

{@guardian}
; Required fields first
name = @person_name
relationship = (adoptive_parent, foster_parent, grandparent, guardian, legal_guardian, other, parent, stepparent)

; Optional fields
primary_contact = ?                                  ; Primary contact person
lives_with_student = ?                               ; Student resides with guardian
legal_custody = ?                                    ; Has legal custody

; Contact
addresses[] = @address
emails[] = *@email
phones[] = *@phone

; Employment
employer = :
occupation = :

; Education
highest_education_level = (associate_degree, bachelor_degree, doctoral_degree, elementary, graduate_professional_degree, high_school_diploma_ged, less_than_high_school, master_degree, post_baccalaureate_certificate, some_college_no_degree)

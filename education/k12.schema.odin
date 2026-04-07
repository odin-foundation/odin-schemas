; ═══════════════════════════════════════════════════════════════════════════════
; ODIN K-12 Education Schema
; ═══════════════════════════════════════════════════════════════════════════════
; K-12 specific schema for elementary and secondary education including
; attendance, behavior, special education (IDEA/IEP), Section 504, English
; Language Learner services, and health records.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types
@import "./student.schema.odin" as student

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.education.k12"
version = "1.0.0"
title = "K-12 Education Schema"
description = "Attendance, behavior, special education, Section 504, ELL, and health services"

{$derivation}
source[0].authority = "U.S. Department of Education"
source[0].citation = "34 CFR Part 300 - Assistance to States for the Education of Children with Disabilities (IDEA)"
source[0].url = "https://www.ecfr.gov/current/title-34/subtitle-B/chapter-III/part-300"
source[0].accessed = 2025-12-21

source[1].authority = "U.S. Department of Education"
source[1].citation = "34 CFR Part 104 - Nondiscrimination on the Basis of Handicap (Section 504)"
source[1].url = "https://www.ecfr.gov/current/title-34/subtitle-B/chapter-I/part-104"
source[1].accessed = 2025-12-21

source[2].authority = "National Center for Education Statistics"
source[2].citation = "Common Education Data Standards (CEDS)"
source[2].url = "https://ceds.ed.gov/"
source[2].accessed = 2025-12-21

source[3].authority = "Centers for Disease Control and Prevention"
source[3].citation = "School Immunization Requirements"
source[3].url = "https://www.cdc.gov/vaccines/php/requirements-laws/index.html"
source[3].accessed = 2025-12-21

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema derived from IDEA Part 300, Section 504, CEDS, and CDC immunization standards"

changelog[0].date = 2025-12-21
changelog[0].change = "Initial K-12 schema"
changelog[0].rationale = "Core K-12 services including IDEA, Section 504, ELL per federal regulations"

; ═══════════════════════════════════════════════════════════════════════════════
; ATTENDANCE
; ═══════════════════════════════════════════════════════════════════════════════

{@attendance_record}
; Required fields first
student_id = !*:                                     ; Student identifier
attendance_date = !date                              ; Date of attendance record
status = (absent, excused_absence, present, tardy, unexcused_absence)

; Optional fields
period = :                                           ; Class period or block
course_section = :                                   ; Specific course section
minutes_absent = ##:(0..)                            ; Minutes absent
minutes_tardy = ##:(0..)                             ; Minutes tardy

; Absence details
absence_reason = (disciplinary, family_emergency, health, illness, other, religious, school_activity, suspension, unknown, vacation, weather)
absence_note = :                                     ; Absence note/documentation
excused = ?                                          ; Excused vs unexcused

; Verification
verified = ?                                         ; Attendance verified
verified_by = :                                      ; Who verified
verified_date = date                                 ; Verification date

; ═══════════════════════════════════════════════════════════════════════════════
; ATTENDANCE SUMMARY
; ═══════════════════════════════════════════════════════════════════════════════

{@attendance_summary}
; Required fields first
student_id = !*:                                     ; Student identifier
academic_year = !:                                   ; Academic year

; Optional fields
academic_term = :                                    ; Specific term

; Counts
days_enrolled = ##:(0..)                             ; Days enrolled
days_present = ##:(0..)                              ; Days present
days_absent = ##:(0..)                               ; Total days absent
days_excused = ##:(0..)                              ; Days excused absence
days_unexcused = ##:(0..)                            ; Days unexcused absence
days_tardy = ##:(0..)                                ; Days tardy

; Rates
attendance_rate = #:(0..100)                         ; Attendance percentage
absence_rate = #:(0..100)                            ; Absence percentage
tardy_rate = #:(0..100)                              ; Tardy percentage

; Truancy
truant = ?                                           ; Truant student flag
truancy_referral_date = date                         ; Truancy referral date

; ═══════════════════════════════════════════════════════════════════════════════
; DISCIPLINE INCIDENT
; ═══════════════════════════════════════════════════════════════════════════════

{@discipline_incident}
; Required fields first
incident_id = !:                                     ; Incident identifier
student_id = !*:                                     ; Student identifier
incident_date = !date                                ; Incident date

; Optional fields
incident_time = time                                 ; Incident time
reported_date = date                                 ; Date reported

; Location
incident_location = (athletic_event, bus, cafeteria, classroom, hallway, off_campus, online, other, playground, restroom, school_grounds)
location_detail = :                                  ; Specific location detail

; Behavior
behavior_type = (academic_dishonesty, alcohol, assault, bullying, defiance, disorderly_conduct, disruption, drugs, fighting, harassment, intimidation, other, profanity, sexual_harassment, theft, tobacco, truancy, vandalism, weapons)
behavior_description = :                             ; Detailed description
severity = (major, minor, moderate)

; Victim information
victim_type = (none, other_student, property, staff, visitor)
victim_id = *:                                       ; Victim identifier if student
injury_occurred = ?                                  ; Physical injury occurred

; Witnesses
witnesses[] = :                                      ; Witness identifiers
reported_by = :                                      ; Who reported incident

; ═══════════════════════════════════════════════════════════════════════════════
; DISCIPLINARY ACTION
; ═══════════════════════════════════════════════════════════════════════════════

{@disciplinary_action}
; Required fields first
incident_id = !:                                     ; Related incident
student_id = !*:                                     ; Student identifier
action_type = (community_service, corporal_punishment, counseling, detention, expulsion, in_school_suspension, loss_of_privilege, out_of_school_suspension, parent_conference, referral, removal, warning, other)

; Optional fields
action_date = date                                   ; Date action taken
effective_date = date                                ; Date action becomes effective
duration_days = ##:(0..)                             ; Duration in days
duration_hours = ##:(0..)                            ; Duration in hours

; Details
action_description = :                               ; Action details
alternative_placement = ?                            ; Student placed in alternative program
placement_program = :                                ; Alternative program name

; Appeal
appeal_filed = ?                                     ; Appeal filed
appeal_date = date                                   ; Appeal filed date
appeal_result = (denied, granted, modified, pending)

; IDEA considerations
idea_manifestation_determination = ?                 ; Manifestation determination held
manifestation_result = (behavior_not_manifestation, behavior_was_manifestation)
idea_services_continued = ?                          ; Special ed services during suspension

; ═══════════════════════════════════════════════════════════════════════════════
; SPECIAL EDUCATION (IDEA)
; ═══════════════════════════════════════════════════════════════════════════════

{@special_education_referral}
; Required fields first
student_id = !*:                                     ; Student identifier
referral_date = !date                                ; Referral date

; Optional fields
referral_source = (administrator, counselor, parent, physician, teacher, other)
referral_reason = :                                  ; Reason for referral
suspected_disability = :                             ; Suspected disability category

; Consent
parent_consent_date = date                           ; Parent consent obtained date
parent_consent = ?                                   ; Parent consent received

; Evaluation
evaluation_due_date = date                           ; Evaluation due (60 days)
evaluation_completed_date = date                     ; Evaluation completed date
eligibility_determination_date = date                ; Eligibility determined date
eligible = ?                                         ; Student eligible for IDEA

; ═══════════════════════════════════════════════════════════════════════════════
; IEP (INDIVIDUALIZED EDUCATION PROGRAM)
; ═══════════════════════════════════════════════════════════════════════════════

{@iep}
; Required fields first
student_id = !*:                                     ; Student identifier
iep_date = !date                                     ; IEP meeting date
effective_date = !date                               ; IEP effective date
review_date = !date                                  ; Next review date

; Optional fields
disability_category = (autism, deaf_blindness, deafness, developmental_delay, emotional_disturbance, hearing_impairment, intellectual_disability, multiple_disabilities, orthopedic_impairment, other_health_impairment, specific_learning_disability, speech_language_impairment, traumatic_brain_injury, visual_impairment)
disability_secondary[] = :                           ; Additional disabilities

; Placement
placement = (general_education, homebound, hospital, private_school, public_separate_facility, resource_room, separate_class, separate_school)
lre_percentage = #:(0..100)                          ; Percentage in general education (LRE)

; Services
related_services[] = :                               ; Related services provided
service_hours = #:(0..)                              ; Weekly service hours
esy_services = ?                                     ; Extended school year services

; Team
iep_team_members[] = @iep_team_member                ; IEP team members
parent_participation = ?                             ; Parent participated

; Goals
annual_goals[] = @iep_goal                           ; Annual goals
transition_services = ?                              ; Transition services included
transition_age = ##                                  ; Age at transition planning start

; ═══════════════════════════════════════════════════════════════════════════════
; IEP TEAM MEMBER
; ═══════════════════════════════════════════════════════════════════════════════

{@iep_team_member}
; Required fields first
name = !:                                            ; Team member name
role = (administrator, general_education_teacher, interpreter, parent, related_services_provider, special_education_teacher, student, other)

; Optional fields
title = :                                            ; Professional title
attended = ?                                         ; Attended IEP meeting
excused = ?                                          ; Excused from meeting

; ═══════════════════════════════════════════════════════════════════════════════
; IEP GOAL
; ═══════════════════════════════════════════════════════════════════════════════

{@iep_goal}
; Required fields first
goal_number = !:                                     ; Goal identifier
goal_statement = !:                                  ; Measurable goal statement

; Optional fields
domain = (academic, behavioral, communication, daily_living, motor, social_emotional, transition, vocational)
baseline = :                                         ; Current performance baseline
measurement_method = :                               ; How progress is measured
target_date = date                                   ; Target completion date

; Progress monitoring
progress_frequency = :                               ; How often progress reported
progress_reports[] = @goal_progress                  ; Progress reports

; ═══════════════════════════════════════════════════════════════════════════════
; GOAL PROGRESS
; ═══════════════════════════════════════════════════════════════════════════════

{@goal_progress}
; Required fields first
reporting_date = !date                               ; Progress report date
progress_level = (achieved, insufficient_progress, limited_progress, regression, satisfactory_progress)

; Optional fields
progress_description = :                             ; Progress description
data = :                                             ; Progress data/measurement

; ═══════════════════════════════════════════════════════════════════════════════
; SECTION 504
; ═══════════════════════════════════════════════════════════════════════════════

{@section_504_plan}
; Required fields first
student_id = !*:                                     ; Student identifier
plan_date = !date                                    ; Plan development date
effective_date = !date                               ; Plan effective date
review_date = !date                                  ; Next review date

; Optional fields
disability = :                                       ; Qualifying disability
substantially_limits = :                             ; Major life activity limited

; Accommodations
accommodations[] = @accommodation                    ; Accommodations and modifications

; Evaluation
evaluation_date = date                               ; Evaluation date
reevaluation_date = date                             ; Reevaluation due date
eligible = ?                                         ; Eligible for Section 504

; Team
team_members[] = :                                   ; 504 team member names
parent_participation = ?                             ; Parent participated

; ═══════════════════════════════════════════════════════════════════════════════
; ACCOMMODATION
; ═══════════════════════════════════════════════════════════════════════════════

{@accommodation}
; Required fields first
accommodation_type = !:                              ; Accommodation type
description = !:                                     ; Detailed description

; Optional fields
category = (assistive_technology, behavioral_support, classroom_modification, environmental, instructional, physical_accessibility, testing)
frequency = :                                        ; How often provided
responsible_party = :                                ; Who implements

; ═══════════════════════════════════════════════════════════════════════════════
; ENGLISH LANGUAGE LEARNER (ELL)
; ═══════════════════════════════════════════════════════════════════════════════

{@ell_program}
; Required fields first
student_id = !*:                                     ; Student identifier
enrollment_date = !date                              ; ELL program enrollment date

; Optional fields
exit_date = date                                     ; Exit date from program
exit_reason = (graduated, met_proficiency, moved, parent_refusal, transferred)

; Language background
primary_language = :                                 ; Primary/home language
languages_spoken[] = :                               ; All languages spoken
english_proficiency_level = (beginner, emerging, intermediate, proficient, transitioning)

; Program type
program_type = (bilingual, content_based_esl, dual_language, english_only, esl_pullout, sheltered_instruction, structured_immersion, transitional_bilingual, two_way_immersion)

; Services
instructional_minutes = ##:(0..)                     ; Weekly instructional minutes
service_setting = (classroom, homeroom, pullout, push_in)

; Assessment
initial_assessment_date = date                       ; Initial language assessment date
annual_assessment_date = date                        ; Annual assessment date
proficiency_test_score = #                           ; English proficiency score

; ═══════════════════════════════════════════════════════════════════════════════
; HEALTH / IMMUNIZATION
; ═══════════════════════════════════════════════════════════════════════════════

{@health_record}
; Required fields first
student_id = !*:                                     ; Student identifier

; Optional fields
blood_type = (a_negative, a_positive, ab_negative, ab_positive, b_negative, b_positive, o_negative, o_positive)

; Medical conditions
allergies[] = @allergy                               ; Allergies
medical_conditions[] = @medical_condition            ; Chronic conditions
medications[] = @medication                          ; Current medications

; Emergency
emergency_care_plan = ?                              ; Emergency care plan on file
emergency_plan_type = (allergy, asthma, diabetes, seizure, other)

; Immunizations
immunizations[] = @immunization                      ; Immunization records
immunization_compliant = ?                           ; Immunization requirements met
immunization_exemption = ?                           ; Exemption on file
exemption_type = (medical, personal, religious)

; ═══════════════════════════════════════════════════════════════════════════════
; ALLERGY
; ═══════════════════════════════════════════════════════════════════════════════

{@allergy}
; Required fields first
allergen = !:                                        ; Allergen name

; Optional fields
category = (drug, environmental, food, insect, other)
severity = (mild, moderate, severe, life_threatening)
reaction = :                                         ; Typical reaction
treatment = :                                        ; Treatment protocol
onset_date = date                                    ; Date allergy identified

; ═══════════════════════════════════════════════════════════════════════════════
; MEDICAL CONDITION
; ═══════════════════════════════════════════════════════════════════════════════

{@medical_condition}
; Required fields first
condition = !:                                       ; Condition name

; Optional fields
diagnosis_date = date                                ; Date diagnosed
severity = (controlled, mild, moderate, severe)
treatment_plan = :                                   ; Treatment plan
requires_monitoring = ?                              ; School monitoring required

; ═══════════════════════════════════════════════════════════════════════════════
; MEDICATION
; ═══════════════════════════════════════════════════════════════════════════════

{@medication}
; Required fields first
medication_name = !*:                                ; Medication name (confidential)

; Optional fields
dosage = *:                                          ; Dosage (confidential)
route = (inhaled, injectable, oral, topical, other)
frequency = :                                        ; Frequency of administration
administered_at_school = ?                           ; Given during school hours
authorization_on_file = ?                            ; Physician authorization on file

; ═══════════════════════════════════════════════════════════════════════════════
; IMMUNIZATION
; ═══════════════════════════════════════════════════════════════════════════════

{@immunization}
; Required fields first
vaccine_type = !:                                    ; Vaccine name
administered_date = !date                            ; Date administered

; Optional fields
dose_number = ##:(1..)                               ; Dose number in series
lot_number = :                                       ; Vaccine lot number
manufacturer = :                                     ; Vaccine manufacturer
administration_site = (deltoid, thigh, other)
provider_name = :                                    ; Provider who administered
provider_npi = :                                     ; Provider NPI number

; Verification
verified = ?                                         ; Record verified
verification_date = date                             ; Verification date

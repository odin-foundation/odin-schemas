; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Academic Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Academic records for K-12 and higher education including course catalogs,
; enrollment, grades, transcripts, degree requirements, and honors.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types
@import "./student.schema.odin" as student

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.education.academic"
version = "1.0.0"
title = "Academic Schema"
description = "Course catalog, enrollment, grades, transcripts, and degree conferral"

{$derivation}
source[0].authority = "U.S. Department of Education"
source[0].citation = "34 CFR Part 99 - Family Educational Rights and Privacy (FERPA)"
source[0].url = "https://www.ecfr.gov/current/title-34/subtitle-A/part-99"
source[0].accessed = 2025-12-21

source[1].authority = "National Center for Education Statistics"
source[1].citation = "Common Education Data Standards (CEDS)"
source[1].url = "https://ceds.ed.gov/"
source[1].accessed = 2025-12-21

source[2].authority = "American Association of Collegiate Registrars and Admissions Officers"
source[2].citation = "AACRAO Academic Record and Transcript Guide"
source[2].url = "https://www.aacrao.org/"
source[2].accessed = 2025-12-21

source[3].authority = "Postsecondary Electronic Standards Council"
source[3].citation = "PESC XML Transcript Standard"
source[3].url = "https://www.pesc.org/"
source[3].accessed = 2025-12-21

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema derived from FERPA, CEDS, AACRAO, and PESC academic standards"

changelog[0].date = 2025-12-21
changelog[0].change = "Initial academic schema"
changelog[0].rationale = "Core academic records including courses, grades, transcripts per FERPA and AACRAO standards"

; ═══════════════════════════════════════════════════════════════════════════════
; COURSE CATALOG
; ═══════════════════════════════════════════════════════════════════════════════

{@course}
; Required fields first
course_code = !:                                     ; Course identifier/number
title = !:                                           ; Course title

; Optional fields
description = :                                      ; Course description
subject_area = :                                     ; Subject/discipline
department = :                                       ; Academic department

; Classification
credit_type = (carnegie_unit, continuing_education, credit_by_exam, dual_credit, noncredit, regular_credit)
credit_hours = #:(0..)                               ; Semester credit hours
credit_hours_min = #:(0..)                           ; Minimum credit hours
credit_hours_max = #:(0..)                           ; Maximum credit hours
variable_credit = ?                                  ; Variable credit course

; Level
course_level = (advanced, basic, college, developmental, graduate, honors, intermediate, lower_division, remedial, undergraduate, upper_division)
grade_levels[] = :                                   ; Applicable grade levels (K-12)

; Classification codes
cip_code = :(2..7)                                   ; Classification of Instructional Programs code
sced_code = :                                        ; School Codes for the Exchange of Data
local_course_code = :                                ; Local classification code

; Prerequisites and requirements
prerequisites[] = :                                  ; Prerequisite courses
corequisites[] = :                                   ; Corequisite courses
restrictions = :                                     ; Enrollment restrictions

; Delivery
instructional_method = (blended, correspondence, face_to_face, independent_study, internship, online, televised)
dual_credit = ?                                      ; Dual credit course
advanced_placement = ?                               ; AP course
international_baccalaureate = ?                      ; IB course

; Status
active = ?                                           ; Course offered
repeatable = ?                                       ; Course may be repeated for credit
max_repeats = ##:(0..)                               ; Maximum repeat count

; ═══════════════════════════════════════════════════════════════════════════════
; COURSE SECTION
; ═══════════════════════════════════════════════════════════════════════════════

{@course_section}
; Required fields first
section_id = !:                                      ; Section identifier
course_code = !:                                     ; Course code (reference)
academic_term = !:                                   ; Term/semester

; Optional fields
section_number = :                                   ; Section number
academic_year = :                                    ; Academic year
title = :                                            ; Section title override

; Schedule
start_date = date                                    ; Section start date
end_date = date                                      ; Section end date
meeting_times[] = @meeting_time                      ; Class meeting schedule

; Enrollment
enrollment_capacity = ##:(0..)                       ; Maximum enrollment
enrollment_count = ##:(0..)                          ; Current enrollment
waitlist_capacity = ##:(0..)                         ; Waitlist capacity
waitlist_count = ##:(0..)                            ; Current waitlist count

; Instructors
instructors[] = :                                    ; Instructor IDs
instructor_of_record = :                             ; Primary instructor

; Delivery
instructional_method = (blended, correspondence, face_to_face, independent_study, internship, online, televised)
location = :                                         ; Building/room
campus = :                                           ; Campus location

; Status
status = (active, cancelled, closed, open, waitlist)

; ═══════════════════════════════════════════════════════════════════════════════
; MEETING TIME
; ═══════════════════════════════════════════════════════════════════════════════

{@meeting_time}
; Days of week
days = :                                             ; Days pattern (e.g., MWF, TR)
monday = ?
tuesday = ?
wednesday = ?
thursday = ?
friday = ?
saturday = ?
sunday = ?

; Time
start_time = time                                    ; Start time
end_time = time                                      ; End time

; Location
building = :                                         ; Building code
room = :                                             ; Room number

; ═══════════════════════════════════════════════════════════════════════════════
; COURSE ENROLLMENT
; ═══════════════════════════════════════════════════════════════════════════════

{@course_enrollment}
; Required fields first
student_id = !*:                                     ; Student identifier
section_id = !:                                      ; Section identifier
enrollment_date = !date                              ; Date enrolled

; Optional fields
status = (add, audit, complete, drop, enrolled, incomplete, in_progress, withdrawn)
status_date = date                                   ; Status change date

; Credit
credit_hours = #:(0..)                               ; Enrolled credit hours
grade_mode = (audit, credit, pass_fail)              ; Grading mode

; Completion
completion_date = date                               ; Course completion date
withdrawal_date = date                               ; Withdrawal date
withdrawal_reason = :                                ; Reason for withdrawal

; Performance (may reference @grade)
final_grade = :                                      ; Final grade
grade_points = #                                     ; Grade points earned
credits_earned = #:(0..)                             ; Credits earned
credits_attempted = #:(0..)                          ; Credits attempted

; ═══════════════════════════════════════════════════════════════════════════════
; GRADE
; ═══════════════════════════════════════════════════════════════════════════════

{@grade}
; Required fields first
student_id = !*:                                     ; Student identifier
course_code = !:                                     ; Course code
academic_term = !:                                   ; Term/semester

; Optional fields
section_id = :                                       ; Section identifier
instructor_id = :                                    ; Instructor who assigned grade

; Grade information
letter_grade = :                                     ; Letter grade (A, B, C, D, F, etc.)
numeric_grade = #:(0..100)                           ; Numeric grade (percentage)
grade_points = #:(0..)                               ; Grade points (for GPA calculation)
quality_points = #:(0..)                             ; Quality points earned

; Grade modifiers
plus_minus = :                                       ; Plus/minus modifier
pass_fail = ?                                        ; Pass/fail grade
incomplete = ?                                       ; Incomplete grade
in_progress = ?                                      ; In progress
withdrawn = ?                                        ; Withdrawn
audit = ?                                            ; Audit enrollment

; Credit
credit_hours = #:(0..)                               ; Credit hours
credits_earned = #:(0..)                             ; Credits earned
credits_attempted = #:(0..)                          ; Credits attempted

; Context
grade_type = (final, midterm, progress)              ; Grade type
posting_date = date                                  ; Date grade posted
effective_date = date                                ; Date grade effective

; ═══════════════════════════════════════════════════════════════════════════════
; GPA CALCULATION
; ═══════════════════════════════════════════════════════════════════════════════

{@gpa_summary}
; Required fields first
gpa = !#:(0..4)                                      ; Grade point average

; Optional fields
gpa_unweighted = #:(0..4)                            ; Unweighted GPA
gpa_weighted = #:(0..5)                              ; Weighted GPA
quality_points = #:(0..)                             ; Total quality points
credits_attempted = #:(0..)                          ; Total credits attempted
credits_earned = #:(0..)                             ; Total credits earned
credits_gpa = #:(0..)                                ; Credits included in GPA

; Context
gpa_type = (cumulative, institutional, major, overall, term, transfer)
calculation_date = date                              ; Date calculated

; ═══════════════════════════════════════════════════════════════════════════════
; TRANSCRIPT
; ═══════════════════════════════════════════════════════════════════════════════

{@transcript}
; Required fields first
student_id = !*:                                     ; Student identifier
issue_date = !date                                   ; Transcript issue date
status = (final, interim, official, unofficial)

; Optional fields
transcript_type = (academic, athletic_eligibility, disciplinary, official, unofficial)
sequence_number = ##                                 ; Transcript sequence number

; Institution
institution_id = :                                   ; Issuing institution
institution_name = :                                 ; Institution name

; Student information
student_name = @person_name                          ; Student name on transcript
student_id_displayed = :                             ; Student ID shown on transcript
date_of_birth = *date                                ; Birth date (optional, PII)

; Academic summary
enrollment_periods[] = @enrollment_record            ; Enrollment history
courses[] = @course_enrollment                       ; Course history
gpa_summary = @gpa_summary                           ; GPA summary

; Degrees and honors
degrees[] = @degree_conferral                        ; Degrees earned
honors[] = @academic_honor                           ; Academic honors

; Holds and restrictions
holds[] = :                                          ; Academic holds
restrictions = :                                     ; Transcript restrictions

; Authentication
registrar_signature = :                              ; Registrar signature
seal = ?                                             ; Official seal applied
electronic_signature = :                             ; Electronic signature
verification_code = :                                ; Verification code

; ═══════════════════════════════════════════════════════════════════════════════
; DEGREE REQUIREMENTS
; ═══════════════════════════════════════════════════════════════════════════════

{@degree_requirements}
; Required fields first
degree_type = !:                                     ; Degree type
program = !:                                         ; Program/major

; Optional fields
catalog_year = :                                     ; Catalog year for requirements
total_credits = #:(0..)                              ; Total credits required
minimum_gpa = #:(0..4)                               ; Minimum GPA required

; Core requirements
general_education_credits = #:(0..)                  ; General education credits
major_credits = #:(0..)                              ; Major credits required
elective_credits = #:(0..)                           ; Elective credits required

; Residency requirements
residency_credits = #:(0..)                          ; Credits required at institution
upper_division_credits = #:(0..)                     ; Upper division credits required

; Completion requirements
capstone_required = ?                                ; Capstone course required
thesis_required = ?                                  ; Thesis required
comprehensive_exam = ?                               ; Comprehensive exam required
internship_required = ?                              ; Internship required

; ═══════════════════════════════════════════════════════════════════════════════
; DEGREE CONFERRAL
; ═══════════════════════════════════════════════════════════════════════════════

{@degree_conferral}
; Required fields first
student_id = !*:                                     ; Student identifier
degree_type = !:                                     ; Degree type
conferral_date = !date                               ; Degree awarded date

; Optional fields
degree_title = :                                     ; Degree title
major = :                                            ; Primary major
minors[] = :                                         ; Minors
concentration = :                                    ; Concentration/specialization

; Institution
institution_id = :                                   ; Conferring institution
institution_name = :                                 ; Institution name

; Academic performance
final_gpa = #:(0..4)                                 ; Final GPA
total_credits = #:(0..)                              ; Total credits earned

; Honors
honors = (cum_laude, magna_cum_laude, none, summa_cum_laude)
honors_detail = :                                    ; Additional honors detail

; Completion
degree_status = (awarded, conferred, in_progress, pending)
completion_date = date                               ; Degree requirements completion date

; ═══════════════════════════════════════════════════════════════════════════════
; ACADEMIC HONOR
; ═══════════════════════════════════════════════════════════════════════════════

{@academic_honor}
; Required fields first
honor_type = !:                                      ; Honor/award type
title = !:                                           ; Honor title

; Optional fields
description = :                                      ; Honor description
date_awarded = date                                  ; Award date
academic_term = :                                    ; Term awarded
academic_year = :                                    ; Year awarded

; Common honor types
honor_category = (academic_achievement, community_service, deans_list, departmental, graduate_distinction, graduation_honors, national_honor_society, presidents_list, research, scholarship)

; Honor roll types
honor_roll_level = (a_honor_roll, a_b_honor_roll, deans_list, high_honors, honors, presidents_list)

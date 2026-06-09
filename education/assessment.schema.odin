; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Assessment Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Assessment and testing for K-12 and higher education including standardized
; tests (SAT, ACT, GRE), state assessments, college readiness, placement
; testing, and assessment accommodations.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types
@import "./student.schema.odin" as student

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.education.assessment"
version = "1.0.0"
title = "Assessment Schema"
description = "Standardized tests, state assessments, college readiness, and placement testing"

{$derivation}
source[0].authority = "U.S. Department of Education"
source[0].citation = "Elementary and Secondary Education Act (ESEA) - State Assessment Requirements"
source[0].url = "https://www.ed.gov/esea"
source[0].accessed = 2025-12-21

source[1].authority = "National Center for Education Statistics"
source[1].citation = "Common Education Data Standards (CEDS)"
source[1].url = "https://ceds.ed.gov/"
source[1].accessed = 2025-12-21

source[2].authority = "College Board"
source[2].citation = "SAT and AP Program Standards"
source[2].url = "https://www.collegeboard.org/"
source[2].accessed = 2025-12-21

source[3].authority = "ACT, Inc."
source[3].citation = "ACT Assessment Technical Manual"
source[3].url = "https://www.act.org/"
source[3].accessed = 2025-12-21

source[4].authority = "International Baccalaureate Organization"
source[4].citation = "IB Assessment Principles and Practice"
source[4].url = "https://www.ibo.org/"
source[4].accessed = 2025-12-21

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema derived from ESEA, CEDS, and public testing standards from College Board, ACT, and IB"

changelog[0].date = 2025-12-21
changelog[0].change = "Initial assessment schema"
changelog[0].rationale = "Comprehensive assessment structure covering state tests and college readiness per ESEA and CEDS"

; ═══════════════════════════════════════════════════════════════════════════════
; ASSESSMENT ADMINISTRATION
; ═══════════════════════════════════════════════════════════════════════════════

{@assessment}
; Required fields first
assessment_id = :                                   ; Assessment identifier
student_id = *:                                     ; Student identifier
test_date = date                                    ; Test administration date

; Optional fields
test_name = :                                        ; Test name
test_type = (achievement, aptitude, college_readiness, diagnostic, formative, placement, state_accountability, summative)
test_publisher = :                                   ; Test publisher/vendor
test_version = :                                     ; Test version/form

; Administration
academic_year = :                                    ; Academic year
academic_term = :                                    ; Academic term
grade_level = :                                      ; Grade when tested
school_year = :                                      ; School year

; Context
test_purpose = (accountability, admission, diagnostic, graduation, placement, proficiency, readiness, screening)
retest = ?                                           ; Retest/retake flag
attempt_number = ##:(1..)                            ; Attempt number

; Results
test_scores[] = @test_score                          ; Test scores
overall_score = #                                    ; Overall/composite score
percentile = ##:(1..99)                              ; National percentile
performance_level = :                                ; Performance level/band

; Accommodations
accommodations[] = @test_accommodation               ; Testing accommodations used

; Status
completed = ?                                        ; Test completed
invalidated = ?                                      ; Results invalidated
invalidation_reason = :                              ; Reason for invalidation

; ═══════════════════════════════════════════════════════════════════════════════
; TEST SCORE
; ═══════════════════════════════════════════════════════════════════════════════

{@test_score}
; Required fields first
subject = :                                         ; Subject/section tested

; Optional fields
scale_score = #                                      ; Scaled score
raw_score = #                                        ; Raw score
percentile = ##:(1..99)                              ; Percentile rank
performance_level = :                                ; Performance level
proficiency_level = (advanced, basic, below_basic, proficient)

; Score ranges
score_min = #                                        ; Minimum possible score
score_max = #                                        ; Maximum possible score
proficiency_cut_score = #                            ; Cut score for proficiency

; ═══════════════════════════════════════════════════════════════════════════════
; TEST ACCOMMODATION
; ═══════════════════════════════════════════════════════════════════════════════

{@test_accommodation}
; Required fields first
accommodation_type = :                              ; Accommodation type

; Optional fields
category = (assistive_technology, extended_time, presentation, response, scheduling, setting)
description = :                                      ; Detailed description
authorized_by = :                                    ; Authorization source (IEP, 504)

; ═══════════════════════════════════════════════════════════════════════════════
; SAT (SCHOLASTIC ASSESSMENT TEST)
; ═══════════════════════════════════════════════════════════════════════════════

{@sat_score}
; Required fields first
student_id = *:                                     ; Student identifier
test_date = date                                    ; Test date

; Optional fields
registration_number = *:                             ; SAT registration number

; Section scores (200-800 each)
evidence_based_reading_writing = ##:(200..800)       ; ERW section score
math = ##:(200..800)                                 ; Math section score

; Total score (400-1600)
total_score = ##:(400..1600)                         ; Total SAT score

; Subscores
reading = ##:(10..40)                                ; Reading subscore
writing_language = ##:(10..40)                       ; Writing and Language subscore
math_no_calculator = ##:(1..20)                      ; Math no calculator subscore
math_calculator = ##:(1..38)                         ; Math calculator subscore

; Cross-test scores
analysis_history_social_studies = ##:(10..40)
analysis_science = ##:(10..40)

; Essay (if taken)
essay_taken = ?
essay_reading = ##:(2..8):if essay_taken = true
essay_analysis = ##:(2..8):if essay_taken = true
essay_writing = ##:(2..8):if essay_taken = true

; Context
grade_level = :                                      ; Grade when tested
retest = ?                                           ; Retest flag

; ═══════════════════════════════════════════════════════════════════════════════
; ACT (AMERICAN COLLEGE TESTING)
; ═══════════════════════════════════════════════════════════════════════════════

{@act_score}
; Required fields first
student_id = *:                                     ; Student identifier
test_date = date                                    ; Test date

; Optional fields
registration_number = *:                             ; ACT registration number

; Section scores (1-36 each)
english = ##:(1..36)                                 ; English section score
math = ##:(1..36)                                    ; Math section score
reading = ##:(1..36)                                 ; Reading section score
science = ##:(1..36)                                 ; Science section score

; Composite score (1-36)
composite = ##:(1..36)                               ; Composite score

; STEM score
stem = ##:(1..36)                                    ; STEM score

; ELA score
ela = ##:(1..36)                                     ; ELA score

; Writing (if taken)
writing_taken = ?
writing_score = ##:(2..12):if writing_taken = true

; Context
grade_level = :                                      ; Grade when tested
retest = ?                                           ; Retest flag

; ═══════════════════════════════════════════════════════════════════════════════
; AP (ADVANCED PLACEMENT)
; ═══════════════════════════════════════════════════════════════════════════════

{@ap_score}
; Required fields first
student_id = *:                                     ; Student identifier
exam_date = date                                    ; Exam date
subject = :                                         ; AP subject/exam

; Optional fields
ap_number = *:                                       ; AP number

; Score (1-5)
score = ##:(1..5)                                    ; AP exam score
qualified_for_credit = ?                             ; Score 3+ (college credit eligible)

; Course enrollment
enrolled_in_ap_course = ?                            ; Enrolled in AP course
course_section = :                                   ; Course section identifier

; ═══════════════════════════════════════════════════════════════════════════════
; IB (INTERNATIONAL BACCALAUREATE)
; ═══════════════════════════════════════════════════════════════════════════════

{@ib_score}
; Required fields first
student_id = *:                                     ; Student identifier
exam_date = date                                    ; Exam date
subject = :                                         ; IB subject

; Optional fields
ib_candidate_number = *:                             ; IB candidate number

; Level
level = (higher_level, standard_level)

; Score (1-7)
score = ##:(1..7)                                    ; IB exam score

; Diploma
diploma_candidate = ?                                ; IB Diploma candidate
diploma_awarded = ?                                  ; IB Diploma awarded
diploma_points = ##:(0..45)                          ; Total diploma points

; Theory of Knowledge and Extended Essay
tok_grade = (A, B, C, D, E)
ee_grade = (A, B, C, D, E)
bonus_points = ##:(0..3)                             ; TOK/EE bonus points

; ═══════════════════════════════════════════════════════════════════════════════
; CLEP (COLLEGE LEVEL EXAMINATION PROGRAM)
; ═══════════════════════════════════════════════════════════════════════════════

{@clep_score}
; Required fields first
student_id = *:                                     ; Student identifier
exam_date = date                                    ; Exam date
exam_name = :                                       ; CLEP exam name

; Optional fields
scaled_score = ##:(20..80)                           ; Scaled score
recommended_credit_score = ##                        ; ACE recommended score
credit_recommended = ?                               ; Met ACE recommendation
semester_hours_recommended = ##:(0..)                ; Recommended semester hours

; ═══════════════════════════════════════════════════════════════════════════════
; GRE (GRADUATE RECORD EXAMINATION)
; ═══════════════════════════════════════════════════════════════════════════════

{@gre_score}
; Required fields first
student_id = *:                                     ; Student identifier
test_date = date                                    ; Test date

; Optional fields
registration_number = *:                             ; GRE registration number

; Section scores
verbal_reasoning = ##:(130..170)                     ; Verbal Reasoning (130-170)
quantitative_reasoning = ##:(130..170)               ; Quantitative Reasoning (130-170)
analytical_writing = #:(0..6)                        ; Analytical Writing (0-6)

; Subject test (if taken)
subject_test_taken = ?
subject_test_name = :if subject_test_taken = true
subject_test_score = ##:(200..990):if subject_test_taken = true

; ═══════════════════════════════════════════════════════════════════════════════
; GMAT (GRADUATE MANAGEMENT ADMISSION TEST)
; ═══════════════════════════════════════════════════════════════════════════════

{@gmat_score}
; Required fields first
student_id = *:                                     ; Student identifier
test_date = date                                    ; Test date

; Optional fields
registration_number = *:                             ; GMAT registration number

; Section scores
quantitative = ##:(6..51)                            ; Quantitative (6-51)
verbal = ##:(6..51)                                  ; Verbal (6-51)
integrated_reasoning = ##:(1..8)                     ; Integrated Reasoning (1-8)
analytical_writing = #:(0..6)                        ; Analytical Writing (0-6)

; Total score (200-800)
total_score = ##:(200..800)                          ; Total GMAT score

; Percentiles
quantitative_percentile = ##:(0..99)
verbal_percentile = ##:(0..99)
total_percentile = ##:(0..99)

; ═══════════════════════════════════════════════════════════════════════════════
; STATE ASSESSMENT
; ═══════════════════════════════════════════════════════════════════════════════

{@state_assessment}
; Required fields first
student_id = *:                                     ; Student identifier
test_date = date                                    ; Test date
subject = :                                         ; Subject tested
grade_level = :                                     ; Grade level tested

; Optional fields
state = :(2)                                         ; State (for state-specific tests)
test_name = :                                        ; State test name
assessment_type = (accountability, diagnostic, formative, summative)

; Scores
scale_score = #                                      ; Scaled score
raw_score = #                                        ; Raw score
performance_level = :                                ; Performance level
proficiency_level = (advanced, basic, below_basic, proficient)
met_standard = ?                                     ; Met proficiency standard

; Context
academic_year = :                                    ; Academic year
testing_window = :                                   ; Testing window/period
retest = ?                                           ; Retest flag

; Accommodations
accommodations[] = @test_accommodation

; ═══════════════════════════════════════════════════════════════════════════════
; PLACEMENT TEST
; ═══════════════════════════════════════════════════════════════════════════════

{@placement_test}
; Required fields first
student_id = *:                                     ; Student identifier
test_date = date                                    ; Test date
subject = :                                         ; Subject area

; Optional fields
test_name = :                                        ; Placement test name
test_publisher = :                                   ; Test publisher

; Scores
score = #                                            ; Score achieved
percentile = ##:(1..99)                              ; Percentile rank

; Placement
placement_level = :                                  ; Recommended placement level
course_recommendation = :                            ; Recommended course
remediation_required = ?                             ; Remediation needed

; Retesting
retest_allowed = ?                                   ; Retest permitted
retest_date = date                                   ; Earliest retest date

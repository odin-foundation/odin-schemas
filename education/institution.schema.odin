; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Institution Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Educational institutions for K-12 and higher education including institution
; profiles, accreditation, academic programs, Title IV eligibility, and IPEDS
; reporting identifiers.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.education.institution"
version = "1.0.0"
title = "Institution Schema"
description = "Educational institution profile, accreditation, programs, and Title IV compliance"

{$derivation}
source[0].authority = "National Center for Education Statistics"
source[0].citation = "Integrated Postsecondary Education Data System (IPEDS)"
source[0].url = "https://nces.ed.gov/ipeds/"
source[0].accessed = 2025-12-21

source[1].authority = "U.S. Department of Education"
source[1].citation = "34 CFR Part 600 - Institutional Eligibility Under the Higher Education Act"
source[1].url = "https://www.ecfr.gov/current/title-34/subtitle-B/chapter-VI/part-600"
source[1].accessed = 2025-12-21

source[2].authority = "U.S. Department of Education"
source[2].citation = "Database of Accredited Postsecondary Institutions and Programs"
source[2].url = "https://ope.ed.gov/dapip/"
source[2].accessed = 2025-12-21

source[3].authority = "National Center for Education Statistics"
source[3].citation = "Common Education Data Standards (CEDS)"
source[3].url = "https://ceds.ed.gov/"
source[3].accessed = 2025-12-21

source[4].authority = "Council for Higher Education Accreditation"
source[4].citation = "CHEA Database of Institutions and Programs Accredited by Recognized Accrediting Organizations"
source[4].url = "https://www.chea.org/"
source[4].accessed = 2025-12-21

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema derived from IPEDS, Title IV Part 600, DAPIP, CEDS, and CHEA standards"

changelog[0].date = 2025-12-21
changelog[0].change = "Initial institution schema"
changelog[0].rationale = "Institutional profile and compliance per IPEDS and Title IV regulations"

; ═══════════════════════════════════════════════════════════════════════════════
; INSTITUTION PROFILE
; ═══════════════════════════════════════════════════════════════════════════════

{@institution}
; Required fields first
institution_id = :                                  ; Institution identifier
name = :                                            ; Institution name

; Optional fields
legal_name = :                                       ; Legal name
former_names[] = :                                   ; Previous names

; Federal identifiers
ipeds_id = :(6)                                      ; IPEDS Unit ID
opeid = :(8)                                         ; Office of Postsecondary Education ID
opeid_6 = :(6)                                       ; OPEID 6-digit
nces_id = :                                          ; NCES School ID (K-12)
federal_ein = *:format ein                     ; Federal EIN (PII)

; State identifiers
state_institution_id = :                             ; State-assigned ID
state_approval_number = :                            ; State approval number

; Institution type
institution_type = (private_for_profit, private_nonprofit, public)
level = (four_or_more_years, less_than_two_years, postsecondary, two_but_less_than_four_years)
control = (private_for_profit, private_nonprofit, public)

; K-12 classifications
school_type = (charter, magnet, private, public, virtual):if level = k12
grade_span_lowest = :                                ; Lowest grade (K-12)
grade_span_highest = :                               ; Highest grade (K-12)

; Higher education classifications
carnegie_classification = :                          ; Carnegie Classification
degree_granting = ?                                  ; Degree-granting institution
primarily_postsecondary = ?                          ; Primarily postsecondary

; Location
{.primary_address}
= @address
mailing_address = @address

; Contact
website = :                                          ; Institution website
main_phone = @phone                                  ; Main phone number
admissions_email = @email                            ; Admissions email

; Dates
founded = date                                       ; Year founded
opened = date                                        ; Date opened
closed = date                                        ; Date closed (if applicable)

; Status
status = (active, closed, inactive, merged)
currently_operating = ?                              ; Currently operating

; Geographic
urbanicity = (city, rural, suburb, town)             ; Urban-centric locale
locale_code = :                                      ; NCES locale code

; ═══════════════════════════════════════════════════════════════════════════════
; ACCREDITATION
; ═══════════════════════════════════════════════════════════════════════════════

{@accreditation}
; Required fields first
accreditor_name = :                                 ; Accrediting agency name
accreditation_type = (national, programmatic, regional, specialized)
status = (accredited, candidate, preaccredited, probation, show_cause, unaccredited, warning)

; Optional fields
accreditor_id = :                                    ; Accreditor identifier
accreditor_agency = :                                ; Full agency name

; Accreditation scope
scope = (institutional, programmatic)
program_name = :if scope = programmatic              ; Program name if programmatic
cip_code = :(2..7):if scope = programmatic          ; CIP code if programmatic

; Dates
initial_accreditation = date                         ; Initial accreditation date
current_accreditation = date                         ; Current accreditation date
reaffirmation_date = date                            ; Last reaffirmation
next_review = date                                   ; Next review date

; Status details
probation_start = date:if status = probation
probation_reason = :if status = probation
show_cause_date = date:if status = show_cause
show_cause_reason = :if status = show_cause

; Recognition
chea_recognized = ?                                  ; CHEA recognized
doe_recognized = ?                                   ; US Department of Education recognized

; ═══════════════════════════════════════════════════════════════════════════════
; ACADEMIC PROGRAM
; ═══════════════════════════════════════════════════════════════════════════════

{@academic_program}
; Required fields first
program_id = :                                      ; Program identifier
program_name = :                                    ; Program name

; Optional fields
program_description = :                              ; Program description

; Classification
cip_code = :(2..7)                                   ; Classification of Instructional Programs
credential_level = (associate, bachelor, certificate, doctoral, master, post_baccalaureate_certificate, post_master_certificate, professional)
credential_type = :                                  ; Type of credential awarded

; Program details
degree_type = :                                      ; Specific degree type
major = :                                            ; Major/concentration
program_length = :                                   ; Normal time to complete
credits_required = #:(0..)                           ; Credits required

; Delivery
delivery_mode = (distance_education, hybrid, in_person)
online_option = ?                                    ; Available online
part_time_option = ?                                 ; Available part-time
evening_weekend_option = ?                           ; Evening/weekend option

; Accreditation
programmatic_accreditation = ?                       ; Programmatically accredited
accreditor_name = :if programmatic_accreditation = true

; Enrollment
enrollment_count = ##:(0..)                          ; Current enrollment
enrollment_capacity = ##:(0..)                       ; Maximum enrollment

; Status
active = ?                                           ; Currently active
accepting_applications = ?                           ; Accepting new students

; Completions (IPEDS)
completions_annual = ##:(0..)                        ; Annual completions
completions_last_year = ##:(0..)                     ; Last year completions

; ═══════════════════════════════════════════════════════════════════════════════
; TITLE IV ELIGIBILITY
; ═══════════════════════════════════════════════════════════════════════════════

{@title_iv_eligibility}
; Required fields first
institution_id = :                                  ; Institution identifier
eligible = ?                                        ; Eligible for Title IV programs

; Optional fields
eligibility_date = date                              ; Date of eligibility
eligibility_end_date = date                          ; End date if limited

; Program Participation Agreement
ppa_signed = ?                                       ; PPA signed
ppa_effective_date = date                            ; PPA effective date
ppa_expiration_date = date                           ; PPA expiration date

; Eligible programs
pell_grant = ?                                       ; Pell Grant
fseog = ?                                            ; FSEOG
federal_work_study = ?                               ; Federal Work-Study
direct_loan = ?                                      ; Direct Loan Program
direct_plus = ?                                      ; Direct PLUS Loan
teach_grant = ?                                      ; TEACH Grant

; Cohort default rate
cohort_default_rate = #:(0..100)                     ; 3-year cohort default rate
cdr_year = :                                         ; CDR fiscal year
cdr_sanction = ?                                     ; Under CDR sanctions
cdr_provisional = ?                                  ; Provisional certification

; Financial responsibility
composite_score = #                                  ; Financial responsibility composite score
financially_responsible = ?                          ; Meets financial responsibility

; Compliance
hcm2_status = (fully_certified, provisionally_certified, reapplication_required)
heightened_cash_monitoring_1 = ?                     ; HCM1 status
heightened_cash_monitoring_2 = ?                     ; HCM2 status
letter_of_credit_required = ?                        ; LOC required
letter_of_credit_amount = #$:(0..)

; Audit
most_recent_audit_date = date                        ; Most recent audit date
audit_findings = ?                                   ; Audit findings
program_review = ?                                   ; Under program review
program_review_date = date

; Sanctions
sanctions_active = ?                                 ; Active sanctions
sanction_description = :                             ; Sanction details
limitation_suspension_termination = ?                ; LST action

; ═══════════════════════════════════════════════════════════════════════════════
; CAMPUS / LOCATION
; ═══════════════════════════════════════════════════════════════════════════════

{@campus}
; Required fields first
campus_id = :                                       ; Campus identifier
institution_id = :                                  ; Parent institution ID
campus_name = :                                     ; Campus name

; Optional fields
campus_type = (additional_location, branch_campus, main_campus, online)

; Federal IDs
ipeds_id = :(6)                                      ; IPEDS Unit ID (if separate)
opeid = :(8)                                         ; OPEID (if separate)

; Location
address = @address                                   ; Campus address

; Contact
phone = @phone                                       ; Campus phone
email = @email                                       ; Campus email
website = :                                          ; Campus website

; Programs offered
programs[] = :                                       ; Program IDs offered at campus
degree_granting = ?                                  ; Degrees conferred at campus

; Enrollment
enrollment_count = ##:(0..)                          ; Campus enrollment

; Status
active = ?                                           ; Currently active
opened = date                                        ; Campus opened date
closed = date                                        ; Campus closed date

; ═══════════════════════════════════════════════════════════════════════════════
; ENROLLMENT STATISTICS
; ═══════════════════════════════════════════════════════════════════════════════

{@enrollment_statistics}
; Required fields first
institution_id = :                                  ; Institution identifier
academic_year = :                                   ; Academic year

; Optional fields
fall_enrollment = ##:(0..)                           ; Fall enrollment
spring_enrollment = ##:(0..)                         ; Spring enrollment
summer_enrollment = ##:(0..)                         ; Summer enrollment

; Full-time/part-time
full_time = ##:(0..)                                 ; Full-time enrollment
part_time = ##:(0..)                                 ; Part-time enrollment

; Level
undergraduate = ##:(0..)                             ; Undergraduate enrollment
graduate = ##:(0..)                                  ; Graduate enrollment

; Gender
male = ##:(0..)                                      ; Male enrollment
female = ##:(0..)                                    ; Female enrollment

; Race/ethnicity (IPEDS categories)
american_indian_alaska_native = ##:(0..)
asian = ##:(0..)
black_african_american = ##:(0..)
hispanic_latino = ##:(0..)
native_hawaiian_pacific_islander = ##:(0..)
white = ##:(0..)
two_or_more_races = ##:(0..)
race_ethnicity_unknown = ##:(0..)
nonresident_alien = ##:(0..)

; Age
under_18 = ##:(0..)
age_18_24 = ##:(0..)
age_25_39 = ##:(0..)
age_40_plus = ##:(0..)

; First-time students
first_time_degree_seeking = ##:(0..)
first_time_first_year = ##:(0..)

; ═══════════════════════════════════════════════════════════════════════════════
; COMPLETIONS STATISTICS
; ═══════════════════════════════════════════════════════════════════════════════

{@completions_statistics}
; Required fields first
institution_id = :                                  ; Institution identifier
academic_year = :                                   ; Academic year

; Optional fields
total_completions = ##:(0..)                         ; Total completions/awards

; By level
certificates = ##:(0..)                              ; Certificates awarded
associate_degrees = ##:(0..)                         ; Associate degrees
bachelor_degrees = ##:(0..)                          ; Bachelor degrees
master_degrees = ##:(0..)                            ; Master degrees
doctoral_degrees = ##:(0..)                          ; Doctoral degrees
professional_degrees = ##:(0..)                      ; Professional degrees

; By gender
male_completions = ##:(0..)
female_completions = ##:(0..)

; By race/ethnicity (IPEDS)
american_indian_alaska_native_completions = ##:(0..)
asian_completions = ##:(0..)
black_african_american_completions = ##:(0..)
hispanic_latino_completions = ##:(0..)
native_hawaiian_pacific_islander_completions = ##:(0..)
white_completions = ##:(0..)
two_or_more_races_completions = ##:(0..)
race_ethnicity_unknown_completions = ##:(0..)
nonresident_alien_completions = ##:(0..)

; Distance education
distance_education_completions = ##:(0..)

; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Employment Compliance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Employment compliance reporting including EEO-1, VETS-4212, Affirmative
; Action Plans, OSHA recordkeeping, workplace investigations, and ACA
; reporting (1094-C, 1095-C).
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.employment.compliance"
version = "1.0.0"
title = "Employment Compliance Schema"
description = "EEO-1, VETS-4212, AAP, OSHA, investigations, and ACA reporting"

{$derivation}
source[0].authority = "U.S. Equal Employment Opportunity Commission"
source[0].citation = "EEO-1 Component 1 Report Instructions"
source[0].url = "https://www.eeoc.gov/employers/eeo-data-collections"

source[1].authority = "Office of Federal Contract Compliance Programs"
source[1].citation = "VETS-4212 Federal Contractor Veterans' Employment Report"
source[1].url = "https://www.law.cornell.edu/uscode/text/38/4212"

source[2].authority = "Office of Federal Contract Compliance Programs"
source[2].citation = "Affirmative Action Program Requirements, 41 CFR Part 60-2"
source[2].url = "https://www.ecfr.gov/current/title-41/subtitle-B/chapter-60"

source[3].authority = "Occupational Safety and Health Administration"
source[3].citation = "OSHA Recordkeeping Requirements, 29 CFR Part 1904"
source[3].url = "https://www.osha.gov/recordkeeping"

source[4].authority = "Internal Revenue Service"
source[4].citation = "ACA Reporting Forms 1094-C and 1095-C"
source[4].url = "https://www.irs.gov/affordable-care-act/employers/questions-and-answers-about-information-reporting-by-employers-on-form-1094-c-and-form-1095-c"

source[5].authority = "U.S. Department of Labor"
source[5].citation = "Family and Medical Leave Act (FMLA) Recordkeeping, 29 CFR 825"
source[5].url = "https://www.ecfr.gov/current/title-29/subtitle-B/chapter-V/subchapter-C/part-825"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial employment compliance schema"
changelog[0].rationale = "EEO-1, VETS-4212, AAP, OSHA, ACA reporting derived from EEOC, OFCCP, OSHA, and IRS requirements"

; ═══════════════════════════════════════════════════════════════════════════════
; EEO-1 REPORT
; ═══════════════════════════════════════════════════════════════════════════════

{@eeo1_report}
= @types.audit_info

report_id = :                                   ; Unique report identifier
filing_year = ##:(2000..)                       ; Reporting year
snapshot_date = date                            ; Snapshot date (typically 12/31)
report_type = (consolidated, headquarters, multi_establishment, single_establishment)

; Company information
company_name = :                                ; Legal company name
duns_number = :                                  ; D-U-N-S number
employer_id_number = *:                          ; EIN (confidential)
naics_code = :                                  ; NAICS code

; Establishment information
establishment_name = :                           ; Establishment name
establishment_address = @types.address           ; Establishment address
establishment_number = :                         ; Establishment number

; EEO-1 Component 1 - Job Categories x Race/Ethnicity/Sex
{.job_categories[]}
job_category = (
    administrative_support,
    craft_workers,
    executive_senior_officials,
    first_mid_officials_managers,
    laborers_helpers,
    operatives,
    professionals,
    sales_workers,
    service_workers,
    technicians
)

; Race/ethnicity/sex breakdown
{.hispanic_latino}
male = ##:(0..)
female = ##:(0..)

{@eeo1_report.job_categories[]}

{.not_hispanic_latino}
white_male = ##:(0..)
white_female = ##:(0..)
black_african_american_male = ##:(0..)
black_african_american_female = ##:(0..)
native_hawaiian_pacific_islander_male = ##:(0..)
native_hawaiian_pacific_islander_female = ##:(0..)
asian_male = ##:(0..)
asian_female = ##:(0..)
american_indian_alaska_native_male = ##:(0..)
american_indian_alaska_native_female = ##:(0..)
two_or_more_races_male = ##:(0..)
two_or_more_races_female = ##:(0..)

{@eeo1_report.job_categories[]}

category_total = ##:(0..)                       ; Category total

{@eeo1_report}

; Totals
total_employees = ##:(0..)                      ; Total employees in report
total_male = ##:(0..)                            ; Total male employees
total_female = ##:(0..)                          ; Total female employees

; Filing information
filed_date = date                                ; Date filed with EEOC
filed_by = :                                     ; Who filed
filing_method = (electronic, paper)              ; Filing method
confirmation_number = :                          ; EEOC confirmation

status = (certified, draft, filed, pending)      ; Report status

; ═══════════════════════════════════════════════════════════════════════════════
; VETS-4212 REPORT
; ═══════════════════════════════════════════════════════════════════════════════

{@vets4212_report}
= @types.audit_info

report_id = :                                   ; Unique report identifier
reporting_period_from = date                    ; Period start (Aug 1)
reporting_period_to = date                      ; Period end (Jul 31)
filing_year = ##:(2000..)                       ; Filing year

; Company information
company_name = :                                ; Legal company name
duns_number = :                                  ; D-U-N-S number
employer_id_number = *:                          ; EIN (confidential)
naics_code = :                                  ; NAICS code
employee_count = ##:(100..)                     ; Total employees (100+ threshold)

; Hiring location
hiring_location_address = @types.address         ; Hiring location

; Veterans hired during period
{.veterans_hired}
total_hires = ##:(0..)                          ; Total new hires

; Veteran categories hired
protected_veterans = ##:(0..)                   ; Protected veterans hired
special_disabled = ##:(0..)                      ; Special disabled veterans
other_protected = ##:(0..)                       ; Other protected veterans
armed_forces_service_medal = ##:(0..)            ; Armed Forces Service Medal veterans
recently_separated = ##:(0..)                    ; Recently separated veterans

{@vets4212_report}

; Maximum/minimum employees
maximum_employees = ##:(0..)                    ; Max employees during period
minimum_employees = ##:(0..)                    ; Min employees during period

; Filing information
filed_date = date                                ; Date filed
filed_by = :                                     ; Who filed
filing_method = (electronic, paper)              ; Filing method
confirmation_number = :                          ; VETS confirmation

status = (certified, draft, filed, pending)      ; Report status

; ═══════════════════════════════════════════════════════════════════════════════
; AFFIRMATIVE ACTION PLAN (AAP)
; ═══════════════════════════════════════════════════════════════════════════════

{@affirmative_action_plan}
= @types.audit_info

aap_id = :                                      ; Unique AAP identifier
plan_year = ##:(2000..)                         ; Plan year
effective_date = date                           ; Plan effective date
plan_period_start = date                        ; Plan period start
plan_period_end = date                          ; Plan period end

; Company information
company_name = :                                ; Legal company name
establishment_name = :                           ; Establishment name
establishment_address = @types.address           ; Establishment address

; Organizational profile
{.organizational_display}
job_group = :                                   ; Job group name
total_employees = ##:(0..)                      ; Total in job group
male = ##:(0..)                                  ; Male employees
female = ##:(0..)                                ; Female employees
minorities = ##:(0..)                            ; Minority employees
white = ##:(0..)                                 ; White employees

{@affirmative_action_plan}

; Job group analysis
{.job_groups[]}
job_group_name = :                              ; Job group name
job_titles[] = :                                 ; Job titles in group

; Availability analysis
{.availability}
internal_availability_female = #:(0..100)       ; Internal female availability %
internal_availability_minority = #:(0..100)     ; Internal minority availability %
external_availability_female = #:(0..100)       ; External female availability %
external_availability_minority = #:(0..100)     ; External minority availability %
weighted_availability_female = #:(0..100)       ; Weighted female availability %
weighted_availability_minority = #:(0..100)     ; Weighted minority availability %

{@affirmative_action_plan.job_groups[]}

; Current workforce
{.current_workforce}
total = ##:(0..)                                ; Total in job group
female_count = ##:(0..)                          ; Female count
female_percent = #:(0..100)                      ; Female percentage
minority_count = ##:(0..)                        ; Minority count
minority_percent = #:(0..100)                    ; Minority percentage

{@affirmative_action_plan.job_groups[]}

; Utilization analysis
underutilization_female = ?                      ; Female underutilization
underutilization_minority = ?                    ; Minority underutilization
placement_goal_female = #:(0..100):if underutilization_female = true
placement_goal_minority = #:(0..100):if underutilization_minority = true

{@affirmative_action_plan}

; Good faith efforts
{.good_faith_efforts[]}
effort_description = :                          ; Description of effort
responsible_party = :                            ; Who is responsible
target_completion_date = date                    ; Target date
completed = ?                                    ; Effort completed
completion_date = date                           ; Completion date

{@affirmative_action_plan}

; Certification
aap_officer_name = :                            ; AAP officer name
aap_officer_title = :                           ; AAP officer title
certification_date = date                        ; Certification date

status = (active, approved, draft, under_review) ; AAP status

; ═══════════════════════════════════════════════════════════════════════════════
; OSHA LOG (Form 300)
; ═══════════════════════════════════════════════════════════════════════════════

{@osha_log}
= @types.audit_info

log_id = :                                      ; Unique log identifier
calendar_year = ##:(2000..)                     ; Calendar year
establishment_name = :                          ; Establishment name
establishment_address = @types.address           ; Establishment address
naics_code = :                                  ; NAICS code
annual_average_employees = ##:(0..)              ; Annual average employees
total_hours_worked = ##:(0..)                    ; Total hours worked by all employees

; Incidents/injuries
{.incidents[]}
case_number = :                                 ; OSHA case number
employee_name = *:                               ; Employee name (confidential)
job_title = :                                    ; Job title
incident_date = date                            ; Date of injury/illness
incident_time = time                             ; Time of injury/illness
location = :                                     ; Where event occurred

; Injury/illness classification
classify_case = (death, days_away_from_work, job_transfer_restriction, other_recordable)
injury_or_illness = (illness, injury)           ; Injury or illness

; Illness category
illness_category = (
    hearing_loss,
    poisoning,
    respiratory_condition,
    skin_disorder,
    all_other_illnesses
):if injury_or_illness = illness

; Injury type
injury_type = :if injury_or_illness = injury     ; Nature of injury

description = :                                 ; Brief description of incident
body_part_affected = :                           ; Body part affected
object_substance = :                             ; Object/substance involved

; Days away/restricted
days_away_from_work = ##:(0..)                   ; Days away from work
days_job_transfer_restriction = ##:(0..)         ; Days on restricted duty
death_date = date:if classify_case = death       ; Date of death if applicable

privacy_case = ?                                 ; Privacy concern case

{@osha_log}

; Annual summary (Form 300A)
{.annual_summary}
total_deaths = ##:(0..)                          ; Total deaths
total_days_away_cases = ##:(0..)                 ; Total DAFW cases
total_job_transfer_cases = ##:(0..)              ; Total DJTR cases
total_other_recordable_cases = ##:(0..)          ; Total other cases
total_days_away = ##:(0..)                       ; Total days away
total_days_restricted = ##:(0..)                 ; Total days restricted

total_injuries = ##:(0..)                        ; Total injuries
total_skin_disorders = ##:(0..)                  ; Total skin disorders
total_respiratory_conditions = ##:(0..)          ; Total respiratory conditions
total_poisonings = ##:(0..)                      ; Total poisonings
total_hearing_loss = ##:(0..)                    ; Total hearing loss cases
total_other_illnesses = ##:(0..)                 ; Total all other illnesses

summary_prepared_by = :                          ; Who prepared summary
summary_date = date                              ; Date summary prepared
company_executive = :                            ; Company executive name
executive_title = :                              ; Executive title
executive_signature_date = date                  ; Executive signature date

{@osha_log}

posted_date = date                               ; Date posted (Feb 1 - Apr 30)
removed_date = date                              ; Date removed

; ═══════════════════════════════════════════════════════════════════════════════
; WORKPLACE INVESTIGATION
; ═══════════════════════════════════════════════════════════════════════════════

{@workplace_investigation}
= @types.audit_info

investigation_id = :                            ; Unique investigation identifier
case_number = :                                  ; Internal case number
investigation_type = (complaint, discrimination, harassment, policy_violation, retaliation, safety_incident, theft, violence, whistleblower)

; Complaint information
complaint_date = date                           ; Date complaint received
complaint_method = (email, hotline, in_person, letter, online_form)
complainant_employee_id = :                      ; Complainant (if employee)
complainant_name = *:                            ; Complainant name (confidential)
complainant_anonymous = ?                        ; Anonymous complaint

; Allegation details
allegation_summary = *:                         ; Summary of allegations (confidential)
alleged_violation_category = (
    discrimination_age,
    discrimination_disability,
    discrimination_gender,
    discrimination_national_origin,
    discrimination_race,
    discrimination_religion,
    harassment_hostile_environment,
    harassment_quid_pro_quo,
    harassment_sexual,
    policy_violation,
    retaliation,
    safety_violation,
    theft_fraud,
    violence_threat
)
alleged_violation_date = date                    ; Date of alleged incident

; Parties involved
{.respondents[]}
:(1..)                                           ; At least one respondent
respondent_employee_id = :                       ; Respondent employee ID
respondent_name = *:                             ; Respondent name (confidential)
respondent_title = :                             ; Job title
respondent_department = :                        ; Department

{@workplace_investigation}

{.witnesses[]}
witness_employee_id = :                          ; Witness employee ID
witness_name = *:                                ; Witness name (confidential)
witness_statement_taken = ?                      ; Statement taken
statement_date = date                            ; Statement date

{@workplace_investigation}

; Investigation process
investigation_start_date = date                 ; Investigation start
investigator_name = :                           ; Investigator(s)
investigator_external = ?                        ; External investigator
investigation_firm = :if investigator_external = true

{.investigation_steps[]}
step_date = date                                ; Step date
step_type = (document_review, interview, policy_review, site_visit)
step_description = :                             ; Description
conducted_by = :                                 ; Who conducted

{@workplace_investigation}

investigation_completed_date = date              ; Investigation complete date

; Findings
findings_summary = *:                            ; Summary of findings (confidential)
allegations_substantiated = ?                    ; Allegations substantiated
policy_violated = ?                              ; Policy violation found
law_violated = ?                                 ; Law violation found

; Disciplinary action
{.disciplinary_actions[]}
employee_id = :                                 ; Employee disciplined
action_type = (coaching, demotion, final_warning, suspension, termination, written_warning)
action_date = date                              ; Action date
action_description = *:                          ; Description (confidential)

{@workplace_investigation}

; Corrective measures
{.corrective_measures[]}
measure_description = :                         ; Corrective measure
responsible_party = :                            ; Who is responsible
target_completion = date                         ; Target date
completed = ?                                    ; Measure completed
completion_date = date                           ; Completion date

{@workplace_investigation}

; Report and closure
report_prepared = ?                              ; Investigation report prepared
report_date = date                               ; Report date
report_document = @types.document_reference      ; Report document

complainant_notified = ?                         ; Complainant notified of outcome
notification_date = date                         ; Notification date

case_closed = ?                                  ; Case closed
case_closed_date = date                          ; Closure date

status = (closed, in_progress, on_hold, pending)

; ═══════════════════════════════════════════════════════════════════════════════
; ACA 1095-C REPORT (EMPLOYEE)
; ═══════════════════════════════════════════════════════════════════════════════

{@aca_1095c}
= @types.audit_info

form_1095c_id = :                               ; Unique form identifier
employee_id = :                                 ; Associated employee
tax_year = ##:(2000..)                          ; Tax year

; Part I - Employee
employee_name = :                               ; Employee name
employee_ssn = *:format ssn                     ; SSN (confidential)
employee_address = @types.address                ; Employee address

; Part II - Employer Offer of Coverage
{.monthly_offers[]}
:(12)                                            ; 12 months required
month = (january, february, march, april, may, june, july, august, september, october, november, december)

; Line 14 - Offer of Coverage
offer_code = (
    code_1a, code_1b, code_1c, code_1d, code_1e, code_1f, code_1g, code_1h, code_1j, code_1k,
    code_2a, code_2b, code_2c, code_2d, code_2e, code_2f, code_2g, code_2h, code_2i
)

; Line 15 - Employee Required Contribution
employee_contribution = #$:(0..)                 ; Employee share of lowest cost coverage

; Line 16 - Section 4980H Safe Harbor
safe_harbor_code = (
    code_2a, code_2b, code_2c, code_2d, code_2e, code_2f, code_2g, code_2h, code_2i
)

{@aca_1095c}

; Part III - Covered Individuals (if applicable)
{.covered_individuals[]}
individual_name = :                             ; Name of covered individual
ssn = *:format ssn                               ; SSN (confidential)
dob = *date                                      ; Date of birth (confidential)
covered_all_12_months = ?                        ; Covered all 12 months
months_covered[] = (january, february, march, april, may, june, july, august, september, october, november, december)

{@aca_1095c}

; Filing information
filed_with_irs = ?                               ; Filed with IRS
filed_date = date                                ; Filing date
provided_to_employee = ?                         ; Provided to employee
provided_date = date                             ; Date provided to employee
correction = ?                                   ; Correction form
corrects_form_id = :if correction = true         ; Original form being corrected

; ═══════════════════════════════════════════════════════════════════════════════
; ACA 1094-C REPORT (EMPLOYER)
; ═══════════════════════════════════════════════════════════════════════════════

{@aca_1094c}
= @types.audit_info

form_1094c_id = :                               ; Unique form identifier
tax_year = ##:(2000..)                          ; Tax year

; Part I - Applicable Large Employer (ALE) Member Information
employer_name = :                               ; Legal employer name
employer_ein = *:                               ; EIN (confidential)
employer_address = @types.address                ; Employer address
contact_name = :                                ; Contact person name
contact_phone = :                               ; Contact phone

; Part II - ALE Member Information
{.monthly_information[]}
:(12)                                            ; 12 months required
month = (january, february, march, april, may, june, july, august, september, october, november, december)
minimum_essential_coverage = ?                   ; Offered MEC
full_time_employee_count = ##:(0..)             ; Full-time employee count
total_employee_count = ##:(0..)                  ; Total employee count

{@aca_1094c}

; Part III - Aggregated Group Information
aggregated_group = ?                             ; Part of aggregated ALE group
authoritative_transmittal = ?:if aggregated_group = true ; Authoritative transmittal

; Part IV - Other Information
{.transition_relief}
section_4980h_transition_relief = ?              ; Section 4980H transition relief
relief_indicator = :if section_4980h_transition_relief = true

{@aca_1094c}

total_1095c_forms = ##:(0..)                    ; Total 1095-C forms transmitted

filed_with_irs = ?                               ; Filed with IRS
filed_date = date                                ; Filing date

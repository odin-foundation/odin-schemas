; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Employment Practices Liability Insurance (EPLI) Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Employment Practices Liability Insurance (EPLI) covering wrongful termination,
; discrimination, sexual harassment, retaliation, and wage/hour claims under
; Title VII, ADA, ADEA, FMLA, FLSA, and state employment laws.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as com
@import "../business.schema.odin" as entity
@import "../business-location.schema.odin" as location

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.specialty.epli"
version = "1.0.0"
title = "Employment Practices Liability Insurance Schema"
description = "Comprehensive EPLI coverage for employment-related claims"

{$derivation}
source[0].authority = "U.S. Equal Employment Opportunity Commission"
source[0].citation = "EEOC Enforcement Guidance on Harassment"
source[0].url = "https://www.eeoc.gov/select-task-force-study-harassment-workplace"

source[1].authority = "U.S. Department of Labor"
source[1].citation = "Fair Labor Standards Act"
source[1].url = "https://www.dol.gov/agencies/whd/flsa"

source[2].authority = "U.S. Department of Labor"
source[2].citation = "Family and Medical Leave Act"
source[2].url = "https://www.dol.gov/agencies/whd/fmla"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Complete EPLI schema covering all employment-related liability exposures"

changelog[0].date = 2025-12-13
changelog[0].change = "Initial EPLI schema"
changelog[0].rationale = "Comprehensive employment practices liability structure"

; ═══════════════════════════════════════════════════════════════════════════════
; Workforce Information
; ═══════════════════════════════════════════════════════════════════════════════

{@epli_workforce}
workforce_id = :                                       ; Unique identifier for workforce record

; ───────────────────────────────────────────────────────────────────────────────
; Employee Counts
; ───────────────────────────────────────────────────────────────────────────────

{.employees}
total = !##                                            ; Total number of employees
full_time = ##                                         ; Number of full-time employees
part_time = ##                                         ; Number of part-time employees
temporary = ##                                         ; Number of temporary employees
seasonal = ##                                          ; Number of seasonal employees
leased_peo = ##                                        ; Number of leased or PEO employees
independent_contractors_1099 = ##                      ; Number of 1099 independent contractors
volunteers = ##                                        ; Number of volunteer workers
interns_paid = ##                                      ; Number of paid interns
interns_unpaid = ##                                    ; Number of unpaid interns

; Employee Changes
hired_last_12_months = ##                              ; Number of employees hired in last 12 months
terminated_last_12_months = ##                         ; Number of employees terminated in last 12 months
layoffs_last_12_months = ##                            ; Number of layoffs in last 12 months
anticipated_layoffs = ##                               ; Number of anticipated future layoffs

{@epli_workforce}

; ───────────────────────────────────────────────────────────────────────────────
; Geographic Distribution
; ───────────────────────────────────────────────────────────────────────────────
states_with_employees[] = :(2)                         ; Two-letter state codes where employees work
california_employees = ##         ; High-risk state
new_york_employees = ##           ; High-risk state
texas_employees = ##                                   ; Number of employees in Texas
florida_employees = ##                                 ; Number of employees in Florida
international_employees = ##                           ; Number of employees outside the United States
international_locations[] = :                          ; List of international locations

; ───────────────────────────────────────────────────────────────────────────────
; Workforce Demographics
; ───────────────────────────────────────────────────────────────────────────────
union_employees = ##                                   ; Number of union-represented employees
union_percentage = #:(0..100)                          ; Percentage of workforce that is unionized
collective_bargaining_agreements = ##                  ; Number of active collective bargaining agreements

; Age Distribution (relevant for ADEA)
employees_over_40 = ##                                 ; Number of employees age 40 or older
employees_over_40_percentage = #:(0..100)              ; Percentage of employees age 40 or older

; ───────────────────────────────────────────────────────────────────────────────
; Compensation Data
; ───────────────────────────────────────────────────────────────────────────────
total_annual_payroll = #$                              ; Total annual payroll for all employees
average_salary = #$                                    ; Average employee salary
employees_exempt = ##             ; FLSA exempt
employees_non_exempt = ##         ; FLSA non-exempt
employees_on_commission = ##                           ; Number of employees compensated by commission
employees_tipped = ##                                  ; Number of tipped employees

; ───────────────────────────────────────────────────────────────────────────────
; Benefits
; ───────────────────────────────────────────────────────────────────────────────
offers_health_insurance = ?                            ; Whether employer offers health insurance
offers_retirement_plan = ?                             ; Whether employer offers retirement plan
offers_stock_options = ?                               ; Whether employer offers stock options
offers_paid_family_leave = ?                           ; Whether employer offers paid family leave

; ═══════════════════════════════════════════════════════════════════════════════
; HR Practices
; ═══════════════════════════════════════════════════════════════════════════════

{@epli_hr_practices}
hr_id = :                                              ; Unique identifier for HR practices record

; ───────────────────────────────────────────────────────────────────────────────
; HR Department
; ───────────────────────────────────────────────────────────────────────────────
dedicated_hr_department = ?                            ; Whether company has dedicated HR department
hr_employees = ##                                      ; Number of HR department employees
outsourced_hr = ?                                      ; Whether HR functions are outsourced
outsourced_provider = ::if outsourced_hr = true        ; Name of outsourced HR provider
peo_relationship = ?                                   ; Whether company has PEO relationship
peo_name = ::if peo_relationship = true                ; Name of PEO provider

; ───────────────────────────────────────────────────────────────────────────────
; Policies and Procedures
; ───────────────────────────────────────────────────────────────────────────────
written_employee_handbook = ?                          ; Whether company has written employee handbook
handbook_updated = date:if written_employee_handbook = true  ; Date handbook was last updated
handbook_reviewed_by_counsel = ?:if written_employee_handbook = true  ; Whether handbook reviewed by legal counsel

; Required Policies
{.policies}
anti_discrimination = ?                                ; Whether anti-discrimination policy exists
anti_harassment = ?                                    ; Whether anti-harassment policy exists
equal_employment_opportunity = ?                       ; Whether EEO policy exists
ada_accommodation = ?                                  ; Whether ADA accommodation policy exists
fmla = ?                                               ; Whether FMLA policy exists
drug_free_workplace = ?                                ; Whether drug-free workplace policy exists
social_media = ?                                       ; Whether social media policy exists
remote_work = ?                                        ; Whether remote work policy exists
arbitration_agreement = ?                              ; Whether arbitration agreement policy exists
at_will_employment = ?                                 ; Whether at-will employment policy exists

{@epli_hr_practices}

; ───────────────────────────────────────────────────────────────────────────────
; Training
; ───────────────────────────────────────────────────────────────────────────────

{.training}
harassment_prevention = ?                              ; Whether harassment prevention training provided
harassment_frequency = (annual, biennial, new_hire_only):if training.harassment_prevention = true  ; Frequency of harassment training
harassment_managers_separate = ?:if training.harassment_prevention = true  ; Whether managers receive separate harassment training

diversity_inclusion = ?                                ; Whether diversity and inclusion training provided
unconscious_bias = ?                                   ; Whether unconscious bias training provided
supervisor_training = ?                                ; Whether supervisor training provided
documented = ?                                         ; Whether training is documented

{@epli_hr_practices}

; ───────────────────────────────────────────────────────────────────────────────
; Complaint Procedures
; ───────────────────────────────────────────────────────────────────────────────

{.complaint_procedure}
written = ?                                            ; Whether written complaint procedure exists
multiple_reporting_channels = ?                        ; Whether multiple reporting channels available
anonymous_hotline = ?                                  ; Whether anonymous hotline available
third_party_investigation = ?                          ; Whether third-party investigation option available
non_retaliation_policy = ?                             ; Whether non-retaliation policy exists

{@epli_hr_practices}

; ───────────────────────────────────────────────────────────────────────────────
; Hiring/Termination Practices
; ───────────────────────────────────────────────────────────────────────────────

{.hiring}
background_checks = ?                                  ; Whether background checks conducted
reference_checks = ?                                   ; Whether reference checks conducted
employment_applications = ?                            ; Whether employment applications used
structured_interviews = ?                              ; Whether structured interviews conducted

{@epli_hr_practices}

{.termination}
documented_performance_reviews = ?                     ; Whether performance reviews documented
progressive_discipline = ?                             ; Whether progressive discipline policy used
exit_interviews = ?                                    ; Whether exit interviews conducted
severance_agreements = ?                               ; Whether severance agreements used
general_releases_over_40 = ?      ; OWBPA compliance

{@epli_hr_practices}

; ═══════════════════════════════════════════════════════════════════════════════
; EPLI Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@epli_coverage}
coverage_id = :                                        ; Unique identifier for coverage record

; ───────────────────────────────────────────────────────────────────────────────
; Limits
; ───────────────────────────────────────────────────────────────────────────────
limit_each_claim = !##                                 ; Coverage limit per claim
limit_aggregate = !##                                  ; Aggregate coverage limit for policy period
defense_within_limits = ?true                 ; Duty to defend erodes limits

; ───────────────────────────────────────────────────────────────────────────────
; Retention/Deductible
; ───────────────────────────────────────────────────────────────────────────────
retention = ##                                         ; Self-insured retention amount
retention_includes_defense = ?                         ; Whether retention includes defense costs
coinsurance_percentage = #:(0..50)                     ; Percentage of coinsurance required

; ───────────────────────────────────────────────────────────────────────────────
; Covered Employment Practices (Wrongful Acts)
; ───────────────────────────────────────────────────────────────────────────────

{.covered_acts}
wrongful_termination = ?true                           ; Coverage for wrongful termination claims
wrongful_demotion = ?true                              ; Coverage for wrongful demotion claims
wrongful_discipline = ?true                            ; Coverage for wrongful discipline claims
failure_to_promote = ?true                             ; Coverage for failure to promote claims
failure_to_hire = ?true                                ; Coverage for failure to hire claims
negligent_hiring = ?                                   ; Coverage for negligent hiring claims
negligent_supervision = ?                              ; Coverage for negligent supervision claims
negligent_retention = ?                                ; Coverage for negligent retention claims
breach_of_employment_contract = ?                      ; Coverage for employment contract breach
misrepresentation = ?                                  ; Coverage for misrepresentation claims
defamation = ?                                         ; Coverage for defamation claims
invasion_of_privacy = ?                                ; Coverage for invasion of privacy claims
infliction_of_emotional_distress = ?                   ; Coverage for emotional distress claims

{@epli_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Discrimination Coverage
; ───────────────────────────────────────────────────────────────────────────────

{.discrimination}
title_vii = ?true              ; Race, color, religion, sex, national origin
ada = ?true                    ; Disability
adea = ?true                   ; Age 40+
pregnancy = ?true              ; PDA
genetic_information = ?true    ; GINA
sexual_orientation = ?                                 ; Coverage for sexual orientation discrimination
gender_identity = ?                                    ; Coverage for gender identity discrimination
military_status = ?            ; USERRA
state_protected_classes = ?                            ; Coverage for state-specific protected classes

{@epli_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Harassment Coverage
; ───────────────────────────────────────────────────────────────────────────────

{.harassment}
sexual_harassment = ?true                              ; Coverage for sexual harassment claims
quid_pro_quo = ?true                                   ; Coverage for quid pro quo harassment
hostile_work_environment = ?true                       ; Coverage for hostile work environment claims
non_sexual_harassment = ?true                          ; Coverage for non-sexual harassment
workplace_bullying = ?                                 ; Coverage for workplace bullying claims

{@epli_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Retaliation Coverage
; ───────────────────────────────────────────────────────────────────────────────

{.retaliation}
general = ?true                                        ; Coverage for general retaliation claims
whistleblower = ?                                      ; Coverage for whistleblower retaliation
whistleblower_sublimit = #$:if retaliation.whistleblower = true  ; Sublimit for whistleblower claims
sarbanes_oxley = ?                ; SOX 806
dodd_frank = ?                                         ; Coverage for Dodd-Frank whistleblower claims
false_claims_act = ?              ; Qui tam
osha = ?                                               ; Coverage for OSHA whistleblower retaliation

{@epli_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Wage and Hour Coverage
; ───────────────────────────────────────────────────────────────────────────────

{.wage_hour}
included = ?                                           ; Whether wage and hour coverage included
sublimit = #$:if wage_hour.included = true             ; Sublimit for wage and hour claims
retention = ##:if wage_hour.included = true            ; Retention for wage and hour claims
defense_only = ?:if wage_hour.included = true          ; Whether coverage is defense-only
class_action = ?:if wage_hour.included = true          ; Whether class action coverage included
paga = ?:if wage_hour.included = true  ; Private Attorneys General Act (CA)

{@epli_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Third-Party Coverage
; ───────────────────────────────────────────────────────────────────────────────

{.third_party}
included = ?                                           ; Whether third-party coverage included
sublimit = #$:if third_party.included = true           ; Sublimit for third-party claims
retention = ##:if third_party.included = true          ; Retention for third-party claims
covered_third_parties = (
    clients,
    contractors,
    customers,
    suppliers,
    vendors,
    visitors
):if third_party.included = true                       ; Types of third parties covered

{@epli_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; EEOC/Administrative Proceeding Coverage
; ───────────────────────────────────────────────────────────────────────────────

{.eeoc_coverage}
included = ?true                                       ; Whether EEOC proceeding coverage included
sublimit = #$                                          ; Sublimit for EEOC proceedings
includes_state_agencies = ?                            ; Whether state agency proceedings covered
presuit_expenses = ?                                   ; Whether pre-suit expenses covered

{@epli_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Additional Coverage Features
; ───────────────────────────────────────────────────────────────────────────────

{.additional}
workplace_violence = ?                                 ; Whether workplace violence coverage included
workplace_violence_sublimit = #$:if additional.workplace_violence = true  ; Sublimit for workplace violence

crisis_management = ?                                  ; Whether crisis management coverage included
crisis_management_sublimit = #$:if additional.crisis_management = true  ; Sublimit for crisis management

employee_assistance = ?                                ; Whether employee assistance coverage included
employee_assistance_sublimit = #$:if additional.employee_assistance = true  ; Sublimit for employee assistance

reference_checking = ?                                 ; Whether reference checking service included

{@epli_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; EPLI Claims History
; ═══════════════════════════════════════════════════════════════════════════════

{@epli_claims_history}
history_id = :                                         ; Unique identifier for claims history record

; ───────────────────────────────────────────────────────────────────────────────
; Prior Claims (Last 5 Years)
; ───────────────────────────────────────────────────────────────────────────────
total_claims_5_years = ##                              ; Total number of claims in last 5 years
total_incurred_5_years = #$                            ; Total amount incurred in last 5 years

{.claims[]}
claim_number = :                                       ; Unique claim number
date_of_incident = date                                ; Date of the alleged incident
date_reported = date                                   ; Date claim was reported
allegation_type = (
    discrimination,
    failure_to_promote,
    harassment,
    hostile_work_environment,
    other,
    retaliation,
    wage_hour,
    wrongful_termination
)                                                      ; Type of allegation
claimant_position = :                                  ; Claimant's job position
status = (open, reserved, closed_paid, closed_no_payment)  ; Current claim status
paid_indemnity = #$                                    ; Amount paid in indemnity
paid_defense = #$                                      ; Amount paid for defense costs
reserves = #$                                          ; Amount reserved for claim
eeoc_charge = ?                                        ; Whether EEOC charge was filed
litigation = ?                                         ; Whether claim involved litigation
class_action = ?                                       ; Whether claim was class action

{@epli_claims_history}

; ───────────────────────────────────────────────────────────────────────────────
; Pending/Known Circumstances
; ───────────────────────────────────────────────────────────────────────────────
pending_eeoc_charges = ##                              ; Number of pending EEOC charges
pending_lawsuits = ##                                  ; Number of pending lawsuits
pending_internal_complaints = ##                       ; Number of pending internal complaints

; ═══════════════════════════════════════════════════════════════════════════════
; EPLI Endorsements
; ═══════════════════════════════════════════════════════════════════════════════

{@epli_endorsement}
id = :                                                 ; Unique identifier for endorsement
number = !:                                            ; Endorsement number
title = :                                              ; Endorsement title
effective_date = date                                  ; Effective date of endorsement

; Endorsement Type
type = (
    board_liability_exclusion,
    crisis_management,
    fiduciary_carveout,
    increased_limits,
    international_extension,
    other,
    prior_acts_exclusion,
    punitive_damages,
    reduced_retention,
    specific_claim_exclusion,
    third_party_coverage,
    wage_hour_coverage,
    workplace_violence
)                                                      ; Type of endorsement

description = :                                        ; Description of endorsement
premium_impact = #$                                    ; Premium impact of endorsement

; ═══════════════════════════════════════════════════════════════════════════════
; EPLI Policy (Composes All Parts)
; ═══════════════════════════════════════════════════════════════════════════════

{@epli_policy}
id = :                                                 ; Unique identifier for policy
number = !:                                            ; Policy number

; ───────────────────────────────────────────────────────────────────────────────
; Term
; ───────────────────────────────────────────────────────────────────────────────
effective_date = !date                                 ; Policy effective date
effective_time = time                                  ; Policy effective time
expiration_date = !date                                ; Policy expiration date
expiration_time = time                                 ; Policy expiration time
:invariant expiration_date > effective_date

; ───────────────────────────────────────────────────────────────────────────────
; Policy Type
; ───────────────────────────────────────────────────────────────────────────────
type = (
    bop_endorsement,
    excess,
    management_liability_package,             ; Combined with D&O
    standalone
)                                                      ; Type of EPLI policy

; ───────────────────────────────────────────────────────────────────────────────
; Claims-Made Dates
; ───────────────────────────────────────────────────────────────────────────────
retroactive_date = !date                               ; Retroactive date for claims-made coverage
continuity_date = date                                 ; Continuity date from prior policy
pending_prior_date = date                              ; Date for pending and prior litigation

; Extended Reporting Period
erp_purchased = ?                                      ; Whether extended reporting period purchased
erp_type = (basic_60_days, supplemental_1_year, supplemental_3_year, unlimited):if erp_purchased = true  ; Type of ERP
erp_effective_date = date:if erp_purchased = true      ; Effective date of ERP

; ───────────────────────────────────────────────────────────────────────────────
; Named Insured
; ───────────────────────────────────────────────────────────────────────────────
named_insured = @entity.business                       ; Reference to named insured business entity

; ───────────────────────────────────────────────────────────────────────────────
; Coverage
; ───────────────────────────────────────────────────────────────────────────────
coverage = @epli_coverage                              ; Reference to EPLI coverage details

; ───────────────────────────────────────────────────────────────────────────────
; Workforce Data
; ───────────────────────────────────────────────────────────────────────────────
workforce = @epli_workforce                            ; Reference to workforce information

; ───────────────────────────────────────────────────────────────────────────────
; HR Practices
; ───────────────────────────────────────────────────────────────────────────────
hr_practices = @epli_hr_practices                      ; Reference to HR practices information

; ───────────────────────────────────────────────────────────────────────────────
; Locations
; ───────────────────────────────────────────────────────────────────────────────
locations[] = @location.business_location              ; Array of business location references

; ───────────────────────────────────────────────────────────────────────────────
; Claims History
; ───────────────────────────────────────────────────────────────────────────────
claims_history = @epli_claims_history                  ; Reference to claims history

; ───────────────────────────────────────────────────────────────────────────────
; Endorsements
; ───────────────────────────────────────────────────────────────────────────────
endorsements[] = @epli_endorsement                     ; Array of endorsement references

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────

{.premium}
base = #$                                              ; Base premium amount
wage_hour = #$                                         ; Additional premium for wage and hour coverage
third_party = #$                                       ; Additional premium for third-party coverage
endorsements = #$                                      ; Total premium for all endorsements
taxes_fees = #$                                        ; Taxes and fees
total = #$                                             ; Total premium including all charges
minimum = #$                                           ; Minimum earned premium

{@epli_policy}



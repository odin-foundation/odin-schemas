; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Medicaid Benefits Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Medicaid covered services and benefit packages including mandatory and optional
; services, EPSDT, and cost sharing requirements. Derived from 42 CFR Part 440
; and state plan requirements.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as medicaid

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.medicaid.benefits"
version = "1.0.0"
title = "Medicaid Benefits Schema"
description = "Medicaid covered services and benefits"

{$derivation}
source[0].authority = "GPO"
source[0].citation = "42 CFR Part 440 - Services: General Provisions"
source[0].url = "https://www.ecfr.gov/current/title-42/chapter-IV/subchapter-C/part-440"

source[1].authority = "CMS"
source[1].citation = "Medicaid Benefits - Mandatory and Optional Services"
source[1].url = "https://www.medicaid.gov/medicaid/benefits/index.html"

source[2].authority = "GPO"
source[2].citation = "42 CFR 447.50-57 - Cost Sharing"
source[2].url = "https://www.ecfr.gov/current/title-42/chapter-IV/subchapter-C/part-447/subpart-A"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial Medicaid benefits schema"
changelog[0].rationale = "Structure derived from 42 CFR Part 440 and CMS benefits guidance"

; ═══════════════════════════════════════════════════════════════════════════════
; BENEFIT PACKAGE
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR Part 440 and state plan

{@package}
package_id = :                              ; Package identifier
state = :(2)                                ; State
package_name = :                             ; Package name
effective_date = date                       ; Effective date
end_date = date                              ; End date (if applicable)

; Package type - Per 42 CFR 440.305
package_type = (abp, benchmark, benchmark_equivalent, secretary_approved, state_plan)

; Eligibility groups covered
eligible_groups[] = :                        ; Eligibility groups receiving package

; Services included
mandatory_services[] = @service_definition   ; Mandatory services
optional_services[] = @service_definition    ; Optional services
epsdt = ?                                    ; EPSDT applies (children under 21)

; Cost sharing
cost_sharing = @cost_sharing                 ; Cost sharing requirements

; ═══════════════════════════════════════════════════════════════════════════════
; SERVICE DEFINITION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 440.1-440.170

{@service_definition}
service_code = :                            ; Service code
service_name = :                            ; Service name
service_category = (behavioral_health, dental, hcbs, institutional, medical, pharmacy, rehabilitative, transportation)

; Mandatory vs optional - Per 42 CFR 440.210-220
mandatory = ?                                ; Mandatory service

; Coverage status
covered = ?                                 ; Service covered in state
coverage_description = :                     ; Coverage description

; Limits - Per 42 CFR 440.230
{.limits}
limited = ?                                  ; Service has limits
amount_limit = :                             ; Amount/quantity limit
duration_limit = :                           ; Duration limit
scope_limit = :                              ; Scope limit

{@service_definition}

; Prior authorization
{.prior_auth}
required = ?                                 ; PA required
criteria = :                                 ; PA criteria
expedited_available = ?                      ; Expedited PA available

{@service_definition}

; Provider requirements
{.provider}
provider_types[] = :                         ; Eligible provider types
enrollment_required = ?                      ; Provider enrollment required
certification_required = ?                   ; Special certification required

{@service_definition}

; ═══════════════════════════════════════════════════════════════════════════════
; MANDATORY SERVICES
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 440.210 - Required services for categorically needy

{@mandatory_services}
; Inpatient hospital - 42 CFR 440.10
{.inpatient_hospital}
covered = ?true                              ; Mandatory
day_limit = ##:(0..)                         ; Day limit if any
certification_required = ?                   ; Certification requirement

{@mandatory_services}

; Outpatient hospital - 42 CFR 440.20
{.outpatient_hospital}
covered = ?true                              ; Mandatory

{@mandatory_services}

; Physician services - 42 CFR 440.50
{.physician}
covered = ?true                              ; Mandatory

{@mandatory_services}

; Laboratory and X-ray - 42 CFR 440.30
{.lab_xray}
covered = ?true                              ; Mandatory

{@mandatory_services}

; Nursing facility (age 21+) - 42 CFR 440.40
{.nursing_facility}
covered = ?true                              ; Mandatory for adults
day_limit = ##:(0..)                         ; Day limit if any

{@mandatory_services}

; EPSDT (under 21) - 42 CFR 440.40(b)
{.epsdt}
covered = ?true                              ; Mandatory for children
screening_periodicity = :                    ; Screening schedule
interperiodic_screens = ?                    ; Between scheduled screens

{@mandatory_services}

; Family planning - 42 CFR 440.40
{.family_planning}
covered = ?true                              ; Mandatory
no_cost_sharing = ?true                      ; No cost sharing required

{@mandatory_services}

; Nurse midwife - 42 CFR 440.165
{.nurse_midwife}
covered = ?true                              ; Mandatory

{@mandatory_services}

; FQHC/RHC - 42 CFR 440.20
{.fqhc_rhc}
covered = ?true                              ; Mandatory

{@mandatory_services}

; Transportation - 42 CFR 431.53
{.transportation}
covered = ?true                              ; Mandatory (NEMT)
broker_used = ?                              ; Transportation broker

{@mandatory_services}

; ═══════════════════════════════════════════════════════════════════════════════
; OPTIONAL SERVICES
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 440.220

{@optional_services}
; Prescription drugs - 42 CFR 440.120
{.prescription_drugs}
covered = ?                                  ; Optional service
generic_substitution = ?                     ; Generic substitution policy
prior_auth_required = ?                      ; PA for certain drugs
quantity_limits = ?                          ; Quantity limits apply

{@optional_services}

; Dental - 42 CFR 440.100
{.dental}
covered = ?                                  ; Optional service
adult_covered = ?                            ; Adult dental covered
services_included = :                        ; Services covered
annual_limit = #$:(0..)                      ; Annual benefit limit

{@optional_services}

; Vision - 42 CFR 440.120
{.vision}
covered = ?                                  ; Optional service
adult_covered = ?                            ; Adult vision covered
exams_per_year = ##:(0..)                    ; Exam frequency
eyewear_covered = ?                          ; Eyewear covered

{@optional_services}

; Mental health - 42 CFR 440.130
{.mental_health}
covered = ?                                  ; Optional service
inpatient_days = ##:(0..)                    ; Inpatient day limit
outpatient_visits = ##:(0..)                 ; Outpatient visit limit
parity_compliant = ?                         ; Mental health parity

{@optional_services}

; Substance use disorder - 42 CFR 440.130
{.sud}
covered = ?                                  ; Optional service
imt_covered = ?                              ; IMD exclusion waiver
residential_covered = ?                      ; Residential treatment

{@optional_services}

; Home health - 42 CFR 440.70
{.home_health}
covered = ?                                  ; Optional service
nursing_covered = ?                          ; Skilled nursing
aide_covered = ?                             ; Home health aide
therapy_covered = ?                          ; PT/OT/Speech

{@optional_services}

; Personal care - 42 CFR 440.167
{.personal_care}
covered = ?                                  ; Optional service
consumer_directed = ?                        ; Consumer-directed option

{@optional_services}

; Physical/occupational therapy - 42 CFR 440.110
{.therapy}
covered = ?                                  ; Optional service
pt_covered = ?                               ; Physical therapy
ot_covered = ?                               ; Occupational therapy
speech_covered = ?                           ; Speech therapy
visit_limit = ##:(0..)                       ; Visit limit

{@optional_services}

; DME - 42 CFR 440.70
{.dme}
covered = ?                                  ; Optional service
prior_auth_required = ?                      ; PA required
rental_vs_purchase = :                       ; Rental/purchase policy

{@optional_services}

; ═══════════════════════════════════════════════════════════════════════════════
; HCBS WAIVER SERVICES
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 441.300 (1915(c) waivers)

{@hcbs_waiver}
waiver_number = :                           ; Waiver number
waiver_name = :                              ; Waiver name
state = :(2)                                ; State
effective_date = date                       ; Effective date
expiration_date = date                       ; Expiration date

; Target population
{.target_population}
aged = ?                                     ; Aged population
disabled = ?                                 ; Disabled population
dd_id = ?                                    ; DD/ID population
mh_sud = ?                                   ; MH/SUD population
technology_dependent = ?                     ; Technology dependent
other = :                                    ; Other population

{@hcbs_waiver}

; Level of care
{.loc}
nursing_facility = ?                         ; NF level of care
icf_iid = ?                                  ; ICF/IID level of care
hospital = ?                                 ; Hospital level of care

{@hcbs_waiver}

; Waiver services
services[] = @hcbs_service                   ; HCBS services offered

{@hcbs_service}
service_name = :                            ; Service name
service_code = :                             ; Service code
definition = :                               ; Service definition
unit = :                                     ; Service unit
max_units = ##:(0..)                         ; Maximum units
provider_types[] = :                         ; Provider types
prior_auth = ?                               ; Prior authorization required

{@hcbs_waiver}

; Cost neutrality - Per 42 CFR 441.302
{.cost_neutrality}
per_capita_limit = #$:(0..)                  ; Per capita cost limit
aggregate_limit = #$:(0..)                   ; Aggregate cap
unduplicated_count = ##:(0..)                ; Unduplicated participants

{@hcbs_waiver}

; ═══════════════════════════════════════════════════════════════════════════════
; COST SHARING
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 447.50-57

{@cost_sharing}
state = :(2)                                ; State
effective_date = date                       ; Effective date

; General rules - Per 42 CFR 447.52
{.rules}
nominal_cost_sharing = ?                     ; Nominal cost sharing only
income_based = ?                             ; Income-based cost sharing
cost_sharing_cap = #:(0..5)                  ; Cap as percent of income

{@cost_sharing}

; Exempt populations - Per 42 CFR 447.56
{.exempt}
children_under_18 = ?                        ; Children exempt
pregnant_women = ?                           ; Pregnant women exempt
institutionalized = ?                        ; Institutionalized exempt
hospice = ?                                  ; Hospice exempt
emergency_services = ?                       ; Emergency exempt
family_planning = ?                          ; Family planning exempt
preventive = ?                               ; Preventive exempt

{@cost_sharing}

; Cost sharing amounts
copayments[] = @copayment                    ; Copayment schedule
premiums = @medicaid_premium                 ; Premium requirements

{@copayment}
service_category = :                         ; Service category
income_level = :                             ; Income level (FPL range)
amount = #$:(0..)                            ; Copayment amount
percent = #:(0..100)                         ; Or percentage

{@medicaid_premium}
applicable = ?                               ; Premiums required
income_threshold = #:(0..400)                ; Income threshold (FPL%)
monthly_amount = #$:(0..)                    ; Monthly premium
maximum_percent = #:(0..5)                   ; Max percent of income


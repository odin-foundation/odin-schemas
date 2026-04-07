; ═══════════════════════════════════════════════════════════════════════════════
; ODIN CHIP Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Children's Health Insurance Program structures covering state programs,
; eligibility, enrollment, and benefits for both Medicaid expansion and
; separate CHIP models. Derived from 42 CFR Part 457.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as medicaid

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.medicaid.chip"
version = "1.0.0"
title = "CHIP Schema"
description = "Children's Health Insurance Program structures"

{$derivation}
source[0].authority = "GPO"
source[0].citation = "42 CFR Part 457 - Allotments and Grants to States"
source[0].url = "https://www.ecfr.gov/current/title-42/chapter-IV/subchapter-D/part-457"

source[1].authority = "CMS"
source[1].citation = "CHIP State Plan Template"
source[1].url = "https://www.medicaid.gov/chip"

source[2].authority = "CMS"
source[2].citation = "CHIPRA and ACA CHIP provisions"
source[2].url = "https://www.medicaid.gov/chip/index.html"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial CHIP schema"
changelog[0].rationale = "Structure derived from 42 CFR Part 457 and CHIP state plan requirements"

; ═══════════════════════════════════════════════════════════════════════════════
; CHIP STATE PROGRAM
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 457.10

{@program}
state = !:(2)                                ; State code
program_name = :                             ; State program name
effective_date = !date                       ; Current state plan effective

; Program type - Per 42 CFR 457.10
program_type = !(combination, medicaid_expansion, separate_chip)
; medicaid_expansion = Medicaid expansion CHIP
; separate_chip = Separate CHIP program
; combination = Both expansion and separate

; Medicaid expansion component
{.medicaid_expansion}
expansion = ?                                ; Medicaid expansion component
target_populations[] = :                     ; Populations in expansion

{@program}

; Separate CHIP component
{.separate_chip}
separate = ?                                 ; Separate CHIP
program_name = :                             ; Separate program name
target_populations[] = :                     ; Populations in separate

{@program}

; ═══════════════════════════════════════════════════════════════════════════════
; CHIP ELIGIBILITY
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 457.310-380

{@eligibility}
state = !:(2)                                ; State

; Age eligibility - Per 42 CFR 457.310
{.age}
min_age = ##:(0..)                           ; Minimum age
max_age = ##:(0..19)                         ; Maximum age (under 19)
age_out_end_of_month = ?                     ; Coverage to end of month of 19th birthday

{@eligibility}

; Income standards - Per 42 CFR 457.315
{.income}
methodology = !(magi)                        ; MAGI methodology required
standard_fpl = #:(0..400)                    ; Standard FPL percentage
infant_fpl = #:(0..400)                      ; Infant FPL (if different)
presumptive_fpl = #:(0..400)                 ; Presumptive eligibility FPL

{@eligibility}

; Other requirements - Per 42 CFR 457.320
{.requirements}
us_citizen_or_lawful = ?                     ; Citizenship/immigration status
state_resident = ?                           ; State residency
not_incarcerated = ?                         ; Not incarcerated
no_group_coverage = ?                        ; Not covered by group health
no_public_coverage = ?                       ; Not covered by public program

{@eligibility}

; Waiting period - Per 42 CFR 457.805
{.waiting_period}
waiting_period = ?                           ; Waiting period applies
months = ##:(0..3)                           ; Waiting period months
exceptions[] = :                             ; Exceptions to waiting period

{@eligibility}

; ═══════════════════════════════════════════════════════════════════════════════
; CHIP ENROLLMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 457.340-350

{@enrollment}
enrollment_id = !:                           ; Enrollment ID
state = !:(2)                                ; State
child = !@medicaid.member                    ; Child information

; Application
{.application}
application_date = date                      ; Application date
application_source = (joint, marketplace, online, paper)
joint_application = ?                        ; Joint Medicaid/CHIP application

{@enrollment}

; Eligibility determination
{.determination}
eligible = ?                                 ; Eligible for CHIP
program_type = (medicaid_chip, separate_chip):if eligible = true
eligibility_date = date                      ; Eligibility determination date
effective_date = date                        ; Coverage effective date

{@enrollment}

; Coverage period
{.coverage}
coverage_type = (medicaid_chip, separate_chip)
effective_date = date                        ; Coverage start
end_date = date                              ; Coverage end
continuous_eligibility = ?                   ; 12-month continuous eligibility

{@enrollment}

; Managed care enrollment
{.managed_care}
enrolled_in_mco = ?                          ; In managed care
plan_id = :                                  ; MCO plan ID
plan_name = :                                ; Plan name
enrollment_date = date                       ; MCO enrollment date

{@enrollment}

; Renewal - Per 42 CFR 457.343
{.renewal}
renewal_due = date                           ; Renewal due date
ex_parte_attempted = ?                       ; Ex parte renewal attempted
ex_parte_successful = ?                      ; Renewed ex parte

{@enrollment}

; ═══════════════════════════════════════════════════════════════════════════════
; CHIP BENEFITS
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 457.410-496

{@benefits}
state = !:(2)                                ; State
program_type = !(medicaid_chip, separate_chip)

; Benefit package type - Per 42 CFR 457.410
package_type = !(benchmark, benchmark_equivalent, existing_comprehensive, secretary_approved)

; Benchmark options - Per 42 CFR 457.420
benchmark_plan = (fehbp_standard, hmo_largest_enrollment, state_employee, other)

; Required benefits - Per 42 CFR 457.430
{.required}
well_baby_well_child = ?true                 ; Well-baby/well-child
age_appropriate_immunizations = ?true        ; Immunizations
emergency_services = ?true                   ; Emergency services
dental = ?                                   ; Dental services (CHIPRA)
mental_health_parity = ?                     ; MH/SUD parity

{@benefits}

; Optional benefits
{.optional}
prescription_drugs = ?                       ; Prescription drugs
vision = ?                                   ; Vision services
hearing = ?                                  ; Hearing services
inpatient_mh = ?                             ; Inpatient mental health
therapy_services = ?                         ; PT/OT/Speech

{@benefits}

; EPSDT-like coverage - Per 42 CFR 457.496
{.epsdt}
epsdt_equivalent = ?                         ; EPSDT-like coverage
screening_periodicity = :                    ; Screening schedule

{@benefits}

; ═══════════════════════════════════════════════════════════════════════════════
; CHIP COST SHARING
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 457.500-560

{@cost_sharing}
state = !:(2)                                ; State

; Maximum cost sharing - Per 42 CFR 457.560
{.limits}
aggregate_cap = #:(0..5)                     ; Aggregate cap (% of income)
annual_cap = #$:(0..)                        ; Dollar cap if used

{@cost_sharing}

; Premiums - Per 42 CFR 457.555
{.premiums}
charges_premiums = ?                         ; State charges premiums
income_threshold = #:(0..400)                ; FPL threshold for premiums
monthly_premium = #$:(0..)                   ; Monthly premium amount

{@cost_sharing}

; Copayments - Per 42 CFR 457.505
{.copayments}
copayments = ?                               ; State uses copayments
copayment_schedule = :                       ; Reference to schedule

{@cost_sharing}

; Exempt services - Per 42 CFR 457.520
{.exempt}
well_child = ?true                           ; Well-child exempt
immunizations = ?true                        ; Immunizations exempt
emergency = ?true                            ; Emergency exempt
pregnancy = ?true                            ; Pregnancy-related exempt
preventive = ?true                           ; Preventive exempt

{@cost_sharing}

; Exempt populations - Per 42 CFR 457.520
{.exempt_populations}
native_american = ?true                      ; AI/AN exempt
below_150_fpl = ?                            ; Under 150% FPL exempt

{@cost_sharing}

; ═══════════════════════════════════════════════════════════════════════════════
; CHIP FINANCING
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 457.600-650

{@financing}
state = !:(2)                                ; State
fiscal_year = !##:(2000..2100)               ; Federal fiscal year

; Allotment - Per 42 CFR 457.608
{.allotment}
federal_allotment = #$:(0..)                 ; Federal allotment
carryover_from_prior = #$:(0..)              ; Carryover from prior years
redistribution_received = #$:(0..)           ; Redistribution received
total_available = #$:(0..)                   ; Total available funds

{@financing}

; Expenditures
{.expenditures}
benefit_expenditures = #$:(0..)              ; Benefit costs
admin_expenditures = #$:(0..)                ; Administrative costs
total_expenditures = #$:(0..)                ; Total expenditures

{@financing}

; Federal match - Per 42 CFR 457.622
{.match}
e_fmap = #:(0..100)                          ; Enhanced FMAP rate
state_share = #$:(0..)                       ; State share
federal_share = #$:(0..)                     ; Federal share

{@financing}


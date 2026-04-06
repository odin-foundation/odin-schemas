; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Medicaid Managed Care Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Medicaid managed care structures for MCO, PIHP, PAHP, and PCCM entities
; including contracts, service areas, network adequacy, and quality measures.
; Derived from 42 CFR Part 438.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as medicaid

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.medicaid.managedcare"
version = "1.0.0"
title = "Medicaid Managed Care Schema"
description = "MCO/PIHP/PAHP/PCCM structures"

{$derivation}
source[0].authority = "GPO"
source[0].citation = "42 CFR Part 438 - Managed Care"
source[0].url = "https://www.ecfr.gov/current/title-42/chapter-IV/subchapter-C/part-438"

source[1].authority = "CMS"
source[1].citation = "Medicaid Managed Care Final Rule (CMS-2390-F)"
source[1].url = "https://www.medicaid.gov/medicaid/managed-care/index.html"

source[2].authority = "CMS"
source[2].citation = "Managed Care State Directed Payment guidance"
source[2].url = "https://www.medicaid.gov/medicaid/managed-care/guidance/state-directed-payments/index.html"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial Medicaid managed care schema"
changelog[0].rationale = "Structure derived from 42 CFR Part 438"

; ═══════════════════════════════════════════════════════════════════════════════
; MANAGED CARE ORGANIZATION (MCO)
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 438.2 and 438.310

{@mco}
plan_id = !:                                 ; Plan identifier
state = !:(2)                                ; State
plan_type = !(mco, pahp, pccm, pccm_entity, pihp)

; Organization information - inherits from @organization
{.organization}
= @organization                              ; Inherits organization fields (legal_name, tax_id, address)
parent_organization = :                      ; Parent company (MCO-specific)
naic_number = :                              ; NAIC company number (MCO-specific)

{@mco}

; Contract information - Per 42 CFR 438.3
{.contract}
contract_number = !:                         ; State contract number
contract_effective = !date                   ; Contract start date
contract_end = date                          ; Contract end date
contract_type = (comprehensive, limited, specialty)
auto_renewal = ?                             ; Auto-renewal provisions

{@mco}

; Service area - Per 42 CFR 438.3(e)
{.service_area}
statewide = ?                                ; Statewide service area
counties[] = :                               ; Counties served (FIPS)
zip_codes[] = :                              ; ZIP codes served
regions[] = :                                ; State-defined regions

{@mco}

; Populations served - Per 42 CFR 438.3
{.populations}
tanf_medicaid = ?                            ; TANF-related Medicaid
ssi_medicaid = ?                             ; SSI-related Medicaid
chip = ?                                     ; CHIP
aged_blind_disabled = ?                      ; ABD populations
dual_eligible = ?                            ; Medicare-Medicaid duals
ltss = ?                                     ; Long-term services and supports

{@mco}

; Accreditation - Per 42 CFR 438.332
{.accreditation}
required = ?                                 ; Accreditation required
accrediting_body = (aaahc, ncqa, other, urac)
accreditation_status = (accredited, conditional, not_accredited, pending)
accreditation_date = date                    ; Current accreditation date
accreditation_expiration = date              ; Expiration date

{@mco}

; Enrollment
{.enrollment}
current_enrollment = ##:(0..)                ; Current member count
enrollment_cap = ##:(0..)                    ; Enrollment cap if any
new_enrollment_open = ?                      ; Accepting new members

{@mco}

; ═══════════════════════════════════════════════════════════════════════════════
; PLAN BENEFITS
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 438.3(e)

{@plan_benefits}
plan_id = !:                                 ; Plan ID
contract_year = !##:(2000..2100)             ; Contract year

; Covered services - Per 42 CFR 438.3(c)
{.services}
comprehensive = ?                            ; Comprehensive MCO
behavioral_only = ?                          ; BH carve-out plan
dental_only = ?                              ; Dental plan
ltss_only = ?                                ; LTSS plan

; Carved out services - Per state contract
carved_out[] = :                             ; Services carved out to FFS

{@plan_benefits}

; Value-added services
{.value_added}
offered = ?                                  ; Additional services offered
services[] = :                               ; List of value-added services

{@plan_benefits}

; Cost sharing - Per 42 CFR 438.3(d)
{.cost_sharing}
copayments = ?                               ; Plan charges copayments
copayment_amounts = @cost_sharing            ; Copayment schedule

{@plan_benefits}

; ═══════════════════════════════════════════════════════════════════════════════
; NETWORK
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 438.68 and 438.206

{@network}
plan_id = !:                                 ; Plan ID
network_id = :                               ; Network identifier

; Network adequacy - Per 42 CFR 438.68
{.adequacy}
meets_standards = ?                          ; Meets adequacy standards
time_distance_compliant = ?                  ; Time/distance standards met
exception_approved = ?                       ; State-approved exception

{@network}

; Provider counts
{.providers}
pcp_count = ##:(0..)                         ; Primary care providers
specialist_count = ##:(0..)                  ; Specialists
ob_gyn_count = ##:(0..)                      ; OB/GYN
behavioral_health_count = ##:(0..)           ; BH providers
hospital_count = ##:(0..)                    ; Hospitals
ltc_facility_count = ##:(0..)                ; LTC facilities
pharmacy_count = ##:(0..)                    ; Pharmacies

{@network}

; Access standards - Per 42 CFR 438.68
{.access}
pcp_miles_urban = ##:(0..)                   ; PCP max miles (urban)
pcp_miles_rural = ##:(0..)                   ; PCP max miles (rural)
specialist_miles_urban = ##:(0..)            ; Specialist max miles (urban)
specialist_miles_rural = ##:(0..)            ; Specialist max miles (rural)
appointment_pcp_urgent = ##:(0..)            ; PCP urgent appt (days)
appointment_pcp_routine = ##:(0..)           ; PCP routine appt (days)
appointment_specialist = ##:(0..)            ; Specialist appt (days)
appointment_behavioral = ##:(0..)            ; BH appt (days)

{@network}

; ═══════════════════════════════════════════════════════════════════════════════
; MEMBER ENROLLMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 438.54-56

{@member_enrollment}
member_id = !:                               ; Member Medicaid ID
plan_id = !:                                 ; Plan ID
enrollment_type = !(auto_assigned, beneficiary_choice, default, mandatory)

; Enrollment period
{.period}
effective_date = !date                       ; Enrollment effective date
end_date = date                              ; Enrollment end date
disenrollment_date = date                    ; Disenrollment date
lock_in_start = date                         ; Lock-in start
lock_in_end = date                           ; Lock-in end

{@member_enrollment}

; PCP assignment
{.pcp}
assigned = ?                                 ; PCP assigned
pcp_name = :                                 ; PCP name
pcp_npi = :                                  ; PCP NPI
pcp_effective = date                         ; PCP assignment date
auto_assigned = ?                            ; Auto-assigned vs member choice

{@member_enrollment}

; Enrollment method
enrollment_method = (auto, broker, community_health_worker, enrollment_center, mail, online, phone)
enrollment_broker = :                        ; Broker name if used

; Disenrollment - Per 42 CFR 438.56
{.disenrollment}
reason = (beneficiary_request, death, eligibility_loss, for_cause, plan_exit, state_action, transfer)
for_cause = ?                                ; For-cause disenrollment
for_cause_reason = :                         ; Reason if for-cause

{@member_enrollment}

; ═══════════════════════════════════════════════════════════════════════════════
; CAPITATION RATE
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 438.4-6

{@capitation_rate}
plan_id = !:                                 ; Plan ID
rate_period_start = !date                    ; Rate period start
rate_period_end = !date                      ; Rate period end

; Rate cell
{.rate_cell}
cell_id = :                                  ; Rate cell identifier
population = :                               ; Population description
age_group = :                                ; Age band
gender = :                                   ; Gender
region = :                                   ; Geographic region
aid_category = :                             ; Aid category

{@capitation_rate}

; Rate amounts - Per 42 CFR 438.5
{.rate}
base_rate = #$:(0..)                         ; Base capitation rate
risk_adjustment = #$                         ; Risk adjustment
quality_withhold = #$:(0..)                  ; Quality withhold
total_rate = #$:(0..)                        ; Total PMPM rate

{@capitation_rate}

; Actuarial certification - Per 42 CFR 438.7
{.certification}
actuarially_sound = ?                        ; Actuarially sound
actuary_name = :                             ; Certifying actuary
actuary_credentials = :                      ; Actuary credentials
certification_date = date                    ; Certification date

{@capitation_rate}

; ═══════════════════════════════════════════════════════════════════════════════
; QUALITY MEASURES
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 438.330

{@quality}
plan_id = !:                                 ; Plan ID
measurement_year = !##:(2000..2100)          ; Measurement year

; Performance measures
measures[] = @quality_measure                ; Quality measures

; Quality improvement - Per 42 CFR 438.330(d)
{.qi_program}
program = ?                                  ; QI program
pia_count = ##:(0..)                         ; Performance improvement projects

{@quality}

; External quality review - Per 42 CFR 438.350
{.eqr}
completed = ?                                ; EQR completed
eqro_name = :                                ; EQRO name
review_year = ##:(2000..2100)                ; Review year
overall_rating = :                           ; Overall rating

{@quality}

{@quality_measure}
measure_id = !:                              ; Measure identifier
measure_name = :                             ; Measure name
measure_set = (cahps, hedis, other, state)   ; Measure set
domain = :                                   ; Quality domain

; Performance
{.performance}
rate = #:(0..100)                            ; Performance rate
numerator = ##:(0..)                         ; Numerator
denominator = ##:(0..)                       ; Denominator
benchmark = #:(0..100)                       ; Benchmark/goal
met_benchmark = ?                            ; Met benchmark

{@quality_measure}

; ═══════════════════════════════════════════════════════════════════════════════
; GRIEVANCE AND APPEAL
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 438.400-424

{@grievance}
grievance_id = !:                            ; Grievance ID
plan_id = !:                                 ; Plan ID
member_id = !:                               ; Member ID
grievance_type = !(grievance, appeal)        ; Type

; Filing
{.filing}
received_date = !date                        ; Date received
filing_method = (mail, oral, written)
expedited = ?                                ; Expedited request
expedited_approved = ?                       ; Expedited approved

{@grievance}

; Issue
{.issue}
category = (access, benefits, billing, customer_service, plan_action, quality, other)
description = :                              ; Issue description
related_service = :                          ; Related service/claim

{@grievance}

; Resolution - Per 42 CFR 438.408
{.resolution}
status = !(dismissed, pending, resolved)
resolution_date = date                       ; Resolution date
resolution = :                               ; Resolution description
upheld = ?                                   ; Plan action upheld (appeals)
reversed = ?                                 ; Plan action reversed (appeals)
timely = ?                                   ; Resolved within timeframe

{@grievance}

; State fair hearing - Per 42 CFR 438.408(f)
{.state_fair_hearing}
requested = ?                                ; State fair hearing requested
request_date = date                          ; Request date
hearing_date = date                          ; Hearing date
outcome = (affirmed, dismissed, reversed)

{@grievance}


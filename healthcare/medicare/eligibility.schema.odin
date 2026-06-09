; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Medicare Eligibility Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Medicare entitlement determination and eligibility verification covering
; Part A, B, C, and D eligibility based on age, disability, and ESRD.
; Derived from CMS Pub 100-01 and 42 CFR Part 406.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as medicare

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.medicare.eligibility"
version = "1.0.0"
title = "Medicare Eligibility Schema"
description = "Medicare entitlement determination and eligibility verification"

{$derivation}
source[0].authority = "CMS"
source[0].citation = "Medicare General Information, Eligibility, and Entitlement Manual (CMS Pub 100-01) Chapter 2"
source[0].url = "https://www.cms.gov/Regulations-and-Guidance/Guidance/Manuals/Downloads/ge101c02.pdf"

source[1].authority = "GPO"
source[1].citation = "42 CFR Part 406 - Hospital Insurance Eligibility and Entitlement"
source[1].url = "https://www.ecfr.gov/current/title-42/chapter-IV/subchapter-B/part-406"

source[2].authority = "CMS"
source[2].citation = "HIPAA Eligibility Transaction System (HETS) 270/271 Companion Guide"
source[2].url = "https://www.cms.gov/Research-Statistics-Data-and-Systems/CMS-Information-Technology/HETSHelp"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial Medicare eligibility schema"
changelog[0].rationale = "Structure derived from CMS Pub 100-01 and 42 CFR Part 406"

; ═══════════════════════════════════════════════════════════════════════════════
; ELIGIBILITY DETERMINATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per CMS Pub 100-01 Chapter 2 - Eligibility and Entitlement

{@determination}
beneficiary = @medicare.beneficiary         ; Beneficiary information
determination_date = date                   ; Date of determination

; Overall eligibility status
eligible = ?                                ; Overall Medicare eligibility
eligible_parts[] = (a, b, c, d)              ; Parts eligible for

; ───────────────────────────────────────────────────────────────────────────────
; Part A Eligibility - Per 42 CFR 406.10-406.15
; ───────────────────────────────────────────────────────────────────────────────
{.part_a}
eligible = ?                                ; Part A eligible
entitlement_basis = @medicare.entitlement_basis  ; Basis for entitlement
premium_free = ?                             ; Premium-free Part A
earliest_effective = date                    ; Earliest effective date

; Age-based - Per 42 CFR 406.10
age_eligible = ?                             ; Eligible based on age
age_65_date = date:if age_eligible = true    ; Date attained age 65

; Disability-based - Per 42 CFR 406.12
disability_eligible = ?                      ; Eligible based on disability
ssdi_entitlement_months = ##:(0..24)         ; Months of SSDI entitlement
als_diagnosed = ?                            ; ALS diagnosis (no waiting period)

; ESRD-based - Per 42 CFR 406.13
esrd_eligible = ?                            ; Eligible based on ESRD
dialysis_months = ##:(0..)                   ; Months receiving dialysis
kidney_transplant = ?                        ; Had kidney transplant

; Quarters of coverage - Per 42 CFR 406.10(a)
quarters_of_coverage = ##:(0..40)            ; Own quarters of coverage
spouse_quarters = ##:(0..40)                 ; Spouse's quarters (derivative)
government_employment = ?                    ; Federal/state employment (no FICA)

{@determination}

; ───────────────────────────────────────────────────────────────────────────────
; Part B Eligibility - Per 42 CFR 407.10
; ───────────────────────────────────────────────────────────────────────────────
{.part_b}
eligible = ?                                ; Part B eligible
eligible_if_part_a = ?                       ; Eligible because Part A eligible
us_resident = ?                              ; US resident requirement
citizen_or_lawful = ?                        ; Citizen or lawfully present

; Part B requirements (must be Part A eligible OR meet these)
age_65_or_older = ?                          ; Age 65 or older
disability_eligible = ?                      ; Disability eligible

{@determination}

; ───────────────────────────────────────────────────────────────────────────────
; Part C (MA) Eligibility - Per 42 CFR 422.50
; ───────────────────────────────────────────────────────────────────────────────
{.part_c}
eligible = ?                                ; Part C (MA) eligible
enrolled_part_a = ?                          ; Enrolled in Part A (required)
enrolled_part_b = ?                          ; Enrolled in Part B (required)
esrd_exception = ?                           ; ESRD exception applies
service_area_resident = ?                    ; Lives in plan service area
incarcerated = ?                             ; Not incarcerated (required)

{@determination}

; ───────────────────────────────────────────────────────────────────────────────
; Part D Eligibility - Per 42 CFR 423.30
; ───────────────────────────────────────────────────────────────────────────────
{.part_d}
eligible = ?                                ; Part D eligible
entitled_part_a = ?                          ; Entitled to Part A
enrolled_part_b = ?                          ; Enrolled in Part B
us_resident = ?                              ; US resident

; Creditable coverage determination
creditable_coverage = ?                      ; Other creditable coverage
creditable_coverage_type = :                 ; Type of creditable coverage

{@determination}

; ═══════════════════════════════════════════════════════════════════════════════
; ELIGIBILITY VERIFICATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per CMS HETS 270/271 transaction structure

{@verification}
; Request information
request_date = date                         ; Date of verification request
verification_type = (eligibility_only, eligibility_with_benefits)

; Beneficiary identifiers
mbi = *:                                     ; Medicare Beneficiary Identifier
hicn = *:                                    ; Legacy HICN (if used)
date_of_birth = *date                        ; Date of birth
last_name = :                                ; Beneficiary last name

; Service date range
service_date_from = date                     ; Service date range start
service_date_to = date                       ; Service date range end

; Response status
{.response}
response_date = date                         ; Date of response
response_code = :                            ; Response code
active_coverage = ?                          ; Has active Medicare coverage

{@verification}

; Coverage details returned
{.coverage}
part_a_active = ?                            ; Part A active
part_a_effective = date                      ; Part A effective date
part_a_termination = date                    ; Part A termination date

part_b_active = ?                            ; Part B active
part_b_effective = date                      ; Part B effective date
part_b_termination = date                    ; Part B termination date

part_c_active = ?                            ; Part C (MA) active
part_c_contract = :                          ; MA contract number
part_c_plan = :                              ; MA plan ID
part_c_effective = date                      ; MA effective date
part_c_termination = date                    ; MA termination date

part_d_active = ?                            ; Part D active
part_d_contract = :                          ; Part D contract number
part_d_plan = :                              ; Part D plan ID
part_d_effective = date                      ; Part D effective date
part_d_termination = date                    ; Part D termination date

{@verification}

; Coordination of benefits
{.cob}
msp_applies = ?                              ; Medicare Secondary Payer
msp_type = (disability_large_group, esrd_coordination, no_fault, workers_comp, working_aged)
other_payer_name = :                         ; Other payer name
other_payer_id = :                           ; Other payer ID

{@verification}

; Hospice election
{.hospice}
elected = ?                                  ; Hospice election active
election_date = date                         ; Date hospice elected
hospice_npi = :                              ; Hospice provider NPI

{@verification}

; ═══════════════════════════════════════════════════════════════════════════════
; DUAL ELIGIBLE STATUS
; ═══════════════════════════════════════════════════════════════════════════════
; Per CMS Medicare-Medicaid coordination

{@dual_eligible}
beneficiary = @medicare.beneficiary         ; Beneficiary information

; Dual status - Per 42 CFR 423.772
dual_eligible = ?                           ; Medicare-Medicaid dual eligible
dual_type = (fbde, other_full, partial, qmb_only, qmb_plus, slmb_only, slmb_plus):if dual_eligible = true

; Dual type definitions:
; fbde = Full Benefit Dual Eligible
; qmb_only = Qualified Medicare Beneficiary (Medicare cost-sharing only)
; qmb_plus = QMB plus Medicaid
; slmb_only = Specified Low-Income Medicare Beneficiary (Part B premium only)
; slmb_plus = SLMB plus Medicaid
; partial = Partial dual (QI, QDWI)
; other_full = Full Medicaid but not QMB/SLMB

; Medicare Savings Program status
{.msp_status}
qmb = ?                                      ; Qualified Medicare Beneficiary
slmb = ?                                     ; Specified Low-Income Medicare Beneficiary
qi = ?                                       ; Qualifying Individual
qdwi = ?                                     ; Qualified Disabled Working Individual

{@dual_eligible}

; Medicaid information
{.medicaid}
medicaid_id = *:                             ; Medicaid ID
medicaid_state = :(2)                        ; State of Medicaid coverage
medicaid_effective = date                    ; Medicaid effective date
full_medicaid = ?                            ; Full Medicaid benefits
medicaid_mco = :                             ; Medicaid managed care plan

{@dual_eligible}

; Special Needs Plan eligibility
{.snp}
d_snp_eligible = ?                           ; Dual-eligible SNP eligible
chronic_snp_eligible = ?                     ; Chronic condition SNP eligible
institutional_snp_eligible = ?               ; Institutional SNP eligible

{@dual_eligible}

; ═══════════════════════════════════════════════════════════════════════════════
; SPECIAL ENROLLMENT PERIOD DETERMINATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 406.24, 407.20, 422.62, 423.38

{@sep_determination}
beneficiary = @medicare.beneficiary         ; Beneficiary information
request_date = date                         ; Date SEP requested

; SEP qualification
qualifies = ?                               ; Qualifies for SEP
sep_type = @medicare.enrollment_period:if qualifies = true

; Qualifying event - Per 42 CFR 422.62(b), 423.38(c)
{.qualifying_event}
event_type = (chronic_condition, contract_violation, disenrollment, dual_eligible_change, employer_coverage, five_star, incarceration_release, lawful_presence, medicaid_change, move, natural_disaster, other, snp_loss)
event_date = date                           ; Date of qualifying event
documentation_type = :                       ; Required documentation type
documentation_received = ?                   ; Documentation received

{@sep_determination}

; SEP details
{.sep_details}
start_date = date                            ; SEP start date
end_date = date                              ; SEP end date
parts_available[] = (a, b, c, d)             ; Parts available during SEP
enrollment_effective = date                  ; Effective date if enrolled during SEP

{@sep_determination}

; Employer coverage SEP - Per 42 CFR 407.20
{.employer_sep}
employer_name = :                            ; Employer name
ghp_coverage_type = (cobra, employer, retiree)
ghp_end_date = date                          ; Date GHP coverage ended/ending
employer_size = ##:(0..)                     ; Employer size (20+ for working aged)
employment_status = (current, former, spouse_current, spouse_former)

{@sep_determination}

; Move SEP - Per 42 CFR 422.62(b)(1)
{.move_sep}
previous_address = @address                  ; Previous address
new_address = @address                       ; New address
move_date = date                             ; Date of move
permanent_move = ?                           ; Permanent residence change
service_area_change = ?                      ; Lost access to prior plan

{@sep_determination}

; ═══════════════════════════════════════════════════════════════════════════════
; ENTITLEMENT RECORD
; ═══════════════════════════════════════════════════════════════════════════════
; Per SSA/CMS entitlement data

{@entitlement_record}
beneficiary = @medicare.beneficiary         ; Beneficiary information

; Current entitlement status
{.current}
part_a_entitled = ?                          ; Currently entitled to Part A
part_a_effective = date                      ; Part A effective date
part_b_enrolled = ?                          ; Currently enrolled in Part B
part_b_effective = date                      ; Part B effective date

{@entitlement_record}

; Entitlement history
history[] = @entitlement_history_entry       ; Entitlement history entries

{@entitlement_history_entry}
part = (a, b)                               ; Medicare part
action = (enrolled, terminated)             ; Action type
effective_date = date                       ; Action effective date
reason = :                                   ; Reason for action
source = :                                   ; Source of entitlement/termination


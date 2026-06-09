; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Medicare Enrollment Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Medicare enrollment for Parts A, B, C (Medicare Advantage), and D including
; enrollment periods, premiums, and late enrollment penalties. Derived from
; CMS enrollment forms and 42 CFR Parts 406, 407, 422, 423.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as medicare

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.medicare.enrollment"
version = "1.0.0"
title = "Medicare Enrollment Schema"
description = "Medicare Part A, B, C, D enrollment processes"

{$derivation}
source[0].authority = "CMS"
source[0].citation = "CMS-40B Application for Enrollment in Medicare Part B"
source[0].url = "https://www.cms.gov/medicare/cms-forms/cms-forms/cms-forms-items/cms017339"

source[1].authority = "CMS"
source[1].citation = "CMS-L564 Request for Employment Information"
source[1].url = "https://www.cms.gov/medicare/cms-forms/cms-forms/cms-forms-items/cms009718"

source[2].authority = "CMS"
source[2].citation = "Medicare Managed Care Manual (CMS Pub 100-16) Chapter 2 - Enrollment/Disenrollment"
source[2].url = "https://www.cms.gov/regulations-and-guidance/guidance/manuals/internet-only-manuals-ioms"

source[3].authority = "GPO"
source[3].citation = "42 CFR Part 406 - Hospital Insurance Eligibility and Entitlement"
source[3].url = "https://www.ecfr.gov/current/title-42/chapter-IV/subchapter-B/part-406"

source[4].authority = "GPO"
source[4].citation = "42 CFR Part 407 - Supplementary Medical Insurance Enrollment and Entitlement"
source[4].url = "https://www.ecfr.gov/current/title-42/chapter-IV/subchapter-B/part-407"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial Medicare enrollment schema"
changelog[0].rationale = "Structure derived from CMS forms and 42 CFR Parts 406, 407, 422, 423"

; ═══════════════════════════════════════════════════════════════════════════════
; PART A ENROLLMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR Part 406 - Hospital Insurance

{@part_a_enrollment}
beneficiary = @medicare.beneficiary         ; Beneficiary information

; Enrollment period
period = @enrollment_period                  ; Enrollment period with status

; Premium status - Per 42 CFR 406.20
{.premium_status}
premium_free = ?                             ; Qualified for premium-free Part A
covered_quarters = ##:(0..40)                ; Quarters of coverage (40 = premium-free)
spouse_quarters = ##:(0..40)                 ; Spouse's quarters (for derivative entitlement)

{@part_a_enrollment}

; Premium Part A - Per 42 CFR 406.21 (for those who must pay)
{.premium_part_a}
monthly_premium = #$:(0..)                   ; Monthly premium amount
rate_type = (full, reduced)                  ; Full (under 30 QCs) or reduced (30-39 QCs)
penalty_percent = #:(0..100)                 ; Late enrollment penalty percentage

{@part_a_enrollment}

; Entitlement basis - Per 42 CFR 406.10-406.15
entitlement = @medicare.entitlement_basis   ; Basis for entitlement

; Enrollment period - Per 42 CFR 406.21
enrollment_period = @medicare.enrollment_period  ; Period used for enrollment

; Application details
{.application}
application_date = date                      ; Date application submitted
application_method = (mail, online, phone, ssa_office)
application_number = :                       ; Application tracking number
decision_date = date                         ; Date of decision
decision = (approved, denied, pending)
denial_reason = :                            ; Reason if denied

{@part_a_enrollment}

; ═══════════════════════════════════════════════════════════════════════════════
; PART B ENROLLMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR Part 407 - Supplementary Medical Insurance and CMS-40B

{@part_b_enrollment}
beneficiary = @medicare.beneficiary         ; Beneficiary information

; Enrollment period
period = @enrollment_period                  ; Enrollment period with status

; Premium - Per 42 CFR 407.20
{.premium}
monthly_premium = #$:(0..)                   ; Monthly Part B premium
standard_premium = #$:(0..)                  ; Standard premium for the year
penalty_percent = #:(0..100)                 ; Late enrollment penalty percentage
penalty_months = ##:(0..)                    ; Months without coverage (for penalty calc)

{@part_b_enrollment}

; IRMAA - Per 42 CFR 407.20 (Income-Related Monthly Adjustment Amount)
{.irmaa}
applies = ?                                  ; IRMAA surcharge applies
bracket = ##:(1..5)                          ; IRMAA income bracket
surcharge = #$:(0..)                         ; Monthly IRMAA surcharge
magi_used = #$:(0..)                         ; MAGI from tax return
tax_year = ##:(2000..2100)                   ; Tax year used for MAGI determination
appeal_filed = ?                             ; Life-changing event appeal filed

{@part_b_enrollment}

; Enrollment period - Per 42 CFR 407.14-407.20
enrollment_period = @medicare.enrollment_period

; SEP for working aged - Per 42 CFR 407.20 (CMS-L564)
{.sep_employer}
qualifies = ?                                ; Qualifies for employer SEP
employer_name = :                            ; Current/former employer
employer_address = @address                  ; Employer address
ghp_coverage_end = date                      ; Date GHP coverage ended/will end
employer_size = ##:(0..)                     ; Number of employees
employment_status = (current, former)        ; Employment status
l564_submitted = ?                           ; CMS-L564 form submitted
l564_date = date                             ; CMS-L564 submission date

{@part_b_enrollment}

; Application details - Per CMS-40B
{.application}
application_date = date                      ; Date application submitted
application_method = (mail, online, phone, ssa_office)
form_40b_submitted = ?                       ; CMS-40B submitted
application_number = :                       ; Application tracking number
decision_date = date                         ; Date of decision
decision = (approved, denied, pending)
denial_reason = :                            ; Reason if denied

{@part_b_enrollment}

; Declination - Per 42 CFR 407.56
{.decline}
declined = ?                                 ; Beneficiary declined Part B
decline_date = date                          ; Date of declination
decline_form_signed = ?                      ; Refusal form signed
decline_reason = (employer_coverage, other, va_coverage)

{@part_b_enrollment}

; ═══════════════════════════════════════════════════════════════════════════════
; PART C (MEDICARE ADVANTAGE) ENROLLMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR Part 422 and CMS Pub 100-16 Chapter 2

{@part_c_enrollment}
beneficiary = @medicare.beneficiary         ; Beneficiary information

; Enrollment period
period = @enrollment_period                  ; Enrollment period with status

; Plan information - Per 42 CFR 422.50
{.plan}
contract_number = :                          ; CMS contract number (H####)
plan_id = :                                  ; Plan benefit package ID
plan_name = :                                ; Plan marketing name
plan_type = (hmo, hmo_pos, local_ppo, msa, pffs, regional_ppo, snp)
organization_name = :                        ; Medicare Advantage Organization

{@part_c_enrollment}

; SNP type if applicable - Per 42 CFR 422.2
snp_type = (c_snp, d_snp, i_snp):if plan.plan_type = snp
; c_snp = Chronic condition SNP
; d_snp = Dual-eligible SNP
; i_snp = Institutional SNP

; Enrollment period - Per 42 CFR 422.62
enrollment_period = @medicare.enrollment_period

; Lock-in period - Per 42 CFR 422.68
{.lock_in}
lock_in_applies = ?                          ; Enrollment lock-in applies
lock_in_start = date                         ; Lock-in period start
lock_in_end = date                           ; Lock-in period end
disenrollment_allowed = ?                    ; Can disenroll during lock-in

{@part_c_enrollment}

; Part D enrollment (for MA-PD plans) - Per 42 CFR 423.30
{.part_d}
included = ?                                 ; Plan includes Part D (MA-PD)
part_d_contract = ::if included = true       ; Part D contract number
part_d_pbp = ::if included = true            ; Part D plan benefit package

{@part_c_enrollment}

; Enrollment application
{.application}
application_date = date                      ; Application submission date
application_method = (agent, mail, online, phone, plan_representative)
confirmation_number = :                      ; Enrollment confirmation number
acknowledgment_date = date                   ; Date plan acknowledged enrollment
cob_verified = ?                             ; Coordination of benefits verified

{@part_c_enrollment}

; Disenrollment - Per 42 CFR 422.74
{.disenrollment}
disenrollment_date = date                    ; Effective date of disenrollment
reason = (beneficiary_request, contract_termination, death, incarceration, loss_of_entitlement, loss_of_residence, nonpayment, plan_initiated, return_to_original_medicare)
involuntary = ?                              ; Involuntary disenrollment
notice_date = date                           ; Date disenrollment notice sent

{@part_c_enrollment}

; ═══════════════════════════════════════════════════════════════════════════════
; PART D ENROLLMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR Part 423 and CMS Pub 100-18

{@part_d_enrollment}
beneficiary = @medicare.beneficiary         ; Beneficiary information

; Enrollment period
period = @enrollment_period                  ; Enrollment period with status

; Plan information - Per 42 CFR 423.30
{.plan}
contract_number = :                          ; CMS contract number (S#### or H####)
plan_id = :                                  ; Plan benefit package ID
plan_name = :                                ; Plan marketing name
plan_type = (employer_pdp, ma_pd, pdp)       ; Plan type
organization_name = :                        ; Plan sponsor name
region = ##:(1..34)                          ; PDP region number

{@part_d_enrollment}

; Premium - Per 42 CFR 423.286
{.premium}
plan_premium = #$:(0..)                      ; Plan's monthly premium
base_beneficiary_premium = #$:(0..)          ; National base premium
penalty_percent = #:(0..100)                 ; Late enrollment penalty percentage
penalty_months = ##:(0..)                    ; Months without creditable coverage
total_monthly = #$:(0..)                     ; Total monthly premium

{@part_d_enrollment}

; IRMAA - Per 42 CFR 423.286(d)
{.irmaa}
applies = ?                                  ; Part D IRMAA applies
bracket = ##:(1..5)                          ; Income bracket
surcharge = #$:(0..)                         ; Monthly IRMAA surcharge

{@part_d_enrollment}

; Creditable coverage - Per 42 CFR 423.56
{.creditable_coverage}
had_creditable = ?                           ; Had creditable coverage before Part D
creditable_months = ##:(0..)                 ; Months of creditable coverage
gap_months = ##:(0..)                        ; Months without creditable coverage (63+ triggers penalty)
attestation_received = ?                     ; Creditable coverage attestation received

{@part_d_enrollment}

; Low Income Subsidy - Per 42 CFR 423.773
lis = @medicare.low_income_subsidy           ; Extra Help/LIS status

; Auto-enrollment - Per 42 CFR 423.34
{.auto_enrollment}
auto_enrolled = ?                            ; Was auto-enrolled
auto_enrollment_type = (facilitated, lis_reassignment, msp_transition):if auto_enrolled = true
opted_out = ?                                ; Opted out of auto-enrollment

{@part_d_enrollment}

; Enrollment period - Per 42 CFR 423.38
enrollment_period = @medicare.enrollment_period

; Application
{.application}
application_date = date                      ; Application submission date
application_method = (agent, mail, online, phone, plan_representative)
confirmation_number = :                      ; Enrollment confirmation number
acknowledgment_date = date                   ; Date plan acknowledged enrollment

{@part_d_enrollment}

; Disenrollment - Per 42 CFR 423.44
{.disenrollment}
disenrollment_date = date                    ; Effective date
reason = (beneficiary_request, contract_termination, death, employer_coverage, incarceration, loss_of_entitlement, loss_of_residence, ma_enrollment, nonpayment, plan_initiated)
involuntary = ?                              ; Involuntary disenrollment

{@part_d_enrollment}

; ═══════════════════════════════════════════════════════════════════════════════
; ENROLLMENT TRANSACTION
; ═══════════════════════════════════════════════════════════════════════════════
; Per CMS enrollment transaction requirements

{@enrollment_transaction}
transaction_id = :                          ; Unique transaction identifier
transaction_type = (disenrollment, enrollment, reenrollment)
transaction_date = date                     ; Date transaction submitted

; Parts affected
parts[] = (a, b, c, d)                      ; Medicare parts in transaction

; Status
status = (accepted, pending, rejected)
status_date = date                           ; Date of status
rejection_reason = :                         ; Reason if rejected

; Source system
source = (beneficiary, cms, plan, ssa, state)  ; Transaction source
submitted_by = :                             ; User/entity who submitted


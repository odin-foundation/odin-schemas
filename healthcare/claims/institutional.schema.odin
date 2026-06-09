; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Healthcare Institutional Claim Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Institutional healthcare claims for hospital and facility services. Derived
; from public CMS UB-04 form instructions and Medicare claims processing manuals.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as claims

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.claims.institutional"
version = "1.0.0"
title = "Healthcare Institutional Claim Schema"
description = "Institutional healthcare claims derived from UB-04 structure"

{$derivation}
source[0].authority = "CMS"
source[0].citation = "UB-04 Data Specifications Manual - Public Form Instructions"
source[0].url = "https://www.nubc.org/"

source[1].authority = "CMS"
source[1].citation = "Medicare Claims Processing Manual Chapter 25 - Completing and Processing UB-04"
source[1].url = "https://www.cms.gov/Regulations-and-Guidance/Guidance/Manuals/Downloads/clm104c25.pdf"

source[2].authority = "CMS"
source[2].citation = "Medicare Claims Processing Manual Chapter 3 - Inpatient Hospital Billing"
source[2].url = "https://www.cms.gov/Regulations-and-Guidance/Guidance/Manuals/Downloads/clm104c03.pdf"

source[3].authority = "CMS"
source[3].citation = "Medicare Claims Processing Manual Chapter 4 - Outpatient Hospital Billing"
source[3].url = "https://www.cms.gov/Regulations-and-Guidance/Guidance/Manuals/Downloads/clm104c04.pdf"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial institutional claim schema"
changelog[0].rationale = "Structure derived from UB-04 form layout and CMS instructions"

; ═══════════════════════════════════════════════════════════════════════════════
; INSTITUTIONAL CLAIM
; ═══════════════════════════════════════════════════════════════════════════════
; Per UB-04 form structure (Form Locators 1-81)

{@claim}
; ───────────────────────────────────────────────────────────────────────────────
; Claim Identification
; ───────────────────────────────────────────────────────────────────────────────
claim_id = :                                 ; Unique claim identifier
original_claim_id = :                         ; Original claim (for adjustments)

; Type of bill (FL 4) - 3 or 4 digits
type_of_bill = :/^\d{3,4}$/                  ; Type of bill code
; First digit: Facility type
; Second digit: Bill classification
; Third digit: Frequency

; ───────────────────────────────────────────────────────────────────────────────
; Provider Information (FL 1-5)
; ───────────────────────────────────────────────────────────────────────────────
billing_provider = @claims.provider          ; Billing provider (FL 1)
federal_tax_id = *:                           ; Federal tax number (FL 5)

; Pay-to provider (if different)
{.pay_to}
name = :                                      ; Pay-to name (FL 2)
address_line1 = :                             ; Pay-to address
address_line2 = :
city = :
state = :(2)
zip = :/^\d{5}(\d{4})?$/

{@claim}

; ───────────────────────────────────────────────────────────────────────────────
; Patient Information (FL 8-17)
; ───────────────────────────────────────────────────────────────────────────────
patient = @claims.subscriber                 ; Patient information

; Patient control number (FL 3a)
patient_control_number = :                   ; Patient account number

; Medical record number (FL 3b)
medical_record_number = :                     ; Medical record number

; Birth date and sex (FL 10, 11)
patient_birth_date = *date                   ; Patient date of birth
patient_sex = (female, male, unknown)        ; Administrative sex

; Admission/discharge (FL 12-17)
{.admission}
date = date                                  ; Admission date (FL 12)
hour = :(2)                                   ; Admission hour (FL 13)
type = :(1)                                   ; Admission type code (FL 14)
source = :(1)                                 ; Admission source code (FL 15)
discharge_hour = :(2)                         ; Discharge hour (FL 16)
status = :(2)                                ; Patient status code (FL 17)

{@claim}

; ───────────────────────────────────────────────────────────────────────────────
; Condition Codes (FL 18-28)
; ───────────────────────────────────────────────────────────────────────────────
condition_codes[] = :(2)                      ; Condition codes (up to 11)

; ───────────────────────────────────────────────────────────────────────────────
; Occurrence Codes and Dates (FL 31-36)
; ───────────────────────────────────────────────────────────────────────────────
occurrences[] = @occurrence                   ; Occurrence codes with dates

{@occurrence}
code = :(2)                                  ; Occurrence code
date = date                                  ; Occurrence date

{@claim}

; ───────────────────────────────────────────────────────────────────────────────
; Occurrence Span Codes and Dates (FL 35-36)
; ───────────────────────────────────────────────────────────────────────────────
occurrence_spans[] = @occurrence_span         ; Occurrence span codes

{@occurrence_span}
code = :(2)                                  ; Occurrence span code
from_date = date                             ; From date
through_date = date                          ; Through date

{@claim}

; ───────────────────────────────────────────────────────────────────────────────
; Value Codes and Amounts (FL 39-41)
; ───────────────────────────────────────────────────────────────────────────────
value_codes[] = @value_code                   ; Value codes with amounts

{@value_code}
code = :(2)                                  ; Value code
amount = #$                                  ; Value amount

{@claim}

; ───────────────────────────────────────────────────────────────────────────────
; Revenue Codes and Service Lines (FL 42-49)
; ───────────────────────────────────────────────────────────────────────────────
revenue_lines[] = @revenue_line               ; Revenue code lines

; ───────────────────────────────────────────────────────────────────────────────
; Payer Information (FL 50-65)
; ───────────────────────────────────────────────────────────────────────────────
payers[] = @institutional_payer               ; Payer information (up to 3)

{@institutional_payer}
payer = @claims.payer                        ; Payer details
payer_sequence = (primary, secondary, tertiary)
health_plan_id = :                            ; Health plan ID (FL 51)
release_of_info = (informed_consent, no, yes) ; Release of info (FL 52)
assignment_of_benefits = (no, yes)            ; Assignment of benefits (FL 53)
prior_payments = #$:(0..)                     ; Prior payments (FL 54)
estimated_amount_due = #$:(0..)               ; Estimated amount due (FL 55)

; Insured information (FL 58-62)
{.insured}
name = :                                      ; Insured name (FL 58)
relationship = (cadaver_donor, child, employee, life_partner, organ_donor, other, self, spouse, unknown)
unique_id = :                                 ; Insured unique ID (FL 60)
group_name = :                                ; Insured group name (FL 61)
group_number = :                              ; Insured group number (FL 62)

{@institutional_payer}

; Authorization
authorization_codes[] = :                     ; Treatment authorization codes (FL 63)

{@claim}

; ───────────────────────────────────────────────────────────────────────────────
; Diagnosis and Procedure Codes (FL 66-74)
; ───────────────────────────────────────────────────────────────────────────────
; Principal diagnosis (FL 67)
principal_diagnosis = @claims.diagnosis      ; Principal diagnosis

; Other diagnoses (FL 67A-Q)
other_diagnoses[] = @claims.diagnosis         ; Secondary diagnoses (up to 17)

; Admitting diagnosis (FL 69)
admitting_diagnosis = @claims.diagnosis       ; Admitting diagnosis

; External cause of injury (FL 72)
external_causes[] = @claims.diagnosis         ; E-codes/external cause codes

; Patient reason for visit (FL 70)
patient_reason_diagnoses[] = @claims.diagnosis ; Outpatient reason for visit

; Principal procedure (FL 74)
principal_procedure = @institutional_procedure ; Principal procedure

; Other procedures (FL 74a-e)
other_procedures[] = @institutional_procedure ; Other procedures (up to 5)

{@institutional_procedure}
code = :/^[A-Z0-9]{7}$/                      ; ICD-10-PCS code
date = date                                  ; Procedure date
description = :                               ; Procedure description

{@claim}

; ───────────────────────────────────────────────────────────────────────────────
; Attending and Other Providers (FL 76-79)
; ───────────────────────────────────────────────────────────────────────────────
attending_provider = @claims.provider        ; Attending physician (FL 76)
operating_provider = @claims.provider         ; Operating physician (FL 77)
other_providers[] = @claims.provider          ; Other providers (FL 78-79)

; ───────────────────────────────────────────────────────────────────────────────
; Remarks (FL 80)
; ───────────────────────────────────────────────────────────────────────────────
remarks = :                                   ; Remarks field

; ───────────────────────────────────────────────────────────────────────────────
; Code-Code Field (FL 81)
; ───────────────────────────────────────────────────────────────────────────────
code_code[] = @code_code_entry                ; Code-code entries

{@code_code_entry}
qualifier = :(2)                              ; Code qualifier
code = :                                      ; Code value

{@claim}

; ───────────────────────────────────────────────────────────────────────────────
; Totals (FL 47)
; ───────────────────────────────────────────────────────────────────────────────
{.totals}
total_charges = #$:(0..)                     ; Total charges
non_covered_charges = #$:(0..)                ; Total non-covered charges

{@claim}

; ───────────────────────────────────────────────────────────────────────────────
; Claim Status
; ───────────────────────────────────────────────────────────────────────────────
status = @claims.claim_status                 ; Current claim status
status_history[] = @claims.claim_status       ; Status history

; ═══════════════════════════════════════════════════════════════════════════════
; REVENUE LINE
; ═══════════════════════════════════════════════════════════════════════════════
; Per UB-04 FL 42-49 structure

{@revenue_line}
line_number = ##:(1..)                       ; Line number

; Revenue code (FL 42)
revenue_code = :/^\d{4}$/                    ; 4-digit revenue code
revenue_description = :                       ; Revenue code description

; HCPCS/Rates (FL 44)
hcpcs_code = :                                ; HCPCS/CPT code
hcpcs_modifiers[] = :(2)                      ; HCPCS modifiers

; Service date (FL 45)
service_date = date                           ; Date of service

; Service units (FL 46)
units = ##:(0..)                              ; Service units

; Total charges (FL 47)
total_charges = #$:(0..)                     ; Total charges for line

; Non-covered charges (FL 48)
non_covered_charges = #$:(0..)                ; Non-covered charges

; Diagnosis pointers
diagnosis_pointers[] = ##:(1..18)             ; Links to diagnoses

; Drug information (for pharmacy lines)
{.drug}
ndc = :/^\d{11}$/                             ; National Drug Code
ndc_unit_qualifier = (f2, gr, me, ml, un)     ; NDC unit of measure
ndc_quantity = #:(0..)                        ; NDC quantity

{@revenue_line}

; ═══════════════════════════════════════════════════════════════════════════════
; DRG INFORMATION
; ═══════════════════════════════════════════════════════════════════════════════
; Diagnosis Related Group for inpatient

{@drg}
code = :                                     ; DRG code
type = (ap_drg, apr_drg, cms_drg, ms_drg)     ; DRG type
description = :                               ; DRG description
weight = #:(0..)                              ; DRG relative weight
severity = ##:(1..4)                          ; Severity of illness (APR-DRG)
mortality = ##:(1..4)                         ; Risk of mortality (APR-DRG)

; ═══════════════════════════════════════════════════════════════════════════════
; INSTITUTIONAL REMITTANCE
; ═══════════════════════════════════════════════════════════════════════════════
; Remittance advice for institutional claims

{@remittance}
remittance_id = :                            ; Unique remittance identifier
check_number = :                              ; Check/EFT number
remittance_date = date                       ; Remittance date

; Payer
payer = @claims.payer                        ; Payer issuing remittance

; Provider (payee)
payee = @claims.provider                     ; Provider receiving payment

; Totals
{.totals}
total_claim_count = ##:(0..)                  ; Number of claims
total_charges = #$:(0..)                      ; Total billed charges
total_paid = #$:(0..)                         ; Total paid amount
total_patient_responsibility = #$:(0..)       ; Total patient responsibility
total_contractual = #$:(0..)                  ; Total contractual adjustments

{@remittance}

; Claim payments
claim_payments[] = @institutional_claim_payment

{@institutional_claim_payment}
claim_id = :                                 ; Original claim ID
patient_control_number = :                    ; Patient control number
patient = @claims.subscriber                 ; Patient

; Claim status
claim_status = (denied, paid, primary_forwarded)
drg = @drg                                    ; DRG information (inpatient)

; Amounts
{.amounts}
total_charges = #$:(0..)                      ; Total claim charges
paid_amount = #$:(0..)                        ; Amount paid
patient_responsibility = #$:(0..)             ; Patient responsibility
contractual_adjustment = #$:(0..)             ; Contractual adjustment

{@institutional_claim_payment}

; Adjustments
adjustments[] = @claims.adjustment            ; Claim-level adjustments

; Revenue line payments
revenue_line_payments[] = @revenue_line_payment

{@revenue_line_payment}
revenue_code = :/^\d{4}$/                    ; Revenue code
service_date = date                           ; Date of service
hcpcs_code = :                                ; HCPCS code if applicable

; Amounts
{.amounts}
charged = #$:(0..)                            ; Charged amount
allowed = #$:(0..)                            ; Allowed amount
paid = #$:(0..)                               ; Paid amount
deductible = #$:(0..)                         ; Applied deductible
coinsurance = #$:(0..)                        ; Patient coinsurance
copay = #$:(0..)                              ; Patient copay

{@revenue_line_payment}

; Adjustments
adjustments[] = @claims.adjustment            ; Line-level adjustments

; Remark codes
remark_codes[] = :                            ; Remark codes


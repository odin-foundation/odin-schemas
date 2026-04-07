; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Healthcare Professional Claim Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Professional healthcare claims for physician and outpatient services. Derived
; from public CMS-1500 form instructions and Medicare claims processing manuals.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as claims

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.claims.professional"
version = "1.0.0"
title = "Healthcare Professional Claim Schema"
description = "Professional healthcare claims derived from CMS-1500 structure"

{$derivation}
source[0].authority = "CMS"
source[0].citation = "CMS-1500 Health Insurance Claim Form Instructions"
source[0].url = "https://www.cms.gov/medicare/cms-forms/cms-forms/downloads/cms1500.pdf"

source[1].authority = "CMS"
source[1].citation = "Medicare Claims Processing Manual Chapter 12 - Physician/Practitioner Billing"
source[1].url = "https://www.cms.gov/Regulations-and-Guidance/Guidance/Manuals/Downloads/clm104c12.pdf"

source[2].authority = "HHS"
source[2].citation = "HIPAA 45 CFR 162.1102 - Retail Pharmacy Drug Claims"
source[2].url = "https://www.ecfr.gov/current/title-45/section-162.1102"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial professional claim schema"
changelog[0].rationale = "Structure derived from CMS-1500 form layout and instructions"

; ═══════════════════════════════════════════════════════════════════════════════
; PROFESSIONAL CLAIM
; ═══════════════════════════════════════════════════════════════════════════════
; Per CMS-1500 form structure

{@claim}
; ───────────────────────────────────────────────────────────────────────────────
; Claim Identification
; ───────────────────────────────────────────────────────────────────────────────
claim_id = !:                                 ; Unique claim identifier
original_claim_id = :                         ; Original claim (for adjustments)
claim_frequency = !(adjustment, original, replacement, void)

; ───────────────────────────────────────────────────────────────────────────────
; Payer Information (CMS-1500 Items 1-4, 9, 11)
; ───────────────────────────────────────────────────────────────────────────────
payer = !@claims.payer                        ; Primary payer
secondary_payer = @claims.payer               ; Secondary payer (if applicable)

; Insurance type (Item 1)
insurance_type = !(champus, champva, feca, group_health, medicaid, medicare, other)

; ───────────────────────────────────────────────────────────────────────────────
; Subscriber/Insured Information (CMS-1500 Items 1a, 4, 7, 11)
; ───────────────────────────────────────────────────────────────────────────────
subscriber = !@claims.subscriber              ; Subscriber (insured person)
subscriber_employer = :                       ; Subscriber employer (Item 11b)
subscriber_insurance_plan = :                 ; Insurance plan name (Item 11c)

; ───────────────────────────────────────────────────────────────────────────────
; Patient Information (CMS-1500 Items 2, 3, 5, 6, 8)
; ───────────────────────────────────────────────────────────────────────────────
patient = !@claims.subscriber                 ; Patient (may differ from subscriber)

; Patient condition (Items 10a-c)
{.condition}
employment_related = ?                        ; Condition related to employment
auto_accident = ?                             ; Condition related to auto accident
auto_accident_state = :(2)                    ; State where auto accident occurred
other_accident = ?                            ; Condition related to other accident

{@claim}

; Dates (Item 14-16)
{.dates}
current_illness_date = date                   ; Date of current illness (Item 14)
similar_illness_date = date                   ; Date of similar illness (Item 15)
unable_to_work_from = date                    ; Unable to work from (Item 16)
unable_to_work_to = date                      ; Unable to work to (Item 16)

{@claim}

; ───────────────────────────────────────────────────────────────────────────────
; Referring Provider (CMS-1500 Item 17)
; ───────────────────────────────────────────────────────────────────────────────
referring_provider = @claims.provider         ; Referring/ordering provider
referring_provider_qualifier = (dn, dq, pxc)  ; DN=Referring, DQ=Supervising, PXC=Ordering

; ───────────────────────────────────────────────────────────────────────────────
; Hospitalization (CMS-1500 Item 18)
; ───────────────────────────────────────────────────────────────────────────────
{.hospitalization}
admission_date = date                         ; Hospital admission date
discharge_date = date                         ; Hospital discharge date

{@claim}

; ───────────────────────────────────────────────────────────────────────────────
; Prior Authorization (CMS-1500 Item 23)
; ───────────────────────────────────────────────────────────────────────────────
prior_authorization_number = :                ; Prior authorization number

; ───────────────────────────────────────────────────────────────────────────────
; Diagnoses (CMS-1500 Item 21)
; ───────────────────────────────────────────────────────────────────────────────
diagnoses[] = @claims.diagnosis               ; Up to 12 diagnosis codes
icd_indicator = : "0"                         ; ICD version (0=ICD-10)

; ───────────────────────────────────────────────────────────────────────────────
; Service Lines (CMS-1500 Item 24)
; ───────────────────────────────────────────────────────────────────────────────
service_lines[] = @claims.service_line        ; Service line items

; ───────────────────────────────────────────────────────────────────────────────
; Billing Provider (CMS-1500 Items 25, 32, 33)
; ───────────────────────────────────────────────────────────────────────────────
billing_provider = !@claims.provider          ; Billing provider/supplier
service_facility = @claims.provider           ; Service facility (if different)
accept_assignment = ?                         ; Accept assignment (Item 27)

; ───────────────────────────────────────────────────────────────────────────────
; Charges and Payment (CMS-1500 Items 28, 29)
; ───────────────────────────────────────────────────────────────────────────────
{.totals}
total_charges = !#$:(0..)                     ; Total charges (Item 28)
amount_paid = #$:(0..)                        ; Amount paid by other payer (Item 29)
balance_due = #$:(0..)                        ; Balance due

{@claim}

; ───────────────────────────────────────────────────────────────────────────────
; Signature and Date (CMS-1500 Items 12, 13, 31)
; ───────────────────────────────────────────────────────────────────────────────
{.signatures}
patient_signature_on_file = ?                 ; Patient signature on file (Item 12)
patient_signature_date = date                 ; Patient signature date
insured_signature_on_file = ?                 ; Insured signature on file (Item 13)
provider_signature_date = date                ; Provider signature date (Item 31)

{@claim}

; ───────────────────────────────────────────────────────────────────────────────
; Coordination of Benefits
; ───────────────────────────────────────────────────────────────────────────────
other_payers[] = @claims.cob_payer            ; Other payer information

; ───────────────────────────────────────────────────────────────────────────────
; Claim Status
; ───────────────────────────────────────────────────────────────────────────────
status = @claims.claim_status                 ; Current claim status
status_history[] = @claims.claim_status       ; Status history

; ═══════════════════════════════════════════════════════════════════════════════
; REMITTANCE ADVICE (835)
; ═══════════════════════════════════════════════════════════════════════════════
; Per CMS remittance advice requirements

{@remittance}
; Remittance identification
remittance_id = !:                            ; Unique remittance identifier
check_number = :                              ; Check/EFT number
remittance_date = !date                       ; Remittance date

; Payer
payer = !@claims.payer                        ; Payer issuing remittance

; Provider (payee)
payee = !@claims.provider                     ; Provider receiving payment

; Totals
{.totals}
total_claim_count = ##:(0..)                  ; Number of claims
total_charges = #$:(0..)                      ; Total billed charges
total_paid = #$:(0..)                         ; Total paid amount
total_patient_responsibility = #$:(0..)       ; Total patient responsibility
total_contractual = #$:(0..)                  ; Total contractual adjustments
total_other_adjustments = #$:(0..)            ; Total other adjustments

{@remittance}

; Claim payments
claim_payments[] = @claim_payment             ; Individual claim payments

{@claim_payment}
claim_id = !:                                 ; Original claim ID
patient = !@claims.subscriber                 ; Patient
claim_status = !(denied, paid, primary_forwarded)
claim_filing_indicator = :                    ; Claim filing indicator

; Amounts
{.amounts}
total_charges = #$:(0..)                      ; Total claim charges
paid_amount = #$:(0..)                        ; Amount paid
patient_responsibility = #$:(0..)             ; Patient responsibility
contractual_adjustment = #$:(0..)             ; Contractual adjustment

{@claim_payment}

; Adjustments
adjustments[] = @claims.adjustment            ; Claim-level adjustments

; Service line payments
service_line_payments[] = @service_line_payment  ; Line-level payments

{@service_line_payment}
line_number = !##:(1..)                       ; Service line number
procedure = @claims.procedure                 ; Procedure code
service_date = date                           ; Date of service

; Amounts
{.amounts}
charged = #$:(0..)                            ; Charged amount
allowed = #$:(0..)                            ; Allowed amount
paid = #$:(0..)                               ; Paid amount
deductible = #$:(0..)                         ; Applied deductible
coinsurance = #$:(0..)                        ; Patient coinsurance
copay = #$:(0..)                              ; Patient copay

{@service_line_payment}

; Adjustments
adjustments[] = @claims.adjustment            ; Line-level adjustments

; Remark codes
remark_codes[] = :                            ; Remark codes (NCPDP/CMS)


; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Healthcare Claims Common Types
; ═══════════════════════════════════════════════════════════════════════════════
; Reusable type definitions shared across healthcare claims schemas, including
; provider, payer, subscriber, and diagnosis types derived from HIPAA and CMS
; public documentation.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.claims.types"
version = "1.0.0"
title = "Healthcare Claims Common Types"
description = "Reusable type definitions for healthcare claims"

{$derivation}
source[0].authority = "HHS"
source[0].citation = "HIPAA Administrative Simplification - 45 CFR 162"
source[0].url = "https://www.ecfr.gov/current/title-45/subtitle-A/subchapter-C/part-162"

source[1].authority = "CMS"
source[1].citation = "Medicare Claims Processing Manual (Pub 100-04)"
source[1].url = "https://www.cms.gov/Regulations-and-Guidance/Guidance/Manuals/Internet-Only-Manuals-IOMs-Items/CMS018912"

source[2].authority = "CMS"
source[2].citation = "CMS-1500 Claim Form Instructions"
source[2].url = "https://www.cms.gov/medicare/cms-forms/cms-forms/downloads/cms1500.pdf"

source[3].authority = "CMS"
source[3].citation = "UB-04 Claim Form Instructions"
source[3].url = "https://www.cms.gov/medicare/cms-forms/cms-forms/cms-forms-items/cms012949"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial healthcare claims common types schema"
changelog[0].rationale = "Base types derived from HIPAA and CMS public documentation"

; ═══════════════════════════════════════════════════════════════════════════════
; PROVIDER
; ═══════════════════════════════════════════════════════════════════════════════
; Per CMS provider identification requirements and HIPAA NPI mandate

{@provider}
; National Provider Identifier - Required per 45 CFR 162.410
npi = !:/^\d{10}$/                            ; 10-digit NPI
npi_type = (individual, organization)         ; NPI entity type (Type 1 or 2)

; Legacy identifiers (still used in some contexts)
tax_id = *:                                   ; Tax ID (EIN or SSN)
tax_id_type = (ein, ssn)                      ; Tax ID type
legacy_id = :                                 ; Legacy provider ID (UPIN, etc.)

; Provider name
{.name}
last = :                                      ; Last name (individuals)
first = :                                     ; First name (individuals)
middle = :                                    ; Middle name
suffix = :                                    ; Suffix (MD, DO, etc.)
organization = :                              ; Organization name

{@provider}

; Taxonomy - Per NUCC Healthcare Provider Taxonomy
taxonomy_code = :/^[\dA-Z]{10}$/              ; 10-char taxonomy code
taxonomy_description = :                      ; Taxonomy description
primary_taxonomy = ?                          ; Primary taxonomy indicator

; Specialty - CMS specialty codes
specialty_code = :                            ; CMS specialty code
specialty_description = :                     ; Specialty description

; Contact
address = @address                            ; Physical address
phone = *@phone                               ; Phone number
fax = *@phone                                 ; Fax number

{@provider}

; ═══════════════════════════════════════════════════════════════════════════════
; SUBSCRIBER/PATIENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per CMS patient identification requirements

{@subscriber}
= @person                                     ; Inherits person fields (name, ssn, dob, contact)

; Identification
member_id = !:                                ; Subscriber/member ID
group_number = :                              ; Group/policy number

; Override required fields per CMS requirements
{.name}
first = !:                                    ; First name (required)
last = !:                                     ; Last name (required)

{@subscriber}

; Override required demographics
date_of_birth = !*date                        ; Date of birth (required, confidential)
gender = !(female, male, unknown)             ; Administrative gender (required)

; Relationship to insured - Per CMS relationship codes
relationship_to_insured = (cadaver_donor, child, employee, life_partner, organ_donor, other, self, spouse, unknown)

; ═══════════════════════════════════════════════════════════════════════════════
; PAYER
; ═══════════════════════════════════════════════════════════════════════════════
; Per HIPAA payer identification requirements

{@payer}
; Identification
payer_id = !:                                 ; Payer ID
name = !:                                     ; Payer name
payer_type = (commercial, medicaid, medicare_advantage, medicare_ffs, other_government, tricare, workers_comp)

; Contact
address = @address                            ; Physical address
phone = *@phone                               ; Phone number
claims_address = @address                     ; Claims submission address

{@payer}

; ═══════════════════════════════════════════════════════════════════════════════
; DIAGNOSIS CODE
; ═══════════════════════════════════════════════════════════════════════════════
; Per ICD-10-CM coding requirements

{@diagnosis}
code = !:/^[A-Z]\d{2}\.?\d{0,4}$/             ; ICD-10-CM code
description = :                               ; Code description
code_type = : "icd10"                         ; Code set (default ICD-10)
qualifier = (admitting, other, principal)     ; Diagnosis type
present_on_admission = (exempt, no, unknown, yes)  ; POA indicator

; ═══════════════════════════════════════════════════════════════════════════════
; PROCEDURE CODE
; ═══════════════════════════════════════════════════════════════════════════════
; Per CPT/HCPCS coding requirements (concepts, not proprietary codes)

{@procedure}
code = !:                                     ; Procedure code
code_type = !(cpt, hcpcs, icd10_pcs)          ; Code set
description = :                               ; Code description
modifiers[] = :(2)                            ; Modifier codes (up to 4)
date = date                                   ; Procedure date

; ═══════════════════════════════════════════════════════════════════════════════
; SERVICE LINE
; ═══════════════════════════════════════════════════════════════════════════════
; Per CMS-1500/UB-04 service line requirements

{@service_line}
line_number = !##:(1..)                       ; Line item number

; Service identification
procedure = !@procedure                       ; Procedure code
revenue_code = :/^\d{4}$/                     ; Revenue code (institutional)
ndc = :/^\d{11}$/                             ; NDC code (drugs)

; Dates
service_date_from = !date                     ; Service start date
service_date_to = date                        ; Service end date (if range)

; Place of service - Per CMS place of service codes
place_of_service = :(2)                       ; 2-digit POS code

; Quantity and units
units = !#:(0..)                              ; Service units
unit_type = (days, miles, minutes, services, units, visits)

; Charges
charge_amount = !#$:(0..)                     ; Billed charges
allowed_amount = #$:(0..)                     ; Allowed amount
paid_amount = #$:(0..)                        ; Payment amount

; Provider
rendering_provider = @provider                ; Provider who rendered service
referring_provider = @provider                ; Referring provider

; Diagnosis pointers (1-12 per CMS)
diagnosis_pointers[] = ##:(1..12)             ; Links to diagnoses

; Prior authorization
prior_auth_number = :                         ; Prior authorization number

; ═══════════════════════════════════════════════════════════════════════════════
; AMOUNT
; ═══════════════════════════════════════════════════════════════════════════════
; Healthcare monetary amount

{@amount}
value = !#$:(0..)                             ; Dollar amount
currency = :(3) "USD"                         ; Currency (default USD)

; ═══════════════════════════════════════════════════════════════════════════════
; CLAIM STATUS
; ═══════════════════════════════════════════════════════════════════════════════
; Per CMS claim status code categories

{@claim_status}
category = !(accepted, additional_info_requested, adjudicated, denied, finalized, forwarded, pending, received, rejected)
status_code = :                               ; Detailed status code
status_date = !date                           ; Status effective date
message = :                                   ; Status message/description

; ═══════════════════════════════════════════════════════════════════════════════
; ADJUSTMENT REASON
; ═══════════════════════════════════════════════════════════════════════════════
; Per CMS CARC/RARC adjustment reason code concepts

{@adjustment}
group = !(contractual_obligation, correction, other_adjustment, patient_responsibility, payer_initiated)
reason_code = :                               ; Adjustment reason code
amount = !#$:(0..)                            ; Adjustment amount
quantity = #:(0..)                            ; Affected quantity
remark_codes[] = :                            ; Remark codes

; Group code meanings (per CMS):
; contractual_obligation = CO - Contractual obligations
; correction = CR - Corrections and reversals
; other_adjustment = OA - Other adjustments
; patient_responsibility = PR - Patient responsibility
; payer_initiated = PI - Payer initiated reductions

; ═══════════════════════════════════════════════════════════════════════════════
; COORDINATION OF BENEFITS
; ═══════════════════════════════════════════════════════════════════════════════
; Per CMS COB requirements

{@cob_payer}
payer = !@payer                               ; Other payer
payer_sequence = !(primary, secondary, tertiary)
claim_filing_indicator = :                    ; Claim filing indicator code
paid_amount = #$:(0..)                        ; Amount paid by payer
adjusted_amount = #$:(0..)                    ; Amount adjusted
patient_responsibility = #$:(0..)             ; Patient responsibility
adjudication_date = date                      ; Date of adjudication
claim_number = :                              ; Other payer claim number


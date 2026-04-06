; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Healthcare Clinical - Explanation of Benefit Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Clinical explanation of benefit resource representing claim adjudication
; results including payment details, adjustments, and patient responsibility.
; Bridges to the claims processing domain. Derived from HL7 FHIR R4/R5
; (CC0 public domain).
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as fhir

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.clinical.explanationofbenefit"
version = "1.0.0"
title = "Healthcare Clinical Explanation of Benefit Schema"
description = "Clinical explanation of benefit (EOB/remittance) resource derived from FHIR R4/R5"

{$derivation}
source[0].authority = "HL7"
source[0].citation = "HL7 FHIR R4 - ExplanationOfBenefit Resource"
source[0].url = "https://hl7.org/fhir/R4/explanationofbenefit.html"

source[1].authority = "HL7"
source[1].citation = "HL7 FHIR R5 - ExplanationOfBenefit Resource"
source[1].url = "https://hl7.org/fhir/R5/explanationofbenefit.html"

source[2].authority = "X12"
source[2].citation = "ASC X12 835 Health Care Claim Payment/Advice"
source[2].url = "https://x12.org/products/transaction-sets"

source[3].authority = "CMS"
source[3].citation = "CMS Interoperability and Patient Access Final Rule"
source[3].url = "https://www.cms.gov/Regulations-and-Guidance/Guidance/Interoperability/index"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-20
changelog[0].change = "Initial clinical explanation of benefit schema"
changelog[0].rationale = "ExplanationOfBenefit resource derived from FHIR R4/R5 specification"

; ═══════════════════════════════════════════════════════════════════════════════
; EXPLANATION OF BENEFIT
; ═══════════════════════════════════════════════════════════════════════════════
; FHIR: ExplanationOfBenefit - https://hl7.org/fhir/R4/explanationofbenefit.html
; Explanation of benefit (claim adjudication result)

{@explanation_of_benefit}
; Resource metadata
id = !:                                       ; Logical id of resource
meta = @fhir.meta                             ; Resource metadata

; Identifiers - FHIR: ExplanationOfBenefit.identifier
identifiers[] = @fhir.identifier              ; Business identifiers

; Status - FHIR: ExplanationOfBenefit.status (required)
status = !(active, cancelled, draft, entered_in_error)

; Type - FHIR: ExplanationOfBenefit.type (required)
type = !@fhir.codeable_concept                ; Category (institutional, oral, pharmacy, professional, vision)

; Sub type - FHIR: ExplanationOfBenefit.subType
sub_type = @fhir.codeable_concept             ; Finer grain type

; Use - FHIR: ExplanationOfBenefit.use (required)
use = !(claim, preauthorization, predetermination)

; Patient - FHIR: ExplanationOfBenefit.patient (required)
patient = !@fhir.reference                    ; Patient receiving services

; Billable period - FHIR: ExplanationOfBenefit.billablePeriod
billable_period = @fhir.period                ; Period for charge submission

; Created - FHIR: ExplanationOfBenefit.created (required)
created = !timestamp                          ; Creation date

; Enterer - FHIR: ExplanationOfBenefit.enterer
enterer = @fhir.reference                     ; Who entered data

; Insurer - FHIR: ExplanationOfBenefit.insurer (required)
insurer = !@fhir.reference                    ; Insurer responsible for EOB

; Provider - FHIR: ExplanationOfBenefit.provider (required)
provider = !@fhir.reference                   ; Party responsible for claim

; Priority - FHIR: ExplanationOfBenefit.priority
priority = @fhir.codeable_concept             ; Processing priority

; Funds reserve requested - FHIR: ExplanationOfBenefit.fundsReserveRequested
funds_reserve_requested = @fhir.codeable_concept  ; Requested funds reserve

; Funds reserve - FHIR: ExplanationOfBenefit.fundsReserve
funds_reserve = @fhir.codeable_concept        ; Actual funds reserve

; Related claims - FHIR: ExplanationOfBenefit.related
related[] = @eob_related                      ; Related claims

; Prescription - FHIR: ExplanationOfBenefit.prescription
prescription = @fhir.reference                ; Prescription authorizing services

; Original prescription - FHIR: ExplanationOfBenefit.originalPrescription
original_prescription = @fhir.reference       ; Original prescription reference

; Payee - FHIR: ExplanationOfBenefit.payee
payee = @eob_payee                            ; Recipient of benefits

; Referral - FHIR: ExplanationOfBenefit.referral
referral = @fhir.reference                    ; Treatment referral

; Facility - FHIR: ExplanationOfBenefit.facility
facility = @fhir.reference                    ; Service facility

; Claim - FHIR: ExplanationOfBenefit.claim
claim = @fhir.reference                       ; Reference to original Claim

; Claim response - FHIR: ExplanationOfBenefit.claimResponse
claim_response = @fhir.reference              ; Reference to ClaimResponse

; Outcome - FHIR: ExplanationOfBenefit.outcome (required)
outcome = !(complete, error, partial, queued)

; Disposition - FHIR: ExplanationOfBenefit.disposition
disposition = :                               ; Disposition message

; Pre auth ref - FHIR: ExplanationOfBenefit.preAuthRef
pre_auth_ref[] = :                            ; Prior authorization reference

; Pre auth ref period - FHIR: ExplanationOfBenefit.preAuthRefPeriod
pre_auth_ref_period[] = @fhir.period          ; Prior authorization period

; Care team - FHIR: ExplanationOfBenefit.careTeam
care_team[] = @eob_care_team                  ; Care team members

; Supporting info - FHIR: ExplanationOfBenefit.supportingInfo
supporting_info[] = @eob_supporting_info      ; Supporting information

; Diagnoses - FHIR: ExplanationOfBenefit.diagnosis
diagnoses[] = @eob_diagnosis                  ; Diagnosis codes

; Procedures - FHIR: ExplanationOfBenefit.procedure
procedures[] = @eob_procedure                 ; Clinical procedures

; Precedence - FHIR: ExplanationOfBenefit.precedence
precedence = ##:(1..)                         ; Precedence (primary, secondary)

; Insurance - FHIR: ExplanationOfBenefit.insurance (required)
insurance[] = @eob_insurance                  ; Insurance information

; Accident - FHIR: ExplanationOfBenefit.accident
accident = @eob_accident                      ; Accident details

; Items - FHIR: ExplanationOfBenefit.item
items[] = @eob_item                           ; Service line items

; Add items - FHIR: ExplanationOfBenefit.addItem
add_items[] = @eob_add_item                   ; Insurer added items

; Adjudication - FHIR: ExplanationOfBenefit.adjudication
adjudication[] = @eob_adjudication            ; Header-level adjudication

; Totals - FHIR: ExplanationOfBenefit.total
totals[] = @eob_total                         ; Adjudication totals

; Payment - FHIR: ExplanationOfBenefit.payment
payment = @eob_payment                        ; Payment details

; Form code - FHIR: ExplanationOfBenefit.formCode
form_code = @fhir.codeable_concept            ; Form type (CMS-1500, UB-04)

; Form - FHIR: ExplanationOfBenefit.form
form = @fhir.attachment                       ; Printed form image

; Process notes - FHIR: ExplanationOfBenefit.processNote
process_notes[] = @eob_process_note           ; Processing notes

; Benefit period - FHIR: ExplanationOfBenefit.benefitPeriod
benefit_period = @fhir.period                 ; Benefit plan period

; Benefit balance - FHIR: ExplanationOfBenefit.benefitBalance
benefit_balance[] = @eob_benefit_balance      ; Balance by category

; ───────────────────────────────────────────────────────────────────────────────
; EOB Related - FHIR: ExplanationOfBenefit.related
; ───────────────────────────────────────────────────────────────────────────────

{@eob_related}
claim = @fhir.reference                       ; Related claim
relationship = @fhir.codeable_concept         ; Relationship to prior claim
reference = @fhir.identifier                  ; File/case reference

; ───────────────────────────────────────────────────────────────────────────────
; EOB Payee - FHIR: ExplanationOfBenefit.payee
; ───────────────────────────────────────────────────────────────────────────────

{@eob_payee}
type = @fhir.codeable_concept                 ; Type of party (provider, patient, other)
party = @fhir.reference                       ; Recipient of benefits

; ───────────────────────────────────────────────────────────────────────────────
; EOB Care Team - FHIR: ExplanationOfBenefit.careTeam
; ───────────────────────────────────────────────────────────────────────────────

{@eob_care_team}
sequence = !##:(1..)                          ; Order of care team
provider = !@fhir.reference                   ; Practitioner or Organization
responsible = ?                               ; Clinically responsible indicator
role = @fhir.codeable_concept                 ; Function within care team
qualification = @fhir.codeable_concept        ; Practitioner credential/specialty

; ───────────────────────────────────────────────────────────────────────────────
; EOB Supporting Info - FHIR: ExplanationOfBenefit.supportingInfo
; ───────────────────────────────────────────────────────────────────────────────

{@eob_supporting_info}
sequence = !##:(1..)                          ; Information instance identifier
category = !@fhir.codeable_concept            ; Classification of information
code = @fhir.codeable_concept                 ; Type of information

; Timing - polymorphic
timing_date = date                            ; When it occurred
timing_period = @fhir.period                  ; When it occurred

; Value - polymorphic
value_boolean = ?                             ; Data as boolean
value_string = :                              ; Data as string
value_quantity = @fhir.quantity               ; Data as quantity
value_attachment = @fhir.attachment           ; Data as attachment
value_reference = @fhir.reference             ; Data as reference

reason = @fhir.codeable_concept               ; Explanation for information

; ───────────────────────────────────────────────────────────────────────────────
; EOB Diagnosis - FHIR: ExplanationOfBenefit.diagnosis
; ───────────────────────────────────────────────────────────────────────────────

{@eob_diagnosis}
sequence = !##:(1..)                          ; Diagnosis instance identifier

; Diagnosis - polymorphic
diagnosis_codeable_concept = @fhir.codeable_concept  ; ICD-10 diagnosis code
diagnosis_reference = @fhir.reference         ; Reference to Condition

types[] = @fhir.codeable_concept              ; Type (admitting, principal, secondary)
on_admission = @fhir.codeable_concept         ; Present on admission indicator
package_code = @fhir.codeable_concept         ; DRG code

; ───────────────────────────────────────────────────────────────────────────────
; EOB Procedure - FHIR: ExplanationOfBenefit.procedure
; ───────────────────────────────────────────────────────────────────────────────

{@eob_procedure}
sequence = !##:(1..)                          ; Procedure instance identifier
types[] = @fhir.codeable_concept              ; Type of procedure
date = timestamp                              ; When procedure performed

; Procedure - polymorphic
procedure_codeable_concept = @fhir.codeable_concept  ; CPT/HCPCS/ICD-10-PCS code
procedure_reference = @fhir.reference         ; Reference to Procedure resource

udi[] = @fhir.reference                       ; Unique device identifiers

; ───────────────────────────────────────────────────────────────────────────────
; EOB Insurance - FHIR: ExplanationOfBenefit.insurance
; ───────────────────────────────────────────────────────────────────────────────

{@eob_insurance}
focal = !?                                    ; Coverage for this claim
coverage = !@fhir.reference                   ; Insurance information

; ───────────────────────────────────────────────────────────────────────────────
; EOB Accident - FHIR: ExplanationOfBenefit.accident
; ───────────────────────────────────────────────────────────────────────────────

{@eob_accident}
date = date                                   ; When accident occurred
type = @fhir.codeable_concept                 ; Type of accident

; Location - polymorphic
location_address = @fhir.address              ; Accident location address
location_reference = @fhir.reference          ; Reference to Location

; ───────────────────────────────────────────────────────────────────────────────
; EOB Item - FHIR: ExplanationOfBenefit.item
; ───────────────────────────────────────────────────────────────────────────────

{@eob_item}
sequence = !##:(1..)                          ; Item instance identifier
care_team_sequence[] = ##:(1..)               ; Care team link
diagnosis_sequence[] = ##:(1..)               ; Diagnosis link
procedure_sequence[] = ##:(1..)               ; Procedure link
information_sequence[] = ##:(1..)             ; Supporting info link

revenue = @fhir.codeable_concept              ; Revenue code
category = @fhir.codeable_concept             ; Benefit classification

product_or_service = !@fhir.codeable_concept  ; CPT/HCPCS/NDC code
modifiers[] = @fhir.codeable_concept          ; Modifier codes
program_code[] = @fhir.codeable_concept       ; Program specific codes

; Serviced - polymorphic
serviced_date = date                          ; Service date
serviced_period = @fhir.period                ; Service period

; Location - polymorphic
location_codeable_concept = @fhir.codeable_concept  ; Place of service code
location_address = @fhir.address              ; Service location address
location_reference = @fhir.reference          ; Reference to Location

quantity = @fhir.simple_quantity              ; Count of products/services
unit_price = @fhir.money                      ; Unit price
factor = #:(0..)                              ; Discount factor
net = @fhir.money                             ; Total item cost
udi[] = @fhir.reference                       ; Unique device identifiers
body_site = @fhir.codeable_concept            ; Anatomical location
sub_site[] = @fhir.codeable_concept           ; Anatomical sub-location
encounter[] = @fhir.reference                 ; Encounters related to item
note_number[] = ##:(1..)                      ; Note numbers for processing
adjudication[] = @eob_adjudication            ; Adjudication details
detail[] = @eob_item_detail                   ; Detail line items

; ───────────────────────────────────────────────────────────────────────────────
; EOB Adjudication - FHIR: ExplanationOfBenefit.item.adjudication
; ───────────────────────────────────────────────────────────────────────────────

{@eob_adjudication}
category = !@fhir.codeable_concept            ; Type (submitted, benefit, deductible, copay)
reason = @fhir.codeable_concept               ; Explanation of adjudication outcome
amount = @fhir.money                          ; Monetary amount
value = #                                     ; Non-monetary value

; ───────────────────────────────────────────────────────────────────────────────
; EOB Item Detail - FHIR: ExplanationOfBenefit.item.detail
; ───────────────────────────────────────────────────────────────────────────────

{@eob_item_detail}
sequence = !##:(1..)                          ; Detail instance identifier
revenue = @fhir.codeable_concept              ; Revenue code
category = @fhir.codeable_concept             ; Benefit classification
product_or_service = !@fhir.codeable_concept  ; Billing code
modifiers[] = @fhir.codeable_concept          ; Modifier codes
program_code[] = @fhir.codeable_concept       ; Program specific codes
quantity = @fhir.simple_quantity              ; Count
unit_price = @fhir.money                      ; Unit price
factor = #:(0..)                              ; Discount factor
net = @fhir.money                             ; Total cost
udi[] = @fhir.reference                       ; Unique device identifiers
note_number[] = ##:(1..)                      ; Note numbers
adjudication[] = @eob_adjudication            ; Adjudication details
sub_detail[] = @eob_item_sub_detail           ; Sub-detail line items

; ───────────────────────────────────────────────────────────────────────────────
; EOB Item Sub Detail - FHIR: ExplanationOfBenefit.item.detail.subDetail
; ───────────────────────────────────────────────────────────────────────────────

{@eob_item_sub_detail}
sequence = !##:(1..)                          ; Sub-detail instance identifier
revenue = @fhir.codeable_concept              ; Revenue code
category = @fhir.codeable_concept             ; Benefit classification
product_or_service = !@fhir.codeable_concept  ; Billing code
modifiers[] = @fhir.codeable_concept          ; Modifier codes
program_code[] = @fhir.codeable_concept       ; Program specific codes
quantity = @fhir.simple_quantity              ; Count
unit_price = @fhir.money                      ; Unit price
factor = #:(0..)                              ; Discount factor
net = @fhir.money                             ; Total cost
udi[] = @fhir.reference                       ; Unique device identifiers
note_number[] = ##:(1..)                      ; Note numbers
adjudication[] = @eob_adjudication            ; Adjudication details

; ───────────────────────────────────────────────────────────────────────────────
; EOB Add Item - FHIR: ExplanationOfBenefit.addItem
; ───────────────────────────────────────────────────────────────────────────────

{@eob_add_item}
item_sequence[] = ##:(1..)                    ; Item sequence number
detail_sequence[] = ##:(1..)                  ; Detail sequence number
sub_detail_sequence[] = ##:(1..)              ; Sub-detail sequence number
providers[] = @fhir.reference                 ; Authorized providers
product_or_service = !@fhir.codeable_concept  ; Billing code
modifiers[] = @fhir.codeable_concept          ; Modifier codes
program_code[] = @fhir.codeable_concept       ; Program specific codes

; Serviced - polymorphic
serviced_date = date                          ; Service date
serviced_period = @fhir.period                ; Service period

; Location - polymorphic
location_codeable_concept = @fhir.codeable_concept  ; Place of service code
location_address = @fhir.address              ; Service location address
location_reference = @fhir.reference          ; Reference to Location

quantity = @fhir.simple_quantity              ; Count
unit_price = @fhir.money                      ; Unit price
factor = #:(0..)                              ; Discount factor
net = @fhir.money                             ; Total cost
body_site = @fhir.codeable_concept            ; Anatomical location
sub_site[] = @fhir.codeable_concept           ; Anatomical sub-location
note_number[] = ##:(1..)                      ; Note numbers
adjudication[] = @eob_adjudication            ; Adjudication details

; ───────────────────────────────────────────────────────────────────────────────
; EOB Total - FHIR: ExplanationOfBenefit.total
; ───────────────────────────────────────────────────────────────────────────────

{@eob_total}
category = !@fhir.codeable_concept            ; Type of total
amount = !@fhir.money                         ; Financial total

; ───────────────────────────────────────────────────────────────────────────────
; EOB Payment - FHIR: ExplanationOfBenefit.payment
; ───────────────────────────────────────────────────────────────────────────────

{@eob_payment}
type = @fhir.codeable_concept                 ; Payment type (complete, partial)
adjustment = @fhir.money                      ; Payment adjustment
adjustment_reason = @fhir.codeable_concept    ; Reason for adjustment
date = date                                   ; Payment date
amount = @fhir.money                          ; Payment amount
identifier = @fhir.identifier                 ; Check or payment reference

; ───────────────────────────────────────────────────────────────────────────────
; EOB Process Note - FHIR: ExplanationOfBenefit.processNote
; ───────────────────────────────────────────────────────────────────────────────

{@eob_process_note}
number = ##:(1..)                             ; Note number for reference
type = (display, print, printoper)            ; Display type
text = :                                      ; Note text
language = @fhir.codeable_concept             ; Note language

; ───────────────────────────────────────────────────────────────────────────────
; EOB Benefit Balance - FHIR: ExplanationOfBenefit.benefitBalance
; ───────────────────────────────────────────────────────────────────────────────

{@eob_benefit_balance}
category = !@fhir.codeable_concept            ; Benefit classification
excluded = ?                                  ; Excluded from plan
name = :                                      ; Short name for benefit
description = :                               ; Description of benefits
network = @fhir.codeable_concept              ; In or out of network
unit = @fhir.codeable_concept                 ; Individual or family
term = @fhir.codeable_concept                 ; Annual or lifetime
financial[] = @eob_benefit_financial          ; Benefit summary

; ───────────────────────────────────────────────────────────────────────────────
; EOB Benefit Financial - FHIR: ExplanationOfBenefit.benefitBalance.financial
; ───────────────────────────────────────────────────────────────────────────────

{@eob_benefit_financial}
type = !@fhir.codeable_concept                ; Type of benefit (deductible, copay, coinsurance)

; Allowed - polymorphic
allowed_unsigned_int = ##:(0..)               ; Allowed amount/units
allowed_string = :                            ; Allowed description
allowed_money = @fhir.money                   ; Allowed amount

; Used - polymorphic
used_unsigned_int = ##:(0..)                  ; Used amount/units
used_money = @fhir.money                      ; Used amount


; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Healthcare Clinical - Claim Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Clinical claim resource representing requests for payment or preauthorization
; for healthcare services. Bridges clinical data to the claims processing domain.
; Derived from HL7 FHIR R4/R5 (CC0 public domain).
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as fhir

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.clinical.claim"
version = "1.0.0"
title = "Healthcare Clinical Claim Schema"
description = "Clinical claim resource derived from FHIR R4/R5"

{$derivation}
source[0].authority = "HL7"
source[0].citation = "HL7 FHIR R4 - Claim Resource"
source[0].url = "https://hl7.org/fhir/R4/claim.html"

source[1].authority = "HL7"
source[1].citation = "HL7 FHIR R5 - Claim Resource"
source[1].url = "https://hl7.org/fhir/R5/claim.html"

source[2].authority = "CMS"
source[2].citation = "CMS-1500 and UB-04 Claim Forms"
source[2].url = "https://www.cms.gov/medicare/forms-notices/cms-forms-list"

source[3].authority = "X12"
source[3].citation = "ASC X12 837 Health Care Claim Transaction"
source[3].url = "https://x12.org/products/transaction-sets"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-20
changelog[0].change = "Initial clinical claim schema"
changelog[0].rationale = "Claim resource derived from FHIR R4/R5 specification"

; ═══════════════════════════════════════════════════════════════════════════════
; CLAIM
; ═══════════════════════════════════════════════════════════════════════════════
; FHIR: Claim - https://hl7.org/fhir/R4/claim.html
; Request for payment or preauthorization

{@claim}
; Resource metadata
id = :                                       ; Logical id of resource
meta = @fhir.meta                             ; Resource metadata

; Identifiers - FHIR: Claim.identifier
identifiers[] = @fhir.identifier              ; Business identifiers

; Status - FHIR: Claim.status (required)
status = (active, cancelled, draft, entered_in_error)

; Type - FHIR: Claim.type (required)
type = @fhir.codeable_concept                ; Category (institutional, oral, pharmacy, professional, vision)

; Sub type - FHIR: Claim.subType
sub_type = @fhir.codeable_concept             ; Finer grain type

; Use - FHIR: Claim.use (required)
use = (claim, preauthorization, predetermination)

; Patient - FHIR: Claim.patient (required)
patient = @fhir.reference                    ; Patient receiving services

; Billable period - FHIR: Claim.billablePeriod
billable_period = @fhir.period                ; Period for charge submission

; Created - FHIR: Claim.created (required)
created = timestamp                          ; Creation date

; Enterer - FHIR: Claim.enterer
enterer = @fhir.reference                     ; Who entered claim

; Insurer - FHIR: Claim.insurer
insurer = @fhir.reference                     ; Target insurer

; Provider - FHIR: Claim.provider (required)
provider = @fhir.reference                   ; Party responsible for claim

; Priority - FHIR: Claim.priority (required)
priority = @fhir.codeable_concept            ; Processing priority

; Funds reserve - FHIR: Claim.fundsReserve
funds_reserve = @fhir.codeable_concept        ; Requested funds reserve

; Related claims - FHIR: Claim.related
related[] = @claim_related                    ; Related claims

; Prescription - FHIR: Claim.prescription
prescription = @fhir.reference                ; Prescription authorizing services

; Original prescription - FHIR: Claim.originalPrescription
original_prescription = @fhir.reference       ; Original prescription reference

; Payee - FHIR: Claim.payee
payee = @claim_payee                          ; Recipient of benefits

; Referral - FHIR: Claim.referral
referral = @fhir.reference                    ; Treatment referral

; Facility - FHIR: Claim.facility
facility = @fhir.reference                    ; Service facility

; Care team - FHIR: Claim.careTeam
care_team[] = @claim_care_team                ; Care team members

; Supporting info - FHIR: Claim.supportingInfo
supporting_info[] = @claim_supporting_info    ; Supporting information

; Diagnoses - FHIR: Claim.diagnosis
diagnoses[] = @claim_diagnosis                ; Diagnosis codes

; Procedures - FHIR: Claim.procedure
procedures[] = @claim_procedure               ; Clinical procedures

; Insurance - FHIR: Claim.insurance (required)
insurance[] = @claim_insurance                ; Patient insurance information

; Accident - FHIR: Claim.accident
accident = @claim_accident                    ; Accident details

; Items - FHIR: Claim.item
items[] = @claim_item                         ; Service or product line items

; Total - FHIR: Claim.total
total = @fhir.money                           ; Total claim cost

; ───────────────────────────────────────────────────────────────────────────────
; Claim Related - FHIR: Claim.related
; ───────────────────────────────────────────────────────────────────────────────

{@claim_related}
claim = @fhir.reference                       ; Related claim
relationship = @fhir.codeable_concept         ; Relationship to prior claim
reference = @fhir.identifier                  ; File/case reference

; ───────────────────────────────────────────────────────────────────────────────
; Claim Payee - FHIR: Claim.payee
; ───────────────────────────────────────────────────────────────────────────────

{@claim_payee}
type = @fhir.codeable_concept                ; Type of party (provider, patient, other)
party = @fhir.reference                       ; Recipient of benefits

; ───────────────────────────────────────────────────────────────────────────────
; Claim Care Team - FHIR: Claim.careTeam
; ───────────────────────────────────────────────────────────────────────────────

{@claim_care_team}
sequence = ##:(1..)                          ; Order of care team
provider = @fhir.reference                   ; Practitioner or Organization
responsible = ?                               ; Clinically responsible indicator
role = @fhir.codeable_concept                 ; Function within care team
qualification = @fhir.codeable_concept        ; Practitioner credential/specialty

; ───────────────────────────────────────────────────────────────────────────────
; Claim Supporting Info - FHIR: Claim.supportingInfo
; ───────────────────────────────────────────────────────────────────────────────

{@claim_supporting_info}
sequence = ##:(1..)                          ; Information instance identifier
category = @fhir.codeable_concept            ; Classification of information
code = @fhir.codeable_concept                 ; Type of information

; Timing - FHIR: Claim.supportingInfo.timing[x] (polymorphic)
timing_date = date                            ; When it occurred
timing_period = @fhir.period                  ; When it occurred

; Value - FHIR: Claim.supportingInfo.value[x] (polymorphic)
value_boolean = ?                             ; Data as boolean
value_string = :                              ; Data as string
value_quantity = @fhir.quantity               ; Data as quantity
value_attachment = @fhir.attachment           ; Data as attachment
value_reference = @fhir.reference             ; Data as reference

reason = @fhir.codeable_concept               ; Explanation for information

; ───────────────────────────────────────────────────────────────────────────────
; Claim Diagnosis - FHIR: Claim.diagnosis
; ───────────────────────────────────────────────────────────────────────────────

{@claim_diagnosis}
sequence = ##:(1..)                          ; Diagnosis instance identifier

; Diagnosis - FHIR: Claim.diagnosis.diagnosis[x] (polymorphic)
diagnosis_codeable_concept = @fhir.codeable_concept  ; ICD-10 diagnosis code
diagnosis_reference = @fhir.reference         ; Reference to Condition

types[] = @fhir.codeable_concept              ; Type (admitting, principal, secondary)
on_admission = @fhir.codeable_concept         ; Present on admission indicator
package_code = @fhir.codeable_concept         ; DRG code

; ───────────────────────────────────────────────────────────────────────────────
; Claim Procedure - FHIR: Claim.procedure
; ───────────────────────────────────────────────────────────────────────────────

{@claim_procedure}
sequence = ##:(1..)                          ; Procedure instance identifier
types[] = @fhir.codeable_concept              ; Type of procedure
date = timestamp                              ; When procedure performed

; Procedure - FHIR: Claim.procedure.procedure[x] (polymorphic)
procedure_codeable_concept = @fhir.codeable_concept  ; CPT/HCPCS/ICD-10-PCS code
procedure_reference = @fhir.reference         ; Reference to Procedure resource

udi[] = @fhir.reference                       ; Unique device identifiers

; ───────────────────────────────────────────────────────────────────────────────
; Claim Insurance - FHIR: Claim.insurance
; ───────────────────────────────────────────────────────────────────────────────

{@claim_insurance}
sequence = ##:(1..)                          ; Insurance instance identifier
focal = ?                                    ; Coverage for this claim
identifier = @fhir.identifier                 ; Claim ID at insurer
coverage = @fhir.reference                   ; Insurance information
business_arrangement = :                      ; Additional information
pre_auth_ref[] = :                            ; Prior authorization reference
claim_response = @fhir.reference              ; Adjudication results

; ───────────────────────────────────────────────────────────────────────────────
; Claim Accident - FHIR: Claim.accident
; ───────────────────────────────────────────────────────────────────────────────

{@claim_accident}
date = date                                  ; When accident occurred
type = @fhir.codeable_concept                 ; Type of accident

; Location - FHIR: Claim.accident.location[x] (polymorphic)
location_address = @fhir.address              ; Accident location address
location_reference = @fhir.reference          ; Reference to Location

; ───────────────────────────────────────────────────────────────────────────────
; Claim Item - FHIR: Claim.item
; ───────────────────────────────────────────────────────────────────────────────

{@claim_item}
sequence = ##:(1..)                          ; Item instance identifier
care_team_sequence[] = ##:(1..)               ; Care team link
diagnosis_sequence[] = ##:(1..)               ; Diagnosis link
procedure_sequence[] = ##:(1..)               ; Procedure link
information_sequence[] = ##:(1..)             ; Supporting info link

revenue = @fhir.codeable_concept              ; Revenue code
category = @fhir.codeable_concept             ; Benefit classification

product_or_service = @fhir.codeable_concept  ; CPT/HCPCS/NDC code
modifiers[] = @fhir.codeable_concept          ; Modifier codes
program_code[] = @fhir.codeable_concept       ; Program specific codes

; Serviced - FHIR: Claim.item.serviced[x] (polymorphic)
serviced_date = date                          ; Service date
serviced_period = @fhir.period                ; Service period

; Location - FHIR: Claim.item.location[x] (polymorphic)
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
detail[] = @claim_item_detail                 ; Detail line items

; ───────────────────────────────────────────────────────────────────────────────
; Claim Item Detail - FHIR: Claim.item.detail
; ───────────────────────────────────────────────────────────────────────────────

{@claim_item_detail}
sequence = ##:(1..)                          ; Detail instance identifier
revenue = @fhir.codeable_concept              ; Revenue code
category = @fhir.codeable_concept             ; Benefit classification
product_or_service = @fhir.codeable_concept  ; Billing code
modifiers[] = @fhir.codeable_concept          ; Modifier codes
program_code[] = @fhir.codeable_concept       ; Program specific codes
quantity = @fhir.simple_quantity              ; Count
unit_price = @fhir.money                      ; Unit price
factor = #:(0..)                              ; Discount factor
net = @fhir.money                             ; Total cost
udi[] = @fhir.reference                       ; Unique device identifiers
sub_detail[] = @claim_item_sub_detail         ; Sub-detail line items

; ───────────────────────────────────────────────────────────────────────────────
; Claim Item Sub Detail - FHIR: Claim.item.detail.subDetail
; ───────────────────────────────────────────────────────────────────────────────

{@claim_item_sub_detail}
sequence = ##:(1..)                          ; Sub-detail instance identifier
revenue = @fhir.codeable_concept              ; Revenue code
category = @fhir.codeable_concept             ; Benefit classification
product_or_service = @fhir.codeable_concept  ; Billing code
modifiers[] = @fhir.codeable_concept          ; Modifier codes
program_code[] = @fhir.codeable_concept       ; Program specific codes
quantity = @fhir.simple_quantity              ; Count
unit_price = @fhir.money                      ; Unit price
factor = #:(0..)                              ; Discount factor
net = @fhir.money                             ; Total cost
udi[] = @fhir.reference                       ; Unique device identifiers


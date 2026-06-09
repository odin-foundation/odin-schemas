; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Healthcare Clinical - Coverage Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Clinical coverage resource representing insurance policies and financial
; instruments for healthcare services. Bridges clinical data to the insurance
; and benefits domain. Derived from HL7 FHIR R4/R5 (CC0 public domain).
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as fhir

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.clinical.coverage"
version = "1.0.0"
title = "Healthcare Clinical Coverage Schema"
description = "Clinical coverage (insurance policy) resource derived from FHIR R4/R5"

{$derivation}
source[0].authority = "HL7"
source[0].citation = "HL7 FHIR R4 - Coverage Resource"
source[0].url = "https://hl7.org/fhir/R4/coverage.html"

source[1].authority = "HL7"
source[1].citation = "HL7 FHIR R5 - Coverage Resource"
source[1].url = "https://hl7.org/fhir/R5/coverage.html"

source[2].authority = "CMS"
source[2].citation = "CMS Interoperability and Patient Access Final Rule"
source[2].url = "https://www.cms.gov/Regulations-and-Guidance/Guidance/Interoperability/index"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-20
changelog[0].change = "Initial clinical coverage schema"
changelog[0].rationale = "Coverage resource derived from FHIR R4/R5 specification"

; ═══════════════════════════════════════════════════════════════════════════════
; COVERAGE
; ═══════════════════════════════════════════════════════════════════════════════
; FHIR: Coverage - https://hl7.org/fhir/R4/coverage.html
; Financial instrument (insurance) for healthcare services

{@coverage}
; Resource metadata
id = :                                       ; Logical id of resource
meta = @fhir.meta                             ; Resource metadata

; Identifiers - FHIR: Coverage.identifier
identifiers[] = @fhir.identifier              ; Business identifiers (member ID, group number)

; Status - FHIR: Coverage.status (required)
status = (active, cancelled, draft, entered_in_error)

; Type - FHIR: Coverage.type
type = @fhir.codeable_concept                 ; Coverage category (medical, dental, vision)

; Policy holder - FHIR: Coverage.policyHolder
policy_holder = @fhir.reference               ; Owner of policy

; Subscriber - FHIR: Coverage.subscriber
subscriber = @fhir.reference                  ; Subscriber to policy

; Subscriber ID - FHIR: Coverage.subscriberId
subscriber_id = :                             ; Subscriber ID at insurer

; Beneficiary - FHIR: Coverage.beneficiary (required)
beneficiary = @fhir.reference                ; Plan beneficiary (patient)

; Dependent - FHIR: Coverage.dependent
dependent = :                                 ; Dependent number

; Relationship - FHIR: Coverage.relationship
relationship = @fhir.codeable_concept         ; Beneficiary relationship to subscriber

; Period - FHIR: Coverage.period
period = @fhir.period                         ; Coverage effective period

; Payor - FHIR: Coverage.payor (required)
payors[] = @fhir.reference                    ; Insurer/payer organization(s)

; Class - FHIR: Coverage.class
classes[] = @coverage_class                   ; Classification of coverage (group, plan, subplan)

; Order - FHIR: Coverage.order
order = ##:(1..)                              ; Order of coverage (primary, secondary, tertiary)

; Network - FHIR: Coverage.network
network = :                                   ; Insurer network

; Cost to beneficiary - FHIR: Coverage.costToBeneficiary
cost_to_beneficiary[] = @coverage_cost        ; Patient cost sharing

; Subrogation - FHIR: Coverage.subrogation
subrogation = ?                               ; Reimbursement to insurer

; Contract - FHIR: Coverage.contract
contracts[] = @fhir.reference                 ; Contract details

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Class - FHIR: Coverage.class
; ───────────────────────────────────────────────────────────────────────────────
; Classification structure (group, plan, class, subclass, etc.)

{@coverage_class}
type = @fhir.codeable_concept                ; Type of class (group, plan, etc.)
value = :                                    ; Value of the classification
name = :                                      ; Human readable description

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Cost - FHIR: Coverage.costToBeneficiary
; ───────────────────────────────────────────────────────────────────────────────
; Patient cost sharing (copay, coinsurance, deductible)

{@coverage_cost}
type = @fhir.codeable_concept                 ; Type of cost (copay, deductible, coinsurance)

; Value - FHIR: Coverage.costToBeneficiary.value[x] (polymorphic)
value_quantity = @fhir.simple_quantity        ; Value as quantity
value_money = @fhir.money                     ; Value as money (dollar amount)

; Exceptions - FHIR: Coverage.costToBeneficiary.exception
exceptions[] = @coverage_cost_exception       ; Exceptions to cost

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Cost Exception - FHIR: Coverage.costToBeneficiary.exception
; ───────────────────────────────────────────────────────────────────────────────

{@coverage_cost_exception}
type = @fhir.codeable_concept                ; Exception category
period = @fhir.period                         ; Exception timeframe


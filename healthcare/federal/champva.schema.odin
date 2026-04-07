; ═══════════════════════════════════════════════════════════════════════════════
; ODIN CHAMPVA Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Civilian Health and Medical Program of the VA covering beneficiary eligibility,
; claims, and benefits for dependents and survivors of disabled veterans. Derived
; from 38 USC 1781 and 38 CFR 17.270-17.278.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.federal.champva"
version = "1.0.0"
title = "CHAMPVA Schema"
description = "Civilian Health and Medical Program of the VA"

{$derivation}
source[0].authority = "GPO"
source[0].citation = "38 USC 1781 - Medical care for survivors and dependents"
source[0].url = "https://www.law.cornell.edu/uscode/text/38/1781"

source[1].authority = "GPO"
source[1].citation = "38 CFR 17.270-17.278 - CHAMPVA"
source[1].url = "https://www.ecfr.gov/current/title-38/chapter-I/part-17"

source[2].authority = "VA"
source[2].citation = "CHAMPVA Policy Manual"
source[2].url = "https://www.va.gov/COMMUNITYCARE/programs/dependents/champva/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial CHAMPVA schema"
changelog[0].rationale = "Structure derived from 38 USC 1781 and 38 CFR 17.270-17.278"

; ═══════════════════════════════════════════════════════════════════════════════
; BENEFICIARY
; ═══════════════════════════════════════════════════════════════════════════════
; Per 38 CFR 17.271

{@beneficiary}
beneficiary_id = !:                         ; CHAMPVA beneficiary ID

; Demographics
{.demographics}
first_name = !:                             ; First name
middle_name = :                             ; Middle name
last_name = !:                              ; Last name
dob = !*date                                ; Date of birth
gender = (female, male)                     ; Gender
ssn = *:                                    ; SSN

{@beneficiary}

; Sponsor - Per 38 CFR 17.271
{.sponsor}
sponsor_name = :                            ; Sponsor name
sponsor_ssn = *:                            ; Sponsor SSN
relationship = !(child, spouse, surviving_spouse)
sponsor_status = !(deceased, permanently_disabled)
combined_rating = ##:(0..100)               ; Sponsor's combined rating (if P&T)
date_of_death = date                        ; Sponsor date of death (if deceased)

{@beneficiary}

; Eligibility - Per 38 CFR 17.271
{.eligibility}
eligible = ?                                ; CHAMPVA eligible
eligibility_basis = !(child_of_pt, child_of_deceased, spouse_of_pt, surviving_spouse)
; pt = Permanently and totally disabled
eligibility_date = date                     ; Eligibility date
ineligibility_reason = :                    ; Reason if not eligible

{@beneficiary}

; Medicare status - Per 38 CFR 17.271(b)
{.medicare}
medicare_entitled = ?                       ; Medicare entitled
medicare_part_a = ?                         ; Part A
medicare_part_b = ?                         ; Part B (required if entitled)
champva_as_secondary = ?                    ; CHAMPVA is secondary

{@beneficiary}

; Other health insurance - Per 38 CFR 17.276
{.ohi}
ohi = ?                                     ; Other health insurance
ohi_carrier = :                             ; OHI carrier name
ohi_policy_number = :                       ; Policy number
champva_is_secondary = ?                    ; CHAMPVA is secondary

{@beneficiary}

; ═══════════════════════════════════════════════════════════════════════════════
; ENROLLMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 38 CFR 17.271

{@enrollment}
enrollment_id = !:                          ; Enrollment ID
beneficiary_id = !:                         ; Beneficiary ID
application_date = !date                    ; Application date (VA Form 10-10d)

; Enrollment status
enrollment_status = @enrollment_period      ; Enrollment period with status

{@enrollment}

; ID card
{.id_card}
card_issued = ?                             ; ID card issued
card_number = :                             ; Card number
issue_date = date                           ; Issue date
expiration_date = date                      ; Expiration date

{@enrollment}

; Meds by mail - Per 38 CFR 17.274
{.meds_by_mail}
enrolled = ?                                ; Enrolled in Meds by Mail
enrollment_date = date                      ; Enrollment date

{@enrollment}

; ═══════════════════════════════════════════════════════════════════════════════
; COST SHARING
; ═══════════════════════════════════════════════════════════════════════════════
; Per 38 CFR 17.275

{@cost_sharing}
calendar_year = !##:(1973..)                ; Calendar year
beneficiary_id = !:                         ; Beneficiary ID

; Annual deductible - Per 38 CFR 17.275
{.deductible}
individual_deductible = #$:(0..)            ; Individual deductible
family_deductible = #$:(0..)                ; Family deductible
deductible_met = #$:(0..)                   ; Amount applied to deductible
deductible_remaining = #$:(0..)             ; Remaining deductible

{@cost_sharing}

; Cost share - Per 38 CFR 17.275
{.cost_share}
inpatient_cost_share = #:(0..25)            ; Inpatient cost share % (typically 25%)
outpatient_cost_share = #:(0..25)           ; Outpatient cost share % (typically 25%)
mental_health_cost_share = #:(0..25)        ; Mental health cost share

{@cost_sharing}

; Catastrophic cap - Per 38 CFR 17.275
{.catastrophic_cap}
annual_cap = #$:(0..)                       ; Annual catastrophic cap
amount_applied = #$:(0..)                   ; Amount applied to cap
cap_met = ?                                 ; Cap met

{@cost_sharing}

; ═══════════════════════════════════════════════════════════════════════════════
; CLAIM
; ═══════════════════════════════════════════════════════════════════════════════
; Per 38 CFR 17.273

{@claim}
claim_id = !:                               ; Claim ID
beneficiary_id = !:                         ; Beneficiary ID
claim_type = !(dental, dme, inpatient, outpatient, pharmacy)

; Service dates
{.dates}
service_date = !date                        ; Date of service
service_end_date = date                     ; End date (if span)
received_date = date                        ; Date claim received

{@claim}

; Provider
{.provider}
provider_name = :                           ; Provider name
provider_npi = :                            ; Provider NPI
facility_name = :                           ; Facility name

{@claim}

; Services
{.services}
procedure_codes[] = :                       ; Procedure codes (CPT/HCPCS)
diagnosis_codes[] = :                       ; Diagnosis codes (ICD-10)
place_of_service = :                        ; Place of service code

{@claim}

; Charges and payment
{.payment}
billed_amount = #$:(0..)                    ; Billed charges
allowable_amount = #$:(0..)                 ; CHAMPVA allowable
ohi_paid = #$:(0..)                         ; Other health insurance paid
medicare_paid = #$:(0..)                    ; Medicare paid (if applicable)
deductible_applied = #$:(0..)               ; Applied to deductible
cost_share = #$:(0..)                       ; Beneficiary cost share
champva_paid = #$:(0..)                     ; CHAMPVA paid

{@claim}

; Coordination of benefits - Per 38 CFR 17.276
{.cob}
primary_payer = (champva, medicare, ohi)    ; Primary payer
secondary_payer = :                         ; Secondary payer
ohi_eob_attached = ?                        ; OHI EOB attached

{@claim}

; Status
{.status}
status = !(denied, paid, pending)
processed_date = date                       ; Date processed
payment_date = date                         ; Payment date
denial_reason = :                           ; Denial reason

{@claim}

; ═══════════════════════════════════════════════════════════════════════════════
; PREAUTHORIZATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 38 CFR 17.273

{@preauthorization}
auth_id = !:                                ; Authorization ID
beneficiary_id = !:                         ; Beneficiary ID
request_date = !date                        ; Request date

; Services requiring authorization - Per 38 CFR 17.272
{.services}
service_type = !(dental, dme, hospice, inpatient, mental_health_inpatient, organ_transplant, snf)
procedure_codes[] = :                       ; Procedure codes
description = :                             ; Service description

{@preauthorization}

; Authorization
{.authorization}
authorized = ?                              ; Authorized
authorization_number = :                    ; Authorization number
authorized_from = date                      ; Authorized start date
authorized_to = date                        ; Authorized end date
authorized_amount = #$:(0..)                ; Authorized amount
authorized_days = ##:(0..)                  ; Authorized days (inpatient)

{@preauthorization}

; Status
{.status}
status = !(approved, denied, pending)
decision_date = date                        ; Decision date
denial_reason = :                           ; Denial reason

{@preauthorization}

; ═══════════════════════════════════════════════════════════════════════════════
; MEDS BY MAIL
; ═══════════════════════════════════════════════════════════════════════════════
; Per 38 CFR 17.274

{@meds_by_mail}
rx_id = !:                                  ; Prescription ID
beneficiary_id = !:                         ; Beneficiary ID

; Prescription
{.prescription}
drug_name = :                               ; Drug name
ndc = :                                     ; NDC code
quantity = ##:(0..)                         ; Quantity
days_supply = ##:(0..90)                    ; Days supply (up to 90)
refills_remaining = ##:(0..)                ; Refills remaining

{@meds_by_mail}

; Prescriber
{.prescriber}
prescriber_name = :                         ; Prescriber name
prescriber_npi = :                          ; Prescriber NPI
prescriber_dea = :                          ; DEA number (if controlled)

{@meds_by_mail}

; Fulfillment
{.fulfillment}
order_date = date                           ; Order date
ship_date = date                            ; Ship date
delivery_date = date                        ; Delivery date
status = (cancelled, delivered, pending, shipped)

{@meds_by_mail}

; Cost
{.cost}
total_cost = #$:(0..)                       ; Total drug cost
beneficiary_cost = #$:(0..)                 ; Beneficiary pays (after deductible)
champva_pays = #$:(0..)                     ; CHAMPVA pays

{@meds_by_mail}

; ═══════════════════════════════════════════════════════════════════════════════
; CITI (CHAMPVA IN THE COMMUNITY)
; ═══════════════════════════════════════════════════════════════════════════════
; Per VA community care partnership

{@citi}
enrollment_id = !:                          ; CITI enrollment ID
beneficiary_id = !:                         ; Beneficiary ID
effective_date = !date                      ; Effective date

; Provider
{.provider}
citi_provider = :                           ; CITI provider name
provider_npi = :                            ; Provider NPI
provider_type = (dental, medical)           ; Provider type
primary_care = ?                            ; Primary care provider

{@citi}

; Cost sharing
{.cost}
copay_required = ?                          ; Copay required
copay_amount = #$:(0..)                     ; Copay amount

{@citi}


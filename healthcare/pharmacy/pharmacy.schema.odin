; ===================================================================================
; ODIN Pharmacy Benefits Schema
; ===================================================================================
; Pharmacy benefit management covering formulary management, prior authorization,
; drug pricing, PBM structures, manufacturer rebates, and specialty pharmacy.
; Supports commercial, Medicare Part D, and Medicaid plans with both pass-through
; and spread pricing models.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.pharmacy"
version = "1.0.0"
title = "Pharmacy Benefits Schema"
description = "Pharmacy benefit management including formulary, prior auth, pricing, PBM, rebates, and specialty"

{$derivation}
source[0].authority = "CMS"
source[0].citation = "Medicare Prescription Drug Benefit Manual (CMS Pub 100-18)"
source[0].url = "https://www.cms.gov/Regulations-and-Guidance/Guidance/Manuals/Internet-Only-Manuals-IOMs-Items/CMS019193"

source[1].authority = "GPO"
source[1].citation = "42 CFR Part 423 - Voluntary Medicare Prescription Drug Benefit"
source[1].url = "https://www.ecfr.gov/current/title-42/chapter-IV/subchapter-B/part-423"

source[2].authority = "CMS"
source[2].citation = "Medicaid Drug Rebate Program (MDRP)"
source[2].url = "https://www.medicaid.gov/medicaid/prescription-drugs/medicaid-drug-rebate-program/index.html"

source[3].authority = "HRSA"
source[3].citation = "340B Drug Pricing Program"
source[3].url = "https://www.hrsa.gov/opa"

source[4].authority = "FDA"
source[4].citation = "Orange Book: Approved Drug Products with Therapeutic Equivalence Evaluations"
source[4].url = "https://www.fda.gov/drugs/drug-approvals-and-databases/approved-drug-products-therapeutic-equivalence-evaluations-orange-book"

source[5].authority = "USP"
source[5].citation = "USP Drug Classification System"
source[5].url = "https://www.usp.org/health-quality-safety/usp-drug-classification-system"

source[6].authority = "CMS"
source[6].citation = "National Average Drug Acquisition Cost (NADAC)"
source[6].url = "https://data.medicaid.gov/nadac"

source[7].authority = "NCPDP"
source[7].citation = "NCPDP Telecommunication Standard"
source[7].url = "https://www.ncpdp.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on CMS Part D, MDRP, 340B, and industry PBM standards"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial pharmacy benefits schema"
changelog[0].rationale = "Comprehensive pharmacy benefit coverage for all payer types"

; ===================================================================================
; FORMULARY - Drug Lists and Tier Management
; ===================================================================================
; Per 42 CFR 423.120 and CMS formulary requirements

{@rx_formulary}
; Required fields first
formulary_id = !:                            ; Unique formulary identifier
formulary_name = !:                          ; Formulary name
effective_date = !date                       ; Effective date

; Optional fields
end_date = date                              ; End date if terminated
formulary_type = (closed, open, preferred)   ; Formulary structure
formulary_version = :                        ; Version number
payer_type = (commercial, exchange, medicaid, medicare_partd, self_funded)
plan_ids[] = :                               ; Plans using this formulary
sponsor_name = :                             ; Plan sponsor name

; ---------------------------------------------------------------------------
; Drug Counts by Tier
; ---------------------------------------------------------------------------
{.counts}
generic_count = ##:(0..)                     ; Generic drugs
brand_count = ##:(0..)                       ; Brand drugs
specialty_count = ##:(0..)                   ; Specialty drugs
tier_1_count = ##:(0..)                      ; Tier 1 drugs
tier_2_count = ##:(0..)                      ; Tier 2 drugs
tier_3_count = ##:(0..)                      ; Tier 3 drugs
tier_4_count = ##:(0..)                      ; Tier 4 drugs
tier_5_count = ##:(0..)                      ; Tier 5 drugs
tier_6_count = ##:(0..)                      ; Tier 6 drugs (specialty)
total_drugs = ##:(0..)                       ; Total drug count

{@rx_formulary}

; ---------------------------------------------------------------------------
; Tier Structure - Per 42 CFR 423.104
; ---------------------------------------------------------------------------
{.tiers}
tier_count = ##:(1..6)                       ; Number of tiers
tier_definitions[] = @rx_tier                ; Tier definitions

{@rx_formulary}

; ---------------------------------------------------------------------------
; Utilization Management
; ---------------------------------------------------------------------------
{.utilization_management}
prior_auth_required = ?                      ; PA program exists
quantity_limits = ?                          ; QL program exists
step_therapy = ?                             ; ST program exists
age_edits = ?                                ; Age-based edits
gender_edits = ?                             ; Gender-based edits
diagnosis_edits = ?                          ; Diagnosis-based edits
duration_limits = ?                          ; Duration limits

{@rx_formulary}

; ===================================================================================
; FORMULARY TIER
; ===================================================================================

{@rx_tier}
; Required fields first
tier_number = !##:(1..6)                     ; Tier number
tier_name = !:                               ; Tier name (e.g., "Preferred Generic")

; Cost sharing - retail 30-day
{.retail_30}
copay = #$:(0..)                             ; Copay amount
coinsurance = #:(0..100)                     ; Coinsurance percentage
cost_type = (copay, coinsurance)             ; Primary cost type
maximum = #$:(0..)                           ; Maximum member cost

{@rx_tier}

; Cost sharing - retail 90-day
{.retail_90}
copay = #$:(0..)                             ; Copay amount
coinsurance = #:(0..100)                     ; Coinsurance percentage
cost_type = (copay, coinsurance)             ; Primary cost type
maximum = #$:(0..)                           ; Maximum member cost

{@rx_tier}

; Cost sharing - mail order
{.mail_order}
copay = #$:(0..)                             ; Copay amount
coinsurance = #:(0..100)                     ; Coinsurance percentage
cost_type = (copay, coinsurance)             ; Primary cost type
maximum = #$:(0..)                           ; Maximum member cost

{@rx_tier}

; Cost sharing - specialty
{.specialty}
copay = #$:(0..)                             ; Copay amount
coinsurance = #:(0..100)                     ; Coinsurance percentage
cost_type = (copay, coinsurance)             ; Primary cost type
maximum = #$:(0..)                           ; Maximum member cost

{@rx_tier}

; Deductible application
deductible_applies = ?                       ; Tier subject to deductible
brand_penalty = ?                            ; Brand penalty when generic available

; ===================================================================================
; FORMULARY DRUG
; ===================================================================================
; Per 42 CFR 423.120 and FDA Orange Book

{@rx_formulary_drug}
; Required fields first
formulary_id = !:                            ; Formulary identifier
ndc = !:/^\d{11}$/                           ; National Drug Code (11-digit)
tier = !##:(1..6)                            ; Assigned tier

; Drug identification
{.drug}
brand_name = :                               ; Brand name
generic_name = :                             ; Generic name
strength = :                                 ; Drug strength
dosage_form = (capsule, cream, gel, inhalant, injectable, ointment, patch, powder, solution, suppository, suspension, tablet)
route = (inhalation, injection, nasal, ophthalmic, oral, otic, rectal, topical, transdermal, vaginal)
rxcui = :                                    ; RxNorm Concept Unique Identifier

{@rx_formulary_drug}

; Classification
{.classification}
ahfs = :                                     ; AHFS Pharmacologic-Therapeutic Classification
gpi = :                                      ; Generic Product Identifier
therapeutic_class = :                        ; Therapeutic class
usp_category = :                             ; USP drug category

{@rx_formulary_drug}

; Restrictions - Per 42 CFR 423.120(b)
{.restrictions}
prior_auth = ?                               ; Prior authorization required (PA)
step_therapy = ?                             ; Step therapy required (ST)
step_therapy_drugs[] = :                     ; Required step drugs
quantity_limit = ?                           ; Quantity limits apply (QL)
quantity_limit_amount = ##:(0..)             ; Quantity per fill
quantity_limit_days = ##:(1..90)             ; Days supply for limit
age_limit_min = ##:(0..120)                  ; Minimum age
age_limit_max = ##:(0..120)                  ; Maximum age
gender_limit = (female, male)                ; Gender restriction
specialty_drug = ?                           ; Specialty tier indicator
limited_distribution = ?                     ; Limited distribution
rems = ?                                     ; REMS program required

{@rx_formulary_drug}

; Pharmacy restrictions
{.pharmacy}
mail_order_only = ?                          ; Mail-order only
specialty_pharmacy_only = ?                  ; Specialty pharmacy only
pharmacy_network[] = :                       ; Allowed pharmacy networks

{@rx_formulary_drug}

; Generic/brand status
{.brand_generic}
multisource = (brand, generic, originator)   ; Brand/generic indicator
generic_available = ?                        ; Generic available
ab_rated = ?                                 ; AB-rated generic available
brand_preferred = ?                          ; Brand preferred over generic
daw_penalty = ?                              ; DAW penalty applies
ther_equiv_code = :                          ; Therapeutic equivalence code

{@rx_formulary_drug}

; ===================================================================================
; PRIOR AUTHORIZATION - Requests and Decisions
; ===================================================================================
; Per 42 CFR 423.566-590 (Medicare Part D) and state laws

{@rx_prior_auth}
; Required fields first
pa_id = !:                                   ; Prior authorization ID
request_date = !date                         ; Date PA requested
drug_name = !:                               ; Drug requested
member_id = !*:                              ; Member identifier

; Drug details
{.drug}
ndc = :                                      ; NDC if known
strength = :                                 ; Strength
dosage_form = :                              ; Dosage form
quantity = ##:(1..)                          ; Quantity requested
days_supply = ##:(1..365)                    ; Days supply
refills = ##:(0..12)                         ; Refills requested
diagnosis_code = :                           ; ICD-10 diagnosis
diagnosis_description = :                    ; Diagnosis description

{@rx_prior_auth}

; Request type - Per 42 CFR 423.568
{.request}
request_type = !(coverage, exception, tiering, quantity, step_bypass, formulary, non_formulary)
urgency = (expedited, standard, urgent)      ; Request urgency
expedited_reason = ::if urgency = expedited  ; Reason for expedited
prescriber_support = ?                       ; Prescriber statement received
clinical_documentation = ?                   ; Clinical docs received
medical_necessity = :                        ; Medical necessity statement

{@rx_prior_auth}

; Prescriber information
{.prescriber}
npi = :/^\d{10}$/                            ; Prescriber NPI
name = :                                     ; Prescriber name
specialty = :                                ; Prescriber specialty
phone = *:                                   ; Contact phone
fax = *:                                     ; Contact fax

{@rx_prior_auth}

; Pharmacy information
{.pharmacy}
ncpdp = :/^\d{7}$/                           ; Pharmacy NCPDP
npi = :/^\d{10}$/                            ; Pharmacy NPI
name = :                                     ; Pharmacy name
phone = *:                                   ; Pharmacy phone

{@rx_prior_auth}

; Clinical criteria
{.criteria}
step_drugs_tried[] = :                       ; Prior drugs tried
step_drugs_failed_reason = :                 ; Reason for failure
contraindications[] = :                      ; Contraindicated drugs
allergies[] = :                              ; Drug allergies
labs[] = :                                   ; Lab results
diagnosis_history = :                        ; Relevant diagnosis history

{@rx_prior_auth}

; Determination - Per 42 CFR 423.568
{.determination}
decision_date = date                         ; Date of determination
decision = (approved, denied, modified, pending, withdrawn)
effective_date = date:if decision = approved ; Approval start date
end_date = date:if decision = approved       ; Approval end date
approved_quantity = ##:(0..):if decision = (approved, modified)
approved_days = ##:(0..):if decision = (approved, modified)
approved_refills = ##:(0..):if decision = (approved, modified)
denial_reason = ::if decision = denied       ; Denial reason code
denial_detail = ::if decision = denied       ; Denial explanation
reviewer = :                                 ; Reviewer name/ID
decision_timeframe_met = ?                   ; Met regulatory timeframe

{@rx_prior_auth}

; Appeal - Per 42 CFR 423.580-600
{.appeal}
appealed = ?                                 ; Appealed
appeal_date = date:if appealed = true        ; Appeal date
appeal_level = (alj, council, district_court, ire, redetermination):if appealed = true
appeal_decision = (affirmed, dismissed, reversed):if appealed = true
appeal_decision_date = date:if appealed = true

{@rx_prior_auth}

; ===================================================================================
; PRICING - AWP, MAC, NADAC, Dispensing Fees
; ===================================================================================
; Per CMS NADAC, state MAC programs, industry AWP standards

{@rx_pricing}
; Required fields first
ndc = !:/^\d{11}$/                           ; National Drug Code
effective_date = !date                       ; Pricing effective date

; Drug identification
brand_name = :                               ; Brand name
generic_name = :                             ; Generic name
strength = :                                 ; Drug strength
package_size = #:(0..)                       ; Package size
unit_of_measure = :                          ; Unit (EA, ML, GM)

; ---------------------------------------------------------------------------
; Acquisition Costs
; ---------------------------------------------------------------------------
{.acquisition}
awp = #$:(0..)                               ; Average Wholesale Price
awp_unit = #$:(0..)                          ; AWP per unit
wac = #$:(0..)                               ; Wholesale Acquisition Cost
wac_unit = #$:(0..)                          ; WAC per unit
nadac = #$:(0..)                             ; National Average Drug Acquisition Cost
nadac_unit = #$:(0..)                        ; NADAC per unit
nadac_effective = date                       ; NADAC effective date
asp = #$:(0..)                               ; Average Sales Price (Medicare Part B)
amp = #$:(0..)                               ; Average Manufacturer Price
bp = #$:(0..)                                ; Best Price (Medicaid rebate)

{@rx_pricing}

; ---------------------------------------------------------------------------
; MAC (Maximum Allowable Cost) - Per state MAC programs
; ---------------------------------------------------------------------------
{.mac}
mac_price = #$:(0..)                         ; MAC price
mac_unit = #$:(0..)                          ; MAC per unit
mac_list = :                                 ; MAC list identifier
mac_effective = date                         ; MAC effective date
state = :(2)                                 ; State if state-specific

{@rx_pricing}

; ---------------------------------------------------------------------------
; Reimbursement Calculation
; ---------------------------------------------------------------------------
{.reimbursement}
basis = (aac, awp, mac, nadac, usual_customary, wac)
awp_discount = #:(0..100)                    ; AWP discount percentage
dispensing_fee = #$:(0..)                    ; Dispensing fee
ingredient_cost = #$:(0..)                   ; Calculated ingredient cost
total_reimbursement = #$:(0..)               ; Total calculated reimbursement
copay = #$:(0..)                             ; Member copay
plan_paid = #$:(0..)                         ; Plan payment

{@rx_pricing}

; ---------------------------------------------------------------------------
; 340B Pricing - Per HRSA 340B program
; ---------------------------------------------------------------------------
{.pricing_340b}
ceiling_price = #$:(0..)                     ; 340B ceiling price
ceiling_unit = #$:(0..)                      ; 340B ceiling per unit
penny_pricing = ?                            ; Penny pricing eligible
subceiling_available = ?                     ; Sub-ceiling pricing

{@rx_pricing}

; Source and updates
{.source}
pricing_source = (cmsnadac, fdb, medi_span, micromedex, other)
last_update = date                           ; Last price update
update_frequency = (daily, monthly, quarterly, weekly)

{@rx_pricing}

; ===================================================================================
; PBM - Pharmacy Benefit Manager Structure
; ===================================================================================
; Per state PBM transparency laws and industry structure

{@rx_pbm}
; Required fields first
pbm_id = !:                                  ; PBM identifier
pbm_name = !:                                ; PBM name

; PBM details
{.organization}
parent_company = :                           ; Parent organization
address = @address                           ; Business address
contact_phone = *@phone                      ; Contact phone
contact_email = *@email                      ; Contact email
ncpdp_id = :                                 ; NCPDP organization ID
nabp_id = :                                  ; NABP number
license_states[] = :(2)                      ; Licensed states

{@rx_pbm}

; Contract details
{.contract}
contract_id = :                              ; Contract identifier
contract_type = (administrative_services, full_risk, pass_through, spread, transparent)
effective_date = date                        ; Contract effective
termination_date = date                      ; Contract termination
plan_sponsor = :                             ; Plan sponsor name
members_covered = ##:(0..)                   ; Members covered

{@rx_pbm}

; ---------------------------------------------------------------------------
; Pricing Model - Per state PBM transparency laws
; ---------------------------------------------------------------------------
{.pricing_model}
model_type = !(pass_through, spread, transparent)
admin_fee_pmpm = #$:(0..)                    ; Per-member-per-month admin
claims_processing_fee = #$:(0..)             ; Per-claim processing fee
rebate_guarantee = #$:(0..)                  ; Guaranteed rebate per script
rebate_share_percent = #:(0..100)            ; Rebate share to plan
generic_effective_rate = #:(0..100)          ; GER discount
brand_effective_rate = #:(0..100)            ; BER discount
specialty_discount = #:(0..100)              ; Specialty discount
spread_retained = ?                          ; PBM retains spread

{@rx_pbm}

; ---------------------------------------------------------------------------
; Network Access
; ---------------------------------------------------------------------------
{.network}
pharmacy_count = ##:(0..)                    ; Total pharmacies
retail_count = ##:(0..)                      ; Retail pharmacies
mail_order = ?                               ; Mail order available
specialty_pharmacy = ?                       ; Specialty pharmacy
ltc_network = ?                              ; Long-term care network
preferred_network = ?                        ; Preferred network tier
network_adequacy_met = ?                     ; Meets CMS adequacy

{@rx_pbm}

; ---------------------------------------------------------------------------
; Clinical Programs
; ---------------------------------------------------------------------------
{.clinical}
formulary_management = ?                     ; Formulary management
prior_auth = ?                               ; Prior authorization
step_therapy = ?                             ; Step therapy
quantity_limits = ?                          ; Quantity limits
mtm = ?                                      ; Medication therapy management
adherence_programs = ?                       ; Adherence programs
generic_programs = ?                         ; Generic incentive
therapeutic_substitution = ?                 ; Therapeutic substitution

{@rx_pbm}

; ---------------------------------------------------------------------------
; Reporting and Transparency
; ---------------------------------------------------------------------------
{.reporting}
claims_reporting = ?                         ; Claims data reporting
rebate_reporting = ?                         ; Rebate reporting
pricing_transparency = ?                     ; Pricing transparency
gag_clause_free = ?                          ; No pharmacist gag clauses
fiduciary_standard = ?                       ; Fiduciary standard

{@rx_pbm}

; ===================================================================================
; REBATE - Manufacturer Rebates and 340B
; ===================================================================================
; Per CMS MDRP, state supplemental rebate programs, 340B

{@rx_rebate}
; Required fields first
rebate_id = !:                               ; Rebate record ID
ndc = !:/^\d{11}$/                           ; National Drug Code
labeler_code = !:/^\d{5}$/                   ; Manufacturer labeler code
period_start = !date                         ; Rebate period start
period_end = !date                           ; Rebate period end

; Drug identification
brand_name = :                               ; Brand name
generic_name = :                             ; Generic name

; ---------------------------------------------------------------------------
; Medicaid Rebate - Per 42 CFR 447.500-520
; ---------------------------------------------------------------------------
{.medicaid}
rebate_type = !(basic, cpi_penalty, innovator, noninnovator)
ura = #$:(0..)                               ; Unit Rebate Amount
amp = #$:(0..)                               ; Average Manufacturer Price
best_price = #$:(0..)                        ; Best Price
base_date_amp = #$:(0..)                     ; Base date AMP
cpi_adjustment = #$:(0..)                    ; CPI penalty amount
total_rebate = #$:(0..)                      ; Total rebate amount
units_reimbursed = ##:(0..)                  ; Units reimbursed
states_participating[] = :(2)                ; Participating states

{@rx_rebate}

; ---------------------------------------------------------------------------
; Supplemental Rebate - Per state programs
; ---------------------------------------------------------------------------
{.supplemental}
state = :(2)                                 ; State
supplemental_amount = #$:(0..)               ; Supplemental rebate amount
pdl_placement = (non_preferred, preferred)   ; PDL placement
effective_date = date                        ; Supplemental effective

{@rx_rebate}

; ---------------------------------------------------------------------------
; Commercial Rebate
; ---------------------------------------------------------------------------
{.commercial}
rebate_per_script = #$:(0..)                 ; Per-script rebate
rebate_percent = #:(0..100)                  ; Percentage rebate
market_share_tier = ##:(1..5)                ; Market share tier
volume_bonus = #$:(0..)                      ; Volume bonus
admin_fee = #$:(0..)                         ; Admin fee
net_rebate = #$:(0..)                        ; Net rebate amount

{@rx_rebate}

; ---------------------------------------------------------------------------
; 340B Program - Per HRSA 340B
; ---------------------------------------------------------------------------
{.program_340b}
ceiling_price = #$:(0..)                     ; 340B ceiling price
ceiling_calculation_date = date              ; Ceiling calc date
covered_entity_type = (cah, che, dsh, fqhc, hemophilia, hiv_aids, other, ryan_white, stds)
contract_pharmacy = ?                        ; Contract pharmacy program
duplicate_discount = ?                       ; Duplicate discount check
savings = #$:(0..)                           ; 340B savings realized

{@rx_rebate}

; Rebate status
{.status}
rebate_status = (disputed, invoiced, paid, pending, reconciled)
invoice_date = date                          ; Invoice date
payment_date = date                          ; Payment date
payment_amount = #$:(0..)                    ; Payment received
dispute_reason = :                           ; Dispute reason if any

{@rx_rebate}

; ===================================================================================
; SPECIALTY PHARMACY - High-Cost Drug Management
; ===================================================================================
; Per CMS specialty tier guidance and industry standards

{@rx_specialty}
; Required fields first
specialty_id = !:                            ; Specialty record ID
ndc = !:/^\d{11}$/                           ; National Drug Code
drug_name = !:                               ; Drug name

; Drug characteristics
{.drug}
brand_name = :                               ; Brand name
generic_name = :                             ; Generic name
manufacturer = :                             ; Manufacturer
therapeutic_area = (autoimmune, cancer, cns, crohns, growth_hormone, hcv, hemophilia, hiv, infertility, ms, organ_transplant, osteoporosis, psoriasis, pulmonary, ra, rare_disease)
biosimilar_available = ?                     ; Biosimilar available
biosimilar_name = :                          ; Biosimilar name if applicable

{@rx_specialty}

; ---------------------------------------------------------------------------
; Cost and Access
; ---------------------------------------------------------------------------
{.cost}
awp = #$:(0..)                               ; AWP price
cost_per_month = #$:(0..)                    ; Monthly cost
cost_per_year = #$:(0..)                     ; Annual cost
specialty_tier_copay = #$:(0..)              ; Member copay
specialty_tier_coinsurance = #:(0..100)      ; Member coinsurance
copay_maximum = #$:(0..)                     ; Copay max

{@rx_specialty}

; ---------------------------------------------------------------------------
; Clinical Requirements
; ---------------------------------------------------------------------------
{.clinical}
prior_auth_required = ?                      ; PA required
step_therapy_required = ?                    ; ST required
step_drugs[] = :                             ; Step therapy drugs
diagnosis_required[] = :                     ; Required ICD-10 codes
lab_monitoring = ?                           ; Lab monitoring required
lab_tests[] = :                              ; Required lab tests
rems_program = ?                             ; REMS required
rems_requirements = :                        ; REMS details

{@rx_specialty}

; ---------------------------------------------------------------------------
; Distribution and Administration
; ---------------------------------------------------------------------------
{.distribution}
limited_distribution = ?                     ; Limited distribution
specialty_pharmacy_only = ?                  ; Specialty pharmacy only
approved_pharmacies[] = :                    ; Approved specialty pharmacies
white_bagging = ?                            ; White bagging allowed
brown_bagging = ?                            ; Brown bagging allowed
clear_bagging = ?                            ; Clear bagging (buy-and-bill)
site_of_care = (clinic, home, hospital_outpatient, infusion_center, physician_office)

{@rx_specialty}

; ---------------------------------------------------------------------------
; Patient Support
; ---------------------------------------------------------------------------
{.patient_support}
copay_assistance = ?                         ; Manufacturer copay assist
copay_card_value = #$:(0..)                  ; Copay card amount
pap_available = ?                            ; Patient assistance program
foundation_support = ?                       ; Foundation support available
nurse_support = ?                            ; Nurse support program
adherence_program = ?                        ; Adherence support
refill_reminder = ?                          ; Refill reminders

{@rx_specialty}

; ---------------------------------------------------------------------------
; Storage and Handling
; ---------------------------------------------------------------------------
{.handling}
cold_chain = ?                               ; Cold chain required
temperature_range = :                        ; Storage temperature
hazardous = ?                                ; Hazardous drug
special_handling = :                         ; Special handling notes
expiration_sensitivity = ?                   ; Short expiration

{@rx_specialty}

; ===================================================================================
; PHARMACY BENEFIT PLAN
; ===================================================================================
; Comprehensive pharmacy plan combining all components

{@rx_benefit_plan}
; Required fields first
plan_id = !:                                 ; Plan identifier
plan_name = !:                               ; Plan name
effective_date = !date                       ; Plan effective date
expiration_date = !date                      ; Plan expiration date

; Invariants
:invariant expiration_date > effective_date

; Plan type
funding_type = !(fully_insured, level_funded, self_funded)
payer_type = (commercial, exchange, medicaid, medicare_partd, self_funded)

; Formulary reference
formulary = @rx_formulary                    ; Associated formulary

; ---------------------------------------------------------------------------
; Deductible - Per 42 CFR 423.104(d)
; ---------------------------------------------------------------------------
{.deductible}
individual = #$:(0..)                        ; Individual deductible
family = #$:(0..)                            ; Family deductible
integrated_medical = ?                       ; Integrated with medical
applies_to_brand = ?                         ; Applies to brand only
applies_to_specialty = ?                     ; Applies to specialty

{@rx_benefit_plan}

; ---------------------------------------------------------------------------
; Out-of-Pocket Maximum
; ---------------------------------------------------------------------------
{.oop_maximum}
individual = #$:(0..)                        ; Individual OOP max
family = #$:(0..)                            ; Family OOP max
integrated_medical = ?                       ; Integrated with medical

{@rx_benefit_plan}

; ---------------------------------------------------------------------------
; Pharmacy Network
; ---------------------------------------------------------------------------
{.network}
pbm = @rx_pbm                                ; PBM reference
retail_pharmacies = ##:(0..)                 ; Retail pharmacy count
preferred_network = ?                        ; Preferred network tier
mail_order = ?                               ; Mail order available
mandatory_mail = ?                           ; Mandatory mail for maintenance
specialty_pharmacy = ?                       ; Specialty pharmacy network
ninety_day_retail = ?                        ; 90-day retail available

{@rx_benefit_plan}

; ---------------------------------------------------------------------------
; Benefit Design
; ---------------------------------------------------------------------------
{.design}
closed_formulary = ?                         ; Closed formulary
mandatory_generic = ?                        ; Mandatory generic substitution
therapeutic_substitution = ?                 ; Therapeutic substitution
dispense_as_written = ?                      ; DAW allowed
daw_penalty = ?                              ; DAW penalty applies
quantity_limits = ?                          ; Quantity limits
prior_auth = ?                               ; Prior auth program
step_therapy = ?                             ; Step therapy program
accumulator_program = ?                      ; Accumulator adjustment
maximizer_program = ?                        ; Copay maximizer

{@rx_benefit_plan}

; ---------------------------------------------------------------------------
; Medicare Part D Specifics - Per 42 CFR 423.104
; ---------------------------------------------------------------------------
{.partd}
contract_number = :/^[HS]\d{4}$/             ; CMS contract number
initial_coverage_limit = #$:(0..)            ; ICL threshold
coverage_gap_begins = #$:(0..)               ; Gap start
catastrophic_threshold = #$:(0..)            ; TrOOP threshold
gap_coverage = ?                             ; Gap coverage
lis_eligible = ?                             ; Low-income subsidy eligible

{@rx_benefit_plan}

; ---------------------------------------------------------------------------
; Summary Statistics
; ---------------------------------------------------------------------------
{.summary}
plan_sponsor = :                             ; Plan sponsor name
members_enrolled = ##:(0..)                  ; Members enrolled
annual_premium = #$:(0..)                    ; Annual premium
monthly_premium = #$:(0..)                   ; Monthly premium
drug_count = ##:(0..)                        ; Drugs on formulary

{@rx_benefit_plan}

; ===================================================================================
; PHARMACY CLAIM
; ===================================================================================
; Per NCPDP standard and 42 CFR 423.308

{@rx_claim}
; Required fields first
claim_id = !:                                ; Claim identifier
fill_date = !date                            ; Date of fill
ndc = !:/^\d{11}$/                           ; National Drug Code
member_id = !*:                              ; Member identifier

; Drug information
{.drug}
drug_name = :                                ; Drug name
strength = :                                 ; Drug strength
quantity = #:(0..)                           ; Quantity dispensed
days_supply = ##:(1..365)                    ; Days supply
refill_number = ##:(0..99)                   ; Refill number
compound = ?                                 ; Compound medication
daw_code = :(1)                              ; Dispense As Written code

{@rx_claim}

; Pharmacy information
{.pharmacy}
ncpdp = :/^\d{7}$/                           ; Pharmacy NCPDP
npi = :/^\d{10}$/                            ; Pharmacy NPI
name = :                                     ; Pharmacy name
pharmacy_type = (chain, clinic, independent, ltc, mail, specialty)

{@rx_claim}

; Prescriber information
{.prescriber}
npi = :/^\d{10}$/                            ; Prescriber NPI
name = :                                     ; Prescriber name
specialty = :                                ; Specialty

{@rx_claim}

; Pricing
{.pricing}
ingredient_cost = #$:(0..)                   ; Ingredient cost
dispensing_fee = #$:(0..)                    ; Dispensing fee
total_amount = #$:(0..)                      ; Total claim amount
patient_pay = #$:(0..)                       ; Member payment
plan_pay = #$:(0..)                          ; Plan payment
copay = #$:(0..)                             ; Copay amount
coinsurance = #$:(0..)                       ; Coinsurance amount
deductible = #$:(0..)                        ; Deductible applied
other_payer = #$:(0..)                       ; Other payer amount

{@rx_claim}

; Adjudication
{.adjudication}
status = (duplicate, paid, pending, rejected, reversed)
rejection_code = :                           ; NCPDP rejection code
rejection_message = :                        ; Rejection description
prior_auth_number = :                        ; PA number if applicable
formulary_status = (covered, non_covered, non_formulary, prior_auth)
tier = ##:(1..6)                             ; Tier assignment

{@rx_claim}

; Part D specifics
{.partd}
coverage_phase = (catastrophic, coverage_gap, deductible, initial_coverage)
troop = #$:(0..)                             ; True out-of-pocket
lics = ?                                     ; Low-income cost sharing
lis_level = (deemed_full, full, none, partial_1, partial_2, partial_3)

{@rx_claim}


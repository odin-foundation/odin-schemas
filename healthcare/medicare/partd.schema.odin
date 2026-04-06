; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Medicare Part D Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Medicare prescription drug coverage (Part D) plan data including formularies,
; coverage phases, low-income subsidies, and star ratings. Derived from CMS
; Pub 100-18 and 42 CFR Part 423.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as medicare

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.medicare.partd"
version = "1.0.0"
title = "Medicare Part D Schema"
description = "Medicare prescription drug coverage (Part D) plan data"

{$derivation}
source[0].authority = "CMS"
source[0].citation = "Medicare Prescription Drug Benefit Manual (CMS Pub 100-18)"
source[0].url = "https://www.cms.gov/Regulations-and-Guidance/Guidance/Manuals/Internet-Only-Manuals-IOMs-Items/CMS019193"

source[1].authority = "GPO"
source[1].citation = "42 CFR Part 423 - Voluntary Medicare Prescription Drug Benefit"
source[1].url = "https://www.ecfr.gov/current/title-42/chapter-IV/subchapter-B/part-423"

source[2].authority = "CMS"
source[2].citation = "Medicare Plan Finder - Part D Plan Data"
source[2].url = "https://www.medicare.gov/plan-compare/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial Medicare Part D schema"
changelog[0].rationale = "Structure derived from CMS Pub 100-18 and 42 CFR Part 423"

; ═══════════════════════════════════════════════════════════════════════════════
; PART D PLAN
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 423.4 and CMS Plan Finder

{@plan}
; Plan identification - Per 42 CFR 423.50
contract_number = !:/^[HS]\d{4}$/            ; CMS contract number (S#### PDP, H#### MA-PD)
plan_id = !:                                 ; Plan benefit package ID
segment_id = :                               ; Segment ID

; Plan type
plan_type = !(employer_pdp, ma_pd, pdp)      ; Plan type

; Sponsor information
{.sponsor}
legal_name = !:                              ; Sponsor legal name
marketing_name = :                           ; Marketing name
parent_organization = :                      ; Parent organization

{@plan}

; Service area - Per 42 CFR 423.2
{.service_area}
region = ##:(1..34)                          ; PDP region (1-34)
states[] = :(2)                              ; States served
nationwide = ?                               ; Nationwide employer plan

{@plan}

; Contract details
{.contract}
contract_year = !##:(2000..2100)             ; Contract year
effective_date = !date                       ; Contract effective date
termination_date = date                      ; Termination date
contract_status = (active, non_renewed, terminated)

{@plan}

; Plan ratings - Per 42 CFR 423.186
{.ratings}
overall_star = #.1:(1..5)                    ; Overall star rating
drug_plan_star = #.1:(1..5)                  ; Drug plan rating
low_performing = ?                           ; Low performing indicator
rating_year = ##:(2000..2100)                ; Rating year

{@plan}

; Formulary
formulary_id = !:                            ; Formulary ID
formulary_version = :                        ; Formulary version

; ═══════════════════════════════════════════════════════════════════════════════
; BENEFIT STRUCTURE
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 423.104 - Standard benefit parameters

{@benefit_structure}
contract_number = !:                         ; Contract number
plan_id = !:                                 ; Plan ID
benefit_year = !##:(2000..2100)              ; Benefit year

; Benefit type - Per 42 CFR 423.104
benefit_type = !(actuarially_equivalent, basic_alternative, defined_standard, enhanced)

; ───────────────────────────────────────────────────────────────────────────────
; Premium - Per 42 CFR 423.286
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
monthly_premium = #$:(0..)                   ; Plan monthly premium
national_base_premium = #$:(0..)             ; National base beneficiary premium
low_income_premium = #$:(0..)                ; LIS benchmark premium

{@benefit_structure}

; ───────────────────────────────────────────────────────────────────────────────
; Deductible Phase - Per 42 CFR 423.104(d)
; ───────────────────────────────────────────────────────────────────────────────
{.deductible}
amount = #$:(0..)                            ; Annual deductible
standard_amount = #$:(0..)                   ; Standard deductible (CMS defined)
applies_to_tiers[] = ##:(1..6)               ; Tiers deductible applies to
exemptions[] = :                             ; Drug classes exempt from deductible

{@benefit_structure}

; ───────────────────────────────────────────────────────────────────────────────
; Initial Coverage Phase - Per 42 CFR 423.104(d)(2)
; ───────────────────────────────────────────────────────────────────────────────
{.initial_coverage}
threshold = #$:(0..)                         ; Initial coverage limit (total drug costs)

; Cost sharing by tier
tiers[] = @tier_cost_sharing                 ; Cost sharing per tier

{@benefit_structure}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Gap Phase - Per 42 CFR 423.104(d)(3)
; ───────────────────────────────────────────────────────────────────────────────
{.coverage_gap}
gap_begins = #$:(0..)                        ; Total drug cost when gap begins
gap_ends = #$:(0..)                          ; Out-of-pocket threshold (gap ends)

; Gap coverage (post-Inflation Reduction Act changes)
{.gap_coverage}
generic_coinsurance = #:(0..100)             ; Beneficiary coinsurance generic
brand_coinsurance = #:(0..100)               ; Beneficiary coinsurance brand
manufacturer_discount = #:(0..100)           ; Manufacturer discount (brand)

{@benefit_structure}

; ───────────────────────────────────────────────────────────────────────────────
; Catastrophic Phase - Per 42 CFR 423.104(d)(4)
; ───────────────────────────────────────────────────────────────────────────────
{.catastrophic}
threshold = #$:(0..)                         ; True out-of-pocket threshold
generic_copay = #$:(0..)                     ; Generic copay in catastrophic
brand_copay = #$:(0..)                       ; Brand copay in catastrophic
coinsurance = #:(0..100)                     ; Coinsurance (whichever is greater)

{@benefit_structure}

; ═══════════════════════════════════════════════════════════════════════════════
; TIER COST SHARING
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 423.104 and CMS formulary guidance

{@tier_cost_sharing}
tier_number = !##:(1..6)                     ; Tier number
tier_name = :                                ; Tier name/label

; Cost sharing type
cost_sharing_type = !(coinsurance, copay)

; Retail pharmacy (30-day supply)
{.retail_30}
preferred_copay = #$:(0..)                   ; Preferred pharmacy copay
standard_copay = #$:(0..)                    ; Standard pharmacy copay
preferred_coinsurance = #:(0..100)           ; Preferred pharmacy coinsurance
standard_coinsurance = #:(0..100)            ; Standard pharmacy coinsurance

{@tier_cost_sharing}

; Retail pharmacy (90-day supply)
{.retail_90}
preferred_copay = #$:(0..)                   ; Preferred pharmacy copay
standard_copay = #$:(0..)                    ; Standard pharmacy copay
preferred_coinsurance = #:(0..100)           ; Preferred coinsurance
standard_coinsurance = #:(0..100)            ; Standard coinsurance

{@tier_cost_sharing}

; Mail order pharmacy (90-day supply)
{.mail_order}
copay = #$:(0..)                             ; Mail order copay
coinsurance = #:(0..100)                     ; Mail order coinsurance

{@tier_cost_sharing}

; ═══════════════════════════════════════════════════════════════════════════════
; FORMULARY
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 423.120 and CMS formulary requirements

{@formulary}
formulary_id = !:                            ; Formulary identifier
formulary_version = !:                       ; Version number
effective_date = !date                       ; Effective date
contract_year = !##:(2000..2100)             ; Contract year

; Sponsor
sponsor_name = :                             ; Plan sponsor name
contracts[] = :                              ; Contracts using this formulary

; Drug counts
{.counts}
total_drugs = ##:(0..)                       ; Total drugs on formulary
tier_1_count = ##:(0..)                      ; Tier 1 drug count
tier_2_count = ##:(0..)                      ; Tier 2 drug count
tier_3_count = ##:(0..)                      ; Tier 3 drug count
tier_4_count = ##:(0..)                      ; Tier 4 drug count
tier_5_count = ##:(0..)                      ; Tier 5 drug count
specialty_count = ##:(0..)                   ; Specialty tier count

{@formulary}

; ═══════════════════════════════════════════════════════════════════════════════
; FORMULARY DRUG
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 423.120

{@formulary_drug}
formulary_id = !:                            ; Formulary ID
ndc = !:/^\d{11}$/                           ; National Drug Code (11-digit)

; Drug identification
{.drug}
rxcui = :                                    ; RxNorm Concept Unique Identifier
name_brand = :                               ; Brand name
name_generic = :                             ; Generic name
strength = :                                 ; Drug strength
dosage_form = :                              ; Dosage form (tablet, capsule, etc.)

{@formulary_drug}

; Tier placement
tier = !##:(1..6)                            ; Formulary tier
tier_name = :                                ; Tier name

; Restrictions - Per 42 CFR 423.120(b)
{.restrictions}
prior_auth = ?                               ; Prior authorization required (PA)
step_therapy = ?                             ; Step therapy required (ST)
quantity_limit = ?                           ; Quantity limits apply (QL)
quantity_limit_amount = ##:(0..)             ; Quantity limit per fill
quantity_limit_days = ##:(0..)               ; Days supply for limit
specialty = ?                                ; Specialty tier drug
half_tab = ?                                 ; Half-tablet allowed

{@formulary_drug}

; Pharmacy type restrictions
{.pharmacy}
mail_only = ?                                ; Mail-order only
specialty_pharmacy_only = ?                  ; Specialty pharmacy only
limited_distribution = ?                     ; Limited distribution

{@formulary_drug}

; Generic availability
generic_available = ?                        ; Generic available
brand_preferred = ?                          ; Brand preferred over generic

; ═══════════════════════════════════════════════════════════════════════════════
; PHARMACY NETWORK
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 423.120(a)

{@pharmacy_network}
network_id = !:                              ; Network identifier
contract_number = !:                         ; Contract number

; Network type
{.network}
standard_pharmacies = ##:(0..)               ; Standard network pharmacy count
preferred_pharmacies = ##:(0..)              ; Preferred pharmacy count
mail_order_pharmacies = ##:(0..)             ; Mail order pharmacy count
ltc_pharmacies = ##:(0..)                    ; Long-term care pharmacy count
specialty_pharmacies = ##:(0..)              ; Specialty pharmacy count

{@pharmacy_network}

; Network adequacy - Per 42 CFR 423.120(a)(1)
{.adequacy}
meets_standards = ?                          ; Meets CMS standards
urban_access_percent = #:(0..100)            ; Urban access percentage
suburban_access_percent = #:(0..100)         ; Suburban access percentage
rural_access_percent = #:(0..100)            ; Rural access percentage

{@pharmacy_network}

; ═══════════════════════════════════════════════════════════════════════════════
; COVERAGE DETERMINATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 423.566 - Coverage Determinations

{@coverage_determination}
request_id = !:                              ; Request identifier
beneficiary_mbi = !*:                        ; Beneficiary MBI
contract_number = !:                         ; Plan contract number

; Request details
{.request}
request_date = !date                         ; Date of request
request_type = !(coverage, exception, tiering)
expedited = ?                                ; Expedited request
prescriber_support = ?                       ; Prescriber supporting statement

{@coverage_determination}

; Drug requested
{.drug}
ndc = :                                      ; NDC if known
drug_name = !:                               ; Drug name
strength = :                                 ; Drug strength
quantity = ##:(0..)                          ; Quantity requested
days_supply = ##:(0..)                       ; Days supply

{@coverage_determination}

; Determination - Per 42 CFR 423.568
{.determination}
decision_date = date                         ; Date of determination
decision = (approved, denied, partially_approved)
effective_date = date                        ; Approval effective date
end_date = date                              ; Approval end date
reason = :                                   ; Reason for decision

{@coverage_determination}

; Appeal - Per 42 CFR 423.580-600
{.appeal}
appealed = ?                                 ; Appealed to redetermination
appeal_date = date                           ; Date of appeal
appeal_level = (alj, council, district_court, ire, redetermination)
appeal_decision = (affirmed, dismissed, reversed)
appeal_decision_date = date                  ; Appeal decision date

{@coverage_determination}

; ═══════════════════════════════════════════════════════════════════════════════
; MEDICATION THERAPY MANAGEMENT (MTM)
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 423.153(d)

{@mtm_program}
contract_number = !:                         ; Contract number
program_year = !##:(2000..2100)              ; Program year

; Targeting criteria - Per 42 CFR 423.153(d)(2)
{.targeting}
min_chronic_conditions = ##:(2..5)           ; Minimum chronic conditions
min_part_d_drugs = ##:(2..8)                 ; Minimum Part D drugs
min_annual_cost = #$:(0..)                   ; Minimum annual drug cost threshold
targeted_conditions[] = :                    ; Targeted chronic conditions

{@mtm_program}

; Program elements - Per 42 CFR 423.153(d)(1)
{.services}
cmr_offered = ?                              ; Comprehensive Medication Review offered
tmr_offered = ?                              ; Targeted Medication Review offered
intervention_letters = ?                     ; Prescriber intervention letters
patient_education = ?                        ; Patient education materials

{@mtm_program}

; ═══════════════════════════════════════════════════════════════════════════════
; MTM ENROLLMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 423.153(d)

{@mtm_enrollment}
beneficiary_mbi = !*:                        ; Beneficiary MBI
contract_number = !:                         ; Contract number
enrollment_date = !date                      ; MTM enrollment date

; Eligibility
{.eligibility}
chronic_condition_count = ##:(0..)           ; Number of chronic conditions
part_d_drug_count = ##:(0..)                 ; Number of Part D drugs
projected_annual_cost = #$:(0..)             ; Projected annual drug cost

{@mtm_enrollment}

; Services received
{.services}
cmr_date = date                              ; CMR completion date
cmr_method = (phone, telehealth, in_person)  ; CMR delivery method
tmr_count = ##:(0..)                         ; TMR count this year
personal_medication_list = ?                 ; PML provided
medication_action_plan = ?                   ; MAP provided

{@mtm_enrollment}

; Opt-out
opted_out = ?                                ; Beneficiary opted out
opt_out_date = date                          ; Date of opt-out


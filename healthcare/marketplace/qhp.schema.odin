; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Qualified Health Plan (QHP) Schema
; ═══════════════════════════════════════════════════════════════════════════════
; QHP certification and plan data structures including metal levels, essential
; health benefits, cost sharing, and network adequacy. Derived from 45 CFR
; Part 156 - Health Insurance Issuer Standards.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as marketplace

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.marketplace.qhp"
version = "1.0.0"
title = "Qualified Health Plan Schema"
description = "QHP certification and plan data structures"

{$derivation}
source[0].authority = "GPO"
source[0].citation = "45 CFR Part 156 - Health Insurance Issuer Standards"
source[0].url = "https://www.ecfr.gov/current/title-45/subtitle-A/subchapter-B/part-156"

source[1].authority = "CMS"
source[1].citation = "QHP Certification Application Instructions"
source[1].url = "https://www.cms.gov/CCIIO/Programs-and-Initiatives/Health-Insurance-Marketplaces/qhp"

source[2].authority = "CMS"
source[2].citation = "Plan Management Technical Guidance"
source[2].url = "https://www.cms.gov/cciio/Resources/Regulations-and-Guidance"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial QHP schema"
changelog[0].rationale = "Structure derived from 45 CFR Part 156 and QHP certification requirements"

; ═══════════════════════════════════════════════════════════════════════════════
; QHP PLAN
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 156.200

{@plan}
plan_id = :                                ; HIOS plan ID (14 char)
issuer_id = :                              ; HIOS issuer ID (5 char)
plan_year = ##:(2014..)                    ; Plan/benefit year
state = :(2)                               ; State

; Plan identification
{.identification}
marketing_name = :                         ; Plan marketing name
hios_product_id = :                         ; Product ID
standard_component_id = :                   ; Standard component ID
plan_variant = :                            ; Plan variant (CSR)

{@plan}

; Market - Per 45 CFR 156.200
{.market}
market = (individual, shop)                ; Market type
exchange_type = (ffm, sbm, sbm_fp)          ; Exchange type
on_exchange = ?                             ; Offered on exchange
off_exchange = ?                            ; Offered off exchange

{@plan}

; Metal level - Per 45 CFR 156.140
{.metal}
metal_level = (bronze, catastrophic, gold, platinum, silver)
actuarial_value = #:(0..100)                ; Actual AV
de_minimis_variation = #:(-2..2)            ; AV variation

{@plan}

; Plan type
{.type}
plan_type = (epo, hmo, indemnity, pos, ppo)
network_tier = :                            ; Network tier type
referral_required = ?                       ; Referral to specialist required

{@plan}

; Service area - Per 45 CFR 156.235
service_area = @marketplace.service_area   ; Service area

; Certification - Per 45 CFR 156.200
{.certification}
qhp_certified = ?                           ; QHP certified
certification_date = date                   ; Certification date
certification_expiration = date             ; Certification expiration
certification_type = (conditional, full)    ; Certification type

{@plan}

; ═══════════════════════════════════════════════════════════════════════════════
; QHP BENEFITS
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 156.110-115 - Essential Health Benefits

{@benefits}
plan_id = :                                ; Plan ID
plan_year = ##:(2014..)                    ; Benefit year

; EHB coverage - Per 45 CFR 156.110
{.ehb}
ehb_benchmark = :                           ; EHB benchmark plan
ehb_percent = #:(0..100)                    ; Percent of benefits that are EHB

{@benefits}

; Essential health benefit categories - Per 45 CFR 156.110(a)
{.categories}
ambulatory = ?true                          ; Ambulatory patient services
emergency = ?true                           ; Emergency services
hospitalization = ?true                     ; Hospitalization
maternity_newborn = ?true                   ; Maternity and newborn care
mental_health_sud = ?true                   ; Mental health and SUD
prescription_drugs = ?true                  ; Prescription drugs
rehabilitative = ?true                      ; Rehabilitative services
lab = ?true                                 ; Laboratory services
preventive_wellness = ?true                 ; Preventive and wellness
pediatric = ?true                           ; Pediatric services (dental/vision)

{@benefits}

; Cost sharing - Per 45 CFR 156.130
{.cost_sharing}
individual_deductible = #$:(0..)            ; Individual deductible
family_deductible = #$:(0..)                ; Family deductible
individual_oop_max = #$:(0..)               ; Individual OOP maximum
family_oop_max = #$:(0..)                   ; Family OOP maximum
integrated_medical_drug = ?                 ; Integrated medical/drug deductible
separate_drug_deductible = #$:(0..)         ; Separate drug deductible

{@benefits}

; Annual limits - Per 45 CFR 156.130
{.limits}
annual_limit_applies = ?false               ; Annual dollar limit (prohibited)
lifetime_limit_applies = ?false             ; Lifetime limit (prohibited)

{@benefits}

; Specific benefits
benefits[] = @benefit_item                  ; Detailed benefit list

{@benefit_item}
benefit_name = :                           ; Benefit name
ehb_category = :                            ; EHB category
covered = ?                                 ; Covered
quantitative_limit = :                      ; Quantity limit
limit_unit = :                              ; Limit unit (visits, days)

; Cost sharing for benefit
{.cost_share}
in_network_copay = #$:(0..)                 ; In-network copay
in_network_coinsurance = #:(0..100)         ; In-network coinsurance %
out_network_copay = #$:(0..)                ; Out-of-network copay
out_network_coinsurance = #:(0..100)        ; Out-of-network coinsurance %
deductible_applies = ?                      ; Subject to deductible

{@benefit_item}

; ═══════════════════════════════════════════════════════════════════════════════
; FORMULARY
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 156.122

{@formulary}
formulary_id = :                           ; Formulary ID
plan_id = :                                ; Associated plan
plan_year = ##:(2014..)                    ; Plan year

; Structure
{.structure}
tier_count = ##:(1..6)                      ; Number of tiers
specialty_tier = ?                          ; Has specialty tier
zero_dollar_tier = ?                        ; Has $0 tier

{@formulary}

; Tier definitions
tiers[] = @formulary_tier                   ; Tier definitions

; Drug list
drugs[] = @formulary_drug                   ; Drugs on formulary

{@formulary_tier}
tier_number = ##:(1..6)                    ; Tier number
tier_name = :                               ; Tier name (Generic, Preferred Brand, etc.)

; Cost sharing
{.cost_share}
copay = #$:(0..)                            ; Copay amount
coinsurance = #:(0..100)                    ; Coinsurance %
deductible_applies = ?                      ; Subject to deductible

{@formulary_tier}

{@formulary_drug}
rxcui = :                                  ; RxNorm Concept ID
drug_name = :                               ; Drug name
tier = ##:(1..6)                            ; Tier assignment

; Restrictions - Per 45 CFR 156.122
{.restrictions}
prior_authorization = ?                     ; PA required
step_therapy = ?                            ; Step therapy required
quantity_limit = ?                          ; Quantity limit applies
specialty_drug = ?                          ; Specialty drug

{@formulary_drug}

; ═══════════════════════════════════════════════════════════════════════════════
; NETWORK
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 156.230

{@network}
network_id = :                             ; Network ID
plan_id = :                                ; Plan ID
network_name = :                            ; Network name

; Network adequacy - Per 45 CFR 156.230
{.adequacy}
meets_adequacy = ?                          ; Meets network adequacy
time_distance_standard = ?                  ; Meets time/distance
appointment_wait_standard = ?               ; Meets appointment wait
essential_community_providers = ?           ; Meets ECP requirement

{@network}

; ECP participation - Per 45 CFR 156.235
{.ecp}
ecp_count = ##:(0..)                        ; Number of ECPs
ecp_percent = #:(0..100)                    ; ECP participation %
fqhc_count = ##:(0..)                       ; FQHC count
ryan_white_count = ##:(0..)                 ; Ryan White providers
family_planning_count = ##:(0..)            ; Family planning providers

{@network}

; Provider counts
{.providers}
total_providers = ##:(0..)                  ; Total network providers
pcp_count = ##:(0..)                        ; Primary care providers
specialist_count = ##:(0..)                 ; Specialists
hospital_count = ##:(0..)                   ; Hospitals
mental_health_count = ##:(0..)              ; Mental health providers
pharmacy_count = ##:(0..)                   ; Pharmacies

{@network}

; ═══════════════════════════════════════════════════════════════════════════════
; RATES
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 156.80 and 147.102

{@rates}
plan_id = :                                ; Plan ID
rating_area = :                            ; Rating area
plan_year = ##:(2014..)                    ; Plan year
effective_date = date                      ; Rate effective date

; Rate basis - Per 45 CFR 147.102
{.basis}
age_rating = ?true                          ; Uses age rating (3:1)
tobacco_rating = ?                          ; Uses tobacco rating (1.5:1)
geographic_rating = ?true                   ; Geographic rating
family_tier_rating = ?                      ; Family tier rating

{@rates}

; Age curve - Per 45 CFR 147.102
{.age_curve}
age_0 = #:(0..3)                            ; Age 0 factor
age_21 = #:(0..3)                           ; Age 21 factor
age_40 = #:(0..3)                           ; Age 40 factor
age_64 = #:(0..3)                           ; Age 64 factor

{@rates}

; Individual rates
rates_by_age[] = @rate_by_age               ; Rates by age

; Family tier rates
{.family_tiers}
individual = #$:(0..)                       ; Individual
couple = #$:(0..)                           ; Couple (adult + adult)
primary_one_dependent = #$:(0..)            ; Adult + 1 child
primary_two_dependents = #$:(0..)           ; Adult + 2 children
primary_three_dependents = #$:(0..)         ; Adult + 3+ children
couple_one_dependent = #$:(0..)             ; Couple + 1 child
couple_two_dependents = #$:(0..)            ; Couple + 2 children
couple_three_dependents = #$:(0..)          ; Couple + 3+ children

{@rates}

{@rate_by_age}
age = ##:(0..64)                            ; Age
non_tobacco_rate = #$:(0..)                 ; Non-tobacco rate
tobacco_rate = #$:(0..)                     ; Tobacco rate

; ═══════════════════════════════════════════════════════════════════════════════
; CSR VARIANT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 156.420

{@csr_variant}
plan_id = :                                ; Standard plan ID
variant_id = :                             ; Variant plan ID
csr_level = ##:(73..100)                   ; CSR level (73, 87, 94)

; Adjusted cost sharing - Per 45 CFR 156.420(a)
{.cost_sharing}
individual_deductible = #$:(0..)            ; Reduced deductible
family_deductible = #$:(0..)                ; Reduced family deductible
individual_oop_max = #$:(0..)               ; Reduced OOP max
family_oop_max = #$:(0..)                   ; Reduced family OOP max
actuarial_value = #:(73..94)                ; Target AV

{@csr_variant}

; Native American zero cost sharing - Per 45 CFR 156.420(d)
{.native_american}
zero_cost_sharing = ?                       ; Zero cost sharing variant
income_under_300_fpl = ?                    ; For income under 300% FPL

{@csr_variant}

; ═══════════════════════════════════════════════════════════════════════════════
; CATASTROPHIC PLAN
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 156.155

{@catastrophic_plan}
plan_id = :                                ; Plan ID
plan_year = ##:(2014..)                    ; Plan year

; Eligibility - Per 45 CFR 156.155
{.eligibility}
under_30_only = ?true                       ; Under 30 eligible
hardship_exemption = ?                      ; Hardship exemption holders eligible
affordability_exemption = ?                 ; Affordability exemption holders

{@catastrophic_plan}

; Benefits - Per 45 CFR 156.155(a)
{.benefits}
preventive_before_deductible = ?true        ; Preventive services before deductible
primary_care_visits = ##:(3..)              ; Primary care visits before deductible
deductible_equals_oop = ?true               ; Deductible equals OOP max

{@catastrophic_plan}

; ═══════════════════════════════════════════════════════════════════════════════
; STANDARDIZED PLAN OPTIONS
; ═══════════════════════════════════════════════════════════════════════════════
; Per CMS standardized plan guidelines

{@standardized_plan}
plan_id = :                                ; Plan ID
standard_option = :                        ; Standard option identifier
plan_year = ##:(2014..)                    ; Plan year

; Standardization
{.standard}
standardized = ?                            ; Standardized option
standard_design = :                         ; Standard design name
simple_choice = ?                           ; CMS Simple Choice plan

{@standardized_plan}

; Fixed cost sharing - Standardized plans
{.fixed_cost_share}
deductible = #$:(0..)                       ; Standard deductible
pcp_copay = #$:(0..)                        ; PCP copay
specialist_copay = #$:(0..)                 ; Specialist copay
generic_copay = #$:(0..)                    ; Generic drug copay
er_copay = #$:(0..)                         ; ER copay
inpatient_copay = #$:(0..)                  ; Inpatient copay/day

{@standardized_plan}


; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Medicare Advantage Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Medicare Advantage (Part C) plan data including MA-PD plans, SNPs, service
; areas, benefits, and star ratings. Derived from CMS Pub 100-16 and
; 42 CFR Part 422.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as medicare

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.medicare.advantage"
version = "1.0.0"
title = "Medicare Advantage Schema"
description = "Medicare Advantage (Part C) plan data"

{$derivation}
source[0].authority = "CMS"
source[0].citation = "Medicare Managed Care Manual (CMS Pub 100-16)"
source[0].url = "https://www.cms.gov/Regulations-and-Guidance/Guidance/Manuals/Internet-Only-Manuals-IOMs-Items/CMS019326"

source[1].authority = "GPO"
source[1].citation = "42 CFR Part 422 - Medicare Advantage Program"
source[1].url = "https://www.ecfr.gov/current/title-42/chapter-IV/subchapter-B/part-422"

source[2].authority = "CMS"
source[2].citation = "Medicare Plan Finder Data"
source[2].url = "https://www.medicare.gov/plan-compare/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial Medicare Advantage schema"
changelog[0].rationale = "Structure derived from CMS Pub 100-16 and 42 CFR Part 422"

; ═══════════════════════════════════════════════════════════════════════════════
; MEDICARE ADVANTAGE PLAN
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 422.4 and CMS Plan Finder

{@plan}
; Plan identification - Per 42 CFR 422.50
contract_number = :/^H\d{4}$/               ; CMS contract number (H####)
plan_id = :                                 ; Plan benefit package ID (PBP)
segment_id = :                               ; Segment ID (if applicable)

; Organization - Per 42 CFR 422.500
{.organization}
legal_name = :                              ; MA organization legal name
marketing_name = :                           ; Marketing/DBA name
organization_type = (hmo, local_ccp, pso, regional_ccp)  ; Per 42 CFR 422.4
parent_organization = :                      ; Parent organization name

{@plan}

; Plan type - Per 42 CFR 422.4
plan_type = (hmo, hmo_pos, local_ppo, msa, pffs, regional_ppo, snp)
snp_type = (c_snp, d_snp, i_snp):if plan_type = snp  ; SNP subtype

; Contract information
{.contract}
contract_year = ##:(2000..2100)             ; Contract year
effective_date = date                       ; Contract effective date
termination_date = date                      ; Contract termination date (if applicable)
contract_status = (active, non_renewed, terminated)

{@plan}

; Service area - Per 42 CFR 422.2
{.service_area}
area_type = (county, state, region)          ; Service area type
states[] = :(2)                              ; States in service area
counties[] = :                               ; Counties in service area (FIPS codes)
zip_codes[] = :                              ; ZIP codes in service area
region_number = ##:(1..26):if plan_type = regional_ppo  ; MA region

{@plan}

; Part D included - Per 42 CFR 422.111
{.part_d}
ma_pd = ?                                    ; Includes Part D (MA-PD)
part_d_contract = :                          ; Part D contract number
part_d_pbp = :                               ; Part D plan benefit package
formulary_id = :                             ; Formulary ID

{@plan}

; ───────────────────────────────────────────────────────────────────────────────
; Plan Ratings - Per 42 CFR 422.162
; ───────────────────────────────────────────────────────────────────────────────
{.ratings}
overall_star = #.1:(1..5)                    ; Overall star rating (1-5)
health_plan_star = #.1:(1..5)                ; Health plan star rating
drug_plan_star = #.1:(1..5):if part_d.ma_pd = true  ; Drug plan star rating
low_performing = ?                           ; Low performing indicator
high_performing = ?                          ; Five-star plan indicator
rating_year = ##:(2000..2100)                ; Rating year

{@plan}

; ═══════════════════════════════════════════════════════════════════════════════
; PLAN BENEFITS
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 422.100-422.111 and CMS Plan Benefit Package

{@benefits}
contract_number = :                         ; Contract number
plan_id = :                                 ; Plan benefit package ID
benefit_year = ##:(2000..2100)              ; Benefit year

; ───────────────────────────────────────────────────────────────────────────────
; Premium and Cost Sharing - Per 42 CFR 422.262
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
monthly_premium = #$:(0..)                   ; Monthly plan premium
part_b_premium_reduction = #$:(0..)          ; Part B premium rebate
part_d_premium = #$:(0..)                    ; Part D portion (if MA-PD)
total_monthly = #$:(0..)                     ; Total monthly premium

{@benefits}

{.deductible}
medical_deductible = #$:(0..)                ; Annual medical deductible
drug_deductible = #$:(0..)                   ; Part D deductible (if MA-PD)
combined_deductible = ?                      ; Combined medical/drug deductible

{@benefits}

; Out-of-pocket maximum - Per 42 CFR 422.100(f)
{.moop}
in_network = #$:(0..)                       ; In-network MOOP
out_of_network = #$:(0..)                    ; Out-of-network MOOP (if applicable)
combined = #$:(0..)                          ; Combined MOOP
includes_drugs = ?                           ; MOOP includes Part D costs

{@benefits}

; ───────────────────────────────────────────────────────────────────────────────
; Inpatient Benefits - Per 42 CFR 422.101
; ───────────────────────────────────────────────────────────────────────────────
{.inpatient}
; Hospital
{.hospital}
copay_days_1_5 = #$:(0..)                    ; Copay per day, days 1-5
copay_days_6_plus = #$:(0..)                 ; Copay per day, days 6+
copay_per_stay = #$:(0..)                    ; Copay per admission
coinsurance = #:(0..100)                     ; Coinsurance percentage
day_limit = ##:(0..)                         ; Covered days per benefit period
prior_auth_required = ?                      ; Prior authorization required

{@benefits.inpatient}

; Skilled nursing facility
{.snf}
copay_days_1_20 = #$:(0..)                   ; Copay days 1-20
copay_days_21_100 = #$:(0..)                 ; Copay days 21-100
day_limit = ##:(0..100)                      ; Covered days
prior_auth_required = ?                      ; Prior authorization required

{@benefits.inpatient}

; Psychiatric
{.psychiatric}
copay_per_day = #$:(0..)                     ; Copay per day
coinsurance = #:(0..100)                     ; Coinsurance percentage
day_limit = ##:(0..)                         ; Day limit per year

{@benefits}

; ───────────────────────────────────────────────────────────────────────────────
; Outpatient Benefits - Per 42 CFR 422.101
; ───────────────────────────────────────────────────────────────────────────────
{.outpatient}
; Primary care
{.primary_care}
copay = #$:(0..)                             ; PCP visit copay
coinsurance = #:(0..100)                     ; Coinsurance percentage
visits_per_year = ##:(0..)                   ; Visit limit (0 = unlimited)

{@benefits.outpatient}

; Specialist
{.specialist}
copay = #$:(0..)                             ; Specialist visit copay
coinsurance = #:(0..100)                     ; Coinsurance percentage
referral_required = ?                        ; PCP referral required

{@benefits.outpatient}

; Preventive care - Per 42 CFR 422.100(c)
{.preventive}
medicare_covered_zero_cost = ?               ; Medicare-covered at $0
annual_wellness_copay = #$:(0..)             ; Annual wellness visit copay

{@benefits.outpatient}

; Emergency
{.emergency}
copay = #$:(0..)                             ; ER copay
waived_if_admitted = ?                       ; Copay waived if admitted

{@benefits.outpatient}

; Urgent care
{.urgent}
copay = #$:(0..)                             ; Urgent care copay
coinsurance = #:(0..100)                     ; Coinsurance percentage

{@benefits.outpatient}

; Outpatient surgery
{.surgery}
ambulatory_copay = #$:(0..)                  ; Ambulatory surgical center copay
hospital_copay = #$:(0..)                    ; Hospital outpatient copay
coinsurance = #:(0..100)                     ; Coinsurance percentage

{@benefits}

; ───────────────────────────────────────────────────────────────────────────────
; Supplemental Benefits - Per 42 CFR 422.102
; ───────────────────────────────────────────────────────────────────────────────
{.supplemental}
; Vision
{.vision}
routine_exam_covered = ?                     ; Routine eye exam covered
exam_copay = #$:(0..)                        ; Eye exam copay
eyewear_allowance = #$:(0..)                 ; Eyewear allowance per year
eyewear_frequency = ##:(1..3)                ; Eyewear every X years

{@benefits.supplemental}

; Dental
{.dental}
preventive_covered = ?                       ; Preventive dental covered
preventive_copay = #$:(0..)                  ; Preventive services copay
comprehensive_covered = ?                    ; Comprehensive dental covered
annual_maximum = #$:(0..)                    ; Annual maximum benefit

{@benefits.supplemental}

; Hearing
{.hearing}
exam_covered = ?                             ; Hearing exam covered
exam_copay = #$:(0..)                        ; Hearing exam copay
hearing_aids_covered = ?                     ; Hearing aids covered
hearing_aid_allowance = #$:(0..)             ; Hearing aid allowance

{@benefits.supplemental}

; Fitness
{.fitness}
fitness_benefit = ?                          ; Fitness benefit included
program_name = :                             ; Fitness program name (e.g., SilverSneakers)

{@benefits.supplemental}

; Transportation
{.transportation}
covered = ?                                  ; Transportation benefit
trips_per_year = ##:(0..)                    ; Trips per year
one_way_trips = ?                            ; One-way trip counting
miles_limit = ##:(0..)                       ; Mile limit per trip

{@benefits.supplemental}

; Over-the-counter
{.otc}
covered = ?                                  ; OTC benefit included
quarterly_allowance = #$:(0..)               ; Quarterly allowance
annual_allowance = #$:(0..)                  ; Annual allowance

{@benefits.supplemental}

; Meals
{.meals}
covered = ?                                  ; Meal benefit included
meals_per_discharge = ##:(0..)               ; Meals after hospital discharge
days_covered = ##:(0..)                      ; Days of meals covered

{@benefits.supplemental}

; Telehealth
{.telehealth}
covered = ?                                  ; Telehealth covered
copay = #$:(0..)                             ; Telehealth visit copay

{@benefits}

; ═══════════════════════════════════════════════════════════════════════════════
; NETWORK
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 422.112

{@network}
contract_number = :                         ; Contract number
plan_id = :                                 ; Plan ID
network_id = :                               ; Network identifier

; Network type
network_type = (closed, open, ppo)          ; Network type
out_of_network_coverage = ?                  ; OON coverage available

; Provider counts
{.providers}
pcp_count = ##:(0..)                         ; Primary care physicians
specialist_count = ##:(0..)                  ; Specialists
hospital_count = ##:(0..)                    ; Hospitals
snf_count = ##:(0..)                         ; SNFs
pharmacy_count = ##:(0..)                    ; In-network pharmacies

{@network}

; Network adequacy - Per 42 CFR 422.116
{.adequacy}
meets_standards = ?                          ; Meets CMS network adequacy
max_travel_time_pcp = ##:(0..)               ; Max travel time to PCP (minutes)
max_travel_time_hospital = ##:(0..)          ; Max travel time to hospital

{@network}

; ═══════════════════════════════════════════════════════════════════════════════
; SPECIAL NEEDS PLAN (SNP)
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 422.2 and 422.101(f)

{@snp}
contract_number = :                         ; Contract number
plan_id = :                                 ; Plan ID

; SNP type - Per 42 CFR 422.2
snp_type = (c_snp, d_snp, i_snp)

; Dual-eligible SNP (D-SNP) - Per 42 CFR 422.107
{.d_snp}
integration_type = (aic, fide, hide):if snp_type = d_snp
; aic = Applicable Integrated Care
; fide = Fully Integrated Dual Eligible
; hide = Highly Integrated Dual Eligible
state_contract = :                           ; State Medicaid contract
medicaid_benefits_included = ?               ; Includes Medicaid benefits

{@snp}

; Chronic condition SNP (C-SNP) - Per 42 CFR 422.4(a)(1)(iv)
{.c_snp}
conditions[] = (cardiovascular, chronic_heart_failure, copd, dementia, diabetes, esrd, hiv_aids, other_chronic):if snp_type = c_snp
multiple_chronic = ?                         ; Multiple chronic conditions

{@snp}

; Institutional SNP (I-SNP) - Per 42 CFR 422.2
{.i_snp}
setting = (assisted_living, ltc_facility, nursing_home, other):if snp_type = i_snp
institution_equivalent = ?                   ; Institutional-equivalent in community

{@snp}

; Model of care - Per 42 CFR 422.101(f)
{.model_of_care}
description = :                              ; MOC description
care_management = ?                          ; Care management included
interdisciplinary_team = ?                   ; IDT included
health_risk_assessment = ?                   ; HRA required
individualized_care_plan = ?                 ; ICP developed

{@snp}

; ═══════════════════════════════════════════════════════════════════════════════
; ANNUAL NOTICE OF CHANGE (ANOC)
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 422.111(d)

{@anoc}
contract_number = :                         ; Contract number
plan_id = :                                 ; Plan ID
notice_year = ##:(2000..2100)               ; Notice for year

; Notice details
{.notice}
mailing_date = date                          ; Date ANOC mailed
effective_date = date                        ; Changes effective date

{@anoc}

; Changes summary
{.changes}
premium_change = ?                           ; Premium changing
premium_current = #$:(0..)                   ; Current premium
premium_new = #$:(0..)                       ; New premium

deductible_change = ?                        ; Deductible changing
copay_change = ?                             ; Copays changing
moop_change = ?                              ; MOOP changing
network_change = ?                           ; Network changing
formulary_change = ?                         ; Formulary changing (if MA-PD)
benefit_change = ?                           ; Benefits changing

{@anoc}

; Change details
change_descriptions[] = :                    ; Description of each change


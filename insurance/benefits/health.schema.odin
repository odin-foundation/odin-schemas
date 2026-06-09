; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Employee Health Benefits Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Medical, dental, vision, prescription, and HSA/FSA benefit structures derived
; from ERISA, ACA, and IRS requirements.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as benefits

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.benefits.health"
version = "1.0.0"
title = "Employee Health Benefits Schema"
description = "Medical, dental, vision, prescription, and account-based benefits"

{$derivation}
source[0].authority = "GPO"
source[0].citation = "29 USC Chapter 18 - ERISA Health Plans"
source[0].url = "https://www.law.cornell.edu/uscode/text/29/chapter-18"

source[1].authority = "IRS"
source[1].citation = "IRC Sections 105, 106, 125, 223 - Health Benefits Tax Treatment"
source[1].url = "https://www.irs.gov/publications/p969"

source[2].authority = "CMS"
source[2].citation = "ACA Group Health Plan Requirements"
source[2].url = "https://www.cms.gov/cciio/Programs-and-Initiatives/Health-Insurance-Market-Reforms"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial employee health benefits schema"
changelog[0].rationale = "Structure derived from ERISA and ACA group health plan requirements"

; ═══════════════════════════════════════════════════════════════════════════════
; MEDICAL PLAN
; ═══════════════════════════════════════════════════════════════════════════════

{@medical_plan}
plan_id = :                                ; Plan ID
employer_id = :                            ; Employer
plan_name = :                              ; Plan name
plan_year = ##:(2000..)                    ; Plan year

; Plan type
{.type}
funding_type = (fully_insured, level_funded, self_funded)
plan_type = (epo, hdhp, hmo, indemnity, ppo)
network_name = :                            ; Network name

{@medical_plan}

; Carrier
{.carrier}
carrier_name = :                            ; Carrier name
carrier_id = :                              ; Carrier ID
policy_number = :                           ; Policy number
group_number = :                            ; Group number
tpa_name = :                                ; TPA (if self-funded)
stop_loss_carrier = :                       ; Stop-loss carrier (if self-funded)

{@medical_plan}

; Cost sharing - In-network
{.in_network}
individual_deductible = #$:(0..)            ; Individual deductible
family_deductible = #$:(0..)                ; Family deductible
individual_oop_max = #$:(0..)               ; Individual OOP max
family_oop_max = #$:(0..)                   ; Family OOP max
coinsurance = #:(0..100)                    ; Coinsurance %
pcp_copay = #$:(0..)                        ; PCP copay
specialist_copay = #$:(0..)                 ; Specialist copay
urgent_care_copay = #$:(0..)                ; Urgent care copay
er_copay = #$:(0..)                         ; ER copay

{@medical_plan}

; Cost sharing - Out-of-network
{.out_of_network}
individual_deductible = #$:(0..)            ; OON individual deductible
family_deductible = #$:(0..)                ; OON family deductible
individual_oop_max = #$:(0..)               ; OON individual OOP max
family_oop_max = #$:(0..)                   ; OON family OOP max
coinsurance = #:(0..100)                    ; OON coinsurance %

{@medical_plan}

; HDHP requirements - Per IRS Notice 2004-2
{.hdhp}
hdhp_qualified = ?                          ; HDHP qualified for HSA
minimum_deductible_met = ?                  ; Meets minimum deductible
maximum_oop_met = ?                         ; Under OOP maximum

{@medical_plan}

; ACA compliance
{.aca}
aca_compliant = ?                           ; ACA compliant
essential_health_benefits = ?               ; Covers EHB
preventive_no_cost_share = ?                ; Preventive at no cost share
no_annual_limits = ?                        ; No annual dollar limits
no_lifetime_limits = ?                      ; No lifetime limits
mental_health_parity = ?                    ; MHPAEA compliant

{@medical_plan}

; Premium tiers
{.premium_tiers}
ee_only = #$:(0..)                          ; Employee only
ee_spouse = #$:(0..)                        ; Employee + spouse
ee_children = #$:(0..)                      ; Employee + child(ren)
family = #$:(0..)                           ; Family

{@medical_plan}

; Employer contribution
{.contribution}
contribution_type = (dollar, percent, tier_based)
ee_only_contribution = #$:(0..)             ; EE only contribution
family_contribution = #$:(0..)              ; Family contribution
contribution_percent = #:(0..100)           ; Contribution %

{@medical_plan}

; ═══════════════════════════════════════════════════════════════════════════════
; DENTAL PLAN
; ═══════════════════════════════════════════════════════════════════════════════

{@dental_plan}
plan_id = :                                ; Plan ID
employer_id = :                            ; Employer
plan_name = :                              ; Plan name

; Plan type
{.type}
plan_type = (dhmo, indemnity, ppo)
network_name = :                            ; Network name

{@dental_plan}

; Carrier
{.carrier}
carrier_name = :                            ; Carrier name
policy_number = :                           ; Policy number
group_number = :                            ; Group number

{@dental_plan}

; Coverage levels - Per service category
{.coverage}
preventive_coinsurance = #:(0..100)         ; Preventive (cleanings, exams)
basic_coinsurance = #:(0..100)              ; Basic (fillings, extractions)
major_coinsurance = #:(0..100)              ; Major (crowns, root canals)
orthodontia_coinsurance = #:(0..100)        ; Orthodontia

{@dental_plan}

; Deductible
{.deductible}
individual_deductible = #$:(0..)            ; Individual deductible
family_deductible = #$:(0..)                ; Family deductible
waived_for_preventive = ?                   ; Deductible waived for preventive

{@dental_plan}

; Maximums
{.maximums}
annual_maximum = #$:(0..)                   ; Annual benefit maximum
orthodontia_lifetime_max = #$:(0..)         ; Ortho lifetime max
waiting_periods = ?                         ; Has waiting periods

{@dental_plan}

; Waiting periods
{.waiting_periods}
basic_waiting_months = ##:(0..12)           ; Basic services
major_waiting_months = ##:(0..12)           ; Major services
ortho_waiting_months = ##:(0..24)           ; Orthodontia

{@dental_plan}

; Premium tiers
{.premium_tiers}
ee_only = #$:(0..)                          ; Employee only
ee_spouse = #$:(0..)                        ; Employee + spouse
ee_children = #$:(0..)                      ; Employee + child(ren)
family = #$:(0..)                           ; Family

{@dental_plan}

; ═══════════════════════════════════════════════════════════════════════════════
; VISION PLAN
; ═══════════════════════════════════════════════════════════════════════════════

{@vision_plan}
plan_id = :                                ; Plan ID
employer_id = :                            ; Employer
plan_name = :                              ; Plan name

; Carrier
{.carrier}
carrier_name = :                            ; Carrier name
policy_number = :                           ; Policy number
group_number = :                            ; Group number
network_name = :                            ; Network name

{@vision_plan}

; Exam benefit
{.exam}
exam_copay = #$:(0..)                       ; Exam copay
exam_frequency = ##:(12..24)                ; Months between exams

{@vision_plan}

; Lenses benefit
{.lenses}
lenses_copay = #$:(0..)                     ; Lenses copay
lenses_frequency = ##:(12..24)              ; Months between lenses
progressive_allowance = #$:(0..)            ; Progressive lens allowance

{@vision_plan}

; Frames benefit
{.frames}
frames_allowance = #$:(0..)                 ; Frame allowance
frames_frequency = ##:(12..24)              ; Months between frames
discount_over_allowance = #:(0..100)        ; Discount over allowance

{@vision_plan}

; Contact lenses
{.contacts}
contacts_allowance = #$:(0..)               ; Contact lens allowance
contacts_frequency = ##:(12..24)            ; Months between contacts
elective_allowance = #$:(0..)               ; Elective contacts allowance
medically_necessary = #$:(0..)              ; Medically necessary allowance

{@vision_plan}

; Laser surgery
{.laser}
lasik_discount = #:(0..50)                  ; LASIK discount %
prk_discount = #:(0..50)                    ; PRK discount %

{@vision_plan}

; Premium tiers
{.premium_tiers}
ee_only = #$:(0..)                          ; Employee only
ee_spouse = #$:(0..)                        ; Employee + spouse
ee_children = #$:(0..)                      ; Employee + child(ren)
family = #$:(0..)                           ; Family

{@vision_plan}

; ═══════════════════════════════════════════════════════════════════════════════
; PRESCRIPTION DRUG PLAN
; ═══════════════════════════════════════════════════════════════════════════════

{@rx_plan}
plan_id = :                                ; Plan ID
employer_id = :                            ; Employer
plan_name = :                               ; Plan name

; PBM
{.pbm}
pbm_name = :                                ; Pharmacy Benefit Manager
bin = :                                     ; BIN number
pcn = :                                     ; PCN
group_id = :                                ; Group ID

{@rx_plan}

; Integrated vs carve-out
{.structure}
integrated_with_medical = ?                 ; Integrated with medical
carve_out = ?                               ; Carve-out plan
separate_deductible = ?                     ; Separate Rx deductible

{@rx_plan}

; Deductible
{.deductible}
individual_deductible = #$:(0..)            ; Individual Rx deductible
family_deductible = #$:(0..)                ; Family Rx deductible

{@rx_plan}

; Tier copays - Retail 30-day
{.retail}
tier1_copay = #$:(0..)                      ; Generic copay
tier2_copay = #$:(0..)                      ; Preferred brand copay
tier3_copay = #$:(0..)                      ; Non-preferred brand copay
tier4_copay = #$:(0..)                      ; Specialty copay
tier4_coinsurance = #:(0..100)              ; Specialty coinsurance

{@rx_plan}

; Tier copays - Mail order 90-day
{.mail_order}
tier1_copay = #$:(0..)                      ; Generic copay
tier2_copay = #$:(0..)                      ; Preferred brand copay
tier3_copay = #$:(0..)                      ; Non-preferred brand copay
tier4_copay = #$:(0..)                      ; Specialty copay
mandatory_mail_order = ?                    ; Mandatory mail order

{@rx_plan}

; Specialty
{.specialty}
specialty_pharmacy_required = ?             ; Specialty pharmacy required
specialty_pharmacy_name = :                 ; Specialty pharmacy name
prior_auth_required = ?                     ; Prior auth for specialty
step_therapy = ?                            ; Step therapy required

{@rx_plan}

; Out of pocket max
{.oop}
embedded_in_medical = ?                     ; Rx counts toward medical OOP
separate_rx_oop_max = #$:(0..)              ; Separate Rx OOP max

{@rx_plan}

; ═══════════════════════════════════════════════════════════════════════════════
; HEALTH SAVINGS ACCOUNT (HSA)
; ═══════════════════════════════════════════════════════════════════════════════
; Per IRC Section 223

{@hsa}
account_id = :                             ; Account ID
employee_id = :                            ; Employee
tax_year = ##:(2004..)                     ; Tax year (HSA effective 2004)

; Account custodian
{.custodian}
custodian_name = :                          ; Custodian/trustee name
account_number = *:                         ; Account number

{@hsa}

; Contribution limits - Per IRS annual limits
{.limits}
individual_limit = #$:(0..)                 ; Individual limit
family_limit = #$:(0..)                     ; Family limit
catch_up_limit = #$:(0..)                   ; Age 55+ catch-up

{@hsa}

; Contributions
{.contributions}
employee_contribution = #$:(0..)            ; Employee contributions
employer_contribution = #$:(0..)            ; Employer contributions
total_contributions = #$:(0..)              ; Total YTD contributions
catch_up_eligible = ?                       ; Age 55+ eligible
catch_up_contribution = #$:(0..)            ; Catch-up contribution

{@hsa}

; Balance
{.balance}
current_balance = #$:(0..)                  ; Current balance
invested_balance = #$:(0..)                 ; Invested portion
cash_balance = #$:(0..)                     ; Cash portion

{@hsa}

; Investment options
{.investments}
investment_threshold = #$:(0..)             ; Balance required to invest
investment_options[] = :                    ; Available investments

{@hsa}

; ═══════════════════════════════════════════════════════════════════════════════
; HEALTH FSA
; ═══════════════════════════════════════════════════════════════════════════════
; Per IRC Section 125

{@health_fsa}
account_id = :                             ; Account ID
employee_id = :                            ; Employee
plan_year = ##:(2000..)                    ; Plan year

; Administrator
{.administrator}
administrator_name = :                      ; TPA/administrator
account_number = *:                         ; Account number

{@health_fsa}

; Election
{.election}
annual_election = #$:(0..)                  ; Annual election amount
per_pay_contribution = #$:(0..)             ; Per pay period
annual_limit = #$:(0..)                     ; IRS annual limit

{@health_fsa}

; Balance
{.balance}
available_balance = #$:(0..)                ; Available balance
ytd_contributions = #$:(0..)                ; YTD contributions
ytd_claims_paid = #$:(0..)                  ; YTD claims paid
ytd_claims_pending = #$:(0..)               ; YTD claims pending

{@health_fsa}

; Carryover/grace period - Per IRS options
{.rollover}
carryover_allowed = ?                       ; Carryover option
carryover_limit = #$:(0..)                  ; Carryover limit
grace_period_allowed = ?                    ; Grace period option
grace_period_end = date                     ; Grace period end date
run_out_end = date                          ; Run-out period end date

{@health_fsa}

; Limited purpose FSA (for HSA users)
limited_purpose = ?                         ; Limited purpose FSA

; ═══════════════════════════════════════════════════════════════════════════════
; DEPENDENT CARE FSA
; ═══════════════════════════════════════════════════════════════════════════════
; Per IRC Section 129

{@dependent_care_fsa}
account_id = :                             ; Account ID
employee_id = :                            ; Employee
plan_year = ##:(2000..)                    ; Plan year

; Administrator
{.administrator}
administrator_name = :                      ; TPA/administrator
account_number = *:                         ; Account number

{@dependent_care_fsa}

; Election
{.election}
annual_election = #$:(0..)                  ; Annual election
per_pay_contribution = #$:(0..)             ; Per pay period
annual_limit_single = #$:(0..)              ; Limit if single/MFJ
annual_limit_mfs = #$:(0..)                 ; Limit if MFS

{@dependent_care_fsa}

; Balance
{.balance}
available_balance = #$:(0..)                ; Available balance (contributed only)
ytd_contributions = #$:(0..)                ; YTD contributions
ytd_claims_paid = #$:(0..)                  ; YTD claims paid

{@dependent_care_fsa}

; Eligible dependents
{.eligible_dependents}
under_13_child = ?                          ; Child under 13
disabled_dependent = ?                      ; Disabled dependent
disabled_spouse = ?                         ; Disabled spouse

{@dependent_care_fsa}

; Dates
{.dates}
run_out_end = date                          ; Run-out period end
forfeiture_date = date                      ; Unused balance forfeiture date

{@dependent_care_fsa}

; ═══════════════════════════════════════════════════════════════════════════════
; HEALTH REIMBURSEMENT ARRANGEMENT (HRA)
; ═══════════════════════════════════════════════════════════════════════════════
; Per IRC Section 105

{@hra}
account_id = :                             ; Account ID
employee_id = :                            ; Employee
plan_year = ##:(2000..)                    ; Plan year

; HRA type - Per IRS types
{.type}
hra_type = (excepted, ichra, qsehra, traditional)
; ichra = Individual Coverage HRA
; qsehra = Qualified Small Employer HRA
; excepted = Excepted benefit HRA

{@hra}

; Employer contribution
{.contribution}
employer_contribution = #$:(0..)            ; Annual employer contribution
contribution_frequency = (annual, monthly, per_pay)
prorated_for_new_hires = ?                  ; Prorated for new hires

{@hra}

; Balance
{.balance}
available_balance = #$:(0..)                ; Available balance
ytd_used = #$:(0..)                         ; YTD used
rollover_balance = #$:(0..)                 ; Rolled over from prior year

{@hra}

; Rollover
{.rollover}
rollover_allowed = ?                        ; Rollover permitted
rollover_limit = #$:(0..)                   ; Maximum rollover
unlimited_rollover = ?                      ; Unlimited rollover

{@hra}

; Integration with HDHP (for HSA compatibility)
{.integration}
integrated_with_hdhp = ?                    ; Integrated with HDHP
post_deductible_hra = ?                     ; Only pays after deductible

{@hra}


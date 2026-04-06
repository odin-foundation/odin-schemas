; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Workers Compensation Coverage Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Workers compensation coverage line extension of the universal coverage primitive
; adding fields for class codes, experience modification, state-specific
; requirements, and employers liability limits.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../coverage.schema.odin" as cov
@import "../limits.schema.odin" as limits

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.coverages.lines.workers-comp"
version = "1.0.0"
title = "Workers Compensation Coverage Schema"
description = "Workers compensation coverage extending universal coverage primitive"

{$derivation}
source[0].authority = "U.S. Department of Labor"
source[0].citation = "Office of Workers' Compensation Programs"
source[0].url = "https://www.dol.gov/agencies/owcp"

source[1].authority = "National Association of Insurance Commissioners (NAIC)"
source[1].citation = "Workers Compensation Model Laws and Regulations"
source[1].url = "https://content.naic.org/"

source[2].authority = "State Workers Compensation Boards"
source[2].citation = "Various state workers compensation statutes"
source[2].url = "https://www.dol.gov/general/topic/workcomp"

source[3].authority = "Association of Workers' Compensation Boards of Canada (AWCBC)"
source[3].citation = "Workers' Compensation in Canada"
source[3].url = "https://awcbc.org/"

source[4].authority = "Workplace Safety and Insurance Board (WSIB) Ontario"
source[4].citation = "WSIA and Rate Framework"
source[4].url = "https://www.wsib.ca/"

source[5].authority = "WorkSafeBC"
source[5].citation = "Workers Compensation Act"
source[5].url = "https://www.worksafebc.com/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Workers compensation coverage line extension - US and Canada"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial workers comp coverage schema"
changelog[0].rationale = "Coverage-centric architecture - WC line extension"

; ═══════════════════════════════════════════════════════════════════════════════
; Workers Comp Coverage (Extends Universal Coverage)
; ═══════════════════════════════════════════════════════════════════════════════

{@wc_coverage}
= @coverage                                       ; Inherit all universal coverage fields

; ───────────────────────────────────────────────────────────────────────────────
; Jurisdiction
; ───────────────────────────────────────────────────────────────────────────────
state = !:(2)                                     ; State jurisdiction
state_act = (federal, maritime, state, uslh)      ; Which act applies

; ───────────────────────────────────────────────────────────────────────────────
; Class Code
; ───────────────────────────────────────────────────────────────────────────────
class_code = !:                                   ; State class code
class_description = :                             ; Class code description
governing_class = ?                               ; Is this the governing class?

; ───────────────────────────────────────────────────────────────────────────────
; Rating Bureau
; ───────────────────────────────────────────────────────────────────────────────
rating_bureau = (
    DTCI,
    MWCIA,
    NCCI,
    NYCIRB,
    PCRB,
    state_fund,
    WCIRB
)

; ───────────────────────────────────────────────────────────────────────────────
; Rating
; ───────────────────────────────────────────────────────────────────────────────
{.rating}
payroll = !#$:(0..)                               ; Estimated annual payroll
employee_count = ##:(0..99999)                    ; Number of employees
rate = #:(0..999.999999)                          ; Rate per $100 payroll
manual_premium = #$:(0..)                         ; Manual premium before mods
standard_premium = #$:(0..)                       ; Premium after exp mod
modified_premium = #$:(0..)                       ; Premium after all mods

{@wc_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Experience Modification
; ───────────────────────────────────────────────────────────────────────────────
{.experience_mod}
factor = #:(0..9.999)                             ; Experience modification factor
effective_date = date
expiration_date = date
interstate = ?                                    ; Interstate vs intrastate

{@wc_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Schedule Rating
; ───────────────────────────────────────────────────────────────────────────────
{.schedule_rating}
credit = #:(-50..0)                               ; Schedule credit (negative)
debit = #:(0..50)                                 ; Schedule debit (positive)
net = #:(-50..50)                                 ; Net schedule modification

{@wc_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Part One - Statutory Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@wc_statutory_coverage}
= @wc_coverage

coverage_type_ref = "WC_STAT"
category = "statutory"

; Statutory - no dollar limit, benefits per state law
statutory = ? "true"

; State benefit maximums (informational - set by state law)
; NOTE: Actual benefit amounts are determined by state law, not schema
{.state_benefits}
benefit_waiting_period_days = ##:(0..14)
temporary_total_max_weeks = ##:(0..999)
permanent_total_available = ?
death_benefit_available = ?

{@wc_statutory_coverage}

; Voluntary compensation
voluntary_comp = ?
voluntary_comp_states[] = :(2):if voluntary_comp = true

; ═══════════════════════════════════════════════════════════════════════════════
; Part Two - Employers Liability Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@wc_el_coverage}
= @wc_coverage

coverage_type_ref = "WC_EL"
category = "liability"

; Employers liability limits
{.el_limits}
each_accident = !#$:(0..)                         ; Bodily injury by accident
disease_each_employee = !#$:(0..)                 ; Bodily injury by disease per employee
disease_policy_limit = !#$:(0..)                  ; Bodily injury by disease policy limit

{@wc_el_coverage}

; Stop gap for monopolistic states
stop_gap = ?
stop_gap_states[] = :(2):if stop_gap = true

; ═══════════════════════════════════════════════════════════════════════════════
; Part Three - Other States Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@wc_other_states_coverage}
= @wc_coverage

coverage_type_ref = "WC_OS"

; Other states
other_states_all = ?                              ; All states except listed
other_states_list[] = :(2)                        ; Or list specific states
excluded_states[] = :(2)                          ; States excluded (monopolistic, etc.)

; ═══════════════════════════════════════════════════════════════════════════════
; WC Deductible Programs
; ═══════════════════════════════════════════════════════════════════════════════

{@wc_deductible_coverage}
= @wc_coverage

; Deductible program
{.deductible_program}
type = (large_deductible, retrospective, small_deductible)
per_claim = #$:(0..)
aggregate = #$:(0..)
applies_to = (indemnity_and_medical, indemnity_only, medical_only)

; Collateral
collateral_required = ?
collateral_amount = #$:(0..):if collateral_required = true
collateral_type = (cash, letter_of_credit, surety_bond, trust):if collateral_required = true

{@wc_deductible_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Special WC Coverages
; ═══════════════════════════════════════════════════════════════════════════════

{@wc_special_coverage}
= @wc_coverage

; USL&H (Longshore and Harbor Workers)
uslh = ?
uslh_payroll = #$:(0..):if uslh = true
uslh_rate = #:(0..999.999999):if uslh = true

; Jones Act (Maritime)
jones_act = ?
jones_act_payroll = #$:(0..):if jones_act = true

; Federal employees
fela = ?                                          ; Federal Employers Liability Act

; Foreign voluntary comp
foreign_voluntary = ?
foreign_countries[] = :(2..3):if foreign_voluntary = true

; ═══════════════════════════════════════════════════════════════════════════════
; Canadian Workers' Compensation Board (WCB) Coverage
; ═══════════════════════════════════════════════════════════════════════════════
; All Canadian provinces have government-run WCB systems. Private insurance
; is not sold for statutory coverage. However, employers may need:
; - WCB registration and premium tracking
; - Employers liability (non-WCB covered workers)
; - Personal Optional Protection (BC) for principals/partners
; - Business interruption related to workplace injuries

{@wcb_coverage}
= @wc_coverage

; Provincial WCB jurisdiction
province = !:(2)                                 ; Canadian province/territory code

; Provincial WCB Board
wcb_board = !(
    AWCBC,                                       ; Federal (some industries)
    CNESST,                                      ; Quebec
    NWT_WSCC,                                    ; NWT & Nunavut
    WCB_AB,                                      ; Alberta
    WCB_MB,                                      ; Manitoba
    WCB_NB,                                      ; New Brunswick
    WCB_NL,                                      ; Newfoundland & Labrador
    WCB_NS,                                      ; Nova Scotia
    WCB_PEI,                                     ; Prince Edward Island
    WCB_SK,                                      ; Saskatchewan
    WCB_YT,                                      ; Yukon
    WorkSafeBC,                                  ; British Columbia
    WSIB                                         ; Ontario
)

; Registration
{.registration}
account_number = *:                               ; WCB account/firm number
registration_date = date
registration_status = (active, clearance_pending, lapsed, new, suspended)
clearance_letter = ?                             ; Has current clearance letter
clearance_expiry = date

{@wcb_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; WCB Rating
; ───────────────────────────────────────────────────────────────────────────────
{.wcb_rating}
rate_group = :                                   ; Provincial rate group/class
rate_code = :                                    ; Specific rate classification
industry_code = :                                ; NAICS or provincial code
base_rate = #:(0..99.99)                         ; Rate per $100 payroll
assessable_payroll = #$:(0..)                    ; Payroll subject to assessment
maximum_assessable = #$:(0..)                    ; Max insurable earnings per worker
premium = #$:(0..)                               ; Annual WCB premium

{@wcb_coverage}

; Experience Rating
{.experience_rating}
program_type = (CAD7, MAP, NEER, PEP, PRIME, provincial_specific)
; Ontario programs: NEER (legacy), MAP (Merit Adjusted Premium), PEP
; BC: Experience Rating
; Alberta: PIR (Partners in Injury Reduction)
experience_rating_factor = #:(0..9.99)
surcharge_percent = #:(-100..200)                ; + surcharge or - rebate
performance_index = #:(0..9.99)                  ; Claims cost performance

{@wcb_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; WCB Benefits Structure (informational - set by provincial legislation)
; ───────────────────────────────────────────────────────────────────────────────
{.benefits}
; These are informational/reference - actual benefits per provincial law
wage_loss_percent = ##:(0..100)                  ; Standard: 85-90% of net earnings
max_insurable_earnings = #$:(0..)                ; Provincial YMPE-based cap
waiting_period_days = ##:(0..3)                  ; Standard: 0-3 days
retroactive_if_exceeds_days = ##:(0..14)

{@wcb_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Workers Covered
; ───────────────────────────────────────────────────────────────────────────────
{.workers}
full_time = ##:(0..99999)
part_time = ##:(0..99999)
seasonal = ##:(0..99999)
contract = ##:(0..99999)
total_workers = ##:(0..99999)

{@wcb_coverage}

; Principal/Partner Coverage
{.principals}
covered = ?                                      ; Principals/partners covered under WCB
coverage_type = (mandatory, optional, excluded)
principal_count = ##:(0..99)
principal_payroll = #$:(0..)                     ; Earnings amount for principals

{@wcb_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; BC Personal Optional Protection (POP)
; ═══════════════════════════════════════════════════════════════════════════════
; WorkSafeBC allows proprietors, partners, and some executives to opt-in

{@bc_pop_coverage}
= @wcb_coverage

wcb_board = "WorkSafeBC"
province = "BC"
coverage_type_ref = "BC_POP"

; POP Enrollment
{.pop}
enrolled = ?
coverage_level = (full, partial)
annual_earnings = #$:(0..)                       ; Declared annual earnings
effective_date = date
expiration_date = date

{@bc_pop_coverage}

; Covered Individuals
{.covered_individuals[]}
individual_id = :
name = :
role = (director, executive, partner, proprietor)
ownership_percent = ##:(0..100)
annual_earnings = #$:(0..)

{@bc_pop_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Ontario WSIB Coverage
; ═══════════════════════════════════════════════════════════════════════════════
; Workplace Safety and Insurance Board specifics

{@wsib_coverage}
= @wcb_coverage

wcb_board = "WSIB"
province = "ON"
coverage_type_ref = "ON_WSIB"

; WSIB Account
{.account}
firm_number = :                                  ; WSIB firm number
branch_number = :                                ; Branch if applicable
account_class = (Schedule_1, Schedule_2)         ; Schedule 1 (collective liability) or 2 (self-insured)

{@wsib_coverage}

; Rate Framework
{.rate_framework}
classification_unit = :                          ; CU code
industry_premium_rate = #:(0..99.99)             ; Industry rate
employer_premium_rate = #:(0..99.99)             ; Actual employer rate after adjustments
premium_rate_effective = date

{@wsib_coverage}

; MAP / Performance Rating
{.performance}
map_enrolled = ?                                 ; Merit Adjusted Premium
projected_costs = #$:(0..)
actual_costs = #$:(0..)
adjustment_percent = #:(-100..100)

{@wsib_coverage}

; Constructive Employer Obligations
executive_coverage = ?                           ; Executives/officers covered
independent_operators = ?                        ; IOs covered

; ═══════════════════════════════════════════════════════════════════════════════
; Quebec CNESST Coverage
; ═══════════════════════════════════════════════════════════════════════════════
; Commission des normes, de l'équité, de la santé et de la sécurité du travail

{@cnesst_coverage}
= @wcb_coverage

wcb_board = "CNESST"
province = "QC"
coverage_type_ref = "QC_CNESST"

; CNESST Registration
{.registration}
employer_file_number = :                         ; Dossier d'employeur
unit_classification = :                          ; Classification unit
risk_unit = :                                    ; Unité de risque

{@cnesst_coverage}

; Rating
{.rating}
sector_rate = #:(0..99.99)
personalized_rate = #:(0..99.99)
retroactive_plan = ?                             ; Enrolled in retrospective rating

{@cnesst_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Alberta WCB Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@wcb_alberta_coverage}
= @wcb_coverage

wcb_board = "WCB_AB"
province = "AB"
coverage_type_ref = "AB_WCB"

; Account
{.account}
account_number = *:
subclass_code = :                                ; Industry subclass

{@wcb_alberta_coverage}

; PIR Partnership
{.pir}
pir_enrolled = ?                                 ; Partners in Injury Reduction
pir_level = (bronze, gold, silver)
certificate_of_recognition = ?                   ; COR certified

{@wcb_alberta_coverage}

; Experience Rating
{.experience}
industry_rate = #:(0..99.99)
experience_adjustment = #:(-100..100)            ; % adjustment
net_rate = #:(0..99.99)

{@wcb_alberta_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Canadian Employers Liability (Non-WCB Workers)
; ═══════════════════════════════════════════════════════════════════════════════
; Private insurance for workers not covered by provincial WCB

{@canadian_el_coverage}
= @wc_coverage

coverage_type_ref = "CA_EL"
category = "liability"

; Which province
province = !:(2)

; Workers not covered by WCB
{.non_covered_workers}
executive_officers = ?                           ; Officers who opted out
independent_contractors = ?                      ; True ICs not covered
out_of_province = ?                              ; Employees working out of province
federal_undertakings = ?                         ; Federal jurisdiction industries

{@canadian_el_coverage}

; Employers liability limits (private coverage)
{.el_limits}
per_occurrence = #$:(0..)
aggregate = #$:(0..)
defense_costs = (included, outside_limits)

{@canadian_el_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Cross-Border (US-Canada) WC Coverage
; ═══════════════════════════════════════════════════════════════════════════════
; For employers with operations in both countries

{@cross_border_wc_coverage}
= @wc_coverage

coverage_type_ref = "CROSS_BORDER_WC"

; Primary jurisdiction
primary_country = !(CA, US)
primary_jurisdiction = !:(2)                     ; State or Province

; Secondary coverage
{.cross_border}
secondary_country = !(CA, US)
secondary_jurisdictions[] = :(2)                 ; States or provinces
temporary_workers = ?                            ; Covers temporary assignments
business_travel = ?                              ; Covers business travel
assignment_max_days = ##:(0..365)                ; Max days before local registration required

{@cross_border_wc_coverage}

; Coordination
{.coordination}
reciprocity_agreement = ?                        ; Covered under reciprocity agreement
primary_payer = (home_jurisdiction, work_jurisdiction)
certificate_on_file = ?                          ; Letter of coverage on file

{@cross_border_wc_coverage}


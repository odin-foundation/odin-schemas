; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Auto Coverage Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Auto coverage line extension of the universal coverage primitive adding auto-
; specific fields for liability, uninsured/underinsured motorist, PIP/no-fault,
; and physical damage coverages.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../coverage.schema.odin" as cov
@import "../limits.schema.odin" as limits

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.coverages.lines.auto"
version = "1.0.0"
title = "Auto Coverage Schema"
description = "Auto-specific coverage extending universal coverage primitive"

{$derivation}
source[0].authority = "U.S. Department of Transportation"
source[0].citation = "Federal Motor Carrier Safety Administration"
source[0].url = "https://www.fmcsa.dot.gov/"

source[1].authority = "National Association of Insurance Commissioners (NAIC)"
source[1].citation = "Auto Insurance Model Laws and Regulations"
source[1].url = "https://content.naic.org/"

source[2].authority = "State Insurance Departments"
source[2].citation = "Various state auto insurance regulations"
source[2].url = "https://content.naic.org/state-insurance-departments"

source[3].authority = "Financial Services Regulatory Authority of Ontario (FSRA)"
source[3].citation = "Statutory Accident Benefits Schedule (SABS)"
source[3].url = "https://www.ontario.ca/laws/regulation/100034"

source[4].authority = "Insurance Corporation of British Columbia (ICBC)"
source[4].citation = "Basic and Optional Autoplan Coverage"
source[4].url = "https://www.icbc.com/"

source[5].authority = "Société de l'assurance automobile du Québec (SAAQ)"
source[5].citation = "Public automobile insurance plan"
source[5].url = "https://saaq.gouv.qc.ca/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Auto coverage line extension - US and Canada"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial auto coverage schema"
changelog[0].rationale = "Coverage-centric architecture - auto line extension"

; ═══════════════════════════════════════════════════════════════════════════════
; Auto Coverage (Extends Universal Coverage)
; ═══════════════════════════════════════════════════════════════════════════════

{@auto_coverage}
= @coverage                                       ; Inherit all universal coverage fields

; ───────────────────────────────────────────────────────────────────────────────
; Symbol Classification
; ───────────────────────────────────────────────────────────────────────────────
symbol = :(1..2)                                  ; Auto symbol (1-9, 10, etc.)
; Symbol meanings:
; 1 = Any auto
; 2 = Owned autos only
; 3 = Owned private passenger autos only
; 4 = Owned autos other than private passenger
; 5 = Owned autos subject to no-fault
; 6 = Owned autos subject to compulsory UM law
; 7 = Specifically described autos
; 8 = Hired autos only
; 9 = Non-owned autos only

; ───────────────────────────────────────────────────────────────────────────────
; Vehicle/Driver Assignment
; ───────────────────────────────────────────────────────────────────────────────
vehicle_ref = :                                   ; Reference to specific vehicle
driver_ref = :                                    ; Reference to specific driver
driver_assignment = (any, excluded, occasional, principal, rated)
applies_to = (driver, policy, vehicle)

; ───────────────────────────────────────────────────────────────────────────────
; Split Limit Structure (Auto-Specific)
; ───────────────────────────────────────────────────────────────────────────────
{.split_limits}
bi_per_person = #$                                ; BI per person limit
bi_per_accident = #$                              ; BI per accident limit
pd = #$                                           ; PD limit
display = :                                       ; e.g., "100/300/100"

{@auto_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Combined Single Limit (Alternative to Split)
; ───────────────────────────────────────────────────────────────────────────────
combined_single_limit = #$

; ───────────────────────────────────────────────────────────────────────────────
; UM/UIM Specific
; ───────────────────────────────────────────────────────────────────────────────
{.um_uim}
stacked = ?                                       ; Stacked vs non-stacked
added_on = ?                                      ; Added-on vs reduced-by
conversion = ?                                    ; Conversion coverage
economic_only = ?                                 ; Economic-only UM (no pain/suffering)

{@auto_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; PIP/No-Fault Specific
; ───────────────────────────────────────────────────────────────────────────────
{.pip}
medical_limit = #$
wage_loss_limit = #$
wage_loss_percent = #:(0..100)                    ; Percentage of wages covered
funeral_benefit = #$
survivors_benefit = #$
essential_services = #$
work_loss_excluded = ?
deductible = @deductible                          ; Use shared deductible type
coordination_of_benefits = (excess, primary)

{@auto_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Physical Damage Options
; ───────────────────────────────────────────────────────────────────────────────
{.physical_damage}
actual_cash_value = ?
agreed_value = ?
agreed_value_amount = #$:if agreed_value = true
stated_amount = #$
replacement_cost = ?
oem_parts = ?                                     ; Original equipment manufacturer parts
full_safety_glass = ?                             ; Glass without deductible
sound_system_limit = #$                           ; Aftermarket sound system

{@auto_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Rental Reimbursement Options
; ───────────────────────────────────────────────────────────────────────────────
{.rental}
daily_limit = #$
maximum_days = ##
maximum_total = #$

{@auto_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Towing Options
; ───────────────────────────────────────────────────────────────────────────────
{.towing}
limit = #$
disablement_limit = #$                            ; Per disablement

{@auto_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Auto Liability Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@auto_liability_coverage}
= @auto_coverage

coverage_type_ref = "BI"                          ; or "PD" or "CSL"
category = "liability"

; Liability-specific options
out_of_state_coverage = ?                         ; Extends to meet other state minimums
mexico_coverage = ?
canada_coverage = ?

; ═══════════════════════════════════════════════════════════════════════════════
; Auto Physical Damage Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@auto_pd_coverage}
= @auto_coverage

coverage_type_ref = "COLL"                        ; or "COMP"
category = "physical_damage"

; Physical damage specific
{.valuation}
type = !(actual_cash_value, agreed_value, replacement_cost, stated_amount)
amount = #$:if type = agreed_value || type = stated_amount

{@auto_pd_coverage}

; Loss payee
loss_payee_ref = :                                ; Reference to lienholder

; ═══════════════════════════════════════════════════════════════════════════════
; Commercial Auto Specific Extensions
; ═══════════════════════════════════════════════════════════════════════════════

{@commercial_auto_coverage}
= @auto_coverage

; Commercial auto classifications
radius_class = (intermediate, local, long_haul)
size_class = (extra_heavy, heavy, light, medium)
business_use = (commercial, retail, service)

; Fleet rating
fleet_rated = ?
fleet_number = :

; MCS-90 (Motor Carrier)
mcs_90_endorsement = ?
mcs_90_limit = #$:if mcs_90_endorsement = true

; Trucking
trucker_coverage = ?
motor_carrier_coverage = ?
trailer_interchange = ?
trailer_interchange_limit = #$:if trailer_interchange = true

; Hired/Non-owned
hired_auto = ?
non_owned_auto = ?

; ═══════════════════════════════════════════════════════════════════════════════
; Canadian Auto Coverage Extensions
; ═══════════════════════════════════════════════════════════════════════════════
; Canadian provinces have unique auto insurance structures including government
; insurers (BC, MB, SK), no-fault systems, and specific benefit structures.

; ───────────────────────────────────────────────────────────────────────────────
; Ontario Statutory Accident Benefits Schedule (SABS)
; ───────────────────────────────────────────────────────────────────────────────
; Ontario's no-fault accident benefits under O. Reg. 34/10

{@ontario_sabs_coverage}
= @auto_coverage

coverage_type_ref = "ON_SABS"
category = "accident_benefits"
province = "ON"

; Injury classification
{.injury_category}
catastrophic = ?                                 ; Catastrophic impairment
non_catastrophic = ?                             ; Non-catastrophic impairment
minor = ?                                        ; Minor injury guideline applies

{@ontario_sabs_coverage}

; Medical, Rehabilitation and Attendant Care Benefits
{.medical_rehab}
limit = #$                                       ; Combined med/rehab limit
attendant_care_limit = #$                        ; Attendant care limit
attendant_care_monthly = #$                      ; Monthly attendant care cap
case_manager = ?                                 ; Case manager coverage
assessment = ?                                   ; Assessment cost coverage
optional_medical_limit = #$                      ; Optional increased limits
optional_attendant_limit = #$                    ; Optional increased attendant care

{@ontario_sabs_coverage}

; Income Replacement Benefits
{.income_replacement}
weekly_limit = #$                                ; Weekly income replacement limit
percent_gross = #:(0..100)                       ; Percentage of gross weekly income
waiting_period_days = ##:(0..7)                  ; Waiting period
duration = (104_weeks, 2_years, until_65, variable)
optional_weekly_limit = #$                       ; Optional increased weekly limit

{@ontario_sabs_coverage}

; Non-Earner Benefits
{.non_earner}
weekly_limit = #$
waiting_period_weeks = ##:(0..26)
duration = (104_weeks, until_65)

{@ontario_sabs_coverage}

; Caregiver Benefits
{.caregiver}
weekly_limit = #$

{@ontario_sabs_coverage}

; Death and Funeral Benefits
{.death_funeral}
death_benefit_spouse = #$
death_benefit_dependent = #$
funeral_benefit = #$

{@ontario_sabs_coverage}

; Housekeeping and Home Maintenance
{.housekeeping}
weekly_limit = #$

{@ontario_sabs_coverage}

; Examinations and Assessments
{.examinations}
insurer_examination = ?                          ; Insurer examination rights
dispute_resolution = (arbitration, court, mediation)

{@ontario_sabs_coverage}

; Optional Benefits Purchased
{.optional_benefits}
increased_medical = ?
increased_income = ?
increased_attendant = ?
caregiver = ?
indexation = ?                                   ; COLA indexation of benefits
dependant_care = ?

{@ontario_sabs_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Direct Compensation - Property Damage (DCPD)
; ───────────────────────────────────────────────────────────────────────────────
; Available in ON, NB, NS, PEI - insured claims against own insurer for PD

{@dcpd_coverage}
= @auto_coverage

coverage_type_ref = "DCPD"
category = "property_damage"

; Applies in these provinces
province = (NB, NS, ON, PE)

; Degree of fault
{.fault}
degree_of_fault_percent = ##:(0..100)            ; Insured's degree of fault
not_at_fault_claim = ?                           ; 0% at fault claim
partial_fault_claim = ?                          ; 1-99% at fault

{@dcpd_coverage}

; Coverage scope
{.scope}
insured_vehicle = ?                              ; Damage to insured vehicle
contents = ?                                     ; Contents of vehicle
loss_of_use = ?                                  ; Rental/loss of use

{@dcpd_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Quebec Dual System (SAAQ Public + Private)
; ───────────────────────────────────────────────────────────────────────────────
; Quebec has public bodily injury coverage via SAAQ, private for property/liability

{@quebec_auto_coverage}
= @auto_coverage

province = "QC"

; Public vs Private component
coverage_component = !(public_saaq, private)

{@quebec_auto_coverage}

; SAAQ Public Coverage (bodily injury - no private BI coverage sold in QC)
{@quebec_saaq_coverage}
= @quebec_auto_coverage

coverage_type_ref = "QC_SAAQ"
coverage_component = "public_saaq"
category = "accident_benefits"

; SAAQ income replacement
{.income_replacement}
percent_net_income = #:(0..100)                  ; % of net income
maximum_insurable_income = #$                    ; YMPE-based cap
waiting_period_days = ##:(0..7)

{@quebec_saaq_coverage}

; SAAQ lump sum indemnities
{.lump_sum}
permanent_impairment = ?
death_benefit = ?
funeral_expenses = ?

{@quebec_saaq_coverage}

; SAAQ rehabilitation
{.rehabilitation}
physical = ?
social = ?
vocational = ?

{@quebec_saaq_coverage}

; Quebec Private Coverage (liability and property only)
{@quebec_private_coverage}
= @quebec_auto_coverage

coverage_component = "private"

; Civil liability (property damage only - no BI in QC private market)
{.civil_liability}
property_damage = #$                             ; Third party PD only
no_bi_available = ?                              ; BI not sold privately in QC

{@quebec_private_coverage}

; Collision / All perils
collision_deductible = #$
all_perils_deductible = #$

; ───────────────────────────────────────────────────────────────────────────────
; Government Auto Insurance (BC, MB, SK)
; ───────────────────────────────────────────────────────────────────────────────
; Provinces with government-run basic auto insurance and optional private

{@government_auto_coverage}
= @auto_coverage

; Which government insurer
government_insurer = !(
    ICBC,                                        ; Insurance Corporation of British Columbia
    MPI,                                         ; Manitoba Public Insurance
    SGI                                          ; Saskatchewan Government Insurance
)

; Basic vs Optional
coverage_tier = !(basic, enhanced, optional)

{@government_auto_coverage}

; ICBC (British Columbia)
{@icbc_coverage}
= @government_auto_coverage

government_insurer = "ICBC"
province = "BC"

; Basic Autoplan (mandatory)
{.basic}
third_party_liability = #$                       ; Minimum $200K
underinsured_motorist = #$
accident_benefits = ?
inverse_liability = ?                            ; No-fault for vehicle damage

{@icbc_coverage}

; Enhanced Care (post-2021 no-fault benefits)
{.enhanced_care}
income_replacement_percent = #:(0..100)
income_replacement_max = #$
medical_rehab = ?                                ; Unlimited for life
attendant_care = ?                               ; Based on need
death_benefit = #$
funeral_benefit = #$

{@icbc_coverage}

; Optional ICBC Coverage
{.optional}
extended_third_party = #$                        ; Beyond basic $200K
collision = ?
comprehensive = ?
specified_perils = ?
excess_underinsured = #$
rental = ?
roadside = ?

{@icbc_coverage}

; Personal Optional Protection (POP)
{.pop}
loss_of_use = ?
new_vehicle_replacement = ?
limited_depreciation = ?

{@icbc_coverage}

; MPI (Manitoba)
{@mpi_coverage}
= @government_auto_coverage

government_insurer = "MPI"
province = "MB"

; Autopac Basic (mandatory)
{.basic}
third_party_liability = #$                       ; Minimum $200K
pipp = ?                                         ; Personal Injury Protection Plan
all_perils = ?                                   ; Included in basic

{@mpi_coverage}

; PIPP Benefits (no-fault)
{.pipp}
income_replacement_percent = #:(0..100)
income_replacement_max = #$
medical_expenses = ?                             ; 100% covered
rehabilitation = ?
permanent_impairment = ?
death_benefit = #$
funeral_benefit = #$

{@mpi_coverage}

; Extension Coverage (optional)
{.extension}
extended_liability = #$                          ; Beyond basic $200K
extended_deductible = #$
loss_of_use = ?
rental_vehicle = ?
new_vehicle_protection = ?

{@mpi_coverage}

; SGI (Saskatchewan)
{@sgi_coverage}
= @government_auto_coverage

government_insurer = "SGI"
province = "SK"

; Auto Fund (mandatory no-fault)
{.basic}
third_party_liability = #$                       ; Minimum $200K
pipp = ?                                         ; Personal Injury Protection Plan
comprehensive = ?                                ; Included in basic

{@sgi_coverage}

; PIPP Benefits (no-fault)
{.pipp}
income_replacement_percent = #:(0..100)
income_replacement_max = #$
medical_expenses = ?
rehabilitation = ?
permanent_impairment = ?
death_benefit = #$
funeral_benefit = #$

{@sgi_coverage}

; Extension Package (optional from SGI or private)
{.extension}
extended_liability = #$
collision_deductible = #$
comprehensive_deductible = #$
loss_of_use = ?
rental_reimbursement = ?

{@sgi_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Atlantic Provinces (NB, NS, PEI, NL)
; ───────────────────────────────────────────────────────────────────────────────
; Private market with standard Section B accident benefits

{@atlantic_auto_coverage}
= @auto_coverage

province = (NB, NL, NS, PE)

; Section B - Accident Benefits
{.section_b}
medical_payments = #$
funeral_benefits = #$
death_benefits = #$
income_replacement_weekly = #$
income_replacement_duration = (104_weeks, variable)

{@atlantic_auto_coverage}

; Section C - Uninsured/Underinsured (SEF 44)
{.uninsured}
sef_44 = ?                                       ; Family Protection Endorsement
sef_44_limit = #$:if sef_44 = true

{@atlantic_auto_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Alberta Auto
; ───────────────────────────────────────────────────────────────────────────────
; Private market with Section B and grid-based rating reform

{@alberta_auto_coverage}
= @auto_coverage

province = "AB"

; Section B - Accident Benefits (Alberta-specific limits)
{.section_b}
medical_payments = #$
funeral_benefits = #$
death_benefits = #$
total_disability_weekly = #$
total_disability_duration = (104_weeks, variable)

{@alberta_auto_coverage}

; SEF 44 - Family Protection
{.sef_44}
selected = ?
limit = #$:if selected = true

{@alberta_auto_coverage}

; Direct Compensation available
dcpd_available = ?                               ; AB has optional DCPD


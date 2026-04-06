; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Commercial Auto Coverage Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Commercial auto coverages extending base auto coverage with truckers liability,
; motor truck cargo, hired and non-owned auto, trailer interchange, bobtail/non-trucking
; liability, and commercial physical damage.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/auto/coverage.schema.odin" as auto

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.auto.coverage"
version = "1.0.0"
title = "Commercial Auto Coverage Schema"
description = "Commercial coverage definitions extending base auto coverage"

{$derivation}
source[0].authority = "Federal Motor Carrier Safety Administration"
source[0].citation = "49 CFR Part 387 - Minimum Levels of Financial Responsibility"
source[0].url = "https://www.ecfr.gov/current/title-49/subtitle-B/chapter-III/subchapter-B/part-387"

source[1].authority = "U.S. Department of Transportation"
source[1].citation = "Motor Carrier Insurance Requirements"
source[1].url = "https://www.fmcsa.dot.gov/registration/insurance-requirements"

source[2].authority = "National Association of Insurance Commissioners (NAIC)"
source[2].citation = "Commercial Auto Insurance Model Laws"
source[2].url = "https://content.naic.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "FMCSA insurance requirements; commercial auto coverage structures"

changelog[0].date = 2025-12-13
changelog[0].change = "Initial commercial coverage schema"
changelog[0].rationale = "DOT/FMCSA insurance requirements for commercial motor carriers"

; ═══════════════════════════════════════════════════════════════════════════════
; Commercial Coverage Codes (Extension of Base)
; ═══════════════════════════════════════════════════════════════════════════════
; Commercial-specific coverage codes use cv-COM prefix

; ═══════════════════════════════════════════════════════════════════════════════
; Commercial Liability Coverage
; ═══════════════════════════════════════════════════════════════════════════════
; Primary liability for commercial motor carriers per FMCSA requirements

{@commercial_liability}
= @auto.liability_coverage                    ; Inherit base liability structure

coverage_id = :

; ───────────────────────────────────────────────────────────────────────────────
; FMCSA Minimum Requirements (49 CFR 387.9)
; ───────────────────────────────────────────────────────────────────────────────
{.fmcsa}
applies = ?                                    ; Subject to FMCSA insurance requirements
commodity_class = (
    hazmat_class_a_b_explosives,               ; Explosives A&B
    hazmat_general,                            ; Hazmat (general)
    hazmat_oil,                                ; Oil (hazmat)
    hazmat_radioactive,                        ; Radioactive materials
    non_hazmat                                 ; Non-hazardous freight
)

; Minimum limits per FMCSA commodity class
meets_minimum = ?
minimum_liability = ##            ; Required minimum per class

{@commercial_liability}
; ───────────────────────────────────────────────────────────────────────────────
; MCS-90 Endorsement (Motor Carrier Act Endorsement)
; ───────────────────────────────────────────────────────────────────────────────
; Required endorsement for interstate for-hire motor carriers
{.mcs90}
attached = ?
effective_date = date
filing_date = date
filing_status = (filed, pending, rejected)

{@commercial_liability}

; ───────────────────────────────────────────────────────────────────────────────
; Limits
; ───────────────────────────────────────────────────────────────────────────────
; Split limits
{.bi}
per_accident = ##                              ; Bodily injury per accident
per_person = ##                                ; Bodily injury per person

{@commercial_liability}
{.pd}
limit = ##                                     ; Property damage limit

{@commercial_liability}
; Combined Single Limit (more common in trucking)
{.csl}
limit = ##                                     ; Combined single limit
used = ?                                       ; CSL used instead of split limits

{@commercial_liability}
; Common trucking liability limits
; $750,000 - Under 10,001 lbs non-hazmat
; $1,000,000 - 10,001+ lbs non-hazmat for-hire
; $5,000,000 - Hazmat general
limit_tier = (1000000, 2000000, 5000000, 750000, other)

; ───────────────────────────────────────────────────────────────────────────────
; Symbol Classifications
; ───────────────────────────────────────────────────────────────────────────────
; Commercial auto symbols 1-9
{.symbol}
description = :
number = ##
; 1 = Any Auto
; 2 = Owned Autos Only
; 3 = Owned Private Passenger Autos Only
; 4 = Owned Autos Other Than Private Passenger
; 5 = Owned Autos Subject to No-Fault
; 6 = Owned Autos Subject to Compulsory UM
; 7 = Specifically Described Autos
; 8 = Hired Autos Only
; 9 = Non-Owned Autos Only

{@commercial_liability}
; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
bi = #$:(0..)                                  ; Bodily injury premium
pd = #$:(0..)                                  ; Property damage premium
total = #$:(0..)                               ; Total liability premium

{@commercial_liability}

; ═══════════════════════════════════════════════════════════════════════════════
; Motor Truck Cargo Coverage
; ═══════════════════════════════════════════════════════════════════════════════
; Covers damage to freight/cargo being transported

{@cargo_coverage}
coverage_id = :
coverage_code = "cv-COM-CARGO"
coverage_form = !(
    all_risk,                                  ; Comprehensive cargo
    broad_form,                                ; All-risk
    legal_liability,                           ; Liability for carrier negligence
    named_perils                               ; Specified perils only
)

selected = ?

; ───────────────────────────────────────────────────────────────────────────────
; Cargo Coverage Type
; ───────────────────────────────────────────────────────────────────────────────

; ───────────────────────────────────────────────────────────────────────────────
; Limits
; ───────────────────────────────────────────────────────────────────────────────
{.limit}
= @coverage_limit                              ; Use shared coverage limit type
aggregate = ##                                 ; Aggregate limit
per_occurrence = ##                            ; Per occurrence limit
per_vehicle = ##                               ; Per vehicle limit

{@cargo_coverage}
{.deductible}
= @deductible                                  ; Use shared deductible type

{@cargo_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Commodity Classes Covered
; ───────────────────────────────────────────────────────────────────────────────
commodities_covered[] = (
    autos_new,
    autos_used,
    building_materials,
    dry_bulk,
    electronics,
    general_freight,
    hazmat,
    high_value,
    household_goods,
    liquid_bulk,
    livestock,
    machinery,
    other,
    pharmaceuticals,
    produce,
    refrigerated
)
commodity_restrictions = :                        ; Specific exclusions

; ───────────────────────────────────────────────────────────────────────────────
; Valuation
; ───────────────────────────────────────────────────────────────────────────────
maximum_value_per_pound = #$:(0..)             ; Maximum value per pound
released_value = #$:(0..)                      ; Carrier's limitation of liability
valuation_basis = (actual_cash_value, agreed_value, invoice_value, replacement_cost)

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Extensions
; ───────────────────────────────────────────────────────────────────────────────
loading_unloading = ?                          ; Loading/unloading covered

{.extra_expense}
included = ?                                   ; Extra expense included
limit = ##                                     ; Extra expense limit

{@cargo_coverage}
{.debris_removal}
included = ?                                   ; Debris removal included
limit = ##                                     ; Debris removal limit

{@cargo_coverage}
{.sue_and_labor}
included = ?                                   ; Sue and labor included
limit = ##                                     ; Sue and labor limit

{@cargo_coverage}
{.earned_freight}
included = ?                                   ; Earned freight included
limit = ##                                     ; Earned freight limit

{@cargo_coverage}
; ───────────────────────────────────────────────────────────────────────────────
; Refrigeration Coverage (Reefer Breakdown)
; ───────────────────────────────────────────────────────────────────────────────
{.reefer}
breakdown = ?                                  ; Breakdown covered
contamination = ?                              ; Contamination covered
deductible = ##                                ; Reefer deductible
limit = ##                                     ; Reefer coverage limit
mechanical_breakdown = ?                       ; Mechanical breakdown covered

{@cargo_coverage}
; ───────────────────────────────────────────────────────────────────────────────
; Territory
; ───────────────────────────────────────────────────────────────────────────────
excluded_states[] = :(2)
territory = (us_canada, us_canada_mexico, us_only, worldwide)

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
amount = #$:(0..)                              ; Premium amount
minimum = #$:(0..)                             ; Minimum premium
rate_per_100 = #$:(0..)                        ; Rate per $100 of cargo value

{@cargo_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Hired Auto Liability Coverage
; ═══════════════════════════════════════════════════════════════════════════════
; Covers vehicles rented or leased for short periods

{@hired_auto_coverage}
coverage_id = :
coverage_code = "cv-COM-HIRED"
symbol = ##                               ; Symbol 8 = Hired Autos Only

selected = ?

; ───────────────────────────────────────────────────────────────────────────────
; Hired Auto Definition
; ───────────────────────────────────────────────────────────────────────────────
hired_auto_type = (
    all_hired,                                 ; All hired vehicles
    short_term_only,                           ; < 30 days
    specific_contracts                         ; Only under named contracts
)

; ───────────────────────────────────────────────────────────────────────────────
; Limits
; ───────────────────────────────────────────────────────────────────────────────
{.bi}
per_accident = ##                              ; Bodily injury per accident
per_person = ##                                ; Bodily injury per person

{@hired_auto_coverage}
{.pd}
limit = ##                                     ; Property damage limit

{@hired_auto_coverage}
{.csl}
limit = ##                                     ; Combined single limit
used = ?                                       ; CSL used

{@hired_auto_coverage}
; ───────────────────────────────────────────────────────────────────────────────
; Physical Damage on Hired Autos
; ───────────────────────────────────────────────────────────────────────────────
{.physical_damage}
coll_deductible = ##                           ; Collision deductible
comp_deductible = ##                           ; Comprehensive deductible
included = ?                                   ; Physical damage included
limit = ##                                     ; Physical damage limit

{@hired_auto_coverage}
; ───────────────────────────────────────────────────────────────────────────────
; Premium Basis
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
amount = #$:(0..)                              ; Premium amount
annual_cost = #$:(0..)                         ; Annual cost of hired autos
basis = (cost, days, flat)                     ; Premium basis type
estimated_days = ##                            ; Estimated hired auto days
rate_per_day = #$:(0..)                        ; Rate per day

{@hired_auto_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Non-Owned Auto Liability Coverage
; ═══════════════════════════════════════════════════════════════════════════════
; Covers employee-owned vehicles used for business

{@non_owned_auto_coverage}
coverage_id = :
coverage_code = "cv-COM-NONOWNED"
symbol = ##                               ; Symbol 9 = Non-Owned Autos Only

selected = ?

; ───────────────────────────────────────────────────────────────────────────────
; Limits
; ───────────────────────────────────────────────────────────────────────────────
{.bi}
per_accident = ##                              ; Bodily injury per accident
per_person = ##                                ; Bodily injury per person

{@non_owned_auto_coverage}
{.pd}
limit = ##                                     ; Property damage limit

{@non_owned_auto_coverage}
{.csl}
limit = ##                                     ; Combined single limit
used = ?                                       ; CSL used

{@non_owned_auto_coverage}
; ───────────────────────────────────────────────────────────────────────────────
; Employee Base
; ───────────────────────────────────────────────────────────────────────────────
employee_count = ##                            ; Total employee count
employee_auto_count = ##                       ; Employees using autos
percent_using_autos = ##:(0..100)              ; Percentage (0-100)

; ───────────────────────────────────────────────────────────────────────────────
; Extensions
; ───────────────────────────────────────────────────────────────────────────────
independent_contractors = ?                    ; Independent contractors included
volunteers = ?                                 ; Volunteers included

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
amount = #$:(0..)                              ; Premium amount
basis = (employees, flat, percentage)          ; Premium basis
rate_per_employee = #$:(0..)                   ; Rate per employee

{@non_owned_auto_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Trailer Interchange Coverage
; ═══════════════════════════════════════════════════════════════════════════════
; Covers trailers in possession under interchange agreement

{@trailer_interchange_coverage}
coverage_id = :
coverage_code = "cv-COM-INTERCHANGE"
coverage_form = (
    broad_form,                                ; All risks
    legal_liability,                           ; Negligence only
    specified_perils                           ; Named perils only
)

selected = ?

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Type
; ───────────────────────────────────────────────────────────────────────────────

; ───────────────────────────────────────────────────────────────────────────────
; Limits
; ───────────────────────────────────────────────────────────────────────────────
{.limit}
aggregate = ##                                 ; Aggregate limit
per_trailer = ##                               ; Per trailer limit

{@trailer_interchange_coverage}
deductible = ##                                ; Deductible amount

; ───────────────────────────────────────────────────────────────────────────────
; Interchange Partners
; ───────────────────────────────────────────────────────────────────────────────
max_trailer_count = ##                         ; Maximum trailers interchanged
trailer_types_covered[] = (chassis, dry_van, flatbed, other, reefer, tanker)

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
amount = #$:(0..)                              ; Premium amount
basis = (flat, trailer_count)                  ; Premium basis
rate_per_trailer = #$:(0..)                    ; Rate per trailer

{@trailer_interchange_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Bobtail / Non-Trucking Liability
; ═══════════════════════════════════════════════════════════════════════════════
; Covers tractor when not pulling trailer for motor carrier

{@bobtail_coverage}
coverage_id = :
coverage_code = "cv-COM-BOBTAIL"
coverage_type = (
    bobtail,                                   ; Power unit only, no trailer
    deadhead,                                  ; Returning empty
    non_trucking                               ; Personal use when not under dispatch
)

selected = ?

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Type
; ───────────────────────────────────────────────────────────────────────────────

; ───────────────────────────────────────────────────────────────────────────────
; When Coverage Applies
; ───────────────────────────────────────────────────────────────────────────────
applies_when = (
    any_non_business,                          ; Any non-business use
    not_under_dispatch,                        ; Not under motor carrier dispatch
    personal_use,                              ; Personal use only
    returning_home                             ; Deadheading home
)

; ───────────────────────────────────────────────────────────────────────────────
; Limits
; ───────────────────────────────────────────────────────────────────────────────
{.bi}
per_accident = ##                              ; Bodily injury per accident
per_person = ##                                ; Bodily injury per person

{@bobtail_coverage}
{.pd}
limit = ##                                     ; Property damage limit

{@bobtail_coverage}
{.csl}
limit = ##                                     ; Combined single limit
used = ?                                       ; CSL used

{@bobtail_coverage}
; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
amount = #$:(0..)                              ; Premium amount

{@bobtail_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Commercial Physical Damage Coverage
; ═══════════════════════════════════════════════════════════════════════════════
; Physical damage for commercial vehicles (higher values, specialized options)

{@commercial_physical_damage}
coverage_id = :
vehicle_number = ##

; ───────────────────────────────────────────────────────────────────────────────
; Comprehensive
; ───────────────────────────────────────────────────────────────────────────────
{.comp}
avc = #$:(0..)                                 ; Actual Cash Value
deductible = ##                                ; Comprehensive deductible
deductible_type = (disappearing, percentage, standard)
premium = #$:(0..)                             ; Comprehensive premium
selected = ?                                   ; Comprehensive selected
symbol = :                                     ; Rating symbol

{@commercial_physical_damage}
; ───────────────────────────────────────────────────────────────────────────────
; Collision
; ───────────────────────────────────────────────────────────────────────────────
{.coll}
broad_form = ?                                 ; Broad form collision
deductible = ##                                ; Collision deductible
deductible_type = (disappearing, percentage, standard)
premium = #$:(0..)                             ; Collision premium
selected = ?                                   ; Collision selected
symbol = :                                     ; Rating symbol

{@commercial_physical_damage}
; ───────────────────────────────────────────────────────────────────────────────
; Specified Perils (Alternative to Comp)
; ───────────────────────────────────────────────────────────────────────────────
{.specified_perils}
deductible = ##                                ; Specified perils deductible
perils_covered[] = (earthquake, fire, flood, glass, theft, vandalism, windstorm)
premium = #$:(0..)                             ; Specified perils premium
selected = ?                                   ; Specified perils selected

{@commercial_physical_damage}
; ───────────────────────────────────────────────────────────────────────────────
; Stated Amount / Agreed Value
; ───────────────────────────────────────────────────────────────────────────────
agreed_value = #$:(0..)                        ; Agreed value amount
stated_amount = #$:(0..)                       ; Stated amount
valuation_type = (actual_cash_value, agreed_value, replacement_cost, stated_amount)

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Extensions
; ───────────────────────────────────────────────────────────────────────────────
; Electronic Equipment
{.electronic_equipment}
covered = ?                                    ; Electronic equipment covered
deductible = ##                                ; Electronic equipment deductible
limit = ##                                     ; Electronic equipment limit

{@commercial_physical_damage}
; Permanently Attached Equipment
{.attached_equipment}
covered = ?                                    ; Attached equipment covered
limit = ##                                     ; Attached equipment limit
schedule_required = ?                          ; Schedule required

{@commercial_physical_damage}
; Refrigeration Unit
{.reefer_unit}
covered = ?                                    ; Reefer unit covered
mechanical_breakdown = ?                       ; Mechanical breakdown covered
value = #$:(0..)                               ; Reefer unit value

{@commercial_physical_damage}
; ───────────────────────────────────────────────────────────────────────────────
; Total Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
total = #$:(0..)                               ; Total physical damage premium

{@commercial_physical_damage}

; ═══════════════════════════════════════════════════════════════════════════════
; Downtime / Loss of Use Coverage
; ═══════════════════════════════════════════════════════════════════════════════
; Covers lost income when vehicle is out of service

{@downtime_coverage}
coverage_id = :
coverage_code = "cv-COM-DOWNTIME"
coverage_type = (
    actual_loss,                               ; Actual documented loss
    daily_limit,                               ; Fixed daily amount
    rental_substitute                          ; Cost to rent replacement
)

selected = ?

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Type
; ───────────────────────────────────────────────────────────────────────────────

; ───────────────────────────────────────────────────────────────────────────────
; Limits
; ───────────────────────────────────────────────────────────────────────────────
daily_limit = ##                               ; Daily limit amount
max_days = ##                         ; Maximum days of downtime coverage
max_total = ##                                 ; Maximum total amount
waiting_period_days = ##               ; Waiting period before coverage begins

; ───────────────────────────────────────────────────────────────────────────────
; Covered Causes
; ───────────────────────────────────────────────────────────────────────────────
covered_for = (all_causes, collision_only, comp_and_coll, specified_causes)
mechanical_breakdown_included = ?

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
amount = #$:(0..)                              ; Premium amount

{@downtime_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Pollution Liability Coverage
; ═══════════════════════════════════════════════════════════════════════════════
; Covers pollution events from cargo or vehicle

{@pollution_coverage}
coverage_id = :
coverage_code = "cv-COM-POLLUTION"
coverage_form = (
    broad_form,                                ; Includes gradual
    mcs90_only,                                ; Only as required by MCS-90
    sudden_accidental                          ; Sudden/accidental only
)

selected = ?

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Type
; ───────────────────────────────────────────────────────────────────────────────

; ───────────────────────────────────────────────────────────────────────────────
; Limits
; ───────────────────────────────────────────────────────────────────────────────
{.limit}
aggregate = ##                                 ; Aggregate limit
per_occurrence = ##                            ; Per occurrence limit

{@pollution_coverage}
deductible = ##                                ; Deductible amount

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Components
; ───────────────────────────────────────────────────────────────────────────────
cleanup_costs = ?
defense_costs = (inside_limits, outside_limits)
third_party_bodily_injury = ?
third_party_property_damage = ?
transportation_expense = ?

; ───────────────────────────────────────────────────────────────────────────────
; Commodities (required for hazmat haulers)
; ───────────────────────────────────────────────────────────────────────────────
commodities_covered[] = (chemicals, hazmat_general, other, petroleum, waste)

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
amount = #$:(0..)                              ; Premium amount

{@pollution_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Occupational Accident Coverage
; ═══════════════════════════════════════════════════════════════════════════════
; Accident insurance for owner-operators (not workers comp)

{@occupational_accident}
coverage_id = :
coverage_code = "cv-COM-OCCACC"
covers = (all, independent_contractors, leased_drivers, owner_operators)

selected = ?

; ───────────────────────────────────────────────────────────────────────────────
; Covered Persons
; ───────────────────────────────────────────────────────────────────────────────
covered_count = ##                             ; Number of covered persons

; ───────────────────────────────────────────────────────────────────────────────
; Benefits
; ───────────────────────────────────────────────────────────────────────────────
{.accidental_death}
limit = ##                                     ; Accidental death limit

{@occupational_accident}
{.accidental_dismemberment}
limit = ##                                     ; Dismemberment limit

{@occupational_accident}
{.accident_medical}
deductible = ##                                ; Medical deductible
limit = ##                                     ; Medical limit

{@occupational_accident}
; Disability Benefits
{.temporary_disability}
max_weeks = ##                        ; Maximum weeks of disability benefit
waiting_period_days = ##               ; Days before disability benefit begins
weekly_benefit = ##                            ; Weekly benefit amount

{@occupational_accident}
{.permanent_disability}
lump_sum = ##                                  ; Lump sum amount

{@occupational_accident}
; Survivors Benefit
{.survivors_benefit}
included = ?                                   ; Survivors benefit included
limit = ##                                     ; Survivors benefit limit

{@occupational_accident}
; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
per_person = #$:(0..)                          ; Premium per person
total = #$:(0..)                               ; Total premium

{@occupational_accident}

; ═══════════════════════════════════════════════════════════════════════════════
; General Liability Extension
; ═══════════════════════════════════════════════════════════════════════════════
; GL coverage triggered by trucking operations

{@gl_extension}
coverage_id = :
coverage_code = "cv-COM-GL"

selected = ?
care_custody_control = ?
loading_unloading = ?

; ───────────────────────────────────────────────────────────────────────────────
; Loading/Unloading Coverage
; ───────────────────────────────────────────────────────────────────────────────

; ───────────────────────────────────────────────────────────────────────────────
; Limits
; ───────────────────────────────────────────────────────────────────────────────
{.limit}
aggregate = ##                                 ; Aggregate limit
per_occurrence = ##                            ; Per occurrence limit

{@gl_extension}
deductible = ##                                ; Deductible amount

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
amount = #$:(0..)                              ; Premium amount

{@gl_extension}

; ═══════════════════════════════════════════════════════════════════════════════
; Commercial Uninsured/Underinsured Motorist
; ═══════════════════════════════════════════════════════════════════════════════
; UM/UIM for commercial operations

{@commercial_um_coverage}
= @auto.um_coverage                           ; Inherit base UM structure

coverage_id = :

; ───────────────────────────────────────────────────────────────────────────────
; Commercial-Specific Options
; ───────────────────────────────────────────────────────────────────────────────
applies_to = (all_vehicles, power_units_only, scheduled_vehicles)

; Higher limits common in commercial
{.um}
bi_per_accident = ##                           ; BI per accident
bi_per_person = ##                             ; BI per person

{@commercial_um_coverage}
; ───────────────────────────────────────────────────────────────────────────────
; Deductible (common in commercial UM)
; ───────────────────────────────────────────────────────────────────────────────
deductible = ##                                ; Deductible amount

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
total = #$:(0..)                               ; Total premium
uim = #$:(0..)                                 ; UIM premium
um = #$:(0..)                                  ; UM premium

{@commercial_um_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Commercial Coverage Premium Summary
; ═══════════════════════════════════════════════════════════════════════════════

{@commercial_coverage_summary}
; Liability
liability_premium = #$:(0..)                   ; Liability premium
cargo_premium = #$:(0..)                       ; Cargo premium
hired_auto_premium = #$:(0..)                  ; Hired auto premium
non_owned_premium = #$:(0..)                   ; Non-owned premium

; Physical Damage
physical_damage_premium = #$:(0..)             ; Physical damage premium
trailer_interchange_premium = #$:(0..)         ; Trailer interchange premium

; Specialty
bobtail_premium = #$:(0..)                     ; Bobtail premium
pollution_premium = #$:(0..)                   ; Pollution premium
downtime_premium = #$:(0..)                    ; Downtime premium
occupational_accident_premium = #$:(0..)       ; Occupational accident premium
gl_extension_premium = #$:(0..)                ; GL extension premium

; UM/UIM
um_uim_premium = #$:(0..)                      ; UM/UIM premium

; Totals
coverage_premium_total = #$:(0..)              ; Total coverage premium
taxes_fees = #$:(0..)                          ; Taxes and fees
grand_total = #$:(0..)                         ; Grand total premium

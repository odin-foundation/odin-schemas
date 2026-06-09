; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Personal Auto Insurance Coverage Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Personal auto coverage definitions extending the universal coverage primitive
; with state-specific extensions, building on the line-level auto coverage schema
; for liability, UM/UIM, PIP, and physical damage.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../coverages/coverage.schema.odin" as cov
@import "../../coverages/lines/auto.schema.odin" as auto

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.auto.coverage"
version = "2.0.0"
title = "Personal Auto Insurance Coverage Schema"
description = "Personal auto coverage definitions extending universal coverage primitive"

{$derivation}
source[0].authority = "Texas Department of Insurance"
source[0].citation = "TX Insurance Code § 1952.101 - UM/UIM Coverage Required"
source[0].url = "https://statutes.capitol.texas.gov/docs/in/htm/in.1952.htm"

source[1].authority = "New York Department of Financial Services"
source[1].citation = "NY Insurance Law Article 23, § 2303/2304"
source[1].url = "https://www.nysenate.gov/legislation/laws/ISC/2303"

source[2].authority = "Florida Office of Insurance Regulation"
source[2].citation = "FL Statutes § 627.0651, § 627.7295"
source[2].url = "https://www.leg.state.fl.us/statutes/index.cfm?App_mode=Display_Statute&URL=0600-0699/0627/Sections/0627.0651.html"

source[3].authority = "California Department of Insurance"
source[3].citation = "CA Insurance Code § 11580.2 (UM/UIM)"
source[3].url = "https://www.insurance.ca.gov/0250-insurers/0800-rate-filings/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Personal auto coverage extending universal coverage primitive with state-specific extensions"

changelog[0].date = 2025-12-14
changelog[0].change = "Refactored to extend universal coverage primitive"
changelog[0].rationale = "Coverage-centric architecture - extend @auto_coverage from coverage/lines/auto.schema.odin"

changelog[1].date = 2025-12-13
changelog[1].change = "Initial coverage schema"
changelog[1].rationale = "Standard auto insurance coverage structures with state-specific regulatory sections"

; ═══════════════════════════════════════════════════════════════════════════════
; Coverage Codes (Human Readable)
; ═══════════════════════════════════════════════════════════════════════════════
; Coverage codes use a prefix pattern for clarity:
;   cv- = coverage type prefix
;   BI  = Bodily Injury
;   PD  = Property Damage
;   UM  = Uninsured Motorist
;   UIM = Underinsured Motorist
;   COMP = Comprehensive
;   COLL = Collision
;   PIP = Personal Injury Protection
;   MED = Medical Payments
; ═══════════════════════════════════════════════════════════════════════════════

; ═══════════════════════════════════════════════════════════════════════════════
; Personal Auto Coverage (Extends @auto_coverage)
; ═══════════════════════════════════════════════════════════════════════════════
; Inherits from @auto_coverage which inherits from @coverage (universal primitive)
; Adds personal auto specific fields and premium calculation details.

{@personal_auto_coverage}
= @auto_coverage                                  ; Inherit from auto line extension

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Type Reference
; ───────────────────────────────────────────────────────────────────────────────
; NOTE: coverage_type_ref from @coverage contains the canonical code (BI, PD, COLL, etc.)
; The coverage_category below provides additional classification for personal auto

coverage_category = (endorsement, liability, no_fault, optional, physical_damage)

; ───────────────────────────────────────────────────────────────────────────────
; Vehicle/Driver Assignment (Personal Auto Specific)
; ───────────────────────────────────────────────────────────────────────────────
vehicle_number = ##:if applies_to = vehicle
driver_number = ##:if applies_to = driver

; ───────────────────────────────────────────────────────────────────────────────
; Waiver Details
; ───────────────────────────────────────────────────────────────────────────────
waived = ?
waived_signature = ?:if waived = true
waived_date = date:if waived = true

; ───────────────────────────────────────────────────────────────────────────────
; Premium Calculation Details (Personal Auto Specific)
; ───────────────────────────────────────────────────────────────────────────────
iteration_number = ##                     ; For multi-iteration coverages
rating_classification = :                   ; Rating classification code
premium_basis_type = (                            ; How premium is calculated
    car_year,
    earned_cars,
    flat,
    miles,
    per_person,
    written_cars
)
minimum_premium = #$:(0..)
pro_rata_factor = #                        ; Pro-rata adjustment factor
net_change_premium = #$                     ; Change from prior term (can be negative)
written_premium = #$:(0..)
current_term_premium = #$:(0..)

; ───────────────────────────────────────────────────────────────────────────────
; Exposure (Personal Auto)
; ───────────────────────────────────────────────────────────────────────────────
{.exposure}
units = #                                   ; Exposure units (car-years, etc.)
basis = (car_years, miles, premium)

{@personal_auto_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Forms
; ───────────────────────────────────────────────────────────────────────────────
form_number = :
form_edition = :
endorsement_number = :

; ═══════════════════════════════════════════════════════════════════════════════
; Personal Auto Liability Coverage (BI/PD)
; ═══════════════════════════════════════════════════════════════════════════════

{@personal_auto_liability}
= @personal_auto_coverage

coverage_type_ref = "BI"                          ; or "PD" or "CSL"
coverage_category = "liability"

; Split limits (BI/PD) - extends universal limits array with convenience fields
{.bi}
per_person = #$:(0..)                             ; Per person BI limit
per_accident = #$:(0..)                           ; Per accident BI limit

{@personal_auto_liability}
{.pd}
limit = #$:(0..)                                  ; Property damage limit

{@personal_auto_liability}
; Or Combined Single Limit
{.csl}
limit = #$:(0..)                                  ; CSL amount
used = ?                                          ; Using CSL instead of split

{@personal_auto_liability}

; Display format: "100/300/100" or "500 CSL"
limit_display = :

; Premium breakdown (component premiums)
{.premium_breakdown}
bi = #$:(0..)
pd = #$:(0..)
total = #$:(0..)

{@personal_auto_liability}

; State/Province reference (informational) - US state or Canadian province
state_province = :(2)

; ═══════════════════════════════════════════════════════════════════════════════
; Personal Auto Uninsured/Underinsured Motorist Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@personal_auto_um}
= @personal_auto_coverage

coverage_type_ref = "UM"                          ; or "UIM"
coverage_category = "liability"

; Selection & Offer/Rejection (required in most states)
{.um_selection}
offered = ?                                       ; Coverage was offered to insured
selected = ?
rejected = ?
rejection_signed = ?                              ; Written rejection obtained
rejection_date = date

{@personal_auto_um}
{.uim_selection}
offered = ?
selected = ?
rejected = ?
rejection_signed = ?
rejection_date = date

; UM Limits
{.um}
bi_per_person = #$:(0..)
bi_per_accident = #$:(0..)
pd_limit = #$:(0..)
pd_deductible = #$:(0..)

{@personal_auto_um}
; UIM Limits
{.uim}
bi_per_person = #$:(0..)
bi_per_accident = #$:(0..)

{@personal_auto_um}

; Stacking (inherits from @auto_coverage.um_uim.stacked)
stacking_factor = ##

; Premium breakdown
{.premium_breakdown}
um = #$:(0..)
uim = #$:(0..)
total = #$:(0..)

{@personal_auto_um}

; ═══════════════════════════════════════════════════════════════════════════════
; Personal Auto PIP Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@personal_auto_pip}
= @personal_auto_coverage

coverage_type_ref = "PIP"
coverage_category = "no_fault"

; Selection & Offer/Rejection
offered = ?
rejected = ?
rejection_signed = ?
rejection_date = date
waived_reason = (health_insurance, medicaid, medicare, other):if waived = true

; Limits - PIP total (components inherit from @auto_coverage.pip)
limit = #$:(0..)                               ; Total PIP limit

; Component limits (varies by state) - extends @auto_coverage.pip structure
{.medical}
limit = #$:(0..)
deductible = #$:(0..)

{@personal_auto_pip}
{.income_loss}
limit = #$:(0..)
percent = ##:(0..100)                          ; % of income covered
waived = ?
exclusion = ?                                  ; Work loss exclusion elected

{@personal_auto_pip}
{.funeral}
limit = #$:(0..)

{@personal_auto_pip}
{.essential_services}
limit = #$:(0..)

{@personal_auto_pip}
{.survivor_loss}
limit = #$:(0..)

{@personal_auto_pip}
; Attendant care (MI specific)
{.attendant_care}
selected = ?
limit = #$:(0..)

{@personal_auto_pip}
; Coordination of benefits
coordinated_with = (excess, none, primary)
health_insurance_carrier = :
health_insurance_type = (employer, individual, medicaid, medicare, other)

; Exclusions
exclude_from_pip[] = ##                ; Driver numbers excluded

; Premium breakdown
{.premium_breakdown}
amount = #$:(0..)
per_person = #$:(0..)

{@personal_auto_pip}

; Michigan specific (post-7/2020)
mi_pip_option = (50000, 250000, 500000, opt_out, unlimited):if state = MI

; Additional/Extended PIP (optional enhanced coverage)
{.additional_pip}
selected = ?
limit = #$:(0..)

{@personal_auto_pip}

; ═══════════════════════════════════════════════════════════════════════════════
; Personal Auto Medical Payments Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@personal_auto_medpay}
= @personal_auto_coverage

coverage_type_ref = "MEDPAY"
coverage_category = "no_fault"

limit = #$:(0..)
expense_type = (any_occupant, household, insured_only)

{@personal_auto_medpay}

; ═══════════════════════════════════════════════════════════════════════════════
; Personal Auto Physical Damage Coverage (Comp/Coll)
; ═══════════════════════════════════════════════════════════════════════════════

{@personal_auto_physical_damage}
= @personal_auto_coverage

coverage_type_ref = "COLL"                        ; or "COMP"
coverage_category = "physical_damage"

; Comprehensive
{.comp}
selected = ?
deductible = #$:(0..)
deductible_type = (disappearing, percentage, standard)
premium = #$:(0..)

{@personal_auto_physical_damage}
; Collision
{.coll}
selected = ?
deductible = #$:(0..)
deductible_type = (disappearing, limited, percentage, standard)
broad_form = ?                                    ; Broad form collision
premium = #$:(0..)

{@personal_auto_physical_damage}

; Deductible waivers
waive_comp_ded_glass = ?                          ; No deductible for glass
waive_coll_ded_uninsured = ?                      ; No deductible if hit by uninsured

; Full glass
{.full_glass}
selected = ?
premium = #$:(0..)

{@personal_auto_physical_damage}
; Specified perils (alternative to comp)
{.specified_perils}
selected = ?
deductible = #$:(0..)
premium = #$:(0..)

{@personal_auto_physical_damage}

; ═══════════════════════════════════════════════════════════════════════════════
; Personal Auto Towing & Roadside Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@personal_auto_towing}
= @personal_auto_coverage

coverage_type_ref = "TOWING"
coverage_category = "optional"

limit = #$:(0..)                                  ; Per occurrence
limit_type = (per_disablement, per_occurrence, unlimited)
includes_roadside = ?
includes_lockout = ?
includes_fuel_delivery = ?
includes_battery_jump = ?
includes_flat_tire = ?

{@personal_auto_towing}

; ═══════════════════════════════════════════════════════════════════════════════
; Personal Auto Rental Reimbursement Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@personal_auto_rental}
= @personal_auto_coverage

coverage_type_ref = "RENTAL"
coverage_category = "optional"

daily_limit = #$:(0..)                            ; Per day amount
max_days = ##                            ; Maximum days
max_total = #$:(0..)                              ; Maximum total amount
waiting_period_days = ##

{@personal_auto_rental}

; ═══════════════════════════════════════════════════════════════════════════════
; Personal Auto Gap Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@personal_auto_gap}
= @personal_auto_coverage

coverage_type_ref = "GAP"
coverage_category = "optional"

gap_type = (loan_lease, new_car_replacement, standard)
max_gap_percent = ##:(0..200)                     ; Max % over ACV
max_gap_amount = #$:(0..)                         ; Max $ amount
includes_deductible = ?                           ; Pays deductible too

{@personal_auto_gap}

; ═══════════════════════════════════════════════════════════════════════════════
; Personal Auto Custom Equipment Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@personal_auto_custom_equipment}
= @personal_auto_coverage

coverage_type_ref = "CUSTOM"
coverage_category = "optional"

limit = #$:(0..)
description = :
equipment_types = :                        ; Comma-separated list

{@personal_auto_custom_equipment}

; ═══════════════════════════════════════════════════════════════════════════════
; Personal Auto Rideshare Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@personal_auto_rideshare}
= @personal_auto_coverage

coverage_type_ref = "RIDESHARE"
coverage_category = "endorsement"

rideshare_company = :                      ; Uber, Lyft, etc.
coverage_periods = (all, period_1, period_2, period_3)
; Period 1 = App on, waiting for ride
; Period 2 = Matched, en route to pickup
; Period 3 = Passenger in vehicle

{@personal_auto_rideshare}

; ═══════════════════════════════════════════════════════════════════════════════
; Personal Auto Coverage Package (Pre-configured Bundle)
; ═══════════════════════════════════════════════════════════════════════════════

{@personal_auto_package}
package_id = :
package_name = :
package_type = (
    basic,
    custom,
    full_coverage,
    liability_only,
    premium,
    standard
)
description = :

; Included coverages (by coverage_type_ref code)
included_coverages[] = :

; Package level defaults
liability_level = (high, low, maximum, medium, state_minimum)
deductible_level = (high, low, medium, waived)

; ═══════════════════════════════════════════════════════════════════════════════
; Personal Auto Available Limits/Deductibles (for quoting)
; ═══════════════════════════════════════════════════════════════════════════════

{@personal_auto_available_limits[]}
coverage_type_ref = :                       ; References @coverage_type.code
limit_value = #$:(0..)
limit_display = :
limit_applies_to = (combined, per_accident, per_occurrence, per_person)
recommended = ?

{@personal_auto_available_deductibles[]}
coverage_type_ref = :                       ; References @coverage_type.code
deductible_value = #$:(0..)
deductible_display = :
deductible_type = (disappearing, percentage, standard)
default = ?

; ═══════════════════════════════════════════════════════════════════════════════
; Personal Auto Premium Summary
; ═══════════════════════════════════════════════════════════════════════════════

{@personal_auto_premium_summary}
; Liability
liability_bi_premium = #$:(0..)
liability_pd_premium = #$:(0..)
liability_total = #$:(0..)

; UM/UIM
um_premium = #$:(0..)
uim_premium = #$:(0..)

; PIP/Med Pay
pip_premium = #$:(0..)
med_pay_premium = #$:(0..)

; Physical Damage (per vehicle totals)
comp_premium_total = #$:(0..)
coll_premium_total = #$:(0..)

; Optional coverages
towing_premium_total = #$:(0..)
rental_premium_total = #$:(0..)
other_premium_total = #$:(0..)

; Grand total
coverage_premium_total = #$:(0..)

; ═══════════════════════════════════════════════════════════════════════════════
; Personal Auto Coverage Adjustments (Credits & Surcharges)
; ═══════════════════════════════════════════════════════════════════════════════

{@personal_auto_adjustment}
adjustment_id = :
type = (credit, surcharge)
code = :                                    ; Adjustment code
description = :
amount = #$:(0..)                                 ; Positive value (credits or surcharges)
percent = #
applies_to_coverage_type_ref = :            ; Coverage type ref affected
effective_date = date
expiration_date = date
reason = :

; ═══════════════════════════════════════════════════════════════════════════════
; STATE-SPECIFIC: New York Department of Financial Services
; ═══════════════════════════════════════════════════════════════════════════════
; Per NY Insurance Law Article 51 (No-Fault)
; https://www.nysenate.gov/legislation/laws/ISC/A51
; Note: Most NY fields map to main spec. OBEL = pip.limit, APIP = additional_pip,
;       SUM = um_coverage. These aliases exist for NY-specific terminology.

{@&gov.ny.dfs.coverage}
; NY-specific terminology aliases (maps to main spec fields)
obel_selected = ?                             ; = pip.selected (Basic Economic Loss)
apip_selected = ?                             ; = additional_pip.selected
sum_selected = ?                              ; = um_selected (Supplementary UM/UIM)

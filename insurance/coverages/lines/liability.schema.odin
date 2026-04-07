; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Liability Coverage Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Liability coverage line extension of the universal coverage primitive adding
; CGL-specific fields for occurrence/claims-made triggers, retroactive dates,
; and aggregate tracking.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../coverage.schema.odin" as cov
@import "../limits.schema.odin" as limits

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.coverages.lines.liability"
version = "1.0.0"
title = "Liability Coverage Schema"
description = "General liability coverage extending universal coverage primitive"

{$derivation}
source[0].authority = "U.S. Department of Labor"
source[0].citation = "Occupational Safety and Health Administration"
source[0].url = "https://www.osha.gov/"

source[1].authority = "National Association of Insurance Commissioners (NAIC)"
source[1].citation = "Liability Insurance Model Laws and Regulations"
source[1].url = "https://content.naic.org/"

source[2].authority = "State Insurance Departments"
source[2].citation = "Various state liability insurance regulations"
source[2].url = "https://content.naic.org/state-insurance-departments"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "General liability coverage line extension"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial liability coverage schema"
changelog[0].rationale = "Coverage-centric architecture - liability line extension"

; ═══════════════════════════════════════════════════════════════════════════════
; Liability Coverage (Extends Universal Coverage)
; ═══════════════════════════════════════════════════════════════════════════════

{@liability_coverage}
= @coverage                                       ; Inherit all universal coverage fields

; ───────────────────────────────────────────────────────────────────────────────
; Form Type
; ───────────────────────────────────────────────────────────────────────────────
form_type = !(claims_made, occurrence)
form_edition = :                                  ; e.g., "04 13"

; ───────────────────────────────────────────────────────────────────────────────
; Claims-Made Specific
; ───────────────────────────────────────────────────────────────────────────────
retroactive_date = date:if form_type = claims_made
continuity_date = date:if form_type = claims_made ; First uninterrupted claims-made coverage

; Extended reporting period
{.erp}
basic_available = ?:if form_type = claims_made
basic_days = ##:(0..90):if form_type = claims_made
supplemental_available = ?:if form_type = claims_made
supplemental_options[] = (1_year, 2_year, 3_year, 5_year, unlimited):if form_type = claims_made
supplemental_purchased = ?:if form_type = claims_made
supplemental_period = ::if supplemental_purchased = true

{@liability_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Defense Handling
; ───────────────────────────────────────────────────────────────────────────────
defense_handling = (duty_to_defend, reimbursement)
defense_within_limits = ?                         ; Defense costs erode limits
supplemental_payments = ?                         ; Supplemental payments outside limits

; ───────────────────────────────────────────────────────────────────────────────
; CGL Limit Structure
; ───────────────────────────────────────────────────────────────────────────────
{.cgl_limits}
each_occurrence = #$
general_aggregate = #$
products_completed_ops_aggregate = #$
personal_advertising_injury = #$
damage_to_premises = #$
medical_expense = #$

; Aggregate applies
aggregate_per = (location, policy, project)

{@liability_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Territory
; ───────────────────────────────────────────────────────────────────────────────
coverage_territory = (
    specified_countries,
    us_canada,
    us_territories,
    worldwide,
    worldwide_excluding
)
specified_countries[] = :(2):if coverage_territory = specified_countries
excluded_countries[] = :(2):if coverage_territory = worldwide_excluding

; ───────────────────────────────────────────────────────────────────────────────
; Classification
; ───────────────────────────────────────────────────────────────────────────────
{.classification}
class_code = :                                    ; GL class code
class_description = :
exposure_basis = (admissions, area, gross_receipts, other, payroll, sales, units)
exposure_amount = #$

{@liability_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; CGL Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@cgl_coverage}
= @liability_coverage

coverage_type_ref = "CGL"

; CGL-specific options
{.coverage_parts}
premises_operations = ?
products_completed_operations = ?
personal_advertising_injury = ?
damage_to_premises_rented = ?
medical_payments = ?

{@cgl_coverage}

; Exclusion modifications
{.exclusion_options}
contractual_liability = ?
underground_explosion_collapse = ?                ; XCU
pollution_buyback = ?
employment_practices_carveout = ?
professional_services_carveout = ?

{@cgl_coverage}

; Additional coverage options
liquor_liability = ?
host_liquor = ?                                   ; vs full liquor liability

; ═══════════════════════════════════════════════════════════════════════════════
; Products/Completed Operations Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@products_coverage}
= @liability_coverage

coverage_type_ref = "PROD_CO"

products_type = (
    consumer_products,
    food_products,
    industrial_products,
    medical_devices,
    pharmaceuticals
)

; Product recall
product_recall = ?
recall_limit = #$:if product_recall = true
recall_deductible = #$:if product_recall = true

; ═══════════════════════════════════════════════════════════════════════════════
; Liquor Liability Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@liquor_coverage}
= @liability_coverage

coverage_type_ref = "LIQUOR"

liquor_type = (
    bar_tavern,
    brewery_winery,
    manufacturer,
    package_store,
    restaurant
)

; Liquor-specific limits
{.liquor_limits}
each_common_cause = #$
aggregate = #$
assault_battery_sublimit = #$

{@liquor_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Pollution Liability Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@pollution_coverage}
= @liability_coverage

coverage_type_ref = "POLLUTION"
form_type = "claims_made"

pollution_type = (
    contractors,
    fixed_site,
    storage_tanks,
    transportation
)

; Pollution-specific
{.pollution_options}
cleanup_costs = ?
third_party_liability = ?
transportation = ?
non_owned_disposal_sites = ?

{@pollution_coverage}


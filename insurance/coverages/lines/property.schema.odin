; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Property Coverage Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Property coverage line extension of the universal coverage primitive adding
; commercial property fields for valuation methods, causes of loss, coinsurance,
; and business income coverage.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../coverage.schema.odin" as cov
@import "../limits.schema.odin" as limits

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.coverages.lines.property"
version = "1.0.0"
title = "Property Coverage Schema"
description = "Property coverage extending universal coverage primitive"

{$derivation}
source[0].authority = "U.S. Department of Housing and Urban Development"
source[0].citation = "Property Insurance Standards"
source[0].url = "https://www.hud.gov/"

source[1].authority = "National Association of Insurance Commissioners (NAIC)"
source[1].citation = "Property Insurance Model Laws and Regulations"
source[1].url = "https://content.naic.org/"

source[2].authority = "State Insurance Departments"
source[2].citation = "Various state property insurance regulations"
source[2].url = "https://content.naic.org/state-insurance-departments"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Property coverage line extension"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial property coverage schema"
changelog[0].rationale = "Coverage-centric architecture - property line extension"

; ═══════════════════════════════════════════════════════════════════════════════
; Property Coverage (Extends Universal Coverage)
; ═══════════════════════════════════════════════════════════════════════════════

{@property_coverage}
= @coverage                                       ; Inherit all universal coverage fields

; ───────────────────────────────────────────────────────────────────────────────
; Valuation Basis
; ───────────────────────────────────────────────────────────────────────────────
valuation_basis = !(
    actual_cash_value,
    agreed_value,
    functional_replacement,
    market_value,
    replacement_cost
)

; Agreed value
agreed_value_amount = #$:if valuation_basis = agreed_value
agreed_value_expiration = date:if valuation_basis = agreed_value

; ───────────────────────────────────────────────────────────────────────────────
; Coinsurance
; ───────────────────────────────────────────────────────────────────────────────
coinsurance = ##:(0..100)                         ; Coinsurance percentage (80%, 90%, 100%)
coinsurance_waived = ?                            ; Agreed value waives coinsurance

; ───────────────────────────────────────────────────────────────────────────────
; Causes of Loss
; ───────────────────────────────────────────────────────────────────────────────
causes_of_loss = !(basic, broad, special)

; Basic: Fire, lightning, explosion, smoke, windstorm, hail, riot, aircraft, vehicles, vandalism, sprinkler leakage, sinkhole, volcanic action
; Broad: Basic + falling objects, weight of snow/ice, water damage, collapse
; Special: All risks except excluded perils

; ───────────────────────────────────────────────────────────────────────────────
; Blanket Coverage
; ───────────────────────────────────────────────────────────────────────────────
blanket = ?
blanket_limit = #$:if blanket = true
blanket_locations[] = ::if blanket = true         ; Location IDs included

; ───────────────────────────────────────────────────────────────────────────────
; Location Reference
; ───────────────────────────────────────────────────────────────────────────────
location_ref = :                                  ; Reference to business_location

; ───────────────────────────────────────────────────────────────────────────────
; Property Limits
; ───────────────────────────────────────────────────────────────────────────────
{.property_limits}
building = #$
contents = #$
business_personal_property = #$
improvements_betterments = #$
outdoor_property = #$
personal_property_of_others = #$

{@property_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Inflation Guard
; ───────────────────────────────────────────────────────────────────────────────
inflation_guard = ?
inflation_guard_percent = #:(0..25):if inflation_guard = true

; ═══════════════════════════════════════════════════════════════════════════════
; Building Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@building_coverage}
= @property_coverage

coverage_type_ref = "BLDG"

; Building-specific
building_limit = !#$
building_includes_fixtures = ?
building_includes_machinery = ?
building_includes_outdoor_fixtures = ?

; Ordinance or law
{.ordinance_law}
coverage_a = ?                                    ; Loss to undamaged portion
coverage_b = ?                                    ; Demolition cost
coverage_c = ?                                    ; Increased cost of construction
combined_limit = #$

{@building_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Business Personal Property Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@bpp_coverage}
= @property_coverage

coverage_type_ref = "BPP"

bpp_limit = !#$

; BPP includes
{.includes}
furniture_fixtures = ?
machinery_equipment = ?
stock = ?
all_other_bpp = ?
tenant_improvements = ?

{@bpp_coverage}

; Property of others
property_of_others_limit = #$

; Off-premises
off_premises_limit = #$
off_premises_percent = ##:(0..100)

; ═══════════════════════════════════════════════════════════════════════════════
; Business Income Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@business_income_coverage}
= @property_coverage

coverage_type_ref = "BI_PROP"

; BI limit options
{.limit_options}
actual_loss_sustained = ?
monthly_limit = #$
maximum_period_months = ##:(0..24)
annual_aggregate = #$

{@business_income_coverage}

; Coverage options
ordinary_payroll = ?
ordinary_payroll_days = ##:(0..180):if ordinary_payroll = true
extended_period_of_indemnity = ?
extended_period_days = ##:(0..365):if extended_period_of_indemnity = true

; Waiting period
waiting_period_hours = ##:(0..168)

; ═══════════════════════════════════════════════════════════════════════════════
; Extra Expense Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@extra_expense_coverage}
= @property_coverage

coverage_type_ref = "EE"

extra_expense_limit = !#$
combined_with_bi = ?

; Monthly limits
month_1_percent = ##:(0..100)
month_2_percent = ##:(0..100)
month_3_percent = ##:(0..100)

; ═══════════════════════════════════════════════════════════════════════════════
; Equipment Breakdown Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@equipment_breakdown_coverage}
= @property_coverage

coverage_type_ref = "EQ"

equipment_limit = !#$

; Equipment types covered
{.covered_equipment}
mechanical = ?
electrical = ?
pressure_vessels = ?
hvac = ?
production_equipment = ?
computers_electronics = ?
renewable_energy = ?

{@equipment_breakdown_coverage}

; Coverage extensions
{.extensions}
expediting_expense = #$
spoilage = #$
utility_interruption = #$
contingent_bi = #$
data_restoration = #$

{@equipment_breakdown_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Inland Marine Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@inland_marine_coverage}
= @property_coverage

coverage_type = (
    accounts_receivable,
    builders_risk,
    contractors_equipment,
    electronic_data_processing,
    fine_arts,
    installation_floater,
    motor_truck_cargo,
    scheduled_property,
    transit,
    valuable_papers
)

; Transit specific
{.transit}
conveyance = (air, rail, truck, vessel)
origin = :
destination = :

{@inland_marine_coverage}


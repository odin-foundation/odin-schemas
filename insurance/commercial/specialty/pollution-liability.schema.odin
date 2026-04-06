; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Pollution Liability Insurance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Pollution liability coverage for environmental risks including site pollution,
; contractors pollution (CPL), environmental impairment, storage tank, and
; transportation pollution under CERCLA, RCRA, and Clean Water/Air Act.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as com
@import "../business.schema.odin" as entity
@import "../business-location.schema.odin" as location

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.specialty.pollution-liability"
version = "1.0.0"
title = "Pollution Liability Insurance Schema"
description = "Comprehensive environmental liability coverage"

{$derivation}
source[0].authority = "U.S. Environmental Protection Agency"
source[0].citation = "CERCLA / Superfund"
source[0].url = "https://www.epa.gov/superfund"

source[1].authority = "U.S. Environmental Protection Agency"
source[1].citation = "Resource Conservation and Recovery Act"
source[1].url = "https://www.epa.gov/rcra"

source[2].authority = "U.S. Environmental Protection Agency"
source[2].citation = "Underground Storage Tank Regulations"
source[2].url = "https://www.epa.gov/ust"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Complete pollution schema covering all environmental liability exposures"

changelog[0].date = 2025-12-13
changelog[0].change = "Initial pollution liability schema"
changelog[0].rationale = "Comprehensive environmental coverage structure"

; ═══════════════════════════════════════════════════════════════════════════════
; Pollution Site Information
; ═══════════════════════════════════════════════════════════════════════════════

{@pollution_site}
site_id = :
site_number = ##

; ───────────────────────────────────────────────────────────────────────────────
; Site Identification
; ───────────────────────────────────────────────────────────────────────────────
site_name = !:

; Site Address - uses shared @address type (US and Canada)
address = @address

{@pollution_site}
latitude = #:(-90..90)
longitude = #:(-180..180)
acreage = #

; ───────────────────────────────────────────────────────────────────────────────
; Site Classification
; ───────────────────────────────────────────────────────────────────────────────
site_type = !(
    agricultural,
    brownfield,
    commercial,
    formerly_used_defense_site,
    fueling_station,
    industrial,
    landfill,
    manufacturing,
    mining,
    office,
    recycling_facility,
    retail,
    tank_farm,
    transportation_terminal,
    treatment_facility,
    warehouse,
    other
)

; ───────────────────────────────────────────────────────────────────────────────
; Current Operations
; ───────────────────────────────────────────────────────────────────────────────
{.operations}
description = !:
naics_code = :(6)
sic_code = :(4)
hazardous_materials_used[] = :
hazardous_materials_generated[] = :
hazardous_waste_generator = (conditionally_exempt, large_quantity, not_generator, small_quantity)
epa_id_number = :

{@pollution_site}

; ───────────────────────────────────────────────────────────────────────────────
; Historical Operations
; ───────────────────────────────────────────────────────────────────────────────
{.history}
years_operated = ##:(0..200)
prior_owners[] = :
prior_operations[] = :
known_historical_uses[] = :
phase_1_completed = ?
phase_1_date = date:if history.phase_1_completed = true
phase_2_completed = ?
phase_2_date = date:if history.phase_2_completed = true

{@pollution_site}

; ───────────────────────────────────────────────────────────────────────────────
; Environmental Assessments
; ───────────────────────────────────────────────────────────────────────────────
{.assessments}
recognized_environmental_conditions = ?
rec_description = ::if assessments.recognized_environmental_conditions = true
contamination_identified = ?
contamination_type = (air, groundwater, multiple, sediment, soil, surface_water):if assessments.contamination_identified = true
contaminants[] = ::if assessments.contamination_identified = true
remediation_required = ?:if assessments.contamination_identified = true
remediation_status = (completed, monitored, not_started, ongoing):if assessments.remediation_required = true
remediation_cost_estimate = #$:if assessments.remediation_required = true

{@pollution_site}

; ───────────────────────────────────────────────────────────────────────────────
; Storage Tanks
; ───────────────────────────────────────────────────────────────────────────────
{.tanks}
underground_tanks = ##
aboveground_tanks = ##
total_ust_capacity_gallons = ##
total_ast_capacity_gallons = ##
contents[] = (chemicals, diesel, gasoline, heating_oil, waste_oil, other)
registered_with_state = ?
leak_detection = ?
spill_prevention_plan = ?

{@pollution_site}

; ───────────────────────────────────────────────────────────────────────────────
; Regulatory Status
; ───────────────────────────────────────────────────────────────────────────────
{.regulatory}
permits[] = :
permit_violations = ?
consent_orders = ?
consent_order_description = ::if regulatory.consent_orders = true
superfund_site = ?
npl_site = ?                       ; National Priorities List
cerclis_site = ?
rcra_corrective_action = ?
state_cleanup_program = ?

{@pollution_site}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Limit for this Site
; ───────────────────────────────────────────────────────────────────────────────
site_limit = #$
site_deductible = ##

; Premium allocation
premium = #$

; ═══════════════════════════════════════════════════════════════════════════════
; Pollution Coverage Structure
; ═══════════════════════════════════════════════════════════════════════════════

{@pollution_coverage}
coverage_id = :

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Type
; ───────────────────────────────────────────────────────────────────────────────
coverage_type = !(
    contractors_pollution,                    ; CPL
    environmental_impairment,                 ; Combined EIL
    products_pollution,
    site_pollution,                           ; Owned/operated premises
    storage_tank,
    transportation
)

; ───────────────────────────────────────────────────────────────────────────────
; Limits
; ───────────────────────────────────────────────────────────────────────────────
limit_each_pollution_condition = #$
limit_aggregate = #$
defense_within_limits = ?

; ───────────────────────────────────────────────────────────────────────────────
; Self-Insured Retention
; ───────────────────────────────────────────────────────────────────────────────
retention = ##
retention_applies_to = (each_pollution_condition, each_claim)
retention_includes_defense = ?

; ───────────────────────────────────────────────────────────────────────────────
; Third-Party Bodily Injury / Property Damage
; ───────────────────────────────────────────────────────────────────────────────
{.third_party}
bodily_injury = ?true
property_damage = ?true
diminution_of_property_value = ?
natural_resource_damages = ?

{@pollution_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; First-Party Cleanup / Remediation
; ───────────────────────────────────────────────────────────────────────────────
{.cleanup}
on_site_cleanup = ?
off_site_cleanup = ?
emergency_response = ?
business_interruption = ?
bi_limit = #$:if cleanup.business_interruption = true
bi_waiting_period_days = #:(0, 7, 14, 30):if cleanup.business_interruption = true

{@pollution_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Non-Owned Disposal Site Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.nods}
included = ?
limit = #$:if nods.included = true
retention = ##:if nods.included = true

{@pollution_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Transportation Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.transportation}
owned_vehicles = ?
non_owned_vehicles = ?
hired_vehicles = ?
rail = ?
marine = ?
pipeline = ?
limit = #$

{@pollution_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Storage Tank Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.tank}
underground_storage_tanks = ?
aboveground_storage_tanks = ?
corrective_action_coverage = ?
third_party_coverage = ?
limit = #$
tank_deductible = ##

{@pollution_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Products Pollution Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.products}
included = ?
limit = #$:if products.included = true
products_covered[] = ::if products.included = true

{@pollution_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Contractors Pollution Liability
; ───────────────────────────────────────────────────────────────────────────────
{.cpl}
included = ?:if coverage_type = contractors_pollution
operations_coverage = ?:if cpl.included = true
completed_operations = ?:if cpl.included = true
transportation = ?:if cpl.included = true
non_owned_disposal = ?:if cpl.included = true
professional_services = ?:if cpl.included = true
microbial_matter = ?:if cpl.included = true
lead_paint = ?:if cpl.included = true
asbestos = ?:if cpl.included = true

{@pollution_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Regulatory Defense
; ───────────────────────────────────────────────────────────────────────────────
{.regulatory}
defense_costs = ?
fines_penalties = ?
insurable_fines_only = ?:if regulatory.fines_penalties = true
voluntary_cleanup = ?

{@pollution_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Additional Coverages
; ───────────────────────────────────────────────────────────────────────────────
{.additional}
crisis_management = ?
crisis_limit = #$:if additional.crisis_management = true

legal_defense = ?
defense_limit = #$:if additional.legal_defense = true

mold_coverage = ?
mold_limit = #$:if additional.mold_coverage = true

legionella = ?
legionella_limit = #$:if additional.legionella = true

{@pollution_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Pollution Policy
; ═══════════════════════════════════════════════════════════════════════════════

{@pollution_policy}
id = :
number = !:

; ───────────────────────────────────────────────────────────────────────────────
; Term
; ───────────────────────────────────────────────────────────────────────────────
effective_date = !date
effective_time = time
expiration_date = !date
expiration_time = time
:invariant expiration_date > effective_date

; ───────────────────────────────────────────────────────────────────────────────
; Policy Form
; ───────────────────────────────────────────────────────────────────────────────
policy_form = !(claims_made, occurrence)

; Claims-Made Dates
retroactive_date = date:if policy_form = claims_made
continuity_date = date:if policy_form = claims_made

; Extended Reporting Period
erp_purchased = ?
erp_type = (basic, supplemental_1_year, supplemental_3_year, unlimited):if erp_purchased = true
erp_effective_date = date:if erp_purchased = true

; ───────────────────────────────────────────────────────────────────────────────
; Named Insured
; ───────────────────────────────────────────────────────────────────────────────
named_insured = @entity.business

; ───────────────────────────────────────────────────────────────────────────────
; Coverage
; ───────────────────────────────────────────────────────────────────────────────
coverage = @pollution_coverage

; ───────────────────────────────────────────────────────────────────────────────
; Scheduled Sites
; ───────────────────────────────────────────────────────────────────────────────
sites[] = @pollution_site

; Blanket coverage for unlisted sites
blanket_coverage = ?
blanket_limit = #$:if blanket_coverage = true
blanket_retention = ##:if blanket_coverage = true

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
base = #$
site_specific = #$
endorsements = #$
taxes_fees = #$
total = #$
minimum = #$

{@pollution_policy}



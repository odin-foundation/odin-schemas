; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Builders Risk Insurance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Builders risk (course of construction) insurance for construction projects
; including single project, master/reporting form, renovation/remodeling,
; and installation floater coverages.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as com
@import "../business.schema.odin" as entity
@import "../business-location.schema.odin" as location

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.property.builders-risk"
version = "1.0.0"
title = "Builders Risk Insurance Schema"
description = "Comprehensive builders risk coverage for construction projects"

{$derivation}
source[0].authority = "American Institute of Architects"
source[0].citation = "AIA Document A101-2017 Standard Form of Agreement"
source[0].url = "https://www.aiacontracts.org/"

source[1].authority = "U.S. Department of Housing and Urban Development"
source[1].citation = "Construction Insurance Requirements"
source[1].url = "https://www.hud.gov/"

source[2].authority = "National Association of Insurance Commissioners (NAIC)"
source[2].citation = "Property Insurance Model Laws and Regulations"
source[2].url = "https://content.naic.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Complete builders risk schema for all construction project types"

changelog[0].date = 2025-12-13
changelog[0].change = "Initial builders risk schema"
changelog[0].rationale = "Comprehensive construction coverage structure"

; ═══════════════════════════════════════════════════════════════════════════════
; Project Information
; ═══════════════════════════════════════════════════════════════════════════════

{@br_project}
; ───────────────────────────────────────────────────────────────────────────────
; Project Identification
; ───────────────────────────────────────────────────────────────────────────────
project_name = !:

id = :
project_number = :
permit_number = :
permit_date = date

; ───────────────────────────────────────────────────────────────────────────────
; Project Address - uses shared @address type (US and Canada)
; ───────────────────────────────────────────────────────────────────────────────
address = @address

{@br_project}

; Coordinates
latitude = #:(-90..90)
longitude = #:(-180..180)

; ───────────────────────────────────────────────────────────────────────────────
; Project Type
; ───────────────────────────────────────────────────────────────────────────────
project_type = !(
    addition,
    civil_works,
    demolition_and_rebuild,
    infrastructure,
    new_construction,
    remodeling,
    renovation,
    restoration
)

; Building Use
building_use = (
    apartment,
    commercial_mixed_use,
    commercial_office,
    commercial_retail,
    condominium,
    educational,
    governmental,
    healthcare,
    hospitality,
    industrial,
    infrastructure,
    other,
    religious,
    residential_multi_family,
    residential_single_family,
    warehouse
)

; Stories
stories_above_grade = ##
stories_below_grade = ##
total_square_footage = ##

; ───────────────────────────────────────────────────────────────────────────────
; Construction Details
; ───────────────────────────────────────────────────────────────────────────────
{.construction}
type = !(
    fire_resistive,
    frame,
    joisted_masonry,
    masonry_noncombustible,
    modified_fire_resistive,
    noncombustible
)

frame_type = (concrete, hybrid, steel, wood)
foundation = (basement, crawl_space, other, pilings, slab)
roof_type = (dome, flat, other, pitched)

{@br_project}

; ───────────────────────────────────────────────────────────────────────────────
; Project Values
; ───────────────────────────────────────────────────────────────────────────────
{.values}
total_project_value = !#$
hard_costs = #$                          ; Construction and materials costs
soft_costs = #$                          ; Fees, permits, financing costs
land_value = #$                          ; Land value for reference
existing_structure_value = #$:if project_type != new_construction

{@br_project}

; ───────────────────────────────────────────────────────────────────────────────
; Project Schedule
; ───────────────────────────────────────────────────────────────────────────────
{.schedule}
ground_breaking_date = date
estimated_completion_date = !date
substantial_completion_date = date
final_completion_date = date
occupancy_date = date
duration_months = ##

{@br_project}

; ───────────────────────────────────────────────────────────────────────────────
; Project Parties
; ───────────────────────────────────────────────────────────────────────────────
{.owner}
name = !:
type = (corporation, governmental, individual, llc, partnership, trust)

{@br_project}
{.general_contractor}
name = :
license_number = *:
bonded = ?

{@br_project}
{.architect}
name = :
license_number = *:

{@br_project}
{.engineer}
name = :
license_number = *:

{@br_project}
{.construction_manager}
name = :

{@br_project}
{.lender}
name = :
loan_number = *:

{@br_project}

; ═══════════════════════════════════════════════════════════════════════════════
; Builders Risk Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@br_coverage}
id = :

; ───────────────────────────────────────────────────────────────────────────────
; Policy Form
; ───────────────────────────────────────────────────────────────────────────────
policy_form = !(
    installation_floater,
    master_reporting,                         ; Multiple projects
    renovation,
    single_project                            ; Single project policy
)

; Causes of Loss
causes_of_loss = !(basic, broad, special)     ; Special = All Risk

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Limits
; ───────────────────────────────────────────────────────────────────────────────
; Building Under Construction
{.building}
limit = !#$
coinsurance = ##:(80, 90, 100)
valuation = (actual_cash_value, completed_value, replacement_cost)
deductible = ##

{@br_coverage}
; Materials and Supplies
{.materials}
on_site_limit = #$
in_transit_limit = #$
at_temporary_locations_limit = #$
deductible = ##

{@br_coverage}
; Existing Structure (if renovation)
{.existing_structure}
limit = #$
deductible = ##

{@br_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Soft Costs Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.soft_costs}
included = ?
limit = #$:if soft_costs.included = true
deductible = ##:if soft_costs.included = true
waiting_period_days = ##:(0, 7, 14, 30):if soft_costs.included = true
period_of_indemnity_months = ##:(3, 6, 12, 18, 24):if soft_costs.included = true

; Covered Soft Costs
architectural_fees = ?:if soft_costs.included = true
engineering_fees = ?:if soft_costs.included = true
legal_fees = ?:if soft_costs.included = true
accounting_fees = ?:if soft_costs.included = true
permit_fees = ?:if soft_costs.included = true
loan_interest = ?:if soft_costs.included = true
real_estate_taxes = ?:if soft_costs.included = true
insurance_premium = ?:if soft_costs.included = true
advertising = ?:if soft_costs.included = true

{@br_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Delay in Completion / Business Income
; ───────────────────────────────────────────────────────────────────────────────
{.delay_in_completion}
included = ?
limit = #$:if delay_in_completion.included = true
daily_limit = #$:if delay_in_completion.included = true
waiting_period_days = ##:(0, 7, 14, 30):if delay_in_completion.included = true
max_days = ##:(30, 60, 90, 180, 365):if delay_in_completion.included = true

{@br_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Additional Coverages
; ───────────────────────────────────────────────────────────────────────────────
{.additional}
debris_removal = ?true
debris_removal_limit = #$

pollutant_cleanup = ?
pollutant_cleanup_limit = #$:if additional.pollutant_cleanup = true

preservation_of_property = ?
preservation_limit = #$:if additional.preservation_of_property = true

fire_department_service = ?
fire_dept_limit = #$:if additional.fire_department_service = true

ordinance_or_law = ?
ordinance_limit = #$:if additional.ordinance_or_law = true

expediting_expense = ?
expediting_limit = #$:if additional.expediting_expense = true

scaffolding = ?
scaffolding_limit = #$:if additional.scaffolding = true

temporary_structures = ?
temporary_structures_limit = #$:if additional.temporary_structures = true

trees_shrubs_plants = ?
landscaping_limit = #$:if additional.trees_shrubs_plants = true

{@br_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Equipment Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.equipment}
contractors_equipment = ?
contractors_equipment_limit = #$:if equipment.contractors_equipment = true

owned_rented_property = (both, owned_only, rented_leased)
deductible = ##:if equipment.contractors_equipment = true

{@br_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Earth Movement / Flood
; ───────────────────────────────────────────────────────────────────────────────
{.earthquake}
included = ?
limit = #$:if earthquake.included = true
deductible_percentage = ##:(2, 5, 10, 15, 20, 25):if earthquake.included = true
deductible_minimum = ##:if earthquake.included = true

{@br_coverage}
{.flood}
included = ?
limit = #$:if flood.included = true
deductible = ##:if flood.included = true

{@br_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Testing Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.testing}
included = ?
hot_testing = ?:if testing.included = true
cold_testing = ?:if testing.included = true
commissioning = ?:if testing.included = true
limit = #$:if testing.included = true
deductible = ##:if testing.included = true

{@br_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Occupancy Provisions
; ───────────────────────────────────────────────────────────────────────────────
{.occupancy}
partial_occupancy_allowed = ?
max_occupancy_percentage = #:(0..100):if occupancy.partial_occupancy_allowed = true
coverage_after_occupancy_days = ##:(0, 30, 60, 90):if occupancy.partial_occupancy_allowed = true

{@br_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Builders Risk Policy
; ═══════════════════════════════════════════════════════════════════════════════

{@br_policy}
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
; Named Insured(s)
; ───────────────────────────────────────────────────────────────────────────────
named_insured = @entity.business

; Additional Named Insureds
{.additional_named_insureds[]}
name = :
role = (construction_manager, general_contractor, lender, owner, subcontractor)
insured_as = (additional_insured, loss_payee, named_insured)

{@br_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Project(s)
; ───────────────────────────────────────────────────────────────────────────────
projects[] = @br_project

; ───────────────────────────────────────────────────────────────────────────────
; Coverage
; ───────────────────────────────────────────────────────────────────────────────
coverage = @br_coverage

; ───────────────────────────────────────────────────────────────────────────────
; Loss Payees / Mortgagees
; ───────────────────────────────────────────────────────────────────────────────
{.loss_payees[]}
name = :                                     ; Loss payee name
address = @address                           ; Loss payee address
loan_number = *:                             ; Loan number
interest = (lenders_loss_payable, loss_payee, mortgagee)

{@br_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
base = #$
soft_costs = #$
delay_in_completion = #$
earthquake = #$
flood = #$
endorsements = #$
total = #$
minimum = #$
deposit = #$

{@br_policy}



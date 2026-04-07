; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Commercial Inland Marine Insurance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Commercial inland marine insurance covering property in transit, contractors
; equipment, EDP equipment, valuable papers, accounts receivable, signs, fine
; arts, jewelers block, and other floater coverages.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as com
@import "../business.schema.odin" as entity

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.property.inland-marine"
version = "1.0.0"
title = "Commercial Inland Marine Insurance Schema"
description = "Comprehensive inland marine coverage for mobile and transit property"

{$derivation}
source[0].authority = "U.S. Department of Transportation"
source[0].citation = "Federal Motor Carrier Safety Administration - Cargo Insurance"
source[0].url = "https://www.fmcsa.dot.gov/"

source[1].authority = "National Association of Insurance Commissioners (NAIC)"
source[1].citation = "Inland Marine Insurance Model Laws"
source[1].url = "https://content.naic.org/"

source[2].authority = "State Insurance Departments"
source[2].citation = "Various state property/marine insurance regulations"
source[2].url = "https://content.naic.org/state-insurance-departments"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Complete inland marine schema covering all floater and transit exposures"

changelog[0].date = 2025-12-13
changelog[0].change = "Initial inland marine schema"
changelog[0].rationale = "Comprehensive mobile property coverage structure"

; ═══════════════════════════════════════════════════════════════════════════════
; Contractors Equipment Floater
; ═══════════════════════════════════════════════════════════════════════════════

{@im_contractors_equipment}
id = :

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Form
; ───────────────────────────────────────────────────────────────────────────────
coverage_form = !(
    blanket,                                  ; All equipment
    combination,                              ; Scheduled + blanket for smaller items
    scheduled                                 ; Listed equipment
)

; ───────────────────────────────────────────────────────────────────────────────
; Limits
; ───────────────────────────────────────────────────────────────────────────────
limit_per_item = #$
limit_per_occurrence = #$
blanket_limit = #$:if coverage_form != scheduled
scheduled_total = #$:if coverage_form != blanket

; ───────────────────────────────────────────────────────────────────────────────
; Deductible
; ───────────────────────────────────────────────────────────────────────────────
deductible = ##
deductible_type = (flat, percentage)
catastrophe_deductible = ##

; ───────────────────────────────────────────────────────────────────────────────
; Valuation
; ───────────────────────────────────────────────────────────────────────────────
valuation = (actual_cash_value, agreed_value, functional, replacement_cost)

; ───────────────────────────────────────────────────────────────────────────────
; Covered Property Types
; ───────────────────────────────────────────────────────────────────────────────
{.covered_property}
heavy_equipment = ?
tools = ?
scaffolding = ?
forms_and_falsework = ?
temporary_structures = ?
mobile_offices = ?
leased_equipment = ?
rented_equipment = ?
borrowed_equipment = ?

{@im_contractors_equipment}

; ───────────────────────────────────────────────────────────────────────────────
; Scheduled Equipment List
; ───────────────────────────────────────────────────────────────────────────────
{.scheduled_items[]}
item_number = ##
description = !:
manufacturer = :
model = :
year = ##:(1900..2100)
serial_number = :
vin = *:/^[A-HJ-NPR-Z0-9]{17}$/
limit = !#$
deductible = ##
owned_leased_rented = (leased, owned, rented)
lessor = ::if owned_leased_rented != owned

{@im_contractors_equipment}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Extensions
; ───────────────────────────────────────────────────────────────────────────────
{.extensions}
newly_acquired = ?
newly_acquired_limit = #$:if extensions.newly_acquired = true
newly_acquired_days = ##:(30, 60, 90):if extensions.newly_acquired = true

rental_reimbursement = ?
rental_daily_limit = #$:if extensions.rental_reimbursement = true
rental_max_days = ##:(30, 60, 90, 180):if extensions.rental_reimbursement = true

debris_removal = ?
debris_removal_limit = #$:if extensions.debris_removal = true

expediting_expense = ?
expediting_limit = #$:if extensions.expediting_expense = true

{@im_contractors_equipment}

; ───────────────────────────────────────────────────────────────────────────────
; Territory
; ───────────────────────────────────────────────────────────────────────────────
territory = (north_america, us_canada, us_only, worldwide)
job_site_notification = ?                     ; Must notify carrier of job sites

; Premium
premium = #$

; ═══════════════════════════════════════════════════════════════════════════════
; Motor Truck Cargo
; ═══════════════════════════════════════════════════════════════════════════════

{@im_cargo}
id = :

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Type
; ───────────────────────────────────────────────────────────────────────────────
type = !(
    annual_transit,                           ; Annual policy
    motor_truck_cargo,                        ; For-hire truckers
    owners_goods,                             ; Shipper's interest
    parcel_post,
    trip_transit                              ; Single shipment
)

; ───────────────────────────────────────────────────────────────────────────────
; Limits
; ───────────────────────────────────────────────────────────────────────────────
limit_per_occurrence = #$
limit_per_vehicle = #$
limit_per_shipment = #$
deductible = ##

; ───────────────────────────────────────────────────────────────────────────────
; Cargo Types
; ───────────────────────────────────────────────────────────────────────────────
cargo_types[] = (
    automobiles,
    building_materials,
    electronics,
    fine_arts,
    general_commodities,
    hazardous_materials,
    household_goods,
    jewelry,
    livestock,
    machinery,
    other,
    pharmaceuticals,
    refrigerated
)
cargo_description = :

; Excluded Cargo
excluded_cargo[] = :

; ───────────────────────────────────────────────────────────────────────────────
; Territory
; ───────────────────────────────────────────────────────────────────────────────
territory = (north_america, us_canada, us_only, worldwide)
origin_points[] = :
destination_points[] = :
routes[] = :

; ───────────────────────────────────────────────────────────────────────────────
; Conveyance
; ───────────────────────────────────────────────────────────────────────────────
conveyance = (air, multimodal, ocean, rail, truck)
owned_trucks = ##
non_owned_trucks = ?

; Premium
premium = #$

; ═══════════════════════════════════════════════════════════════════════════════
; Electronic Data Processing Equipment
; ═══════════════════════════════════════════════════════════════════════════════

{@im_edp}
id = :

; ───────────────────────────────────────────────────────────────────────────────
; Coverage
; ───────────────────────────────────────────────────────────────────────────────
hardware_limit = #$
software_limit = #$
media_limit = #$
extra_expense_limit = #$
business_interruption_limit = #$

deductible = ##
bi_waiting_period_hours = ##:(0, 8, 12, 24, 48, 72)

; ───────────────────────────────────────────────────────────────────────────────
; Valuation
; ───────────────────────────────────────────────────────────────────────────────
hardware_valuation = (actual_cash_value, functional, replacement_cost)
software_valuation = (market_value, reproduction_cost)

; ───────────────────────────────────────────────────────────────────────────────
; Covered Locations
; ───────────────────────────────────────────────────────────────────────────────
locations[] = :
portable_equipment = ?
in_transit = ?
temporary_locations = ?

; Premium
premium = #$

; ═══════════════════════════════════════════════════════════════════════════════
; Valuable Papers and Records
; ═══════════════════════════════════════════════════════════════════════════════

{@im_valuable_papers}
id = :

limit = #$
deductible = ##
extra_expense_limit = #$

covered_property[] = (
    abstracts,
    books_of_account,
    card_index_systems,
    disc,
    drawings,
    electronic_data,
    film,
    manuscripts,
    other,
    tape
)

valuation = (actual_cash_value, cost_to_research_replace)
territory = (premises_only, transit, worldwide)

premium = #$

; ═══════════════════════════════════════════════════════════════════════════════
; Installation Floater
; ═══════════════════════════════════════════════════════════════════════════════

{@im_installation}
id = :

; Project Information
project_name = :                             ; Project name
project_address = @address                   ; Project address
project_description = :                      ; Project description
project_start_date = date                    ; Project start date
project_completion_date = date               ; Project completion date

; Coverage
limit = #$
deductible = ##
valuation = (contract_price, cost, selling_price)

; Covered Phases
{.coverage}
in_transit = ?
at_job_site = ?
during_installation = ?
testing = ?
after_installation = ?
maintenance_period = ?
maintenance_days = ##:if coverage.maintenance_period = true  ; Maintenance coverage period days

{@im_installation}
; Property Types
property_type = (
    communications,
    electrical_equipment,
    elevator,
    fire_suppression,
    hvac,
    machinery_equipment,
    other,
    security_systems
)

premium = #$

; ═══════════════════════════════════════════════════════════════════════════════
; Inland Marine Policy
; ═══════════════════════════════════════════════════════════════════════════════

{@im_policy}
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
; Named Insured
; ───────────────────────────────────────────────────────────────────────────────
named_insured = @entity.business

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Sections
; ───────────────────────────────────────────────────────────────────────────────
contractors_equipment = @im_contractors_equipment
cargo = @im_cargo
edp_equipment = @im_edp
valuable_papers = @im_valuable_papers
installation = @im_installation

; ───────────────────────────────────────────────────────────────────────────────
; Additional Coverages
; ───────────────────────────────────────────────────────────────────────────────
{.signs}
included = ?
limit = #$:if signs.included = true
deductible = ##:if signs.included = true

{@im_policy}
{.fine_arts}
included = ?
limit = #$:if fine_arts.included = true
deductible = ##:if fine_arts.included = true
schedule[] = ::if fine_arts.included = true

{@im_policy}
{.accounts_receivable}
included = ?
limit = #$:if accounts_receivable.included = true
deductible = ##:if accounts_receivable.included = true

{@im_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Premium Summary
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
contractors_equipment = #$
cargo = #$
edp = #$
valuable_papers = #$
installation = #$
other = #$
total = #$
minimum = #$

{@im_policy}



; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Commercial General Liability (CGL) Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Commercial General Liability (CGL) coverage including Coverage A (bodily injury
; and property damage), Coverage B (personal and advertising injury), and
; Coverage C (medical payments) in both occurrence and claims-made forms.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../coverages/coverage.schema.odin" as cov
@import "../../coverages/lines/liability.schema.odin" as liability
@import "../../common/types.schema.odin" as com
@import "../business.schema.odin" as entity
@import "../business-location.schema.odin" as location

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.liability.cgl"
version = "2.0.0"
title = "Commercial General Liability Schema"
description = "CGL coverage extending universal coverage primitive"

{$derivation}
source[0].authority = "Texas Department of Insurance"
source[0].citation = "Commercial Liability Insurance Filing Requirements"
source[0].url = "https://www.tdi.texas.gov/commercial/index.html"

source[1].authority = "California Department of Insurance"
source[1].citation = "Commercial General Liability Rate Filing Guidelines"
source[1].url = "https://www.insurance.ca.gov/"

source[2].authority = "New York Department of Financial Services"
source[2].citation = "Commercial Lines Property/Casualty Insurance Regulations"
source[2].url = "https://www.dfs.ny.gov/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "CGL schema extending universal coverage primitive with CGL-specific extensions"

changelog[0].date = 2025-12-14
changelog[0].change = "Refactored to extend universal coverage primitive"
changelog[0].rationale = "Coverage-centric architecture - extend @cgl_coverage from coverage/lines/liability.schema.odin"

changelog[1].date = 2025-12-13
changelog[1].change = "Initial CGL schema"
changelog[1].rationale = "Comprehensive general liability coverage structure"

; ═══════════════════════════════════════════════════════════════════════════════
; CGL Commercial Coverage (Extends @cgl_coverage from liability line)
; ═══════════════════════════════════════════════════════════════════════════════
; Inherits from @cgl_coverage which inherits from @liability_coverage <- @coverage

{@cgl_commercial_coverage}
= @cgl_coverage                                   ; Inherit from CGL line extension

; ───────────────────────────────────────────────────────────────────────────────
; Form Edition (CGL Specific)
; ───────────────────────────────────────────────────────────────────────────────
form_number = :                                   ; Policy form identifier
form_edition_date = date

; Claims-Made Extensions (beyond what @liability_coverage provides)
extended_reporting_period = ?:if form_type = claims_made
erp_type = (
    basic,                                        ; 60 days automatic
    supplemental_1_year,
    supplemental_3_year,
    supplemental_5_year,
    unlimited
):if form_type = claims_made
erp_effective_date = date:if extended_reporting_period = true

; ───────────────────────────────────────────────────────────────────────────────
; Coverage A - Bodily Injury and Property Damage Liability
; ───────────────────────────────────────────────────────────────────────────────

{.coverage_a}
each_occurrence = #$:(0..)                        ; Extends universal limits
damage_to_premises_rented = #$:(0..)
medical_expense = #$:(0..)                        ; Any one person

; Aggregates
general_aggregate = #$:(0..)
products_completed_ops_aggregate = #$:(0..)

; Aggregate Application (extends from @liability_coverage.cgl_limits.aggregate_per)
designated_project = :if aggregate_per = project
designated_location = ##:if aggregate_per = location

{@cgl_commercial_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage B - Personal and Advertising Injury Liability
; ───────────────────────────────────────────────────────────────────────────────
{.coverage_b}
limit = #$:(0..)                                  ; Each offense

covered_offenses = (detention_imprisonment, false_arrest, infringement_of_copyright, infringement_of_trade_dress, invasion_of_privacy, malicious_prosecution, oral_publication_slander, use_of_anothers_advertising_idea, wrongful_entry, wrongful_eviction, written_publication_libel)

{@cgl_commercial_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage C - Medical Payments
; ───────────────────────────────────────────────────────────────────────────────
{.coverage_c}
any_one_person = #$:(0..)
coverage_territory = (
    designated_countries,
    us_territories_canada,
    worldwide
)
designated_countries[] = :if coverage_territory = designated_countries

{@cgl_commercial_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Products-Completed Operations Hazard
; ───────────────────────────────────────────────────────────────────────────────
{.products_completed_ops}
included = ?
separate_aggregate = ?
aggregate_limit = #$:(0..):if included = true

{@cgl_commercial_coverage}
; Products Coverage
{.products}
products_manufactured = :
products_distributed = :
products_sold = :
annual_products_sales = #$:(0..)

; Recall Coverage
recall_expense_coverage = ?
recall_limit = #$:(0..):if recall_expense_coverage = true
recall_deductible = #$:(0..):if recall_expense_coverage = true

{@cgl_commercial_coverage}
; Completed Operations
{.completed_ops}
operations_description = :
annual_completed_ops_receipts = #$:(0..)

{@cgl_commercial_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Deductibles / Self-Insured Retentions
; ───────────────────────────────────────────────────────────────────────────────
{.deductible_options}
= @deductible                                     ; Use shared deductible type

; CGL-specific extensions
deductible_type_cgl = (deductible, none, self_insured_retention)
applies_to_cgl = (
    all_coverage,
    bodily_injury_and_property_damage,
    property_damage_only
):if deductible_type_cgl != none
per = (claim, occurrence):if deductible_type_cgl != none
annual_aggregate = #$:(0..):if deductible_type_cgl != none

{@cgl_commercial_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Territory
; ───────────────────────────────────────────────────────────────────────────────
{.territory_options}
primary = (designated, us_territories_canada, worldwide)
products_worldwide = ?
suits_brought_in = (us_canada, us_only, worldwide)
excluded_countries[] = :

{@cgl_commercial_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Who Is An Insured
; ───────────────────────────────────────────────────────────────────────────────
{.insureds}
named_insured_type = (
    individual,
    joint_venture,
    llc,
    organization_other_than_partnership_jv_llc,
    partnership,
    trust
)
spouse_covered = ?:if named_insured_type = individual
partners_covered = ?:if named_insured_type = partnership
members_covered = ?:if named_insured_type = llc
executive_officers_covered = ?
directors_covered = ?
stockholders_covered = ?
employees_covered = ?
volunteer_workers_covered = ?
real_estate_managers_covered = ?

{@cgl_commercial_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Premium Information
; ───────────────────────────────────────────────────────────────────────────────
{.premium_details}
estimated_annual = #$:(0..)
minimum = #$:(0..)
deposit = #$:(0..)
audit_type = (annual, monthly, quarterly, self_audit, semi_annual)

{@cgl_commercial_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; CGL Classification
; ═══════════════════════════════════════════════════════════════════════════════

{@cgl_classification}
= @rating_classification                       ; Use shared rating classification type

class_id = :
sequence = ##

; GL Classification - extends @rating_classification
hazard_group = (A, B, C, D, E, F, G)           ; Hazard group

; Exposure Basis - extends @rating_classification.exposure_basis
exposure_basis_description = :if exposure_basis = other

; Exposure Amount - extends @rating_classification.exposure
estimated_exposure = #$:(0..)
actual_exposure = #$:(0..)                     ; From audit
exposure_period = date_range

; Location Assignment
location_number = ##                           ; Which location this applies to
applies_to_all_locations = ?

; Rating - extends @rating_classification base_rate and factor
rate = #
base_premium = #$:(0..)
credits[] = #
surcharges[] = #
final_premium = #$:(0..)

; Products/Completed Operations Split
premises_operations_premium = #$:(0..)
products_completed_ops_premium = #$:(0..)

; ═══════════════════════════════════════════════════════════════════════════════
; Additional Insured
; ═══════════════════════════════════════════════════════════════════════════════

{@cgl_additional_insured}
ai_id = :

; Identity - uses shared @address type (US and Canada)
name = :
address = @address

{@cgl_additional_insured}

; Endorsement Form
endorsement_form = (
    blanket_automatic,
    custom,
    designated_person_organization,
    engineers_architects,
    grantor_of_permits,
    lessor_leased_equipment,
    managers_lessors_premises,
    mortgagee_assignee_receiver,
    owners_lessees_contractors_automatic,
    owners_lessees_contractors_completed_ops,
    owners_lessees_contractors_scheduled,
    owners_lessees_premises,
    state_governmental_agency,
    vendors
)
endorsement_edition_date = date
custom_endorsement_number = :if endorsement_form = custom

; Coverage Scope
coverage_scope = (
    both,
    completed_operations,
    ongoing_operations,
    premises,
    products,
    your_work
)

; Special Provisions
primary_and_noncontributory = ?
primary_noncontributory_endorsement = :if primary_and_noncontributory = true
waiver_of_subrogation = ?
waiver_endorsement = :if waiver_of_subrogation = true
notice_of_cancellation = ?
cancellation_notice_days = ##:if notice_of_cancellation = true

; Contract Reference
contract_number = :
contract_date = date
project_name = :
project_location = :

; Effective Period
effective_date = date
expiration_date = date

; ═══════════════════════════════════════════════════════════════════════════════
; Key Endorsements
; ═══════════════════════════════════════════════════════════════════════════════

{@cgl_endorsement}
id = :
number = :                        ; Endorsement identifier
title = :
edition_date = date
effective_date = date

; Endorsement Category
category = (
    additional_insured,
    definition_change,
    exclusion,
    extension,
    limitation,
    other,
    territory
)

; Effect
modifies_coverage = (broadens, clarifies, restricts)
affects_coverage_part = (A, B, C, all)
premium_impact = #$

; Common Endorsements
endorsement_type = (
    amendment_aggregate_per_project,
    contractual_blanket,
    contractual_liability_limitation,
    exclusion_access_or_disclosure,
    exclusion_assault_battery,
    exclusion_designated_premises,
    exclusion_designated_products,
    exclusion_designated_work,
    exclusion_discrimination,
    exclusion_employee_benefits,
    exclusion_employment_practices,
    exclusion_fungi_bacteria,
    exclusion_intercompany_products,
    exclusion_lead,
    exclusion_silica,
    exclusion_total_pollution,
    exclusion_war,
    nuclear_energy_exclusion,
    other,
    waiver_of_subrogation
)

description = :

; ═══════════════════════════════════════════════════════════════════════════════
; CGL Exclusions (Tracking what's excluded)
; ═══════════════════════════════════════════════════════════════════════════════

{@cgl_exclusions}
; Standard Exclusions (always present)
expected_intended_injury = ?true
contractual_liability_standard = ?true
liquor_liability_standard = ?true
workers_compensation = ?true
employers_liability = ?true
pollution_standard = ?true
aircraft_auto_watercraft = ?true
mobile_equipment = ?true
war = ?true
damage_to_property_owned = ?true
damage_to_property_care_custody = ?true
damage_to_your_product = ?true
damage_to_your_work = ?true
damage_to_impaired_property = ?true
recall_of_products = ?true
personal_advertising_injury_exclusions = ?true
electronic_data = ?true
recording_distribution = ?true

; Common Additional Exclusions (by endorsement)
total_pollution = ?
designated_products = ?
designated_operations = ?
access_disclosure_confidential = ?
fungi_bacteria = ?
asbestos = ?
lead = ?
silica = ?
nuclear_energy = ?
employment_related_practices = ?
professional_services = ?
cyber_incidents = ?

; ═══════════════════════════════════════════════════════════════════════════════
; CGL Policy (Composes All Parts)
; ═══════════════════════════════════════════════════════════════════════════════

{@cgl_policy}
id = :
number = :

; Term
effective_date = date
effective_time = time
expiration_date = date
expiration_time = time
:invariant expiration_date > effective_date

; Named Insured
named_insured = @entity.business

; Coverage (uses new coverage architecture)
coverage = @cgl_commercial_coverage

; Classifications by Location
classifications[] = @cgl_classification

; Locations
locations[] = @location.business_location

; Additional Insureds
additional_insureds[] = @cgl_additional_insured

; Endorsements
endorsements[] = @cgl_endorsement

; Exclusions Summary
exclusions = @cgl_exclusions

; Premium Summary
{.premium_summary}
total_estimated = #$:(0..)
total_minimum = #$:(0..)
deposit = #$:(0..)

{@cgl_policy}


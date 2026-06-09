; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Renters Insurance Policy Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Renters insurance (HO-4) covering personal property, personal liability, medical
; payments to others, additional living expenses, and identity theft for
; tenant-occupied residences.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../coverages/coverage.schema.odin" as cov
@import "../../coverages/lines/homeowners.schema.odin" as ho
@import "../../common/types.schema.odin" as types
@import "../../common/party.schema.odin" as party
@import "../residential-types.schema.odin" as res

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.renters"
version = "1.0.0"
title = "Renters Insurance Policy Schema"
description = "Renters insurance policy (HO-4) for tenant personal property and liability"

{$derivation}
source[0].authority = "National Association of Insurance Commissioners (NAIC)"
source[0].citation = "Renters Insurance Consumer Guide"
source[0].url = "https://content.naic.org/insurance-topics/homeowners-insurance"

source[1].authority = "Texas Department of Insurance"
source[1].citation = "Renters Insurance Information"
source[1].url = "https://tdi.texas.gov/pubs/consumer/cb025.html"

source[2].authority = "California Department of Insurance"
source[2].citation = "Renter's Insurance Information"
source[2].url = "https://www.insurance.ca.gov/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Renters insurance schema based on HO-4 form and state regulatory requirements"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial renters insurance policy schema"
changelog[0].rationale = "Coverage-centric architecture - renters policy composition"

; ═══════════════════════════════════════════════════════════════════════════════
; Renters Personal Property Coverage (Coverage C - Primary Coverage)
; ═══════════════════════════════════════════════════════════════════════════════

{@renters_personal_property_coverage}
= @homeowners_coverage

coverage_type_ref = "HO4_C"

; Personal property limit (primary limit for renters)
personal_property_limit = #$:(0..)

; Coverage type
peril_type = (named_perils, open_perils)
named_perils_count = ##:(10..20)

; Loss settlement
loss_settlement = (
    actual_cash_value,
    replacement_cost
)

; Replacement cost endorsement
replacement_cost_endorsement = ?
replacement_cost_premium = #$:(0..):if replacement_cost_endorsement = true

; ───────────────────────────────────────────────────────────────────────────────
; Special Limits of Liability (sublimits)
; ───────────────────────────────────────────────────────────────────────────────
{.special_limits}
= @res.res_special_limits

{@renters_personal_property_coverage}

; Off-premises coverage
off_premises_coverage = ?
off_premises_limit = #$:(0..):if off_premises_coverage = true
off_premises_worldwide = ?                       ; Coverage while traveling

; Student property away at school
student_property_covered = ?
student_property_limit = #$:(0..):if student_property_covered = true

; Property in storage
storage_unit_coverage = ?
storage_unit_limit = #$:(0..):if storage_unit_coverage = true

; ═══════════════════════════════════════════════════════════════════════════════
; Renters Loss of Use Coverage (Coverage D)
; ═══════════════════════════════════════════════════════════════════════════════

{@renters_loss_of_use_coverage}
= @res.res_loss_of_use

; Renter-specific coverage type reference
coverage_type_ref = "HO4_D"

; Override percentage terminology for renters (based on Coverage C)
percentage_of_coverage_c = ##:(0..100)

; ═══════════════════════════════════════════════════════════════════════════════
; Renters Personal Liability (Coverage E)
; ═══════════════════════════════════════════════════════════════════════════════

{@renters_liability_coverage}
= @res.res_liability

; Renter-specific coverage type reference
coverage_type_ref = "HO4_E"

; ═══════════════════════════════════════════════════════════════════════════════
; Renters Medical Payments (Coverage F)
; ═══════════════════════════════════════════════════════════════════════════════

{@renters_medical_payments_coverage}
= @res.res_medical_payments

; Renter-specific coverage type reference
coverage_type_ref = "HO4_F"

; ═══════════════════════════════════════════════════════════════════════════════
; Renter Named Insured
; ═══════════════════════════════════════════════════════════════════════════════

{@renter_insured}
= @res.res_named_insured

; Renter-specific fields
; Additional named insureds (roommates)
additional_insureds[] = :

; Employment (may affect rating)
occupation = :
employer = :

; ═══════════════════════════════════════════════════════════════════════════════
; Rental Unit Information
; ═══════════════════════════════════════════════════════════════════════════════

{@rental_unit}
unit_id = :

; ───────────────────────────────────────────────────────────────────────────────
; Address - uses shared @address type (US and Canada)
; ───────────────────────────────────────────────────────────────────────────────
address = @address
unit_number = :

{@rental_unit}

; ───────────────────────────────────────────────────────────────────────────────
; Unit Type
; ───────────────────────────────────────────────────────────────────────────────
unit_type = (
    apartment,
    basement_apartment,
    condominium,
    duplex,
    house,
    loft,
    mobile_home,
    room,
    studio,
    townhouse
)

floor_number = ##:(0..)
total_floors_in_building = ##:(1..)

; Unit characteristics
square_feet = ##:(0..)
bedroom_count = ##:(0..)
bathroom_count = #:(0..20)

; ───────────────────────────────────────────────────────────────────────────────
; Occupancy
; ───────────────────────────────────────────────────────────────────────────────
lease_start_date = date
lease_end_date = date
monthly_rent = #$:(0..)
security_deposit = #$:(0..)

roommate_count = ##:(0..)
roommates_have_own_insurance = ?

; ───────────────────────────────────────────────────────────────────────────────
; Building Information
; ───────────────────────────────────────────────────────────────────────────────
{.building}
year_built = ##:(1600..)
construction_type = (brick, concrete, frame, masonry, mixed, steel)
total_units_in_building = ##:(1..)
elevator = ?
doorman = ?
security = ?
gated_community = ?

{@rental_unit}

; Fire protection
{.fire_protection}
= @res.res_fire_protection

{@rental_unit}

; Security
{.security}
= @res.res_security

{@rental_unit}

; Protection class
protection_class = ##:(1..10)

; ───────────────────────────────────────────────────────────────────────────────
; Special Considerations
; ───────────────────────────────────────────────────────────────────────────────
pets = ?
pet_types[] = ::if pets = true
dog_breed = ::if pets = true
dog_bite_history = ?:if pets = true

home_business = ?
home_business_type = ::if home_business = true

trampoline = ?
swimming_pool_access = ?

; ═══════════════════════════════════════════════════════════════════════════════
; Scheduled Personal Property
; ═══════════════════════════════════════════════════════════════════════════════

{@renters_scheduled_property}
= @res.res_scheduled_item

; ═══════════════════════════════════════════════════════════════════════════════
; Renters Endorsements
; ═══════════════════════════════════════════════════════════════════════════════

{@renters_endorsement}
= @res.res_endorsement

; Renter-specific endorsement types
endorsement_type = (earthquake, flood, identity_theft, increased_liability, increased_medical, jewelry_coverage, other, personal_injury, pet_damage, replacement_cost_contents, scheduled_property, water_backup, wedding_gifts)

; ═══════════════════════════════════════════════════════════════════════════════
; Renters Policy (HO-4)
; ═══════════════════════════════════════════════════════════════════════════════

{@renters_policy}
id = :
number = :

; ───────────────────────────────────────────────────────────────────────────────
; Policy Form
; ───────────────────────────────────────────────────────────────────────────────
policy_form = "HO4"
policy_form_edition = :

; ───────────────────────────────────────────────────────────────────────────────
; Policy Term
; ───────────────────────────────────────────────────────────────────────────────
effective_date = date
effective_time = time
expiration_date = date
expiration_time = time
:invariant expiration_date > effective_date

term_months = ##:(1..)

; ───────────────────────────────────────────────────────────────────────────────
; Transaction
; ───────────────────────────────────────────────────────────────────────────────
{.transaction}
= @res.res_transaction

{@renters_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Named Insured
; ───────────────────────────────────────────────────────────────────────────────
named_insureds[] = @renter_insured

; ───────────────────────────────────────────────────────────────────────────────
; Rental Unit
; ───────────────────────────────────────────────────────────────────────────────
rental_unit = @rental_unit

; ───────────────────────────────────────────────────────────────────────────────
; Coverages (NO Coverage A or B - tenant doesn't insure building)
; ───────────────────────────────────────────────────────────────────────────────
; Coverage C - Personal Property (PRIMARY)
coverage_c = @renters_personal_property_coverage

; Coverage D - Loss of Use
coverage_d = @renters_loss_of_use_coverage

; Coverage E - Personal Liability
coverage_e = @renters_liability_coverage

; Coverage F - Medical Payments
coverage_f = @renters_medical_payments_coverage

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Summary (Quick Reference)
; ───────────────────────────────────────────────────────────────────────────────
{.coverage_summary}
personal_property_limit = #$:(0..)               ; Coverage C
loss_of_use_limit = #$:(0..)                     ; Coverage D
liability_limit = #$:(0..)                       ; Coverage E
medical_payments_limit = #$:(0..)                ; Coverage F

{@renters_policy}


; ───────────────────────────────────────────────────────────────────────────────
; Deductibles
; ───────────────────────────────────────────────────────────────────────────────
standard_deductible = #$:(0..)
hurricane_deductible = #$:(0..)

; ───────────────────────────────────────────────────────────────────────────────
; Scheduled Property
; ───────────────────────────────────────────────────────────────────────────────
scheduled_property[] = @renters_scheduled_property

; ───────────────────────────────────────────────────────────────────────────────
; Endorsements
; ───────────────────────────────────────────────────────────────────────────────
endorsements[] = @renters_endorsement

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
= @res.res_premium

{@renters_policy}

; Payment
{.payment}
= @res.res_payment_plan

{@renters_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Prior Claims
; ───────────────────────────────────────────────────────────────────────────────
{@renters_policy.prior_claims[]}
= @res.res_prior_claim

{@renters_policy}

claims_free_years = ##:(0..)

; ───────────────────────────────────────────────────────────────────────────────
; Agency/Producer
; ───────────────────────────────────────────────────────────────────────────────
agency = @agency
producer = @producer

{@renters_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Underwriting
; ───────────────────────────────────────────────────────────────────────────────
{.underwriting}
= @res.res_underwriting

{@renters_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
{.status}
= @res.res_policy_status

{@renters_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Landlord Requirements
; ───────────────────────────────────────────────────────────────────────────────
landlord_requires_insurance = ?
landlord_minimum_liability = #$:(0..):if landlord_requires_insurance = true
landlord_as_additional_interest = ?
landlord_name = ::if landlord_as_additional_interest = true
landlord_address = @address:if landlord_as_additional_interest = true


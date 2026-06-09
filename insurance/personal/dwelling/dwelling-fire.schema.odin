; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Dwelling Fire Policy Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Dwelling fire policy for owner-occupied, tenant-occupied, and vacant properties
; covering dwelling, other structures, personal property, fair rental value,
; and liability in DP-1, DP-2, and DP-3 forms.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../coverages/coverage.schema.odin" as cov
@import "../../coverages/lines/homeowners.schema.odin" as ho
@import "../../common/types.schema.odin" as types
@import "../../common/party.schema.odin" as party
@import "../residential-types.schema.odin" as res

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.dwelling.dwelling-fire"
version = "1.0.0"
title = "Dwelling Fire Policy Schema"
description = "Dwelling fire policy for non-owner-occupied properties"

{$derivation}
source[0].authority = "North Carolina Department of Insurance"
source[0].citation = "Dwelling Policies"
source[0].url = "https://www.ncdoi.gov/consumers/homeowners-insurance/dwelling-policies"

source[1].authority = "Texas Department of Insurance"
source[1].citation = "Dwelling Fire Insurance"
source[1].url = "https://tdi.texas.gov/pubs/consumer/cb025.html"

source[2].authority = "South Carolina Department of Insurance"
source[2].citation = "Understanding Dwelling Policies"
source[2].url = "https://doi.sc.gov/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Dwelling fire policy schema based on state regulatory requirements"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial dwelling fire policy schema"
changelog[0].rationale = "Coverage-centric architecture - dwelling fire policy composition"

; ═══════════════════════════════════════════════════════════════════════════════
; Dwelling Fire Coverage (Extends homeowners coverage with DP-specific options)
; ═══════════════════════════════════════════════════════════════════════════════

{@dp_dwelling_coverage}
= @homeowners_coverage

coverage_type_ref = "DP_DWELLING"

; Dwelling limit
dwelling_limit = #$:(0..)

dwelling_loss_settlement = (
    actual_cash_value,
    functional_replacement,
    replacement_cost
)

coinsurance_percent = ##:(0..100)
coinsurance_waiver = ?

rental_income_coverage = ?
rental_income_limit = #$:(0..):if rental_income_coverage = true
rental_income_time_limit_months = ##:(0..):if rental_income_coverage = true

; Fair rental value
fair_rental_value = ?
fair_rental_value_limit = #$:(0..):if fair_rental_value = true

; ═══════════════════════════════════════════════════════════════════════════════
; Dwelling Fire Other Structures
; ═══════════════════════════════════════════════════════════════════════════════

{@dp_other_structures_coverage}
= @homeowners_coverage

coverage_type_ref = "DP_OTHER_STRUCTURES"

other_structures_limit = #$:(0..)
percentage_of_coverage_a = ##:(0..100)

; ═══════════════════════════════════════════════════════════════════════════════
; Dwelling Fire Personal Property (Limited Coverage)
; ═══════════════════════════════════════════════════════════════════════════════

{@dp_personal_property_coverage}
= @homeowners_coverage

coverage_type_ref = "DP_PERSONAL_PROPERTY"

personal_property_limit = #$:(0..)
percentage_of_coverage_a = ##:(0..100)

; Coverage type
contents_coverage_type = (
    landlord_contents,
    none,
    tenant_contents
)

; ═══════════════════════════════════════════════════════════════════════════════
; Dwelling Fire Liability (Optional - NOT included by default)
; ═══════════════════════════════════════════════════════════════════════════════

{@dp_coverage_e}
= @res.res_liability

; DP-specific: liability NOT included by default
liability_included = ?

; Premises liability endorsement number
liability_endorsement = ::if liability_included = true

{@dp_coverage_f}
= @res.res_medical_payments

; DP-specific: medical payments NOT included by default
medical_payments_included = ?

; ═══════════════════════════════════════════════════════════════════════════════
; Dwelling Fire Named Insured
; ═══════════════════════════════════════════════════════════════════════════════

{@dp_named_insured}
= @res.res_named_insured

; DP-specific: owner type (entity vs individual)
owner_type = (corporation, estate, individual, joint_owners, llc, partnership, trust)

; Entity owner fields
entity_name = ::if owner_type != individual
ein = ::if owner_type != individual

; Multiple owners
additional_insureds[] = :

; ═══════════════════════════════════════════════════════════════════════════════
; Dwelling Fire Property
; ═══════════════════════════════════════════════════════════════════════════════

{@dp_dwelling}
dwelling_id = :

; ───────────────────────────────────────────────────────────────────────────────
; Property Address - uses shared @address type (US and Canada)
; ───────────────────────────────────────────────────────────────────────────────
address = @address

{@dp_dwelling}

; Coordinates
latitude = #:(-90..90)
longitude = #:(-180..180)

; ───────────────────────────────────────────────────────────────────────────────
; Occupancy (Key for Dwelling Fire)
; ───────────────────────────────────────────────────────────────────────────────
occupancy_type = (
    owner_occupied_not_primary,                  ; Secondary home, vacation home
    seasonal,                                    ; Occupied only part of year
    tenant_occupied,                             ; Rented to tenants (landlord policy)
    vacant                                       ; Currently unoccupied
)

; Rental details
rental_property = ?
rental_unit_count = ##:(1..):if rental_property = true
monthly_rental_income = #$:(0..):if rental_property = true
annual_rental_income = #$:(0..):if rental_property = true
tenant_occupied = ?:if rental_property = true

; Vacancy
vacant = ?
days_vacant = ##:(0..):if vacant = true
vacancy_permit = ?:if vacant = true

; Seasonal use
seasonal = ?
months_occupied = ##:(0..12):if seasonal = true

; ───────────────────────────────────────────────────────────────────────────────
; Dwelling Type
; ───────────────────────────────────────────────────────────────────────────────
dwelling_type = (
    condominium,
    duplex,
    fourplex,
    manufactured_home,
    mobile_home,
    multi_family,
    rooming_house,
    single_family,
    townhouse,
    triplex
)

unit_count = ##:(1..)
story_count = #:(0..10)

; ───────────────────────────────────────────────────────────────────────────────
; Construction
; ───────────────────────────────────────────────────────────────────────────────
construction = @res.res_construction

{@dp_dwelling}

; ───────────────────────────────────────────────────────────────────────────────
; Roof
; ───────────────────────────────────────────────────────────────────────────────
roof = @res.res_roof

{@dp_dwelling}

; ───────────────────────────────────────────────────────────────────────────────
; Systems
; ───────────────────────────────────────────────────────────────────────────────
heating = @res.res_heating
plumbing = @res.res_plumbing
electrical = @res.res_electrical

{@dp_dwelling}

; ───────────────────────────────────────────────────────────────────────────────
; Protection Class
; ───────────────────────────────────────────────────────────────────────────────
protection = @res.res_protection_class

; DP-specific: subscription service common in rural areas
fire_department_subscription = ?

; ───────────────────────────────────────────────────────────────────────────────
; Valuation
; ───────────────────────────────────────────────────────────────────────────────
valuation = @res.res_valuation

{@dp_dwelling}

; ═══════════════════════════════════════════════════════════════════════════════
; Dwelling Fire Endorsements
; ═══════════════════════════════════════════════════════════════════════════════

{@dp_endorsement}
= @res.res_endorsement

; DP-specific endorsement types
endorsement_type = (broad_theft, building_code_upgrade, earthquake, extended_coverage, fair_rental_value, flood, inflation_guard, liability, loss_of_rents, other, replacement_cost_contents, replacement_cost_dwelling, vandalism_malicious_mischief, water_backup)

; ═══════════════════════════════════════════════════════════════════════════════
; Dwelling Fire Policy
; ═══════════════════════════════════════════════════════════════════════════════

{@dwelling_policy}
id = :
number = :

; ───────────────────────────────────────────────────────────────────────────────
; Policy Form
; ───────────────────────────────────────────────────────────────────────────────
policy_form = (
    DP1,                                         ; Basic Dwelling Form
    DP2,                                         ; Broad Dwelling Form
    DP3                                          ; Special Dwelling Form
)

policy_form_edition = :

dwelling_coverage_type = (named_perils, open_perils)
contents_coverage_type = (named_perils, none)

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
transaction = @res.res_transaction

; ───────────────────────────────────────────────────────────────────────────────
; Named Insured (Property Owner)
; ───────────────────────────────────────────────────────────────────────────────
named_insureds[] = @dp_named_insured

; ───────────────────────────────────────────────────────────────────────────────
; Insured Dwelling
; ───────────────────────────────────────────────────────────────────────────────
dwelling = @dp_dwelling

; ───────────────────────────────────────────────────────────────────────────────
; Coverages
; ───────────────────────────────────────────────────────────────────────────────
; Coverage A - Dwelling
coverage_a = @dp_dwelling_coverage

; Coverage B - Other Structures
coverage_b = @dp_other_structures_coverage

; Coverage C - Personal Property
coverage_c = @dp_personal_property_coverage

; Coverage E - Liability (Optional)
coverage_e = @dp_coverage_e

; Coverage F - Medical Payments (Optional)
coverage_f = @dp_coverage_f

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Summary
; ───────────────────────────────────────────────────────────────────────────────
{.coverage_summary}
coverage_a_limit = #$:(0..)
coverage_b_limit = #$:(0..)
coverage_c_limit = #$:(0..)
rental_income_limit = #$:(0..)
liability_limit = #$:(0..)
medical_payments_limit = #$:(0..)

{@dwelling_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Deductibles
; ───────────────────────────────────────────────────────────────────────────────
standard_deductible = #$:(0..)
hurricane_deductible = #$:(0..)
hurricane_deductible_percent = #:(0..100)
wind_hail_deductible = #$:(0..)

; ───────────────────────────────────────────────────────────────────────────────
; Endorsements
; ───────────────────────────────────────────────────────────────────────────────
endorsements[] = @dp_endorsement

; ───────────────────────────────────────────────────────────────────────────────
; Mortgagee
; ───────────────────────────────────────────────────────────────────────────────
{@dwelling_policy.mortgagees[]}
= @res.res_mortgagee

{@dwelling_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
premium = @res.res_premium

{@dwelling_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Payment Plan
; ───────────────────────────────────────────────────────────────────────────────
payment_plan = @res.res_payment_plan

{@dwelling_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Underwriting
; ───────────────────────────────────────────────────────────────────────────────
underwriting = @res.res_underwriting

{@dwelling_policy}

; DP-specific underwriting considerations
vacancy_permit_issued = ?
seasonal_permit_issued = ?
property_management_company = :

{@dwelling_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Agency/Producer
; ───────────────────────────────────────────────────────────────────────────────
agency = @agency
producer = @producer

{@dwelling_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = @res.res_policy_status


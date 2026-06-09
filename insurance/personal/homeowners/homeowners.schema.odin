; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Homeowners Policy Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Homeowners policy covering HO-1 through HO-8 forms including dwelling (Coverage
; A), other structures (B), personal property (C), loss of use (D), personal
; liability (E), and medical payments (F).
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../coverages/coverage.schema.odin" as cov
@import "../../coverages/lines/homeowners.schema.odin" as ho
@import "../../common/types.schema.odin" as types
@import "../../common/party.schema.odin" as party
@import "../residential-types.schema.odin" as res

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.homeowners"
version = "1.0.0"
title = "Homeowners Policy Schema"
description = "Comprehensive homeowners policy extending homeowners coverage primitives"

{$derivation}
source[0].authority = "National Association of Insurance Commissioners (NAIC)"
source[0].citation = "Homeowners Insurance Industry Data Call"
source[0].url = "https://content.naic.org/insurance-topics/homeowners-insurance"

source[1].authority = "Texas Department of Insurance"
source[1].citation = "Home Insurance Guide"
source[1].url = "https://tdi.texas.gov/pubs/consumer/cb025.html"

source[2].authority = "North Carolina Department of Insurance"
source[2].citation = "Consumer Guide to Homeowners Insurance"
source[2].url = "https://www.ncdoi.gov/consumers/homeowners-insurance"

source[3].authority = "Virginia Administrative Code"
source[3].citation = "14VAC5-342 Homeowner's Policy Standards"
source[3].url = "https://law.lis.virginia.gov/admincode/title14/agency5/chapter342/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Homeowners policy schema based on NAIC data definitions and state regulatory requirements"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial homeowners policy schema"
changelog[0].rationale = "Coverage-centric architecture - homeowners policy composition"

; ═══════════════════════════════════════════════════════════════════════════════
; Named Insured
; ═══════════════════════════════════════════════════════════════════════════════

{@ho_named_insured}
= @res.res_named_insured

; HO-specific extensions
prior_residence_address = @address           ; Previous residence address

; ═══════════════════════════════════════════════════════════════════════════════
; Protection Devices
; ═══════════════════════════════════════════════════════════════════════════════

{@ho_protection_devices}
fire_protection = @res.res_fire_protection
security = @res.res_security

; ═══════════════════════════════════════════════════════════════════════════════
; Scheduled Personal Property
; ═══════════════════════════════════════════════════════════════════════════════

{@ho_scheduled_property}
= @res.res_scheduled_item

; ═══════════════════════════════════════════════════════════════════════════════
; Deductible
; ═══════════════════════════════════════════════════════════════════════════════

{@ho_deductible}
; Required fields first
deductible_type = (all_other_perils, earthquake, flood, hurricane, named_storm, water_damage, wind_hail)  ; Type of peril this deductible applies to

; Optional fields
applies_to_coverage = :                      ; Coverage this deductible applies to
deductible_amount = #$                       ; Flat dollar deductible amount
deductible_percent = #                       ; Percentage-based deductible

; ═══════════════════════════════════════════════════════════════════════════════
; Exclusions
; ═══════════════════════════════════════════════════════════════════════════════

{@ho_exclusions}
earth_movement = ?                           ; Earth movement exclusion applied
flood = ?                                    ; Flood exclusion applied
government_action = ?                        ; Government action exclusion applied
intentional_loss = ?                         ; Intentional loss exclusion applied
mold_fungi_bacteria = ?                      ; Mold/fungi/bacteria exclusion applied
neglect = ?                                  ; Neglect exclusion applied
nuclear_hazard = ?                           ; Nuclear hazard exclusion applied
ordinance_law = ?                            ; Ordinance or law exclusion applied
power_failure = ?                            ; Power failure exclusion applied
war = ?                                      ; War exclusion applied
water_damage = ?                             ; Water damage exclusion applied

; ═══════════════════════════════════════════════════════════════════════════════
; Coverage D - Loss of Use
; ═══════════════════════════════════════════════════════════════════════════════

{@ho_loss_of_use_coverage}
= @res.res_loss_of_use

; ═══════════════════════════════════════════════════════════════════════════════
; Coverage E - Personal Liability
; ═══════════════════════════════════════════════════════════════════════════════

{@ho_personal_liability_coverage}
= @res.res_liability

; ═══════════════════════════════════════════════════════════════════════════════
; Coverage F - Medical Payments
; ═══════════════════════════════════════════════════════════════════════════════

{@ho_medical_payments_coverage}
= @res.res_medical_payments

; ═══════════════════════════════════════════════════════════════════════════════
; Insured Location (Property Address)
; ═══════════════════════════════════════════════════════════════════════════════

{@ho_insured_location}
; Required fields first
location_number = ##:(1..)                  ; Location sequence number

; Optional fields
address = @address                           ; Property physical address
assessor_parcel_number = :                   ; Tax assessor parcel number
latitude = #:(-90..90)                       ; GPS latitude coordinate
legal_description = :                        ; Legal property description
location_id = :                              ; Unique location identifier
longitude = #:(-180..180)                    ; GPS longitude coordinate

; ═══════════════════════════════════════════════════════════════════════════════
; Dwelling Characteristics
; ═══════════════════════════════════════════════════════════════════════════════

{@ho_dwelling}
; Required fields first
dwelling_type = (condominium, cooperative, duplex, manufactured_home, mobile_home, modular_home, multi_family, row_house, single_family, townhouse, triplex)  ; Type of dwelling structure

; Optional fields
dwelling_id = :                              ; Unique dwelling identifier
location_ref = :                             ; Reference to @ho_insured_location
occupancy = @res.res_occupancy               ; Occupancy information

; ───────────────────────────────────────────────────────────────────────────────
; HO-specific occupancy fields
; ───────────────────────────────────────────────────────────────────────────────
family_count = ##                            ; Number of families residing
unit_count = ##                              ; Number of dwelling units

; ───────────────────────────────────────────────────────────────────────────────
; Construction Details
; ───────────────────────────────────────────────────────────────────────────────
construction = @res.res_construction

; HO-specific construction fields
{@ho_dwelling}
exterior_wall = (aluminum_siding, asbestos_shingle, brick, cement_fiber, clapboard, hardboard, log, other, stone, stucco, vinyl_siding, wood_shingle)  ; Exterior wall material
frame_type = (balloon_frame, log_construction, other, platform_frame, post_and_beam, steel_frame, timber_frame)  ; Frame construction type

; ───────────────────────────────────────────────────────────────────────────────
; Foundation
; ───────────────────────────────────────────────────────────────────────────────
foundation = @res.res_foundation

; ───────────────────────────────────────────────────────────────────────────────
; Roof
; ───────────────────────────────────────────────────────────────────────────────
roof = @res.res_roof

{@ho_dwelling}

; ───────────────────────────────────────────────────────────────────────────────
; Size and Layout
; ───────────────────────────────────────────────────────────────────────────────
{.dimensions}
total_square_feet = ##                      ; Total dwelling square footage
bathroom_count = #                           ; Number of bathrooms (can be fractional)
bedroom_count = ##                           ; Number of bedrooms
finished_square_feet = ##                    ; Finished square footage
fireplace_count = ##                         ; Number of fireplaces
kitchen_count = ##                           ; Number of kitchens
living_square_feet = ##                      ; Living area square footage
room_count = ##                              ; Total number of rooms
stories = #                                  ; Number of stories

{@ho_dwelling}
lot_size_acres = #                           ; Lot size in acres
lot_size_square_feet = ##                    ; Lot size in square feet

; ───────────────────────────────────────────────────────────────────────────────
; Systems and Utilities
; ───────────────────────────────────────────────────────────────────────────────
heating = @res.res_heating

; HO-specific heating fields
{@ho_dwelling}
supplemental_heating = :                     ; Supplemental heating description
thermostatically_controlled = ?              ; Thermostat-controlled heating system

cooling = @res.res_cooling
electrical = @res.res_electrical
plumbing = @res.res_plumbing

; ───────────────────────────────────────────────────────────────────────────────
; Special Features and Hazards
; ───────────────────────────────────────────────────────────────────────────────
special_features = @res.res_special_features

; HO-specific special features
{@ho_dwelling}
detached_structure_count = ##                ; Number of detached structures
pool_slide = ?:if special_features.swimming_pool = true  ; Swimming pool has slide

; ───────────────────────────────────────────────────────────────────────────────
; Building Improvements
; ───────────────────────────────────────────────────────────────────────────────
{.improvements}
addition_square_feet = ##                    ; Square footage of addition
addition_year = ##:if addition_square_feet > 0  ; Year addition completed
bathroom_remodel = ?                         ; Bathroom remodel completed
bathroom_remodel_year = ##:if bathroom_remodel = true  ; Year bathroom remodel completed
kitchen_remodel = ?                          ; Kitchen remodel completed
kitchen_remodel_year = ##:if kitchen_remodel = true  ; Year kitchen remodel completed

{@ho_dwelling}

; ───────────────────────────────────────────────────────────────────────────────
; Valuation
; ───────────────────────────────────────────────────────────────────────────────
valuation = @res.res_valuation               ; Valuation information

; HO-specific valuation fields
{@ho_dwelling}
architecturally_significant = ?              ; Home is architecturally significant
historic_home = ?                            ; Home is historically significant
historic_registry = :if historic_home = true ; Historic registry name

; ═══════════════════════════════════════════════════════════════════════════════
; Mortgagee / Lienholder
; ═══════════════════════════════════════════════════════════════════════════════

{@ho_mortgagee}
= @res.res_mortgagee

; ═══════════════════════════════════════════════════════════════════════════════
; Other Structures Detail
; ═══════════════════════════════════════════════════════════════════════════════

{@ho_other_structure}
; Required fields first
structure_type = (barn, carport, detached_garage, fence, gazebo, greenhouse, guest_house, other, pool_house, retaining_wall, shed, stable, studio, workshop)  ; Type of other structure

; Optional fields
business_use = ?                             ; Structure used for business
condition = (excellent, fair, good, poor)    ; Physical condition assessment
construction_type = :                        ; Construction material/method
description = :                              ; Structure description
location_ref = :                             ; Reference to location
rental_use = ?                               ; Structure rented to others
square_feet = ##                             ; Structure square footage
structure_id = :                             ; Unique structure identifier
value = #$                                   ; Estimated structure value
year_built = ##                              ; Year structure was built

; ═══════════════════════════════════════════════════════════════════════════════
; Claims History
; ═══════════════════════════════════════════════════════════════════════════════

{@ho_prior_claim}
= @res.res_prior_claim

; ═══════════════════════════════════════════════════════════════════════════════
; Homeowners Endorsements
; ═══════════════════════════════════════════════════════════════════════════════

{@ho_endorsement}
= @res.res_endorsement

; HO-specific endorsement types (alphabetical)
endorsement_type = (animal_liability, building_code_upgrade, business_pursuits, earthquake, equipment_breakdown, extended_replacement_cost, flood, guaranteed_replacement_cost, home_business, home_sharing, identity_theft, incidental_business, inflation_guard, mold_coverage, ordinance_law, other, personal_injury, personal_property_replacement_cost, scheduled_personal_property, service_line, sinkhole, special_computer, umbrella_increase, water_backup, watercraft, workers_compensation_residence_employees)  ; Type of endorsement

; ═══════════════════════════════════════════════════════════════════════════════
; Homeowners Policy (Composes All Components)
; ═══════════════════════════════════════════════════════════════════════════════

{@homeowners_policy}
; Required fields first
effective_date = date                       ; Policy effective date
expiration_date = date                      ; Policy expiration date
policy_form = (HO1, HO2, HO3, HO4, HO5, HO6, HO7, HO8)  ; Policy form type
policy_number = :                           ; Policy number

; Invariants
:invariant expiration_date > effective_date

; Optional fields
agency = @agency                             ; Agency information
commission_percent = #:(0..100)              ; Commission percentage
coverage_a = @ho_dwelling_coverage           ; Coverage A - Dwelling
coverage_b = @ho_other_structures_coverage   ; Coverage B - Other Structures
coverage_c = @ho_personal_property_coverage  ; Coverage C - Personal Property
coverage_d = @ho_loss_of_use_coverage        ; Coverage D - Loss of Use
coverage_e = @ho_personal_liability_coverage ; Coverage E - Personal Liability
coverage_f = @ho_medical_payments_coverage   ; Coverage F - Medical Payments
dwelling = @ho_dwelling                      ; Dwelling information
effective_time = time                        ; Policy effective time
endorsements[] = @ho_endorsement             ; Policy endorsements
exclusions = @ho_exclusions                  ; Exclusions applied
expiration_time = time                       ; Policy expiration time
id = :                                       ; Unique policy identifier
insured_locations[] = @ho_insured_location   ; Insured locations
mortgagees[] = @ho_mortgagee                 ; Mortgagees
named_insureds[] = @ho_named_insured         ; Named insureds
other_structures[] = @ho_other_structure     ; Other structures schedule
payment = @res.res_payment_plan              ; Payment plan
policy_form_edition = :                      ; Policy form edition date
policy_status = @res.res_policy_status       ; Policy status
policy_year = ##                             ; Policy year number
premium = @res.res_premium                   ; Premium information
prior_claims[] = @ho_prior_claim             ; Prior claims history
producer = @producer                         ; Producer information
protection_devices = @ho_protection_devices  ; Protection devices
scheduled_property[] = @ho_scheduled_property; Scheduled property
term_months = ##                             ; Policy term in months
transaction = @res.res_transaction           ; Transaction information
underwriting = @res.res_underwriting         ; Underwriting information

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Summary (nested)
; ───────────────────────────────────────────────────────────────────────────────
{.coverage_summary}
coverage_a_limit = #$                        ; Coverage A limit
coverage_b_limit = #$                        ; Coverage B limit
coverage_c_limit = #$                        ; Coverage C limit
coverage_d_limit = #$                        ; Coverage D limit
coverage_e_limit = #$                        ; Coverage E limit
coverage_f_limit = #$                        ; Coverage F limit

{@homeowners_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Deductibles (nested)
; ───────────────────────────────────────────────────────────────────────────────
hurricane_deductible_applies = ?             ; Hurricane deductible applies
claims_free_years = ##                       ; Years without claims
deductibles[] = @ho_deductible               ; Deductible details
hurricane_deductible = #$                    ; Hurricane deductible amount
hurricane_deductible_percent = #             ; Hurricane deductible percentage
other_discounts = #$                         ; Other policy discounts
standard_deductible = #$                     ; Standard deductible amount
total_prior_claims = ##                      ; Total count of prior claims


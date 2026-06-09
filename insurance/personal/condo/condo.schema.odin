; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Condo/Unit-Owners Insurance Schema (HO-6)
; ═══════════════════════════════════════════════════════════════════════════════
; Condo and unit-owners insurance (HO-6) covering walls-in property, personal
; property, loss assessment, improvements and betterments, and personal liability
; for condominium unit owners.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../coverages/coverage.schema.odin" as cov
@import "../../coverages/lines/homeowners.schema.odin" as ho
@import "../../common/types.schema.odin" as types
@import "../../common/party.schema.odin" as party
@import "../residential-types.schema.odin" as res

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.condo"
version = "1.0.0"
title = "Condo/Unit-Owners Insurance Schema (HO-6)"
description = "Comprehensive condo/unit-owners policy extending homeowners coverage primitives"

{$derivation}
source[0].authority = "National Association of Insurance Commissioners (NAIC)"
source[0].citation = "Homeowners Insurance Industry Data Call"
source[0].url = "https://content.naic.org/insurance-topics/homeowners-insurance"

source[1].authority = "Washington State Office of the Insurance Commissioner"
source[1].citation = "Learn How Condo Insurance Works"
source[1].url = "https://www.insurance.wa.gov/insurance-resources/condo-insurance/learn-how-condo-insurance-works"

source[2].authority = "Texas Department of Insurance"
source[2].citation = "Home Insurance Guide"
source[2].url = "https://tdi.texas.gov/pubs/consumer/cb025.html"

source[3].authority = "Florida Statutes"
source[3].citation = "627.714 - Condominium Association Insurance"
source[3].url = "http://www.leg.state.fl.us/statutes/"

source[4].authority = "Virginia Administrative Code"
source[4].citation = "14VAC5-342 Homeowner's Policy Standards"
source[4].url = "https://law.lis.virginia.gov/admincode/title14/agency5/chapter342/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "HO-6 condo policy schema based on NAIC data definitions, state regulatory requirements, and industry practices for condominium unit-owners insurance"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial HO-6 condo/unit-owners policy schema"
changelog[0].rationale = "Coverage-centric architecture - condo policy with HOA master policy coordination"

; ═══════════════════════════════════════════════════════════════════════════════
; HO-6 Specific Coverage Types
; ═══════════════════════════════════════════════════════════════════════════════

; ───────────────────────────────────────────────────────────────────────────────
; Coverage A - Unit-Owners Building Property (Improvements and Betterments)
; ───────────────────────────────────────────────────────────────────────────────

{@ho6_dwelling_coverage}
= @homeowners_coverage

coverage_section = "A"
coverage_type_ref = "HO6_A"

; Coverage A for condos is for additions, alterations, improvements to the unit
; Covers what's NOT covered by the HOA master policy (depends on master type)
dwelling_limit = #$:(0..)                           ; May be $0 if master policy is all-in

; Loss settlement
loss_settlement = (actual_cash_value, replacement_cost)

; Improvements and betterments detail
{.improvements_betterments}
covered = ?                                          ; Whether improvements and betterments are covered
description = :                                      ; What has been upgraded from original
kitchen_upgrades = ?                                 ; Whether kitchen has been upgraded
bathroom_upgrades = ?                                ; Whether bathrooms have been upgraded
flooring_upgrades = ?                                ; Whether flooring has been upgraded
fixtures_upgrades = ?                                ; Whether fixtures have been upgraded
built_ins = ?                                        ; Whether built-in features are included
appliances_upgrades = ?                              ; Whether appliances have been upgraded
interior_walls = ?                                   ; Whether interior walls have been modified
ceilings = ?                                         ; Whether ceilings have been modified
estimated_value = #$:(0..)                           ; Estimated value of all improvements

{@ho6_dwelling_coverage}

; Additions to the unit
{.additions}
addition_exists = ?                                  ; Whether additions to the unit exist
addition_description = ::if addition_exists = true   ; Description of the additions
addition_square_feet = ##:(0..):if addition_exists = true ; Square footage of additions
addition_year = ##:(1900..):if addition_exists = true ; Year additions were made
addition_value = #$:(0..):if addition_exists = true  ; Value of additions

{@ho6_dwelling_coverage}

; Fixtures permanently installed
{.fixtures}
light_fixtures = ?                                   ; Whether custom light fixtures are installed
ceiling_fans = ?                                     ; Whether ceiling fans are installed
built_in_cabinetry = ?                               ; Whether built-in cabinetry exists
countertops = ?                                      ; Whether custom countertops are installed
backsplash = ?                                       ; Whether custom backsplash is installed
bathroom_vanities = ?                                ; Whether custom bathroom vanities are installed
mirrors = ?                                          ; Whether custom mirrors are installed
shelving = ?                                         ; Whether custom shelving is installed

{@ho6_dwelling_coverage}

; Walls-in coverage coordination
walls_in_coverage = ?                               ; Unit owner responsible for walls inward
unit_owner_responsible_items[] = :                   ; List what unit owner must insure

; ───────────────────────────────────────────────────────────────────────────────
; Loss Assessment Coverage (CRITICAL FOR CONDOS)
; ───────────────────────────────────────────────────────────────────────────────

{@ho6_loss_assessment_coverage}
= @homeowners_coverage

coverage_section = "loss_assessment"
coverage_type_ref = "HO6_LOSS_ASSESSMENT"

; Loss assessment coverage protects against special assessments from HOA
; when master policy limits are exceeded or deductibles are high
loss_assessment_limit = #$:(0..)                   ; Common: $1,000 to $50,000
standard_limit = #$:(0..)                           ; Base coverage (typically $1,000)
additional_limit_purchased = #$:(0..)               ; Additional coverage purchased

; Coverage applies to
{.applies_to}
property_loss_assessment = ?                         ; Property damage exceeding master policy
liability_loss_assessment = ?                        ; Liability claims exceeding master policy
master_policy_deductible = ?                         ; HOA passes deductible to unit owner
uninsured_common_area_loss = ?                       ; Loss not covered by master policy

{@ho6_loss_assessment_coverage}

; Exclusions
{.exclusions}
routine_maintenance_excluded = ?true                 ; Not for regular upkeep
voluntary_assessments_excluded = ?true               ; Not for voluntary improvements
pre_existing_conditions = ?                          ; Assessments known before policy inception

{@ho6_loss_assessment_coverage}

; Peril limitations (matches unit owner policy perils)
limited_to_covered_perils = ?                        ; Whether coverage is limited to covered perils

; ───────────────────────────────────────────────────────────────────────────────
; Coverage C - Personal Property (Primary Coverage for Condos)
; ───────────────────────────────────────────────────────────────────────────────

{@ho6_personal_property_coverage}
= @homeowners_coverage

coverage_section = "C"
coverage_type_ref = "HO6_C"

; Personal property limit (this is the primary coverage for most condo owners)
personal_property_limit = #$:(0..)

; Loss settlement
loss_settlement = (actual_cash_value, replacement_cost)

; Peril coverage (typically named perils, can be upgraded to open perils)
peril_type = (named_perils, open_perils)            ; Type of peril coverage
named_perils_count = ##:(10..20)                     ; Number of named perils covered

; Replacement cost endorsement
replacement_cost_endorsement = ?                     ; Whether replacement cost endorsement is included
replacement_cost_premium = #$:(0..):if replacement_cost_endorsement = true ; Premium for replacement cost coverage

; Special Limits of Liability (sublimits)
special_limits = @res.res_special_limits             ; Special limits for high-value items

; Off-premises coverage
off_premises_coverage = ?                            ; Whether off-premises coverage is included
off_premises_limit = #$:(0..):if off_premises_coverage = true ; Coverage limit for off-premises property
off_premises_worldwide = ?                           ; Whether off-premises coverage applies worldwide

; Storage unit coverage
storage_unit_coverage = ?                            ; Whether storage unit coverage is included
storage_unit_limit = #$:(0..):if storage_unit_coverage = true ; Coverage limit for storage unit contents

; ───────────────────────────────────────────────────────────────────────────────
; Coverage D - Loss of Use
; ───────────────────────────────────────────────────────────────────────────────

{@ho6_loss_of_use_coverage}
= @res.res_loss_of_use
; HO-6 specific: Loss of use when unit is uninhabitable

; ───────────────────────────────────────────────────────────────────────────────
; Coverage E - Personal Liability
; ───────────────────────────────────────────────────────────────────────────────

{@ho6_personal_liability_coverage}
= @res.res_liability
; HO-6 specific: Standard personal liability coverage

; ───────────────────────────────────────────────────────────────────────────────
; Coverage F - Medical Payments to Others
; ───────────────────────────────────────────────────────────────────────────────

{@ho6_medical_payments_coverage}
= @res.res_medical_payments
; HO-6 specific: Standard medical payments coverage

; ═══════════════════════════════════════════════════════════════════════════════
; Condo Unit Owner (Named Insured)
; ═══════════════════════════════════════════════════════════════════════════════

{@ho6_named_insured}
= @res.res_named_insured
; HO-6 specific: Standard named insured structure

{@ho6_named_insured}
; Prior insurance specific to HO-6
prior_insurance = @res.res_prior_insurance

; ═══════════════════════════════════════════════════════════════════════════════
; Condominium Unit Information
; ═══════════════════════════════════════════════════════════════════════════════

{@condo_unit}
unit_id = :                                          ; Unique identifier for the unit
unit_number = :                                     ; Unit number

; ───────────────────────────────────────────────────────────────────────────────
; Address - uses shared @address type (US and Canada)
; ───────────────────────────────────────────────────────────────────────────────
address = @address                                   ; Unit address

{@condo_unit}

; Unit location within building
building_name = :                                    ; Name of the building
building_number = :                                  ; Building number within complex
floor_number = ##:(0..)                              ; 0 = ground floor
wing_section = :                                     ; Building section/wing identifier

; Geographic location
latitude = #:(-90..90)                               ; Geographic latitude coordinate
longitude = #:(-180..180)                            ; Geographic longitude coordinate

assessor_parcel_number = :                           ; Tax assessor's parcel number
legal_description = :                                ; Legal property description

; ───────────────────────────────────────────────────────────────────────────────
; Ownership Type
; ───────────────────────────────────────────────────────────────────────────────
ownership_type = (cooperative, fee_simple, leasehold, timeshare) ; Type of unit ownership

; Occupancy
occupancy = @res.res_occupancy                       ; Occupancy details

{@condo_unit}

; ───────────────────────────────────────────────────────────────────────────────
; Unit Characteristics
; ───────────────────────────────────────────────────────────────────────────────
{.unit_characteristics}
total_square_feet = ##:(0..)                        ; Total square footage of unit
living_square_feet = ##:(0..)                        ; Living square footage
room_count = ##:(0..)                                ; Total number of rooms
bedroom_count = ##:(0..)                             ; Number of bedrooms
bathroom_count = #:(0..20)                           ; Number of bathrooms
kitchen_count = ##:(0..)                             ; Number of kitchens
fireplace_count = ##:(0..)                           ; Number of fireplaces

{@condo_unit}

; Unit features
balcony = ?                                          ; Whether unit has a balcony
balcony_square_feet = ##:(0..):if balcony = true     ; Square footage of balcony
patio = ?                                            ; Whether unit has a patio
patio_square_feet = ##:(0..):if patio = true         ; Square footage of patio
private_entrance = ?                                 ; Whether unit has private entrance
private_garage = ?                                   ; Whether unit has private garage
garage_spaces = ##:(0..):if private_garage = true    ; Number of garage spaces
assigned_parking = ?                                 ; Whether unit has assigned parking
parking_spaces = ##:(0..):if assigned_parking = true ; Number of assigned parking spaces
storage_unit_included = ?                            ; Whether storage unit is included
storage_unit_square_feet = ##:(0..):if storage_unit_included = true ; Square footage of storage unit

; ───────────────────────────────────────────────────────────────────────────────
; Building Information
; ───────────────────────────────────────────────────────────────────────────────
{.building}
year_built = ##:(1600..)                            ; Year building was built
construction_type = (brick, concrete, concrete_block, fire_resistive, frame, masonry, mixed, steel_frame, superior_construction) ; Type of building construction

total_floors_in_building = ##:(1..)                  ; Total number of floors in building
total_units_in_building = ##:(1..)                   ; Total number of units in building
elevator = ?                                         ; Whether building has elevator
sprinklers = ?                                       ; Whether building has sprinkler system

{@condo_unit}

; ───────────────────────────────────────────────────────────────────────────────
; Unit Systems
; ───────────────────────────────────────────────────────────────────────────────
heating = @res.res_heating                           ; Heating system information
cooling = @res.res_cooling                           ; Cooling system information
electrical = @res.res_electrical                     ; Electrical system information
plumbing = @res.res_plumbing                         ; Plumbing system information

{@condo_unit}

; ───────────────────────────────────────────────────────────────────────────────
; Fire and Security Protection
; ───────────────────────────────────────────────────────────────────────────────
fire_protection = @res.res_fire_protection           ; Fire protection details

{.fire_protection}
; HO-6 specific building-level fire protection
sprinkler_system_in_unit = ?                         ; Whether unit has sprinkler system

{@condo_unit}

security = @res.res_security                         ; Security system details

{.security}
; HO-6 specific building-level security
doorman = ?                                          ; Whether building has doorman
security = ?                                         ; Whether building has security system
gated_community = ?                                  ; Whether in gated community

{@condo_unit}

protection_class = ##:(1..10)                        ; Fire protection class rating (1=best, 10=worst)

; ───────────────────────────────────────────────────────────────────────────────
; Special Considerations
; ───────────────────────────────────────────────────────────────────────────────
special_features = @res.res_special_features         ; Special features

{.special_features}
; HO-6 specific features
short_term_rental = ?                                ; Airbnb, VRBO, etc.
short_term_rental_days_per_year = ##:(0..365):if short_term_rental = true ; Days per year rented short-term

{@condo_unit}

; ───────────────────────────────────────────────────────────────────────────────
; Valuation
; ───────────────────────────────────────────────────────────────────────────────
valuation = @res.res_valuation                       ; Valuation details

{.valuation}
; HO-6 specific valuation
improvements_value = #$:(0..)                        ; Value of improvements/betterments

{@condo_unit}

; ═══════════════════════════════════════════════════════════════════════════════
; HOA / Condominium Association Information (CRITICAL)
; ═══════════════════════════════════════════════════════════════════════════════

{@condo_association}
association_id = :                                   ; Unique identifier for association

; Association details
association_name = :                                ; Name of condominium association
association_type = (condominium, cooperative, planned_unit_development) ; Type of association

; Management
management_company = :                               ; Name of management company
management_contact_name = :                          ; Contact person name
management_phone = *@phone                           ; Management phone number
management_email = *@email                           ; Management email address


; Association address
address = @address                                   ; Association mailing address

{@condo_association}

; ───────────────────────────────────────────────────────────────────────────────
; HOA Fees and Assessments
; ───────────────────────────────────────────────────────────────────────────────
{.fees}
monthly_hoa_fee = #$:(0..)                           ; Monthly HOA fee amount
annual_hoa_fee = #$:(0..)                            ; Annual HOA fee amount
special_assessment_pending = ?                       ; Whether special assessment is pending
special_assessment_amount = #$:(0..):if special_assessment_pending = true ; Amount of pending special assessment
special_assessment_reason = ::if special_assessment_pending = true ; Reason for special assessment
special_assessment_history = ?                       ; Whether there is history of special assessments
past_special_assessments_count = ##:(0..):if special_assessment_history = true ; Number of past special assessments

{@condo_association}

; What HOA fees cover
{.hoa_covers}
exterior_maintenance = ?                             ; Whether HOA covers exterior maintenance
roof_maintenance = ?                                 ; Whether HOA covers roof maintenance
common_area_maintenance = ?                          ; Whether HOA covers common area maintenance
landscaping = ?                                      ; Whether HOA covers landscaping
snow_removal = ?                                     ; Whether HOA covers snow removal
trash_removal = ?                                    ; Whether HOA covers trash removal
water_sewer = ?                                      ; Whether HOA covers water and sewer
exterior_insurance = ?                               ; Whether HOA covers exterior insurance
reserve_fund = ?                                     ; Whether HOA fees include reserve fund

{@condo_association}

; ───────────────────────────────────────────────────────────────────────────────
; Master Insurance Policy Information (CRITICAL FOR COORDINATION)
; ───────────────────────────────────────────────────────────────────────────────
{.master_policy}
carrier_name = :                                    ; Name of master policy insurance carrier
policy_number = :                                    ; Master policy number
effective_date = date                                ; Master policy effective date
expiration_date = date                               ; Master policy expiration date
coverage_amount = #$:(0..)                           ; Master policy coverage amount

; Master policy type (determines what unit owner must insure)
master_policy_type = (all_in, bare_walls, single_entity) ; Type of master policy

; What master policy covers (depends on type)
{.master_covers}
building_structure = ?                               ; Whether master policy covers building structure
roof = ?                                             ; Whether master policy covers roof
exterior_walls = ?                                   ; Whether master policy covers exterior walls
common_areas = ?                                     ; Whether master policy covers common areas
hallways_lobbies = ?                                 ; Whether master policy covers hallways and lobbies
elevators = ?                                        ; Whether master policy covers elevators
original_fixtures = ?:if master_policy_type = single_entity ; Whether original fixtures are covered (single entity)
original_fixtures = ?:if master_policy_type = all_in ; Whether original fixtures are covered (all-in)
unit_improvements = ?:if master_policy_type = all_in ; Whether unit improvements are covered (all-in)
appliances = ?:if master_policy_type = all_in        ; Whether appliances are covered (all-in)

{.master_policy}

; Master policy deductible (important for loss assessment)
master_deductible = #$:(0..)                         ; Common: $5,000 to $100,000
master_deductible_applies_to = (aggregate, per_occurrence, per_unit) ; How master deductible applies
unit_owner_responsible_for_deductible = ?            ; HOA may pass deductible to at-fault unit owner

; Master policy liability coverage
master_liability_limit = #$:(0..)                    ; Master policy liability limit

; Master policy adequacy
adequate_coverage_in_place = ?                       ; Whether adequate coverage is in place
coverage_reviewed_by_agent = ?                       ; Whether coverage was reviewed by agent
coverage_review_date = date                          ; Date coverage was reviewed

{@condo_association}

; ───────────────────────────────────────────────────────────────────────────────
; Common Areas and Amenities
; ───────────────────────────────────────────────────────────────────────────────
{.amenities}
swimming_pool = ?                                    ; Whether building has swimming pool
fitness_center = ?                                   ; Whether building has fitness center
clubhouse = ?                                        ; Whether building has clubhouse
tennis_courts = ?                                    ; Whether building has tennis courts
basketball_court = ?                                 ; Whether building has basketball court
playground = ?                                       ; Whether building has playground
business_center = ?                                  ; Whether building has business center
guest_parking = ?                                    ; Whether building has guest parking
concierge_service = ?                                ; Whether building has concierge service
package_room = ?                                     ; Whether building has package room
bike_storage = ?                                     ; Whether building has bike storage
rooftop_deck = ?                                     ; Whether building has rooftop deck
party_room = ?                                       ; Whether building has party room
theater_room = ?                                     ; Whether building has theater room
sauna_spa = ?                                        ; Whether building has sauna or spa

{@condo_association}

; ───────────────────────────────────────────────────────────────────────────────
; Financial Health
; ───────────────────────────────────────────────────────────────────────────────
{.financial}
reserve_fund_balance = #$:(0..)                      ; Balance in reserve fund
reserve_fund_adequate = ?                            ; Whether reserve fund is adequate
litigation_pending = ?                               ; Whether litigation is pending
litigation_description = ::if litigation_pending = true ; Description of pending litigation
fha_approved = ?                                     ; Whether building is FHA approved
fannie_mae_approved = ?                              ; Whether building is Fannie Mae approved

{@condo_association}

; ═══════════════════════════════════════════════════════════════════════════════
; HO-6 Condo Policy (Composes All Components)
; ═══════════════════════════════════════════════════════════════════════════════

{@condo_policy}
id = :                                               ; Unique policy identifier
number = :(1..50)                                   ; Policy number

; ───────────────────────────────────────────────────────────────────────────────
; Policy Form
; ───────────────────────────────────────────────────────────────────────────────
policy_form = "HO6"                                  ; Policy form type
policy_form_edition = :                              ; Edition of policy form

; ───────────────────────────────────────────────────────────────────────────────
; Policy Term
; ───────────────────────────────────────────────────────────────────────────────
effective_date = date                               ; Policy effective date
effective_time = time                                ; Policy effective time
expiration_date = date                              ; Policy expiration date
expiration_time = time                               ; Policy expiration time
:invariant expiration_date > effective_date

term_months = ##:(1..)                               ; Policy term in months
policy_year = ##:(1..)                               ; Policy year number

; ───────────────────────────────────────────────────────────────────────────────
; Transaction
; ───────────────────────────────────────────────────────────────────────────────
transaction = @res.res_transaction                   ; Transaction details

{@condo_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Named Insured
; ───────────────────────────────────────────────────────────────────────────────
named_insureds[] = @ho6_named_insured                ; Named insureds on policy

; ───────────────────────────────────────────────────────────────────────────────
; Condominium Unit
; ───────────────────────────────────────────────────────────────────────────────
condo_unit = @condo_unit                             ; Condominium unit details

; ───────────────────────────────────────────────────────────────────────────────
; HOA / Condominium Association
; ───────────────────────────────────────────────────────────────────────────────
condo_association = @condo_association               ; Condominium association details

; ───────────────────────────────────────────────────────────────────────────────
; Coverages (HO-6 specific - NO Coverage B)
; ───────────────────────────────────────────────────────────────────────────────
; Coverage A - Unit-Owners Building Property (Improvements/Betterments)
coverage_a = @ho6_dwelling_coverage                  ; Coverage A details

; Coverage B - NOT APPLICABLE for HO-6 (other structures covered by HOA)

; Coverage C - Personal Property (PRIMARY COVERAGE)
coverage_c = @ho6_personal_property_coverage        ; Coverage C details

; Coverage D - Loss of Use
coverage_d = @ho6_loss_of_use_coverage               ; Coverage D details

; Coverage E - Personal Liability
coverage_e = @ho6_personal_liability_coverage       ; Coverage E details

; Coverage F - Medical Payments
coverage_f = @ho6_medical_payments_coverage          ; Coverage F details

; Loss Assessment Coverage (CRITICAL for HO-6)
loss_assessment_coverage = @ho6_loss_assessment_coverage ; Loss assessment coverage details

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Summary
; ───────────────────────────────────────────────────────────────────────────────
{.coverage_summary}
coverage_a_limit = #$:(0..)                          ; May be $0 if master is all-in
coverage_c_limit = #$:(0..)                          ; Primary coverage
coverage_d_limit = #$:(0..)                          ; Coverage D limit
coverage_e_limit = #$:(0..)                          ; Coverage E limit
coverage_f_limit = #$:(0..)                          ; Coverage F limit
loss_assessment_limit = #$:(0..)                     ; Critical for condos

{@condo_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Deductibles
; ───────────────────────────────────────────────────────────────────────────────
standard_deductible = #$:(0..)                       ; Standard deductible amount

hurricane_deductible = #$:(0..)                      ; Hurricane deductible amount
hurricane_deductible_percent = #:(0..100)            ; Hurricane deductible percentage
hurricane_deductible_applies = ?                     ; Whether hurricane deductible applies

; Water damage deductible
water_damage_deductible = #$:(0..)                   ; Water damage deductible amount
water_damage_deductible_separate = ?                 ; Whether water damage deductible is separate

; ───────────────────────────────────────────────────────────────────────────────
; Scheduled Property
; ───────────────────────────────────────────────────────────────────────────────
scheduled_property[] = @res.res_scheduled_item       ; Scheduled high-value items

; ───────────────────────────────────────────────────────────────────────────────
; Mortgagees
; ───────────────────────────────────────────────────────────────────────────────
mortgagees[] = @res.res_mortgagee                    ; Mortgagee information

; ───────────────────────────────────────────────────────────────────────────────
; Endorsements
; ───────────────────────────────────────────────────────────────────────────────
endorsements[] = @ho6_endorsement                    ; Policy endorsements

{@ho6_endorsement}
= @res.res_endorsement

; HO-6 specific endorsement types
endorsement_type = (additional_loss_assessment, building_code_upgrade, earthquake, equipment_breakdown, extended_replacement_cost, flood, home_sharing, identity_theft, increased_coverage_c, increased_liability, mold_coverage, ordinance_law, other, personal_injury, personal_property_replacement_cost, scheduled_personal_property, service_line, special_computer, unit_improvements_betterments, water_backup, watercraft) ; Type of endorsement

{@condo_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Prior Claims
; ───────────────────────────────────────────────────────────────────────────────
prior_claims[] = @res.res_prior_claim                ; Prior claims history
total_prior_claims = ##:(0..)                        ; Total number of prior claims
claims_free_years = ##:(0..)                         ; Number of claims-free years

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
premium = @res.res_premium                           ; Premium details

{@condo_policy}

; Payment plan
payment = @res.res_payment_plan                      ; Payment plan details

{@condo_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Underwriting
; ───────────────────────────────────────────────────────────────────────────────
underwriting = @res.res_underwriting                 ; Underwriting details

{.underwriting}
; HO-6 specific underwriting fields
master_policy_reviewed = ?                           ; Whether master policy was reviewed
master_policy_adequate = ?                           ; Whether master policy is adequate

{@condo_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Agency/Producer
; ───────────────────────────────────────────────────────────────────────────────
agency = @agency                                     ; Agency information
producer = @producer                                 ; Producer information
commission_percent = #:(0..100)                      ; Commission percentage

{@condo_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
policy_status = @res.res_policy_status               ; Policy status

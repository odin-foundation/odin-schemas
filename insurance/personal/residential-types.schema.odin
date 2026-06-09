; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Residential Insurance Common Types
; ═══════════════════════════════════════════════════════════════════════════════
; Common types shared across residential insurance schemas including dwelling
; details, construction classifications, protection systems, and property
; valuation methods.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.residential-types"
version = "1.0.0"
title = "Residential Insurance Common Types"
description = "Shared types for residential property insurance policies"

{$derivation}
methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-14
changelog[0].change = "Initial residential common types"
changelog[0].rationale = "DRY - consolidate common patterns across HO-# policies"

; ═══════════════════════════════════════════════════════════════════════════════
; Named Insured
; ═══════════════════════════════════════════════════════════════════════════════
; Common named insured structure for all residential policies

{@res_named_insured}
insured_id = :                                         ; Unique identifier for the insured
name = @person_name                                    ; Full legal name of the named insured
date_of_birth = *date                                  ; Date of birth (confidential)

ssn_last_four = :(4)                                   ; Last 4 digits of Social Security Number
marital_status = (common_law, divorced, domestic_partner, married, single, widowed)  ; Current marital status
spouse_included = ?                                    ; Whether spouse is included on the policy
spouse_name = @person_name:if spouse_included = true   ; Full legal name of spouse
spouse_dob = *date:if spouse_included = true           ; Spouse's date of birth (confidential)
resident_relatives_covered = ?                         ; Whether resident relatives have coverage
contact = @contact_info                                ; Contact information for the insured
years_at_residence = ##:(0..)                          ; Number of years insured has lived at residence

; ═══════════════════════════════════════════════════════════════════════════════
; Prior Insurance
; ═══════════════════════════════════════════════════════════════════════════════
; Prior coverage history for underwriting

{@res_prior_insurance}
currently_insured = ?                                  ; Whether applicant has current coverage
prior_carrier = ::if currently_insured = true          ; Name of previous insurance carrier
prior_policy_number = ::if currently_insured = true    ; Previous policy number
prior_expiration_date = date:if currently_insured = true  ; Expiration date of prior policy
years_with_prior_carrier = ##:(0..):if currently_insured = true  ; Years insured with prior carrier
prior_claims_count = ##:(0..):if currently_insured = true  ; Number of claims with prior carrier

; ═══════════════════════════════════════════════════════════════════════════════
; Coverage C Special Limits (Sublimits)
; ═══════════════════════════════════════════════════════════════════════════════
; Standard personal property sublimits

{@res_special_limits}
money = #$:(0..)                                       ; Sublimit for cash and currency
securities = #$:(0..)                                  ; Sublimit for stocks, bonds, and securities
jewelry_theft = #$:(0..)                               ; Sublimit for jewelry lost to theft
furs = #$:(0..)                                        ; Sublimit for fur garments
firearms = #$:(0..)                                    ; Sublimit for guns and firearms
silverware = #$:(0..)                                  ; Sublimit for sterling and silver items
electronics = #$:(0..)                                 ; Sublimit for electronic equipment
computers = #$:(0..)                                   ; Sublimit for computers and peripherals
business_property = #$:(0..)                           ; Sublimit for business property at residence
collectibles = #$:(0..)                                ; Sublimit for collectible items
fine_arts = #$:(0..)                                   ; Sublimit for artwork and sculptures
musical_instruments = #$:(0..)                         ; Sublimit for musical instruments

; ═══════════════════════════════════════════════════════════════════════════════
; Liability Coverage (Coverage E)
; ═══════════════════════════════════════════════════════════════════════════════
; Personal liability common fields

{@res_liability}
liability_limit = #$:(0..)                       ; Common: $100k, $300k, $500k
per_occurrence = ?                                     ; Whether limit applies per occurrence
defense_costs = (outside_limits, within_limits)        ; How defense costs are handled
damage_to_property_of_others = #$:(0..)               ; Sublimit for property damage to third parties
claim_expenses = ?                                     ; Whether claim expenses are covered
first_aid_expenses = ?                                 ; Whether first aid expenses are covered
loss_of_earnings = #$:(0..)                            ; Limit for insured's loss of earnings
premises_operations = ?                                ; Coverage for premises and operations
personal_activities = ?                                ; Coverage for personal activities
watercraft_liability = ?                               ; Liability coverage for watercraft
recreational_vehicles = ?                              ; Liability coverage for recreational vehicles

; ═══════════════════════════════════════════════════════════════════════════════
; Medical Payments Coverage (Coverage F)
; ═══════════════════════════════════════════════════════════════════════════════

{@res_medical_payments}
medical_payments_limit = #$:(0..)                ; Common: $1k, $2k, $5k
per_person = ?                                         ; Whether limit applies per person
expense_time_limit_years = ##:(0..)                    ; Years after accident expenses are covered
no_fault_coverage = ?                                  ; Whether coverage is no-fault basis

; ═══════════════════════════════════════════════════════════════════════════════
; Loss of Use Coverage (Coverage D)
; ═══════════════════════════════════════════════════════════════════════════════

{@res_loss_of_use}
loss_of_use_limit = #$:(0..)                           ; Overall limit for loss of use coverage
percentage_of_primary = ##:(0..100)                    ; Percentage of Coverage A (dwelling)
maximum_period_months = ##:(0..)                       ; Maximum months coverage applies
additional_living_expenses = ?                         ; Whether ALE coverage is included
ale_limit = #$:(0..):if additional_living_expenses = true  ; Limit for additional living expenses
prohibited_use_civil_authority = ?                     ; Coverage when civil authority prohibits use
prohibited_use_days = ##:(0..):if prohibited_use_civil_authority = true  ; Days of civil authority prohibition covered
fair_rental_value = ?                                  ; Coverage for lost rental income
frv_limit = #$:(0..):if fair_rental_value = true       ; Limit for fair rental value

; ═══════════════════════════════════════════════════════════════════════════════
; Scheduled Personal Property
; ═══════════════════════════════════════════════════════════════════════════════

{@res_scheduled_item}
item_id = :                                            ; Unique identifier for scheduled item
item_type = (bicycles, cameras, coins, collectibles, electronics, fine_arts, firearms, furs, golf_equipment, jewelry, musical_instruments, other, silverware, sports_equipment, stamps, watches)  ; Category of scheduled item
description = :                                       ; Detailed description of the item
scheduled_value = #$:(0..)                            ; Agreed value for the scheduled item
appraisal_date = date                                  ; Date of professional appraisal
appraisal_value = #$:(0..)                             ; Appraised value of the item
deductible = #$:(0..)                                  ; Deductible specific to this item
all_risk = ?                                           ; Whether all-risk coverage applies
mysterious_disappearance = ?                           ; Coverage for unexplained loss
breakage = ?                                           ; Coverage for accidental breakage
serial_number = :                                      ; Serial number of the item
make = :                                               ; Manufacturer or maker
model = :                                              ; Model name or number

; ═══════════════════════════════════════════════════════════════════════════════
; Prior Claim
; ═══════════════════════════════════════════════════════════════════════════════

{@res_prior_claim}
id = :                                                 ; Unique claim identifier
date = date                                           ; Date claim was filed
loss_date = date                                       ; Date loss occurred
type = (fire, hail, hurricane, liability, lightning, medical_payments, other, theft, tornado, vandalism, water_damage, weather, wind)  ; Type of claim/loss
loss_description = :                                   ; Description of the loss
amount_paid = #$:(0..)                                 ; Amount paid on the claim
amount_reserved = #$:(0..)                             ; Amount reserved for future payments
deductible_applied = #$:(0..)                          ; Deductible applied to claim
status = (closed, denied, open, subrogation)           ; Current status of claim
catastrophe_claim = ?                                  ; Whether claim is catastrophe-related
catastrophe_code = ::if catastrophe_claim = true       ; Catastrophe event code
at_fault = ?                                           ; Whether insured was at fault

; ═══════════════════════════════════════════════════════════════════════════════
; Endorsement
; ═══════════════════════════════════════════════════════════════════════════════

{@res_endorsement}
id = :                                                 ; Unique endorsement identifier
number = :                                            ; Endorsement form number
title = :                                              ; Endorsement title or name
effective_date = date                                  ; Date endorsement becomes effective
expiration_date = date                                 ; Date endorsement expires
description = :                                        ; Description of endorsement coverage
premium = #$:(0..)                                     ; Additional premium for endorsement
limit = #$:(0..)                                       ; Coverage limit added by endorsement
deductible = #$:(0..)                                  ; Deductible specific to endorsement

; ═══════════════════════════════════════════════════════════════════════════════
; Mortgagee / Lienholder
; ═══════════════════════════════════════════════════════════════════════════════

{@res_mortgagee}
mortgagee_id = :                                       ; Unique identifier for mortgagee
sequence = ##:(1..)                               ; 1st, 2nd mortgage
lender_name = :                                       ; Name of lending institution
loan_number = :                                       ; Loan or mortgage number
address = @address                                     ; Mailing address for mortgagee
loan_type = (chattel, conventional, fha, other, usda, va)  ; Type of mortgage loan
escrow_required = ?                                    ; Whether escrow is required
loss_payee_clause = ?                                  ; Whether loss payee clause applies

; ═══════════════════════════════════════════════════════════════════════════════
; Premium Structure
; ═══════════════════════════════════════════════════════════════════════════════

{@res_premium}
base_premium = #$:(0..)                                ; Base premium before endorsements and discounts
endorsement_premium = #$:(0..)                         ; Additional premium from endorsements
surcharges = #$:(0..)                                  ; Premium surcharges applied
taxes = #$:(0..)                                       ; Premium taxes
fees = #$:(0..)                                        ; Policy fees
total_premium = #$:(0..)                               ; Total premium before discounts
multi_policy_discount = #$:(0..)                       ; Discount for multiple policies
claims_free_discount = #$:(0..)                        ; Discount for no claims history
new_home_discount = #$:(0..)                           ; Discount for newly built home
protective_device_discount = #$:(0..)                  ; Discount for security/fire devices
loyalty_discount = #$:(0..)                            ; Discount for customer tenure
payment_discount = #$:(0..)                            ; Discount for payment method
autopay_discount = #$:(0..)                            ; Discount for automatic payments
paperless_discount = #$:(0..)                          ; Discount for paperless delivery
total_discounts = #$:(0..)                             ; Total of all discounts
net_premium = #$:(0..)                                 ; Final premium after discounts

; ═══════════════════════════════════════════════════════════════════════════════
; Payment Plan
; ═══════════════════════════════════════════════════════════════════════════════

{@res_payment_plan}
payment_plan = (annual, eft_monthly, lienholder_billed, monthly, mortgagee_billed, quarterly, semi_annual)  ; Payment frequency type
installment_fee = #$:(0..)                             ; Fee for installment payments
down_payment = #$:(0..)                                ; Initial down payment amount
installment_amount = #$:(0..)                          ; Amount of each installment
installment_count = ##:(0..)                           ; Number of installments
due_date = date                                        ; First payment due date
autopay_enrolled = ?                                   ; Whether enrolled in automatic payments

; ═══════════════════════════════════════════════════════════════════════════════
; Policy Status
; ═══════════════════════════════════════════════════════════════════════════════

{@res_policy_status}
status = (active, cancelled, expired, non_renewed, pending, reinstated)  ; Current policy status
cancellation_date = date:if status = cancelled         ; Date policy was cancelled
cancellation_reason = ::if status = cancelled          ; Reason for cancellation
cancellation_type = (flat, mid_term, short_rate):if status = cancelled  ; Type of cancellation calculation
cancellation_requested_by = (insured, insurer, lienholder):if status = cancelled  ; Party requesting cancellation

; ═══════════════════════════════════════════════════════════════════════════════
; Transaction Type
; ═══════════════════════════════════════════════════════════════════════════════

{@res_transaction}
transaction_type = (cancellation, endorsement, new_business, non_renewal, reinstatement, renewal, rewrite)  ; Type of policy transaction
transaction_effective_date = date                      ; Date transaction becomes effective
previous_policy_number = ::if transaction_type = renewal  ; Policy number of previous term

; ═══════════════════════════════════════════════════════════════════════════════
; Underwriting
; ═══════════════════════════════════════════════════════════════════════════════

{@res_underwriting}
underwriting_company = :                               ; Underwriting carrier name
program_code = :                                       ; Underwriting program identifier
tier = :                                               ; Risk tier or pricing tier
credit_score_used = ?                                  ; Whether credit score was used
insurance_score = ##:(0..)                             ; Insurance score calculated
loss_history_years_reviewed = ##:(0..10)               ; Years of loss history reviewed
inspection_required = ?                                ; Whether property inspection required
inspection_type = (desktop, drive_by, four_point, full, wind_mitigation):if inspection_required = true  ; Type of inspection
inspection_completed = ?:if inspection_required = true ; Whether inspection has been completed
inspection_date = date:if inspection_completed = true  ; Date inspection was performed
inspection_report_id = ::if inspection_completed = true  ; Inspection report identifier

; ═══════════════════════════════════════════════════════════════════════════════
; Fire Protection
; ═══════════════════════════════════════════════════════════════════════════════

{@res_fire_protection}
smoke_detectors = ?                                    ; Whether smoke detectors are installed
smoke_detector_count = ##:(0..):if smoke_detectors = true  ; Number of smoke detectors
smoke_detectors_hardwired = ?:if smoke_detectors = true  ; Whether smoke detectors are hardwired
fire_extinguisher = ?                                  ; Whether fire extinguisher present
fire_extinguisher_count = ##:(0..):if fire_extinguisher = true  ; Number of fire extinguishers
sprinkler_system = ?                                   ; Whether sprinkler system installed
sprinkler_type = (full, partial):if sprinkler_system = true  ; Coverage level of sprinkler system
fire_alarm = ?                                         ; Whether fire alarm installed
fire_alarm_type = (central_station, local, monitored):if fire_alarm = true  ; Type of fire alarm system
carbon_monoxide_detector = ?                           ; Whether CO detector installed

; ═══════════════════════════════════════════════════════════════════════════════
; Security Devices
; ═══════════════════════════════════════════════════════════════════════════════

{@res_security}
deadbolt_locks = ?                                     ; Whether deadbolt locks installed
security_system = ?                                    ; Whether security system installed
security_system_type = (local, monitored, smart_home):if security_system = true  ; Type of security system
security_certificate = ::if security_system = true     ; Security system certificate or ID
burglar_alarm = ?                                      ; Whether burglar alarm installed
burglar_alarm_monitored = ?:if burglar_alarm = true    ; Whether alarm is professionally monitored
security_cameras = ?                                   ; Whether security cameras installed
camera_count = ##:(0..):if security_cameras = true     ; Number of security cameras
doorbell_camera = ?                                    ; Whether doorbell camera installed

; ═══════════════════════════════════════════════════════════════════════════════
; Building Systems - Heating
; ═══════════════════════════════════════════════════════════════════════════════

{@res_heating}
heating_type = (baseboard_electric, central_electric, central_forced_air, central_gas, central_oil, fireplace_only, geothermal, heat_pump, hot_water_boiler, none, propane, radiant_floor, solar, space_heater, steam, wall_heater, wood_stove)  ; Primary heating system type
heating_fuel = (electric, gas, oil, propane, wood)     ; Fuel source for heating
central_heat = ?                                       ; Whether central heating system
heating_age_years = ##:(0..)                           ; Age of heating system in years

; ═══════════════════════════════════════════════════════════════════════════════
; Building Systems - Cooling
; ═══════════════════════════════════════════════════════════════════════════════

{@res_cooling}
cooling_type = (central_air, evaporative, none, wall_unit, window_unit)  ; Primary cooling system type
central_air = ?                                        ; Whether central air conditioning

; ═══════════════════════════════════════════════════════════════════════════════
; Building Systems - Electrical
; ═══════════════════════════════════════════════════════════════════════════════

{@res_electrical}
electrical_service_amps = ##:(0..800)                  ; Amperage of electrical service
wiring_type = (aluminum, bx_armored, copper, knob_and_tube, mixed, romex)  ; Type of electrical wiring
wiring_updated = ?                                     ; Whether wiring has been updated
wiring_update_year = ##:(1900..):if wiring_updated = true  ; Year wiring was updated
circuit_breakers = ?                                   ; Whether circuit breakers installed
fuse_box = ?                                           ; Whether fuse box present

; ═══════════════════════════════════════════════════════════════════════════════
; Building Systems - Plumbing
; ═══════════════════════════════════════════════════════════════════════════════

{@res_plumbing}
plumbing_type = (abs, cast_iron, copper, cpvc, galvanized, lead, mixed, pex, polybutylene, pvc)  ; Type of plumbing material
plumbing_updated = ?                                   ; Whether plumbing has been updated
plumbing_update_year = ##:(1900..):if plumbing_updated = true  ; Year plumbing was updated
plumbing_condition = (excellent, fair, good, poor)     ; Overall condition of plumbing
water_heater_type = (electric, gas, oil, propane, solar, tankless)  ; Type of water heater
water_heater_age_years = ##:(0..)                      ; Age of water heater in years
water_source = (municipal, private_well, shared_well)  ; Source of water supply
sewer_type = (municipal, private_septic, shared_system)  ; Type of sewer/waste system

; ═══════════════════════════════════════════════════════════════════════════════
; Roof
; ═══════════════════════════════════════════════════════════════════════════════

{@res_roof}
roof_type = (asphalt_composition, asphalt_shingle, built_up, clay_tile, concrete_tile, flat, metal, rubber_membrane, shake_wood, slate, tar_gravel)  ; Material type of roof
roof_shape = (flat, gable, gambrel, hip, mansard, shed)  ; Architectural shape of roof
roof_age_years = ##:(0..)                              ; Age of roof in years
roof_last_replaced = date                              ; Date roof was last replaced
roof_condition = (excellent, fair, good, poor)         ; Overall condition of roof
impact_resistant = ?                                   ; Whether roof is impact-resistant

; ═══════════════════════════════════════════════════════════════════════════════
; Construction
; ═══════════════════════════════════════════════════════════════════════════════

{@res_construction}
year_built = ##:(1600..)                              ; Year building was constructed
construction_type = (adobe, brick, brick_on_block, brick_on_frame, brick_veneer, concrete_block, fire_resistive, frame, log, manufactured, masonry, masonry_veneer, mixed, steel_frame, stone, stucco, stucco_on_frame)  ; Type of building construction
total_square_feet = ##:(0..)                          ; Total square footage including all areas
living_square_feet = ##:(0..)                          ; Finished living square footage
story_count = #:(0..10)                                ; Number of stories/floors

; ═══════════════════════════════════════════════════════════════════════════════
; Foundation
; ═══════════════════════════════════════════════════════════════════════════════

{@res_foundation}
foundation_type = (basement_finished, basement_unfinished, basement_walkout, concrete_slab, crawl_space, elevated_stilts, pier, pier_and_beam, raised_foundation, slab_on_grade)  ; Type of foundation
basement = ?                                           ; Whether basement is present
basement_finished = ?:if basement = true               ; Whether basement is finished
basement_square_feet = ##:(0..):if basement = true     ; Square footage of basement

; ═══════════════════════════════════════════════════════════════════════════════
; Valuation
; ═══════════════════════════════════════════════════════════════════════════════

{@res_valuation}
purchase_date = date                                   ; Date property was purchased
purchase_price = #$:(0..)                              ; Original purchase price
current_market_value = #$:(0..)                        ; Current estimated market value
replacement_cost_estimate = #$:(0..)                   ; Estimated cost to rebuild
actual_cash_value = #$:(0..)                           ; Depreciated value of property
last_appraisal_date = date                             ; Date of last professional appraisal
last_appraisal_value = #$:(0..)                        ; Value from last appraisal

; ═══════════════════════════════════════════════════════════════════════════════
; Occupancy
; ═══════════════════════════════════════════════════════════════════════════════

{@res_occupancy}
occupancy_type = (owner_occupied, rental_dwelling, seasonal, secondary_residence, tenant_occupied, vacant)  ; Type of property occupancy
owner_occupied = ?                                     ; Whether owner lives in property
primary_residence = ?                                  ; Whether property is primary residence
rental_to_others = ?                                   ; Whether property is rented to others
seasonal_use = ?                                       ; Whether property is seasonal use
days_per_year_occupied = ##:(0..365):if seasonal_use = true  ; Days per year property is occupied

; ═══════════════════════════════════════════════════════════════════════════════
; Special Features / Hazards
; ═══════════════════════════════════════════════════════════════════════════════

{@res_special_features}
swimming_pool = ?                                      ; Whether swimming pool present
pool_type = (above_ground, in_ground):if swimming_pool = true  ; Type of swimming pool
pool_fenced = ?:if swimming_pool = true                ; Whether pool is fenced
diving_board = ?:if swimming_pool = true               ; Whether pool has diving board
hot_tub_spa = ?                                        ; Whether hot tub or spa present
trampoline = ?                                         ; Whether trampoline present
trampoline_fenced = ?:if trampoline = true             ; Whether trampoline is fenced
dog_on_premises = ?                                    ; Whether dog is kept on premises
dog_breed = ::if dog_on_premises = true                ; Breed of dog
dog_bite_history = ?:if dog_on_premises = true         ; Whether dog has bite history
wood_burning_stove = ?                                 ; Whether wood burning stove present
wood_stove_professionally_installed = ?:if wood_burning_stove = true  ; Whether professionally installed
solar_panels = ?                                       ; Whether solar panels installed
solar_panel_ownership = (leased, owned, ppa):if solar_panels = true  ; Ownership type of solar panels
{.ev_charger}
installed = ?                                          ; Whether EV charger installed
level = (level_1, level_2, level_3_dc):if installed = true  ; Charging level of EV charger
amps = ##:(0..):if installed = true                    ; Amperage of EV charger
hardwired = ?:if installed = true                      ; Whether EV charger is hardwired
outdoor = ?:if installed = true                        ; Whether EV charger is outdoors
value = #$:(0..):if installed = true                   ; Value of EV charger installation

{@res_special_features}
business_conducted = ?                                 ; Whether business conducted at property
business_type = ::if business_conducted = true         ; Type of business conducted
daycare_on_premises = ?                                ; Whether daycare operated on premises
home_sharing = ?                                       ; Whether property used for short-term rentals

; ═══════════════════════════════════════════════════════════════════════════════
; Natural Hazard Exposure
; ═══════════════════════════════════════════════════════════════════════════════

{@res_hazard_exposure}
flood_zone = :                              ; FEMA flood zone
in_sfha = ?                                       ; Special Flood Hazard Area
earthquake_zone = ?                                    ; Whether property in earthquake zone
hurricane_zone = ?                                     ; Whether property in hurricane zone
tornado_zone = ?                                       ; Whether property in tornado zone
wildfire_zone = ?                                      ; Whether property in wildfire zone
coastal_exposure = ?                                   ; Whether property has coastal exposure
coastal_distance_miles = #:(0..500):if coastal_exposure = true  ; Distance from coast in miles

; ═══════════════════════════════════════════════════════════════════════════════
; Protection Class
; ═══════════════════════════════════════════════════════════════════════════════

{@res_protection_class}
protection_class = ##                             ; ISO Protection Class
distance_to_fire_station_miles = #:(0..100)            ; Distance to nearest fire station
distance_to_hydrant_feet = ##:(0..)                    ; Distance to nearest fire hydrant
fire_district = :                                      ; Fire protection district
responding_fire_department = :                         ; Name of responding fire department
fire_department_type = (career, combination, volunteer)  ; Type of fire department


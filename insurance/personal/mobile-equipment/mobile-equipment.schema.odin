; ===================================================================================
; ODIN Personal Mobile Equipment Insurance Schema
; ===================================================================================
; Personal mobile equipment insurance for ATVs, golf carts, snowmobiles, farm
; equipment, and other off-road vehicles covering physical damage, liability,
; passenger coverage, and accessories/custom parts.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.mobile-equipment"
version = "1.0.0"
title = "Personal Mobile Equipment Insurance Schema"
description = "Insurance for personally-owned mobile equipment and small vehicles"

{$derivation}
source[0].authority = "National Association of Insurance Commissioners (NAIC)"
source[0].citation = "Personal Lines Insurance Model"
source[0].url = "https://content.naic.org/"

source[1].authority = "Consumer Product Safety Commission (CPSC)"
source[1].citation = "Outdoor Power Equipment Safety Standards"
source[1].url = "https://www.cpsc.gov/"

source[2].authority = "Outdoor Power Equipment Institute (OPEI)"
source[2].citation = "Equipment Classification Standards"
source[2].url = "https://www.opei.org/"

source[3].authority = "Texas Department of Insurance"
source[3].citation = "Personal Property and Equipment Insurance Guide"
source[3].url = "https://www.tdi.texas.gov/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on OPEI classifications and state insurance regulations"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial personal mobile equipment insurance schema"
changelog[0].rationale = "Personal lines coverage for mobile equipment and small vehicles"

; ===================================================================================
; Equipment Category
; ===================================================================================
; Classifications for personal mobile equipment.

{@me_category}
category = (
    aerial_lift,                              ; Personal aerial work platform
    chainsaw,                                 ; Chainsaws and pole saws
    chipper_shredder,                         ; Chippers and shredders
    compact_tractor,                          ; Small tractors under 25HP
    e_bike,                                   ; Electric bicycle
    e_scooter,                                ; Electric kick scooter
    generator,                                ; Portable generators
    golf_cart,                                ; Golf cart/neighborhood vehicle
    lawn_mower_riding,                        ; Riding mowers and lawn tractors
    lawn_mower_walk,                          ; Walk-behind mowers
    log_splitter,                             ; Log splitting equipment
    mini_excavator,                           ; Small excavators
    neighborhood_vehicle,                     ; Low-speed vehicles (LSV)
    pressure_washer,                          ; Pressure washing equipment
    side_by_side,                             ; Personal UTV/side-by-side
    skid_steer,                               ; Compact skid steer
    snow_blower,                              ; Snow blowers
    snow_plow,                                ; Personal snow plows
    stump_grinder,                            ; Stump grinding equipment
    tiller,                                   ; Garden tillers
    trailer,                                  ; Equipment trailers
    trencher,                                 ; Trenching equipment
    utility_cart,                             ; Utility vehicles
    zero_turn_mower                           ; Zero-turn radius mowers
)

; Equipment propulsion
propulsion = (
    battery_electric,                         ; Battery powered
    corded_electric,                          ; Plug-in electric
    diesel,                                   ; Diesel engine
    gas,                                      ; Gasoline engine
    hybrid,                                   ; Hybrid power
    manual,                                   ; Human powered
    propane                                   ; Propane powered
)

; Street legal status
street_legal = ?                              ; Registered for road use

; ===================================================================================
; Equipment Details
; ===================================================================================
; Detailed equipment specifications.

{@me_equipment}
; Required fields first
category = @me_category                      ; Equipment category
make = :                                     ; Manufacturer
model = :                                    ; Model name/number
model_year = ##:(1950..2100)                 ; Model year

; Optional fields
acquisition_date = date                       ; Date acquired
condition = (excellent, fair, good, poor)     ; Current condition
deck_size_inches = ##:if category.category = (lawn_mower_riding, lawn_mower_walk, zero_turn_mower)
engine_hours = ##                             ; Engine hour meter
equipment_id = :                              ; Internal identifier
features[] = :                                ; Special features
fuel_capacity = #                             ; Fuel tank size
garage_kept = ?                               ; Stored indoors
garaging_address = @address                   ; Storage location
horsepower = ##                               ; Engine horsepower
license_plate = ::if category.street_legal = true
license_state = :(2):if category.street_legal = true
modifications[] = :                           ; Aftermarket modifications
msrp = #$:(0..)                               ; Original MSRP
odometer = ##                                 ; Mileage if applicable
purchase_price = #$:(0..)                     ; Purchase price
registration_expiration = date:if category.street_legal = true
salvage = ?                                   ; Salvage title
seating_capacity = ##                         ; Passenger capacity
serial_number = *:                            ; Serial number
towing_capacity_lbs = ##                      ; Towing capacity
vehicle_id = :                                ; VIN if applicable
voltage = ##:if category.propulsion = (battery_electric, corded_electric)
weight_lbs = ##                               ; Equipment weight
width_inches = ##                             ; Cutting/operating width

; ---------------------------------------------------------------------------
; Golf Cart Specific
; ---------------------------------------------------------------------------
{.golf_cart}
battery_type = (agm, flooded_lead, lithium):if category.category = golf_cart
battery_voltage = ##:if category.category = golf_cart
enclosure = ?:if category.category = golf_cart                ; Has enclosure
lights = ?:if category.category = golf_cart                   ; Has lights
seat_count = ##:if category.category = golf_cart
street_legal_package = ?:if category.category = golf_cart
turn_signals = ?:if category.category = golf_cart
windshield = ?:if category.category = golf_cart

{@me_equipment}

; ---------------------------------------------------------------------------
; Side-by-Side/UTV Specific
; ---------------------------------------------------------------------------
{.utv}
cab_enclosed = ?:if category.category = side_by_side
four_wheel_drive = ?:if category.category = side_by_side
power_steering = ?:if category.category = side_by_side
roll_cage = ?:if category.category = side_by_side
winch = ?:if category.category = side_by_side

{@me_equipment}

; ---------------------------------------------------------------------------
; Attachments and Accessories
; ---------------------------------------------------------------------------
{.attachments[]}
attachment_type = :                           ; Type of attachment
description = :                               ; Description
value = #$:(0..)                              ; Attachment value

{@me_equipment}

; ===================================================================================
; Equipment Usage
; ===================================================================================
; How equipment is used.

{@me_usage}
; Required fields first
primary_use = (
    hobby_farming,                            ; Personal hobby farm
    home_maintenance,                         ; Residential maintenance
    neighborhood_transport,                   ; Golf cart transportation
    personal_projects,                        ; DIY projects
    property_maintenance,                     ; Property upkeep
    recreational,                             ; Recreation
    snow_removal                              ; Snow clearing
)

; Optional fields
acreage_maintained = #                        ; Acres serviced
commercial_use = ?false                       ; No commercial use
hours_per_week = #                            ; Weekly usage hours
loan_to_others = ?                            ; Lent to neighbors
months_used = ##:(1..12)                      ; Months of active use
off_property_use = ?                          ; Used off premises
rental_use = ?false                           ; Not rented out
seasonal_use = ?                              ; Seasonal only
storage_months[] = ##:(1..12)                 ; Storage months

; ===================================================================================
; Liability Coverage
; ===================================================================================
; Liability protection for equipment operation.

{@me_liability}
; Required fields first
bodily_injury_per_accident = #$:(0..)        ; BI per accident
bodily_injury_per_person = #$:(0..)          ; BI per person
property_damage = #$:(0..)                   ; PD limit

; Optional fields
combined_single_limit = #$:(0..)              ; CSL if used
liability_form = (combined_single_limit, split_limits)
premises_liability = ?                        ; Premises coverage
products_liability = ?                        ; Products if applicable

; ===================================================================================
; Medical Payments
; ===================================================================================
; Medical payments coverage.

{@me_medical_payments}
included = ?                                  ; Coverage included
limit_per_person = #$:(0..)                   ; Per person limit
passengers_covered = ?                        ; Covers passengers

; ===================================================================================
; Physical Damage Coverage
; ===================================================================================
; Equipment physical damage coverage.

{@me_physical_damage}
; Required fields first
coverage_type = (collision, comprehensive)   ; Coverage type

; Optional fields
actual_cash_value = #$:(0..)                  ; ACV valuation
agreed_value = #$:(0..)                       ; Agreed value
deductible = #$:(0..)                         ; Deductible amount
replacement_cost = ?                          ; Replacement cost coverage
stated_amount = #$:(0..)                      ; Stated value
valuation = (
    actual_cash_value,
    agreed_value,
    replacement_cost,
    stated_amount
)

; ===================================================================================
; Attachments Coverage
; ===================================================================================
; Coverage for equipment attachments and accessories.

{@me_attachments_coverage}
included = ?                                  ; Coverage included
limit = #$:(0..)                              ; Total limit
per_item_limit = #$:(0..)                     ; Per-item sublimit

; Scheduled attachments
{.scheduled_items[]}
attachment_type = :                           ; Type
description = :                              ; Description
serial_number = :                             ; Serial number
value = #$:(0..)                             ; Value

{@me_attachments_coverage}

; ===================================================================================
; Rental Reimbursement
; ===================================================================================
; Rental coverage during repair.

{@me_rental_reimbursement}
included = ?                                  ; Coverage included
daily_limit = #$:(0..)                        ; Daily limit
max_days = ##                                 ; Maximum days
waiting_period_days = ##                      ; Days before coverage

; ===================================================================================
; Debris Removal
; ===================================================================================
; Coverage for debris removal after loss.

{@me_debris_removal}
included = ?                                  ; Coverage included
limit = #$:(0..)                              ; Coverage limit
percentage_of_loss = #:(0..25)                ; Percent of loss amount

; ===================================================================================
; Newly Acquired Equipment
; ===================================================================================
; Automatic coverage for new acquisitions.

{@me_newly_acquired}
included = ?                                  ; Coverage included
notification_days = ##:(10..60)               ; Days to report
per_item_limit = #$:(0..)                     ; Per-item limit
total_limit = #$:(0..)                        ; Total limit

; ===================================================================================
; Off-Premises Coverage
; ===================================================================================
; Coverage when equipment is away from home.

{@me_off_premises}
included = ?                                  ; Coverage included
limit = #$:(0..)                              ; Off-premises limit
territory = (
    north_america,                            ; US/Canada
    state_only,                               ; Issuing state only
    us_only,                                  ; United States
    worldwide                                 ; Global
)

; Covered locations
neighbor_property = ?                         ; Neighbor's property
repair_facilities = ?                         ; At repair shop
storage_facilities = ?                        ; Storage locations
transit = ?                                   ; In transit

; ===================================================================================
; Premium Details
; ===================================================================================
; Premium information.

{@me_premium}
; Required fields first
total_premium = #$:(0..)                     ; Total annual premium

; Optional fields
attachments_premium = #$:(0..)                ; Attachments coverage
collision_premium = #$:(0..)                  ; Collision premium
comprehensive_premium = #$:(0..)              ; Comprehensive premium
liability_premium = #$:(0..)                  ; Liability premium
medical_premium = #$:(0..)                    ; Med pay premium
minimum_premium = #$:(0..)                    ; Minimum premium
policy_fee = #$:(0..)                         ; Policy fee
rental_premium = #$:(0..)                     ; Rental coverage
taxes_and_fees = #$:(0..)                     ; Taxes and fees

; ---------------------------------------------------------------------------
; Discounts
; ---------------------------------------------------------------------------
{.discounts}
alarm_anti_theft = ?                          ; Anti-theft device
claims_free = ?                               ; No claims
garaged = ?                                   ; Indoor storage
multi_equipment = ?                           ; Multiple items
multi_policy = ?                              ; Multi-policy
new_equipment = ?                             ; New equipment
paid_in_full = ?                              ; Pay in full
safety_features = ?                           ; Safety equipment
seasonal_lay_up = ?                           ; Seasonal storage

{@me_premium}

; ===================================================================================
; Operator Information
; ===================================================================================
; Equipment operator details.

{@me_operator}
; Required fields first
date_of_birth = *date                        ; Operator DOB
name = @person_name                          ; Operator name
relationship = (
    child,                                    ; Minor child
    domestic_partner,                         ; Domestic partner
    employee,                                 ; Household employee
    other,                                    ; Other relationship
    self,                                     ; Named insured
    spouse                                    ; Spouse
)

; Optional fields
drivers_license = *:                          ; License if applicable
license_state = :(2)                          ; Issuing state
operator_id = :                               ; Internal identifier
training_completed = ?                        ; Safety training

; Experience
years_experience = ##                         ; Years operating

; Driving/operating record
accidents_3_years = ##:(0..10)                ; At-fault incidents
violations_3_years = ##:(0..10)               ; Violations

; ===================================================================================
; Prior Claims
; ===================================================================================
; Claims history.

{@me_prior_claim}
; Required fields first
claim_date = date                            ; Date of loss
claim_type = (
    collision,                                ; Collision damage
    comprehensive,                            ; Comp loss
    fire,                                     ; Fire damage
    liability_bi,                             ; BI claim
    liability_pd,                             ; PD claim
    other,                                    ; Other
    theft,                                    ; Theft
    vandalism                                 ; Vandalism
)

; Optional fields
amount_paid = #$:(0..)                        ; Amount paid
claim_id = :                                  ; Claim identifier
claim_status = (closed, denied, open)         ; Status
description = :                               ; Loss description
equipment_reference = :                       ; Equipment involved

; ===================================================================================
; Exclusions
; ===================================================================================
; Policy exclusions.

{@me_exclusions}
; Standard exclusions
commercial_use = ?true                        ; Commercial use
intentional_damage = ?true                    ; Intentional acts
racing = ?true                                ; Racing/competition
rental = ?true                                ; Rental to others
war = ?true                                   ; War/terrorism

; Optional exclusions
contractor_use = ?                            ; Contractor operations
maintenance_neglect = ?                       ; Poor maintenance
off_road_racing = ?                           ; Off-road competition
unlicensed_operator = ?                       ; Unlicensed operation

; ===================================================================================
; Endorsements
; ===================================================================================
; Policy endorsements.

{@me_endorsement}
; Required fields first
effective_date = date                        ; Effective date
endorsement_type = (
    agreed_value,                             ; Agreed value
    attachments,                              ; Attachments coverage
    debris_removal,                           ; Debris removal
    increased_limit,                          ; Higher limits
    newly_acquired,                           ; Auto coverage
    off_premises,                             ; Off-premises
    other,                                    ; Other
    rental_reimbursement,                     ; Rental coverage
    replacement_cost                          ; RC valuation
)

; Optional fields
description = :                               ; Description
endorsement_id = :                            ; Endorsement ID
premium = #$:(0..)                            ; Endorsement premium

; ===================================================================================
; Personal Mobile Equipment Policy
; ===================================================================================
; Complete policy composition.

{@mobile_equipment_policy}
; Required fields first
effective_date = date                        ; Policy effective date
equipment[] = @me_equipment                  ; Covered equipment
expiration_date = date                       ; Policy expiration date
policy_number = :                            ; Policy number

; Invariants
:invariant expiration_date > effective_date

; Optional fields
agency = @agency                              ; Issuing agency
attachments_coverage = @me_attachments_coverage  ; Attachments
billing_address = @address                    ; Billing address
collision = @me_physical_damage               ; Collision coverage
comprehensive = @me_physical_damage           ; Comprehensive coverage
debris_removal = @me_debris_removal           ; Debris removal
endorsements[] = @me_endorsement              ; Endorsements
exclusions = @me_exclusions                   ; Exclusions
id = :                                        ; Internal identifier
liability = @me_liability                     ; Liability coverage
medical_payments = @me_medical_payments       ; Med pay coverage
named_insured = @person_name                  ; Named insured
named_insured_address = @address              ; Insured address
newly_acquired = @me_newly_acquired           ; Newly acquired
off_premises = @me_off_premises               ; Off-premises
operators[] = @me_operator                    ; Covered operators
policy_form = (
    equipment_floater,                        ; Standalone floater
    golf_cart_policy,                         ; Golf cart specific
    homeowners_endorsement,                   ; HO endorsement
    standalone                                ; Standalone policy
)
policy_status = (
    active,
    cancelled,
    expired,
    pending,
    renewal
)
premium = @me_premium                         ; Premium details
prior_claims[] = @me_prior_claim              ; Prior claims
producer = @producer                          ; Agent
rental_reimbursement = @me_rental_reimbursement  ; Rental coverage
state_province = :(2)                         ; Issuing state
term_months = ##:(1..12)                      ; Policy term
underwriting = @underwriting_decision         ; Underwriting
usage = @me_usage                             ; Usage info

; ---------------------------------------------------------------------------
; Coverage Summary
; ---------------------------------------------------------------------------
{.coverage_summary}
equipment_count = ##                          ; Number of items
liability_limit = :                           ; Liability string
total_insured_value = #$:(0..)                ; Total value

{@mobile_equipment_policy}


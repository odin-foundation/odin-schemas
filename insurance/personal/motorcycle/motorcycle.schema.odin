; ===================================================================================
; ODIN Motorcycle Insurance Schema
; ===================================================================================
; Motorcycle insurance covering standard, sport, touring, cruiser, off-road, and
; three-wheel motorcycles with liability, collision, comprehensive, UM/UIM, PIP,
; custom parts/equipment, and accessory coverage.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.motorcycle"
version = "1.0.0"
title = "Motorcycle Insurance Schema"
description = "Comprehensive motorcycle and powersports vehicle insurance"

{$derivation}
source[0].authority = "National Association of Insurance Commissioners (NAIC)"
source[0].citation = "Personal Lines Insurance Data Model"
source[0].url = "https://content.naic.org/"

source[1].authority = "Motorcycle Industry Council (MIC)"
source[1].citation = "Motorcycle Classification Standards"
source[1].url = "https://www.mic.org/"

source[2].authority = "National Highway Traffic Safety Administration (NHTSA)"
source[2].citation = "Motorcycle Safety Standards"
source[2].url = "https://www.nhtsa.gov/road-safety/motorcycles"

source[3].authority = "California Department of Insurance"
source[3].citation = "Motorcycle Insurance Consumer Guide"
source[3].url = "https://www.insurance.ca.gov/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on MIC classifications and state insurance regulations"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial motorcycle insurance schema"
changelog[0].rationale = "Personal lines coverage for motorcycles and powersports"

; ===================================================================================
; Motorcycle Type Classification
; ===================================================================================
; Standard motorcycle and powersports classifications.

{@mc_vehicle_type}
category = (
    atv,                                      ; All-terrain vehicle
    cruiser,                                  ; Cruiser motorcycle
    dirt_bike,                                ; Off-road motorcycle
    dual_sport,                               ; On/off road capable
    electric,                                 ; Electric motorcycle
    moped,                                    ; Moped (under 50cc)
    scooter,                                  ; Motor scooter
    sidecar,                                  ; Motorcycle with sidecar
    snowmobile,                               ; Snowmobile
    sport,                                    ; Sport/supersport bike
    sport_touring,                            ; Sport-touring
    standard,                                 ; Standard/naked bike
    three_wheeler,                            ; Trike, Spyder, Slingshot
    touring,                                  ; Full touring bike
    utv                                       ; Utility task vehicle
)

engine_displacement = ##                      ; Engine size in cc
street_legal = ?                              ; Street legal vehicle
wheel_count = ##:(2..4)                       ; Number of wheels

; ===================================================================================
; Motorcycle Vehicle Details
; ===================================================================================
; Detailed motorcycle specifications.

{@mc_vehicle}
; Required fields first
make = :                                     ; Manufacturer
model = :                                    ; Model name
model_year = ##:(1900..2100)                 ; Model year
vehicle_type = @mc_vehicle_type              ; Vehicle classification
vin = *:/^[A-HJ-NPR-Z0-9]{17}$/              ; Vehicle identification number

; Optional fields
abs_brakes = ?                                ; Has ABS brakes
anti_theft = ?                                ; Has anti-theft device
anti_theft_type = (
    alarm,                                    ; Alarm system
    gps_tracking,                             ; GPS tracker
    ignition_kill,                            ; Kill switch
    wheel_lock                                ; Disc lock
):if anti_theft = true
bore_stroke = :                               ; Engine bore x stroke
color = :                                     ; Primary color
compression_ratio = :                         ; Engine compression
condition = (excellent, fair, good, poor)     ; Overall condition
cooling = (air, liquid, oil)                  ; Cooling system type
custom_built = ?                              ; Custom-built vehicle
cylinders = ##                                ; Number of cylinders
engine_configuration = (
    flat,                                     ; Flat/boxer
    inline,                                   ; Inline
    single,                                   ; Single cylinder
    v_twin,                                   ; V-twin
    v_four                                    ; V-four
)
final_drive = (belt, chain, shaft)            ; Final drive type
fuel_capacity_gallons = #                     ; Tank capacity
fuel_injection = ?                            ; Fuel injected
garage_kept = ?                               ; Stored in garage
garaging_address = @address                   ; Storage location
horsepower = ##                               ; Engine horsepower
license_plate = :                             ; License plate number
license_state = :(2)                          ; Registration state
modifications[] = :                           ; Aftermarket modifications
msrp = #$:(0..)                               ; Original MSRP
odometer = ##                                 ; Current mileage
original_owner = ?                            ; First owner
purchase_date = date                          ; Acquisition date
purchase_price = #$:(0..)                     ; Purchase price
registration_expiration = date                ; Registration expiry
salvage_title = ?                             ; Salvage/rebuilt title
seat_height_inches = #                        ; Seat height
traction_control = ?                          ; Has traction control
transmission_speeds = ##                      ; Number of gears
vehicle_id = :                                ; Internal identifier
weight_lbs = ##                               ; Dry weight

; ---------------------------------------------------------------------------
; Three-Wheeler Specific
; ---------------------------------------------------------------------------
{.three_wheeler}
configuration = (
    delta,                                    ; Two wheels rear
    tadpole                                   ; Two wheels front
):if vehicle_type.wheel_count = 3
enclosed = ?:if vehicle_type.wheel_count = 3  ; Has enclosure
reverse = ?:if vehicle_type.wheel_count = 3   ; Has reverse gear

{@mc_vehicle}

; ---------------------------------------------------------------------------
; Off-Road Specific
; ---------------------------------------------------------------------------
{.off_road}
competition_use = ?:if vehicle_type.category = dirt_bike
four_wheel_drive = ?:if vehicle_type.category = (atv, utv)
roll_cage = ?:if vehicle_type.category = utv
seating_capacity = ##:if vehicle_type.category = utv

{@mc_vehicle}

; ===================================================================================
; Motorcycle Usage
; ===================================================================================
; Usage patterns affecting rating.

{@mc_usage}
; Required fields first
primary_use = (
    business,                                 ; Business use
    commuting,                                ; Daily commute
    competition,                              ; Racing/competition
    off_road_only,                            ; Off-road only
    pleasure_only,                            ; Pleasure/recreation
    touring                                   ; Long-distance touring
)

; Optional fields
annual_miles = ##                             ; Estimated annual miles
club_membership = ?                           ; Riding club member
commute_distance = ##                         ; One-way commute miles
group_riding = ?                              ; Rides with groups
months_ridden = ##:(1..12)                    ; Months ridden per year
multi_vehicle_discount = ?                    ; Other vehicles insured
other_motorcycles = ##                        ; Other bikes owned
passengers_carried = ?                        ; Carries passengers
seasonal_use = ?                              ; Seasonal only use
track_days = ?                                ; Track day participation

; ===================================================================================
; Rider Information
; ===================================================================================
; Rider details for rating.

{@mc_rider}
; Required fields first
date_of_birth = *date                        ; Rider DOB
name = @person_name                          ; Rider name
relationship = (
    child,                                    ; Child of insured
    domestic_partner,                         ; Domestic partner
    employee,                                 ; Employee
    other,                                    ; Other relationship
    self,                                     ; Primary insured
    spouse                                    ; Spouse
)

; Optional fields
drivers_license = *:                          ; License number
endorsement_type = (
    class_m,                                  ; Full motorcycle
    class_m1,                                 ; Two-wheel only
    class_m2,                                 ; Moped/scooter
    learners_permit,                          ; Learner's permit
    three_wheel                               ; Three-wheel only
)
license_state = :(2)                          ; Issuing state
marital_status = (divorced, married, single, widowed)
motorcycle_endorsement = ?                    ; Has MC endorsement
occupation = :                                ; Occupation
rider_id = :                                  ; Internal identifier
sex = (female, male)                          ; Gender
years_licensed = ##                           ; Years with MC license
years_riding = ##                             ; Total years experience

; ---------------------------------------------------------------------------
; Training and Certification
; ---------------------------------------------------------------------------
{.training}
advanced_course = ?                           ; Advanced riding course
advanced_course_date = date:if training.advanced_course = true
basic_course = ?                              ; Basic rider course
basic_course_date = date:if training.basic_course = true
instructor_certified = ?                      ; Certified instructor
msf_certified = ?                             ; MSF course completion
track_training = ?                            ; Track-based training

{@mc_rider}

; ---------------------------------------------------------------------------
; Driving Record
; ---------------------------------------------------------------------------
accidents_3_years = ##:(0..10)                ; At-fault accidents
at_fault_accidents = ##:(0..10)               ; At-fault only
dui_dwi = ?                                   ; DUI/DWI history
major_violations_3_years = ##:(0..10)         ; Major violations
minor_violations_3_years = ##:(0..10)         ; Minor violations
motorcycle_accidents = ##:(0..10)             ; MC-specific accidents
sr22_required = ?                             ; SR-22 filing
suspended_revoked = ?                         ; License issues

; ===================================================================================
; Liability Coverage
; ===================================================================================
; Motorcycle liability coverage.

{@mc_liability}
; Required fields first
bodily_injury_per_accident = #$:(0..)        ; BI per accident limit
bodily_injury_per_person = #$:(0..)          ; BI per person limit
property_damage = #$:(0..)                   ; PD limit

; Optional fields
combined_single_limit = #$:(0..)              ; CSL if used
guest_passenger_liability = ?                 ; Passenger coverage
liability_form = (combined_single_limit, split_limits)

; ===================================================================================
; Uninsured/Underinsured Motorist
; ===================================================================================
; UM/UIM coverage for motorcycle.

{@mc_um_coverage}
bodily_injury_per_accident = #$:(0..)         ; UM BI per accident
bodily_injury_per_person = #$:(0..)           ; UM BI per person
property_damage = #$:(0..)                    ; UMPD
stacked = ?                                   ; Stacked coverage
underinsured_included = ?                     ; UIM included
underinsured_per_accident = #$:(0..)          ; UIM per accident
underinsured_per_person = #$:(0..)            ; UIM per person

; ===================================================================================
; Medical Payments
; ===================================================================================
; Medical payments coverage.

{@mc_medical_payments}
included = ?                                  ; Coverage included
limit_per_person = #$:(0..)                   ; Per person limit
passenger_medical = ?                         ; Passengers covered

; ===================================================================================
; Physical Damage Coverage
; ===================================================================================
; Comprehensive and collision coverage.

{@mc_physical_damage}
; Required fields first
coverage_type = (collision, comprehensive)   ; Coverage type

; Optional fields
actual_cash_value = #$:(0..)                  ; ACV
agreed_value = #$:(0..)                       ; Agreed value
deductible = #$:(0..)                         ; Deductible amount
disappearing_deductible = ?                   ; Diminishing deductible
lay_up_period = ?                             ; Seasonal lay-up
lay_up_months[] = ##:(1..12):if lay_up_period = true
original_equipment = ?                        ; OEM parts only
stated_amount = #$:(0..)                      ; Stated value
valuation = (
    actual_cash_value,
    agreed_value,
    replacement_cost,
    stated_amount
)

; ===================================================================================
; Accessory Coverage
; ===================================================================================
; Coverage for motorcycle accessories and custom parts.

{@mc_accessory_coverage}
; Optional coverage
included = ?                                  ; Coverage included
limit = #$:(0..)                              ; Total accessories limit
per_item_limit = #$:(0..)                     ; Per-item sublimit

; Covered categories
audio_equipment = ?                           ; Audio systems
chrome_accessories = ?                        ; Chrome parts
custom_exhaust = ?                            ; Exhaust systems
custom_paint = ?                              ; Custom paint/graphics
luggage = ?                                   ; Saddlebags, tour packs
performance_parts = ?                         ; Performance upgrades
safety_equipment = ?                          ; Guards, bars

; ---------------------------------------------------------------------------
; Scheduled Accessories
; ---------------------------------------------------------------------------
{.scheduled_items[]}
accessory_type = :                            ; Type of accessory
description = :                              ; Description
value = #$:(0..)                             ; Accessory value

{@mc_accessory_coverage}

; ===================================================================================
; Safety Apparel Coverage
; ===================================================================================
; Coverage for riding gear and apparel.

{@mc_safety_apparel}
; Optional coverage
included = ?                                  ; Coverage included
limit = #$:(0..)                              ; Total apparel limit
per_item_limit = #$:(0..)                     ; Per-item sublimit

; Covered items
boots = ?                                     ; Riding boots
gloves = ?                                    ; Riding gloves
helmet = ?                                    ; Helmet coverage
jacket = ?                                    ; Riding jacket
pants = ?                                     ; Riding pants
suit = ?                                      ; Full riding suit

; ===================================================================================
; Roadside Assistance
; ===================================================================================
; Roadside assistance coverage.

{@mc_roadside}
included = ?                                  ; Coverage included
provider = :                                  ; Service provider

; Covered services
battery_service = ?                           ; Battery jump
flat_tire = ?                                 ; Tire repair
fuel_delivery = ?                             ; Fuel delivery
lockout = ?                                   ; Lockout service
towing = ?                                    ; Towing
towing_limit = #$:(0..):if towing = true      ; Towing limit

; ===================================================================================
; Trip Interruption Coverage
; ===================================================================================
; Coverage for trip interruption expenses.

{@mc_trip_interruption}
; Optional coverage
included = ?                                  ; Coverage included
limit_per_day = #$:(0..)                      ; Daily limit
max_days = ##                                 ; Maximum days
minimum_miles_from_home = ##                  ; Minimum distance

; Covered expenses
lodging = ?                                   ; Hotel/motel
meals = ?                                     ; Meal expenses
rental_vehicle = ?                            ; Rental vehicle
transportation = ?                            ; Alt transportation

; ===================================================================================
; Transport Trailer Coverage
; ===================================================================================
; Coverage for motorcycle transport trailer.

{@mc_trailer_coverage}
; Optional coverage
included = ?                                  ; Trailer coverage included
trailer_value = #$:(0..)                      ; Trailer value
trailer_vin = :                               ; Trailer VIN if applicable

; Coverages
collision = ?                                 ; Collision coverage
collision_deductible = #$:(0..):if collision = true
comprehensive = ?                             ; Comprehensive coverage
comprehensive_deductible = #$:(0..):if comprehensive = true
liability = ?                                 ; Trailer liability

; ===================================================================================
; Premium Details
; ===================================================================================
; Premium calculation components.

{@mc_premium}
; Required fields first
total_premium = #$:(0..)                     ; Total annual premium

; Optional fields
accessory_premium = #$:(0..)                  ; Accessory coverage
apparel_premium = #$:(0..)                    ; Safety apparel
collision_premium = #$:(0..)                  ; Collision premium
comprehensive_premium = #$:(0..)              ; Comprehensive premium
liability_premium = #$:(0..)                  ; Liability premium
medical_payments_premium = #$:(0..)           ; Med pay premium
minimum_premium = #$:(0..)                    ; Minimum premium
policy_fee = #$:(0..)                         ; Policy fee
roadside_premium = #$:(0..)                   ; Roadside assistance
taxes_and_fees = #$:(0..)                     ; Taxes and fees
trailer_premium = #$:(0..)                    ; Trailer coverage
trip_interruption_premium = #$:(0..)          ; Trip interruption
um_uim_premium = #$:(0..)                     ; UM/UIM premium

; ---------------------------------------------------------------------------
; Discounts
; ---------------------------------------------------------------------------
{.discounts}
anti_theft = ?                                ; Anti-theft device
claim_free = ?                                ; Claims-free
club_membership = ?                           ; Riding club
experienced_rider = ?                         ; Experience discount
homeowner = ?                                 ; Homeowner
loyalty = ?                                   ; Loyalty discount
multi_bike = ?                                ; Multiple bikes
multi_policy = ?                              ; Multi-policy
msf_course = ?                                ; MSF course
new_bike = ?                                  ; New vehicle
paid_in_full = ?                              ; Pay in full
safety_course = ?                             ; Any safety course
transfer = ?                                  ; Transfer discount

{@mc_premium}

; ===================================================================================
; Prior Claims
; ===================================================================================
; Claims history.

{@mc_prior_claim}
; Required fields first
claim_date = date                            ; Date of loss
claim_type = (
    collision,
    comprehensive,
    liability_bi,
    liability_pd,
    other,
    theft,
    total_loss,
    um_uim
)

; Optional fields
amount_paid = #$:(0..)                        ; Amount paid
at_fault = ?                                  ; At-fault indicator
claim_id = :                                  ; Claim identifier
claim_status = (closed, open, subrogation)
description = :                               ; Loss description
injuries = ?                                  ; Injuries involved

; ===================================================================================
; Exclusions
; ===================================================================================
; Policy exclusions.

{@mc_exclusions}
; Standard exclusions
business_use = ?true                          ; Business use
intentional_damage = ?true                    ; Intentional acts
racing = ?true                                ; Racing/competition
rental = ?true                                ; Rental to others
war = ?true                                   ; War/terrorism

; Optional exclusions
off_road = ?                                  ; Off-road use
stunt_riding = ?                              ; Stunt/wheelies
unlicensed_rider = ?                          ; Unlicensed rider

; ===================================================================================
; Endorsements
; ===================================================================================
; Policy endorsements.

{@mc_endorsement}
; Required fields first
effective_date = date                        ; Effective date
endorsement_type = (
    accessory_coverage,                       ; Custom parts/accessories
    agreed_value,                             ; Agreed value
    laid_up,                                  ; Seasonal storage
    loan_lease,                               ; Gap coverage
    oem_parts,                                ; Original parts
    other,                                    ; Other
    roadside,                                 ; Roadside assistance
    safety_apparel,                           ; Riding gear
    total_loss_replacement,                   ; New bike replacement
    trailer,                                  ; Trailer coverage
    trip_interruption                         ; Trip interruption
)

; Optional fields
description = :                               ; Description
endorsement_id = :                            ; Endorsement ID
premium = #$:(0..)                            ; Endorsement premium

; ===================================================================================
; Motorcycle Insurance Policy
; ===================================================================================
; Complete policy composition.

{@motorcycle_policy}
; Required fields first
effective_date = date                        ; Policy effective date
expiration_date = date                       ; Policy expiration date
liability = @mc_liability                    ; Liability coverage
policy_number = :                            ; Policy number
riders[] = @mc_rider                         ; Covered riders
vehicle = @mc_vehicle                        ; Covered motorcycle

; Invariants
:invariant expiration_date > effective_date

; Optional fields
accessory_coverage = @mc_accessory_coverage   ; Accessories
agency = @agency                              ; Issuing agency
billing_address = @address                    ; Billing address
collision = @mc_physical_damage               ; Collision
comprehensive = @mc_physical_damage           ; Comprehensive
endorsements[] = @mc_endorsement              ; Endorsements
exclusions = @mc_exclusions                   ; Exclusions
id = :                                        ; Internal ID
medical_payments = @mc_medical_payments       ; Med pay
named_insured = @person_name                  ; Named insured
named_insured_address = @address              ; Insured address
policy_status = (
    active,
    cancelled,
    expired,
    pending,
    renewal
)
premium = @mc_premium                         ; Premium details
prior_claims[] = @mc_prior_claim              ; Prior claims
producer = @producer                          ; Agent
roadside = @mc_roadside                       ; Roadside assistance
safety_apparel = @mc_safety_apparel           ; Apparel coverage
state_province = :(2)                         ; Issuing state
term_months = ##:(1..12)                      ; Policy term
trailer_coverage = @mc_trailer_coverage       ; Trailer coverage
trip_interruption = @mc_trip_interruption     ; Trip interruption
um_uim = @mc_um_coverage                      ; UM/UIM coverage
underwriting = @underwriting_decision         ; Underwriting
usage = @mc_usage                             ; Usage info

; ---------------------------------------------------------------------------
; Coverage Summary
; ---------------------------------------------------------------------------
{.coverage_summary}
collision_deductible = #$:(0..)
comprehensive_deductible = #$:(0..)
liability_limits = :                          ; Liability string
total_insured_value = #$:(0..)

{@motorcycle_policy}


; ===================================================================================
; ODIN Classic and Collector Auto Insurance Schema
; ===================================================================================
; Classic and collector auto insurance for antique, vintage, classic, exotic, and
; special interest vehicles with agreed value coverage, limited use restrictions,
; storage requirements, and spare parts/automobilia coverage.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.classic-auto"
version = "1.0.0"
title = "Classic and Collector Auto Insurance Schema"
description = "Insurance for antique, classic, vintage, and collector vehicles"

{$derivation}
source[0].authority = "Classic Car Club of America"
source[0].citation = "Classic Car Classification Standards"
source[0].url = "https://www.classiccarclub.org/"

source[1].authority = "Antique Automobile Club of America"
source[1].citation = "AACA Vehicle Classification Guidelines"
source[1].url = "https://www.aaca.org/"

source[2].authority = "National Association of Insurance Commissioners (NAIC)"
source[2].citation = "Specialty Auto Insurance Model Provisions"
source[2].url = "https://content.naic.org/"

source[3].authority = "California Department of Insurance"
source[3].citation = "Collector Vehicle Insurance Regulations"
source[3].url = "https://www.insurance.ca.gov/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on CCCA/AACA classifications and state insurance regulations"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial classic and collector auto insurance schema"
changelog[0].rationale = "Personal lines coverage for collector and antique vehicles"

; ===================================================================================
; Vehicle Classification
; ===================================================================================
; Classifications for collector and classic vehicles.

{@ca_vehicle_class}
classification = (
    antique,                                  ; 25+ years, substantially original
    barn_find,                                ; Unrestored original discovery
    classic,                                  ; 20-40 years, collectible
    custom,                                   ; Custom-built vehicle
    exotic,                                   ; High-value exotic/supercar
    hot_rod,                                  ; Hot rod/street rod
    kit_car,                                  ; Kit car or replica
    military,                                 ; Military vehicle
    modified,                                 ; Modified classic
    muscle_car,                               ; Classic muscle car
    project,                                  ; Under restoration
    replica,                                  ; Replica vehicle
    resto_mod,                                ; Restored with modern updates
    sports_car,                               ; Classic sports car
    vintage                                   ; Pre-1930 vehicle
)

; Registration type affects rating
registration_type = (
    antique_plate,                            ; Antique/historic plates
    collector_plate,                          ; Collector plates
    standard_registration,                    ; Standard registration
    year_of_manufacture                       ; YOM plates
)

; ===================================================================================
; Vehicle Condition
; ===================================================================================
; Condition rating for valuation purposes.

{@ca_condition}
; Overall condition rating (AACA scale)
overall_rating = (
    concours,                                 ; 1 - Perfect, show quality
    excellent,                                ; 2 - Excellent, minor flaws
    fine,                                     ; 3 - Well above average
    good,                                     ; 4 - Above average
    fair,                                     ; 5 - Average driver
    restorable                                ; 6 - Restorable, needs work
)

; Component ratings
body_condition = (excellent, fair, good, poor)
chrome_condition = (excellent, fair, good, none, poor)
drivetrain_condition = (excellent, fair, good, needs_work, poor)
electrical_condition = (excellent, fair, good, modified, poor)
glass_condition = (excellent, fair, good, poor, replaced)
interior_condition = (excellent, fair, good, poor, reupholstered)
mechanical_condition = (excellent, fair, good, needs_work, poor)
paint_condition = (excellent, fair, good, original, poor, repainted)
rust_condition = (none, repaired, significant, surface_rust)
tire_condition = (excellent, fair, good, needs_replacement, period_correct, poor)
upholstery_condition = (excellent, fair, good, original, poor, replaced)

; ===================================================================================
; Provenance and History
; ===================================================================================
; Ownership history and documentation.

{@ca_provenance}
; Documentation
bill_of_sale = ?                              ; Original bill of sale
build_sheet = ?                               ; Factory build sheet
dealer_invoice = ?                            ; Original dealer invoice
historical_documents[] = :                    ; Other historical docs
original_title = ?                            ; Original title
owner_history_documented = ?                  ; Complete owner history
window_sticker = ?                            ; Original window sticker

; Ownership
celebrity_owned = ?                           ; Celebrity provenance
first_owner_name = :                          ; Original owner name
owner_count = ##                              ; Total owners
race_history = ?                              ; Racing provenance
significant_provenance = ?                    ; Notable history

; Awards and Recognition
awards[] = :                                  ; Show awards won
concours_appearances = ##                     ; Concours entries
magazine_features[] = :                       ; Magazine coverage
registry_listed = ?                           ; Listed in registry

; ===================================================================================
; Restoration Details
; ===================================================================================
; Restoration history and work performed.

{@ca_restoration}
; Restoration status
restoration_status = (
    barn_find,                                ; Unrestored as discovered
    body_off,                                 ; Body-off restoration
    concours,                                 ; Concours-level restoration
    custom_modified,                          ; Custom restoration
    frame_off,                                ; Frame-off restoration
    none,                                     ; Never restored
    numbers_matching,                         ; Numbers-matching restoration
    ongoing,                                  ; In-progress restoration
    partial,                                  ; Partial restoration
    rolling,                                  ; Rolling restoration
    survivor                                  ; Unrestored survivor
)

; Restoration details
completion_date = date:if restoration_status != (none, ongoing, survivor)
cost_of_restoration = #$:(0..):if restoration_status != (none, survivor)
documentation[] = :                           ; Restoration documentation
performing_shop = :                           ; Shop name
start_date = date:if restoration_status != (none, survivor)

; Authenticity
correct_components = ?                        ; Period-correct parts
numbers_matching = ?                          ; Matching numbers
original_components[] = :                     ; List of originals
original_engine = ?                           ; Original engine
original_transmission = ?                     ; Original transmission
replacement_components[] = :                  ; List of replacements

; ===================================================================================
; Valuation
; ===================================================================================
; Vehicle appraisal and valuation details.

{@ca_valuation}
; Required fields first
agreed_value = #$:(0..)                      ; Agreed insurance value
valuation_date = date                        ; Date of valuation

; Optional fields
appraiser_credentials = :                     ; Appraiser qualifications
appraiser_name = :                            ; Appraiser name
auction_comparables[] = :                     ; Comparable sales
current_market_value = #$:(0..)               ; Current market estimate
insurance_value = #$:(0..)                    ; Insurance stated value
next_appraisal_due = date                     ; Reappraisal due date
original_msrp = #$:(0..)                      ; Original MSRP
purchase_price = #$:(0..)                     ; Owner's purchase price
replacement_value = #$:(0..)                  ; Replacement cost
restoration_value = #$:(0..):if ca_restoration.restoration_status != (none, survivor)
valuation_id = :                              ; Valuation record ID
valuation_method = (
    auction_analysis,                         ; Auction sales analysis
    comparable_sales,                         ; Similar vehicle sales
    cost_approach,                            ; Cost to replace/restore
    market_analysis,                          ; Market trend analysis
    professional_appraisal                    ; Professional appraiser
)
valuation_source = (
    auction_house,                            ; Auction company
    dealer,                                   ; Classic car dealer
    independent_appraiser,                    ; Independent appraiser
    insurance_company,                        ; Carrier appraisal
    owner_stated,                             ; Owner declaration
    price_guide                               ; Published guide
)

; Published guide values
hagerty_value = #$:(0..)                      ; Hagerty valuation
nada_classic_value = #$:(0..)                 ; NADA classic value
sports_car_market_value = #$:(0..)            ; SCM value

; ---------------------------------------------------------------------------
; Appraisal Documents
; ---------------------------------------------------------------------------
{.appraisal}
appraisal_document = :                        ; Document reference
appraisal_fee = #$:(0..)                      ; Appraisal cost
appraisal_photos[] = :                        ; Photo references
certification = :                             ; Appraiser certification
expiration_date = date                        ; Appraisal expiration
next_appraisal = date                         ; Next required

{@ca_valuation}

; ===================================================================================
; Classic Vehicle Details
; ===================================================================================
; Comprehensive classic vehicle information.

{@ca_vehicle}
; Required fields first
body_style = :                               ; Body style description
make = :                                     ; Manufacturer
model = :                                    ; Model name
model_year = ##:(1886..2100)                 ; Model year
vehicle_class = @ca_vehicle_class            ; Classification
vin = *:                                     ; VIN or serial number

; Optional fields
body_number = :                               ; Body number (if separate)
color_code = :                                ; Factory color code
condition = @ca_condition                     ; Condition rating
country_of_origin = :                         ; Manufacturing country
cowl_tag = :                                  ; Cowl tag data
cylinders = ##                                ; Engine cylinders
data_plate = :                                ; Data plate info
displacement_ci = ##                          ; Engine size in cubic inches
displacement_liters = #                       ; Engine size in liters
drivetrain = (awd, fwd, rwd)                  ; Drive configuration
engine_number = :                             ; Engine serial number
engine_type = :                               ; Engine description
exterior_color = :                            ; Exterior color
factory_options[] = :                         ; Factory-installed options
fender_tag = :                                ; Fender tag info
fuel_type = (diesel, electric, gas, steam)    ; Fuel type
garage_kept = ?                               ; Stored in garage
garaging_address = @address                   ; Storage location
horsepower = ##                               ; Engine horsepower
interior_color = :                            ; Interior color
license_plate = :                             ; License plate
license_state = :(2)                          ; Registration state
odometer = ##                                 ; Current mileage
odometer_exempt = ?                           ; Exempt from odometer law
original_odometer = ##                        ; Mileage when purchased
plant_code = :                                ; Manufacturing plant
production_number = ##                        ; Production sequence
provenance = @ca_provenance                   ; Ownership history
purchase_date = date                          ; Acquisition date
registration_expiration = date                ; Registration expiry
restoration = @ca_restoration                 ; Restoration details
series = :                                    ; Model series
torque = ##                                   ; Engine torque
transmission_number = :                       ; Transmission serial
transmission_type = (automatic, manual, semi_automatic)
transmission_speeds = ##                      ; Number of gears
trim_level = :                                ; Trim package
valuation = @ca_valuation                     ; Valuation info
vehicle_id = :                                ; Internal identifier
weight_lbs = ##                               ; Vehicle weight
wheelbase_inches = ##                         ; Wheelbase

; ---------------------------------------------------------------------------
; Spare Parts
; ---------------------------------------------------------------------------
{.spare_parts}
engines = ##                                  ; Spare engines
included_in_value = ?                         ; Parts in agreed value
parts_inventory[] = :                         ; Parts list
parts_value = #$:(0..)                        ; Total parts value
transmissions = ##                            ; Spare transmissions

{@ca_vehicle}

; ---------------------------------------------------------------------------
; Security and Storage
; ---------------------------------------------------------------------------
{.security}
alarm_system = ?                              ; Alarm installed
battery_disconnect = ?                        ; Battery cutoff
fuel_shutoff = ?                              ; Fuel shutoff
gps_tracking = ?                              ; GPS tracker
hidden_kill_switch = ?                        ; Kill switch
locked_garage = ?                             ; Locked storage
security_system = ?                           ; General security

{@ca_vehicle}

; ===================================================================================
; Usage Restrictions
; ===================================================================================
; Usage limitations for classic vehicle policies.

{@ca_usage}
; Required restrictions
primary_use = (
    club_activities,                          ; Club events only
    exhibition,                               ; Shows and exhibitions
    limited_pleasure,                         ; Limited pleasure use
    parade,                                   ; Parades and displays
    pleasure,                                 ; General pleasure
    restoration                               ; Being restored
)

; Mileage limits
annual_mileage_limit = ##                     ; Annual mileage cap
mileage_verification = ?                      ; Mileage verified

; Excluded uses
commuting = ?false                            ; No commuting
daily_driver = ?false                         ; Not daily driver
racing = ?false                               ; No racing
rental = ?false                               ; No rental

; Permitted activities
car_shows = ?                                 ; Show participation
club_events = ?                               ; Club activities
mechanic_test_drives = ?                      ; Shop test drives
parades = ?                                   ; Parade use
rallies = ?                                   ; Rally events
touring = ?                                   ; Extended touring

; ===================================================================================
; Liability Coverage
; ===================================================================================
; Standard liability coverage.

{@ca_liability}
; Required fields first
bodily_injury_per_accident = #$:(0..)        ; BI per accident
bodily_injury_per_person = #$:(0..)          ; BI per person
property_damage = #$:(0..)                   ; PD limit

; Optional fields
combined_single_limit = #$:(0..)              ; CSL if used
liability_form = (combined_single_limit, split_limits)

; ===================================================================================
; Physical Damage Coverage
; ===================================================================================
; Agreed value comprehensive and collision.

{@ca_physical_damage}
; Required fields first
agreed_value = #$:(0..)                      ; Agreed value amount
coverage_type = (collision, comprehensive)   ; Coverage type

; Optional fields
deductible = #$:(0..)                         ; Deductible amount
disappearing_deductible = ?                   ; Diminishing deductible
inflation_guard = ?                           ; Automatic value increase
inflation_guard_percent = #:(0..10):if inflation_guard = true
zero_deductible_available = ?                 ; Zero deductible option

; ===================================================================================
; Spare Parts Coverage
; ===================================================================================
; Coverage for spare parts inventory.

{@ca_spare_parts_coverage}
included = ?                                  ; Coverage included
limit = #$:(0..)                              ; Parts coverage limit
deductible = #$:(0..)                         ; Parts deductible
location = @address                           ; Storage location
off_premises = ?                              ; Covered off-premises
scheduled_parts[] = :                         ; Scheduled parts list

; ===================================================================================
; Auto Show and Event Coverage
; ===================================================================================
; Coverage while at shows and events.

{@ca_show_coverage}
included = ?                                  ; Coverage included
event_liability = ?                           ; Liability at events
event_liability_limit = #$:(0..):if event_liability = true
in_transit_to_show = ?                        ; Transit coverage
on_display = ?                                ; Display coverage
trophy_coverage = ?                           ; Covers trophies/awards

; ===================================================================================
; Trip Interruption
; ===================================================================================
; Trip interruption coverage for touring.

{@ca_trip_interruption}
included = ?                                  ; Coverage included
daily_limit = #$:(0..)                        ; Daily expense limit
max_days = ##                                 ; Maximum days
minimum_distance = ##                         ; Minimum miles from home

; Covered expenses
lodging = ?                                   ; Hotel expenses
meals = ?                                     ; Meal expenses
rental_car = ?                                ; Rental vehicle
return_transportation = ?                     ; Return travel

; ===================================================================================
; Diminished Value Coverage
; ===================================================================================
; Coverage for loss in value after repair.

{@ca_diminished_value}
included = ?                                  ; Coverage included
limit = #$:(0..)                              ; Maximum recovery
deductible = #$:(0..)                         ; Deductible

; ===================================================================================
; Towing and Transport
; ===================================================================================
; Specialized towing requirements.

{@ca_towing}
included = ?                                  ; Coverage included
flatbed_only = ?                              ; Requires flatbed
enclosed_transport = ?                        ; Enclosed carrier option
limit_per_occurrence = #$:(0..)               ; Towing limit
provider = :                                  ; Preferred provider

; ===================================================================================
; Premium Details
; ===================================================================================
; Premium information.

{@ca_premium}
; Required fields first
total_premium = #$:(0..)                     ; Total annual premium

; Optional fields
collision_premium = #$:(0..)                  ; Collision premium
comprehensive_premium = #$:(0..)              ; Comprehensive premium
liability_premium = #$:(0..)                  ; Liability premium
minimum_premium = #$:(0..)                    ; Minimum premium
policy_fee = #$:(0..)                         ; Policy fee
spare_parts_premium = #$:(0..)                ; Spare parts coverage
taxes_and_fees = #$:(0..)                     ; Taxes and fees
trip_interruption_premium = #$:(0..)          ; Trip interruption

; ---------------------------------------------------------------------------
; Discounts
; ---------------------------------------------------------------------------
{.discounts}
alarm = ?                                     ; Alarm discount
club_member = ?                               ; Car club member
garaged = ?                                   ; Garage storage
limited_use = ?                               ; Limited mileage
multi_car = ?                                 ; Multiple classics
multi_policy = ?                              ; Multi-policy
safe_driver = ?                               ; Clean driving record
vehicle_tracking = ?                          ; GPS tracking

{@ca_premium}

; ===================================================================================
; Driver Information
; ===================================================================================
; Driver details for classic vehicle.

{@ca_driver}
; Required fields first
date_of_birth = *date                        ; Driver DOB
name = @person_name                          ; Driver name

; Optional fields
collector_experience_years = ##               ; Years as collector
drivers_license = *:                          ; License number
license_state = :(2)                          ; Issuing state
marital_status = (divorced, married, single, widowed)
occupation = :                                ; Occupation
other_collector_vehicles = ##                 ; Other classics owned
primary_vehicle_daily_driver = ?              ; Has regular daily driver
relationship = (
    child,
    domestic_partner,
    other,
    self,
    spouse
)
sex = (female, male)                          ; Gender
years_licensed = ##                           ; Years licensed

; Driving record
accidents_5_years = ##:(0..10)                ; At-fault accidents
major_violations_5_years = ##:(0..10)         ; Major violations
minor_violations_5_years = ##:(0..10)         ; Minor violations

; ===================================================================================
; Prior Claims
; ===================================================================================
; Claims history.

{@ca_prior_claim}
; Required fields first
claim_date = date                            ; Date of loss
claim_type = (
    collision,
    comprehensive,
    diminished_value,
    liability,
    other,
    spare_parts,
    theft,
    total_loss
)

; Optional fields
amount_paid = #$:(0..)                        ; Claim payment
claim_id = :                                  ; Claim identifier
claim_status = (closed, denied, open)         ; Claim status
description = :                               ; Loss description
vehicle_reference = :                         ; Vehicle involved

; ===================================================================================
; Exclusions
; ===================================================================================
; Policy exclusions.

{@ca_exclusions}
; Standard exclusions
business_use = ?true                          ; No commercial use
commuting = ?true                             ; No commuting
daily_driver = ?true                          ; Not daily driver
intentional_damage = ?true                    ; Intentional acts
racing = ?true                                ; No racing
rental = ?true                                ; No rental
war = ?true                                   ; War/terrorism

; Optional exclusions
drag_racing = ?                               ; Drag racing
off_road = ?                                  ; Off-road use
track_events = ?                              ; Track events
unlicensed_driver = ?                         ; Unlicensed driver

; ===================================================================================
; Endorsements
; ===================================================================================
; Policy endorsements.

{@ca_endorsement}
; Required fields first
effective_date = date                        ; Effective date
endorsement_type = (
    agreed_value_increase,                    ; Value increase
    diminished_value,                         ; Diminished value
    inflation_guard,                          ; Automatic increase
    newly_acquired,                           ; New acquisitions
    other,                                    ; Other
    roadside_assistance,                      ; Roadside
    show_coverage,                            ; Event coverage
    spare_parts,                              ; Parts coverage
    trip_interruption                         ; Trip interruption
)

; Optional fields
description = :                               ; Description
endorsement_id = :                            ; Endorsement ID
premium = #$:(0..)                            ; Endorsement premium

; ===================================================================================
; Classic Auto Insurance Policy
; ===================================================================================
; Complete policy composition.

{@classic_auto_policy}
; Required fields first
drivers[] = @ca_driver                       ; Covered drivers
effective_date = date                        ; Policy effective date
expiration_date = date                       ; Policy expiration date
liability = @ca_liability                    ; Liability coverage
policy_number = :                            ; Policy number
vehicles[] = @ca_vehicle                     ; Covered vehicles

; Invariants
:invariant expiration_date > effective_date

; Optional fields
agency = @agency                              ; Issuing agency
billing_address = @address                    ; Billing address
collision = @ca_physical_damage               ; Collision coverage
comprehensive = @ca_physical_damage           ; Comprehensive coverage
diminished_value = @ca_diminished_value       ; Diminished value
endorsements[] = @ca_endorsement              ; Endorsements
exclusions = @ca_exclusions                   ; Exclusions
id = :                                        ; Internal identifier
named_insured = @person_name                  ; Named insured
named_insured_address = @address              ; Insured address
policy_status = (
    active,
    cancelled,
    expired,
    pending,
    renewal
)
premium = @ca_premium                         ; Premium details
prior_claims[] = @ca_prior_claim              ; Prior claims
producer = @producer                          ; Agent
show_coverage = @ca_show_coverage             ; Show/event coverage
spare_parts = @ca_spare_parts_coverage        ; Spare parts coverage
state_province = :(2)                         ; Issuing state
term_months = ##:(1..12)                      ; Policy term
towing = @ca_towing                           ; Towing coverage
trip_interruption = @ca_trip_interruption     ; Trip interruption
underwriting = @underwriting_decision         ; Underwriting
usage = @ca_usage                             ; Usage restrictions

; ---------------------------------------------------------------------------
; Coverage Summary
; ---------------------------------------------------------------------------
{.coverage_summary}
collision_deductible = #$:(0..)
comprehensive_deductible = #$:(0..)
liability_limits = :                          ; Liability string
total_agreed_value = #$:(0..)                 ; All vehicles
vehicle_count = ##                            ; Number of vehicles

{@classic_auto_policy}


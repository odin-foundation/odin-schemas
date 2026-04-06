; ===================================================================================
; ODIN Garage Insurance Schema
; ===================================================================================
; Garage insurance for auto dealerships, repair shops, service stations, and
; related automotive businesses covering garage liability, garagekeepers,
; dealer's open lot, demo/loaner vehicles, and drive-away collision.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.transportation.garage"
version = "1.0.0"
title = "Garage Insurance Schema"
description = "Garage liability and garagekeepers coverage for automotive businesses"

{$derivation}
source[0].authority = "Insurance Services Office (ISO)"
source[0].citation = "Garage Coverage Form (CA 00 05)"
source[0].url = "https://www.verisk.com/insurance/"

source[1].authority = "National Association of Insurance Commissioners (NAIC)"
source[1].citation = "Commercial Auto Insurance Manual - Garage"
source[1].url = "https://content.naic.org/"

source[2].authority = "National Automobile Dealers Association (NADA)"
source[2].citation = "Dealership Insurance Requirements"
source[2].url = "https://www.nada.org/"

source[3].authority = "Automotive Service Association"
source[3].citation = "Shop Insurance Guidelines"
source[3].url = "https://www.asashop.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on ISO Garage Coverage Form and industry standards"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial garage insurance schema"
changelog[0].rationale = "Commercial transportation coverage for automotive businesses"

; ===================================================================================
; Garage Business Type
; ===================================================================================
; Classification of garage operations.

{@gr_business_type}
business_class = !(
    auto_body_shop,                           ; Collision repair
    auto_detail,                              ; Detailing service
    auto_glass,                               ; Glass repair/replace
    auto_parts,                               ; Parts retailer
    auto_repair,                              ; General repair
    car_wash,                                 ; Car wash
    dealer_franchise,                         ; Franchise new car
    dealer_independent,                       ; Independent used car
    dealer_motorcycle,                        ; Motorcycle dealer
    dealer_rv,                                ; RV dealer
    dealer_trailer,                           ; Trailer dealer
    dealer_truck,                             ; Truck dealer
    fleet_service,                            ; Fleet maintenance
    gas_station,                              ; Service station
    oil_change,                               ; Quick lube
    parking_garage,                           ; Parking facility
    storage_facility,                         ; Vehicle storage
    tire_shop,                                ; Tire dealer
    towing_company,                           ; Tow/recovery
    transmission_shop                         ; Transmission repair
)

; Operations classification
operation_type = (
    dealership,                               ; Vehicle sales
    parking,                                  ; Parking/storage
    repair,                                   ; Repair operations
    service                                   ; Service operations
)

; ===================================================================================
; Garage Location
; ===================================================================================
; Physical location details for garage operations.

{@gr_location}
; Required fields first
address = !@address                           ; Physical address
business_type = !@gr_business_type            ; Business classification
location_number = !##:(1..)                   ; Location sequence

; Optional fields
annual_gross_receipts = #$:(0..)              ; Annual revenue
annual_payroll = #$:(0..)                     ; Payroll amount
building_square_feet = ##                     ; Building size
customer_vehicles_capacity = ##               ; Customer vehicle capacity
dealer_plate_count = ##                       ; Dealer plates
employee_count = ##                           ; Employee count
inventory_value = #$:(0..)                    ; Inventory value
leased_building = ?                           ; Leased premises
location_id = :                               ; Internal identifier
lot_square_feet = ##                          ; Lot size
mechanic_count = ##                           ; Mechanic count
open_24_hours = ?                             ; 24-hour operation
service_bays = ##                             ; Service bay count
storage_lot_locations[] = @address            ; Off-site storage
technician_count = ##                         ; Tech count

; ---------------------------------------------------------------------------
; Security Features
; ---------------------------------------------------------------------------
{.security}
alarm_system = ?                              ; Alarm installed
attendant_on_duty = ?                         ; Attended parking
cctv = ?                                      ; Camera system
fencing = ?                                   ; Fenced lot
gated = ?                                     ; Gated access
guard_service = ?                             ; Security guard
key_control = ?                               ; Key management
lighting = ?                                  ; Lot lighting

{@gr_location}

; ---------------------------------------------------------------------------
; Operations
; ---------------------------------------------------------------------------
{.operations}
body_work = ?                                 ; Collision repair
custom_work = ?                               ; Custom/hot rod
detailing = ?                                 ; Detailing services
glass_work = ?                                ; Glass services
oil_changes = ?                               ; Oil/lube services
painting = ?                                  ; Paint services
parts_sales = ?                               ; Parts retail
salvage = ?                                   ; Salvage operations
service = ?                                   ; General service
tire_sales = ?                                ; Tire sales/service
towing = ?                                    ; Towing services
transmission = ?                              ; Transmission repair
upholstery = ?                                ; Upholstery work
used_parts = ?                                ; Used parts
vehicle_sales = ?                             ; Vehicle sales
welding = ?                                   ; Welding services

{@gr_location}

; ===================================================================================
; Garage Liability Coverage
; ===================================================================================
; Liability coverage for garage operations.

{@gr_liability}
; Required fields first
bodily_injury_per_accident = !#$:(0..)        ; BI per accident
bodily_injury_per_person = !#$:(0..)          ; BI per person
property_damage = !#$:(0..)                   ; PD limit

; Optional fields
combined_single_limit = #$:(0..)              ; CSL
general_aggregate = #$:(0..)                  ; Annual aggregate
liability_form = (combined_single_limit, split_limits)
products_completed_ops_aggregate = #$:(0..)   ; Prod/comp ops aggregate

; Coverage scope
completed_operations = ?true                  ; Comp ops coverage
customer_vehicles = ?true                     ; Liability for cust vehicles
employees_as_insureds = ?                     ; Employee coverage
premises_operations = ?true                   ; Prem/ops coverage
products_liability = ?true                    ; Products coverage

; ===================================================================================
; Garagekeepers Coverage
; ===================================================================================
; Coverage for customer vehicles in care, custody, or control.

{@gr_garagekeepers}
; Required fields first
included = !?                                 ; Garagekeepers coverage

; Coverage terms
deductible = #$:(0..):if included = true      ; Deductible
limit_per_location = #$:(0..):if included = true  ; Per location limit
limit_per_vehicle = #$:(0..):if included = true   ; Per vehicle limit

; Coverage type
coverage_form = (
    direct_primary,                           ; Direct/primary coverage
    excess,                                   ; Excess of owner's insurance
    legal_liability                           ; Legal liability only
):if included = true

; Covered perils
collision = ?:if included = true              ; Collision coverage
comprehensive = ?:if included = true          ; Comprehensive
fire = ?:if included = true                   ; Fire coverage
specified_perils = ?:if included = true       ; Specified perils
theft = ?:if included = true                  ; Theft coverage

; Additional terms
customer_deductible = #$:(0..):if included = true  ; Customer deductible
off_premises = ?:if included = true           ; Off-premises coverage
road_test = ?:if included = true              ; Road test coverage
valet = ?:if included = true                  ; Valet coverage

; ===================================================================================
; Dealers Open Lot Coverage
; ===================================================================================
; Physical damage for dealer inventory.

{@gr_open_lot}
; Required fields first
included = !?                                 ; Open lot coverage

; Coverage terms
deductible = #$:(0..):if included = true      ; Deductible
limit = #$:(0..):if included = true           ; Coverage limit
valuation = (
    actual_cash_value,                        ; ACV
    agreed_value,                             ; Agreed value
    invoice_value,                            ; Invoice cost
    replacement_cost                          ; Replacement
):if included = true

; Covered vehicles
consignment = ?:if included = true            ; Consignment vehicles
customer_vehicles = ?:if included = true      ; Customer vehicles
demonstration = ?:if included = true          ; Demo vehicles
employee_vehicles = ?:if included = true      ; Employee vehicles
new_inventory = ?:if included = true          ; New inventory
service_loaners = ?:if included = true        ; Loaner vehicles
used_inventory = ?:if included = true         ; Used inventory

; Covered perils
collision = ?:if included = true              ; Collision
comprehensive = ?:if included = true          ; Comprehensive
specified_perils = ?:if included = true       ; Specified perils

; Extensions
newly_acquired = ?:if included = true         ; Auto-coverage new
newly_acquired_days = ##:if newly_acquired = true

; ===================================================================================
; False Pretense Coverage
; ===================================================================================
; Coverage for fraud/theft by deception.

{@gr_false_pretense}
included = ?                                  ; False pretense coverage
deductible = #$:(0..):if included = true      ; Deductible
limit = #$:(0..):if included = true           ; Coverage limit

; Covered events
bad_checks = ?:if included = true             ; Bad check fraud
counterfeit = ?:if included = true            ; Counterfeit payment
credit_card_fraud = ?:if included = true      ; Credit card fraud
identity_theft = ?:if included = true         ; ID theft schemes
test_drive_theft = ?:if included = true       ; Test drive theft
title_fraud = ?:if included = true            ; Title fraud

; ===================================================================================
; Demo and Loaner Coverage
; ===================================================================================
; Coverage for demo and loaner vehicles.

{@gr_demo_loaner}
; Demo vehicles
demo_coverage = ?                             ; Demo vehicle coverage
demo_collision = ?:if demo_coverage = true    ; Collision
demo_collision_deductible = #$:(0..):if demo_collision = true
demo_comprehensive = ?:if demo_coverage = true; Comprehensive
demo_comprehensive_deductible = #$:(0..):if demo_comprehensive = true
demo_limit = #$:(0..):if demo_coverage = true ; Coverage limit
demo_vehicle_count = ##:if demo_coverage = true

; Loaner vehicles
loaner_coverage = ?                           ; Loaner coverage
loaner_collision = ?:if loaner_coverage = true
loaner_collision_deductible = #$:(0..):if loaner_collision = true
loaner_comprehensive = ?:if loaner_coverage = true
loaner_comprehensive_deductible = #$:(0..):if loaner_comprehensive = true
loaner_limit = #$:(0..):if loaner_coverage = true
loaner_vehicle_count = ##:if loaner_coverage = true

; ===================================================================================
; Garage Physical Damage
; ===================================================================================
; Physical damage for owned/leased vehicles.

{@gr_physical_damage}
; Coverage type
coverage_type = !(collision, comprehensive, specified_perils)

; Terms
deductible = #$:(0..)                         ; Deductible
limit = #$:(0..)                              ; Coverage limit
valuation = (
    actual_cash_value,
    agreed_value,
    replacement_cost,
    stated_amount
)

; Covered vehicles
owned_vehicles = ?                            ; Owned vehicles
leased_vehicles = ?                           ; Leased vehicles

; ===================================================================================
; Towing Operations
; ===================================================================================
; Coverage for towing operations.

{@gr_towing}
included = ?                                  ; Towing coverage

; Tow truck coverage
hook_liability = #$:(0..):if included = true  ; On-hook liability
hook_deductible = #$:(0..):if included = true ; On-hook deductible
tow_truck_count = ##:if included = true       ; Tow truck count
tow_truck_liability = ?:if included = true    ; Truck liability

; Covered operations
repossession = ?:if included = true           ; Repo towing
roadside_assistance = ?:if included = true    ; Roadside
storage = ?:if included = true                ; Impound storage

; ===================================================================================
; Additional Coverages
; ===================================================================================
; Optional coverage extensions.

{@gr_additional_coverages}
; Property extensions
business_income = ?                           ; BI coverage
business_income_limit = #$:(0..):if business_income = true
debris_removal = ?                            ; Debris removal
equipment_breakdown = ?                       ; Equipment breakdown
signs = ?                                     ; Sign coverage
signs_limit = #$:(0..):if signs = true
tools = ?                                     ; Mechanic tools
tools_limit = #$:(0..):if tools = true

; Liability extensions
contractual_liability = ?                     ; Contractual
employee_benefits_liability = ?               ; EBL
hired_auto = ?                                ; Hired auto
non_owned_auto = ?                            ; Non-owned auto
personal_injury = ?                           ; Personal injury

; Specialized
drive_away_collision = ?                      ; Drive-away
drive_away_limit = #$:(0..):if drive_away_collision = true
mechanical_breakdown = ?                      ; Mech breakdown
pollution_liability = ?                       ; Pollution
pollution_limit = #$:(0..):if pollution_liability = true

; ===================================================================================
; Exclusions
; ===================================================================================
; Standard garage exclusions.

{@gr_exclusions}
; Standard exclusions
aircraft = ?true                              ; Aircraft
asbestos = ?true                              ; Asbestos
expected_intended = ?true                     ; Expected/intended
nuclear = ?true                               ; Nuclear
pollution = ?true                             ; Pollution
racing = ?true                                ; Racing
war = ?true                                   ; War
watercraft = ?true                            ; Watercraft

; Garage-specific
classic_antique = ?                           ; Classic vehicles
consignment = ?                               ; Consignment
customer_owned_parts = ?                      ; Customer parts
mechanical_breakdown = ?                      ; Mech breakdown
professional_services = ?                     ; Professional
restoration = ?                               ; Restoration work
salvage_operations = ?                        ; Salvage
used_parts = ?                                ; Used parts
warranty_work = ?                             ; Warranty claims

; ===================================================================================
; Premium Details
; ===================================================================================
; Garage insurance premium structure.

{@gr_premium}
; Required fields first
total_premium = !#$:(0..)                     ; Total premium

; Optional fields
demo_loaner_premium = #$:(0..)                ; Demo/loaner premium
false_pretense_premium = #$:(0..)             ; False pretense
garagekeepers_premium = #$:(0..)              ; Garagekeepers
liability_premium = #$:(0..)                  ; Garage liability
minimum_premium = #$:(0..)                    ; Minimum premium
open_lot_premium = #$:(0..)                   ; Open lot
physical_damage_premium = #$:(0..)            ; Physical damage
policy_fee = #$:(0..)                         ; Policy fee
taxes_and_fees = #$:(0..)                     ; Taxes/fees
towing_premium = #$:(0..)                     ; Towing

; ---------------------------------------------------------------------------
; Rating Factors
; ---------------------------------------------------------------------------
{.rating}
claim_experience = #                          ; Experience mod
gross_receipts_factor = #                     ; Receipts factor
inventory_factor = #                          ; Inventory factor
location_factor = #                           ; Territory
operations_factor = #                         ; Operations type
payroll_factor = #                            ; Payroll-based
vehicle_count_factor = #                      ; Vehicle count

{@gr_premium}

; ===================================================================================
; Claims
; ===================================================================================
; Garage claims structure.

{@gr_claim}
; Required fields first
claim_date = !date                            ; Claim date
claim_type = !(
    bodily_injury,                            ; BI claim
    collision,                                ; Collision
    comprehensive,                            ; Comprehensive
    customer_vehicle,                         ; Customer veh damage
    employee_injury,                          ; Employee claim
    false_pretense,                           ; Fraud claim
    fire,                                     ; Fire loss
    inventory_damage,                         ; Inventory claim
    products_liability,                       ; Products claim
    property_damage,                          ; PD claim
    theft,                                    ; Theft claim
    vandalism,                                ; Vandalism
    other                                     ; Other
)

; Optional fields
amount_claimed = #$:(0..)                     ; Amount claimed
amount_paid = #$:(0..)                        ; Amount paid
claim_id = :                                  ; Claim ID
claim_status = (
    closed,
    denied,
    litigation,
    negotiation,
    open,
    paid,
    reserved,
    subrogation
)
claimant_name = :                             ; Claimant
customer_vehicle_vin = :                      ; Customer VIN
deductible_applied = #$:(0..)                 ; Deductible
description = :                               ; Description
location_reference = :                        ; Location
reserve = #$:(0..)                            ; Reserve
subrogation = #$:(0..)                        ; Subrogation

; ===================================================================================
; Garage Insurance Policy
; ===================================================================================
; Complete garage policy structure.

{@garage_policy}
; Required fields first
effective_date = !date                        ; Policy effective date
expiration_date = !date                       ; Policy expiration date
liability = !@gr_liability                    ; Garage liability
locations[] = !@gr_location                   ; Covered locations
policy_number = !:                            ; Policy number

; Invariants
:invariant expiration_date > effective_date

; Optional fields
additional_coverages = @gr_additional_coverages  ; Extensions
agency = @agency                              ; Issuing agency
claims[] = @gr_claim                          ; Claims history
demo_loaner = @gr_demo_loaner                 ; Demo/loaner
endorsements[] = :                            ; Endorsements
exclusions = @gr_exclusions                   ; Exclusions
false_pretense = @gr_false_pretense           ; False pretense
garagekeepers = @gr_garagekeepers             ; Garagekeepers
id = :                                        ; Internal identifier
named_insured = !:                            ; Named insured
named_insured_address = @address              ; Insured address
open_lot = @gr_open_lot                       ; Open lot
owned_vehicles[] = @tk_vehicle                ; Owned vehicles
physical_damage = @gr_physical_damage         ; Physical damage
policy_form = (
    dealers,                                  ; Dealer form
    garage,                                   ; Standard garage
    service_station,                          ; Service station
    towing                                    ; Towing form
)
policy_status = (
    active,
    cancelled,
    expired,
    pending,
    suspended
)
premium = @gr_premium                         ; Premium details
producer = @producer                          ; Agent
towing = @gr_towing                           ; Towing coverage
underwriting = @underwriting_decision         ; Underwriting

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
garagekeepers_limit = #$:(0..)                ; Garagekeepers limit
liability_limit = :                           ; Liability string
location_count = ##                           ; Location count
open_lot_limit = #$:(0..)                     ; Open lot limit

{@garage_policy}


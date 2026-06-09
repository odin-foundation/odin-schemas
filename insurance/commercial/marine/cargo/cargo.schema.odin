; ===================================================================================
; ODIN Commercial Cargo Insurance Schema
; ===================================================================================
; Commercial cargo insurance covering goods in transit across all modes of
; transportation including motor truck cargo, shipper's interest, warehouse-to-
; warehouse, and multimodal/intermodal cargo coverage.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.marine.cargo"
version = "1.0.0"
title = "Commercial Cargo Insurance Schema"
description = "Comprehensive cargo insurance for goods in transit"

{$derivation}
source[0].authority = "Federal Motor Carrier Safety Administration (FMCSA)"
source[0].citation = "Motor Carrier Cargo Insurance Requirements (49 CFR Part 387)"
source[0].url = "https://www.fmcsa.dot.gov/"

source[1].authority = "Surface Transportation Board (STB)"
source[1].citation = "Carrier Liability and Cargo Insurance Regulations"
source[1].url = "https://www.stb.gov/"

source[2].authority = "National Association of Insurance Commissioners (NAIC)"
source[2].citation = "Inland Marine Insurance Guidelines"
source[2].url = "https://content.naic.org/"

source[3].authority = "Transportation Intermediaries Association"
source[3].citation = "Cargo Insurance Standards and Practices"
source[3].url = "https://www.tianet.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on FMCSA requirements and inland marine insurance standards"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial commercial cargo insurance schema"
changelog[0].rationale = "Commercial cargo coverage for trucking and logistics"

; ===================================================================================
; Policy Type
; ===================================================================================
; Classification of cargo insurance policies.

{@cg_policy_type}
policy_form = (
    annual_open,                              ; Annual open cargo policy
    motor_truck_cargo,                        ; For-hire carrier cargo
    owners_goods,                             ; Owner's goods in transit
    shippers_interest,                        ; Shipper's cargo interest
    single_transit,                           ; Trip-specific policy
    warehouse_to_warehouse                    ; W-W coverage
)

; Insured interest
insured_interest = (
    bailee,                                   ; Bailee interest
    carrier,                                  ; Common/contract carrier
    freight_forwarder,                        ; Forwarder
    owner,                                    ; Cargo owner
    shipper                                   ; Shipper
)

; ===================================================================================
; Cargo Classification
; ===================================================================================
; Commodity classification for cargo.

{@cg_cargo_type}
classification = (
    agricultural,                             ; Farm products
    automotive,                               ; Auto parts, vehicles
    building_materials,                       ; Construction materials
    chemicals,                                ; Chemical products
    consumer_goods,                           ; General consumer
    electronics,                              ; Electronic equipment
    food_beverage,                            ; Food and drink
    furniture,                                ; Furniture/fixtures
    general_merchandise,                      ; General freight
    hazardous,                                ; Hazmat/DG
    heavy_machinery,                          ; Heavy equipment
    high_value,                               ; High-value cargo
    household_goods,                          ; Moving/personal
    industrial,                               ; Industrial products
    livestock,                                ; Live animals
    metals,                                   ; Metal products
    paper,                                    ; Paper products
    perishables,                              ; Perishable goods
    pharmaceuticals,                          ; Medical/pharma
    refrigerated,                             ; Reefer cargo
    textiles,                                 ; Clothing/fabric
    tobacco_alcohol                           ; Controlled substances
)

; Hazmat classification
hazmat_class = (
    class_1,                                  ; Explosives
    class_2,                                  ; Gases
    class_3,                                  ; Flammable liquids
    class_4,                                  ; Flammable solids
    class_5,                                  ; Oxidizers
    class_6,                                  ; Poisons
    class_7,                                  ; Radioactive
    class_8,                                  ; Corrosives
    class_9,                                  ; Misc dangerous
    none                                      ; Not hazardous
)
un_number = :if hazmat_class != none          ; UN hazmat number

; NMFC class
nmfc_class = (
    class_50,
    class_55,
    class_60,
    class_65,
    class_70,
    class_77_5,
    class_85,
    class_92_5,
    class_100,
    class_110,
    class_125,
    class_150,
    class_175,
    class_200,
    class_250,
    class_300,
    class_400,
    class_500
)

; ===================================================================================
; Cargo Details
; ===================================================================================
; Detailed cargo description.

{@cg_cargo}
; Required fields first
cargo_type = @cg_cargo_type                  ; Cargo classification
description = :                              ; Cargo description
value = #$:(0..)                             ; Cargo value

; Optional fields
cargo_id = :                                  ; Internal identifier
commodity_code = :                            ; Commodity code
currency = :(3) "USD"                         ; Value currency
dimensions_inches = :                         ; L x W x H
gross_weight_lbs = ##                         ; Gross weight
hazardous = ?                                 ; Hazmat flag
invoice_number = :                            ; Invoice reference
marks_and_numbers = :                         ; Shipping marks
net_weight_lbs = ##                           ; Net weight
package_count = ##                            ; Number of packages
packaging = (
    bags,
    bales,
    barrels,
    boxes,
    bundles,
    cartons,
    crates,
    drums,
    loose,
    pallets,
    rolls,
    totes
)
perishable = ?                                ; Perishable flag
po_number = :                                 ; Purchase order
seal_numbers[] = :                            ; Seal numbers
special_handling = :                          ; Special requirements
stackable = ?                                 ; Can be stacked
temperature_controlled = ?                    ; Temp sensitive
temperature_max_f = #:if temperature_controlled = true
temperature_min_f = #:if temperature_controlled = true

; ===================================================================================
; Transit Details
; ===================================================================================
; Shipment routing and transit information.

{@cg_transit}
; Required fields first
destination = :                              ; Destination city/state
origin = :                                   ; Origin city/state

; Optional fields
actual_arrival = timestamp                    ; Actual arrival
actual_departure = timestamp                  ; Actual departure
carrier_name = :                              ; Primary carrier
carrier_scac = :(2..4)                        ; SCAC code
consignee = :                                 ; Consignee name
consignee_address = @address                  ; Consignee address
delivery_appointment = timestamp              ; Delivery appointment
destination_address = @address                ; Destination address
estimated_arrival = timestamp                 ; ETA
estimated_departure = timestamp               ; ETD
interline_carriers[] = :                      ; Connecting carriers
mode = (
    air,                                      ; Air freight
    courier,                                  ; Courier/parcel
    intermodal,                               ; Intermodal container
    ltl,                                      ; Less-than-truckload
    multimodal,                               ; Multiple modes
    rail,                                     ; Rail freight
    tl                                        ; Truckload
)
origin_address = @address                     ; Origin address
pickup_appointment = timestamp                ; Pickup appointment
route_miles = ##                              ; Distance
shipper = :                                   ; Shipper name
shipper_address = @address                    ; Shipper address
transit_days = ##                             ; Expected transit time
transit_id = :                                ; Tracking identifier

; ---------------------------------------------------------------------------
; Equipment
; ---------------------------------------------------------------------------
{.equipment}
container_number = :                          ; Container/trailer ID
container_type = (
    container_20,                             ; 20' container
    container_40,                             ; 40' container
    container_40_hc,                          ; 40' high cube
    container_45,                             ; 45' container
    curtainside,                              ; Curtain trailer
    dry_van,                                  ; Standard dry van
    flatbed,                                  ; Flatbed trailer
    lowboy,                                   ; Lowboy trailer
    reefer,                                   ; Refrigerated
    specialized,                              ; Specialized
    step_deck,                                ; Step deck
    tanker                                    ; Tank trailer
)
seal_intact = ?                               ; Seal verification
temperature_setting = #:if container_type = reefer
trailer_number = :                            ; Trailer number
tractor_number = :                            ; Tractor unit

{@cg_transit}

; ===================================================================================
; Coverage Terms
; ===================================================================================
; Cargo coverage provisions.

{@cg_coverage}
; Required fields first
coverage_form = (
    all_risk,                                 ; All risk coverage
    basic,                                    ; Basic named perils
    broad,                                    ; Broad named perils
    special                                   ; Manuscript form
)

; Optional fields
coverage_territory = (
    continental_us,                           ; 48 states
    designated_routes,                        ; Specific routes
    north_america,                            ; US/Canada/Mexico
    us_canada,                                ; US and Canada
    us_only                                   ; US only
)
deductible = #$:(0..)                         ; Policy deductible
deductible_basis = (each_claim, each_loss, each_shipment)
limit_per_conveyance = #$:(0..)               ; Per vehicle limit
limit_per_occurrence = #$:(0..)               ; Per occurrence limit
limit_per_shipment = #$:(0..)                 ; Per shipment limit
valuation = (
    actual_cash_value,                        ; ACV
    agreed_value,                             ; Agreed value
    invoice_value,                            ; Invoice value
    invoice_plus_10,                          ; Invoice + 10%
    replacement_cost                          ; RC
)

; ---------------------------------------------------------------------------
; Covered Perils
; ---------------------------------------------------------------------------
{.perils}
; All-risk usually covers these
collision = ?true                             ; Vehicle collision
contamination = ?                             ; Contamination
derailment = ?true                            ; Rail derailment
fire = ?true                                  ; Fire damage
flood = ?                                     ; Flood damage
lightning = ?true                             ; Lightning
overturning = ?true                           ; Vehicle overturn
pilferage = ?                                 ; Pilferage
refrigeration_breakdown = ?                   ; Reefer failure
stranding = ?true                             ; Vehicle stranding
theft = ?                                     ; Theft coverage
water_damage = ?                              ; Water damage
windstorm = ?true                             ; Windstorm

{@cg_coverage}

; ---------------------------------------------------------------------------
; Loading/Unloading
; ---------------------------------------------------------------------------
{.loading_unloading}
covered = ?                                   ; L/U covered
driver_assist = ?                             ; Driver assists
forklift_damage = ?                           ; Forklift coverage
lumper_services = ?                           ; Lumper covered
mechanical_breakdown = ?                      ; Equipment failure

{@cg_coverage}

; ---------------------------------------------------------------------------
; Covered Locations
; ---------------------------------------------------------------------------
{.locations}
customers_premises = ?                        ; At customer site
in_transit = ?true                            ; While in transit
intermediate_warehouses = ?                   ; Interim storage
loading_dock = ?                              ; At dock
terminal = ?                                  ; At carrier terminal
thirty_days_storage = ?                       ; Storage extension

{@cg_coverage}

; ===================================================================================
; Additional Coverages
; ===================================================================================
; Optional coverage extensions.

{@cg_additional_coverages}
; Expense coverages
debris_removal = ?                            ; Debris removal
debris_limit = #$:(0..):if debris_removal = true
expediting = ?                                ; Expediting expense
expediting_limit = #$:(0..):if expediting = true
forwarding_charges = ?                        ; Forwarding
general_average = ?                           ; GA contribution
preservation = ?                              ; Preservation costs
refrigeration = ?                             ; Extra reefer
salvage = ?                                   ; Salvage charges
sue_and_labor = ?                             ; Sue and labor

; Liability extensions
earned_freight = ?                            ; Freight charges
earned_freight_limit = #$:(0..):if earned_freight = true
liability_assumed = ?                         ; Contractual
motor_carrier_act = ?                         ; MCS-90 coverage
rejected_cargo = ?                            ; Rejection coverage
rejected_limit = #$:(0..):if rejected_cargo = true
trailer_interchange = ?                       ; Trailer exchange

; Special extensions
brand_protection = ?                          ; Brand damage
pair_and_set = ?                              ; Pairs/sets
repackaging = ?                               ; Repackaging
sorting = ?                                   ; Sorting/segregating

; ===================================================================================
; Exclusions
; ===================================================================================
; Standard cargo exclusions.

{@cg_exclusions}
; Standard exclusions
acts_of_shipper = ?true                       ; Shipper's acts
concealed_shortage = ?                        ; Concealed shortage
delay = ?true                                 ; Delay loss
electrical_breakdown = ?                      ; Electrical failure
illegal_cargo = ?true                         ; Illegal goods
improper_packing = ?true                      ; Inadequate packing
inherent_vice = ?true                         ; Inherent vice
intentional = ?true                           ; Intentional acts
loss_of_market = ?true                        ; Market loss
mechanical_breakdown = ?                      ; Mechanical failure
mold = ?                                      ; Mold damage
nuclear = ?true                               ; Nuclear
ordinary_leakage = ?true                      ; Normal leakage
temperature_controlled = ?                    ; Temp variation
war = ?true                                   ; War/terrorism
wear_and_tear = ?true                         ; Normal wear
wilful_misconduct = ?true                     ; Misconduct

; Commodity exclusions
accounts_bills = ?                            ; Accounts/money
antiques = ?                                  ; Antiques
furs = ?                                      ; Furs
jewelry = ?                                   ; Jewelry
money_securities = ?true                      ; Cash/securities
precious_metals = ?                           ; Precious metals

; ===================================================================================
; Shipment Declaration
; ===================================================================================
; Individual shipment under open policy.

{@cg_shipment}
; Required fields first
cargo = @cg_cargo                            ; Cargo details
declared_value = #$:(0..)                    ; Declared value
transit = @cg_transit                        ; Transit info

; Optional fields
bill_of_lading = :                            ; B/L number
broker_reference = :                          ; Broker ref
declaration_date = date                       ; Declaration date
load_tender = :                               ; Load tender number
policy_reference = :                          ; Policy number
premium = #$:(0..)                            ; Shipment premium
pro_number = :                                ; PRO number
shipment_id = :                               ; Shipment ID
status = (
    cancelled,
    claimed,
    delivered,
    in_transit,
    pending,
    picked_up
)

; ===================================================================================
; Premium Details
; ===================================================================================
; Cargo premium structure.

{@cg_premium}
; Required fields first
total_premium = #$:(0..)                     ; Total premium

; Optional fields
additional_premium = #$:(0..)                 ; Extensions
base_premium = #$:(0..)                       ; Base premium
currency = :(3) "USD"                         ; Premium currency
deposit_premium = #$:(0..)                    ; Deposit if annual
minimum_premium = #$:(0..)                    ; Minimum premium
policy_fee = #$:(0..)                         ; Policy fee
rate_per_hundred = #                          ; Rate per $100
taxes_and_fees = #$:(0..)                     ; Taxes/fees

; ---------------------------------------------------------------------------
; Rating Factors
; ---------------------------------------------------------------------------
{.rating_factors}
cargo_class = :                               ; Commodity factor
claims_experience = #                         ; Experience mod
deductible_credit = #                         ; Deductible credit
geographic = #                                ; Route factor
mode_factor = #                               ; Transport mode
security_credit = #                           ; Security discount
volume_discount = #                           ; Volume credit

{@cg_premium}

; ===================================================================================
; Cargo Claim
; ===================================================================================
; Claim structure for cargo losses.

{@cg_claim}
; Required fields first
claim_date = date                            ; Date claim filed
claim_type = (
    concealed_damage,                         ; Hidden damage
    contamination,                            ; Contamination
    damage,                                   ; Physical damage
    delay,                                    ; Delay claim
    loss,                                     ; Total loss
    pilferage,                                ; Pilferage
    refrigeration,                            ; Reefer failure
    rejection,                                ; Rejected cargo
    shortage,                                 ; Shortage
    temperature,                              ; Temperature
    theft,                                    ; Theft
    water,                                    ; Water damage
    other                                     ; Other
)

; Optional fields
adjuster = :                                  ; Claims adjuster
amount_claimed = #$:(0..)                     ; Amount claimed
amount_paid = #$:(0..)                        ; Amount settled
carrier_liability = #$:(0..)                  ; Carrier's share
cause_of_loss = :                             ; Loss description
claim_id = :                                  ; Claim identifier
claim_status = (
    closed,
    denied,
    negotiation,
    open,
    paid,
    reserved,
    subrogation
)
date_of_loss = date                           ; When loss occurred
deductible_applied = #$:(0..)                 ; Deductible
delivery_date = date                          ; Delivery date
discovery_date = date                         ; When discovered
documents[] = :                               ; Supporting docs
exception_noted = ?                           ; Exception on POD
inspection_date = date                        ; Inspection date
location_of_loss = :                          ; Where loss occurred
os_and_d_report = :                           ; OS&D reference
photos[] = :                                  ; Photo references
pro_number = :                                ; PRO number
recovery = #$:(0..)                           ; Carrier recovery
reserve = #$:(0..)                            ; Reserve amount
salvage = #$:(0..)                            ; Salvage value
shipment_reference = :                        ; Shipment ID
subrogation = #$:(0..)                        ; Subrogation amount
survey_report = :                             ; Survey reference

; ===================================================================================
; Insured Carrier/Shipper
; ===================================================================================
; Named insured details.

{@cg_insured}
; Required fields first
insured_name = :                             ; Named insured

; Optional fields
address = @address                            ; Business address
dba_names[] = :                               ; DBA names
duns_number = :                               ; D&B number
email = *@email                               ; Contact email
fein = *:                                     ; Tax ID
insured_type = @cg_policy_type                ; Policy/insured type
mc_number = :                                 ; Motor carrier number
phone = *@phone                               ; Contact phone
scac_code = :(2..4)                           ; SCAC code
usdot_number = :                              ; USDOT number
years_in_business = ##                        ; Years operating

; ===================================================================================
; Cargo Insurance Policy
; ===================================================================================
; Complete cargo policy structure.

{@cargo_policy}
; Required fields first
coverage = @cg_coverage                      ; Coverage terms
effective_date = date                        ; Policy effective date
expiration_date = date                       ; Policy expiration date
insured = @cg_insured                        ; Named insured
policy_number = :                            ; Policy number
policy_type = @cg_policy_type                ; Policy type

; Invariants
:invariant expiration_date > effective_date

; Optional fields
additional_coverages = @cg_additional_coverages  ; Extensions
agency = @agency                              ; Issuing agency
annual_cargo_value = #$:(0..)                 ; Estimated annual
broker = :                                    ; Broker
claims[] = @cg_claim                          ; Claims history
commodities_covered[] = :                     ; Covered commodities
commodities_excluded[] = :                    ; Excluded commodities
exclusions = @cg_exclusions                   ; Exclusions
filings[] = :                                 ; Required filings
id = :                                        ; Internal identifier
loss_payee = :                                ; Loss payee
policy_status = (
    active,
    cancelled,
    expired,
    pending,
    suspended
)
premium = @cg_premium                         ; Premium details
producer = @producer                          ; Agent
routes_covered[] = :                          ; Covered routes
routes_excluded[] = :                         ; Excluded routes
shipments[] = @cg_shipment                    ; Shipment declarations
special_conditions[] = :                      ; Special terms
subjectivities[] = :                          ; Outstanding items
underwriting = @underwriting_decision         ; Underwriting

; ---------------------------------------------------------------------------
; BMC-32 / MCS-90 Endorsement
; ---------------------------------------------------------------------------
{.regulatory}
bmc_32_filed = ?                              ; BMC-32 required
bmc_34_filed = ?                              ; BMC-34 required
bmc_91_filed = ?                              ; BMC-91 required
effective_filing_date = date                  ; Filing effective
filing_state = :(2)                           ; State of filing
mcs_90_attached = ?                           ; MCS-90 attached

{@cargo_policy}

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
cargo_limit = #$:(0..)                        ; Per shipment limit
commodity_class = :                           ; Primary commodity
deductible = #$:(0..)                         ; Deductible
estimated_shipments = ##                      ; Annual shipments

{@cargo_policy}


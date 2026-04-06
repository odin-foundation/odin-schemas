; ===================================================================================
; ODIN Motor Truck Cargo Insurance Schema
; ===================================================================================
; FMCSA-compliant motor truck cargo insurance for for-hire motor carriers per
; 49 CFR Part 387 including BMC-32 filings, all-risk cargo coverage, refrigeration
; breakdown, theft, and loading/unloading protection.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.transportation.motor-truck-cargo"
version = "1.0.0"
title = "Motor Truck Cargo Insurance Schema"
description = "FMCSA-compliant cargo insurance for motor carriers"

{$derivation}
source[0].authority = "Federal Motor Carrier Safety Administration (FMCSA)"
source[0].citation = "49 CFR Part 387 - Minimum Levels of Financial Responsibility"
source[0].url = "https://www.ecfr.gov/current/title-49/subtitle-B/chapter-III/subchapter-B/part-387"

source[1].authority = "U.S. Department of Transportation"
source[1].citation = "Motor Carrier Insurance Requirements"
source[1].url = "https://www.transportation.gov/"

source[2].authority = "American Moving and Storage Association"
source[2].citation = "Household Goods Cargo Insurance Standards"
source[2].url = "https://www.moving.org/"

source[3].authority = "Transportation Intermediaries Association"
source[3].citation = "Freight Broker Cargo Coverage Guidelines"
source[3].url = "https://www.tianet.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on FMCSA 49 CFR Part 387 cargo insurance requirements"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial motor truck cargo insurance schema"
changelog[0].rationale = "FMCSA-compliant cargo coverage for motor carriers"

; ===================================================================================
; Carrier Authority Type
; ===================================================================================
; Motor carrier operating authority classification.

{@mtc_authority_type}
authority = !(
    broker,                                   ; Freight broker
    common_carrier,                           ; Common carrier
    contract_carrier,                         ; Contract carrier
    exempt,                                   ; Exempt carrier
    freight_forwarder,                        ; Freight forwarder
    household_goods                           ; Household goods mover
)

; Operating scope
interstate = ?                                ; Interstate authority
intrastate[] = :(2)                           ; Intrastate states

; Commodity authority
general_freight = ?                           ; General commodities
hazardous_materials = ?                       ; Hazmat authorized
household_goods = ?                           ; HHG authority
refrigerated = ?                              ; Reefer authority

; ===================================================================================
; Motor Carrier
; ===================================================================================
; Insured motor carrier details.

{@mtc_carrier}
; Required fields first
carrier_name = !:                             ; Legal name
mc_number = !:                                ; MC number
usdot_number = !:                             ; USDOT number

; Optional fields
address = @address                            ; Business address
authority = @mtc_authority_type               ; Authority type
carrier_id = :                                ; Internal identifier
dba_names[] = :                               ; DBA names
email = *@email                               ; Contact email
fein = *:                                     ; Tax ID
fleet_size = ##                               ; Power unit count
icc_number = :                                ; ICC number (legacy)
phone = *@phone                               ; Contact phone
safety_rating = (
    conditional,
    not_rated,
    satisfactory,
    unsatisfactory
)
scac_code = :(2..4)                           ; SCAC code
years_in_business = ##                        ; Years operating

; ===================================================================================
; Commodity Classification
; ===================================================================================
; Cargo commodity types covered.

{@mtc_commodity}
commodity_class = !(
    agricultural,                             ; Farm products
    automobiles,                              ; Vehicles
    building_materials,                       ; Construction
    chemicals,                                ; Chemicals
    consumer_electronics,                     ; Electronics
    food_beverage,                            ; Food/beverage
    furniture,                                ; Furniture
    general_freight,                          ; General freight
    hazardous_materials,                      ; Hazmat
    heavy_machinery,                          ; Heavy equipment
    high_value,                               ; High-value cargo
    household_goods,                          ; HHG moving
    industrial,                               ; Industrial
    livestock,                                ; Live animals
    mail_packages,                            ; Mail/parcel
    metals,                                   ; Metal products
    paper_products,                           ; Paper
    perishables,                              ; Perishable food
    pharmaceuticals,                          ; Pharma/medical
    refrigerated,                             ; Reefer cargo
    retail,                                   ; Retail goods
    textiles                                  ; Textiles/apparel
)

; Special handling
hazmat_un_number = ::if commodity_class = hazardous_materials
temperature_controlled = ?:if commodity_class = (perishables, refrigerated, pharmaceuticals)

; ===================================================================================
; Coverage Terms
; ===================================================================================
; Motor truck cargo coverage provisions.

{@mtc_coverage}
; Required fields first
coverage_form = !(
    all_risk,                                 ; All-risk coverage
    broad_form,                               ; Broad named perils
    named_perils,                             ; Basic named perils
    special                                   ; Manuscript form
)
limit_per_occurrence = !#$:(0..)              ; Per occurrence limit
limit_per_vehicle = !#$:(0..)                 ; Per vehicle limit

; Optional fields
aggregate_limit = #$:(0..)                    ; Annual aggregate
deductible = #$:(0..)                         ; Policy deductible
deductible_basis = (each_claim, each_occurrence, each_shipment)

; FMCSA minimums
fmcsa_commodity = (
    general_freight,                          ; No federal minimum
    hazmat_bulk,                              ; Hazmat bulk cargo
    hazmat_non_bulk,                          ; Hazmat non-bulk
    household_goods,                          ; HHG minimums
    oil_hazmat                                ; Oil/hazardous
)

; Valuation
valuation = (
    actual_cash_value,                        ; ACV
    agreed_value,                             ; Agreed value
    invoice,                                  ; Invoice value
    invoice_plus_10,                          ; Invoice + 10%
    released_value,                           ; Released value
    replacement_cost                          ; Replacement
)

; Territory
territory = (
    continental_us,                           ; 48 states
    north_america,                            ; US/Canada/Mexico
    us_canada,                                ; US and Canada
    us_only                                   ; US only
)

; ---------------------------------------------------------------------------
; Covered Perils
; ---------------------------------------------------------------------------
{.perils}
; Standard covered perils
collision = ?true                             ; Vehicle collision
derailment = ?true                            ; Rail derailment
fire = ?true                                  ; Fire
flood = ?                                     ; Flood
lightning = ?true                             ; Lightning strike
overturning = ?true                           ; Vehicle overturn
pilferage = ?                                 ; Pilferage
refrigeration_breakdown = ?                   ; Reefer failure
stranding = ?true                             ; Stranding
theft = ?                                     ; Theft
water_damage = ?                              ; Water damage
windstorm = ?true                             ; Windstorm

{@mtc_coverage}

; ---------------------------------------------------------------------------
; Loading/Unloading
; ---------------------------------------------------------------------------
{.loading_unloading}
covered = ?                                   ; L/U covered
driver_assist = ?                             ; Driver loading
forklift = ?                                  ; Forklift damage
lumper = ?                                    ; Lumper service

{@mtc_coverage}

; ---------------------------------------------------------------------------
; Extensions
; ---------------------------------------------------------------------------
{.extensions}
debris_removal = ?                            ; Debris removal
debris_limit = #$:(0..):if extensions.debris_removal = true
expediting = ?                                ; Expediting expense
expediting_limit = #$:(0..):if extensions.expediting = true
general_average = ?                           ; GA contribution
preservation = ?                              ; Preservation costs
repackaging = ?                               ; Repackaging
sue_and_labor = ?                             ; Sue and labor

{@mtc_coverage}

; ===================================================================================
; Commodity Limits
; ===================================================================================
; Per-commodity sublimits.

{@mtc_commodity_limit}
; Required fields first
commodity = !@mtc_commodity                   ; Commodity type
limit = !#$:(0..)                             ; Commodity limit

; Optional fields
deductible = #$:(0..)                         ; Commodity deductible
excluded = ?                                  ; Commodity excluded

; ===================================================================================
; Exclusions
; ===================================================================================
; Standard motor truck cargo exclusions.

{@mtc_exclusions}
; Standard cargo exclusions
acts_of_shipper = ?true                       ; Shipper's acts
concealed_damage = ?                          ; Concealed damage
delay = ?true                                 ; Delay loss
electrical_breakdown = ?                      ; Electrical failure
illegal_cargo = ?true                         ; Illegal goods
improper_packing = ?true                      ; Improper packing
inherent_vice = ?true                         ; Inherent vice
intentional = ?true                           ; Intentional acts
loss_of_market = ?true                        ; Market loss
mechanical_breakdown = ?                      ; Mechanical failure
mold = ?                                      ; Mold damage
nuclear = ?true                               ; Nuclear
ordinary_leakage = ?true                      ; Normal leakage
temperature = ?                               ; Temp variation
war = ?true                                   ; War/terrorism
wear_and_tear = ?true                         ; Normal wear
willful_misconduct = ?true                    ; Misconduct

; Commodity exclusions
accounts_bills = ?true                        ; Accounts/bills
antiques = ?                                  ; Antiques
cash_currency = ?true                         ; Cash
furs = ?                                      ; Furs
jewelry = ?                                   ; Jewelry
live_animals = ?                              ; Livestock
precious_metals = ?                           ; Precious metals
securities = ?true                            ; Securities

; ===================================================================================
; BMC-32 Filing
; ===================================================================================
; FMCSA cargo insurance filing.

{@mtc_bmc_32}
; Required for for-hire carriers
required = !?                                 ; BMC-32 required

; Filing details
effective_date = date:if required = true      ; Filing effective
expiration_date = date:if required = true     ; Filing expiration
filed = ?:if required = true                  ; Currently filed
filing_limit = #$:(0..):if required = true    ; Filed limit
filing_number = ::if required = true          ; Filing reference
filing_status = (
    active,                                   ; Active filing
    cancelled,                                ; Cancelled
    expired,                                  ; Expired
    pending                                   ; Pending
):if required = true
policy_number = ::if required = true          ; Policy reference
surety_company = ::if required = true         ; Surety company

; BMC-34 alternative
bmc_34_bond = ?                               ; Surety bond instead
bond_amount = #$:(0..):if bmc_34_bond = true  ; Bond amount
bond_number = ::if bmc_34_bond = true         ; Bond number

; ===================================================================================
; Trailer Interchange
; ===================================================================================
; Trailer interchange cargo extension.

{@mtc_trailer_interchange}
included = ?                                  ; TI cargo covered
limit = #$:(0..):if included = true           ; TI cargo limit
deductible = #$:(0..):if included = true      ; TI deductible

; Covered trailer types
dry_van = ?:if included = true                ; Dry van trailers
flatbed = ?:if included = true                ; Flatbed trailers
reefer = ?:if included = true                 ; Reefer trailers
specialized = ?:if included = true            ; Specialized

; ===================================================================================
; Household Goods Provisions
; ===================================================================================
; HHG-specific coverage provisions.

{@mtc_household_goods}
; HHG carrier provisions
hhg_authority = !?                            ; HHG authority

; Coverage provisions
declared_value = ?:if hhg_authority = true    ; Declared value
full_replacement = ?:if hhg_authority = true  ; Full value protection
released_value = ?:if hhg_authority = true    ; Released value option

; HHG limits
full_value_limit = #$:(0..):if full_replacement = true
released_rate = #:if released_value = true    ; Cents per pound

; Storage coverage
storage_in_transit = ?:if hhg_authority = true
storage_limit = #$:(0..):if storage_in_transit = true
storage_days = ##:if storage_in_transit = true

; ===================================================================================
; Premium Details
; ===================================================================================
; Premium structure.

{@mtc_premium}
; Required fields first
total_premium = !#$:(0..)                     ; Total premium

; Optional fields
base_premium = #$:(0..)                       ; Base premium
deposit_premium = #$:(0..)                    ; Deposit premium
extensions_premium = #$:(0..)                 ; Extensions
minimum_premium = #$:(0..)                    ; Minimum premium
policy_fee = #$:(0..)                         ; Policy fee
rate_per_hundred = #                          ; Rate per $100
taxes_and_fees = #$:(0..)                     ; Taxes/fees
ti_premium = #$:(0..)                         ; Trailer interchange

; ---------------------------------------------------------------------------
; Rating Factors
; ---------------------------------------------------------------------------
{.rating}
claims_experience = #                         ; Experience factor
commodity_factor = #                          ; Commodity class
deductible_credit = #                         ; Deductible credit
fleet_size_factor = #                         ; Fleet size
security_credit = #                           ; Security discount
territory_factor = #                          ; Territory

{@mtc_premium}

; ===================================================================================
; Claims
; ===================================================================================
; Cargo claim structure.

{@mtc_claim}
; Required fields first
claim_date = !date                            ; Claim date
claim_type = !(
    concealed_damage,                         ; Hidden damage
    contamination,                            ; Contamination
    damage,                                   ; Physical damage
    delay,                                    ; Delay claim
    loss,                                     ; Total loss
    pilferage,                                ; Pilferage
    refrigeration,                            ; Reefer failure
    shortage,                                 ; Shortage
    temperature,                              ; Temp damage
    theft,                                    ; Theft
    water,                                    ; Water damage
    other                                     ; Other
)

; Optional fields
amount_claimed = #$:(0..)                     ; Amount claimed
amount_paid = #$:(0..)                        ; Amount paid
bill_of_lading = :                            ; B/L number
carrier_liability = #$:(0..)                  ; Carrier share
claim_id = :                                  ; Claim ID
claim_status = (
    closed,
    denied,
    negotiation,
    open,
    paid,
    reserved,
    subrogation
)
claimant = :                                  ; Claimant name
commodity = :                                 ; Cargo type
date_of_loss = date                           ; Loss date
deductible_applied = #$:(0..)                 ; Deductible
description = :                               ; Description
destination = :                               ; Destination
origin = :                                    ; Origin
pro_number = :                                ; PRO number
recovery = #$:(0..)                           ; Recovery
reserve = #$:(0..)                            ; Reserve
salvage = #$:(0..)                            ; Salvage
subrogation = #$:(0..)                        ; Subrogation

; ===================================================================================
; Motor Truck Cargo Policy
; ===================================================================================
; Complete MTC policy structure.

{@mtc_policy}
; Required fields first
bmc_32 = !@mtc_bmc_32                         ; BMC-32 filing
carrier = !@mtc_carrier                       ; Insured carrier
coverage = !@mtc_coverage                     ; Coverage terms
effective_date = !date                        ; Policy effective date
expiration_date = !date                       ; Policy expiration date
policy_number = !:                            ; Policy number

; Invariants
:invariant expiration_date > effective_date

; Optional fields
agency = @agency                              ; Issuing agency
claims[] = @mtc_claim                         ; Claims history
commodity_limits[] = @mtc_commodity_limit     ; Per-commodity limits
commodities_covered[] = @mtc_commodity        ; Covered commodities
commodities_excluded[] = @mtc_commodity       ; Excluded commodities
endorsements[] = :                            ; Endorsements
estimated_annual_cargo = #$:(0..)             ; Annual cargo value
exclusions = @mtc_exclusions                  ; Exclusions
household_goods = @mtc_household_goods        ; HHG provisions
id = :                                        ; Internal identifier
policy_form = (
    annual_open,                              ; Annual open policy
    motor_truck_cargo,                        ; Standard MTC
    specific_shipment                         ; Per-shipment
)
policy_status = (
    active,
    cancelled,
    expired,
    pending,
    suspended
)
premium = @mtc_premium                        ; Premium details
producer = @producer                          ; Agent
routes_covered[] = :                          ; Covered routes
routes_excluded[] = :                         ; Excluded routes
special_conditions[] = :                      ; Special terms
trailer_interchange = @mtc_trailer_interchange; TI cargo
underwriting = @underwriting_decision         ; Underwriting

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
cargo_limit = #$:(0..)                        ; Per occurrence limit
deductible = #$:(0..)                         ; Deductible
primary_commodities[] = :                     ; Primary cargo types
vehicle_limit = #$:(0..)                      ; Per vehicle limit

{@mtc_policy}


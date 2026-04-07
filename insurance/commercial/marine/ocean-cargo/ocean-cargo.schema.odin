; ===================================================================================
; ODIN Ocean Cargo Insurance Schema
; ===================================================================================
; Ocean marine cargo insurance covering goods transported by sea including all-risk
; and named perils coverage per Institute Cargo Clauses, war risk, strikes/riots,
; general average, and warehouse-to-warehouse transit.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.marine.ocean-cargo"
version = "1.0.0"
title = "Ocean Cargo Insurance Schema"
description = "Marine cargo insurance for goods transported by sea"

{$derivation}
source[0].authority = "Lloyd's Market Association"
source[0].citation = "Institute Cargo Clauses (A, B, C)"
source[0].url = "https://web.archive.org/web/2023/https://www.lmalloyds.com/LMA/Underwriting/Marine/JCC/JCC.aspx"

source[1].authority = "International Maritime Organization (IMO)"
source[1].citation = "International Maritime Conventions"
source[1].url = "https://www.imo.org/"

source[2].authority = "American Institute of Marine Underwriters (AIMU)"
source[2].citation = "Marine Insurance Forms and Clauses"
source[2].url = "https://www.aimu.org/"

source[3].authority = "United Nations Conference on Trade and Development"
source[3].citation = "UNCTAD Model Clauses on Marine Cargo Insurance"
source[3].url = "https://unctad.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on Institute Cargo Clauses and AIMU standard forms"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial ocean cargo insurance schema"
changelog[0].rationale = "Commercial marine cargo coverage for international trade"

; ===================================================================================
; Cargo Classification
; ===================================================================================
; Classification of cargo types and commodities.

{@oc_cargo_class}
classification = !(
    automobiles,                              ; Vehicles and automotive
    break_bulk,                               ; Non-containerized general
    bulk_dry,                                 ; Dry bulk commodities
    bulk_liquid,                              ; Liquid bulk/tanker
    chemicals,                                ; Chemical products
    containerized,                            ; Container cargo
    electronics,                              ; Electronic goods
    fine_arts,                                ; Art and antiques
    frozen_goods,                             ; Frozen products
    garments,                                 ; Clothing and textiles
    general_merchandise,                      ; General cargo
    hazardous,                                ; Dangerous goods
    heavy_lift,                               ; Project/heavy cargo
    household_goods,                          ; Personal effects
    livestock,                                ; Live animals
    machinery,                                ; Industrial machinery
    perishables,                              ; Perishable goods
    pharmaceuticals,                          ; Medical products
    precious_metals,                          ; Bullion/precious metals
    project_cargo,                            ; Oversize/project
    refrigerated,                             ; Reefer cargo
    ro_ro                                     ; Roll-on/roll-off cargo
)

; IMO hazardous classification
imo_class = (
    class_1_explosives,
    class_2_gases,
    class_3_flammable_liquids,
    class_4_flammable_solids,
    class_5_oxidizers,
    class_6_toxic,
    class_7_radioactive,
    class_8_corrosive,
    class_9_misc_dangerous
):if classification = hazardous

un_number = ::if classification = hazardous   ; UN dangerous goods number

; ===================================================================================
; Cargo Details
; ===================================================================================
; Detailed cargo description and specifications.

{@oc_cargo}
; Required fields first
cargo_class = !@oc_cargo_class                ; Cargo classification
description = !:                              ; Cargo description
value = !#$:(0..)                             ; Cargo value

; Optional fields
cargo_id = :                                  ; Internal identifier
commodity_code = :                            ; HS code or commodity code
container_numbers[] = :                       ; Container IDs
country_of_origin = :(2..3)                   ; ISO country code
currency = :(3) "USD"                         ; Value currency
dangerous_goods = ?                           ; Is dangerous cargo
gross_weight_kg = #                           ; Gross weight
invoice_number = :                            ; Commercial invoice
marks_and_numbers = :                         ; Shipping marks
nature_of_goods = :                           ; Nature description
net_weight_kg = #                             ; Net weight
package_count = ##                            ; Package count
packing_type = (
    bags,
    bales,
    barrels,
    boxes,
    bulk,
    cartons,
    cases,
    crates,
    drums,
    pallets,
    rolls,
    tanks
)
perishable = ?                                ; Is perishable
purchase_order = :                            ; PO reference
seal_numbers[] = :                            ; Container seals
special_handling = :                          ; Special requirements
temperature_controlled = ?                    ; Requires temp control
temperature_max_c = #:if temperature_controlled = true
temperature_min_c = #:if temperature_controlled = true
volume_cbm = #                                ; Volume in cubic meters

; ===================================================================================
; Voyage Details
; ===================================================================================
; Shipping route and voyage information.

{@oc_voyage}
; Required fields first
destination_port = !:                         ; Destination port
origin_port = !:                              ; Origin port

; Optional fields
destination_country = :(2..3)                 ; Destination country code
estimated_arrival = date                      ; ETA
estimated_departure = date                    ; ETD
feeder_vessels[] = :                          ; Feeder vessel names
final_destination = :                         ; Final inland destination
inland_destination = :                        ; Inland delivery point
inland_origin = :                             ; Inland pickup point
main_vessel = :                               ; Main carrying vessel
origin_country = :(2..3)                      ; Origin country code
sailing_date = date                           ; Actual departure
transshipment_ports[] = :                     ; Transshipment points
voyage_id = :                                 ; Voyage reference
voyage_number = :                             ; Vessel voyage number

; ---------------------------------------------------------------------------
; Transit Details
; ---------------------------------------------------------------------------
{.transit}
conveyance = (air, multimodal, rail, road, sea)
estimated_days = ##                           ; Estimated transit days
feeder_vessel = ?                             ; Uses feeder service
transit_type = (
    combined_transport,                       ; Multimodal
    door_to_door,                             ; Complete logistics
    port_to_door,                             ; Port to inland
    port_to_port,                             ; Port to port only
    warehouse_to_warehouse                    ; Full coverage
)

{@oc_voyage}

; ===================================================================================
; Vessel Information
; ===================================================================================
; Carrying vessel details.

{@oc_vessel}
vessel_name = !:                              ; Vessel name
imo_number = :                                ; IMO vessel number
flag_state = :(2..3)                          ; Flag country
vessel_type = (
    bulk_carrier,
    container_ship,
    general_cargo,
    reefer_vessel,
    ro_ro,
    tanker
)
year_built = ##:(1950..2100)                  ; Year constructed
gross_tonnage = ##                            ; Gross tonnage
classification_society = :                    ; Class society
classification_status = (
    in_class,
    not_classed,
    suspended,
    withdrawn
)

; Age/condition restrictions
age_years = ##                                ; Current age
over_age_vessel = ?                           ; Exceeds age warranty

; ===================================================================================
; Coverage Terms
; ===================================================================================
; Standard coverage clauses and terms.

{@oc_coverage_terms}
; Required fields first
clause_type = !(
    fpa,                                      ; Free from particular average
    icc_a,                                    ; Institute Cargo Clauses (A) - All Risk
    icc_b,                                    ; Institute Cargo Clauses (B) - Named Perils
    icc_c,                                    ; Institute Cargo Clauses (C) - Basic
    icc_air,                                  ; Institute Cargo Clauses (Air)
    open_cover,                               ; Open cargo policy terms
    special                                   ; Special/manuscript terms
)

; Optional fields
containerized = ?                             ; Container cargo clause
deductible = #$:(0..)                         ; Policy deductible
deductible_basis = (each_loss, each_occurrence, each_shipment)
duration_clause = (
    institute_cargo,                          ; Standard transit
    marine_extension,                         ; Extended coverage
    warehouse_to_warehouse                    ; Full W-W coverage
)
excess = #$:(0..)                             ; Excess if applicable
franchise = #$:(0..)                          ; Franchise amount
limit_per_conveyance = #$:(0..)               ; Per vessel/vehicle limit
limit_per_location = #$:(0..)                 ; Per location limit
limit_per_occurrence = #$:(0..)               ; Per occurrence limit
limit_per_shipment = #$:(0..)                 ; Per shipment limit
manuscript_terms = :                          ; Special terms if any
on_deck = ?                                   ; On-deck cargo covered
refrigerated = ?                              ; Reefer clause
second_hand_machinery = ?                     ; Used equipment clause

; ---------------------------------------------------------------------------
; Valuation
; ---------------------------------------------------------------------------
{.valuation}
basis = (
    agreed_value,                             ; Pre-agreed value
    cif,                                      ; CIF value
    cif_plus_10,                              ; CIF + 10% (standard)
    cif_plus_20,                              ; CIF + 20%
    invoice_value,                            ; Invoice value
    market_value,                             ; Current market
    replacement_cost                          ; Replacement cost
)
duty_included = ?                             ; Includes duty
freight_included = ?                          ; Includes freight
profit_margin = #:(0..50)                     ; Profit percentage

{@oc_coverage_terms}

; ===================================================================================
; War and Strikes Coverage
; ===================================================================================
; War risk and SRCC coverage extensions.

{@oc_war_strikes}
; War risk
war_risk = ?                                  ; War risk coverage
war_clause = (
    institute_war_cargo,                      ; Standard war clause
    american_war,                             ; American conditions
    special                                   ; Special terms
):if war_risk = true
war_limit = #$:(0..):if war_risk = true       ; War risk limit
war_premium = #$:(0..):if war_risk = true     ; War premium

; Strikes coverage
strikes_coverage = ?                          ; SRCC coverage
strikes_clause = (
    institute_strikes,                        ; Standard strikes
    special                                   ; Special terms
):if strikes_coverage = true
strikes_limit = #$:(0..):if strikes_coverage = true
strikes_premium = #$:(0..):if strikes_coverage = true

; Excluded areas
excluded_countries[] = :(2..3)                ; Excluded territories
war_rated_areas[] = :                         ; Areas with war premium

; ===================================================================================
; Additional Coverages
; ===================================================================================
; Optional coverage extensions.

{@oc_additional_coverages}
; General average
general_average = ?true                       ; GA contribution covered
jason_clause = ?                              ; Jason clause included
new_jason_clause = ?                          ; New Jason clause

; Sue and labor
sue_and_labor = ?true                         ; Sue and labor covered
sue_labor_limit = #$:(0..)                    ; Sue and labor limit

; Other coverages
air_freight = ?                               ; Air freight in emergency
contamination = ?                             ; Contamination coverage
debris_removal = ?                            ; Debris removal
delay = ?                                     ; Delay coverage
forwarding_charges = ?                        ; Forwarding expenses
fumigation = ?                                ; Fumigation coverage
insolvency = ?                                ; Carrier insolvency
inspection = ?                                ; Survey costs
labels = ?                                    ; Label damage only
mold = ?                                      ; Mold coverage
pairs_and_sets = ?                            ; Pairs/sets clause
quarantine = ?                                ; Quarantine expenses
reconditioning = ?                            ; Reconditioning costs
rejection = ?                                 ; Rejection coverage
shortage = ?                                  ; Shortage coverage
sorting = ?                                   ; Sorting and segregating
sweat_damage = ?                              ; Sweat/condensation
temperature_variation = ?                     ; Temperature damage

; ---------------------------------------------------------------------------
; Extensions for Specific Cargo
; ---------------------------------------------------------------------------
{.extensions}
brand_damage = ?                              ; Brand/name damage
electrical_derangement = ?                    ; Electrical damage
inherent_vice = ?                             ; Inherent vice buy-back
leakage = ?                                   ; Leakage coverage
pilferage = ?                                 ; Pilferage extension
rust = ?                                      ; Rust and oxidation
theft = ?                                     ; Theft coverage
transit_exposure = ?                          ; Extended transit

{@oc_additional_coverages}

; ===================================================================================
; Exclusions
; ===================================================================================
; Standard and optional exclusions.

{@oc_exclusions}
; Standard exclusions (typically non-modifiable)
delay = ?true                                 ; Delay loss excluded
inherent_vice = ?true                         ; Inherent vice
insufficiency_packing = ?true                 ; Inadequate packing
insolvency = ?                                ; Carrier insolvency
loss_of_market = ?true                        ; Market loss
ordinary_leakage = ?true                      ; Normal leakage
ordinary_loss = ?true                         ; Ordinary loss
willful_misconduct = ?true                    ; Insured's misconduct

; War and related exclusions
biological_chemical = ?true                   ; Bio/chem weapons
cyber = ?                                     ; Cyber exclusion
nuclear = ?true                               ; Nuclear exclusion
sanctions = ?true                             ; Sanctions exclusion
terrorism = ?                                 ; Terrorism exclusion
war = ?true                                   ; War exclusion

; Cargo-specific exclusions
electrical_mechanical = ?                     ; Mechanical breakdown
temperature = ?                               ; Temperature variation
vermin = ?                                    ; Vermin damage

; ===================================================================================
; Shipment Declaration
; ===================================================================================
; Individual shipment under open policy.

{@oc_shipment}
; Required fields first
cargo = !@oc_cargo                            ; Cargo details
declared_value = !#$:(0..)                    ; Declared value
voyage = !@oc_voyage                          ; Voyage details

; Optional fields
bill_of_lading = :                            ; B/L number
broker_reference = :                          ; Broker ref
certificate_number = :                        ; Certificate number
coverage_terms = @oc_coverage_terms           ; Coverage terms
declaration_date = date                       ; Declaration date
letter_of_credit = :                          ; L/C reference
policy_reference = :                          ; Policy number
premium = #$:(0..)                            ; Shipment premium
shipment_id = :                               ; Shipment identifier
status = (
    cancelled,
    claimed,
    closed,
    declared,
    in_transit,
    pending
)
vessel = @oc_vessel                           ; Carrying vessel

; ===================================================================================
; Premium Details
; ===================================================================================
; Premium calculation for ocean cargo.

{@oc_premium}
; Required fields first
total_premium = !#$:(0..)                     ; Total premium

; Optional fields
additional_coverage_premium = #$:(0..)        ; Extensions premium
base_premium = #$:(0..)                       ; Base cargo premium
currency = :(3) "USD"                         ; Premium currency
deposit_premium = #$:(0..)                    ; Deposit if open policy
minimum_premium = #$:(0..)                    ; Minimum premium
policy_fee = #$:(0..)                         ; Policy fee
rate_per_hundred = #                          ; Rate per $100
strikes_premium = #$:(0..)                    ; SRCC premium
taxes_and_fees = #$:(0..)                     ; Taxes and fees
war_premium = #$:(0..)                        ; War risk premium

; ---------------------------------------------------------------------------
; Rating Factors
; ---------------------------------------------------------------------------
{.rating_factors}
cargo_class = :                               ; Cargo class factor
commodities[] = :                             ; Specific commodities
deductible_credit = #                         ; Deductible credit
experience = #                                ; Experience rating
origin_destination = :                        ; Route factor
packing_factor = #                            ; Packing credit/debit
vessel_age = #                                ; Vessel age factor
volume_discount = #                           ; Volume discount

{@oc_premium}

; ===================================================================================
; Claims
; ===================================================================================
; Cargo claim structure.

{@oc_claim}
; Required fields first
claim_date = !date                            ; Date of claim
claim_type = !(
    contamination,                            ; Contamination
    damage,                                   ; Physical damage
    general_average,                          ; GA contribution
    loss,                                     ; Total loss
    partial_loss,                             ; Partial loss
    shortage,                                 ; Missing cargo
    temperature,                              ; Temperature damage
    theft,                                    ; Theft/pilferage
    water_damage,                             ; Water/moisture
    other                                     ; Other loss
)

; Optional fields
adjuster = :                                  ; Claims adjuster
amount_claimed = #$:(0..)                     ; Amount claimed
amount_paid = #$:(0..)                        ; Amount settled
bill_of_lading = :                            ; B/L reference
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
deductible_applied = #$:(0..)                 ; Deductible amount
documents[] = :                               ; Supporting documents
excess_applied = #$:(0..)                     ; Excess amount
notice_of_claim_date = date                   ; Claim notice date
reserve = #$:(0..)                            ; Reserve amount
salvage = #$:(0..)                            ; Salvage recovery
shipment_reference = :                        ; Shipment ID
subrogation_recovery = #$:(0..)               ; Subrogation amount
survey_report = :                             ; Survey reference

; ===================================================================================
; Open Cargo Policy
; ===================================================================================
; Annual open cargo policy structure.

{@ocean_cargo_policy}
; Required fields first
coverage_terms = !@oc_coverage_terms          ; Coverage terms
effective_date = !date                        ; Policy effective date
expiration_date = !date                       ; Policy expiration date
limit_any_one_conveyance = !#$:(0..)          ; Per conveyance limit
limit_any_one_location = !#$:(0..)            ; Per location limit
policy_number = !:                            ; Policy number

; Invariants
:invariant expiration_date > effective_date

; Optional fields
additional_coverages = @oc_additional_coverages  ; Extensions
agency = @agency                              ; Issuing agency
aggregate_limit = #$:(0..)                    ; Annual aggregate
annual_value = #$:(0..)                       ; Estimated annual cargo
broker = :                                    ; Broker name
claims[] = @oc_claim                          ; Claims history
commodities_covered[] = :                     ; Covered commodities
commodities_excluded[] = :                    ; Excluded commodities
countries_excluded[] = :(2..3)                ; Excluded countries
declarations[] = @oc_shipment                 ; Shipment declarations
exclusions = @oc_exclusions                   ; Policy exclusions
id = :                                        ; Internal identifier
insured_name = !:                             ; Named insured
insured_address = @address                    ; Insured address
loss_payee = :                                ; Loss payee if any
policy_form = (
    annual_open,                              ; Open cargo policy
    blanket,                                  ; Blanket coverage
    specific_voyage                           ; Voyage policy
)
policy_status = (
    active,
    cancelled,
    expired,
    pending,
    suspended
)
premium = @oc_premium                         ; Premium details
producer = @producer                          ; Agent
reporting_requirements = :                    ; Declaration requirements
routes_covered[] = :                          ; Covered trade routes
routes_excluded[] = :                         ; Excluded routes
special_conditions[] = :                      ; Special terms
subjectivities[] = :                          ; Outstanding requirements
underwriting = @underwriting_decision         ; Underwriting decision
vessels_approved[] = :                        ; Approved vessels
vessels_excluded[] = :                        ; Excluded vessels
war_strikes = @oc_war_strikes                 ; War/strikes coverage

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
estimated_shipments = ##                      ; Annual shipment count
estimated_value = #$:(0..)                    ; Annual cargo value
primary_commodities[] = :                     ; Main cargo types
primary_routes[] = :                          ; Main trade lanes

{@ocean_cargo_policy}


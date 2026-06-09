; ===================================================================================
; ODIN Mining Insurance Schema
; ===================================================================================
; Mining industry insurance covering surface and underground mining operations
; including property (above and below ground), business interruption, equipment
; breakdown, liability, subsidence, and tailings dam coverage.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.energy.mining"
version = "1.0.0"
title = "Mining Insurance Schema"
description = "Comprehensive insurance for mining and extraction operations"

{$derivation}
source[0].authority = "Mine Safety and Health Administration (MSHA)"
source[0].citation = "Mining Safety and Insurance Requirements"
source[0].url = "https://www.msha.gov/"

source[1].authority = "U.S. Office of Surface Mining"
source[1].citation = "Surface Mining Reclamation and Bonding Requirements"
source[1].url = "https://www.osmre.gov/"

source[2].authority = "Environmental Protection Agency"
source[2].citation = "Mining Environmental Compliance and Insurance"
source[2].url = "https://www.epa.gov/"

source[3].authority = "National Mining Association"
source[3].citation = "Mining Industry Insurance Standards"
source[3].url = "https://nma.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on MSHA, OSM, and industry mining insurance standards"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial mining insurance schema"
changelog[0].rationale = "Commercial energy coverage for mining operations"

; ===================================================================================
; Mining Type Classification
; ===================================================================================

{@mine_type}
operation = (
    aggregate,                                ; Sand/gravel/aggregate
    coal_surface,                             ; Surface coal mining
    coal_underground,                         ; Underground coal
    construction_materials,                   ; Construction mining
    dimension_stone,                          ; Quarrying
    hard_rock_surface,                        ; Surface hard rock
    hard_rock_underground,                    ; Underground hard rock
    industrial_minerals,                      ; Industrial minerals
    metal_open_pit,                           ; Open pit metal
    metal_underground,                        ; Underground metal
    oil_sands,                                ; Oil sands/tar sands
    placer,                                   ; Placer mining
    rare_earth,                               ; Rare earth mining
    uranium                                   ; Uranium mining
)

; Commodity mined
commodity = (
    aggregate,                                ; Sand/gravel
    bauxite,                                  ; Aluminum ore
    coal,                                     ; Coal
    copper,                                   ; Copper
    gold,                                     ; Gold
    iron_ore,                                 ; Iron ore
    limestone,                                ; Limestone
    lithium,                                  ; Lithium
    nickel,                                   ; Nickel
    phosphate,                                ; Phosphate
    potash,                                   ; Potash
    rare_earth,                               ; Rare earth
    silver,                                   ; Silver
    uranium,                                  ; Uranium
    zinc,                                     ; Zinc
    other                                     ; Other
)

; ===================================================================================
; Mine Site Details
; ===================================================================================

{@mine_site}
; Required fields first
mine_name = :                                ; Mine name
mine_type = @mine_type                       ; Mining classification
tiv = #$:(0..)                               ; Total insured value

; Optional fields
access_type = (air, rail, road, water)        ; Site access
address = @address                            ; Site location
annual_production = :                         ; Annual output
depth_feet = ##                               ; Depth (underground)
employee_count = ##                           ; Site employees
environmental_bonds = #$:(0..)                ; Bond amounts
equipment_value = #$:(0..)                    ; Equipment TIV
infrastructure_value = #$:(0..)               ; Infrastructure TIV
lat = #:(-90..90)                             ; Latitude
life_of_mine_years = ##                       ; Remaining life
long = #:(-180..180)                          ; Longitude
mill_capacity = :                             ; Processing capacity
mine_id = :                                   ; Internal identifier
msha_id = :                                   ; MSHA ID number
operating_days = ##                           ; Days/year operating
processing_facility = ?                       ; Has processing
production_rate = :                           ; Production rate
proven_reserves = :                           ; Proven reserves
reclamation_bond = #$:(0..)                   ; Reclamation bond
site_acres = ##                               ; Site size
state = :(2)                                  ; State
stockpile_value = #$:(0..)                    ; Inventory value
tailings_dam = ?                              ; Has tailings dam
waste_impoundment = ?                         ; Has waste impound
water_rights = ?                              ; Has water rights
year_opened = ##                              ; Year operations began

; ---------------------------------------------------------------------------
; Underground-Specific
; ---------------------------------------------------------------------------
{.underground}
mining_method = (
    block_caving,                             ; Block caving
    cut_and_fill,                             ; Cut and fill
    longwall,                                 ; Longwall
    room_and_pillar,                          ; Room and pillar
    shrinkage_stoping,                        ; Shrinkage stoping
    sublevel_caving,                          ; Sublevel caving
    sublevel_stoping                          ; Sublevel stoping
):if mine_type.operation = (coal_underground, hard_rock_underground, metal_underground)
portal_count = ##:if mine_type.operation = (coal_underground, hard_rock_underground, metal_underground)
shaft_count = ##:if mine_type.operation = (coal_underground, hard_rock_underground, metal_underground)
ventilation_shafts = ##:if mine_type.operation = (coal_underground, hard_rock_underground, metal_underground)

{@mine_site}

; ---------------------------------------------------------------------------
; Surface-Specific
; ---------------------------------------------------------------------------
{.surface}
bench_count = ##:if mine_type.operation = (metal_open_pit, coal_surface, hard_rock_surface)
haul_road_miles = #:if mine_type.operation = (metal_open_pit, coal_surface, hard_rock_surface)
overburden_ratio = #:if mine_type.operation = (metal_open_pit, coal_surface, hard_rock_surface)
pit_depth_feet = ##:if mine_type.operation = (metal_open_pit, coal_surface, hard_rock_surface)

{@mine_site}

; ===================================================================================
; Property Coverage
; ===================================================================================

{@mine_property}
; Required fields first
total_insured_value = #$:(0..)               ; TIV

; Optional fields
all_risk = ?                                  ; All-risk form
buildings = #$:(0..)                          ; Building values
business_interruption = ?                     ; BI coverage
bi_annual_value = #$:(0..):if business_interruption = true
bi_indemnity_months = ##:if business_interruption = true
bi_waiting_days = ##:if business_interruption = true
deductible = #$:(0..)                         ; Property deductible
earthquake = ?                                ; Earthquake
equipment = #$:(0..)                          ; Equipment values
equipment_breakdown = ?                       ; MB coverage
flood = ?                                     ; Flood coverage
infrastructure = #$:(0..)                     ; Infrastructure
inventory = #$:(0..)                          ; Stockpile inventory
landslide = ?                                 ; Landslide coverage
replacement_cost = ?                          ; RC valuation
subsidence = ?                                ; Subsidence coverage
tailings_dam = ?                              ; Tailings dam failure
underground_collapse = ?                      ; Collapse coverage
wildfire = ?                                  ; Wildfire

; ===================================================================================
; Mining-Specific Perils
; ===================================================================================

{@mine_perils}
; Underground perils
bump = ?                                      ; Rock bump/burst
cave_in = ?                                   ; Cave-in
coal_burst = ?                                ; Coal burst
explosion = ?                                 ; Explosion
gas_ignition = ?                              ; Gas ignition
inundation = ?                                ; Water inundation
roof_collapse = ?                             ; Roof collapse
spontaneous_combustion = ?                    ; Spontaneous fire
subsidence = ?                                ; Subsidence

; Surface perils
embankment_failure = ?                        ; Embankment failure
highwall_failure = ?                          ; Highwall collapse
landslide = ?                                 ; Landslide
pit_wall_failure = ?                          ; Pit wall failure
slope_failure = ?                             ; Slope failure
tailings_breach = ?                           ; Tailings dam breach
waste_dump_failure = ?                        ; Waste dump failure

; ===================================================================================
; Liability Coverage
; ===================================================================================

{@mine_liability}
; Required fields first
general_liability = #$:(0..)                 ; GL per occurrence

; Optional fields
aggregate = #$:(0..)                          ; Annual aggregate
auto_liability = ?                            ; Auto coverage
contractors = ?                               ; Contractor coverage
deductible = #$:(0..)                         ; Liability deductible
employers_liability = ?                       ; EL coverage
el_limit = #$:(0..):if employers_liability = true
excess_umbrella = ?                           ; Excess/umbrella
excess_limit = #$:(0..):if excess_umbrella = true
pollution = ?                                 ; Pollution liability
pollution_limit = #$:(0..):if pollution = true
products = ?                                  ; Products liability
professional = ?                              ; Professional/E&O
subsidence_liability = ?                      ; Subsidence claims

; ===================================================================================
; Environmental Coverage
; ===================================================================================

{@mine_environmental}
included = ?                                  ; Environmental coverage
acid_drainage = ?:if included = true          ; AMD coverage
aggregate = #$:(0..):if included = true       ; Annual aggregate
cleanup_costs = ?:if included = true          ; Cleanup expenses
deductible = #$:(0..):if included = true      ; Deductible
groundwater = ?:if included = true            ; Groundwater
limit_per_occurrence = #$:(0..):if included = true
natural_resource = ?:if included = true       ; NRD coverage
reclamation = ?:if included = true            ; Reclamation
tailings = ?:if included = true               ; Tailings spill
third_party = ?:if included = true            ; Third-party claims
transportation = ?:if included = true         ; Transit pollution

; ===================================================================================
; Premium Details
; ===================================================================================

{@mine_premium}
; Required fields first
total_premium = #$:(0..)                     ; Total premium

; Optional fields
environmental_premium = #$:(0..)              ; Environmental
liability_premium = #$:(0..)                  ; Liability
minimum_premium = #$:(0..)                    ; Minimum premium
policy_fee = #$:(0..)                         ; Policy fee
property_premium = #$:(0..)                   ; Property
taxes_and_fees = #$:(0..)                     ; Taxes/fees

; ===================================================================================
; Claims
; ===================================================================================

{@mine_claim}
; Required fields first
claim_date = date                            ; Claim date
claim_type = (
    bodily_injury,                            ; BI claim
    business_interruption,                    ; BI loss
    cave_in,                                  ; Cave-in
    collapse,                                 ; Collapse
    environmental,                            ; Environmental
    equipment_failure,                        ; Equipment
    explosion,                                ; Explosion
    fire,                                     ; Fire
    flood,                                    ; Flood/inundation
    property_damage,                          ; PD claim
    slope_failure,                            ; Slope failure
    subsidence,                               ; Subsidence
    tailings,                                 ; Tailings breach
    other                                     ; Other
)

; Optional fields
amount_claimed = #$:(0..)                     ; Amount claimed
amount_paid = #$:(0..)                        ; Amount paid
claim_id = :                                  ; Claim ID
claim_status = (closed, denied, open, paid, reserved)
deductible_applied = #$:(0..)                 ; Deductible
description = :                               ; Description
downtime_days = ##                            ; Downtime
mine_reference = :                            ; Mine site
reserve = #$:(0..)                            ; Reserve

; ===================================================================================
; Mining Insurance Policy
; ===================================================================================

{@mining_policy}
; Required fields first
effective_date = date                        ; Policy effective date
expiration_date = date                       ; Policy expiration date
mines[] = @mine_site                         ; Covered mines
policy_number = :                            ; Policy number

; Invariants
:invariant expiration_date > effective_date

; Optional fields
agency = @agency                              ; Issuing agency
claims[] = @mine_claim                        ; Claims history
environmental = @mine_environmental           ; Environmental coverage
id = :                                        ; Internal identifier
insured_name = :                             ; Named insured
insured_address = @address                    ; Insured address
liability = @mine_liability                   ; Liability coverage
perils = @mine_perils                         ; Covered perils
policy_status = (active, cancelled, expired, pending)
premium = @mine_premium                       ; Premium details
producer = @producer                          ; Agent
property = @mine_property                     ; Property coverage
underwriting = @underwriting_decision         ; Underwriting

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
commodity = :                                 ; Primary commodity
liability_limit = #$:(0..)                    ; Liability limit
mine_count = ##                               ; Site count
property_tiv = #$:(0..)                       ; Total TIV

{@mining_policy}


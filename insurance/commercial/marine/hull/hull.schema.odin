; ===================================================================================
; ODIN Marine Hull Insurance Schema
; ===================================================================================
; Marine hull insurance covering commercial vessels, their machinery, and equipment
; including total loss, partial loss, general average, collision liability (Running
; Down Clause), machinery damage, and loss of hire.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.marine.hull"
version = "1.0.0"
title = "Marine Hull Insurance Schema"
description = "Commercial marine hull insurance for vessels and watercraft"

{$derivation}
source[0].authority = "Lloyd's Market Association"
source[0].citation = "Institute Time Clauses - Hulls"
source[0].url = "https://www.lmalloyds.com/LMA/Underwriting/Marine/JCC/JCC.aspx"

source[1].authority = "American Institute of Marine Underwriters (AIMU)"
source[1].citation = "American Hull Insurance Syndicate Clauses"
source[1].url = "https://www.aimu.org/"

source[2].authority = "International Maritime Organization (IMO)"
source[2].citation = "SOLAS and Maritime Safety Conventions"
source[2].url = "https://www.imo.org/"

source[3].authority = "United States Coast Guard"
source[3].citation = "Commercial Vessel Documentation Requirements"
source[3].url = "https://www.uscg.mil/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on Institute Time Clauses Hulls and American hull forms"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial marine hull insurance schema"
changelog[0].rationale = "Commercial marine hull coverage for vessel operators"

; ===================================================================================
; Vessel Type Classification
; ===================================================================================
; Standard vessel classifications for marine hull insurance.

{@hull_vessel_type}
classification = !(
    barge,                                    ; Non-self-propelled barge
    bulk_carrier,                             ; Bulk cargo vessel
    cable_ship,                               ; Cable laying vessel
    container_ship,                           ; Container vessel
    cruise_ship,                              ; Passenger cruise
    dredger,                                  ; Dredging vessel
    drill_ship,                               ; Drilling vessel
    ferry,                                    ; Passenger ferry
    fishing_vessel,                           ; Commercial fishing
    floating_dock,                            ; Floating dry dock
    fpso,                                     ; Floating production
    general_cargo,                            ; General cargo vessel
    heavy_lift,                               ; Heavy lift vessel
    lng_carrier,                              ; LNG tanker
    lpg_carrier,                              ; LPG tanker
    offshore_supply,                          ; OSV/PSV
    passenger_vessel,                         ; Passenger ship
    reefer,                                   ; Refrigerated vessel
    ro_ro,                                    ; Roll-on/roll-off
    tanker,                                   ; Oil/chemical tanker
    tug,                                      ; Tugboat
    workboat,                                 ; General workboat
    yacht                                     ; Commercial yacht
)

; Propulsion type
propulsion = (
    diesel,                                   ; Diesel engine
    diesel_electric,                          ; Diesel-electric
    dual_fuel,                                ; Dual fuel (LNG)
    electric,                                 ; Electric
    gas_turbine,                              ; Gas turbine
    hybrid,                                   ; Hybrid power
    none,                                     ; Non-propelled
    sail,                                     ; Sail powered
    steam                                     ; Steam turbine
)

; Operating area
trading_area = (
    coastal,                                  ; Coastal waters
    great_lakes,                              ; Great Lakes
    inland_rivers,                            ; Rivers/canals
    offshore,                                 ; Offshore operations
    worldwide                                 ; Worldwide trading
)

; ===================================================================================
; Vessel Details
; ===================================================================================
; Comprehensive vessel specifications.

{@hull_vessel}
; Required fields first
gross_tonnage = !##                           ; Gross tonnage
imo_number = !:                               ; IMO vessel number
vessel_name = !:                              ; Vessel name
vessel_type = !@hull_vessel_type              ; Vessel classification

; Optional fields
beam_meters = #                               ; Beam width
builder = :                                   ; Shipyard/builder
call_sign = :                                 ; Radio call sign
classification_society = :                    ; Class society (DNV, ABS, etc.)
classification_status = (
    conditional,                              ; Conditional class
    full_class,                               ; In class
    interim,                                  ; Interim class
    suspended,                                ; Class suspended
    withdrawn                                 ; Class withdrawn
)
container_capacity_teu = ##                   ; TEU capacity if applicable
deadweight_tonnage = ##                       ; DWT
depth_meters = #                              ; Depth
draft_meters = #                              ; Maximum draft
engine_make = :                               ; Main engine manufacturer
engine_model = :                              ; Engine model
engine_power_kw = ##                          ; Main engine power
flag_state = :(2..3)                          ; Flag state
former_names[] = :                            ; Previous vessel names
hull_material = (
    aluminum,
    composite,
    fiberglass,
    steel,
    wood
)
keel_laid_date = date                         ; Keel laying date
length_overall_meters = #                     ; LOA
mmsi = :                                      ; Maritime Mobile Service ID
net_tonnage = ##                              ; Net tonnage
official_number = :                           ; Official number
passenger_capacity = ##                       ; Passenger count if applicable
port_of_registry = :                          ; Home port
propeller_count = ##                          ; Number of propellers
service_speed_knots = #                       ; Service speed
vessel_id = :                                 ; Internal identifier
year_built = ##:(1900..2100)                  ; Year of construction

; ---------------------------------------------------------------------------
; Classification and Surveys
; ---------------------------------------------------------------------------
{.classification}
class_notation = :                            ; Full class notation
entry_date = date                             ; Class entry date
ice_class = :                                 ; Ice class notation
last_annual_survey = date                     ; Last annual survey
last_docking_survey = date                    ; Last dry-dock survey
last_intermediate_survey = date               ; Last intermediate
last_special_survey = date                    ; Last special survey
next_annual_survey = date                     ; Next annual due
next_docking_survey = date                    ; Next dry-dock due
next_special_survey = date                    ; Next special due
recommendations[] = :                         ; Outstanding conditions

{@hull_vessel}

; ---------------------------------------------------------------------------
; Machinery Details
; ---------------------------------------------------------------------------
{.machinery}
aux_engine_count = ##                         ; Auxiliary engines
aux_engine_power_kw = ##                      ; Aux engine power
boiler_count = ##                             ; Number of boilers
bow_thruster = ?                              ; Has bow thruster
crane_capacity_tonnes = #                     ; Crane capacity
generator_count = ##                          ; Generators
main_engine_count = ##                        ; Main engines
stern_thruster = ?                            ; Has stern thruster

{@hull_vessel}

; ---------------------------------------------------------------------------
; Safety Equipment
; ---------------------------------------------------------------------------
{.safety}
ecdis = ?                                     ; Electronic charts
epirb = ?                                     ; Emergency beacon
fire_fighting_class = :                       ; Fire fighting notation
gmdss = ?                                     ; GMDSS equipment
ism_certified = ?                             ; ISM Code compliance
isps_certified = ?                            ; ISPS compliance
lifeboat_capacity = ##                        ; Lifeboat capacity
solas_compliant = ?                           ; SOLAS compliance
vdr = ?                                       ; Voyage data recorder

{@hull_vessel}

; ---------------------------------------------------------------------------
; Ownership and Management
; ---------------------------------------------------------------------------
{.ownership}
beneficial_owner = :                          ; Beneficial owner
commercial_manager = :                        ; Commercial manager
doa_holder = :                                ; DOC holder
operator = :                                  ; Ship operator
registered_owner = :                          ; Registered owner
technical_manager = :                         ; Technical manager

{@hull_vessel}

; ===================================================================================
; Hull Valuation
; ===================================================================================
; Vessel valuation for insurance purposes.

{@hull_valuation}
; Required fields first
agreed_value = !#$:(0..)                      ; Agreed insured value

; Optional fields
currency = :(3) "USD"                         ; Value currency
disbursements_value = #$:(0..)                ; Disbursements (IV)
freight_value = #$:(0..)                      ; Freight value
increased_value = #$:(0..)                    ; Increased value
machinery_value = #$:(0..)                    ; Machinery value
market_value = #$:(0..)                       ; Current market value
replacement_value = #$:(0..)                  ; New-build cost
scrap_value = #$:(0..)                        ; Scrap steel value
total_insured_value = #$:(0..)                ; TIV
valuation_basis = (
    agreed_value,                             ; Agreed value
    assessed_value,                           ; Broker assessment
    book_value,                               ; Accounting value
    market_value                              ; Current market
)
valuation_date = date                         ; Date of valuation

; ===================================================================================
; Hull Coverage Terms
; ===================================================================================
; Coverage terms and conditions.

{@hull_coverage}
; Required fields first
clause_set = !(
    aih,                                      ; American Institute Hull
    american_yacht,                           ; American yacht form
    itc_hulls,                                ; Institute Time Clauses Hulls
    itc_hulls_1983,                           ; ITC Hulls 1983
    itc_hulls_1995,                           ; ITC Hulls 1995
    norwegian_plan,                           ; Norwegian Marine Plan
    special                                   ; Manuscript terms
)

; Optional fields
additional_perils = ?                         ; Additional perils clause
classification_clause = ?                     ; Classification warranty
collision_liability = ?                       ; Running down clause
constructive_total_loss = ?                   ; CTL coverage
continuation_clause = ?                       ; Held covered
crew_negligence = ?                           ; Crew negligence covered
deductible = #$:(0..)                         ; Policy deductible
disbursements = ?                             ; Disbursements covered
ffo_liability = ?                             ; Fixed/floating objects
general_average = ?true                       ; GA covered
inchmaree_clause = ?                          ; Machinery damage
latent_defect = ?                             ; Latent defect covered
pollution_hazard = ?                          ; Pollution liability
salvage = ?true                               ; Salvage covered
sister_ship = ?                               ; Sister ship clause
sue_and_labor = ?true                         ; Sue and labor

; ---------------------------------------------------------------------------
; Deductibles
; ---------------------------------------------------------------------------
{.deductibles}
machinery = #$:(0..)                          ; Machinery deductible
navigation = #$:(0..)                         ; Navigation deductible
standard = #$:(0..)                           ; Standard deductible
stranding = #$:(0..)                          ; Stranding deductible

{@hull_coverage}

; ---------------------------------------------------------------------------
; Collision Liability
; ---------------------------------------------------------------------------
{.collision}
limit = #$:(0..)                              ; 3/4 or 4/4 collision
limit_type = (
    excess,                                   ; Excess of P&I
    four_fourths,                             ; Full 4/4 RDC
    three_fourths                             ; Standard 3/4 RDC
)
sistership = ?                                ; Sister ship covered

{@hull_coverage}

; ===================================================================================
; Trading Warranties
; ===================================================================================
; Geographic and operational warranties.

{@hull_warranties}
; Trading area
excluded_waters[] = :                         ; Excluded areas
navigation_limits = :                         ; Trading limits
trading_warranty = (
    coastal,                                  ; Coastal only
    great_lakes,                              ; Great Lakes
    inland_waters,                            ; Inland only
    worldwide,                                ; Worldwide
    worldwide_except                          ; WW with exclusions
)
winter_trading = :                            ; Winter restrictions

; Operational warranties
cargo_exclusions[] = :                        ; Excluded cargoes
hazardous_cargo = ?                           ; Hazardous allowed
hot_work = ?                                  ; Hot work restrictions
layup_warranty = ?                            ; Layup requirements
passenger_warranty = ?                        ; Passenger restrictions
speed_warranty = ##                           ; Speed limitation
towing_warranty = ?                           ; Towing restrictions
towage = (
    customary,                                ; Customary towage
    in_ballast,                               ; Ballast only
    not_under_tow,                            ; No towage
    towage_permitted                          ; Towage allowed
)

; Classification warranty
class_maintained = ?true                      ; Must maintain class
class_recommendations = ?                     ; Outstanding conditions
class_society_approved[] = :                  ; Approved societies

; Management warranty
ism_compliance = ?                            ; ISM required
isps_compliance = ?                           ; ISPS required
manager_approved = ?                          ; Manager approval

; ===================================================================================
; War and Strikes
; ===================================================================================
; War risk and strikes coverage.

{@hull_war_strikes}
; War risk
war_coverage = ?                              ; War risk coverage
war_clause = (
    american_war,                             ; American war clause
    institute_war,                            ; Institute war clause
    london_blocking,                          ; London blocking
    special                                   ; Special terms
):if war_coverage = true
war_limit = #$:(0..):if war_coverage = true   ; War risk limit
war_premium = #$:(0..):if war_coverage = true ; War premium
war_cancellation_days = ##:if war_coverage = true  ; Cancellation notice

; Strikes coverage
strikes_coverage = ?                          ; Strikes coverage
strikes_limit = #$:(0..):if strikes_coverage = true
strikes_premium = #$:(0..):if strikes_coverage = true

; Excluded areas
excluded_areas[] = :                          ; War-excluded areas
additional_premium_areas[] = :                ; AP required areas
breach_notification = ?                       ; Breach notice required

; ===================================================================================
; Loss of Hire/Earnings
; ===================================================================================
; Loss of hire insurance coverage.

{@hull_loss_of_hire}
; Required if purchased
included = !?                                 ; LOH coverage included

; Coverage terms
daily_rate = #$:(0..):if included = true      ; Daily insured rate
deductible_days = ##:if included = true       ; Waiting period
indemnity_period_days = ##:if included = true ; Maximum days
limit = #$:(0..):if included = true           ; Total LOH limit
premium = #$:(0..):if included = true         ; LOH premium

; Coverage scope
collision = ?:if included = true              ; Collision covered
grounding = ?:if included = true              ; Grounding covered
machinery = ?:if included = true              ; Machinery breakdown
total_loss = ?:if included = true             ; Total loss trigger

; ===================================================================================
; Premium Details
; ===================================================================================
; Hull insurance premium.

{@hull_premium}
; Required fields first
total_premium = !#$:(0..)                     ; Total annual premium

; Optional fields
base_premium = #$:(0..)                       ; Base hull premium
collision_premium = #$:(0..)                  ; RDC premium
currency = :(3) "USD"                         ; Premium currency
ffo_premium = #$:(0..)                        ; FFO premium
installments = ##                             ; Number of installments
loss_of_hire_premium = #$:(0..)               ; LOH premium
machinery_premium = #$:(0..)                  ; Additional machinery
minimum_premium = #$:(0..)                    ; Minimum premium
policy_fee = #$:(0..)                         ; Policy fee
rate = #                                      ; Rate per hundred
return_premium = #$:(0..)                     ; Return premium credits
strikes_premium = #$:(0..)                    ; Strikes premium
taxes_and_fees = #$:(0..)                     ; Taxes and fees
war_premium = #$:(0..)                        ; War premium

; ---------------------------------------------------------------------------
; Rating Factors
; ---------------------------------------------------------------------------
{.rating_factors}
age_factor = #                                ; Vessel age factor
class_credit = #                              ; Classification credit
claims_experience = #                         ; Claims loading
deductible_credit = #                         ; Deductible credit
flag_state_factor = #                         ; Flag state factor
management_credit = #                         ; Management credit
trading_area = #                              ; Trading area factor
vessel_type_factor = #                        ; Type factor

{@hull_premium}

; ===================================================================================
; Claims
; ===================================================================================
; Hull claim structure.

{@hull_claim}
; Required fields first
claim_date = !date                            ; Date of claim
claim_type = !(
    collision,                                ; Collision damage
    constructive_total_loss,                  ; CTL
    contact,                                  ; Contact damage
    crew_injury,                              ; Crew-related
    engine_room,                              ; Engine room incident
    fire_explosion,                           ; Fire/explosion
    ffo,                                      ; Fixed/floating object
    general_average,                          ; GA contribution
    grounding,                                ; Grounding
    heavy_weather,                            ; Weather damage
    latent_defect,                            ; Latent defect
    machinery,                                ; Machinery damage
    piracy,                                   ; Piracy attack
    pollution,                                ; Pollution incident
    salvage,                                  ; Salvage operation
    sinking,                                  ; Sinking
    theft,                                    ; Theft/pilferage
    total_loss,                               ; Actual total loss
    other                                     ; Other
)

; Optional fields
adjuster = :                                  ; Marine surveyor
amount_claimed = #$:(0..)                     ; Amount claimed
amount_paid = #$:(0..)                        ; Amount settled
cause_of_loss = :                             ; Loss description
claim_id = :                                  ; Claim identifier
claim_status = (
    closed,
    denied,
    investigation,
    litigation,
    negotiation,
    open,
    paid,
    reserved,
    subrogation
)
classification_surveyor = :                   ; Class surveyor
collision_other_vessel = :                    ; Other vessel name
date_of_loss = date                           ; When loss occurred
deductible_applied = #$:(0..)                 ; Deductible amount
dry_dock_required = ?                         ; Required dry-docking
location = :                                  ; Location of incident
pollution_involved = ?                        ; Pollution component
port_of_refuge = :                            ; Port of refuge
recovery = #$:(0..)                           ; Recovery/salvage
repair_port = :                               ; Where repaired
repair_time_days = ##                         ; Repair duration
reserve = #$:(0..)                            ; Current reserve
subrogation = #$:(0..)                        ; Subrogation recovery
survey_report = :                             ; Survey reference
third_party_liability = ?                     ; Third party involved

; ===================================================================================
; Marine Hull Policy
; ===================================================================================
; Complete hull policy composition.

{@hull_policy}
; Required fields first
coverage = !@hull_coverage                    ; Coverage terms
effective_date = !date                        ; Policy effective date
expiration_date = !date                       ; Policy expiration date
policy_number = !:                            ; Policy number
valuation = !@hull_valuation                  ; Vessel valuation
vessel = !@hull_vessel                        ; Insured vessel

; Invariants
:invariant expiration_date > effective_date

; Optional fields
agency = @agency                              ; Issuing agency
broker = :                                    ; Insurance broker
claims[] = @hull_claim                        ; Claims history
id = :                                        ; Internal identifier
insured_name = !:                             ; Named insured
insured_address = @address                    ; Insured address
layup_periods[] = @hull_layup                 ; Layup periods
loss_of_hire = @hull_loss_of_hire             ; LOH coverage
loss_payee = :                                ; Mortgagee/financier
policy_form = (
    annual_time,                              ; Annual time policy
    builders_risk,                            ; Construction
    port_risk,                                ; Port risk only
    voyage                                    ; Voyage policy
)
policy_status = (
    active,
    cancelled,
    expired,
    pending,
    suspended
)
premium = @hull_premium                       ; Premium details
producer = @producer                          ; Agent
subjectivities[] = :                          ; Outstanding requirements
underwriting = @underwriting_decision         ; Underwriting decision
war_strikes = @hull_war_strikes               ; War/strikes coverage
warranties = @hull_warranties                 ; Policy warranties

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
agreed_value = #$:(0..)                       ; Hull agreed value
collision_limit = #$:(0..)                    ; Collision limit
deductible = #$:(0..)                         ; Standard deductible
total_insured_value = #$:(0..)                ; TIV

{@hull_policy}

; ===================================================================================
; Layup Period
; ===================================================================================
; Layup return premium structure.

{@hull_layup}
end_date = date                               ; Layup end
layup_port = :                                ; Layup location
layup_type = (
    cold,                                     ; Cold layup
    hot,                                      ; Hot/warm layup
    operational                               ; Operational standby
)
return_premium = #$:(0..)                     ; Return premium
return_rate = #:(0..100)                      ; Return rate percent
start_date = date                             ; Layup start
terms = :                                     ; Layup terms


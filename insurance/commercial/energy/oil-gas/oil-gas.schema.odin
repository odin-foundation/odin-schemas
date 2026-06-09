; ===================================================================================
; ODIN Oil and Gas Insurance Schema
; ===================================================================================
; Oil and gas industry insurance covering upstream (exploration and production),
; midstream (transportation and storage), and downstream (refining and distribution)
; operations including control of well, pollution, and business interruption.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.energy.oil-gas"
version = "1.0.0"
title = "Oil and Gas Insurance Schema"
description = "Comprehensive insurance for oil and gas industry operations"

{$derivation}
source[0].authority = "U.S. Bureau of Safety and Environmental Enforcement"
source[0].citation = "Offshore Oil and Gas Insurance Requirements"
source[0].url = "https://www.bsee.gov/"

source[1].authority = "Texas Railroad Commission"
source[1].citation = "Oil and Gas Operations Financial Assurance"
source[1].url = "https://www.rrc.texas.gov/"

source[2].authority = "Environmental Protection Agency"
source[2].citation = "Oil Pollution Prevention Requirements (SPCC)"
source[2].url = "https://www.epa.gov/"

source[3].authority = "International Association of Drilling Contractors"
source[3].citation = "Drilling Industry Insurance Standards"
source[3].url = "https://www.iadc.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on BSEE, state RRC, and industry insurance standards"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial oil and gas insurance schema"
changelog[0].rationale = "Commercial energy coverage for petroleum industry"

; ===================================================================================
; Industry Segment
; ===================================================================================

{@og_segment}
segment = (
    downstream,                               ; Refining/distribution
    midstream,                                ; Transportation/storage
    oilfield_services,                        ; Service companies
    upstream                                  ; E&P operations
)

; ===================================================================================
; Operations Classification
; ===================================================================================

{@og_operation}
operation_type = (
    completion,                               ; Well completion
    directional_drilling,                     ; Directional drilling
    drilling,                                 ; Drilling operations
    enhanced_recovery,                        ; EOR/IOR
    exploration,                              ; Exploration
    fracking,                                 ; Hydraulic fracturing
    gathering,                                ; Gathering systems
    offshore_platform,                        ; Offshore production
    onshore_production,                       ; Land production
    pipeline,                                 ; Pipeline operations
    processing,                               ; Gas processing
    refining,                                 ; Refinery
    storage,                                  ; Storage terminals
    terminal,                                 ; Distribution terminal
    transportation,                           ; Trucking/rail
    well_servicing,                           ; Workover/servicing
    wireline                                  ; Wireline services
)

location_type = (
    inland_waters,                            ; Lakes/rivers
    land,                                     ; Onshore
    offshore_deepwater,                       ; Deepwater >1000ft
    offshore_shelf                            ; Continental shelf
)

; ===================================================================================
; Insured Entity
; ===================================================================================

{@og_insured}
; Required fields first
entity_name = :                              ; Legal entity name
entity_type = (
    contractor,                               ; Oilfield contractor
    distributor,                              ; Product distributor
    joint_venture,                            ; JV/partnership
    operator,                                 ; Lease operator
    owner,                                    ; Working interest owner
    refiner,                                  ; Refinery operator
    service_company,                          ; Service provider
    transporter                               ; Pipeline/transporter
)

; Optional fields
address = @address                            ; Business address
email = *@email                               ; Contact email
fein = *:                                     ; Tax ID
iacuc_member = ?                              ; IADC member
parent_company = :                            ; Parent entity
phone = *@phone                               ; Contact phone
sic_code = :                                  ; SIC code
years_in_business = ##                        ; Years operating

; ===================================================================================
; Property Coverage
; ===================================================================================

{@og_property}
; Required fields first
property_type = (
    equipment,                                ; Movable equipment
    offshore_platform,                        ; Offshore structure
    onshore_facility,                         ; Onshore facilities
    pipeline,                                 ; Pipeline system
    processing_plant,                         ; Processing facility
    refinery,                                 ; Refinery
    storage_tank,                             ; Tank farm
    terminal,                                 ; Distribution terminal
    well                                      ; Wellhead/casing
)
total_insured_value = #$:(0..)               ; TIV

; Optional fields
business_interruption = ?                     ; BI coverage
bi_limit = #$:(0..):if business_interruption = true
bi_waiting_days = ##:if business_interruption = true
contingent_bi = ?                             ; Contingent BI
debris_removal = ?                            ; Debris removal
deductible = #$:(0..)                         ; Property deductible
extra_expense = ?                             ; Extra expense
extra_expense_limit = #$:(0..):if extra_expense = true
replacement_cost = ?                          ; RC valuation

; Covered perils
all_risk = ?                                  ; All-risk form
earthquake = ?                                ; Earthquake
flood = ?                                     ; Flood
named_storm = ?                               ; Named storm
windstorm = ?                                 ; Wind

; ===================================================================================
; Control of Well / Well Control
; ===================================================================================

{@og_well_control}
; Required fields first
included = ?                                 ; Well control coverage

; Coverage terms
blowout = ?:if included = true                ; Blowout coverage
control_costs = #$:(0..):if included = true   ; Control expense limit
cratering = ?:if included = true              ; Cratering
extra_expense = #$:(0..):if included = true   ; OEE limit
redrilling = ?:if included = true             ; Redrilling costs
redrilling_limit = #$:(0..):if redrilling = true
seepage = ?:if included = true                ; Seepage/pollution
seepage_limit = #$:(0..):if seepage = true
underground_blowout = ?:if included = true    ; Underground blowout
wild_well = ?:if included = true              ; Wild well

; Deductibles
deductible = #$:(0..):if included = true      ; Per well deductible
waiting_period_hours = ##:if included = true  ; Time deductible

; ===================================================================================
; Operators Extra Expense (OEE)
; ===================================================================================

{@og_oee}
included = ?                                  ; OEE coverage
aggregate_limit = #$:(0..):if included = true ; Annual aggregate
care_custody = ?:if included = true           ; CCC coverage
deductible = #$:(0..):if included = true      ; Deductible
limit_per_occurrence = #$:(0..):if included = true
pollution = ?:if included = true              ; Pollution OEE
redrilling = ?:if included = true             ; Redrilling
restoration = ?:if included = true            ; Well restoration
underground_resources = ?:if included = true   ; UGOD

; ===================================================================================
; Liability Coverage
; ===================================================================================

{@og_liability}
; Required fields first
general_liability_limit = #$:(0..)           ; GL per occurrence

; Optional fields
aggregate = #$:(0..)                          ; Annual aggregate
auto_liability = ?                            ; Auto liability
auto_limit = #$:(0..):if auto_liability = true
contractual = ?                               ; Contractual liability
deductible = #$:(0..)                         ; Liability deductible
employers_liability = ?                       ; EL coverage
el_limit = #$:(0..):if employers_liability = true
excess_umbrella = ?                           ; Excess/umbrella
excess_limit = #$:(0..):if excess_umbrella = true
products_completed = ?                        ; Prod/comp ops
products_limit = #$:(0..):if products_completed = true
professional_liability = ?                    ; Professional/E&O

; ===================================================================================
; Pollution Liability
; ===================================================================================

{@og_pollution}
; Required fields first
included = ?                                 ; Pollution coverage

; Coverage terms
aggregate = #$:(0..):if included = true       ; Annual aggregate
cleanup_costs = ?:if included = true          ; Cleanup expenses
deductible = #$:(0..):if included = true      ; Deductible
gradual_pollution = ?:if included = true      ; Gradual pollution
limit_per_occurrence = #$:(0..):if included = true
natural_resource = ?:if included = true       ; NRD coverage
opa_90 = ?:if included = true                 ; OPA 90 compliance
spcc_compliant = ?:if included = true         ; SPCC compliant
sudden_accidental = ?:if included = true      ; Sudden/accidental
third_party_claims = ?:if included = true     ; Third-party claims
transportation = ?:if included = true         ; Transit pollution

; ===================================================================================
; Location/Site Details
; ===================================================================================

{@og_location}
; Required fields first
location_id = :                              ; Location identifier
location_type = @og_operation                ; Operation type

; Optional fields
address = @address                            ; Physical address
api_number = :                                ; API well number
county = :                                    ; County
depth_feet = ##                               ; Well depth
field_name = :                                ; Field name
lat = #:(-90..90)                             ; Latitude
lease_name = :                                ; Lease name
long = #:(-180..180)                          ; Longitude
offshore_block = :                            ; OCS block
ocs_area = :                                  ; OCS area
operator = :                                  ; Operator name
platform_name = :                             ; Platform name
state = :(2)                                  ; State
tiv = #$:(0..)                                ; Location TIV
water_depth_feet = ##                         ; Water depth
well_name = :                                 ; Well name
working_interest = #:(0..100)                 ; WI percentage

; ===================================================================================
; Premium Details
; ===================================================================================

{@og_premium}
; Required fields first
total_premium = #$:(0..)                     ; Total premium

; Optional fields
liability_premium = #$:(0..)                  ; Liability premium
minimum_premium = #$:(0..)                    ; Minimum premium
oee_premium = #$:(0..)                        ; OEE premium
policy_fee = #$:(0..)                         ; Policy fee
pollution_premium = #$:(0..)                  ; Pollution premium
property_premium = #$:(0..)                   ; Property premium
taxes_and_fees = #$:(0..)                     ; Taxes/fees
well_control_premium = #$:(0..)               ; Well control

; ===================================================================================
; Claims
; ===================================================================================

{@og_claim}
; Required fields first
claim_date = date                            ; Claim date
claim_type = (
    blowout,                                  ; Blowout
    bodily_injury,                            ; BI claim
    business_interruption,                    ; BI loss
    equipment_damage,                         ; Equipment
    explosion,                                ; Explosion
    fire,                                     ; Fire
    pollution,                                ; Pollution
    property_damage,                          ; PD claim
    well_control,                             ; Well control
    other                                     ; Other
)

; Optional fields
amount_claimed = #$:(0..)                     ; Amount claimed
amount_paid = #$:(0..)                        ; Amount paid
claim_id = :                                  ; Claim ID
claim_status = (closed, denied, open, paid, reserved)
deductible_applied = #$:(0..)                 ; Deductible
description = :                               ; Description
location_reference = :                        ; Location
reserve = #$:(0..)                            ; Reserve

; ===================================================================================
; Oil and Gas Policy
; ===================================================================================

{@oil_gas_policy}
; Required fields first
effective_date = date                        ; Policy effective date
expiration_date = date                       ; Policy expiration date
insured = @og_insured                        ; Named insured
policy_number = :                            ; Policy number
segment = @og_segment                        ; Industry segment

; Invariants
:invariant expiration_date > effective_date

; Optional fields
agency = @agency                              ; Issuing agency
claims[] = @og_claim                          ; Claims history
liability = @og_liability                     ; Liability coverage
locations[] = @og_location                    ; Covered locations
oee = @og_oee                                 ; OEE coverage
policy_status = (active, cancelled, expired, pending)
pollution = @og_pollution                     ; Pollution coverage
premium = @og_premium                         ; Premium details
producer = @producer                          ; Agent
property = @og_property                       ; Property coverage
underwriting = @underwriting_decision         ; Underwriting
well_control = @og_well_control               ; Well control

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
liability_limit = #$:(0..)                    ; GL limit
location_count = ##                           ; Locations
pollution_limit = #$:(0..)                    ; Pollution limit
property_tiv = #$:(0..)                       ; Total TIV
well_control_limit = #$:(0..)                 ; Well control limit

{@oil_gas_policy}


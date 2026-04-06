; ===================================================================================
; ODIN Power Generation Insurance Schema
; ===================================================================================
; Conventional power generation insurance covering natural gas, coal-fired, nuclear,
; cogeneration, biomass, and waste-to-energy facilities including property,
; business interruption, machinery breakdown, and Price-Anderson nuclear coverage.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.energy.power-generation"
version = "1.0.0"
title = "Power Generation Insurance Schema"
description = "Insurance for conventional power generation facilities"

{$derivation}
source[0].authority = "Federal Energy Regulatory Commission (FERC)"
source[0].citation = "Power Generation Licensing and Insurance Requirements"
source[0].url = "https://www.ferc.gov/"

source[1].authority = "Nuclear Regulatory Commission (NRC)"
source[1].citation = "Nuclear Power Plant Insurance Requirements"
source[1].url = "https://www.nrc.gov/"

source[2].authority = "North American Electric Reliability Corporation (NERC)"
source[2].citation = "Reliability Standards for Generation"
source[2].url = "https://www.nerc.com/"

source[3].authority = "Environmental Protection Agency"
source[3].citation = "Power Plant Environmental Compliance"
source[3].url = "https://www.epa.gov/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on FERC, NRC, and industry power generation insurance standards"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial power generation insurance schema"
changelog[0].rationale = "Commercial energy coverage for power plants"

; ===================================================================================
; Generation Type
; ===================================================================================

{@pg_generation_type}
technology = !(
    biomass,                                  ; Biomass power
    coal_subcritical,                         ; Subcritical coal
    coal_supercritical,                       ; Supercritical coal
    coal_ultra_supercritical,                 ; Ultra-supercritical
    cogeneration,                             ; Combined heat/power
    diesel,                                   ; Diesel generators
    fuel_oil,                                 ; Fuel oil plant
    igcc,                                     ; Integrated gasification
    natural_gas_ccgt,                         ; Combined cycle gas
    natural_gas_peaker,                       ; Peaking plant
    natural_gas_simple,                       ; Simple cycle gas
    nuclear_bwr,                              ; Boiling water reactor
    nuclear_pwr,                              ; Pressurized water reactor
    waste_to_energy                           ; WTE facility
)

; Prime mover
prime_mover = (
    boiler_steam,                             ; Steam turbine
    combustion_turbine,                       ; Gas turbine
    combined_cycle,                           ; Combined cycle
    diesel_engine,                            ; Diesel engine
    gas_engine,                               ; Gas engine
    nuclear_steam                             ; Nuclear steam
)

; Operating status
operating_status = (
    baseload,                                 ; Baseload operation
    cycling,                                  ; Cycling plant
    intermediate,                             ; Intermediate
    peaking,                                  ; Peaking only
    standby                                   ; Standby/reserve
)

; ===================================================================================
; Facility Details
; ===================================================================================

{@pg_facility}
; Required fields first
capacity_mw = !#:(0..)                        ; Nameplate capacity
facility_name = !:                            ; Facility name
generation_type = !@pg_generation_type        ; Technology type
tiv = !#$:(0..)                               ; Total insured value

; Optional fields
address = @address                            ; Location
annual_generation_mwh = ##                    ; Annual output
capacity_factor = #:(0..100)                  ; Capacity factor
cod_date = date                               ; Commercial operation
control_area = :                              ; Control area
cooling_type = (
    air_cooled,                               ; Air cooling
    cooling_tower,                            ; Cooling tower
    dry_cooling,                              ; Dry cooling
    once_through,                             ; Once-through water
    pond                                      ; Cooling pond
)
eia_plant_id = :                              ; EIA plant ID
facility_id = :                               ; Internal identifier
fuel_source = :                               ; Primary fuel
grid_interconnection = :                      ; Interconnection
heat_rate = ##                                ; Heat rate BTU/kWh
iso_rto = :                                   ; ISO/RTO region
lat = #:(-90..90)                             ; Latitude
long = #:(-180..180)                          ; Longitude
nerc_region = :                               ; NERC region
nrc_license = ::if generation_type.technology = (nuclear_bwr, nuclear_pwr)
operator = :                                  ; Plant operator
owner = :                                     ; Owner
plant_age_years = ##                          ; Plant age
state = :(2)                                  ; State
unit_count = ##                               ; Generating units
utility = :                                   ; Connected utility

; ---------------------------------------------------------------------------
; Unit Details
; ---------------------------------------------------------------------------
{.units[]}
capacity_mw = #:(0..)                         ; Unit capacity
cod_date = date                               ; Unit COD
fuel_type = :                                 ; Unit fuel
manufacturer = :                              ; OEM
model = :                                     ; Unit model
unit_number = ##                              ; Unit number
unit_type = :                                 ; Unit type

{@pg_facility}

; ---------------------------------------------------------------------------
; Fuel Supply
; ---------------------------------------------------------------------------
{.fuel}
contract_type = (
    firm,                                     ; Firm supply
    interruptible,                            ; Interruptible
    spot,                                     ; Spot market
    tolling                                   ; Tolling arrangement
)
days_on_site = ##                             ; Fuel inventory days
dual_fuel = ?                                 ; Dual fuel capable
fuel_supplier = :                             ; Supplier name
pipeline = :                                  ; Pipeline name
storage_capacity = :                          ; Storage capacity

{@pg_facility}

; ---------------------------------------------------------------------------
; Nuclear-Specific
; ---------------------------------------------------------------------------
{.nuclear}
containment_type = (
    bwr_mark_1,
    bwr_mark_2,
    bwr_mark_3,
    large_dry,
    ice_condenser,
    subatmospheric
):if generation_type.technology = (nuclear_bwr, nuclear_pwr)
decommissioning_fund = #$:(0..):if generation_type.technology = (nuclear_bwr, nuclear_pwr)
license_expiration = date:if generation_type.technology = (nuclear_bwr, nuclear_pwr)
nsss_vendor = ::if generation_type.technology = (nuclear_bwr, nuclear_pwr)
price_anderson = ?:if generation_type.technology = (nuclear_bwr, nuclear_pwr)
reactor_thermal_mw = ##:if generation_type.technology = (nuclear_bwr, nuclear_pwr)
refuel_cycle_months = ##:if generation_type.technology = (nuclear_bwr, nuclear_pwr)

{@pg_facility}

; ===================================================================================
; Property Coverage
; ===================================================================================

{@pg_property}
; Required fields first
total_insured_value = !#$:(0..)               ; TIV

; Optional fields
all_risk = ?                                  ; All-risk form
boiler_machinery = ?                          ; B&M coverage
business_interruption = ?                     ; BI coverage
bi_annual_revenue = #$:(0..):if business_interruption = true
bi_indemnity_months = ##:if business_interruption = true
bi_waiting_days = ##:if business_interruption = true
capacity_payments = ?                         ; Capacity BI
contingent_bi = ?                             ; Contingent BI
debris_removal = ?                            ; Debris removal
deductible = #$:(0..)                         ; Property deductible
earthquake = ?                                ; Earthquake
equipment_breakdown = ?                       ; MB coverage
extra_expense = ?                             ; Extra expense
flood = ?                                     ; Flood
replacement_cost = ?                          ; RC valuation
service_interruption = ?                      ; Service BI
substation = ?                                ; Substation covered
transmission = ?                              ; Transmission lines
windstorm = ?                                 ; Wind/storm

; ===================================================================================
; Machinery Breakdown
; ===================================================================================

{@pg_machinery}
included = ?                                  ; MB coverage
aggregate = #$:(0..):if included = true       ; Annual aggregate
combustion_turbine = ?:if included = true     ; CT coverage
deductible = #$:(0..):if included = true      ; MB deductible
electrical = ?:if included = true             ; Electrical equipment
generator = ?:if included = true              ; Generator coverage
limit_per_occurrence = #$:(0..):if included = true
pressure_equipment = ?:if included = true     ; Boiler/pressure
service_interruption = ?:if included = true   ; Service BI
steam_turbine = ?:if included = true          ; ST coverage
transformer = ?:if included = true            ; Transformer coverage

; ===================================================================================
; Liability Coverage
; ===================================================================================

{@pg_liability}
; Required fields first
general_liability = !#$:(0..)                 ; GL per occurrence

; Optional fields
aggregate = #$:(0..)                          ; Annual aggregate
auto_liability = ?                            ; Auto coverage
deductible = #$:(0..)                         ; Liability deductible
employers_liability = ?                       ; EL coverage
excess_umbrella = ?                           ; Excess/umbrella
excess_limit = #$:(0..):if excess_umbrella = true
pollution = ?                                 ; Pollution liability
pollution_limit = #$:(0..):if pollution = true
products = ?                                  ; Products liability
professional = ?                              ; Professional/E&O

; ===================================================================================
; Nuclear-Specific Coverage
; ===================================================================================

{@pg_nuclear}
; Only for nuclear plants
applicable = ?                                ; Nuclear plant

; Primary nuclear coverage
onsite_property = #$:(0..):if applicable = true
decontamination = #$:(0..):if applicable = true
excess_property = #$:(0..):if applicable = true

; Liability (Price-Anderson)
primary_liability = #$:(0..):if applicable = true
secondary_layer = #$:(0..):if applicable = true
excess_liability = #$:(0..):if applicable = true

; Business interruption
accidental_outage = ?:if applicable = true
outage_bi_daily = #$:(0..):if accidental_outage = true
outage_bi_max = #$:(0..):if accidental_outage = true
outage_waiting_days = ##:if accidental_outage = true

; ===================================================================================
; Environmental Coverage
; ===================================================================================

{@pg_environmental}
included = ?                                  ; Environmental coverage
aggregate = #$:(0..):if included = true       ; Annual aggregate
air_emissions = ?:if included = true          ; Air emissions
ash_disposal = ?:if included = true           ; Ash/CCR coverage
cleanup_costs = ?:if included = true          ; Cleanup expenses
deductible = #$:(0..):if included = true      ; Deductible
groundwater = ?:if included = true            ; Groundwater
limit_per_occurrence = #$:(0..):if included = true
natural_resource = ?:if included = true       ; NRD coverage
third_party = ?:if included = true            ; Third-party claims
water_discharge = ?:if included = true        ; Water discharge

; ===================================================================================
; Premium Details
; ===================================================================================

{@pg_premium}
; Required fields first
total_premium = !#$:(0..)                     ; Total premium

; Optional fields
bi_premium = #$:(0..)                         ; BI premium
environmental_premium = #$:(0..)              ; Environmental
liability_premium = #$:(0..)                  ; Liability
machinery_premium = #$:(0..)                  ; Machinery BD
minimum_premium = #$:(0..)                    ; Minimum premium
nuclear_premium = #$:(0..)                    ; Nuclear (if applicable)
policy_fee = #$:(0..)                         ; Policy fee
property_premium = #$:(0..)                   ; Property
taxes_and_fees = #$:(0..)                     ; Taxes/fees

; ===================================================================================
; Claims
; ===================================================================================

{@pg_claim}
; Required fields first
claim_date = !date                            ; Claim date
claim_type = !(
    bodily_injury,                            ; BI claim
    boiler_explosion,                         ; Boiler
    business_interruption,                    ; BI loss
    combustion_turbine,                       ; CT failure
    contamination,                            ; Contamination
    electrical,                               ; Electrical failure
    environmental,                            ; Environmental
    fire,                                     ; Fire
    flood,                                    ; Flood
    generator,                                ; Generator failure
    property_damage,                          ; PD claim
    steam_turbine,                            ; ST failure
    transformer,                              ; Transformer
    weather,                                  ; Weather damage
    other                                     ; Other
)

; Optional fields
amount_claimed = #$:(0..)                     ; Amount claimed
amount_paid = #$:(0..)                        ; Amount paid
claim_id = :                                  ; Claim ID
claim_status = (closed, denied, open, paid, reserved)
deductible_applied = #$:(0..)                 ; Deductible
description = :                               ; Description
downtime_days = ##                            ; Outage days
facility_reference = :                        ; Facility
lost_revenue = #$:(0..)                       ; Revenue loss
reserve = #$:(0..)                            ; Reserve
unit_affected = :                             ; Unit number

; ===================================================================================
; Power Generation Policy
; ===================================================================================

{@power_gen_policy}
; Required fields first
effective_date = !date                        ; Policy effective date
expiration_date = !date                       ; Policy expiration date
facilities[] = !@pg_facility                  ; Covered facilities
policy_number = !:                            ; Policy number

; Invariants
:invariant expiration_date > effective_date

; Optional fields
agency = @agency                              ; Issuing agency
claims[] = @pg_claim                          ; Claims history
environmental = @pg_environmental             ; Environmental coverage
id = :                                        ; Internal identifier
insured_name = !:                             ; Named insured
insured_address = @address                    ; Insured address
liability = @pg_liability                     ; Liability coverage
machinery = @pg_machinery                     ; Machinery breakdown
nuclear = @pg_nuclear                         ; Nuclear coverage
policy_form = (
    construction,                             ; Construction phase
    operational,                              ; Operating plant
    shutdown                                  ; Decommissioning
)
policy_status = (active, cancelled, expired, pending)
premium = @pg_premium                         ; Premium details
producer = @producer                          ; Agent
property = @pg_property                       ; Property coverage
underwriting = @underwriting_decision         ; Underwriting

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
capacity_mw = #:(0..)                         ; Total capacity
facility_count = ##                           ; Facility count
liability_limit = #$:(0..)                    ; Liability limit
nuclear = ?                                   ; Nuclear plants
property_tiv = #$:(0..)                       ; Total TIV
technology = :                                ; Primary technology

{@power_gen_policy}


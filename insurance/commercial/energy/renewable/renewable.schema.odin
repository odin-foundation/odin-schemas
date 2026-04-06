; ===================================================================================
; ODIN Renewable Energy Insurance Schema
; ===================================================================================
; Renewable energy insurance covering solar, wind, hydroelectric, geothermal,
; biomass, and energy storage operations including property, business interruption,
; mechanical breakdown, weather/resource risk, and delay in start-up.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.energy.renewable"
version = "1.0.0"
title = "Renewable Energy Insurance Schema"
description = "Insurance for solar, wind, and other renewable energy facilities"

{$derivation}
source[0].authority = "Federal Energy Regulatory Commission (FERC)"
source[0].citation = "Renewable Energy Project Requirements"
source[0].url = "https://www.ferc.gov/"

source[1].authority = "U.S. Department of Energy"
source[1].citation = "Renewable Energy Finance and Insurance Guidelines"
source[1].url = "https://www.energy.gov/"

source[2].authority = "American Wind Energy Association"
source[2].citation = "Wind Project Insurance Standards"
source[2].url = "https://www.awea.org/"

source[3].authority = "Solar Energy Industries Association"
source[3].citation = "Solar Project Risk Management Guidelines"
source[3].url = "https://www.seia.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on FERC, DOE, and industry renewable energy insurance standards"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial renewable energy insurance schema"
changelog[0].rationale = "Commercial energy coverage for renewable projects"

; ===================================================================================
; Energy Type Classification
; ===================================================================================

{@re_energy_type}
technology = !(
    battery_storage,                          ; Battery storage
    biomass,                                  ; Biomass/biogas
    fuel_cell,                                ; Fuel cell
    geothermal,                               ; Geothermal
    hydroelectric,                            ; Hydro power
    solar_csp,                                ; Concentrated solar
    solar_pv_commercial,                      ; Commercial solar PV
    solar_pv_residential,                     ; Residential solar
    solar_pv_utility,                         ; Utility-scale PV
    wind_offshore,                            ; Offshore wind
    wind_onshore                              ; Onshore wind
)

; Project phase
project_phase = (
    construction,                             ; Under construction
    commissioning,                            ; Testing/commissioning
    operational,                              ; In operation
    repowering                                ; Repowering/upgrade
)

; ===================================================================================
; Facility Details
; ===================================================================================

{@re_facility}
; Required fields first
capacity_mw = !#:(0..)                        ; Nameplate capacity MW
energy_type = !@re_energy_type                ; Technology type
facility_name = !:                            ; Facility name

; Optional fields
address = @address                            ; Location
annual_output_mwh = ##                        ; Expected annual output
capacity_factor = #:(0..100)                  ; Capacity factor %
cod_date = date                               ; Commercial operation date
construction_start = date                     ; Construction start
epc_contractor = :                            ; EPC contractor
facility_id = :                               ; Internal identifier
grid_interconnection = :                      ; Interconnection point
land_acres = #                                ; Land area
land_lease = ?                                ; Leased land
lat = #:(-90..90)                             ; Latitude
long = #:(-180..180)                          ; Longitude
manufacturer = :                              ; Equipment OEM
offtake_agreement = :                         ; PPA/offtake
owner = :                                     ; Owner/developer
project_cost = #$:(0..)                       ; Total project cost
project_life_years = ##                       ; Expected life
state = :(2)                                  ; State
tiv = #$:(0..)                                ; Total insured value
utility_interconnect = :                      ; Utility name
warranty_years = ##                           ; OEM warranty period

; ---------------------------------------------------------------------------
; Solar-Specific
; ---------------------------------------------------------------------------
{.solar}
bifacial = ?:if energy_type.technology = (solar_pv_commercial, solar_pv_utility, solar_pv_residential)
inverter_count = ##:if energy_type.technology = (solar_pv_commercial, solar_pv_utility, solar_pv_residential)
module_count = ##:if energy_type.technology = (solar_pv_commercial, solar_pv_utility, solar_pv_residential)
module_type = (monocrystalline, polycrystalline, thin_film):if energy_type.technology = (solar_pv_commercial, solar_pv_utility, solar_pv_residential)
mounting = (fixed_tilt, single_axis, dual_axis):if energy_type.technology = (solar_pv_commercial, solar_pv_utility, solar_pv_residential)
panel_wattage = ##:if energy_type.technology = (solar_pv_commercial, solar_pv_utility, solar_pv_residential)

{@re_facility}

; ---------------------------------------------------------------------------
; Wind-Specific
; ---------------------------------------------------------------------------
{.wind}
hub_height_meters = ##:if energy_type.technology = (wind_onshore, wind_offshore)
rotor_diameter_meters = ##:if energy_type.technology = (wind_onshore, wind_offshore)
turbine_count = ##:if energy_type.technology = (wind_onshore, wind_offshore)
turbine_manufacturer = ::if energy_type.technology = (wind_onshore, wind_offshore)
turbine_model = ::if energy_type.technology = (wind_onshore, wind_offshore)
turbine_rating_mw = #:if energy_type.technology = (wind_onshore, wind_offshore)
water_depth_meters = ##:if energy_type.technology = wind_offshore

{@re_facility}

; ---------------------------------------------------------------------------
; Storage-Specific
; ---------------------------------------------------------------------------
{.storage}
battery_chemistry = (lead_acid, lithium_ion, flow):if energy_type.technology = battery_storage
charge_cycles = ##:if energy_type.technology = battery_storage
duration_hours = #:if energy_type.technology = battery_storage
storage_capacity_mwh = #:if energy_type.technology = battery_storage

{@re_facility}

; ===================================================================================
; Property Coverage
; ===================================================================================

{@re_property}
; Required fields first
total_insured_value = !#$:(0..)               ; TIV

; Optional fields
all_risk = ?                                  ; All-risk coverage
business_interruption = ?                     ; BI coverage
bi_annual_revenue = #$:(0..):if business_interruption = true
bi_indemnity_months = ##:if business_interruption = true
bi_waiting_days = ##:if business_interruption = true
debris_removal = ?                            ; Debris removal
deductible = #$:(0..)                         ; Property deductible
earthquake = ?                                ; Earthquake coverage
extra_expense = ?                             ; Extra expense
flood = ?                                     ; Flood coverage
hail = ?                                      ; Hail coverage
lightning = ?                                 ; Lightning surge
mechanical_breakdown = ?                      ; MB coverage
named_storm = ?                               ; Named storm
replacement_cost = ?                          ; RC valuation
sublimits[] = :                               ; Coverage sublimits
transmission_lines = ?                        ; Transmission covered
wildfire = ?                                  ; Wildfire coverage
wind = ?                                      ; Wind coverage

; ===================================================================================
; Delay in Start-Up (DSU)
; ===================================================================================

{@re_dsu}
included = ?                                  ; DSU coverage
daily_value = #$:(0..):if included = true     ; Daily loss amount
deductible_days = ##:if included = true       ; Time deductible
defect_exclusion = ?:if included = true       ; Defect exclusion
indemnity_period_months = ##:if included = true  ; Max indemnity
limit = #$:(0..):if included = true           ; DSU limit
liquidated_damages = ?:if included = true     ; LD recovery
supplier_insolvency = ?:if included = true    ; Supplier exclusion
testing_coverage = ?:if included = true       ; Testing phase

; ===================================================================================
; Liability Coverage
; ===================================================================================

{@re_liability}
; Required fields first
general_liability = !#$:(0..)                 ; GL limit per occ

; Optional fields
aggregate = #$:(0..)                          ; Annual aggregate
auto_liability = ?                            ; Auto coverage
completed_operations = ?                      ; Completed ops
contractual = ?                               ; Contractual
deductible = #$:(0..)                         ; Liability deductible
employers_liability = ?                       ; EL coverage
environmental = ?                             ; Environmental liability
excess_umbrella = ?                           ; Excess/umbrella
excess_limit = #$:(0..):if excess_umbrella = true
products = ?                                  ; Products liability
professional = ?                              ; Professional liability

; ===================================================================================
; Performance/Resource Risk
; ===================================================================================

{@re_resource_risk}
; Resource/weather guarantee
included = ?                                  ; Resource coverage
basis = (
    irradiance,                               ; Solar irradiance
    p50,                                      ; P50 estimate
    p90,                                      ; P90 estimate
    wind_speed                                ; Wind speed
):if included = true
coverage_percentage = #:(0..100):if included = true
deductible_percentage = #:(0..25):if included = true
measurement_period = (annual, monthly, quarterly):if included = true

; Resource data
p50_estimate = #:if included = true           ; P50 output estimate
p90_estimate = #:if included = true           ; P90 output estimate
resource_assessment = ::if included = true    ; Resource study

; ===================================================================================
; Premium Details
; ===================================================================================

{@re_premium}
; Required fields first
total_premium = !#$:(0..)                     ; Total premium

; Optional fields
bi_premium = #$:(0..)                         ; BI premium
dsu_premium = #$:(0..)                        ; DSU premium
liability_premium = #$:(0..)                  ; Liability
minimum_premium = #$:(0..)                    ; Minimum premium
policy_fee = #$:(0..)                         ; Policy fee
property_premium = #$:(0..)                   ; Property premium
resource_premium = #$:(0..)                   ; Resource risk
taxes_and_fees = #$:(0..)                     ; Taxes/fees

; ===================================================================================
; Claims
; ===================================================================================

{@re_claim}
; Required fields first
claim_date = !date                            ; Claim date
claim_type = !(
    blade_damage,                             ; Wind blade
    bodily_injury,                            ; BI claim
    business_interruption,                    ; BI loss
    electrical_failure,                       ; Electrical
    equipment_failure,                        ; Equipment
    fire,                                     ; Fire
    flood,                                    ; Flood
    foundation,                               ; Foundation
    gearbox,                                  ; Gearbox failure
    hail,                                     ; Hail damage
    inverter,                                 ; Inverter failure
    lightning,                                ; Lightning
    property_damage,                          ; PD claim
    theft,                                    ; Theft
    tower_collapse,                           ; Tower failure
    wildfire,                                 ; Wildfire
    wind,                                     ; Wind damage
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
facility_reference = :                        ; Facility
lost_revenue = #$:(0..)                       ; Revenue loss
reserve = #$:(0..)                            ; Reserve

; ===================================================================================
; Renewable Energy Policy
; ===================================================================================

{@renewable_policy}
; Required fields first
effective_date = !date                        ; Policy effective date
expiration_date = !date                       ; Policy expiration date
facilities[] = !@re_facility                  ; Covered facilities
policy_number = !:                            ; Policy number

; Invariants
:invariant expiration_date > effective_date

; Optional fields
agency = @agency                              ; Issuing agency
claims[] = @re_claim                          ; Claims history
dsu = @re_dsu                                 ; DSU coverage
id = :                                        ; Internal identifier
insured_name = !:                             ; Named insured
insured_address = @address                    ; Insured address
liability = @re_liability                     ; Liability coverage
policy_form = (
    construction,                             ; Construction phase
    operational,                              ; Operating facility
    wrap_up                                   ; Project wrap-up
)
policy_status = (active, cancelled, expired, pending)
premium = @re_premium                         ; Premium details
producer = @producer                          ; Agent
property = @re_property                       ; Property coverage
resource_risk = @re_resource_risk             ; Resource coverage
underwriting = @underwriting_decision         ; Underwriting

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
capacity_mw = #:(0..)                         ; Total capacity
facility_count = ##                           ; Facility count
liability_limit = #$:(0..)                    ; Liability limit
property_tiv = #$:(0..)                       ; Total TIV
technology = :                                ; Primary technology

{@renewable_policy}


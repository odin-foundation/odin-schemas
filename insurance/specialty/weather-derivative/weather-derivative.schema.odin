; ===================================================================================
; ODIN Weather Derivative Insurance Schema
; ===================================================================================
; Weather derivative contracts providing financial protection against weather-
; related revenue losses using index-based triggers for temperature, precipitation,
; snowfall, wind, and degree day measurements.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.specialty.weather-derivative"
version = "1.0.0"
title = "Weather Derivative Insurance Schema"
description = "Parametric coverage for weather-related business impacts"

{$derivation}
source[0].authority = "Weather Risk Management Association"
source[0].citation = "Weather Derivative Standards and Documentation"
source[0].url = "https://web.archive.org/web/20201111205411/https://wrma.org/"

source[1].authority = "Chicago Mercantile Exchange"
source[1].citation = "Weather Derivative Contract Specifications"
source[1].url = "https://www.cmegroup.com/"

source[2].authority = "Insurance Services Office (ISO)"
source[2].citation = "Parametric Weather Insurance"
source[2].url = "https://www.verisk.com/"

source[3].authority = "National Weather Service"
source[3].citation = "Weather Data and Measurement Standards"
source[3].url = "https://www.weather.gov/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on WRMA and CME weather derivative standards"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial weather derivative insurance schema"
changelog[0].rationale = "Specialty coverage for parametric weather protection"

; ===================================================================================
; Insured Entity
; ===================================================================================

{@weather_insured}
; Required fields first
business_name = :                            ; Business name
industry = (
    agriculture,                              ; Agriculture/farming
    aviation,                                 ; Aviation
    construction,                             ; Construction
    energy,                                   ; Energy/utilities
    entertainment,                            ; Events/entertainment
    food_beverage,                            ; Food/beverage
    hospitality,                              ; Hospitality/tourism
    marine,                                   ; Marine/shipping
    retail,                                   ; Retail
    ski_resort,                               ; Ski/winter sports
    sports,                                   ; Sports
    transportation,                           ; Transportation
    utility                                   ; Utility company
)

; Optional fields
address = @address                            ; Business address
contact_email = *@email                       ; Contact email
contact_phone = *@phone                       ; Contact phone
fein = *:                                     ; Tax ID
insured_id = :                                ; Internal identifier
weather_exposure = :                          ; Weather exposure type
years_in_business = ##                        ; Years operating

; ===================================================================================
; Weather Index
; ===================================================================================

{@weather_index}
; Required fields first
index_type = (
    cdd,                                      ; Cooling degree days
    frost_days,                               ; Frost day count
    hdd,                                      ; Heating degree days
    precipitation,                            ; Rainfall amount
    snow_depth,                               ; Snow depth
    snowfall,                                 ; Snowfall amount
    solar_radiation,                          ; Sunshine hours
    temperature_avg,                          ; Average temperature
    temperature_high,                         ; Maximum temperature
    temperature_low,                          ; Minimum temperature
    wind_speed                                ; Wind speed
)
measurement_unit = :                         ; Unit of measure

; Index parameters
base_temperature = ##                         ; Base temp for HDD/CDD
measurement_frequency = (daily, hourly, monthly)
threshold = #                                 ; Trigger threshold

; Data source
data_source = (
    airport,                                  ; Airport weather
    noaa,                                     ; NOAA station
    private,                                  ; Private station
    satellite                                 ; Satellite data
)
weather_station = :                           ; Station identifier
station_location = @address                   ; Station location

; ===================================================================================
; Contract Terms
; ===================================================================================

{@weather_terms}
; Required fields first
contract_period_end = date                   ; Contract end
contract_period_start = date                 ; Contract start
limit = #$:(0..)                             ; Maximum payout
strike = #                                   ; Strike level
tick_size = #$:(0..)                         ; Payment per unit

; Contract structure
cap = #                                       ; Cap level
collar = ?                                    ; Collar structure
floor = #                                     ; Floor level
option_type = (call, collar, put, swap)       ; Option type

; Payout calculation
payout_calculation = (
    binary,                                   ; Binary payout
    linear,                                   ; Linear payout
    tiered                                    ; Tiered payout
)
payout_frequency = (
    at_expiry,                                ; At contract end
    daily,                                    ; Daily settlement
    monthly                                   ; Monthly settlement
)

; Invariants
:invariant contract_period_end > contract_period_start

; ===================================================================================
; Weather Coverage
; ===================================================================================

{@weather_coverage}
; Required fields first
index = @weather_index                       ; Weather index
terms = @weather_terms                       ; Contract terms

; Coverage structure
aggregate_limit = #$:(0..)                    ; Aggregate payout
deductible = #$:(0..)                         ; Deductible
franchise = #                                 ; Franchise amount
per_occurrence = #$:(0..)                     ; Per occurrence limit

; ---------------------------------------------------------------------------
; Temperature Coverage (HDD/CDD)
; ---------------------------------------------------------------------------
{.temperature}
included = ?:if index.index_type = (hdd, cdd, temperature_avg, temperature_high, temperature_low)
base_temp_f = ##:if included = true           ; Base temperature
cdd_tick = #$:(0..):if included = true        ; CDD tick value
hdd_tick = #$:(0..):if included = true        ; HDD tick value
limit = #$:(0..):if included = true           ; Temperature limit
strike_hdd = ##:if included = true            ; HDD strike
strike_cdd = ##:if included = true            ; CDD strike

{@weather_coverage}

; ---------------------------------------------------------------------------
; Precipitation Coverage
; ---------------------------------------------------------------------------
{.precipitation}
included = ?:if index.index_type = (precipitation, snowfall, snow_depth)
daily_threshold = #:if included = true        ; Daily threshold
limit = #$:(0..):if included = true           ; Precipitation limit
monthly_threshold = #:if included = true      ; Monthly threshold
rain_days = ?:if included = true              ; Rain day count
snow_threshold = #:if included = true         ; Snow threshold
strike = #:if included = true                 ; Strike level
tick_value = #$:(0..):if included = true      ; Per unit value

{@weather_coverage}

; ---------------------------------------------------------------------------
; Wind Coverage
; ---------------------------------------------------------------------------
{.wind}
included = ?:if index.index_type = wind_speed
gust_threshold = ##:if included = true        ; Gust threshold
limit = #$:(0..):if included = true           ; Wind limit
strike_mph = ##:if included = true            ; Wind strike
sustained_threshold = ##:if included = true   ; Sustained wind
tick_value = #$:(0..):if included = true      ; Per unit value

{@weather_coverage}

; ===================================================================================
; Premium Details
; ===================================================================================

{@weather_premium}
; Required fields first
total_premium = #$:(0..)                     ; Total premium

; Optional fields
broker_fee = #$:(0..)                         ; Broker fee
minimum_premium = #$:(0..)                    ; Minimum premium
policy_fee = #$:(0..)                         ; Policy fee
taxes_and_fees = #$:(0..)                     ; Taxes/fees

; Pricing model
expected_loss = #$:(0..)                      ; Expected loss
loss_ratio_target = #:(0..100)                ; Target loss ratio
model_price = #$:(0..)                        ; Model price

; ---------------------------------------------------------------------------
; Rating Factors
; ---------------------------------------------------------------------------
{.rating}
basis_risk = #                                ; Basis risk adjustment
historical_volatility = #                     ; Historical vol
limit_factor = #                              ; Limit factor
term_factor = #                               ; Contract term

{@weather_premium}

; ===================================================================================
; Settlement
; ===================================================================================

{@weather_settlement}
; Settlement terms
calculation_agent = :                         ; Calculation agent
data_backup = :                               ; Backup data source
data_provider = :                             ; Official data source
dispute_resolution = :                        ; Dispute process
settlement_date = date                        ; Settlement date
settlement_delay_days = ##                    ; Delay after period

; Calculated values
actual_index = #                              ; Actual index value
calculated_payout = #$:(0..)                  ; Calculated payout
days_measured = ##                            ; Days in period
final_index = #                               ; Final index
variance_from_strike = #                      ; Variance

; ===================================================================================
; Claims
; ===================================================================================

{@weather_claim}
; Required fields first
claim_date = date                            ; Claim date
index_type = :                               ; Index triggered

; Optional fields
actual_value = #                              ; Actual measurement
amount_claimed = #$:(0..)                     ; Amount claimed
amount_paid = #$:(0..)                        ; Amount paid
claim_id = :                                  ; Claim ID
claim_status = (
    closed,
    disputed,
    open,
    paid,
    verification
)
contract_period = :                           ; Contract period
description = :                               ; Description
measurement_period_end = date                 ; Period end
measurement_period_start = date               ; Period start
reserve = #$:(0..)                            ; Reserve amount
settlement = @weather_settlement              ; Settlement details
strike_value = #                              ; Strike level

; ===================================================================================
; Weather Derivative Policy
; ===================================================================================

{@weather_policy}
; Required fields first
coverage = @weather_coverage                 ; Coverage terms
effective_date = date                        ; Policy effective date
expiration_date = date                       ; Policy expiration date
insured = @weather_insured                   ; Insured entity
policy_number = :                            ; Policy number

; Invariants
:invariant expiration_date > effective_date

; Optional fields
agency = @agency                              ; Issuing agency
claims[] = @weather_claim                     ; Claims history
endorsements[] = :                            ; Policy endorsements
id = :                                        ; Internal identifier
policy_form = (
    cat_bond,                                 ; Catastrophe bond
    derivative,                               ; Weather derivative
    parametric                                ; Parametric insurance
)
policy_status = (
    active,
    cancelled,
    expired,
    pending,
    settled
)
premium = @weather_premium                    ; Premium details
producer = @producer                          ; Agent
underwriting = @underwriting_decision         ; Underwriting

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
index_type = :                                ; Weather index
insured_name = :                              ; Insured name
limit = #$:(0..)                              ; Maximum payout
period = :                                    ; Coverage period
strike = #                                    ; Strike level

{@weather_policy}


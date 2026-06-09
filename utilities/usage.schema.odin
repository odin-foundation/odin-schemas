; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Utilities/Energy - Usage Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Customer energy and water usage data including electric (kWh, kW demand),
; gas (therms, CCF), water (gallons), interval data, time-of-use periods,
; and peak demand tracking.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.utilities.usage"
version = "1.0.0"
title = "Utility Usage Data"
description = "Energy and water usage schema for electric, gas, and water utilities"

{$derivation}
source[0].authority = "North American Energy Standards Board"
source[0].citation = "NAESB WEQ-015 Usage Data Exchange"
source[0].url = "https://www.naesb.org/"
source[0].accessed = 2025-12-21

source[1].authority = "U.S. Department of Energy"
source[1].citation = "Green Button Standard - Energy Usage Information"
source[1].url = "https://www.energy.gov/data/green-button"
source[1].accessed = 2025-12-21

source[2].authority = "Federal Energy Regulatory Commission"
source[2].citation = "18 CFR Part 35.47 - Open Access Same-Time Information System"
source[2].url = "https://www.ecfr.gov/current/title-18/chapter-I/subchapter-B/part-35"
source[2].accessed = 2025-12-21

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial utilities usage schema"
changelog[0].rationale = "Standard usage data structures per NAESB, Green Button, and FERC requirements"

; ═══════════════════════════════════════════════════════════════════════════════
; ELECTRIC USAGE
; ═══════════════════════════════════════════════════════════════════════════════

{@electric_usage}
= @types.audit_info

; Required fields first
account_number = *:                                ; Account identifier
meter_number = :                                  ; Meter identifier
start_date = date                                 ; Usage period start
end_date = date                                   ; Usage period end

; Consumption
consumption_kwh = #:(0..)                          ; Total kWh consumed
billing_days = ##:(1..)                            ; Number of days in period
average_daily_kwh = #:(0..)                        ; Average daily consumption

; Demand (commercial/industrial)
demand_kw = #:(0..)                                ; Billing demand in kW
demand_date = date                                 ; Date of peak demand
demand_time = time                                 ; Time of peak demand
contract_demand_kw = #:(0..)                       ; Contracted demand level
demand_ratchet_kw = #:(0..)                        ; Ratcheted demand amount

; Reactive power
reactive_kvar = #                                  ; Reactive power
reactive_kvarh = #:(0..)                           ; Reactive energy
power_factor = #:(-1..1)                           ; Power factor

; Time-of-use breakdowns
{.tou}
on_peak_kwh = #:(0..)                              ; On-peak consumption
mid_peak_kwh = #:(0..)                             ; Mid-peak consumption
off_peak_kwh = #:(0..)                             ; Off-peak consumption
super_off_peak_kwh = #:(0..)                       ; Super off-peak consumption
on_peak_demand_kw = #:(0..)                        ; On-peak demand
mid_peak_demand_kw = #:(0..)                       ; Mid-peak demand

{@electric_usage}
; Seasonal periods
season = (shoulder, summer, winter)                ; Rate season
critical_peak_days = ##:(0..)                      ; Number of critical peak days
critical_peak_kwh = #:(0..)                        ; Critical peak consumption

; Usage characteristics
load_factor = #:(0..100)                           ; Load factor percentage
diversity_factor = #:(0..)                         ; Diversity factor
coincident_peak_kw = #:(0..)                       ; System coincident peak contribution

; Comparisons
prior_year_kwh = #:(0..)                           ; Same period last year
percent_change = #:(-100..1000)                    ; Percent change from prior year
weather_normalized_kwh = #:(0..)                   ; Weather-adjusted usage
degree_days_heating = #:(0..)                      ; Heating degree days
degree_days_cooling = #:(0..)                      ; Cooling degree days

; Generation (if net metering)
generation_kwh = #:(0..)                           ; Customer generation
net_kwh = #                                        ; Net consumption (can be negative)
excess_generation_kwh = #:(0..)                    ; Excess sent to grid

{@electric_usage}

; ═══════════════════════════════════════════════════════════════════════════════
; GAS USAGE
; ═══════════════════════════════════════════════════════════════════════════════

{@gas_usage}
= @types.audit_info

; Required fields first
account_number = *:                                ; Account identifier
meter_number = :                                  ; Meter identifier
start_date = date                                 ; Usage period start
end_date = date                                   ; Usage period end

; Consumption
consumption_therms = #:(0..)                       ; Consumption in therms
consumption_ccf = #:(0..)                          ; Consumption in CCF (hundred cubic feet)
consumption_mcf = #:(0..)                          ; Consumption in MCF (thousand cubic feet)
consumption_btu = #:(0..)                          ; Consumption in BTU
billing_days = ##:(1..)                            ; Number of days in period
average_daily_therms = #:(0..)                     ; Average daily consumption

; Volume measurements
measured_volume = #:(0..)                          ; Measured volume (uncorrected)
billing_volume = #:(0..)                           ; Billing volume (corrected)
temperature_avg_f = #:(-50..150)                   ; Average temperature
pressure_avg_psig = #:(0..)                        ; Average pressure
correction_factor = #:(0..)                        ; Applied correction factor
heating_value_btu = #:(0..)                        ; BTU content per unit

; Seasonal data
season = (shoulder, summer, winter)                ; Rate season
degree_days_heating = #:(0..)                      ; Heating degree days

; Comparisons
prior_year_therms = #:(0..)                        ; Same period last year
percent_change = #:(-100..1000)                    ; Percent change from prior year
weather_normalized_therms = #:(0..)                ; Weather-adjusted usage

; Transport customers (unbundled)
commodity_supplier = :                             ; Gas supplier name
transportation_only = ?                            ; Transportation service only flag

{@gas_usage}

; ═══════════════════════════════════════════════════════════════════════════════
; WATER USAGE
; ═══════════════════════════════════════════════════════════════════════════════

{@water_usage}
= @types.audit_info

; Required fields first
account_number = *:                                ; Account identifier
meter_number = :                                  ; Meter identifier
start_date = date                                 ; Usage period start
end_date = date                                   ; Usage period end

; Consumption
consumption_gallons = #:(0..)                      ; Consumption in gallons
consumption_ccf = #:(0..)                          ; Consumption in CCF
consumption_cubic_meters = #:(0..)                 ; Consumption in cubic meters
billing_days = ##:(1..)                            ; Number of days in period
average_daily_gallons = #:(0..)                    ; Average daily consumption

; Tier usage (tiered rate structures)
{.tiers}
tier_1_gallons = #:(0..)                           ; Tier 1 usage
tier_2_gallons = #:(0..)                           ; Tier 2 usage
tier_3_gallons = #:(0..)                           ; Tier 3 usage
tier_4_gallons = #:(0..)                           ; Tier 4 usage

{@water_usage}
; Usage type breakdown
indoor_gallons = #:(0..)                           ; Estimated indoor use
outdoor_gallons = #:(0..)                          ; Estimated outdoor use
irrigation_gallons = #:(0..)                       ; Irrigation usage

; Seasonal data
season = (shoulder, summer, winter)                ; Rate season

; Comparisons
prior_year_gallons = #:(0..)                       ; Same period last year
percent_change = #:(-100..1000)                    ; Percent change from prior year
baseline_gallons = #:(0..)                         ; Baseline/budget allocation

; Wastewater
wastewater_gallons = #:(0..)                       ; Wastewater volume (may differ)
wastewater_billed_gallons = #:(0..)                ; Billed wastewater volume

; Leak detection
high_usage_alert = ?                               ; High usage flag
continuous_flow_detected = ?                       ; Continuous flow indicator
leak_suspected = ?                                 ; Possible leak

{@water_usage}

; ═══════════════════════════════════════════════════════════════════════════════
; INTERVAL USAGE
; ═══════════════════════════════════════════════════════════════════════════════

{@interval_usage}
= @types.audit_info

; Required fields first
account_number = *:                                ; Account identifier
meter_number = :                                  ; Meter identifier
commodity = (electric, gas, water)                ; Commodity type
interval_minutes = ##:(1..)                       ; Interval length (15, 30, 60, etc.)

; Interval data points
{.intervals[]}
start_timestamp = timestamp                       ; Interval start
end_timestamp = timestamp                         ; Interval end
consumption = #:(0..)                              ; Consumption for interval
demand = #:(0..)                                   ; Demand for interval (electric)
uom = (ccf, gallons, kva, kvar, kvah, kvarh, kw, kwh, mcf, therms)
quality = (actual, estimated, missing, verified)   ; Data quality
quality_code = :                                   ; Quality code
estimated_method = :                               ; Estimation method if estimated

{@interval_usage}
; Period summary
total_consumption = #:(0..)                        ; Total for all intervals
peak_interval_demand = #:(0..)                     ; Peak interval demand
peak_interval_timestamp = timestamp                ; When peak occurred
total_intervals = ##:(1..)                         ; Number of intervals
missing_intervals = ##:(0..)                       ; Number missing
estimated_intervals = ##:(0..)                     ; Number estimated

{@interval_usage}

; ═══════════════════════════════════════════════════════════════════════════════
; DAILY USAGE
; ═══════════════════════════════════════════════════════════════════════════════

{@daily_usage}
= @types.audit_info

; Required fields first
account_number = *:                                ; Account identifier
meter_number = :                                  ; Meter identifier
commodity = (electric, gas, water)                ; Commodity type
usage_date = date                                 ; Usage date

; Consumption
consumption = #:(0..)                              ; Daily consumption
uom = (ccf, gallons, kwh, mcf, therms)            ; Unit of measure
demand = #:(0..)                                   ; Peak demand (electric)
demand_time = time                                 ; Time of peak (electric)

; Weather
temperature_high_f = #:(-50..150)                  ; High temperature
temperature_low_f = #:(-50..150)                   ; Low temperature
temperature_avg_f = #:(-50..150)                   ; Average temperature
heating_degree_days = #:(0..)                      ; Heating degree days
cooling_degree_days = #:(0..)                      ; Cooling degree days

; Day type
day_of_week = (friday, monday, saturday, sunday, thursday, tuesday, wednesday)
holiday = ?                                        ; Holiday indicator
weekend = ?                                        ; Weekend indicator

; Comparisons
prior_year_consumption = #:(0..)                   ; Same day last year
prior_day_consumption = #:(0..)                    ; Previous day

{@daily_usage}

; ═══════════════════════════════════════════════════════════════════════════════
; MONTHLY USAGE
; ═══════════════════════════════════════════════════════════════════════════════

{@monthly_usage}
= @types.audit_info

; Required fields first
account_number = *:                                ; Account identifier
meter_number = :                                  ; Meter identifier
commodity = (electric, gas, water)                ; Commodity type
year = ##:(2000..)                                ; Year
month = ##:(1..12)                                ; Month

; Consumption
consumption = #:(0..)                              ; Monthly consumption
uom = (ccf, gallons, kwh, mcf, therms)            ; Unit of measure
billing_days = ##:(1..)                            ; Number of days
average_daily = #:(0..)                            ; Average daily consumption

; Demand (electric)
demand = #:(0..)                                   ; Peak demand
demand_date = date                                 ; Date of peak
demand_time = time                                 ; Time of peak

; Weather
degree_days_heating = #:(0..)                      ; Heating degree days
degree_days_cooling = #:(0..)                      ; Cooling degree days
temperature_avg_f = #:(-50..150)                   ; Average temperature

; Comparisons
prior_year_consumption = #:(0..)                   ; Same month last year
percent_change = #:(-100..1000)                    ; Percent change
twelve_month_average = #:(0..)                     ; Rolling 12-month average
twelve_month_total = #:(0..)                       ; Rolling 12-month total

; Cost
total_charges = #$                                 ; Total charges for month
average_rate = #$:(0..)                            ; Average rate per unit

{@monthly_usage}

; ═══════════════════════════════════════════════════════════════════════════════
; ANNUAL USAGE
; ═══════════════════════════════════════════════════════════════════════════════

{@annual_usage}
= @types.audit_info

; Required fields first
account_number = *:                                ; Account identifier
meter_number = :                                  ; Meter identifier
commodity = (electric, gas, water)                ; Commodity type
year = ##:(2000..)                                ; Calendar or fiscal year

; Consumption
consumption = #:(0..)                              ; Annual consumption
uom = (ccf, gallons, kwh, mcf, therms)            ; Unit of measure
billing_days = ##:(1..)                            ; Total days
average_daily = #:(0..)                            ; Average daily consumption
average_monthly = #:(0..)                          ; Average monthly consumption

; Demand (electric)
annual_peak_demand = #:(0..)                       ; Highest demand
annual_peak_date = date                            ; Date of annual peak
annual_peak_time = time                            ; Time of annual peak
coincident_peak = #:(0..)                          ; System coincident peak contribution

; Seasonal breakdown
summer_consumption = #:(0..)                       ; Summer season total
winter_consumption = #:(0..)                       ; Winter season total
shoulder_consumption = #:(0..)                     ; Shoulder season total

; Comparisons
prior_year_consumption = #:(0..)                   ; Prior year total
percent_change = #:(-100..1000)                    ; Year-over-year change

; Cost
total_charges = #$                                 ; Total annual charges
average_rate = #$:(0..)                            ; Average rate per unit
average_monthly_bill = #$                          ; Average monthly bill

{@annual_usage}

; ═══════════════════════════════════════════════════════════════════════════════
; USAGE BENCHMARK
; ═══════════════════════════════════════════════════════════════════════════════

{@usage_benchmark}
= @types.audit_info

; Required fields first
account_number = *:                                ; Account identifier
commodity = (electric, gas, water)                ; Commodity type
benchmark_period = :                              ; Period description

; Actual usage
actual_consumption = #:(0..)                      ; Actual usage
uom = (ccf, gallons, kwh, mcf, therms)            ; Unit of measure

; Benchmarks
efficient_neighbors_avg = #:(0..)                  ; Efficient neighbors average
all_neighbors_avg = #:(0..)                        ; All neighbors average
regional_avg = #:(0..)                             ; Regional average
national_avg = #:(0..)                             ; National average

; Efficiency metrics
percentile = ##:(0..100)                           ; Usage percentile
efficiency_score = ##:(0..100)                     ; Efficiency score
savings_opportunity = #:(0..)                      ; Potential savings vs efficient

; Normalization factors
square_footage = ##:(0..)                          ; Building square footage
occupants = ##:(1..)                               ; Number of occupants
usage_per_sqft = #:(0..)                           ; Usage per square foot
usage_per_occupant = #:(0..)                       ; Usage per occupant

{@usage_benchmark}

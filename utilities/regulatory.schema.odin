; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Utilities/Energy - Regulatory Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Regulatory compliance for utilities including tariffs, rate cases, FERC/PUC
; reporting, EIA forms, NERC reliability, environmental compliance, and
; service quality metrics (SAIDI, SAIFI, CAIDI).
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.utilities.regulatory"
version = "1.0.0"
title = "Utility Regulatory Compliance"
description = "Regulatory filing, tariff, and compliance schema for electric, gas, and water utilities"

{$derivation}
source[0].authority = "Federal Energy Regulatory Commission"
source[0].citation = "18 CFR Chapter I - FERC Regulations"
source[0].url = "https://www.ecfr.gov/current/title-18/chapter-I"
source[0].accessed = 2025-12-21

source[1].authority = "U.S. Energy Information Administration"
source[1].citation = "EIA Forms 861, 923 - Electric Power Data"
source[1].url = "https://www.eia.gov/electricity/data/eia861/"
source[1].accessed = 2025-12-21

source[2].authority = "North American Electric Reliability Corporation"
source[2].citation = "NERC Reliability Standards"
source[2].url = "https://www.nerc.com/pa/Stand/Pages/ReliabilityStandards.aspx"
source[2].accessed = 2025-12-21

source[3].authority = "National Association of Regulatory Utility Commissioners"
source[3].citation = "NARUC Accounting and Reporting Standards"
source[3].url = "https://www.naruc.org/"
source[3].accessed = 2025-12-21

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial utilities regulatory schema"
changelog[0].rationale = "Standard regulatory structures per FERC, EIA, NERC, and NARUC requirements"

; ═══════════════════════════════════════════════════════════════════════════════
; TARIFF
; ═══════════════════════════════════════════════════════════════════════════════

{@tariff}
= @types.audit_info

; Required fields first
tariff_number = :                                 ; Tariff identifier
tariff_name = :                                   ; Tariff name
commodity = (electric, gas, water)                ; Commodity type
jurisdiction = (federal, municipal, state)        ; Regulatory jurisdiction
status = (active, approved, draft, pending, superseded)

; Filing information
filed_date = date                                  ; Filing date
effective_date = date                              ; Effective date
approval_date = date                               ; Approval date
approved_by = :                                    ; Regulatory body
docket_number = :                                  ; Docket/case number

; Service territory
state_province = :(2)                              ; State/province
service_territory = :                              ; Territory description
utility_name = :                                   ; Utility company name
utility_id = :                                     ; Utility identifier

; Rate schedules
{.rate_schedules[]}
schedule_code = :                                 ; Schedule identifier
schedule_name = :                                  ; Schedule name
customer_class = (commercial, government, industrial, residential)
description = :                                    ; Description
effective_date = date                              ; Schedule effective date

{@tariff}
; Terms and conditions
{.terms[]}
section = :                                       ; Section number
title = :                                         ; Section title
content = :                                        ; Terms text
effective_date = date                              ; Effective date

{@tariff}
; Riders and surcharges
{.riders[]}
rider_code = :                                    ; Rider identifier
rider_name = :                                     ; Rider description
type = (adjustment, fuel, recovery, surcharge)     ; Rider type
rate = #$                                          ; Rate or percentage
effective_date = date                              ; Effective date
expiration_date = date                             ; Expiration if applicable

{@tariff}
; Revisions
{.revisions[]}
revision_number = ##:(1..)                        ; Revision number
revision_date = date                              ; Revision date
description = :                                   ; What changed
approved_date = date                               ; Approval date
supersedes_revision = ##                           ; Prior revision number

{@tariff}

; ═══════════════════════════════════════════════════════════════════════════════
; RATE CASE
; ═══════════════════════════════════════════════════════════════════════════════

{@rate_case}
= @types.audit_info

; Required fields first
case_number = :                                   ; Case/docket number
case_name = :                                     ; Case title
utility_name = :                                  ; Utility filing
jurisdiction = (federal, state)                   ; Jurisdiction
status = (approved, denied, pending, settled, withdrawn)

; Filing details
filed_date = date                                 ; Filing date
filing_type = (decrease, general, increase, merger, new_service)
commodity = (electric, gas, water)                ; Commodity

; Regulatory body
commission = :                                     ; Commission name
presiding_officer = :                              ; ALJ or commissioner

; Rate request
{.rate_request}
requested_revenue_increase = #$                    ; Requested increase
requested_percentage_increase = #:(0..)            ; Percentage increase
test_year = ##:(2000..)                            ; Test year
test_year_type = (actual, forecasted, historical) ; Test year type

{@rate_case}
; Revenue requirement
{.revenue_requirement}
operating_expenses = #$                            ; Operating expenses
depreciation = #$:(0..)                            ; Depreciation expense
taxes = #$                                         ; Tax expenses
rate_base = #$:(0..)                               ; Rate base
allowed_return = #:(0..100)                        ; Allowed ROE %
return_amount = #$:(0..)                           ; Return on equity

{@rate_case}
; Testimony and evidence
{.testimony[]}
witness_name = :                                  ; Witness name
witness_type = (company, expert, intervenor)       ; Witness type
filed_date = date                                  ; Testimony filed
topic = :                                          ; Testimony topic

{@rate_case}
; Hearings
{.hearings[]}
hearing_date = date                               ; Hearing date
hearing_type = (evidentiary, procedural, public, technical)
location = :                                       ; Hearing location
presiding_officer = :                              ; Who presided

{@rate_case}
; Intervenors
{.intervenors[]}
intervenor_name = :                               ; Intervenor name
intervenor_type = (advocacy, commercial, consumer, government, industrial)
intervention_date = date                           ; Intervention date
position = :                                       ; Position on case

{@rate_case}
; Decision
decision_date = date                               ; Decision date
{.decision}
approved_revenue_increase = #$                     ; Approved increase
approved_percentage_increase = #:(0..)             ; Approved percentage
allowed_roe = #:(0..100)                           ; Allowed return on equity
effective_date = date                              ; Effective date
implementation_date = date                         ; Implementation date
conditions = :                                     ; Conditions imposed

{@rate_case}
; Appeal
appeal_filed = ?                                   ; Appeal filed flag
appeal_date = date                                 ; Appeal filing date
appeal_court = :                                   ; Court name
appeal_status = (dismissed, pending, remanded, upheld)

{@rate_case}

; ═══════════════════════════════════════════════════════════════════════════════
; EIA FORM 861 - ELECTRIC UTILITY DATA
; ═══════════════════════════════════════════════════════════════════════════════

{@eia_form_861}
; Required fields first
reporting_year = ##:(2000..)                      ; Reporting year
utility_name = :                                  ; Utility name
utility_id = ##                                   ; EIA utility ID
respondent_type = (cooperative, iou, municipal, political_subdivision, retail_power_marketer)

; Sales and revenue
{.sales_revenue}
; By customer class
residential_customers = ##:(0..)                   ; Residential customer count
residential_sales_mwh = #:(0..)                    ; Residential sales MWh
residential_revenue = #$:(0..)                     ; Residential revenue
commercial_customers = ##:(0..)                    ; Commercial customer count
commercial_sales_mwh = #:(0..)                     ; Commercial sales MWh
commercial_revenue = #$:(0..)                      ; Commercial revenue
industrial_customers = ##:(0..)                    ; Industrial customer count
industrial_sales_mwh = #:(0..)                     ; Industrial sales MWh
industrial_revenue = #$:(0..)                      ; Industrial revenue
transportation_customers = ##:(0..)                ; Transportation customers
transportation_sales_mwh = #:(0..)                 ; Transportation sales MWh
transportation_revenue = #$:(0..)                  ; Transportation revenue

{@eia_form_861}
; Net metering
{.net_metering}
customers_net_metering = ##:(0..)                  ; Net metering customers
capacity_net_metering_mw = #:(0..)                 ; NEM capacity MW
generation_net_metering_mwh = #:(0..)              ; NEM generation MWh

{@eia_form_861}
; Demand response
{.demand_response}
customers_enrolled = ##:(0..)                      ; DR customers enrolled
potential_peak_reduction_mw = #:(0..)              ; Potential reduction MW
actual_peak_reduction_mw = #:(0..)                 ; Actual reduction MW
incentive_payments = #$:(0..)                      ; DR incentive payments

{@eia_form_861}
; Energy efficiency
{.energy_efficiency}
incremental_savings_mwh = #:(0..)                  ; Annual savings MWh
incremental_peak_reduction_mw = #:(0..)            ; Peak reduction MW
program_costs = #$:(0..)                           ; Program costs
incentive_payments = #$:(0..)                      ; Customer incentives

{@eia_form_861}
; Reliability
{.reliability}
saidi_with_meds = #:(0..)                          ; SAIDI with major events
saidi_without_meds = #:(0..)                       ; SAIDI without major events
saifi_with_meds = #:(0..)                          ; SAIFI with major events
saifi_without_meds = #:(0..)                       ; SAIFI without major events
caidi_with_meds = #:(0..)                          ; CAIDI with major events
caidi_without_meds = #:(0..)                       ; CAIDI without major events
customers_monitored = ##:(0..)                     ; Customers in sample

{@eia_form_861}

; ═══════════════════════════════════════════════════════════════════════════════
; EIA FORM 923 - POWER PLANT OPERATIONS
; ═══════════════════════════════════════════════════════════════════════════════

{@eia_form_923}
; Required fields first
reporting_year = ##:(2000..)                      ; Reporting year
plant_name = :                                    ; Plant name
plant_id = ##                                     ; EIA plant ID
operator_name = :                                  ; Operating company
operator_id = ##                                   ; EIA operator ID

; Generation
{.generation}
net_generation_mwh = #:(0..)                       ; Net generation MWh
gross_generation_mwh = #:(0..)                     ; Gross generation MWh
station_use_mwh = #:(0..)                          ; Station use MWh

{@eia_form_923}
; Fuel consumption
{.fuel[]}
fuel_type = (coal, gas, nuclear, oil, other, solar, wind)
quantity = #:(0..)                                 ; Quantity consumed
quantity_uom = (barrels, mmbtu, short_tons)        ; Unit of measure
cost = #$:(0..)                                    ; Fuel cost
delivered_cost_per_mmbtu = #$:(0..)                ; Cost per MMBtu

{@eia_form_923}
; Environmental
{.emissions}
co2_short_tons = #:(0..)                           ; CO2 emissions
nox_short_tons = #:(0..)                           ; NOx emissions
so2_short_tons = #:(0..)                           ; SO2 emissions
mercury_pounds = #:(0..)                           ; Mercury emissions

{@eia_form_923}

; ═══════════════════════════════════════════════════════════════════════════════
; NERC RELIABILITY METRICS
; ═══════════════════════════════════════════════════════════════════════════════

{@reliability_metrics}
; Required fields first
utility_name = :                                  ; Utility name
reporting_year = ##:(2000..)                      ; Reporting year
reporting_month = ##:(1..12)                       ; Reporting month if monthly

; SAIDI - System Average Interruption Duration Index
saidi_minutes = #:(0..)                            ; SAIDI in minutes
saidi_with_meds = #:(0..)                          ; SAIDI with major events
saidi_without_meds = #:(0..)                       ; SAIDI without major events
saidi_ieee_definition = ?                          ; IEEE standard definition used

; SAIFI - System Average Interruption Frequency Index
saifi_interruptions = #:(0..)                      ; SAIFI count
saifi_with_meds = #:(0..)                          ; SAIFI with major events
saifi_without_meds = #:(0..)                       ; SAIFI without major events

; CAIDI - Customer Average Interruption Duration Index
caidi_minutes = #:(0..)                            ; CAIDI in minutes
caidi_with_meds = #:(0..)                          ; CAIDI with major events
caidi_without_meds = #:(0..)                       ; CAIDI without major events

; MAIFI - Momentary Average Interruption Frequency Index
maifi_interruptions = #:(0..)                      ; MAIFI count

; Customer metrics
customers_monitored = ##:(1..)                    ; Customers in sample
total_customers = ##:(1..)                         ; Total customer count
customer_interruptions = ##:(0..)                  ; Total interruptions
customer_minutes_interrupted = #:(0..)             ; Total minutes

; Major event days
major_event_days = ##:(0..)                        ; Count of MEDs
med_threshold_minutes = #:(0..)                    ; MED threshold

{@reliability_metrics}

; ═══════════════════════════════════════════════════════════════════════════════
; SERVICE QUALITY METRICS
; ═══════════════════════════════════════════════════════════════════════════════

{@service_quality}
; Required fields first
utility_name = :                                  ; Utility name
reporting_period = :                              ; Period description
period_start = date                               ; Period start
period_end = date                                 ; Period end

; Customer service
{.customer_service}
average_call_answer_time_seconds = #:(0..)         ; Call answer time
calls_answered_30_seconds_percent = #:(0..100)     ; 30-second answer %
abandoned_call_rate_percent = #:(0..100)           ; Abandoned calls %
call_center_availability_percent = #:(0..100)      ; Availability %

{@service_quality}
; Appointments
{.appointments}
appointments_kept_percent = #:(0..100)             ; Appointments kept %
appointments_cancelled_by_utility = ##:(0..)       ; Utility cancellations
appointments_missed = ##:(0..)                     ; Missed appointments

{@service_quality}
; Service connections
{.connections}
average_days_to_connect = #:(0..)                  ; Average connection time
connections_on_time_percent = #:(0..100)           ; On-time %
connections_delayed = ##:(0..)                     ; Delayed connections

{@service_quality}
; Billing accuracy
{.billing}
billing_accuracy_percent = #:(0..100)              ; Accuracy %
billing_complaints = ##:(0..)                      ; Billing complaint count
billing_adjustments = ##:(0..)                     ; Adjustments made
high_bill_complaints = ##:(0..)                    ; High bill complaints

{@service_quality}
; Customer satisfaction
{.satisfaction}
overall_satisfaction_score = #:(0..100)            ; Overall score
recommend_utility_percent = #:(0..100)             ; Would recommend %
survey_response_count = ##:(0..)                   ; Survey responses

{@service_quality}

; ═══════════════════════════════════════════════════════════════════════════════
; AFFILIATE TRANSACTION
; ═══════════════════════════════════════════════════════════════════════════════

{@affiliate_transaction}
; Required fields first
transaction_id = :                                ; Transaction identifier
transaction_date = date                           ; Transaction date
utility_name = :                                  ; Reporting utility
affiliate_name = :                                ; Affiliate entity
transaction_type = (expense, purchase, revenue, sale, service)

; Transaction details
description = :                                   ; Description
amount = #$                                       ; Transaction amount
service_category = :                               ; Service category
ferc_account = :                                   ; FERC account code

; Pricing
pricing_method = (cost_based, market_based, tariff)
market_rate = #$                                   ; Market rate if applicable
cost_basis = #$                                    ; Cost basis
allocation_method = :                              ; Allocation methodology

; Approval
approved_by_commission = ?                         ; Commission approved
approval_date = date                               ; Approval date
docket_number = :                                  ; Docket reference

; Reporting
reporting_year = ##:(2000..)                       ; Reporting year
reporting_quarter = ##:(1..4)                      ; Quarter
ferc_form = (ferc_1, ferc_2, ferc_3)               ; FERC form

{@affiliate_transaction}

; ═══════════════════════════════════════════════════════════════════════════════
; ENVIRONMENTAL COMPLIANCE
; ═══════════════════════════════════════════════════════════════════════════════

{@environmental_compliance}
; Required fields first
facility_name = :                                 ; Facility name
facility_id = :                                    ; Facility identifier
reporting_year = ##:(2000..)                      ; Reporting year
compliance_program = (clean_air_act, clean_water_act, rcra, renewable_portfolio, state_program)

; Emissions reporting
{.emissions}
co2_metric_tons = #:(0..)                          ; CO2 emissions
co2_intensity = #:(0..)                            ; CO2 per MWh
nox_tons = #:(0..)                                 ; NOx emissions
so2_tons = #:(0..)                                 ; SO2 emissions
mercury_pounds = #:(0..)                           ; Mercury emissions
particulate_matter_tons = #:(0..)                  ; PM emissions

{@environmental_compliance}
; Renewable portfolio standard
{.rps}
renewable_target_percent = #:(0..100)              ; RPS target %
renewable_generation_mwh = #:(0..)                 ; Renewable generation
total_generation_mwh = #:(0..)                     ; Total generation
renewable_percent_actual = #:(0..100)              ; Actual renewable %
recs_purchased = ##:(0..)                          ; RECs purchased
recs_retired = ##:(0..)                            ; RECs retired
compliance_status = (compliant, deficient, surplus)

{@environmental_compliance}
; Water usage
{.water}
water_withdrawals_mgd = #:(0..)                    ; Withdrawals (million gallons/day)
water_consumption_mgd = #:(0..)                    ; Consumption
water_discharge_mgd = #:(0..)                      ; Discharge
discharge_temperature_f = #:(32..212)              ; Discharge temperature

{@environmental_compliance}
; Waste management
{.waste}
coal_ash_tons = #:(0..)                            ; Coal ash generated
hazardous_waste_tons = #:(0..)                     ; Hazardous waste
recycled_tons = #:(0..)                            ; Materials recycled

{@environmental_compliance}
; Compliance status
compliance_status = (compliant, non_compliant, pending)
violations = ##:(0..)                              ; Violation count
penalties_assessed = #$:(0..)                      ; Penalties assessed
remediation_costs = #$:(0..)                       ; Remediation costs

{@environmental_compliance}

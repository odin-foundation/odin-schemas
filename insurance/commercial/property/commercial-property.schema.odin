; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Commercial Property Insurance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Commercial property insurance based on ISO CP coverage forms including building
; and personal property (CP 00 10), business income (CP 00 30), and causes of
; loss forms (basic, broad, special, earthquake, flood).
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../coverages/coverage.schema.odin" as cov
@import "../../coverages/lines/property.schema.odin" as property
@import "../../common/types.schema.odin" as com
@import "../business.schema.odin" as entity
@import "../business-location.schema.odin" as location

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.property.commercial-property"
version = "2.0.0"
title = "Commercial Property Insurance Schema"
description = "Comprehensive commercial property coverage extending universal coverage primitive"

{$derivation}
source[0].authority = "Federal Emergency Management Agency"
source[0].citation = "National Flood Insurance Program"
source[0].url = "https://www.fema.gov/flood-insurance"

source[1].authority = "Texas Department of Insurance"
source[1].citation = "Commercial Property Insurance Rate Filing Guidelines"
source[1].url = "https://www.tdi.texas.gov/commercial/index.html"

source[2].authority = "California Department of Insurance"
source[2].citation = "Commercial Property Insurance Regulations"
source[2].url = "https://www.insurance.ca.gov/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Commercial property schema extending universal coverage primitive"

changelog[0].date = 2025-12-14
changelog[0].change = "Refactored to extend universal coverage primitive"
changelog[0].rationale = "Coverage-centric architecture - extend @property_coverage from coverage/lines/property.schema.odin"

changelog[1].date = 2025-12-13
changelog[1].change = "Initial commercial property schema"
changelog[1].rationale = "Comprehensive property coverage structure"

; ═══════════════════════════════════════════════════════════════════════════════
; CP Commercial Building Coverage (Extends @building_coverage from property line)
; ═══════════════════════════════════════════════════════════════════════════════
; Inherits from @building_coverage which inherits from @property_coverage <- @coverage

{@cp_commercial_building}
= @building_coverage                              ; Inherit from property line extension

building_id = :                                   ; Unique identifier for the building
building_number = ##                              ; Building number within the location
location_number = ##                              ; Location number for the property

; ───────────────────────────────────────────────────────────────────────────────
; Building Identification
; ───────────────────────────────────────────────────────────────────────────────
building_description = :                          ; Description of the building
address = @address                                ; Physical address of the building

; ───────────────────────────────────────────────────────────────────────────────
; Building Details (Extends Location Data)
; ───────────────────────────────────────────────────────────────────────────────
; Refer to @location.business_location for full construction details
location_reference = @location.business_location  ; Reference to full business location details

; ───────────────────────────────────────────────────────────────────────────────
; Covered Property - Building
; ───────────────────────────────────────────────────────────────────────────────
{.building_coverage}
included = ?                                      ; Whether building coverage is included
limit = #$:if building_coverage.included = true   ; Coverage limit for the building
coinsurance = ##:(0, 80, 90, 100):if building_coverage.included = true  ; Coinsurance percentage requirement
valuation = (
    actual_cash_value,
    agreed_value,
    functional_replacement,
    replacement_cost,
    selling_price
):if building_coverage.included = true           ; Valuation method for building coverage
deductible = ##:if building_coverage.included = true  ; Deductible amount for building coverage

; Agreed Value (requires Statement of Values)
agreed_value = ?:if building_coverage.included = true  ; Whether agreed value option is selected
agreed_value_amount = #$:if building_coverage.agreed_value = true  ; Agreed value amount
agreed_value_expiration = date:if building_coverage.agreed_value = true  ; Expiration date of agreed value

; Inflation Guard
inflation_guard = ?:if building_coverage.included = true  ; Whether inflation guard is included
inflation_percentage = ##:(0..25):if building_coverage.inflation_guard = true  ; Annual inflation percentage increase

{@cp_commercial_building}

; ───────────────────────────────────────────────────────────────────────────────
; Covered Property - Business Personal Property (BPP)
; ───────────────────────────────────────────────────────────────────────────────
{.bpp_coverage}
included = ?                                      ; Whether business personal property coverage is included
limit = #$:if bpp_coverage.included = true        ; Coverage limit for business personal property
coinsurance = ##:(0, 80, 90, 100):if bpp_coverage.included = true  ; Coinsurance percentage requirement
valuation = (
    actual_cash_value,
    replacement_cost,
    selling_price
):if bpp_coverage.included = true                 ; Valuation method for BPP
deductible = ##:if bpp_coverage.included = true   ; Deductible amount for BPP coverage

; Peak Season
peak_season = ?:if bpp_coverage.included = true   ; Whether peak season coverage is included
peak_season_limit = #$:if bpp_coverage.peak_season = true  ; Additional limit during peak season
peak_season_period = date_range:if bpp_coverage.peak_season = true  ; Date range for peak season

; Blanket Coverage
blanket = ?:if bpp_coverage.included = true       ; Whether blanket coverage applies
blanket_number = ::if bpp_coverage.blanket = true ; Blanket coverage identifier

{@cp_commercial_building}

; ───────────────────────────────────────────────────────────────────────────────
; Covered Property - Personal Property of Others
; ───────────────────────────────────────────────────────────────────────────────
{.ppo_coverage}
included = ?                                      ; Whether personal property of others coverage is included
limit = #$:if ppo_coverage.included = true        ; Coverage limit for personal property of others
deductible = ##:if ppo_coverage.included = true   ; Deductible amount for PPO coverage

{@cp_commercial_building}

; ───────────────────────────────────────────────────────────────────────────────
; Tenant's Improvements & Betterments
; ───────────────────────────────────────────────────────────────────────────────
{.tenant_improvements}
included = ?                                      ; Whether tenant improvements and betterments coverage is included
limit = #$:if tenant_improvements.included = true ; Coverage limit for tenant improvements
valuation = (
    actual_cash_value,
    replacement_cost,
    use_interest
):if tenant_improvements.included = true          ; Valuation method for tenant improvements
deductible = ##:if tenant_improvements.included = true  ; Deductible amount for tenant improvements

{@cp_commercial_building}

; ───────────────────────────────────────────────────────────────────────────────
; Additional Coverages (Included in CP 00 10)
; ───────────────────────────────────────────────────────────────────────────────
{.additional_coverages}
debris_removal = ?true                            ; Whether debris removal is covered
debris_removal_limit = #$                         ; Limit for debris removal coverage
preservation_of_property = ?true                  ; Whether preservation of property is covered
fire_department_service_charge = #$               ; Limit for fire department service charges
pollutant_cleanup = #$                            ; Limit for pollutant cleanup and removal
increased_cost_of_construction = ?                ; Whether increased cost of construction is covered
increased_cost_limit = #$:if additional_coverages.increased_cost_of_construction = true  ; Limit for increased construction costs
electronic_data = #$                              ; Limit for electronic data restoration
electronic_data_included = ?                      ; Whether electronic data coverage is included

{@cp_commercial_building}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Extensions
; ───────────────────────────────────────────────────────────────────────────────
{.extensions}
newly_acquired_property = ?                       ; Whether newly acquired property extension is included
newly_acquired_building_limit = #$:if extensions.newly_acquired_property = true  ; Limit for newly acquired buildings
newly_acquired_bpp_limit = #$:if extensions.newly_acquired_property = true  ; Limit for newly acquired business personal property
newly_acquired_days = ##:(30, 60, 90, 120):if extensions.newly_acquired_property = true  ; Number of days coverage applies

personal_effects = ?                              ; Whether personal effects extension is included
personal_effects_limit = #$:if extensions.personal_effects = true  ; Limit for personal effects of employees

valuable_papers = ?                               ; Whether valuable papers extension is included
valuable_papers_limit = #$:if extensions.valuable_papers = true  ; Limit for valuable papers and records

accounts_receivable = ?                           ; Whether accounts receivable extension is included
accounts_receivable_limit = #$:if extensions.accounts_receivable = true  ; Limit for accounts receivable

outdoor_property = ?                              ; Whether outdoor property extension is included
outdoor_property_limit = #$:if extensions.outdoor_property = true  ; Limit for outdoor property

nonowned_detached_trailers = ?                    ; Whether non-owned detached trailers extension is included
nonowned_trailer_limit = #$:if extensions.nonowned_detached_trailers = true  ; Limit for non-owned detached trailers

{@cp_commercial_building}

; ───────────────────────────────────────────────────────────────────────────────
; Equipment Breakdown (if added)
; ───────────────────────────────────────────────────────────────────────────────
{.equipment_breakdown}
included = ?                                      ; Whether equipment breakdown coverage is included
limit = #$:if equipment_breakdown.included = true ; Coverage limit for equipment breakdown
deductible = ##:if equipment_breakdown.included = true  ; Deductible for equipment breakdown
coverage_form = ::if equipment_breakdown.included = true  ; Equipment breakdown coverage form number

{@cp_commercial_building}

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
building = #$                                     ; Premium for building coverage
bpp = #$                                          ; Premium for business personal property coverage
total_location = #$                               ; Total premium for this location

{@cp_commercial_building}

; ═══════════════════════════════════════════════════════════════════════════════
; Business Income Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@cp_business_income}
id = :                                            ; Unique identifier for business income coverage
location_number = ##                              ; Location number where coverage applies
building_number = ##                              ; Building number where coverage applies

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Form
; ───────────────────────────────────────────────────────────────────────────────
coverage_form = !(
    cp_00_30_bi_with_extra_expense,           ; BI with Extra Expense
    cp_00_32_bi_without_extra_expense,        ; BI without Extra Expense
    cp_00_50_extra_expense_only               ; Extra Expense Only
)

; ───────────────────────────────────────────────────────────────────────────────
; Business Income Limit
; ───────────────────────────────────────────────────────────────────────────────
{.business_income}
limit = #$                                        ; Business income coverage limit
coinsurance = ##:(50, 60, 70, 80, 90, 100, 125)   ; Coinsurance percentage requirement
actual_loss_sustained = ?                         ; Actual loss sustained basis
monthly_limit = #$:if business_income.actual_loss_sustained = true  ; Monthly limit for actual loss sustained

; Maximum Period of Indemnity (Alternative to Coinsurance)
max_period_of_indemnity = ?                       ; Whether maximum period of indemnity option is selected
period_months = ##:(3, 6, 12, 18, 24):if business_income.max_period_of_indemnity = true  ; Period of indemnity in months

; Extended Period of Indemnity
extended_period = ##:(0, 30, 60, 90, 120, 180, 360)  ; Extended period of indemnity in days
extended_period_limit = #$                        ; Limit for extended period coverage

{@cp_business_income}

; ───────────────────────────────────────────────────────────────────────────────
; Extra Expense
; ───────────────────────────────────────────────────────────────────────────────
{.extra_expense}
included = ?:if coverage_form = cp_00_10          ; Whether extra expense is included
included = ?:if coverage_form = cp_00_17          ; Whether extra expense is included
included = ?:if coverage_form = cp_00_30          ; Whether extra expense is included
included = ?:if coverage_form = cp_00_32_bi_with_extra_expense  ; Whether extra expense is included
limit = #$:if extra_expense.included = true       ; Extra expense coverage limit
monthly_limits = ?:if extra_expense.included = true  ; Whether monthly limits apply

; Monthly limits if applicable
month_1_limit = ##:(0..100):if extra_expense.monthly_limits = true  ; Percentage limit for month 1
month_2_limit = ##:(0..100):if extra_expense.monthly_limits = true  ; Percentage limit for month 2
month_3_limit = ##:(0..100):if extra_expense.monthly_limits = true  ; Percentage limit for month 3
month_4_plus_limit = ##:(0..100):if extra_expense.monthly_limits = true  ; Percentage limit for month 4 and beyond

{@cp_business_income}

; ───────────────────────────────────────────────────────────────────────────────
; Ordinary Payroll
; ───────────────────────────────────────────────────────────────────────────────
{.ordinary_payroll}
included = ?                                      ; Whether ordinary payroll is included in business income
limited = ?:if ordinary_payroll.included = true   ; Whether ordinary payroll coverage is time-limited
limit_days = ##:(0, 60, 90, 180):if ordinary_payroll.limited = true  ; Number of days ordinary payroll is covered

{@cp_business_income}

; ───────────────────────────────────────────────────────────────────────────────
; Waiting Period
; ───────────────────────────────────────────────────────────────────────────────
{.waiting_period}
hours = ##:(0, 24, 48, 72)                        ; Waiting period in hours before coverage begins
waiver_for_utility_services = ?                   ; Whether waiting period is waived for utility services interruption

{@cp_business_income}

; ───────────────────────────────────────────────────────────────────────────────
; Dependent Properties
; ───────────────────────────────────────────────────────────────────────────────
{.dependent_properties}
included = ?                                      ; Whether dependent properties coverage is included
contributing_locations[] = ::if dependent_properties.included = true  ; Locations that contribute to the insured's operations
recipient_locations[] = ::if dependent_properties.included = true  ; Locations that receive products from the insured
manufacturing_locations[] = ::if dependent_properties.included = true  ; Locations that manufacture for the insured
leader_locations[] = ::if dependent_properties.included = true  ; Locations that attract customers to the area
limit = #$:if dependent_properties.included = true  ; Coverage limit for dependent properties

{@cp_business_income}

; ───────────────────────────────────────────────────────────────────────────────
; Civil Authority
; ───────────────────────────────────────────────────────────────────────────────
{.civil_authority}
included = ?true                                  ; Whether civil authority coverage is included
waiting_period_hours = ##:(0, 24, 48, 72)         ; Waiting period before civil authority coverage begins
coverage_period_days = ##:(3, 4, 7, 14, 30)       ; Number of days civil authority coverage applies

{@cp_business_income}

; ───────────────────────────────────────────────────────────────────────────────
; Ingress/Egress
; ───────────────────────────────────────────────────────────────────────────────
{.ingress_egress}
included = ?                                      ; Whether ingress/egress coverage is included
coverage_period_days = ##:if ingress_egress.included = true  ; Number of days ingress/egress coverage applies

{@cp_business_income}

; ───────────────────────────────────────────────────────────────────────────────
; Utility Services
; ───────────────────────────────────────────────────────────────────────────────
{.utility_services}
included = ?                                      ; Whether utility services coverage is included
types[] = (communication, gas, power, sewer, water):if utility_services.included = true  ; Types of utility services covered
direct_damage = ?:if utility_services.included = true  ; Whether direct damage to utility services is covered
time_element = ?:if utility_services.included = true  ; Whether time element coverage for utility interruption is included
overhead_transmission_lines = ?:if utility_services.included = true  ; Whether overhead transmission lines are covered

{@cp_business_income}

; ───────────────────────────────────────────────────────────────────────────────
; Worksheet Data (for rating)
; ───────────────────────────────────────────────────────────────────────────────
{.worksheet}
annual_gross_earnings = #$                        ; Annual gross earnings for rating purposes
annual_gross_sales = #$                           ; Annual gross sales for rating purposes
annual_ordinary_payroll = #$                      ; Annual ordinary payroll amount
projected_increase_percentage = #:(0..100)        ; Projected percentage increase in business
estimated_period_of_interruption_days = ##        ; Estimated number of days of business interruption

{@cp_business_income}
; Premium
{.premium}
business_income = #$                              ; Premium for business income coverage
extra_expense = #$                                ; Premium for extra expense coverage

{@cp_business_income}

; ═══════════════════════════════════════════════════════════════════════════════
; Causes of Loss
; ═══════════════════════════════════════════════════════════════════════════════

{@cp_causes_of_loss}
id = :                                            ; Unique identifier for causes of loss

; ───────────────────────────────────────────────────────────────────────────────
; Causes of Loss Form
; ───────────────────────────────────────────────────────────────────────────────
form = !(
    cp_10_10_basic,                           ; Fire, lightning, explosion, etc.
    cp_10_20_broad,                           ; Basic + more perils
    cp_10_30_special                          ; All-risk / Open Perils
)

; ───────────────────────────────────────────────────────────────────────────────
; Basic Form Covered Perils (CP 10 10)
; ───────────────────────────────────────────────────────────────────────────────
{.basic_perils}
fire = ?true                                      ; Fire peril coverage
lightning = ?true                                 ; Lightning peril coverage
explosion = ?true                                 ; Explosion peril coverage
windstorm_hail = ?true                            ; Windstorm and hail peril coverage
smoke = ?true                                     ; Smoke peril coverage
aircraft_vehicles = ?true                         ; Aircraft and vehicles peril coverage
riot_civil_commotion = ?true                      ; Riot and civil commotion peril coverage
vandalism = ?true                                 ; Vandalism peril coverage
sprinkler_leakage = ?true                         ; Sprinkler leakage peril coverage
sinkhole_collapse = ?true                         ; Sinkhole collapse peril coverage
volcanic_action = ?true                           ; Volcanic action peril coverage

{@cp_causes_of_loss}

; ───────────────────────────────────────────────────────────────────────────────
; Broad Form Additional Perils (CP 10 20)
; ───────────────────────────────────────────────────────────────────────────────
{.broad_perils}
falling_objects = ?:if form = cp_10_20_broad      ; Falling objects peril coverage
weight_ice_snow_sleet = ?:if form = cp_10_20_broad  ; Weight of ice, snow, or sleet peril coverage
water_damage = ?:if form = cp_10_20_broad         ; Water damage peril coverage

{@cp_causes_of_loss}

; ───────────────────────────────────────────────────────────────────────────────
; Special Form (CP 10 30) - All Risk with Exclusions
; ───────────────────────────────────────────────────────────────────────────────
{.special_form}
open_perils = ?:if form = cp_10_30_special        ; Whether open perils (all-risk) coverage applies

{@cp_causes_of_loss}

; ───────────────────────────────────────────────────────────────────────────────
; Standard Exclusions (all forms)
; ───────────────────────────────────────────────────────────────────────────────
{.exclusions}
ordinance_or_law = ?true                          ; Ordinance or law exclusion applies
earth_movement = ?true                            ; Earth movement exclusion applies
governmental_action = ?true                       ; Governmental action exclusion applies
nuclear_hazard = ?true                            ; Nuclear hazard exclusion applies
utility_services = ?true                          ; Utility services exclusion applies
war = ?true                                       ; War and military action exclusion applies
water_flood = ?true                               ; Water and flood exclusion applies
fungus_bacteria = ?true                           ; Fungus and bacteria exclusion applies
virus_bacteria = ?true                            ; Virus and bacteria exclusion applies

; Additional Special Form Exclusions
wear_tear = ?true:if form = cp_10_30_special      ; Wear and tear exclusion applies
rust_corrosion = ?true:if form = cp_10_30_special ; Rust and corrosion exclusion applies
smog = ?true:if form = cp_10_30_special           ; Smog exclusion applies
settling = ?true:if form = cp_10_30_special       ; Settling, cracking, shrinking exclusion applies
nesting_vermin = ?true:if form = cp_10_30_special ; Nesting or infestation by vermin exclusion applies
mechanical_breakdown = ?true:if form = cp_10_30_special  ; Mechanical breakdown exclusion applies
missing_property = ?true:if form = cp_10_30_special  ; Missing property exclusion applies
collapse = ?true:if form = cp_10_30_special       ; Collapse exclusion applies (limited coverage may apply)

{@cp_causes_of_loss}

; ───────────────────────────────────────────────────────────────────────────────
; Theft Coverage (Special Form)
; ───────────────────────────────────────────────────────────────────────────────
{.theft}
included = ?:if form = cp_10_30_special           ; Whether theft coverage is included
employee_dishonesty_excluded = ?:if theft.included = true  ; Whether employee dishonesty is excluded from theft coverage
building_exterior_excluded = ?:if theft.included = true  ; Whether theft of building exterior is excluded

{@cp_causes_of_loss}

; ═══════════════════════════════════════════════════════════════════════════════
; Earthquake Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@cp_earthquake}
id = :                                            ; Unique identifier for earthquake coverage
location_number = ##                              ; Location number for earthquake coverage
building_number = ##                              ; Building number for earthquake coverage

; ───────────────────────────────────────────────────────────────────────────────
; Coverage
; ───────────────────────────────────────────────────────────────────────────────
included = ?                                      ; Whether earthquake coverage is included
form = (cp_10_40_earthquake, difference_in_conditions, standalone)  ; Type of earthquake coverage form

; ───────────────────────────────────────────────────────────────────────────────
; Limits
; ───────────────────────────────────────────────────────────────────────────────
{.limit}
= @coverage_limit                                 ; Use shared coverage limit type

; Earthquake-specific limit extensions
per_occurrence = #$:if included = true            ; Per occurrence limit for earthquake
annual_aggregate = #$:if included = true          ; Annual aggregate limit for earthquake
building = #$:if included = true                  ; Building coverage limit for earthquake
contents = #$:if included = true                  ; Contents coverage limit for earthquake
business_income = #$:if included = true           ; Business income coverage limit for earthquake

{@cp_earthquake}

; ───────────────────────────────────────────────────────────────────────────────
; Deductible
; ───────────────────────────────────────────────────────────────────────────────
{.deductible}
= @deductible                                     ; Use shared deductible type

; Earthquake-specific deductible extensions
flat_amount = ##:if type = flat                   ; Flat dollar deductible amount
percentage = ##:(2, 5, 10, 15, 20, 25):if type = percentage  ; Percentage deductible
minimum = ##:if type = percentage                 ; Minimum deductible when using percentage
applies_separately = ?:if included = true         ; Whether deductible applies separately to building and contents

{@cp_earthquake}

; ───────────────────────────────────────────────────────────────────────────────
; Seismic Zone
; ───────────────────────────────────────────────────────────────────────────────
seismic_zone = ##:(0..4):if included = true       ; Seismic zone classification (0-4)
soil_type = (A, B, C, D, E, F):if included = true ; Soil type classification for seismic rating
distance_to_fault_miles = #:if included = true    ; Distance to nearest active fault in miles

; Premium
premium = #$:if included = true                   ; Premium for earthquake coverage

; ═══════════════════════════════════════════════════════════════════════════════
; Flood Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@cp_flood}
id = :                                            ; Unique identifier for flood coverage
location_number = ##                              ; Location number for flood coverage
building_number = ##                              ; Building number for flood coverage

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Type
; ───────────────────────────────────────────────────────────────────────────────
coverage_type = !(
    difference_in_conditions,                 ; Difference in Conditions coverage
    nfip,                                     ; National Flood Insurance Program
    private_excess,                           ; Excess over NFIP
    private_primary                           ; Primary private flood
)

; ───────────────────────────────────────────────────────────────────────────────
; NFIP (if applicable)
; ───────────────────────────────────────────────────────────────────────────────
{.nfip}
policy_number = ::if coverage_type = nfip         ; NFIP policy number
building_limit = ##:if coverage_type = nfip       ; NFIP building coverage limit
contents_limit = ##:if coverage_type = nfip       ; NFIP contents coverage limit
building_deductible = ##:if coverage_type = nfip  ; NFIP building deductible
contents_deductible = ##:if coverage_type = nfip  ; NFIP contents deductible
waiting_period_days = ##:if coverage_type = nfip  ; NFIP waiting period in days

{@cp_flood}

; ───────────────────────────────────────────────────────────────────────────────
; Private/Excess Flood Limits
; ───────────────────────────────────────────────────────────────────────────────
{.private}
building_limit = #$:if coverage_type != nfip      ; Private flood building coverage limit
contents_limit = #$:if coverage_type != nfip      ; Private flood contents coverage limit
business_income_limit = #$:if coverage_type != nfip  ; Private flood business income coverage limit
deductible = ##:if coverage_type != nfip          ; Private flood deductible
excess_attachment = #$:if coverage_type = private_excess  ; Attachment point for excess flood coverage

{@cp_flood}

; ───────────────────────────────────────────────────────────────────────────────
; Flood Zone
; ───────────────────────────────────────────────────────────────────────────────
flood_zone = :                                ; A, AE, VE, X, etc.
base_flood_elevation = #                      ; BFE in feet
building_elevation = #                        ; Building elevation in feet
lowest_floor_elevation = #                    ; Lowest floor elevation in feet
in_sfha = ?                                   ; Special Flood Hazard Area
cbrs_area = ?                                 ; Coastal Barrier Resources System
loma_lomr = ?                                 ; Letter of Map Amendment/Revision
loma_date = date:if loma_lomr = true          ; Date of LOMA/LOMR issuance

; Premium
premium = #$                                      ; Premium for flood coverage

; ═══════════════════════════════════════════════════════════════════════════════
; Equipment Breakdown
; ═══════════════════════════════════════════════════════════════════════════════

{@cp_equipment_breakdown}
id = :                                            ; Unique identifier for equipment breakdown coverage
location_number = ##                              ; Location number for equipment breakdown coverage
building_number = ##                              ; Building number for equipment breakdown coverage

; ───────────────────────────────────────────────────────────────────────────────
; Coverage
; ───────────────────────────────────────────────────────────────────────────────
included = ?                                      ; Whether equipment breakdown coverage is included

; ───────────────────────────────────────────────────────────────────────────────
; Limits
; ───────────────────────────────────────────────────────────────────────────────
{.limit}
= @coverage_limit                                 ; Use shared coverage limit type

; Equipment breakdown-specific limit extensions
per_accident = #$:if included = true              ; Per accident limit for equipment breakdown
annual_aggregate = #$:if included = true          ; Annual aggregate limit for equipment breakdown
property_damage = #$:if included = true           ; Property damage limit
business_income = #$:if included = true           ; Business income limit
extra_expense = #$:if included = true             ; Extra expense limit
expediting_expense = #$:if included = true        ; Expediting expense limit
spoilage = #$:if included = true                  ; Spoilage coverage limit
ammonia_contamination = #$:if included = true     ; Ammonia contamination limit
hazardous_substances = #$:if included = true      ; Hazardous substances limit
water_damage = #$:if included = true              ; Water damage from equipment breakdown limit

{@cp_equipment_breakdown}

; ───────────────────────────────────────────────────────────────────────────────
; Deductible
; ───────────────────────────────────────────────────────────────────────────────
{.deductible}
= @deductible                                     ; Use shared deductible type

; Equipment breakdown-specific deductible extensions
property_damage = ##:if included = true           ; Property damage deductible
business_income_hours = ##:if included = true     ; Business income waiting period in hours

{@cp_equipment_breakdown}

; ───────────────────────────────────────────────────────────────────────────────
; Covered Equipment Categories
; ───────────────────────────────────────────────────────────────────────────────
{.equipment}
hvac = ?:if included = true                       ; HVAC equipment covered
refrigeration = ?:if included = true              ; Refrigeration equipment covered
electrical = ?:if included = true                 ; Electrical equipment covered
production = ?:if included = true                 ; Production equipment covered
computer_systems = ?:if included = true           ; Computer systems covered
communication = ?:if included = true              ; Communication equipment covered
boilers = ?:if included = true                    ; Boilers covered
pressure_vessels = ?:if included = true           ; Pressure vessels covered

{@cp_equipment_breakdown}

; Schedule of Equipment
{.scheduled_equipment[]}
description = ::if included = true                ; Description of scheduled equipment
value = #$:if included = true                     ; Value of scheduled equipment
year = ##:(1900..2100):if included = true         ; Year equipment was manufactured
manufacturer = ::if included = true               ; Equipment manufacturer

{@cp_equipment_breakdown}

; Premium
premium = #$:if included = true                   ; Premium for equipment breakdown coverage

; ═══════════════════════════════════════════════════════════════════════════════
; CP Endorsements
; ═══════════════════════════════════════════════════════════════════════════════

{@cp_endorsement}
id = :                                            ; Unique identifier for endorsement
number = !:                                       ; CP 00 90, CP 12 18, etc.
title = :                                         ; Title of endorsement
edition_date = date                               ; Edition date of endorsement form
effective_date = date                             ; Effective date of endorsement

; Type
category = !(
    additional_coverage,
    coinsurance,
    conditions,
    coverage_exclusion,
    coverage_extension,
    coverage_limitation,
    deductible,
    definitions,
    loss_payee,
    other,
    valuation
)

; Common Endorsements
type = (
    cp_00_10_building_personal_property,
    cp_00_30_business_income,
    cp_00_32_bi_without_extra_expense,
    cp_00_40_legal_liability,
    cp_00_50_extra_expense,
    cp_00_90_conditions,
    cp_04_11_windstorm_hail_percentage_ded,
    cp_10_10_basic,
    cp_10_20_broad,
    cp_10_30_special,
    cp_10_34_exclusion_windstorm_hail,
    cp_10_35_earthquake_sprinkler_leakage,
    cp_10_36_water_exclusion,
    cp_10_37_vacancy_changes,
    cp_10_38_fungi_bacteria_exclusion,
    cp_10_40_earthquake,
    cp_10_50_flood,
    cp_10_55_electronic_data_exclusion,
    cp_12_18_loss_payable,
    cp_12_19_additional_insured,
    cp_14_10_refrigerated_property,
    cp_14_20_scheduled_equipment,
    cp_14_30_accounts_receivable,
    cp_14_40_valuable_papers,
    cp_14_50_signs,
    cp_14_60_fine_arts,
    other
)

description = :                                   ; Description of endorsement
premium_impact = #$                               ; Premium impact of endorsement

; ═══════════════════════════════════════════════════════════════════════════════
; Loss Payable / Mortgagee
; ═══════════════════════════════════════════════════════════════════════════════

{@cp_loss_payable}
; Required fields first
building_number = !##                        ; Building number
interest_type = !(building_owner, contract_of_sale, lenders_loss_payable, loss_payee, mortgagee, other, trustee)  ; Interest type
location_number = !##                        ; Location number
name = !:                                    ; Payee name
sequence = !##                               ; Sequence number

; Optional fields
address = @address                           ; Payee address
applies_to = (both, building, contents)      ; Coverage applies to
loan_date = date                             ; Loan origination date
loan_number = *:                             ; Loan number (confidential)
payee_id = :                                 ; Unique payee identifier

; ═══════════════════════════════════════════════════════════════════════════════
; Commercial Property Policy
; ═══════════════════════════════════════════════════════════════════════════════

{@cp_policy}
; Required fields first
effective_date = !date                       ; Policy effective date
expiration_date = !date                      ; Policy expiration date
number = !:                           ; Policy number

; Invariants
:invariant expiration_date > effective_date

; Optional fields
buildings[] = @cp_commercial_building        ; Insured buildings
business_income[] = @cp_business_income      ; Business income coverages
causes_of_loss = @cp_causes_of_loss          ; Causes of loss form
earthquake[] = @cp_earthquake                ; Earthquake coverage
effective_time = time                        ; Policy effective time
endorsements[] = @cp_endorsement             ; Policy endorsements
equipment_breakdown[] = @cp_equipment_breakdown  ; Equipment breakdown coverage
expiration_time = time                       ; Policy expiration time
flood[] = @cp_flood                          ; Flood coverage
id = :                                ; Unique policy identifier
locations[] = @location.business_location    ; Insured locations
loss_payables[] = @cp_loss_payable           ; Loss payees
named_insured = @entity.business      ; Named insured

; ───────────────────────────────────────────────────────────────────────────────
; Blanket Coverage (nested)
; ───────────────────────────────────────────────────────────────────────────────
{.blankets[]}
applies_to = (bpp, building, building_and_bpp)  ; Coverage applies to
blanket_number = :                                ; Blanket identifier
buildings[] = ##                                  ; Buildings included
coinsurance = ##:(80, 90, 100)                    ; Coinsurance percentage
description = :                                   ; Blanket description
limit = #$                                        ; Blanket limit
locations[] = ##                                  ; Locations included

{@cp_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Premium Summary
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
building_total = #$                               ; Total building premium
bpp_total = #$                                    ; Total business personal property premium
business_income_total = #$                        ; Total business income premium
earthquake_total = #$                             ; Total earthquake premium
flood_total = #$                                  ; Total flood premium
equipment_breakdown_total = #$                    ; Total equipment breakdown premium
endorsements_total = #$                           ; Total endorsements premium
total_estimated = #$                              ; Total estimated premium
minimum = #$                                      ; Minimum earned premium
deposit = #$                                      ; Deposit premium

{@cp_policy}



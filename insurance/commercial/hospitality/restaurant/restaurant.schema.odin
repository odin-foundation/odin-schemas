; ===================================================================================
; ODIN Restaurant Insurance Schema
; ===================================================================================
; Restaurant and food service insurance covering property, general liability,
; products and completed operations, food contamination/spoilage, liquor
; liability, business interruption, and equipment breakdown.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.hospitality.restaurant"
version = "1.0.0"
title = "Restaurant Insurance Schema"
description = "Comprehensive insurance for restaurants and food service operations"

{$derivation}
source[0].authority = "National Association of Insurance Commissioners (NAIC)"
source[0].citation = "Commercial Insurance - Restaurant Operations"
source[0].url = "https://content.naic.org/"

source[1].authority = "National Restaurant Association"
source[1].citation = "Restaurant Industry Insurance Guidelines"
source[1].url = "https://restaurant.org/"

source[2].authority = "Food and Drug Administration"
source[2].citation = "Food Code and Safety Requirements"
source[2].url = "https://www.fda.gov/"

source[3].authority = "Insurance Services Office (ISO)"
source[3].citation = "Commercial General Liability - Restaurant Classification"
source[3].url = "https://www.verisk.com/insurance/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on NAIC guidelines and restaurant industry insurance practices"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial restaurant insurance schema"
changelog[0].rationale = "Commercial hospitality coverage for food service operations"

; ===================================================================================
; Restaurant Classification
; ===================================================================================

{@rest_classification}
restaurant_type = !(
    bakery,                                   ; Bakery/pastry shop
    bar_grill,                                ; Bar and grill
    buffet,                                   ; Buffet restaurant
    cafe,                                     ; Cafe/coffee shop
    catering,                                 ; Catering operation
    deli,                                     ; Delicatessen
    diner,                                    ; Diner
    fast_casual,                              ; Fast casual
    fine_dining,                              ; Fine dining
    food_court,                               ; Food court tenant
    food_truck,                               ; Mobile food truck
    full_service,                             ; Full-service
    ghost_kitchen,                            ; Delivery only
    institutional,                            ; Institutional (school, hospital)
    pizza,                                    ; Pizzeria
    quick_service                             ; QSR/fast food
)

; Cuisine type
cuisine = (
    american,                                 ; American
    asian,                                    ; Asian
    barbecue,                                 ; BBQ
    chinese,                                  ; Chinese
    french,                                   ; French
    indian,                                   ; Indian
    italian,                                  ; Italian
    japanese,                                 ; Japanese
    mediterranean,                            ; Mediterranean
    mexican,                                  ; Mexican
    other,                                    ; Other
    seafood,                                  ; Seafood
    steakhouse                                ; Steakhouse
)

; Service style
service_style = (
    counter,                                  ; Counter service
    delivery_only,                            ; Delivery only
    drive_thru,                               ; Drive-thru
    full_service,                             ; Table service
    takeout                                   ; Takeout only
)

; ===================================================================================
; Restaurant Property
; ===================================================================================

{@rest_establishment}
; Required fields first
annual_gross_sales = !#$:(0..)                ; Annual revenue
business_name = !:                            ; Legal name
classification = !@rest_classification        ; Restaurant type

; Optional fields
address = @address                            ; Physical location
alcohol_sales = #$:(0..)                      ; Alcohol revenue
bar_seating = ##                              ; Bar seats
catering_percentage = #:(0..100)              ; Catering % of sales
days_per_week = ##:(1..7)                     ; Days open
delivery_percentage = #:(0..100)              ; Delivery % of sales
dba = :                                       ; DBA name
email = *@email                               ; Contact email
employee_count = ##                           ; Staff count
establishment_id = :                          ; Internal identifier
fein = *:                                     ; Tax ID
food_sales = #$:(0..)                         ; Food revenue
franchise = ?                                 ; Franchise location
franchise_brand = ::if franchise = true       ; Brand name
hours_of_operation = :                        ; Operating hours
kitchen_sqft = ##                             ; Kitchen size
outdoor_seating = ##                          ; Patio seats
owner = :                                     ; Owner name
payroll = #$:(0..)                            ; Annual payroll
phone = *@phone                               ; Contact phone
restaurant_seating = ##                       ; Dining seats
square_feet = ##                              ; Total square feet
years_in_business = ##                        ; Years operating

; ---------------------------------------------------------------------------
; Kitchen Equipment
; ---------------------------------------------------------------------------
{.kitchen}
char_broiler = ?                              ; Char broiler/grill
deep_fryer = ?                                ; Deep fryers
exhaust_hood = ?                              ; Commercial hood
fire_suppression = ?                          ; Ansul system
flat_top = ?                                  ; Flat top grill
hood_cleaning = (monthly, quarterly, semi_annual)
open_flame = ?                                ; Open flame cooking
pizza_oven = ?                                ; Pizza oven
smoker = ?                                    ; Smoker
solid_fuel = ?                                ; Wood/charcoal
walk_in_cooler = ?                            ; Walk-in refrigeration
walk_in_freezer = ?                           ; Walk-in freezer
wok = ?                                       ; Wok cooking

{@rest_establishment}

; ===================================================================================
; Property Coverage
; ===================================================================================

{@rest_property}
; Required fields first
building_limit = !#$:(0..)                    ; Building coverage
contents_limit = !#$:(0..)                    ; Contents/equipment

; Optional fields
all_risk = ?                                  ; All-risk form
deductible = #$:(0..)                         ; Property deductible
earthquake = ?                                ; Earthquake
equipment_breakdown = ?                       ; Equipment breakdown
flood = ?                                     ; Flood
improvements_limit = #$:(0..)                 ; Tenant improvements
inventory_limit = #$:(0..)                    ; Food/beverage stock
outdoor_fixtures = #$:(0..)                   ; Patio furniture
replacement_cost = ?                          ; RC valuation
signs = #$:(0..)                              ; Sign coverage
windstorm = ?                                 ; Windstorm

; ---------------------------------------------------------------------------
; Business Interruption
; ---------------------------------------------------------------------------
{.business_interruption}
included = ?                                  ; BI coverage
actual_loss = ?:if included = true            ; Actual loss sustained
civil_authority = ?:if included = true        ; Civil authority
contingent_bi = ?:if included = true          ; Contingent BI
extended_bi = ?:if included = true            ; Extended BI
extra_expense = ?:if included = true          ; Extra expense
ingress_egress = ?:if included = true         ; Ingress/egress
limit = #$:(0..):if included = true           ; BI limit
waiting_days = ##:if included = true          ; Waiting period

{@rest_property}

; ---------------------------------------------------------------------------
; Spoilage Coverage
; ---------------------------------------------------------------------------
{.spoilage}
included = ?                                  ; Spoilage coverage
breakdown = ?:if included = true              ; Equipment breakdown
contamination = ?:if included = true          ; Contamination
deductible = #$:(0..):if included = true      ; Spoilage deductible
limit = #$:(0..):if included = true           ; Spoilage limit
power_failure = ?:if included = true          ; Power outage

{@rest_property}

; ===================================================================================
; Liability Coverage
; ===================================================================================

{@rest_liability}
; Required fields first
general_liability = !#$:(0..)                 ; GL per occurrence

; Optional fields
aggregate = #$:(0..)                          ; Annual aggregate
assault_battery = ?                           ; A&B coverage
assault_battery_limit = #$:(0..):if assault_battery = true
deductible = #$:(0..)                         ; Liability deductible
employers_liability = ?                       ; EL coverage
el_limit = #$:(0..):if employers_liability = true
excess_umbrella = ?                           ; Excess/umbrella
excess_limit = #$:(0..):if excess_umbrella = true
food_borne_illness = ?                        ; Food contamination
hired_auto = ?                                ; Hired auto (delivery)
liquor_liability = ?                          ; Liquor liability
liquor_limit = #$:(0..):if liquor_liability = true
medical_payments = #$:(0..)                   ; Med pay limit
non_owned_auto = ?                            ; Non-owned auto
personal_advertising_injury = ?               ; Personal/advertising
products_completed = ?                        ; Products/completed ops
products_limit = #$:(0..):if products_completed = true

; ===================================================================================
; Workers Compensation
; ===================================================================================

{@rest_workers_comp}
included = ?                                  ; WC coverage
class_code = :                                ; Primary class code
el_each_accident = #$:(0..):if included = true
el_disease_employee = #$:(0..):if included = true
el_disease_policy = #$:(0..):if included = true
experience_mod = #:if included = true         ; Experience modifier
payroll = #$:(0..):if included = true         ; Covered payroll

; ===================================================================================
; Crime Coverage
; ===================================================================================

{@rest_crime}
included = ?                                  ; Crime coverage
employee_theft = #$:(0..):if included = true  ; Employee theft
forgery = #$:(0..):if included = true         ; Forgery
money_on_premises = #$:(0..):if included = true  ; On-premises
money_in_transit = #$:(0..):if included = true   ; In transit
robbery = #$:(0..):if included = true         ; Robbery

; ===================================================================================
; Premium Details
; ===================================================================================

{@rest_premium}
; Required fields first
total_premium = !#$:(0..)                     ; Total premium

; Optional fields
bi_premium = #$:(0..)                         ; BI premium
crime_premium = #$:(0..)                      ; Crime premium
liability_premium = #$:(0..)                  ; Liability premium
liquor_premium = #$:(0..)                     ; Liquor premium
minimum_premium = #$:(0..)                    ; Minimum premium
policy_fee = #$:(0..)                         ; Policy fee
property_premium = #$:(0..)                   ; Property premium
spoilage_premium = #$:(0..)                   ; Spoilage premium
taxes_and_fees = #$:(0..)                     ; Taxes/fees
wc_premium = #$:(0..)                         ; Workers comp

; ---------------------------------------------------------------------------
; Rating Factors
; ---------------------------------------------------------------------------
{.rating}
alcohol_factor = #                            ; Alcohol sales factor
claims_experience = #                         ; Experience mod
cooking_factor = #                            ; Cooking hazard
delivery_factor = #                           ; Delivery operations
location_factor = #                           ; Location rating
sales_factor = #                              ; Gross sales tier
type_factor = #                               ; Restaurant type

{@rest_premium}

; ===================================================================================
; Claims
; ===================================================================================

{@rest_claim}
; Required fields first
claim_date = !date                            ; Claim date
claim_type = !(
    assault,                                  ; Assault on premises
    auto_delivery,                            ; Delivery auto
    bodily_injury,                            ; Customer injury
    burns,                                    ; Burn injury
    employee_theft,                           ; Employee theft
    equipment_breakdown,                      ; Equipment failure
    fire,                                     ; Fire damage
    food_poisoning,                           ; Food-borne illness
    foreign_object,                           ; Foreign object
    liquor,                                   ; Liquor liability
    property_damage,                          ; Property damage
    robbery,                                  ; Robbery
    slip_fall,                                ; Slip and fall
    spoilage,                                 ; Food spoilage
    third_party,                              ; Third-party injury
    workers_comp,                             ; Employee injury
    other                                     ; Other
)

; Optional fields
amount_claimed = #$:(0..)                     ; Amount claimed
amount_paid = #$:(0..)                        ; Amount paid
claim_id = :                                  ; Claim ID
claim_status = (
    closed,
    denied,
    litigation,
    open,
    paid,
    reserved,
    settled
)
claimant_name = *:                            ; Claimant name
deductible_applied = #$:(0..)                 ; Deductible
description = :                               ; Description
health_dept_involved = ?                      ; Health dept report
incident_date = date                          ; Incident date
incident_location = :                         ; Where occurred
litigation = ?                                ; In litigation
reserve = #$:(0..)                            ; Reserve amount

; ===================================================================================
; Restaurant Policy
; ===================================================================================

{@restaurant_policy}
; Required fields first
effective_date = !date                        ; Policy effective date
establishment = !@rest_establishment          ; Restaurant details
expiration_date = !date                       ; Policy expiration date
liability = !@rest_liability                  ; Liability coverage
policy_number = !:                            ; Policy number

; Invariants
:invariant expiration_date > effective_date

; Optional fields
agency = @agency                              ; Issuing agency
claims[] = @rest_claim                        ; Claims history
crime = @rest_crime                           ; Crime coverage
endorsements[] = :                            ; Policy endorsements
id = :                                        ; Internal identifier
policy_form = (
    bop,                                      ; Business owners policy
    commercial_package,                       ; Commercial package
    monoline                                  ; Monoline coverage
)
policy_status = (
    active,
    cancelled,
    expired,
    non_renewed,
    pending
)
premium = @rest_premium                       ; Premium details
producer = @producer                          ; Agent
property = @rest_property                     ; Property coverage
underwriting = @underwriting_decision         ; Underwriting
workers_comp = @rest_workers_comp             ; Workers compensation

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
annual_sales = #$:(0..)                       ; Annual revenue
liability_limit = #$:(0..)                    ; GL limit
property_limit = #$:(0..)                     ; Total property
restaurant_name = :                           ; Business name
restaurant_type = :                           ; Classification

{@restaurant_policy}


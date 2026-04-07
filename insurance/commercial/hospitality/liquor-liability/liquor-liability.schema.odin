; ===================================================================================
; ODIN Liquor Liability Insurance Schema
; ===================================================================================
; Liquor liability (dram shop) insurance for bars, restaurants, nightclubs, and
; other establishments that manufacture, distribute, sell, or serve alcoholic
; beverages covering third-party bodily injury and property damage.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.hospitality.liquor-liability"
version = "1.0.0"
title = "Liquor Liability Insurance Schema"
description = "Dram shop liability coverage for alcohol-serving establishments"

{$derivation}
source[0].authority = "National Association of Insurance Commissioners (NAIC)"
source[0].citation = "Commercial Liability Insurance - Liquor Liability"
source[0].url = "https://content.naic.org/"

source[1].authority = "Insurance Services Office (ISO)"
source[1].citation = "Liquor Liability Coverage Form CG 00 34"
source[1].url = "https://www.verisk.com/insurance/"

source[2].authority = "Alcohol and Tobacco Tax and Trade Bureau"
source[2].citation = "Beverage Alcohol Licensing Requirements"
source[2].url = "https://www.ttb.gov/"

source[3].authority = "State Alcoholic Beverage Control Boards"
source[3].citation = "Dram Shop Liability Laws by State"
source[3].url = "https://www.nabca.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on ISO liquor liability forms and state dram shop laws"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial liquor liability insurance schema"
changelog[0].rationale = "Commercial hospitality coverage for alcohol establishments"

; ===================================================================================
; Establishment Classification
; ===================================================================================

{@ll_establishment_type}
business_type = !(
    bar,                                      ; Bar/tavern
    brewery,                                  ; Brewery with taproom
    caterer,                                  ; Catering with alcohol
    distillery,                               ; Distillery with tasting
    event_venue,                              ; Event/banquet venue
    golf_course,                              ; Golf course with bar
    hotel_bar,                                ; Hotel bar/lounge
    liquor_store,                             ; Package store
    nightclub,                                ; Nightclub/dance club
    restaurant,                               ; Restaurant with bar
    sports_bar,                               ; Sports bar
    winery                                    ; Winery with tasting room
)

; Service type
service_type = (
    consumption_on_premises,                  ; On-premise consumption
    consumption_off_premises,                 ; Off-premise (package)
    mixed                                     ; Both on and off
)

; ===================================================================================
; License Information
; ===================================================================================

{@ll_license}
; Required fields first
license_number = !*:                           ; ABC license number
license_type = !(
    beer_only,                                ; Beer only
    beer_wine,                                ; Beer and wine
    full_liquor,                              ; Full liquor license
    manufacturer,                             ; Brewery/winery/distillery
    special_event,                            ; Special event permit
    wholesaler                                ; Wholesale/distributor
)

; Optional fields
expiration_date = date                        ; License expiration
issue_date = date                             ; License issue date
issuing_authority = :                         ; ABC board/agency
license_class = :                             ; State-specific class
restrictions[] = :                            ; License restrictions
state = :(2)                                  ; State of license

; ===================================================================================
; Insured Establishment
; ===================================================================================

{@ll_establishment}
; Required fields first
annual_alcohol_sales = !#$:(0..)              ; Annual alcohol revenue
business_name = !:                            ; Legal business name
establishment_type = !@ll_establishment_type  ; Business classification
license = !@ll_license                        ; Liquor license

; Optional fields
address = @address                            ; Physical location
annual_food_sales = #$:(0..)                  ; Food revenue
annual_gross_receipts = #$:(0..)              ; Total gross receipts
bar_seating = ##                              ; Bar seats
capacity = ##                                 ; Total capacity
dancing = ?                                   ; Dance floor
dba = :                                       ; DBA name
email = *@email                               ; Contact email
employee_count = ##                           ; Staff count
entertainment = ?                             ; Live entertainment
fein = *:                                     ; Tax ID
hours_of_operation = :                        ; Operating hours
live_music = ?                                ; Live music
outdoor_service = ?                           ; Patio/outdoor bar
phone = *@phone                               ; Contact phone
pool_tables = ?                               ; Pool tables
restaurant_seating = ##                       ; Restaurant seats
security_staff = ?                            ; Security personnel
valet_parking = ?                             ; Valet service
video_surveillance = ?                        ; CCTV system
years_in_business = ##                        ; Years operating

; ===================================================================================
; Liquor Liability Coverage
; ===================================================================================

{@ll_coverage}
; Required fields first
each_occurrence = !#$:(0..)                   ; Per occurrence limit
general_aggregate = !#$:(0..)                 ; Aggregate limit

; Optional fields
assault_battery = ?                           ; A&B coverage
assault_battery_limit = #$:(0..):if assault_battery = true
assault_battery_sublimit = #$:(0..):if assault_battery = true
deductible = #$:(0..)                         ; Deductible
defense_costs = (included, supplementary)     ; Defense inside/outside
host_liquor = ?                               ; Host liquor liability
products_completed = ?                        ; Products coverage
sexual_assault = ?                            ; Sexual assault coverage
sexual_assault_sublimit = #$:(0..):if sexual_assault = true

; ---------------------------------------------------------------------------
; Coverage Extensions
; ---------------------------------------------------------------------------
{.extensions}
employee_acts = ?                             ; Employee negligence
fire_legal_liability = ?                      ; Fire legal
fire_legal_limit = #$:(0..):if extensions.fire_legal_liability = true
hired_auto = ?                                ; Hired auto (valet)
medical_payments = ?                          ; Med pay
medical_payments_limit = #$:(0..):if extensions.medical_payments = true
personal_advertising_injury = ?               ; Personal/advertising

{@ll_coverage}

; ===================================================================================
; Exclusions
; ===================================================================================

{@ll_exclusions}
; Standard exclusions
criminal_acts = ?true                         ; Criminal conduct
expected_intended = ?true                     ; Expected/intended
illegal_sale_minor = ?true                    ; Sale to minors
illegal_sale_intoxicated = ?true              ; Sale to intoxicated
known_violation = ?true                       ; Known violations
war = ?true                                   ; War/terrorism
workers_comp = ?true                          ; Work comp excluded

; Liquor-specific exclusions
after_hours = ?                               ; After-hours sales
drug_related = ?                              ; Drug-related claims
employment_related = ?                        ; Employee injury
failure_to_procure = ?                        ; No license
gambling = ?                                  ; Gambling activities
sports_participant = ?                        ; Sports injuries

; ===================================================================================
; Risk Characteristics
; ===================================================================================

{@ll_risk}
; Operating characteristics
age_verification = ?                          ; ID checking policy
alcohol_percent_revenue = #:(0..100)          ; Alcohol % of sales
avg_check_size = #$:(0..)                     ; Average tab
closing_time = :                              ; Closing time
designated_driver = ?                         ; DD program
drink_limit = ?                               ; Drink limit policy
happy_hour = ?                                ; Happy hour specials
last_call_time = :                            ; Last call time
server_training = ?                           ; TIPS/ServSafe trained
shots_served = ?                              ; Shots/shooters served

; Claims history
claims_last_3_years = ##                      ; Claims count
claims_paid_last_3_years = #$:(0..)           ; Claims paid
license_suspensions = ##                      ; Past suspensions
prior_coverage = ?                            ; Prior insurance
prior_insurer = :                             ; Prior carrier

; ===================================================================================
; Premium Details
; ===================================================================================

{@ll_premium}
; Required fields first
total_premium = !#$:(0..)                     ; Total premium

; Optional fields
assault_battery_premium = #$:(0..)            ; A&B premium
base_premium = #$:(0..)                       ; Base premium
extensions_premium = #$:(0..)                 ; Extensions
minimum_premium = #$:(0..)                    ; Minimum premium
policy_fee = #$:(0..)                         ; Policy fee
taxes_and_fees = #$:(0..)                     ; Taxes/fees

; ---------------------------------------------------------------------------
; Rating Factors
; ---------------------------------------------------------------------------
{.rating}
alcohol_sales_factor = #                      ; Alcohol revenue factor
claims_experience = #                         ; Experience factor
entertainment_factor = #                      ; Entertainment factor
hours_factor = #                              ; Late hours factor
location_factor = #                           ; Location rating
training_credit = #                           ; Server training credit
type_factor = #                               ; Establishment type

{@ll_premium}

; ===================================================================================
; Claims
; ===================================================================================

{@ll_claim}
; Required fields first
claim_date = !date                            ; Claim date
claim_type = !(
    assault_battery,                          ; A&B claim
    auto_accident,                            ; DUI-related auto
    bodily_injury,                            ; Bodily injury
    minor_sale,                               ; Sale to minor
    over_service,                             ; Over-serving
    property_damage,                          ; Property damage
    slip_fall,                                ; Premises injury
    wrongful_death,                           ; Wrongful death
    other                                     ; Other
)

; Optional fields
alcohol_involved = ?                          ; Alcohol factor
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
claimant_age = ##                             ; Claimant age
claimant_bac = #                              ; Blood alcohol level
deductible_applied = #$:(0..)                 ; Deductible
description = :                               ; Description
incident_date = date                          ; Incident date
incident_location = :                         ; Where occurred
incident_time = :                             ; Time of incident
litigation = ?                                ; In litigation
reserve = #$:(0..)                            ; Reserve amount
third_party = ?                               ; Third-party claim

; ===================================================================================
; Liquor Liability Policy
; ===================================================================================

{@liquor_policy}
; Required fields first
coverage = !@ll_coverage                      ; Coverage terms
effective_date = !date                        ; Policy effective date
establishment = !@ll_establishment            ; Insured establishment
expiration_date = !date                       ; Policy expiration date
policy_number = !:                            ; Policy number

; Invariants
:invariant expiration_date > effective_date

; Optional fields
agency = @agency                              ; Issuing agency
claims[] = @ll_claim                          ; Claims history
endorsements[] = :                            ; Policy endorsements
exclusions = @ll_exclusions                   ; Exclusions
id = :                                        ; Internal identifier
policy_form = (
    iso_cg_00_34,                             ; ISO form
    manuscript,                               ; Manuscript form
    proprietary                               ; Carrier form
)
policy_status = (
    active,
    cancelled,
    expired,
    non_renewed,
    pending
)
premium = @ll_premium                         ; Premium details
producer = @producer                          ; Agent
risk = @ll_risk                               ; Risk characteristics
underwriting = @underwriting_decision         ; Underwriting

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
alcohol_sales = #$:(0..)                      ; Annual alcohol sales
business_type = :                             ; Establishment type
coverage_limit = #$:(0..)                     ; Per occurrence
total_receipts = #$:(0..)                     ; Total revenue

{@liquor_policy}


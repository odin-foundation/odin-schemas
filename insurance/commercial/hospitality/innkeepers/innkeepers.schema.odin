; ===================================================================================
; ODIN Innkeepers Insurance Schema
; ===================================================================================
; Innkeepers liability insurance for hotels, motels, resorts, and bed & breakfasts
; covering guest property liability, safe deposit box coverage, innkeeper's legal
; liability, and guest personal property protection.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.hospitality.innkeepers"
version = "1.0.0"
title = "Innkeepers Insurance Schema"
description = "Liability coverage for hotels, motels, and lodging establishments"

{$derivation}
source[0].authority = "National Association of Insurance Commissioners (NAIC)"
source[0].citation = "Commercial Liability - Innkeepers Coverage"
source[0].url = "https://content.naic.org/"

source[1].authority = "American Hotel & Lodging Association"
source[1].citation = "Hotel Industry Insurance Standards"
source[1].url = "https://www.ahla.com/"

source[2].authority = "Insurance Services Office (ISO)"
source[2].citation = "Commercial General Liability - Hotels/Motels"
source[2].url = "https://www.verisk.com/insurance/"

source[3].authority = "State Innkeeper Liability Statutes"
source[3].citation = "Innkeeper Rights and Responsibilities"
source[3].url = "https://www.ncsl.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on innkeeper liability laws and hospitality insurance practices"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial innkeepers insurance schema"
changelog[0].rationale = "Commercial hospitality coverage for lodging establishments"

; ===================================================================================
; Lodging Classification
; ===================================================================================

{@ik_lodging_type}
property_class = !(
    bed_breakfast,                            ; B&B/inn
    boutique_hotel,                           ; Boutique property
    casino_hotel,                             ; Casino resort
    convention_hotel,                         ; Convention center hotel
    extended_stay,                            ; Extended stay
    full_service_hotel,                       ; Full-service hotel
    hostel,                                   ; Hostel
    limited_service_hotel,                    ; Limited-service
    motel,                                    ; Motel
    resort,                                   ; Resort property
    vacation_rental                           ; Commercial STR
)

; Star rating
star_rating = (
    economy,                                  ; 1-star/economy
    midscale,                                 ; 2-star/midscale
    upscale,                                  ; 3-star/upscale
    upper_upscale,                            ; 4-star/upper upscale
    luxury                                    ; 5-star/luxury
)

; Brand affiliation
affiliation = (
    franchise,                                ; Franchise
    independent,                              ; Independent
    managed,                                  ; Management company
    owned                                     ; Brand-owned
)

; ===================================================================================
; Lodging Property
; ===================================================================================

{@ik_property}
; Required fields first
lodging_type = !@ik_lodging_type              ; Property classification
property_name = !:                            ; Hotel/property name
room_count = !##                              ; Total rooms

; Optional fields
address = @address                            ; Physical location
avg_daily_rate = #$:(0..)                     ; ADR
brand = :                                     ; Brand affiliation
conference_space_sqft = ##                    ; Meeting space
email = *@email                               ; Contact email
employee_count = ##                           ; Staff count
fein = *:                                     ; Tax ID
floors = ##                                   ; Number of floors
gross_receipts = #$:(0..)                     ; Annual revenue
management_company = :                        ; Management company
occupancy_rate = #:(0..100)                   ; Avg occupancy %
owner = :                                     ; Property owner
phone = *@phone                               ; Contact phone
property_id = :                               ; Internal identifier
restaurant_capacity = ##                      ; Restaurant seats
revpar = #$:(0..)                             ; Revenue per room
suite_count = ##                              ; Suite count
year_built = ##                               ; Year constructed
year_renovated = ##                           ; Last renovation

; ---------------------------------------------------------------------------
; Amenities
; ---------------------------------------------------------------------------
{.amenities}
bar_lounge = ?                                ; Bar/lounge
business_center = ?                           ; Business center
casino = ?                                    ; Casino
concierge = ?                                 ; Concierge services
convention_center = ?                         ; Convention facilities
fitness_center = ?                            ; Fitness center
golf = ?                                      ; Golf course
kids_club = ?                                 ; Children's program
parking_garage = ?                            ; Parking structure
pool_indoor = ?                               ; Indoor pool
pool_outdoor = ?                              ; Outdoor pool
restaurant = ?                                ; On-site restaurant
room_service = ?                              ; Room service
shuttle_service = ?                           ; Airport/local shuttle
ski = ?                                       ; Ski facilities
spa = ?                                       ; Spa services
tennis = ?                                    ; Tennis courts
valet = ?                                     ; Valet parking
water_park = ?                                ; Water park

{@ik_property}

; ===================================================================================
; Innkeeper's Liability Coverage
; ===================================================================================

{@ik_liability}
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
liquor_liability = ?                          ; Liquor liability
liquor_limit = #$:(0..):if liquor_liability = true
personal_advertising_injury = ?               ; Personal/advertising
products_completed = ?                        ; Products/completed ops
sexual_abuse = ?                              ; Sexual abuse/molestation
sexual_abuse_limit = #$:(0..):if sexual_abuse = true

; ===================================================================================
; Guest Property Coverage
; ===================================================================================

{@ik_guest_property}
; Guest property liability
guest_property_limit = #$:(0..)               ; Per guest limit
guest_property_aggregate = #$:(0..)           ; Annual aggregate
deductible = #$:(0..)                         ; Deductible

; Safe deposit coverage
safe_deposit = ?                              ; Safe deposit coverage
safe_deposit_limit = #$:(0..):if safe_deposit = true
safe_deposit_per_item = #$:(0..):if safe_deposit = true

; In-room safes
in_room_safe = ?                              ; In-room safe coverage
in_room_safe_limit = #$:(0..):if in_room_safe = true

; Bailment coverage
bailment = ?                                  ; Bailment liability
bailment_limit = #$:(0..):if bailment = true
coat_check = ?:if bailment = true             ; Coat check covered
luggage = ?:if bailment = true                ; Luggage handling
valet_parking = ?:if bailment = true          ; Valet parking

; ===================================================================================
; Property Coverage
; ===================================================================================

{@ik_property_insurance}
; Required fields first
building_limit = !#$:(0..)                    ; Building coverage
contents_limit = !#$:(0..)                    ; Contents/FF&E

; Optional fields
all_risk = ?                                  ; All-risk form
business_interruption = ?                     ; BI coverage
bi_limit = #$:(0..):if business_interruption = true
bi_waiting_days = ##:if business_interruption = true
deductible = #$:(0..)                         ; Property deductible
earthquake = ?                                ; Earthquake
equipment_breakdown = ?                       ; Equipment breakdown
flood = ?                                     ; Flood
named_storm = ?                               ; Named storm
ordinance_law = ?                             ; Ordinance/law
replacement_cost = ?                          ; RC valuation
spoilage = ?                                  ; Food spoilage
windstorm = ?                                 ; Windstorm

; ===================================================================================
; Crime Coverage
; ===================================================================================

{@ik_crime}
included = ?                                  ; Crime coverage
employee_theft = #$:(0..):if included = true  ; Employee theft limit
forgery = #$:(0..):if included = true         ; Forgery limit
guest_theft = #$:(0..):if included = true     ; Guest theft
money_securities = #$:(0..):if included = true ; Money/securities
robbery = #$:(0..):if included = true         ; Robbery limit

; ===================================================================================
; Premium Details
; ===================================================================================

{@ik_premium}
; Required fields first
total_premium = !#$:(0..)                     ; Total premium

; Optional fields
crime_premium = #$:(0..)                      ; Crime coverage
guest_property_premium = #$:(0..)             ; Guest property
liability_premium = #$:(0..)                  ; Liability premium
minimum_premium = #$:(0..)                    ; Minimum premium
policy_fee = #$:(0..)                         ; Policy fee
property_premium = #$:(0..)                   ; Property premium
taxes_and_fees = #$:(0..)                     ; Taxes/fees

; ---------------------------------------------------------------------------
; Rating Factors
; ---------------------------------------------------------------------------
{.rating}
adr_factor = #                                ; Rate tier factor
amenities_factor = #                          ; Amenities factor
claims_experience = #                         ; Experience mod
construction_factor = #                       ; Construction class
location_factor = #                           ; Location rating
occupancy_factor = #                          ; Occupancy factor
room_count_factor = #                         ; Size factor

{@ik_premium}

; ===================================================================================
; Claims
; ===================================================================================

{@ik_claim}
; Required fields first
claim_date = !date                            ; Claim date
claim_type = !(
    assault,                                  ; Assault on property
    auto_valet,                               ; Valet damage
    bed_bug,                                  ; Bed bug claims
    bodily_injury,                            ; Guest injury
    fire,                                     ; Fire damage
    food_poisoning,                           ; Food illness
    guest_property,                           ; Guest belongings
    mold,                                     ; Mold exposure
    pool_spa,                                 ; Pool/spa injury
    property_damage,                          ; Property damage
    robbery,                                  ; Robbery/theft
    safe_deposit,                             ; Safe deposit loss
    sexual_assault,                           ; Sexual assault
    slip_fall,                                ; Slip and fall
    wrongful_death,                           ; Wrongful death
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
deductible_applied = #$:(0..)                 ; Deductible
description = :                               ; Description
guest_name = *:                               ; Guest name
incident_date = date                          ; Incident date
incident_location = :                         ; Where occurred
litigation = ?                                ; In litigation
reserve = #$:(0..)                            ; Reserve amount
room_number = :                               ; Room number

; ===================================================================================
; Innkeeper's Policy
; ===================================================================================

{@innkeeper_policy}
; Required fields first
effective_date = !date                        ; Policy effective date
expiration_date = !date                       ; Policy expiration date
liability = !@ik_liability                    ; Liability coverage
policy_number = !:                            ; Policy number
property = !@ik_property                      ; Insured property

; Invariants
:invariant expiration_date > effective_date

; Optional fields
agency = @agency                              ; Issuing agency
claims[] = @ik_claim                          ; Claims history
crime = @ik_crime                             ; Crime coverage
endorsements[] = :                            ; Policy endorsements
guest_property = @ik_guest_property           ; Guest property coverage
id = :                                        ; Internal identifier
policy_form = (
    package,                                  ; Package policy
    standalone                                ; Standalone form
)
policy_status = (
    active,
    cancelled,
    expired,
    non_renewed,
    pending
)
premium = @ik_premium                         ; Premium details
producer = @producer                          ; Agent
property_insurance = @ik_property_insurance   ; Building/contents
underwriting = @underwriting_decision         ; Underwriting

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
guest_property_limit = #$:(0..)               ; Guest property limit
liability_limit = #$:(0..)                    ; GL limit
property_name = :                             ; Hotel name
room_count = ##                               ; Rooms

{@innkeeper_policy}


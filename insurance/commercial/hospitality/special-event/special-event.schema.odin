; ===================================================================================
; ODIN Special Event Insurance Schema
; ===================================================================================
; Special event insurance for one-time or short-term events such as festivals,
; concerts, weddings, and corporate events providing general liability, event
; cancellation, participant accident, and weather coverage.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.hospitality.special-event"
version = "1.0.0"
title = "Special Event Insurance Schema"
description = "Insurance for one-time and short-term special events"

{$derivation}
source[0].authority = "National Association of Insurance Commissioners (NAIC)"
source[0].citation = "Special Event Liability Insurance"
source[0].url = "https://content.naic.org/"

source[1].authority = "Insurance Services Office (ISO)"
source[1].citation = "Special Events Coverage Forms"
source[1].url = "https://www.verisk.com/insurance/"

source[2].authority = "International Festivals & Events Association"
source[2].citation = "Event Insurance Best Practices"
source[2].url = "https://www.ifea.com/"

source[3].authority = "Meeting Professionals International"
source[3].citation = "Event Risk Management Guidelines"
source[3].url = "https://www.mpi.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on NAIC and event industry insurance standards"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial special event insurance schema"
changelog[0].rationale = "Commercial hospitality coverage for special events"

; ===================================================================================
; Event Classification
; ===================================================================================

{@se_event_type}
event_category = !(
    athletic_competition,                     ; Races, tournaments
    carnival_fair,                            ; Carnival/fair
    charity_fundraiser,                       ; Charity event
    concert_festival,                         ; Music event
    convention_trade_show,                    ; Trade show
    corporate_meeting,                        ; Corporate event
    cultural_celebration,                     ; Cultural event
    film_screening,                           ; Film premiere
    graduation,                               ; Graduation ceremony
    holiday_celebration,                      ; Holiday event
    parade,                                   ; Parade/procession
    political_rally,                          ; Political event
    religious_gathering,                      ; Religious event
    reunion,                                  ; Class/family reunion
    social_party,                             ; Private party
    theatrical_performance,                   ; Theater/performance
    wedding                                   ; Wedding/reception
)

; Venue type
venue_type = (
    arena_stadium,                            ; Arena/stadium
    community_center,                         ; Community center
    conference_center,                        ; Conference venue
    fairgrounds,                              ; Fairgrounds
    hotel_ballroom,                           ; Hotel venue
    outdoor_park,                             ; Outdoor park
    private_estate,                           ; Private property
    religious_facility,                       ; Church/temple
    restaurant,                               ; Restaurant venue
    rented_hall,                              ; Rented hall
    school_campus,                            ; School/university
    street_public,                            ; Street/public space
    theater,                                  ; Theater
    waterfront                                ; Waterfront venue
)

; ===================================================================================
; Event Details
; ===================================================================================

{@se_event}
; Required fields first
event_name = !:                               ; Event name
event_type = !@se_event_type                  ; Event classification
expected_attendance = !##                     ; Expected attendees
organizer_name = !:                           ; Organizer/host

; Optional fields
address = @address                            ; Event address
admission_charged = ?                         ; Paid admission
admission_price = #$:(0..):if admission_charged = true
age_restricted = ?                            ; Age restrictions
alcohol_served = ?                            ; Alcohol service
alcohol_sold = ?:if alcohol_served = true     ; Alcohol sales
animals = ?                                   ; Animals present
amusement_devices = ?                         ; Rides/amusements
bouncy_houses = ?:if amusement_devices = true ; Inflatables
catering = ?                                  ; Food service
contact_email = *@email                       ; Contact email
contact_phone = *@phone                       ; Contact phone
dancing = ?                                   ; Dancing
email = *@email                               ; Organizer email
end_date = date                               ; End date
entertainment = ?                             ; Entertainment
event_id = :                                  ; Internal identifier
fireworks = ?                                 ; Fireworks
food_vendors = ##                             ; Food vendor count
gross_receipts = #$:(0..)                     ; Expected revenue
indoors = ?                                   ; Indoor event
live_music = ?                                ; Live music
minors_attending = ?                          ; Children present
outdoor = ?                                   ; Outdoor event
overnight = ?                                 ; Overnight event
parking = ?                                   ; Parking provided
phone = *@phone                               ; Organizer phone
private = ?                                   ; Private event
professional_catering = ?                     ; Professional caterer
public = ?                                    ; Open to public
pyrotechnics = ?                              ; Special effects
security = ?                                  ; Security provided
security_count = ##:if security = true        ; Security staff
setup_days = ##                               ; Setup/teardown days
sporting_activity = ?                         ; Sports activities
start_date = date                             ; Start date
start_time = :                                ; Start time
tent = ?                                      ; Tent/canopy
total_event_days = ##                         ; Duration in days
venue_name = :                                ; Venue name
vendors = ##                                  ; Total vendors
vip_area = ?                                  ; VIP section
volunteers = ##                               ; Volunteer count

; ===================================================================================
; General Liability Coverage
; ===================================================================================

{@se_liability}
; Required fields first
each_occurrence = !#$:(0..)                   ; Per occurrence limit
general_aggregate = !#$:(0..)                 ; Aggregate limit

; Optional fields
assault_battery = ?                           ; A&B coverage
assault_battery_limit = #$:(0..):if assault_battery = true
damage_to_rented_premises = #$:(0..)          ; Fire legal
deductible = #$:(0..)                         ; Liability deductible
host_liquor = ?                               ; Host liquor
liquor_liability = ?                          ; Liquor liability
liquor_limit = #$:(0..):if liquor_liability = true
medical_payments = #$:(0..)                   ; Med pay limit
personal_advertising_injury = #$:(0..)        ; Personal/advertising
products_completed = ?                        ; Products/completed ops
products_limit = #$:(0..):if products_completed = true

; ---------------------------------------------------------------------------
; Additional Insureds
; ---------------------------------------------------------------------------
{.additional_insureds}
included = ?                                  ; Additional insureds
municipality = ?:if included = true           ; City/municipality
sponsors[] = ::if included = true             ; Event sponsors
venue_owner = ?:if included = true            ; Venue owner/landlord
vendors = ?:if included = true                ; Vendor AI status

{@se_liability}

; ===================================================================================
; Event Cancellation Coverage
; ===================================================================================

{@se_cancellation}
included = ?                                  ; Cancellation coverage

; Coverage terms
adverse_weather = ?:if included = true        ; Weather cancellation
communicable_disease = ?:if included = true   ; Pandemic/disease
covered_expenses = #$:(0..):if included = true  ; Covered expenses
deductible = #$:(0..):if included = true      ; Deductible
failure_to_appear = ?:if included = true      ; No-show coverage
government_action = ?:if included = true      ; Government order
key_person = ?:if included = true             ; Key person coverage
limit = #$:(0..):if included = true           ; Coverage limit
natural_disaster = ?:if included = true       ; Natural disaster
non_appearance = ?:if included = true         ; Non-appearance
postponement = ?:if included = true           ; Postponement covered
terrorism = ?:if included = true              ; Terrorism
venue_damage = ?:if included = true           ; Venue unavailable

; ===================================================================================
; Participant Accident Coverage
; ===================================================================================

{@se_participant}
included = ?                                  ; Participant coverage

; Coverage terms
accidental_death = #$:(0..):if included = true    ; AD&D benefit
deductible = #$:(0..):if included = true      ; Deductible
dental = #$:(0..):if included = true          ; Dental expenses
excess_medical = ?:if included = true         ; Excess basis
medical_expense = #$:(0..):if included = true ; Medical expense
participant_count = ##:if included = true     ; Covered participants
primary_medical = ?:if included = true        ; Primary basis
spectators = ?:if included = true             ; Spectators covered
volunteers = ?:if included = true             ; Volunteers covered

; ===================================================================================
; Property Coverage
; ===================================================================================

{@se_property}
included = ?                                  ; Property coverage

; Equipment/displays
audio_visual = #$:(0..):if included = true    ; AV equipment
deductible = #$:(0..):if included = true      ; Property deductible
decorations = #$:(0..):if included = true     ; Decorations/displays
equipment = #$:(0..):if included = true       ; Event equipment
gifts_prizes = #$:(0..):if included = true    ; Gifts/prizes
hired_equipment = ?:if included = true        ; Rented equipment
limit = #$:(0..):if included = true           ; Total property limit
owned_equipment = ?:if included = true        ; Owned equipment
signage = #$:(0..):if included = true         ; Signs/banners
tents = #$:(0..):if included = true           ; Tents/structures

; ===================================================================================
; Premium Details
; ===================================================================================

{@se_premium}
; Required fields first
total_premium = !#$:(0..)                     ; Total premium

; Optional fields
cancellation_premium = #$:(0..)               ; Cancellation premium
liability_premium = #$:(0..)                  ; Liability premium
liquor_premium = #$:(0..)                     ; Liquor premium
minimum_premium = #$:(0..)                    ; Minimum premium
participant_premium = #$:(0..)                ; Participant premium
policy_fee = #$:(0..)                         ; Policy fee
property_premium = #$:(0..)                   ; Property premium
taxes_and_fees = #$:(0..)                     ; Taxes/fees

; ---------------------------------------------------------------------------
; Rating Factors
; ---------------------------------------------------------------------------
{.rating}
activities_factor = #                         ; Activity hazard
alcohol_factor = #                            ; Alcohol factor
attendance_factor = #                         ; Attendance tier
duration_factor = #                           ; Event length
event_type_factor = #                         ; Event type
venue_factor = #                              ; Venue type

{@se_premium}

; ===================================================================================
; Claims
; ===================================================================================

{@se_claim}
; Required fields first
claim_date = !date                            ; Claim date
claim_type = !(
    assault,                                  ; Assault/battery
    auto,                                     ; Auto incident
    bodily_injury,                            ; Attendee injury
    cancellation,                             ; Event cancellation
    equipment_damage,                         ; Equipment damage
    fire,                                     ; Fire damage
    food_poisoning,                           ; Food-borne illness
    liquor,                                   ; Liquor-related
    participant_injury,                       ; Participant injury
    property_damage,                          ; Property damage
    slip_fall,                                ; Slip and fall
    theft,                                    ; Theft
    vendor,                                   ; Vendor claim
    weather,                                  ; Weather damage
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
claimant_type = (
    attendee,
    employee,
    participant,
    spectator,
    vendor,
    volunteer
)
deductible_applied = #$:(0..)                 ; Deductible
description = :                               ; Description
incident_date = date                          ; Incident date
incident_location = :                         ; Where occurred
litigation = ?                                ; In litigation
reserve = #$:(0..)                            ; Reserve amount

; ===================================================================================
; Special Event Policy
; ===================================================================================

{@special_event_policy}
; Required fields first
effective_date = !date                        ; Coverage start date
event = !@se_event                            ; Event details
expiration_date = !date                       ; Coverage end date
liability = !@se_liability                    ; Liability coverage
policy_number = !:                            ; Policy number

; Invariants
:invariant expiration_date >= effective_date

; Optional fields
agency = @agency                              ; Issuing agency
cancellation = @se_cancellation               ; Cancellation coverage
claims[] = @se_claim                          ; Claims history
endorsements[] = :                            ; Policy endorsements
id = :                                        ; Internal identifier
participant = @se_participant                 ; Participant accident
policy_form = (
    event_pak,                                ; Event package
    manuscript,                               ; Manuscript form
    special_event                             ; Special event form
)
policy_status = (
    active,
    cancelled,
    expired,
    pending
)
premium = @se_premium                         ; Premium details
producer = @producer                          ; Agent
property = @se_property                       ; Property coverage
underwriting = @underwriting_decision         ; Underwriting

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
attendance = ##                               ; Expected attendance
cancellation_limit = #$:(0..)                 ; Cancellation limit
event_date = date                             ; Event date
event_name = :                                ; Event name
liability_limit = #$:(0..)                    ; Liability limit

{@special_event_policy}


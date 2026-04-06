; ===================================================================================
; ODIN Event Cancellation Insurance Schema
; ===================================================================================
; Event cancellation, postponement, and abandonment insurance for concerts, festivals,
; sporting events, conventions, and corporate events providing coverage for financial
; losses when events cannot proceed as planned.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.entertainment.event-cancellation"
version = "1.0.0"
title = "Event Cancellation Insurance Schema"
description = "Financial loss coverage for cancelled, postponed, or abandoned events"

{$derivation}
source[0].authority = "Lloyd's of London"
source[0].citation = "Contingency Insurance - Event Cancellation"
source[0].url = "https://www.lloyds.com/"

source[1].authority = "International Special Events Society"
source[1].citation = "Event Risk Management and Insurance"
source[1].url = "https://www.ises.com/"

source[2].authority = "Risk Management Society (RIMS)"
source[2].citation = "Event Cancellation Risk Guidelines"
source[2].url = "https://www.rims.org/"

source[3].authority = "Entertainment Industry Counsel"
source[3].citation = "Event Cancellation Insurance Standards"
source[3].url = "https://www.entertainmentlaw.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on Lloyd's contingency and event insurance standards"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial event cancellation insurance schema"
changelog[0].rationale = "Commercial entertainment coverage for event cancellation"

; ===================================================================================
; Event Classification
; ===================================================================================

{@ec_event_type}
category = !(
    awards_show,                              ; Awards ceremony
    charity_gala,                             ; Charity event
    concert,                                  ; Single concert
    conference,                               ; Conference/summit
    convention,                               ; Convention
    corporate_event,                          ; Corporate function
    exhibition,                               ; Exhibition/expo
    festival,                                 ; Multi-day festival
    marathon_race,                            ; Marathon/running
    political_event,                          ; Political rally
    premiere,                                 ; Film/show premiere
    religious_gathering,                      ; Religious event
    sporting_event,                           ; Sports event
    theatrical_production,                    ; Theater show
    tour,                                     ; Multi-venue tour
    trade_show,                               ; Trade show
    wedding                                   ; Wedding event
)

; Scale
scale = (
    intimate,                                 ; Under 500
    small,                                    ; 500-2,500
    medium,                                   ; 2,500-10,000
    large,                                    ; 10,000-50,000
    major,                                    ; 50,000-100,000
    mega                                      ; Over 100,000
)

; ===================================================================================
; Event Details
; ===================================================================================

{@ec_event}
; Required fields first
event_date = !date                            ; Primary event date
event_name = !:                               ; Event name
event_type = !@ec_event_type                  ; Event classification
expected_attendance = !##                     ; Expected attendance
organizer = !:                                ; Event organizer

; Optional fields
additional_dates[] = date                     ; Multi-day events
broadcast = ?                                 ; Broadcast/streaming
budget = #$:(0..)                             ; Total event budget
contact_email = *@email                       ; Contact email
contact_phone = *@phone                       ; Contact phone
end_date = date                               ; End date
event_id = :                                  ; Internal identifier
expenses_committed = #$:(0..)                 ; Committed costs
gross_receipts = #$:(0..)                     ; Expected revenue
headliner = :                                 ; Headline performer
indoor = ?                                    ; Indoor event
location_address = @address                   ; Event address
outdoor = ?                                   ; Outdoor event
rain_date = date                              ; Backup date
sponsorship_revenue = #$:(0..)                ; Sponsor revenue
ticket_price_avg = #$:(0..)                   ; Avg ticket price
ticket_revenue = #$:(0..)                     ; Ticket revenue
venue_capacity = ##                           ; Venue capacity
venue_name = :                                ; Venue name

; ---------------------------------------------------------------------------
; Key Persons/Performers
; ---------------------------------------------------------------------------
{.key_persons[]}
essential = ?                                 ; Essential to event
name = :                                      ; Person name
role = :                                      ; Role/position

{@ec_event}

; ===================================================================================
; Cancellation Coverage
; ===================================================================================

{@ec_cancellation}
; Required fields first
cancellation_limit = !#$:(0..)                ; Cancellation limit

; Optional fields
abandonment = ?                               ; Abandonment covered
aggregate = #$:(0..)                          ; Aggregate limit
communicable_disease = ?                      ; Pandemic/disease
curtailment = ?                               ; Curtailment covered
deductible = #$:(0..)                         ; Deductible
deductible_type = (flat, percentage, time)    ; Deductible type
denial_of_access = ?                          ; Denial of access
evacuation = ?                                ; Forced evacuation
failure_to_vacate = ?                         ; Prior event overrun
government_action = ?                         ; Government order
national_mourning = ?                         ; National mourning
non_appearance = ?                            ; Non-appearance
postponement = ?                              ; Postponement covered
relocation = ?                                ; Relocation covered
strike = ?                                    ; Strike/labor dispute
terrorism = ?                                 ; Terrorism
venue_damage = ?                              ; Venue damage

; ---------------------------------------------------------------------------
; Covered Expenses
; ---------------------------------------------------------------------------
{.covered_expenses}
advertising = ?                               ; Advertising costs
artist_fees = ?                               ; Performer fees
catering = ?                                  ; Catering costs
equipment_rental = ?                          ; Equipment rental
fixed_costs = ?                               ; Fixed overhead
lost_profit = ?                               ; Lost profit
production_costs = ?                          ; Production costs
refund_costs = ?                              ; Ticket refund admin
security = ?                                  ; Security costs
staff_costs = ?                               ; Staff/crew costs
venue_rental = ?                              ; Venue rental

{@ec_cancellation}

; ===================================================================================
; Weather Coverage
; ===================================================================================

{@ec_weather}
included = ?                                  ; Weather coverage

; Coverage terms
adverse_weather = ?:if included = true        ; Adverse weather
deductible = #$:(0..):if included = true      ; Deductible
extreme_heat = ?:if included = true           ; Extreme heat
fog = ?:if included = true                    ; Fog
frost = ?:if included = true                  ; Frost/freeze
hail = ?:if included = true                   ; Hail
hurricane = ?:if included = true              ; Hurricane
lightning = ?:if included = true              ; Lightning
limit = #$:(0..):if included = true           ; Weather limit
measurement_station = ::if included = true    ; Weather station
rain = ?:if included = true                   ; Rain/precipitation
rain_threshold = ::if included = true         ; Precipitation trigger
snow = ?:if included = true                   ; Snow
temperature_high = ##:if included = true      ; High temp trigger
temperature_low = ##:if included = true       ; Low temp trigger
tornado = ?:if included = true                ; Tornado
wind = ?:if included = true                   ; High wind
wind_threshold = ##:if included = true        ; Wind speed trigger

; ===================================================================================
; Non-Appearance Coverage
; ===================================================================================

{@ec_non_appearance}
included = ?                                  ; Non-appearance coverage

; Coverage terms
accident = ?:if included = true               ; Accident cause
civil_authority = ?:if included = true        ; Travel restriction
covered_persons[] = ::if included = true      ; Covered performers
death = ?:if included = true                  ; Death
deductible = #$:(0..):if included = true      ; Deductible
illness = ?:if included = true                ; Illness
kidnap = ?:if included = true                 ; Kidnap/detention
limit = #$:(0..):if included = true           ; Coverage limit
medical_exam = ?:if included = true           ; Medical exam required
quarantine = ?:if included = true             ; Quarantine
travel_delay = ?:if included = true           ; Travel delay
weather_delay = ?:if included = true          ; Weather delay

; ===================================================================================
; Prize Indemnity (if applicable)
; ===================================================================================

{@ec_prize}
included = ?                                  ; Prize coverage

; Coverage terms
deductible = #$:(0..):if included = true      ; Deductible
hole_in_one = ?:if included = true            ; Hole-in-one
limit = #$:(0..):if included = true           ; Prize limit
performance_contest = ?:if included = true    ; Performance-based
prize_description = ::if included = true      ; Prize details
random_drawing = ?:if included = true         ; Random drawing

; ===================================================================================
; Premium Details
; ===================================================================================

{@ec_premium}
; Required fields first
total_premium = !#$:(0..)                     ; Total premium

; Optional fields
cancellation_premium = #$:(0..)               ; Cancellation premium
minimum_premium = #$:(0..)                    ; Minimum premium
non_appearance_premium = #$:(0..)             ; Non-appearance
policy_fee = #$:(0..)                         ; Policy fee
prize_premium = #$:(0..)                      ; Prize indemnity
taxes_and_fees = #$:(0..)                     ; Taxes/fees
weather_premium = #$:(0..)                    ; Weather premium

; ---------------------------------------------------------------------------
; Rating Factors
; ---------------------------------------------------------------------------
{.rating}
attendance_factor = #                         ; Attendance tier
event_type_factor = #                         ; Event type
location_factor = #                           ; Location rating
outdoor_factor = #                            ; Indoor/outdoor
prior_cancellation = #                        ; Prior cancellations
season_factor = #                             ; Season/time of year

{@ec_premium}

; ===================================================================================
; Exclusions
; ===================================================================================

{@ec_exclusions}
; Standard exclusions
bankruptcy = ?true                            ; Financial default
known_circumstances = ?true                   ; Known conditions
lack_of_funds = ?true                         ; Insufficient funds
lack_of_interest = ?true                      ; Poor ticket sales
nuclear = ?true                               ; Nuclear
war = ?true                                   ; War (may have buy-back)
wear_and_tear = ?true                         ; Normal wear

; Event-specific exclusions
failure_to_obtain_permit = ?                  ; Permit failure
mechanical_breakdown = ?                      ; Equipment failure
regulatory_change = ?                         ; Regulation change
voluntary_cancellation = ?                    ; Voluntary cancel

; ===================================================================================
; Claims
; ===================================================================================

{@ec_claim}
; Required fields first
claim_date = !date                            ; Claim date
claim_type = !(
    abandonment,                              ; Event abandoned
    cancellation,                             ; Full cancellation
    curtailment,                              ; Early termination
    denial_of_access,                         ; Access denied
    non_appearance,                           ; Performer no-show
    postponement,                             ; Event postponed
    relocation,                               ; Venue change
    weather,                                  ; Weather event
    other                                     ; Other
)

; Optional fields
amount_claimed = #$:(0..)                     ; Amount claimed
amount_paid = #$:(0..)                        ; Amount paid
cause = :                                     ; Cause of loss
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
event_date_affected = date                    ; Affected event date
expenses_incurred = #$:(0..)                  ; Actual expenses
lost_revenue = #$:(0..)                       ; Revenue lost
new_date = date                               ; Rescheduled date
reserve = #$:(0..)                            ; Reserve amount

; ===================================================================================
; Event Cancellation Policy
; ===================================================================================

{@event_cancel_policy}
; Required fields first
cancellation = !@ec_cancellation              ; Cancellation coverage
effective_date = !date                        ; Policy effective date
event = !@ec_event                            ; Event details
expiration_date = !date                       ; Policy expiration date
policy_number = !:                            ; Policy number

; Invariants
:invariant expiration_date >= effective_date

; Optional fields
agency = @agency                              ; Issuing agency
claims[] = @ec_claim                          ; Claims history
endorsements[] = :                            ; Policy endorsements
exclusions = @ec_exclusions                   ; Exclusions
id = :                                        ; Internal identifier
non_appearance = @ec_non_appearance           ; Non-appearance coverage
policy_form = (
    multi_event,                              ; Multiple events
    single_event,                             ; Single event
    tour                                      ; Tour policy
)
policy_status = (
    active,
    cancelled,
    expired,
    pending
)
premium = @ec_premium                         ; Premium details
prize = @ec_prize                             ; Prize indemnity
producer = @producer                          ; Agent
underwriting = @underwriting_decision         ; Underwriting
weather = @ec_weather                         ; Weather coverage

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
cancellation_limit = #$:(0..)                 ; Cancellation limit
event_budget = #$:(0..)                       ; Event budget
event_date = date                             ; Event date
event_name = :                                ; Event name

{@event_cancel_policy}


; ===================================================================================
; ODIN Sports Insurance Schema
; ===================================================================================
; Sports insurance for professional and amateur teams, leagues, athletic facilities,
; and event organizers covering participant accident, spectator liability, sexual
; abuse/molestation, sports accident medical, and athlete disability.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.entertainment.sports"
version = "1.0.0"
title = "Sports Insurance Schema"
description = "Insurance for sports organizations, teams, and athletic operations"

{$derivation}
source[0].authority = "National Association of Insurance Commissioners (NAIC)"
source[0].citation = "Sports and Recreation Insurance Guidelines"
source[0].url = "https://content.naic.org/"

source[1].authority = "National Council of Youth Sports"
source[1].citation = "Youth Sports Risk Management Standards"
source[1].url = "https://www.ncys.org/"

source[2].authority = "Sports and Fitness Industry Association"
source[2].citation = "Sports Industry Insurance Best Practices"
source[2].url = "https://www.sfia.org/"

source[3].authority = "Risk Management for Sports Organizations"
source[3].citation = "Sports Liability and Insurance"
source[3].url = "https://www.sportslawexpert.com/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on NAIC and sports industry insurance standards"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial sports insurance schema"
changelog[0].rationale = "Commercial entertainment coverage for sports organizations"

; ===================================================================================
; Organization Classification
; ===================================================================================

{@sp_org_type}
organization_class = (
    amateur_league,                           ; Amateur sports league
    college_athletics,                        ; College/university
    event_organizer,                          ; Sports event org
    fitness_center,                           ; Gym/fitness
    high_school,                              ; High school athletics
    individual_athlete,                       ; Individual pro
    martial_arts,                             ; Martial arts studio
    professional_league,                      ; Pro league
    professional_team,                        ; Pro team
    recreation_center,                        ; Rec center
    ski_resort,                               ; Ski/snowboard resort
    sports_camp,                              ; Camp/clinic
    stadium_arena,                            ; Venue operator
    youth_league                              ; Youth sports
)

; Sport type
sport = (
    baseball_softball,                        ; Baseball/softball
    basketball,                               ; Basketball
    boxing_mma,                               ; Combat sports
    cheerleading,                             ; Cheerleading
    cycling,                                  ; Cycling
    dance,                                    ; Dance
    equestrian,                               ; Horse sports
    football,                                 ; Football
    golf,                                     ; Golf
    gymnastics,                               ; Gymnastics
    hockey,                                   ; Hockey
    lacrosse,                                 ; Lacrosse
    martial_arts,                             ; Martial arts
    motorsports,                              ; Racing
    multi_sport,                              ; Multiple sports
    skiing_snowboard,                         ; Winter sports
    soccer,                                   ; Soccer
    swimming,                                 ; Aquatics
    tennis,                                   ; Tennis
    track_field,                              ; Track and field
    volleyball,                               ; Volleyball
    wrestling,                                ; Wrestling
    other                                     ; Other
)

; Level of play
level = (
    elite,                                    ; Elite/Olympic
    junior,                                   ; Junior/youth
    professional,                             ; Professional
    recreational,                             ; Recreational
    semi_pro                                  ; Semi-professional
)

; ===================================================================================
; Sports Organization
; ===================================================================================

{@sp_organization}
; Required fields first
organization_name = :                        ; Organization name
organization_type = @sp_org_type             ; Organization class
participant_count = ##                       ; Registered participants

; Optional fields
address = @address                            ; Primary address
age_range = :                                 ; Age range served
annual_revenue = #$:(0..)                     ; Annual revenue
coach_count = ##                              ; Coaches/instructors
contact_email = *@email                       ; Contact email
contact_phone = *@phone                       ; Contact phone
contact_sports = ?                            ; Contact sports
equipment_value = #$:(0..)                    ; Equipment value
events_per_year = ##                          ; Annual events
facilities[] = :                              ; Facility locations
fein = *:                                     ; Tax ID
governing_body = :                            ; Governing association
minors = ?                                    ; Minor participants
nonprofit = ?                                 ; Non-profit status
organization_id = :                           ; Internal identifier
overnight_travel = ?                          ; Overnight trips
season_months = ##                            ; Season length
spectator_events = ?                          ; Spectator events
team_count = ##                               ; Number of teams
volunteer_count = ##                          ; Volunteers
year_established = ##                         ; Year founded

; ===================================================================================
; General Liability
; ===================================================================================

{@sp_liability}
; Required fields first
each_occurrence = #$:(0..)                   ; Per occurrence limit
general_aggregate = #$:(0..)                 ; Aggregate limit

; Optional fields
abuse_molestation = ?                         ; Sexual abuse coverage
abuse_limit = #$:(0..):if abuse_molestation = true
athletic_participation = ?                    ; Participation liability
concussion = ?                                ; Concussion protocol
damage_to_premises = #$:(0..)                 ; Fire legal
deductible = #$:(0..)                         ; Liability deductible
employers_liability = ?                       ; EL coverage
el_limit = #$:(0..):if employers_liability = true
excess_umbrella = ?                           ; Excess/umbrella
excess_limit = #$:(0..):if excess_umbrella = true
host_liquor = ?                               ; Host liquor
medical_payments = #$:(0..)                   ; Med pay limit
personal_advertising_injury = #$:(0..)        ; Personal/advertising
products_completed = ?                        ; Products/completed ops
spectator = ?                                 ; Spectator liability

; ===================================================================================
; Participant Accident
; ===================================================================================

{@sp_participant}
included = ?                                  ; Participant coverage

; Coverage terms
accidental_death = #$:(0..):if included = true    ; AD&D benefit
catastrophic = ?:if included = true           ; Catastrophic injury
deductible = #$:(0..):if included = true      ; Deductible
dental = #$:(0..):if included = true          ; Dental expense
disability_weekly = #$:(0..):if included = true   ; Weekly disability
excess_medical = ?:if included = true         ; Excess coverage
medical_expense = #$:(0..):if included = true ; Medical expense
participant_count = ##:if included = true     ; Covered participants
primary_medical = ?:if included = true        ; Primary coverage
rehabilitation = ?:if included = true         ; Rehab expenses
surgical = #$:(0..):if included = true        ; Surgical expense

; ---------------------------------------------------------------------------
; Coverage Trigger
; ---------------------------------------------------------------------------
{.trigger}
competition = ?:if included = true            ; Competition
practice = ?:if included = true               ; Practice
sanctioned_events = ?:if included = true      ; Sanctioned events
travel = ?:if included = true                 ; Travel to/from

{@sp_participant}

; ===================================================================================
; Directors & Officers
; ===================================================================================

{@sp_do}
included = ?                                  ; D&O coverage

; Coverage terms
aggregate = #$:(0..):if included = true       ; Aggregate limit
deductible = #$:(0..):if included = true      ; Deductible
defense_costs = (included, supplementary):if included = true
employment_practices = ?:if included = true   ; EPL coverage
fiduciary = ?:if included = true              ; Fiduciary liability
limit = #$:(0..):if included = true           ; Per claim limit
prior_acts = ?:if included = true             ; Prior acts
third_party_epl = ?:if included = true        ; Third-party EPL

; ===================================================================================
; Professional Athlete Coverage
; ===================================================================================

{@sp_athlete}
; For individual professional athletes
included = ?                                  ; Athlete coverage

; Career protection
disability = ?:if included = true             ; Disability coverage
disability_monthly = #$:(0..):if disability = true
disability_term_years = ##:if disability = true
loss_of_value = ?:if included = true          ; Loss of value
medical_exam = ?:if included = true           ; Medical required
permanent_total = ?:if included = true        ; PTD coverage
ptd_limit = #$:(0..):if permanent_total = true
temporary_total = ?:if included = true        ; TTD coverage

; ===================================================================================
; Equipment Coverage
; ===================================================================================

{@sp_equipment}
included = ?                                  ; Equipment coverage

; Coverage terms
all_risk = ?:if included = true               ; All-risk form
deductible = #$:(0..):if included = true      ; Deductible
hired_equipment = #$:(0..):if included = true ; Rented equipment
limit = #$:(0..):if included = true           ; Coverage limit
mysterious_disappearance = ?:if included = true
owned_equipment = #$:(0..):if included = true ; Owned equipment
replacement_cost = ?:if included = true       ; RC valuation
transit = ?:if included = true                ; Transit coverage

; ===================================================================================
; Facility Coverage
; ===================================================================================

{@sp_facility}
included = ?                                  ; Facility coverage

; Property coverage
building = #$:(0..):if included = true        ; Building coverage
business_interruption = ?:if included = true  ; BI coverage
contents = #$:(0..):if included = true        ; Contents/equipment
deductible = #$:(0..):if included = true      ; Property deductible
earthquake = ?:if included = true             ; Earthquake
equipment_breakdown = ?:if included = true    ; Equipment breakdown
flood = ?:if included = true                  ; Flood
playing_surface = #$:(0..):if included = true ; Field/court surface
signage = #$:(0..):if included = true         ; Signage
windstorm = ?:if included = true              ; Windstorm

; ===================================================================================
; Premium Details
; ===================================================================================

{@sp_premium}
; Required fields first
total_premium = #$:(0..)                     ; Total premium

; Optional fields
athlete_premium = #$:(0..)                    ; Athlete coverage
do_premium = #$:(0..)                         ; D&O premium
equipment_premium = #$:(0..)                  ; Equipment premium
facility_premium = #$:(0..)                   ; Facility premium
liability_premium = #$:(0..)                  ; Liability premium
minimum_premium = #$:(0..)                    ; Minimum premium
participant_premium = #$:(0..)                ; Participant accident
policy_fee = #$:(0..)                         ; Policy fee
taxes_and_fees = #$:(0..)                     ; Taxes/fees

; ---------------------------------------------------------------------------
; Rating Factors
; ---------------------------------------------------------------------------
{.rating}
age_factor = #                                ; Age group factor
claims_experience = #                         ; Experience mod
contact_factor = #                            ; Contact sport factor
level_factor = #                              ; Level of play
participant_factor = #                        ; Participant count
sport_factor = #                              ; Sport hazard

{@sp_premium}

; ===================================================================================
; Claims
; ===================================================================================

{@sp_claim}
; Required fields first
claim_date = date                            ; Claim date
claim_type = (
    abuse,                                    ; Sexual abuse
    auto,                                     ; Auto accident
    bodily_injury,                            ; BI claim
    concussion,                               ; Concussion
    death,                                    ; Wrongful death
    do_claim,                                 ; D&O claim
    equipment_damage,                         ; Equipment damage
    facility_damage,                          ; Facility damage
    heat_illness,                             ; Heat-related
    participant_injury,                       ; Participant injury
    property_damage,                          ; Property damage
    spectator_injury,                         ; Spectator injury
    wrongful_act,                             ; Wrongful act
    other                                     ; Other
)

; Optional fields
activity = :                                  ; Activity at time
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
claimant_name = *:                            ; Claimant name
claimant_type = (
    coach,
    parent,
    participant,
    spectator,
    third_party,
    volunteer
)
deductible_applied = #$:(0..)                 ; Deductible
description = :                               ; Description
incident_date = date                          ; Incident date
incident_location = :                         ; Where occurred
injury_type = :                               ; Injury description
litigation = ?                                ; In litigation
reserve = #$:(0..)                            ; Reserve amount
sport = :                                     ; Sport involved

; ===================================================================================
; Sports Insurance Policy
; ===================================================================================

{@sports_policy}
; Required fields first
effective_date = date                        ; Policy effective date
expiration_date = date                       ; Policy expiration date
liability = @sp_liability                    ; General liability
organization = @sp_organization              ; Insured organization
policy_number = :                            ; Policy number

; Invariants
:invariant expiration_date > effective_date

; Optional fields
agency = @agency                              ; Issuing agency
athlete = @sp_athlete                         ; Athlete coverage
claims[] = @sp_claim                          ; Claims history
do = @sp_do                                   ; D&O coverage
endorsements[] = :                            ; Policy endorsements
equipment = @sp_equipment                     ; Equipment coverage
facility = @sp_facility                       ; Facility coverage
id = :                                        ; Internal identifier
participant = @sp_participant                 ; Participant accident
policy_form = (
    annual,                                   ; Annual policy
    event,                                    ; Single event
    seasonal                                  ; Seasonal policy
)
policy_status = (
    active,
    cancelled,
    expired,
    non_renewed,
    pending
)
premium = @sp_premium                         ; Premium details
producer = @producer                          ; Agent
underwriting = @underwriting_decision         ; Underwriting

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
liability_limit = #$:(0..)                    ; GL limit
organization_name = :                         ; Organization name
participant_count = ##                        ; Participants
sport = :                                     ; Primary sport

{@sports_policy}


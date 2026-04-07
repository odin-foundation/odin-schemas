; ===================================================================================
; ODIN Prize Indemnity Insurance Schema
; ===================================================================================
; Prize indemnity insurance covering financial exposure from promotional contests,
; sweepstakes, hole-in-one competitions, and other events where a specified
; outcome triggers a large predetermined payout.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.specialty.prize-indemnity"
version = "1.0.0"
title = "Prize Indemnity Insurance Schema"
description = "Coverage for promotional contest prize obligations"

{$derivation}
source[0].authority = "Insurance Services Office (ISO)"
source[0].citation = "Prize Indemnification Coverage"
source[0].url = "https://www.verisk.com/insurance/"

source[1].authority = "Hole In One International"
source[1].citation = "Golf Prize Insurance Standards"
source[1].url = "https://www.holeinoneinternational.com/"

source[2].authority = "Promotional Marketing Association"
source[2].citation = "Contest Insurance Best Practices"
source[2].url = "https://www.promomarketing.com/"

source[3].authority = "Federal Trade Commission"
source[3].citation = "Contest and Sweepstakes Regulations"
source[3].url = "https://www.ftc.gov/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on promotional industry and prize insurance standards"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial prize indemnity insurance schema"
changelog[0].rationale = "Specialty coverage for promotional prize obligations"

; ===================================================================================
; Sponsor/Promoter
; ===================================================================================

{@prize_sponsor}
; Required fields first
sponsor_name = !:                             ; Sponsor/promoter name
sponsor_type = !(
    advertiser,                               ; Advertising agency
    brand,                                    ; Brand/manufacturer
    casino,                                   ; Casino/gaming
    charity,                                  ; Charity/nonprofit
    corporation,                              ; Corporation
    dealer,                                   ; Auto dealer
    event_organizer,                          ; Event organizer
    golf_course,                              ; Golf course
    media,                                    ; Media company
    promotion_company,                        ; Promo company
    retailer,                                 ; Retailer
    sports_team                               ; Sports team
)

; Optional fields
address = @address                            ; Sponsor address
contact_email = *@email                       ; Contact email
contact_phone = *@phone                       ; Contact phone
fein = *:                                     ; Tax ID
sponsor_id = :                                ; Internal identifier
years_in_business = ##                        ; Years operating

; ===================================================================================
; Contest Details
; ===================================================================================

{@prize_contest}
; Required fields first
contest_name = !:                             ; Contest name
contest_type = !(
    basketball_shot,                          ; Half-court shot
    dice_roll,                                ; Dice roll
    drawing,                                  ; Random drawing
    football_throw,                           ; Football throw
    golf_hole_in_one,                         ; Hole-in-one
    hockey_shot,                              ; Hockey shot
    instant_win,                              ; Scratch/instant
    performance,                              ; Performance-based
    prediction,                               ; Prediction contest
    putting,                                  ; Putting contest
    skill_based,                              ; Skill contest
    spin_wheel,                               ; Wheel spin
    sweepstakes                               ; Sweepstakes
)
grand_prize_value = !#$:(0..)                 ; Grand prize value

; Optional fields
bonus_prizes[] = #$:(0..)                     ; Bonus prize values
contest_date = date                           ; Contest date
contest_id = :                                ; Internal identifier
duration_days = ##                            ; Contest duration
eligible_participants = ##                    ; Expected entries
end_date = date                               ; End date
entry_fee = #$:(0..)                          ; Entry fee
estimated_attempts = ##                       ; Estimated attempts
event_name = :                                ; Associated event
location = :                                  ; Contest location
multiple_winners = ?                          ; Multiple winners
prize_description = :                         ; Prize description
secondary_prizes[] = #$:(0..)                 ; Secondary prizes
start_date = date                             ; Start date
total_prize_pool = #$:(0..)                   ; Total prizes

; ---------------------------------------------------------------------------
; Contest Parameters (Golf)
; ---------------------------------------------------------------------------
{.golf}
distance_yards = ##:if contest_type = (golf_hole_in_one, putting)
elevation_change = (downhill, level, uphill):if contest_type = golf_hole_in_one
green_speed = #:if contest_type = putting     ; Stimp reading
hole_number = ##:if contest_type = golf_hole_in_one
par = ##:if contest_type = golf_hole_in_one
professional_event = ?:if contest_type = (golf_hole_in_one, putting)
putting_distance_feet = ##:if contest_type = putting

{@prize_contest}

; ---------------------------------------------------------------------------
; Contest Parameters (Basketball)
; ---------------------------------------------------------------------------
{.basketball}
attempt_time_seconds = ##:if contest_type = basketball_shot
court_type = (college, nba, outdoor):if contest_type = basketball_shot
distance_feet = ##:if contest_type = basketball_shot
shot_type = (free_throw, half_court, three_point):if contest_type = basketball_shot

{@prize_contest}

; ---------------------------------------------------------------------------
; Contest Parameters (Random)
; ---------------------------------------------------------------------------
{.random}
number_range = ##:if contest_type = (dice_roll, spin_wheel)
odds = #:if contest_type = (instant_win, sweepstakes)
total_entries = ##:if contest_type = (drawing, sweepstakes)
winning_numbers = ##:if contest_type = dice_roll

{@prize_contest}

; ===================================================================================
; Prize Coverage
; ===================================================================================

{@prize_coverage}
; Required fields first
grand_prize_limit = !#$:(0..)                 ; Grand prize indemnity

; Optional fields
aggregate_limit = #$:(0..)                    ; Total aggregate
bonus_coverage = ?                            ; Bonus prizes covered
bonus_limit = #$:(0..):if bonus_coverage = true
deductible = #$:(0..)                         ; Deductible
multiple_winner = ?                           ; Multiple winners
multiple_limit = #$:(0..):if multiple_winner = true
progressive_coverage = ?                      ; Progressive jackpot
progressive_limit = #$:(0..):if progressive_coverage = true
secondary_coverage = ?                        ; Secondary prizes
secondary_limit = #$:(0..):if secondary_coverage = true

; Coverage terms
contest_cancelled = ?                         ; Cancellation coverage
judging_disputes = ?                          ; Judging covered
tie_breaker = ?                               ; Tie-breaker covered
verification_period_days = ##                 ; Verification period

; ===================================================================================
; Premium Details
; ===================================================================================

{@prize_premium}
; Required fields first
total_premium = !#$:(0..)                     ; Total premium

; Optional fields
bonus_premium = #$:(0..)                      ; Bonus coverage
minimum_premium = #$:(0..)                    ; Minimum premium
policy_fee = #$:(0..)                         ; Policy fee
secondary_premium = #$:(0..)                  ; Secondary prizes
taxes_and_fees = #$:(0..)                     ; Taxes/fees

; ---------------------------------------------------------------------------
; Rating Factors
; ---------------------------------------------------------------------------
{.rating}
attempts_factor = #                           ; Number of attempts
contest_type_factor = #                       ; Contest type
difficulty_factor = #                         ; Difficulty
odds_factor = #                               ; Winning odds
prize_factor = #                              ; Prize value

{@prize_premium}

; ===================================================================================
; Claims
; ===================================================================================

{@prize_claim}
; Required fields first
claim_date = !date                            ; Claim date
prize_type = !(
    bonus,                                    ; Bonus prize
    grand_prize,                              ; Grand prize
    progressive,                              ; Progressive jackpot
    secondary                                 ; Secondary prize
)
winner_name = !*:                             ; Winner name

; Optional fields
amount_claimed = #$:(0..)                     ; Amount claimed
amount_paid = #$:(0..)                        ; Amount paid
claim_id = :                                  ; Claim ID
claim_status = (
    closed,
    denied,
    open,
    paid,
    verification
)
contest_reference = :                         ; Contest ID
deductible_applied = #$:(0..)                 ; Deductible
description = :                               ; Description
incident_date = date                          ; Win date
prize_description = :                         ; Prize won
reserve = #$:(0..)                            ; Reserve amount
verification_complete = ?                     ; Verified
video_confirmation = ?                        ; Video proof
witness_count = ##                            ; Witnesses

; ===================================================================================
; Prize Indemnity Policy
; ===================================================================================

{@prize_policy}
; Required fields first
contest = !@prize_contest                     ; Contest details
coverage = !@prize_coverage                   ; Coverage terms
effective_date = !date                        ; Policy effective date
expiration_date = !date                       ; Policy expiration date
policy_number = !:                            ; Policy number
sponsor = !@prize_sponsor                     ; Sponsor details

; Invariants
:invariant expiration_date >= effective_date

; Optional fields
agency = @agency                              ; Issuing agency
claims[] = @prize_claim                       ; Claims history
endorsements[] = :                            ; Policy endorsements
id = :                                        ; Internal identifier
policy_form = (
    event,                                    ; Single event
    program,                                  ; Multi-event program
    seasonal                                  ; Seasonal coverage
)
policy_status = (
    active,
    cancelled,
    expired,
    pending
)
premium = @prize_premium                      ; Premium details
producer = @producer                          ; Agent
underwriting = @underwriting_decision         ; Underwriting

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
contest_name = :                              ; Contest name
contest_type = :                              ; Contest type
grand_prize = #$:(0..)                        ; Grand prize value
sponsor_name = :                              ; Sponsor name

{@prize_policy}


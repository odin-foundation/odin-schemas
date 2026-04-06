; ===================================================================================
; ODIN Contingency Insurance Schema
; ===================================================================================
; Contingency insurance covering financial losses from uncertain future events
; including prize indemnity, contest/sweepstakes, weather, event cancellation,
; and overredemption for promotional campaigns.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.specialty.contingency"
version = "1.0.0"
title = "Contingency Insurance Schema"
description = "Coverage for financial losses from contingent events"

{$derivation}
source[0].authority = "Lloyd's of London"
source[0].citation = "Contingency and Special Risks Market"
source[0].url = "https://www.lloyds.com/"

source[1].authority = "International Risk Management Institute (IRMI)"
source[1].citation = "Contingency Insurance Coverage"
source[1].url = "https://www.irmi.com/"

source[2].authority = "Risk Management Society (RIMS)"
source[2].citation = "Contingency Risk Guidelines"
source[2].url = "https://www.rims.org/"

source[3].authority = "National Association of Insurance Commissioners"
source[3].citation = "Specialty Lines - Contingency Insurance"
source[3].url = "https://content.naic.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on Lloyd's contingency market and specialty insurance standards"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial contingency insurance schema"
changelog[0].rationale = "Specialty coverage for contingent financial exposures"

; ===================================================================================
; Insured Entity
; ===================================================================================

{@contingent_insured}
; Required fields first
insured_name = !:                             ; Entity name
insured_type = !(
    advertiser,                               ; Advertiser
    broadcaster,                              ; Broadcaster
    charity,                                  ; Charity/nonprofit
    corporation,                              ; Corporation
    entertainment,                            ; Entertainment company
    event_organizer,                          ; Event organizer
    gaming,                                   ; Gaming company
    manufacturer,                             ; Manufacturer
    media,                                    ; Media company
    promoter,                                 ; Promoter
    retailer,                                 ; Retailer
    sports_organization,                      ; Sports org
    studio                                    ; Film/TV studio
)

; Optional fields
address = @address                            ; Address
contact_email = *@email                       ; Contact email
contact_phone = *@phone                       ; Contact phone
fein = *:                                     ; Tax ID
insured_id = :                                ; Internal identifier

; ===================================================================================
; Contingent Event
; ===================================================================================

{@contingent_event}
; Required fields first
event_description = !:                        ; Event description
event_type = !(
    award_ceremony,                           ; Award show
    bonus_program,                            ; Bonus/incentive
    contest,                                  ; Contest/competition
    death_disgrace,                           ; Death/disgrace
    event_cancellation,                       ; Event cancellation
    incentive,                                ; Sales incentive
    non_appearance,                           ; Non-appearance
    over_redemption,                          ; Coupon/redemption
    performance,                              ; Performance bonus
    prize,                                    ; Prize indemnity
    promotion,                                ; Promotional event
    sports_performance,                       ; Sports achievement
    weather                                   ; Weather contingency
)
maximum_exposure = !#$:(0..)                  ; Maximum financial exposure

; Optional fields
contingency_date = date                       ; Event/trigger date
contingency_period_end = date                 ; Period end
contingency_period_start = date               ; Period start
event_id = :                                  ; Internal identifier
location = :                                  ; Event location
trigger_description = :                       ; What triggers payout
verification_method = :                       ; How verified

; ===================================================================================
; Contingency Coverage
; ===================================================================================

{@contingent_coverage}
; Required fields first
coverage_type = !(
    cancellation,                             ; Cancellation/postponement
    death_disgrace,                           ; Death/disgrace
    incentive,                                ; Incentive program
    non_appearance,                           ; Non-appearance
    over_redemption,                          ; Over-redemption
    performance,                              ; Performance achievement
    prize,                                    ; Prize indemnity
    weather                                   ; Weather contingency
)
limit = !#$:(0..)                             ; Coverage limit

; Optional fields
aggregate = #$:(0..)                          ; Aggregate limit
co_insurance = #:(0..100)                     ; Co-insurance %
deductible = #$:(0..)                         ; Deductible
excess = #$:(0..)                             ; Excess amount
waiting_period_days = ##                      ; Waiting period

; ---------------------------------------------------------------------------
; Death/Disgrace Coverage
; ---------------------------------------------------------------------------
{.death_disgrace}
included = ?:if coverage_type = death_disgrace
covered_persons[] = ::if included = true      ; Named individuals
death = ?:if included = true                  ; Death covered
disability = ?:if included = true             ; Disability covered
disgrace = ?:if included = true               ; Disgrace covered
kidnap = ?:if included = true                 ; Kidnap covered
limit = #$:(0..):if included = true           ; DD limit
medical_exam = ?:if included = true           ; Medical required

{@contingent_coverage}

; ---------------------------------------------------------------------------
; Non-Appearance Coverage
; ---------------------------------------------------------------------------
{.non_appearance}
included = ?:if coverage_type = non_appearance
accident = ?:if included = true               ; Accident cause
covered_persons[] = ::if included = true      ; Named individuals
death = ?:if included = true                  ; Death cause
illness = ?:if included = true                ; Illness cause
limit = #$:(0..):if included = true           ; NA limit
travel_delay = ?:if included = true           ; Travel delay

{@contingent_coverage}

; ---------------------------------------------------------------------------
; Over-Redemption Coverage
; ---------------------------------------------------------------------------
{.over_redemption}
included = ?:if coverage_type = over_redemption
base_redemption = ##:if included = true       ; Expected redemption
coupon_value = #$:(0..):if included = true    ; Per-coupon value
limit = #$:(0..):if included = true           ; Over-redemption limit
redemption_threshold = ##:if included = true  ; Threshold %
total_coupons = ##:if included = true         ; Total distributed

{@contingent_coverage}

; ---------------------------------------------------------------------------
; Incentive Program Coverage
; ---------------------------------------------------------------------------
{.incentive}
included = ?:if coverage_type = (incentive, performance)
achievement_threshold = #:if included = true  ; Achievement level
limit = #$:(0..):if included = true           ; Incentive limit
participants = ##:if included = true          ; Participant count
payout_per_achievement = #$:(0..):if included = true
program_description = ::if included = true    ; Program details

{@contingent_coverage}

; ===================================================================================
; Premium Details
; ===================================================================================

{@contingent_premium}
; Required fields first
total_premium = !#$:(0..)                     ; Total premium

; Optional fields
minimum_premium = #$:(0..)                    ; Minimum premium
policy_fee = #$:(0..)                         ; Policy fee
taxes_and_fees = #$:(0..)                     ; Taxes/fees

; Pricing components
actuarial_premium = #$:(0..)                  ; Actuarial rate
broker_fee = #$:(0..)                         ; Broker fee
risk_load = #$:(0..)                          ; Risk load

; ---------------------------------------------------------------------------
; Rating Factors
; ---------------------------------------------------------------------------
{.rating}
exposure_factor = #                           ; Exposure amount
historical_factor = #                         ; Historical data
probability_factor = #                        ; Event probability
term_factor = #                               ; Coverage term

{@contingent_premium}

; ===================================================================================
; Claims
; ===================================================================================

{@contingent_claim}
; Required fields first
claim_date = !date                            ; Claim date
claim_type = !(
    cancellation,                             ; Event cancelled
    death,                                    ; Death
    disability,                               ; Disability
    disgrace,                                 ; Disgrace
    non_appearance,                           ; Non-appearance
    over_redemption,                          ; Over-redemption
    performance,                              ; Performance triggered
    prize,                                    ; Prize won
    weather,                                  ; Weather trigger
    other                                     ; Other
)

; Optional fields
amount_claimed = #$:(0..)                     ; Amount claimed
amount_paid = #$:(0..)                        ; Amount paid
claim_id = :                                  ; Claim ID
claim_status = (
    closed,
    denied,
    open,
    paid,
    reserved,
    verification
)
deductible_applied = #$:(0..)                 ; Deductible
description = :                               ; Description
incident_date = date                          ; Trigger date
reserve = #$:(0..)                            ; Reserve amount
trigger_event = :                             ; What triggered
verification_complete = ?                     ; Verified

; ===================================================================================
; Contingency Policy
; ===================================================================================

{@contingency_policy}
; Required fields first
coverage = !@contingent_coverage              ; Coverage terms
effective_date = !date                        ; Policy effective date
event = !@contingent_event                    ; Contingent event
expiration_date = !date                       ; Policy expiration date
insured = !@contingent_insured                ; Insured entity
policy_number = !:                            ; Policy number

; Invariants
:invariant expiration_date >= effective_date

; Optional fields
agency = @agency                              ; Issuing agency
claims[] = @contingent_claim                  ; Claims history
endorsements[] = :                            ; Policy endorsements
exclusions[] = :                              ; Exclusions
id = :                                        ; Internal identifier
policy_form = (
    annual,                                   ; Annual policy
    event,                                    ; Single event
    program                                   ; Program policy
)
policy_status = (
    active,
    cancelled,
    expired,
    pending
)
premium = @contingent_premium                 ; Premium details
producer = @producer                          ; Agent
underwriting = @underwriting_decision         ; Underwriting

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
coverage_type = :                             ; Coverage type
event_description = :                         ; Event description
insured_name = :                              ; Insured name
limit = #$:(0..)                              ; Coverage limit
maximum_exposure = #$:(0..)                   ; Maximum exposure

{@contingency_policy}


; ===================================================================================
; ODIN Railroad Protective Liability Insurance Schema
; ===================================================================================
; Railroad Protective Liability (RPL) insurance for contractors and others
; performing work on or adjacent to railroad property covering bodily injury,
; property damage, and physical damage to railroad property.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.railroad.railroad-protective"
version = "1.0.0"
title = "Railroad Protective Liability Insurance Schema"
description = "Liability coverage for work on or adjacent to railroad property"

{$derivation}
source[0].authority = "Insurance Services Office (ISO)"
source[0].citation = "Railroad Protective Liability Coverage Form CG 00 35"
source[0].url = "https://www.verisk.com/insurance/"

source[1].authority = "Federal Railroad Administration"
source[1].citation = "Railroad Safety and Liability Requirements"
source[1].url = "https://railroads.dot.gov/"

source[2].authority = "Association of American Railroads"
source[2].citation = "Contractor Insurance Requirements"
source[2].url = "https://www.aar.org/"

source[3].authority = "Surface Transportation Board"
source[3].citation = "Rail Transportation Regulations"
source[3].url = "https://www.stb.gov/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on ISO RPL form and railroad industry insurance standards"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial railroad protective liability insurance schema"
changelog[0].rationale = "Commercial railroad coverage for contractors"

; ===================================================================================
; Named Insured (Contractor)
; ===================================================================================

{@rpl_contractor}
; Required fields first
contractor_name = :                          ; Contractor name
contractor_type = (
    communications,                           ; Telecom/fiber
    construction,                             ; General construction
    engineering,                              ; Engineering firm
    environmental,                            ; Environmental
    government,                               ; Government agency
    maintenance,                              ; Track maintenance
    pipeline,                                 ; Pipeline company
    signaling,                                ; Signal contractor
    utility                                   ; Utility company
)

; Optional fields
address = @address                            ; Business address
contact_email = *@email                       ; Contact email
contact_phone = *@phone                       ; Contact phone
contractor_id = :                             ; Internal identifier
fein = *:                                     ; Tax ID
license_number = *:                            ; Contractor license
railroad_experience_years = ##                ; RR experience

; ===================================================================================
; Railroad Information
; ===================================================================================

{@rpl_railroad}
; Required fields first
railroad_name = :                            ; Railroad name
railroad_type = (
    class_1,                                  ; Class I railroad
    class_2,                                  ; Class II regional
    class_3,                                  ; Class III short line
    commuter,                                 ; Commuter rail
    industrial,                               ; Industrial railroad
    passenger,                                ; Passenger rail
    switching                                 ; Switching/terminal
)

; Optional fields
aar_code = :                                  ; AAR code
address = @address                            ; Railroad HQ
fra_number = :                                ; FRA number
parent_company = :                            ; Parent railroad
railroad_id = :                               ; Internal identifier
scac = :(2..4)                                ; SCAC code
track_miles = ##                              ; Track miles operated

; ===================================================================================
; Project Details
; ===================================================================================

{@rpl_project}
; Required fields first
project_description = :                      ; Project description
project_type = (
    bridge_construction,                      ; Bridge work
    drainage,                                 ; Drainage work
    fiber_optic,                              ; Fiber installation
    grade_crossing,                           ; Crossing work
    highway_construction,                     ; Highway near RR
    maintenance_of_way,                       ; Track maintenance
    overhead_crossing,                        ; Overhead structure
    pipeline_crossing,                        ; Pipeline crossing
    signal_work,                              ; Signal installation
    track_construction,                       ; Track construction
    tunnel_work,                              ; Tunnel work
    underpass,                                ; Underpass work
    utility_crossing                          ; Utility crossing
)

; Optional fields
contract_value = #$:(0..)                     ; Contract value
end_date = date                               ; Project end
location_description = :                      ; Location details
milepost_end = #                              ; End milepost
milepost_start = #                            ; Start milepost
project_duration_days = ##                    ; Duration
project_id = :                                ; Internal identifier
railroad = @rpl_railroad                      ; Railroad
start_date = date                             ; Project start
state = :(2)                                  ; State
subdivision = :                               ; RR subdivision
work_on_rr_property = ?                       ; On RR property
work_within_feet_of_track = ##                ; Distance from track

; ===================================================================================
; RPL Coverage
; ===================================================================================

{@rpl_coverage}
; Required fields first
bodily_injury = #$:(0..)                     ; BI per occurrence
property_damage = #$:(0..)                   ; PD per occurrence
aggregate = #$:(0..)                         ; Annual aggregate

; Optional fields
deductible = #$:(0..)                         ; Deductible
defense_costs = (included, supplementary)     ; Defense inside/outside

; ---------------------------------------------------------------------------
; Physical Damage to Railroad Property
; ---------------------------------------------------------------------------
{.property}
included = ?                                  ; RR property damage
bridges = ?:if included = true                ; Bridges covered
buildings = ?:if included = true              ; Buildings covered
limit = #$:(0..):if included = true           ; Property limit
signals = ?:if included = true                ; Signal systems
track = ?:if included = true                  ; Track/roadbed
utilities = ?:if included = true              ; RR utilities

{@rpl_coverage}

; ---------------------------------------------------------------------------
; Rolling Stock Damage
; ---------------------------------------------------------------------------
{.rolling_stock}
included = ?                                  ; Rolling stock damage
each_occurrence = #$:(0..):if included = true ; Per occurrence
locomotives = ?:if included = true            ; Locomotives
passenger_cars = ?:if included = true         ; Passenger cars
railcars = ?:if included = true               ; Freight cars

{@rpl_coverage}

; ---------------------------------------------------------------------------
; Delay/Loss of Use
; ---------------------------------------------------------------------------
{.delay}
included = ?                                  ; Delay coverage
daily_limit = #$:(0..):if included = true     ; Daily limit
maximum_days = ##:if included = true          ; Maximum days
per_occurrence = #$:(0..):if included = true  ; Per occurrence
waiting_hours = ##:if included = true         ; Waiting period

{@rpl_coverage}

; ===================================================================================
; Premium Details
; ===================================================================================

{@rpl_premium}
; Required fields first
total_premium = #$:(0..)                     ; Total premium

; Optional fields
delay_premium = #$:(0..)                      ; Delay coverage
minimum_premium = #$:(0..)                    ; Minimum premium
physical_damage_premium = #$:(0..)            ; Property damage
policy_fee = #$:(0..)                         ; Policy fee
rolling_stock_premium = #$:(0..)              ; Rolling stock
taxes_and_fees = #$:(0..)                     ; Taxes/fees

; ---------------------------------------------------------------------------
; Rating Factors
; ---------------------------------------------------------------------------
{.rating}
class_factor = #                              ; Railroad class
contract_factor = #                           ; Contract value
duration_factor = #                           ; Project duration
project_type_factor = #                       ; Work type
proximity_factor = #                          ; Distance from track

{@rpl_premium}

; ===================================================================================
; Claims
; ===================================================================================

{@rpl_claim}
; Required fields first
claim_date = date                            ; Claim date
claim_type = (
    bodily_injury,                            ; BI claim
    bridge_damage,                            ; Bridge damage
    delay,                                    ; Delay claim
    derailment,                               ; Derailment
    equipment_damage,                         ; RR equipment
    property_damage,                          ; PD claim
    rolling_stock,                            ; Rolling stock
    signal_damage,                            ; Signal damage
    track_damage,                             ; Track damage
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
    subrogation
)
deductible_applied = #$:(0..)                 ; Deductible
delay_hours = ##                              ; Delay duration
description = :                               ; Description
incident_date = date                          ; Incident date
incident_location = :                         ; Location
litigation = ?                                ; In litigation
milepost = #                                  ; Milepost
project_reference = :                         ; Project ID
railroad_claimant = :                         ; Railroad name
reserve = #$:(0..)                            ; Reserve amount

; ===================================================================================
; Railroad Protective Liability Policy
; ===================================================================================

{@rpl_policy}
; Required fields first
contractor = @rpl_contractor                 ; Named insured
coverage = @rpl_coverage                     ; Coverage terms
effective_date = date                        ; Policy effective date
expiration_date = date                       ; Policy expiration date
policy_number = :                            ; Policy number
project = @rpl_project                       ; Project details

; Invariants
:invariant expiration_date > effective_date

; Optional fields
agency = @agency                              ; Issuing agency
claims[] = @rpl_claim                         ; Claims history
endorsements[] = :                            ; Policy endorsements
id = :                                        ; Internal identifier
policy_form = (
    annual,                                   ; Annual policy
    iso_cg_00_35,                             ; ISO form
    project                                   ; Project-specific
)
policy_status = (
    active,
    cancelled,
    completed,
    expired,
    pending
)
premium = @rpl_premium                        ; Premium details
producer = @producer                          ; Agent
underwriting = @underwriting_decision         ; Underwriting

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
aggregate_limit = #$:(0..)                    ; Aggregate limit
bi_limit = #$:(0..)                           ; BI limit
contractor_name = :                           ; Contractor
pd_limit = #$:(0..)                           ; PD limit
project_type = :                              ; Project type
railroad_name = :                             ; Railroad

{@rpl_policy}


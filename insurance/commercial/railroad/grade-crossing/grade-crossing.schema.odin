; ===================================================================================
; ODIN Grade Crossing Insurance Schema
; ===================================================================================
; Grade crossing insurance covering accidents and incidents at highway-railroad
; grade crossings including liability, crossing protection equipment damage,
; signal/warning device damage, and vehicular impact.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.railroad.grade-crossing"
version = "1.0.0"
title = "Grade Crossing Insurance Schema"
description = "Liability and property coverage for highway-railroad grade crossings"

{$derivation}
source[0].authority = "Federal Railroad Administration"
source[0].citation = "Highway-Rail Grade Crossing Safety Program"
source[0].url = "https://railroads.dot.gov/"

source[1].authority = "Federal Highway Administration"
source[1].citation = "Manual on Uniform Traffic Control Devices - Rail Crossings"
source[1].url = "https://highways.dot.gov/"

source[2].authority = "Operation Lifesaver"
source[2].citation = "Grade Crossing Safety Standards"
source[2].url = "https://oli.org/"

source[3].authority = "Association of American Railroads"
source[3].citation = "Grade Crossing Insurance Requirements"
source[3].url = "https://www.aar.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on FRA crossing inventory and railroad insurance standards"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial grade crossing insurance schema"
changelog[0].rationale = "Commercial railroad coverage for grade crossings"

; ===================================================================================
; Crossing Owner/Operator
; ===================================================================================

{@gc_owner}
; Required fields first
owner_name = !:                               ; Owner/operator name
owner_type = !(
    class_1,                                  ; Class I railroad
    commuter_rail,                            ; Commuter rail
    freight,                                  ; Freight railroad
    highway_authority,                        ; Highway authority
    industrial,                               ; Industrial owner
    municipality,                             ; City/county
    passenger_rail,                           ; Passenger railroad
    private,                                  ; Private crossing
    short_line,                               ; Short line
    state_dot                                 ; State DOT
)

; Optional fields
address = @address                            ; Business address
aar_mark = :(2..4)                            ; AAR reporting mark
contact_email = *@email                       ; Contact email
contact_phone = *@phone                       ; Contact phone
fein = *:                                     ; Tax ID
fra_number = :                                ; FRA number
owner_id = :                                  ; Internal identifier
total_crossings = ##                          ; Total crossings owned

; ===================================================================================
; Grade Crossing Details
; ===================================================================================

{@gc_crossing}
; Required fields first
crossing_id = !:                              ; DOT/AAR crossing ID
crossing_type = !(
    pedestrian,                               ; Pedestrian crossing
    private,                                  ; Private crossing
    public                                    ; Public crossing
)
protection_type = !(
    active,                                   ; Gates/signals
    none,                                     ; No protection
    passive,                                  ; Signs only
    pedestrian_only                           ; Pedestrian signals
)

; Location
highway_name = :                              ; Highway/road name
lat = #:(-90..90)                             ; Latitude
long = #:(-180..180)                          ; Longitude
milepost = #                                  ; Railroad milepost
municipality = :                              ; City/town
state = :(2)                                  ; State
subdivision = :                               ; Railroad subdivision

; Crossing characteristics
aadt = ##                                     ; Avg daily traffic
approach_grade = #                            ; Approach grade %
commercial_vehicle_pct = #:(0..100)           ; Commercial vehicle %
highway_lanes = ##                            ; Number of lanes
highway_speed_limit = ##                      ; Speed limit
highway_type = (
    city_street,
    county_road,
    interstate,
    private_road,
    state_highway,
    us_highway
)
pedestrian_pathway = ?                        ; Pedestrian path
quiet_zone = ?                                ; Quiet zone
school_bus_route = ?                          ; School bus
sight_distance_feet = ##                      ; Sight distance
train_count_daily = ##                        ; Trains per day
tracks = ##                                   ; Number of tracks

; ---------------------------------------------------------------------------
; Warning Devices
; ---------------------------------------------------------------------------
{.warning_devices}
advance_warning = ?                           ; Advance warning signs
bells = ?                                     ; Warning bells
cantilever_signals = ?                        ; Cantilever signals
crossbucks = ?                                ; Crossbuck signs
flashing_lights = ?                           ; Flashing lights
four_quadrant_gates = ?                       ; 4-quad gates
gates = ?                                     ; Standard gates
interconnection = ?                           ; Traffic signal connected
mast_signals = ?                              ; Mast-mounted signals
pavement_markings = ?                         ; Pavement markings
pedestrian_gates = ?                          ; Pedestrian gates
positive_train_control = ?                    ; PTC equipped
stop_signs = ?                                ; Stop signs
wayside_horn = ?                              ; Wayside horn
yield_signs = ?                               ; Yield signs

{@gc_crossing}

; ===================================================================================
; Grade Crossing Coverage
; ===================================================================================

{@gc_coverage}
; Required fields first
bodily_injury = !#$:(0..)                     ; BI per occurrence
property_damage = !#$:(0..)                   ; PD per occurrence
aggregate = !#$:(0..)                         ; Annual aggregate

; Optional fields
combined_single_limit = #$:(0..)              ; CSL option
deductible = #$:(0..)                         ; Deductible
defense_costs = (included, supplementary)     ; Defense inside/outside

; ---------------------------------------------------------------------------
; Warning Device Coverage
; ---------------------------------------------------------------------------
{.warning_devices}
included = ?                                  ; Device damage coverage
deductible = #$:(0..):if included = true      ; Device deductible
gates = #$:(0..):if included = true           ; Gate replacement
limit = #$:(0..):if included = true           ; Device limit
signals = #$:(0..):if included = true         ; Signal equipment

{@gc_coverage}

; ---------------------------------------------------------------------------
; Track/Roadbed Damage
; ---------------------------------------------------------------------------
{.track}
included = ?                                  ; Track damage coverage
deductible = #$:(0..):if included = true      ; Track deductible
limit = #$:(0..):if included = true           ; Track limit
rail = ?:if included = true                   ; Rail damage
roadbed = ?:if included = true                ; Roadbed damage
surface = ?:if included = true                ; Crossing surface
ties = ?:if included = true                   ; Tie damage

{@gc_coverage}

; ---------------------------------------------------------------------------
; Highway/Approach Damage
; ---------------------------------------------------------------------------
{.highway}
included = ?                                  ; Highway damage
approach = ?:if included = true               ; Approach damage
deductible = #$:(0..):if included = true      ; Highway deductible
limit = #$:(0..):if included = true           ; Highway limit
pavement = ?:if included = true               ; Pavement damage
signage = ?:if included = true                ; Sign damage

{@gc_coverage}

; ---------------------------------------------------------------------------
; Train Delay
; ---------------------------------------------------------------------------
{.delay}
included = ?                                  ; Train delay coverage
daily_limit = #$:(0..):if included = true     ; Daily limit
maximum_days = ##:if included = true          ; Maximum days
per_occurrence = #$:(0..):if included = true  ; Per occurrence
waiting_hours = ##:if included = true         ; Waiting period

{@gc_coverage}

; ===================================================================================
; Premium Details
; ===================================================================================

{@gc_premium}
; Required fields first
total_premium = !#$:(0..)                     ; Total premium

; Optional fields
delay_premium = #$:(0..)                      ; Delay coverage
highway_premium = #$:(0..)                    ; Highway damage
minimum_premium = #$:(0..)                    ; Minimum premium
policy_fee = #$:(0..)                         ; Policy fee
taxes_and_fees = #$:(0..)                     ; Taxes/fees
track_premium = #$:(0..)                      ; Track damage
warning_device_premium = #$:(0..)             ; Device coverage

; ---------------------------------------------------------------------------
; Rating Factors
; ---------------------------------------------------------------------------
{.rating}
aadt_factor = #                               ; Traffic volume
crossing_count = #                            ; Number of crossings
claims_experience = #                         ; Loss history
protection_factor = #                         ; Protection type
train_factor = #                              ; Train frequency

{@gc_premium}

; ===================================================================================
; Claims
; ===================================================================================

{@gc_claim}
; Required fields first
claim_date = !date                            ; Claim date
claim_type = !(
    auto_impact,                              ; Vehicle impact
    derailment,                               ; Derailment at crossing
    device_damage,                            ; Warning device
    fatality,                                 ; Fatal collision
    highway_damage,                           ; Highway damage
    pedestrian,                               ; Pedestrian incident
    property_damage,                          ; Property damage
    signal_failure,                           ; Signal failure
    track_damage,                             ; Track damage
    train_collision,                          ; Train-vehicle collision
    other                                     ; Other
)

; Optional fields
amount_claimed = #$:(0..)                     ; Amount claimed
amount_paid = #$:(0..)                        ; Amount paid
at_fault = (driver, pedestrian, railroad, unknown)
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
crossing_reference = :                        ; Crossing ID
deductible_applied = #$:(0..)                 ; Deductible
delay_hours = ##                              ; Train delay
description = :                               ; Description
fatalities = ##                               ; Number of fatalities
gate_failure = ?                              ; Gate malfunction
incident_date = date                          ; Incident date
incident_time = :                             ; Time of incident
injuries = ##                                 ; Number of injuries
litigation = ?                                ; In litigation
reserve = #$:(0..)                            ; Reserve amount
signal_activated = ?                          ; Signals working
train_speed = ##                              ; Train speed mph
vehicle_type = :                              ; Vehicle type
weather_conditions = :                        ; Weather

; ===================================================================================
; Grade Crossing Policy
; ===================================================================================

{@gc_policy}
; Required fields first
coverage = !@gc_coverage                      ; Coverage terms
crossings[] = !@gc_crossing                   ; Covered crossings
effective_date = !date                        ; Policy effective date
expiration_date = !date                       ; Policy expiration date
owner = !@gc_owner                            ; Crossing owner
policy_number = !:                            ; Policy number

; Invariants
:invariant expiration_date > effective_date

; Optional fields
agency = @agency                              ; Issuing agency
claims[] = @gc_claim                          ; Claims history
endorsements[] = :                            ; Policy endorsements
id = :                                        ; Internal identifier
policy_form = (
    blanket,                                  ; Blanket coverage
    per_crossing,                             ; Per crossing
    scheduled                                 ; Scheduled crossings
)
policy_status = (
    active,
    cancelled,
    expired,
    non_renewed,
    pending
)
premium = @gc_premium                         ; Premium details
producer = @producer                          ; Agent
underwriting = @underwriting_decision         ; Underwriting

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
aggregate_limit = #$:(0..)                    ; Aggregate limit
bi_limit = #$:(0..)                           ; BI limit
crossing_count = ##                           ; Covered crossings
owner_name = :                                ; Owner name
pd_limit = #$:(0..)                           ; PD limit

{@gc_policy}


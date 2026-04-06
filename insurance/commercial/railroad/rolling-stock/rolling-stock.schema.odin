; ===================================================================================
; ODIN Rolling Stock Insurance Schema
; ===================================================================================
; Rolling stock insurance covering railroad locomotives, freight cars, passenger
; cars, intermodal equipment, and maintenance of way equipment for physical
; damage, breakdown, theft, fire, and transit.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.railroad.rolling-stock"
version = "1.0.0"
title = "Rolling Stock Insurance Schema"
description = "Physical damage coverage for railroad locomotives and cars"

{$derivation}
source[0].authority = "Association of American Railroads"
source[0].citation = "Railroad Equipment Registration and Insurance"
source[0].url = "https://www.aar.org/"

source[1].authority = "Federal Railroad Administration"
source[1].citation = "Railroad Equipment Safety and Maintenance Standards"
source[1].url = "https://railroads.dot.gov/"

source[2].authority = "Railway Supply Institute"
source[2].citation = "Railroad Equipment Standards"
source[2].url = "https://www.rsiweb.org/"

source[3].authority = "Surface Transportation Board"
source[3].citation = "Rail Equipment Interchange Rules"
source[3].url = "https://www.stb.gov/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on AAR interchange rules and railroad equipment insurance"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial rolling stock insurance schema"
changelog[0].rationale = "Commercial railroad equipment coverage"

; ===================================================================================
; Equipment Owner
; ===================================================================================

{@rs_owner}
; Required fields first
owner_name = !:                               ; Owner name
owner_type = !(
    car_leasing,                              ; Car leasing company
    class_1,                                  ; Class I railroad
    industrial,                               ; Industrial shipper
    passenger_railroad,                       ; Passenger railroad
    private_car,                              ; Private car owner
    regional_railroad,                        ; Regional railroad
    short_line                                ; Short line railroad
)

; Optional fields
address = @address                            ; Business address
aar_mark = :(2..4)                            ; AAR reporting mark
contact_email = *@email                       ; Contact email
contact_phone = *@phone                       ; Contact phone
fein = *:                                     ; Tax ID
fleet_size = ##                               ; Fleet count
owner_id = :                                  ; Internal identifier
scac = :(2..4)                                ; SCAC code

; ===================================================================================
; Rolling Stock Equipment
; ===================================================================================

{@rs_equipment}
; Required fields first
equipment_type = !(
    autorack,                                 ; Auto carrier
    boxcar,                                   ; Boxcar
    caboose,                                  ; Caboose
    centerbeam,                               ; Centerbeam flat
    coil_car,                                 ; Coil steel car
    covered_hopper,                           ; Covered hopper
    flat_car,                                 ; Flatcar
    gondola,                                  ; Gondola
    hopper,                                   ; Open hopper
    intermodal_car,                           ; Well car
    locomotive_diesel,                        ; Diesel locomotive
    locomotive_electric,                      ; Electric locomotive
    mow_equipment,                            ; MOW equipment
    passenger_car,                            ; Passenger car
    refrigerator,                             ; Reefer car
    tank_car                                  ; Tank car
)
insured_value = !#$:(0..)                     ; Equipment value

; Optional fields
aar_car_type = :                              ; AAR car type code
axle_count = ##                               ; Number of axles
build_date = date                             ; Build date
builder = :                                   ; Manufacturer
capacity_tons = ##                            ; Capacity
car_number = :                                ; Car number
condition = (excellent, fair, good, poor)     ; Condition
equipment_id = :                              ; Internal identifier
grl = ##                                      ; Gross rail load
hazmat_certified = ?                          ; Hazmat approved
horsepower = ##:if equipment_type = (locomotive_diesel, locomotive_electric)
in_service_date = date                        ; Service date
last_inspection = date                        ; Last inspection
length_feet = ##                              ; Length
light_weight_lbs = ##                         ; Light weight
lube_type = (grease, journal, roller)         ; Bearing type
model = :                                     ; Model
pool_car = ?                                  ; Pool car
rebuilt_date = date                           ; Rebuild date
reporting_mark = :(2..4)                      ; Reporting mark
stcc = :                                      ; STCC if hazmat
tare_weight_lbs = ##                          ; Tare weight
umler_registered = ?                          ; UMLER registered

; ===================================================================================
; Rolling Stock Coverage
; ===================================================================================

{@rs_coverage}
; Required fields first
physical_damage_limit = !#$:(0..)             ; PD limit

; Valuation
valuation = (
    actual_cash_value,                        ; ACV
    agreed_value,                             ; Agreed value
    replacement_cost                          ; Replacement cost
)

; Deductible
deductible = #$:(0..)                         ; Per occurrence
deductible_type = (flat, percentage)          ; Deductible type

; ---------------------------------------------------------------------------
; Covered Perils
; ---------------------------------------------------------------------------
{.perils}
collision = ?                                 ; Collision
contamination = ?                             ; Contamination
derailment = ?                                ; Derailment
earthquake = ?                                ; Earthquake
explosion = ?                                 ; Explosion
fire = ?                                      ; Fire
flood = ?                                     ; Flood
freezing = ?                                  ; Freezing damage
malicious_damage = ?                          ; Vandalism
overloading = ?                               ; Overloading
overturn = ?                                  ; Overturn
theft = ?                                     ; Theft
windstorm = ?                                 ; Windstorm

{@rs_coverage}

; ---------------------------------------------------------------------------
; Mechanical Breakdown
; ---------------------------------------------------------------------------
{.breakdown}
included = ?                                  ; Breakdown coverage
bearings = ?:if included = true               ; Bearing failure
brakes = ?:if included = true                 ; Brake failure
couplers = ?:if included = true               ; Coupler failure
deductible = #$:(0..):if included = true      ; Breakdown deductible
engines = ?:if included = true                ; Engine failure
limit = #$:(0..):if included = true           ; Breakdown limit
traction_motors = ?:if included = true        ; Motor failure
trucks = ?:if included = true                 ; Truck failure
wheels = ?:if included = true                 ; Wheel failure

{@rs_coverage}

; ---------------------------------------------------------------------------
; Leased Equipment
; ---------------------------------------------------------------------------
{.leased}
included = ?                                  ; Leased equipment
legal_liability = ?:if included = true        ; Liability for leased
limit = #$:(0..):if included = true           ; Leased limit
per_car = #$:(0..):if included = true         ; Per car limit

{@rs_coverage}

; ---------------------------------------------------------------------------
; Loss of Use
; ---------------------------------------------------------------------------
{.loss_of_use}
included = ?                                  ; Loss of use
daily_value = #$:(0..):if included = true     ; Daily limit
maximum_days = ##:if included = true          ; Maximum days
waiting_days = ##:if included = true          ; Waiting period

{@rs_coverage}

; ===================================================================================
; Fleet Schedule
; ===================================================================================

{@rs_fleet}
; Fleet summary
equipment_count = ##                          ; Total units
equipment_list[] = @rs_equipment              ; Scheduled equipment
total_insured_value = #$:(0..)                ; Total fleet TIV

; Fleet composition
freight_cars = ##                             ; Freight car count
locomotives = ##                              ; Locomotive count
mow_equipment = ##                            ; MOW count
passenger_cars = ##                           ; Passenger car count

; ===================================================================================
; Premium Details
; ===================================================================================

{@rs_premium}
; Required fields first
total_premium = !#$:(0..)                     ; Total premium

; Optional fields
breakdown_premium = #$:(0..)                  ; Breakdown coverage
fleet_discount = #:(0..100)                   ; Fleet discount %
leased_premium = #$:(0..)                     ; Leased equipment
loss_of_use_premium = #$:(0..)                ; Loss of use
minimum_premium = #$:(0..)                    ; Minimum premium
physical_damage_premium = #$:(0..)            ; Physical damage
policy_fee = #$:(0..)                         ; Policy fee
taxes_and_fees = #$:(0..)                     ; Taxes/fees

; Rating basis
rate_per_100 = #                              ; Rate per $100 value

; ---------------------------------------------------------------------------
; Rating Factors
; ---------------------------------------------------------------------------
{.rating}
age_factor = #                                ; Equipment age
claims_experience = #                         ; Loss history
deductible_credit = #                         ; Deductible factor
equipment_factor = #                          ; Equipment type
fleet_size_factor = #                         ; Fleet size
maintenance_factor = #                        ; Maintenance quality

{@rs_premium}

; ===================================================================================
; Claims
; ===================================================================================

{@rs_claim}
; Required fields first
claim_date = !date                            ; Claim date
claim_type = !(
    bearing_failure,                          ; Bearing failure
    collision,                                ; Collision
    contamination,                            ; Contamination
    derailment,                               ; Derailment
    engine_failure,                           ; Engine failure
    fire,                                     ; Fire
    flood,                                    ; Flood damage
    overloading,                              ; Overloading
    theft,                                    ; Theft
    vandalism,                                ; Vandalism
    wheel_failure,                            ; Wheel failure
    other                                     ; Other
)

; Optional fields
amount_claimed = #$:(0..)                     ; Amount claimed
amount_paid = #$:(0..)                        ; Amount paid
car_number = :                                ; Equipment number
claim_id = :                                  ; Claim ID
claim_status = (
    closed,
    denied,
    open,
    paid,
    reserved,
    salvage,
    subrogation
)
deductible_applied = #$:(0..)                 ; Deductible
description = :                               ; Description
equipment_reference = :                       ; Equipment ID
incident_date = date                          ; Incident date
incident_location = :                         ; Location
loss_of_use_days = ##                         ; Days out of service
repair_cost = #$:(0..)                        ; Repair cost
reserve = #$:(0..)                            ; Reserve amount
salvage = #$:(0..)                            ; Salvage value
total_loss = ?                                ; Total loss

; ===================================================================================
; Rolling Stock Policy
; ===================================================================================

{@rolling_stock_policy}
; Required fields first
coverage = !@rs_coverage                      ; Coverage terms
effective_date = !date                        ; Policy effective date
expiration_date = !date                       ; Policy expiration date
fleet = !@rs_fleet                            ; Fleet schedule
owner = !@rs_owner                            ; Equipment owner
policy_number = !:                            ; Policy number

; Invariants
:invariant expiration_date > effective_date

; Optional fields
agency = @agency                              ; Issuing agency
claims[] = @rs_claim                          ; Claims history
endorsements[] = :                            ; Policy endorsements
id = :                                        ; Internal identifier
policy_form = (
    blanket,                                  ; Blanket coverage
    fleet,                                    ; Fleet policy
    scheduled                                 ; Scheduled equipment
)
policy_status = (
    active,
    cancelled,
    expired,
    non_renewed,
    pending
)
premium = @rs_premium                         ; Premium details
producer = @producer                          ; Agent
underwriting = @underwriting_decision         ; Underwriting

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
equipment_count = ##                          ; Total units
owner_name = :                                ; Owner name
pd_limit = #$:(0..)                           ; PD limit
total_tiv = #$:(0..)                          ; Total value

{@rolling_stock_policy}


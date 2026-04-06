; ===================================================================================
; ODIN Non-Trucking Liability Insurance Schema
; ===================================================================================
; Non-trucking liability (NTL) insurance, also known as bobtail or deadhead
; coverage, for owner-operators and leased truckers providing liability coverage
; when the truck is not under dispatch or carrier authority.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.transportation.non-trucking"
version = "1.0.0"
title = "Non-Trucking Liability Insurance Schema"
description = "Bobtail/deadhead coverage for owner-operators between dispatches"

{$derivation}
source[0].authority = "Federal Motor Carrier Safety Administration (FMCSA)"
source[0].citation = "Motor Carrier Insurance and Financial Responsibility"
source[0].url = "https://www.fmcsa.dot.gov/"

source[1].authority = "Owner-Operator Independent Drivers Association (OOIDA)"
source[1].citation = "Non-Trucking Liability Insurance Guidelines"
source[1].url = "https://www.ooida.com/"

source[2].authority = "National Association of Insurance Commissioners (NAIC)"
source[2].citation = "Commercial Auto - Non-Trucking Liability"
source[2].url = "https://content.naic.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on industry standard NTL coverage provisions"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial non-trucking liability insurance schema"
changelog[0].rationale = "Coverage for owner-operators when not under dispatch"

; ===================================================================================
; Owner-Operator Classification
; ===================================================================================
; Owner-operator and independent contractor details.

{@ntl_operator_type}
operator_class = !(
    independent_contractor,                   ; IC with permanent lease
    lease_on,                                 ; Leased to one carrier
    lease_on_multiple,                        ; Multiple carrier leases
    owner_operator,                           ; Standard owner-op
    permanent_lease                           ; Permanent lease arrangement
)

; Operating status
cdl_class = !(A, B, C)                        ; CDL class
primary_carrier = :                           ; Primary lease carrier
secondary_carriers[] = :                      ; Other lease carriers

; ===================================================================================
; Owner-Operator Details
; ===================================================================================
; Insured owner-operator information.

{@ntl_operator}
; Required fields first
cdl_number = !*:                              ; CDL number
cdl_state = !:(2)                             ; CDL state
date_of_birth = !*date                        ; Date of birth
name = !@person_name                          ; Operator name
operator_type = !@ntl_operator_type           ; Operator classification

; Optional fields
address = @address                            ; Mailing address
business_name = :                             ; Business DBA name
cdl_expiration = date                         ; CDL expiry
email = *@email                               ; Email address
fein = *:                                     ; Tax ID if applicable
medical_card_expiration = date                ; Medical cert expiry
operator_id = :                               ; Internal identifier
phone = *@phone                               ; Phone number
ssn = *:format ssn                            ; SSN
years_experience = ##                         ; Trucking experience

; ---------------------------------------------------------------------------
; Driving Record
; ---------------------------------------------------------------------------
{.driving_record}
accidents_3_years = ##:(0..10)                ; At-fault accidents
dui_convictions = ##:(0..10)                  ; DUI history
major_violations = ##:(0..10)                 ; Major violations
minor_violations = ##:(0..10)                 ; Minor violations
suspended_license = ?                         ; Suspension history

{@ntl_operator}

; ---------------------------------------------------------------------------
; Primary Carrier Lease
; ---------------------------------------------------------------------------
{.primary_lease}
carrier_mc_number = :                         ; Carrier MC number
carrier_name = :                              ; Carrier name
carrier_usdot = :                             ; Carrier USDOT
exclusive_lease = ?                           ; Exclusive agreement
lease_effective = date                        ; Lease start
lease_expiration = date                       ; Lease end

{@ntl_operator}

; ===================================================================================
; Covered Vehicle
; ===================================================================================
; Power unit covered under NTL policy.

{@ntl_vehicle}
; Required fields first
vehicle_type = !(
    bobtail,                                  ; Tractor only
    straight_truck,                           ; Straight truck
    tractor                                   ; Tractor (power unit)
)
vin = !*:/^[A-HJ-NPR-Z0-9]{17}$/              ; VIN

; Optional fields
gvwr_lbs = ##                                 ; GVWR
license_plate = :                             ; License plate
license_state = :(2)                          ; Registration state
make = :                                      ; Manufacturer
model = :                                     ; Model
model_year = ##:(1950..2100)                  ; Year
odometer = ##                                 ; Current mileage
owned_financed = (financed, leased, owned)    ; Ownership status
stated_value = #$:(0..)                       ; Value
unit_number = :                               ; Unit number
vehicle_id = :                                ; Internal identifier

; ---------------------------------------------------------------------------
; Physical Damage (Optional)
; ---------------------------------------------------------------------------
{.physical_damage}
collision = ?                                 ; Collision coverage
collision_deductible = #$:(0..):if physical_damage.collision = true
comprehensive = ?                             ; Comprehensive coverage
comprehensive_deductible = #$:(0..):if physical_damage.comprehensive = true
stated_amount = #$:(0..)                      ; Coverage amount
valuation = (
    actual_cash_value,
    agreed_value,
    stated_amount
)

{@ntl_vehicle}

; ===================================================================================
; Non-Trucking Liability Coverage
; ===================================================================================
; NTL coverage provisions.

{@ntl_coverage}
; Required fields first
combined_single_limit = !#$:(0..)             ; CSL

; Optional fields
deductible = #$:(0..)                         ; Liability deductible
medical_payments = ?                          ; Med pay coverage
medical_payments_limit = #$:(0..):if medical_payments = true
uninsured_motorist = ?                        ; UM coverage
uninsured_motorist_limit = #$:(0..):if uninsured_motorist = true
underinsured_motorist = ?                     ; UIM coverage
underinsured_motorist_limit = #$:(0..):if underinsured_motorist = true

; ---------------------------------------------------------------------------
; Coverage Scope
; ---------------------------------------------------------------------------
{.scope}
; When coverage applies
between_dispatches = ?true                    ; Between load assignments
deadhead = ?true                              ; Returning empty
personal_errands = ?                          ; Personal use
returning_home = ?true                        ; Traveling home
to_first_dispatch = ?true                     ; To first pickup
weekends = ?                                  ; Weekend use

; When coverage does NOT apply
for_hire = ?true                              ; Under dispatch excluded
under_carrier_authority = ?true               ; Carrier auth excluded
with_cargo = ?true                            ; Hauling load excluded

{@ntl_coverage}

; ---------------------------------------------------------------------------
; Territory
; ---------------------------------------------------------------------------
territory = (
    continental_us,                           ; 48 states
    north_america,                            ; US/Canada/Mexico
    us_canada                                 ; US and Canada
)

; ===================================================================================
; Exclusions
; ===================================================================================
; Standard NTL exclusions.

{@ntl_exclusions}
; Coverage trigger exclusions (NTL does not apply when)
for_hire_operations = ?true                   ; Under dispatch
hauling_cargo = ?true                         ; With load
under_carrier_dispatch = ?true                ; Carrier's authority
using_trailer = ?                             ; With trailer attached

; Standard auto exclusions
expected_intended = ?true                     ; Expected/intended
fellow_employee = ?                           ; Fellow employee
nuclear = ?true                               ; Nuclear
racing = ?true                                ; Racing
rental = ?                                    ; Rental to others
war = ?true                                   ; War/terrorism
workers_comp = ?true                          ; Workers comp

; Vehicle-related
pulling_loaded_trailer = ?true                ; Loaded trailer
pulling_trailer_for_hire = ?true              ; Trailer for hire
vehicle_as_premises = ?                       ; Living in vehicle

; ===================================================================================
; Premium Details
; ===================================================================================
; NTL premium structure.

{@ntl_premium}
; Required fields first
total_premium = !#$:(0..)                     ; Total premium

; Optional fields
liability_premium = #$:(0..)                  ; Liability premium
medical_payments_premium = #$:(0..)           ; Med pay premium
minimum_premium = #$:(0..)                    ; Minimum premium
physical_damage_premium = #$:(0..)            ; PD premium
policy_fee = #$:(0..)                         ; Policy fee
taxes_and_fees = #$:(0..)                     ; Taxes/fees
um_uim_premium = #$:(0..)                     ; UM/UIM premium

; ---------------------------------------------------------------------------
; Rating Factors
; ---------------------------------------------------------------------------
{.rating}
accident_surcharge = #                        ; Accident loading
age_factor = #                                ; Age factor
deductible_credit = #                         ; Deductible credit
experience_credit = #                         ; Experience credit
territory_factor = #                          ; Territory
violation_surcharge = #                       ; Violation loading

{@ntl_premium}

; ===================================================================================
; Claims
; ===================================================================================
; NTL claim structure.

{@ntl_claim}
; Required fields first
claim_date = !date                            ; Claim date
claim_type = !(
    bodily_injury,                            ; BI claim
    collision,                                ; Collision
    comprehensive,                            ; Comprehensive
    medical_payments,                         ; Med pay claim
    property_damage,                          ; PD claim
    um_uim,                                   ; UM/UIM claim
    other                                     ; Other
)

; Optional fields
accident_date = date                          ; Accident date
accident_location = :                         ; Location
amount_claimed = #$:(0..)                     ; Amount claimed
amount_paid = #$:(0..)                        ; Amount paid
at_fault = ?                                  ; At-fault indicator
claim_id = :                                  ; Claim ID
claim_status = (
    closed,
    denied,
    litigation,
    negotiation,
    open,
    paid,
    reserved,
    subrogation
)
claimant = :                                  ; Claimant name
coverage_dispute = ?                          ; Coverage dispute
coverage_dispute_reason = ::if coverage_dispute = true
deductible_applied = #$:(0..)                 ; Deductible
description = :                               ; Description
dispatch_status = (
    between_dispatches,                       ; NTL applies
    personal_use,                             ; NTL applies
    under_dispatch,                           ; Primary applies
    unknown                                   ; Under investigation
)
other_vehicle = :                             ; Other vehicle
police_report = :                             ; Police report
reserve = #$:(0..)                            ; Reserve
subrogation = #$:(0..)                        ; Subrogation

; ===================================================================================
; Non-Trucking Liability Policy
; ===================================================================================
; Complete NTL policy structure.

{@ntl_policy}
; Required fields first
coverage = !@ntl_coverage                     ; Coverage terms
effective_date = !date                        ; Policy effective date
expiration_date = !date                       ; Policy expiration date
operator = !@ntl_operator                     ; Insured operator
policy_number = !:                            ; Policy number
vehicle = !@ntl_vehicle                       ; Covered vehicle

; Invariants
:invariant expiration_date > effective_date

; Optional fields
additional_vehicles[] = @ntl_vehicle          ; Additional units
agency = @agency                              ; Issuing agency
claims[] = @ntl_claim                         ; Claims history
endorsements[] = :                            ; Endorsements
exclusions = @ntl_exclusions                  ; Exclusions
id = :                                        ; Internal identifier
loss_payee = :                                ; Lienholder
policy_form = (
    bobtail,                                  ; Bobtail form
    deadhead,                                 ; Deadhead form
    non_trucking                              ; Standard NTL
)
policy_status = (
    active,
    cancelled,
    expired,
    pending,
    suspended
)
premium = @ntl_premium                        ; Premium details
producer = @producer                          ; Agent
underwriting = @underwriting_decision         ; Underwriting

; ---------------------------------------------------------------------------
; Primary Insurance Reference
; ---------------------------------------------------------------------------
{.primary_insurance}
carrier_name = :                              ; Motor carrier
carrier_policy = :                            ; Carrier's policy #
carrier_insurer = :                           ; Carrier's insurer
mc_number = :                                 ; Carrier MC number
primary_limit = #$:(0..)                      ; Carrier's limit

{@ntl_policy}

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
csl_limit = #$:(0..)                          ; Combined single limit
physical_damage = ?                           ; PD included
vehicle_count = ##                            ; Vehicle count

{@ntl_policy}


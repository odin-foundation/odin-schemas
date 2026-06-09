; ===================================================================================
; ODIN Truckers Liability Insurance Schema
; ===================================================================================
; Truckers liability insurance for commercial motor carriers and owner-operators
; covering primary auto liability, motor truck cargo, physical damage, trailer
; interchange, non-trucking, and FMCSA compliance (MCS-90, BMC-91).
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.transportation.truckers"
version = "1.0.0"
title = "Truckers Liability Insurance Schema"
description = "Commercial motor carrier liability and trucking insurance"

{$derivation}
source[0].authority = "Federal Motor Carrier Safety Administration (FMCSA)"
source[0].citation = "49 CFR Part 387 - Minimum Levels of Financial Responsibility"
source[0].url = "https://www.fmcsa.dot.gov/regulations"

source[1].authority = "U.S. Department of Transportation"
source[1].citation = "Motor Carrier Safety Improvement Act"
source[1].url = "https://www.transportation.gov/"

source[2].authority = "National Association of Insurance Commissioners (NAIC)"
source[2].citation = "Commercial Auto Insurance Manual"
source[2].url = "https://content.naic.org/"

source[3].authority = "American Trucking Associations"
source[3].citation = "Trucking Industry Insurance Standards"
source[3].url = "https://www.trucking.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on FMCSA requirements and state trucking regulations"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial truckers liability insurance schema"
changelog[0].rationale = "Commercial transportation coverage for motor carriers"

; ===================================================================================
; Motor Carrier Type
; ===================================================================================
; Classification of motor carrier operations.

{@tk_carrier_type}
carrier_class = (
    common,                                   ; Common carrier (for-hire)
    contract,                                 ; Contract carrier
    exempt,                                   ; Exempt carrier
    owner_operator,                           ; Independent owner-op
    private                                   ; Private carrier
)

; Operating authority
authority_type = (
    broker,                                   ; Freight broker
    freight_forwarder,                        ; Freight forwarder
    household_goods,                          ; HHG mover
    intermodal,                               ; Intermodal carrier
    intrastate,                               ; Intrastate only
    passenger,                                ; Passenger carrier
    property                                  ; Property carrier
)

; Size classification
fleet_size = (
    large,                                    ; 100+ power units
    medium,                                   ; 20-99 power units
    owner_operator,                           ; Single unit
    small                                     ; 2-19 power units
)

; ===================================================================================
; Motor Carrier Details
; ===================================================================================
; Insured motor carrier information.

{@tk_carrier}
; Required fields first
carrier_name = :                             ; Legal entity name
mc_number = :                                ; MC number
usdot_number = :                             ; USDOT number

; Optional fields
address = @address                            ; Business address
billing_address = @address                    ; Billing address
carrier_id = :                                ; Internal identifier
carrier_type = @tk_carrier_type               ; Carrier classification
dba_names[] = :                               ; DBA names
email = *@email                               ; Contact email
fein = *:                                     ; Tax ID
fleet_size = ##                               ; Power unit count
icc_number = :                                ; ICC number (legacy)
phone = *@phone                               ; Contact phone
safety_rating = (
    conditional,                              ; Conditional rating
    not_rated,                                ; Not rated
    satisfactory,                             ; Satisfactory
    unsatisfactory                            ; Unsatisfactory
)
scac_code = :(2..4)                           ; SCAC code
state_of_incorporation = :(2)                 ; State of formation
terminal_addresses[] = @address               ; Terminal locations
years_in_business = ##                        ; Operating years

; ---------------------------------------------------------------------------
; Operating Authority
; ---------------------------------------------------------------------------
{.authority}
authority_date = date                         ; Authority grant date
authority_status = (
    active,                                   ; Active authority
    inactive,                                 ; Inactive
    pending,                                  ; Pending application
    revoked,                                  ; Revoked
    suspended                                 ; Suspended
)
hazmat_authority = ?                          ; Hazmat authorized
household_goods = ?                           ; HHG authority
interstate = ?                                ; Interstate authority
intrastate[] = :(2)                           ; Intrastate states
passenger = ?                                 ; Passenger authority
property = ?                                  ; Property authority

{@tk_carrier}

; ---------------------------------------------------------------------------
; Safety Record
; ---------------------------------------------------------------------------
{.safety}
accidents_12_months = ##                      ; Recent accidents
basic_scores[] = :                            ; BASIC percentiles
compliance_review_date = date                 ; Last review
driver_oos_rate = #                           ; Driver OOS rate
fatalities_24_months = ##                     ; Fatalities
inspections_12_months = ##                    ; Inspection count
out_of_service_rate = #                       ; OOS rate
vehicle_oos_rate = #                          ; Vehicle OOS rate

{@tk_carrier}

; ===================================================================================
; Covered Vehicle
; ===================================================================================
; Commercial vehicle details.

{@tk_vehicle}
; Required fields first
vehicle_type = (
    bobtail,                                  ; Tractor only
    box_truck,                                ; Box truck
    car_hauler,                               ; Auto carrier
    cement_mixer,                             ; Mixer truck
    dump_truck,                               ; Dump truck
    flatbed,                                  ; Flatbed trailer
    intermodal_chassis,                       ; Container chassis
    lowboy,                                   ; Lowboy trailer
    refrigerated,                             ; Reefer trailer
    step_deck,                                ; Step deck trailer
    straight_truck,                           ; Straight truck
    tanker,                                   ; Tank trailer
    tractor,                                  ; Power unit only
    tractor_trailer,                          ; Tractor-trailer combo
    van_trailer                               ; Dry van trailer
)
vin = *:/^[A-HJ-NPR-Z0-9]{17}$/              ; VIN

; Optional fields
axle_count = ##                               ; Number of axles
body_type = :                                 ; Body style
gvwr_lbs = ##                                 ; GVWR
hazmat_placarded = ?                          ; Hazmat capability
leased_from = :                               ; Lessor if leased
license_plate = :                             ; License plate
license_state = :(2)                          ; Registration state
make = :                                      ; Manufacturer
model = :                                     ; Model
model_year = ##:(1950..2100)                  ; Year
odometer = ##                                 ; Current mileage
owned_leased = (leased, owned)                ; Ownership
stated_value = #$:(0..)                       ; Stated value
unit_number = :                               ; Fleet unit number
vehicle_id = :                                ; Internal identifier

; ---------------------------------------------------------------------------
; Physical Damage
; ---------------------------------------------------------------------------
{.physical_damage}
collision_coverage = ?                        ; Collision
collision_deductible = #$:(0..):if collision_coverage = true
comprehensive_coverage = ?                    ; Comprehensive
comprehensive_deductible = #$:(0..):if comprehensive_coverage = true
specified_perils = ?                          ; Specified perils
stated_amount = #$:(0..)                      ; Insured value
valuation = (
    actual_cash_value,
    agreed_value,
    replacement_cost,
    stated_amount
)

{@tk_vehicle}

; ---------------------------------------------------------------------------
; Ratings and Premiums
; ---------------------------------------------------------------------------
{.rating}
primary_factor = #                            ; Primary rating factor
radius_class = (local, intermediate, long_haul, regional)
symbol = ##                                   ; Rate symbol
territory = :                                 ; Rating territory
use_class = (
    food_delivery,
    general_freight,
    hazmat,
    heavy_haul,
    logging,
    retail_delivery,
    specialized,
    truckload
)

{@tk_vehicle}

; ===================================================================================
; Driver Information
; ===================================================================================
; Commercial driver details.

{@tk_driver}
; Required fields first
cdl_class = (A, B, C)                        ; CDL class
cdl_number = *:                              ; CDL number
cdl_state = :(2)                             ; CDL state
date_of_birth = *date                        ; Date of birth
name = @person_name                          ; Driver name

; Optional fields
cdl_expiration = date                         ; CDL expiry
date_of_hire = date                           ; Hire date
driver_id = :                                 ; Internal identifier
endorsements[] = (H, N, P, S, T, X)           ; CDL endorsements
experience_years = ##                         ; Driving experience
hazmat_endorsement = ?                        ; Has H endorsement
medical_card_expiration = date                ; Medical cert expiry
mvr_date = date                               ; Last MVR date
restrictions[] = :                            ; CDL restrictions
sex = (female, male)                          ; Gender
twic_card = ?                                 ; TWIC cardholder

; ---------------------------------------------------------------------------
; Driving Record
; ---------------------------------------------------------------------------
{.record}
accidents_3_years = ##:(0..10)                ; At-fault accidents
dui_convictions = ##:(0..10)                  ; DUI count
felony_convictions = ?                        ; Felony history
major_violations = ##:(0..10)                 ; Major violations
minor_violations = ##:(0..10)                 ; Minor violations
moving_violations = ##:(0..10)                ; Moving violations
suspended_license = ?                         ; Suspension history

{@tk_driver}

; ===================================================================================
; Liability Coverage
; ===================================================================================
; Truckers liability coverage.

{@tk_liability}
; Required fields first
bodily_injury_per_accident = #$:(0..)        ; BI per accident
bodily_injury_per_person = #$:(0..)          ; BI per person
property_damage = #$:(0..)                   ; PD limit

; Optional fields
combined_single_limit = #$:(0..)              ; CSL
liability_form = (
    combined_single_limit,                    ; CSL
    split_limits                              ; Split limits
)

; FMCSA minimums
fmcsa_minimum = (
    general_freight_750k,                     ; $750,000 general
    hazmat_1m,                                ; $1M non-bulk hazmat
    hazmat_5m,                                ; $5M bulk hazmat
    household_goods_750k,                     ; $750,000 HHG
    oil_1m,                                   ; $1M oil
    passenger_1_5m,                           ; $1.5M passenger small
    passenger_5m                              ; $5M passenger large
)

; Additional liability
excess_liability = #$:(0..)                   ; Excess/umbrella
hired_auto = ?                                ; Hired auto coverage
non_owned_auto = ?                            ; Non-owned coverage

; ===================================================================================
; Motor Truck Cargo Coverage
; ===================================================================================
; Cargo liability coverage.

{@tk_cargo}
; Required coverage for for-hire carriers
included = ?                                 ; Cargo coverage

; Coverage terms
deductible = #$:(0..):if included = true      ; Cargo deductible
limit_per_occurrence = #$:(0..):if included = true  ; Per loss limit
limit_per_vehicle = #$:(0..):if included = true     ; Per vehicle limit
trailer_interchange = ?:if included = true    ; TI cargo covered

; Commodity restrictions
excluded_commodities[] = ::if included = true ; Excluded cargo
hazmat_covered = ?:if included = true         ; Hazmat cargo
high_value_sublimit = #$:(0..):if included = true
refrigerated_covered = ?:if included = true   ; Reefer cargo

; Coverage territory
territory = (
    continental_us,                           ; 48 states
    north_america,                            ; US/Canada/Mexico
    us_canada                                 ; US and Canada
):if included = true

; ===================================================================================
; Trailer Interchange Coverage
; ===================================================================================
; Coverage for non-owned trailers.

{@tk_trailer_interchange}
included = ?                                  ; TI coverage
deductible = #$:(0..):if included = true      ; TI deductible
limit = #$:(0..):if included = true           ; TI limit
per_trailer_limit = #$:(0..):if included = true  ; Per trailer

; Covered agreements
interchange_agreements[] = ::if included = true  ; Partner carriers
type = (
    collision_only,                           ; Collision only
    comprehensive_collision                   ; Full coverage
):if included = true

; ===================================================================================
; Non-Trucking Liability
; ===================================================================================
; Bobtail/deadhead coverage.

{@tk_non_trucking}
included = ?                                  ; NTL coverage
combined_single_limit = #$:(0..):if included = true
deductible = #$:(0..):if included = true

; Coverage scope
deadhead = ?:if included = true               ; Deadheading covered
personal_use = ?:if included = true           ; Personal use
repo_driving = ?:if included = true           ; Repo/delivery

; ===================================================================================
; Physical Damage Coverage
; ===================================================================================
; Physical damage for fleet.

{@tk_physical_damage}
; Required fields
coverage_type = (collision, comprehensive, specified_perils)

; Coverage terms
deductible = #$:(0..)                         ; Deductible
limit = #$:(0..)                              ; Coverage limit
valuation = (
    actual_cash_value,
    agreed_value,
    replacement_cost,
    stated_amount
)

; Additional coverages
downtime = ?                                  ; Downtime coverage
downtime_daily = #$:(0..):if downtime = true
downtime_max = #$:(0..):if downtime = true
rental_reimbursement = ?                      ; Rental coverage
rental_daily = #$:(0..):if rental_reimbursement = true
rental_max_days = ##:if rental_reimbursement = true
towing = ?                                    ; Towing coverage
towing_limit = #$:(0..):if towing = true

; ===================================================================================
; FMCSA Filings
; ===================================================================================
; Required regulatory filings.

{@tk_filings}
; BMC-91 (Financial Responsibility)
bmc_91_filed = ?                              ; BMC-91 filed
bmc_91_effective = date:if bmc_91_filed = true
bmc_91_limit = #$:(0..):if bmc_91_filed = true

; MCS-90 (Public Liability)
mcs_90_attached = ?                           ; MCS-90 attached
mcs_90_effective = date:if mcs_90_attached = true

; BMC-32 (Cargo)
bmc_32_filed = ?                              ; BMC-32 filed
bmc_32_effective = date:if bmc_32_filed = true
bmc_32_limit = #$:(0..):if bmc_32_filed = true

; BMC-34 (Surety Bond)
bmc_34_filed = ?                              ; BMC-34 filed

; MCS-90B (Pollution)
mcs_90b_attached = ?                          ; MCS-90B attached
mcs_90b_effective = date:if mcs_90b_attached = true

; Form E / Form H
form_e_filed = ?                              ; Form E required
form_h_filed = ?                              ; Form H required

; Filing states
intrastate_filings[] = :(2)                   ; State filings

; ===================================================================================
; Premium Details
; ===================================================================================
; Truckers premium structure.

{@tk_premium}
; Required fields first
total_premium = #$:(0..)                     ; Total premium

; Optional fields
cargo_premium = #$:(0..)                      ; Cargo premium
general_liability_premium = #$:(0..)          ; GL if included
liability_premium = #$:(0..)                  ; Auto liability
minimum_premium = #$:(0..)                    ; Minimum premium
physical_damage_premium = #$:(0..)            ; PD premium
policy_fee = #$:(0..)                         ; Policy fee
taxes_and_fees = #$:(0..)                     ; Taxes/fees
trailer_interchange_premium = #$:(0..)        ; TI premium

; ---------------------------------------------------------------------------
; Rating Factors
; ---------------------------------------------------------------------------
{.rating}
accident_surcharge = #                        ; Accident loading
deductible_credit = #                         ; Deductible credit
driver_surcharge = #                          ; Driver loading
experience_mod = #                            ; Experience mod
fleet_size_credit = #                         ; Fleet credit
safety_credit = #                             ; Safety discount
territory_factor = #                          ; Territory factor

{@tk_premium}

; ===================================================================================
; Claims
; ===================================================================================
; Trucking claims structure.

{@tk_claim}
; Required fields first
claim_date = date                            ; Claim date
claim_type = (
    bodily_injury,                            ; BI claim
    cargo,                                    ; Cargo claim
    collision,                                ; Collision
    comprehensive,                            ; Comp claim
    environmental,                            ; Environmental
    property_damage,                          ; PD claim
    trailer_interchange,                      ; TI claim
    wrongful_death,                           ; Wrongful death
    other                                     ; Other
)

; Optional fields
accident_date = date                          ; Accident date
accident_location = :                         ; Location
amount_claimed = #$:(0..)                     ; Amount claimed
amount_paid = #$:(0..)                        ; Amount paid
at_fault = ?                                  ; At-fault indicator
claim_id = :                                  ; Claim identifier
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
claimant_name = :                             ; Claimant
deductible_applied = #$:(0..)                 ; Deductible
description = :                               ; Description
dot_recordable = ?                            ; DOT recordable
driver_reference = :                          ; Driver involved
fatality = ?                                  ; Fatality involved
hazmat_release = ?                            ; Hazmat involved
injuries = ##                                 ; Injury count
other_vehicle = :                             ; Other vehicle
police_report = :                             ; Police report
reserve = #$:(0..)                            ; Reserve amount
subrogation = #$:(0..)                        ; Subrogation
vehicle_reference = :                         ; Vehicle involved

; ===================================================================================
; Exclusions
; ===================================================================================
; Policy exclusions.

{@tk_exclusions}
; Standard exclusions
expected_intended = ?true                     ; Expected/intended
fellow_employee = ?                           ; Fellow employee
nuclear = ?true                               ; Nuclear
pollution_standard = ?true                    ; Standard pollution
racing = ?true                                ; Racing
war = ?true                                   ; War/terrorism
workers_comp = ?true                          ; Workers comp

; Auto-specific
completed_operations = ?                      ; Comp ops
employee_indemnification = ?                  ; Employee indem
employment_practices = ?                      ; Employment
professional_services = ?                     ; Professional

; Trucking-specific
logging_operations = ?                        ; Logging
mining_operations = ?                         ; Mining
oilfield_operations = ?                       ; Oilfield

; ===================================================================================
; Truckers Liability Policy
; ===================================================================================
; Complete truckers policy structure.

{@truckers_policy}
; Required fields first
carrier = @tk_carrier                        ; Insured carrier
effective_date = date                        ; Policy effective date
expiration_date = date                       ; Policy expiration date
liability = @tk_liability                    ; Liability coverage
policy_number = :                            ; Policy number
vehicles[] = @tk_vehicle                     ; Covered vehicles

; Invariants
:invariant expiration_date > effective_date

; Optional fields
agency = @agency                              ; Issuing agency
cargo = @tk_cargo                             ; Cargo coverage
claims[] = @tk_claim                          ; Claims history
collision = @tk_physical_damage               ; Collision coverage
comprehensive = @tk_physical_damage           ; Comprehensive coverage
drivers[] = @tk_driver                        ; Covered drivers
endorsements[] = :                            ; Endorsement list
exclusions = @tk_exclusions                   ; Exclusions
filings = @tk_filings                         ; Regulatory filings
id = :                                        ; Internal identifier
non_trucking = @tk_non_trucking               ; NTL coverage
policy_form = (
    commercial_auto,                          ; Standard CA form
    motor_carrier,                            ; MC-specific form
    truckers                                  ; Truckers form
)
policy_status = (
    active,
    cancelled,
    expired,
    pending,
    suspended
)
premium = @tk_premium                         ; Premium details
producer = @producer                          ; Agent
trailer_interchange = @tk_trailer_interchange ; TI coverage
underwriting = @underwriting_decision         ; Underwriting

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
cargo_limit = #$:(0..)                        ; Cargo limit
driver_count = ##                             ; Driver count
liability_limit = :                           ; Liability string
vehicle_count = ##                            ; Vehicle count

{@truckers_policy}


; ===================================================================================
; ODIN Trailer Interchange Insurance Schema
; ===================================================================================
; Trailer interchange insurance providing physical damage coverage for non-owned
; trailers operated under trailer interchange agreements between motor carriers
; including specified perils, collision, comprehensive, and all-risk.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.transportation.trailer-interchange"
version = "1.0.0"
title = "Trailer Interchange Insurance Schema"
description = "Physical damage coverage for non-owned trailers under interchange"

{$derivation}
source[0].authority = "Federal Motor Carrier Safety Administration (FMCSA)"
source[0].citation = "Motor Carrier Trailer Interchange Regulations"
source[0].url = "https://www.fmcsa.dot.gov/"

source[1].authority = "Intermodal Association of North America (IANA)"
source[1].citation = "Uniform Intermodal Interchange Agreement"
source[1].url = "https://www.intermodal.org/"

source[2].authority = "Truckload Carriers Association"
source[2].citation = "Trailer Interchange Best Practices"
source[2].url = "https://www.truckload.org/"

source[3].authority = "National Association of Insurance Commissioners (NAIC)"
source[3].citation = "Commercial Auto - Trailer Interchange Coverage"
source[3].url = "https://content.naic.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on IANA UIIA and industry interchange standards"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial trailer interchange insurance schema"
changelog[0].rationale = "Physical damage coverage for interchanged trailers"

; ===================================================================================
; Motor Carrier
; ===================================================================================
; Insured motor carrier details.

{@ti_carrier}
; Required fields first
carrier_name = :                             ; Legal name
mc_number = :                                ; MC number
usdot_number = :                             ; USDOT number

; Optional fields
address = @address                            ; Business address
carrier_id = :                                ; Internal identifier
email = *@email                               ; Contact email
fein = *:                                     ; Tax ID
fleet_size = ##                               ; Power unit count
phone = *@phone                               ; Contact phone
scac_code = :(2..4)                           ; SCAC code
trailer_count = ##                            ; Owned trailer count

; ===================================================================================
; Interchange Agreement
; ===================================================================================
; Trailer interchange agreement details.

{@ti_agreement}
; Required fields first
agreement_type = (
    bilateral,                                ; Two-way interchange
    intermodal,                               ; Intermodal container
    private,                                  ; Private agreement
    uiia                                      ; IANA UIIA
)
partner_name = :                             ; Partner carrier name

; Optional fields
agreement_date = date                         ; Agreement effective
agreement_id = :                              ; Agreement reference
cargo_liability = ?                           ; Cargo in TI trailers
expiration_date = date                        ; Agreement expiration
insurance_required = ?                        ; Insurance mandatory
minimum_coverage = #$:(0..)                   ; Required minimum
partner_mc = :                                ; Partner MC number
partner_scac = :(2..4)                        ; Partner SCAC
partner_usdot = :                             ; Partner USDOT
proof_of_insurance = ?                        ; POI required

; ---------------------------------------------------------------------------
; UIIA Compliance
; ---------------------------------------------------------------------------
{.uiia}
equipment_provider = ?:if agreement_type = uiia  ; EP registered
motor_carrier = ?:if agreement_type = uiia       ; MC registered
scac_registered = ?:if agreement_type = uiia     ; SCAC active
uiia_addendum[] = ::if agreement_type = uiia     ; Addenda applied
uiia_member = ?:if agreement_type = uiia         ; UIIA membership

{@ti_agreement}

; ===================================================================================
; Trailer Type
; ===================================================================================
; Types of trailers covered under interchange.

{@ti_trailer_type}
trailer_class = (
    chassis,                                  ; Container chassis
    container_20,                             ; 20' container
    container_40,                             ; 40' container
    container_40_hc,                          ; 40' high cube
    container_45,                             ; 45' container
    container_53,                             ; 53' container
    dry_van_48,                               ; 48' dry van
    dry_van_53,                               ; 53' dry van
    flatbed,                                  ; Flatbed trailer
    refrigerated,                             ; Reefer trailer
    specialized,                              ; Specialized
    tank                                      ; Tank trailer
)

; Trailer characteristics
axle_count = ##:(1..5)                        ; Number of axles
gvwr_lbs = ##                                 ; GVWR
length_feet = ##                              ; Length
refrigerated = ?                              ; Reefer unit
specialized_equipment = ?                     ; Special equipment

; ===================================================================================
; Trailer Interchange Coverage
; ===================================================================================
; TI physical damage coverage terms.

{@ti_coverage}
; Required fields first
coverage_form = (
    all_risk,                                 ; All-risk coverage
    collision_only,                           ; Collision only
    comprehensive_collision,                  ; Full coverage
    specified_perils                          ; Named perils
)
limit_per_trailer = #$:(0..)                 ; Per trailer limit

; Optional fields
aggregate_limit = #$:(0..)                    ; Annual aggregate
deductible = #$:(0..)                         ; Deductible
deductible_type = (flat, percentage)          ; Deductible type

; ---------------------------------------------------------------------------
; Covered Perils
; ---------------------------------------------------------------------------
{.perils}
collision = ?                                 ; Collision damage
comprehensive = ?                             ; Comprehensive
explosion = ?                                 ; Explosion
fire = ?                                      ; Fire
flood = ?                                     ; Flood
hail = ?                                      ; Hail
lightning = ?                                 ; Lightning
malicious_mischief = ?                        ; Vandalism
theft = ?                                     ; Theft
windstorm = ?                                 ; Windstorm

{@ti_coverage}

; ---------------------------------------------------------------------------
; Coverage Extensions
; ---------------------------------------------------------------------------
{.extensions}
debris_removal = ?                            ; Debris removal
debris_limit = #$:(0..):if extensions.debris_removal = true
loss_of_use = ?                               ; Loss of use
loss_of_use_daily = #$:(0..):if extensions.loss_of_use = true
loss_of_use_max_days = ##:if extensions.loss_of_use = true
reefer_breakdown = ?                          ; Reefer unit failure
reefer_cargo = ?                              ; Cargo in reefer
tires = ?                                     ; Tire coverage
towing = ?                                    ; Towing coverage
towing_limit = #$:(0..):if extensions.towing = true

{@ti_coverage}

; ---------------------------------------------------------------------------
; Territory
; ---------------------------------------------------------------------------
territory = (
    continental_us,                           ; 48 states
    north_america,                            ; US/Canada/Mexico
    us_canada                                 ; US and Canada
)

; ===================================================================================
; Scheduled Trailers (Optional)
; ===================================================================================
; Specific trailers scheduled on policy.

{@ti_scheduled_trailer}
; Required fields first
owner = :                                    ; Trailer owner
trailer_type = @ti_trailer_type              ; Trailer classification

; Optional fields
equipment_number = :                          ; Equipment number
limit = #$:(0..)                              ; Scheduled limit
make = :                                      ; Manufacturer
model_year = ##:(1950..2100)                  ; Year
serial_number = :                             ; Serial number
vin = *:                                       ; VIN if applicable

; ===================================================================================
; Exclusions
; ===================================================================================
; Standard TI exclusions.

{@ti_exclusions}
; Standard exclusions
expected_intended = ?true                     ; Expected/intended
illegal_use = ?true                           ; Illegal operations
nuclear = ?true                               ; Nuclear
racing = ?true                                ; Racing
war = ?true                                   ; War/terrorism
wear_and_tear = ?true                         ; Normal wear

; TI-specific exclusions
cargo_damage = ?                              ; Cargo in trailer
conversion = ?                                ; Conversion of trailer
mechanical_breakdown = ?                      ; Mechanical failure
mysterious_disappearance = ?                  ; Missing trailer
owned_trailers = ?true                        ; Owned equipment
rental_trailers = ?                           ; Rental trailers
tire_damage_only = ?                          ; Tire-only damage

; ===================================================================================
; Premium Details
; ===================================================================================
; TI premium structure.

{@ti_premium}
; Required fields first
total_premium = #$:(0..)                     ; Total premium

; Optional fields
base_premium = #$:(0..)                       ; Base premium
extensions_premium = #$:(0..)                 ; Extensions
minimum_premium = #$:(0..)                    ; Minimum premium
policy_fee = #$:(0..)                         ; Policy fee
scheduled_premium = #$:(0..)                  ; Scheduled trailers
taxes_and_fees = #$:(0..)                     ; Taxes/fees

; ---------------------------------------------------------------------------
; Rating Factors
; ---------------------------------------------------------------------------
{.rating}
claims_experience = #                         ; Experience factor
deductible_credit = #                         ; Deductible credit
fleet_size_factor = #                         ; Fleet size
interchange_volume = #                        ; Volume factor
territory_factor = #                          ; Territory
trailer_type_factor = #                       ; Trailer type

{@ti_premium}

; ===================================================================================
; Claims
; ===================================================================================
; TI claim structure.

{@ti_claim}
; Required fields first
claim_date = date                            ; Claim date
claim_type = (
    collision,                                ; Collision damage
    comprehensive,                            ; Comp loss
    fire,                                     ; Fire damage
    hail,                                     ; Hail damage
    reefer_breakdown,                         ; Reefer failure
    theft,                                    ; Theft
    vandalism,                                ; Vandalism
    water,                                    ; Water damage
    other                                     ; Other
)

; Optional fields
accident_date = date                          ; Incident date
accident_location = :                         ; Location
amount_claimed = #$:(0..)                     ; Amount claimed
amount_paid = #$:(0..)                        ; Amount paid
at_fault = ?                                  ; At-fault indicator
claim_id = :                                  ; Claim ID
claim_status = (
    closed,
    denied,
    negotiation,
    open,
    paid,
    reserved,
    subrogation
)
deductible_applied = #$:(0..)                 ; Deductible
description = :                               ; Description
interchange_partner = :                       ; Partner carrier
partner_claim = :                             ; Partner claim #
reserve = #$:(0..)                            ; Reserve
salvage = #$:(0..)                            ; Salvage
subrogation = #$:(0..)                        ; Subrogation
trailer_owner = :                             ; Trailer owner
trailer_reference = :                         ; Trailer ID

; ===================================================================================
; Trailer Interchange Policy
; ===================================================================================
; Complete TI policy structure.

{@ti_policy}
; Required fields first
carrier = @ti_carrier                        ; Insured carrier
coverage = @ti_coverage                      ; Coverage terms
effective_date = date                        ; Policy effective date
expiration_date = date                       ; Policy expiration date
policy_number = :                            ; Policy number

; Invariants
:invariant expiration_date > effective_date

; Optional fields
agency = @agency                              ; Issuing agency
agreements[] = @ti_agreement                  ; Interchange agreements
claims[] = @ti_claim                          ; Claims history
endorsements[] = :                            ; Endorsements
exclusions = @ti_exclusions                   ; Exclusions
id = :                                        ; Internal identifier
policy_form = (
    blanket,                                  ; Blanket coverage
    scheduled,                                ; Scheduled trailers
    uiia_endorsement                          ; UIIA form
)
policy_status = (
    active,
    cancelled,
    expired,
    pending,
    suspended
)
premium = @ti_premium                         ; Premium details
producer = @producer                          ; Agent
scheduled_trailers[] = @ti_scheduled_trailer  ; Scheduled equipment
trailer_types[] = @ti_trailer_type            ; Covered types
underwriting = @underwriting_decision         ; Underwriting

; ---------------------------------------------------------------------------
; Coverage Summary
; ---------------------------------------------------------------------------
{.summary}
agreement_count = ##                          ; Interchange partners
coverage_type = :                             ; Coverage form
deductible = #$:(0..)                         ; Deductible
per_trailer_limit = #$:(0..)                  ; Per trailer limit

{@ti_policy}


; ===================================================================================
; ODIN Difference in Conditions (DIC) Insurance Schema
; ===================================================================================
; Difference in Conditions (DIC) insurance providing coverage for perils excluded
; by standard property policies, primarily earthquake and flood, with standalone
; or wrap-around policy structures.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.specialty.difference-in-conditions"
version = "1.0.0"
title = "Difference in Conditions Insurance Schema"
description = "Gap coverage for perils excluded from primary property policies"

{$derivation}
source[0].authority = "Insurance Services Office (ISO)"
source[0].citation = "Difference in Conditions Coverage Form"
source[0].url = "https://www.verisk.com/insurance/"

source[1].authority = "National Association of Insurance Commissioners (NAIC)"
source[1].citation = "Specialty Property Insurance - DIC"
source[1].url = "https://content.naic.org/"

source[2].authority = "Federal Emergency Management Agency (FEMA)"
source[2].citation = "National Flood Insurance Program"
source[2].url = "https://www.fema.gov/flood-insurance"

source[3].authority = "California Earthquake Authority"
source[3].citation = "Earthquake Insurance Standards"
source[3].url = "https://www.earthquakeauthority.com/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on ISO DIC forms and surplus lines standards"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial difference in conditions insurance schema"
changelog[0].rationale = "Specialty coverage for property gap coverage"

; ===================================================================================
; Insured Entity
; ===================================================================================

{@dic_insured}
; Required fields first
insured_name = !:                             ; Entity name
insured_type = !(
    commercial,                               ; Commercial owner
    condominium,                              ; Condo association
    homeowner,                                ; High-value HO
    industrial,                               ; Industrial
    institutional,                            ; Institutional
    investor,                                 ; Real estate investor
    municipality,                             ; Government/municipal
    nonprofit,                                ; Nonprofit
    religious,                                ; Religious org
    reit,                                     ; REIT
    resort                                    ; Resort/hospitality
)

; Optional fields
address = @address                            ; Business address
contact_email = *@email                       ; Contact email
contact_phone = *@phone                       ; Contact phone
fein = *:                                     ; Tax ID
insured_id = :                                ; Internal identifier
primary_carrier = :                           ; Primary insurer
primary_policy = :                            ; Primary policy number

; ===================================================================================
; Property Details
; ===================================================================================

{@dic_property}
; Required fields first
location_address = !@address                  ; Property address
property_type = !(
    apartment,                                ; Apartment complex
    condo,                                    ; Condominium
    educational,                              ; School/university
    healthcare,                               ; Hospital/medical
    hospitality,                              ; Hotel/resort
    industrial,                               ; Industrial/warehouse
    manufacturing,                            ; Manufacturing
    mixed_use,                                ; Mixed use
    office,                                   ; Office building
    religious,                                ; Church/temple
    residential,                              ; High-value home
    retail,                                   ; Retail
    special_use                               ; Special purpose
)
total_insured_value = !#$:(0..)               ; Total TIV

; Optional fields
building_value = #$:(0..)                     ; Building value
business_personal_property = #$:(0..)         ; BPP value
construction_type = (
    fire_resistive,                           ; Class 1
    joisted_masonry,                          ; Class 3
    masonry_non_combustible,                  ; Class 2
    modified_fire_resistive,                  ; Class 2
    non_combustible,                          ; Class 2
    wood_frame                                ; Class 4
)
contents_value = #$:(0..)                     ; Contents value
flood_zone = :                                ; FEMA flood zone
lat = #:(-90..90)                             ; Latitude
long = #:(-180..180)                          ; Longitude
occupancy = :                                 ; Occupancy type
property_id = :                               ; Internal identifier
replacement_cost = ?                          ; RC valuation
soil_type = :                                 ; Soil classification
square_feet = ##                              ; Building size
stories = ##                                  ; Number of floors
year_built = ##                               ; Year constructed

; ===================================================================================
; Primary Policy Reference
; ===================================================================================

{@dic_primary}
; Primary policy details
carrier = :                                   ; Primary carrier
policy_number = :                             ; Primary policy #
effective_date = date                         ; Primary effective
expiration_date = date                        ; Primary expiration

; Primary coverage
primary_limit = #$:(0..)                      ; Primary limit
primary_deductible = #$:(0..)                 ; Primary deductible

; Excluded perils in primary
earthquake_excluded = ?                       ; EQ excluded
flood_excluded = ?                            ; Flood excluded
landslide_excluded = ?                        ; Landslide excluded
mudflow_excluded = ?                          ; Mudflow excluded
sinkhole_excluded = ?                         ; Sinkhole excluded
volcanic_excluded = ?                         ; Volcanic excluded

; ===================================================================================
; DIC Coverage
; ===================================================================================

{@dic_coverage}
; Required fields first
policy_limit = !#$:(0..)                      ; DIC limit

; Deductible
deductible = #$:(0..)                         ; Flat deductible
deductible_percentage = #:(0..25)             ; Percentage deductible
deductible_minimum = #$:(0..)                 ; Minimum deductible

; Coverage form
coverage_form = (
    all_risk,                                 ; All-risk DIC
    earthquake_only,                          ; Earthquake only
    flood_only,                               ; Flood only
    named_perils                              ; Named perils DIC
)

; ---------------------------------------------------------------------------
; Earthquake Coverage
; ---------------------------------------------------------------------------
{.earthquake}
included = ?                                  ; Earthquake coverage
aftershock_hours = ##:if included = true      ; Aftershock period
building = #$:(0..):if included = true        ; Building limit
contents = #$:(0..):if included = true        ; Contents limit
deductible_percentage = #:(0..25):if included = true
fire_following = ?:if included = true         ; Fire following EQ
limit = #$:(0..):if included = true           ; EQ limit
sprinkler_leakage = ?:if included = true      ; Sprinkler damage
tsunami = ?:if included = true                ; Tsunami covered

{@dic_coverage}

; ---------------------------------------------------------------------------
; Flood Coverage
; ---------------------------------------------------------------------------
{.flood}
included = ?                                  ; Flood coverage
building = #$:(0..):if included = true        ; Building limit
contents = #$:(0..):if included = true        ; Contents limit
deductible = #$:(0..):if included = true      ; Flood deductible
excess_over_nfip = ?:if included = true       ; Excess over NFIP
flash_flood = ?:if included = true            ; Flash flood
limit = #$:(0..):if included = true           ; Flood limit
nfip_limit = #$:(0..):if included = true      ; Underlying NFIP
storm_surge = ?:if included = true            ; Storm surge
surface_water = ?:if included = true          ; Surface water

{@dic_coverage}

; ---------------------------------------------------------------------------
; Earth Movement Coverage
; ---------------------------------------------------------------------------
{.earth_movement}
included = ?                                  ; Earth movement
deductible = #$:(0..):if included = true      ; EM deductible
landslide = ?:if included = true              ; Landslide
limit = #$:(0..):if included = true           ; EM limit
mine_subsidence = ?:if included = true        ; Mine subsidence
mudflow = ?:if included = true                ; Mudflow
sinkhole = ?:if included = true               ; Sinkhole collapse
volcanic = ?:if included = true               ; Volcanic activity

{@dic_coverage}

; ---------------------------------------------------------------------------
; Business Interruption
; ---------------------------------------------------------------------------
{.business_interruption}
included = ?                                  ; BI for DIC perils
civil_authority = ?:if included = true        ; Civil authority
contingent_bi = ?:if included = true          ; Contingent BI
extended_period = ##:if included = true       ; Extended period
extra_expense = ?:if included = true          ; Extra expense
indemnity_days = ##:if included = true        ; Indemnity period
limit = #$:(0..):if included = true           ; BI limit
waiting_period_days = ##:if included = true   ; Waiting period

{@dic_coverage}

; ===================================================================================
; Premium Details
; ===================================================================================

{@dic_premium}
; Required fields first
total_premium = !#$:(0..)                     ; Total premium

; Optional fields
bi_premium = #$:(0..)                         ; BI premium
earth_movement_premium = #$:(0..)             ; Earth movement
earthquake_premium = #$:(0..)                 ; Earthquake
flood_premium = #$:(0..)                      ; Flood
minimum_premium = #$:(0..)                    ; Minimum premium
policy_fee = #$:(0..)                         ; Policy fee
taxes_and_fees = #$:(0..)                     ; Taxes/fees

; Rating basis
rate_per_100 = #                              ; Rate per $100 TIV

; ---------------------------------------------------------------------------
; Rating Factors
; ---------------------------------------------------------------------------
{.rating}
construction_factor = #                       ; Construction class
deductible_credit = #                         ; Deductible factor
flood_zone_factor = #                         ; Flood zone
location_factor = #                           ; Seismic/flood zone
occupancy_factor = #                          ; Occupancy type
soil_factor = #                               ; Soil type
tiv_factor = #                                ; TIV tier

{@dic_premium}

; ===================================================================================
; Claims
; ===================================================================================

{@dic_claim}
; Required fields first
claim_date = !date                            ; Claim date
claim_type = !(
    business_interruption,                    ; BI loss
    earthquake,                               ; Earthquake damage
    fire_following,                           ; Fire following EQ
    flood,                                    ; Flood damage
    landslide,                                ; Landslide
    mudflow,                                  ; Mudflow
    sinkhole,                                 ; Sinkhole collapse
    storm_surge,                              ; Storm surge
    tsunami,                                  ; Tsunami
    volcanic,                                 ; Volcanic
    other                                     ; Other
)

; Optional fields
amount_claimed = #$:(0..)                     ; Amount claimed
amount_paid = #$:(0..)                        ; Amount paid
bi_loss = #$:(0..)                            ; BI component
building_damage = #$:(0..)                    ; Building damage
claim_id = :                                  ; Claim ID
claim_status = (
    closed,
    denied,
    open,
    paid,
    reserved
)
contents_damage = #$:(0..)                    ; Contents damage
deductible_applied = #$:(0..)                 ; Deductible
description = :                               ; Description
incident_date = date                          ; Event date
primary_claim = ?                             ; Primary claim filed
primary_payment = #$:(0..):if primary_claim = true
property_reference = :                        ; Property ID
reserve = #$:(0..)                            ; Reserve amount

; ===================================================================================
; DIC Policy
; ===================================================================================

{@dic_policy}
; Required fields first
coverage = !@dic_coverage                     ; Coverage terms
effective_date = !date                        ; Policy effective date
expiration_date = !date                       ; Policy expiration date
insured = !@dic_insured                       ; Insured entity
policy_number = !:                            ; Policy number
properties[] = !@dic_property                 ; Covered properties

; Invariants
:invariant expiration_date > effective_date

; Optional fields
agency = @agency                              ; Issuing agency
claims[] = @dic_claim                         ; Claims history
endorsements[] = :                            ; Policy endorsements
id = :                                        ; Internal identifier
policy_form = (
    blanket,                                  ; Blanket coverage
    scheduled,                                ; Scheduled locations
    single_location                           ; Single property
)
policy_status = (
    active,
    cancelled,
    expired,
    non_renewed,
    pending
)
premium = @dic_premium                        ; Premium details
primary = @dic_primary                        ; Primary policy ref
producer = @producer                          ; Agent
underwriting = @underwriting_decision         ; Underwriting

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
earthquake_limit = #$:(0..)                   ; Earthquake limit
flood_limit = #$:(0..)                        ; Flood limit
insured_name = :                              ; Insured name
location_count = ##                           ; Number of locations
policy_limit = #$:(0..)                       ; DIC limit
total_tiv = #$:(0..)                          ; Total TIV

{@dic_policy}


; ===================================================================================
; ODIN Film Production Insurance Schema
; ===================================================================================
; Film, television, and video production insurance covering cast, crew, equipment,
; and production-specific exposures including negative film/faulty stock, props,
; sets, wardrobe, extra expense, and errors and omissions.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.entertainment.film-production"
version = "1.0.0"
title = "Film Production Insurance Schema"
description = "Insurance for film, television, and video production operations"

{$derivation}
source[0].authority = "Association of Film Commissioners International"
source[0].citation = "Production Insurance Requirements"
source[0].url = "https://afci.org/"

source[1].authority = "Producers Guild of America"
source[1].citation = "Production Best Practices and Insurance"
source[1].url = "https://producersguild.org/"

source[2].authority = "Entertainment Industry Insurance Specialists"
source[2].citation = "Production Insurance Coverage Standards"
source[2].url = "https://www.entertainmentinsurancespecialists.com/"

source[3].authority = "California Film Commission"
source[3].citation = "Film Production Insurance and Permit Requirements"
source[3].url = "https://film.ca.gov/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on entertainment industry insurance standards"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial film production insurance schema"
changelog[0].rationale = "Commercial entertainment coverage for production companies"

; ===================================================================================
; Production Type Classification
; ===================================================================================

{@fp_production_type}
category = !(
    commercial,                               ; Commercials/ads
    corporate,                                ; Corporate video
    documentary,                              ; Documentary
    episodic,                                 ; TV series
    feature_film,                             ; Feature film
    independent,                              ; Independent film
    music_video,                              ; Music video
    pilot,                                    ; TV pilot
    reality,                                  ; Reality TV
    short_film,                               ; Short film
    streaming,                                ; Streaming content
    student,                                  ; Student film
    web_series                                ; Web series
)

; Distribution method
distribution = (
    broadcast,                                ; Broadcast TV
    cable,                                    ; Cable network
    streaming,                                ; Streaming platform
    theatrical,                               ; Theatrical release
    web                                       ; Web/digital
)

; Union status
union_status = (
    iatse,                                    ; IATSE production
    non_union,                                ; Non-union
    sag_aftra                                 ; SAG-AFTRA
)

; ===================================================================================
; Production Details
; ===================================================================================

{@fp_production}
; Required fields first
budget = !#$:(0..)                            ; Total production budget
production_company = !:                       ; Production company name
production_title = !:                         ; Working title
production_type = !@fp_production_type        ; Production classification

; Optional fields
above_the_line = #$:(0..)                     ; Above-line budget
below_the_line = #$:(0..)                     ; Below-line budget
completion_bond = ?                           ; Completion guarantor
contact_email = *@email                       ; Contact email
contact_phone = *@phone                       ; Contact phone
crew_size = ##                                ; Crew count
director = :                                  ; Director name
distributor = :                               ; Distribution company
end_date = date                               ; Wrap date
fein = *:                                     ; Tax ID
filming_locations[] = :                       ; Filming locations
foreign_locations = ?                         ; International filming
negative_cost = #$:(0..)                      ; Negative cost
post_production = ?                           ; Post-production period
pre_production_start = date                   ; Pre-production start
principal_photography_end = date              ; End of principal
principal_photography_start = date            ; Start of principal
producer = :                                  ; Producer name
production_id = :                             ; Internal identifier
production_manager = :                        ; UPM name
start_date = date                             ; Start date
studio = :                                    ; Studio/financier

; ---------------------------------------------------------------------------
; Hazardous Activities
; ---------------------------------------------------------------------------
{.hazards}
aerial_work = ?                               ; Aerial filming
aircraft = ?                                  ; Aircraft use
animals = ?                                   ; Animal work
explosives = ?                                ; Pyrotechnics
firearms = ?                                  ; Weapons/firearms
motor_vehicles = ?                            ; Vehicle chases
stunts = ?                                    ; Stunt work
underwater = ?                                ; Underwater filming
watercraft = ?                                ; Watercraft use

{@fp_production}

; ===================================================================================
; Cast Insurance
; ===================================================================================

{@fp_cast}
included = ?                                  ; Cast coverage

; Essential elements
death_disability = #$:(0..):if included = true  ; Death/disability limit
each_person = #$:(0..):if included = true       ; Per person limit
essential_elements[] = ::if included = true     ; Covered cast

; Cast details
cast_count = ##:if included = true            ; Number of covered cast
deductible = #$:(0..):if included = true      ; Deductible
kidnap_ransom = ?:if included = true          ; K&R coverage
medical_exam = ?:if included = true           ; Medical exam required
mental_nervous = ?:if included = true         ; Mental/nervous covered
pre_existing = ?:if included = true           ; Pre-existing conditions
stunt_performer = ?:if included = true        ; Stunt doubles covered

; ===================================================================================
; Negative Film / Faulty Stock
; ===================================================================================

{@fp_negative}
included = ?                                  ; Negative coverage

; Coverage terms
aggregate = #$:(0..):if included = true       ; Annual aggregate
deductible = #$:(0..):if included = true      ; Deductible
digital_media = ?:if included = true          ; Digital media covered
extra_expense = ?:if included = true          ; Extra expense
faulty_camera = ?:if included = true          ; Camera malfunction
faulty_processing = ?:if included = true      ; Lab processing
faulty_stock = ?:if included = true           ; Faulty raw stock
limit = #$:(0..):if included = true           ; Coverage limit
rain_cover = ?:if included = true             ; Rain protection

; ===================================================================================
; Props, Sets, Wardrobe
; ===================================================================================

{@fp_props_sets}
included = ?                                  ; PSW coverage

; Coverage terms
deductible = #$:(0..):if included = true      ; Deductible
extra_expense = ?:if included = true          ; Extra expense
hired_equipment = #$:(0..):if included = true ; Rented items
limit = #$:(0..):if included = true           ; Coverage limit
owned_equipment = #$:(0..):if included = true ; Owned items
replacement_cost = ?:if included = true       ; RC valuation
rented_wardrobe = #$:(0..):if included = true ; Rented wardrobe
sets_scenery = #$:(0..):if included = true    ; Sets/scenery
transit = ?:if included = true                ; In-transit coverage

; ===================================================================================
; Equipment Coverage
; ===================================================================================

{@fp_equipment}
included = ?                                  ; Equipment coverage

; Coverage terms
camera_equipment = #$:(0..):if included = true    ; Camera/lens
deductible = #$:(0..):if included = true      ; Deductible
grip_electric = #$:(0..):if included = true   ; Grip/electric
hired_equipment = #$:(0..):if included = true ; Rented equipment
limit = #$:(0..):if included = true           ; Coverage limit
lighting = #$:(0..):if included = true        ; Lighting equipment
mysterious_disappearance = ?:if included = true
owned_equipment = #$:(0..):if included = true ; Owned equipment
sound_equipment = #$:(0..):if included = true ; Sound equipment
transit = ?:if included = true                ; In-transit coverage
vehicles = #$:(0..):if included = true        ; Production vehicles

; ===================================================================================
; Third Party Property Damage
; ===================================================================================

{@fp_third_party}
included = ?                                  ; TPPD coverage

; Coverage terms
deductible = #$:(0..):if included = true      ; Deductible
limit = #$:(0..):if included = true           ; Coverage limit
location_damage = ?:if included = true        ; Location damage
rented_equipment = ?:if included = true       ; Rented equipment damage
vehicle_physical = ?:if included = true       ; Vehicle physical damage

; ===================================================================================
; Extra Expense
; ===================================================================================

{@fp_extra_expense}
included = ?                                  ; Extra expense coverage

; Coverage terms
deductible = #$:(0..):if included = true      ; Deductible
limit = #$:(0..):if included = true           ; Coverage limit
property_damage = ?:if included = true        ; Property damage cause
waiting_period_days = ##:if included = true   ; Time deductible

; ===================================================================================
; General Liability
; ===================================================================================

{@fp_liability}
; Required fields first
each_occurrence = !#$:(0..)                   ; Per occurrence limit
general_aggregate = !#$:(0..)                 ; Aggregate limit

; Optional fields
aircraft_liability = ?                        ; Aircraft liability
aircraft_limit = #$:(0..):if aircraft_liability = true
auto_liability = ?                            ; Auto liability
auto_limit = #$:(0..):if auto_liability = true
deductible = #$:(0..)                         ; Liability deductible
employers_liability = ?                       ; EL coverage
el_limit = #$:(0..):if employers_liability = true
excess_umbrella = ?                           ; Excess/umbrella
excess_limit = #$:(0..):if excess_umbrella = true
host_liquor = ?                               ; Host liquor
medical_payments = #$:(0..)                   ; Med pay
personal_advertising_injury = #$:(0..)        ; Personal/advertising
products_completed = ?                        ; Products/completed ops
watercraft_liability = ?                      ; Watercraft liability
watercraft_limit = #$:(0..):if watercraft_liability = true
workers_comp = ?                              ; Workers compensation

; ===================================================================================
; Errors & Omissions
; ===================================================================================

{@fp_eo}
included = ?                                  ; E&O coverage

; Coverage terms
aggregate = #$:(0..):if included = true       ; Aggregate limit
chain_of_title = ?:if included = true         ; Chain of title
copyright = ?:if included = true              ; Copyright infringement
defamation = ?:if included = true             ; Defamation
deductible = #$:(0..):if included = true      ; Deductible
idea_submission = ?:if included = true        ; Idea submission
invasion_of_privacy = ?:if included = true    ; Privacy claims
limit = #$:(0..):if included = true           ; Per claim limit
music_clearance = ?:if included = true        ; Music clearance
plagiarism = ?:if included = true             ; Plagiarism
title_clearance = ?:if included = true        ; Title clearance
trademark = ?:if included = true              ; Trademark

; ===================================================================================
; Premium Details
; ===================================================================================

{@fp_premium}
; Required fields first
total_premium = !#$:(0..)                     ; Total premium

; Optional fields
cast_premium = #$:(0..)                       ; Cast premium
eo_premium = #$:(0..)                         ; E&O premium
equipment_premium = #$:(0..)                  ; Equipment premium
extra_expense_premium = #$:(0..)              ; Extra expense
liability_premium = #$:(0..)                  ; Liability premium
minimum_premium = #$:(0..)                    ; Minimum premium
negative_premium = #$:(0..)                   ; Negative film
policy_fee = #$:(0..)                         ; Policy fee
props_sets_premium = #$:(0..)                 ; PSW premium
taxes_and_fees = #$:(0..)                     ; Taxes/fees
third_party_premium = #$:(0..)                ; TPPD premium

; ---------------------------------------------------------------------------
; Rating Factors
; ---------------------------------------------------------------------------
{.rating}
budget_factor = #                             ; Budget tier
hazard_factor = #                             ; Hazardous activities
location_factor = #                           ; Location rating
production_type_factor = #                    ; Production type
union_factor = #                              ; Union status

{@fp_premium}

; ===================================================================================
; Claims
; ===================================================================================

{@fp_claim}
; Required fields first
claim_date = !date                            ; Claim date
claim_type = !(
    cast_injury,                              ; Cast injury
    cast_illness,                             ; Cast illness
    copyright,                                ; Copyright claim
    crew_injury,                              ; Crew injury
    defamation,                               ; Defamation
    equipment_damage,                         ; Equipment damage
    equipment_theft,                          ; Equipment theft
    extra_expense,                            ; Production delay
    faulty_stock,                             ; Faulty film/media
    location_damage,                          ; Location damage
    props_damage,                             ; Props/sets damage
    stunt_accident,                           ; Stunt accident
    third_party_injury,                       ; Third-party injury
    vehicle_accident,                         ; Vehicle accident
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
    settled
)
deductible_applied = #$:(0..)                 ; Deductible
description = :                               ; Description
incident_date = date                          ; Incident date
incident_location = :                         ; Where occurred
litigation = ?                                ; In litigation
production_day = ##                           ; Day of production
reserve = #$:(0..)                            ; Reserve amount

; ===================================================================================
; Film Production Policy
; ===================================================================================

{@film_policy}
; Required fields first
effective_date = !date                        ; Policy effective date
expiration_date = !date                       ; Policy expiration date
liability = !@fp_liability                    ; General liability
policy_number = !:                            ; Policy number
production = !@fp_production                  ; Production details

; Invariants
:invariant expiration_date > effective_date

; Optional fields
agency = @agency                              ; Issuing agency
cast = @fp_cast                               ; Cast coverage
claims[] = @fp_claim                          ; Claims history
endorsements[] = :                            ; Policy endorsements
eo = @fp_eo                                   ; E&O coverage
equipment = @fp_equipment                     ; Equipment coverage
extra_expense = @fp_extra_expense             ; Extra expense
id = :                                        ; Internal identifier
negative = @fp_negative                       ; Negative film
policy_form = (
    annual,                                   ; Annual production
    short_term                                ; Single production
)
policy_status = (
    active,
    cancelled,
    expired,
    pending
)
premium = @fp_premium                         ; Premium details
producer = @producer                          ; Agent
props_sets = @fp_props_sets                   ; Props/sets/wardrobe
third_party = @fp_third_party                 ; Third-party property
underwriting = @underwriting_decision         ; Underwriting

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
budget = #$:(0..)                             ; Production budget
liability_limit = #$:(0..)                    ; GL limit
production_title = :                          ; Production name
production_type = :                           ; Type

{@film_policy}


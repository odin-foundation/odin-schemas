; ===================================================================================
; ODIN Protection and Indemnity (P&I) Insurance Schema
; ===================================================================================
; Protection and Indemnity (P&I) mutual insurance for shipowners covering
; third-party liabilities including crew injury/illness, cargo damage, collision
; excess, pollution cleanup, wreck removal, and defense costs.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.marine.protection-indemnity"
version = "1.0.0"
title = "Protection and Indemnity Insurance Schema"
description = "P&I club coverage for shipowner third-party liabilities"

{$derivation}
source[0].authority = "International Group of P&I Clubs"
source[0].citation = "Standard P&I Club Rules and Coverage"
source[0].url = "https://www.igpandi.org/"

source[1].authority = "International Maritime Organization (IMO)"
source[1].citation = "Maritime Liability Conventions (CLC, Fund, Athens, MLC)"
source[1].url = "https://www.imo.org/"

source[2].authority = "Lloyd's Market Association"
source[2].citation = "Charterers P&I Clauses"
source[2].url = "https://www.lmalloyds.com/"

source[3].authority = "U.S. Code"
source[3].citation = "Oil Pollution Act of 1990 (OPA 90) and Jones Act"
source[3].url = "https://www.law.cornell.edu/uscode/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on IG Club rules and international maritime conventions"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial protection and indemnity insurance schema"
changelog[0].rationale = "Commercial marine P&I coverage for vessel operators"

; ===================================================================================
; Entry Type
; ===================================================================================
; Type of P&I club entry (coverage type).

{@pi_entry_type}
entry_class = !(
    bareboat_charterers,                      ; Bareboat charterers P&I
    cargo_interests,                          ; Cargo owner's P&I
    charterers,                               ; Time/voyage charterers
    fixed_premium,                            ; Fixed premium entry
    freight_demurrage_defense,                ; FD&D coverage
    mutual,                                   ; Full mutual entry
    offshore,                                 ; Offshore units
    passenger_vessels,                        ; Passenger ship entry
    ports_terminals,                          ; Port/terminal operators
    small_craft,                              ; Small vessel entry
    specialized,                              ; Specialized risks
    tanker                                    ; Tanker-specific
)

; Entry basis
premium_basis = (
    fixed,                                    ; Fixed premium
    mutual,                                   ; Mutual calls
    mixed                                     ; Combination
)

; ===================================================================================
; Entered Vessel
; ===================================================================================
; Vessel details for P&I entry.

{@pi_vessel}
; Required fields first
gross_tonnage = !##                           ; Gross tonnage
imo_number = !:                               ; IMO number
vessel_name = !:                              ; Vessel name

; Optional fields
beam_meters = #                               ; Beam
call_sign = :                                 ; Radio call sign
classification_society = :                    ; Class society
deadweight_tonnage = ##                       ; DWT
flag_state = :(2..3)                          ; Flag state
hull_insurer = :                              ; Hull underwriter
hull_value = #$:(0..)                         ; Hull agreed value
length_meters = #                             ; LOA
net_tonnage = ##                              ; Net tonnage
official_number = :                           ; Official number
p_and_i_club = :                              ; Current club name
passenger_capacity = ##                       ; Passenger count
port_of_registry = :                          ; Home port
prior_club = :                                ; Previous club
trade = :                                     ; Trading description
vessel_id = :                                 ; Internal identifier
vessel_type = (
    barge,
    bulk_carrier,
    container_ship,
    cruise_ship,
    dry_cargo,
    ferry,
    fishing_vessel,
    general_cargo,
    lpg_lng_carrier,
    offshore_vessel,
    passenger_vessel,
    reefer,
    ro_ro,
    tanker,
    tug_supply,
    yacht
)
year_built = ##:(1900..2100)                  ; Year built

; ---------------------------------------------------------------------------
; Crew Information
; ---------------------------------------------------------------------------
{.crew}
average_crew_count = ##                       ; Average crew
cadets = ##                                   ; Cadets onboard
crew_nationalities[] = :(2..3)                ; Crew flag states
maximum_crew = ##                             ; Max crew capacity
officers = ##                                 ; Officer count
ratings = ##                                  ; Ratings count

{@pi_vessel}

; ---------------------------------------------------------------------------
; Trade and Operations
; ---------------------------------------------------------------------------
{.operations}
bunker_capacity_mt = ##                       ; Bunker capacity
cargo_types[] = :                             ; Cargo carried
container_capacity_teu = ##                   ; TEU if applicable
hazardous_cargo = ?                           ; Carries hazmat
ice_trading = ?                               ; Ice navigation
offshore_operations = ?                       ; Offshore work
passenger_operations = ?                      ; Carries passengers
salvage_operations = ?                        ; Salvage work
trading_area = :                              ; Trading description
towing_operations = ?                         ; Towing services

{@pi_vessel}

; ===================================================================================
; P&I Coverage Terms
; ===================================================================================
; Standard P&I club coverage.

{@pi_coverage}
; Required fields first
limit = !#$:(0..)                             ; Per incident limit

; Optional fields
aggregate_limit = #$:(0..)                    ; Annual aggregate
club_retention = #$:(0..)                     ; Club's retention
deductible = #$:(0..)                         ; Member deductible
excess_layer = #$:(0..)                       ; Excess coverage
free_reserves = ?                             ; Club free reserves
overspill = ?                                 ; IG overspill coverage
pooling_limit = #$:(0..)                      ; Pool limit
reinsurance = ?                               ; Reinsurance backing

; ---------------------------------------------------------------------------
; Protection Coverages (Third-Party)
; ---------------------------------------------------------------------------
{.protection}
; Crew liabilities
crew_death = ?true                            ; Crew death coverage
crew_illness = ?true                          ; Crew illness
crew_injury = ?true                           ; Crew injury
crew_repatriation = ?true                     ; Repatriation costs
diversion = ?true                             ; Diversion expenses
hospital_costs = ?true                        ; Hospital expenses
loss_of_life = ?true                          ; Death claims
medical_costs = ?true                         ; Medical treatment
quarantine = ?true                            ; Quarantine expenses
stowaways = ?                                 ; Stowaway costs
substitute_expenses = ?true                   ; Replacement crew
wages_maintenance = ?true                     ; Wages and maintenance

; Passenger liabilities
passenger_death = ?                           ; Passenger death
passenger_illness = ?                         ; Passenger illness
passenger_injury = ?                          ; Passenger injury
passenger_luggage = ?                         ; Luggage claims

; Third-party property
collision_excess = ?                          ; 1/4 RDC excess
ffo_excess = ?                                ; FFO excess
property_damage = ?true                       ; Third-party property

{@pi_coverage}

; ---------------------------------------------------------------------------
; Indemnity Coverages (Cargo)
; ---------------------------------------------------------------------------
{.indemnity}
cargo_damage = ?true                          ; Cargo damage
cargo_proportion = ?true                      ; Cargo proportion in GA
cargo_shortage = ?true                        ; Cargo shortage/missing
container_loss = ?                            ; Container loss
deck_cargo = ?                                ; On-deck cargo
deviation = ?true                             ; Deviation liability
reefer_breakdown = ?                          ; Reefer failure
through_transport = ?                         ; Through B/L liability

{@pi_coverage}

; ---------------------------------------------------------------------------
; Environmental and Pollution
; ---------------------------------------------------------------------------
{.pollution}
bunker_spill = ?true                          ; Bunker oil pollution
cargo_pollution = ?                           ; Cargo pollution
cleanup_costs = ?true                         ; Cleanup expenses
compensation_fund = ?                         ; IOPC Fund coverage
fines_pollution = ?                           ; Pollution fines
gradual_pollution = ?                         ; Gradual pollution
opa_90 = ?                                    ; OPA 90 coverage
pollution_limit = #$:(0..)                    ; Pollution sublimit
sudden_pollution = ?true                      ; Sudden pollution

{@pi_coverage}

; ---------------------------------------------------------------------------
; Wreck Removal
; ---------------------------------------------------------------------------
{.wreck}
cargo_in_wreck = ?                            ; Cargo removal
compulsory_removal = ?true                    ; Compulsory orders
discretionary_removal = ?                     ; Discretionary removal
nairobi_convention = ?                        ; Nairobi WRC compliance
wreck_limit = #$:(0..)                        ; Wreck sublimit
wreck_marking = ?true                         ; Marking/lighting

{@pi_coverage}

; ---------------------------------------------------------------------------
; Fines and Penalties
; ---------------------------------------------------------------------------
{.fines}
customs_fines = ?                             ; Customs violations
environmental_fines = ?                       ; Environmental
immigration_fines = ?                         ; Immigration
loading_discharge = ?                         ; Loading/discharge fines
other_fines = ?                               ; Other fines
safety_fines = ?                              ; Safety violations
smuggling_fines = ?                           ; Drug smuggling

{@pi_coverage}

; ---------------------------------------------------------------------------
; Contractual Liabilities
; ---------------------------------------------------------------------------
{.contractual}
bareboat_charter = ?                          ; Bareboat liability
berth_damage = ?                              ; Berth/dock damage
deviation = ?                                 ; Deviation claims
dock_damage = ?                               ; Dock/wharf damage
general_average = ?true                       ; GA contribution
salvage = ?true                               ; Salvage charges
sue_and_labor = ?true                         ; Sue and labor
time_charter = ?                              ; Time charter liability
towage_contracts = ?                          ; Towage liability
voyage_charter = ?                            ; Voyage charter

{@pi_coverage}

; ---------------------------------------------------------------------------
; Defense and Legal
; ---------------------------------------------------------------------------
{.legal}
correspondent_costs = ?true                   ; P&I correspondents
defense_costs = ?true                         ; Legal defense
legal_costs = ?true                           ; Legal expenses
limitation_fund = ?                           ; Limitation costs
survey_costs = ?true                          ; Survey expenses

{@pi_coverage}

; ===================================================================================
; Additional Covers
; ===================================================================================
; Optional additional coverages.

{@pi_additional_covers}
; Charterers additional
bunker_non_delivery = ?                       ; Bunker shortage
charterers_liability = ?                      ; Charterers extension
damage_to_hull = ?                            ; Damage to entered vessel

; Offshore extensions
offshore_personnel = ?                        ; Offshore workers
subsea_equipment = ?                          ; Subsea equipment

; Special extensions
cyber_liability = ?                           ; Cyber extension
kidnap_ransom = ?                             ; K&R coverage
war_risks = ?                                 ; War P&I

; Limit extensions
excess_collision = ?                          ; Excess collision
excess_pollution = ?                          ; Excess pollution
excess_war = ?                                ; War excess

; ===================================================================================
; Exclusions
; ===================================================================================
; Standard P&I exclusions.

{@pi_exclusions}
; Hull/machinery (covered by H&M)
hull_damage = ?true                           ; Vessel hull damage
machinery = ?true                             ; Machinery damage
loss_of_hire = ?true                          ; Loss of hire
towage_of_entered_ship = ?                    ; Entered ship towage

; Contractual/commercial
cargo_delay = ?true                           ; Cargo delay
demurrage = ?true                             ; Demurrage claims
freight_claims = ?true                        ; Freight disputes
loss_of_market = ?true                        ; Market loss

; Willful acts
intentional_discharge = ?true                 ; Intentional pollution
reckless_acts = ?true                         ; Willful misconduct

; War and terrorism
nuclear = ?true                               ; Nuclear exclusion
terrorism = ?                                 ; Terrorism exclusion
war = ?true                                   ; War exclusion

; Regulatory
sanctions = ?true                             ; Sanctions exclusion
class_requirements = ?                        ; Class conditions

; Other
consequential_loss = ?true                    ; Consequential
punitive_damages = ?                          ; Punitive damages

; ===================================================================================
; Premium/Calls
; ===================================================================================
; P&I club premium structure.

{@pi_premium}
; Required fields first
total_premium = !#$:(0..)                     ; Total premium/calls

; Optional fields
additional_calls = #$:(0..)                   ; Additional calls
advance_call = #$:(0..)                       ; Advance call
annual_premium = #$:(0..)                     ; Fixed premium
currency = :(3) "USD"                         ; Premium currency
deferred_call = #$:(0..)                      ; Deferred portion
minimum_premium = #$:(0..)                    ; Minimum premium
overspill_call = #$:(0..)                     ; Overspill assessment
release_call = #$:(0..)                       ; Release call
supplementary_call = #$:(0..)                 ; Supplementary call
taxes_and_fees = #$:(0..)                     ; Taxes and fees

; ---------------------------------------------------------------------------
; Rating Factors
; ---------------------------------------------------------------------------
{.rating}
claims_experience = #                         ; Experience factor
deductible_credit = #                         ; Deductible credit
flag_factor = #                               ; Flag state factor
tonnage_rate = #                              ; Rate per GT
trade_factor = #                              ; Trade area factor
type_factor = #                               ; Vessel type factor

{@pi_premium}

; ===================================================================================
; P&I Claim
; ===================================================================================
; Claim structure for P&I incidents.

{@pi_claim}
; Required fields first
claim_category = !(
    cargo,                                    ; Cargo claims
    collision,                                ; Collision claims
    contractual,                              ; Contractual liability
    crew,                                     ; Crew claims
    environmental,                            ; Pollution/environmental
    fines,                                    ; Fines and penalties
    passenger,                                ; Passenger claims
    property,                                 ; Property damage
    wreck,                                    ; Wreck removal
    other                                     ; Other claims
)
claim_date = !date                            ; Date of claim
incident_date = !date                         ; Date of incident

; Optional fields
amount_claimed = #$:(0..)                     ; Amount claimed
amount_paid = #$:(0..)                        ; Amount paid
claimant_name = :                             ; Claimant name
claimant_type = (
    cargo_interest,
    charterer,
    crew_member,
    government,
    other,
    passenger,
    port_authority,
    shipyard,
    third_party,
    vessel_owner
)
claim_id = :                                  ; Claim identifier
claim_status = (
    closed,
    denied,
    investigation,
    litigation,
    negotiation,
    open,
    paid,
    reserved,
    subrogation
)
claim_type = :                                ; Specific claim type
correspondent = :                             ; P&I correspondent
currency = :(3) "USD"                         ; Claim currency
deductible_applied = #$:(0..)                 ; Deductible
defense_costs = #$:(0..)                      ; Legal costs
description = :                               ; Claim description
incident_location = :                         ; Location of incident
incident_port = :                             ; Port if applicable
incident_type = (
    allision,                                 ; Contact with fixed object
    cargo_damage,                             ; Cargo damage
    collision,                                ; Vessel collision
    crew_injury,                              ; Crew injury/death
    environmental,                            ; Environmental incident
    grounding,                                ; Grounding
    passenger_incident,                       ; Passenger claim
    pollution,                                ; Pollution event
    salvage,                                  ; Salvage operation
    wreck,                                    ; Wreck situation
    other                                     ; Other incident
)
pool_claim = ?                                ; Pool involvement
recovery = #$:(0..)                           ; Recovery received
reserve = #$:(0..)                            ; Current reserve
subrogation = #$:(0..)                        ; Subrogation recovery
surveyor = :                                  ; Survey reference
third_party_vessel = :                        ; Other vessel if applicable

; ===================================================================================
; P&I Entry (Policy)
; ===================================================================================
; Complete P&I club entry structure.

{@pi_entry}
; Required fields first
coverage = !@pi_coverage                      ; Coverage terms
effective_date = !date                        ; Entry effective date
entry_type = !@pi_entry_type                  ; Type of entry
expiration_date = !date                       ; Entry noon date
policy_year = !##:(2000..2100)                ; Policy year
vessel = !@pi_vessel                          ; Entered vessel

; Invariants
:invariant expiration_date > effective_date

; Optional fields
additional_covers = @pi_additional_covers     ; Additional coverages
administrator = :                             ; Club administrator
broker = :                                    ; Insurance broker
certificate_number = :                        ; Entry certificate
claims[] = @pi_claim                          ; Claims history
club_name = :                                 ; P&I club name
entry_id = :                                  ; Internal identifier
entry_status = (
    active,
    cancelled,
    ceased,
    pending,
    suspended
)
exclusions = @pi_exclusions                   ; Exclusions
id = :                                        ; Internal identifier
loss_record[] = :                             ; Loss record references
member_name = !:                              ; Member name
member_address = @address                     ; Member address
mortgagee = :                                 ; Mortgagee if any
omnibus_rule = ?                              ; Omnibus coverage
premium = @pi_premium                         ; Premium/calls
prior_clubs[] = :                             ; Prior club history
special_conditions[] = :                      ; Special terms
subjectivities[] = :                          ; Outstanding conditions
underwriting = @underwriting_decision         ; Underwriting

; ---------------------------------------------------------------------------
; Blue Card and Certificates
; ---------------------------------------------------------------------------
{.certificates}
athens_certificate = ?                        ; Athens Convention cert
blue_card = :                                 ; Blue card reference
bunker_certificate = ?                        ; Bunker Convention cert
clc_certificate = ?                           ; CLC certificate
nairobi_certificate = ?                       ; WRC certificate
opa_90_cofr = ?                               ; OPA 90 COFR

{@pi_entry}

; ---------------------------------------------------------------------------
; Entry Summary
; ---------------------------------------------------------------------------
{.summary}
coverage_limit = #$:(0..)                     ; Per incident limit
deductible = #$:(0..)                         ; Member deductible
total_premium = #$:(0..)                      ; Total estimated

{@pi_entry}


; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Personal Umbrella/Excess Liability Insurance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Personal umbrella and excess liability insurance providing additional limits
; above underlying auto, homeowners, and watercraft policies with self-insured
; retention and drop-down provisions.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as types
@import "../../common/party.schema.odin" as party
@import "../../common/agency.schema.odin" as agency
@import "../../common/carrier.schema.odin" as carrier
@import "../../common/documents.schema.odin" as docs
@import "../../coverages/lines/umbrella.schema.odin" as umb

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.umbrella"
version = "1.0.0"
title = "Personal Umbrella/Excess Liability Schema"
description = "Personal umbrella insurance bridging auto, homeowners, watercraft, and recreational vehicle policies"

{$derivation}
source[0].authority = "National Association of Insurance Commissioners (NAIC)"
source[0].citation = "Personal Lines Data Calls - Umbrella Liability"
source[0].url = "https://content.naic.org/"

source[1].authority = "State Insurance Departments"
source[1].citation = "Personal Umbrella Filing Requirements"
source[1].url = "https://content.naic.org/state-insurance-departments"

source[2].authority = "Insurance Information Institute (III)"
source[2].citation = "Personal Umbrella Liability Policies"
source[2].url = "https://www.iii.org/article/what-umbrella-liability"

source[3].authority = "American Property Casualty Insurance Association"
source[3].citation = "Personal Liability Coverage Guidelines"
source[3].url = "https://www.apci.org/"

source[4].authority = "California Department of Insurance"
source[4].citation = "Personal Umbrella Policy Standards"
source[4].url = "https://www.insurance.ca.gov/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Personal umbrella schema derived from NAIC data calls and state regulatory requirements"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial personal umbrella insurance schema"
changelog[0].rationale = "Comprehensive personal umbrella bridging all personal lines products"

; ═══════════════════════════════════════════════════════════════════════════════
; INSURED PERSON
; ═══════════════════════════════════════════════════════════════════════════════
; Persons covered under the umbrella policy including named insured, spouse,
; resident relatives, and household members.

{@umbrella_insured_person}
= @person                                           ; Inherits person fields (name, dob, contact)

; Required fields first
relationship = (child, dependent, domestic_partner, grandchild, insured, other, other_relative, parent, sibling, spouse)

; Override required name fields
{.name}
first = :                                          ; First name (required)
last = :                                           ; Last name (required)

{@umbrella_insured_person}

; Umbrella-specific fields
resident = ?                                        ; Resides in named insured's household
student_away = ?                                    ; Full-time student away at school

; Driver status (for auto underlying)
licensed_driver = ?                                 ; Has valid driver's license
drivers_license_number = *:                         ; Driver license number
drivers_license_state = :(2)                        ; License state/province
youthful_driver = ?                                 ; Under age 25
driver_excluded = ?                                 ; Excluded from auto coverage

; Identification
id = :                                              ; Unique insured person identifier
sequence = ##:(1..)                                 ; Sequence number

; ═══════════════════════════════════════════════════════════════════════════════
; UNDERLYING AUTO POLICY
; ═══════════════════════════════════════════════════════════════════════════════
; Auto liability underlying policy requirements. Most umbrella policies require
; specific minimum liability limits on all auto policies.

{@umbrella_underlying_auto}
; Required fields first
carrier_name = :                                   ; Auto insurance carrier name
policy_number = :                                  ; Auto policy number

; Term
effective_date = date                              ; Auto policy effective date
expiration_date = date                             ; Auto policy expiration date

:invariant expiration_date > effective_date

; Liability limits (split limit structure)
{.liability_limits}
; Per person/per accident/property damage structure (e.g., 250/500/100)
bodily_injury_per_person = #$:(0..)                ; BI limit per person
bodily_injury_per_accident = #$:(0..)              ; BI limit per accident
property_damage = #$:(0..)                         ; PD limit per accident

{@umbrella_underlying_auto}

; Combined single limit alternative
combined_single_limit = #$:(0..)                    ; CSL if not split limits

; Uninsured/Underinsured motorist
{.um_uim}
uninsured_motorist = ?                              ; UM coverage in force
uninsured_bodily_injury_per_person = #$:(0..)       ; UM BI per person
uninsured_bodily_injury_per_accident = #$:(0..)     ; UM BI per accident
underinsured_motorist = ?                           ; UIM coverage in force
underinsured_bodily_injury_per_person = #$:(0..)    ; UIM BI per person
underinsured_bodily_injury_per_accident = #$:(0..)  ; UIM BI per accident

{@umbrella_underlying_auto}

; Vehicles covered
vehicle_count = ##:(0..)                            ; Number of vehicles on policy
vehicle_types[] = (antique_classic, commercial_use, leased, motorcycle, owned, recreational)

; Status
status = (active, cancelled, expired, pending)     ; Policy status
meets_minimum = ?                                   ; Meets umbrella minimum requirements
minimum_gap = #$:(0..)                              ; Gap below required minimum

; Identification
id = :                                              ; Unique underlying auto identifier
sequence = ##:(1..)                                 ; Sequence number

; ═══════════════════════════════════════════════════════════════════════════════
; UNDERLYING HOMEOWNERS POLICY
; ═══════════════════════════════════════════════════════════════════════════════
; Homeowners/renters liability underlying policy requirements.

{@umbrella_underlying_homeowners}
; Required fields first
carrier_name = :                                   ; Homeowners carrier name
policy_form = (HO1, HO2, HO3, HO4, HO5, HO6, HO7, HO8)  ; Policy form
policy_number = :                                  ; Homeowners policy number

; Term
effective_date = date                              ; Policy effective date
expiration_date = date                             ; Policy expiration date

:invariant expiration_date > effective_date

; Property address
{.property_address}
line1 = :                                           ; Street address
city = :                                            ; City
state_province = :(2)                               ; State/province
postal_code = :                                     ; ZIP/postal code

{@umbrella_underlying_homeowners}

; Liability limits (Coverage E and F)
{.liability_limits}
personal_liability = #$:(0..)                      ; Coverage E - Personal Liability
medical_payments = #$:(0..)                         ; Coverage F - Medical Payments to Others

{@umbrella_underlying_homeowners}

; Property type
occupancy = (owner_occupied, rental_to_others, seasonal, secondary, tenant, vacant)
property_type = (condo, manufactured_home, mobile_home, multi_family, single_family, townhouse)

; Special exposures
business_on_premises = ?                            ; Business conducted on premises
daycare_on_premises = ?                             ; Daycare operated on premises
farming_ranching = ?                                ; Farming/ranching operations
swimming_pool = ?                                   ; Swimming pool on premises
trampoline = ?                                      ; Trampoline on premises

; Animals
dogs = ##:(0..)                                     ; Number of dogs
dog_breeds[] = :                                    ; Dog breed names
exotic_animals = ?                                  ; Exotic or dangerous animals
horses = ##:(0..)                                   ; Number of horses

; Status
status = (active, cancelled, expired, pending)     ; Policy status
meets_minimum = ?                                   ; Meets umbrella minimum requirements
minimum_gap = #$:(0..)                              ; Gap below required minimum

; Identification
id = :                                              ; Unique underlying homeowners identifier
sequence = ##:(1..)                                 ; Sequence number

; ═══════════════════════════════════════════════════════════════════════════════
; UNDERLYING WATERCRAFT POLICY
; ═══════════════════════════════════════════════════════════════════════════════
; Watercraft liability underlying policy requirements.

{@umbrella_underlying_watercraft}
; Required fields first
carrier_name = :                                   ; Watercraft carrier name
policy_number = :                                  ; Watercraft policy number

; Term
effective_date = date                              ; Policy effective date
expiration_date = date                             ; Policy expiration date

:invariant expiration_date > effective_date

; Liability limits
{.liability_limits}
bodily_injury_per_person = #$:(0..)                 ; BI per person
bodily_injury_per_occurrence = #$:(0..)             ; BI per occurrence
combined_single_limit = #$:(0..)                    ; CSL if applicable
property_damage = #$:(0..)                          ; PD per occurrence

{@umbrella_underlying_watercraft}

; Vessel details
{.vessel}
hin = :                                             ; Hull Identification Number
length_feet = ##:(0..)                              ; Length in feet
horsepower = ##:(0..)                               ; Engine horsepower
manufacturer = :                                    ; Vessel manufacturer
model = :                                           ; Vessel model
vessel_name = :                                     ; Vessel name
vessel_type = (bass_boat, cabin_cruiser, jet_ski, pontoon, pwc, runabout, sailboat, ski_boat, yacht)
year = ##:(1900..2100)                              ; Model year

{@umbrella_underlying_watercraft}

; Status
status = (active, cancelled, expired, pending)     ; Policy status
meets_minimum = ?                                   ; Meets umbrella minimum requirements
minimum_gap = #$:(0..)                              ; Gap below required minimum

; Identification
id = :                                              ; Unique underlying watercraft identifier
sequence = ##:(1..)                                 ; Sequence number

; ═══════════════════════════════════════════════════════════════════════════════
; UNDERLYING RECREATIONAL VEHICLE POLICY
; ═══════════════════════════════════════════════════════════════════════════════
; Recreational vehicle (RV, ATV, snowmobile, golf cart) underlying requirements.

{@umbrella_underlying_rv}
; Required fields first
carrier_name = :                                   ; RV carrier name
policy_number = :                                  ; RV policy number
rv_type = (atv, dirt_bike, golf_cart, motorhome, motorcycle, snowmobile, travel_trailer, utv)

; Term
effective_date = date                              ; Policy effective date
expiration_date = date                             ; Policy expiration date

:invariant expiration_date > effective_date

; Liability limits
{.liability_limits}
bodily_injury_per_person = #$:(0..)                 ; BI per person
bodily_injury_per_occurrence = #$:(0..)             ; BI per occurrence
combined_single_limit = #$:(0..)                    ; CSL if applicable
property_damage = #$:(0..)                          ; PD per occurrence

{@umbrella_underlying_rv}

; Vehicle details
{.vehicle}
make = :                                            ; Vehicle make
model = :                                           ; Vehicle model
vin = *:(17)                                        ; VIN if applicable
year = ##:(1900..2100)                              ; Model year

{@umbrella_underlying_rv}

; Status
status = (active, cancelled, expired, pending)     ; Policy status
meets_minimum = ?                                   ; Meets umbrella minimum requirements
minimum_gap = #$:(0..)                              ; Gap below required minimum

; Identification
id = :                                              ; Unique underlying RV identifier
sequence = ##:(1..)                                 ; Sequence number

; ═══════════════════════════════════════════════════════════════════════════════
; UNDERLYING POLICY SCHEDULE (COMPLETE)
; ═══════════════════════════════════════════════════════════════════════════════
; Complete underlying policy verification combining all policy types.

{@umbrella_underlying}
; All underlying policies
auto_policies[] = @umbrella_underlying_auto         ; Auto policies
homeowners_policies[] = @umbrella_underlying_homeowners  ; Homeowners/renters policies
rv_policies[] = @umbrella_underlying_rv             ; Recreational vehicle policies
watercraft_policies[] = @umbrella_underlying_watercraft  ; Watercraft policies

; Required minimum limits (carrier requirements)
{.required_minimums}
; Auto minimums (typical 250/500/100 or $300K CSL)
auto_bi_per_person = #$:(0..)                       ; Required auto BI per person
auto_bi_per_accident = #$:(0..)                     ; Required auto BI per accident
auto_combined_single_limit = #$:(0..)               ; Required auto CSL alternative
auto_property_damage = #$:(0..)                     ; Required auto PD

; Homeowners minimums (typical $300K-$500K)
homeowners_personal_liability = #$:(0..)            ; Required Coverage E minimum

; Watercraft minimums
watercraft_liability = #$:(0..)                     ; Required watercraft liability

; RV minimums
rv_liability = #$:(0..)                             ; Required RV liability

{@umbrella_underlying}

; Verification status
all_minimums_met = ?                                ; All underlying policies meet minimums
verification_date = date                            ; Date underlying was verified
verified_by = :                                     ; Person/system that verified

; Gap coverage needed
gaps_exist = ?                                      ; Gaps in underlying coverage exist
gap_coverage_applies = ?                            ; Umbrella drops down for gaps

; ═══════════════════════════════════════════════════════════════════════════════
; EXPOSURE FACTORS
; ═══════════════════════════════════════════════════════════════════════════════
; Exposure units used for umbrella rating. Premium is based on number of
; exposures (autos, properties, watercraft, etc.) and risk characteristics.

{@umbrella_exposure}
; Vehicle exposures
{.autos}
total_count = ##:(0..)                              ; Total auto count
antique_classic_count = ##:(0..)                    ; Antique/classic vehicles
commercial_use_count = ##:(0..)                     ; Vehicles used for business
high_performance_count = ##:(0..)                   ; High-performance vehicles
leased_count = ##:(0..)                             ; Leased vehicles
motorcycle_count = ##:(0..)                         ; Motorcycles
owned_count = ##:(0..)                              ; Owned vehicles

{@umbrella_exposure}

; Property exposures
{.properties}
total_count = ##:(0..)                              ; Total property count
primary_residence_count = ##:(1..)                  ; Primary residences (usually 1)
rental_property_count = ##:(0..)                    ; Properties rented to others
seasonal_count = ##:(0..)                           ; Seasonal/vacation properties
secondary_residence_count = ##:(0..)                ; Secondary residences
vacant_land_count = ##:(0..)                        ; Vacant land parcels

{@umbrella_exposure}

; Watercraft exposures
{.watercraft}
total_count = ##:(0..)                              ; Total watercraft count
high_performance_count = ##:(0..)                   ; High-speed boats
large_yacht_count = ##:(0..)                        ; Yachts over 26 feet
pwc_count = ##:(0..)                                ; Personal watercraft (jet skis)
sailboat_count = ##:(0..)                           ; Sailboats
small_boat_count = ##:(0..)                         ; Small boats under 26 feet

{@umbrella_exposure}

; Recreational vehicle exposures
{.recreational_vehicles}
total_count = ##:(0..)                              ; Total RV count
atv_count = ##:(0..)                                ; ATVs
golf_cart_count = ##:(0..)                          ; Golf carts
motorhome_count = ##:(0..)                          ; Motorhomes
snowmobile_count = ##:(0..)                         ; Snowmobiles

{@umbrella_exposure}

; Driver exposures
{.drivers}
total_count = ##:(0..)                              ; Total household drivers
excluded_count = ##:(0..)                           ; Excluded drivers
inexperienced_count = ##:(0..)                      ; Drivers with < 3 years experience
senior_count = ##:(0..)                             ; Drivers over 70
youthful_count = ##:(0..)                           ; Drivers under 25

{@umbrella_exposure}

; Driver violations (within 3-5 years)
{.violations}
accidents_at_fault = ##:(0..)                       ; At-fault accidents
accidents_not_at_fault = ##:(0..)                   ; Not-at-fault accidents
dui_dwi = ##:(0..)                                  ; DUI/DWI convictions
license_suspensions = ##:(0..)                      ; License suspensions
major_violations = ##:(0..)                         ; Major moving violations
minor_violations = ##:(0..)                         ; Minor moving violations
reckless_driving = ##:(0..)                         ; Reckless driving convictions

{@umbrella_exposure}

; Special exposures
{.special}
; Animals
dangerous_dog_breeds = ##:(0..)                     ; Dogs on restricted breed list
dogs_total = ##:(0..)                               ; Total dogs
exotic_animals = ##:(0..)                           ; Exotic/wild animals
horses = ##:(0..)                                   ; Horses

; Property features
diving_boards = ##:(0..)                            ; Diving boards
swimming_pools = ##:(0..)                           ; Swimming pools
trampolines = ##:(0..)                              ; Trampolines

; Activities
firearms_collection = ?                             ; Firearms collection
hunting = ?                                         ; Regular hunting activities

{@umbrella_exposure}

; ═══════════════════════════════════════════════════════════════════════════════
; EXCLUSIONS
; ═══════════════════════════════════════════════════════════════════════════════
; Standard personal umbrella exclusions. These are common exclusions across
; most personal umbrella policies.

{@umbrella_exclusions}
; Business/Professional (most common exclusions)
business_pursuits = ?true                           ; Business activities excluded
professional_liability = ?true                      ; Professional services excluded
business_property = ?                               ; Business property excluded
employment_practices = ?                            ; Employment practices excluded
home_business = ?                                   ; Home-based business excluded

; Vehicles/Conveyances
aircraft = ?true                                    ; Aircraft excluded
aircraft_exception_passenger = ?                    ; Exception for aircraft passenger
watercraft_over_limit = ?                           ; Watercraft over HP/length excluded
watercraft_horsepower_limit = ##:(0..)              ; HP limit for watercraft exclusion
watercraft_length_limit = ##:(0..)                  ; Length limit for watercraft exclusion

; Intentional/Criminal
communicable_disease = ?                            ; Communicable disease excluded
criminal_acts = ?true                               ; Criminal acts excluded
intentional_acts = ?true                            ; Intentional injury excluded
sexual_misconduct = ?                               ; Sexual misconduct excluded

; Property/Contract
care_custody_control = ?                            ; Property in care excluded
contractual_liability = ?                           ; Contractual liability excluded
damage_to_property = ?                              ; Damage to own property excluded

; Statutory/Regulatory
nuclear = ?true                                     ; Nuclear hazard excluded
pollution = ?                                       ; Pollution excluded
war = ?true                                         ; War excluded
workers_compensation = ?true                        ; Workers compensation excluded

; Other common exclusions
board_membership = ?                                ; Board/director liability excluded
cyber_liability = ?                                 ; Cyber/data breach excluded
punitive_damages = ?                                ; Punitive damages excluded
racing = ?                                          ; Racing activities excluded
rental_property_business = ?                        ; Rental property as business excluded

; ═══════════════════════════════════════════════════════════════════════════════
; COVERAGE
; ═══════════════════════════════════════════════════════════════════════════════
; Personal umbrella coverage structure including limits, self-insured retention,
; drop-down coverage, and UM/UIM options.

{@umbrella_coverage}
; Coverage type
coverage_type = (excess_follow_form, excess_specific, true_umbrella)

; ───────────────────────────────────────────────────────────────────────────────
; Limits
; ───────────────────────────────────────────────────────────────────────────────
; Occurrence limit (typically $1M-$10M in $1M increments)
each_occurrence = #$:(0..)                         ; Per occurrence limit
aggregate = #$:(0..)                                ; Annual aggregate (if applicable)
aggregate_applies = ?                               ; Aggregate limit applies

; Standard limit tiers
limit_tier = (tier_1m, tier_2m, tier_3m, tier_4m, tier_5m, tier_6m, tier_7m, tier_8m, tier_9m, tier_10m, tier_over_10m)

; ───────────────────────────────────────────────────────────────────────────────
; Self-Insured Retention (SIR)
; ───────────────────────────────────────────────────────────────────────────────
{.sir}
amount = #$:(0..)                                   ; SIR amount (typically $0-$10,000)
applies_to = (all_claims, drop_down_only, gaps_only, non_underlying)
includes_defense = ?                                ; Defense costs within SIR

{@umbrella_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Drop-Down Coverage (True Umbrella)
; ───────────────────────────────────────────────────────────────────────────────
; Drop-down applies when underlying is exhausted or has coverage gap
{.drop_down}
available = ?:if coverage_type = true_umbrella      ; Drop-down feature available
for_coverage_gaps = ?:if available = true           ; Drops for gaps in underlying
for_exhausted_underlying = ?:if available = true    ; Drops when underlying exhausted
for_excluded_exposure = ?:if available = true       ; Drops for underlying exclusions
for_insurer_insolvency = ?:if available = true      ; Drops if underlying carrier insolvent

{@umbrella_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Defense Costs
; ───────────────────────────────────────────────────────────────────────────────
{.defense}
duty_to_defend = ?                                  ; Umbrella has duty to defend
outside_limits = ?                                  ; Defense outside (in addition to) limits
supplementary_payments = ?                          ; Supplementary payments included
within_limits = ?                                   ; Defense inside (erodes) limits

{@umbrella_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Uninsured/Underinsured Motorist (UM/UIM) Umbrella
; ───────────────────────────────────────────────────────────────────────────────
{.um_uim}
uninsured_motorist = ?                              ; UM coverage included
uninsured_limit = #$:(0..):if uninsured_motorist = true
underinsured_motorist = ?                           ; UIM coverage included
underinsured_limit = #$:(0..):if underinsured_motorist = true
stacking_allowed = ?                                ; Stacking of UM/UIM limits allowed

{@umbrella_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Territory
; ───────────────────────────────────────────────────────────────────────────────
territory = (us_canada_only, us_possessions, worldwide)
excluded_countries[] = :                            ; Specific country exclusions
suit_jurisdiction = (any, us_canada_only)           ; Where suits must be brought

; ───────────────────────────────────────────────────────────────────────────────
; Follow Form (Excess Policies)
; ───────────────────────────────────────────────────────────────────────────────
{.follow_form}
follows_auto = ?:if coverage_type = excess_follow_form
follows_homeowners = ?:if coverage_type = excess_follow_form
follows_rv = ?:if coverage_type = excess_follow_form
follows_watercraft = ?:if coverage_type = excess_follow_form
broader_than_underlying = ?:if coverage_type = excess_follow_form

{@umbrella_coverage}

; Coverage identifier
coverage_id = :                                     ; Unique coverage identifier

; ═══════════════════════════════════════════════════════════════════════════════
; RATING
; ═══════════════════════════════════════════════════════════════════════════════
; Premium rating factors for personal umbrella policies.

{@umbrella_rating}
; Base premium factors
{.base}
limit_factor = #:(0..)                              ; Factor for limit selected
territory_factor = #:(0..)                          ; Geographic territory factor
tier_base_premium = #$:(0..)                        ; Base premium for limit tier

{@umbrella_rating}

; Exposure charges
{.exposure_charges}
auto_charge = #$:(0..)                              ; Charge per auto
homeowners_charge = #$:(0..)                        ; Charge per residence
motorcycle_charge = #$:(0..)                        ; Charge per motorcycle
rental_property_charge = #$:(0..)                   ; Charge per rental property
rv_charge = #$:(0..)                                ; Charge per recreational vehicle
watercraft_charge = #$:(0..)                        ; Charge per watercraft
youthful_driver_charge = #$:(0..)                   ; Charge per youthful driver

{@umbrella_rating}

; Surcharges
{.surcharges}
diving_board_surcharge = #$:(0..)                   ; Diving board surcharge
dog_surcharge = #$:(0..)                            ; Dog surcharge (breed-based)
dui_surcharge = #$:(0..)                            ; DUI/DWI surcharge
major_violation_surcharge = #$:(0..)                ; Major violation surcharge
pool_surcharge = #$:(0..)                           ; Swimming pool surcharge
trampoline_surcharge = #$:(0..)                     ; Trampoline surcharge
violation_surcharge = #$:(0..)                      ; Moving violation surcharge

{@umbrella_rating}

; Credits/Discounts
{.discounts}
advance_quote_discount = #$:(0..)                   ; Advance quote discount
autopay_discount = #$:(0..)                         ; Auto-pay discount
claims_free_discount = #$:(0..)                     ; Claims-free discount
defensive_driver_discount = #$:(0..)                ; Defensive driver course discount
loyalty_discount = #$:(0..)                         ; Long-term customer discount
multi_policy_discount = #$:(0..)                    ; Multi-policy bundle discount
paid_in_full_discount = #$:(0..)                    ; Paid-in-full discount
paperless_discount = #$:(0..)                       ; Paperless billing discount
total_discounts = #$:(0..)                          ; Sum of all discounts

{@umbrella_rating}

; Premium calculation
{.premium}
base_premium = #$:(0..)                             ; Base premium
exposure_premium = #$:(0..)                         ; Exposure-based charges
fees = #$:(0..)                                     ; Policy fees
minimum_premium = #$:(0..)                          ; Minimum premium
subtotal = #$:(0..)                                 ; Subtotal before discounts
surcharges_total = #$:(0..)                         ; Total surcharges
taxes = #$:(0..)                                    ; Taxes
total_premium = #$:(0..)                            ; Final total premium
um_uim_premium = #$:(0..)                           ; UM/UIM premium if elected

{@umbrella_rating}

; ═══════════════════════════════════════════════════════════════════════════════
; CLAIM
; ═══════════════════════════════════════════════════════════════════════════════
; Umbrella claim structure tracking the claim from underlying through excess.

{@umbrella_claim}
; Required fields first
claim_number = :                                   ; Unique claim number
date_of_loss = date                                ; Date loss occurred
date_reported = timestamp                          ; Date claim reported

; Status (workflow order)
status = (
    reported,
    coverage_review,
    monitoring,
    investigation,
    excess_triggered,
    defense_engaged,
    negotiation,
    settlement,
    litigation,
    closed_no_payment,
    closed_paid,
    subrogation,
    reopened
)

; Loss description
{.loss}
description = :                                     ; Description of loss
location = :                                        ; Loss location
loss_type = (auto_liability, personal_liability, professional_liability, watercraft_liability)

{@umbrella_claim}

; Underlying claim information
{.underlying_claim}
underlying_carrier = :                              ; Underlying carrier name
underlying_claim_number = :                         ; Underlying claim number
underlying_policy_number = :                        ; Underlying policy number
underlying_policy_type = (auto, homeowners, rv, watercraft)
underlying_limits_exhausted = ?                     ; Underlying limits exhausted
underlying_limits_available = #$:(0..)              ; Remaining underlying limits
underlying_paid = #$:(0..)                          ; Amount paid by underlying

{@umbrella_claim}

; Umbrella involvement
{.umbrella_involvement}
drop_down_triggered = ?                             ; Drop-down coverage triggered
excess_triggered = ?                                ; Excess coverage triggered
sir_applies = ?                                     ; SIR applies to this claim
sir_satisfied = ?                                   ; SIR has been satisfied
trigger_date = date                                 ; Date umbrella was triggered

{@umbrella_claim}

; Reserves
{.reserves}
defense_reserve = #$:(0..)                          ; Defense cost reserve
indemnity_reserve = #$:(0..)                        ; Indemnity reserve
total_reserve = #$:(0..)                            ; Total incurred reserve

{@umbrella_claim}

; Payments
{.payments}
defense_paid = #$:(0..)                             ; Defense costs paid
indemnity_paid = #$:(0..)                           ; Indemnity paid
sir_paid = #$:(0..)                                 ; SIR paid by insured
total_paid = #$:(0..)                               ; Total paid by umbrella

{@umbrella_claim}

; Claimant information
{.claimant}
name = :                                            ; Claimant name
represented = ?                                     ; Claimant has attorney
attorney_name = ::if represented = true             ; Attorney name
demand_amount = #$:(0..)                            ; Claimant demand

{@umbrella_claim}

; Litigation
{.litigation}
suit_filed = ?                                      ; Lawsuit filed
suit_date = date:if suit_filed = true               ; Date suit filed
venue = ::if suit_filed = true                      ; Court venue
case_number = ::if suit_filed = true                ; Court case number
defense_counsel = :                                 ; Defense attorney/firm
trial_date = date                                   ; Scheduled trial date

{@umbrella_claim}

; Adjuster
{.adjuster}
name = :                                            ; Assigned adjuster
phone = @phone                                      ; Adjuster phone

{@umbrella_claim}

; Dates
date_closed = date                                  ; Date claim closed
date_reopened = date                                ; Date claim reopened

; Identification
id = :                                              ; Unique claim identifier

; ═══════════════════════════════════════════════════════════════════════════════
; ENDORSEMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Personal umbrella policy endorsements and modifications.

{@umbrella_endorsement}
; Required fields first
effective_date = date                              ; Endorsement effective date
endorsement_number = :                             ; Endorsement form number
endorsement_type = (
    additional_insured,
    coverage_extension,
    coverage_restriction,
    exclusion_addition,
    exclusion_removal,
    exposure_change,
    limit_change,
    other,
    premium_adjustment,
    sir_modification,
    territory_extension,
    um_uim_election,
    underlying_change
)

; Description
description = :                                     ; Endorsement description
title = :                                           ; Endorsement title

; Premium impact
premium_change = #$                                 ; Change in premium (can be negative)
new_premium = #$:(0..)                              ; New premium after endorsement

; Coverage changes
{.changes}
; Limit changes
new_each_occurrence = #$:(0..)                      ; New occurrence limit
new_aggregate = #$:(0..)                            ; New aggregate limit
new_um_limit = #$:(0..)                             ; New UM limit
new_uim_limit = #$:(0..)                            ; New UIM limit

; SIR changes
new_sir_amount = #$:(0..)                           ; New SIR amount

; Exposure changes
autos_added = ##                                    ; Autos added
autos_removed = ##                                  ; Autos removed
properties_added = ##                               ; Properties added
properties_removed = ##                             ; Properties removed
watercraft_added = ##                               ; Watercraft added
watercraft_removed = ##                             ; Watercraft removed

{@umbrella_endorsement}

; Processing
processed_by = :                                    ; Agent/user who processed
processed_date = timestamp                          ; Date processed

; Identification
id = :                                              ; Unique endorsement identifier
sequence = ##:(1..)                                 ; Endorsement sequence number

; ═══════════════════════════════════════════════════════════════════════════════
; POLICY
; ═══════════════════════════════════════════════════════════════════════════════
; Complete personal umbrella policy composition.

{@umbrella_policy}
; ───────────────────────────────────────────────────────────────────────────────
; Identification (Required)
; ───────────────────────────────────────────────────────────────────────────────
number = :                                         ; Policy number
state_province = :(2)                              ; Primary state/province
status = (active, application, bound, cancelled, expired, non_renewed, pending, quote, reinstated)

; ───────────────────────────────────────────────────────────────────────────────
; Term (Required)
; ───────────────────────────────────────────────────────────────────────────────
{.term}
effective = date                                   ; Policy effective date
expiration = date                                  ; Policy expiration date
effective_time = time                               ; Effective time if not midnight
expiration_time = time                              ; Expiration time if not midnight
months = ##:(1..36)                                 ; Term length in months
type = (annual, monthly, semi_annual)               ; Term type

:invariant term.expiration > term.effective

{@umbrella_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Identification (Optional)
; ───────────────────────────────────────────────────────────────────────────────
application_number = :                              ; Application reference
id = :                                              ; Internal system identifier
quote_number = :                                    ; Original quote reference

; ───────────────────────────────────────────────────────────────────────────────
; Classification
; ───────────────────────────────────────────────────────────────────────────────
line_of_business = "personal_umbrella"              ; Line of business constant
product_type = (preferred, standard)                ; Product tier

; ───────────────────────────────────────────────────────────────────────────────
; Version Control
; ───────────────────────────────────────────────────────────────────────────────
endorsement_count = ##                              ; Number of endorsements
prior_version = ##                                  ; Previous version number
version = ##:(1..)                                  ; Current version number
version_date = timestamp                            ; Version timestamp
version_reason = :                                  ; Reason for version change

; ───────────────────────────────────────────────────────────────────────────────
; Status Details
; ───────────────────────────────────────────────────────────────────────────────
cancellation_date = date                            ; Cancellation effective date
cancellation_reason = (carrier_non_renewal, insured_request, non_payment, underlying_lapse, underwriting)
original_effective = date                           ; Original effective date for continuous coverage
status_date = date                                  ; Date status changed
status_reason = :                                   ; Reason for status change

; ───────────────────────────────────────────────────────────────────────────────
; Timestamps
; ───────────────────────────────────────────────────────────────────────────────
bound_date = date                                   ; Date policy bound
cancelled_date = date                               ; Date policy cancelled
created = timestamp                                ; Record creation timestamp
created_by = :                                      ; User who created record
expired_date = date                                 ; Date policy expired
issued_date = date                                  ; Date policy issued
modified = timestamp                                ; Last modification timestamp
modified_by = :                                     ; User who last modified
quote_date = date                                   ; Date quote generated

; ═══════════════════════════════════════════════════════════════════════════════
; NAMED INSURED (Primary)
; ═══════════════════════════════════════════════════════════════════════════════

{@umbrella_policy.named_insured}
= @party.named_insured

{@umbrella_policy.secondary_insured}
= @party.named_insured

; ═══════════════════════════════════════════════════════════════════════════════
; INSURED PERSONS (Household Members)
; ═══════════════════════════════════════════════════════════════════════════════

{@umbrella_policy.insured_persons[]}
= @umbrella_insured_person

; ═══════════════════════════════════════════════════════════════════════════════
; CARRIER & PROGRAM
; ═══════════════════════════════════════════════════════════════════════════════

{@umbrella_policy.carrier}
= @carrier.carrier

{@umbrella_policy.program}
= @carrier.program

; ═══════════════════════════════════════════════════════════════════════════════
; AGENCY
; ═══════════════════════════════════════════════════════════════════════════════

{@umbrella_policy.agency}
= @agency.agency

{@umbrella_policy.producer}
= @agency.producer

; ═══════════════════════════════════════════════════════════════════════════════
; UNDERLYING POLICIES
; ═══════════════════════════════════════════════════════════════════════════════

{@umbrella_policy.underlying}
= @umbrella_underlying

; ═══════════════════════════════════════════════════════════════════════════════
; COVERAGE
; ═══════════════════════════════════════════════════════════════════════════════

{@umbrella_policy.coverage}
= @umbrella_coverage

; ═══════════════════════════════════════════════════════════════════════════════
; EXCLUSIONS
; ═══════════════════════════════════════════════════════════════════════════════

{@umbrella_policy.exclusions}
= @umbrella_exclusions

; ═══════════════════════════════════════════════════════════════════════════════
; EXPOSURES
; ═══════════════════════════════════════════════════════════════════════════════

{@umbrella_policy.exposure}
= @umbrella_exposure

; ═══════════════════════════════════════════════════════════════════════════════
; RATING
; ═══════════════════════════════════════════════════════════════════════════════

{@umbrella_policy.rating}
= @umbrella_rating

; ═══════════════════════════════════════════════════════════════════════════════
; CLAIMS
; ═══════════════════════════════════════════════════════════════════════════════

{@umbrella_policy.claims[]}
= @umbrella_claim

; ═══════════════════════════════════════════════════════════════════════════════
; ENDORSEMENTS
; ═══════════════════════════════════════════════════════════════════════════════

{@umbrella_policy.endorsements[]}
= @umbrella_endorsement

; ═══════════════════════════════════════════════════════════════════════════════
; PAYMENT PLAN
; ═══════════════════════════════════════════════════════════════════════════════

{@umbrella_policy.payment_plan}
plan_type = (annual, monthly, pay_in_full, quarterly, semi_annual)
auto_pay = ?                                        ; Auto-pay enrolled
down_payment = #$:(0..)                             ; Down payment amount
installment_amount = #$:(0..)                       ; Installment amount
installment_fee = #$:(0..)                          ; Per-installment fee
installments = ##:(0..12)                           ; Number of installments

{@umbrella_policy.payment_plan.scheduled_payments[]}
amount_due = #$:(0..)                               ; Amount due
amount_paid = #$:(0..)                              ; Amount paid
due_date = date                                     ; Due date
payment_date = date                                 ; Payment date
payment_method = (ach, cash, check, credit_card, debit_card)
sequence = ##:(1..)                                 ; Payment sequence
status = (cancelled, paid, past_due, pending, refunded)

; ═══════════════════════════════════════════════════════════════════════════════
; LOSS HISTORY
; ═══════════════════════════════════════════════════════════════════════════════

{@umbrella_policy.loss_history[]}
clue_claim_id = :                                   ; CLUE claim identifier
date_of_loss = date                                 ; Date of loss
description = :                                     ; Loss description
loss_amount = #$:(0..)                              ; Total loss amount
loss_type = (auto_liability, premises_liability, watercraft_liability)
status = (closed, open)                             ; Claim status
underlying_carrier = :                              ; Carrier that paid
umbrella_paid = #$:(0..)                            ; Amount paid by umbrella

; ═══════════════════════════════════════════════════════════════════════════════
; DOCUMENTS
; ═══════════════════════════════════════════════════════════════════════════════

{@umbrella_policy.documents[]}
= @docs.document

; ═══════════════════════════════════════════════════════════════════════════════
; NOTES
; ═══════════════════════════════════════════════════════════════════════════════

{@umbrella_policy.notes[]}
= @types.policy_note

; ═══════════════════════════════════════════════════════════════════════════════
; UNDERWRITING
; ═══════════════════════════════════════════════════════════════════════════════

{@umbrella_policy.underwriting}
= @types.underwriting_decision

; ═══════════════════════════════════════════════════════════════════════════════
; MARKETING & SOURCE
; ═══════════════════════════════════════════════════════════════════════════════

{@umbrella_policy.marketing}
= @types.marketing_source

; ═══════════════════════════════════════════════════════════════════════════════
; EXTERNAL REFERENCES
; ═══════════════════════════════════════════════════════════════════════════════

{@umbrella_policy.external_references[]}
= @types.external_reference

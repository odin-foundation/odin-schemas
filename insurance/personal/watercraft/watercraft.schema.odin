; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Watercraft Insurance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Watercraft insurance for boats, personal watercraft, sailboats, and yachts
; covering hull physical damage, watercraft liability, medical payments,
; uninsured boater, towing, and fuel spill liability.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as types
@import "../../common/party.schema.odin" as party
@import "../../common/agency.schema.odin" as agency
@import "../../common/carrier.schema.odin" as carrier
@import "../../common/documents.schema.odin" as docs

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.watercraft"
version = "1.0.0"
title = "Watercraft Insurance Schema"
description = "Personal watercraft insurance coverage for boats, yachts, PWC, and recreational vessels"

{$derivation}
source[0].authority = "U.S. Coast Guard"
source[0].citation = "33 CFR Part 67 - Documentation of Vessels"
source[0].url = "https://www.ecfr.gov/current/title-33/chapter-I/subchapter-C/part-67"

source[1].authority = "U.S. Coast Guard"
source[1].citation = "33 CFR 181.25 - Hull Identification Number (HIN) Requirements"
source[1].url = "https://www.ecfr.gov/current/title-33/chapter-I/subchapter-S/part-181"

source[2].authority = "U.S. Coast Guard"
source[2].citation = "46 CFR Part 67 - Documentation of Vessels"
source[2].url = "https://www.ecfr.gov/current/title-46/chapter-I/subchapter-G/part-67"

source[3].authority = "National Association of State Boating Law Administrators (NASBLA)"
source[3].citation = "Vessel Sub-Types Classification System"
source[3].url = "https://www.nasbla.org"

source[4].authority = "U.S. Census Bureau"
source[4].citation = "NAICS 713930 - Marinas, 441222 - Boat Dealers"
source[4].url = "https://www.census.gov/naics/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Watercraft insurance based on USCG vessel documentation, HIN requirements, and standard marine insurance practices"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial comprehensive watercraft insurance schema"
changelog[0].rationale = "Complete personal watercraft coverage representation with USCG compliance"

; ═══════════════════════════════════════════════════════════════════════════════
; Watercraft (Vessel)
; ═══════════════════════════════════════════════════════════════════════════════

{@watercraft}
id = :                                            ; Unique watercraft identifier
sequence = ##:(1..)                               ; Watercraft sequence number

; ───────────────────────────────────────────────────────────────────────────────
; Vessel Identification
; ───────────────────────────────────────────────────────────────────────────────
hin = :/^[A-Z0-9]{12}$/                           ; Hull Identification Number (12-character)
hin_verified = ?                                  ; HIN verification status

registration_number = :                           ; State or provincial registration number
registration_state = :(2)                         ; US state or Canadian province
registration_expiration = date                    ; Registration expiration date

uscg_documented = ?                               ; USCG documented vessel flag
uscg_documentation_number = ::if uscg_documented = true ; USCG official documentation number
uscg_hailing_port = ::if uscg_documented = true   ; USCG registered hailing port
uscg_endorsement = (coastwise, fishery, recreation, registry):if uscg_documented = true ; USCG documentation endorsement type

; Vessel Names
vessel_name = :                                   ; Official vessel name
vessel_nickname = :                               ; Informal vessel nickname

; ───────────────────────────────────────────────────────────────────────────────
; Vessel Classification
; ───────────────────────────────────────────────────────────────────────────────
vessel_type = (airboat, bass_boat, bowrider, cabin_cruiser, canoe, catamaran, center_console, cruiser, cuddy_cabin, deck_boat, dinghy, express_cruiser, fishing_boat, houseboat, inflatable, jet_boat, kayak, motor_yacht, performance_boat, personal_watercraft, pontoon, rigid_inflatable, rowboat, runabout, sailboat, ski_boat, sport_fishing, trawler, trimaran, wakeboard_boat, yacht) ; Type of watercraft/vessel

vessel_class = (class_1, class_2, class_3, class_4, class_a) ; USCG vessel class by length

; ───────────────────────────────────────────────────────────────────────────────
; Specifications
; ───────────────────────────────────────────────────────────────────────────────
{.specifications}
year_manufactured = ##:(1900..2100)               ; Year vessel was manufactured
manufacturer = :                                  ; Manufacturer/builder name
make = :                                          ; Make/brand name
model = :                                         ; Model name/number
model_year = ##:(1900..2100)                      ; Model year designation
length_feet = ##:(1..)                            ; Overall length in feet
beam_width_feet = ##:(1..)                        ; Maximum beam (width) in feet
draft_feet = ##:(0..50)                           ; Draft depth in feet
net_tonnage = ##:(0..100000)                      ; Net tonnage rating
gross_tonnage = ##:(0..100000)                    ; Gross tonnage rating
weight_pounds = ##:(0..)                          ; Total weight in pounds
capacity_persons = ##:(1..)                       ; Maximum person capacity
capacity_weight_pounds = ##:(0..50000)            ; Maximum weight capacity in pounds

{@watercraft}

; ───────────────────────────────────────────────────────────────────────────────
; Hull Construction
; ───────────────────────────────────────────────────────────────────────────────
{.hull}
type = (
    catamaran,
    deep_v,
    displacement,
    flat_bottom,
    modified_v,
    multi_hull,
    planing,
    pontoon,
    round_bottom,
    semi_displacement,
    trimaran,
    tunnel
)                                                 ; Hull design/configuration type

material = (
    aluminum,
    carbon_fiber,
    composite,
    ferro_cement,
    fiberglass,
    hypalon,
    pvc,
    steel,
    wood
)                                                 ; Hull construction material

color = :                                         ; Primary vessel color
color_hull = :                                    ; Hull color
color_trim = :                                    ; Trim color

{@watercraft}

; ───────────────────────────────────────────────────────────────────────────────
; Propulsion
; ───────────────────────────────────────────────────────────────────────────────
{.propulsion}
type = (electric, human_powered, hybrid, inboard, inboard_outboard, jet, outboard, paddle, sail, sail_auxiliary) ; Propulsion system type

; Engine details (for motorized vessels)
engines = ##:(0..8)                               ; Number of engines
engine_manufacturer = :                           ; Engine manufacturer name
engine_model = :                                  ; Engine model designation
engine_year = ##:(1900..2100)                     ; Engine year of manufacture
engine_serial_number = :                          ; Engine serial number
total_horsepower = ##:(0..10000)                  ; Total horsepower across all engines
fuel_type = (diesel, electric, gasoline, hybrid, other) ; Fuel type
fuel_capacity_gallons = ##:(0..10000)             ; Fuel tank capacity in gallons

{@watercraft}

; ───────────────────────────────────────────────────────────────────────────────
; Sail Configuration (for sailboats)
; ───────────────────────────────────────────────────────────────────────────────
{.sail}
rig_type = (
    catboat,
    cutter,
    gaff_rig,
    ketch,
    schooner,
    sloop,
    yawl
):if propulsion.type = sail                       ; Sail rig configuration type

rig_type = (
    catboat,
    cutter,
    gaff_rig,
    ketch,
    schooner,
    sloop,
    yawl
):if propulsion.type = sail_auxiliary             ; Sail rig configuration type for auxiliary vessels

sail_area_sqft = ##:if propulsion.type = sail     ; Total sail area in square feet
sail_area_sqft = ##:if propulsion.type = sail_auxiliary ; Total sail area in square feet for auxiliary vessels
mast_count = ##:(1..):if propulsion.type = sail   ; Number of masts
mast_count = ##:(1..):if propulsion.type = sail_auxiliary ; Number of masts for auxiliary vessels

{@watercraft}

; ───────────────────────────────────────────────────────────────────────────────
; Ownership
; ───────────────────────────────────────────────────────────────────────────────
{.ownership}
type = (
    chartered,
    corporate,
    fractional,
    leased,
    owned,
    partnership,
    rental_fleet,
    shared,
    trust
)                                                 ; Ownership type/structure

purchase_date = date                              ; Date of purchase/acquisition
purchase_price = #$:(0..)                         ; Purchase price paid
purchase_type = (cash, financed, gifted, inherited, lease) ; Method of purchase

{@watercraft}

; ───────────────────────────────────────────────────────────────────────────────
; Lienholders
; ───────────────────────────────────────────────────────────────────────────────
{@watercraft.lienholders[]}
id = :                                       ; Lienholder ID
sequence = ##:(1..)                          ; Sequence number
name = !:                                    ; Lienholder name
address = @address                           ; Lienholder address
account_number = *:                          ; Account number
loan_amount = #$:(0..)                       ; Loan amount


{@watercraft}

; ───────────────────────────────────────────────────────────────────────────────
; Valuation
; ───────────────────────────────────────────────────────────────────────────────
{.valuation}
agreed_value = #$:(0..)                           ; Agreed upon value for coverage
actual_cash_value = #$:(0..)                      ; Actual cash value (depreciated)
stated_amount = #$:(0..)                          ; Stated value amount
market_value = #$:(0..)                           ; Current market value
replacement_cost = #$:(0..)                       ; Cost to replace with new vessel

{@watercraft}

; ───────────────────────────────────────────────────────────────────────────────
; Use and Operations
; ───────────────────────────────────────────────────────────────────────────────
{.use}
primary_use = (
    charter,
    commercial,
    cruising,
    fishing,
    personal_pleasure,
    racing,
    rental,
    sport_fishing,
    towsports,
    water_sports
)                                                 ; Primary use/purpose of vessel

annual_days_used = ##:(0..365)                    ; Annual days vessel is used
average_passengers = ##:(0..500)                  ; Average number of passengers
tow_water_skiers = ?                              ; Used for towing water skiers
tow_wakeboarders = ?                              ; Used for towing wakeboarders
tow_tubers = ?                                    ; Used for towing tubes
racing = ?                                        ; Used for racing activities
commercial_use = ?                                ; Used for commercial purposes
rental_use = ?                                    ; Used as rental vessel
charter_use = ?                                   ; Used for charter operations
fishing_tournaments = ?                           ; Used in fishing tournaments

{@watercraft}

; ───────────────────────────────────────────────────────────────────────────────
; Mooring and Storage
; ───────────────────────────────────────────────────────────────────────────────
{.mooring}
primary_location_type = (
    beach,
    boat_lift,
    davits,
    dock_slip,
    dry_stack,
    floating_dock,
    garage,
    marina_covered,
    marina_open,
    mooring_buoy,
    on_trailer,
    other
)                                                 ; Primary storage/mooring location type

address = @address                           ; Mooring location address
marina_name = :                              ; Marina name
slip_number = :                              ; Slip number

{@watercraft}

; ───────────────────────────────────────────────────────────────────────────────
; Navigation Limits
; ───────────────────────────────────────────────────────────────────────────────
{.navigation}
territory = (
    canada_east_coast,
    canada_great_lakes,
    canada_west_coast,
    coastal,                                      ; Within 200 miles of coast
    great_lakes,
    international,
    inland_waters,
    territorial_waters,                           ; Within 12 nautical miles
    us_east_coast,
    us_gulf_coast,
    us_west_coast,
    worldwide
)                                                 ; Approved navigation territory

excluded_waters[] = :                             ; Specific excluded water bodies
cruising_radius_miles = ##:(0..50000)             ; Maximum cruising radius in miles
offshore_capable = ?                              ; Vessel rated for offshore use
max_distance_from_shore_miles = ##:(0..50000)     ; Maximum allowed distance from shore

{@watercraft}

; ───────────────────────────────────────────────────────────────────────────────
; Seasonal Layup
; ───────────────────────────────────────────────────────────────────────────────
{.seasonal}
layup_applicable = ?                              ; Seasonal layup applies
layup_start_month = ##:(1..12):if layup_applicable = true ; Month layup period begins
layup_end_month = ##:(1..12):if layup_applicable = true ; Month layup period ends
winter_storage_type = (dry_stack, garage, heated_indoor, indoor, outdoor_covered, shrink_wrap):if layup_applicable = true ; Winter storage method

{@watercraft}

; ───────────────────────────────────────────────────────────────────────────────
; Equipment and Electronics
; ───────────────────────────────────────────────────────────────────────────────
{.equipment}
gps = ?                                           ; GPS navigation system installed
depth_finder = ?                                  ; Depth finder installed
fish_finder = ?                                   ; Fish finder installed
radar = ?                                         ; Radar system installed
vhf_radio = ?                                     ; VHF radio installed
autopilot = ?                                     ; Autopilot system installed
chart_plotter = ?                                 ; Chart plotter installed
ais = ?                                           ; Automatic Identification System
epirb = ?                                         ; Emergency Position Indicating Radio Beacon

{.safety_equipment}
life_jackets = ##                                 ; Number of life jackets onboard
fire_extinguishers = ##                           ; Number of fire extinguishers onboard
flares = ?                                        ; Flares available onboard
anchor = ?                                        ; Anchor available
bilge_pump = ?                                    ; Bilge pump installed
raft_dinghy = ?                                   ; Emergency raft or dinghy available

{@watercraft}

; ───────────────────────────────────────────────────────────────────────────────
; Trailer
; ───────────────────────────────────────────────────────────────────────────────
{.trailer}
included = ?                                      ; Trailer included with watercraft
year = ##:(1900..2100):if included = true         ; Trailer year of manufacture
manufacturer = ::if included = true               ; Trailer manufacturer
model = ::if included = true                      ; Trailer model
vin = *:/^[A-HJ-NPR-Z0-9]{17}$/:if included = true ; Trailer VIN (17 characters)
axles = ##:(1..):if included = true               ; Number of axles
capacity_pounds = ##:(0..100000):if included = true ; Trailer weight capacity in pounds
value = #$:(0..):if included = true               ; Trailer value
registration_number = ::if included = true        ; Trailer registration number
registration_state = :(2):if included = true      ; Trailer registration state

{@watercraft}

; ═══════════════════════════════════════════════════════════════════════════════
; Operator (Named Operator/Driver)
; ═══════════════════════════════════════════════════════════════════════════════

{@operator}
id = :                                            ; Operator identifier
sequence = ##:(1..)                               ; Operator sequence number

; ───────────────────────────────────────────────────────────────────────────────
; Identity
; ───────────────────────────────────────────────────────────────────────────────
{.name}
first = !:                                        ; First name
middle = :                                        ; Middle name
last = !:                                         ; Last name

{@operator}

date_of_birth = *date                             ; Date of birth (confidential)
relationship_to_insured = (child, employee, friend, insured, other, other_family, spouse) ; Relationship to named insured

; ───────────────────────────────────────────────────────────────────────────────
; Boating License/Certificate
; ───────────────────────────────────────────────────────────────────────────────
{.license}
boating_safety_certificate = ?                    ; Boating safety certificate held
certificate_number = ::if boating_safety_certificate = true ; Certificate number
certificate_state = :(2):if boating_safety_certificate = true ; State that issued certificate
certificate_expiration = date:if boating_safety_certificate = true ; Certificate expiration date
uscg_captain_license = ?                          ; USCG captain's license held
captain_license_number = *:if uscg_captain_license = true ; Captain's license number (confidential)
captain_license_expiration = date:if uscg_captain_license = true ; Captain's license expiration date


{@operator}

; ───────────────────────────────────────────────────────────────────────────────
; Experience
; ───────────────────────────────────────────────────────────────────────────────
{.experience}
years_operating = ##:(0..100)                     ; Total years operating watercraft
similar_vessel_experience_years = ##:(0..100)     ; Years operating similar vessel type
pwc_experience_years = ##:(0..100)                ; Years operating personal watercraft
sailboat_experience_years = ##:(0..100)           ; Years operating sailboats
boating_education = ?                             ; Formal boating education completed
racing_experience = ?                             ; Racing experience

{@operator}

; ───────────────────────────────────────────────────────────────────────────────
; History
; ───────────────────────────────────────────────────────────────────────────────
{.history}
accidents = ##                                    ; Number of boating accidents
violations = ##                                   ; Number of boating violations
dui_bui = ?                                       ; Boating Under Influence
insurance_cancelled = ?                           ; Prior insurance cancelled
claims_history = ?                                ; Has claims history

{@operator}

; ═══════════════════════════════════════════════════════════════════════════════
; Hull Coverage (Physical Damage)
; ═══════════════════════════════════════════════════════════════════════════════

{@hull_coverage}
id = :                                            ; Hull coverage identifier
watercraft_ref = :                                ; Reference to @watercraft.id

coverage_type = (actual_cash_value, agreed_value, stated_amount) ; Type of hull coverage valuation
insured_value = #$:(0..)                          ; Insured hull value amount

; ───────────────────────────────────────────────────────────────────────────────
; Perils Covered
; ───────────────────────────────────────────────────────────────────────────────
{.perils}
form = (all_risk, named_perils, total_loss_only)  ; Coverage form type

; Named perils (if applicable)
collision = ?:if form = named_perils              ; Collision coverage included
sinking = ?:if form = named_perils                ; Sinking coverage included
fire = ?:if form = named_perils                   ; Fire coverage included
theft = ?:if form = named_perils                  ; Theft coverage included
vandalism = ?:if form = named_perils              ; Vandalism coverage included
lightning = ?:if form = named_perils              ; Lightning coverage included
windstorm = ?:if form = named_perils              ; Windstorm coverage included
hail = ?:if form = named_perils                   ; Hail coverage included

{@hull_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Deductibles
; ───────────────────────────────────────────────────────────────────────────────
{.deductible}
amount = #$:(0..)                                 ; Deductible dollar amount
percentage = ##:(0..100)                          ; Deductible percentage
type = (dollar_amount, percentage, percentage_minimum) ; Deductible type
hurricane_deductible = #$:(0..)                   ; Hurricane-specific deductible
named_storm_deductible = #$:(0..)                 ; Named storm deductible

{@hull_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Additional Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.additional}
salvage = ?                                       ; Salvage coverage included
wreck_removal = ?                                 ; Wreck removal coverage included
wreck_removal_limit = #$:(0..):if wreck_removal = true ; Wreck removal limit amount
total_loss_replacement = ?                        ; New boat replacement
total_loss_replacement_months = ##:(0..60):if total_loss_replacement = true ; Months for replacement eligibility
diminution_of_value = ?                           ; Diminution of value coverage

{@hull_coverage}

premium = #$:(0..)                                ; Hull coverage premium amount

; ═══════════════════════════════════════════════════════════════════════════════
; Liability Coverage (Protection & Indemnity)
; ═══════════════════════════════════════════════════════════════════════════════

{@liability_coverage}
id = :                                            ; Liability coverage identifier
watercraft_ref = :                                ; Reference to @watercraft.id

; ───────────────────────────────────────────────────────────────────────────────
; Liability Limits Structure
; ───────────────────────────────────────────────────────────────────────────────
limit_structure = (combined_single_limit, split_limits) ; Liability limit structure type

; Combined Single Limit
csl_limit = #$:(0..):if limit_structure = combined_single_limit ; Combined single limit amount

; Split Limits
{.split_limits}
bodily_injury_per_person = #$:(0..):if limit_structure = split_limits ; Bodily injury limit per person
bodily_injury_per_occurrence = #$:(0..):if limit_structure = split_limits ; Bodily injury limit per occurrence
property_damage_per_occurrence = #$:(0..):if limit_structure = split_limits ; Property damage limit per occurrence

{@liability_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Extensions
; ───────────────────────────────────────────────────────────────────────────────
{.extensions}
jones_act = ?                                     ; Crew coverage (for yachts with crew)
longshoremen_harbor_workers = ?                   ; Longshoremen and Harbor Workers coverage
oil_pollution_act = ?                             ; Oil Pollution Act coverage
protection_indemnity = ?                          ; Protection and indemnity coverage

{@liability_coverage}

premium = #$:(0..)                                ; Liability coverage premium amount

; ═══════════════════════════════════════════════════════════════════════════════
; Medical Payments Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@medical_payments_coverage}
id = :                                            ; Medical payments coverage identifier
watercraft_ref = :                                ; Reference to @watercraft.id

included = ?                                      ; Medical payments coverage included
per_person_limit = #$:(0..):if included = true    ; Limit per person
per_occurrence_limit = #$:(0..):if included = true ; Limit per occurrence
covers_insured = ?:if included = true             ; Coverage applies to insured
covers_passengers = ?:if included = true          ; Coverage applies to passengers
premium = #$:(0..):if included = true             ; Medical payments premium amount

; ═══════════════════════════════════════════════════════════════════════════════
; Uninsured/Underinsured Boater Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@uninsured_boater_coverage}
id = :                                            ; Uninsured boater coverage identifier
watercraft_ref = :                                ; Reference to @watercraft.id

uninsured_included = ?                            ; Uninsured boater coverage included
underinsured_included = ?                         ; Underinsured boater coverage included

; Limits
bodily_injury_per_person = #$:(0..)               ; Bodily injury limit per person
bodily_injury_per_occurrence = #$:(0..)           ; Bodily injury limit per occurrence
property_damage_per_occurrence = #$:(0..)         ; Property damage limit per occurrence

premium = #$:(0..)                                ; Uninsured boater premium amount

; ═══════════════════════════════════════════════════════════════════════════════
; Additional Coverages
; ═══════════════════════════════════════════════════════════════════════════════

{@additional_coverages}
id = :                                            ; Additional coverages identifier
watercraft_ref = :                                ; Reference to @watercraft.id

; ───────────────────────────────────────────────────────────────────────────────
; Fuel Spill Liability
; ───────────────────────────────────────────────────────────────────────────────
{.fuel_spill}
included = ?                                      ; Fuel spill liability included
limit = #$:(0..):if included = true               ; Fuel spill liability limit

{@additional_coverages}

; ───────────────────────────────────────────────────────────────────────────────
; Towing and Assistance
; ───────────────────────────────────────────────────────────────────────────────
{.towing}
included = ?                                      ; Towing and assistance included
limit = #$:(0..):if included = true               ; Towing and assistance limit
on_water = ?:if included = true                   ; On-water towing covered
on_land = ?:if included = true                    ; On-land towing covered

{@additional_coverages}

; ───────────────────────────────────────────────────────────────────────────────
; Personal Effects
; ───────────────────────────────────────────────────────────────────────────────
{.personal_effects}
included = ?                                      ; Personal effects coverage included
limit = #$:(0..):if included = true               ; Personal effects limit
deductible = #$:(0..):if included = true          ; Personal effects deductible

{@additional_coverages}

; ───────────────────────────────────────────────────────────────────────────────
; Fishing Equipment
; ───────────────────────────────────────────────────────────────────────────────
{.fishing_equipment}
included = ?                                      ; Fishing equipment coverage included
limit = #$:(0..):if included = true               ; Fishing equipment limit
deductible = #$:(0..):if included = true          ; Fishing equipment deductible

{@additional_coverages}

; ───────────────────────────────────────────────────────────────────────────────
; Trailer Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.trailer}
included = ?                                      ; Trailer coverage included
actual_cash_value = #$:(0..):if included = true   ; Trailer actual cash value
agreed_value = #$:(0..):if included = true        ; Trailer agreed value
deductible = #$:(0..):if included = true          ; Trailer coverage deductible

{@additional_coverages}

; ───────────────────────────────────────────────────────────────────────────────
; Emergency Services
; ───────────────────────────────────────────────────────────────────────────────
{.emergency_services}
included = ?                                      ; Emergency services coverage included
salvage = ?:if included = true                    ; Salvage services covered
emergency_towing = ?:if included = true           ; Emergency towing covered
soft_ungrounding = ?:if included = true           ; Soft ungrounding covered
fuel_delivery = ?:if included = true              ; Fuel delivery covered
battery_jump = ?:if included = true               ; Battery jump start covered

{@additional_coverages}

; ───────────────────────────────────────────────────────────────────────────────
; Navigational Territory Extension
; ───────────────────────────────────────────────────────────────────────────────
{.navigation_extension}
included = ?                                      ; Navigation territory extension included
extended_territory = ::if included = true         ; Extended navigation territory

{@additional_coverages}

premium_total = #$:(0..)                          ; Total additional coverages premium

; ═══════════════════════════════════════════════════════════════════════════════
; Watercraft Policy
; ═══════════════════════════════════════════════════════════════════════════════

{@watercraft_policy}
id = :                                            ; Policy identifier
number = !:                                       ; Policy number
quote_number = :                                  ; Quote number

; ───────────────────────────────────────────────────────────────────────────────
; Line of Business
; ───────────────────────────────────────────────────────────────────────────────
line_of_business = "watercraft"                   ; Line of business designation
product_type = (non_standard, preferred, standard) ; Product type classification
type = (
    comprehensive,
    hull_only,
    liability_only,
    pwc,
    specialty_yacht
)                                                 ; Policy type

; ───────────────────────────────────────────────────────────────────────────────
; Term
; ───────────────────────────────────────────────────────────────────────────────
{.term}
effective_date = !date                            ; Policy effective date
effective_time = time                             ; Policy effective time
expiration_date = !date                           ; Policy expiration date
expiration_time = time                            ; Policy expiration time
months = ##:(1..)                                 ; Policy term length in months
type = (annual, monthly, seasonal, semi_annual)   ; Policy term type
:invariant term.expiration_date > term.effective_date ; Expiration must be after effective date

{@watercraft_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = !(
    active,
    application,
    bound,
    cancelled,
    expired,
    non_renewed,
    pending_payment,
    pending_underwriting,
    quote,
    reinstated
)                                                 ; Policy status
status_date = date                                ; Date of status change
status_reason = :                                 ; Reason for status

; ───────────────────────────────────────────────────────────────────────────────
; Jurisdiction
; ───────────────────────────────────────────────────────────────────────────────
state_province = !:(2)                            ; State or province code
territory = :                                     ; Insurance territory code

; ───────────────────────────────────────────────────────────────────────────────
; Version Control
; ───────────────────────────────────────────────────────────────────────────────
version = ##:(1..)                                ; Policy version number
version_date = timestamp                          ; Version date and time
version_reason = :                                ; Reason for version change
prior_version = ##:(0..)                          ; Prior version number
endorsement_count = ##:(0..)                      ; Number of endorsements

; ───────────────────────────────────────────────────────────────────────────────
; Timestamps
; ───────────────────────────────────────────────────────────────────────────────
created = !timestamp                              ; Policy creation timestamp
created_by = :                                    ; User who created policy
modified = timestamp                              ; Last modification timestamp
modified_by = :                                   ; User who last modified policy
quote_date = date                                 ; Quote date
bound_date = date                                 ; Bound date
issued_date = date                                ; Issued date
cancelled_date = date                             ; Cancellation date
expired_date = date                               ; Expiration date

; ═══════════════════════════════════════════════════════════════════════════════
; NAMED INSURED
; ═══════════════════════════════════════════════════════════════════════════════

{@watercraft_policy.named_insured}
= @party.named_insured

{@watercraft_policy.secondary_insured}
= @party.named_insured

; ═══════════════════════════════════════════════════════════════════════════════
; CARRIER & PROGRAM
; ═══════════════════════════════════════════════════════════════════════════════

{@watercraft_policy.carrier}
= @carrier.carrier

{@watercraft_policy.program}
= @carrier.program

; ═══════════════════════════════════════════════════════════════════════════════
; AGENCY
; ═══════════════════════════════════════════════════════════════════════════════

{@watercraft_policy.agency}
= @agency.agency

{@watercraft_policy.producer}
= @agency.producer

; ═══════════════════════════════════════════════════════════════════════════════
; WATERCRAFT (VESSELS)
; ═══════════════════════════════════════════════════════════════════════════════

{@watercraft_policy.watercraft[]}
= @watercraft

; ═══════════════════════════════════════════════════════════════════════════════
; OPERATORS
; ═══════════════════════════════════════════════════════════════════════════════

{@watercraft_policy.operators[]}
= @operator

; ═══════════════════════════════════════════════════════════════════════════════
; EXCLUDED OPERATORS
; ═══════════════════════════════════════════════════════════════════════════════

{@watercraft_policy.excluded_operators[]}
id = :                                            ; Excluded operator identifier
sequence = ##:(1..)                               ; Excluded operator sequence number
name_first = :                                    ; First name
name_middle = :                                   ; Middle name
name_last = :                                     ; Last name
date_of_birth = *date                             ; Date of birth (confidential)
reason = :                                        ; Reason for exclusion
date_excluded = date                              ; Date of exclusion

; ═══════════════════════════════════════════════════════════════════════════════
; COVERAGES (per watercraft - linked via watercraft_ref)
; ═══════════════════════════════════════════════════════════════════════════════

{@watercraft_policy.hull_coverages[]}
= @hull_coverage

{@watercraft_policy.liability_coverages[]}
= @liability_coverage

{@watercraft_policy.medical_payments_coverages[]}
= @medical_payments_coverage

{@watercraft_policy.uninsured_boater_coverages[]}
= @uninsured_boater_coverage

{@watercraft_policy.additional_coverages[]}
= @additional_coverages

; ═══════════════════════════════════════════════════════════════════════════════
; PREMIUM
; ═══════════════════════════════════════════════════════════════════════════════

{@watercraft_policy.premium}
hull_premium = #$:(0..)                           ; Hull coverage premium
liability_premium = #$:(0..)                      ; Liability coverage premium
medical_payments_premium = #$:(0..)               ; Medical payments premium
uninsured_boater_premium = #$:(0..)               ; Uninsured boater premium
additional_coverages_premium = #$:(0..)           ; Additional coverages premium

; Discounts
{.discounts}
multi_policy = #$:(0..)                           ; Multi-policy discount
safety_equipment = #$:(0..)                       ; Safety equipment discount
boating_safety_course = #$:(0..)                  ; Boating safety course discount
claims_free = #$:(0..)                            ; Claims-free discount
experienced_operator = #$:(0..)                   ; Experienced operator discount
marina_storage = #$:(0..)                         ; Marina storage discount
total_discount = #$:(0..)                         ; Total discount amount

{@watercraft_policy.premium}

; Charges
{.charges}
policy_fee = #$:(0..)                             ; Policy fee
inspection_fee = #$:(0..)                         ; Inspection fee
other_fees = #$:(0..)                             ; Other fees
total_charges = #$:(0..)                          ; Total charges

{@watercraft_policy.premium}

; Totals
base_premium = #$:(0..)                           ; Base premium before discounts
subtotal = #$:(0..)                               ; Subtotal after discounts
taxes = #$:(0..)                                  ; Taxes
total_premium = #$:(0..)                          ; Total premium including taxes

; ═══════════════════════════════════════════════════════════════════════════════
; PAYMENT PLAN
; ═══════════════════════════════════════════════════════════════════════════════

{@watercraft_policy.payment_plan}
plan_type = (annual, monthly, pay_in_full, seasonal, semi_annual) ; Payment plan type
down_payment = #$:(0..)                           ; Down payment amount
installments = ##:(0..12)                         ; Number of installments
installment_amount = #$:(0..)                     ; Amount per installment
installment_fee = #$:(0..)                        ; Fee per installment
auto_pay = ?                                      ; Auto-pay enabled

{@watercraft_policy.payment_plan.scheduled_payments[]}
sequence = ##:(1..)                               ; Payment sequence number
due_date = date                                   ; Payment due date
amount_due = #$:(0..)                             ; Amount due
amount_paid = #$:(0..)                            ; Amount paid
payment_date = date                               ; Date payment was made
payment_method = (ach, cash, check, credit_card, debit_card) ; Payment method
status = (cancelled, paid, past_due, pending)     ; Payment status

; ═══════════════════════════════════════════════════════════════════════════════
; DOCUMENTS
; ═══════════════════════════════════════════════════════════════════════════════

{@watercraft_policy.documents[]}
= @docs.document

; ═══════════════════════════════════════════════════════════════════════════════
; NOTES
; ═══════════════════════════════════════════════════════════════════════════════

{@watercraft_policy.notes[]}
= @types.policy_note

; ═══════════════════════════════════════════════════════════════════════════════
; UNDERWRITING
; ═══════════════════════════════════════════════════════════════════════════════

{@watercraft_policy.underwriting}
= @types.underwriting_decision

; ═══════════════════════════════════════════════════════════════════════════════
; MARKETING & SOURCE
; ═══════════════════════════════════════════════════════════════════════════════

{@watercraft_policy.marketing}
= @types.marketing_source

; ═══════════════════════════════════════════════════════════════════════════════
; ADDITIONAL INTERESTS
; ═══════════════════════════════════════════════════════════════════════════════

{@watercraft_policy.additional_interests[]}
= @party.additional_insured

; ═══════════════════════════════════════════════════════════════════════════════
; LOSS HISTORY
; ═══════════════════════════════════════════════════════════════════════════════

{@watercraft_policy.loss_history[]}
loss_date = date                                  ; Date of loss
watercraft_hin = :                                ; Watercraft HIN involved in loss
location = :                                      ; Location of loss
type_of_loss = (
    collision,
    fire,
    grounding,
    lightning,
    sinking,
    storm_damage,
    theft,
    vandalism,
    weather
)                                                 ; Type of loss
hull_paid = #$:(0..)                              ; Hull damage amount paid
liability_paid = #$:(0..)                         ; Liability amount paid
medical_paid = #$:(0..)                           ; Medical payments amount paid
total_paid = #$:(0..)                             ; Total amount paid
status = (closed, open)                           ; Loss claim status
description = :                                   ; Loss description

; ═══════════════════════════════════════════════════════════════════════════════
; EXTERNAL REFERENCES
; ═══════════════════════════════════════════════════════════════════════════════

{@watercraft_policy.external_references[]}
= @types.external_reference

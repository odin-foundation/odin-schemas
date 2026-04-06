; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Mobile/Manufactured Home Insurance Schema (HO-7)
; ═══════════════════════════════════════════════════════════════════════════════
; Mobile and manufactured home insurance (HO-7) covering the structure, personal
; property, liability, additional living expenses, trip collision during
; transport, and tie-down/anchoring systems.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../residential-types.schema.odin" as res
@import "../../coverages/coverage.schema.odin" as cov
@import "../../coverages/lines/homeowners.schema.odin" as ho
@import "../../common/types.schema.odin" as types
@import "../../common/party.schema.odin" as party

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.mobile-home"
version = "1.0.0"
title = "Mobile/Manufactured Home Insurance Schema (HO-7)"
description = "Comprehensive HO-7 policy schema for manufactured and mobile homes"

{$derivation}
source[0].authority = "U.S. Department of Housing and Urban Development (HUD)"
source[0].citation = "Manufactured Home Construction and Safety Standards (24 CFR Part 3280)"
source[0].url = "https://www.ecfr.gov/current/title-24/subtitle-B/chapter-XX/part-3280"

source[1].authority = "HUD Office of Manufactured Housing Programs"
source[1].citation = "HUD Code for Manufactured Homes"
source[1].url = "https://www.hud.gov/hud-partners/manufactured-home"

source[2].authority = "National Association of Insurance Commissioners (NAIC)"
source[2].citation = "Homeowners Insurance Industry Data Call"
source[2].url = "https://content.naic.org/insurance-topics/homeowners-insurance"

source[3].authority = "Texas Department of Insurance"
source[3].citation = "Home Insurance Guide - Mobile Homes"
source[3].url = "https://tdi.texas.gov/pubs/consumer/cb025.html"

source[4].authority = "Institute for Building Technology and Safety (IBTS)"
source[4].citation = "Manufactured Home Label Verification"
source[4].url = "https://www.ibts.org"

source[5].authority = "InterNACHI"
source[5].citation = "Tie-Downs for Manufactured Homes"
source[5].url = "https://www.nachi.org/manufactured-home-tie-downs.htm"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Based on HUD manufactured housing standards, federal tie-down requirements, and state insurance regulations"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial mobile/manufactured home insurance schema"
changelog[0].rationale = "HO-7 coverage for manufactured housing with HUD Code compliance tracking"

; ═══════════════════════════════════════════════════════════════════════════════
; Mobile Home Classification
; ═══════════════════════════════════════════════════════════════════════════════

{@mobile_home_classification}
; Classification determines regulatory requirements and coverage eligibility
home_classification = !(
    manufactured_home,                              ; Built after June 15, 1976 (HUD Code)
    mobile_home,                                    ; Built before June 15, 1976
    modular_home                                    ; Site-built to local codes, transported in sections
)

; Relationship to HUD Code (federal manufactured housing standards)
hud_code_compliant = ?                          ; Whether home meets HUD Code standards (post-1976)
hud_certification_date = date:if hud_code_compliant = true ; Date of HUD certification

; Size classification
size_type = !(
    double_wide,                                    ; Two sections joined, typically 20+ feet wide
    single_wide,                                    ; Single section, typically 14-18 feet wide
    triple_wide                                     ; Three sections joined
)

section_count = !##:(1..5)                          ; Number of sections joined together

; ═══════════════════════════════════════════════════════════════════════════════
; Manufactured Home Identification
; ═══════════════════════════════════════════════════════════════════════════════

{@manufactured_home_identification}
; HUD Label/Certification (required for post-1976 manufactured homes)
{.hud_label}
hud_label = ?                                   ; Whether HUD certification label is present
label_number = ::if hud_label = true      ; HUD certification label number
seal_number = ::if hud_label = true       ; Alternative: HUD seal number
label_verification_letter = ?:if hud_label = false ; IBTS letter if label missing

{@manufactured_home_identification}

; Serial Number / VIN (Housing Identification Number - HIN)
{.serial_number}
hin = !:                                      ; Stamped on foremost cross member
section_identifier = (A, B, C):if section_count > 1 ; A/B for double, A/B/C for triple
hin_location = (data_plate, frame_cross_member, tow_bar) ; Where HIN is stamped/located

{@manufactured_home_identification}

; Manufacturer Information
manufacturer_name = !:                              ; Name of manufacturing company
manufacturer_code = :(3)                            ; First 3 digits of HIN
brand_name = :                                      ; Brand/trade name if different from manufacturer
model_name = :                                      ; Model name designation
model_number = :                                    ; Model number designation
year_manufactured = !##:(1950..)                    ; Year the home was manufactured
state_manufactured = :(2)                           ; US state code from HIN

; Data Plate Location (inside home)
{.data_plate}
data_plate = ?                                      ; Whether data plate is present and accessible
data_plate_location = (bedroom_closet, electrical_panel, kitchen_cabinet):if data_plate = true ; Where data plate is located inside home

; ═══════════════════════════════════════════════════════════════════════════════
; Mobile Home Physical Characteristics
; ═══════════════════════════════════════════════════════════════════════════════

{@manufactured_home}
home_id = :                                         ; Unique identifier for this manufactured home
location_ref = :                                    ; Reference to @mobile_home_location

; Classification and identification
classification = @mobile_home_classification        ; Mobile home type and classification
identification = @manufactured_home_identification  ; Serial numbers and manufacturer details

; ───────────────────────────────────────────────────────────────────────────────
; Dimensions and Size
; ───────────────────────────────────────────────────────────────────────────────
{.dimensions}
total_length_feet = !##:(20..100)                   ; Total length of home in feet
total_width_feet = !##:(8..40)                      ; Total width of home in feet
total_square_feet = !##:(320..)                     ; HUD minimum 320 sq ft
living_square_feet = ##:(0..)                       ; Heated/finished living space in square feet
bedroom_count = ##:(0..10)                          ; Number of bedrooms
bathroom_count = #:(0..10)                          ; Number of bathrooms (can be fractional)
room_count = ##:(0..)                               ; Total number of rooms

{@manufactured_home}

; ───────────────────────────────────────────────────────────────────────────────
; Construction Details
; ───────────────────────────────────────────────────────────────────────────────
{.construction}
; Mobile home specific exterior materials
exterior_material = !(aluminum_siding, fiber_cement, hardboard, metal, steel, stucco, vinyl_siding, wood_siding) ; Primary exterior siding material
siding_condition = (excellent, fair, good, poor)    ; Condition of exterior siding

{@manufactured_home}

{.roof}
= @res.res_roof

; Mobile home specific roof details
roof_over = ?                                       ; Roof installed over existing roof

{@manufactured_home}

; Skirting (encloses undercarriage)
{.skirting}
skirted = ?                                         ; Whether home has skirting installed
skirting_type = (aluminum, brick, concrete_block, fiberglass, rock, vinyl):if skirted = true ; Type of skirting material
skirting_condition = (excellent, fair, good, poor):if skirted = true ; Condition of skirting

{@manufactured_home}

; Frame and chassis
{.frame}
permanent_chassis = !?                              ; Required for manufactured homes
frame_material = (galvanized_steel, steel)          ; Material of main frame structure
tongue_hitch_attached = ?                           ; Indicates mobility capability
axles_removed = ?                                   ; Whether axles have been removed
wheels_removed = ?                                  ; Whether wheels have been removed

; ───────────────────────────────────────────────────────────────────────────────
; Foundation and Anchoring System
; ───────────────────────────────────────────────────────────────────────────────
{@manufactured_home}
{.foundation}
foundation_type = !(
    basement,                                       ; Full basement (permanent)
    crawl_space,                                    ; Permanent crawl space
    permanent_slab,                                 ; Concrete slab (permanent)
    pier_and_beam,                                  ; Piers with beams (may be permanent or non-permanent)
    runners,                                        ; Concrete/steel runners
    slab_on_grade                                   ; Permanent slab
)

permanent_foundation = ?                            ; Whether home has permanent foundation
foundation_certification = ?:if permanent_foundation = true ; Whether foundation is certified
foundation_engineer_certified = ?:if permanent_foundation = true ; Whether engineer certified the foundation

; Pier details (for pier_and_beam)
{.piers}
pier_material = (concrete, concrete_block, steel):if foundation_type = pier_and_beam ; Type of pier material
pier_count = ##:(0..):if foundation_type = pier_and_beam ; Number of piers supporting home
pier_spacing_feet = ##:(0..):if foundation_type = pier_and_beam ; Distance between piers in feet

{.foundation}

; Anchoring/Tie-Down System (critical for wind resistance)
{.anchoring}
anchored = !?
tiedown_system_type = (
    diagonal_and_vertical,                          ; Single-wide homes
    diagonal_only,                                  ; Double-wide homes
    frame_anchors_only                              ; Heavy newer homes
):if anchored = true

tiedown_certification = ?:if anchored = true        ; Whether tie-down system is certified
tiedown_engineer_certified = ?:if anchored = true  ; Whether engineer certified tie-downs
tiedown_installation_date = date:if anchored = true ; Date tie-down system was installed

; Tie-down specifications (HUD requirements)
diagonal_tiedowns_per_side = ##:(0..):if anchored = true ; Number of diagonal tie-downs per side
vertical_tiedowns_count = ##:(0..):if anchored = true ; Number of vertical tie-downs
working_load_capacity_lbs = ##:(0..):if anchored = true ; Minimum 3,150 lbs (Type I) or 4,000 lbs (Type II)

; Ground anchors
anchor_type = (
    arrowhead,
    auger,
    concrete_deadman,
    expanding,
    screw
):if anchored = true
anchor_depth_inches = ##:(0..):if anchored = true   ; Depth of ground anchors in inches
below_frost_line = ?:if anchored = true             ; Whether anchors are below frost line

; Soil classification (affects anchor selection)
soil_type = (
    clay,
    clayey_gravel,
    heavy_sand,
    heavy_soil,
    rock_hardpan,
    sandy_gravel,
    silty_gravel
):if anchored = true

; Wind zone rating (HUD wind zones I, II, III)
wind_zone = (I, II, III)                            ; HUD wind zone classification
wind_zone_design_speed_mph = ##:(70..180)           ; Design wind speed in miles per hour

{@manufactured_home}

; ───────────────────────────────────────────────────────────────────────────────
; Systems and Utilities
; ───────────────────────────────────────────────────────────────────────────────
{.heating}
= @res.res_heating

{@manufactured_home}

{.cooling}
= @res.res_cooling

{@manufactured_home}

{.electrical}
= @res.res_electrical

; Electrical panel location (HUD requirement - data plate nearby)
panel_accessible = ?                                ; Whether electrical panel is accessible

{@manufactured_home}

{.plumbing}
= @res.res_plumbing

; Water/sewer connections (mobile home park specific)
water_source = (municipal, park_system, private_well) ; Source of water service
sewer_type = (municipal, park_system, septic_tank)  ; Type of sewer/waste disposal

{@manufactured_home}

; ───────────────────────────────────────────────────────────────────────────────
; Mobile Home Park / Land Ownership
; ───────────────────────────────────────────────────────────────────────────────
{.land_status}
land_ownership = !(
    leased_lot,                                     ; Rent lot in mobile home park
    owned_land                                      ; Own land beneath home
)

; Mobile home park details (if leased_lot)
in_mobile_home_park = ?:if land_ownership = leased_lot ; Whether home is in mobile home park
park_name = ::if in_mobile_home_park = true         ; Name of mobile home park
park_address = @address:if in_mobile_home_park = true ; Physical address of park
lot_number = ::if in_mobile_home_park = true        ; Lot/space number within park
lot_rent_monthly = #$:(0..):if in_mobile_home_park = true ; Monthly lot rent amount
lot_lease_expiration = date:if in_mobile_home_park = true ; Expiration date of lot lease

; Park amenities (affects additional living expense calculations)
park_amenities = ::if in_mobile_home_park = true    ; Description of park amenities

; Land details (if owned_land)
lot_size_acres = #:(0..):if land_ownership = owned_land ; Size of owned land in acres
lot_size_square_feet = ##:(0..):if land_ownership = owned_land ; Size of owned land in square feet
legal_description = ::if land_ownership = owned_land ; Legal description of owned land
assessor_parcel_number = ::if land_ownership = owned_land ; Tax assessor parcel number

{@manufactured_home}

; ───────────────────────────────────────────────────────────────────────────────
; Special Features and Hazards
; ───────────────────────────────────────────────────────────────────────────────
{.special_features}
= @res.res_special_features

; Mobile home specific features
attached_carport = ?                                ; Whether home has attached carport
attached_porch = ?                                  ; Whether home has attached porch
attached_deck = ?                                   ; Whether home has attached deck
deck_square_feet = ##:(0..):if attached_deck = true ; Size of deck in square feet
screened_room = ?                                   ; Whether home has screened room addition
sunroom = ?                                         ; Whether home has sunroom addition
storage_shed = ?                                    ; Whether property has storage shed

{@manufactured_home}

; ───────────────────────────────────────────────────────────────────────────────
; Condition and Age-Related Factors
; ───────────────────────────────────────────────────────────────────────────────
{.condition}
overall_condition = (excellent, fair, good, poor)   ; Overall condition rating of home
age_years = ##:(0..)                                ; Age of home in years
well_maintained = ?                                 ; Whether home has been well maintained

; Common mobile home issues
{.issues}
floor_sagging = ?                                   ; Whether floors are sagging
door_alignment_issues = ?                           ; Whether doors have alignment problems
window_seal_damage = ?                              ; Whether window seals are damaged
moisture_problems = ?                               ; Whether moisture issues exist
mold_present = ?                                    ; Whether mold is present
structural_damage = ?                               ; Whether structural damage exists
frame_rust = ?                                      ; Whether frame has rust damage

{@manufactured_home}

; Updates and improvements
{.improvements}
hvac_updated = ?                                    ; Whether HVAC system has been updated
hvac_update_year = ##:(1950..):if hvac_updated = true ; Year HVAC was updated
windows_replaced = ?                                ; Whether windows have been replaced
windows_replacement_year = ##:(1950..):if windows_replaced = true ; Year windows were replaced
insulation_upgraded = ?                             ; Whether insulation has been upgraded
kitchen_remodel = ?                                 ; Whether kitchen has been remodeled
bathroom_remodel = ?                                ; Whether bathroom has been remodeled

{@manufactured_home}

; ───────────────────────────────────────────────────────────────────────────────
; Valuation
; ───────────────────────────────────────────────────────────────────────────────
{.valuation}
= @res.res_valuation

; Mobile home specific valuation
nada_value = #$:(0..)                               ; NADA Mobile Home Guide value
depreciation_rate_annual = #:(0..100)               ; Annual depreciation rate percentage

{@manufactured_home}

; ───────────────────────────────────────────────────────────────────────────────
; Transportation History
; ───────────────────────────────────────────────────────────────────────────────
{.transportation}
ever_moved = ?                                      ; Whether home has ever been moved
move_count = ##:(0..)                               ; Number of times home has been moved
last_move_date = date:if ever_moved = true          ; Date of most recent move
original_installation_date = date                   ; Date of original installation
current_location_since = date                       ; Date home arrived at current location

; Transportability assessment
currently_transportable = ?                         ; Whether home can currently be transported
axles_and_wheels_intact = ?:if currently_transportable = true ; Whether axles and wheels are intact
hitch_functional = ?:if currently_transportable = true ; Whether tow hitch is functional
estimated_move_cost = #$:(0..):if currently_transportable = true ; Estimated cost to move home

; ═══════════════════════════════════════════════════════════════════════════════
; Mobile Home Location (Property Address)
; ═══════════════════════════════════════════════════════════════════════════════

{@mobile_home_location}
location_id = :                                     ; Unique identifier for location
location_number = ##:(1..)                          ; Location number

; Physical address - uses shared @address type (US and Canada)
address = @address                                  ; Physical address of location

latitude = #:(-90..90)                              ; Latitude coordinate
longitude = #:(-180..180)                           ; Longitude coordinate

; Fire protection (critical for underwriting)
{.fire_protection}
= @res.res_protection_class

{@mobile_home_location}

; Natural hazard exposure
{.hazards}
= @res.res_hazard_exposure

; ═══════════════════════════════════════════════════════════════════════════════
; Lienholder (Mobile Home Financing)
; ═══════════════════════════════════════════════════════════════════════════════
; NOTE: Mobile homes are often financed as personal property (chattel loans)
; rather than real estate mortgages, especially when on leased land.

{@mobile_home_lienholder}
= @res.res_mortgagee

; Mobile home specific fields
lienholder_id = :                                   ; Unique identifier for lienholder
account_number = *:                                 ; Loan account number (confidential)


; Loan details specific to manufactured homes
loan_type = !(chattel_loan, conventional_mortgage, fha_loan, personal_loan, seller_financing, va_loan) ; Type of loan/financing

loan_date = date                                    ; Date loan was originated
loan_amount = #$:(0..)                              ; Original loan amount
current_balance = #$:(0..)                          ; Current outstanding balance
monthly_payment = #$:(0..)                          ; Monthly payment amount

; Title status (affects financing and coverage)
title_type = (certificate_of_title, real_property_deed) ; Type of title held

; Coverage requirements from lienholder
requires_coverage_a = ?                             ; Dwelling coverage required
minimum_coverage_a = #$:(0..):if requires_coverage_a = true ; Minimum Coverage A amount required
requires_physical_damage = ?                        ; Whether physical damage coverage required
maximum_deductible = #$:(0..)                       ; Maximum allowable deductible

{.contact}
phones[] = *@phone                                  ; Contact phone numbers (confidential)
email = *@email                                     ; Contact email address (confidential)


; ═══════════════════════════════════════════════════════════════════════════════
; HO-7 Specific Coverages
; ═══════════════════════════════════════════════════════════════════════════════

; Coverage A - Dwelling (the manufactured home itself)
{@ho7_coverage_a}
coverage_id = :                                     ; Unique identifier for coverage
coverage_type = "dwelling"                          ; Type of coverage
coverage_letter = "A"                               ; Coverage letter designation

; Coverage basis
valuation_method = !(
    actual_cash_value,                              ; Depreciated value (common for older mobile homes)
    functional_replacement_cost,                    ; Cost to replace with similar quality
    replacement_cost,                               ; Full replacement cost
    stated_amount                                   ; Agreed value
)

coverage_limit = !#$:(0..)                          ; Maximum coverage limit
deductible = #$:(0..)                               ; Deductible amount

; Mobile home specific inclusions
includes_permanently_attached = ?                   ; Carport, porch, deck if attached
includes_skirting = ?                               ; Whether skirting is included in coverage
includes_steps = ?                                  ; Whether steps are included in coverage
includes_tie_downs = ?                              ; Whether tie-downs are included in coverage

; Form type
peril_coverage = (named_perils, open_perils)        ; Type of peril coverage

; Exclusions specific to mobile homes
excludes_flood = ?                                  ; Whether flood is excluded
excludes_earthquake = ?                             ; Whether earthquake is excluded
excludes_settling = ?                               ; Whether settling is excluded
excludes_transportation = ?                         ; Covered separately under trip coverage

; Coverage B - Other Structures (detached structures)
{@ho7_coverage_b}
coverage_id = :                                     ; Unique identifier for coverage
coverage_type = "other_structures"                  ; Type of coverage
coverage_letter = "B"                               ; Coverage letter designation

coverage_limit = #$:(0..)                           ; Maximum coverage limit
limit_basis = (percentage_of_a, separate_limit)     ; Basis for calculating limit
percentage_of_coverage_a = #:(0..100):if limit_basis = percentage_of_a ; Percentage of Coverage A
typical_percentage = #:(10)                         ; Typically 10% of Coverage A

includes_detached_structures = ?                    ; Whether detached structures are included
includes_fences = ?                                 ; Whether fences are included
includes_driveways = ?                              ; Whether driveways are included

; Coverage C - Personal Property
{@ho7_coverage_c}
coverage_id = :                                     ; Unique identifier for coverage
coverage_type = "personal_property"                 ; Type of coverage
coverage_letter = "C"                               ; Coverage letter designation

coverage_limit = #$:(0..)                           ; Maximum coverage limit
limit_basis = (percentage_of_a, separate_limit)     ; Basis for calculating limit
percentage_of_coverage_a = #:(0..100):if limit_basis = percentage_of_a ; Percentage of Coverage A
typical_percentage = #:(50)                         ; Typically 50% of Coverage A

valuation = (actual_cash_value, replacement_cost)   ; Valuation method for personal property
replacement_cost_endorsement = ?                    ; Whether replacement cost endorsement applies

on_premises_limit = #$:(0..)                        ; Coverage limit for property on premises
off_premises_limit = #$:(0..)                       ; Coverage limit for property off premises
off_premises_percentage = #:(0..100)                ; Percentage of limit available off premises

; Special limits (standard sublimits) - using common residential type
{.special_limits}
= @res.res_special_limits

; Coverage D - Loss of Use / Additional Living Expense
{@ho7_coverage_d}
= @res.res_loss_of_use

; HO-7 specific fields
coverage_id = :                                     ; Unique identifier for coverage
coverage_type = "loss_of_use"                       ; Type of coverage
coverage_letter = "D"                               ; Coverage letter designation
coverage_limit = #$:(0..)                           ; Maximum coverage limit
limit_basis = (percentage_of_a, separate_limit, time_period) ; Basis for calculating limit
percentage_of_coverage_a = #:(0..100):if limit_basis = percentage_of_a ; Percentage of Coverage A
typical_percentage = #:(20)                         ; Typically 20% of Coverage A
time_limit_months = ##:(0..):if limit_basis = time_period ; Time limit in months

; Mobile home park specific
includes_lot_rent = ?:if in_mobile_home_park = true ; Continues paying lot rent during loss
includes_temporary_housing = ?                      ; Whether temporary housing is included
includes_moving_expenses = ?                        ; Whether moving expenses are included

; Coverage E - Personal Liability
{@ho7_coverage_e}
= @res.res_liability

; HO-7 specific fields
coverage_id = :                                     ; Unique identifier for coverage
coverage_type = "personal_liability"                ; Type of coverage
coverage_letter = "E"                               ; Coverage letter designation
typical_limits = (100000, 300000, 500000, 1000000)  ; Typical liability limit options

; Coverage F - Medical Payments to Others
{@ho7_coverage_f}
= @res.res_medical_payments

; HO-7 specific fields
coverage_id = :                                     ; Unique identifier for coverage
coverage_type = "medical_payments"                  ; Type of coverage
coverage_letter = "F"                               ; Coverage letter designation
typical_limits = (1000, 2500, 5000)                 ; Typical medical payments limit options
applies_to_insured_location = ?                     ; Whether coverage applies to insured location

; ═══════════════════════════════════════════════════════════════════════════════
; Transportation Coverage (Trip Coverage)
; ═══════════════════════════════════════════════════════════════════════════════
; Specialized coverage for when the mobile home is being moved/transported

{@ho7_transportation_coverage}
coverage_id = :                                     ; Unique identifier for coverage
coverage_included = ?                               ; Whether transportation coverage is included

{.trip_coverage}
coverage_limit = #$:(0..)                           ; Maximum coverage limit for trip
deductible = #$:(0..)                               ; Deductible amount for trip coverage

; What's covered during transit
covers_collision_damage = ?:if coverage_included = true ; Whether collision damage is covered
covers_upset_rollover = ?:if coverage_included = true ; Whether upset/rollover is covered
covers_contents_in_transit = ?:if coverage_included = true ; Whether contents during transit are covered
covers_debris_removal = ?:if coverage_included = true ; Whether debris removal is covered

; Transportation details (when coverage applies)
{.transport_details}
from_address = @address                             ; Origin address for move
to_address = @address                               ; Destination address for move
scheduled_move_date = date                          ; Scheduled date of move
estimated_distance_miles = ##:(0..)                 ; Estimated distance of move in miles
transport_company = :                               ; Name of transport company
transport_company_licensed = ?                      ; Whether transport company is licensed
transport_company_insured = ?                       ; Whether transport company is insured

; Exclusions
excludes_mechanical_breakdown = ?                   ; Whether mechanical breakdown is excluded
excludes_wear_and_tear = ?                          ; Whether wear and tear is excluded
excludes_manufacturer_defect = ?                    ; Whether manufacturer defect is excluded

{@ho7_transportation_coverage}

; Liability during move
transport_liability_included = ?                    ; Whether liability coverage during transport included
transport_liability_limit = #$:(0..)                ; Liability limit during transport

; ═══════════════════════════════════════════════════════════════════════════════
; Mobile Home Endorsements (HO-7 Specific)
; ═══════════════════════════════════════════════════════════════════════════════

{@ho7_endorsement}
= @res.res_endorsement

; Mobile/manufactured home specific endorsement types
endorsement_type = !(debris_removal_increased, earthquake, equipment_breakdown, extended_replacement_cost, flood, guaranteed_replacement_cost, identity_theft, inflation_guard, loss_assessment, mold_coverage_enhanced, ordinance_law, outbuilding_coverage, personal_property_replacement_cost, replacement_cost_mobile_home, scheduled_personal_property, service_line, sinkhole, tie_down_coverage, transportation_trip, water_backup, wind_hail_exclusion_buyback, windstorm_enhanced)

; ═══════════════════════════════════════════════════════════════════════════════
; Protection Devices (Mobile Home Specific)
; ═══════════════════════════════════════════════════════════════════════════════

{@ho7_protection_devices}
; Fire protection - using common residential type
{.fire_protection}
= @res.res_fire_protection

{@ho7_protection_devices}

; Security - using common residential type
{.security}
= @res.res_security

{@ho7_protection_devices}

; Environmental
water_shutoff_valve = ?                             ; Whether automatic water shutoff valve installed
leak_detection_system = ?                           ; Whether leak detection system installed
sump_pump = ?:if foundation_type = basement         ; Whether sump pump installed (basement)
sump_pump = ?:if foundation_type = crawl_space      ; Whether sump pump installed (crawl space)

; Wind protection (critical for mobile homes)
hurricane_shutters = ?:if hurricane_zone = true     ; Whether hurricane shutters installed
impact_resistant_windows = ?                        ; Whether impact resistant windows installed
roof_tie_down_straps = ?                            ; Whether roof has tie-down straps
reinforced_roof_structure = ?                       ; Whether roof structure is reinforced

; ═══════════════════════════════════════════════════════════════════════════════
; Prior Claims History
; ═══════════════════════════════════════════════════════════════════════════════

{@ho7_prior_claim}
= @res.res_prior_claim

; Mobile home specific fields
occurred_during_transport = ?                       ; Whether claim occurred during transport

; ═══════════════════════════════════════════════════════════════════════════════
; Underwriting and Risk Assessment
; ═══════════════════════════════════════════════════════════════════════════════

{@ho7_underwriting}
= @res.res_underwriting

; Mobile home specific underwriting fields
{.age_restrictions}
home_age_acceptable = ?                             ; Whether home age is acceptable
maximum_age_years = ##:(0..)                        ; Maximum acceptable age in years
requires_inspection_if_older_than = ##:(0..)        ; Age threshold requiring inspection

{@ho7_underwriting}

; Condition requirements
minimum_condition_rating = (excellent, fair, good)  ; Minimum acceptable condition rating
condition_acceptable = ?                            ; Whether condition meets requirements

; Foundation requirements
requires_permanent_foundation = ?                   ; Whether permanent foundation is required
requires_tiedown_certification = ?                  ; Whether tie-down certification is required
requires_engineer_certification = ?                 ; Whether engineer certification is required

; HUD compliance
requires_hud_certification = ?                      ; Whether HUD certification is required
hud_compliant = ?                                   ; Whether home is HUD compliant

; Inspection issues
{.inspection_issues}
inspection_issues[] = :                             ; List of issues found during inspection
repair_required = ?                                 ; Whether repairs are required
repairs_completed = ?:if repair_required = true     ; Whether required repairs have been completed

{@ho7_underwriting}

; Underwriting decision
{.decision}
underwriting_approved = ?                           ; Whether policy is approved
approval_conditions[] = :                           ; Conditions of approval
declination_reason = ::if underwriting_approved = false ; Reason for declination

{@ho7_underwriting}

; Loss history review
prior_claims_acceptable = ?                         ; Whether prior claims history is acceptable
claims_surcharge_applied = ?                        ; Whether claims surcharge has been applied
claims_surcharge_amount = #$:(0..):if claims_surcharge_applied = true ; Amount of claims surcharge

; ═══════════════════════════════════════════════════════════════════════════════
; HO-7 Mobile Home Policy (Main Container)
; ═══════════════════════════════════════════════════════════════════════════════

{@mobile_home_policy}
id = :                                              ; Unique identifier for policy
number = !:                                         ; Policy number

; ───────────────────────────────────────────────────────────────────────────────
; Policy Form
; ───────────────────────────────────────────────────────────────────────────────
policy_form = "HO7"                                 ; Policy form type
policy_form_name = "Mobile Home Form"               ; Name of policy form
policy_form_edition = :                             ; Edition of policy form
policy_version = :                                  ; Version of policy

; ───────────────────────────────────────────────────────────────────────────────
; Policy Term
; ───────────────────────────────────────────────────────────────────────────────
effective_date = !date                              ; Policy effective date
effective_time = time "12:01 AM"                    ; Policy effective time
expiration_date = !date                             ; Policy expiration date
expiration_time = time "12:01 AM"                   ; Policy expiration time
:invariant expiration_date > effective_date         ; Expiration must be after effective date

term_months = ##:(1..) 12                           ; Policy term in months (default 12)
policy_year = ##:(1..)                              ; Policy year number

; ───────────────────────────────────────────────────────────────────────────────
; Transaction Type
; ───────────────────────────────────────────────────────────────────────────────
{.transaction}
= @res.res_transaction

transaction_reason = :                              ; Reason for transaction

; ───────────────────────────────────────────────────────────────────────────────
; Named Insured(s)
; ───────────────────────────────────────────────────────────────────────────────
{.named_insureds[]}
= @res.res_named_insured

; ───────────────────────────────────────────────────────────────────────────────
; Insured Location
; ───────────────────────────────────────────────────────────────────────────────
insured_location = @mobile_home_location            ; Location of insured mobile home

; ───────────────────────────────────────────────────────────────────────────────
; Manufactured/Mobile Home
; ───────────────────────────────────────────────────────────────────────────────
manufactured_home = @manufactured_home              ; Details of manufactured/mobile home

; ───────────────────────────────────────────────────────────────────────────────
; Coverages (HO-7 Specific)
; ───────────────────────────────────────────────────────────────────────────────
coverage_a_dwelling = @ho7_coverage_a               ; Coverage A - Dwelling
coverage_b_other_structures = @ho7_coverage_b       ; Coverage B - Other Structures
coverage_c_personal_property = @ho7_coverage_c      ; Coverage C - Personal Property
coverage_d_loss_of_use = @ho7_coverage_d            ; Coverage D - Loss of Use
coverage_e_liability = @ho7_coverage_e              ; Coverage E - Personal Liability
coverage_f_medical_payments = @ho7_coverage_f       ; Coverage F - Medical Payments
transportation_coverage = @ho7_transportation_coverage ; Transportation/Trip Coverage

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Limits Summary
; ───────────────────────────────────────────────────────────────────────────────
{.coverage_summary}
coverage_a_limit = !#$:(0..)                        ; Coverage A limit amount
coverage_b_limit = #$:(0..)                         ; Coverage B limit amount
coverage_c_limit = #$:(0..)                         ; Coverage C limit amount
coverage_d_limit = #$:(0..)                         ; Coverage D limit amount
coverage_e_limit = #$:(0..)                         ; Coverage E limit amount
coverage_f_limit = #$:(0..)                         ; Coverage F limit amount
transportation_limit = #$:(0..)                     ; Transportation coverage limit amount

{@mobile_home_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Deductibles
; ───────────────────────────────────────────────────────────────────────────────
{.deductibles}
standard_deductible = !#$:(0..)                     ; Standard deductible amount
wind_hail_deductible = #$:(0..)                     ; Wind/hail deductible amount
wind_hail_deductible_percent = #:(0..100)           ; Wind/hail deductible as percentage
hurricane_deductible = #$:(0..)                     ; Hurricane deductible amount
hurricane_deductible_percent = #:(0..100)           ; Hurricane deductible as percentage

{@mobile_home_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Lienholders (Mobile Home Financing)
; ───────────────────────────────────────────────────────────────────────────────
lienholders[] = @mobile_home_lienholder             ; List of lienholders

; ───────────────────────────────────────────────────────────────────────────────
; Protection Devices
; ───────────────────────────────────────────────────────────────────────────────
protection_devices = @ho7_protection_devices        ; Protection devices installed

; ───────────────────────────────────────────────────────────────────────────────
; Endorsements
; ───────────────────────────────────────────────────────────────────────────────
endorsements[] = @ho7_endorsement                   ; List of policy endorsements

; ───────────────────────────────────────────────────────────────────────────────
; Prior Claims History
; ───────────────────────────────────────────────────────────────────────────────
prior_claims[] = @ho7_prior_claim                   ; List of prior claims
total_prior_claims = ##:(0..)                       ; Total number of prior claims
claims_free_years = ##:(0..)                        ; Number of claims-free years
prior_cancellations = ##:(0..)                      ; Number of prior policy cancellations

; ───────────────────────────────────────────────────────────────────────────────
; Premium Structure
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
= @res.res_premium

; HO-7 specific premium components
coverage_a_premium = #$:(0..)                       ; Premium for Coverage A
coverage_b_premium = #$:(0..)                       ; Premium for Coverage B
coverage_c_premium = #$:(0..)                       ; Premium for Coverage C
coverage_d_premium = #$:(0..)                       ; Premium for Coverage D
coverage_e_premium = #$:(0..)                       ; Premium for Coverage E
coverage_f_premium = #$:(0..)                       ; Premium for Coverage F
transportation_premium = #$:(0..):if transportation_coverage.coverage_included = true ; Premium for transportation coverage

{.premium}

; Mobile home specific surcharges
age_surcharge = #$:(0..)                            ; Surcharge for older homes
condition_surcharge = #$:(0..)                      ; Surcharge for fair/poor condition
claims_surcharge = #$:(0..)                         ; Surcharge for prior claims
non_permanent_foundation_surcharge = #$:(0..)       ; Surcharge for non-permanent foundation
wind_zone_surcharge = #$:(0..)                      ; Surcharge for wind zone location
coastal_surcharge = #$:(0..)                        ; Surcharge for coastal location

{.premium}

; Mobile home specific discounts
permanent_foundation_discount = #$:(0..)            ; Discount for permanent foundation
tiedown_certification_discount = #$:(0..)           ; Discount for certified tie-downs
wind_mitigation_discount = #$:(0..)                 ; Discount for wind mitigation features
senior_discount = #$:(0..)                          ; Discount for senior citizens

{.premium}

; Taxes and fees
state_tax = #$:(0..)                                ; State tax amount
county_tax = #$:(0..)                               ; County tax amount
policy_fee = #$:(0..)                               ; Policy fee amount
inspection_fee = #$:(0..)                           ; Inspection fee amount
installment_fee = #$:(0..)                          ; Installment fee amount

{@mobile_home_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Payment Plan
; ───────────────────────────────────────────────────────────────────────────────
{.payment}
= @res.res_payment_plan

{@mobile_home_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Underwriting
; ───────────────────────────────────────────────────────────────────────────────
underwriting = @ho7_underwriting                    ; Underwriting details

carrier_ref = :                                     ; Insurance carrier reference

{@mobile_home_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Agency/Producer
; ───────────────────────────────────────────────────────────────────────────────
agency = @agency                                    ; Agency information
producer = @producer                                ; Producer information
commission_percent = #:(0..100)                     ; Commission percentage

; ───────────────────────────────────────────────────────────────────────────────
; Policy Status
; ───────────────────────────────────────────────────────────────────────────────
{.status}
= @res.res_policy_status

; ───────────────────────────────────────────────────────────────────────────────
; Documents and Correspondence
; ───────────────────────────────────────────────────────────────────────────────
{.documents}
declarations_page_issued = ?                        ; Whether declarations page has been issued
policy_jacket_issued = ?                            ; Whether policy jacket has been issued
hud_label_verification_on_file = ?                  ; Whether HUD label verification is on file
tiedown_certification_on_file = ?                   ; Whether tie-down certification is on file
foundation_certification_on_file = ?                ; Whether foundation certification is on file
inspection_report_on_file = ?                       ; Whether inspection report is on file

; ───────────────────────────────────────────────────────────────────────────────
; Notes and Special Instructions
; ───────────────────────────────────────────────────────────────────────────────
underwriting_notes = :                              ; Notes from underwriting review
special_instructions = :                            ; Special instructions for policy handling

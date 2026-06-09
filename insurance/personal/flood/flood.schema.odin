; ===============================================================================
; ODIN Flood Insurance Policy Schema
; ===============================================================================
; Flood insurance including NFIP (National Flood Insurance Program) and private
; market flood policies covering building, contents, and additional living
; expenses with flood zone, BFE, and community rating details.
; ===============================================================================

@import "../../common/types.schema.odin" as types
@import "../../common/party.schema.odin" as party
@import "../residential-types.schema.odin" as res

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.flood"
version = "1.0.0"
title = "Flood Insurance Policy Schema"
description = "Comprehensive flood insurance schema for NFIP and private flood coverage"

{$derivation}
source[0].authority = "Federal Emergency Management Agency (FEMA)"
source[0].citation = "National Flood Insurance Program Flood Insurance Manual"
source[0].url = "https://www.fema.gov/flood-insurance/work-with-nfip/manuals"

source[1].authority = "Federal Emergency Management Agency (FEMA)"
source[1].citation = "NFIP Dwelling Form - Standard Flood Insurance Policy"
source[1].url = "https://www.fema.gov/flood-insurance/find-form"

source[2].authority = "Federal Emergency Management Agency (FEMA)"
source[2].citation = "Elevation Certificate and Instructions (FEMA Form 086-0-33)"
source[2].url = "https://www.fema.gov/glossary/elevation-certificate"

source[3].authority = "Federal Emergency Management Agency (FEMA)"
source[3].citation = "Flood Zone Designations"
source[3].url = "https://www.fema.gov/glossary/flood-zones"

source[4].authority = "Federal Emergency Management Agency (FEMA)"
source[4].citation = "Community Rating System (CRS)"
source[4].url = "https://www.fema.gov/floodplain-management/community-rating-system"

source[5].authority = "Federal Emergency Management Agency (FEMA)"
source[5].citation = "Risk Rating 2.0 Methodology"
source[5].url = "https://www.fema.gov/flood-insurance/risk-rating"

source[6].authority = "Code of Federal Regulations"
source[6].citation = "44 CFR Parts 59-80 - National Flood Insurance Program"
source[6].url = "https://www.ecfr.gov/current/title-44/chapter-I/subchapter-B"

source[7].authority = "Federal Emergency Management Agency (FEMA)"
source[7].citation = "Write Your Own (WYO) Program"
source[7].url = "https://nfipservices.floodsmart.gov/wyo-program"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema derived exclusively from public FEMA/NFIP documentation and federal regulations"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial flood insurance schema"
changelog[0].rationale = "NFIP structure derived from FEMA Flood Insurance Manual and 44 CFR"

; ===============================================================================
; FLOOD ZONES
; ===============================================================================
; FEMA flood zone classifications per Flood Insurance Rate Maps (FIRMs)

{@flood_zone}
; Required fields first
zone = (A, A1_30, A99, AE, AH, AO, AR, AR_A, AR_A1_30, AR_AE, AR_AH, AR_AO, B, C, D, V, V1_30, VE, X, X_shaded)  ; FEMA flood zone designation

; Optional fields
base_flood_depth = #                             ; Base flood depth in feet (Zone AO)
base_flood_elevation = #                         ; BFE in feet NAVD88 or NGVD29
coastal_barrier_resource = ?                     ; Within CBRS unit
coastal_high_hazard = ?                          ; V zone indicator (wave action)
community_panel_number = :                       ; FIRM panel number (county + panel)
datum = (NAVD88, NGVD29)                         ; Vertical datum for elevations
firm_date = date                                 ; FIRM effective date
floodway = ?                                     ; Within regulatory floodway
letter_of_map_amendment = ?                      ; LOMA/LOMR applies
loma_lomr_case_number = ::if letter_of_map_amendment = true  ; LOMA/LOMR case number
loma_lomr_date = date:if letter_of_map_amendment = true  ; LOMA/LOMR effective date
map_number = :                                   ; FIRM map number
special_flood_hazard_area = ?                    ; SFHA indicator (A/V zones)
zone_suffix = :                                  ; Zone suffix if applicable

; -------------------------------------------------------------------------------
; Zone Descriptions (per FEMA definitions)
; -------------------------------------------------------------------------------
; A        - SFHA, no BFE determined
; A1-30    - SFHA with BFE (older format, replaced by AE)
; AE       - SFHA with BFE
; AH       - SFHA, shallow flooding 1-3 feet, ponding
; AO       - SFHA, shallow flooding 1-3 feet, sheet flow
; AR       - SFHA, areas of special consideration
; A99      - SFHA, protected by federal flood control system
; V        - SFHA, coastal high hazard, no BFE
; V1-30    - SFHA, coastal with BFE (older format)
; VE       - SFHA, coastal high hazard with BFE
; B        - Moderate flood hazard (older format, replaced by X shaded)
; C        - Minimal flood hazard (older format, replaced by X unshaded)
; X        - Minimal flood hazard (unshaded) or moderate (shaded)
; D        - Undetermined risk, unstudied

; ===============================================================================
; PROPERTY / STRUCTURE DETAILS
; ===============================================================================
; Building and property characteristics for flood insurance rating

{@flood_property}
; Required fields first
building_type = (commercial, mixed_use, non_residential, other_residential, residential)  ; NFIP building type classification
occupancy = (condo_unit, manufactured_mobile_home, multi_family, non_residential, other, single_family, two_to_four_family)  ; NFIP occupancy type

; Optional fields
address = @address                               ; Property physical address
assessor_parcel_number = :                       ; Tax assessor parcel number
building_description = :                         ; Building description
condo_association_policy = ?                     ; Covered by RCBAP
contents_location = (basement_enclosure, building, other)  ; Where contents located
latitude = #:(-90..90)                           ; GPS latitude coordinate
legal_description = :                            ; Legal property description
longitude = #:(-180..180)                        ; GPS longitude coordinate
primary_residence = ?                            ; Owner's primary residence
property_id = :                                  ; Unique property identifier
rental_property = ?                              ; Rented to others
unit_number = :                                  ; Condo/apartment unit number

; -------------------------------------------------------------------------------
; Building Construction
; -------------------------------------------------------------------------------
{.construction}
construction_type = (frame, masonry, other)      ; Basic construction category
exterior_walls = (aluminum_vinyl_siding, brick_veneer, cmu_block, concrete, hardboard, other, stucco, wood)  ; Exterior wall material
fire_resistive = ?                               ; Fire resistive construction
floor_count = ##:(1..)                          ; Floors above ground
solid_foundation_walls = ?                       ; Solid foundation walls (vs open)
square_footage = ##:(0..)                       ; Total building square footage
total_basement_square_footage = ##:(0..)         ; Basement/enclosure area
year_built = ##:(1600..)                        ; Year of original construction

{@flood_property}

; -------------------------------------------------------------------------------
; Foundation Type (Critical for Rating)
; -------------------------------------------------------------------------------
; Per FEMA Flood Insurance Manual and NFIP rating requirements
{.foundation}
foundation_type = (basement, crawlspace, elevated_no_enclosure, elevated_with_enclosure, elevated_with_obstruction, fill, pier_post_piles, slab_on_grade, subgrade_crawlspace)  ; Foundation type

; Enclosure details (for elevated structures)
enclosure_below_bfe = ?                          ; Enclosed area below BFE
enclosure_floor_elevation = #                    ; Elevation of enclosure floor
enclosure_square_footage = ##:(0..)              ; Enclosure area in square feet
enclosure_use = (building_access, no_use, parking, storage):if enclosure_below_bfe = true  ; Enclosure use type

; Openings (required for rating enclosed areas)
flood_openings = ?:if enclosure_below_bfe = true ; Engineered flood openings present
flood_opening_count = ##:(0..):if flood_openings = true  ; Number of openings
flood_opening_total_area = ##:(0..):if flood_openings = true  ; Total opening area in sq inches

; Breakaway walls
breakaway_walls = ?                              ; Breakaway walls installed
breakaway_wall_certification = ?:if breakaway_walls = true  ; Certified by engineer

{@flood_property}

; -------------------------------------------------------------------------------
; NFIP Rating Factors
; -------------------------------------------------------------------------------
{.rating_factors}
; Pre-FIRM / Post-FIRM
firm_indicator = (post_firm, pre_firm)          ; Before/after first FIRM adoption
community_first_firm_date = date                 ; Date of community's first FIRM
original_construction_date = date                ; Original construction date

; Substantial Improvement/Damage
substantial_improvement = ?                      ; SI occurred after first FIRM
substantial_improvement_date = date:if substantial_improvement = true  ; SI completion date
substantial_damage = ?                           ; SD occurred (cumulative 50%+)
substantial_damage_date = date:if substantial_damage = true  ; SD determination date

; Repetitive Loss
repetitive_loss_property = ?                     ; 2+ losses >= $1,000 each
severe_repetitive_loss = ?                       ; SRL property per NFIP definition
flood_loss_count = ##:(0..)                      ; Number of flood losses
cumulative_loss_amount = #$:(0..)                ; Total of all flood losses paid

; Other factors
contents_above_ground_floor = ?                  ; Contents only above ground floor
machinery_equipment_below_bfe = ?                ; M&E below BFE

{@flood_property}

; -------------------------------------------------------------------------------
; Flood Mitigation Features
; -------------------------------------------------------------------------------
{.mitigation}
backflow_valves = ?                              ; Backflow prevention valves
barrier_floodproofed = ?                         ; Barrier/levee protection
battery_backup_sump = ?                          ; Battery backup sump pump
elevated_appliances = ?                          ; Appliances elevated above BFE
elevated_utilities = ?                           ; Utilities elevated above BFE
flood_damage_resistant_materials = ?             ; FDRM below BFE
flood_vents = ?                                  ; Non-engineered flood vents
floodproofed = ?                                 ; Dry/wet floodproofing
floodproofing_certificate = ?:if floodproofed = true  ; Floodproofing certificate on file
floodproofing_type = (dry, wet):if floodproofed = true  ; Type of floodproofing
french_drain = ?                                 ; French drain system
generator = ?                                    ; Backup generator
landscape_grading = ?                            ; Improved grading/drainage
sump_pump = ?                                    ; Sump pump installed

{@flood_property}

; ===============================================================================
; ELEVATION CERTIFICATE
; ===============================================================================
; Per FEMA Form 086-0-33 (Elevation Certificate)

{@flood_elevation_certificate}
; Required fields first
building_diagram = ##:(1..9)                    ; FEMA building diagram number (1-9)
lowest_floor_elevation = #                      ; Lowest floor elevation (Section C2a)

; Optional fields
attached_garage_elevation = #                    ; Attached garage floor elevation
bottom_of_lowest_horizontal_member = #           ; V-zone: bottom of lowest horizontal member (C2c)
certificate_date = date                          ; Date certificate completed
certifier_community = :                          ; Certifier community name
certifier_license = :                            ; Certifier license/certification number
certifier_name = :                               ; Certifier name
certifier_phone = *@phone                        ; Certifier phone
certifier_title = (architect, engineer, land_surveyor, other)  ; Certifier type
datum = (NAVD88, NGVD29, other)                  ; Vertical datum used
datum_conversion = #                             ; Datum conversion factor if applicable
ec_id = :                                        ; Elevation certificate ID
enclosure_floor_elevation = #                    ; Enclosure/crawlspace floor elevation
grade_elevation_building_side_a = #              ; Building side A grade elevation
grade_elevation_building_side_b = #              ; Building side B grade elevation
grade_elevation_building_side_c = #              ; Building side C grade elevation
grade_elevation_building_side_d = #              ; Building side D grade elevation
highest_adjacent_grade = #                       ; Highest adjacent grade (HAG) (C2e)
lag_difference = #                               ; Difference from LAG to lowest floor
lowest_adjacent_grade = #                        ; Lowest adjacent grade (LAG) (C2d)
lowest_elevation_machinery = #                   ; Lowest elevation of machinery/equipment (C2b)
next_higher_floor_elevation = #                  ; Next higher floor elevation
property_ref = :                                 ; Reference to @flood_property
section_a_amendment_number = :                   ; Section A amendment number
section_a_property_description = :               ; Section A property description
top_of_bottom_floor = #                          ; Top of bottom floor elevation

; -------------------------------------------------------------------------------
; Calculated Values
; -------------------------------------------------------------------------------
{.calculations}
base_flood_elevation = #                         ; BFE from FIRM
difference_building_to_bfe = #                   ; Lowest floor minus BFE
height_above_adjacent_grade = #                  ; Height of lowest floor above grade
lowest_floor_above_bfe = ?                       ; Lowest floor at or above BFE

{@flood_elevation_certificate}

; ===============================================================================
; BUILDING COVERAGE (Coverage A)
; ===============================================================================
; NFIP building coverage for structure and permanently installed fixtures

{@flood_building_coverage}
; Required fields first
coverage_amount = #$:(0..)                      ; Building coverage limit
deductible = #$:(0..)                           ; Building deductible

; Optional fields
basis = (actual_cash_value, replacement_cost)    ; Coverage basis
covered = ?                                      ; Coverage selected
coverage_id = :                                  ; Unique coverage identifier
maximum_available = #$:(0..)                     ; Maximum coverage available

; -------------------------------------------------------------------------------
; Coverage Details
; -------------------------------------------------------------------------------
{.covered_items}
; Building structure items per NFIP
appliances = ?                                   ; Built-in appliances
attached_garages = ?                             ; Attached garages/carports
blinds = ?                                       ; Window blinds
bookcases_cabinets = ?                           ; Built-in bookcases/cabinets
carpeting = ?                                    ; Permanently installed carpeting
central_air = ?                                  ; Central air conditioning
cleanup_debris_removal = ?                       ; Debris removal from building
detached_garage = ?                              ; Detached garage (separate structure)
docks = ?                                        ; Docks and wharves
drywall = ?                                      ; Drywall/wallboard
electrical = ?                                   ; Electrical systems
elevators = ?                                    ; Elevators
fire_sprinklers = ?                              ; Fire sprinkler systems
flooring = ?                                     ; Floor coverings
foundation = ?                                   ; Foundation and footings
fuel_tanks = ?                                   ; Fuel tanks (interior)
furnaces = ?                                     ; Furnaces/heating equipment
paneling = ?                                     ; Wall paneling
plumbing = ?                                     ; Plumbing systems
refrigerators = ?                                ; Refrigerators (if covered)
staircases = ?                                   ; Interior staircases
stoves = ?                                       ; Stoves/ranges (if covered)
water_heaters = ?                                ; Water heaters
well_pumps = ?                                   ; Well pumps/equipment

{@flood_building_coverage}

; ===============================================================================
; CONTENTS COVERAGE (Coverage B)
; ===============================================================================
; NFIP contents coverage for personal property

{@flood_contents_coverage}
; Required fields first
coverage_amount = #$:(0..)                      ; Contents coverage limit
deductible = #$:(0..)                           ; Contents deductible

; Optional fields
basis = (actual_cash_value, replacement_cost)    ; Coverage basis (residential only for RC)
covered = ?                                      ; Coverage selected
coverage_id = :                                  ; Unique coverage identifier
location_of_contents = (above_ground_floor, basement_enclosure, ground_floor, multiple_floors)  ; Where contents are located
maximum_available = #$:(0..)                     ; Maximum coverage available

; -------------------------------------------------------------------------------
; Special Limits of Liability
; -------------------------------------------------------------------------------
{.special_limits}
artwork_limit = #$:(0..)                         ; Per item artwork limit
business_property_limit = #$:(0..)               ; Business property sublimit
collectibles_limit = #$:(0..)                    ; Collectibles per item limit
electronic_equipment_limit = #$:(0..)            ; Electronic equipment sublimit
furs_limit = #$:(0..)                            ; Furs per item limit
jewelry_limit = #$:(0..)                         ; Jewelry per item limit

{@flood_contents_coverage}

; ===============================================================================
; INCREASED COST OF COMPLIANCE (ICC) COVERAGE
; ===============================================================================
; Coverage for building code compliance after flood damage

{@flood_icc_coverage}
; Required fields first
coverage_amount = #$:(0..)                      ; ICC coverage limit (max $30,000 NFIP)

; Optional fields
covered = ?                                      ; ICC coverage included
coverage_id = :                                  ; Unique coverage identifier

; -------------------------------------------------------------------------------
; ICC Claim Eligibility (determined at claim time)
; -------------------------------------------------------------------------------
{.claim_eligibility}
building_code_requirement = ?                    ; Local code requires elevation/floodproofing
community_compliant = ?                          ; Community in compliance with NFIP
elevation_cost_estimate = #$:(0..)               ; Estimated elevation cost
floodproofing_cost_estimate = #$:(0..)           ; Estimated floodproofing cost
relocation_cost_estimate = #$:(0..)              ; Estimated relocation cost
substantial_damage = ?                           ; SD determination made
substantial_improvement = ?                      ; SI triggered

{@flood_icc_coverage}

; ===============================================================================
; FLOOD RATING
; ===============================================================================
; Rating factors and calculations per NFIP methodology

{@flood_rating}
; Required fields first
rating_method = (preferred_risk, risk_rating_2, specific_rating, standard)  ; Rating method used

; Optional fields
annual_premium = #$:(0..)                        ; Annual policy premium
building_premium = #$:(0..)                      ; Building coverage premium
condo_unit_premium = #$:(0..)                    ; Condo unit owner premium if applicable
contents_premium = #$:(0..)                      ; Contents coverage premium
federal_policy_fee = #$:(0..)                    ; Federal policy fee
hfiaa_surcharge = #$:(0..)                       ; HFIAA surcharge (per policy)
icc_premium = #$:(0..)                           ; ICC coverage premium
probation_surcharge = #$:(0..)                   ; Community probation surcharge
rate_effective_date = date                       ; Rate effective date
rating_date = date                               ; Date rating calculated
rating_id = :                                    ; Unique rating identifier
reserve_fund_assessment = #$:(0..)               ; Reserve fund assessment
total_premium = #$:(0..)                         ; Total premium with all fees

; -------------------------------------------------------------------------------
; Rating Factors
; -------------------------------------------------------------------------------
{.rating_factors}
; Building characteristics
building_age_factor = #                          ; Age-based factor
building_value_factor = #                        ; Value-based factor
construction_type_factor = #                     ; Construction type factor
elevation_difference_factor = #                  ; Elevation to BFE factor
foundation_type_factor = #                       ; Foundation type factor
floor_count_factor = #                           ; Floor count factor

; Location factors
distance_to_coast_factor = #                     ; Distance to coast factor
distance_to_river_factor = #                     ; Distance to river factor
flood_frequency_factor = #                       ; Historical flooding factor
territory_factor = #                             ; Geographic territory factor
zone_factor = #                                  ; Flood zone factor

; Other factors
claim_history_factor = #                         ; Prior claims factor
deductible_factor = #                            ; Deductible credit factor
prior_flood_factor = #                           ; Prior NFIP flood insurance factor

{@flood_rating}

; -------------------------------------------------------------------------------
; Discounts and Surcharges
; -------------------------------------------------------------------------------
{.adjustments}
crs_discount = #$:(0..)                          ; Community Rating System discount
crs_discount_percent = ##:(0..45)                ; CRS discount percentage (5-45%)
elevation_discount = #$:(0..)                    ; Elevation above BFE discount
group_flood_discount = #$:(0..)                  ; Group flood insurance discount
mitigation_discount = #$:(0..)                   ; Mitigation measures discount
newly_mapped_discount = #$:(0..)                 ; Newly mapped discount
pre_firm_discount = #$:(0..)                     ; Pre-FIRM subsidized discount
prior_policy_discount = #$:(0..)                 ; Continuous coverage discount
srl_surcharge = #$:(0..)                         ; Severe Repetitive Loss surcharge

{@flood_rating}

; -------------------------------------------------------------------------------
; Risk Rating 2.0 Specific Factors (Current NFIP methodology)
; -------------------------------------------------------------------------------
{.risk_rating_2}
building_replacement_cost = #$:(0..)             ; Replacement cost used in rating
distance_to_coast_miles = #:(0..)                ; Distance to nearest coast
distance_to_flood_source_feet = ##:(0..)         ; Distance to flood source
first_floor_height_above_ground = #              ; First floor height
flood_type = (coastal, fluvial, great_lakes, pluvial)  ; Primary flood type
historical_flood_frequency = #:(0..)             ; Expected annual flood frequency
levee_distance_miles = #:(0..)                   ; Distance to levee (if any)
levee_quality_rating = ##:(0..100)               ; Levee quality score

{@flood_rating}

; ===============================================================================
; COMMUNITY RATING SYSTEM (CRS)
; ===============================================================================
; CRS class and discount information

{@flood_crs}
; Required fields first
community_crs_class = ##:(1..10)                ; CRS class (1 = best, 10 = no participation)
community_id = :(6)                             ; NFIP community ID number

; Optional fields
crs_discount_sfha = ##:(0..45)                   ; SFHA discount percentage
crs_discount_non_sfha = ##:(0..10)               ; Non-SFHA discount percentage (5 or 10%)
crs_entry_date = date                            ; Date community entered CRS
crs_id = :                                       ; CRS record identifier
last_verification_date = date                    ; Last CRS verification
participating = ?                                ; Community participates in CRS

; -------------------------------------------------------------------------------
; CRS Credit Points by Activity Series
; -------------------------------------------------------------------------------
{.credit_points}
series_300 = ##:(0..)                            ; Public information (300 series)
series_400 = ##:(0..)                            ; Mapping and regulations (400 series)
series_500 = ##:(0..)                            ; Flood damage reduction (500 series)
series_600 = ##:(0..)                            ; Warning and response (600 series)
total_points = ##:(0..)                          ; Total CRS credit points

{@flood_crs}

; ===============================================================================
; FLOOD CLAIM
; ===============================================================================
; Flood insurance claim structure

{@flood_claim}
; Required fields first
claim_number = :                                ; Unique claim number
date_of_loss = date                             ; Date flood damage occurred
policy_number = :                               ; Policy number
reported_date = date                            ; Date claim reported

; Optional fields
adjuster_name = :                                ; Assigned adjuster name
adjuster_phone = *@phone                         ; Adjuster phone
advance_payment = #$:(0..)                       ; Advance/emergency payment made
building_damage_amount = #$:(0..)                ; Building damage assessed
building_paid = #$:(0..)                         ; Building claim amount paid
catastrophe_number = :                           ; FEMA catastrophe number if applicable
cause_of_loss = (coastal_erosion, dam_break, flash_flood, general_flood, ice_jam, mudflow, overflow, ponding, river_flood, storm_surge, tidal, tsunami)  ; Cause of flood
claim_id = :                                     ; Unique claim identifier
closed_date = date                               ; Date claim closed
contents_damage_amount = #$:(0..)                ; Contents damage assessed
contents_paid = #$:(0..)                         ; Contents claim amount paid
deductible_applied = #$:(0..)                    ; Deductible amount applied
disaster_number = :                              ; Presidential disaster declaration number
examiner_name = :                                ; Claims examiner name
icc_paid = #$:(0..)                              ; ICC claim amount paid
icc_requested = ?                                ; ICC benefits requested
property_ref = :                                 ; Reference to @flood_property
reopened = ?                                     ; Claim was reopened
reopened_date = date:if reopened = true          ; Date claim reopened
salvage_amount = #$:(0..)                        ; Salvage/subrogation recovered
status = (assigned, closed_no_payment, closed_paid, denied, investigation, open, partial_payment, pending, reopened, subrogation)  ; Claim status
total_paid = #$:(0..)                            ; Total claim amount paid
water_depth_inches = ##:(0..)                    ; Water depth in structure (inches)

; -------------------------------------------------------------------------------
; Proof of Loss
; -------------------------------------------------------------------------------
{.proof_of_loss}
building_pol_amount = #$:(0..)                   ; Building POL amount claimed
building_pol_date = date                         ; Building POL signed date
building_pol_received = ?                        ; Building POL received
contents_pol_amount = #$:(0..)                   ; Contents POL amount claimed
contents_pol_date = date                         ; Contents POL signed date
contents_pol_received = ?                        ; Contents POL received
extension_granted = ?                            ; POL extension granted
extension_date = date:if extension_granted = true  ; Extension deadline

{@flood_claim}

; -------------------------------------------------------------------------------
; Damage Assessment
; -------------------------------------------------------------------------------
{.damage_assessment}
basement_damaged = ?                             ; Basement/enclosure damaged
contents_destroyed = ?                           ; Contents total loss
electrical_damaged = ?                           ; Electrical system damaged
foundation_damaged = ?                           ; Foundation damaged
hvac_damaged = ?                                 ; HVAC system damaged
percent_building_damaged = ##:(0..100)           ; Percent of building damaged
percent_contents_damaged = ##:(0..100)           ; Percent of contents damaged
plumbing_damaged = ?                             ; Plumbing damaged
roof_damaged = ?                                 ; Roof damaged from flooding
structure_total_loss = ?                         ; Building total loss
walls_damaged = ?                                ; Walls/drywall damaged

{@flood_claim}

; ===============================================================================
; FLOOD ENDORSEMENT
; ===============================================================================
; Policy endorsements and modifications

{@flood_endorsement}
; Required fields first
effective_date = date                           ; Endorsement effective date
endorsement_number = :                          ; Endorsement number

; Optional fields
building_coverage_change = #$                    ; Change in building coverage
building_deductible_change = #$                  ; Change in building deductible
contents_coverage_change = #$                    ; Change in contents coverage
contents_deductible_change = #$                  ; Change in contents deductible
description = :                                  ; Endorsement description
endorsement_id = :                               ; Unique endorsement identifier
endorsement_type = (address_change, cancel, coverage_decrease, coverage_increase, deductible_change, insured_change, mortgagee_change, new_elevation_certificate, reinstatement, renewal)  ; Type of endorsement
expiration_date = date                           ; Endorsement expiration
premium_change = #$                              ; Premium change amount (positive or negative)

{@flood_endorsement}

; ===============================================================================
; WAITING PERIOD
; ===============================================================================
; NFIP waiting period rules

{@flood_waiting_period}
; Required fields first
application_date = date                         ; Date application received
coverage_effective_date = date                  ; Date coverage becomes effective
waiting_period_days = ##:(0..30)                ; Waiting period in days

; Optional fields
exception_applied = ?                            ; Waiting period exception
exception_reason = (initial_purchase, loan_increase, loma_lomr, map_revision, private_to_nfip):if exception_applied = true  ; Exception reason
rollover_from_private = ?                        ; Rollover from private flood policy

; Standard NFIP Waiting Periods:
; - 30 days: Standard waiting period
; - 0 days: Initial purchase with loan closing (within 13 months)
; - 0 days: Loan increase
; - 1 day: Map revision (LOMA/LOMR)
; - 0 days: Private flood rollover (continuous coverage)

{@flood_waiting_period}

; ===============================================================================
; FLOOD POLICY
; ===============================================================================
; Complete NFIP or private flood insurance policy

{@flood_policy}
; Required fields first
effective_date = date                           ; Policy effective date
expiration_date = date                          ; Policy expiration date
policy_form = (dwelling_form, general_property, private_excess, private_primary, rcbap)  ; Policy form type
policy_number = :                               ; Policy number

; Invariants
:invariant expiration_date > effective_date

; Optional fields
agency = @agency                                 ; Agency information
building_coverage = @flood_building_coverage     ; Coverage A - Building
cancellation_date = date                         ; If cancelled
cancellation_reason = :                          ; Reason for cancellation
commission_percent = #:(0..100)                  ; Commission percentage
community = @flood_crs                           ; Community rating information
contents_coverage = @flood_contents_coverage     ; Coverage B - Contents
effective_time = time                            ; Policy effective time
elevation_certificate = @flood_elevation_certificate  ; Elevation certificate data
endorsements[] = @flood_endorsement              ; Policy endorsements
expiration_time = time                           ; Policy expiration time
flood_zone = @flood_zone                         ; Flood zone information
icc_coverage = @flood_icc_coverage               ; ICC coverage
id = :                                           ; Unique policy identifier
lapsed = ?                                       ; Policy lapsed (lapse in coverage)
lapsed_date = date:if lapsed = true              ; Date policy lapsed
mortgagee = @mortgagee                           ; Mortgagee/lienholder
named_insured = @named_insured                   ; Named insured
payment_plan = @res_payment_plan                 ; Payment plan
policy_status = (active, cancelled, expired, lapsed, pending, reinstated)  ; Policy status
policy_year = ##:(1..)                           ; Policy year number
premium = @res_premium                           ; Premium information
prior_claims[] = @flood_claim                    ; Prior flood claims
producer = @producer                             ; Producer information
property = @flood_property                       ; Property details
rating = @flood_rating                           ; Rating information
renewal = ?                                      ; Is this a renewal
renewal_of_policy = ::if renewal = true          ; Prior policy number if renewal
term_months = ##:(12)                            ; Policy term in months (typically 12)
transaction = @res_transaction                   ; Transaction information
waiting_period = @flood_waiting_period           ; Waiting period information
wyo_carrier = :                                  ; Write Your Own carrier name
wyo_carrier_naic = :(5)                          ; WYO carrier NAIC code

; -------------------------------------------------------------------------------
; Policy Limits Summary
; -------------------------------------------------------------------------------
{.limits_summary}
building_limit = #$:(0..)                        ; Building coverage limit
contents_limit = #$:(0..)                        ; Contents coverage limit
icc_limit = #$:(0..)                             ; ICC coverage limit
total_coverage = #$:(0..)                        ; Total all coverages

{@flood_policy}

; -------------------------------------------------------------------------------
; Deductible Summary
; -------------------------------------------------------------------------------
{.deductibles}
building_deductible = #$:(0..)                   ; Building deductible
contents_deductible = #$:(0..)                   ; Contents deductible

{@flood_policy}

; -------------------------------------------------------------------------------
; NFIP Maximums (per 44 CFR)
; -------------------------------------------------------------------------------
; Residential 1-4 Family:
;   Building: $250,000
;   Contents: $100,000
; Other Residential (RCBAP):
;   Building: $250,000 per unit
;   Contents: $100,000 per unit
; Non-Residential:
;   Building: $500,000
;   Contents: $500,000
; ICC: $30,000 (all building types)

; -------------------------------------------------------------------------------
; Underwriting Information
; -------------------------------------------------------------------------------
underwriting = @res_underwriting                 ; Underwriting details

{@flood_policy}
grandfathered = ?                                ; Pre-FIRM subsidy or rate grandfathering
grandfathering_type = (continuous_coverage, pre_firm_subsidy, zone_grandfathering):if grandfathered = true  ; Type of grandfathering


; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Gig Economy Coverage Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Gig economy coverage for rideshare (Uber, Lyft) and delivery (DoorDash, Instacart)
; drivers covering TNC period gaps, commercial use exclusions, and platform-
; specific insurance coordination.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../../coverages/coverage.schema.odin" as cov
@import "../../../coverages/lines/liability.schema.odin" as liability
@import "../../../coverages/lines/auto.schema.odin" as auto
@import "../../../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.auto.gig-economy"
version = "1.0.0"
title = "Gig Economy Coverage Schema"
description = "Coverage for rideshare and delivery gig workers with period-based and platform-specific structures"

{$derivation}
source[0].authority = "California Public Utilities Commission"
source[0].citation = "TNC Insurance Requirements - Decision 13-09-045"
source[0].url = "https://www.cpuc.ca.gov/regulatory-services/licensing/transportation-licensing-and-analysis-branch/transportation-network-companies/tnc-insurance-requirements"

source[1].authority = "Texas Department of Licensing and Regulation"
source[1].citation = "Texas Insurance Code Chapter 1954 - Transportation Network Companies"
source[1].url = "https://www.tdlr.texas.gov/tnc/operations.htm"

source[2].authority = "New York Department of Financial Services"
source[2].citation = "NY Vehicle and Traffic Law Article 44-B Section 1693"
source[2].url = "https://www.nysenate.gov/legislation/laws/VAT/1693"

source[3].authority = "Virginia Department of Motor Vehicles"
source[3].citation = "TNC Insurance Requirements"
source[3].url = "https://www.dmv.virginia.gov/businesses/tnc/insurance"

source[4].authority = "California Legislature"
source[4].citation = "Assembly Bill 5 (AB5) - Worker Classification"
source[4].url = "https://leginfo.legislature.ca.gov/faces/billTextClient.xhtml?bill_id=201920200AB5"

source[5].authority = "U.S. Department of Labor"
source[5].citation = "Independent Contractor Rule - 29 CFR Parts 780, 788, 795"
source[5].url = "https://www.dol.gov/agencies/whd/flsa/misclassification"

source[6].authority = "National Association of Insurance Commissioners"
source[6].citation = "Commercial Ride-Sharing Insurance Topics"
source[6].url = "https://content.naic.org/insurance-topics/commercial-ride-sharing"

methodology = "regulatory_derivation"                 ; Schema derivation methodology
proprietary_sources_consulted = ?false             ; No proprietary sources were used
notes = "Derived from state TNC regulations, AB5 worker classification law, and DOL guidance. Coverage periods and minimum limits vary by state."  ; Additional derivation notes

changelog[0].date = 2024-12-14
changelog[0].change = "Initial gig economy coverage schema"
changelog[0].rationale = "Comprehensive coverage for emerging rideshare and delivery gig worker insurance needs"

; ═══════════════════════════════════════════════════════════════════════════════
; ENUMERATIONS
; ═══════════════════════════════════════════════════════════════════════════════

; ───────────────────────────────────────────────────────────────────────────────
; Gig Work Types
; ───────────────────────────────────────────────────────────────────────────────

{@gig_work_type}
category = (delivery, errand, logistics, moving, rideshare, shopping)

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Periods
; ───────────────────────────────────────────────────────────────────────────────

{@gig_period}
period = (period_0, period_1, period_2, period_3)  ; TNC coverage period designation
description = :                                    ; Human-readable period description

; ═══════════════════════════════════════════════════════════════════════════════
; GIG PLATFORM
; ═══════════════════════════════════════════════════════════════════════════════
; Platform details for rideshare and delivery companies

{@gig_platform}
id = :                                             ; Unique platform identifier

; ───────────────────────────────────────────────────────────────────────────────
; Platform Identification
; ───────────────────────────────────────────────────────────────────────────────
name = :                                          ; Platform name (Uber, Lyft, DoorDash, etc.)
code = :                                           ; Short code for platform
platform_type = (delivery, errand, logistics, multi_service, rideshare, shopping)  ; Type of gig service provided

; ───────────────────────────────────────────────────────────────────────────────
; Platform-Provided Insurance
; ───────────────────────────────────────────────────────────────────────────────

{.provided_coverage}
provides_liability = ?                             ; Platform provides liability coverage
provides_collision = ?                             ; Platform provides collision coverage
provides_comprehensive = ?                         ; Platform provides comprehensive coverage
provides_um_uim = ?                                ; Platform provides UM/UIM coverage
provides_occupational_accident = ?                 ; Platform provides occupational accident coverage

{@gig_platform}
{.provided_coverage.period_1}
; Period 1 limits (app on, waiting)
liability_per_person = #$:(0..)            ; BI per person
liability_per_accident = #$:(0..)          ; BI per accident
liability_property_damage = #$:(0..)       ; PD limit
liability_combined_single = #$:(0..)       ; CSL if used instead of split

{@gig_platform}
{.provided_coverage.period_2_3}
; Period 2-3 limits (matched/passenger)
liability_combined_single = #$:(0..)       ; CSL limit
um_uim_limit = #$:(0..)                    ; UM/UIM limit
collision_deductible = #$:(0..)            ; Platform collision deductible
comprehensive_deductible = #$:(0..)        ; Platform comp deductible

{@gig_platform}
{.provided_coverage}
; Occupational accident coverage provided by platform
occ_accident_medical = #$:(0..)            ; Medical expense limit
occ_accident_disability = #$:(0..)         ; Disability benefit
occ_accident_death = #$:(0..)              ; Accidental death benefit

{@gig_platform}

; Coverage conditions
coverage_requires_personal_policy = ?              ; Must have personal auto to qualify
coverage_requires_comp_coll = ?                    ; Must have comp/coll on personal policy
platform_deductible = #$:(0..)                     ; Deductible for platform coverage

; ───────────────────────────────────────────────────────────────────────────────
; Platform Requirements
; ───────────────────────────────────────────────────────────────────────────────
min_vehicle_year = ##:(1900..2100)                 ; Minimum model year for vehicles
max_vehicle_age = ##:(0..30)                       ; Maximum vehicle age in years
min_driver_age = ##:(16..30)                       ; Minimum driver age to work on platform
requires_background_check = ?                      ; Platform requires background check
requires_vehicle_inspection = ?                    ; Platform requires vehicle inspection
requires_commercial_registration = ?               ; Platform requires commercial registration

; ═══════════════════════════════════════════════════════════════════════════════
; GIG WORKER
; ═══════════════════════════════════════════════════════════════════════════════
; Gig economy worker profile and classification

{@gig_worker}
id = :                                             ; Unique worker identifier

; ───────────────────────────────────────────────────────────────────────────────
; Worker Identity
; ───────────────────────────────────────────────────────────────────────────────
name = @person_name                                ; Worker's name
contact = @contact_info                            ; Contact information
address = @address                                 ; Worker's address
demographics = @demographics                       ; Demographic information
identifiers = @person_identifiers                  ; Personal identifiers (licenses, etc.)

; ───────────────────────────────────────────────────────────────────────────────
; Worker Classification
; ───────────────────────────────────────────────────────────────────────────────

classification = (employee, independent_contractor)  ; Worker classification status
classification_state = :(2)                        ; State where classification is determined
abc_test_status = (employee, exempt, independent_contractor):if classification_state = CA  ; AB5 ABC test status for California

tax_id_type = (ein, sin, ssn)                      ; Type of tax identifier
ein = *:                                           ; Employer Identification Number (for business entities)
sin = *:/^\d{3}-\d{3}-\d{3}$/                      ; Social Insurance Number (Canada)
ssn = *:format ssn                                 ; Social Security Number

; ───────────────────────────────────────────────────────────────────────────────
; Platform Affiliations
; ───────────────────────────────────────────────────────────────────────────────
; Worker may operate on multiple platforms

{.platforms[]}
platform_ref = :                                   ; Reference to @gig_platform
platform_name = :                                  ; Name of the platform
active = ?                                         ; Currently active on this platform
onboarded_date = date                              ; Date worker joined platform
deactivated = ?                                    ; Worker has been deactivated
deactivation_date = date                           ; Date of deactivation
deactivation_reason = (
    background_check_failed,
    customer_complaints,
    inactivity,
    other,
    policy_violation,
    rating_too_low,
    safety_incident,
    vehicle_issue,
    voluntary
):if deactivated = true                            ; Reason for deactivation
lifetime_trips = ##:(0..)                          ; Total trips completed on platform
lifetime_deliveries = ##:(0..)                     ; Total deliveries completed on platform
current_rating = #                                 ; Current customer rating

{@gig_worker}

; ───────────────────────────────────────────────────────────────────────────────
; Gig Work Activity
; ───────────────────────────────────────────────────────────────────────────────
primary_gig_type = (both, delivery, other, rideshare)  ; Primary type of gig work performed
gig_work_status = (full_time, occasional, part_time)  ; Employment status for gig work
avg_weekly_hours = ##:(0..168)                     ; Average weekly hours worked
avg_weekly_trips = ##:(0..)                        ; Average weekly trips completed
avg_weekly_deliveries = ##:(0..)                   ; Average weekly deliveries completed
gig_start_date = date                              ; When started gig work
years_gig_experience = ##:(0..50)                  ; Years of gig work experience

; ───────────────────────────────────────────────────────────────────────────────
; Non-Gig Employment
; ───────────────────────────────────────────────────────────────────────────────
; Many gig workers have other employment

other_employment = ?                               ; Has other employment outside gig work
other_employment_details = @employment:if other_employment = true  ; Details of other employment
employer_health_insurance = ?                      ; Employer provides health insurance
employer_auto_coverage = ?                         ; Employer provides auto coverage

; ═══════════════════════════════════════════════════════════════════════════════
; GIG VEHICLE
; ═══════════════════════════════════════════════════════════════════════════════
; Vehicle used for gig work with hybrid personal/commercial characteristics

{@gig_vehicle}
= @vehicle                                 ; Inherit base vehicle fields

; ───────────────────────────────────────────────────────────────────────────────
; Gig-Specific Usage
; ───────────────────────────────────────────────────────────────────────────────
{.gig_usage}
gig_use_type = (both, delivery, rideshare)        ; Type of gig work performed with vehicle
personal_use_percent = ##:(0..100)                 ; Percent of miles for personal use
gig_use_percent = ##:(0..100)                      ; Percent of miles for gig work
avg_weekly_gig_miles = ##:(0..)                    ; Average weekly miles for gig work
avg_weekly_gig_hours = ##:(0..)                    ; Average weekly hours for gig work
annual_gig_miles = ##:(0..)                        ; Annual miles for gig work

{@gig_vehicle}
{.gig_usage}
; Platform approvals
approved_platforms[] = :                           ; Platforms this vehicle is approved for
platform_vehicle_id[] = :                          ; Platform-assigned vehicle ID
meets_platform_requirements = ?                    ; Vehicle meets platform requirements

{@gig_vehicle}

; ───────────────────────────────────────────────────────────────────────────────
; Rideshare-Specific
; ───────────────────────────────────────────────────────────────────────────────
passenger_capacity = ##:(1..15)                    ; How many passengers can be carried
wheelchair_accessible = ?                          ; Vehicle is wheelchair accessible
car_seat_available = ?                             ; Car seat available for child passengers
luxury_tier_eligible = ?                           ; Uber Black, Lyft Lux, etc.
xl_tier_eligible = ?                               ; UberXL, Lyft XL

; ───────────────────────────────────────────────────────────────────────────────
; Delivery-Specific
; ───────────────────────────────────────────────────────────────────────────────
cargo_capacity_cubic_feet = ##:(0..1000)           ; Cargo capacity in cubic feet
insulated_bags = ?                                 ; Has insulated delivery bags
hot_bag = ?                                        ; Has hot bag for food delivery
cold_storage = ?                                   ; Has cold storage capability
catering_capable = ?                               ; Can handle large catering orders
max_delivery_weight_lbs = ##:(0..2000)             ; Maximum delivery weight in pounds

; ───────────────────────────────────────────────────────────────────────────────
; Telematics / App Integration
; ───────────────────────────────────────────────────────────────────────────────
{.telematics}
enrolled = ?                                       ; Enrolled in telematics program
provider = :                                       ; Telematics provider
device_type = (app_based, dongle, factory_installed, none)  ; Type of telematics device
app_integration = ?                                ; Integrates with gig platform apps
tracks_gig_vs_personal = ?                         ; Can distinguish gig vs personal miles

{@gig_vehicle}

; ───────────────────────────────────────────────────────────────────────────────
; Commercial Registration
; ───────────────────────────────────────────────────────────────────────────────
commercial_registration = ?                        ; Registered as commercial vehicle
livery_plates = ?                                  ; Has TLC/livery plates (NYC, etc.)
commercial_registration_number = :                 ; Commercial registration number
commercial_registration_state = :(2)               ; State of commercial registration
commercial_registration_expiration = date          ; Commercial registration expiration date

; ═══════════════════════════════════════════════════════════════════════════════
; PERIOD-BASED COVERAGE STRUCTURE
; ═══════════════════════════════════════════════════════════════════════════════
; Defines coverage that applies during specific TNC periods

{@gig_period_coverage}
id = :                                             ; Unique identifier for period coverage
period = (all_periods, period_0, period_1, period_2, period_3)  ; Which TNC period this coverage applies to

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Source
; ───────────────────────────────────────────────────────────────────────────────
coverage_source = (
    gap,                                   ; Gap coverage bridging personal/platform
    personal,                              ; Personal auto policy
    platform,                              ; Platform-provided
    rideshare_endorsement                  ; Rideshare endorsement on personal policy
)

; ───────────────────────────────────────────────────────────────────────────────
; Period 0 - App Off
; ───────────────────────────────────────────────────────────────────────────────
; Personal auto policy applies - no gig-specific coverage needed
{.period_0}
applies = ?:if period = period_0                   ; Coverage applies during period 0
coverage_source = "personal"                       ; Personal auto policy covers period 0
personal_policy_ref = :                            ; Reference to personal auto policy

{@gig_period_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Period 1 - App On, Waiting
; ───────────────────────────────────────────────────────────────────────────────
; Gap period where personal and platform coverage may not apply
{.period_1}
applies = ?:if period = period_1                   ; Coverage applies during period 1
; Personal policy status during period 1
personal_covers_period_1 = ?                       ; Does personal policy cover this period?
personal_excluded = ?                              ; Is commercial use excluded?
; Platform-provided coverage
platform_liability_per_person = #$:(0..)           ; Platform liability limit per person
platform_liability_per_accident = #$:(0..)         ; Platform liability limit per accident
platform_liability_pd = #$:(0..)                   ; Platform property damage limit
platform_provides_collision = ?                    ; Not provided during period 1
platform_provides_comprehensive = ?                ; Not provided during period 1
; Gap coverage needed
gap_coverage_required = ?                          ; Gap coverage is required
gap_coverage_ref = :                               ; Reference to gap coverage policy

{@gig_period_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Period 2 - Request Accepted, En Route to Pickup
; ───────────────────────────────────────────────────────────────────────────────
{.period_2}
applies = ?:if period = period_2                   ; Coverage applies during period 2
platform_liability_csl = #$:(0..)                  ; Platform combined single liability limit
platform_um_uim = #$:(0..)                         ; Platform UM/UIM limit
platform_collision = ?                             ; Platform provides collision coverage
platform_collision_deductible = #$:(0..)           ; Platform collision deductible
platform_comprehensive = ?                         ; Platform provides comprehensive coverage
platform_comprehensive_deductible = #$:(0..)       ; Platform comprehensive deductible

{@gig_period_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Period 3 - Passenger/Delivery in Vehicle
; ───────────────────────────────────────────────────────────────────────────────
{.period_3}
applies = ?:if period = period_3                   ; Coverage applies during period 3
platform_liability_csl = #$:(0..)                  ; Platform combined single liability limit
platform_um_uim = #$:(0..)                         ; Platform UM/UIM limit
platform_collision = ?                             ; Platform provides collision coverage
platform_collision_deductible = #$:(0..)           ; Platform collision deductible
platform_comprehensive = ?                         ; Platform provides comprehensive coverage
platform_comprehensive_deductible = #$:(0..)       ; Platform comprehensive deductible

{@gig_period_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; GIG LIABILITY COVERAGE
; ═══════════════════════════════════════════════════════════════════════════════
; Liability coverage extending the universal liability primitive

{@gig_liability_coverage}
= @liability_coverage                              ; Inherit from liability line

coverage_type_ref = "GIG_LIABILITY"                ; Reference to gig liability coverage type

; ───────────────────────────────────────────────────────────────────────────────
; Gig-Specific Liability Fields
; ───────────────────────────────────────────────────────────────────────────────
gig_type = (both, delivery, rideshare)             ; Type of gig work covered
applies_to_periods = (all, period_1, period_1_2_3, period_2_3)  ; Which TNC periods are covered

; Liability limits
{.limits}
bi_per_person = #$:(0..)                           ; Bodily injury limit per person
bi_per_accident = #$:(0..)                         ; Bodily injury limit per accident
pd_limit = #$:(0..)                                ; Property damage limit
combined_single_limit = #$:(0..)                   ; Combined single limit
use_csl = ?                                        ; Using CSL instead of split limits

{@gig_liability_coverage}

; UM/UIM
{.um_uim}
um_selected = ?                                    ; Uninsured motorist coverage selected
um_per_person = #$:(0..)                           ; UM limit per person
um_per_accident = #$:(0..)                         ; UM limit per accident
uim_selected = ?                                   ; Underinsured motorist coverage selected
uim_per_person = #$:(0..)                          ; UIM limit per person
uim_per_accident = #$:(0..)                        ; UIM limit per accident
stacked = ?                                        ; Stacked UM/UIM coverage

{@gig_liability_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; RIDESHARE-SPECIFIC COVERAGE
; ═══════════════════════════════════════════════════════════════════════════════
; Coverage specifically designed for rideshare (TNC) operations

{@gig_rideshare_coverage}
= @gig_liability_coverage                          ; Inherit from gig liability coverage

coverage_type_ref = "RIDESHARE"                    ; Reference to rideshare coverage type
gig_type = "rideshare"                             ; Rideshare gig type

; ───────────────────────────────────────────────────────────────────────────────
; Rideshare Endorsement (added to personal policy)
; ───────────────────────────────────────────────────────────────────────────────
endorsement_type = (
    blanket,                                       ; Covers all TNC platforms
    named_platform                                 ; Covers specific named platforms
)                                                  ; Type of endorsement
named_platforms[] = :                              ; List of covered platforms

; ───────────────────────────────────────────────────────────────────────────────
; Coverage by Period
; ───────────────────────────────────────────────────────────────────────────────
period_1_coverage = ?                              ; Extends coverage to period 1
period_2_coverage = ?                              ; Extends coverage to period 2
period_3_coverage = ?                              ; Extends coverage to period 3

; ───────────────────────────────────────────────────────────────────────────────
; Deductible Gap Coverage
; ───────────────────────────────────────────────────────────────────────────────
; Covers gap between personal and platform deductibles
deductible_gap = ?                                 ; Deductible gap coverage selected
deductible_gap_amount = #$:(0..)                   ; Covers up to this amount
; Example: Personal policy $500 ded, Platform $2,500 ded = $2,000 gap

; ───────────────────────────────────────────────────────────────────────────────
; Passenger Liability
; ───────────────────────────────────────────────────────────────────────────────
passenger_liability = ?                            ; Passenger liability coverage included
passenger_medical_payments = #$:(0..)              ; Medical payments limit for passengers

; ═══════════════════════════════════════════════════════════════════════════════
; DELIVERY-SPECIFIC COVERAGE
; ═══════════════════════════════════════════════════════════════════════════════
; Coverage specifically designed for delivery gig work

{@gig_delivery_coverage}
= @gig_liability_coverage                          ; Inherit from gig liability coverage

coverage_type_ref = "DELIVERY"                     ; Reference to delivery coverage type
gig_type = "delivery"                              ; Delivery gig type

; ───────────────────────────────────────────────────────────────────────────────
; Delivery Endorsement
; ───────────────────────────────────────────────────────────────────────────────
endorsement_type = (blanket, named_platform)       ; Type of delivery endorsement
named_platforms[] = :                              ; DoorDash, Uber Eats, Instacart, etc.

; ───────────────────────────────────────────────────────────────────────────────
; Delivery-Specific Coverage Options
; ───────────────────────────────────────────────────────────────────────────────
covers_food_delivery = ?                           ; Covers food delivery
covers_grocery_delivery = ?                        ; Covers grocery delivery
covers_package_delivery = ?                        ; Covers package delivery
covers_alcohol_delivery = ?                        ; May require additional coverage
covers_pharmacy_delivery = ?                       ; May have HIPAA implications

; ───────────────────────────────────────────────────────────────────────────────
; Cargo / Goods in Transit
; ───────────────────────────────────────────────────────────────────────────────
goods_in_transit = ?                               ; Goods in transit coverage included
goods_in_transit_limit = #$:(0..)                  ; Goods in transit coverage limit
goods_in_transit_deductible = #$:(0..)             ; Goods in transit deductible
spoilage_coverage = ?                              ; Coverage for spoiled food/goods
spoilage_limit = #$:(0..)                          ; Spoilage coverage limit

; ═══════════════════════════════════════════════════════════════════════════════
; OCCUPATIONAL ACCIDENT COVERAGE
; ═══════════════════════════════════════════════════════════════════════════════
; Worker injury coverage for 1099 independent contractors
; NOT workers compensation (which requires employee status)

{@gig_occupational_accident}
= @coverage                                        ; Inherit from universal coverage

coverage_type_ref = "OCC_ACCIDENT"                 ; Reference to occupational accident coverage type

; ───────────────────────────────────────────────────────────────────────────────
; Eligibility
; ───────────────────────────────────────────────────────────────────────────────
; OA coverage is for independent contractors, not employees
worker_classification = "independent_contractor"   ; Worker must be classified as independent contractor
platform_provided = ?                              ; Platform provides this coverage
voluntary = ?                                      ; Worker opted into coverage

; ───────────────────────────────────────────────────────────────────────────────
; Medical Expense Benefits
; ───────────────────────────────────────────────────────────────────────────────
{.medical}
limit = #$:(0..)                                   ; Maximum medical expense benefit
deductible = #$:(0..)                              ; Medical expense deductible
coinsurance_percent = ##:(0..100)                  ; Coinsurance percentage
covers_emergency = ?                               ; Covers emergency room treatment
covers_hospitalization = ?                         ; Covers hospitalization
covers_surgery = ?                                 ; Covers surgical procedures
covers_rehabilitation = ?                          ; Covers rehabilitation services
covers_prescription = ?                            ; Covers prescription medications

{@gig_occupational_accident}

; ───────────────────────────────────────────────────────────────────────────────
; Disability Benefits
; ───────────────────────────────────────────────────────────────────────────────
{.disability}
temporary_total = ?                                ; Temporary total disability coverage included
temporary_total_weekly = #$:(0..)                  ; Weekly benefit amount
temporary_total_max_weeks = ##:(0..520)            ; Maximum weeks payable
permanent_total = ?                                ; Permanent total disability coverage included
permanent_total_amount = #$:(0..)                  ; Permanent total disability benefit amount
permanent_partial = ?                              ; Permanent partial disability coverage included
elimination_period_days = ##:(0..90)               ; Waiting period before benefits

{@gig_occupational_accident}

; ───────────────────────────────────────────────────────────────────────────────
; Accidental Death & Dismemberment
; ───────────────────────────────────────────────────────────────────────────────
{.ad_d}
principal_sum = #$:(0..)                           ; Death benefit
dismemberment_schedule = ?                         ; Has schedule of dismemberment benefits
; Common schedule percentages
loss_of_life = ##:(0..100)                         ; Percent of principal sum
loss_of_two_limbs = ##:(0..100)                    ; Percent for loss of two limbs
loss_of_one_limb = ##:(0..100)                     ; Percent for loss of one limb
loss_of_sight_both = ##:(0..100)                   ; Percent for loss of sight in both eyes
loss_of_sight_one = ##:(0..100)                    ; Percent for loss of sight in one eye
loss_of_hearing = ##:(0..100)                      ; Percent for loss of hearing
loss_of_speech = ##:(0..100)                       ; Percent for loss of speech

{@gig_occupational_accident}

; ───────────────────────────────────────────────────────────────────────────────
; Survivor Benefits
; ───────────────────────────────────────────────────────────────────────────────
{.survivor}
benefit = #$:(0..)                                 ; Survivor benefit amount
funeral_expense = #$:(0..)                         ; Funeral expense benefit
education_benefit = #$:(0..)                       ; For dependent children

{@gig_occupational_accident}

; ═══════════════════════════════════════════════════════════════════════════════
; GIG EQUIPMENT COVERAGE
; ═══════════════════════════════════════════════════════════════════════════════
; Coverage for personal property used in gig work

{@gig_equipment_coverage}
= @coverage                                        ; Inherit from universal coverage

coverage_type_ref = "GIG_EQUIPMENT"                ; Reference to gig equipment coverage type

; ───────────────────────────────────────────────────────────────────────────────
; Covered Equipment
; ───────────────────────────────────────────────────────────────────────────────
{.equipment[]}
item_id = :                                        ; Unique item identifier
description = :                                    ; Description of equipment item
category = (
    bike_scooter,                                  ; E-bike, scooter for delivery
    car_accessories,                               ; Phone mounts, chargers, etc.
    communication,                                 ; Phone, tablet
    food_transport,                                ; Insulated bags, hot bags, coolers
    navigation,                                    ; GPS devices
    other,
    safety,                                        ; First aid kit, fire extinguisher
    signage                                        ; Branded signs, lights
)                                                  ; Category of equipment
purchase_date = date                               ; Date equipment was purchased
purchase_price = #$:(0..)                          ; Original purchase price
current_value = #$:(0..)                           ; Current actual cash value
replacement_cost = #$:(0..)                        ; Cost to replace with new

{@gig_equipment_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Limits
; ───────────────────────────────────────────────────────────────────────────────
total_limit = #$:(0..)                             ; Total coverage limit for all equipment
per_item_limit = #$:(0..)                          ; Maximum limit per individual item
deductible = #$:(0..)                              ; Deductible for equipment claims
valuation = (actual_cash_value, agreed_value, replacement_cost)  ; Valuation method

; Covered perils
covers_theft = ?                                   ; Covers theft of equipment
covers_damage = ?                                  ; Covers physical damage
covers_fire = ?                                    ; Covers fire damage
covers_water = ?                                   ; Covers water damage
covers_electrical = ?                              ; Covers electrical damage

; ═══════════════════════════════════════════════════════════════════════════════
; GIG GAP COVERAGE
; ═══════════════════════════════════════════════════════════════════════════════
; Coverage that bridges gaps between personal and platform coverage

{@gig_gap_coverage}
= @coverage                                        ; Inherit from universal coverage

coverage_type_ref = "GIG_GAP"                      ; Reference to gig gap coverage type

; ───────────────────────────────────────────────────────────────────────────────
; Gap Types
; ───────────────────────────────────────────────────────────────────────────────
gap_type = (
    deductible_gap,                                ; Covers platform deductible vs personal
    full_gap,                                      ; Comprehensive gap coverage
    liability_gap,                                 ; Enhanced liability during period 1
    physical_damage_gap                            ; Comp/coll during period 1
)                                                  ; Type of gap coverage

; ───────────────────────────────────────────────────────────────────────────────
; Period 1 Gap Coverage
; ───────────────────────────────────────────────────────────────────────────────
; Period 1 coverage gap between personal and platform insurance
{.period_1_gap}
liability_bi_per_person = #$:(0..)                 ; Supplements platform coverage
liability_bi_per_accident = #$:(0..)               ; Supplements platform coverage
liability_pd = #$:(0..)                            ; Supplements platform coverage
collision = ?                                      ; Platform does not provide during period 1
collision_deductible = #$:(0..)                    ; Collision deductible for period 1
comprehensive = ?                                  ; Comprehensive coverage for period 1
comprehensive_deductible = #$:(0..)                ; Comprehensive deductible for period 1

{@gig_gap_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Deductible Gap Coverage
; ───────────────────────────────────────────────────────────────────────────────
; Covers difference between personal policy deductible and platform deductible
{.deductible_gap}
max_gap_amount = #$:(0..)                          ; Maximum gap to cover (e.g., $2,000)
personal_policy_deductible = #$:(0..)              ; Your personal policy deductible
platform_deductible = #$:(0..)                     ; Platform's deductible

{@gig_gap_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; INCOME PROTECTION / DEACTIVATION COVERAGE
; ═══════════════════════════════════════════════════════════════════════════════
; Coverage for income loss due to platform deactivation or inability to work

{@gig_income_protection}
= @coverage                                        ; Inherit from universal coverage

coverage_type_ref = "GIG_INCOME"                   ; Reference to gig income protection coverage type

; ───────────────────────────────────────────────────────────────────────────────
; Income Verification
; ───────────────────────────────────────────────────────────────────────────────
avg_weekly_gig_income = #$:(0..)                   ; Average weekly income from gig work
avg_monthly_gig_income = #$:(0..)                  ; Average monthly income from gig work
income_verification_method = (
    bank_statements,
    platform_reports,
    self_reported,
    tax_returns
)                                                  ; Method used to verify income
income_verified = ?                                ; Income has been verified
income_verification_date = date                    ; Date income was verified

; ───────────────────────────────────────────────────────────────────────────────
; Deactivation Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.deactivation}
covered = ?                                        ; Deactivation coverage included
covered_reasons = (
    accident_related,                              ; Deactivated due to accident
    appeal_pending,                                ; While appealing deactivation
    background_recheck,                            ; Background check issues
    false_claim,                                   ; Wrongful deactivation
    rating_drop,                                   ; Rating dropped below threshold
    vehicle_issue                                  ; Vehicle no longer qualifies
)                                                  ; Reasons covered for deactivation
excluded_reasons = (
    criminal_activity,
    fraud,
    intentional_misconduct,
    voluntary_departure
)                                                  ; Reasons excluded from deactivation coverage
benefit_period_weeks = ##:(0..52)                  ; How long benefits last
weekly_benefit = #$:(0..)                          ; Weekly benefit amount
waiting_period_days = ##:(0..30)                   ; Waiting period before benefits begin

{@gig_income_protection}

; ───────────────────────────────────────────────────────────────────────────────
; Vehicle Downtime Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.vehicle_downtime}
covered = ?                                        ; Vehicle downtime coverage included
daily_benefit = #$:(0..)                           ; Daily income replacement
max_days = ##:(0..90)                              ; Maximum days covered
covered_causes = (
    accident_repair,
    mechanical_failure,
    stolen_vehicle,
    total_loss
)                                                  ; Causes of vehicle downtime covered

{@gig_income_protection}

; ═══════════════════════════════════════════════════════════════════════════════
; GIG POLICY
; ═══════════════════════════════════════════════════════════════════════════════
; Main policy wrapper for gig economy coverage

{@gig_policy}
id = :                                             ; Unique policy identifier
number = :                                        ; Policy number

; ───────────────────────────────────────────────────────────────────────────────
; Policy Term
; ───────────────────────────────────────────────────────────────────────────────
effective_date = date                              ; Policy effective date
effective_time = time                              ; Policy effective time
expiration_date = date                             ; Policy expiration date
expiration_time = time                             ; Policy expiration time
:invariant expiration_date > effective_date        ; Expiration must be after effective date

status = (active, cancelled, expired, pending, reinstated, suspended)  ; Policy status
type = (
    endorsement,                                   ; Endorsement to existing personal auto
    hybrid,                                        ; Combined personal + gig policy
    standalone                                     ; Standalone gig policy
)                                                  ; Type of gig policy

; ───────────────────────────────────────────────────────────────────────────────
; Named Insured (Gig Worker)
; ───────────────────────────────────────────────────────────────────────────────
worker = @gig_worker                               ; Reference to gig worker (named insured)

; ───────────────────────────────────────────────────────────────────────────────
; Covered Vehicles
; ───────────────────────────────────────────────────────────────────────────────
vehicles[] = @gig_vehicle                          ; List of covered vehicles

; ───────────────────────────────────────────────────────────────────────────────
; Covered Platforms
; ───────────────────────────────────────────────────────────────────────────────
platforms[] = @gig_platform                        ; List of platforms
platform_coverage = (all, named)                   ; All platforms or only named
named_platforms[] = :                              ; Specific platforms covered

; ───────────────────────────────────────────────────────────────────────────────
; Coverages
; ───────────────────────────────────────────────────────────────────────────────
rideshare_coverage = @gig_rideshare_coverage       ; Rideshare coverage details
delivery_coverage = @gig_delivery_coverage         ; Delivery coverage details
occupational_accident = @gig_occupational_accident  ; Occupational accident coverage details
equipment_coverage = @gig_equipment_coverage       ; Equipment coverage details
gap_coverage = @gig_gap_coverage                   ; Gap coverage details
income_protection = @gig_income_protection         ; Income protection coverage details

; ───────────────────────────────────────────────────────────────────────────────
; Period Coverage Matrix
; ───────────────────────────────────────────────────────────────────────────────
period_coverages[] = @gig_period_coverage          ; Coverage by TNC period

; ───────────────────────────────────────────────────────────────────────────────
; Personal Auto Policy Reference
; ───────────────────────────────────────────────────────────────────────────────
; Required for most gig coverage
{.personal_policy}
required = ?                                       ; Personal policy is required
policy_number = :                                  ; Personal policy number
carrier = :                                        ; Personal policy carrier name
effective_date = date                              ; Personal policy effective date
expiration_date = date                             ; Personal policy expiration date
liability_limits = :                               ; e.g., "100/300/100"
comp_coll = ?                                      ; Personal policy has comp/coll
comp_deductible = #$:(0..)                         ; Personal policy comprehensive deductible
coll_deductible = #$:(0..)                         ; Personal policy collision deductible
rideshare_endorsement = ?                          ; Has TNC endorsement on personal policy
delivery_endorsement = ?                           ; Has delivery endorsement on personal policy

{@gig_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
total = #$:(0..)                                   ; Total premium amount
basis = (annual, monthly, per_mile, per_trip, term)  ; Premium basis
; Usage-based pricing
per_mile_rate = #$:(0..9.99)                       ; Rate per mile
per_trip_rate = #$:(0..99.99)                      ; Rate per trip
per_delivery_rate = #$:(0..99.99)                  ; Rate per delivery
base_premium = #$:(0..)                            ; Base premium amount
usage_premium = #$:(0..)                           ; Usage-based premium amount

{@gig_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Billing
; ───────────────────────────────────────────────────────────────────────────────
{.billing}
method = (ach, card, payroll_deduction, platform_deduction)  ; Billing payment method
frequency = (annual, monthly, per_use, semi_annual)  ; Billing frequency
platform_integration = ?                           ; Deducted directly by platform

{@gig_policy}

; ═══════════════════════════════════════════════════════════════════════════════
; GIG CLAIM
; ═══════════════════════════════════════════════════════════════════════════════
; Claim with gig-specific context (period, platform, activity type)

{@gig_claim}
id = :                                             ; Unique claim identifier
number = :                                        ; Claim number
policy_ref = :                                     ; Reference to @gig_policy

; ───────────────────────────────────────────────────────────────────────────────
; Loss Details
; ───────────────────────────────────────────────────────────────────────────────
loss_date = date                                   ; Date of loss
loss_time = time                                   ; Time of loss
reported_date = date                               ; Date claim was reported
loss_description = :                               ; Description of the loss

; ───────────────────────────────────────────────────────────────────────────────
; Gig Context at Time of Loss
; ───────────────────────────────────────────────────────────────────────────────
gig_period = (period_0, period_1, period_2, period_3)  ; TNC period at time of loss
gig_activity = (
    app_off,                                       ; Period 0 - not working
    delivery_dropoff,                              ; Dropping off delivery
    delivery_pickup,                               ; Picking up delivery
    delivery_transit,                              ; En route with delivery
    passenger_dropoff,                             ; Dropping off passenger
    passenger_pickup,                              ; Picking up passenger
    passenger_transit,                             ; Passenger in vehicle
    waiting                                        ; App on, waiting for request
)                                                  ; Activity at time of loss
platform_at_loss = :                               ; Which platform was active
multiple_platforms_active = ?                      ; Multiple apps running
trip_id = :                                        ; Platform trip/delivery ID
passenger_count = ##                               ; Passengers at time of loss
delivery_contents = :                              ; What was being delivered

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Determination
; ───────────────────────────────────────────────────────────────────────────────
primary_coverage = (gap, personal, platform, rideshare_endorsement)  ; Primary coverage source
platform_claim_filed = ?                           ; Claim filed with platform insurance
platform_claim_number = :                          ; Platform claim number
personal_claim_filed = ?                           ; Claim filed with personal auto insurance
personal_claim_number = :                          ; Personal auto claim number

; Platform coverage response
platform_accepted = ?                              ; Platform accepted the claim
platform_denied_reason = :                         ; Reason platform denied claim

; ───────────────────────────────────────────────────────────────────────────────
; Claim Status
; ───────────────────────────────────────────────────────────────────────────────
status = (
    closed_denied,
    closed_paid,
    closed_withdrawn,
    investigation,
    litigation,
    open,
    pending_platform,
    subrogation
)                                                  ; Claim status

; ───────────────────────────────────────────────────────────────────────────────
; Amounts
; ───────────────────────────────────────────────────────────────────────────────
{.amounts}
total_incurred = #$:(0..)                          ; Total incurred amount
paid_loss = #$:(0..)                               ; Loss payments made
paid_expense = #$:(0..)                            ; Expense payments made
reserve_loss = #$:(0..)                            ; Loss reserves
reserve_expense = #$:(0..)                         ; Expense reserves
; Platform contribution
platform_paid = #$:(0..)                           ; Amount paid by platform
; Personal policy contribution
personal_policy_paid = #$:(0..)                    ; Amount paid by personal policy
; Gap policy contribution
gap_policy_paid = #$:(0..)                         ; Amount paid by gap policy
; Deductible
deductible_applied = #$:(0..)                      ; Deductible amount applied
deductible_waived = ?                              ; Deductible was waived
deductible_waived_reason = :                       ; Reason deductible was waived

{@gig_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Bodily Injury Details
; ───────────────────────────────────────────────────────────────────────────────
{.bodily_injury[]}
injured_party = (driver, other_driver, passenger, pedestrian, third_party)  ; Who was injured
injury_description = :                             ; Description of injury
treatment_status = (completed, none, ongoing, pending)  ; Status of medical treatment
medical_expense = #$:(0..)                         ; Medical expenses incurred
lost_wages = #$:(0..)                              ; Lost wages due to injury

{@gig_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Property Damage Details
; ───────────────────────────────────────────────────────────────────────────────
{.property_damage[]}
damaged_property = (
    cargo,                                         ; Delivered goods
    equipment,                                     ; Gig equipment
    insured_vehicle,
    other_property,
    other_vehicle
)                                                  ; Type of property damaged
damage_description = :                             ; Description of damage
repair_estimate = #$:(0..)                         ; Estimated repair cost
actual_repair_cost = #$:(0..)                      ; Actual repair cost
total_loss = ?                                     ; Vehicle/property is a total loss

{@gig_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Subrogation
; ───────────────────────────────────────────────────────────────────────────────
{.subrogation}
potential = ?                                      ; Subrogation potential exists
against = (other_driver, platform, third_party)    ; Party against whom subrogation is pursued
amount_sought = #$:(0..)                           ; Amount sought in subrogation
amount_recovered = #$:(0..)                        ; Amount recovered through subrogation

{@gig_claim}

; ═══════════════════════════════════════════════════════════════════════════════
; STATE-SPECIFIC EXTENSIONS
; ═══════════════════════════════════════════════════════════════════════════════
; State-specific minimum coverage requirements for TNCs

{@&gov.ca.cpuc.tnc_minimums}
; California TNC minimum requirements per CPUC
period_1_bi_per_person = #$:(0..) #$50000          ; Period 1 BI per person minimum
period_1_bi_per_accident = #$:(0..) #$100000       ; Period 1 BI per accident minimum
period_1_pd = #$:(0..) #$30000                     ; Period 1 property damage minimum
period_2_3_csl = #$:(0..) #$1000000                ; Period 2-3 combined single limit
period_2_3_um_uim = #$:(0..) #$1000000             ; Period 2-3 UM/UIM minimum

{@&gov.tx.tdlr.tnc_minimums}
; Texas TNC minimum requirements
period_1_bi_per_person = #$:(0..) #$50000          ; Period 1 BI per person minimum
period_1_bi_per_accident = #$:(0..) #$100000       ; Period 1 BI per accident minimum
period_1_pd = #$:(0..) #$25000                     ; Period 1 property damage minimum
period_2_3_csl = #$:(0..) #$1000000                ; Period 2-3 combined single limit

{@&gov.ny.dfs.tnc_minimums}
; New York TNC minimum requirements (higher for NYC)
period_1_bi_per_person = #$:(0..) #$75000          ; Period 1 BI per person minimum
period_1_bi_per_accident = #$:(0..) #$150000       ; Period 1 BI per accident minimum
period_1_pd = #$:(0..) #$25000                     ; Period 1 property damage minimum
period_2_3_csl = #$:(0..) #$1250000                ; Period 2-3 combined single limit

{@&gov.az.dot.tnc_minimums}
; Arizona TNC minimum requirements (per HB 2729)
period_1_bi_per_person = #$:(0..) #$25000          ; Period 1 BI per person minimum
period_1_bi_per_accident = #$:(0..) #$50000        ; Period 1 BI per accident minimum
period_1_pd = #$:(0..) #$20000                     ; Period 1 property damage minimum
period_2_3_csl = #$:(0..) #$1000000                ; Period 2-3 combined single limit


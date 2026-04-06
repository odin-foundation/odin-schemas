; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Commercial Auto Driver Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Commercial auto driver extending the base driver schema with CDL requirements,
; DOT physical/medical certification, Driver Qualification File (DQ File) per
; 49 CFR Part 391, FMCSA Clearinghouse, and owner-operator details.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/auto/driver.schema.odin" as core

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.auto.driver"
version = "1.0.0"
title = "Commercial Auto Driver Schema"
description = "Commercial driver definitions extending base auto driver"

{$derivation}
source[0].authority = "Federal Motor Carrier Safety Administration"
source[0].citation = "49 CFR Part 391 - Qualifications of Drivers"
source[0].url = "https://www.ecfr.gov/current/title-49/subtitle-B/chapter-III/subchapter-B/part-391"

source[1].authority = "Federal Motor Carrier Safety Administration"
source[1].citation = "49 CFR Part 382 - Controlled Substances and Alcohol Use and Testing"
source[1].url = "https://www.ecfr.gov/current/title-49/subtitle-B/chapter-III/subchapter-B/part-382"

source[2].authority = "Federal Motor Carrier Safety Administration"
source[2].citation = "FMCSA Drug & Alcohol Clearinghouse"
source[2].url = "https://clearinghouse.fmcsa.dot.gov/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "DOT/FMCSA driver qualification requirements per federal regulations"

changelog[0].date = 2025-12-13
changelog[0].change = "Initial commercial driver schema"
changelog[0].rationale = "FMCSA driver qualification requirements for commercial motor vehicles"

; ═══════════════════════════════════════════════════════════════════════════════
; Commercial Driver (Extends Driver Core)
; ═══════════════════════════════════════════════════════════════════════════════

{@commercial_driver}
= @core.driver                                ; Inherit all base driver fields

; ───────────────────────────────────────────────────────────────────────────────
; CDL (Commercial Driver's License)
; ───────────────────────────────────────────────────────────────────────────────
{.cdl}
class = !(A, B, C)                             ; A=combination, B=heavy single, C=small vehicle
expiration = date                              ; CDL expiration date
hazmat_expiration = date                       ; Hazmat endorsement expiration
number = :                                     ; CDL license number
original_date = date                           ; Date first CDL issued
state_province = :(2)                          ; US state or Canadian province
status = (disqualified, downgraded, expired, revoked, suspended, valid)

{@commercial_driver}

; CDL Endorsements (per 49 CFR 383.93)
{.cdl}
endorsements[] = (
    H,                                         ; Hazardous Materials
    N,                                         ; Tank Vehicle
    P,                                         ; Passenger
    S,                                         ; School Bus
    T,                                         ; Double/Triple Trailers
    X                                          ; Combination of Tank + Hazmat
)

; CDL Restrictions (per 49 CFR 383.95)
restrictions[] = (
    E,                                         ; No Manual Transmission CMV
    K,                                         ; Intrastate Only
    L,                                         ; No Air Brake CMV
    M,                                         ; No Class A Passenger Vehicle
    N,                                         ; No Class A or B Passenger Vehicle
    O,                                         ; No Tractor-Trailer CMV
    V,                                         ; Medical Variance
    Z                                          ; No Full Air Brake CMV
)

; CDL History
months_cdl = ##
previously_held_cdl = ?
prior_cdl_number = :
prior_cdl_state_province = :(2)                ; US state or Canadian province
years_cdl = ##

{@commercial_driver}

; ───────────────────────────────────────────────────────────────────────────────
; DOT Physical / Medical Certificate (per 49 CFR 391.41-391.49)
; ───────────────────────────────────────────────────────────────────────────────
{.medical}
card_date = date                               ; Date of examination
card_duration = (1_year, 2_years, 3_months, 6_months)  ; Certificate duration
card_expiration = date                         ; Certificate expiration date
card_status = (exemption, expired, pending, valid, waiver)  ; Current status

; Medical Examiner
examination_location = :
examiner_license_number = *:                   ; Confidential
examiner_license_state_province = :(2)         ; US state or Canadian province
examiner_name = :
examiner_national_registry_number = :          ; National Registry number

; Medical Qualifications
qualified = ?
qualified_with_restrictions = ?
restrictions[] = :                             ; Corrective lenses, hearing aid, etc.

; Medical Waivers/Exemptions
diabetes_exemption = ?
diabetes_exemption_expiration = date
hearing_exemption = ?
hearing_exemption_expiration = date
skill_performance_evaluation = ?               ; SPE certificate for limb impairment
spe_expiration = date
vision_waiver = ?
vision_waiver_expiration = date

; Physical Conditions (affects insurability)
heart_condition = ?
insulin_dependent = ?
seizure_history = ?
sleep_apnea = ?
sleep_apnea_treated = ?

{@commercial_driver}

; ───────────────────────────────────────────────────────────────────────────────
; Driver Qualification File (DQ File) per 49 CFR Part 391
; ───────────────────────────────────────────────────────────────────────────────
{.dq_file}
last_review = date
status = (complete, expired, incomplete, pending)

; Application (49 CFR 391.21)
application_date = date
application_on_file = ?

; Road Test (49 CFR 391.31)
road_test_date = date
road_test_examiner = :
road_test_passed = ?
road_test_vehicle_type = :
road_test_waived = ?                           ; CDL in lieu of road test

; Annual Review of Driving Record (49 CFR 391.25)
annual_review_by = :
annual_review_certified = ?
annual_review_date = date
annual_review_due = date

; Annual Inquiry to Previous Employers (49 CFR 391.23)
employer_inquiry_complete = ?
employer_inquiry_date = date

{@commercial_driver}

; ───────────────────────────────────────────────────────────────────────────────
; Drug & Alcohol Testing (per 49 CFR Part 382)
; ───────────────────────────────────────────────────────────────────────────────
{.drug_alcohol}
consortium = :                                 ; Testing consortium name
consortium_id = :                              ; Consortium ID

; Pre-Employment
pre_employment_date = date
pre_employment_result = (negative, not_completed, positive)

; Random Testing
last_random_date = date
random_pool = ?                                ; In random testing pool

; Testing History
follow_up_end_date = date
follow_up_testing = ?
positive_test_date = date
positive_test_ever = ?
refusal_date = date
refusal_ever = ?
return_to_duty_complete = ?
return_to_duty_date = date

; SAP (Substance Abuse Professional)
sap_evaluation = ?
sap_evaluation_date = date
sap_name = :

{@commercial_driver}

; ───────────────────────────────────────────────────────────────────────────────
; FMCSA Clearinghouse (per 49 CFR Part 382 Subpart G)
; ───────────────────────────────────────────────────────────────────────────────
{.clearinghouse}
consent_date = date
consent_on_file = ?
registered = ?
registration_date = date

; Pre-Employment Query
pre_employment_query_date = date
pre_employment_query_result = (clear, not_clear, pending)

; Annual Query
annual_query_date = date
annual_query_due = date
annual_query_result = (clear, not_clear, pending)

; Violations in Clearinghouse
violations = ?
prohibited_status = ?                          ; Currently prohibited from safety-sensitive functions
violation_date = date:if clearinghouse.violations = true
violation_type = (
    actual_knowledge,
    positive_test,
    refusal_to_test,
    return_to_duty_not_complete
):if clearinghouse.violations = true

{@commercial_driver}

; ───────────────────────────────────────────────────────────────────────────────
; PSP (Pre-Employment Screening Program) Report
; ───────────────────────────────────────────────────────────────────────────────
{.psp}
consent_date = date
consent_on_file = ?
report_date = date

; 5-Year Crash History
crash_count_5_year = ##                        ; Total crashes in 5 years
crashes_fatal = ##                             ; Fatal crashes
crashes_injury = ##                            ; Injury crashes
crashes_tow_away = ##                          ; Tow-away crashes

; 3-Year Inspection History
driver_violation_count_3_year = ##             ; Driver violations in 3 years
inspection_count_3_year = ##                   ; Total inspections in 3 years
out_of_service_driver_count = ##               ; Driver OOS violations
out_of_service_vehicle_count = ##              ; Vehicle OOS violations
vehicle_violation_count_3_year = ##            ; Vehicle violations in 3 years

{@commercial_driver}

; ───────────────────────────────────────────────────────────────────────────────
; Commercial Driving Experience
; ───────────────────────────────────────────────────────────────────────────────
{.experience}
miles_last_year = ##
months_commercial = ##
total_miles = ##
years_commercial = ##

; Vehicle Types Operated
bus = ?
bus_years = ##
doubles_triples = ?
doubles_triples_years = ##
flatbed = ?
flatbed_years = ##
hazmat = ?
hazmat_years = ##
oversized = ?
oversized_years = ##
straight_truck = ?
straight_truck_years = ##
tanker = ?
tanker_years = ##
tractor_trailer = ?
tractor_trailer_years = ##

; Cargo Types Hauled
cargo_types[] = (
    auto_transport,
    construction,
    flatbed,
    general_freight,
    hazmat,
    household_goods,
    intermodal,
    livestock,
    logging,
    other,
    oversized,
    refrigerated,
    tanker_dry_bulk,
    tanker_liquid
)

{@commercial_driver}

; ───────────────────────────────────────────────────────────────────────────────
; Employment History (49 CFR 391.21 - 10 years commercial)
; ───────────────────────────────────────────────────────────────────────────────
; Embedded array for previous employers

{@commercial_driver.employment_history[]}
employer_sequence = ##:(1..)                   ; Employment history sequence number
employer_name = !:                             ; Employer company name

; Employer Address - uses shared @address type
employer_address = @address                    ; Employer location

{@commercial_driver.employment_history[]}
employer_phone = *@phone                       ; Employer phone number (confidential)
employer_dot_number = :                        ; Employer DOT number (7-8 digits)

position_held = :
effective = !date
expiration = date
months_employed = ##
reason_for_leaving = :

; Driving Position Details
was_driving_position = ?
cdl_position = ?
equipment_type = :
states_driven = :

; Safety Sensitive Functions
subject_to_dot_testing = ?                     ; Subject to DOT drug/alcohol testing
any_accidents = ?                              ; Had accidents during employment
accident_count = ##                            ; Number of accidents
any_violations = ?                             ; Had violations during employment
violation_count = ##                           ; Number of violations

; Employer Contact for Verification
contact_name = :
contact_phone = *@phone                        ; Confidential
verification_date = date
verification_status = (discrepancy, pending, unable_to_verify, verified)

{@commercial_driver}

; ───────────────────────────────────────────────────────────────────────────────
; Training & Certifications
; ───────────────────────────────────────────────────────────────────────────────
; Entry Level Driver Training (ELDT) per 49 CFR Part 380
{.eldt}
btw_provider = :
btw_provider_tpr_number = :
btw_training_complete = ?                      ; Behind-the-wheel
btw_training_date = date
range_training_complete = ?
range_training_date = date
theory_provider = :
theory_provider_tpr_number = :                 ; Training Provider Registry number
theory_training_complete = ?
theory_training_date = date

{@commercial_driver}
; Hazmat Training (49 CFR 172.704)
{.training}
hazmat_function_specific = ?
hazmat_general = ?
hazmat_general_date = date
hazmat_general_expiration = date               ; Every 3 years
hazmat_in_depth_security = ?
hazmat_security = ?

; Tanker Training
tanker_rollover_prevention = ?
tanker_training_date = date

; Passenger Endorsement Training
passenger_emergency = ?
passenger_post_trip = ?
passenger_pre_trip = ?

; Security Training (TSA)
tsa_background_date = date
tsa_background_expiration = date               ; Every 5 years
tsa_hazmat_background = ?

{@commercial_driver}

; ───────────────────────────────────────────────────────────────────────────────
; Hours of Service Compliance
; ───────────────────────────────────────────────────────────────────────────────
{.hos}
eld_exempt = ?
eld_exempt_reason = (drive_away, pre_2000_engine, short_haul):if hos.eld_exempt = true
log_type = (aobrd, eld, paper)                 ; AOBRD grandfathered

; Violations (rating relevant)
out_of_service_order_count = ##                ; OOS order count
violation_count_last_3_years = ##              ; Violations in last 3 years
violation_count_last_year = ##                 ; Violations in last year

{@commercial_driver}
; ───────────────────────────────────────────────────────────────────────────────
; Owner-Operator Specific
; ───────────────────────────────────────────────────────────────────────────────
owner_operator = ?                             ; Is an owner-operator

; ───────────────────────────────────────────────────────────────────────────────
; Fleet Assignment
; ───────────────────────────────────────────────────────────────────────────────
{.fleet}
name = :
number = :

{@commercial_driver}
assigned_power_units[] = :                     ; Assigned vehicle IDs
terminal_name = :
terminal_number = ##:(1..)

; ───────────────────────────────────────────────────────────────────────────────
; Rating Factors (Commercial-Specific)
; ───────────────────────────────────────────────────────────────────────────────
{.rating}
commercial_class = :
experience_factor = #
hazmat_factor = #
violation_factor = #

{@commercial_driver}
; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, disqualified, inactive, on_leave, terminated)
hire_date = date
termination_date = date
termination_reason = :

; ═══════════════════════════════════════════════════════════════════════════════
; Owner-Operator (Specialized Type)
; ═══════════════════════════════════════════════════════════════════════════════
; Owner-operators who lease equipment to carriers

{@owner_operator}
= @commercial_driver                          ; Inherit all commercial driver fields

id = :                                         ; Operator identifier

; Operating Authority
{.authority}
dot_number = :                                 ; DOT number (7-8 digits)
mc_number = :                                  ; MC number
status = (active, inactive, pending)
type = (independent, leased, owner_operator)

{@owner_operator}
; Lease Agreement
{.lease}
auto_renewal = ?
carrier_dot = :                                ; Carrier DOT number (7-8 digits)
carrier_name = :
effective_date = date
expiration_date = date
lease_type = (exclusive, non_exclusive)

{@owner_operator}
; Equipment Provided
{.equipment}
insurance_type = (bobtail, non_trucking, occupational_accident, physical_damage)
power_unit_count = ##:(0..)
provides_insurance = ?
trailer_count = ##:(0..)

{@owner_operator}
; Settlement
{.settlement}
detention_pay = ?
flat_rate = #$
fuel_surcharge = ?
mileage_rate = #$
pay_type = (combination, flat_rate, mileage, percentage)
percentage = ##:(0..100)

{@owner_operator}
; Insurance Requirements
{.insurance}
cargo_minimum = ##
cargo_required = ?
minimum_liability = ##
occupational_accident = ?
physical_damage_required = ?

{@owner_operator}

; ═══════════════════════════════════════════════════════════════════════════════
; Commercial Driver Summary (Compact Reference)
; ═══════════════════════════════════════════════════════════════════════════════

{@commercial_driver_summary}
id = :                                         ; Driver identifier
number = ##:(1..)                              ; Number

{.name}
first = :
last = :

{@commercial_driver_summary}
date_of_birth = *date                          ; Confidential

{.cdl}
class = (A, B, C)
endorsements[] = (H, N, P, S, T, X)
state_province = :(2)                          ; US state or Canadian province
status = (disqualified, expired, revoked, suspended, valid)

{@commercial_driver_summary}
{.medical}
card_expiration = date
card_status = (expired, pending, valid)

{@commercial_driver_summary}
{.clearinghouse}
prohibited_status = ?

{@commercial_driver_summary}
{.experience}
years_commercial = ##                          ; Years of commercial experience

{@commercial_driver_summary}
accident_count = ##                            ; Total accident count
status = (active, disqualified, inactive, terminated)  ; Driver status
violation_count = ##                           ; Total violation count

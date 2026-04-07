; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Travel Insurance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Travel insurance covering trip cancellation/interruption, emergency medical,
; medical evacuation, baggage loss/delay, travel delay, and cancel for any
; reason (CFAR) for domestic and international travel.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../coverages/coverage.schema.odin" as cov
@import "../../common/party.schema.odin" as party

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.travel"
version = "1.0.0"
title = "Travel Insurance Schema"
description = "Comprehensive travel insurance policy schema for personal travel protection"

{$derivation}
source[0].authority = "U.S. Travel Insurance Association"
source[0].citation = "Travel Insurance Consumer Resources"
source[0].url = "https://www.ustia.org/"

source[1].authority = "State Insurance Departments"
source[1].citation = "Travel Insurance Regulatory Requirements"
source[1].url = "https://content.naic.org/state-insurance-departments"

source[2].authority = "National Association of Insurance Commissioners (NAIC)"
source[2].citation = "Travel Insurance Model Act"
source[2].url = "https://content.naic.org/"

source[3].authority = "Centers for Disease Control and Prevention"
source[3].citation = "CDC Yellow Book - Travel Insurance Guidance"
source[3].url = "https://www.cdc.gov/yellow-book/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Travel insurance schema derived from public regulatory sources and industry practices"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial travel insurance schema"
changelog[0].rationale = "Coverage-centric architecture for travel insurance products"

; ═══════════════════════════════════════════════════════════════════════════════
; TRAVELER
; ═══════════════════════════════════════════════════════════════════════════════
; Individual covered under the travel insurance policy

{@traveler}
= @person                                      ; Inherits person fields (name, dob, contact, address)

id = :                                         ; Unique identifier for the traveler
traveler_number = ##:(1..)                     ; Sequential traveler number

; ───────────────────────────────────────────────────────────────────────────────
; Override required name fields
; ───────────────────────────────────────────────────────────────────────────────
{.name}
first = !:                                     ; First/given name (required)
last = !:                                      ; Last/family name (required)

{@traveler}

; Travel-specific demographics
age = ##:(0..120)                              ; Current age in years

; ───────────────────────────────────────────────────────────────────────────────
; Emergency Contact (travel-specific)
; ───────────────────────────────────────────────────────────────────────────────
phone.emergency = *@phone                      ; Emergency contact phone (confidential)

{@traveler}

; ───────────────────────────────────────────────────────────────────────────────
; Travel Documents
; ───────────────────────────────────────────────────────────────────────────────
passport_number = *:                           ; Passport number (confidential)
passport_country = :(2..3)                     ; Country of passport issuance (ISO code)
passport_expiration = date                     ; Passport expiration date


; ───────────────────────────────────────────────────────────────────────────────
; Traveler Classification
; ───────────────────────────────────────────────────────────────────────────────
traveler_type = (companion, dependent_child, other_family, primary, spouse_partner) ; Type/role of this traveler
relationship_to_primary = :                    ; Relationship to the primary insured
primary_insured = ?                            ; Is this the primary insured

; ───────────────────────────────────────────────────────────────────────────────
; Health Information (for underwriting)
; ───────────────────────────────────────────────────════════════════════════════
primary_health_insurance = ?                   ; Has primary health insurance coverage
primary_health_carrier = :                     ; Name of primary health insurance carrier
pre_existing_conditions = ?                    ; Has known pre-existing medical conditions
pre_existing_condition_details = *:            ; Description of pre-existing conditions (confidential)

medically_able_to_travel = ?                   ; Medically cleared to travel
medically_able_date = date                     ; Date of medical clearance

; ───────────────────────────────────────────────────────────────────────────────
; Emergency Contact
; ───────────────────────────────────────────────────────────────────────────────
{.emergency_contact}
name = :                                       ; Emergency contact full name
relationship = :                               ; Relationship to traveler
phone = *@phone                                ; Emergency contact phone (confidential)
email = *@email                                ; Emergency contact email (confidential)

{@traveler}

; ═══════════════════════════════════════════════════════════════════════════════
; TRIP
; ═══════════════════════════════════════════════════════════════════════════════
; Trip details including dates, destinations, and costs

{@trip}
id = :                                         ; Unique identifier for the trip
trip_number = ##:(1..)                         ; Sequential trip number

; ───────────────────────────────────────────────────────────────────────────────
; Trip Dates
; ───────────────────────────────────────────────────────────────────────────────
departure_date = date                          ; Trip departure date
return_date = date                             ; Trip return date
trip_duration_days = ##:(1..365)               ; Total duration of trip in days
:invariant return_date >= departure_date

; ───────────────────────────────────────────────────────────────────────────────
; Booking Information
; ───────────────────────────────────────────────────────────────────────────────
initial_deposit_date = date                    ; Date of initial trip deposit
final_payment_date = date                      ; Date of final payment for trip
booking_date = date                            ; Date trip was booked

; ───────────────────────────────────────────────────────────────────────────────
; Trip Type
; ───────────────────────────────────────────────────────────────────────────────
trip_type = (adventure, business, cruise, domestic, educational, group_tour, honeymoon, international, leisure, medical_tourism, mission, religious_pilgrimage, safari, ski, study_abroad, wedding_destination) ; Category of trip

; ───────────────────────────────────────────────────────────────────────────────
; Trip Purpose
; ───────────────────────────────────────────────────────────────────────────────
trip_purpose = (business, combined, leisure, other) ; Primary purpose of the trip

; ═══════════════════════════════════════════════════════════════════════════════
; TRIP DESTINATIONS
; ═══════════════════════════════════════════════════════════════════════════════

{@trip.destinations[]}
sequence = ##:(1..)                            ; Order of destinations in itinerary
destination_type = (departure, layover, primary, return, secondary) ; Type of destination in the itinerary

city = :                                       ; Destination city name
state_province = :                             ; State or province
country = :(2..3)                              ; ISO country code (2 or 3 characters)
country_name = :                               ; Full country name

arrival_date = date                            ; Date of arrival at this destination
departure_date = date                          ; Date of departure from this destination
nights = ##:(0..365)                           ; Number of nights at this destination

; Travel advisories
travel_advisory_level = ##:(1..4)              ; Travel advisory level (1=low, 4=high)
travel_advisory_source = :                     ; Source of advisory (e.g., State Dept)

{@trip}

; ═══════════════════════════════════════════════════════════════════════════════
; TRIP COSTS
; ═══════════════════════════════════════════════════════════════════════════════

{@trip.costs}
; Total trip cost (sum of all components)
total_trip_cost = #$:(0..)                     ; Total cost of the entire trip
total_prepaid_nonrefundable = #$:(0..)         ; Total prepaid non-refundable amount
currency = :(3)                                ; ISO currency code (3 characters)

; Cost breakdown by category
{.air}
cost = #$:(0..)                                ; Cost of air travel
prepaid = ?                                    ; Is airfare prepaid
refundable = ?                                 ; Is airfare refundable
carrier = :                                    ; Airline carrier name
confirmation_number = :                        ; Airline confirmation/booking number

{@trip.costs}

{.cruise}
cost = #$:(0..)                                ; Cost of cruise
prepaid = ?                                    ; Is cruise prepaid
refundable = ?                                 ; Is cruise refundable
cruise_line = :                                ; Name of cruise line
ship_name = :                                  ; Name of cruise ship
confirmation_number = :                        ; Cruise confirmation/booking number
cabin_category = :                             ; Cabin type/category

{@trip.costs}

{.accommodations}
cost = #$:(0..)                                ; Cost of accommodations
prepaid = ?                                    ; Are accommodations prepaid
refundable = ?                                 ; Are accommodations refundable
hotel_name = :                                 ; Name of hotel/lodging
confirmation_number = :                        ; Hotel confirmation/booking number

{@trip.costs}

{.tour_package}
cost = #$:(0..)                                ; Cost of tour package
prepaid = ?                                    ; Is tour package prepaid
refundable = ?                                 ; Is tour package refundable
tour_operator = :                              ; Name of tour operator
confirmation_number = :                        ; Tour confirmation/booking number

{@trip.costs}

{.car_rental}
cost = #$:(0..)                                ; Cost of car rental
prepaid = ?                                    ; Is car rental prepaid
refundable = ?                                 ; Is car rental refundable
rental_company = :                             ; Name of car rental company
confirmation_number = :                        ; Car rental confirmation/booking number

{@trip.costs}

{.other_costs[]}
description = :                                ; Description of other cost
cost = #$:(0..)                                ; Cost amount
prepaid = ?                                    ; Is this cost prepaid
refundable = ?                                 ; Is this cost refundable
vendor = :                                     ; Vendor/supplier name

{@trip}

; ═══════════════════════════════════════════════════════════════════════════════
; COVERED REASON (Named Perils)
; ═══════════════════════════════════════════════════════════════════════════════

{@covered_reason}
code = :                                       ; Unique code for this covered reason
category = (employment, financial, legal, medical, military, natural_disaster, other, residence, terrorism, transportation, travel_supplier) ; Category of the covered reason

reason_name = :                                ; Name of the covered reason
reason_description = :                         ; Detailed description of the covered reason
documentation_required = :                     ; What documentation is required to prove this reason
applies_to = (cancellation, interruption, both) ; Whether this reason applies to cancellation, interruption, or both

; ═══════════════════════════════════════════════════════════════════════════════
; TRIP CANCELLATION COVERAGE
; ═══════════════════════════════════════════════════════════════════════════════

{@trip_cancellation_coverage}
= @coverage

coverage_type_ref = "TRIP_CANCEL"              ; Reference to coverage type

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Limits
; ───────────────────────────────────────────────────────────────────────────────
trip_cost_limit = #$:(0..)                     ; Maximum coverage per trip
per_person_limit = #$:(0..)                    ; Maximum coverage per person
reimbursement_percent = ##:(0..100)            ; Percentage of costs reimbursed

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Basis
; ───────────────────────────────────────────────────────────────────────────────
coverage_basis = (named_perils, all_risk)      ; Coverage basis type

; ───────────────────────────────────────────────────────────────────────────────
; Pre-existing Condition Waiver
; ───────────────────────────────────────────────────────────────────────────────
pre_existing_waiver_eligible = ?               ; Is policy eligible for pre-existing condition waiver
pre_existing_waiver_period_days = ##:(0..30)   ; Days after deposit to purchase for waiver
pre_existing_lookback_days = ##:(0..180)       ; Days to look back for pre-existing conditions
pre_existing_waiver_requirements = :           ; Requirements to qualify for waiver

; ───────────────────────────────────────────────────────────────────────────────
; Time-Sensitive Purchase Requirements
; ───────────────────────────────────────────────────────────────────────────────
purchase_deadline_days = ##:(0..30)            ; Days after deposit to purchase policy
insure_full_cost_required = ?                  ; Must insure full trip cost

; ───────────────────────────────────────────────────────────────────────────────
; Covered Reasons
; ───────────────────────────────────────────────────────────────────────────────
covered_reasons[] = @covered_reason            ; List of covered reasons for cancellation

; ═══════════════════════════════════════════════════════════════════════════════
; TRIP INTERRUPTION COVERAGE
; ═══════════════════════════════════════════════════════════════════════════════

{@trip_interruption_coverage}
= @coverage

coverage_type_ref = "TRIP_INT"                 ; Reference to coverage type

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Limits
; ───────────────────────────────────────────────────────────────────────────────
trip_cost_limit = #$:(0..)                     ; Maximum coverage per trip
per_person_limit = #$:(0..)                    ; Maximum coverage per person
reimbursement_percent = ##:(100..200)          ; Percentage of costs reimbursed (100-200%)

; Many policies pay 100-150% of remaining trip cost for interruption

; ───────────────────────────────────────────────────────────────────────────────
; Additional Coverage
; ───────────────────────────────────────────────────────────────────────────────
return_air_included = ?                        ; Covers cost to return home early
return_air_limit = #$:(0..)                    ; Maximum reimbursement for return airfare
additional_accommodations_included = ?         ; Covers extra lodging due to interruption
additional_accommodations_limit = #$:(0..)     ; Maximum reimbursement for additional accommodations

; ───────────────────────────────────────────────────────────────────────────────
; Covered Reasons
; ───────────────────────────────────────────────────────────────────────────────
covered_reasons[] = @covered_reason            ; List of covered reasons for interruption

; ═══════════════════════════════════════════════════════════════════════════════
; CANCEL FOR ANY REASON (CFAR)
; ═══════════════════════════════════════════════════════════════════════════════

{@cfar_coverage}
= @coverage

coverage_type_ref = "CFAR"                     ; Reference to coverage type

; ───────────────────────────────────────────────────────────────────────────────
; CFAR Benefits
; ───────────────────────────────────────────────────────────────────────────────
reimbursement_percent = ##:(50..80)            ; Percentage reimbursed (typically 50-75%)
maximum_benefit = #$:(0..)                     ; Maximum benefit amount

; 50-75% of prepaid, non-refundable costs

; ───────────────────────────────────────────────────────────────────────────────
; Eligibility Requirements
; ───────────────────────────────────────────────────────────────────────────────
purchase_deadline_days = ##:(14..21)           ; Days after deposit to purchase CFAR
insure_full_cost_required = ?                  ; Must insure full trip cost
cancellation_deadline_hours = ##:(48..72)      ; Hours before departure to cancel

; Must cancel at least 48-72 hours before scheduled departure

; ───────────────────────────────────────────────────────────────────────────────
; State Availability
; ───────────────────────────────────────────────────────────────────────────────
; CFAR not available in all states (e.g., not in NY)
available_states[] = :(2)                      ; States where CFAR is available (2-char codes)
excluded_states[] = :(2)                       ; States where CFAR is not available (2-char codes)

; ───────────────────────────────────────────────────────────────────────────────
; Additional Premium
; ───────────────────────────────────────────────────────────────────────────────
additional_premium_percent = #:(0..100)        ; Additional premium as percentage of base
additional_premium_amount = #$:(0..)           ; Additional premium in currency

; ═══════════════════════════════════════════════════════════════════════════════
; TRIP DELAY COVERAGE
; ═══════════════════════════════════════════════════════════════════════════════
; Coverage for additional expenses when trip is delayed

{@trip_delay_coverage}
= @coverage

coverage_type_ref = "TRIP_DELAY"               ; Reference to coverage type

; ───────────────────────────────────────────────────────────────────────────────
; Trigger
; ───────────────────────────────────────────────────────────────────────────────
minimum_delay_hours = ##:(3..12)               ; Minimum hours of delay to trigger coverage
delay_causes = (carrier_delay, lost_documents, mechanical_breakdown, missed_connection, natural_disaster, quarantine, severe_weather, traffic_accident, unannounced_strike) ; Covered causes of delay

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Limits
; ───────────────────────────────────────────────────────────────────────────────
maximum_benefit = #$:(0..)                     ; Maximum total benefit
daily_limit = #$:(0..)                         ; Maximum benefit per day
per_person_limit = #$:(0..)                    ; Maximum benefit per person

; ───────────────────────────────────────────────────────────────────────────────
; Covered Expenses
; ───────────────────────────────────────────────────────────────────────────────
meals_covered = ?                              ; Are meals covered during delay
meals_limit = #$:(0..)                         ; Maximum reimbursement for meals
accommodations_covered = ?                     ; Are accommodations covered during delay
accommodations_limit = #$:(0..)                ; Maximum reimbursement for accommodations
transportation_covered = ?                     ; Is local transportation covered during delay
transportation_limit = #$:(0..)                ; Maximum reimbursement for transportation
essential_items_covered = ?                    ; Are essential items covered during delay
essential_items_limit = #$:(0..)               ; Maximum reimbursement for essential items

; ═══════════════════════════════════════════════════════════════════════════════
; MISSED CONNECTION COVERAGE
; ═══════════════════════════════════════════════════════════════════════════════

{@missed_connection_coverage}
= @coverage

coverage_type_ref = "MISS_CONN"                ; Reference to coverage type

minimum_connection_time_hours = ##:(1..6)      ; Minimum connection time required for coverage
maximum_benefit = #$:(0..)                     ; Maximum total benefit

; Covered expenses
rebooking_costs_covered = ?                    ; Are rebooking costs covered
accommodations_covered = ?                     ; Are accommodations covered
meals_covered = ?                              ; Are meals covered
transportation_covered = ?                     ; Is transportation covered

; ═══════════════════════════════════════════════════════════════════════════════
; EMERGENCY MEDICAL COVERAGE
; ═══════════════════════════════════════════════════════════════════════════════

{@trip_medical_coverage}
= @coverage

coverage_type_ref = "TRIP_MED"                 ; Reference to coverage type

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Type
; ───────────────────────────────────────────────────────────────────────────────
coverage_type = (excess, primary, secondary)   ; Whether coverage is primary, secondary, or excess

; ───────────────────────────────────────────────────────────────────────────────
; Limits
; ───────────────────────────────────────────────────────────────────────────────
maximum_benefit = #$:(0..)                     ; Maximum total benefit
per_incident_limit = #$:(0..)                  ; Maximum benefit per incident
deductible = #$:(0..)                          ; Deductible amount

; ───────────────────────────────────────────────────────────────────────────────
; Covered Expenses
; ───────────────────────────────────────────────────────────────────────────────
{.covered_expenses}
hospital_inpatient = ?                         ; Covers inpatient hospital care
hospital_outpatient = ?                        ; Covers outpatient hospital care
emergency_room = ?                             ; Covers emergency room visits
physician_services = ?                         ; Covers physician/doctor services
surgery = ?                                    ; Covers surgical procedures
diagnostic_tests = ?                           ; Covers diagnostic tests (X-rays, labs, etc.)
prescription_drugs = ?                         ; Covers prescription medications
ambulance = ?                                  ; Covers ambulance services
dental_emergency = ?                           ; Covers emergency dental care
dental_limit = #$:(0..)                        ; Maximum benefit for dental care
vision_emergency = ?                           ; Covers emergency vision care
physical_therapy = ?                           ; Covers physical therapy
mental_health = ?                              ; Covers mental health services

{@trip_medical_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Pre-existing Conditions
; ───────────────────────────────────────────────────────────────────────────────
pre_existing_covered = ?                       ; Are pre-existing conditions covered
pre_existing_waiver_eligible = ?               ; Is policy eligible for pre-existing condition waiver
pre_existing_lookback_days = ##:(60..180)      ; Days to look back for pre-existing conditions
stability_period_days = ##:(60..180)           ; Required stability period for pre-existing conditions

; ───────────────────────────────────────────────────────────────────────────────
; Age Limits
; ───────────────────────────────────────────────────────────────────────────────
minimum_age = ##:(0..18)                       ; Minimum age for coverage
maximum_age = ##:(65..100)                     ; Maximum age for coverage
age_affects_limits = ?                         ; Do age restrictions affect coverage limits

; ───────────────────────────────────────────────────────────────────────────────
; Geographic Scope
; ───────────────────────────────────────────────────────────────────────────────
domestic_coverage = ?                          ; Covers domestic travel
international_coverage = ?                     ; Covers international travel
home_country_coverage = ?                      ; Covers medical care in home country
home_country_coverage_days = ##:(0..30)        ; Days of home country coverage

; ───────────────────────────────────────────────────────────────────────────────
; Telemedicine
; ───────────────────────────────────────────────────────────────────────────────
telemedicine_included = ?                      ; Is telemedicine service included
telemedicine_copay = #$:(0..)                  ; Copay amount for telemedicine

; ═══════════════════════════════════════════════════════════════════════════════
; MEDICAL EVACUATION COVERAGE
; ═══════════════════════════════════════════════════════════════════════════════
; Coverage for emergency medical evacuation and repatriation

{@trip_evacuation_coverage}
= @coverage

coverage_type_ref = "MED_EVAC"                 ; Reference to coverage type

; ───────────────────────────────────────────────────────────────────────────────
; Evacuation Benefits
; ───────────────────────────────────────────────────────────────────────────────
emergency_evacuation_limit = #$:(0..)          ; Maximum benefit for emergency evacuation
medical_repatriation_limit = #$:(0..)          ; Maximum benefit for medical repatriation
repatriation_of_remains_limit = #$:(0..)       ; Maximum benefit for repatriation of remains
return_of_minor_children_limit = #$:(0..)      ; Maximum benefit for return of minor children
bedside_visit_limit = #$:(0..)                 ; Maximum benefit for family bedside visit
bedside_visit_included = ?                     ; Is bedside visit benefit included

; ───────────────────────────────────────────────────────────────────────────────
; Evacuation Types
; ───────────────────────────────────────────────────────────────────────────────
{.evacuation_types}
medical_evacuation = ?                         ; Covers medical evacuation
air_ambulance = ?                              ; Covers air ambulance service
ground_ambulance = ?                           ; Covers ground ambulance service
search_and_rescue = ?                          ; Covers search and rescue operations
search_and_rescue_limit = #$:(0..)             ; Maximum benefit for search and rescue
political_evacuation = ?                       ; Covers political evacuation
political_evacuation_limit = #$:(0..)          ; Maximum benefit for political evacuation
natural_disaster_evacuation = ?                ; Covers natural disaster evacuation
natural_disaster_limit = #$:(0..)              ; Maximum benefit for natural disaster evacuation

{@trip_evacuation_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Evacuation Destination
; ───────────────────────────────────────────────────────────────────────────────
evacuation_destination = (
    facility_of_choice,
    home_country,
    hospital_of_choice,
    nearest_adequate_facility
)                                              ; Allowable evacuation destinations

; ───────────────────────────────────────────────────────────────────────────────
; Companion Benefits
; ───────────────────────────────────────────────────────────────────────────────
companion_transportation = ?                   ; Covers companion transportation
companion_lodging = ?                          ; Covers companion lodging
companion_daily_limit = #$:(0..)               ; Maximum daily benefit for companion
companion_max_days = ##:(0..30)                ; Maximum days of companion benefits

; ═══════════════════════════════════════════════════════════════════════════════
; BAGGAGE COVERAGE
; ═══════════════════════════════════════════════════════════════════════════════
; Coverage for lost, stolen, or damaged baggage

{@trip_baggage_coverage}
= @coverage

coverage_type_ref = "BAGGAGE"                  ; Reference to coverage type

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Types
; ───────────────────────────────────────────────────────────────────────────────
{.coverage_parts}
baggage_loss = ?                               ; Covers lost baggage
baggage_loss_limit = #$:(0..)                  ; Maximum benefit for lost baggage
baggage_theft = ?                              ; Covers stolen baggage
baggage_theft_limit = #$:(0..)                 ; Maximum benefit for stolen baggage
baggage_damage = ?                             ; Covers damaged baggage
baggage_damage_limit = #$:(0..)                ; Maximum benefit for damaged baggage

{@trip_baggage_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Per-Item Sublimits
; ───────────────────────────────────────────────────────────────────────────────
{.sublimits}
per_item_limit = #$:(0..)                      ; Maximum benefit per individual item
jewelry_limit = #$:(0..)                       ; Maximum benefit for jewelry
electronics_limit = #$:(0..)                   ; Maximum benefit for electronics
cameras_limit = #$:(0..)                       ; Maximum benefit for cameras
sporting_equipment_limit = #$:(0..)            ; Maximum benefit for sporting equipment
business_equipment_limit = #$:(0..)            ; Maximum benefit for business equipment
eyewear_limit = #$:(0..)                       ; Maximum benefit for eyewear
watches_limit = #$:(0..)                       ; Maximum benefit for watches

{@trip_baggage_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Valuation
; ───────────────────────────────────────────────────────────────────────────────
valuation_basis = (actual_cash_value, replacement_cost) ; Basis for valuing lost/damaged items
depreciation_applied = ?                       ; Is depreciation applied to claims

; ───────────────────────────────────────────────────────────────────────────────
; Exclusions
; ───────────────────────────────────────────────────────────────────────────────
excluded_items[] = :                           ; List of items excluded from coverage

; Common exclusions:
; - Cash, securities, tickets
; - Dental bridges, hearing aids
; - Perishables
; - Business samples/merchandise
; - Fragile items improperly packed
; - Items left unattended
; - Motor vehicles, watercraft

; ═══════════════════════════════════════════════════════════════════════════════
; BAGGAGE DELAY COVERAGE
; ═══════════════════════════════════════════════════════════════════════════════

{@baggage_delay_coverage}
= @coverage

coverage_type_ref = "BAG_DELAY"                ; Reference to coverage type

; ───────────────────────────────────────────────────────────────────────────────
; Delay Trigger
; ───────────────────────────────────────────────────────────────────────────────
minimum_delay_hours = ##:(6..24)               ; Minimum hours of delay to trigger coverage

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Limits
; ───────────────────────────────────────────────────────────────────────────────
maximum_benefit = #$:(0..)                     ; Maximum total benefit
per_person_limit = #$:(0..)                    ; Maximum benefit per person
daily_limit = #$:(0..)                         ; Maximum benefit per day

; ───────────────────────────────────────────────────────────────────────────────
; Covered Expenses
; ───────────────────────────────────────────────────────────────────────────────
essential_clothing = ?                         ; Covers essential clothing purchases
essential_toiletries = ?                       ; Covers essential toiletries purchases
essential_items_only = ?                       ; Only essential items are covered
rental_equipment = ?                           ; Covers rental equipment (e.g., ski gear)

; ═══════════════════════════════════════════════════════════════════════════════
; ADVENTURE SPORTS COVERAGE
; ═══════════════════════════════════════════════════════════════════════════════
; Optional rider for hazardous/adventure activities

{@adventure_sports_coverage}
= @coverage

coverage_type_ref = "ADVENTURE"                ; Reference to coverage type

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Tier
; ───────────────────────────────────────────────────────────────────────────────
coverage_tier = (adventure, extreme)           ; Tier of adventure sports coverage

; Adventure: bungee, skydiving tandem, scuba (certified), zip-lining
; Extreme: base jumping, heli-skiing, mountaineering >3000m, paragliding

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Limits
; ───────────────────────────────────────────────────────────────────────────────
medical_limit = #$:(0..)                       ; Maximum medical coverage for adventure sports
evacuation_limit = #$:(0..)                    ; Maximum evacuation coverage for adventure sports
search_and_rescue_limit = #$:(0..)             ; Maximum search and rescue coverage

; ───────────────────────────────────────────────────────────────────────────────
; Covered Activities
; ───────────────────────────────────────────────────────────────────────────────
covered_activities[] = (
    backcountry_skiing,
    base_jumping,
    bungee_jumping,
    canyoneering,
    caving,
    cliff_diving,
    freediving,
    glacier_trekking,
    hang_gliding,
    heli_skiing,
    high_altitude_trekking,
    hot_air_ballooning,
    ice_climbing,
    jet_skiing,
    kayaking_whitewater,
    kiteboarding,
    moto_cross,
    mountain_biking,
    mountaineering,
    parachuting,
    paragliding,
    parasailing,
    rock_climbing,
    safari,
    scuba_diving,
    skydiving,
    snowboarding,
    snowmobiling,
    surfing,
    trekking,
    wakeboarding,
    windsurfing,
    zip_lining
)

; ───────────────────────────────────────────────────────────────────────────────
; Activity Restrictions
; ───────────────────────────────────────────────────────────────────────────────
scuba_depth_limit_meters = ##:(0..60)          ; Maximum scuba diving depth in meters
altitude_limit_meters = ##:(0..8848)           ; Maximum altitude for activities in meters
certification_required = ?                     ; Is certification required for coverage
professional_guide_required = ?                ; Is professional guide required for coverage
organized_tour_required = ?                    ; Must activity be part of organized tour

; ───────────────────────────────────────────────────────────────────────────────
; Exclusions
; ───────────────────────────────────────────────────────────────────────────────
professional_competition_excluded = ?          ; Professional competition excluded
speed_records_excluded = ?                     ; Speed record attempts excluded
exploration_excluded = ?                       ; Exploration activities excluded
racing_excluded = ?                            ; Racing activities excluded

; ───────────────────────────────────────────────────────────────────────────────
; Additional Premium
; ───────────────────────────────────────────────────────────────────────────────
additional_premium_amount = #$:(0..)           ; Additional premium in currency
additional_premium_percent = #:(0..100)        ; Additional premium as percentage of base

; ═══════════════════════════════════════════════════════════════════════════════
; TRAVEL ASSISTANCE SERVICES
; ═══════════════════════════════════════════════════════════════════════════════
; Non-insurance assistance services included with policy

{@travel_assistance}
; ───────────────────────────────────────────────────────────────────────────────
; 24/7 Assistance
; ───────────────────────────────────────────────────────────────────────────────
available_24_7 = ?                             ; Is assistance available 24/7
multilingual = ?                               ; Is multilingual support available
languages_supported[] = :                      ; List of supported languages

; ───────────────────────────────────────────────────────────────────────────────
; Contact Information
; ───────────────────────────────────────────────────────────────────────────────
toll_free_number = :                           ; Toll-free contact number
international_collect_number = :               ; International collect number
email = *@email                                ; Assistance email address (confidential)
mobile_app_available = ?                       ; Is mobile app available

; ───────────────────────────────────────────────────────────────────────────────
; Emergency Services
; ───────────────────────────────────────────────────────────────────────────────
{.emergency_services}
medical_referrals = ?                          ; Provides medical provider referrals
hospital_admission_assistance = ?              ; Assists with hospital admission
emergency_message_relay = ?                    ; Relays emergency messages to family
embassy_consulate_referral = ?                 ; Provides embassy/consulate referrals
emergency_cash_transfer = ?                    ; Assists with emergency cash transfers
cash_transfer_limit = #$:(0..)                 ; Maximum cash transfer amount
emergency_travel_arrangements = ?              ; Assists with emergency travel arrangements
legal_referrals = ?                            ; Provides legal referrals
bail_bond_assistance = ?                       ; Assists with bail bond arrangements
bail_bond_limit = #$:(0..)                     ; Maximum bail bond assistance amount
lost_document_assistance = ?                   ; Assists with lost document replacement
prescription_assistance = ?                    ; Assists with prescription replacement

{@travel_assistance}

; ───────────────────────────────────────────────────────────────────────────────
; Concierge Services
; ───────────────────────────────────────────────────────────────────────────────
{.concierge_services}
restaurant_reservations = ?                    ; Assists with restaurant reservations
hotel_reservations = ?                         ; Assists with hotel reservations
event_tickets = ?                              ; Assists with event ticket purchases
ground_transportation = ?                      ; Assists with ground transportation
golf_tee_times = ?                             ; Assists with golf tee time reservations
spa_reservations = ?                           ; Assists with spa reservations
floral_delivery = ?                            ; Assists with floral delivery
gift_services = ?                              ; Assists with gift services
interpreter_referral = ?                       ; Provides interpreter referrals

{@travel_assistance}

; ───────────────────────────────────────────────────────────────────────────────
; Pre-Trip Services
; ───────────────────────────────────────────────────────────────────────────────
{.pre_trip_services}
destination_information = ?                    ; Provides destination information
visa_passport_requirements = ?                 ; Provides visa/passport requirement info
vaccination_requirements = ?                   ; Provides vaccination requirement info
weather_information = ?                        ; Provides weather information
currency_exchange_info = ?                     ; Provides currency exchange information
travel_advisory_alerts = ?                     ; Provides travel advisory alerts

{@travel_assistance}

; ═══════════════════════════════════════════════════════════════════════════════
; ACCIDENTAL DEATH & DISMEMBERMENT
; ═══════════════════════════════════════════════════════════════════════════════

{@travel_ad_d_coverage}
= @coverage

coverage_type_ref = "TRAVEL_ADD"               ; Reference to coverage type

; ───────────────────────────────────────────────────────────────────────────────
; Principal Sum
; ───────────────────────────────────────────────────────────────────────────────
principal_sum = #$:(0..)                       ; Base principal sum for AD&D
common_carrier_principal_sum = #$:(0..)        ; Enhanced principal sum for common carrier accidents

; ───────────────────────────────────────────────────────────────────────────────
; Schedule of Benefits (Percentage of Principal Sum)
; ───────────────────────────────────────────────────────────────────────────────
{.schedule}
accidental_death = ##:(0..100)                 ; Percentage paid for accidental death
loss_of_both_hands = ##:(0..100)               ; Percentage paid for loss of both hands
loss_of_both_feet = ##:(0..100)                ; Percentage paid for loss of both feet
loss_of_sight_both_eyes = ##:(0..100)          ; Percentage paid for loss of sight in both eyes
loss_of_one_hand_one_foot = ##:(0..100)        ; Percentage paid for loss of one hand and one foot
loss_of_one_hand_sight = ##:(0..100)           ; Percentage paid for loss of one hand and sight in one eye
loss_of_one_foot_sight = ##:(0..100)           ; Percentage paid for loss of one foot and sight in one eye
loss_of_one_hand = ##:(0..100)                 ; Percentage paid for loss of one hand
loss_of_one_foot = ##:(0..100)                 ; Percentage paid for loss of one foot
loss_of_sight_one_eye = ##:(0..100)            ; Percentage paid for loss of sight in one eye
loss_of_thumb_index_finger = ##:(0..100)       ; Percentage paid for loss of thumb and index finger
paralysis_quadriplegia = ##:(0..100)           ; Percentage paid for quadriplegia
paralysis_paraplegia = ##:(0..100)             ; Percentage paid for paraplegia
coma = ##:(0..100)                             ; Percentage paid for coma

{@travel_ad_d_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Period
; ───────────────────────────────────────────────────────────────────────────────
coverage_period = (common_carrier_only, trip_duration) ; Period during which coverage applies
loss_period_days = ##:(90..365)                ; Days within which loss must occur after accident

; ═══════════════════════════════════════════════════════════════════════════════
; TRAVEL INSURANCE POLICY
; ═══════════════════════════════════════════════════════════════════════════════
; Main policy structure tying together all components

{@travel_policy}
; ───────────────────────────────────────────────────────────────────────────────
; Policy Identification
; ───────────────────────────────────────────────────────────────────────────────
id = :                                         ; Unique identifier for the policy
number = !:                                    ; Policy number (required)
certificate_number = :                         ; Certificate number
quote_number = :                               ; Quote/proposal number

; ───────────────────────────────────────────────────────────────────────────────
; Policy Type
; ───────────────────────────────────────────────────────────────────────────────
type = (annual, group, single_trip)            ; Type of travel insurance policy
product_name = :                               ; Name of insurance product
product_code = :                               ; Product code
plan_level = (basic, comprehensive, deluxe, platinum, standard) ; Coverage plan level

; ───────────────────────────────────────────────────────────────────────────────
; Annual/Multi-Trip Specific
; ───────────────────────────────────────────────────────────────────────────────
max_trip_length_days = ##:(30..90):if type = annual ; Maximum length per trip for annual policies
unlimited_trips = ?:if type = annual           ; Unlimited trips allowed in year
annual_trip_cancellation_limit = #$:(0..):if type = annual ; Annual aggregate trip cancellation limit

; ───────────────────────────────────────────────────────────────────────────────
; Group Policy Specific
; ───────────────────────────────────────────────────────────────────────────────
group_name = ::if type = group                 ; Name of the group
group_size_minimum = ##:(5..):if type = group  ; Minimum group size required
group_size_actual = ##:(1..):if type = group   ; Actual group size
group_discount_percent = #:(0..50):if type = group ; Group discount percentage

; ───────────────────────────────────────────────────────────────────────────────
; Policy Dates
; ───────────────────────────────────────────────────────────────────────────────
{.dates}
purchase_date = date                           ; Date policy was purchased
effective_date = date                          ; Policy effective date
expiration_date = date                         ; Policy expiration date
days_from_deposit = ##:(0..365)                ; Days between initial deposit and purchase
:invariant expiration_date > effective_date

{@travel_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Time-Sensitive Benefits Eligibility
; ───────────────────────────────────────────────────────────────────────────────
{.time_sensitive}
cfar_eligible = ?                              ; Eligible for Cancel For Any Reason coverage
pre_existing_waiver_eligible = ?               ; Eligible for pre-existing condition waiver
financial_default_eligible = ?                 ; Eligible for supplier financial default coverage
terrorism_eligible = ?                         ; Eligible for terrorism coverage
eligibility_deadline_met = ?                   ; Time-sensitive eligibility deadline met

{@travel_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Policy Status
; ───────────────────────────────────────────────────────────────────────────────
status = (
    active,
    cancelled,
    claim_pending,
    expired,
    pending_payment,
    quote,
    void
)                                              ; Current policy status
status_date = date                             ; Date of status change
status_reason = :                              ; Reason for current status

; ───────────────────────────────────────────────────────────────────────────────
; Geographic Coverage
; ───────────────────────────────────────────────────────────────────────────────
coverage_territory = (domestic_only, international_only, worldwide) ; Geographic scope of coverage
home_country = :(2..3)                         ; Insured's home country (ISO code)
excluded_countries[] = :(2..3)                 ; Countries excluded from coverage (ISO codes)

; ───────────────────────────────────────────────────────────────────────────────
; State/Province
; ───────────────────────────────────────────────────────────────────────────────
state_of_residence = :                         ; State/province of residence
state_filed = :                                ; State/province where policy is filed

; ───────────────────────────────────────────────────────────────────────────────
; Primary Insured
; ───────────────────────────────────────────────────────────────────────────────
{.primary_insured}
= @traveler

{@travel_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Additional Travelers
; ───────────────────────────────────────────────────────────────────────────────
{.travelers[]}
= @traveler

{@travel_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Trip Details
; ───────────────────────────────────────────────────────────────────────────────
{.trip}
= @trip

{@travel_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Coverages
; ───────────────────────────────────────────────────────────────────────────────
{.coverages}

{..trip_cancellation}
= @trip_cancellation_coverage

{..trip_interruption}
= @trip_interruption_coverage

{..cfar}
= @cfar_coverage

{..trip_delay}
= @trip_delay_coverage

{..missed_connection}
= @missed_connection_coverage

{..emergency_medical}
= @trip_medical_coverage

{..medical_evacuation}
= @trip_evacuation_coverage

{..baggage}
= @trip_baggage_coverage

{..baggage_delay}
= @baggage_delay_coverage

{..adventure_sports}
= @adventure_sports_coverage

{..ad_d}
= @travel_ad_d_coverage

{@travel_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Assistance Services
; ───────────────────────────────────────────────────────────────────────────────
{.assistance}
= @travel_assistance

{@travel_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
base_premium = #$:(0..)                        ; Base premium amount
cfar_premium = #$:(0..)                        ; Cancel For Any Reason premium add-on
adventure_sports_premium = #$:(0..)            ; Adventure sports premium add-on
other_upgrades_premium = #$:(0..)              ; Other upgrade premiums
total_premium = #$:(0..)                       ; Total premium before taxes and fees
premium_per_traveler = #$:(0..)                ; Premium amount per traveler
taxes = #$:(0..)                               ; Tax amount
fees = #$:(0..)                                ; Administrative/processing fees
total_cost = #$:(0..)                          ; Total cost including taxes and fees
currency = :(3)                                ; ISO currency code (3 characters)
:invariant total_premium >= base_premium

{@travel_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Payment
; ───────────────────────────────────────────────────────────────────────────────
{.payment}
method = (ach, check, credit_card, debit_card, other, paypal) ; Payment method
card_last_four = *:(4)                         ; Last four digits of card (confidential)
payment_date = date                            ; Date of payment

payment_status = (authorized, captured, declined, pending, refunded) ; Payment status
confirmation_number = :                        ; Payment confirmation number

{@travel_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Carrier/Insurer
; ───────────────────────────────────────────────────────────────────────────────
carrier_ref = :                               ; Insurance carrier reference

{@travel_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Distribution
; ───────────────────────────────────────────────────────────────────────────────
{.distribution}
channel = (aggregator, airline, cruise_line, direct, hotel, tour_operator, travel_agency) ; Distribution channel
agency_name = :                                ; Name of selling agency
agency_code = :                                ; Agency code
agent_name = :                                 ; Name of selling agent
agent_code = :                                 ; Agent code
affiliate_code = :                             ; Affiliate/partner code

{@travel_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Documents
; ───────────────────────────────────────────────────────────────────────────────
{.documents[]}
document_type = (
    certificate_of_insurance,
    claim_form,
    declarations_page,
    policy_document,
    receipt,
    travel_card
)                                              ; Type of document
document_url = :                               ; URL to access the document
document_date = date                           ; Date document was generated

{@travel_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Claims
; ───────────────────────────────────────────────────────────────────────────────
{.claims[]}
= @travel_claim

{@travel_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Timestamps
; ───────────────────────────────────────────────────────────────────────────────
created = timestamp                            ; Timestamp when policy was created
modified = timestamp                           ; Timestamp when policy was last modified
created_by = :                                 ; User who created the policy
modified_by = :                                ; User who last modified the policy

; ═══════════════════════════════════════════════════════════════════════════════
; TRAVEL CLAIM
; ═══════════════════════════════════════════════════════════════════════════════
; Claim submission and processing for travel insurance

{@travel_claim}
id = :                                         ; Unique identifier for the claim
number = !:                                    ; Claim number (required)
policy_number = !:                             ; Associated policy number (required)
certificate_number = :                         ; Associated certificate number

; ───────────────────────────────────────────────────────────────────────────────
; Claim Type
; ───────────────────────────────────────────────────────────────────────────────
type = (
    accidental_death,
    baggage_damage,
    baggage_delay,
    baggage_loss,
    baggage_theft,
    cfar,
    medical_emergency,
    medical_evacuation,
    missed_connection,
    repatriation_of_remains,
    trip_cancellation,
    trip_delay,
    trip_interruption
)                                              ; Type of claim

; ───────────────────────────────────────────────────────────────────────────────
; Claim Dates
; ───────────────────────────────────────────────────────────────────────────────
{.dates}
incident_date = date                           ; Date the incident occurred
incident_time = time                           ; Time the incident occurred
reported_date = date                           ; Date the incident was reported
filed_date = date                              ; Date the claim was filed
filing_deadline = date                         ; Deadline to file the claim
:invariant filed_date >= incident_date

{@travel_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Incident Details
; ───────────────────────────────────────────────────────────────────────────────
{.incident}
description = :                                ; Description of the incident
location_city = :                              ; City where incident occurred
location_country = :(2..3)                     ; Country where incident occurred (ISO code)
covered_reason = @covered_reason               ; Reference to the covered reason

{@travel_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Claimant
; ───────────────────────────────────────────────────────────────────────────────
{.claimant}
traveler_id = :                                ; Reference to traveler ID
name = :                                       ; Claimant's full name
email = *@email                                ; Claimant's email (confidential)
phone = *@phone                                ; Claimant's phone (confidential)
relationship_to_insured = :                    ; Relationship to the insured

{@travel_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Claim Status
; ───────────────────────────────────────────────────────────────────────────────
status = (
    approved,
    closed,
    denied,
    in_review,
    information_requested,
    paid,
    partially_approved,
    received,
    submitted,
    under_investigation
)                                              ; Current claim status
status_date = date                             ; Date of status change
status_reason = :                              ; Reason for current status

; ───────────────────────────────────────────────────────────────────────────────
; Claim Amounts
; ───────────────────────────────────────────────────────────────────────────────
{.amounts}
amount_claimed = #$:(0..)                      ; Amount claimed by claimant
amount_approved = #$:(0..)                     ; Amount approved for payment
amount_paid = #$:(0..)                         ; Amount actually paid
amount_denied = #$:(0..)                       ; Amount denied
deductible_applied = #$:(0..)                  ; Deductible amount applied
other_insurance_paid = #$:(0..)                ; Amount paid by other insurance
currency = :(3)                                ; ISO currency code (3 characters)

{@travel_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Documentation Submitted
; ───────────────────────────────────────────────────────────────────────────────
{.documents[]}
document_type = (
    airline_report,
    attending_physician_statement,
    bank_statement,
    credit_card_statement,
    death_certificate,
    hotel_receipt,
    itemized_receipts,
    medical_records,
    passport_copy,
    physician_statement,
    police_report,
    proof_of_loss_form,
    property_irregularity_report,
    purchase_receipts,
    travel_confirmation,
    travel_invoice,
    trip_itinerary,
    unused_tickets
)                                              ; Type of supporting document
document_name = :                              ; Name/title of the document
document_url = :                               ; URL to access the document
submitted_date = date                          ; Date document was submitted
status = (accepted, pending_review, rejected, requested) ; Document review status

{@travel_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Payment Information
; ───────────────────────────────────────────────────────────────────────────────
{.payment}
payment_date = date                            ; Date payment was made
payment_method = (check, credit_card_refund, direct_deposit) ; Method of payment
payment_reference = :                          ; Payment reference number
payee_name = :                                 ; Name of payee

{@travel_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Adjuster
; ───────────────────────────────────────────────────────────────────────────────
{.adjuster}
name = :                                       ; Claims adjuster's name
email = *@email                                ; Adjuster's email (confidential)
phone = *@phone                                ; Adjuster's phone (confidential)
assigned_date = date                           ; Date adjuster was assigned to claim

{@travel_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Claim Notes
; ───────────────────────────────────────────────────────────────────────────────
{.notes[]}
note_date = timestamp                          ; Timestamp when note was created
note_by = :                                    ; Person who created the note
note_text = :                                  ; Content of the note
note_type = (adjuster, claimant, system)       ; Type of note

{@travel_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Appeal
; ───────────────────────────────────────────────────────────────────────────────
{.appeal}
appeal_date = date                             ; Date appeal was filed
appeal_reason = :                              ; Reason for appeal
appeal_status = (approved, denied, pending, submitted) ; Status of the appeal
appeal_decision_date = date                    ; Date of appeal decision
appeal_decision_reason = :                     ; Reason for appeal decision

{@travel_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Timestamps
; ───────────────────────────────────────────────────────────────────────────────
created = timestamp                            ; Timestamp when claim was created
modified = timestamp                           ; Timestamp when claim was last modified


; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Commercial Auto Fleet & Motor Carrier Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Fleet management, motor carrier registration, DOT/FMCSA compliance, terminal
; operations, and cargo/commodity classifications for commercial auto.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.auto.fleet"
version = "1.0.0"
title = "Commercial Auto Fleet & Motor Carrier Schema"
description = "Fleet management, DOT/FMCSA compliance, and motor carrier operations"

{$derivation}
source[0].authority = "Federal Motor Carrier Safety Administration"
source[0].citation = "49 CFR Part 387 - Minimum Levels of Financial Responsibility"
source[0].url = "https://www.fmcsa.dot.gov/registration/insurance-filing-requirements"

source[1].authority = "Federal Motor Carrier Safety Administration"
source[1].citation = "49 CFR Part 390 - General Motor Carrier Requirements"
source[1].url = "https://www.ecfr.gov/current/title-49/subtitle-B/chapter-III/subchapter-B/part-390"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "FMCSA requirements per federal regulations; industry-standard fleet structures"

changelog[0].date = 2025-12-13
changelog[0].change = "Initial commercial fleet schema"
changelog[0].rationale = "DOT/FMCSA compliance requirements for commercial motor carriers"

; ═══════════════════════════════════════════════════════════════════════════════
; Motor Carrier Registration
; ═══════════════════════════════════════════════════════════════════════════════
; DOT/FMCSA registration and operating authority

{@motor_carrier}
carrier_id = :

; DOT Registration
{.dot}
last_update = date
number = :                                    ; USDOT number (7-8 digits)
registration_date = date
status = (active, inactive, not_authorized, out_of_service)

{@motor_carrier}
; MC/MX/FF Numbers (Operating Authority)
{.mc}
effective_date = date
number = :                                     ; Motor Carrier number
status = (active, inactive, pending, revoked)
type = (FF, MC, MX)                            ; MC=carrier, MX=broker, FF=freight forwarder

{@motor_carrier}

; Carrier Classification (per FMCSA)
carrier_type = (
    exempt_for_hire,                           ; Exempt for-hire
    federal_government,                        ; Federal government
    for_hire_passenger,                        ; For-hire passenger carrier
    for_hire_property,                         ; For-hire property carrier
    indian_tribe,                              ; Indian tribe
    local_government,                          ; Local government
    private_passenger,                         ; Private passenger carrier
    private_property,                          ; Private property carrier
    state_government,                          ; State government
    us_mail                                    ; US Mail carrier
)

; Interstate/Intrastate
authorized_states[] = :(2)                     ; States authorized to operate
operation_type = (both, interstate, intrastate)

; Entity Type
business_name = :
dba_name = :
ein = *:(9)                                    ; Employer Identification Number (confidential)
entity_type = (corporation, llc, other, partnership, sole_proprietor)

; Primary Contact
contact_ref = :                               ; Reference to person ID

{@motor_carrier}
; Principal Address - uses shared @address type (US and Canada)
address = @address

{@motor_carrier}
; Mailing Address (if different)
mailing_address = @address                     ; Mailing address if different from principal
same_as_principal = ?                          ; Mailing same as principal address

{@motor_carrier}

; ═══════════════════════════════════════════════════════════════════════════════
; FMCSA Insurance Filings
; ═══════════════════════════════════════════════════════════════════════════════
; Required insurance forms and filings

{@fmcsa_filing}
filing_id = :
filing_type = (
    BMC_34,                                    ; Motor Carrier Cargo Insurance
    BMC_83,                                    ; Motor Carrier Surety Bond (cargo)
    BMC_84,                                    ; Broker Surety Bond
    BMC_85,                                    ; Broker Trust Fund Agreement
    BMC_91,                                    ; Motor Carrier Automobile Liability
    BMC_91X,                                   ; Motor Carrier Automobile Liability (alt)
    BOC_3,                                     ; Designation of Process Agent
    MCS_82,                                    ; Motor Carrier Surety Bond
    MCS_90                                     ; Motor Carrier Endorsement
)
effective_date = date

; Filing Details
acceptance_date = date
cancellation_date = date
expiration_date = date
filing_date = date
policy_number = :                              ; Policy number

; Insurance Company
insurer_ref = :                              ; Reference to carrier.schema.odin

; Coverage Amounts (per FMCSA minimums)
bond_amount = #$:(0..)
cargo_limit = #$:(0..)
liability_limit = #$:(0..)

; Status
rejection_reason = ::if status = rejected
status = (active, cancelled, expired, pending, rejected)

; ═══════════════════════════════════════════════════════════════════════════════
; Fleet Information
; ═══════════════════════════════════════════════════════════════════════════════
; Fleet composition and vehicle counts

{@fleet_info}
fleet_id = :
fleet_name = :

; Vehicle Counts by Ownership
{.vehicles}
hired = ##                                     ; Hired with driver
leased_long_term = ##                          ; > 30 days
leased_trip = ##                               ; Trip lease
non_owned = ##                                 ; Employee-owned used for business
owned = ##
total = ##

; Vehicle Counts by Radius
intermediate_radius = ##                       ; 50-200 miles
local_radius = ##                              ; < 50 miles
long_distance_radius = ##                      ; > 200 miles

; Vehicle Counts by Type
bus_count = ##                                 ; Number of buses
pickup_count = ##                              ; Number of pickups
power_unit_count = ##                          ; Number of power units (tractors, trucks)
trailer_count = ##                             ; Number of trailers
van_count = ##                                 ; Number of vans

{@fleet_info}
; Driver Counts
{.drivers}
company_driver_count = ##                      ; Number of company drivers
leased_driver_count = ##                       ; Number of leased drivers
owner_operator_count = ##                      ; Number of owner-operators
total = ##                                     ; Total driver count

{@fleet_info}
; Fleet Discount Eligibility
fleet_discount_eligible = ?
fleet_discount_vehicle_count = ##

; ═══════════════════════════════════════════════════════════════════════════════
; Terminal / Operating Location
; ═══════════════════════════════════════════════════════════════════════════════
; Physical operating locations for fleet

{@terminal}
terminal_id = :
terminal_name = :
terminal_number = ##:(1..)

; Location - uses shared @address type (US and Canada)
address = @address

{@terminal}
; Coordinates
latitude = #:(-90..90)
longitude = #:(-180..180)

; Terminal Type
primary = ?                                    ; Is primary terminal
terminal_type = (branch, customer, drop_yard, headquarters, satellite, yard)

; Vehicles Based Here
driver_count = ##                              ; Drivers based at terminal
vehicle_count = ##                             ; Vehicles based at terminal

; Distance from Primary
distance_from_headquarters = ##                ; Miles
distance_measurement = (air_miles, road_miles)

; Operating Zone
territory_code = :
zone_code = :

; Status
closed_date = date
effective_date = date
status = (active, closed, inactive)

; ═══════════════════════════════════════════════════════════════════════════════
; Zone / Radius of Operation
; ═══════════════════════════════════════════════════════════════════════════════
; Operating radius and zone classifications

{@operating_zone}
zone_code = :
zone_id = :
zone_name = :

; Radius Classification
radius_type = (
    intermediate,                              ; 50-200 miles
    local,                                     ; < 50 miles from terminal
    long_haul,                                 ; > 500 miles
    nationwide,                                ; No radius restriction
    regional                                   ; 200-500 miles
)

; Distance Limits
farthest_terminal_distance = ##
max_radius_miles = ##

; States/Provinces Operated (US states or Canadian provinces)
primary_state_province = :(2)
states_provinces_operated[] = :(2)

; Zone Premium Factors
zone_factor = #:(0..10)

; ═══════════════════════════════════════════════════════════════════════════════
; Commodity / Cargo Types
; ═══════════════════════════════════════════════════════════════════════════════
; What the carrier hauls

{@commodity}
commodity_id = :
sequence = ##:(1..)
commodity_class = (
    agricultural_equipment,
    beverages,
    building_materials,
    chemicals,
    coal,
    commodities_dry_bulk,
    construction,
    drive_away_tow_away,
    fresh_produce,
    garbage_refuse,
    general_freight,
    grain,
    household_goods,
    intermodal_containers,
    liquids_bulk,
    livestock,
    logs_poles_lumber,
    machinery,
    meat,
    metal_sheets_coils,
    mobile_homes,
    motor_vehicles,
    oilfield_equipment,
    other,
    paper_products,
    passengers,
    refrigerated_food,
    us_mail,
    utilities,
    water_well
)

; Classification
commodity_code = :
commodity_description = :

; Hazmat Classification
hazmat = ?                                     ; Is hazardous material
hazmat_class = ::if hazmat = true              ; DOT hazmat class
hazmat_placard_required = ?:if hazmat = true   ; Placard required
hazmat_un_number = :(4):if hazmat = true       ; UN identification number

; Revenue Percentage
primary = ?                                    ; Is primary commodity
revenue_percent = ##:(0..100)                  ; Percentage of total revenue from this commodity

; Value
average_load_value = #$:(0..)
max_load_value = #$:(0..)

; ═══════════════════════════════════════════════════════════════════════════════
; Trailer Interchange Agreement
; ═══════════════════════════════════════════════════════════════════════════════
; Equipment interchange between carriers

{@trailer_interchange}
interchange_id = :

; Agreement Details
agreement_type = (implied, verbal, written)
partner_carrier = :
partner_dot_number = :                         ; Partner DOT number (7-8 digits)
partner_mc_number = :                          ; Partner MC number

; Coverage
coverage_type = (full, none, specified_perils)
deductible = ##
interchange_coverage = ?

; Equipment
max_trailers_interchanged = ##
trailer_types[] = (container, dry_van, flatbed, other, reefer, tanker)

; Period
effective_date = date
expiration_date = date

; ═══════════════════════════════════════════════════════════════════════════════
; Hired Auto / Non-Owned Auto Details
; ═══════════════════════════════════════════════════════════════════════════════
; For hired and non-owned auto liability coverage

{@hired_auto_info}
info_id = :

; Hired Auto (rented/leased < 30 days)
{.hired}
annual_cost = #$:(0..)                         ; Annual cost of hired autos
class_code = :                                 ; Rating class code
physical_damage = ?                            ; Includes physical damage coverage
day_count = ##                                 ; Estimated hired days per year
vehicle_count = ##                             ; Number of vehicles

{@hired_auto_info}
; Non-Owned Auto (employee vehicles used for business)
{.non_owned}
class_code = :                                 ; Rating class code
employee_count = ##                            ; Total employee count
employee_auto_count = ##                       ; Employees using personal autos
percent_using_autos = ##:(0..100)              ; Percentage using autos
social_service_agency = ?                      ; Is social service agency
volunteers = ?                                 ; Volunteers included

{@hired_auto_info}
; Drive Other Car (named individuals)
{.doc}
class_code = :                                 ; Rating class code
included = ?                                   ; DOC coverage included
individual_count = ##:(0..)                    ; Number of covered individuals

{@hired_auto_info}

; ═══════════════════════════════════════════════════════════════════════════════
; Safety / Compliance Programs
; ═══════════════════════════════════════════════════════════════════════════════
; Fleet safety programs and compliance indicators

{@safety_program}
program_id = :

; Driver Qualification
driver_drug_testing = ?
driver_mvr_verification = ?
driver_physicals_required = ?
driver_recruiting_standards = ?
driver_road_test_required = ?
driver_training_program = ?

; Vehicle Maintenance
preventive_maintenance_schedule = ?
vehicle_inspection_program = ?
vehicle_maintenance_program = ?

; Electronic Monitoring
dash_cameras = ?
eld_vendor = :                                 ; ELD vendor name
electronic_logging_device = ?
gps_tracking = ?
gps_vendor = :                                 ; GPS vendor name
telematics_program = ?

; Safety Ratings
{.csa_score}
controlled_substances = ##:(0..100)
crash_indicator = ##:(0..100)
driver_fitness = ##:(0..100)
hazmat_compliance = ##:(0..100)
hours_of_service = ##:(0..100)
unsafe_driving = ##:(0..100)
vehicle_maintenance = ##:(0..100)

{@safety_program}
; FMCSA Safety Rating
safety_rating = (conditional, satisfactory, unrated, unsatisfactory)
safety_rating_date = date

; Out of Service Rates
{.oos_rate}
driver = #:(0..100)
hazmat = #:(0..100)
vehicle = #:(0..100)

{@safety_program}

; ═══════════════════════════════════════════════════════════════════════════════
; Revenue / Financials
; ═══════════════════════════════════════════════════════════════════════════════
; Carrier revenue for rating purposes

{@carrier_revenue}
revenue_id = :
period = (annual, monthly, quarterly)
period_end = date
period_start = date

; Gross Revenue
gross_receipts = #$:(0..)
gross_receipts_other = #$:(0..)
gross_receipts_trucking = #$:(0..)

; Revenue by Type
{.revenue}
for_hire = #$:(0..)
leasing = #$:(0..)
private = #$:(0..)

{@carrier_revenue}
; Mileage
empty_miles = ##
loaded_miles = ##
total_miles = ##

; Cost Basis (for hired auto)
hired_auto_cost = #$:(0..)

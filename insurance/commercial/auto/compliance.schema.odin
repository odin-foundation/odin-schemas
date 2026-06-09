; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Commercial Auto Federal Compliance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; DOT/FMCSA federal compliance requirements for commercial motor carriers including
; operating authority, safety ratings, BOC-3 filings, MCS-90/MCS-82 endorsements,
; hazmat compliance, UCR registration, and financial responsibility filings.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.auto.compliance"
version = "1.0.0"
title = "Commercial Auto Federal Compliance Schema"
description = "DOT/FMCSA hazmat and federal compliance requirements"

{$derivation}
source[0].authority = "Federal Motor Carrier Safety Administration"
source[0].citation = "49 CFR Part 387 - Minimum Levels of Financial Responsibility"
source[0].url = "https://www.fmcsa.dot.gov/registration/insurance-filing-requirements"

source[1].authority = "Pipeline and Hazardous Materials Safety Administration"
source[1].citation = "49 CFR Part 172 Subpart F - Placarding Requirements"
source[1].url = "https://www.ecfr.gov/current/title-49/subtitle-B/chapter-I/subchapter-C/part-172/subpart-F"

source[2].authority = "Federal Motor Carrier Safety Administration"
source[2].citation = "49 CFR Part 366 - Designation of Process Agents (BOC-3)"
source[2].url = "https://www.fmcsa.dot.gov/registration/form-boc-3-designation-agents-service-process"

source[3].authority = "Pipeline and Hazardous Materials Safety Administration"
source[3].citation = "PHMSA Hazmat Registration 2024-2025"
source[3].url = "https://www.phmsa.dot.gov/sites/phmsa.dot.gov/files/2024-04/Registration-Process-Brochure-2024-2025-Web-04-17-2024.pdf"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Federal hazmat transport and motor carrier compliance per DOT, FMCSA, PHMSA regulations"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial compliance schema for hazmat/DOT federal requirements"
changelog[0].rationale = "Comprehensive hazmat transport compliance per federal regulations"

; ═══════════════════════════════════════════════════════════════════════════════
; OPERATING AUTHORITY
; ═══════════════════════════════════════════════════════════════════════════════
; FMCSA operating authority registration and status

{@operating_authority}
authority_id = :

; ───────────────────────────────────────────────────────────────────────────────
; USDOT Number
; ───────────────────────────────────────────────────────────────────────────────
{.usdot}
number = :                                    ; USDOT number (7-8 digits)
registration_date = date                       ; Registration date
status = (active, inactive, not_authorized, out_of_service)  ; Current status
last_update = date                             ; Last update date

{@operating_authority}

; ───────────────────────────────────────────────────────────────────────────────
; MC/MX/FF Operating Authority Number
; ───────────────────────────────────────────────────────────────────────────────
{.mc_number}
number = :                                     ; MC, MX, or FF number
type = (FF, MC, MX)                            ; MC=carrier, MX=broker, FF=freight forwarder
status = (active, inactive, pending, revoked)
effective_date = date
grant_date = date
revocation_date = date:if status = revoked
revocation_reason = ::if status = revoked

{@operating_authority}

; ───────────────────────────────────────────────────────────────────────────────
; Authority Type
; ───────────────────────────────────────────────────────────────────────────────
; Common and contract authority merged since 2007
authority_type = (
    broker,                                    ; Property broker
    common_carrier,                            ; For-hire carrier (property or passenger)
    contract_carrier,                          ; Contract carrier (legacy - now same as common)
    freight_forwarder,                         ; Freight forwarder
    private_carrier                            ; Private carrier (no authority required but may have USDOT)
)

; ───────────────────────────────────────────────────────────────────────────────
; Interstate vs Intrastate
; ───────────────────────────────────────────────────────────────────────────────
operation_classification = (both, interstate, intrastate)  ; Operating classification
interstate = ?                                 ; Has interstate authority
intrastate = ?                                 ; Has intrastate authority
base_state = :(2)                              ; Primary state of operation

; ───────────────────────────────────────────────────────────────────────────────
; Operating States
; ───────────────────────────────────────────────────────────────────────────────
states_authorized[] = :(2)                     ; States authorized to operate
states_intrastate[] = :(2)                     ; States with intrastate authority

; ═══════════════════════════════════════════════════════════════════════════════
; SAFETY & COMPLIANCE RATINGS
; ═══════════════════════════════════════════════════════════════════════════════
; FMCSA Safety Measurement System (SMS) and compliance ratings

{@safety_rating}
rating_id = :

; ───────────────────────────────────────────────────────────────────────────────
; Overall Safety Rating
; ───────────────────────────────────────────────────────────────────────────────
overall_rating = (conditional, satisfactory, unrated, unsatisfactory)  ; Overall safety rating
rating_date = date                             ; Rating date
rating_expiration = date                       ; Rating expiration

; ───────────────────────────────────────────────────────────────────────────────
; Out of Service Rates
; ───────────────────────────────────────────────────────────────────────────────
{.out_of_service}
driver_oos_rate = #:(0..100)                   ; Driver out-of-service percentage
vehicle_oos_rate = #:(0..100)                  ; Vehicle out-of-service percentage
hazmat_oos_rate = #:(0..100)                   ; Hazmat-specific OOS rate
national_avg_driver = #:(0..100)
national_avg_vehicle = #:(0..100)

{@safety_rating}

; ───────────────────────────────────────────────────────────────────────────────
; BASIC Categories (Behavior Analysis and Safety Improvement Categories)
; ───────────────────────────────────────────────────────────────────────────────
; SMS/CSA BASIC scores (0-100, higher is worse)
{.basic_scores}
unsafe_driving = ##:(0..100)
crash_indicator = ##:(0..100)
hos_compliance = ##:(0..100)                   ; Hours of Service
vehicle_maintenance = ##:(0..100)
controlled_substances = ##:(0..100)            ; Drug/alcohol
hazmat_compliance = ##:(0..100)
driver_fitness = ##:(0..100)

{@safety_rating}

; ───────────────────────────────────────────────────────────────────────────────
; Inspection & Audit History
; ───────────────────────────────────────────────────────────────────────────────
{.inspection}
date = date                                    ; Last inspection date
result = (conditional, failed, passed)         ; Last inspection result
count_24mo = ##                                ; Total inspections in 24 months
violation_count = ##                           ; Inspections with violations

{@safety_rating}
{.audit}
date = date                                    ; Last audit date
type = (compliance_review, new_entrant, safety_audit)  ; Audit type
result = (conditional, satisfactory, unsatisfactory)  ; Audit result
next_scheduled = date                          ; Next scheduled audit

{@safety_rating}

; ───────────────────────────────────────────────────────────────────────────────
; Crash Data
; ───────────────────────────────────────────────────────────────────────────────
{.crashes}
count_24mo = ##                                ; Total crashes in 24 months
fatal_count_24mo = ##                          ; Fatal crashes in 24 months
injury_count_24mo = ##                         ; Injury crashes in 24 months
tow_count_24mo = ##                            ; Tow-away crashes in 24 months
rate_per_million_miles = #                     ; Crash rate per million miles

{@safety_rating}

; ───────────────────────────────────────────────────────────────────────────────
; Special Monitoring
; ───────────────────────────────────────────────────────────────────────────────
{.monitoring}
new_entrant = ?                                ; Subject to new entrant monitoring
entrant_expiration = date:if monitoring.new_entrant = true
imminent_hazard = ?                            ; Imminent hazard status
conditional_rating_improvement_plan = ?
safety_improvement_plan_required = ?

{@safety_rating}

; ═══════════════════════════════════════════════════════════════════════════════
; BOC-3 PROCESS AGENT
; ═══════════════════════════════════════════════════════════════════════════════
; Blanket of Coverage - Designation of process agents per state

{@boc3_filing}
filing_id = :
filing_status = (expired, filed, invalid, not_filed, pending)

; ───────────────────────────────────────────────────────────────────────────────
; Filing Status
; ───────────────────────────────────────────────────────────────────────────────
filing_required = ?                            ; Required for this carrier
filing_date = date:if filing_status = filed
effective_date = date:if filing_status = filed
expiration_date = date                         ; No statutory expiration but track updates

; ───────────────────────────────────────────────────────────────────────────────
; Filing Details
; ───────────────────────────────────────────────────────────────────────────────
form_number = :                                ; BOC-3 form reference
updated = date
updated_reason = :

; ───────────────────────────────────────────────────────────────────────────────
; Process Agent Service Provider
; ───────────────────────────────────────────────────────────────────────────────
{.agent_service}
provider_name = :                              ; Process agent service company
provider_contact = *@phone                     ; Confidential
provider_email = *@email                       ; Confidential
annual_fee = #$:(0..)                         ; Annual service fee

{@boc3_filing}

; ───────────────────────────────────────────────────────────────────────────────
; State-by-State Process Agents
; ───────────────────────────────────────────────────────────────────────────────
; Must have agent in each state where carrier operates
{.state_agents[]}
state = :(2)                                  ; US state code
agent_name = :                                ; Agent name
agent_address = @address                       ; Agent address (cannot be PO Box)
agent_phone = *@phone                          ; Agent phone (confidential)
designation_date = date                        ; Designation date

{@boc3_filing}

; ───────────────────────────────────────────────────────────────────────────────
; Compliance Status
; ───────────────────────────────────────────────────────────────────────────────
{.compliance}
all_states_covered = ?                         ; Agent in all operating states
missing_agent_states[] = :(2)                  ; States lacking designation
suspension_risk = ?                            ; At risk of authority suspension
suspension_notice_date = date                  ; Suspension notice date

{@boc3_filing}

; ═══════════════════════════════════════════════════════════════════════════════
; MCS-90 ENDORSEMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Endorsement for Motor Carrier Policies - Financial Responsibility

{@mcs90_endorsement}
id = :

; ───────────────────────────────────────────────────────────────────────────────
; Applicability
; ───────────────────────────────────────────────────────────────────────────────
required = ?                                   ; MCS-90 required for this carrier
requirement_basis = (for_hire_passenger, for_hire_property, hazmat)  ; Basis for requirement

; For-hire property carriers
for_hire_property = ?                          ; For-hire property carrier
min_limit_property = #$:(0..) "750000"         ; $750k minimum

; For-hire passenger carriers
for_hire_passenger = ?                         ; For-hire passenger carrier
min_limit_passenger = #$:(0..) "5000000"       ; $5M for 16+ passengers
seating_capacity = ##:if for_hire_passenger = true  ; Seating capacity

; Hazmat carriers
hazmat = ?                                     ; Hazmat carrier
min_limit_hazmat = #$:(0..)                    ; $1M-$5M depending on quantity/class

{@mcs90_endorsement}

; ───────────────────────────────────────────────────────────────────────────────
; MCS-82 Endorsement (Passenger Carriers)
; ───────────────────────────────────────────────────────────────────────────────
{.mcs82}
required = ?:if for_hire_passenger = true      ; MCS-82 required
surety_bond_amount = #$:(0..):if mcs82.required = true  ; Surety bond amount
bond_number = :if mcs82.required = true        ; Bond number
surety_company = :if mcs82.required = true     ; Surety company name
bond_effective = date:if mcs82.required = true ; Bond effective date

{@mcs90_endorsement}

; ───────────────────────────────────────────────────────────────────────────────
; Endorsement Filing
; ───────────────────────────────────────────────────────────────────────────────
{.filing}
filing_status = (cancelled, filed, not_filed, pending)
filing_date = date
effective_date = date
cancellation_date = date
policy_number = :

{@mcs90_endorsement}

; ───────────────────────────────────────────────────────────────────────────────
; Insurance Carrier
; ───────────────────────────────────────────────────────────────────────────────
insurer_ref = :                                ; Insurance carrier reference

{@mcs90_endorsement}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Limits
; ───────────────────────────────────────────────────────────────────────────────
{.limits}
policy_limit = #$:(0..)                       ; Policy limit
each_occurrence = #$:(0..)                     ; Each occurrence limit
aggregate = #$:(0..)                           ; Aggregate limit
meets_minimum = ?                              ; Meets FMCSA minimum

{@mcs90_endorsement}

; ═══════════════════════════════════════════════════════════════════════════════
; HAZMAT COMPLIANCE
; ═══════════════════════════════════════════════════════════════════════════════
; DOT/PHMSA hazardous materials transportation compliance

{@hazmat_compliance}
compliance_id = :
hazmat = ?                                    ; Authorized to haul hazmat

; ───────────────────────────────────────────────────────────────────────────────
; Hazmat Authority
; ───────────────────────────────────────────────────────────────────────────────
authorization_date = date:if hazmat = true     ; Authorization date

; ───────────────────────────────────────────────────────────────────────────────
; PHMSA Registration
; ───────────────────────────────────────────────────────────────────────────────
{.phmsa_registration}
registered = ?
registration_number = ::if phmsa_registration.registered = true
registration_year = ##:(2020..2030):if phmsa_registration.registered = true
registration_expiration = date:if phmsa_registration.registered = true
registration_fee_paid = #$:(0..):if phmsa_registration.registered = true
annual_renewal_required = ?

{@hazmat_compliance}

; ───────────────────────────────────────────────────────────────────────────────
; Hazmat Safety Permit
; ───────────────────────────────────────────────────────────────────────────────
{.safety_permit}
permit_required = ?                            ; Required for certain quantities/classes
permit_number = ::if safety_permit.permit_required = true
permit_issued = date:if safety_permit.permit_required = true
permit_expiration = date:if safety_permit.permit_required = true
permit_status = (active, expired, pending, revoked):if safety_permit.permit_required = true

{@hazmat_compliance}

; ───────────────────────────────────────────────────────────────────────────────
; DOT Hazmat Classes Hauled
; ───────────────────────────────────────────────────────────────────────────────
; Per 49 CFR 173.2 - Nine classes of hazardous materials
{.classes_hauled}
class_1_explosives = ?
class_1_division_1_1 = ?:if classes_hauled.class_1_explosives = true    ; Mass explosion hazard
class_1_division_1_2 = ?:if classes_hauled.class_1_explosives = true    ; Projection hazard
class_1_division_1_3 = ?:if classes_hauled.class_1_explosives = true    ; Fire hazard
class_1_division_1_4 = ?:if classes_hauled.class_1_explosives = true    ; Minor blast hazard
class_1_division_1_5 = ?:if classes_hauled.class_1_explosives = true    ; Very insensitive
class_1_division_1_6 = ?:if classes_hauled.class_1_explosives = true    ; Extremely insensitive

class_2_gases = ?
class_2_division_2_1_flammable = ?:if classes_hauled.class_2_gases = true
class_2_division_2_2_nonflammable = ?:if classes_hauled.class_2_gases = true
class_2_division_2_3_toxic = ?:if classes_hauled.class_2_gases = true

class_3_flammable_liquids = ?

class_4_flammable_solids = ?
class_4_division_4_1_flammable_solids = ?:if classes_hauled.class_4_flammable_solids = true
class_4_division_4_2_spontaneous_combustion = ?:if classes_hauled.class_4_flammable_solids = true
class_4_division_4_3_dangerous_when_wet = ?:if classes_hauled.class_4_flammable_solids = true

class_5_oxidizers = ?
class_5_division_5_1_oxidizers = ?:if classes_hauled.class_5_oxidizers = true
class_5_division_5_2_organic_peroxides = ?:if classes_hauled.class_5_oxidizers = true

class_6_toxic = ?
class_6_division_6_1_toxic_substances = ?:if classes_hauled.class_6_toxic = true
class_6_division_6_2_infectious = ?:if classes_hauled.class_6_toxic = true

class_7_radioactive = ?

class_8_corrosives = ?

class_9_miscellaneous = ?

{@hazmat_compliance}

; ───────────────────────────────────────────────────────────────────────────────
; Specific Materials Hauled
; ───────────────────────────────────────────────────────────────────────────────
{.materials[]}
un_na_number = :                              ; UN/NA identification number (4-5 digits)
proper_shipping_name = :
hazard_class = :                              ; Primary class (1-3 chars)
packing_group = (I, II, III)                   ; I=great danger, II=medium, III=minor
placard_required = ?
reportable_quantity = ?                        ; RQ threshold material
quantity_hauled = :                            ; Typical quantity description

{@hazmat_compliance}

; ───────────────────────────────────────────────────────────────────────────────
; Placarding Requirements
; ───────────────────────────────────────────────────────────────────────────────
{.placarding}
placarding_required = ?
placard_types_used[] = :                       ; Types of placards displayed
table_1_materials = ?                          ; Any quantity requires placards
table_2_materials = ?                          ; 1,001+ lbs requires placards
aggregate_threshold_met = ?                    ; 1,001 lbs aggregate for Table 2
dangerous_placard_used = ?                     ; DANGEROUS placard for mixed loads

{@hazmat_compliance}

; ───────────────────────────────────────────────────────────────────────────────
; Employee Training
; ───────────────────────────────────────────────────────────────────────────────
{.training}
employee_training_program = ?
training_frequency = (annual, initial, triennial)
last_training_date = date
next_training_due = date
training_records_maintained = ?
training_provider = :

{@hazmat_compliance}

; ───────────────────────────────────────────────────────────────────────────────
; Security Plan
; ───────────────────────────────────────────────────────────────────────────────
{.security_plan}
security_plan_required = ?                     ; Required for certain hazmat
security_plan_documented = ?:if security_plan.security_plan_required = true
plan_last_reviewed = date:if security_plan.security_plan_required = true
plan_next_review = date:if security_plan.security_plan_required = true
security_aware_training = ?:if security_plan.security_plan_required = true

{@hazmat_compliance}

; ───────────────────────────────────────────────────────────────────────────────
; Driver Qualifications
; ───────────────────────────────────────────────────────────────────────────────
{.driver_requirements}
cdl_hazmat_endorsement = ?                     ; CDL hazmat endorsement required
hazmat_driver_count = ##                       ; Drivers with hazmat endorsement
tsa_background_check = ?                       ; TSA background check required
background_check_frequency = (every_5_years, initial):if driver_requirements.tsa_background_check = true

{@hazmat_compliance}

; ───────────────────────────────────────────────────────────────────────────────
; Compliance Status
; ───────────────────────────────────────────────────────────────────────────────
{.compliance_status}
compliant = ?                                  ; Currently compliant
violation_count_24mo = ##                      ; Violations in 24 months
unresolved_violation_count = ##                ; Unresolved violations
last_hazmat_inspection = date                  ; Last hazmat inspection date
last_inspection_result = (conditional, failed, passed)  ; Last inspection result
corrective_actions_required = ?                ; Corrective actions required

{@hazmat_compliance}

; ═══════════════════════════════════════════════════════════════════════════════
; UNIFIED CARRIER REGISTRATION (UCR)
; ═══════════════════════════════════════════════════════════════════════════════
; Annual interstate carrier registration and fee payment

{@ucr_registration}
registration_id = :
registration_year = ##:(2020..2030)
registration_status = (expired, not_registered, pending, registered)

; ───────────────────────────────────────────────────────────────────────────────
; Registration Year
; ───────────────────────────────────────────────────────────────────────────────
registration_date = date:if registration_status = registered
confirmation_number = ::if registration_status = registered

; ───────────────────────────────────────────────────────────────────────────────
; Base State
; ───────────────────────────────────────────────────────────────────────────────
base_state = :(2)                             ; State where UCR filed
base_state_account = :                         ; UCR account number

; ───────────────────────────────────────────────────────────────────────────────
; Fleet Size & Fee Bracket
; ───────────────────────────────────────────────────────────────────────────────
{.fleet}
vehicle_count = ##                            ; Total power units (no trailers)
fee_bracket = (
    bracket_0_2,                               ; 0-2 vehicles
    bracket_1001_plus,                         ; 1001+ vehicles
    bracket_101_1000,                          ; 101-1000 vehicles
    bracket_21_100,                            ; 21-100 vehicles
    bracket_3_5,                               ; 3-5 vehicles
    bracket_6_20                               ; 6-20 vehicles
)

{@ucr_registration}

; ───────────────────────────────────────────────────────────────────────────────
; Fee Payment (2025 rates)
; ───────────────────────────────────────────────────────────────────────────────
{.payment}
fee_amount = #$:(0..)                         ; Fee amount
payment_date = date                            ; Payment date
payment_method = (ach, check, credit_card)     ; Payment method
payment_reference = :                          ; Payment reference number
payment_status = (failed, paid, pending, refunded)  ; Payment status

{@ucr_registration}

; ───────────────────────────────────────────────────────────────────────────────
; Enforcement & Compliance
; ───────────────────────────────────────────────────────────────────────────────
{.enforcement}
enforcement_active = ?                         ; UCR enforcement in effect
proof_of_payment_available = ?
no_proof_required_in_vehicle = ?               ; UCR does not require vehicle proof
renewal_reminder_sent = ?
renewal_due_date = date

{@ucr_registration}

; ═══════════════════════════════════════════════════════════════════════════════
; CARGO INSURANCE (BMC-34)
; ═══════════════════════════════════════════════════════════════════════════════
; Motor carrier cargo liability insurance filing

{@cargo_insurance}
insurance_id = :

; ───────────────────────────────────────────────────────────────────────────────
; BMC-34 Filing
; ───────────────────────────────────────────────────────────────────────────────
{.bmc34_filing}
filing_required = ?                            ; Required for common/contract carriers
filing_status = (cancelled, filed, not_filed, pending)
filing_date = date:if bmc34_filing.filing_status = filed
form_number = ::if bmc34_filing.filing_status = filed

{@cargo_insurance}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Details
; ───────────────────────────────────────────────────────────────────────────────
{.coverage}
coverage_limit = #$:(0..)                     ; Coverage limit
per_occurrence_limit = #$:(0..)                ; Per occurrence limit
aggregate_limit = #$:(0..)                     ; Aggregate limit
deductible = #$:(0..)                          ; Deductible amount

{@cargo_insurance}

; ───────────────────────────────────────────────────────────────────────────────
; Commodities Covered
; ───────────────────────────────────────────────────────────────────────────────
{.commodities}
general_freight = ?
refrigerated_goods = ?
hazmat = ?
high_value_goods = ?
specialized_cargo = ?

{@cargo_insurance}

; ───────────────────────────────────────────────────────────────────────────────
; Excluded Commodities
; ───────────────────────────────────────────────────────────────────────────────
{.exclusions}
exclusions_apply = ?
excluded_items[] = :

{@cargo_insurance}

; ───────────────────────────────────────────────────────────────────────────────
; Policy Information
; ───────────────────────────────────────────────────────────────────────────────
{.policy}
policy_number = :
effective_date = date
expiration_date = date
insurer_ref = :                               ; Reference to carrier.schema.odin
cancellation_date = date
cancellation_reason = :

{@cargo_insurance}

; ═══════════════════════════════════════════════════════════════════════════════
; FINANCIAL RESPONSIBILITY
; ═══════════════════════════════════════════════════════════════════════════════
; Overall financial responsibility compliance (BMC-91, BMC-91X, BMC-32)

{@financial_responsibility}
responsibility_id = :

; ───────────────────────────────────────────────────────────────────────────────
; Minimum Financial Responsibility Requirements
; ───────────────────────────────────────────────────────────────────────────────
{.requirements}
carrier_type = (broker, for_hire_passenger, for_hire_property, private_hazmat)
minimum_required = #$:(0..)                   ; Minimum required amount

; For-hire property: $750k minimum
property_minimum = #$:(0..) "750000":if requirements.carrier_type = for_hire_property

; For-hire passenger: $1.5M-$5M based on seating
passenger_minimum = #$:(0..):if requirements.carrier_type = for_hire_passenger
seating_capacity = ##:if requirements.carrier_type = for_hire_passenger

; Hazmat: $1M-$5M depending on class/quantity
hazmat_minimum = #$:(0..):if requirements.carrier_type = private_hazmat

; Broker: $75k surety bond
broker_bond_minimum = #$:(0..) "75000":if requirements.carrier_type = broker

{@financial_responsibility}

; ───────────────────────────────────────────────────────────────────────────────
; BMC-91 Surety Bond
; ───────────────────────────────────────────────────────────────────────────────
{.bmc91_bond}
filed = ?                                      ; Bond filed
bond_type = (BMC_91, BMC_91X):if bmc91_bond.filed = true  ; 91X is trust fund
bond_amount = #$:(0..):if bmc91_bond.filed = true  ; Bond amount
surety_company = :if bmc91_bond.filed = true   ; Surety company name
surety_naic = ::if bmc91_bond.filed = true     ; Surety NAIC code (5-6 digits)
bond_number = :if bmc91_bond.filed = true      ; Bond number
effective = date:if bmc91_bond.filed = true    ; Effective date
expiration = date:if bmc91_bond.filed = true   ; Expiration date
filing_date = date:if bmc91_bond.filed = true  ; Filing date

{@financial_responsibility}

; ───────────────────────────────────────────────────────────────────────────────
; BMC-32 Cargo Insurance Filing
; ───────────────────────────────────────────────────────────────────────────────
{.bmc32_cargo}
required = ?                                   ; Cargo filing required
filed = ?:if bmc32_cargo.required = true       ; BMC-32 filed
filing_date = date:if bmc32_cargo.filed = true ; Filing date
policy_number = :if bmc32_cargo.filed = true   ; Policy number
insurer_name = :if bmc32_cargo.filed = true    ; Insurer name

{@financial_responsibility}

; ───────────────────────────────────────────────────────────────────────────────
; Evidence of Insurance
; ───────────────────────────────────────────────────────────────────────────────
{.evidence}
insurance_on_file = ?                         ; Insurance on file
form_type = (BMC_91, BMC_91X, MCS_90)          ; Form type
filing_date = date                             ; Filing date
filing_accepted = ?                            ; Filing accepted
acceptance_date = date                         ; Acceptance date
rejection_reason = :                           ; Rejection reason if filing rejected

{@financial_responsibility}

; ───────────────────────────────────────────────────────────────────────────────
; Compliance Status
; ───────────────────────────────────────────────────────────────────────────────
{.compliance}
meets_minimum = ?                             ; Meets minimum requirements
deficiencies[] = :                             ; List of compliance deficiencies
corrective_action_required = ?                 ; Corrective action required
corrective_action_deadline = date              ; Corrective action deadline
suspension_risk = ?                            ; Suspension risk

{@financial_responsibility}

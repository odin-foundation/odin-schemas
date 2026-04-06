; ===================================================================================
; ODIN Automotive History Schema
; ===================================================================================
; Vehicle history including title chain, accidents, service records, recalls, and
; liens. Derived from NMVTIS, NHTSA recalls database, and UCC Article 9.
; ===================================================================================

@import "../common/vehicle.schema.odin" as vehicle
@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.automotive.history"
version = "1.0.0"
title = "Automotive History Schema"
description = "Vehicle history including title chain, accidents, service records, recalls, and liens"

{$derivation}
source[0].authority = "National Motor Vehicle Title Information System"
source[0].citation = "NMVTIS Consumer Access Product Standards"
source[0].url = "https://vehiclehistory.bja.ojp.gov/"

source[1].authority = "National Highway Traffic Safety Administration"
source[1].citation = "NHTSA Recalls Database API"
source[1].url = "https://www.nhtsa.gov/recalls"

source[2].authority = "Uniform Law Commission"
source[2].citation = "UCC Article 9 - Secured Transactions"
source[2].url = "https://www.uniformlaws.org/committees/community-home?communitykey=a34e7b9c-df54-4363-81f3-ed9e36693a71"

source[3].authority = "National Insurance Crime Bureau"
source[3].citation = "NICB VINCheck Service"
source[3].url = "https://www.nicb.org/vincheck"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Vehicle history structures per NMVTIS, NHTSA, and UCC requirements"

changelog[0].date = 2025-12-21
changelog[0].change = "Initial automotive history schema"
changelog[0].rationale = "Structures derived from NMVTIS and NHTSA requirements"

; ===================================================================================
; TITLE HISTORY
; ===================================================================================
; Complete title chain per NMVTIS standards.

{@title_history}
; Required fields first
vin = !*:format vin                              ; Vehicle VIN
report_date = !date                              ; Date of history report

; Title events
events[] = @title_event                          ; Title events in chronological order

; Summary
{.summary}
total_owners = ##:(0..)                          ; Total owners
total_title_states = ##:(0..)                    ; States titled in
branded = ?                                      ; Any brand on title
current_state = :(2)                             ; Current title state
current_title_number = :                         ; Current title number
current_status = (active, cancelled, duplicate, suspended)

{@title_history}

{@title_event}
; Required fields first
event_date = !date                               ; Event date
event_type = !(brand_added, brand_removed, duplicate_issued, lien_added, lien_released, new_title, title_transfer)
state = !:(2)                                    ; State where event occurred

; Title information
title_number = :                                 ; Title number
prior_title_number = :                           ; Prior title number

; Transfer details (for title_transfer)
{.transfer}
transfer_type = (auction, dealer, inheritance, lease_end, private, repossession):if event_type = title_transfer
odometer = ##:(0..):if event_type = title_transfer
odometer_type = (actual, discrepancy, exempt, not_actual):if event_type = title_transfer

{@title_event}

; Brand details (for brand_added/brand_removed)
{.brand}
brand_type = (
    bonded,
    flood,
    gray_market,
    hail,
    junk,
    lemon,
    manufacturer_buyback,
    odometer_discrepancy,
    odometer_exceeded,
    odometer_rollback,
    rebuilt,
    salvage,
    theft_recovery
):if event_type = brand_added|brand_removed

{@title_event}

; Lien details (for lien_added/lien_released)
{.lien}
lienholder = ::if event_type = lien_added|lien_released
lien_position = ##:(1..3):if event_type = lien_added|lien_released

{@title_event}

; ===================================================================================
; ACCIDENT RECORD
; ===================================================================================
; Accident and damage history.

{@accident_record}
; Required fields first
vin = !*:format vin                              ; Vehicle VIN
accident_date = !date                            ; Date of accident

; Location
{.location}
city = :                                         ; City
state = :(2)                                     ; State
country = :(2..3) "US"                           ; Country
description = :                                  ; Location description

{@accident_record}

; Accident details
{.details}
severity = !(major, minor, moderate, total_loss)
type = (collision, fire, flood, hail, other, rollover, theft, vandalism)
description = :                                  ; Accident description
police_report = ?                                ; Police report filed
police_report_number = :                         ; Report number

{@accident_record}

; Damage assessment
{.damage}
impact_area = (front, front_left, front_right, left, rear, rear_left, rear_right, right, roof, undercarriage)
airbags_deployed = ?                             ; Airbags deployed
structural_damage = ?                            ; Structural damage
frame_damage = ?                                 ; Frame damage
estimated_repair_cost = #$:(0..)                 ; Estimated repair cost
actual_repair_cost = #$:(0..)                    ; Actual repair cost

{@accident_record}

; Repair status
{.repair}
repaired = ?                                     ; Vehicle repaired
repair_date = date                               ; Date repaired
repair_shop = :                                  ; Repair facility name
repair_quality = (concours, excellent, fair, good, poor)
parts_used = (aftermarket, new_oem, reconditioned, salvage)

{@accident_record}

; Insurance claim
{.claim}
claim_filed = ?                                  ; Insurance claim filed
claim_number = *:                                ; Claim number
carrier = :                                      ; Insurance carrier
total_loss = ?                                   ; Declared total loss
payout_amount = #$:(0..)                         ; Insurance payout

{@accident_record}

; Source
{.source}
source_type = (carfax, insurance, law_enforcement, nmvtis, owner, repair_shop)
source_date = date                               ; Date reported
source_confidence = (confirmed, estimated, reported)

{@accident_record}

; ===================================================================================
; SERVICE RECORD
; ===================================================================================
; Maintenance and service history.

{@service_record}
; Required fields first
vin = !*:format vin                              ; Vehicle VIN
service_date = !date                             ; Date of service
odometer = !##:(0..)                             ; Odometer at service

; Service provider
{.provider}
name = !:                                        ; Service provider name
type = (dealer, fleet, independent, owner, specialty)
address = @address                               ; Provider address
phone = *@phone                                  ; Contact phone
license = :                                      ; Shop license number

{@service_record}

; Service type
{.service}
category = !(
    body_repair,
    brakes,
    electrical,
    emissions,
    engine,
    exhaust,
    hvac,
    inspection,
    maintenance,
    recall,
    suspension,
    tires,
    transmission,
    warranty
)
description = !:                                 ; Service description
work_order = :                                   ; Work order number
warranty_repair = ?                              ; Covered under warranty
recall_repair = ?                                ; Recall-related repair

{@service_record}

; Parts
parts[] = @service_part                          ; Parts used

; Labor
{.labor}
hours = #:(0..)                                  ; Labor hours
rate = #$:(0..)                                  ; Labor rate
total = #$:(0..)                                 ; Total labor cost

{@service_record}

; Totals
{.totals}
parts_cost = #$:(0..)                            ; Total parts cost
labor_cost = #$:(0..)                            ; Total labor cost
other_cost = #$:(0..)                            ; Other charges
tax = #$:(0..)                                   ; Tax
total_cost = #$:(0..)                            ; Total invoice

{@service_record}

; Payment
{.payment}
method = (cash, check, credit, financing, warranty)
invoice_number = :                               ; Invoice number
paid = ?                                         ; Paid in full

{@service_record}

; Technician
technician = :                                   ; Technician name
technician_certification = :                     ; ASE certification

{@service_part}
; Required fields first
part_number = !:                                 ; Part number
description = !:                                 ; Part description
quantity = ##:(1..)                              ; Quantity used

; Part details
part_type = (aftermarket, new_oem, reconditioned, remanufactured, used)
manufacturer = :                                 ; Part manufacturer
cost = #$:(0..)                                  ; Part cost each
extended = #$:(0..)                              ; Extended cost

; Warranty
warranty_months = ##:(0..)                       ; Part warranty period
warranty_miles = ##:(0..)                        ; Part warranty mileage

; ===================================================================================
; RECALL RECORD
; ===================================================================================
; NHTSA recall information per NHTSA Recalls API.

{@recall_record}
; Required fields first
vin = *:format vin                               ; Vehicle VIN (if specific)
nhtsa_campaign_number = !:                       ; NHTSA campaign number
manufacturer_campaign_number = :                 ; Manufacturer campaign number

; Recall information
{.recall}
component = !:                                   ; Component description
summary = !:                                     ; Defect summary
consequence = :                                  ; Safety consequence
remedy = :                                       ; Remedy description
notes = :                                        ; Additional notes

{@recall_record}

; Affected vehicles
{.affected}
make = :                                         ; Make
model = :                                        ; Model
year_start = ##:(1900..2100)                     ; Start model year
year_end = ##:(1900..2100)                       ; End model year
production_start = date                          ; Production start date
production_end = date                            ; Production end date
affected_count = ##:(0..)                        ; Total affected vehicles

{@recall_record}

; Dates
{.dates}
recall_date = date                               ; NHTSA recall date
manufacturer_notification = date                 ; Manufacturer notification date
owner_notification_date = date                   ; Owner notification date

{@recall_record}

; Completion status
{.completion}
completed = ?                                    ; Recall completed
completion_date = date                           ; Date completed
completion_mileage = ##:(0..)                    ; Odometer at completion
dealer_name = :                                  ; Completing dealer
work_order = :                                   ; Work order number

{@recall_record}

; Investigation
{.investigation}
investigation_number = :                         ; NHTSA investigation number
related_tsb = :                                  ; Related TSB numbers

{@recall_record}

; ===================================================================================
; TECHNICAL SERVICE BULLETIN
; ===================================================================================
; Manufacturer technical service bulletins.

{@tsb_record}
; Required fields first
tsb_number = !:                                  ; TSB number
manufacturer = !:                                ; Manufacturer

; TSB information
{.bulletin}
issue_date = date                                ; TSB issue date
revision_date = date                             ; Revision date
revision_number = ##:(0..)                       ; Revision number
title = !:                                       ; TSB title
description = :                                  ; TSB description
cause = :                                        ; Cause description
correction = :                                   ; Correction procedure
labor_time = #:(0..)                             ; Labor time (hours)

{@tsb_record}

; Affected vehicles
{.affected}
make = :                                         ; Make
model = :                                        ; Model
year_start = ##:(1900..2100)                     ; Start model year
year_end = ##:(1900..2100)                       ; End model year
vin_pattern = :                                  ; VIN pattern if applicable

{@tsb_record}

; Component
{.component}
system = :                                       ; System affected
subsystem = :                                    ; Subsystem affected
symptom = :                                      ; Symptom description

{@tsb_record}

; Parts
parts_required[] = :                             ; Required part numbers
parts_superseded[] = :                           ; Superseded part numbers

; Warranty
{.warranty}
covered = ?                                      ; Covered under warranty
warranty_extension = ?                           ; Extends warranty coverage
extended_months = ##:(0..)                       ; Extended months
extended_miles = ##:(0..)                        ; Extended miles

{@tsb_record}

; ===================================================================================
; LIEN RECORD
; ===================================================================================
; Security interest and lien information per UCC Article 9.

{@lien_record}
; Required fields first
vin = !*:format vin                              ; Vehicle VIN
lien_type = !(floor_plan, lease, loan, tax)      ; Type of lien

; Lienholder
{.lienholder}
name = !:                                        ; Lienholder name
address = @address                               ; Lienholder address
phone = *@phone                                  ; Contact phone
ein = *:(9)                                      ; Employer ID (confidential)

{@lien_record}

; Lien details
{.lien}
lien_date = !date                                ; Lien origination date
position = ##:(1..3)                             ; Lien position
original_amount = #$:(0..)                       ; Original lien amount
current_balance = #$:(0..)                       ; Current balance
payment_amount = #$:(0..)                        ; Monthly payment

{@lien_record}

; Filing
{.filing}
filing_type = (elt, paper, ucc)                  ; Filing type
filing_number = :                                ; UCC filing number
filing_state = :(2)                              ; Filing state
filing_date = date                               ; Date filed
expiration_date = date                           ; Filing expiration

{@lien_record}

; Status
{.status}
status = !(active, paid, released, transferred)
release_date = date:if status = released|paid   ; Release date
release_method = (elt, letter, ucc_3):if status = released|paid
payoff_amount = #$:(0..):if status = active      ; Current payoff amount
payoff_valid_date = date:if status = active      ; Payoff valid through

{@lien_record}

; Account
{.account}
account_number = *:                              ; Account number (confidential)
contract_date = date                             ; Contract date
maturity_date = date                             ; Maturity date
delinquent = ?                                   ; Account delinquent
delinquent_amount = #$:(0..):if delinquent = true
delinquent_days = ##:(0..):if delinquent = true

{@lien_record}

; ===================================================================================
; THEFT RECORD
; ===================================================================================
; Theft and recovery history per NICB and NMVTIS.

{@theft_record}
; Required fields first
vin = !*:format vin                              ; Vehicle VIN
theft_date = !date                               ; Date of theft
status = !(active, recovered)                    ; Theft status

; Theft details
{.theft}
type = (carjacking, fraud, parts_theft, theft, unauthorized_use)
location_city = :                                ; City of theft
location_state = :(2)                            ; State of theft
reported_to = (insurance, law_enforcement, nicb, owner)

{@theft_record}

; Law enforcement
{.law_enforcement}
agency = :                                       ; Reporting agency
case_number = :                                  ; Case number
ncic_entry = ?                                   ; Entered in NCIC
ncic_date = date                                 ; NCIC entry date

{@theft_record}

; Recovery (if recovered)
{.recovery}
recovery_date = date:if status = recovered       ; Date recovered
recovery_location = ::if status = recovered      ; Recovery location
condition = (damaged, good, parts_only, stripped, total_loss):if status = recovered
damage_estimate = #$:(0..):if status = recovered ; Damage estimate

{@theft_record}

; Insurance
{.insurance}
claim_filed = ?                                  ; Insurance claim filed
claim_number = *:                                ; Claim number
carrier = :                                      ; Insurance carrier
payout = #$:(0..)                                ; Insurance payout

{@theft_record}

; ===================================================================================
; REGISTRATION HISTORY
; ===================================================================================
; Registration history by state.

{@registration_history}
; Required fields first
vin = !*:format vin                              ; Vehicle VIN
report_date = !date                              ; Report date

; Registration events
events[] = @registration_event                   ; Registration events

; Summary
{.summary}
total_registrations = ##:(0..)                   ; Total registrations
states_registered = ##:(0..)                     ; Number of states
first_registration_date = date                   ; First registration date
first_registration_state = :(2)                  ; First state
current_state = :(2)                             ; Current state
current_expiration = date                        ; Current expiration

{@registration_history}

{@registration_event}
; Required fields first
event_date = !date                               ; Event date
event_type = !(cancellation, expired, new, renewal, transfer)
state = !:(2)                                    ; Registration state

; Registration details
registration_number = :                          ; Registration number
plate_number = :                                 ; Plate number
expiration_date = date                           ; Expiration date
odometer = ##:(0..)                              ; Odometer reading

; Owner type
owner_type = (commercial, individual, lease)     ; Owner type

; ===================================================================================
; VEHICLE HISTORY REPORT
; ===================================================================================
; Comprehensive vehicle history report aggregating all history data.

{@vehicle_history_report}
; Required fields first
vin = !*:format vin                              ; Vehicle VIN
report_date = !timestamp                         ; Report generation date
report_id = !:                                   ; Report identifier

; Report source
{.source}
provider = (autocheck, carfax, nmvtis, other)    ; Report provider
report_type = (consumer, dealer, institutional)  ; Report type
expiration = date                                ; Report expiration

{@vehicle_history_report}

; Vehicle details
vehicle = @vehicle_identification                ; Vehicle identification

; History sections
title_history = @title_history                   ; Title history
accidents[] = @accident_record                   ; Accident records
service[] = @service_record                      ; Service records
recalls[] = @recall_record                       ; Recall records
liens[] = @lien_record                           ; Lien records
theft[] = @theft_record                          ; Theft records
registration_history = @registration_history     ; Registration history

; Summary scores
{.summary}
; Title issues
title_issues = ?                                 ; Title issues found
salvage_history = ?                              ; Salvage history
lemon_history = ?                                ; Lemon history
flood_history = ?                                ; Flood history

; Accident summary
accident_count = ##:(0..)                        ; Number of accidents
major_damage = ?                                 ; Major damage reported
structural_damage = ?                            ; Structural damage reported

; Odometer
odometer_problems = ?                            ; Odometer issues found
last_odometer = ##:(0..)                         ; Last reported odometer
last_odometer_date = date                        ; Date of last reading

; Other
theft_history = ?                                ; Theft history
open_recalls = ##:(0..)                          ; Open recall count
service_records = ##:(0..)                       ; Service record count
owners = ##:(0..)                                ; Owner count

{@vehicle_history_report}


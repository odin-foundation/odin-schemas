; ===================================================================================
; ODIN Automotive Vehicle Schema
; ===================================================================================
; Vehicle specification, title, registration, and odometer disclosure. Derived
; from state DMV requirements, NMVTIS, and federal regulations.
; ===================================================================================

@import "../common/vehicle.schema.odin" as vehicle
@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.automotive.vehicle"
version = "1.0.0"
title = "Automotive Vehicle Schema"
description = "Vehicle specification, title, registration, and odometer disclosure"

{$derivation}
source[0].authority = "National Highway Traffic Safety Administration"
source[0].citation = "49 CFR Part 565 - Vehicle Identification Number (VIN) Requirements"
source[0].url = "https://www.ecfr.gov/current/title-49/subtitle-B/chapter-V/part-565"

source[1].authority = "National Motor Vehicle Title Information System"
source[1].citation = "NMVTIS State Reporting Requirements"
source[1].url = "https://vehiclehistory.bja.ojp.gov/"

source[2].authority = "National Highway Traffic Safety Administration"
source[2].citation = "49 CFR Part 580 - Odometer Disclosure Requirements"
source[2].url = "https://www.ecfr.gov/current/title-49/subtitle-B/chapter-V/part-580"

source[3].authority = "American Association of Motor Vehicle Administrators"
source[3].citation = "AAMVA Vehicle Title and Registration Data Standards"
source[3].url = "https://www.aamva.org/technology"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Vehicle data structures per state DMV, NMVTIS, and federal requirements"

changelog[0].date = 2025-12-21
changelog[0].change = "Initial automotive vehicle schema"
changelog[0].rationale = "Structures derived from DMV and NMVTIS requirements"

; ===================================================================================
; VEHICLE SPECIFICATION
; ===================================================================================
; Complete vehicle specification combining identification, engine, EV, and dimensions.

{@vehicle_spec}
= @vehicle_identification                        ; Inherits core identification fields

; Serial numbers
chassis_serial = *:                              ; Chassis serial number
engine_serial = *:                               ; Engine serial number
transmission_serial = *:                         ; Transmission serial number

; Engine specification
engine = @engine_spec                            ; ICE engine specs

; EV specification
ev = @ev_spec                                    ; EV/hybrid specs

; Transmission
transmission = @transmission_spec                ; Transmission specs

; Fuel economy
fuel_economy = @fuel_economy                     ; EPA fuel economy

; Dimensions
dimensions = @vehicle_dimensions                 ; Physical dimensions

; Safety equipment
safety = @safety_equipment                       ; Safety features

; Anti-theft
antitheft = @antitheft_equipment                 ; Security features

; Weight ratings
{.weight}
curb_weight_lb = ##:(0..)                        ; Curb weight
gvwr_lb = ##:(0..)                               ; Gross Vehicle Weight Rating
gcwr_lb = ##:(0..)                               ; Gross Combined Weight Rating
gawr_front_lb = ##:(0..)                         ; Front axle rating
gawr_rear_lb = ##:(0..)                          ; Rear axle rating
payload_capacity_lb = ##:(0..)                   ; Payload capacity
towing_capacity_lb = ##:(0..)                    ; Towing capacity

{@vehicle_spec}

; Country of origin
assembly_plant = :                               ; Assembly plant name
assembly_country = :(2..3)                       ; Assembly country code
assembly_state = :(2)                            ; Assembly state/province

; ===================================================================================
; VEHICLE TITLE
; ===================================================================================
; Vehicle title document per state DMV requirements and NMVTIS.

{@vehicle_title}
; Required fields first
title_number = !:                                ; Title document number
state = !:(2)                                    ; Title issuing state
vin = !*:format vin                              ; Vehicle VIN

; Title status
{.status}
status = !(
    active,                                      ; Active/current title
    cancelled,                                   ; Title cancelled
    duplicate,                                   ; Duplicate issued
    electronic,                                  ; Electronic title (e-title)
    paper,                                       ; Paper title
    surrendered,                                 ; Surrendered to state
    suspended,                                   ; Title suspended
    transferred                                  ; Transferred to new owner
)
issue_date = date                                ; Title issue date
last_action_date = date                          ; Last action date

{@vehicle_title}

; Title brands (per NMVTIS)
{.brands}
salvage = ?                                      ; Salvage brand
rebuilt = ?                                      ; Rebuilt/reconstructed
flood = ?                                        ; Flood damage
hail = ?                                         ; Hail damage
lemon = ?                                        ; Lemon law buyback
junk = ?                                         ; Junk title
theft_recovery = ?                               ; Recovered theft
odometer_discrepancy = ?                         ; Odometer discrepancy
odometer_rollback = ?                            ; Odometer rollback
odometer_exceeded = ?                            ; Exceeds mechanical limits
damaged = ?                                      ; Damage disclosure
warranty_return = ?                              ; Warranty return
gray_market = ?                                  ; Gray market vehicle
manufacturer_buyback = ?                         ; Manufacturer buyback
bonded = ?                                       ; Bonded title
fire = ?                                         ; Fire damage
brand_date = date                                ; Date brand applied
brand_state = :(2)                               ; State that applied brand

{@vehicle_title}

; Vehicle information on title
{.vehicle}
year = ##:(1900..2100)                           ; Model year
make = :                                         ; Make
model = :                                        ; Model
body_type = :                                    ; Body type
color = :                                        ; Color
cylinders = ##                                   ; Number of cylinders
fuel_type = :                                    ; Fuel type
weight_lb = ##:(0..)                             ; Weight in pounds
gvwr_lb = ##:(0..)                               ; GVWR

{@vehicle_title}

; Owner information
{.owner}
owner_type = !(individual, organization)         ; Owner type
owner_name = :                                   ; Owner name (confidential on actual docs)
owner_count = ##:(1..)                           ; Number of owners on title
ownership_type = (and, individual, or)           ; Joint ownership type
address = @address                               ; Owner address

{@vehicle_title}

; Lien information
{.lien}
lien_recorded = ?                                ; Lien on title
lienholder_count = ##:(0..)                      ; Number of lienholders
first_lienholder = :                             ; First lienholder name
first_lien_date = date                           ; First lien recorded date
second_lienholder = :                            ; Second lienholder name
second_lien_date = date                          ; Second lien recorded date

{@vehicle_title}

; Odometer at title
{.odometer}
reading = ##:(0..)                               ; Odometer at title
reading_type = !(actual, discrepancy, exempt, not_actual)
disclosure_date = date                           ; Odometer disclosure date

{@vehicle_title}

; Prior title
{.prior_title}
state = :(2)                                     ; Prior title state
number = :                                       ; Prior title number
issue_date = date                                ; Prior title date

{@vehicle_title}

; ===================================================================================
; VEHICLE REGISTRATION
; ===================================================================================
; Vehicle registration per state DMV requirements.

{@vehicle_registration}
; Required fields first
registration_number = !:                         ; Registration ID/number
state = !:(2)                                    ; Registration state
vin = !*:format vin                              ; Vehicle VIN

; Registration status
{.status}
status = !(active, expired, pending, revoked, suspended, transferred)
effective_date = date                            ; Registration effective date
expiration_date = date                           ; Registration expiration date
renewal_eligible = ?                             ; Eligible for renewal

{@vehicle_registration}

; License plate
{.plate}
plate_number = :                                 ; License plate number
plate_type = (antique, commercial, disabled, farm, fleet, government, personalized, standard, temporary)
plate_issue_date = date                          ; Plate issue date
plate_expiration = date                          ; Plate expiration (may differ from reg)

{@vehicle_registration}

; Registered owner
{.owner}
owner_type = !(individual, organization)         ; Owner type
owner_name = :                                   ; Registered owner name
owner_count = ##:(1..)                           ; Owner count
address = @address                               ; Registration address

{@vehicle_registration}

; Vehicle use
use_type = (agricultural, commercial, emergency, government, personal, rental)
use_description = :                              ; Use description

; Registration class
class = :                                        ; Registration class code
class_description = :                            ; Class description
weight_class = :                                 ; Weight classification

; Fees
{.fees}
registration_fee = #$:(0..)                      ; Registration fee
title_fee = #$:(0..)                             ; Title fee if combined
plate_fee = #$:(0..)                             ; Plate fee
other_fees = #$:(0..)                            ; Other fees
total_due = #$:(0..)                             ; Total amount due

{@vehicle_registration}

; Emissions compliance
{.emissions}
required = ?                                     ; Emissions test required
compliant = ?                                    ; Currently compliant
last_test_date = date                            ; Last emissions test
next_test_due = date                             ; Next test due date
waiver = ?                                       ; Waiver granted
waiver_reason = :                                ; Waiver reason

{@vehicle_registration}

; Insurance verification
{.insurance}
verified = ?                                     ; Insurance verified
verification_date = date                         ; Verification date
policy_number = *:                               ; Policy number
carrier = :                                      ; Insurance carrier

{@vehicle_registration}

; ===================================================================================
; ODOMETER DISCLOSURE
; ===================================================================================
; Federal odometer disclosure per 49 CFR Part 580.

{@odometer_disclosure}
; Required fields first
vin = !*:format vin                              ; Vehicle VIN
reading = !##:(0..)                              ; Odometer reading
reading_date = !date                             ; Date of reading
disclosure_type = !(actual, discrepancy, exempt, not_actual)

; Disclosure context
disclosure_purpose = !(dealer_sale, lease_end, private_sale, repossession, title_transfer, trade_in)

; Exemptions (49 CFR 580.17)
exempt_reason = (
    heavy_vehicle,                               ; GVWR > 16,000 lbs
    model_year,                                  ; 20+ model years old
    new_vehicle,                                 ; New vehicle transfer
    non_self_propelled                           ; Trailers, etc.
):if disclosure_type = exempt

; Transferor (seller)
{.transferor}
name = !:                                        ; Transferor name
address = @address                               ; Transferor address
signature_date = date                            ; Date signed
printed_name = :                                 ; Printed name

{@odometer_disclosure}

; Transferee (buyer)
{.transferee}
name = !:                                        ; Transferee name
address = @address                               ; Transferee address
signature_date = date                            ; Date signed
printed_name = :                                 ; Printed name

{@odometer_disclosure}

; Discrepancy details
{.discrepancy}
prior_reading = ##:(0..):if disclosure_type = discrepancy|not_actual
prior_reading_date = date:if disclosure_type = discrepancy|not_actual
discrepancy_reason = (
    broken_odometer,
    odometer_replaced,
    repair_not_reset,
    rollback_suspected,
    unknown
):if disclosure_type = discrepancy|not_actual
investigation_required = ?:if disclosure_type = discrepancy|not_actual

{@odometer_disclosure}

; Witness/notarization
{.notarization}
notarized = ?                                    ; Notarization required
notary_name = :                                  ; Notary name
notary_date = date                               ; Notarization date
notary_commission = :                            ; Commission number
notary_state = :(2)                              ; Notary state

{@odometer_disclosure}

; ===================================================================================
; POWER OF ATTORNEY
; ===================================================================================
; Power of attorney for title/registration purposes.

{@vehicle_poa}
; Required fields first
vin = !*:format vin                              ; Vehicle VIN
poa_type = !(general, limited, secure)           ; POA type

; Grantor (vehicle owner)
{.grantor}
name = !:                                        ; Grantor name
address = @address                               ; Grantor address
signature_date = date                            ; Date signed

{@vehicle_poa}

; Grantee (authorized party)
{.grantee}
name = !:                                        ; Grantee name
address = @address                               ; Grantee address
relationship = (dealer, family, lender, other)   ; Relationship to owner

{@vehicle_poa}

; Authorization scope
{.scope}
title_application = ?                            ; Apply for title
title_transfer = ?                               ; Transfer title
registration = ?                                 ; Register vehicle
lien_release = ?                                 ; Release lien
duplicate_documents = ?                          ; Obtain duplicates
odometer_disclosure = ?                          ; Make odometer disclosure

{@vehicle_poa}

; Validity
{.validity}
effective_date = date                            ; POA effective date
expiration_date = date                           ; POA expiration
revoked = ?                                      ; POA revoked
revocation_date = date:if revoked = true         ; Revocation date

{@vehicle_poa}

; Notarization
{.notarization}
notarized = ?                                    ; Notarization required
notary_name = :                                  ; Notary name
notary_date = date                               ; Notarization date
notary_commission = :                            ; Commission number
notary_state = :(2)                              ; Notary state

{@vehicle_poa}

; ===================================================================================
; TEMPORARY PERMIT
; ===================================================================================
; Temporary operating permit (trip permit, transit permit, temp tag).

{@temporary_permit}
; Required fields first
permit_number = !:                               ; Permit number
permit_type = !(dealer, in_transit, temporary_registration, trip)
issuing_state = !:(2)                            ; Issuing state
vin = *:format vin                               ; Vehicle VIN (if assigned)

; Validity
effective_date = !date                           ; Permit start date
expiration_date = !date                          ; Permit end date
valid_days = ##:(1..90)                          ; Valid duration

; Trip permit specifics
{.trip}
origin_state = :(2):if permit_type = trip        ; Origin state
destination_state = :(2):if permit_type = trip   ; Destination state
route_description = ::if permit_type = trip      ; Route if required

{@temporary_permit}

; Vehicle information
{.vehicle}
year = ##:(1900..2100)                           ; Model year
make = :                                         ; Make
model = :                                        ; Model
body_type = :                                    ; Body type
weight_lb = ##:(0..)                             ; Weight

{@temporary_permit}

; Applicant
{.applicant}
name = :                                         ; Applicant name
address = @address                               ; Applicant address
phone = *@phone                                  ; Contact phone

{@temporary_permit}

; Fees
fee_amount = #$:(0..)                            ; Permit fee
payment_method = (cash, check, credit)           ; Payment method
receipt_number = :                               ; Payment receipt

; ===================================================================================
; VEHICLE IDENTIFICATION NUMBER ASSIGNMENT
; ===================================================================================
; Assigned VIN for vehicles without manufacturer VIN (kit cars, rebuilds, etc.).

{@vin_assignment}
; Required fields first
assigned_vin = !:format vin                      ; Assigned VIN
assignment_date = !date                          ; Date assigned
assigning_state = !:(2)                          ; State assigning VIN
assignment_reason = !(homemade, imported, kit_car, no_record, rebuilt, vin_destroyed, vin_missing)

; Prior identification
prior_vin = :                                    ; Prior VIN if any
chassis_number = :                               ; Chassis/frame number
engine_number = :                                ; Engine number

; Inspection
{.inspection}
inspection_date = date                           ; Inspection date
inspector = :                                    ; Inspector name/badge
inspection_location = :                          ; Inspection location
passed = ?                                       ; Inspection passed

{@vin_assignment}

; Vehicle details
{.vehicle}
year = ##:(1900..2100)                           ; Model year (assigned)
make = :                                         ; Make
model = :                                        ; Model
body_type = :                                    ; Body type
weight_lb = ##:(0..)                             ; Weight

{@vin_assignment}

; Documentation
photos_required = ?                              ; Photos required
photos_submitted = ?                             ; Photos submitted
bill_of_sale = ?                                 ; Bill of sale provided
receipt_for_parts = ?                            ; Parts receipts provided
affidavit = ?                                    ; Affidavit signed


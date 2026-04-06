; ===================================================================================
; ODIN Automotive Dealer Schema
; ===================================================================================
; Dealer licensing, inventory management, and floor plan financing. Derived from
; state dealer licensing regulations and industry practices.
; ===================================================================================

@import "../common/vehicle.schema.odin" as vehicle
@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.automotive.dealer"
version = "1.0.0"
title = "Automotive Dealer Schema"
description = "Dealer licensing, inventory management, and floor plan financing"

{$derivation}
source[0].authority = "National Automobile Dealers Association"
source[0].citation = "NADA Dealer Industry Guidelines"
source[0].url = "https://www.nada.org/"

source[1].authority = "American Association of Motor Vehicle Administrators"
source[1].citation = "AAMVA Dealer Licensing Guidelines"
source[1].url = "https://www.aamva.org/"

source[2].authority = "Federal Trade Commission"
source[2].citation = "FTC Dealer Advertising Guidelines"
source[2].url = "https://www.ftc.gov/business-guidance/resources/advertising-leasing-consumer-guide-dealers"

source[3].authority = "Uniform Commercial Code"
source[3].citation = "UCC Article 9 - Secured Transactions (Floor Plan Financing)"
source[3].url = "https://www.uniformlaws.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Dealer structures per state licensing regulations and NADA guidelines"

changelog[0].date = 2025-12-21
changelog[0].change = "Initial automotive dealer schema"
changelog[0].rationale = "Structures derived from state dealer regulations and NADA"

; ===================================================================================
; DEALER LICENSE
; ===================================================================================
; State dealer license per DMV/BMV requirements.

{@dealer_license}
; Required fields first
license_number = !*:                              ; Dealer license number
state = !:(2)                                    ; Licensing state
license_type = !(
    distributor,
    franchise_new,
    franchise_new_used,
    independent_used,
    manufacturer,
    motorcycle,
    recreational,
    salvage,
    trailer,
    wholesale
)

; Dealer information
{.dealer}
legal_name = !:                                  ; Legal business name
dba_name = :                                     ; DBA/trade name
ein = *:(9)                                      ; Employer ID Number
business_type = (corporation, llc, partnership, sole_proprietor)

{@dealer_license}

; Physical location
{.location}
address = @address                               ; Dealer address
lot_size_sqft = ##:(0..)                         ; Lot size
building_sqft = ##:(0..)                         ; Building size
vehicle_capacity = ##:(0..)                      ; Vehicle display capacity
service_bays = ##:(0..)                          ; Service bay count
county = :                                       ; County

{@dealer_license}

; Mailing address
mailing_address = @address                       ; Mailing if different

; Contact
{.contact}
phone = *@phone                                  ; Primary phone
fax = *@phone                                    ; Fax number
email = *@email                                  ; Email
website = :                                      ; Website URL

{@dealer_license}

; License status
{.status}
status = !(active, expired, pending, revoked, suspended)
issue_date = date                                ; Original issue date
effective_date = date                            ; Current license effective
expiration_date = date                           ; License expiration
renewal_date = date                              ; Last renewal date

{@dealer_license}

; Franchises (for franchise dealers)
franchises[] = @franchise_agreement              ; Franchise agreements

; Bond information
{.bond}
bond_required = ?                                ; Surety bond required
bond_amount = #$:(0..)                           ; Bond amount
bond_number = :                                  ; Bond number
bond_company = :                                 ; Surety company
bond_effective = date                            ; Bond effective date
bond_expiration = date                           ; Bond expiration

{@dealer_license}

; Principals/owners
principals[] = @dealer_principal                 ; Dealer principals

; Compliance
{.compliance}
background_check_completed = ?                   ; Background checks done
fingerprints_on_file = ?                         ; Fingerprints on file
training_completed = ?                           ; Required training done
continuing_education = ?                         ; CE requirements met
last_audit_date = date                           ; Last state audit
audit_result = (pass, fail, pending)             ; Audit result

{@dealer_license}

; Violations/disciplinary
{.disciplinary}
violations = ##:(0..)                            ; Violation count
pending_actions = ?                              ; Pending disciplinary
prior_revocation = ?                             ; Prior revocation
prior_suspension = ?                             ; Prior suspension

{@dealer_license}

; Fees
{.fees}
license_fee = #$:(0..)                           ; Annual license fee
renewal_fee = #$:(0..)                           ; Renewal fee
late_fee = #$:(0..)                              ; Late renewal fee
plate_fee_per_vehicle = #$:(0..)                 ; Dealer plate fee

{@dealer_license}

; Dealer plates
{.plates}
plates_issued = ##:(0..)                         ; Dealer plates issued
plate_numbers[] = :                              ; Plate numbers
demo_plates = ##:(0..)                           ; Demo plates
transporter_plates = ##:(0..)                    ; Transporter plates

{@dealer_license}

{@dealer_principal}
; Required fields first
principal_type = !(
    board_member,
    manager,
    officer,
    owner,
    partner
)
name = !:                                        ; Principal name
title = :                                        ; Title/position
ownership_percent = #:(0..100)                   ; Ownership percentage

; Identification
{.identification}
ssn = *:format ssn                               ; SSN (confidential)
date_of_birth = *date                            ; Date of birth
drivers_license = *:                             ; Driver license
dl_state = :(2)                                  ; DL state

{@dealer_principal}

; Address
address = @address                               ; Principal address

; Background
{.background}
background_check = ?                             ; Background checked
fingerprinted = ?                                ; Fingerprinted
prior_dealer_license = ?                         ; Prior dealer license
prior_violations = ?                             ; Prior violations
felony_conviction = ?                            ; Felony conviction

{@dealer_principal}

{@franchise_agreement}
; Required fields first
manufacturer = !:                                ; Manufacturer name
brand = !:                                       ; Brand/make
agreement_number = :                             ; Agreement number

; Status
{.status}
status = !(active, pending, terminated)
effective_date = date                            ; Agreement start
termination_date = date                          ; If terminated
renewal_date = date                              ; Next renewal

{@franchise_agreement}

; Sales requirements
{.requirements}
minimum_sales = ##:(0..)                         ; Minimum annual sales
minimum_inventory = ##:(0..)                     ; Minimum inventory
service_requirements = ?                         ; Service facility required
parts_requirements = ?                           ; Parts inventory required
facility_standards = ?                           ; Facility standards required
training_requirements = ?                        ; Training requirements

{@franchise_agreement}

; Territory
{.territory}
exclusive = ?                                    ; Exclusive territory
primary_market_area = :                          ; PMA definition
counties[] = :                                   ; Counties in territory
zip_codes[] = :                                  ; ZIP codes in territory

{@franchise_agreement}

; ===================================================================================
; DEALER INVENTORY
; ===================================================================================
; Dealer vehicle inventory management.

{@dealer_inventory}
; Required fields first
dealer_id = !:                                   ; Dealer identifier
inventory_date = !date                           ; Inventory as-of date

; Summary counts
{.summary}
total_units = ##:(0..)                           ; Total vehicles
new_units = ##:(0..)                             ; New vehicles
used_units = ##:(0..)                            ; Used vehicles
cpo_units = ##:(0..)                             ; CPO vehicles
wholesale_units = ##:(0..)                       ; Wholesale inventory
on_lot = ##:(0..)                                ; On lot
in_transit = ##:(0..)                            ; In transit
in_reconditioning = ##:(0..)                     ; In recon

{@dealer_inventory}

; Values
{.values}
total_cost = #$:(0..)                            ; Total inventory cost
total_msrp = #$:(0..)                            ; Total MSRP (new)
total_retail = #$:(0..)                          ; Total retail value
average_age_days = ##:(0..)                      ; Average days in stock
aged_units_60 = ##:(0..)                         ; Units 60+ days
aged_units_90 = ##:(0..)                         ; Units 90+ days

{@dealer_inventory}

; Vehicles
vehicles[] = @inventory_vehicle                  ; Individual vehicles

{@inventory_vehicle}
; Required fields first
stock_number = !:                                ; Stock number
vin = !*:format vin                              ; VIN
status = !(
    available,
    customer_order,
    hold,
    in_transit,
    pending_sale,
    reconditioning,
    sold,
    wholesale
)

; Vehicle details
{.vehicle}
new_used = !(new, used)                          ; New or used
year = ##:(1900..2100)                           ; Model year
make = :                                         ; Make
model = :                                        ; Model
trim = :                                         ; Trim level
color_exterior = :                               ; Exterior color
color_interior = :                               ; Interior color
odometer = ##:(0..)                              ; Odometer
fuel_type = :                                    ; Fuel type
transmission = :                                 ; Transmission
drive_type = :                                   ; Drive type

{@inventory_vehicle}

; Pricing
{.pricing}
invoice = #$:(0..):if new_used = new             ; Invoice (new)
msrp = #$:(0..):if new_used = new                ; MSRP (new)
cost = #$:(0..)                                  ; Dealer cost
asking_price = #$:(0..)                          ; Asking/list price
internet_price = #$:(0..)                        ; Internet price
floor_plan_cost = #$:(0..)                       ; Floor plan balance

{@inventory_vehicle}

; Acquisition
{.acquisition}
source = (auction, customer_trade, dealer_trade, factory_order, lease_return, manufacturer, wholesale)
acquisition_date = date                          ; Date acquired
days_in_stock = ##:(0..)                         ; Days in inventory
prior_owner_count = ##:(0..)                     ; Prior owners

{@inventory_vehicle}

; Reconditioning
{.reconditioning}
completed = ?                                    ; Recon completed
recon_cost = #$:(0..)                            ; Reconditioning cost
detail_cost = #$:(0..)                           ; Detail cost
repair_cost = #$:(0..)                           ; Repair cost
inspection_passed = ?                            ; Passed inspection

{@inventory_vehicle}

; Title
{.title}
title_status = (clear, pending, problem)         ; Title status
title_received = ?                               ; Title in hand
title_state = :(2)                               ; Title state
branded = ?                                      ; Title branded
brand_type = ::if branded = true                 ; Brand type

{@inventory_vehicle}

; Floor plan
{.floor_plan}
floored = ?                                      ; Floor plan financed
floor_plan_date = date:if floored = true         ; Floor plan date
curtailment_date = date:if floored = true        ; Curtailment due
floor_plan_balance = #$:(0..):if floored = true  ; Floor plan balance

{@inventory_vehicle}

; Location
location = (customer, detail, in_transit, lot, offsite, service, storage, wholesale)

; Certification
{.certification}
cpo = ?                                          ; CPO certified
cpo_program = ::if cpo = true                    ; CPO program name
cpo_warranty_months = ##:if cpo = true           ; CPO warranty
cpo_warranty_miles = ##:if cpo = true            ; CPO warranty miles

{@inventory_vehicle}

; ===================================================================================
; FLOOR PLAN FINANCING
; ===================================================================================
; Dealer floor plan (inventory financing) per UCC Article 9.

{@floor_plan}
; Required fields first
account_number = !*:                             ; Account number
dealer_id = !:                                   ; Dealer identifier

; Lender
{.lender}
lender_name = !:                                 ; Floor plan lender
lender_address = @address                        ; Lender address
lender_phone = *@phone                           ; Lender phone
account_manager = :                              ; Account manager

{@floor_plan}

; Dealer
{.dealer}
dealer_name = :                                  ; Dealer name
dealer_address = @address                        ; Dealer address

{@floor_plan}

; Credit facility
{.facility}
credit_line = #$:(0..)                           ; Total credit line
available_credit = #$:(0..)                      ; Available credit
outstanding_balance = #$:(0..)                   ; Current balance
vehicle_count = ##:(0..)                         ; Vehicles floored
average_cost = #$:(0..)                          ; Average vehicle cost

{@floor_plan}

; Terms
{.terms}
interest_rate = #.4                              ; Interest rate
rate_type = (fixed, variable)                    ; Rate type
index = ::if rate_type = variable               ; Index (Prime, SOFR)
spread = #.4:if rate_type = variable            ; Spread over index
free_floor_days = ##:(0..)                       ; Interest-free period
curtailment_days = ##:(0..)                      ; Days to first curtailment
full_payoff_days = ##:(0..)                      ; Days to full payoff

{@floor_plan}

; Fees
{.fees}
floor_plan_fee = #$:(0..)                        ; Per-vehicle floor fee
curtailment_fee = #$:(0..)                       ; Curtailment fee
late_fee = #$:(0..)                              ; Late payment fee
audit_fee = #$:(0..)                             ; Audit fee
monthly_minimum = #$:(0..)                       ; Minimum monthly fee

{@floor_plan}

; Curtailment schedule
{.curtailment}
schedule_type = (fixed, percentage)              ; Schedule type
curtailment_1_days = ##                          ; First curtailment
curtailment_1_percent = #:(0..100)               ; First curtailment %
curtailment_2_days = ##                          ; Second curtailment
curtailment_2_percent = #:(0..100)               ; Second curtailment %
curtailment_3_days = ##                          ; Third/final
curtailment_3_percent = #:(0..100)               ; Third curtailment %

{@floor_plan}

; Account status
{.status}
status = !(active, closed, default, suspended)
last_audit_date = date                           ; Last physical audit
audit_result = (discrepancy, pass)               ; Audit result
payment_status = (current, delinquent)           ; Payment status
days_past_due = ##:(0..)                         ; Days past due

{@floor_plan}

; Security
{.security}
personal_guarantee = ?                           ; Personal guarantee
guarantee_amount = #$:(0..)                      ; Guarantee amount
ucc_filing_number = :                            ; UCC-1 filing number
ucc_filing_state = :(2)                          ; Filing state
ucc_filing_date = date                           ; Filing date
subordination = ?                                ; Subordination agreement

{@floor_plan}

; Floored vehicles
vehicles[] = @floored_vehicle                    ; Floored vehicle list

{@floored_vehicle}
; Required fields first
vin = !*:format vin                              ; VIN
advance_amount = !#$:(0..)                       ; Amount advanced
floor_date = !date                               ; Date floored

; Vehicle details
{.vehicle}
stock_number = :                                 ; Stock number
year = ##:(1900..2100)                           ; Model year
make = :                                         ; Make
model = :                                        ; Model

{@floored_vehicle}

; Current status
{.status}
status = !(active, paid_off, sold)               ; Floor status
days_on_floor = ##:(0..)                         ; Days floored
current_balance = #$:(0..)                       ; Current balance
accrued_interest = #$:(0..)                      ; Accrued interest
curtailment_due = date                           ; Next curtailment
curtailment_amount = #$:(0..)                    ; Curtailment due

{@floored_vehicle}

; Payoff
{.payoff}
sale_date = date:if status = sold                ; Date sold
payoff_date = date:if status = paid_off          ; Payoff date
payoff_amount = #$:(0..):if status = paid_off    ; Amount paid
interest_paid = #$:(0..):if status = paid_off    ; Interest paid

{@floored_vehicle}

; ===================================================================================
; DEALER AUCTION
; ===================================================================================
; Wholesale auction transaction.

{@auction_transaction}
; Required fields first
transaction_id = !:                              ; Transaction identifier
auction_house = !:                               ; Auction company
auction_date = !date                             ; Auction date
vin = !*:format vin                              ; Vehicle VIN

; Transaction type
transaction_type = !(purchase, sale)             ; Buying or selling

; Auction location
{.auction}
location = :                                     ; Auction location
lane = :                                         ; Lane number
run_number = ##:(0..)                            ; Run number
sale_time = time                                 ; Sale time

{@auction_transaction}

; Vehicle
{.vehicle}
year = ##:(1900..2100)                           ; Model year
make = :                                         ; Make
model = :                                        ; Model
trim = :                                         ; Trim
odometer = ##:(0..)                              ; Odometer
condition_grade = #:(0..5)                       ; Condition grade
announcements[] = :                              ; Auction announcements
light_status = (green, red, yellow)              ; Auction light

{@auction_transaction}

; Pricing
{.pricing}
starting_bid = #$:(0..)                          ; Starting bid
winning_bid = #$:(0..)                           ; Hammer price
buy_fee = #$:(0..)                               ; Buyer fee
sell_fee = #$:(0..)                              ; Seller fee
transport_fee = #$:(0..)                         ; Transport fee
total_price = #$:(0..)                           ; Total price

{@auction_transaction}

; Participants
{.seller}
seller_dealer_id = :                             ; Seller dealer ID
seller_name = :                                  ; Seller name

{@auction_transaction}

{.buyer}
buyer_dealer_id = :                              ; Buyer dealer ID
buyer_name = :                                   ; Buyer name
buyer_number = :                                 ; Auction buyer number

{@auction_transaction}

; Post-sale
{.post_sale}
arbitration_filed = ?                            ; Arbitration filed
arbitration_reason = ::if arbitration_filed = true
arbitration_result = (awarded, denied):if arbitration_filed = true
title_received = ?                               ; Title received
title_date = date                                ; Title receipt date
transport_arranged = ?                           ; Transport arranged
pickup_date = date                               ; Pickup date

{@auction_transaction}

; Payment
{.payment}
payment_method = (ach, check, floor_plan, wire)
payment_date = date                              ; Payment date
payment_reference = :                            ; Reference number
paid = ?                                         ; Paid in full

{@auction_transaction}

; ===================================================================================
; DEALER TRADE
; ===================================================================================
; Dealer-to-dealer vehicle trade.

{@dealer_trade}
; Required fields first
trade_id = !:                                    ; Trade identifier
trade_date = !date                               ; Trade date
vin = !*:format vin                              ; Vehicle VIN

; Parties
{.sending_dealer}
dealer_id = :                                    ; Sending dealer ID
dealer_name = :                                  ; Sending dealer name
contact = :                                      ; Contact person
phone = *@phone                                  ; Phone

{@dealer_trade}

{.receiving_dealer}
dealer_id = :                                    ; Receiving dealer ID
dealer_name = :                                  ; Receiving dealer name
contact = :                                      ; Contact person
phone = *@phone                                  ; Phone

{@dealer_trade}

; Vehicle
{.vehicle}
year = ##:(1900..2100)                           ; Model year
make = :                                         ; Make
model = :                                        ; Model
trim = :                                         ; Trim
color = :                                        ; Color
stock_number = :                                 ; Stock number
odometer = ##:(0..)                              ; Odometer

{@dealer_trade}

; Terms
{.terms}
trade_type = (borrow, exchange, purchase)        ; Trade type
trade_price = #$:(0..)                           ; Trade price
invoice_included = ?                             ; Invoice provided
holdback_included = ?                            ; Holdback included
incentives_assigned = ?                          ; Incentives assigned
return_by = date:if trade_type = borrow          ; Return date if borrow

{@dealer_trade}

; Status
{.status}
status = !(cancelled, completed, in_transit, pending)
shipped_date = date                              ; Ship date
received_date = date                             ; Receipt date
title_sent = ?                                   ; Title sent
title_received = ?                               ; Title received
payment_sent = ?                                 ; Payment sent
payment_received = ?                             ; Payment received

{@dealer_trade}


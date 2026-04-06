; ===================================================================================
; ODIN Automotive Transaction Schema
; ===================================================================================
; Vehicle transactions including sales, trade-ins, leases, and financing. Derived
; from FTC Used Car Rule, state dealer regulations, and TILA.
; ===================================================================================

@import "../common/vehicle.schema.odin" as vehicle
@import "../common/types.schema.odin" as types
@import "../finance/leasing/leasing.schema.odin" as leasing

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.automotive.transaction"
version = "1.0.0"
title = "Automotive Transaction Schema"
description = "Vehicle sales, trade-ins, leases, and financing transactions"

{$derivation}
source[0].authority = "Federal Trade Commission"
source[0].citation = "FTC Used Car Rule (16 CFR Part 455)"
source[0].url = "https://www.ecfr.gov/current/title-16/chapter-I/subchapter-D/part-455"

source[1].authority = "Consumer Financial Protection Bureau"
source[1].citation = "Regulation Z - Truth in Lending (12 CFR 1026)"
source[1].url = "https://www.consumerfinance.gov/rules-policy/regulations/1026/"

source[2].authority = "Consumer Financial Protection Bureau"
source[2].citation = "Regulation M - Consumer Leasing (12 CFR 1013)"
source[2].url = "https://www.consumerfinance.gov/rules-policy/regulations/1013/"

source[3].authority = "National Conference of Commissioners on Uniform State Laws"
source[3].citation = "UCC Article 2A - Leases"
source[3].url = "https://www.uniformlaws.org/committees/community-home?communitykey=da0e7d65-2b0c-4c95-9ec6-b32d60a11e5c"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Vehicle transaction structures per FTC, TILA, and Reg M requirements"

changelog[0].date = 2025-12-21
changelog[0].change = "Initial automotive transaction schema"
changelog[0].rationale = "Structures derived from FTC Used Car Rule and TILA/Reg M"

; ===================================================================================
; VEHICLE SALE
; ===================================================================================
; Vehicle purchase/sale transaction per FTC Used Car Rule and state regulations.

{@vehicle_sale}
; Required fields first
transaction_id = !:                              ; Unique transaction ID
transaction_type = !(dealer_new, dealer_used, private_party)
transaction_date = !date                         ; Sale date
vin = !*:format vin                              ; Vehicle VIN

; Parties
{.seller}
seller_type = !(dealer, individual, organization)
seller_name = !:                                 ; Seller name
seller_address = @address                        ; Seller address
seller_phone = *@phone                           ; Seller phone
dealer_license = ::if seller_type = dealer       ; Dealer license number
dealer_state = :(2):if seller_type = dealer      ; Dealer state

{@vehicle_sale}

{.buyer}
buyer_type = !(individual, organization)
buyer_name = !:                                  ; Buyer name
buyer_address = @address                         ; Buyer address
buyer_phone = *@phone                            ; Buyer phone
buyer_email = *@email                            ; Buyer email
drivers_license = *:                             ; Driver license number
drivers_license_state = :(2)                     ; DL state

{@vehicle_sale}

; Vehicle information
vehicle = @vehicle_identification                ; Vehicle details

; Odometer
{.odometer}
reading = !##:(0..)                              ; Odometer at sale
reading_type = !(actual, discrepancy, exempt, not_actual)
disclosure_date = date                           ; Disclosure date

{@vehicle_sale}

; Pricing
{.pricing}
vehicle_price = !#$:(0..)                        ; Base vehicle price
msrp = #$:(0..):if transaction_type = dealer_new ; MSRP for new
invoice = #$:(0..):if transaction_type = dealer_new ; Invoice for new
dealer_addons = #$:(0..)                         ; Dealer add-ons
destination = #$:(0..):if transaction_type = dealer_new ; Destination charge
total_vehicle_price = #$:(0..)                   ; Total before trade/fees

{@vehicle_sale}

; Trade-in
trade_in = @trade_in                             ; Trade-in details

; Fees
{.fees}
documentation_fee = #$:(0..)                     ; Doc fee
title_fee = #$:(0..)                             ; Title fee
registration_fee = #$:(0..)                      ; Registration fee
plate_fee = #$:(0..)                             ; Plate fee
emissions_fee = #$:(0..)                         ; Emissions test fee
electronic_filing = #$:(0..)                     ; Electronic filing fee
dealer_handling = #$:(0..)                       ; Dealer handling
other_fees = #$:(0..)                            ; Other fees
total_fees = #$:(0..)                            ; Total fees

{@vehicle_sale}

; Taxes
{.taxes}
sales_tax_rate = #:(0..15)                       ; Sales tax rate %
sales_tax = #$:(0..)                             ; Sales tax amount
luxury_tax = #$:(0..)                            ; Luxury tax if applicable
tire_tax = #$:(0..)                              ; Tire recycling fee
battery_fee = #$:(0..)                           ; Battery disposal fee
total_tax = #$:(0..)                             ; Total taxes

{@vehicle_sale}

; Products (F&I products)
products[] = @sale_product                       ; F&I products sold

; Totals
{.totals}
subtotal = #$:(0..)                              ; Before tax
total_due = #$:(0..)                             ; Total due from buyer
trade_allowance = #$:(0..)                       ; Trade-in credit
net_trade = #$:(0..)                             ; Net trade (after payoff)
cash_price = #$:(0..)                            ; Cash price
amount_financed = #$:(0..)                       ; Amount financed
total_sale = #$:(0..)                            ; Total sale amount

{@vehicle_sale}

; Payment
{.payment}
payment_type = !(cash, financing, outside_financing)
down_payment = #$:(0..)                          ; Down payment
deposit = #$:(0..)                               ; Deposit amount
balance_due = #$:(0..)                           ; Balance due at delivery
payment_method = (ach, cash, cashiers_check, check, credit)
check_number = :                                 ; Check number if applicable

{@vehicle_sale}

; Financing (if financed)
financing = @auto_financing:if payment.payment_type = financing

; FTC Buyers Guide (Used Car Rule)
{.buyers_guide}
required = ?:if transaction_type = dealer_used   ; Buyers Guide required
warranty = !(as_is, dealer_warranty, implied, limited, manufacturer):if transaction_type = dealer_used
warranty_duration_months = ##:if warranty = dealer_warranty|limited
warranty_duration_miles = ##:if warranty = dealer_warranty|limited
warranty_coverage = ::if warranty = dealer_warranty|limited
buyers_guide_date = date:if transaction_type = dealer_used
buyers_guide_signed = ?:if transaction_type = dealer_used

{@vehicle_sale}

; Delivery
{.delivery}
delivery_date = date                             ; Delivery date
delivery_type = (customer_pickup, dealer_delivery, transport)
delivery_location = @address                     ; Delivery location
fuel_level = (empty, full, half, quarter, three_quarter)
inspected_by_buyer = ?                           ; Buyer inspected vehicle
keys_provided = ##:(1..)                         ; Number of keys

{@vehicle_sale}

; Status
status = !(cancelled, completed, pending, unwound)
cancellation_date = date:if status = cancelled
cancellation_reason = ::if status = cancelled
unwind_date = date:if status = unwound
unwind_reason = ::if status = unwound

; Contract
{.contract}
contract_number = :                              ; Contract/deal number
contract_date = date                             ; Contract date
salesperson = :                                  ; Salesperson name
sales_manager = :                                ; Sales manager
finance_manager = :                              ; F&I manager

{@vehicle_sale}

{@sale_product}
; Required fields first
product_type = !(
    anti_theft,
    appearance_protection,
    credit_insurance,
    ding_dent,
    etch,
    extended_warranty,
    gap_insurance,
    key_replacement,
    maintenance,
    paint_protection,
    road_hazard,
    tire_wheel,
    windshield
)
product_name = !:                                ; Product name
price = !#$:(0..)                                ; Retail price

; Product details
provider = :                                     ; Provider name
term_months = ##:(1..)                           ; Term in months
term_miles = ##:(0..)                            ; Term in miles
deductible = #$:(0..)                            ; Deductible amount
coverage_start = date                            ; Coverage start date
coverage_end = date                              ; Coverage end date

; Cost/profit
dealer_cost = #$:(0..)                           ; Dealer cost
dealer_profit = #$:(0..)                         ; Dealer profit
financed = ?                                     ; Product financed

; Cancellation
cancellable = ?                                  ; Product cancellable
cancellation_fee = #$:(0..)                      ; Cancellation fee
pro_rata_refund = ?                              ; Pro-rata refund available

; ===================================================================================
; TRADE-IN
; ===================================================================================
; Trade-in vehicle valuation and payoff.

{@trade_in}
; Required fields first
vin = !*:format vin                              ; Trade VIN
trade_date = !date                               ; Trade date

; Vehicle information
vehicle = @vehicle_identification                ; Vehicle details

; Condition
{.condition}
overall = !(excellent, fair, good, poor, rough)
interior = (excellent, fair, good, poor)
exterior = (excellent, fair, good, poor)
mechanical = (excellent, fair, good, poor)
tire_condition = (excellent, fair, good, poor, needs_replacement)
damage_present = ?                               ; Damage present
damage_description = ::if damage_present = true
smoker = ?                                       ; Smoker vehicle
pet_odor = ?                                     ; Pet odor
accidents = ##:(0..)                             ; Known accident count
accident_history = ?                             ; Accident history disclosed

{@trade_in}

; Odometer
{.odometer}
reading = !##:(0..)                              ; Odometer reading
reading_type = !(actual, discrepancy, exempt, not_actual)
disclosure_date = date                           ; Disclosure date

{@trade_in}

; Valuation
{.valuation}
trade_source = (appraisal, auction, black_book, kbb, manager, nada, other)
wholesale_value = #$:(0..)                       ; Wholesale book value
retail_value = #$:(0..)                          ; Retail book value
trade_in_value = #$:(0..)                        ; Trade-in book value
acv = #$:(0..)                                   ; Actual Cash Value
reconditioning_estimate = #$:(0..)               ; Estimated recon cost
auction_estimate = #$:(0..)                      ; Expected auction value

{@trade_in}

; Allowance
{.allowance}
gross_allowance = !#$:(0..)                      ; Gross trade allowance
over_allowance = #$:(0..)                        ; Over allowance (bump)
acv_allowance = #$:(0..)                         ; ACV-based allowance
total_allowance = #$:(0..)                       ; Total allowance

{@trade_in}

; Payoff
{.payoff}
lien_exists = ?                                  ; Lien on trade
lienholder = ::if lien_exists = true             ; Lienholder name
account_number = *::if lien_exists = true        ; Account number
payoff_amount = #$:(0..):if lien_exists = true   ; Payoff amount
payoff_good_through = date:if lien_exists = true ; Payoff valid through
per_diem = #$:(0..):if lien_exists = true        ; Per diem interest
payoff_confirmed = ?:if lien_exists = true       ; Payoff confirmed
payoff_confirmation = ::if payoff_confirmed = true

{@trade_in}

; Net trade
net_trade = #$                                   ; Net trade (can be negative)
negative_equity = ?                              ; Negative equity exists
negative_equity_amount = #$:(0..):if negative_equity = true

; Title
{.title}
title_present = ?                                ; Title present
title_state = :(2)                               ; Title state
title_number = :                                 ; Title number
branded = ?                                      ; Title branded
brand_type = :                                   ; Brand type if branded
additional_owners = ?                            ; Additional owners on title
owner_signatures_required = ##:(1..)             ; Signatures needed

{@trade_in}

; Keys/documents
{.documents}
keys_count = ##:(0..)                            ; Keys provided
remotes_count = ##:(0..)                         ; Remotes provided
owners_manual = ?                                ; Owner's manual
service_records = ?                              ; Service records
window_sticker = ?                               ; Window sticker

{@trade_in}

; ===================================================================================
; VEHICLE LEASE (CONSUMER)
; ===================================================================================
; Consumer vehicle lease per Regulation M (Consumer Leasing Act).

{@vehicle_lease}
; Required fields first
lease_id = !:                                    ; Lease identifier
vin = !*:format vin                              ; Vehicle VIN
lease_type = !(closed_end, open_end)             ; Lease type

; Parties
{.lessor}
lessor_name = !:                                 ; Lessor (finance company)
lessor_address = @address                        ; Lessor address
lessor_phone = *@phone                           ; Lessor phone

{@vehicle_lease}

{.lessee}
lessee_name = !:                                 ; Lessee name
lessee_address = @address                        ; Lessee address
lessee_phone = *@phone                           ; Lessee phone
lessee_email = *@email                           ; Lessee email
lessee_employer = :                              ; Employer name

{@vehicle_lease}

; Co-lessee
{.co_lessee}
co_lessee_name = :                               ; Co-lessee name
co_lessee_address = @address                     ; Co-lessee address
co_lessee_phone = *@phone                        ; Co-lessee phone

{@vehicle_lease}

; Vehicle
vehicle = @vehicle_identification                ; Vehicle details

; Term
{.term}
term_months = !##:(1..)                          ; Lease term (months)
inception_date = !date                           ; Lease inception
expiration_date = !date                          ; Lease expiration
first_payment_date = date                        ; First payment due

{@vehicle_lease}

; Capitalized cost (Reg M disclosure)
{.capitalized_cost}
agreed_value = #$:(0..)                          ; Agreed upon value
msrp = #$:(0..)                                  ; MSRP
invoice = #$:(0..)                               ; Invoice price
cap_cost_reduction = #$:(0..)                    ; Cap cost reduction
net_trade_allowance = #$                         ; Net trade (can be negative)
rebates = #$:(0..)                               ; Manufacturer rebates
adjusted_cap_cost = #$:(0..)                     ; Adjusted cap cost

{@vehicle_lease}

; Residual
{.residual}
residual_value = #$:(0..)                        ; Residual value
residual_percent = #:(0..100)                    ; Residual as % of MSRP
guaranteed_residual = ?                          ; Residual guaranteed

{@vehicle_lease}

; Money factor / Rent charge (Reg M)
{.rent_charge}
money_factor = #.6                               ; Money factor (divide by 2400 for APR)
equivalent_apr = #.4                             ; Equivalent APR
total_rent_charge = #$:(0..)                     ; Total rent charge

{@vehicle_lease}

; Payment
{.payment}
base_payment = #$:(0..)                          ; Base monthly payment
sales_tax = #$:(0..)                             ; Monthly sales tax
total_payment = #$:(0..)                         ; Total monthly payment
payment_day = ##:(1..31)                         ; Due day of month
payment_count = ##:(1..)                         ; Total payments

{@vehicle_lease}

; Amounts at signing
{.due_at_signing}
first_payment = #$:(0..)                         ; First month payment
cap_cost_reduction = #$:(0..)                    ; Cap cost reduction
security_deposit = #$:(0..)                      ; Security deposit
acquisition_fee = #$:(0..)                       ; Acquisition fee
title_fees = #$:(0..)                            ; Title/registration fees
doc_fee = #$:(0..)                               ; Documentation fee
other_fees = #$:(0..)                            ; Other fees
total_due = #$:(0..)                             ; Total due at signing

{@vehicle_lease}

; Mileage
{.mileage}
annual_limit = ##:(0..)                          ; Annual mileage limit
total_limit = ##:(0..)                           ; Total mileage limit
excess_rate = #$:(0..)                           ; Excess mileage rate per mile
current_odometer = ##:(0..)                      ; Current odometer
mileage_used = ##:(0..)                          ; Miles used
mileage_remaining = ##:(0..)                     ; Miles remaining

{@vehicle_lease}

; Wear and use
{.wear_and_use}
normal_wear_defined = ?                          ; Normal wear defined in contract
wear_standards_provided = ?                      ; Standards document provided
excess_wear_charge = #$:(0..)                    ; Estimated excess wear

{@vehicle_lease}

; Fees
{.fees}
disposition_fee = #$:(0..)                       ; Disposition fee
early_termination_fee = #$:(0..)                 ; Early termination
purchase_option_fee = #$:(0..)                   ; Purchase option fee

{@vehicle_lease}

; End of lease options
{.end_options}
purchase_option = ?                              ; Purchase option available
purchase_price = #$:(0..)                        ; Purchase option price
renewal_option = ?                               ; Renewal option
extension_available = ?                          ; Extension available
extension_months = ##:(0..)                      ; Extension term

{@vehicle_lease}

; Insurance requirements
{.insurance}
liability_required = #$:(0..)                    ; Minimum liability
collision_required = ?                           ; Collision required
collision_deductible_max = ##                    ; Max collision deductible
comprehensive_required = ?                       ; Comprehensive required
comprehensive_deductible_max = ##                ; Max comprehensive deductible
gap_included = ?                                 ; GAP coverage included

{@vehicle_lease}

; Status
status = !(active, charged_off, early_terminated, extended, expired, matured)
termination_date = date:if status = early_terminated
termination_reason = ::if status = early_terminated

; ===================================================================================
; AUTO FINANCING
; ===================================================================================
; Auto loan/financing per Regulation Z (TILA).

{@auto_financing}
; Required fields first
loan_id = !:                                     ; Loan identifier
vin = !*:format vin                              ; Vehicle VIN
loan_type = !(direct, indirect)                  ; Direct lender vs dealer arranged

; Lender
{.lender}
lender_name = !:                                 ; Lender name
lender_address = @address                        ; Lender address
lender_phone = *@phone                           ; Lender phone
nmls_id = :                                      ; NMLS ID if applicable

{@auto_financing}

; Borrower
{.borrower}
borrower_name = !:                               ; Borrower name
borrower_address = @address                      ; Borrower address
borrower_phone = *@phone                         ; Borrower phone
borrower_email = *@email                         ; Borrower email
employer = :                                     ; Employer name
monthly_income = *#$:(0..)                       ; Monthly income (confidential)

{@auto_financing}

; Co-borrower
{.co_borrower}
co_borrower_name = :                             ; Co-borrower name
co_borrower_address = @address                   ; Co-borrower address
co_borrower_phone = *@phone                      ; Co-borrower phone
co_borrower_employer = :                         ; Co-borrower employer

{@auto_financing}

; Vehicle
vehicle = @vehicle_identification                ; Vehicle details

; Reg Z Disclosures (TILA Box)
{.tila}
apr = !#.4                                       ; Annual Percentage Rate
finance_charge = !#$:(0..)                       ; Finance Charge (total interest)
amount_financed = !#$:(0..)                      ; Amount Financed
total_of_payments = !#$:(0..)                    ; Total of Payments
total_sale_price = #$:(0..)                      ; Total Sale Price

{@auto_financing}

; Loan terms
{.terms}
term_months = !##:(1..)                          ; Loan term (months)
first_payment_date = !date                       ; First payment due
payment_amount = !#$:(0..)                       ; Monthly payment
payment_day = ##:(1..31)                         ; Due day of month
final_payment_date = date                        ; Final payment date
final_payment_amount = #$:(0..)                  ; Final payment if different

{@auto_financing}

; Interest
{.interest}
interest_rate = #.4                              ; Note rate
rate_type = !(fixed, variable)                   ; Fixed or variable
index = ::if rate_type = variable               ; Index if variable
margin = #.4:if rate_type = variable            ; Margin if variable
rate_cap = #.4:if rate_type = variable          ; Rate cap if variable
interest_method = (add_on, rule_of_78s, simple_interest)
day_count = (actual_360, actual_365, basis_30_360)

{@auto_financing}

; Fees
{.fees}
origination_fee = #$:(0..)                       ; Origination fee
documentation_fee = #$:(0..)                     ; Documentation fee
filing_fee = #$:(0..)                            ; Lien filing fee
other_fees = #$:(0..)                            ; Other fees
total_fees = #$:(0..)                            ; Total fees
fees_financed = ?                                ; Fees included in amount financed

{@auto_financing}

; Prepayment
{.prepayment}
penalty = ?                                      ; Prepayment penalty
penalty_type = (fixed, percentage):if penalty = true
penalty_amount = #$:(0..):if penalty = true
penalty_period_months = ##:if penalty = true     ; Penalty period

{@auto_financing}

; Late payment
{.late_payment}
grace_period_days = ##:(0..)                     ; Grace period
late_fee_type = (fixed, percentage)              ; Late fee type
late_fee_amount = #$:(0..)                       ; Late fee if fixed
late_fee_percent = #:(0..15)                     ; Late fee if percentage
late_fee_max = #$:(0..)                          ; Maximum late fee

{@auto_financing}

; Security interest
{.security}
secured = !?true                                 ; Secured loan (always true for auto)
lien_position = ##:(1..3)                        ; Lien position
lien_filed = ?                                   ; Lien filed
lien_state = :(2)                                ; Lien filing state
filing_date = date                               ; Filing date
filing_number = :                                ; Filing reference

{@auto_financing}

; Current status
{.status}
status = !(active, charged_off, closed, delinquent, paid_off, repossessed)
current_balance = #$:(0..)                       ; Current balance
principal_balance = #$:(0..)                     ; Principal balance
accrued_interest = #$:(0..)                      ; Accrued interest
days_past_due = ##:(0..)                         ; Days past due
payments_remaining = ##:(0..)                    ; Payments remaining
next_payment_due = date                          ; Next due date
payoff_amount = #$:(0..)                         ; Current payoff
payoff_good_through = date                       ; Payoff valid through
per_diem = #$:(0..)                              ; Per diem interest

{@auto_financing}

; Payment history
{.payment_history}
payments_made = ##:(0..)                         ; Total payments made
on_time_payments = ##:(0..)                      ; On-time payments
late_payments = ##:(0..)                         ; Late payments
last_payment_date = date                         ; Last payment date
last_payment_amount = #$:(0..)                   ; Last payment amount

{@auto_financing}

; Credit reporting
{.credit}
reports_to_bureaus = ?                           ; Reports to credit bureaus
bureau_tradeline_id = :                          ; Tradeline ID
reported_balance = #$:(0..)                      ; Last reported balance
reported_date = date                             ; Last report date

{@auto_financing}

; ===================================================================================
; BILL OF SALE
; ===================================================================================
; Vehicle bill of sale document.

{@bill_of_sale}
; Required fields first
document_id = !:                                 ; Document identifier
sale_date = !date                                ; Date of sale
vin = !*:format vin                              ; Vehicle VIN

; Seller
{.seller}
name = !:                                        ; Seller name
address = @address                               ; Seller address
phone = *@phone                                  ; Seller phone

{@bill_of_sale}

; Buyer
{.buyer}
name = !:                                        ; Buyer name
address = @address                               ; Buyer address
phone = *@phone                                  ; Buyer phone

{@bill_of_sale}

; Vehicle
{.vehicle}
year = !##:(1900..2100)                          ; Model year
make = !:                                        ; Make
model = !:                                       ; Model
color = :                                        ; Color
body_type = :                                    ; Body type

{@bill_of_sale}

; Odometer
{.odometer}
reading = !##:(0..)                              ; Odometer reading
reading_type = !(actual, discrepancy, exempt, not_actual)

{@bill_of_sale}

; Sale amount
sale_price = !#$:(0..)                           ; Sale price
payment_method = (cash, cashiers_check, check, financing)
down_payment = #$:(0..)                          ; Down payment if financed

; Warranty disclaimer
as_is = ?                                        ; Sold as-is
warranty_disclaimer = :                          ; Warranty disclaimer text

; Signatures
seller_signature_date = date                     ; Seller signature date
buyer_signature_date = date                      ; Buyer signature date
notarized = ?                                    ; Notarized
notary_name = ::if notarized = true
notary_date = date:if notarized = true
notary_commission = ::if notarized = true
notary_state = :(2):if notarized = true

; ===================================================================================
; PURCHASE ORDER
; ===================================================================================
; Dealer purchase order / buyer's order.

{@purchase_order}
; Required fields first
order_number = !:                                ; Purchase order number
order_date = !date                               ; Order date
vin = *:format vin                               ; Vehicle VIN (if stock unit)

; Status
status = !(cancelled, completed, delivered, pending, rejected)

; Dealer
{.dealer}
dealer_name = !:                                 ; Dealer name
dealer_address = @address                        ; Dealer address
dealer_license = :                               ; Dealer license number
salesperson = :                                  ; Salesperson name

{@purchase_order}

; Customer
{.customer}
customer_name = !:                               ; Customer name
customer_address = @address                      ; Customer address
customer_phone = *@phone                         ; Customer phone
customer_email = *@email                         ; Customer email

{@purchase_order}

; Vehicle ordered
{.vehicle}
new_used = !(new, used)                          ; New or used
year = ##:(1900..2100)                           ; Model year
make = :                                         ; Make
model = :                                        ; Model
trim = :                                         ; Trim level
color_exterior = :                               ; Exterior color
color_interior = :                               ; Interior color
stock_number = :                                 ; Stock number
order_code = ::if new_used = new                 ; Factory order code

{@purchase_order}

; Pricing
{.pricing}
msrp = #$:(0..):if new_used = new                ; MSRP
selling_price = #$:(0..)                         ; Selling price
dealer_installed = #$:(0..)                      ; Dealer installed options
trade_allowance = #$:(0..)                       ; Trade allowance
total_price = #$:(0..)                           ; Total before fees/tax

{@purchase_order}

; Deposit
{.deposit}
deposit_amount = #$:(0..)                        ; Deposit amount
deposit_date = date                              ; Deposit date
deposit_method = (cash, check, credit)           ; Payment method
refundable = ?                                   ; Deposit refundable
refund_conditions = :                            ; Refund conditions

{@purchase_order}

; Estimated delivery
{.delivery}
estimated_date = date                            ; Estimated delivery date
factory_order = ?:if new_used = new              ; Factory ordered
in_transit = ?                                   ; Vehicle in transit
transit_eta = date:if in_transit = true          ; Transit ETA

{@purchase_order}

; Terms
{.terms}
offer_valid_days = ##:(1..)                      ; Offer validity period
financing_contingent = ?                         ; Subject to financing approval
trade_contingent = ?                             ; Subject to trade appraisal

{@purchase_order}


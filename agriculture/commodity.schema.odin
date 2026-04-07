; ===================================================================================
; ODIN Agriculture Commodity Schema
; ===================================================================================
; Commodity marketing including grain delivery, storage, and settlement, livestock
; marketing, futures contracts, hedging, basis contracts, and specialty crop contracts.
; ===================================================================================

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.agriculture.commodity"
version = "1.0.0"
title = "Agriculture Commodity Schema"
description = "Commodity marketing with grain, livestock, futures, and contracts"

{$derivation}
source[0].authority = "U.S. Department of Agriculture Grain Inspection, Packers and Stockyards Administration"
source[0].citation = "GIPSA Official Grain Standards (7 CFR Part 810)"
source[0].url = "https://www.ecfr.gov/current/title-7/subtitle-B/chapter-VIII/subchapter-A/part-810"

source[1].authority = "Chicago Mercantile Exchange"
source[1].citation = "CME Agricultural Commodity Futures and Options Contract Specifications"
source[1].url = "https://www.cmegroup.com/markets/agriculture.html"

source[2].authority = "U.S. Department of Agriculture Agricultural Marketing Service"
source[2].citation = "Livestock Market Reporting (7 CFR Part 59)"
source[3].url = "https://www.ams.usda.gov/services/market-news/livestock-poultry-grain"

source[3].authority = "Commodity Futures Trading Commission"
source[3].citation = "CFTC Regulations"
source[3].url = "https://www.cftc.gov/LawRegulation/index.htm"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial agriculture commodity schema"
changelog[0].rationale = "Commodity structures derived from GIPSA, CME, AMS, and CFTC standards"

; ===================================================================================
; GRAIN DELIVERY
; ===================================================================================

{@grain_delivery}
= @types.audit_info

; ───────────────────────────────────────────────────────────────────────────────
; Delivery Details
; ───────────────────────────────────────────────────────────────────────────────
delivery_id = !:                                 ; Delivery ticket number
delivery_date = !date                            ; Delivery date
delivery_time = time                             ; Delivery time
farm_ref = :                                     ; Farm reference
seller_name = :                                  ; Seller name
seller_id = :                                    ; Seller account number

; ───────────────────────────────────────────────────────────────────────────────
; Elevator/Buyer
; ───────────────────────────────────────────────────────────────────────────────
{.buyer}
buyer_name = !:                                  ; Elevator/buyer name
buyer_location = @types.address                  ; Buyer location
receiving_location = :                           ; Receiving location/bin

{@grain_delivery}

; ───────────────────────────────────────────────────────────────────────────────
; Grain Details
; ───────────────────────────────────────────────────────────────────────────────
{.grain}
commodity = (barley, canola, corn, millet, oats, rice, rye, sorghum, soybeans, sunflower, wheat)
crop_year = ##:(1900..2100)                      ; Crop year
gross_weight_lbs = !#:(0..)                      ; Gross weight
tare_weight_lbs = #:(0..)                        ; Tare weight
net_weight_lbs = !#:(0..)                        ; Net weight
bushels = #:(0..)                                ; Converted to bushels
test_weight = #:(0..)                            ; Test weight (lbs/bu)

{@grain_delivery}

; ───────────────────────────────────────────────────────────────────────────────
; Grade Factors (USDA Standards)
; ───────────────────────────────────────────────────────────────────────────────
{.grade}
grade = :                                        ; Official USDA grade
moisture_percent = #:(0..100)                    ; Moisture percentage
protein_percent = #:(0..100)                     ; Protein percentage
oil_content_percent = #:(0..100)                 ; Oil content percentage
foreign_material_percent = #:(0..100)            ; Foreign material
damaged_kernels_percent = #:(0..100)             ; Damaged kernels
broken_kernels_percent = #:(0..100)              ; Broken/cracked kernels
heat_damage_percent = #:(0..100)                 ; Heat damaged kernels
total_damage_percent = #:(0..100)                ; Total damaged kernels
splits_percent = #:(0..100)                      ; Splits (soybeans)
dockage_percent = #:(0..100)                     ; Dockage
falling_number = ##:(0..)                        ; Falling number (wheat)
vomitoxin_ppm = #:(0..)                          ; Vomitoxin/DON (ppm)
aflatoxin_ppb = #:(0..)                          ; Aflatoxin (ppb)

{@grain_delivery}

; ───────────────────────────────────────────────────────────────────────────────
; Price & Settlement
; ───────────────────────────────────────────────────────────────────────────────
{.settlement}
contract_number = :                              ; Contract number if applicable
price_per_bushel = #$                            ; Price per bushel
basis = #$                                       ; Basis (if futures pricing)
futures_month = :                                ; Futures month reference
cash_price = #$                                  ; Cash price per bushel
premium_discount = #$                            ; Grade premium/discount
shrink_bushels = #:(0..)                         ; Shrink (moisture adjustment)
gross_value = #$:(0..)                           ; Gross value
drying_charge = #$:(0..)                         ; Drying charge
storage_charge = #$:(0..)                        ; Storage charge
handling_fee = #$:(0..)                          ; Handling fee
other_charges = #$:(0..)                         ; Other charges
net_value = #$                                   ; Net value to seller
payment_status = (paid, pending, scheduled)
payment_date = date                              ; Payment date
check_number = :                                 ; Check/payment number

{@grain_delivery}

; ───────────────────────────────────────────────────────────────────────────────
; Disposition
; ───────────────────────────────────────────────────────────────────────────────
{.disposition}
disposition_type = (cash_sale, contract_delivery, forward_contract, storage)
storage_location = :                             ; Storage bin/location
storage_start_date = date                        ; Storage start date

; ===================================================================================
; GRAIN CONTRACT
; ===================================================================================

{@grain_contract}
; ───────────────────────────────────────────────────────────────────────────────
; Contract Details
; ───────────────────────────────────────────────────────────────────────────────
contract_number = !:                             ; Contract number
contract_date = !date                            ; Contract date
contract_type = (basis, cash_forward, deferred_pricing, hedged, minimum_price)
seller_name = !:                                 ; Seller name
seller_id = :                                    ; Seller account
buyer_name = !:                                  ; Buyer name

; ───────────────────────────────────────────────────────────────────────────────
; Commodity Specifications
; ───────────────────────────────────────────────────────────────────────────────
{.commodity}
commodity = (barley, canola, corn, oats, soybeans, sunflower, wheat)
crop_year = ##:(1900..2100)                      ; Crop year
quantity_bushels = !#:(0..)                      ; Contract quantity (bushels)
delivered_bushels = #:(0..)                      ; Delivered bushels
remaining_bushels = #:(0..)                      ; Remaining bushels
grade_specification = :                          ; Required grade
protein_min = #:(0..100)                         ; Minimum protein
test_weight_min = #:(0..)                        ; Minimum test weight

{@grain_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Pricing
; ───────────────────────────────────────────────────────────────────────────────
{.pricing}
pricing_method = (basis, cash, futures_plus_basis, minimum_price)
cash_price = #$:if pricing_method = cash         ; Fixed cash price
futures_month = :if pricing_method = basis|futures_plus_basis
basis = #$:if pricing_method = basis|futures_plus_basis
futures_price = #$:if pricing_method = futures_plus_basis
minimum_price = #$:if pricing_method = minimum_price
floor_price = #$                                 ; Floor price (if applicable)
ceiling_price = #$                               ; Ceiling price (if cap)
pricing_complete = ?                             ; Price established
pricing_date = date                              ; Date price set

{@grain_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Delivery Period
; ───────────────────────────────────────────────────────────────────────────────
{.delivery}
delivery_start = !date                           ; Delivery period start
delivery_end = !date                             ; Delivery period end
delivery_location = @types.address               ; Delivery location
delivery_terms = :                               ; Delivery terms/conditions

{@grain_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Financial
; ───────────────────────────────────────────────────────────────────────────────
{.financial}
estimated_value = #$:(0..)                       ; Estimated contract value
delivered_value = #$:(0..)                       ; Value of deliveries
remaining_value = #$:(0..)                       ; Remaining value

{@grain_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
{.status}
contract_status = (cancelled, completed, extended, open, pending)
cancellation_date = date:if contract_status = cancelled
cancellation_reason = :if contract_status = cancelled

{@grain_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Deliveries
; ───────────────────────────────────────────────────────────────────────────────
deliveries[] = @grain_delivery                   ; Delivery records

; ===================================================================================
; GRAIN STORAGE
; ===================================================================================

{@grain_storage}
; ───────────────────────────────────────────────────────────────────────────────
; Storage Details
; ───────────────────────────────────────────────────────────────────────────────
storage_id = !:                                  ; Storage account/receipt number
owner_name = !:                                  ; Owner name
owner_id = :                                     ; Owner account
facility_name = !:                               ; Storage facility
facility_location = @types.address               ; Facility address
bin_number = :                                   ; Specific bin/location

; ───────────────────────────────────────────────────────────────────────────────
; Stored Grain
; ───────────────────────────────────────────────────────────────────────────────
{.grain}
commodity = !:                                   ; Commodity stored
crop_year = ##:(1900..2100)                      ; Crop year
storage_date = !date                             ; Date placed in storage
quantity_bushels = !#:(0..)                      ; Bushels in storage
net_weight_lbs = #:(0..)                         ; Net weight (lbs)
grade = :                                        ; Grade at storage
moisture_percent = #:(0..100)                    ; Moisture at storage

{@grain_storage}

; ───────────────────────────────────────────────────────────────────────────────
; Storage Terms
; ───────────────────────────────────────────────────────────────────────────────
{.terms}
storage_type = (commercial, farm, government)
storage_rate = #$:(0..)                          ; Storage rate per bushel per month
in_date = date                                   ; Free storage end date
out_date = date                                  ; Required withdrawal date
insurance_coverage = #$:(0..)                    ; Insurance coverage amount

{@grain_storage}

; ───────────────────────────────────────────────────────────────────────────────
; Withdrawals
; ───────────────────────────────────────────────────────────────────────────────
{.withdrawals[]}
withdrawal_date = date                           ; Withdrawal date
bushels_withdrawn = #:(0..)                      ; Bushels withdrawn
remaining_bushels = #:(0..)                      ; Remaining balance

{@grain_storage}

; ───────────────────────────────────────────────────────────────────────────────
; Charges
; ───────────────────────────────────────────────────────────────────────────────
{.charges}
storage_charges = #$:(0..)                       ; Accumulated storage charges
shrink_charges = #$:(0..)                        ; Shrink charges
handling_fees = #$:(0..)                         ; Handling fees
total_charges = #$:(0..)                         ; Total charges

; ===================================================================================
; LIVESTOCK SALE
; ===================================================================================

{@livestock_sale}
; ───────────────────────────────────────────────────────────────────────────────
; Sale Details
; ───────────────────────────────────────────────────────────────────────────────
sale_id = !:                                     ; Sale ID/lot number
sale_date = !date                                ; Sale date
sale_type = (auction, direct, private_treaty, video)
market_name = :                                  ; Market/auction name
market_location = @types.address                 ; Market location

; ───────────────────────────────────────────────────────────────────────────────
; Seller
; ───────────────────────────────────────────────────────────────────────────────
{.seller}
seller_name = !:                                 ; Seller name
seller_id = :                                    ; Seller account
farm_ref = :                                     ; Farm reference
consignment_number = :                           ; Consignment number

{@livestock_sale}

; ───────────────────────────────────────────────────────────────────────────────
; Buyer
; ───────────────────────────────────────────────────────────────────────────────
{.buyer}
buyer_name = :                                   ; Buyer name
buyer_id = :                                     ; Buyer account
buyer_type = (dealer, farmer, feedlot, packer)

{@livestock_sale}

; ───────────────────────────────────────────────────────────────────────────────
; Animals Sold
; ───────────────────────────────────────────────────────────────────────────────
{.animals}
species = (beef_cattle, bison, dairy_cattle, goats, hogs, lambs, sheep)
description = :                                  ; Lot description
head_count = !##:(1..)                           ; Number of head
sex = (bulls, cows, heifers, mixed, steers)
average_weight_lbs = #:(0..)                     ; Average weight
total_weight_lbs = #:(0..)                       ; Total weight
weight_method = (actual, estimated, shrunk)
breed = :                                        ; Predominant breed
frame_size = (large, medium, small)
grade = :                                        ; Quality grade
individual_ids[] = :                             ; Individual animal IDs

{@livestock_sale}

; ───────────────────────────────────────────────────────────────────────────────
; Price & Settlement
; ───────────────────────────────────────────────────────────────────────────────
{.pricing}
price_basis = (per_cwt, per_head, per_pound)
price = !#$:(0..)                                ; Price
gross_proceeds = #$:(0..)                        ; Gross proceeds
commission = #$:(0..)                            ; Commission/fees
yardage = #$:(0..)                               ; Yardage fees
feed_charges = #$:(0..)                          ; Feed charges
brand_inspection = #$:(0..)                      ; Brand inspection fee
health_certificate = #$:(0..)                    ; Health certificate fee
trucking = #$:(0..)                              ; Trucking cost
checkoff = #$:(0..)                              ; Beef/pork checkoff
other_charges = #$:(0..)                         ; Other deductions
net_proceeds = #$                                ; Net to seller

{@livestock_sale}

; ───────────────────────────────────────────────────────────────────────────────
; Payment
; ───────────────────────────────────────────────────────────────────────────────
{.payment}
payment_status = (paid, pending)
payment_date = date                              ; Payment date
check_number = :                                 ; Check number

; ===================================================================================
; FUTURES CONTRACT
; ===================================================================================

{@futures_contract}
; ───────────────────────────────────────────────────────────────────────────────
; Contract Details
; ───────────────────────────────────────────────────────────────────────────────
contract_id = !:                                 ; Internal contract ID
account_number = *:                               ; Brokerage account number
trade_date = !date                               ; Trade date
exchange = (cbot, cme, ice, kcbt, mgex)         ; Exchange
commodity_symbol = !:                            ; Commodity symbol (ZC, ZS, ZW, etc.)
commodity_name = !:                              ; Commodity name

; ───────────────────────────────────────────────────────────────────────────────
; Position
; ───────────────────────────────────────────────────────────────────────────────
{.position}
position_type = (long, short)                   ; Long (buy) or short (sell)
contract_month = !:                              ; Contract month (e.g., "Dec 2025")
contract_year = ##:(2000..2100)                  ; Contract year
contract_count = !##:(1..)                       ; Number of contracts
contract_size_bushels = ##:(0..)                 ; Contract size (bushels)
total_bushels = #:(0..)                          ; Total bushels (contracts x size)

{@futures_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Pricing
; ───────────────────────────────────────────────────────────────────────────────
{.pricing}
entry_price = !#$                                ; Entry price per bushel
current_price = #$                               ; Current market price
exit_price = #$                                  ; Exit price (if closed)
price_change = #$                                ; Change from entry

{@futures_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Margin & Equity
; ───────────────────────────────────────────────────────────────────────────────
{.margin}
initial_margin = #$:(0..)                        ; Initial margin required
maintenance_margin = #$:(0..)                    ; Maintenance margin
current_equity = #$                              ; Current account equity
margin_calls = ##:(0..)                          ; Number of margin calls

{@futures_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Profit/Loss
; ───────────────────────────────────────────────────────────────────────────────
{.pnl}
unrealized_pnl = #$                              ; Unrealized profit/loss
realized_pnl = #$                                ; Realized profit/loss (if closed)
commission = #$:(0..)                            ; Commission paid

{@futures_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
{.status}
contract_status = (closed, expired, offset, open)
offset_date = date:if contract_status = offset|closed
expiration_date = date                           ; Contract expiration date
delivery_intent = ?                              ; Intent to deliver

{@futures_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Hedge Purpose
; ───────────────────────────────────────────────────────────────────────────────
{.hedge}
hedge_purpose = (income_protection, price_floor, price_lock, speculative)
hedged_crop_year = ##:(1900..2100)               ; Crop year being hedged
physical_bushels = #:(0..)                       ; Physical bushels hedged
field_refs[] = :                                 ; Fields hedged

; ===================================================================================
; OPTIONS CONTRACT
; ===================================================================================

{@options_contract}
; ───────────────────────────────────────────────────────────────────────────────
; Contract Details
; ───────────────────────────────────────────────────────────────────────────────
contract_id = !:                                 ; Internal contract ID
account_number = *:                               ; Brokerage account
trade_date = !date                               ; Trade date
exchange = (cbot, cme, ice, kcbt, mgex)
underlying_symbol = !:                           ; Underlying futures symbol
option_type = (call, put)                       ; Call or put option

; ───────────────────────────────────────────────────────────────────────────────
; Option Specifications
; ───────────────────────────────────────────────────────────────────────────────
{.specifications}
strike_price = !#$                               ; Strike price
contract_month = !:                              ; Expiration month
contract_year = ##:(2000..2100)                  ; Expiration year
expiration_date = !date                          ; Expiration date
contract_count = !##:(1..)                       ; Number of contracts
contract_size_bushels = ##:(0..)                 ; Size per contract

{@options_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Pricing
; ───────────────────────────────────────────────────────────────────────────────
{.pricing}
premium_paid = !#$:(0..)                         ; Premium paid per bushel
total_premium = #$:(0..)                         ; Total premium cost
current_premium = #$                             ; Current market premium
intrinsic_value = #$                             ; Intrinsic value
time_value = #$                                  ; Time value

{@options_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Greeks (Risk Metrics)
; ───────────────────────────────────────────────────────────────────────────────
{.greeks}
delta = #:(-1..1)                                ; Delta
gamma = #                                        ; Gamma
theta = #                                        ; Theta
vega = #                                         ; Vega

{@options_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
{.status}
option_status = (exercised, expired, open, sold)
exercise_date = date:if option_status = exercised
sale_date = date:if option_status = sold
in_the_money = ?                                 ; Currently ITM
realized_pnl = #$                                ; Realized profit/loss

; ===================================================================================
; SPECIALTY CROP CONTRACT
; ===================================================================================

{@specialty_contract}
; ───────────────────────────────────────────────────────────────────────────────
; Contract Details
; ───────────────────────────────────────────────────────────────────────────────
contract_number = !:                             ; Contract number
contract_date = !date                            ; Contract date
grower_name = !:                                 ; Grower name
buyer_name = !:                                  ; Buyer/processor name

; ───────────────────────────────────────────────────────────────────────────────
; Crop Specifications
; ───────────────────────────────────────────────────────────────────────────────
{.crop}
crop_type = !:                                   ; Crop type (vegetables, fruits, etc.)
variety = :                                      ; Specific variety required
organic = ?                                      ; Organic production required
gmo_status = (gmo, non_gmo, not_specified)
acreage = #:(0..)                                ; Contracted acres
estimated_yield = #:(0..)                        ; Estimated yield per acre
total_quantity = #:(0..)                         ; Total quantity expected
quantity_unit = :                                ; Unit of measure

{@specialty_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Quality Requirements
; ───────────────────────────────────────────────────────────────────────────────
{.quality}
grade_standard = :                               ; Grade standard required
size_specification = :                           ; Size requirements
color_requirements = :                           ; Color requirements
brix_min = #:(0..):if crop_type = fruit          ; Minimum Brix (sugar content)
defect_tolerance = :                             ; Defect tolerance
food_safety_cert = (gap, gfsi, organic, primus_gfs)

{@specialty_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Pricing
; ───────────────────────────────────────────────────────────────────────────────
{.pricing}
price_per_unit = !#$:(0..)                       ; Price per unit
pricing_basis = :                                ; Pricing basis (field pack, FOB, delivered)
minimum_price = #$:(0..)                         ; Minimum guaranteed price
premium_for_organic = #$:(0..)                   ; Organic premium
premium_for_quality = #$:(0..)                   ; Quality premium

{@specialty_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Delivery
; ───────────────────────────────────────────────────────────────────────────────
{.delivery}
delivery_start = date                            ; Delivery window start
delivery_end = date                              ; Delivery window end
delivery_location = @types.address               ; Delivery location
delivery_schedule = :                            ; Delivery schedule/frequency
packaging_requirements = :                       ; Packaging requirements

{@specialty_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Production Requirements
; ───────────────────────────────────────────────────────────────────────────────
{.production}
approved_seed_varieties[] = :                    ; Approved varieties
planting_dates = @types.effective_period         ; Planting window
harvest_window = @types.effective_period         ; Harvest window
field_inspections_required = ?                   ; Field inspections required
buyer_approval_required = ?                      ; Buyer approval for inputs

{@specialty_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Performance
; ───────────────────────────────────────────────────────────────────────────────
{.performance}
delivered_quantity = #:(0..)                     ; Quantity delivered
accepted_quantity = #:(0..)                      ; Quantity accepted
rejected_quantity = #:(0..)                      ; Quantity rejected
rejection_reasons[] = :                          ; Rejection reasons
contract_fulfillment_percent = #:(0..100)        ; Percent fulfilled

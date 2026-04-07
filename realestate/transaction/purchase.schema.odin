; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Real Estate Purchase Transaction Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Real estate purchase contracts and transactions covering the full lifecycle
; from offer through closing and recording. Includes contract terms,
; contingencies, due diligence (inspections, appraisal, title), financing,
; and closing coordination.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as common
@import "../types.schema.odin" as re
@import "../../mortgage/loan.schema.odin" as mtg

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.realestate.transaction.purchase"
version = "1.0.0"
title = "Real Estate Purchase Transaction Schema"
description = "Comprehensive purchase contract and transaction management"

{$derivation}
source[0].authority = "National Association of Realtors"
source[0].citation = "Standard Real Estate Purchase Contract Forms"
source[0].url = "https://www.nar.realtor/"

source[1].authority = "CFPB"
source[1].citation = "TILA-RESPA Integrated Disclosure Rule"
source[1].url = "https://www.consumerfinance.gov/rules-policy/regulations/1026/"

source[2].authority = "State Real Estate Commissions"
source[2].citation = "State-mandated contract disclosures and requirements"
source[2].url = "https://web.archive.org/web/20250101041308/https://www.arello.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Purchase transaction schema derived from standard real estate contract law and TRID requirements"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial purchase transaction schema"
changelog[0].rationale = "Comprehensive transaction structure from listing to closing"

; ═══════════════════════════════════════════════════════════════════════════════
; PURCHASE OFFER
; ═══════════════════════════════════════════════════════════════════════════════
; Initial offer from buyer to seller

{@purchase_offer}
; Required fields first
offer_date = !date                                ; Date offer submitted
offer_price = !#$:(0..)                           ; Offered purchase price
property_address = !@address                      ; Property address

; Offer identification
offer_id = :                                      ; Unique offer identifier
offer_number = ##:(1..)                           ; Offer sequence number

; ───────────────────────────────────────────────────────────────────────────────
; Parties
; ───────────────────────────────────────────────────────────────────────────────
buyers[] = @re_party                              ; Buyer(s)
buyer_agent = @re_agent                           ; Buyer's agent
buyer_broker = @re_company                        ; Buyer's brokerage

{@purchase_offer}

; ───────────────────────────────────────────────────────────────────────────────
; Offer Terms
; ───────────────────────────────────────────────────────────────────────────────
{.terms}
earnest_money = #$:(0..)                          ; Earnest money deposit
earnest_money_due = date                          ; Earnest money due date
additional_deposit = #$:(0..)                     ; Additional deposit amount
additional_deposit_due = date                     ; Additional deposit due date
down_payment = #$:(0..)                           ; Down payment amount
closing_date = !date                              ; Proposed closing date
possession_date = date                            ; Possession date if different
offer_expiration = !timestamp                     ; Offer expiration time

{@purchase_offer}

; ───────────────────────────────────────────────────────────────────────────────
; Financing
; ───────────────────────────────────────────────────────────────────────────────
{.financing}
type = !(assumption, cash, conventional, fha, other, seller_finance, usda, va)
loan_amount = #$:(0..):if type != cash            ; Loan amount
interest_rate = #:(0..100):if type != cash        ; Maximum acceptable rate
loan_term_years = ##:(1..50):if type != cash      ; Loan term
financing_contingency = ?:if type != cash         ; Subject to financing approval
financing_contingency_days = ##:(1..):if financing_contingency = true
pre_approval = ?:if type != cash                  ; Buyer has pre-approval
pre_approval_lender = ::if pre_approval = true    ; Pre-approval lender name
pre_approval_amount = #$:(0..):if pre_approval = true
pre_approval_expiration = date:if pre_approval = true

{@purchase_offer}

; ───────────────────────────────────────────────────────────────────────────────
; Contingencies
; ───────────────────────────────────────────────────────────────────────────────
{.contingencies}
appraisal_contingency = ?                         ; Subject to appraisal
appraisal_days = ##:(1..):if appraisal_contingency = true
appraisal_gap = #$:(0..):if appraisal_contingency = true  ; Buyer covers gap up to amount
home_sale_contingency = ?                         ; Subject to sale of buyer's home
home_sale_address = @address:if home_sale_contingency = true
home_sale_days = ##:(1..):if home_sale_contingency = true
inspection_contingency = ?                        ; Subject to inspection
inspection_days = ##:(1..):if inspection_contingency = true
title_contingency = ?                             ; Subject to clear title
title_days = ##:(1..):if title_contingency = true
other_contingencies[] = :                         ; Other contingency descriptions

{@purchase_offer}

; ───────────────────────────────────────────────────────────────────────────────
; Inclusions/Exclusions
; ───────────────────────────────────────────────────────────────────────────────
{.inclusions}
appliances = ?                                    ; Appliances included
ceiling_fans = ?                                  ; Ceiling fans included
window_treatments = ?                             ; Window treatments included
light_fixtures = ?                                ; Light fixtures included
outdoor_equipment = ?                             ; Outdoor equipment included
other_inclusions[] = :                            ; Other items included

{@purchase_offer}
exclusions[] = :                                  ; Excluded items

; ───────────────────────────────────────────────────────────────────────────────
; Seller Concessions
; ───────────────────────────────────────────────────────────────────────────────
{.concessions}
seller_paid_closing_costs = #$:(0..)              ; Seller contribution to closing
home_warranty = ?                                 ; Seller provides home warranty
home_warranty_amount = #$:(0..):if home_warranty = true
repair_credit = #$:(0..)                          ; Credit for repairs
other_concessions[] = :                           ; Other seller concessions

{@purchase_offer}

; ───────────────────────────────────────────────────────────────────────────────
; Offer Status
; ───────────────────────────────────────────────────────────────────────────────
status = (accepted, countered, expired, pending, rejected, withdrawn)
status_date = date                                ; Date of status change
counter_offer_ref = @purchase_offer:if status = countered  ; Reference to counter

; ═══════════════════════════════════════════════════════════════════════════════
; PURCHASE CONTRACT
; ═══════════════════════════════════════════════════════════════════════════════
; Executed purchase agreement between buyer and seller

{@purchase_contract}
; Required fields first
contract_date = !date                             ; Contract execution date
purchase_price = !#$:(0..)                        ; Agreed purchase price
property_address = !@address                      ; Property address

; Contract identification
contract_id = :                                   ; Unique contract identifier
mls_number = :                                    ; MLS listing number

; Property reference
property_ref = :                                  ; Reference to property schema

; ───────────────────────────────────────────────────────────────────────────────
; Parties
; ───────────────────────────────────────────────────────────────────────────────
sellers[] = @re_party                             ; Seller(s)
buyers[] = @re_party                              ; Buyer(s)
listing_agent = @re_agent                         ; Listing agent
listing_broker = @re_company                      ; Listing brokerage
buyer_agent = @re_agent                           ; Buyer's agent
buyer_broker = @re_company                        ; Buyer's brokerage

{@purchase_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Financial Terms
; ───────────────────────────────────────────────────────────────────────────────
{.financial}
earnest_money = !#$:(0..)                         ; Earnest money deposit
earnest_money_holder = :                          ; Who holds earnest money
earnest_money_received_date = date                ; Date earnest money received
additional_deposit = #$:(0..)                     ; Additional deposit
down_payment = #$:(0..)                           ; Total down payment
loan_amount = #$:(0..)                            ; Financing amount
seller_concessions = #$:(0..)                     ; Total seller concessions
estimated_closing_costs = #$:(0..)                ; Estimated buyer closing costs

{@purchase_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Financing
; ───────────────────────────────────────────────────────────────────────────────
{.financing}
type = !(assumption, cash, conventional, fha, other, seller_finance, usda, va)
lender = :                                        ; Lender name
loan_officer = :                                  ; Loan officer name
loan_officer_phone = *@phone                      ; Loan officer phone
loan_application_date = date                      ; Date of loan application
loan_approval_date = date                         ; Date of loan approval
loan_commitment_date = date                       ; Date commitment received
clear_to_close_date = date                        ; Clear to close date

{@purchase_contract}

; Mortgage bridge to loan schema
mortgage_application_ref = @mtg.application       ; Bridge to mortgage application

; ───────────────────────────────────────────────────────────────────────────────
; Key Dates
; ───────────────────────────────────────────────────────────────────────────────
{.dates}
effective_date = !date                            ; Contract effective date
inspection_deadline = date                        ; Inspection period deadline
inspection_resolution = date                      ; Inspection resolution deadline
appraisal_deadline = date                         ; Appraisal deadline
financing_deadline = date                         ; Financing contingency deadline
title_deadline = date                             ; Title objection deadline
closing_date = !date                              ; Scheduled closing date
possession_date = date                            ; Possession transfer date

{@purchase_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Contingencies
; ───────────────────────────────────────────────────────────────────────────────
{.contingencies}
appraisal = ?                                     ; Appraisal contingency
appraisal_status = (removed, satisfied, waived):if appraisal = true
appraisal_removed_date = date:if appraisal = true
financing = ?                                     ; Financing contingency
financing_status = (removed, satisfied, waived):if financing = true
financing_removed_date = date:if financing = true
home_sale = ?                                     ; Home sale contingency
home_sale_status = (removed, satisfied, waived):if home_sale = true
home_sale_removed_date = date:if home_sale = true
inspection = ?                                    ; Inspection contingency
inspection_status = (removed, satisfied, waived):if inspection = true
inspection_removed_date = date:if inspection = true
title = ?                                         ; Title contingency
title_status = (removed, satisfied, waived):if title = true
title_removed_date = date:if title = true

{@purchase_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Title and Escrow
; ───────────────────────────────────────────────────────────────────────────────
{.title_escrow}
title_company = @re_company                       ; Title company
title_officer = :                                 ; Title officer name
title_order_number = :                            ; Title order number
escrow_company = @re_company                      ; Escrow company (if different)
escrow_officer = :                                ; Escrow officer name
escrow_number = :                                 ; Escrow file number

{@purchase_contract}

; Bridge to title insurance schema
title_commitment_ref = @title_commitment          ; Bridge to title commitment

; ───────────────────────────────────────────────────────────────────────────────
; Inspections
; ───────────────────────────────────────────────────────────────────────────────
{.inspections[]}
inspection_type = !(appraisal, chimney, environmental, general, hvac, mold, other, pest, pool, radon, roof, septic, sewer, structural, well)
inspector = :                                     ; Inspector name
inspection_company = :                            ; Inspection company
inspection_date = date                            ; Date of inspection
inspection_complete = ?                           ; Inspection completed
report_received = ?                               ; Report received
issues_found = ?                                  ; Issues identified
issue_summary = ::if issues_found = true          ; Summary of issues
resolution = (credit, no_action, repair, termination):if issues_found = true

{@purchase_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Amendments
; ───────────────────────────────────────────────────────────────────────────────
{.amendments[]}
amendment_number = ##:(1..)                       ; Amendment sequence
amendment_date = date                             ; Date of amendment
description = :                                   ; Amendment description
price_change = #$                                 ; Change to purchase price
closing_date_change = date                        ; New closing date
other_changes = :                                 ; Other changes

{@purchase_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Addenda
; ───────────────────────────────────────────────────────────────────────────────
{.addenda[]}
addendum_type = !(as_is, condominium, fha_va, financing, home_warranty, hoa, inspection, lead_paint, mold, other, property_disclosure, seller_disclosure, short_sale)
addendum_date = date                              ; Date of addendum
attached = ?                                      ; Addendum attached

{@purchase_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Prorations
; ───────────────────────────────────────────────────────────────────────────────
{.prorations}
proration_date = date                             ; Date for prorations (usually closing)
property_taxes = #$                               ; Prorated property taxes
hoa_dues = #$                                     ; Prorated HOA dues
rent = #$                                         ; Prorated rent (if tenants)
utilities = #$                                    ; Prorated utilities
other = #$                                        ; Other prorations

{@purchase_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Contract Status
; ───────────────────────────────────────────────────────────────────────────────
status = !(active, cancelled, closed, contingent, pending, terminated)
status_date = date                                ; Status change date
cancellation_reason = ::if status = cancelled     ; Reason for cancellation
termination_reason = ::if status = terminated     ; Reason for termination

; ═══════════════════════════════════════════════════════════════════════════════
; PURCHASE CLOSING
; ═══════════════════════════════════════════════════════════════════════════════
; Settlement/closing of purchase transaction

{@purchase_closing}
; Required fields first
closing_date = !date                              ; Actual closing date
contract_ref = !@purchase_contract                ; Reference to purchase contract

; Closing identification
closing_id = :                                    ; Unique closing identifier
file_number = :                                   ; Closing file number

; ───────────────────────────────────────────────────────────────────────────────
; Parties at Closing
; ───────────────────────────────────────────────────────────────────────────────
closing_agent = @re_party                         ; Closing agent/attorney
seller_attorney = @re_party                       ; Seller's attorney
buyer_attorney = @re_party                        ; Buyer's attorney
notary = :                                        ; Notary name

{@purchase_closing}

; ───────────────────────────────────────────────────────────────────────────────
; Closing Disclosure (Per TRID)
; ───────────────────────────────────────────────────────────────────────────────
{.disclosure}
cd_issue_date = date                              ; Closing Disclosure issue date
cd_received_date = date                           ; Date buyer received CD
three_day_rule_met = ?                            ; 3 business day requirement met
changed_circumstances = ?                         ; Changed circumstances occurred
revised_cd = ?                                    ; Revised CD issued
revised_cd_date = date:if revised_cd = true       ; Revised CD date

{@purchase_closing}

; ───────────────────────────────────────────────────────────────────────────────
; Final Amounts
; ───────────────────────────────────────────────────────────────────────────────
{.final_amounts}
sale_price = !#$:(0..)                            ; Final sale price
loan_amount = #$:(0..)                            ; Loan amount funded
earnest_money_credit = #$:(0..)                   ; Earnest money applied
down_payment = #$:(0..)                           ; Down payment
seller_credits = #$:(0..)                         ; Seller credits to buyer
total_buyer_credits = #$:(0..)                    ; Total credits to buyer
total_seller_credits = #$:(0..)                   ; Total credits to seller

{@purchase_closing}

; ───────────────────────────────────────────────────────────────────────────────
; Buyer Charges
; ───────────────────────────────────────────────────────────────────────────────
{.buyer_charges}
loan_origination = #$:(0..)                       ; Loan origination fee
discount_points = #$:(0..)                        ; Discount points
appraisal_fee = #$:(0..)                          ; Appraisal fee
credit_report = #$:(0..)                          ; Credit report fee
flood_certification = #$:(0..)                    ; Flood certification
tax_service = #$:(0..)                            ; Tax service fee
title_insurance = #$:(0..)                        ; Title insurance premium
title_search = #$:(0..)                           ; Title search/exam
settlement_fee = #$:(0..)                         ; Settlement/closing fee
recording_fees = #$:(0..)                         ; Recording charges
transfer_taxes = #$:(0..)                         ; Transfer taxes (buyer share)
prepaid_interest = #$:(0..)                       ; Prepaid interest
prepaid_insurance = #$:(0..)                      ; Prepaid hazard insurance
prepaid_taxes = #$:(0..)                          ; Prepaid property taxes
initial_escrow = #$:(0..)                         ; Initial escrow deposit
other_charges = #$:(0..)                          ; Other charges
total_buyer_charges = #$:(0..)                    ; Total buyer charges

{@purchase_closing}

; ───────────────────────────────────────────────────────────────────────────────
; Seller Charges
; ───────────────────────────────────────────────────────────────────────────────
{.seller_charges}
listing_commission = #$:(0..)                     ; Listing broker commission
buyer_broker_commission = #$:(0..)                ; Buyer broker commission
title_insurance = #$:(0..)                        ; Owner's title (if seller pays)
transfer_taxes = #$:(0..)                         ; Transfer taxes (seller share)
recording_fees = #$:(0..)                         ; Recording charges
documentary_stamps = #$:(0..)                     ; Documentary stamps
seller_attorney = #$:(0..)                        ; Seller attorney fees
hoa_fees = #$:(0..)                               ; HOA fees/clearance
loan_payoff = #$:(0..)                            ; Existing loan payoff
lien_payoffs = #$:(0..)                           ; Other lien payoffs
proration_debits = #$:(0..)                       ; Proration debits
other_charges = #$:(0..)                          ; Other seller charges
total_seller_charges = #$:(0..)                   ; Total seller charges

{@purchase_closing}

; ───────────────────────────────────────────────────────────────────────────────
; Settlement
; ───────────────────────────────────────────────────────────────────────────────
{.settlement}
cash_from_buyer = #$:(0..)                        ; Cash from buyer to close
cash_to_seller = #$:(0..)                         ; Net proceeds to seller
wire_transfer = ?                                 ; Funds wired
wire_date = date:if wire_transfer = true          ; Wire date
cashiers_check = ?                                ; Cashier's check
certified_funds_received = ?                      ; Funds received

{@purchase_closing}

; ───────────────────────────────────────────────────────────────────────────────
; Recording
; ───────────────────────────────────────────────────────────────────────────────
{.recording}
deed_recorded = ?                                 ; Deed recorded
deed_recording_date = date:if deed_recorded = true
deed_book = ::if deed_recorded = true             ; Deed book number
deed_page = ::if deed_recorded = true             ; Deed page number
deed_instrument = ::if deed_recorded = true       ; Instrument number
mortgage_recorded = ?                             ; Mortgage/DOT recorded
mortgage_recording_date = date:if mortgage_recorded = true
mortgage_book = ::if mortgage_recorded = true     ; Mortgage book
mortgage_page = ::if mortgage_recorded = true     ; Mortgage page
mortgage_instrument = ::if mortgage_recorded = true  ; Mortgage instrument number

{@purchase_closing}

; ───────────────────────────────────────────────────────────────────────────────
; Title Policies
; ───────────────────────────────────────────────────────────────────────────────
owner_policy_issued = ?                           ; Owner's policy issued
owner_policy_amount = #$:(0..):if owner_policy_issued = true
lender_policy_issued = ?                          ; Lender's policy issued
lender_policy_amount = #$:(0..):if lender_policy_issued = true

; Bridge to title insurance schema
owner_policy_ref = @title_owner_policy            ; Bridge to owner's policy
lender_policy_ref = @title_lender_policy          ; Bridge to lender's policy

; ───────────────────────────────────────────────────────────────────────────────
; Closing Status
; ───────────────────────────────────────────────────────────────────────────────
status = (cancelled, completed, funded, pending, recorded, scheduled)
funding_date = date                               ; Date funds disbursed
disbursement_date = date                          ; Date checks/wires sent
possession_transferred = ?                        ; Possession transferred
key_exchange_date = date                          ; Date keys exchanged


; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Real Estate Settlement Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Closing/settlement statements based on the CFPB Closing Disclosure (TRID)
; and HUD-1 formats. Covers loan costs, other costs, cash-to-close
; calculations, borrower and seller transaction summaries, prorations, and
; non-TRID settlement statements for cash and commercial transactions.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as common
@import "../types.schema.odin" as re

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.realestate.escrow.settlement"
version = "1.0.0"
title = "Real Estate Settlement Schema"
description = "Closing disclosure and settlement statement management"

{$derivation}
source[0].authority = "Consumer Financial Protection Bureau"
source[0].citation = "TILA-RESPA Integrated Disclosure Rule (TRID)"
source[0].url = "https://www.consumerfinance.gov/rules-policy/regulations/1026/37/"

source[1].authority = "HUD"
source[1].citation = "Real Estate Settlement Procedures Act (RESPA)"
source[1].url = "https://www.consumerfinance.gov/compliance/compliance-resources/mortgage-resources/respa/"

source[2].authority = "American Land Title Association"
source[2].citation = "ALTA Settlement Statement Best Practices"
source[2].url = "https://www.alta.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Settlement schema derived from CFPB TRID and RESPA requirements"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial settlement schema"
changelog[0].rationale = "TRID-compliant closing disclosure structure"

; ═══════════════════════════════════════════════════════════════════════════════
; CLOSING DISCLOSURE
; ═══════════════════════════════════════════════════════════════════════════════
; CFPB Closing Disclosure form (Page 1-5)

{@closing_disclosure}
; Required fields first
closing_date = !date                                 ; Closing/settlement date
disbursement_date = !date                            ; Disbursement date
loan_amount = !#$:(0..)                              ; Total loan amount
property_address = !@address                         ; Property address
sale_price = !#$:(0..)                               ; Contract sale price

; CD identification
cd_id = :                                            ; Unique CD identifier
file_number = :                                      ; Escrow/title file number
loan_number = :                                      ; Lender loan number

; Transaction type
transaction_type = !(purchase, refinance)

; ───────────────────────────────────────────────────────────────────────────────
; Transaction Information (Page 1)
; ───────────────────────────────────────────────────────────────────────────────
{.transaction}
property_type = (manufactured, mixed_use, multi_family, single_family)
property_location = (attached, condominium, cooperative, detached, pud)
purpose = (construction, home_equity, purchase, refinance)
product = :                                          ; Loan product description

{@closing_disclosure}

; ───────────────────────────────────────────────────────────────────────────────
; Parties
; ───────────────────────────────────────────────────────────────────────────────
{.borrower}
name = !:                                            ; Borrower name
address = @address                                   ; Borrower address

{@closing_disclosure}

{.seller}
name = :                                             ; Seller name
address = @address                                   ; Seller address

{@closing_disclosure}

{.lender}
name = :                                             ; Lender name
nmls_id = :                                          ; Lender NMLS ID
address = @address                                   ; Lender address

{@closing_disclosure}

{.settlement_agent}
name = :                                             ; Settlement agent name
address = @address                                   ; Settlement agent address
email = @email                                       ; Settlement agent email
phone = @phone                                       ; Settlement agent phone

{@closing_disclosure}

; ───────────────────────────────────────────────────────────────────────────────
; Loan Terms (Page 1)
; ───────────────────────────────────────────────────────────────────────────────
{.loan_terms}
loan_amount = #$:(0..)                               ; Loan amount
interest_rate = #:(0..100)                           ; Interest rate
monthly_principal_interest = #$:(0..)                ; Monthly P&I
prepayment_penalty = ?                               ; Has prepayment penalty
balloon_payment = ?                                  ; Has balloon payment
balloon_amount = #$:(0..):if balloon_payment = true  ; Balloon amount

{@closing_disclosure}

; ───────────────────────────────────────────────────────────────────────────────
; Projected Payments (Page 1)
; ───────────────────────────────────────────────────────────────────────────────
{.projected_payments[]}
period = :                                           ; Payment period description
years = :                                            ; Years range (e.g., "1-7")
principal_interest = #$:(0..)                        ; P&I payment
mortgage_insurance = #$:(0..)                        ; Mortgage insurance
escrow = #$:(0..)                                    ; Escrow amount
total_payment = #$:(0..)                             ; Total monthly payment
estimated_taxes = #$:(0..)                           ; Est. taxes in escrow
estimated_insurance = #$:(0..)                       ; Est. insurance in escrow
estimated_other = #$:(0..)                           ; Est. other in escrow

{@closing_disclosure}

; ───────────────────────────────────────────────────────────────────────────────
; Costs at Closing (Page 1)
; ───────────────────────────────────────────────────────────────────────────────
{.costs_at_closing}
closing_costs = #$:(0..)                             ; Total closing costs
cash_to_close = #$                                   ; Cash to close (can be negative for refund)

{@closing_disclosure}

; ───────────────────────────────────────────────────────────────────────────────
; Loan Costs (Page 2 - Section A, B, C)
; ───────────────────────────────────────────────────────────────────────────────
; Section A - Origination Charges
{.loan_costs.origination}
origination_fee = #$:(0..)                           ; Origination fee
points = #:(0..)                                     ; Discount points percentage
points_amount = #$:(0..)                             ; Discount points amount
application_fee = #$:(0..)                           ; Application fee
underwriting_fee = #$:(0..)                          ; Underwriting fee
processing_fee = #$:(0..)                            ; Processing fee
other_origination[] = :                              ; Other origination charges
section_a_total = #$:(0..)                           ; Section A total

{@closing_disclosure}

; Section B - Services You Cannot Shop For
{.loan_costs.cannot_shop}
appraisal_fee = #$:(0..)                             ; Appraisal fee
credit_report_fee = #$:(0..)                         ; Credit report
flood_certification = #$:(0..)                       ; Flood determination
tax_service_fee = #$:(0..)                           ; Tax service fee
title_services = #$:(0..)                            ; Title services (if lender-selected)
other_cannot_shop[] = :                              ; Other services
section_b_total = #$:(0..)                           ; Section B total

{@closing_disclosure}

; Section C - Services You Did Shop For
{.loan_costs.can_shop}
pest_inspection = #$:(0..)                           ; Pest inspection
survey = #$:(0..)                                    ; Survey
title_insurance = #$:(0..)                           ; Title insurance premiums
title_search = #$:(0..)                              ; Title search
settlement_fee = #$:(0..)                            ; Settlement/closing fee
other_can_shop[] = :                                 ; Other services
section_c_total = #$:(0..)                           ; Section C total

{@closing_disclosure}

; Total Loan Costs
total_loan_costs = #$:(0..)                          ; D = A + B + C

{@closing_disclosure}

; ───────────────────────────────────────────────────────────────────────────────
; Other Costs (Page 2 - Section E, F, G, H)
; ───────────────────────────────────────────────────────────────────────────────
; Section E - Taxes and Government Fees
{.other_costs.government}
recording_fees = #$:(0..)                            ; Recording fees
deed_recording = #$:(0..)                            ; Deed recording
mortgage_recording = #$:(0..)                        ; Mortgage recording
transfer_taxes = #$:(0..)                            ; Transfer taxes
city_county_stamps = #$:(0..)                        ; City/county stamps
state_stamps = #$:(0..)                              ; State stamps
section_e_total = #$:(0..)                           ; Section E total

{@closing_disclosure}

; Section F - Prepaids
{.other_costs.prepaids}
homeowners_insurance_premium = #$:(0..)              ; HOI premium
months_prepaid_insurance = ##:(0..)                  ; Months prepaid
daily_interest_charge = #$:(0..)                     ; Daily interest
days_prepaid_interest = ##:(0..)                     ; Days prepaid
prepaid_interest_total = #$:(0..)                    ; Total prepaid interest
mortgage_insurance_premium = #$:(0..)                ; MI premium prepaid
property_taxes = #$:(0..)                            ; Property taxes prepaid
months_prepaid_taxes = ##:(0..)                      ; Months taxes prepaid
section_f_total = #$:(0..)                           ; Section F total

{@closing_disclosure}

; Section G - Initial Escrow at Closing
{.other_costs.escrow}
homeowners_insurance = #$:(0..)                      ; HOI in escrow
months_hoi_escrow = ##:(0..)                         ; Months HOI
mortgage_insurance = #$:(0..)                        ; MI in escrow
months_mi_escrow = ##:(0..)                          ; Months MI
property_taxes = #$:(0..)                            ; Taxes in escrow
months_tax_escrow = ##:(0..)                         ; Months taxes
aggregate_adjustment = #$                            ; Aggregate adjustment
section_g_total = #$:(0..)                           ; Section G total

{@closing_disclosure}

; Section H - Other
{.other_costs.other}
hoa_dues = #$:(0..)                                  ; HOA dues
home_warranty = #$:(0..)                             ; Home warranty
real_estate_commission = #$:(0..)                    ; RE commission (seller)
title_owner_policy = #$:(0..)                        ; Owner's title insurance
other_costs[] = :                                    ; Other costs
section_h_total = #$:(0..)                           ; Section H total

{@closing_disclosure}

; Total Other Costs
total_other_costs = #$:(0..)                         ; I = E + F + G + H

{@closing_disclosure}

; ───────────────────────────────────────────────────────────────────────────────
; Total Closing Costs (Page 2)
; ───────────────────────────────────────────────────────────────────────────────
{.closing_costs}
total_loan_costs = #$:(0..)                          ; D - Total Loan Costs
total_other_costs = #$:(0..)                         ; I - Total Other Costs
total_closing_costs = #$:(0..)                       ; J = D + I
lender_credits = #$:(0..)                            ; Lender credits
closing_costs_financed = #$:(0..)                    ; Closing costs financed
down_payment_funds = #$:(0..)                        ; Down payment from borrower

{@closing_disclosure}

; ───────────────────────────────────────────────────────────────────────────────
; Calculating Cash to Close (Page 3)
; ───────────────────────────────────────────────────────────────────────────────
{.cash_to_close}
total_closing_costs = #$:(0..)                       ; Total closing costs (J)
closing_costs_financed = #$:(0..)                    ; Less: Financed
down_payment_funds = #$:(0..)                        ; Less: Down payment/funds
deposit = #$:(0..)                                   ; Less: Deposit
funds_for_borrower = #$:(0..)                        ; Less: Funds for borrower
seller_credits = #$:(0..)                            ; Less: Seller credits
adjustments = #$                                     ; Plus/minus adjustments
cash_to_close = #$                                   ; Cash to close

{@closing_disclosure}

; LE comparison
{.cash_to_close.le_comparison}
le_cash_to_close = #$                                ; LE Cash to close
change_amount = #$                                   ; Change from LE
change_reason = :                                    ; Reason for change

{@closing_disclosure}

; ───────────────────────────────────────────────────────────────────────────────
; Summaries of Transactions (Page 3)
; ───────────────────────────────────────────────────────────────────────────────
; Borrower's Transaction
{.borrower_transaction}
sale_price = #$:(0..)                                ; Sale price
sale_price_personal_property = #$:(0..)              ; Personal property in sale
closing_costs = #$:(0..)                             ; Closing costs to borrower
adjustments_paid_by_seller = #$:(0..)                ; Items paid by seller in advance
city_town_taxes = #$:(0..)                           ; City/town taxes
county_taxes = #$:(0..)                              ; County taxes
assessments = #$:(0..)                               ; Assessments
hoa_dues = #$:(0..)                                  ; HOA dues prepaid by seller
other_credits[] = :                                  ; Other adjustments
total_due_from_borrower = #$:(0..)                   ; K - Total due from borrower

{@closing_disclosure}

; Borrower credits
{.borrower_transaction.credits}
deposit = #$:(0..)                                   ; Earnest money deposit
loan_amount = #$:(0..)                               ; Loan amount
other_loans = #$:(0..)                               ; Other loans
seller_credit = #$:(0..)                             ; Seller credit
rebates = #$:(0..)                                   ; Rebates
adjustments_unpaid_by_seller = #$:(0..)              ; Items unpaid by seller
city_town_taxes = #$:(0..)                           ; City/town taxes owed
county_taxes = #$:(0..)                              ; County taxes owed
assessments = #$:(0..)                               ; Assessments owed
other_adjustments[] = :                              ; Other adjustments
total_paid_by_borrower = #$:(0..)                    ; L - Total paid by/for borrower
cash_to_close = #$                                   ; M = K - L

{@closing_disclosure}

; Seller's Transaction
{.seller_transaction}
sale_price = #$:(0..)                                ; Sale price
sale_price_personal_property = #$:(0..)              ; Personal property
adjustments_paid_by_seller = #$:(0..)                ; Items paid by seller in advance
city_town_taxes = #$:(0..)                           ; City/town taxes prepaid
county_taxes = #$:(0..)                              ; County taxes prepaid
assessments = #$:(0..)                               ; Assessments prepaid
hoa_dues = #$:(0..)                                  ; HOA dues prepaid
other_credits[] = :                                  ; Other credits
total_due_to_seller = #$:(0..)                       ; N - Total due to seller

{@closing_disclosure}

; Seller debits
{.seller_transaction.debits}
excess_deposit = #$:(0..)                            ; Excess deposit
closing_costs = #$:(0..)                             ; Closing costs to seller
existing_loans = #$:(0..)                            ; Existing loan payoff
payoff_first_mortgage = #$:(0..)                     ; First mortgage payoff
payoff_second_mortgage = #$:(0..)                    ; Second mortgage payoff
seller_credit = #$:(0..)                             ; Seller credit to buyer
adjustments_unpaid_by_seller = #$:(0..)              ; Items unpaid
city_town_taxes = #$:(0..)                           ; City/town taxes owed
county_taxes = #$:(0..)                              ; County taxes owed
assessments = #$:(0..)                               ; Assessments owed
other_adjustments[] = :                              ; Other adjustments
total_paid_by_seller = #$:(0..)                      ; O - Total from seller
cash_to_seller = #$                                  ; P = N - O

{@closing_disclosure}

; ───────────────────────────────────────────────────────────────────────────────
; Loan Disclosures (Page 4)
; ───────────────────────────────────────────────────────────────────────────────
{.loan_disclosures}
assumption = ?                                       ; Loan is assumable
demand_feature = ?                                   ; Has demand feature
late_payment = :                                     ; Late payment terms
negative_amortization = ?                            ; Has negative amortization
partial_payments = :                                 ; Partial payment policy
security_interest = :                                ; Security interest description
escrow_account = ?                                   ; Has escrow account
escrow_escrowed_items = :                            ; Items escrowed
escrow_non_escrowed_items = :                        ; Items not escrowed
estimated_annual_escrow = #$:(0..)                   ; Est. annual escrow
initial_escrow_payment = #$:(0..)                    ; Initial escrow payment

{@closing_disclosure}

; ───────────────────────────────────────────────────────────────────────────────
; Loan Calculations (Page 5)
; ───────────────────────────────────────────────────────────────────────────────
{.loan_calculations}
total_of_payments = #$:(0..)                         ; Total of all payments
finance_charge = #$:(0..)                            ; Finance charge
amount_financed = #$:(0..)                           ; Amount financed
apr = #:(0..100)                                     ; Annual percentage rate
tip = #:(0..100)                                     ; Total interest percentage

{@closing_disclosure}

; ───────────────────────────────────────────────────────────────────────────────
; Contact Information (Page 5)
; ───────────────────────────────────────────────────────────────────────────────
{.contacts.lender}
name = :                                             ; Lender name
nmls_id = :                                          ; NMLS ID
address = @address                                   ; Address
contact = :                                          ; Contact person
contact_nmls = :                                     ; Contact NMLS
email = @email                                       ; Email
phone = @phone                                       ; Phone

{@closing_disclosure}

{.contacts.mortgage_broker}
name = :                                             ; Broker name
nmls_id = :                                          ; NMLS ID
address = @address                                   ; Address
contact = :                                          ; Contact person
contact_nmls = :                                     ; Contact NMLS
email = @email                                       ; Email
phone = @phone                                       ; Phone

{@closing_disclosure}

{.contacts.real_estate_broker_buyer}
name = :                                             ; Broker name
license = :                                          ; License number
address = @address                                   ; Address
contact = :                                          ; Agent name
license_contact = :                                  ; Agent license
email = @email                                       ; Email
phone = @phone                                       ; Phone

{@closing_disclosure}

{.contacts.real_estate_broker_seller}
name = :                                             ; Broker name
license = :                                          ; License number
address = @address                                   ; Address
contact = :                                          ; Agent name
license_contact = :                                  ; Agent license
email = @email                                       ; Email
phone = @phone                                       ; Phone

{@closing_disclosure}

{.contacts.settlement_agent}
name = :                                             ; Settlement agent name
license = :                                          ; License number
address = @address                                   ; Address
contact = :                                          ; Contact person
email = @email                                       ; Email
phone = @phone                                       ; Phone

{@closing_disclosure}

; ───────────────────────────────────────────────────────────────────────────────
; Confirm Receipt (Page 5)
; ───────────────────────────────────────────────────────────────────────────────
{.receipt}
applicant_signature = :                              ; Applicant signature
applicant_date = date                                ; Applicant date
co_applicant_signature = :                           ; Co-applicant signature
co_applicant_date = date                             ; Co-applicant date

{@closing_disclosure}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
cd_type = (initial, revised)
revision_date = date:if cd_type = revised            ; Revision date
revision_reason = ::if cd_type = revised             ; Revision reason
status = (cancelled, closed, delivered, pending, revised)
status_date = date                                   ; Status date

; ═══════════════════════════════════════════════════════════════════════════════
; SETTLEMENT STATEMENT (Cash/Commercial)
; ═══════════════════════════════════════════════════════════════════════════════
; Non-TRID settlement statement for cash and commercial transactions

{@settlement_statement}
; Required fields first
closing_date = !date                                 ; Closing date
property_address = !@address                         ; Property address
sale_price = !#$:(0..)                               ; Sale price

; Statement identification
statement_id = :                                     ; Unique identifier
file_number = :                                      ; File number

; Transaction type
transaction_type = !(cash_purchase, commercial, exchange_1031, refinance)

; ───────────────────────────────────────────────────────────────────────────────
; Parties
; ───────────────────────────────────────────────────────────────────────────────
{.buyer}
name = :                                             ; Buyer name
entity_type = (corporation, individual, llc, partnership, trust)
address = @address                                   ; Address
tax_id = *:                                          ; Tax ID (confidential)

{@settlement_statement}

{.seller}
name = :                                             ; Seller name
entity_type = (corporation, individual, llc, partnership, trust)
address = @address                                   ; Address
tax_id = *:                                          ; Tax ID (confidential)

{@settlement_statement}

; ───────────────────────────────────────────────────────────────────────────────
; Buyer Side
; ───────────────────────────────────────────────────────────────────────────────
{.buyer_debits}
purchase_price = #$:(0..)                            ; Purchase price
closing_costs = #$:(0..)                             ; Closing costs
recording_fees = #$:(0..)                            ; Recording fees
title_insurance = #$:(0..)                           ; Title insurance
escrow_fee = #$:(0..)                                ; Escrow fee
prorated_taxes = #$:(0..)                            ; Prorated taxes (if prepaid)
prorated_rent = #$:(0..)                             ; Prorated rent (if applicable)
other_debits[] = :                                   ; Other debits
total_debits = #$:(0..)                              ; Total buyer debits

{@settlement_statement}

{.buyer_credits}
earnest_money = #$:(0..)                             ; Earnest money deposit
loan_proceeds = #$:(0..)                             ; Loan proceeds (if financed)
seller_credit = #$:(0..)                             ; Seller credit
prorated_taxes = #$:(0..)                            ; Prorated taxes (if owed)
prorated_rent = #$:(0..)                             ; Prorated rent collected
security_deposits = #$:(0..)                         ; Security deposits transferred
other_credits[] = :                                  ; Other credits
total_credits = #$:(0..)                             ; Total buyer credits

{@settlement_statement}

; Buyer balance
buyer_balance_due = #$                               ; Balance due from buyer

; ───────────────────────────────────────────────────────────────────────────────
; Seller Side
; ───────────────────────────────────────────────────────────────────────────────
{.seller_credits}
sale_price = #$:(0..)                                ; Sale price
prorated_taxes = #$:(0..)                            ; Prorated taxes prepaid
prorated_rent = #$:(0..)                             ; Prorated rent (if collected)
other_credits[] = :                                  ; Other credits
total_credits = #$:(0..)                             ; Total seller credits

{@settlement_statement}

{.seller_debits}
existing_liens = #$:(0..)                            ; Existing liens payoff
first_mortgage = #$:(0..)                            ; First mortgage payoff
second_mortgage = #$:(0..)                           ; Second mortgage payoff
closing_costs = #$:(0..)                             ; Closing costs
real_estate_commission = #$:(0..)                    ; RE commission
transfer_tax = #$:(0..)                              ; Transfer tax
recording_fees = #$:(0..)                            ; Recording fees
title_insurance = #$:(0..)                           ; Title insurance
escrow_fee = #$:(0..)                                ; Escrow fee
seller_credit = #$:(0..)                             ; Credit to buyer
prorated_taxes = #$:(0..)                            ; Prorated taxes owed
security_deposits = #$:(0..)                         ; Security deposits transferred
other_debits[] = :                                   ; Other debits
total_debits = #$:(0..)                              ; Total seller debits

{@settlement_statement}

; Seller balance
seller_proceeds = #$                                 ; Net proceeds to seller

; ───────────────────────────────────────────────────────────────────────────────
; Prorations
; ───────────────────────────────────────────────────────────────────────────────
{.prorations}
proration_date = date                                ; Proration date
proration_method = (per_diem, 30_day, 365_day)       ; Proration method

{@settlement_statement}

{.prorations.items[]}
item = :                                             ; Prorated item
period_start = date                                  ; Period start
period_end = date                                    ; Period end
total_amount = #$:(0..)                              ; Total amount for period
days_to_seller = ##:(0..)                            ; Days charged to seller
days_to_buyer = ##:(0..)                             ; Days charged to buyer
seller_amount = #$:(0..)                             ; Seller's share
buyer_amount = #$:(0..)                              ; Buyer's share

{@settlement_statement}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (cancelled, closed, draft, final)
status_date = date                                   ; Status date


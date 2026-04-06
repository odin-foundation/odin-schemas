; ===================================================================================
; ODIN Finance Trade Schema
; ===================================================================================
; Trade finance covering letters of credit, documentary collections, bank
; guarantees, supply chain finance, and forfaiting. Derived from UCP 600,
; ISP98, URC 522, and URDG 758 frameworks.
; ===================================================================================

@import "../types.schema.odin" as fin

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.finance.trade"
version = "1.0.0"
title = "Finance Trade Schema"
description = "Comprehensive trade finance schema for LCs, collections, guarantees, supply chain finance, and forfaiting"

{$derivation}
source[0].authority = "International Chamber of Commerce"
source[0].citation = "UCP 600 - Uniform Customs and Practice for Documentary Credits"
source[0].url = "https://iccwbo.org/business-solutions/banking-finance/ucp-600/"

source[1].authority = "International Chamber of Commerce"
source[1].citation = "ISP98 - International Standby Practices"
source[1].url = "https://iccwbo.org/business-solutions/banking-finance/isp98/"

source[2].authority = "International Chamber of Commerce"
source[2].citation = "URC 522 - Uniform Rules for Collections"
source[2].url = "https://iccwbo.org/business-solutions/banking-finance/urc-522/"

source[3].authority = "International Chamber of Commerce"
source[3].citation = "URDG 758 - Uniform Rules for Demand Guarantees"
source[3].url = "https://iccwbo.org/business-solutions/banking-finance/urdg-758/"

source[4].authority = "International Chamber of Commerce"
source[4].citation = "Standard Definitions for Techniques of Supply Chain Finance"
source[4].url = "https://iccwbo.org/business-solutions/banking-finance/supply-chain-finance/"

source[5].authority = "Uniform Law Commission"
source[5].citation = "UCC Article 5 - Letters of Credit"
source[5].url = "https://www.uniformlaws.org/committees/community-home?communitykey=1457c422-ddb7-40b0-8c76-39a1991651ac"

source[6].authority = "SWIFT"
source[6].citation = "MT700 Series - Documentary Credits and Guarantees"
source[6].url = "https://www.swift.com/standards/data-standards/mt-message-standards"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Derived from ICC rules (UCP 600, ISP98, URC 522, URDG 758), SWIFT standards, and UCC Article 5"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial trade finance schema"
changelog[0].rationale = "Comprehensive trade finance coverage for documentary trade and supply chain finance"

; ===================================================================================
; TRADE PARTY
; ===================================================================================
; Parties involved in trade finance transactions.

{@trade_party}
; Required fields first
party_id = !:                                   ; Party identifier
party_type = !(
    advising_bank,                              ; Advising bank
    applicant,                                  ; LC applicant (buyer)
    beneficiary,                                ; LC beneficiary (seller)
    buyer,                                      ; Buyer/importer
    collecting_bank,                            ; Collecting bank
    confirming_bank,                            ; Confirming bank
    drawee,                                     ; Drawee of draft
    drawer,                                     ; Drawer of draft
    forfaiter,                                  ; Forfaiting bank
    guarantor_bank,                             ; Guarantee issuing bank
    instructing_bank,                           ; Instructing party
    issuing_bank,                               ; LC/guarantee issuing bank
    negotiating_bank,                           ; Negotiating bank
    nominated_bank,                             ; Nominated bank
    paying_bank,                                ; Paying bank
    presenting_bank,                            ; Presenting bank
    principal,                                  ; Guarantee principal
    reimbursing_bank,                           ; Reimbursing bank
    remitting_bank,                             ; Remitting bank
    seller,                                     ; Seller/exporter
    supplier                                    ; Supplier (SCF)
)
name = !:                                       ; Party legal name

; Financial institution details (for banks)
bic = :format bic  ; SWIFT BIC
lei = :format lei                         ; Legal Entity Identifier

; Address
addresses[] = @address                          ; Party addresses (HQ, operations)
country = :(2)                                  ; ISO country code

; Contact
contact_names[] = :                             ; Contact persons (buyer, ops, logistics)
emails[] = *@email                              ; Emails (multiple contacts)
phones[] = *@phone                              ; Phones (multiple departments, time zones)

; Bank account (for payments)
accounts[] = @fin.account                       ; Bank accounts (multiple currencies)

; ===================================================================================
; LETTER OF CREDIT
; ===================================================================================
; Documentary letters of credit per UCP 600.

{@letter_of_credit}
; Required fields first
lc_number = !:                                  ; LC reference number
lc_type = !(
    commercial,                                 ; Commercial documentary LC
    confirmed,                                  ; Confirmed LC
    deferred_payment,                           ; Deferred payment LC
    green_clause,                               ; Green clause (advance for packaging)
    negotiation,                                ; Negotiation LC
    red_clause,                                 ; Red clause (advance before shipment)
    revolving,                                  ; Revolving LC
    sight,                                      ; Sight LC
    standby,                                    ; Standby LC (ISP98)
    transferable,                               ; Transferable LC
    usance                                      ; Usance/time LC
)
amount = !#$:(0..)                              ; LC amount
currency = !:(3)                                ; LC currency

; Parties
applicants[] = !@trade_party                    ; Applicants (joint importers)
beneficiaries[] = !@trade_party                 ; Beneficiaries (transferable LC has multiple)
issuing_bank = !@trade_party                    ; Issuing bank
advising_bank = @trade_party                    ; Advising bank
confirming_bank = @trade_party                  ; Confirming bank (if confirmed)
nominated_bank = @trade_party                   ; Nominated bank
reimbursing_bank = @trade_party                 ; Reimbursing bank

; Governing rules
governing_rules = !(
    isp98,                                      ; International Standby Practices
    ucp_600,                                    ; UCP 600 (most common)
    ucp_latest,                                 ; Latest UCP version
    ucc_article_5                               ; US domestic
)

; Status
status = (
    advised,                                    ; Advised to beneficiary
    amended,                                    ; Amended
    cancelled,                                  ; Cancelled
    closed,                                     ; Closed
    claimed,                                    ; Claim made (standby)
    discrepant,                                 ; Documents with discrepancies
    drawing_paid,                               ; Drawing paid
    expired,                                    ; Expired unused
    issued,                                     ; Issued
    negotiated,                                 ; Documents negotiated
    paid,                                       ; Fully paid
    pending,                                    ; Pending issuance
    presented,                                  ; Documents presented
    rejected,                                   ; Application rejected
    transferred                                 ; Transferred to another beneficiary
)

; ---------------------------------------------------------------------------
; Dates
; ---------------------------------------------------------------------------
{.dates}
issue_date = date                               ; Date of issue
expiry_date = !date                             ; Expiry date
expiry_place = :                                ; Place of expiry
latest_shipment = date                          ; Latest shipment date
latest_presentation = date                      ; Latest presentation date
period_for_presentation = ##:(0..) "21"         ; Days after shipment for presentation

{@letter_of_credit}

; ---------------------------------------------------------------------------
; Payment Terms
; ---------------------------------------------------------------------------
{.payment_terms}
available_with = (
    advising_bank,
    any_bank,
    confirming_bank,
    issuing_bank,
    nominated_bank
)
available_by = !(
    acceptance,                                 ; Acceptance of draft
    deferred_payment,                           ; Deferred payment
    mixed_payment,                              ; Mixed payment terms
    negotiation,                                ; Negotiation
    sight_payment                               ; Payment at sight
)

; Sight terms
at_sight = ?:if available_by = sight_payment

; Usance terms
tenor_days = ##:if available_by = acceptance    ; Days after sight/shipment
tenor_from = (
    bill_of_lading_date,
    invoice_date,
    sight
):if available_by = acceptance
draft_required = ?:if available_by = acceptance
draft_drawn_on = ::if draft_required = true     ; Drawee bank

; Deferred payment terms
deferred_days = ##:if available_by = deferred_payment
deferred_from = (
    bill_of_lading_date,
    invoice_date,
    presentation_date
):if available_by = deferred_payment

{@letter_of_credit}

; ---------------------------------------------------------------------------
; Amounts
; ---------------------------------------------------------------------------
{.amounts}
lc_amount = #$:(0..)                            ; Original LC amount
tolerance_plus = #:(0..10) "0"                  ; Plus tolerance %
tolerance_minus = #:(0..10) "0"                 ; Minus tolerance %
maximum_amount = #$:(0..)                       ; Maximum drawable
drawn_amount = #$:(0..)                         ; Amount drawn to date
available_amount = #$:(0..)                     ; Amount still available

{@letter_of_credit}

; ---------------------------------------------------------------------------
; Shipment Details
; ---------------------------------------------------------------------------
{.shipment}
partial_shipments = (allowed, not_allowed)      ; Partial shipment
transshipment = (allowed, not_allowed)          ; Transshipment
loading_ports[] = :                             ; Ports of loading (multi-origin)
discharge_ports[] = :                           ; Ports of discharge (split shipments)
loading_place = :                               ; Place of loading (multimodal)
final_destination = :                           ; Final destination
transport_mode = (
    air,
    courier,
    multimodal,
    rail,
    road,
    sea
)
incoterms = :(3)                                ; Incoterms code (CIF, FOB, etc.)
incoterms_place = :                             ; Incoterms named place

{@letter_of_credit}

; ---------------------------------------------------------------------------
; Goods Description
; ---------------------------------------------------------------------------
{.goods}
description = !:                                ; Goods description
hs_codes[] = :(10)                              ; HS codes (multiple goods types)
countries_of_origin[] = :(2)                    ; Origin countries (multi-component goods)
quantity = :                                    ; Quantity/unit
unit_price = #$:(0..)                           ; Unit price
total_value = #$:(0..)                          ; Total value

{@letter_of_credit}

; ---------------------------------------------------------------------------
; Required Documents
; ---------------------------------------------------------------------------
documents[] = @required_document                ; Required documents

{@required_document}
document_type = !(
    airway_bill,
    beneficiary_certificate,
    bill_of_exchange,
    bill_of_lading,
    certificate_of_analysis,
    certificate_of_conformity,
    certificate_of_inspection,
    certificate_of_insurance,
    certificate_of_origin,
    commercial_invoice,
    consular_invoice,
    draft,
    forwarders_certificate,
    health_certificate,
    insurance_policy,
    multimodal_transport_document,
    other,
    packing_list,
    phytosanitary_certificate,
    quality_certificate,
    shipping_advice,
    weight_certificate
)
document_name = :                               ; Document name/description
copies_required = ##:(1..)                      ; Number of copies
originals_required = ##:(0..)                   ; Number of originals
issued_by = :                                   ; Required issuer
special_instructions = :                        ; Special requirements

; ---------------------------------------------------------------------------
; Confirmation
; ---------------------------------------------------------------------------
{@letter_of_credit}

{.confirmation}
confirmed = ?                                   ; Confirmed LC
confirmation_bank = ::if confirmed = true       ; Confirming bank name
confirmation_date = date:if confirmed = true    ; Confirmation date
confirmation_charges = (
    beneficiary,                                ; Beneficiary pays
    other                                       ; Applicant or shared
):if confirmed = true

{@letter_of_credit}

; ---------------------------------------------------------------------------
; Charges
; ---------------------------------------------------------------------------
{.charges}
issuing_bank_charges = (applicant, beneficiary, shared)
advising_bank_charges = (applicant, beneficiary, shared)
confirming_charges = (applicant, beneficiary, shared)
reimbursement_charges = (applicant, beneficiary, shared)
amendment_charges = (applicant, beneficiary, shared)

{@letter_of_credit}

; ---------------------------------------------------------------------------
; SWIFT MT References
; ---------------------------------------------------------------------------
{.swift}
mt700_reference = :                             ; MT700 Issue reference
mt710_reference = :                             ; MT710 Advice reference
mt707_reference = :                             ; MT707 Amendment reference
mt730_reference = :                             ; MT730 Acknowledgment reference
mt799_reference = :                             ; MT799 Free format

{@letter_of_credit}

; ---------------------------------------------------------------------------
; Special Conditions
; ---------------------------------------------------------------------------
special_conditions[] = :                        ; Additional conditions (Field 47A)
advices_required = ?                            ; Pre-advice required
confirm_if_requested = ?                        ; May add confirmation

; ===================================================================================
; LC AMENDMENT
; ===================================================================================
; Letter of credit amendment per UCP 600 Article 10.

{@lc_amendment}
; Required fields first
amendment_number = !:                           ; Amendment sequence number
lc_reference = !:                               ; Original LC reference
amendment_date = !date                          ; Amendment date

; Amendment details
{.changes}
new_amount = #$:(0..)                           ; New LC amount
amount_increase = #$:(0..)                      ; Amount increase
amount_decrease = #$:(0..)                      ; Amount decrease
new_expiry_date = date                          ; New expiry date
new_latest_shipment = date                      ; New shipment date
new_tolerance_plus = #:(0..10)                  ; New plus tolerance
new_tolerance_minus = #:(0..10)                 ; New minus tolerance
other_changes[] = :                             ; Other changes (multiple items per amendment)

{@lc_amendment}

; Status
accepted = ?                                    ; Beneficiary accepted
acceptance_date = date                          ; Acceptance date
rejected = ?                                    ; Beneficiary rejected
rejection_date = date                           ; Rejection date
rejection_reason = :                            ; Rejection reason

; SWIFT references
mt707_reference = :                             ; Amendment message reference

; ===================================================================================
; LC DRAWING / PRESENTATION
; ===================================================================================
; Drawing/presentation under letter of credit.

{@lc_drawing}
; Required fields first
drawing_id = !:                                 ; Drawing identifier
lc_reference = !:                               ; LC reference
presentation_date = !date                       ; Presentation date
drawing_amount = !#$:(0..)                      ; Drawing amount

; Documents presented
documents_presented[] = @presented_document     ; Presented documents

; Status
status = (
    accepted,                                   ; Documents accepted
    discrepant,                                 ; Discrepancies noted
    paid,                                       ; Payment made
    pending,                                    ; Under examination
    refused                                     ; Documents refused
)

; Examination
examination_days = ##:(0..)                     ; Days for examination (max 5)
examination_complete = date                     ; Examination completed

; ---------------------------------------------------------------------------
; Discrepancies
; ---------------------------------------------------------------------------
{.discrepancies}
discrepancies = ?                               ; Discrepancies found
discrepancy_list[] = :                          ; List of discrepancies
waiver_requested = ?                            ; Waiver requested
waiver_approved = ?                             ; Waiver granted
waiver_date = date                              ; Waiver date

{@lc_drawing}

; ---------------------------------------------------------------------------
; Payment
; ---------------------------------------------------------------------------
{.payment}
payment_due_date = date                         ; Payment due date
payment_date = date                             ; Actual payment date
payment_amount = #$:(0..)                       ; Payment amount
payment_currency = :(3)                         ; Payment currency
fx_rate = #.6                                   ; FX rate if converted
deductions = #$:(0..)                           ; Charges deducted
net_payment = #$:(0..)                          ; Net amount paid

{@lc_drawing}

{@presented_document}
document_type = !:                              ; Document type
document_number = :                             ; Document number
document_date = date                            ; Document date
issuer = :                                      ; Issuer
copies_presented = ##:(1..)                     ; Copies presented
originals_presented = ##:(0..)                  ; Originals presented
compliant = ?                                   ; Document compliant

; ===================================================================================
; DOCUMENTARY COLLECTION
; ===================================================================================
; Documentary collections per URC 522.

{@collection}
; Required fields first
collection_reference = !:                       ; Collection reference
collection_type = !(
    cap,                                        ; Cash Against Presentation
    clean,                                      ; Clean collection (no documents)
    da,                                         ; Documents Against Acceptance
    dp                                          ; Documents Against Payment
)
amount = !#$:(0..)                              ; Collection amount
currency = !:(3)                                ; Currency

; Parties
drawer = !@trade_party                          ; Drawer (exporter/seller)
drawee = !@trade_party                          ; Drawee (importer/buyer)
remitting_bank = !@trade_party                  ; Remitting bank
collecting_bank = !@trade_party                 ; Collecting bank
presenting_bank = @trade_party                  ; Presenting bank

; Governing rules
governing_rules = "URC 522"                     ; Uniform Rules for Collections

; Status
status = (
    accepted,                                   ; Draft accepted
    cancelled,                                  ; Collection cancelled
    collected,                                  ; Payment collected
    dishonored,                                 ; Dishonored
    pending_acceptance,                         ; Awaiting acceptance
    pending_payment,                            ; Awaiting payment
    presented,                                  ; Documents presented
    protested,                                  ; Protested for non-payment/acceptance
    sent                                        ; Sent to collecting bank
)

; ---------------------------------------------------------------------------
; Dates
; ---------------------------------------------------------------------------
{.dates}
collection_date = date                          ; Collection instruction date
due_date = date                                 ; Payment/acceptance due date
presentation_date = date                        ; Date presented to drawee
payment_date = date                             ; Payment date
acceptance_date = date                          ; Acceptance date

{@collection}

; ---------------------------------------------------------------------------
; Payment Terms
; ---------------------------------------------------------------------------
{.payment_terms}
at_sight = ?:if collection_type = dp            ; Sight payment
usance_days = ##:if collection_type = da        ; Days for acceptance
usance_from = (
    acceptance_date,
    bill_of_lading_date,
    invoice_date,
    presentation_date
):if collection_type = da

{@collection}

; ---------------------------------------------------------------------------
; Draft (Bill of Exchange)
; ---------------------------------------------------------------------------
{.draft}
draft_amount = #$:(0..)                         ; Draft amount
draft_date = date                               ; Draft date
draft_number = :                                ; Draft number
drawn_on = :                                    ; Drawee name/bank
tenor = :                                       ; Tenor description
maturity_date = date:if collection_type = da    ; Maturity date

{@collection}

; ---------------------------------------------------------------------------
; Documents
; ---------------------------------------------------------------------------
documents[] = @collection_document              ; Documents for collection

{@collection_document}
document_type = !:                              ; Document type
originals = ##:(0..)                            ; Number of originals
copies = ##:(0..)                               ; Number of copies
description = :                                 ; Document description

{@collection}

; ---------------------------------------------------------------------------
; Instructions
; ---------------------------------------------------------------------------
{.instructions}
release_documents = (
    against_acceptance,                         ; D/A
    against_payment                             ; D/P
)
partial_payment = (allowed, not_allowed)        ; Partial payment
protest_instructions = (
    for_non_acceptance,
    for_non_payment,
    no_protest
)
storage_insurance = (for_account_of_drawee, for_account_of_drawer)
advice_of_fate = ?                              ; Request advice of fate
advice_of_non_payment = ?                       ; Advise non-payment

{@collection}

; ---------------------------------------------------------------------------
; Charges
; ---------------------------------------------------------------------------
{.charges}
collection_charges = (drawee, drawer)           ; Collection charges bearer
commission = #$:(0..)                           ; Commission amount
cable_charges = #$:(0..)                        ; Cable/telex charges
other_charges = #$:(0..)                        ; Other charges
waived_if_unpaid = ?                            ; Waive charges if not paid

{@collection}

; ===================================================================================
; BANK GUARANTEE
; ===================================================================================
; Demand guarantees per URDG 758.

{@guarantee}
; Required fields first
guarantee_number = !:                           ; Guarantee reference
guarantee_type = !(
    advance_payment,                            ; Advance payment guarantee
    bid_bond,                                   ; Bid/tender bond
    counter_guarantee,                          ; Counter-guarantee
    customs_bond,                               ; Customs/duty guarantee
    maintenance,                                ; Maintenance/warranty guarantee
    payment,                                    ; Payment guarantee
    performance,                                ; Performance guarantee
    retention,                                  ; Retention money guarantee
    shipping,                                   ; Shipping guarantee
    standby_lc,                                 ; Standby LC (ISP98)
    warranty                                    ; Warranty guarantee
)
amount = !#$:(0..)                              ; Guarantee amount
currency = !:(3)                                ; Currency

; Parties
principal = !@trade_party                       ; Principal (applicant)
beneficiaries[] = !@trade_party                 ; Beneficiaries (multiple named parties)
guarantor = !@trade_party                       ; Guarantor bank
instructing_party = @trade_party                ; Instructing party (for counter-guarantee)
advising_bank = @trade_party                    ; Advising bank

; Governing rules
governing_rules = !(
    isp98,                                      ; Standby LCs
    local_law,                                  ; Local law only
    urdg_758,                                   ; URDG 758
    ucp_600                                     ; Documentary LC rules
)
applicable_law = :                              ; Governing law
jurisdiction = :                                ; Jurisdiction for disputes

; Status
status = (
    advised,                                    ; Advised to beneficiary
    amended,                                    ; Amended
    cancelled,                                  ; Cancelled/released
    claimed,                                    ; Claim received
    expired,                                    ; Expired
    extended,                                   ; Extended
    issued,                                     ; Issued
    paid,                                       ; Claim paid
    pending,                                    ; Pending issuance
    reduced,                                    ; Amount reduced
    released                                    ; Released by beneficiary
)

; ---------------------------------------------------------------------------
; Dates
; ---------------------------------------------------------------------------
{.dates}
issue_date = date                               ; Date of issue
effective_date = date                           ; Effective date
expiry_date = !date                             ; Expiry date
expiry_event = :                                ; Expiry event description
claim_deadline = date                           ; Deadline for claims
extend_or_pay = date                            ; Extend or pay deadline

{@guarantee}

; ---------------------------------------------------------------------------
; Underlying Transaction
; ---------------------------------------------------------------------------
{.underlying}
contract_references[] = :                       ; Underlying contract refs (multiple contracts)
contract_date = date                            ; Contract date
project_name = :                                ; Project name
project_description = :                         ; Project description
contract_value = #$:(0..)                       ; Contract value

{@guarantee}

; ---------------------------------------------------------------------------
; Reduction
; ---------------------------------------------------------------------------
{.reduction}
reducible = ?                                   ; Amount reducible
reduction_schedule[] = @reduction_event         ; Reduction schedule
auto_reduction = ?                              ; Automatic reduction
reduction_trigger = :                           ; Trigger for reduction

{@guarantee}

{@reduction_event}
reduction_date = !date                          ; Reduction date
reduction_amount = !#$:(0..)                    ; Reduction amount
reduction_percentage = #:(0..100)               ; Reduction %
condition = :                                   ; Reduction condition
document_required = :                           ; Required document

; ---------------------------------------------------------------------------
; Claim Requirements
; ---------------------------------------------------------------------------
{@guarantee}

{.claim}
claim_must_state = :                            ; Required statement
supporting_documents[] = :                      ; Required documents
partial_claims = (allowed, not_allowed)         ; Multiple claims
multiple_claims = (allowed, not_allowed)        ; Multiple drawings

{@guarantee}

; ---------------------------------------------------------------------------
; Counter-Guarantee
; ---------------------------------------------------------------------------
{.counter_guarantee}
counter_guarantee = ?                           ; Counter-guarantee exists
counter_guarantee_ref = :                       ; Counter-guarantee reference
counter_guarantor = @trade_party                ; Counter-guarantor

{@guarantee}

; ---------------------------------------------------------------------------
; SWIFT References
; ---------------------------------------------------------------------------
{.swift}
mt760_reference = :                             ; MT760 Guarantee message
mt767_reference = :                             ; MT767 Amendment
mt769_reference = :                             ; MT769 Reduction
mt768_reference = :                             ; MT768 Acknowledgment

{@guarantee}

; ===================================================================================
; GUARANTEE CLAIM
; ===================================================================================
; Claim under bank guarantee.

{@guarantee_claim}
; Required fields first
claim_id = !:                                   ; Claim identifier
guarantee_reference = !:                        ; Guarantee reference
claim_date = !date                              ; Claim date
claim_amount = !#$:(0..)                        ; Claim amount

; Claimant
claimant = !@trade_party                        ; Claimant (beneficiary)

; Claim details
claim_statement = :                             ; Claim statement
claim_bases[] = :                               ; Bases for claim (multiple grounds)
breach_description = :                          ; Description of breach

; Supporting documents
documents_submitted[] = :                       ; Documents submitted

; Status
status = (
    accepted,                                   ; Claim accepted
    paid,                                       ; Claim paid
    pending,                                    ; Under review
    rejected,                                   ; Claim rejected
    withdrawn                                   ; Claim withdrawn
)

; Examination
{.examination}
examination_date = date                         ; Examination date
compliant = ?                                   ; Claim complies with terms
deficiencies[] = :                              ; Non-compliance issues

{@guarantee_claim}

; Payment
{.payment}
payment_date = date                             ; Payment date
payment_amount = #$:(0..)                       ; Amount paid
payment_method = (swift, check, other)          ; Payment method
payment_reference = :                           ; Payment reference

{@guarantee_claim}

; Rejection
{.rejection}
rejected = ?                                    ; Claim rejected
rejection_date = date                           ; Rejection date
rejection_reason = :                            ; Reason for rejection
extend_or_pay_invoked = ?                       ; Extend or pay

{@guarantee_claim}

; ===================================================================================
; SUPPLY CHAIN FINANCE
; ===================================================================================
; Supply chain finance per ICC Standard Definitions.

{@supply_chain_finance}
; Required fields first
scf_id = !:                                     ; SCF transaction ID
scf_type = !(
    approved_payables_finance,                  ; Reverse factoring
    dynamic_discounting,                        ; Buyer discount program
    distributor_finance,                        ; Distributor financing
    invoice_discounting,                        ; Invoice discounting
    loan_against_receivables,                   ; AR-secured loan
    payables_finance,                           ; Payables finance
    pre_shipment_finance,                       ; Pre-export finance
    receivables_discounting,                    ; Receivables discount
    receivables_purchase                        ; Factoring
)

; Parties
anchor = !@trade_party                          ; Anchor company (buyer or seller)
counterparty = !@trade_party                    ; Supplier or buyer
finance_providers[] = !@trade_party             ; Finance providers (syndicated SCF)
platform_provider = @trade_party                ; SCF platform if applicable

; Program details
program_id = :                                  ; SCF program ID
program_name = :                                ; Program name
program_currency = :(3)                         ; Program currency
program_limit = #$:(0..)                        ; Total program limit
program_utilized = #$:(0..)                     ; Current utilization
program_available = #$:(0..)                    ; Available capacity

; Status
status = (
    active,                                     ; Active program
    approved,                                   ; Approved
    closed,                                     ; Closed
    on_hold,                                    ; On hold
    pending                                     ; Pending approval
)

; ---------------------------------------------------------------------------
; Financing Terms
; ---------------------------------------------------------------------------
{.terms}
finance_rate = #.4                              ; Financing rate
rate_type = (fixed, floating)                   ; Rate type
base_rate = (euribor, prime, sofr)              ; Reference rate
spread = #.4                                    ; Spread (bps)
discount_rate = #.4                             ; Discount rate for discounting
advance_rate = #:(0..100)                       ; Advance rate %
minimum_invoice = #$:(0..)                      ; Minimum invoice amount
maximum_invoice = #$:(0..)                      ; Maximum invoice amount
minimum_tenor = ##                              ; Minimum days
maximum_tenor = ##                              ; Maximum days

{@supply_chain_finance}

; ---------------------------------------------------------------------------
; Anchor Terms (Buyer-led program)
; ---------------------------------------------------------------------------
{.anchor_terms}
payment_terms_days = ##                         ; Standard payment terms
extended_terms_days = ##                        ; Extended payment terms
auto_approval = ?                               ; Auto-approve invoices
approval_threshold = #$:(0..)                   ; Auto-approval limit

{@supply_chain_finance}

; ===================================================================================
; SCF INVOICE
; ===================================================================================
; Invoice submitted for supply chain finance.

{@scf_invoice}
; Required fields first
invoice_id = !:                                 ; Invoice identifier
program_id = !:                                 ; SCF program reference
invoice_number = !:                             ; Original invoice number
invoice_date = !date                            ; Invoice date
invoice_amount = !#$:(0..)                      ; Invoice amount
currency = !:(3)                                ; Invoice currency

; Parties
seller = !@trade_party                          ; Seller/supplier
buyer = !@trade_party                           ; Buyer

; Due date
original_due_date = !date                       ; Original payment due date
extended_due_date = date                        ; Extended due date (if any)
payment_terms = :                               ; Payment terms description

; Status
status = (
    approved,                                   ; Approved for financing
    financed,                                   ; Financing disbursed
    paid,                                       ; Paid by buyer
    pending,                                    ; Pending approval
    rejected,                                   ; Rejected
    submitted                                   ; Submitted for approval
)

; ---------------------------------------------------------------------------
; Financing Details
; ---------------------------------------------------------------------------
{.financing}
financed = ?                                    ; Invoice financed
finance_date = date                             ; Date financed
advance_amount = #$:(0..)                       ; Amount advanced
advance_rate = #:(0..100)                       ; Advance rate %
discount_amount = #$:(0..)                      ; Discount/fee amount
net_proceeds = #$:(0..)                         ; Net to supplier
finance_rate = #.4                              ; Applied rate
finance_days = ##                               ; Days financed

{@scf_invoice}

; ---------------------------------------------------------------------------
; Settlement
; ---------------------------------------------------------------------------
{.settlement}
buyer_payment_date = date                       ; Date buyer paid
buyer_payment_amount = #$:(0..)                 ; Amount from buyer
settled = ?                                     ; Fully settled
settlement_date = date                          ; Settlement date

{@scf_invoice}

; ===================================================================================
; FORFAITING
; ===================================================================================
; Forfaiting (without recourse purchase of trade receivables).

{@forfaiting}
; Required fields first
forfait_id = !:                                 ; Forfaiting transaction ID
forfait_type = !(
    avalized_draft,                             ; Avalized bill of exchange
    book_debt,                                  ; Book debt
    deferred_payment_lc,                        ; Deferred payment LC
    promissory_note                             ; Promissory note
)

; Parties
exporter = !@trade_party                        ; Exporter (seller of receivable)
importer = !@trade_party                        ; Importer/obligor
forfaiter = !@trade_party                       ; Forfaiting bank
guarantors[] = @trade_party                     ; Guarantors (multiple avalizing banks)

; Transaction details
face_value = !#$:(0..)                          ; Face value of receivable
currency = !:(3)                                ; Currency
purchase_date = !date                           ; Date of purchase
maturity_date = !date                           ; Maturity date

; Status
status = (
    active,                                     ; Active transaction
    closed,                                     ; Transaction closed
    defaulted,                                  ; Obligor defaulted
    matured,                                    ; Receivable matured
    paid,                                       ; Payment received
    pending                                     ; Pending purchase
)

; ---------------------------------------------------------------------------
; Pricing
; ---------------------------------------------------------------------------
{.pricing}
discount_rate = #.4                             ; Discount rate (all-in)
commitment_fee = #.4                            ; Commitment fee
documentation_fee = #$:(0..)                    ; Documentation fee
discount_amount = #$:(0..)                      ; Total discount
net_proceeds = #$:(0..)                         ; Net to exporter
yield = #.4                                     ; Yield to forfaiter

{@forfaiting}

; ---------------------------------------------------------------------------
; Underlying Obligation
; ---------------------------------------------------------------------------
{.obligation}
obligation_type = (
    accepted_draft,
    avalized_draft,
    deferred_lc,
    promissory_note
)
obligation_number = :                           ; Instrument number
obligation_date = date                          ; Date of instrument
drawee = :                                      ; Drawee (for drafts)
avalizing_bank = @trade_party                   ; Avalizing bank
aval_date = date                                ; Aval date
without_recourse = ?true                        ; Without recourse (always true)

{@forfaiting}

; ---------------------------------------------------------------------------
; Risk Details
; ---------------------------------------------------------------------------
{.risk}
country_risk = :(2)                             ; Obligor country
obligor_rating = :                              ; Obligor credit rating
bank_risk = :(2)                                ; Guarantor bank country
bank_rating = :                                 ; Guarantor rating
political_risk_insurance = ?                    ; PRI obtained
credit_insurance = ?                            ; Credit insurance

{@forfaiting}

; ---------------------------------------------------------------------------
; Secondary Market
; ---------------------------------------------------------------------------
{.secondary}
tradeable = ?                                   ; Can be traded
par_value = #$:(0..)                            ; Current par value
market_price = #:(0..200)                       ; Market price (% of par)
last_trade_date = date                          ; Last trade date

{@forfaiting}


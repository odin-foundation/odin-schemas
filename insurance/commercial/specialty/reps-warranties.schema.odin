; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Representations and Warranties Insurance (RWI) Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Representations and Warranties Insurance (RWI) for M&A transactions covering
; breaches of reps and warranties in purchase agreements. Includes buy-side and
; sell-side policies with fundamental, intermediate, and general rep categories.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../business.schema.odin" as entity
@import "../../common/types.schema.odin" as com

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.specialty.reps-warranties"
version = "1.0.0"
title = "Representations and Warranties Insurance Schema"
description = "Transactional risk insurance for M&A representation breaches"

{$derivation}
source[0].authority = "American Bar Association"
source[0].citation = "M&A Committee, Private Target M&A Deal Points Studies"
source[0].url = "https://www.americanbar.org/groups/business_law/committees/mergers-acquisitions/"

source[1].authority = "U.S. Securities and Exchange Commission"
source[1].citation = "M&A Disclosure Requirements, Regulation S-K"
source[1].url = "https://www.ecfr.gov/current/title-17/chapter-II/part-229"

source[2].authority = "Harvard Law School Forum on Corporate Governance"
source[2].citation = "Representations and Warranties Insurance in M&A Transactions"
source[2].url = "https://corpgov.law.harvard.edu/2017/12/11/representations-and-warranties-insurance-in-ma-transactions/"

source[3].authority = "Internal Revenue Service"
source[3].citation = "Section 338 Elections and M&A Tax Treatment"
source[3].url = "https://www.irs.gov/pub/irs-regs/td9257.pdf"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema derived from public M&A practice standards and regulatory requirements"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial RWI schema"
changelog[0].rationale = "Comprehensive transactional risk insurance for M&A deals"

; ═══════════════════════════════════════════════════════════════════════════════
; Transaction Details
; ═══════════════════════════════════════════════════════════════════════════════
; The underlying M&A transaction that the RWI policy covers

{@rwi_transaction}
id = :                                         ; Unique identifier for the transaction

; ───────────────────────────────────────────────────────────────────────────────
; Transaction Type
; ───────────────────────────────────────────────────────────────────────────────
transaction_type = (
    asset_purchase,
    carve_out,
    management_buyout,
    merger,
    recapitalization,
    secondary_transaction,
    spin_off,
    stock_purchase
)

transaction_name = :                           ; Name or title of the M&A transaction
transaction_description = :                    ; Detailed description of the transaction

; ───────────────────────────────────────────────────────────────────────────────
; Transaction Dates
; ───────────────────────────────────────────────────────────────────────────────
letter_of_intent_date = date                   ; Date the letter of intent was signed
signing_date = date                            ; Date the purchase agreement was executed
closing_date = date                            ; Actual date the transaction closed
expected_closing_date = date:if closing_date = ~ ; Anticipated closing date if not yet closed

; ───────────────────────────────────────────────────────────────────────────────
; Transaction Value
; ───────────────────────────────────────────────────────────────────────────────
enterprise_value = #$:(0..)                    ; Total enterprise value of the target company
equity_value = #$:(0..)                        ; Equity value of the target company
purchase_price = #$:(0..)                      ; Total consideration paid to sellers
purchase_price_adjustments = ?                 ; Whether purchase price is subject to adjustments

{.working_capital}
target_amount = #$:(0..)                       ; Target working capital amount agreed in purchase agreement
adjustment_mechanism = (collar, dollar_for_dollar, true_up) ; Method for calculating working capital adjustments
collar_amount = #$:(0..):if working_capital.adjustment_mechanism = collar ; Threshold amount for collar mechanism
dispute_resolution = (accountant_determination, arbitration, expert) ; Process for resolving working capital disputes

{@rwi_transaction}

; ───────────────────────────────────────────────────────────────────────────────
; Transaction Structure
; ───────────────────────────────────────────────────────────────────────────────
deal_structure = (
    all_cash,
    all_stock,
    cash_and_stock,
    earnout,
    leveraged_buyout,
    seller_financing
)

; Tax Structure
tax_structure = (
    section_338_h_10,
    section_336_e,
    section_754,
    taxable_asset,
    taxable_stock,
    tax_free_reorganization
)

; Governance
governing_law_state = :(2)                     ; Two-letter state code for governing law
governing_law_country = :(2..3) "US"           ; ISO country code for governing law jurisdiction

; ───────────────────────────────────────────────────────────────────────────────
; Escrow and Holdback
; ───────────────────────────────────────────────────────────────────────────────
{.escrow}
amount = #$:(0..)                              ; Total dollar amount held in escrow
percentage_of_purchase_price = #:(0..100)     ; Escrow amount as percentage of purchase price
release_schedule = (cliff, pro_rata, milestone) ; How and when escrow funds are released
release_period_months = ##:(0..72)             ; Total period over which escrow is released
escrow_agent = :                               ; Name of the escrow agent

{@rwi_transaction}

{.holdback}
amount = #$:(0..)                              ; Total dollar amount held back from purchase price
percentage_of_purchase_price = #:(0..100)     ; Holdback amount as percentage of purchase price
purpose = (general_indemnification, purchase_price_adjustment, specific_indemnity, working_capital) ; Purpose of the holdback
release_date = date                            ; Date when holdback funds will be released

{@rwi_transaction}

; ───────────────────────────────────────────────────────────────────────────────
; Earnout Structure
; ───────────────────────────────────────────────────────────────────────────────
{.earnout}
included = ?                                   ; Whether the transaction includes an earnout
maximum_amount = #$:(0..):if earnout.included = true ; Maximum earnout payment possible
measurement_period_months = ##:(0..60):if earnout.included = true ; Period over which earnout metrics are measured
metrics[] = (ebitda, revenue, gross_profit, net_income, milestones, other):if earnout.included = true ; Performance metrics used to calculate earnout
acceleration_events[] = ::if earnout.included = true ; Events that trigger immediate earnout payment

{@rwi_transaction}

; ───────────────────────────────────────────────────────────────────────────────
; Competitive Process
; ───────────────────────────────────────────────────────────────────────────────
auction_process = ?                            ; Whether the sale was conducted as an auction
bidder_count = ##                              ; Number of bidders in the process
exclusivity_period_days = ##                   ; Length of exclusivity period granted to buyer

; ───────────────────────────────────────────────────────────────────────────────
; Deal Advisors
; ───────────────────────────────────────────────────────────────────────────────
{.buyer_advisors}
legal_counsel = :                              ; Law firm representing the buyer
financial_advisor = :                          ; Investment bank or M&A advisor for buyer
accounting_firm = :                            ; Accounting firm providing due diligence
insurance_broker = :                           ; Broker arranging RWI coverage

{@rwi_transaction}

{.seller_advisors}
legal_counsel = :                              ; Law firm representing the seller
financial_advisor = :                          ; Investment bank or M&A advisor for seller
accounting_firm = :                            ; Accounting firm for the seller

{@rwi_transaction}

; ═══════════════════════════════════════════════════════════════════════════════
; Target Company
; ═══════════════════════════════════════════════════════════════════════════════
; The company or assets being acquired

{@rwi_target}
id = :                                         ; Unique identifier for the target company

; ───────────────────────────────────────────────────────────────────────────────
; Entity Information
; ───────────────────────────────────────────────────────────────────────────────
entity = @entity.business                      ; Business entity information for the target

; ───────────────────────────────────────────────────────────────────────────────
; Industry and Operations
; ───────────────────────────────────────────────────────────────────────────────
industry_sector = (
    aerospace_defense,
    agriculture,
    automotive,
    business_services,
    chemicals,
    construction,
    consumer_products,
    education,
    energy_oil_gas,
    financial_services,
    food_beverage,
    government_services,
    healthcare,
    hospitality,
    industrial_manufacturing,
    life_sciences,
    logistics_transportation,
    media_entertainment,
    mining,
    other,
    pharmaceuticals,
    professional_services,
    real_estate,
    retail,
    technology,
    telecommunications,
    utilities
)

; ───────────────────────────────────────────────────────────────────────────────
; Financial Profile
; ───────────────────────────────────────────────────────────────────────────────
{.financials}
annual_revenue = #$:(0..)                      ; Most recent annual revenue
ebitda = #$:(0..)                              ; Earnings before interest, taxes, depreciation, amortization
ebitda_margin = #:(0..100)                     ; EBITDA as percentage of revenue
total_assets = #$:(0..)                        ; Total assets on balance sheet
total_liabilities = #$:(0..)                   ; Total liabilities on balance sheet
net_working_capital = #$:(0..)                 ; Current assets minus current liabilities
fiscal_year_end_month = ##:(1..12)             ; Month when fiscal year ends (1-12)
audited_financials = ?                         ; Whether financials have been audited
auditor_name = :                               ; Name of auditing firm if applicable

{@rwi_target}

; ───────────────────────────────────────────────────────────────────────────────
; Operational Profile
; ───────────────────────────────────────────────────────────────────────────────
{.operations}
employee_count = ##                            ; Total number of employees
locations_count = ##                           ; Number of operating locations
operating_countries[] = :                      ; Countries where target operates
union_employees = ?                            ; Whether target has unionized employees
collective_bargaining_agreements = ?           ; Whether target has collective bargaining agreements
employee_benefit_plans_count = ##              ; Number of employee benefit plans maintained

{@rwi_target}

; ───────────────────────────────────────────────────────────────────────────────
; Risk Profile
; ───────────────────────────────────────────────────────────────────────────────
{.risk_factors}
environmental_exposure = ?                     ; Whether target has environmental liabilities or risks
hazardous_materials = ?                        ; Whether target handles hazardous materials
product_liability_exposure = ?                 ; Whether target faces product liability risks
government_contracts = ?                       ; Whether target has government contracts
regulated_industry = ?                         ; Whether target operates in regulated industry
intellectual_property_significant = ?          ; Whether IP is significant to target's business
customer_concentration = ?                     ; Whether target has customer concentration risk
supplier_concentration = ?                     ; Whether target has supplier concentration risk
pending_litigation = ?                         ; Whether target has pending litigation
material_litigation_count = ##                 ; Number of material litigation matters

{@rwi_target}

; ═══════════════════════════════════════════════════════════════════════════════
; Buyer Entity
; ═══════════════════════════════════════════════════════════════════════════════

{@rwi_buyer}
id = :                                         ; Unique identifier for the buyer entity

; ───────────────────────────────────────────────────────────────────────────────
; Entity Information
; ───────────────────────────────────────────────────────────────────────────────
entity = @entity.business                      ; Business entity information for the buyer

; ───────────────────────────────────────────────────────────────────────────────
; Buyer Type
; ───────────────────────────────────────────────────────────────────────────────
buyer_type = (
    corporate_strategic,
    family_office,
    individual,
    infrastructure_fund,
    pension_fund,
    private_equity,
    sovereign_wealth_fund,
    spac,
    venture_capital
)

; For Private Equity / Financial Buyers
{.fund_details}
fund_name = ::if buyer_type = private_equity   ; Name of the private equity fund
fund_vintage_year = ##:if buyer_type = private_equity ; Year the fund was raised
fund_size = #$:(0..):if buyer_type = private_equity ; Total size of the fund
fund_number = ##:if buyer_type = private_equity ; Fund number in the series (e.g., Fund IV)
sponsor_name = ::if buyer_type = private_equity ; Name of the PE firm sponsor

{@rwi_buyer}

; ───────────────────────────────────────────────────────────────────────────────
; Acquisition Experience
; ───────────────────────────────────────────────────────────────────────────────
{.experience}
prior_acquisitions_count = ##                  ; Number of prior acquisitions completed by buyer
industry_experience = ?                        ; Whether buyer has experience in target's industry
prior_rwi_policies = ?                         ; Whether buyer has purchased RWI policies before
prior_rwi_claims = ?                           ; Whether buyer has made prior RWI claims

{@rwi_buyer}

; ═══════════════════════════════════════════════════════════════════════════════
; Seller(s)
; ═══════════════════════════════════════════════════════════════════════════════

{@rwi_seller}
id = :                                         ; Unique identifier for the seller

; ───────────────────────────────────────────────────────────────────────────────
; Seller Identity
; ───────────────────────────────────────────────────────────────────────────────
seller_type = (
    corporation,
    estate,
    family_members,
    founders,
    individual,
    management_team,
    other,
    partnership,
    private_equity,
    trust,
    venture_capital
)

; Entity (if applicable)
entity = @entity.business:if seller_type = corporation ; Business entity if seller is a corporation
entity = @entity.business:if seller_type = partnership ; Business entity if seller is a partnership

; Individual (if applicable)
{.individual}
{.name}
first = ::if seller_type = individual
last = ::if seller_type = individual

{@rwi_seller.individual}
ownership_percentage = #:(0..100):if seller_type = individual ; Ownership percentage for individual seller

{@rwi_seller}

; ───────────────────────────────────────────────────────────────────────────────
; Ownership Details
; ───────────────────────────────────────────────────────────────────────────────
ownership_percentage = #:(0..100)              ; Ownership percentage held by this seller
voting_percentage = #:(0..100)                 ; Voting percentage controlled by this seller
shares_owned = ##                              ; Number of shares owned by this seller
share_class = :                                ; Class of shares owned

; Role
management_seller = ?                          ; Whether seller is part of target management
continuing_post_closing = ?                    ; Whether seller will continue with target post-closing
employment_agreement = ?:if continuing_post_closing = true ; Whether continuing seller has employment agreement
non_compete_agreement = ?                      ; Whether seller has non-compete agreement

; ───────────────────────────────────────────────────────────────────────────────
; Indemnification Obligations
; ───────────────────────────────────────────────────────────────────────────────
{.indemnification}
joint_several_liability = ?                    ; Whether sellers have joint and several liability
several_only_liability = ?                     ; Whether sellers have several liability only
pro_rata_liability = ?                         ; Whether sellers have pro rata liability
indemnification_cap = #$:(0..)                 ; Maximum indemnification obligation for this seller
indemnification_cap_percentage = #:(0..100)    ; Cap as percentage of purchase price
fundamental_rep_cap = #$:(0..)                 ; Cap for fundamental representation breaches
general_rep_cap = #$:(0..)                     ; Cap for general representation breaches
survival_period_months = ##                    ; Period during which seller can be held liable

{@rwi_seller}

; ═══════════════════════════════════════════════════════════════════════════════
; Purchase Agreement Reference
; ═══════════════════════════════════════════════════════════════════════════════

{@rwi_purchase_agreement}
id = :                                         ; Unique identifier for the purchase agreement

; ───────────────────────────────────────────────────────────────────────────────
; Agreement Identification
; ───────────────────────────────────────────────────────────────────────────────
agreement_type = (
    asset_purchase_agreement,
    contribution_agreement,
    merger_agreement,
    purchase_and_sale_agreement,
    securities_purchase_agreement,
    stock_purchase_agreement
)

agreement_date = date                          ; Date the purchase agreement was executed
agreement_title = :                            ; Title of the purchase agreement
governing_law = :(2)                           ; State or jurisdiction governing the agreement

; ───────────────────────────────────────────────────────────────────────────────
; Indemnification Provisions
; ───────────────────────────────────────────────────────────────────────────────
{.indemnification}
; Baskets
deductible_basket = ?                          ; Whether agreement has deductible basket
deductible_amount = #$:(0..):if indemnification.deductible_basket = true ; Deductible basket threshold amount
tipping_basket = ?                             ; Whether agreement has tipping basket
tipping_amount = #$:(0..):if indemnification.tipping_basket = true ; Tipping basket threshold amount
mini_basket = ?                                ; Whether agreement has mini basket for individual claims
mini_basket_amount = #$:(0..):if indemnification.mini_basket = true ; Mini basket threshold per claim

; Caps
general_cap = #$:(0..)                         ; Maximum liability for general representations
general_cap_percentage = #:(0..100)            ; General cap as percentage of purchase price
fundamental_cap = #$:(0..)                     ; Maximum liability for fundamental representations
fundamental_cap_percentage = #:(0..100)        ; Fundamental cap as percentage of purchase price
fraud_cap = #$:(0..)                           ; Maximum liability for fraud claims
fraud_cap_uncapped = ?                         ; Whether fraud claims are uncapped

; Other Provisions
materiality_scrape = ?                         ; Whether materiality qualifiers are scraped for claims
knowledge_scrape = ?                           ; Whether knowledge qualifiers are scraped for claims
pro_sandbagging = ?                            ; Whether buyer can claim despite prior knowledge
anti_sandbagging = ?                           ; Whether buyer cannot claim if had prior knowledge

{@rwi_purchase_agreement}

; ───────────────────────────────────────────────────────────────────────────────
; Survival Periods
; ───────────────────────────────────────────────────────────────────────────────
{.survival}
general_rep_months = ##                        ; Survival period for general representations
fundamental_rep_months = ##                    ; Survival period for fundamental representations
tax_rep_months = ##                            ; Survival period for tax representations
environmental_rep_months = ##                  ; Survival period for environmental representations
employee_benefits_rep_months = ##              ; Survival period for employee benefits representations
fraud_survival = (statute_of_limitations, unlimited, specified) ; How fraud claims survive
fraud_survival_months = ##:if survival.fraud_survival = specified ; Specified fraud survival period if applicable

{@rwi_purchase_agreement}

; ───────────────────────────────────────────────────────────────────────────────
; Closing Conditions
; ───────────────────────────────────────────────────────────────────────────────
{.closing_conditions}
regulatory_approvals_required = ?              ; Whether regulatory approvals are needed to close
hart_scott_rodino = ?                          ; Whether HSR filing is required
cfius_review = ?                               ; Whether CFIUS review is required
foreign_regulatory_approvals[] = :             ; List of foreign regulatory approvals required
financing_condition = ?                        ; Whether closing is conditioned on financing
material_adverse_change_condition = ?          ; Whether closing has MAC condition

{@rwi_purchase_agreement}

; ═══════════════════════════════════════════════════════════════════════════════
; Representations Being Covered
; ═══════════════════════════════════════════════════════════════════════════════
; Individual representations and warranties from the purchase agreement

{@rwi_representation}
id = :                                         ; Unique identifier for the representation

; ───────────────────────────────────────────────────────────────────────────────
; Representation Details
; ───────────────────────────────────────────────────────────────────────────────
section_reference = :                          ; Section reference in the purchase agreement
title = :                                      ; Title of the representation
description = :                                ; Description of what is being represented

; ───────────────────────────────────────────────────────────────────────────────
; Classification
; ───────────────────────────────────────────────────────────────────────────────
category = (
    fundamental,
    intermediate,
    general
)

; Representation Type
rep_type = (
    absence_of_changes,
    accounts_receivable,
    anti_corruption,
    assets,
    authority,
    bank_accounts,
    books_records,
    brokers_fees,
    capitalization,
    compliance_with_law,
    condition_of_assets,
    contracts,
    customers_suppliers,
    data_privacy,
    employee_benefits,
    employment,
    environmental,
    financial_statements,
    government_contracts,
    guarantees,
    insurance,
    intellectual_property,
    inventory,
    legal_proceedings,
    no_undisclosed_liabilities,
    organization,
    other,
    permits_licenses,
    product_liability,
    product_warranty,
    real_property,
    related_party,
    sanctions,
    sufficiency_of_assets,
    tax,
    title_to_assets,
    title_to_shares
)

; ───────────────────────────────────────────────────────────────────────────────
; Qualifications
; ───────────────────────────────────────────────────────────────────────────────
{.qualifications}
materiality_qualified = ?                      ; Whether representation includes materiality qualifiers
knowledge_qualified = ?                        ; Whether representation is qualified by knowledge
knowledge_persons[] = ::if qualifications.knowledge_qualified = true ; Persons whose knowledge is relevant
dollar_threshold = #$:(0..)                    ; Dollar threshold if representation is qualified
bring_down_standard = (material_respect, all_respects, mac) ; Standard for bring-down at closing

{@rwi_representation}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Status
; ───────────────────────────────────────────────────────────────────────────────
coverage_status = (
    covered,
    excluded,
    sublimited,
    modified
)

exclusion_reason = ::if coverage_status = excluded ; Reason for exclusion from coverage
sublimit_amount = #$:(0..):if coverage_status = sublimited ; Sublimit amount if coverage is limited
modification_description = ::if coverage_status = modified ; Description of how coverage is modified

; ───────────────────────────────────────────────────────────────────────────────
; Survival and Cap (from Purchase Agreement)
; ───────────────────────────────────────────────────────────────────────────────
survival_months = ##                           ; Survival period for this representation
indemnification_cap = #$:(0..)                 ; Cap on indemnification for this representation
basket_applies = ?                             ; Whether basket applies to this representation

; ═══════════════════════════════════════════════════════════════════════════════
; RWI Coverage Structure
; ═══════════════════════════════════════════════════════════════════════════════

{@rwi_coverage}
id = :                                         ; Unique identifier for coverage structure

; ───────────────────────────────────────────────────────────────────────────────
; Policy Limits
; ───────────────────────────────────────────────────────────────────────────────
policy_limit = #$:(0..)                        ; Total policy limit in dollars
policy_limit_percentage_ev = #:(0..100)        ; Policy limit as percentage of enterprise value

; ───────────────────────────────────────────────────────────────────────────────
; Retention Structure
; ───────────────────────────────────────────────────────────────────────────────
{.retention}
initial_retention = #$:(0..)                   ; Initial retention amount in dollars
initial_retention_percentage_ev = #:(0..5)     ; Initial retention as percentage of enterprise value
retention_type = (buyer_only, seller_only, split) ; Who bears the retention

; Split Retention Details
{.split}
buyer_portion = #$:(0..):if retention.retention_type = split ; Buyer's portion of retention in dollars
seller_portion = #$:(0..):if retention.retention_type = split ; Seller's portion of retention in dollars
buyer_percentage = #:(0..100):if retention.retention_type = split ; Buyer's percentage of retention
seller_percentage = #:(0..100):if retention.retention_type = split ; Seller's percentage of retention

{@rwi_coverage.retention}

; Retention Drop-Down
drop_down = ?                                  ; Whether retention drops down over time
drop_down_date = date:if retention.drop_down = true ; Date when retention drops down
drop_down_months = ##:(0..36):if retention.drop_down = true ; Months after inception when retention drops
dropped_retention = #$:(0..):if retention.drop_down = true ; Reduced retention amount after drop-down
dropped_retention_percentage_ev = #:(0..5):if retention.drop_down = true ; Reduced retention as percentage of EV

{@rwi_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Periods
; ───────────────────────────────────────────────────────────────────────────────
{.periods}
general_rep_years = ##                         ; Coverage period for general representations
fundamental_rep_years = ##                     ; Coverage period for fundamental representations
tax_rep_years = ##                             ; Coverage period for tax representations
environmental_rep_years = ##                   ; Coverage period for environmental representations
employee_benefits_years = ##                   ; Coverage period for employee benefits representations

{@rwi_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Defense Costs
; ───────────────────────────────────────────────────────────────────────────────
defense_within_limits = ?                      ; Whether defense costs erode policy limits
defense_outside_limits = ?                     ; Whether defense costs are paid in addition to limits
duty_to_defend = ?                             ; Whether insurer has duty to defend claims
advancement_of_defense = ?                     ; Whether insurer advances defense costs

; ───────────────────────────────────────────────────────────────────────────────
; Subrogation
; ───────────────────────────────────────────────────────────────────────────────
{.subrogation}
waiver = ?                                     ; Whether insurer waives all subrogation rights
waiver_except_fraud = ?                        ; Whether subrogation is waived except for fraud
fraud_subrogation = ?                          ; Whether insurer can subrogate for fraud
subrogation_threshold = #$:(0..)               ; Dollar threshold before subrogation rights apply

{@rwi_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Assignment
; ───────────────────────────────────────────────────────────────────────────────
{.assignment}
assignable = ?                                 ; Whether policy can be assigned
affiliate_assignment = ?                       ; Whether policy can be assigned to affiliates
successor_assignment = ?                       ; Whether policy transfers to successors
lender_assignment = ?                          ; Whether policy can be assigned to lenders

{@rwi_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Exclusions
; ═══════════════════════════════════════════════════════════════════════════════

{@rwi_exclusion}
id = :                                         ; Unique identifier for the exclusion

; ───────────────────────────────────────────────────────────────────────────────
; Exclusion Type
; ───────────────────────────────────────────────────────────────────────────────
exclusion_category = (
    standard,
    deal_specific
)

exclusion_type = (
    ; Standard Exclusions
    known_matters,
    forward_looking,
    purchase_price_adjustment,
    covenants,
    seller_fraud,
    criminal_fines,
    punitive_damages,
    multiplied_damages,
    consequential_damages,
    transfer_taxes,
    inadequate_reserves,
    underfunded_pension,
    asbestos,
    pcb,
    pfas,
    mold,
    nuclear,
    war,
    terrorism,
    cyber,
    trade_sanctions,
    anti_corruption,
    net_operating_loss,
    ; Deal-Specific Exclusions
    specific_matter,
    other
)

; ───────────────────────────────────────────────────────────────────────────────
; Exclusion Details
; ───────────────────────────────────────────────────────────────────────────────
description = :                                ; Description of the exclusion
section_reference = :                          ; Section reference in policy for exclusion

; For specific matter exclusions
{.specific_matter}
matter_description = ::if exclusion_type = specific_matter ; Description of the specific matter excluded
identified_in_diligence = ?:if exclusion_type = specific_matter ; Whether matter was identified in due diligence
disclosed_in_schedule = ?:if exclusion_type = specific_matter ; Whether matter was disclosed in disclosure schedules
schedule_reference = ::if exclusion_type = specific_matter ; Reference to disclosure schedule
estimated_exposure = #$:(0..):if exclusion_type = specific_matter ; Estimated financial exposure for matter
risk_allocation = (buyer, seller, shared):if exclusion_type = specific_matter ; How risk is allocated for this matter

{@rwi_exclusion}

; ═══════════════════════════════════════════════════════════════════════════════
; RWI Policy
; ═══════════════════════════════════════════════════════════════════════════════

{@rwi_policy}
id = :                                         ; Unique identifier for the policy
number = :                                     ; Policy number

; ───────────────────────────────────────────────────────────────────────────────
; Policy Type
; ───────────────────────────────────────────────────────────────────────────────
type = (
    buy_side,
    sell_side
)

policy_form = (claims_made)                    ; Policy trigger form

; ───────────────────────────────────────────────────────────────────────────────
; Policy Term
; ───────────────────────────────────────────────────────────────────────────────
effective_date = date                          ; Policy effective date
effective_time = time                          ; Policy effective time
expiration_date = date                         ; Policy expiration date
expiration_time = time                         ; Policy expiration time
:invariant expiration_date > effective_date

; ───────────────────────────────────────────────────────────────────────────────
; Transaction Reference
; ───────────────────────────────────────────────────────────────────────────────
transaction = @rwi_transaction                 ; Reference to the underlying transaction

; ───────────────────────────────────────────────────────────────────────────────
; Parties
; ───────────────────────────────────────────────────────────────────────────────
target = @rwi_target                           ; Target company being acquired
buyer = @rwi_buyer                             ; Buyer entity
sellers[] = @rwi_seller                        ; Array of sellers
purchase_agreement = @rwi_purchase_agreement   ; Reference to purchase agreement

; ───────────────────────────────────────────────────────────────────────────────
; Named Insured
; ───────────────────────────────────────────────────────────────────────────────
named_insured = @entity.business               ; Primary named insured on the policy

{.additional_insureds[]}
entity = @entity.business                      ; Additional insured entity
relationship = (affiliate, lender, equity_commitment_provider, co_investor, other) ; Relationship to named insured

{@rwi_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Structure
; ───────────────────────────────────────────────────────────────────────────────
coverage = @rwi_coverage                       ; Coverage structure and terms

; ───────────────────────────────────────────────────────────────────────────────
; Covered Representations
; ───────────────────────────────────────────────────────────────────────────────
representations[] = @rwi_representation        ; Array of representations covered by policy

; ───────────────────────────────────────────────────────────────────────────────
; Exclusions
; ───────────────────────────────────────────────────────────────────────────────
exclusions[] = @rwi_exclusion                  ; Array of exclusions from coverage

; ───────────────────────────────────────────────────────────────────────────────
; Layer Position (for towers)
; ───────────────────────────────────────────────────────────────────────────────
{.layer}
position = (primary, excess)                   ; Layer position in tower
layer_number = ##:if layer.position = excess   ; Layer number if excess layer
attachment_point = #$:(0..):if layer.position = excess ; Dollar amount where this layer attaches
underlying_limit = #$:(0..):if layer.position = excess ; Limit of underlying coverage
underlying_carrier = ::if layer.position = excess ; Name of underlying carrier
quota_share = ?                                ; Whether this is a quota share layer
quota_share_percentage = #:(0..100):if layer.quota_share = true ; Percentage of quota share participation

{@rwi_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Underwriting Information
; ───────────────────────────────────────────────────────────────────────────────
{.underwriting}
submission_date = date                         ; Date submission was made to underwriters
quote_date = date                              ; Date quote was provided
bind_date = date                               ; Date policy was bound
underwriting_fee = #$:(0..)                    ; Underwriting fee charged
due_diligence_call = ?                         ; Whether underwriter held due diligence call
due_diligence_call_date = date:if underwriting.due_diligence_call = true ; Date of due diligence call
management_presentation = ?                    ; Whether management presentation was held
no_claims_declaration = ?                      ; Whether no claims declaration was obtained
no_claims_declaration_date = date:if underwriting.no_claims_declaration = true ; Date of no claims declaration

{@rwi_policy}

; Due Diligence Reports Reviewed
{.diligence_reports[]}
report_type = (
    accounting,
    benefits,
    commercial,
    environmental,
    financial,
    hr,
    insurance,
    ip,
    it,
    legal,
    market,
    operational,
    quality_of_earnings,
    regulatory,
    tax,
    other
)                                              ; Type of due diligence report
provider = :                                   ; Provider or author of the report
date = date                                    ; Date of the report
satisfactory = ?                               ; Whether report findings were satisfactory to underwriter

{@rwi_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
base_premium = #$:(0..)                        ; Base premium for coverage
rate_on_limit = #:(0..10)                      ; Premium rate as percentage of policy limit
underwriting_fee = #$:(0..)                    ; Fee for underwriting services
broker_fee = #$:(0..)                          ; Broker's commission or fee
taxes = #$:(0..)                               ; Premium taxes
total_premium = #$:(0..)                       ; Total premium including all fees and taxes

; Premium allocation
{.allocation}
general_reps_percentage = #:(0..100)           ; Percentage of premium for general reps coverage
fundamental_reps_percentage = #:(0..100)       ; Percentage of premium for fundamental reps coverage
tax_reps_percentage = #:(0..100)               ; Percentage of premium for tax reps coverage

{@rwi_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Premium Payor
; ───────────────────────────────────────────────────────────────────────────────
premium_payor = (buyer, seller, split)         ; Who pays the premium
buyer_share = #:(0..100):if premium_payor = split ; Buyer's share of premium if split
seller_share = #:(0..100):if premium_payor = split ; Seller's share of premium if split

; ───────────────────────────────────────────────────────────────────────────────
; Extended Reporting Period (Tail)
; ───────────────────────────────────────────────────────────────────────────────
{.erp}
available = ?                                  ; Whether extended reporting period is available
premium_percentage = #:(0..300):if erp.available = true ; Premium as percentage of annual premium
period_options[] = (1_year, 2_years, 3_years, unlimited):if erp.available = true ; Available ERP period options

{@rwi_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Notices
; ───────────────────────────────────────────────────────────────────────────────
{.notices}
claim_notice_days = ##                         ; Number of days to provide notice of claim
circumstances_notice_days = ##                 ; Number of days to provide notice of circumstances
occurrence_notice_days = ##                    ; Number of days to provide notice of occurrence

{@rwi_policy}

; ═══════════════════════════════════════════════════════════════════════════════
; RWI Claim
; ═══════════════════════════════════════════════════════════════════════════════

{@rwi_claim}
id = :                                         ; Unique identifier for the claim
number = :                                     ; Claim number

; ───────────────────────────────────────────────────────────────────────────────
; Claim Dates
; ───────────────────────────────────────────────────────────────────────────────
discovery_date = date                          ; Date breach was discovered
notice_date = date                             ; Date insurer was notified
formal_claim_date = date                       ; Date formal claim was submitted
:invariant notice_date >= discovery_date

; ───────────────────────────────────────────────────────────────────────────────
; Breached Representations
; ───────────────────────────────────────────────────────────────────────────────
{.breached_reps[]}
representation_ref = @rwi_representation       ; Reference to the breached representation
section_reference = :                          ; Section reference in purchase agreement
breach_description = :                         ; Description of how representation was breached
breach_category = (fundamental, intermediate, general) ; Category of the breached representation

{@rwi_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Claim Details
; ───────────────────────────────────────────────────────────────────────────────
claim_description = :                          ; Description of the claim
underlying_facts = :                           ; Underlying facts giving rise to the claim

; ───────────────────────────────────────────────────────────────────────────────
; Claim Type
; ───────────────────────────────────────────────────────────────────────────────
claim_type = (
    accounting_irregularity,
    compliance_violation,
    contract_breach,
    customer_loss,
    employee_issue,
    environmental_liability,
    financial_statement_error,
    intellectual_property,
    inventory_valuation,
    litigation_liability,
    other,
    product_liability,
    regulatory_action,
    revenue_recognition,
    tax_liability,
    undisclosed_liability
)

; ───────────────────────────────────────────────────────────────────────────────
; Claim Amounts
; ───────────────────────────────────────────────────────────────────────────────
{.amounts}
initial_estimate = #$:(0..)                    ; Initial estimate of loss
current_estimate = #$:(0..)                    ; Current estimate of loss
defense_costs_estimate = #$:(0..)              ; Estimated defense costs
retention_applied = #$:(0..)                   ; Amount of retention applied to claim
amount_claimed = #$:(0..)                      ; Total amount claimed from insurer
amount_paid = #$:(0..)                         ; Amount paid by insurer to date
amount_reserved = #$:(0..)                     ; Amount reserved by insurer for claim

{@rwi_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Claim Status
; ───────────────────────────────────────────────────────────────────────────────
status = (
    notice_only,
    open,
    under_investigation,
    coverage_confirmed,
    coverage_denied,
    in_negotiation,
    settled,
    closed_paid,
    closed_no_payment,
    withdrawn
)

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Determination
; ───────────────────────────────────────────────────────────────────────────────
{.coverage_determination}
coverage_position = (pending, full_coverage, partial_coverage, no_coverage) ; Insurer's coverage position
denial_reason = ::if coverage_determination.coverage_position = no_coverage ; Reason for coverage denial
partial_reason = ::if coverage_determination.coverage_position = partial_coverage ; Reason for partial coverage
exclusion_applied = :                          ; Exclusion applied if coverage denied or limited
reservation_of_rights = ?                      ; Whether insurer issued reservation of rights
reservation_of_rights_letter_date = date:if coverage_determination.reservation_of_rights = true ; Date of reservation letter

{@rwi_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Resolution
; ───────────────────────────────────────────────────────────────────────────────
{.resolution}
resolution_date = date                         ; Date claim was resolved
resolution_type = (settlement, judgment, withdrawal, coverage_denial) ; Type of resolution
settlement_amount = #$:(0..):if resolution.resolution_type = settlement ; Settlement amount if settled
defense_costs_paid = #$:(0..)                  ; Defense costs paid by insurer
indemnity_paid = #$:(0..)                      ; Indemnity amount paid by insurer
subrogation_recovery = #$:(0..)                ; Amount recovered through subrogation
net_paid = #$:(0..)                            ; Net amount paid after recoveries

{@rwi_claim}

; ═══════════════════════════════════════════════════════════════════════════════
; Tax Insurance (Related Product)
; ═══════════════════════════════════════════════════════════════════════════════
; Separate coverage, may be purchased alongside RWI

{@tax_insurance}
id = :                                         ; Unique identifier for tax insurance policy
policy_number = :                              ; Tax insurance policy number

; ───────────────────────────────────────────────────────────────────────────────
; Policy Term
; ───────────────────────────────────────────────────────────────────────────────
effective_date = date                          ; Policy effective date
expiration_date = date                         ; Policy expiration date
:invariant expiration_date > effective_date

; ───────────────────────────────────────────────────────────────────────────────
; Insured Tax Position
; ───────────────────────────────────────────────────────────────────────────────
{.tax_position}
description = :                                ; Description of the tax position being insured
position_type = (
    ; Transaction Structure
    section_338_h_10,
    section_336_e,
    section_754,
    tax_free_reorganization,
    spin_off,
    ; NOL and Credits
    nol_utilization,
    tax_credit_utilization,
    section_382_limitation,
    ; Transfer Pricing
    transfer_pricing,
    permanent_establishment,
    ; State and Local
    state_nexus,
    apportionment,
    ; International
    subpart_f,
    pfic,
    cffc,
    ; Other
    r_and_d_credits,
    cost_segregation,
    other
)                                              ; Type of tax position

; Tax Years
tax_years_covered[] = ##                       ; Tax years covered by the policy

{@tax_insurance}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Amounts
; ───────────────────────────────────────────────────────────────────────────────
{.coverage}
policy_limit = #$:(0..)                        ; Total policy limit for tax insurance
retention = #$:(0..)                           ; Retention amount for tax claims
tax_liability = #$:(0..)                       ; Maximum tax liability covered
interest_and_penalties = ?                     ; Whether interest and penalties are covered
gross_up = ?                                   ; Whether policy includes gross-up for taxes on recovery
defense_costs_within_limit = ?                 ; Whether defense costs erode policy limit
defense_costs_outside_limit = ?                ; Whether defense costs are paid outside limit

{@tax_insurance}

; ───────────────────────────────────────────────────────────────────────────────
; Opinion and Analysis
; ───────────────────────────────────────────────────────────────────────────────
{.opinion}
tax_opinion_obtained = ?                       ; Whether a tax opinion was obtained
opinion_provider = ::if opinion.tax_opinion_obtained = true ; Provider of the tax opinion
opinion_level = (should, more_likely_than_not, substantial_authority):if opinion.tax_opinion_obtained = true ; Confidence level of opinion
opinion_date = date:if opinion.tax_opinion_obtained = true ; Date of the tax opinion

{@tax_insurance}

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
base_premium = #$:(0..)                        ; Base premium for tax insurance
rate_on_limit = #:(0..15)                      ; Premium rate as percentage of policy limit
underwriting_fee = #$:(0..)                    ; Underwriting fee for tax insurance
taxes = #$:(0..)                               ; Premium taxes
total_premium = #$:(0..)                       ; Total premium including fees and taxes

{@tax_insurance}

; ═══════════════════════════════════════════════════════════════════════════════
; Endorsements
; ═══════════════════════════════════════════════════════════════════════════════

{@rwi_endorsement}
id = :                                         ; Unique identifier for the endorsement
number = :                                     ; Endorsement number
effective_date = date                          ; Date endorsement becomes effective

; ───────────────────────────────────────────────────────────────────────────────
; Endorsement Type
; ───────────────────────────────────────────────────────────────────────────────
type = (
    ; Coverage Modifications
    add_insured,
    additional_coverage,
    assignment,
    coverage_enhancement,
    coverage_reduction,
    ; Limit Changes
    increased_limit,
    limit_reinstatement,
    reduced_limit,
    ; Retention Changes
    reduced_retention,
    retention_buydown,
    ; Exclusion Changes
    exclusion_addition,
    exclusion_buyback,
    exclusion_modification,
    ; Period Changes
    coverage_period_extension,
    erp_purchase,
    ; Other
    correction,
    name_change,
    other
)

; ───────────────────────────────────────────────────────────────────────────────
; Endorsement Details
; ───────────────────────────────────────────────────────────────────────────────
title = :                                      ; Title of the endorsement
description = :                                ; Description of what the endorsement does
premium_impact = #$                            ; Impact on premium (positive or negative)

{@rwi_endorsement}


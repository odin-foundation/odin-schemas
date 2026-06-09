; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Captive Insurance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Captive insurance company schema for self-insured risk financing entities
; including single-parent, group, association, risk retention group (RRG),
; and cell captive structures with domicile and regulatory details.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.market-structures.captive"
version = "1.0.0"
title = "Captive Insurance Schema"
description = "Comprehensive captive insurance structures and programs"

{$derivation}
source[0].authority = "National Association of Insurance Commissioners (NAIC)"
source[0].citation = "Captive Insurance Company Model Act (CA-80)"
source[0].url = "https://content.naic.org/model-laws"

source[1].authority = "National Association of Insurance Commissioners (NAIC)"
source[1].citation = "Protected Cell Company Model Act"
source[1].url = "https://content.naic.org/sites/default/files/model-law-chart-ca-80-captive-insurance-company-laws.pdf"

source[2].authority = "U.S. Internal Revenue Service"
source[2].citation = "Internal Revenue Code Section 831(b) - Alternative Tax for Small Insurance Companies"
source[2].url = "https://www.irs.gov/pub/irs-pdf/p334.pdf"

source[3].authority = "U.S. Congress"
source[3].citation = "Liability Risk Retention Act of 1986 (15 U.S.C. 3901-3906)"
source[3].url = "https://www.govinfo.gov/content/pkg/USCODE-2023-title15/pdf/USCODE-2023-title15-chap65.pdf"

source[4].authority = "Vermont Department of Financial Regulation"
source[4].citation = "Vermont Captive Insurance Financial Regulation"
source[4].url = "https://dfr.vermont.gov/reg-bul-ord/captive-insurance-financial-regulation"

source[5].authority = "Delaware Department of Insurance"
source[5].citation = "Delaware Captive Insurance Annual Filing Requirements"
source[5].url = "https://captive.delaware.gov/annual-filing-requirements/"

source[6].authority = "Bermuda Monetary Authority"
source[6].citation = "Insurance Act 1978 and Related Regulations"
source[6].url = "https://www.bma.bm/insurance"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Derived from NAIC model laws, federal statutes, and state/offshore domicile regulations"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial captive insurance schema"
changelog[0].rationale = "Comprehensive coverage of captive structures for alternative risk transfer"

; ═══════════════════════════════════════════════════════════════════════════════
; Captive Type Enumeration
; ═══════════════════════════════════════════════════════════════════════════════
; Classification of captive insurance company structures based on ownership,
; membership, and regulatory framework.

{@captive_type}
type_code = :
classification = (
    agency,
    association,
    group,
    industrial_insured,
    micro_captive,
    protected_cell_company,
    rent_a_captive,
    risk_retention_group,
    segregated_portfolio_company,
    single_parent,
    special_purpose_vehicle,
    sponsored_captive
)

; ───────────────────────────────────────────────────────────────────────────────
; Classification Descriptions
; ───────────────────────────────────────────────────────────────────────────────
; single_parent: Pure captive owned by single parent company
; group: Multiple unrelated companies sharing ownership and risk
; association: Trade association members pooling risk
; agency: Owned by insurance agency to write affiliated business
; rent_a_captive: Cell rental without forming separate entity
; risk_retention_group: Federal preemption, liability only, member-owned
; protected_cell_company: Statutory cell separation, shared capital
; segregated_portfolio_company: Cayman/Bermuda term for PCC structure
; sponsored_captive: Third-party sponsorship of captive structure
; special_purpose_vehicle: Transaction-specific risk financing entity
; industrial_insured: Large commercial entities meeting premium thresholds
; micro_captive: 831(b) election, premium under threshold ($2.8M in 2024)

description = :

; ───────────────────────────────────────────────────────────────────────────────
; Regulatory Classification
; ───────────────────────────────────────────────────────────────────────────────
federal_preemption = ?                   ; RRGs have federal preemption
naic_model_act_applicable = ?
state_specific_regulation = ?

; ═══════════════════════════════════════════════════════════════════════════════
; Captive Entity
; ═══════════════════════════════════════════════════════════════════════════════
; The captive insurance company itself - the licensed insurance entity.

{@captive_entity}
id = :

; ───────────────────────────────────────────────────────────────────────────────
; Legal Identity
; ───────────────────────────────────────────────────────────────────────────────
legal_name = :
dba_names[] = :
former_names[] = :

; Business Structure
entity_structure = (
    corporation,
    llc,
    mutual,
    nonprofit,
    reciprocal,
    stock_company,
    trust
)

; ───────────────────────────────────────────────────────────────────────────────
; Captive Classification
; ───────────────────────────────────────────────────────────────────────────────
captive_type = @captive_type
micro_captive = ?                     ; 831(b) eligible
risk_retention_group = ?              ; Subject to LRRA
cell_captive = ?                      ; PCC/SPC structure

; ───────────────────────────────────────────────────────────────────────────────
; Tax Identifiers
; ───────────────────────────────────────────────────────────────────────────────
fein = */^\d{2}-\d{7}$/                 ; US Federal Employer ID
naic_company_code = :(5..6)              ; NAIC assigned code
naic_group_code = :(5..6)
am_best_number = :

; ───────────────────────────────────────────────────────────────────────────────
; Formation
; ───────────────────────────────────────────────────────────────────────────────
formation_date = date
license_date = date
license_number = *:
license_status = (active, suspended, revoked, voluntary_dissolution, liquidation)

; ───────────────────────────────────────────────────────────────────────────────
; Contact Information
; ───────────────────────────────────────────────────────────────────────────────
primary_contact = @person

{@captive_entity}

; ═══════════════════════════════════════════════════════════════════════════════
; Captive Domicile
; ═══════════════════════════════════════════════════════════════════════════════
; Jurisdiction where the captive is licensed and regulated.
; Domicile selection is critical for regulatory requirements, capital needs,
; tax treatment, and operational flexibility.

{@captive_domicile}
id = :

; ───────────────────────────────────────────────────────────────────────────────
; Jurisdiction
; ───────────────────────────────────────────────────────────────────────────────
jurisdiction_type = (offshore, other, us_state, us_territory)
jurisdiction_code = :                    ; State code or country code
jurisdiction_name = :

; Common US Domiciles
; VT (Vermont), DE (Delaware), NC (North Carolina), UT (Utah), HI (Hawaii),
; SC (South Carolina), TN (Tennessee), DC (District of Columbia), AZ (Arizona),
; NV (Nevada), TX (Texas), MT (Montana), NY (New York), CT (Connecticut)

; Common Offshore Domiciles
; BM (Bermuda), KY (Cayman Islands), BVI (British Virgin Islands),
; GY (Guernsey), LU (Luxembourg), IE (Ireland), BB (Barbados)

; ───────────────────────────────────────────────────────────────────────────────
; Regulatory Authority
; ───────────────────────────────────────────────────────────────────────────────
regulatory_authority = :          ; Vermont DFR, Delaware DOI, BMA, CIMA
regulator_contact = :
regulatory_website = :

; ───────────────────────────────────────────────────────────────────────────────
; Domicile Requirements
; ───────────────────────────────────────────────────────────────────────────────
{.capital_requirements}
minimum_capital = #$                     ; Varies by type and domicile
minimum_surplus = #$
combined_minimum = #$                    ; Capital + surplus minimum
letter_of_credit_allowed = ?
parental_guarantee_allowed = ?
trust_fund_allowed = ?

{@captive_domicile}

; ───────────────────────────────────────────────────────────────────────────────
; Operational Requirements
; ───────────────────────────────────────────────────────────────────────────────
board_meeting_in_domicile_required = ?            ; Annual meeting required in domicile
principal_office_in_domicile_required = ?          ; Principal office in domicile
resident_agent_required = ?
registered_office_address = @address              ; Registered office address

; ───────────────────────────────────────────────────────────────────────────────
; Examination Schedule
; ───────────────────────────────────────────────────────────────────────────────
examination_frequency_years = ##:(1..10) ; Standard: 3-5 years
last_examination_date = date
next_examination_date = date

; ───────────────────────────────────────────────────────────────────────────────
; Tax Treatment
; ───────────────────────────────────────────────────────────────────────────────
premium_tax_rate = #:(0..100)            ; Percentage
premium_tax_cap = #$                     ; Maximum annual premium tax
other_fees_annual = #$                   ; Annual government fees

; ═══════════════════════════════════════════════════════════════════════════════
; Captive Owner
; ═══════════════════════════════════════════════════════════════════════════════
; Parent company or member that owns interest in the captive.

{@captive_owner}
id = :

; ───────────────────────────────────────────────────────────────────────────────
; Owner Identity
; ───────────────────────────────────────────────────────────────────────────────
legal_name = :
owner_type = (
    corporation,
    llc,
    partnership,
    sole_proprietor,
    nonprofit,
    government_entity,
    individual,
    trust,
    association,
    other
)

; ───────────────────────────────────────────────────────────────────────────────
; Tax Identifiers
; ───────────────────────────────────────────────────────────────────────────────
fein = *:format ein
duns_number = :(9)

; ───────────────────────────────────────────────────────────────────────────────
; Ownership Details
; ───────────────────────────────────────────────────────────────────────────────
ownership_percentage = #:(0..100)
voting_percentage = #:(0..100)
ownership_class = :                ; Class A, Class B, etc.
ownership_start_date = date
ownership_end_date = date

; ───────────────────────────────────────────────────────────────────────────────
; Owner Classification
; ───────────────────────────────────────────────────────────────────────────────
insured_party = ?                     ; Owner also insured by captive
ultimate_parent = ?
affiliated_entity = ?

; ───────────────────────────────────────────────────────────────────────────────
; Industry Classification
; ───────────────────────────────────────────────────────────────────────────────
naics_primary = :(6)
naics_description = :
sic_primary = :(4)

; ═══════════════════════════════════════════════════════════════════════════════
; Captive Cell (for PCC/SPC structures)
; ═══════════════════════════════════════════════════════════════════════════════
; Individual cell within a Protected Cell Company or Segregated Portfolio Company.
; Each cell has legally segregated assets and liabilities.

{@captive_cell}
id = :
cell_name = :

; ───────────────────────────────────────────────────────────────────────────────
; Cell Structure
; ───────────────────────────────────────────────────────────────────────────────
cell_type = (
    protected_cell,
    segregated_portfolio,
    incorporated_cell,
    unincorporated_cell
)
cell_number = :
core_company_ref = :               ; Reference to parent PCC/SPC entity

; ───────────────────────────────────────────────────────────────────────────────
; Cell Ownership
; ───────────────────────────────────────────────────────────────────────────────
cell_participant_name = :
cell_participant_fein = */^\d{2}-\d{7}$/
cell_ownership_percentage = #:(0..100)

; ───────────────────────────────────────────────────────────────────────────────
; Cell Capitalization
; ───────────────────────────────────────────────────────────────────────────────
{.cell_capital}
initial_capital = #$
current_capital = #$
minimum_required = #$
letter_of_credit = #$
collateral_posted = #$

{@captive_cell}

; ───────────────────────────────────────────────────────────────────────────────
; Cell Dates
; ───────────────────────────────────────────────────────────────────────────────
cell_formation_date = date
cell_activation_date = date
cell_termination_date = date
cell_status = (active, dormant, terminated, liquidating)

; ───────────────────────────────────────────────────────────────────────────────
; Cell Segregation
; ───────────────────────────────────────────────────────────────────────────────
assets_legally_segregated = ?
liabilities_legally_segregated = ?
no_recourse_to_core = ?                  ; Core cannot be liable for cell
no_recourse_to_other_cells = ?           ; Other cells cannot be liable

; ═══════════════════════════════════════════════════════════════════════════════
; Captive Fronting Arrangement
; ═══════════════════════════════════════════════════════════════════════════════
; Fronting is where a licensed, admitted insurer issues policies and reinsures
; the risk to the captive. Required when captive cannot directly write coverage
; (workers comp, auto liability, statutory requirements).

{@captive_fronting}
id = :

; ───────────────────────────────────────────────────────────────────────────────
; Fronting Carrier
; ───────────────────────────────────────────────────────────────────────────────
fronting_carrier_ref = :                      ; Reference to carrier.schema.odin
fronting_carrier_admitted_states[] = :(2)     ; States where admitted

; ───────────────────────────────────────────────────────────────────────────────
; Fronting Agreement Terms
; ───────────────────────────────────────────────────────────────────────────────
fronting_agreement_effective = date
fronting_agreement_expiration = date
fronting_fee_percentage = #:(0..100)          ; Standard: 5-10% of premium
fronting_fee_minimum = #$
fronting_fee_maximum = #$

; ───────────────────────────────────────────────────────────────────────────────
; Collateral Requirements
; ───────────────────────────────────────────────────────────────────────────────
{.collateral}
collateral_required = ?
collateral_percentage = #:(0..100)            ; Percentage of premium/reserves
collateral_amount = #$
collateral_type = (cash, letter_of_credit, parental_guarantee, securities, trust_fund)
collateral_provider = :                ; Bank, parent company, etc.
collateral_release_schedule = :        ; When/how collateral is released

{@captive_fronting}

; ───────────────────────────────────────────────────────────────────────────────
; Reinsurance to Captive
; ───────────────────────────────────────────────────────────────────────────────
reinsurance_type = (quota_share, excess_of_loss, aggregate_stop_loss)
cession_percentage = #:(0..100)               ; % ceded to captive
retention_by_front = #$                       ; Amount retained by fronting carrier
risk_transfer_percentage = #:(0..100)

; ───────────────────────────────────────────────────────────────────────────────
; Lines of Business Fronted
; ───────────────────────────────────────────────────────────────────────────────
lines_of_business[] = :
; Common fronted lines: workers_compensation, commercial_auto, general_liability,
; professional_liability, property, employers_liability

; ═══════════════════════════════════════════════════════════════════════════════
; Captive Capitalization
; ═══════════════════════════════════════════════════════════════════════════════
; Capital structure and solvency requirements for the captive.

{@captive_capitalization}
id = :
as_of_date = date

; ───────────────────────────────────────────────────────────────────────────────
; Capital Components
; ───────────────────────────────────────────────────────────────────────────────
paid_in_capital = #$
paid_in_surplus = #$
contributed_surplus = #$
unassigned_surplus = #$
total_capital_surplus = #$

; ───────────────────────────────────────────────────────────────────────────────
; Regulatory Minimums
; ───────────────────────────────────────────────────────────────────────────────
minimum_capital_required = #$                 ; By domicile/type
minimum_surplus_required = #$
combined_minimum = #$
capital_surplus_ratio = #

; ───────────────────────────────────────────────────────────────────────────────
; Capital Support Instruments
; ───────────────────────────────────────────────────────────────────────────────
{.letter_of_credit}
loc_amount = #$
loc_issuing_bank = :
loc_expiration_date = date
loc_beneficiary = :
loc_renewable = ?

{@captive_capitalization}

{.parental_guarantee}
guarantee_amount = #$
guarantor_name = :
guarantee_date = date
guarantee_expiration = date

{@captive_capitalization}

{.trust_fund}
trust_amount = #$
trustee_name = :
trust_effective_date = date
trust_beneficiary = :

{@captive_capitalization}

; ───────────────────────────────────────────────────────────────────────────────
; Risk-Based Capital (if applicable)
; ───────────────────────────────────────────────────────────────────────────────
rbc_applicable = ?
rbc_ratio = #
rbc_action_level = (no_action, company_action, regulatory_action, authorized_control, mandatory_control)

; ═══════════════════════════════════════════════════════════════════════════════
; Captive Governance
; ═══════════════════════════════════════════════════════════════════════════════
; Board of directors, officers, and governance requirements.

{@captive_governance}
id = :

; ───────────────────────────────────────────────────────────────────────────────
; Board of Directors
; ───────────────────────────────────────────────────────────────────────────────
{.board}
total_directors = ##
independent_directors = ##
domicile_resident_directors = ##
minimum_directors_required = ##              ; By domicile regulation

{@captive_governance}

; ───────────────────────────────────────────────────────────────────────────────
; Board Meetings
; ───────────────────────────────────────────────────────────────────────────────
annual_meeting_required = ?
meeting_in_domicile_required = ?
minimum_meetings_per_year = ##:(1..12)
last_board_meeting_date = date
next_board_meeting_date = date

; ───────────────────────────────────────────────────────────────────────────────
; Corporate Officers
; ───────────────────────────────────────────────────────────────────────────────
dedicated_officers = ?                        ; vs. shared with parent

{.officers[]}
name = :
title = :
officer_role = (president, ceo, cfo, secretary, treasurer, other)
appointment_date = date
domicile_resident = ?
affiliated_with_parent = ?

{@captive_governance}

; ───────────────────────────────────────────────────────────────────────────────
; Governance Documents
; ───────────────────────────────────────────────────────────────────────────────
articles_of_incorporation_date = date
bylaws_last_amended = date
shareholders_agreement_date = date
plan_of_operation_date = date
plan_of_operation_last_amended = date

; ═══════════════════════════════════════════════════════════════════════════════
; Captive Manager
; ═══════════════════════════════════════════════════════════════════════════════
; Third-party captive management company that operates the captive.
; Most captives use external managers rather than in-house staff.

{@captive_manager}
id = :

; ───────────────────────────────────────────────────────────────────────────────
; Manager Identity
; ───────────────────────────────────────────────────────────────────────────────
company_name = :
dba_name = :
manager_type = (
    captive_management_company,
    insurance_company_subsidiary,
    broker_affiliate,
    consulting_firm,
    in_house
)

; ───────────────────────────────────────────────────────────────────────────────
; Licensing/Registration
; ───────────────────────────────────────────────────────────────────────────────
domicile_licensed = ?                         ; Licensed in captive's domicile
license_number = *:
license_state = :(2)
resident_manager_required = ?                 ; Some domiciles require resident

; ───────────────────────────────────────────────────────────────────────────────
; Management Agreement
; ───────────────────────────────────────────────────────────────────────────────
agreement_effective_date = date
agreement_expiration_date = date
agreement_term_years = ##:(1..10)
auto_renewal = ?
termination_notice_days = ##:(0..365)

; ───────────────────────────────────────────────────────────────────────────────
; Services Provided
; ───────────────────────────────────────────────────────────────────────────────
services_accounting = ?
services_regulatory_filings = ?
services_board_administration = ?
services_policy_issuance = ?
services_claims_management = ?
services_reinsurance_placement = ?
services_actuarial_coordination = ?
services_investment_management = ?

; ───────────────────────────────────────────────────────────────────────────────
; Fees
; ───────────────────────────────────────────────────────────────────────────────
{.fees}
annual_management_fee = #$
fee_basis = (flat_fee, percentage_of_premium, percentage_of_assets, hourly)
fee_percentage = #:(0..100)
additional_services_fee = #$

{@captive_manager}

; ───────────────────────────────────────────────────────────────────────────────
; Contact Information
; ───────────────────────────────────────────────────────────────────────────────
contact_ref = :                               ; Primary contact reference

{@captive_manager}

; ═══════════════════════════════════════════════════════════════════════════════
; Captive Program
; ═══════════════════════════════════════════════════════════════════════════════
; The insurance program written by the captive - coverages, limits, and terms.

{@captive_program}
id = :
program_name = :

; ───────────────────────────────────────────────────────────────────────────────
; Program Period
; ───────────────────────────────────────────────────────────────────────────────
effective_date = date
expiration_date = date
policy_term_months = ##:(1..36)

; ───────────────────────────────────────────────────────────────────────────────
; Lines of Business
; ───────────────────────────────────────────────────────────────────────────────
primary_line = (
    general_liability,
    professional_liability,
    directors_officers,
    errors_omissions,
    employment_practices,
    workers_compensation,
    employers_liability,
    commercial_auto,
    property,
    inland_marine,
    crime,
    cyber,
    product_liability,
    medical_malpractice,
    environmental,
    excess_umbrella,
    other
)
additional_lines[] = :

; ───────────────────────────────────────────────────────────────────────────────
; Writing Method
; ───────────────────────────────────────────────────────────────────────────────
writing_method = (direct, fronted, reinsurance_assumed)
fronting_arrangement_ref = :            ; Reference to @captive_fronting

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
gross_written_premium = #$
net_written_premium = #$
ceded_premium = #$
earned_premium = #$
unearned_premium = #$

{@captive_program}

; ───────────────────────────────────────────────────────────────────────────────
; Limits and Retention
; ───────────────────────────────────────────────────────────────────────────────
{.limits}
per_occurrence_limit = #$
aggregate_limit = #$
per_claim_limit = #$
policy_limit = #$

{@captive_program}

{.retention}
self_insured_retention = #$
deductible = #$
captive_retention = #$                        ; Retained by captive before reinsurance

{@captive_program}

; ───────────────────────────────────────────────────────────────────────────────
; Insureds
; ───────────────────────────────────────────────────────────────────────────────
named_insureds[] = :
insured_count = ##                            ; Number of insured entities/persons
related_party_only = ?                        ; Only owner/affiliates insured

; ═══════════════════════════════════════════════════════════════════════════════
; Captive Financial Statements
; ═══════════════════════════════════════════════════════════════════════════════
; Annual financial reporting for the captive.

{@captive_financials}
id = :
fiscal_year_end = date
statement_date = date

; ───────────────────────────────────────────────────────────────────────────────
; Balance Sheet - Assets
; ───────────────────────────────────────────────────────────────────────────────
{.assets}
cash_equivalents = #$
invested_assets = #$
bonds = #$
stocks = #$
real_estate = #$
premium_receivable = #$
reinsurance_recoverable = #$
due_from_parent = #$
other_assets = #$
total_admitted_assets = #$
non_admitted_assets = #$
total_assets = #$

{@captive_financials}

; ───────────────────────────────────────────────────────────────────────────────
; Balance Sheet - Liabilities
; ───────────────────────────────────────────────────────────────────────────────
{.liabilities}
loss_reserves = #$
loss_adjustment_expense_reserves = #$
unearned_premium = #$
ceded_reinsurance_payable = #$
due_to_parent = #$
other_liabilities = #$
total_liabilities = #$

{@captive_financials}

; ───────────────────────────────────────────────────────────────────────────────
; Capital and Surplus
; ───────────────────────────────────────────────────────────────────────────────
{.capital_surplus}
capital_stock = #$
paid_in_surplus = #$
unassigned_surplus = #$
total_capital_surplus = #$

{@captive_financials}

; ───────────────────────────────────────────────────────────────────────────────
; Income Statement
; ───────────────────────────────────────────────────────────────────────────────
{.income}
gross_premium_written = #$
net_premium_written = #$
net_premium_earned = #$
losses_incurred = #$
loss_adjustment_expenses = #$
other_underwriting_expenses = #$
underwriting_gain_loss = #$
net_investment_income = #$
realized_gains_losses = #$
other_income = #$
net_income = #$

{@captive_financials}

; ───────────────────────────────────────────────────────────────────────────────
; Key Ratios
; ───────────────────────────────────────────────────────────────────────────────
{.ratios}
loss_ratio = #                                ; Losses / Earned Premium
expense_ratio = #                             ; Expenses / Written Premium
combined_ratio = #                            ; Loss Ratio + Expense Ratio
operating_ratio = #                           ; Combined Ratio - Investment Income Ratio

{@captive_financials}

; ───────────────────────────────────────────────────────────────────────────────
; Audit Information
; ───────────────────────────────────────────────────────────────────────────────
auditor_name = :
audit_opinion = (unqualified, qualified, adverse, disclaimer)
audit_date = date
actuarial_opinion_required = ?
actuarial_opinion_date = date
actuary_name = :
actuary_firm = :

; ═══════════════════════════════════════════════════════════════════════════════
; Risk Retention Group
; ═══════════════════════════════════════════════════════════════════════════════
; Specialized captive structure under the Liability Risk Retention Act of 1986.
; RRGs can write liability coverage across state lines with federal preemption.

{@risk_retention_group}
id = :

; ───────────────────────────────────────────────────────────────────────────────
; RRG Identity
; ───────────────────────────────────────────────────────────────────────────────
group_name = :
chartering_state = :(2)                       ; State of charter/domicile
chartering_date = date
naic_rrg_code = :

; ───────────────────────────────────────────────────────────────────────────────
; Federal Preemption Status
; ───────────────────────────────────────────────────────────────────────────────
; RRGs have federal preemption under LRRA - chartered in one state,
; can operate in all states with registration only
lrra_compliant = ?
federal_preemption_applicable = ?

; ───────────────────────────────────────────────────────────────────────────────
; State Registrations
; ───────────────────────────────────────────────────────────────────────────────
; RRGs must register (not license) in non-domiciliary states
{.state_registrations[]}
state = :(2)
registration_date = date
registration_status = (active, suspended, withdrawn)
registration_number = :

{@risk_retention_group}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Limitations
; ───────────────────────────────────────────────────────────────────────────────
; RRGs can ONLY write liability coverage - not property, not WC
liability_coverage_only = ?
prohibited_coverages[] = :             ; workers_comp, property, etc.

; ───────────────────────────────────────────────────────────────────────────────
; Membership
; ───────────────────────────────────────────────────────────────────────────────
member_count = ##                             ; Minimum 2 members required
similar_exposure_requirement = ?              ; Members must have similar exposures
common_business_activity = :           ; Description of common activity

; ───────────────────────────────────────────────────────────────────────────────
; RRG Feasibility Study
; ───────────────────────────────────────────────────────────────────────────────
feasibility_study_date = date
feasibility_study_actuary = :
projected_premium_5_year = #$
projected_losses_5_year = #$

; ═══════════════════════════════════════════════════════════════════════════════
; 831(b) Micro-Captive Election
; ═══════════════════════════════════════════════════════════════════════════════
; Small captives electing taxation under IRC Section 831(b).
; Premium threshold for 2024: $2.8 million (indexed for inflation).

{@micro_captive_election}
id = :

; ───────────────────────────────────────────────────────────────────────────────
; Election Status
; ───────────────────────────────────────────────────────────────────────────────
election_status = (elected, not_elected, revoked, ineligible)
election_tax_year = ##:(2000..2100)
election_effective_date = date

; ───────────────────────────────────────────────────────────────────────────────
; Premium Threshold
; ───────────────────────────────────────────────────────────────────────────────
premium_threshold_year = ##:(1900..2100)
premium_threshold_amount = #$                 ; $2.8M for 2024, indexed
direct_written_premium = #$
reinsurance_premium_assumed = #$
total_premium = #$
under_threshold = ?

; ───────────────────────────────────────────────────────────────────────────────
; Tax Treatment
; ───────────────────────────────────────────────────────────────────────────────
; 831(b) captives pay tax on investment income only (not underwriting income)
tax_on_investment_income_only = ?
underwriting_income_excluded = ?

; ───────────────────────────────────────────────────────────────────────────────
; Risk Distribution Requirements (IRS)
; ───────────────────────────────────────────────────────────────────────────────
; IRS requires adequate risk distribution for insurance tax treatment
risk_distribution_method = (
    brother_sister_coverage,
    unrelated_third_party,
    risk_pool,
    multiple_insureds,
    other
)
unrelated_premium_percentage = #:(0..100)     ; % from unrelated parties
minimum_insured_count = ##                    ; Number of insured entities
risk_pool_participation = ?

; ───────────────────────────────────────────────────────────────────────────────
; Risk Shifting Requirements (IRS)
; ───────────────────────────────────────────────────────────────────────────────
; Genuine risk transfer from insured to insurer
risk_shifting_documented = ?
economic_risk_transfer = ?
arms_length_premium = ?
actuarially_determined_premium = ?

; ───────────────────────────────────────────────────────────────────────────────
; Listed Transaction Status (IRS Notice 2016-66)
; ───────────────────────────────────────────────────────────────────────────────
; IRS has identified certain micro-captive arrangements as listed transactions
listed_transaction = ?
transaction_of_interest = ?
disclosure_filed = ?
disclosure_form = :                           ; Form 8886

; ───────────────────────────────────────────────────────────────────────────────
; Loss Ratio Analysis
; ───────────────────────────────────────────────────────────────────────────────
; IRS scrutinizes low loss ratios as indicator of potential abuse
historical_loss_ratio = #
industry_benchmark_loss_ratio = #
loss_ratio_below_threshold = ?               ; Below 30% is listed transaction trigger

; ═══════════════════════════════════════════════════════════════════════════════
; Captive Actuarial Analysis
; ═══════════════════════════════════════════════════════════════════════════════
; Actuarial work required for captive formation and ongoing operations.

{@captive_actuarial}
id = :
analysis_date = date
analysis_type = (feasibility_study, reserve_study, premium_study, annual_opinion)

; ───────────────────────────────────────────────────────────────────────────────
; Actuary Information
; ───────────────────────────────────────────────────────────────────────────────
actuary_name = :
actuary_credentials = :               ; FCAS, FSA, MAAA, etc.
actuary_firm = :
actuary_independence = ?                      ; Independent from captive/parent

; ───────────────────────────────────────────────────────────────────────────────
; Feasibility Study (Formation)
; ───────────────────────────────────────────────────────────────────────────────
{.feasibility}
projected_premium_year_1 = #$
projected_premium_year_5 = #$
projected_losses_year_1 = #$
projected_losses_year_5 = #$
recommended_capital = #$
recommended_surplus = #$
break_even_year = ##
feasibility_conclusion = (favorable, unfavorable, conditional)

{@captive_actuarial}

; ───────────────────────────────────────────────────────────────────────────────
; Reserve Analysis
; ───────────────────────────────────────────────────────────────────────────────
{.reserves}
case_reserves = #$
ibnr_reserves = #$                            ; Incurred But Not Reported
bulk_reserves = #$
total_loss_reserves = #$
lae_reserves = #$                             ; Loss Adjustment Expenses
total_reserves = #$
reserve_adequacy_opinion = (adequate, inadequate, cannot_determine)

{@captive_actuarial}

; ───────────────────────────────────────────────────────────────────────────────
; Premium Analysis
; ───────────────────────────────────────────────────────────────────────────────
{.premium_analysis}
indicated_premium = #$
selected_premium = #$
loss_cost = #$
expense_load = #:(0..100)
profit_margin = #:(0..100)
risk_load = #:(0..100)
premium_adequacy_opinion = (adequate, inadequate, cannot_determine)

{@captive_actuarial}

; ───────────────────────────────────────────────────────────────────────────────
; Statement of Actuarial Opinion (SAO)
; ───────────────────────────────────────────────────────────────────────────────
sao_required = ?
sao_date = date
sao_type = (appointed_actuary, independent_actuary)
sao_opinion = (unqualified, qualified, adverse)
sao_scope_limitations = :

; ═══════════════════════════════════════════════════════════════════════════════
; Captive Service Providers
; ═══════════════════════════════════════════════════════════════════════════════
; External service providers supporting captive operations.

{@captive_service_provider}
id = :
provider_name = :

; ───────────────────────────────────────────────────────────────────────────────
; Provider Role
; ───────────────────────────────────────────────────────────────────────────────
provider_role = (
    captive_manager,
    actuary,
    auditor,
    legal_counsel,
    investment_manager,
    claims_administrator,
    fronting_carrier,
    reinsurer,
    broker,
    banker,
    registered_agent,
    tax_advisor
)

; ───────────────────────────────────────────────────────────────────────────────
; Engagement Details
; ───────────────────────────────────────────────────────────────────────────────
engagement_date = date
engagement_expiration = date
annual_fee = #$
fee_structure = :

; ───────────────────────────────────────────────────────────────────────────────
; Contact
; ───────────────────────────────────────────────────────────────────────────────
contact_ref = :                               ; Contact reference

{@captive_service_provider}

; ═══════════════════════════════════════════════════════════════════════════════
; Captive Reinsurance
; ═══════════════════════════════════════════════════════════════════════════════
; Reinsurance purchased by the captive to manage retained risk.

{@captive_reinsurance}
id = :

; ───────────────────────────────────────────────────────────────────────────────
; Reinsurer Information
; ───────────────────────────────────────────────────────────────────────────────
reinsurer_ref = :                             ; Reference to carrier.schema.odin
authorized_reinsurer = ?                      ; Licensed/accredited in state

; ───────────────────────────────────────────────────────────────────────────────
; Treaty Type
; ───────────────────────────────────────────────────────────────────────────────
treaty_type = (
    quota_share,
    excess_of_loss,
    aggregate_stop_loss,
    catastrophe,
    facultative,
    finite,
    loss_portfolio_transfer
)

; ───────────────────────────────────────────────────────────────────────────────
; Treaty Terms
; ───────────────────────────────────────────────────────────────────────────────
treaty_effective_date = date
treaty_expiration_date = date
treaty_limit = #$
treaty_attachment = #$                        ; Attachment point
cession_percentage = #:(0..100)               ; For quota share
ceded_premium = #$
provisional_rate = #:(0..100)
sliding_scale = ?

; ───────────────────────────────────────────────────────────────────────────────
; Collateral/Security
; ───────────────────────────────────────────────────────────────────────────────
collateral_required = ?
trust_fund = #$
letter_of_credit = #$
funds_withheld = #$

; ═══════════════════════════════════════════════════════════════════════════════
; Captive Annual Report
; ═══════════════════════════════════════════════════════════════════════════════
; Regulatory annual reporting requirements.

{@captive_annual_report}
id = :
reporting_year = ##:(2000..2100)

; ───────────────────────────────────────────────────────────────────────────────
; Filing Requirements
; ───────────────────────────────────────────────────────────────────────────────
filing_due_date = date
filing_date = date
filing_status = (filed, pending, overdue, extension_granted)
extension_date = date:if filing_status = extension_granted

; ───────────────────────────────────────────────────────────────────────────────
; Required Components
; ───────────────────────────────────────────────────────────────────────────────
audited_financials_required = ?
audited_financials_filed = ?
actuarial_opinion_required = ?
actuarial_opinion_filed = ?
premium_tax_return_required = ?
premium_tax_return_filed = ?
management_report_required = ?
management_report_filed = ?

; ───────────────────────────────────────────────────────────────────────────────
; Examination Status
; ───────────────────────────────────────────────────────────────────────────────
examination_year = ?                          ; Is this an examination year
examination_scheduled = ?
examination_start_date = date
examination_completion_date = date
examination_findings = :

; ───────────────────────────────────────────────────────────────────────────────
; Premium Tax
; ───────────────────────────────────────────────────────────────────────────────
{.premium_tax}
gross_premium_taxable = #$
tax_rate = #:(0..100)
premium_tax_due = #$
premium_tax_paid = #$
premium_tax_credits = #$

{@captive_annual_report}

; ═══════════════════════════════════════════════════════════════════════════════
; Complete Captive Structure
; ═══════════════════════════════════════════════════════════════════════════════
; Top-level type combining all captive elements.

{@captive_structure}
id = :

; Core Entity
entity = @captive_entity
domicile = @captive_domicile
capitalization = @captive_capitalization
governance = @captive_governance
manager = @captive_manager

; Ownership
owners[] = @captive_owner

; Cells (if PCC/SPC)
cells[] = @captive_cell

; Programs
programs[] = @captive_program

; Fronting
fronting_arrangements[] = @captive_fronting

; Reinsurance
reinsurance_treaties[] = @captive_reinsurance

; Financials
financials[] = @captive_financials
annual_reports[] = @captive_annual_report

; Actuarial
actuarial_studies[] = @captive_actuarial

; Service Providers
service_providers[] = @captive_service_provider

; RRG-specific (if applicable)
rrg_details = @risk_retention_group

; Micro-captive (if applicable)
micro_captive_election = @micro_captive_election


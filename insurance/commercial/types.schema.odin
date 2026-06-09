; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Commercial Insurance Common Types
; ═══════════════════════════════════════════════════════════════════════════════
; Reusable type definitions for commercial insurance schemas shared across all
; commercial lines but not personal lines.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types
@import "../common/party.schema.odin" as party

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.types"
version = "1.0.0"
title = "Commercial Insurance Common Types"
description = "Reusable type definitions for commercial insurance lines"

{$derivation}
source[0].authority = "U.S. Census Bureau"
source[0].citation = "North American Industry Classification System (NAICS) 2022"
source[0].url = "https://www.census.gov/naics/"

source[1].authority = "Internal Revenue Service"
source[1].citation = "Employer Identification Number (EIN) Requirements"
source[1].url = "https://www.irs.gov/businesses/small-businesses-self-employed/employer-id-numbers"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Standard commercial business entity and insurance data elements"

changelog[0].date = 2025-12-13
changelog[0].change = "Initial commercial types schema"
changelog[0].rationale = "Foundation types for all commercial insurance lines"

; ═══════════════════════════════════════════════════════════════════════════════
; Business Structure Types
; ═══════════════════════════════════════════════════════════════════════════════

{@business_structure}
structure_type = (c_corporation, cooperative, county, estate, federal_government, foreign_corporation, general_partnership, joint_venture, limited_liability_partnership, limited_partnership, llc_multi_member, llc_single_member, municipality, nonprofit_501c3, nonprofit_501c4, nonprofit_501c6, nonprofit_other, other, professional_corporation, s_corporation, sole_proprietorship, state_government, tribal_nation, trust)

; ═══════════════════════════════════════════════════════════════════════════════
; Industry Classification
; ═══════════════════════════════════════════════════════════════════════════════

{@industry_classification}
; NAICS (North American Industry Classification System)
naics_primary = :(6)                           ; Primary 6-digit NAICS code
naics_description = :

; Additional NAICS codes
{.naics_secondary[]}
code = :(6)
description = :
percentage = ##:(0..100)     ; Percentage of operations

; SIC (Standard Industrial Classification) - legacy
sic_primary = :(4)
sic_description = :

; General Liability Classification
gl_class = :                                   ; GL class code
gl_class_description = :

; ═══════════════════════════════════════════════════════════════════════════════
; Officer / Key Person
; ═══════════════════════════════════════════════════════════════════════════════

{@officer}
= @person                                    ; Inherits person fields (name, ssn, dob, contact)

; Required fields first
title = :                                   ; Officer title

; Override required name fields
{.name}
first = :                                   ; First name (required)
last = :                                    ; Last name (required)

{@officer}

; Officer-specific fields
background_check_completed = ?               ; Background check performed
background_check_date = date                 ; Background check completion date
compensation = #$                            ; Annual compensation
hire_date = date                             ; Employment start date
officer_id = :                               ; Unique officer identifier
ownership_percentage = #:(0..100)            ; Ownership percentage
role = (board_member, ceo, cfo, coo, director, general_partner, limited_partner, managing_member, other, owner, president, principal, registered_agent, secretary, treasurer, vice_president)  ; Officer role
termination_date = date                      ; Employment end date
voting_percentage = #:(0..100)               ; Voting rights percentage

{@officer}

; ═══════════════════════════════════════════════════════════════════════════════
; Shareholder / Owner
; ═══════════════════════════════════════════════════════════════════════════════

{@shareholder}
shareholder_id = :

; Identity (person or entity)
shareholder_type = (entity, individual)

; If individual
{.individual}
{.name}
first = :if shareholder_type = individual
last = :if shareholder_type = individual

{.individual}
ssn = *:format ssn:if shareholder_type = individual  ; US SSN
sin = *:/^\d{3}-\d{3}-\d{3}$/:if shareholder_type = individual  ; Canadian SIN

{@shareholder}
; If entity
{.entity}
name = :if shareholder_type = entity
fein = *:format ein:if shareholder_type = entity
entity_type = @business_structure:if shareholder_type = entity

{@shareholder}

; Ownership
shares_owned = ##
ownership_percentage = #:(0..100)
voting_percentage = #:(0..100)
class_of_stock = :                             ; Common, Preferred, etc.

; Dates
acquisition_date = date
disposition_date = date

; ═══════════════════════════════════════════════════════════════════════════════
; Affiliate (Subsidiary, Parent, Related Entity)
; ═══════════════════════════════════════════════════════════════════════════════

{@affiliate}
= @organization                               ; Inherits from organization

; ───────────────────────────────────────────────────────────────────────────────
; Relationship to Primary Entity
; ───────────────────────────────────────────────────────────────────────────────
relationship_type = (
    affiliate,
    joint_venture,
    parent,
    predecessor,
    sister_company,
    subsidiary,
    successor
)
ownership_percentage = #:(0..100)
consolidated_financial = ?

; ───────────────────────────────────────────────────────────────────────────────
; Operations
; ───────────────────────────────────────────────────────────────────────────────
primary_operations = :
employee_count = ##
annual_revenue = #$

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Status
; ───────────────────────────────────────────────────────────────────────────────
included_as_insured = ?
separate_policy = ?
policy_number = :if separate_policy = true

; ═══════════════════════════════════════════════════════════════════════════════
; Financial Information
; ═══════════════════════════════════════════════════════════════════════════════

{@financial_info}
fiscal_year_end = :(5)                         ; MM-DD format
reporting_period = date_range

; Revenue
gross_revenue = #$
net_revenue = #$
gross_receipts = #$

; Payroll
total_payroll = #$
officer_payroll = #$
clerical_payroll = #$

; Assets
total_assets = #$
current_assets = #$
fixed_assets = #$

; Liabilities
total_liabilities = #$
current_liabilities = #$
long_term_debt = #$

; Equity
shareholders_equity = #$  ; Equity value
retained_earnings = #$    ; Retained earnings value

; Profitability
net_income = #$:          ; Net income value
ebitda = #$:              ; Earnings before interest, taxes, depreciation, amortization

; Financial Status
audited_financials = ?
auditor_name = :
audit_opinion = (adverse, disclaimer, qualified, unqualified)

; ═══════════════════════════════════════════════════════════════════════════════
; Claims-Made Policy Dates
; ═══════════════════════════════════════════════════════════════════════════════

{@claims_made_dates}
retroactive_date = date                        ; Prior acts date
continuity_date = date                         ; Date of first claims-made policy
pending_or_prior_date = date                   ; P&P litigation date

; Extended Reporting Period (Tail)
erp_purchased = ?
erp_type = (
    five_year,
    mini_tail,
    one_year,
    three_year,
    two_year,
    unlimited
):if erp_purchased = true
erp_effective_date = date:if erp_purchased = true
erp_expiration_date = date:if erp_purchased = true
erp_premium = #$:if erp_purchased = true

; ═══════════════════════════════════════════════════════════════════════════════
; Audit Information (Premium Audit)
; ═══════════════════════════════════════════════════════════════════════════════

{@premium_audit}
audit_id = :
policy_number = :
policy_period = date_range

; Audit Details
audit_type = (
    estimated,
    final,
    mail,
    physical,
    telephone,
    voluntary
)
audit_date = date
auditor_name = :

; Status
status = (
    completed,
    disputed,
    in_progress,
    pending,
    waived
)

; Results
estimated_premium = #$
audited_premium = #$
premium_adjustment = #$:(-999999999..999999999)
additional_premium_due = #$
return_premium_due = #$

; Exposure Details
{.exposures[]}
basis = (area, other, payroll, receipts, sales, units)
class_code = :
estimated_exposure = #$
audited_exposure = #$
variance = #$:(-999999999999..999999999999)

; ═══════════════════════════════════════════════════════════════════════════════
; Subcontractor Information
; ═══════════════════════════════════════════════════════════════════════════════

{@subcontractor}
; Required fields first
company_name = :                            ; Subcontractor company name

; Optional fields
additional_insured_status = ?                ; Named as additional insured
coi_expiration_date = date                   ; Certificate of insurance expiration
coi_on_file = ?                              ; Certificate on file
contact_emails[] = *@email                   ; Contact emails (confidential)
contact_name = :                             ; Contact person name
contact_phones[] = *@phone                   ; Contact phones (confidential)
contract_amount = #$                         ; Contract dollar amount
contract_effective = date                    ; Contract effective date
contract_expiration = date                   ; Contract expiration date
dba_name = :                                 ; Doing business as name
fein = *:format ein                     ; Federal Employer ID Number
gl_limit_required = ##                       ; GL limit required
gl_limit_verified = ##                       ; GL limit verified
subcontractor_id = :                         ; Unique subcontractor identifier
waiver_of_subrogation = ?                    ; Waiver obtained
wc_verified = ?                              ; Workers comp verified
work_description = :                         ; Description of work

; ═══════════════════════════════════════════════════════════════════════════════
; Loss Control / Risk Management
; ═══════════════════════════════════════════════════════════════════════════════

{@loss_control}
inspection_id = :

; Inspection
inspection_type = (
    claim_related,
    compliance,
    loss_control,
    renewal,
    safety,
    underwriting
)
inspection_date = date
inspector_name = :
inspector_company = :

; Findings
overall_rating = (excellent, fair, good, poor, unacceptable)
hazards_identified[] = :
recommendations[] = :
required_improvements[] = :
improvement_deadline = date

; Follow-Up
follow_up_required = ?
follow_up_date = date
improvements_verified = ?
verification_date = date


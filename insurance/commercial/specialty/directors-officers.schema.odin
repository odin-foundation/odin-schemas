; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Directors & Officers Liability (D&O) Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Directors and Officers (D&O) liability coverage including Side A (individual
; D&O coverage), Side B (corporate reimbursement), Side C (entity securities
; coverage), and Side D (derivative investigation costs).
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as com
@import "../business.schema.odin" as entity

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.specialty.directors-officers"
version = "1.0.0"
title = "Directors & Officers Liability Schema"
description = "Comprehensive D&O coverage with Side A/B/C/D structure"

{$derivation}
source[0].authority = "U.S. Securities and Exchange Commission"
source[0].citation = "Securities Act of 1933, Securities Exchange Act of 1934"
source[0].url = "https://www.sec.gov/laws"

source[1].authority = "Delaware Court of Chancery"
source[1].citation = "Delaware General Corporation Law"
source[1].url = "https://delcode.delaware.gov/title8/"

source[2].authority = "American Law Institute"
source[2].citation = "Model Business Corporation Act"
source[2].url = "https://www.americanbar.org/groups/business_law/publications/mbca/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Complete D&O schema covering public, private, and nonprofit entities"

changelog[0].date = 2025-12-13
changelog[0].change = "Initial D&O schema"
changelog[0].rationale = "Comprehensive management liability coverage structure"

; ═══════════════════════════════════════════════════════════════════════════════
; Insured Person
; ═══════════════════════════════════════════════════════════════════════════════

{@do_insured_person}
= @person                                         ; Inherits person fields (name, contact)

person_id = :                                     ; Unique identifier for the insured person

; ───────────────────────────────────────────────────────────────────────────────
; Override required name fields
; ───────────────────────────────────────────────────────────────────────────────

{.name}
first = !:                                        ; Required first name
last = !:                                         ; Required last name

{@do_insured_person}

; ───────────────────────────────────────────────────────────────────────────────
; Position
; ───────────────────────────────────────────────────────────────────────────────
title = !:                                        ; Required job title of the insured person
position_type = !(                                ; Required classification of the person's role
    committee_member,
    de_facto_director,
    director,
    employee,
    executive_officer,
    general_partner,
    independent_director,
    manager,                                  ; LLC
    member,
    officer,
    other,
    outside_director,
    shadow_director,
    trustee
)

; Board Details
board_member = ?                                  ; Whether person serves on the board of directors
board_committees[] = (audit, compensation, executive, governance, nominating, other, risk) ; Board committees on which the person serves
committee_chair[] = (audit, compensation, executive, governance, nominating, risk) ; Committees where person serves as chair
board_chair = ?                                   ; Whether person is the chairman of the board
lead_independent_director = ?                     ; Whether person is the lead independent director

; Officer Roles
c_suite = ?                                       ; Whether person holds a C-level executive position
officer_title = (                                 ; Specific officer title if position_type is officer
    ceo,
    cfo,
    cio,
    cmo,
    controller,
    coo,
    corporate_secretary,
    cro,
    cso,
    cto,
    evp,
    general_counsel,
    other,
    president,
    svp,
    treasurer,
    vp
):if position_type = officer

; ───────────────────────────────────────────────────────────────────────────────
; Service Period
; ───────────────────────────────────────────────────────────────────────────────
effective = date                                  ; Date when person's service began
expiration = date                                 ; Date when person's service ended (if applicable)
current = ?                                       ; Whether person is currently serving in this role

; Former D&O Coverage
former_do = ?:if current = false                  ; Whether extended coverage applies for former D&O
years_of_extended_coverage = ##:(0..10):if former_do = true ; Years of runoff coverage for former D&O

; ───────────────────────────────────────────────────────────────────────────────
; Compensation (relevant for Side A capacity)
; ───────────────────────────────────────────────────────────────────────────────
total_compensation = #$                           ; Total annual compensation including salary and bonuses
stock_ownership_percentage = #:(0..100)           ; Percentage of company stock owned by person

; ───────────────────────────────────────────────────────────────────────────────
; Outside Board Service
; ───────────────────────────────────────────────────────────────────────────────
{.outside_directorships[]}
company_name = :                                  ; Name of company where person serves on outside board
position = :                                      ; Position held on the outside board
publicly_traded = ?                               ; Whether the outside company is publicly traded
nonprofit = ?                                     ; Whether the outside company is a nonprofit organization

; ═══════════════════════════════════════════════════════════════════════════════
; D&O Coverage Structure
; ═══════════════════════════════════════════════════════════════════════════════

{@do_coverage}
coverage_id = :                                   ; Unique identifier for the coverage structure

; ───────────────────────────────────────────────────────────────────────────────
; Side A - Non-Indemnifiable Loss
; ───────────────────────────────────────────────────────────────────────────────
; Covers individual D&Os when company cannot or will not indemnify
; Most valuable coverage - pays when company is bankrupt, derivative suits, etc.

{.side_a}
included = !?true                                 ; Whether Side A coverage is included (defaults to true)
limit = #$:if side_a.included = true              ; Coverage limit for Side A
retention = ##:if side_a.included = true          ; Deductible amount for Side A claims
excess_of_side_b_c = ?:if side_a.included = true  ; Whether Side A limit applies excess of Side B/C
dedicated_limit = ?:if side_a.included = true       ; DIC / Difference in Conditions

{@do_coverage}

; Side A DIC (Difference in Conditions) - Standalone Side A
{.side_a_dic}
included = ?                                      ; Whether standalone Side A DIC coverage is included
limit = #$:if side_a_dic.included = true          ; Coverage limit for Side A DIC
drops_down = ?:if side_a_dic.included = true      ; Whether DIC coverage drops down when underlying exhausted
bankruptcy_trigger = ?:if side_a_dic.included = true ; Whether coverage triggers on company bankruptcy
coverage_gaps = ?:if side_a_dic.included = true   ; Whether DIC fills gaps in underlying coverage

{@do_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Side B - Corporate Reimbursement
; ───────────────────────────────────────────────────────────────────────────────
; Reimburses the company for indemnifying D&Os

{.side_b}
included = ?                                      ; Whether Side B coverage is included
limit = #$:if side_b.included = true              ; Coverage limit for Side B
retention = ##:if side_b.included = true          ; Deductible amount for Side B claims
coinsurance = ##:(0..50):if side_b.included = true ; Percentage of loss shared by insured (0-50%)

{@do_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Side C - Entity Securities Coverage (Public Companies)
; ───────────────────────────────────────────────────────────────────────────────
; Covers the entity itself for securities claims

{.side_c}
included = ?                                      ; Whether Side C coverage is included
limit = #$:if side_c.included = true              ; Coverage limit for Side C
retention = ##:if side_c.included = true          ; Deductible amount for Side C claims
securities_claims_only = ?:if side_c.included = true ; Whether coverage is limited to securities claims only
coinsurance = ##:(0..50):if side_c.included = true ; Percentage of loss shared by insured (0-50%)

{@do_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Side D - Derivative Investigation Costs / Pre-Claim Inquiry
; ───────────────────────────────────────────────────────────────────────────────

{.side_d}
included = ?                                      ; Whether Side D coverage is included
limit = #$:if side_d.included = true              ; Coverage limit for Side D
sublimit = ?:if side_d.included = true            ; Whether Side D has a separate sublimit
retention = ##:if side_d.included = true          ; Deductible amount for Side D claims

{@do_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Policy Aggregate
; ───────────────────────────────────────────────────────────────────────────────
policy_aggregate = #$                             ; Total aggregate limit across all coverage sides
defense_within_limits = ?true                 ; Defense costs erode limits

; ───────────────────────────────────────────────────────────────────────────────
; Priority of Payments
; ───────────────────────────────────────────────────────────────────────────────
; When shared limits are exhausted, order of payment
priority_of_payments = (                          ; Order of priority when limits are exhausted
    entity_first,                             ; Rare
    individuals_first,                        ; Side A before B/C
    pro_rata
)

; Order of Layers for Excess
order_of_payments = (follow_form, specific)       ; How excess layers apply (follow form or specific terms)

; ═══════════════════════════════════════════════════════════════════════════════
; Entity Coverage Extensions
; ═══════════════════════════════════════════════════════════════════════════════

{@do_entity_extensions}
extension_id = :                                  ; Unique identifier for entity coverage extensions

; ───────────────────────────────────────────────────────────────────────────────
; Employment Practices Liability (Sometimes added to D&O)
; ───────────────────────────────────────────────────────────────────────────────

{.epl}
included = ?                                      ; Whether employment practices liability coverage is included
limit = #$:if epl.included = true                 ; Coverage limit for EPL claims
retention = ##:if epl.included = true             ; Deductible amount for EPL claims
third_party_claims = ?:if epl.included = true     ; Whether third-party harassment claims are covered
wage_hour_sublimit = #$:if epl.included = true    ; Sublimit for wage and hour violation claims

{@do_entity_extensions}

; ───────────────────────────────────────────────────────────────────────────────
; Fiduciary Liability
; ───────────────────────────────────────────────────────────────────────────────

{.fiduciary}
included = ?                                      ; Whether fiduciary liability coverage is included
limit = #$:if fiduciary.included = true           ; Coverage limit for fiduciary liability claims
retention = ##:if fiduciary.included = true       ; Deductible amount for fiduciary liability claims
dol_civil_penalties = ?:if fiduciary.included = true ; Whether DOL civil penalties are covered
voluntary_compliance = ?:if fiduciary.included = true ; Whether voluntary compliance costs are covered
settlor_function = ?:if fiduciary.included = true ; Whether settlor function decisions are covered

{@do_entity_extensions}

; ───────────────────────────────────────────────────────────────────────────────
; Crime / Fidelity
; ───────────────────────────────────────────────────────────────────────────────

{.crime}
included = ?                                      ; Whether crime/fidelity coverage is included
limit = #$:if crime.included = true               ; Coverage limit for crime/fidelity claims
retention = ##:if crime.included = true           ; Deductible amount for crime/fidelity claims

{@do_entity_extensions}

; ───────────────────────────────────────────────────────────────────────────────
; Kidnap & Ransom
; ───────────────────────────────────────────────────────────────────────────────

{.kidnap_ransom}
included = ?                                      ; Whether kidnap and ransom coverage is included
limit = #$:if kidnap_ransom.included = true       ; Coverage limit for kidnap and ransom claims

{@do_entity_extensions}

; ───────────────────────────────────────────────────────────────────────────────
; Crisis Management / Reputation
; ───────────────────────────────────────────────────────────────────────────────

{.crisis_management}
included = ?                                      ; Whether crisis management coverage is included
limit = #$:if crisis_management.included = true   ; Coverage limit for crisis management expenses

{@do_entity_extensions}

; ───────────────────────────────────────────────────────────────────────────────
; Investigative Costs
; ───────────────────────────────────────────────────────────────────────────────

{.investigation_costs}
sec_subpoena = ?                                  ; Whether SEC subpoena costs are covered
doj_investigation = ?                             ; Whether DOJ investigation costs are covered
state_ag = ?                                      ; Whether state attorney general investigation costs are covered
congressional = ?                                 ; Whether congressional investigation costs are covered
limit = #$                                        ; Coverage limit for investigation costs

{@do_entity_extensions}

; ───────────────────────────────────────────────────────────────────────────────
; Extradition Costs
; ───────────────────────────────────────────────────────────────────────────────

{.extradition}
included = ?                                      ; Whether extradition cost coverage is included
limit = #$:if extradition.included = true         ; Coverage limit for extradition costs

{@do_entity_extensions}

; ───────────────────────────────────────────────────────────────────────────────
; Civil Fines and Penalties
; ───────────────────────────────────────────────────────────────────────────────

{.civil_fines}
included = ?                                      ; Whether civil fines and penalties coverage is included
limit = #$:if civil_fines.included = true         ; Coverage limit for civil fines and penalties
insurable_only = ?:if civil_fines.included = true ; Whether only insurable fines are covered

{@do_entity_extensions}

; ═══════════════════════════════════════════════════════════════════════════════
; Subsidiary / Acquisition Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@do_subsidiary}
subsidiary_id = :                                 ; Unique identifier for the subsidiary
legal_name = !:                                   ; Required legal name of the subsidiary
coverage_status = !(                              ; Required coverage status of the subsidiary
    automatically_covered,
    scheduled,
    excluded,
    pending_underwriting
)

; Identity
fein = *:format ein                       ; US EIN
bn = *:/^\d{9}$/                               ; Canadian Business Number
state_province_of_incorporation = :(2)        ; US state or Canadian province
country_of_incorporation = :(2..3) "US"       ; ISO 3166: "US" or "CA"

; Ownership
ownership_percentage = #:(0..100)                 ; Percentage ownership of subsidiary by parent company
acquisition_date = date                           ; Date when subsidiary was acquired
disposition_date = date                           ; Date when subsidiary was disposed of
wholly_owned = ?                                  ; Whether subsidiary is 100% owned by parent

; Thresholds for automatic coverage
meets_automatic_threshold = ?                     ; Whether subsidiary meets automatic coverage thresholds
assets_under_threshold = ?                        ; Whether subsidiary assets are under automatic coverage threshold
revenue_under_threshold = ?                       ; Whether subsidiary revenue is under automatic coverage threshold

; ───────────────────────────────────────────────────────────────────────────────
; Acquisition / Transaction Coverage
; ───────────────────────────────────────────────────────────────────────────────
transaction_type = (acquisition, merger, divestiture, spinoff, ipo, spac) ; Type of transaction involving subsidiary
transaction_date = date                           ; Date when transaction occurred
transaction_value = #$                            ; Dollar value of the transaction
target_company_name = :                           ; Name of target company in transaction
runoff_coverage = ?                               ; Whether runoff coverage is purchased for transaction
runoff_period_years = ##:(1..10):if runoff_coverage = true ; Number of years for runoff coverage period

; ═══════════════════════════════════════════════════════════════════════════════
; Securities Exposures (Public Companies)
; ═══════════════════════════════════════════════════════════════════════════════

{@do_securities_exposure}
exposure_id = :                                   ; Unique identifier for securities exposure

; ───────────────────────────────────────────────────────────────────────────────
; Securities Information
; ───────────────────────────────────────────────────────────────────────────────
publicly_traded = ?                               ; Whether company is publicly traded
exchange = (AMEX, LSE, NASDAQ, NYSE, OTC, TSX, foreign_other):if publicly_traded = true ; Stock exchange where company is listed
ticker_symbol = ::if publicly_traded = true       ; Stock ticker symbol
market_cap = #$:if publicly_traded = true         ; Market capitalization of the company
market_cap_category = (                           ; Market cap size category
    micro_cap,                                ; < $300M
    small_cap,                                ; $300M - $2B
    mid_cap,                                  ; $2B - $10B
    large_cap,                                ; $10B - $200B
    mega_cap                                  ; > $200B
):if publicly_traded = true

; Stock Information
outstanding_shares = ##:if publicly_traded = true ; Total number of outstanding shares
average_daily_volume = ##:if publicly_traded = true ; Average daily trading volume of shares
institutional_ownership_percentage = ##:(0..100):if publicly_traded = true ; Percentage of shares owned by institutions
insider_ownership_percentage = ##:(0..100):if publicly_traded = true ; Percentage of shares owned by insiders

; ───────────────────────────────────────────────────────────────────────────────
; SEC Filings
; ───────────────────────────────────────────────────────────────────────────────
sec_registrant = ?:if publicly_traded = true      ; Whether company is registered with the SEC
sec_cik = ::if sec_registrant = true              ; SEC Central Index Key number
sec_filing_status = (large_accelerated, accelerated, non_accelerated, smaller_reporting, emerging_growth):if sec_registrant = true ; SEC filer status category

; Recent Offerings
{.recent_offerings[]}
type = (ipo, secondary, debt, convertible):if publicly_traded = true ; Type of securities offering
date = date:if publicly_traded = true             ; Date of the offering
amount = #$:if publicly_traded = true             ; Dollar amount raised in the offering

; ───────────────────────────────────────────────────────────────────────────────
; ADR / Foreign Private Issuer
; ───────────────────────────────────────────────────────────────────────────────
adr_program = ?                                   ; Whether company has an ADR program
adr_level = ##:(1..3):if adr_program = true       ; Level of ADR program (1, 2, or 3)
foreign_private_issuer = ?                        ; Whether company is a foreign private issuer
home_country = ::if foreign_private_issuer = true ; Home country of foreign private issuer
home_exchange = ::if foreign_private_issuer = true ; Primary exchange in home country

; ───────────────────────────────────────────────────────────────────────────────
; SPAC Exposure
; ───────────────────────────────────────────────────────────────────────────────
spac = ?                                          ; Whether company is a SPAC
spac_status = (pre_ipo, searching, announced_target, de_spac_completed):if spac = true ; Current status of SPAC lifecycle
trust_amount = #$:if spac = true                  ; Amount held in trust for SPAC

; ═══════════════════════════════════════════════════════════════════════════════
; Private Company Exposures
; ═══════════════════════════════════════════════════════════════════════════════

{@do_private_exposure}
exposure_id = :                                   ; Unique identifier for private company exposure

; Company Status
venture_backed = ?                                ; Whether company is venture capital backed
pe_backed = ?                                     ; Whether company is private equity backed
pre_ipo = ?                                       ; Whether company is preparing for IPO
expected_ipo_date = date:if pre_ipo = true        ; Expected date of initial public offering

; Funding History
total_funding_raised = #$                         ; Total amount of funding raised to date
last_round_type = (seed, series_a, series_b, series_c, series_d_plus, growth, mezzanine) ; Type of most recent funding round
last_round_amount = #$                            ; Amount raised in most recent funding round
last_round_date = date                            ; Date of most recent funding round
post_money_valuation = #$                         ; Company valuation after most recent funding round

; Investors
institutional_investor_count = ##                 ; Number of institutional investors
lead_investors[] = :                              ; Names of lead investors
board_seats_investor_controlled = ##:(0..20)      ; Number of board seats controlled by investors

; M&A Exposure
m_and_a_active = ?                                ; Whether company is actively pursuing M&A
recent_acquisitions_count = ##                    ; Number of recent acquisitions
planned_acquisitions = ?                          ; Whether acquisitions are planned
recent_divestitures_count = ##                    ; Number of recent divestitures
planned_divestitures = ?                          ; Whether divestitures are planned

; ═══════════════════════════════════════════════════════════════════════════════
; Nonprofit Exposures
; ═══════════════════════════════════════════════════════════════════════════════

{@do_nonprofit_exposure}
exposure_id = :                                   ; Unique identifier for nonprofit exposure

; Tax Status
tax_exempt_status = (501c3, 501c4, 501c6, other)  ; IRS tax-exempt status category
irs_determination_letter_date = date              ; Date of IRS determination letter granting tax-exempt status

; Financial
annual_budget = #$                                ; Total annual operating budget
total_assets = #$                                 ; Total assets of the nonprofit
endowment_value = #$                              ; Value of endowment fund
annual_fundraising = #$                           ; Total annual fundraising amount

; Governance
board_size = ##:(1..99)                           ; Number of board members
paid_board_members = ##                           ; Number of board members who are compensated
volunteer_board_members = ##                      ; Number of volunteer board members
d_and_o_questionnaires_completed = ?              ; Whether D&O questionnaires have been completed by board

; Special Exposures
government_grants = ?                             ; Whether nonprofit receives government grants
government_grant_amount = #$:if government_grants = true ; Total amount of government grants received
accreditation_required = ?                        ; Whether accreditation is required for operations
accrediting_body = ::if accreditation_required = true ; Name of accrediting organization

; ═══════════════════════════════════════════════════════════════════════════════
; D&O Endorsements
; ═══════════════════════════════════════════════════════════════════════════════

{@do_endorsement}
id = !:                                           ; Required unique identifier for the endorsement
number = !:                                       ; Required endorsement number
type = !(                                         ; Required type of endorsement
    ; Coverage Extensions
    acquisition_extension,
    bodily_injury_property_damage_exclusion,
    crime_coverage,
    crisis_management,
    decreased_sublimit,
    entity_coverage_extension,
    epl_coverage,
    fiduciary_coverage,
    increased_sublimit,
    investigation_costs,
    other,
    pollution_exclusion,
    prior_acts_exclusion,
    professional_services_exclusion,
    reinstatement,
    runoff_coverage,
    specific_claim_exclusion
)
title = :                                         ; Title or name of the endorsement
effective_date = date                             ; Date when endorsement becomes effective
description = :                                   ; Detailed description of endorsement terms
premium_impact = #$                               ; Additional premium charged for this endorsement

; ═══════════════════════════════════════════════════════════════════════════════
; D&O Policy (Composes All Parts)
; ═══════════════════════════════════════════════════════════════════════════════

{@do_policy}
id = !:                                           ; Required unique policy identifier
number = !:                                       ; Required policy number
effective_date = !date                            ; Required policy effective date
expiration_date = !date                           ; Required policy expiration date
type = !(                                         ; Required type of D&O policy
    excess_follow_form,
    excess_specific,
    nonprofit,
    private_company,
    private_equity_portfolio,
    public_company,
    side_a_dic_only
)
retroactive_date = !date                          ; Required retroactive date for claims-made coverage

; ───────────────────────────────────────────────────────────────────────────────
; Term
; ───────────────────────────────────────────────────────────────────────────────
effective_time = time                             ; Time of day when policy becomes effective
expiration_time = time                            ; Time of day when policy expires
:invariant expiration_date > effective_date

; ───────────────────────────────────────────────────────────────────────────────
; Policy Type
; ───────────────────────────────────────────────────────────────────────────────

; ───────────────────────────────────────────────────────────────────────────────
; Claims-Made Dates
; ───────────────────────────────────────────────────────────────────────────────
continuity_date = date                            ; Continuity date from prior policy
pending_prior_litigation_date = date              ; Date for pending and prior litigation exclusion

; Extended Reporting Period
erp_purchased = ?                                 ; Whether extended reporting period is purchased
erp_type = (basic, supplemental_1_year, supplemental_3_year, supplemental_6_year, unlimited):if erp_purchased = true ; Type of extended reporting period
erp_effective_date = date:if erp_purchased = true ; Date when extended reporting period begins

; ───────────────────────────────────────────────────────────────────────────────
; Named Insured (Entity)
; ───────────────────────────────────────────────────────────────────────────────
named_insured = @entity.business                  ; Reference to the named insured business entity

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Structure
; ───────────────────────────────────────────────────────────────────────────────
coverage = @do_coverage                           ; Reference to the D&O coverage structure

; ───────────────────────────────────────────────────────────────────────────────
; Entity Extensions
; ───────────────────────────────────────────────────────────────────────────────
entity_extensions = @do_entity_extensions         ; Reference to entity coverage extensions

; ───────────────────────────────────────────────────────────────────────────────
; Insured Persons
; ───────────────────────────────────────────────────────────────────────────────
insured_persons[] = @do_insured_person            ; Array of insured persons (directors and officers)

; ───────────────────────────────────────────────────────────────────────────────
; Subsidiaries
; ───────────────────────────────────────────────────────────────────────────────
subsidiaries[] = @do_subsidiary                   ; Array of covered subsidiaries

; ───────────────────────────────────────────────────────────────────────────────
; Exposures (based on policy type)
; ───────────────────────────────────────────────────────────────────────────────
securities_exposure = @do_securities_exposure:if policy_type = public_company ; Securities exposure for public companies
private_exposure = @do_private_exposure:if policy_type = private_company ; Private company exposure
nonprofit_exposure = @do_nonprofit_exposure:if policy_type = nonprofit ; Nonprofit organization exposure

; ───────────────────────────────────────────────────────────────────────────────
; Excess/Quota Share Position
; ───────────────────────────────────────────────────────────────────────────────
layer_position = (primary, first_excess, excess, quota_share) ; Position of this policy in the coverage tower
underlying_limit = #$:if layer_position != primary ; Aggregate limit of underlying policies
underlying_carrier = ::if layer_position != primary ; Name of underlying insurance carrier
quota_share_percentage = ##:(0..100):if layer_position = quota_share ; Percentage of risk shared in quota share arrangement

; ───────────────────────────────────────────────────────────────────────────────
; Endorsements
; ───────────────────────────────────────────────────────────────────────────────
endorsements[] = @do_endorsement                  ; Array of policy endorsements

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────

{.premium}
base = #$                                         ; Base premium amount before adjustments
side_a = #$                                       ; Premium portion for Side A coverage
side_b = #$                                       ; Premium portion for Side B coverage
side_c = #$                                       ; Premium portion for Side C coverage
entity_extensions = #$                            ; Premium portion for entity coverage extensions
taxes_fees = #$                                   ; Total taxes and fees
total = #$                                        ; Total premium including all components
minimum = #$                                      ; Minimum earned premium

{@do_policy}



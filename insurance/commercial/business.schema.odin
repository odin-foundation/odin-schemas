; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Commercial Business Entity Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Core business entity definition for commercial insurance extending the base
; organization type with business identification, industry classification,
; corporate structure, ownership, financial information, and operations data.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/party.schema.odin" as party
@import "./types.schema.odin" as com

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.business-entity"
version = "1.0.0"
title = "Commercial Business Entity Schema"
description = "Core business entity definition for commercial insurance"

{$derivation}
source[0].authority = "Internal Revenue Service"
source[0].citation = "Publication 583 - Starting a Business and Keeping Records"
source[0].url = "https://www.irs.gov/pub/irs-pdf/p583.pdf"

source[1].authority = "U.S. Securities and Exchange Commission"
source[1].citation = "EDGAR Filing Requirements"
source[1].url = "https://www.sec.gov/edgar/searchedgar/companysearch"

source[2].authority = "U.S. Census Bureau"
source[2].citation = "North American Industry Classification System (NAICS) 2022"
source[2].url = "https://www.census.gov/naics/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Comprehensive business entity data for commercial underwriting"

changelog[0].date = 2025-12-13
changelog[0].change = "Initial business entity schema"
changelog[0].rationale = "Foundation entity for all commercial insurance lines"

; ═══════════════════════════════════════════════════════════════════════════════
; Business Entity
; ═══════════════════════════════════════════════════════════════════════════════

{@business}
= @organization                        ; Inherits from organization
entity_id = :

; ───────────────────────────────────────────────────────────────────────────────
; Extended Legal Identity
; ───────────────────────────────────────────────────────────────────────────────
dba_names[] = :                         ; Additional DBA names (extends org.dba_name)
former_names[] = :                      ; Prior legal names

; Extended Business Structure (overrides org.business_type with more detail)
business_structure = (benefit_corporation, c_corporation, cooperative, county, estate, federal_government, foreign_corporation, general_partnership, joint_venture, limited_liability_partnership, limited_partnership, llc_multi_member, llc_single_member, municipality, nonprofit_501c3, nonprofit_501c4, nonprofit_501c6, nonprofit_other, other, professional_corporation, s_corporation, sole_proprietorship, state_government, tribal_nation, trust)

; ───────────────────────────────────────────────────────────────────────────────
; Tax Identifiers (US and Canada)
; ───────────────────────────────────────────────────────────────────────────────
; US Identifiers
fein = *:format ein                      ; US Federal Employer ID Number (EIN)
fein_date_issued = date
ssn = *:format ssn:if business_structure = sole_proprietorship  ; US SSN for sole props

; Canadian Identifiers
bn = *:/^\d{9}$/                               ; Canadian Business Number (9 digits)
bn_program_accounts[] = :               ; RT (GST/HST), RP (Payroll), RC (Corp Tax), RM (Import/Export)
sin = *:/^\d{3}-\d{3}-\d{3}$/:if business_structure = sole_proprietorship  ; Canadian SIN for sole props

; D-U-N-S Number (Dun & Bradstreet)
duns_number = :(9)
duns_plus_four = :(4)                          ; +4 extension for locations

; SEC Identifiers (publicly traded)
sec_cik = :(10):if publicly_traded = true      ; Central Index Key
sec_ticker = ::if publicly_traded = true
sec_exchange = (AMEX, NASDAQ, NYSE, OTC, foreign):if publicly_traded = true

; ───────────────────────────────────────────────────────────────────────────────
; Formation/Incorporation (US and Canada)
; ───────────────────────────────────────────────────────────────────────────────
state_province_of_formation = :(2)             ; US state or Canadian province
country_of_formation = :(2..3) "US"            ; ISO 3166: "US" or "CA"
formation_date = date
formation_type = (domestic, foreign)

; Secretary of State Registration
sos_entity_number = :
sos_status = (active, dissolved, inactive, revoked, suspended)
sos_status_date = date

; Foreign Qualification (jurisdictions where qualified to do business)
{.foreign_qualifications[]}
state_province = :(2)                         ; US state or Canadian province
country = :(2..3) "US"                        ; ISO 3166: "US" or "CA"
qualification_date = date
entity_number = :
status = (active, withdrawn, revoked)

; Jurisdiction Tax IDs (US state or Canadian provincial)
{.jurisdiction_tax_ids[]}
state_province = :(2)                         ; US state or Canadian province
country = :(2..3) "US"                        ; ISO 3166: "US" or "CA"
tax_id = *:
tax_type = (gst, hst, income, pst, qst, sales, unemployment, withholding)

; ───────────────────────────────────────────────────────────────────────────────
; Industry Classification
; ───────────────────────────────────────────────────────────────────────────────
; NAICS (North American Industry Classification System - 2022)
naics_primary = :(6)                          ; Primary 6-digit NAICS code
naics_primary_description = :

{.naics_secondary[]}
code = :(6)
description = :
percentage = ##:(0..100)     ; % of operations

; SIC (Standard Industrial Classification - legacy, still used by some)
sic_primary = :(4)
sic_primary_description = :

; General Liability Classification
gl_class = :
gl_class_description = :

; Workers Compensation Governing Class
wc_governing_class = :                   ; State class code
wc_governing_class_description = :

; ───────────────────────────────────────────────────────────────────────────────
; Business Description
; ───────────────────────────────────────────────────────────────────────────────
business_description = :             ; Nature of business
operations_description = :             ; Detailed operations
products_description = :               ; Products manufactured/sold
services_description = :               ; Services provided
territory_description = :              ; Geographic scope
website = :

; ───────────────────────────────────────────────────────────────────────────────
; Business History
; ───────────────────────────────────────────────────────────────────────────────
years_in_business = ##:(0..500)
years_current_management = ##:(0..500)
years_current_ownership = ##:(0..500)
predecessor_business = :
predecessor_fein = *:format ein
business_acquired_from = :
acquisition_date = date
acquisition_type = (asset_purchase, merger, stock_purchase)

; ───────────────────────────────────────────────────────────────────────────────
; Size Metrics
; ───────────────────────────────────────────────────────────────────────────────
; Employee Counts
{.employees}
full_time = ##
part_time = ##
seasonal = ##
temporary = ##
leased = ##                        ; PEO/staffing employees
volunteers = ##
contractors_1099 = ##
total = ##

{@business}

; Revenue & Financial
annual_revenue = #$
annual_gross_receipts = #$
annual_payroll = #$
total_assets = #$

; Physical
total_square_footage = ##
location_count = ##:(1..)

; ───────────────────────────────────────────────────────────────────────────────
; Public/Private Status
; ───────────────────────────────────────────────────────────────────────────────
publicly_traded = ?

{.stock_info}
ticker_symbol = ::if publicly_traded = true
exchange = (AMEX, LSE, NASDAQ, NYSE, OTC, other, TSX):if publicly_traded = true
market_cap = #$:if publicly_traded = true
outstanding_shares = ##:if publicly_traded = true

; Private Company Info
{@business}
closely_held = ?:if publicly_traded = false
family_owned = ?:if publicly_traded = false
venture_backed = ?:if publicly_traded = false
private_equity_owned = ?:if publicly_traded = false

; ───────────────────────────────────────────────────────────────────────────────
; Corporate Structure
; ───────────────────────────────────────────────────────────────────────────────
; Parent Company
parent = ?

{.parent}
legal_name = ::if parent = true
fein = *:format ein:if parent = true
ownership_percentage = ##:(0..100):if parent = true
ultimate_parent = ?:if parent = true

{@business}

; Subsidiaries
subsidiaries = ?

; Affiliates
affiliates = ?

; ───────────────────────────────────────────────────────────────────────────────
; Contact Information
; ───────────────────────────────────────────────────────────────────────────────
primary_contact_ref = :                       ; Primary business contact reference
insurance_contact_ref = :                     ; Insurance contact reference

{@business}

; ───────────────────────────────────────────────────────────────────────────────
; Regulatory/Licensing
; ───────────────────────────────────────────────────────────────────────────────
{.licenses[]}
type = :
number = :
state_province = :(2)                         ; US state or Canadian province
country = :(2..3) "US"                        ; ISO 3166: "US" or "CA"
expiration_date = date
status = (active, expired, revoked, suspended)

{.professional_registrations[]}
type = :
number = :
issuing_body = :
expiration_date = date

; Special Regulatory Status
regulated_industry = ?
regulator = ::if regulated_industry = true
franchise = ?
franchisor = ::if franchise = true

; ───────────────────────────────────────────────────────────────────────────────
; Tax Status
; ───────────────────────────────────────────────────────────────────────────────
tax_exempt = ?
tax_exempt_type = ::if tax_exempt = true ; 501(c)(3), etc.
tax_exempt_date = date:if tax_exempt = true

; ═══════════════════════════════════════════════════════════════════════════════
; Officers (Embedded Array)
; ═══════════════════════════════════════════════════════════════════════════════

{@business.officers[]}
= @com.officer

; ═══════════════════════════════════════════════════════════════════════════════
; Shareholders/Owners (Embedded Array)
; ═══════════════════════════════════════════════════════════════════════════════

{@business.shareholders[]}
= @com.shareholder

; ═══════════════════════════════════════════════════════════════════════════════
; Subsidiaries (Embedded Array)
; ═══════════════════════════════════════════════════════════════════════════════

{@business.subsidiaries[]}
= @com.affiliate

; ═══════════════════════════════════════════════════════════════════════════════
; Affiliates (Embedded Array)
; ═══════════════════════════════════════════════════════════════════════════════

{@business.affiliates[]}
= @com.affiliate

; ═══════════════════════════════════════════════════════════════════════════════
; Financial Information (Embedded)
; ═══════════════════════════════════════════════════════════════════════════════

{@business.financials[]}
= @com.financial_info


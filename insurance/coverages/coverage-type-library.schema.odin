; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Coverage Type Library
; ═══════════════════════════════════════════════════════════════════════════════
; Seed definitions for common coverage types across all lines providing canonical
; codes that coverage instances reference for interoperability.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./coverage-type.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.coverages.coverage-type-library"
version = "1.0.0"
title = "Coverage Type Library"
description = "Seed definitions for common coverage types"

{$derivation}
source[0].authority = "U.S. Department of Labor"
source[0].citation = "Employee Benefits Security Administration"
source[0].url = "https://www.dol.gov/agencies/ebsa"

source[1].authority = "State Insurance Departments"
source[1].citation = "Various state insurance regulations and statutes"
source[1].url = "https://content.naic.org/state-insurance-departments"

source[2].authority = "Financial Services Regulatory Authority of Ontario (FSRA)"
source[2].citation = "Statutory Accident Benefits Schedule (SABS)"
source[2].url = "https://www.ontario.ca/laws/regulation/100034"

source[3].authority = "Insurance Corporation of British Columbia (ICBC)"
source[3].citation = "Basic and Optional Autoplan Coverage"
source[3].url = "https://www.icbc.com/"

source[4].authority = "Association of Workers' Compensation Boards of Canada (AWCBC)"
source[4].citation = "Workers' Compensation in Canada"
source[4].url = "https://awcbc.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Seed coverage type library for all lines of business - US and Canada"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial coverage type library"
changelog[0].rationale = "Provides canonical codes for coverage_type_ref references"

; ═══════════════════════════════════════════════════════════════════════════════
; AUTO COVERAGE TYPES
; ═══════════════════════════════════════════════════════════════════════════════

{@coverage_type}
code = "BI"
name = "Bodily Injury Liability"
description = "Covers bodily injury or death to others caused by the insured's negligent operation of a covered vehicle"
line_of_business = "auto"
category = "liability"

{@coverage_type}
code = "PD"
name = "Property Damage Liability"
description = "Covers damage to property of others caused by the insured's negligent operation of a covered vehicle"
line_of_business = "auto"
category = "liability"

{@coverage_type}
code = "CSL"
name = "Combined Single Limit"
description = "Single limit covering both bodily injury and property damage liability combined"
line_of_business = "auto"
category = "liability"

{@coverage_type}
code = "COLL"
name = "Collision"
description = "Covers damage to insured vehicle from collision with another object or vehicle"
line_of_business = "auto"
category = "physical_damage"

{@coverage_type}
code = "COMP"
name = "Comprehensive"
description = "Covers damage to insured vehicle from non-collision perils (theft, fire, hail, vandalism, etc.)"
line_of_business = "auto"
category = "physical_damage"

{@coverage_type}
code = "UM"
name = "Uninsured Motorist Bodily Injury"
description = "Covers bodily injury to insured caused by uninsured or hit-and-run driver"
line_of_business = "auto"
category = "liability"

{@coverage_type}
code = "UIM"
name = "Underinsured Motorist Bodily Injury"
description = "Covers bodily injury to insured when at-fault driver has insufficient liability limits"
line_of_business = "auto"
category = "liability"

{@coverage_type}
code = "UMPD"
name = "Uninsured Motorist Property Damage"
description = "Covers property damage caused by uninsured driver"
line_of_business = "auto"
category = "physical_damage"

{@coverage_type}
code = "PIP"
name = "Personal Injury Protection"
description = "No-fault coverage for medical expenses, lost wages, and other expenses regardless of fault"
line_of_business = "auto"
category = "no_fault"

{@coverage_type}
code = "MEDPAY"
name = "Medical Payments"
description = "Covers medical expenses for insured and passengers regardless of fault"
line_of_business = "auto"
category = "medical"

{@coverage_type}
code = "RENTAL"
name = "Rental Reimbursement"
description = "Covers cost of rental vehicle while insured vehicle is being repaired"
line_of_business = "auto"
category = "supplemental"

{@coverage_type}
code = "TOWING"
name = "Towing and Labor"
description = "Covers towing and roadside labor costs"
line_of_business = "auto"
category = "supplemental"

{@coverage_type}
code = "GAP"
name = "Gap Coverage"
description = "Covers difference between vehicle value and loan balance if vehicle is totaled"
line_of_business = "auto"
category = "supplemental"

; ═══════════════════════════════════════════════════════════════════════════════
; GENERAL LIABILITY COVERAGE TYPES
; ═══════════════════════════════════════════════════════════════════════════════

{@coverage_type}
code = "CGL"
name = "Commercial General Liability"
description = "Comprehensive liability coverage for business operations, premises, and products"
line_of_business = "general_liability"
category = "liability"
form_type = "occurrence"

{@coverage_type}
code = "CGL_CM"
name = "Commercial General Liability - Claims Made"
description = "CGL coverage on claims-made basis"
line_of_business = "general_liability"
category = "liability"
form_type = "claims_made"

{@coverage_type}
code = "PREM_OPS"
name = "Premises and Operations"
description = "Liability arising from business premises and ongoing operations"
line_of_business = "general_liability"
category = "liability"

{@coverage_type}
code = "PROD_CO"
name = "Products/Completed Operations"
description = "Liability arising from products sold or work completed"
line_of_business = "general_liability"
category = "liability"

{@coverage_type}
code = "PERS_ADV"
name = "Personal and Advertising Injury"
description = "Coverage for libel, slander, false arrest, and advertising injury"
line_of_business = "general_liability"
category = "liability"

{@coverage_type}
code = "DAM_PREM"
name = "Damage to Premises Rented to You"
description = "Coverage for damage to premises rented by the insured"
line_of_business = "general_liability"
category = "liability"

{@coverage_type}
code = "MED_EXP"
name = "Medical Expenses"
description = "Medical payments for injuries on insured's premises regardless of fault"
line_of_business = "general_liability"
category = "medical"

; ═══════════════════════════════════════════════════════════════════════════════
; WORKERS COMPENSATION COVERAGE TYPES
; ═══════════════════════════════════════════════════════════════════════════════

{@coverage_type}
code = "WC_STAT"
name = "Workers Compensation - Statutory"
description = "Part One - Statutory workers compensation benefits as required by state law"
line_of_business = "workers_compensation"
category = "statutory"

{@coverage_type}
code = "WC_EL"
name = "Employers Liability"
description = "Part Two - Employers liability for work-related injuries not covered by statutory WC"
line_of_business = "workers_compensation"
category = "liability"

{@coverage_type}
code = "WC_OS"
name = "Other States Coverage"
description = "Part Three - Coverage for operations in states not listed in declarations"
line_of_business = "workers_compensation"
category = "statutory"

; ═══════════════════════════════════════════════════════════════════════════════
; PROPERTY COVERAGE TYPES
; ═══════════════════════════════════════════════════════════════════════════════

{@coverage_type}
code = "BLDG"
name = "Building"
description = "Coverage for the insured building structure"
line_of_business = "property"
category = "first_party"

{@coverage_type}
code = "BPP"
name = "Business Personal Property"
description = "Coverage for business personal property and contents"
line_of_business = "property"
category = "first_party"

{@coverage_type}
code = "BI_PROP"
name = "Business Income"
description = "Coverage for lost income due to covered property damage"
line_of_business = "property"
category = "first_party"

{@coverage_type}
code = "EE"
name = "Extra Expense"
description = "Coverage for extra expenses to continue operations after covered loss"
line_of_business = "property"
category = "first_party"

{@coverage_type}
code = "IMP_BET"
name = "Tenant Improvements and Betterments"
description = "Coverage for tenant improvements to leased space"
line_of_business = "property"
category = "first_party"

{@coverage_type}
code = "EQ"
name = "Equipment Breakdown"
description = "Coverage for mechanical and electrical equipment breakdown"
line_of_business = "property"
category = "first_party"

; ═══════════════════════════════════════════════════════════════════════════════
; PROFESSIONAL LIABILITY COVERAGE TYPES
; ═══════════════════════════════════════════════════════════════════════════════

{@coverage_type}
code = "PL_EO"
name = "Professional Liability - Errors and Omissions"
description = "Coverage for professional negligence, errors, and omissions"
line_of_business = "professional_liability"
category = "liability"
form_type = "claims_made"

{@coverage_type}
code = "PL_MPL"
name = "Medical Professional Liability"
description = "Coverage for medical malpractice"
line_of_business = "professional_liability"
category = "liability"
form_type = "claims_made"

{@coverage_type}
code = "DO"
name = "Directors and Officers Liability"
description = "Coverage for directors and officers for wrongful acts in their capacity"
line_of_business = "professional_liability"
category = "liability"
form_type = "claims_made"

{@coverage_type}
code = "EPL"
name = "Employment Practices Liability"
description = "Coverage for employment-related claims (harassment, discrimination, wrongful termination)"
line_of_business = "professional_liability"
category = "liability"
form_type = "claims_made"

{@coverage_type}
code = "FID"
name = "Fiduciary Liability"
description = "Coverage for fiduciary breaches in employee benefit plan administration"
line_of_business = "professional_liability"
category = "liability"
form_type = "claims_made"

; ═══════════════════════════════════════════════════════════════════════════════
; CYBER LIABILITY COVERAGE TYPES
; ═══════════════════════════════════════════════════════════════════════════════

{@coverage_type}
code = "CYBER"
name = "Cyber Liability"
description = "Comprehensive cyber risk coverage including breach response, liability, and business interruption"
line_of_business = "cyber"
category = "liability"
form_type = "claims_made"

{@coverage_type}
code = "CYBER_1P"
name = "Cyber First Party"
description = "First party cyber coverage for breach response, data restoration, business interruption"
line_of_business = "cyber"
category = "first_party"

{@coverage_type}
code = "CYBER_3P"
name = "Cyber Third Party Liability"
description = "Third party liability for privacy breaches and network security failures"
line_of_business = "cyber"
category = "liability"
form_type = "claims_made"

; ═══════════════════════════════════════════════════════════════════════════════
; UMBRELLA/EXCESS COVERAGE TYPES
; ═══════════════════════════════════════════════════════════════════════════════

{@coverage_type}
code = "UMB"
name = "Umbrella Liability"
description = "Broad excess coverage that may also provide primary coverage for gaps"
line_of_business = "umbrella_excess"
category = "liability"
form_type = "occurrence"

{@coverage_type}
code = "EXCESS"
name = "Excess Liability"
description = "Excess coverage following form of underlying policies"
line_of_business = "umbrella_excess"
category = "liability"

{@coverage_type}
code = "EXCESS_FF"
name = "Excess Liability - Follow Form"
description = "Excess coverage that follows the terms of underlying coverage"
line_of_business = "umbrella_excess"
category = "liability"

; ═══════════════════════════════════════════════════════════════════════════════
; CANADIAN AUTO COVERAGE TYPES
; ═══════════════════════════════════════════════════════════════════════════════

; ───────────────────────────────────────────────────────────────────────────────
; Ontario Auto Coverage Types (SABS O. Reg. 34/10)
; ───────────────────────────────────────────────────────────────────────────────

{@coverage_type}
code = "ON_SABS"
name = "Ontario Statutory Accident Benefits"
description = "No-fault accident benefits under Ontario SABS O. Reg. 34/10 including medical, rehabilitation, attendant care, and income replacement"
line_of_business = "auto"
category = "accident_benefits"
jurisdiction = "ON"

{@coverage_type}
code = "ON_MR"
name = "Ontario Medical and Rehabilitation"
description = "SABS medical, rehabilitation, and attendant care benefits"
line_of_business = "auto"
category = "accident_benefits"
jurisdiction = "ON"

{@coverage_type}
code = "ON_IR"
name = "Ontario Income Replacement"
description = "SABS income replacement benefits (70% of gross income)"
line_of_business = "auto"
category = "accident_benefits"
jurisdiction = "ON"

{@coverage_type}
code = "ON_CD"
name = "Ontario Caregiver and Dependant"
description = "SABS caregiver, housekeeping, and dependant care benefits"
line_of_business = "auto"
category = "accident_benefits"
jurisdiction = "ON"

{@coverage_type}
code = "ON_DEATH"
name = "Ontario Death and Funeral Benefits"
description = "SABS death benefits and funeral expense coverage"
line_of_business = "auto"
category = "accident_benefits"
jurisdiction = "ON"

{@coverage_type}
code = "ON_OPCF"
name = "Ontario Policy Change Forms"
description = "Optional OPCF endorsements for enhanced coverage"
line_of_business = "auto"
category = "endorsement"
jurisdiction = "ON"

; ───────────────────────────────────────────────────────────────────────────────
; Direct Compensation Property Damage (ON, NB, NS, PE)
; ───────────────────────────────────────────────────────────────────────────────

{@coverage_type}
code = "DCPD"
name = "Direct Compensation - Property Damage"
description = "No-fault property damage coverage - insurer pays own insured's damage based on fault determination rules"
line_of_business = "auto"
category = "physical_damage"
jurisdiction = "ON,NB,NS,PE"

; ───────────────────────────────────────────────────────────────────────────────
; Quebec Auto Coverage Types (SAAQ Public System + Private)
; ───────────────────────────────────────────────────────────────────────────────

{@coverage_type}
code = "QC_SAAQ"
name = "Quebec SAAQ Public Coverage"
description = "Public automobile insurance from Société de l'assurance automobile du Québec covering bodily injury regardless of fault"
line_of_business = "auto"
category = "accident_benefits"
jurisdiction = "QC"

{@coverage_type}
code = "QC_PRIV"
name = "Quebec Private Auto Coverage"
description = "Private insurance for property damage and civil liability (public roads) in Quebec's dual system"
line_of_business = "auto"
category = "liability"
jurisdiction = "QC"

{@coverage_type}
code = "QC_Q_FORMS"
name = "Quebec Q.P.F. Endorsements"
description = "Quebec Policy Forms for optional coverage endorsements"
line_of_business = "auto"
category = "endorsement"
jurisdiction = "QC"

; ───────────────────────────────────────────────────────────────────────────────
; British Columbia Auto Coverage Types (ICBC)
; ───────────────────────────────────────────────────────────────────────────────

{@coverage_type}
code = "BC_ICBC_BASIC"
name = "ICBC Basic Autoplan"
description = "Mandatory basic auto insurance from Insurance Corporation of British Columbia"
line_of_business = "auto"
category = "liability"
jurisdiction = "BC"

{@coverage_type}
code = "BC_ICBC_ENHANCED"
name = "ICBC Enhanced Care"
description = "Enhanced accident benefits under BC's Enhanced Care model (2021+)"
line_of_business = "auto"
category = "accident_benefits"
jurisdiction = "BC"

{@coverage_type}
code = "BC_ICBC_OPT"
name = "ICBC Optional Coverage"
description = "Optional ICBC coverage including collision, comprehensive, and extended third party"
line_of_business = "auto"
category = "physical_damage"
jurisdiction = "BC"

; ───────────────────────────────────────────────────────────────────────────────
; Manitoba Auto Coverage Types (MPI)
; ───────────────────────────────────────────────────────────────────────────────

{@coverage_type}
code = "MB_MPI_BASIC"
name = "Manitoba Basic Autopac"
description = "Mandatory basic auto insurance from Manitoba Public Insurance"
line_of_business = "auto"
category = "liability"
jurisdiction = "MB"

{@coverage_type}
code = "MB_MPI_EXT"
name = "Manitoba Extension Coverage"
description = "Optional MPI Extension coverage for enhanced limits and deductibles"
line_of_business = "auto"
category = "physical_damage"
jurisdiction = "MB"

{@coverage_type}
code = "MB_PIPP"
name = "Manitoba PIPP Benefits"
description = "Personal Injury Protection Plan no-fault benefits under MPI"
line_of_business = "auto"
category = "accident_benefits"
jurisdiction = "MB"

; ───────────────────────────────────────────────────────────────────────────────
; Saskatchewan Auto Coverage Types (SGI)
; ───────────────────────────────────────────────────────────────────────────────

{@coverage_type}
code = "SK_SGI_BASIC"
name = "Saskatchewan Basic Auto Fund"
description = "Mandatory basic auto insurance from Saskatchewan Government Insurance"
line_of_business = "auto"
category = "liability"
jurisdiction = "SK"

{@coverage_type}
code = "SK_SGI_EXT"
name = "Saskatchewan Extension Coverage"
description = "Optional SGI Extension coverage packages"
line_of_business = "auto"
category = "physical_damage"
jurisdiction = "SK"

{@coverage_type}
code = "SK_PIPP"
name = "Saskatchewan PIPP Benefits"
description = "Personal Injury Protection Plan no-fault benefits under SGI"
line_of_business = "auto"
category = "accident_benefits"
jurisdiction = "SK"

; ───────────────────────────────────────────────────────────────────────────────
; Alberta Auto Coverage Types
; ───────────────────────────────────────────────────────────────────────────────

{@coverage_type}
code = "AB_SEF"
name = "Alberta SEF Endorsements"
description = "Standard Endorsement Forms for Alberta auto policies"
line_of_business = "auto"
category = "endorsement"
jurisdiction = "AB"

{@coverage_type}
code = "AB_DCPD"
name = "Alberta DCPD"
description = "Alberta Direct Compensation for Property Damage (effective 2022)"
line_of_business = "auto"
category = "physical_damage"
jurisdiction = "AB"

; ───────────────────────────────────────────────────────────────────────────────
; Atlantic Canada Auto Coverage Types (NB, NS, PE, NL)
; ───────────────────────────────────────────────────────────────────────────────

{@coverage_type}
code = "ATL_SEF"
name = "Atlantic SEF Endorsements"
description = "Standard Endorsement Forms for Atlantic province auto policies"
line_of_business = "auto"
category = "endorsement"
jurisdiction = "NB,NS,PE,NL"

{@coverage_type}
code = "NL_AUTO"
name = "Newfoundland Auto Coverage"
description = "Newfoundland and Labrador private auto insurance coverage"
line_of_business = "auto"
category = "liability"
jurisdiction = "NL"

; ═══════════════════════════════════════════════════════════════════════════════
; CANADIAN WORKERS' COMPENSATION COVERAGE TYPES
; ═══════════════════════════════════════════════════════════════════════════════

; ───────────────────────────────────────────────────────────────────────────────
; General Canadian WCB Coverage
; ───────────────────────────────────────────────────────────────────────────────

{@coverage_type}
code = "CA_WCB"
name = "Canadian Workers' Compensation"
description = "Provincial workers' compensation board coverage for workplace injuries"
line_of_business = "workers_compensation"
category = "statutory"
jurisdiction = "CA"

{@coverage_type}
code = "CA_EL"
name = "Canadian Employers Liability"
description = "Employers liability coverage for workers not covered by WCB (domestic, farm workers in some provinces)"
line_of_business = "workers_compensation"
category = "liability"
jurisdiction = "CA"

; ───────────────────────────────────────────────────────────────────────────────
; Ontario WSIB
; ───────────────────────────────────────────────────────────────────────────────

{@coverage_type}
code = "ON_WSIB"
name = "Ontario WSIB Coverage"
description = "Workplace Safety and Insurance Board coverage for Ontario workplace injuries"
line_of_business = "workers_compensation"
category = "statutory"
jurisdiction = "ON"

{@coverage_type}
code = "ON_WSIB_OPT"
name = "Ontario WSIB Optional Coverage"
description = "WSIB optional insurance for independent operators, partners, and executive officers"
line_of_business = "workers_compensation"
category = "statutory"
jurisdiction = "ON"

; ───────────────────────────────────────────────────────────────────────────────
; British Columbia WorkSafeBC
; ───────────────────────────────────────────────────────────────────────────────

{@coverage_type}
code = "BC_WSBC"
name = "WorkSafeBC Coverage"
description = "WorkSafeBC coverage for British Columbia workplace injuries"
line_of_business = "workers_compensation"
category = "statutory"
jurisdiction = "BC"

{@coverage_type}
code = "BC_POP"
name = "BC Personal Optional Protection"
description = "WorkSafeBC POP coverage for proprietors, partners, and principals"
line_of_business = "workers_compensation"
category = "statutory"
jurisdiction = "BC"

; ───────────────────────────────────────────────────────────────────────────────
; Quebec CNESST
; ───────────────────────────────────────────────────────────────────────────────

{@coverage_type}
code = "QC_CNESST"
name = "Quebec CNESST Coverage"
description = "Commission des normes, de l'équité, de la santé et de la sécurité du travail coverage"
line_of_business = "workers_compensation"
category = "statutory"
jurisdiction = "QC"

; ───────────────────────────────────────────────────────────────────────────────
; Alberta WCB
; ───────────────────────────────────────────────────────────────────────────────

{@coverage_type}
code = "AB_WCB"
name = "Alberta WCB Coverage"
description = "Workers' Compensation Board - Alberta coverage for workplace injuries"
line_of_business = "workers_compensation"
category = "statutory"
jurisdiction = "AB"

{@coverage_type}
code = "AB_WCB_OPT"
name = "Alberta WCB Optional Coverage"
description = "WCB-Alberta optional coverage for partners, proprietors, and directors"
line_of_business = "workers_compensation"
category = "statutory"
jurisdiction = "AB"

; ───────────────────────────────────────────────────────────────────────────────
; Other Provincial WCB Boards
; ───────────────────────────────────────────────────────────────────────────────

{@coverage_type}
code = "MB_WCB"
name = "Manitoba WCB Coverage"
description = "Workers Compensation Board of Manitoba coverage"
line_of_business = "workers_compensation"
category = "statutory"
jurisdiction = "MB"

{@coverage_type}
code = "SK_WCB"
name = "Saskatchewan WCB Coverage"
description = "Saskatchewan Workers' Compensation Board coverage"
line_of_business = "workers_compensation"
category = "statutory"
jurisdiction = "SK"

{@coverage_type}
code = "NB_WSNB"
name = "WorkSafeNB Coverage"
description = "WorkSafeNB coverage for New Brunswick workplace injuries"
line_of_business = "workers_compensation"
category = "statutory"
jurisdiction = "NB"

{@coverage_type}
code = "NS_WCB"
name = "Nova Scotia WCB Coverage"
description = "Workers' Compensation Board of Nova Scotia coverage"
line_of_business = "workers_compensation"
category = "statutory"
jurisdiction = "NS"

{@coverage_type}
code = "PE_WCB"
name = "PEI WCB Coverage"
description = "Workers Compensation Board of PEI coverage"
line_of_business = "workers_compensation"
category = "statutory"
jurisdiction = "PE"

{@coverage_type}
code = "NL_WHSCC"
name = "Newfoundland WHSCC Coverage"
description = "Workplace Health, Safety and Compensation Commission of NL coverage"
line_of_business = "workers_compensation"
category = "statutory"
jurisdiction = "NL"

; ───────────────────────────────────────────────────────────────────────────────
; Cross-Border Coverage
; ───────────────────────────────────────────────────────────────────────────────

{@coverage_type}
code = "CROSS_BORDER_WC"
name = "Cross-Border Workers Compensation"
description = "Coverage for employees working across US-Canada border requiring coordination of WC/WCB"
line_of_business = "workers_compensation"
category = "statutory"
jurisdiction = "US,CA"

; ═══════════════════════════════════════════════════════════════════════════════
; HOMEOWNERS/RENTERS COVERAGE TYPES
; ═══════════════════════════════════════════════════════════════════════════════

{@coverage_type}
code = "HO_A"
name = "Dwelling Coverage (Coverage A)"
description = "Coverage for the dwelling structure on the residence premises"
line_of_business = "homeowners"
category = "first_party"

{@coverage_type}
code = "HO_B"
name = "Other Structures Coverage (Coverage B)"
description = "Coverage for structures detached from the dwelling (garages, sheds, fences)"
line_of_business = "homeowners"
category = "first_party"

{@coverage_type}
code = "HO_C"
name = "Personal Property Coverage (Coverage C)"
description = "Coverage for personal property owned or used by insureds"
line_of_business = "homeowners"
category = "first_party"

{@coverage_type}
code = "HO_D"
name = "Loss of Use Coverage (Coverage D)"
description = "Additional living expenses when dwelling is uninhabitable due to covered loss"
line_of_business = "homeowners"
category = "first_party"

{@coverage_type}
code = "HO_E"
name = "Personal Liability Coverage (Coverage E)"
description = "Personal liability for bodily injury or property damage to others"
line_of_business = "homeowners"
category = "liability"

{@coverage_type}
code = "HO_F"
name = "Medical Payments Coverage (Coverage F)"
description = "Medical payments to others injured on insured premises regardless of fault"
line_of_business = "homeowners"
category = "medical"

{@coverage_type}
code = "HO4_C"
name = "Renters Personal Property (HO-4 Coverage C)"
description = "Personal property coverage for tenants - primary coverage for renters insurance"
line_of_business = "renters"
category = "first_party"

{@coverage_type}
code = "HO4_D"
name = "Renters Loss of Use (HO-4 Coverage D)"
description = "Additional living expenses for renters when unit is uninhabitable"
line_of_business = "renters"
category = "first_party"

{@coverage_type}
code = "HO4_E"
name = "Renters Liability (HO-4 Coverage E)"
description = "Personal liability coverage for renters"
line_of_business = "renters"
category = "liability"

{@coverage_type}
code = "HO4_F"
name = "Renters Medical Payments (HO-4 Coverage F)"
description = "Medical payments to others for renters policies"
line_of_business = "renters"
category = "medical"

{@coverage_type}
code = "DP_A"
name = "Dwelling Fire Coverage A"
description = "Dwelling coverage under dwelling fire policy (DP-1, DP-2, DP-3)"
line_of_business = "dwelling"
category = "first_party"

{@coverage_type}
code = "DP_B"
name = "Dwelling Fire Other Structures"
description = "Other structures coverage under dwelling fire policy"
line_of_business = "dwelling"
category = "first_party"

{@coverage_type}
code = "DP_C"
name = "Dwelling Fire Personal Property"
description = "Personal property coverage under dwelling fire policy"
line_of_business = "dwelling"
category = "first_party"

{@coverage_type}
code = "DP_D"
name = "Dwelling Fire Fair Rental Value"
description = "Fair rental value/loss of rents coverage for landlords"
line_of_business = "dwelling"
category = "first_party"


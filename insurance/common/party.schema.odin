; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Insurance Party Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Parties involved in insurance transactions including named insureds, additional
; insureds, beneficiaries, lienholders, and other interested parties.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.common.party"
version = "1.0.0"
title = "Insurance Party Schema"
description = "Person and organization definitions for insurance"

{$derivation}
methodology = "industry_practice"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-13
changelog[0].change = "Initial party schema"
changelog[0].rationale = "Standard insurance party structures"

; ===============================================================================
; PERSON (INDIVIDUAL)
; ===============================================================================
; Uses common types: @address, @phone, @email

{@person}
; -------------------------------------------------------------------------------
; Core Identification
; -------------------------------------------------------------------------------
party_type = "person"                         ; Party type discriminator
party_id = :                                  ; Unique party identifier

; -------------------------------------------------------------------------------
; Name Components
; -------------------------------------------------------------------------------
{.name}
full = :                                      ; Full name as single string
first = :                                     ; First/given name
last = :                                      ; Last/family name
middle = :                                    ; Middle name or initial
prefix = :                                    ; Title prefix
suffix = :                                    ; Name suffix

; -------------------------------------------------------------------------------
; Government Identifiers (Confidential PII)
; -------------------------------------------------------------------------------
{@person}
sin = *:/^\d{3}-\d{3}-\d{3}$/                 ; Canadian Social Insurance Number
ssn = *:format ssn                            ; US Social Security Number
tax_id = *:                                   ; EIN, BN, or SSN/SIN without dashes

{.license}
expiration = date                             ; License expiration date
number = *:                                   ; Driver license number
state_province = :(2)                         ; US state or CA province code (ISO 3166-2)

; -------------------------------------------------------------------------------
; Demographics (Confidential PII)
; -------------------------------------------------------------------------------
{@person}
date_of_birth = *date                         ; Birth date (confidential PII)
gender = (female, male, non_binary)
marital_status = (common_law, divorced, domestic_partner, married, single, widowed)

; -------------------------------------------------------------------------------
; Language Preferences
; -------------------------------------------------------------------------------
languages_spoken[] = :(2..5)                  ; Additional languages spoken (ISO 639)
primary_language = :(2..5)                    ; Preferred language (ISO 639: en, fr, es, zh, etc.)

; -------------------------------------------------------------------------------
; Contact Information (Confidential TCPA/GDPR)
; -------------------------------------------------------------------------------
address = @address                            ; Primary physical address
email = *@email                               ; Email address
mailing_address = @address                    ; Mailing address if different
phones[] = *@phone                            ; Phone numbers
preferred_contact = (email, mail, phone)      ; Preferred contact method
role = :                                      ; Business role or title

; -------------------------------------------------------------------------------
; Employment Information
; -------------------------------------------------------------------------------
{.employment}
employer = :                                  ; Employer company name
industry_code = :(3)                          ; Industry classification code
months = ##                                   ; Months at current employer
occupation = :                                ; Job title or occupation
status = (employed, homemaker, military, retired, self_employed, student, unemployed)

; -------------------------------------------------------------------------------
; Residence Information
; -------------------------------------------------------------------------------
{.residence}
months = ##                                   ; Months at current residence
ownership = (lease, live_with_family, other, own, rent)  ; Occupancy type
type = (apartment, condo, house, mobile_home, other, townhouse)  ; Dwelling type

; ===============================================================================
; ORGANIZATION (COMPANY, TRUST, ETC.)
; ===============================================================================
; Uses common types: @address, @phone, @email

{@organization}
; -------------------------------------------------------------------------------
; Core Identification
; -------------------------------------------------------------------------------
party_type = "organization"                   ; Party type discriminator
party_id = :                                  ; Unique party identifier

; -------------------------------------------------------------------------------
; Legal Identity
; -------------------------------------------------------------------------------
legal_name = :                               ; Legal company name
business_type = (corporation, estate, government, llc, nonprofit, partnership, sole_prop, trust)
dba_name = :                                  ; Doing Business As name
naic_code = :(5..6)                           ; NAIC company code
tax_id = *:                                   ; EIN (US), BN (CA), or other tax identifier

; -------------------------------------------------------------------------------
; Formation Information
; -------------------------------------------------------------------------------
country_of_formation = :(2..3) "US"           ; ISO 3166 country code
date_formed = date                            ; Date of incorporation or formation
state_province_of_formation = :(2)            ; US state or CA province of formation

; -------------------------------------------------------------------------------
; Language Preferences
; -------------------------------------------------------------------------------
primary_language = :(2..5)                    ; Preferred language for communications

; -------------------------------------------------------------------------------
; Contact Information (Confidential TCPA/GDPR)
; -------------------------------------------------------------------------------
address = @address                            ; Primary physical address
email = *@email                               ; Primary email address
mailing_address = @address                    ; Mailing address if different
phones[] = *@phone                            ; Phone numbers
website = :                                   ; Company website URL

; ═══════════════════════════════════════════════════════════════════════════════
; NAMED INSURED (PRIMARY POLICYHOLDER)
; ═══════════════════════════════════════════════════════════════════════════════
; Inherits from @person or @organization via polymorphic reference. Use this type
; when the insured can be either person or organization.

{@named_insured}
; ───────────────────────────────────────────────────────────────────────────────
; Required Fields
; ───────────────────────────────────────────────────────────────────────────────
insured_type = (additional, primary, secondary)  ; Insured classification
party_ref = @person|@organization            ; Reference to person or organization

; ───────────────────────────────────────────────────────────────────────────────
; Addresses
; ───────────────────────────────────────────────────────────────────────────────
address = @address                            ; Current address
prior_address = @address                      ; Prior address for underwriting

; ───────────────────────────────────────────────────────────────────────────────
; Contact Preferences
; ───────────────────────────────────────────────────────────────────────────────
email_declined = ?                            ; Customer declined to provide email
preferred_contact = (email, mail, phone)      ; Preferred contact method

; ═══════════════════════════════════════════════════════════════════════════════
; ADDITIONAL INSURED
; ═══════════════════════════════════════════════════════════════════════════════
; Additional parties with insurable interest in the policy.

{@additional_insured}
; ───────────────────────────────────────────────────────────────────────────────
; Required Fields
; ───────────────────────────────────────────────────────────────────────────────
interest_type = (additional_insured, certificate_holder, lessor, loss_payee, mortgagee)
party_ref = @person|@organization            ; Reference to person or organization

; ───────────────────────────────────────────────────────────────────────────────
; Relationship
; ───────────────────────────────────────────────────────────────────────────────
relationship = :                              ; Relationship to named insured

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Application
; ───────────────────────────────────────────────────────────────────────────────
applies_to_all = ?                            ; Coverage applies to all items
specific_items = :                            ; Comma-separated item references if not applies_to_all

; ═══════════════════════════════════════════════════════════════════════════════
; LIENHOLDER (VEHICLE/PROPERTY)
; ═══════════════════════════════════════════════════════════════════════════════
; Financial institution with secured interest in financed vehicle or property.

{@lienholder}
; ───────────────────────────────────────────────────────────────────────────────
; Required Fields
; ───────────────────────────────────────────────────────────────────────────────
name = :                                     ; Lienholder company name

; ───────────────────────────────────────────────────────────────────────────────
; Classification
; ───────────────────────────────────────────────────────────────────────────────
type = (lease, lien, loan, loss_payee, mortgagee) ; Type of lien (alphabetical)

; ───────────────────────────────────────────────────────────────────────────────
; Identifiers
; ───────────────────────────────────────────────────────────────────────────────
id = :                                        ; Unique lienholder identifier
account_number = *:                           ; Customer account number (confidential)

; ───────────────────────────────────────────────────────────────────────────────
; Loan Details
; ───────────────────────────────────────────────────────────────────────────────
loan_amount = #$:(0..)
loan_date = date

; ───────────────────────────────────────────────────────────────────────────────
; Contact Information (Confidential TCPA/GDPR)
; ───────────────────────────────────────────────────────────────────────────────
address = @address                            ; Lienholder mailing address
phones[] = *@phone                            ; Phone numbers

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Requirements
; ───────────────────────────────────────────────────────────────────────────────
coll_required = ?                             ; Collision coverage required
comp_required = ?                             ; Comprehensive coverage required
min_coll_ded = ##                             ; Minimum collision deductible
min_comp_ded = ##                             ; Minimum comprehensive deductible

; ═══════════════════════════════════════════════════════════════════════════════
; MORTGAGEE (PROPERTY)
; ═══════════════════════════════════════════════════════════════════════════════
; Mortgage lender with secured interest in mortgaged property.

{@mortgagee}
; ───────────────────────────────────────────────────────────────────────────────
; Required Fields
; ───────────────────────────────────────────────────────────────────────────────
name = :                                     ; Mortgagee company name
type = (first, second, third)                ; Mortgage priority position

; ───────────────────────────────────────────────────────────────────────────────
; Identifiers
; ───────────────────────────────────────────────────────────────────────────────
id = :                                        ; Unique mortgagee identifier
loan_number = *:                              ; Loan or mortgage number

; ───────────────────────────────────────────────────────────────────────────────
; Contact Information
; ───────────────────────────────────────────────────────────────────────────────
address = @address                            ; Mortgagee mailing address

; ───────────────────────────────────────────────────────────────────────────────
; Account Details
; ───────────────────────────────────────────────────────────────────────────────
escrow_account = ?                            ; Property taxes or insurance escrowed

; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Indian Health Service (IHS) Schema
; ═══════════════════════════════════════════════════════════════════════════════
; IHS health care system structures covering beneficiary eligibility, facilities,
; and purchased/referred care. Derived from 25 USC Chapter 18 (IHCIA) and
; 42 CFR Part 136.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.federal.ihs"
version = "1.0.0"
title = "Indian Health Service Schema"
description = "IHS health care system structures"

{$derivation}
source[0].authority = "GPO"
source[0].citation = "25 USC Chapter 18 - Indian Health Care"
source[0].url = "https://www.law.cornell.edu/uscode/text/25/chapter-18"

source[1].authority = "GPO"
source[1].citation = "42 CFR Part 136 - Indian Health"
source[1].url = "https://www.ecfr.gov/current/title-42/chapter-I/subchapter-M/part-136"

source[2].authority = "IHS"
source[2].citation = "IHS Manual"
source[2].url = "https://www.ihs.gov/ihm/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial IHS schema"
changelog[0].rationale = "Structure derived from 25 USC Chapter 18 and 42 CFR Part 136"

; ═══════════════════════════════════════════════════════════════════════════════
; BENEFICIARY
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 136.12

{@beneficiary}
beneficiary_id = !:                         ; IHS beneficiary ID

; Demographics
{.demographics}
first_name = !:                             ; First name
middle_name = :                             ; Middle name
last_name = !:                              ; Last name
dob = !*date                                ; Date of birth
gender = (female, male)                     ; Gender
ssn = *:                                    ; SSN

{@beneficiary}

; Tribal affiliation - Per 42 CFR 136.12
{.tribal}
tribe_name = :                              ; Primary tribe name
tribe_code = :                              ; Tribal code
enrollment_number = :                       ; Tribal enrollment number
tribal_member = ?                           ; Enrolled tribal member
descendant = ?                              ; Descendant of tribal member
lineal_descendant = ?                       ; Lineal descendant

{@beneficiary}

; Additional affiliations
additional_tribes[] = @tribal_affiliation   ; Additional tribal affiliations

; Eligibility - Per 42 CFR 136.12
{.eligibility}
eligible = ?                                ; IHS eligible
eligibility_basis = !(community_member, descendant, other_eligible, tribal_member)
eligibility_date = date                     ; Eligibility date
verification_status = (pending, unverified, verified)

{@beneficiary}

{@tribal_affiliation}
tribe_name = :                              ; Tribe name
tribe_code = :                              ; Tribal code
enrollment_number = :                       ; Enrollment number if any
relationship = :                            ; Relationship (member, descendant)

; ═══════════════════════════════════════════════════════════════════════════════
; IHS FACILITY
; ═══════════════════════════════════════════════════════════════════════════════
; Per IHS organizational structure

{@facility}
facility_id = !:                            ; Facility ID
name = !:                                   ; Facility name
area = !:                                   ; IHS Area
service_unit = :                            ; Service unit

; Location
address = @address                          ; Physical address
reservation = :                             ; Reservation (if applicable)

{@facility}

; Facility type - Per IHS structure
{.type}
facility_type = !(health_center, health_station, hospital)
operated_by = !(ihs, tribal, urban)         ; Operating entity
; ihs = IHS direct operated
; tribal = Tribal operated (638)
; urban = Urban Indian program

{@facility}

; Services
{.services}
emergency = ?                               ; Emergency services
inpatient = ?                               ; Inpatient
outpatient = ?                              ; Outpatient
dental = ?                                  ; Dental
pharmacy = ?                                ; Pharmacy
behavioral_health = ?                       ; Behavioral health
public_health_nursing = ?                   ; Public health nursing
community_health = ?                        ; Community health

{@facility}

; Contract Health Service Delivery Area - Per 42 CFR 136.22
{.chsda}
chsda_counties[] = :                        ; CHSDA counties (FIPS)
service_area_description = :                ; Service area description

{@facility}

; ═══════════════════════════════════════════════════════════════════════════════
; PURCHASED/REFERRED CARE (PRC)
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 136.21-136.33

{@prc}
referral_id = !:                            ; PRC referral ID
beneficiary_id = !:                         ; Beneficiary ID
referral_date = !date                       ; Referral date
facility_id = !:                            ; Referring IHS facility

; Eligibility - Per 42 CFR 136.23
{.eligibility}
ihs_eligible = ?                            ; IHS eligible
resides_in_chsda = ?                        ; Resides in CHSDA
emergency = ?                               ; Emergency service
direct_care_not_available = ?               ; Direct care not available

{@prc}

; Medical priority - Per IHS medical priorities
{.priority}
priority_level = ##:(1..5)                  ; Medical priority (1-5)
; 1 - Emergent/Acutely urgent
; 2 - Preventive care
; 3 - Primary/secondary care
; 4 - Tertiary care
; 5 - Excluded services

{@prc}

; Service details
{.service}
service_type = :                            ; Type of service
procedure_codes[] = :                       ; Procedure codes
diagnosis_codes[] = :                       ; Diagnosis codes
inpatient = ?                               ; Inpatient service
outpatient = ?                              ; Outpatient service

{@prc}

; Authorization
{.authorization}
authorized = ?                              ; PRC authorized
authorization_number = :                    ; Authorization number
authorized_amount = #$:(0..)                ; Authorized amount
deferred = ?                                ; Deferred (pending funds)
denial_reason = :                           ; Denial reason if applicable

{@prc}

; Outside provider
{.provider}
provider_name = :                           ; Provider name
provider_npi = :                            ; Provider NPI
facility_name = :                           ; Facility name

{@prc}

; Alternate resources - Per 42 CFR 136.61
{.alternate_resources}
medicare = ?                                ; Medicare
medicaid = ?                                ; Medicaid
private_insurance = ?                       ; Private insurance
alternate_resource_checked = ?              ; AR checked
ar_claim_filed = ?                          ; AR claim filed

{@prc}

; ═══════════════════════════════════════════════════════════════════════════════
; TRIBAL SELF-GOVERNANCE
; ═══════════════════════════════════════════════════════════════════════════════
; Per 25 USC 5381-5399 (Title V) and 25 USC 5321-5332 (Title I)

{@self_governance}
tribe_id = !:                               ; Tribe identifier
tribe_name = !:                             ; Tribe name
compact_type = !(title_i, title_v)          ; Self-governance type
; title_i = Self-Determination Contract (P.L. 93-638)
; title_v = Self-Governance Compact

; Compact/contract
{.agreement}
agreement_number = :                        ; Compact/contract number
effective_date = date                       ; Effective date
expiration_date = date                      ; Expiration date (if applicable)
annual_funding_agreement = ?                ; Has AFA

{@self_governance}

; Programs assumed
{.programs}
health_services = ?                         ; Health services
public_health_nursing = ?                   ; Public health nursing
community_health = ?                        ; Community health
behavioral_health = ?                       ; Behavioral health
dental = ?                                  ; Dental
pharmacy = ?                                ; Pharmacy
environmental_health = ?                    ; Environmental health
other_programs[] = :                        ; Other programs

{@self_governance}

; Funding
{.funding}
ihs_funding = #$:(0..)                      ; IHS funding amount
tribal_shares = #$:(0..)                    ; Tribal shares
contract_support_costs = #$:(0..)           ; CSC funding
total_funding = #$:(0..)                    ; Total funding

{@self_governance}

; ═══════════════════════════════════════════════════════════════════════════════
; URBAN INDIAN PROGRAM
; ═══════════════════════════════════════════════════════════════════════════════
; Per 25 USC 1651-1660h

{@urban_program}
program_id = !:                             ; Program ID
organization_name = !:                      ; Organization name (e.g., UIH)

; Location
address = !@address                         ; Physical address

{@urban_program}

; Program type - Per 25 USC 1653
{.type}
program_type = !(limited, outreach, residential)
; limited = Limited ambulatory
; residential = Residential treatment

{@urban_program}

; Services
{.services}
outpatient = ?                              ; Outpatient services
behavioral_health = ?                       ; Behavioral health
dental = ?                                  ; Dental
pharmacy = ?                                ; Pharmacy
substance_abuse = ?                         ; Substance abuse
wic = ?                                     ; WIC
referrals = ?                               ; Referral services
outreach = ?                                ; Outreach and enrollment

{@urban_program}

; Funding
{.funding}
ihs_grant = #$:(0..)                        ; IHS grant amount
other_funding = #$:(0..)                    ; Other funding
total_budget = #$:(0..)                     ; Total budget

{@urban_program}

; ═══════════════════════════════════════════════════════════════════════════════
; ALTERNATE RESOURCES
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 136.61

{@alternate_resources}
beneficiary_id = !:                         ; Beneficiary ID
verification_date = !date                   ; Verification date

; Medicare
{.medicare}
medicare = ?                                ; Medicare
medicare_number = *:                        ; Medicare number
part_a = ?                                  ; Part A
part_b = ?                                  ; Part B
part_d = ?                                  ; Part D
advantage_plan = ?                          ; Medicare Advantage

{@alternate_resources}

; Medicaid
{.medicaid}
medicaid = ?                                ; Medicaid
medicaid_id = :                             ; Medicaid ID
state = :(2)                                ; State

{@alternate_resources}

; Private insurance
{.private}
private_insurance = ?                       ; Private insurance
carrier_name = :                            ; Carrier name
policy_number = :                           ; Policy number
group_number = :                            ; Group number

{@alternate_resources}

; Other coverage
{.other}
va = ?                                      ; VA health care
tricare = ?                                 ; TRICARE
workers_comp = ?                            ; Workers' compensation
other = ?                                   ; Other coverage
other_description = :                       ; Other coverage description

{@alternate_resources}


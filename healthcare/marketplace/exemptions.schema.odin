; ═══════════════════════════════════════════════════════════════════════════════
; ODIN ACA Exemptions Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Individual Shared Responsibility exemptions including hardship, religious,
; affordability, and tribal exemptions. Remains relevant for catastrophic plan
; eligibility and state mandate compliance. Derived from 26 CFR 1.5000A and
; 45 CFR 155.605.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as marketplace

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.marketplace.exemptions"
version = "1.0.0"
title = "ACA Exemptions Schema"
description = "Individual Shared Responsibility exemptions"

{$derivation}
source[0].authority = "GPO"
source[0].citation = "26 CFR 1.5000A-3 - Exempt individuals"
source[0].url = "https://www.ecfr.gov/current/title-26/section-1.5000A-3"

source[1].authority = "GPO"
source[1].citation = "45 CFR 155.605 - Eligibility determination for exemptions"
source[1].url = "https://www.ecfr.gov/current/title-45/subtitle-A/subchapter-B/part-155/subpart-G/section-155.605"

source[2].authority = "IRS"
source[2].citation = "Publication 974 - Premium Tax Credit"
source[2].url = "https://www.irs.gov/publications/p974"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial ACA exemptions schema"
changelog[0].rationale = "Structure derived from 26 CFR 1.5000A and 45 CFR 155.605"

; ═══════════════════════════════════════════════════════════════════════════════
; EXEMPTION APPLICATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.610

{@application}
application_id = :                         ; Application ID
applicant_id = :                           ; Applicant
application_date = date                    ; Date submitted

; Tax year
tax_year = ##:(2014..)                     ; Tax year for exemption

; Exemption type requested
exemption_type = (affordability, hardship, religious, short_gap, tribal, other)

; Months requested
{.coverage_months}
months[] = :                                ; Months exemption requested (YYYY-MM)
full_year = ?                               ; Full year exemption

{@application}

; Status
{.status}
status = (approved, denied, partial, pending, withdrawn)
decision_date = date                        ; Decision date
denial_reason = :                           ; Reason if denied

{@application}

; Exemption certificate
{.certificate}
ecn = :                                     ; Exemption Certificate Number
certificate_date = date                     ; Certificate issue date
valid_months[] = :                          ; Months certificate valid

{@application}

; ═══════════════════════════════════════════════════════════════════════════════
; EXEMPTION CERTIFICATE
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.625

{@certificate}
ecn = :                                    ; Exemption Certificate Number
applicant_id = :                           ; Certificate holder
issue_date = date                          ; Issue date

; Exemption type
exemption_type = :                         ; Type of exemption
exemption_code = :                          ; IRS exemption code

; Validity period
{.validity}
start_date = date                          ; Start of exemption
end_date = date                             ; End of exemption
months_covered[] = :                        ; Specific months covered

{@certificate}

; Coverage status
{.coverage}
allows_catastrophic = ?                     ; Allows catastrophic plan enrollment
satisfies_mandate = ?                       ; Satisfies individual mandate

{@certificate}

; ═══════════════════════════════════════════════════════════════════════════════
; HARDSHIP EXEMPTION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.605(g)

{@hardship}
application_id = :                         ; Associated application
hardship_type = :                          ; Hardship category

; Hardship categories - Per 45 CFR 155.605(g)
category = (domestic_violence, eviction, homeless, medical_expenses, natural_disaster, other, utility_shutoff)

; Hardship details
{.details}
description = :                             ; Description of hardship
hardship_date = date                        ; When hardship occurred
ongoing = ?                                 ; Hardship is ongoing
documentation_type = :                      ; Type of documentation provided

{@hardship}

; Specific hardship types
homeless = @homeless_hardship
eviction = @eviction_hardship
medical = @medical_hardship
domestic_violence = @domestic_violence_hardship
utility = @utility_hardship
disaster = @disaster_hardship
other = @other_hardship

{@homeless_hardship}
shelter_name = :                            ; Shelter or organization
duration_months = ##:(0..)                  ; Duration of homelessness
current_living_situation = :                ; Current situation

{@eviction_hardship}
eviction_date = date                        ; Eviction date
eviction_notice_date = date                 ; Notice received date
reason = :                                  ; Reason for eviction

{@medical_hardship}
medical_debt_amount = #$:(0..)              ; Medical debt amount
condition = :                               ; Medical condition
unable_to_afford = ?                        ; Unable to afford coverage

{@domestic_violence_hardship}
victim_services_contact = ?                 ; Contact with victim services
documentation_type = (court_order, police_report, shelter_statement, other)

{@utility_hardship}
utility_type = (electric, gas, water)       ; Utility type
shutoff_date = date                         ; Shutoff date
shutoff_notice_date = date                  ; Notice date
amount_owed = #$:(0..)                      ; Amount owed

{@disaster_hardship}
disaster_type = :                           ; Type of disaster
fema_declaration = ?                        ; FEMA declared disaster
disaster_date = date                        ; Date of disaster
location = :                                ; Disaster location

{@other_hardship}
hardship_description = :                    ; Description
why_unable_to_obtain_coverage = :           ; Reason cannot obtain coverage
supporting_documentation[] = :              ; Documentation provided

; ═══════════════════════════════════════════════════════════════════════════════
; AFFORDABILITY EXEMPTION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 26 CFR 1.5000A-3(e)

{@affordability}
application_id = :                         ; Associated application
tax_year = ##:(2014..)                     ; Tax year

; Income - Per 26 CFR 1.5000A-3(e)(2)
{.income}
household_income = #$:(0..)                 ; Household income
household_size = ##:(1..)                   ; Household size
fpl_percent = #:(0..)                       ; Income as % FPL

{@affordability}

; Lowest cost coverage - Per 26 CFR 1.5000A-3(e)(4)
{.lowest_cost}
bronze_plan_premium = #$:(0..)              ; Lowest bronze plan premium
employer_ee_premium = #$:(0..)              ; Employer employee-only premium
required_contribution = #$:(0..)            ; Required contribution

{@affordability}

; Affordability calculation - Per 26 CFR 1.5000A-3(e)(1)
{.calculation}
affordability_threshold = #:(0..9.12)       ; Threshold percent (varies by year)
coverage_percent_of_income = #:(0..100)     ; Coverage as % of income
exceeds_threshold = ?                       ; Exceeds affordability threshold
qualifies = ?                               ; Qualifies for exemption

{@affordability}

; ═══════════════════════════════════════════════════════════════════════════════
; SHORT COVERAGE GAP EXEMPTION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 26 CFR 1.5000A-3(j)

{@short_gap}
tax_year = ##:(2014..)                     ; Tax year
applicant_id = :                           ; Applicant

; Gap period
{.gap}
gap_start = date                           ; Gap start date
gap_end = date                             ; Gap end date
gap_months = ##:(1..3)                      ; Number of months in gap

{@short_gap}

; Qualification - Per 26 CFR 1.5000A-3(j)
{.qualification}
less_than_three_months = ?                  ; Gap less than 3 consecutive months
only_gap_in_year = ?                        ; Only gap during the year
qualifies = ?                               ; Qualifies for exemption

{@short_gap}

; Coverage before/after gap
{.surrounding_coverage}
coverage_before = ?                         ; Had coverage before gap
coverage_after = ?                          ; Had coverage after gap
before_coverage_type = :                    ; Type of prior coverage
after_coverage_type = :                     ; Type of subsequent coverage

{@short_gap}

; ═══════════════════════════════════════════════════════════════════════════════
; RELIGIOUS CONSCIENCE EXEMPTION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 26 CFR 1.5000A-3(a)

{@religious}
application_id = :                         ; Application ID
exemption_type = (health_care_sharing, religious_sect)

; Religious sect - Per 26 CFR 1.5000A-3(a)
{.sect}
sect_name = :                               ; Name of religious sect
recognized_by_ssa = ?                       ; Recognized by Social Security Admin
sect_number = :                             ; SSA sect number

{@religious}

; Health care sharing ministry - Per 26 CFR 1.5000A-3(b)
{.hcsm}
ministry_name = :                           ; Ministry name
member_since = date                         ; Membership date
meets_requirements = ?                      ; Meets IRC 5000A(d)(2)(B) requirements

{@religious}

; ═══════════════════════════════════════════════════════════════════════════════
; TRIBAL EXEMPTION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 26 CFR 1.5000A-3(c)

{@tribal}
applicant_id = :                           ; Applicant

; Tribal membership - Per 26 CFR 1.5000A-3(c)
{.membership}
tribal_member = ?                           ; Member of federally-recognized tribe
tribe_name = :                              ; Tribe name
tribal_id = :                               ; Tribal enrollment number
eligible_for_ihs = ?                        ; Eligible for IHS services

{@tribal}

; IHCIA eligible - Per 26 CFR 1.5000A-3(c)
{.ihcia}
ihcia_eligible = ?                          ; Eligible for IHCIA services
services_received = ?                       ; Received IHS services

{@tribal}

; ═══════════════════════════════════════════════════════════════════════════════
; INCOME BELOW FILING THRESHOLD
; ═══════════════════════════════════════════════════════════════════════════════
; Per 26 CFR 1.5000A-3(f)

{@below_filing_threshold}
tax_year = ##:(2014..)                     ; Tax year
applicant_id = :                           ; Applicant

; Filing status
{.filing}
filing_status = :(head_of_household, married_filing_jointly, married_filing_separately, qualifying_widow, single)
gross_income = #$:(0..)                     ; Gross income
filing_threshold = #$:(0..)                 ; Filing threshold for status
below_threshold = ?                         ; Income below threshold

{@below_filing_threshold}

; Qualification
{.qualification}
required_to_file = ?                        ; Required to file return
qualifies = ?                               ; Qualifies for exemption

{@below_filing_threshold}

; ═══════════════════════════════════════════════════════════════════════════════
; STATE MANDATE EXEMPTIONS
; ═══════════════════════════════════════════════════════════════════════════════
; For states with individual mandates (CA, DC, MA, NJ, RI, VT)

{@state_exemption}
state = :(2)                               ; State
tax_year = ##:(2019..)                     ; Tax year
applicant_id = :                           ; Applicant

; State-specific exemption type
{.exemption}
exemption_type = :                          ; State exemption type
state_code = :                              ; State exemption code
qualifies = ?                               ; Qualifies for exemption

{@state_exemption}

; State-specific requirements
{.requirements}
application_required = ?                    ; Application required
documentation[] = :                         ; Required documentation
filing_deadline = date                      ; Application deadline

{@state_exemption}

; Certificate
{.certificate}
certificate_number = :                      ; State certificate number
issued_date = date                          ; Issue date
valid_months[] = :                          ; Months covered

{@state_exemption}

; ═══════════════════════════════════════════════════════════════════════════════
; EXEMPTION TYPES REFERENCE
; ═══════════════════════════════════════════════════════════════════════════════
; Per IRS instructions

{@exemption_type_reference}
code = :                                   ; Exemption code (A-H)
name = :                                   ; Exemption name
cfr_citation = :                            ; CFR citation
claimed_on_return = ?                       ; Claimed on tax return
requires_ecn = ?                            ; Requires ECN from Exchange

; Codes:
; A - Religious conscience
; B - Health care sharing ministry
; C - Incarcerated
; D - Indian tribe member
; E - Short coverage gap
; F - Affordability
; G - Aggregate self-only coverage exceeds threshold
; H - Other coverage exemptions

; Exchange-granted codes:
; hardship, religious, affordability, indian


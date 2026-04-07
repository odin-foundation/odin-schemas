; ===================================================================================
; ODIN Dental Benefits Schema
; ===================================================================================
; Dental benefit management covering plans, CDT procedure coverage, orthodontia,
; waiting periods, and provider networks. Supports DHMO, DPPO, indemnity, and
; discount dental plans for both fully-insured and self-funded arrangements.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.dental"
version = "1.0.0"
title = "Dental Benefits Schema"
description = "Dental benefit management including plans, benefits, procedures, orthodontia, waiting periods, and providers"

{$derivation}
source[0].authority = "ADA"
source[0].citation = "CDT: Code on Dental Procedures and Nomenclature"
source[0].url = "https://www.ada.org/publications/cdt"

source[1].authority = "NADP"
source[1].citation = "National Association of Dental Plans - Industry Standards"
source[1].url = "https://www.nadp.org/"

source[2].authority = "CMS"
source[2].citation = "Dental Benefits in Medicare Advantage and Medicaid"
source[2].url = "https://www.cms.gov/medicare/coverage/dental"

source[3].authority = "NAIC"
source[3].citation = "Dental Plan Disclosure Requirements"
source[3].url = "https://content.naic.org/"

source[4].authority = "State Dental Boards"
source[4].citation = "State Dental Practice Acts and Regulations"
source[4].url = "https://www.ada.org/resources/practice/practice-management"

source[5].authority = "GPO"
source[5].citation = "42 CFR 440.100 - Dental Services (Medicaid)"
source[5].url = "https://www.ecfr.gov/current/title-42/chapter-IV/subchapter-C/part-440/subpart-A/section-440.100"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on ADA CDT codes, NADP standards, and CMS dental guidelines"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial dental benefits schema"
changelog[0].rationale = "Comprehensive dental benefit coverage for all plan types"

; ===================================================================================
; DENTAL PLAN - Plan Structure and Design
; ===================================================================================
; Per NADP standards and state insurance regulations

{@dental_plan}
; Required fields first
plan_id = !:                                 ; Plan identifier
plan_name = !:                               ; Plan name
effective_date = !date                       ; Plan effective date
expiration_date = !date                      ; Plan expiration date

; Invariants
:invariant expiration_date > effective_date

; Plan type
plan_type = !(dhmo, discount, dppo, epo, indemnity, ppo)
funding_type = (fully_insured, level_funded, self_funded)
payer_type = (commercial, exchange, medicaid, medicare_advantage, self_funded)

; Sponsor information
{.sponsor}
sponsor_name = :                             ; Plan sponsor
group_number = :                             ; Group number
situs_state = :(2)                           ; Situs state

{@dental_plan}

; ---------------------------------------------------------------------------
; Premium and Contribution
; ---------------------------------------------------------------------------
{.premium}
monthly_employee = #$:(0..)                  ; Employee monthly premium
monthly_ee_spouse = #$:(0..)                 ; Employee + spouse
monthly_ee_child = #$:(0..)                  ; Employee + child(ren)
monthly_family = #$:(0..)                    ; Family
annual_employee = #$:(0..)                   ; Employee annual
employer_contribution = #:(0..100)           ; Employer contribution %

{@dental_plan}

; ---------------------------------------------------------------------------
; Deductible - Per plan design
; ---------------------------------------------------------------------------
{.deductible}
individual = #$:(0..)                        ; Individual deductible
family = #$:(0..)                            ; Family deductible
family_max = ##:(2..5)                       ; Family max multiplier
waived_preventive = ?                        ; Waived for preventive
waived_diagnostic = ?                        ; Waived for diagnostic
calendar_year = ?                            ; Calendar year deductible

{@dental_plan}

; ---------------------------------------------------------------------------
; Annual Maximum
; ---------------------------------------------------------------------------
{.annual_maximum}
per_person = #$:(0..)                        ; Per-person annual max
calendar_year = ?                            ; Calendar year max
carryover = ?                                ; Unused benefits carryover
carryover_max = #$:(0..):if carryover = true ; Maximum carryover amount
rollover_threshold = #$:(0..):if carryover = true ; Threshold for carryover

{@dental_plan}

; ---------------------------------------------------------------------------
; Lifetime Maximum
; ---------------------------------------------------------------------------
{.lifetime_maximum}
orthodontia = #$:(0..)                       ; Orthodontia lifetime max
implants = #$:(0..)                          ; Implant lifetime max
tmj = #$:(0..)                               ; TMJ lifetime max

{@dental_plan}

; ---------------------------------------------------------------------------
; Network Information
; ---------------------------------------------------------------------------
{.network}
network_name = :                             ; Network name
in_network_required = ?                      ; In-network only (DHMO/EPO)
provider_count = ##:(0..)                    ; Network provider count
states_covered[] = :(2)                      ; States with coverage
national_network = ?                         ; National network available
access_fee = #$:(0..)                        ; Network access fee (DHMO)

{@dental_plan}

; ---------------------------------------------------------------------------
; Eligibility
; ---------------------------------------------------------------------------
{.eligibility}
dependent_age_limit = ##:(19..26)            ; Dependent age limit
student_age_limit = ##:(23..26)              ; Full-time student limit
disabled_dependent = ?                       ; Disabled dependent coverage
domestic_partner = ?                         ; Domestic partner coverage
waiting_period_days = ##:(0..365)            ; Eligibility waiting period

{@dental_plan}

; ---------------------------------------------------------------------------
; Plan Design
; ---------------------------------------------------------------------------
{.design}
incentive_plan = ?                           ; Incentive/step-up plan
incentive_start = #:(0..100):if incentive_plan = true
incentive_max = #:(0..100):if incentive_plan = true
incentive_step = #:(0..20):if incentive_plan = true
missing_tooth_clause = ?                     ; Missing tooth exclusion
pre_existing_exclusion = ?                   ; Pre-existing condition exclusion
cosmetic_exclusion = ?                       ; Cosmetic exclusion
implant_coverage = ?                         ; Implant coverage
posterior_composite = ?                      ; Posterior composite covered

{@dental_plan}

; ===================================================================================
; DENTAL BENEFIT - Coverage Levels and Frequencies
; ===================================================================================
; Per NADP benefit classification standards

{@dental_benefit}
; Required fields first
plan_id = !:                                 ; Plan identifier
category = !(basic, diagnostic, endodontic, major, oral_surgery, orthodontia, periodontic, preventive, prosthodontic)
coinsurance_in = !#:(0..100)                 ; In-network coinsurance
coinsurance_out = !#:(0..100)                ; Out-of-network coinsurance

; Category mapping to CDT codes
{.coverage}
cdt_range_start = :                          ; CDT code range start
cdt_range_end = :                            ; CDT code range end
description = :                              ; Category description

{@dental_benefit}

; ---------------------------------------------------------------------------
; Deductible Application
; ---------------------------------------------------------------------------
{.deductible}
applies = ?                                  ; Deductible applies
waived = ?                                   ; Deductible waived

{@dental_benefit}

; ---------------------------------------------------------------------------
; Annual Maximum Application
; ---------------------------------------------------------------------------
{.annual_max}
applies = ?                                  ; Counts toward annual max
separate_max = ?                             ; Separate max for category
separate_max_amount = #$:(0..):if separate_max = true

{@dental_benefit}

; ---------------------------------------------------------------------------
; Waiting Period
; ---------------------------------------------------------------------------
{.waiting}
waiting_period = ?                           ; Waiting period applies
waiting_months = ##:(0..24):if waiting_period = true

{@dental_benefit}

; ---------------------------------------------------------------------------
; Frequency Limitations
; ---------------------------------------------------------------------------
{.frequency}
exams_per_year = ##:(0..4)                   ; Exams per year
cleanings_per_year = ##:(0..4)               ; Cleanings per year
xray_frequency = :                           ; X-ray frequency (e.g., "1 per 36 months")
fluoride_age_limit = ##:(0..21)              ; Fluoride age limit
sealant_age_limit = ##:(0..16)               ; Sealant age limit
sealant_permanent_only = ?                   ; Permanent teeth only

{@dental_benefit}

; ===================================================================================
; DENTAL PROCEDURE - CDT Procedure Codes
; ===================================================================================
; Per ADA CDT code structure

{@dental_procedure}
; Required fields first
cdt_code = !:/^D\d{4}$/                      ; CDT procedure code
procedure_name = !:                          ; Procedure name
category = !(adjunctive, basic, diagnostic, endodontic, implant, major, oral_surgery, orthodontia, periodontic, preventive, prosthodontic_fixed, prosthodontic_removable)

; Procedure details
{.details}
description = :                              ; Full description
nomenclature = :                             ; ADA nomenclature
subcategory = :                              ; Subcategory
tooth_specific = ?                           ; Tooth-specific procedure
surface_specific = ?                         ; Surface-specific
quadrant_specific = ?                        ; Quadrant-specific
arch_specific = ?                            ; Arch-specific

{@dental_procedure}

; ---------------------------------------------------------------------------
; Coverage and Limitations
; ---------------------------------------------------------------------------
{.coverage}
covered = ?                                  ; Covered under plan
coverage_tier = (basic, major, minor, not_covered, preventive)
coinsurance_in = #:(0..100)                  ; In-network coinsurance
coinsurance_out = #:(0..100)                 ; Out-of-network coinsurance
deductible_applies = ?                       ; Deductible applies
max_applies = ?                              ; Counts toward max

{@dental_procedure}

; ---------------------------------------------------------------------------
; Frequency and Age Limits
; ---------------------------------------------------------------------------
{.limits}
frequency = :                                ; Frequency limit description
per_months = ##:(0..60)                      ; Per X months
per_year = ##:(0..4)                         ; Per year limit
per_lifetime = ##:(0..)                      ; Per lifetime limit
age_min = ##:(0..99)                         ; Minimum age
age_max = ##:(0..99)                         ; Maximum age
tooth_limit = ##:(0..32)                     ; Tooth limit

{@dental_procedure}

; ---------------------------------------------------------------------------
; Prior Authorization
; ---------------------------------------------------------------------------
{.prior_auth}
required = ?                                 ; PA required
threshold = #$:(0..):if required = true      ; PA threshold amount
documentation[] = ::if required = true       ; Required documentation

{@dental_procedure}

; ---------------------------------------------------------------------------
; Downgrades and Alternatives
; ---------------------------------------------------------------------------
{.alternatives}
downgrade_to = :                             ; Downgrade to CDT code
downgrade_material = (amalgam, composite)    ; Material downgrade
least_expensive_alternative = ?              ; LEAT applies
alternate_benefit = :                        ; Alternate benefit code

{@dental_procedure}

; ===================================================================================
; DENTAL ORTHODONTIA - Orthodontic Coverage
; ===================================================================================
; Per NADP orthodontia standards

{@dental_ortho}
; Required fields first
plan_id = !:                                 ; Plan identifier
covered = !?                                 ; Orthodontia covered

; Coverage details
lifetime_maximum = #$:(0..):if covered = true ; Lifetime maximum
coinsurance_in = #:(0..100):if covered = true ; In-network coinsurance
coinsurance_out = #:(0..100):if covered = true ; Out-of-network coinsurance

; ---------------------------------------------------------------------------
; Eligibility
; ---------------------------------------------------------------------------
{.eligibility}
child_only = ?                               ; Children only
adult_covered = ?                            ; Adult ortho covered
age_limit = ##:(0..26)                       ; Age limit for ortho
dependent_age_limit = ##:(19..26)            ; Dependent age limit

{@dental_ortho}

; ---------------------------------------------------------------------------
; Treatment Types
; ---------------------------------------------------------------------------
{.treatment}
comprehensive = ?                            ; Comprehensive ortho covered
limited = ?                                  ; Limited ortho covered
interceptive = ?                             ; Interceptive ortho covered
retention = ?                                ; Retention covered
clear_aligners = ?                           ; Clear aligners covered
lingual_braces = ?                           ; Lingual braces covered

{@dental_ortho}

; ---------------------------------------------------------------------------
; Payment Structure
; ---------------------------------------------------------------------------
{.payment}
payment_type = (lump_sum, monthly, quarterly)
initial_payment = #$:(0..)                   ; Initial/banding payment
initial_percent = #:(0..50)                  ; Initial payment percent
monthly_payment = #$:(0..)                   ; Monthly payment
treatment_months = ##:(12..36)               ; Typical treatment months

{@dental_ortho}

; ---------------------------------------------------------------------------
; Waiting Period
; ---------------------------------------------------------------------------
{.waiting}
waiting_period = ?                           ; Waiting period applies
waiting_months = ##:(0..24):if waiting_period = true

{@dental_ortho}

; ---------------------------------------------------------------------------
; Pre-existing Conditions
; ---------------------------------------------------------------------------
{.preexisting}
excluded = ?                                 ; Pre-existing excluded
banding_date_applies = ?                     ; Banding date determines coverage
in_progress_covered = ?                      ; In-progress treatment covered

{@dental_ortho}

; ---------------------------------------------------------------------------
; Medically Necessary Orthodontia
; ---------------------------------------------------------------------------
{.medical_necessity}
separate_benefit = ?                         ; Separate from elective
cleft_palate = ?                             ; Cleft lip/palate covered
craniofacial = ?                             ; Craniofacial anomaly covered
hhi_criteria = ?                             ; Handicapping malocclusion index

{@dental_ortho}

; ===================================================================================
; DENTAL WAITING PERIOD - Service-Based Waiting Periods
; ===================================================================================
; Per state regulations and plan design

{@dental_waiting}
; Required fields first
plan_id = !:                                 ; Plan identifier
category = !(basic, diagnostic, endodontic, major, oral_surgery, orthodontia, periodontic, preventive, prosthodontic)
waiting_months = !##:(0..24)                 ; Waiting period in months

; Waiting period details
{.details}
effective_from = (coverage_start, enrollment_date, hire_date)
pro_rata = ?                                 ; Pro-rata credit
prior_coverage_credit = ?                    ; Credit for prior coverage
proof_required = ?:if prior_coverage_credit = true
documentation[] = ::if proof_required = true ; Required documentation

{@dental_waiting}

; ---------------------------------------------------------------------------
; Waiver Conditions
; ---------------------------------------------------------------------------
{.waiver}
waived_new_groups = ?                        ; Waived for new groups
waived_open_enrollment = ?                   ; Waived during OE
waived_portability = ?                       ; Waived with prior coverage
waiver_threshold_months = ##:(0..12):if waived_portability = true
waiver_gap_days = ##:(0..63):if waived_portability = true

{@dental_waiting}

; ---------------------------------------------------------------------------
; Exception Procedures
; ---------------------------------------------------------------------------
{.exceptions}
emergency_waived = ?                         ; Emergency exempt
accident_waived = ?                          ; Accident exempt
exception_procedures[] = :                   ; CDT codes exempt

{@dental_waiting}

; ===================================================================================
; DENTAL PROVIDER - Provider Network and Credentialing
; ===================================================================================
; Per state dental board regulations and NCQA standards

{@dental_provider}
; Required fields first
provider_id = !:                             ; Provider identifier
npi = !:/^\d{10}$/                           ; National Provider Identifier
provider_type = !(dental_hygienist, dentist, denturist, orthodontist, specialist)

; Provider identification
{.identification}
first_name = :                               ; First name
last_name = :                                ; Last name
suffix = :                                   ; Suffix (DDS, DMD)
dba_name = :                                 ; Doing business as
practice_name = :                            ; Practice name
tax_id = *:                                  ; Tax ID

{@dental_provider}

; ---------------------------------------------------------------------------
; Licensure - Per state dental board
; ---------------------------------------------------------------------------
license = @license_credential                ; License credential

; DEA information
{.dea}
dea_number = *:                              ; DEA number
dea_expiration = date                        ; DEA expiration

{@dental_provider}

; ---------------------------------------------------------------------------
; Specialty - Per ADA recognized specialties
; ---------------------------------------------------------------------------
{.specialty}
primary_specialty = (endodontics, general_dentistry, oral_maxillofacial_pathology, oral_maxillofacial_radiology, oral_maxillofacial_surgery, orofacial_pain, orthodontics, pediatric_dentistry, periodontics, prosthodontics, public_health_dentistry)
board_certified = ?                          ; Board certified
board_name = ::if board_certified = true     ; Certifying board
certification_date = date:if board_certified = true

{@dental_provider}

; ---------------------------------------------------------------------------
; Network Participation
; ---------------------------------------------------------------------------
{.network}
network_ids[] = :                            ; Network memberships
participation_status = (active, inactive, pending, terminated)
effective_date = date                        ; Network effective date
termination_date = date                      ; Termination date
accepting_patients = ?                       ; Accepting new patients
dhmo_assignment = ?                          ; DHMO assigned provider

{@dental_provider}

; ---------------------------------------------------------------------------
; Fee Schedule
; ---------------------------------------------------------------------------
{.fees}
fee_schedule_id = :                          ; Fee schedule identifier
fee_schedule_percent = #:(0..150)            ; Percent of fee schedule
negotiated_rates = ?                         ; Has negotiated rates

{@dental_provider}

; ---------------------------------------------------------------------------
; Practice Location
; ---------------------------------------------------------------------------
{.location}
address = @address                           ; Practice address
phone = *@phone                              ; Practice phone
fax = *:                                     ; Practice fax
email = *@email                              ; Practice email
office_hours = :                             ; Office hours
handicap_accessible = ?                      ; ADA accessible
languages[] = :                              ; Languages spoken

{@dental_provider}

; ---------------------------------------------------------------------------
; Credentialing - Per NCQA standards
; ---------------------------------------------------------------------------
{.credentialing}
credentialed = ?                             ; Credentialing complete
credential_date = date:if credentialed = true
recredential_due = date                      ; Recredentialing due
malpractice_coverage = ?                     ; Malpractice verified
malpractice_carrier = :                      ; Malpractice carrier
malpractice_amount = #$:(0..)                ; Coverage amount
sanctions_checked = ?                        ; Sanctions verified
background_checked = ?                       ; Background verified

{@dental_provider}

; ===================================================================================
; DENTAL CLAIM
; ===================================================================================
; Per ADA claim form and HIPAA 837D

{@dental_claim}
; Required fields first
claim_id = !:                                ; Claim identifier
service_date = !date                         ; Date of service
member_id = !*:                              ; Member identifier
provider_npi = !:/^\d{10}$/                  ; Rendering provider NPI

; Patient information
{.patient}
patient_name = :                             ; Patient name
relationship = (child, other, self, spouse)  ; Relationship to subscriber
tooth_number = :(1..32)                      ; Tooth number (1-32)
tooth_surface[] = :(B, D, F, I, L, M, O)     ; Tooth surfaces
quadrant = (ll, lr, ul, ur)                  ; Quadrant
arch = (lower, upper)                        ; Arch

{@dental_claim}

; Procedure information
{.procedure}
cdt_code = :/^D\d{4}$/                       ; CDT code
procedure_name = :                           ; Procedure name
quantity = ##:(1..10)                        ; Quantity
description = :                              ; Additional description

{@dental_claim}

; Provider information
{.provider}
rendering_npi = :/^\d{10}$/                  ; Rendering provider
billing_npi = :/^\d{10}$/                    ; Billing provider
provider_name = :                            ; Provider name
provider_taxonomy = :                        ; Provider taxonomy

{@dental_claim}

; Charges and payment
{.charges}
billed_amount = #$:(0..)                     ; Billed amount
allowed_amount = #$:(0..)                    ; Allowed amount
deductible = #$:(0..)                        ; Deductible applied
coinsurance = #$:(0..)                       ; Coinsurance amount
copay = #$:(0..)                             ; Copay amount
plan_paid = #$:(0..)                         ; Plan payment
patient_responsibility = #$:(0..)            ; Patient responsibility
cob_amount = #$:(0..)                        ; COB adjustment

{@dental_claim}

; Adjudication
{.adjudication}
status = (denied, paid, pended, pending, rejected)
process_date = date                          ; Process date
denial_reason = :                            ; Denial reason code
denial_description = :                       ; Denial description
frequency_denial = ?                         ; Frequency limitation
waiting_period_denial = ?                    ; Waiting period denial
not_covered_denial = ?                       ; Not covered denial
prior_auth_denial = ?                        ; Prior auth required

{@dental_claim}

; Pre-treatment estimate
{.pre_treatment}
estimate_requested = ?                       ; Pre-treatment estimate
estimate_id = :                              ; Estimate ID
estimate_date = date                         ; Estimate date
estimate_status = (approved, denied, pending)

{@dental_claim}


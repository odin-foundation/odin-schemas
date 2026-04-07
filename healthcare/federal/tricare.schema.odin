; ═══════════════════════════════════════════════════════════════════════════════
; ODIN TRICARE Schema
; ═══════════════════════════════════════════════════════════════════════════════
; TRICARE military health system structures covering beneficiary eligibility,
; enrollment, plan options, and claims for active duty and their dependents.
; Derived from 10 USC Chapter 55 and 32 CFR Part 199.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.federal.tricare"
version = "1.0.0"
title = "TRICARE Schema"
description = "TRICARE military health system structures"

{$derivation}
source[0].authority = "GPO"
source[0].citation = "10 USC Chapter 55 - Medical and Dental Care"
source[0].url = "https://www.law.cornell.edu/uscode/text/10/subtitle-A/part-II/chapter-55"

source[1].authority = "GPO"
source[1].citation = "32 CFR Part 199 - Civilian Health and Medical Program"
source[1].url = "https://www.ecfr.gov/current/title-32/subtitle-A/chapter-I/subchapter-M/part-199"

source[2].authority = "DHA"
source[2].citation = "TRICARE Policy Manual 6010.57-M"
source[2].url = "https://manuals.health.mil/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial TRICARE schema"
changelog[0].rationale = "Structure derived from 10 USC Chapter 55 and 32 CFR Part 199"

; ═══════════════════════════════════════════════════════════════════════════════
; BENEFICIARY
; ═══════════════════════════════════════════════════════════════════════════════
; Per 32 CFR 199.3

{@beneficiary}
beneficiary_id = !:                         ; Beneficiary ID
dod_id = !:                                 ; DoD ID number (EDIPI)

; Demographics
{.demographics}
first_name = !:                             ; First name
middle_name = :                             ; Middle name
last_name = !:                              ; Last name
dob = !*date                                ; Date of birth
gender = (female, male)                     ; Gender
ssn = *:                                    ; SSN

{@beneficiary}

; Sponsor relationship
{.sponsor}
sponsor_id = :                              ; Sponsor's DoD ID
relationship = !(child, former_spouse, parent, self, spouse, widow_widower)
sponsor = ?                                 ; Sponsor

{@beneficiary}

; Eligibility category - Per 32 CFR 199.3(b)
{.eligibility}
category = !(adr_dependent, adr_member, guard_reserve, retiree, retiree_dependent, survivor, tamp, trr)
; adr = Active Duty Regular
; tamp = Transitional Assistance Management Program
; trr = TRICARE Reserve Retired

uniformed_service = (air_force, army, coast_guard, marine_corps, navy, noaa, phs, space_force)
status = (active_duty, medically_retired, retired, separated)

{@beneficiary}

; DEERS registration
{.deers}
deers_eligible = ?                          ; DEERS eligible
deers_enrolled = ?                          ; Enrolled in DEERS
deers_enrollment_date = date                ; DEERS enrollment date
deers_termination_date = date               ; DEERS termination date

{@beneficiary}

; ═══════════════════════════════════════════════════════════════════════════════
; TRICARE PLAN
; ═══════════════════════════════════════════════════════════════════════════════
; Per 32 CFR 199.17

{@plan}
plan_type = !(prime, prime_remote, select, tricare_for_life, us_family, young_adult)
plan_year = !##:(1995..)                    ; Plan year
region = (east, overseas, west)             ; TRICARE region

; Plan details - Per 32 CFR 199.17
{.details}
managed_care = ?                            ; Managed care option
pcp_required = ?                            ; PCP required
referral_required = ?                       ; Referrals required
network_required = ?                        ; Must use network

{@plan}

; Costs - Per 32 CFR 199.17
{.costs}
enrollment_fee = #$:(0..)                   ; Annual enrollment fee
deductible_individual = #$:(0..)            ; Individual deductible
deductible_family = #$:(0..)                ; Family deductible
catastrophic_cap = #$:(0..)                 ; Catastrophic cap

{@plan}

; Eligibility
{.eligibility}
active_duty = ?                             ; For active duty
active_duty_family = ?                      ; For AD family
retiree = ?                                 ; For retirees
retiree_family = ?                          ; For retiree family
guard_reserve = ?                           ; For Guard/Reserve
survivor = ?                                ; For survivors

{@plan}

; ═══════════════════════════════════════════════════════════════════════════════
; ENROLLMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 32 CFR 199.17

{@enrollment}
enrollment_id = !:                          ; Enrollment ID
beneficiary_id = !:                         ; Beneficiary ID
plan_type = !:                              ; Plan type

; Enrollment status
enrollment_status = @enrollment_period      ; Enrollment period with status

{@enrollment}

; Region
{.region}
region = !(east, overseas, west)            ; TRICARE region
region_contractor = :                       ; Regional contractor
mtf_enrolled = ?                            ; Enrolled at MTF

{@enrollment}

; Primary Care Manager (TRICARE Prime)
{.pcm}
pcm_assigned = ?                            ; Assigned PCM
pcm_name = :                                ; PCM name
pcm_npi = :                                 ; PCM NPI
mtf_assigned = ?                            ; Assigned to MTF
mtf_name = :                                ; MTF name

{@enrollment}

; Premium payment (for fee-based plans)
{.premium}
premium_required = ?                        ; Premium required
monthly_premium = #$:(0..)                  ; Monthly premium
payment_method = (allotment, direct)        ; Payment method

{@enrollment}

; ═══════════════════════════════════════════════════════════════════════════════
; TRICARE FOR LIFE
; ═══════════════════════════════════════════════════════════════════════════════
; Per 10 USC 1086(d)

{@tricare_for_life}
beneficiary_id = !:                         ; Beneficiary ID

; Eligibility - Per 10 USC 1086(d)
{.eligibility}
medicare_entitled = ?                       ; Medicare Part A entitled
medicare_part_b = ?                         ; Medicare Part B enrolled
tricare_eligible = ?                        ; TRICARE eligible
deers_registered = ?                        ; DEERS registered

{@tricare_for_life}

; Medicare information
{.medicare}
medicare_number = *:                         ; Medicare number
part_a_effective = date                     ; Part A effective date
part_b_effective = date                     ; Part B effective date
premium_paid = ?                            ; Part B premium current

{@tricare_for_life}

; TFL coverage
{.coverage}
tfl_effective_date = date                   ; TFL effective date
primary_payer = : "medicare"                ; Medicare is primary
secondary_payer = : "tricare"               ; TRICARE is secondary

{@tricare_for_life}

; ═══════════════════════════════════════════════════════════════════════════════
; TRICARE RESERVE SELECT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 10 USC 1076d

{@reserve_select}
beneficiary_id = !:                         ; Beneficiary ID
enrollment_id = !:                          ; Enrollment ID

; Eligibility - Per 10 USC 1076d
{.eligibility}
reserve_component = (afr, ang, ar, arng, mcr, nr, cgr)
status = (drilling, retired_grey_area)      ; Reserve status
qualifies = ?                               ; Meets TRS requirements

{@reserve_select}

; Enrollment
{.enrollment}
enrollment_type = (member_only, member_and_family)
period = @enrollment_period                 ; Coverage period

{@reserve_select}

; Premium - Per 10 USC 1076d(d)
{.premium}
monthly_premium = #$:(0..)                  ; Monthly premium
member_share = #$:(0..)                     ; Member share (28%)
government_share = #$:(0..)                 ; Government share (72%)

{@reserve_select}

; ═══════════════════════════════════════════════════════════════════════════════
; TRICARE YOUNG ADULT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 10 USC 1110b

{@young_adult}
beneficiary_id = !:                         ; Beneficiary ID
sponsor_id = !:                             ; Sponsor ID

; Eligibility - Per 10 USC 1110b
{.eligibility}
age = ##:(21..26)                           ; Age (21-26)
unmarried = ?                               ; Must be unmarried
not_eligible_employer = ?                   ; Not eligible for employer coverage
sponsor_eligible = ?                        ; Sponsor TRICARE eligible

{@young_adult}

; Plan option
{.plan}
option = (prime, select)                    ; TYA Prime or TYA Select

{@young_adult}

; Premium - Per 10 USC 1110b(c)
{.premium}
monthly_premium = #$:(0..)                  ; Full monthly premium
enrollee_pays = ?true                       ; Enrollee pays full premium

{@young_adult}

; ═══════════════════════════════════════════════════════════════════════════════
; AUTHORIZATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 32 CFR 199.4

{@authorization}
auth_id = !:                                ; Authorization ID
beneficiary_id = !:                         ; Beneficiary ID
request_date = !date                        ; Request date

; Service requested
{.service}
service_type = :                            ; Service type
procedure_codes[] = :                       ; Procedure codes
diagnosis_codes[] = :                       ; Diagnosis codes
provider_name = :                           ; Requested provider
provider_npi = :                            ; Provider NPI

{@authorization}

; Referral (TRICARE Prime)
{.referral}
referral_required = ?                       ; Referral required
referral_number = :                         ; Referral number
pcm_approved = ?                            ; PCM approved
valid_from = date                           ; Valid from date
valid_to = date                             ; Valid to date

{@authorization}

; Prior authorization
{.prior_auth}
prior_auth_required = ?                     ; Prior auth required
auth_number = :                             ; Authorization number
status = (approved, denied, pending)        ; Status
units_approved = ##:(0..)                   ; Units approved
denial_reason = :                           ; Denial reason

{@authorization}

; ═══════════════════════════════════════════════════════════════════════════════
; CLAIM
; ═══════════════════════════════════════════════════════════════════════════════
; Per 32 CFR 199.7

{@claim}
claim_id = !:                               ; Claim ID
beneficiary_id = !:                         ; Beneficiary ID
claim_type = !(dental, institutional, pharmacy, professional)

; Service dates
{.dates}
service_date = !date                        ; Date of service
service_end_date = date                     ; Service end date (if range)
received_date = date                        ; Claim received date

{@claim}

; Provider
{.provider}
provider_name = :                           ; Provider name
provider_npi = :                            ; Provider NPI
provider_type = (mtf, network, non_network) ; Provider type
par_provider = ?                            ; Participating provider

{@claim}

; Charges
{.charges}
billed_amount = #$:(0..)                    ; Billed charges
allowed_amount = #$:(0..)                   ; TRICARE allowed
medicare_paid = #$:(0..)                    ; Medicare paid (if TFL)
tricare_paid = #$:(0..)                     ; TRICARE paid
beneficiary_liability = #$:(0..)            ; Beneficiary pays

{@claim}

; Status
{.status}
status = !(denied, paid, pending, rejected)
processed_date = date                       ; Date processed
payment_date = date                         ; Payment date
denial_reason = :                           ; Denial reason

{@claim}

; ═══════════════════════════════════════════════════════════════════════════════
; MILITARY TREATMENT FACILITY (MTF)
; ═══════════════════════════════════════════════════════════════════════════════
; Per 32 CFR 199.6

{@mtf}
mtf_id = !:                                 ; MTF identifier (DMIS ID)
name = !:                                   ; MTF name

; Location
installation = :                            ; Military installation
address = @address                          ; Physical address

{@mtf}

; MTF type
{.type}
facility_type = (clinic, dental, hospital, medical_center)
branch = (air_force, army, dha, navy)       ; Service branch
teaching_facility = ?                       ; Teaching facility

{@mtf}

; Services
{.services}
emergency = ?                               ; Emergency services
inpatient = ?                               ; Inpatient services
outpatient = ?                              ; Outpatient services
pharmacy = ?                                ; Pharmacy
dental = ?                                  ; Dental services
specialties[] = :                           ; Medical specialties

{@mtf}

; TRICARE enrollment
accepting_prime = ?                         ; Accepting Prime enrollees
catchment_area = :                          ; Catchment area


; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Federal Employees Health Benefits (FEHB) Schema
; ═══════════════════════════════════════════════════════════════════════════════
; FEHB program structures for federal employee health coverage including plans,
; enrollment, premiums, and service areas. Derived from 5 USC Chapter 89 and
; 5 CFR Part 890.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.federal.fehb"
version = "1.0.0"
title = "Federal Employees Health Benefits Schema"
description = "FEHB program structures"

{$derivation}
source[0].authority = "GPO"
source[0].citation = "5 USC Chapter 89 - Health Insurance"
source[0].url = "https://www.law.cornell.edu/uscode/text/5/part-III/subpart-G/chapter-89"

source[1].authority = "GPO"
source[1].citation = "5 CFR Part 890 - FEHB Program"
source[1].url = "https://www.ecfr.gov/current/title-5/chapter-I/subchapter-B/part-890"

source[2].authority = "OPM"
source[2].citation = "FEHB Handbook"
source[2].url = "https://www.opm.gov/healthcare-insurance/healthcare/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial FEHB schema"
changelog[0].rationale = "Structure derived from 5 USC Chapter 89 and 5 CFR Part 890"

; ═══════════════════════════════════════════════════════════════════════════════
; FEHB PLAN
; ═══════════════════════════════════════════════════════════════════════════════
; Per 5 CFR 890.201

{@plan}
plan_code = !:                              ; OPM plan code (3 char)
carrier_code = !:                           ; Carrier code (2 char)
plan_year = !##:(1960..)                    ; Plan year
plan_name = !:                              ; Plan name

; Plan type - Per 5 CFR 890.201
{.type}
plan_type = !(comprehensive, fee_for_service, hdhp, hmo)
option = (high, standard)                   ; Plan option
nationwide = ?                              ; Nationwide availability

{@plan}

; Carrier
{.carrier}
carrier_name = :                            ; Carrier name
carrier_type = (association, carrier, hmo)  ; Carrier type
contract_number = :                         ; OPM contract number

{@plan}

; Service area - Per 5 CFR 890.201
{.service_area}
nationwide = ?                              ; Nationwide plan
states[] = :(2)                             ; States served
zip_codes[] = :                             ; ZIP codes served

{@plan}

; Premiums - Per 5 CFR 890.503
{.premiums}
biweekly_self_only = #$:(0..)               ; Self only biweekly
biweekly_self_plus_one = #$:(0..)           ; Self plus one biweekly
biweekly_self_family = #$:(0..)             ; Self and family biweekly
government_contribution_self = #$:(0..)     ; Government contribution
government_contribution_family = #$:(0..)   ; Government contribution family

{@plan}

; Benefits summary
{.benefits}
deductible_self = #$:(0..)                  ; Individual deductible
deductible_family = #$:(0..)                ; Family deductible
oop_max_self = #$:(0..)                     ; Individual OOP max
oop_max_family = #$:(0..)                   ; Family OOP max
coinsurance_in_network = #:(0..100)         ; In-network coinsurance
coinsurance_out_network = #:(0..100)        ; Out-of-network coinsurance

{@plan}

; HDHP/HSA - Per 5 CFR 890.204
{.hsa}
hsa_compatible = ?                          ; HSA compatible HDHP
hsa_contribution = #$:(0..)                 ; Employer HSA contribution

{@plan}

; ═══════════════════════════════════════════════════════════════════════════════
; ENROLLMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 5 CFR 890.301

{@enrollment}
enrollment_id = !:                          ; Enrollment ID
employee_id = !:                            ; Employee ID
plan_code = !:                              ; Plan code

; Enrollment type - Per 5 CFR 890.301
enrollment_type = !(self_and_family, self_only, self_plus_one)

; Employment status
{.employment}
employment_type = !(annuitant, employee, former_spouse, survivor, temporary, tcc)
agency_code = :                             ; Agency code
payroll_office = :                          ; Payroll office

{@enrollment}

; Coverage period
coverage = @enrollment_period               ; Enrollment period with status
plan_year = ##:(1960..)                     ; Plan year

{@enrollment}

; Enrollment event - Per 5 CFR 890.301
{.event}
event_type = !(initial, open_season, qle, termination, transfer)
event_date = date                           ; Event date
qle_type = :                                ; QLE type if applicable

{@enrollment}

; Premium payment
{.premium}
biweekly_premium = #$:(0..)                 ; Total biweekly premium
employee_share = #$:(0..)                   ; Employee share
government_share = #$:(0..)                 ; Government share
pre_tax = ?                                 ; Pre-tax premium

{@enrollment}

; Family members
{.members}
subscriber = @fehb_member                   ; Subscriber
dependents[] = @fehb_member                 ; Covered dependents

{@enrollment}

{@fehb_member}
member_id = !:                              ; Member ID
relationship = !(child, domestic_partner, self, spouse)
first_name = :                              ; First name
last_name = :                               ; Last name
dob = *date                                 ; Date of birth
ssn = *:                                    ; SSN
covered = ?                                 ; Currently covered
effective_date = date                       ; Coverage start
termination_date = date                     ; Coverage end

; ═══════════════════════════════════════════════════════════════════════════════
; OPEN SEASON
; ═══════════════════════════════════════════════════════════════════════════════
; Per 5 CFR 890.301

{@open_season}
year = !##:(1960..)                         ; Open season year
start_date = !date                          ; Start date (typically mid-November)
end_date = !date                            ; End date (typically mid-December)
effective_date = !date                      ; Coverage effective date (Jan 1)

; Changes allowed
{.changes}
plan_change = ?true                         ; Can change plans
enrollment_type_change = ?true              ; Can change enrollment type
cancel_enrollment = ?true                   ; Can cancel enrollment
enroll_new = ?true                          ; Can enroll for first time

{@open_season}

; ═══════════════════════════════════════════════════════════════════════════════
; QUALIFYING LIFE EVENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 5 CFR 890.301(g)

{@qle}
qle_id = !:                                 ; QLE ID
employee_id = !:                            ; Employee ID
event_type = !:                             ; Event type
event_date = !date                          ; Event date

; Event types - Per 5 CFR 890.301(g)
category = !(dependent_change, employment, family, open_season, other)

; Specific events
{.event}
marriage = ?                                ; Marriage
divorce = ?                                 ; Divorce
birth_adoption = ?                          ; Birth or adoption
death_dependent = ?                         ; Death of dependent
loss_other_coverage = ?                     ; Loss of other coverage
gain_other_coverage = ?                     ; Gain of other coverage

{@qle}

; QLE window
{.window}
request_deadline = date                     ; Deadline to request change
effective_date = date                       ; Coverage effective date
days_from_event = ##:(31..60)               ; Days from event allowed

{@qle}

; Documentation
{.documentation}
documentation_required = ?                  ; Documentation required
document_type = :                           ; Type of document
document_received = ?                       ; Document received

{@qle}

; ═══════════════════════════════════════════════════════════════════════════════
; ANNUITANT ENROLLMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 5 CFR 890.303

{@annuitant_enrollment}
annuitant_id = !:                           ; Annuitant ID
enrollment_id = !:                          ; Enrollment ID
csrs_or_fers = !(csrs, fers)                ; Retirement system

; Eligibility - Per 5 CFR 890.303
{.eligibility}
enrolled_five_years = ?                     ; Enrolled 5 years before retirement
continuous_enrollment = ?                   ; Continuous enrollment
immediate_annuity = ?                       ; Immediate annuity

{@annuitant_enrollment}

; Premium deduction
{.premium}
deducted_from_annuity = ?                   ; Premium from annuity
direct_pay = ?                              ; Direct pay
biweekly_premium = #$:(0..)                 ; Biweekly premium
monthly_premium = #$:(0..)                  ; Monthly premium

{@annuitant_enrollment}

; ═══════════════════════════════════════════════════════════════════════════════
; TEMPORARY CONTINUATION OF COVERAGE (TCC)
; ═══════════════════════════════════════════════════════════════════════════════
; Per 5 CFR 890.1103

{@tcc}
tcc_id = !:                                 ; TCC ID
former_employee_id = !:                     ; Former employee
plan_code = !:                              ; Plan code

; TCC type - Per 5 CFR 890.1103
{.type}
tcc_type = !(former_employee, former_spouse, child)
separation_date = date                      ; Separation date
qualifying_event = :                        ; Qualifying event

{@tcc}

; Coverage period - Per 5 CFR 890.1107
{.period}
tcc_start = date                            ; TCC start date
tcc_end = date                              ; TCC end date
max_months = ##:(18..36)                    ; Maximum months (18 or 36)

{@tcc}

; Premium - Per 5 CFR 890.1108
{.premium}
full_premium = #$:(0..)                     ; Full premium (100%+2%)
monthly_payment = #$:(0..)                  ; Monthly payment amount
administrative_charge = #$:(0..)            ; 2% administrative charge

{@tcc}

; ═══════════════════════════════════════════════════════════════════════════════
; FEHB DENTAL AND VISION (FEDVIP)
; ═══════════════════════════════════════════════════════════════════════════════
; Per 5 USC 8951-8960

{@fedvip}
enrollment_id = !:                          ; Enrollment ID
employee_id = !:                            ; Employee ID
plan_type = !(dental, vision)               ; Plan type

; Plan
{.plan}
plan_code = !:                              ; Plan code
carrier_name = :                            ; Carrier name
plan_name = :                               ; Plan name

{@fedvip}

; Enrollment type
enrollment_type = !(self_and_family, self_only, self_plus_one)

; Premium
{.premium}
biweekly_premium = #$:(0..)                 ; Biweekly premium
enrollee_pays = #$:(0..)                    ; Enrollee pays (no govt contribution)

{@fedvip}

; Coverage period
{.coverage}
effective_date = date                       ; Coverage start
termination_date = date                     ; Coverage end

{@fedvip}


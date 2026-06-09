; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Veterans Affairs Health Care Schema
; ═══════════════════════════════════════════════════════════════════════════════
; VA health care system structures covering veteran eligibility, enrollment,
; priority groups, copayments, and community care. Derived from 38 USC
; Chapter 17 and 38 CFR Part 17.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.federal.va"
version = "1.0.0"
title = "Veterans Affairs Health Care Schema"
description = "VA health care system structures"

{$derivation}
source[0].authority = "GPO"
source[0].citation = "38 USC Chapter 17 - Hospital, Nursing Home, Domiciliary, and Medical Care"
source[0].url = "https://www.law.cornell.edu/uscode/text/38/part-II/chapter-17"

source[1].authority = "GPO"
source[1].citation = "38 CFR Part 17 - Medical"
source[1].url = "https://www.ecfr.gov/current/title-38/chapter-I/part-17"

source[2].authority = "VA"
source[2].citation = "VA Health Benefits Handbook"
source[2].url = "https://www.va.gov/health-care/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial VA health care schema"
changelog[0].rationale = "Structure derived from 38 USC Chapter 17 and 38 CFR Part 17"

; ═══════════════════════════════════════════════════════════════════════════════
; VETERAN
; ═══════════════════════════════════════════════════════════════════════════════
; Per 38 CFR 17.36

{@veteran}
veteran_id = :                             ; VA patient identifier
edipi = :                                   ; DoD EDIPI

; Demographics
{.demographics}
first_name = :                             ; First name
middle_name = :                             ; Middle name
last_name = :                              ; Last name
dob = *date                                ; Date of birth
gender = (female, male)                     ; Gender
ssn = *:                                    ; SSN

{@veteran}

; Military service - Per 38 CFR 3.12a
{.service}
branch = (air_force, army, coast_guard, marine_corps, navy, space_force)
service_number = :                          ; Service number
entry_date = date                           ; Service entry date
discharge_date = date                       ; Discharge date
discharge_type = (bad_conduct, dishonorable, general, honorable, other_than_honorable)
character_of_discharge = :                  ; Character of service
combat_veteran = ?                          ; Combat veteran
era[] = :                                   ; Service eras (Vietnam, Gulf War, etc.)

{@veteran}

; Service-connected disability - Per 38 CFR 4
{.disability}
service_connected = ?                       ; Has SC disability
combined_rating = ##:(0..100)               ; Combined SC rating
individual_unemployability = ?              ; IU granted
special_monthly_compensation = ?            ; SMC

{@veteran}

; ═══════════════════════════════════════════════════════════════════════════════
; ENROLLMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 38 CFR 17.36

{@enrollment}
enrollment_id = :                          ; Enrollment ID
veteran_id = :                             ; Veteran ID
application_date = date                    ; Application date (VA Form 10-10EZ)

; Enrollment status - Per 38 CFR 17.36
enrollment_status = @enrollment_period      ; Enrollment period with status
rejection_reason = :                        ; Rejection reason

{@enrollment}

; Priority group - Per 38 CFR 17.36
{.priority}
priority_group = ##:(1..8)                 ; Priority group (1-8)
subpriority = :                             ; Subpriority (a-i)
; Priority 1: 50%+ SC or IU
; Priority 2: 30-40% SC
; Priority 3: Former POW, Purple Heart, etc.
; Priority 4: Aid & Attendance, catastrophically disabled
; Priority 5: Non-compensable SC, pension recipients
; Priority 6: Combat veterans (5 years), Agent Orange, etc.
; Priority 7: Below income threshold
; Priority 8: Above income threshold

{@enrollment}

; Eligibility
{.eligibility}
basic_eligibility = ?                       ; Meets basic eligibility
enhanced_eligibility = ?                    ; Enhanced eligibility
means_test_required = ?                     ; Means test required
means_test_completed = ?                    ; Means test completed

{@enrollment}

; ═══════════════════════════════════════════════════════════════════════════════
; PRIORITY GROUP ASSIGNMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 38 CFR 17.36(b)

{@priority_assignment}
veteran_id = :                             ; Veteran ID
assignment_date = date                     ; Assignment date

; Factors - Per 38 CFR 17.36(b)
{.factors}
service_connected_50_plus = ?               ; 50%+ SC rating
service_connected_30_40 = ?                 ; 30-40% SC rating
service_connected_10_20 = ?                 ; 10-20% SC rating
service_connected_0 = ?                     ; 0% SC rating
former_pow = ?                              ; Former POW
purple_heart = ?                            ; Purple Heart recipient
medal_of_honor = ?                          ; Medal of Honor
catastrophically_disabled = ?               ; Catastrophically disabled
aid_attendance = ?                          ; Aid & Attendance
housebound = ?                              ; Housebound
pension_recipient = ?                       ; Pension recipient
combat_veteran_5_year = ?                   ; Combat veteran (within 5 years)
agent_orange = ?                            ; Agent Orange exposure
camp_lejeune = ?                            ; Camp Lejeune water exposure

{@priority_assignment}

; Income assessment - Per 38 CFR 17.47
{.income}
gross_household_income = #$:(0..)           ; Gross household income
va_income_threshold = #$:(0..)              ; VA means test threshold
geographic_income_threshold = #$:(0..)      ; Geographic means test threshold
below_threshold = ?                         ; Below income threshold

{@priority_assignment}

; Assigned group
priority_group = ##:(1..8)                  ; Assigned priority group
subpriority = :                             ; Subpriority

; ═══════════════════════════════════════════════════════════════════════════════
; COPAYMENTS
; ═══════════════════════════════════════════════════════════════════════════════
; Per 38 CFR 17.108-17.111

{@copayment}
copayment_id = :                           ; Copayment ID
veteran_id = :                             ; Veteran ID
service_date = date                        ; Date of service

; Service type
{.service}
service_type = (inpatient, medication, outpatient)
service_description = :                     ; Description
facility_id = :                             ; VA facility

{@copayment}

; Copayment amount - Per 38 CFR 17.108
{.amount}
full_copay = #$:(0..)                       ; Full copay amount
reduced_copay = #$:(0..)                    ; Reduced copay if applicable
actual_copay = #$:(0..)                     ; Actual copay charged

{@copayment}

; Exemptions - Per 38 CFR 17.108(e)
{.exemptions}
exempt = ?                                  ; Copay exempt
exemption_reason = :                        ; Exemption reason
; 50%+ SC, former POW, Purple Heart, etc.
service_connected_care = ?                  ; SC condition care
hardship_exemption = ?                      ; Hardship exemption
below_threshold = ?                         ; Below income threshold

{@copayment}

; ═══════════════════════════════════════════════════════════════════════════════
; APPOINTMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per VHA scheduling directives

{@appointment}
appointment_id = :                         ; Appointment ID
veteran_id = :                             ; Veteran ID
facility_id = :                            ; VA facility

; Appointment details
{.details}
appointment_date = date                    ; Appointment date
appointment_time = :                        ; Time
appointment_type = (in_person, telehealth, telephone, video)
clinic_name = :                             ; Clinic name
specialty = :                               ; Medical specialty

{@appointment}

; Provider
{.provider}
provider_name = :                           ; Provider name
provider_type = (md, np, pa)                ; Provider type

{@appointment}

; Status
{.status}
status = (cancelled, completed, no_show, scheduled)
check_in_time = :                           ; Check-in time
cancellation_reason = :                     ; Cancellation reason

{@appointment}

; Community care - Per 38 CFR 17.4000
{.community_care}
community_care = ?                          ; Community care appointment
referral_number = :                         ; Referral number
community_provider = :                      ; Community provider name

{@appointment}

; ═══════════════════════════════════════════════════════════════════════════════
; COMMUNITY CARE
; ═══════════════════════════════════════════════════════════════════════════════
; Per 38 USC 1703 and 38 CFR 17.4000

{@community_care}
referral_id = :                            ; Referral ID
veteran_id = :                             ; Veteran ID
referral_date = date                       ; Referral date

; Eligibility criteria - Per 38 CFR 17.4010
{.eligibility}
service_not_available = ?                   ; Service not available at VA
wait_time_exceeded = ?                      ; Wait time standards exceeded
drive_time_exceeded = ?                     ; Drive time standards exceeded
grandfathered = ?                           ; Grandfathered community care
best_medical_interest = ?                   ; Best medical interest

{@community_care}

; Access standards - Per 38 CFR 17.4040
{.access_standards}
wait_time_standard = ##:(20..28)            ; Wait time standard (days)
actual_wait_time = ##:(0..)                 ; Actual VA wait time
drive_time_standard = ##:(30..60)           ; Drive time standard (minutes)
actual_drive_time = ##:(0..)                ; Actual drive time to VA

{@community_care}

; Authorization
{.authorization}
authorized = ?                              ; Community care authorized
authorization_number = :                    ; Authorization number
authorized_services[] = :                   ; Authorized services
valid_from = date                           ; Authorization start
valid_to = date                             ; Authorization end

{@community_care}

; Community provider
{.provider}
provider_name = :                           ; Provider name
provider_npi = :                            ; Provider NPI
in_network = ?                              ; In VA community care network

{@community_care}

; ═══════════════════════════════════════════════════════════════════════════════
; VA FACILITY
; ═══════════════════════════════════════════════════════════════════════════════
; Per VHA facility data

{@facility}
facility_id = :                            ; Station number
name = :                                   ; Facility name
visn = ##:(1..23)                           ; VISN number

; Location
address = @address                          ; Physical address

{@facility}

; Facility type
{.type}
facility_type = (cboc, domiciliary, medical_center, nursing_home, outpatient_clinic, vet_center)
complexity = (1a, 1b, 1c, 2, 3)             ; Complexity level
teaching_facility = ?                       ; Teaching facility

{@facility}

; Services
{.services}
emergency = ?                               ; Emergency department
inpatient = ?                               ; Inpatient
outpatient = ?                              ; Outpatient
mental_health = ?                           ; Mental health
pharmacy = ?                                ; Pharmacy
dental = ?                                  ; Dental
specialties[] = :                           ; Medical specialties

{@facility}

; ═══════════════════════════════════════════════════════════════════════════════
; TRAVEL REIMBURSEMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 38 CFR 70

{@travel_reimbursement}
claim_id = :                               ; Claim ID
veteran_id = :                             ; Veteran ID
travel_date = date                         ; Date of travel

; Trip details
{.trip}
origin = :                                  ; Origin address
destination = :                             ; VA facility
round_trip_miles = #:(0..)                  ; Round trip miles
mode = (bus, mileage, plane, special)       ; Mode of transport

{@travel_reimbursement}

; Eligibility - Per 38 CFR 70.10
{.eligibility}
eligible = ?                                ; Eligible for reimbursement
service_connected_travel = ?                ; Travel for SC care
pension_recipient = ?                       ; Pension with A&A or HB
income_under_threshold = ?                  ; Income under threshold
special_mode_required = ?                   ; Special mode medically required

{@travel_reimbursement}

; Payment
{.payment}
mileage_rate = #:(0..1)                     ; Per mile rate
total_mileage_amount = #$:(0..)             ; Mileage reimbursement
deductible = #$:(0..18)                     ; Deductible (round trip)
total_payment = #$:(0..)                    ; Total payment
payment_status = (denied, paid, pending)    ; Status

{@travel_reimbursement}


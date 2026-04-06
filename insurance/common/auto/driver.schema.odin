; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Auto Driver Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Base driver fields shared by both personal and commercial auto. Contains only
; fields applicable to all driver types; personal and commercial schemas extend
; this with their specific attributes.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.auto.driver"
version = "1.0.0"
title = "Auto Driver Schema"
description = "Base driver fields shared by personal and commercial auto"

{$derivation}
source[0].authority = "American Association of Motor Vehicle Administrators"
source[0].citation = "Driver License Agreement (DLA)"
source[0].url = "https://www.aamva.org/technology/systems/driver-license-data-verification"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Core driver identification and attributes common to all auto insurance"

changelog[0].date = 2025-12-13
changelog[0].change = "Initial driver core schema - refactored from monolithic driver schema"
changelog[0].rationale = "Clean separation of shared vs personal vs commercial fields"

; ═══════════════════════════════════════════════════════════════════════════════
; Driver Core (Shared Fields Only)
; ═══════════════════════════════════════════════════════════════════════════════

{@driver}
= @person                                     ; Inherits person fields

id = :                                        ; Driver identifier
number = ##:(1..)                             ; Position on policy

; ───────────────────────────────────────────────────────────────────────────────
; Identification
; ───────────────────────────────────────────────────────────────────────────────
{.name}
first = !:
last = !:

prefix = :
middle = :
suffix = :

{@driver}
date_of_birth = *!date

ssn = *:format ssn                            ; US Social Security Number
sin = *:/^\d{3}-\d{3}-\d{3}$/                 ; Canadian Social Insurance Number
gender = (female, male, non_binary)
marital_status = (common_law, divorced, domestic_partner, married, single, widowed)

; ───────────────────────────────────────────────────────────────────────────────
; Contact (if different from named insured)
; ───────────────────────────────────────────────────────────────────────────────
; Address - uses shared @address type (US and Canada)
address = @address

; Contact
phones[] = *@phone
email = *@email
email_declined = ?

; ───────────────────────────────────────────────────────────────────────────────
; Licensing (Base - both personal and commercial use)
; ───────────────────────────────────────────────────────────────────────────────
{.license}
= @license_credential                         ; Use shared license credential type

; Driver-specific extensions
class = :                             ; License class (D, M, CDL-A, etc.)
first_licensed_date = date
first_licensed_state_province = :(2) ; First licensed jurisdiction
first_licensed_age = ##:(14..100)
months_licensed = ##
years_licensed = ##

; License details
restrictions[] = :                    ; Restriction codes
total_points = ##                     ; Total points on license
learners_permit = ?
international = ?
international_country = :(2..3)

{@driver}
; Prior license (if different jurisdiction)
{.prior_license}
= @license_credential                         ; Use shared license credential type

{@driver}

; ───────────────────────────────────────────────────────────────────────────────
; Relationship
; ───────────────────────────────────────────────────────────────────────────────
relation = !(
    child,
    domestic_partner,
    employee,
    named_insured,
    non_resident,
    other,
    other_resident,
    owner_operator,
    parent,
    relative,
    spouse
)

; ───────────────────────────────────────────────────────────────────────────────
; Driver Type/Status
; ───────────────────────────────────────────────────────────────────────────────
driver_type = (excluded, occasional, rated, unlisted)
excluded = ?                                  ; Excluded from all coverage
excluded_reason = :if excluded = true
excluded_date = date:if excluded = true
excluded_signature = ?:if excluded = true

occasional_operator = ?                       ; Occasional driver flag
primary_operator = ?                       ; Is primary operator of a vehicle
primary_vehicle = ##:if primary_operator = true

; ───────────────────────────────────────────────────────────────────────────────
; Employment (Core)
; ───────────────────────────────────────────────────────────────────────────────
{.employment}
status = (employed, homemaker, military, retired, self_employed, student, unemployed)
occupation = :
industry_code = :
employer = :                                  ; Employer company name (consistent with @person)
employed_since = date                         ; Date started with employer

{@driver}

; ───────────────────────────────────────────────────────────────────────────────
; Education & Training (Shared)
; ───────────────────────────────────────────────────────────────────────────────
{.education}
level = (
    associates,
    bachelors,
    doctorate,
    high_school,
    masters,
    no_high_school,
    professional,
    some_college,
    vocational
)

{@driver}
{.training}
drivers_ed = ?
defensive_driving = ?
defensive_driving_date = date
defensive_driving_expiration = date

{@driver}

; ───────────────────────────────────────────────────────────────────────────────
; Military
; ───────────────────────────────────────────────────────────────────────────────
military_status = (active, none, reserve, retired, veteran)

; ───────────────────────────────────────────────────────────────────────────────
; Prior Insurance
; ───────────────────────────────────────────────────────────────────────────────
{.prior_insurance}
prior = ?
carrier_ref = :                      ; Prior insurance carrier reference
policy_number = :
effective_date = date
expiration_date = date

{.limits}
bi_per_person = ##
bi_per_accident = ##
pd = ##

{@prior_insurance}
months_covered = ##
continuous = ?
days_lapsed = ##

{@driver}

; ───────────────────────────────────────────────────────────────────────────────
; MVR (Motor Vehicle Report)
; ───────────────────────────────────────────────────────────────────────────────
{.mvr}
ordered = ?
order_date = date
received_date = date
url = :
status = (error, not_found, pending, received)

{@driver}

; ───────────────────────────────────────────────────────────────────────────────
; Consent & Compliance
; ───────────────────────────────────────────────────────────────────────────────
{.consent}
fcra = ?                              ; Fair Credit Reporting Act
fcra_date = date
fcra_gathered_by = :
tcpa = ?                              ; Telephone Consumer Protection Act
tcpa_date = date
agency_disclosure = ?
agency_disclosure_date = date

{@driver}

; ───────────────────────────────────────────────────────────────────────────────
; Rating Classification (Core)
; ───────────────────────────────────────────────────────────────────────────────
{.rating}
class_code = :
tier = :
points = ##

{@driver}

; ───────────────────────────────────────────────────────────────────────────────
; Violation/Accident Summary
; ───────────────────────────────────────────────────────────────────────────────
violations_count = ##
accidents_count = ##
suspensions_count = ##
total_points = ##

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, deleted, pending, terminated)
added_date = date
deleted_date = date
delete_reason = :

; ═══════════════════════════════════════════════════════════════════════════════
; Driver Violations (Shared - applies to both personal and commercial)
; ═══════════════════════════════════════════════════════════════════════════════

{@driver.violations[]}
id = :
sequence = ##

; ───────────────────────────────────────────────────────────────────────────────
; Violation Identification
; ───────────────────────────────────────────────────────────────────────────────
code = !(
    ; Major violations (alcohol/drug related)
    vc-DUI,                                   ; Driving Under Influence
    vc-DWI,                                   ; Driving While Intoxicated
    vc-DWAI,                                  ; Driving While Ability Impaired
    vc-OUI,                                   ; Operating Under Influence
    vc-DRUGDRIVE,                             ; Driving Under Drug Influence
    vc-REFTEST,                               ; Refused Chemical Test
    vc-OPENCONTAINER,                         ; Open Container

    ; Major violations (serious)
    vc-RECKLESS,                              ; Reckless Driving
    vc-RACING,                                ; Racing/Speed Contest
    vc-FLEEING,                               ; Fleeing/Eluding Police
    vc-HITRUN,                                ; Hit and Run
    vc-HITRUNINJ,                             ; Hit and Run with Injury
    vc-VEHICHOM,                              ; Vehicular Homicide
    vc-VEHICMAN,                              ; Vehicular Manslaughter
    vc-VEHICASS,                              ; Vehicular Assault
    vc-DRIVSUSPD,                             ; Driving While Suspended
    vc-DRIVREVKD,                             ; Driving While Revoked
    vc-NOLICENSE,                             ; Driving Without License
    vc-NOINSURE,                              ; No Insurance/Proof
    vc-FELONY,                                ; Felony Involving Vehicle

    ; Speeding violations
    vc-SPEED,                                 ; Speeding (general)
    vc-SPEED1-10,                             ; 1-10 over limit
    vc-SPEED11-15,                            ; 11-15 over limit
    vc-SPEED16-20,                            ; 16-20 over limit
    vc-SPEED21-25,                            ; 21-25 over limit
    vc-SPEED26-30,                            ; 26-30 over limit
    vc-SPEED31PLUS,                           ; 31+ over limit
    vc-SPEEDZONE,                             ; Speeding in School/Work Zone
    vc-TOOFAST,                               ; Too Fast for Conditions
    vc-TOOSLOW,                               ; Impeding Traffic

    ; Moving violations
    vc-REDLIGHT,                              ; Red Light Violation
    vc-STOPSIGN,                              ; Stop Sign Violation
    vc-YIELDFAIL,                             ; Failure to Yield
    vc-RIGHTWAY,                              ; Right of Way Violation
    vc-FOLLOWCLOSE,                           ; Following Too Closely
    vc-IMPROPASS,                             ; Improper Passing
    vc-IMPROTURN,                             ; Improper Turn
    vc-IMPROLANE,                             ; Improper Lane Change
    vc-IMPRBACK,                              ; Improper Backing
    vc-WRONGWAY,                              ; Wrong Way/Direction
    vc-CENTERLINE,                            ; Crossing Centerline
    vc-CARELESS,                              ; Careless Driving
    vc-NEGLIGENT,                             ; Negligent Driving
    vc-ILLUTURN,                              ; Illegal U-Turn
    vc-DISOBEY,                               ; Disobeying Traffic Device
    vc-RRXING,                                ; Railroad Crossing Violation
    vc-SCHOOL,                                ; School Bus Violation
    vc-EMERGEVEH,                             ; Emergency Vehicle Violation
    vc-TEXTING,                               ; Texting While Driving
    vc-CELLPHONE,                             ; Cell Phone Violation
    vc-DISTRACT,                              ; Distracted Driving

    ; Safety violations
    vc-SEATBELT,                              ; Seatbelt Violation
    vc-CHILDSEAT,                             ; Child Restraint Violation
    vc-HELMET,                                ; Helmet Violation (motorcycle)

    ; License violations
    vc-LICRESTR,                              ; Violate License Restriction
    vc-NOENDORSE,                             ; No Proper Endorsement
    vc-PERMITVIOL,                            ; Permit Violation

    ; Equipment violations
    vc-DEFEQUIP,                              ; Defective Equipment
    vc-LIGHTING,                              ; Lighting Violation
    vc-WINDOW,                                ; Window Tint Violation

    ; Accident-related
    vc-ACCFAULT,                              ; At-Fault Accident
    vc-ACCNOFAULT,                            ; Not-At-Fault Accident
    vc-ACCPD,                                 ; Accident - Property Damage Only
    vc-ACCINJURY,                             ; Accident - With Injury
    vc-ACCFATAL,                              ; Accident - Fatality

    ; Commercial-specific (included in core for MVR compatibility)
    vc-HOSVIOL,                               ; Hours of Service Violation
    vc-LOGBOOK,                               ; Logbook Violation
    vc-OVERWEIGHT,                            ; Overweight Violation
    vc-HAZMAT,                                ; Hazmat Violation
    vc-OOSORDER,                              ; Out of Service Order Violation

    ; Miscellaneous
    vc-MISCMOV,                               ; Miscellaneous Moving
    vc-MISCNMOV,                              ; Miscellaneous Non-Moving
    vc-OTHER                                  ; Other Violation
)
description = :
custom_description = :

; ───────────────────────────────────────────────────────────────────────────────
; Violation Details
; ───────────────────────────────────────────────────────────────────────────────
date = !date
conviction_date = date
convicted = ?
at_fault = ?
{.location}
city = :
state_province = :(2)                 ; US state or Canadian province
description = :

{@driver.violations[]}
police_report = ?

; ───────────────────────────────────────────────────────────────────────────────
; Violation Attributes
; ───────────────────────────────────────────────────────────────────────────────
; Speeding
{.speed}
over_limit = ##
posted_limit = ##
actual_speed = ##

{@driver.violations[]}

; DUI/DWI
bac_level = #:(0..1)                          ; Blood alcohol level

; Accidents
{.damage}
bodily_injury = #$:(0..)
property_damage = #$:(0..)
total_claim = #$:(0..)

{@driver.violations[]}

; ───────────────────────────────────────────────────────────────────────────────
; Points & Rating Impact
; ───────────────────────────────────────────────────────────────────────────────
points = ##
company_points = ##                           ; Carrier-assigned points
surcharge_amount = #$:(0..)
surcharge_percent = #:(0..500)
responsibility_percent = ##:(0..100)          ; Percent at fault

; ───────────────────────────────────────────────────────────────────────────────
; Entry Metadata
; ───────────────────────────────────────────────────────────────────────────────
entry_source = (
    agent,                                    ; Agent entered
    clue,                                     ; From CLUE report
    customer,                                 ; Customer disclosed
    mvr,                                      ; From MVR report
    mvr_modified,                             ; MVR modified by agent
    psp                                       ; From PSP report (commercial)
)
entry_date = date

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, deleted, disputed)

; ═══════════════════════════════════════════════════════════════════════════════
; Driver Suspensions (Shared)
; ═══════════════════════════════════════════════════════════════════════════════

{@driver.suspensions[]}
id = :
sequence = ##

action_type = !(
    administrative,
    cancelled,
    denied,
    disqualified,                             ; CDL disqualification
    dui_related,
    failure_to_appear,
    financial_responsibility,
    medical,
    other,
    out_of_service,                           ; Commercial OOS order
    points_accumulated,
    restricted,
    revoked,
    suspended
)
action_date = !date
reinstatement_date = date
state_province = :(2)                         ; US state or Canadian province
reason = :
duration_days = ##
status = (active, pending, resolved)

; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Personal Auto Vehicle Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Personal auto vehicle extending the base vehicle schema with personal-specific
; fields for commute distance, rideshare/TNC use, telematics data, and vehicle
; usage classification.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/auto/vehicle.schema.odin" as veh

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.auto.vehicle"
version = "1.0.0"
title = "Personal Auto Vehicle Schema"
description = "Personal vehicle extending core with personal-specific fields"

{$derivation}
source[0].authority = "California Department of Insurance"
source[0].citation = "CA CCR Title 10, § 2632.5 (Annual Miles Rating)"
source[0].url = "https://www.law.cornell.edu/regulations/california/10-CCR-2632.5"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Personal auto vehicle data elements including commute, telematics, and personal use"

changelog[0].date = 2025-12-13
changelog[0].change = "Initial personal vehicle schema - refactored from monolithic schema"
changelog[0].rationale = "Clean separation of personal-specific vehicle fields"

; ═══════════════════════════════════════════════════════════════════════════════
; Personal Vehicle (Extends Core)
; ═══════════════════════════════════════════════════════════════════════════════

{@personal_vehicle}
= @veh.vehicle                                 ; Inherit all base vehicle fields

; ───────────────────────────────────────────────────────────────────────────────
; Personal Vehicle Type Classification
; ───────────────────────────────────────────────────────────────────────────────
type = (antique, atv, car, convertible, coupe, exotic, golf_cart, kit_car, minivan, motor_home, motorcycle, other, suv, trailer, truck, van, wagon)
truck_size = (half_ton, one_ton, quarter_ton, three_quarter_ton):if type = truck

{.antique}
agreed_value = ?                               ; Agreed value coverage
limited_use = ?                                ; Limited use restriction
mileage_restriction = ##                       ; Annual mile limit
year_threshold = ##                            ; Years old to qualify

{@personal_vehicle}

; ───────────────────────────────────────────────────────────────────────────────
; Personal Usage
; ───────────────────────────────────────────────────────────────────────────────
{.usage}
business_miles = ##                            ; Business miles driven
commute_days = ##                              ; Days per week commuting
commute_destination_territory = :              ; Territory code of work location
commute_miles = ##                             ; One-way commute distance
days_driven_per_week = ##                      ; Days per week driven
percent_business = ##:(0..100)                 ; Business use percentage

{@personal_vehicle}

; ───────────────────────────────────────────────────────────────────────────────
; Rideshare Usage
; ───────────────────────────────────────────────────────────────────────────────
{.rideshare}
active = ?                                     ; Rideshare active flag
company = :                                    ; Uber, Lyft, etc.
coverage_period = (all, period_1, period_2, period_3)
hours_per_week = ##                            ; Hours per week

{@personal_vehicle}

; ───────────────────────────────────────────────────────────────────────────────
; Delivery Gig Usage
; ───────────────────────────────────────────────────────────────────────────────
{.delivery}
active = ?                                     ; Delivery gig active flag
company = :                                    ; DoorDash, UberEats, Amazon Flex, etc.
hours_per_week = ##                            ; Hours per week
type = (food, grocery, other, package)         ; Delivery type

{@personal_vehicle}

; ───────────────────────────────────────────────────────────────────────────────
; Carpool
; ───────────────────────────────────────────────────────────────────────────────
{.carpool}
active = ?                                     ; Carpool active flag
passenger_count = ##                           ; Number of passengers
vanpool = ?                                    ; Formal vanpool arrangement

{@personal_vehicle}

; ───────────────────────────────────────────────────────────────────────────────
; Youthful Operators
; ───────────────────────────────────────────────────────────────────────────────
youthful_operator_count = ##                   ; Number of drivers under 25

; ───────────────────────────────────────────────────────────────────────────────
; Alternate Garaging
; ───────────────────────────────────────────────────────────────────────────────
alternate_state_percent = ##:(0..100)          ; Percent time in alternate state/province
alternate_state_province = :(2)                ; Alternate US state or Canadian province

; ───────────────────────────────────────────────────────────────────────────────
; Telematics / Usage-Based Insurance
; ───────────────────────────────────────────────────────────────────────────────
{.telematics}
active = ?                                     ; Device active flag
device_install_date = date                     ; Device installation date
device_serial = :                              ; Device serial number
device_type = (aftermarket, factory_installed, mobile_app, none, obd_dongle)
device_vendor = :                              ; Device vendor name
enrolled = ?                                   ; Telematics enrollment flag
enrollment_date = date                         ; Enrollment date

{.score}
acceleration = ##:(0..100)                     ; Acceleration score
braking = ##:(0..100)                          ; Braking score
cornering = ##:(0..100)                        ; Cornering score
date = date                                    ; Score date
mileage = ##:(0..100)                          ; Mileage score
overall = ##:(0..1000)                         ; Overall score
phone_distraction = ##:(0..100)                ; Phone distraction score
speeding = ##:(0..100)                         ; Speeding score
time_of_day = ##:(0..100)                      ; Time of day score

{.summary}
avg_daily_miles = #                            ; Average daily miles
hard_accel_per_1000_miles = #                  ; Hard accelerations per 1000 miles
hard_brakes_per_1000_miles = #                 ; Hard brakes per 1000 miles
highway_percent = ##:(0..100)                  ; Highway driving percentage
night_driving_percent = ##:(0..100)            ; Night driving percentage
total_miles = ##                               ; Total miles tracked
total_trips = ##                               ; Total trips tracked

{@personal_vehicle}

; ───────────────────────────────────────────────────────────────────────────────
; Personal Vehicle Customization
; ───────────────────────────────────────────────────────────────────────────────
{.customization}
custom_equipment = ?                           ; Has custom equipment
custom_value = #$                              ; Custom equipment value
description = :                                ; Customization description
types[] = (audio_system, body_kit, interior, lift_kit, lighting, lowering_kit, other, paint_wrap, performance_exhaust, turbo_supercharger, wheels_tires)

{.sound_system}
aftermarket = ?                                ; Aftermarket sound system
value = #$                                     ; Sound system value

{@personal_vehicle}

; ───────────────────────────────────────────────────────────────────────────────
; High Theft / Special Indicators
; ───────────────────────────────────────────────────────────────────────────────
high_theft = ?                                 ; On high-theft vehicle list
previously_leased = ?                          ; Was previously a lease vehicle

; ───────────────────────────────────────────────────────────────────────────────
; Personal Rating Symbols
; ───────────────────────────────────────────────────────────────────────────────
{.rating}
bipd_symbol = :                                ; BI/PD rating symbol
damageability_code = :                         ; Damageability code
med_pay_symbol = :                             ; Medical payments symbol
performance_code = :                           ; Performance code
physical_damage_class = :                      ; Physical damage class
pip_symbol = :                                 ; PIP symbol

{@personal_vehicle}

; ───────────────────────────────────────────────────────────────────────────────
; Residual/Assigned Risk Market
; ───────────────────────────────────────────────────────────────────────────────
liability_refused = ?                          ; Liability coverage refused
liability_refused_reason = :                   ; Reason for refusal
residual_market = ?                            ; Residual market flag
residual_market_tier = :                       ; Residual market tier

; ───────────────────────────────────────────────────────────────────────────────
; Statistical Reporting
; ───────────────────────────────────────────────────────────────────────────────
{.statistical}
accident_year = ##:(1900..2100)                ; Accident year
earned_exposure = #                            ; Earned exposure
policy_year = ##:(1900..2100)                  ; Policy year
voluntary_market = ?                           ; Voluntary market flag
written_exposure = #                           ; Written exposure

; ===============================================================================
; ODIN Healthcare FHIR Types
; ===============================================================================
; Reusable FHIR-derived type definitions for healthcare schemas including
; Identifier, HumanName, Address, CodeableConcept, Reference, and other
; foundational data types. Follows FHIR R4/R5 specifications (CC0 public domain).
; ===============================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.types"
version = "1.0.0"
title = "Healthcare FHIR Types"
description = "FHIR-derived type definitions for healthcare schemas"

{$derivation}
source[0].authority = "HL7"
source[0].citation = "HL7 FHIR R4 - Data Types"
source[0].url = "https://hl7.org/fhir/R4/datatypes.html"

source[1].authority = "HL7"
source[1].citation = "HL7 FHIR R5 - Foundation Module"
source[1].url = "https://hl7.org/fhir/R5/foundation-module.html"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial healthcare common types schema"
changelog[0].rationale = "Base types derived from FHIR R4/R5 data types"

changelog[1].date = 2025-12-20
changelog[1].change = "Renamed all types with @fhir_ prefix to avoid collision with common types"

; ===============================================================================
; FHIR IDENTIFIER
; ===============================================================================
; FHIR: Identifier - https://hl7.org/fhir/R4/datatypes.html#Identifier

{@fhir_identifier}
use = (official, old, secondary, temp, usual)  ; Purpose of identifier
system = :                                    ; Namespace for identifier value
value = :                                    ; The identifier value
period_start = date                           ; Start of validity period
period_end = date                             ; End of validity period
assigner = :                                  ; Organization that issued ID

; ===============================================================================
; FHIR HUMAN NAME
; ===============================================================================
; FHIR: HumanName - https://hl7.org/fhir/R4/datatypes.html#HumanName

{@fhir_human_name}
use = (anonymous, maiden, nickname, official, old, temp, usual)
text = :                                      ; Full text representation
family = :                                    ; Family name (surname)
given[] = :                                   ; Given names (first, middle)
prefix[] = :                                  ; Parts that come before name (Dr, Mr)
suffix[] = :                                  ; Parts that come after name (Jr, PhD)
period_start = date                           ; Name valid from
period_end = date                             ; Name valid to

; ===============================================================================
; FHIR ADDRESS
; ===============================================================================
; FHIR: Address - https://hl7.org/fhir/R4/datatypes.html#Address

{@fhir_address}
use = (billing, home, old, temp, work)        ; Purpose of address
type = (both, physical, postal)               ; Address type
text = :                                      ; Full text representation
line[] = :                                    ; Street address lines
city = :                                      ; City name
district = :                                  ; District/county
state = :                                     ; State/province/region
postal_code = :                               ; Postal/ZIP code
country = :                                   ; Country (ISO 3166)
period_start = date                           ; Address valid from
period_end = date                             ; Address valid to

; ===============================================================================
; FHIR CONTACT POINT
; ===============================================================================
; FHIR: ContactPoint - https://hl7.org/fhir/R4/datatypes.html#ContactPoint

{@fhir_contact_point}
system = (email, fax, other, pager, phone, sms, url)
value = :                                    ; Contact point value
use = (home, mobile, old, temp, work)         ; Purpose of contact
rank = ##:(1..)                               ; Preference order
period_start = date                           ; Valid from
period_end = date                             ; Valid to

; ===============================================================================
; FHIR CODEABLE CONCEPT
; ===============================================================================
; FHIR: CodeableConcept - https://hl7.org/fhir/R4/datatypes.html#CodeableConcept

{@fhir_codeable_concept}
coding[] = @fhir_coding                       ; Code(s) defined by a system
text = :                                      ; Plain text representation

{@fhir_coding}
system = :                                    ; Code system URI
version = :                                   ; Version of code system
code = :                                     ; Code value
display = :                                   ; Human readable display
user_selected = ?                             ; User selected this code

; ===============================================================================
; FHIR QUANTITY
; ===============================================================================
; FHIR: Quantity - https://hl7.org/fhir/R4/datatypes.html#Quantity

{@fhir_quantity}
value = #                                     ; Numerical value
comparator = (less_than, less_or_equal, greater_or_equal, greater_than)
unit = :                                      ; Unit representation
system = :                                    ; System defining units (e.g., UCUM)
code = :                                      ; Coded form of unit

; ===============================================================================
; FHIR RANGE
; ===============================================================================
; FHIR: Range - https://hl7.org/fhir/R4/datatypes.html#Range

{@fhir_range}
low = @fhir_quantity                          ; Low limit
high = @fhir_quantity                         ; High limit

; ===============================================================================
; FHIR PERIOD
; ===============================================================================
; FHIR: Period - https://hl7.org/fhir/R4/datatypes.html#Period

{@fhir_period}
start = timestamp                             ; Starting time with inclusive boundary
end = timestamp                               ; End time with inclusive boundary

; ===============================================================================
; FHIR REFERENCE
; ===============================================================================
; FHIR: Reference - https://hl7.org/fhir/R4/references.html

{@fhir_reference}
reference = :                                 ; Literal reference (URL or relative)
type = :                                      ; Resource type
identifier = @fhir_identifier                 ; Logical reference
display = :                                   ; Text description of target

; ===============================================================================
; FHIR ANNOTATION
; ===============================================================================
; FHIR: Annotation - https://hl7.org/fhir/R4/datatypes.html#Annotation

{@fhir_annotation}
author_reference = @fhir_reference            ; Individual responsible
author_string = :                             ; Individual responsible (string)
time = timestamp                              ; When annotation was made
text = :                                     ; The annotation content

; ===============================================================================
; FHIR ATTACHMENT
; ===============================================================================
; FHIR: Attachment - https://hl7.org/fhir/R4/datatypes.html#Attachment

{@fhir_attachment}
content_type = :                              ; MIME type of content
language = :                                  ; Human language (BCP-47)
data = ^                                      ; Base64 encoded data
url = :                                       ; URL where data can be found
size = ##:(0..)                               ; Number of bytes
hash = ^sha1                                  ; SHA-1 hash of data
title = :                                     ; Label for display
creation = timestamp                          ; Date attachment was created

; ===============================================================================
; FHIR MONEY
; ===============================================================================
; FHIR: Money - https://hl7.org/fhir/R4/datatypes.html#Money

{@fhir_money}
value = #$                                    ; Numerical value
currency = :(3)                               ; ISO 4217 currency code

; ===============================================================================
; FHIR AGE
; ===============================================================================
; FHIR: Age (specialization of Quantity)

{@fhir_age}
value = #:(0..)                              ; Numerical age value
unit = :(a, d, h, min, mo, wk)                ; Unit (years, days, hours, etc.)
system = : "http://unitsofmeasure.org"        ; UCUM system
code = :                                      ; UCUM code

; ===============================================================================
; FHIR DOSAGE
; ===============================================================================
; FHIR: Dosage - https://hl7.org/fhir/R4/dosage.html

{@fhir_dosage}
sequence = ##:(1..)                           ; Order of dosage instructions
text = :                                      ; Free text instructions
additional_instruction[] = @fhir_codeable_concept  ; Additional instructions
patient_instruction = :                       ; Patient-oriented instructions
timing = @fhir_timing                         ; When medication should be administered
as_needed = ?                                 ; Take as needed
as_needed_for = @fhir_codeable_concept        ; Condition for as-needed
site = @fhir_codeable_concept                 ; Body site to administer
route = @fhir_codeable_concept                ; Route of administration
method = @fhir_codeable_concept               ; How drug is administered
max_dose_per_period = @fhir_ratio             ; Maximum dose per time period
max_dose_per_administration = @fhir_quantity  ; Maximum dose per administration
max_dose_per_lifetime = @fhir_quantity        ; Maximum lifetime dose

; Dose and rate
{.dose_rate}
type = @fhir_codeable_concept                 ; Type of dose (calculated, ordered)
dose_range = @fhir_range                      ; Dose range
dose_quantity = @fhir_quantity                ; Dose amount
rate_ratio = @fhir_ratio                      ; Dose rate ratio
rate_range = @fhir_range                      ; Dose rate range
rate_quantity = @fhir_quantity                ; Dose rate quantity

{@fhir_dosage}

; ===============================================================================
; FHIR TIMING
; ===============================================================================
; FHIR: Timing - https://hl7.org/fhir/R4/datatypes.html#Timing

{@fhir_timing}
event[] = timestamp                           ; When the event occurs
code = @fhir_codeable_concept                 ; Timing abbreviation (BID, TID, etc.)

; Repeat pattern
{.repeat}
bounds_duration = @fhir_duration              ; Length of time
bounds_range = @fhir_range                    ; Range of length of time
bounds_period = @fhir_period                  ; Start and end dates
count = ##:(0..)                              ; Number of times to repeat
count_max = ##:(0..)                          ; Maximum number of times
duration = #                                  ; How long when it happens
duration_max = #                              ; Maximum duration
duration_unit = (a, d, h, min, mo, s, wk)     ; Unit of duration
frequency = ##:(0..)                          ; Event occurs frequency times per period
frequency_max = ##:(0..)                      ; Maximum frequency
period = #                                    ; Event occurs frequency times per period
period_max = #                                ; Maximum period
period_unit = (a, d, h, min, mo, s, wk)       ; Unit of period
day_of_week[] = (fri, mon, sat, sun, thu, tue, wed)
time_of_day[] = time                          ; Time of day for action
when[] = (ac, acd, acm, acv, c, cd, cm, cv, hs, pc, pcd, pcm, pcv, wake)  ; Code for time period of day
offset = ##:(0..)                             ; Minutes from event before/after

{@fhir_timing}

; ===============================================================================
; FHIR RATIO
; ===============================================================================
; FHIR: Ratio - https://hl7.org/fhir/R4/datatypes.html#Ratio

{@fhir_ratio}
numerator = @fhir_quantity                    ; Numerator value
denominator = @fhir_quantity                  ; Denominator value

; ===============================================================================
; FHIR DURATION
; ===============================================================================
; FHIR: Duration (specialization of Quantity)

{@fhir_duration}
value = #                                    ; Numerical value
unit = :                                      ; String unit representation
system = : "http://unitsofmeasure.org"        ; UCUM system
code = :                                      ; UCUM code

; ===============================================================================
; FHIR SIMPLE QUANTITY
; ===============================================================================
; FHIR: SimpleQuantity (Quantity without comparator)

{@fhir_simple_quantity}
value = #                                    ; Numerical value
unit = :                                      ; Unit representation
system = :                                    ; System defining units
code = :                                      ; Coded form of unit

; ===============================================================================
; FHIR META
; ===============================================================================
; FHIR: Meta - https://hl7.org/fhir/R4/resource.html#Meta

{@fhir_meta}
version_id = :                                ; Version specific identifier
updated = timestamp                           ; When resource last changed
source = :                                    ; Source of resource content
profile[] = :                                 ; Profiles this resource claims to conform to
security[] = @fhir_coding                     ; Security labels
tag[] = @fhir_coding                          ; Tags applied to resource


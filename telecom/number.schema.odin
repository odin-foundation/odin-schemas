; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Telecom Number Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Telephone number management, local number portability (LNP), Local Service
; Request (LSR), Firm Order Confirmation (FOC), provisioning, and inventory.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.telecom.number"
version = "1.0.0"
title = "Telecom Number Management Schema"
description = "Telephone numbers, porting (LNP), provisioning, and inventory"

{$derivation}
source[0].authority = "Federal Communications Commission"
source[0].citation = "47 CFR Part 52 - Numbering"
source[0].url = "https://www.ecfr.gov/current/title-47/chapter-I/subchapter-B/part-52"

source[1].authority = "North American Numbering Plan Administration"
source[1].citation = "NANP - North American Numbering Plan"
source[1].url = "https://www.nanpa.com/"

source[2].authority = "Alliance for Telecommunications Industry Solutions"
source[2].citation = "ATIS-0300115 - LNP Operational and Intercarrier Guidelines"
source[2].url = "https://www.atis.org/"

source[3].authority = "Federal Communications Commission"
source[3].citation = "47 CFR 52.23 - Deployment of Long-Term Database Methods for Number Portability"
source[3].url = "https://www.ecfr.gov/current/title-47/chapter-I/subchapter-B/part-52/section-52.23"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial number management schema"
changelog[0].rationale = "Number and porting structure derived from FCC Part 52 and NANP/ATIS standards"

; ═══════════════════════════════════════════════════════════════════════════════
; TELEPHONE NUMBER
; ═══════════════════════════════════════════════════════════════════════════════
; Individual telephone number resource

{@telephone_number}
= @types.audit_info

; ───────────────────────────────────────────────────────────────────────────────
; Number Identification (Required)
; ───────────────────────────────────────────────────────────────────────────────
number_id = :                                    ; Unique number identifier
phone_number = *:                                ; Full phone number (CPNI)

; ───────────────────────────────────────────────────────────────────────────────
; NANP Components
; ───────────────────────────────────────────────────────────────────────────────
{.nanp}
npa = :/^\d{3}$/                                  ; Numbering Plan Area (area code)
nxx = :/^\d{3}$/                                  ; Exchange (central office code)
line = :/^\d{4}$/                                 ; Line number
country_code = :(1..3) "1"                        ; Country code (default US/Canada)

{@telephone_number}

; ───────────────────────────────────────────────────────────────────────────────
; Number Type and Classification
; ───────────────────────────────────────────────────────────────────────────────
number_type = (freephone, geographic, mobile, non_geographic, premium, shared_cost, voip)
service_type = (local, long_distance, toll_free)
toll_free_pattern = ("800", "833", "844", "855", "866", "877", "888", "889") ; Toll-free NPAs

; ───────────────────────────────────────────────────────────────────────────────
; Number Status
; ───────────────────────────────────────────────────────────────────────────────
status = (
    active,
    aging,
    available,
    disconnected,
    pending_port,
    quarantine,
    reserved,
    suspended
)
status_date = date                                ; Status change date

; ───────────────────────────────────────────────────────────────────────────────
; Assignment
; ───────────────────────────────────────────────────────────────────────────────
{.assignment}
assigned_to_account = :                           ; Account reference
assigned_to_subscription = :                      ; Subscription reference
assignment_date = date                            ; Assignment date
assignment_type = (individual, pool, temporary)

{@telephone_number}

; ───────────────────────────────────────────────────────────────────────────────
; Ownership and Carrier
; ───────────────────────────────────────────────────────────────────────────────
{.ownership}
owning_carrier = :                               ; Current owning carrier
carrier_type = (lec, mobile, voip, wireless)      ; Carrier type
serving_carrier = :                               ; Serving carrier (if different)
ocn = :/^\d{4}$/                                  ; Operating Company Number
lrn = :/^\d{10}$/                                 ; Location Routing Number (for ported numbers)

{@telephone_number}

; ───────────────────────────────────────────────────────────────────────────────
; Geographic Information
; ───────────────────────────────────────────────────────────────────────────────
{.location}
rate_center = :                                   ; Rate center
lata = :                                          ; Local Access and Transport Area
state_province = :(2)                             ; US state or Canadian province
country = :(2..3) "US"                            ; ISO country code
time_zone = :                                     ; IANA time zone

{@telephone_number}

; ───────────────────────────────────────────────────────────────────────────────
; Porting History
; ───────────────────────────────────────────────────────────────────────────────
{.porting}
ported = ?                                        ; Number has been ported
ported_in = ?                                     ; Ported into this carrier
ported_out = ?                                    ; Ported out from this carrier
port_date = date                                  ; Most recent port date
previous_carrier = :                              ; Previous carrier (if ported in)
original_carrier = :                              ; Original carrier

{@telephone_number}

; ───────────────────────────────────────────────────────────────────────────────
; Features and Capabilities
; ───────────────────────────────────────────────────────────────────────────────
{.features}
sms_capable = ?                                   ; SMS capable
mms_capable = ?                                   ; MMS capable
voice_capable = ?                                 ; Voice capable
data_capable = ?                                  ; Data capable
fax_capable = ?                                   ; Fax capable
e911_capable = ?                                 ; E911 capable

{@telephone_number}

; ───────────────────────────────────────────────────────────────────────────────
; Provisioning Dates
; ───────────────────────────────────────────────────────────────────────────────
{.dates}
acquired_date = date                              ; Date acquired by carrier
activated_date = date                             ; Activation date
disconnected_date = date                          ; Disconnection date
aging_start_date = date                           ; Aging period start (after disconnect)
aging_end_date = date                             ; Aging period end

{@telephone_number}

; ───────────────────────────────────────────────────────────────────────────────
; Vanity and Custom Numbers
; ───────────────────────────────────────────────────────────────────────────────
{.vanity}
vanity_number = ?                                 ; Vanity/custom number
vanity_pattern = :                                ; Vanity pattern (e.g., "1-800-FLOWERS")
premium_number = ?                                ; Premium number (higher acquisition cost)

{@telephone_number}

; ═══════════════════════════════════════════════════════════════════════════════
; PORT REQUEST (LSR)
; ═══════════════════════════════════════════════════════════════════════════════
; Local Service Request for number porting

{@port_request}
= @types.audit_info

; ───────────────────────────────────────────────────────────────────────────────
; Request Identification (Required)
; ───────────────────────────────────────────────────────────────────────────────
port_request_id = :                              ; Unique port request identifier
lsr_number = :                                   ; Local Service Request number
pon = :                                           ; Port Order Number

; ───────────────────────────────────────────────────────────────────────────────
; Request Type
; ───────────────────────────────────────────────────────────────────────────────
request_type = (port_in, port_out)
port_type = (full_port, partial_port, simple, complex)
number_count = ##:(1..)                           ; Number of TNs being ported

; ───────────────────────────────────────────────────────────────────────────────
; Carriers
; ───────────────────────────────────────────────────────────────────────────────
{.carriers}
old_carrier = :                                  ; Losing carrier (donor)
old_carrier_ocn = :/^\d{4}$/                      ; Old carrier OCN
new_carrier = :                                  ; Gaining carrier (recipient)
new_carrier_ocn = :/^\d{4}$/                      ; New carrier OCN

{@port_request}

; ───────────────────────────────────────────────────────────────────────────────
; Numbers Being Ported
; ───────────────────────────────────────────────────────────────────────────────
numbers[] = @porting_number                       ; Telephone numbers in port

; ───────────────────────────────────────────────────────────────────────────────
; Request Dates
; ───────────────────────────────────────────────────────────────────────────────
{.dates}
request_date = date                              ; Port request submission date
requested_due_date = date                        ; Requested port due date
foc_date = date                                   ; Firm Order Confirmation date
activation_date = date                            ; Actual activation date
completion_date = date                            ; Completion date

{@port_request}

; ───────────────────────────────────────────────────────────────────────────────
; Request Status
; ───────────────────────────────────────────────────────────────────────────────
status = (
    active,
    cancelled,
    completed,
    conflict,
    exception,
    foc_received,
    pending,
    rejected,
    submitted
)
status_date = timestamp                           ; Status change timestamp
status_reason = :                                 ; Status reason/notes

; ───────────────────────────────────────────────────────────────────────────────
; Subscriber Information (for validation)
; ───────────────────────────────────────────────────────────────────────────────
{.subscriber}
account_number = *:                               ; Account number with old carrier (confidential)
authorized_name = :                              ; Authorized contact name
billing_telephone_number = *:                     ; BTN (confidential)
pin = *:                                          ; Account PIN (confidential)
service_address = @types.address                  ; Service address

{@port_request}

; ───────────────────────────────────────────────────────────────────────────────
; FOC (Firm Order Confirmation)
; ───────────────────────────────────────────────────────────────────────────────
{.foc}
foc_received = ?                                  ; FOC received from old carrier
foc_number = :                                    ; FOC confirmation number
foc_date = date                                   ; FOC date
confirmed_activation_date = date                  ; Confirmed activation date

{@port_request}

; ───────────────────────────────────────────────────────────────────────────────
; Rejection/Exception Handling
; ───────────────────────────────────────────────────────────────────────────────
{.exception}
exception_code = :                                ; Exception/rejection code
exception_reason = :                              ; Exception reason
resolution_notes = :                              ; Resolution notes
resolution_date = date                            ; Resolution date

{@port_request}

; ───────────────────────────────────────────────────────────────────────────────
; Project and Coordination
; ───────────────────────────────────────────────────────────────────────────────
{.project}
project_code = :                                  ; Project/batch code
coordination_required = ?                         ; Inter-carrier coordination required
coordination_notes = :                            ; Coordination notes

{@port_request}

; ═══════════════════════════════════════════════════════════════════════════════
; PORTING NUMBER
; ═══════════════════════════════════════════════════════════════════════════════
; Individual number within a port request

{@porting_number}
; Required fields
phone_number = *:                                ; Phone number being ported (CPNI)
number_type = (fax, main, voice)
status = (active, cancelled, failed, pending, ported)

; Optional fields
lrn = :/^\d{10}$/                                 ; Location Routing Number
spid = :                                          ; Service Provider ID
activation_timestamp = timestamp                  ; Actual activation timestamp
failure_reason = :                                ; Failure reason (if failed)

; ═══════════════════════════════════════════════════════════════════════════════
; NUMBER RESERVATION
; ═══════════════════════════════════════════════════════════════════════════════
; Number reservation for future assignment

{@number_reservation}
; ───────────────────────────────────────────────────────────────────────────────
; Reservation Identification
; ───────────────────────────────────────────────────────────────────────────────
reservation_id = :                               ; Unique reservation identifier
phone_number = *:                                ; Reserved phone number

; ───────────────────────────────────────────────────────────────────────────────
; Reservation Details
; ───────────────────────────────────────────────────────────────────────────────
reserved_for_account = :                          ; Account reference
reserved_for_subscription = :                     ; Subscription reference
reservation_date = date                          ; Reservation date
expiration_date = date                           ; Reservation expiration
reservation_type = (customer_hold, internal, pending_port, temporary)

; ───────────────────────────────────────────────────────────────────────────────
; Reservation Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, assigned, cancelled, expired)
status_date = date                                ; Status change date

; ═══════════════════════════════════════════════════════════════════════════════
; NUMBER BLOCK
; ═══════════════════════════════════════════════════════════════════════════════
; Block of consecutive telephone numbers

{@number_block}
; ───────────────────────────────────────────────────────────────────────────────
; Block Identification
; ───────────────────────────────────────────────────────────────────────────────
block_id = :                                     ; Unique block identifier
npa = :/^\d{3}$/                                 ; Area code
nxx = :/^\d{3}$/                                 ; Exchange

; ───────────────────────────────────────────────────────────────────────────────
; Block Range
; ───────────────────────────────────────────────────────────────────────────────
{.range}
start_line = :/^\d{4}$/                          ; Starting line number
end_line = :/^\d{4}$/                            ; Ending line number
total_numbers = ##:(1..)                         ; Total numbers in block

{@number_block}

; ───────────────────────────────────────────────────────────────────────────────
; Block Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, assigned, available, reserved)
status_date = date                                ; Status change date

; ───────────────────────────────────────────────────────────────────────────────
; Block Assignment
; ───────────────────────────────────────────────────────────────────────────────
{.assignment}
assigned_to_carrier = :                           ; Assigned carrier
assignment_date = date                            ; Assignment date
utilization_count = ##:(0..)                      ; Numbers currently in use
utilization_percent = #:(0..100)                  ; Utilization percentage

{@number_block}

; ═══════════════════════════════════════════════════════════════════════════════
; NPA (AREA CODE)
; ═══════════════════════════════════════════════════════════════════════════════
; Area code information

{@npa}
; ───────────────────────────────────────────────────────────────────────────────
; NPA Identification
; ───────────────────────────────────────────────────────────────────────────────
npa = :/^\d{3}$/                                 ; Area code (NPA)
npa_type = (geographic, non_geographic, toll_free)

; ───────────────────────────────────────────────────────────────────────────────
; Geographic Information
; ───────────────────────────────────────────────────────────────────────────────
{.location}
country = (CA, US)                               ; Country
states_provinces[] = :(2)                         ; States/provinces served
regions[] = :                                     ; Regions/cities served
time_zones[] = :                                  ; Time zones

{@npa}

; ───────────────────────────────────────────────────────────────────────────────
; NPA Dates
; ───────────────────────────────────────────────────────────────────────────────
{.dates}
in_service_date = date                            ; NPA in-service date
overlay_date = date                               ; Overlay implementation date
planned_relief_date = date                        ; Planned relief date

{@npa}

; ───────────────────────────────────────────────────────────────────────────────
; NPA Configuration
; ───────────────────────────────────────────────────────────────────────────────
{.config}
permissive_dialing = ?                            ; Permissive dialing allowed
mandatory_10_digit = ?                            ; 10-digit dialing mandatory
overlay_npa = ?                                   ; Overlay area code
overlay_of = :/^\d{3}$/                           ; Original NPA (if overlay)

{@npa}

; ═══════════════════════════════════════════════════════════════════════════════
; NPANXX (EXCHANGE)
; ═══════════════════════════════════════════════════════════════════════════════
; NPA-NXX exchange information

{@npanxx}
; ───────────────────────────────────────────────────────────────────────────────
; Exchange Identification
; ───────────────────────────────────────────────────────────────────────────────
npa = :/^\d{3}$/                                 ; Area code
nxx = :/^\d{3}$/                                 ; Exchange
npanxx = :/^\d{6}$/                              ; Combined NPA-NXX

; ───────────────────────────────────────────────────────────────────────────────
; Exchange Assignment
; ───────────────────────────────────────────────────────────────────────────────
{.assignment}
assigned_carrier = :                             ; Assigned carrier
ocn = :/^\d{4}$/                                  ; Operating Company Number
use_type = (general, government, reserved, special)
assignment_date = date                            ; Assignment date

{@npanxx}

; ───────────────────────────────────────────────────────────────────────────────
; Geographic Information
; ───────────────────────────────────────────────────────────────────────────────
{.location}
rate_center = :                                   ; Rate center
lata = :                                          ; LATA
state_province = :(2)                             ; State/province
country = :(2..3)                                 ; Country code
time_zone = :                                     ; Time zone
latitude = #:(-90..90)                            ; Latitude
longitude = #:(-180..180)                         ; Longitude

{@npanxx}

; ───────────────────────────────────────────────────────────────────────────────
; Service Capabilities
; ───────────────────────────────────────────────────────────────────────────────
{.capabilities}
portable = ?                                      ; LNP capable
wireless = ?                                      ; Wireless exchange
wireline = ?                                      ; Wireline exchange
voip = ?                                          ; VoIP exchange

{@npanxx}

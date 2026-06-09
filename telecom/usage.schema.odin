; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Telecom Usage Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Voice call detail records (CDR), data sessions, messaging, roaming,
; and usage summaries.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.telecom.usage"
version = "1.0.0"
title = "Telecom Usage Schema"
description = "Voice CDR, data sessions, messaging, roaming, and usage tracking"

{$derivation}
source[0].authority = "GSMA"
source[0].citation = "TAP3 - Transferred Account Procedure"
source[0].url = "https://www.gsma.com/services/tap/"

source[1].authority = "GSMA"
source[1].citation = "RAP - Returned Accounts Procedure"
source[1].url = "https://www.gsma.com/services/rap/"

source[2].authority = "3GPP"
source[2].citation = "TS 32.298 - Charging Data Record (CDR) Parameter Description"
source[2].url = "https://www.3gpp.org/specifications"

source[3].authority = "Federal Communications Commission"
source[3].citation = "47 CFR Part 64, Subpart U - CPNI Usage Data"
source[3].url = "https://www.ecfr.gov/current/title-47/chapter-I/subchapter-B/part-64/subpart-U"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial usage schema"
changelog[0].rationale = "Usage structure derived from GSMA TAP/RAP standards and 3GPP CDR specifications"

; ═══════════════════════════════════════════════════════════════════════════════
; VOICE CALL DETAIL RECORD (CDR)
; ═══════════════════════════════════════════════════════════════════════════════
; Individual voice call record

{@voice_cdr}
= @types.audit_info

; ───────────────────────────────────────────────────────────────────────────────
; Call Identification (Required)
; ───────────────────────────────────────────────────────────────────────────────
record_id = :                                    ; Unique CDR identifier
call_id = :                                      ; Unique call identifier

; ───────────────────────────────────────────────────────────────────────────────
; Subscriber Information (CPNI)
; ───────────────────────────────────────────────────────────────────────────────
calling_number = *:                              ; Calling party number (CPNI)
called_number = *:                               ; Called party number (CPNI)
subscription_ref = :                             ; Subscription reference
imsi = *:                                         ; IMSI (confidential)
imei = *:                                         ; IMEI (confidential)

; ───────────────────────────────────────────────────────────────────────────────
; Call Timing
; ───────────────────────────────────────────────────────────────────────────────
{.timing}
start_time = timestamp                           ; Call start timestamp
end_time = timestamp                             ; Call end timestamp
duration_seconds = ##:(0..)                      ; Call duration in seconds
ring_duration_seconds = ##:(0..)                  ; Ring duration before answer

{@voice_cdr}

; ───────────────────────────────────────────────────────────────────────────────
; Call Type and Classification
; ───────────────────────────────────────────────────────────────────────────────
call_type = (incoming, outgoing)
call_direction = (mobile_originated, mobile_terminated)
call_category = (
    "411",
    "911",
    conference,
    emergency,
    forwarded,
    international,
    local,
    long_distance,
    toll_free,
    voicemail
)

; ───────────────────────────────────────────────────────────────────────────────
; Call Completion
; ───────────────────────────────────────────────────────────────────────────────
call_completed = ?                               ; Call successfully completed
completion_status = (answered, busy, failed, no_answer, rejected)
disconnect_reason = :                             ; Reason for disconnect

; ───────────────────────────────────────────────────────────────────────────────
; Location Information
; ───────────────────────────────────────────────────────────────────────────────
{.location}
cell_id = :                                       ; Cell tower ID
location_area_code = :                            ; LAC
serving_network = :                               ; Serving network identifier
country_code = :(2..3)                            ; ISO country code
roaming = ?                                       ; Roaming call flag

{@voice_cdr}

; ───────────────────────────────────────────────────────────────────────────────
; Network and Technology
; ───────────────────────────────────────────────────────────────────────────────
{.network}
network_type = (cdma, evdo, gsm, lte, nr, umts)   ; Network technology
service_type = (circuit_switched, volte, vowifi)  ; Service type
codec = :                                         ; Voice codec used

{@voice_cdr}

; ───────────────────────────────────────────────────────────────────────────────
; Charging Information
; ───────────────────────────────────────────────────────────────────────────────
{.charging}
charge_amount = #$:(0..)                          ; Charge for this call
charge_type = (allowance, overage, per_minute, roaming)
rate_per_minute = #$:(0..)                        ; Rate per minute
free_minutes_used = ##:(0..)                      ; Free minutes applied

{@voice_cdr}

; ═══════════════════════════════════════════════════════════════════════════════
; DATA SESSION
; ═══════════════════════════════════════════════════════════════════════════════
; Mobile data usage session

{@data_session}
= @types.audit_info

; ───────────────────────────────────────────────────────────────────────────────
; Session Identification (Required)
; ───────────────────────────────────────────────────────────────────────────────
session_id = :                                   ; Unique session identifier
record_id = :                                    ; Unique record identifier

; ───────────────────────────────────────────────────────────────────────────────
; Subscriber Information (CPNI)
; ───────────────────────────────────────────────────────────────────────────────
phone_number = *:                                 ; Phone number (CPNI)
subscription_ref = :                             ; Subscription reference
imsi = *:                                         ; IMSI (confidential)
imei = *:                                         ; IMEI (confidential)

; ───────────────────────────────────────────────────────────────────────────────
; Session Timing
; ───────────────────────────────────────────────────────────────────────────────
{.timing}
start_time = timestamp                           ; Session start timestamp
end_time = timestamp                             ; Session end timestamp
duration_seconds = ##:(0..)                      ; Session duration in seconds

{@data_session}

; ───────────────────────────────────────────────────────────────────────────────
; Data Volume
; ───────────────────────────────────────────────────────────────────────────────
{.volume}
bytes_uploaded = ##:(0..)                        ; Bytes uploaded
bytes_downloaded = ##:(0..)                      ; Bytes downloaded
total_bytes = ##:(0..)                           ; Total bytes transferred

{@data_session}

; ───────────────────────────────────────────────────────────────────────────────
; Network and Technology
; ───────────────────────────────────────────────────────────────────────────────
{.network}
network_type = ("2g", "3g", "4g", "5g")           ; Network generation
technology = (evdo, gprs, hspa, lte, nr, umts)    ; Specific technology
apn = :                                           ; Access Point Name
ip_address = *:                                   ; Assigned IP address (CPNI)
serving_network = :                               ; Serving network identifier

{@data_session}

; ───────────────────────────────────────────────────────────────────────────────
; Location Information
; ───────────────────────────────────────────────────────────────────────────────
{.location}
cell_id = :                                       ; Cell tower ID
location_area_code = :                            ; LAC
country_code = :(2..3)                            ; ISO country code
roaming = ?                                       ; Roaming session flag

{@data_session}

; ───────────────────────────────────────────────────────────────────────────────
; Session Type
; ───────────────────────────────────────────────────────────────────────────────
session_type = (hotspot, regular, tethering, video_streaming)
application_category = :                          ; Application category (if detected)

; ───────────────────────────────────────────────────────────────────────────────
; Charging Information
; ───────────────────────────────────────────────────────────────────────────────
{.charging}
charge_amount = #$:(0..)                          ; Charge for this session
charge_type = (allowance, overage, roaming)
rate_per_mb = #$:(0..)                            ; Rate per MB
free_data_used_mb = ##:(0..)                      ; Free data allowance used (MB)

{@data_session}

; ═══════════════════════════════════════════════════════════════════════════════
; MESSAGE (SMS/MMS)
; ═══════════════════════════════════════════════════════════════════════════════
; SMS or MMS message record

{@message}
= @types.audit_info

; ───────────────────────────────────────────────────────────────────────────────
; Message Identification (Required)
; ───────────────────────────────────────────────────────────────────────────────
message_id = :                                   ; Unique message identifier
record_id = :                                    ; Unique record identifier

; ───────────────────────────────────────────────────────────────────────────────
; Message Type
; ───────────────────────────────────────────────────────────────────────────────
message_type = (mms, sms)
message_direction = (incoming, outgoing)

; ───────────────────────────────────────────────────────────────────────────────
; Subscriber Information (CPNI)
; ───────────────────────────────────────────────────────────────────────────────
sender_number = *:                               ; Sender number (CPNI)
recipient_number = *:                            ; Recipient number (CPNI)
subscription_ref = :                             ; Subscription reference
imsi = *:                                         ; IMSI (confidential)
imei = *:                                         ; IMEI (confidential)

; ───────────────────────────────────────────────────────────────────────────────
; Message Timing
; ───────────────────────────────────────────────────────────────────────────────
{.timing}
sent_time = timestamp                            ; Message sent timestamp
delivered_time = timestamp                        ; Message delivered timestamp

{@message}

; ───────────────────────────────────────────────────────────────────────────────
; Message Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
message_length = ##:(0..)                         ; Message length (characters for SMS, bytes for MMS)
segment_count = ##:(0..)                          ; Number of message segments
delivery_status = (delivered, failed, pending, sent)
failure_reason = :                                ; Failure reason (if failed)

{@message}

; ───────────────────────────────────────────────────────────────────────────────
; MMS-Specific Fields
; ───────────────────────────────────────────────────────────────────────────────
{.mms}
subject = :                                       ; MMS subject line
attachment_count = ##:(0..)                       ; Number of attachments
attachment_size_bytes = ##:(0..)                  ; Total attachment size
content_type = :                                  ; Content type (image, video, audio)

{@message}

; ───────────────────────────────────────────────────────────────────────────────
; Message Category
; ───────────────────────────────────────────────────────────────────────────────
message_category = (
    group_message,
    international,
    local,
    premium_sms,
    short_code,
    standard
)

; ───────────────────────────────────────────────────────────────────────────────
; Location Information
; ───────────────────────────────────────────────────────────────────────────────
{.location}
cell_id = :                                       ; Cell tower ID
country_code = :(2..3)                            ; ISO country code
roaming = ?                                       ; Roaming message flag

{@message}

; ───────────────────────────────────────────────────────────────────────────────
; Charging Information
; ───────────────────────────────────────────────────────────────────────────────
{.charging}
charge_amount = #$:(0..)                          ; Charge for this message
charge_type = (allowance, overage, per_message, premium, roaming)
rate_per_message = #$:(0..)                       ; Rate per message
free_messages_used = ##:(0..)                     ; Free messages applied

{@message}

; ═══════════════════════════════════════════════════════════════════════════════
; ROAMING EVENT
; ═══════════════════════════════════════════════════════════════════════════════
; Roaming session or event record

{@roaming_event}
; ───────────────────────────────────────────────────────────────────────────────
; Event Identification (Required)
; ───────────────────────────────────────────────────────────────────────────────
event_id = :                                     ; Unique event identifier
subscription_ref = :                             ; Subscription reference

; ───────────────────────────────────────────────────────────────────────────────
; Event Type
; ───────────────────────────────────────────────────────────────────────────────
event_type = (data, sms, voice)
roaming_type = (domestic, international)

; ───────────────────────────────────────────────────────────────────────────────
; Subscriber Information (CPNI)
; ───────────────────────────────────────────────────────────────────────────────
phone_number = *:                                 ; Phone number (CPNI)
imsi = *:                                         ; IMSI (confidential)
imei = *:                                         ; IMEI (confidential)

; ───────────────────────────────────────────────────────────────────────────────
; Event Timing
; ───────────────────────────────────────────────────────────────────────────────
{.timing}
start_time = timestamp                           ; Event start timestamp
end_time = timestamp                              ; Event end timestamp
duration_seconds = ##:(0..)                       ; Event duration

{@roaming_event}

; ───────────────────────────────────────────────────────────────────────────────
; Roaming Network
; ───────────────────────────────────────────────────────────────────────────────
{.roaming_network}
network_operator = :                             ; Roaming network operator
country_code = :(2..3)                           ; ISO country code
country_name = :                                  ; Country name
mcc = :/^\d{3}$/                                  ; Mobile Country Code
mnc = :/^\d{2,3}$/                                ; Mobile Network Code
network_type = ("2g", "3g", "4g", "5g")           ; Network type

{@roaming_event}

; ───────────────────────────────────────────────────────────────────────────────
; Usage Details
; ───────────────────────────────────────────────────────────────────────────────
{.usage}
voice_minutes = ##:(0..)                          ; Voice minutes used
data_mb = ##:(0..)                                ; Data used (MB)
sms_count = ##:(0..)                              ; SMS messages sent

{@roaming_event}

; ───────────────────────────────────────────────────────────────────────────────
; Charging Information
; ───────────────────────────────────────────────────────────────────────────────
{.charging}
total_charge = #$:(0..)                           ; Total roaming charge
voice_charge = #$:(0..)                           ; Voice charges
data_charge = #$:(0..)                            ; Data charges
sms_charge = #$:(0..)                             ; SMS charges
rate_plan_applied = :                             ; Roaming rate plan

{@roaming_event}

; ═══════════════════════════════════════════════════════════════════════════════
; USAGE SUMMARY
; ═══════════════════════════════════════════════════════════════════════════════
; Periodic usage summary (daily, billing cycle, etc.)

{@usage_summary}
; ───────────────────────────────────────────────────────────────────────────────
; Summary Identification (Required)
; ───────────────────────────────────────────────────────────────────────────────
summary_id = :                                   ; Unique summary identifier
subscription_ref = :                             ; Subscription reference

; ───────────────────────────────────────────────────────────────────────────────
; Summary Period
; ───────────────────────────────────────────────────────────────────────────────
{.period}
period_type = (billing_cycle, daily, monthly, weekly)
period_start = date                              ; Period start date
period_end = date                                ; Period end date

{@usage_summary}

; ───────────────────────────────────────────────────────────────────────────────
; Voice Usage Summary
; ───────────────────────────────────────────────────────────────────────────────
{.voice}
total_minutes = ##:(0..)                          ; Total voice minutes
incoming_minutes = ##:(0..)                       ; Incoming minutes
outgoing_minutes = ##:(0..)                       ; Outgoing minutes
roaming_minutes = ##:(0..)                        ; Roaming minutes
international_minutes = ##:(0..)                  ; International minutes
allowance_minutes = ##:(0..)                      ; Allowance minutes
overage_minutes = ##:(0..)                        ; Overage minutes
calls_count = ##:(0..)                            ; Total number of calls

{@usage_summary}

; ───────────────────────────────────────────────────────────────────────────────
; Data Usage Summary
; ───────────────────────────────────────────────────────────────────────────────
{.data}
total_mb = ##:(0..)                               ; Total data (MB)
total_gb = #:(0..)                                ; Total data (GB)
roaming_mb = ##:(0..)                             ; Roaming data (MB)
hotspot_mb = ##:(0..)                             ; Hotspot data (MB)
allowance_mb = ##:(0..)                           ; Allowance data (MB)
overage_mb = ##:(0..)                             ; Overage data (MB)
sessions_count = ##:(0..)                         ; Number of data sessions

{@usage_summary}

; ───────────────────────────────────────────────────────────────────────────────
; Messaging Usage Summary
; ───────────────────────────────────────────────────────────────────────────────
{.messaging}
sms_sent = ##:(0..)                               ; SMS messages sent
sms_received = ##:(0..)                           ; SMS messages received
mms_sent = ##:(0..)                               ; MMS messages sent
mms_received = ##:(0..)                           ; MMS messages received
international_sms = ##:(0..)                      ; International SMS
roaming_sms = ##:(0..)                            ; Roaming SMS
allowance_sms = ##:(0..)                          ; Allowance SMS used
overage_sms = ##:(0..)                            ; Overage SMS

{@usage_summary}

; ───────────────────────────────────────────────────────────────────────────────
; Charges Summary
; ───────────────────────────────────────────────────────────────────────────────
{.charges}
total_usage_charges = #$:(0..)                    ; Total usage charges
voice_charges = #$:(0..)                          ; Voice charges
data_charges = #$:(0..)                           ; Data charges
messaging_charges = #$:(0..)                      ; Messaging charges
roaming_charges = #$:(0..)                        ; Roaming charges
overage_charges = #$:(0..)                        ; Overage charges

{@usage_summary}

; ───────────────────────────────────────────────────────────────────────────────
; Allowance Utilization
; ───────────────────────────────────────────────────────────────────────────────
{.utilization}
voice_percent_used = #:(0..100)                   ; Voice allowance % used
data_percent_used = #:(0..100)                    ; Data allowance % used
sms_percent_used = #:(0..100)                     ; SMS allowance % used

{@usage_summary}

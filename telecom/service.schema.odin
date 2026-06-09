; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Telecom Service Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Wireless and wireline services including voice, data, messaging, broadband,
; and VoIP. Covers plans, bundles, features, and service provisioning.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.telecom.service"
version = "1.0.0"
title = "Telecom Service Schema"
description = "Wireless and wireline service plans, features, and provisioning"

{$derivation}
source[0].authority = "GSMA"
source[0].citation = "GSMA Service and Product Data Model"
source[0].url = "https://www.gsma.com/services/data-models/"

source[1].authority = "Federal Communications Commission"
source[1].citation = "47 CFR Part 20 - Commercial Mobile Services"
source[1].url = "https://www.ecfr.gov/current/title-47/chapter-I/subchapter-B/part-20"

source[2].authority = "Federal Communications Commission"
source[2].citation = "47 CFR Part 64 - Miscellaneous Rules Relating to Common Carriers"
source[3].url = "https://www.ecfr.gov/current/title-47/chapter-I/subchapter-B/part-64"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial service schema"
changelog[0].rationale = "Service structure derived from GSMA data models and FCC service classifications"

; ═══════════════════════════════════════════════════════════════════════════════
; SERVICE SUBSCRIPTION
; ═══════════════════════════════════════════════════════════════════════════════
; Individual service subscription (line of service)

{@subscription}
= @types.audit_info

; ───────────────────────────────────────────────────────────────────────────────
; Subscription Identification (Required)
; ───────────────────────────────────────────────────────────────────────────────
subscription_id = :                              ; Unique subscription identifier
account_ref = :                                  ; Account reference
service_type = (broadband, data, messaging, video, voice, voip)

; ───────────────────────────────────────────────────────────────────────────────
; Subscription Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, cancelled, disconnected, pending, suspended, terminated)
status_date = date                                ; Date of status change
status_reason = :                                 ; Reason for status change

; ───────────────────────────────────────────────────────────────────────────────
; Service Classification
; ───────────────────────────────────────────────────────────────────────────────
technology = ("2g", "3g", "4g", "5g", cable, copper, dsl, fiber, fixed_wireless, satellite)
network_type = (cdma, evdo, gsm, lte, nr, umts)   ; Network technology type

; ───────────────────────────────────────────────────────────────────────────────
; Service Plan
; ───────────────────────────────────────────────────────────────────────────────
plan = @plan                                      ; Service plan details

; ───────────────────────────────────────────────────────────────────────────────
; Service Dates
; ───────────────────────────────────────────────────────────────────────────────
{.dates}
activated = date                                 ; Service activation date
deactivated = date                                ; Service deactivation date
last_modified = timestamp                         ; Last modification timestamp
contract_start = date                             ; Contract start date
contract_end = date                               ; Contract end date

{@subscription}

; ───────────────────────────────────────────────────────────────────────────────
; Telephone Number (if applicable)
; ───────────────────────────────────────────────────────────────────────────────
phone_number = *:                                 ; Assigned phone number (CPNI)
phone_number_type = (mobile, toll_free, voip, wireline)

; ───────────────────────────────────────────────────────────────────────────────
; Service Address (for fixed services)
; ───────────────────────────────────────────────────────────────────────────────
service_address = @types.address                  ; Service installation address

; ───────────────────────────────────────────────────────────────────────────────
; Features and Add-ons
; ───────────────────────────────────────────────────────────────────────────────
features[] = @feature                             ; Service features/add-ons

; ───────────────────────────────────────────────────────────────────────────────
; Device Association
; ───────────────────────────────────────────────────────────────────────────────
primary_device_ref = :                            ; Primary device reference

; ───────────────────────────────────────────────────────────────────────────────
; Billing
; ───────────────────────────────────────────────────────────────────────────────
{.billing}
monthly_recurring_charge = #$:(0..)               ; Monthly service charge
one_time_charge = #$:(0..)                        ; One-time activation charge
proration_method = (calendar_days, full_month, no_proration, service_days)

{@subscription}

; ───────────────────────────────────────────────────────────────────────────────
; Usage Allowances (for metered services)
; ───────────────────────────────────────────────────────────────────────────────
{.allowances}
data_allowance_mb = ##:(0..)                      ; Data allowance in MB
voice_minutes = ##:(0..)                          ; Voice minutes allowance
sms_messages = ##:(0..)                           ; SMS message allowance
mms_messages = ##:(0..)                           ; MMS message allowance
unlimited_data = ?                                ; Unlimited data flag
unlimited_voice = ?                               ; Unlimited voice flag
unlimited_sms = ?                                 ; Unlimited SMS flag

{@subscription}

; ═══════════════════════════════════════════════════════════════════════════════
; SERVICE PLAN
; ═══════════════════════════════════════════════════════════════════════════════
; Rate plan or service package definition

{@plan}
= @types.audit_info

; ───────────────────────────────────────────────────────────────────────────────
; Plan Identification (Required)
; ───────────────────────────────────────────────────────────────────────────────
plan_id = :                                      ; Unique plan identifier
plan_name = :                                    ; Plan name
plan_type = (business, enterprise, family, individual, prepaid)

; ───────────────────────────────────────────────────────────────────────────────
; Plan Classification
; ───────────────────────────────────────────────────────────────────────────────
service_type = (broadband, bundle, data, voice, voip)
contract_type = (month_to_month, prepaid, term_12, term_24, term_36)

; ───────────────────────────────────────────────────────────────────────────────
; Plan Pricing
; ───────────────────────────────────────────────────────────────────────────────
{.pricing}
monthly_rate = #$:(0..)                          ; Monthly base rate
activation_fee = #$:(0..)                         ; Activation fee
early_termination_fee = #$:(0..)                  ; Early termination fee
overage_rate_per_mb = #$:(0..)                    ; Data overage rate per MB
overage_rate_per_minute = #$:(0..)                ; Voice overage rate per minute
overage_rate_per_sms = #$:(0..)                   ; SMS overage rate

{@plan}

; ───────────────────────────────────────────────────────────────────────────────
; Plan Allowances
; ───────────────────────────────────────────────────────────────────────────────
{.allowances}
data_allowance_mb = ##:(0..)                      ; Monthly data allowance (MB)
data_speed_kbps = ##:(0..)                        ; Data speed (Kbps)
voice_minutes = ##:(0..)                          ; Monthly voice minutes
sms_messages = ##:(0..)                           ; Monthly SMS allowance
mms_messages = ##:(0..)                           ; Monthly MMS allowance
unlimited_data = ?                                ; Unlimited data
unlimited_voice = ?                               ; Unlimited voice
unlimited_sms = ?                                 ; Unlimited SMS
hotspot_data_mb = ##:(0..)                        ; Mobile hotspot data (MB)

{@plan}

; ───────────────────────────────────────────────────────────────────────────────
; International Features
; ───────────────────────────────────────────────────────────────────────────────
{.international}
international_calling_included = ?                ; International calling included
international_roaming_included = ?                ; International roaming included
roaming_countries[] = :(2..3)                     ; ISO country codes where roaming allowed

{@plan}

; ───────────────────────────────────────────────────────────────────────────────
; Plan Availability
; ───────────────────────────────────────────────────────────────────────────────
{.availability}
available = ?                                     ; Plan currently available
available_date = date                             ; Plan availability start date
discontinued_date = date                          ; Plan discontinued date
grandfathered = ?                                 ; Grandfathered plan (no longer sold)

{@plan}

; ───────────────────────────────────────────────────────────────────────────────
; Plan Description
; ───────────────────────────────────────────────────────────────────────────────
description = :                                   ; Plan description
terms_url = :                                     ; URL to plan terms and conditions

; ═══════════════════════════════════════════════════════════════════════════════
; SERVICE FEATURE
; ═══════════════════════════════════════════════════════════════════════════════
; Optional service feature or add-on

{@feature}
= @types.audit_info

; ───────────────────────────────────────────────────────────────────────────────
; Feature Identification (Required)
; ───────────────────────────────────────────────────────────────────────────────
feature_id = :                                   ; Unique feature identifier
feature_name = :                                 ; Feature name
feature_type = (addon, base_included, optional, premium)

; ───────────────────────────────────────────────────────────────────────────────
; Feature Category
; ───────────────────────────────────────────────────────────────────────────────
category = (
    calling_features,
    content,
    data_management,
    device_protection,
    entertainment,
    international,
    messaging,
    network_features,
    security
)

; ───────────────────────────────────────────────────────────────────────────────
; Feature Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, cancelled, pending, suspended)
status_date = date                                ; Status change date

; ───────────────────────────────────────────────────────────────────────────────
; Feature Pricing
; ───────────────────────────────────────────────────────────────────────────────
{.pricing}
monthly_charge = #$:(0..)                         ; Monthly recurring charge
one_time_charge = #$:(0..)                        ; One-time setup charge
usage_based = ?                                   ; Usage-based pricing
included_in_plan = ?                              ; Included in base plan

{@feature}

; ───────────────────────────────────────────────────────────────────────────────
; Feature Details
; ───────────────────────────────────────────────────────────────────────────────
description = :                                   ; Feature description
provisioning_required = ?                         ; Requires network provisioning
activation_date = date                            ; Feature activation date
deactivation_date = date                          ; Feature deactivation date

; ═══════════════════════════════════════════════════════════════════════════════
; SERVICE BUNDLE
; ═══════════════════════════════════════════════════════════════════════════════
; Bundle of multiple services (double play, triple play, etc.)

{@bundle}
; ───────────────────────────────────────────────────────────────────────────────
; Bundle Identification (Required)
; ───────────────────────────────────────────────────────────────────────────────
bundle_id = :                                    ; Unique bundle identifier
bundle_name = :                                  ; Bundle name
bundle_type = (double_play, quad_play, single, triple_play)

; ───────────────────────────────────────────────────────────────────────────────
; Bundled Services
; ───────────────────────────────────────────────────────────────────────────────
services[] = @subscription                        ; Services in bundle

; ───────────────────────────────────────────────────────────────────────────────
; Bundle Pricing
; ───────────────────────────────────────────────────────────────────────────────
{.pricing}
bundle_rate = #$:(0..)                           ; Bundle monthly rate
discount_amount = #$:(0..)                        ; Discount vs individual services
promotional_rate = #$:(0..)                       ; Promotional rate
promotional_period_months = ##:(0..)              ; Promotional period length

{@bundle}

; ───────────────────────────────────────────────────────────────────────────────
; Bundle Terms
; ───────────────────────────────────────────────────────────────────────────────
contract_term_months = ##:(0..)                   ; Contract term in months
auto_renew = ?                                    ; Auto-renew flag
early_termination_fee = #$:(0..)                  ; Early termination fee

; ═══════════════════════════════════════════════════════════════════════════════
; BROADBAND SERVICE
; ═══════════════════════════════════════════════════════════════════════════════
; Broadband/internet service details

{@broadband_service}
; ───────────────────────────────────────────────────────────────────────────────
; Service Identification
; ───────────────────────────────────────────────────────────────────────────────
subscription_ref = :                             ; Subscription reference

; ───────────────────────────────────────────────────────────────────────────────
; Broadband Technology
; ───────────────────────────────────────────────────────────────────────────────
technology = (cable, dsl, fiber, fixed_wireless, satellite)
docsis_version = :                                ; DOCSIS version (for cable)

; ───────────────────────────────────────────────────────────────────────────────
; Speed Tier
; ───────────────────────────────────────────────────────────────────────────────
{.speed}
download_mbps = ##:(0..)                         ; Download speed (Mbps)
upload_mbps = ##:(0..)                           ; Upload speed (Mbps)
guaranteed_minimum = ?                            ; Guaranteed minimum speed
burst_speed_mbps = ##:(0..)                       ; Burst speed capability

{@broadband_service}

; ───────────────────────────────────────────────────────────────────────────────
; Data Cap
; ───────────────────────────────────────────────────────────────────────────────
{.data_cap}
monthly_cap_gb = ##:(0..)                         ; Monthly data cap (GB)
unlimited = ?                                     ; Unlimited data
overage_charge_per_gb = #$:(0..)                  ; Overage charge per GB
throttle_after_cap = ?                            ; Throttle speed after cap

{@broadband_service}

; ───────────────────────────────────────────────────────────────────────────────
; Equipment
; ───────────────────────────────────────────────────────────────────────────────
{.equipment}
modem_required = ?                                ; Modem required
modem_rental_fee = #$:(0..)                       ; Monthly modem rental fee
router_required = ?                               ; Router required
router_rental_fee = #$:(0..)                      ; Monthly router rental fee
gateway_provided = ?                              ; Gateway device provided

{@broadband_service}

; ───────────────────────────────────────────────────────────────────────────────
; Installation
; ───────────────────────────────────────────────────────────────────────────────
{.installation}
installation_required = ?                         ; Professional installation required
installation_fee = #$:(0..)                       ; Installation fee
self_install_option = ?                           ; Self-install available
installation_date = date                          ; Scheduled installation date

{@broadband_service}

; ═══════════════════════════════════════════════════════════════════════════════
; VOIP SERVICE
; ═══════════════════════════════════════════════════════════════════════════════
; Voice over IP service details

{@voip_service}
; ───────────────────────────────────────────────────────────────────────────────
; Service Identification
; ───────────────────────────────────────────────────────────────────────────────
subscription_ref = :                             ; Subscription reference

; ───────────────────────────────────────────────────────────────────────────────
; VoIP Configuration
; ───────────────────────────────────────────────────────────────────────────────
sip_uri = :                                       ; SIP URI
codec = (g711, g722, g729, opus)                  ; Voice codec
e911_enabled = ?                                 ; E911 emergency service enabled
e911_address = @types.address                     ; E911 registered address

; ───────────────────────────────────────────────────────────────────────────────
; Features
; ───────────────────────────────────────────────────────────────────────────────
{.features}
call_forwarding = ?                               ; Call forwarding enabled
call_waiting = ?                                  ; Call waiting enabled
caller_id = ?                                     ; Caller ID enabled
voicemail = ?                                     ; Voicemail enabled
voicemail_to_email = ?                            ; Voicemail to email
three_way_calling = ?                             ; Three-way calling
call_screening = ?                                ; Call screening

{@voip_service}

; ───────────────────────────────────────────────────────────────────────────────
; Number Portability
; ───────────────────────────────────────────────────────────────────────────────
{.porting}
ported_number = ?                                 ; Number ported in
porting_date = date                               ; Porting completion date
previous_carrier = :                              ; Previous carrier name

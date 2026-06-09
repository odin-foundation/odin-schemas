; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Telecom Device Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Mobile devices (IMEI, MEID), SIM cards, equipment (modem, ONT, router),
; device financing, and BYOD management.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.telecom.device"
version = "1.0.0"
title = "Telecom Device Schema"
description = "Mobile devices, SIM cards, equipment, and device management"

{$derivation}
source[0].authority = "GSMA"
source[0].citation = "IMEI Allocation and Approval Guidelines"
source[0].url = "https://www.gsma.com/services/device-services/imei-services/"

source[1].authority = "GSMA"
source[1].citation = "SIM Card Specifications (SIM, USIM, eSIM)"
source[1].url = "https://www.gsma.com/esim/esim-specification/"

source[2].authority = "3GPP"
source[2].citation = "TS 23.003 - Numbering, addressing and identification"
source[2].url = "https://www.3gpp.org/specifications"

source[3].authority = "Federal Communications Commission"
source[3].citation = "47 CFR Part 27 - Miscellaneous Wireless Communications Services"
source[3].url = "https://www.ecfr.gov/current/title-47/chapter-I/subchapter-B/part-27"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial device schema"
changelog[0].rationale = "Device structure derived from GSMA IMEI/SIM standards and 3GPP specifications"

; ═══════════════════════════════════════════════════════════════════════════════
; MOBILE DEVICE
; ═══════════════════════════════════════════════════════════════════════════════
; Mobile phone or cellular device

{@mobile_device}
= @types.audit_info

; ───────────────────────────────────────────────────────────────────────────────
; Device Identification (Required)
; ───────────────────────────────────────────────────────────────────────────────
device_id = :                                    ; Unique device identifier
imei = *:/^\d{15}$/                               ; IMEI (GSM/LTE/5G) - confidential
meid = *:/^[0-9A-F]{14}$/                         ; MEID (CDMA) - confidential
serial_number = *:                                ; Manufacturer serial number

; ───────────────────────────────────────────────────────────────────────────────
; Device Details
; ───────────────────────────────────────────────────────────────────────────────
manufacturer = :                                 ; Device manufacturer
model = :                                        ; Device model name
model_number = :                                  ; Model number/SKU

; ───────────────────────────────────────────────────────────────────────────────
; Device Type
; ───────────────────────────────────────────────────────────────────────────────
device_type = (feature_phone, hotspot, smartphone, tablet, wearable)
form_factor = (bar, clamshell, flip, foldable, slider)

; ───────────────────────────────────────────────────────────────────────────────
; Network Capabilities
; ───────────────────────────────────────────────────────────────────────────────
{.capabilities}
networks_supported[] = ("2g", "3g", "4g", "5g")   ; Supported network generations
network_types[] = (cdma, evdo, gsm, lte, nr, umts) ; Network technologies
dual_sim = ?                                      ; Dual SIM capable
esim_capable = ?                                  ; eSIM capable
wifi_calling = ?                                  ; WiFi calling capable
volte_capable = ?                                 ; VoLTE capable
vowifi_capable = ?                                ; VoWiFi capable

{@mobile_device}

; ───────────────────────────────────────────────────────────────────────────────
; Hardware Specifications
; ───────────────────────────────────────────────────────────────────────────────
{.hardware}
operating_system = :                              ; Operating system
os_version = :                                    ; OS version
storage_gb = ##:(0..)                             ; Storage capacity (GB)
ram_gb = ##:(0..)                                 ; RAM (GB)
screen_size_inches = #:(0..)                      ; Screen size in inches
battery_mah = ##:(0..)                            ; Battery capacity (mAh)
color = :                                         ; Device color

{@mobile_device}

; ───────────────────────────────────────────────────────────────────────────────
; Device Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, blacklisted, inactive, lost, returned, stolen, suspended)
status_date = date                                ; Status change date
activation_date = date                            ; Device activation date
deactivation_date = date                          ; Device deactivation date

; ───────────────────────────────────────────────────────────────────────────────
; Ownership and Acquisition
; ───────────────────────────────────────────────────────────────────────────────
{.ownership}
ownership_type = (byod, financed, leased, owned, rented)
purchase_date = date                              ; Purchase date
purchase_price = #$:(0..)                         ; Purchase price
trade_in_credit = #$:(0..)                        ; Trade-in credit applied

{@mobile_device}

; ───────────────────────────────────────────────────────────────────────────────
; Financing (if applicable)
; ───────────────────────────────────────────────────────────────────────────────
financing = @device_financing                     ; Financing details

; ───────────────────────────────────────────────────────────────────────────────
; Insurance/Protection
; ───────────────────────────────────────────────────────────────────────────────
{.insurance}
insurance_enrolled = ?                            ; Device insurance enrolled
insurance_monthly_fee = #$:(0..)                  ; Monthly insurance fee
deductible = #$:(0..)                             ; Insurance claim deductible
coverage_start = date                             ; Coverage start date
coverage_end = date                               ; Coverage end date

{@mobile_device}

; ───────────────────────────────────────────────────────────────────────────────
; SIM Card Association
; ───────────────────────────────────────────────────────────────────────────────
primary_sim_ref = :                               ; Primary SIM card reference
secondary_sim_ref = :                             ; Secondary SIM (dual SIM devices)

; ───────────────────────────────────────────────────────────────────────────────
; Subscription Association
; ───────────────────────────────────────────────────────────────────────────────
subscription_ref = :                              ; Associated subscription

; ───────────────────────────────────────────────────────────────────────────────
; Device Lock Status
; ───────────────────────────────────────────────────────────────────────────────
{.lock}
locked_to_carrier = ?                             ; Device locked to carrier
lock_status = (locked, unlocked, unlocking_pending)
unlock_date = date                                ; Date device was unlocked
unlock_code = *:                                  ; Unlock code (confidential)

{@mobile_device}

; ═══════════════════════════════════════════════════════════════════════════════
; SIM CARD
; ═══════════════════════════════════════════════════════════════════════════════
; Physical or eSIM card

{@sim_card}
= @types.audit_info

; ───────────────────────────────────────────────────────────────────────────────
; SIM Identification (Required)
; ───────────────────────────────────────────────────────────────────────────────
sim_id = :                                       ; Unique SIM identifier
iccid = *:/^\d{19,20}$/                          ; Integrated Circuit Card ID (confidential)
imsi = *:/^\d{14,15}$/                            ; International Mobile Subscriber Identity (confidential)

; ───────────────────────────────────────────────────────────────────────────────
; SIM Type
; ───────────────────────────────────────────────────────────────────────────────
sim_type = (esim, nano_sim, physical_sim, usim)
form_factor = (embedded, micro, mini, nano, standard)

; ───────────────────────────────────────────────────────────────────────────────
; SIM Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, deactivated, inactive, suspended, terminated)
status_date = date                                ; Status change date
activation_date = date                            ; SIM activation date
deactivation_date = date                          ; SIM deactivation date

; ───────────────────────────────────────────────────────────────────────────────
; Network Assignment
; ───────────────────────────────────────────────────────────────────────────────
network_operator = :                             ; Network operator name
mcc = :/^\d{3}$/                                  ; Mobile Country Code
mnc = :/^\d{2,3}$/                                ; Mobile Network Code

; ───────────────────────────────────────────────────────────────────────────────
; eSIM Details (if applicable)
; ───────────────────────────────────────────────────────────────────────────────
{.esim}
eid = *:/^[0-9A-F]{32}$/                          ; eUICC Identifier (eSIM)
qr_code = :                                       ; QR code for eSIM activation
activation_code = *:                              ; Activation code (confidential)
profile_downloaded = ?                            ; Profile downloaded to device

{@sim_card}

; ───────────────────────────────────────────────────────────────────────────────
; Security
; ───────────────────────────────────────────────────────────────────────────────
{.security}
pin = *:                                          ; PIN code (confidential)
puk = *:                                          ; PUK code (confidential)
pin_enabled = ?                                   ; PIN protection enabled
pin_attempts_remaining = ##:(0..3)                ; PIN attempts remaining

{@sim_card}

; ───────────────────────────────────────────────────────────────────────────────
; Associated Resources
; ───────────────────────────────────────────────────────────────────────────────
device_ref = :                                    ; Associated device reference
subscription_ref = :                              ; Associated subscription reference

; ═══════════════════════════════════════════════════════════════════════════════
; EQUIPMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Customer premises equipment (modem, router, ONT, set-top box, etc.)

{@equipment}
= @types.audit_info

; ───────────────────────────────────────────────────────────────────────────────
; Equipment Identification (Required)
; ───────────────────────────────────────────────────────────────────────────────
equipment_id = :                                 ; Unique equipment identifier
serial_number = *:                               ; Serial number (confidential)
mac_address = *:                                  ; MAC address (confidential)

; ───────────────────────────────────────────────────────────────────────────────
; Equipment Type
; ───────────────────────────────────────────────────────────────────────────────
equipment_type = (gateway, modem, ont, router, set_top_box, voip_adapter)
manufacturer = :                                 ; Equipment manufacturer
model = :                                        ; Equipment model

; ───────────────────────────────────────────────────────────────────────────────
; Equipment Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, defective, inactive, returned, shipped, stored)
status_date = date                                ; Status change date

; ───────────────────────────────────────────────────────────────────────────────
; Ownership
; ───────────────────────────────────────────────────────────────────────────────
{.ownership}
owned_by = (carrier, customer)                   ; Equipment ownership
rental_fee = #$:(0..)                             ; Monthly rental fee
purchase_option = ?                               ; Customer can purchase
purchase_price = #$:(0..)                         ; Purchase price

{@equipment}

; ───────────────────────────────────────────────────────────────────────────────
; Installation
; ───────────────────────────────────────────────────────────────────────────────
{.installation}
installed = ?                                     ; Equipment installed
installation_date = date                          ; Installation date
installation_technician = :                       ; Technician ID
installation_address = @types.address             ; Installation address
self_installed = ?                                ; Customer self-installed

{@equipment}

; ───────────────────────────────────────────────────────────────────────────────
; Equipment Capabilities
; ───────────────────────────────────────────────────────────────────────────────
{.capabilities}
docsis_version = :                                ; DOCSIS version (modems)
wifi_standard = ("802.11a", "802.11ac", "802.11ax", "802.11b", "802.11g", "802.11n")
max_speed_mbps = ##:(0..)                         ; Maximum speed (Mbps)
ethernet_ports = ##:(0..)                         ; Number of ethernet ports
phone_ports = ##:(0..)                            ; Number of phone ports
dual_band = ?                                     ; Dual-band WiFi
gigabit_ethernet = ?                              ; Gigabit ethernet ports

{@equipment}

; ───────────────────────────────────────────────────────────────────────────────
; Firmware
; ───────────────────────────────────────────────────────────────────────────────
{.firmware}
current_version = :                               ; Current firmware version
last_update = timestamp                           ; Last firmware update
auto_update_enabled = ?                           ; Auto-update enabled

{@equipment}

; ───────────────────────────────────────────────────────────────────────────────
; Service Association
; ───────────────────────────────────────────────────────────────────────────────
subscription_ref = :                              ; Associated subscription

; ═══════════════════════════════════════════════════════════════════════════════
; DEVICE FINANCING
; ═══════════════════════════════════════════════════════════════════════════════
; Device payment plan or financing agreement

{@device_financing}
; ───────────────────────────────────────────────────────────────────────────────
; Financing Identification (Required)
; ───────────────────────────────────────────────────────────────────────────────
financing_id = :                                 ; Unique financing identifier
device_ref = :                                   ; Device reference

; ───────────────────────────────────────────────────────────────────────────────
; Financing Terms
; ───────────────────────────────────────────────────────────────────────────────
{.terms}
total_price = #$:(0..)                           ; Total device price
down_payment = #$:(0..)                           ; Down payment amount
financed_amount = #$:(0..)                       ; Amount financed
monthly_payment = #$:(0..)                       ; Monthly payment
payment_count = ##:(0..)                         ; Number of payments
term_months = ##:(0..)                           ; Term length in months
interest_rate = #:(0..100)                        ; Annual interest rate percentage
apr = #:(0..100)                                  ; APR percentage

{@device_financing}

; ───────────────────────────────────────────────────────────────────────────────
; Financing Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, cancelled, charged_off, complete, defaulted, past_due)
status_date = date                                ; Status change date

; ───────────────────────────────────────────────────────────────────────────────
; Payment Tracking
; ───────────────────────────────────────────────────────────────────────────────
{.payment_tracking}
start_date = date                                ; First payment date
payments_made = ##:(0..)                          ; Number of payments made
payments_remaining = ##:(0..)                     ; Payments remaining
amount_paid = #$:(0..)                            ; Total amount paid
balance_remaining = #$:(0..)                      ; Balance remaining
last_payment_date = date                          ; Last payment date
next_payment_date = date                          ; Next payment due date
past_due_amount = #$:(0..)                        ; Past due amount

{@device_financing}

; ───────────────────────────────────────────────────────────────────────────────
; Early Payoff
; ───────────────────────────────────────────────────────────────────────────────
{.early_payoff}
payoff_amount = #$:(0..)                          ; Current payoff amount
payoff_quote_date = date                          ; Payoff quote date
early_payoff_penalty = #$:(0..)                   ; Early payoff penalty
payoff_discount = #$:(0..)                        ; Discount for early payoff

{@device_financing}

; ───────────────────────────────────────────────────────────────────────────────
; Default/Charge-off
; ───────────────────────────────────────────────────────────────────────────────
{.default}
default_date = date                               ; Date of default
charged_off_date = date                           ; Date charged off
recovery_amount = #$:(0..)                        ; Amount recovered
device_returned = ?                               ; Device returned to carrier
device_blacklisted = ?                            ; Device blacklisted from network

{@device_financing}

; ═══════════════════════════════════════════════════════════════════════════════
; DEVICE UPGRADE
; ═══════════════════════════════════════════════════════════════════════════════
; Device upgrade transaction

{@device_upgrade}
; ───────────────────────────────────────────────────────────────────────────────
; Upgrade Identification
; ───────────────────────────────────────────────────────────────────────────────
upgrade_id = :                                   ; Unique upgrade identifier
upgrade_date = date                              ; Upgrade transaction date

; ───────────────────────────────────────────────────────────────────────────────
; Old and New Devices
; ───────────────────────────────────────────────────────────────────────────────
old_device_ref = :                               ; Old device reference
new_device_ref = :                               ; New device reference

; ───────────────────────────────────────────────────────────────────────────────
; Upgrade Details
; ───────────────────────────────────────────────────────────────────────────────
upgrade_type = (byod, early_upgrade, standard_upgrade, trade_in)
eligibility_date = date                           ; Upgrade eligibility date
upgrade_fee = #$:(0..)                            ; Upgrade processing fee

; ───────────────────────────────────────────────────────────────────────────────
; Trade-in (if applicable)
; ───────────────────────────────────────────────────────────────────────────────
{.trade_in}
trade_in_offered = ?                              ; Trade-in offered
trade_in_accepted = ?                             ; Trade-in accepted
trade_in_value = #$:(0..)                         ; Trade-in credit value
trade_in_applied_to = (device_price, down_payment, service_credit)
trade_in_received = ?                             ; Old device received
trade_in_condition = (damaged, excellent, fair, good, poor)

{@device_upgrade}

; ───────────────────────────────────────────────────────────────────────────────
; Subscription Association
; ───────────────────────────────────────────────────────────────────────────────
subscription_ref = :                              ; Associated subscription

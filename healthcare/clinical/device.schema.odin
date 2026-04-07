; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Healthcare Clinical - Device Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Clinical device resource representing medical equipment including implantable
; devices, durable medical equipment, and diagnostic/treatment devices. Derived
; from HL7 FHIR R4/R5 (CC0 public domain).
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as fhir

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.clinical.device"
version = "1.0.0"
title = "Healthcare Clinical Device Schema"
description = "Clinical medical device resource derived from FHIR R4/R5"

{$derivation}
source[0].authority = "HL7"
source[0].citation = "HL7 FHIR R4 - Device Resource"
source[0].url = "https://hl7.org/fhir/R4/device.html"

source[1].authority = "HL7"
source[1].citation = "HL7 FHIR R5 - Device Resource"
source[1].url = "https://hl7.org/fhir/R5/device.html"

source[2].authority = "FDA"
source[2].citation = "Unique Device Identification (UDI) System"
source[2].url = "https://www.fda.gov/medical-devices/device-advice-comprehensive-regulatory-assistance/unique-device-identification-system-udi-system"

source[3].authority = "HL7"
source[3].citation = "US Core Implantable Device Profile"
source[3].url = "https://hl7.org/fhir/us/core/StructureDefinition-us-core-implantable-device.html"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-20
changelog[0].change = "Initial clinical device schema"
changelog[0].rationale = "Device resource derived from FHIR R4/R5 specification"

; ═══════════════════════════════════════════════════════════════════════════════
; DEVICE
; ═══════════════════════════════════════════════════════════════════════════════
; FHIR: Device - https://hl7.org/fhir/R4/device.html
; An item of medical equipment

{@device}
; Resource metadata
id = !:                                       ; Logical id of resource
meta = @fhir.meta                             ; Resource metadata

; Identifiers - FHIR: Device.identifier
identifiers[] = @fhir.identifier              ; Instance identifiers

; Definition - FHIR: Device.definition
definition = @fhir.reference                  ; Reference to DeviceDefinition

; UDI carrier - FHIR: Device.udiCarrier
udi_carriers[] = @device_udi_carrier          ; Unique Device Identifier (UDI)

; Status - FHIR: Device.status
status = (active, entered_in_error, inactive, unknown)

; Status reason - FHIR: Device.statusReason
status_reasons[] = @fhir.codeable_concept     ; Why device is in current status

; Distinct identifier - FHIR: Device.distinctIdentifier
distinct_identifier = :                       ; Distinct identification string

; Manufacturer - FHIR: Device.manufacturer
manufacturer = :                              ; Name of device manufacturer

; Manufacture date - FHIR: Device.manufactureDate
manufacture_date = timestamp                  ; Date when device was made

; Expiration date - FHIR: Device.expirationDate
expiration_date = timestamp                   ; Date device expires

; Lot number - FHIR: Device.lotNumber
lot_number = :                                ; Lot number of manufacture

; Serial number - FHIR: Device.serialNumber
serial_number = :                             ; Serial number

; Device names - FHIR: Device.deviceName
device_names[] = @device_name                 ; Device names

; Model number - FHIR: Device.modelNumber
model_number = :                              ; Model number

; Part number - FHIR: Device.partNumber
part_number = :                               ; Part number

; Type - FHIR: Device.type
type = @fhir.codeable_concept                 ; Device type (SNOMED, GMDN)

; Specializations - FHIR: Device.specialization
specializations[] = @device_specialization    ; Device specializations

; Versions - FHIR: Device.version
versions[] = @device_version                  ; Device versions (software, firmware, hardware)

; Properties - FHIR: Device.property
properties[] = @device_property               ; Device properties

; Patient - FHIR: Device.patient
patient = @fhir.reference                     ; Patient to whom device is affixed

; Owner - FHIR: Device.owner
owner = @fhir.reference                       ; Organization responsible for device

; Contact - FHIR: Device.contact
contacts[] = @fhir.contact_point              ; Contact details

; Location - FHIR: Device.location
location = @fhir.reference                    ; Where device is found

; URL - FHIR: Device.url
url = :                                       ; Network address to contact device

; Notes - FHIR: Device.note
notes[] = @fhir.annotation                    ; Device notes and comments

; Safety - FHIR: Device.safety
safety[] = @fhir.codeable_concept             ; Safety characteristics

; Parent - FHIR: Device.parent
parent = @fhir.reference                      ; Device this is part of

; ───────────────────────────────────────────────────────────────────────────────
; Device UDI Carrier - FHIR: Device.udiCarrier
; ───────────────────────────────────────────────────────────────────────────────
; Unique Device Identifier per FDA UDI System

{@device_udi_carrier}
device_identifier = :                         ; Mandatory fixed portion of UDI
issuer = :                                    ; UDI Issuing Organization
jurisdiction = :                              ; Regional UDI authority
carrier_aidc = ^                              ; UDI Machine Readable Barcode String
carrier_hrf = :                               ; UDI Human Readable Barcode String
entry_type = (barcode, card, manual, rfid, self_reported, unknown)

; ───────────────────────────────────────────────────────────────────────────────
; Device Name - FHIR: Device.deviceName
; ───────────────────────────────────────────────────────────────────────────────

{@device_name}
name = !:                                     ; Device name
type = !(manufacturer_name, model_name, other, patient_reported_name, udi_label_name, user_friendly_name)

; ───────────────────────────────────────────────────────────────────────────────
; Device Specialization - FHIR: Device.specialization
; ───────────────────────────────────────────────────────────────────────────────

{@device_specialization}
system_type = !@fhir.codeable_concept         ; The standard that is used
version = :                                   ; The version of the standard

; ───────────────────────────────────────────────────────────────────────────────
; Device Version - FHIR: Device.version
; ───────────────────────────────────────────────────────────────────────────────

{@device_version}
type = @fhir.codeable_concept                 ; Type of version (software, firmware, hardware)
component = @fhir.identifier                  ; Component producing version
value = !:                                    ; Version text

; ───────────────────────────────────────────────────────────────────────────────
; Device Property - FHIR: Device.property
; ───────────────────────────────────────────────────────────────────────────────

{@device_property}
type = !@fhir.codeable_concept                ; Property type code

; Value - FHIR: Device.property.valueQuantity / valueCode
value_quantities[] = @fhir.quantity           ; Property value as quantity
value_codes[] = @fhir.codeable_concept        ; Property value as code


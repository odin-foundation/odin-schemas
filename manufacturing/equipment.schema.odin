; ===================================================================================
; ODIN Manufacturing Equipment Schema
; ===================================================================================
; Manufacturing equipment, maintenance, calibration, and tooling management.
; ===================================================================================

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.manufacturing.equipment"
version = "1.0.0"
title = "Manufacturing Equipment Schema"
description = "Equipment, maintenance, and calibration tracking"

{$derivation}
source[0].authority = "ISO"
source[0].citation = "ISO 55000 Asset Management"
source[0].url = "https://www.iso.org/standard/55088.html"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial manufacturing equipment schema"
changelog[0].rationale = "Equipment structures derived from ISO 55000"

; ===================================================================================
; EQUIPMENT
; ===================================================================================

{@equipment}
= @types.base_equipment

; Domain-specific fields
equipment_type = (assembly, cnc, fabrication, inspection, packaging, testing)
installation_date = date                         ; Installation date
criticality = (critical, important, normal)

; Specifications
capacity = :                                     ; Capacity specification
power_requirements = :                           ; Power requirements
operating_parameters = :                         ; Operating parameters

; Maintenance
maintenance_frequency_days = ##:(0..)            ; Maintenance frequency

maintenance_records[] = @maintenance_record

; ===================================================================================
; MAINTENANCE RECORD
; ===================================================================================

{@maintenance_record}
= @types.base_maintenance

; Domain-specific fields (none - all covered by base_maintenance)

; ===================================================================================
; CALIBRATION
; ===================================================================================

{@calibration}
calibration_id = :                              ; Calibration ID
equipment_id = :                                ; Equipment reference
calibration_date = date                         ; Calibration date
calibrated_by = :                               ; Calibrated by

result = (fail, in_tolerance, out_of_tolerance, pass)
certificate_number = :                           ; Certificate number

; Standards
standard_used = :                                ; Standard/reference used
standard_traceable = ?                           ; NIST traceable
standard_certificate = :                         ; Standard certificate

; Measurements
as_found[] = :                                   ; As-found readings
as_left[] = :                                    ; As-left readings
tolerance = :                                    ; Tolerance specification

next_calibration = date                          ; Next calibration due
calibration_interval_days = ##:(0..)             ; Calibration interval

; ===================================================================================
; TOOLING
; ===================================================================================

{@tooling}
tool_id = :                                     ; Tool identifier
tool_name = :                                   ; Tool name
tool_type = (cutting, die, fixture, gauge, jig, mold)

part_number = :                                  ; Tool part number
manufacturer = :                                 ; Manufacturer
location = :                                     ; Storage location
status = (active, retired, rework_needed)

; Lifecycle
expected_life_cycles = ##:(0..)                  ; Expected life (cycles)
current_cycles = ##:(0..)                        ; Current cycle count
remaining_life_percent = #:(0..100)              ; Remaining life %

last_inspection = date                           ; Last inspection
next_inspection = date                           ; Next inspection due

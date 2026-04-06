; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Property & Casualty Common Types
; ═══════════════════════════════════════════════════════════════════════════════
; Common types shared across property and casualty insurance schemas including
; risk location, loss history, excluded driver, and prior insurance details.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.types"
version = "1.0.0"
title = "Property & Casualty Common Types"
description = "Reusable type definitions for P&C insurance lines"

{$derivation}
methodology = "industry_practice"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-13
changelog[0].change = "Initial P&C common types schema"
changelog[0].rationale = "Standard P&C insurance industry data patterns"

; ═══════════════════════════════════════════════════════════════════════════════
; Excluded Driver
; ═══════════════════════════════════════════════════════════════════════════════
; Driver exclusion for personal and commercial auto
; NOT applicable to life, health, or annuity products

{@excluded_driver}
= @person                                    ; Inherits person fields (name, ssn, license, contact)

; Required fields first
date = !date                                 ; Exclusion date
number = !##:(1..)                           ; Driver sequence number

; Override required name fields
{.name}
first = !:                                   ; First name (required)
last = !:                                    ; Last name (required)

{@excluded_driver}

; Exclusion-specific fields
id = :                                       ; Unique identifier
lives_in_household = ?                       ; Lives in household
reason = :                                   ; Exclusion reason
relation = (child, domestic_partner, employee, household_member, other, parent, relative, spouse)  ; Relationship to insured
removed_date = date                          ; Date exclusion removed
removed_reason = :                           ; Reason exclusion removed
signature_date = date                        ; Date signature obtained
signature_method = (electronic, verbal, wet) ; Signature method
signature_obtained = ?                       ; Signature obtained
signature_required = ?                       ; Signature required
status = (active, pending, removed)          ; Exclusion status
type = (required, underwriting, voluntary)   ; Exclusion type

{@excluded_driver}

; ═══════════════════════════════════════════════════════════════════════════════
; Location / Risk Location
; ═══════════════════════════════════════════════════════════════════════════════
; Physical location of insured risk (home, business, garaging)
; Used by auto (garaging), home (dwelling), commercial (premises)

{@risk_location}
id = :
number = ##:(1..)
type = (business, primary, seasonal, secondary, storage)

; Address - uses shared @address type (US and Canada)
address = @address

{@risk_location}
; Coordinates
latitude = #:(-90..90)
longitude = #:(-180..180)
; Territory
territory_code = :
fire_district = :
protection_class = ##:(1..10)                     ; Fire protection class (1-10)
; Dates
effective_date = date
removed_date = date

; ═══════════════════════════════════════════════════════════════════════════════
; Loss History
; ═══════════════════════════════════════════════════════════════════════════════
; Prior loss/claim history for underwriting
; Used across all P&C lines

{@loss_history}
id = :
sequence = ##:(1..)
date = !date
reported_date = date
; Source
source = (application, clue, internal, mvr, other, prior_carrier)
source_reference = :
; Classification
type = :                            ; Line-specific (collision, fire, theft, etc.)
coverage_type = :                        ; Which coverage responded
; Fault/Cause
at_fault = ?
fault_percent = ##:(0..100)
cause_code = :
cause_description = :
; Amounts
paid_amount = #$:(0..)
reserved_amount = #$:(0..)
incurred_amount = #$:(0..)
deductible_amount = #$:(0..)
; Subrogation
subrogation_received = #$:(0..)
; Status
status = (closed, disputed, open)
disputed_reason = :
; Surcharge
surchargeable = ?
surcharge_points = ##:(0..)

; ═══════════════════════════════════════════════════════════════════════════════
; Property Valuation
; ═══════════════════════════════════════════════════════════════════════════════
; Valuation methods and amounts for insured property
; Used by auto (vehicle), home (dwelling), commercial (building/contents)

{@property_valuation}
id = :
method = (actual_cash_value, agreed_value, market_value, replacement_cost, stated_amount)
; Amounts
original_cost = #$:(0..)
current_value = #$:(0..)
replacement_cost = #$:(0..)
stated_amount = #$:(0..)
; Appraisal
appraisal_date = date
appraised_by = :
appraisal_value = #$:(0..)
; Depreciation
age_years = ##:(0..200)
depreciation_percent = ##:(0..100)
depreciated_value = #$:(0..)
; Condition
condition = (excellent, fair, good, poor)

; ═══════════════════════════════════════════════════════════════════════════════
; Inspection
; ═══════════════════════════════════════════════════════════════════════════════
; Property/risk inspection for underwriting
; Used by auto (vehicle inspection), home (property inspection)

{@inspection}
id = :
type = (appraisal, claim, compliance, safety, underwriting)
; Status
required = ?
status = (not_scheduled, scheduled, completed, passed, failed, waived)
waived_reason = :
; Schedule
scheduled_date = date
completed_date = date
; Inspector
inspector_name = :
inspector_company = :
inspector_license = :
; Results
pass_fail = (conditional, fail, pass)
deficiencies[] = :
recommendations[] = :
; Photos
photos_required = ?
photos_received = ?
photo_count = ##:(0..100)
; Report
report_received = ?
report_date = date
report_reference = :

; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Government Permitting - Building Permits and Inspections Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Building permits, inspections, and certificates of occupancy based on
; International Building Code (IBC) standards. Covers permit applications,
; plan reviews, inspection scheduling, code violations, and final occupancy
; certification.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.government.permitting.building"
version = "1.0.0"
title = "Building Permits and Inspections"
description = "Building permits, inspections, and certificates of occupancy"

{$derivation}
source[0].authority = "International Code Council"
source[0].citation = "International Building Code (IBC)"
source[0].url = "https://www.iccsafe.org/"
source[0].accessed = 2025-12-21

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial building permitting schema"
changelog[0].rationale = "Building permit and inspection requirements per IBC"

; ═══════════════════════════════════════════════════════════════════════════════
; BUILDING PERMIT
; ═══════════════════════════════════════════════════════════════════════════════

{@building_permit}
= @types.audit_info

permit_number = !:
permit_type = (addition, alteration, demolition, new_construction, repair)
work_type = (commercial, industrial, residential)

; Property Information
{.property}
address = !@address
parcel_number = :
legal_description = :
zoning_district = :

{@building_permit}
; Owner Information
{.owner}
name = !:
address = @address
phone = @phone
email = @email

{@building_permit}
; Contractor Information
{.contractor}
company_name = !:
license_number = !*:
address = @address
phone = @phone
email = @email
insurance_carrier = :
insurance_policy = :

{@building_permit}
; Project Details
{.project}
description = !:
estimated_cost = #$:(0..)
square_footage = ##:(0..)
story_count = ##:(1..)
occupancy_type = :
construction_type = :

{@building_permit}
; Application
application_date = date
issue_date = date
expiration_date = date
status = (approved, denied, expired, pending, revoked)

; Fees
permit_fee = #$:(0..)
plan_review_fee = #$:(0..)
inspection_fee = #$:(0..)
impact_fees = #$:(0..)
total_fees = #$:(0..)

; ═══════════════════════════════════════════════════════════════════════════════
; BUILDING INSPECTION
; ═══════════════════════════════════════════════════════════════════════════════

{@building_inspection}
= @types.audit_info

permit_number = !:
inspection_type = (electrical, final, footing, foundation, framing, mechanical, plumbing, rough)
inspection_date = !date
inspector_name = :

; Inspection Result
result = (approved, approved_with_conditions, failed, partial)
{.deficiencies[]}
code_section = :
description = !:
correction_required = ?

{@building_inspection}
; Re-Inspection
reinspection_required = ?
reinspection_date = date:if reinspection_required = true
reinspection_fee = #$:(0..)

; Comments
inspector_comments = :

; ═══════════════════════════════════════════════════════════════════════════════
; CERTIFICATE OF OCCUPANCY
; ═══════════════════════════════════════════════════════════════════════════════

{@certificate_of_occupancy}
= @types.audit_info

certificate_number = !:
permit_number = :
property_address = !@address

; Building Information
{.building}
occupancy_type = !:
occupancy_load = ##:(1..)
construction_type = :
building_area = ##:(0..)
story_count = ##:(1..)

{@certificate_of_occupancy}
; Certificate Details
issue_date = !date
expiration_date = date
certificate_type = (permanent, temporary)
temporary_duration = :if certificate_type = temporary

; Final Inspections Completed
all_inspections_passed = !?
{.final_inspections[]}
inspection_type = !:
inspection_date = date
passed = ?

{@certificate_of_occupancy}
; Conditions
{.conditions[]}
condition_description = :

{@certificate_of_occupancy}
; Signature
issued_by = :
title = :
issue_date = date

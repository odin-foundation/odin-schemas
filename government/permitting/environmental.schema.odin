; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Government Permitting - Environmental Permits Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Environmental permits for air quality, water discharge, waste management,
; stormwater, and NEPA review processes. Covers EPA and state agency permit
; applications, compliance monitoring, emissions reporting, and corrective
; action plans.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.government.permitting.environmental"
version = "1.0.0"
title = "Environmental Permits"
description = "Air, water, waste, stormwater, and NEPA environmental permits"

{$derivation}
source[0].authority = "U.S. Environmental Protection Agency"
source[0].citation = "Clean Air Act, Clean Water Act, RCRA Permit Programs"
source[0].url = "https://www.epa.gov/npdes"
source[0].accessed = 2025-12-21

source[1].authority = "U.S. Environmental Protection Agency"
source[1].citation = "40 CFR - Environmental Regulations"
source[1].url = "https://www.ecfr.gov/current/title-40"
source[1].accessed = 2025-12-21

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial environmental permitting schema"
changelog[0].rationale = "Environmental permits per EPA and state regulations"

; ═══════════════════════════════════════════════════════════════════════════════
; AIR QUALITY PERMIT
; ═══════════════════════════════════════════════════════════════════════════════

{@air_permit}
= @types.audit_info

permit_number = :
permit_type = (major_source, minor_source, operating, psd, synthetic_minor, title_v)
facility_name = :
facility_address = @address
naics_code = ##:(100000..999999)

; Applicant/Permittee
{.permittee}
name = :
contact_person = :
address = @address
phone = @phone
email = @email

{@air_permit}
; Emission Sources
{.emission_sources[]}
source_id = :
description = :
fuel_type = :
maximum_capacity = :
control_equipment = :

{@air_permit}
; Pollutants and Limits
{.pollutant_limits[]}
pollutant_name = :                                  ; PM2.5, NOx, SO2, VOC, etc.
cas_number = :
emission_limit = #:(0..)
unit_of_measure = :
averaging_period = :
monitoring_method = :

{@air_permit}
; Permit Dates
application_date = date
issue_date = date
effective_date = date
expiration_date = date

; Compliance Requirements
{.compliance}
monitoring_required = ?
recordkeeping_required = ?
reporting_frequency = :
stack_testing_required = ?

{@air_permit}
; ═══════════════════════════════════════════════════════════════════════════════
; WATER DISCHARGE PERMIT (NPDES)
; ═══════════════════════════════════════════════════════════════════════════════

{@water_permit}
= @types.audit_info

permit_number = :
permit_type = (individual, general, stormwater)
program = (federal_npdes, state_program)
facility_name = :
facility_address = @address

; Permittee
{.permittee}
name = :
contact_person = :
address = @address
phone = @phone
email = @email

{@water_permit}
; Discharge Points
{.outfalls[]}
outfall_id = :
latitude = #:(-90..90)
longitude = #:(-180..180)
receiving_water_name = :
discharge_type = (continuous, intermittent)

{@water_permit}
; Effluent Limitations
{.effluent_limits[]}
parameter = :                                       ; BOD, TSS, pH, etc.
daily_maximum = #:(0..)
monthly_average = #:(0..)
unit_of_measure = :
monitoring_frequency = :
sample_type = (composite, grab)

{@water_permit}
; Permit Dates
application_date = date
issue_date = date
effective_date = date
expiration_date = date

; Reporting Requirements
{.reporting}
dmr_required = ?                                     ; Discharge Monitoring Report
reporting_frequency = (annual, monthly, quarterly)
electronic_reporting_required = ?

{@water_permit}
; ═══════════════════════════════════════════════════════════════════════════════
; HAZARDOUS WASTE PERMIT (RCRA)
; ═══════════════════════════════════════════════════════════════════════════════

{@waste_permit}
= @types.audit_info

permit_number = :
epa_id_number = :
permit_type = (interim_status, post_closure, research_demo, treatment_storage_disposal)
facility_name = :
facility_address = @address

; Permittee
{.permittee}
name = :
contact_person = :
address = @address
phone = @phone
email = @email

{@waste_permit}
; Waste Management Activities
{.activities[]}
activity_type = (container_storage, incineration, land_disposal, landfill, treatment)
waste_codes[] = :                                    ; EPA hazardous waste codes
capacity = :
capacity_unit = :

{@waste_permit}
; Permit Conditions
{.conditions[]}
condition_number = :
description = :
compliance_required = ?

{@waste_permit}
; Permit Dates
application_date = date
issue_date = date
effective_date = date
expiration_date = date
modification_date = date

; ═══════════════════════════════════════════════════════════════════════════════
; STORMWATER PERMIT
; ═══════════════════════════════════════════════════════════════════════════════

{@stormwater_permit}
= @types.audit_info

permit_number = :
notice_of_intent_date = date
coverage_type = (construction, industrial, municipal)
project_name = :
project_address = @address

; Operator Information
{.operator}
name = :
contact_person = :
address = @address
phone = @phone
email = @email

{@stormwater_permit}
; Site Information
{.site}
disturbed_acreage = #:(0..)
receiving_waters = :
impaired_waters = ?
tmdl_approved = ?

{@stormwater_permit}
; Best Management Practices
{.bmps[]}
bmp_type = :
description = :
installation_date = date
maintenance_frequency = :

{@stormwater_permit}
; Inspections
{.inspections[]}
inspection_date = date
inspector_name = :
rainfall_amount = #:(0..)
deficiencies_noted[] = :

{@stormwater_permit}
; Permit Dates
authorization_date = date
project_start_date = date
project_completion_date = date
notice_of_termination_date = date

; ═══════════════════════════════════════════════════════════════════════════════
; NEPA ENVIRONMENTAL REVIEW
; ═══════════════════════════════════════════════════════════════════════════════

{@nepa_review}
= @types.audit_info

project_name = :
project_location = @address
federal_agency = :
review_level = (categorical_exclusion, eis, environmental_assessment)

; Project Description
{.project}
description = :
purpose_and_need = :
estimated_cost = #$:(0..)
project_type = :

{@nepa_review}
; Environmental Impacts
{.impacts}
air_quality_impact = ?
water_quality_impact = ?
wetlands_impact = ?
endangered_species_impact = ?
cultural_resources_impact = ?
environmental_justice_impact = ?

{@nepa_review}
; Public Process
{.public_process}
public_comment_period_start = date
public_comment_period_end = date
public_hearing_held = ?
public_hearing_date = date
comments_received = ##:(0..)

{@nepa_review}
; Determination
{.determination}
finding = (finding_of_no_significant_impact, record_of_decision, significant_impact)
determination_date = date
mitigation_required = ?
{.mitigation_measures[]}
measure_description = :
responsible_party = :
implementation_timeline = :

{@nepa_review}
; Document Dates
draft_document_date = date
final_document_date = date
decision_date = date

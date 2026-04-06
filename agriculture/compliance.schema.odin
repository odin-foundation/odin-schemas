; ===================================================================================
; ODIN Agriculture Compliance Schema
; ===================================================================================
; Agricultural compliance including FSA programs (ARC/PLC, CRP, EQIP), organic
; certification (USDA NOP), environmental compliance, food safety (GAP, FSMA),
; and labor compliance (H-2A).
; ===================================================================================

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.agriculture.compliance"
version = "1.0.0"
title = "Agriculture Compliance Schema"
description = "Agricultural compliance with FSA, organic, environmental, food safety, and labor regulations"

{$derivation}
source[0].authority = "U.S. Department of Agriculture Farm Service Agency"
source[0].citation = "Agriculture Risk Coverage (ARC) and Price Loss Coverage (PLC) Programs"
source[0].url = "https://www.fsa.usda.gov/programs-and-services/arcplc_program/index"

source[1].authority = "U.S. Department of Agriculture Farm Service Agency"
source[1].citation = "Conservation Reserve Program (CRP)"
source[1].url = "https://www.fsa.usda.gov/programs-and-services/conservation-programs/conservation-reserve-program/index"

source[2].authority = "U.S. Department of Agriculture NRCS"
source[2].citation = "Environmental Quality Incentives Program (EQIP)"
source[2].url = "https://www.nrcs.usda.gov/programs-initiatives/eqip-environmental-quality-incentives"

source[3].authority = "U.S. Department of Agriculture Agricultural Marketing Service"
source[3].citation = "7 CFR Part 205 - National Organic Program"
source[3].url = "https://www.ecfr.gov/current/title-7/subtitle-B/chapter-I/subchapter-M/part-205"

source[4].authority = "U.S. Food and Drug Administration"
source[4].citation = "21 CFR Part 112 - FSMA Produce Safety Rule"
source[4].url = "https://www.ecfr.gov/current/title-21/chapter-I/subchapter-A/part-112"

source[5].authority = "Environmental Protection Agency"
source[5].citation = "40 CFR Part 170 - Worker Protection Standard"
source[5].url = "https://www.ecfr.gov/current/title-40/chapter-I/subchapter-E/part-170"

source[6].authority = "U.S. Department of Labor"
source[6].citation = "H-2A Temporary Agricultural Workers Program"
source[6].url = "https://www.dol.gov/agencies/eta/foreign-labor/programs/h-2a"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial agriculture compliance schema"
changelog[0].rationale = "Compliance structures derived from FSA, USDA NOP, FDA FSMA, EPA, and DOL requirements"

; ===================================================================================
; FSA PROGRAM ENROLLMENT
; ===================================================================================

{@fsa_program}
; ───────────────────────────────────────────────────────────────────────────────
; Program Details
; ───────────────────────────────────────────────────────────────────────────────
enrollment_id = !:                               ; Enrollment ID
program_type = (arc_county, arc_individual, crp, csp, eqip, plc)
program_year = !##:(2014..2100)                  ; Program year
farm_number = !:                                 ; FSA farm number
state_code = !:(2)                               ; State code
county_code = !:(3)                              ; County code
enrollment_date = date                           ; Date enrolled

; ───────────────────────────────────────────────────────────────────────────────
; ARC/PLC Specifics
; ───────────────────────────────────────────────────────────────────────────────
{.arc_plc}
crop_code = :if program_type = arc_county|arc_individual|plc
base_acres = #:(0..):if program_type = arc_county|arc_individual|plc
plc_yield = #:(0..):if program_type = plc        ; PLC payment yield
reference_price = #$:(0..):if program_type = plc  ; Reference price
benchmark_revenue = #$:(0..):if program_type = arc_county|arc_individual
guarantee_percent = #:(0..100):if program_type = arc_county|arc_individual
payment_rate = #$                                ; Payment rate
total_payment = #$:(0..)                         ; Total program payment

{@fsa_program}

; ───────────────────────────────────────────────────────────────────────────────
; CRP Specifics
; ───────────────────────────────────────────────────────────────────────────────
{.crp}
contract_number = :if program_type = crp         ; CRP contract number
signup_number = :if program_type = crp           ; Signup period
practice_code = :if program_type = crp           ; Conservation practice code
contract_acres = #:(0..):if program_type = crp   ; Contract acres
contract_start = date:if program_type = crp      ; Contract start date
contract_end = date:if program_type = crp        ; Contract end date
contract_years = ##:(1..15):if program_type = crp
annual_rental_payment = #$:(0..):if program_type = crp
incentive_payment = #$:(0..):if program_type = crp
cost_share = #$:(0..):if program_type = crp      ; Cost-share assistance
soil_rental_rate = #$:(0..):if program_type = crp

{@fsa_program}

; ───────────────────────────────────────────────────────────────────────────────
; EQIP Specifics
; ───────────────────────────────────────────────────────────────────────────────
{.eqip}
contract_number = :if program_type = eqip        ; EQIP contract number
practice_codes[] = :if program_type = eqip       ; Conservation practices
contract_start = date:if program_type = eqip     ; Contract start date
contract_end = date:if program_type = eqip       ; Contract end date
total_obligation = #$:(0..):if program_type = eqip
payments_received = #$:(0..):if program_type = eqip
practices_completed[] = :if program_type = eqip

{@fsa_program}

; ───────────────────────────────────────────────────────────────────────────────
; Payment History
; ───────────────────────────────────────────────────────────────────────────────
{.payments[]}
payment_date = date                              ; Payment date
payment_type = :                                 ; Payment type
payment_amount = #$:(0..)                        ; Payment amount
fiscal_year = ##:(2000..2100)                    ; Fiscal year

; ===================================================================================
; ORGANIC CERTIFICATION (USDA NOP)
; ===================================================================================

{@organic_certification}
; ───────────────────────────────────────────────────────────────────────────────
; Certification Details
; ───────────────────────────────────────────────────────────────────────────────
certification_id = !:                            ; Certification ID
operation_name = !:                              ; Operation name
certifier = !:                                   ; Certifying agent name
certifier_number = !:                            ; Certifying agent USDA number
certification_date = date                        ; Initial certification date
certificate_issue_date = !date                   ; Current certificate issue date
certificate_expiration = !date                   ; Certificate expiration date

; ───────────────────────────────────────────────────────────────────────────────
; Scope of Certification
; ───────────────────────────────────────────────────────────────────────────────
{.scope}
scope_type = (crop, handling, livestock, wild_crop)
certified_products[] = :                         ; List of certified products
total_certified_acres = #:(0..)                  ; Total certified acres
transition_acres = #:(0..)                       ; Acres in transition
parallel_production = ?                          ; Parallel production (organic & conventional)

{@organic_certification}

; ───────────────────────────────────────────────────────────────────────────────
; Organic System Plan (OSP)
; ───────────────────────────────────────────────────────────────────────────────
{.osp}
osp_version = :                                  ; OSP version
osp_update_date = date                           ; Last OSP update
field_history[] = @organic_field_history         ; Field histories (3-year requirement)
inputs_list[] = @organic_input                   ; Approved inputs list
buffer_zones = ?                                 ; Buffer zones implemented
contamination_prevention = :                     ; Contamination prevention measures

{@organic_certification}

; ───────────────────────────────────────────────────────────────────────────────
; Inspections
; ───────────────────────────────────────────────────────────────────────────────
{.inspections[]}
inspection_date = !date                          ; Inspection date
inspector_name = :                               ; Inspector name
inspection_type = (annual, initial, renewal, spot_check, surveillance, unannounced)
findings = :                                     ; Inspection findings
corrective_actions[] = :                         ; Required corrective actions
compliance_status = (approved, conditional, non_compliant)

{@organic_certification}

; ───────────────────────────────────────────────────────────────────────────────
; Fees
; ───────────────────────────────────────────────────────────────────────────────
{.fees}
application_fee = #$:(0..)                       ; Application fee
annual_fee = #$:(0..)                            ; Annual certification fee
inspection_fee = #$:(0..)                        ; Inspection fee
certification_fee = #$:(0..)                     ; Certification fee
total_fees = #$:(0..)                            ; Total fees

; ===================================================================================
; ORGANIC FIELD HISTORY
; ===================================================================================

{@organic_field_history}
; ───────────────────────────────────────────────────────────────────────────────
; Field Information
; ───────────────────────────────────────────────────────────────────────────────
field_ref = !:                                   ; Field reference
field_name = :                                   ; Field name
acres = !#:(0..)                                 ; Field acres

; ───────────────────────────────────────────────────────────────────────────────
; History (3-year requirement)
; ───────────────────────────────────────────────────────────────────────────────
{.history[]}
:(3..)                                           ; Minimum 3 years history
year = !##:(1900..2100)                          ; Crop year
crop = !:                                        ; Crop grown
prohibited_substances_used = !?                  ; Prohibited substances used
substances_applied[] = :                         ; Substances applied
last_prohibited_date = date                      ; Last prohibited substance date

{@organic_field_history}

; ───────────────────────────────────────────────────────────────────────────────
; Transition Status
; ───────────────────────────────────────────────────────────────────────────────
{.transition}
status = (certified_organic, first_year_transition, second_year_transition, third_year_transition, transitional)
transition_start_date = date                     ; Transition start date
eligible_for_certification = date                ; Eligible date (36 months)

; ===================================================================================
; ORGANIC INPUT
; ===================================================================================

{@organic_input}
; ───────────────────────────────────────────────────────────────────────────────
; Input Details
; ───────────────────────────────────────────────────────────────────────────────
input_name = !:                                  ; Input/product name
manufacturer = :                                 ; Manufacturer
input_type = (fertilizer, pest_management, seed, soil_amendment)
omri_listed = ?                                  ; OMRI listed
approval_status = (approved, conditionally_approved, pending_review, prohibited)
approval_date = date                             ; Date approved by certifier
restrictions = :                                 ; Usage restrictions
prohibited_in = :                                ; Prohibited in (e.g., "organic livestock")

; ===================================================================================
; ENVIRONMENTAL COMPLIANCE
; ===================================================================================

{@environmental_compliance}
; ───────────────────────────────────────────────────────────────────────────────
; Program Details
; ───────────────────────────────────────────────────────────────────────────────
compliance_id = !:                               ; Compliance record ID
compliance_type = (cafo_permit, manure_management, nutrient_management, pesticide_recordkeeping, water_quality)
farm_ref = !:                                    ; Farm reference
compliance_year = ##:(2000..2100)                ; Compliance year

; ───────────────────────────────────────────────────────────────────────────────
; CAFO Permit (if applicable)
; ───────────────────────────────────────────────────────────────────────────────
{.cafo}
permit_number = :if compliance_type = cafo_permit
permit_type = (general, individual):if compliance_type = cafo_permit
cafo_size = (large, medium, small):if compliance_type = cafo_permit
animal_units = ##:(0..):if compliance_type = cafo_permit
issue_date = date:if compliance_type = cafo_permit
expiration_date = date:if compliance_type = cafo_permit
issuing_authority = :if compliance_type = cafo_permit

{@environmental_compliance}

; ───────────────────────────────────────────────────────────────────────────────
; Nutrient Management Plan
; ───────────────────────────────────────────────────────────────────────────────
{.nutrient_management}
plan_id = :if compliance_type = nutrient_management
plan_date = date:if compliance_type = nutrient_management
planner_name = :if compliance_type = nutrient_management
certified_planner = ?:if compliance_type = nutrient_management
soil_test_date = date:if compliance_type = nutrient_management
manure_test_date = date:if compliance_type = nutrient_management
application_records[] = :if compliance_type = nutrient_management

{@environmental_compliance}

; ───────────────────────────────────────────────────────────────────────────────
; Manure Management
; ───────────────────────────────────────────────────────────────────────────────
{.manure}
storage_capacity_gal = ##:(0..):if compliance_type = manure_management
storage_type = (lagoon, pit, shed_pack, solid_stack):if compliance_type = manure_management
lined = ?:if compliance_type = manure_management
inspection_date = date:if compliance_type = manure_management
inspection_status = (approved, failed, pending):if compliance_type = manure_management

{@environmental_compliance}

; ───────────────────────────────────────────────────────────────────────────────
; Water Quality
; ───────────────────────────────────────────────────────────────────────────────
{.water_quality}
monitoring_required = ?:if compliance_type = water_quality
sample_locations[] = :if compliance_type = water_quality
last_sample_date = date:if compliance_type = water_quality
results_compliant = ?:if compliance_type = water_quality
violations[] = :if compliance_type = water_quality

; ===================================================================================
; FOOD SAFETY (GAP/FSMA)
; ===================================================================================

{@food_safety}
; ───────────────────────────────────────────────────────────────────────────────
; Program Details
; ───────────────────────────────────────────────────────────────────────────────
program_id = !:                                  ; Program ID
program_type = (fsma_psr, gap, harmonized_gap, primus_gfs)
operation_name = !:                              ; Operation name
farm_ref = :                                     ; Farm reference

; ───────────────────────────────────────────────────────────────────────────────
; GAP Certification
; ───────────────────────────────────────────────────────────────────────────────
{.gap}
certifier = :if program_type = gap|harmonized_gap
certificate_number = :if program_type = gap|harmonized_gap
issue_date = date:if program_type = gap|harmonized_gap
expiration_date = date:if program_type = gap|harmonized_gap
scope = :if program_type = gap|harmonized_gap    ; Products covered
audit_date = date:if program_type = gap|harmonized_gap
audit_score = #:(0..100):if program_type = gap|harmonized_gap

{@food_safety}

; ───────────────────────────────────────────────────────────────────────────────
; FSMA Produce Safety Rule
; ───────────────────────────────────────────────────────────────────────────────
{.fsma}
covered_produce[] = :if program_type = fsma_psr  ; Covered produce grown
exempt = ?:if program_type = fsma_psr            ; Qualified exemption
exemption_reason = :if program_type = fsma_psr   ; Exemption reason
training_completed = ?:if program_type = fsma_psr
training_date = date:if program_type = fsma_psr
psa_supervisor = :if program_type = fsma_psr     ; Produce Safety Alliance supervisor

{@food_safety}

; ───────────────────────────────────────────────────────────────────────────────
; Water Testing
; ───────────────────────────────────────────────────────────────────────────────
{.water_testing}
agricultural_water_tested = ?                    ; Ag water tested
test_date = date                                 ; Test date
test_results = :                                 ; Test results
generic_ecoli_compliant = ?                      ; E. coli compliance
corrective_actions = :                           ; Corrective actions if needed

{@food_safety}

; ───────────────────────────────────────────────────────────────────────────────
; Worker Training
; ───────────────────────────────────────────────────────────────────────────────
{.worker_training}
hygiene_training_provided = ?                    ; Worker hygiene training
health_hygiene_training_date = date              ; Training date
trainer_name = :                                 ; Trainer name
records_maintained = ?                           ; Training records maintained

{@food_safety}

; ───────────────────────────────────────────────────────────────────────────────
; Inspections
; ───────────────────────────────────────────────────────────────────────────────
{.inspections[]}
inspection_date = date                           ; Inspection date
inspector_name = :                               ; Inspector name
inspection_type = (fda, state, third_party)
findings = :                                     ; Findings
corrective_actions[] = :                         ; Corrective actions required

; ===================================================================================
; LABOR COMPLIANCE (H-2A)
; ===================================================================================

{@h2a_program}
; ───────────────────────────────────────────────────────────────────────────────
; Application Details
; ───────────────────────────────────────────────────────────────────────────────
application_id = !:                              ; H-2A application ID
case_number = :                                  ; DOL case number
employer_name = !:                               ; Employer legal name
fein = *:                                        ; Federal EIN (confidential)
farm_labor_contractor = ?                        ; Using FLC

; ───────────────────────────────────────────────────────────────────────────────
; Job Opportunity
; ───────────────────────────────────────────────────────────────────────────────
{.job}
job_title = !:                                   ; Job title
job_duties = !:                                  ; Job duties description
worker_count = !##:(1..)                         ; Workers requested
begin_date = !date                               ; Employment begin date
end_date = !date                                 ; Employment end date
work_location = @types.address                   ; Primary work location
additional_locations[] = @types.address          ; Additional work locations

{@h2a_program}

; ───────────────────────────────────────────────────────────────────────────────
; Wages & Benefits
; ───────────────────────────────────────────────────────────────────────────────
{.compensation}
aewr = !#$:(0..)                                 ; Adverse Effect Wage Rate
offered_wage = !#$:(0..)                         ; Offered wage rate
wage_basis = (hourly, piece_rate)
piece_rate_description = :if wage_basis = piece_rate
guarantee_hours = ##:(0..)                       ; Three-fourths guarantee hours
inbound_transportation = ?                       ; Inbound transportation provided
outbound_transportation = ?                      ; Outbound transportation provided
daily_subsistence = #$:(0..)                     ; Daily subsistence
housing_provided = ?                             ; Housing provided
meals_provided = ?                               ; Meals provided

{@h2a_program}

; ───────────────────────────────────────────────────────────────────────────────
; Recruitment
; ───────────────────────────────────────────────────────────────────────────────
{.recruitment}
us_workers_contacted = ##:(0..)                  ; US workers contacted
us_workers_hired = ##:(0..)                      ; US workers hired
referral_sources[] = :                           ; Recruitment sources
job_order_posted = ?                             ; Job order posted
posting_dates = @types.effective_period          ; Posting period

{@h2a_program}

; ───────────────────────────────────────────────────────────────────────────────
; Certification
; ───────────────────────────────────────────────────────────────────────────────
{.certification}
application_date = date                          ; Application date
certification_date = date                        ; Certification date
validity_period = @types.effective_period        ; Validity dates
certified_workers = ##:(0..)                     ; Workers certified
denial_reason = :                                ; Denial reason if applicable
status = (approved, denied, pending, withdrawn)

{@h2a_program}

; ───────────────────────────────────────────────────────────────────────────────
; Housing
; ───────────────────────────────────────────────────────────────────────────────
{.housing}
housing_type = (dormitory, employer_provided, hotel_motel, individual_housing, mobile_home)
housing_address = @types.address                 ; Housing location
capacity = ##:(1..)                              ; Housing capacity
inspection_date = date                           ; Last inspection date
inspection_status = (approved, conditional, failed)
inspector_name = :                               ; Inspector name

; ===================================================================================
; WORKER PROTECTION STANDARD (WPS)
; ===================================================================================

{@wps_compliance}
; ───────────────────────────────────────────────────────────────────────────────
; Training Records
; ───────────────────────────────────────────────────────────────────────────────
training_id = !:                                 ; Training record ID
worker_name = !:                                 ; Worker name
worker_id = :                                    ; Worker ID
training_date = !date                            ; Training completion date
trainer_name = !:                                ; Trainer name
trainer_qualified = !?                           ; EPA-qualified trainer
training_type = (handler, worker)
training_language = :                            ; Training language
certificate_issued = ?                           ; Training certificate issued

; ───────────────────────────────────────────────────────────────────────────────
; Pesticide Safety Information
; ───────────────────────────────────────────────────────────────────────────────
{.safety_info}
safety_poster_displayed = ?                      ; Safety poster displayed
rei_information_provided = ?                     ; REI info provided to workers
emergency_info_posted = ?                        ; Emergency assistance info posted
sds_available = ?                                ; Safety Data Sheets available
decontamination_supplies = ?                     ; Decontamination supplies provided

; ═══════════════════════════════════════════════════════════════════════════════
; AUDIT/INSPECTION RECORD
; ═══════════════════════════════════════════════════════════════════════════════

{@audit_record}
; ───────────────────────────────────────────────────────────────────────────────
; Audit Details
; ───────────────────────────────────────────────────────────────────────────────
audit_id = !:                                    ; Audit ID
audit_date = !date                               ; Audit date
audit_type = (customer, government, internal, third_party)
auditor_name = !:                                ; Lead auditor
auditor_company = :                              ; Auditing company
standard = :                                     ; Standard audited against

; ───────────────────────────────────────────────────────────────────────────────
; Scope
; ───────────────────────────────────────────────────────────────────────────────
{.scope}
facility_audited = :                             ; Facility name
areas_audited[] = :                              ; Areas covered
products_covered[] = :                           ; Products in scope

{@audit_record}

; ───────────────────────────────────────────────────────────────────────────────
; Results
; ───────────────────────────────────────────────────────────────────────────────
{.results}
overall_score = #:(0..100)                       ; Overall score
pass_fail = (fail, pass)
critical_findings = ##:(0..)                     ; Critical non-conformances
major_findings = ##:(0..)                        ; Major non-conformances
minor_findings = ##:(0..)                        ; Minor non-conformances
observations = ##:(0..)                          ; Observations

{@audit_record}

; ───────────────────────────────────────────────────────────────────────────────
; Corrective Actions
; ───────────────────────────────────────────────────────────────────────────────
{.corrective_actions[]}
finding_id = :                                   ; Finding ID
finding_description = :                          ; Description
severity = (critical, major, minor, observation)
corrective_action = :                            ; Action taken
responsible_party = :                            ; Person responsible
target_date = date                               ; Target completion date
completion_date = date                           ; Actual completion date
verified = ?                                     ; Verification completed

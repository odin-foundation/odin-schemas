; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Public Health Emergency Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Public health emergency structures covering declarations, response operations,
; waivers, and resource allocation. Derived from HHS/ASPR Section 319,
; FEMA Stafford Act, and PHE authorities.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.publichealth.emergency"
version = "1.0.0"
title = "Public Health Emergency Schema"
description = "Public health emergency structures and declarations"

{$derivation}
source[0].authority = "HHS"
source[0].citation = "42 USC 247d - Public Health Service Act Section 319"
source[0].url = "https://www.law.cornell.edu/uscode/text/42/247d"

source[1].authority = "FEMA"
source[1].citation = "44 CFR Part 206 - Stafford Act Implementation"
source[1].url = "https://www.ecfr.gov/current/title-44/chapter-I/subchapter-D/part-206"

source[2].authority = "ASPR"
source[2].citation = "Public Health Emergency Declarations"
source[2].url = "https://aspr.hhs.gov/legal/PHE/Pages/default.aspx"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial public health emergency schema"
changelog[0].rationale = "Structure derived from HHS PHE and Stafford Act authorities"

; ═══════════════════════════════════════════════════════════════════════════════
; PUBLIC HEALTH EMERGENCY DECLARATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 USC 247d (Section 319)

{@declaration}
declaration_id = !:                         ; Declaration identifier
declaration_type = !(national_emergency, phe_section_319, stafford_declaration, state_declaration)
jurisdiction = !:                           ; Declaring jurisdiction

; Declaration details
{.details}
title = !:                                  ; Declaration title
threat = :                                  ; Threat/hazard description
legal_authority = :                         ; Legal authority cited
effective_date = !date                      ; Effective date
expiration_date = date                      ; Expiration date (if time-limited)

{@declaration}

; Declaring official
{.official}
declared_by = :                             ; Name/title of declaring official
agency = :                                  ; Agency
declaration_date = !date                    ; Date signed

{@declaration}

; Geographic scope
{.geography}
nationwide = ?                              ; Nationwide declaration
states[] = :(2)                             ; Affected states
counties[] = :                              ; Affected counties (FIPS)
territories[] = :                           ; Territories

{@declaration}

; Authorities activated - Per Section 319
{.authorities}
emergency_use_authorization = ?             ; EUA authority (21 USC 360bbb-3)
liability_protections = ?                   ; PREP Act declaration
waiver_1135 = ?                             ; CMS 1135 waivers
strategic_national_stockpile = ?            ; SNS deployment
emergency_funding = ?                       ; Emergency funding activated
medical_countermeasures = ?                 ; MCM authority
quarantine_authority = ?                    ; Quarantine authority

{@declaration}

; Status
{.status}
status = !(active, expired, renewed, terminated)
renewals[] = date                           ; Renewal dates
termination_date = date                     ; Termination date

{@declaration}

; ═══════════════════════════════════════════════════════════════════════════════
; STAFFORD ACT DECLARATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 USC 5121 et seq.

{@stafford_declaration}
disaster_number = !:                        ; FEMA disaster number
declaration_type = !(emergency, major_disaster)
incident_type = !:                          ; Type of incident

; Request
{.request}
requested_by = :                            ; Governor/tribal leader
request_date = date                         ; Date requested
request_letter = :                          ; Request letter reference

{@stafford_declaration}

; Presidential declaration
{.declaration}
declared = ?                                ; Declaration approved
declaration_date = date                     ; Date declared
declared_by = : "President"                 ; Declaring authority

{@stafford_declaration}

; Incident period
{.incident}
incident_start = !date                      ; Incident period begin
incident_end = date                         ; Incident period end

{@stafford_declaration}

; Designated areas
{.designated_areas}
states[] = :(2)                             ; States
counties[] = :                              ; Designated counties (FIPS)
tribal_areas[] = :                          ; Tribal areas

{@stafford_declaration}

; Assistance authorized
{.assistance}
individual_assistance = ?                   ; IA authorized
public_assistance = ?                       ; PA authorized
hazard_mitigation = ?                       ; HMGP authorized
emergency_protective = ?                    ; Emergency protective measures
direct_federal_assistance = ?               ; DFA authorized

{@stafford_declaration}

; Federal coordinating officer
{.fco}
fco_name = :                                ; FCO name
fco_appointed = date                        ; Date appointed

{@stafford_declaration}

; ═══════════════════════════════════════════════════════════════════════════════
; EMERGENCY RESPONSE ACTIVATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per ICS/NIMS standards

{@response_activation}
activation_id = !:                          ; Activation identifier
incident_name = !:                          ; Incident name
activation_date = !date                     ; Activation date

; Incident type
{.incident}
incident_type = :                           ; Type of incident
cause = :                                   ; Cause if known
affected_population = ##:(0..)              ; Estimated affected population

{@response_activation}

; Command structure
{.command}
incident_commander = :                      ; IC name
unified_command = ?                         ; Unified command activated
area_command = ?                            ; Area command established

{@response_activation}

; ESF activations
{.esf}
esf_activated[] = ##:(1..15)                ; Emergency Support Functions activated
; ESF-8 = Public Health and Medical Services
esf8_lead = :                               ; ESF-8 lead agency
medical_surge = ?                           ; Medical surge activated
mortuary_ops = ?                            ; Mass fatality activated

{@response_activation}

; Operations center
{.operations}
eoc_activated = ?                           ; EOC activated
eoc_level = ##:(1..3)                       ; EOC activation level (1=full)
doh_ops_center = ?                          ; Health dept ops center
cdc_eoc = ?                                 ; CDC EOC activated

{@response_activation}

; Status
{.status}
operational_period = :                      ; Current operational period
status = (active, demobilized, monitoring)
deactivation_date = date                    ; Deactivation date

{@response_activation}

; ═══════════════════════════════════════════════════════════════════════════════
; MEDICAL COUNTERMEASURES
; ═══════════════════════════════════════════════════════════════════════════════
; Per ASPR/BARDA MCM framework

{@medical_countermeasure}
mcm_id = !:                                 ; MCM identifier
mcm_type = !(antidote, diagnostic, ppe, therapeutic, vaccine)
product_name = !:                           ; Product name

; Product details
{.product}
manufacturer = :                            ; Manufacturer
ndc = :                                     ; NDC code
lot_numbers[] = :                           ; Lot numbers deployed
fda_status = (approved, authorized_eua, investigational)

{@medical_countermeasure}

; Deployment
{.deployment}
deployed_from = (commercial, sns, state_stockpile)
; sns = Strategic National Stockpile
deployment_date = date                      ; Date deployed
quantity_deployed = ##:(0..)                ; Quantity
destination = :                             ; Deployment destination

{@medical_countermeasure}

; Distribution
{.distribution}
distribution_site = :                       ; Distribution site type
point_of_dispensing = ?                     ; POD operations
doses_distributed = ##:(0..)                ; Doses distributed
doses_administered = ##:(0..)               ; Doses administered

{@medical_countermeasure}

; EUA details (if authorized under EUA)
{.eua}
eua_number = :                              ; EUA number
eua_date = date                             ; EUA issuance date
authorized_use = :                          ; Authorized use
fact_sheet_required = ?                     ; Fact sheet required

{@medical_countermeasure}

; ═══════════════════════════════════════════════════════════════════════════════
; CRISIS STANDARDS OF CARE
; ═══════════════════════════════════════════════════════════════════════════════
; Per IOM/NAM CSC framework

{@crisis_standards}
csc_id = !:                                 ; CSC activation ID
jurisdiction = !:                           ; Jurisdiction
activation_date = !date                     ; Activation date

; Activation
{.activation}
declared_by = :                             ; Declaring authority
legal_authority = :                         ; Legal authority
activation_level = (contingency, conventional, crisis)
trigger_event = :                           ; Triggering event

{@crisis_standards}

; Scope
{.scope}
statewide = ?                               ; Statewide activation
facilities[] = :                            ; Specific facilities
care_areas[] = :                            ; Care areas affected (ICU, ED, etc.)

{@crisis_standards}

; Indicators/triggers
{.indicators}
ventilator_shortage = ?                     ; Ventilator shortage
bed_shortage = ?                            ; Bed shortage
staffing_shortage = ?                       ; Staffing shortage
supply_shortage = ?                         ; Supply shortage
medication_shortage = ?                     ; Medication shortage

{@crisis_standards}

; Strategies activated
{.strategies}
allocation_protocols = ?                    ; Allocation protocols activated
triage_protocols = ?                        ; Crisis triage protocols
alternate_care_sites = ?                    ; Alternate care sites
resource_sharing = ?                        ; Resource sharing agreements

{@crisis_standards}

; Status
{.status}
status = (active, deactivated)
deactivation_date = date                    ; Deactivation date
deactivation_criteria = :                   ; Criteria for deactivation

{@crisis_standards}

; ═══════════════════════════════════════════════════════════════════════════════
; QUARANTINE ORDER
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR Part 70-71 (federal) and state authorities

{@quarantine_order}
order_id = !:                               ; Order identifier
order_type = !(federal, local, state)
jurisdiction = !:                           ; Issuing jurisdiction

; Authority
{.authority}
legal_authority = :                         ; Legal authority cited
issuing_agency = :                          ; Issuing agency
issuing_official = :                        ; Official name/title
order_date = !date                          ; Date issued

{@quarantine_order}

; Order details
{.details}
order_type = !(isolation, quarantine, travel_restriction)
condition = :                               ; Disease/condition
duration_days = ##:(0..30)                  ; Duration (days)
effective_date = date                       ; Effective date
expiration_date = date                      ; Expiration date

{@quarantine_order}

; Persons/areas subject to order
{.subject}
individual_order = ?                        ; Individual order
individual_name = *:                        ; Individual name (if individual)
geographic_area = :                         ; Geographic area (if area)
facility = :                                ; Facility (if facility-based)

{@quarantine_order}

; Requirements
{.requirements}
stay_at_home = ?                            ; Stay at home required
monitoring_required = ?                     ; Health monitoring
testing_required = ?                        ; Testing required
violations_penalty = :                      ; Penalty for violations

{@quarantine_order}

; Status
{.status}
status = (active, expired, terminated)
termination_date = date                     ; Termination date
compliance = ?                              ; Order complied with

{@quarantine_order}

; ═══════════════════════════════════════════════════════════════════════════════
; WAIVER (1135)
; ═══════════════════════════════════════════════════════════════════════════════
; Per Section 1135 of Social Security Act

{@waiver_1135}
waiver_id = !:                              ; Waiver identifier
emergency_declaration = !:                  ; Associated PHE/disaster
effective_date = !date                      ; Effective date

; Waiver scope
{.scope}
geographic_scope = :                        ; Geographic scope
provider_types[] = :                        ; Provider types affected
affected_requirements[] = :                 ; Requirements waived

{@waiver_1135}

; Specific waivers - Per CMS 1135 waiver authority
{.waivers}
emtala = ?                                  ; EMTALA requirements waived
licensure = ?                               ; State licensure
hipaa_sanctions = ?                         ; HIPAA sanction waiver
conditions_participation = ?                ; COPs waived
clia = ?                                    ; CLIA requirements
physician_self_referral = ?                 ; Stark law waiver
screening_requirements = ?                  ; SNF screening
preadmission_screening = ?                  ; PASRR waived
face_to_face = ?                            ; Face-to-face requirements

{@waiver_1135}

; Status
{.status}
status = (active, expired)
expiration_date = date                      ; Expiration date
terminated_early = ?                        ; Terminated before PHE end

{@waiver_1135}

; Blanket waiver info
{.blanket}
blanket_waiver = ?                          ; Blanket vs individual
individual_provider_approval = ?            ; Requires individual approval
notification_required = ?                   ; Notification to CMS required

{@waiver_1135}


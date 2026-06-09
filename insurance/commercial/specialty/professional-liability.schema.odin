; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Professional Liability Insurance (E&O) Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Professional liability (errors and omissions) coverage for technology/IT,
; accountants, lawyers, architects/engineers, healthcare providers, insurance
; agents, real estate professionals, and financial advisors.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../coverages/coverage.schema.odin" as cov
@import "../../coverages/lines/professional.schema.odin" as professional
@import "../../common/types.schema.odin" as com
@import "../business.schema.odin" as entity

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.specialty.professional-liability"
version = "2.0.0"
title = "Professional Liability Insurance Schema"
description = "Comprehensive E&O coverage extending universal coverage primitive"

{$derivation}
source[0].authority = "American Bar Association"
source[0].citation = "Model Rules of Professional Conduct"
source[0].url = "https://www.americanbar.org/groups/professional_responsibility/"

source[1].authority = "American Institute of Certified Public Accountants"
source[1].citation = "AICPA Professional Standards"
source[1].url = "https://www.aicpa-cima.com/resources/landing/standards-and-statements"

source[2].authority = "State Medical Boards"
source[2].citation = "Medical Practice Acts"
source[2].url = "https://www.fsmb.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Professional liability schema extending universal coverage primitive"

changelog[0].date = 2025-12-14
changelog[0].change = "Refactored to extend universal coverage primitive"
changelog[0].rationale = "Coverage-centric architecture - extend @professional_coverage from coverage/lines/professional.schema.odin"

changelog[1].date = 2025-12-13
changelog[1].change = "Initial professional liability schema"
changelog[1].rationale = "Comprehensive E&O coverage structure for all professions"

; ═══════════════════════════════════════════════════════════════════════════════
; Professional Practice Profile
; ═══════════════════════════════════════════════════════════════════════════════

{@pl_professional}
professional_id = :

; ───────────────────────────────────────────────────────────────────────────────
; Professional Category
; ───────────────────────────────────────────────────────────────────────────────
profession_category = (
    ; Technology
    accounting_firms,
    allied_health,
    appraisers,
    architects,
    attorneys,
    bookkeepers,
    broker_dealers,
    chiropractors,
    clinics,
    cpas,
    data_processing,
    dentists,
    engineers,
    environmental_consultants,
    financial_planners,
    hedge_funds,
    hospitals,
    hr_consultants,
    insurance_agents,
    insurance_brokers,
    interior_designers,
    investment_advisors,
    it_consulting,
    laboratories,
    landscape_architects,
    law_firms,
    legal_services,
    managed_services,
    management_consultants,
    marketing_consultants,
    mental_health,
    mgas,
    mortgage_brokers,
    notaries,
    nurses,
    other,
    pharmacies,
    physicians,
    private_equity,
    property_managers,
    real_estate_agents,
    real_estate_brokers,
    saas_provider,
    software_development,
    staffing_agencies,
    surgeons,
    surveyors,
    system_integrator,
    tax_preparers,
    technology_services,
    title_agents,
    tpa,
    travel_agents,
    veterinarians,
    wealth_managers
)

profession_description = ::if profession_category = other

; ───────────────────────────────────────────────────────────────────────────────
; Professional Services Rendered
; ───────────────────────────────────────────────────────────────────────────────
services_description = :
services_primary[] = :
services_secondary[] = :

; Service Delivery
service_delivery = (in_person, remote, hybrid)
services_rendered_states[] = :(2)
services_rendered_countries[] = :

; ───────────────────────────────────────────────────────────────────────────────
; Licensing / Credentials
; ───────────────────────────────────────────────────────────────────────────────
{.licenses[]}
type = :
number = *:
state_province = :(2)                         ; US state or Canadian province
expiration_date = date
status = (active, inactive, suspended, revoked)

certifications[] = :
professional_designations[] = :        ; CPA, PE, RIA, etc.

; ───────────────────────────────────────────────────────────────────────────────
; Professional Staff
; ───────────────────────────────────────────────────────────────────────────────
{.staff}
principals = ##
licensed_professionals = ##
unlicensed_staff = ##
independent_contractors = ##
subcontractors_used = ?

{@pl_professional}

; ───────────────────────────────────────────────────────────────────────────────
; Revenue and Billing
; ───────────────────────────────────────────────────────────────────────────────
{.revenue}
annual_gross = #$
professional_fees = #$
fee_structure = (contingency, fixed_fee, hourly, mixed, retainer, subscription)

; Revenue by Service Type (percentages)
{.breakdown[]}
service = :
percentage = #:(0..100)

{@pl_professional}

; Largest Client
{.revenue}
largest_client_percentage = #:(0..100)
top_5_clients_percentage = #:(0..100)

{@pl_professional}

; ───────────────────────────────────────────────────────────────────────────────
; Client Profile
; ───────────────────────────────────────────────────────────────────────────────
{.clients}
client_count = ##
types[] = (
    financial_institutions,
    government,
    healthcare,
    individuals,
    large_corporations,
    mid_market,
    nonprofit,
    other,
    publicly_traded,
    small_business
)

; Client Contracts
written_contracts = ?
contracts_reviewed_by_counsel = ?
limitation_of_liability_clauses = ?
indemnification_clauses = ?
arbitration_clauses = ?

{@pl_professional}

; ═══════════════════════════════════════════════════════════════════════════════
; Technology E&O Specific
; ═══════════════════════════════════════════════════════════════════════════════

{@pl_tech_eo}
tech_id = :

; Technology Services
{.services}
software_development = ?
custom_software = ?:if services.software_development = true
packaged_software = ?:if services.software_development = true
saas = ?
cloud_services = ?
managed_services = ?
system_integration = ?
data_processing = ?
data_analytics = ?
ai_ml_services = ?
iot_services = ?

{@pl_tech_eo}

; Technology Products
{.products}
software_products = ?
source_code_escrow = ?
open_source_components = ?
api_services = ?

{@pl_tech_eo}

; Service Level Agreements
{.sla}
provides_slas = ?
uptime_guarantee = ##:(0..100):if sla.provides_slas = true
financial_penalties = ?:if sla.provides_slas = true

{@pl_tech_eo}

; Development Standards
{.standards}
secure_sdlc = ?
code_review = ?
penetration_testing = ?
vulnerability_scanning = ?

{@pl_tech_eo}

; ═══════════════════════════════════════════════════════════════════════════════
; Medical Professional Liability Specific
; ═══════════════════════════════════════════════════════════════════════════════

{@pl_medical}
medical_id = :

; Provider Type
provider_type = (
    allied_health,
    chiropractor,
    clinic,
    dentist,
    hospital,
    mental_health,
    nurse_practitioner,
    nursing_facility,
    other,
    physician,
    physician_assistant,
    surgeon
)

; Specialty (Physicians)
specialty = (
    anesthesiology,
    cardiology,
    cardiothoracic_surgery,
    dermatology,
    emergency_medicine,
    family_practice,
    gastroenterology,
    general_surgery,
    internal_medicine,
    nephrology,
    neurology,
    neurosurgery,
    obstetrics_gynecology,
    oncology,
    ophthalmology,
    orthopedic_surgery,
    other,
    otolaryngology,
    pain_management,
    pathology,
    pediatrics,
    plastic_surgery,
    psychiatry,
    pulmonology,
    radiology,
    rheumatology,
    urology
)

; Practice Details
board_certified = ?
hospital_privileges = ?
hospital_names[] = ::if hospital_privileges = true
surgical_procedures = ?
procedures_performed[] = :
annual_patient_encounters = ##

; Risk Factors
high_risk_procedures = ?
cosmetic_procedures = ?
weight_loss_procedures = ?
telemedicine = ?
telemedicine_percentage = #:(0..100):if telemedicine = true
clinical_trials = ?

; ═══════════════════════════════════════════════════════════════════════════════
; Architects & Engineers Specific
; ═══════════════════════════════════════════════════════════════════════════════

{@pl_ae}
ae_id = :

; Discipline
discipline = (
    architecture,
    civil_engineering,
    construction_management,
    electrical_engineering,
    environmental_engineering,
    geotechnical_engineering,
    interior_design,
    landscape_architecture,
    mechanical_engineering,
    other,
    structural_engineering,
    surveying
)

; Project Types
project_types[] = (
    bridges_roads,
    commercial,
    educational,
    environmental,
    government,
    healthcare,
    industrial,
    infrastructure,
    institutional,
    other,
    residential,
    water_wastewater
)

; Project Size
largest_project_value = #$
average_project_value = #$
projects_over_10m_percentage = #:(0..100)
projects_over_50m_percentage = #:(0..100)

; Structural/Design Risk
structural_design = ?
seismic_design = ?
high_rise_design = ?
environmental_impact = ?
hazardous_materials = ?

; Contractual
standard_contract_forms = (aia, ejcdc, consensusdocs, custom)
limitation_of_liability = ?
indemnification_caps = ?

; ═══════════════════════════════════════════════════════════════════════════════
; PL Commercial Coverage (Extends @eo_coverage from professional line)
; ═══════════════════════════════════════════════════════════════════════════════
; Inherits from @eo_coverage which inherits from @professional_coverage <- @coverage

{@pl_commercial_coverage}
= @eo_coverage                                    ; Inherit from E&O line extension

; ───────────────────────────────────────────────────────────────────────────────
; Retention / Deductible
; ───────────────────────────────────────────────────────────────────────────────
retention = ##
retention_type = (each_claim, each_occurrence)
retention_includes_defense = ?
coinsurance_percentage = #:(0..50)

; ───────────────────────────────────────────────────────────────────────────────
; Covered Wrongful Acts
; ───────────────────────────────────────────────────────────────────────────────

{.covered_acts}
professional_services = ?true
negligent_acts = ?true
errors = ?true
omissions = ?true
breach_of_duty = ?true
misrepresentation = ?
breach_of_contract = ?
personal_injury = ?
defamation = ?
violation_of_privacy = ?

{@pl_commercial_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Additional Coverage Grants
; ───────────────────────────────────────────────────────────────────────────────

{.additional}
disciplinary_proceedings = ?
disciplinary_sublimit = #$:if additional.disciplinary_proceedings = true

subpoena_response = ?
subpoena_sublimit = #$:if additional.subpoena_response = true

breach_of_contract = ?
breach_contract_sublimit = #$:if additional.breach_of_contract = true

loss_of_documents = ?
documents_sublimit = #$:if additional.loss_of_documents = true

pre_claim_assistance = ?
pre_claim_sublimit = #$:if additional.pre_claim_assistance = true

crisis_management = ?
crisis_sublimit = #$:if additional.crisis_management = true

network_security = ?
network_security_sublimit = #$:if additional.network_security = true

privacy_liability = ?
privacy_sublimit = #$:if additional.privacy_liability = true

{@pl_commercial_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Prior Acts Coverage
; ───────────────────────────────────────────────────────────────────────────────

{.prior_acts}
full_prior_acts = ?
retroactive_date = date:if prior_acts.full_prior_acts = false
nose_coverage = ?                  ; Coverage for unknown claims at inception

{@pl_commercial_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Extended Reporting Period (Tail)
; ───────────────────────────────────────────────────────────────────────────────

{.erp}
basic_included = ?
basic_days = ##:(0..90):if erp.basic_included = true
supplemental_available = ?
supplemental_options[] = (1_year, 2_year, 3_year, 5_year, unlimited)
supplemental_premium_percentage = #:

{@pl_commercial_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Professional Liability Claims History
; ═══════════════════════════════════════════════════════════════════════════════

{@pl_claims_history}
history_id = :

; Claims (Last 5 Years)
total_claims_5_years = ##
total_incurred_5_years = #$

{.claims[]}
claim_number = :
date_of_incident = date
date_reported = date
allegation = :
claimant_type = (client, regulatory, third_party)
status = (open, closed_paid, closed_no_payment)
paid_indemnity = #$
paid_defense = #$
reserves = #$

{@pl_claims_history}

; Disciplinary Actions
disciplinary_actions = ##
license_suspensions = ##
license_revocations = ##

; ═══════════════════════════════════════════════════════════════════════════════
; Professional Liability Endorsements
; ═══════════════════════════════════════════════════════════════════════════════

{@pl_endorsement}
id = :
number = :
title = :
effective_date = date

; Endorsement Type
type = (
    disciplinary_coverage,
    increased_limits,
    innocent_partner,
    joint_venture_coverage,
    network_security_privacy,
    other,
    pollution_coverage,
    predecessor_firm_coverage,
    prior_acts_extension,
    punitive_damages,
    reduced_retention,
    specific_client_exclusion,
    specific_service_exclusion
)

description = :
premium_impact = #$

; ═══════════════════════════════════════════════════════════════════════════════
; Professional Liability Policy
; ═══════════════════════════════════════════════════════════════════════════════

{@pl_policy}
id = :
number = :

; ───────────────────────────────────────────────────────────────────────────────
; Term
; ───────────────────────────────────────────────────────────────────────────────
effective_date = date
effective_time = time
expiration_date = date
expiration_time = time
:invariant expiration_date > effective_date

; ───────────────────────────────────────────────────────────────────────────────
; Policy Type
; ───────────────────────────────────────────────────────────────────────────────
policy_form = (claims_made, occurrence)
type = (
    excess,
    primary,
    quota_share
)

; ───────────────────────────────────────────────────────────────────────────────
; Claims-Made Dates
; ───────────────────────────────────────────────────────────────────────────────
retroactive_date = date:if policy_form = claims_made
continuity_date = date:if policy_form = claims_made
pending_prior_date = date:if policy_form = claims_made

; ───────────────────────────────────────────────────────────────────────────────
; Named Insured
; ───────────────────────────────────────────────────────────────────────────────
named_insured = @entity.business

; ───────────────────────────────────────────────────────────────────────────────
; Professional Profile
; ───────────────────────────────────────────────────────────────────────────────
professional = @pl_professional

; Profession-Specific Details
tech_eo = @pl_tech_eo:if professional.profession_category = technology_services
medical = @pl_medical:if professional.profession_category = physicians
ae = @pl_ae:if professional.profession_category = architects

; ───────────────────────────────────────────────────────────────────────────────
; Coverage
; ───────────────────────────────────────────────────────────────────────────────
coverage = @pl_commercial_coverage

; ───────────────────────────────────────────────────────────────────────────────
; Claims History
; ───────────────────────────────────────────────────────────────────────────────
claims_history = @pl_claims_history

; ───────────────────────────────────────────────────────────────────────────────
; Endorsements
; ───────────────────────────────────────────────────────────────────────────────
endorsements[] = @pl_endorsement

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────

{.premium}
base = #$
additional_coverages = #$
endorsements = #$
taxes_fees = #$
total = #$
minimum = #$

{@pl_policy}



; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Professional Liability Coverage Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Professional liability coverage line extension of the universal coverage
; primitive adding E&O-specific fields for claims-made triggers, professional
; categories, and regulatory compliance.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../coverage.schema.odin" as cov
@import "../limits.schema.odin" as limits

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.coverages.lines.professional"
version = "1.0.0"
title = "Professional Liability Coverage Schema"
description = "Professional liability coverage extending universal coverage primitive"

{$derivation}
source[0].authority = "U.S. Department of Labor"
source[0].citation = "Employee Benefits Security Administration"
source[0].url = "https://www.dol.gov/agencies/ebsa"

source[1].authority = "National Association of Insurance Commissioners (NAIC)"
source[1].citation = "Professional Liability Model Laws and Regulations"
source[1].url = "https://content.naic.org/"

source[2].authority = "State Insurance Departments"
source[2].citation = "Various state professional liability regulations"
source[2].url = "https://www.usa.gov/state-insurance"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Professional liability coverage line extension"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial professional liability coverage schema"
changelog[0].rationale = "Coverage-centric architecture - professional line extension"

; ═══════════════════════════════════════════════════════════════════════════════
; Professional Coverage (Extends Universal Coverage)
; ═══════════════════════════════════════════════════════════════════════════════

{@professional_coverage}
= @coverage                                       ; Inherit all universal coverage fields

; ───────────────────────────────────────────────────────────────────────────────
; Form Type (Almost Always Claims-Made)
; ───────────────────────────────────────────────────────────────────────────────
form_type = !(claims_made, occurrence)
form_type = "claims_made"                         ; Default to claims-made

; ───────────────────────────────────────────────────────────────────────────────
; Claims-Made Dates
; ───────────────────────────────────────────────────────────────────────────────
retroactive_date = date                           ; Retro date (claims must arise after this)
continuity_date = date                            ; First uninterrupted claims-made coverage
prior_acts_date = date                            ; Coverage for acts before policy inception

; ───────────────────────────────────────────────────────────────────────────────
; Extended Reporting Period (ERP/Tail)
; ───────────────────────────────────────────────────────────────────────────────
{.erp}
basic_available = ?
basic_days = ##:(0..90)                           ; Standard: 30-60 days
basic_automatic = ?                               ; Automatic vs must elect

supplemental_available = ?
supplemental_options[] = (1_year, 2_year, 3_year, 5_year, unlimited)
supplemental_premium_percent = ##:(0..300)        ; % of expiring premium

{@professional_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Professional Liability Limits
; ───────────────────────────────────────────────────────────────────────────────
{.pl_limits}
each_claim = !#$                                  ; Per claim limit
aggregate = !#$                                   ; Annual aggregate
each_wrongful_act = #$                            ; Per wrongful act (if different)

{@professional_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Defense Cost Handling
; ───────────────────────────────────────────────────────────────────────────────
defense_within_limits = ?                         ; Defense costs erode limits
defense_outside_limits = ?                        ; Defense costs outside limits
duty_to_defend = ?                                ; Insurer has duty to defend
reimbursement = ?                                 ; vs reimbursement of defense costs

; Deductible applies to defense
deductible_applies_to_defense = ?

; ───────────────────────────────────────────────────────────────────────────────
; Consent to Settle
; ───────────────────────────────────────────────────────────────────────────────
consent_to_settle = ?
hammer_clause = ?                                 ; Penalty for refusing settlement
hammer_percent = ##:(0..100):if hammer_clause = true ; % insured pays if refuses

; ═══════════════════════════════════════════════════════════════════════════════
; Errors and Omissions Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@eo_coverage}
= @professional_coverage

coverage_type_ref = "PL_EO"

; Professional type
professional_type = (
    accountants,
    architects_engineers,
    attorneys,
    consultants,
    financial_advisors,
    healthcare,
    insurance_agents,
    real_estate,
    technology
)

; Services covered
{.services}
professional_services = ?
technology_services = ?
consulting_services = ?
managed_services = ?

{@eo_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Directors and Officers Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@do_coverage}
= @professional_coverage

coverage_type_ref = "DO"

; Coverage sides
{.coverage_sides}
side_a = ?                                        ; Non-indemnifiable loss (direct to D&O)
side_b = ?                                        ; Corporate reimbursement
side_c = ?                                        ; Entity coverage

; Side A limits
side_a_limit = #$:if side_a = true
side_a_dedicated = ?:if side_a = true             ; Dedicated Side A (DIC)

{@do_coverage}

; Entity type
entity_type = (for_profit, nonprofit, private, public)

; Securities claim
securities_claim = ?
sec_registered = ?:if securities_claim = true

; ═══════════════════════════════════════════════════════════════════════════════
; Employment Practices Liability Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@epl_coverage}
= @professional_coverage

coverage_type_ref = "EPL"

; Covered claims
{.covered_claims}
discrimination = ?
harassment = ?
wrongful_termination = ?
retaliation = ?
failure_to_promote = ?
breach_of_contract = ?
defamation = ?
invasion_of_privacy = ?
wage_hour = ?                                     ; May be excluded or sublimited

{@epl_coverage}

; Third party coverage
third_party = ?
third_party_limit = #$:if third_party = true

; Wage and hour sublimit
wage_hour_sublimit = #$:if wage_hour = true

; ═══════════════════════════════════════════════════════════════════════════════
; Fiduciary Liability Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@fiduciary_coverage}
= @professional_coverage

coverage_type_ref = "FID"

; Covered plans
{.covered_plans}
defined_benefit = ?
defined_contribution = ?
health_welfare = ?
esop = ?

{@fiduciary_coverage}

; DOL investigation
dol_investigation = ?
dol_sublimit = #$:if dol_investigation = true

; Voluntary correction
voluntary_correction = ?
correction_sublimit = #$:if voluntary_correction = true

; ═══════════════════════════════════════════════════════════════════════════════
; Cyber Liability Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@cyber_coverage}
= @professional_coverage

coverage_type_ref = "CYBER"

; First party coverages
{.first_party}
breach_response = ?
breach_response_limit = #$:if breach_response = true
data_restoration = ?
data_restoration_limit = #$:if data_restoration = true
business_interruption = ?
bi_limit = #$:if business_interruption = true
bi_waiting_hours = ##:(0..168):if business_interruption = true
cyber_extortion = ?
extortion_limit = #$:if cyber_extortion = true

{@cyber_coverage}

; Third party coverages
{.third_party}
privacy_liability = ?
privacy_limit = #$:if privacy_liability = true
network_security = ?
network_limit = #$:if network_security = true
media_liability = ?
media_limit = #$:if media_liability = true
regulatory_defense = ?
regulatory_limit = #$:if regulatory_defense = true
pci_fines = ?
pci_limit = #$:if pci_fines = true

{@cyber_coverage}

; Social engineering
social_engineering = ?
social_engineering_limit = #$:if social_engineering = true

; Contingent business interruption
contingent_bi = ?
contingent_bi_limit = #$:if contingent_bi = true


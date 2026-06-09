; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Commercial Claims Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Commercial claims schema for all lines of business including property, liability,
; workers compensation, professional liability, D&O, EPLI, cyber, and crime claims.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as com
@import "../business.schema.odin" as entity

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.claims.commercial-claim"
version = "1.0.0"
title = "Commercial Claims Schema"
description = "Comprehensive claims schema for all commercial lines"

{$derivation}
source[0].authority = "U.S. Department of Labor"
source[0].citation = "Office of Workers' Compensation Programs"
source[0].url = "https://www.dol.gov/agencies/owcp"

source[1].authority = "National Association of Insurance Commissioners (NAIC)"
source[1].citation = "Claims Handling Model Laws and Regulations"
source[1].url = "https://content.naic.org/"

source[2].authority = "State Insurance Departments"
source[2].citation = "Various state claims handling regulations"
source[2].url = "https://content.naic.org/state-insurance-departments"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Complete commercial claims schema for all lines of business"

changelog[0].date = 2025-12-13
changelog[0].change = "Initial commercial claims schema"
changelog[0].rationale = "Comprehensive claims structure for all commercial lines"

; ═══════════════════════════════════════════════════════════════════════════════
; Claimant Information
; ═══════════════════════════════════════════════════════════════════════════════
; References @person or @organization from party.schema.odin

{@claim_claimant}
; Required fields first
type = (class_member, client, customer, driver, employee, first_party, other, passenger, patient, pedestrian, regulatory_agency, third_party, vendor)
number = ##:(1..)                           ; Claimant sequence number

; Optional fields
id = :                                       ; Unique claimant identifier

; ───────────────────────────────────────────────────────────────────────────────
; Claimant Identity (polymorphic - person or organization)
; ───────────────────────────────────────────────────────────────────────────────
person_ref = :                               ; Individual claimant reference (from party.schema.odin)
organization_ref = :                         ; Organization claimant reference (from party.schema.odin)

; ───────────────────────────────────────────────────────────────────────────────
; Legal Representation
; ───────────────────────────────────────────────────────────────────────────────
represented = ?                              ; Claimant has legal representation
{.attorney}
address = @address:if represented = true     ; Attorney address
emails[] = *@email:if represented = true     ; Attorney emails (confidential)
firm = :if represented = true                ; Law firm name
name = :if represented = true                ; Attorney name
phones[] = *@phone:if represented = true     ; Attorney phones (confidential)
{@claim_claimant}

; ═══════════════════════════════════════════════════════════════════════════════
; Claim Reserve
; ═══════════════════════════════════════════════════════════════════════════════

{@claim_reserve}
id = :
transaction_date = date

; Reserve Type
type = (
    defense_cost_containment,
    expense,                                  ; Defense/adjustment expenses
    indemnity,                                ; Claim payment reserves
    loss_adjustment_expense,
    medical,                                  ; WC medical
    other,
    permanent_disability,                     ; WC PD
    salvage,
    subrogation,
    temporary_disability,                     ; WC TD
    vocational_rehabilitation
)

; Amounts
prior_reserve = #$:(0..)
change_amount = #$                                ; Can be negative (reserve decrease)
current_reserve = #$:(0..)

; Reason
change_reason = :
authorized_by = :

; ═══════════════════════════════════════════════════════════════════════════════
; Claim Payment
; ═══════════════════════════════════════════════════════════════════════════════

{@claim_payment}
id = :
transaction_date = date
check_number = :

; Payment Type
type = (
    adjustment_expense,
    death_benefit,
    defense_cost,
    indemnity,
    judgment,
    medical,
    other,
    permanent_disability,
    settlement,
    temporary_disability,
    vocational_rehabilitation
)

; Amounts
gross_amount = #$:(0..)
deductible_applied = #$:(0..)
net_amount = #$:(0..)

; Payee
{.payee}
name = :                                    ; Payee name
type = (attorney, claimant, medical_provider, other, vendor)
address = @address                           ; Payee address
tax_id = *:                                  ; Tax ID
1099_reportable = ?                          ; 1099 reportable
{@claim_payment}

; ═══════════════════════════════════════════════════════════════════════════════
; Claim Recovery
; ═══════════════════════════════════════════════════════════════════════════════

{@claim_recovery}
id = :
transaction_date = date

; Recovery Type
type = (
    deductible_reimbursement,
    other_recovery,
    reinsurance,
    salvage,
    subrogation
)

; Amounts
anticipated = #$:(0..)
received = #$:(0..)

; Source
{.source}
name = :
type = (at_fault_party, insurer, other, salvage_buyer)
claim_number = :
{@claim_recovery}

; ═══════════════════════════════════════════════════════════════════════════════
; Litigation
; ═══════════════════════════════════════════════════════════════════════════════

{@claim_litigation}
id = :

; ───────────────────────────────────────────────────────────────────────────────
; Suit Information
; ───────────────────────────────────────────────────────────────────────────────
suit_filed = ?
suit_date = date:if suit_filed = true
court_name = ::if suit_filed = true
case_number = ::if suit_filed = true
venue_state_province = :(2):if suit_filed = true  ; US state or Canadian province
venue_county = ::if suit_filed = true

; Suit Type
suit_type = (
    administrative_proceeding,
    arbitration,
    class_action,
    derivative_action,
    mediation,
    other,
    personal_injury,
    property_damage,
    regulatory_action,
    wrongful_death
):if suit_filed = true

class_action = ?:if suit_filed = true
class_size = ##:(0..):if class_action = true

; ───────────────────────────────────────────────────────────────────────────────
; Defense Information
; ───────────────────────────────────────────────────────────────────────────────
{.defense_counsel}
assignment_date = date                       ; Date counsel assigned
emails[] = *@email                           ; Defense counsel emails (confidential)
firm = :                                     ; Law firm name
lead_attorney = :                            ; Lead attorney name
phones[] = *@phone                           ; Defense counsel phones (confidential)
{@claim_litigation}

; ───────────────────────────────────────────────────────────────────────────────
; Key Dates
; ───────────────────────────────────────────────────────────────────────────────
answer_due_date = date
discovery_cutoff = date
dispositive_motion_deadline = date
trial_date = date
mediation_date = date
arbitration_date = date

; ───────────────────────────────────────────────────────────────────────────────
; Outcome
; ───────────────────────────────────────────────────────────────────────────────
outcome = (
    appeal_pending,
    arbitration_award,
    default_judgment,
    dismissed,
    judgment_for_claimant,
    judgment_for_insured,
    pending,
    settled
)
outcome_date = date
judgment_amount = #$:(0..)
settlement_amount = #$:(0..)

; ═══════════════════════════════════════════════════════════════════════════════
; Commercial Claim
; ═══════════════════════════════════════════════════════════════════════════════

{@commercial_claim}
id = :
number = :

; ───────────────────────────────────────────────────────────────────────────────
; Line of Business
; ───────────────────────────────────────────────────────────────────────────────
line_of_business = (
    builders_risk,
    commercial_auto,
    commercial_general_liability,
    commercial_property,
    crime_fidelity,
    cyber_liability,
    directors_officers,
    employment_practices,
    inland_marine,
    other,
    pollution_liability,
    professional_liability,
    umbrella_excess,
    workers_compensation
)

; ───────────────────────────────────────────────────────────────────────────────
; Policy Reference
; ───────────────────────────────────────────────────────────────────────────────
policy_number = :
policy_effective_date = date
policy_expiration_date = date
carrier_ref = :

; Coverage triggered
coverage_triggered = :
coverage_part = :

; ───────────────────────────────────────────────────────────────────────────────
; Dates
; ───────────────────────────────────────────────────────────────────────────────
date_of_loss = date
date_reported_to_insured = date
date_reported_to_carrier = date
date_claim_made = date                        ; For claims-made policies
date_acknowledged = date
date_assigned = date
date_closed = date
date_reopened = date

; ───────────────────────────────────────────────────────────────────────────────
; Loss Location - uses shared @address type (US and Canada)
; ───────────────────────────────────────────────────────────────────────────────
{.loss_location}
address = @address
latitude = #:(-90..90)
longitude = #:(-180..180)
{@commercial_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Cause of Loss
; ───────────────────────────────────────────────────────────────────────────────
cause_of_loss = (advertising_injury, auto_accident, bodily_injury, collapse, completed_operations, crime, cyber_incident, data_breach, earthquake, employment_dispute, equipment_breakdown, explosion, fire, flood, hail, lightning, occupational_disease, occupational_injury, other, personal_injury, pollution, products, professional_error, property_damage, ransomware, riot, securities_claim, sprinkler_leakage, theft, vandalism, water_damage, windstorm)
cause_of_loss_code = :
cause_of_loss_description = :

; ───────────────────────────────────────────────────────────────────────────────
; Claim Description
; ───────────────────────────────────────────────────────────────────────────────
description = :
allegations = :

; ───────────────────────────────────────────────────────────────────────────────
; Claim Status
; ───────────────────────────────────────────────────────────────────────────────
status = (reported, assigned, open, pending_investigation, pending_coverage_decision, offered, settled, denied, closed_paid, closed_without_payment, pending_litigation, pending_subrogation, reopened, reserved)  ; Claim workflow status

; ───────────────────────────────────────────────────────────────────────────────
; Claimants
; ───────────────────────────────────────────────────────────────────────────────
claimants[] = @claim_claimant

; ───────────────────────────────────────────────────────────────────────────────
; Financial Summary
; ───────────────────────────────────────────────────────────────────────────────
{.financials}
paid_loss = #$:(0..)
paid_expense = #$:(0..)
paid_total = #$:(0..)

reserve_loss = #$:(0..)
reserve_expense = #$:(0..)
reserve_total = #$:(0..)

incurred_loss = #$:(0..)
incurred_expense = #$:(0..)
incurred_total = #$:(0..)

subrogation_potential = #$:(0..)
subrogation_received = #$:(0..)
salvage_received = #$:(0..)

deductible_applicable = #$:(0..)
deductible_collected = #$:(0..)
{@commercial_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Reserves
; ───────────────────────────────────────────────────────────────────────────────
reserves[] = @claim_reserve

; ───────────────────────────────────────────────────────────────────────────────
; Payments
; ───────────────────────────────────────────────────────────────────────────────
payments[] = @claim_payment

; ───────────────────────────────────────────────────────────────────────────────
; Recoveries
; ───────────────────────────────────────────────────────────────────────────────
recoveries[] = @claim_recovery

; ───────────────────────────────────────────────────────────────────────────────
; Litigation
; ───────────────────────────────────────────────────────────────────────────────
litigation = @claim_litigation

; ───────────────────────────────────────────────────────────────────────────────
; Adjuster Assignment
; ───────────────────────────────────────────────────────────────────────────────
{.adjuster}
assignment_date = date                       ; Date adjuster assigned
company = :                                  ; Adjusting company name
emails[] = *@email                           ; Adjuster emails (confidential)
name = :                                     ; Adjuster name
phones[] = *@phone                           ; Adjuster phones (confidential)
{@commercial_claim}

; Supervisor
{.supervisor}
name = :                                     ; Supervisor name
phones[] = *@phone                           ; Supervisor phones (confidential)
{@commercial_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Decision
; ───────────────────────────────────────────────────────────────────────────────
{.coverage_decision}
decision = (covered, not_covered, partial, pending, reservation_of_rights)
decision_date = date
decision_reason = :
reservation_of_rights_letter = ?
denial_letter = ?
{@commercial_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Notes / Diary
; ───────────────────────────────────────────────────────────────────────────────
{.notes[]}
date = date
author = :
category = (closure, coverage, general, investigation, litigation, negotiation, settlement, subrogation)
content = :
{@commercial_claim}

; Diary/Follow-up
{.diary[]}
date = date
description = :
completed = ?
{@commercial_claim}



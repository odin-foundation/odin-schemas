; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Coverage Schedule Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Coverage schedule grouping coverages for a policy. This is the unit that
; certificates, declaration pages, and API responses project into their
; respective formats as views of the same underlying coverage truth.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./coverage.schema.odin" as cov
@import "../common/party.schema.odin" as party

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.coverages.coverage-schedule"
version = "1.0.0"
title = "Coverage Schedule Schema"
description = "Groups coverages for a policy - what certificates view"

{$derivation}
source[0].authority = "U.S. Department of Labor"
source[0].citation = "Employee Benefits Security Administration"
source[0].url = "https://www.dol.gov/agencies/ebsa"

source[1].authority = "State Insurance Departments"
source[1].citation = "Various state insurance regulations and statutes"
source[1].url = "https://content.naic.org/state-insurance-departments"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Coverage schedule for grouping coverages on a policy"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial coverage schedule schema"
changelog[0].rationale = "Coverage-centric architecture - schedules group coverages"

; ═══════════════════════════════════════════════════════════════════════════════
; Coverage Schedule
; ═══════════════════════════════════════════════════════════════════════════════

{@coverage_schedule}
schedule_id = :                                   ; Unique identifier
schedule_number = ##:(1..)                        ; Sequence on policy

schedule_type = !(
    auto_commercial,
    auto_personal,
    bop,
    commercial_package,
    crime,
    cyber,
    general_liability,
    homeowners,
    inland_marine,
    professional_liability,
    property,
    umbrella,
    workers_comp
)

; Policy reference
policy_ref = :                                    ; Reference to parent policy
policy_number = :                                 ; Policy number

; ───────────────────────────────────────────────────────────────────────────────
; Schedule Dates
; ───────────────────────────────────────────────────────────────────────────────
effective_date = !date
expiration_date = !date

; ───────────────────────────────────────────────────────────────────────────────
; The Actual Coverages
; ───────────────────────────────────────────────────────────────────────────────
coverages[] = @coverage                           ; Array of coverage instances

; ───────────────────────────────────────────────────────────────────────────────
; Schedule-Level Modifiers (Apply to All Coverages)
; ───────────────────────────────────────────────────────────────────────────────
{.schedule_modifiers}
waiver_of_subrogation = ?
waiver_of_subrogation_for[] = :                   ; Who waiver applies to
primary_noncontributory = ?
blanket_additional_insured = ?
notice_of_cancellation_days = ##:(0..90)

{@coverage_schedule}

; ───────────────────────────────────────────────────────────────────────────────
; Additional Insureds at Schedule Level
; ───────────────────────────────────────────────────────────────────────────────

{@coverage_schedule.additional_insureds[]}
party_id = :
party_type = (organization, person)

; For person
{.name}
first = :if party_type = person
last = :if party_type = person

{@coverage_schedule.additional_insureds[]}

; For organization
legal_name = :if party_type = organization

; Interest type
interest_type = !(
    additional_insured,
    blanket_additional_insured,
    certificate_holder,
    designated_person,
    engineer,
    grantor_of_franchise,
    landlord,
    lessor,
    lessor_of_leased_equipment,
    manager_or_operator,
    mortgagee,
    owner,
    state_or_political_subdivision,
    vendor
)

; Form/endorsement creating the AI status
endorsement_form = :                              ; e.g., CG 20 10, CG 20 37
endorsement_edition = :                           ; Edition date

; Coverage relationship
{.coverage}
applies_to_coverages[] = :                        ; Which coverages they're AI on
ongoing_operations = ?
completed_operations = ?
products = ?
premises = ?
your_work = ?

{@coverage_schedule.additional_insureds[]}

; Address - uses shared @address type (US and Canada)
address = @address

{@coverage_schedule.additional_insureds[]}

; Status
status = (active, pending, removed)
effective_date = date
removed_date = date

; ═══════════════════════════════════════════════════════════════════════════════
; Schedule Premium Summary
; ═══════════════════════════════════════════════════════════════════════════════

{@coverage_schedule}

{.premium}
total = #$                                        ; Total premium for schedule
deposit = #$                                      ; Deposit premium
minimum = #$                                      ; Minimum premium
auditable = ?                                     ; Subject to audit
audit_basis = :                                   ; What audit is based on

{@coverage_schedule}

; ═══════════════════════════════════════════════════════════════════════════════
; Schedule Status
; ═══════════════════════════════════════════════════════════════════════════════
status = (active, cancelled, expired, pending, renewed)
cancellation_date = date
cancellation_reason = :
renewal_schedule_ref = :                          ; Reference to renewal schedule


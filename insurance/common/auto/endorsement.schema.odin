; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Auto Insurance Endorsement Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Auto insurance endorsement and policy change definitions including mid-term
; changes, additions, deletions, and modifications. Designed for ODIN's parts
; capability where endorsements store only delta changes.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.auto.endorsement"
version = "1.0.0"
title = "Auto Insurance Endorsement Schema"
description = "Endorsement and policy change definitions"

{$derivation}
source[0].authority = "TurboTags (The Unlicense)"
source[0].citation = "Policy-Tags"
source[0].url = "https://github.com/getitc/turbotags"

methodology = "industry_practice"
proprietary_sources_consulted = ?false
notes = "Standard policy change and endorsement structures"

changelog[0].date = 2025-12-13
changelog[0].change = "Initial endorsement schema"
changelog[0].rationale = "Standard policy change and endorsement structures"

; ═══════════════════════════════════════════════════════════════════════════════
; Endorsement (Policy Change Transaction)
; ═══════════════════════════════════════════════════════════════════════════════

{@endorsement}
id = :
number = !:                             ; Sequential within policy term
sequence = ##

; ───────────────────────────────────────────────────────────────────────────────
; Policy Reference
; ───────────────────────────────────────────────────────────────────────────────
{.policy}
number = !:
term_effective = date
term_expiration = date
version_before = ##               ; Policy version before this change
version_after = ##                ; Policy version after this change

{@endorsement}

; ───────────────────────────────────────────────────────────────────────────────
; Endorsement Type
; ───────────────────────────────────────────────────────────────────────────────
transaction_type = !(
    add_additional_insured,
    add_coverage,
    add_driver,
    add_lienholder,
    add_vehicle,
    cancel_flat,
    cancel_pro_rata,
    cancel_short_rate,
    change_address,
    change_deductible,
    change_driver_info,
    change_garaging,
    change_insured_info,
    change_lienholder,
    change_limits,
    change_name,
    change_payment_plan,
    change_vehicle_coverage,
    change_vehicle_info,
    correction,
    decrease_coverage,
    delete_additional_insured,
    delete_coverage,
    delete_driver,
    delete_lienholder,
    delete_vehicle,
    exclude_driver,
    general_change,
    include_driver,
    increase_coverage,
    non_renewal,
    other,
    reinstatement,
    renewal,
    replace_vehicle,
    rewrite
)

; ───────────────────────────────────────────────────────────────────────────────
; Effective Dates
; ───────────────────────────────────────────────────────────────────────────────
effective_date = !date
effective_time = time
processed_date = !date
requested_date = date

; Pro-rata calculation
days_in_term = ##
days_remaining = ##
pro_rata_factor = #

; ───────────────────────────────────────────────────────────────────────────────
; Premium Impact
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
change_amount = #$
annual_change = #$
new_term_premium = #$:(0..)
new_annual_premium = #$:(0..)
return_premium = #$:(0..)
additional_premium = #$:(0..)
min_earned_premium = #$:(0..)

{@endorsement}
; Fees
{.fees}
endorsement_fee = #$:(0..)
other_fees = #$:(0..)

{@endorsement}
; Tax impact
{.taxes}
change_amount = #$
new_total = #$:(0..)

{@endorsement}

; ───────────────────────────────────────────────────────────────────────────────
; Description of Change
; ───────────────────────────────────────────────────────────────────────────────
description = :
reason = :
internal_notes = :

; ───────────────────────────────────────────────────────────────────────────────
; Forms Added
; ───────────────────────────────────────────────────────────────────────────────
{@endorsement.forms[]}
:
number = !:
name = :
edition = :
form_type = (endorsement, exclusion, notice, other, schedule)

; ───────────────────────────────────────────────────────────────────────────────
; Change Details (What Changed)
; ───────────────────────────────────────────────────────────────────────────────

; Vehicle changes
{.vehicle_changes}
vehicles_added[] = ##
vehicles_deleted[] = ##
vehicles_modified[] = ##

{@endorsement}
; Driver changes
{.driver_changes}
drivers_added[] = ##
drivers_deleted[] = ##
drivers_excluded[] = ##
drivers_included[] = ##
drivers_modified[] = ##

{@endorsement}
; Coverage changes
{.coverage_changes}
coverages_added[] = :
coverages_deleted[] = :
coverages_modified[] = :

{@endorsement}

; ───────────────────────────────────────────────────────────────────────────────
; Before/After Snapshots (for key changes)
; ───────────────────────────────────────────────────────────────────────────────

; Address change
address_before = @address
address_after = @address

{@endorsement}
; Coverage change summary
{.coverage_before}
liability_limits = :
um_limits = :
comp_ded = ##
coll_ded = ##

{@endorsement}
{.coverage_after}
liability_limits = :
um_limits = :
comp_ded = ##
coll_ded = ##

{@endorsement}

; ───────────────────────────────────────────────────────────────────────────────
; Status & Audit
; ───────────────────────────────────────────────────────────────────────────────
status = (cancelled, issued, pending, processed, reversed)
requested_by = :
processed_by = :
approved_by = :
created = !timestamp
created_by = :
modified = timestamp
modified_by = :

; ═══════════════════════════════════════════════════════════════════════════════
; Policy Status Change
; ═══════════════════════════════════════════════════════════════════════════════

{@status_change}
id = :

; Policy reference
{.policy}
number = !:

{@status_change}
; Status transition
status_from = !(
    active,
    application,
    cancelled,
    expired,
    non_renewed,
    pending_payment,
    pending_uw,
    quote,
    reinstated,
    rewritten
)
status_to = !(
    active,
    application,
    cancelled,
    expired,
    non_renewed,
    pending_payment,
    pending_uw,
    quote,
    reinstated,
    rewritten
)

; Effective
effective_date = !date
effective_time = time

; Reason
reason_code = (
    adverse_loss_experience,
    agent_error,
    bank_error,
    claims_frequency,
    claims_severity,
    expired,
    fraud,
    insured_request,
    license_suspended,
    material_misrepresentation,
    non_cooperation,
    non_payment,
    other,
    payment_received,
    rewrite,
    risk_unacceptable,
    state_withdrawal,
    underwriting,
    underwriting_approved,
    underwriting_guidelines
)
reason_description = :

; Cancellation specific
{.cancellation}
type = (flat, pro_rata, short_rate):if status_to = cancelled
return_premium = #$:(0..):if status_to = cancelled
earned_premium = #$:(0..):if status_to = cancelled
days_covered = ##:if status_to = cancelled
notice_date = date:if status_to = cancelled
notice_days = ##:if status_to = cancelled

{@status_change}
; Reinstatement specific
{.reinstatement}
lapse_days = ##:if status_to = reinstated
fee = #$:(0..):if status_to = reinstated
back_premium = #$:(0..):if status_to = reinstated
coverage_gap = ?:if status_to = reinstated

{@status_change}
; Non-renewal specific
{.non_renewal}
notice_date = date:if status_to = non_renewed
notice_days = ##:if status_to = non_renewed
offer_renewal = ?:if status_to = non_renewed

{@status_change}

; Audit
created = !timestamp
created_by = :

; ═══════════════════════════════════════════════════════════════════════════════
; Renewal Transaction
; ═══════════════════════════════════════════════════════════════════════════════

{@renewal}
id = :

; Policy reference
{.policy}
number = !:
expiring_term_effective = !date
expiring_term_expiration = !date
renewal_term_effective = !date
renewal_term_expiration = !date

{@renewal}
; Renewal type
type = (automatic, conditional, declined, manual)

; Premium comparison
{.premium}
expiring_annual = #$:(0..)
renewal_annual = #$:(0..)
change_amount = #$
change_percent = #

{@renewal}
; Changes from expiring
{.changes}
coverage_changes = ?
rating_changes = ?
driver_changes = ?
vehicle_changes = ?
tier_changed = ?
tier_before = :
tier_after = :

{@renewal}
; Status
status = (accepted, bound, expired, offered, pending, rejected)
offer_date = date
response_date = date
response = (accept, modify, no_response, reject)

; Documents
dec_page_generated = ?
renewal_notice_sent = ?
renewal_notice_date = date

; ═══════════════════════════════════════════════════════════════════════════════
; Binder Transaction
; ═══════════════════════════════════════════════════════════════════════════════

{@binder}
id = :
number = !:

; Policy reference
{.policy}
number = :                        ; May not exist yet
quote_id = :

{@binder}

; Binder period
effective_date = !date
effective_time = time
expiration_date = !date
days_in_effect = ##

; Status
status = (active, cancelled, expired, replaced_by_policy, voided)
replaced_by_policy_number = :if status = replaced_by_policy
cancelled_date = date:if status = cancelled
void_reason = :if status = voided

; Premium
{.premium}
estimated = #$:(0..)
deposit = #$:(0..)

{@binder}
; Coverage summary
{.coverage}
liability_limits = :
um_limits = :
comp_ded = ##
coll_ded = ##

{@binder}

; Vehicles
vehicle_count = ##
vehicle_descriptions[] = :

; Audit
created = !timestamp
created_by = :
bound_by = :

; ═══════════════════════════════════════════════════════════════════════════════
; Policy History Entry
; ═══════════════════════════════════════════════════════════════════════════════

{@policy_history_entry}
id = :
sequence = ##
transaction_date = !timestamp
transaction_type = !(
    cancellation,
    claim,
    document,
    endorsement,
    new_business,
    non_renewal,
    note,
    other,
    payment,
    reinstatement,
    renewal,
    rewrite,
    status_change
)

; Reference to related transaction
endorsement_number = ::if transaction_type = endorsement
claim_number = ::if transaction_type = claim
payment_reference = ::if transaction_type = payment
document_id = ::if transaction_type = document

; Summary
description = :
premium_impact = #$                       ; Can be negative
effective_date = date

; Policy version
policy_version = ##

; Audit
created_by = :
created = !timestamp

; ═══════════════════════════════════════════════════════════════════════════════
; Endorsement Form Definitions
; ═══════════════════════════════════════════════════════════════════════════════

{@endorsement_form}
number = !:
name = !:
edition = :
standard_form = ?

; Classification
category = (
    additional_insured,
    condition_modification,
    coverage_extension,
    coverage_restriction,
    exclusion,
    named_driver,
    optional,
    other,
    state_required,
    vehicle_specific
)

; Applicability
states[] = :(2)                                ; Which states use this form
applies_to = (driver, policy, vehicle)

; Description
description = :

; Premium
premium_impact = (additional, credit, no_change, varies)
base_premium = #$:(0..)
rate_factor = #

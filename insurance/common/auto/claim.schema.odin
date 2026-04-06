; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Auto Insurance Claim Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Auto insurance claim definitions including loss information, parties involved,
; damages, payments, and claim lifecycle for personal auto insurance.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.auto.claim"
version = "1.0.0"
title = "Auto Insurance Claim Schema"
description = "Claim definitions for personal auto insurance"

{$derivation}
methodology = "industry_practice"
proprietary_sources_consulted = ?false
notes = "Standard auto insurance claim data structures"

changelog[0].date = 2025-12-13
changelog[0].change = "Initial claim schema"
changelog[0].rationale = "Standard auto insurance claim data structures"

; ═══════════════════════════════════════════════════════════════════════════════
; Claim (Complete Definition)
; ═══════════════════════════════════════════════════════════════════════════════

{@claim}
number = !:
id = :

; ───────────────────────────────────────────────────────────────────────────────
; Policy Reference
; ───────────────────────────────────────────────────────────────────────────────
{.policy}
number = !:
effective = date
expiration = date
insured_name = :

{@claim}

; ───────────────────────────────────────────────────────────────────────────────
; Claim Status & Type
; ───────────────────────────────────────────────────────────────────────────────
status = !(
    fnol,                                      ; First Notice of Loss
    open,                                      ; Open/Active
    pending,                                   ; Pending investigation/info
    under_review,                              ; Under review
    reserved,                                  ; Reserved
    paid,                                      ; Paid/Settled
    denied,                                    ; Denied
    closed,                                    ; Closed
    closed_without_payment,                    ; Closed without payment
    litigation,                                ; In litigation
    subrogation,                               ; In subrogation
    reopened,                                  ; Reopened
    voided                                     ; Voided
)
type = !(
    collision,
    comprehensive,
    glass,
    liability_bi,
    liability_pd,
    med_pay,
    other,
    pip,
    rental,
    towing,
    uim_bi,
    uim_pd,
    um_bi,
    um_pd,
    underinsured,
    uninsured
)

; ───────────────────────────────────────────────────────────────────────────────
; Loss Information
; ───────────────────────────────────────────────────────────────────────────────
{.loss}
= @loss_occurrence                                ; Use shared loss occurrence type

time = time                                       ; Loss time (extends date from @loss_occurrence)

; Location - extends location from @loss_occurrence with additional details
{.location}
latitude = #:(-90..90)
longitude = #:(-180..80)
description = :

{@loss}
; Cause - extends cause from @loss_occurrence with auto-specific causes
cause = (
    ; Collision causes
    collision_angle,
    collision_animal,
    collision_backing,
    collision_bicycle,
    collision_head_on,
    collision_hit_run,
    collision_object,
    collision_other,
    collision_parked,
    collision_pedestrian,
    collision_rear_end,
    collision_rollover,
    collision_side_impact,
    collision_sideswipe,

    ; Comprehensive causes
    comp_animal,
    comp_earthquake,
    comp_falling_object,
    comp_fire,
    comp_flood,
    comp_glass,
    comp_hail,
    comp_lightning,
    comp_other,
    comp_riot,
    comp_theft,
    comp_theft_recovery,
    comp_vandalism,
    comp_wind,

    ; Other causes
    mechanical,
    other,
    rental,
    towing
)

; Fault
fault_determination = (insured_at_fault, insured_not_at_fault, shared_fault, undetermined)
insured_fault_percent = ##:(0..100)
fault_disputed = ?

; Weather/Conditions
weather = (clear, fog, hail, ice, other, rain, snow, wind)
road_condition = (dry, icy, other, snow_covered, wet)
lighting = (dark_lighted, dark_unlighted, dawn, daylight, dusk)

; Police
police_notified = ?
police_report_number = :
police_department = :
citation_issued = ?
citation_number = :
citation_to_insured = ?

{@claim}

; ───────────────────────────────────────────────────────────────────────────────
; Vehicles Involved
; ───────────────────────────────────────────────────────────────────────────────
{@claim.vehicles[]}
id = :
sequence = ##
insured_vehicle = ?

; Identification
vin = *:/^[A-HJ-NPR-Z0-9]{17}$/
year = ##:(1900..2100)
make = :
model = :
color = :
license_plate = :
license_state_province = :(2)                 ; US state or Canadian province

; Owner
{.owner}
name = :
phone = *@phone
address = @address
insurance_carrier = :
policy_number = :
claim_number = :

{@claim.vehicles[]}
; Driver at time of loss
{.driver}
name = :
relation_to_owner = (child, employee, other, owner, permissive_user, spouse, unlisted)
license_number = *:
license_state_province = :(2)                 ; US state or Canadian province
phone = *@phone
injured = ?

{@claim.vehicles[]}
; Damage
{.damage}
description = :
severity = (none, minor, moderate, severe, total_loss)
location = :
driveable = ?
towed = ?
tow_destination = :
repair_status = (not_started, in_progress, completed, total_loss)
estimate_amount = #$:(0..)
actual_repair_cost = #$:(0..)
acv = #$:(0..)
total_loss = ?
salvage_value = #$:(0..):if total_loss = true

{@claim.vehicles[]}

; ───────────────────────────────────────────────────────────────────────────────
; Parties/Claimants
; ───────────────────────────────────────────────────────────────────────────────
{@claim.parties[]}
= @person                                     ; Inherit person fields (name, dob, identifiers, contact)
type = !(
    attorney,
    claimant,
    driver,
    medical_provider,
    named_insured,
    other,
    passenger,
    pedestrian,
    property_owner,
    repair_shop,
    third_party,
    witness
)
id = :
sequence = ##
business_name = :                             ; For non-person parties (organizations)

; Injury information
injured = ?
{.injury}
description = :if injured = true
severity = (minor, moderate, severe, critical, fatal):if injured = true
body_parts = :if injured = true
hospitalized = ?:if injured = true
hospital_name = :if injured = true
treatment_ongoing = ?:if injured = true
permanent = ?:if injured = true
fatality = ?:if injured = true

{@claim.parties[]}
; Attorney
attorney_retained = ?
{.attorney}
name = :if attorney_retained = true
firm = :if attorney_retained = true
phone = *@phone:if attorney_retained = true
address = @address:if attorney_retained = true

{@claim.parties[]}

; ───────────────────────────────────────────────────────────────────────────────
; Adjusters
; ───────────────────────────────────────────────────────────────────────────────
{@claim.adjusters[]}
= @person                                     ; Inherit person fields (name, contact)
id = :
sequence = ##
type = (catastrophe, independent, staff, supervisor)
company = :
assigned_date = date
unassigned_date = date
active = ?

; ───────────────────────────────────────────────────────────────────────────────
; Reserves
; ───────────────────────────────────────────────────────────────────────────────
{.reserves}
property_damage = #$:(0..)
bodily_injury = #$:(0..)
medical_payments = #$:(0..)
collision = #$:(0..)
comprehensive = #$:(0..)
um_uim = #$:(0..)
pip = #$:(0..)
rental = #$:(0..)
towing = #$:(0..)
subrogation = #$:(0..)
expense = #$:(0..)
total = #$:(0..)
updated = timestamp

{@claim}

; ───────────────────────────────────────────────────────────────────────────────
; Payments
; ───────────────────────────────────────────────────────────────────────────────
{@claim.payments[]}
type = !(
    death_benefit,
    deductible_recovery,
    expense,
    medical,
    other,
    property_damage,
    rental,
    salvage_recovery,
    settlement,
    subrogation_recovery,
    towing,
    vehicle_repair,
    vehicle_total_loss,
    wage_loss
)
amount = !#$:(0..)
date = !date
id = :
sequence = ##
coverage_code = :
check_number = :
check_date = date
method = (check, draft, eft, wire)
cleared_date = date

; Payee - uses shared @address type (US and Canada)
{.payee}
name = !:
type = (attorney, claimant, insured, lienholder, medical_provider, other, vendor)
address = @address

{@claim.payments[]}

; Additional payees (joint check)
additional_payees[] = :

; Status
status = (cashed, issued, mailed, pending, returned, stop_payment, voided)
voided_date = date:if status = voided
void_reason = :if status = voided

; Reference
invoice_number = :
claim_reference = :
memo = :

; ───────────────────────────────────────────────────────────────────────────────
; Subrogation
; ───────────────────────────────────────────────────────────────────────────────
{.subrogation}
potential = ?
status = (abandoned, closed, in_progress, none, open, pending, recovered)
target_party = :
target_carrier = :
target_policy = :
target_claim = :
amount_sought = #$:(0..)
amount_recovered = #$:(0..)
deductible_recovered = #$:(0..)
recovery_date = date

; Arbitration
{.arbitration}
filed = ?
date = date
decision = (lost, pending, settled, won)
forum = :

{@subrogation}

{@claim}

; ───────────────────────────────────────────────────────────────────────────────
; Salvage
; ───────────────────────────────────────────────────────────────────────────────
{.salvage}
salvage = ?
status = (none, pending, retained, sold)
buyer = :
sale_date = date
sale_amount = #$:(0..)
title_status = (clean, junk, rebuilt, salvage)
retained_by_owner = ?
owner_retention_amount = #$:(0..)

{@claim}

; ───────────────────────────────────────────────────────────────────────────────
; Litigation
; ───────────────────────────────────────────────────────────────────────────────
{.litigation}
suit_filed = ?
suit_date = date
plaintiff = :
defendant = :
court = :
case_number = :
jurisdiction = :
status = (active, dismissed, pending, settled, verdict)
trial_date = date
verdict_date = date
verdict_amount = #$:(0..)
defense_counsel = :

{@claim}

; ───────────────────────────────────────────────────────────────────────────────
; Claim Summary
; ───────────────────────────────────────────────────────────────────────────────
{.summary}
total_paid = #$:(0..)
total_reserves = #$:(0..)
total_incurred = #$:(0..)
recoveries = #$:(0..)
net_incurred = #$:(0..)
deductible_applied = #$:(0..)
expenses = #$:(0..)

{@claim}

; ───────────────────────────────────────────────────────────────────────────────
; Activity/Notes
; ───────────────────────────────────────────────────────────────────────────────
{@claim.activities[]}
date = !timestamp
id = :
sequence = ##
type = (
    contact_adjuster,
    contact_attorney,
    contact_claimant,
    contact_insured,
    contact_vendor,
    contact_witness,
    document_received,
    document_sent,
    estimate,
    fnol,
    inspection,
    litigation_update,
    note,
    other,
    payment,
    reserve_change,
    settlement_accepted,
    settlement_offer,
    status_change,
    subrogation_update
)
description = :
created_by = :
internal_only = ?

; ───────────────────────────────────────────────────────────────────────────────
; Documents
; ───────────────────────────────────────────────────────────────────────────────
{@claim.documents[]}
id = :
type = (
    appraisal,
    arbitration_filing,
    correspondence,
    estimate,
    invoice,
    litigation_documents,
    medical_bills,
    medical_records,
    other,
    photos,
    police_report,
    recorded_statement,
    release,
    settlement_agreement,
    subrogation_demand,
    supplement,
    wage_loss_docs
)
description = :
filename = :
uploaded_date = timestamp
uploaded_by = :

; ───────────────────────────────────────────────────────────────────────────────
; Timestamps
; ───────────────────────────────────────────────────────────────────────────────
created = !timestamp
created_by = :
modified = timestamp
modified_by = :
closed_date = timestamp
closed_by = :
close_reason = (
    denied,
    duplicate,
    no_coverage,
    other,
    paid,
    settled,
    statute_expired,
    withdrawn
):if status = closed
close_reason = :if status = closed_without_payment

; ═══════════════════════════════════════════════════════════════════════════════
; Claim Summary (Compact for Policy History)
; ═══════════════════════════════════════════════════════════════════════════════

{@claim_summary}
id = :
number = :
loss_date = date
type = :
status = :
fault = (at_fault, not_at_fault, shared, undetermined)
total_paid = #$:(0..)
total_incurred = #$:(0..)
description = :

; ═══════════════════════════════════════════════════════════════════════════════
; FNOL (First Notice of Loss)
; ═══════════════════════════════════════════════════════════════════════════════

{@fnol}
policy_number = !:
reported_date = !timestamp
id = :
{.reported_by}
name = !:
phone = *@phone
relation = (agent, claimant, driver, insured, other, passenger, witness)

{@fnol}
; Loss summary
loss_date = !date
loss_time = time
loss_type = (collision, comprehensive, liability, med_pay, other, pip, um_uim)
loss_description = !:

; Location - uses shared @address type (US and Canada)
{.location}
address = @address

{@fnol}

; Vehicles involved
vehicle_count = ##
{.insured_vehicle}
vin = *:(17)
year = ##:(1900..2100)
make = :
model = :
driver = :
damage_description = :
driveable = ?

{@fnol}

; Injuries
any_injuries = ?
injury_description = :if any_injuries = true

; Police
police_notified = ?
police_report_number = :

; Other parties
other_parties_involved = ?
other_party_count = ##

; Action taken
towing_needed = ?
rental_needed = ?
glass_only = ?

; Status
status = (cancelled, claim_created, duplicate, pending_claim_create, received)
claim_number = :if status = claim_created

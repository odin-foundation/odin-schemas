; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Auto Insurance Policy Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Complete personal auto insurance policy lifecycle schema tying together vehicles,
; drivers, coverages, rating, claims, and endorsements from quote/application
; through renewal and cancellation.
; ═══════════════════════════════════════════════════════════════════════════════

; ═══════════════════════════════════════════════════════════════════════════════
; IMPORTS
; ═══════════════════════════════════════════════════════════════════════════════
@import "../../common/types.schema.odin" as types
@import "../../common/party.schema.odin" as party
@import "../../common/agency.schema.odin" as agency
@import "../../common/carrier.schema.odin" as carrier
@import "../../common/documents.schema.odin" as docs
@import "../types.schema.odin" as pc
@import "../../common/auto/coverage.schema.odin" as cov
@import "../../common/auto/rating.schema.odin" as rating
@import "../../common/auto/claim.schema.odin" as claim
@import "../../common/auto/endorsement.schema.odin" as endorse
@import "./vehicle.schema.odin" as veh
@import "./driver.schema.odin" as drv

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.auto.policy"
version = "1.0.0"
title = "Auto Insurance Policy Schema"
description = "Complete personal auto insurance policy lifecycle schema"

{$derivation}
source[0].authority = "TurboTags (The Unlicense)"
source[0].citation = "Policy-Tags, Car-Tags, Driver-Tags"
source[0].url = "https://github.com/getitc/turbotags"

methodology = "industry_practice"
proprietary_sources_consulted = ?false
notes = "Standard auto insurance data elements as required by state regulations"

changelog[0].date = 2025-12-13
changelog[0].change = "Initial comprehensive policy schema"
changelog[0].rationale = "Complete auto insurance lifecycle representation"

; ═══════════════════════════════════════════════════════════════════════════════
; POLICY TYPE DEFINITION
; ═══════════════════════════════════════════════════════════════════════════════
; Defines the @policy type which can be inherited by state-specific schemas.
; The type contains all fields for a complete personal auto policy.

{@policy}
; ───────────────────────────────────────────────────────────────────────────────
; Identification (Required)
; ───────────────────────────────────────────────────────────────────────────────
number = !:                                    ; Display policy number
state_province = !:(2)                         ; Primary US state or Canadian province
status = !@types.policy_status                 ; Policy lifecycle status (canonical)

; ───────────────────────────────────────────────────────────────────────────────
; Term (Required)
; ───────────────────────────────────────────────────────────────────────────────
{.term}
effective = !date                              ; Coverage start date
expiration = !date                             ; Coverage end date

:invariant term.expiration > term.effective

{@policy}

; ───────────────────────────────────────────────────────────────────────────────
; Identification (Optional)
; ───────────────────────────────────────────────────────────────────────────────
application_number = :                         ; Application reference
id = :                                         ; Internal system identifier
quote_number = :                               ; Original quote reference

; ───────────────────────────────────────────────────────────────────────────────
; Classification
; ───────────────────────────────────────────────────────────────────────────────
line_of_business = "personal_auto"             ; Line of business constant
product_type = (assigned_risk, non_standard, preferred, standard)
type = (
    antique_classic,
    comprehensive_only,
    fr44,
    full_coverage,
    liability_only,
    named_non_owner,
    operator_only,
    sr22
)

; ───────────────────────────────────────────────────────────────────────────────
; Term (Optional)
; ───────────────────────────────────────────────────────────────────────────────
{.term}
effective_time = time                          ; Start time if not midnight
expiration_time = time                         ; End time if not midnight
months = ##                                    ; Term length in months
type = (annual, monthly, other, quarterly, semi_annual)

{@policy}
original_effective = date                      ; Original effective date for continuous coverage

; ───────────────────────────────────────────────────────────────────────────────
; Status Details
; ───────────────────────────────────────────────────────────────────────────────
status_date = date                             ; Date status changed
status_reason = :                              ; Reason for status change

; ───────────────────────────────────────────────────────────────────────────────
; Jurisdiction
; ───────────────────────────────────────────────────────────────────────────────
secondary_state_province = :(2)                ; For multi-state/province coverage
territory = :                                  ; Rating territory code

; ───────────────────────────────────────────────────────────────────────────────
; Version Control
; ───────────────────────────────────────────────────────────────────────────────
endorsement_count = ##                         ; Number of endorsements
prior_version = ##                             ; Previous version number
version = ##:(1..)                             ; Current version number
version_date = timestamp                       ; Version timestamp
version_reason = :                             ; Reason for version change

; ───────────────────────────────────────────────────────────────────────────────
; Timestamps
; ───────────────────────────────────────────────────────────────────────────────
bound_date = date                              ; Date policy bound
cancelled_date = date                          ; Date policy cancelled
created = !timestamp                           ; Record creation timestamp
created_by = :                                 ; User who created record
expired_date = date                            ; Date policy expired
issued_date = date                             ; Date policy issued
modified = timestamp                           ; Last modification timestamp
modified_by = :                                ; User who last modified
quote_date = date                              ; Date quote generated

; ═══════════════════════════════════════════════════════════════════════════════
; NAMED INSURED
; ═══════════════════════════════════════════════════════════════════════════════
; Uses @named_insured type from party.schema.odin

{@policy.named_insured}
= @party.named_insured

{@policy.secondary_insured}
= @party.named_insured

; ═══════════════════════════════════════════════════════════════════════════════
; CARRIER & PROGRAM
; ═══════════════════════════════════════════════════════════════════════════════
; Uses types from carrier.schema.odin

{@policy.carrier}
= @carrier.carrier

{@policy.program}
= @carrier.program

{@policy.secondary_carrier}
= @carrier.carrier

; ═══════════════════════════════════════════════════════════════════════════════
; AGENCY
; ═══════════════════════════════════════════════════════════════════════════════
; Uses types from agency.schema.odin

{@policy.agency}
= @agency.agency

{@policy.producer}
= @agency.producer

{@policy.service_attribution}
= @agency.service_attribution

; ═══════════════════════════════════════════════════════════════════════════════
; PRIOR INSURANCE
; ═══════════════════════════════════════════════════════════════════════════════
; Uses @prior_carrier type from carrier.schema.odin

{@policy.prior_insurance}
= @carrier.prior_carrier

; ═══════════════════════════════════════════════════════════════════════════════
; VEHICLES
; ═══════════════════════════════════════════════════════════════════════════════
; Uses @vehicle type from vehicle.schema.odin

{@policy.vehicles[]}
= @veh.personal_vehicle

; ═══════════════════════════════════════════════════════════════════════════════
; DRIVERS
; ═══════════════════════════════════════════════════════════════════════════════
; Uses @driver type from driver.schema.odin (includes nested violations)

{@policy.drivers[]}
= @drv.personal_driver

; ═══════════════════════════════════════════════════════════════════════════════
; EXCLUDED DRIVERS
; ═══════════════════════════════════════════════════════════════════════════════
; Uses @excluded_driver type from P&C types.schema.odin

{@policy.excluded_drivers[]}
= @pc.excluded_driver

; ═══════════════════════════════════════════════════════════════════════════════
; COVERAGES
; ═══════════════════════════════════════════════════════════════════════════════
; Uses coverage types from coverage.schema.odin

{@policy.coverage.liability}
= @cov.liability_coverage

{@policy.coverage.um}
= @cov.um_coverage

{@policy.coverage.pip}
= @cov.pip_coverage

{@policy.coverage.med_pay}
= @cov.med_pay_coverage

{@policy.coverage.vehicles[]}
= @cov.physical_damage_coverage

; ═══════════════════════════════════════════════════════════════════════════════
; RATING & PREMIUM
; ═══════════════════════════════════════════════════════════════════════════════
; Uses @rating and @premium types from rating.schema.odin

{@policy.rating}
= @rating.rating

{@policy.premium}
= @rating.premium

; ═══════════════════════════════════════════════════════════════════════════════
; PAYMENT PLAN
; ═══════════════════════════════════════════════════════════════════════════════
; Uses @payment_plan type from rating.schema.odin (includes nested payments)

{@policy.payment_plan}
= @rating.payment_plan

; ═══════════════════════════════════════════════════════════════════════════════
; BINDER
; ═══════════════════════════════════════════════════════════════════════════════
; Uses @binder type from endorsement.schema.odin

{@policy.binder}
= @endorse.binder

; ═══════════════════════════════════════════════════════════════════════════════
; DOCUMENTS
; ═══════════════════════════════════════════════════════════════════════════════
; Uses @document type from documents.schema.odin

{@policy.documents[]}
= @docs.document

; ═══════════════════════════════════════════════════════════════════════════════
; ENDORSEMENTS (Policy Changes)
; ═══════════════════════════════════════════════════════════════════════════════
; Uses @endorsement type from endorsement.schema.odin (includes nested forms)

{@policy.endorsements[]}
= @endorse.endorsement

; ═══════════════════════════════════════════════════════════════════════════════
; CLAIMS
; ═══════════════════════════════════════════════════════════════════════════════
; Uses @claim type from claim.schema.odin (includes nested parties, payments, etc.)

{@policy.claims[]}
= @claim.claim

; ═══════════════════════════════════════════════════════════════════════════════
; POLICY HISTORY
; ═══════════════════════════════════════════════════════════════════════════════
; Uses @policy_history_entry type from endorsement.schema.odin

{@policy.history[]}
= @endorse.policy_history_entry

; ═══════════════════════════════════════════════════════════════════════════════
; NOTES
; ═══════════════════════════════════════════════════════════════════════════════
; Uses @policy_note type from types.schema.odin

{@policy.notes[]}
= @types.policy_note

; ═══════════════════════════════════════════════════════════════════════════════
; UNDERWRITING
; ═══════════════════════════════════════════════════════════════════════════════
; Uses @underwriting_decision type from types.schema.odin

{@policy.underwriting}
= @types.underwriting_decision

; ═══════════════════════════════════════════════════════════════════════════════
; MARKETING & SOURCE
; ═══════════════════════════════════════════════════════════════════════════════
; Uses @marketing_source type from types.schema.odin

{@policy.marketing}
= @types.marketing_source

; ═══════════════════════════════════════════════════════════════════════════════
; ADDITIONAL INTERESTS
; ═══════════════════════════════════════════════════════════════════════════════
; Uses @additional_insured type from party.schema.odin

{@policy.additional_interests[]}
= @party.additional_insured

; ═══════════════════════════════════════════════════════════════════════════════
; EXTERNAL REFERENCES
; ═══════════════════════════════════════════════════════════════════════════════
; Uses @external_reference type from types.schema.odin

{@policy.external_references[]}
= @types.external_reference

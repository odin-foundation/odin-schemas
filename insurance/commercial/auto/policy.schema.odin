; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Commercial Auto Insurance Policy Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Complete commercial auto insurance policy covering motor carrier registration,
; fleet composition, commercial vehicles and CDL drivers, truckers liability
; coverages, FMCSA filings, claims, and endorsements.
; ═══════════════════════════════════════════════════════════════════════════════

; ═══════════════════════════════════════════════════════════════════════════════
; IMPORTS
; ═══════════════════════════════════════════════════════════════════════════════
@import "../../common/types.schema.odin" as types
@import "../../common/party.schema.odin" as party
@import "../../common/agency.schema.odin" as agency
@import "../../common/carrier.schema.odin" as carrier
@import "../../common/documents.schema.odin" as docs
@import "../../personal/types.schema.odin" as pc
@import "../../common/auto/claim.schema.odin" as claim
@import "../../common/auto/endorsement.schema.odin" as endorsement
@import "../../common/auto/rating.schema.odin" as rating
@import "./fleet.schema.odin" as fleet
@import "./vehicle.schema.odin" as veh
@import "./driver.schema.odin" as drv
@import "./coverage.schema.odin" as cov

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.auto.policy"
version = "1.0.0"
title = "Commercial Auto Insurance Policy Schema"
description = "Complete commercial auto insurance policy lifecycle schema"

{$derivation}
source[0].authority = "Federal Motor Carrier Safety Administration"
source[0].citation = "49 CFR Part 387 - Minimum Levels of Financial Responsibility"
source[0].url = "https://www.ecfr.gov/current/title-49/subtitle-B/chapter-III/subchapter-B/part-387"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Commercial auto insurance per DOT/FMCSA requirements and industry practice"

changelog[0].date = 2025-12-13
changelog[0].change = "Initial commercial auto policy schema"
changelog[0].rationale = "Commercial auto insurance requirements for motor carriers"

; ═══════════════════════════════════════════════════════════════════════════════
; POLICY HEADER
; ═══════════════════════════════════════════════════════════════════════════════
; Core policy identification and term information

{policy}
; ───────────────────────────────────────────────────────────────────────────────
; Identification
; ───────────────────────────────────────────────────────────────────────────────
number = :(1..50)                             ; Display number
id = :                                   ; Internal system ID
quote_number = :                         ; Original quote reference
application_number = :

; Line of business
line_of_business = "commercial_auto"
product_type = (business_auto, fleet, garage, motor_carrier, owner_operator, truckers)
type = (
    business_auto,                             ; Commercial business auto
    cargo_only,                                ; Cargo coverage only
    excess,                                    ; Excess/umbrella
    fleet,                                     ; Large fleet policy
    hired_non_owned,                           ; Hired & non-owned only
    motor_carrier,                             ; Full motor carrier package
    owner_operator,                            ; Individual O/O policy
    truckers_liability                         ; Primary truckers policy
)

; ───────────────────────────────────────────────────────────────────────────────
; Term
; ───────────────────────────────────────────────────────────────────────────────
{.term}
effective = date                              ; Coverage start date
effective_time = time                          ; Start time if not midnight
expiration = date                             ; Coverage end date
expiration_time = time                         ; End time if not midnight
months = ##:(1..24)                            ; Term length in months
type = (annual, continuous, monthly, quarterly, semi_annual)  ; Term type
:invariant term.expiration > term.effective

{policy}

; Original effective (for continuous coverage)
original_effective = date                      ; Original policy effective date

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (
    active,
    application,
    bound,
    cancelled,
    expired,
    non_renewed,
    pending_filings,                           ; Waiting for FMCSA filings
    pending_payment,
    pending_underwriting,
    quote,
    reinstated,
    rewritten
)
status_date = date
status_reason = :

; ───────────────────────────────────────────────────────────────────────────────
; State & Jurisdiction
; ───────────────────────────────────────────────────────────────────────────────
state = :(2)                                  ; Primary state (domicile)
garaging_states[] = :(2)                       ; States where vehicles garaged
operating_states[] = :(2)                      ; States of operation

; ───────────────────────────────────────────────────────────────────────────────
; FMCSA Jurisdiction
; ───────────────────────────────────────────────────────────────────────────────
{.fmcsa}
filings_complete = ?                           ; All required filings completed
filings_required = ?                           ; Filings required for this policy
operation_type = (both, interstate, intrastate)  ; Operating jurisdiction type
subject_to_fmcsa = ?                           ; Subject to FMCSA requirements

{policy}

; ───────────────────────────────────────────────────────────────────────────────
; Version Control
; ───────────────────────────────────────────────────────────────────────────────
version = ##:(1..)
version_date = timestamp
version_reason = :
prior_version = ##:(0..)
endorsement_count = ##:(0..)

; ───────────────────────────────────────────────────────────────────────────────
; Timestamps
; ───────────────────────────────────────────────────────────────────────────────
created = timestamp                           ; Record creation timestamp
created_by = :                                 ; User who created record
modified = timestamp                           ; Last modification timestamp
modified_by = :                                ; User who last modified
quote_date = date                              ; Date quote generated
bound_date = date                              ; Date policy bound
issued_date = date                             ; Date policy issued
cancelled_date = date                          ; Date policy cancelled
expired_date = date                            ; Date policy expired

; ═══════════════════════════════════════════════════════════════════════════════
; NAMED INSURED (Motor Carrier/Business Entity)
; ═══════════════════════════════════════════════════════════════════════════════

{policy.named_insured}
= @party.named_insured

; Commercial-specific insured fields
date_established = date
dba_name = :
entity_type = (corporation, llc, other, partnership, sole_proprietor, trust)
years_in_business = ##:(0..200)

{policy}

; ═══════════════════════════════════════════════════════════════════════════════
; MOTOR CARRIER REGISTRATION
; ═══════════════════════════════════════════════════════════════════════════════
; DOT/FMCSA registration and operating authority

{policy.motor_carrier}
= @fleet.motor_carrier

; ═══════════════════════════════════════════════════════════════════════════════
; FMCSA INSURANCE FILINGS
; ═══════════════════════════════════════════════════════════════════════════════
; Required insurance filings (BMC-91, MCS-90, BOC-3)

{policy.fmcsa_filings[]}
= @fleet.fmcsa_filing

; ═══════════════════════════════════════════════════════════════════════════════
; FLEET INFORMATION
; ═══════════════════════════════════════════════════════════════════════════════
; Fleet composition and vehicle counts

{policy.fleet}
= @fleet.fleet_info

; ═══════════════════════════════════════════════════════════════════════════════
; TERMINALS / OPERATING LOCATIONS
; ═══════════════════════════════════════════════════════════════════════════════

{policy.terminals[]}
= @fleet.terminal

; ═══════════════════════════════════════════════════════════════════════════════
; OPERATING ZONES / RADIUS
; ═══════════════════════════════════════════════════════════════════════════════

{policy.operating_zones[]}
= @fleet.operating_zone

; ═══════════════════════════════════════════════════════════════════════════════
; COMMODITIES HAULED
; ═══════════════════════════════════════════════════════════════════════════════

{policy.commodities[]}
= @fleet.commodity

; ═══════════════════════════════════════════════════════════════════════════════
; CARRIER & PROGRAM
; ═══════════════════════════════════════════════════════════════════════════════

{policy.carrier}
= @carrier.carrier

{policy.program}
= @carrier.program

; ═══════════════════════════════════════════════════════════════════════════════
; AGENCY
; ═══════════════════════════════════════════════════════════════════════════════

{policy.agency}
= @agency.agency

{policy.producer}
= @agency.producer

{policy.service_attribution}
= @agency.service_attribution

; ═══════════════════════════════════════════════════════════════════════════════
; PRIOR INSURANCE
; ═══════════════════════════════════════════════════════════════════════════════

{policy.prior_insurance}
= @carrier.prior_carrier

; ═══════════════════════════════════════════════════════════════════════════════
; POWER UNITS (Tractors, Trucks)
; ═══════════════════════════════════════════════════════════════════════════════

{policy.power_units[]}
= @veh.power_unit

; ═══════════════════════════════════════════════════════════════════════════════
; TRAILERS
; ═══════════════════════════════════════════════════════════════════════════════

{policy.trailers[]}
= @veh.trailer

; ═══════════════════════════════════════════════════════════════════════════════
; OTHER COMMERCIAL VEHICLES
; ═══════════════════════════════════════════════════════════════════════════════

{policy.vehicles[]}
= @veh.commercial_vehicle

; ═══════════════════════════════════════════════════════════════════════════════
; DRIVERS
; ═══════════════════════════════════════════════════════════════════════════════

{policy.drivers[]}
= @drv.commercial_driver

; ═══════════════════════════════════════════════════════════════════════════════
; OWNER-OPERATORS
; ═══════════════════════════════════════════════════════════════════════════════

{policy.owner_operators[]}
= @drv.owner_operator

; ═══════════════════════════════════════════════════════════════════════════════
; EXCLUDED DRIVERS
; ═══════════════════════════════════════════════════════════════════════════════

{policy.excluded_drivers[]}
= @pc.excluded_driver

; ═══════════════════════════════════════════════════════════════════════════════
; COVERAGES
; ═══════════════════════════════════════════════════════════════════════════════

; Primary Liability
{policy.coverage.liability}
= @cov.commercial_liability

; Motor Truck Cargo
{policy.coverage.cargo}
= @cov.cargo_coverage

; Hired Auto
{policy.coverage.hired_auto}
= @cov.hired_auto_coverage

; Non-Owned Auto
{policy.coverage.non_owned_auto}
= @cov.non_owned_auto_coverage

; Trailer Interchange
{policy.coverage.trailer_interchange}
= @cov.trailer_interchange_coverage

; Bobtail / Non-Trucking
{policy.coverage.bobtail}
= @cov.bobtail_coverage

; Physical Damage (per vehicle)
{policy.coverage.physical_damage[]}
= @cov.commercial_physical_damage

; Downtime / Loss of Use
{policy.coverage.downtime}
= @cov.downtime_coverage

; Pollution Liability
{policy.coverage.pollution}
= @cov.pollution_coverage

; Occupational Accident
{policy.coverage.occupational_accident}
= @cov.occupational_accident

; General Liability Extension
{policy.coverage.gl_extension}
= @cov.gl_extension

; UM/UIM
{policy.coverage.um}
= @cov.commercial_um_coverage

; Coverage Summary
{policy.coverage.summary}
= @cov.commercial_coverage_summary

; ═══════════════════════════════════════════════════════════════════════════════
; TRAILER INTERCHANGE AGREEMENTS
; ═══════════════════════════════════════════════════════════════════════════════

{policy.interchange_agreements[]}
= @fleet.trailer_interchange

; ═══════════════════════════════════════════════════════════════════════════════
; HIRED AUTO INFORMATION
; ═══════════════════════════════════════════════════════════════════════════════

{policy.hired_auto_info}
= @fleet.hired_auto_info

; ═══════════════════════════════════════════════════════════════════════════════
; SAFETY PROGRAM
; ═══════════════════════════════════════════════════════════════════════════════

{policy.safety_program}
= @fleet.safety_program

; ═══════════════════════════════════════════════════════════════════════════════
; CARRIER REVENUE (for rating)
; ═══════════════════════════════════════════════════════════════════════════════

{policy.revenue}
= @fleet.carrier_revenue

; ═══════════════════════════════════════════════════════════════════════════════
; RATING & PREMIUM
; ═══════════════════════════════════════════════════════════════════════════════

{policy.rating}
= @rating.rating

{policy.premium}
= @rating.premium

; ═══════════════════════════════════════════════════════════════════════════════
; PAYMENT PLAN
; ═══════════════════════════════════════════════════════════════════════════════

{policy.payment_plan}
= @rating.payment_plan

; ═══════════════════════════════════════════════════════════════════════════════
; BINDER
; ═══════════════════════════════════════════════════════════════════════════════

{policy.binder}
= @endorsement.binder

; ═══════════════════════════════════════════════════════════════════════════════
; DOCUMENTS
; ═══════════════════════════════════════════════════════════════════════════════

{policy.documents[]}
= @docs.document

; ═══════════════════════════════════════════════════════════════════════════════
; ENDORSEMENTS (Policy Changes)
; ═══════════════════════════════════════════════════════════════════════════════

{policy.endorsements[]}
= @endorsement.endorsement

; ═══════════════════════════════════════════════════════════════════════════════
; CLAIMS
; ═══════════════════════════════════════════════════════════════════════════════

{policy.claims[]}
= @claim.claim

; ═══════════════════════════════════════════════════════════════════════════════
; LOSS HISTORY
; ═══════════════════════════════════════════════════════════════════════════════

{policy.loss_history[]}
= @pc.loss_history

; ═══════════════════════════════════════════════════════════════════════════════
; POLICY HISTORY
; ═══════════════════════════════════════════════════════════════════════════════

{policy.history[]}
= @endorsement.policy_history_entry

; ═══════════════════════════════════════════════════════════════════════════════
; NOTES
; ═══════════════════════════════════════════════════════════════════════════════

{policy.notes[]}
= @types.policy_note

; ═══════════════════════════════════════════════════════════════════════════════
; UNDERWRITING
; ═══════════════════════════════════════════════════════════════════════════════

{policy.underwriting}
= @types.underwriting_decision

; ═══════════════════════════════════════════════════════════════════════════════
; MARKETING & SOURCE
; ═══════════════════════════════════════════════════════════════════════════════

{policy.marketing}
= @types.marketing_source

; ═══════════════════════════════════════════════════════════════════════════════
; ADDITIONAL INTERESTS
; ═══════════════════════════════════════════════════════════════════════════════

{policy.additional_interests[]}
= @party.additional_insured

; ═══════════════════════════════════════════════════════════════════════════════
; EXTERNAL REFERENCES
; ═══════════════════════════════════════════════════════════════════════════════

{policy.external_references[]}
= @types.external_reference

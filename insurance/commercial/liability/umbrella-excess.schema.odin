; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Commercial Umbrella/Excess Liability Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Commercial umbrella and excess liability coverage providing additional limits
; above underlying CGL, commercial auto, and employers liability policies.
; Includes true umbrella with drop-down, excess follow-form, and bumbershoot.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../coverages/coverage.schema.odin" as cov
@import "../../coverages/lines/umbrella.schema.odin" as umbrella
@import "../../common/types.schema.odin" as com
@import "../business.schema.odin" as entity

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.liability.umbrella-excess"
version = "2.0.0"
title = "Commercial Umbrella/Excess Liability Schema"
description = "Comprehensive umbrella/excess coverage extending universal coverage primitive"

{$derivation}
source[0].authority = "U.S. Department of Labor"
source[0].citation = "Employee Benefits Security Administration"
source[0].url = "https://www.dol.gov/agencies/ebsa"

source[1].authority = "National Association of Insurance Commissioners (NAIC)"
source[1].citation = "Excess and Surplus Lines Model Laws"
source[1].url = "https://content.naic.org/"

source[2].authority = "State Insurance Departments"
source[2].citation = "Various state umbrella/excess liability regulations"
source[2].url = "https://content.naic.org/state-insurance-departments"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Umbrella/excess schema extending universal coverage primitive"

changelog[0].date = 2025-12-14
changelog[0].change = "Refactored to extend universal coverage primitive"
changelog[0].rationale = "Coverage-centric architecture - extend @umbrella_coverage from coverage/lines/umbrella.schema.odin"

changelog[1].date = 2025-12-13
changelog[1].change = "Initial umbrella/excess schema"
changelog[1].rationale = "Comprehensive excess liability coverage structure"

; ═══════════════════════════════════════════════════════════════════════════════
; Underlying Policy Schedule
; ═══════════════════════════════════════════════════════════════════════════════

{@underlying_policy}
; ───────────────────────────────────────────────────────────────────────────────
; Policy Identification
; ───────────────────────────────────────────────────────────────────────────────
type = (
    aircraft_liability,
    cgl,                                      ; Commercial General Liability
    commercial_auto,
    drone_liability,
    employers_liability,
    foreign_liability,
    other,
    pollution_liability,
    products_liability,
    professional_liability,
    watercraft_liability
)
carrier_name = :
policy_number = :
effective_date = date
expiration_date = date

id = :
sequence = ##
type_description = :if type = other
carrier_am_best_rating = :

; ───────────────────────────────────────────────────────────────────────────────
; Underlying Limits
; ───────────────────────────────────────────────────────────────────────────────
; CGL Limits
{.cgl}
each_occurrence = #$:if type = cgl
general_aggregate = #$:if type = cgl
products_completed_ops_aggregate = #$:if type = cgl
personal_advertising_injury = #$:if type = cgl
damage_to_rented_premises = #$:if type = cgl
medical_expense = #$:if type = cgl

{@underlying_policy}
; Auto Limits
{.auto}
combined_single_limit = #$:if type = commercial_auto
bodily_injury_per_person = #$:if type = commercial_auto
bodily_injury_per_accident = #$:if type = commercial_auto
property_damage = #$:if type = commercial_auto
uninsured_motorist = #$:if type = commercial_auto
hired_auto = #$:if type = commercial_auto
non_owned_auto = #$:if type = commercial_auto

{@underlying_policy}
; Employers Liability Limits
{.el}
bodily_injury_accident = #$:if type = employers_liability
bodily_injury_disease_employee = #$:if type = employers_liability
bodily_injury_disease_aggregate = #$:if type = employers_liability

{@underlying_policy}
; Professional Liability Limits
{.pl}
each_claim = #$:if type = professional_liability
aggregate = #$:if type = professional_liability

{@underlying_policy}
; Generic Limits (for other types)
{.other_limits}
each_occurrence = #$
aggregate = #$

{@underlying_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Form
; ───────────────────────────────────────────────────────────────────────────────
coverage_form = (claims_made, occurrence)
retroactive_date = date:if coverage_form = claims_made

; ───────────────────────────────────────────────────────────────────────────────
; Retained Limit (Self-Insured Retention applied by underlying)
; ───────────────────────────────────────────────────────────────────────────────
sir_applies = ?
sir_amount = #$:if sir_applies = true

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (cancelled, expired, in_force, pending)
maintained = ?                                ; Required to be maintained

; ═══════════════════════════════════════════════════════════════════════════════
; Commercial Umbrella/Excess Coverage (Extends @umbrella_coverage from umbrella line)
; ═══════════════════════════════════════════════════════════════════════════════
; Inherits from @umbrella_coverage which inherits from @coverage

{@umbrella_commercial_coverage}
= @umbrella_coverage                              ; Inherit from umbrella line extension
coverage_id = :

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Type
; ───────────────────────────────────────────────────────────────────────────────
type = (
    bumbershoot,                              ; Maritime umbrella
    excess_follow_form,                       ; Follow form only
    excess_specific,                          ; Scheduled coverage only
    true_umbrella                             ; Drop-down + broader coverage
)

; ───────────────────────────────────────────────────────────────────────────────
; Limits (commercial-specific extensions beyond @umbrella_coverage.umbrella_limits)
; ───────────────────────────────────────────────────────────────────────────────
each_occurrence = #$
aggregate = #$
aggregate_type = (annual, per_location, per_project, policy)

; Product-completed operations aggregate (if separate)
products_completed_ops_aggregate = #$
products_separate_aggregate = ?

; ───────────────────────────────────────────────────────────────────────────────
; Self-Insured Retention (commercial-specific extensions)
; ───────────────────────────────────────────────────────────────────────────────
; SIR applies when drop-down is triggered (no underlying coverage)
sir = #$
sir_applies_to = (all_claims, bodily_injury_only, drop_down_only, property_damage_only)
sir_erodes_limit = ?
sir_includes_defense = ?

; ───────────────────────────────────────────────────────────────────────────────
; Drop-Down Coverage (True Umbrella)
; ───────────────────────────────────────────────────────────────────────────────
{.drop_down}
available = ?:if type = true_umbrella
underlying_exhausted = ?:if available = true
underlying_bankrupt = ?:if available = true
gap_coverage = ?:if available = true
underlying_exclusion = ?:if available = true

{@umbrella_commercial_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Territory
; ───────────────────────────────────────────────────────────────────────────────
territory = (scheduled, us_territories_canada, worldwide)
scheduled_countries[] = :if territory = scheduled
excluded_countries[] = :

; ───────────────────────────────────────────────────────────────────────────────
; Defense
; ───────────────────────────────────────────────────────────────────────────────
{.defense}
duty_to_defend = ?
within_limits = ?                     ; Defense erodes limits
outside_limits = ?                    ; Defense doesn't erode
supplementary_payments = ?

{@umbrella_commercial_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Follow Form Provisions (Excess Policies)
; ───────────────────────────────────────────────────────────────────────────────
{.follow_form}
follows_cgl = ?:if type = excess_follow_form
follows_auto = ?:if type = excess_follow_form
follows_el = ?:if type = excess_follow_form
broader_than_underlying = ?:if type = excess_follow_form

{@umbrella_commercial_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Standard Exclusions
; ───────────────────────────────────────────────────────────────────────────────
{.exclusions}
asbestos = ?true
pollution = ?true
nuclear = ?true
aircraft = ?true
watercraft = ?
professional = ?
employment_practices = ?
cyber = ?
recall = ?
punitive_damages = ?

{@umbrella_commercial_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Umbrella Endorsements
; ═══════════════════════════════════════════════════════════════════════════════

{@umbrella_endorsement}
id = :
number = :
title = :
effective_date = date

; Endorsement Type
type = (coverage_exclusion, coverage_extension, cyber_coverage, employment_practices, other, pollution_buyback, professional_coverage, punitive_damages, sir_modification, territory_extension, underlying_schedule)

description = :
premium_impact = #$

; ═══════════════════════════════════════════════════════════════════════════════
; Umbrella/Excess Policy
; ═══════════════════════════════════════════════════════════════════════════════

{@umbrella_policy}
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
; Layer Position
; ───────────────────────────────────────────────────────────────────────────────
layer_position = (
    fifth_or_higher_excess,
    first_umbrella,                           ; Directly over primary
    fourth_excess,
    second_excess,
    third_excess
)
layer_number = ##

; Attachment Point
attachment_point = #$
immediately_underlying_limit = #$
immediately_underlying_carrier = :

; ───────────────────────────────────────────────────────────────────────────────
; Named Insured
; ───────────────────────────────────────────────────────────────────────────────
named_insured = @entity.business

; ───────────────────────────────────────────────────────────────────────────────
; Coverage
; ───────────────────────────────────────────────────────────────────────────────
coverage = @umbrella_commercial_coverage

; ───────────────────────────────────────────────────────────────────────────────
; Underlying Schedule
; ───────────────────────────────────────────────────────────────────────────────
underlying_policies[] = @underlying_policy

; Required Underlying Minimums
{.required_minimums}
cgl_occurrence = #$
cgl_aggregate = #$
auto_csl = #$
el_accident = #$

{@umbrella_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Endorsements
; ───────────────────────────────────────────────────────────────────────────────
endorsements[] = @umbrella_endorsement

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
base = #$
endorsements = #$
taxes_fees = #$
total = #$
minimum = #$

{@umbrella_policy}



; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Personal Auto - Texas State-Specific Policy Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Texas state-specific personal auto insurance schema covering mandatory liability
; minimums (30/60/25), PIP requirements, UM/UIM stacking rules, and TDI
; regulatory compliance.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../policy.schema.odin" as pol
@import "../../../common/auto/coverage.schema.odin" as cov

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.auto.states.tx"
version = "1.0.0"
title = "Texas Personal Auto Policy Schema"
description = "Texas-specific personal auto policy with state minimum limits"

{$derivation}
source[0].authority = "Texas Department of Insurance"
source[0].citation = "TX Transportation Code § 601.072 - Minimum Coverage Amounts"
source[0].url = "https://statutes.capitol.texas.gov/Docs/TN/htm/TN.601.htm#601.072"

source[1].authority = "Texas Department of Insurance"
source[1].citation = "TX Insurance Code § 1952.101 - UM/UIM Offer Requirements"
source[1].url = "https://statutes.capitol.texas.gov/docs/in/htm/in.1952.htm"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "TX minimum limits: 30/60/25. UM/UIM must be offered but can be rejected in writing."

changelog[0].date = 2025-12-15
changelog[0].change = "Initial TX state-specific policy schema with :override syntax"
changelog[0].rationale = "Complete TX policy inheriting base policy with coverage overrides"

; ═══════════════════════════════════════════════════════════════════════════════
; TX POLICY (Inherits full base policy)
; ═══════════════════════════════════════════════════════════════════════════════
; The TX policy inherits all fields from the base personal auto policy.
; Only the coverage sections are overridden with TX-specific limits.

{@tx_policy}
= @pol.policy :override

; Override state to TX only
state_province = :(2) "TX"                    ; Texas state code

; ═══════════════════════════════════════════════════════════════════════════════
; Texas Liability Coverage (Overrides base limits)
; ═══════════════════════════════════════════════════════════════════════════════
; TX minimum liability: 30/60/25
;   - $30,000 BI per person
;   - $60,000 BI per accident
;   - $25,000 PD per accident
;
; The :override modifier allows redefining fields from the base type with
; more restrictive constraints. Without :override, redefining a field would
; be a schema conflict error.

{@tx_liability}
= @cov.personal_auto_liability :override

; Override BI limits with TX minimums
{.bi}
per_accident = #$:(60000..)                   ; TX minimum $60K per accident
per_person = #$:(30000..)                     ; TX minimum $30K per person

{@tx_liability}

; Override PD limit with TX minimum
{.pd}
limit = #$:(25000..)                          ; TX minimum $25K property damage

{@tx_liability}

; ═══════════════════════════════════════════════════════════════════════════════
; Texas UM/UIM Coverage (Overrides base with offer requirements)
; ═══════════════════════════════════════════════════════════════════════════════
; Per TX Insurance Code § 1952.101:
; - UM/UIM must be offered in writing
; - Rejection must be signed
; - If not rejected, limits default to liability limits

{@tx_um}
= @cov.personal_auto_um :override

; TX requires documented offer
offered = ?                                   ; Must document offer (override: was optional)
rejection_signed = ?:if rejected = true       ; Signed rejection required

; Override UM limits with TX minimums (if not rejected)
{.um}
bi_per_accident = #$:(60000..):if selected = true  ; TX minimum $60K per accident
bi_per_person = #$:(30000..):if selected = true    ; TX minimum $30K per person

{@tx_um}

{.uim}
bi_per_accident = #$:(60000..):if selected = true  ; TX minimum $60K per accident
bi_per_person = #$:(30000..):if selected = true    ; TX minimum $30K per person

{@tx_um}

; ═══════════════════════════════════════════════════════════════════════════════
; Texas PIP Coverage (Optional in TX - no override needed)
; ═══════════════════════════════════════════════════════════════════════════════
; Texas is a tort state, not a no-fault state. PIP is optional.
; Base schema already allows optional PIP, so no override required.
; This type exists for documentation and potential future TX-specific PIP rules.

{@tx_pip}
= @cov.personal_auto_pip

; TX PIP is optional - no minimum required (inherits base as-is)
; Typical TX PIP options: $2,500, $5,000, $10,000

; ═══════════════════════════════════════════════════════════════════════════════
; TX Policy Coverage Overrides
; ═══════════════════════════════════════════════════════════════════════════════
; Override the coverage sections in the policy to use TX-specific types

{@tx_policy.coverage.liability}
= @tx_liability

{@tx_policy.coverage.um}
= @tx_um

{@tx_policy.coverage.pip}
= @tx_pip


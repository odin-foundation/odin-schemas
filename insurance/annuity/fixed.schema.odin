; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Fixed Annuity Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Traditional fixed annuities with carrier-declared interest rates and Multi-Year
; Guarantee Annuity (MYGA) products with CD-like guaranteed rates.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./contract.schema.odin" as annuity
@import "../common/life-annuity/types.schema.odin" as la

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.annuity.fixed"
version = "1.0.0"
title = "Fixed Annuity Schema"
description = "Traditional fixed annuities with declared interest rates"

{$derivation}
source[0].authority = "NAIC"
source[0].citation = "Suitability in Annuity Transactions Model Regulation"
source[0].url = "https://content.naic.org/sites/default/files/model-law-275.pdf"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-15
changelog[0].change = "Initial fixed annuity schema (separated from indexed)"
changelog[0].rationale = "Clean separation of fixed from indexed annuity products"

; ═══════════════════════════════════════════════════════════════════════════════
; Fixed Annuity (Traditional Declared Rate)
; ═══════════════════════════════════════════════════════════════════════════════
; Traditional fixed annuity with carrier-declared interest rate

{@fixed_annuity}
= @annuity.contract                           ; Inherit all base contract fields

; Set product type
product_type = !(fixed)

; ───────────────────────────────────────────────────────────────────────────────
; Interest Crediting
; ───────────────────────────────────────────────────────────────────────────────
{.interest}
crediting_method = !(compound, simple)        ; Interest crediting method
current_rate = #                              ; Current declared rate
guaranteed_minimum_rate = #:(0..10)           ; Guaranteed floor rate
initial_rate = #                              ; Initial/teaser rate
initial_rate_period_months = ##:(1..60)       ; Initial rate period
rate_effective = date                         ; Date current rate became effective
rate_history[] = @rate_period                 ; Historical rate periods
rate_renewal_date = date                      ; Next rate renewal date

{@fixed_annuity}

{@rate_period}
effective = !date                             ; Rate effective date
rate = !#                                     ; Interest rate

expiration = date                             ; Rate expiration date

; ───────────────────────────────────────────────────────────────────────────────
; Principal Protection
; ───────────────────────────────────────────────────────────────────────────────
{.guarantee}
mva_applies = ?                               ; Market value adjustment applies
principal_protected = ?true                   ; Principal guaranteed (always true for fixed)

{@fixed_annuity}

; ═══════════════════════════════════════════════════════════════════════════════
; Multi-Year Guarantee Annuity (MYGA)
; ═══════════════════════════════════════════════════════════════════════════════
; Fixed annuity with rate guaranteed for multiple years (CD-like)

{@myga}
= @fixed_annuity                              ; Inherit fixed annuity fields

; MYGA-specific fields
{.myga}
guarantee_period_years = !##:(2..10)          ; Rate guarantee period

automatic_renewal = ?                         ; Automatically renews
guarantee_expiration = date                   ; Date guarantee period ends
renewal_options = (extend, renew_at_current, surrender)  ; Options at guarantee end
renewal_period_years = ##                     ; Renewal period length

{@myga}


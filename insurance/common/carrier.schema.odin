; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Insurance Carrier Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Insurance carrier, underwriting company, and program definitions for carrier
; management across all insurance lines.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.common.carrier"
version = "1.0.0"
title = "Insurance Carrier Schema"
description = "Carrier and program definitions"

{$derivation}
methodology = "industry_practice"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-13
changelog[0].change = "Initial carrier schema"
changelog[0].rationale = "Standard carrier data structures"

; ═══════════════════════════════════════════════════════════════════════════════
; Insurance Carrier
; ═══════════════════════════════════════════════════════════════════════════════

{@carrier}
= @organization                              ; Inherits from organization

; ───────────────────────────────────────────────────────────────────────────────
; Carrier-Specific Identification
; ───────────────────────────────────────────────────────────────────────────────
id = :
code = :

; ───────────────────────────────────────────────────────────────────────────────
; Financial Strength Ratings
; ───────────────────────────────────────────────────────────────────────────────
{.am_best}
number = *:
rating = :                                    ; Financial Strength Rating
outlook = (developing, negative, positive, stable, under_review)

{@carrier}
fitch_rating = :
moodys_rating = :
sp_rating = :

; ───────────────────────────────────────────────────────────────────────────────
; Regulatory Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, inactive, runoff)
admitted = ?
domicile_state_province = :(2)
domicile_country = :(2..3) "US"

; ═══════════════════════════════════════════════════════════════════════════════
; Carrier Program/Product
; ═══════════════════════════════════════════════════════════════════════════════

{@program}
id = :
name = !:
code = :

; Parent carrier reference
carrier_ref = :

; Program details
line_of_business = !(auto, commercial, health, home, life, other)
product_type = :
state_province = :(2)
country = :(2..3) "US"

; Rate information
rate_effective_date = date
rate_revision = ##
rate_filing_number = :

; Commission
new_business_commission = #:(0..100)
renewal_commission = #:(0..100)

; Status
status = (active, inactive, pending)

; ═══════════════════════════════════════════════════════════════════════════════
; Prior Carrier Information
; ═══════════════════════════════════════════════════════════════════════════════

{@prior_carrier}
name = :
naic = :(5..6)
policy_number = :

; Coverage details
effective_date = date
expiration_date = date
{.limits}
bi_per_person = ##
bi_per_accident = ##
pd = ##

{@prior_carrier}

; Transfer information
months_covered = ##
continuous_coverage = ?
reason_for_lapse = (coverage_elsewhere, incarcerated, military, non_payment, none, other, unlicensed, vehicle_sold)
days_lapsed = ##

; Policy status
in_agency = ?
transfer_level = (non_standard, preferred, standard, unknown)

; ═══════════════════════════════════════════════════════════════════════════════
; Reason Not Bound
; ═══════════════════════════════════════════════════════════════════════════════

{@reason_not_bound}
carrier_ref = :
program_ref = :
rate_effective_date = date

reason = (
    bound_elsewhere,
    claims_history,
    coverage_not_offered,
    credit_issue,
    customer_declined,
    driver_excluded,
    incomplete_info,
    mvr_issue,
    other,
    premium_too_high,
    quote_expired,
    sr22_required,
    territory_excluded,
    underwriting_declined,
    vehicle_excluded
)
reason_detail = :
quote_date = date

; Premium details
quoted_premium = #$:(0..)
quoted_term = ##:(1..24)

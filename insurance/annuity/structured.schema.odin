; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Structured Annuity (RILA) Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Registered Index-Linked Annuities (RILA), also known as structured or buffer
; annuities. SEC-registered securities with index-linked returns and buffer/floor
; protection against downside, but without full principal guarantee.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./contract.schema.odin" as annuity
@import "../common/life-annuity/types.schema.odin" as la

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.annuity.structured"
version = "1.0.0"
title = "Structured Annuity (RILA) Schema"
description = "Registered Index-Linked Annuities with buffer/floor protection"

{$derivation}
source[0].authority = "SEC"
source[0].citation = "Securities Act Registration - Variable Annuities"
source[0].url = "https://www.sec.gov/rules/final/33-8098.htm"

source[1].authority = "FINRA"
source[1].citation = "Structured Products Guidance"
source[1].url = "https://www.finra.org/rules-guidance/notices/12-03"

source[2].authority = "LIMRA"
source[2].citation = "Structured Annuity Market Research"
source[2].url = "https://www.limra.com/en/research/research-abstracts/2023/u.s.-individual-annuities-sales-survey/"

methodology = "industry_practice"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-15
changelog[0].change = "Initial structured annuity (RILA) schema"
changelog[0].rationale = "Growing product category with unique characteristics"

; ═══════════════════════════════════════════════════════════════════════════════
; Structured Annuity (RILA)
; ═══════════════════════════════════════════════════════════════════════════════

{@structured_annuity}
= @annuity.contract                           ; Inherit base contract fields

; Set product type
product_type = (structured)

; ───────────────────────────────────────────────────────────────────────────────
; SEC Registration
; ───────────────────────────────────────────────────────────────────────────────
{.registration}
prospectus_date = date                        ; Prospectus effective date
prospectus_number = :                         ; SEC file number
sec_registered = ?true                        ; SEC-registered security

{@structured_annuity}

; ───────────────────────────────────────────────────────────────────────────────
; Downside Protection Type
; ───────────────────────────────────────────────────────────────────────────────
protection_type = (buffer, dual, floor)      ; Type of downside protection

; Buffer: Carrier absorbs first X% of loss (e.g., 10% buffer means carrier takes 0-10% loss)
; Floor: Client only loses up to floor (e.g., -10% floor means max loss is 10%)
; Dual: Combination of buffer and floor mechanisms

; ───────────────────────────────────────────────────────────────────────────────
; Segment/Term Structure
; ───────────────────────────────────────────────────────────────────────────────
{.segment_structure}
current_segment_length = ##:(1..6)            ; Current segment term (years)
days_remaining = ##:(0..2200)                 ; Days until segment matures
segment_effective = date                      ; Current segment start date
segment_expiration = date                     ; Current segment end date
segment_lengths_available[] = ##:(1..6)       ; Available segment lengths (years)

{@structured_annuity}

; ───────────────────────────────────────────────────────────────────────────────
; Investment Strategies
; ───────────────────────────────────────────────────────────────────────────────
strategies[] = @structured_strategy           ; Available/elected strategies
total_invested = #$:(0..)                     ; Total in indexed strategies

; ───────────────────────────────────────────────────────────────────────────────
; Fixed Account Option
; ───────────────────────────────────────────────────────────────────────────────
{.fixed_account}
available = ?                                 ; Fixed account option available
balance = #$:(0..)                            ; Fixed account balance
current_rate = #:(0..10)                      ; Current fixed rate
max_allocation_percent = #:(0..100)           ; Maximum allowed in fixed

{@structured_annuity}

; ═══════════════════════════════════════════════════════════════════════════════
; Structured Strategy
; ═══════════════════════════════════════════════════════════════════════════════
; Individual strategy within a structured annuity

{@structured_strategy}
; Required fields
index = :                                    ; Tracked index (S&P 500, etc.)
name = :                                     ; Strategy name
term_years = ##:(1..6)                       ; Strategy term in years

; ───────────────────────────────────────────────────────────────────────────────
; Protection Mechanism
; ───────────────────────────────────────────────────────────────────────────────
{.protection}
type = (buffer, dual, floor, none)           ; Protection type

; Buffer protection
buffer_percent = #:(0..30)                    ; Carrier absorbs first X% of loss
buffer_type = (per_segment, per_year, step_rate)  ; How buffer is applied

; Floor protection
floor_percent = #:(-50..0)                    ; Maximum client loss (e.g., -10%)

; Step-rate buffer (e.g., 10% in year 1, 15% in year 2)
step_buffer_schedule[] = @step_buffer         ; Step buffer by year

{@structured_strategy}

{@step_buffer}
year = ##:(1..6)                             ; Term year
buffer_percent = #:(0..30)                   ; Buffer for that year

; ───────────────────────────────────────────────────────────────────────────────
; Upside Limits
; ───────────────────────────────────────────────────────────────────────────────
{.upside}
cap_rate = #:(0..100)                         ; Maximum gain percentage
cap_type = (annual, none, segment, uncapped)  ; Type of cap
participation_rate = #:(0..300)               ; Participation in index gains
performance_trigger = #:(0..50)               ; Trigger rate (for trigger strategies)
spread = #:(0..10)                            ; Spread deducted from gains
upside_participation = (capped, participation, trigger, uncapped)  ; Upside mechanism

{@structured_strategy}

; ───────────────────────────────────────────────────────────────────────────────
; Allocation
; ───────────────────────────────────────────────────────────────────────────────
{.allocation}
amount = #$:(0..)                             ; Amount in this strategy
percent = #:(0..100)                          ; Percentage of contract

{@structured_strategy}

; ───────────────────────────────────────────────────────────────────────────────
; Performance Tracking
; ───────────────────────────────────────────────────────────────────────────────
{.performance}
at_risk_amount = #$:(0..)                     ; Amount at risk (beyond protection)
estimated_credit = #$:(0..)                   ; Estimated credit if ended today
index_change_percent = #:(-100..1000)         ; Index change to date
index_current_value = #                       ; Current index value
index_start_value = #                         ; Index at segment start
protected_amount = #$:(0..)                   ; Amount protected by buffer/floor

{@structured_strategy}

; ───────────────────────────────────────────────────────────────────────────────
; Historical Results
; ───────────────────────────────────────────────────────────────────────────────
history[] = @strategy_result                  ; Completed segment history

{@strategy_result}
segment_effective = date                     ; Segment start date
segment_expiration = date                    ; Segment end date

buffer_used = #:(0..100)                      ; Percent of buffer used
credited_return = #:(-100..1000)              ; Actual credited return
ending_value = #$:(0..)                       ; Ending value
floor_hit = ?                                 ; Floor was reached
index_return = #:(-100..1000)                 ; Raw index return
starting_value = #$:(0..)                     ; Starting value

; ═══════════════════════════════════════════════════════════════════════════════
; RILA Living Benefit Riders
; ═══════════════════════════════════════════════════════════════════════════════
; Some structured annuities offer living benefit riders

{@rila_glwb}
= @la.rider

; Benefit base (may be different from FIA due to market exposure)
{.benefit_base}
amount = #$:(0..)                             ; Current benefit base
calculation_method = (contract_value, greater_of, roll_up)  ; How benefit base calculated
roll_up_percent = #:(0..10)                   ; Roll-up rate (if applicable)

{@rila_glwb}

; Withdrawal rates (often lower than FIA due to risk profile)
{.withdrawal}
single_rate = #:(0..10)                       ; Single life rate
joint_rate = #:(0..10)                        ; Joint life rate
annual_max = #$:(0..)                         ; Maximum annual withdrawal

{@rila_glwb}

; ═══════════════════════════════════════════════════════════════════════════════
; Death Benefit Options
; ═══════════════════════════════════════════════════════════════════════════════
; Death benefits for structured annuities

{@rila_death_benefit}
type = (accumulated_value, greater_of, highest_anniversary, protected_value, return_of_premium)  ; DB type

; Protected value (unique to RILA - DB may include buffer protection)
{.protected}
includes_buffer_protection = ?                ; Buffer protection applies to DB
protected_amount = #$:(0..)                   ; Protected death benefit value

; Step-up options
{.step_up}
available = ?                                 ; Step-up available
frequency = (annual, quarterly, segment_end)  ; Step-up frequency
highest_value = #$:(0..)                      ; Highest stepped-up value

{@rila_death_benefit}

; ═══════════════════════════════════════════════════════════════════════════════
; Suitability (FINRA Requirements)
; ═══════════════════════════════════════════════════════════════════════════════
; Structured annuities are securities requiring FINRA suitability

{@suitability}
; Required fields
determination = :                            ; Suitability determination
determination_date = date                    ; Date of determination

; Risk acknowledgment (unique to structured)
{.risk_acknowledgment}
buffer_mechanics_explained = ?                ; Buffer/floor mechanics explained
principal_at_risk_acknowledged = ?            ; Client understands principal not guaranteed
worst_case_disclosed = ?                      ; Worst-case scenario disclosed

{@suitability}

; Customer profile
{.customer}
age = ##:(18..100)                            ; Age at purchase
investment_experience = (extensive, limited, moderate, none)  ; Experience level
investment_horizon_years = ##:(1..50)         ; Time horizon
net_worth = #$                                ; Net worth - can be negative
risk_tolerance = (aggressive, conservative, moderate)  ; Risk tolerance

{@suitability}

; Principal approval
{.approval}
approval_date = date                          ; Approval date
approved_by = :                               ; Principal name
firm_name = :                                 ; B/D firm name
rep_crd = :                                   ; Rep CRD number
rep_name = :                                  ; Rep name

{@suitability}


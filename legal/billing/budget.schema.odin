; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Legal Budget Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Legal matter budgets and forecasting for practice management. Covers matter
; budgets, phase-level budgets, alternative fee arrangements, and budget
; forecasting with variance tracking and approval workflows.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as legal
@import "../../common/types.schema.odin" as common

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.legal.billing.budget"
version = "1.0.0"
title = "Legal Budget Schema"
description = "Legal matter budgets and alternative fee arrangements"

{$derivation}
source[0].authority = "Association of Corporate Counsel"
source[0].citation = "ACC Value Challenge - Budgeting Best Practices"
source[0].url = "https://www.acc.com/resource-library"

source[1].authority = "Legal Electronic Data Exchange Standard"
source[1].citation = "LEDES Budget Tracking"
source[1].url = "https://ledes.org/"

source[2].authority = "Uniform Task-Based Management System"
source[2].citation = "UTBMS Phase Codes for Budgeting"
source[2].url = "https://ledes.org/utbms/"

methodology = "industry_practice"
proprietary_sources_consulted = ?false
notes = "Budget schema derived from ACC value practices and UTBMS phase structure"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial legal budget schema"
changelog[0].rationale = "Comprehensive budget tracking structure"

; ═══════════════════════════════════════════════════════════════════════════════
; LEGAL BUDGET
; ═══════════════════════════════════════════════════════════════════════════════
; Matter budget

{@legal_budget}
; Required fields first
budget_amount = !#$:(0..)                         ; Total budget amount
budget_type = !(alternative_fee, cap, estimate, fixed_fee, not_to_exceed, phase_based)
effective_date = !date                            ; Budget effective date

; Budget identification
budget_id = :                                     ; Unique budget ID
budget_name = :                                   ; Budget name/version

; ───────────────────────────────────────────────────────────────────────────────
; Matter Reference
; ───────────────────────────────────────────────────────────────────────────────
{.matter}
matter_ref = @legal_matter_ref                    ; Reference to matter
client_id = :                                     ; Client ID
matter_id = :                                     ; Matter ID
client_ref = @legal_client                        ; Reference to client

{@legal_budget}

; ───────────────────────────────────────────────────────────────────────────────
; Budget Period
; ───────────────────────────────────────────────────────────────────────────────
{.period}
start_date = date                                 ; Budget start date
end_date = date                                   ; Budget end date
annual_budget = ?                                 ; Annual budget
fiscal_year = ::if annual_budget = true           ; Fiscal year

{@legal_budget}

; ───────────────────────────────────────────────────────────────────────────────
; Budget Breakdown
; ───────────────────────────────────────────────────────────────────────────────
{.breakdown}
fees_budget = #$:(0..)                            ; Fees portion
expenses_budget = #$:(0..)                        ; Expenses portion
contingency = #$:(0..)                            ; Contingency amount
contingency_percentage = #:(0..100)               ; Contingency as percentage

{@legal_budget}

; Phase breakdown
phases[] = @budget_phase                          ; Phase-level budgets

{@legal_budget}

; ───────────────────────────────────────────────────────────────────────────────
; Actuals vs Budget
; ───────────────────────────────────────────────────────────────────────────────
{.actuals}
fees_incurred = #$:(0..)                          ; Fees incurred to date
expenses_incurred = #$:(0..)                      ; Expenses incurred
total_incurred = #$:(0..)                         ; Total incurred
fees_billed = #$:(0..)                            ; Fees billed
expenses_billed = #$:(0..)                        ; Expenses billed
total_billed = #$:(0..)                           ; Total billed
work_in_progress = #$:(0..)                       ; Unbilled WIP

{@legal_budget}

; Variance
{.actuals.variance}
budget_remaining = #$                             ; Remaining budget
variance_amount = #$                              ; Over/under budget
variance_percentage = #:(-100..1000)              ; Variance as percentage
over_budget = ?                                   ; Currently over budget
projected_at_completion = #$:(0..)                ; Projected final amount
projected_variance = #$                           ; Projected variance

{@legal_budget}

; ───────────────────────────────────────────────────────────────────────────────
; Assumptions
; ───────────────────────────────────────────────────────────────────────────────
{.assumptions}
scope_description = :                             ; Scope of work covered
key_assumptions[] = :                             ; Budget assumptions
exclusions[] = :                                  ; What's excluded
blended_rate = #$:(0..)                           ; Assumed blended rate
hours_estimated = #:(0..)                         ; Total hours estimated

{@legal_budget}

; Risk factors
{.assumptions.risk_factors[]}
risk_description = :                              ; Risk description
probability = (high, low, medium)                 ; Likelihood
impact = (high, low, medium)                      ; Budget impact
mitigation = :                                    ; Mitigation strategy
contingency_allocation = #$:(0..)                 ; Allocated contingency

{@legal_budget}

; ───────────────────────────────────────────────────────────────────────────────
; Approval
; ───────────────────────────────────────────────────────────────────────────────
{.approval}
client_approved = ?                               ; Client approved budget
approval_date = date:if client_approved = true    ; Approval date
approved_by = ::if client_approved = true         ; Who approved
approval_notes = ::if client_approved = true      ; Approval notes
fee_arrangement_id = :                            ; Related fee arrangement

{@legal_budget}

; ───────────────────────────────────────────────────────────────────────────────
; Revisions
; ───────────────────────────────────────────────────────────────────────────────
{.revisions[]}
revision_number = ##:(1..)                        ; Revision number
revision_date = date                              ; Revision date
previous_amount = #$:(0..)                        ; Previous budget
new_amount = #$:(0..)                             ; New budget
change_reason = :                                 ; Reason for change
approved_by = :                                   ; Who approved
approval_date = date                              ; Approval date

{@legal_budget}

; ───────────────────────────────────────────────────────────────────────────────
; Alerts
; ───────────────────────────────────────────────────────────────────────────────
{.alerts}
threshold_50_reached = ?                          ; 50% threshold reached
threshold_50_date = date:if threshold_50_reached = true
threshold_75_reached = ?                          ; 75% threshold reached
threshold_75_date = date:if threshold_75_reached = true
threshold_90_reached = ?                          ; 90% threshold reached
threshold_90_date = date:if threshold_90_reached = true
over_budget_alert = ?                             ; Over budget alert sent
over_budget_date = date:if over_budget_alert = true
custom_threshold = #:(0..100)                     ; Custom threshold percentage
custom_threshold_reached = ?                      ; Custom threshold reached

{@legal_budget}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, closed, draft, exceeded, on_hold, pending_approval, superseded)
status_date = date                                ; Date of status
close_date = date:if status = closed              ; Budget close date
final_amount = #$:(0..):if status = closed        ; Final amount spent

; ═══════════════════════════════════════════════════════════════════════════════
; BUDGET PHASE
; ═══════════════════════════════════════════════════════════════════════════════
; Phase-level budget (UTBMS-aligned)

{@budget_phase}
; Required fields first
phase_code = !:                                   ; UTBMS phase code
phase_name = !:                                   ; Phase name
phase_budget = !#$:(0..)                          ; Phase budget amount

; ───────────────────────────────────────────────────────────────────────────────
; Budget Breakdown
; ───────────────────────────────────────────────────────────────────────────────
{.breakdown}
fees_budget = #$:(0..)                            ; Fees for phase
expenses_budget = #$:(0..)                        ; Expenses for phase
hours_budget = #:(0..)                            ; Hours for phase

{@budget_phase}

; ───────────────────────────────────────────────────────────────────────────────
; Task Breakdown
; ───────────────────────────────────────────────────────────────────────────────
{.tasks[]}
task_code = :                                     ; UTBMS task code
task_name = :                                     ; Task description
task_budget = #$:(0..)                            ; Task budget
task_hours = #:(0..)                              ; Estimated hours
responsible_timekeeper = :                        ; Responsible person

{@budget_phase}

; ───────────────────────────────────────────────────────────────────────────────
; Actuals
; ───────────────────────────────────────────────────────────────────────────────
{.actuals}
fees_incurred = #$:(0..)                          ; Fees incurred
expenses_incurred = #$:(0..)                      ; Expenses incurred
total_incurred = #$:(0..)                         ; Total incurred
hours_incurred = #:(0..)                          ; Hours incurred
phase_complete_percentage = #:(0..100)            ; Percent complete

{@budget_phase}

; ───────────────────────────────────────────────────────────────────────────────
; Schedule
; ───────────────────────────────────────────────────────────────────────────────
{.schedule}
planned_start = date                              ; Planned start date
planned_end = date                                ; Planned end date
actual_start = date                               ; Actual start date
actual_end = date                                 ; Actual end date
on_schedule = ?                                   ; Phase on schedule

{@budget_phase}

; Status
status = (completed, in_progress, not_started, on_hold)

; ═══════════════════════════════════════════════════════════════════════════════
; ALTERNATIVE FEE ARRANGEMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Alternative fee arrangement terms

{@legal_afa}
; Required fields first
afa_type = !(blended_rate, cap, collar, contingency, fixed_fee, flat_fee_plus, holdback, hybrid, performance, portfolio, retainer, success_fee)
effective_date = !date                            ; AFA effective date

; AFA identification
afa_id = :                                        ; Unique AFA ID
afa_name = :                                      ; AFA name/description

; ───────────────────────────────────────────────────────────────────────────────
; Parties
; ───────────────────────────────────────────────────────────────────────────────
{.parties}
client_ref = @legal_client                        ; Client reference
firm_ref = @legal_firm                            ; Firm reference
matter_ref = @legal_matter_ref                    ; Matter reference (if matter-specific)
portfolio = ?                                     ; Portfolio arrangement
portfolio_matters[] = :                           ; Matters in portfolio

{@legal_afa}

; ───────────────────────────────────────────────────────────────────────────────
; Fixed Fee Terms
; ───────────────────────────────────────────────────────────────────────────────
{.fixed_fee}
fixed_amount = #$:(0..):if afa_type = fixed_fee | afa_type = flat_fee_plus
scope_of_work = ::if afa_type = fixed_fee         ; What's covered
payment_schedule = (milestone, monthly, on_completion, quarterly, upfront)
includes_expenses = ?:if afa_type = fixed_fee     ; Expenses included

{@legal_afa}

; Milestones
{.fixed_fee.milestones[]}
milestone_name = :                                ; Milestone name
milestone_amount = #$:(0..)                       ; Payment amount
milestone_percentage = #:(0..100)                 ; Percentage of total
due_date = date                                   ; Due date
completed = ?                                     ; Milestone completed
completion_date = date:if completed = true        ; Completion date
billed = ?:if completed = true                    ; Milestone billed

{@legal_afa}

; ───────────────────────────────────────────────────────────────────────────────
; Cap/Collar Terms
; ───────────────────────────────────────────────────────────────────────────────
{.cap_collar}
cap_amount = #$:(0..):if afa_type = cap | afa_type = collar
collar_floor = #$:(0..):if afa_type = collar      ; Collar floor amount
collar_ceiling = #$:(0..):if afa_type = collar    ; Collar ceiling
sharing_percentage = #:(0..100):if afa_type = collar ; Savings sharing

{@legal_afa}

; ───────────────────────────────────────────────────────────────────────────────
; Contingency Terms
; ───────────────────────────────────────────────────────────────────────────────
{.contingency}
contingency_percentage = #:(0..100):if afa_type = contingency | afa_type = hybrid
contingency_base = (gross_recovery, net_recovery):if afa_type = contingency
sliding_scale = ?:if afa_type = contingency       ; Sliding scale

{@legal_afa}

; Sliding scale tiers
{.contingency.tiers[]}
recovery_up_to = #$:(0..)                         ; Recovery up to amount
percentage = #:(0..100)                           ; Fee percentage

{@legal_afa}

; ───────────────────────────────────────────────────────────────────────────────
; Holdback Terms
; ───────────────────────────────────────────────────────────────────────────────
{.holdback}
holdback_percentage = #:(0..100):if afa_type = holdback | afa_type = performance
performance_criteria = ::if afa_type = holdback | afa_type = performance
evaluation_period = ::if afa_type = performance   ; When evaluated
bonus_percentage = #:(0..100):if afa_type = performance ; Bonus potential

{@legal_afa}

; ───────────────────────────────────────────────────────────────────────────────
; Blended Rate Terms
; ───────────────────────────────────────────────────────────────────────────────
{.blended_rate}
blended_rate = #$:(0..):if afa_type = blended_rate
rate_applies_to = (all_timekeepers, attorneys_only, partners_associates)
rate_effective = date:if afa_type = blended_rate
rate_expiration = date:if afa_type = blended_rate

{@legal_afa}

; ───────────────────────────────────────────────────────────────────────────────
; Expenses
; ───────────────────────────────────────────────────────────────────────────────
{.expenses}
expenses_included = ?                             ; Expenses in AFA
expense_cap = #$:(0..):if expenses_included = true
expense_types_covered[] = :                       ; Types covered
markup_allowed = ?:if expenses_included = false   ; Markup on expenses
markup_percentage = #:(0..100):if markup_allowed = true

{@legal_afa}

; ───────────────────────────────────────────────────────────────────────────────
; Term
; ───────────────────────────────────────────────────────────────────────────────
{.term}
start_date = date                                 ; AFA start date
end_date = date                                   ; AFA end date
renewable = ?                                     ; Renewable arrangement
renewal_terms = ::if renewable = true             ; Renewal terms
termination_notice_days = ##:(0..)                ; Notice for termination

{@legal_afa}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, completed, expired, negotiating, suspended, terminated)
status_date = date                                ; Date of status
termination_date = date:if status = terminated    ; Termination date
termination_reason = ::if status = terminated     ; Reason for termination


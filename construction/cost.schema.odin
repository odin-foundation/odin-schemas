; ===================================================================================
; ODIN Construction Cost Schema
; ===================================================================================
; Cost estimates, budgets, cost tracking, and earned value management.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.construction.cost"
version = "1.0.0"
title = "Construction Cost Schema"
description = "Cost estimation, budgeting, and cost control"

{$derivation}
source[0].authority = "AACE"
source[0].citation = "AACE Cost Engineering Standards"
source[0].url = "https://www.aacei.org/"

source[1].authority = "CSI"
source[1].citation = "MasterFormat Cost Coding"
source[1].url = "https://www.csiresources.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial construction cost schema"
changelog[0].rationale = "Cost structures for construction operations"

; ===================================================================================
; ESTIMATE
; ===================================================================================

{@estimate}
= @types.audit_info

estimate_id = :                                ; Estimate identifier
project_id = :                                 ; Project reference
estimate_name = :                              ; Estimate name
estimate_type = (budget, conceptual, control, definitive, order_of_magnitude)

version = :                                     ; Estimate version
estimate_date = date                           ; Estimate date
prepared_by = :                                 ; Prepared by
approved_by = :                                 ; Approved by
approved_date = date                            ; Approved date

; Basis
basis_date = date                               ; Basis date for pricing
location_factor = #:(0..)                       ; Location factor
escalation_rate = #:(0..100)                    ; Escalation rate percent

; Totals
direct_cost = #$:(0..)                          ; Direct cost
indirect_cost = #$:(0..)                        ; Indirect cost/overhead
contingency = #$:(0..)                          ; Contingency
escalation = #$:(0..)                           ; Escalation allowance
total_estimate = #$:(0..)                      ; Total estimate

; Percentages
contingency_percent = #:(0..100)                ; Contingency percent
overhead_percent = #:(0..100)                   ; Overhead percent
profit_percent = #:(0..100)                     ; Profit percent

; Metrics
cost_per_sqft = #$:(0..)                        ; Cost per square foot
gross_sqft = #:(0..)                            ; Gross square feet

status = (approved, draft, revised, superseded)

divisions[] = @estimate_division                ; CSI divisions
line_items[] = @estimate_line                   ; Estimate line items

; ===================================================================================
; ESTIMATE DIVISION
; ===================================================================================

{@estimate_division}
division_code = :                              ; CSI division code
division_name = :                              ; Division name
subtotal = #$:(0..)                             ; Division subtotal
percent_of_total = #:(0..100)                   ; Percent of total

; ===================================================================================
; ESTIMATE LINE
; ===================================================================================

{@estimate_line}
line_id = :                                    ; Line identifier
cost_code = :                                  ; Cost code
description = :                                ; Description
division = :                                    ; CSI division

; Quantity
quantity = #:(0..)                              ; Quantity
unit = :                                        ; Unit of measure

; Unit costs
material_unit_cost = #$:(0..)                   ; Material unit cost
labor_unit_cost = #$:(0..)                      ; Labor unit cost
equipment_unit_cost = #$:(0..)                  ; Equipment unit cost
subcontract_unit_cost = #$:(0..)                ; Subcontract unit cost
total_unit_cost = #$:(0..)                      ; Total unit cost

; Extended costs
material_cost = #$:(0..)                        ; Material extended
labor_cost = #$:(0..)                           ; Labor extended
equipment_cost = #$:(0..)                       ; Equipment extended
subcontract_cost = #$:(0..)                     ; Subcontract extended
total_cost = #$:(0..)                           ; Total extended

; Labor
labor_hours = #:(0..)                           ; Labor hours
labor_rate = #$:(0..)                           ; Labor rate

; Production
production_rate = #:(0..)                       ; Production rate
crew_size = #:(0..)                             ; Crew size
duration_days = #:(0..)                         ; Duration in days

notes = :                                       ; Notes

; ===================================================================================
; BUDGET
; ===================================================================================

{@budget}
= @types.audit_info

budget_id = :                                  ; Budget identifier
project_id = :                                 ; Project reference
budget_name = :                                ; Budget name
budget_type = (control, forecast, original, revised)

version = :                                     ; Budget version
effective_date = date                          ; Effective date
created_by = :                                  ; Created by
approved_by = :                                 ; Approved by

; Totals
original_budget = #$:(0..)                      ; Original budget
budget_transfers = #$                           ; Transfers in/out
current_budget = #$:(0..)                       ; Current budget
contingency_original = #$:(0..)                 ; Original contingency
contingency_remaining = #$:(0..)                ; Remaining contingency

; Status
committed_cost = #$:(0..)                       ; Committed cost
actual_cost = #$:(0..)                          ; Actual cost to date
forecast_at_completion = #$:(0..)               ; Forecast at completion
variance = #$                                   ; Budget variance

status = (active, closed, draft)

line_items[] = @budget_line                     ; Budget line items

; ===================================================================================
; BUDGET LINE
; ===================================================================================

{@budget_line}
line_id = :                                    ; Line identifier
cost_code = :                                  ; Cost code
description = :                                ; Description
responsible_party = :                           ; Responsible contractor

; Budget
original_budget = #$:(0..)                      ; Original budget
transfers = #$                                  ; Transfers in/out
current_budget = #$:(0..)                       ; Current budget

; Costs
committed_cost = #$:(0..)                       ; Committed (contracts, POs)
actual_cost = #$:(0..)                          ; Actual cost incurred
pending_changes = #$:(0..)                      ; Pending change orders

; Forecast
estimate_to_complete = #$:(0..)                 ; Estimate to complete
forecast_at_completion = #$:(0..)               ; Forecast at completion

; Variance
variance = #$                                   ; Variance (budget - forecast)
variance_percent = #:(-100..100)                ; Variance percent

; ===================================================================================
; COST CODE
; ===================================================================================

{@cost_code}
cost_code = :                                  ; Cost code
cost_code_name = :                             ; Cost code name
parent_code = :                                 ; Parent cost code
level = ##:(1..)                                ; Hierarchy level

csi_division = :                                ; CSI division
csi_section = :                                 ; CSI section

cost_type = :(equipment, labor, material, other, subcontract)
active = ? "true"                               ; Active flag

; ===================================================================================
; COST TRANSACTION
; ===================================================================================

{@cost_transaction}
= @types.audit_info

transaction_id = :                             ; Transaction identifier
project_id = :                                 ; Project reference
cost_code = :                                  ; Cost code

transaction_type = (actual, accrual, budget, commitment, forecast, invoice)
transaction_date = date                        ; Transaction date
posting_date = date                             ; Posting date

description = :                                 ; Description
vendor_id = :                                   ; Vendor
contract_id = :                                 ; Contract reference
invoice_number = :                              ; Invoice number
po_number = :                                   ; PO number

amount = #$                                    ; Amount (+ or -)
quantity = #                                    ; Quantity
unit = :                                        ; Unit of measure
unit_cost = #$:(0..)                            ; Unit cost

period = :                                      ; Accounting period
fiscal_year = ##:(2000..)                       ; Fiscal year

created_by = :                                  ; Created by
approved_by = :                                 ; Approved by
status = (approved, pending, posted, rejected)

; ===================================================================================
; COST REPORT
; ===================================================================================

{@cost_report}
report_id = :                                  ; Report identifier
project_id = :                                 ; Project reference
report_date = date                             ; Report date
report_type = (executive, monthly, quarterly, weekly)

prepared_by = :                                 ; Prepared by
approved_by = :                                 ; Approved by

; Summary
original_budget = #$:(0..)                      ; Original budget
current_budget = #$:(0..)                       ; Current budget
committed = #$:(0..)                            ; Committed
actual_to_date = #$:(0..)                       ; Actual to date
forecast_at_completion = #$:(0..)               ; Forecast at completion
variance = #$                                   ; Variance

percent_complete = #:(0..100)                   ; Percent complete
percent_spent = #:(0..100)                      ; Percent spent

; Earned Value (optional)
bcws = #$:(0..)                                 ; Budgeted cost of work scheduled
bcwp = #$:(0..)                                 ; Budgeted cost of work performed
acwp = #$:(0..)                                 ; Actual cost of work performed
spi = #:(0..)                                   ; Schedule performance index
cpi = #:(0..)                                   ; Cost performance index
eac = #$:(0..)                                  ; Estimate at completion

; Contingency
contingency_original = #$:(0..)                 ; Original contingency
contingency_used = #$:(0..)                     ; Contingency used
contingency_remaining = #$:(0..)                ; Contingency remaining

narrative = :                                   ; Report narrative
concerns[] = :                                  ; Cost concerns

status = (approved, draft, issued)


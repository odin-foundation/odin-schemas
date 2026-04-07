; ===================================================================================
; ODIN Construction Contract Schema
; ===================================================================================
; Construction contracts, change orders, amendments, and contract management.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.construction.contract"
version = "1.0.0"
title = "Construction Contract Schema"
description = "Contracts, change orders, and amendments"

{$derivation}
source[0].authority = "AIA"
source[0].citation = "AIA A101/A201 Contract Documents"
source[0].url = "https://aiacontracts.com/"

source[1].authority = "ConsensusDocs"
source[1].citation = "ConsensusDocs 200 Standard Agreement"
source[1].url = "https://www.consensusdocs.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial construction contract schema"
changelog[0].rationale = "Contract structures for construction operations"

; ===================================================================================
; CONTRACT
; ===================================================================================

{@contract}
= @types.audit_info

contract_id = :                                ; Contract identifier
contract_number = :                            ; Contract number
project_id = :                                 ; Project reference

contract_type = (cost_plus_fee, cost_plus_gmp, design_build, lump_sum, time_and_materials, unit_price)
contract_form = :(aia_a101, aia_a102, aia_a103, consensusdocs_200, custom)

; Parties
owner_id = :                                   ; Owner
owner_name = :                                  ; Owner name
contractor_id = :                              ; Contractor
contractor_name = :                             ; Contractor name

; Scope
scope_of_work = :                               ; Scope description
contract_documents[] = :                        ; List of contract documents

; Financial
original_contract_sum = #$:(0..)               ; Original contract sum
approved_changes = #$                           ; Approved changes (+ or -)
current_contract_sum = #$:(0..)                 ; Current contract sum
retainage_percent = #:(0..100) "10"             ; Retainage percentage

; Schedule
execution_date = date                           ; Contract execution date
notice_to_proceed = date                        ; Notice to proceed
contract_period = @types.effective_period       ; Contract period (effective/expiration)
substantial_completion = date                   ; Substantial completion date
final_completion = date                         ; Final completion date
contract_time = ##:(0..)                        ; Contract time in days

; Insurance
general_liability = #$:(0..)                    ; General liability required
auto_liability = #$:(0..)                       ; Auto liability required
workers_comp = ?                                ; Workers comp required
umbrella = #$:(0..)                             ; Umbrella required

; Bonds
performance_bond = ?                            ; Performance bond required
payment_bond = ?                                ; Payment bond required
bond_amount = #$:(0..)                          ; Bond amount

status = (active, closed, executed, pending, terminated)

change_orders[] = @change_order                 ; Change orders
amendments[] = @amendment                       ; Contract amendments

; ===================================================================================
; CHANGE ORDER
; ===================================================================================

{@change_order}
= @types.audit_info

change_order_id = :                            ; Change order identifier
contract_id = :                                ; Contract reference
change_order_number = ##:(1..)                 ; Change order number

title = :                                      ; Change order title
description = :                                 ; Description of change
reason = (code_compliance, design_change, field_condition, owner_request, rfi_response, unforeseen, value_engineering)

; Amounts
cost_change = #$                               ; Cost change (+ or -)
time_change = ##                                ; Time change in days (+ or -)

; Breakdown
labor_cost = #$                                 ; Labor cost
material_cost = #$                              ; Material cost
equipment_cost = #$                             ; Equipment cost
subcontract_cost = #$                           ; Subcontract cost
overhead_markup = #$                            ; Overhead/markup
bond_cost = #$                                  ; Bond cost

; Status
status = (approved, pending, rejected, submitted, void)
submitted_date = date                           ; Submitted date
approved_date = date                            ; Approved date
approved_by = :                                 ; Approved by

; Supporting docs
proposal_request = :                            ; PR reference
construction_change_directive = :               ; CCD reference
rfi_reference = :                               ; RFI reference

items[] = @change_order_item                    ; Line items

; ===================================================================================
; CHANGE ORDER ITEM
; ===================================================================================

{@change_order_item}
item_number = ##:(1..)                         ; Item number
description = :                                ; Description
cost = #$                                      ; Cost (+ or -)
time_impact = ##                                ; Time impact in days

; ===================================================================================
; AMENDMENT
; ===================================================================================

{@amendment}
amendment_id = :                               ; Amendment identifier
contract_id = :                                ; Contract reference
amendment_number = ##:(1..)                    ; Amendment number

title = :                                      ; Amendment title
description = :                                 ; Description
effective_date = date                          ; Effective date

; What changed
sections_modified[] = :                         ; Contract sections modified
financial_impact = #$                           ; Financial impact (if any)
time_impact = ##                                ; Time impact in days (if any)

status = (executed, pending, void)
executed_date = date                            ; Execution date

; ===================================================================================
; SUBCONTRACT
; ===================================================================================

{@subcontract}
= @types.audit_info

subcontract_id = :                             ; Subcontract identifier
subcontract_number = :                         ; Subcontract number
prime_contract_id = :                          ; Prime contract reference
project_id = :                                 ; Project reference

; Parties
contractor_id = :                              ; Prime contractor
subcontractor_id = :                           ; Subcontractor
subcontractor_name = :                          ; Subcontractor name

; Scope
trade = :                                      ; Trade
scope_of_work = :                               ; Scope description
specification_sections[] = :                    ; Spec sections
exclusions = :                                  ; Exclusions

; Financial
original_amount = #$:(0..)                     ; Original subcontract amount
approved_changes = #$                           ; Approved changes
current_amount = #$:(0..)                       ; Current amount
retainage_percent = #:(0..100)                  ; Retainage percentage

; Schedule
execution_date = date                           ; Execution date
start_date = date                               ; Start date
completion_date = date                          ; Completion date

; Insurance & bonds
insurance_verified = ?                          ; Insurance verified
bond_required = ?                               ; Bond required
bond_amount = #$:(0..)                          ; Bond amount

status = (active, closed, executed, pending, terminated)

; ===================================================================================
; PAY APPLICATION
; ===================================================================================

{@pay_application}
= @types.audit_info

pay_app_id = :                                 ; Pay application identifier
contract_id = :                                ; Contract reference
application_number = ##:(1..)                  ; Application number
period_to = date                               ; Period ending date

; Current application
scheduled_value = #$:(0..)                      ; Scheduled value (SOV)
work_completed_previous = #$:(0..)              ; Work completed previous
work_completed_current = #$:(0..)               ; Work completed this period
materials_stored = #$:(0..)                     ; Materials presently stored
total_completed_stored = #$:(0..)               ; Total completed and stored
retainage = #$:(0..)                            ; Retainage
total_earned_less_retainage = #$:(0..)          ; Total earned less retainage
less_previous_payments = #$:(0..)               ; Less previous payments
current_payment_due = #$:(0..)                 ; Current payment due

percent_complete = #:(0..100)                   ; Percent complete

; Status
status = (approved, draft, paid, rejected, submitted)
submitted_date = date                           ; Submitted date
approved_date = date                            ; Approved date
approved_by = :                                 ; Approved by
paid_date = date                                ; Paid date
check_number = :                                ; Check/payment number

lines[] = @pay_application_line                 ; Schedule of values lines

; ===================================================================================
; PAY APPLICATION LINE
; ===================================================================================

{@pay_application_line}
line_number = ##:(1..)                         ; Line number
description = :                                ; Description of work
scheduled_value = #$:(0..)                      ; Scheduled value

work_previous = #$:(0..)                        ; Work completed previous
work_current = #$:(0..)                         ; Work completed this period
materials_stored = #$:(0..)                     ; Materials stored
total_completed = #$:(0..)                      ; Total completed
percent_complete = #:(0..100)                   ; Percent complete
balance_to_finish = #$:(0..)                    ; Balance to finish
retainage = #$:(0..)                            ; Retainage


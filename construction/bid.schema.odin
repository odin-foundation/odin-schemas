; ===================================================================================
; ODIN Construction Bid Schema
; ===================================================================================
; Bid packages, bid items, bid bonds, and construction procurement.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.construction.bid"
version = "1.0.0"
title = "Construction Bid Schema"
description = "Bids, bid packages, and procurement"

{$derivation}
source[0].authority = "AIA"
source[0].citation = "AIA A701 Instructions to Bidders"
source[0].url = "https://aiacontracts.com/"

source[1].authority = "ConsensusDocs"
source[1].citation = "ConsensusDocs 200"
source[1].url = "https://www.consensusdocs.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial construction bid schema"
changelog[0].rationale = "Bid structures for construction procurement"

; ===================================================================================
; BID PACKAGE
; ===================================================================================

{@bid_package}
= @types.audit_info

bid_package_id = :                             ; Bid package identifier
project_id = :                                 ; Project reference
package_number = :                             ; Package number
package_name = :                               ; Package name

bid_type = (invitation, negotiated, open, prequalified)
delivery_method = (cm_at_risk, cm_agency, design_bid_build, design_build)

; Scope
scope_description = :                           ; Scope description
divisions[] = :                                 ; CSI divisions included
trades[] = :                                    ; Trades included

; Documents
specification_sections[] = :                    ; Specification sections
drawing_list[] = :                              ; Drawings included

; Schedule
issue_date = date                               ; Bid issue date
pre_bid_meeting = date                          ; Pre-bid meeting
rfi_deadline = date                             ; RFI deadline
bid_due_date = date                            ; Bid due date
bid_due_time = time                             ; Bid due time
award_date = date                               ; Expected award date

; Requirements
bid_bond_required = ?                           ; Bid bond required
bid_bond_percent = #:(0..100)                   ; Bid bond percentage
prequalification_required = ?                   ; Prequalification required
insurance_requirements = :                      ; Insurance requirements

status = (awarded, cancelled, closed, draft, issued, under_review)

bids[] = @bid                                   ; Received bids

; Estimate
engineers_estimate = *#$:(0..)                  ; Engineer's estimate (confidential)
budget = #$:(0..)                               ; Budget

; ===================================================================================
; BID
; ===================================================================================

{@bid}
= @types.audit_info

bid_id = :                                     ; Bid identifier
bid_package_id = :                             ; Bid package reference
bidder_id = :                                  ; Bidder/contractor

; Bidder info
company_name = :                               ; Company name
contact_name = :                                ; Contact name
email = @types.email                            ; Email
phone = @types.phone                            ; Phone

submitted_date = timestamp                      ; Submission date/time
status = (accepted, disqualified, pending, rejected, submitted, withdrawn)

; Amounts
base_bid = #$:(0..)                            ; Base bid amount
alternates_total = #$                           ; Alternates total
total_bid = #$:(0..)                            ; Total bid amount

; Alternates
alternates[] = @bid_alternate                   ; Bid alternates

; Unit prices
unit_prices[] = @bid_unit_price                 ; Unit prices

; Allowances
allowances_accepted = ?                         ; Allowances accepted as stated

; Bond
bid_bond_submitted = ?                          ; Bid bond submitted
bid_bond_amount = #$:(0..)                      ; Bid bond amount
surety_company = :                              ; Surety company

; Evaluation
responsive = ?                                  ; Responsive bid
responsible = ?                                 ; Responsible bidder
ranking = ##:(1..)                              ; Bid ranking
notes = :                                       ; Evaluation notes

; ===================================================================================
; BID ALTERNATE
; ===================================================================================

{@bid_alternate}
alternate_id = :                               ; Alternate identifier
alternate_number = :                           ; Alternate number
description = :                                ; Alternate description
amount = #$                                    ; Amount (add or deduct)
accepted = ?                                    ; Alternate accepted

; ===================================================================================
; BID UNIT PRICE
; ===================================================================================

{@bid_unit_price}
item_id = :                                    ; Item identifier
description = :                                ; Item description
unit = :                                       ; Unit of measure
quantity = #:(0..)                              ; Estimated quantity
unit_price = #$:(0..)                          ; Unit price
extended = #$:(0..)                             ; Extended amount

; ===================================================================================
; BID TABULATION
; ===================================================================================

{@bid_tabulation}
tabulation_id = :                              ; Tabulation identifier
bid_package_id = :                             ; Bid package reference
created = timestamp                        ; Created date
created_by = :                                  ; Created by

; Summary
bidders_invited = ##:(0..)                      ; Bidders invited
bids_received = ##:(0..)                        ; Bids received
responsive_bids = ##:(0..)                      ; Responsive bids

low_bid = #$:(0..)                              ; Low bid amount
low_bidder = :                                  ; Low bidder
high_bid = #$:(0..)                             ; High bid amount
average_bid = #$:(0..)                          ; Average bid
bid_spread = #$:(0..)                           ; Spread (high - low)

recommendation = :                              ; Award recommendation
status = (approved, draft, pending_approval, rejected)

; ===================================================================================
; PREQUALIFICATION
; ===================================================================================

{@prequalification}
= @types.audit_info

prequal_id = :                                 ; Prequalification identifier
contractor_id = :                              ; Contractor
project_id = :                                  ; Project (if project-specific)

submitted_date = date                           ; Submission date
expiration_date = date                          ; Expiration date
status = (approved, expired, pending, rejected)

; Company info
company_name = :                               ; Company name
years_in_business = ##:(0..)                    ; Years in business
annual_revenue = *#$:(0..)                      ; Annual revenue (confidential)

; Capacity
bonding_capacity = *#$:(0..)                    ; Bonding capacity (confidential)
single_project_limit = *#$:(0..)                ; Single project limit (confidential)
current_backlog = *#$:(0..)                     ; Current backlog (confidential)

; Experience
similar_projects = ##:(0..)                     ; Similar projects completed
largest_project = #$:(0..)                      ; Largest project value
references[] = :                                ; Reference contacts

; Safety
emr = #:(0..)                                   ; Experience modification rate
osha_recordable = #:(0..)                       ; OSHA recordable rate
safety_program = ?                              ; Written safety program

approved_trades[] = :                           ; Approved trades
approved_project_size = #$:(0..)                ; Approved project size


; ===================================================================================
; ODIN Construction Lien Schema
; ===================================================================================
; Lien waivers, mechanic's liens, preliminary notices, and payment protection.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.construction.lien"
version = "1.0.0"
title = "Construction Lien Schema"
description = "Lien waivers, mechanics liens, and notices"

{$derivation}
source[0].authority = "AIA"
source[0].citation = "AIA G706 Lien Waivers"
source[0].url = "https://aiacontracts.com/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial construction lien schema"
changelog[0].rationale = "Lien structures for construction operations"

; ===================================================================================
; LIEN WAIVER
; ===================================================================================

{@lien_waiver}
= @types.audit_info

waiver_id = :                                  ; Waiver identifier
project_id = :                                 ; Project reference

waiver_type = (conditional_final, conditional_progress, unconditional_final, unconditional_progress)

; Claimant
claimant_id = :                                ; Claimant (contractor/supplier)
claimant_name = :                              ; Claimant name
claimant_address = @types.address               ; Claimant address

; Property
property_address = @types.address               ; Property address
property_owner = :                              ; Property owner

; Payment
through_date = date                            ; Through date
amount = #$:(0..)                              ; Amount of waiver
check_number = :                                ; Payment check number
payment_date = date                             ; Payment date

; For conditional waivers
exceptions = :                                  ; Exceptions/disputed work
disputed_amount = #$:(0..)                      ; Disputed amount

; Execution
executed_date = date                           ; Execution date
signed_by = :                                  ; Signed by
signer_title = :                                ; Signer title
notarized = ?                                   ; Notarized
notary_date = date                              ; Notary date

status = (draft, executed, received, requested, void)

; ===================================================================================
; MECHANICS LIEN
; ===================================================================================

{@mechanics_lien}
= @types.audit_info

lien_id = :                                    ; Lien identifier
project_id = :                                 ; Project reference
lien_number = :                                 ; Lien number

; Claimant
claimant_id = :                                ; Claimant
claimant_name = :                              ; Claimant name
claimant_type = (contractor, laborer, material_supplier, prime_contractor, subcontractor)
claimant_address = @types.address               ; Claimant address

; Property
property_address = @types.address              ; Property address
legal_description = :                           ; Legal description
parcel_number = :                               ; Parcel/APN number
property_owner = :                             ; Property owner
owner_address = @types.address                  ; Owner address

; Contract
hired_by = :                                    ; Hired by (if sub/supplier)
prime_contractor = :                            ; Prime contractor
contract_amount = #$:(0..)                      ; Contract amount
work_description = :                            ; Description of work/materials

; Dates
first_work_date = date                         ; First furnishing date
last_work_date = date                          ; Last furnishing date
completion_date = date                          ; Project completion date
notice_date = date                              ; Prelim notice date
recording_date = date                           ; Recording date
expiration_date = date                          ; Lien expiration date

; Amounts
contract_value = #$:(0..)                       ; Contract value
amount_paid = #$:(0..)                          ; Amount paid
amount_owed = #$:(0..)                         ; Amount claimed
interest = #$:(0..)                             ; Interest claimed
total_claim = #$:(0..)                          ; Total claim

; Recording
county = :                                      ; Recording county
instrument_number = :                           ; Instrument number
book = :                                        ; Book number
page = :                                        ; Page number

; Status
status = (contested, filed, foreclosed, paid, pending, released, void)
release_date = date                             ; Release date
release_instrument = :                          ; Release instrument number

foreclosure_filed = ?                           ; Foreclosure filed
foreclosure_date = date                         ; Foreclosure date
case_number = :                                 ; Court case number

; ===================================================================================
; PRELIMINARY NOTICE
; ===================================================================================

{@preliminary_notice}
= @types.audit_info

notice_id = :                                  ; Notice identifier
project_id = :                                 ; Project reference

; Sender
sender_id = :                                  ; Sender
sender_name = :                                ; Sender name
sender_type = (contractor, laborer, material_supplier, subcontractor)
sender_address = @types.address                 ; Sender address

; Recipients
property_owner = :                              ; Property owner
owner_address = @types.address                  ; Owner address
prime_contractor = :                            ; Prime contractor
contractor_address = @types.address             ; Contractor address
lender = :                                      ; Construction lender
lender_address = @types.address                 ; Lender address

; Property
property_address = @types.address              ; Property address
legal_description = :                           ; Legal description

; Work
work_description = :                            ; Description of work/materials
first_work_date = date                         ; First furnishing date
estimated_value = #$:(0..)                      ; Estimated value

; Notice
notice_date = date                             ; Notice date
sent_date = date                                ; Sent date
sent_via = (certified_mail, hand, overnight, regular_mail)
tracking_number = :                             ; Tracking number

deadline = date                                 ; Notice deadline
timely = ?                                      ; Sent timely

status = (acknowledged, draft, sent)

; ===================================================================================
; STOP NOTICE
; ===================================================================================

{@stop_notice}
stop_notice_id = :                             ; Stop notice identifier
project_id = :                                 ; Project reference

stop_notice_type = (bonded, unbonded)

; Claimant
claimant_id = :                                ; Claimant
claimant_name = :                              ; Claimant name
claimant_address = @types.address               ; Claimant address

; Property
property_owner = :                              ; Property owner
prime_contractor = :                            ; Prime contractor
construction_lender = :                         ; Construction lender

; Claim
claim_amount = #$:(0..)                        ; Claim amount
work_description = :                            ; Work/materials description
first_work_date = date                          ; First furnishing date
last_work_date = date                           ; Last furnishing date

; Notice
notice_date = date                             ; Notice date
served_on[] = :                                 ; Served on parties
service_method = (certified_mail, hand, overnight)

; Bond (if bonded)
bond_amount = #$:(0..)                          ; Release bond amount
surety_company = :                              ; Surety company
bond_number = :                                 ; Bond number

status = (active, bonded_off, released, void)
release_date = date                             ; Release date

; ===================================================================================
; NOTICE OF COMPLETION
; ===================================================================================

{@notice_of_completion}
notice_id = :                                  ; Notice identifier
project_id = :                                 ; Project reference

; Property
property_address = @types.address              ; Property address
legal_description = :                           ; Legal description
parcel_number = :                               ; Parcel number

; Owner
owner_name = :                                 ; Owner name
owner_address = @types.address                  ; Owner address

; Contractor
contractor_name = :                             ; Contractor name
contractor_address = @types.address             ; Contractor address

; Dates
completion_date = date                         ; Completion date
acceptance_date = date                          ; Owner acceptance date
recording_date = date                           ; Recording date

; Recording
county = :                                      ; Recording county
instrument_number = :                           ; Instrument number
book = :                                        ; Book number
page = :                                        ; Page number

; Lien deadlines (set by recording)
prime_lien_deadline = date                      ; Prime contractor lien deadline
sub_lien_deadline = date                        ; Sub/supplier lien deadline

status = (draft, recorded)

; ===================================================================================
; LIEN RELEASE TRACKING
; ===================================================================================

{@lien_release_tracking}
tracking_id = :                                ; Tracking identifier
project_id = :                                 ; Project reference
pay_application = :                             ; Pay application reference
period_to = date                                ; Period ending

; Summary
total_parties = ##:(0..)                        ; Total parties tracked
waivers_required = ##:(0..)                     ; Waivers required
waivers_received = ##:(0..)                     ; Waivers received
waivers_outstanding = ##:(0..)                  ; Waivers outstanding

total_waived = #$:(0..)                         ; Total waived amount
amount_outstanding = #$:(0..)                   ; Outstanding amount

status = (complete, incomplete, pending)

parties[] = @lien_release_party                 ; Party waivers

; ===================================================================================
; LIEN RELEASE PARTY
; ===================================================================================

{@lien_release_party}
party_id = :                                   ; Party identifier
party_name = :                                 ; Party name
party_type = :(contractor, material_supplier, subcontractor)
tier = ##:(1..)                                 ; Tier (1=prime, 2=sub, etc.)

contract_amount = #$:(0..)                      ; Contract amount
billed_to_date = #$:(0..)                       ; Billed to date
paid_to_date = #$:(0..)                         ; Paid to date

; Current period
current_waiver_type = :(conditional_progress, unconditional_progress)
current_waiver_amount = #$:(0..)                ; Current waiver amount
current_waiver_received = ?                     ; Waiver received
current_waiver_date = date                      ; Waiver date

; Prior
prior_waiver_type = :(conditional_final, unconditional_progress)
prior_waiver_through = date                     ; Prior waiver through date
prior_waiver_received = ?                       ; Prior waiver received

prelim_notice_received = ?                      ; Prelim notice on file
prelim_notice_date = date                       ; Prelim notice date

notes = :                                       ; Notes

